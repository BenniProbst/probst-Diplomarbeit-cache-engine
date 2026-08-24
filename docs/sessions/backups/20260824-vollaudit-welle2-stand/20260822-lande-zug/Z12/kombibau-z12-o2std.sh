#!/bin/bash
set -u
CE=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
OUT=/home/comdare/backups-workflow/20260822-lande-zug/Z12
mkdir -p "$OUT"
cd "$CE" || exit 9
echo "KOMBIBAU-Z12 ENDSTAND $(git rev-parse --short HEAD) $(date -u +%FT%TZ)"
FAIL=0
TOOLS="comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli comdare_axis_registry_gen comdare_catalog_codegen_cli comdare_measurement_axis_registry_gen comdare_overlay_source_hash_gen comdare_system_axis_registry_gen"
FACADE="comdare_profile_run_facade"
PRUEFLINGE="$CE/tests/pruefling_fixture"

zelle() {
  local NAME=$1 BDIR=$2 CC=$3 CXX=$4 TYP=$5
  echo "===== ZELLE $NAME ($CC/$TYP) START $(date -u +%T) ====="
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
  echo "-- Schritt 6: ctest --"
  ctest --test-dir "$BDIR" --no-tests=error --output-on-failure > "$OUT/$NAME-6ctest.log" 2>&1
  RC=$?
  grep -E "tests passed|tests failed out of" "$OUT/$NAME-6ctest.log" || true
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME CTEST-ROT rc=$RC"; FAIL=1; else echo "ZELLE $NAME GRUEN"; fi
  df -h / | tail -1
}

zelle gcc-rel   build-l1        gcc-15   g++-15     Release
zelle clang-rel build-l1-clang  clang-22 clang++-22 Release
zelle gcc-dbg   build-dbg       gcc-15   g++-15     Debug
zelle clang-dbg build-dbg-clang clang-22 clang++-22 Debug
echo "KOMBIBAU-Z12-ENDE FAIL=$FAIL $(date -u +%FT%TZ)"
exit $FAIL
