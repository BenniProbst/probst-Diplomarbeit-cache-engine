# STRANG C — Live-Bestand + Klassifikation (Delta-Matrix-Rohmaterial, Spalte „Live")

Datum: 2026-07-16. Autor: Strang-C-Agent (read-only-Kartierung, keine Code-Änderung).
Pfad-Konvention: alle `datei:zeile`-Belege sind relativ zu
`Code/external/comdare-cache-engine/` (im Folgenden „ce/"), außer explizit anders angegeben.
Absoluter Wurzelpfad: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/`.

Klassifikations-Vokabular (aus dem USER-KONZEPT 2026-07-16):
- **GATTUNG** = Algorithmus-Gattungs-Achse: wird von der CEB in die Tier-Binaries EINKOMPILIERT, permutiert, Teil der `binary_id`.
- **MESS-SYS** = Mess-System-Achse: CEB-/host-seitig, misst „nach einer Strategie", nie Organ-Slot.
- **WEDER-NOCH** = weder in Tier-Binary einkompilierter Permutations-Slot noch Mess-System-Achse.

Referenz-Anker der Klassifikation (gelten für alle Einträge):
- Die 19 Komposition-Achsen der `binary_id` (T0..T18): `libs/cache_engine/builder/experiment_tree/axis_path_serialization.hpp:30-34` — enthält `allocator`(T6), `prefetch`(T7), `concurrency`(T8), NICHT `general_hardware`.
- Die 26 Baum-Achsen inkl. 3 build-only: `libs/cache_engine/builder/experiment_tree/registry_to_axis_levels.hpp:6-9` („3 build-only-Achsen (page_type/01, simd_extension/09b, general_hardware/12; DefinitionOnly)") und `:67-76` (T17_page_type/T18_simd_extension/T19_general_hardware/T20-T21 queuing/T22-T25 node-shape).
- Observer-Klassifikation aller 26 Achsen: `libs/cache_engine/builder/experiment_tree/axis_observer_classification.hpp:47-79`.
- 19-Slot-Komposition (Einkompilierung in die Tier-Binary): `libs/cache_engine/anatomy/composition_factory.hpp:51-70` (`AdHocComposition` mit `allocator=T6`, `prefetch=T7`, `concurrency=T8`, `isa=T12`).
- Mess-System-Achsen sind host-seitig/„Blut": `libs/cache_engine/include/cache_engine/measurement/system_axis.hpp:143-145` („System-Achsen sind bei eingeschalteter Messung immer host-seitig praesent (Blut-Direktive), unabhaengig von Tier-Permutation und E2/E3-Baum. Sie sind keine Organ-Taxonomie und kein austauschbarer Achsen-Slot.").

---

## 1. axis_12 — general_hardware (T19)

**Klassifikation: WEDER-NOCH (build-only „DefinitionOnly"-Achse; weder 19-Slot-Gattungs-Achse noch Mess-System-Achse).**

Belege:
- NICHT in der 19-Achsen-`binary_id`: `axis_path_serialization.hpp:27-29` — „zwischen T16 und q1/q2 [stehen] die 3 build-only-Achsen (page_type/simd_extension/general_hardware)"; die Slot-Liste `:30-34` enthält kein `general_hardware`.
- ABER Baum-Ebene mit Fanout: `registry_to_axis_levels.hpp:103` (`push_static_axis<axes26::T19_general_hardware>(lv, "general_hardware")`) und Kardinalitäts-Produkt `:124` (`enabled_count<axes26::T19_general_hardware>`).
- Observer-Natur: `axis_observer_classification.hpp:68` — `{"general_hardware", AxisObserverKind::DefinitionOnly}, // 12 Hardware, Build-Konstante`; Definition der Kategorie `:9-11` („Build-Zeit-KONSTANTEN (kein Laufzeit-Zustand) → … KEINEN Laufzeit-Observer").
- Varianten (3): `libs/cache_engine/topics/hardware/axis_12_general_hardware/axis_12_general_hardware_registry.hpp:42` (`AllPlatforms = mp_list<GenericHardwareProfile, X86_64HardwareProfile, Aarch64HardwareProfile>`), CMake-gated `:20` + Root-`CMakeLists.txt:272-274` (`COMDARE_AXIS_12_ENABLE_GENERIC/X86_64/AARCH64`, alle ON) + `:945-953` (configure_file der flags).
- Pflicht-Properties (Konzept): `topics/hardware/axis_12_general_hardware/concepts/axis_12_general_hardware_concept.hpp:21-25` — `cache_line_size()`, `memory_page_size()`, `simd_width_bits()`, `numa_capable()`, `huge_page_capable()`.
- Sub-Achsen HW1–HW4 (compile-time Tags): `axis_12_general_hardware_subaxes_hw1_to_hw4.hpp:26` (HW1 cpu_family), `:31` (HW2 simd_capability), `:36` (HW3 memory_topology — **NUMA + Cache-Hierarchie**: „UMA-single-socket, NUMA-multi-socket, Apple-unified-memory, HBM-on-package, CXL-attached"), `:41` (HW4 page_topology).
- Permutations-Identität existiert formal (Concept verlangt `axis_tag`/`family_id`/`name`/`flag_suffix`/`enabled`): `concepts/axis_12_general_hardware_cache_engine_permutation_concept.hpp:39-46`; CRTP-Basis mit 3-fach Concept-Check: `axis_12_general_hardware_strategy_base.hpp:16-29`.
- Cross-Constraints ISA×SIMD×Plattform (physisch unmögliche Tupel compile-time weggefiltert): `topics/hardware/topic_hardware_config_set.hpp:46-59` (isa_simd_compatible), `:68-88` (isa_platform_compatible), `:119` (FilteredIsa09xPlatform12), `:131-133` (FilteredIsa09xExt09bxPlatform12).
- Realer Property-Konsum (einziger!): die NUMA/Page→Allocator-Kante F-B, s. §3 (`axes/alloc/alloc_hw_config.hpp:5-10` — „Vor F-B waren memory_page_size/huge_page_capable NIRGENDS konsumiert (honest-0)").

**Delta zum USER-KONZEPT (Pflicht-Systemachse „Hardware/NUMA"):** general_hardware ist heute Build-Konstante + Property-Quelle, KEINE eigenständige, gemessene System-HAUPTACHSE mit dynamischen Unter-Achsen. HW3 (NUMA-Topologie) existiert nur als Doku-Tag ohne treibende/messende Mechanik.

---

## 2. axis_08 — concurrency (T08)

**Klassifikation: GATTUNG (19-Slot-Komposition, einkompiliert, `binary_id`-Segment `concurrency=<name>`).**

Belege:
- Slot T8 der Komposition: `composition_factory.hpp:59` (`using concurrency = T8;`); `binary_id`-Name: `axis_path_serialization.hpp:33` (`"concurrency"`); Baum-Ebene: `registry_to_axis_levels.hpp:58,92`; Observer: `axis_observer_classification.hpp:56` (SearchAlgorithmObserver).
- 9 Organe: `axes/concurrency_axis/axis_08_concurrency_registry.hpp:23-25` — `NoneConcurrency, BlockingConcurrency, ReaderWriterConcurrency, OlcOptimisticConcurrency, LockFreeConcurrency, WaitFreeConcurrency, RcuConcurrency, HazardPointerConcurrency, OlcReservedBlocksConcurrency`; flag-gated `:30` (`EnabledStrategies = mp_filter<is_enabled, …>`).
- topics/-Seite ist reiner Alias auf axes/: `topics/concurrency/axis_08_concurrency/axis_08_concurrency_subaxes_cc1_to_cc2.hpp:2-4` (using-namespace-Weiterleitung).

**Deckt axis_08 „Locking" ab?** Auf ORGAN-/Gattungs-Ebene ja, auf SYSTEM-Ebene nein:
- Sub-Achsen: `axes/concurrency_axis/axis_08_concurrency_subaxes_cc1_to_cc2.hpp:4-8` — „Topic-Doku (Master §11.7.A) nennt 3 Sub-Dimensionen: Pattern / Locking-Mode / Coherence. In der Achsen-Implementierung fallen Locking-Mode + Coherence natuerlich zusammen zur Reclamation-Dimension"; CC1 `synchronization_pattern_tag` `:13`, CC2 `reclamation_scheme_tag` `:16`.
- Echtes Locking-Primitiv wird getrieben: `axis_08_concurrency_blocking.hpp:17-19` („Pessimistic: globaler/coarse-grained Mutex (std::mutex) … Vergleichs-Obergrenze fuer Locking-Overhead") + Mess-Kopplung acquire/try_acquire mit ehrlicher Contention-Zählung `axis_08_concurrency_observable.hpp:89-100`.
- KEINE host-/CEB-seitige Locking-Systemachse vorhanden (keine SystemAxis-Ableitung, kein Mess-Regime): `system_axis.hpp` kennt nur WallClock/ObserverSnapshot/Pmc (`:192,238,283`) — nichts zu Locking/Contention auf Systemebene.

**Runtime-Unter-Achse (RC):** `thread_count` — Feld `anatomy/resource_controllable_tier.hpp:35`; Setter auf jeder Observable-Hülle `axis_08_concurrency_observable.hpp:82-84` (Clamp auf 64); ABER: „der In-Prozess-In-Memory-Tier KONSUMIERT ihn nicht in der Mess-Scan (runtime_thread_count() hat repo-weit null wirkende Aufrufer …) … zaehlt aber NIE als applied … Echter Threading-Konsum = Fix A (#221-Rest, deferred)" — `anatomy/abi_adapter.hpp:254-262`. Zusätzlich dynamische Baum-Ebene `concurrency.thread_count`: `builder/experiment_tree/profile_to_tree.hpp:92-93`.

---

## 3. axis_06 — allocator (T06)

**Klassifikation: GATTUNG (19-Slot-Komposition, einkompiliert, `binary_id`-Segment `allocator=<name>`).**

Belege:
- Slot T6: `composition_factory.hpp:57`; `binary_id`-Name `axis_path_serialization.hpp:32`; Baum `registry_to_axis_levels.hpp:56,90`; Observer `axis_observer_classification.hpp:54` (SearchAlgorithmObserver, „R5.B: search_algo + allocator + … operativ" `:7`).
- 26 Vendor-Organe: `axes/alloc/axis_06_allocator_registry.hpp:78-99` (StdMalloc … VampirNfpAllocator; „Allocator-Achse 6 KOMPLETT (26 Vendor …)").

**Sub-Achsen AA1–AA7 (compile-time Klassifikations-Tags, `typename axis_tag`):** `axes/alloc/axis_06_allocator_subaxes_aa1_to_aa7.hpp` —
AA1 freelist_topology `:30`, AA2 size_class_schema `:40`, AA3 thread_locality `:50`, AA4 synchronization `:60`, AA5 allocation_policy `:70` (**NUMA-Anteil**: „NUMA-origin-aware (A09 NUMAlloc), cache-set-aware (A12 CAMA), NUCA-aware (A14 …), PIM-aware (A16 …)" `:66-68`), AA6 reclamation `:80`, AA7 fragmentation_strategy `:90`. Zweck/Permutations-Konsequenz `:12-14` („der CacheEngineBuilder kann Familien nach Sub-Achsen gruppieren").

**NUMA-Anteile über AA5 hinaus — die F-B-Unterachse `alloc_hw` (compile-time, Achse-12-Kante):** `axes/alloc/alloc_hw_config.hpp`
- Mechanik `:2-10`: general_hardware-Properties `numa_capable`/`memory_page_size`/`huge_page_capable` fließen als COMPILE-TIME-Inputs in axis_06, „NUR an der Allocator-Kante, HW-als-Typ-Parameter, if constexpr-Gating (numa_capable=false -> NUMA-Pinning wegkompiliert)".
- Werteräume `:37` (`AllocNumaNode {Auto=-1, Node0, Node1}`), `:42` (`AllocPageHint {Native, Page4k, Page2m}`).
- `binary_id`-Relevanz NUR profil-aktiviert `:16-17`; Baum-Andockung: `profile_to_tree.hpp:69-74` (`ref=="alloc_hw"` → statische Sub-Ebenen `alloc_hw.numa_node` + `alloc_hw.page`).
- HW-Gate `:94-102` (`gate_alloc_hw_for<HW>`), realer Konsum `:18-20` (NUMAllocAllocatorBody, PoolResourceAllocatorBody), HW-Gate-Grenze ehrlich `:22-24` („NUMA-EFFEKT braucht Multi-Socket-Hardware (HW-gated ~Sep)").

**Runtime-Unter-Achse (RC):** `pool_budget_bytes` — Feld `resource_controllable_tier.hpp:37`; Anwendung nur store-backed: `abi_adapter.hpp:270-275` („Setter NUR auf store-backed Kompositionen (observable_composed_search.hpp:115-118 → flacher Store axis_04:253)"); Setter-Implementierung `axes/node/axis_04_node_type_layout_aware_store.hpp:253`.

---

## 4. axis_07 — prefetch (T07)

**Klassifikation: GATTUNG (19-Slot-Komposition, einkompiliert, `binary_id`-Segment `prefetch=<name>`).**

Belege:
- Slot T7: `composition_factory.hpp:58`; `binary_id`-Name `axis_path_serialization.hpp:32`; Baum `registry_to_axis_levels.hpp:57,91`; Observer `axis_observer_classification.hpp:55` (SearchAlgorithmObserver).
- 4 Organe: `axes/prefetch_axis/axis_07_prefetch_registry.hpp:18` (`AllPrefetchers = mp_list<NonePrefetch, DistanceEstimatorPrefetch, HardwarePrefetch, PathOrientedPrefetch>`).
- Sub-Achsen PF1–PF3 (compile-time Tags): `axes/prefetch_axis/axis_07_prefetch_subaxes_pf1_to_pf3.hpp:7` (PF1 trigger_mechanism: none/compile-hint/hw-instruction/observed-pattern), `:10` (PF2 distance_heuristic: none/linear/adaptive), `:13` (PF3 granularity: cache-line/page/bundle).

**Runtime-Unter-Achsen (RC + dynamische Baum-Ebene):**
- `prefetch_distance` — Feld `resource_controllable_tier.hpp:36` (Distanz/Tiefe in Cache-Lines); Anwendung: `abi_adapter.hpp:263-268` („Setter NUR fuer DistanceEstimatorPrefetch (prefetch_family_v==1, axis_07_prefetch_observable.hpp:119-123); None/Hardware/Path tragen ihn nicht"); Setter `axes/prefetch_axis/axis_07_prefetch_observable.hpp:119`; Test-Anker `tests/unit/test_221_rc_prefetch_distance.cpp`.
- `prefetch.hw_prefetcher` als DYNAMISCHE Baum-Ebene: `profile_to_tree.hpp:94-95`; MSR-Realität nur auf Cluster (abi_adapter-Kommentar `:258-259` „hw_prefetcher-MSR-Ausnahme (nur auf dem Cluster real)").

---

## 5. c11_scheduler-Deskriptor

**Klassifikation: WEDER-NOCH — reines Subsystem-Interface-Skelett, unverdrahtet. Das ist der Live-Beleg für „Pflicht-Systemachse Scheduling = TODO/kaputt".**

Belege:
- Gesamtbestand des Subsystems = 3 Dateien: `libs/cache_engine/subsystems/c11_scheduler_engine/{.gitkeep, CMakeLists.txt, i_scheduler_engine.hpp}` (find-verifiziert).
- Deskriptor: `i_scheduler_engine.hpp:2-3` („C11 ISchedulerEngine — Page-Type-Wechsel + Operations-Scheduling; Termin 7 / 02_md §2 (PageTypeChangeTree) + P05 START Self-Tuning"); `SchedulingKind` `:9-14` (PageTypeUpgrade/PageTypeDowngrade/PageRebalance/OperationDeferral); abstrakte Klasse `:16-27` (schedule/run_due_operations/total_scheduled/total_executed).
- KEINE Implementierung, KEIN Konsument in libs/ (grep „c11_scheduler|ISchedulerEngine" trifft in libs/ nur den Header selbst); einziger Test-Berührpunkt: `tests/unit/test_sub_engines.cpp:45` (`is_abstract_v`), `:111-114` (Enum-Werte).
- CMake ist sogar fehl-etikettiert: `subsystems/c11_scheduler_engine/CMakeLists.txt:1-5` — Kommentar „page_type_scheduler — Sub-Komponente / Skelett (Phase 4.B) — keine Implementation", Target `comdare_page_type_scheduler` (INTERFACE).
- Semantik-Hinweis: `SchedulingKind` betrifft datenstruktur-internes Scheduling (Page-Type-Wechsel/Deferral), NICHT OS-Thread-Scheduling — auch inhaltlich keine Deckung der System-Scheduling-Achse des USER-KONZEPTS.
- Verwandte Skelette (für die Pflicht-Systemachsen Scheduling/NUMA relevant, alle unimplementiert):
  - `subsystems/c02_pinning_engine/i_pinning_engine.hpp:10-16` (`PinningTarget` inkl. `NumaLocalCore=3`), abstrakt `:18-28`; keine Implementierung/Konsumenten.
  - `subsystems/c10_topologie_engine/i_topologie_engine.hpp` (26 Zeilen, Interface-only).
  - `libs/cache_engine/concurrency_manager/*` — 8 Unterordner, ausschließlich `.gitkeep`+`CMakeLists.txt` (find-verifiziert).
  - `libs/common/platform/hybrid_core_pinning/` + `libs/common/platform/hugepage_manager/` — nur `.gitkeep`+`CMakeLists.txt`.

---

## 6. Mess-System-Achsen (CEB-/host-seitig) — „Blut"/Querschnitt M

**Klassifikation: MESS-SYS (alle Bausteine dieses Abschnitts). Host-/CEB-seitig verankert, ausdrücklich KEIN Organ-Slot, quer zu allen Tier-Permutationen.**

### 6.1 measurement_category.hpp — die 16 Kategorien
- `libs/cache_engine/include/cache_engine/measurement/measurement_category.hpp:10-27`: `MeasurementCategory` = CLU, CACHE_MISS_L1/L2/L3, DTLB_MISS, MEMORY_FOOTPRINT, BRANCH_MISS, IPC_CPI, LATENCY_MEAN/P50/P95/P99/P999, THROUGHPUT, ENERGY_J, FILL_BUFFER_OCCUPANCY; Drift-Guard `:32` (`kMeasurementCategoryCount = 16`).

### 6.2 system_axis.hpp — SystemAxis-Wurzel (CRTP, compile-time)
- Wurzel: `system_axis.hpp:148-180` (`template <Derived> struct SystemAxis` mit `categories()/regime()/available()/collect()`); Concept `:183-190` (`SystemAxisConcept`: empty, non-polymorphic — keine vtable).
- Regime-Zweiteilung (die „Strategie" der Messung): `:20-23` (`MeasurementRegime {TimeObserver, PmcCounter}`), Listen `:36-40` (7 PMC) + `:42-52` (9 TimeObserver), Single-Source `regime_of` `:54-80` (mit Thesis-Belegen 03_messsystem_prtart.tex:382-386 + 06_evaluation_methodology.tex:119-126 im Kommentar), Vollständigkeits-static_assert `:130-132`; Regime-Misch-Verbot je Achse `:117-126` (consteval `regime_for_axis`).
- Host-Verankerung: `:143-145` („immer host-seitig praesent (Blut-Direktive), unabhaengig von Tier-Permutation und E2/E3-Baum … kein austauschbarer Achsen-Slot"), `system_axes_always_present()` `:145`.
- 3 konkrete System-Achsen: `WallClockSystemAxis` `:192-236` (LATENCY_MEAN/THROUGHPUT; Perzentile honest-0 invalid `:224-231` — „Echte Perzentile liefert das HdrHistogramm (AP-8/#242)"); `ObserverSnapshotSystemAxis` `:238-277` (CLU aus `axis_stats[5][2]`/`[5][3]`, Schema-gebunden per static_assert `:280-281`; MEMORY_FOOTPRINT + FILL_BUFFER_OCCUPANCY honest-0 invalid `:267-274`); `PmcSystemAxis` `:283-332` (7 PMC-Kategorien; IPC_CPI invalid, da PmcCounters-POD keine instructions/cycles-Spalten hat `:325-329`).

### 6.3 measurement_axis_registry.hpp — DIE Registry der Mess-System-Achsen
- `measurement_axis_registry.hpp:2-5`: „Phase-6-Vorbau (2026-07-10): compile-time Mess-Achsen-Registry ueber die 16 MeasurementCategory-System-Achsen (»Blut«, Dossier 19 Querschnitt M). KEIN Runtime-Switch … Konsumenten (E4-Reporting, Pruef-Dock-Verdrahtung) = Folge-Increment."
- Registry `:32-49` (16 Einträge, Name = Enum-Name = E4-CSV-Vokabular), consteval-Vollständigkeit `:52-62`, constexpr-Lookup `:65-67`, **Mess-Visitor** `for_each_measurement_axis` `:70-75` (Metaprogrammierungs-Iteration).
- Live-Konsumenten: `profile_facade/validate_profile.hpp:55-56,298` (Single-Source der 16 Kategorie-Namen für Validierung) + `tests/unit/test_phase6_vorbau.cpp`. E4-Reporting-Verdrahtung noch offen (Vorbau-Status).

### 6.4 i_measurement_source.hpp — vendor-neutrale Mess-Quellen (host-seitig)
- Host-Verankerung explizit: `i_measurement_source.hpp:4-6` — „Bewusst HOST-seitig (nicht ueber die DLL-Grenze): PMC-Zugriff braucht OS-Privilegien/Treiber, die ein Lebewesen-Modul nicht haben soll; die echte Erhebung umklammert host-seitig den run_workload-/tier_*-Aufruf am Dock. Runner-/Pruef-Dock-Verdrahtung = Folge-Increment."
- 10 `MeasuredEvent`s `:24-36`; Caps mit ZIH-Gate `:51-57` (`needs_admin`, `hybrid_core_aware`); `MeasuredDelta` mit per-Event-Gültigkeit (honest-Doktrin) `:61-69`; Interface `:72-85`; garantierter `WallClockSource`-Fallback (ns-Proxy) `:100-128`; GoF-Adapter auf Bestands-PMC-Familie (7 Kanäle, grob-granulare valid-Stempelung) `:136-184`.
- Live-Konsument: nur `tests/unit/test_phase6_vorbau.cpp` (Vorbau, unverdrahtet).

### 6.5 curve_fit (E4'-Vorbau) — CEB-seitige Auswertungs-Stufe
- `libs/cache_engine/builder/curve_fit/curve_fit.hpp:2-5`: „E4'-Kurven-Fit-SKELETON (Phase-6-Vorbau …): CSV -> Kurven -> Schaetzer-Stufe … HONEST-EMPTY-Doktrin … Der reale Fit ist datengetrieben und bleibt auf #156-Messdaten gated."
- Kurve je Mess-Achse (Kategorie aus der Registry) über Working-Set `:36-42`; Modell `y = a*log2(x) + b` `:51-57`; `fit_log_linear` `:62` mit Ehrlichkeits-Stati `:44-49` (NoData/InsufficientPoints/InvalidData/Ok).
- Spalten-Wahrheit `:7-12`: Registry-Namen (LATENCY_P99 …) = E4-REPORTING-Vokabular, NICHT die Bestands-CSV-Spalten (`op_<art>_p99_ns` …) — Mapping = E4'-Folge-Stufe.
- Live-Konsument: nur `tests/unit/test_phase6_vorbau.cpp`.

### 6.6 selection_filter_chain (S4) — der Filter des Experiment-Baums für die CEB-Stufe
- `libs/cache_engine/builder/experiment_tree/selection_filter_chain.hpp:2-6`: „Chain of Responsibility (GoF) im CacheEngineBuilder fuer die Kontrolle der Tier-Binary-GENERIERUNG (Doc 20 §C). Schliesst die … Feedback-Kante Auswertung (best_binary_selector) -> Generierung (build_orchestrator provision_all): … join ueber binary_id …".
- `PermutationCandidate::binary_id` als 19-Achsen-Join-Schlüssel `:42-46`; CoR-Handler `:49-69`; einziges Live-Glied `ResumeFilter` `:76-83` (two_phase_valid → nicht neu bauen); Ausführung `run_selection_filter_chain` `:87-100`.
- Bewusst DEFERRED `:15-20`: PaperComparison (Wall-Clock-Vorrang, data-gated) + DominanceHandler/Pareto (braucht Messkurven-Typsystem-Schlüssel framework×workload×op×size, „noch nicht gebaut").
- Kontext „Experiment-B+-Baum": tatsächlich ein achsen-geschichteter PRÄFIXBAUM (Benennungs-Ehrlichkeit): `experiment_tree.hpp:4-10`; lazy Odometer-Materialisierung + dynamische Variablen als virtuelle for-Schleifen `:15-26`.
- Live-Konsument: nur `tests/unit/test_d15_selection_filter_chain.cpp`.

### 6.7 Weitere Mess-Bausteine (Einordnung)
- `measurement/measure.hpp:23-29` — `Measure<Cat, Detail>` constexpr-Hook-Matrix (F1): TIER-seitige compile-time Mess-Hooks (at_lookup_begin/at_node_visit/extract), Default no-op. Klassifikation: Mess-Apparat, aber tier-binary-seitig einkompilierter Hook — kein Permutations-Slot, keine `binary_id`-Wirkung.
- `measurement/in_memory_measurement_buffer.hpp:2` — F5, append-only, „kein Lock im Hot-Path"; Dump-Format COMDARE-MEASUREMENT-V1 `:20-29`. Host-seitige Persistenz-Ebene.

---

## 7. RC-/Runtime-Unter-Achsen — ComdareResourceControlV1 (die dynamischen UNTER-ACHSEN im Live-Bestand)

POD-Definition: `libs/cache_engine/anatomy/resource_controllable_tier.hpp:34-43` — 6 uint64-Felder, Sentinel 0 = „nicht setzen":

| Feld | Achse | Live-Wirkung (Beleg) |
|---|---|---|
| `thread_count` (:35) | concurrency (axis_08) | Setter durchgereicht, zählt NIE als applied; in-Prozess wirkungslos, Fix A deferred (`abi_adapter.hpp:254-262`) |
| `prefetch_distance` (:36) | prefetch (axis_07) | real NUR DistanceEstimatorPrefetch (`abi_adapter.hpp:263-268`; Setter `axis_07_prefetch_observable.hpp:119`) |
| `pool_budget_bytes` (:37) | allocator (axis_06) | real NUR store-backed Kompositionen (`abi_adapter.hpp:270-275`) |
| `batch_size` (:38) | traversal (axis_03a) | adapter-konsumiert als Fenster-Semantik, genus-invariant (`abi_adapter.hpp:281-284`) |
| `inline_threshold_bytes` (:39) | value_handle (axis_14) | real konsumiert im threshold_scan (`abi_adapter.hpp:277-280`; `axis_14_value_handle_observable.hpp:95`) |
| `controllable_axis_count` (:40) | Meta/Diagnose | Zähl-Wahrheit via Detection-Idiom (`abi_adapter.hpp:236-249`) |

- Interface `IResourceControllableTier` `:56-68`; IMMER einkompiliert, NICHT messungs-gated `:14-15` („Die Steuerschnittstelle bleibt AKTIV AUCH BEI ABGESCHALTETER MESSUNG"); ABI: standard_layout+trivially_copyable static_asserts `:45-48`, Version `:51`.
- Host-Caps-Obergrenzen: `abi_adapter.hpp:224-232` (thread_count 64, prefetch_distance 64 Lines, pool 1 GiB, batch 4096, inline 256 B).
- Dynamische Baum-Ebenen (die Laufzeit-for-Schleifen ÜBER einer Tier-Binary): `profile_to_tree.hpp:85-95` — EINZIGE Quelle: `concurrency.thread_count` + `prefetch.hw_prefetcher`; Modell `experiment_tree.hpp:23-26` („DYNAMISCHE Variablen sind VIRTUELL ineinander verschachtelte for-Schleifen … Algorithm_Resource_Control").

**Befund zur USER-These „beide Achsen-Konzepte haben dynamische runtime-UNTER-ACHSEN":** Für GATTUNGS-Achsen live vorhanden (RC-POD + 2 dynamische Baum-Ebenen). Für MESS-System-Achsen gibt es KEINE dynamischen Unter-Achsen — die 16 Kategorien sind rein statisch/constexpr; einzig `available()`/valid-Flags degradieren zur Laufzeit ehrlich (kein Parameter-Raum).

---

## 8. Compiler-SYSTEMACHSE (USER-Punkt 4) — Live-Bestand: EXISTIERT NICHT ALS ACHSE

- Tier-Binary-Kompilierung: `builder/build_orchestrator/build_orchestrator.hpp:463-467` — `make_gpp_compile_fn(include_dirs, defines, std::string cxx = "g++-16")`; fester Flag-Satz `-std=c++23 -O2 -fPIC -shared` `:470-480`.
- Einzige Compiler-Wahl heute: globale Env-Variable, EIN Compiler für ALLE Permutationen eines Laufs: `profile_facade/profile_run_facade.cpp:95-98` (`COMDARE_CXX`, Default `g++-16`) → einziger Aufruf `:150`.
- KEIN XML-Element wählt den Compiler; keine per-Permutation-Compiler-Dimension; `binary_id` (19 Slots) enthält keinen Compiler.
- Nicht verwechseln: `topics/axis_base.hpp:58-70` `AxisBase::get_compiler()` = Paper-Provenance-Metadatum je Organ („original"/„gcc-9.5" …, Habich-Compliance), KEINE Build-Compiler-Steuerung.
- CEB selbst wird vom äußeren CMake-Toolchain gebaut; gcc-ODER-clang-Wahl für den CEB per XML existiert nicht (kein Treffer für XML-gesteuerte Compiler-Auswahl in libs/ oder experiment_config/).

**Delta:** Die verlangte NEUE Compiler-Systemachse (XML wählt gcc/clang für CEB UND je Tier-Binary-Permutation) hat im Live-Bestand nur den Andockpunkt `cxx`-Parameter von `make_gpp_compile_fn` + `cxx_compiler()`-Hook — beides heute global, nicht achsen-förmig, nicht `binary_id`-relevant.

---

## 9. Flankierende Live-Anker (Voll-Vergleich / 3 Stufen / dritte Anwendung)

- „alt gegen neu" je Stufe: `profile_facade/sota_catalog.hpp:202` (St2) und `:237` (St3) — SotaModule-Pässe `lebewesen+prt(St2)`/`(St3)` mit eigener `sota_binary_id` (`:73`); 3 offizielle Experiment-XMLs im Super-Repo: `Code/experiment_config/config_a_prt_art_vs_sota.xml`, `config_b_cache_engine_perms.xml`, `config_c_merge_alt_neu.xml` (ls-verifiziert).
- XML-Interpretation heute: `libs/common/serialization/xml_config_parser/` (ThesisProfile) + Adapter `builder/experiment_tree/profile_to_tree.hpp:1-12` — als BIBLIOTHEKS-Fassade (`run_profile_facade`, `profile_run_facade.cpp:102`), NICHT als eigenständige Anwendung. App-Bestand (ce/apps/): adhoc_emitter, anatomy_codegen_tool, catalog_codegen_tool, f15_compare, h2_score_akte_tool, is_original_validator, perm_runner, permutation_codegen_tool — ein „Experiment-Planer mit XML-Interpreter" als DRITTE ANWENDUNG existiert nicht (USER-Punkt 6 = Neubau, Andockpunkte: profile_to_tree + selection_filter_chain + run_profile_facade).

---

## 10. Delta-Matrix — Spalte „Live" (Kondensat)

| Baustein | Live-Klassifikation | einkompiliert in Tier-Binary? | binary_id? | Mess-System (CEB)? | runtime-Unter-Achse |
|---|---|---|---|---|---|
| axis_06 allocator (T06) | GATTUNG | JA (Slot T6) | JA (`allocator=`) | nein | RC `pool_budget_bytes` (store-backed); alloc_hw NUMA/Page = compile-time-Unterachse, profil-gated |
| axis_07 prefetch (T07) | GATTUNG | JA (Slot T7) | JA (`prefetch=`) | nein | RC `prefetch_distance` (nur DistanceEstimator); dyn. Ebene `prefetch.hw_prefetcher` |
| axis_08 concurrency (T08) | GATTUNG | JA (Slot T8) | JA (`concurrency=`) | nein | RC `thread_count` (durchgereicht, wirkungslos in-Prozess, deferred #221); dyn. Ebene `concurrency.thread_count` |
| axis_12 general_hardware (T19) | WEDER-NOCH (DefinitionOnly/build-only) | nein (nur Baum-Fanout, nicht 19-Slot) | NEIN | nein | keine (Build-Konstante; Properties → alloc_hw-Kante) |
| c11_scheduler-Deskriptor | WEDER-NOCH (Interface-Skelett) | nein | nein | nein | keine — 0 Impl, 0 Konsumenten |
| measurement_axis_registry (16) | MESS-SYS | nein (host) | nein | JA (Vorbau; Konsument validate_profile) | keine (statisch/constexpr) |
| i_measurement_source | MESS-SYS | nein (host, bewusst nicht über DLL-Grenze) | nein | JA (Vorbau; nur Test-Konsument) | keine (nur valid/caps-Degradation) |
| SystemAxis-Wurzel + 3 Achsen | MESS-SYS | nein (host, „Blut") | nein | JA | keine |
| curve_fit (E4') | MESS-SYS (Auswertung) | nein | nein | JA (Skeleton, #156-gated) | keine |
| selection_filter_chain (S4) | MESS-SYS (CEB-Generierungs-Filter) | nein | joint über binary_id | JA (Slice 1: nur ResumeFilter) | keine |

**Kern-Deltas zum USER-KONZEPT (für Strang-Zusammenführung):**
1. Pflicht-Systemachsen Scheduling (c11: Skelett), Hardware (axis_12: DefinitionOnly-Konstante), NUMA (nur AA5-Tag + alloc_hw-Kante + HW3-Doku-Tag), Locking (nur Organ-Ebene CC1) — KEINE davon existiert als eigenständige, gemessene SYSTEM-Hauptachse neben den 16 Mess-Kategorien. Konsistent mit USER-Verdikt „das Konzept ist Pflicht und kaputt".
2. Compiler-Systemachse: nur Env-Knopf `COMDARE_CXX` (global) + `cxx`-Parameter — nicht XML-getrieben, nicht per Permutation, nicht im CEB-Eigenbau.
3. Mess-System-Achsen sind sauber getrennt und host-seitig (Blut-Direktive belegt), aber die Phase-6-Vorbauten (Registry→E4-Reporting, IMeasurementSource→Prüf-Dock, curve_fit→Schätzer) sind unverdrahtet (Konsumenten = Folge-Increment/Tests).
4. Der CEB-Stufen-Filter des Experiment-Baums existiert als CoR-Slice-1 (nur ResumeFilter); Paper-/Pareto-Glieder deferred.
5. Experiment-Planer/XML-Interpreter als dritte Anwendung: nicht vorhanden; heute Bibliotheks-Fassade (profile_facade) hinter perm_runner-artigen Konsumenten.
