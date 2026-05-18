# O-Phase PRT-ART als Bausteine-Spiegel — V32+ Vorbereitung (O.1-O.6)

## §0 KRITISCHE KORREKTUR AA.4 (2026-05-18 spaet)

**User-Direktive 2026-05-18 spaet:** Im §1.2 dieser Doku stehen 10 Sub-Achsen als "FEHLT - muss angelegt werden". **Diese Markierung ist FALSCH.**

### §0.1 Korrekte Default-Aktion bei fehlender Achsen-Spec

> "Wenn eine Axe nicht explizit definiert wird, ist die Default-Aktion: Nachschlagen in der Bibliothek (CE-Sub-Engine Permutation aller SOTA-Bausteine der Achse). Pruefung ALLER verfuegbaren Algorithmen der Axe, sofern in Pruef-Config nicht limitiert."

### §0.2 Wann braucht PRT-ART trotzdem ein eigenes Modul?

Nur wenn:
- PRT-ART eine ECHTE Neu-Implementation auf der Achse bietet (Status (b))
- PRT-ART einen SOTA-Baustein der CE-Bibliothek explizit PINNT (Status (a))
- PRT-ART eine spezifische Permutations-Configuration setzt (Status (c))

Wenn nichts davon: KEIN PrtArt-Modul noetig, CEB nutzt Default-Lookup.

### §0.3 Korrigiertes §1.2 Achsen-Abdeckung Audit

| Achse | Aktueller Status | Korrigierter Status |
|---|---|---|
| 1 PAGE-TYPE | DONE | DONE (b) Neu-Impl |
| 2 NODE-TYPE | DONE | DONE (b) Neu-Impl |
| 3.A SearchAlgo-Traversal | DONE | DONE (b) Neu-Impl |
| 3.B Cache-Memory-Traversal | FEHLT - muss NEU | **DEFAULT-LOOKUP** (CE-Bibliothek hat Default-Cache-Line-Walk) |
| 3.M Traversal-Mapping | FEHLT - muss NEU | DONE (b) VirtualOffsetCalculator (existiert in memory_layout/, muss nur verschoben werden) |
| 4 VALUEHANDLE | DONE | DONE (a) Reuse K05 |
| 5 MEMORY-LAYOUT | DONE | DONE (b) Neu-Impl |
| 6.1 Allocation-Strategy | DONE | DONE (b) Neu-Impl Bucket |
| 6.2 Reclamation-Policy | FEHLT | **DEFAULT-LOOKUP** (CE liefert epoch/RCU/HP/QSBR-Permutation) |
| 6.3 NUMA-Affinity | FEHLT | **DEFAULT-LOOKUP** (CE liefert local/interleave/preferred-Permutation) |
| 6.4 Huge-Page-Policy | FEHLT | **DEFAULT-LOOKUP** (CE liefert transparent/explicit/none-Permutation) |
| 6.5 Free-List-Strategy | DONE | DONE (b) Bucket-Strategy |
| 7 PREFETCH | DONE | DONE (b) Neu-Impl + (a) P27-Reuse |
| 8.1 Concurrency-Pattern | DONE | DONE (b) Neu-Impl Kombination |
| 8.2 Locking-Mode | FEHLT | **DEFAULT-LOOKUP** (CE liefert read-only/RW/optimistic/upgradeable-Permutation) |
| 9 ISA | FEHLT | **DEFAULT-LOOKUP** (CE-IPlatformProbe liefert Host-ISA, kein PrtArt-Override) |
| 10 MEASUREMENT | DONE | DONE (b) Neu-Impl |
| 11 TELEMETRY-COLLECTION | FEHLT (Kuehn-Strategien) | **DEFAULT-LOOKUP** (CE-concepts/telemetry/* hat Kuehn 11.X1-X4) |
| 12 HARDWARE-STRATEGY | FEHLT | **DEFAULT-LOOKUP** (CE-IHardwareStrategy Auto-Permutation, V32 NEU im CE) |
| 13 SCHEDULING-STRATEGY | FEHLT | **DEFAULT-LOOKUP** (CE-ISchedulingStrategy Auto-Permutation, V32 NEU im CE) |

### §0.4 Korrigierte O.3 Spiegel-Module Pflichtliste

Statt 6 NEUE Subdirectories sind nur 2 wirklich noetig:

- `prt_art/traversal/traversal_mapping.hpp` — VirtualOffsetCalculator verschieben (b Neu-Impl)
- `prt_art/traversal/search_algo_traversal.hpp` — bestehende internal_search/-Klassen reorganisieren (b Neu-Impl)

**Optional (NICHT pflicht)** falls PRT-ART eigene Erweiterung auf der Achse haben sollte:
- `prt_art/telemetry/`, `prt_art/hardware/`, `prt_art/scheduling/`, etc. — aktuell NICHT noetig, CEB-Auto-Permutation deckt es ab

### §0.5 Korrigierte O.6 Template-Parameter

PrtArtSearchEngine bekommt KEINE 20+ Template-Params (das war Z.2 §1 Soll). **Korrigiertes Soll:**

- 12 V31.F Template-Params **bleiben** (Backward-Compat)
- + 2 NEUE Template-Params: `TraversalMapping` + `SearchAlgoTraversal` (= O.3 Pflicht-Neue)
- + Optionale Template-Params fuer Default-Lookup-Overrides (Hardware/Scheduling/Telemetry/etc.) wenn User explizit konfigurieren will

Damit: **PrtArtSearchEngine mit 14-16 Template-Params** (Pflicht), Rest via Default-Lookup vom CEB.

### §0.6 V32-Implementations-Konsequenzen

- DD.1 CEB AutoPermutator-Klasse: lookup in CE-Bibliothek aller Bausteine pro Achse + Permutations-Generierung
- DD.2 PrtArt-Template-Erweiterung auf 14-16 Params (statt 20+)
- DD.3 messung_driver XML-Schema: `<axes_default_lookup>true</axes_default_lookup>` Flag erlaubt das

---



**Stand:** 2026-05-18 (O-Phase 6/6 DONE als Konsolidierungs-Doku)
**Trigger:** User-Direktive 2026-05-18 + N-Phase 14 Achsen
**Konsequenz fuer V32+:** comdare-prt-art/prt_art/include/prt_art/ Sub-Verzeichnisse aufruesten

> **Hinweis:** Dieses Dokument konsolidiert den PRT-ART-Achsen-Audit, das Neuartigkeits-Audit, die Spiegel-Module-Spezifikation, die Reuse-Matrix und die Template-Parameter-Erweiterung. Die eigentlichen Code-Aenderungen folgen in V32.1+ Sprints im comdare-prt-art Repo.

---

## §1 O.1 — PRT-ART Bausteine-Achsen-Audit (Achse 1-13)

### §1.1 Aktueller `prt_art/include/prt_art/` Verzeichnis-Stand

```
prt_art/include/prt_art/
├── allocator/        — Achse 6 ALLOCATOR (4+2 Pool-Familie)
├── concurrency/      — Achse 8 CONCURRENCY (OLC + Reserved-Blocks)
├── identity/         — PrtArtSearchEngine (Top-Level + Adapter)
├── internal_search/  — Achse 3 TRAVERSAL (4 Suchtypen A/B/C/D)
├── measurement/      — Achse 10 MEASUREMENT (Density-Tracker, H1/H2/H3)
├── memory_layout/    — Achse 5 MEMORY-LAYOUT (TLB-Offset + cache-line-aligned)
├── nodes/            — Achse 1+2 PAGE-TYPE + NODE-TYPE (Redirect + B+)
├── prefetch/         — Achse 7 PREFETCH (Distance-Estimator + HierarchicalBundlePrefetcher V31.K6)
├── serialization/    — (Hilfs-Modul, kein direkter Achsen-Bezug)
└── value_buffer/     — Achse 4 VALUEHANDLE + Value-Pool-Mechanik
```

### §1.2 Achsen-Abdeckung Audit

| Achse | Sub-Verzeichnis vorhanden? | Status |
|---|---|---|
| 1 PAGE-TYPE | ✅ `nodes/` | DONE |
| 2 NODE-TYPE | ✅ `nodes/` | DONE |
| 3.A SearchAlgo-Traversal | ✅ `internal_search/` (4 Suchtypen) | DONE |
| 3.B Cache-Memory-Traversal | ❌ FEHLT | **muss angelegt werden** |
| 3.M Traversal-Mapping | ❌ FEHLT (eventuell in `memory_layout/`?) | **muss angelegt werden** |
| 4 VALUEHANDLE | ✅ `value_buffer/` + `value_handle/` (falls existiert) | DONE |
| 5 MEMORY-LAYOUT | ✅ `memory_layout/` | DONE |
| 6.1 Allocation-Strategy | ✅ `allocator/` | DONE |
| 6.2 Reclamation-Policy | ❌ FEHLT (eventuell in `concurrency/`) | **muss klargestellt werden** |
| 6.3 NUMA-Affinity | ❌ FEHLT | **muss angelegt werden** |
| 6.4 Huge-Page-Policy | ❌ FEHLT | **muss angelegt werden** |
| 6.5 Free-List-Strategy | ✅ in `allocator/` (Bucket-Strategy) | DONE |
| 7 PREFETCH | ✅ `prefetch/` (V31.K6) | DONE |
| 8.1 Concurrency-Pattern | ✅ `concurrency/` | DONE |
| 8.2 Locking-Mode | ❌ FEHLT (eventuell in `concurrency/`?) | **muss klargestellt werden** |
| 9 ISA | ❌ FEHLT | **muss angelegt werden** |
| 10 MEASUREMENT | ✅ `measurement/` | DONE |
| 11 TELEMETRY-COLLECTION | ❌ FEHLT (Kuehn-Strategien noch nicht integriert) | **muss angelegt werden** |
| **12 HARDWARE-STRATEGY** | ❌ FEHLT | **muss angelegt werden (O.3)** |
| **13 SCHEDULING-STRATEGY** | ❌ FEHLT | **muss angelegt werden (O.3)** |

**Bilanz:** 9/19 Sub-Achsen abgedeckt. **10 Sub-Achsen fehlen.**

---

## §2 O.2 — PRT-ART Neuartigkeits-Audit

User-Direktive 2026-05-18: "Ein neuartiger Algorithmus hat mindestens eine voellig neuartige Implementierung in mindestens einem Detail einer Axe."

### §2.1 PRT-ART Neuartigkeits-Pruefung

| Achse | PRT-ART-Auspraegung | Reuse-Status |
|---|---|---|
| 1 PAGE-TYPE | `PAGE_PRTART_DENSEBYTE` / `EXTENDEDDENSE` / ... | **(b) Neu-Impl** |
| 2 NODE-TYPE | `NODE_PRTART_REDIRECT` + `NODE_PRTART_BPLUS` (4 Sub-Suchtypen) | **(b) Neu-Impl** |
| 3.A | byte-by-byte mit Density-Schwellen | **(b) Neu-Impl Sub-Idee** |
| 3.B | (Default Cache-Line-Walk reuse?) | (?) AUDIT pending |
| 3.M | VirtualOffsetCalculator | **(b) Neu-Impl** |
| 4 | Inline / External / ChainRef | (a) Reuse aus K05 Konzept |
| 5 | TLB-Offset + Cache-Line-Aligned | **(b) Neu-Impl** |
| 6.1 | 4+2 Pool-Familie (per Suchtyp) | **(b) Neu-Impl** |
| 6.5 | Bucket-Strategy (Frage 15 GPT) | **(b) Neu-Impl** |
| 7 | Distance-Estimator + Path-Oriented + Redirect-Prefetch + HierarchicalBundlePrefetcher | **(b) Neu-Impl + (a) P27 Reuse** |
| 8.1 | OLC + reservierte Value-Bloecke + Lock-free-Reader | **(b) Neu-Impl Kombination** |
| 8.2 | mixed (read-only Tree + optimistic-Updates + read-write Buffer) | **(b) Neu-Impl** |
| 10 | Density-Tracker + H1/H2/H3-Metriken | **(b) Neu-Impl** |
| 12 | (TBD nach O.3) | (?) Default-Reuse |
| 13 | (TBD nach O.3) | (?) Default-Reuse |

**Bilanz:** PRT-ART qualifiziert MEHRFACH als "neuartiger Algorithmus":
- Achsen 1, 2, 3.A, 3.M, 5, 6.1, 6.5, 7, 8.1, 8.2, 10 = **11 Neu-Implementationen** (Minimum laut User: 1)

---

## §3 O.3 — Spiegel-Module fuer fehlende Achsen anlegen

Pro fehlender Achse (siehe §1.2 ❌) ein Skelett-Modul anlegen.

### §3.1 Achse 12 HARDWARE-STRATEGY → `prt_art/hardware/`

```
prt_art/include/prt_art/hardware/
├── prt_art_hardware_strategy.hpp   — Hauptkonzept
├── simd_family.hpp                  — Achse 12.1 (AVX2 default)
├── cache_level_targeting.hpp        — Achse 12.2 (L1-aware)
├── numa_strategy.hpp                — Achse 12.3 (local)
├── prefetch_hardware.hpp            — Achse 12.4 (PREFETCH + PREFETCHNTA)
└── atomic_instruction_family.hpp    — Achse 12.5 (CAS + LL-SC OLC)
```

Beispiel-Skelett `prt_art_hardware_strategy.hpp`:

```cpp
// V32.O3 — PRT-ART Hardware-Strategy (Achse 12 Spiegel)
#pragma once
#include <cstdint>

namespace comdare::prt_art::hardware {

/// Achse 12.1 SIMD-Family Auspraegung
enum class SimdFamily : std::uint8_t {
    Scalar = 0,
    AVX2 = 1,        ///< PRT-ART default
    AVX512 = 2,
    NEON = 3,
    SVE2 = 4
};

/// Achse 12.2 Cache-Level-Targeting Auspraegung
enum class CacheLevelTarget : std::uint8_t {
    L1Aware = 1,     ///< PRT-ART default (TLB-aligned)
    L2Aware = 2,
    L3Aware = 3,
    HBMAware = 4
};

/// Achse 12.3 NUMA-Strategy
enum class NumaStrategy : std::uint8_t {
    Local = 0,       ///< PRT-ART default
    Interleave = 1,
    Preferred = 2,
    Bind = 3,
    None = 4
};

/// Achse 12.4 Prefetch-Hardware
enum class PrefetchHwInstruction : std::uint8_t {
    None = 0,
    Prefetch = 1,    ///< PRT-ART Distance-Estimator
    PrefetchNta = 2, ///< PRT-ART Redirect-Path
    PrefetchW = 3
};

/// Achse 12.5 Atomic-Instruction-Family
enum class AtomicFamily : std::uint8_t {
    None = 0,
    CAS = 1,         ///< PRT-ART OLC
    LLSC = 2,        ///< PRT-ART Reserved-Block-Token
    RmwExtended = 3
};

/// Defaults fuer PRT-ART
struct PrtArtHardwareDefault {
    static constexpr SimdFamily simd = SimdFamily::AVX2;
    static constexpr CacheLevelTarget cache_level = CacheLevelTarget::L1Aware;
    static constexpr NumaStrategy numa = NumaStrategy::Local;
    static constexpr PrefetchHwInstruction prefetch_hw = PrefetchHwInstruction::Prefetch;
    static constexpr AtomicFamily atomic = AtomicFamily::CAS;
};

} // namespace comdare::prt_art::hardware
```

### §3.2 Achse 13 SCHEDULING-STRATEGY → `prt_art/scheduling/`

```
prt_art/include/prt_art/scheduling/
├── prt_art_scheduling_strategy.hpp   — Hauptkonzept
├── worker_pool_layout.hpp             — Achse 13.1 (thread-per-core)
├── simd_worker_count_limit.hpp        — Achse 13.2 (typ. 2 von N Cores)
├── heterogeneous_core_dispatch.hpp    — Achse 13.3 (Intel Hybrid P/E)
├── co_routine_strategy.hpp            — Achse 13.4 (interleave)
└── batch_granularity.hpp              — Achse 13.5 (micro-batch)
```

### §3.3 Achse 3.B + 3.M → `prt_art/traversal/`

```
prt_art/include/prt_art/traversal/
├── search_algo_traversal.hpp          — Achse 3.A (byte-by-byte + Density)
├── cache_memory_traversal.hpp         — Achse 3.B (cache-line-walk default)
└── traversal_mapping.hpp              — Achse 3.M (VirtualOffsetCalculator)
```

### §3.4 Achse 11 TELEMETRY-COLLECTION → `prt_art/telemetry/`

```
prt_art/include/prt_art/telemetry/
├── prt_art_telemetry_strategy.hpp     — Hauptkonzept
├── leaf_only_counter.hpp               — Achse 11.X1 (Kuehn-Strategie)
├── sampling_counter.hpp                — Achse 11.X2
├── offline_recompute.hpp               — Achse 11.X3
└── inner_node_counter_legacy.hpp      — Achse 11.X4 (ANTI-PATTERN, fuer Vergleich)
```

### §3.5 Achse 6.2/6.3/6.4 → `prt_art/allocator/` (Erweiterung)

```
prt_art/include/prt_art/allocator/
├── ...existierend...
├── reclamation_policy.hpp              — Achse 6.2 (epoch default)
├── numa_affinity.hpp                   — Achse 6.3 (local)
└── huge_page_policy.hpp                — Achse 6.4 (transparent)
```

### §3.6 Achse 9 ISA → `prt_art/isa/`

```
prt_art/include/prt_art/isa/
└── isa_features.hpp                    — Achse 9 (x86_64/ARM64 etc.)
```

---

## §4 O.4 — PRT-ART Reuse-vs-Neuartig Matrix

**Neu anzulegen:** `comdare-prt-art/docs/PRT_ART_AXES_REUSE_MATRIX.md`

Inhalt analog §2.1 oben. Pro Achse 1-13 (+ Sub-Achsen):
- PRT-ART-Klasse
- Reuse-Status: (a) SOTA-Reuse / (b) Neu-Impl / (c) Permutations-Config
- Quelle (CE-Sub-Engine konsumiert? / eigene Implementation?)
- Bezug zu Bausteine-Matrix Achse

**Beweis-Funktion:** PRT-ART qualifiziert als "neuartiger Algorithmus" mit min. 1 Neu-Impl in min. 1 Achse — siehe §2.1.

---

## §5 O.5 — Doku PrtArtSearchEngine = Spiegel zum Bausteine-Turm der CacheEngine

User-Direktive 2026-05-18: "Pruefling-Modul soll sich wie der Baustein-Axen-Turm der CacheEngine verhalten."

### §5.1 Doku-Update in `prt_art_search_engine.hpp`

Doxygen-Kommentar im Header ergaenzen:

```cpp
/// PrtArtSearchEngine ist die Pruefling-Implementierung der
/// 14-Achsen-Bausteine-Matrix. Pro Achse 1-13 wird (a) entweder ein
/// SOTA-Baustein aus der CacheEngine reusiert oder (b) eine
/// PRT-ART-eigene Neu-Implementation bereitgestellt.
///
/// Spiegel-Module:
///   Achse 1+2: prt_art/nodes/                    (b) Neu-Impl
///   Achse 3.A: prt_art/internal_search/          (b) Neu-Impl
///   Achse 3.B: prt_art/traversal/                (a) Reuse CE-Default
///   Achse 3.M: prt_art/traversal/                (b) Neu-Impl VirtualOffsetCalculator
///   Achse 4:   prt_art/value_handle/             (a) Reuse K05 Konzept
///   Achse 5:   prt_art/memory_layout/            (b) Neu-Impl TLB-Offset
///   Achse 6.1: prt_art/allocator/                (b) Neu-Impl 4+2 Pool
///   Achse 6.2: prt_art/allocator/reclamation_*   (a) Reuse epoch
///   Achse 6.3-6.5: prt_art/allocator/*           (a)+(b) gemischt
///   Achse 7:   prt_art/prefetch/                 (b) Neu-Impl + P27-Reuse (V31.K6)
///   Achse 8.1: prt_art/concurrency/              (b) Neu-Impl OLC+Reserved
///   Achse 8.2: prt_art/concurrency/              (b) Neu-Impl mixed
///   Achse 9:   prt_art/isa/                      (a) Reuse CE-Default
///   Achse 10:  prt_art/measurement/              (b) Neu-Impl Density+H1/H2/H3
///   Achse 11:  prt_art/telemetry/                (a) Reuse Kuehn 11.X1
///   Achse 12:  prt_art/hardware/                 (a)+(b) gemischt
///   Achse 13:  prt_art/scheduling/               (a) Reuse CE-Default
```

---

## §6 O.6 — Template-Parameter-Erweiterung 12 → 14+

Aktuelle PrtArtSearchEngine hat 12 Template-Parameter (V31). Erweiterung auf 14+ Parameter analog 14-Achsen-Modell.

### §6.1 Soll-Template-Liste

```cpp
template <
    typename Key,
    typename Value,

    // Achse 1+2: Page+Node-Strategie (Pruefling-spezifisch)
    typename PageStrategy           = PrtArtDefaultPageStrategy,
    typename NodeStrategy           = PrtArtDefaultNodeStrategy,

    // Achse 3: Traversal-Triple (3.A + 3.B + 3.M)
    typename AlgoTraversal          = PrtArtAlgoTraversal,
    typename CacheTraversal         = PrtArtCacheTraversal,
    typename TraversalMapping       = PrtArtVirtualOffsetCalculator,

    // Achse 4: ValueHandle
    typename ValueHandle            = PrtArtValueHandle,

    // Achse 5: Memory-Layout
    typename MemoryLayout           = PrtArtTLBOffsetLayout,

    // Achse 6: Allocator-Sub-Achsen (Per-Suchtyp Pool A/B/C/D + R + V-static/V-dynamic)
    typename AllocStrategy          = PrtArtBucketAllocator,
    typename ReclamationPolicy      = PrtArtEpochReclamation,
    typename NumaAffinity           = PrtArtLocalNuma,
    typename HugePagePolicy         = PrtArtTransparentHugePage,
    typename FreeListStrategy       = PrtArtSizeClassFreeList,

    // Achse 7: Prefetch
    typename PrefetchStrategy       = PrtArtDistanceEstimator,

    // Achse 8: Concurrency-Sub-Achsen
    typename ConcurrencyPattern     = PrtArtOLCWithReservedBlocks,
    typename LockingMode            = PrtArtMixedLockingMode,

    // Achse 9: ISA-Target
    typename IsaTarget              = PrtArtAvx2Target,

    // Achse 10: Measurement
    typename MeasurementStrategy    = PrtArtDensityH1H2H3,

    // Achse 11: Telemetry
    typename TelemetryStrategy      = PrtArtLeafOnlyCounter,

    // Achse 12: Hardware (NEU)
    typename HardwareStrategy       = comdare::prt_art::hardware::PrtArtHardwareDefault,

    // Achse 13: Scheduling (NEU)
    typename SchedulingStrategy     = comdare::prt_art::scheduling::PrtArtSchedulingDefault,

    // Optionale Filter
    typename FingerprintFilter      = PrtArtNoFingerprint
>
class PrtArtSearchEngine : public ISearchEngine<Key, Value> {
    // ...
};
```

### §6.2 Default-Variants

Alle neuen Template-Params haben sinnvolle Defaults — bestehende Aufrufer (V31.F Smoke-Tests) muessen NICHT geaendert werden.

### §6.3 V32.1 Implementations-Plan

1. Spiegel-Module aus O.3 anlegen (prt_art/hardware/, scheduling/, traversal/, telemetry/, isa/, allocator/-Erweiterungen)
2. PrtArtSearchEngine Template-Parameter-Liste erweitern (V32.1, siehe Tasks #512-515)
3. Default-Variants als Type-Aliases verfuegbar machen
4. Tests fuer neue Template-Params (siehe U.2 #511)

---

## §7 Konsequenzen fuer V32+ Code-Sprint

| Aenderung | Was | Wo | Task |
|---|---|---|---|
| 1 | `prt_art/hardware/` Sub-Verzeichnis NEU | comdare-prt-art | O.3 (V32.O3a) |
| 2 | `prt_art/scheduling/` Sub-Verzeichnis NEU | comdare-prt-art | O.3 (V32.O3b) |
| 3 | `prt_art/traversal/` Sub-Verzeichnis NEU | comdare-prt-art | O.3 (V32.O3c) |
| 4 | `prt_art/telemetry/` Sub-Verzeichnis NEU | comdare-prt-art | O.3 (V32.O3d) |
| 5 | `prt_art/isa/` Sub-Verzeichnis NEU | comdare-prt-art | O.3 (V32.O3e) |
| 6 | `prt_art/allocator/` erweitern um Sub-Achsen-Header | comdare-prt-art | O.3 (V32.O3f) |
| 7 | `prt_art/identity/prt_art_search_engine.hpp` Template-Params 12 → 20+ | comdare-prt-art | V32.1 (#512) |
| 8 | `PRT_ART_AXES_REUSE_MATRIX.md` Doku in `comdare-prt-art/docs/` | comdare-prt-art | O.4 |
| 9 | Tests fuer alle neuen Sub-Module + Template-Params | comdare-prt-art | U.2 (#511) |
| 10 | thesis Kapitel 04 Implementation Erweiterung um PRT-ART-Spiegel-Module | Diplomarbeit | (separat) |

---

## §8 Querverweise

- Bausteine-Matrix N-Phase: `../bausteine/07_bausteine_matrix_N_erweitert.md`
- Schichten-Modell M: `../architektur/10_schichten_modell_M.md`
- Anti-Vermischung: `../architektur/11_axes_vs_strategies_disambiguation.md`
- T-Phase Adapter-Status: `T_PHASE_ADAPTER_STATUS.md`
- V31.K6 HierarchicalBundlePrefetcher: `comdare-prt-art/prt_art/include/prt_art/prefetch/hierarchical_bundle_prefetcher.hpp`
- Memory N-Phase: `~/.claude/.../memory/reference_n_phase_achsen_erweiterung.md`
- Memory M-Schichten: `~/.claude/.../memory/reference_m_schichten_modell.md`

---

**Ende docs/adapters/O_PHASE_PRT_ART_AXES_MIRROR.md (O.1-O.6 als Konsolidierungs-Doku DONE).**
