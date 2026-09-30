#!/usr/bin/env bash
# Riftwrought — Roguelite I11: Repeated Playable Level-Up Offer Loop V1 smoke checks
# (decision D-314).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN.
#
# I11 OWNS NO SCENE. It extends the accepted I2 review so one expedition opens, and resolves
# one explicit choice at a time, a distinct three-card offer for every Rift level it reaches.
# Its verification is a SceneTree script that loads the accepted I2 scene exactly as it ships
# and drives six seed-99 expeditions through it. What this script proves:
#
#   1. the new verification and both changed production scripts parse;
#   2. the accepted I2 scene, and the accepted I2, I3, I10 and H9 evidence frames, are
#      byte-identical to their accepted hashes; nothing that runs names the harness; the
#      verification names no file under tests/ but its own;
#   3. the pinned verification passes, proved in BOTH directions against a replay of its own
#      log, with every owed check reaching its last line, the measured lines read out of that
#      log, zero SCRIPT ERROR and zero engine ERROR, and no engine WARNING but the accepted core
#      loop's own two navigation-bake precision warnings — and a run that hangs is killed and
#      FAILS;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine
#      sections, no `[autoload]`;
#   5. the third-party inventory has not moved (185 + 2 = 187);
#   6. optionally (`--shots <dir>`), rendered evidence at 1920x1080 and at the 1280x720
#      minimum tested window, each run passing at the SAME pinned count, because the evidence
#      frames add no assertion;
#   7. the whole of game/ outside .godot/, .godot/ itself, every protected file outside game/
#      and the project owner's own user:// files are byte-identical across the run.
#
# Usage, from the repository root:
#   game/tests/roguelite_repeated_level_up_offer_loop_smoke.sh
#   game/tests/roguelite_repeated_level_up_offer_loop_smoke.sh --shots docs/testing/roguelite_repeated_level_up_offer_loop_evidence

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a shell evaluates an
# assignment only when execution REACHES it.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS.
reached_end=0
scratch_replay=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nROGUELITE REPEATED LEVEL-UP OFFER LOOP SMOKE CHECKS: ABORTED before the end of the script\n'
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
EXPECTED_CHECKS=44
EXPECTED_OWED_CHECKS=28

# Seconds a verification may take before it is killed and counted as a failure.
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# The review extracts nothing. D-216's authorized numbers, unmoved.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187

# The only engine warnings the verification may print: the accepted core loop's own navigation
# bake rounding its agent values to the voxel grid (accepted under D-290).
KNOWN_WARNINGS=(
	"WARNING: Property agent_max_climb is floored to cell_height voxel units and loses precision."
	"WARNING: Property agent_radius is ceiled to cell_size voxel units and loses precision."
)

THIS_VERIFICATION="tests/roguelite_repeated_level_up_offer_loop_verification.gd"

# The new verification, and both production scripts Roguelite I11 changed.
PARSED_SCRIPTS=(
	"$THIS_VERIFICATION"
	"scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
	"scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
)

# The accepted scene this review drives, and every accepted evidence frame it must not
# regenerate, each by the SHA-256 prefix its acceptance recorded (D-293, D-295, D-290, D-313).
ACCEPTED_PREFIXES=(
	"scenes/roguelite/roguelite_level_up_choice_review.tscn|7038bce6"
	"../docs/testing/roguelite_level_up_choice_review_evidence/01_three_card_offer.png|5567fa79"
	"../docs/testing/roguelite_level_up_choice_review_evidence/02_support_receipt.png|d4ad49f6"
	"../docs/testing/roguelite_level_up_choice_review_evidence/03_passive_receipt.png|6168883e"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/01_three_card_offer.png|32bce080"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/02_support_receipt.png|912bbc23"
	"../docs/testing/roguelite_level_up_choice_review_evidence/1280x720/03_passive_receipt.png|5bcedc2b"
	"../docs/testing/roguelite_live_effect_review_evidence/01_sweeping_edge_live.png|73ccb8ec"
	"../docs/testing/roguelite_live_effect_review_evidence/02_celerity_live.png|c23cf8ed"
	"../docs/testing/roguelite_live_effect_review_evidence/03_fleetness_live.png|f844767c"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/01_sweeping_edge_live.png|5b112d8c"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/02_celerity_live.png|82d4bbe8"
	"../docs/testing/roguelite_live_effect_review_evidence/1280x720/03_fleetness_live.png|5207c56c"
	"../docs/testing/roguelite_passive_fallback_presentation_review_evidence/01_passive_fallback_offer.png|6695a969"
	"../docs/testing/roguelite_passive_fallback_presentation_review_evidence/02_passive_fallback_receipt.png|f72204e5"
	"../docs/testing/roguelite_passive_fallback_presentation_review_evidence/1280x720/01_passive_fallback_offer.png|f93a1d48"
	"../docs/testing/roguelite_passive_fallback_presentation_review_evidence/1280x720/02_passive_fallback_receipt.png|8b96f21e"
	"../docs/testing/roguelite_experience_collection_review_evidence/01_uncollected_mote_pickup_off.png|39b83295"
	"../docs/testing/roguelite_experience_collection_review_evidence/02_level_up_ready.png|6281a25a"
	"../docs/testing/roguelite_experience_collection_review_evidence/03_fresh_second_run.png|cc6c6f7f"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/01_uncollected_mote_pickup_off.png|63909c92"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/02_level_up_ready.png|77ff0426"
	"../docs/testing/roguelite_experience_collection_review_evidence/1280x720/03_fresh_second_run.png|7134269a"
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

# Engine ERROR lines are refused outright, and every WARNING line must be one of the accepted
# bake's two known lines.
assert_engine_output() {
	local what="$1" logfile="$2" errors warnings unknown=0 line known
	errors="$(grep -cE "^ERROR:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$errors" == "0" ]]; then
		pass "$what produced no engine ERROR line"
	else
		fail "$what produced $errors engine ERROR line(s)"
		grep -A2 -E "^ERROR:" "$logfile" | head -20 | sed 's/^/        /'
	fi
	warnings="$(grep -cE "^WARNING:" "$logfile" 2>/dev/null | tr -d ' ')"
	while IFS= read -r line; do
		known=0
		for expected in "${KNOWN_WARNINGS[@]}"; do
			[[ "$line" == "$expected" ]] && known=1
		done
		if [[ "$known" == "0" ]]; then
			fail "$what printed an unexpected warning: $line"
			unknown=$((unknown + 1))
		fi
	done < <(grep -E "^WARNING:" "$logfile" 2>/dev/null)
	if [[ "$unknown" == "0" ]]; then
		pass "$what printed $warnings engine WARNING line(s), each one of the accepted core loop's two navigation-bake precision warnings"
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

printf 'Riftwrought — Roguelite I11: Repeated Playable Level-Up Offer Loop V1 smoke checks (D-314)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Engine, and a fingerprint of everything this review must not disturb"

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
	pass "${#PRESERVED_FILES[@]} protected file(s) outside game/ fingerprinted"
fi

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
pass "the project owner's own three user:// files fingerprinted"

# --------------------------------------------------------------------------
step "1. The new verification and both changed production scripts parse"

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
step "2. The accepted scene and evidence frames are the accepted ones; nothing that runs names the harness"

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
	pass "the I2 scene and all 22 accepted I2, I3, I10 and H9 evidence frames match their accepted SHA-256 prefixes"
fi

if grep -rlE 'repeated_level_up_offer_loop' "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" "$PROJECT_DIR/project.godot" 2>/dev/null | grep -q .; then
	fail "a running file or project.godot names the I11 harness"
else
	pass "no file under scripts/, scenes/, data/ or addons/, and nothing in project.godot, names the I11 harness"
fi

others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -q '^extends SceneTree$' "$PROJECT_DIR/$THIS_VERIFICATION"; then
	pass "the verification is a SceneTree script and names no file under tests/ but its own"
else
	fail "the verification names another test file: ${others:-none}, or is not a SceneTree script"
fi

if grep -qE 'user://|ConfigFile|ResourceSaver|DirAccess|store_string' "$PROJECT_DIR/$THIS_VERIFICATION"; then
	fail "the verification names a storage path or writer"
else
	pass "the verification names no storage path or writer (its only file write is an evidence frame under --shots)"
fi

# --------------------------------------------------------------------------
step "3. The pinned verification passes, proved in BOTH directions"

verify_log="/tmp/riftwrought_repeated_level_up_offer_loop_verify.log"
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

count="$(read_check_count "ROGUELITE REPEATED LEVEL-UP OFFER LOOP VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log whose count moved
# by one, and the negative direction must READ the moved number.
replay="$(mktemp -t riftwrought_repeated_level_up_offer_loop_replay)"
scratch_replay="$replay"
sed "s/ROGUELITE REPEATED LEVEL-UP OFFER LOOP VERIFICATION: PASS ($EXPECTED_CHECKS checks)/ROGUELITE REPEATED LEVEL-UP OFFER LOOP VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "ROGUELITE REPEATED LEVEL-UP OFFER LOOP VERIFICATION" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
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
for moved in "$((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS of $((EXPECTED_OWED_CHECKS + 1))"; do
	if grep -qE "^  $moved owed checks completed" "$verify_log"; then
		fail "the owed-set line reads '$moved'"
	fi
done

# The measurements this review exists to make, read out of the run's own log rather than
# restated here. `--` before the pattern is D-244's lesson kept. No line carrying a rectangle,
# a distance walked or a tick count — each of which varies with the window and the clock — is
# printed at all.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the accepted scene roguelite_level_up_choice_review.tscn runs roguelite_level_up_choice_review.gd; no accepted suite started; 31 actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload]; 0 of 15 injection patterns in this harness's code
the review declares 18 fields — the one guard `_offer_attempted_level: int`, no list, array or queue — and constants LEVEL_UP_VERIFICATION_SCRIPT, OFFER_PANEL_SCRIPT, NO_LEVEL_ASKED, RECEIPT_TITLE, RECEIPT_NOTE, OFFER_STANDING_TEXT, SUPPORTS_MAXED_DETAIL, FALLBACK_RECEIPT_LINE; none of 13 cap, queue, history or seed-counter tokens
the guard is written twice: to the run's level just before the one opening call, and back to NO_LEVEL_ASKED when the expedition's runtime goes; the opening is asked from exactly the automatic tick and a successful choice; none of the 5 path functions loops; the lane is taken only by the card entry point
the panel still reaches the runtime once, pauses nothing, and — already open — shows a new offer in place with the contract's own arming rule and no close; 20 functions, none added
25 accepted files match the SHA-256 prefixes they held before the first I11 edit, but for I3's review and the seam, at their D-320 hashes, and the modal contract, at its D-322 hash
experience 25.0 -> 50.0 -> 75.0 through real motes; at each step 0 opening(s) asked, no attempt recorded (attempted level 0), no panel, not paused, level 1, no offer
the collecting sweep took [3]: experience 100.0 = G1's Level 1 requirement; 1 opening asked, recorded against Level 1; the panel opened on its own; paused (1 pause notice to the probe); frozen requirement 100.0; root seed 99 (G2: 99)
root 99 lanes [0, 1, 2] [quick_strike, sweeping_edge] [card_celerity] [card_fleetness] kind 0 category -1 — identical in the review's run and the G4 twin
Support: Sweeping Edge — Applies to Quick Strike; Combat and Defence: Celerity — +10% Skill Speed; Utility: Fleetness — +10% Movement Speed; Choose Sweeping Edge, Choose Celerity, Choose Fleetness; focus on card 1; the greybox note verbatim; H9 'Rift level 1' / 'XP 100 / 100', its LEVEL-UP READY lines withheld
30 physics and 10 idle frames: 0 further opening(s), the same offer (root 99), 0 choices, 0 sweeps, the escort and the probe unmoved
lane 7: 'lane 7 is not one of the offer's lanes (Support 2996865621, Combat and Defence 1818840148, Utility 1107088162)'; shown word for word; the same offer still open, paused, level 1, 100.0
125 awarded: the review asked 1 opening, recorded against Level 2; root 1000102 lanes [0, 1, 2] [quick_strike, reaching_edge] [card_power] [card_magnetism] kind 0 category -1; cards Reaching Edge / Power / Magnetism; Level 1's receipt held but hidden
the Level 2 offer: 15 of 15 visible text controls on screen, smallest 12 px; 3 cards, 0 overlapping, each at least 320 px wide; the panel centred within 1 px
Level 3 -> 4: physics frame unchanged, panel open (opens 3, closes 2, replacements 0 -> 1), the probe's ticks and unpause notices unchanged, 1 opening asked
Level 4 -> 5: physics frame unchanged, panel open (opens 3, closes 2, replacements 1 -> 2), the probe's ticks and unpause notices unchanged, 1 opening asked
over both chained offers and 80 held frames: the probe received 0 physics ticks and 0 unpause notices; the one close at Level 6 sent exactly 1; the escort moved again after it
after Level 3: root 3000108 lanes [0, 1, 2] [quick_strike, sweeping_edge] [card_power] [card_magnetism] kind 0 category -1 — Sweeping Edge / Power / Magnetism
after Level 4: root 4000111 lanes [0, 1, 2] [card_power] [card_vitality] [card_fleetness] kind 1 category 0 — Power / Vitality / Fleetness
each the G4 twin's own; card 1 focused and no refusal left over each time; the held receipt hidden behind both
the chained Level 4 offer: 15 of 15 visible text controls on screen, smallest 12 px; 3 cards, 0 overlapping, each at least 320 px wide; the panel centred within 1 px
525 banked at Level 3 (150 + 175 + 200): 3 openings asked — 1 on the review's tick, 2 by the choices that chained them — 3 choices from sources 3, 4, 5; 40 frames after each of the first two, 0 choices made on their own
Support taken at Levels 1–4 — Sweeping Edge new, Reaching Edge new, Reaching Edge 1 -> 2, Sweeping Edge 1 -> 2 — and the Level 5 offer, shown by the review's own chain, is PASSIVE_FALLBACK from category 0 with reaching_edge 2 / 2 and sweeping_edge 2 / 2 held
Support: Power — Supports maxed — +10% Global Damage; Combat and Defence: Vitality — +15% Maximum Life; Utility: Fleetness — +10% Movement Speed; Choose Power, Choose Vitality, Choose Fleetness
Temporary build — this expedition | Support — Power (+10% Global Damage) | Passive fallback from Combat and Defence | Rift level 5 → 6 · 0 XP carried over | Recorded in the temporary build; not applied to the character in this review.
the fallback offer: 15 of 15 visible text controls on screen, smallest 12 px; 3 cards, 0 overlapping, each at least 320 px wide; the panel centred within 1 px
the fallback receipt: 5 lines on screen inside the review panel, clear of the centre, smallest 12 px; not paused
card_power 0 -> 1, passive cards 0 -> 1, pairs [quick_strike -> reaching_edge, quick_strike -> sweeping_edge], ranks 2 / 2 -> 2 / 2, total 4 -> 4
225 awarded at Level 6: 1 opening asked on the review's own tick; root 5000114 lanes [0, 1, 2] [card_insight] [card_vitality] [card_magnetism] kind 1 category 1 — Insight / Vitality / Magnetism, the G4 twin's own
Support taken with Enter: Level 6 -> 7 with 0 kept; 'Support — Insight (+10% Experience Gain)' / 'Rift level 6 → 7 · 0 XP carried over'; H9 'Rift level 7' / 'XP 0 / 250'; the twin's ledger holds 6 root seeds
1 request for Level 3, recorded against it and refused: 'level 3 already has an offer open; only a lane of that offer may be taken'; shown as 'Last refusal: level-up offer did not open — level 3 already has an offer open; only a lane of that offer may be taken'; 70 frames later still 1, no panel, not paused
before the lethal hit: level 3, attempted level 3, an offer standing true, 2 pair(s); Fallen opened; Enter on its button returned to the Nexus
after it: no runtime, attempted level 0, no refusal, record or receipt, the level-up panel closed, not paused; H9 reads 'No expedition in progress'
E began after D's death at Level 1, XP 0, no offer standing, attempted level 0, an empty temporary build of 0 pair(s) and 0 card(s), the panel closed
E completed through its last Rift Gate at Level 2: the runtime gone, the summary open, attempted level 0; the card entry point asked afterwards took nothing; 36 frames in the Nexus asked nothing
F began at Level 1, XP 0, no offer standing, attempted level 0, an empty temporary build of 0 pair(s) and 0 card(s), the panel closed
A Level 1 Support by Enter: root 99, granted [quick_strike, sweeping_edge] — Support — Quick Strike → Sweeping Edge; Level 1 -> 2 with 0 kept; the panel closed and play resumed in the same call
A Level 2 Support by Enter: root 1000102, granted [quick_strike, reaching_edge] — Support — Quick Strike → Reaching Edge; Level 2 -> 3 with 0 kept; the panel closed and play resumed in the same call
A Level 3 Support by Enter: root 2000105, granted [quick_strike, reaching_edge] — Support — Quick Strike → Reaching Edge; Level 3 -> 4 with 375 kept; the Level 4 offer (root 3000108) took its place in the same call
A Level 4 Support by Enter: root 3000108, granted [quick_strike, sweeping_edge] — Support — Quick Strike → Sweeping Edge; Level 4 -> 5 with 200 kept; the Level 5 offer (root 4000111) took its place in the same call
A Level 5 Support by Enter: root 4000111, granted [card_power] — Support — Power (+10% Global Damage); Level 5 -> 6 with 0 kept; the panel closed and play resumed in the same call
A Level 6 Support by Enter: root 5000114, granted [card_insight] — Support — Insight (+10% Experience Gain); Level 6 -> 7 with 0 kept; the panel closed and play resumed in the same call
B Level 1 Support by (A): root 99, granted [quick_strike, sweeping_edge] — Support — Quick Strike → Sweeping Edge; Level 1 -> 2 with 150 kept; the Level 2 offer (root 1000102) took its place in the same call
B Level 2 Combat and Defence by (A): root 1000102, granted [card_power] — Combat and Defence — Power (+10% Global Damage); Level 2 -> 3 with 25 kept; the panel closed and play resumed in the same call
C Level 1 Support by left click: root 99, granted [quick_strike, sweeping_edge] — Support — Quick Strike → Sweeping Edge; Level 1 -> 2 with 150 kept; the Level 2 offer (root 1000102) took its place in the same call
C Level 2 Utility by left click: root 1000102, granted [card_magnetism] — Utility — Magnetism (+25% Pickup Radius); Level 2 -> 3 with 25 kept; the panel closed and play resumed in the same call
D Level 1 Support by Enter: root 99, granted [quick_strike, sweeping_edge] — Support — Quick Strike → Sweeping Edge; Level 1 -> 2 with 125 kept; the Level 2 offer (root 1000102) took its place in the same call
D Level 2 Support by Enter: root 1000102, granted [quick_strike, reaching_edge] — Support — Quick Strike → Reaching Edge; Level 2 -> 3 with 0 kept; the panel closed and play resumed in the same call
E Level 1 Support by Enter: root 99, granted [quick_strike, sweeping_edge] — Support — Quick Strike → Sweeping Edge; Level 1 -> 2 with 0 kept; the panel closed and play resumed in the same call
13 choices, each one level; 8 closed the panel with the completed receipt shown by the same input and the world running again; 5 left the next level's offer standing
Level 1's receipt: Temporary build — this expedition | Support — Quick Strike → Sweeping Edge | a new compatible pair, rank 0 -> 1 | Rift level 1 → 2 · 0 XP carried over | Recorded in the temporary build; not applied to the character in this review.; after it the escort moved again and the sweep ran again
keyboard: each Enter press took exactly one card; its release and a held-key echo over the replacement took none
controller: with (A) held, the press that took Level 1's Support left the panel disarmed; a second press of the still-held (A) was refused by the contract's held-input rule over the same Level 2 offer; its release re-armed the panel
mouse: one click took exactly one card; 2 clicks took 2 cards
a new Enter took A's chained Level 4 and Level 5 offers and D's chained Level 2; the D-pad and a new (A) took B's chained Level 2 (Combat and Defence); a new click took C's chained Level 2 (Utility)
A [99, 1000102, 2000105, 3000108, 4000111, 5000114] / B [99, 1000102] / C [99, 1000102] / D [99, 1000102] / E [99] — each G2's own for levels 1, 2, 3 … in order; each expedition's G4 twin consumed exactly those, once each
after each of the 8 closing choices, taking the same lane again through H8 answered 'no offer is open; one must be opened before a lane may be taken'
A1 0, A2 0, A3 375, A4 200, A5 0, A6 0, B1 150, B2 25, C1 150, C2 25, D1 125, D2 0, E1 0 — each equal to the G4 twin's and to the review's own last_retained_experience
A: the escort — alive, AI on — unmoved across both chained offers and 80 held frames: position, state, state time, Life, the sweep count, drops 8 / uncollected 0, attacks and destination identical; after the close it moved again and the sweep ran again
A: Esc, (B), F5, F8, F6, [, a right click and a left click on the backdrop over the chained Level 4 offer — the same offer, 0 choices, no attack, no destination, pickup, grid, camera and expedition unchanged
B: the player 0.00 m from the pending mote; 40 frames: 0 sweep(s), 1 uncollected, experience 150.0, its marker shown; the first sweep after the panel closed collected [4]
C: the escort, alive with its AI on, unmoved across the chained panel and 40 held frames, and moving again once the panel closed
B at Level 2: 'Combat and Defence — Power (+10% Global Damage)'; card_power 0 -> 1, pairs [quick_strike -> sweeping_edge] and 1 rank(s) unchanged
C at Level 2: 'Utility — Magnetism (+25% Pickup Radius)'; card_magnetism 0 -> 1, pairs [quick_strike -> sweeping_edge] and 1 rank(s) unchanged
max speed 5.0 m/s, action time 0.80 s (effective 0.80 s), reach 1.65 m, arc 100 deg, cone 65 deg, +0% attack speed — identical after all 13 choices, the fallback and both passive lanes included
6 of 6 expeditions (A, B, C, D by death, E by completion, F) ended with no runtime, attempted level 0, no record or receipt, the panel closed and the world running
6 expeditions (5 given seed 99 again by staging), 10 fixture Graveblades registered and killed, 14 offer opening(s) asked by the review, 13 level-ups taken through its panel, 5 offers shown in place of a chosen one
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
step "5. The third-party inventory has not moved — the review extracts nothing"

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
		shots_log="/tmp/riftwrought_repeated_level_up_offer_loop_shots_$resolution.log"
		run_verification "$shots_log" --path "$PROJECT_DIR" --resolution "$resolution" \
			--script "res://$THIS_VERIFICATION" -- --seed "$ROUTE_SEED" --shots "$target"
		shots_status=$?
		printf '  %s verification exit status: %s\n' "$resolution" "$shots_status"
		assert_log_is_fresh "$shots_log"
		assert_no_script_error "the $resolution rendered run" "$shots_log"
		assert_engine_output "the $resolution rendered run" "$shots_log"
		rendered_count="$(read_check_count "ROGUELITE REPEATED LEVEL-UP OFFER LOOP VERIFICATION" "$shots_log")"
		if [[ "$shots_status" == "0" && "$rendered_count" == "$EXPECTED_CHECKS" ]]; then
			pass "the $resolution rendered run exits 0 at the same pinned $EXPECTED_CHECKS checks"
		else
			fail "the $resolution rendered run exits $shots_status at ${rendered_count:-no} checks, not $EXPECTED_CHECKS"
			grep -E "^  FAIL" "$shots_log" | head -10 | sed 's/^/        /'
		fi
		measured_here=0
		for panel_line in "the Level 2 offer: 15 of 15 visible text controls on screen" \
				"the chained Level 4 offer: 15 of 15 visible text controls on screen" \
				"the fallback offer: 15 of 15 visible text controls on screen" \
				"the fallback receipt: 5 lines on screen inside the review panel, clear of the centre"; do
			grep -qF -- "$panel_line" "$shots_log" && measured_here=$((measured_here + 1))
		done
		if [[ "$measured_here" == "4" ]]; then
			pass "at $resolution the later offer, the chained offer, the fallback offer and the fallback receipt are on screen, apart, centred and unobstructed"
		else
			fail "at $resolution only $measured_here of 4 on-screen measurements were reported"
		fi
		shots=0
		for stem in 01_later_offer 02_chained_offer 03_fallback_offer 04_fallback_receipt; do
			frame="$target/$stem.png"
			if [[ -f "$frame" && "$(stat -f %m "$frame")" -ge "$RUN_STARTED_AT" && "$(wc -c < "$frame" | tr -d ' ')" -gt 20000 ]]; then
				shots=$((shots + 1))
			else
				fail "$stem.png was not freshly captured at $resolution"
			fi
		done
		if [[ "$shots" == "4" ]]; then
			pass "all four evidence frames freshly captured into $target"
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
	pass "all ${#PRESERVED_FILES[@]} protected files outside game/ are byte-identical"
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
	printf 'ROGUELITE REPEATED LEVEL-UP OFFER LOOP SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; game/ and %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite I11 — Repeated Playable Level-Up Offer Loop V1 is DELIVERED under D-314\n'
	printf '  and ACCEPTED and CLOSED at the playable greybox repeated level-up offer-loop review\n'
	printf '  level under D-315.\n'
	reached_end=1
	exit 0
else
	printf 'ROGUELITE REPEATED LEVEL-UP OFFER LOOP SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
