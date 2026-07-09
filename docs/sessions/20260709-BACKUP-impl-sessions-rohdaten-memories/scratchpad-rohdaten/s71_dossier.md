# DOSSIER S7-1 (#261/#234, erster Einzel-Commit) — BST-Pool: Allokator-Param `A` (defaultiert, byte-identisch) + Allokator-DEG-Hook (honest-0 → echt), ABI-4, golden-neutral

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent. Repo-Wurzel = `--cd` (comdare-cache-engine, HEAD ~24dee528).
> **NICHT committen, KEINE git-Operationen.** Basis = fresh-context-Kartierung (Explore a5bee8f0), alle Zeilen belegt.
> **SCOPE = NUR die fork-freie S7-1-Teilmenge (BST-Familie):** defaultierter `A`-Param + Allokator-Statistik + Hook-Route + Test.
> NICHT in diesem Commit: N/L-Params (L-Semantik-Fork offen), Composition-Threading (organ_for-Trait-Fork offen), andere 8 Familien.

## 1. Auftrag
`TreeNodePoolStore<Shape>` → `TreeNodePoolStore<Shape, A = std::allocator<TreeNode>>` — Default byte-identisch; Node-Vektor + Free-List über `A`; ECHTE Allokator-Statistik im Pool (Zähler: allocations, bytes, node_count) und Route bis in den ABI-Observer (T6-allocator-Felder, die für Pool-Kompositionen heute honest-0 sind) → erster DEG-Zähler 0→>0. Plus dedizierter Observer-Test.

## 2. VERIFIZIERTER Ist-Zustand (Kartierung — nutze GENAU diese Belege)
- **Store:** `libs/cache_engine/axes/lookup/composable/tree_node_pool_store.hpp` — `TreeNodePoolStore<Shape>` (`:23-24`), Backing `std::vector<Node>` + Free-List (`:87-88`), static_assert-Referenz `:94`. Spiegel unter `topics/traversal/axis_03a_search_algo/composable/` (prüfen ob include-identisch oder Kopie — bei Kopie BEIDE konsistent halten; #159 hatte modules-Spiegel-Pflege).
- **Organ-Alias:** `tier_to_organ_mapping.hpp:45` `BstTreeOrgan = ComposedTreeSearch<TreeNodePoolStore<>>` (o.ä.) — MUSS nach dem Default-Param unverändert kompilieren (`TreeNodePoolStore<>` = gleiche Type-Identity wie vorher NICHT nötig — aber gleiche Semantik/Layout; Alias-Schreibweise ggf. anpassen, Namens-Identität wahren).
- **Ernte-Primitive:** `composed_tree_search.hpp:37` `for_each_record` (In-Order, DEG-1) + `observable_composed_container.hpp:104-110`.
- **honest-0-Naht:** `abi_adapter.hpp:1875-1883` — `container_algorithm_is_store_backed_ = requires{ container_algorithm_t::store_type }` == false für Pools → allocator-stats + T4/T5/T6 honest-0 (`:1879`). Der Commit öffnet die Route NUR für allocator (T6): wenn das Pool-Organ eine Allokator-Statistik anbietet (neues schmales `requires { c.store_allocator_statistics() }`-Gate am ObservableComposedContainer/Organ), dann echte Werte in die BESTEHENDEN T6-POD-Felder — POD-Form/Feldzahl UNVERÄNDERT.
- **Muster echte A-Statistik:** `axes/node/axis_04_node_type_layout_aware_store.hpp:73-77` (A-Param) + `:188` (echte A-Statistik) + `:181-195` (Chunks über A).
- **CI-Beleg-Targets:** `tests/unit/test_188_4bbV_pool_adapter_flip_compile.cpp` (treibt alle 9, `:187-195`; exactly-once for_each_record `:162-175`) + `.gitlab-ci.yml:169-181` contract:pool_flip + `test_profile_roundtrip` (golden byte-identisch).

## 3. Soll (der Increment) — Defaults gesetzt, NICHT nachfragen
(a) **`tree_node_pool_store.hpp`:** Template um `class A = std::allocator<node_type>` erweitern (Default = exakt heutiges Verhalten); `std::vector<Node>`-Backing auf `std::vector<Node, typename std::allocator_traits<A>::template rebind_alloc<Node>>` umstellen; **Statistik-Zähler** (uint64: `alloc_calls_`, `bytes_allocated_`, `live_nodes_`) an den Alloc-/Free-List-Pfaden pflegen (Vektor-Wachstum via capacity-Delta zählen — ehrlich, kein Fabrikat); `store_allocator_statistics()`-Accessor (struct mit den 3 Feldern, analog LayoutAware-Muster). Spiegel-Header (topics/…) konsistent halten falls Kopie.
(b) **`observable_composed_container.hpp` (o. Organ-Schicht):** schmale Durchreiche: `requires`-gated `store_allocator_statistics()` (delegiert an den Pool des inneren Organs, falls vorhanden).
(c) **`abi_adapter.hpp` (honest-0-Naht, minimal-invasiv):** an der T6-allocator-Befüllung (`~:1879`-Umfeld): wenn `container_is_authoritative_` UND `requires { container_algorithm_.store_allocator_statistics() }` → echte Zähler in die bestehenden T6-axis_stats-Felder; sonst wie bisher honest-0. KEINE POD-/vtable-Änderung, KEIN neues Interface.
(d) **Test `tests/unit/test_s7_1_bst_pool_allocator_deg.cpp`** (gtest, CMake-Registrierung Muster test_ap9): baue eine BST-Pool-Komposition (wie test_188_4bbV sie treibt), N Inserts, dann: (1) `store_allocator_statistics().alloc_calls > 0` + `live_nodes == N` (exakt), (2) über den ABI-Adapter/tier_observe: T6-allocator-axis_stats > 0 (der DEG-Beweis 0→>0), (3) Default-Byte-Identität: `TreeNodePoolStore<DefaultShape>`-Verhalten unverändert (Insert/Lookup-Roundtrip wie test_188_4bbV-Smoke), (4) NeutralityGuards-Block (wörtlich aus test_ap9_provenance_manifest.cpp:68-84: ABI-4, sizeof 1416, CSV 25/16).

## 4. HARTE Auflagen (Verstoß = Abbruch)
1. **golden/Katalog TABU:** `registry` EnabledStrategies/AllStrategies-Ordnung, `source_catalog.hpp` CatalogAxes, `golden_fullpilot_320_binary_ids.txt`, `gen_golden_fullpilot.cpp` UNBERÜHRT. Kein neuer Katalog-Param.
2. **POD/ABI:** `ComdareTierObserverSnapshot`-Form/Feldzahl/`kTierObserverSnapshotVersionUnified`/`COMDARE_ANATOMY_ABI_MAJOR`(4) unverändert — nur BESTEHENDE T6-Felder befüllen.
3. **Byte-Identität beim Default:** `A`-Default ändert weder Layout noch Verhalten des Backings (std::allocator-rebind == vorher). Andere 8 Familien + Eytzinger/Masstree UNBERÜHRT.
4. **Ehrliche Zähler:** capacity-basiertes Zählen dokumentieren; NIE Werte erfinden; wenn ein Zähler nicht sauber ermittelbar ist → weglassen statt schätzen.
5. Kein `git`. Kein `$null`. `apps/perm_runner/main.cpp` (user-dirty) NICHT anfassen.

## 5. Verifikation (PFLICHT — Codex, literal, über den konfigurierten build/)
- `cmake --build build --target test_188_4bbV_pool_adapter_flip_compile test_188_4a_eytzinger_organ test_s7_1_bst_pool_allocator_deg test_profile_roundtrip --config Debug` + alle 4 ausführen → literal `[ PASSED ]` je Suite; test_profile_roundtrip = golden byte-identisch-Beleg.
- clang-format-Konformität der angefassten Dateien prüfen (Root-.clang-format; lint:format ist jetzt Pflicht-grün): `<scratchpad>/llvm/clang-format.exe --dry-run -Werror <dateien>` = 0 Fehler (Pfad: C:/Users/benja/AppData/Local/Temp/claude/C--WINDOWS-system32/78cf67f8-571e-4fcd-a907-1556dbc5be72/scratchpad/llvm/clang-format.exe).
- `git status --short`: NUR tree_node_pool_store.hpp (+Spiegel falls Kopie) + observable_composed_container.hpp + abi_adapter.hpp + neuer Test + tests/unit/CMakeLists.txt.

## 6. Ausgabe an Claude
(a) Diffs; (b) literal `[ PASSED ]` aller 4 Suiten + der T6-DEG>0-Wert aus dem Test-Output; (c) Bestätigung Default-byte-identisch/golden-roundtrip-grün/POD-unverändert/clang-format-0; (d) Notiz, welche Zähler-Semantik gewählt wurde (capacity-Delta etc.).
