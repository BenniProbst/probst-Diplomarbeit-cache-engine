# DOSSIER — Phase 0.3: Allocator-Adapter (Hebel B), BST-first Slice

> Doc 21 §F Phase 0 (3). Ziel: die Allocator-Achse (axis_06) echt auf die Pool-Organe wirken lassen, sodass
> T6 die **gewählte** Allocator-Strategie reflektiert (messbare Differenzierung = Thesis-Ziel) statt der
> allocator-unabhängigen Store-eigenen Kapazitäts-Zählung. Rahmung: punktuelle Refactorings, CI grün+messfähig,
> ce `8175c802`. Selbst-Implementierung. Ist-Verifikation: boundary-sauber (KEIN mp_list-Templatizing).

## 0. HARTE VERBOTE / GRENZEN
golden/permutation_axes.xml/POD(sizeof==1416)/GenusBindingTraits/ABI-MAJOR==4/Registry-mp_list/modules/ext/thesis
TABU; ue/ae/oe; kein Python; kein Runtime-Switch/vtable im Hot-Path (compile-time-strikt). **Registry-mp_list
NICHT anfassen** — Ist-Verifikation bestätigt: die Pool-Organe sind KEINE mp_list-Blätter (die Blätter sind
SearchAlgo-/Entry-Wrapper), sondern via `organ_for_search_algo`-Trait + Alias erreicht → Änderung =
Instanziierung/Store-Body, kein Registry-Templatizing.

## 1. IST (verifiziert)
- **Adapter (axis_06):** `AllocatorStrategyBase<Derived,CacheLineCfg>::StdAllocatorAdapter<T>` (`axis_06_allocator_strategy_base.hpp:122-143`,
  **stateful**, hält `Derived*`, NICHT default-konstruierbar) + Fabrik `as_std_allocator<T>()` (`:169-172`);
  `statistics()` liefert `AllocationStatistics` (`:104`).
- **Blaupause (Präzedenz):** `axis_04 ComposedStore<N,L,A>` (`axis_04_node_type_composed_store.hpp`): hält
  `A allocator_` als Member VOR den Vektoren (`:129-130`), `slot_alloc = A::StdAllocatorAdapter<slot_t>` (`:57`),
  konstruiert `slots_(allocator_.as_std_allocator<slot_t>())` (`:133`), Copy/Move gelöscht (Adapter hält &allocator_).
- **T6-Route (bereits antizipiert!):** `abi_adapter.hpp:285-299,1149-1160` liest `store_allocator_statistics()` und
  hat einen **bevorzugten Zweig** für die Strategie-Snapshot-Felder `total_bytes_allocated / total_bytes_in_use /
  allocation_count / deallocation_count / failure_count` → r[0..4]. D. h. der End-Zustand „Store liefert die
  Strategie-Statistik" ist im ABI-Adapter schon vorgesehen (5-Feld-Allocator-Signal = messbare Differenzierung).
- **BST-Pool-Store IST:** `tree_node_pool_store.hpp` — `A = std::allocator<Node>` (`:40`), zwei Vektoren via
  `allocator_traits<A>::rebind_alloc` (`:128-129,146-147`), **store-eigene** `record_capacity_growth_`-Zählung
  (`:134-139`) → `store_allocator_statistics()` liefert `{alloc_calls, bytes_allocated, live_nodes}` (`:73-79`).
  Diese Zählung ist **allocator-unabhängig** (Vektor-Kapazitäts-Delta) → JEDER Allocator ergibt dasselbe T6 = die Lücke.
- **Default-Strategie (verhaltens-neutral):** `Exgen` (`axis_06_allocator_exgen.hpp`) — `name()="exgen(real=std)"`
  bei disabled → std-Fallback, immer funktional, single-thread. Sauberster verhaltens-neutraler Default.
- **Konsument:** `ComposedTreeSearch<Traversal,Pool>` (`composed_tree_search.hpp:58-62`) forwarded
  `pool_.store_allocator_statistics()`; Alias `BstTreeOrgan = ComposedTreeSearch<BSTTraversalOrgan, TreeNodePoolStore<>>`
  (`tier_to_organ_mapping.hpp:46`, Default-Param → heute std::allocator).

## 2. FIX (dieser Slice — nur BST/TreeNodePoolStore, Pattern-Beweis)
Harmonisierung des BST-Pool-Stores auf das **axis_04-ComposedStore-Muster**:
1. Param `class A = std::allocator<Node>` → `class Alloc = Exgen` (axis_06-Strategie), `requires AllocatorStrategy<Alloc>`.
   Include `axis_06_allocator_exgen.hpp` + concept.
2. `Alloc allocator_{}` als **erstes** Daten-Member (vor `nodes_`/`free_`), Copy/Move gelöscht (Adapter hält &allocator_).
3. `using node_alloc = typename Alloc::template StdAllocatorAdapter<Node>;` (analog free_), Vektoren via
   `allocator_.as_std_allocator<Node>()` / `<std::size_t>()` konstruiert.
4. `allocator_type` = die Strategie `Alloc` (wie axis_04 `:64`); `store_allocator_statistics()` liefert
   `allocator_.statistics()` (`AllocationStatistics`, 5 Felder) → T6 nimmt den reichen abi_adapter-Zweig.
   Die store-eigene `record_capacity_growth_`-Zählung entfällt (die Strategie zählt die echten Allokationen).
5. `static_assert(TreeNodePool<TreeNodePoolStore<>>)` bleibt gültig.

## 3. CONTRACT-UPDATE (bewusst, s7_1)
`test_s7_1_bst_pool_allocator_deg.cpp`: (a) `:41` `allocator_type == std::allocator<node_type>` → `== Exgen`
(bzw. gemäß neuem Vertrag); (b) `:88-89` `stats.alloc_calls/bytes_allocated` → `stats.allocation_count/
total_bytes_allocated` (AllocationStatistics-Felder); (c) `:112-114` T6 `axis_stats[6][0..2] > 0` bleibt (jetzt
strategie-getrieben). Messsemantik erhalten (> 0), nur Quelle + Feldnamen ändern sich (dokumentiert).

**Scope-Grenze (mehrschichtig — wichtige Präzisierung):** Phase 0.3 ist KEIN Einzel-Refactoring, sondern
zwei Schichten:
- **0.3a (Store-Enabling, dieser Slice):** Pool-Store konsumiert eine axis_06-Strategie (Default exgen), T6
  reflektiert die Strategie (rich 5-Feld-Snapshot). Ändert die T6-QUELLE, noch KEINE Cross-Allocator-
  Differenzierung (der Default ist fix exgen). BST zuerst; die übrigen 9 Stores = gleiche Folge-Slices.
- **0.3b (Composition-Threading, Folge-Slice):** `organ_for_search_algo<S>` → `<S,Alloc>` + Anatomie reicht
  `Composition::allocator` (permutierter axis_06-Slot) in den Pool-Store → ERST DANN Differenzierung (die
  eigentliche Utilization-Schließung). Nahe der ABI-/Anatomie-Grenze → eigener Increment mit voller Sorgfalt.
Verifiziert (organ_for_search_algo.hpp:62-116): heute wird der Allocator NICHT durchgereicht (`TreeNodePoolStore<>`
= Default). 4 Shapes erben den Seam automatisch; Eytzinger/Masstree tragen keinen Seam (Folge).

## 3b. BEFUND (Implementierungs-Versuch 0.3a, 2026-07-11) — COW-Wand: naives axis_04-Muster INVALID
Der Implementierungs-Versuch (Store besitzt die axis_06-Strategie, Vektoren via self-referential Adapter,
Copy/Move gelöscht — exakt das axis_04-ComposedStore-Muster) **bricht den Bau** an
`abi_adapter.hpp:2176`: `saved_container_algorithm_.emplace(container_algorithm_)` **kopiert** das Such-Organ
(inkl. Pool-Store) für die **Zwei-Phasen-Op-Messung** (COW `save→op-warmup→rollback→op-measure`,
`cow_materialize_copy_()`). Zwei harte Konsequenzen:
1. **Gelöschte Copy/Move** (axis_04-Muster) → das COW-`emplace(container_algorithm_)` ist nicht mehr
   konstruierbar → Bau bricht. axis_04 ComposedStore darf Copy/Move löschen, weil es das **Node-Organ** ist
   (nicht COW-kopiert); der **Pool-Store im Such-Organ IST COW-kopiert** → das Muster ist hier nicht anwendbar.
2. **Naiver rebindender Copy-Ctor** wäre auch falsch: das Konstruieren der Kopie **allokiert erneut** über die
   (mitkopierte) Strategie → **Stats-Verfälschung/Doppelzählung** bei jeder COW-Save/Rollback → T6 korrumpiert.
**Erkenntnis:** Ein Store, der die Allocator-Strategie **selbst besitzt**, ist inkompatibel mit dem
COW-kopierten Such-Organ. Der saubere Weg ist **Tier-Level-Strategie-Besitz**: die Anatomie besitzt EINE
axis_06-Strategie-Instanz, die in die Pool-Store-Vektoren gefädelt wird (Adapter zeigt auf die EXTERNE
Strategie); COW-Kopien des Such-Organs teilen dann die externe Strategie (Stats akkumulieren korrekt auf
Tier-Ebene, kein Doppelzählen). Das ist ein **mehrschichtiger Umbau** (Anatomie besitzt Strategie → Ctor-
Threading durch ComposedTreeSearch → Pool-Store) **nahe der Mess-Maschinerie** = **NEUE echte Architektur-
Entscheidung (Ledger §0: anhalten)**, kein punktuelles Refactoring. Berührt das Zwei-Phasen-Mess-Protokoll
(Thesis-Kern) → GO-pflichtig. Der 0.3a-Versuch wurde vollständig revertiert (sauberer Zustand, ce clean).

## 3c. AUFLOESUNG (2026-07-11) — Option A (Memento) implementiert, COW-safe
Deep-Research-Workflow wf_ced9827f (2 Research + Design + 2 adversariale Kritiker) → **Option A**: store-besitzende
axis_06-Strategie (Default ExgenAllocator) + **copy-konstruierbarer/assignable** Store (cow_capable_-Pflicht, weil
cow_materialize_copy_ unbedingt kopiert); Copy-Ctor/Assign rebinden den StdAllocatorAdapter an das eigene
allocator_ und verwerfen die COW-Kopier-Pollution per **Memento** `allocator_.restore_statistics(o.statistics())`
(unter `#ifdef COMDARE_CE_ENABLE_STATISTICS`). Move nicht deklariert → degradiert sicher zu Copy. abi_adapter/
Anatomie/golden UNBERUEHRT (nur eine Populations-Zeile in tier_get_allocator: `live_nodes` aus `occupied_count()`,
da live_nodes eine Container-Eigenschaft ist, kein Alloc-Stat — kein POD/ABI/golden-Touch). `restore_statistics`
additiv auf CRTP-Base + ExgenAllocator (opt-in, kein Concept-Zwang). Kritiker-Fixes alle adressiert:
- BLOCKER (stats-OFF-Bau): restore_statistics-Aufrufe unter `#ifdef` → **stats-OFF-Compile verifiziert EXIT=0**.
- MAJOR (Zwei-Phasen-Test fehlt): **NEUER** `TwoPhaseCowT6IsPollutionFree` faehrt save→warmup→rollback→measure ein-
  vs. zwei-phasig, fordert **counter-clean (2-phasig ≤ 1-phasig)** — beweist die Neutralisierung (1-phasig 8160 vs
  2-phasig 4064). Der 0.3a-Bug haette hier s2>s1 erzeugt.
- MAJOR (golden-Verifikation): **golden-320-Roundtrip ALLE OK (Diff leer)**, golden-Datei git-unveraendert.
  binary_id = Achsen-`::name()` (nicht mangled type) → interner Alloc-Param aendert keine ID (`allocator=std_malloc`).
- MINOR: exakter Belegungs-Invariant via `occupied_count()==keys.size()`; Downstream-Regression `test_ap15_2`
  (live_nodes) mit dem occupied_count-Fix behoben.
Zusatz-Erkenntnis: `total_bytes_allocated > total_bytes_in_use` (vector-Wachstum dealloziert alte Puffer) = echte
Allocator-Semantik (die alte allocator-unabhaengige Zaehlung hatte allocated==in_use). Verifiziert: voller ctest
**202/202** gruen, clang-format-22 konform, Mojibake 0. **Scope 0.3a-BST**: nur TreeNodePoolStore; 0.3b (Composition-
Threading permutierter axis_06 → Store-Alloc, Cross-Allocator-Differenzierung) = Folge-Slice; die uebrigen 9 Stores
gleiche Folge-Slices (restore_statistics je erreichte Familie).

## 4. DoD (doppelt-literal, g++-16)
Voller ctest 100% (inkl. s7_1 neu); clang-format-22==0; Mojibake==0; git status NUR die berührten Dateien;
golden/POD/ABI byte-unberührt (kein Registry/POD/GenusBindingTraits-Touch — git-diff-Beleg); Verhaltens-Nachweis:
T6 reflektiert jetzt die Strategie (exgen-Snapshot > 0, 5 Felder). Danach adversarialer Review-Workflow (Finder→
2-Lens-Verifier) + Rohdaten-Backup, Fixes, granulare Commits ce beide Remotes (development→main ff), CI strikt grün.
**ce-Submodule im super NICHT bumpen** (CI-Job-Token-Limitierung, s. Memory).
