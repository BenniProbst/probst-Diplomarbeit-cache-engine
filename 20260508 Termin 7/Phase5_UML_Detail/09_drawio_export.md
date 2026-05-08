# Anleitung — Uebertragung der UML-Spezifikation in drawio

**Ziel:** `Phase5_UML_Detail/phase5_uml_detail.drawio` als Master-Diagramm-Datei mit allen Tabs, Tabellen und Cross-References.

**Stand:** 2026-05-09 — textuelle Vorarbeit ist in `01_uml_search_engine.md` bis `08_cross_reference.md` abgeschlossen.

---

## 1. Tab-Struktur (REV 2)

| # | Tab-Name | Quelle | Hauptklassen |
|---|----------|--------|--------------|
| 1 | 01-A Page-Bausteine | 01_uml_search_engine §2 | IPage + alle PAGE_*-Klassen |
| 2 | 01-B Node-Bausteine | 01_uml_search_engine §3 | INode + alle NODE_*-Klassen |
| 3 | 01-C Traversal-Bausteine | 01_uml_search_engine §4 | ITraversalAlgorithm + Traversal-Klassen |
| 4 | 01-D ValueHandle | 01_uml_search_engine §5 | ValueHandle (variant) + DynamicValueHandle |
| 5 | 01-E MemoryLayout | 01_uml_search_engine §6 | IMemoryLayout + Layout-Klassen |
| 6 | 01-F Allocator | 01_uml_search_engine §7 | IAllocator + IPlatformAllocatorFactory |
| 7 | 01-G Prefetch | 01_uml_search_engine §8 | IPrefetchStrategy + Prefetch-Klassen |
| 8 | 02-A CacheEngine Singleton | 02_uml_cache_engine §1 | CacheEngine, ObserverRegistry, etc. |
| 9 | 02-B DecisionLambdaTrees | 02_uml_cache_engine §2 | IDecisionLambdaTree + 10+ Tree-Familien |
| 10 | 02-C ConcurrencyManager | 02_uml_cache_engine §3 | IConcurrencyDiscipline + IConcurrencyMechanic + Composition |
| 11 | 02-D TelemetryStrategy NEU 2026-05-09 | 02_uml_cache_engine §4 | ITelemetryStrategy + Kuehn-Klassen |
| 12 | 02-E Event-Hierarchie | 02_uml_cache_engine §5 | Event-Subklassen + ObserverRegistry |
| 13 | 02-F CacheHierarchyManager | 02_uml_cache_engine §6 | F4 Plattform-Adapter |
| 14 | 02-G Lambda-Tree Sequence | 02_uml_cache_engine §7 | evaluate-Aufruf-Pfad |
| 15 | 03-A Mess-Matrix | 03_uml_measurement §1 | Measure<Cat, Detail> Spezialisierung |
| 16 | 03-B HasMeasurement-Concept | 03_uml_measurement §3 | F-EXTRA-7 Default+Override |
| 17 | 03-C Trigger-Modus | 03_uml_measurement §4 | F11 Continuous/Sampled |
| 18 | 04-A PlatformProbe | 04_uml_hardware_isa §1 | PlatformProbe + Profile + Topology |
| 19 | 04-B PermutationFlags Bank-Layout | 04_uml_hardware_isa §2 | F10-K CPUID-Vorbild |
| 20 | 04-C ConstraintFilter | 04_uml_hardware_isa §3 | F4 ISA-Filter |
| 21 | 04-D Block AO | 04_uml_hardware_isa §4 | RyzenX3DProbe + IntelHybridProbe |
| 22 | 04-E Cross-Compile | 04_uml_hardware_isa §5 | F13 Toolchain + DeliveryDriver |
| 23 | 05-A Builder Lebenszyklus | 05_uml_engine_choice_builder §1+§2 | CacheEngineBuilder Sequence |
| 24 | 05-B Permutation-Flags | 05_uml_engine_choice_builder §3 | (Cross-Bezug zu 04-B) |
| 25 | 05-C Compiler-Layering | 05_uml_engine_choice_builder §7 | F-EXTRA-1 Schale + Internals + Linker |
| 26 | 05-D EngineChoice | 05_uml_engine_choice_builder §6 | StaticEngineChoice + CacheEngineChoice |
| 27 | 05-E NO-PYTHON Codegen | 05_uml_engine_choice_builder §5 | CMakeShBatCodegenDriver (H6/F-EXTRA-5) |
| 28 | 06-A InMemoryBuffer | 06_uml_persistence §1+§2 | per-thread arenas |
| 29 | 06-B Disk-Dump-Format | 06_uml_persistence §3+§4 | Binary + CSV |
| 30 | 06-C LatexRenderer | 06_uml_persistence §5 | H3 Pipeline |
| 31 | 07-A ER-Modell | 07_er_model | alle 6 Tabellen + Beziehungen |
| 32 | 08-A Cross-Reference Map | 08_cross_reference | visualisierte Cross-Referenz |

---

## 2. Farb-Konvention

| Stereotyp | Farbe (Material Design) |
|-----------|--------------------------|
| `<<singleton>>` | Indigo 700 (#303F9F) |
| `<<concept>>` | Cyan 700 (#0097A7) |
| `<<adapter>>` (Originalcode-Wrapper) | Blau 700 (#1976D2) |
| `<<comdare eigen>>` (PRT-ART eigen) | Gruen 700 (#388E3C) |
| `<<adaptive>>` | Orange 700 (#F57C00) |
| `<<barrier>>` | Rot 700 (#D32F2F) |
| `<<NEU 2026-05-09>>` (Kuehn) | Pink 600 (#D81B60) |
| ER-Entitaet | Braun 600 (#6D4C41) |
| Klasse-A-Originalcode | Blau 500 (#2196F3) |
| Klasse-B-LEGACY_REIMPL | Orange 500 (#FF9800) |
| Klasse-C-Konzept-Quelle | Grau 500 (#9E9E9E) |

---

## 3. Kanten-Stil-Konvention

| Beziehung | Stil | Farbe |
|-----------|------|-------|
| Vererbung | solid line, unfilled triangle | schwarz |
| Implementierung | dashed line, unfilled triangle | schwarz |
| Komposition | solid line, filled diamond | schwarz |
| Aggregation | solid line, unfilled diamond | schwarz |
| Assoziation | solid line, arrow | grau 700 |
| Abhaengigkeit | dashed line, arrow | grau 500 |
| Multiplizitaet-Label | "0..1", "1..*", "n" | klein 9pt |

---

## 4. Tab-spezifische Hinweise

### Tab 02-G (Lambda-Tree Sequence)

Verwende **Sequence-Diagramm-Stil** (nicht Klassendiagramm). Akteure:
- `Algorithmus` (im Hot-Path)
- `CacheEngine` (Singleton)
- `DecisionLambdaTreeBundle`
- `IDecisionLambdaTree<...>`
- `Decision-Enum`

Sequenz: `Algo` ruft `notify(event)` → `CacheEngine` filtert via Bundle → einzelner Tree evaluiert → liefert `EXECUTE/DELAY/SKIP`.

### Tab 04-D (Block AO)

Hier Plattform-Spezifika visualisieren:
- Ryzen 9 9950X3D: 2 CCDs (96+32 MiB L3) — asymmetrisch
- i9-14900KS: 8 P-Cores + 16 E-Cores (cpu_core/cpu_atom-Trennung)
- DDR5-5600 CL36 als Speicher-Kontext

### Tab 05-C (Compiler-Layering, F-EXTRA-1)

Drei Schichten klar visualisieren:
- **Schale (C++23)** in Indigo: Adapter, Concept-Bindungen, ABI-Interface
- **Bausteine-Internals (Original-Compiler je Algo)** in Blau:
  - P01 GCC 4.7+/10+ (unodb)
  - P02 GCC 5+ (HOT, BMI2/AVX2)
  - P03 GCC 4.6+ (Masstree)
  - P04 GCC 11+ (CoCo-trie)
  - P05 GCC 7+ (START)
  - P06a/b GCC 9+ (B²Tree)
  - P07 GCC 7+ (Wormhole, SSE4.2/CRC)
  - P10 g++ -mpopcnt (SuRF)
  - P25 GCC 11+ (Mahling)
  - P29 GCC 4+ (userspace-rcu, falls genutzt)
- **Static Linking → ABI-stabiles Modul** in Orange: .so / .dll / .dylib

### Tab 07-A (ER-Modell)

Standard-Crow's-Foot-Notation. Tabellen:
- ExperimentRun (zentral)
- MeasurementRecord (1:N zu ExperimentRun)
- DatasetMetadata (1:N zu ExperimentRun)
- ModuleSpec (1:N zu ExperimentRun)
- PermutationFlags (Lookup, N:1 zu ModuleSpec)
- BuildArtefact (1:N zu ModuleSpec)

---

## 5. drawio-Datei-Struktur

```xml
<mxfile>
  <diagram name="01-A Page-Bausteine" id="...">...</diagram>
  <diagram name="01-B Node-Bausteine" id="...">...</diagram>
  ...
  <diagram name="07-A ER-Modell" id="...">...</diagram>
  <diagram name="08-A Cross-Reference Map" id="...">...</diagram>
</mxfile>
```

---

## 6. Workflow zur Diagramm-Erstellung

1. drawio-Desktop oder app.diagrams.net oeffnen
2. Pro Tab: textuelle Spezifikation aus `01_*.md` bis `08_*.md` als Vorlage nehmen
3. Klassen-Boxen nach UML-Konvention zeichnen (mit Stereotyp-Tags + Farb-Konvention)
4. Beziehungen mit Multiplizitaet-Labels einfuegen
5. Alle Tabs in einer .drawio-Datei zusammenfassen
6. Export als PNG/SVG/PDF fuer Diplomarbeit-Anhang

---

## 7. Aktualisierungs-Pflicht

Wenn die textuellen Spezifikationen geaendert werden, muss die drawio-Datei nachgezogen werden. Die textuellen Dateien sind die **Single Source of Truth**; drawio dient der Visualisierung.

Bei groesseren Aenderungen (z.B. neue Bausteine_Matrix-Achse) bitte:
1. Textuelle Spezifikation in betroffenen `01_*.md`–`08_*.md` aktualisieren
2. Cross-Reference in `08_cross_reference.md` synchronisieren
3. drawio-Datei nachziehen
4. Diplomarbeit-PDF neu kompilieren
