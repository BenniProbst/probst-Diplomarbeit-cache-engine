# T-Phase Adapter-Status — V32+ Vorbereitung (T.1-T.4)

**Stand:** 2026-05-18 (T-Phase 4/4 DONE als Konsolidierungs-Doku)
**Trigger:** Email-Code-Drops (Schuele/Zhang/Kuehn) + N-Phase 14-Achsen-Erweiterung
**Konsequenz fuer V32+:** comdare-cache-engine/adapters/ Sub-Verzeichnisse aufruesten

> **Hinweis:** Dieses Dokument konsolidiert die Adapter-Status- + Aufbau-Plaene. Die eigentlichen Code-Aenderungen folgen in V32+ Sprints (cache-engine + prt-art Submodule-Push erforderlich). Die Doku hier ist die Spezifikation.

---

## §1 T.1 — P06-B2tree Adapter-Upgrade

**Aktueller Stand:** `Code/external/comdare-cache-engine/adapters/P06-B2tree/p06_b2tree_adapter.hpp` ist V31.K3-Skelett (Stub mit COMDARE_HAVE_B2TREE-Schalter).

**Vorhandene ext/-Quelle:** `Forschungsarbeiten/code/P06-B2tree/b2-tree-master/` (voller B²-Tree-Source) + `bart-master/` (Cross-Algorithm-Vergleichsbasis).

### §1.1 Upgrade-Plan V32

1. **CMakeLists aktualisieren** in `cache-engine/adapters/P06-B2tree/CMakeLists.txt`:
   - `find_package(P06_B2tree QUIET)` oder direkter `add_subdirectory(${PROJECT_SOURCE_DIR}/../../Forschungsarbeiten/code/P06-B2tree/b2-tree-master)` (bei lokaler Build)
   - `target_compile_definitions(adapter_p06_b2tree PUBLIC COMDARE_HAVE_B2TREE=1)` wenn ext/-Quelle gefunden
2. **Header erweitern** mit Achsen-Auspraegung (Doxygen):
   ```
   /// Achse 1 PAGE-TYPE: PAGE_DECISION_B2TREE / PAGE_SPAN_B2TREE
   /// Achse 2 NODE-TYPE: NODE_DECISION_B2TREE / NODE_SPAN_B2TREE
   /// Achse 3.A SearchAlgo-Traversal: Decision-Tree-Walk + Span-Scan
   /// Achse 3.B Cache-Memory-Traversal: L2-aware Decision-Tree-cache
   /// Achse 3.M Mapping: Embedded-Decision-Tree-Offset
   /// Achse 6.2 Reclamation: epoch + hazard-pointer (b2-tree-master internal)
   /// Achse 8.1 Pattern: OLC (optimistic_lock.hpp)
   /// Achse 8.2 Locking-Mode: optimistic-validation
   /// Achse 12.1 SIMD: scalar (BMI2-Befehle moeglich)
   /// Achse 12.2 Cache-Level: L2-aware
   /// Achse 13.1 Worker-Pool: thread-per-core
   ```
3. **Wrapper-Methoden** in B2TreeAdapter um die b2-tree-master internal API umsetzen:
   - `insert(key, value)` → `b2tree::Tree::insert(b2tree::Key{key}, b2tree::Value{value})`
   - `find(key)` → `b2tree::Tree::lookup(b2tree::Key{key}).value_or(std::nullopt)`
4. **Smoke-Test ergaenzen** in `tests/unit/test_v31_adapters.cpp`: P06-B2tree mit echtem ext/-Pfad.

### §1.2 LICENSE-Status

Keine LICENSE-Datei im Nextcloud-Drop. Per Architekt-Direktive II 2026-05-14 verwendbar mit korrekter Zitation (Schmeisser/Schuele/Leis/Neumann/Kemper 2022). NOTICE-Eintrag aktualisieren mit dieser Klarstellung.

---

## §2 T.2 — P27-hp-soft Adapter NEU anlegen

**Aktueller Stand:** Verzeichnis existiert NICHT in `cache-engine/adapters/`. V31.K5+K6 Code liegt in `comdare-prt-art/` (P27 Build-Time-Tool + Runtime-Prefetcher).

**Vorhandene Quellen:**
- `Forschungsarbeiten/code/P27-Zhang-ASPLOS-Hierarchical/hp-soft/hp_soft.py` (Original Python-Script)
- `comdare-prt-art/tools/p27_bundle_finder/` (C++23-Port, V31.K5)
- `comdare-prt-art/prt_art/include/prt_art/prefetch/hierarchical_bundle_prefetcher.hpp` (Runtime, V31.K6)

### §2.1 Aufbau-Plan V32

1. **Verzeichnis anlegen:** `cache-engine/adapters/P27-hp-soft/`
2. **CMakeLists.txt:**
   ```
   option(COMDARE_USE_P27_HP_SOFT "Use P27 hp-soft hierarchical prefetcher" OFF)
   if(COMDARE_USE_P27_HP_SOFT)
       add_library(adapter_p27_hp_soft INTERFACE)
       target_compile_definitions(adapter_p27_hp_soft INTERFACE COMDARE_HAVE_P27_HP_SOFT=1)
       target_include_directories(adapter_p27_hp_soft INTERFACE
           ${PROJECT_SOURCE_DIR}/../comdare-prt-art/prt_art/include)
   endif()
   ```
3. **Header `p27_hp_soft_adapter.hpp`** als Wrapper um HierarchicalBundlePrefetcher:
   ```cpp
   // V32.T2 — P27 hp-soft Adapter (Wrapper for V31.K5 build-time + V31.K6 runtime)
   #pragma once
   #include <cstdint>
   #include <string_view>
   
   #if defined(COMDARE_HAVE_P27_HP_SOFT)
   #  include <prt_art/prefetch/hierarchical_bundle_prefetcher.hpp>
   #endif
   
   namespace comdare::adapter::p27_hp_soft {
   
   /// Achse 7 PREFETCH: Hierarchical-Bundle (P27 Sub-Familie)
   /// Achse 12.1 SIMD: scalar
   /// Achse 12.2 Cache-Level: L1+L2+L3-aware (hierarchical)
   /// Achse 12.4 Prefetch-Hardware: PREFETCH + PREFETCHNTA
   /// Achse 13.4 Co-Routine-Strategy: interleave (mit Hardware-Prefetch)
   ///
   /// License: CC-BY (open access via Edinburgh Research Explorer)
   /// DOI 10.1145/3676641.3716260
   /// Citation: T. Zhang et al. (2025). "Hierarchical Prefetching..."
   ///   ASPLOS '25, 30th ACM International Conference on Architectural
   ///   Support for Programming Languages and Operating Systems, Volume 2.
   class HpSoftAdapter {
   public:
       [[nodiscard]] static constexpr const char *paper_id() noexcept {
           return "P27 hp-soft (T. Zhang et al. 2025 ASPLOS)";
       }
   
   #if defined(COMDARE_HAVE_P27_HP_SOFT)
       using prefetcher_type =
           comdare::prt_art::prefetch::HierarchicalBundlePrefetcher;
   
       void prefetch_l1(std::uintptr_t addr) { prefetcher_.prefetch_l1(addr); }
       void prefetch_l2(std::uintptr_t addr) { prefetcher_.prefetch_l2(addr); }
       void prefetch_l3(std::uintptr_t addr) { prefetcher_.prefetch_l3(addr); }
   
   private:
       prefetcher_type prefetcher_;
   #endif
   };
   
   } // namespace comdare::adapter::p27_hp_soft
   ```
4. **Smoke-Test ergaenzen** in `tests/unit/test_v31_adapters.cpp`: P27 hp-soft Adapter konstruieren + paper_id() pruefen.

### §2.2 NOTICE-Eintrag

```
- P27 hp-soft: T. Zhang et al. (2025). "Hierarchical Prefetching: A
  Software-Hardware Instruction Prefetcher for Server Applications".
  ASPLOS '25. DOI 10.1145/3676641.3716260. License: CC-BY.
  Source via E-Mail-Reply 2026-05-11 (hp-soft.zip).
```

---

## §3 T.3 — P28-DaMoN-LeafCounter Adapter NEU vorbereiten

**Aktueller Stand:** Code von Kuehn NOCH NICHT eingegangen (User-Direktive 2026-05-18: keine weiteren Mails). Adapter-Verzeichnis kann VORBEREITET werden als Skelett.

### §3.1 Aufbau-Plan V32

1. **Verzeichnis anlegen:** `cache-engine/adapters/P28-DaMoN-LeafCounter/`
2. **CMakeLists.txt:**
   ```
   option(COMDARE_USE_P28_LEAF_COUNTER "Use P28 Kuehn Leaf-Only Counter" OFF)
   if(COMDARE_USE_P28_LEAF_COUNTER)
       add_library(adapter_p28_leaf_counter INTERFACE)
       target_compile_definitions(adapter_p28_leaf_counter INTERFACE
           COMDARE_HAVE_P28_LEAF_COUNTER=1)
   endif()
   ```
3. **Header `p28_damon_leafcounter_adapter.hpp`** als Skelett:
   ```cpp
   // V32.T3 — P28 DaMoN Leaf-Only Counter Adapter (Skelett, Code pending)
   #pragma once
   #include <cstdint>
   #include <atomic>
   #include <stdexcept>
   
   namespace comdare::adapter::p28_damon_leafcounter {
   
   /// Achse 11 TELEMETRY-COLLECTION-STRATEGY: Leaf-Only-Counter (11.X1)
   ///
   /// User-Direktive 2026-05-18 Kuehn-Quote: "Insbesondere auf die Knoten in
   /// den oberen Ebenen des Baums wird sehr haeufig zugegriffen, sodass diese
   /// typischerweise im Caches mehrerer Kerne liegen. Zusaetzliche
   /// Schreibzugriffe fuehren dann durch die Cache-Kohaerenzmechanismen
   /// schnell zu starkem Cacheline-Ping-Pong zwischen den Kernen."
   ///
   /// Strategie:
   ///   - Counter NUR in Blatt-Knoten (vermeidet Ping-Pong in inneren Ebenen)
   ///   - Vor Reordering: bottom-up Aufsummierung von Blatt zur Wurzel
   ///   - Sampling-Variante: nur jeder n-te Zugriff gezaehlt (11.X2)
   ///
   /// License: PENDING (Code-Drop ausstehend)
   /// Citation: Kuehn et al. (2023). "Towards Data-Based Cache Optimization
   ///   of B+-Trees". DaMoN 2023.
   class LeafCounterAdapter {
   public:
       [[nodiscard]] static constexpr const char *paper_id() noexcept {
           return "P28 Kuehn Leaf-Only Counter (DaMoN 2023)";
       }
   
   #if defined(COMDARE_HAVE_P28_LEAF_COUNTER)
       // [PENDING] echte Implementation sobald Kuehn-Code eingeht
       void notify_leaf_access(std::uintptr_t leaf_id) {
           // [TODO] increment Leaf-Counter
           (void)leaf_id;
       }
       void offline_recompute_inner_node_counters() {
           // [TODO] bottom-up Aggregation
       }
   #else
       void notify_leaf_access(std::uintptr_t) {
           throw std::runtime_error("COMDARE_HAVE_P28_LEAF_COUNTER not enabled");
       }
       void offline_recompute_inner_node_counters() {
           throw std::runtime_error("COMDARE_HAVE_P28_LEAF_COUNTER not enabled");
       }
   #endif
   };
   
   } // namespace comdare::adapter::p28_damon_leafcounter
   ```
4. **Smoke-Test ergaenzen** in `tests/unit/test_v31_adapters.cpp`.

### §3.2 Pending wenn Kuehn-Code eingeht

1. Code drop in `Forschungsarbeiten/code/P28-Kuehn-DAMON/<code>/`
2. ext/-Verweis in CMakeLists.txt aktivieren
3. echte Implementation in Adapter ausfuellen
4. PRT-ART eigene Variante der Leaf-Only-Counter-Telemetrie (Achse 11.X1)

---

## §4 T.4 — bart-master Cross-Algorithm-Hooks (HAT-Trie / PB-Tree-Static / BART-Hybrid)

**Aktueller Stand:** `Forschungsarbeiten/code/P06-B2tree/bart-master/` enthaelt:
- ART.cpp (P01-aehnlich, eigene Implementation)
- b2tree_int.cpp (P06 B²-Tree)
- bart.cpp (BART-Hybrid)
- btree.cpp (klassischer B+-Tree)
- cpp-btree-1.0.1/ (Google btree submodule)
- hattrie.cpp (HAT-Trie P06-Sub-Variante)

Die Varianten sind bereits in der Bausteine-Matrix verankert: `PAGE_BART_HYBRID_P06`, `PAGE_HATTRIE_P06`, `PAGE_PBTREESTATIC_P06`, `PAGE_PBTREESTATIC_OPT_P06`, `PAGE_PBTREESTATIC_TRIE_P06`, `PAGE_PBTREESTATIC_ART_P06` (siehe `01_bausteine_matrix.md` §3 Zeilen 139-189).

### §4.1 Aufbau-Plan V32

1. **Sub-Verzeichnisse anlegen:**
   - `cache-engine/adapters/P06-B2tree/sub/hattrie/`
   - `cache-engine/adapters/P06-B2tree/sub/bart_hybrid/`
   - `cache-engine/adapters/P06-B2tree/sub/pbtree_static/`
2. **Pro Sub-Verzeichnis** CMakeLists.txt + Adapter-Header (Skelett-Stub mit COMDARE_HAVE_<X> Schalter), analog zu T.1.
3. **Achsen-Zuordnung pro Variante** im Header dokumentieren (analog T.1).

### §4.2 Cross-Algorithm-Vergleichsbasis

bart-master ist primaer eine Cross-Algorithm-Vergleichsbasis (P06-Sub-Variante mit verschiedenen Page-Typ-Konkretisierungen). Im Messreihen-Setup A (PRT-ART vs SOTA) koennten diese Varianten als zusaetzliche Baselines dienen — falls vom Diplomanden gewuenscht.

---

## §5 Status-Zusammenfassung T-Phase

| Adapter | Verzeichnis | Skelett-Status | ext/-Quelle | V32-Aktion |
|---|---|---|---|---|
| **T.1 P06-B2tree** | `adapters/P06-B2tree/` existiert | V31.K3-Skelett | b2-tree-master (voll) | Upgrade mit ext/-Verweis |
| **T.2 P27-hp-soft** | NEU anlegen | — | comdare-prt-art/tools + prefetch | Header + CMakeLists NEU |
| **T.3 P28-DaMoN-LeafCounter** | NEU anlegen | — | (Code pending) | Skelett-Header + CMakeLists |
| **T.4 bart-master Sub** | NEU `sub/{hattrie,bart_hybrid,pbtree_static}/` | — | bart-master (voll) | 3 Sub-Skelette |

---

## §6 Konsequenzen fuer V32+ Code-Sprint

Diese T-Phase-Doku spezifiziert was im V32+ Sprint im comdare-cache-engine-Repo aenderbar ist:

1. 1x CMakeLists.txt-Erweiterung in `adapters/CMakeLists.txt` (Top-Level) um P27 + P28 add_subdirectory
2. 1x Upgrade `adapters/P06-B2tree/{CMakeLists,p06_b2tree_adapter.hpp}` (T.1)
3. 1x NEU `adapters/P27-hp-soft/{CMakeLists,p27_hp_soft_adapter.hpp}` (T.2)
4. 1x NEU `adapters/P28-DaMoN-LeafCounter/{CMakeLists,p28_damon_leafcounter_adapter.hpp}` (T.3)
5. 3x NEU `adapters/P06-B2tree/sub/{hattrie,bart_hybrid,pbtree_static}/{CMakeLists,...adapter.hpp}` (T.4)
6. 1x Test-Erweiterung in `tests/unit/test_v31_adapters.cpp` (P27 + P28 + 3 Sub) → U-Phase (#510)
7. 1x NOTICE-Eintrag fuer P27 hp-soft CC-BY

Damit waechst die Adapter-Anzahl von 22 auf **22 + 3 (P27/P28/upgraded P06) + 3 Sub-Hooks = 28**.

---

## §7 Querverweise

- Email-Verlaeufe (Top-Level PDFs): `../../E-Mail Kuehn/Schuele/Zhang ...pdf`
- EMAIL_KONTAKTE.md REV 3: `../EMAIL_KONTAKTE.md`
- Forschungsarbeiten-STATUS pro Paper: `../../Forschungsarbeiten/code/{P06-B2tree,P27-...,P28-Kuehn-DAMON}/STATUS.md`
- Bausteine-Matrix N-Phase: `../bausteine/07_bausteine_matrix_N_erweitert.md`
- Schichten-Modell M: `../architektur/10_schichten_modell_M.md`
- Anti-Vermischung: `../architektur/11_axes_vs_strategies_disambiguation.md`
- V31.K5+K6 Sessions: `../sessions/20260514-4500-habich-termin-8-briefing-refresh-v19-v31.md`

---

**Ende docs/adapters/T_PHASE_ADAPTER_STATUS.md (T.1-T.4 als Konsolidierungs-Doku DONE).**
