#!/usr/bin/env bash
# Riftwrought — P1A: Character Scale and Rendering Lock — focused runner.
#
# P1A IS ACCEPTED AND CLOSED under D-356. This runner is now the regression guard over
# what that acceptance locked: rendering mode 7 (display-pinned fractional fill), the
# 1920 x 1080 base and default output, 60.0 px/m, the 128 x 128 character cell, the
# (64, 122) ground anchor and the 120 x 60 isometric tile. The twelve original checks
# are unchanged and still run.
#
# A PLAIN INVOCATION IS HEADLESS ONLY. It opens no window, renders nothing and writes
# no image. Rendered evidence is opt-in behind `--shots <dir>`, because a rendered run
# takes the owner's real pointer and keyboard while it is up.
#
#   bash game2d/tests/p1a_smoke.sh                     # headless checks only
#   bash game2d/tests/p1a_smoke.sh --shots <dir>       # ... and capture rendered evidence
#   bash game2d/tests/p1a_smoke.sh --report <file>     # ... and write the measurement JSON
#
# WHAT IT PROVES
#   1. every P1A script parses, and this runner parses;
#   2. the two imported PNGs are byte-identical to the owner's own exports, proved by
#      SHA-256 against BOTH the recorded value and the source file, with the pin shown
#      to refuse an altered digest;
#   3. `game/` is untouched — file count and whole-subtree digest, `.DS_Store` pruned
#      and never hashed, `game/.godot/` neither read into the digest nor regenerated;
#   4. the headless verification passes, and its own log is pinned in BOTH directions:
#      the run token, the check count, the owed count, the deferred count and the
#      transferred-debt count are each replayed with one value altered and each pin is
#      required to refuse it;
#   5. the locked constants agree on every surface that states them, the canonical
#      rendering mode behaves as ruled (exact scaling at 1920x1080 and its integer
#      multiples, a stationary display grid, and a world extent that never grows with
#      the window), the Mage is recorded as non-conforming legacy art with its
#      reconstruction obligation, and the detached fragments are classified.
#
# WHAT IT CANNOT PROVE, and says so: that the locked presentation LOOKS right. That was
# the owner's live judgement and it produced D-356. A GREEN RUN IS NOT P1A ACCEPTANCE —
# acceptance is the owner's ruling, and this runner only guards what the ruling locked.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$HERE/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"

SHOTS=""
REPORT=""
while [ $# -gt 0 ]; do
	case "$1" in
		--shots) SHOTS="${2:-}"; shift 2 ;;
		--report) REPORT="${2:-}"; shift 2 ;;
		*) echo "unknown argument: $1" >&2; exit 2 ;;
	esac
done

# Godot resolves a relative OS path against the project directory given by `--path`, not
# against the caller's working directory, so a relative `--report` was written inside
# `game2d/` and then failed. Both output paths are made absolute here, after parsing, so
# they land where the caller meant.
case "$SHOTS" in "" | /*) ;; *) SHOTS="$(pwd)/$SHOTS" ;; esac
case "$REPORT" in "" | /*) ;; *) REPORT="$(pwd)/$REPORT" ;; esac

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

FAILURES=0
step() { printf '\n=== %s ===\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; FAILURES=$((FAILURES + 1)); }
note() { printf '  ----  %s\n' "$1"; }

# ---------------------------------------------------------------------------- pins --
#
# Every value below is a MEASUREMENT of the state P1A was delivered in. They move only
# when the thing they measure moves, and re-pinning any of them is an owner decision.

PIN_MAGE_SHA256="70321b212e5f9381f0badd80b29c938465a84289db14fe30e327fe1804d3d671"
PIN_HUNTRESS_SHA256="93c5a713c9d32d3c843cf09e94f5c35bd8883e262afa64e4c3cb65418bb3e740"
PIN_MAGE_SOURCE="assets/Pixel Art/Mage/mage_idle_8_direction_master_v1.png"
PIN_HUNTRESS_SOURCE="assets/Pixel Art/Huntress/Animations/huntress_idle_down_128_v1.png"

# `game/` as P1A found it, and as it must still be. `.DS_Store` is pruned and never
# hashed, per the standing rule; `game/.godot/` IS inside this digest, because the
# whole point is that a 2D run never regenerates it.
PIN_GAME_FILE_COUNT="1482"
PIN_GAME_DIGEST="dbf6258d75f4a7c2a3a1cb42fd99414a393525fe7d02c836a4c37175d7200f51"

# Re-pinned as P1A grew: 12 -> 17 -> 22 -> 23 -> 25 -> 26 -> 30 checks. The last four
# came with P1A's ACCEPTANCE (D-356) and MEASURE the owner's rulings rather than record
# them on trust: the canonical rendering mode and every clause of its rationale, the
# locked production constants agreeing on every surface they are stated on, the Mage
# reconstruction obligation, and the detached fragments.
#
# The deferred list went 5 -> 11 -> 9 -> 7 -> 6 -> 0. It is empty because the live
# rendering comparison those rows waited on was PERFORMED — by the owner, on the owner's
# display — and produced ruling 1. What is left is not deferred work but TRANSFERRED debt
# with a named destination, pinned separately so no later phase can mistake somebody
# else's obligation for a finished one.
PIN_CHECKS="30"
PIN_OWED="30"
PIN_DEFERRED="0"
PIN_TRANSFERRED="6"

RUN_TOKEN="p1a-$$-$(date -u +%Y%m%dT%H%M%SZ)"

P1A_SCRIPTS=(
	"scripts/p1a_art.gd"
	"scripts/p1a_scale.gd"
	"scripts/p1a_render_mode.gd"
	"scripts/p1a_world.gd"
	"scripts/p1a_actor.gd"
	"scripts/p1a_pan.gd"
	"scripts/p1a_comparison_root.gd"
	"tests/p1a_verification.gd"
	"tests/p1a_evidence.gd"
	"tools/p1a_report.gd"
)

printf '\n'
printf 'Riftwrought — P1A Character Scale and Rendering Lock — focused runner\n'
printf '  project   %s\n' "$PROJECT_DIR"
printf '  godot     %s\n' "$("$GODOT" --version 2>/dev/null | head -1)"
printf '  run token %s\n' "$RUN_TOKEN"
printf '  mode      %s\n' "$([ -n "$SHOTS" ] && echo "headless checks + RENDERED evidence into $SHOTS" || echo "headless only — no window, no image")"

# ------------------------------------------------------------------- 1. it parses --
step "1. Every P1A script parses, and this runner parses"
if bash -n "$HERE/p1a_smoke.sh"; then
	pass "the runner parses"
else
	fail "the runner does not parse"
fi
for rel in "${P1A_SCRIPTS[@]}"; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/parse.log" \
		--check-only --script "res://$rel" 2>&1 | grep -v '^Godot Engine' | grep -v '^$')"
	if [ -z "$out" ]; then
		pass "$rel parses"
	else
		fail "$rel: $out"
	fi
done
if [ -f "$PROJECT_DIR/scenes/p1a_comparison.tscn" ]; then
	pass "scenes/p1a_comparison.tscn is present"
else
	fail "the comparison scene is missing"
fi

# --------------------------------------------------------- 2. the owner-art boundary --
step "2. The two imported PNGs are byte-identical copies of the owner's own exports"
check_png() {
	local copy="$1" pin="$2" source_rel="$3" label="$4"
	local digest source_digest
	digest="$(shasum -a 256 "$PROJECT_DIR/$copy" | cut -d' ' -f1)"
	if [ "$digest" = "$pin" ]; then
		pass "$label copy hashes its recorded $pin"
	else
		fail "$label copy hashes $digest, not the recorded $pin"
	fi
	if [ -f "$REPO_DIR/$source_rel" ]; then
		source_digest="$(shasum -a 256 "$REPO_DIR/$source_rel" | cut -d' ' -f1)"
		if [ "$source_digest" = "$digest" ]; then
			pass "$label copy is byte-identical to $source_rel, which is unmodified"
		else
			fail "$label copy $digest differs from its source $source_digest"
		fi
	else
		note "DEFERRED: $source_rel is not present, so the copy cannot be compared to it here"
	fi
	# Both directions: the pin must refuse a digest that is not the recorded one.
	if [ "${digest}0" = "$pin" ]; then
		fail "$label pin accepts an altered digest — it protects nothing"
	else
		pass "$label pin refuses an altered digest"
	fi
}
check_png "assets/characters/mage/mage_idle_8dir_64.png" "$PIN_MAGE_SHA256" "$PIN_MAGE_SOURCE" "mage"

# All eight Huntress idle directions, each against its own exact owner export. The
# mapping is the owner's and is authoritative; note that the north source is spelled
# `huntress_idle_top128_v1.png`, with no underscore between `top` and `128`.
HUNTRESS_DIRS=(
	"e:huntress_idle_right_128_v1.png:767adcc29f6d0ad875416feca0c160016e71313c639b744f9d84f2df946e43d9"
	"se:huntress_idle_bottom_right_128_v1.png:8a0bb98cda3d12141795bf0a4fe1594b723213543607f6e688a5ef322131e189"
	"s:huntress_idle_down_128_v1.png:93c5a713c9d32d3c843cf09e94f5c35bd8883e262afa64e4c3cb65418bb3e740"
	"sw:huntress_idle_down_left_128_v1.png:be2b7937a17621da2472efbad2c041fdb4d197bc5a07009b9fda8cdbada1c039"
	"w:huntress_idle_left_128_v1.png:17b4866b00d4fac9bbe617632c94a064e53375a92c50c1e79175127b8cbd2006"
	"nw:huntress_idle_top_left_128_v1.png:eb34798ce7e17c659a74405621fbcb7b6f56af14e6ff75f4069c9e56174e3ba2"
	"n:huntress_idle_top128_v1.png:4433171f2ea790070654cbb0c8a6e2f2045521e873629fe5a802d2a709be2c54"
	"ne:huntress_idle_top_right_128_v1.png:9cec9cb0cff7c7e7a2788f833ea01d393b23ba5382a8827249e02bda50beae46"
)
for row in "${HUNTRESS_DIRS[@]}"; do
	IFS=: read -r tok src want <<< "$row"
	check_png "assets/characters/huntress/huntress_idle_${tok}.png" "$want" \
		"assets/Pixel Art/Huntress/Animations/$src" "huntress $tok"
done

pxo_count="$(find "$PROJECT_DIR" -type f -iname '*.pxo' | wc -l | tr -d ' ')"
if [ "$pxo_count" = "0" ]; then
	pass "no Pixelorama source file exists anywhere under game2d/"
else
	fail "$pxo_count Pixelorama source file(s) found under game2d/"
fi
image_count="$(find "$PROJECT_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.webp' -o -iname '*.svg' \) \
	-not -path '*/.godot/*' | wc -l | tr -d ' ')"
if [ "$image_count" = "13" ]; then
	pass "exactly 13 image files outside the cache: the Mage strip, the eight Huntress directions, the three Wroughtstone tiles and the icon"
else
	fail "$image_count image files outside the cache; 13 expected"
fi

# ------------------------------------------------------------------- 3. isolation --
step "3. \`game/\` is untouched, and its Godot cache was neither hashed into nor regenerated"
if [ -d "$REPO_DIR/game" ]; then
	game_list="$WORK/game_files.txt"
	( cd "$REPO_DIR/game" && find . -type f ! -name '.DS_Store' -print0 | sort -z | xargs -0 shasum -a 256 ) > "$game_list"
	game_count="$(wc -l < "$game_list" | tr -d ' ')"
	game_digest="$(shasum -a 256 < "$game_list" | cut -d' ' -f1)"
	if [ "$game_count" = "$PIN_GAME_FILE_COUNT" ] && [ "$game_digest" = "$PIN_GAME_DIGEST" ]; then
		pass "game/ is byte-identical: $game_count files, digest ${game_digest:0:16}…"
	else
		fail "game/ moved: $game_count files (pinned $PIN_GAME_FILE_COUNT), digest ${game_digest:0:16}… (pinned ${PIN_GAME_DIGEST:0:16}…)"
	fi
	# Both directions: the digest pin must refuse a changed list.
	altered="$(printf '%s\nx\n' "$(cat "$game_list")" | shasum -a 256 | cut -d' ' -f1)"
	if [ "$altered" != "$PIN_GAME_DIGEST" ]; then
		pass "the game/ digest pin refuses a list with one line added"
	else
		fail "the game/ digest pin accepts an altered list"
	fi
	ds_count="$(find "$REPO_DIR/game" -type f -name '.DS_Store' | wc -l | tr -d ' ')"
	note "$ds_count .DS_Store file(s) under game/ were pruned from the walk and never hashed"
	note "no P1A command names a path under game/; this runner only reads it"
else
	fail "game/ is missing"
fi

# --------------------------------------------------------------- 4. the verification --
step "4. The headless verification, and its log pinned in both directions"
# Re-import FIRST. Every measurement in the verification reads Godot's imported texture,
# not the PNG on disk. Skipping this once let a green suite measure owner art that had
# already been replaced. Check 26 proves the two agree; this is what makes them agree.
"$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/import.log" --import \
	> "$WORK/import.out" 2>&1
import_status=$?
if [ "$import_status" = "0" ]; then
	pass "the texture import cache was refreshed from the PNGs on disk before measuring"
else
	fail "the texture reimport exited $import_status"
fi
verify_log="$WORK/verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/godot_file.log" \
	--script "res://tests/p1a_verification.gd" -- --run-token "$RUN_TOKEN" > "$verify_log" 2>&1
verify_status=$?
if [ "$verify_status" = "0" ]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
fi
if grep -qE '^(ERROR|SCRIPT ERROR|USER ERROR)' "$verify_log"; then
	fail "the verification log carries an engine error, whatever its PASS line says"
	grep -E '^(ERROR|SCRIPT ERROR|USER ERROR)' "$verify_log" | head -5
else
	pass "the verification log carries no engine error"
fi

# Each pin is asserted against this run's own log, and then required to refuse a copy
# of that same log with exactly one value altered. A guard that accepts everything
# protects nothing, and a guard nothing can reach is not a guard.
pin_line() {
	local label="$1" want="$2" tampered="$3"
	if grep -qxF "$want" "$verify_log"; then
		pass "$label: '$want'"
	else
		fail "$label: '$want' is not in the log"
		return
	fi
	sed "s|^$(printf '%s' "$want" | sed 's/[.[\*^$/]/\\&/g')\$|$tampered|" "$verify_log" > "$WORK/tampered.log"
	if grep -qxF "$want" "$WORK/tampered.log"; then
		fail "$label: the pin accepts a log with that line altered"
	else
		pass "$label: the pin refuses a log with that line altered"
	fi
}
pin_line "run token"      "P1A RUN TOKEN: $RUN_TOKEN"                "P1A RUN TOKEN: not-this-run"
pin_line "check count"    "P1A VERIFICATION: PASS ($PIN_CHECKS checks)" "P1A VERIFICATION: PASS ($((PIN_CHECKS + 1)) checks)"
pin_line "owed count"     "P1A OWED CHECKS: $PIN_OWED"               "P1A OWED CHECKS: $((PIN_OWED + 1))"
pin_line "deferred count" "P1A DEFERRED: $PIN_DEFERRED"              "P1A DEFERRED: $((PIN_DEFERRED + 1))"
pin_line "transferred debt" "P1A TRANSFERRED DEBT: $PIN_TRANSFERRED" "P1A TRANSFERRED DEBT: $((PIN_TRANSFERRED - 1))"

if grep -q "owed $PIN_OWED; reached $PIN_OWED" "$verify_log"; then
	pass "the owed set was compared in both directions and nothing was missing or unexpected"
else
	fail "the owed-set comparison line is not in the log"
fi
if grep -q "A GREEN RUN IS NOT P1A ACCEPTANCE" "$verify_log"; then
	pass "the verification says out loud that passing is not acceptance"
else
	fail "the verification does not disclaim acceptance"
fi
# P1A is accepted — by the OWNER, under D-356, after a live comparison no suite can make.
# The verification must keep saying that distinction out loud, and must keep saying that
# P1B is not begun. Acceptance of a phase is the easiest thing to let leak into the next.
if grep -q "Acceptance is the owner" "$verify_log"; then
	pass "the verification attributes acceptance to the owner's ruling, not to its own exit code"
else
	fail "the verification does not attribute acceptance to the owner"
fi
# D-359: P1B was authorized under D-358, so the old "P1B IS NOT BEGUN" assertion became
# false. What still matters is that the suite states P1B's status truthfully and keeps
# saying what P1C's real state is -- phase status is the easiest thing to let leak forward.
if grep -q "P1B IS ACCEPTED AND CLOSED under D-362" "$verify_log" \
	&& grep -q "P1C-H IS BEGUN under D-364" "$verify_log" \
	&& grep -q "ORIGINAL P1C is NOT complete" "$verify_log"; then
	pass "the verification states P1B's status, that P1C-H is begun, and that the ORIGINAL P1C is not complete"
else
	fail "the verification does not state P1B's status and P1C's gating"
fi
note "the verification's own output follows the runner's summary; it is the measurement record"

# ------------------------------------------------------- 5. the machine-readable report --
if [ -n "$REPORT" ]; then
	step "5. The machine-readable measurement report"
	if "$GODOT" --headless --path "$PROJECT_DIR" --log-file "$WORK/report.log" \
			--script "res://tools/p1a_report.gd" -- --out "$REPORT" > "$WORK/report.out" 2>&1; then
		pass "wrote $REPORT"
		note "$(grep -o 'wrote .*' "$WORK/report.out" | head -1)"
	else
		fail "the report tool failed"
		cat "$WORK/report.out"
	fi
else
	step "5. The machine-readable measurement report — NOT REQUESTED"
	note "DEFERRED: pass --report <file> to write it. It is not written by a plain invocation."
fi

# --------------------------------------------------------------- 6. rendered evidence --
if [ -n "$SHOTS" ]; then
	step "6. Rendered evidence — OPT-IN, and this opens a window"
	mkdir -p "$SHOTS"
	if "$GODOT" --path "$PROJECT_DIR" --script "res://tests/p1a_evidence.gd" \
			-- --out "$SHOTS" --density A > "$WORK/shots.log" 2>&1; then
		pass "captured into $SHOTS"
		grep -E 'comparison sheet|CAPTURED' "$WORK/shots.log" | sed 's/^/  ----  /'
	else
		fail "the evidence capture failed"
		grep -E 'PROBLEM|DISAGREE' "$WORK/shots.log" | head -10
	fi
else
	step "6. Rendered evidence — NOT REQUESTED"
	note "DEFERRED: pass --shots <dir> to capture it. A plain invocation stays headless."
fi

# ------------------------------------------------------------------------ summary --
step "Summary"
printf '  P1A is ACCEPTED AND CLOSED under D-356 — by the owner, after a live\n'
printf '  comparison this runner cannot perform. A green runner is still not\n'
printf '  acceptance, and this runner never claims to grant it.\n'
printf '\n'
printf '  LOCKED: rendering mode 7 (display-pinned fractional fill) · base and\n'
printf '  output 1920 x 1080 · 60.0 px/m · 128 x 128 character cell ·\n'
printf '  anchor (64, 122) · 120 x 60 isometric tile = 1 square metre.\n'
printf '  The visible world is FIXED at 32.00 x 18.00 m at every output size.\n'
printf '\n'
printf '  CARRIED OUT OF P1A, owed by a LATER phase — not by this one, not done:\n'
printf '    - HUD, menu, text and accessibility at arbitrary output resolutions\n'
printf '      -> the later UI foundation;\n'
printf '    - a 128 x 128 Mage reconstruction at the locked values -> a future\n'
printf '      art phase; the 64 x 64 exports stay legacy/reference, NOT edited;\n'
printf '    - an optional player-facing pixel-perfect mode -> allowed, NOT\n'
printf '      authorized and NOT implemented;\n'
printf '    - the P1B Wroughtstone 2D Proof Kit -> needs its own explicit ruling;\n'
printf '    - a canonical Huntress class specification -> a P2 prerequisite.\n'
printf '\n'
printf '  P1B IS ACCEPTED AND CLOSED (D-362). P1C-H IS BEGUN (D-364), DELIVERED and OPEN;\n'
printf '  the ORIGINAL P1C is NOT complete and its Mage portion is DEFERRED.\n'
printf '\n'
if [ "$FAILURES" = "0" ]; then
	printf 'P1A SMOKE: PASS\n'
else
	printf 'P1A SMOKE: %d FAILURE(S)\n' "$FAILURES"
fi

printf '\n--- the verification record, in full ---\n'
cat "$verify_log"

[ "$FAILURES" = "0" ] || exit 1
