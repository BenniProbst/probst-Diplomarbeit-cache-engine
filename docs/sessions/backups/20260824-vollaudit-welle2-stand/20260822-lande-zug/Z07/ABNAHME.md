# Z07 ABNAHME-PROTOKOLL — Merge 8/10 bau/trigfix in lande/w2-s1s2 (2026-08-22)

## Objekt
- Merge-Commit: f7b64039 (Eltern a58f77b5 + 0f900dcf, --no-ff), Branch lande/w2-s1s2, wt-ce-lande.
- Haertungs-Commit: a84f1119 (trigfix-KLEIN-1 ersetze()-npos, Audit-r1-Fix-Weg "im Lande-Zug";
  1 Datei, +3/-1; clang-format-22 --dry-run -Werror rc=0 nach Format-Anwendung).
- 5 Merge-Dateien: A profile_facade/e07_gate_kriterien.hpp · A tests/unit/test_e07_gate_kriterien.cpp
  · A tests/unit/test_e8_bytes_in_use_peak_demo.cpp · M tests/unit/CMakeLists.txt (NUR Dateiende)
  · M libs/execution_engine/include/comdare/experiment/experiment_demo.hpp.

## Konflikt-Harmonisierung (H-9, A2.1b)
- Einziger Konflikt: tests/unit/CMakeLists.txt (merge-tree-Vorhersage == Ist).
- Union: HEAD-Endstand (Merges 1-7) VOLL erhalten + trigfix-Block (22 Zeilen inkl. eigenem
  "# ===="-Trenner) ans Dateiende (Kopie: harmonisierung-trigfix-block-22z.txt).
- Zaehlwerk EINMAL live: comdare_add_test( Basis 245 / HEAD 261 / Tip 247 -> nach Union 263
  (gemessen 263; Endkontrolle nach Haertung erneut 263). Beide neuen Tests je exakt 1x.
- Dateiende nach Merge = e8-LABELS-Zeile (DATEIENDE-Regel gehalten, 8158 Zeilen).

## ASCII/Format
- Haertungs-Diff: 3 Add-Zeilen, 0 Nicht-ASCII (grep -cP '[^\x00-\x7F]' = 0; Positiv-Kontrolle
  2 npos-Treffer in denselben Zeilen — keine stille Null).
- clang-format-22: rc=0 auf test_e07_gate_kriterien.cpp (nach -i-Anwendung; Diff blieb exakt
  die 3 Zeilen der Haertung).

## Bau-/Testabnahme (Zwischenmerge-Form: gcc-Release-Teilbau; volle T-11b-Matrix = Endstand-Kombibau)
- df-Gate VOR Bau: 20G frei (>=5G, df-vor-bau.txt). NACH Bau: 20G (df-nach-bau.txt).
- Baum: wt-ce-lande/build/gcc-release (Ninja, Release, COMDARE_CE_PRUEFLINGE=
  /home/comdare/wt-ce-lande/tests/pruefling_fixture — J-0b gesetzt), Bauslot slot2.d "lande-w2-zug".
- Teilbau beider neuer Targets: TEILBAU_RC=0 (teilbau-gcc-release.log, 20 Ninja-Schritte,
  CMake-Regen wegen CMakeLists-Aenderung inbegriffen).
- ctest (gefilterter Lauf, --no-tests=error): CTEST_RC=0, Bilanz-Literal aus der GESICHERTEN
  Kopie ctest-e07-e8.log: "100% tests passed, 0 tests failed out of 2" —
  Test #540 test_e07_gate_kriterien Passed, #541 test_e8_bytes_in_use_peak_demo Passed.
  (Die 23 Entfernungs-Proben des E07-Tests laufen ALLE durch das gehaertete ersetze():
  Gruen == Beweis "kein Semantik-Delta". Nenner-Hinweis: gefilterter Lauf N=2 von aktuell
  #541+ registrierten Tests dieses Baums; der VOLLE Nenner ist Sache des Endstand-Kombibaus
  T-11b {gcc,clang}x{Release,Debug} mit 7er-J-1-Liste literal + comdare_profile_run_facade,
  RE-CONFIGURE, comdare_tests vor ctest — Quer-Auflage G8/H5, VOR dem Push.)

## Cache-Raeumung des gelandeten Strangs
- wt-ce-trigfix/build EXISTIERT NICHT (BUILD_FEHLT gemessen; Audit r1 hatte "build/ entfernt"
  bereits verifiziert) -> nichts zu raeumen; df unveraendert 20G/20G.
- Worktree wt-ce-trigfix (HEAD 0f900dcf, porcelain 0): Raeumung laut Zug-Plan in Z11 —
  hier bewusst STEHEN GELASSEN (auch wegen #114-Re-Run-Vorbehalt auf der Trigger-Linie).

## Selbstcheck
Merge --no-ff mit 2 Eltern bestaetigt · KONFLIKT-DEKLARATION im Commit-Text · Trailer gesetzt ·
kein rebase/force-push/add -A · TABU-Zonen unberuehrt (Diff enthaelt keine golden/axes/topics/
heuristik/YAML) · kein Push (Lande-Push mit Gates 6/6 + gitleaks = Zug-Endstufe) · Exit-Codes
ohne Pipes erhoben · Beweise liegen als Kopien in diesem Ordner.
