#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation H6 smoke checks: the run-owned, one-time
# Experience Mote emission of one defeated enemy (decision D-281).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation H6 adds ONE pure-logic script under `scripts/experience/` — the
# record of the one Experience Mote reward one future enemy owns: an exact signed
# run seed, a caller-supplied base experience, and whether it has emitted. Asked
# to emit at a defeat position into the mote field of its own run, it asks that
# field to make exactly one drop, and marks itself emitted only after the field
# confirms the drop was appended. No scene, no resource, no asset, no InputMap
# action, no entrypoint change, nothing written to disk, no enemy connected, and
# NOTHING THAT RUNS CREATES OR EMITS AN EMISSION.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT COMPOSES. Four accepted suites moved one for
# one because the emission names their classes or shares their directory — H1,
# whose reader table granted the emission the mote's class alone and whose
# directory pin gained one script; H2, whose mote reader table gained the same
# grant; H5, whose blanket unwired scan became a per-file, per-token table granting
# the emission the field's class and its drop-making call; and E1, whose directory
# pin gained one script — and each is rerun by its own runner at its own unchanged
# count.
#
# What this script proves:
#
#   1. the new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log;
#   3. from outside the engine: the emission declares exactly its three bare
#      fields and seven functions, no constant, static state or signal; it
#      carries no literal and performs no arithmetic; it restates no amount or
#      position rule and folds no seed; it makes one temporary mote in one place
#      and asks the field for one drop in one place; it refuses an emitted
#      record, then an invalid amount, then a missing field, then an incoherent
#      field, then another run's seed, before the field is asked for a drop, and
#      marks itself emitted only after that; it reads no storage, randomness,
#      ambient state, physics or scenes, and names no enemy content, no
#      experience balance and no guarded token it is not granted; of every project
#      class — READ from the `class_name` lines under `scripts/` and `addons/` — it
#      names exactly its three; nothing that runs names it — Foundation H7's
#      Graveblade mote binding, which nothing creates, is granted the emission's
#      class and its emitting call (D-283); and the verification names no file
#      under `tests/` but its own;
#   4. `scripts/experience/` holds exactly E1's two scripts, H1's mote, H6's
#      emission, H7's binding, H8's runtime (D-286), and their uid files;
#   5. the files this work could conceivably have disturbed — the project owner's
#      loading teaser, the character experience table, the laboratory progression
#      records and every Graveblade record among them — are BYTE-IDENTICAL ACROSS
#      THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_enemy_mote_emission_smoke.sh

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
		printf '\nRIFT ENEMY MOTE EMISSION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_enemy_mote_emission_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=347

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=16

EMISSION="scripts/experience/rift_enemy_mote_emission.gd"
THIS_VERIFICATION="tests/rift_enemy_mote_emission_verification.gd"

PARSED_SCRIPTS=(
	"$EMISSION"
	"$THIS_VERIFICATION"
)

# The only project classes the emission may name, in C-locale sort order: itself,
# the mote whose own rule validates its amount, and the field it emits into.
EXPECTED_NAMED="RiftEnemyMoteEmission RiftExperienceMote RiftMoteField"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# canonical combat record, the project owner's composed zone, the project owner's
# loading teaser and its import settings (pre-existing work this foundation does
# not touch), the accepted mechanisms the emission composes or stands beside — H1's
# mote, H5's field and result, H4's drop, H3's attempt and result, H2's query and
# reading, G4's coordinator and its record, the one-level lifecycle and its receipt,
# E1's track and reading — and the project's OTHER experience and enemy records,
# which this foundation must neither reuse nor edit: the character experience table
# and state, the laboratory progression script, record and data, both Graveblade
# records, the Graveblade actor whose death this foundation deliberately does not
# hear, and the canonical opening that awards character experience.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
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
	"scripts/levels/rift_level_up_result.gd"
	"scripts/character/experience_table.gd"
	"scripts/character/character_state.gd"
	"scripts/prototype_zero/lab_progress.gd"
	"scripts/prototype_zero/lab_progression_data.gd"
	"data/prototype_zero/progression.tres"
	"data/prototype_zero/graveblade.tres"
	"data/roguelite/graveblade_elite.tres"
	"scripts/actors/prototype_graveblade.gd"
	"scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
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

printf 'Riftwrought — Roguelite Foundation H6: run-owned one-time enemy mote emission (D-281)\n'
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
verify_log="/tmp/riftwrought_rift_enemy_mote_emission_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless emission verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT ENEMY MOTE EMISSION VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_enemy_mote_emission_replay)"
scratch_replay="$replay"
sed "s/RIFT ENEMY MOTE EMISSION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT ENEMY MOTE EMISSION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT ENEMY MOTE EMISSION VERIFICATION" "$replay")"
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
the constructor takes 2 arguments and no method defaults one; 24 of 24 emissions over 6 seeds and 4 amounts read back their exact seed and amount; none has emitted
into an empty field of run seed 99: '' — 1 drop, 0 collected; Enemy Experience Mote emission of run seed 99, worth 25 base experience; emitted
the field reads exactly as a twin given the same position and amount directly: Experience Mote field of run seed 99: 1 drops, 0 collected, 1 not collected
4 emissions of 25.0 — one level-1 requirement's worth — left the run at level 1 with 0.0, offer open: false, and the field 0 collected
the field's own sweep then collected [0, 1, 2, 3] and delivered 100.0: still level 1, offer open: false
25, 0.1, 5e-324, 1.7e+308: each emitted drop was collected at entry 0 by a later sweep and paid exactly its amount; a resweep skipped it and paid nothing
one spacing within 2.5 m collected, one spacing beyond out of range — identical to a twin given the same positions directly (sweep of 2 drops: 0 skipped as already collected, 2 attempted — 1 collected [0], 1 out of range, 0 refused)
after one emission, 6 of 6 further attempts — the same field, another matching field, no field, a stranger's field, a non-finite position, and after the drop was collected — answered 'this enemy's Experience Mote has already been emitted; it emits nothing again' and added 0 drops
2 emissions of 25.0 at one defeat position: 2 drops, each emission emitted once; the sweep collected [0, 1] and delivered 50.0
no field: 'an enemy's Experience Mote must be emitted into a mote field, and none was given' twice — once at a non-finite position, where a field would have answered 'an Experience Mote drop's position must have a finite x, y and z, not (nan, 0.0, 0.0)' — and the emission unmoved; it then emitted once into its own field
9 non-finite defeat positions: 9 of 9 refused with the field's own answer word for word — 'an Experience Mote drop's position must have a finite x, y and z, not (nan, 0.0, 0.0)' for (nan, 0.0, 0.0) — nothing appended, a field holding 2 drops unmoved, and the emission not emitted
retried at a finite position the same emission emitted once, and once only: seed=99 drops=1 collected=0 uncollected=1 problem=''
zero, negative, not a number, positive infinity, negative infinity: 25 of 25 attempts refused with H1's own reason word for word — twice into the owning field, before a non-finite position the field would have named first, before a missing field and before ownership — nothing appended and none emitted
zero answers 'an Experience Mote's base experience must be positive, not 0'
run seed 100's field refused ('this enemy's Experience Mote belongs to run seed 99, not to the mote field's run seed 100; it may be emitted only into a field of its own run') — at the defeat position, at a non-finite position that field would have named first ('an Experience Mote drop's position must have a finite x, y and z, not (nan, 0.0, 0.0)'), and into a field already holding 2 drops — with 0 drops added
the correct field then received it once, and its own run collected 25.0
0 and 4294967296 each refused the other's field ('this enemy's Experience Mote belongs to run seed 0, not to the mote field's run seed 4294967296; it may be emitted only into a field of its own run' / 'this enemy's Experience Mote belongs to run seed 4294967296, not to the mote field's run seed 0; it may be emitted only into a field of its own run') and each emitted into its own, which its own run then collected
seeds 0, 4294967296, -9223372036854775808, -1, 4294967295, 9223372036854775807: 6 of 36 emission-field pairs emitted (each into its own run's field); 30 refused naming both seeds in full, 12 of them seeds that agree in their low 32 bits; 30 of 30 refused emissions then emitted into their own field
a field holding 3 prior drops (entry 0 already collected) received the emission as entry 3 of 4
sweeps from the new drop and from each prior drop collected [3], then [1], then [2], paying 25.0, 12.5, 17.5 — the field and a twin given the same four drops directly answered identically 4 of 4 times
3 fields (_run_seed:int, _base_experience:float, _emitted:bool), 0 object references; 5 argument-free readings answer 0 objects; emit_at answered a String 2 of 2 times
the methods declaring an object answer are _init; the one temporary mote is made inside the one return statement that answers with its problem, and 100 more problem() calls moved nothing
3 fields declared exactly (_emitted alone initialized, to false); written only as _run_seed = for_run_seed, _base_experience = for_base_experience, _emitted = true; 7 methods pinned, none defaulting an argument; 0 constants, signals, reset, re-arm, copy, transfer, setter or listener members
16 emission steps in order, each once; 6 gates each return on the next line; 12 return lines pinned; the field is asked problem() 1, run_seed() 2 and spawn_drop( 1 times, and nothing else
0 hits for enemy content (17 names, Graveblade and Vanguard among them), the character and laboratory experience records, other foundations' members, amount or position rules, seed folding, arithmetic, loops, nodes, signals, scenes, physics or files; literals []
the emission names only RiftEnemyMoteEmission, RiftExperienceMote, RiftMoteField; its name overlaps 0 other class names;
0 unauthorized project files create or emit an emission (1 reader granted by file and token); scripts/experience/ holds 6 scripts; 31 actions;
83 refusals and 57 emissions were asserted across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Three bare fields, no arithmetic, the refusals before the one drop, three named classes, and nothing that runs creates an emission"
shape=0

code="$(bare_code "$PROJECT_DIR/$EMISSION")"

fields="$(grep -E '^var ' <<< "$code" | tr '\n' '|')"
if [[ "$fields" != "var _run_seed: int|var _base_experience: float|var _emitted: bool = false|" ]]; then
	fail "the emission declares the fields: ${fields:-none} — not exactly three, bare, in order"
	shape=$((shape + 1))
fi
if grep -qE '^(static|const|signal|enum|@)' <<< "$code"; then
	fail "the emission declares static state, a constant, a signal, an enum or an annotation"
	shape=$((shape + 1))
fi
functions="$(grep -oE '^func [a-z_]+\(' <<< "$code" | tr '\n' ' ')"
if [[ "$functions" != "func _init( func run_seed( func base_experience( func is_emitted( func problem( func emit_at( func describe( " ]]; then
	fail "the emission declares the functions: ${functions:-none}"
	shape=$((shape + 1))
fi
# NO ARITHMETIC AND NO LITERAL: `%` only as the two formatting operators.
if grep -qE '[+*/&|^]|<<|>>' <<< "$code"; then
	fail "the emission adds, multiplies, divides or operates on bits"
	shape=$((shape + 1))
fi
if sed 's/->//g' <<< "$code" | grep -qF -- '-'; then
	fail "the emission subtracts or negates something"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '%' <<< "$code" | wc -l | tr -d ' ')" != "2" ]]; then
	fail "the emission uses % other than in its two formatted sentences"
	shape=$((shape + 1))
fi
literals="$(grep -oE '(^|[^A-Za-z0-9_.])[0-9][0-9_.]*' <<< "$code" | grep -oE '[0-9][0-9_.]*' | LC_ALL=C sort -u | tr '\n' ' ')"
if [[ -n "${literals// /}" ]]; then
	fail "the emission carries the literals: ${literals}"
	shape=$((shape + 1))
fi
# NO RULE RESTATED: the amount is H1's question, the position H4's, the seed whole.
if grep -qE 'is_finite|is_nan|is_inf|is_zero|> 0|<= 0|< 0|sqrt|abs\(|pow\(|min\(|max\(|clamp|snapped|round|floor|ceil|\.x|\.y|\.z|distance|radius|mask|hash\(|Dictionary|Array|Packed|set\(|get\(|setget|duplicate|free\(|sort|erase|remove|clear\(|append|signal|emit_signal|\.emit\(|connect\(|await|_process|Node|sweep|collect|award|drop_count|for |while |match ' <<< "$code"; then
	fail "the emission restates a rule, folds a seed, holds a collection, listens, or asks another step"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '.new(' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'return RiftExperienceMote.new(_base_experience).problem()' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'field.spawn_drop(defeat_position, _base_experience)' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'spawn_drop(' <<< "$code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -cF '_emitted = true' <<< "$code" | tr -d ' ')" != "1" ]]; then
	fail "the emission does not make one temporary mote, ask for one untransformed drop, and mark itself emitted, each in one place"
	shape=$((shape + 1))
fi
if grep -qE ': RiftExperienceMote|= RiftExperienceMote|return RiftExperienceMote\.new\([^)]*\)$|return field$' <<< "$code"; then
	fail "the emission keeps or hands out the temporary mote or the field"
	shape=$((shape + 1))
fi
# THE ORDER, BY LINE: emitted, then the amount, then no field, then an incoherent
# field, then ownership, then the one drop, then its refusal, then — only then —
# the mark.
emitted_line="$(grep -nF 'if _emitted:' "$PROJECT_DIR/$EMISSION" | cut -d: -f1)"
invalid_line="$(grep -nF 'var invalid: String = problem()' "$PROJECT_DIR/$EMISSION" | cut -d: -f1)"
null_line="$(grep -nF 'if field == null:' "$PROJECT_DIR/$EMISSION" | cut -d: -f1)"
incoherent_line="$(grep -nF 'var incoherent: String = field.problem()' "$PROJECT_DIR/$EMISSION" | cut -d: -f1)"
owner_line="$(grep -nF 'if field.run_seed() != _run_seed:' "$PROJECT_DIR/$EMISSION" | cut -d: -f1)"
spawn_line="$(grep -nF 'var refusal: String = field.spawn_drop(' "$PROJECT_DIR/$EMISSION" | cut -d: -f1)"
refused_line="$(grep -nF 'if not refusal.is_empty():' "$PROJECT_DIR/$EMISSION" | cut -d: -f1)"
mark_line="$(grep -nF '_emitted = true' "$PROJECT_DIR/$EMISSION" | cut -d: -f1)"
order_ok=1
previous=0
for at in "$emitted_line" "$invalid_line" "$null_line" "$incoherent_line" "$owner_line" "$spawn_line" "$refused_line" "$mark_line"; do
	if [[ -z "$at" || "$at" == *$'\n'* || "$at" -le "$previous" ]]; then
		order_ok=0
		break
	fi
	previous="$at"
done
if [[ "$order_ok" != "1" ]]; then
	fail "emit_at() does not refuse emitted, invalid, no field, incoherent and another run's field, then ask for one drop, then mark (lines ${emitted_line:-?} / ${invalid_line:-?} / ${null_line:-?} / ${incoherent_line:-?} / ${owner_line:-?} / ${spawn_line:-?} / ${refused_line:-?} / ${mark_line:-?})"
	shape=$((shape + 1))
fi
if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|preload\(|load\(|get_tree|get_node|Node3D|Area3D|CollisionShape|PhysicsServer|NavigationServer|NavigationAgent|distance_to|distance_squared_to|length\(|global_position|Transform3D' \
		"$PROJECT_DIR/$EMISSION"; then
	fail "the emission reads storage, randomness, ambient engine state, physics, navigation or a node"
	shape=$((shape + 1))
fi
# Enemy content, experience balance, the OTHER experience records, and every
# accepted scan's guarded token the emission is not granted — raw, comments
# included.
if grep -qE 'Graveblade|graveblade|GRAVEBLADE|[Vv]anguard|VANGUARD|Skeleton|Mauler|Marrowshot|Tombknife|Acolyte|Cantor|Warden|Ossuary|Elite|Guardian|XP|ExperienceTable|experience_table|CharacterState|LabProgress|progression|quick_strike|died|\.tres|\.tscn|scenes/|res://|rift_experience_mote|collect_into|RiftMoteDrop|rift_mote_drop|attempt_collection|RiftMoteCollection|rift_mote_collection|RiftMotePickup|rift_mote_pickup|rift_mote_field|RiftMoteSweepResult|rift_mote_sweep_result|sweep_collection|RiftRunLevelCoordinator|RiftRunLevelUpResult|RiftLevelUp|RiftExperienceTrack|RiftExperienceReading|award_experience|open_current_offer|choose\(|next_level_coordinator|RiftRunBuild|PlayerStat|PassiveCard|card_|EXPERIENCE_GAIN|experience_gain|PICKUP_RADIUS|pickup_radius|RiftOffer|RiftLevelRequirement|requirement_for|RiftLevelOfferSeed|offer_root_seed|RiftConsumptionLedger' \
		"$PROJECT_DIR/$EMISSION"; then
	fail "the emission names enemy content, an experience record, another step of the run, or a guarded token it is not granted"
	shape=$((shape + 1))
fi
if [[ "$shape" == "0" ]]; then
	pass "three bare fields and seven functions; no arithmetic and no literal; no rule restated; one temporary mote, one untransformed drop, one mark; emitted, amount, no field, incoherent and ownership before the drop, the mark after it; no ambient read, no enemy content and no ungranted token"
fi

# EVERY PROJECT CLASS, READ FROM ITS OWN `class_name` LINE — never typed here.
declare -a project_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && project_classes+=("$name"); done \
	< <(grep -rhoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/scripts" "$PROJECT_DIR/addons" 2>/dev/null \
		| awk '{print $2}' | LC_ALL=C sort -u)
named=""
for name in "${project_classes[@]}"; do
	grep -qF "$name" "$PROJECT_DIR/$EMISSION" && named="$named$name "
done
if [[ "${#project_classes[@]}" -lt 100 ]]; then
	fail "only ${#project_classes[@]} project classes were read — the class scan may be inert"
elif [[ "$named" == "$EXPECTED_NAMED " ]]; then
	pass "of ${#project_classes[@]} project classes the emission names exactly $EXPECTED_NAMED"
else
	fail "the emission names: ${named:-nothing}"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# NOTHING THAT RUNS CREATES OR EMITS AN EMISSION.
unwired=0
for token in "RiftEnemyMoteEmission" "rift_enemy_mote_emission" "emit_at("; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$EMISSION"|*/"$EMISSION".uid) continue ;;
		esac
		# D-283: Foundation H7's Graveblade mote binding makes one emission and asks
		# it to emit once when its Graveblade dies — granted the emission's class and
		# the emitting call, never the emission's file name. Recorded in the
		# verification's per-file, per-token reader table. Nothing creates a binding.
		if [[ "$token" == "RiftEnemyMoteEmission" || "$token" == "emit_at(" ]]; then
			case "$hit" in
				*/scripts/experience/rift_graveblade_mote_binding.gd) continue ;;
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
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the emission or emits one but H7's granted binding, which nothing creates"
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
	printf 'RIFT ENEMY MOTE EMISSION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation H6 — Run-Owned One-Time Enemy Mote Emission — is\n'
	printf '  DELIVERED under D-281 and ACCEPTED and CLOSED at the run-owned one-time\n'
	printf '  enemy-mote emission mechanism level under D-282.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT ENEMY MOTE EMISSION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
