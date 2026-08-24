#!/bin/bash
# Z12-NEUFAHRT-FABLE: E-7/#121 O3-WAEHLBARKEITS-PROBE am gelandeten Endstand
# (Haus-Bauwelt LIVE: Opt-in ON unter WARNING -> Restore OFF byte-ruhig).
# Laeuft NACH dem Kombibau (build-l1 ist bis dahin dem Kombibau vorbehalten).
# ASCII-only. Schreibt nur nach $OUT und in build-l1-CMake-Metadaten.
set -u
CE=/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine
OUT=/home/comdare/backups-workflow/20260822-lande-zug/Z12/neufahrt-fable
B="$CE/build-l1"
cd "$CE" || exit 9
echo "== O3-PROBE START $(date -u +%FT%TZ) HEAD=$(git rev-parse --short HEAD) =="
echo "-- (1) Opt-in ON: WARNING + Statuszeile muessen feuern --"
cmake -S "$CE" -B "$B" -DCOMDARE_OPT_O3=ON > "$OUT/o3probe-on.log" 2>&1
ON_RC=$?
echo "PROBE_ON_RC=$ON_RC"
grep -n "COMDARE_OPT_O3=ON" "$OUT/o3probe-on.log" | head -2
grep -n "Release-Optimierung: -O3" "$OUT/o3probe-on.log" | head -2
echo "-- (2) Restore OFF: O2-Statuszeile + Cache-Wert --"
cmake -S "$CE" -B "$B" -DCOMDARE_OPT_O3=OFF > "$OUT/o3probe-off.log" 2>&1
OFF_RC=$?
echo "RESTORE_OFF_RC=$OFF_RC"
grep -n "Release-Optimierung: -O2" "$OUT/o3probe-off.log" | head -2
grep "^COMDARE_OPT_O3" "$B/CMakeCache.txt"
echo "-- (3) No-Op-Kontrolle nach Restore (Baum baulich unveraendert) --"
ninja -C "$B" all > "$OUT/o3probe-noop.log" 2>&1
NOOP_RC=$?
echo "NOOP_RC=$NOOP_RC zeilen=$(wc -l < "$OUT/o3probe-noop.log")"
tail -2 "$OUT/o3probe-noop.log"
echo "-- (4) ctest -N Schlusszeile (Inventur unveraendert) --"
ctest --test-dir "$B" -N > "$OUT/o3probe-ctestN.log" 2>&1
grep -E "Total Tests:" "$OUT/o3probe-ctestN.log"
echo "== O3-PROBE ENDE $(date -u +%FT%TZ) =="
[ $ON_RC -eq 0 ] && [ $OFF_RC -eq 0 ] && [ $NOOP_RC -eq 0 ] && exit 0 || exit 1
