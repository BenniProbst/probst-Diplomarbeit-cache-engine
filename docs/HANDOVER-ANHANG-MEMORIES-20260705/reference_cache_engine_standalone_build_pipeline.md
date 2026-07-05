---
name: cache-engine-standalone-build-pipeline
description: Pflicht-Reihenfolge + 3 bekannte Stolpersteine beim STANDALONE-Bauen der cache-engine Unit-Tests (ohne Diplomarbeit-Orchestrierung). Verifiziert 2026-05-28.
metadata: 
  node_type: memory
  type: reference
  originSessionId: 78cf67f8-571e-4fcd-a907-1556dbc5be72
---

Standalone-Build der cache-engine Unit-Tests (build/msvc-release, VS17 2022). Build-Dir `build/msvc-r2` aus alter Übergabe existiert NICHT mehr — `build/msvc-release` nutzen.

**Pflicht-Reihenfolge (sonst C1083-Fehler):**
1. `cmake -S . -B build/msvc-release` **einmal** genügt (seit Fix febc020). FRÜHER war 2× nötig wegen GLOB-Ordering-Bug — jetzt leitet `tests/unit/CMakeLists.txt` COMDARE_ALL_AXIS_GENERATED_DIRS aus dem SOURCE-Tree ab (ordering-invariant). Falls eine ältere Checkout-Version: 2× configure.
2. Paper-Codegen bauen (erzeugt `*_is_original.hpp`, ESET-Freigabe beim 1. Lauf): `cmake --build build/msvc-release --config Release --target comdare_paper_a04_mimalloc_codegen comdare_paper_a05_jemalloc_codegen comdare_paper_a07_snmalloc_codegen comdare_paper_a10_rpmalloc_codegen comdare_paper_a11_lrmalloc_codegen comdare_paper_a20_dlmalloc_codegen comdare_paper_p01_art_codegen comdare_paper_p02_hot_codegen comdare_paper_p05_start_codegen comdare_paper_p07_wormhole_codegen comdare_paper_p10_surf_codegen` (11 Targets, alle `module=ALL ORIGINAL`).
3. Test-Target bauen, dann `.exe` direkt ausführen (Post-Build gtest-Discovery wirft harmloses MSB3073 — ignorieren, die .exe wird trotzdem gebaut). Pfad: `build/msvc-release/tests/unit/Release/<test>.exe`.

**3 vorbestehende Blocker beim Full-Standalone-Build (NICHT fixbar ohne Zusatzschritte):**
- **q01 concurrentqueue:** GELÖST 2026-05-28 via `git submodule update --init ext/queuing/Q01-concurrentqueue` (moodycamel BSD-2, github.com/cameron314/concurrentqueue, gepinnt d655418). DANACH reconfigure → Codegen-Target `comdare_paper_q01_concurrentqueue_codegen` erscheint → bauen → topic_queuing (216) + paper_legacy_code (145) grün. WICHTIG: Bei frischem Klon `git submodule update --init --recursive` ausführen (ext-Paper sind teils Submodules, NICHT vendored — anders als ext/allocator/A04-mimalloc das committed ist). Submodule-Init ist KEINE Repo-Änderung (Pointer bereits gepinnt).
- **prt_art-abhängige Legacy-Tests:** `test_concepts_compile`, `test_value_handle`, `test_six_page_structures`, `test_three_layer_audit` includen `prt_art/*.hpp` direkt → bauen NUR im Diplomarbeit/prt-art-Kontext, NICHT cache-engine-standalone. (User-Bestätigung 2026-05-28: Diplomarbeit kompiliert cache-engine + holt prt-art.)
- **Composition-Targets ohne Glob-Var:** GEFIXT febc020 — 9 anatomy/composition tests/unit-Targets erhielten die Var. NOCH OFFEN: builder-Pilots (`anatomy_codegen_pilot_*`, `anatomy_multi_pilot_*`, `comdare_anatomy_codegen_tool`) in libs/.../builder-CMakeLists referenzieren die Var noch nicht → bauen im Full-ALL noch nicht (kein Unit-Test, niedrigere Prio).

**Verifiziertes grünes-Baseline (2026-05-28, 12 Dateien, 348 Tests):** axis_01(21) axis_02_04(13) axis_05(14) axis_07(8) axis_09(21) axis_09b(50) axis_12(17) axis_14(8) topics_fundament(16) anatomy_r4_driver(10) permutation_engine(15) topic_traversal(155). + axis_08(8 neu). topic_queuing(216) blockiert durch q01.

Siehe [[v41-open-todos-master]], [[axis-gold-standard-checklist]], [[buildsystem-not-cmake]].
