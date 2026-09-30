#!/usr/bin/env bash
# Riftwrought — Roguelite I13: Player Global-Damage Application V1 smoke checks (decision D-318).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I13 makes the accepted Power card's Global Damage live: the player holds the run build's
# normalized total, and every outgoing Hit — Quick Strike, Faultbreaker, Splinter Shot and
# Emberbolt — is evaluated through C1's own calculation path when its damage is committed. Its
# verification is a SceneTree script that loads the Gate 1E practice range and the accepted I3
# review exactly as they ship. What this script proves:
#
#   1. the new verification and the six changed production scripts parse;
#   2. every accepted file and historical evidence frame this work stands beside is byte-identical
#      to its accepted hash; nothing that runs names the harness; the verification names no file
#      under tests/ but its own and no storage path or writer; and the player's entry point has one
#      running caller, the seam — twice since Roguelite I14 (D-320): the write, and its put-back;
#   3. the pinned verification passes, proved in BOTH directions against a replay of its own log,
#      with every owed check reaching its last line, the measured lines read out of that log, zero
#      SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the accepted ones — and a run
#      that hangs is killed and FAILS;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine
#      sections, no `[autoload]`;
#   5. the third-party inventory has not moved (185 + 2 = 187);
#   6. optionally (`--shots <dir>`), rendered evidence at 1920x1080 and at the 1280x720 minimum
#      tested window, each run passing at the SAME pinned count, because the frames add no assertion;
#   7. the whole of game/ outside .godot/, .godot/ itself, every protected file outside game/ and the
#      project owner's own user:// files are byte-identical across the run.
#
# Usage, from the repository root:
#   game/tests/global_damage_live_application_smoke.sh
#   game/tests/global_damage_live_application_smoke.sh --shots docs/testing/roguelite_global_damage_live_application_evidence

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a shell evaluates an
# assignment only when execution REACHES it.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS.
reached_end=0
scratch_replay=""
scratch_warnings=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	[[ -n "$scratch_warnings" ]] && rm -rf "$scratch_warnings"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nGLOBAL DAMAGE LIVE APPLICATION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROUTE_SEED=99

# Pinned, and proved in both directions below. ONE number: the rendered evidence frames add no
# assertion, so the headless and both rendered runs must agree.
EXPECTED_CHECKS=33
EXPECTED_OWED_CHECKS=22

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# I13 extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# The only engine warnings the verification may print: a navigation bake rounding its agent values
# to the voxel grid. Both scenes print exactly these two lines from their own bakes, neither of
# which I13 touches: the accepted core loop's (accepted under D-290), and the Gate 1E practice
# range's (`foundation_skill_practice.gd`, pinned above at its pre-I13 hash) — the same 0.40 m
# agent radius and 0.20 m climb against a 0.15 m cell.
KNOWN_WARNINGS=(
	"WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
	"WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
)
# D-319 ruling 5: the allowance is by exact text AND count. Each accepted line appears exactly this many
# times per run — once per scene bake, the practice range's and the core loop's — so a run prints four
# warning lines, and a missing copy, a fifth copy of either line or any other wording fails.
EXPECTED_WARNING_EACH=2

THIS_VERIFICATION="tests/global_damage_live_application_verification.gd"
SEAM="scripts/roguelite/live_effects/rift_build_application.gd"

# The new verification, and the six production scripts Roguelite I13 changed.
PARSED_SCRIPTS=(
	"$THIS_VERIFICATION"
	"scripts/actors/prototype_player.gd"
	"scripts/combat/quick_strike_action.gd"
	"scripts/skills/first_mvp_skill_action.gd"
	"$SEAM"
	"scripts/roguelite/live_effects/rift_build_application_result.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
)

# Accepted files this work stands beside and must not edit or regenerate, each by the SHA-256
# prefix it held before the first I13 edit: the damage records, the projectile, the Skill, weapon,
# Quick Strike and Graveblade records and their scripts, C1, the cards, the run build, the
# catalogues, the level-up and offer transactions, H8, the running reviews and their scenes, the
# practice range, both actor scenes and project.godot; and every accepted I3 and I12 evidence frame,
# which stay historical and are never re-rendered here (D-297, D-317).
ACCEPTED_PREFIXES=(
	"scripts/combat/damage_event.gd|3b3185c4"
	"scripts/combat/first_mvp_damage_event.gd|b84600b0"
	"scripts/skills/first_mvp_skill_projectile.gd|33afd061"
	"scripts/skills/first_mvp_skill_data.gd|e5e11268"
	"scripts/combat/prototype_weapon_data.gd|ba616ae2"
	"scripts/items/first_mvp_weapon_record.gd|a6316cd7"
	"scripts/actors/prototype_graveblade.gd|0ae1374b"
	"scripts/combat/graveblade_data.gd|1b1daee3"
	"scripts/combat/quick_strike_data.gd|50bfabfc"
	"scripts/combat/target_acquisition.gd|bf4c14d4"
	"scripts/stats/player_stats.gd|b0be8c7c"
	"scripts/stats/player_stat_totals.gd|84f3a515"
	"scripts/stats/player_stat_value.gd|f2620acc"
	"scripts/stats/player_stat_definition.gd|cf3433c2"
	"scripts/stats/passive_card_catalogue.gd|278b30dc"
	"scripts/stats/passive_card_definition.gd|c64dcaf4"
	"scripts/runs/rift_run_build.gd|1920ae25"
	"scripts/skills/skill_support_catalogue.gd|a94f61cc"
	"scripts/levels/rift_level_up_coordinator.gd|f178c358"
	"scripts/levels/rift_run_level_coordinator.gd|b654e0a2"
	"scripts/offers/rift_offer.gd|9bc94208"
	"scripts/offers/rift_offer_composition.gd|15ef203a"
	"scripts/choices/rift_offer_choice.gd|533ee30f"
	"scripts/experience/rift_mote_runtime.gd|23c41eb2"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd|128103b4"
	# First-MVP UI J1 (D-322) moved the panel and the modal contract one for one — `61173e43` →
	# `694eb0b2` and `8d57039b` → `1cfe9c73` — moving the left-press routing into the contract.
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd|694eb0b2"
	"scripts/roguelite/roguelite_core_loop_runtime.gd|a76cec3d"
	"scripts/first_mvp/canonical_opening/foundation_skill_practice.gd|be0c3073"
	"scripts/ui/first_mvp_modal.gd|1cfe9c73"
	# First-MVP UI J6 (D-332) moved the combat HUD one for one — `0bb284a1` → `aff939f3` — so that its
	# Life and Mana fills draw the fraction their labels state.
	# First-MVP UI J7 (D-334) moved it again — `aff939f3` → `38c485cb` — so that the enemy hover Life fill
	# draws its fraction.
	# First-MVP UI J8 (D-336) moved it again — `38c485cb` → `ee485029` — so that the player resource column
	# sits wholly inside the window.
	"scripts/ui/first_mvp_combat_hud.gd|ee485029"
	"data/prototype_zero/graveblade.tres|56317f5f"
	"data/prototype_zero/honed_sword.tres|77cc713d"
	"data/prototype_zero/starter_sword.tres|5069d1a3"
	"data/prototype_zero/quick_strike.tres|76060315"
	"data/first_mvp/skills/faultbreaker.tres|d9439378"
	"data/first_mvp/skills/splinter_shot.tres|d5664fd4"
	"data/first_mvp/skills/emberbolt.tres|eb8860df"
	"data/first_mvp/foundation/garrison_greatsword.tres|78af8487"
	"data/first_mvp/foundation/marrow_bow.tres|471853f1"
	"data/first_mvp/foundation/cantor_wand.tres|82d22238"
	"data/first_mvp/severed_threshold/broken_watch/starting_sword.tres|08e97d2e"
	"scenes/roguelite/roguelite_live_effect_review.tscn|0c3c6c98"
	"scenes/roguelite/roguelite_level_up_choice_review.tscn|7038bce6"
	"scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn|3dccdaa5"
	"scenes/actors/prototype_player.tscn|3078a215"
	"scenes/actors/prototype_graveblade.tscn|752db86c"
	"project.godot|55351038"
	"../docs/testing/roguelite_live_effect_review_evidence/01_sweeping_edge_live.png|73ccb8ec"
	"../docs/testing/roguelite_live_effect_review_evidence/02_celerity_live.png|c23cf8ed"
	"../docs/testing/roguelite_live_effect_review_evidence/03_fleetness_live.png|f844767c"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/01_sweeping_edge_live.png|5b112d8c"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/02_celerity_live.png|82d4bbe8"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/03_fleetness_live.png|5207c56c"
	"../docs/testing/roguelite_repeated_live_effect_loop_evidence/01_fallback_offer_after_rank_two.png|0107e97a"
	"../docs/testing/roguelite_repeated_live_effect_loop_evidence/02_level_six_live_and_held_receipt.png|c01d3ab2"
	"../docs/testing/roguelite_repeated_live_effect_loop_evidence/1280x720/01_fallback_offer_after_rank_two.png|066cf550"
	"../docs/testing/roguelite_repeated_live_effect_loop_evidence/1280x720/02_level_six_live_and_held_receipt.png|7e3cf6cc"
)

# Protected outside game/, where the whole-tree fingerprint below does not reach.
PRESERVED_FILES=(
	"../CLAUDE.md"
	"../README.md"
)
for row in "${ACCEPTED_PREFIXES[@]}"; do
	PRESERVED_FILES+=("${row%%|*}")
done

SHOT_DIR=""
if [[ "${1:-}" == "--shots" && -n "${2:-}" ]]; then
	mkdir -p "$2"
	SHOT_DIR="$(cd "$2" && pwd)"
fi

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

# Every file under game/ outside .godot/, and .godot/ on its own, each as one digest.
tree_fingerprint() {
	(cd "$PROJECT_DIR" && find . -path ./.godot -prune -o -type f -print0 | LC_ALL=C sort -z \
		| xargs -0 shasum -a 256) | shasum -a 256 | cut -d' ' -f1
}
cache_fingerprint() {
	(cd "$PROJECT_DIR" && find .godot -type f -print0 | LC_ALL=C sort -z | xargs -0 shasum -a 256) \
		| shasum -a 256 | cut -d' ' -f1
}

state_fingerprint() {
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s, mtime %s' \
			"$(wc -c < "$1" | tr -d ' ')" \
			"$(shasum -a 256 "$1" | cut -d' ' -f1)" \
			"$(stat -f %m "$1")"
	else
		printf 'absent'
	fi
}

# D-201's lesson: a run that reports PASS while a script error scrolled past is not a pass.
assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found script error line(s)"
		grep -A3 -E "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# The accepted-warning rule as a pure reading of one log (D-319 ruling 5): one line per problem, and
# nothing at all when the log holds exactly EXPECTED_WARNING_EACH copies of each accepted line and no
# other warning. The replay proofs in step 3 ask this same function, so the rule they prove is the
# rule every run is held to.
warning_problems() {
	local logfile="$1" line known expected each
	while IFS= read -r line; do
		known=0
		for expected in "${KNOWN_WARNINGS[@]}"; do
			[[ "$line" == "$expected" ]] && known=1
		done
		if [[ "$known" == "0" ]]; then
			printf 'an unexpected warning: %s\n' "$line"
		fi
	done < <(grep -E "^WARNING:" "$logfile" 2>/dev/null)
	for expected in "${KNOWN_WARNINGS[@]}"; do
		each="$(grep -cxF -- "$expected" "$logfile" 2>/dev/null | tr -d ' ')"
		if [[ "$each" != "$EXPECTED_WARNING_EACH" ]]; then
			printf "'%s' %s time(s), not %s\n" "${expected#WARNING: }" "$each" "$EXPECTED_WARNING_EACH"
		fi
	done
}

# Engine ERROR lines are refused outright, and the WARNING lines must be exactly the accepted ones, each
# exactly EXPECTED_WARNING_EACH times.
assert_engine_output() {
	local what="$1" logfile="$2" errors warnings problems line
	errors="$(grep -cE "^ERROR:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$errors" == "0" ]]; then
		pass "$what produced no engine ERROR line"
	else
		fail "$what produced $errors engine ERROR line(s)"
		grep -A2 -E "^ERROR:" "$logfile" | head -20 | sed 's/^/        /'
	fi
	warnings="$(grep -cE "^WARNING:" "$logfile" 2>/dev/null | tr -d ' ')"
	problems="$(warning_problems "$logfile")"
	if [[ -z "$problems" ]]; then
		pass "$what printed $warnings engine WARNING line(s): each of the two accepted navigation-bake precision lines exactly $EXPECTED_WARNING_EACH times, and no other"
	else
		while IFS= read -r line; do
			fail "$what printed $line"
		done <<< "$problems"
	fi
}

# `/tmp` is never cleared between runs, so a file from an earlier invocation must never answer
# for this one.
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

# The three-step read the project settled on.
read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

run_verification() {
	local logfile="$1"
	shift
	perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" "$@" > "$logfile" 2>&1
}

printf 'Riftwrought — Roguelite I13: Player Global-Damage Application V1 smoke checks (D-318)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything this work must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi

tree_before="$(tree_fingerprint)"
cache_before="$(cache_fingerprint)"
tree_files="$(cd "$PROJECT_DIR" && find . -path ./.godot -prune -o -type f -print | wc -l | tr -d ' ')"
cache_files="$(cd "$PROJECT_DIR" && find .godot -type f | wc -l | tr -d ' ')"
pass "game/ fingerprinted whole: $tree_files file(s) outside .godot/, and $cache_files under .godot/"

declare -a BEFORE_HASHES
missing_preserved=0
for i in "${!PRESERVED_FILES[@]}"; do
	BEFORE_HASHES[$i]="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "${BEFORE_HASHES[$i]}" == "MISSING" ]]; then
		fail "protected file ${PRESERVED_FILES[$i]} does not exist"
		missing_preserved=$((missing_preserved + 1))
	fi
done
if [[ "$missing_preserved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected file(s) fingerprinted"
fi

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. The new verification and the six changed production scripts parse"

for relative in "${PARSED_SCRIPTS[@]}"; do
	if [[ ! -f "$PROJECT_DIR/$relative" ]]; then
		fail "$relative is missing"
		continue
	fi
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The accepted files and frames are the accepted ones; nothing that runs names the harness; one caller writes the total"

mismatched=0
for row in "${ACCEPTED_PREFIXES[@]}"; do
	relative="${row%%|*}"
	prefix="${row##*|}"
	digest="$(fingerprint "$PROJECT_DIR/$relative")"
	if [[ "$digest" != "$prefix"* ]]; then
		fail "$relative hashes ${digest:0:8}, not its accepted $prefix"
		mismatched=$((mismatched + 1))
	fi
done
if [[ "$mismatched" == "0" ]]; then
	pass "${#ACCEPTED_PREFIXES[@]} accepted files and historical frames match their SHA-256 prefixes, the 10 I3 and I12 frames among them"
fi

if grep -rlE 'global_damage_live_application' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" "$PROJECT_DIR/project.godot" 2>/dev/null | grep -q .; then
	fail "a running file or project.godot names the I13 harness"
else
	pass "no file under scripts/, scenes/, data/ or addons/, and nothing in project.godot, names the I13 harness"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -q '^extends SceneTree$' "$PROJECT_DIR/$THIS_VERIFICATION"; then
	pass "the verification is a SceneTree script and names no file under tests/ but its own"
else
	fail "the verification names another test file: ${others:-none}, or is not a SceneTree script"
fi

# DirAccess is used READ-ONLY, to list the running files the whole-project scan reads; every writer
# and storage path is refused.
if grep -qE 'user://|ConfigFile|ResourceSaver|store_string|make_dir|remove_absolute|rename_absolute|FileAccess\.open' \
		"$PROJECT_DIR/$THIS_VERIFICATION"; then
	fail "the verification names a storage path or writer"
else
	pass "the verification names no storage path or writer (its only file write is an evidence frame under --shots)"
fi

# THE PLAYER'S ONE ENTRY POINT HAS ONE CALLER, measured from outside the engine over every running
# directory: the seam. Roguelite I14 (D-320) moved its call count one for one from 1 to 2: the write,
# and its put-back when the player refuses the Maximum Life total that follows it.
callers="$(grep -rlF 'set_increased_global_damage(' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
	"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null | sed "s|^$PROJECT_DIR/||" \
	| grep -vxF 'scripts/actors/prototype_player.gd' | tr '\n' ' ' | sed 's/ $//')"
calls="$(grep -v '^[[:space:]]*#' "$PROJECT_DIR/$SEAM" | grep -oF 'set_increased_global_damage(' | wc -l | tr -d ' ')"
if [[ "$callers" == "$SEAM" && "$calls" == "2" ]]; then
	pass "the only running caller of set_increased_global_damage( is $SEAM, twice — the write and its put-back"
else
	fail "set_increased_global_damage( is called by '${callers:-nothing}' ($calls time(s) in the seam)"
fi

# --------------------------------------------------------------------------
step "3. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_global_damage_live_application_verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" --script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED"
verify_status=$?
printf '  verification exit status: %s\n' "$verify_status"
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless verification" "$verify_log"
assert_engine_output "the headless verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "GLOBAL DAMAGE LIVE APPLICATION VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log whose count moved by
# one, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_global_damage_live_application_replay)"
scratch_replay="$replay"
sed "s/GLOBAL DAMAGE LIVE APPLICATION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/GLOBAL DAMAGE LIVE APPLICATION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "GLOBAL DAMAGE LIVE APPLICATION VERIFICATION" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

# D-319 ruling 5: the warning pin must refuse replays of this run's own log with one accepted line
# removed, with a fifth copy of an accepted line, and with a reworded line — and must accept the log as
# it stands, so the three refusals cannot be a rule that refuses everything.
scratch_warnings="$(mktemp -d -t riftwrought_global_damage_warning_replays)"
awk -v target="${KNOWN_WARNINGS[0]}" '!removed && $0 == target { removed = 1; next } { print }' \
	"$verify_log" > "$scratch_warnings/fewer.log"
{ cat "$verify_log"; printf '%s\n' "${KNOWN_WARNINGS[1]}"; } > "$scratch_warnings/fifth.log"
{ cat "$verify_log"; printf '%s\n' "${KNOWN_WARNINGS[1]/loses precision/loses some precision}"; } \
	> "$scratch_warnings/reworded.log"
as_is="$(warning_problems "$verify_log")"
fewer="$(warning_problems "$scratch_warnings/fewer.log")"
fifth="$(warning_problems "$scratch_warnings/fifth.log")"
reworded="$(warning_problems "$scratch_warnings/reworded.log")"
if [[ -z "$as_is" && "$fewer" == *"1 time(s), not $EXPECTED_WARNING_EACH"* \
		&& "$fifth" == *"$((EXPECTED_WARNING_EACH + 1)) time(s), not $EXPECTED_WARNING_EACH"* \
		&& "$reworded" == *"an unexpected warning"* ]]; then
	pass "the warning pin accepts this run's own log and refuses its replays with one accepted line removed, a fifth copy added and a reworded line"
else
	fail "the warning pin did not hold: as is '${as_is}'; one removed '${fewer}'; a fifth copy '${fifth}'; reworded '${reworded}'"
fi

if grep -qE "^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi
for moved in "$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))"; do
	if grep -qE "^  $moved owed checks completed" "$verify_log"; then
		fail "the owed-set line reads '$moved'"
	fi
done

# The measurements this work exists to make, read out of the run's own log rather than restated
# here. `--` before the pattern is D-244's lesson kept. No line carrying a frame number or a count of
# drawn lines — each of which varies with the window and the clock — is listed.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the practice range foundation_skill_practice.tscn runs foundation_skill_practice.gd on the production player; no accepted suite started; 31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload]; 0 of 22 injection patterns in this harness's code
6 changed production files at their D-318 SHA-256 prefixes, four since moved to their D-320 ones, the result since to its D-321 one and the player since to its D-324 one; the player declares one stored total, 0.0, and set_increased_global_damage, increased_global_damage and outgoing_hit_damage
the entry point's only caller is [rift_build_application.gd x2], the query's only callers are [first_mvp_skill_action.gd x2, quick_strike_action.gd x1], and none but the player names the stored total
Quick Strike's release, the area release and every projectile launch ask the query before a damage record or a projectile exists; a refused answer reaches push_error and deals nothing; none restates 1 + a total
the seam covers [global_damage, skill_speed, maximum_life, movement_speed], holds [] and leaves [experience_gain, pickup_radius] to the run's own mote path
a detached player and the range's player both hold +0%; the Worn Sword's raw 100 comes back from the query as 100, C1's answer, to the last bit
nan refused: 'global_damage: the total increased is not a finite number'
inf refused: 'global_damage: the total increased is not a finite number'
-inf refused: 'global_damage: the total increased is not a finite number'
-1.0 refused: 'global_damage: a total of -1.000000 increased would make the scale 0.000000, and a scale must be positive'
-1.5 refused: 'global_damage: a total of -1.500000 increased would make the scale -0.500000, and a scale must be positive'
5 of 5 refused with C1's own reason and the total left at +0%; +25% accepted and then restored by the seam's empty build
a base of -5, nan and inf: 3 of 3 came back as C1's refusal, not as zero, the base or a clamp
the Worn Sword's raw 100 at +10%: C1 answers 110.000000000000; the release's damage record carries raw 110.000000000000 and final 110.000000000000; the Graveblade 300 -> 190.000000000000
two acquisitions sum to +20% in C1's accumulator and in the build, applied once: 120.000000000000, which displays as 120, not 121; applied again, the same description and the same +20%
Worn Sword 100 -> 110.000000000000; Honed Sword 150 -> 165.000000000000; Worn Sword again -> 110.000000000000: 3 of 3 hits exactly C1's answer, the total +10% throughout, no application between them
the two weapon records still read 100 and 150
the Garrison Greatsword's 120 at the record's own scale is a base of 192.000000000000; at +10% C1 answers 211.200000000000 (applied twice it would be 232.320000000000)
one release: 3 damage record(s) on 3 Graveblade(s), 3 of them exactly C1's answer in raw, final and Life lost, all Physical
the Marrow Bow's 110 at the record's own scale is a base of 110.000000000000; the projectile stored 121.000000000000 at launch — C1's answer — and its one Hit dealt 121.000000000000 Physical: Life 300 -> 179.000000000000
Emberbolt's own 130, not the Cantor Wand's 60; the projectile stored 143.000000000000 at launch — C1's answer — and its one Hit dealt 143.000000000000 Fire: Life 300 -> 157.000000000000
launched at +10% storing 121.000000000000; +20% applied through the seam while it flew; it still stored 121.000000000000 and dealt 121.000000000000 on impact
the next projectile launched at +20% and stored and dealt 132.000000000000 — C1's answer at the new total
the player holds +20%; the Graveblade's one Hit carried raw 125.000000000000 and final 125.000000000000 — its record's own 125 — and Life went 500 -> 375
an Emberbolt launched at +20% stored 156.000000000000; the seam's empty build restored +0% while it flew; it still stored 156.000000000000 and dealt 156.000000000000
12 of 12 damage records made earlier in this range still carry exactly what they carried; every weapon, Skill, Quick Strike and Graveblade record reads as it did when the range loaded
the next Emberbolt stored and dealt its own 130, and the next Quick Strike the Worn Sword's own 100, each to the last bit
a success missing its Global Damage derivation: 'a derived application is missing its Global Damage derivation'
a derivation naming another stat: 'the Global Damage derivation names maximum_life'
a copied total that is not the build's: 'the Global Damage total +20% is not the build's own +10%'
a copied value a millionth off C1's answer: 'the Global Damage value 110.000001000000 is not C1's own answer 110.000000000000'
a refusal carrying a Global Damage derivation: 'a refused application must carry no partial value'
a refusal carrying a Global Damage total: 'a refused application must carry no partial value'
a written result stripped of its derivation: 'a derived application is missing its Global Damage derivation'
a clean derivation and a clean written result answer ''; 2 of 2 seam refusals carry no Global Damage derivation and a +0% total
one Power's applied line: 'damage 100 → 110'; beside Vitality: ["damage 100 → 110", "Maximum Life 500 → 575 · Life preserved at 100%"], both live and nothing held; an empty build: no damage line; the description reads 'quick_strike; skill speed +0% -> 0.800000000 s; movement +0% -> 5.000 m/s; global damage +10% -> 110.000 from 100.000;
over a player already holding +20% (outgoing 120.000000000000), deriving one Power answered 110.000000000000 from the raw 100 — C1's answer — not 132.000000000000
one Power applied twice leaves +10%; apply() tests the derivation, then writes the total, then refuses if the player refused it, then writes every other covered value
after Level 1, a real controller press into the Elite 1.2 m ahead: one damage record of raw 100.000000000000 and final 100.000000000000 — the Worn Sword's own — Life 600 -> 500
behind the standing Level 5 fallback offer, after 4 applications: +0% held, and the damage reading is 100.000000000000
Level 1, opened on its own: the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line
Level 2, opened on its own: the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line
Level 3, opened on its own with 525 banked: the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line
Level 4, in place of Level 3's in the same call: the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line
Level 5 fallback, in place of Level 4's in the same call: the receipt shows only 'Level-up offer open — choose one of the three cards.'; no live line
in the Enter press's own call — physics and process frames unchanged — the run's whole build went through the seam a fifth time: +10% held, and the reading for the Worn Sword's 100 is 110.000000000000, C1's answer
5 applications, 0 refusals; the panel closed at Rift level 6; the record granted [card_power] as the passive fallback
| Support — Power (+10% Global Damage)
| Passive fallback from Combat and Defence
| Rift level 5 → 6 · 0 XP carried over
| Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target / damage 100 → 110
"Live now —" appears once; the damage is its second line; no held heading, and no card named in it
the Level 6 Power receipt: 6 lines on screen inside the review panel, 0 overlapping, clear of the centre, smallest 12 px; not paused
3.20 m ahead, inside rank two's 3.65 m: the real press wound up without stepping and its one damage record carried 110.000000000000 — C1's answer — Elite 500 -> 390
a 300-Life Graveblade 1.2 m ahead, three real presses: 300 -> 190 -> 80 -> 0 — 3 of 3 exactly C1's answer; 110 damage still takes three hits
an Experience Mote collected after Power paid exactly its 25: Global Damage moves no experience
movement 5.0 m/s, action time 0.80 s, reach 3.65 m, arc 260°, cone 155°, 1 target(s), Global Damage +10%, damage 110.000000000000 -> movement 5.0 m/s, action time 0.80 s, reach 1.65 m, arc 100°, cone 65°, 1 target(s), Global Damage +0%, damage 100.000000000000
restored by the seam from an empty build: quick_strike; skill speed +0% -> 0.800000000 s; movement +0% -> 5.000 m/s; global damage +0% -> 100.000 from 100.000; maximum life +0% -> 500.000 from 500.000; life 500.000/500.000 -> 500.000/500.000; reach 1.65 m, arc 100 deg, cone 65 deg, 1 target(s); supports []; run path []; deferred []; committed
B began at Rift level 1, run seed 99: an empty build, card_power 0, +0% held; movement 5.0 m/s, action time 0.80 s, reach 1.65 m, arc 100°, cone 65°, 1 target(s), Global Damage +0%, damage 100.000000000000
| Combat and Defence — Vitality (+15% Maximum Life)
| Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target / Maximum Life 500 → 575 · Life preserved at 100%
Maximum Life 500 -> 575 and Life 500 -> 575, its fraction kept; the Life display reads 'Life — 575 / 575'; Global Damage +0%; the damage reading 100.000000000000, the raw base
the Level 6 Vitality receipt: 5 lines on screen inside the review panel, 0 overlapping, clear of the centre, smallest 12 px; not paused
13 practice uses, 5 real Quick Strike presses, 28 builds staged through the seam in the practice range, 2 expeditions (1 given seed 99 again by staging), 11 fixture Graveblades registered and killed, 10 applications and 4 restorations made by the review
MEASURED

# --------------------------------------------------------------------------
step "4. project.godot is untouched"

project_godot="$PROJECT_DIR/project.godot"
actions="$(sed -n '/^\[input\]/,/^\[layer_names\]/p' "$project_godot" | grep -cE '^[a-zA-Z_0-9]+=')"
if [[ "$actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "the InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions"
else
	fail "the InputMap declares $actions actions, not $EXPECTED_INPUT_ACTIONS"
fi
main_scene="$(grep -oE 'run/main_scene="[^"]+"' "$project_godot" | head -1 | sed -E 's/run\/main_scene="([^"]+)"/\1/')"
if [[ "$main_scene" == "$EXPECTED_MAIN_SCENE" ]]; then
	pass "the entrypoint is still $EXPECTED_MAIN_SCENE"
else
	fail "the entrypoint is '$main_scene', not $EXPECTED_MAIN_SCENE"
fi
sections="$(grep -oE '^\[[a-z_]+\]$' "$project_godot" | tr -d '[]' | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$sections" == "$EXPECTED_SECTIONS" ]]; then
	pass "the same nine sections, no new one"
else
	fail "project.godot's sections are '$sections'"
fi
if grep -q '^\[autoload\]' "$project_godot"; then
	fail "an [autoload] section was added"
else
	pass "there is still no [autoload]"
fi

# --------------------------------------------------------------------------
step "5. The third-party inventory has not moved — I13 extracts nothing"

payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' 2>/dev/null | wc -l | tr -d ' ')"
maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
		"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && maps=$((maps + 1))
done
total=$((payloads + maps))
printf '  arithmetic: %d payload(s) + %d source map(s) = %d\n' "$payloads" "$maps" "$total"
if [[ "$payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" && "$total" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "still $EXPECTED_THIRD_PARTY_PAYLOADS + $maps = $EXPECTED_THIRD_PARTY, unchanged"
else
	fail "the third-party inventory is $payloads + $maps = $total, not $EXPECTED_THIRD_PARTY_PAYLOADS + 2 = $EXPECTED_THIRD_PARTY"
fi

# --------------------------------------------------------------------------
step "6. Rendered evidence"

if [[ -n "$SHOT_DIR" ]]; then
	for resolution in 1920x1080 1280x720; do
		target="$SHOT_DIR"
		[[ "$resolution" == "1280x720" ]] && target="$SHOT_DIR/1280x720"
		mkdir -p "$target"
		shots_log="/tmp/riftwrought_global_damage_live_application_shots_$resolution.log"
		run_verification "$shots_log" --path "$PROJECT_DIR" --resolution "$resolution" \
			--script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED" --shots "$target"
		shots_status=$?
		printf '  %s verification exit status: %s\n' "$resolution" "$shots_status"
		assert_log_is_fresh "$shots_log"
		assert_no_script_error "the $resolution rendered run" "$shots_log"
		assert_engine_output "the $resolution rendered run" "$shots_log"
		rendered_count="$(read_check_count "GLOBAL DAMAGE LIVE APPLICATION VERIFICATION" "$shots_log")"
		if [[ "$shots_status" == "0" && "$rendered_count" == "$EXPECTED_CHECKS" ]]; then
			pass "the $resolution rendered run exits 0 at the same pinned $EXPECTED_CHECKS checks"
		else
			fail "the $resolution rendered run exits $shots_status at ${rendered_count:-no} checks, not $EXPECTED_CHECKS"
			grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
		fi
		measured_here=0
		for panel_line in "the Level 6 Power receipt: 6 lines on screen inside the review panel, 0 overlapping, clear of the centre" \
				"the Level 6 Vitality receipt: 5 lines on screen inside the review panel, 0 overlapping, clear of the centre"; do
			grep -qF -- "$panel_line" "$shots_log" && measured_here=$((measured_here + 1))
		done
		if [[ "$measured_here" == "2" ]]; then
			pass "at $resolution both Level 6 receipts are on screen, inside the review panel and unobstructed"
		else
			fail "at $resolution only $measured_here of 2 on-screen measurements were reported"
		fi
		grep -oE "the Level 6 [A-Za-z]+ receipt: the live line's logical lines are drawn as [0-9]+ lines" "$shots_log" \
			| sed "s/^/  at $resolution /"
		shots=0
		for stem in 01_level_six_power_damage_live 02_level_six_vitality_held; do
			frame="$target/$stem.png"
			if [[ -f "$frame" && "$(stat -f %m "$frame")" -ge "$RUN_STARTED_AT" && "$(wc -c < "$frame" | tr -d ' ')" -gt 20000 ]]; then
				shots=$((shots + 1))
			else
				fail "$stem.png was not freshly captured at $resolution"
			fi
		done
		if [[ "$shots" == "2" ]]; then
			pass "both evidence frames freshly captured into $target"
		fi
	done
else
	printf '  skipped (pass --shots <dir> to render evidence)\n'
fi

# --------------------------------------------------------------------------
step "7. Nothing under game/ moved, every protected file is byte-identical, and the owner's files are untouched"

tree_after="$(tree_fingerprint)"
cache_after="$(cache_fingerprint)"
if [[ "$tree_after" == "$tree_before" ]]; then
	pass "game/ outside .godot/ is byte-identical across the run: $tree_files file(s), the run wrote nothing there"
else
	fail "a file under game/ outside .godot/ changed during this run"
fi
if [[ "$cache_after" == "$cache_before" ]]; then
	pass ".godot/ is byte-identical across the run: $cache_files file(s)"
else
	fail ".godot/ changed during this run"
fi

changed=0
for i in "${!PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "$after" != "${BEFORE_HASHES[$i]}" ]]; then
		fail "${PRESERVED_FILES[$i]} CHANGED during this run"
		changed=$((changed + 1))
	fi
done
if [[ "$changed" == "0" && "$missing_preserved" == "0" ]]; then
	pass "all ${#PRESERVED_FILES[@]} protected files are byte-identical"
fi

settings_after="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_after="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_after="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
if [[ "$settings_after" == "$settings_before" && "$lab_after" == "$lab_before" \
		&& "$character_after" == "$character_before" ]]; then
	pass "the project owner's own prototype_settings.cfg, prototype_zero.cfg and riftwrought_character.cfg are unchanged"
else
	fail "a file in the project owner's own user:// directory changed during this run"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'GLOBAL DAMAGE LIVE APPLICATION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; game/ and %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite I13 — Player Global-Damage Application V1 is DELIVERED under D-318 and ACCEPTED and\n'
	printf '  CLOSED at the player-owned global outgoing-Hit damage application mechanism level under\n'
	printf '  D-319.\n'
	reached_end=1
	exit 0
else
	printf 'GLOBAL DAMAGE LIVE APPLICATION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
