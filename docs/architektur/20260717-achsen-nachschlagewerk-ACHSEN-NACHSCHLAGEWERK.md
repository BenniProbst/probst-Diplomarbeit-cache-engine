# ACHSEN-NACHSCHLAGEWERK — CacheEngine (Stand nach INC-2c)

## (0) Kopf

**Zweck.** Konsolidiertes Übersichts-Nachschlagewerk *aller* Achsen des CacheEngine-Systems über die fünf orthogonalen Dimensionen (System-Konfig · Organ/Komposition · Gattung/Genus · Messung · Compile-/Registry-XML). Synthese aus 172 kartierten Achsen-Einträgen. Referenz gegen Überblicksverlust — jede Zeile mit Quelle.

**Stand INC-2c (gerade abgeschlossen).** Telemetrie aus der binary_id herausgelöst → Organ-Achsen **19 → 18**; ABI-Major **4 → 5** (ce `86769bc9`), Observer-POD-Version **5 → 6**, `sizeof` **1416 → 1344** (−72); golden-Roundtrip **== 320 intakt** (telemetry war single-enabled → nur Segmentzahl 19→18, Kardinalität unverändert). Das Telemetrie-*Organ* (`axes/telemetry_axis`) lebt weiter als Mess-Infrastruktur, permutiert aber nicht mehr.

**Lesehinweis.**
- **ce-Wurzel (absolut)** = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine`. Alle `quelle`-Pfade sind relativ dazu (Ausnahmen: `measurement/…`, `docs/…`, XML unter `Code/…`, ausdrücklich vermerkt).
- **Ausprägungs-Zahlen = `AllStrategies`/`All*`-Registry-Inventar** (Design-Space-Kardinalität), NICHT die per Build-Flag `Enabled`-Teilmenge. Wo golden pinnt, ist der gepinnte Wert = `mp_take_c<Enabled,1>` = erste enabled Variante.
- **binary_id-Disziplin.** NUR die 18 Organ-Achsen permutieren die binary_id. Alle System-/Compile-/Shape-Achsen sind binary_id-orthogonal; ihre Provenienz gehört ins **H-10-Sidecar** (`system_axes_version_suffix` in `build_version`), NIE in die binary_id.
- **honest-0.** Nicht real gemessene Kategorien liefern ehrliche 0 (kein Schein-0), s. §4.

**Gesamt-Zählung je Ebene (kanonisch).**

| Ebene | Kanon-Zahl | Bestandteile |
|---|---|---|
| System-Konfig (CEB) | **6** Haupt (+3 Wurzeln) | Scheduling · Hardware/ISA · Telemetrie · Last/Frameworks · Compiler · Erweiterungshardware; Wurzeln: `Axis<Derived>` (Dach), `CebSystemAxis` (Konfig-Root), `SystemAxis` (Mess-„Blut"-Root) |
| Organ / Komposition | **18** (T0..T17) | binary_id-permutierend, `kCompositionAxisNames` |
| Gattung — Ebene-1 (AnatomyGattung) | **3** | SearchAlgorithm · Container · Graph |
| Gattung — Ebene-2 (Genus) | **5** | SearchAlgorithm · Set · Sequence · Adapter · View |
| Mess-Dimensionen (Grundmodell) | **3** | D1 Wall-Clock · D2 Observer · D3 vs std::map |
| Mess-Kategorien | **16** | 9 TimeObserver + 7 PmcCounter |
| System-Mess-Kollektoren | **3** | WallClock · ObserverSnapshot · Pmc |
| Build/Shape (nicht binary_id) | **7** | page_type · simd_extension(09b) · general_hardware(12) + 4 node-shapes (btree/skip/bst/hash) |

---

## (1) SYSTEM-ACHSEN (CEB-Konfig-Achsen)

Alle System-Achsen: **binary_id? = NEIN** (immer H-10-Sidecar `system_axes_version_suffix`, ABI-neutral). Nur **Erweiterungshardware** ist bau-treibend (Flag-QUELLE); Hardware/ISA ist reiner Host-Deskriptor.

### 1a — Die 6 CEB-Konfig-Achsen + Wurzeln

| Haupt-Achse | Unter-Achsen | Ausprägungen | Status | binary_id? | Quelle |
|---|---|---|---|---|---|
| `Axis<Derived>` (gemeinsames Dach) | — | AxisKind-Diskriminator (organ / system_measurement / system_config); empty base, kein vtable | gebaut | — | `topics/axis.hpp:16-38` + LEDGER:1916 (Q1) |
| `CebSystemAxis<Derived>` (Konfig-Root, Elter der 6) | — | `axis_kind()==system_config`; `axis_label()` compile-time; static dispatch | gebaut | NEIN | `measurement/ceb_system_axis.hpp:21-37` |
| `SystemAxis<Derived>` (Mess-„Blut"-Root, Geschwister) | WallClock/ObserverSnapshot/Pmc | 3 Mess-Kollektoren, Regime 2, 16 Kategorien | gebaut | NEIN | `measurement/system_axis.hpp:148-194` |
| **Scheduling (#37)** — `SchedulingSystemAxis` | worker_pool_layout · simd_worker_count_limit · hetero_core_dispatch · co_routine_strategy · batch_granularity · thread_count · *ISchedulingStrategy(depr.)* | 1 konkret (DefaultScheduling) + 5 constexpr Sub-Dim | gebaut (Header); Consumer-Wiring geplant | NEIN | `measurement/scheduling_system_axis.hpp:22-74` + LEDGER:429 S-1 |
| **Hardware/ISA** — `HardwareIsaSystemAxis` (Host-Deskriptor+Mess-Gate) | host_isa · Laufzeit-Capability-Gate(cpuid) · general_hardware | 1 konkret (Amd64, host_isa=`x86_64`); geplant aarch64/riscv64 | gebaut (Rahmen) | NEIN (e18-⟂) | `measurement/hardware_isa_system_axis.hpp:19-40` + §19.A Q2 |
| **Telemetrie** (INC-2c herausgelöst) | TelemetryConfig Active/Silent · Telemetrie-ORGAN-Varianten(Legacy) | Active/Silent (2); als AxisLevel „telemetry", KEIN CRTP-Header | gebaut | **ENTFERNT** (war Organ-Slot T10 → 18 Slots) | `registry_to_axis_levels.hpp:110-118` + `composition_factory.hpp:44-49` + INC-2c |
| **Last/Frameworks (H-9)** — `LoadFrameworkSystemAxis` | workload (dynamisch) | 1 konkret (Ycsb, framework_id=`ycsb`) | gebaut (Header); Wiring geplant | NEIN | `measurement/load_framework_system_axis.hpp:21-46` + §17-F4 |
| **Compiler (gcc\|clang)** — `CompilerSystemAxis` (5.) | compiler_id · driver_default · supports_fno_gnu_unique · opt-level · Flags · Commands · Laufzeit-Verfügbarkeit(S-6) | 2: Gcc(g++-16) / Clang(clang++-22) | gebaut + verdrahtet (+cxx=) | NEIN | `measurement/compiler_system_axis.hpp:22-57` + §19.A Q3 |
| **Erweiterungshardware (SIMD→GPU)** — `ExtensionHardwareSystemAxis` (6.) | simd_extension_id · gcc_march_flag · clang_march_flag · simd_extension(09b) · HW-Erw.-Unterachsen(deep research) | 3: Generic(no_extension) / Avx2(-mavx2) / Avx512(-mavx512f) | gebaut + verdrahtet (+ext=) | NEIN | `measurement/extension_hardware_system_axis.hpp:23-71` + Q2 Option C |

**Nicht eine der 6, aber in `build_system_axis_levels()`:**

| Achse | Ausprägungen | Status | binary_id? | Quelle |
|---|---|---|---|---|
| `page_type` (build-only System-Schicht) | 6: DenseByte / ExtendedDense / SparsePatricia / Redirect / CustomCache / BPlus | gebaut | NEIN (orthogonal) | `axis_01_page_type_registry.hpp:20-26` + `registry_to_axis_levels.hpp:69/115` |
| `system_axes_version_suffix` (H-10-Träger) | `"+ext=<policy>+cxx=<driver>"`; +opt= geplant | gebaut | NEIN (Sidecar-Mechanismus) | `profile_run_facade.cpp:167-174,229,405` |

### 1b — System-Achsen-Unterachsen (Detail)

| Unter-Achse | Parent | Ausprägungen | Status | Quelle |
|---|---|---|---|---|
| worker_pool_layout | Scheduling | 4: ThreadPerCore/WorkStealing/CpuPinning/FreePool | gebaut | `concepts/scheduling_strategy.hpp:36` |
| simd_worker_count_limit | Scheduling | `size_t` (Default 2) | gebaut | `scheduling_system_axis.hpp:29-31/64` |
| hetero_core_dispatch | Scheduling | 4: None/HybridAware/PCoresOnly/ECoresOnly | gebaut | `concepts/scheduling_strategy.hpp:39` |
| co_routine_strategy | Scheduling | 3: None/Interleave/DependencyTracking | gebaut | `concepts/scheduling_strategy.hpp:42` |
| batch_granularity | Scheduling | 3: Single/MicroBatch/MacroBatch | gebaut | `concepts/scheduling_strategy.hpp:45` |
| thread_count (Runtime) | Scheduling | dyn. RC-POD-Wert | geplant | Bauplan INC-1c (RC-POD) |
| `ISchedulingStrategy` (Runtime-vtable) | Scheduling | 5 pure-virtual Getter; 0 Konsumenten | **deprecated** | `concepts/scheduling_strategy.hpp:56-64` |
| host_isa | Hardware/ISA | 1: x86_64 (+geplant aarch64/riscv64) | gebaut | `hardware_isa_system_axis.hpp:24/38-40` |
| Laufzeit-Capability-Gate (cpuid) | Hardware/ISA | Binary-ISA ⊆ Host-Capability | geplant | `hardware_isa_system_axis.hpp:6-7` |
| general_hardware | Hardware/ISA | 3: Generic/X86_64/Aarch64 | gebaut (build-only) | `topic_hardware_config_set.hpp:105-106` + `registry_to_axis_levels.hpp:71/117` |
| TelemetryConfig Active/Silent | Telemetrie | 2: Active/Silent | gebaut | `composition_factory.hpp:47` |
| Telemetrie-ORGAN-Varianten (ex-T10) | Telemetrie | 4: LeafOnlyCounter/DensityTracker/InsertCounter/LatencyHistogram | Legacy (Mess-Infra) | `axis_11_telemetry_registry.hpp:18,23` |
| workload | Last/Frameworks | YCSB ycsb_a..ycsb_f (dyn., is_static=false) | gebaut | `load_framework_system_axis.hpp:29` + `experiment_run_entry.hpp:145-147` |
| compiler_id | Compiler | 2: gcc/clang | gebaut | `compiler_system_axis.hpp:26/48/54` |
| driver_default | Compiler | 2: g++-16/clang++-22 (env COMDARE_CXX override) | gebaut | `compiler_system_axis.hpp:28/49/55` |
| supports_fno_gnu_unique (Dialekt-Gate) | Compiler | 2: gcc=true/clang=false (hartes Bau-Gate) | gebaut | `compiler_system_axis.hpp:30/50/56` + `build_orchestrator.hpp:479` |
| **opt-level** (dyn. XML-Unterachse) | Compiler | 5: O0/O1/O2(Ist)/O3/Ofast | **geplant** (INC-2c.opt) | `axis_library_registry.hpp:347-356` + LEDGER:1922 |
| Flags (je Compiler) | Compiler | XML-permutierbar, je Compiler verschieden | geplant | LEDGER:430 F3i |
| Commands (je Compiler) | Compiler | XML-permutierbar, je Compiler verschieden | geplant | LEDGER:430 F3i |
| Laufzeit-Verfügbarkeit (S-6) | Compiler | welche Compiler am Runner (`.toolchain-probe`) | geplant | LEDGER:429 S-6 + ADDENDUM §2.2 |
| simd_extension_id | Erweiterungshardware | 3: no_extension/avx2/avx512 | gebaut | `extension_hardware_system_axis.hpp:28` |
| gcc_march_flag | Erweiterungshardware | 3: ``/-mavx2/-mavx512f | gebaut | `extension_hardware_system_axis.hpp:32` |
| clang_march_flag | Erweiterungshardware | 3: ``/-mavx2/-mavx512f | gebaut | `extension_hardware_system_axis.hpp:33` |
| simd_extension (09b, deklarativ) | Erweiterungshardware | 8: NoExt/Sse2/Avx2/Avx512/Neon/Sve2/Rvv/CudaGh200 (CRTP zeigt 3) | gebaut (build-only) | `topic_hardware_config_set.hpp:26/101-103` |
| HW-Erweiterungs-Unterachsen (max SIMD) | Erweiterungshardware | Umfang offen (deep research) | geplant | memory `project_compiler_systemachse_traegt_dynamische_xml_unterachsen` |

---

## (2) ORGAN-ACHSEN (T0..T17, Komposition)

Autoritative Reihenfolge = `kCompositionAxisNames` `std::array<…,18>` (`axis_path_serialization.hpp:31-34`) = AdHocComposition-Slots (`composition_factory.hpp:55-94`, `static_assert sizeof...==18`). Observer-POD-Schema = `kV3AxisSchema[18]` (`observable_tier.hpp:67-103`). Alle 18 seit Phase B (2026-06-04) befüllt (`kV3FilledAxisCount=18`).

| T | Achse | Ausprägungen (All) | Sub-Achsen | Observer-Felder | golden-Faktor | Quelle |
|---|---|---|---|---|---|---|
| T0 | search_algo | **22** (4 enabled-default) | per-K K2/K4/K8/K16 (gated) | 6: lookup/hit/miss/insert/erase/peak | **×4 (FREI, KSearch)** | `axis_03a_search_algo_registry.hpp:54-88` |
| T1 | cache_traversal | 3: LinearFanout/HashLookup/BinarySearchFanout | — | 8: resolve/hit/miss/register/unregister/peak_tracked/batch_size/batch_visited | ×1 gepinnt `linear_fanout` | `axis_03b_cache_traversal_registry.hpp:18-24` |
| T2 | mapping | 2: DirectPlacement/PoolRelative (MP03/MP04 TABU) | — | 7: register/resolve/hit/miss/reverse_lookup/peak_mapped/indirect_steps | ×1 gepinnt `direct_placement` | `axis_03m_mapping_registry.hpp:16-32` |
| T3 | path_compression | 3: None/Patricia/ByteWise | — | 5: compress/prefix_len/bytes_saved/cuts/checksum | ×1 gepinnt `path_compression_none` | `axis_02_path_compression_registry.hpp:17` |
| T4 | node_type | 4: Node4/16/48/256 | btree_order · skip_list_shape · bst_shape · hash_probe_shape · page_type(build) | 4: find/keys_stored/queries/checksum | **×4 (FREI, KNode)** | `axis_04_node_type_registry.hpp:18` |
| T5 | memory_layout | 5: CacheLineAligned/AoSStrict/SoA/PackedBitmap/AoSoA | — | 5: scan/records/field_bytes/cache_lines/checksum | **×5 (FREI, KLayout)** | `axis_05_memory_layout_registry.hpp:36-37` |
| T6 | allocator | **26** Vendor (3 enabled im Registry) | — (DLL-Load Option B, Arena-Isolation) | 6: bytes_alloc/bytes_in_use/alloc_cnt/dealloc_cnt/fail/budget_reject | ×1 gepinnt `std_malloc` | `axis_06_allocator_registry.hpp:78-102` |
| T7 | prefetch | 4: None/DistanceEstimator/Hardware/PathOriented | — | 5: trigger/suggestions/hot_path_hints/max_queue_depth/addrs_enqueued | **×4 (FREI, KPrefetch)** | `axis_07_prefetch_registry.hpp:18` |
| T8 | concurrency | 9: None/Blocking/ReaderWriter/OlcOptimistic/LockFree/WaitFree/Rcu/HazardPtr/OlcReservedBlocks | — | 5: acquire/release/contention/validation_fail/pattern_id | ×1 gepinnt `concurrency_none` | `axis_08_concurrency_registry.hpp:23-25` |
| T9 | serialization | 4: RawBinary/VarLen/Succinct/Compressed | — | 4: serialize/records/bytes/checksum | ×1 gepinnt `serialization_raw_binary` | `axis_10_serialization_registry.hpp:19` |
| T10 | value_handle | 5: Inline/ExternalPool/ImmutableSharedRef/VersionedPointer/ChainRef | — | 4: access/indirect_deref/version_strips/peak_chain_depth | ×1 gepinnt `value_handle_inline` | `axis_14_value_handle_registry.hpp:19-20` |
| T11 | isa | 4: Amd64/Aarch64/RiscV/PowerPc | simd_extension(09b) · general_hardware(12) | 5: simd_calls/elements/simd_iters/scalar_fallback/checksum | ×1 gepinnt `isa_amd64` | `axis_09_isa_registry.hpp:18` |
| T12 | index_organization | 4: Heap/Clustered/NonClustered/Iot | — | 5: scan/records/predicate_evals/indirect_lookups/checksum | ×1 gepinnt `index_org_heap` | `axis_01_index_organization_registry.hpp:19` |
| T13 | io_dispatch | 4: InMemoryOnly/DirectIo/BufferedIo/MmapIo | — | 5: rounds/bytes/align_adjusts/dispatch_cnt/checksum | ×1 gepinnt `io_in_memory_only` | `axis_io_registry.hpp:18` |
| T14 | migration_policy | 4: None/HotCold/TierBased/Adaptive | IMigratableTier (Sub-Interface, #123) | 5: decisions/migrations/hot_votes/cold_votes/tier_moves | ×1 gepinnt `migration_none` | `axis_migration_registry.hpp:18` |
| T15 | filter | 4: Bloom/Cuckoo/RangeSurf/Xor | — | 5: probe/pos/neg/hash_probes/checksum | ×1 gepinnt `filter_bloom` | `axis_filter_registry.hpp:18` |
| T16 | queuing_q1 (buffer_strategy) | **15**: NoBuffer/FIFO/LIFO/BoundedRing/AppendOnly/PriorityHeap/DeltaChain/Skiplist/Tombstone/CopyOnWrite/Epoch/BatchedInsert/LockFreeSPSC/LockFreeMPMC/OrigLockFreeMpmc | — | 5: put/get/overflow/underflow/peak_size | ×1 gepinnt `no_buffer` | `axis_q1_queuing_registry.hpp:38-53` |
| T17 | queuing_q2 (flush_policy) | 5: Eager/Watermark/Lazy/Timed/AdaptiveLsm | — | 5: decisions/full_flush/partial_flush/no_flush/flush_complete | ×1 gepinnt `eager_flush` | `axis_q2_queuing_registry.hpp:21-29` |

**Organ-Sub-Achsen (nicht binary_id-Slot; node-shape default-OFF, DefinitionOnly):**

| Sub-Achse | Parent | Ausprägungen | Status | Quelle |
|---|---|---|---|---|
| search_algo per-K (K2/K4/K8/K16) | search_algo | 4 compile-time-K Wrapper (S18-S21) | gated (default OFF, #188) | `axis_03a_search_algo_registry.hpp:79-84` |
| btree_order | node_type | 5: Kt2/Kt3/Kt4/Kt8/Kt16 | gebaut, DefinitionOnly (#234-K) | `axis_btree_order_registry.hpp:18` |
| skip_list_shape | node_type | 4: Max16P50/Max8P50/Max32P50/Max16P25 | gebaut, DefinitionOnly | `axis_skip_list_shape_registry.hpp:17` |
| bst_shape | node_type | 3: PtrSizeT/PtrU32/PtrU16 | gebaut, DefinitionOnly | `axis_bst_shape_registry.hpp:16` |
| hash_probe_shape | node_type | 4: OaLf70/OaLf50/OaLf90/Chaining | gebaut, DefinitionOnly | `axis_hash_probe_shape_registry.hpp:17` |
| page_type | node_type | 6 (build-only, s. §1/§3) | gebaut, build-only | `axis_01_page_type_registry.hpp:20-21` |
| simd_extension | isa | 8 (build-only → 6. System-Achse) | gebaut, build-only | `axis_09b_simd_extension_registry.hpp:22-23` |
| general_hardware | isa | 3 (build-only) | gebaut, build-only | `axis_12_general_hardware_registry.hpp:42` |
| telemetry | (ex-T10, herausgelöst) | 4 Varianten + Active/Silent | INC-2c: KEIN Slot mehr → System-Achse | `axis_11_telemetry_registry.hpp:18` |

> Varianten-Summe der 18 Komposition-Achsen (All): **127 Strategien**. Voll-Permutation `all_axes_binary_count() == 137.594.142.720.000` (`registry_to_axis_levels.hpp:145-159`, über `Enabled`).

---

## (3) GATTUNGS-ACHSEN-MATRIX (5 Ebene-2-Genera)

**3-Ebenen-Modell** (`anatomy_base.hpp:30-109`): **Ebene 1 AnatomyGattung** = Außen-Interface/Prüf-Dock = **3** (SearchAlgorithm | **Container** | Graph). **Ebene 2 AnatomyGenus** = Tier-Unterklasse = **5** (SearchAlgorithm | Set | Sequence | Adapter | View); Set/Sequence/Adapter/View hängen an Container. User-Begriff „Gattung" ≈ umgangssprachlich Ebene-2 Genus. Cross-Genus type-unmöglich (jedes eigene Komposition + Anatomie + Observer + z.T. ABI).

| Genus (Tier-Metapher) | slot_count | Achsen-Satz (Organ-Achsen) | Eigene Achse(n) | Lässt weg | Quelle |
|---|---|---|---|---|---|
| **SearchAlgorithm** (Mammal) | **18** | VOLLER Satz T0..T17 (16 core + q1/q2) | keine (voll); `axis_names()` = direkt `kCompositionAxisNames` | — | `genus_binding_traits.hpp:36-52` |
| **Adapter** (Invertebrate) | **12** | search_algo, cache_traversal, memory_layout, allocator, prefetch, concurrency, serialization, value_handle, isa, io_dispatch, migration_policy, **inner_container** | inner_container (3 Substrate) | mapping, path_compression, node_type, index_organization, filter, queuing, telemetry; KEINE ordering-Achse | `genus_binding_traits.hpp:59-80` + `adapter_anatomy.hpp:112-133` |
| **Set** (Bird, K-only K=V) | **14** | search_algo, cache_traversal, path_compression, node_type, memory_layout, allocator, prefetch, concurrency, serialization, isa, index_organization, io_dispatch, migration_policy, filter | KEINE (durch Absenz charakterisiert) | mapping, value_handle, queuing, telemetry | `genus_binding_traits.hpp:85-106` + `set_composition.hpp:14-38` |
| **Sequence** (Reptile, V-indexed) | **10** | memory_layout, allocator, prefetch, concurrency, serialization, value_handle, isa, io_dispatch, migration_policy, **growth_policy** | growth_policy | search_algo, cache_traversal, mapping, path_compression, node_type, index_organization, filter, queuing, telemetry | `genus_binding_traits.hpp:111-131` + `sequence_composition.hpp:31-50` |
| **View** (Plant, non-owning) | **6** | memory_layout, value_handle, isa, **extent_policy**, **layout_policy**, **accessor_policy** | extent/layout/accessor (mdspan §26.6) | allocator, concurrency, alle K-Such-/Node-Achsen, queuing, telemetry | `genus_binding_traits.hpp:136-155` + `view_composition.hpp:44-59` |

**⚠ Stale k*SlotCount-Konstanten (post-INC-2c NICHT nachgezogen, +1 telemetry):** `set_composition.hpp:61` =15 · `sequence_composition.hpp:68` =11 · `view_composition.hpp:73` =7 · `adapter_anatomy.hpp:153` =13. **Belastbar ist NUR struct-internes `slot_count` + `axis_names().size()`.**

### Genus-eigene Achsen (Detail)

| Achse | Genus | Ausprägungen | Status | Quelle |
|---|---|---|---|---|
| inner_container | Adapter | 3: DequeInner(Default) / VectorInner / HeapInner (Priority-Disziplin INNERHALB, keine ordering-Achse) | gebaut | `adapter_anatomy.hpp:37-96` |
| growth_policy | Sequence | 1 gebaut: DoublingGrowth(×2); geplant GoldenRatio/FixedChunk/Exact | gebaut (Default) | `sequence_composition.hpp:15-29` |
| extent_policy | View | 1 gebaut: DynamicExtent; geplant statisch | gebaut (Default) | `view_composition.hpp:17-21` |
| layout_policy | View | 1 gebaut: LayoutRight; geplant layout_left/stride | gebaut (Default) | `view_composition.hpp:22-26` |
| accessor_policy | View | 1 gebaut: DefaultAccessor; geplant aligned | gebaut (Default) | `view_composition.hpp:27-31` |

### BUILD/SHAPE-Achsen (binary_id-orthogonal)

| Achse | Ausprägungen | binary_id? | Emission | Quelle |
|---|---|---|---|---|
| page_type | 6: DenseByte/ExtendedDense/SparsePatricia/Redirect/CustomCache/BPlus | NEIN (build_system_axis_levels) | System-Schicht Ordner/Sidecar | `registry_to_axis_levels.hpp:69/115` |
| simd_extension (09b) | 8 (Q2: CEB permutiert selbst; ISA×SIMD-Constraint #704) | NEIN (Q2-Ruling) | Flags an CompileFn, H-10-Sidecar | `registry_to_axis_levels.hpp:70/116` |
| general_hardware (12) | 3: Generic/X86_64/Aarch64 (ISA×Plattform-Constraint) | NEIN | System-Schicht | `registry_to_axis_levels.hpp:71/117` |
| btree_order (T22) | 5: Kt2/Kt3/Kt4/Kt8/Kt16 | NEIN (Codegen-Variante) | optional NACH q2 via `with_shape_segment`; Shape=void → byte-identisch | `registry_to_axis_levels.hpp:74/126` |
| skip_list_shape (T23) | 4 | NEIN | wie btree_order | `registry_to_axis_levels.hpp:75/127` |
| bst_shape (T24) | 3 | NEIN | wie btree_order | `registry_to_axis_levels.hpp:76/128` |
| hash_probe_shape (T25) | 4 | NEIN | wie btree_order | `registry_to_axis_levels.hpp:77/129` |

> binary_id-Dreiteilung: (1) Organ/Komposition permutiert · (2) System-Schicht (page_type/simd_extension/general_hardware/telemetry) orthogonal · (3) Shape-Achsen = Codegen-Varianten derselben Struktur, default-OFF, byte-identischer golden_320 wenn `Shape=void`.

---

## (4) MESS-ACHSEN

> **§47/§54-T2-SEKTIONS-NACHTRAG (2026-07-20, A10 — additiv; die Tabelle unten bleibt gültig):** Diese Sektion listet die Mess-Dimensionen als flache Registry-/CSV-Sicht. Architektur-kanonisch (§47/§54-T2) gilt die Haupt-/Unter-Zweiteilung: **HAUPT = Mess-TOOLING {nur Wallclock · Makro-Benchmarks · Micro-Benchmarks über die Observer}** (statisch/CT, je Wahl eine eigene CEB-Strecke `ceb:build:[a,b,c]`, Stempel §43) — die heute fehlende Auffächerungs-Achse. **UNTER (Planer-gesteuert, delegiert, manifestieren sich als CSV-Spalten) = Ablaufmethodik {Debug/Messen/Release} · Workloads/Datasets (YCSB A–F × Datasets) · die 16 measurement_categories · Rückschrieb-Methoden.** Die 16 Kategorien, W/D/K und die Granularität in den Zeilen unten sind demnach UNTER-Achsen bzw. deren CSV-Projektion, NICHT die Mess-HAUPT-Achse (§28-Mess-Registry-Angebot, §55-PFLEGE-HINWEIS).

| Achse / Dimension / Kategorie | misst was | Ausprägungen | ct/rt | Quelle |
|---|---|---|---|---|
| **Mess-Dimensionen (3-fach)** | Grundmodell | 3: D1/D2/D3 | — | `24_messmodell_korrektur §2` |
| D1 Wall-Clock | Latenz-Kurven r/w/d(+scan/rmw)+RAM+Disk | steady_clock, total_ns/cycles | rt | `24_..§2.1` + `workload_orchestrator.hpp:42-55` |
| D2 Per-Achsen-Observer | observe_all → Statistics-Trace `axis_stats[18][8]` | je Achse `statistics()` | rt (nur MEASUREMENT_ON) | `24_..§2.2` + `observable_tier.hpp:129-185` |
| D3 vs std::map | welche Variante besser (Korrektheit) | verify_matches_std_map (kein Latenz-Bench) | ct/Unit-Test | `24_..§2.3` |
| **Mess-Pfade A/B** | Mess-Konfiguration wählt Pfad | 2: A (isoliert in-DLL) / B (Composite Observer-Pull) | — | `24_..§8.1` |
| Pfad A | isolierte Achsen-Algorithmen | Welch/MWU/Cliff's-δ | rt | `measurable_workload.hpp` |
| Pfad B | Composite über Modul-Binary-ABI | D1+D2 korreliert in EINEM Lauf | rt | `24_..§8.6-8.7` + `workload_orchestrator.hpp:65-164` |
| Observer-Trigger-Modi | wann Snapshot | 2: Zeitschritt-Sync / Zustands-Manipulation | rt | `24_..§8.7` |
| Zwei-Phasen-Messung | Memento save/rollback pro Op | save-all→warmup→rollback→measure | rt (MEASUREMENT_ON) | `workload_orchestrator.hpp:75-160` |
| **Drei Profile** | BUILD⊥LAST⊥COMPILE-RELEASE | 3 | — | `messarchitektur_v5_drei_profile.md` |
| BUILD-Profil | welche DLLs/Permutationen | smoke/medium/full | ct (configure) | `..drei_profile.md Z.12` |
| LASTENPROFIL (Achse 2) | Testdaten/Op-Mix/Umfang/Verteilung | WorkloadConfig+Generator (xorshift64) | rt | `workload_config.hpp:99-146` |
| COMPILE-RELEASE | Messung an/aus | 2: MEASUREMENT_ON / RELEASE | ct (cmake) | `..drei_profile.md Z.14,32-40` |
| **Mess-Kategorien (16)** | System-Achsen „Blut" | 16 (9 Time + 7 Pmc) | — | `measurement_category.hpp:10-32` |
| Regime TimeObserver (9) | zeit-/observer-basiert, immer | CLU, MEMORY_FOOTPRINT, LATENCY_MEAN/P50/P95/P99/P999, THROUGHPUT, FILL_BUFFER | rt | `system_axis.hpp:43-53` |
| Regime PmcCounter (7) | PMC-basiert, extern-gated | CACHE_MISS_L1/L2/L3, DTLB_MISS, BRANCH_MISS, IPC_CPI, ENERGY_J | rt (gated #26) | `system_axis.hpp:37-41` |
| Latenz-Perzentile | Nearest-Rank | 5: MEAN+P50+P95+P99+P999 | rt (Op-Kind real; System-Achse honest-0) | `measurement_snapshot.hpp:78-87` |
| Cache-Miss-Ebenen | PMC | 3: L1/L2/L3 (+DTLB) | rt (honest-0 ohne PmcSource) | `pmc_source.hpp:19-27` |
| **Mess-Granularität** | Trennbarkeits-Problem | 3: Micro / Makro / Gesamt | — | `06_evaluation_methodology.tex:26-37` |
| Micro-Benchmarking | Achse isoliert über Kategorie-Interface | kRunOps=1000×kReps=10 | rt (aktiv, 43/43 smoke) | `06_..:27-28` |
| Makro-Benchmarking | einzelne std::map-Ops | insert/lookup/erase/scan/rmw ns | rt (Op-Kind-Trennung) | `06_..:28-30` |
| Gesamt-Benchmarking | YCSB über jede Rekombination | 7-Phasen ExperimentDriver | rt (gated #156) | `06_..:30-31,39-48` |
| **Mess-Reihen** | messung_driver/ExperimentDriver | 3: A (PRT-ART vs SOTA) / B (Achsen-Variation) / C (Merge/Regression) | — (jede ×3 Granularität) | `06_..:6-24` |
| Reihe-A Modi | SOTA-Umfang | 2: A_defined(8) / A_full(30, Standard) | rt | `06_..:13-16` |
| **Workload-Achse (Achse 2)** | LASTENPROFIL | 8 Tokens: A/B/C/D/E/F + IH/LH | rt | `workload_profiles.hpp:20-35` |
| YCSB-Varianten A-F | skewed Key-Verteilung | A(50/50) B(5/95) C(100%R) D(95/5 Latest) E(95%Scan) F(RMW) +IH/LH | rt | `workload_config.hpp:179-288` |
| Op-Kind (6) | einzelne Op der Sequenz | Insert/Lookup/Erase/Clear/Scan/RMW | rt | `workload_config.hpp:26-34` |
| Op-Type-Profile (OP-1..6) | XSD-Enumeration (required) | Read/Insert/Update/Scan/RMW/RangeDelete | rt (Tabelle+Validator) | `op_type_filter.hpp:63-76` |
| KeyDistribution (3) | YCSB-Definitionsmerkmal | Uniform/Zipfian(θ≈0.99)/Latest | rt | `workload_config.hpp:46-50` |
| WorkloadConfig-Parameter | Op-Mix/Range/Skew | seed=42, num_ops, key_min/max, pct_*, scan_length_max, zipfian_theta, negative_query_pct | rt | `workload_config.hpp:99-146` |
| **Mess-Input W/D/K (E4-XML)** | additive Mess-INPUTs | 3: W(Workload)/D(Dataset)/K(Category) | rt-deklarativ (binary_id-neutral) | `xml_config_parser.hpp:166-303` |
| W — Workloads | XML-Filter | YCSB A..F | rt | `xml_config_parser.hpp:201/298` |
| D — Datasets (GO-5) | akte_ref → test_data-AKTE | string_corpus / sosd_uint64 | rt (Mess-Konsum lauf-gated) | `xml_config_parser.hpp:166-180` |
| K — Measurement-Categories (INC-3) | Spalten-Projektion über 16 | `<category name=..>*` | rt | `xml_config_parser.hpp:235-245` |
| **DynamicDims (E1, KF-9)** | Runtime-Kartesik EINER Binary | is_static=false → binary_id unverändert | rt | `runtime_variable_loop.hpp:1-113` |
| thread_count | RC-POD | 1/2/4 (Mess=1-Thread) | rt | `runtime_variable_loop.hpp:53-54` |
| prefetch_distance | RC-POD | N | rt | `runtime_variable_loop.hpp:55-56` |
| pool_budget_bytes | RC-POD | Bytes | rt | `runtime_variable_loop.hpp:57-58` |
| batch_size | RC-POD | N | rt | `runtime_variable_loop.hpp:59-60` |
| inline_threshold_bytes | RC-POD | Bytes | rt | `runtime_variable_loop.hpp:61-62` |
| hw_prefetcher (architektonisch) | MSR 0x1A4 (KEIN POD-Feld) | all_on/adjacent_off/all_off | rt (Label; MSR Cluster-gated) | `runtime_variable_loop.hpp:11-13,63` |
| repetition | NIE interpoliert, separat | 0..repetitions-1 (Default 3) | rt | `repetition_plan.hpp:18-53` |
| workload (DynDim) | zwingend für two_phase_valid | workload_id | rt | `experiment_run_entry.hpp:147-159` |
| fixed_conditions | Mess-Umgebung gepinnt | turbo/smt/aslr/numa/governor | rt (Deklaration) | `xml_config_parser.hpp:211` |
| working_set_sweep | äußere N-Schleife (Füllstand) | N-Liste; leer=einmalig | rt | `xml_config_parser.hpp:222-225` |
| **Mess-POD-Schemata** | Serialisierung (memcpy über DLL) | 3 PODs | — | `measurement_snapshot.hpp` u.a. |
| ComdareMeasurementSnapshotV1 | Pipeline-Sicht | 16+6[+2]; volle CSV = 24 Spalten | — (kVersion=1) | `measurement_snapshot.hpp:34-66` |
| ComdareTierObserverSnapshot | Observer-POD | axis_stats[18][8]+seg_ns[18]+6 Meta | — (kV3AxisCount=18, Version 6, sizeof 1344) | `observable_tier.hpp:44-155` |
| kV3AxisSchema | Feld-Vertrag Schreiber↔CSV | 18 Achsen × ≤8 Felder | — | `observable_tier.hpp:67-103` |
| PmcCounters | HW-Counter-POD | 7 Zähler + available | — (gated #26) | `pmc_source.hpp:19-27` |
| kMeasurementAxisRegistry | compile-time Mess-Registry | 16 MeasurementAxisInfo (Index==Kategorie) | ct (constexpr, KEIN Runtime-Switch) | `measurement_axis_registry.hpp:16-77` |
| **System-Mess-Kollektoren** | host-seitige Wurzel, nur LESEND | 3 CRTP: WallClock/ObserverSnapshot/Pmc | rt | `system_axis.hpp:135-342` |
| WallClockSystemAxis | total_ns/op_count | LATENCY_MEAN + THROUGHPUT real; P50..P999 honest-0 | rt | `system_axis.hpp:196-240` |
| ObserverSnapshotSystemAxis | axis_stats[5][2]/[3] | CLU real; MEMORY_FOOTPRINT + FILL_BUFFER honest-0 | rt | `system_axis.hpp:242-285` |
| PmcSystemAxis | counters.available | L1/L2/L3/DTLB/BRANCH/ENERGY; IPC_CPI honest-0 | rt (gated) | `system_axis.hpp:287-336` |

---

## (5) COMPILE-/REGISTRY-XML-ACHSEN

| Achse | Ausprägungen | verdrahtet? | Status | Quelle |
|---|---|---|---|---|
| **cache_engine_axis_registry.xml** (18 Achsen T00-T17) | search_algo(4)…queuing_q2(5), s. §2 | JA (GENERIERT, live golden) | **gebaut** | `cache_engine_axis_registry.xml:9-130` |
| permutation_axes.xml (Legacy-11) | 11: page(10)/node(8)/traversal(5)/value_handle(3)/concurrency(6)/allocator(16)/prefetch(6)/**telemetry(5)**/isa(6)/layout(6)/reclamation(5); GROSS-Aliasse | NEIN (AxisRegistry kennt Aliasse nicht mehr) | **Legacy / TABU read-only** | `permutation_axes.xml:6-150` |
| AxisLibraryRegistry Achsen 1-14 | harte C++-Lookup-Tabelle (Deskriptor) | nur DATEN für AutoPermutator, KEIN ct-Treiber | **Legacy** (V34+ Doxygen-Ersatz geplant) | `axis_library_registry.hpp:28-338` |
| Achse 14 Engine-Choice (Betriebswahl) | 4: V1_Manual / V2_Adaptive / V3_Hybrid_AB / V4_Automatic | Betriebswahl, KEINE Prüf-Stufe/4. Merge-Stufe | Legacy (S-3) | `axis_library_registry.hpp:334-338` |
| **15.1 Compiler-Family** | 4 DATEN: GCC/Clang/AppleClang/MSVC; IST 2 (gcc\|clang) | SOFT-FILTER (Host-Skip); IST via CompilerSystemAxis | **gebaut** (gcc\|clang) | `axis_library_registry.hpp:341-345` |
| 15.2 Optimization-Level | 8: O0/O1/O2/O3/Ofast + MSVC_Od/O1/O2 | parsed, aber „kein Skip" (Compile-Time-only) | **geplant** (INC-2c.opt) | `axis_library_registry.hpp:348-356` |
| 15.3 LTO-Mode | 4: None/ThinLTO/FullLTO/MSVC_LTCG | parsed, kein Bau-Treiber | **geplant** | `axis_library_registry.hpp:359-363` |
| 15.4 PGO-Profile | 4: None/Generate/Use/SamplePGO | parsed, kein Bau-Treiber | **geplant** | `axis_library_registry.hpp:366-370` |
| 15.5 Target-Arch (-march) | 6: native/x86-64-v3/v4/znver4/armv9-a/generic | IST via ExtensionHardwareSystemAxis; host-gefiltert | **gebaut** | `axis_library_registry.hpp:373-379` |
| simd_extension (09b) | 8: no_extension/sse2/avx2/avx512/neon/sve2/rvv/cuda_gh200 | deklarative Build-Achse; Material der 6. System-Achse | **gebaut** | `axis_09b_simd_extension_registry.hpp:22-28` |
| page_type (01) + PG1-PG3 | Achse + 3 Sub: structure_role/density_class/path_collapse | topics/nodes; nicht in golden-18 | **gebaut** | `axis_01_page_type_subaxes_pg1_to_pg3.hpp:4-15` |
| cacheline (KF-3 per-Organ) | line_size{64,128,256,32}/alignment{none,aligned,padded}/sw_prefetch_hint{none,T0,T1,T2,NTA} | JEDES Organ eigene Einstellung → bis 60⁴ | **gebaut** (Sonderzweig) | `cacheline_study.profile.xml:57-70` |
| messreihe_v32 `<compiler_strategy>` | XML-Achse+5 Unterachsen: family/opt_level/lto/pgo/target_arch | parsed (CompilerStrategyV32), SOFT-FILTER | **deprecated** (→ INC-D) | `messreihe_v32_schema.xsd:112-132` |
| messreihe_v32 `<hardware_strategy>` | 5: simd/cache_level/numa/prefetch_distance/atomic_granularity | parsed HardwareStrategyV32, host-gefiltert | deprecated | `messreihe_v32_schema.xsd:88-99` |
| messreihe_v32 `<scheduling_strategy>` | 5: worker_pool/simd_workers/heterogeneous/interleave/batching | parsed; deckt Registry 13.1-13.5; ISchedulingStrategy tot | deprecated | `messreihe_v32_schema.xsd:100-111` |
| messreihe_v32 `<axes>`+`<axes_default_lookup>` | `<axis id baustein>*` + allowed_variants | generische Organ-Selektion; numerische IDs | deprecated | `messreihe_v32_schema.xsd:53-63,133-144` |
| comdare_experiment (INC-C) | referenziert 2 Registries: engines/phases(Stufe1/2/3)/axes_default_lookup/workloads/datasets/measurement_categories/op_types | INERT bis Parser INC-D (`--validate` verdrahtet) | **geplant** | `experiment_golden.xml:21-91` |
| CompilerSystemAxis (IST 15.1) | 2: Gcc(g++-16, fno_gnu_unique=true) / Clang(clang++-22, false) | JA (+cxx=, CRTP unter CebSystemAxis) | **gebaut** | `compiler_system_axis.hpp:22-60` |
| ExtensionHardwareSystemAxis (IST -march/15.5) | 3: Generic/Avx2(-mavx2)/Avx512(-mavx512f); Flags je Compiler | JA (+ext=, CompileFn-Naht) | **gebaut** | `extension_hardware_system_axis.hpp:24-71` |
| CebSystemAxis (Konfig-Root) | CRTP-Wurzel, AxisKind=system_config; Kinder = die 6 | JA | **gebaut** | `ceb_system_axis.hpp:20-37` |

**Compiler-Achse ⊃ Unterachsen (User-Ruling 2026-07-17).** Opt-Level (O0..Ofast) + Flags + Commands + march sind **Unterachsen UNTER** der Compiler-Haupt-Achse — KEINE dedizierten Geschwister. In einem dynamischen XML-System existiert „global" NICHT. Der INC-2c.opt-Bauplan §2/F1/F3 (`OptimizationLevelSystemAxis`-Geschwister) ist per KORREKTUR-KOPF verworfen. Kanonische XML-Modellierung = `messreihe_v32 <compiler_strategy>` (deprecated → `comdare_experiment` INC-D).

---

## (6) ABHÄNGIGKEITS-ÜBERSICHT

**golden-320-Faktoren (autoritativ `source_catalog.hpp:83-113`).** `FullSourceCatalog = CatalogAxes<4,4,5,4> = 320`. NUR 4 Achsen FREI:

```
search_algo (T0) ×4 [KSearch]  ·  node_type (T4) ×4 [KNode]
memory_layout (T5) ×5 [KLayout]  ·  prefetch (T7) ×4 [KPrefetch]
4 · 4 · 5 · 4 = 320
```

Die übrigen **14 Komposition-Slots je `mp_take_c<…,1>` GEPINNT**: cache_traversal=linear_fanout · mapping=direct_placement · path_compression=path_compression_none · allocator=std_malloc · concurrency=concurrency_none · serialization=serialization_raw_binary · value_handle=value_handle_inline · isa=isa_amd64 · index_organization=index_org_heap · io_dispatch=io_in_memory_only · migration_policy=migration_none · filter=filter_bloom · queuing_q1=no_buffer · queuing_q2=eager_flush. Verifiziert gegen `golden_fullpilot_320_binary_ids.txt` (alle 320 Zeilen ABI-5/18-Slot, ohne telemetry-Segment). `SmallSourceCatalog = CatalogAxes<1,2,2,1> = 4` (E2E-Treibertest).

**Pinnt / permutiert.** search_algo↔cache_traversal via `traversal_for_search_algo` gekoppelt. node_type trägt 4 node-shape-Sub-Achsen + page_type. isa trägt simd_extension(09b) + general_hardware(12). Genus-eigene Achsen (growth/extent/layout/accessor) heute SINGLE-VARIANT → tragen ×1 zur Genus-Kardinalität.

**Orthogonalität.**
- **System-Achsen ⊥ Organ-Achsen:** KEINE der 6 System-Achsen steht je in `kCompositionAxisNames`/`serialize_composition_path`/`P::variants`. golden bleibt bei 320.
- **BUILD ⊥ LASTENPROFIL** = die ZWEI Haupt-Experiment-Achsen (kartesisches Kreuz, eine DLL × N Lastprofile). COMPILE-RELEASE ist AUSDRÜCKLICH KEINE 3. Experiment-Achse (nur Build-Schalter).
- **e18-Rollentrennung:** Hardware/ISA = reiner Host-Deskriptor+Mess-Gate („welcher Host", treibt nichts). Erweiterungshardware = einzige Bau-Treiberin („welche Instruktionen", -march-Flag-QUELLE an `make_gpp_compile_fn`, `build_orchestrator.hpp:466/476`).

**binary_id vs. H-10-Sidecar.**

| In binary_id (permutiert) | NICHT in binary_id (H-10-Sidecar / build_version) |
|---|---|
| 18 Organ-Achsen T0..T17 | Alle 6 System-Achsen (Compiler +cxx=, Erweiterungshardware +ext=, +opt= geplant) |
| | page_type · simd_extension(09b) · general_hardware(12) (build_system_axis_levels) |
| | node-shape btree/skip/bst/hash (Codegen-Varianten, Shape=void byte-identisch) |
| | Alle DynDims (is_static=false) · W/D/K E4-Mess-Inputs |

**IST-vs-GEPLANT Consumer-Wiring:** heute in `build_version` VARIABEL verdrahtet = nur **Erweiterungshardware (+ext=)** + **Compiler (+cxx=)**. Scheduling + Last sind als CRTP-Header GEBAUT, im version_suffix aber „Default weggelassen". Telemetrie über `build_system_axis_levels()`/`composition_factory` verankert.

**gated / TABU (Ledger §19/§20, 2026-07-17).**
- **gated:** PMC-Kategorien honest-0 bis #26 (Intel-PCM/PAPI, prod1). golden-320-Voll-Messlauf gated #156 (mehrtägig). D-Loader-Mess-Konsum lauf-gated. Vollworkload/Gesamt-Benchmarking gated.
- **TABU / eingefroren:** `golden_fullpilot_320` · `CatalogAxes<4,4,5,4>` · `kV3AxisSchema` · `kCompositionAxisNames` · Registry-`mp_list` · POD-sizeof. mapping-Erweiterung (MP03/MP04), node-shape-Aktivierung, per-K-Enable würden Gate-1-Kardinalität/golden-Radix neu schneiden → nur unter explizitem User-GO im koordinierten Bau-INC-2. `permutation_axes.xml` = read-only.

**OFFENE AUDIT-AUFLAGE (INC-2c, nicht-blockierend, vor Messlauf zwingend):** `build_system_axis_levels()` (`registry_to_axis_levels.hpp:112`) hat repo-weit KEINEN Aufrufer → telemetry-Wahl (Active/Silent) landet in KEINEM Sidecar (vorbestehende INC-1-Lücke, auch page_type/simd_extension betroffen). Provenienz läuft real über `system_axes_version_suffix` (`profile_run_facade.cpp:172`).

---

## (7) ZÄHL-FALLEN + KONFLIKTE

**(A) Die konkurrierenden Achsen-Zählungen — sauber getrennt:**

| Zählung | Wert | Was | Wo |
|---|---|---|---|
| Organ / Komposition | **18** (T0..T17) | binary_id-permutierend | `kCompositionAxisNames` `axis_path_serialization.hpp:31-34` |
| System-Konfig (CEB) | **6** | Scheduling/HW-ISA/Telemetrie/Last/Compiler/ErweiterungsHW | LEDGER:1916 |
| axes26 (Registry-Reflexion) | **26** | T00..T25: 18 Komposition + telemetry-Alias + 3 build-only (page/simd/general) + 4 node-shape | `registry_to_axis_levels.hpp:51-77` |
| Observer-POD-Achsen | **18** | `kV3AxisCount` (war 19) | `observable_tier.hpp:44-115` |
| Mess-Kategorien | **16** | 9 TimeObserver + 7 PmcCounter | `measurement_category.hpp:32` |
| Observer-Feld-Slots | **8** | `kV3FieldCount` je Achse | `observable_tier.hpp` |
| AxisLibraryRegistry | **1-14 + 15.1-15.5** | numerische Deskriptor-IDs (AutoPermutator) | `axis_library_registry.hpp:28-379` |
| Legacy permutation_axes.xml | **11** | Alias-Achsen (TABU) | `permutation_axes.xml:6-150` |
| Genus Ebene-1 / Ebene-2 | **3 / 5** | AnatomyGattung / Genus | `anatomy_base.hpp:30-109` |

> **16 vs 18 vs 8 NIE verwechseln:** 16 Mess-KATEGORIEN, 18 Observer-ACHSEN, 8 Feld-SLOTS je Achse.

**(B) 19 → 18 (INC-2c, häufigste Stale-Falle).** Registry hat JETZT 18 (telemetry ausgebaut). Belege sagen noch „19": `ceb_system_axis.hpp:7-8` · Ledger LED:1668/1679 (`std::array<…,19>`, `PermTuple<V0..V18>`, „Telemetrie Organ-Slot T10") · `genus_binding_traits.hpp:42/12` („Blatt-PermTuple<19>", „19 SearchAlgorithm-Achsen") · `anatomy_base.hpp:169` („Pflicht 19"). **Immer Registry-XML als Ist nehmen; Code-Kommentare/Ledger als stale.** Slot-Verschiebung: value_handle Alt-T11→**T10**, isa Alt-T12→T11 … queuing_q2 Alt-T18→T17.

**(C) Stale k*SlotCount-Konstanten (Gattung).** set=15/seq=11/view=7/adapter=13 (alle +1 telemetry). Belastbar NUR `slot_count` + `axis_names().size()` (14/10/6/12).

**(D) Drei inkompatible ID-Systeme für „dieselben" Achsen** (NICHT austauschbar; Übersetzung nur in `cacheline_study.profile.xml:10-16`):
1. `cache_engine_axis_registry.xml` = string-IDs `search_algo`..`queuing_q2` + Slots T00-T17 (die 18 golden).
2. `axis_library_registry.hpp` = numerische IDs `1`..`14` + `15.1`..`15.5` (AutoPermutator-Deskriptor).
3. `permutation_axes.xml` = Legacy-GROSS-Aliasse (page/node/traversal/layout, TABU).

**(E) 5%-Doppeldeutigkeit** (LEDGER:1922): (1) **Compiler-5%** = Performance-Delta gcc vs clang gegen DIESELBE Konfig. (2) **memory_layout-5%** = Layout-Sensitivität (Stride 48 vs 64) im `test_all19_segment_timer`, nur unter -O3. Opt-Level-Sub-Achsen-Bau (2c.opt) betrifft NUR (2).

**(F) Op-Kind (6) vs. Op-Type-Profile (OP-1..6) — verschieden.** Op-Kind (`WorkloadOpKind`: Insert/Lookup/Erase/Clear/Scan/RMW) = feine Op-Klassifizierung INNERHALB einer Sequenz. OP-1..OP-6 (Read/Insert/Update/Scan/RMW/RangeDelete) = XSD-Profile. Gekreuzt: YCSB A-F × OP-1..6.

**(G) POD-Spalten.** `ComdareMeasurementSnapshotV1` heißt „16+6", die volle `serialize_measurements_csv` schreibt **24 Spalten** (16 Pipeline + 6 Observer + pmc_available + 2 Host). `serialize_measurements_pipeline16_csv` = nur 16 (LaTeX-Stufe 04/05).

**(H) page_type-Falle.** Liegt in `build_system_axis_levels()` (System-Schicht-Serialisierungs-Keimzelle), ist aber **KEINE der 6** benannten CEB-System-Achsen — build-only, binary_id-orthogonal, nicht in `kCompositionAxisNames`.

**(I) Kardinalitäts-Formel-Inkonsistenz.** `all_axes_binary_count()` (`registry_to_axis_levels.hpp:145-159`) multipliziert weiterhin `enabled_count<axes26::T10_telemetry>` (Z.151) mit — obwohl telemetry bei INC-2c binary_id-orthogonale System-Achse wurde. Der `T10_telemetry`-Alias bleibt bewusst als Registry-Reflexionsquelle; die 26er-Formel spiegelt die neue System/Organ-Trennung noch NICHT in der Zählung.

**(J) queuing ≠ Gattung.** `queuing` zerfällt in 2 gleichrangige Komposition-Slots q1(T16)/q2(T17) = reguläre SA-Tier-Unterklasse-Achsen (Doc 30 §8.0), KEINE eigene Gattung (Kategorienfehler-Korrektur 2026-06-03; echte Container-Gattung std::queue/stack/priority_queue separat, `ContainerObserver` reserviert).

**(K) Richtwert „~279 Sub-Achsen" nicht belegt.** Weder 127 Strategien noch 94 Observer-Felder noch 164 Organ-Ausprägungen treffen ihn — vermutlich dimensionsübergreifende Gesamtschätzung (System+Mess+Organ+Gattung+Build). Hier nur die belegten Zahlen geführt.

**(L) Deprecated/Legacy danebenstehend (nicht löschen — `feedback_never_delete`).** `ISchedulingStrategy`-Runtime-vtable (+3 Schwestern numa_affinity/locking_mode/hardware_strategy) = deprecated, 0 Konsumenten; die compile-time-Scheduling-System-Achse tritt DANEBEN, ersetzt nicht (vtable-Ersatz = Bau-INC-2). Gesamter `messreihe_v32`-Pfad `[[deprecated]]` (→ `parse_experiment_profile`/`comdare_experiment` INC-D). Telemetrie-Organ = Legacy-Mess-Infra.