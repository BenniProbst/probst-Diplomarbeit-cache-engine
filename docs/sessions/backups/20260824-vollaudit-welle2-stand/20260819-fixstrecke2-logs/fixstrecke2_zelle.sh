#!/bin/bash
# fixstrecke2_zelle.sh -- ABNAHME FIX-STRECKE 2 (A2.5, #15-Bump-Bruch): EIN Zellen-Lauf
# der vollen J-Treppe am End-Tip von /home/comdare/wt-ce-bump15 (J-1 Werkzeuge ->
# J-2 RE-CONFIGURE -> Vollbau all -> RECONF2 (Nachtrag 10.08.) ->
# comdare_profile_run_facade -> comdare_tests -> voller ctest --no-tests=error).
# Ableitung des bewaehrten g2nachweis_zelle.sh (20260819-g2-nachweis-cb856212).
# ASCII-only. Aufruf: fixstrecke2_zelle.sh N CC_SOLL CXX_SOLL BT_SOLL BUILDDIR
# Zellen: 1=gcc-debug 2=gcc-release 3=clang-debug 4=clang-release (SEQUENTIELL).
# selfcheck: bash -n OK; 0 Non-ASCII; 0 Zeilen ueber 120
set -u
N="$1"; CCS="$2"; CXS="$3"; BTS="$4"; BD="$5"
SRC=/home/comdare/wt-ce-bump15
BK=/home/comdare/backups-workflow/20260819-fixstrecke2-logs
ML="$BK/fixstrecke2_c${N}_master.log"
JOBS=12
GREP=/usr/bin/grep
# Target-Namen am bump15-Stand nachgemessen (add_executable/add_custom_target in
# CMakeLists/cmake): der Emitter heisst HIER comdare_adhoc_emitter_cli, dazu kommt
# comdare_catalog_codegen_cli; Anlauf 1 mit dem g2-Satz brach mit
# "No rule to make target 'comdare-adhoc-emitter'" (fixstrecke2_c1_tools_anlauf1_targetname.log).
TOOLS="comdare_adhoc_emitter_cli comdare_catalog_codegen_cli comdare_limits_generated_source_catalog"
TOOLS="$TOOLS comdare_axis_registry_gen comdare_system_axis_registry_gen"
TOOLS="$TOOLS comdare_measurement_axis_registry_gen comdare_gen_golden_fullpilot comdare_anatomy_codegen_cli"

log() { echo "$*" >> "$ML"; }
abbruch() { log "$1"; log "DONE_CELL${N}_RC_CTEST=$2"; log "ENDE fixstrecke2_c${N} $(date -Is)"; exit "$2"; }

echo "=== FIXSTRECKE2-ABNAHME ZELLE ${N}: CC=${CCS} CXX=${CXS} TYPE=${BTS} DIR=${BD} START=$(date -Is)" > "$ML"
git -C "$SRC" log -1 --format='TIP_AM_START %H %s' >> "$ML" 2>&1

# df-Gate: unter 5G wird NICHT gebaut
AVAIL=$(df --output=avail -BG /home/comdare | tail -1 | tr -dc '0-9')
log "DF_GATE avail=${AVAIL}G limit=5G"
[ "$AVAIL" -lt 5 ] && abbruch "DFGATE_FAIL" 99

# Cache-SOLL/IST-Wache: die Zelle baut nur, wenn der vorhandene Cache Typ+Compiler traegt
BT_IST=$($GREP -E '^CMAKE_BUILD_TYPE:' "$BD/CMakeCache.txt" | cut -d= -f2)
CX_IST=$($GREP -E '^CMAKE_CXX_COMPILER:' "$BD/CMakeCache.txt" | head -1 | cut -d= -f2)
log "CACHE_SOLL_IST BT=${BTS}/${BT_IST} CXX=${CXS}/${CX_IST}"
# Basename-GLEICHHEIT, kein Substring: Release-Caches tragen "g++"/"clang++" ohne
# Pfad (UNINITIALIZED aus dem Preset-Aufruf), und "clang++" ENDET auf "g++" --
# ein Substring-Match waere eine falsch-gruene Wache (Anlauf 1: CACHE_CXX_FREMD).
[ "$(basename "$CX_IST")" = "$(basename "$CXS")" ] || abbruch "CACHE_CXX_FREMD" 90
[ "$BT_IST" = "$BTS" ] || abbruch "CACHE_BT_FREMD" 89

# PHASE_CONF (Re-Configure aus dem vorhandenen Cache dieser Zelle)
cmake -S "$SRC" -B "$BD" > "$BK/fixstrecke2_c${N}_conf.log" 2>&1
RC=$?; log "PHASE_CONF RC=$RC"; [ "$RC" -ne 0 ] && abbruch "CONF_ROT" 98

# PHASE_TOOLS (J-1: Werkzeuge ZUERST, inkl. comdare_anatomy_codegen_cli)
# shellcheck disable=SC2086
cmake --build "$BD" -j "$JOBS" --target $TOOLS > "$BK/fixstrecke2_c${N}_tools.log" 2>&1
RC=$?; log "PHASE_TOOLS RC=$RC"; [ "$RC" -ne 0 ] && abbruch "TOOLS_ROT" 97

# PHASE_RECONF (J-2: Configure-Zeit-Codegen laeuft HIER)
cmake -S "$SRC" -B "$BD" > "$BK/fixstrecke2_c${N}_reconf.log" 2>&1
RC=$?; log "PHASE_RECONF RC=$RC"; [ "$RC" -ne 0 ] && abbruch "RECONF_ROT" 96

# PHASE_ALL (Vollbau)
cmake --build "$BD" -j "$JOBS" --target all > "$BK/fixstrecke2_c${N}_all.log" 2>&1
RC=$?; log "PHASE_ALL RC=$RC"; [ "$RC" -ne 0 ] && abbruch "ALL_ROT" 95

# PHASE_RECONF2 (Nachtrag 10.08.: die Kette ist all -> RECONFIGURE -> comdare_tests)
cmake -S "$SRC" -B "$BD" > "$BK/fixstrecke2_c${N}_reconf2.log" 2>&1
RC=$?; log "PHASE_RECONF2 RC=$RC"; [ "$RC" -ne 0 ] && abbruch "RECONF2_ROT" 94

# PHASE_FACADE (Fassaden-TU liegt NICHT im all-Ziel)
cmake --build "$BD" -j "$JOBS" --target comdare_profile_run_facade > "$BK/fixstrecke2_c${N}_facade.log" 2>&1
RC=$?; log "PHASE_FACADE RC=$RC"; [ "$RC" -ne 0 ] && abbruch "FACADE_ROT" 93

# PHASE_TESTS (EXCLUDE_FROM_ALL-Sammelziel)
cmake --build "$BD" -j "$JOBS" --target comdare_tests > "$BK/fixstrecke2_c${N}_tests.log" 2>&1
RC=$?; log "PHASE_TESTS RC=$RC"; [ "$RC" -ne 0 ] && abbruch "TESTS_ROT" 92

# REGISTRIERUNGS-PROTOKOLL (Protokoll-Stand + ctest-N IMMER zusammen nennen)
log "== REGISTRIERUNGS-PROTOKOLL (${BD}/comdare_registrierungs_protokoll.txt):"
if [ -f "$BD/comdare_registrierungs_protokoll.txt" ]; then
  cat "$BD/comdare_registrierungs_protokoll.txt" >> "$ML"
else
  log "PROTOKOLL_DATEI_FEHLT"
fi
log "== CTEST_ZAEHLUNG (ctest -N tail -2):"
( cd "$BD" && ctest -N > "$BK/fixstrecke2_c${N}_ctestN.log" 2>&1 )
tail -2 "$BK/fixstrecke2_c${N}_ctestN.log" >> "$ML"

# PHASE_CTEST (VOLLER Lauf)
( cd "$BD" && ctest --no-tests=error --output-on-failure > "$BK/fixstrecke2_c${N}_ctest.log" 2>&1 )
RCC=$?
log "PHASE_CTEST RC=$RCC"
log "== CTEST_SUMMENZEILE (literal, mit out-of-N):"
$GREP -E "tests (passed|failed)" "$BK/fixstrecke2_c${N}_ctest.log" | tail -1 >> "$ML"
log "== CTEST_SCHLUSS (tail -4):"
tail -4 "$BK/fixstrecke2_c${N}_ctest.log" >> "$ML"

# TABU-WACHE je Zelle (5 golden-Pfade + Konstante; SOLL siehe g4_tabu_nach_gruppe_b.txt)
log "== TABU_PROBE_NACH_ZELLE:"
( cd "$SRC" && sha256sum libs/cache_engine/algorithm_profiles/permutation_axes.xml \
    tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt \
    tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids_abi4.txt \
    tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids_abi5.txt \
    tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids_abi6.txt ) >> "$ML" 2>&1
$GREP -n "kNewGolden131072Crc64 = 0x" "$SRC/libs/cache_engine/profile_facade/source_catalog.hpp" >> "$ML"

log "DONE_CELL${N}_RC_CTEST=$RCC"
log "ENDE fixstrecke2_c${N} $(date -Is)"
exit "$RCC"
