# ce test:unit ECHTES Laufzeit-Fail-Inventar — Pipeline 8112 / Job 213964 (2026-07-06 19:10)
# Literal: 66% tests passed, 62 tests failed out of 183 (nach Build-Fixes b3d02002+e3e52f92+ec0ce62a)

33 - test_module_loader (Failed)
56 - test_v41_search_algorithm_permutation_engine (Failed)
60 - test_v41_anatomy_multi_codegen (Failed)
61 - test_v41_anatomy_codegen_tool (Failed)
64 - test_v41_workload_generator (Failed)
86 - test_v41_anatomy_r5i_configure_codegen (Failed)
87 - test_v41_anatomy_f15_measurement (Failed)
97 - test_ap10_dataset_akte (Failed)
98 - test_v5_disk_memento (Failed)
106 - test_v41_anatomy_adhoc_dll_load (Failed)
107 - test_d1_d2_selection (Not Run)                    goal_v6 phase_d
108 - test_d3_ceb_generator (Not Run)                   goal_v6 phase_d
109 - test_d7_build_variant (Not Run)                   goal_v6 phase_d
110 - test_d7a_build_inspection (Not Run)               goal_v6 phase_d
111 - test_d7b_definition_per_node (Not Run)            goal_v6 phase_d
112 - test_d8_operability (Not Run)                     goal_v6 phase_d
113 - test_d9_set (Not Run)                             goal_v6 phase_d
114 - test_d9_set_adapter (Not Run)                     goal_v6 phase_d
115 - test_d10_sequence (Not Run)                       goal_v6 phase_d
116 - test_d11_view (Not Run)                           goal_v6 phase_d
117 - test_genus_docks (Not Run)                        goal_v6 phase_d
118 - test_d12_virus (Not Run)                          goal_v6 phase_d
119 - test_d13_runtime_measure (Not Run)                goal_v6 phase_d
120 - test_d14_result_ingest (Not Run)                  goal_v6 phase_d
121 - test_d14b_perm_runner (Not Run)                   goal_v6 phase_d
122 - test_a1_load_profile_opmix (Not Run)              goal_v6 phase_d
123 - test_d14c_e2e_pipeline (Not Run)                  goal_v6 phase_d
124 - test_container_genus (Not Run)                    goal_v6 phase_d
125 - test_container_dock (Not Run)                     goal_v6 phase_d
126 - test_d_v42_probe (Not Run)                        goal_v6 phase_d
127 - test_d_v42_probe2 (Not Run)                       goal_v6 phase_d
128 - test_d_v42_telemetry_observable (Not Run)         goal_v6 phase_d
129 - test_d_v42_memory_layout_observable (Not Run)     goal_v6 phase_d
130 - test_d_v42_serialization_observable (Not Run)     goal_v6 phase_d
131 - test_d_v42_node_type_observable (Not Run)         goal_v6 phase_d
132 - test_d_v42_telemetry_registry_observable (Not Run) goal_v6 phase_d
133 - test_genus_permutation_engines (Not Run)          goal_v6 phase_d
134 - test_axis_growth_policies (Not Run)               goal_v6 phase_d
135 - test_axis_view_policies (Not Run)                 goal_v6 phase_d
136 - test_migration_two_tier (Not Run)                 phase_e standalone
137 - test_seg_coverage (Not Run)                       phase_e standalone
138 - test_filter_real_from_keys (Not Run)              phase_e standalone
139 - test_patricia_real (Not Run)                      phase_e standalone
140 - test_value_handle_real (Not Run)                  phase_e standalone
141 - test_prefetch_real (Not Run)                      phase_e standalone
142 - test_prefetch_adversarial_verify (Not Run)        phase_e standalone
143 - test_prefetch_patha_t7 (Not Run)                  phase_e standalone
144 - test_cow_memento (Not Run)                        phase_e standalone
145 - test_v5_io_real_fixture (Not Run)                 io phase_e standalone
146 - test_winsorized_mean (Not Run)                    phase_e standalone stats
147 - test_conformance_gate (Not Run)                   contract gate standalone
149 - test_188_4bbV_pool_adapter_flip_compile (Not Run) contract pool_flip standalone
173 - m3v2_pmc_smoke (Not Run)                          phase_e pmc standalone
174 - test_harness_compile (Not Run)                    contract harness standalone
176 - linux_perf_pmc_smoke (Not Run)                    linux phase_e pmc standalone
177 - test_dgenus_dll (Not Run)                         dll_roundtrip goal_v6 phase_d
178 - test_buildvariant_dll (Not Run)                   dll_roundtrip goal_v6 phase_d
179 - test_buildvariant_dll_real (Not Run)              dll_roundtrip goal_v6 phase_d
180 - test_adhoc_buildvariant_dll (Not Run)             dll_roundtrip goal_v6 phase_d
181 - test_d13_dll_runtime_measure (Not Run)            dll_roundtrip goal_v6 phase_d
182 - test_cacheline_policy_selector (Not Run)          cacheline strategy tools
183 - test_load_profile_writer (Not Run)                tools workload_driver xml_export

## KLASSIFIKATION (19:15)
- **Klasse A — 10 echte Laufzeit-Fails (Wurzeln):** test_module_loader · test_v41_search_algorithm_permutation_engine · test_v41_anatomy_multi_codegen · test_v41_anatomy_codegen_tool · test_v41_workload_generator · test_v41_anatomy_r5i_configure_codegen · test_v41_anatomy_f15_measurement · test_ap10_dataset_akte · test_v5_disk_memento · test_v41_anatomy_adhoc_dll_load. Fehlerdetails im CI-Trace nicht enthalten (nur Summary) → lokal reproduzieren: `cmake --build build-cmd1b --target <die 10>` + ctest einzeln.
- **Klasse B — 52 „Not Run":** Executables fehlen unter `build-test/tests/unit/Development/…` — die Development-Testgruppe ist per add_test registriert, hängt aber NICHT am comdare_tests-Sammel-Target → EIN Registrierungs-Fix (Development-Targets in COMDARE_TEST_TARGETS/Sammel-Kante) löst alle 52.
- Fix-Reihenfolge nächster Goal-Zyklus: (1) Klasse-B-Sammel-Kante (ein CMake-Fix, 52 Tests), (2) Klasse A einzeln lokal reproduzieren+fixen (Verdacht-Überschneidungen: /tmp-Klasse Task #24, DLL-/CWD-Pfade), (3) allow_failure raus (#278).

## KLASSE-A-FEHLERBILDER (lokal reproduziert, 19:3x — 6/10 lokal, 4 CI-only)
- **A1 — Pilot-DLL-Verzeichnis-Klasse (4):** test_v41_anatomy_multi_codegen (:61 PilotDirectoryContainsExpectedDlls), test_v41_anatomy_r5i_configure_codegen (:62 ThreeDlls), test_v41_anatomy_f15_measurement (:139 handles.size()==0), test_v41_anatomy_adhoc_dll_load (:34 handles==0). WURZEL: R5G/R5I-Pilot-DLLs entstehen nur, wenn comdare_adhoc_emitter_cli zur CONFIGURE-Zeit existiert (CMakeLists ~:1414 „SKIPPED … Build emitter first, then re-configure") — frisches Configure (CI wie lokal) ⇒ Piloten fehlen ⇒ 4 Fails. SAUBERE Fix-Richtung: Pilot-Erzeugung von Configure-Zeit-Bedingung auf Build-Zeit-Custom-Command-Kette umstellen (KEIN GTEST_SKIP — wäre #12-Maskierung).
- **A2 — Workload-Generator-Vertragsbruch (1):** test_v41_workload_generator:244 `op.key <= cfg.key_max` verletzt (402 vs 200) — echter Logik-Fail im Mess-Pfad-relevanten Generator (Verdacht: Op-Typen mit key-Ableitung jenseits key_max). Quell-Analyse nötig (Generator + Test-Vertrag).
- **A3 — module_loader (1):** test_module_loader:119 Failure (nach grünem Mock-Case) — Detail-Analyse nötig.
- **CI-only (4, lokal Passed):** test_v41_search_algorithm_permutation_engine, test_v41_anatomy_codegen_tool, test_ap10_dataset_akte, test_v5_disk_memento — Verdacht /tmp-Klasse (Task #24) bzw. Workspace-Eigenheiten; nach Klasse-B-CI-Ernte (8121) gegen CI-Fehlerausgaben abgleichen.

## ERNTE 8149/Job 214367 (fbf47ada, 19:48) — 62 → 29 Fails, 84% passed, Build 0 Fehler
- **A1+CI-only (8, unverändert Failed):** permutation_engine, multi_codegen, codegen_tool, r5i_configure, f15_measurement, ap10_dataset_akte, v5_disk_memento, adhoc_dll_load — Pilot-DLL-/Umgebungs-Klasse; CI-Fehlerbilder jetzt in diesem Vollbau-Trace verfügbar (Job 214367).
- **NEU sichtbar durch 52er-Erstlauf (7):** test_d1_d2_selection (Failed), test_d_v42_memory_layout_observable (Subprocess aborted!), + 5 phase_e-standalone: migration_two_tier, seg_coverage, prefetch_real, prefetch_adversarial_verify, cow_memento (Failed) — echte Laufzeit-Fehlerbilder im Trace.
- **Not Run (14) = ZWEI Klassen:** (a) Job-Scope-Kollision: conformance_gate, 188_4bbV, harness_compile, m3v2_pmc_smoke, linux_perf_pmc_smoke laufen bereits HART in eigenen Jobs (contract:*/pmc:amd) — im unit-Job als Not Run gezählt → Design-Entscheid: ctest-Ausschluss per Label im unit-Job (KEIN Auslassen: eigene Jobs beweisen sie) ODER Doppelbau; (b) weitere Registrierungs-Gruppen ohne COMDARE_TEST_TARGETS-Property: 5× dll_roundtrip (foreach _dll ~:2036/:2085), cacheline_policy_selector, load_profile_writer, io_real_fixture, winsorized_mean — gleicher Property-Fix wie Klasse B. ctest sucht zudem in Deployment/- UND Development/-Config-Pfaden (Multi-Config-Pfadliste — beobachten).
- Fix-Reihenfolge Zyklus 9: (1) Not-Run-(b)-Property-Sweep, (2) unit-Job-Scope für (a) sauber definieren, (3) die 7 neuen Laufzeit-Fails aus Trace 214367 einzeln, (4) A1-Serie mit CI-Bildern.

## LAUFZEITBILD 1/7 (Trace 214367): test_migration_two_tier
`[ERR] HotCold: tier_migrate_step Rueckgabe > 0 (ECHTER Move, keine Simulation)` — moved=0 bei tier0=4096/tier1=0. IMigratableTier (abi_adapter ~:1557, P4/#123) bewegt im Standalone-CI-Kontext nichts; ERSTLAUF-Befund (phase_e-standalone lief nie in CI). Analyse-Increment: Bedingungen von tier_migrate_step gegen die HotCold-Test-Komposition (Move-Kriterien/Schwellen) — Mess-Pfad-relevant, KEIN Schnellfix.

## ERNTE 8169/Job 214584 (fe80a36c): Not-Run-(b)-Sweep zog die nächste Schicht — 3 WINDOWS-ONLY-TUs
`fatal error: windows.h` in test_buildvariant_dll.cpp, test_adhoc_buildvariant_dll.cpp, test_v5_io_real_fixture.cpp — die (b)-Gruppe wurde nie auf Linux gebaut (Windows-Ära). WinAPI-Umfang je TU minimal: LoadLibraryA/GetProcAddress/FreeLibrary (+ HMODULE). FIX-PLAN (nächster Zyklus, mechanisch): portables Shim je TU — `#ifdef _WIN32` windows.h/LoadLibraryA/GetProcAddress/FreeLibrary/HMODULE `#else` dlfcn.h/dlopen(RTLD_NOW)/dlsym/dlclose/void* — KEIN Gate/Skip (Tests sollen auf Linux-CI echt laufen; Symbol-Lookup identisch). Danach zeigt die nächste Ernte die Laufzeitbilder dieser 3 + der restlichen (b)-Tests.

## ERNTE 8175/Job 214641 (e6196da1): 62 → 29 → 20 Fails (89% passed), Build sauber
- dlopen-Shims WIRKEN: beide DLL-Roundtrip-Tests bauen auf Linux (lokal 2/2 Passed, echte .so-Symbol-Inspektion).
- Rest: 14 Failed + 1 aborted (echte Laufzeitliste) + 5 Not Run (= exakt die Job-Scope-Kollisionen contract|pmc).
- SCOPE-FIX gelandet (ce e62b8cf6): COMDARE_TEST_CTEST_ARGS="-LE contract|pmc" im unit-Job — die 5 laufen hart in contract:*/pmc:amd; unit-Scope sauber. Erwartete nächste Ernte: ~15 echte Laufzeit-Fails als finale #278-Arbeitsliste (dann Einzelfix-Serie: migration moved=0 [erfasst], d_v42 aborted, seg_coverage, prefetch-Paar, cow_memento, d1_d2, A1-Vierer, CI-only-Rest).

## ✅ FINALE LAUFZEITLISTE — Ernte 8180/Job 214698 (e62b8cf6): 15 Fails, 0 Not Run, 91% (164 Tests im sauberen unit-Scope)
Kurve des Abends: **62 → 29 → 20 → 15.** Scope-Fix wirkt exakt (contract|pmc laufen in eigenen Jobs).
Die 15 = Einzelfix-Serie (Fehlerbilder ALLER 15 in `20260706-278-rohdaten-trace-214698-final15.txt`):
8× Pilot-DLL/Umgebungs-Klasse (permutation_engine, multi_codegen, codegen_tool, r5i_configure, f15_measurement, ap10_dataset_akte, v5_disk_memento, adhoc_dll_load) + 7× phase_d/e (d1_d2_selection, d_v42 ABORT, migration_two_tier [moved=0, erfasst], seg_coverage, prefetch_real, prefetch_adversarial_verify, cow_memento).
Nach 15×Fix → allow_failure raus (#278-Ziel) + sanitize-Härtung.

## ✅ EINZELFIX-SERIE ABGESCHLOSSEN (Zyklus 10, 21:15) — 15 → 0 lokal (164/164), CI-Wellen 9754d692 + 861dce2d
- **W1 Pilot-DLL (4 Tests):** `lib`-Präfix vs Loader-Pattern `comdare_anatomy_perm_*` → `PREFIX ""` an 3 Erzeugungsstellen (b0f2a92f). A1-Wurzel war NICHT der R5G-2-Pass — der 2-Pass funktionierte; der Dateiname brach den Filter.
- **W2 prefetch (2):** Array256-Domänen-Treue seit #188-4c-ii vs gespreizte u64-Treiber-Keys → 0xFF-Klemme (473301de).
- **W3 honest-0-Einlösung (3):** f15/seg_coverage/cow_memento auf CMD-1-b-Echtmessung nachgezogen; fill_segment_timing_v3 mit Mindest-Op 256 (Masstree-Coverage 0.58→0.994) (074a97f9).
- **W4 d_v42_memory_layout (1):** P-MD1-#167 (32 statt 16) (9cf14469).
- **W5 migration (1):** store-backed AdHoc Array65535 statt Hülle → moved=2048 echt (9754d692).
- **W6 /tmp-Kollisionsklasse (5, NUR CI-frisch rot):** permutation_engine/codegen_tool/ap10/v5_disk_memento/d1_d2 → comdare_test_tmp.hpp-Helper (861dce2d). Job 214810: 159/164 → Beweis-Pipeline 8191 für 164/164 läuft.
- d_v42-„Subprocess aborted" war test_d_v42_memory_layout_observable (assert = W4); seg_coverage-Masstree-Abnahme (<0.90) war KEIN CMD-1-b-Schaden, sondern nk=1-Fixkosten (auch in 214698 identisch 0.58).
