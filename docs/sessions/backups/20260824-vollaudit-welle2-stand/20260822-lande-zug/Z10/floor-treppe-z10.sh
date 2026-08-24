#!/bin/bash
# Z10-FLOOR-TREPPE (H-7 + #39-Nachzug-Pflicht): drei Sprossen LIVE am Endstand,
# comm in BEIDE Richtungen, Restore byte-gleich. Rezept: scripts/
# ci_test_inventory_floor.txt Kopf + ~/backups-workflow/20260822-lande-cifix-
# varwache/floor-messung2.log. Läuft im gcc-Release-Baum build-l1 NACH dem
# gruenen Kombibau. Exit-Codes NIE durch Pipes.
set -u
CE=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
BD=build-l1
OUT=/home/comdare/backups-workflow/20260822-lande-zug/Z10
cd "$CE" || exit 9
echo "FLOOR-TREPPE Z10 $(git rev-parse --short HEAD) $(date -u +%FT%TZ)"
inventur() {
  NAME=$1
  ctest --test-dir "$BD" -N > "$OUT/floor-ctestN-$NAME.log" 2>&1
  RC=$?
  if [ $RC -ne 0 ]; then echo "INVENTUR[$NAME] ctest-N-ROT rc=$RC"; return 1; fi
  TOTAL=$(sed -n 's/^Total Tests: \([0-9][0-9]*\)$/\1/p' "$OUT/floor-ctestN-$NAME.log")
  sed -n 's/^ *Test *#[0-9]*: \(.*\)$/\1/p' "$OUT/floor-ctestN-$NAME.log" | LC_ALL=C sort > "$OUT/floor-namen-$NAME.txt"
  LEN=$(wc -l < "$OUT/floor-namen-$NAME.txt" | tr -d ' ')
  if [ "$TOTAL" = "$LEN" ] && [ -n "$TOTAL" ]; then
    echo "INVENTUR[$NAME]: Total=$TOTAL Listenlaenge=$LEN (Gegenprobe OK)"
  else
    echo "INVENTUR[$NAME]: Total=$TOTAL Listenlaenge=$LEN GEGENPROBE-ROT"; return 1
  fi
}
echo "--- SPROSSE avx512f (nativ) ---"
inventur avx512f || exit 1
cmake -DCOMDARE_HOST_RUNS_AVX512F=0 "$BD" > "$OUT/floor-conf-avx2.log" 2>&1
RC=$?; echo "RC_CONF_AVX2=$RC"; [ $RC -ne 0 ] && exit 1
echo "--- SPROSSE avx2 (erzwungen) ---"
inventur avx2 || exit 1
cmake -DCOMDARE_HOST_RUNS_AVX2=0 "$BD" > "$OUT/floor-conf-basis.log" 2>&1
RC=$?; echo "RC_CONF_BASIS=$RC"; [ $RC -ne 0 ] && exit 1
echo "--- SPROSSE basis (erzwungen) ---"
inventur basis || exit 1
echo "--- COMM beide Richtungen ---"
echo "avx512f->avx2 VERLIERT:"
LC_ALL=C comm -23 "$OUT/floor-namen-avx512f.txt" "$OUT/floor-namen-avx2.txt"
echo "avx2->avx512f GEWINNT (SOLL leer):"
LC_ALL=C comm -13 "$OUT/floor-namen-avx512f.txt" "$OUT/floor-namen-avx2.txt"
echo "avx2->basis VERLIERT:"
LC_ALL=C comm -23 "$OUT/floor-namen-avx2.txt" "$OUT/floor-namen-basis.txt"
echo "basis->avx2 GEWINNT (SOLL leer):"
LC_ALL=C comm -13 "$OUT/floor-namen-avx2.txt" "$OUT/floor-namen-basis.txt"
echo "--- RESTORE (cmake -U beide Variablen) ---"
cmake -U COMDARE_HOST_RUNS_AVX512F -U COMDARE_HOST_RUNS_AVX2 "$BD" > "$OUT/floor-conf-restore.log" 2>&1
RC=$?; echo "RC_RESTORE=$RC"; [ $RC -ne 0 ] && exit 1
inventur restore || exit 1
if cmp -s "$OUT/floor-namen-avx512f.txt" "$OUT/floor-namen-restore.txt"; then
  echo "RESTORE_NAMENSLISTE=BYTE-GLEICH"
else
  echo "RESTORE_NAMENSLISTE=ABWEICHUNG"; exit 1
fi
grep "COMDARE_HOST_RUNS_AVX2:INTERNAL\|COMDARE_HOST_RUNS_AVX512F:INTERNAL" "$BD/CMakeCache.txt"
echo "FLOOR-TREPPE-ENDE $(date -u +%FT%TZ)"
