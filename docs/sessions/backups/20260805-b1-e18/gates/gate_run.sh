#!/usr/bin/env bash
# B1/E-18 -- Dauer-Auflagen-Gate am Commit-Objekt.
# Reihenfolge nach der dokumentierten N-ERHEBUNGS-FALLE (w2fix-Report, offene_punkte[6]):
#   frisches Configure -> VOLL-BAU -> ZWEITES Configure (die werkzeug-erzeugten Configure-
#   Snippets entstehen erst im Bau) -> ctest -N == 405 -> Doppellauf 2x SERIELL.
set -uo pipefail
WT=/home/comdare/wt-b1-e18
BD=$WT/build-b1e18-gate
G=/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/b1-e18/gates

echo "== COMMIT-OBJEKT =="              | tee    "$G/00-gate.log"
git -C "$WT" log --oneline -1           | tee -a "$G/00-gate.log"
git -C "$WT" status --porcelain | wc -l | xargs echo "git status --porcelain Zeilen:" | tee -a "$G/00-gate.log"

rm -rf "$BD"
echo "== CONFIGURE PASS 1 (frisch, Build-Dir NEU) ==" | tee -a "$G/00-gate.log"
cmake -B "$BD" -S "$WT" -G Ninja -DCOMDARE_V32_ENABLE=ON > "$G/01-configure-pass1.log" 2>&1
echo "configure_pass1_rc=$?" | tee -a "$G/00-gate.log"
( cd "$BD" && ctest -N 2>&1 | tail -1 ) | tee "$G/02-ctest-N-pass1.log"

echo "== VOLL-BAU ==" | tee -a "$G/00-gate.log"
cmake --build "$BD" > "$G/05-build.log" 2>&1
BRC=$?
echo "build_rc=$BRC" | tee -a "$G/00-gate.log"
if [ "$BRC" -ne 0 ]; then echo "GATE_BAU_FEHLGESCHLAGEN_RC$BRC" | tee -a "$G/00-gate.log"; exit "$BRC"; fi
echo "GATE_BAU_KOMPLETT_RC0" | tee -a "$G/00-gate.log"

echo "== CONFIGURE PASS 2 (kanonischer 2-Pass NACH dem Bau) ==" | tee -a "$G/00-gate.log"
cmake -B "$BD" -S "$WT" -G Ninja -DCOMDARE_V32_ENABLE=ON > "$G/03-configure-pass2.log" 2>&1
echo "configure_pass2_rc=$?" | tee -a "$G/00-gate.log"
cmake --build "$BD" >> "$G/05-build.log" 2>&1
echo "build_pass2_rc=$?" | tee -a "$G/00-gate.log"
( cd "$BD" && ctest -N 2>&1 | tail -1 ) | tee "$G/04-ctest-N-pass2.log"

echo "== DOPPELLAUF LAUF 1 (seriell, -j1) ==" | tee -a "$G/00-gate.log"
( cd "$BD" && ctest -j1 ) > "$G/06-ctest-lauf1.log" 2>&1
echo "LAUF1-RC=$?" | tee -a "$G/00-gate.log"
grep -E "tests passed|tests failed" "$G/06-ctest-lauf1.log" | tail -2 | tee -a "$G/00-gate.log"

echo "== DOPPELLAUF LAUF 2 (seriell, -j1) ==" | tee -a "$G/00-gate.log"
( cd "$BD" && ctest -j1 ) > "$G/07-ctest-lauf2.log" 2>&1
echo "LAUF2-RC=$?" | tee -a "$G/00-gate.log"
grep -E "tests passed|tests failed" "$G/07-ctest-lauf2.log" | tail -2 | tee -a "$G/00-gate.log"

echo "GATE_DOPPELLAUF_KOMPLETT" | tee -a "$G/00-gate.log"
