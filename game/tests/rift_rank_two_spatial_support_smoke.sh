#!/usr/bin/env bash
# Riftwrought — Roguelite I4: Rank-Two Spatial Support Effects smoke checks
# (decision D-298).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I4 is a headless MECHANISM: an exact rank-two record for each of the two shipped
# spatial supports, owned by `SkillSupportCatalogue`, consumed by the accepted I3
# run-build seam. It adds no production file, no scene, no panel, no HUD, no evidence
# frame, no asset, no `.tres`, no InputMap action and no storage, and it is not the
# entrypoint. Its production reach is exactly two edited files — the catalogue and the
# seam — and its verification is one new SceneTree suite. What this script proves:
#
#   0. the engine is the locked 4.7.2 and every protected file is fingerprinted;
#   1. both edited production scripts, the new suite and the moved I3 suite parse;
#   2. the two edited production files name no asset, storage or resource saver, each
#      names exactly the project classes it named before I4 (read from the engine's
#      own class cache), neither computes a rank, no other running file names a rank
#      value, the two touched directories hold exactly their scripts, and the new
#      suite reads no other suite — checked in the shell as well as in the engine,
#      because a scan that only runs inside the thing it audits is one process away
#      from proving nothing;
#   3. the pinned verification passes — its check count AND its owed-check count each
#      proved in BOTH directions against a replay of its own log — with zero SCRIPT
#      ERROR, zero engine ERROR and zero engine WARNING, the measured lines read out of
#      that log, and a run that hangs killed and failed;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same
#      nine sections, no `[autoload]`, nothing naming I4;
#   5. the third-party inventory has not moved (185 + 2 = 187);
#   6. the run wrote nothing: no file under `game/` outside `.godot/` is newer than the
#      run's start, `.godot/` is byte-identical, and no `.uid` sidecar sits beside the
#      new suite;
#   7. every protected file — every canonical `.tres` record under `data/`, the loading
#      teaser with its import record and imported cache, H9's, I2's and I3's eighteen
#      accepted evidence frames, the combat and movement kernels, the run build and its
#      records, I3's result and runtime, and the accepted runtimes, scenes and suites I3
#      stands on, the project owner's composed zone, `project.godot`, `CLAUDE.md` and
#      `README.md` — is BYTE-IDENTICAL across the run, and the project owner's own
#      user:// files are untouched.
#
# THE TWO EDITED PRODUCTION FILES AND I3's MOVED SUITE ARE DELIBERATELY NOT IN THE
# PROTECTED LIST, because I4 edits them on purpose; the accepted suites that own or
# guard them are run by their own runners (D-298 names which, and why).
#
# Usage, from the repository root:
#   game/tests/rift_rank_two_spatial_support_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a shell
# evaluates an assignment only when execution REACHES it.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS.
reached_end=0
scratch_replay=""
run_marker=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	[[ -n "$run_marker" ]] && rm -f "$run_marker"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRIFT RANK TWO SPATIAL SUPPORT SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_rank_two_spatial_support_verification.gd"
THIS_VERIFICATION="tests/rift_rank_two_spatial_support_verification.gd"
PASS_LINE="RIFT RANK TWO SPATIAL SUPPORT VERIFICATION"

# Pinned, and proved in both directions below: the count of the suite's first green
# development run, whose 18 owed check functions are itemised in D-298.
EXPECTED_CHECKS=41
EXPECTED_OWED_CHECKS=18

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# I4 extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# Every canonical `.tres` record under data/ is protected; how many there are is pinned.
EXPECTED_CANONICAL_RECORDS=17

CATALOGUE="scripts/skills/skill_support_catalogue.gd"
SEAM="scripts/roguelite/live_effects/rift_build_application.gd"

# The project classes each edited file names, measured before the first I4 edit.
EXPECTED_CATALOGUE_NAMES="FirstMvpSkillData FirstMvpSkillLibrary QuickStrikeData RogueliteUpgrade SkillSupportCatalogue SkillTagProfile SkillTags SupportDefinition SupportEligibility"
EXPECTED_SEAM_NAMES="PlayerStatTotals PlayerStatValue PlayerStats PrototypePlayer QuickStrikeAction QuickStrikeData RiftBuildApplication RiftBuildApplicationResult RiftRunBuild SkillSupportCatalogue"

# The two edited production scripts, this suite, and I3's suite, which I4 moved.
PARSED_SCRIPTS=(
	"$CATALOGUE"
	"$SEAM"
	"$THIS_VERIFICATION"
	"tests/roguelite_live_effect_review_verification.gd"
)

EDITED_PRODUCTION=(
	"$CATALOGUE"
	"$SEAM"
)

# The two directories I4 edited a file in, and exactly what each holds.
EXPECTED_SKILLS_SCRIPTS="acquired_supports.gd first_mvp_active_bindings.gd first_mvp_skill_action.gd first_mvp_skill_data.gd first_mvp_skill_library.gd first_mvp_skill_projectile.gd skill_support_catalogue.gd skill_tag_profile.gd skill_tags.gd support_definition.gd support_eligibility.gd support_selection.gd support_selection_result.gd"
EXPECTED_LIVE_EFFECTS_SCRIPTS="rift_build_application.gd rift_build_application_result.gd roguelite_live_effect_review.gd"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE: the files I4 reads, stands
# beside or could conceivably disturb, and the project owner's work. Every `.tres`
# under data/ is added below, enumerated rather than typed.
PRESERVED_FILES=(
	"project.godot"
	"../CLAUDE.md"
	"../README.md"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png.import"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.ctex"
	".godot/imported/riftwrought-loading-teaser-v1.png-b052aa6f935e93824cd8ff133a3ff6f4.md5"
	"../docs/testing/roguelite_experience_collection_review_evidence/01_uncollected_mote_pickup_off.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/02_level_up_ready.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/03_fresh_second_run.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/01_uncollected_mote_pickup_off.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/02_level_up_ready.png"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/03_fresh_second_run.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/01_three_card_offer.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/02_support_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/03_passive_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/01_three_card_offer.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/02_support_receipt.png"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/03_passive_receipt.png"
	"../docs/testing/roguelite_live_effect_review_evidence/01_sweeping_edge_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/02_celerity_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/03_fleetness_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/01_sweeping_edge_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/02_celerity_live.png"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/03_fleetness_live.png"
	"scripts/combat/quick_strike_action.gd"
	"scripts/combat/quick_strike_data.gd"
	"scripts/combat/target_acquisition.gd"
	"scripts/actors/prototype_player.gd"
	"scripts/actors/prototype_graveblade.gd"
	"scripts/actors/graveblade_target_area.gd"
	"scenes/actors/prototype_player.tscn"
	"scenes/actors/prototype_graveblade.tscn"
	"scripts/movement/prototype_locomotion.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/skills/acquired_supports.gd"
	"scripts/skills/skill_tag_profile.gd"
	"scripts/skills/skill_tags.gd"
	"scripts/skills/support_definition.gd"
	"scripts/skills/support_eligibility.gd"
	"scripts/skills/first_mvp_skill_library.gd"
	"scripts/skills/first_mvp_skill_data.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/roguelite/live_effects/rift_build_application_result.gd"
	"scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
	"scenes/roguelite/roguelite_live_effect_review.tscn"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
	"scenes/roguelite/roguelite_level_up_choice_review.tscn"
	"tests/roguelite_level_up_choice_review_verification.gd"
	"tests/roguelite_level_up_choice_review_smoke.sh"
	"scripts/roguelite/experience/roguelite_experience_collection_review.gd"
	"scenes/roguelite/roguelite_experience_collection_review.tscn"
	"tests/roguelite_experience_collection_review_verification.gd"
	"tests/roguelite_experience_collection_review_smoke.sh"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/experience/rift_mote_runtime.gd"
	"scripts/roguelite/roguelite_core_loop_runtime.gd"
	"scenes/roguelite/roguelite_core_loop.tscn"
	"scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
	"scripts/roguelite/build_variety/roguelite_upgrade.gd"
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

godot_tree_fingerprint() {
	(cd "$PROJECT_DIR/.godot" && find . -type f -print0 | sort -z | xargs -0 shasum -a 256 | shasum -a 256 | awk '{print $1}')
}

# `/tmp` is never cleared between runs, so a file from an earlier invocation must
# never answer for this one.
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

# The owed line, read in two parts, so a replay can move either one.
read_owed() {
	grep -ohE "^  [0-9]+ of [0-9]+ owed checks completed" "$1" | grep -ohE '[0-9]+ of [0-9]+' | head -1
}

# Comment lines removed.
code_of() {
	sed -e 's/^[[:space:]]*#.*$//' "$1"
}

printf 'Riftwrought — Roguelite I4: Rank-Two Spatial Support Effects smoke checks (D-298)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything I4 must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi

canonical_records=()
while IFS= read -r record; do
	canonical_records+=("${record#"$PROJECT_DIR"/}")
done < <(find "$PROJECT_DIR/data" -type f -name '*.tres' | sort)
if [[ "${#canonical_records[@]}" == "$EXPECTED_CANONICAL_RECORDS" ]]; then
	pass "${#canonical_records[@]} canonical .tres records found under data/, all protected"
else
	fail "found ${#canonical_records[@]} canonical .tres records under data/, not $EXPECTED_CANONICAL_RECORDS"
fi
PRESERVED_FILES+=("${canonical_records[@]}")

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

godot_before="$(godot_tree_fingerprint)"
run_marker="$(mktemp -t riftwrought_rank_two_marker)"
pass ".godot/ fingerprinted as one tree, and a start-of-run marker laid"

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. Every edited script, the new suite and the moved I3 suite parse"

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
step "2. The edited files name nothing new, compute no rank, and the touched directories hold exactly what they should"

# The ASSET scan is RAW, comments included (D-215). The STORAGE scan is
# COMMENT-STRIPPED, so a file may say in prose that it writes nothing.
asset_fragments='res://assets/|\.gltf|\.glb|\.png|\.import|kaykit|kenney|k0rveen|quaternius|lelu|GPUParticles|CPUParticles|ShaderMaterial|\.gdshader|AudioStream|Texture2D'
storage_fragments='user://|ConfigFile|ResourceSaver|FileAccess|DirAccess|store_string|save_png|PrototypeSettings|PrototypeLabState|CharacterSave'
hits=0
for relative in "${EDITED_PRODUCTION[@]}"; do
	if grep -qE "$asset_fragments" "$PROJECT_DIR/$relative"; then
		fail "$relative names an asset, shader, particle or sound fragment"
		hits=$((hits + 1))
	fi
	if code_of "$PROJECT_DIR/$relative" | grep -qE "$storage_fragments"; then
		fail "$relative names a storage path, store or writer in CODE"
		hits=$((hits + 1))
	fi
done
if grep -qE '\.tres|ResourceSaver' "$PROJECT_DIR/$SEAM"; then
	fail "the seam names a .tres path or a resource saver"
	hits=$((hits + 1))
fi
if [[ "$hits" == "0" ]]; then
	pass "the catalogue and the seam name no asset (raw) and no storage (code), and the seam no .tres path or resource saver"
fi

# The project classes each edited file names, read from the engine's own class cache.
project_classes="$(grep -oE '"class": &"[A-Za-z0-9_]+"' "$PROJECT_DIR/.godot/global_script_class_cache.cfg" \
	| grep -oE '&"[A-Za-z0-9_]+"' | tr -d '&"' | sort -u)"
names_in() {
	local file="$1" named=""
	for class_id in $project_classes; do
		grep -q "$class_id" "$file" && named="$named $class_id"
	done
	echo "${named# }"
}
catalogue_names="$(names_in "$PROJECT_DIR/$CATALOGUE")"
seam_names="$(names_in "$PROJECT_DIR/$SEAM")"
if [[ "$catalogue_names" == "$EXPECTED_CATALOGUE_NAMES" && "$seam_names" == "$EXPECTED_SEAM_NAMES" ]]; then
	pass "of $(echo "$project_classes" | wc -l | tr -d ' ') project classes the catalogue names exactly its 9 and the seam its 10 — the sets measured before I4"
else
	fail "the catalogue names '$catalogue_names'; the seam '$seam_names'"
fi

# No rank arithmetic in either, in CODE; no other running file names a rank value.
if code_of "$PROJECT_DIR/$SEAM" | grep -qE 'rank \*|\* rank|rank \+|\+ rank|rank -|rank /' \
		|| code_of "$PROJECT_DIR/$CATALOGUE" | grep -qE 'rank \*|\* rank|rank \+|\+ rank|rank -|rank /'; then
	fail "the seam or the catalogue computes with a rank"
else
	pass "neither the seam nor the catalogue computes with a rank"
fi
namers="$(grep -rlE '_EDGE_RANK_|SkillSupportCatalogue\.RANK_' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
	"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null | grep -vF "$PROJECT_DIR/$CATALOGUE")"
readers="$(grep -rlE 'support_rank_values\(|reviewed_support_ranks\(' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
	"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null | sed "s|$PROJECT_DIR/||" | sort | tr '\n' ' ')"
if [[ -z "$namers" && "$readers" == "$SEAM $CATALOGUE " ]]; then
	pass "no running file but the catalogue names a rank value, and only the seam reads the rank table"
else
	fail "rank values named by: ${namers:-none}; the rank table read by: $readers"
fi

skills="$(find "$PROJECT_DIR/scripts/skills" -maxdepth 1 -type f -name '*.gd' -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
skills_uids="$(find "$PROJECT_DIR/scripts/skills" -maxdepth 1 -type f -name '*.gd.uid' | wc -l | tr -d ' ')"
skills_other="$(find "$PROJECT_DIR/scripts/skills" -mindepth 1 ! -name '*.gd' ! -name '*.gd.uid' | wc -l | tr -d ' ')"
if [[ "$skills" == "$EXPECTED_SKILLS_SCRIPTS" && "$skills_uids" == "13" && "$skills_other" == "0" ]]; then
	pass "scripts/skills/ holds exactly its 13 scripts and their 13 uid files"
else
	fail "scripts/skills/ holds '$skills' ($skills_uids uid, $skills_other other)"
fi
live="$(find "$PROJECT_DIR/scripts/roguelite/live_effects" -maxdepth 1 -type f -name '*.gd' -exec basename {} \; | sort | tr '\n' ' ' | sed 's/ $//')"
live_uids="$(find "$PROJECT_DIR/scripts/roguelite/live_effects" -maxdepth 1 -type f -name '*.gd.uid' | wc -l | tr -d ' ')"
live_other="$(find "$PROJECT_DIR/scripts/roguelite/live_effects" -mindepth 1 ! -name '*.gd' ! -name '*.gd.uid' | wc -l | tr -d ' ')"
if [[ "$live" == "$EXPECTED_LIVE_EFFECTS_SCRIPTS" && "$live_uids" == "3" && "$live_other" == "0" ]]; then
	pass "scripts/roguelite/live_effects/ holds exactly I3's 3 scripts and their 3 uid files — I4 added none"
else
	fail "scripts/roguelite/live_effects/ holds '$live' ($live_uids uid, $live_other other)"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]]; then
	pass "the verification names no file under tests/ but its own"
else
	fail "the verification names another test file: $others"
fi

# --------------------------------------------------------------------------
step "3. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_rank_two_spatial_support_verify.log"
perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" --headless --path "$PROJECT_DIR" \
	--script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
printf '  verification exit status: %s\n' "$verify_status"
assert_log_is_fresh "$verify_log"

script_errors="$(grep -cE "SCRIPT ERROR|String formatting error|Parse Error" "$verify_log" | tr -d ' ')"
engine_lines="$(grep -cE "^(ERROR|WARNING):" "$verify_log" | tr -d ' ')"
if [[ "$script_errors" == "0" ]]; then
	pass "the verification produced no SCRIPT ERROR"
else
	fail "the verification produced $script_errors script error line(s)"
	grep -A3 -E "SCRIPT ERROR|String formatting error|Parse Error" "$verify_log" | head -20 | sed 's/^/        /'
fi
if [[ "$engine_lines" == "0" ]]; then
	pass "the verification produced no engine ERROR and no engine WARNING line"
else
	fail "the verification produced $engine_lines engine ERROR or WARNING line(s)"
	grep -A2 -E "^(ERROR|WARNING):" "$verify_log" | head -20 | sed 's/^/        /'
fi

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "$PASS_LINE" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: each pin must refuse a log whose
# number moved, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_rank_two_replay)"
scratch_replay="$replay"
sed "s/$PASS_LINE: PASS ($EXPECTED_CHECKS checks)/$PASS_LINE: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "$PASS_LINE" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

owed="$(read_owed "$verify_log")"
expected_owed="$EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS"
if [[ "$owed" == "$expected_owed" ]]; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report reads '${owed:-nothing}', not '$expected_owed'"
fi
refused=0
for moved in "$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))"; do
	sed "s/^  $expected_owed owed checks completed/  $moved owed checks completed/" "$verify_log" > "$replay"
	moved_read="$(read_owed "$replay")"
	if [[ "$moved_read" == "$moved" && "$moved_read" != "$expected_owed" ]]; then
		refused=$((refused + 1))
	fi
done
if [[ -z "$owed" ]]; then
	fail "the verification printed no owed line, so the owed pin proves nothing this run"
elif [[ "$refused" == "2" ]]; then
	pass "and that pin reads a log with one check short ('$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS') and one owed too many ('$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))'), refusing both"
else
	fail "the owed pin refused $refused of 2 moved logs"
fi

# The measurements I4 exists to make, read out of the run's own log rather than
# restated here. `--` before the pattern is D-244's lesson kept. A line that follows a
# number which varies with the project's file count is pinned only up to it.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
prototype_player.tscn holds a private copy of quick_strike.tres (private: true); a 2-point navigation path crosses the fixture's floor; movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s)
the catalogue's rank-one records: { &"reach": 2.65 } and { &"release_arc_degrees": 180.0, &"soft_target_cone_degrees": 110.0 }
applied: [quick_strike -> reaching_edge rank 1] reach 2.65 m, arc 100°, cone 65°, 1 target(s); [quick_strike -> sweeping_edge rank 1] reach 1.65 m, arc 180°, cone 110°, 1 target(s)
the catalogue's rank-two records: { &"reach": 3.65 } and { &"release_arc_degrees": 260.0, &"soft_target_cone_degrees": 155.0 }; its reviewed ranks: [1, 2] and [1, 2]; after a caller changed its copies it still answers { &"reach": 3.65 } and { &"release_arc_degrees": 260.0, &"soft_target_cone_degrees": 155.0 }
applied: [quick_strike -> reaching_edge rank 2] reach 3.65 m, arc 100°, cone 65°, 1 target(s); [quick_strike -> sweeping_edge rank 2] reach 1.65 m, arc 260°, cone 155°, 1 target(s) — the record's own half-angles +/-130.0° arc and +/-77.5° cone, inside its 89° guard
the catalogue declares 6 value constants, each a literal; of
running files 0 other name(s) one
the rank table is read by [rift_build_application.gd, skill_support_catalogue.gd]; the seam asks it 1 time(s) for a rank's record and 1 for the ranks it holds
the seam's code holds the numeric literal(s) [0.0] and the result's [0, 0.0, 1, 100.0, 6]; 0 of 10 retyping tokens found in either
0 operator(s) in the catalogue's three lookups and 0 in the seam's rank phrase; 0 rank-arithmetic match(es) in either; 0 of 16 questions past the table answered (ranks -1, 0, 3, 4, 5, 10, 100 and the largest recordable)
the rank-two moves are +1.00 m (x1.377), +80° (x1.444) and +45° (x1.409): no one increment and no one multiplier makes them
3.20 m ahead: rank one's query miss — '3.20 m is beyond the 2.65 m reach'; rank two's hit; rank one's again miss
from where the player stands, rank two's real press began in windup, moved 0.000 m and hit, 300 -> 200; rank one's began in approach, wound up 2.492 m away and hit, 200 -> 100
a real approach to a Graveblade 4.50 m ahead wound up 1.542 m from it at baseline, 2.542 m at rank one and 3.542 m at rank two (each the reach less the 0.10 m margin); the three releases: hit, hit, hit
110° at 1.20 m: rank one's query miss — '110 deg is outside the 180 deg release arc'; rank two's hit; rank one's again miss
the real swing along the facing: rank one miss with 0 damage event(s), 0 hit(s), Life 300; rank two made 1 query, 1 release and 1 damage event(s), 1 hit(s) on it, 300 -> 200
70° at 3.00 m: baseline — '70.0 deg outside the 32.5 deg half-cone (65 deg total)'; rank one — '70.0 deg outside the 55.0 deg half-cone (110 deg total)'; rank two chose it — 'approach: 70 deg off intent, 3.00 m away'; rank one again — '70.0 deg outside the 55.0 deg half-cone (110 deg total)'
the real press: rank one began in windup — 'no eligible target in the 110 deg cone'; rank two began in approach — 'approach: 70 deg off intent, 3.00 m away' — and its release hit with 1 damage event(s)
Reaching Edge rank one: 2 legal at +/-10°, 1 release(s), 1 damage event(s); the nearer 300 -> 200, the other 300 with 0 hit(s)
Reaching Edge rank two: 2 legal at +/-10°, 1 release(s), 1 damage event(s); the nearer 300 -> 200, the other 300 with 0 hit(s)
Sweeping Edge rank one: 2 legal at +/-70°, 1 release(s), 1 damage event(s); the nearer 300 -> 200, the other 300 with 0 hit(s)
Sweeping Edge rank two: 2 legal at +/-110°, 1 release(s), 1 damage event(s); the nearer 300 -> 200, the other 300 with 0 hit(s)
both at rank two: 2 legal at +/-110°, 1 release(s), 1 damage event(s); the nearer 300 -> 200, the other 300 with 0 hit(s)
at most 1 target(s) at any rank; Quick Strike's tags Attack, Hit, Melee, Strike, Physical — carries Area: false; weapon damage 100
both at rank two: reach 3.65 m, arc 260°, cone 155°, 1 target(s), supports [quick_strike -> reaching_edge rank 2, quick_strike -> sweeping_edge rank 2]; Reaching 2 + Sweeping 1: reach 3.65 m, arc 180°, cone 110°, 1 target(s); Reaching 1 + Sweeping 2: reach 2.65 m, arc 260°, cone 155°, 1 target(s)
120° at 3.40 m: both together — hit, and the real swing hit with 1 damage event(s); Reaching Edge alone — '120 deg is outside the 100 deg release arc'; Sweeping Edge alone — '3.40 m is beyond the 1.65 m reach'
Celerity + Reaching Edge 2 + Sweeping Edge 2, applied, applied again, acquired Sweeping-first and applied, then applied again: movement 5.0 m/s, Skill Speed +10% (action time 0.7273 s), reach 3.65 m, arc 260°, cone 155°, 1 target(s); 3 of 3 re-applications identical to the first, 0 speed-change signals, supports [quick_strike -> reaching_edge rank 2, quick_strike -> sweeping_edge rank 2]
over a live record the harness set to reach 9.00 m, arc 17°, cone 30°, 1 target(s), the seam derived 3.65 m / 260° / 155° from the canonical record while the live record still read reach 9.00 m, arc 17°, cone 30°, 1 target(s), and the application left reach 3.65 m, arc 260°, cone 155°, 1 target(s)
movement 5.5 m/s, Skill Speed +10% (action time 0.7273 s), reach 3.65 m, arc 260°, cone 155°, 1 target(s) -> movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s)
Reaching Edge at rank three: 'reaching_edge on quick_strike is held at rank 3, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied'
Sweeping Edge at rank three beside Reaching Edge at rank two: 'sweeping_edge on quick_strike is held at rank 3, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied'
Sweeping Edge at rank four: 'sweeping_edge on quick_strike is held at rank 4, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied'
both at rank three: 'reaching_edge on quick_strike is held at rank 3, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied'
an uncatalogued support: 'invented_support on quick_strike is held at rank 1, and the catalogue holds no reviewed value for it at any rank; nothing was applied'
5 of 5 refused identically by derive() and by apply(), with no partial value; a rank-three reason names [quick_strike, reaching_edge, rank 3, ranks 1 and 2, nothing was applied]; apply() tests the refusal at character
5 of 5 rank-three-or-higher builds, each also holding +20% Skill Speed and Fleetness, refused over movement 5.0 m/s, Skill Speed +10% (action time 0.7273 s), reach 3.65 m, arc 260°, cone 155°, 1 target(s); 0 of 17 covered values moved, 0 speed-change signals, the same private record: true; the release query at 3.20 m afterwards: hit
after 61 applications quick_strike.tres reads 0.80 s, reach 1.65 m, arc 100°, cone 65°, 1 target(s), marker 0.325; 17 of 17 .tres records under res://data hash identically before and after
seed 99 lane 0 [quick_strike, sweeping_edge] -> movement 5.0 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 180°, cone 110°, 1 target(s); 'Live now — arc 100° → 180° · cone 65° → 110° · one target'
seed 99 lane 1 [card_celerity] -> movement 5.0 m/s, Skill Speed +10% (action time 0.7273 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s); 'Live now — action time 0.80 s → 0.727 s'
seed 99 lane 2 [card_fleetness] -> movement 5.5 m/s, Skill Speed +0% (action time 0.8000 s), reach 1.65 m, arc 100°, cone 65°, 1 target(s); 'Live now — movement speed 5.0 m/s → 5.5 m/s'
the Sweeping Edge choice derives: quick_strike; skill speed +0% -> 0.800000000 s; movement +0% -> 5.000 m/s; global damage +0% -> 100.000 from 100.000; maximum life +0% -> 500.000 from 500.000; life 500.000/500.000 -> 500.000/500.000; reach 1.65 m, arc 180 deg, cone 110 deg, 1 target(s); supports [quick_strike -> sweeping_edge rank 1]; run path []; deferred []; committed
project.godot: 31 actions; the Prototype App entrypoint unchanged; [autoload] present: false; 0 of 16 inert-token or RefCounted findings in the catalogue and the seam
the catalogue names 9 project classes (FirstMvpSkillData, FirstMvpSkillLibrary, QuickStrikeData, RogueliteUpgrade, SkillSupportCatalogue, SkillTagProfile, SkillTags, SupportDefinition, SupportEligibility), the seam 10 and the result 7 — the sets measured before the first I4 edit, the result's with the player's class since I14 (D-320)
15 real Quick Strike presses, 16 production Graveblades placed, 67 builds applied through the seam (10 refused), 50 kernel log lines heard; the fixture freed
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
if grep -qiE "rank_two|ranktwo|rift_rank_two" "$project_godot"; then
	fail "project.godot names I4 — it must own no project setting"
else
	pass "project.godot names nothing about I4"
fi

# --------------------------------------------------------------------------
step "5. The third-party inventory has not moved — I4 extracts nothing"

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
step "6. The run wrote nothing"

written="$(find "$PROJECT_DIR" -path "$PROJECT_DIR/.godot" -prune -o -type f -newer "$run_marker" -print 2>/dev/null)"
if [[ -z "$written" ]]; then
	pass "no file under game/ outside .godot/ was written during this run"
else
	fail "files were written during this run: $(echo "$written" | sed "s|$PROJECT_DIR/||" | tr '\n' ' ')"
fi
if [[ "$(godot_tree_fingerprint)" == "$godot_before" ]]; then
	pass ".godot/ is byte-identical across the run — no import pass, no cache rewrite"
else
	fail ".godot/ changed during this run"
fi
if [[ -e "$PROJECT_DIR/$THIS_VERIFICATION.uid" ]]; then
	fail "a .uid sidecar sits beside the new suite"
else
	pass "no .uid sidecar sits beside the new suite"
fi

# --------------------------------------------------------------------------
step "7. Every protected file is byte-identical, and the owner's files are untouched"

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
	printf 'RIFT RANK TWO SPATIAL SUPPORT SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite I4 — Rank-Two Spatial Support Effects is DELIVERED under D-298\n'
	printf '  and ACCEPTED and CLOSED at the exact rank-two spatial-support effect\n'
	printf '  mechanism level under D-299.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT RANK TWO SPATIAL SUPPORT SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
