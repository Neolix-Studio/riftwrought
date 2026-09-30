#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation F1 smoke checks: ranked support ownership.
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# F1 is a STATE EXTENSION to two already-accepted pure-logic scripts and adds no
# file of its own to `scripts/`. It adds no scene, no resource, no asset, no
# `.tres`, no InputMap action and no entrypoint change; it writes nothing to
# disk; it changes no gameplay value; and NOTHING THAT RUNS CALLS IT — there is
# no rank selection, no continuation policy, no rank effect, no level-up and no
# persistence, and the verification proves that by scanning every project file
# under `scripts/`, `scenes/`, `data/` and `addons/`, plus `project.godot`, and
# requiring that not one of them calls any of the six new members. Rerunning
# Gates A-F, 1A-1E, the Zone Composer or the three roguelite reviews to check an
# unwired value would be verification theatre over work that cannot have reached
# them.
#
# WHICH ACCEPTED SUITES THIS WORK OWES A RERUN, AND WHICH IT DOES NOT.
# F1 edits exactly two production files, so the accepted suites that SCAN,
# PROTECT or EXERCISE one of them are re-run by their own runners at their own
# pinned counts: B (223), D1 (447), D2 (259), D3 (571), E1 (277) and E2 (494).
# **Foundations A, C1, C2 and C3 are deliberately NOT re-run.** Foundation A
# names `acquired_supports.gd` only in a list of paths it EXCLUDES from its
# inertness scan, and asserts nothing about that file's contents; C1 and C2 each
# grant `rift_run_build.gd` exactly one class in a per-file reader allowlist. No
# path moved and no granted class moved, so none of the four can see this work —
# which is the same property, stated the same way, that D-236 recorded when it
# declined to rerun Foundation A.
#
# ONLY D2's HARNESS MOVED, AND IT MOVED ONE FOR ONE. Its method pin gained the
# three new member names inside the SAME single assertion, and its deferred-token
# list traded the blanket `"rank"` — which F1 makes false for that file by
# authorization — for the three balance concepts F1 still excludes. **D2's count
# does not move: it is still 259.**
#
# What this script proves:
#
#   1. both extended scripts and this suite parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line;
#   3. neither extended record names a concrete Skill, support, card, catalogue
#      or presentation label, neither reads storage, a random source or ambient
#      engine state, the run-build state still performs no percentage arithmetic
#      of its own, and NOTHING in the project calls any of the six new members;
#      checked in the shell as well as in the engine, because a scan that only
#      ever runs inside the thing it audits is one process away from proving
#      nothing;
#   4. `scripts/skills/` and `scripts/runs/` hold exactly the scripts they should
#      and no stray probe beside them — F1 adds no production file, so any new
#      one is a file nobody meant to ship;
#   5. the twenty-five files this work could conceivably have disturbed are
#      BYTE-IDENTICAL ACROSS THE RUN — `project.godot` and the accepted mechanism
#      scripts of Foundations A, B, C1, C2, C3, D1, D3, E1 and E2.
#
# THE TWO EXTENDED FILES ARE DELIBERATELY NOT IN THAT PRESERVED LIST, because F1
# edits them on purpose. Every accepted mechanism BESIDE them is in the list and
# is untouched.
#
# Usage, from the repository root:
#   game/tests/ranked_support_ownership_smoke.sh

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
	local status=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRANKED SUPPORT OWNERSHIP SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$status"
		exit 1
	fi
	exit "$status"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/ranked_support_ownership_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=395

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added —
# reporting a failure whose text is the correct answer.
EXPECTED_OWED_CHECKS=16

CHANGED_SCRIPTS=(
	"scripts/skills/acquired_supports.gd"
	"scripts/runs/rift_run_build.gd"
	"tests/ranked_support_ownership_verification.gd"
)

# The two files F1 extends. Neither may name a Skill, a support, a card, either
# catalogue or a presentation label; neither may store, randomise or read ambient
# state.
STATE_SCRIPTS=(
	"scripts/skills/acquired_supports.gd"
	"scripts/runs/rift_run_build.gd"
)

# The six member names F1 introduces. Nothing that runs may call any of them.
F1_MEMBERS=(
	"rank_for("
	"increase_rank("
	"total_ranks("
	"rank_support("
	"support_rank_for("
	"total_support_ranks("
)

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. These are the files this
# work could conceivably have disturbed: the project settings and every accepted
# mechanism script of the foundations F1 stands beside. The two files F1 extends
# are deliberately absent — this work edits them.
PRESERVED_FILES=(
	"project.godot"
	"scripts/skills/skill_tags.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/support_eligibility.gd"
	"scripts/skills/skill_support_catalogue.gd"
	"scripts/skills/support_definition.gd"
	"scripts/skills/support_selection.gd"
	"scripts/skills/support_selection_result.gd"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_selection.gd"
	"scripts/stats/passive_card_selection_result.gd"
	"scripts/offers/rift_offer.gd"
	"scripts/offers/rift_offer_composition.gd"
	"scripts/choices/rift_offer_choice.gd"
	"scripts/choices/rift_offer_choice_result.gd"
	"scripts/choices/rift_consumption_ledger.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
)

# The exact scripts each touched directory holds. F1 adds no production file, so
# a name that is not on one of these lists is a file nobody meant to ship — and
# it would be invisible to every scan above that filters on a known path.
SKILLS_SCRIPTS=(
	acquired_supports.gd
	first_mvp_active_bindings.gd
	first_mvp_skill_action.gd
	first_mvp_skill_data.gd
	first_mvp_skill_library.gd
	first_mvp_skill_projectile.gd
	skill_support_catalogue.gd
	skill_tag_profile.gd
	skill_tags.gd
	support_definition.gd
	support_eligibility.gd
	support_selection.gd
	support_selection_result.gd
)
EXPECTED_SKILLS_SCRIPTS=13

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

printf 'Riftwrought — Roguelite Foundation F1: ranked support ownership\n'
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
step "1. Every changed script parses"
for script in "${CHANGED_SCRIPTS[@]}"; do
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
verify_log="/tmp/riftwrought_ranked_support_ownership_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless ranked support ownership verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RANKED SUPPORT OWNERSHIP VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one.
#
# THE NEGATIVE DIRECTION MUST READ THE MOVED NUMBER, NOT MERELY "NOT THE PINNED
# ONE". A bare `!=` is satisfied by the empty string, so on any run where the
# verification never printed its PASS line — exactly the runs where a broken
# suite needs catching — the substitution is a no-op, both reads come back
# empty, and the guard reports PASS while proving nothing at all.
replay="$(mktemp -t riftwrought_ranked_support_ownership_replay)"
scratch_replay="$replay"
sed "s/RANKED SUPPORT OWNERSHIP VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RANKED SUPPORT OWNERSHIP VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RANKED SUPPORT OWNERSHIP VERIFICATION" "$replay")"
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
# rather than restated here.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
a new record and a new run build: 0 pairs, 0 ranks, 0 Skills; absent reports rank 0
first acquisition: count 1, rank 1, total ranks 1, at the record and the run build
a duplicate is refused at rank 1 AND at rank 3; neither rank moved
one pair raised twice: 1 -> 2 -> 3; count stays 1; the listing never moved
3 absent-pair refusals at the run build and 3 at the record; 0 ghost pairs created
5 blank-identifier rank refusals and 5 acquisition refusals; the state never moved
one support on 2 Skills: ranks 3 and 2; two supports on 1 Skill: ranks 2 and 2
3 distinct pairs at ranks 1 / 2 / 4 = 7 total ranks; the two counts are not the same
4 acquisition orders x 4 ranking orders: 0 listing drift, 0 state drift
ranks 1 / 3 / 5 duplicated exactly; 6 mutations across both directions moved nothing
a rank-4 pair released: 3 pairs / 7 ranks -> 2 pairs / 3 ranks; re-acquired at rank 1
6 raises: 6 stat totals, 6 card counts and every card identity unchanged
ranks 1 / 2 / 3 / 7: the held pair is unreachable across all 600 tickets each time
and the exhaustion reason still counts 2 PAIRS while the record holds 8 ranks
the accepted acquisition, refusal and listing behaviour is unchanged at 2 pairs
1000 ordinary raises each stepped by exactly 1; the refusal branch is pinned
STATED LIMITATION: the ceiling refusal is NOT driven behaviourally, because
the rank increase is staged; that staging is DEFENCE IN DEPTH and is pinned
15 + 24 methods and 1 + 3 fields pinned, every field private, 0 live maps returned
19 refusals were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Neither record names anything concrete, and nothing calls F1"
ambient=0
for script in "${STATE_SCRIPTS[@]}"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess' "$PROJECT_DIR/$script"; then
		fail "$script names a storage path or a writer"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'randi|randf|randomize|RandomNumberGenerator|rand_from_seed' "$PROJECT_DIR/$script"; then
		fail "$script reads a global random source"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'Time\.|OS\.|Engine\.|ProjectSettings|InputMap' "$PROJECT_DIR/$script"; then
		fail "$script reads ambient engine state"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'QuickStrike|quick_strike|PrototypePlayer|PassiveEffects|RogueliteUpgrade|FirstMvpSkill|Graveblade' "$PROJECT_DIR/$script"; then
		fail "$script names a concrete class"
		ambient=$((ambient + 1))
	fi
	# A rank record is handed the identifiers it counts. Naming a catalogue would
	# make a generic mechanism the shipped set's own.
	if grep -qE 'PassiveCardCatalogue|SkillSupportCatalogue|card_power|card_celerity|card_vitality|card_fleetness|card_insight|card_magnetism|reaching_edge|sweeping_edge' "$PROJECT_DIR/$script"; then
		fail "$script names a catalogue, a card or a support"
		ambient=$((ambient + 1))
	fi
	if grep -qE 'display_name|base_weight' "$PROJECT_DIR/$script"; then
		fail "$script reads a presentation name or an offer weight"
		ambient=$((ambient + 1))
	fi
	# A rank RECORDS PROGRESSION AND APPLIES NOTHING: no per-rank value, no
	# multiplier, no effect, and no gameplay ceiling or diminishing return.
	if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$script" | grep -qE 'rank_cap|max_rank|maximum_rank|diminish|multiplier'; then
		fail "$script carries a rank cap, a diminishing return or a per-rank multiplier"
		ambient=$((ambient + 1))
	fi
done
# D2's own accepted property, restated here because F1 edited that file: the
# run-build state computes no percentage of its own. The comment lines are
# stripped first — the file's header says in plain English that it computes none,
# and a scan that cannot tell the promise from the breach is worthless.
if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/scripts/runs/rift_run_build.gd" | grep -qE '[*/]'; then
	fail "the run-build state multiplies or divides"
	ambient=$((ambient + 1))
fi
if grep -vE '^[[:space:]]*#' "$PROJECT_DIR/scripts/runs/rift_run_build.gd" | grep -qE '[0-9]\.[0-9]'; then
	fail "the run-build state carries a floating-point literal"
	ambient=$((ambient + 1))
fi
if [[ "$ambient" == "0" ]]; then
	pass "the ${#STATE_SCRIPTS[@]} extended scripts store nothing, randomise nothing, read no ambient state, name no catalogue or label, and carry no rank cap or per-rank value"
fi

# NOTHING THAT RUNS CALLS F1, measured a second time from outside the engine.
#
# IT ASSERTS A FLOOR ON WHAT IT SEARCHED, WHICH IS THE WHOLE DIFFERENCE BETWEEN
# this and a scan that proves nothing. `grep -rl` over a directory that does not
# exist — a renamed tree, a PROJECT_DIR resolved one level high — returns nothing
# and looks exactly like a clean result.
searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# THE ONE AUTHORIZED CALLER, AND THE EXACT TWO MEMBERS IT MAY CALL (Foundation
# F3, D-255). The accepted three-lane offer composer freezes the rank transition its
# support lane offers, and it MEASURES that transition by staging the decided
# operation on a private duplicate of the supplied acquisition record. Reading a
# rank and applying the decided operation is the whole of that; `total_ranks(`,
# the run-build rank raise and both run-build readings are still refused to it
# here, exactly as they are refused to every other file.
# IT IS A LIST OF ROWS RATHER THAN ONE PATH SINCE FOUNDATION F4 (D-257), AND THE
# GENERALIZATION IS THE POINT. A single `AUTHORIZED_CALLER` could only ever
# exempt one file, so a second authorized caller would have had to be exempted by
# widening the MEMBER list for everybody — which is not a narrower boundary, it is
# a much wider one. Each row is `path|member,member`, and a member is exempt only
# for the path it is written beside.
#
# The composer freezes a transition by staging it on a private duplicate
# (`rank_for(`, `increase_rank(`). The choice transaction CONSUMES the frozen
# progression through the run build (`support_rank_for(`, `rank_support(`), and
# the choice result re-asks the build it carries (`support_rank_for(`). The
# substring `rank_for(` rides along with `support_rank_for(` and is granted with
# it; neither choice file may name `AcquiredSupports` at all, which the Foundation
# D3 suite asserts, so the ride-along reaches nothing. `total_ranks(` is granted
# to nobody. `total_support_ranks(` is granted to the transaction alone since
# Roguelite Foundation I8 (D-308): taking a passive-fallback Support lane reads the
# run build's rank sum before and after the acquisition to prove no rank moved.
AUTHORIZED_ROWS=(
	"scripts/offers/rift_offer_composition.gd|rank_for(,increase_rank("
	"scripts/choices/rift_offer_choice.gd|support_rank_for(,rank_support(,rank_for(,total_support_ranks("
	"scripts/choices/rift_offer_choice_result.gd|support_rank_for(,rank_for("
	# D-295: the run-build application seam reads the rank a held pair is at, and
	# nothing else of F1; `rank_for(` rides along with `support_rank_for(`.
	"scripts/roguelite/live_effects/rift_build_application.gd|support_rank_for(,rank_for("
	# D-300: the accepted weighted selector's rank-increase draw reads the rank a held
	# pair is at, to exclude a pair at its maximum; it raises, sums and refunds nothing.
	"scripts/skills/support_selection.gd|rank_for("
)

# How many (path, member) exemptions the rows above declare, computed from the
# rows rather than typed, so a row added without a use is caught below.
EXPECTED_AUTHORIZED_HITS=0
for row in "${AUTHORIZED_ROWS[@]}"; do
	IFS=',' read -r -a row_members <<< "${row#*|}"
	EXPECTED_AUTHORIZED_HITS=$((EXPECTED_AUTHORIZED_HITS + ${#row_members[@]}))
done

called=0
authorized_hits=0
for member in "${F1_MEMBERS[@]}"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/scripts/skills/acquired_supports.gd|*/scripts/runs/rift_run_build.gd)
				continue ;;
		esac
		granted=0
		for row in "${AUTHORIZED_ROWS[@]}"; do
			row_path="${row%%|*}"
			case "$hit" in
				*/"$row_path") ;;
				*) continue ;;
			esac
			IFS=',' read -r -a row_members <<< "${row#*|}"
			for row_member in "${row_members[@]}"; do
				[[ "$member" == "$row_member" ]] && granted=1
			done
		done
		if [[ "$granted" == "1" ]]; then
			authorized_hits=$((authorized_hits + 1))
			continue
		fi
		fail "$(basename "$hit") calls $member"
		called=$((called + 1))
	done < <(grep -rlF "$member" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	# An [autoload] entry loads a class without any script naming it.
	if grep -qF "$member" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $member"
		called=$((called + 1))
	fi
done
# A GRANT THAT CANNOT FAIL IS NOT A BOUNDARY: every exemption above must actually
# be used, or it is protecting nothing while looking exactly like protection.
if [[ "$authorized_hits" != "$EXPECTED_AUTHORIZED_HITS" ]]; then
	fail "the ${#AUTHORIZED_ROWS[@]} authorized callers use $authorized_hits of the $EXPECTED_AUTHORIZED_HITS exemptions they are granted"
	called=$((called + 1))
fi
if [[ "$called" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot calls any of the ${#F1_MEMBERS[@]} new members, except the ${#AUTHORIZED_ROWS[@]} authorized callers' $EXPECTED_AUTHORIZED_HITS exemptions"
fi

# --------------------------------------------------------------------------
step "4. The two touched directories hold exactly what they should"
unexpected=0
while IFS= read -r entry; do
	base="$(basename "$entry")"
	case "$base" in
		*.uid) continue ;;
	esac
	known=0
	for known_script in "${SKILLS_SCRIPTS[@]}"; do
		[[ "$base" == "$known_script" ]] && known=1
	done
	if [[ "$known" == "0" ]]; then
		fail "scripts/skills/ holds the unexpected file $base"
		unexpected=$((unexpected + 1))
	fi
done < <(find "$PROJECT_DIR/scripts/skills" -type f 2>/dev/null)
skills_count="$(find "$PROJECT_DIR/scripts/skills" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$skills_count" != "$EXPECTED_SKILLS_SCRIPTS" ]]; then
	fail "scripts/skills/ holds $skills_count scripts, not $EXPECTED_SKILLS_SCRIPTS"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/skills/ holds exactly its $EXPECTED_SKILLS_SCRIPTS scripts and their uid files"
fi

runs_unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_run_build.gd|rift_run_build.gd.uid)
			continue ;;
	esac
	fail "scripts/runs/ holds the unexpected file $(basename "$entry")"
	runs_unexpected=$((runs_unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/runs" -type f 2>/dev/null)
runs_count="$(find "$PROJECT_DIR/scripts/runs" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$runs_count" != "1" ]]; then
	fail "scripts/runs/ holds $runs_count scripts, not 1"
elif [[ "$runs_unexpected" == "0" ]]; then
	pass "scripts/runs/ holds exactly the one script and its uid file"
fi

# --------------------------------------------------------------------------
step "5. Nothing that already existed changed"
index=0
moved=0
for file in "${PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/$file")"
	if [[ "$after" != "${before_prints[$index]}" ]]; then
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
	printf 'RANKED SUPPORT OWNERSHIP SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation F1 — Ranked Support Ownership — is DELIVERED under\n'
	printf '  D-251 and ACCEPTED and CLOSED at the temporary ranked-support state\n'
	printf '  mechanism level under D-252.\n'
	reached_end=1
	exit 0
else
	printf 'RANKED SUPPORT OWNERSHIP SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
