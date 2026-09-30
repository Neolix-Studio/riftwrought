#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation H1 smoke checks: atomic Experience Mote
# collection (decision D-271).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation H1 adds ONE pure-logic script under `scripts/experience/` — a
# temporary in-memory Experience Mote that carries one base-experience amount and
# whether it has been collected, and delivers that exact amount into the accepted
# run-level coordinator (Foundation G4) exactly once, marking itself collected only
# after the run accepts. No scene, no resource, no asset, no InputMap action, no
# entrypoint change, nothing written to disk, and NOTHING THAT RUNS CREATES OR
# COLLECTS A MOTE.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT STANDS BESIDE. Two accepted suites moved one
# for one because the mote exists — E1, whose directory pin gained the mote, and
# G4, whose reader scan gained one per-file, per-class grant — and each is rerun by
# its own runner at its own unchanged count.
#
# What this script proves:
#
#   1. the new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log;
#   3. from outside the engine: the mote holds two fields, performs no
#      arithmetic and carries no floating-point literal but zero; it reads no
#      storage, randomness or ambient state and names no content; of every
#      project class — READ from the `class_name` lines under `scripts/` — it
#      names itself and the run-level coordinator and nothing else; nothing that
#      runs names it or calls a collection — Foundation H3's collection attempt,
#      which nothing runs, is granted the mote's class and the collection call
#      (D-275), Foundation H4's drop, which nothing creates, the mote's class
#      alone (D-277), and Foundation H6's enemy mote emission, which nothing
#      creates, the mote's class alone (D-281); and the verification names no file
#      under `tests/` but its own;
#   4. `scripts/experience/` holds exactly E1's two scripts, the mote, H6's
#      emission, H7's Graveblade mote binding (D-283), H8's Experience Mote runtime
#      (D-286), and their uid files;
#   5. the files this work could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_experience_mote_smoke.sh

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
		printf '\nRIFT EXPERIENCE MOTE SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_experience_mote_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=193

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=11

MOTE="scripts/experience/rift_experience_mote.gd"
THIS_VERIFICATION="tests/rift_experience_mote_verification.gd"

PARSED_SCRIPTS=(
	"$MOTE"
	"$THIS_VERIFICATION"
)

MOTE_CLASS="RiftExperienceMote"

# The only project classes the mote may name, sorted: itself, and the run it is
# collected into.
EXPECTED_NAMED="RiftExperienceMote RiftRunLevelCoordinator"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# canonical combat record, the run-level coordinator and its record (whose award
# contract the mote calls), the one-level lifecycle and its receipt, the track and
# its reading (which own Experience Gain's application and share the mote's
# directory), the build, the ledger, the offer, the stat vocabulary and the card
# records, G1 and G2, the two first-MVP character scripts that own the project's
# OTHER experience concept, and the project owner's composed zone.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_seeds/rift_level_offer_seed_derivation.gd"
	"scripts/character/experience_table.gd"
	"scripts/character/character_state.gd"
	"scenes/first_mvp/zone_composer_practice.tscn"
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

printf 'Riftwrought — Roguelite Foundation H1: atomic Experience Mote collection (D-271)\n'
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
verify_log="/tmp/riftwrought_rift_experience_mote_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless Experience Mote verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT EXPERIENCE MOTE VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_experience_mote_replay)"
scratch_replay="$replay"
sed "s/RIFT EXPERIENCE MOTE VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT EXPERIENCE MOTE VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT EXPERIENCE MOTE VERIFICATION" "$replay")"
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
25, 0.1, 7.5, 1.7e+308, 5e-324: each forwarded exactly, each collected only after the run accepted it
2 motes of 25.0: 50.0 delivered, each once; both repeats refused and nothing moved
the second collection refused ('this Experience Mote has already been collected; it delivers nothing again'); the whole run and the mote unmoved; a second run refused too and received 0.0
zero, negative, not a number, positive infinity, negative infinity: each refused twice with its own problem and never collected; the run unmoved
order: collected before invalid before a missing run; a valid mote refused for a missing run was then collected
1.7e+308 on a run holding Experience Gain: refused, quoting the run's own evaluation; uncollected; refused again; then collected once into an unmodified run
50.0 kept before the card; a mote of 50.0 collected while holding it came to 105.0, equal to the run's own path and not 100.0
refused twice while the offer stood ('an offer is open; it must be resolved before further experience is recorded'); the offer and run unchanged; after the choice the same mote paid 25.0 once
4 x 25.0 = 100.0 at level 1 with no offer; the open and the choice were each asked for; level 2 with 0.0
the completed level-1 lifecycle stayed at 0.0; the mote landed in the level-2 successor, which now holds 25.0
2 fields; 6 methods pinned, none defaulting an argument; 10 collection steps in order; 4 gates each return on the next line; literals ["0.0"]
0 percentage operations, requirements, seeds, offers, positions, distances or pickup queries; names only RiftExperienceMote, RiftRunLevelCoordinator
0 unauthorized project files create or collect a mote (3 readers granted by file and token); scripts/experience/ holds 6 scripts
31 refusals and 33 collections were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Two fields, no arithmetic, two named classes, and nothing that runs creates a mote"
shape=0

# Comment lines are stripped: the file says in plain English what it does not
# do, and a scan that cannot tell the promise from the breach is worthless —
# Gate 1C's lesson, kept.
mote_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$MOTE")"
fields="$(grep -E '^var ' <<< "$mote_code" | awk '{print $2}' | tr -d ':' | tr '\n' ' ')"
if [[ "$fields" != "_base_experience _collected " ]]; then
	fail "the mote declares the fields: ${fields:-none}"
	shape=$((shape + 1))
fi
if ! grep -qxE 'var _base_experience: float' <<< "$mote_code"; then
	fail "the base-experience field is not declared bare — a default amount may have arrived"
	shape=$((shape + 1))
fi
if [[ "$(grep -cF '_collected = true' <<< "$mote_code" | tr -d ' ')" != "1" ]]; then
	fail "the mote does not mark itself collected in exactly one place"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '.award_experience(_base_experience)' <<< "$mote_code" | wc -l | tr -d ' ')" != "1" ]]; then
	fail "the mote does not hand its exact stored amount to the run exactly once"
	shape=$((shape + 1))
fi
if grep -qE '[*/+&|^]|<<|>>' <<< "$mote_code"; then
	fail "the mote performs arithmetic or a bit operation"
	shape=$((shape + 1))
fi
if sed 's/->//g' <<< "$mote_code" | grep -qF -- '-'; then
	fail "the mote subtracts or negates something"
	shape=$((shape + 1))
fi
strays="$(grep -oE '[0-9]+\.[0-9]+' <<< "$mote_code" | grep -vx '0.0' | sort -u | tr '\n' ' ')"
if [[ -n "${strays// /}" ]]; then
	fail "the mote carries the floating-point literal(s) ${strays}"
	shape=$((shape + 1))
fi
if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|Vector2|Vector3|global_position|distance_to' "$PROJECT_DIR/$MOTE"; then
	fail "the mote reads storage, randomness, ambient engine state or space"
	shape=$((shape + 1))
fi
if grep -qE 'quick_strike|card_[a-z]+|display_name|base_weight|magnitude|Catalogue|EXPERIENCE_GAIN|experience_gain|requirement_for|offer_root_seed_for|open_current_offer|choose\(|next_level_coordinator|with_state\(' "$PROJECT_DIR/$MOTE"; then
	fail "the mote names content, the stat vocabulary or another step of the run"
	shape=$((shape + 1))
fi
if [[ "$shape" == "0" ]]; then
	pass "two fields, the amount declared bare; collected in one place; the exact amount handed over once; no arithmetic, float, ambient read, spatial read or content"
fi

# EVERY PROJECT CLASS, READ FROM ITS OWN `class_name` LINE — never typed here.
declare -a project_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && project_classes+=("$name"); done \
	< <(grep -rhoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/scripts" "$PROJECT_DIR/addons" 2>/dev/null \
		| awk '{print $2}' | sort -u)
named=""
for name in "${project_classes[@]}"; do
	grep -qF "$name" "$PROJECT_DIR/$MOTE" && named="$named$name "
done
if [[ "${#project_classes[@]}" -lt 100 ]]; then
	fail "only ${#project_classes[@]} project classes were read — the class scan may be inert"
elif [[ "$named" == "$EXPECTED_NAMED " ]]; then
	pass "of ${#project_classes[@]} project classes the mote names exactly: $EXPECTED_NAMED"
else
	fail "the mote names: ${named:-nothing}"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# NOTHING THAT RUNS CREATES OR COLLECTS A MOTE.
unwired=0
for token in "$MOTE_CLASS" "rift_experience_mote" "collect_into("; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$MOTE"|*/"$MOTE".uid) continue ;;
		esac
		# D-275: Foundation H3's collection attempt asks a supplied mote to collect
		# itself, only when it is within range, so it is granted the mote's class and
		# the collection call — never the mote's file name. Recorded in the
		# verification's per-file, per-token reader table. Nothing runs the attempt.
		if [[ "$token" != "rift_experience_mote" ]]; then
			case "$hit" in
				*/scripts/pickups/rift_mote_collection_attempt.gd) continue ;;
			esac
		fi
		# D-277: Foundation H4's drop makes and holds one mote but never asks it to
		# collect itself, so it is granted the mote's class alone — never the
		# collection call and never the mote's file name. Nothing creates a drop.
		# D-281: Foundation H6's enemy mote emission makes a temporary mote only to
		# ask its own problem, and never asks a mote to collect itself — granted the
		# mote's class alone, too. Nothing creates an emission.
		if [[ "$token" == "$MOTE_CLASS" ]]; then
			case "$hit" in
				*/scripts/pickups/rift_mote_drop.gd) continue ;;
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
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the mote or calls a collection but H3's granted caller, H4's granted holder and H6's granted validator, which nothing runs"
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
step "4. scripts/experience/ holds exactly E1's two scripts, the mote, H6's emission, H7's binding and H8's runtime"
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_experience_track.gd|rift_experience_track.gd.uid| \
		rift_experience_reading.gd|rift_experience_reading.gd.uid| \
		rift_experience_mote.gd|rift_experience_mote.gd.uid| \
		rift_enemy_mote_emission.gd|rift_enemy_mote_emission.gd.uid| \
		rift_graveblade_mote_binding.gd|rift_graveblade_mote_binding.gd.uid| \
		rift_mote_runtime.gd|rift_mote_runtime.gd.uid)
			continue ;;
	esac
	fail "scripts/experience/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/experience" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/experience" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "6" ]]; then
	fail "scripts/experience/ holds $gd_count scripts, not 6"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/experience/ holds exactly its six scripts and their six uid files"
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
	printf 'RIFT EXPERIENCE MOTE SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation H1 — Atomic Experience Mote Collection — is\n'
	printf '  DELIVERED under D-271 and ACCEPTED and CLOSED at the atomic Experience\n'
	printf '  Mote collection mechanism level under D-272.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT EXPERIENCE MOTE SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
