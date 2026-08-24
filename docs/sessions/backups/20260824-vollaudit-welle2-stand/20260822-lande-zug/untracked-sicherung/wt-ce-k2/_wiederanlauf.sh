#!/bin/bash
set -o pipefail
cd /home/comdare/wt-ce-k2
mkdir -p build-protokolle
L=build-protokolle/20260817-wiederanlauf-bau-ctest.log
{
echo "=== WIEDERANLAUF $(date -u '+%F %H:%M:%S') UTC ==="
df -h / | tail -1
cmake --build build -j5 2>&1
echo "BAU_RC=$?"
avail=$(df --output=avail -BG / | tail -1 | tr -dc 0-9)
echo "PLATTE_VOR_CTEST=${avail}G"
if [ "$avail" -lt 9 ]; then echo ABBRUCH_PLATTE_UNTER_9G; exit 2; fi
ctest --test-dir build -j5 --output-on-failure 2>&1 | tail -60
echo "CTEST_RC=$?"
echo "=== FERTIG $(date -u '+%H:%M:%S') ==="
} > $L 2>&1
