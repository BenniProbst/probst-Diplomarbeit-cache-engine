# BB.1 + BB.2 — Doxygen-Mapping-Konvention fuer Achsen + Subsystem + Reuse-Status

**Stand:** 2026-05-18 (BB.1+BB.2 Spezifikation)
**Konsequenz:** Pro Header in cache-engine + prt-art ein Doxygen-Block ergaenzen, der maschinen-lesbar Achsen-Zuordnung + Default-Lookup-Status zeigt.

> Diese Konvention erlaubt Doxygen + grep + custom-script die N-Phase-14-Achsen-Abdeckung DIREKT aus dem Source-Code zu extrahieren (statt nur aus Doku). Damit ist die Doku auto-konsistent mit Code.

---

## §1 Custom Doxygen Tags (neu eingefuehrt)

| Tag | Bedeutung | Beispiel |
|---|---|---|
| `@achse N` oder `@achse N.X` | Bausteine-Matrix-Achse | `@achse 1` oder `@achse 6.2` |
| `@subsystem CE/CEB/PA` | M-Modell-Subsystem-Zuordnung | `@subsystem CE` |
| `@reuse_status (a)/(b)/(c)/(default-lookup)` | AA.3-Korrektur Status | `@reuse_status (b)` |
| `@kuehn_variant 11.X1-X4` | Achse 11 Telemetry-Sub-Variante | `@kuehn_variant 11.X1` |
| `@phase_owner CEB/CE/PA` | Pipeline-Phasen-Verantwortung | `@phase_owner CEB` |
| `@command_pattern Execute/Compare/AutoPermutate` | Command-Pattern-Klasse (AA.2) | `@command_pattern Execute` |
| `@anti_pattern` | bekannte Falsch-Implementation (z.B. 11.X4 Ping-Pong) | `@anti_pattern` |
| `@default_lookup_provided_by CE-libs/families/X` | falls Achse via Default-Lookup gemacht | `@default_lookup_provided_by cache-engine/concepts/telemetry/` |

---

## §2 BB.1 cache-engine — 8 Beispiel-Doxygen-Bloecke

### §2.1 i_telemetry_strategy.hpp (Achse 11)

```cpp
/**
 * @brief ITelemetryStrategy - Concept Achse 11 TELEMETRY-COLLECTION
 * @achse 11
 * @subsystem CE
 * @reuse_status (b)
 * @kuehn_variants 11.X1 LeafOnlyCounter, 11.X2 LeafOnlySampledCounter,
 *                 11.X3 RetroactiveAggregator, 11.X4 PerNodeCounter (ANTI-PATTERN)
 * @phase_owner CE (wird von Pruefling konsumiert in Phase 6 EXECUTE)
 *
 * Default-Implementations vom CE bereitgestellt:
 * - LeafOnlyCounter (Kuehn-Hauptvariante 2024+, vermeidet Cache-Line-Ping-Pong)
 * - LeafOnlySampledCounter (n-tes-Zugriff-Sampling)
 * - RetroactiveAggregator (bottom-up vor Reordering)
 * - PerNodeCounter (DEPRECATED - hat Cache-Line-Ping-Pong-Problem)
 */
class ITelemetryStrategy { ... };
```

### §2.2 leaf_only_counter.hpp (Achse 11.X1 KUEHN)

```cpp
/**
 * @brief LeafOnlyCounter - Achse 11.X1 KUEHN-Hauptvariante 2024+
 * @achse 11.X1
 * @subsystem CE
 * @reuse_status (b)
 * @kuehn_variant 11.X1
 * @phase_owner CE
 *
 * Implementiert Kuehn-Strategie (DaMoN 2023 + 2024-Erweiterung):
 * Counter NUR in Blatt-Knoten -> vermeidet Cache-Line-Ping-Pong in oberen Baum-Ebenen.
 *
 * Vor Reordering: Offline-Recompute via RetroactiveAggregator (11.X3) summiert
 * Counter bottom-up zur Wurzel.
 */
class LeafOnlyCounter : public ITelemetryStrategy { ... };
```

### §2.3 per_node_counter.hpp (Achse 11.X4 ANTI-PATTERN)

```cpp
/**
 * @brief PerNodeCounter - Achse 11.X4 NAIVE Variante DEPRECATED
 * @achse 11.X4
 * @subsystem CE
 * @reuse_status (b)
 * @kuehn_variant 11.X4
 * @anti_pattern
 * @deprecated Cache-Line-Ping-Pong-Problem bei Multi-Thread-Zugriff auf obere Baum-Ebenen
 *
 * Counter in ALLEN Knoten (auch inneren). Funktioniert single-threaded.
 * In Multi-Thread-Workload: Cache-Coherence-Aufwand schnell starkem Cacheline-Ping-Pong
 * zwischen Kernen, was Performance entsprechend beeintraechtigt.
 *
 * BLEIBT FUER VERGLEICH (F15-Forschungsmission): wir zeigen Differenz Leaf-Only vs Per-Node.
 */
class PerNodeCounter : public ITelemetryStrategy { ... };
```

### §2.4 cache_engine_builder/commands/ (Command-Pattern AA.2, V32 NEU)

```cpp
/**
 * @brief ICommand - Command-Pattern fuer CEB Test-Treiber (V32 NEU)
 * @subsystem CEB
 * @phase_owner CEB
 * @command_pattern Base
 *
 * Wird in CacheEngineBuilder verwendet um zwei ExecutionEngines (CE + PrtArt)
 * parallel zu orchestrieren (AA.2 Korrektur des M-Modells).
 */
class ICommand { ... };

/**
 * @brief ExecuteEngineCommand - fuehrt eine ExecutionEngine auf einer Permutation aus
 * @command_pattern Execute
 * @phase_owner CEB
 */
class ExecuteEngineCommand : public ICommand { ... };

/**
 * @brief CompareEngineCommand - vergleicht 2 EE-Ergebnisse (F15 Forschungsmission)
 * @command_pattern Compare
 * @phase_owner CEB
 */
class CompareEngineCommand : public ICommand { ... };

/**
 * @brief AutoPermutateAxisCommand - lookup CE-Bibliothek + permutiert fehlende Achse (AA.3)
 * @command_pattern AutoPermutate
 * @phase_owner CEB
 *
 * Bei fehlender Achsen-Spec im algorithm_profile: Auto-Lookup aller verfuegbaren SOTA-Bausteine
 * der Achse + Permutations-Generierung.
 */
class AutoPermutateAxisCommand : public ICommand { ... };
```

### §2.5 hardware_strategy.hpp (Achse 12 NEU)

```cpp
/**
 * @brief IHardwareStrategy - Achse 12 HARDWARE-STRATEGY (NEU)
 * @achse 12
 * @subsystem CE
 * @reuse_status (b)
 *
 * Aktive Hardware-Strategie des Algorithmus (NICHT C09 Hardware-Probing-Heuristik).
 * Sub-Achsen 12.1 SIMD-Family, 12.2 Cache-Level-Targeting, 12.3 NUMA-Strategy,
 * 12.4 Prefetch-Hardware, 12.5 Atomic-Instruction-Family.
 *
 * Default-Variants vom CE bereitgestellt (Auto-Permutation aus families/):
 * - SIMD: AVX2, AVX-512, NEON, SVE2, scalar
 * - Cache: L1/L2/L3/HBM-aware
 * - NUMA: local/interleave/preferred/bind
 * - PrefetchHW: PREFETCH/PREFETCHNTA/PREFETCHW
 * - Atomic: CAS/LL-SC/RmwExtended
 */
class IHardwareStrategy { ... };
```

### §2.6 permutation_flags.hpp (V32.2 14 Banks)

```cpp
/**
 * @brief PermutationFlags - 82-bit Bitfield fuer Permutations-ID (V32.2 ERWEITERUNG)
 * @subsystem CE
 * @phase_owner CEB
 *
 * V31: 9 Banks (~50 bit)
 * V32.2: 14 Banks (82 bit) mit Sub-Bank-Encoding fuer Achse 3 + 6 + 8 + NEU 12 + 13.
 *
 * Migrations-Mapper v31_to_v32 erlaubt Backward-Compat (default-encoding fuer neue Banks).
 */
struct PermutationFlags { ... };
```

---

## §3 BB.2 prt-art — 8 Beispiel-Doxygen-Bloecke

### §3.1 prt_art_search_engine.hpp (Subsystem 4)

```cpp
/**
 * @brief PrtArtSearchEngine - ExecutionEngine B im M-Modell (AA.2 Korrektur)
 * @subsystem PA
 * @phase_owner PA (wird vom CEB orchestriert, Phase 6 EXECUTE)
 * @command_pattern Execute (ist Target eines ExecuteEngineCommand)
 *
 * V31.F: 12 Template-Parameter
 * V32.1: 14-16 Template-Parameter (siehe O.6 §0 KORRIGIERT)
 *
 * Implementiert IExecutingEngine + ISearchEngine.
 * GLEICHWERTIG zu cache_engine::CacheEngine als ExecutionEngine A.
 * KEIN "im CE-Subsystem registrierter Pruefling" - sondern eigenstaendige EE.
 */
template <...20+ Template-Params...>
class PrtArtSearchEngine : public ISearchEngine<Key, Value> { ... };
```

### §3.2 nodes/bplus_node.hpp (Achse 1+2 (b))

```cpp
/**
 * @brief BPlusNode - Achse 1 PAGE-TYPE + Achse 2 NODE-TYPE (PRT-ART eigen)
 * @achse 1
 * @achse 2
 * @subsystem PA
 * @reuse_status (b)
 *
 * 4 interne Suchtypen A/B/C/D (Dichte-Schwellen-Transition):
 * - Typ A (Array256): < 25% Dichte
 * - Typ B (Array65535): 25-50% Dichte (Punkt-Suche)
 * - Typ C (VectorU8U8): 50-75% Dichte (Range-Scan)
 * - Typ D (VectorU16U16): > 75% Dichte (terminale Form)
 */
class BPlusNode : public IPrtArtNode { ... };
```

### §3.3 prefetch/distance_estimator.hpp (Achse 7 (b))

```cpp
/**
 * @brief DistanceEstimator - Achse 7 PREFETCH (PRT-ART Neu-Impl)
 * @achse 7
 * @subsystem PA
 * @reuse_status (b)
 *
 * Distance-Schaetzung fuer Cache-Level-Auswahl im HierarchicalBundlePrefetcher (V31.K6).
 */
class DistanceEstimator { ... };
```

### §3.4 traversal/traversal_mapping.hpp (Achse 3.M (b), V32 NEU verschoben)

```cpp
/**
 * @brief VirtualOffsetCalculator - Achse 3.M Traversal-Mapping (PRT-ART eigen)
 * @achse 3.M
 * @subsystem PA
 * @reuse_status (b)
 *
 * V32 NEU: aus memory_layout/virtual_offset_address.hpp nach traversal/ verschoben.
 * Mapping zwischen Algorithmus-Konzept (Pool-Adressierung) und physischer Cache-Memory.
 */
class VirtualOffsetCalculator { ... };
```

### §3.5 (Beispiel) prt_art/telemetry/ - DEFAULT-LOOKUP-Indikator (V32 KEIN Code, nur Header-Hinweis)

```cpp
/**
 * @file prt_art_telemetry_default_lookup.hpp
 * @brief PLATZHALTER - keine PrtArt-spezifische Telemetry-Implementation
 * @achse 11
 * @subsystem PA
 * @reuse_status (default-lookup)
 * @default_lookup_provided_by cache-engine/concepts/telemetry/
 *
 * PRT-ART hat KEINE eigene Telemetry-Implementation auf Achse 11.
 * CEB-AutoPermutator nutzt die CE-Bibliothek (LeafOnlyCounter / Sampled /
 * RetroactiveAggregator / PerNodeCounter) zur Permutation.
 *
 * Wenn PRT-ART spaeter eine eigene Telemetry braucht: hier ueberschreiben mit @reuse_status (b).
 */
// Bewusst KEINE Klassen-Definition - Default-Lookup signalisiert "kein PrtArt-Code".
```

### §3.6 (Beispiel) prt_art/hardware/ - DEFAULT-LOOKUP-Indikator

```cpp
/**
 * @file prt_art_hardware_default_lookup.hpp
 * @brief PLATZHALTER - keine PrtArt-spezifische Hardware-Strategy
 * @achse 12
 * @subsystem PA
 * @reuse_status (default-lookup)
 * @default_lookup_provided_by cache-engine/concepts/hardware_strategy.hpp (V32 NEU)
 *
 * PRT-ART nutzt CE-Bibliothek-Default fuer Hardware-Strategy.
 * Auto-Permutation: CEB iteriert AVX2/AVX-512/NEON/SVE2/scalar + L1/L2/L3/HBM
 * + local/interleave/preferred + PREFETCH/PREFETCHNTA + CAS/LL-SC, gefiltert per IPlatformProbe.
 */
```

---

## §4 Auto-Extraktion via Custom-Script (V32 Folge)

Pro Repo ein Script `extract_achsen_coverage.sh`:

```bash
#!/bin/bash
# extract_achsen_coverage.sh - Extrahiert Achsen-Abdeckung aus Doxygen-Tags
grep -rn "@achse " libs/ prt_art/ --include="*.hpp" |
  awk -F'@achse ' '{print $2}' |
  sort | uniq -c | sort -rn
```

Output:
```
   15 1
   12 2
    8 3.A
    1 3.B   # nur in cache-engine
    2 3.M   # 1x prt-art (b) + 1x cache-engine (default)
    ...
```

Damit ist die N-Phase-Coverage direkt aus Source extrahierbar.

---

## §5 Konsequenzen + Implementations-Reihenfolge

### §5.1 BB.1 cache-engine (Submodule-Push erforderlich)

Pro Header: Doxygen-Block ergaenzen ohne Code-Aenderung. Aufwand: 193 Header * 1 Min = ~3 Stunden.

**Prioritaet:**
1. concepts/telemetry/* (4 Files) - Kuehn-Mapping
2. cache_engine/builder/* (5 Files) - Phase-Owner-Mapping
3. concepts/disciplines/* (10 Files) - Achse 3 + 8 Mapping
4. allocators/concepts/* + families/* - Achse 6 Mapping
5. NEU concepts/hardware_strategy.hpp + scheduling_strategy.hpp - Achse 12+13

### §5.2 BB.2 prt-art (Submodule-Push erforderlich)

Pro Header: Doxygen-Block. Plus 2-3 NEUE Platzhalter-Files fuer Default-Lookup-Indikatoren. Aufwand: ~30 Files * 1 Min = ~30 Min.

### §5.3 Test der Auto-Extraktion (V32 Folge)

Script schreiben + auf beiden Repos laufen lassen. CI-Pipeline ergaenzen um auto-Achsen-Coverage-Report.

---

## §6 Querverweise

- AA.1 drawio-Konsolidierung: `AA1_drawio_konsolidierung.md`
- AA.2 M-Modell-Korrektur: `../architektur/10_schichten_modell_M.md` §0
- AA.3 Z.5-Korrektur: `Z5_master_index_und_gap_analyse.md` §0
- AA.4 O-Phase-Korrektur: `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md` §0
- CC.1 + CC.2 drawio Tabs: REV7.drawio Tab 50 + Tab 51
- DD.1+DD.2+DD.3 V32-Code: folgt in DD-Phase

---

**Ende docs/uml_planning/BB_doxygen_mapping_konvention.md (BB.1+BB.2 Spec DONE).**
