#!/bin/sh
# BUMP15-VOLLABNAHME Zell-Wrapper (Strang A) -- nach Vorstrecken-Vorbild fixstrecke2_c*_master.log
# Aufruf: vollabnahme_zelle.sh <N> <CC> <CXX> <TYPE> <DIR-relativ> <frisch|inkrementell>
set -u
N="$1"; CC="$2"; CXX="$3"; TYPE="$4"; DIR="$5"; MODE="$6"
SRC=/home/comdare/wt-ce-bump15
LOGD=/home/comdare/backups-workflow/20260819-fixstrecke2-logs
M="$LOGD/vollabnahme_79171599_c${N}_master.log"
P="$LOGD/vollabnahme_79171599_c${N}"
SLOTD=/home/comdare/.claude/jobs/5a19728e/tmp/bauslots
SLOT="$SLOTD/strangA_bump15_c${N}.slot"
J=16

echo "=== BUMP15-VOLLABNAHME ZELLE ${N}: CC=$CC CXX=$CXX TYPE=$TYPE DIR=$SRC/$DIR MODE=$MODE START=$(date -Is)" > "$M"
cd "$SRC" || { echo "CD_FAIL" >> "$M"; exit 2; }
echo "TIP_AM_START $(git rev-parse HEAD) $(git log -1 --format=%s)" >> "$M"

# DF-GATE: unter 5G warten (Heartbeat ins Log), NIE die Abnahme abbrechen
i=0
while :; do
  availK=$(df -P /home/comdare | awk 'NR==2{print $4}')
  availH=$(df -h /home/comdare | awk 'NR==2{print $4}')
  if [ "$availK" -ge 5242880 ]; then echo "DF_GATE avail=${availH} limit=5G" >> "$M"; break; fi
  i=$((i+1)); echo "DF_WAIT iter=$i avail=${availH} limit=5G (warte 30s auf Raeumung des Parallel-Strangs)" >> "$M"
  if [ $i -ge 240 ]; then echo "DF_WAIT_NOT_RESOLVED nach 240x30s -- Zelle nicht gestartet, erneuter Anlauf noetig" >> "$M"; exit 3; fi
  sleep 30
done

# BAU-SLOT: Deckel 3 (ein weiterer Lande-Steward kann zeitweise bauen)
i=0
while :; do
  n=$(ls "$SLOTD" 2>/dev/null | wc -l)
  if [ "$n" -lt 3 ]; then break; fi
  i=$((i+1)); echo "SLOT_WAIT iter=$i belegte_slots=$n deckel=3" >> "$M"
  if [ $i -ge 240 ]; then echo "SLOT_WAIT_NOT_RESOLVED nach 240x30s" >> "$M"; exit 3; fi
  sleep 30
done
echo "strangA_bump15 c${N} pid=$$ start=$(date -Is)" > "$SLOT"
trap 'rm -f "$SLOT"' EXIT INT TERM
echo "SLOT_GENOMMEN $(basename "$SLOT") belegte_slots_jetzt=$(ls "$SLOTD" | wc -l) deckel=3" >> "$M"

# MODE=frisch: Belegpruefung DIREKT vor rm (git ls-files + find csv/xlsx beide 0), dann raeumen
if [ "$MODE" = "frisch" ]; then
  tracked=$(git ls-files "$DIR/" | wc -l)
  daten=$(find "$DIR" \( -name '*.csv' -o -name '*.xlsx' \) 2>/dev/null | wc -l)
  echo "BELEGPRUEFUNG_VOR_RM tracked=$tracked csv_xlsx=$daten" >> "$M"
  if [ "$tracked" -ne 0 ] || [ "$daten" -ne 0 ]; then echo "RM_VERWEIGERT Belege vorhanden" >> "$M"; exit 4; fi
  rm -rf "$DIR"
  echo "FRISCH_GERAEUMT $DIR" >> "$M"
fi

phase_rc() {
  echo "PHASE_$1 RC=$2" >> "$M"
  if [ "$2" -ne 0 ]; then echo "CELL_ABBRUCH in PHASE_$1 (Log: ${P}_$3.log)" >> "$M"; exit 5; fi
}

# PHASE_CONF (J-Treppe Stufe 1; inkrementell = RE-CONFIGURE des bestehenden Caches)
# Frisch-Configure traegt die VOLLE Abnahme-Konfiguration inkl. Pruefling-Zusicherung
# (COMDARE_CE_PRUEFLINGE=tests/pruefling_fixture, Zusicherung pruefling_slots_v1 durch
# fixture_min) -- ohne sie ist der Block pruefling_slots_v1 deklariert UEBERSPRUNGEN
# und ctest zaehlt 506 statt 507 (Befund c2-Anlauf-1).
PRUEFLINGE="$SRC/tests/pruefling_fixture"
if [ "$MODE" = "frisch" ]; then
  cmake -S "$SRC" -B "$DIR" -DCMAKE_BUILD_TYPE="$TYPE" -DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" -DCOMDARE_CE_PRUEFLINGE="$PRUEFLINGE" > "${P}_conf.log" 2>&1; rc=$?
else
  cmake -S "$SRC" -B "$DIR" > "${P}_conf.log" 2>&1; rc=$?
fi
pf=$(grep '^COMDARE_CE_PRUEFLINGE:' "$DIR/CMakeCache.txt" 2>/dev/null | head -1 | cut -d= -f2)
echo "CONF_PRUEFLINGE=$pf" >> "$M"
bt=$(grep '^CMAKE_BUILD_TYPE:' "$DIR/CMakeCache.txt" 2>/dev/null | head -1 | cut -d= -f2)
cxx_ist=$(grep '^CMAKE_CXX_COMPILER:' "$DIR/CMakeCache.txt" 2>/dev/null | head -1 | cut -d= -f2)
echo "CACHE_SOLL_IST BT=$TYPE/$bt CXX=$CXX/$cxx_ist" >> "$M"
if [ "$(basename "$cxx_ist")" != "$(basename "$CXX")" ] || [ "$bt" != "$TYPE" ]; then
  echo "MISCHBAU_ALARM soll=$TYPE/$CXX ist=$bt/$cxx_ist -- Zelle gestoppt" >> "$M"; exit 6
fi
phase_rc CONF $rc conf

# PHASE_TOOLS: Werkzeuge inkl. comdare_anatomy_codegen_cli + comdare_gen_golden_fullpilot
cmake --build "$DIR" --target comdare_anatomy_codegen_cli comdare_gen_golden_fullpilot -j$J > "${P}_tools.log" 2>&1
phase_rc TOOLS $? tools

# PHASE_RECONF: RE-CONFIGURE nach Werkzeugbau
cmake -S "$SRC" -B "$DIR" > "${P}_reconf.log" 2>&1
phase_rc RECONF $? reconf

# PHASE_ALL: Vollbau
cmake --build "$DIR" --target all -j$J > "${P}_all.log" 2>&1
phase_rc ALL $? all

# PHASE_RECONF2: RE-CONFIGURE nach Vollbau (adhoc-Emitter-Bloecke werden AKTIV)
cmake -S "$SRC" -B "$DIR" > "${P}_reconf2.log" 2>&1
phase_rc RECONF2 $? reconf2

# PHASE_FACADE
cmake --build "$DIR" --target comdare_profile_run_facade -j$J > "${P}_facade.log" 2>&1
phase_rc FACADE $? facade

# PHASE_TESTS
cmake --build "$DIR" --target comdare_tests -j$J > "${P}_tests.log" 2>&1
phase_rc TESTS $? tests

# REGISTRIERUNGS-PROTOKOLL
echo "== REGISTRIERUNGS-PROTOKOLL ($SRC/$DIR/comdare_registrierungs_protokoll.txt):" >> "$M"
cat "$DIR/comdare_registrierungs_protokoll.txt" >> "$M" 2>&1

# CTEST-ZAEHLUNG
( cd "$DIR" && ctest -N ) > "${P}_ctestN.log" 2>&1
echo "== CTEST_ZAEHLUNG (ctest -N tail -2):" >> "$M"
tail -2 "${P}_ctestN.log" >> "$M"

# VOLLER CTEST
( cd "$DIR" && ctest --no-tests=error ) > "${P}_ctest.log" 2>&1; RCT=$?
echo "PHASE_CTEST RC=$RCT" >> "$M"
echo "== CTEST_SUMMENZEILE (literal, mit out-of-N):" >> "$M"
grep -E "tests passed|tests failed" "${P}_ctest.log" | head -2 >> "$M"
echo "== CTEST_SCHLUSS (tail -4):" >> "$M"
tail -4 "${P}_ctest.log" >> "$M"

# TABU-PROBE NACH ZELLE
echo "== TABU_PROBE_NACH_ZELLE:" >> "$M"
sha256sum libs/cache_engine/algorithm_profiles/permutation_axes.xml \
  tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt \
  tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids_abi4.txt \
  tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids_abi5.txt \
  tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids_abi6.txt >> "$M"
grep -n "kNewGolden131072Crc64 = 0x" libs/cache_engine/profile_facade/source_catalog.hpp >> "$M"

echo "DONE_CELL${N}_RC_CTEST=$RCT" >> "$M"
echo "ENDE vollabnahme_79171599_c${N} $(date -Is)" >> "$M"
exit $RCT
