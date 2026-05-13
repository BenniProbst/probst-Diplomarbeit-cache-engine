# 6-Tage-Review-Plan REV 7.6 (ab 2026-05-13)

**Zweck:** Detaillierter, dokumenten-orientierter Review-Plan fuer die
naechsten 6 Tage (Mo 2026-05-13 bis Sa 2026-05-18). Pro Tag: ein
inhaltlicher Fokus + konkrete Lese-/Verifikations-Schritte.

**Anker:** Habich-Termin 7 am vermutlich 2026-05-13 (oder kurz danach).
Die Review-Tage sind so geschnitten, dass sich Architektur (oben) zu
Implementierung (unten) durchhangelt.

---

## Tag 1 — Mo 2026-05-13 — Architektur-Master + Drei-Repo-Aufteilung

**Fokus:** Sicherstellen, dass die Drei-Repo-Aufteilung in allen drei Repos
identisch beschrieben ist.

**Pflicht-Lese-Liste:**
1. Diplomarbeit `STRUCTURAL_CORRECTION_diplomarbeit.md` (Master)
2. Diplomarbeit `FINDINGS_REV7_6_diplomarbeit.md` (Master)
3. cache-engine `STRUCTURAL_CORRECTION_cache_engine.md`
4. cache-engine `FINDINGS_REV7_6_cache_engine.md`
5. prt-art `STRUCTURAL_CORRECTION_prt_art.md`
6. prt-art `FINDINGS_REV7_6_prt_art.md`

**Verifikations-Schritt:** In jedem der drei Repos `PROJECT_LAYER_MAP.md`
oeffnen und pruefen, dass REV 7.6 erwaehnt ist und der „WAS / Pruefling /
WIE"-Trichter konsistent dargestellt wird.

---

## Tag 2 — Di 2026-05-14 — Hybride SearchEngine-API (REV 7.1)

**Fokus:** Pruefen, dass die hybride `PrtArtSearchEngine` (Vector/Map/Tuple
+ errno-style status_t) in allen drei Repos korrekt referenziert wird und
die Tests gruen sind.

**Pflicht-Lese-Liste:**
1. `20260508 Termin 7/Phase5_UML_Detail/25_hybrid_search_engine_2026_05_12.md`
2. prt-art `prt_art/identity/prt_art_search_engine.hpp`
3. prt-art `prt_art/identity/status.hpp` (errno-Konstanten)
4. prt-art `tests/unit/test_prt_art_identity.cpp`

**Verifikations-Schritt:** In prt-art `ctest` ausfuehren, 51 Tests muessen
durchlaufen (MapApi 20 / TupleApi 4 / VectorApi 19 / Status 1 / Identity 7).

---

## Tag 3 — Mi 2026-05-15 — ExperimentDriver-Library + Phase 1-7

**Fokus:** ExperimentDriver-Library (REV 7.6) gegen die Phase-1-bis-7-
Anforderungen pruefen + verifizieren, dass alle Diagnose-Outputs erhalten
sind.

**Pflicht-Lese-Liste:**
1. cache-engine `cache_engine/builder/experiment_driver/experiment_driver.hpp`
2. cache-engine `cache_engine/builder/experiment_driver/experiment_driver.cpp`
3. cache-engine `cache_engine/builder/main.cpp` (Wrapper, sollte ~82 Zeilen sein)
4. `20260508 Termin 7/Phase5_UML_Detail/28_cmake_pipeline_2026_05_12.md`
5. `20260508 Termin 7/Phase5_UML_Detail/29_phase4_7_loader_2026_05_12.md`

**Verifikations-Schritt:** cache-engine `comdare-cache-engine-builder
--enumerate-only --verbose` ausfuehren, alle 7 Phasen-Diagnose-Blocks
muessen erscheinen (Phase 1 enumerate, Phase 2 codegen, Phase 3 compile,
Phase 4 load, Phase 5+6 run/measure, Phase 7 export).

---

## Tag 4 — Do 2026-05-16 — Diplomarbeit/Code/ Build + 3 Messreihen

**Fokus:** Diplomarbeit/Code/ vollstaendig bauen und alle 3 Messreihen
mindestens als Dry-Run (--enumerate-only) durchspielen.

**Pflicht-Lese-Liste:**
1. Diplomarbeit `Code/CMakeLists.txt`
2. Diplomarbeit `Code/messung_driver/main.cpp`
3. Diplomarbeit `Code/experiment_config/config_a_prt_art_vs_sota.xml`
4. Diplomarbeit `Code/experiment_config/config_b_cache_engine_perms.xml`
5. Diplomarbeit `Code/experiment_config/config_c_merge_alt_neu.xml`
6. Diplomarbeit `Code/USAGE.md` (Stack-Anleitung)

**Verifikations-Schritt:**
```
cd "Diplomarbeit - Datenbanken/Code"
cmake -B build
cmake --build build --target comdare-messung-driver
build/messung_driver/comdare-messung-driver --enumerate-only --verbose
```
Erwartet: 3 Messreihen werden hintereinander mit jeweiliger Anzahl
Permutationen aufgezaehlt.

---

## Tag 5 — Fr 2026-05-17 — Auswertungs-Pipeline (Binary → CSV → LaTeX)

**Fokus:** Sicherstellen, dass die Post-Processing-Pipeline lueckenlos
funktioniert und mit synthetischen Records testbar ist.

**Pflicht-Lese-Liste:**
1. Diplomarbeit `Code/binary_to_csv/binary_to_csv.{hpp,cpp}`
2. Diplomarbeit `Code/csv_to_latex/csv_to_latex.{hpp,cpp}` (mit
   `generate_baustein_description`)
3. Diplomarbeit `Code/diagram_generator/diagram_generator.{hpp,cpp}`
   (A4-aware TikZ Bar/Scatter/Heatmap)
4. Diplomarbeit `Code/latex_to_pdf/build_thesis.sh + .bat`
5. Diplomarbeit `Code/tests/unit/test_messung_driver.cpp` (GoogleTest)

**Verifikations-Schritt:**
```
cmake --build build --target ctest
ctest --test-dir build --output-on-failure
```
Erwartet: alle Unit-Tests gruen, inkl. der GoogleTest-Suite fuer den
Mess-Driver.

---

## Tag 6 — Sa 2026-05-18 — Habich-Vorbereitung + Manuskript-Anker

**Fokus:** Habich-Termin-Inhalt fixieren, Manuskript-Anker pruefen.

**Pflicht-Lese-Liste:**
1. `20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
2. `20260508 Termin 7/Phase5_UML_Detail/30_architektur_delta_REV7_6_drei_repo_layer_2026_05_13.md`
3. `20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`
4. `20260508 Termin 7/Phase5_UML_Entwurf/Sprechpunkte_Habich.md`

**Verifikations-Schritt:** Die fuenf Diskussionspunkte unter §5 der
Habich-Zusammenfassung gegen die Sprechpunkte abgleichen. Eventuelle
offene Fragen vor Termin schriftlich pro Repo dokumentieren.

---

## Querverweise

- **Master-Findings:** `Diplomarbeit/FINDINGS_REV7_6_diplomarbeit.md`
- **Master-Struktur-Korrektur:** `Diplomarbeit/STRUCTURAL_CORRECTION_diplomarbeit.md`
- **Termin-7-Zusammenfassung:** `Diplomarbeit/20260508 Termin 7/HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md`
- **Pro-Repo-Schwester-Doks:** siehe Habich-Zusammenfassung §6.2/§6.3
