# DOSSIER W1/234-K — Sequenzieller Kopf: 4 Node-Shape-Achsen-Gerüste (geteilte Dateien, Varianten Default-OFF)

Du bist der IMPLEMENTIERUNGS-Agent. Implementiere GENAU diesen Increment im Arbeitsbaum. NICHT committen/pushen/
builden (kein lokaler Compiler; statisch sorgfältig gegen die genannten Vorlagen prüfen). Abschlussbericht:
Datei-Liste + je Achse 1-2 Sätze + Risiken/offene Fragen.

## 1) Repo/Stand/Kontext
Repo-Wurzel = Arbeitsverzeichnis (comdare-cache-engine, main, HEAD b8761f0, sauber). C++23, Boost.MP11.
#188-4b-c/D: per-Familie Node-Shape-Achse für die 4 NICHT-Trie-Pool-Familien — **BtreeOrder, SkipListShape,
BstShape, HashProbeShape** — als Achsen AUSSERHALB der 19 Composition-Slots (Präzedenz `axis_01_page_type`),
mit Default-OFF-Varianten (Präzedenz per-K `7c1f444`). Dieser Increment 234-K legt NUR die GETEILTEN Teile an;
4 disjunkte Familien-Increments (F1-F4) füllen danach NUR ihre eigenen Dateien (Varianten-Level-Logik,
Pool-Store-/Traversal-Umbau je Level, Tests).

## 2) Die 4 Achsen (Spezifikation)
GEMEINSAMER KONTRAKT: (a) **Level 0 = EXAKT die heutige hartkodierte Shape, CMake-Option Default-ON**;
alle VARIANTEN-Levels Default-OFF (0-Fanout-Riegel: eine gepushte Achse mit 0 enabled-Levels macht
binary_count=0 — `axis_reflect.hpp:40-42` + `experiment_tree.hpp:360-376`; Level-0-ON garantiert ≥1).
(b) Achse = compile-time Strategie-Typen (kein Runtime-Switch). (c) Default-Verhalten ALLER heutigen Binaries
bit-identisch (Level-0-Strategie trägt exakt die Ist-Konstanten; Varianten OFF).
1. **BtreeOrder** (`axes/lookup/composable/btree_node_pool_store.hpp:26-33`: kT=4/kMaxKeys=7/kMaxChildren=8):
   Strategien `BtreeOrderKt2|Kt3|Kt4(Default,ON)|Kt8|Kt16` — je `static constexpr int kT` (+abgeleitete Werte
   als Doku-Kommentar; die STORE-Umsetzung macht F1).
2. **SkipListShape** (`skip_list_node_pool_store.hpp:32`: kMaxLevel=16, p=0.5): Strategien
   `SkipListMax16P50(Default,ON)|Max8P50|Max32P50|Max16P25` — je `static constexpr int kMaxLevel` +
   `static constexpr int kPNumerator/kPDenominator` (16/1/2 etc.).
3. **BstShape** (`tree_node_pool_store.hpp:20-24`: size_t-Indizes left/right, KEINE Shape-Konstante):
   Dimension = INDEX-/ZEIGER-PACKING: Strategien `BstPtrSizeT(Default,ON)|BstPtrU32|BstPtrU16` — je
   `using index_type = std::size_t|std::uint32_t|std::uint16_t` (+`static constexpr std::size_t kIndexBytes`).
4. **HashProbeShape** (`hash_bucket_pool_store.hpp:29` kInitialCapacity=16, OA/Tombstone/Fibonacci;
   Load-Faktor 0.7 liegt im `hash_probe_traversal_organ.hpp:49-85`): Strategien
   `HashOaLf70(Default,ON)|HashOaLf50|HashOaLf90|HashChaining` — je `static constexpr bool kOpenAddressing`
   + `static constexpr int kLoadNumerator/kLoadDenominator` (chaining: kOpenAddressing=false; VOLLER
   Struktur-Umbau Store+Organ = F4, hier NUR die Strategie-Typen).

## 3) SOLL — exakt diese Bausteine (Muster mit file:line)
### (A) 4 neue Achsen-Verzeichnisse `topics/nodes/axis_btree_order/`, `axis_skip_list_shape/`,
`axis_bst_shape/`, `axis_hash_probe_shape/` — VOLLSTÄNDIG nach page_type-Muster
(`topics/nodes/axis_01_page_type/`): je eigener `…_registry.hpp` (AllShapes-mp_list + `is_enabled` +
`EnabledShapes = mp_filter<…>` + `static_assert(size>0)` — Muster `axis_01_page_type_registry.hpp:20-28`),
je EIGENE `…_flags.hpp.in` (`#cmakedefine01 COMDARE_AXIS_<KURZ>_USE_*` + `inline constexpr bool *_enabled` —
Muster `axis_01_page_type_flags.hpp.in:4-18`), je CRTP-`…_strategy_base.hpp` (Muster
`axis_01_page_type_strategy_base.hpp:13-20`), je `concepts/…_concept.hpp` + `…_cache_engine_permutation_concept.hpp`
(Muster page_type concepts :14-30 bzw. :10-18), je die Strategie-Header aus §2 (Muster
`axis_01_page_type_dense_byte.hpp:15-31`: `enabled = flags::…_enabled`, `flag_suffix()`, `name()`, family-Tag).
**ALLE Strategie-Typen aller Levels implementieren** (sie sind reine constexpr-Konstanten-Träger — kein
Store-Umbau; das ist billig und macht F1-F4 zu reinen Konsum-Increments).
### (B) Root-`CMakeLists.txt` — je Achse ein EIGENER Block (4 Blöcke, direkt hinter dem page_type-Block):
Options (Level-0 **ON**, Varianten **OFF** — OFF-Muster wörtlich wie `CMakeLists.txt:256-259`), eigenes
`foreach(...)`-USE + `configure_file` nach `generated/topics/nodes/axis_<name>/…` + Status-message (Muster
page_type `CMakeLists.txt:286-292` + `:862-873`).
### (C) Meta-Registrierung (die EIGENTLICH geteilten Dateien):
- `builder/experiment_tree/registry_to_axis_levels.hpp`: 4 Includes (Muster `:22`), 4 `using T22..T25_… =
  …EnabledShapes` (Muster `:64`), 4 `push_static_axis<…>(lv, "btree_order"|"skip_list_shape"|"bst_shape"|
  "hash_probe_shape")` (Muster `:93`), 4 Faktoren in `all_axes_binary_count()` (Muster `:111`),
  `lv.reserve(22)`→26 (`:75`).
- `builder/experiment_tree/axis_observer_classification.hpp` (bzw. wo die 22er-Liste liegt): 4 Einträge
  `{"…", DefinitionOnly}` (Muster `:66`), Array 22→26 (`:47`), count-Diagnose konsistent (`:88-90`).
### (D) Shape-Durchreichungs-SIGNATUR (kopf-owned, verhaltens-neutral):
- Die 4 Pool-Stores bekommen einen Shape-Template-Parameter MIT DEFAULT = Level-0-Strategie:
  `template <class Shape = nodes::axis_btree_order::BtreeOrderKt4> class BTreeNodePoolStore { … }` — in DIESEM
  Increment NUR: Parameter einführen + `static_assert(Concept<Shape>)` + die bisher hartkodierten Konstanten aus
  `Shape::` LESEN, wo das 1:1 möglich ist (BTree kT/kMaxKeys/kMaxChildren aus Shape::kT; SkipList kMaxLevel aus
  Shape::kMaxLevel; BST index_type aus Shape::index_type NUR wenn trivialer typedef-Tausch bit-neutral ist —
  size_t bleibt Default; Hash: kOpenAddressing/Load NUR als static_assert(Shape::kOpenAddressing==true)-Anker +
  Kommentar, KEIN Verhalten). Alles, was mehr als Konstanten-Lesen wäre (RNG-p-Umbau, chaining, u16-Packing-
  Konsequenzen), bleibt F1-F4 — hier nur der Anker, dokumentiert je Stelle mit `#234-K`-Kommentar.
  Präzedenz Store-Templatisierung: `axes/node/axis_04_node_type_layout_aware_store.hpp:53-56` (+requires).
  Präzedenz Default-NTTP am Organ: `tier_to_organ_mapping.hpp:67` `StartTrieTraversalOrgan<2>` /
  `masstree_layer_traversal_organ.hpp:45`.
- `axes/lookup/composable/tier_to_organ_mapping.hpp:42-46`: die 4 Aliase bleiben SEMANTISCH identisch —
  `BTreeSearchOrgan = ComposedBTreeSearch<BTreeTraversalOrgan, BTreeNodePoolStore<>>` (Default-Arg) usw.
  ZUSÄTZLICH je Familie ein parametrisierter Alias `BTreeSearchOrganShaped<Shape> = …<…, BTreeNodePoolStore<Shape>>`
  (analog SkipList/Bst/Hash) als F-Konsumpunkt.
- Falls die jeweiligen `*_node_pool_concept.hpp` die Konstanten verlangen (`btree_node_pool_concept.hpp:25-32`):
  Concepts UNVERÄNDERT lassen (die Stores erfüllen sie weiter — Konstanten existieren ja, nur aus Shape gespeist).
### (E) BEWUSST NICHT in 234-K (im Bericht als Abgrenzung nennen): Build-Variant-ABI-Erweiterung
(`build_variant_definition.hpp:17-29/:60`, reader, inspection-Makro, adhoc_emitter-Emission der Shape-Typen)
= späterer Verdrahtungs-Increment 234-V nach F1-F4; ebenso KEINE Tests-CMake-Targets (kommen mit F1-F4).
`composed_*_search.hpp`, `organ_for_search_algo.hpp`, `abi_adapter.hpp`, `observable_composed_container.hpp`
werden NICHT angefasst (Recherche-bestätigt: Container-Interface bleibt gleich → keine Adapter-Änderung nötig).

## 4) Verbote/Constraints (STRIKT)
- NICHT anfassen: modules/**, ext/**, cmake/**, .gitlab-ci.yml, tests/**, die 9 composed_*_search.hpp,
  organ_for_search_algo.hpp, abi_adapter.hpp, observable_composed_container.hpp, alle Traversal-Organe
  (inkl. hash_probe_traversal_organ.hpp — Load-Factor-Umbau ist F4!), Konformitäts-Gate, is_original-Dateien.
- Bit-Identität: Default-Build (nur Level-0 ON) erzeugt EXAKT heutige Konstanten/Typen in den 4 Stores;
  KEINE Logik-Änderung in insert/lookup/erase/rehash/split.
- golden-320/m3v2 nicht stören: die 4 neuen AxisLevels haben im Default GENAU 1 Wert (Level 0) → binary_count-
  Faktor 1. NICHTS an axis_03a/EnabledStrategies ändern.
- Topics-Shims (topics/traversal/…/composable/*.hpp re-exportieren axes/lookup/…) unverändert lassen.
- Deutsche Banner-Kommentare im Nachbar-Stil, Task-Tag `#234-K`; Namensschema der Verzeichnisse/Dateien exakt
  wie axis_01_page_type (nur ohne Nummern-Präfix-Zwang — wähle `axis_btree_order` etc. wie in §3A benannt).
- Minimale Diffs; keine Format-Sweeps.

## 5) DoD + Bericht
4 Achsen-Gerüste vollständig (alle Level-Strategien als Konstanten-Träger), CMake 4 Blöcke (Level-0 ON/Rest OFF),
registry_to_axis_levels 22→26 + observer_classification 22→26 konsistent, 4 Pool-Stores tragen Shape-Param mit
Default-Arg (bit-neutral, Konstanten aus Shape gelesen wo 1:1), tier_to_organ_mapping mit Default- +
Shaped-Aliasen. Bericht: Datei-Liste; je Achse: welche Konstanten Level-0 trägt + was F1-F4 als Nächstes füllt;
Risiken (v.a. Stellen, wo Konstanten-Lesen NICHT 1:1 ging und du den Anker-Kommentar statt Umbau gesetzt hast).
