# SYNTHESE — Adversarialer Review „Limits-Entkopplung Produktivumschaltung" (wf_1009d16f-4fa)

> GO-Increment 1b (Gate-Stufen 4-6). Rohdaten: `rohdaten-review/` (journal.jsonl, workflow-skript.js,
> ergebnis-review.json). Dossier: `CODEX-DOSSIER.md` (dieser Ordner). 11 Agenten (3 Finder-Dimensionen ×
> 2-Lens-Verify), 929k Tokens, 337 Tool-Calls. 8 Kandidaten → **5 CONFIRMED / 3 refutiert** (alle empirisch).

## Besonderheit dieses Increments: Implementierungs-Übergang Codex → Claude

Die Codex-Erstimplementierung hing nach dem MCP-Dispatch 1800s ohne Antwort (Client-Abbruch); der
Server-Thread arbeitete unbemerkt weiter, hinterließ einen substanziellen Teilstand (7 Dateien) und
überschrieb später zwei bereits korrigierte Dateien erneut (catalog_codegen.cmake, tests/unit) — er wurde
daraufhin beendet (kill + MCP-Server), `build-codex-limits2/` entfernt. **User-Direktive seither: Claude
implementiert selbst.** Der Codex-Teilstand wurde voll reviewt und selektiv übernommen/korrigiert:
- ÜBERNOMMEN (korrekt): zentrales `cmake/catalog_codegen.cmake` (custom_command + attach-Funktion),
  tests/unit-Ersetzung des Duplikat-Blocks, profile_run_entry-/test_run_profile_union-Umstellung auf
  `generated_make_catalog_source_gen()`, Facade-DEFER-attach, Tool-Umstellung auf PROJECT_BINARY_DIR-Axis-
  Includes (fixt latenten super-Build-Ordering-Bug), PAPER_CODEGEN_CONSUMER-Registrierung des Tools,
  ADHOC-Target-Funktion (EXCLUDE_FROM_ALL, nicht in ctest — README-Doktrin), 5 COMDARE_TEST_TARGETS-
  Nachregistrierungen (Not-Run-Klasse, scope-fremd aber korrekt; separater Commit).
- KORRIGIERT (Claude): `catalog_codegen.cmake` Output auf `${PROJECT_BINARY_DIR}/generated` (Layering:
  ce schreibt in SEIN Build-Verzeichnis; Codex' CMAKE_BINARY_DIR hätte im super-Sub-Build ins super-Root
  geschrieben); attach-Funktion liefert zusätzlich den `tests/unit`-Include (generierter Header
  re-inkludiert `thesis_tiere/source_catalog.hpp` — super-Facade-Bruch empirisch gefunden+gefixt);
  Facade-Diff auf das Nötige minimiert; redundanter generated-Include aus dem ADHOC-Block entfernt.

## Review-Verdikt: 5 CONFIRMED

1. **major — build_run_profile_union.ps1:11 / build_and_measure_150_tiere.ps1:66 / profile_run_entry.hpp:23
   (eine Fehlerklasse, 3 Findings + 1 Doppel-Verify, alle empirisch reproduziert):** Die committeten
   Windows-PS1-Reproduktionswege (README-ADHOC-Doktrin; 150er = Thesis-Mess-Harness) kompilieren direkt mit
   `cl` und stoßen den neuen BUILD-zeitigen Codegen nie an → C1083 auf frischem configure-only-Tree UND
   stiller Stale-Katalog nach `m3v2_study.profile.xml`-Edit (PS1 hat keinen DEPENDS-Mechanismus).
   **Fix (Claude, Major ⇒ selbst):** beide Skripte bauen nach dem generated/-Gate idempotent
   `cmake --build (Split-Path $gen) --target comdare_limits_generated_source_catalog` mit
   LASTEXITCODE-Abbruch; README additiv um den Hinweis ergänzt.
2. **minor — apps/catalog_codegen_tool/CMakeLists.txt (22 ext-Adapter-Includes):** im ce-Standalone
   empirisch wirkungslos (Dep-Sets byte-identisch). **ABER:** Beim Entfernen brach der super-Sub-Build
   REAL (`mimalloc.h: No such file or directory` — dort aktiviert `COMDARE_HAVE_MIMALLOC=ON` echte
   Vendor-Pfade der Katalog-Kette). Der Verifier-Beweis galt nur für Standalone-Defines. **Auflösung:**
   Liste restauriert mit präzisem Kommentar (Standalone unbenutzt / super tragend; Duplikat von
   `_facade_adapter_ext_includes`); **Zentralisierung in ein geteiltes cmake/-Modul = notierte
   Folge-Hygiene.** Lehre: „empirisch bewiesen" ist konfigurationsgebunden.

## Refutiert (3) + verwertete Nebenbefunde

- ADHOC-CMAKE_BINARY_DIR-Schatten (refutiert; Hygiene-Zeile war ohnehin schon entfernt).
- test_conformance_gate-Registry-Kante (refutiert: is_original ist Provenienz-Boolean, kein Gate; Kante
  laut Registry-Doktrin harmlos-redundant) → **verwertet:** stale Root-Kommentar `:1417` additiv
  aktualisiert.
- ADHOC-Axis-Includes im super-Build (refutiert: korrekte Dirs kommen transitiv über die E3-gehärteten
  PUBLIC-Includes von workload_driver/anatomy_module_loader) → **verwerteter Nebenbefund:** die 3
  ADHOC-Targets sind im super-Sub-Build wegen mimalloc-Vendor-Includes nicht baubar — als dokumentierte
  GRENZE an der ADHOC-Funktion kommentiert (Gates 4-5 laufen standalone; super-Beweis = messung_driver).

## End-Beweise (literal, offizieller g++-16-Baum)

- Gate 4: `test_profile_roundtrip` → „STRANG-A Inc1..4 Round-Trip-Gate (gegen GOLDEN): ALLE OK (Diff leer)"
- Gate 5: `test_run_profile_union` (über den GENERIERTEN Produktiv-Pfad) → „ALLE OK";
  `test_axis_sweep_pilot` → „ALLE OK"
- Voller ctest: **„100% tests passed, 0 tests failed out of 197"** (inkl. der 5 nachregistrierten Targets)
- super-Sub-Build: `messung_driver` → „Built target messung_driver"; generierter Header entsteht unter
  `_cache_engine_external/generated/` (ce-eigenes Build-Verzeichnis)
- clang-format-22 dry-run == 0 (hpp/cpp); Mojibake == 0; golden/m3v2/source_catalog/gen_golden_fullpilot/
  adhoc_emitter byte-unberührt.
