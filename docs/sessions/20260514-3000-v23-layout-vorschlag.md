# V23 Layout-Vorschlag (4-Bereiche-Layout)

## §1 Ziel-Layout cache-engine

Empfehlung aus Web-Recherche (ClickHouse-`src/Common/` + Pitchfork-`libs/` + Folly-`experimental/`-Idiom invertiert zu `deprecated/`):

```
comdare-cache-engine/
├── build/                       # gitignored, alle Presets darunter
├── apps/                        # Top-Level Executables
│   └── cache_engine_builder/    # main.cpp + CLI-Wrapper (heute: cache_engine/builder/main.cpp)
├── libs/
│   ├── domain/                  # Cache-spezifische Logik
│   │   ├── cache_engine/        # ICacheEngine, Hierarchy, Heuristik (heute: cache_engine/)
│   │   ├── search_engine/       # ABI + i_search_engine + i_cache_page Konzepte
│   │   │                        #   (heute: search_engine/ + prt_art/include/concepts/)
│   │   ├── builder/             # ExperimentDriver, Codegen, Phasen 1-7
│   │   │                        #   (heute: cache_engine/builder/ minus main.cpp)
│   │   ├── execution_engine/    # ResultAggregator, ExperimentDemo
│   │   │                        #   (heute: experiment/)
│   │   └── allocator/           # 4+2 Pools (Cache-Engine-Basisdisziplin)
│   │                            #   (heute: cache_engine/allocators/)
│   ├── common/                  # Cross-Cutting (ClickHouse-Stil)
│   │   ├── serialization/       # xml_config_parser
│   │   │                        #   (heute: cache_engine/builder/xml_config_parser/)
│   │   ├── io/                  # File, Stream, Buffer (NEU)
│   │   ├── logging/             # (NEU — std::cerr-Wrapper)
│   │   ├── error/               # ErrorCodes, status_t-Konvention (NEU, ClickHouse-Pattern)
│   │   ├── concurrency/         # OLC, RCU, Hazard Pointers
│   │   │                        #   (heute: ggf. in cache_engine/concurrency/)
│   │   ├── platform/            # CPU detect, NUMA, ISA detect
│   │   │                        #   (heute: hardware_isa/)
│   │   ├── measurement/         # HW counters, telemetry
│   │   │                        #   (heute: measurement/)
│   │   └── succinct/            # SDSL-Portierung (BitVector, LOUDS)
│   │                            #   (heute: succinct/)
│   ├── test_infra/              # Test-Werkzeuge (KEINE Tests selbst)
│   │   ├── workload_generator/  # YCSB-synth (heute: workload_generator/)
│   │   ├── test_data/           # Test-Data-Engine (heute: test_data_accumulation/)
│   │   └── benchmark_suite/     # Mikrobench (heute: benchmark_suite/)
│   ├── adapters/                # P01-P33 Adapter (heute: adapters/, leer)
│   └── deprecated/              # Folly-Stil, option(COMDARE_BUILD_DEPRECATED OFF)
│       └── README.md            # "scheduled for removal in vX.Y, do not use"
├── ext/                         # 22 Sub-Repos (P01-P30 + A01-A20) — bleibt
├── tests/                       # GoogleTest, +tests/data/ + tests/fixtures/external/
├── tools/                       # Dev-Skripte (NEU: fetch_testdata.sh, .bat)
├── cmake/                       # Helper-Module (bleibt)
├── docs/                        # Architektur, Sessions (BLEIBT VOLLSTAENDIG)
├── benchmarks/                  # bleibt (Konfig fuer benchmark_suite-Runs)
├── algorithm_profiles/          # XML-Profile (heute: cache_engine/algorithm_profiles/)
├── CMakePresets.json            # NEU: alle Presets unter build/<preset>/
├── CMakeLists.txt               # Top-Level
├── README.md
└── .gitignore                   # erweitert: /build/, /tests/fixtures/external/
```

## §2 Was wo hinkommt — Source-Mapping

| Heute | Morgen | Anmerkung |
|---|---|---|
| `cache_engine/` (134 .hpp + 7 .cpp) | `libs/domain/cache_engine/` + `libs/domain/builder/` + `libs/domain/allocator/` | aufgeteilt in 3 Komponenten, jedes mit src+include+tests |
| `cache_engine/builder/main.cpp` | `apps/cache_engine_builder/main.cpp` | Builder-Programm raus aus Lib |
| `cache_engine/builder/xml_config_parser/` | `libs/common/serialization/xml_config_parser/` | Cross-Cutting |
| `prt_art/include/concepts/i_*.hpp` (11 Header) | `libs/domain/search_engine/include/comdare/search_engine/concepts/` | ABI-Konzepte |
| `prt_art/include/page_structures/*.hpp` (6) | **prt-art-Repo** (Implementation) | gehoert zum Pruefling |
| `prt_art/include/interpreters/*.hpp` (6) | **prt-art-Repo** (Implementation) | gehoert zum Pruefling |
| `prt_art/{allocator,concurrency,...}/` (Stubs) | **`libs/deprecated/prt_art_stubs/`** | Folly-Stil, geplante Removal |
| `experiment/` | `libs/domain/execution_engine/` | umbenannt |
| `workload_generator/` | `libs/test_infra/workload_generator/` | |
| `test_data_accumulation/` | `libs/test_infra/test_data/` | umbenannt |
| `benchmark_suite/` | `libs/test_infra/benchmark_suite/` | |
| `adapters/` | `libs/adapters/` | |
| `succinct/` | `libs/common/succinct/` | |
| `hardware_isa/` | `libs/common/platform/` | umbenannt zu Konvention |
| `measurement/` | `libs/common/measurement/` | |
| `tools/` (2 .cpp) | je nach Inhalt: `apps/<name>/` oder `libs/common/...` | inhaltsabhaengig |
| `engine_choice/` | `libs/common/config/` | umbenannt |
| `cache_engine/algorithm_profiles/` | Top-Level `algorithm_profiles/` | wird von Top-Level konsumiert |
| `modules/` (leer) | **GELOESCHT** | |
| `datasets/` (leer) | `tests/fixtures/external/` (gitignored) | umgewidmet |
| `build*/` (8 Dirs) | `build/` (1 Dir, gitignored) | |
| `docs/` | `docs/` | UNVERAENDERT, vollstaendig |
| `cmake/` | `cmake/` | |
| `ext/` | `ext/` | |
| `tests/` | `tests/` + `tests/data/` + `tests/fixtures/external/` | |
| `benchmarks/` | `benchmarks/` | |

## §3 Phasen-Plan (V23.A bis V23.F)

Wegen Groesse (3 Repos, 280+ Source-Dateien betroffen, Submodule-Pin-Kette) verteile ich auf 6 Phasen die nacheinander committed werden. Nach jeder Phase: cmake configure + ctest VERIFIZIEREN, dann commit + push + Pin-Bump.

| Phase | Was | Risiko | Reversibilitaet |
|---|---|---|---|
| **V23.A** Cleanup | Build-Dirs loeschen, leere Ordner weg, `.gitignore`, `CMakePresets.json` | niedrig | hoch (kein Code beruehrt) |
| **V23.B** apps/ extrahieren | nur `main.cpp` raus aus `cache_engine/builder/`, neuer `apps/cache_engine_builder/` | mittel | mittel (1 Pfad in CMake) |
| **V23.C** libs/common/ aufbauen | xml_config_parser + succinct + hardware_isa + measurement migrieren | hoch | mittel (Include-Pfade) |
| **V23.D** libs/domain/ aufbauen | cache_engine + experiment + search_engine + allocator + builder migrieren | sehr hoch | mittel (massiv Includes + CMake) |
| **V23.E** prt_art/-Subsumption | i_*.hpp nach search_engine, Rest in deprecated/ | hoch | hoch (Header-Verschiebung dokumentiert) |
| **V23.F** test_infra + adapters + Final | Restmigrationen + alle 3 Repos verifizieren + Diplomarbeit-Pin-Bump | mittel | mittel |

## §4 Was im Repo "Diplomarbeit" passiert (parallel)

| # | Was | Phase |
|---|---|---|
| V23.X1 | `Code/test_data_xml/` neu anlegen (User-Anforderung: eigene Testdatensatz-XMLs) | parallel zu V23.A |
| V23.X2 | `Code/external/comdare-cache-engine` Pin-Bumps nach jedem cache-engine-Push | nach jeder Phase |
| V23.X3 | thesis chapter 04 + chapter 06 Pfad-Updates (falls cache-engine-Pfade zitiert) | nach V23.F |

## §5 Drei-Repo-Risiko

Pin-Disziplin nach jeder Phase:
1. cache-engine push → neuer commit-Hash
2. Diplomarbeit Submodule update auf neuen Hash → Pin-Bump-Commit
3. prt-art muss CACHE-ENGINE Headers konsumieren — falls Pfade in prt-art geaendert werden muessen, separat im prt-art-Repo + Pin-Bump dort
4. CI in allen 3 Repos (GitLab + GitHub) muss durchlaufen

**Gesamtrisiko Aufwand:** ~2-3 Sessions, je nach wie tief V23.D geht.

## §6 Was BEWUSST nicht refactoriert wird

- `ext/` — Submodules sind klar, Pfade etabliert
- `docs/` — Inhalt vollstaendig erhalten (User-Direktive)
- `algorithm_profiles/` Inhalt — XML bleibt wie es ist (V19/V20-Schema)
- `cmake/` Module — bleiben wo sie sind
- ABI `module_abi_v1.hpp` — bleibt im selben relativen Pfad innerhalb der neuen `libs/domain/cache_engine/include/.../abi/`-Hierarchie
