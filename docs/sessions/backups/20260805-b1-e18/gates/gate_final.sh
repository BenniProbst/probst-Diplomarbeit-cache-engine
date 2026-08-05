#!/usr/bin/env bash
# Vervollstaendigt das Gate: die 4 nach dem 2. Configure NEU erschienenen Tests (375-378)
# brauchen Werkzeuge, die das all-Ziel NICHT baut (registry_roundtrip.cmake:30 sagt das
# literal: "Vorher bauen (2-Pass, wie #25-B): cmake --build <build> --target <generator>").
# Danach: Doppellauf 2x SERIELL am vollstaendigen Bau.
set -uo pipefail
WT=/home/comdare/wt-b1-e18
BD=$WT/build-b1e18-gate
G=/tmp/claude-1001/-home-comdare/46375cdc-821a-4bf9-93d4-fe0a5687f489/scratchpad/b1-e18/gates

echo "== NACHBAU der 2-Pass-Werkzeuge + der adhoc-Test-Binary ==" | tee -a "$G/00-gate.log"
cmake --build "$BD" --target comdare_axis_registry_gen comdare_system_axis_registry_gen \
      comdare_measurement_axis_registry_gen test_profile_roundtrip > "$G/08-nachbau-2pass.log" 2>&1
echo "nachbau_rc=$?" | tee -a "$G/00-gate.log"
( cd "$BD" && ctest -N 2>&1 | tail -1 ) | tee "$G/04-ctest-N-final.log"

echo "== DOPPELLAUF (final) LAUF 1 (seriell, -j1) ==" | tee -a "$G/00-gate.log"
( cd "$BD" && ctest -j1 ) > "$G/06-ctest-lauf1.log" 2>&1
echo "LAUF1-RC=$?" | tee -a "$G/00-gate.log"
grep -E "tests passed, .* tests failed out of" "$G/06-ctest-lauf1.log" | tee -a "$G/00-gate.log"

echo "== DOPPELLAUF (final) LAUF 2 (seriell, -j1) ==" | tee -a "$G/00-gate.log"
( cd "$BD" && ctest -j1 ) > "$G/07-ctest-lauf2.log" 2>&1
echo "LAUF2-RC=$?" | tee -a "$G/00-gate.log"
grep -E "tests passed, .* tests failed out of" "$G/07-ctest-lauf2.log" | tee -a "$G/00-gate.log"

echo "GATE_DOPPELLAUF_FINAL_KOMPLETT" | tee -a "$G/00-gate.log"
