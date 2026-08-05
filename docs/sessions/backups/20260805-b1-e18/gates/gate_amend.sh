#!/usr/bin/env bash
# Doppellauf NACH dem Amend, damit die Literale wirklich am finalen Commit-Objekt haengen.
set -uo pipefail
WT=/home/comdare/wt-b1-e18; BD=$WT/build-b1e18-gate
G=/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/b1-e18/gates
echo "== DOPPELLAUF AM FINALEN COMMIT-OBJEKT ==" | tee "$G/09-doppellauf-final.log"
git -C "$WT" log --oneline -1 | tee -a "$G/09-doppellauf-final.log"
git -C "$WT" status --porcelain | wc -l | xargs echo "git status --porcelain Zeilen:" | tee -a "$G/09-doppellauf-final.log"
cmake --build "$BD" > "$G/09-build-inkrementell.log" 2>&1; echo "build_rc=$?" | tee -a "$G/09-doppellauf-final.log"
( cd "$BD" && ctest -N 2>&1 | tail -1 ) | tee -a "$G/09-doppellauf-final.log"
( cd "$BD" && ctest -j1 ) > "$G/09-lauf1.log" 2>&1; echo "LAUF1-RC=$?" | tee -a "$G/09-doppellauf-final.log"
grep -E "tests passed, .* tests failed out of" "$G/09-lauf1.log" | tee -a "$G/09-doppellauf-final.log"
( cd "$BD" && ctest -j1 ) > "$G/09-lauf2.log" 2>&1; echo "LAUF2-RC=$?" | tee -a "$G/09-doppellauf-final.log"
grep -E "tests passed, .* tests failed out of" "$G/09-lauf2.log" | tee -a "$G/09-doppellauf-final.log"
echo "GATE_FINAL_AM_AMEND_KOMPLETT" | tee -a "$G/09-doppellauf-final.log"
