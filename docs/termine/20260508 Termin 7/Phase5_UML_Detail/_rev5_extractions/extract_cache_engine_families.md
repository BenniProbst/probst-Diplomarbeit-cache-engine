# ICacheEngine-Familien-Taxonomie (REV5.1)

**Stand:** 2026-05-11
**Pendant zu:** ISearchEngine-Familien S1-S30 (K06)
**Quelle:** 11_cache_strategy_taxonomie.md (F1-F29 Strategien) + 13_saeule_b_plattform_modell_konkretisierung.md + Cluster A/D/E
**Architektur-Bezug:** REV5.1 — Saeule B Cache-Engine als VISITOR-Familie mit orthogonalen Komponenten-Familien

---

## 0. Vorbemerkung — Engine-Familien vs. Strategie-Familien

**KRITISCHE UNTERSCHEIDUNG (User-Direktive 2026-05-11):**

Die F1-F29 Familien aus `11_cache_strategy_taxonomie.md` sind **Wahl-Optionen**, die eine Cache-Engine ihren Konsumenten anbieten kann (z.B. F5 SoftwarePrefetch, F25 SyncMechaniken, F27 NFP-Decorator). Die F1-F29 sind also die *Strategien*, die durch die ICacheStrategy = VISITOR-Hierarchie reisen.

Die hier vorgestellten **C1-Cn ICacheEngine-Familien** sind dagegen die **internen Komponenten-Kategorien** der Cache-Engine selbst — die orthogonalen Sub-Engines, die jeweils ihre eigene Strategie-Auswahl beherbergen. Beispiel:

- **C3 Cache-Prefetch-Engine-Familie** ist die Kategorie aller Prefetch-Sub-Engines (atomare Bausteine: WideNodePrefetch, JumpPointerArrayPrefetch, CoroutineFullNode, …).
- F5 SoftwarePrefetchStrategy ist die *Wahl-Option*, die C3 einer Konkretion zur Verfuegung stellt.
- F23 AdaptiveRuntimePrefetchDistance verbindet C3 (Prefetch-Engine) ↔ C5 (Telemetry-Engine) ↔ C9 (Heuristik-Engine).

Die ICacheEngine-Familien sind also der **Architektur-Bauplan** der Cache-Engine — die Strategie-Familien sind ihre **Permutations-Optionen**. Die Familien-Anzahl entspricht der Anzahl orthogonaler Sub-Engines, die im REV5-Architektur-Skizze identifiziert wurden.

Format der folgenden Sektionen entspricht ISearchEngine-Familien S1-S30:

1. Familien-Definition (Concept-Klasse + Dach-Idee)
2. Atomare Bausteine (analog zu Singular-Strategien)
3. Hybride Bausteine (analog zu Plural-Strategien) + Hybrid-Aufloesung via Command-Pattern
4. Mapping zu F-Strategien aus 11_md
5. Konkretisierungen aus den 33 Papern
6. Verzeichnis-Bezug zu cache_engine/<sub-pfad>/

---

## 1. UEBERSICHT der C1-C12 ICacheEngine-Familien

| ID | Name | Hauptkategorie | Verzeichnis | F-Mapping | Familien-Quelle |
|----|------|----------------|-------------|-----------|-----------------|
| **C1** | Cache-Layout-Engine | Knoten-Format & Footprint | `cache_engine/layout/` | F1, F2, F3, F4, F8, F11, F12, F13, F14, F15, F16, F17, F19, F22 | P01-P22, P32 |
| **C2** | Cache-Pinning-Engine | NUMA/Core/Tier-Bindung | `cache_engine/pinning/` | (ergaenzt F18, F25) | P03, P25, P28, P29, P31, P32, P33 |
| **C3** | Cache-Prefetch-Engine | Latenz-Hiding | `cache_engine/prefetch/` | F4, F5, F6, F23, F26 | P02-P05, P14, P15, P21-P28 |
| **C4** | Cache-Coherence-Engine | Reader/Writer-Asymmetrie, Sync | `cache_engine/coherence/` | F18, F25, F26 | P03, P06-P08, P28-P30 |
| **C5** | Cache-Telemetry-Engine | Mess- + Probe-Strategien | `cache_engine/telemetry/` | F23, F24 | P05, P13, P23-P28, P32 |
| **C6** | Cache-Allocation-Engine | Allocator + Tier-Auswahl | `cache_engine/allocation/` | F1, F12, F21, F27 | P05, P22, P25, P31, P33 |
| **C7** | Cache-Migration-Engine | Tier-Migration & Compensation | `cache_engine/migration/` | F9, F19, F27 | P22, P25, P33 |
| **C8** | Cache-Encoding-Engine | Topologie + Bit-Packing | `cache_engine/encoding/` | F2, F10, F16, F17, F19, F20 | P01, P02, P04, P09, P10, P11, P12 |
| **C9** | Cache-Heuristik-Engine | Decision-Logik + Cost-Modell | `cache_engine/heuristic/` | (orthogonal zu allen) | alle 33 Paper |
| **C10** | Cache-Topologie-Engine | Plattform-Probe + Discovery | `cache_engine/topology/` | (Saeule B Adapter) | P05, P25, P28, P32, P33 |
| **C11** | Cache-Scheduler-Engine | Background-Worker + Trigger | `cache_engine/scheduler/` | F25, F24 | P05, P15, P26, P28, P29, P31, P33 |
| **C12** | Cache-Filter-Engine | Approximate-Membership | `cache_engine/filter/` | F29 | P10 (SuRF) |

**Gesamt: 12 ICacheEngine-Familien.**

Der Permutations-Raum entspricht: ~250 atomare Bausteine × 12 Familien ≈ 3000 unique Kombinationen (REV5.1 Forschungs-Ziel: F15 cross-family Permutationen).

---

## 2. C1 — Cache-Layout-Engine-Familie

**Concept-Klasse:** `ICacheLayoutEngine` (Sub-Engine der ICacheEngine, traegt INode-Format-Politik)
**Dach-Idee:** Bestimmt Knoten-Repraesentation: Groesse, Cache-Line-Alignment, Footprint, Layer-Differenzierung, Indirection vs. Inline. Verbindet Saeule-A (ISearchPage/INode) mit Saeule-B (ICacheLine.size_bytes).

### 2.1 Atomare Bausteine (analog zu Singular-Strategien S1-S74)

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `Node4LayoutAtom` | P01 ART | Adaptive Knoten 4 Slots |
| `Node16LayoutAtom` | P01 ART | Adaptive Knoten 16 Slots, SSE-faehig |
| `Node48LayoutAtom` | P01 ART | Adaptive Knoten 48 Slots, indirektes Slot-Mapping |
| `Node256LayoutAtom` | P01 ART | Direct Lookup Knoten 256 Slots |
| `SingleMask8PKEYAtom` | P02 HOT | 8-Bit Partial-Key Single-Mask |
| `SingleMask16PKEYAtom` | P02 HOT | 16-Bit Partial-Key Single-Mask |
| `SingleMask32PKEYAtom` | P02 HOT | 32-Bit Partial-Key Single-Mask |
| `MultiMask8x8Atom` ... `MultiMask32x32Atom` | P02 HOT | 6 weitere Multi-Mask-Varianten |
| `MultilevelNodeAtom` | P05 START | Multi-Level Span-Width |
| `RewiredVirtualPhysicalAtom` | P05 START | Virtual<->Physical Page-Sharing |
| `SegmentedAllocationAtom` | P12 CSB+ | Segmentierte Allocation |
| `FullPreallocatedAtom` | P12 CSB+ | Full Preallocated Layout |
| `BasicSinglePointerAtom` | P12 CSB+ | Basic Layout mit Single firstChild |
| `CacheLineSizedNodeAtom` | P11 CSS-Tree | Knoten = 1 Cache-Line |
| `MultiCacheLineNodeAtom(w)` | P03 Masstree, P21 Chen | Knoten umspannt w Cache-Lines |
| `EmbeddedSecondaryIndexAtom` | P06 B²-Tree, P11 CSS-Tree | Sub-Index in Page (Decision-Span / Embedded Directory) |
| `IndirectionVectorAtom` | P03 Masstree, P15 Graefe | Permutation-Field, Range-Array, Slotted-Page |
| `CacheObliviousVEBAtom` | P17 Bender | Van Emde Boas Layout |
| `CacheSensitiveMultiLevelAtom` | P18 Saikkonen | B_0 < B_1 < ... mit Aliasing-Correction |
| `HotPathLinearAtom` | P28 Kuehn | Hot-Path in linear ascending memory |
| `ProbabilityWeightedRootBlockAtom` | P16 Bender | Greedy (B-1)/B |
| `PoorMansNormalizedKeyAtom` | P15, P20 | 4-Byte Heads in Indirection-Vector |
| `PrefixTruncationAtom` | P20 | Fence-basierte Prefix-Truncation |
| `OrderPreservingHuffmanAtom` | P15 Graefe | Order-preserving Compression |
| `CodeSpecializedSearchAtom` | P11/P12/P14/P23 | Compile-Time-Loop-Unrolled |
| `StridedPaddedAtom` | P32 To-Stride | 576-Byte Padding zur Set-Thrashing-Vermeidung |

### 2.2 Hybride Bausteine + Command-Pattern-Aufloesung

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **HOT 9-Layout-Pool** (P02) | 9 Atom-Commands (Single-Mask + Multi-Mask) | `HOTAdaptiveLayoutSelectionCompositionCommand` |
| **START Multilevel + Rewired** (P05) | `MultilevelNodeCommand` + `RewiredVirtualPhysicalCommand` + `Multinode4Command` | `STARTAdaptiveCompositionCommand` |
| **CSB+ 3-Allocation-Modi** (P12) | `SegmentedAllocationCommand` + `FullPreallocatedCommand` + `BasicSinglePointerCommand` | `CSBPlusAllocationModeCompositionCommand` |
| **B-Tree-adaptive 4-Layout-Heterogen** (P20) | Comparison + Fingerprinting + SDL + FDL Atom-Commands | `BTreesAreBackHeterogeneousAdaptiveCompositionCommand` |

### 2.3 F-Mapping (welche F-Strategien koennen waehlbar sein)

C1 hostet die *Wahl* zwischen F1 (AdaptiveFootprint), F3 (CacheLineAligned), F4 (MultiCacheLineNode), F8 (PathCompression), F9 (LayerDependentEncoding), F11 (EmbeddedSecondaryIndex), F12 (IndirectionVector), F13 (CacheObliviousLayout), F14 (CacheSensitiveMultiLevel), F15 (ProbabilityWeightedLayout), F16 (Compression), F17 (PoorMansNormalizedKey), F19 (HotColdLayer), F22 (CodeSpecialization).

### 2.4 Verzeichnis-Struktur

```
cache_engine/layout/
├── adaptive_footprint/   (F1, ART/HOT/START/CSB+/B-Tree-adaptive)
├── cache_line_aligned/   (F3, ART/HOT/Wormhole/CSS-Tree/CSB+/Itanium/Graefe/To-Stride)
├── multi_cache_line/     (F4, Masstree/Hankins/Chen pB+/Chen Fractal)
├── path_compression/     (F8, ART/HOT/CoCo/START/B²-Tree/Wormhole/ART-OLC)
├── layer_dependent/      (F9, HOT/START/SuRF/B-Tree-adaptive/Kuehn)
├── indirection_vector/   (F12, Masstree/B²-Tree/Wormhole/Graefe/B-Tree-adaptive)
├── cache_oblivious/      (F13, Bender/Saikkonen)
├── cache_sensitive/      (F14, Saikkonen/Kuehn)
├── probability_weighted/ (F15, Bender/Kuehn)
├── compression/          (F16/F17, Graefe/B-Tree-adaptive)
└── code_specialized/     (F22, CSS-Tree/CSB+/CSB+-Itanium/Khan)
```

---

## 3. C2 — Cache-Pinning-Engine-Familie

**Concept-Klasse:** `ICachePinningEngine` (Sub-Engine, traegt Thread-Core-Memory-Bindungs-Politik)
**Dach-Idee:** Bestimmt, auf welchem Core/CCD/Socket Threads laufen, welcher NUMA-Node Memory bindet, ob first-touch oder explicit. Verbindet Saeule-B (`IPinningPolicy`, `ICoreToThreadMap`) mit den NUMA-Discoveries aus P25/P28/P32/P33.

### 3.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `FirstTouchPinningAtom` | P28 Kuehn | Linux Default first-touch |
| `NumactlBindAtom` | P25 Mahling, P32 To-Stride | Explicit numactl/mbind |
| `PerCpuQuiescentAtom` | P29 RCU | Per-CPU-State-Tracking |
| `PerThreadHazardAtom` | P30 Hazard Pointers | Per-Thread HP-Records |
| `CrossSocketAvoidanceAtom` | P03 Masstree, P25 | Hard-Partitioned pro Socket |
| `LargestL3CcdPinningAtom` | (Auto-Discovery, ehemals X3DVCachePinning) | CCD mit groesstem L3 bevorzugen (Ryzen 9 9950X3D) |
| `HotPathOnHighIpcCoreAtom` | (Auto-Discovery, ehemals IntelHybrid) | Hot-Path auf P-Cores routen |
| `MicroServerCpuBindingAtom` | P15 Graefe Sektion 7 | Modul-orientierte CPU-Bindung |
| `CoreManagerPinningAtom` | P31 Tomahawk | Core Manager + PE-Allocation |
| `IntelThreadDirectorHintAtom` | (Block AO i9-14900KS) | P-/E-Core Hints |

### 3.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **3-Klassen Wormhole-Scheduling** (P07) | RCU-Lookup + RW-Lock + MutEx pro Klasse | `WormholePinning3ClassesCompositionCommand` |
| **CoreManager + DVFS** (P31) | `CoreManagerPinningAtom` + `FrequencyScalingAtom` + `PEAllocationAtom` | `TomahawkCoreManagerCompositionCommand` |

### 3.3 F-Mapping

C2 ergaenzt F18 (NoSharedWrite, durch Pinning unterstuetzt) und F25 (SyncMechaniken — Pinning ist die Voraussetzung fuer Per-CPU-RCU-State).

### 3.4 Verzeichnis-Struktur

```
cache_engine/pinning/
├── numa_aware/        (FirstTouch, Numactl, CrossSocket)
├── per_cpu/           (RCU, HP, CoreManager)
├── platform_property/ (LargestL3, HighIpc, IntelThreadDirector)
└── micro_server/      (Modul-orientiert, P15)
```

---

## 4. C3 — Cache-Prefetch-Engine-Familie

**Concept-Klasse:** `ICachePrefetchEngine`
**Dach-Idee:** Latenz-Hiding via explizite Prefetch-Instruktionen, Jump-Pointer-Arrays, Coroutines, Stride-Patterns. Konsumiert `IIsaFeatureSet.has_software_prefetch`, `ICacheLevel`-Latenzen, `ILivePlatformModel.fb_size`.

### 4.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `T0PrefetchAtom` | P25, P26 | __builtin_prefetch L1 |
| `T1PrefetchAtom` | P25 | L2 (Intel: T1=T2) |
| `T2PrefetchAtom` | P25, P26 | L3 |
| `NTAPrefetchAtom` | P14 Itanium, P25 | Non-Temporal Hint |
| `KEEPArmAtom`, `STREAMArmAtom` | P25 ARM | ARM-Policies × 3 Targets |
| `LfetchAtom` | P14 Itanium, P23 Khan | Itanium lfetch / lfetch.nt1 |
| `WideNodePrefetchAtom(w)` | P21 Chen pB+ | w Cache-Lines parallel |
| `JumpPointerArrayPrefetchAtom(k)` | P21, P22, P26 | k voraus, externes Array |
| `InternalJumpPointerAtom` | P21 Chen | Bottom-Non-Leaves als Jump-Array |
| `ChunkedLinkedListHintAtom` | P21, P26 | Hint-Pointer + Chunk-Search |
| `DualJumpCachePlusDiskAtom` | P22 Chen Fractal | Dual fuer Cache+Disk |
| `CoroutineFullNodeAtom` | P25 Mahling | Coroutine-Suspend bei Full Node |
| `CoroutineHalfNodeAtom` | P25 Mahling | Erst Header, dann Keys |
| `BundlePrefetchAtom(d=90)` | P27 Zhang Hierarchical | Coarse-grained Distance 90 |
| `StridedScalarAtom` | P32 To-Stride | Strided > simd-sequential |
| `PartitionStrideAtom(N=30..42)` | P32 To-Stride | 30-42 Partitions auf Sapphire Rapids |
| `PathPrefetchAtom` | P26 Zhang Index | Pfad voraus prefetchen |
| `MonitorPrefetchAtom` | P26 Zhang Index | Telemetry-getrieben (Stage 2 Round-Robin) |
| `CachePrefetchInsideNodeAtom` | P26 Zhang Index | Cache-Lines im Knoten vor Binary Search |
| `PostLocationCheckAtom` | P15 Graefe | Verifizierter Prefetch-Hit |
| `MultiRecordHintAtom` | P15 Graefe | Multi-Record-Prefetch |
| `TwoNodesAheadRangeScanAtom` | P14 Itanium | 2 Knoten voraus bei Range-Scan |
| `RuntimeAdaptiveDistanceAtom` | P23 Khan | Live-berechnete Distance |
| `AffineDistanceAtom(A,B)` | P23 Khan | I = O*A + B |
| `TemplateSpecializerAtom` | P23 Khan | 2-5 Bitwise-Modifications |

### 4.2 Hybride Bausteine + Command-Aufloesung

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **3-Prefetcher Zhang Index** (P26) | `CachePrefetchInsideNodeCommand` + `PathPrefetchCommand` + `MonitorPrefetchCommand` | `ThreePrefetcherOrchestrationCompositionCommand` |
| **Khan 3-Phasen-Pipeline** (P23) | `CompileTimeAnalysisCommand` + `TemplateSpecializerCommand` + `OnlineDistanceAdaptCommand` | `KhanDynamicSpecializerCompositionCommand` |
| **Coroutine Selection** (P25) | `CoroutineFullNodeCommand` + `CoroutineHalfNodeCommand` + `ReliabilitySwitchCommand` | `CoroutineSelectionCompositionCommand` |
| **Itanium Prefetch** (P14) | `LfetchExplicitCommand` + `RangeScanLookaheadCommand` | `ItaniumPrefetchCompositionCommand` |
| **Graefe-Survey** (P15) | `MultiCacheLinePrefetchCommand` + `IndirectionVectorCommand` + `MultiRecordHintCommand` + `PostLocationCheckCommand` | `GraefePrefetchSurveyCompositionCommand` |
| **Chen pB+ Prefetched** (P21) | `WideNodePrefetchCommand` + `JumpPointerArrayPrefetchCommand` + `ChunkedLinkedListHintCommand` | `ChenPrefetchedBPlusCompositionCommand` |

### 4.3 F-Mapping

C3 hostet die *Wahl* zwischen F4 (MultiCacheLineNode), F5 (SoftwarePrefetch), F6 (PointerChasingResolution), F23 (AdaptiveRuntimePrefetchDistance), F26 (StrideAccessPattern).

### 4.4 Verzeichnis-Struktur

```
cache_engine/prefetch/
├── instruction/        (T0/T1/T2/NTA/lfetch/KEEP/STREAM)
├── wide_node/          (WideNode, MultiCacheLine — F4/F5)
├── jump_pointer/       (External, Internal, Dual, ChunkedLinked)
├── coroutine/          (FullNode, HalfNode, ReliabilitySwitch)
├── monitor_driven/     (PathPrefetch, MonitorPrefetch — F24-Bezug)
├── stride/             (StridedScalar, Partition)
├── runtime_adaptive/   (Khan, AffineDistance, TemplateSpecializer)
└── bundle/             (Coarse-grained Distance ~90, P27)
```

---

## 5. C4 — Cache-Coherence-Engine-Familie

**Concept-Klasse:** `ICacheCoherenceEngine`
**Dach-Idee:** Verwaltet Reader/Writer-Asymmetrie, Sync-Protokolle, vermeidet Cache-Line-Bouncing. Konsumiert `IInterconnect.cache_coherence_latency`, `IConcurrencyProtocol`.

### 5.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `OptimisticLockCouplingAtom` | P03, P06, P08 | Vinsert/Vsplit-Counter, Restart-Loop |
| `RowexAtom` | P02 HOT, P08 ART-OLC | 4-Schritt Read-Optimistic-Write-Exclusive |
| `RcuQsbrAtom` | P29 McKenney, P07 | Grace Period + Quiescent States |
| `RcuMembarrierAtom` | P29 + URCU 6-Flavor | Membarrier-Variante |
| `RcuSignalAtom` | URCU | Signal-basiertes RCU |
| `HazardPointerAtom` | P30 Michael | Single-word CAS, wait-free |
| `EpochBasedReclamationAtom` | (P29-Erweiterung) | Per-Thread Epoch-Counter |
| `HtmTransactionalAtom` | P08 ART-OLC | Hardware Transactional Memory |
| `HandOverHandLockingAtom` | P03 Masstree | Per-Layer Lock-Acquire-Release |
| `CowAtom` | P02 HOT | Copy-on-Write fuer Concurrent Reads |
| `MfenceLfenceAtom` | P05, P29 | Memory-Ordering Barriers |
| `NoSharedWriteAtom` | P03, P08, P29, P30 | Read-only Reader-Side |

### 5.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **Wormhole 3-Class Sync** (P07) | RCU + RW-Lock + MutEx | `WormholeQsbrRwlockMutexCompositionCommand` |
| **ART-OLC + ROWEX** (P08) | OLC + ROWEX + Restart-Limit + Write-Lock-Fallback | `ArtOlcRowexFallbackCompositionCommand` |
| **HOT COW + Obsolete-Marker** (P02) | `CowAtom` + `ObsoleteMarkerAtom` | `HotCowReaderCompositionCommand` |

### 5.3 F-Mapping

C4 hostet F18 (NoSharedWrite), F25 (SyncMechaniken), und beeinflusst F26 (StrideAccessPattern bei Cross-Socket-Coherence).

### 5.4 Verzeichnis-Struktur

```
cache_engine/coherence/
├── optimistic/         (OLC, ROWEX, HandOverHand)
├── reclamation/        (RCU-{qsbr,mb,membarrier,signal}, HP, EBR)
├── transactional/      (HTM)
├── cow/                (HOT-COW, Obsolete-Marker)
└── barriers/           (MFENCE, LFENCE, NoSharedWrite-Discipline)
```

---

## 6. C5 — Cache-Telemetry-Engine-Familie

**Concept-Klasse:** `ICacheTelemetryEngine`
**Dach-Idee:** Erfasst Mess-Daten zur Laufzeit (Counter, Hardware-Performance-Counters, Sampling). Speist C9 Heuristik mit Live-Daten.

### 6.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `PerNodeCounterAtom` | P28 Kuehn | Counter pro Comparison Key (mit Coherence-Falle!) |
| `LeafOnlyCounterAtom` | P28-Mail (NEU 2026-05-08) | Counter nur Leaves — vermeidet Coherence-Storm |
| `LeafOnlySampledCounterAtom<N>` | P28-Mail (NEU) | Sampling 1/N |
| `RetroactiveAggregationAtom` | P28-Mail (NEU) | Periodische Counter→Root-Propagation |
| `PathReadCounterAtom` | P26 Zhang Index | Per-Block-Counter, separater Storage |
| `MonitorClusteringAtom` | P26 Zhang Index | 2-Stage mit Forgetting-Factor w |
| `JaccardSimilarityAtom` | P27 Zhang Hierarchical | Per-Bundle Avg Jaccard-Index |
| `BundleIdentificationAtom` | P27 Zhang Hierarchical | Threshold 200 KB |
| `CompressionBufferFifoAtom(16)` | P27 Zhang Hierarchical | 16-Entry FIFO Spatial-Region |
| `HotPathExtractionAtom` | P28 Kuehn | Greedy highest-prob → highest-prob Child |
| `FbFullCounterAtom` | P25 Mahling | L1D_PEND_MISS.FB_FULL Performance Counter |
| `ClflushProbeAtom` | P05 START | CLFLUSH-cycle-Measurement Probe |
| `LatencyProbeAtom` | P05, P13, P32 | All-Pairs-Pinning-Vermessung |
| `PerfmonReaderAtom` | P12 CSB+ | perfmon-Tool-Counter-Reader |
| `PapiReaderAtom` | P13 Hankins/Patel | PAPI library |
| `VTuneReaderAtom` | P28 Kuehn | Intel VTune |
| `CardenasFormulaAtom` | P13 Hankins/Patel | Steady-state Cache-Hit-Rate |
| `SlidingWindowDriftAtom` | P28 Future Work | Drift-Detection |
| `GeneCountReuseDistanceAtom` | P24 Naderan-Tahan | Reuse-Distance Coverage |
| `OverpredictionGateAtom` | P24 Naderan-Tahan | Overprediction-Threshold |
| `IpcMeasurementAtom` | (Saeule B Live) | Instructions-per-Cycle Counter |
| `BranchMispredictMeasurementAtom` | P13 implizit | Branch-Mispredict-Rate |

### 6.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **Zhang Index 3-Komponenten-Telemetry** (P26) | `OnlineQueryMonitorCommand` + `PathReadCounterCommand` + `MonitorClusteringCommand` | `ZhangFGCSTelemetryCompositionCommand` |
| **Kuehn-Mail Telemetry-Stack** (P28-Mail) | `LeafOnlyCounterCommand` + `LeafOnlySampledCounterCommand` + `RetroactiveAggregationCommand` + `ProbabilityHintsHeaderCommand` | `KuehnMailLeafOnlyCompositionCommand` |
| **Bundle-FIFO Telemetry** (P27) | `JaccardSimilarityCommand` + `BundleIdentificationCommand` + `CompressionBufferFifoCommand` | `ZhangAsplosBundleCompositionCommand` |
| **3-Probe-Toolchain** (P05+P13+P32) | `ClflushProbeCommand` + `PapiReaderCommand` + `VTuneReaderCommand` | `MultiToolProbeCompositionCommand` |

### 6.3 F-Mapping

C5 hostet F23 (AdaptiveRuntimePrefetchDistance via Live-Counter) und F24 (TelemetryDrivenStrategy — die zentrale Familie fuer C5).

### 6.4 Verzeichnis-Struktur

```
cache_engine/telemetry/
├── counters/           (PerNode, LeafOnly, LeafOnlySampled, PathRead, FbFull)
├── aggregation/        (RetroactiveAggregation, MonitorClustering, HotPathExtraction)
├── bundles/            (JaccardSim, BundleIdentification, CompressionBufferFifo)
├── probes/             (Clflush, Latency, Perfmon, PAPI, VTune)
├── formulas/           (Cardenas, ReuseDistance, OverpredictionGate)
└── drift/              (SlidingWindow, ProbabilityHintsHeader)
```

---

## 7. C6 — Cache-Allocation-Engine-Familie

**Concept-Klasse:** `ICacheAllocationEngine`
**Dach-Idee:** Allokiert Knoten-Speicher in passenden Tier (DRAM/HBM/NVRAM/Disk), beruecksichtigt Page-Sharing, NFP-Decorator, Tier-Properties.

### 7.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `MallocAtom` | (Standard) | Standard glibc malloc |
| `JemallocAtom` | (typisch DBMS) | Arena-basiert |
| `MimallocAtom` | (modern) | Page-Pooling |
| `MmapAnonymousAtom` | P05 START | mmap fuer grosse Allocations |
| `MemfdCreateAtom` | P05 START | File-Descriptor-basiertes Mapping |
| `RewiredVirtualPhysicalAllocatorAtom` | P05 START | virtual<->physical via memfd + multiple mmap |
| `HugePagesAtom` | (Linux/POSIX) | 2 MiB / 1 GiB Pages |
| `NumaLocalAllocatorAtom` | P25, P32 | numactl/mbind, first-touch |
| `HbmAllocationAtom` | P25 Mahling, P33 VAMPIR | HBM-Tier auto-discovered |
| `LpddrAllocationAtom` | P25 Grace | LPDDR5X Tier |
| `NvramAllocationAtom` | P33 VAMPIR | Persistent NVDIMM / Optane |
| `CxlAllocationAtom` | P25 Future-Trend | CXL-Memory-Pool |
| `PoolAllocatorAtom` | (typisch DBMS) | Arena fuer kleinere Knoten |
| `SegmentedAllocatorAtom` | P12 CSB+ | Bei NodeGroup-Layout |
| `OverflowPageAllocatorAtom` | P22 Chen Fractal | Overflow-Pages fuer Leaf-Parents |
| `NfpDecoratorAtom` | P33 VAMPIR | latency/throughput/persistence-Property |
| `VMallocAtom` | P33 VAMPIR | Virtualisierungs-Layer ueber DRAM/HBM/NVRAM |

### 7.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **VAMPIR V-malloc + Compensation** (P33) | `VMallocCommand` + `NfpDecoratorCommand` + `CompensationMigrationCommand` | `VampirVMallocCompositionCommand` |
| **START Rewiring + memfd** (P05) | `MemfdCreateCommand` + `RewiredVirtualPhysicalCommand` + `MmapMappingCommand` | `StartRewiringCompositionCommand` |
| **Multi-Tier-Allocator (HBM+DRAM+NVRAM)** (P25+P33) | `HbmAllocationCommand` + `MallocCommand` + `NvramAllocationCommand` + `TierDispatchCommand` | `HeterogeneousMemoryCompositionCommand` |

### 7.3 F-Mapping

C6 hostet F1 (AdaptiveFootprint setzt Allocator voraus), F12 (IndirectionVector), F21 (VirtualMemoryRewiring), F27 (NFP-Decorator).

### 7.4 Verzeichnis-Struktur

```
cache_engine/allocation/
├── system/             (Malloc, Jemalloc, Mimalloc)
├── mmap/               (MmapAnonymous, MemfdCreate, HugePages)
├── numa/               (NumaLocal, FirstTouch, mbind)
├── tier/               (Hbm, Lpddr, Nvram, Cxl, Vmalloc)
├── pool/               (PoolAllocator, SegmentedAllocator, OverflowPage)
└── nfp/                (NfpDecorator, Compensation, Migration)
```

---

## 8. C7 — Cache-Migration-Engine-Familie

**Concept-Klasse:** `ICacheMigrationEngine`
**Dach-Idee:** Verschiebt Knoten zwischen Cache-Tiers (Hot/Cold, DRAM↔HBM, Cache↔Disk). Periodisches oder Trigger-getriebenes Re-Layouting.

### 8.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `HotColdSegregationAtom` | P02 HOT, P05 START, P10 SuRF | Hot-Pages oben, Cold-Pages unten |
| `LayerCutoffAtom(R=64)` | P10 SuRF | Cutoff-Level R=64 zwischen Dense/Sparse |
| `MultiTierMigrationAtom(Cache,Disk)` | P22 Chen Fractal | Cache-Tier ↔ Disk-Tier |
| `DramHbmMigrationAtom` | P25, P33 | HBM-DRAM-Migration (V-malloc-gesteuert) |
| `CompensationMigrationAtom` | P33 VAMPIR | Transparente Daten-Migration zwischen NFP-Tiers |
| `LocalRelocationAtom(α=1..6)` | P19 Saikkonen | 1-6 Knoten lokal verschieben (wait-free) |
| `GlobalRelocationAtom` | P19 Saikkonen | BFS-Periodic globale Reorganisation |
| `LayoutInvariantPreservationAtom` | P19 Saikkonen | Invarianten-Erhaltung |
| `HotPathRefreshAtom` | P28 + P28-Mail | Periodische Hot-Path-Neuberechnung via RetroactiveAggregation |
| `BulkUpdateRebuildAtom` | P04 CoCo | Rebuild-only fuer statische Strukturen |
| `OnlineSelfTuningTriggerAtom` | P05 START | VACUUM-aehnlich, >10% Daten-Aenderung |
| `LayoutDegradationTriggerAtom` | P19 Saikkonen | # Updates seit Global-Reloc |

### 8.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **Saikkonen Local + Global Reloc** (P19) | `LocalRelocationCommand` (wait-free) + `GlobalRelocationCommand` (BFS-Periodic) + `LayoutInvariantPreservationCommand` | `LayoutInvariantCompositionCommand` |
| **Kuehn Hot-Path-Refresh** (P28-Mail) | `RetroactiveAggregationCommand` + `HotPathExtractionCommand` + `HotPathLinearLayoutCommand` | `KuehnHotPathRefreshCompositionCommand` |
| **VAMPIR Compensation/Migration** (P33) | `CompensationMigrationCommand` + `NfpDecoratorCommand` + `TierDispatchCommand` | `VampirCompensationMigrationCompositionCommand` |

### 8.3 F-Mapping

C7 hostet F9 (LayerDependentEncoding), F19 (HotColdLayer fuer Filter), F27 (NFP-Decorator-Migration).

### 8.4 Verzeichnis-Struktur

```
cache_engine/migration/
├── layer/              (HotCold, LayerCutoff, LayerDependentEncoding)
├── tier/               (MultiTier, DramHbm, Compensation)
├── relocation/         (LocalReloc, GlobalReloc, LayoutInvariantPreservation)
├── refresh/            (HotPathRefresh, BulkUpdate, OnlineSelfTuning)
└── trigger/            (LayoutDegradation, SelfTuningTrigger)
```

---

## 9. C8 — Cache-Encoding-Engine-Familie

**Concept-Klasse:** `ICacheEncodingEngine`
**Dach-Idee:** Topology-Encoding (LOUDS/DFUDS/BP/Pointer/BitArray) + Bit-Packing (Succinct, Compression, Pointer-Tag). Orthogonal zu C1 Layout.

### 9.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `LoudsEncodingAtom` | P09 Jacobson, P10 SuRF | 2-Bit-pro-Knoten |
| `LoudsDenseEncodingAtom` | P10 SuRF | 256-Bit-Bitmaps (oben) |
| `LoudsSparseEncodingAtom` | P10 SuRF | 8n+2n Bits (unten) |
| `DfudsEncodingAtom` | (klassisch succinct) | Depth-First Unary Degree |
| `BalancedParenthesesAtom` | (klassisch succinct) | BP-Topology |
| `PointerTopologyAtom` | (klassisch) | Standard-Pointer (Default) |
| `BitArrayTopologyAtom` | (Sub-Variante) | Implicit Bitmap |
| `EliasFanoEncodingAtom` | P04 CoCo | EF-Compression |
| `PackedArrayEncodingAtom` | P04 CoCo | PA-Encoding |
| `BitvectorEncodingAtom` | P04 CoCo | BV-Encoding |
| `DenseEncodingAtom` | P04 CoCo | DE-Encoding |
| `PointerTagAtom` | P01 ART, P02 HOT, P05 START, P07 Wormhole | Type-Bits in LSB |
| `OrderPreservingHuffmanAtom` | P15 Graefe | Order-preserving Encoding |
| `KeyNormalizationAtom` | P15 Graefe, P01 ART | Variable-length → comparable |
| `PrefixSuffixTruncationAtom` | P15 Graefe | Prefix/Suffix kurzen |
| `NextNeighborDifferencingAtom` | P15 Graefe | Delta-Encoding zwischen Nachbarn |
| `RankSelectPrimitiveAtom` | P09, P10, P04 | popcount-faehiges rank/select |
| `BlockOrientedRankSelectAtom(B)` | P10 SuRF (B=64/512) | Cache-Line-aligned LUT |
| `JacobsonTwoLevelDirectoryAtom` | P09 Jacobson | Klassische Tarjan-Yao-Tabellen |
| `PoppyRankAtom` | (modern succinct) | Poppy-Variante |
| `PartialKeyEncodingAtom(8/16/32)` | P02 HOT | 8/16/32-Bit Partial-Key |
| `SuRFBaseEncodingAtom`, `SuRFHashEncodingAtom`, `SuRFRealEncodingAtom`, `SuRFMixedEncodingAtom` | P10 SuRF | 4 Encoding-Varianten |
| `WAHCompressionAtom`, `PLWAHCompressionAtom`, `COMPAXCompressionAtom` | P31 Ungethuem | Bitmap-Compression-Familie |

### 9.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **CoCo Encoding-Pool** (P04) | `EliasFanoEncodingCommand` + `PackedArrayEncodingCommand` + `BitvectorEncodingCommand` + `DenseEncodingCommand` | `CoCoEncodingPoolCompositionCommand` |
| **SuRF Cutoff-Hybrid** (P10) | `LoudsDenseEncodingCommand` + `LoudsSparseEncodingCommand` + `LayerCutoffR64Command` | `CutoffLevelLoudsCompositionCommand` |
| **SuRF Filter-Pool** (P10) | `SuRFBaseCommand` + `SuRFHashCommand` + `SuRFRealCommand` + `SuRFMixedCommand` | `SuRFFilterPoolCompositionCommand` |
| **Graefe Compression-Suite** (P15) | `OrderPreservingHuffmanCommand` + `KeyNormalizationCommand` + `PrefixSuffixTruncationCommand` + `NextNeighborDifferencingCommand` | `GraefeCompressionSuiteCompositionCommand` |

### 9.3 F-Mapping

C8 hostet F2 (SuccinctEncoding), F10 (PointerTagDispatch), F16 (Compression), F17 (PoorMansNormalizedKey), F19 (HotColdLayer-Encoding fuer Filter), F20 (BlockOrientedRankSelect).

### 9.4 Verzeichnis-Struktur

```
cache_engine/encoding/
├── topology/           (LOUDS-Dense/Sparse, DFUDS, BP, Pointer, BitArray)
├── succinct/           (EF, PA, BV, DE, RankSelect)
├── compression/        (OrderPreservingHuffman, KeyNormalization, Prefix/Suffix, NextNeighborDifferencing, WAH/PLWAH/COMPAX)
├── pointer_tag/        (TypeBits in LSB, Combined Pointer/Value Slots)
├── partial_key/        (8/16/32-Bit Partial-Key, Single-Mask, Multi-Mask)
└── filter/             (SuRF-Base/Hash/Real/Mixed)
```

---

## 10. C9 — Cache-Heuristik-Engine-Familie

**Concept-Klasse:** `ICacheHeuristicEngine`
**Dach-Idee:** Decision-Logik + Cost-Modell. Konsumiert C5 Telemetry + C10 Topology, entscheidet welche Atom-Bausteine in C1-C8 aktiviert werden. Orthogonal zu allen anderen Familien.

### 10.1 Atomare Bausteine (Klassen, gekuerzt — Vollstaendig in 13_md §9)

**Layout-Selection-Heuristiken (≥18 Atoms):** AdaptiveLayoutSelection, HeightConstrainedPartitioning, DataAwareCollapsing, CacheCostBasedNodePlacement, BellmanDPNodeOptimizer, RecursiveCommonPrefixDecomposition, MinimumDistinguishingPrefix, MatchCacheLineSize, BranchFactorSelection, SegmentationPolicy, HardcodedSearchVariant, ConfigurationLookup, ProbabilityWeightedRootBlock, OptimalAllocation, AlphaTuning, HeadQuality, KeyType, BoundaryNode.

**Cost-Modell-Heuristiken (≥13 Atoms):** CacheCostDP, OptimalNodeSize (Hankins-Patel), TLBAwareSizing, BranchPredictionAware, CardenasFormula, OptimalNodeWidth (Chen), OptimalPrefetchDistance, OptimalChunkSize, OptimalWidthMultiTier (Fractal), OverflowVsOffload, DiskFirstVsCacheFirst, ConflictMissPrediction, WidthCostModel.

**Adaptive-Prefetch-Distance-Heuristiken (≥8 Atoms):** AdaptivePrefetchDistance (Khan), RuntimeOffsetAdaptation, CostBenefitGated, AffineDistance, TemplateSpecializer, StrideVsSequential (To-Stride), PartitionCount, PaddingStrategy.

**Workload-Detection-Heuristiken (≥6 Atoms):** SequentialInsertOptimization, LayerCreationDecision, WorkloadDetection (B-Tree-adaptive), ScanFrequencyCounter, SkewedDistributionDetection (Zipfian), SlidingWindowDriftDetection.

**Coherence-Pressure-Heuristiken (≥6 Atoms):** CacheCoherenceCost, OverpredictionGate, NegativPredictionDetection, PrefetchReliability, FBSizeAwareLimiting, AccessProbabilitySortedPrefetch.

**Telemetry-getriebene Heuristiken (≥9 Atoms):** PathReadCounter, MonitorClustering, JaccardSimilarityTelemetry, StaticVsDynamicFootprintRatio, HotPathExtraction, PerNodeHistogram, LeafOnlyCounter, LeafOnlySampledCounter, RetroactiveAggregation.

**Search-Strategy-Selection-Heuristiken:** LinearSearchPreferred, BinarySearchPreferred, InterpolationSearchPreferred, PoorMansKeyAccelerated.

**Workload-Mix-Heuristiken:** PointQueryOptimized, ScanOptimized, InsertOptimized, MixedWorkload, StrategyCompatibilityMatrix, LayoutDegradation.

**Hardware-Probing-Heuristiken:** PlatformProbe, OnlinePerformanceCounterReader, DynamicSpecializer, BundleThreshold.

### 10.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **Samuel ConfigurationTable** (P14) | `ConfigurationLookupCommand` + `KeySizeMappingCommand` + `NodeSizeSelectionCommand` + `SearchStrategySelectionCommand` | `SamuelConfigurationTableCompositionCommand` |
| **Khan Dynamic Specializer** (P23) | `CompileTimeAnalysisCommand` + `RuntimeSpecializerCommand` + `OnlineDistanceAdaptationCommand` | `KhanDynamicSpecializerCompositionCommand` |
| **Hankins-Patel Cost-Modell** (P13) | `OptimalNodeSizeCommand` + `TLBAwareSizingCommand` + `BranchPredictionAwareCommand` + `CardenasFormulaCommand` | `HankinsPatelCostModelCompositionCommand` |
| **Block-AO Plattform-Dispatch** (Block AO) | `PlatformDispatchCommand` + `AvxFeatureGateCommand` + `Ddr5BandwidthCommand` + `HotPathLayoutCommand` | `BlockAOProductionDispatchCompositionCommand` |

### 10.3 F-Mapping

C9 ist *orthogonal* — die Heuristiken entscheiden welche F-Strategien in welchen Familien aktiviert werden.

### 10.4 Verzeichnis-Struktur

```
cache_engine/heuristic/
├── layout_selection/   (18 Atoms aus §9.1)
├── cost_model/         (13 Atoms aus §9.2)
├── prefetch_distance/  (8 Atoms aus §9.3)
├── workload_detection/ (6 Atoms aus §9.4)
├── coherence_pressure/ (6 Atoms aus §9.5)
├── telemetry_driven/   (9 Atoms aus §9.6)
├── search_selection/   (LinearSearch/BinarySearch/InterpolationSearch/PoorMansKey)
├── workload_mix/       (PointQuery/Scan/Insert/Mixed/Compatibility/LayoutDegradation)
└── platform_probing/   (PlatformProbe/OnlineCounter/DynamicSpecializer/BundleThreshold)
```

---

## 11. C10 — Cache-Topologie-Engine-Familie

**Concept-Klasse:** `ICacheTopologyEngine`
**Dach-Idee:** Auto-Discovery der Plattform-Eigenschaften (CPUID, sysfs, hwloc, /proc/cpuinfo). Adapter-Schicht zu Saeule B (`ICacheLevel`, `ICacheLine`, `ICpuCore`, `IIsaFeatureSet`, `IInterconnect`). REV3-konform: KEINE plattform-spezifischen Klassen, sondern AUTO-discovered Properties.

### 11.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `CpuidProbeAtom` | (Saeule B Standard) | x86 CPUID-Instruction |
| `SysfsProbeAtom` | (Linux) | /sys/devices/system/cpu/ |
| `HwlocProbeAtom` | (libhwloc) | Portable Topology-Library |
| `ProcCpuinfoProbeAtom` | (Linux) | /proc/cpuinfo |
| `ClflushCycleMeasureAtom` | P05 START | Probe per CLFLUSH+rdtsc |
| `AllPairsPinningProbeAtom` | P25, P32 | Cross-Core-Latenz vermessen |
| `CacheCoherenceCostProbeAtom` | P28-Mail | Coherence-Cost calibrieren |
| `TlbCapacityProbeAtom` | P28, P32 | DTLB/STLB Capacity-Measurement |
| `PrefetcherStreamProbeAtom` | P32 | Stream-Limit pro Generation |
| `AsymmetricL3DiscoveryAtom` | (Auto-Discovery, ehemals X3DProbe) | has_asymmetric_l3 = true |
| `HybridCoreDiscoveryAtom` | (Auto-Discovery, ehemals IntelHybridProbe) | has_hybrid_cores = true |
| `HbmTierDiscoveryAtom` | (Auto-Discovery) | has_hbm_tier = true |
| `IsaFeatureSetClassifierAtom` | P02, P31, P32 | AVX2/AVX-512/BMI2/popcount/CRC32c |
| `InterconnectTopologyClassifierAtom` | P25, P31, P33 | NoC/Crossbar/Mesh/Ring/QPI/UPI/InfinityFabric/PCIe/CXL |
| `MemoryBandwidthClassifierAtom` | P21, P22, P25, P31 | DDR4/DDR5/HBM2/HBM3/LPDDR5X mit B = T1/T_next |
| `NumaTopologyClassifierAtom` | P25, P29, P32 | local/remote-Latency-Ratios |
| `PropertyPublisherAtom` | (REV3-Architektur) | Stellt Properties allen Permutations-Modulen zur Verfuegung |

### 11.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **5-Schritt Auto-Discovery** (REV3-Architektur) | `DiscoverCommand` + `MeasureCommand` + `ClassifyCommand` + `PublishCommand` + `BindCommand` | `AutoDiscoveryFiveStepCompositionCommand` |
| **Block AO Auto-Discovery** (Block AO) | `AsymmetricL3DiscoveryCommand` + `HybridCoreDiscoveryCommand` + `IsaFeatureSetClassifierCommand` + `Ddr5BandwidthClassifierCommand` | `BlockAOAutoDiscoveryCompositionCommand` |
| **Multi-Tool-Probe** (P05+P13+P32) | `ClflushProbeCommand` + `PerfmonProbeCommand` + `PapiProbeCommand` + `VTuneProbeCommand` | `MultiToolProbeCompositionCommand` |

### 11.3 F-Mapping

C10 ist *Saeule-B-Adapter*; alle F-Strategien koennen seine Properties konsumieren via `IPlatformPropertyClassifier`.

### 11.4 Verzeichnis-Struktur

```
cache_engine/topology/
├── probe/              (Cpuid, Sysfs, Hwloc, ProcCpuinfo, Clflush, AllPairsPinning)
├── classifier/         (IsaFeatureSet, Interconnect, MemoryBandwidth, NumaTopology)
├── property/           (AsymmetricL3, HybridCores, HbmTier, has_avx512, has_bmi2, has_software_prefetch)
└── publisher/          (PropertyPublisher, PropertyBinder)
```

---

## 12. C11 — Cache-Scheduler-Engine-Familie

**Concept-Klasse:** `ICacheSchedulerEngine`
**Dach-Idee:** Background-Worker, periodische Trigger, Re-Layouting-Phases, Async-Index-Build. Verbindet C5 Telemetry mit C7 Migration und C9 Heuristik.

### 12.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `OfflineSelfTuningAtom` | P05 START | VACUUM-Trigger, Threshold-basiert |
| `PeriodicGlobalRelocationAtom` | P19 Saikkonen | Nach N Updates |
| `MicroServerSchedulerAtom` | P15 Graefe | Task-Layout-Bindung |
| `WorkerThreadAsyncAtom` | P26 Zhang Index | Async Index-Build |
| `CoreManagerSchedulerAtom` | P31 Tomahawk | Frequency-Scaling, PE-Allocation |
| `MultiQueryPipelineAtom` | P33 VAMPIR | Compile-Time-Negotiation |
| `OptimisticLockingSchedulerAtom` | P03, P06, P08 | OLC |
| `RcuGracePeriodSchedulerAtom` | P29 McKenney | Grace-Period-basiert |
| `HazardPointerSchedulerAtom` | P30 Michael | Wait-free, kein Scheduler-Support |
| `HtmSchedulerAtom` | P08 ART-OLC | HTM mit Fallback |
| `BackgroundCheckpointAtom` | P03 Masstree | Per-Core Log-File, Background |
| `RebalanceAmortizationAtom` | P17 Bender | PackedMemoryArray Rebalance batchen |
| `RetroactiveAggregationSchedulerAtom` | P28-Mail | Periodische Counter-Propagation |

### 12.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **Wormhole 3-Class Scheduler** (P07) | `OptimisticLockingSchedulerCommand` (Klasse 1) + `RwLockSchedulerCommand` (Klasse 2) + `MutexSchedulerCommand` (Klasse 3) | `WormholeThreeClassSchedulerCompositionCommand` |
| **Tomahawk Core Manager** (P31) | `CoreManagerSchedulerCommand` + `FrequencyScalingCommand` + `PEAllocationCommand` + `DataTransferCommand` | `TomahawkCoreManagerSchedulerCompositionCommand` |
| **Kuehn Hot-Path Scheduler** (P28-Mail) | `RetroactiveAggregationSchedulerCommand` + `WorkerThreadAsyncCommand` + `OfflineSelfTuningCommand` | `KuehnHotPathSchedulerCompositionCommand` |

### 12.3 F-Mapping

C11 hostet F25 (SyncMechaniken-Scheduler-Bezug) und F24 (TelemetryDriven-Scheduler).

### 12.4 Verzeichnis-Struktur

```
cache_engine/scheduler/
├── tuning/             (OfflineSelfTuning, PeriodicGlobalReloc, RetroactiveAggregation)
├── worker/             (WorkerThreadAsync, BackgroundCheckpoint, MicroServer)
├── concurrency/        (OptimisticLocking, RcuGracePeriod, HazardPointer, Htm)
├── core_manager/       (CoreManager, FrequencyScaling, PEAllocation)
└── pipeline/           (MultiQueryPipeline, RebalanceAmortization)
```

---

## 13. C12 — Cache-Filter-Engine-Familie

**Concept-Klasse:** `ICacheFilterEngine`
**Dach-Idee:** Approximate-Membership-Filter mit One-Sided-Error-Garantie. Geschwister von ISearchPageStrategy. Spart I/O bei negativen Lookups.

### 13.1 Atomare Bausteine

| Atom-Baustein | Quelle | Beschreibung |
|---------------|--------|--------------|
| `BloomFilterAtom` | (klassisch) | Bloom-Filter |
| `SuRFFilterAtom` | P10 SuRF | SuRF mit FPR-Tuning |
| `CuckooFilterAtom` | (modern) | Cuckoo-Filter |
| `AdaptiveRangeFilterAtom` | (Litwin/Lomet ARF) | ARF |
| `SuRFBaseFilterAtom`, `SuRFHashFilterAtom`, `SuRFRealFilterAtom`, `SuRFMixedFilterAtom` | P10 SuRF | 4 Encoding-Varianten (Bezug zu C8 Encoding) |
| `FalsePositiveRateModelAtom` | P10 SuRF | FPR-Quality-Property |
| `FilterStorageMediumAtom` | P10 SuRF Sec 6 | DRAM/SSD/HDD-Layer |

### 13.2 Hybride Bausteine

| Hybrid | Aufloesung | Composition-Command |
|--------|------------|---------------------|
| **SuRF Filter-Pool mit FPR-Tuning** (P10) | `SuRFBaseFilterCommand` + `SuRFHashFilterCommand` + `SuRFRealFilterCommand` + `SuRFMixedFilterCommand` + `FalsePositiveRateModelCommand` | `SuRFFilterPoolCompositionCommand` |

### 13.3 F-Mapping

C12 hostet F29 (FilterStrategy) als zentrale Familie.

### 13.4 Verzeichnis-Struktur

```
cache_engine/filter/
├── bloom/              (Bloom)
├── surf/               (SuRF-Base/Hash/Real/Mixed)
├── cuckoo/             (Cuckoo)
├── arf/                (Adaptive Range Filter)
└── quality/            (FalsePositiveRateModel, StorageMediumBezug)
```

---

## 14. CROSS-FAMILIEN-AUFLOESUNGEN (Hybrid-Forschungs-Slot F15)

**Architektur-Vorgesehene Cross-Familien-Permutationen** (Forschungs-Ziel):

| Cross-Familien-Hybrid | Beteiligte Familien | Beispiel-Konkretisierung |
|------------------------|---------------------|--------------------------|
| **Trie-Page + B+-Layout + LOUDS-Encoding + Hot-Path-Heuristic** | C1 + C8 + C9 | F15 zentrales Beispiel — bisher nicht in Literatur |
| **Wormhole P07 (Hash + B+ + LinkedList)** | C1 + C8 + C11 | `TripleLayerLookupCompositionCommand` |
| **Masstree P03 (Slice-Trie + B+-pro-Layer)** | C1 + C3 + C4 | `MasstreeSliceLayeredCompositionCommand` |
| **B²-Tree P06 (Outer-B+ + Inner-Decision/Span)** | C1 + C8 + C4 | `B2TreeRecursiveCommonPrefixCompositionCommand` |
| **Fractal P22 (Cache-Tier + Disk-Tier + Dual-JumpPointer)** | C3 + C6 + C7 | `FractalHierarchicalCompositionCommand` |
| **Khan P23 + Mahling P25 (RuntimeAdaptive + Coroutine)** | C3 + C5 + C9 | `KhanMahlingAdaptiveCoroutineCompositionCommand` |
| **Block AO Production-Dispatch** (alle 12 Familien) | C1+...+C12 | `BlockAOProductionDispatchCompositionCommand` |

---

## 15. PERMUTATIONS-RAUM-ABSCHAETZUNG

**Vor REV5.1 (monolithische F-Familien):** 29 Familien × ~3 Konkretisierungen = ~100 Bausteine.

**Nach REV5.1 (12 ICacheEngine-Familien × atomare Bausteine):**
- C1 Layout: ~26 Atoms
- C2 Pinning: ~10 Atoms
- C3 Prefetch: ~25 Atoms
- C4 Coherence: ~12 Atoms
- C5 Telemetry: ~22 Atoms
- C6 Allocation: ~17 Atoms
- C7 Migration: ~12 Atoms
- C8 Encoding: ~28 Atoms
- C9 Heuristik: ~73 Atoms (vollstaendig in 13_md §9)
- C10 Topologie: ~17 Atoms
- C11 Scheduler: ~13 Atoms
- C12 Filter: ~9 Atoms

**Gesamt: ~264 atomare Bausteine + ~30 Hybrid-Composition-Commands.**

Cross-Familien-Permutationen (12 Familien, je ein Atom-Baustein gewaehlt) ergibt theoretisch >10^12 Permutationen — praktisch durch Kompatibilitaet-Constraints (siehe `IStrategyCompatibilityMatrix` in 11_md §4.1) auf ~10^4-10^5 valide Konfigurationen reduziert.

---

## 16. ZUSAMMENFASSUNG

**12 ICacheEngine-Familien (C1-C12) als Pendant zu ISearchEngine-Familien S1-S30:**

1. **C1 Cache-Layout** — Knoten-Format & Footprint (F1, F3, F4, F8, F11, F12, F13, F14, F15, F16, F17, F19, F22)
2. **C2 Cache-Pinning** — NUMA/Core/Tier-Bindung
3. **C3 Cache-Prefetch** — Latenz-Hiding (F4, F5, F6, F23, F26)
4. **C4 Cache-Coherence** — Reader/Writer-Asymmetrie & Sync (F18, F25)
5. **C5 Cache-Telemetry** — Mess- + Probe-Strategien (F23, F24)
6. **C6 Cache-Allocation** — Allocator + Tier-Auswahl (F1, F12, F21, F27)
7. **C7 Cache-Migration** — Tier-Migration & Compensation (F9, F19, F27)
8. **C8 Cache-Encoding** — Topologie + Bit-Packing (F2, F10, F16, F17, F19, F20)
9. **C9 Cache-Heuristik** — Decision-Logik + Cost-Modell (orthogonal)
10. **C10 Cache-Topologie** — Plattform-Probe + Discovery (Saeule-B-Adapter)
11. **C11 Cache-Scheduler** — Background-Worker + Trigger (F24, F25)
12. **C12 Cache-Filter** — Approximate-Membership (F29)

**Gesamt-Verzeichnis-Struktur:**
```
cache_engine/
├── layout/      (C1, ~11 Sub-Verzeichnisse)
├── pinning/     (C2, 4 Sub)
├── prefetch/    (C3, 8 Sub)
├── coherence/   (C4, 5 Sub)
├── telemetry/   (C5, 6 Sub)
├── allocation/  (C6, 6 Sub)
├── migration/   (C7, 5 Sub)
├── encoding/    (C8, 6 Sub)
├── heuristic/   (C9, 9 Sub)
├── topology/    (C10, 4 Sub)
├── scheduler/   (C11, 5 Sub)
└── filter/      (C12, 5 Sub)
```

**Architektur-Konformitaet zu REV5.1:**
- Plattform-AGNOSTISCH im Code, plattform-KONKRET im Verhalten (REV3 K3.2)
- Hybrid-Konkretisierungen IMMER via Command-Pattern aufgeloest (REV3 K3.4)
- 12 Familien sind ORTHOGONAL — Cross-Familien-Permutationen sind das Forschungs-Ziel (F15)
- Jede Familie = eigene Sub-Engine mit eigenem `ICache<Familie>Engine`-Interface
- Auto-Discovery (5-Schritt: Discover/Measure/Classify/Publish/Bind) zentral in C10

**Bezug zu PRT-ART-Innovation:**
- LeafOnlyCounter / LeafOnlySampledCounter / RetroactiveAggregation (P28-Mail) → C5 Telemetry + C11 Scheduler
- ProbabilityHintsHeader (PRT-ART eigen) → C5 Telemetry + C8 Encoding
- Cross-Familien-Permutationen ueber 12 Familien = F15-Forschungs-Slot
