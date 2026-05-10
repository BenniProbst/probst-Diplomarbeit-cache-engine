# Saeule B Plattform-Modell — Konkretisierung aus 33 Papern
**Stand:** 2026-05-09 (REV 1) · Korrektur-Runde 3 ergaenzt 2026-05-10
**Quelle:** _paper_extractions/cluster_A-F.md
**Architektur-Bezug:** REV 2 Concept-Hierarchie, Saeule B (Cache-Engine-Plattform-Modell, Echtzeit-Modell)

---

## ⚠ KORREKTUR-RUNDE 3 (2026-05-10) — Plattform-Auto-Discovery statt CPU-Spezialisierung

**Bezug:** `10_korrektur_architektur_skizze_2026_05_09.md` Sektion K3.2

### Lese-Anweisung fuer dieses Dokument

Dieses Dokument enthaelt an mehreren Stellen Klassen-Bezeichnungen wie `RyzenX3DProbe`, `IntelHybridProbe`, `X3DAwareFactory`, `X3DVCachePinningHeuristic`, `IntelHybridPCoreRoutingHeuristic`. Diese Bezeichnungen sind Architektur-falsch:

**Architektur-falsch ist:** plattform-spezifische Klassen, die hard-coded fuer eine bestimmte CPU-Generation gebaut sind (z.B. fuer Ryzen 9950X3D).

**Architektur-richtig ist:** GENERELLE `IPlatformProbe` und `IPlatformPropertyClassifier`, die ALLE Cache-/CPU-Eigenschaften AUTOMATISCH entdecken + AUTOMATISCH ausmessen. Die schnellste Rekombination wird vom CacheEngineBuilder ausgewaehlt — keine plattform-spezifische Klassen-Hierarchie.

### Re-Mapping Tabelle (in Korrektur-Runde 3 anzuwenden)

| Bezeichnung in diesem Dokument (zu ersetzen) | Architektur-richtige Bezeichnung |
|----------------------------------------------|----------------------------------|
| `RyzenX3DProbe` Klasse | `IPlatformProbe` entdeckt `cache_topology.l3_per_ccd` mit verschiedenen Werten ⇒ Property `has_asymmetric_l3 = true` |
| `IntelHybridProbe` Klasse | `IPlatformProbe` entdeckt `core_layout.core_classes` mit mehreren Klassen ⇒ Property `has_hybrid_cores = true` |
| `X3DAwareFactory` | `IPlatformPropertyClassifier` liefert `preferred_pinning = LARGEST_L3_CCD` (gewaehlt durch Messung) |
| `X3DVCachePinningHeuristic` | **`LargestL3CcdPinningHeuristic`** (allgemein, nicht CPU-spezifisch) |
| `IntelHybridPCoreRoutingHeuristic` | **`HotPathOnHighIpcCoreHeuristic`** (allgemein) |
| `Block AO Production-Plattform` | bleibt als BEISPIEL-KONKRETION fuer Auto-Discovery, NICHT als Implementierung |
| `IntelHBMAllocator` / `GraceHopperHBMAllocator` | `IPlatformProbe` entdeckt `has_hbm_tier = true` ⇒ Property + generelle `HbmAllocationStrategy` |

### Auto-Discovery-Pflichten der CacheEngine

Pro Plattform-Eigenschaft, die wir beruecksichtigen wollen, muss der CacheEngineBuilder vor jedem Permutations-Build folgende Auto-Discovery-Schritte ausfuehren:

1. **Discover** (statisch): Lese aus CPUID / sysfs / /proc/cpuinfo / hwloc / cpuid-Instruction
2. **Measure** (dynamisch): Mikrobenchmark (z.B. clflush-cycle-Measurement; All-Pairs-Pinning-Vermessung; Cache-Coherence-Cost-Calibration)
3. **Classify**: Stelle aus den Messungen Properties zusammen (`has_asymmetric_l3`, `preferred_pinning`, `usable_simd_width`, ...)
4. **Publish**: Stelle die Properties allen Permutations-Modulen als Konfigurations-Optionen zur Verfuegung
5. **Bind**: Pro Permutation entscheidet die `ICacheStrategy`-Visitor-Implementierung, welche Properties sie konsumiert

Die Cache-Engine bleibt damit **plattform-agnostisch im Code, plattform-konkret im Verhalten** — exakt das Gegenteil einer plattform-spezifischen Klassen-Hierarchie.

### Was vom Block AO erhalten bleibt

Block AO (Production-Plattform Ryzen 9950X3D + i9-14900KS, 64 GB DDR5-5600 CL36) bleibt als KONKRETES BEISPIEL erhalten:
- **Was Auto-Discovery dort findet:** asymmetrisches L3 (96+32 MiB), Hybrid-Cores (8P+16E), DDR5-5600 mit 36 Zyklen
- **Welche Properties daraus resultieren:** `has_asymmetric_l3=true`, `has_hybrid_cores=true`, `cpu_core_atom_perf_separation=required`
- **Welche Permutationen davon profitieren:** alle, die `ICacheStrategy`-Visitor mit Pinning-Hint konsumieren

Damit ist Block AO ein TESTFALL fuer die Auto-Discovery, nicht eine Implementierung der Cache-Engine.

---

## 1. ICacheLevel + ICacheTopology

**Zweck:** Modelliert L1/L2/L3 + Memory-Hierarchie inkl. Geometrie und Latenzen.

**Konkretisierungen aus den Papern:**
- **P03 Masstree (Cluster B)**: 64 KB I+D L1, 512 KB L2 privat, 6 MB L3 shared per Chip; AMD Opteron 8431 8-Chip × 6 Cores (Section 6.1).
- **P05 START (Cluster A)**: i9-7900X mit 13.8 MB LLC, 60 ns LLC Miss; explizite L_L1/L_L2/L_RAM Latenzen im Cost-Modell (Sec. IV.A).
- **P11 CSS-Tree (Cluster B)**: 16k L1 1-way Sun, 16k L1 4-way Pentium — explizite Set-Associativity-Modellierung.
- **P13 Hankins/Patel (Cluster B)**: Pentium III: 16 KB L1 4-way, 512 KB L2 4-way, lsz=32, miss_latency=75 cycles, page_sz=4096; **vollstaendige Tabelle 2 als Plattform-Modell**.
- **P14 CSB+ Itanium (Cluster C)**: L1=16KB/64B, L2=256KB/128B, L3=1.5MB/128B — **Cache-Lines unterschiedlich pro Level (64B vs 128B)**.
- **P15 Graefe/Larson Survey (Cluster C)**: bis zu 5 Levels (Register, 3 Caches, Memory); typisch L1 8-32 KB, L2 128 KB-2 MB, L3 on-chip; Cacheline 16-128 B.
- **P17 Bender Cache-Oblivious (Cluster C)**: Ideal-Cache-Modell mit 2 Levels (Cache, Main Memory), Block-Size B, Capacity M, fully associative, optimal offline replacement.
- **P18 Saikkonen 2008 (Cluster C)**: Multi-Level-Modell `B_0 = node size, B_1 = L1-line-size, B_2 = TLB-page-size, ..., B_{k+1} = ∞`; jedes B_i ist Multiple von B_{i-1}.
- **P19 Saikkonen 2016 (Cluster C)**: 4 verschiedene CPUs (Athlon XP, Sempron 3000+, Atom N270, Core2 Quad) — alle mit 64B-Cacheline.
- **P20 B-Tree adaptive (Cluster D)**: AMD Ryzen 9 7950X mit `L1=32KiB, L2=1MiB, L3=32MiB`, Frequency-Boost off bei 4.5 GHz.
- **P21 Chen pB+-Tree (Cluster D)**: Compaq ES40 simuliert — 64 KB L1 D-Cache 2-way, 64 KB L1 I-Cache 2-way, 2 MB L2 direct-mapped, 64 Byte Lines; L1→L2 Miss=15 cycles, L1→Memory Miss=150 cycles.
- **P22 Chen Fractal (Cluster D)**: dieselbe Compaq ES40 Spec wie P21; multi-tier Cache+Disk mit (T1, T_next) und (Disk Seek Time, IO Throughput).
- **P25 Mahling (Cluster E)**: 7 CPU-Plattformen (EPYC-2/3, Xeon-E5/2/3, A64FX, Grace) mit konkreten lokalen/remote Latenzen (Tab. 1, 76-215 ns lokal, 130-760 ns remote).
- **P26 Zhang Index (Cluster E)**: L1 (32KB), L2 (256KB-1MB), L3 (8-28MB), DRAM (200-220 cycles); Coffee Lake (E-2224G, 4 cores) + Cascade Lake (Gold 5218R, 20 cores).
- **P27 Zhang Hierarchical (Cluster E)**: L1-I 32 KB 8-way 2 cycles 16 MSHRs, L1-D 48 KB 12-way 4 cycles 16 MSHRs, L2 512 KB 8-way 14 cycles 32 MSHRs, LLC 2 MB/core 16-way 50 cycles 64 MSHRs, Memory DDR4 2400 MHz.
- **P28 Kuehn (Cluster E)**: 2× Intel Xeon Gold 6230, 2.1 GHz, 20 Cores each; L1D 32 KB, L2 1 MB, L3 27.5 MB; TLB Level 1: 64 entries, TLB Level 2: 1536 entries; 192 GB DDR4 RAM.
- **P32 To-Stride TUD (Cluster F)**: Cascade Lake (Xeon Gold 6240R, L1D 32KiB, L2 1MiB, L3 35.75MiB, DTLB 64, STLB 1536) vs. Sapphire Rapids (Xeon Gold 9468, L1D 48KiB, L2 2MiB, L3 105MiB, DTLB 96, STLB 2048).

**Multi-Tier-Verallgemeinerung (P22 + P26 + P28 konvergieren):** `ICacheTopology` muss mindestens 3-4 Tiers (L1/L2/L3/Memory) + TLB-Levels modellieren. P14 zeigt zusaetzlich, dass `ICacheLine.size_bytes` PRO LEVEL variieren kann (64B vs 128B). P25 zeigt heterogene Memory-Backends (DDR4/HBM2/HBM3/LPDDR5X/GDDR).

---

## 2. ICacheLine

**Zweck:** Geometrie der Cache-Linie (typisch 64 Byte), Set-Associativity.

**Konkretisierungen aus den Papern:**
- **P01 ART (Cluster A)**: 16-Byte Single-Cache-Line-Header.
- **P02 HOT (Cluster A)**: 32 KB L1 / 256 KB L2 / 8 MB L3 (i7-6700) — implizit 64 B Cache-Line.
- **P03 Masstree (Cluster B)**: 64 B Cache-Line (impliziert via 256 B Knoten = 4 Cache-Lines).
- **P07 Wormhole (Cluster B)**: "8 prefixes in an array of a cache-line size (64 bytes)" — explizit.
- **P10 SuRF (Cluster A)**: 64 Byte Cache-Line; bestimmt Block-Groesse fuer LOUDS-Sparse rank-LUT (B=512 Bits = 1 Cache-Line).
- **P11 CSS-Tree (Cluster B)**: 32 Byte Sun Ultra Sparc II / 32 Byte Pentium II.
- **P12 CSB+ (Cluster B)**: 32-128 Byte Range (Section 2 "32 to 128 bytes"); experimentell auf 64 Byte gesetzt.
- **P13 Hankins/Patel (Cluster B)**: lsz=32 (Pentium III).
- **P14 CSB+ Itanium (Cluster C)**: L1=64B, L2=128B, L3=128B — **NICHT uniform pro Level**.
- **P15 Graefe/Larson Survey (Cluster C)**: 16-128 Byte typisch.
- **P21/P22 Chen (Cluster D)**: 64 Byte Lines.
- **P25 Mahling (Cluster E)**: 64B Standard, ARM A64FX 256B Ausnahme.
- **P28 Kuehn (Cluster E)**: 64B implizit.
- **P32 To-Stride TUD (Cluster F)**: 64B; Way-Associativity (8-way L1, 16-way L2, 11-15-way L3) entscheidend fuer Cache-Set-Thrashing.

**Verallgemeinerung:** `ICacheLine.size_bytes` = 64 (x86 Standard, dominant in 28/33 Papern). Ausnahmen: ARM A64FX 256B (P25), Pentium III 32B (P13), historische Sun 32B (P11), variable pro Level (P14).

---

## 3. ICacheResidency

**Zweck:** Welche Daten sind aktuell in welchem Cache-Level (Cached/HeaderCached/Uncached); LRU-Eviction-Modell.

**Konkretisierungen aus den Papern:**
- **P05 START (Cluster A)**: explizite Unterscheidung Cached/HeaderCached/Uncached pro Knoten-Lookup (Tabelle I, Sec. IV.A).
- **P13 Hankins/Patel (Cluster B)**: Cardenas-Formula `X_D(lambda, q) = lambda * (1 - (1 - 1/lambda)^q)` fuer steady-state Cache Occupancy (Eq. 9).
- **P15 Graefe/Larson Survey (Cluster C)**: LRU oder Second-Chance Replacement.
- **P25 Mahling (Cluster E)**: NTA = direct evict / KEEP = retain — als Strategy-Knob ueber Prefetch-Hints.
- **P26 Zhang Index (Cluster E)**: TLB Miss Penalty separat von Cache Miss Penalty (T_tlb=18 cycles vs T_1=200 cycles in Cost-Modell).
- **P28 Kuehn (Cluster E)**: Age-based Eviction (LRU-aehnlich, modern CPUs).
- **P28 Kuehn (Cluster E, NEU 2026-05-08)**: LeafOnlyCounter / RetroactiveAggregation als Telemetry zur Cache-Residency-Schaetzung (PRT-ART-Innovation).

**Verallgemeinerung:** `ICacheResidency` muss mindestens (Cached, HeaderCached, Uncached) modellieren. Histogram pro Knoten (P28 statisch, NEU 2026-05-08 LeafOnly).

---

## 4. ICpuCore + ICoreLayout + ICoreToThreadMap + IPinningPolicy

**Zweck:** CPU-Architektur, Core-Anzahl, NUMA-Topologie, Thread-Pinning.

**Konkretisierungen aus den Papern:**
- **P01 ART (Cluster A)**: 12 Threads (Multithreaded throughput, Sec. V.A); software pipelining mit 8 queries/thread.
- **P02 HOT (Cluster A)**: i7-6700 4-Core / i9-7900X 10-Core; Skalierung bis 10 Threads.
- **P03 Masstree (Cluster B)**: AMD Opteron 8431 8-Chip × 6 Cores = 48-Core (16 aktiv); **NUMA-Effekte explizit (Section 6.6)** — Hard-partitioned Masstree hat 1.5x Throughput auf Multi-Socket bei uniformer Last.
- **P05 START (Cluster A)**: i9-7900X 10-Core; Speculative Execution / Out-of-Order explizit (Sec. V).
- **P07 Wormhole (Cluster B)**: 16-core Intel Xeon E5-2697A v4; Hyperthreading **disabled**; "We use one NUMA node to run the experiments" — explizit NUMA-Sensitiv.
- **P08 ART OLC (Cluster F)**: Haswell EP Intel Xeon E5-2687W v3 (10 Cores, 20 Hyper-Threads, 25 MB L3); 24-Core Broadwell EP genannt.
- **P11 CSS-Tree (Cluster B)**: Sun Ultra Sparc II 296 MHz / Pentium II 333 MHz (Single-Core).
- **P12 CSB+ (Cluster B)**: Sun Ultra Sparc II / Pentium II — NICHT Multi-Core adressiert.
- **P14 CSB+ Itanium (Cluster C)**: Itanium 2 EPIC In-Order — Compiler ist Scheduler.
- **P19 Saikkonen 2016 (Cluster C)**: 4 verschiedene CPUs — alle Single-Threaded experimentell.
- **P20 B-Tree adaptive (Cluster D)**: AMD Ryzen 9 7950X — skaliert auf 24 Threads.
- **P25 Mahling Coro (Cluster E)**: 7 Plattformen; **NUMA local vs. remote-Latenz-Differenz** dramatisch (EPYC-3 local 83ns / remote 272ns; Grace local 181ns / remote 760ns); numactl/mbind fuer NUMA Pinning.
- **P28 Kuehn (Cluster E)**: 2× Xeon Gold 6230, 40 cores total; **NUMA-Limitation explizit** — Single-threaded Remapping → first-touch policy auf Linux NUMA → Bei >40 Threads: Memory auf einem NUMA-Node = costly remote access.
- **P29 RCU (Cluster F)**: Per-CPU-Quiescent-State-Tracking direkt mappable auf ICoreLayout; NUMA-Hardware (1996+) explizit als Treiber genannt; remote-vs-local-Memory-Latency-Ratio motiviert RCU.
- **P30 Hazard Pointers (Cluster F)**: Per-Thread-HP-Records; IBM RS/6000 mit 4× 375 MHz POWER3-II.
- **P31 Ungethuem TUD (Cluster F)**: App-Core (fat, control-plane) + N PEs (slim, data-plane); Tomahawk DBA mit 4 PEs (Tensilica LX5 RISC).
- **P32 To-Stride TUD (Cluster F)**: NUMA local vs. remote DRAM/HBM; numactl Pinning; explizite Multi-Socket-Tests.
- **P33 VAMPIR (Cluster F)**: Xeon Phi 7250, 36 Tiles, 2D Mesh Interconnect.

**Verallgemeinerung:** **NUMA-Awareness ist DURCHGAENGIG SCHWACH** in Cluster A/B/C/D/E (explizit nur P03, P28 Detail). P25/P32/P33 (TUD-Habich-Cluster F) liefern die NUMA-Modellierung. `IPinningPolicy` muss mindestens (Cross-Socket-cost, NUMA-node-binding, first-touch-policy) abdecken.

---

## 5. IHardwareExtension + IIsaFeatureSet

**Zweck:** ISA-Erweiterungen (SSE/AVX/BMI2/CRC32c/lfetch), Hardware-Beschleuniger, ISA-Feature-Detection.

**Konkretisierungen aus den Papern:**
- **P01 ART (Cluster A)**: SSE in Node16 (`_mm_set1_epi8` + `_mm_cmpeq_epi8` + `_mm_movemask_epi8`).
- **P02 HOT (Cluster A)**: AVX2 + BMI2 (PEXT/PDEP) — explizit benannt; Single-Mask braucht PEXT; **AVX2 als Mindest-ISA, nicht backward-kompatibel zu SSE-only**.
- **P03 Masstree (Cluster B)**: Byte-Swap-Instruktion fuer little-endian Slice-Vergleich; atomic int64 native fuer 4-Bit-Index-Permutation per 64-Bit Single-Atomic-Write.
- **P04 CoCo (Cluster A)**: GCC __int128 (128-Bit uint128_t als Plattform-Annahme).
- **P05 START (Cluster A)**: CLFLUSH / LFENCE als ISA-Features.
- **P07 Wormhole (Cluster B)**: CRC32c HW-Instruction (SSE 4.2).
- **P08 ART OLC (Cluster F)**: SIMD fuer Linear-Node-Lookups (Node4/16); HTM (Hardware Transactional Memory) als eigene Plattform-Capability.
- **P10 SuRF (Cluster A)**: CPU popcount instruction; 128-Bit SSE SIMD; `__builtin_prefetch`.
- **P12 CSB+ (Cluster B)**: GCC `Label as Values` (`Pro99`) fuer indirect jumps in `variable` Code-Variant.
- **P14 CSB+ Itanium (Cluster C)**: Itanium 2 EPIC + Software-Prefetch-Instruktion (lfetch); In-Order Scheduling — Compiler-driven.
- **P15 Graefe/Larson Survey (Cluster C)**: Software-Prefetch-Instruktionen, Write-Behind-Hints, Pre-Validation, Auto-Read-Ahead.
- **P20 B-Tree adaptive (Cluster D)**: SIMD fuer Fingerprint-Suche (AVX/SSE) und Head-Vergleich.
- **P21 Chen pB+-Tree (Cluster D)**: MIPS R10000 (super-skalar dynamisch geschedulter Pipeline), explizite `prefetch`-Instructions (gcc ASM macro), 32 Miss-Handlers Daten / 2 Instructions.
- **P22 Chen Fractal (Cluster D)**: MIPS R10000 + IBM POWER (DB2-Test), software-gesteuerte Prefetch-Instructions.
- **P23 Khan (Cluster D)**: VLIW-Itanium-II — `lfetch.nt1` (non-temporal Level-1 Prefetch), Instruction-Bundles, Predication; `lfetch`-Instruction-Family.
- **P25 Mahling Coro (Cluster E)**: T0/T1/T2/NTA (x86), KEEP/STREAM × L1/L2/L3 (ARM) — **ARM-spezifisch 6 Instructions ueber 2 Policies × 3 Targets**.
- **P26 Zhang Index (Cluster E)**: __builtin_prefetch + L3-Hint (Locality 0/1/2/3).
- **P27 Zhang Hierarchical (Cluster E)**: x86-64 / AArch64 (beide unterstuetzt durch Reserved Bits in call/return).
- **P30 Hazard Pointers (Cluster F)**: Single-word CAS oder restricted LL/SC; **64-Bit-Architektur OHNE 128-Bit-Atomics (POWER3, Alpha, MIPS, PowerPC) wird explizit unterstuetzt**.
- **P31 Ungethuem TUD (Cluster F)**: **DAS ISA-Goldstandard-Inventar**:
  - **`WAHExtension`, `PLWAHExtension`, `COMPAXExtension`** (Bitmap-Compression).
  - **`HashExtension`** (Hash+Lookup, Hash+Insert, CityHash32, Hash Sampling).
  - **`MergeSortExtension`, `IntersectionExtension`, `UnionExtension`, `DifferenceExtension`, `SortMergeJoinExtension`, `SortMergeAggregationExtension`**.
  - **`RiscBaseISA`** (Tensilica LX5: 80 base instructions).
  - **`SSEExtension`** (Intel x86, 144 SSE instructions).
  - **`AVXExtension`, `SGXExtension`** (Software Guard Extensions, security), **`THUMBExtension`** (ARM), **`NEONExtension`** (ARM SIMD).
- **P32 To-Stride TUD (Cluster F)**: AVX-512 explizit; aber strided scalar OUTPERFORMS AVX-512 simd-sequential.

**Verallgemeinerung:** `IIsaFeatureSet` als Concept-Tree mit folgender Mindest-Hierarchie:
- **Base-ISA:** RISC-Base (80 Inst.) | x86-64 (Standard) | AArch64
- **SIMD-Extensions:** SSE/SSE2/SSE3/SSE4 | AVX/AVX2/AVX-512 | NEON | A64FX-SVE
- **Bit-Manipulation:** BMI/BMI2 (PEXT/PDEP), popcount, CRC32c
- **Memory-Hints:** prefetcht{0,1,2}, prefetchnta (x86); lfetch (Itanium); KEEP/STREAM (ARM)
- **Synchronization:** atomic int64, CAS, LL/SC, HTM, MFENCE/LFENCE
- **Security:** SGX, Predication
- **Database-spezifisch (P31):** WAH/PLWAH/COMPAX, Hash+Lookup, MergeSort, Intersection/Union/Difference

---

## 6. IInterconnect + IBusTopology + IMemoryBandwidthModel

**Zweck:** Bus-/Network-on-Chip-Topologie, Cache-Coherence-Traffic, Memory-Bandbreite, NUMA-Interconnect.

**Konkretisierungen aus den Papern:**
- **P03 Masstree (Cluster B)**: DRAM-Stall-Time waechst mit Cores (2050 Cycles bei 1 Core, 2800 bei 16 Cores) — klare Bandbreitenkonstellation.
- **P05 START (Cluster A)**: Memory-Page-Management (memfd_create, mmap, virtual<->physical) — tiefer Kontakt zum OS-Memory-Management.
- **P10 SuRF (Cluster A)**: SSD-I/O via Intel 540s 480 GB SSD; OS Page Cache + RocksDB Block Cache als 2-stufige Memory-Hierarchy.
- **P13 Hankins/Patel (Cluster B)**: 600 MHz Pentium III, miss_latency=75 cycles als Bus-Latenz-Modell.
- **P15 Graefe/Larson Survey (Cluster C)**: Cache-Coherency-Cost ist explizit "particularly noticeably for heavily used, fast-changing data items (e.g., latches)... This delay occurs even if there is no contention on the lock" — Latch-Pingpong-Effekt.
- **P21 Chen pB+-Tree (Cluster D)**: Crossbar-Interconnect mit 24 outstanding Cache-Misses; `B = T1/T_next = 150/10 = 15` (normalized memory bandwidth).
- **P22 Chen Fractal (Cluster D)**: Multi-Disk SCSI (SGI Origin 200, 12 SCSI Disks Cheetah 4LP, 40 MB/s, 18 ms seek).
- **P24 Naderan-Tahan (Cluster E)**: 16-core directory-based shared L2; **LLC slices, routers, directories — alle als Energiekonsumenten markiert**.
- **P25 Mahling Coro (Cluster E)**: **CHA (Caching/Home Agent) explizit modelliert** (Fig. 2); Cross-Socket-Latenz dominant (EPYC-3 local 83ns / remote 272ns; Grace local 181ns / remote 760ns); CXL als Future-Trend genannt.
- **P26 Zhang Index (Cluster E)**: DRAM-Latenz 200-220 cycles als Konstante.
- **P27 Zhang Hierarchical (Cluster E)**: DDR4 2400 MHz konkrete Memory-Spezifikation; FTQ (Fetch Target Queue, 24 entries default).
- **P29 RCU (Cluster F)**: NUMA-Hardware (1996+) explizit als Treiber; remote-vs-local-Memory-Latency-Ratio steigt mit Moore's Law.
- **P31 Ungethuem TUD (Cluster F)**: **DAS Bus-Topologie-Goldstandard**:
  - **`NetworkOnChip` (NoC)** zwischen PEs.
  - **`QPI`, `InfiniBand`, `OmniPath`, `NUMAlink5`, `AXI/AHB`** (Section 1).
  - **DDR2 Timing-Constraints (Tab. 1):** tRCD=15ns, tRP=15ns, tCL=15ns, tRAS=40ns; Bank/Row/Column-Index-Modell; Burst Length 4/8.
- **P32 To-Stride TUD (Cluster F)**: **Hardware-Prefetcher-Stream-Limit**: Cascade Lake bis zu 32 concurrent streams; Sapphire Rapids bis zu 72 streams; **DTLB/STLB-Capacity** (Cascade DTLB 64 + STLB 1536; Sapphire DTLB 96 + STLB 2048); Cache-Associativity-Pathologien (Multiples of 8/16/24 verursachen Cache-Set-Thrashing); **Heterogene Memory** (DDR4/DDR5/HBM2/HBM3/LPDDR5X).
- **P33 VAMPIR (Cluster F)**: Xeon Phi 36-Tile 2D-Mesh, EDC, MCDRAM-Anbindung; **NFP-Modellierung** (latency, throughput, transience/persistence, reliability, wearout, random accessibility, cache coherence).

**Verallgemeinerung:** `IInterconnect` muss mindestens 4 Sub-Klassen modellieren:
- **OnChipInterconnect:** NoC, Crossbar, Mesh, Ring
- **InterSocket:** QPI, UPI, Infinity Fabric
- **NetworkRDMA:** InfiniBand, OmniPath, NUMAlink5
- **HostToDevice:** PCIe, NVLink-C2C (Grace+Hopper), CXL

`IMemoryBandwidthModel` muss mindestens modellieren:
- **DRAM:** DDR4/DDR5 mit tRCD/tRP/tCL/tRAS
- **HBM:** HBM2/HBM3 mit Bandbreite-Charakteristik
- **LPDDR:** LPDDR5X (Mobile/Embedded)
- **NVRAM:** Optane, persistent NVDIMM
- **Bank/Row/Column-Parallelism** (P32 OFFEN — Refs [6, 13, 22] zur Integration)

---

## 7. ILivePlatformModel + ILiveCpuModel

**Zweck:** Runtime-akquiriertes Plattform-Modell ueber Hardware-Performance-Counter; Compensation/Migration; DVFS.

**Konkretisierungen aus den Papern:**
- **P05 START (Cluster A)**: **DAS Vorbild-Paper fuer ILivePlatformModel** — das Cost-Modell IST eine Live-Messung; CLFLUSH/LFENCE-basierte Probing direkt auf Target-Machine; "we point out that this cost model is workload-agnostic" + Hook fuer IWorkloadModel.
- **P03 Masstree (Cluster B)**: Linear vs Binary Search ist architektur-dependent (Intel: linear schneller, AMD: gleich) — Hinweis auf `IHeuristic` mit Plattform-Sensorik.
- **P11 CSS-Tree (Cluster B)**: Cache Simulator zur Validierung (Section 6 "+ifdef SIMULATOR").
- **P12 CSB+ (Cluster B)**: Cache misses durch `perfmon` direkt gemessen (Section 5 "perfmon Tool").
- **P13 Hankins/Patel (Cluster B)**: Cardenas-Formula als steady-state-Modell; PAPI library zum Counter-Auslesen (Section 4.2).
- **P14 CSB+ Itanium (Cluster C)**: ConfigurationTable als Lookup-IHeuristic, befuellt durch Konfigurations-Experiment.
- **P19 Saikkonen 2016 (Cluster C)**: keine Real-Time-Measurement, aber TPC-C Benchmark mit instrumentiertem MySQL/InnoDB.
- **P20 B-Tree adaptive (Cluster D)**: KeyAdaption + OperationAdaption als Live-Counter-driven Layout-Wahl.
- **P23 Khan (Cluster D)**: **DAS Vorbild-Paper fuer ILiveCpuModel + Runtime-Adaption**:
  - `getCurrentLatency()` → cycles (live measurement)
  - `computeOptimalDistance(L_miss, L_iter) → distance` (Khan Equation 6)
  - Performance-Counter fuer Iteration-Latency-Messung (Cycle-genau)
  - Bitwise Instruction Modification zur Laufzeit (Itanium-II spezifisch)
- **P25 Mahling Coro (Cluster E)**: **L1D_PEND_MISS.FB_FULL Performance Counter** (Xeon-3) als RUNTIME-TELEMETRY; THP (madvise), NUMA mbind System Calls — Live-Konfiguration.
- **P26 Zhang Index (Cluster E)**: DRAM-Latenz 200-220 cycles als Konstante.
- **P27 Zhang Hierarchical (Cluster E)**: gem5 Simulation fuer Architekturforschung; **Avg Jaccard Index pro Bundle (0.81-0.97)** als Live-Telemetry-Metrik.
- **P28 Kuehn (Cluster E)**: Linux 20.04, perf, Intel VTune fuer Telemetry.
- **P29 RCU (Cluster F)**: `wait_for_rcu()` (Figure 18) nutzt SCHED_FIFO-Policy + cpus_allowed-Mask, force-Schedule auf jede CPU.
- **P32 To-Stride TUD (Cluster F)**: **DAS Vorbild-Paper fuer Live-Probing**:
  - DTLB/STLB-Capacity zur Laufzeit messen
  - Hardware-Prefetcher-Stream-Limit zur Laufzeit messen
  - Cache-Associativity-Disalignment automatisch
  - **PER-GENERATION-Modell** noetig (Cascade Lake vs Sapphire Rapids differieren stark)
- **P33 VAMPIR (Cluster F)**: V-malloc als Virtualisierungs-Layer ueber NVRAM/DRAM/HBM; Compensation/Migration als ILivePlatformModel.

**Verallgemeinerung:** `ILivePlatformModel` muss folgende Live-Properties verfuegbar machen:
- `measured_miss_latency(level)` — pro ICacheLevel (P05, P21, P23)
- `dtlb_capacity, stlb_capacity` — Live-Probing (P32, P28)
- `prefetcher_stream_limit` — pro Generation (P32)
- `cache_associativity` — pro Level (P32, P11, P13)
- `cache_coherency_pressure` — als Funktion(numCores, sharedCounters) (P25, P28-Mail)
- `fb_size` (Fill Buffer) — pro Plattform (P25)
- `numa_topology` — local/remote latencies (P25, P28, P32)
- `current_cycle()` — Cycle-Counter-Read (P23)
- `loop_iteration_cycles(loopId)` — Per-Loop-Profiling (P23)

`ILiveCpuModel` als Sub-Concept fuer CPU-spezifische Live-Properties:
- DVFS-State (Frequency-Scaling am Core Manager, P31)
- Instructions-per-Cycle (IPC)
- Branch-Mispredict-Rate
- Speculative-Execution-Effectiveness

---

## 8. IScheduler-Strategien (Konkrete Implementierungen)

**Zweck:** Task-Scheduling, Thread-Allocation, Concurrency-Mechanik-Auswahl, Background-Worker.

**Konkretisierungen aus den Papern:**
- **P01 ART (Cluster A)**: Software pipelining mit 8 queries/thread (Sec. V.A) — impliziert IScheduler.
- **P03 Masstree (Cluster B)**: Hand-over-Hand Optimistic Locking; Per-Core Log-File, Background-Checkpointing.
- **P05 START (Cluster A)**: **`OfflineSelfTuningStrategy`** (`ISearchPagesStrategyPattern`) — periodisches Re-Tuning, einmalige Offline-Phase, amortisiert ueber Zeit (z.B. wenn >10% Daten geaendert oder bei VACUUM).
- **P06 B^2-Tree (Cluster B)**: Optimistic Lock Coupling (OLC) — Reader validieren, dass Pointer innerhalb der Page-Boundary sind.
- **P07 Wormhole (Cluster B)**: 3-Klassen Scheduling — Klasse 1 (Lookup) nur RCU, Klasse 2 (single-leaf insert/del) RW-Lock, Klasse 3 (split/merge) MutEx.
- **P08 ART OLC (Cluster F)**: OLC + ROWEX als 2 alternative Scheduling-Mechaniken; Forward-Progress-Garantie via Restart-Limit + Fallback auf Write-Locks.
- **P15 Graefe/Larson Survey (Cluster C)**: **MicroServerThreadingStrategy** (Sektion 7) — Statt Connection-pro-Thread Task-orientierte Micro-Server, jeder bedient ein bestimmtes Modul; "Micro servers might be allocated to specific CPUs in a multi-processor system" → Verbindung zu IPinningPolicy + ICoreToThreadMap.
- **P17 Bender Cache-Oblivious (Cluster C)**: PackedMemoryArray's Rebalance-Cost ist amortisiert → IScheduler kann Rebalance-Operationen *batchen* oder zu off-peak-Zeiten verschieben.
- **P19 Saikkonen 2016 (Cluster C)**: Periodic Global Relocation — Composite-Strategie (Local + periodische Global-Relocation).
- **P26 Zhang Index (Cluster E)**: Worker Thread baut Index auf Read Counters — async Konsistenz-Modell.
- **P29 RCU McKenney (Cluster F)**: `wait_for_rcu()` (Figure 18) — SCHED_FIFO + cpus_allowed-Mask; Force-Schedule auf jede CPU.
- **P30 Hazard Pointers (Cluster F)**: HelpScan als Failure-Tolerance-Strategie; benoetigt KEINEN Scheduler-Support → Userspace-tauglich (Differenz zu RCU!).
- **P31 Ungethuem TUD (Cluster F)**: **Core Manager (CM)** — Task-Scheduling, PE-Allocation, Datentransfers, Frequency-Scaling.
- **P33 VAMPIR (Cluster F)**: Multi-Query-Pipeline-Scheduler mit Compile-Time-Negotiation; Phase 1 Single-Query Pipeline + Phase 2 Multi-Query Pipeline.

**Verallgemeinerung:** `IScheduler` mit folgenden Sub-Strategien:
- **OfflineSelfTuningScheduler** (P05 START — VACUUM-Trigger, Threshold-basiert)
- **PeriodicGlobalRelocationScheduler** (P19 Saikkonen — nach N Updates)
- **MicroServerScheduler** (P15 — Task-Layout-Bindung)
- **WorkerThreadScheduler** (P26 — async Index-Build)
- **CoreManagerScheduler** (P31 Tomahawk — Frequency-Scaling, PE-Allocation)
- **MultiQueryPipelineScheduler** (P33 VAMPIR — Compile-Time-Negotiation)
- **OptimisticLockingScheduler** (P03/P06/P08 — OLC)
- **RcuScheduler** (P29 — Grace-Period-basiert, Scheduler-abhaengig)
- **HazardPointerScheduler** (P30 — wait-free, kein Scheduler-Support)
- **HtmScheduler** (P08 — Hardware Transactional Memory mit Fallback)

---

## 9. IHeuristic-Familie (alle aus den Papern abgeleiteten Heuristiken)

**Zweck:** Datenabhaengige + plattformabhaengige Cost-Funktionen + Decision-Logik fuer Strategy-Wahl.

**Aus den Papern abgeleitete Heuristiken:**

### 9.1 Layout-Selection-Heuristiken
- **`AdaptiveLayoutSelectionHeuristic`** (P01 ART) — Wahl Node4/16/48/256 nach Population
- **`HeightConstrainedPartitioningHeuristic`** (P02 HOT) — minimiere expected lookup depth
- **`DataAwareCollapsingHeuristic`** (P04 CoCo) — DP-Optimierung pro Knoten ueber Encoding-Pool
- **`CacheCostBasedNodePlacementHeuristic`** (P05 START) — datengetrieben + plattformgetrieben
- **`BellmanDPNodeOptimizer`** (P05 START) — DP zur Optimal-Placement-Berechnung
- **`RecursiveCommonPrefixDecompositionHeuristic`** (P06 B^2-Tree) — Decision/Span-Node-Wahl
- **`MinimumDistinguishingPrefixHeuristic`** (P07 Wormhole) — Anchor-Length Minimization
- **`SmartSplitHeuristic`** (P07 Wormhole) — intelligenter Split-Punkt im Leaf
- **`SplitPointSelectionHeuristic`** (P07 Wormhole) — Anchor-Laenge minimieren
- **`MatchCacheLineSizeHeuristic`** (P11 CSS-Tree) — Knoten = 1 Cache-Line
- **`BranchFactorSelectionHeuristic`** (P12 CSB+) — m = (cache_line - sizeof(firstChild) - sizeof(nKeys))/sizeof(key)
- **`SegmentationPolicyHeuristic`** (P12 CSB+) — Anzahl Segmente = function(workload, space_budget)
- **`HardcodedSearchVariantHeuristic`** (P12 CSB+) — basic/uniform/variable
- **`ConfigurationLookupHeuristic`** (P14) — (KeySize, NodeSize, SearchStrategy) → optimaler Konfiguration
- **`ProbabilityWeightedRootBlockHeuristic`** (P16 Bender) — Greedy mit (B-1)/B optimal
- **`OptimalAllocationHeuristic`** (P19 Saikkonen) — neuer Knoten in Parent-Cache-Block
- **`AlphaTuningHeuristic`** (P19 Saikkonen) — α aus Workload (Insert/Search-Ratio)
- **`HeadQualityHeuristic`** (P20 B-Tree adaptive) — String-vs-Integer-Detektion (Schwellwert 16/64)
- **`KeyTypeHeuristic`** (P20 B-Tree adaptive) — Layout-Type-Selection
- **`BoundaryNodeHeuristic`** (P20 B-Tree adaptive) — Sequential-Insert-Detection

### 9.2 Cost-Modell-Heuristiken
- **`CacheCostDPHeuristic`** (P05 START — auch genannt CacheCostBasedNodePlacement)
- **`OptimalNodeSizeHeuristic`** (P13 Hankins/Patel) — `cost = I*cpi + M*miss_latency + B*pred_penalty + T*tlb_penalty`
- **`TLBAwareSizingHeuristic`** (P13 Hankins/Patel) — TLB-Miss-Penalty in Sizing einbeziehen
- **`BranchPredictionAwareHeuristic`** (P13) — Branch-Mispredict-Cost in intra-node-Search-Wahl
- **`CardenasFormulaHeuristic`** (P13 Hankins/Patel) — Cache-Hit-Rate-Schaetzung
- **`OptimalNodeWidthHeuristic`** (P21 Chen) — w_optimal aus B = T1/T_next
- **`OptimalPrefetchDistanceHeuristic`** (P21 Chen) — k_optimal aus B und w
- **`OptimalChunkSizeHeuristic`** (P21 Chen) — c = ceil(B/(2m))
- **`OptimalWidthMultiTierHeuristic`** (P22 Chen Fractal) — pro Tier separat
- **`OverflowVsOffloadHeuristic`** (P22 Chen Fractal) — Aggressive-Placement-Decision
- **`DiskFirstVsCacheFirstHeuristic`** (P22 Chen Fractal) — Architektur-Wahl
- **`ConflictMissPredictionHeuristic`** (P18 Saikkonen) — SetAssociativity, BlockHierarchy → erwartete Konflikt-Miss-Rate

### 9.3 Adaptive Prefetch-Distance-Heuristiken
- **`AdaptivePrefetchDistanceHeuristic`** (P23 Khan) — Khan Equation 6, O_r = AvgMissLat / AvgIterLat
- **`RuntimeOffsetAdaptationHeuristic`** (P23 Khan) — affine Formel I = O*A + B
- **`CostBenefitGatedHeuristic`** (P23 Khan) — Equation 4
- **`AffineDistanceHeuristic`** (P23 Khan) — generisches affines Modell
- **`TemplateSpecializerHeuristic`** (P23 Khan) — p_instructions, modify_locations
- **`StrideVsSequentialHeuristic`** (P32 TUD) — strided > simd-sequential bei AVX-512 + grossem TLB
- **`PartitionCountHeuristic`** (P32 TUD) — optimal partition count = 30-42 (Sapphire Rapids)
- **`PaddingStrategyHeuristic`** (P32 TUD) — 576-Byte-Padding zwischen Partitions

### 9.4 Workload-Detection-Heuristiken
- **`SequentialInsertOptimizationHeuristic`** (P03 Masstree) — bei sequenziellem Insert kein Split
- **`LayerCreationDecisionHeuristic`** (P03 Masstree) — neuer Layer wenn Praefix > 8h Bytes
- **`WorkloadDetectionHeuristic`** (P20 B-Tree adaptive) — KeyAdaption + OperationAdaption Counter
- **`ScanFrequencyCounterHeuristic`** (P20 B-Tree adaptive) — saturating counter [0,3]
- **`SkewedDistributionDetectionHeuristic`** (P26 Zhang Index) — Zipfian theta-Detektion
- **`SlidingWindowDriftDetectionHeuristic`** (P28 Future Work) — Drift, trigger Re-Layouting

### 9.5 Cache-Coherence-Heuristiken
- **`CacheCoherenceCostHeuristic`** (P28 Kuehn Block AN) — basiert auf P28 PerNodeHistogram + Cache-Coherence-Falle
- **`OverpredictionGateHeuristic`** (P24 Naderan-Tahan) — wenn (overprediction/coverage > threshold) → Prefetch deaktivieren
- **`NegativPredictionDetectionHeuristic`** (P24) — erkennt wenn Prefetch SCHADET (negative Coverage)
- **`PrefetchReliabilityHeuristic`** (P25 Mahling) — FB_FULL Counter pro Knoten
- **`FBSizeAwareLimitingHeuristic`** (P25 Mahling) — Prefetches ≤ FB-Size
- **`AccessProbabilitySortedPrefetchHeuristic`** (P25) — bei WEAK Reliability nach Zugriffswahrscheinlichkeit sortieren

### 9.6 Telemetry-getriebene Heuristiken
- **`PathReadCounterHeuristic`** (P26 Zhang Index) — per-Block Counter, separater Storage
- **`MonitorClusteringHeuristic`** (P26 Zhang Index) — 2-Stage Algorithm mit Forgetting-Factor w
- **`JaccardSimilarityTelemetryHeuristic`** (P27 Zhang Hierarchical) — Per-Bundle Avg Jaccard Index
- **`StaticVsDynamicFootprintRatioHeuristic`** (P27) — Bundle-Speedup correlations to ratio
- **`HotPathExtractionHeuristic`** (P28 Kuehn) — greedy highest-prob → highest-prob Child
- **`PerNodeHistogramHeuristic`** (P28 Kuehn) — Counter pro Comparison Key, normalisiert
- **`LeafOnlyCounterHeuristic`** (P28 Kuehn-Mail 2026-05-08, NEU) — Counter NUR auf Leaf-Pages, keine Root-Coherence-Storm
- **`LeafOnlySampledCounterHeuristic<N>`** (P28 Kuehn-Mail 2026-05-08, NEU) — Sampling 1/N
- **`RetroactiveAggregationHeuristic`** (P28 Kuehn-Mail 2026-05-08, NEU) — periodisch Counter-Stand zur Root propagieren

### 9.7 Layout-Auswahl-Heuristiken (Kompatibilitaet, Komposition)
- **`LinearSearchPreferredHeuristic`** (P14 + P28) — Itanium 2 EPIC, kleine Knoten <384 B
- **`BinarySearchPreferredHeuristic`** (P14 + Standard)
- **`InterpolationSearchPreferredHeuristic`** (P15 — uniforme Verteilung)
- **`PoorMansKeyAcceleratedHeuristic`** (P15) — variable-length Keys
- **`StrategyCompatibilityMatrixHeuristic`** (P15) — gewaehlte Strategie-Kombinationen → Compatibility-Score
- **`PointQueryOptimizedHeuristic`** vs. **`ScanOptimizedHeuristic`** vs. **`InsertOptimizedHeuristic`** (P14 + P19)
- **`MixedWorkloadHeuristic`** (P14 — Workload-Mix-aware)
- **`LayoutDegradationHeuristic`** (P19 Saikkonen) — # Updates seit letztem Global-Relocation → Trigger
- **`WidthCostModelHeuristic`** (P13 Hankins) — vollstaendige Cost-Modellierung als IHeuristic
- **`ProbabilityLayoutHeuristic`** (P16 Bender) — Greedy-Algorithmus auf P_v_l-Distribution

### 9.8 Hardware-Probing-Heuristiken
- **`PlatformProbeHeuristic`** (P05 + P13 + P32) — CLFLUSH-Probing, perfmon, PAPI, VTune
- **`OnlinePerformanceCounterReaderHeuristic`** (P23 + P25) — Live-Counter
- **`DynamicSpecializerHeuristic`** (P23 Khan) — 3-Phasen-Pipeline (CompileTime + RuntimeSpecialization + OnlineDistanceAdaptation)
- **`BundleThresholdHeuristic`** (P27 Zhang Hierarchical) — 200 KB default

**Konsolidierte IHeuristic-Familie-Hierarchie (REV 3 Vorschlag):**
```
IHeuristic
├── ILayoutSelectionHeuristic
│   ├── AdaptiveLayoutSelectionHeuristic (P01)
│   ├── HeightConstrainedPartitioning (P02)
│   ├── DataAwareCollapsing (P04)
│   ├── CacheCostBasedNodePlacement (P05)
│   ├── BellmanDPNodeOptimizer (P05)
│   ├── RecursiveCommonPrefixDecomposition (P06)
│   ├── MinimumDistinguishingPrefix (P07)
│   ├── MatchCacheLineSize (P11)
│   ├── BranchFactorSelection (P12)
│   ├── SegmentationPolicy (P12)
│   ├── HardcodedSearchVariant (P12)
│   ├── ConfigurationLookup (P14)
│   ├── ProbabilityWeightedRootBlock (P16)
│   ├── OptimalAllocation (P19)
│   ├── AlphaTuning (P19)
│   ├── HeadQuality (P20)
│   ├── KeyType (P20)
│   └── BoundaryNode (P20)
├── ICostModelHeuristic
│   ├── CacheCostDPHeuristic (P05)
│   ├── OptimalNodeSize (P13)
│   ├── TLBAwareSizing (P13)
│   ├── BranchPredictionAware (P13)
│   ├── CardenasFormula (P13)
│   ├── OptimalNodeWidth (P21)
│   ├── OptimalPrefetchDistance (P21)
│   ├── OptimalChunkSize (P21)
│   ├── OptimalWidthMultiTier (P22)
│   ├── OverflowVsOffload (P22)
│   ├── DiskFirstVsCacheFirst (P22)
│   ├── ConflictMissPrediction (P18)
│   └── WidthCostModel (P13)
├── IRuntimeAdaptationHeuristic
│   ├── AdaptivePrefetchDistance (P23)
│   ├── RuntimeOffsetAdaptation (P23)
│   ├── CostBenefitGated (P23)
│   ├── AffineDistance (P23)
│   ├── TemplateSpecializer (P23)
│   ├── StrideVsSequential (P32)
│   ├── PartitionCount (P32)
│   └── PaddingStrategy (P32)
├── IWorkloadDetectionHeuristic
│   ├── SequentialInsertOptimization (P03)
│   ├── LayerCreationDecision (P03)
│   ├── WorkloadDetection (P20)
│   ├── ScanFrequencyCounter (P20)
│   ├── SkewedDistributionDetection (P26)
│   └── SlidingWindowDriftDetection (P28 Future)
├── ICoherencePressureHeuristic
│   ├── CacheCoherenceCost (P28 Block AN)
│   ├── OverpredictionGate (P24)
│   ├── NegativPredictionDetection (P24)
│   ├── PrefetchReliability (P25)
│   ├── FBSizeAwareLimiting (P25)
│   └── AccessProbabilitySortedPrefetch (P25)
├── ITelemetryDrivenHeuristic
│   ├── PathReadCounter (P26)
│   ├── MonitorClustering (P26)
│   ├── JaccardSimilarityTelemetry (P27)
│   ├── StaticVsDynamicFootprintRatio (P27)
│   ├── HotPathExtraction (P28)
│   ├── PerNodeHistogram (P28)
│   ├── LeafOnlyCounter (P28-Mail NEU)
│   ├── LeafOnlySampledCounter<N> (P28-Mail NEU)
│   └── RetroactiveAggregation (P28-Mail NEU)
├── ISearchStrategySelectionHeuristic
│   ├── LinearSearchPreferred (P14, P28)
│   ├── BinarySearchPreferred (P14)
│   ├── InterpolationSearchPreferred (P15)
│   └── PoorMansKeyAccelerated (P15)
├── IWorkloadMixHeuristic
│   ├── PointQueryOptimized (P14, P19)
│   ├── ScanOptimized (P14, P19)
│   ├── InsertOptimized (P14, P19)
│   ├── MixedWorkload (P14)
│   ├── StrategyCompatibilityMatrix (P15)
│   └── LayoutDegradation (P19)
└── IPlatformProbingHeuristic
    ├── PlatformProbe (P05, P13, P32)
    ├── OnlinePerformanceCounterReader (P23, P25)
    ├── DynamicSpecializer (P23)
    └── BundleThreshold (P27)
```

---

## 10. Block AO Production-Plattform-Konkretisierung

**Zweck:** Konkrete Hardware-Spezifikation der Production-Plattform fuer Block AO (Ryzen 9 9950X3D + i9-14900KS + DDR5-5600 CL36).

**Hinweis:** Die 33 gelesenen Paper enthalten KEINE direkte Modellierung der Block-AO-Production-Plattform (Ryzen 9 9950X3D, i9-14900KS). Aus den Papern lassen sich aber **uebertragbare Konstanten und Heuristiken** ableiten, die fuer die Production-Plattform parametrisiert werden muessen:

### 10.1 Ryzen 9 9950X3D (mit 3D V-Cache)
**Aus Cluster-Erkenntnissen abgeleitete Modellierung:**
- **ICacheLine.size_bytes = 64** (Standard x86-64, alle 33 Paper konvergieren ausser P25 ARM A64FX)
- **ICacheLevel:**
  - L1D: 32-48 KiB pro Core (Zen 5 Trend, P20 zeigt 32 KiB L1 fuer Ryzen 7950X)
  - L2: 1 MiB pro Core (P20: AMD Ryzen 9 7950X mit L2=1MiB)
  - **L3 mit 3D V-Cache: ~128 MiB total** (3D V-Cache erweitert dramatisch ueber Standard-L3)
- **IIsaFeatureSet:** AVX-512 (Zen 5 voll unterstuetzt), AVX2, BMI2 (PEXT/PDEP), CRC32c, popcount, T0/T1/T2/NTA Prefetch-Hints
- **ICoreLayout:** 16 Cores / 32 Threads (8 + 8 Cluster-Layout)
- **IPinningPolicy:** Cluster-aware (innerhalb des CCX bleiben fuer L3-Lokalitaet)
- **IInterconnect:** Infinity Fabric (Cross-CCX-Latenz ~80ns lokal, ~200ns Cross-Socket)
- **IMemoryBandwidthModel:** DDR5-5600 CL36 (76.8 GB/s pro Channel)
- **`CacheCoherencePressure`** kritisch bei PerNodeCounter (P28-Mail Erkenntnis): LeafOnlyCounter mandatory
- **Heuristiken-Anwendung:**
  - `OptimalNodeSizeHeuristic` (P13): bei 64B Cache-Line + AVX-512 → 256-512B Knoten (P13 Empfehlung)
  - `StrideVsSequentialHeuristic` (P32): Sapphire-Rapids-Insights uebertragbar (Ryzen 9950X3D auch grosse TLB)
  - `PrefetchReliabilityHeuristic` (P25): AMD = WEAK Reliability → Half-Node-Prefetch bevorzugt
  - `FBSizeAwareLimitingHeuristic` (P25): EPYC-3 hat FB-Size 24 → Ryzen 9 9950X3D wahrscheinlich aehnlich

### 10.2 i9-14900KS (Raptor Lake Refresh)
**Aus Cluster-Erkenntnissen abgeleitete Modellierung:**
- **ICacheLine.size_bytes = 64** (x86-64 Standard)
- **ICacheLevel:**
  - L1D: 48 KiB P-Core, 32 KiB E-Core (Hybrid-Architektur)
  - L2: 2 MiB P-Core, 4 MiB shared per E-Core-Cluster
  - L3: 36 MiB shared
- **IIsaFeatureSet:** AVX2, BMI2 (PEXT/PDEP), CRC32c, popcount, T0/T1/T2/NTA — **AVX-512 disabled** (Intel Hybrid-Constraint!)
- **ICoreLayout:** 8 P-Cores + 16 E-Cores = 32 Threads (heterogen!)
- **IPinningPolicy:** P-Core vs E-Core Trennung kritisch — IntelThreadDirector-Hint nutzen
- **IInterconnect:** Ring Bus, 12 Cores per Ring-Stop
- **IMemoryBandwidthModel:** DDR5-5600 CL36 (76.8 GB/s pro Channel)
- **PrefetcherStreamLimit:** Sapphire-Rapids-aehnlich (~72 streams pro Core, P32 Kennzahl)
- **STLB-Capacity:** 2048 entries (P32 Sapphire Rapids gleicher Trend)
- **`PrefetchReliabilityHeuristic`** (P25): Intel = STRONG Reliability → grosse Knoten KAPUTT (P25 Hauptbefund: STRONG + 8KB Nodes → Slowdown 0.4-1x!)
- **HEURISTIK-WARNUNG (P25):** Auf i9-14900KS muessen kleine Knoten (<1 KiB) bevorzugt werden, sonst Performance-Degradation

### 10.3 DDR5-5600 CL36 (gemeinsam beide Plattformen)
- **Bandwidth:** 76.8 GB/s pro Channel (Dual-Channel = 153.6 GB/s)
- **Latenz:** CL36 @ 5600 MHz = ~12.86 ns CAS-Latency
- **DRAM-Latenz Total:** ~150-220 cycles (in Linie mit P26 Zhang Index 200-220 cycles)
- **`IMemoryBandwidthModel`-Konstanten:**
  - `T1` (Memory-Miss-Latency): ~150 cycles (P21/P22 Compaq ES40 Wert direkt uebertragbar)
  - `T_next` (pipelined Miss): ~10 cycles (P21/P22 Wert direkt uebertragbar)
  - `B = T1/T_next = 15` (P21 normalized memory bandwidth)
  - `w_optimal = 8` (P21 Empfehlung mit B=15, m=8)
- **Bank/Row/Column-Parallelism:** Aus P31 Tomahawk-Modell uebertragbar (DDR2 Timing-Constraints, jetzt aber DDR5):
  - tRCD ~13.75ns
  - tRP ~13.75ns
  - tCL ~12.86ns
  - tRAS ~32ns
- **NUMA:** Single-Socket (kein Cross-Socket-Effekt, aber CCX-internal lokal vs CCX-external im Ryzen)

### 10.4 Plattform-Switch-Heuristiken Block AO
**Aus den Papern abgeleitete Production-Plattform-Heuristiken:**

1. **`PlatformDispatchHeuristic`** (NEU, abgeleitet aus P14 ConfigurationTable + P25 Reliability-Awareness):
   - **WENN Plattform = Ryzen 9 9950X3D (AMD WEAK Reliability):**
     - PrefetchReliability = WEAK
     - Bevorzuge `Coro Half Node`-Strategie (P25 Empfehlung)
     - Bevorzuge mittlere Knoten-Groessen 256-1024 B (P13 Optimal)
     - Aktiviere `LeafOnlyCounter` (P28-Mail) — Cross-CCX-Coherence-Pressure!
   - **WENN Plattform = i9-14900KS (Intel STRONG Reliability):**
     - PrefetchReliability = STRONG
     - Bevorzuge `Comparison`-Layout (P20 Default), keine grossen Knoten >1 KiB (P25 Slowdown-Risiko!)
     - Bevorzuge kleine Knoten 64-256 B
     - Aktiviere `IntelThreadDirector`-Hints fuer P/E-Core Pinning

2. **`AvxFeatureGateHeuristic`** (abgeleitet aus P02 HOT BMI2-Annahme + P32 AVX-512):
   - **Ryzen 9 9950X3D:** AVX-512 verfuegbar → SimdAccelerated Lookup mit AVX-512
   - **i9-14900KS:** **NUR AVX2 verfuegbar (AVX-512 disabled in Hybrid-CPU!)** → SimdAccelerated Lookup mit AVX2 + PEXT/PDEP
   - Compile-Time Detection via `__AVX512F__` Macro

3. **`Ddr5BandwidthHeuristic`** (NEU, aus P32 Multi-Tier-Stride):
   - DDR5-5600 CL36 Dual-Channel → 153.6 GB/s aggregierte Bandwidth
   - Fuer AggSum-aehnliche Operationen: scalar-strided mit Partition-Count 30-42 (P32 Sapphire Rapids Wert direkt uebertragbar)
   - Stride-Size NICHT power-of-2 (P32 Empfehlung)

4. **`HotPathLayoutHeuristic`** (P28 Kuehn — nur fuer Read-Heavy Workloads):
   - Bei Read-Heavy: HLS (Hot Path + Linear Search + Sort) — 21-26% Speedup ueber Native (P28)
   - Bei Mixed Workload: HotPath nicht aktivieren (Insert-Performance unter HotPath ist nicht in P28 evaluiert)
   - Layout-Refresh per `RetroactiveAggregation` (P28-Mail) periodisch (alle N Queries)

5. **`PathReadCounterPlacementHeuristic`** (P26 + P28-Mail):
   - Counter NICHT inline in Block (P26 Erkenntnis: Cascade Updates) → separater Counter-Block (Search Block Table)
   - Bevorzuge LeafOnly-Variante (P28-Mail) zur Coherence-Pressure-Reduktion
   - Async Worker-Thread fuer Counter-Index-Build (P26 Pattern)

### 10.5 OFFENE Punkte fuer Block-AO-Production-Plattform

- **OFFEN:** Konkrete Cache-Coherence-Pressure-Quantifizierung fuer 3D V-Cache (Ryzen 9 9950X3D) — keines der 33 Paper modelliert 3D-stacked Cache.
- **OFFEN:** P/E-Core-Heterogenitaet i9-14900KS — keines der 33 Paper modelliert Hybrid-Architecture, IntelThreadDirector-Integration ist Eigenleistung.
- **OFFEN:** Bandwidth-Aware Layout fuer DDR5-5600 — Multi-Channel-Modell und Refresh-Cycle-Effekte sind in P31 (Tomahawk DDR2) und P32 (DDR4/5) implizit, aber nicht voll formalisiert.
- **OFFEN:** Live-Probing der Plattform-Konstanten via CPUID + `__cpu_indicator_init` — kein Paper liefert direkt anwendbares Code-Template.
- **OFFEN:** Cross-CCX-Coherence-Latenz auf Ryzen 9 9950X3D ist nicht in den 33 Papern modelliert (P25 modelliert EPYC-Cross-Socket, aber nicht 9950X3D Cross-CCX).

---

## ZUSAMMENFASSUNG: Saeule-B-Concept-Inventar nach Paperfrequenz

| Saeule-B-Concept | Anzahl Paper-Erwaehnungen | Konkretisierungs-Tiefe |
|------------------|---------------------------|------------------------|
| `ICacheLevel` | 28/33 | sehr hoch (alle mit konkreten KB/MB-Werten) |
| `ICacheLine` | 24/33 | hoch (64B-Standard, einige Ausnahmen) |
| `IIsaFeatureSet` | 22/33 | sehr hoch (P31 als Goldstandard) |
| `ICpuCore` | 20/33 | hoch (alle mit Modell-Bezeichnung) |
| `IInterconnect` | 18/33 | mittel (P25 + P31 + P33 als Leitpaper) |
| `IMemoryBandwidthModel` | 17/33 | hoch (P21/P22/P31 als Leitpaper, B = T1/T_next) |
| `IHardwareExtension` | 14/33 | hoch (P31 mit DBA-ISA-Inventar) |
| `IPinningPolicy` | 12/33 | mittel (NUMA durchgaengig schwach) |
| `ICoreLayout` | 11/33 | mittel |
| `ILivePlatformModel` | 10/33 | hoch (P05/P23/P32 als Leitpaper) |
| `IScheduler` | 9/33 | mittel (OLC/RCU/HP/CoreManager als 4 Mechaniken) |
| `IHeuristic` | 33/33 | sehr hoch (alle 33 Paper liefern Heuristiken) |
| `ICacheTopology` | 8/33 | mittel (Set-Associativity nur in P11/P13/P18/P32) |
| `ICacheResidency` | 6/33 | niedrig (P05/P28/P28-Mail Leitpaper) |
| `IBusTopology` | 6/33 | mittel (P31 als Leitpaper) |
| `ILiveCpuModel` | 4/33 | niedrig (P23 als Leitpaper, DVFS in P31) |
| `ICoreToThreadMap` | 4/33 | niedrig (NUMA-Pinning nur in P29/P31/P33) |

**Hauptlueckenanalyse:** `ICacheResidency`, `ILiveCpuModel`, `ICoreToThreadMap` sind in den 33 Papern unterrepraesentiert und benoetigen entweder
(a) eigene Forschungsbeitraege im Diplomarbeits-Rahmen oder
(b) sekundaere Literatur (Hennessy-Patterson, Intel/AMD Optimization Manuals).
