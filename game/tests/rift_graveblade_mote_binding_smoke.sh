#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation H7 smoke checks: one real Graveblade's
# death, heard once through its own `died` signal, becomes its one Experience
# Mote drop in the mote field of its run (decision D-283).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation H7 adds ONE script under `scripts/experience/` — a binding of one
# `PrototypeGraveblade`, one H5 mote field and one H6 enemy mote emission. Asked
# explicitly, it validates itself and connects to the Graveblade's EXISTING
# `died` signal; when that Graveblade dies it reads the bound Graveblade's own
# world position — never the event's source or target — and makes exactly one
# H6 emission attempt there, keeping H6's exact answer. No scene, no resource, no
# asset, no InputMap action, no entrypoint change, nothing written to disk, no
# edit to the Graveblade, its scene or its records, and NOTHING THAT RUNS CREATES
# A BINDING.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT COMPOSES. Four accepted suites moved one for
# one because the binding names their classes or shares their directory — H6,
# whose blanket unwired scan became a per-file, per-token table granting the
# binding the emission's class and its emitting call, and whose directory pin
# gained one script; H5, whose reader table granted the binding the field's class
# alone; H1 and E1, whose directory pins gained one script — and each is rerun by
# its own runner at its own unchanged count.
#
# What this script proves:
#
#   1. the new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log — and a run that
#      hangs is killed and FAILS rather than waiting forever, because this is the
#      first H-series suite that awaits a frame and a script error inside a
#      coroutine leaves the engine running with nothing left to call `quit()`;
#   3. from outside the engine: the binding declares exactly its six bare fields
#      and eight functions, no constant, static state or signal; it carries no
#      literal and performs no arithmetic; it checks no Graveblade, no field, the
#      emission's amount, the field's coherence and ownership, then its own and
#      the signal's connection, then — last, immediately before it connects —
#      whether the Graveblade is already dead (D-284); its callback returns first
#      on a heard death, then reads the bound Graveblade's position, then asks
#      its one emission, then records the death; it reads the event for nothing;
#      it names no enemy record, balance value, storage or ambient state and no
#      guarded token it is not granted; of every project class — READ from the
#      `class_name` lines under `scripts/` and `addons/` — it names exactly its
#      five; nothing that runs names it; and the verification names no file under
#      `tests/` but its own;
#      (D-286: Foundation H8's Experience Mote runtime, which nothing creates, is
#      granted the binding's class and its connecting call, by file and token;)
#   4. `scripts/experience/` holds exactly E1's two scripts, H1's mote, H6's
#      emission, H7's binding, H8's runtime (D-286), and their uid files;
#   5. the files this work could conceivably have disturbed — the project owner's
#      loading teaser, the Graveblade actor, its scene, its rig, its target area
#      and both of its records, the damage event, the attack coordinator, every
#      accepted mechanism H7 composes or stands beside, the project's OTHER
#      experience records, the three roguelite runtimes and `CLAUDE.md` — are
#      BYTE-IDENTICAL ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_graveblade_mote_binding_smoke.sh

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
		printf '\nRIFT GRAVEBLADE MOTE BINDING SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_graveblade_mote_binding_verification.gd"

# Pinned, and proved in both directions below. 165 at delivery (D-283), plus the 13
# assertions of D-284's already-dead check = 178.
EXPECTED_CHECKS=178

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=17

# Seconds the verification may take before it is killed and counted as a failure.
# A green run takes a few seconds; this exists only so a hang cannot pass or stall.
VERIFICATION_TIMEOUT=300

BINDING="scripts/experience/rift_graveblade_mote_binding.gd"
THIS_VERIFICATION="tests/rift_graveblade_mote_binding_verification.gd"

PARSED_SCRIPTS=(
	"$BINDING"
	"$THIS_VERIFICATION"
)

# The only project classes the binding may name, in C-locale sort order: the event
# the death arrives with, the actor whose death it hears, the emission it asks, the
# field it emits into, and itself.
EXPECTED_NAMED="DamageEvent PrototypeGraveblade RiftEnemyMoteEmission RiftGravebladeMoteBinding RiftMoteField"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# project owner's composed zone and loading teaser with its import settings
# (pre-existing work this foundation does not touch), the Graveblade this
# foundation listens to and must not edit — its actor script, scene, rig, target
# area, record script and both records — the damage event and attack coordinator
# its death order depends on, the canonical combat record, every accepted
# mechanism the binding composes or stands beside, the project's OTHER experience
# records, the three roguelite runtimes this foundation deliberately does not wire
# into, the canonical opening that awards character experience, and `CLAUDE.md`.
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
	"data/prototype_zero/quick_strike.tres"
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

# The first H-series suite with real nodes in it, so engine errors that are not
# script errors — a node read outside the tree, a physics complaint — are refused
# too. The verification's own FAIL lines are printed separately.
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

# The first line number at which a fixed string occurs in the binding.
line_of() {
	grep -nF -- "$1" "$PROJECT_DIR/$BINDING" | head -1 | cut -d: -f1
}

printf 'Riftwrought — Roguelite Foundation H7: Graveblade death-to-mote binding (D-283)\n'
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
verify_log="/tmp/riftwrought_rift_graveblade_mote_binding_verify.log"
perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" \
	"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless binding verification" "$verify_log"
assert_no_engine_error "the headless binding verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT GRAVEBLADE MOTE BINDING VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_graveblade_mote_binding_replay)"
scratch_replay="$replay"
sed "s/RIFT GRAVEBLADE MOTE BINDING VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT GRAVEBLADE MOTE BINDING VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT GRAVEBLADE MOTE BINDING VERIFICATION" "$replay")"
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
the constructor takes 4 arguments and no method defaults one; construction left the Graveblade's died at 1 connection (the harness's own observer) and the binding not connected
connect_to_death(): '' — 1 connection added, exactly 1 of them the binding's; a second answered 'this Graveblade's Experience Mote binding has already connected or already heard a death; it connects nothing again' and added 0
a binding connected ('') and then let go left the Graveblade's died at 1 connections, its own gone; the death (300 -> 200 -> 100 -> 0) made 0 drops
2 accepted hits of 100.0: Life 300 -> 200 -> 100, took_damage 2, died 0 — 0 drops, death heard: false, emitted: false
Life 300 -> 200 -> 100 -> 0: took_damage 3, died 1; the lethal event's source stood at (30.0, 0.0, 30.0) and its target at (-30.0, 0.0, -30.0)
the Graveblade entered at (-12.0, 0.0, 8.0) and died at (6.0, 0.0, -6.0); just before the binding's callback the field held 0 drops, just after it 1
8 of 8 probes held: nothing in range from where it entered, the attacker or the target; nothing one float32 spacing beyond 2.5 m on any of four sides; collected exactly 2.5 m away and paid 25.0 — as a twin given the drop directly answered
the one killed (300 -> 200 -> 100 -> 0) by an event from the second at the third: died 1 / 0 / 0, 1 drop, the source's and target's bindings unheard
7 of 7 probes held: the drop lies where the killed Graveblade died and pays its own 25.0 — not the source's 12.5 or the target's 40.0
first death (300 -> 200 -> 100 -> 0) at (-26.0, 0.0, -20.0): 1 drop; 3 hits on the dead Graveblade were ignored — Life 0, died still 1, 1 drop
reset_encounter() restored it at (-20.0, 0.0, -20.0) with the binding still connected; the second death (300 -> 200 -> 100 -> 0) fired died a second time and the field still holds 1 drop, emitted, answer ''
6 of 6 probes held: the one drop lies where the FIRST death happened, not the second
bound first (25.0) and second (12.5), killed second-bound first: from where the second-bound fell the sweep collected [0] paying 12.5; from where the first-bound fell, [1] paying 25.0 — as a twin answered
2 deaths left the run exactly as it was (seed=99 level=1 experience=0.0 offer=false) and the field 2 drops, 0 collected
one sweep 1.5 m from both collected [0, 1] and delivered 37.5 = 12.5 + 25.0; a resweep skipped both and paid nothing
12 of 12 refusals word for word — no Graveblade, one that no longer exists, no field, another run's field, three in precedence order, and zero, negative, not a number, positive infinity, negative infinity with H1's own reason — each connecting nothing
no Graveblade: 'a Graveblade's Experience Mote binding needs the Graveblade whose death it hears, and there is none'; no field: 'a Graveblade's Experience Mote binding needs the mote field of its run, and none was given'; another run: 'this Graveblade's Experience Mote belongs to run seed 99, not to the mote field's run seed 100; it may be bound only to a field of its own run'
the Graveblade then died (300 -> 200 -> 100 -> 0): died 1, 0 refused bindings heard it, 0 drops anywhere
seeds 0, 4294967296, -9223372036854775808, -1, 4294967295, 9223372036854775807: 6 of 36 binding-field pairs connected, and each Graveblade's drop was collected by its own run; 30 refused naming both seeds in full, 12 of them seeds that agree in their low 32 bits
the Graveblade all 30 refused bindings named then died: 30 of 30 of their fields hold 0 drops
3 of 3 Graveblades given one non-finite component under a Node3D parent — x not a number, y positive infinity, z negative infinity — stood at (nan, nan, nan) by the engine's own reading
3 of 3 dying there: the callback kept the field's own answer for that place word for word — 'an Experience Mote drop's position must have a finite x, y and z, not (nan, nan, nan)' — with 0 drops, the death heard and H6 pending
3 of 3 then refused a reconnection, were restored at a finite spawn where a fresh emission would have emitted, and died again: still 0 drops and the same answer — nothing retried
a Graveblade killed with no binding (300 -> 200 -> 100 -> 0), then given a fresh coherent binding: 2 of 2 connection attempts while it stayed dead answered 'the bound Graveblade is already dead; its Experience Mote binding must be connected before death' and moved nothing — 0 callbacks connected, connected=false heard=false emitted=false answer='', the field 0 drops
reset_encounter() restored the same Graveblade alive at (220.0, 0.0, 0.0) with Life 300; the same unused binding then connected ('') exactly once — a second attempt answered 'this Graveblade's Experience Mote binding has already connected or already heard a death; it connects nothing again'
killed at (226.0, 0.0, 0.0) (300 -> 200 -> 100 -> 0): died 2, 1 drop, answer ''; a further revive and death (300 -> 200 -> 100 -> 0, died 3) refused a reconnection ('this Graveblade's Experience Mote binding has already connected or already heard a death; it connects nothing again') and added no drop — the field still holds 1
6 of 6 probes held: the one drop lies where the restored Graveblade died, not where it was restored
before the kill: alive=true state=ATTACK_WINDUP layer=8 mask=3 target_layer=4 monitorable=true permission=true holder=DeathOrder animation=-1 drops=0 heard=false emitted=false
heard just before the binding: alive=false state=DEAD layer=0 mask=0 target_layer=0 monitorable=false permission=false holder=none animation=-1 drops=0 heard=false emitted=false
heard just after the binding:  alive=false state=DEAD layer=0 mask=0 target_layer=0 monitorable=false permission=false holder=none animation=-1 drops=1 heard=true emitted=true
the kill read 300 -> 200 -> 100 -> 0; the death animation started only after every listener, inside the same call
ordinary 300 -> 200 -> 100 -> 0; elite 600 -> 500 -> 400 -> 300 -> 200 -> 100 -> 0
both records carry 10 in their own reward field; 4 of 4 drops paid exactly the caller's amount: ordinary 25.0, elite 25.0, ordinary 40.0, elite 12.5
6 fields declared exactly (_enemy, _field, _emission, _connected, _death_observed, _emission_answer), 0 collections
8 methods pinned, none defaulting an argument, only _init declaring an object answer; 20 connection steps in order, each once; 8 gates each return on the next line; the dead-Graveblade gate last among them, immediately before the connection, and the connection and its mark last
the callback is exactly: func _on_enemy_died(_event: DamageEvent) -> void: | if _death_observed: | return | var defeat_position: Vector3 = _enemy.global_position | _emission_answer = _emission.emit_at(defeat_position, _field) | _death_observed = true
15 return lines pinned; asked: _enemy { "died": 2, "is_alive": 1, "global_position": 1 }; _field { "problem": 1, "run_seed": 2 }; _emission { "problem": 1, "run_seed": 2, "emit_at": 1, "is_emitted": 1, "describe": 1 }; the event is named once, in the callback's signature, and read never; 0 reset, retry, re-arm, copy, setter or position members
0 hits for 59 balance, record, enemy-content, storage and other-foundation tokens and 41 behaviour tokens; no arithmetic; % only in its 3 formatted sentences; literals []
the binding names only DamageEvent, PrototypeGraveblade, RiftEnemyMoteEmission, RiftGravebladeMoteBinding, RiftMoteField; its name overlaps 0 other class names;
0 unauthorized project files create or connect a binding (1 reader granted by file and token); scripts/experience/ holds 6 scripts; 31 actions;
54 refusals were asserted and 31 Graveblade deaths were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Six bare fields, no arithmetic, every refusal before the one connection, the guard before the one attempt, five named classes, and nothing that runs creates a binding"
shape=0

code="$(bare_code "$PROJECT_DIR/$BINDING")"

fields="$(grep -E '^var ' <<< "$code" | tr '\n' '|')"
if [[ "$fields" != 'var _enemy: PrototypeGraveblade|var _field: RiftMoteField|var _emission: RiftEnemyMoteEmission|var _connected: bool = false|var _death_observed: bool = false|var _emission_answer: String = ""|' ]]; then
	fail "the binding declares the fields: ${fields:-none} — not exactly six, bare, in order"
	shape=$((shape + 1))
fi
if grep -qE '^(static|const|signal|enum|@)' <<< "$code"; then
	fail "the binding declares static state, a constant, a signal, an enum or an annotation"
	shape=$((shape + 1))
fi
functions="$(grep -oE '^func [a-z_]+\(' <<< "$code" | tr '\n' ' ')"
if [[ "$functions" != "func _init( func connect_to_death( func _on_enemy_died( func has_connected( func has_observed_death( func is_emitted( func emission_answer( func describe( " ]]; then
	fail "the binding declares the functions: ${functions:-none}"
	shape=$((shape + 1))
fi
# NO ARITHMETIC AND NO LITERAL: `%` only as the three formatting operators.
if grep -qE '[+*/&|^]|<<|>>' <<< "$code"; then
	fail "the binding adds, multiplies, divides or operates on bits"
	shape=$((shape + 1))
fi
if sed 's/->//g' <<< "$code" | grep -qF -- '-'; then
	fail "the binding subtracts or negates something"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '%' <<< "$code" | wc -l | tr -d ' ')" != "3" ]]; then
	fail "the binding uses % other than in its three formatted sentences"
	shape=$((shape + 1))
fi
literals="$(grep -oE '(^|[^A-Za-z0-9_.])[0-9][0-9_.]*' <<< "$code" | grep -oE '[0-9][0-9_.]*' | LC_ALL=C sort -u | tr '\n' ' ')"
if [[ -n "${literals// /}" ]]; then
	fail "the binding carries the literals: ${literals}"
	shape=$((shape + 1))
fi
# THE EVENT IS READ FOR NOTHING, AND THE GRAVEBLADE IS IDENTIFIED NO OTHER WAY.
# D-284: its own alive reading is granted once — counted below and placed by line.
if grep -qE '_event\.|\.source|\.target|display_name|\.name|get_node|find_child|get_parent|get_tree|get_instance_id|get_children|life|data|disconnect|retry|await|Timer|create_timer|_process|call_deferred|emit_signal|\.emit\(|for |while |match |Array|Dictionary|Packed|load\(|position =|place_at|reset|sweep|collect|award|spawn|is_instance_valid' <<< "$code"; then
	fail "the binding reads the event, identifies a Graveblade another way, reads a record, disconnects, retries, waits, loops or reaches a further step"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '_event' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF '.new(' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'RiftEnemyMoteEmission.new(for_run_seed, for_base_experience)' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'died.connect(' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'emit_at(' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -cF '_connected = true' <<< "$code" | tr -d ' ')" != "1" \
		|| "$(grep -cF '_death_observed = true' <<< "$code" | tr -d ' ')" != "1" \
		|| "$(grep -oF 'is_alive()' <<< "$code" | wc -l | tr -d ' ')" != "1" ]]; then
	fail "the binding does not name the event once, make one emission, ask the Graveblade's alive reading once, connect once, attempt once and mark each state once"
	shape=$((shape + 1))
fi
# THE CONNECTION ORDER, BY LINE: no Graveblade, no field, the amount, the field's
# coherence, ownership, already connected or heard, already listening, already dead,
# then the one connection, then — only then — the mark.
order_ok=1
previous=0
for at in "$(line_of 'if _enemy == null:')" "$(line_of 'if _field == null:')" \
		"$(line_of 'var invalid: String = _emission.problem()')" "$(line_of 'var incoherent: String = _field.problem()')" \
		"$(line_of 'if _field.run_seed() != _emission.run_seed():')" "$(line_of 'if _connected or _death_observed:')" \
		"$(line_of 'if _enemy.died.is_connected(_on_enemy_died):')" "$(line_of 'if not _enemy.is_alive():')" \
		"$(line_of '_enemy.died.connect(_on_enemy_died)')" "$(line_of '_connected = true')"; do
	if [[ -z "$at" || "$at" -le "$previous" ]]; then
		order_ok=0
		break
	fi
	previous="$at"
done
if [[ "$order_ok" != "1" ]]; then
	fail "connect_to_death() does not refuse no Graveblade, no field, the amount, an incoherent field, another run, a repeat, a live listener and a dead Graveblade, then connect, then mark"
	shape=$((shape + 1))
fi
# D-284: THE DEAD-GRAVEBLADE GATE SITS IMMEDIATELY BEFORE THE CONNECTION — its line
# directly after the listening gate's return, its own return next, and the real
# connection on the line after that. Containing `is_alive()` somewhere is not enough.
listening_line="$(line_of 'if _enemy.died.is_connected(_on_enemy_died):')"
dead_gate_line="$(line_of 'if not _enemy.is_alive():')"
connection_line="$(line_of '_enemy.died.connect(_on_enemy_died)')"
dead_return="$(sed -n "$(( ${dead_gate_line:-0} + 1 ))p" "$PROJECT_DIR/$BINDING" | sed -E 's/^[[:space:]]+//')"
if [[ -z "$dead_gate_line" || -z "$listening_line" || "$dead_gate_line" != "$((listening_line + 2))" \
		|| "$dead_return" != 'return "the bound Graveblade is already dead; its Experience Mote binding must be connected before death"' \
		|| "$connection_line" != "$((dead_gate_line + 2))" ]]; then
	fail "the dead-Graveblade gate is not directly after the listening gate and directly before the connection (${listening_line:-?} / ${dead_gate_line:-?} / ${connection_line:-?})"
	shape=$((shape + 1))
fi
# THE CALLBACK, BY LINE: its declaration, then the guard on the very next line and
# its return on the one after, then the position read from the bound Graveblade,
# then the one attempt, then the record that the death was heard.
callback_line="$(line_of 'func _on_enemy_died(_event: DamageEvent) -> void:')"
guard_line="$(line_of '	if _death_observed:')"
position_line="$(line_of 'var defeat_position: Vector3 = _enemy.global_position')"
attempt_line="$(line_of '_emission_answer = _emission.emit_at(defeat_position, _field)')"
heard_line="$(line_of '_death_observed = true')"
return_after_guard="$(sed -n "$(( ${guard_line:-0} + 1 ))p" "$PROJECT_DIR/$BINDING" | tr -d '[:space:]')"
if [[ -z "$callback_line" || "$guard_line" != "$((callback_line + 1))" || "$return_after_guard" != "return" \
		|| "$position_line" != "$((guard_line + 2))" || "$attempt_line" != "$((position_line + 1))" \
		|| "$heard_line" != "$((attempt_line + 1))" ]]; then
	fail "the callback is not guard, return, position, attempt, heard on consecutive lines (${callback_line:-?} / ${guard_line:-?} / ${position_line:-?} / ${attempt_line:-?} / ${heard_line:-?})"
	shape=$((shape + 1))
fi
if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|preload\(|load\(|res://' \
		"$PROJECT_DIR/$BINDING"; then
	fail "the binding reads storage, randomness, ambient engine state or a resource"
	shape=$((shape + 1))
fi
# Enemy records, experience balance, the OTHER experience records, and every
# accepted scan's guarded token the binding is not granted — raw, comments included.
# Lower-case "elite" is anchored, because a bare token fails on "Roguelite".
if grep -qE 'GravebladeData|experience_reward|GRAVEBLADE_EXPERIENCE|ExperienceTable|experience_table|CharacterState|LabProgress|progression|max_life|[Vv]anguard|VANGUARD|Elite|[ _]elite|ELITE|XP|Mauler|Marrowshot|Tombknife|Acolyte|Cantor|Warden|\.tres|\.tscn|RiftExperienceMote|rift_experience_mote|collect_into|RiftMoteDrop|rift_mote_drop|attempt_collection|RiftMoteCollection|RiftMotePickup|rift_mote_field|RiftMoteSweepResult|sweep_collection|spawn_drop|rift_enemy_mote_emission|RiftRunLevelCoordinator|award_experience|RiftExperienceTrack|RiftExperienceReading|RiftRunBuild|PlayerStat|RogueliteCoreLoopRuntime|RogueliteReplayabilityRuntime|RogueliteBuildVariety' \
		"$PROJECT_DIR/$BINDING"; then
	fail "the binding names an enemy record, a balance value, another experience record or a guarded token it is not granted"
	shape=$((shape + 1))
fi
if [[ "$shape" == "0" ]]; then
	pass "six bare fields and eight functions; no arithmetic and no literal; the event named once and read never; every refusal before the one connection, the dead-Graveblade gate directly before it, and the mark after it; guard, position, attempt and heard on consecutive lines; no ambient read, no record, no balance and no ungranted token"
fi

# EVERY PROJECT CLASS, READ FROM ITS OWN `class_name` LINE — never typed here.
declare -a project_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && project_classes+=("$name"); done \
	< <(grep -rhoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/scripts" "$PROJECT_DIR/addons" 2>/dev/null \
		| awk '{print $2}' | LC_ALL=C sort -u)
named=""
for name in "${project_classes[@]}"; do
	grep -qF "$name" "$PROJECT_DIR/$BINDING" && named="$named$name "
done
if [[ "${#project_classes[@]}" -lt 100 ]]; then
	fail "only ${#project_classes[@]} project classes were read — the class scan may be inert"
elif [[ "$named" == "$EXPECTED_NAMED " ]]; then
	pass "of ${#project_classes[@]} project classes the binding names exactly $EXPECTED_NAMED"
else
	fail "the binding names: ${named:-nothing}"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# NOTHING THAT RUNS CREATES OR CONNECTS A BINDING.
unwired=0
for token in "RiftGravebladeMoteBinding" "rift_graveblade_mote_binding" "connect_to_death("; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$BINDING"|*/"$BINDING".uid) continue ;;
		esac
		# D-286: Foundation H8's Experience Mote runtime makes, connects and owns one
		# binding for each registered Graveblade — granted the binding's class and the
		# connecting call, never the binding's file name. Recorded in the
		# verification's per-file, per-token reader table. Nothing creates a runtime.
		if [[ "$token" == "RiftGravebladeMoteBinding" || "$token" == "connect_to_death(" ]]; then
			case "$hit" in
				*/scripts/experience/rift_mote_runtime.gd) continue ;;
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
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the binding or connects one but H8's granted runtime, which nothing creates"
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
	printf 'RIFT GRAVEBLADE MOTE BINDING SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation H7 — Graveblade Death-to-Mote Binding — is\n'
	printf '  DELIVERED under D-283, CORRECTED under D-284, and ACCEPTED and CLOSED\n'
	printf '  at the one-enemy death-to-mote binding mechanism level under D-285.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT GRAVEBLADE MOTE BINDING SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
