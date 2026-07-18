# Y.4 — Cross-Repo Klassen-Beziehungen + Submodule-Pin-Status

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-18 (Y.4)
**Vorgehen:** Cross-Repo API-Grenzen + Submodule-Pins + bidirektionale CE↔Pruefling-Beziehung

> Ist-Bestandsaufnahme der API-Grenzen zwischen den drei Repos. Welche Klassen sprechen ueber Repo-Grenzen? Wo sind Submodule-Pins gesetzt? Diese Doku ist Basis fuer Z.4 (Soll-UML Cross-Repo).

---

## §1 Submodule-Pin-Status (Stand 2026-05-18)

| Container-Repo | Submodule-Pfad | Pinned-HEAD | Submodule-Repo |
|---|---|---|---|
| **Diplomarbeit-Datenbanken** | `Code/external/comdare-cache-engine` | `16176ee` | comdare-cache-engine V31.F |
| **Diplomarbeit-Datenbanken** | `Code/external/comdare-prt-art` | `1a36ab4` | comdare-prt-art V31.F Pin |
| **comdare-prt-art** | `external/comdare-cache-engine` | (eigener Pin) | comdare-cache-engine V31.F |

**Eigentumsverhaeltnis:**
- Diplomarbeit-Datenbanken Top-HEAD: `9ecdd3f` (heute, 2026-05-18, alle Konsolidierungs-Doks + Pre-flight-Infra)
- comdare-cache-engine HEAD: `16176ee` (V31.F Teil 1 + 22 V31-Adapter-Smoke-Tests)
- comdare-prt-art HEAD: `1a36ab4` (Pin cache-engine V31.F)

**Pflicht-Update-Reihenfolge bei V32+:**
1. comdare-cache-engine Refactor + Push + Tag
2. comdare-prt-art Refactor + Submodule-Pin-Bump cache-engine + Push + Tag
3. Diplomarbeit-Datenbanken Submodule-Pin-Bump cache-engine + prt-art + Push

---

## §2 Cross-Repo Klassen-Beziehungen (Ist)

### §2.1 Diplomarbeit/Code → comdare-cache-engine (Subsystem 1 → 2)

| Diplomarbeit-Klasse | cache-engine-Klasse | Methode |
|---|---|---|
| `messung_driver/main.cpp` | `CacheEngineBuilder` (apps/cache_engine_builder/main.cpp) | invokes als Subprozess oder direkt via Builder-API |
| `messung_driver/main.cpp` | `ExperimentDriver` (libs/cache_engine/builder/experiment_driver/) | direkt via Library-Link |
| `messung_driver/main.cpp` | `ResultAggregator` (libs/cache_engine/concepts/) | Direkt im selben Prozess |
| `binary_to_csv/binary_to_csv.cpp` | `PermutationResult` (libs/cache_engine/concepts/permutation_flags.hpp) | Read binary-Serialisierung |

### §2.2 Diplomarbeit/Code → comdare-prt-art (Subsystem 1 → 4)

| Diplomarbeit-Klasse | prt-art-Klasse | Methode |
|---|---|---|
| `messung_driver/main.cpp` | `PrtArtSearchEngineAdapter` (prt_art/identity/) | Pruefling-Registrierung bei CacheEngine |

### §2.3 comdare-cache-engine → comdare-prt-art (Subsystem 3 → 4, M-Bidirektional Richtung a)

| cache-engine-Klasse | prt-art-Klasse | Methode |
|---|---|---|
| `CacheEngine::register_engine(IExecutingEngine&)` | `PrtArtSearchEngineAdapter : IExecutingEngine` | Registrierung (Phase 5 BIND) |
| `ExperimentDriver::execute_one(perm, workload)` | `PrtArtSearchEngineAdapter::execute(workload)` | Pruefling-Aufruf (Phase 6 EXECUTE) |

### §2.4 comdare-prt-art → comdare-cache-engine (Subsystem 4 → 3, M-Bidirektional Richtung b)

| prt-art-Klasse | cache-engine-Klasse | Methode |
|---|---|---|
| `PrtArtSearchEngine::lookup(key)` | `CacheEngine::get_telemetry_strategy()` | Per-Lookup CE-Service-Call (Achse 11) |
| `PrtArtSearchEngine::lookup(key)` | `CacheEngine::get_prefetch_strategy()` | Prefetch-Service-Call (Achse 7) |
| `PrtArtSearchEngine::lookup(key)` | `CacheEngine::get_heuristic_for(HeuristicKind)` | Heuristik-Service-Call (C09 Heuristik-Cluster) |
| (V32+) `PrtArtSearchEngine` | `CacheEngine::get_scheduler()` | Scheduling-Service (Achse 13, NEU) |

**Bidirektionale Beziehung verankert in M-Modell-Doku** (`docs/architektur/10_schichten_modell_M.md` §3.1 + §3.2).

---

## §3 ABI-Grenzen (Stand V31.F)

### §3.1 IExecutingEngine (libs/cache_engine/include/cache_engine/abi/execution_engine.hpp)

Concept-Interface fuer Pruefling-Klassen. PrtArtSearchEngineAdapter implementiert dies.

### §3.2 ISearchEngine (libs/cache_engine/include/cache_engine/abi/search_engine.hpp)

Container-API mit V12.A/B Erweiterungen:
- 1 Template-Param = std::vector-API
- 2 Template-Params = std::map-API
- N>2 Template-Params = map<Key, tuple<V1..VN>>-API
- Schreib-/IO-Ops returnen `Status` (errno-style)

### §3.3 ICacheEngine (libs/cache_engine/include/cache_engine/concepts/i_cache_engine.hpp)

CacheEngine-Service-API. Wird vom Pruefling KONSUMIERT (M.3 Richtung b).

### §3.4 ModuleABI V1 (libs/cache_engine/include/cache_engine/abi/module_abi_v1.hpp)

Cross-DLL ABI fuer Dynamic-Loading von Permutations-Modulen.

---

## §4 V32+ ABI-Erweiterungen (geplant)

### §4.1 PermutationFlags 9 → 14 Banks (V32.2)

- Cross-Repo-Impact: alle DLL-Module muessen neu kompiliert werden (Bitfield-Layout-Aenderung)
- Migrations-Mapper alt → neu erforderlich fuer Backward-Compat

### §4.2 PrtArtSearchEngine Template-Params 12 → 20+ (V32.1)

- Cross-Repo-Impact: prt-art-internal, nur Adapter `PrtArtSearchEngineAdapter` bleibt stabil (Bridge zur ABI)
- Default-Variants sorgen fuer Bestand der V31.F Smoke-Tests

### §4.3 xml_config_parser 14 Banks (V32.3)

- Cross-Repo-Impact: messung_driver-XML-Configs muessen Sub-Bank-Tags ergaenzen
- Alte Configs weiterhin parsebar via Defaults

### §4.4 Codegen-Templates (V32.4)

- Cross-Repo-Impact: prt-art-Codegen erbt Cache-Engine-Codegen-Templates via Submodule
- Templates generieren 82-bit-Encoder/Decoder

---

## §5 Datenfluss-Sequenz (Master-Beispiel: Messreihe A)

```
1. User: ./messung_driver --config=test_data_xml/config_a_prt_art_vs_sota.xml --mode=defined

2. messung_driver liest XML, iteriert ueber Tupel.

3. Pro Tupel:
   3.1 messung_driver -> CacheEngineBuilder.build_for_engine(prt_art_adapter)
                              | M.3 Phase 1 DISCOVER
                              | M.3 Phase 2 MEASURE
                              | M.3 Phase 3 CLASSIFY
                              | M.3 Phase 4 PUBLISH
   3.2 CacheEngineBuilder -> CacheEngine.register_engine(prt_art_adapter)     [Phase 5 BIND]
   3.3 CacheEngineBuilder -> CacheEngine.execute(permutation, workload)         [Phase 6]
                            CE -> PrtArtAdapter.execute(workload)
                            PrtArtAdapter -> PrtArtSearchEngine.lookup(key) ...
                                              PrtArt -> CacheEngine.get_telemetry()   [Richtung b]
                                              PrtArt -> CacheEngine.get_prefetch()    [Richtung b]
                                              PrtArt -> CacheEngine.get_heuristic()   [Richtung b]
   3.4 PrtArt -> liefert PermutationResult zurueck an CE -> CacheEngineBuilder
   3.5 CacheEngineBuilder -> ResultAggregator.collect(result)

4. CacheEngineBuilder -> Phase 7 COMPARE (Aggregation ueber alle Tupel)

5. messung_driver -> binary_to_csv (results.bin -> results.csv)
6. messung_driver -> csv_to_latex (results.csv -> results.tex)
7. messung_driver -> diagram_generator (results.bin -> plot.tex)
8. (User) -> latex_to_pdf (thesis-Anhang final)
```

**Wichtig:** Die bidirektionale CE↔Pruefling-Symmetrie zeigt sich in 3.3 — CE ruft PrtArt (Phase 6), aber PrtArt ruft auch CE-Services waehrend des Lookups.

---

## §6 Repo-Pin-Synchronisation V32-Workflow

```
Schritt 1: comdare-cache-engine V32-Sprint
  git checkout -b v32-staging
  # ... V32.2 + V32.3 + V32.4 Refactor + U.1 Tests ...
  git tag v32.0-staging
  git push origin v32-staging --tags

Schritt 2: comdare-prt-art V32-Sprint
  cd external/comdare-cache-engine
  git checkout v32.0-staging
  cd ../..
  git add external/comdare-cache-engine
  git commit -m "Pin cache-engine V32.0-staging"
  # ... O.3 Spiegel-Module + V32.1 Template + U.2 Tests ...
  git tag v32.0-staging
  git push origin v32-staging --tags

Schritt 3: Diplomarbeit-Datenbanken V32-Sprint
  cd Code/external/comdare-cache-engine
  git checkout v32.0-staging
  cd ../comdare-prt-art
  git checkout v32.0-staging
  cd ../../..
  git add Code/external/
  git commit -m "Submodule-Pin-Bumps fuer V32.0-staging"
  git push origin main

Schritt 4: V32-Final-Tag in allen 3 Repos wenn Verifikation OK
  cd Code/external/comdare-cache-engine
  git tag v32-final && git push --tags
  cd ../comdare-prt-art
  git tag v32-final && git push --tags
  cd ../../..
  git tag v32-final && git push --tags
```

---

## §7 Querverweise

- Y.1 Cache-Engine: `Y1_cache_engine_ist_kartografie.md`
- Y.2 PRT-ART: `Y2_prt_art_ist_kartografie.md`
- Y.3 Diplomarbeit/Code/: `Y3_diplomarbeit_code_ist_kartografie.md`
- M-Modell + Bidirektional: `../architektur/10_schichten_modell_M.md`
- V32 Code-Refactoring-Plan: `../adapters/V32_CODE_REFACTORING_PLAN.md` §7 Sprint-Workflow

---

**Ende docs/uml_planning/Y4_cross_repo_beziehungen.md (Y.4 DONE).**
