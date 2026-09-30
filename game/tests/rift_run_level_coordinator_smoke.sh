#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation G4 smoke checks: repeated run-level
# coordination (decision D-269).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation G4 adds TWO pure-logic scripts under `scripts/levels/` — a run-level
# coordinator holding one run seed and one current one-level lifecycle, and the
# run-level record of one choice — plus one copying method, `duplicated()`, on the
# accepted one-level receipt. No scene, no resource, no asset, no InputMap action,
# no entrypoint change, nothing written to disk, and NOTHING THAT RUNS CALLS IT.
#
# It asks the accepted curve (G1) for each level's requirement, the accepted
# derivation (G2) for each level's root seed, the accepted one-level coordinator
# (E2) to open and resolve each offer, and the accepted continuation seam (G3) for
# each successor — once per successful choice, one level per explicit choice.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT COMPOSES. Accepted suites whose files or
# allowlists G4 moved one for one — E2, F5 and G3 for the receipt's pin and the
# shared directory; G1 and G2, whose classes it names; A, B, C2, D2, D3 and E1,
# whose reader tables gained one row for the new coordinator — are each rerun by
# their own runners at their own unchanged counts.
#
# What this script proves:
#
#   1. the changed and new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log;
#   3. from outside the engine: the coordinator holds two fields and performs no
#      arithmetic; it asks the continuation once and never builds a lifecycle
#      through `with_state()`; G1 and G2 — whose class names are READ from their
#      own `class_name` lines — are named outside their own directories by the
#      two G4 files and by nothing else; nothing that runs names either G4 class;
#      and the verification names no file under `tests/` but its own;
#   4. `scripts/levels/` holds exactly E2's two scripts, G4's two, and their uid
#      files;
#   5. the files this work could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_run_level_coordinator_smoke.sh

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
		printf '\nRIFT RUN LEVEL COORDINATOR SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_run_level_coordinator_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=366

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=18

PARSED_SCRIPTS=(
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/levels/rift_level_up_result.gd"
	"tests/rift_run_level_coordinator_verification.gd"
)

COORDINATOR="scripts/levels/rift_run_level_coordinator.gd"
RESULT="scripts/levels/rift_run_level_up_result.gd"
THIS_VERIFICATION="tests/rift_run_level_coordinator_verification.gd"

G4_SCRIPTS=("$COORDINATOR" "$RESULT")
G4_CLASSES=("RiftRunLevelCoordinator" "RiftRunLevelUpResult")

# Where G1 and G2 live. Their class names are READ from these directories.
G1_DIRECTORY="scripts/level_requirements"
G2_DIRECTORY="scripts/level_seeds"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# canonical combat record, every accepted mechanism file a run composes or stands
# beside — the one-level coordinator and its receipt (which must not move again
# while this suite reads them), the track, the build, the ledger, the choice
# transaction, the offer and its composer, the acquisition record, the
# continuation decision, the three record types the open forwards, the stat
# vocabulary, G1 and G2 — the two first-MVP character scripts that own the
# project's OTHER experience concept, and the project owner's composed zone.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/support_definition.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/continuation/support_continuation.gd"
	"scripts/continuation/support_continuation_result.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/level_requirements/rift_level_requirement_curve.gd"
	"scripts/level_requirements/rift_level_requirement_reading.gd"
	"scripts/level_seeds/rift_level_offer_seed_derivation.gd"
	"scripts/level_seeds/rift_level_offer_seed_reading.gd"
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

printf 'Riftwrought — Roguelite Foundation G4: repeated run-level coordination (D-269)\n'
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
step "1. Every changed or new script parses"
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
verify_log="/tmp/riftwrought_rift_run_level_coordinator_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless run-level coordinator verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT RUN LEVEL COORDINATOR VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_run_level_coordinator_replay)"
scratch_replay="$replay"
sed "s/RIFT RUN LEVEL COORDINATOR VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT RUN LEVEL COORDINATOR VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT RUN LEVEL COORDINATOR VERIFICATION" "$replay")"
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
# measured line that begins with a dash is read by grep as an option bundle —
# and one of these does.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
run seeds 99, 0, -1, 9223372036854775807, -9223372036854775808 each read back exactly, at level=1 experience=0.0 offer=false with one unfinished lifecycle; the first requirement is 100
run seed 99, requirement/root per level: L1 100/99, L2 125/1000102, L3 150/2000105 — each asked for the current level, never supplied
375.0: L1 -> L2 with 275.0; L2 -> L3 with 150.0; L3 -> L4 with 0.0; 2 successors already met their next requirement and neither advanced nor opened until asked; level 4 requires 175 and does not open
sweeping_edge a new compatible pair, rank 0 -> 1; reaching_edge a new compatible pair, rank 0 -> 1; reaching_edge another rank of a held pair, rank 1 -> 2
3 consumed: 99, 1000102, 2000105; opening never spent a seed
card_celerity, card_magnetism, card_vitality: 3 cards, 0 pairs, no support progression on any receipt; the same levels and surplus as the Support run
run seed 10 took card_insight at level 1; 50.0 retained stayed 50.0; 4 refused awards moved nothing; the next 50 came to 105.0, equal to an independent track
2 operations refused while the offer stood; the award quoted verbatim; the same offer then paid out
1 refusal with no offer and 3 undeclared lanes refused; each carried run seed 99 at level 1, nothing moved, the same offer then paid out
a short open quoted the track's own reading; a composition refusal equalled the one-level coordinator's own; nothing moved; the open then succeeded
the one-level coordinator alone opened on spent seed 99 and refused all 3 lanes; the run refused that state before opening, left no offer and moved nothing; an unrelated spent seed opened at 99 and paid out
10 opening steps in order, each once; 5 refusing gates each return on the next line; both readings' reasons quoted; the G2 refusal is shadowed by G1 at all 3 sub-first levels asked
4 receipts copied field for field with independent identities; the record's input, store and hand-out are three separate receipts; a record of nothing is incoherent
8 contradictions caught by problem(); 9 coherent records, including refusals that know no root and G2's wrap at run seed -1, level 2
-1 -> 4294901758, 934465; 9223372036854775807 -> 2147418110, 2148418113; -9223372036854775808 -> 2147483648, 2148483651; every record kept its run seed unmasked
5 handed-out copies mutated — build, ledger, lanes, identity, requirement reading — and the run did not move
2 fields; 18 coordinator and 7 record methods pinned; the one-level receipt gained duplicated() and no field under G4, and its two Support-content fields and two readings under I9; literals rift_run_level_coordinator.gd []; rift_run_level_up_result.gd ["0"]
0 unauthorized files name G4 (6 readers granted by file and class); the continuation is called only by rift_run_level_coordinator.gd; G1 and G2 are named outside their directories only by the 2 G4 files and, for G1 alone, the experience collection review; scripts/levels/ holds 4 scripts
14 refusals and 19 successes were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Two fields, no arithmetic, one continuation, and nothing that runs calls it"
shape=0

# Comment lines are stripped: both files say in plain English what they do not
# do, and a scan that cannot tell the promise from the breach is worthless —
# Gate 1C's lesson, kept.
coordinator_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$COORDINATOR")"
fields="$(grep -E '^var ' <<< "$coordinator_code" | awk '{print $2}' | tr -d ':' | tr '\n' ' ')"
if [[ "$fields" != "_run_seed _current " ]]; then
	fail "the coordinator declares the fields: ${fields:-none}"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF 'next_level_coordinator()' <<< "$coordinator_code" | wc -l | tr -d ' ')" != "1" ]]; then
	fail "the coordinator does not ask the continuation exactly once"
	shape=$((shape + 1))
fi
if grep -qF 'with_state(' <<< "$coordinator_code"; then
	fail "the coordinator builds a lifecycle through with_state() instead of the continuation seam"
	shape=$((shape + 1))
fi
if ! grep -qF 'if _current.consumption_ledger().has_consumed(root_seed):' <<< "$coordinator_code"; then
	fail "the coordinator carries no spent-seed preflight"
	shape=$((shape + 1))
fi
for script in "${G4_SCRIPTS[@]}"; do
	code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script")"
	if grep -qE '[*/+&|^]|<<|>>' <<< "$code"; then
		fail "$script performs arithmetic or a bit operation"
		shape=$((shape + 1))
	fi
	if grep -qE '[0-9]+\.[0-9]+' <<< "$code"; then
		fail "$script carries a floating-point literal"
		shape=$((shape + 1))
	fi
	if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap' "$PROJECT_DIR/$script"; then
		fail "$script reads storage, randomness or ambient engine state"
		shape=$((shape + 1))
	fi
	if grep -qE 'BASE_REQUIREMENT|REQUIREMENT_STEP|MASK_32|LEVEL_STEP|RUN_HIGH_FOLD_STEP|quick_strike|reaching_edge|sweeping_edge|card_[a-z]+|display_name|base_weight|Catalogue' "$PROJECT_DIR/$script"; then
		fail "$script restates a formula constant or names content"
		shape=$((shape + 1))
	fi
done
if [[ "$shape" == "0" ]]; then
	pass "two fields; the continuation asked once and with_state() never; the preflight present; no arithmetic, float, ambient read, formula constant or content in either G4 script"
fi

# G1's AND G2's CLASS NAMES, READ FROM THEIR OWN FILES — never typed here.
declare -a g1_classes=() g2_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && g1_classes+=("$name"); done \
	< <(grep -hoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/$G1_DIRECTORY"/*.gd 2>/dev/null | awk '{print $2}')
while IFS= read -r name; do [[ -n "$name" ]] && g2_classes+=("$name"); done \
	< <(grep -hoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/$G2_DIRECTORY"/*.gd 2>/dev/null | awk '{print $2}')
if [[ "${#g1_classes[@]}" == "2" && "${#g2_classes[@]}" == "2" ]]; then
	pass "2 G1 and 2 G2 class names were read from their own directories"
else
	fail "${#g1_classes[@]} G1 and ${#g2_classes[@]} G2 class names were read — the wiring scan below may be inert"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# G1 IS NAMED OUTSIDE ITS DIRECTORY BY THE COORDINATOR AND THE D-288 REVIEW ONLY; G2
# BY THE TWO G4 FILES ONLY.
wiring=0
for name in "${g1_classes[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$G1_DIRECTORY"/*|*/"$COORDINATOR") continue ;;
		esac
		# D-288: the Roguelite Experience Collection Greybox Review asks G1 for the
		# current level's requirement to display it — both G1 classes, no G2 class.
		# Recorded in the verification's single wiring assertion.
		case "$hit" in
			*/scripts/roguelite/experience/roguelite_experience_collection_review.gd) continue ;;
		esac
		fail "$(basename "$hit") names the G1 class $name"
		wiring=$((wiring + 1))
	done < <(grep -rlF "$name" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	grep -qF "$name" "$PROJECT_DIR/$COORDINATOR" || { fail "the coordinator does not name $name"; wiring=$((wiring + 1)); }
done
for name in "${g2_classes[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$G2_DIRECTORY"/*|*/"$COORDINATOR"|*/"$RESULT") continue ;;
		esac
		fail "$(basename "$hit") names the G2 class $name"
		wiring=$((wiring + 1))
	done < <(grep -rlF "$name" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	for script in "${G4_SCRIPTS[@]}"; do
		grep -qF "$name" "$PROJECT_DIR/$script" || { fail "$script does not name $name"; wiring=$((wiring + 1)); }
	done
done
if grep -qF "RiftLevelRequirement" "$PROJECT_DIR/$RESULT"; then
	fail "the run-level record names a G1 class"
	wiring=$((wiring + 1))
fi
if [[ "$wiring" == "0" ]]; then
	pass "G1 is named outside its directory by the coordinator and the experience collection review alone, and G2 by the two G4 files alone"
fi

# NOTHING THAT RUNS NAMES A G4 CLASS, AND THE CONTINUATION HAS ONE CALLER.
unwired=0
for name in "${G4_CLASSES[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$COORDINATOR"|*/"$RESULT") continue ;;
		esac
		# D-271: Foundation H1's Experience Mote is collected into a run through the
		# coordinator's award contract, so it is granted the coordinator only — never
		# the run-level record. Recorded in the verification's per-file, per-class
		# reader table.
		# D-275: Foundation H3's collection attempt is handed a run and hands it to
		# the mote, so it is granted the coordinator only, for the same reason.
		# D-277: Foundation H4's drop compares a run's seed with its own and hands
		# the run to the attempt, so it is granted the coordinator only, too.
		# D-279: Foundation H5's field compares a run's seed with its own and hands
		# the run to each of its drops, so it is granted the coordinator only, too.
		# D-286: Foundation H8's Experience Mote runtime makes and owns one run and
		# sweeps its field into it, so it is granted the coordinator only, too.
		if [[ "$name" == "RiftRunLevelCoordinator" ]]; then
			case "$hit" in
				*/scripts/experience/rift_experience_mote.gd) continue ;;
				*/scripts/pickups/rift_mote_collection_attempt.gd) continue ;;
				*/scripts/pickups/rift_mote_drop.gd) continue ;;
				*/scripts/pickups/rift_mote_field.gd) continue ;;
				*/scripts/experience/rift_mote_runtime.gd) continue ;;
			esac
		fi
		# D-291: Foundation I1's lane choice on that same H8 runtime hands back the
		# run's own run-level record unchanged, so that one file — and no other — is
		# granted the record too. Recorded in the verification's reader table.
		if [[ "$name" == "RiftRunLevelUpResult" ]]; then
			case "$hit" in
				*/scripts/experience/rift_mote_runtime.gd) continue ;;
			esac
		fi
		# D-293: the Roguelite I2 level-up choice review reads the run-level record its
		# one lane choice hands back — the record only, never the coordinator. Recorded
		# in the verification's reader table.
		if [[ "$name" == "RiftRunLevelUpResult" ]]; then
			case "$hit" in
				*/scripts/roguelite/level_up/roguelite_level_up_choice_review.gd) continue ;;
			esac
		fi
		fail "$(basename "$hit") names $name"
		unwired=$((unwired + 1))
	done < <(grep -rlF "$name" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	if grep -qF "$name" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $name"
		unwired=$((unwired + 1))
	fi
done
while IFS= read -r hit; do
	case "$hit" in
		*/scripts/levels/rift_level_up_coordinator.gd|*/"$COORDINATOR") continue ;;
	esac
	fail "$(basename "$hit") names next_level_coordinator"
	unwired=$((unwired + 1))
done < <(grep -rlF "next_level_coordinator" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
	"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	unwired=$((unwired + 1))
fi
if [[ "$unwired" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names a G4 class but the coordinator's five granted readers, H1's mote, H3's attempt, H4's drop, H5's field and H8's runtime — the runtime also granted the run-level record (D-291), and the D-293 level-up choice review the record alone; the continuation's only caller is the G4 coordinator"
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
step "4. scripts/levels/ holds exactly E2's two scripts and G4's two"
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_level_up_coordinator.gd|rift_level_up_coordinator.gd.uid| \
		rift_level_up_result.gd|rift_level_up_result.gd.uid| \
		rift_run_level_coordinator.gd|rift_run_level_coordinator.gd.uid| \
		rift_run_level_up_result.gd|rift_run_level_up_result.gd.uid)
			continue ;;
	esac
	fail "scripts/levels/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/levels" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/levels" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "4" ]]; then
	fail "scripts/levels/ holds $gd_count scripts, not 4"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/levels/ holds exactly its four scripts and their four uid files"
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
	printf 'RIFT RUN LEVEL COORDINATOR SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation G4 — Repeated Run-Level Coordination — is\n'
	printf '  DELIVERED under D-269 and ACCEPTED and CLOSED at the repeated run-level\n'
	printf '  coordination mechanism level under D-270.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT RUN LEVEL COORDINATOR SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
