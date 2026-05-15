# Phase 5 REV 2 — Voll-detaillierte UML + ER-Modell

**Habich-Anforderung H1** (2026-05-08): "maximal-detaillierte Software-Architektur-UML mit allen Klassen + ER-Modell + Verbindungen + Relationen + Assoziationen — das volle Programm".

**Stand:** 2026-05-09 (textuelle Vorarbeit; drawio-Diagramme folgen)
**Verzeichnis:** `Phase5_UML_Detail/`
**Vorgaenger:** `../Phase5_UML_Entwurf/` (Erstentwurf vom 2026-05-08, weniger detailliert)

---

## Inhalt

| Datei | Inhalt |
|-------|--------|
| `00_README.md` | dieses Dokument — Index, Lese-Reihenfolge, Notations-Konvention |
| `01_uml_search_engine.md` | UML-Klassen Search Engine: Page, Node, Traversal, ValueHandle, MemoryLayout, Allocator, Prefetch |
| `02_uml_cache_engine.md` | UML-Klassen Cache Engine: CacheEngine-Singleton, DecisionLambdaTree, ConcurrencyManager (8 Disziplinen + 3 Mechaniken), TelemetryStrategy (Achse 11 — Kuehn-Erkenntnisse) |
| `03_uml_measurement.md` | UML-Klassen Measurement: Mess-Kategorie x Algo-Detail Matrix (F1), constexpr-Spezialisierung, Measurement-Hooks |
| `04_uml_hardware_isa.md` | UML-Klassen Hardware/ISA: Flag_System.txt-Bezug, PlatformProbe, X3D-V-Cache-Awareness, Hybrid-CPU-Trennung |
| `05_uml_engine_choice_builder.md` | UML-Klassen Engine-Choice + CacheEngineBuilder (F12-K Heap-Singleton im Builder-Prozess) |
| `06_uml_persistence.md` | UML-Klassen Persistence: InMemoryMeasurementBuffer Disk-Dump-Format, Binary/CSV-Schema |
| `07_er_model.md` | ER-Modell fuer persistente + In-Memory Datenstrukturen: MeasurementRecord, PermutationFlags, BuildArtefakt, ExperimentRun, DatasetMetadata |
| `08_cross_reference.md` | Cross-Reference: Concept (Bausteine_Matrix.txt) ↔ Implementation (UML-Klasse) ↔ ER-Entitaet |
| `09_drawio_export.md` | Anleitung zur Uebertragung in drawio (Tabs-Struktur, Farb-Konvention, Kanten-Style) |

---

## Notations-Konvention

Wir verwenden eine PlantUML-aehnliche Pseudo-Syntax fuer textuelle UML-Klassen:

```
class CacheEngine <<singleton>> {
    -- Attribute --
    + concurrency_manager : ConcurrencyManager& [0..1]
    + decision_trees : map<BausteinId, IDecisionLambdaTree*>
    - measurement_buffer : InMemoryMeasurementBuffer
    -- Methoden --
    + static instance() : CacheEngine&  <<thread-safe call_once>>
    + notify(event : Event&&) : void  <<noexcept>>
    + reset_state() : void
    -- Constraints --
    inv: instance() liefert immer dieselbe Adresse [F12-K]
    inv: lebt im Builder-Prozess, NICHT als separater Service [F12-K]
}
```

**Sichtbarkeits-Praefixe:**
- `+` public
- `-` private
- `#` protected
- `~` package/internal

**Stereotyp-Tags `<<...>>`:**
- `<<singleton>>` Heap-Singleton mit `unique_ptr` + `call_once` (F1, F12-K)
- `<<concept>>` C++23-Concept (F1, F-EXTRA-7)
- `<<requires>>` C++23-`requires`-Constraint
- `<<constexpr>>` Compile-Time-Konstante
- `<<noexcept>>` Methode garantiert keine Exception
- `<<inline>>` markiert Hot-Path-Inlining (F1)
- `<<configurable>>` Konfigurierbar via Build-Flag
- `<<adaptive>>` Anpassbar zur Laufzeit (Cache-Engine-Modus 3)
- `<<barrier>>` Single-Threaded BARRIERE-Phase (siehe Kuehn-Erkenntnisse Block AK)

**Beziehungen (UML 2.x Standard):**

| Beziehung | Notation | Bedeutung |
|-----------|----------|-----------|
| Vererbung | `Parent <|-- Child` | Class inheritance |
| Implementierung | `Interface <|.. Class` | Interface impl |
| Komposition | `Whole *-- Part` | strong ownership (Lifetime) |
| Aggregation | `Whole o-- Part` | weak ownership (Reference) |
| Assoziation | `A --> B` | gerichtete Beziehung |
| Abhaengigkeit | `A ..> B` | use, no ownership |
| Multiplizitaet | `Class "0..1" --> "*" Other` | Cardinality |

---

## Lese-Reihenfolge fuer den Pruefungsausschuss

1. **Diese README** (00_README.md) — Konvention + Lese-Pfad
2. **08_cross_reference.md** — Highlights: Wie korrespondieren die 11 Bausteine_Matrix-Achsen mit den UML-Klassen?
3. **02_uml_cache_engine.md** — die zentrale Forschungs-Komponente
4. **01_uml_search_engine.md** — die zerlegten Algorithmus-Bausteine
5. **05_uml_engine_choice_builder.md** — der Orchestrator (F12-K)
6. **03_uml_measurement.md** + **06_uml_persistence.md** — Mess-Pipeline (F1, F5)
7. **04_uml_hardware_isa.md** — Plattform-Anpassung (Flag_System, X3D-V-Cache, Hybrid-CPU)
8. **07_er_model.md** — Datenpersistenz (Block AO Plattform-spezifisch)

---

## Bezug zu Architektur-Dokumenten

| UML-Datei | Quelle |
|-----------|--------|
| 01_search_engine | `Bausteine_Matrix.txt` Achse 1-7, `Glossar_v7` BLOCK A-G, `ADR F1, F3, F8, F10-K, F-EXTRA-1` |
| 02_cache_engine | `ADR F1, F2, F6, F12-K`, `Glossar_v7` BLOCK AC-AM (DecisionLambdaTrees + Kuehn-Erkenntnisse) |
| 03_measurement | `ADR F1, F11, F-EXTRA-7`, `Bausteine_Matrix` Achse 10 |
| 04_hardware_isa | `Flag_System.txt`, `Glossar_v7` BLOCK AO (Production-Plattform), `ADR F4, F9, F13` |
| 05_engine_choice_builder | `ADR F12, F12-K, F4, F10-K`, `Glossar_v7` BLOCK Z, AC, AM |
| 06_persistence | `ADR F5`, `Glossar_v7` BLOCK U, AC |
| 07_er_model | abgeleitet aus Bausteine_Matrix Implementierungs-Pfade + InMemoryMeasurementBuffer-Schema |
| 08_cross_reference | Tabelle quer durch alle Bausteine_Matrix-Eintraege |

---

## Aktualitaet REV 2 (2026-05-09)

Diese REV 2 beruecksichtigt die Korrekturen aus der Re-Verifikation 2026-05-09:
- **F-EXTRA-1 Compiler-Layering** (Hauptcompiler IMMER C++23, Bausteine-Internals mit Original-Compiler) — beruehrt 01_search_engine + 05_engine_choice_builder
- **F12-K Korrektur** (CacheEngine ist Heap-Singleton im Builder-Prozess, NICHT separater Service) — beruehrt 02_cache_engine + 05_engine_choice_builder
- **F-EXTRA-5 NO-PYTHON-DIREKTIVE** (CMake + sh/bat statt Python) — beruehrt 05_engine_choice_builder Codegen-Pipeline
- **Achse 11 Telemetry-Collection-Strategy** (Kuehn-Erkenntnisse 2026-05-09) — neuer Abschnitt in 02_cache_engine
- **Production-Plattform Block AO** (Ryzen 9 9950X3D + i9-14900KS) — beruehrt 04_hardware_isa
- **Forschungs-Mission-Statement Block AP** (heuristisch ↔ informiert ↔ adaptiv) — beruehrt 05_engine_choice_builder
