#!/usr/bin/env bash
# Riftwrought — Roguelite I14: Player Maximum-Life Application V1 smoke checks (decision D-320).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I14 makes the accepted Vitality card's Maximum Life live: the player holds the run build's
# normalized total and its own unmodified baseline, the one write entry point derives the new
# maximum through C1 and moves current Life with it by the one preservation rule, and the
# run-build application seam writes it atomically beside every other covered value. Its
# verification is a SceneTree script that loads the accepted I3 review exactly as it ships and
# instances the production player scene as fixtures. What this script proves:
#
#   1. the new verification and the four changed production scripts parse;
#   2. every accepted file and historical evidence frame this work stands beside is byte-identical
#      to its hash before the first I14 edit; nothing that runs names the harness; the
#      verification names no file under tests/ but its own and no storage path or writer; the
#      player's Maximum-Life entry point has one running caller, the seam, exactly once, and the
#      seam calls the Global Damage entry point exactly twice — the write and its put-back;
#   3. the pinned verification passes, proved in BOTH directions against a replay of its own log,
#      with every owed check reaching its last line, the measured lines read out of that log, zero
#      SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the accepted ones, each exactly
#      once — and a run that hangs is killed and FAILS;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine
#      sections, no `[autoload]`;
#   5. the third-party inventory has not moved (185 + 2 = 187);
#   6. optionally (`--shots <dir>`), rendered evidence at 1920x1080 and at the 1280x720 minimum
#      tested window, each run passing at the SAME pinned count, because the frames add no assertion;
#   7. the whole of game/ outside .godot/, .godot/ itself, every protected file outside game/ and the
#      project owner's own user:// files are byte-identical across the run.
#
# Usage, from the repository root:
#   game/tests/maximum_life_live_application_smoke.sh
#   game/tests/maximum_life_live_application_smoke.sh --shots docs/testing/roguelite_maximum_life_live_application_evidence

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
		printf '\nMAXIMUM LIFE LIVE APPLICATION SMOKE CHECKS: ABORTED before the end of the script\n'
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
EXPECTED_CHECKS=31
EXPECTED_OWED_CHECKS=23

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# I14 extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# The only engine warnings the verification may print: the accepted core loop's own navigation bake
# rounding its agent values to the voxel grid (accepted under D-290). I14 loads one scene, so each
# line appears exactly once per run; a missing copy, a second copy or any other wording fails.
KNOWN_WARNINGS=(
	"WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
	"WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
)
EXPECTED_WARNING_EACH=1

THIS_VERIFICATION="tests/maximum_life_live_application_verification.gd"
SEAM="scripts/roguelite/live_effects/rift_build_application.gd"

# The new verification, and the four production scripts Roguelite I14 changed.
PARSED_SCRIPTS=(
	"$THIS_VERIFICATION"
	"scripts/actors/prototype_player.gd"
	"$SEAM"
	"scripts/roguelite/live_effects/rift_build_application_result.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
)

# Accepted files this work stands beside and must not edit or regenerate, each by the SHA-256
# prefix it held before the first I14 edit: C1 and the card records, the run build, the offers,
# choices, both level-up coordinators and their receipts, H8 and H9, I2, the core loop, the modal
# and the HUD, every damage, weapon, Skill, Quick Strike and Graveblade record and script, both
# review scenes, both actor scenes and project.godot; and every accepted I3, I12 and I13 evidence
# frame, which stay historical and are never re-rendered here.
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
	"scripts/combat/quick_strike_action.gd|e6514705"
	"scripts/skills/first_mvp_skill_action.gd|1874582b"
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
	"scripts/levels/rift_level_up_result.gd|2d67cee9"
	"scripts/levels/rift_run_level_coordinator.gd|b654e0a2"
	"scripts/levels/rift_run_level_up_result.gd|cc7f8b84"
	"scripts/offers/rift_offer.gd|9bc94208"
	"scripts/offers/rift_offer_composition.gd|15ef203a"
	"scripts/choices/rift_offer_choice.gd|533ee30f"
	"scripts/choices/rift_offer_choice_result.gd|f051a955"
	"scripts/experience/rift_mote_runtime.gd|23c41eb2"
	"scripts/roguelite/experience/roguelite_experience_collection_review.gd|150509d5"
	"scripts/roguelite/experience/roguelite_experience_review_hud.gd|042a5088"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd|128103b4"
	# First-MVP UI J1 (D-322) moved the panel and the modal contract one for one — `61173e43` →
	# `694eb0b2` and `8d57039b` → `1cfe9c73` — moving the left-press routing into the contract.
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd|694eb0b2"
	"scripts/roguelite/roguelite_core_loop_runtime.gd|a76cec3d"
	"scripts/ui/first_mvp_modal.gd|1cfe9c73"
	# First-MVP UI J6 (D-332) moved the combat HUD one for one — `0bb284a1` → `aff939f3` — so that its
	# Life and Mana fills draw the fraction their labels state.
	# First-MVP UI J7 (D-334) moved it again — `aff939f3` → `38c485cb` — so that the enemy hover Life fill
	# draws its fraction.
	# First-MVP UI J8 (D-336) moved it again — `38c485cb` → `ee485029` — so that the player resource column
	# sits wholly inside the window.
	"scripts/ui/first_mvp_combat_hud.gd|ee485029"
	"data/prototype_zero/graveblade.tres|56317f5f"
	"data/roguelite/graveblade_elite.tres|6eb3d792"
	"data/prototype_zero/honed_sword.tres|77cc713d"
	"data/prototype_zero/starter_sword.tres|5069d1a3"
	"data/prototype_zero/quick_strike.tres|76060315"
	"data/first_mvp/skills/faultbreaker.tres|d9439378"
	"data/first_mvp/skills/splinter_shot.tres|d5664fd4"
	"data/first_mvp/skills/emberbolt.tres|eb8860df"
	"data/first_mvp/severed_threshold/broken_watch/starting_sword.tres|08e97d2e"
	"scenes/roguelite/roguelite_live_effect_review.tscn|0c3c6c98"
	"scenes/roguelite/roguelite_level_up_choice_review.tscn|7038bce6"
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
	"../docs/testing/roguelite_global_damage_live_application_evidence/01_level_six_power_damage_live.png|ef932fbc"
	"../docs/testing/roguelite_global_damage_live_application_evidence/02_level_six_vitality_held.png|950d5aeb"
	"../docs/testing/roguelite_global_damage_live_application_evidence/1280x720/01_level_six_power_damage_live.png|b5129431"
	"../docs/testing/roguelite_global_damage_live_application_evidence/1280x720/02_level_six_vitality_held.png|7a4fecf6"
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

# The accepted-warning rule as a pure reading of one log (D-319 ruling 5's form): one line per
# problem, and nothing at all when the log holds exactly EXPECTED_WARNING_EACH copies of each accepted
# line and no other warning. The replay proofs in step 3 ask this same function.
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
		pass "$what printed $warnings engine WARNING line(s): each of the two accepted navigation-bake precision lines exactly $EXPECTED_WARNING_EACH time, and no other"
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

printf 'Riftwrought — Roguelite I14: Player Maximum-Life Application V1 smoke checks (D-320)\n'
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
step "1. The new verification and the four changed production scripts parse"

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
	pass "${#ACCEPTED_PREFIXES[@]} accepted files and historical frames match their SHA-256 prefixes, the 14 I3, I12 and I13 frames among them"
fi

if grep -rlE 'maximum_life_live_application' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" "$PROJECT_DIR/project.godot" 2>/dev/null | grep -q .; then
	fail "a running file or project.godot names the I14 harness"
else
	pass "no file under scripts/, scenes/, data/ or addons/, and nothing in project.godot, names the I14 harness"
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

# THE PLAYER'S TWO FALLIBLE ENTRY POINTS, measured from outside the engine over every running
# directory: the Maximum-Life one is called by the seam alone, once; the Global Damage one by the seam
# alone, twice — its write, and its put-back when the Maximum-Life write is refused.
count_calls() {
	grep -v '^[[:space:]]*#' "$PROJECT_DIR/$SEAM" | grep -oF "$1" | wc -l | tr -d ' '
}
callers_of() {
	grep -rlF "$1" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null \
		| sed "s|^$PROJECT_DIR/||" | grep -vxF 'scripts/actors/prototype_player.gd' | tr '\n' ' ' | sed 's/ $//'
}
maximum_callers="$(callers_of 'set_increased_maximum_life(')"
damage_callers="$(callers_of 'set_increased_global_damage(')"
maximum_calls="$(count_calls 'set_increased_maximum_life(')"
damage_calls="$(count_calls 'set_increased_global_damage(')"
if [[ "$maximum_callers" == "$SEAM" && "$maximum_calls" == "1" && "$damage_callers" == "$SEAM" && "$damage_calls" == "2" ]]; then
	pass "the only running caller of set_increased_maximum_life( is $SEAM, once; of set_increased_global_damage(, the same file, twice"
else
	fail "set_increased_maximum_life( is called by '${maximum_callers:-nothing}' ($maximum_calls in the seam); set_increased_global_damage( by '${damage_callers:-nothing}' ($damage_calls)"
fi

# --------------------------------------------------------------------------
step "3. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_maximum_life_live_application_verify.log"
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

count="$(read_check_count "MAXIMUM LIFE LIVE APPLICATION VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log whose count moved by
# one, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_maximum_life_live_application_replay)"
scratch_replay="$replay"
sed "s/MAXIMUM LIFE LIVE APPLICATION VERIFICATION: PASS ($EXPECTED_CHECKS checks)/MAXIMUM LIFE LIVE APPLICATION VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "MAXIMUM LIFE LIVE APPLICATION VERIFICATION" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

# The warning pin must refuse replays of this run's own log with one accepted line removed, with a
# second copy of an accepted line, and with a reworded line — and must accept the log as it stands.
scratch_warnings="$(mktemp -d -t riftwrought_maximum_life_warning_replays)"
awk -v target="${KNOWN_WARNINGS[0]}" '!removed && $0 == target { removed = 1; next } { print }' \
	"$verify_log" > "$scratch_warnings/fewer.log"
{ cat "$verify_log"; printf '%s\n' "${KNOWN_WARNINGS[1]}"; } > "$scratch_warnings/second.log"
{ cat "$verify_log"; printf '%s\n' "${KNOWN_WARNINGS[1]/loses precision/loses some precision}"; } \
	> "$scratch_warnings/reworded.log"
as_is="$(warning_problems "$verify_log")"
fewer="$(warning_problems "$scratch_warnings/fewer.log")"
second="$(warning_problems "$scratch_warnings/second.log")"
reworded="$(warning_problems "$scratch_warnings/reworded.log")"
if [[ -z "$as_is" && "$fewer" == *"0 time(s), not $EXPECTED_WARNING_EACH"* \
		&& "$second" == *"$((EXPECTED_WARNING_EACH + 1)) time(s), not $EXPECTED_WARNING_EACH"* \
		&& "$reworded" == *"an unexpected warning"* ]]; then
	pass "the warning pin accepts this run's own log and refuses its replays with one accepted line removed, a second copy added and a reworded line"
else
	fail "the warning pin did not hold: as is '${as_is}'; one removed '${fewer}'; a second copy '${second}'; reworded '${reworded}'"
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
the accepted scene roguelite_live_effect_review.tscn runs roguelite_live_effect_review.gd on the production player; no accepted suite started; 31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload]; 0 of 24 injection patterns in this harness's code
4 changed production files at their D-320 SHA-256 prefixes, the result at its D-321 one and the player at its D-324 one; the player declares one stored total and one captured baseline, both 0.0, and set_increased_maximum_life, increased_maximum_life, maximum_life_baseline, preserved_life, life_transition_problem
the entry point's only caller is [rift_build_application.gd x1]; none but the player names the stored total or baseline, and none but the player writes a maximum
the seam covers [global_damage, skill_speed, maximum_life, movement_speed], holds [] and leaves [experience_gain, pickup_radius] to the run's own mote path; it and its result reach the Life rule only through the player's two static functions
in the player's five new functions, the seam's derive() and apply() and the result's problem() and applied_lines(): no 1 + a total restated and no Life number typed (0 of 9 bodies)
a fixture configured at 400 (STAGED) became 459.99999999999994 / 459.99999999999994, baseline 400 — C1's 460.000000000000 — and an empty build returned it to 400 / 400
enlarged to 575, a fixture still reads its baseline as 500; a second Vitality is derived from that baseline — 650.000000000000, C1's answer — not 661.250000000000 (one card on the moved maximum) or 747.500000000000 (both on it)
1 Vitality: +15% -> 575.000000000000 against C1's 575.000000000000
2 Vitality: +30% -> 650.000000000000 against C1's 650.000000000000
3 Vitality: +45% -> 725.000000000000 against C1's 725.000000000000
500 / 500, +15% -> 575 / 575, the fraction 1 kept as 1, 1 emission(s), line 'Maximum Life 500 → 575 · Life preserved at 100%', diagnostic 'maximum life +15% -> 575.000 from 500.000; life 500.000/500.000 -> 575.000/575.000'
250 / 500, +15% -> 287.5 / 575, the fraction 0.5 kept as 0.5, 1 emission(s), line 'Maximum Life 500 → 575 · Life preserved at 50%', diagnostic 'maximum life +15% -> 575.000 from 500.000; life 250.000/500.000 -> 287.500/575.000'
125 / 500, +15% -> 143.75 / 575, the fraction 0.25 kept as 0.25, 1 emission(s), line 'Maximum Life 500 → 575 · Life preserved at 25%', diagnostic 'maximum life +15% -> 575.000 from 500.000; life 125.000/500.000 -> 143.750/575.000'
0 / 500, +15% -> 0 / 575, the fraction 0 kept as 0, 1 emission(s), line 'Maximum Life 500 → 575 · Life preserved at 0%', diagnostic 'maximum life +15% -> 575.000 from 500.000; life 0.000/500.000 -> 0.000/575.000'
287.5 / 575, +30% -> 325 / 650, the fraction 0.5 kept as 0.5, 1 emission(s), line 'Maximum Life 500 → 650 · Life preserved at 50%', diagnostic 'maximum life +30% -> 650.000 from 500.000; life 287.500/575.000 -> 325.000/650.000'
287.5 / 575, empty build -> 250 / 500, the fraction 0.5 kept as 0.5, 1 emission(s), line '', diagnostic 'maximum life +0% -> 500.000 from 500.000; life 287.500/575.000 -> 250.000/500.000'
6 of 6 rows: the maximum C1's answer and the Life the rule's, both to the last bit, one life_changed each, carrying exactly that Life and maximum
killed through receive_damage: 0 / 500 FALLEN -> 0 / 575 FALLEN -> 0 / 650 FALLEN -> 0 / 500 FALLEN — one fall, and never revived
STAGED 1e-300 Life of a 1e+300 maximum: 'Maximum Life: a living character at 1e-300 of 1e+300 would keep no Life at a Maximum Life of 1.1499999999999999e+300; nothing was applied'; nothing moved
STAGED a maximum of 2^-1074 handed -50% directly: 'the new Maximum Life 0 is not a positive finite number'; nothing moved
at full: 575 / 575 after the first application and after the second, 1 emission in all
a real 125-point Hit through receive_damage left 450 / 575; the same build again left exactly 450 / 575, and adding Power to it moved Life by nothing — 0 emissions after the Hit
the same build again describes itself truthfully: 'maximum life +15% -> 575.000 from 500.000; life 450.000/575.000 -> 450.000/575.000'
two acquisitions sum to +30% and derive 650.000000000000 from the unmodified 500 — not 661.250000000000, 575 at +15%; applied again, no emission; back to one, 575 / 575
entry point, nan: 'maximum_life: the total increased is not a finite number'
entry point, -1.0: 'maximum_life: a total of -1.000000 increased would make the scale 0.000000, and a scale must be positive'
entry point, -1.5: 'maximum_life: a total of -1.500000 increased would make the scale -0.500000, and a scale must be positive'
seam, a Life that is not a number: 'Maximum Life: the current Life nan is not a finite number from 0 to the current Maximum Life 575; nothing was applied'
seam, a negative Life: 'Maximum Life: the current Life -1 is not a finite number from 0 to the current Maximum Life 575; nothing was applied'
seam, a Life above its maximum: 'Maximum Life: the current Life 600 is not a finite number from 0 to the current Maximum Life 575; nothing was applied'
seam, an infinite Life: 'Maximum Life: the current Life inf is not a finite number from 0 to the current Maximum Life 575; nothing was applied'
seam, a zero maximum: 'Maximum Life: the current Maximum Life 0 is not a positive finite number; nothing was applied'
seam, a maximum that is not a number: 'Maximum Life: the current Maximum Life nan is not a positive finite number; nothing was applied'
5 of 5 totals and 6 of 6 incoherent states refused with nothing moved: 575 | 575 | 0.15 | 500 | 0.1 | 5.5 | 0.1 | 2.65 | 180 | 110 | IDLE
0 life_changed and 0 attack_speed_changed signals; the +20% Global Damage the refused build carried was never written — the +10% stood
STRUCTURAL ONLY: the put-back branch is read in code, not driven — derive() asks the player's own rule about the same Life first, so no coherent state reaches it
a success missing its Maximum Life derivation: 'a derived application is missing its Maximum Life derivation'
a derivation naming another stat: 'the Maximum Life derivation names global_damage'
a copied total that is not the build's: 'the Maximum Life total +30% is not the build's own +15%'
a derivation a millionth off C1's answer: 'the Maximum Life value 575.000001000000 is not C1's own answer 575.000000000000'
a final maximum a millionth off C1's answer: 'the final Maximum Life 575.000001000000 is not C1's own answer 575.000000000000'
a prior Life that is not a number: 'the Life transition is not coherent: the current Life nan is not a finite number from 0 to the current Maximum Life 500'
a prior maximum of zero: 'the Life transition is not coherent: the current Maximum Life 0 is not a positive finite number'
a prior Life above its maximum: 'the Life transition is not coherent: the current Life 501 is not a finite number from 0 to the current Maximum Life 500'
a Life after healed to the new maximum: 'the Life after 575.000000000000 is not the preserved 287.500000000000'
a Life after a billionth off the rule: 'the Life after 287.500000001000 is not the preserved 287.500000000000'
a refusal carrying a Maximum Life derivation: 'a refused application must carry no partial value'
a written result stripped of its derivation: 'a derived application is missing its Maximum Life derivation'
2 of 2 seam refusals carry no Maximum Life derivation, a +0% total and no Life fact
an empty build 0, one Vitality 1, one Vitality again 0, two Vitalities 1, two Vitalities again 0, an empty build 1, an empty build again 0; each emission carried the Life and maximum the character then held
Power, Celerity and Fleetness on a fixture holding no Vitality: 0 life_changed
full: 'Maximum Life 500 → 575 · Life preserved at 100%'
half: 'Maximum Life 500 → 575 · Life preserved at 50%'
450 / 575, the same build: 'Maximum Life 500 → 575 · Life preserved at 78.3%'
574.77 / 575 (STAGED), the same build: 'Maximum Life 500 → 575 · Life preserved at 99.96%'
an empty build over 450 / 575: no Maximum Life line, and the Life it leaves is the rule's 391.304347826087 — unrounded; the receipt only formats
Vitality alone: 'Live now — Maximum Life 500 → 575 · Life preserved at 100%'; beside Insight: 'Live now — Maximum Life 500 → 575 · Life preserved at 100% / Held, not live on the character: / Experience Gain +10% — applied by the run's own mote path'
'Live now — damage 100 → 110 / Maximum Life 500 → 575 · Life preserved at 100%'
a Hit's damage 110.000000000000 and the maximum 575.000000000000, each C1's answer; Life 575 / 575; the training sword still reads 100
| reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target
| action time 0.80 s → 0.727 s
| movement speed 5.0 m/s → 5.5 m/s
| damage 100 → 110
| Maximum Life 500 → 575 · Life preserved at 100%
reach, arc, cone, targets, action time, movement, Global Damage and the damage reading identical with and without Vitality; the seam's two descriptions differ only in 'maximum life +0% -> 500.000 from 500.000; life 500.000/500.000 -> 500.000/500.000' against 'maximum life +15% -> 575.000 from 500.000; life 500.000/500.000 -> 575.000/575.000', and are otherwise word for word the same
Level 5 fallback, in place of Level 4's in the same call: paused, the receipt shows only 'Level-up offer open — choose one of the three cards.', no live line; Life — 500 / 500
4 applications before the fallback, 0 refusals; +0% Maximum Life held behind the standing Level 5 offer
in the (A) press's own call — physics and process frames unchanged — the choice committed once, the panel closed at Rift level 6 and the record granted [card_vitality]
Life 500 / 500, Maximum Life +0%, reach 3.65 m, arc 260°, cone 155°, action time 0.80 s, movement 5.0 m/s, Global Damage +0%, damage 100.000000000000 -> Life 575 / 575, Maximum Life +15%, reach 3.65 m, arc 260°, cone 155°, action time 0.80 s, movement 5.0 m/s, Global Damage +0%, damage 100.000000000000
Maximum Life 575.000000000000 — C1's answer for +15% on the unmodified 500 — with Life kept at 100%; one life_changed, [[575.0, 575.0]]; the HUD reads 'Life — 575 / 575' in that same call
| Combat and Defence — Vitality (+15% Maximum Life)
| Rift level 5 → 6 · 0 XP carried over
| Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target / Maximum Life 500 → 575 · Life preserved at 100%
"Live now —" appears once; Maximum Life is its second line; no held heading; the HUD reads 'Life — 575 / 575'
the Level 6 Vitality receipt: 5 lines on screen inside the review panel, 0 overlapping, clear of the centre, smallest 12 px; not paused
the escort's one Hit carried raw 125.000000000000 and final 125.000000000000 — its record's own 125 — and Life went 575 -> 450 of 575; one life_changed; the HUD reads 'Life — 450 / 575'
the held build again: 450 / 575 before and after, 0 life_changed, every covered value and the receipt unchanged
Life 450 / 575, Maximum Life +15%, reach 3.65 m, arc 260°, cone 155°, action time 0.80 s, movement 5.0 m/s, Global Damage +0%, damage 100.000000000000 -> Life 500 / 500, Maximum Life +0%, reach 1.65 m, arc 100°, cone 65°, action time 0.80 s, movement 5.0 m/s, Global Damage +0%, damage 100.000000000000
the restoration ran at 450 / 575 and kept the fraction: 391.304347826087 / 500, the rule's answer — its own one emission, [391.304347826087, 500.0]; then the core loop's revive: [[500.0, 500.0], [500.0, 500.0]]
+0% Maximum Life held, baseline 500, no application, no live line; the HUD reads 'Life — 500 / 500'
B began at Rift level 1, run seed 99: an empty build, card_vitality 0, Life 500 / 500, Maximum Life +0%, reach 1.65 m, arc 100°, cone 65°, action time 0.80 s, movement 5.0 m/s, Global Damage +0%, damage 100.000000000000; the HUD reads 'Life — 500 / 500'; no application and no live line
16 records read at the start and again now, 0 moved: the three swords, both Graveblade records, the canonical Quick Strike, the three Skills, the six cards and the Maximum Life definition
25 fixture players spawned, 68 builds staged through the seam on them, 2 expeditions (1 given seed 99 again by staging), 5 fixture Graveblades registered and killed, 5 applications and 3 restorations made by the review
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
step "5. The third-party inventory has not moved — I14 extracts nothing"

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
		shots_log="/tmp/riftwrought_maximum_life_live_application_shots_$resolution.log"
		run_verification "$shots_log" --path "$PROJECT_DIR" --resolution "$resolution" \
			--script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED" --shots "$target"
		shots_status=$?
		printf '  %s verification exit status: %s\n' "$resolution" "$shots_status"
		assert_log_is_fresh "$shots_log"
		assert_no_script_error "the $resolution rendered run" "$shots_log"
		assert_engine_output "the $resolution rendered run" "$shots_log"
		rendered_count="$(read_check_count "MAXIMUM LIFE LIVE APPLICATION VERIFICATION" "$shots_log")"
		if [[ "$shots_status" == "0" && "$rendered_count" == "$EXPECTED_CHECKS" ]]; then
			pass "the $resolution rendered run exits 0 at the same pinned $EXPECTED_CHECKS checks"
		else
			fail "the $resolution rendered run exits $shots_status at ${rendered_count:-no} checks, not $EXPECTED_CHECKS"
			grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
		fi
		if grep -qF -- "the Level 6 Vitality receipt: 5 lines on screen inside the review panel, 0 overlapping, clear of the centre" "$shots_log"; then
			pass "at $resolution the Level 6 Vitality receipt is on screen, inside the review panel and unobstructed"
		else
			fail "at $resolution the on-screen measurement of the Level 6 Vitality receipt was not reported"
		fi
		grep -oE "the Level 6 Vitality receipt: the live line's logical lines are drawn as [0-9]+ lines" "$shots_log" \
			| sed "s/^/  at $resolution /"
		shots=0
		for stem in 01_level_six_vitality_live 02_graveblade_hit_450_of_575; do
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
	printf 'MAXIMUM LIFE LIVE APPLICATION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; game/ and %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite I14 — Player Maximum-Life Application V1 is DELIVERED under D-320, CORRECTED under\n'
	printf '  D-321, and ACCEPTED and CLOSED at the player-owned percentage-preserving Maximum-Life application\n'
	printf '  mechanism level under D-321. D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'MAXIMUM LIFE LIVE APPLICATION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
