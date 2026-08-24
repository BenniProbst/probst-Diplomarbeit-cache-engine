# Z19 ABNAHME -- super-Phase Merge 4: bau/w1luecken-super @ 8edc34a0 -> development

Merge-Commit: **17c93c2aa8aa88e88613185c39d7639832434571** (--no-ff, 'ort', konfliktfrei;
2 Dateien, +55/-0: Code/tests/CMakeLists.txt +13, Code/tests/skip_anker_bissprobe.cmake +42 NEU).
Vorher development @ 2e6f7a0b; Gitlink Code/external/comdare-cache-engine COMMITTED unveraendert
66de5c09 (ls-tree-Beweis; Sperre bis Z23 eingehalten). KEIN Push (R4; Phasen-Push Z23).

## 1. B11 skip_anker-Bissprobe am GEMERGTEN Stand (17c93c2a)

Baum-Nenner (beide Mengen benannt): bestehender Abnahme-Baum `build-l4` (Ninja,
CMAKE_HOME_DIRECTORY=<super>/Code, CMakeCache urspruenglich 20.08.), RE-CONFIGURE am
gemergten Stand RC=0 ("Configuring done", reconfigure-build-l4.log). Dieser Baum
registriert die da_unit-Konfiguration mit Testnummern bis #946+ -- der da_unit-VOLLNENNER
ist konfigurationsabhaengig (V-F3) und wird am Phasen-Endstand (Z23-Kombibau) gemessen;
diese Abnahme deckt die deklarierten B11-Gegenstaende, NICHT den Vollauf.

- `ctest --no-tests=error -R skip_anker` RC=0, literal:
  `1/1 Test #946: test_fixture_skip_anker_biss .....   Passed`
  `100% tests passed, 0 tests failed out of 1`
  (Log: ctest-skip-anker-bissprobe.log)
- `ctest --no-tests=error -L fixture_sync` RC=0, literal:
  `100% tests passed, 0 tests failed out of 6` -- Tests #941-#946: fixture_sync_experiment_golden,
  fixture_sync_prt_registry, fixture_schema_experiment_golden_kern, fixture_schema_experiment_golden,
  golden_n_consistency, fixture_skip_anker_biss (= 5 Wachen MIT Skip-Property + neue Bissprobe;
  Log: ctest-fixture-sync.log). Deckt zugleich: SKIP_REGULAR_EXPRESSION-Property weiterhin auf
  allen 5 Wachen, Bissprobe zieht die Regex DRIFT-FREI per get_test_property (CMakeLists-Dateiende).

## 2. 13/13 B14-xmllint-Heilungen/GRENZE am GEMERGTEN Stand (marker-gegenprobe-13von13.log)

Befund-Marker-Zaehlung (`grep -rn "Befund B[0-9]"` ueber Code/tests/*.cmake + CMakeLists.txt):
B1(2) B2(3) B3(3) B4(4) B5(2) B6(3) B7(2) B8(2) B9(3) B10(1) B11(1) = **11/11 Heilungs-Klassen
vorhanden**, Markerzahlen deckungsgleich mit w1-luecken-ergebnis.md (B1 2x quote-bewusst,
B2 3x Wurzelbindung, B3 3x --nonet, B4 4x SKIP-Anker, B9 3x MASTER, B11 Opus-Review-Marker).
GRENZEN: **GRENZE-1** Namespace golden_n_consistency_check.cmake:51 ("AUSGEWIESENE GRENZE
(B14-NB4/NB5 ...)" EXAKT am berichteten Anker) + **GRENZE-2** comdare_xml_count-Dezimal
xml_canonical_utils.cmake:531/:549 (EXAKT an den berichteten Ankern) = **13/13**.
Zusaetzlich (im Bericht als weitere ausgewiesene Grenzen gefuehrt, beide vorhanden):
xs:include-1-Ebene fixture_schema_subset_check.cmake:138-150 + CMake--P-Grenze
xml_canonical_utils.cmake:163.

## 3. Raeumungs-/Betriebslage

- df-Gate: 15G frei VOR und NACH der Abnahme (df-vor-/df-nach-abnahme.txt); kein Vollbau
  gefahren (nur Re-Configure + CMake-Skript-Tests), Slot slot2.d = "lande-w2-zug" (Claim-Zeile
  Z19 fortgeschrieben).
- Eigenes Build-Verzeichnis des GELANDETEN Strangs: EXISTIERT NICHT MEHR (ls wt-super-w1luecken/build*
  RC=2; Bau- und Verify-Baeume wurden lt. Strang-Doku bereits nach Doppel-Bedingung geraeumt) --
  keine Raeumung in diesem Schritt noetig. build-l4 im Hauptklon ist der PHASEN-Abnahme-Baum
  (untracked) und bleibt fuer kampvor-super/Z23 stehen (deklariert).
- wt-super-w1luecken: NICHT angefasst (968M, porcelain leer/clean, nested ce 66de5c09 +
  nested prt-art d11781fa) -- Raeumung ausschliesslich in Z26 nach rekursiver Doktrin.

## 4. Beweisorte (dieses Verzeichnis)

EXPLORE-BEFUND-Z19.md * merge-tree-probe-vor-merge.txt * merge-commit-kopf.txt *
merge-commit-volltext.txt * reconfigure-build-l4.log * ctest-skip-anker-bissprobe.log *
ctest-fixture-sync.log * marker-gegenprobe-13von13.log * df-vor-abnahme.txt * df-nach-abnahme.txt
