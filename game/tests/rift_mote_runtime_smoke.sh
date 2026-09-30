#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation H8 smoke checks: the run-owned Experience-Mote
# runtime — one run, one mote field of the same exact seed, and every Graveblade
# binding that connected, behind two operations (decision D-286).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation H8 adds ONE script under `scripts/experience/` — a runtime that, made
# for one exact signed run seed, makes that run (G4) and a mote field of the same
# seed (H5), registers one live Graveblade at a time by making, connecting and
# strongly keeping its one binding (H7), and sweeps its own field into its own run
# only when a caller asks. No scene, no resource, no asset, no InputMap action, no
# entrypoint change, nothing written to disk, no edit to the Graveblade, its scene
# or its records, and NOTHING THAT RUNS CREATES A RUNTIME.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT COMPOSES BY ITSELF. Six accepted suites moved
# one for one because the runtime names their classes or shares their directory —
# G4, whose reader table granted the runtime the coordinator alone; H5, whose
# reader table granted it the field's class, the result's class and the sweep call;
# H7, whose blanket unwired scan became a per-file, per-token table granting it the
# binding's class and the connecting call, and whose directory pin gained one
# script; and H6, H1 and E1, whose directory pins gained one script — and each is
# rerun once by its own runner at its own unchanged count.
#
# What this script proves:
#
#   1. the new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log — and a run that
#      hangs is killed and FAILS rather than waiting forever, because this suite
#      awaits frames and a script error inside a coroutine leaves the engine
#      running with nothing left to call `quit()`;
#   3. from outside the engine: the runtime declares exactly its three bare
#      fields — no run seed of its own — and twenty-three functions (sixteen, plus
#      Foundation I1's six one-line offer delegations, D-291, and Roguelite I3's
#      one-line build reading, D-295), no constant,
#      static state or signal; it carries no literal and performs no arithmetic;
#      it refuses no Graveblade, then an incoherent run and field, then a
#      Graveblade already registered, before the one binding is made, and keeps
#      that binding only on the line after the binding's own refusal returns; its
#      sweep is one line handing its field its run; it walks its collection only
#      through its keys and its values; it names no enemy record, balance value,
#      room, round, encounter, storage or ambient state and no guarded token it
#      is not granted; of every project class — READ from the `class_name` lines
#      under `scripts/` and `addons/` — it names exactly its eleven (six, plus the
#      four types I1's delegations must name, plus the build type Roguelite I3's
#      one-line reading hands on, D-295); nothing that runs
#      names it but the D-288 experience collection review, granted its class
#      alone; and the verification names no file under `tests/` but its own;
#   4. `scripts/experience/` holds exactly E1's two scripts, H1's mote, H6's
#      emission, H7's binding, H8's runtime, and their uid files;
#   5. the files this work could conceivably have disturbed — the project owner's
#      loading teaser, the Graveblade actor, its scene, its rig, its target area
#      and both of its records, the damage event, the attack coordinator, every
#      accepted mechanism H8 composes or stands beside, the project's OTHER
#      experience records, the three roguelite runtimes and `CLAUDE.md` — are
#      BYTE-IDENTICAL ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_mote_runtime_smoke.sh

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
		printf '\nRIFT MOTE RUNTIME SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_mote_runtime_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=120

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=16

# Seconds the verification may take before it is killed and counted as a failure.
# A green run takes a few seconds; this exists only so a hang cannot pass or stall.
VERIFICATION_TIMEOUT=300

RUNTIME="scripts/experience/rift_mote_runtime.gd"
THIS_VERIFICATION="tests/rift_mote_runtime_verification.gd"

PARSED_SCRIPTS=(
	"$RUNTIME"
	"$THIS_VERIFICATION"
)

# The only project classes the runtime may name, in C-locale sort order: the actor
# it registers, the binding it makes for that actor, the field it owns, itself, the
# value a sweep answers with, and the run it owns — and, since Foundation I1
# (D-291), the three record types a caller hands its offer opening and the run's
# own level-up record its lane choice hands back — and, since Roguelite I3 (D-295),
# the type of the copied build its one build reading hands on.
EXPECTED_NAMED="PassiveCardDefinition PrototypeGraveblade RiftGravebladeMoteBinding RiftMoteField RiftMoteRuntime RiftMoteSweepResult RiftRunBuild RiftRunLevelCoordinator RiftRunLevelUpResult SkillTagProfile SupportDefinition"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# project owner's composed zone and loading teaser with its import settings
# (pre-existing work this foundation does not touch), the Graveblade this
# foundation registers and must not edit — its actor script, scene, rig, target
# area, record script and both records — the damage event and attack coordinator
# its death order depends on, every accepted mechanism the runtime composes or
# stands beside, the level-requirement curve it must not restate, the project's
# OTHER experience records, the three roguelite runtimes this foundation
# deliberately does not wire into, the canonical opening that awards character
# experience, and `CLAUDE.md`.
PRESERVED_FILES=(
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	"scripts/actors/prototype_graveblade.gd"
	"scenes/actors/prototype_graveblade.tscn"
	"scenes/actors/graveblade_rig.tscn"
	"scripts/actors/graveblade_target_area.gd"
	"scripts/combat/graveblade_data.gd"
	"data/prototype_zero/graveblade.tres"
	"data/roguelite/graveblade_elite.tres"
	"scripts/combat/damage_event.gd"
	"scripts/combat/attack_coordinator.gd"
	"scripts/experience/rift_graveblade_mote_binding.gd"
	"scripts/experience/rift_enemy_mote_emission.gd"
	"scripts/experience/rift_experience_mote.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/pickups/rift_mote_field.gd"
	"scripts/pickups/rift_mote_sweep_result.gd"
	"scripts/pickups/rift_mote_drop.gd"
	"scripts/pickups/rift_mote_collection_attempt.gd"
	"scripts/pickups/rift_mote_collection_result.gd"
	"scripts/pickups/rift_mote_pickup_query.gd"
	"scripts/pickups/rift_mote_pickup_reading.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/character/experience_table.gd"
	"scripts/character/character_state.gd"
	"scripts/prototype_zero/lab_progress.gd"
	"scripts/prototype_zero/lab_progression_data.gd"
	"data/prototype_zero/progression.tres"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
	"scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
	"../CLAUDE.md"
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

# Real nodes are in this suite, so engine errors that are not script errors — a
# node read outside the tree, a freed key walked directly — are refused too. The
# verification's own FAIL lines are printed separately.
assert_no_engine_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "^ERROR:|^WARNING:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no engine ERROR or WARNING line"
	else
		fail "$what produced $found engine ERROR or WARNING line(s)"
		grep -A2 -E "^ERROR:|^WARNING:" "$logfile" | head -20 | sed 's/^/        /'
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

# The first line number at which a fixed string occurs in the runtime.
line_of() {
	grep -nF -- "$1" "$PROJECT_DIR/$RUNTIME" | head -1 | cut -d: -f1
}

printf 'Riftwrought — Roguelite Foundation H8: run-owned Experience-Mote runtime (D-286)\n'
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
verify_log="/tmp/riftwrought_rift_mote_runtime_verify.log"
perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" \
	"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless runtime verification" "$verify_log"
assert_no_engine_error "the headless runtime verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT MOTE RUNTIME VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_mote_runtime_replay)"
scratch_replay="$replay"
sed "s/RIFT MOTE RUNTIME VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT MOTE RUNTIME VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT MOTE RUNTIME VERIFICATION" "$replay")"
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
# measured line that begins with a dash is read by grep as an option bundle. Three
# lines are pinned only up to a number that varies — two grow with the project, and
# the physics frames that pass during three awaited frames depend on the machine.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the constructor takes 1 argument and no method defaults one; a new runtime reads seed=99 level=1 experience=0.0 offer=false bindings=0 drops=0 collected=0 uncollected=0 problem=''
construction left a Graveblade already in the tree at 1 died connection (the harness's own observer), 0 of them a binding's; the runtime has 0 incoming connections and declares 0 signals
register_graveblade(): '' — seed=99 level=1 experience=0.0 offer=false bindings=0 drops=0 collected=0 uncollected=0 problem='' became seed=99 level=1 experience=0.0 offer=false bindings=1 drops=0 collected=0 uncollected=0 problem=''; 1 died connection added, exactly 1 of them a binding's
a runtime returned from the helper that registered with it: 1 binding connection survived the return; the death (300 -> 200 -> 100 -> 0) was heard and made 1 drop
a runtime registered ('') and let go: the Graveblade's died went back to 1 connection, 0 of them a binding's; its death (300 -> 200 -> 100 -> 0) reached nothing
2 accepted hits of 100.0: Life 300 -> 200 -> 100, took_damage 2, died 0 — 0 drops, death heard: false, experience 0.0
the lethal hit (300 -> 200 -> 100 -> 0) at (6.0, 0.0, -6.0): seed=99 level=1 experience=0.0 offer=false bindings=1 drops=1 collected=0 uncollected=1 problem='' | registered=true heard=true answer='' alive=false life=0 died=1 connections=2 binding_connections=1
6 of 6 sweeps found it out of range and paid nothing — from where it entered, from the attacker, and one float32 spacing beyond 2.5 m on each of four sides; exactly 2.5 m away the sweep collected [0] and paid 25.0 — as a twin given the drop directly answered
a later sweep skipped 1, attempted 0 and paid nothing: seed=99 level=1 experience=25.0 offer=false bindings=1 drops=1 collected=1 uncollected=0 problem=''
3 of 3 second registrations — 25.0, 40.0 and not a number — answered 'this Graveblade is already registered with this run's Experience Mote runtime; it registers nothing again' and moved nothing: seed=99 level=1 experience=0.0 offer=false bindings=1 drops=0 collected=0 uncollected=0 problem='' | registered=true heard=false answer='' alive=true life=300 died=0 connections=2 binding_connections=1
the death (300 -> 200 -> 100 -> 0) fired died 1 time(s) into exactly 1 binding connection, made 1 drop, and one sweep paid 25.0 — the first registration's amount, not 40.0 or the sum
two Graveblades named Graveblade/Graveblade and Graveblade/Graveblade under two rooms: both registered, 2 bindings
killed second-registered first (300 -> 200 -> 100 -> 0) then first-registered (300 -> 200 -> 100 -> 0): from where the second fell the sweep collected [0] paying 12.5; from where the first fell, [1] paying 25.0 — death order, as a twin answered
after both deaths: 2 bindings still owned; heard true / true; answers '' / ''
a Graveblade of the same name never registered here, and no Graveblade at all: registered false, heard false, answer 'that Graveblade is not registered with this run's Experience Mote runtime, so it has no emission answer'; its death (300 -> 200 -> 100 -> 0) left 2 drops
7 of 7 refusals word for word — no Graveblade, no Graveblade before an unusable amount, and zero, negative, not a number, positive infinity, negative infinity with H1's own reason as a fresh binding answers it — each keeping nothing: seed=99 level=1 experience=0.0 offer=false bindings=0 drops=0 collected=0 uncollected=0 problem='' | registered=false heard=false answer='that Graveblade is not registered with this run's Experience Mote runtime, so it has no emission answer' alive=true life=300 died=0 connections=1 binding_connections=0
no Graveblade: 'a run's Experience Mote runtime registers a Graveblade, and none was given'
the same living Graveblade then registered with 25.0 (''), 1 binding connection; its death (300 -> 200 -> 100 -> 0) made 1 drop and one sweep paid 25.0
a Graveblade killed with nothing registered (300 -> 200 -> 100 -> 0): 2 of 2 registrations answered 'the bound Graveblade is already dead; its Experience Mote binding must be connected before death' — the same words a fresh binding answers — and kept nothing: seed=99 level=1 experience=0.0 offer=false bindings=0 drops=0 collected=0 uncollected=0 problem='' | registered=false heard=false answer='that Graveblade is not registered with this run's Experience Mote runtime, so it has no emission answer' alive=false life=0 died=1 connections=1 binding_connections=0
reset_encounter() restored it; it then registered (''), died again at (104.0, 0.0, 0.0) (300 -> 200 -> 100 -> 0, died 2) and one sweep paid 25.0
seeds 0 and 4294967296 agree in their low 32 bits (0) and read back whole; each registered its own Graveblade and not the other's
drops (seed 0 / seed 4294967296) after the first death 1 / 0, after the second 1 / 1; the first sweep paid 25.0 / 0.0; each run was paid only by its own sweep
seeds 0, 4294967296, -9223372036854775808, -1, 4294967295, 9223372036854775807: 6 of 6 read back whole, registered, dropped on death and paid 25.0 to their own run
4 Graveblades registered at 25.0 each and killed: seed=99 level=1 experience=0.0 offer=false bindings=4 drops=4 collected=0 uncollected=4 problem=''
one sweep collected [0, 1, 2, 3]: experience 100.0 = G1's Level 1 requirement 100.0; level 1, offer false
a further sweep skipped 4 and moved nothing; a twin run awarded the same 4 x 25.0 directly holds 100.0 and opened an offer when explicitly asked ('') — the runtime, never asked, is still level 1 with no offer
problem() read '' before the free and 'a Graveblade registered with this run's Experience Mote runtime no longer exists' after it; 1 binding kept — none pruned — and the run unchanged: seed=99 level=1 experience=0.0 offer=false
a new Graveblade then registered (''), died (300 -> 200 -> 100 -> 0), and one sweep paid 25.0; problem() still reads the freed entry; an untouched runtime reads ''
seed=99 level=1 experience=0.0 offer=false bindings=1 drops=1 collected=0 uncollected=1 problem='' held unchanged while process and physics frames passed; then one explicit sweep collected [0] and paid 25.0
3 fields declared exactly (_run, _field, _bindings), the collection typed 'PrototypeGraveblade;RiftGravebladeMoteBinding'; written only as _run = RiftRunLevelCoordinator.new(for_run_seed) | _field = RiftMoteField.new(for_run_seed) | _bindings[enemy] = binding
25 methods pinned, none defaulting an argument, only _init, sweep_at, choose_level_up_lane and run_build declaring an object answer; every whole body pinned line for line; the duplicate gate two lines before the one binding is made, and the binding kept on the line after its refusal returns
asked: _run { "run_seed": 4, "open_current_offer": 1, "offer_root_seed": 1, "offer_lanes": 1, "offer_identity_for": 1, "offer_support_content_kind": 1, "offer_support_fallback_category": 1, "frozen_requirement": 1, "choose": 1, "run_build": 1, "level": 1, "experience": 1, "is_offer_active": 1 }; _field { "sweep_collection": 1, "drop_count": 1, "collected_count": 1, "uncollected_count": 1, "problem": 1, "run_seed": 2 }; _bindings { "has": 2, "size": 1, "keys": 1, "values": 1 }; 3 objects made, 1 connection asked for, 1 sweep; the collection walked only through its keys and its values; 0 open, choose, reset, prune, transfer, save or timer members but I1's six delegations, and no offer member but is_offer_active, I1's five and Roguelite I10's two
0 hits for 74 balance, record, enemy-content, storage and other-foundation tokens and 49 behaviour tokens; no arithmetic; % only in its 1 formatted sentence; literals []
the runtime names only PassiveCardDefinition, PrototypeGraveblade, RiftGravebladeMoteBinding, RiftMoteField, RiftMoteRuntime, RiftMoteSweepResult, RiftRunBuild, RiftRunLevelCoordinator, RiftRunLevelUpResult, SkillTagProfile, SupportDefinition; its name overlaps 0 other class names;
0 unauthorized project files create a runtime (1 reader(s) granted by file and token); scripts/experience/ holds 6 scripts; 31 actions;
12 refusals were asserted, 24 Graveblade deaths were driven and 25 sweeps were made across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Three bare fields, no arithmetic, every refusal before the one binding, the one-line sweep, eleven named classes, and nothing that runs creates a runtime"
shape=0

code="$(bare_code "$PROJECT_DIR/$RUNTIME")"

fields="$(grep -E '^var ' <<< "$code" | tr '\n' '|')"
if [[ "$fields" != 'var _run: RiftRunLevelCoordinator|var _field: RiftMoteField|var _bindings: Dictionary[PrototypeGraveblade, RiftGravebladeMoteBinding] = {}|' ]]; then
	fail "the runtime declares the fields: ${fields:-none} — not exactly three, bare, in order"
	shape=$((shape + 1))
fi
if grep -qE '^(static|const|signal|enum|@)' <<< "$code"; then
	fail "the runtime declares static state, a constant, a signal, an enum or an annotation"
	shape=$((shape + 1))
fi
if ! grep -qxF 'extends RefCounted' <<< "$code"; then
	fail "the runtime is not a RefCounted"
	shape=$((shape + 1))
fi
functions="$(grep -oE '^func [a-z_]+\(' <<< "$code" | tr '\n' ' ')"
if [[ "$functions" != "func _init( func register_graveblade( func sweep_at( func open_level_up_offer( func offer_root_seed( func offer_lanes( func offer_identity_for( func offer_support_content_kind( func offer_support_fallback_category( func frozen_offer_requirement( func choose_level_up_lane( func run_build( func run_seed( func level( func experience( func is_offer_active( func binding_count( func drop_count( func collected_count( func uncollected_count( func is_registered( func has_observed_death( func emission_answer( func problem( func _owned_problem( " ]]; then
	fail "the runtime declares the functions: ${functions:-none}"
	shape=$((shape + 1))
fi
# NO ARITHMETIC AND NO LITERAL: `%` only as the one formatting operator.
if grep -qE '[+*/&|^]|<<|>>' <<< "$code"; then
	fail "the runtime adds, multiplies, divides or operates on bits"
	shape=$((shape + 1))
fi
if sed 's/->//g' <<< "$code" | grep -qF -- '-'; then
	fail "the runtime subtracts or negates something"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '%' <<< "$code" | wc -l | tr -d ' ')" != "1" ]]; then
	fail "the runtime uses % other than in its one formatted sentence"
	shape=$((shape + 1))
fi
literals="$(grep -oE '(^|[^A-Za-z0-9_.])[0-9][0-9_.]*' <<< "$code" | grep -oE '[0-9][0-9_.]*' | LC_ALL=C sort -u | tr '\n' ' ')"
if [[ -n "${literals// /}" ]]; then
	fail "the runtime carries the literals: ${literals}"
	shape=$((shape + 1))
fi
# NO TICK, NO WAIT, NO SIGNAL, NO SCENE, NO OTHER IDENTITY, NO ACTOR MEMBER, NO
# OTHER COLLECTION, NO REMOVAL, AND NO ROOM, ROUND, WAVE OR ENCOUNTER.
# Foundation I1 (D-291): exactly its five declaration lines must name a typed
# collection — each pinned whole by the verification — and only those five exact
# lines are lifted out before this scan; every token still holds over every other line.
if grep -vxE '[[:space:]]*(profiles: Array\[SkillTagProfile\],|definitions: Array\[SupportDefinition\],|cards: Array\[PassiveCardDefinition\]|func offer_lanes\(\) -> Array\[int\]:|func offer_identity_for\(lane: int\) -> PackedStringArray:)' <<< "$code" \
		| grep -qE '_process|Timer|create_timer|await|emit_signal|\.emit\(|signal |disconnect|get_node|get_tree|find_child|get_parent|get_children|get_instance_id|instance_from_id|\.name|display_name|\.data|global_position|place_at|receive_damage|reset_encounter|is_alive|died|Node|while |match |Array|Packed|load\(|erase\(|clear\(|duplicate\(|remove|sort|shuffle|room|round|wave|encounter|family|is_instance_valid|print|push_error|assert'; then
	fail "the runtime ticks, waits, signals, reaches into a scene, identifies a Graveblade another way, touches the actor, holds another collection, removes something or names a room, round, wave or encounter"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '.new(' <<< "$code" | wc -l | tr -d ' ')" != "3" \
		|| "$(grep -oF 'RiftGravebladeMoteBinding.new(_run.run_seed(), enemy, _field, base_experience)' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'connect_to_death()' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'sweep_collection(' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -cF '_bindings[enemy] = binding' <<< "$code" | tr -d ' ')" != "1" \
		|| "$(grep -cF 'in _bindings.keys():' <<< "$code" | tr -d ' ')" != "1" \
		|| "$(grep -cF 'in _bindings.values():' <<< "$code" | tr -d ' ')" != "1" \
		|| "$(grep -cF 'in _bindings:' <<< "$code" | tr -d ' ')" != "0" ]]; then
	fail "the runtime does not make three objects, one binding from its run's seed, ask one connection and one sweep, keep one binding in one place, and walk its collection only through its keys and its values"
	shape=$((shape + 1))
fi
# THE REGISTRATION ORDER, BY LINE: no Graveblade, the owned run and field, a
# Graveblade already registered, then the one binding, its connection, its refusal
# gate — and only then is it kept.
order_ok=1
previous=0
for at in "$(line_of 'if enemy == null:')" "$(line_of 'var incoherent: String = _owned_problem()')" \
		"$(line_of 'if _bindings.has(enemy):')" "$(line_of 'RiftGravebladeMoteBinding.new(')" \
		"$(line_of 'var refusal: String = binding.connect_to_death()')" "$(line_of 'if not refusal.is_empty():')" \
		"$(line_of '_bindings[enemy] = binding')"; do
	if [[ -z "$at" || "$at" -le "$previous" ]]; then
		order_ok=0
		break
	fi
	previous="$at"
done
if [[ "$order_ok" != "1" ]]; then
	fail "register_graveblade() does not refuse no Graveblade, an incoherent run and field and a registered Graveblade, then make, connect and gate one binding, then keep it"
	shape=$((shape + 1))
fi
# THE DUPLICATE GATE STANDS IMMEDIATELY BEFORE THE BINDING IS MADE — its return
# between them — AND THE BINDING IS KEPT ON THE LINE AFTER ITS REFUSAL RETURNS.
duplicate_line="$(line_of 'if _bindings.has(enemy):')"
made_line="$(line_of 'RiftGravebladeMoteBinding.new(')"
refusal_gate="$(line_of 'if not refusal.is_empty():')"
kept_line="$(line_of '_bindings[enemy] = binding')"
refusal_return="$(sed -n "$(( ${refusal_gate:-0} + 1 ))p" "$PROJECT_DIR/$RUNTIME" | tr -d '[:space:]')"
if [[ -z "$duplicate_line" || "$made_line" != "$((duplicate_line + 2))" || "$refusal_return" != "returnrefusal" \
		|| "$kept_line" != "$((refusal_gate + 2))" ]]; then
	fail "the duplicate gate is not directly before the binding, or the binding is not kept directly after its refusal returns (${duplicate_line:-?} / ${made_line:-?} / ${refusal_gate:-?} / ${kept_line:-?})"
	shape=$((shape + 1))
fi
# THE SWEEP IS ONE LINE: THE FIELD, SWEPT INTO THE RUN, FOR THE POSITION GIVEN.
sweep_decl="$(line_of 'func sweep_at(player_position: Vector3) -> RiftMoteSweepResult:')"
sweep_body="$(sed -n "$(( ${sweep_decl:-0} + 1 ))p" "$PROJECT_DIR/$RUNTIME" | sed -E 's/^[[:space:]]+//')"
if [[ -z "$sweep_decl" || "$sweep_body" != 'return _field.sweep_collection(player_position, _run)' ]]; then
	fail "the sweep is not the one line handing the field its run: '${sweep_body}'"
	shape=$((shape + 1))
fi
if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|preload\(|load\(|res://' \
		"$PROJECT_DIR/$RUNTIME"; then
	fail "the runtime reads storage, randomness, ambient engine state or a resource"
	shape=$((shape + 1))
fi
# Enemy records, experience balance, the OTHER experience records, and every
# accepted scan's guarded token the runtime is not granted — raw, comments included.
# Lower-case "elite" is anchored, because a bare token fails on "Roguelite".
if grep -qE 'GravebladeData|experience_reward|GRAVEBLADE_EXPERIENCE|ExperienceTable|experience_table|CharacterState|LabProgress|progression|max_life|[Vv]anguard|VANGUARD|Elite|[ _]elite|ELITE|XP|Mauler|Marrowshot|Tombknife|Acolyte|Cantor|Warden|\.tres|\.tscn|RiftExperienceMote|rift_experience_mote|collect_into|RiftMoteDrop|rift_mote_drop|attempt_collection|RiftMoteCollection|RiftMotePickup|rift_mote_field|rift_mote_sweep_result|spawn_drop|RiftEnemyMoteEmission|rift_enemy_mote_emission|emit_at|rift_graveblade_mote_binding|RiftLevelUpCoordinator|next_level_coordinator|open_offer|award_experience|RiftExperienceTrack|RiftExperienceReading|RiftConsumptionLedger|RiftLevelRequirement|RiftLevelOfferSeed|requirement_reading|PlayerStat|SkillSupportCatalogue|DamageEvent|RogueliteCoreLoopRuntime|RogueliteReplayabilityRuntime|RogueliteBuildVariety' \
		"$PROJECT_DIR/$RUNTIME"; then
	fail "the runtime names an enemy record, a balance value, another experience record or a guarded token it is not granted"
	shape=$((shape + 1))
fi
# FOUNDATION I1 (D-291): the four guarded tokens its delegations must name moved out
# of the zero-occurrence scan above and are owed EXACTLY ONCE each, raw, comments
# included — so a second choice, a catalogue named even in a comment, or the run's
# opening asked twice fails exactly as any mention did before.
# ROGUELITE I3 (D-295): D2's build type moved out of the zero-occurrence scan the same
# way — owed exactly once, as the return type of the one-line build reading.
for granted in 'open_current_offer' 'choose(' 'RiftRunLevelUpResult' 'PassiveCard' 'RiftRunBuild'; do
	if [[ "$(grep -oF -- "$granted" "$PROJECT_DIR/$RUNTIME" | wc -l | tr -d ' ')" != "1" ]]; then
		fail "the runtime names $granted $(grep -oF -- "$granted" "$PROJECT_DIR/$RUNTIME" | wc -l | tr -d ' ') times, not exactly once"
		shape=$((shape + 1))
	fi
done
if [[ "$shape" == "0" ]]; then
	pass "three bare fields and twenty-three functions; I1's four granted tokens and I3's one each exactly once; no arithmetic and no literal; every refusal before the one binding, the duplicate gate directly before it and the keeping directly after its refusal; the one-line sweep; the collection walked only through its keys and values; no ambient read, record, balance or ungranted token"
fi

# EVERY PROJECT CLASS, READ FROM ITS OWN `class_name` LINE — never typed here.
declare -a project_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && project_classes+=("$name"); done \
	< <(grep -rhoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/scripts" "$PROJECT_DIR/addons" 2>/dev/null \
		| awk '{print $2}' | LC_ALL=C sort -u)
named=""
for name in "${project_classes[@]}"; do
	grep -qF "$name" "$PROJECT_DIR/$RUNTIME" && named="$named$name "
done
if [[ "${#project_classes[@]}" -lt 100 ]]; then
	fail "only ${#project_classes[@]} project classes were read — the class scan may be inert"
elif [[ "$named" == "$EXPECTED_NAMED " ]]; then
	pass "of ${#project_classes[@]} project classes the runtime names exactly $EXPECTED_NAMED"
else
	fail "the runtime names: ${named:-nothing}"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# NOTHING THAT RUNS CREATES A RUNTIME.
unwired=0
for token in "RiftMoteRuntime" "rift_mote_runtime"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$RUNTIME"|*/"$RUNTIME".uid) continue ;;
		esac
		# D-288: the Roguelite Experience Collection Greybox Review, an isolated scene
		# launched by name, makes exactly one runtime per expedition — granted the
		# runtime's class, never its file name. Recorded in the verification's
		# per-file, per-token reader table.
		if [[ "$token" == "RiftMoteRuntime" ]]; then
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
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	unwired=$((unwired + 1))
fi
if [[ "$unwired" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the runtime, but the experience collection review, granted its class alone"
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
step "4. scripts/experience/ holds exactly E1's two scripts, H1's mote, H6's emission, H7's binding and H8's runtime"
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
	printf 'RIFT MOTE RUNTIME SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation H8 — Run-Owned Experience-Mote Runtime — is\n'
	printf '  DELIVERED under D-286 and ACCEPTED and CLOSED at the single-run\n'
	printf '  Experience-Mote ownership and explicit-sweep mechanism level under D-287.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT MOTE RUNTIME SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
