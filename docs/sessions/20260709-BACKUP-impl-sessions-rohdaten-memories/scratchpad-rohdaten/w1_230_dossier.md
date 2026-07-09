# DOSSIER W1/#230-Rest — Harness-/Treiber-Compile-Gate in der CI (cache-engine)

Du bist der IMPLEMENTIERUNGS-Agent. Implementiere GENAU den unten spezifizierten Increment im Arbeitsbaum.
NICHT committen, NICHT pushen, NICHT builden (KEIN lokaler C++-Compiler; statisch sorgfältig prüfen).
Abschlussbericht: geänderte Dateien + Entscheidungen + Risiken.

## 1) Repo/Stand
Repo-Wurzel = Arbeitsverzeichnis (comdare-cache-engine, main, HEAD 46e6ce6, Arbeitsbaum sauber).
C++23, Boost.MP11, GTest; CI-Jobs bauen ISOLIERTE Targets via `cmake --build --target X` auf Linux-g++/Ninja.

## 2) Problem (#230, E4-Harness-Verifikationslücke — Scope nach Teil-Abdeckung)
Die contract-Stage compiliert inzwischen den ABI-Adapter + alle 9 Pool-Organe (`contract:pool_flip` →
`tests/unit/test_188_4bbV_pool_adapter_flip_compile.cpp`) und die Organ-Konformität (test_188_4bb0, lokal).
NICHT CI-compiliert ist der HOST-TREIBER-Stack (das „thesis_tiere-Harness"): 
`libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp` (LazyIterator/CSV/Resume),
`libs/cache_engine/builder/experiment_tree/perm_runner.hpp` (run_observable_perm/run_workload_perm/Gate),
+ deren Kontext (experiment_tree.hpp, result_ingest, workload_orchestrator, pmc_source_factory …).
`.gitlab-ci.yml` (contract:conformance-Kommentar) sagt wörtlich „kein cl/thesis_tiere-Harness". Ein Bruch in
diesen god-headern fällt heute erst beim lokalen Windows-Build auf. GENAU JETZT kritisch: die 4 kommenden
Node-Shape-Achsen (W2) fließen über Registry→Iterator/Runner — sie sollen AB ENTSTEHUNG harness-gegated sein.

## 3) SOLL — EIN neues Standalone-Compile+Smoke-Target + EIN CI-Job
### (A) `tests/unit/test_harness_compile.cpp` (NEU, plain int main, KEIN gtest, KEINE DLL-Builds, KEIN Mess-Lauf)
Zweck = COMPILE-Gate der Host-Treiber-Header + minimaler Instanziierungs-Smoke, CI-schnell (<~1 min Laufzeit):
- Inkludiere die schweren Treiber-Header: `builder/experiment_tree/cache_engine_builder_iterator.hpp` und
  `builder/experiment_tree/perm_runner.hpp` (transitiv ziehen sie experiment_tree/Registry/Anatomie).
  PRÜFE selbst per Lesen, welche weiteren Top-Header des Harness sinnvoll+kompilierbar sind (z. B.
  `builder/experiment_tree/experiment_tree.hpp`), und nimm sie auf, WENN sie ohne DLL-/Datei-Seiteneffekte
  header-only instanziierbar sind. AUSDRÜCKLICH AUSSERHALB des Scopes: run_lazy/DLL-Loader-LAUF, echte Messung,
  CSV-Dateien schreiben (kein Disk-Artefakt im CI ausser stdout).
- Smoke-Checks (nur billige, deterministische, seiteneffektfreie Aufrufe — lies die Header und wähle exakt
  solche): z. B. Baum-/AxisLevels-Aufbau via der registry-getriebenen Konstruktion (BR-1), Iteration weniger
  Knoten, `lazy_csv_header()`-String nicht-leer + enthält erwartete Spaltenpräfixe (stat_/seg_), Konstruktion
  eines `PermResult`/`LazyMeasuredRow` + `format_csv_row` auf Default-Werten (string nicht-leer). KEINE
  Adapter-/DLL-Instanz nötig (das deckt 4bbV). check()-Muster wie test_conformance_gate (g_fail/exit-code).
- Deutscher Banner-Kommentar: #230-Rest, warum (E4-Lücke, W1-Kopf vor den Shape-Achsen), was BEWUSST nicht
  (kein Lauf/keine DLLs — nur Compile+Smoke der Treiber-Schicht).
### (B) `tests/unit/CMakeLists.txt` — Target nach m3v2_pmc_smoke-Vorlage (direkt daneben einordnen):
add_executable + cxx_std_23 + include-Dirs {libs/cache_engine, include, src, builder, libs/common,
${CMAKE_BINARY_DIR}/generated, ${COMDARE_ALL_AXIS_GENERATED_DIRS}} + Boost::mp11 +
comdare_set_platform_defines + COMDARE_MEASUREMENT_ON=1 COMDARE_CE_ENABLE_STATISTICS=1
COMDARE_EXPERIMENT_MODE_ON=1 + add_test + LABELS "contract;standalone;harness".
Falls der Iterator-Stack weitere Link-/Include-Anforderungen hat (lies die anderen Targets, die iterator/
perm_runner ziehen — z. B. Boost-Tests in COMDARE_PHASE_E_BOOST_TESTS): SPIEGELE deren Include-Satz exakt.
### (C) `.gitlab-ci.yml` — Job `contract:harness` EXAKT nach `contract:pool_flip`-Vorlage
(eigener build-Ordner `build-harness`, needs lint:secrets, tags [baremetal], artifacts paths [],
Kommentar-Banner analog: #230-Rest, E4-Lücke, W1-Gate vor den Node-Shape-Achsen).

## 4) Verbote/Constraints (STRIKT)
- NUR diese 3 Dateien anfassen (Test NEU, CMakeLists + CI-YAML erweitern). NICHTS an abi_adapter/Organen/
  Registry/iterator/perm_runner SELBST ändern — wenn etwas nicht header-only kompilierbar scheint, NICHT den
  Treiber patchen, sondern den betreffenden Include/Check weglassen und im Bericht als Befund notieren.
- modules/**, ext/**, cmake/**, Root-CMakeLists: TABU. Keine neuen CMake-Optionen. Keine Format-Sweeps.
- Der Test darf KEINE Dateien schreiben, keine env-Abhängigkeit haben, keine DLLs laden, nicht threaden.
- Deutscher Kommentar-Stil wie die Nachbar-Targets; Task-Tag `#230`.

## 5) DoD + Bericht
Target + Job stehen; Test statisch schlüssig (Includes/Namespaces/Signaturen gegen die realen Header geprüft);
Bericht: welche Header/Smokes aufgenommen, welche bewusst ausgelassen (+warum), Risiken.
