# OP-1 bis OP-6 Operations-Detail-Spezifikationen (Q.2)

**Stand:** 2026-05-21 (Q.2 unter V33-Architektur-Bezug)
**Quelle:** `docs/termine/20260508 Termin 7/Datasets_Spezifikation.txt`, Section "OP-1 bis OP-6"
**V33-Bezug:** Mapping auf `WorkloadKind` enum in `cache_engine/builder/commands/workload.hpp`

---

## §0 Mapping-Tabelle (Master)

| OP | Operation | YCSB-Mapping | V32 WorkloadKind | Hardware-Empfehlung | Scheduling-Empfehlung | Telemetry default |
|---|---|---|---|---|---|---|
| **OP-1** | Read | YCSB_C | `YCSB_C_ReadOnly` | AVX2 + L1Aware | ThreadPerCore + WorkStealing | LeafOnlyCounter (Kuehn 11.X1) |
| **OP-2** | Insert | YCSB_LOAD | (custom: `Custom_BulkInsert`) | Scalar + L3Aware | ThreadPerCore + Limit_1 | RetroactiveAggregator (11.X3) |
| **OP-3** | Update | YCSB_A | `YCSB_A_Read50Write50` | AVX2 + L2Aware | WorkStealing + Limit_2 | LeafOnlySampledCounter (11.X2) |
| **OP-4** | Scan | YCSB_E | `YCSB_E_Scan95` | AVX512 + L3Aware | ThreadPerCore + MacroBatch | PathReadCounter (11.X3b) |
| **OP-5** | Read-Modify-Write | YCSB_F | `YCSB_F_ReadModifyWrite` | AVX2 + L2Aware | CpuPinning + Limit_2 | LeafOnlyCounter (11.X1) |
| **OP-6** | Range-Delete | (custom) | `Custom_RangeDelete` | Scalar + L1Aware | ThreadPerCore + Limit_1 | RetroactiveAggregator (11.X3) |

---

## §1 OP-1 — Read (Pure Lookup)

**Beschreibung:** Reine Lookup-Workload ohne Schreibzugriffe. Best-case fuer Cache-Engine-Optimierungen, da Reordering nach erstem Warmup stabil bleibt.

**YCSB-Mapping:** `YCSB_C` (100% read).

**Workload-Variation:**
- **Uniform:** Zugriff ueber gesamten Key-Range gleichverteilt
- **Hot-Key (Zipf):** 80/20 Pareto-Verteilung — passt zu Reordering (Kuehn)
- **Sequential-Scan:** Reads in Key-Reihenfolge

**Hardware-Empfehlung:**
- SIMD: AVX2 (256-bit batched compare-key fuer Trie-Lookup)
- Cache-Level: L1Aware (Hot-Keys passen in L1)
- NUMA: Local (kein Cross-Node-Pingpong)

**Scheduling-Empfehlung:**
- Worker-Pool: ThreadPerCore mit WorkStealing
- SIMD-Worker: Limit_2 (Hardware-Default)
- Heterogeneous-Awareness: HybridAware (P-Core fuer Hot-Path)

**Telemetry default:** `LeafOnlyCounter` (Kuehn 11.X1) — minimaler Overhead bei Read-only.

**Vergleichs-Workloads (Cross-Ref):**
- `bart-master/HAT-Trie` (P06 Schuele) read-only
- `index-microbench/BTreeOLC` (Kuehn-Basis) `--workload=ycsb_c`
- `unodb` benchmarks (P01 ART) lookup-suite

---

## §2 OP-2 — Insert (Bulk-Insert)

**Beschreibung:** Massen-Insert (z.B. Initial-Load). Wichtig fuer "Build-Performance"-Bewertung.

**YCSB-Mapping:** `YCSB_LOAD` (initial-load phase, custom enum `Custom_BulkInsert`).

**Workload-Variation:**
- **Sequential:** Inserts in Key-Reihenfolge (best-case fuer B+-Trees, schlecht fuer Hashing)
- **Random:** Inserts in zufaelliger Reihenfolge (worst-case fuer B+-Trees)

**Hardware-Empfehlung:**
- SIMD: Scalar (Insert ist branch-heavy, SIMD selten nutzbar)
- Cache-Level: L3Aware (working set wird waehrend Load gross)
- NUMA: Interleave (Memory-Pressure verteilen)

**Scheduling-Empfehlung:**
- Worker-Pool: ThreadPerCore (Insert ist nicht batch-friendly)
- SIMD-Worker: Limit_1
- Batching: Single (jeder Insert separat — Sequential-Sort der Keys vorab)

**Telemetry default:** `RetroactiveAggregator` (11.X3) — bottom-up nach Load fuer Reordering-Decision.

---

## §3 OP-3 — Update (Hot-Key)

**Beschreibung:** Workload mit Hot-Key-Konzentration und 50/50 Read/Update-Mix.

**YCSB-Mapping:** `YCSB_A` (`YCSB_A_Read50Write50`).

**Workload-Variation:**
- **Hot-Key (Zipf 0.99):** 90% Zugriffe auf 10% Keys
- **Uniform:** Update gleichverteilt

**Hardware-Empfehlung:**
- SIMD: AVX2 (compare-key fuer Update-Path)
- Cache-Level: L2Aware (Hot-Set passt in L2)
- Atomic-Granularity: CAS_64 (typische Pointer-Update)

**Scheduling-Empfehlung:**
- Worker-Pool: WorkStealing (variable Workload pro Thread)
- SIMD-Worker: Limit_2
- Concurrency-Pattern (Achse 8.1): `OptimisticLockCoupling` (P08)

**Telemetry default:** `LeafOnlySampledCounter` (11.X2) — Sampling reduziert Write-Overhead.

**ANTI-PATTERN-Hinweis:** `PerNodeCounter` (11.X4) — Cache-Line-Ping-Pong bei Hot-Key.

---

## §4 OP-4 — Scan (Range-Query)

**Beschreibung:** Range-Scans dominieren (95% scan, 5% insert).

**YCSB-Mapping:** `YCSB_E` (`YCSB_E_Scan95`).

**Workload-Variation:**
- **Short-Range (k=10-100 Keys):** L2-resident
- **Long-Range (k=1000+ Keys):** L3-stressed, prefetch-kritisch

**Hardware-Empfehlung:**
- SIMD: AVX512 (gather-instructions fuer scan-prefetch)
- Cache-Level: L3Aware (scan-working-set ueberschreitet L1/L2)
- Prefetch-Distance: PrefetchT1 oder PrefetchT2 (look-ahead beim Scan)

**Scheduling-Empfehlung:**
- Worker-Pool: ThreadPerCore
- Batching: MacroBatch (128+ ops per batch)
- Memory-Interleave: RoundRobin (Scan stresst NUMA)

**Telemetry default:** `PathReadCounter` (11.X3b) — Counter entlang Read-Pfaden.

---

## §5 OP-5 — Read-Modify-Write (Conflict-Heavy)

**Beschreibung:** Konflikt-intensive Workloads (50% read / 50% RMW).

**YCSB-Mapping:** `YCSB_F` (`YCSB_F_ReadModifyWrite`).

**Workload-Variation:**
- **Conflict-Heavy:** RMW auf wenigen Hot-Keys (Stress fuer Lock-Pattern)
- **Lock-Free-Friendly:** RMW gleichverteilt (kein Pingpong)

**Hardware-Empfehlung:**
- SIMD: AVX2
- Cache-Level: L2Aware
- Atomic-Granularity: CAS_128 (RMW braucht atomic-tag+value)

**Scheduling-Empfehlung:**
- Worker-Pool: CpuPinning (deterministisch fuer Lock-Profiling)
- SIMD-Worker: Limit_2
- Locking-Mode (Achse 8.2): `LockFree` (Conflict-Heavy) oder `Optimistic` (Conflict-Light)

**Telemetry default:** `LeafOnlyCounter` (11.X1).

---

## §6 OP-6 — Range-Delete (Bulk-Delete-Pattern)

**Beschreibung:** Bulk-Delete von Key-Ranges (z.B. TTL-Expiry, Garbage-Collection).

**YCSB-Mapping:** keine (Custom-Operation, enum `Custom_RangeDelete`).

**Workload-Variation:**
- **Contiguous-Range:** Delete von zusammenhaengendem Key-Bereich
- **Sparse-Range:** Delete von verstreuten Keys (selteneres Pattern)

**Hardware-Empfehlung:**
- SIMD: Scalar (Delete ist pointer-chase + tree-rebalance)
- Cache-Level: L1Aware (Delete-Path beruehrt wenige Cache-Lines pro Op)
- NUMA: Local

**Scheduling-Empfehlung:**
- Worker-Pool: ThreadPerCore + Limit_1 (Delete-Lock-Range ist nicht parallelisierbar)
- Reclamation-Policy (Achse 6.2): `RCU` oder `EpochBased` (deferred-free)

**Telemetry default:** `RetroactiveAggregator` (11.X3) — vor Delete den Subtree-Counter aggregieren fuer Cleanup-Decision.

---

## §7 V32-Integration — `<op_type>` in messreihen.xml

**XML-Erweiterung** (V33.D.4):

```xml
<tupel id="t01">
    <workload kind="YCSB_C_ReadOnly" record_count="1000000" operation_count="100000" seed="42"/>
    <op_type>OP-1</op_type>   <!-- NEU: OP-1 bis OP-6 -->
</tupel>
```

**Filter-Logik im V32Orchestrator** (V33.D.5): Pro `<op_type>` werden NUR die default-Telemetrie/Hardware/Scheduling-Strategien aktiviert die in der Mapping-Tabelle (§0) stehen.

**Pseudo-Code:**

```cpp
// V33.D.5 (V34+ Sprint): OpTypeFilter
struct OpTypeFilter {
    static std::vector<std::string> default_axes_for(std::string_view op_type) {
        if (op_type == "OP-1") return {"AVX2", "L1Aware", "ThreadPerCore", "LeafOnlyCounter"};
        if (op_type == "OP-4") return {"AVX512", "L3Aware", "ThreadPerCore", "MacroBatch", "PathReadCounter"};
        // ... etc.
        return {};
    }
};
```

---

## §8 Vergleichs-Workloads (Cross-Ref auf P06 Schuele)

`bart-master` (Schuele 2024) enthaelt 3 Workload-Generator-Varianten die wir analog zu OP-1 bis OP-6 mappen:
- `bart-master/workload_zipf.cpp` → OP-1 (Hot-Key Read)
- `bart-master/workload_uniform.cpp` → OP-3 (Uniform Update)
- `bart-master/workload_scan.cpp` → OP-4 (Range-Scan)

`bplustree_reordering` (P28 Kuehn 2026-05-21) hat eigene Zipf-basierte Workloads:
- `scripts/run_experiments.sh` → OP-1 (Read mit Zipf)

---

## §9 Querverweise

- Original-Spec: `docs/termine/20260508 Termin 7/Datasets_Spezifikation.txt`
- Q-Phase Master: `docs/adapters/Q_PHASE_DATASETS_F_EXTRA_PLAN.md`
- V32 Workload-Struct: `cache-engine/libs/cache_engine/builder/commands/workload.hpp`
- V32 Orchestrator: `Diplomarbeit/Code/messung_driver/v32_orchestrator.hpp`
- V32 XML-Schema: `Diplomarbeit/Code/test_data_xml/messreihe_v32_schema.xsd`
- Telemetry Achse 11 Kuehn: `07_bausteine_matrix_N_erweitert.md` §11

---

**Q.2 Akzeptanz-Kriterien erfuellt:**
- [x] OP_1_to_6_SPECIFICATIONS.md mit 6 Detail-Beschreibungen (§1-§6)
- [x] V32-Mapping auf WorkloadKind enum dokumentiert (§0 Master-Tabelle)
- [x] `<op_type>` XML-Erweiterung spezifiziert (§7)
- [x] Filter-Logik im V32Orchestrator skizziert (§7 Pseudo-Code)

**Folge-Task (V34+):** Implementierung des `OpTypeFilter` in `Code/messung_driver/op_type_filter.hpp` + Verdrahtung in V32Orchestrator.

**Ende docs/datasets/OP_1_to_6_SPECIFICATIONS.md (Q.2 DONE).**
