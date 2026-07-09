# DOSSIER #188-4b-DEG-1 — Key-Ernte-Capability `for_each_record` für die 9 Pool-Organ-Familien (cache-engine)

Du bist der IMPLEMENTIERUNGS-Agent. Implementiere GENAU den unten spezifizierten Increment im Arbeitsbaum.
NICHT committen, NICHT pushen, NICHT builden (auf dieser Maschine existiert KEIN C++-Compiler — g++/clang/cl fehlen;
verlasse dich auf sorgfältige statische Prüfung deiner Edits). Am Ende: Liste aller geänderten Dateien + je Familie
1-2 Sätze, WIE der Walk die reale Struktur traversiert + offene Fragen/Risiken.

## 1) Repo / Stand
- Repo-Wurzel = dein Arbeitsverzeichnis (comdare-cache-engine, branch `main`, HEAD `e064c49`, Arbeitsbaum sauber).
- Kanonischer Code: `libs/cache_engine/**`. C++23, header-only Achsen-Bibliothek, Boost.MP11, GTest in `tests/unit`.
- Sprache der Kommentare: DEUTSCH, im Stil der umgebenden Dateien (Banner-Kommentare mit Task-Tags wie `#188-4b-DEG1`).

## 2) Architektur-Kontext (musst du NICHT neu recherchieren — verifizierte Fakten)
- #188-4b-b1b („container_-Flip", Commit cd25b9b): Für die 9 Weg-B-**Pool-Familien** (Composition::search_algo =
  ROHER Wrapper: `BinarySearchTreeSearchAlgo`, `BTreeSearchAlgo`, `SkipListSearchAlgo`, `HashSearchAlgo`,
  `OriginalArtSearchAlgo`, `OriginalHotSearchAlgo`, `OriginalStartSearchAlgo`, `OriginalWormholeSearchAlgo`,
  `OriginalSurfSearchAlgo`) ist im `anatomy/abi_adapter.hpp` das Feld `container_` jetzt
  `ObservableComposedContainer<organ_for_search_algo_t<SearchAlgo>>` (das NATIVE u64-Organ), Prädikate
  `pool_family_` + `container_is_authoritative_`; insert/lookup/erase/T0 routen über `container_`.
  `search_organ_` (der Wrapper) bleibt Member, ist für Pools aber LEER (wird nicht mehr beschrieben).
- Trait: `libs/cache_engine/axes/lookup/composable/organ_for_search_algo.hpp` mappt Wrapper→Organ
  (z. B. `BinarySearchTreeSearchAlgo` → `BstTreeOrgan` = `ComposedTreeSearch<BSTTraversalOrgan, TreeNodePoolStore>`;
  Aliase in `libs/cache_engine/axes/lookup/composable/tier_to_organ_mapping.hpp:42-97`).
- Die Organ-Klassen (je `<Traversal, Pool>`-Template, EINHEITLICHES std::map-Interface
  `insert(k,v)/lookup(k)/erase(k)/clear()/occupied_count()`, key_type = std::uint64_t) liegen in
  `libs/cache_engine/axes/lookup/composable/`:
  `composed_tree_search.hpp` (BST) · `composed_btree_search.hpp` · `composed_skip_list_search.hpp` ·
  `composed_hash_search.hpp` · `composed_art_trie_search.hpp` · `composed_hot_patricia_search.hpp` ·
  `composed_start_trie_search.hpp` · `composed_wormhole_search.hpp` · `composed_surf_map_search.hpp` ·
  (`composed_masstree_search.hpp` = deferred, s. §5).
  Die zugehörigen Pool-Stores (`tree_node_pool_store.hpp`, `btree_node_pool_store.hpp`, `skip_list_node_pool_store.hpp`,
  `hash_bucket_pool_store.hpp`, `art_trie_node_pool_store.hpp`, `hot_patricia_node_pool_store.hpp`,
  `start_trie_node_pool_store.hpp`, `wormhole_leaf_list_pool_store.hpp`, `surf_fst_map_pool_store.hpp`) liegen im
  selben Verzeichnis. LIES sie je Familie, bevor du den Walk schreibst.
- Die Hülle `libs/cache_engine/axes/lookup/composable/observable_composed_container.hpp` (Z.38-106):
  hält `Container container_{}` privat, `container()`-Accessoren (Z.84-85), Statistik nur unter
  `#ifdef COMDARE_CE_ENABLE_STATISTICS` (insert/lookup/erase zählen; `clear()`=nur Daten; `reset()`=nur Statistik;
  `restore_statistics(s)` für CoW #133). KEIN save_state, KEINE Iteration — genau die Lücke.
- Flaches Präzedenz-Vorbild: `libs/cache_engine/axes/lookup/composable/composable_search.hpp:108` — der FLACHE
  `ComposedSearch<Traversal,Store>` hat bereits einen Record-Walk („Senke (aufrufbar mit (key,value)) IN
  KEY-REIHENFOLGE. Rueckgabe = Anzahl besuchter Records."). Übernimm NAME + SIGNATUR-Form von dort
  (sehr wahrscheinlich `for_each_record`; LIES die Stelle und spiegele sie exakt).

## 3) Der Defekt (DEG-1), den du behebst
`anatomy/abi_adapter.hpp`, `fill_segment_timing_v3`, Key-Ernte Z.1298-1314 (Zeilen-Anker approximativ, greppe den
Kommentar „Reale gespeicherte Keys EINMAL beziehen"):

```cpp
std::vector<std::uint64_t> keys;
if constexpr (::comdare::cache_engine::lookup::composable::StoreTraversableSearchAlgo<SearchAlgo>) {
    auto snap = container_.save_state().data; // ObservableComposedSearch::save_state → (key,value)-Liste im Store
    ...
} else if constexpr (MementoAxis<SearchAlgo>) {
    auto snap = search_organ_.save_state(); // (key,value)-Liste der real gespeicherten Records (Weg-B)
    ...
}
std::size_t const nk = keys.empty() ? std::size_t{1} : keys.size();
if (keys.empty()) keys.push_back(0);
```

Für Pool-Familien ist `StoreTraversableSearchAlgo<SearchAlgo>`=false und `MementoAxis<SearchAlgo>`=true (der
Wrapper hat save_state) — aber `search_organ_` ist LEER → `keys={0}, nk=1` → die per-op-Segment-Timings
(T0 :1326-1328 via `container_.lookup`, T1 ct_organ_.resolve, T2 map_organ_.resolve_offset, T3 pc_organ_.compress)
messen n_ops-mal Key 0 (Miss) = degeneriert. Gleiches Schicksal für die 11 Reference-Compositions
(search_algo = `Observable*Organ`-Hülle → `MementoAxis<SearchAlgo>`=false → keys={0}).

## 4) SOLL — genau DREI Bausteine (+Tests)

### (A) `for_each_record` auf JEDER der 9 Pool-Organ-Klassen
In jeder `composed_*_search.hpp` (tree/btree/skip_list/hash/art_trie/hot_patricia/start_trie/wormhole/surf_map):

```cpp
/// #188-4b-DEG1 — besucht JEDEN gespeicherten Record GENAU EINMAL als sink(key, value).
/// Reihenfolge familien-spezifisch, NICHT vertraglich (Hash unsortiert; Bäume/Tries in natürlicher Ordnung).
/// Reines Lesen: KEIN Substrat-/Statistik-Effekt. Rückgabe = Anzahl besuchter Records (== occupied_count()).
template <class Sink>
std::size_t for_each_record(Sink&& sink) const { ... }
```

- Der Walk MUSS die REALE Struktur traversieren (Pool-Knoten-Graph bzw. Bucket-Array) — KEIN Schatten-Key-Log,
  KEIN paralleler std::vector, KEIN Neben-Apparat (exakt das Anti-Pattern, das #188 eliminiert hat).
- Je Familie: lies Organ + Pool-Store und traversiere strukturgerecht, z. B.:
  BST=in-order über left/right ab root; BTree=Knoten-/Blatt-Walk über die key/child-Arrays; SkipList=Level-0-Kette;
  Hash=Bucket-Scan NUR occupied (Tombstones/Empty überspringen); ART/HOT/START=rekursiver bzw. iterativer
  Trie-Abstieg (alle Kindarten der adaptiven Knoten!); Wormhole=doppelt verkettete Leaf-Liste; SuRF=Map-/FST-Walk.
  Wenn eine Familie bereits eine äquivalente interne Traversierung besitzt (z. B. fürs erase/rebalancing), NUTZE sie
  wieder, statt zu duplizieren. Rekursion vermeiden, wo die Struktur tief werden kann (expliziter Stack ok).
- Falls das Organ den Zustand teils im Traversal-Organ hält (z. B. root-Index): entsprechend dort ansetzen.

### (B) Delegation auf der Hülle `ObservableComposedContainer`
In `observable_composed_container.hpp` (nach `occupied_count()`/`container()`):

```cpp
/// #188-4b-DEG1 — Key-Ernte für den Mess-Pfad (abi_adapter::fill_segment_timing_v3): delegiert an das Organ.
/// Meta-/Mess-Operation: bewusst OHNE Statistik-Effekt (kein lookup-/insert-Zähler).
template <class Sink>
std::size_t for_each_record(Sink&& sink) const { return container_.for_each_record(std::forward<Sink>(sink)); }
```
(+ `#include <utility>` falls nötig.) AUSSERHALB des `#ifdef COMDARE_CE_ENABLE_STATISTICS` (funktional, nicht statistisch).

### (C) Harvest-Zweig im Adapter (`anatomy/abi_adapter.hpp`, Key-Ernte aus §3)
Ersetze die zweizweigige Ernte durch VIER Zweige in DIESER Reihenfolge (if/else-if-Kette):
1. `StoreTraversableSearchAlgo<SearchAlgo>` — UNVERÄNDERT lassen (flacher Store).
2. **NEU** `else if constexpr (pool_family_)` — Pool-Keys aus dem NATIVEN Organ:
   `container_.for_each_record([&](std::uint64_t k, std::uint64_t) { keys.push_back(k); });`
   (vorher `keys.reserve(container_.occupied_count());`). Kommentar: `#188-4b-DEG1: Pool-Key-Ernte aus dem nativen
   container_-Organ statt dem (nach dem Flip leeren) search_organ_ → echte per-op-Segment-Timings.`
3. `else if constexpr (MementoAxis<SearchAlgo>)` — UNVERÄNDERT (Weg-B Default-Flach mit Wrapper-Daten).
4. **NEU (Bonus, klein)** `else if constexpr (requires { search_organ_.for_each_record([](std::uint64_t, std::uint64_t){}); })`
   — Reference-Compositions (search_algo = Observable*Organ-Hülle als `search_organ_`): Keys via
   `search_organ_.for_each_record(...)`. Kommentar: behebt die keys={0}-Degeneration auch für die References.
Der Fallback `keys={0}` DANACH bleibt unverändert.
WICHTIG: `pool_family_` und `container_is_authoritative_` existieren bereits als `static constexpr bool` im Adapter —
verwende sie, definiere NICHTS Neues davon.

### (D) Tests (NUR bestehende Targets erweitern — KEINE CMake-/CI-Änderungen)
1. `tests/unit/test_188_4bb0_pool_organ_wide_key_conformance.cpp` (gtest): in
   `verify_pool_organ_wide_key_conformance<Wrapper>()` nach dem insert-Block (b1) einen Abschnitt „(b1b) for_each_record"
   ergänzen: sammle via `c.for_each_record` alle (k,v) in eine `std::map<std::uint64_t,std::uint64_t>` und
   EXPECT_EQ gegen `oracle` (gleiche Größe, gleiche Paare); Rückgabewert == oracle.size() == c.occupied_count().
   Nach dem erase-Block (b5/b6) denselben Vergleich erneut (Ernte reflektiert erases). Auf leerem Container
   (nach clear, b7): 0 Besuche, Rückgabe 0.
2. `tests/unit/test_188_4bbV_pool_adapter_flip_compile.cpp` (Standalone, läuft im CI-Job contract:pool_flip):
   KEINE Struktur-Änderung nötig — der neue Adapter-Zweig (C) wird durch die bestehende `tier_observe`-Fahrt
   automatisch mit-instanziiert (Compile-Gate). Ergänze NUR, falls trivial möglich, direkt nach dem tier_observe-Block
   einen Kommentar, dass der Pool-Harvest-Zweig hier mit-compiliert wird (kein neuer Check nötig).

## 5) Verbote / Constraints (STRIKT)
- NICHT anfassen: `modules/**`, `ext/**`, `.gitlab-ci.yml`, `CMakeLists.txt`, `tests/unit/CMakeLists.txt`,
  `cmake/**`, `composable_search.hpp`, `observable_composed_search.hpp`, die Memento-/CoW-Logik des Adapters
  (tier_save_all/tier_rollback_all, saved_*-Member — der Kopie-Fallback deckt Pools bereits; KEIN save_state/
  restore_state an der Hülle, das wäre toter Code neben dem Kopie-Pfad), `organ_for_search_algo.hpp`,
  `tier_to_organ_mapping.hpp`.
- `composed_masstree_search.hpp`: NUR wenn der Walk trivial analog ist, mit-implementieren; sonst auslassen und
  im Abschlussbericht notieren (Familie ist deferred, kein Wrapper in AllStrategies).
- Keine Format-/Umbenennungs-Sweeps; minimale Diffs; keine neuen Dateien; keine Runtime-Switches (alles
  compile-time via if constexpr/requires); kein dynamic_cast; keine Statistik-Semantik-Änderung (clear/reset/
  restore_statistics bleiben exakt wie sie sind); `for_each_record` ist const und liest nur.
- Achte auf die bestehenden Include-Guards/Namespaces (`comdare::cache_engine::lookup::composable`).
- Der Adapter ist ein ~2000-Zeilen-god-header — ändere AUSSCHLIESSLICH die Key-Ernte-Stelle aus §3/§4C.

## 6) Definition of Done
- Alle 9 Organe + Hülle tragen `for_each_record` (Vertrag §4A); Adapter-Ernte hat die 4-Zweig-Kette (§4C);
  test_188_4bb0 erweitert (§4D1). Geänderte Dateien im Arbeitsbaum hinterlassen (unstaged ok).
- Abschlussbericht (dein Final-Output): Datei-Liste, je Familie 1-2 Sätze zum Walk (welche Struktur, welche
  Invariante sichert exactly-once), Risiken/offene Fragen (z. B. Familien, bei denen du dir unsicher bist).
