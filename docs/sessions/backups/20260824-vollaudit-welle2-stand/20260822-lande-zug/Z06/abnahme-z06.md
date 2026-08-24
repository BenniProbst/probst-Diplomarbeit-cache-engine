# Z06 ABNAHME (Merge 7/10 ph89, 22.08.2026) — gcc-Release-Zwischenlauf am Merge-Stand

MERGE: a58f77b5aa6021114a82df9828f27867ce33f2ad (--no-ff; P1=85a67b08 P2=2809e4d4),
porcelain 0 nach Commit. Merge-Stat 42 Dateien +2246/-12 == Audit-Literal.

TREPPE (wt-ce-lande, build/gcc-release: Release/Ninja/g++,
COMDARE_CE_PRUEFLINGE=/home/comdare/wt-ce-lande/tests/pruefling_fixture -- CMakeCache-Literal):
- J-1 7 Werkzeuge LITERAL (comdare_adhoc_emitter_cli comdare_anatomy_codegen_cli
  comdare_axis_registry_gen comdare_catalog_codegen_cli comdare_measurement_axis_registry_gen
  comdare_overlay_source_hash_gen comdare_system_axis_registry_gen): J1_RC=0 (z06-j1-werkzeuge.log)
- RE-CONFIGURE: RECONF_RC=0 (z06-reconfigure.log)
- Vollbau all: ALL_RC=0 (z06-vollbau.log, 1739 Targets)
- Facade REALES Target comdare_profile_run_facade: FAC_RC=0 (z06-facade.log)
- comdare_tests: TESTS_TARGET_RC=0 (z06-tests-target.log)
- ctest --no-tests=error --output-on-failure: CTEST_RC=0 (DIREKTER RC, keine Pipe)
  LITERAL: "100% tests passed, 0 tests failed out of 539" (z06-ctest-gcc-release.log)
  ph89-Test sichtbar+gruen: "539/539 Test #539: test_ph89_paper_prueflinge ... Passed"

NENNER-KETTE (jede Zahl mit Nenner):
- Z03-Stand (Merge 4/10 + B06-Fix): 532 (Z03/ctest-voll-lauf2-nach-harmonisierung.log)
- Z04-Stand (Merge 5/10 pmcpaket): 534 (Z04-Log, +2)
- Z05 (vollzug91): +4 Registrierungen (git diff 9da4d21d..85a67b08 CMakeLists, gezaehlt 4)
- Z06 (ph89): +1 Registrierung (git diff 85a67b08..HEAD, gezaehlt 1)
- 534+4+1 = 539 == gemessen. EXAKT.

WARNUNGS-BEFUND: genau 1 "warning"-Zeile im Vollbau (z06-vollbau.log:1333,
-Wstringop-overflow gcc-15-STL stl_algobase.h via test_v41_topic_traversal /
InterpolationSearchAlgo::erase) -- VORBESTAND: identisch 1 Treffer im Audit-Scratch-Bau
des ph89-Branches (20260821-w2-audit-fixverify/ph89/bau-all.log) UND im Z04-Vollbau
(Z04/abnahme-05-vollbau.log). KEINE neue Warnung dieses Merges; keine ph89-Datei beteiligt.

BEIDE MENGEN: Dieser Lauf deckt NUR die Zelle gcc-Release am Zwischenstand a58f77b5.
clang-Release + gcc-Debug + clang-Debug = K17-Endstand-Kombibau VOR dem Push (T-11b, P-22).

CACHE-RAEUMUNG (Schritt 4): Build-Verzeichnis des GELANDETEN Strangs wt-ce-ph89/build
existiert NICHT (ls | grep -i build => RC=1) -- bereits vom Strang-Agent nach dokumentierter
Doppel-Belegpruefung entfernt (p-h-89-ergebnis.md ENDSTAND: "git ls-files 0, csv/xlsx 0";
Audit Abschnitt 2 Nachlauf-Hygiene). df vorher/nachher unveraendert: 20G frei (>5G-Gate).
Lande-Build build/gcc-release BLEIBT (traegt Merges 8-10 + Endstand-Kombibau; nicht
Gegenstand der Strang-Raeumung).

WORKTREE wt-ce-ph89: STEHT (HEAD 2809e4d4, porcelain 0) -- Raeumung per Ziel-Vorgabe in Z11.
