# Y.2 — comdare-prt-art Ist-Kartografie (V31.F Stand)

**Stand:** 2026-05-18 (Y.2)
**Repo-HEAD:** `1a36ab4` (Pin cache-engine V31.F)
**Vorgehen:** Klassen-Inventar pro Verzeichnis, Achsen-Zuordnung, Reuse-vs-Neuartig-Status

> Ist-Bestandsaufnahme PRT-ART als Pruefling. Erweiterung von O.1-Audit aus O_PHASE_PRT_ART_AXES_MIRROR.md mit konkreten Datei-Pfaden.

---

## §1 Top-Level-Struktur

```
comdare-prt-art/
├── prt_art/
│   ├── algorithm_profiles/      (XML-Profile, V8.10)
│   ├── codegen/templates/       (V18.2 prtart_body.hpp.template)
│   ├── include/prt_art/
│   │   ├── allocator/           (3 Header: Pool-Familie, NICHT Allokator-Klasse selbst)
│   │   ├── concurrency/         (1 Header: olc_with_reserved_blocks)
│   │   ├── identity/            (4 Header: SearchEngine + Adapter + Status)
│   │   ├── internal_search/     (4 Header: 4 Suchtypen A/B/C/D)
│   │   ├── measurement/         (2 Header: density + h1/h2/h3)
│   │   ├── memory_layout/       (4 Header: byte_path, cache_line_aligned, multi_level, virtual_offset)
│   │   ├── nodes/               (2 Header: bplus + redirect)
│   │   ├── prefetch/            (3 Header: distance, path_oriented, redirect)
│   │   ├── serialization/       (1 Header: signaling_bits)
│   │   ├── value_buffer/        (1 Header: linear_value_buffer)
│   │   └── value_handle/        (5 Header: chain_ref, cost_model, external, inline, value_handle)
│   ├── legacy_reimpl/           (14 Re-Impl-Verzeichnisse P11-P27)
│   └── tests/                   (Identity-Tests + Fallback-Chain-E2E)
├── tools/
│   └── p27_bundle_finder/       (V31.K5 C++23-Port von hp_soft.py)
├── docs/                        (sessions/, V31-Anker-Doku)
└── external/comdare-cache-engine (Submodule)
```

**Header-Files total:** ~30 in prt_art/include/ + 14 legacy_reimpl/include/
**4+2 Pool-Familie:** in `allocator/` (Pool-Descriptor + Router + Set, NICHT Allokator)
**Tests:** 51 Identity-Tests + 39 Fallback-Chain E2E (V31.F-Stand)

---

## §2 PRT-ART Achsen-Zuordnung (Y.2 Pendant zu O.1)

| Achse | PRT-ART-Subdir | Klassen | Reuse-Status |
|---|---|---|---|
| **1 PAGE-TYPE** | `nodes/` | `RedirectNode`, `BPlusNode` | **(b) Neu-Impl** |
| **2 NODE-TYPE** | `nodes/` + `internal_search/` | obige + 4 Suchtypen (Array256, Array65535, VectorU8, VectorU16) | **(b) Neu-Impl** (5 Klassen) |
| **3.A SearchAlgo-Traversal** | `internal_search/` (4 Suchtypen) | Array-/Vector-Scan-Strategien | **(b) Neu-Impl** |
| 3.B Cache-Memory-Traversal | (fehlt explizit) | (Default Cache-Line-Walk vermutet) | **fehlt - muss NEU (O.3)** |
| **3.M Traversal-Mapping** | `memory_layout/virtual_offset_address.hpp` | `VirtualOffsetCalculator` | **(b) Neu-Impl** |
| **4 VALUEHANDLE** | `value_handle/` (5 Header) | `ValueHandle`, `InlineHandle`, `ExternalHandle`, `ChainRefHandle`, `CostModel` | (a) Reuse K05 Konzept |
| **5 MEMORY-LAYOUT** | `memory_layout/` (4 Header) | `BytePath`, `CacheLineAlignedLayout`, `MultiLevelLayout`, `VirtualOffsetAddress` | **(b) Neu-Impl (TLB-Offset)** |
| **6.1 Allocation-Strategy** | `allocator/` (3 Header) + `value_buffer/linear_value_buffer.hpp` | `PoolDescriptor`, `PoolRouter`, `PoolSet`, `LinearValueBuffer` (4+2 Pool-Familie) | **(b) Neu-Impl Bucket-Strategy** |
| 6.2 Reclamation | (in `concurrency/olc_with_reserved_blocks` impliziert) | implizit | (?) AUDIT-Klarstellung |
| 6.3 NUMA | (fehlt explizit) | — | **fehlt - muss NEU (O.3)** |
| 6.4 HugePage | (fehlt explizit) | — | **fehlt - muss NEU (O.3)** |
| **6.5 Free-List-Strategy** | `allocator/pool_router.hpp` (Bucket-Routing) | implizit Bucket-Strategy | **(b) Neu-Impl** |
| **7 PREFETCH** | `prefetch/` (3 Header) | `DistanceEstimator`, `PathOrientedPrefetch`, `RedirectPrefetch`. **Plus V31.K6 HierarchicalBundlePrefetcher** in `legacy_reimpl/P27/include/hierarchical_bundle_prefetch.hpp` | **(b) Neu-Impl + (a) P27-Reuse** |
| **8.1 Concurrency-Pattern** | `concurrency/olc_with_reserved_blocks.hpp` | `OlcWithReservedBlocks` (Kombi OLC + Reserved-Value-Blocks) | **(b) Neu-Impl Kombination** |
| 8.2 Locking-Mode | (in concurrency impliziert) | implizit mixed (read-only Tree + optimistic Updates + RW Buffer) | (?) AUDIT-Klarstellung |
| 9 ISA | (fehlt explizit) | — | **fehlt - muss NEU (O.3)** |
| **10 MEASUREMENT** | `measurement/` (2 Header) | `DensityTracker`, `HypothesisMetrics` (H1/H2/H3) | **(b) Neu-Impl** |
| 11 TELEMETRY-COLLECTION | (fehlt explizit, CE-Reuse via concepts/telemetry/) | — | (a) Reuse aus CE oder muss NEU |
| 12 HARDWARE-STRATEGY | (fehlt explizit) | — | **fehlt - muss NEU (O.3)** |
| 13 SCHEDULING-STRATEGY | (fehlt explizit) | — | **fehlt - muss NEU (O.3)** |

**Bilanz:** PRT-ART hat **konkret implementiert** 11 Achsen mit Header-Files. **8 Sub-Achsen fehlen** (3.B, 6.2 explizit, 6.3, 6.4, 8.2 explizit, 9, 11, 12, 13).

**Neuartigkeits-Qualifikation:** 11 Neu-Implementationen (Reuse-Status (b)) — PRT-ART qualifiziert MEHRFACH als neuartiger Algorithmus.

---

## §3 Identity-Schicht (prt_art/include/prt_art/identity/)

| Header | Klasse | Rolle |
|---|---|---|
| `prt_art_identity.hpp` | `PrtArtIdentity` | Identitaets-Helfer |
| `prt_art_search_engine.hpp` | `PrtArtSearchEngine<Key, Value, 12 Template-Params>` | **Hauptklasse, V31.F-Stand 12 Params, muss V32.1 -> 20+ erweitert werden** |
| `prt_art_search_engine_adapter.hpp` | `PrtArtSearchEngineAdapter` | Bridge zwischen ISearchEngine-ABI und PrtArtSearchEngine-Template |
| `status.hpp` | `Status` (errno-style) | V12.B Returntype fuer Schreib-/IO-Ops |

---

## §4 Internal-Search (prt_art/include/prt_art/internal_search/) — 4 Suchtypen K05b

| Header | Klasse | Typ |
|---|---|---|
| `array_256.hpp` | `Array256` | Suchtyp A: 1-Byte-Slot, 256 Felder, Initial bei < 25% Dichte (Merge 2 Ebenen) |
| `array_65535.hpp` | `Array65535` | Suchtyp B: 2-Byte-Slot, 65535 Felder, bei > 50% Dichte (Split 2 Ebenen, Auftrittswahrscheinlichkeit-Sortierung) |
| `vector_u8_u8.hpp` | `VectorU8U8` | Suchtyp C: Range-Scan tuple<u8, u8>, sortiert nach Auftrittswahrscheinlichkeit (2 Byte Pair) |
| `vector_u16_u16.hpp` | `VectorU16U16` | Suchtyp D: Range-Scan tuple<u16, u16>, > 75% Dichte (Merge 2 Ebenen, terminale Form) |

**Dichte-Schwellen-Transition (K05b):**
- 25%: Typ A → Typ B (Punkt-Suche mit 2 Bytes)
- 50%: Typ B → Typ C (Range-Scan, Sortierung Auftrittswahrscheinlichkeit)
- 75%: Typ C → Typ D (Range-Scan unsigned short Merge 2 Ebenen)

---

## §5 Allocator-Schicht (prt_art/include/prt_art/allocator/) — 4+2 Pool-Familie

| Header | Klasse | Pool |
|---|---|---|
| `pool_descriptor.hpp` | `PoolDescriptor` | Beschreibung pro Pool (A/B/C/D + R + V-static + V-dynamic) |
| `pool_router.hpp` | `PoolRouter` | Routing: pro Suchtyp + Value-Typ → richtiger Pool |
| `pool_set.hpp` | `PoolSet` | Container aller 7 Pools |
| `../value_buffer/linear_value_buffer.hpp` | `LinearValueBuffer` | Pool V (Value-Pool, statisch + dynamisch) |

**4+2 Pool-Familie (K05e):**
- Pool A: 256 B Cache-Line / Page-Multiple, Fixed-Size-Slab
- Pool B: 64 KB Pages, Fixed-Size-Slab
- Pool C: 4 KB Variable-Vector-Groesse, Pool mit variabler Fuellung
- Pool D: 64 B Cache-Line, Variable-Size-Slab
- Pool R: Redirect-Knoten (Byte-String + optional Value-Pointer), Variable-Size-Slab
- Pool V-static: Values mit statischer Groesse (kein Serializer noetig), bucket-basiert, fixer Slot, Append-only
- Pool V-dynamic: Values mit dynamischer Groesse + Signaling-Bits-Header, bucket-basiert, Append-only

---

## §6 Memory-Layout (prt_art/include/prt_art/memory_layout/)

| Header | Klasse | Rolle |
|---|---|---|
| `byte_path.hpp` | `BytePath` | Byte-Pfad-Repraesentation (fuer Lookup-Traversierung) |
| `cache_line_aligned_layout.hpp` | `CacheLineAlignedLayout` | F1-K Cache-Line-Aware (Achse 5) |
| `multi_level_layout.hpp` | `MultiLevelLayout` | Page-Multilevel-Layout |
| `virtual_offset_address.hpp` | `VirtualOffsetAddress` | **VirtualOffsetCalculator (3.M Mapping-Strategy)** |

---

## §7 Concurrency-Schicht (prt_art/include/prt_art/concurrency/)

| Header | Klasse | Achse 8 |
|---|---|---|
| `olc_with_reserved_blocks.hpp` | `OlcWithReservedBlocks` | 8.1 Pattern (OLC + Reserved-Value-Blocks) + 8.2 Locking-Mode (mixed) |

**K05g Multi-Reader-Writer-Concurrency:**
1. Lock-free Reader (Standard)
2. Reservierte Value-Speicher-Bloecke pro Writer (sequentielle Allokation)
3. Parallele Index-Updates auf disjunkten Node-Bereichen (Konflikt-Detection notwendig)
4. Konflikt-Resolution via OLC (siehe S30 in K06)

---

## §8 Prefetch-Schicht (prt_art/include/prt_art/prefetch/)

| Header | Klasse | Strategie |
|---|---|---|
| `distance_estimator.hpp` | `DistanceEstimator` | Distance-Schaetzung fuer Prefetch-Level (L1/L2/L3) |
| `path_oriented_prefetch.hpp` | `PathOrientedPrefetch` | Pfad-orientiertes Prefetch |
| `redirect_prefetch.hpp` | `RedirectPrefetch` | Redirect-Knoten-spezifisches Prefetch |
| `../legacy_reimpl/P27-Zhang-ASPLOS-Hierarchical/include/hierarchical_bundle_prefetch.hpp` | `HierarchicalBundlePrefetcher` | **V31.K6 P27 Reuse** (L1/L2/L3 Bundle) |

---

## §9 Value-Handle-Schicht (prt_art/include/prt_art/value_handle/)

| Header | Klasse | Auspraegung |
|---|---|---|
| `value_handle.hpp` | `ValueHandle` Concept | Achse 4 Master |
| `inline_handle.hpp` | `InlineHandle` | Value direkt im Knoten (kleine Werte) |
| `external_handle.hpp` | `ExternalHandle` | Pointer auf externen Payload-Speicher |
| `chain_ref_handle.hpp` | `ChainRefHandle` | Verkettete Referenz fuer Multi-Value (vertagt P3) |
| `cost_model.hpp` | `CostModel` | Inline-vs-External-Grenze ist H3-Hypothese |

---

## §10 Measurement-Schicht (prt_art/include/prt_art/measurement/)

| Header | Klasse | Metrik |
|---|---|---|
| `density_tracker.hpp` | `DensityTracker` | Dichte-Tracking pro Suchtyp |
| `hypothesis_metrics.hpp` | `HypothesisMetrics` | H1 (CLU/Footprint) + H2 (Layoutwahl) + H3 (Inline-vs-External) |

---

## §11 Legacy-Reimpl (prt_art/legacy_reimpl/) — 14 Re-Implementations

| Sub-Verzeichnis | Paper | Hauptklasse |
|---|---|---|
| `P11-CSS-tree/` | Rao 1999 | `CssNodePage` |
| `P12-CSB-tree/` | Rao 2000 | `CsbNodeGroupPage` |
| `P13-Hankins/` | Hankins 2003 | `WiderBplusPage` |
| `P14-Samuel/` | Samuel 2005 | `ConfigTableBplusPage` |
| `P16-Bender-TreeLayout/` | Bender 2002 | `ProbabilityLayout` |
| `P17-Bender-CacheOblivious/` | Bender 2005 | `CacheObliviousLayout` |
| `P18-Saikkonen-MultiLevel/` | Saikkonen 2008 | `MultiLevelReloc` |
| `P19-Saikkonen-LayoutInvariant/` | Saikkonen 2016 | `LayoutInvariant` |
| `P21-Chen-PrefetchBPlus/` | Chen 2001 | `PrefetchBplus` |
| `P22-Chen-Fractal/` | Chen 2002 | `FractalPrefetchBplus` |
| `P23-Khan-AdaptivePrefetch/` | Khan 2010 | `AdaptivePrefetchDistance` |
| `P24-NaderanTahan/` | Naderan 2016 | `UselessPrefetchStudy` |
| `P26-Zhang-FGCS/` | Q. Zhang 2024 | `PathJumppointerPrefetch` |
| `P27-Zhang-ASPLOS-Hierarchical/` | T. Zhang 2025 | `HierarchicalBundlePrefetcher` (V31.K6) |

**Total:** 14 Re-Implementations + 28 zusaetzliche Header (include + src + tests pro Re-Impl).

---

## §12 Tools (tools/)

| Sub-Verzeichnis | Inhalt | Quelle |
|---|---|---|
| `p27_bundle_finder/` | V31.K5 C++23-Port von hp_soft.py (Build-Time Call-Graph-Analyse) | Zhang 2026-05-11 hp-soft.zip |

---

## §13 V32+ Refactoring-Bedarf

### §13.1 Spiegel-Module fuer fehlende Achsen anlegen (O.3)

1. `prt_art/include/prt_art/hardware/` (Achse 12)
   - `prt_art_hardware_strategy.hpp` + 5 Sub-Achsen-Header (siehe O_PHASE §3.1)
2. `prt_art/include/prt_art/scheduling/` (Achse 13)
   - `prt_art_scheduling_strategy.hpp` + 5 Sub-Achsen-Header
3. `prt_art/include/prt_art/traversal/` (Achse 3.B + 3.M aus memory_layout/ extrahieren)
   - `search_algo_traversal.hpp`, `cache_memory_traversal.hpp`, `traversal_mapping.hpp`
4. `prt_art/include/prt_art/telemetry/` (Achse 11.X1-X4, Reuse aus cache-engine/concepts/telemetry/)
5. `prt_art/include/prt_art/isa/` (Achse 9)
6. `prt_art/include/prt_art/allocator/` Erweiterung (6.2 Reclamation, 6.3 NUMA, 6.4 HugePage)

### §13.2 PrtArtSearchEngine Template-Params 12 → 20+ (V32.1)

Komplett-Spec siehe `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md` §6.

### §13.3 PRT_ART_AXES_REUSE_MATRIX.md NEU (O.4)

In `docs/` des prt-art Repos. Vorlage in O_PHASE §4.

---

## §14 Querverweise

- O-Phase PRT-ART Spiegel: `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md`
- V32 Code-Refactoring-Plan: `../adapters/V32_CODE_REFACTORING_PLAN.md`
- Bausteine N-Phase: `../bausteine/07_bausteine_matrix_N_erweitert.md`
- M-Modell Schichten: `../architektur/10_schichten_modell_M.md`
- Y.1 Cache-Engine Pendant: `Y1_cache_engine_ist_kartografie.md`

---

**Ende docs/uml_planning/Y2_prt_art_ist_kartografie.md (Y.2 DONE).**
