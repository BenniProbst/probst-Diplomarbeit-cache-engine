# Schichten-Modell M — Diplomarbeit / CacheEngineBuilder / CacheEngine / Pruefling

**Stand:** 2026-05-18 (Phase M.2)
**Vorgaenger:** `02_aktueller_master_REV7_7.md` §2 Drei-Repo-Layer (REV7.6)
**Trigger:** User-Direktive 2026-05-18 (KRITISCHE KLARSTELLUNG)
**Ziel:** Eindeutige Trennung der 4 Subsysteme + bidirektionale Pruefling-Beziehung formalisieren.

---

## §1 KERNSATZ (User-Direktive 2026-05-18, verbatim)

> "CacheEngineBuilder und CacheEngine sind formal 2 getrennte Systeme, die dennoch zum selben Projekt gehoeren. Der CacheEngineBuilder ist ein autonomes System zum Ausmessen einer Plattform, waehrend die CacheEngine dabei als Werkzeug verwendet wird. Die CacheEngine kann einen registrierten Pruefling (PRT-ART) als Struktur ueber alle Permutationen mit einbinden und dessen Konfigurationen gegenpruefen, **waehrend dieser die CacheEngine mit benutzt, um die eigene Performance auszumessen und zu optimieren**."

**Schluesselbeobachtung:** Die CE<->Pruefling-Beziehung ist **bidirektional symmetrisch** — CE benutzt Pruefling als Permutations-Struktur UND Pruefling benutzt CE als Optimierungs-Service. Diese Symmetrie war in REV7 implizit, wird hier explizit.

---

## §2 4-Subsystem-Modell

```
+================================================================+
|  Diplomarbeit/Code/messung_driver  (OUTER-LOOP / Auswertung)   |
|  - 3 Messreihen-XML-Configs (A/B/C)                            |
|  - Loop ueber Configs                                          |
|  - ResultAggregator -> CSV/JSON -> TikZ-Diagramme              |
|  - thesis-Manuskript-Anhang                                    |
+================================================================+
                  |  konfiguriert/triggert
                  ▼
+================================================================+
|  CacheEngineBuilder  (AUTONOMES Subsystem)                     |
|  - PIKA-aehnliches Plattform-Ausmess-System                    |
|  - Phasen 1-7 Pipeline (DISCOVER/MEASURE/CLASSIFY/PUBLISH/     |
|    BIND/EXECUTE/COMPARE)                                       |
|  - Enumeriert Permutationen pro Search-Engine                  |
|  - Verwendet CacheEngine als Werkzeug                          |
|  - Verwendet IPlatformProbe fuer Auto-Discovery                |
|  Eigentumsverhaeltnis: cache-engine/apps/cache_engine_builder/ |
+================================================================+
                  |  verwendet als Werkzeug
                  ▼
+================================================================+              +======================+
|  CacheEngine  (WERKZEUG-BIBLIOTHEK)                            |◄────────────▶|  Pruefling (PRT-ART) |
|  - 12 Sub-Engines C1-C12                                       | bidirektional|                       |
|    (Layout, Pinning, Prefetch, Coherence, Telemetry,           |              |  ExecutionEngine      |
|     Allocation, Migration, Encoding, Heuristik,                |              |  registriert bei CE   |
|     Topologie, Scheduler, Filter)                              |              |                       |
|  - 29 Cache-Strategien F1-F29                                  | (a) CE -> PA |  PrtArtSearchEngine   |
|  - ~80-85 IHeuristik-Instanzen                                 | (b) PA -> CE |  PrtArtSearchEngine-  |
|  - DecisionLambdaTrees pro Baustein                            |              |    Adapter            |
|  - ObserverRegistry + Event-Hierarchie                         |              |                       |
|  - ConcurrencyManager (8 Disziplinen + 3 Mechaniken)           |              |  - Nutzt CE-Services  |
|  Eigentumsverhaeltnis: cache-engine/libs/cache_engine/         |              |    (Telemetry,        |
+================================================================+              |     Prefetch,         |
                                                                                |     Heuristik)        |
                                                                                +======================+
```

### §2.1 Subsystem-Rollen-Tabelle

| Subsystem | Rolle | Eigentumsverhaeltnis | Eigenstaendigkeit |
|---|---|---|---|
| **Diplomarbeit/Code/messung_driver** | Auswertung-Orchestrator (OUTER LOOP) | `Diplomarbeit/Code/messung_driver/` | eigenes Repo + eigene Build-Unit |
| **CacheEngineBuilder** | Autonomes Plattform-Ausmess-System | `cache-engine/apps/cache_engine_builder/` | eigenes Executable, kann ohne `messung_driver` laufen |
| **CacheEngine** | Werkzeug-Bibliothek (Cache-Optimierungs-Services) | `cache-engine/libs/cache_engine/` | Library (.lib/.so), keine main() |
| **Pruefling (PRT-ART)** | Registrierte ExecutionEngine + CE-Konsument | `comdare-prt-art/prt_art/` | Library + Tests, baut auf CE auf |

### §2.2 Beziehungs-Tabelle

| Pfeil | Richtung | Bedeutung | Konkrete API |
|---|---|---|---|
| 1→2 | messung_driver → CacheEngineBuilder | konfiguriert + triggert Permutations-Lauf | `messung_driver` ruft `CacheEngineBuilder::build(config_xml)` |
| 2→3 | CacheEngineBuilder → CacheEngine | verwendet als Werkzeug | `CacheEngineBuilder` instantiiert `CacheEngine cache_engine_;` |
| 3↔4 | **CacheEngine ↔ Pruefling (bidirektional)** | (a) CE bindet Pruefling ein + (b) Pruefling nutzt CE | siehe §3 |

---

## §3 Bidirektionale CE↔Pruefling-Beziehung (KERN)

### §3.1 Richtung (a): CE → Pruefling

**Was:** CacheEngine instantiiert PRT-ART als ExecutionEngine pro Permutations-Config.

**Wann:** Phase 5 (BIND) im CacheEngineBuilder-Pipeline.

**Wie:**
```cpp
// Im CacheEngine
class CacheEngine {
  std::vector<IExecutingEngine*> registered_engines_;

  void register_engine(IExecutingEngine& engine) {
    registered_engines_.push_back(&engine);
  }

  void execute_permutation(const PermutationDescriptor& desc) {
    auto engine = select_engine(desc.engine_kind);  // z.B. PrtArt
    engine->configure(desc.algo_baustein_set);
    engine->execute(desc.workload);
  }
};
```

**Pruefling-Erwartung:** Pruefling exponiert `IExecutingEngine`-Interface (notify_*, execute, configure).

### §3.2 Richtung (b): Pruefling → CE

**Was:** Pruefling ruft CacheEngine-Services waehrend eigener Lookups.

**Wann:** zur Laufzeit, in jeder lookup()/insert()/scan()-Operation.

**Wie:**
```cpp
// In comdare::prt_art
template <Key, Value, ...>
class prt_art : public ISearchEngine<Key, Value> {
  CacheEngine* cache_engine_;  // injiziert beim Constructor / register_engine()

  optional<Value> lookup(const Key& key) const {
    // (b) Pruefling nutzt CE-Services
    auto& telemetry = cache_engine_->get_telemetry_strategy();
    telemetry.notify_lookup_start(key);

    auto& prefetcher = cache_engine_->get_prefetch_strategy();
    prefetcher.prefetch(predicted_address);

    auto& heuristic = cache_engine_->get_heuristic_for(HeuristicKind::HotPath);
    auto layout_hint = heuristic.recommend(LiveModel{});

    // ... eigener Algorithmus-Lookup ...

    telemetry.notify_lookup_complete(result);
    return result;
  }
};
```

**CacheEngine-Erwartung:** CacheEngine bietet stabile Service-API (Telemetry/Prefetch/Heuristik/...) — siehe `04_konzepte_saeule_b.md`.

### §3.3 Symmetrie-Pflicht

Beide Richtungen MUESSEN im UML (`05_uml_klassen.md`), im drawio (P.2 Tab "Bidirektionale CE↔Pruefling Beziehung") und im Code (`prt_art_search_engine_adapter.hpp` mit Composition CacheEngine&) explizit sein.

---

## §4 Abgrenzung CacheEngineBuilder vs CacheEngine

| Eigenschaft | CacheEngineBuilder | CacheEngine |
|---|---|---|
| **Typ** | Executable (`main()`) | Library (.lib/.so) |
| **Eigenstaendigkeit** | Autonomes Subsystem, eigenes Programm | Wird von CEB UND von Pruefling konsumiert |
| **Hauptaufgabe** | Plattform AUSMESSEN (Phasen 1-7) | Cache-Optimierungs-Services BEREITSTELLEN |
| **Zustand** | Pipeline-Zustand (Phase 1 done? Phase 2 in progress?) | langlebige Service-Instanzen + ObserverRegistry |
| **Lifecycle** | Per Messreihe gestartet + beendet | Singleton zur Laufzeit, lange lebend |
| **Eigentumsverhaeltnis** | `cache-engine/apps/cache_engine_builder/main.cpp` | `cache-engine/libs/cache_engine/cache_engine.hpp` |
| **Aussen-API** | CLI + XML-Config-Input | C++23 Concept-API (ICacheEngine + 12 Sub-Engines) |
| **Wer triggert es?** | `messung_driver` (Diplomarbeit/Code/) ODER User direkt | CacheEngineBuilder + Pruefling |
| **Phasen 1-7 Bezug** | OWNED — CEB ist der Phasen-Treiber | KONSUMIERT — CE liefert nur Sub-Services pro Phase |

**Wichtig:** CEB UND CE liegen im selben Repo (`cache-engine/`), sind aber 2 unabhaengige Subsysteme. CEB ist ein App-Konsument der CE-Bibliothek.

---

## §5 Phasen 1-7 Zuordnung (K11 Pipeline klargestellt)

K11-Tab zeigt 7 Phasen monolithisch. M-Klarstellung:

| Phase | Owner | CE-Services konsumiert |
|---|---|---|
| 1 DISCOVER | **CEB** | `IPlatformProbe` (CE-Service) |
| 2 MEASURE | **CEB** | `IPlatformPropertyClassifier`, Mikrobenchmark-Suite |
| 3 CLASSIFY | **CEB** | `IPlatformPropertyClassifier`, `PropertySet` |
| 4 PUBLISH | **CEB** | `ICacheEngineOptionPublisher` (CE-Service) |
| 5 BIND | **CEB + CE** | CEB instantiiert ExecutionEngine (Pruefling) ueber CE-Registry |
| 6 EXECUTE | **Pruefling + CE** | Pruefling laeuft + ruft CE-Services (Telemetry/Prefetch) |
| 7 COMPARE | **CEB** | CEB aggregiert Measurement-Results aus mehreren Phase-6-Laeufen |

**Konsequenz:** Phase 6 (EXECUTE) ist die einzige Phase wo der Pruefling aktiv ist. Phasen 1-5 + 7 sind reines CEB-Territorium.

---

## §6 Multi-Pruefling-Faehigkeit

Die CE kann **mehrere Pruefling-Implementationen** gleichzeitig registriert haben:

```cpp
CacheEngine ce;
ce.register_engine(prt_art_v1);
ce.register_engine(art_baseline);
ce.register_engine(hot_baseline);

CacheEngineBuilder ceb(ce);
ceb.execute_messreihe_a(config_xml);  // Vergleich PRT-ART vs ART vs HOT
```

Dies entspricht **Messreihe A** (PRT-ART vs SOTA). Die anderen Pruefling-Wrapper sind 22 V31-Adapter (12 SOTA + 10 Allokator).

---

## §7 Cross-Refs

- **REV7.7 Master:** `02_aktueller_master_REV7_7.md` §2 Drei-Repo-Layer
- **K01 Drei-Ebenen-Architektur:** Soll-Korrektur via M.4 (#461)
- **REV7-Master drawio:** Soll-Korrektur via M.3 (#460)
- **U10 prt_art-UML:** Soll-Korrektur via M.5 (#462)
- **thesis Kapitel 03 Architektur:** Soll-Erweiterung via M.6 (#463)
- **drawio REV8 4-Box-Schema:** P.1 (#480)
- **drawio REV8 bidirektionale Beziehung:** P.2 (#481)
- **K11 Pipeline CEB-Spalte:** P.5 (#484)

---

## §8 Implementierungs-Konsequenzen fuer V32+ Sprints

| Konsequenz | Was | Wo |
|---|---|---|
| 1 | `cache-engine/apps/cache_engine_builder/main.cpp` muss klar als App separiert sein | cache-engine V23.B (DONE) |
| 2 | `CacheEngine::register_engine(IExecutingEngine&)` muss public + dokumentiert sein | V32 Code-Audit |
| 3 | `prt_art` Constructor muss `CacheEngine&` annehmen | V32 Refactor — heute optional, dann pflicht |
| 4 | Tests fuer **bidirektionale** Beziehung (CE registriert PRT-ART + PRT-ART nutzt CE-Telemetry) | V32 Test-Erweiterung |
| 5 | thesis-Kapitel 03 muss diese Bidirektionalitaet erklaeren | M.6 (#463) |

---

**Ende docs/architektur/10_schichten_modell_M.md (Phase M.2 DONE).**
