#!/bin/bash
# NACHLANDE-r4-KOMBIBAU (K17/T-11b): {gcc,clang} x {Release,Debug} am Soll-Endstand
# (b247a339 + 5a8e2841-cherry + Verschaerfung) VOR dem ZWEITEN Dual-Push.
# G8/H5: J-1 VOLLE 7er-Liste LITERAL -> RE-CONFIGURE (PRUEFLINGE) -> Vollbau ->
# Facade REALES Target comdare_profile_run_facade -> comdare_tests -> ctest
# --no-tests=error. df-Gate je Zelle. Exit-Codes NIE durch Pipes.
# ZUSATZ (Lead-Klarstellung): Test 509 (test_vl3_debug_stdout_bytegleich) 3x in
# der gcc-Debug-Zelle nach den 4 Zellen.
set -u
CE=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
OUT=/home/comdare/backups-workflow/20260822-lande-zug/Z10/nachlande-r4
W7="comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli comdare_axis_registry_gen comdare_catalog_codegen_cli comdare_measurement_axis_registry_gen comdare_overlay_source_hash_gen comdare_system_axis_registry_gen"
cd "$CE" || exit 9
echo "R4-KOMBIBAU-SOLL-ENDSTAND $(git rev-parse --short HEAD) $(date -u +%FT%TZ)"
echo "J-1-LISTE LITERAL: $W7"
FAIL=0
zelle() {
  NAME=$1; BDIR=$2; ZCC=$3; ZCXX=$4; TYP=$5
  echo "===== ZELLE $NAME ($ZCC/$TYP) START $(date -u +%T) ====="
  FREI_G=$(df --output=avail -BG / | tail -1 | tr -dc '0-9')
  echo "DF-GATE $NAME: ${FREI_G}G frei"
  if [ "$FREI_G" -lt 5 ]; then echo "ZELLE $NAME DF-GATE-ROT (<5G) -- ABBRUCH"; FAIL=1; return; fi
  ARGS="--with-generator=Ninja --enable-build-tests --build-dir=$BDIR -DCOMDARE_CE_PRUEFLINGE=$CE/tests/pruefling_fixture"
  if [ "$TYP" = Debug ]; then ARGS="$ARGS --with-build-type=Debug"; fi
  CC=$ZCC CXX=$ZCXX ./configure.sh $ARGS > "$OUT/$NAME-configure.log" 2>&1
  RC=$?; if [ $RC -ne 0 ]; then echo "ZELLE $NAME CONFIGURE-ROT rc=$RC"; FAIL=1; return; fi
  cmake --build "$BDIR" --target $W7 -j 24 > "$OUT/$NAME-j1.log" 2>&1
  RC=$?; if [ $RC -ne 0 ]; then echo "ZELLE $NAME J1-ROT rc=$RC"; FAIL=1; return; fi
  CC=$ZCC CXX=$ZCXX ./configure.sh $ARGS > "$OUT/$NAME-reconfigure.log" 2>&1
  RC=$?; if [ $RC -ne 0 ]; then echo "ZELLE $NAME RECONF-ROT rc=$RC"; FAIL=1; return; fi
  cmake --build "$BDIR" --target all -j 24 > "$OUT/$NAME-build.log" 2>&1
  RC=$?; if [ $RC -ne 0 ]; then echo "ZELLE $NAME BUILD-ROT rc=$RC"; FAIL=1; return; fi
  cmake --build "$BDIR" --target comdare_profile_run_facade -j 24 > "$OUT/$NAME-facade.log" 2>&1
  RC=$?; if [ $RC -ne 0 ]; then echo "ZELLE $NAME FACADE-ROT rc=$RC"; FAIL=1; return; fi
  cmake --build "$BDIR" --target comdare_tests -j 24 > "$OUT/$NAME-tests.log" 2>&1
  RC=$?; if [ $RC -ne 0 ]; then echo "ZELLE $NAME COMDARE_TESTS-ROT rc=$RC"; FAIL=1; return; fi
  ctest --test-dir "$BDIR" --no-tests=error --output-on-failure > "$OUT/$NAME-ctest.log" 2>&1
  RC=$?
  grep -E "tests passed|tests failed out of" "$OUT/$NAME-ctest.log"
  GRC=$?; if [ $GRC -ne 0 ]; then echo "ZELLE $NAME BILANZ-ZEILE FEHLT (grep rc=$GRC)"; fi
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME CTEST-ROT rc=$RC"; FAIL=1; else echo "ZELLE $NAME GRUEN"; fi
}
zelle gcc-rel   build-l1        gcc-15   g++-15     Release
zelle clang-rel build-l1-clang  clang-22 clang++-22 Release
zelle gcc-dbg   build-dbg       gcc-15   g++-15     Debug
zelle clang-dbg build-dbg-clang clang-22 clang++-22 Debug
# Lead-Klarstellung: Test 509/vl3 3x in der gcc-Debug-Zelle (Wiederholungsprobe)
for i in 1 2 3; do
  ctest --test-dir build-dbg --no-tests=error -R "^test_vl3_debug_stdout_bytegleich$" --output-on-failure > "$OUT/vl3-3x-lauf$i.log" 2>&1
  RC=$?
  grep -E "tests passed|tests failed out of" "$OUT/vl3-3x-lauf$i.log"
  if [ $RC -ne 0 ]; then echo "VL3-WIEDERHOLUNG $i ROT rc=$RC"; FAIL=1; else echo "VL3-WIEDERHOLUNG $i GRUEN"; fi
done
echo "R4-KOMBIBAU-ENDE FAIL=$FAIL $(date -u +%FT%TZ)"
exit $FAIL
