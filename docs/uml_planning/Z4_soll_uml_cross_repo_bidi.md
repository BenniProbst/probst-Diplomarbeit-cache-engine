# Z.4 — Soll-UML Cross-Repo bidirektionale Schnittstellen (M-Modell)

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-18 (Z.4)
**Vorgaenger:** `Y4_cross_repo_beziehungen.md` + `../architektur/10_schichten_modell_M.md`
**Konsequenz:** ABI-Stabilitaet zwischen den 3 Repos

> Soll-UML der API-Grenzen zwischen Subsystemen. Hybrid: Mermaid-Sequence + Klassen-Diagramm.

---

## §1 M-Modell 4-Subsystem-Schichten-Diagramm

```mermaid
flowchart TD
    MD["Subsystem 1:<br/>Diplomarbeit/Code/messung_driver<br/>(Outer-Loop / Auswertung)"]
    CEB["Subsystem 2:<br/>CacheEngineBuilder<br/>(AUTONOMES<br/>Plattform-Ausmess-System)<br/>Eigene Executable"]
    CE["Subsystem 3:<br/>CacheEngine<br/>(WERKZEUG-Bibliothek)<br/>12 Sub-Engines + 29 Strategien"]
    PA["Subsystem 4:<br/>Pruefling (PRT-ART)<br/>IExecutingEngine"]

    MD -->|"konfiguriert + triggert<br/>CacheEngineBuilder.build()"| CEB
    CEB -->|"verwendet als Werkzeug<br/>instantiiert CacheEngine"| CE
    CE -.->|"(a) CE -> PA<br/>register_engine() in Phase 5"| PA
    PA -.->|"(b) PA -> CE<br/>get_telemetry/prefetch/heuristic in Phase 6"| CE

    style MD fill:#FFF3E0
    style CEB fill:#E1F5FE
    style CE fill:#E8F5E9
    style PA fill:#EDE7F6
```

---

## §2 Cross-Repo ABI-Klassen-Diagramm

```mermaid
classDiagram
    namespace Diplomarbeit-Code {
        class MessungDriver {
            +main()
        }
    }

    namespace comdare-cache-engine {
        class CacheEngineBuilder {
            <<App / Executable>>
            +build(config: XmlConfig) : MeasurementBuffer
        }

        class ICacheEngine {
            <<Concept, Library>>
            +register_engine(engine: IExecutingEngine&)
            +execute_permutation(perm)
            +get_telemetry_strategy() : ITelemetryStrategy&
            +get_prefetch_strategy() : IPrefetchStrategy&
            +get_heuristic_for(kind) : IHeuristic&
            +get_scheduler() : IScheduler&
            +get_hardware_strategy() : IHardwareStrategy&
        }

        class IExecutingEngine {
            <<ABI>>
            +execute(workload) : Status
            +configure(baustein_set) : Status
        }

        class ISearchEngine~K, V~ {
            <<ABI V12>>
            +lookup(key) : optional~V~
            +insert(key, value) : Status
            +scan(begin, end) : Iterator
        }
    }

    namespace comdare-prt-art {
        class PrtArtSearchEngineAdapter {
            <<Bridge>>
            +execute(workload) : Status
            +configure(baustein_set) : Status
            -engine_ : PrtArtSearchEngine
            -cache_engine_ : ICacheEngine&
        }

        class PrtArtSearchEngine~K, V, 20+~ {
            <<Template>>
            +lookup(key) : optional~V~
        }
    }

    MessungDriver --> CacheEngineBuilder : Cross-Repo (Diplo -> CE-Repo)
    CacheEngineBuilder --> ICacheEngine : Library-Link
    ICacheEngine ..> IExecutingEngine : registriert (M.3 Richtung a)
    IExecutingEngine <|.. PrtArtSearchEngineAdapter
    ISearchEngine <|.. PrtArtSearchEngineAdapter
    PrtArtSearchEngineAdapter "1" *-- "1" PrtArtSearchEngine : komponiert
    PrtArtSearchEngineAdapter --> ICacheEngine : nutzt CE-Services (M.3 Richtung b)
```

---

## §3 Bidirektionale CE↔PA Sequence-Detail

```mermaid
sequenceDiagram
    autonumber
    participant CEB as CacheEngineBuilder
    participant CE as CacheEngine
    participant Reg as engine_registry_
    participant PA as PrtArtAdapter
    participant PRT as PrtArtSearchEngine

    rect rgba(255, 240, 200, 0.4)
        Note over CEB,PRT: PHASE 5 BIND - M.3 Richtung (a) CE -> PA
        CEB->>CE: register_engine(prt_art_adapter)
        CE->>Reg: registered_engines_.emplace_back(prt_art_adapter)
        CEB->>CE: configure_engine(prt_art_adapter, baustein_set)
        CE->>PA: configure(baustein_set)
        PA->>PRT: configure(template_params)
        PRT-->>PA: Status::OK
        PA-->>CE: Status::OK
    end

    rect rgba(200, 240, 255, 0.4)
        Note over CEB,PRT: PHASE 6 EXECUTE - M.3 Richtung (b) PA -> CE
        CEB->>CE: execute_permutation(desc)
        CE->>PA: execute(workload)
        loop pro Workload-Operation
            PA->>PRT: lookup(key)
            PRT->>CE: get_telemetry_strategy()
            CE-->>PRT: LeafOnlyCounter& [Achse 11.X1]
            PRT->>PRT: telemetry.notify_leaf_access(key)

            PRT->>CE: get_prefetch_strategy()
            CE-->>PRT: HierarchicalBundlePrefetcher& [V31.K6 P27]
            PRT->>PRT: prefetcher.prefetch_l2(predicted_addr)

            PRT->>CE: get_heuristic_for(HotPathRecognition)
            CE-->>PRT: HotPathHeuristic& [C09]
            PRT->>PRT: heuristic.recommend(live_model)

            PRT-->>PA: optional~Value~
        end
        PA-->>CE: PermutationResult
        CE-->>CEB: PermutationResult
    end
```

---

## §4 ABI-Stabilitaets-Garantien (V32 → V33+ Roadmap)

```mermaid
classDiagram
    class ABI_V1 {
        <<V31.F-Stand>>
        +IExecutingEngine
        +ISearchEngine (12-Template-Params)
        +PermutationFlags (9 Banks, ~50 bit)
    }

    class ABI_V2 {
        <<V32.0-staging>>
        +IExecutingEngine (unveraendert)
        +ISearchEngine (Template-Erweiterung, Default-Variants)
        +PermutationFlags (14 Banks, 82 bit)
        +IHardwareStrategy (NEU Achse 12)
        +ISchedulingStrategy (NEU Achse 13)
    }

    class ABI_V3 {
        <<V33+ zukuenftig>>
        +ABI_V2 erweitert um:
        +Multi-Pruefling-Federation
        +Distributed-Cache-Coherence
    }

    ABI_V1 <|-- ABI_V2 : Default-Variants halten Bestand
    ABI_V2 <|-- ABI_V3 : TBD
```

**Migrations-Mapper V31 → V32:**
- Alte 9-Banks-PermutationFlags → V32-Adapter mapped auf 14-Banks mit Defaults
- Alte 12-Template-Param PrtArtSearchEngine → V32-Default-Variants fuer neue Params

---

## §5 Phasen-Owner-Matrix (M-Modell + Pipeline)

```mermaid
flowchart LR
    subgraph CEB["CacheEngineBuilder Phasen (Subsystem 2 Owner)"]
        P1[Phase 1 DISCOVER]
        P2[Phase 2 MEASURE]
        P3[Phase 3 CLASSIFY]
        P4[Phase 4 PUBLISH]
        P5[Phase 5 BIND]
        P7[Phase 7 COMPARE]
    end

    subgraph SHARED["BIDIREKTIONAL CEB + CE + PA"]
        P5_d[Phase 5 BIND<br/>CE.register_engine PA]
        P6[Phase 6 EXECUTE<br/>PA nutzt CE-Services]
    end

    subgraph CE_OWNER["CacheEngine Services (Subsystem 3 ownership)"]
        IPlatformProbe
        IPlatformPropertyClassifier
        ICacheEngineOptionPublisher
        ITelemetryStrategy
        IPrefetchStrategy
        IHeuristic
    end

    P1 --> IPlatformProbe
    P2 --> IPlatformPropertyClassifier
    P3 --> IPlatformPropertyClassifier
    P4 --> ICacheEngineOptionPublisher
    P5 --> P5_d
    P5_d --> P6
    P6 --> ITelemetryStrategy
    P6 --> IPrefetchStrategy
    P6 --> IHeuristic
    P6 --> P7
```

---

## §6 V32-Submodule-Pin-Synchronisation Sequence

```mermaid
sequenceDiagram
    participant CE_Repo as comdare-cache-engine
    participant PA_Repo as comdare-prt-art
    participant DA_Repo as Diplomarbeit-Datenbanken

    Note over CE_Repo: Schritt 1: cache-engine V32-Sprint
    CE_Repo->>CE_Repo: git checkout -b v32-staging
    CE_Repo->>CE_Repo: V32.2+V32.3+V32.4+U.1 Refactor
    CE_Repo->>CE_Repo: git tag v32.0-staging
    CE_Repo->>CE_Repo: git push --tags

    Note over PA_Repo: Schritt 2: prt-art V32-Sprint
    PA_Repo->>CE_Repo: git submodule update --remote
    PA_Repo->>PA_Repo: O.3 + V32.1 + U.2 Refactor
    PA_Repo->>PA_Repo: Pin-Bump cache-engine v32.0-staging
    PA_Repo->>PA_Repo: git tag v32.0-staging
    PA_Repo->>PA_Repo: git push --tags

    Note over DA_Repo: Schritt 3: Diplomarbeit Pin-Bumps
    DA_Repo->>CE_Repo: git submodule update --remote
    DA_Repo->>PA_Repo: git submodule update --remote
    DA_Repo->>DA_Repo: git commit "Submodule-Pin-Bumps fuer V32.0-staging"
    DA_Repo->>DA_Repo: git push

    Note over CE_Repo,DA_Repo: Schritt 4: V32-Final-Tag wenn Verifikation OK
    CE_Repo->>CE_Repo: git tag v32-final && git push --tags
    PA_Repo->>PA_Repo: git tag v32-final && git push --tags
    DA_Repo->>DA_Repo: git tag v32-final && git push --tags
```

---

## §7 drawio-Tab-Vorschlaege fuer Z.4

| drawio-Tab | Inhalt |
|---|---|
| `Z4-M-Modell-Cross-Repo-Master` | 4-Subsystem-Schichten-Schema mit Repo-Grenzen markiert |
| `Z4-ABI-Stabilitaets-Roadmap` | ABI V1 → V2 → V3 Vererbung mit Migrations-Mappers |
| `Z4-Phasen-Owner-Matrix` | Phase 1-7 Owner-Zuordnung CEB vs CE vs PA |

---

## §8 Querverweise

- Y.4 Cross-Repo-Beziehungen: `Y4_cross_repo_beziehungen.md`
- M-Modell: `../architektur/10_schichten_modell_M.md`
- V32 Submodule-Workflow: `../adapters/V32_CODE_REFACTORING_PLAN.md` §7
- Z.1/Z.2/Z.3 Repo-Pendants: `Z1_*.md`, `Z2_*.md`, `Z3_*.md`

---

**Ende docs/uml_planning/Z4_soll_uml_cross_repo_bidi.md (Z.4 DONE).**
