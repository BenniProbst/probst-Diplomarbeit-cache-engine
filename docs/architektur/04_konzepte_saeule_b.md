# Konzepte Saeule B — Plattform-Modell

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-15 (K-C.5)
**Quelle:** `Phase5_UML_Detail/13_saeule_b_plattform_modell_konkretisierung.md` (631 Z)

---

## §1 Saeule B im Drei-Saeulen-Modell

```
EBENE 3: ← SAEULE B — CacheEngine + Plattform-Modell
  IPlatformProbe (Auto-Discovery) /
  IPlatformPropertyClassifier /
  ICacheLevel / ICacheLine / ICacheTopology / ICacheResidency /
  ICpuCore / ICoreLayout / ICoreToThreadMap / IPinningPolicy /
  IHardwareExtension / IIsaFeatureSet /
  IInterconnect / IBusTopology / IMemoryBandwidthModel /
  ILivePlatformModel / ILiveCpuModel /
  IScheduler / IHeuristik / ICacheEngineOptionPublisher /
  DecisionLambdaTrees
```

**Trennungs-Prinzip:** Saeule B ist plattform-agnostisch im Code, plattform-konkret im Verhalten via Auto-Discovery.

---

## §2 KORREKTUR-RUNDE 3 (2026-05-10) — Plattform-Auto-Discovery statt CPU-Spezialisierung

### 2.1 Architektur-Falsch (vor REV5 K3.2)

Plattform-spezifische Klassen, die hard-coded fuer eine bestimmte CPU-Generation gebaut sind:
- `RyzenX3DProbe` (fuer Ryzen 9950X3D)
- `IntelHybridProbe` (fuer i9-14900KS)
- `X3DAwareFactory`
- `X3DVCachePinningHeuristic`
- `IntelHybridPCoreRoutingHeuristic`
- `IntelHBMAllocator` / `GraceHopperHBMAllocator`

### 2.2 Architektur-Richtig (REV5 K3.2)

GENERELLE `IPlatformProbe` und `IPlatformPropertyClassifier`, die ALLE Cache-/CPU-Eigenschaften AUTOMATISCH entdecken + AUTOMATISCH ausmessen.

| Falsch (CPU-spezifisch) | Richtig (allgemein) |
|---|---|
| `RyzenX3DProbe` | `IPlatformProbe` entdeckt `cache_topology.l3_per_ccd` mit verschiedenen Werten ⇒ Property `has_asymmetric_l3 = true` |
| `IntelHybridProbe` | `IPlatformProbe` entdeckt `core_layout.core_classes` mit mehreren Klassen ⇒ Property `has_hybrid_cores = true` |
| `X3DAwareFactory` | `IPlatformPropertyClassifier` liefert `preferred_pinning = LARGEST_L3_CCD` (gewaehlt durch Messung) |
| `X3DVCachePinningHeuristic` | `LargestL3CcdPinningHeuristic` (allgemein, nicht CPU-spezifisch) |
| `IntelHybridPCoreRoutingHeuristic` | `HotPathOnHighIpcCoreHeuristic` (allgemein) |
| `IntelHBMAllocator` | `IPlatformProbe` entdeckt `has_hbm_tier = true` ⇒ generelle `HbmAllocationStrategy` |

---

## §3 Auto-Discovery-Pflichten der CacheEngine

Pro Plattform-Eigenschaft fuehrt der CacheEngineBuilder vor jedem Permutations-Build aus:

1. **Discover** (statisch): Lese aus CPUID / sysfs / /proc/cpuinfo / hwloc / cpuid-Instruction
2. **Measure** (dynamisch): Mikrobenchmark (z.B. clflush-cycle-Measurement; All-Pairs-Pinning-Vermessung; Cache-Coherence-Cost-Calibration)
3. **Classify**: Stelle aus den Messungen Properties zusammen (`has_asymmetric_l3`, `preferred_pinning`, `usable_simd_width`, ...)
4. **Publish**: Stelle die Properties allen Permutations-Modulen als Konfigurations-Optionen zur Verfuegung
5. **Bind**: Pro Permutation entscheidet die `ICacheStrategy`-Visitor-Implementierung, welche Properties sie konsumiert

→ Cache-Engine bleibt **plattform-agnostisch im Code, plattform-konkret im Verhalten**.

---

## §4 Block AO Production-Plattform (Beispiel-Konkretisierung)

**Block AO** (siehe Begriffsglossar v7 BLOCK AO) bleibt als KONKRETES BEISPIEL fuer Auto-Discovery erhalten:

### 4.1 Production-Maschinen (Architekt-Beschluss 2026-05-08)

| Maschine | Spezifikation |
|---|---|
| **AMD Ryzen 9 9950X3D** (Zen 5, mit X3D-V-Cache) | 16 Cores / 32 Threads; 3D V-Cache asymmetrisch 96+32 MiB L3 (CCD0 mit V-Cache, CCD1 ohne); DDR5-5600, 64 GB |
| **Intel Core i9-14900KS** (Raptor Lake Refresh) | Hybrid-CPU: 8 P-Cores + 16 E-Cores (24 Cores / 32 Threads); Pflicht: cpu_core/* vs cpu_atom/* perf-Counter trennen; DDR5-5600, 64 GB |

### 4.2 Was Auto-Discovery dort findet

| Auto-Discovery-Property | Wert |
|---|---|
| `has_asymmetric_l3` | `true` (96+32 MiB) |
| `has_hybrid_cores` | `true` (8P+16E) |
| `cpu_core_atom_perf_separation` | `required` |
| `cpu_class_count` | 2 (P-Core + E-Core) |
| `cache_topology.l3_per_ccd` | unterschiedliche Werte (96/32) |

### 4.3 Welche Permutationen davon profitieren

Alle, die `ICacheStrategy`-Visitor mit Pinning-Hint konsumieren.

---

## §5 28 Saeule-B-Concept-Klassen (REV5 K07)

In REV5 K07 wurden 28 fehlende Concept-Klassen identifiziert + integriert (Doc 22 §7.2):

| # | Concept-Klasse | Bedeutung |
|---|---|---|
| 1 | `IRankSelectPrimitive` | Basis-Operation fuer succinct Strukturen (P09 Jacobson, P10 SuRF) |
| 2 | `IBranchPredictorModel` | Branch-Prediction-Awareness (P33 VAMPIR) |
| 3 | `IBitManipulationFeatureGate` | BMI2/PEXT/PDEP-Verfuegbarkeit (P02 HOT) |
| 4 | `IStorageMedium` | DRAM vs HBM vs NVRAM (P32 Schmidt) |
| 5 | `IPageCacheModel` | OS-Page-Cache-Modell |
| 6 | `IConcurrencyProtocol` | Lock vs Lock-Free vs OLC vs RCU |
| 7 | `IRebuildScheduler` | Wann Reorg/Rebuild ausloesen |
| 8 | `IRebuildCostModel` | Kosten-Schaetzung fuer Reorg |
| 9 | `IWorkloadModel` | YCSB-Workloads, Read/Write/Range-Verhaeltnis |
| 10 | `ICellProbeModel` vs `IWordProbeModel` | Theoretisches Modell |
| 11-28 | (siehe Original Doc 22 §7.2) | weitere Plattform-Konzepte |

---

## §6 Plattform-Modell verfeinert (REV5 K08)

REV5 K08 (Doc 22 §8.2) ergaenzte:
- **NUMA-Awareness**: Multi-Socket-Topologie, Node-Distance-Matrix, Memory-Affinity
- **TLB-Modell**: Hugepages 2 MB / 1 GB, TLB-Reach, dTLB-Miss-Pattern
- **Hardware-Counter-Feedback**: perf-Counter (P31 Ungethuem TUD, P32 Schmidt TUD)
- **NVRAM/Persistent-Memory**: Persistent-Memory-Ebene
- **6-Flavor-RCU-Klassifikation**: Memory-Barrier-Variants (P29 McKenney 2001)

---

## §7 ~80 Heuristiken (REV5 K09)

Doc 13 §9 + Doc 12 §4 wurden in REV5 K09 vereint und bereinigt: ca. 80 Heuristiken konsolidiert.

Detail-Liste siehe Original-Datei `13_saeule_b_plattform_modell_konkretisierung.md` §9.

---

## §8 V31 Code-Stand fuer Saeule B

| Komponente | V31 Code-Pfad |
|---|---|
| IPlatformProbe (Auto-Discovery) | `comdare-cache-engine/libs/cache_engine/builder/platform_probe/` |
| ILivePlatformModel + ILiveCpuModel | `libs/cache_engine/builder/live_cpu_model/` |
| IScheduler + IHeuristik | (in libs/cache_engine/builder/ verteilt) |
| DecisionLambdaTrees | `libs/cache_engine/builder/decision_lambda_trees/` |
| Hardware/ISA Plattform-Defines | `libs/common/platform/` (V23.C) |

V31 hat die Plattform-Auto-Discovery (V8.5 INK-5) implementiert.

---

## §9 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/13_saeule_b_plattform_modell_konkretisierung.md`
- Saeule A Konzepte: `03_konzepte_saeule_a.md` (K-C.4)
- UML-Klassen Hardware/ISA: `05_uml_klassen.md` §4 (K-C.6)
- REV-Historie K3.2 Plattform-Auto-Discovery: `01_REV_Historie.md` §4 K07/K08 (K-C.2)
- Aktueller Master REV7.7 Drei-Repo-Layer: `02_aktueller_master_REV7_7.md` §1+§2 (K-C.3)
- Begriffsglossar v7 BLOCK AO Production-Plattform: `../glossar/01_begriffsglossar_v7_master.md` §7.3
- Architekturentscheidungen F13 Cross-Compilation-Toolchain: `../bausteine/04_architekturentscheidungen_F1_F15.md`
