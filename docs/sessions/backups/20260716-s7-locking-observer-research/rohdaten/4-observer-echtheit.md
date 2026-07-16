# STRANG 4 — Observer-Echtheits-Audit ALLER Gattungen (Rohdaten, 2026-07-16)

> **Auftrag S-7 (wörtlich):** „Alle Gattungen sollen ihre wichtigen Observer-Messwerte echt ermitteln."
> Audit je Gattung: Liste wichtiger Messwerte ↔ Status {echt | honest-0-berechtigt | PHANTOM-Risiko | fehlt}.
> Quellen: ce `anatomy/*_tier.hpp`, `*_abi_adapter.hpp`, `builder/pruef_dock/*`, `virus/graph_bfs.hpp`,
> `axes/concurrency_axis/*`, goal-v6-luecken-ledger (historisch), Ledger §11-H.
> READ-ONLY-Audit; code-verifiziert (keine Vermutungen). Alle Zeilennummern-Angaben gegen den IST-Stand
> `Code/external/comdare-cache-engine/libs/cache_engine/` (development, 2026-07-16).

---

## §0 Kernbefund (Einordnung vor den Tabellen)

**Zwei orthogonale Echtheits-Achsen, die nicht verwechselt werden dürfen:**

1. **Observer-Echtheit auf CODE-/UNIT-Ebene** — werden die Zähler in der REALEN Operation inkrementiert
   (kein Stub, kein `return 0`)? → für ALLE vier Gattungen (SearchAlgorithm, Container-Sub-Genera,
   Virus/Graph) ist die Antwort **JA, echt**.
2. **Observer-Echtheit im MESS-PFAD (golden-320-Pipeline)** — zieht die eigentliche Experiment-Maschinerie
   (Prüf-Dock-Registry → experiment_golden.xml) den Snapshot der Gattung? → **NUR für SearchAlgorithm.**
   Container + Virus/Graph sind pipeline-seitig **V42-/bewusst-deferred** (Docks existieren, sind aber
   NICHT registriert; keine CSV-Spalten, keine Population).

**⟹ Es gibt kein PHANTOM (kein erfundener/falscher Wert) in irgendeiner Gattung.** Die einzige echte,
klar benennbare *Substanz-Lücke* ist die vom Auftrag genannte: **Sub-Achse 8.2 `LockingMode::Upgradeable`
ohne Organ** in axis_08 (SearchAlgorithm-Gattung, T8) — siehe §1, Zeile T8.

**Wichtiger IST-Update gegenüber Dossier 20260628 (§5/B2-1 „paralleler Apparat"):** Das frühere
Doppel-Speicher-Problem (`search_organ_` echtes Baum-Organ ⇄ `container_`-Spiegel) ist **AUFGELÖST**.
`grep search_organ_ abi_adapter.hpp` = **0 Treffer** — das Member ist ENTFERNT (#188-4c-iii, 2026-07-02).
Es gibt jetzt **EINEN** konstitutiven Store `container_algorithm_` (`LayoutAwareChunkedStore`), den
`tier_insert/lookup/erase` treiben UND über den ALLE Achsen-Observer messen. Damit misst kein Achsen-Observer
mehr einen Neben-Apparat — die Meta-Lehre-#3-Grenze (Austauschbarkeits-Beleg = verschiedene Organ-Pfade) ist
für die SearchAlgorithm-Gattung code-seitig erfüllt (Wirksamkeit in den Daten erst nach 320-DLL-Neubau #215).

---

## §1 Gattung SearchAlgorithm — `axis_stats[19][8]` (kV3AxisSchema)

- **POD:** `ComdareTierObserverSnapshot` (`anatomy/observable_tier.hpp:130`, `sizeof==1416`, ABI-Major-versioniert).
- **Schreiber:** `abi_adapter.hpp::fill_observer_v3` (:1142–1446), STATISTICS-gegated, Q1-Sequenz READ→Timing→Reset.
- **Mess-Pfad-Anbindung:** `builder/pruef_dock/search_algorithm_dock.hpp` (`dock_genus()==SearchAlgorithm`,
  `dynamic_cast<IObservableTier*>` + `drive_tier_observe_trace_abi`). **DIES ist die EINE pipeline-verdrahtete
  Gattung** (golden-320-Population: `experiment_golden.xml` Achse `search_algo` k_ary/eytzinger).

| Achse (T) | Wichtige Messwerte | Quelle im Code | Status |
|---|---|---|---|
| **T0 search_algo** | lookup, hit, miss, insert, erase, peak | `container_algorithm_.statistics()` (:1156) | **echt** (der EINE getriebene Store, #188-4c) |
| **T1 cache_traversal** | resolve/hit/miss, register/unregister, peak_tracked, batch_size, batch_visited | `ct_organ_.statistics()` auto-gekoppelt (:1168) | **echt** (r[6]/r[7] = effektiv gefahrene Fenster-Form, ehrlich) |
| **T2 mapping** | register, resolve/hit/miss, reverse_lookup, peak_mapped, indirect_steps | `map_organ_.statistics()` (:1185) | **echt** |
| **T3 path_compression** | compress, prefix_len, bytes_saved, cuts, checksum | `pc_organ_.statistics()` je Tier-Op (:1347) | **echt** (None → ehrlich niedrig, kein Sonderfall) |
| **T4 node_type** | find, keys_stored, queries, checksum | `store_observe_node_type` über `container_algorithm_` (:1201) | **echt** (Zustand-Scan über realen Store) |
| **T5 memory_layout** | scan, records, field_bytes, cache_lines, checksum | `store_observe_layout` (:1214) | **echt** |
| **T6 allocator** | bytes_alloc, bytes_in_use, alloc/dealloc_cnt, fail, budget_reject | `store_allocator_statistics()` (:1229) | **echt wo Route vorhanden**; **honest-0-berechtigt** für Familien ohne `store_allocator_statistics()` (S7-1: nicht mehr an store_type gekoppelt) |
| **T7 prefetch** | trigger, …, real_prefetches_issued, last_distance, last_address | `pf_organ_.statistics()`, realer `_mm_prefetch` (:1265) | **echt** (K9-Fix); None=0-Baseline; r[1..4] Tracker-Felder jetzt **honest-0** (PathOriented nicht mehr enqueue-getrieben) |
| **T8 concurrency** | acquire, release, contention, validation_fail, pattern_id | `cc_organ_.statistics()` via `observe_critical_section` (:1281) | **echt** für die **9 Strategie-Organe**; contention/validation_fail = **honest-0-berechtigt** (single-thread Pfad B, bewusst kein nebenläufiger Treiber). ⚠️ **SIEHE §1.1 — Sub-Achse 8.2 Upgradeable = PHANTOM-Risiko/fehlt** |
| **T9 serialization** | serialize, records, bytes, checksum | `store_observe_serialization` (:1294) | **echt** |
| **T10 telemetry** | events, leaf_updates, node_updates, peak_tracked | `telemetry_organ_.statistics()` auto-gekoppelt (:1305) | **echt** |
| **T11 value_handle** | access, indirect_deref, version_strips, peak_chain_depth | `store_observe_value_handle` über reale Slots (:1319) | **echt** |
| **T12 isa** | simd_calls, elements, simd_iters, scalar_fallback, checksum | `store_observe_isa` über reale Slot-Bytes (:1333) | **echt** |
| **T13 index_org** | scan, records, predicate_evals, indirect_lookups, checksum | `store_observe_index_org` (:1362) | **echt** (predicate_evals/indirect_lookups folgen statischen Strategie-Props is_clustered/has_secondary_indexes) |
| **T14 io_dispatch** | rounds, bytes, align_adjusts, dispatch_cnt, checksum | `store_observe_io_dispatch` (:1378) | **echt** als IN-MEMORY-Dispatch; align_adjusts = **honest-0-berechtigt** für InMemoryOnly (kein Disk-IO, Hauptagent-Entscheid) |
| **T15 migration_policy** | decisions, migrations, hot/cold_votes, tier_moves | `store_observe_migration` (:1394) | **echt** (decide-scan); tier_moves + migrations/hot/cold = **honest-0-berechtigt** für NoMigration/single-tier (kein 2. Tier `container_algorithm_tier1_`) |
| **T16 filter** | probe, pos, neg, hash_probes, checksum | `store_observe_filter` über reale low-Bytes der Keys (:1410) | **echt** (realer In-Memory-Filter) |
| **T17 queuing_q1** | put, get, overflow, underflow, peak_size | `queuing_q1_organ_.statistics()` auto-gekoppelt (:1422) | **echt** |
| **T18 queuing_q2** | decisions, full_flush, partial_flush, no_flush, flush_complete | `queuing_q2_organ_.statistics()` via should_flush/on_flush_complete (:1433) | **echt** (das „flush" der Frage sitzt HIER, nicht im Container) |
| Meta | observable_axis_count, tier_fill_level, filled_axis_count | :1443–1445 | **echt** |

**Verdikt SearchAlgorithm:** Alle 19 Achsen sind **echt getrieben ODER honest-0-berechtigt**; **keine** Achse
ist „strukturell nie getrieben" (alle 19 Slots existieren in jeder `AdHocComposition<T0..T18>` und werden im
STATISTICS-Build befüllt). honest-0 tritt genuin auf (Baseline-/None-Strategien, single-thread, InMemoryOnly).

### §1.1 Die EINE echte Substanz-Lücke — T8 Sub-Achse 8.2 `Upgradeable`-Locking ohne Organ

- **9 vorhandene Concurrency-Organe** (`axes/concurrency_axis/axis_08_concurrency_*.hpp`): none, blocking,
  reader_writer, olc, olc_reserved_blocks, rcu, hazard_pointer, lock_free, wait_free.
- **Sub-Achse 8.2 `LockingMode`** (`include/cache_engine/concepts/locking_mode.hpp:20-25`) deklariert ein
  **Enum + Concept `ILockingMode`** mit vier Modi: `ReadOnly`, `ReadWrite`, **`Upgradeable`** (Kommentar
  „boost::shared_mutex upgrade"), `OptimisticValidation`.
- **Befund (bestätigt `ls | grep -i upgrade` = KEIN Treffer):** Für `Upgradeable` existiert **kein eigenes
  Organ** unter den 9 Strategien; der Observer `ConcurrencyStatistics`
  (`axis_08_concurrency_observable.hpp:37`) trägt **kein locking-mode-distinktes Feld** — er misst
  acquire/release/contention auf **Strategie**-Ebene, nicht auf `ReadOnly/ReadWrite/Upgradeable`-Ebene.
- **Status: PHANTOM-Risiko / fehlt.** Das distinkte Verhalten des Upgradeable-Locks (Reader→Writer-Upgrade)
  wird derzeit von **keinem** getriebenen Organ erzeugt und von **keinem** Observer-Feld gemessen. Ein Lebewesen
  mit `LockingMode::Upgradeable` durchliefe denselben Organ-Pfad wie eine benachbarte Strategie → Meta-Lehre-#3-
  Verletzung (Apparat-Artefakt) genau an dieser Sub-Achse.
- **⟹ Exakt der S-7-Deep-Research-Gegenstand** (Delta-Matrix Dossier 23): Forschungs-Paper + Organ-Code +
  Observer-Feld für die Upgradeable-Locking-Achse fehlen und sind mit Vendoring-Doktrin (vendor→faithful→
  self-contained) zu ergänzen, damit die Achse in der SearchAlgorithm-Gattung (T8) echt getrieben + gemessen wird.

---

## §2 Gattung Container — Set / Sequence / View / Adapter (je genus-eigener V1-POD)

**Es gibt KEINEN einzelnen `ContainerObserverSnapshotV1`.** Die Container-Messung ist **pro Tier-Unterklasse**
realisiert (je eigener flacher, ABI-stabiler POD + eigenes Sub-Interface + je 1 Dock). Das ist die vom
Ledger §11-H gemeinte „Property in genus-eigener Form da".

**Code-Echtheit je Sub-Genus (Zähler in der REALEN Operation inkrementiert):**

| Sub-Genus | POD / Interface | Wichtige Messwerte | Reale Treiber-Stelle | Status (Code-Ebene) |
|---|---|---|---|---|
| **Set** (Vogel, K-only) | `SetObserverSnapshotV1` (`set_tier.hpp:17`), `ISetTier` | insert_count, contains_count, hit/miss, erase_count, current/peak_size | `SetAnatomy::insert/contains/erase` (`set_anatomy.hpp:44-71`) → `++obs_.*` | **echt** |
| **Sequence** (Reptil, V-indexed) | `SequenceObserverSnapshotV1` (`sequence_tier.hpp:12`) | push_count, at_count, at_oob, current/peak, **growth_events** | `SequenceAnatomy::push_back/at` treibt axis_growth-Policy real (`sequence_anatomy.hpp:42-60`) | **echt** (growth_events aus `growth_.next_capacity`) |
| **View** (Pflanze, non-owning) | `ViewObserverSnapshotV1` (`view_tier.hpp:12`) | read_count, read_oob, bound_size, bind_count | `ViewAnatomy::read` über axis_layout/accessor (`view_anatomy.hpp:45-53`) | **echt** |
| **Adapter** (Invertebrat, queue/stack) | `AdapterObserverSnapshotV1` (`adapter_tier.hpp:26`), `IAdapterTier` | **push/put**_count, pop_count, front/back_reads, current/peak_occupancy | `AdapterAnatomy::push/pop_front/pop_back` treibt inner_container real (`adapter_anatomy.hpp:180-205`) | **echt** (`put`=`push`-Alias; **„flush" existiert im Container NICHT** — flush ist T18/SearchAlgorithm) |

**ABI-Adapter ziehen die Werte echt durch:** `set_abi_adapter.hpp:66 tier_observe_set` ruft
`anatomy_.observe_all()` → V1-POD (analog sequence/view/adapter). `observable_axis_count` wird **ehrlich = 1**
gesetzt (R5.B: real getrieben ist nur das search_algo-Kern-Organ; die restlichen 14/11/7/13 Achsen tragen die
Komposition-**Identität**, nicht reale Werte — ehrlich ausgewiesen, kein Phantom).

**ABER — Mess-Pfad-Status = V42-/bewusst-deferred (der Kern der §11-H-Frage „Ist heute?"):**

- **Container-Docks sind NICHT registriert.** `builder/pruef_dock/pruef_dock_registry.hpp:4-5` wörtlich:
  „Hält genau EIN Prüf-Dock pro implementierter Gattung (**initial nur SearchAlgorithmDock**; Set/Sequence/
  Adapter/View **kommen mit V42**)."
- **`tier_observe_set/sequence/view/adapter` haben NULL Pipeline-Call-Sites.** `grep` über `libs/` (ohne
  build/tests): die Methoden sind nur in den Tier-Headern **definiert**; aufgerufen werden sie
  **ausschließlich in Unit-Tests** (`test_container_dock.cpp`, `test_genus_docks.cpp`, `test_d10_sequence.cpp`,
  `test_d11_view.cpp`, `test_d4b_container_adapter.cpp`, `genus_module_sequence.cpp`, `genus_module_view.cpp`).
- **Kein Builder-Code referenziert** `SetAbiAdapter/SequenceAbiAdapter/ViewAbiAdapter/AdapterAbiAdapter`
  (`grep libs/cache_engine/builder/` = 0).
- **golden-320-Population** (`experiment_golden.xml`) trägt **keine** Container-Tiere (nur `search_algo`).
- **Historik goal-v6-luecken-ledger:** Gattungs-Bindung IST 2/5 — `GenusBound<SearchAlgorithm>==true`,
  `GenusBound<Adapter>==true`, **Set/Sequence/View==false**; Vervollständigung = Task **L-75**
  („Container-Gattung vervollständigen: q2-Slot + DLL-Pfad", Aufwand M).
- **Ledger §11-H (2026-07-11, Deep-Research wf_d15b529f):** „Container-Genera-Messung (Property in
  genus-eigener Form da, **V42-deferred**)" — als **adversarial widerlegter Phantom-Gap** eingestuft (= NICHT
  bauen, weil die Property in genus-eigener Form bereits da ist; die volle Pipeline-Integration ist bewusst
  deferred, nicht vergessen).

**Status je Messwert (Container):** auf Code-/Unit-Ebene **echt** (reale Zähler, memcpy-fähige V1-PODs, Docks
funktionsfähig, in Tests getrieben) — im MESS-Pfad **inaktiv/V42-deferred, aber PHANTOM-frei** (keine erfundenen
Werte, keine CSV-Spalten, keine Schein-Grün-Zeile). **Kein honest-0-Problem, kein „fehlt"** im Sinne fehlender
Substanz; die Substanz existiert und ist ehrlich abgeklemmt. Ein PHANTOM-Risiko entstünde erst, falls die
Container-Docks in die golden-Pipeline verdrahtet würden, OHNE dass die 14/11/7/12 delegierten Achsen (analog
#188 für SearchAlgorithm) echte Organ-Pfade bekommen — dann würde `observable_axis_count=1` zur ehrlichen
Warnung, dass 13 von 14 Set-Achsen nur Identität, nicht Messung tragen.

---

## §3 Gattung Virus / Graph

- **POD:** `VirusMeasurementSnapshotV1` (`execution_engine/virus_execution_engine.hpp:19`): run_count,
  visited_nodes, edges_traversed, result_checksum. `IVirusExecutionEngine::virus_observe`.
- **Einzige produktive Engine:** `GraphBfs` (`virus/graph_bfs.hpp`) — **ECHTE** Breitensuche über
  CSR-Adjacency (`run_bfs`, :27-57): `++snap_.run_count`, `visited_nodes`, `edges_traversed`,
  `result_checksum` (u-Summe als Anti-DCE-Korrektheits-Anker) werden real gesetzt. `virus_observe` (:76)
  zieht den Snapshot. **Kein Stub** (Header-Kommentar :4 „echte BFS, kein Stub"; `grep IVirusExecutionEngine`
  = nur GraphBfs als Impl).

| Messwert | Status |
|---|---|
| run_count, visited_nodes, edges_traversed, result_checksum | **echt** (in `run_bfs` gesetzt) |

**ABER — Gattungs-Status = bewusst-deferred Stub:** Die Graph-Gattung ist der „Schwester-Zweig zu den
Anatomie-Gattungen (**kein Achsen-System**)" (graph_bfs.hpp:2-3). Es existiert **keine** Graph-Anatomie /
-Composition / -Tier-Unterklasse / -Dock / -Registry und **keine** Population im Experiment. Ledger §11-H:
„Graph-Gattung (**bewusst-deferred Interface-Stub**)". ⟹ Die EINE Virus-Engine hat einen echten Observer;
die Graph-Gattung als **Experiment-Teilnehmer** ist deferred. **Kein PHANTOM** (reale BFS + Checksum), nur
bewusst reduzierter Scope.

---

## §4 Zusammenfassung Status-Matrix

| Gattung | Observer-Substanz (Code) | Mess-Pfad (golden-320) | echte Lücke? |
|---|---|---|---|
| **SearchAlgorithm** (19 Achsen) | **echt** (18 getrieben/scan + honest-0 wo genuin) | **AKTIV** (einzige verdrahtete Gattung) | **JA — T8.2 Upgradeable-Locking ohne Organ** (PHANTOM-Risiko/fehlt) |
| **Container/Set** | echt (insert/contains/hit/miss/erase) | V42-deferred (Dock nicht registriert) | nein (deferred, PHANTOM-frei) |
| **Container/Sequence** | echt (push/at/growth_events) | V42-deferred | nein |
| **Container/View** | echt (read/read_oob/bind) | V42-deferred | nein |
| **Container/Adapter** | echt (put=push/pop/front/back) | V42-deferred (GenusBound=true, aber Dock nicht in Registry) | nein |
| **Virus/Graph** | echt (BFS: visited/edges/checksum) | bewusst-deferred (kein Achsen-System, keine Population) | nein |

**honest-0-berechtigt-Positionen (SearchAlgorithm, genuin 0 — kein Fehler):** T6 allocator (Familien ohne
`store_allocator_statistics`), T7 prefetch r[1..4] (Tracker), T8 contention/validation_fail (single-thread),
T14 alignment_adjusts (InMemoryOnly), T15 tier_moves/migrations/hot/cold (NoMigration/single-tier).

**Doktrin-Konformität:** honest-100% eingehalten — **keine** erfundenen/falschen Werte in irgendeiner Gattung;
alle Nicht-Werte sind entweder genuin honest-0 oder ehrlich-abgeklemmt-deferred. Die EINZIGE bau-würdige
Substanz-Lücke ist die Upgradeable-Locking-Achse (§1.1) — der S-7-Deep-Research-Auftrag.

---

## §5 Quellen (code-verifiziert, absolute Pfade)

Basis: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/external/comdare-cache-engine/libs/cache_engine/`
- `anatomy/observable_tier.hpp` (kV3AxisSchema :66, ComdareTierObserverSnapshot :130, IObservableTier :173, IMigratableTier :202)
- `anatomy/abi_adapter.hpp` (fill_observer_v3 :1142-1446; `search_organ_` grep=0 ⇒ #188-4c vollzogen; tier_search_routes_through_store :1891 ⇒ true)
- `anatomy/set_tier.hpp` / `set_abi_adapter.hpp` / `set_anatomy.hpp`
- `anatomy/sequence_tier.hpp` / `sequence_anatomy.hpp`
- `anatomy/view_tier.hpp` / `view_anatomy.hpp`
- `anatomy/adapter_tier.hpp` / `adapter_anatomy.hpp`
- `anatomy/search_algorithm_anatomy.hpp` (observe_all :62-106, 9 real gehaltene Organe)
- `axes/concurrency_axis/axis_08_concurrency_observable.hpp` (ConcurrencyStatistics :37) + `axis_08_concurrency_*.hpp` (9 Organe)
- `include/cache_engine/concepts/locking_mode.hpp` (LockingMode-Enum :20-25, Upgradeable=2 ohne Organ)
- `virus/graph_bfs.hpp` + `execution_engine/virus_execution_engine.hpp` (VirusMeasurementSnapshotV1 :19)
- `builder/pruef_dock/pruef_dock_registry.hpp:4-5` („initial nur SearchAlgorithmDock; Set/Sequence/Adapter/View kommen mit V42")
- `docs/sessions/goal-v6-luecken-ledger.md` (GenusBound 2/5; L-75 Container-Gattung)
- `docs/sessions/20260628-KONTEXT-DOSSIER-mess-echtheit-gattungen-observer-pruefdock-A2welle.md` (§5 Weg-A/B; historisch, §5-Bruch durch #188 aufgelöst)

Super-Ledger: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
- §11-H (Z.289-311): Container-Messung „genus-eigener Form da, V42-deferred"; Graph „bewusst-deferred Interface-Stub"; Perzentile „schon da".

Population: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/test_data_xml/experiment_golden.xml` (nur `search_algo` k_ary/eytzinger).
