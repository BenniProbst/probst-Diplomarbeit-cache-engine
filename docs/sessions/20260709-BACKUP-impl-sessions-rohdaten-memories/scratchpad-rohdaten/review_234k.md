# ADVERSARISCHER REVIEW #234-K — Node-Shape-Achsen-Kopf (Gerüste + Shape-Param + Meta-Registrierung 22→26)

Du bist READ-ONLY-Reviewer. KEINE Edits. Prüfe den UNCOMMITTETEN Arbeitsbaum-Stand (HEAD b8761f0 + Diff):
`git status --short`, `git diff`, plus die 4 NEUEN untracked Verzeichnisse `libs/cache_engine/topics/nodes/axis_{btree_order,skip_list_shape,bst_shape,hash_probe_shape}/` (vollständig lesen).
Versuche aktiv, den Increment zu WIDERLEGEN (Compile-Bruch, Verhaltensänderung, Konsistenzloch). Verdikt am Ende: SHIP / SHIP-WITH-NITS / FIX (mit BLOCKER-Liste file:line).

## Increment-Anspruch (das ist zu verifizieren)
234-K legt NUR die geteilten Teile der 4 Nicht-Trie-Node-Shape-Achsen an; Verhalten ALLER heutigen Binaries bit-identisch:
1. 4 Achsen-Verzeichnisse nach axis_01_page_type-Muster (Registry mp_filter + flags.hpp.in #cmakedefine01 + CRTP-Base + 2 Concepts + alle Level-Strategien als constexpr-Konstanten-Träger).
2. Root-CMakeLists: 4 Options-Blöcke (Level-0 ON, Varianten OFF) + 4 foreach/configure_file-Blöcke nach `generated/topics/nodes/axis_*/`.
3. registry_to_axis_levels.hpp: axes22→axes26, 4 Includes, T22-T25, reserve(26), 4 push_static_axis, binary_count ×4 Faktoren. axis_observer_classification.hpp: Array 22→26, 4× DefinitionOnly, Diagnose 17/7/2.
4. Die 4 Pool-Stores tragen `template <typename Shape = Level0>` + static_assert(Concept) und LESEN Konstanten aus Shape (BTree kT; SkipList kMaxLevel; BST index_type voll verdrahtet; Hash nur static_assert-Anker kOpenAddressing==true). tier_to_organ_mapping: Default-Aliase mit `Store<>` semantisch identisch + je Familie `*OrganShaped<Shape>`.
5. Claude-Korrekturen (nach Codex-Draft): Legacy-Makrobrücken `#define Store Store<>` + #undef-Ritual ENTFERNT; stattdessen die 4 Traversal-Organ-Selfchecks (btree/hash_probe/skip_list/tree_traversal_organ letzte Zeilen) + tests/unit/test_v41_topic_traversal.cpp (5 Stellen) + test_v41_axis_03a_cross_variant_equivalence.cpp:30 auf `Store<>` gehoben; Test-Kardinalitäten 22→26 bzw. DefinitionOnly 3→7 in test_br1_full22_count.cpp / test_br3_obs22.cpp / test_d7b_definition_per_node.cpp; EOF-Newlines der 4 Stores; ⇒-Unicode-Restore; cstddef-Dublette.

## Prüf-Checkliste (JEDEN Punkt explizit beantworten)
1. **Bit-Neutralität Default-Build:** Level-0-Strategien tragen EXAKT kT=4 / kMaxLevel=16,P=1/2 / index_type=size_t / OA+7/10. KEINE Logik-Änderung in new_node/allocate_node/draw_level/place_occupied/rehash/clear (Diff-Zeilen der Stores durchgehen). BST: alle Casts für size_t identitätsäquivalent? kNil == numeric_limits<size_t>::max() für Level 0?
2. **Kein Makro-Rest, keine nackte Template-Nutzung:** grep auf `#define.*PoolStore` leer; jede Nutzung von {Tree,BTree,SkipList,HashBucket}...PoolStore außerhalb der eigenen Header ist `<...>`-Form (Kommentare egal). Auch composed_*_search.hpp / organ_for_search_algo.hpp / abi_adapter.hpp prüfen: kompilieren die mit Template-Store weiter (nutzen sie nur die Aliase aus tier_to_organ_mapping)?
3. **26er-Konsistenz:** registry (Includes/using/push/reserve/binary_count) ↔ observer_classification (26 Einträge, 7 DefinitionOnly) ↔ Tests (br1/br3/d7b jetzt 26/7). Gibt es WEITERE Dateien mit harter 22/„3 DefinitionOnly"-Annahme (grep '22' in builder/ + tests auf kAxisObserverClasses/build_all_axis_levels/all_axes_binary_count-Konsumenten, auch apps/)?
4. **CMake:** ENABLE-Defaults (KT4/MAX16_P50/PTR_SIZE_T/OA_LF70 = ON, Rest OFF); USE=ENABLE-foreach vollständig je Achse; configure_file-Quell-/Zielpfade existieren; flags.hpp.in-Makronamen == die im flags-Namespace konsumierten #cmakedefine01-Namen (Suffix-für-Suffix, alle 17).
5. **0-Fanout/golden-320:** Default-Build ⇒ je neue Achse GENAU 1 enabled Shape ⇒ binary_count-Faktor 1; axis_03a/EnabledStrategies unberührt.
6. **Include-Layering:** die neuen topics/nodes/axis_*-Header inkludieren NICHT zurück nach axes/lookup (Zyklusfreiheit); Stores (axes) → topics-Include ok wie bei topics-Shims üblich? `<topics/...>`-Pfade auflösbar (Include-Roots wie bei axis_01_page_type-Flags, generated/ als Binary-Include-Dir)?
7. **Verbote eingehalten:** modules/**, ext/**, cmake/**, .gitlab-ci.yml, abi_adapter.hpp, organ_for_search_algo.hpp, composed_*_search.hpp, observable_composed_container.hpp UNVERÄNDERT (git status). Traversal-Organe: NUR die letzte static_assert-Zeile geändert?
8. **Concept-Stärke:** BtreeOrderShape erzwingt kMaxKeys==2kT-1 usw.; CacheEnginePermutationStrategy deckt name/family_name/flag_suffix/enabled/axis_tag/family_id; AxisBase-Vererbung konsistent zum page_type-Muster.
9. **Runtime-Konsumenten von build_all_axis_levels:** finden sich Konsumenten, die bei 26 Levels BRECHEN (z.B. run_lazy_150 validate-Logik, profile_to_tree, csv/latex-Spalten aus AxisLevels)? Nur melden, nicht fixen.
10. **tests/unit/test_harness_compile.cpp + test_188_4bbV...:** kompilieren die transitiv die neue Kette (via iterator/abi_adapter→tier_to_organ_mapping→Stores→topics-Registries)? Fehlen dem 4bbV-/harness-Target dafür Include-Pfade (generated/)? (Nur prüfen ob CMake-Includes das hergeben — target_include_directories.)

Bericht: je Checkliste-Punkt 1-3 Sätze mit file:line-Beleg; dann BLOCKER/MAJOR/NIT-Liste; dann Verdikt.
