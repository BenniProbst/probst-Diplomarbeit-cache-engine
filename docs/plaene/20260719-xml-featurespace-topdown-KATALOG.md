# XML-FEATURESPACE — TOP-DOWN-KATALOG (konsolidiert)

Stand: 2026-07-19 — ce HEAD `5da2caf7`, super HEAD `1a8b95e`.
Quellen: 5 Sammler (xml-featurespace, achsen-code-vorrat, prt-art-rahmen, latex-resultat, workflow-rahmen).
Querverweise: Register `docs/audits/20260719-konsolidierung-register-post-crash-REGISTER.md` (61 Eintraege),
Audits `docs/audits/20260718-*.md` (G1-G10, P1-P8, Konvergenz G1==A1 binary_id-Struktur-Guard),
Bauplan `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md` (Phase-0-Blocker).
Deadline: 28.07.2026 (FF0-FF4 honest-100% + Thesis-PDF).

Doktrin-Anker (gelten fuer den GESAMTEN Katalog):
- binary_id = AUSSCHLIESSLICH die 17 Organ-Kompositions-Achsen (ABI-6, Magic `.A6.`, POD sizeof==1272, kV3AxisCount=17; isa+telemetry raus per INC-2c/2d). System-/Mess-Achsen sind Sidecar (build_version / `.version`-Sidecar), NIE binary_id.
- Haupt-Achse = CT-statisch, Unter-Achse = runtime; stufen-relativ (Planer→CEB→Tier).
- NUR EIN offizielles XML-Programm (`comdare-messung-driver experiment_config <out>`); keine Parallelstrukturen.
- golden-320 = Alias/Snapshot (TABU messdaten-erhaltend); neue Referenz = golden N=2^17=131072 all-vary (CRC64-Fixture gelandet, BAU offen).
- Doku nie loeschen, nur deprecaten/superseden.

---

## A) XML-registrierbarer Featurespace (top-down)

### A.1 Organ-Kompositions-Achsen (17, ABI-6) — binary_id-bildend

Registry-Quelle: `libs/cache_engine/algorithm_profiles/cache_engine_axis_registry.xml` (GENERIERT via `tools/axis_registry_gen`).
XML-Traeger: Registry (Bausteine) + `permute_axes`/`axis ref` (ThesisProfile) + `axes_default_lookup` (Experiment-XML, nur LIMIT).
Reihenfolge = `kCompositionAxisNames` (`builder/experiment_tree/axis_path_serialization.hpp:34`) — garantiert byte-identische binary_ids (Round-Trip-Gate `tests/unit/thesis_tiere/test_profile_roundtrip.cpp`).

| T | Achse | enabled-Varianten (name()-Vorrat, Code-Ist) | wired | Code-Ist (Pfad) | All-Vary-take-2 (golden-N) |
|---|---|---|---|---|---|
| T00 | search_algo | 4/22: k_ary, interpolation, eytzinger, linear_scan | 4 | axes/lookup/axis_03a_* | k_ary + linear_scan |
| T01 | cache_traversal | 3/3: linear_fanout, hash_lookup, binary_search_fanout | 1 | axes/cache_traversal/axis_03b_* | linear_fanout + hash_lookup |
| T02 | mapping | 2/2: direct_placement, pool_relative (MP03/MP04 = Gate-1-Tabu-Roadmap) | 1 | axes/mapping/axis_03m_* | beide (=voll) |
| T03 | path_compression | 3/3: path_compression_none, _patricia, _byte_wise (patricia = prt-art golden_merge_slot) | 1 | axes/path_compression/axis_02_* | none + patricia |
| T04 | node_type | 4/4: node4, node16, node48, node256 (ObservableNodeType<>, name() passthrough) | 4 | axes/node/axis_04_* | node4 + node256 |
| T05 | memory_layout | 5/5: memory_layout_cache_line_aligned, _aos_strict, _soa, _packed_bitmap, _aosoa (Observable) | 5 | axes/layout/axis_05_* | cache_line_aligned + packed_bitmap |
| T06 | allocator (Organ per Doktrin malloc=Organ) | 3/26: std_malloc, pmr_resource, pool_resource (23 Fremd-Vendor disabled) | 1 | axes/alloc/axis_06_* | std_malloc + pool_resource |
| T07 | prefetch | 4/4: prefetch_none, _distance_estimator, _hardware, _path_oriented | 4 | axes/prefetch_axis/axis_07_* | none + path_oriented |
| T08 | concurrency | 9/9: concurrency_none, _blocking, _reader_writer, olc_optimistic, _lock_free, _wait_free, _rcu, _hazard_ptr, olc_reserved_blocks | 1 | axes/concurrency_axis/axis_08_* | none + wait_free |
| T09 | serialization | 4/4: serialization_raw_binary, _var_len, _succinct, _compressed (Observable) | 1 | axes/serialization_axis/axis_10_* | raw_binary + succinct |
| T10 | value_handle | 5/5: value_handle_inline, _external_pool, _immutable_shared_ref, _versioned_pointer, _chain_ref | 1 | axes/value_handle_axis/axis_14_* | inline + chain_ref |
| T11 | index_organization (committed-XML noch als T12, s. Gap B7) | 4/4: index_org_heap, _clustered, _non_clustered, _index_organized_table | 1 | axes/index_organization/axis_01_* | heap + index_organized_table |
| T12 | io_dispatch | 4/4: io_in_memory_only, io_direct, io_buffered, io_mmap | 1 | axes/io_dispatch/axis_io_* | in_memory_only + direct |
| T13 | migration_policy | 4/4: migration_none, _hot_cold, _tier_based, _adaptive | 1 | axes/migration_policy/axis_migration_* | none + adaptive |
| T14 | filter | 4/4: filter_bloom, _cuckoo, _range_surf, _xor | 1 | axes/filter_axis/axis_filter_* | bloom + range_surf |
| T15 | queuing_q1 (Puffer-Struktur) | 15/15: no_buffer, fifo_queue, lifo_stack, bounded_ring, append_only, priority_heap, delta_chain, skiplist_buffer, tombstone_buffer, copy_on_write, epoch_buffer, batched_insert_buffer, lockfree_spsc, lockfree_mpmc, original_concurrentqueue | 1 | topics/queuing/axis_q1_queuing/* | no_buffer + lockfree_mpmc |
| T16 | queuing_q2 (Flush-Politik) | 5/5: eager_flush, watermark_flush, lazy_flush, timed_flush, adaptive_lsm_flush | 1 | topics/queuing/axis_q2_queuing/* | eager_flush + lazy_flush |

Legende (Notiz): "enabled x/y" = enabled-Bausteine von Gesamt-Inventar (Registry-Header + generated Flags); "wired" = golden_wired-Bausteine laut Registry-XML. Summe enabled = 82 Bausteine ueber 17 Achsen (Code-Ist). golden-320 = 4(search_algo)x4(node_type)x5(memory_layout)x4(prefetch), 13 Achsen je 1 Wert gepinnt. golden-N = alle 17 Achsen je 2 Werte (mp_take_c<Enabled,2>) = 2^17 = 131072.

Status: alle 17 Achsen ERLEDIGT (registrierbar + Code-Ist deckungsgleich); Registry-XML-Committed-Stand selbst = DRIFT (s. B7).

### A.2 CEB-System-Achsen (6) — binary_id-NEUTRAL (Sidecar/Provenienz)

CT-Schicht: `libs/cache_engine/include/cache_engine/measurement/*_system_axis.hpp` (CRTP `CebSystemAxis`).

| # | Achse | Auspraegungen/Unter-Achsen (Code-Ist) | XML-Kanal (comdare_experiment) | Status |
|---|---|---|---|---|
| 1 | compiler | compiler_id gcc \| clang (Gcc/ClangCompilerAxis); dyn. Unter-Achsen: opt_level, atomic128 (no_cx16 \| cx16) | nur Unter-Achse opt_level; compiler-FAMILIE NICHT ausdrueckbar (Gap B2) | teilweise steuerbar |
| 2 | opt_level (Unter-Achse von compiler) | O0 \| O1 \| O2 \| O3 \| Ofast (kKnownOptLevelIds); Default O3; Ofast bricht IEEE-754-Determinismus (fuer CRC64-golden meiden) | `system_axes/compiler/opt_level` → CompilerAxisSel, HART validiert (kAllOptLevelIds), Konsum run_experiment_profile opt×simd | steuerbar (ERLEDIGT) |
| 3 | extension_hardware / simd (Q2 Option C, 6. System-Achse) | no_extension (kein Flag) \| avx2 (-mavx2) \| avx512 (-mavx512f); Flags→CompileFn, NIE binary_id | `system_axes/extension_hardware/simd` → ExtensionHardwareAxisSel, HART validiert (kAllSimdIds) | XML-Kanal FERTIG; aktiver Familien-Knoten FEHLT (E-4) → GATED |
| 4 | target_isa (INC-2d Variante A) | x86_64 (host) \| aarch64 (-target aarch64-linux-gnu, -march=armv8-a); aarch64 nur Build-Seite | KEIN XML-Kanal (Gap B2) | Code ERLEDIGT, XML Gap |
| 5 | scheduling | genau 1: DefaultSchedulingSystemAxis (ThreadPerCore, simd_worker_limit=2, HeteroDispatch None, CoRoutine None, Batch Single); Eigenschaften compile-time, keine string-ids | KEIN XML-Kanal (Gap B2; Legacy-v32 hatte scheduling_strategy) | Code ERLEDIGT (1 Variante), XML Gap |
| 6 | load_framework | framework_id ycsb (einziges); dyn. Unter-Achse "workload" (Single-Source der workload.workload_id-Konvention); Token: mixed_a, mixed_b, ycsb_c, ycsb_d, ycsb_e, ycsb_f, insert_heavy, lookup_heavy | workload-AUSWAHL via `workloads`-Liste (beide Kanaele); Framework selbst nicht permutierbar | steuerbar (Auswahl) |

isa-ORGAN (Amd64Isa/ObservableIsa, hardware_isa_system_axis.hpp Label "hardware") bleibt Codegen-Traeger, permutiert NICHT.

### A.3 Mess-Achsen / measurement_categories — Sicht-PROJEKTION, keine Vary-Achse

- 3 SystemAxis-Quell-Familien: WallClockSystemAxis / ObserverSnapshotSystemAxis / PmcSystemAxis (`measurement/system_axis.hpp`).
- 16 Kategorien (Registry `measurement_axis_registry.hpp:32-49`, Index==Kategorie, consteval-geprueft): CLU, CACHE_MISS_L1, CACHE_MISS_L2, CACHE_MISS_L3, DTLB_MISS, MEMORY_FOOTPRINT, BRANCH_MISS, IPC_CPI, LATENCY_MEAN, LATENCY_P50, LATENCY_P95, LATENCY_P99, LATENCY_P999, THROUGHPUT, ENERGY_J, FILL_BUFFER_OCCUPANCY.
- XML: `measurement_categories` (experiment_schema.xsd:200-231) = Spalten-Projektion; fehlt = alle 16. Parser-Traeger in BEIDEN Kanaelen (ThesisProfile :236-245, ExperimentProfile :312) + Aufloesung gegen kMeasurementAxisRegistry in validate_profile.hpp. → KEIN Gap, ERLEDIGT.

### A.4 DynamicDims — is_static=false, binary_id-unberuehrt

Quelle: `builder/experiment_tree/profile_to_tree.hpp:92-111` + `profile_facade/experiment_run_entry.hpp:196-226`; POD-Mapping `runtime_variable_loop.hpp:53-64`.

| Dim | XML-Traeger | Anmerkung |
|---|---|---|
| workload.workload_id | compile_dims/workloads bzw. Experiment-`workloads` | aus YcsbLoadFrameworkAxis::sub_axis_label |
| repetition.repetition_index | `repetitions count=3 interpolate=false overlay_in_chart=true` (KF-10) | immer emittiert; architektonische Ausnahme ohne POD-Feld |
| concurrency.thread_count | runtime_dynamic/thread_count | LABEL-ONLY (DRIFT, s. B11) — ehrlich auf 1 gepinnt (Mess=1-Thread-Doktrin) |
| prefetch.hw_prefetcher | runtime_dynamic | Cluster-real via MSR 0x1A4; Ausnahme ohne POD-Feld |
| prefetch.prefetch_distance | runtime_dynamic/prefetch_distances | POD |
| allocator.pool_budget_bytes | runtime_dynamic/pool_budgets_bytes | POD |
| cache_traversal.batch_size | runtime_dynamic/batch_sizes | POD |
| value_handle.inline_threshold_bytes | runtime_dynamic/inline_thresholds_bytes | POD |
| fixed_conditions (turbo/smt/aslr/numa/governor) | runtime_dynamic/fixed_conditions | deklarativ, keine Dim-Expansion |

datasets sind KEINE Dim, sondern `<datasets>`-Deklaration → datasets_signature im Resume-Stamp.

### A.5 Workloads / Datasets / op_types

| Element | XML | Parser-Traeger | Status |
|---|---|---|---|
| workloads | Whitespace-Token-Liste (Experiment-XSD:31) bzw. compile_dims/workloads (ThesisProfile) = AUTORITATIVE Achse-2-Auswahl ycsb_a..ycsb_f; env COMDARE_LOAD_PROFILE_DIR=Override | ExperimentProfile.workloads :310 / ThesisProfile :201 | ERLEDIGT |
| datasets | dataset id/akte_ref/loader; Single-Source test_data-AKTEN `Code/test_data_xml/*.test_data.xml` (KEINE test_data_sets.xml-Doppelquelle, GO-5 Fork 2); loader = DatasetLoaderRegistry-id (string_corpus/sosd_uint64); binary_id-neutral | ThesisDatasetRef :166-180+311; Loader-Slot hermetisch bewiesen (#184) | Parse+Validate FERTIG; Loader-MESS-Konsum OFFEN (B4, lauf-gated) |
| op_types | OP-1..OP-6 (XSD:233-246) | ExperimentProfile.op_types :313; op_type_filter.hpp OP→WorkloadKind | ERLEDIGT |
| telemetry (compile_dims) | mode=on/off/leaf_sampled/all, silent=bool | ThesisProfile.telemetry_mode/_silent :202-203 | ERLEDIGT (Sidecar H-10, nie binary_id) |

### A.6 Experiment-Kanal: Root / Engines / Lebewesen / Phasen / MergeStrategy / Limits

Schema: `Code/test_data_xml/experiment_schema.xsd`; Kanon-Instanz: `experiment_golden.xml` (2 Sync-Kopien, F27 user-gated, s. B15).

| Element | Inhalt | Parser/Code-Ist | Status |
|---|---|---|---|
| comdare_experiment Root | version=1 fixed, id; metadata name/mode defined\|full\|full_sampled (Rohstring; Enum-Pruefung ce-Schicht) | ExperimentProfile/-Metadata :257-260+300-303; parse_experiment_profile cpp:370 | ERLEDIGT (full_sampled-Fallback = DRIFT B9) |
| execution_engines | GENAU 2: ee_ce→cache_engine_axis_registry.xml, ee_prt→prt_art_axis_registry.xml; Experiment-XML traegt KEINE Bausteine selbst | ExperimentEngine :262-266; Registry-Aufloesung validate_profile.hpp:467-481 | ERLEDIGT |
| lebewesen | gemessene Tiere als base_tier-ids | :305 | ERLEDIGT |
| phases | GENAU 3; merge=MergeStrategy-Enum + engine\|engines + optional pruefling (golden: phase2 Stufe1/ee_ce, phase1 Stufe2/ee_prt pruefling=prt_art, phase3 Stufe3/ee_ce+ee_prt) | ExperimentPhase :268-274; MergeStrategy anatomy/pruefling_merge.hpp:130-134; PhaseStrategyFor experiment_phase_strategy.hpp | Parse+Validate ERLEDIGT; Planer-Kopf FEHLT (B6) |
| MergeStrategy-Semantik (Single-Source ce anatomy/pruefling_merge.hpp) | Stufe1_CeOnly = DefaultList; Stufe2_PrueflingReplace = conditional Replace mit Fallback (EmptyPrueflingSlot→DefaultList, "Regel der abstrakt-leeren Achse"); Stufe3_FullJoin = mp_unique-Union; Dispatch MergeAxis<S,...>; Cross-Genus-Join type-system-unmoeglich (genus-Guards) | :91-158, :202-209 (Guard) | ERLEDIGT |
| axes_default_lookup | enabled-Flag; axis ref + allowed_variants-Teilmenge; ungenannte Achse = volle Registry-Liste — reines LIMIT | ExperimentAxisDefault :276-279+308-309; Validat gegen Registry | ERLEDIGT |
| system_axes | compiler/opt_level (O0..Ofast, leer=O3) + extension_hardware/simd (no_extension/avx2/avx512, leer=no_extension); explizit binary_id-NEUTRAL; Planer permutiert selbst (opt-g) | CompilerAxisSel :292-294 / ExtensionHardwareAxisSel :295-298; HART-Validate :554-581; Konsum experiment_run_entry.hpp:52 | ERLEDIGT (Kanal); E-4 gated (B5) |
| output | binary_path/csv_path/latex_path/comparison_metrics(bool) | ExperimentOutput :281-286+317 | ERLEDIGT |

### A.7 PRT-ART-Bausteine (SEPARATER Pruefling, kein CEB-Merge; Werkzeug=CacheEngine)

Registry: `comdare-prt-art/prt_art/algorithm_profiles/prt_art_axis_registry.xml` — GENERIERT (prt_art_registry_gen, INC-B: compile-time-Reflexion der PrueflingVariants-mp_list, COMDARE_DEFINE_ORGAN_LOCATION (R-B), genus via genus_name (F30), name()-Guard, Roundtrip via registry_roundtrip.cmake).

| Eintrag | Slot/Achse | Baustein | golden_wired | Status |
|---|---|---|---|---|
| pruefling_slot | page_type / axis_01 | prtart_bplus_page (PrtArtBPlusPageType) | false | Demo, ERLEDIGT |
| pruefling_slot | prefetch / axis_07 | prtart_redirect_prefetch | false | Demo, ERLEDIGT |
| pruefling_slot | telemetry / axis_11 | prtart_per_node_counter | false | Demo; Doktrin-Frage B13 (Achse hat Komposition verlassen) |
| pruefling_slot | value_handle / axis_14 | prtart_chain_ref_handle | false | Demo, ERLEDIGT |
| golden_merge_slot | path_compression / axis_02 | path_compression_patricia = bare ce-PatriciaPathCompression (KEIN prtart_-Name) | true | traegt EINZIG die SOTA-Merge-Serien, ERLEDIGT |

Rahmen:
- binary_id-Bildung im Join: HostPrtMergeComposition<Host,MergedPC> uebernimmt 16 Organ-Achsen des SOTA-Hosts, ersetzt NUR path_compression; serialize_composition_from_slots ueber 17 Organ-Achsen. Stufe2-Messpunkt = mp_front (Replace-Liste, Groesse 1), Stufe3 = mp_back (Union, Groesse 2), static_asserts. M-CE-10: je 6 per-Host-Kompositionen fuer Stufe2 UND Stufe3 (Art/Hot/Masstree/Surf/Start/Wormhole) = genuine distinkte binary_ids.
- KEINE eigene PRT-ABI: reiner CT-Slot-Merge → CE-ABI-6 (.A6., POD 1272; Fuss AnatomyModuleLoader dlopen, IPruefDock, 4 Symbole, host_compatible_with). Plugin via -DCOMDARE_CE_PRUEFLINGE + comdare_pruefling.cmake; super add_subdirectory(COMDARE_PRT_ART_DIR). V8-"ABI-Inheritance"-Doku = superseded (markiert, nicht loeschen).
- Registry-Pfade als CMake-Interface-PARAMETER (COMDARE_CE_AXIS_REGISTRY_PATH + COMDARE_PRT_AXIS_REGISTRY_PATH an 02_messung_driver; ce-Fassade haelt KEINEN prt-Pfad hart; ce-Tests read-only Fixture-Kopie via COMDARE_PRT_AXIS_REGISTRY).
- Reuse-Matrix (PRT_ART_AXES_REUSE_MATRIX.md, V32.FF.3): 10 Neu / 1 Reuse / 9 default-lookup — Kartierungs-Quelle, Nummern NICHT 1:1 auf axis_NN/T-IDs mappen (DRIFT, uebersetzen bei Thesis-Verwendung).

### A.8 ThesisProfile-Kanal (comdare_thesis_profile) — Mess-Detail-Traeger

Parser: `parse_thesis_profile` (xml_config_parser.hpp:332); Struct ThesisProfile :195-246.

| Element | Inhalt | Status |
|---|---|---|
| Root + base_tiers | id/schema_version; tier id/profile_ref→sota/*.profile.xml/paper_ref; 7 Lebewesen prt_art+art/hot/masstree/surf/start/wormhole | ERLEDIGT |
| permute_axes | axis ref=Registry-id + konkrete value-Liste (leer=volle Liste; all_axes_golden VERBIETET leer); Reihenfolge = kCompositionAxisNames (byte-identische binary_ids, Round-Trip-Gate) | ERLEDIGT |
| Unter-Achsen-Kanaele | cacheline (per_organ/line_sizes 32-256/alignments/sw_prefetch_hints, KF-3), node_width (width_in_lines 1-16, C2), alloc_hw (alloc_numa_nodes auto/0/1 + alloc_pages 4k/2m, F-B) — additiv, Round-Trip byte-identisch | ERLEDIGT |
| axis_sweeps | axis+baseline=index0 (EINE Achse vs Baseline via StaticBinaryView::flat_index); vertiefte Achsen eigener Sweep-Baum (reale distinkte DLL je Auspraegung); m3v2: 8, all_axes_golden: alle 17 | ERLEDIGT |
| sota_series | id A/B/C + lebewesen + merge (Stufe1/2/3) + pruefling_type ''\|full\|abstract (leer=derive_pruefling_type); 21 Eintraege je Profil; Reihe C build-uebergreifend | ERLEDIGT |
| fairness (je sota_series) | ''\|common_denominator\|native (GO-5 Fork 6); bis Runner-Spec+CSV-Spalte+Resume-Stamp verdrahtet; Kompositions-Pinnung + MESS-Abnahme DATEN-gated (#156/#162) | GATED |
| working_set_sweep | N-Liste aeussere Lauf-Iteration {2^14,2^17,2^20,2^23}; ersetzt COMDARE_WORKLOAD_RECORDS; leer=einmalig | ERLEDIGT |
| compile_dims | workloads (autoritativ) + telemetry mode/silent | ERLEDIGT |
| runtime_dynamic | s. A.4 (DynamicDims; hw_prefetcher real via MSR 0x1A4) | ERLEDIGT (thread_count DRIFT B11) |
| repetitions | count=3 interpolate=false overlay_in_chart=true (KF-10: separat, nie interpoliert) | ERLEDIGT |
| run_options | cap/n_ops/platform/build_version/resume(+resume_set); argv/env darf uebersteuern; Anm.: platform='win-x86_64' = kopiertes CSV-Tag, Mess-Realitaet Linux-Cluster | ERLEDIGT |
| modes | name+merge+active_axes(17er)+optional pruefling/replaces_axes; static_axes from=base_tier; key_value_signature (uint64_t/std::string) | ERLEDIGT |
| system_axes | FEHLT im Struct — G3 (Gap B1) | OFFEN |

Profil-Instanzen:
- `m3v2_study.profile.xml` = golden-320-Grundlage (Alias/Snapshot): 4 variierte Achsen ×320, 13 gepinnt, cap=320, TABU messdaten-erhaltend; binary_ids byte-identisch zum FullPilot verifiziert (Mismatch=0). Kopfkommentar "19 SLOTS T0..T18" = Kommentar-DRIFT (B14).
- `all_axes_golden.profile.xml` = golden-N-KEIMZELLE: alle 17 Achsen je GENAU 2 Werte → N=2^17=131072; bewusst ENTKOPPELT vom Bau (catalog_codegen.cmake NICHT repointet, materialisierter Katalog bleibt 320; Referenz-Count lazy via catalog_axis_product/StaticBinaryView); CRC64-Fixture gelandet; Materialisierung+opt-simd-Wiring+Entkopplungs-BAU offen (B12).

### A.9 Output / Provenienz (FF4)

| Artefakt | Traeger | Status |
|---|---|---|
| output-Element | binary_path/csv_path/latex_path/comparison_metrics (Experiment-XML) | ERLEDIGT |
| measurements.csv 16-Spalten-Record | permutation_id, fingerprint, succeeded, workload_used, op_count, total_cycles, cache_misses_l1/l2/l3, dtlb_misses, coherence_invalidations, energy_micro_joules, bytes_allocated, bytes_in_use_peak, external_frag, internal_frag (03_binary_to_csv) | ERLEDIGT (Branch-Miss/IPC/Durchsatz = Schema-Erweiterung OFFEN, B17) |
| build_manifest.txt | manifest:provenance (#198): super-SHA + alle Submodul-SHAs + Toolchain + OS/ISA + cpu_flags_sha256 + Profil-Hash aller ce-XMLs | ERLEDIGT |
| .version-Sidecar | System-Provenienz (ext/cxx/opt/target/ceb) je Tier-DLL; stale ABI (5→6) NIE reused | ERLEDIGT (#50) |
| .algos-Sidecar | Organ-Signatur (perm.algos), SEPARAT von .version (Organ/System nie vermischt); write nur bei Bau-Erfolg | ERLEDIGT (#50, Pipeline 11278 gruen) |
| result.csv.stamp | Resume nur bei stream-verifiziertem CSV + Vollstaendigkeit + two_phase_valid je Zeile; Inhalt binary_resume_stamp\|rows=N | ERLEDIGT (#139/M1.4) |

### A.10 Legacy-/Superseded-Kanaele (BEHALTEN, nicht loeschen)

| Kanal | Inhalt | Status |
|---|---|---|
| permutation_axes.xml (REV 7.6 V8.3) | 11 Legacy-Wertedomaenen-Achsen fuer alten full-Mode-Cartesian; ids DISJUNKT zu Registry-axis-ids | SUPERSEDED (COMDARE_LEGACY_MESSREIHEN-gated) |
| — darin: Allocator-16-Familien-Domaene | SYSTEM_MALLOC..DLMALLOC/mimalloc/jemalloc/tcmalloc/... — offizielle Registry-Achse hat nur 3 | OFFEN (Entscheid B10) |
| — darin: isa-Domaene | X86_BASELINE..ARM_SVE; traegt selbst INC-2d-Annotation (→ target_isa-System-Achse) | SUPERSEDED |
| messreihe_v32-Schema | Root version=32, tupel/axes/output; hardware_strategy + scheduling_strategy (EINZIGER je gebauter Scheduling-/HW-XML-Kanal, ohne Nachfolger) + compiler_strategy (family/lto/pgo/target_arch ohne Nachfolger, nur opt_level ueberlebte) | SUPERSEDED (Legacy-Fixture behalten) |
| messreihen.xml | 4 Pflicht-Messreihen (A_defined 8 Tier-1-SOTA, A_full, B_CacheEngine_Perms, C_Merge_Alt_Neu) + #31 workload-Tag A..F | GATED (funktionsfaehig, Legacy-Pfad) |
| config_a/b/c (REV 7.6) | sota_profiles/pruefling/merge_points C.1-C.4/parameters/diagrams — merge_points/diagrams/parameters OHNE Parser-Traeger; heute offiziell via sota_series+MergeStrategy bzw. workload/working_set_sweep | SUPERSEDED |
| CacheEngineConfig-4-Satz | cache_engine/search_algorithm/allocator_permutations + test_data_sets (DEPRECATED, bleibt LEER — Akten=Single-Source) | SUPERSEDED (gated) |
| SOTA-AlgorithmProfile-Kanal | sota/*.profile.xml: id/paper_ref/pruefling_type/axes-Map/key_types/value_types/expected_workload(V19.1)/allocator_override(V29.A); 8 Tier-1, 30 gesamt | ERLEDIGT (aktiv genutzt via base_tiers) |

---

## B) GAPS — Design-Soll vs. Parser-/Code-Ist

### B.1 XML-Kanal-Gaps (Kern)

| # | Gap | Design-Soll / Quelle | Code-Ist | next_action |
|---|---|---|---|---|
| B1 | **G3 BESTAETIGT: ThesisProfile ohne system_axes-Feld** — thesis_profile-XML (inkl. all_axes_golden) kann opt_level/simd/target_isa NICHT ausdruecken; golden-N opt×simd-Wiring im Keimzellen-Profil strukturell offen | System-Achsen-Kanal existiert nur im comdare_experiment | ExperimentProfile.compiler/.extension_hardware :314-316; ThesisProfile :195-246 ohne | golden-N: system_axes additiv in ThesisProfile (Haupt→Unter→Option-Muster) ODER golden-N ueber Experiment-Kanal fahren (EIN offizielles Programm) |
| B2 | 4 von 6 System-Achsen OHNE XML-Kanal: target_isa, scheduling, load_framework, compiler-FAMILIE (GCC/Clang) | Legacy-v32 hatte compiler_strategy/family + scheduling_strategy | CT-Schicht existiert; kein Parser-Feld | Entscheiden welche XML-permutierbar werden (additiv XSD + CompilerAxisSel-Analoga + validate) |
| B3 | Experiment-XML kann NICHT: repetitions, working_set_sweep, runtime_dynamic, run_options, axis_sweeps, fairness — die 2 Kanaele sind nicht feature-deckungsgleich | XSD-Sequenz ohne diese Elemente | nur ThesisProfile :195-246 | beim Planer-Kopf-Bau: Experiment-XML additiv erweitern ODER ThesisProfile als Mess-Detail-Traeger referenzieren |
| B4 | datasets: Loader-MESS-Konsum offen (load_or_generate_ycsb im Workload-Pfad) | Akten-Single-Source deklariert | Parse+Validate fertig, Loader-Slot hermetisch bewiesen (#184) | Loader-Konsum verdrahten (lauf-gated, Mess-Fenster) |
| B5 | E-4: aktiver extension_hardware-Familien-Knoten FEHLT (XML-Kanal+Validate fertig) | Q2 Option C: SIMD→GPU-Erweiterungspfad | simd_sub_axis + extension_hardware_system_axis CRTP da; kein Familien-Knoten | E-4 bauen; Flags→CompileFn, nie binary_id; Vorbedingung fuer echtes CEB-simd-Permutieren |
| B6 | Planer-KOPF fehlt: header-only Naht run_experiment_profile(_facade), kein Director/Builder, kein Executable | Bauplan 20260719, Phase-0-Blocker | execute_messreihe = return-0-Stub (v32_orchestrator.hpp); v32_messreihe_antrieb real aber INERT+DEPRECATED-BY-DESIGN; PhaseStrategyFor existiert | Existierendes Skelett (PhaseStrategyFor + run_experiment_profile_facade) WIEDERVERWENDEN, NICHT daneben bauen; je Phase User-Freigabe |
| B7 | Registry-Manifest-DRIFT: committed 18 Achsen/86 Bausteine inkl. isa als composition T11 (T00..T17) vs. Generator HEAD 17 composition T00..T16 + isa/telemetry als system_axis + 7 build_shape (nur with_extra) | Registry = reines generiertes Manifest | axis_registry_gen main.cpp:206-238 vs. committed XML | Registry-XML neu generieren+committen (binary_id-neutral); prt-art-Registry Schema-Gleichstand pruefen |
| B8 | XSD-Kopf behauptet "19 Achsen/90 Bausteine" | Ist: 17 Kompositions-Achsen (kV3AxisCount=17) | experiment_schema.xsd:9-10 | Kommentar bei naechster XSD-Beruehrung auf 17 nachziehen |
| B9 | mode full_sampled: beide XSDs erlauben es, MessreihenMode kennt nur Defined/Full — parse_mode faellt still auf Defined (Rohstring bleibt korrekt) | XSD-Enum | xml_config_parser.hpp:41-49 | semantisch definieren (Sampling-Breite) oder aus XSD-Enums deprecaten |
| B10 | Allocator-16-Familienraum nur im Legacy-XML; offizielle Organ-Achse allocator = 3 Bausteine | permutation_axes.xml:70-90 | Registry T06 = 3 | Entscheid: Enabled*-Nachzug per Vendoring-Doktrin oder dokumentiert entfallen |
| B11 | thread_count LABEL-ONLY: runtime_thread_count() ohne Consumer, abi_adapter counts=false — Sweep produzierte Phantom-Zeilen; ehrlich auf 1 gepinnt | runtime_dynamic-Kanal | kein Konsument | Fix A (#221-Rest) nur falls Multi-Thread-Messung je gewollt; sonst dokumentiert gepinnt |
| B12 | golden-N-BAU offen: XML-Materialisierung + opt-simd-Wiring + Referenz/Katalog-Entkopplung | feedback_new_golden_all_axes_xml_gt320 | Keimzelle+CRC64-Fixture da; Voraussetzungen erfuellt (#50 Cache done, #51 inert/Weg-A, #52 variant-Verbot done) | golden-N-Materialisierung nach Bauplan; je Schritt golden-Neutralitaet ausweisen |
| B13 | prt-art telemetry-Slot-Demo zielt auf Achse ausserhalb der 17er-Komposition; Verdrahtung in den Merge waere doktrin-widrig | ABI-6/INC-2c | Registry fuehrt axis_11 als pruefling_slot; kCompositionAxisNames ohne telemetry | User-Entscheid: als Sidecar-Beitrag umkategorisieren oder Demo belassen |
| B14 | Kommentar-Drifts (byte-neutral): prt_art_merge_reference.hpp "18 Achsen" (:117,:120); m3v2-Kopf "19 SLOTS T0..T18"; CI ".gitlab-ci.yml" "16 Darstellungs-.tex" (:530,588,612) | Ist: 17 / 17 / 17 je Sprache (34) | Code jeweils korrekt | bei naechster (TABU-vertraeglicher) Beruehrung nachziehen |
| B15 | F27 Fixture-Kanon: experiment_golden.xml als Sync-Kopie in ce tests/unit/thesis_tiere UND super Code/test_data_xml | Single-Source-Doktrin | Sync-PFLICHT via ctest test_fixture_sync_experiment_golden (bis E7/I7) | User-Entscheid F27; bis dahin beide synchron halten |

KEIN Gap (explizit verifiziert): measurement_categories — in BEIDEN Parser-Kanaelen getragen (ThesisProfile :236-245 + ExperimentProfile :312) und gegen kMeasurementAxisRegistry validiert.

### B.2 Nachgelagerte Drifts/Gaps (Auswertung/LaTeX/CI — Konsumenten des XML-Outputs)

| # | Gap | Ist | next_action |
|---|---|---|---|
| B16 | AXEN-ZAHL-DRIFT 19 vs 17: Thesis-Text "neunzehn Achsen"/"20 Segmente"; Stufe 05 kSegmentCount=20 MIT seg_isa_ns+seg_telemetry_ns → 17-Achsen-WIDE liefert 17+1 seg-Spalten → has_seg_ns=false → seg_attribution.tex wird NIE erzeugt | diagram_generator.hpp:182 + .cpp:31-32; thesis 06_fazit/A_measurements | Stufen 04/05/08 auf 17 (Segment-Liste aus CE-Single-Source ableiten); Thesis-Zahlen 19→17 (DE+EN) |
| B17 | Branch-Misses/IPC/Durchsatz fehlen im Record-Schema (FF3 braucht sie); Cache-Misses in Smoke-Reihe 0 (Limitierung 1) | PMC seit I-PMC-1 scharf (golden-320 mit -DCOMDARE_ENABLE_PMC=ON, prod1 pmc_available=1) | naechster COMDARE_RUN_MEASURE-Lauf liefert PMC-Spalten; Branch/IPC = Record-Erweiterung separat entscheiden (ABI darf brechen) |
| B18 | 4 Heuristik-Writer (sota_series_table A1, sweep_axis_longtable A3, seg_coverage A4, working_set_sweep_curve A2 = Heuristik-Messkurven-Form) parametrisch uebersprungen — WIDE traegt series/sweep_axis/working_set_n/seg_coverage nicht | Writer implementiert, kein Facade-Aufruf | sobald golden-N-Laeufe die Spalten emittieren: in 08-Facade + Anhang-A \InputIfFileExists (DE+EN) |
| B19 | Sensitivitaets-/Varianz-Ranking-Writer fehlt (Kern-Auswertungs-Forderung 05_evaluation: Achsen-Beitrag zur Varianz, Rang ueber 3 Granularitaeten, Standard-Konfig-Empfehlung je Workload-Klasse) | naechstliegend: ld_exchange-Paar-Differenzen + exchange_forest | neuer 04/05-Writer + Facade-Schritt; braucht golden-N-Datenbasis |
| B20 | Haupt-Text-Einbindung tikz/<spec_id>/ + tabellen/ (Reihen A/B/C) — Verzeichnisse existieren nicht, 4 \input auskommentiert | kein Generator-Pfad erzeugt sie | nach erstem Driver-Lauf Stufe-04/05-Outputs ablegen + einkommentieren (oder auf Anhang konsolidieren) |
| B21 | CI-Kettenende NICHT geschlossen (INC-7): kein Copy-Back regenerierter Anhang-.tex ins Thesis-Submodul; thesis:pdf haengt nicht hinter measure | persist sammelt nur nach measurement/<ts>/ | INC-7: Copy-Back → thesis anhang/{de,en}/tabellen/ + thesis:pdf nach Anhang-Regen = Kettenende "PDF mit Messwerten" |
| B22 | thesis:pdf baut nur EIN PDF (Default-\thesislang=de) statt DE+EN | build_all.ps1 baut beide lokal | CI auf Beide-Sprachen-Bau (latexmk 2x, jobname -de/-en) sobald TeXLive-Gate faellt |

---

## C) Rand-/Rahmenbedingungen des Experiment-Workflows (kompakt)

### C.1 Super-CI-Gates (`.gitlab-ci.yml`)

| Bedingung | Inhalt |
|---|---|
| workflow rules | Tag-Pipelines NIE (when:never); nur merge_request_event/web/pipeline/branch |
| Stage-Kette | lint → orchestrate → submodules → analyse → test → integration → manifest → thesis-pdf → measure → persist |
| lint:secrets | HARTES Eingangs-Gate der GESAMTEN Kette (needs von trigger:*, verify:submodules, ce-Gates); scannt nur super-Code |
| orchestrate | trigger:cache-engine/prt-art/thesis downstream mit strategy:depend (Modul rot = super rot); forward false/false (eigener Kontext) |
| verify:submodules | Gitlink-Determinismus HART (REV-CI-04): -/+/U → exit 1 |
| Submodul-Auth | REV15/17: STRATEGY none global; before_script klont 3 Submodule manuell mit Group-Deploy-Token, Token-URLs ephemer in .gitmodules; Lint erbt nicht |
| analyse:thesis-data | baut 4 Auswertungswerkzeuge OHNE PMC; kein build/-Artefakt (Object-Storage-500) |
| visibility:tier-binaries (#279) | permutations_manifest.txt + tier-binary-report geplant/gebaut/offen; HART, kein schwerer Lauf |
| test:unit / integration:smoke | da_unit hart (nicht Target all); E2E record.bin→CSV→LaTeX/TikZ auf Fixtures, kein DLL-Bau/PMC |
| manifest:provenance (#198) | EINE build_manifest.txt (SHAs+Toolchain+cpu_flags_sha256+Profil-Hashes); when:always, 12 weeks |
| prebackup:measurements | reiner Mechanismus-SELBSTTEST (additiv, sha256, Overwrite-Schutz rc=3); NIE in autoritativen measurement/-Baum; reale Backups #202-gated |
| thesis:pdf | NUR bei COMDARE_TEXLIVE_AVAILABLE==true (GATED, Infra); latexmk -halt-on-error; 4 weeks |
| Build-Parallelitaet | IMMER CMAKE_BUILD_PARALLEL_LEVEL=6, NIE -j nproc |
| Storage Ebene A | ccache via dev-MinIO runners.cache; CCACHE_DIR projektlokal; 3G super / 5G ce |

### C.2 Mess-Jobs (inert-by-default; CI-Gruen = Messung AUS)

| Job | Gate | Pflichten |
|---|---|---|
| measure:smoke | _bot_→never; COMDARE_RUN_MEASURE==true ODER COMDARE_MEASURE_PROFILE==smoke; tags [prod,baremetal,amd]; 12h | Profil via COMDARE_THESIS_PROFILE=m3_smoke_coverage; eigenes measure_out_smoke/ |
| measure:golden-320 | NUR COMDARE_RUN_MEASURE==true; tags [prod,baremetal,amd]; timeout 10 days (<14d-Ceiling); needs smoke optional (erst Smoke DANN Voll) | der EINE offizielle XML-Voll-Messlauf |
| beide | — | -DCOMDARE_ENABLE_PMC=ON PFLICHT; Pre-Flight `driver --validate` (lesend, Fail→Abbruch VOR Mehrtageslauf); Beleg-Check mind. 1 measurements.csv sonst exit 1; Anhang-Regen (#24) honest-empty-tolerant; Artefakte NUR *.csv + appendix/*.tex (NIE DLLs), 12 weeks; identische Invocation, Profil nur per env |
| persist:measurements (#22) | _bot_→never; COMDARE_PERSIST_MEASUREMENTS==true && branch==development; Writeback-Token (id=54, write_repository, inert) PFLICHT | measurement/<YYYYMMDD-HHMMSS-p{pipeline}>/ additiv, NUR *.csv/*.tex; PROVENANCE.txt; Loop-Schutz DREIFACH (ci.skip + [skip ci] + _bot_-rule); non-ff → fetch+MERGE (NIE rebase/force), max 5 Versuche |

### C.3 ce-Pipeline (REV10)

| Punkt | Inhalt |
|---|---|
| Stages | lint → build → sanitize → contract → test → chaos |
| .pmc | build+measure in EINEM Job; timeout 15m fail-fast; PMC-Smokes scharf (COMDARE_ENABLE_PMC=ON) |
| pmc:intel / arm64 | prod2 gated (COMDARE_PROD2_AVAILABLE, seit 09.07. aus); arm64-smoke opt-in COMDARE_ISA_MATRIX, advisory (#276) |
| test:unit | HART (#278, "100% tests passed, 0 failed out of 164"); Scope -LE contract\|pmc; 2-Pass PREBUILD codegen-CLIs vor byte_identity |
| sanitize:tsan | HART; DLL-dlopen-Tests bewusst ausgeklammert |
| chaos:drift (#197) | >5% Wiederholungs-Abweichung → Gruppen-Rerun bis max_reruns, danach advisory stabilste Gruppe; Mechanismus HART verifiziert; reale Kalibrierung #156-gated |

### C.4 Storage-3-Ebenen-Doktrin (#51)

| Ebene | Inhalt | Status |
|---|---|---|
| A (ccache) | dev-MinIO runners.cache | ERLEDIGT |
| B (Tier-Binaries) | prod-MinIO Bucket cache-engine-tier-binaries via mc-Shellout; Key <build_version>/<stem>/perm.dll(+.version); perm.dll ZUERST / .version ZULETZT (halb-gepusht = kein Pull); Key koppelt an dll_is_current-Signatur → stale ABI nie reused | Code fertig+INERT; Weg-A-CI-Aktivierung gelandet (COMDARE_STORAGE_CACHE-Gate) |
| C (Messergebnisse) | write-only measure-drop HTTPS-PUT <DROP_URL>/<ts>/<datei>; 409 = still-additiv-OK; PARALLEL zu git-persist; KEIN POSIX-Mount (Entscheid A 18.07.) | Code fertig+INERT |
| Doktrin | from_env() NUR env; unkonfiguriert → INERT → No-Op → golden byte-identisch; Creds NIE argv/Log (MC_HOST_<alias>, 0600-curl-Config); Fehler → InfraErrorClass::ArtefaktIo-Log NEBEN Datei, MESSUNG LAEUFT WEITER; SYNCHRON (async VERBOTEN, I/O-Contention=Messfehler); posix_spawn ohne /bin/sh; kein Python | ERLEDIGT |
| Infra-Endstrecke | Handout P1-P6 (IMPL-TO-INFRA 19.07.): mc im Runner-Image, CI-Vars Projekt 288, Bucket erreichbar, measure-drop V60 — Cluster fuer Impl-Agent NUR lesend (Handover-Pflicht) | OFFEN |

### C.5 Sequentialitaet + Mess-Doktrin

- Debug=parallel, Mess=1-Thread (Gattung aus Binary); nie Nullen.
- Storage-Push haengt SYNCHRON per-Binary im 1-Thread-Loop: NACH result.csv+stamp, VOR RAII-DLL-Unload; (1) cache_push Ebene B, (2) measurement_sink Ebene C; naechste Messung erst nach Rueckkehr; No-Op-Default = golden byte-identisch.
- Resume-Stamp nur bei (a) CSV stream-verifiziert, (b) rows==settings>0, (c) jede Zeile two_phase_valid; sonst Stamp entfernt → Voll-Neumessung. Ohne dyn. Dims: genau EIN Punkt "as built", setting_id==binary_id.
- Messdaten NIE loeschen (additiv); Rohdaten-Backups additiv.
- Runner-Topologie: PMC-Pflicht-Node prod1 (tags [prod,baremetal,amd], Runner id=16, perf/MSR bewiesen); Nicht-Mess-Jobs [baremetal]; prod2/intel + arm64 gated.

### C.6 Fehlerklassen-Taxonomie (#29) — PFLICHT je Achse→Unterachse→Algo

| Klasse | Werte | Verhalten |
|---|---|---|
| D1 CompilerCompilerErrorClass | KonfigXmlParse / ToolchainFehlt / HardwareErweiterungFehlt / CompileKombination (Count=4) | im LOG deklariert, Experiment misst weiter |
| D2 SampleStatus | Ok / NotApplicable / SourceUnavailable / Failed (Count=4) | CSV-Zelle Zahl/'n/a'/'failed', NIE Null; Log neben CSV |
| InfraErrorClass | ProzessStart(127) / ProzessAbbruch(128+sig) / IO(125) / ArtefaktIo | DISJUNKT von D1 — Infra nie als HW-/Compile-Klasse fehletikettiert; Drift-Guards constexpr |

### C.7 LaTeX-Ende (Kettenende) + Forschungsfragen

- Bilingual Single-Source \thesislang (DE+EN, XOR je PDF); aktive Kapitel 01-06 + Anhang A-F; 8er-Altdateien nicht eingebunden (nicht loeschen).
- Anhang A fordert 21 eingebundene .tex je Sprache: 16 committed + 5 per \InputIfFileExists (fehlen bis Messlauf mit seg_*_ns/stat_*; PDF kompiliert dank Guard). Stufe-08-Facade: 12 Kern + 5 additiv = 17 je Sprache (34 gesamt), in-process, honest-empty.
- Perzentile: WIDE nur Aggregat p50 (Pflicht) + p99 (optional), nearest-rank; Thesis dokumentiert p50-p99-Range + Konfigurations-ECDF; HDR-Forderung der Methodik ggf. Text angleichen statt Code aufblasen.
- FF0-FF4 (sec:rqs): quantifizierte Differenz aktiv vs. passiv; Reihen A-C ueber 3 Granularitaeten mit HW-Zaehlern; PRT-ART vs. 8 Rang-1-SOTA (Mikroarchitektur-Metriken); provenienz-nachweisbare Binaries. Fazit beantwortet bisher nur methodisch → golden-N-Laeufe liefern Zahlen → 06_fazit honest-100% (Deadline 28.07.).
- Heuristik-Automation + Binary-Delivery (Teilaufgabe 7) = explizit Folge-Phase; keine zusaetzlichen Darstellungen ueber Sensitivitaet+Kurven hinaus gefordert.
- Anhang-A-Prosa auf Smoke-43 kalibriert → nach golden-N additiv neue Sektion (alte historisch stehen lassen).

### C.8 Ablauf-Doktrin Ende-zu-Ende (ENTSCHEIDUNG)

lint:secrets → orchestrate (3 Module gruen) → verify:submodules (Gitlink exakt) → Tools/Tests/Integration/Manifest gruen (= CI-Gruen OHNE Messung) || opt-in: COMDARE_MEASURE_PROFILE=smoke (nur Smoke) oder COMDARE_RUN_MEASURE=true (Smoke DANN golden-320, PMC ON, --validate-Pre-Flight, Storage-#51 inert/scharf) → persist:measurements (nur development + Gate + Token, dreifacher Loop-Schutz, merge-nie-rebase) → Messdaten additiv in measurement/<RUN_TS>/, nie geloescht.

---

## KORREKTUR-NACHTRAG (Vollstaendigkeits-Kritik 2026-07-19)

**Ledger §27+§28 (NEUESTE Eintraege 19.07.) fehlten in diesem Katalog:** Der in A.6/C beschriebene **2-Registry-Kanon (ce+prt-art) ist der IST-Stand**; die Ziel-Struktur ist per §28 **DREI art-spezifische Angebots-Registries je Modul**: (1) Organ-Registry (existiert, A.1/A.7), (2) **System-Registry NEU** im measurement-Modul (die A.2-Achsen samt Unter-Achsen opt/Flags/simd/march/target — loest die Gaps B1/B2 kuenftig ueber Registry-ANGEBOT statt nur XSD-Erweiterung), (3) **Mess-Registry NEU** im Mess-Modul (A.3-Kategorien, Kollektoren, A.4-DynamicDims, Workload-Achse). Dazu §27: Planer erhaelt eine **Resolver-/Link-Stufe** (.pom-Modell: Registry=ANGEBOT, Anwender-XML=ANZEIGE; Andocken an `validate_profile.hpp`, KEIN Parallel-Validator; Detail-Doc `docs/plaene/20260719-registry-angebot-anwender-xml-resolver-STUFE.md`). In der Roadmap als PL-17/PL-18 (F-1) nachgetragen.
