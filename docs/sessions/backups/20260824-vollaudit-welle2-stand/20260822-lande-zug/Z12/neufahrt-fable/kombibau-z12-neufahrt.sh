#!/bin/bash
# Z12-NEUFAHRT-FABLE: K17/T-11b-Endstand-Kombibau {gcc,clang}x{Release,Debug}
# am Endstand 943c70ee, INKREMENTELL auf den bestehenden 4 Zellen-Verzeichnissen
# (Lead-Order 24.08.: Teil-Bauten fortsetzen, ctest-Bilanz FRISCH messen).
# Form = Vorbild kombibau-z12-o2std.sh (Z10-Rezept): J-1-7er LITERAL,
# PRUEFLINGE-Var, RE-CONFIGURE, all, Facade comdare_profile_run_facade,
# comdare_tests, ctest --no-tests=error. ASCII-only. Selbstcheck: Skript
# schreibt NUR nach $OUT und in die 4 Bau-Verzeichnisse.
set -u
CE=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
OUT=/home/comdare/backups-workflow/20260822-lande-zug/Z12/neufahrt-fable
mkdir -p "$OUT"
cd "$CE" || exit 9
HEADSHA=$(git rev-parse HEAD)
echo "KOMBIBAU-Z12-NEUFAHRT ENDSTAND $HEADSHA $(date -u +%FT%TZ)"
if [ "$HEADSHA" != "943c70ee52796da8dede7ace1bf3a370a0994d16" ]; then
  echo "ABBRUCH: HEAD ist nicht der erwartete Endstand 943c70ee"; exit 8
fi
if [ -n "$(git status --porcelain)" ]; then
  echo "ABBRUCH: Baum nicht sauber (porcelain != 0)"; exit 8
fi
FAIL=0
TOOLS="comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli comdare_axis_registry_gen comdare_catalog_codegen_cli comdare_measurement_axis_registry_gen comdare_overlay_source_hash_gen comdare_system_axis_registry_gen"
FACADE="comdare_profile_run_facade"
PRUEFLINGE="$CE/tests/pruefling_fixture"

zelle() {
  local NAME=$1 BDIR=$2 CC=$3 CXX=$4 TYP=$5
  echo "===== ZELLE $NAME ($CC/$TYP) START $(date -u +%T) ====="
  df -h / | tail -1
  local ARGS=(--with-generator=Ninja --enable-build-tests --build-dir="$BDIR" -DCOMDARE_CE_PRUEFLINGE="$PRUEFLINGE")
  [ "$TYP" = Debug ] && ARGS+=(--with-build-type=Debug)
  echo "-- Schritt 1: Configure --"
  CC=$CC CXX=$CXX ./configure.sh "${ARGS[@]}" > "$OUT/$NAME-1configure.log" 2>&1
  RC=$?
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME CONFIGURE-ROT rc=$RC"; FAIL=1; return; fi
  echo "-- Schritt 2: 7 Werkzeuge + Facade bauen --"
  cmake --build "$BDIR" --target $TOOLS $FACADE -j 24 > "$OUT/$NAME-2tools.log" 2>&1
  RC=$?
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME WERKZEUGBAU-ROT rc=$RC"; FAIL=1; return; fi
  echo "-- Schritt 3: RE-CONFIGURE --"
  CC=$CC CXX=$CXX ./configure.sh "${ARGS[@]}" > "$OUT/$NAME-3reconfigure.log" 2>&1
  RC=$?
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME RECONFIGURE-ROT rc=$RC"; FAIL=1; return; fi
  echo "-- Schritt 4: Vollbau (all) --"
  cmake --build "$BDIR" --target all -j 24 > "$OUT/$NAME-4build.log" 2>&1
  RC=$?
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME BUILD-ROT rc=$RC"; FAIL=1; return; fi
  echo "-- Schritt 5: comdare_tests --"
  cmake --build "$BDIR" --target comdare_tests -j 24 > "$OUT/$NAME-5testsbuild.log" 2>&1
  RC=$?
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME TESTSBUILD-ROT rc=$RC"; FAIL=1; return; fi
  echo "-- Schritt 6: ctest (FRISCH) --"
  ctest --test-dir "$BDIR" --no-tests=error --output-on-failure > "$OUT/$NAME-6ctest.log" 2>&1
  RC=$?
  grep -E "tests passed|tests failed out of" "$OUT/$NAME-6ctest.log" || true
  echo "FRISCH-BELEG LastTest.log: $(ls --time-style=+%FT%TZ -la "$CE/$BDIR/Testing/Temporary/LastTest.log" | awk '{print $6}')"
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME CTEST-ROT rc=$RC"; FAIL=1; else echo "ZELLE $NAME GRUEN"; fi
  df -h / | tail -1
}

zelle gcc-rel   build-l1        gcc-15   g++-15     Release
zelle clang-rel build-l1-clang  clang-22 clang++-22 Release
zelle gcc-dbg   build-dbg       gcc-15   g++-15     Debug
zelle clang-dbg build-dbg-clang clang-22 clang++-22 Debug
echo "KOMBIBAU-Z12-NEUFAHRT-ENDE FAIL=$FAIL $(date -u +%FT%TZ)"
exit $FAIL
