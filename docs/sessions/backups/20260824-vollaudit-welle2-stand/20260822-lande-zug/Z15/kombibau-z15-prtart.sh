#!/bin/bash
# Z15/W1L-4: prt-art-Kombibau sinngemaess T-11b -- 4 Zellen {gcc,clang}x{Release,Debug}
# am gemergten Endstand, CI-aequivalentes Layout (ce-pin @ COMDARE_CE_PIN_SHA in der Wurzel).
# Vorbild: kombibau-cifix-varwache.sh (juengste erfolgreiche Landung), prt-art-angepasst.
set -u
PRT=/home/comdare/Projekte/Research/comdare-prt-art
CE_SPENDER=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
PIN=66de5c0972290ec1ae3d219988ecc207d8f5de6b
OUT=/home/comdare/backups-workflow/20260822-lande-zug/Z15
cd "$PRT" || exit 9
echo "KOMBIBAU-Z15-ENDSTAND $(git rev-parse --short HEAD) $(date -u +%FT%TZ)"
df -h / | tail -1

# CI-aequivalenter ce-Pin-Klon (T9-ERGEBNIS-Rezept: Netz-URL lokal durch Pfad-Klon ersetzt)
if [ ! -d ce-pin ]; then
  git clone --no-checkout "$CE_SPENDER" ce-pin > "$OUT/ce-pin-klon.log" 2>&1 || { echo "CE-PIN-KLON-ROT"; exit 8; }
fi
git -C ce-pin checkout --detach "$PIN" >> "$OUT/ce-pin-klon.log" 2>&1 || { echo "CE-PIN-CHECKOUT-ROT"; exit 8; }
echo "ce-Pin ausgecheckt: $(git -C ce-pin rev-parse HEAD) (SOLL $PIN)" | tee -a "$OUT/ce-pin-klon.log"

FAIL=0
zelle() {
  local NAME=$1 BDIR=$2 CC=$3 CXX=$4 TYP=$5
  echo "===== ZELLE $NAME ($CXX/$TYP) START $(date -u +%T) ====="
  cmake -B "$BDIR" -G Ninja -DCMAKE_BUILD_TYPE="$TYP" \
    -DCMAKE_C_COMPILER="$CC" -DCMAKE_CXX_COMPILER="$CXX" \
    -DCMAKE_C_COMPILER_LAUNCHER=ccache -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCOMDARE_CACHE_ENGINE_DIR="$PWD/ce-pin" > "$OUT/$NAME-configure.log" 2>&1
  local RC=${PIPESTATUS[0]}
  [ $RC -ne 0 ] && { echo "ZELLE $NAME CONFIGURE-ROT rc=$RC"; FAIL=1; return; }
  cmake --build "$BDIR" --parallel 12 > "$OUT/$NAME-build.log" 2>&1
  RC=${PIPESTATUS[0]}
  [ $RC -ne 0 ] && { echo "ZELLE $NAME BUILD-ROT rc=$RC"; FAIL=1; return; }
  ctest --test-dir "$BDIR" --no-tests=error --output-on-failure > "$OUT/$NAME-ctest.log" 2>&1
  RC=${PIPESTATUS[0]}
  grep -E "tests passed|tests failed out of" "$OUT/$NAME-ctest.log" || true
  if [ $RC -ne 0 ]; then echo "ZELLE $NAME CTEST-ROT rc=$RC"; FAIL=1; else echo "ZELLE $NAME GRUEN"; fi
}
zelle gcc-rel   build-z15-gcc-rel   gcc   g++     Release
zelle gcc-dbg   build-z15-gcc-dbg   gcc   g++     Debug
zelle clang-rel build-z15-clang-rel clang clang++ Release
zelle clang-dbg build-z15-clang-dbg clang clang++ Debug
df -h / | tail -1
echo "KOMBIBAU-Z15-ENDE FAIL=$FAIL $(date -u +%FT%TZ)"
exit $FAIL
