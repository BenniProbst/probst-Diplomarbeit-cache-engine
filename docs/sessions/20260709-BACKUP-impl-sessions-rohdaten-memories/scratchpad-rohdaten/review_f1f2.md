# ADVERSARISCHER REVIEW #234-F1 + #234-F2 — SkipList-P-Verallgemeinerung + 2 neue Shape-Konformitäts-Tests

READ-ONLY, keine Edits. Prüfe im Arbeitsbaum (HEAD f31a5c4 + uncommittete Änderungen) GENAU diese 3 Dateien:
1. `libs/cache_engine/axes/lookup/composable/skip_list_node_pool_store.hpp` (Diff: draw_level Shape-P-Maskenformel + 2 static_asserts + Kommentare)
2. `tests/unit/test_234_f2_skip_list_shape.cpp` (NEU, gtest)
3. `tests/unit/test_234_f1_btree_order_shape.cpp` (NEU, gtest)
(Ignoriere ALLE anderen Änderungen im Baum — tree_node_pool_store/hash_* gehören zu getrennten, noch laufenden Increments.)
Versuche aktiv zu widerlegen. Verdikt: SHIP / SHIP-WITH-NITS / FIX (BLOCKER mit file:line).

## Ansprüche (zu verifizieren)
- **F2-Store BIT-TREUE:** neue Ziehung `while ((rng_() & (u64(kPDen)-1)) >= u64(kPDen - kPNum) && lvl < kMaxLevel)`
  muss für kPNum=1/kPDen=2 DRAW-FÜR-DRAW dem alten `while ((rng_() & 1u) != 0u && lvl < kMaxLevel)` entsprechen
  (gleicher RNG-Konsum, gleiches Prädikat). Prüfe die Arithmetik + Integer-Promotionen exakt. Prüfe auch p25
  (kPNum=1,kPDen=4): P(weiter)=P(draw&3 >= 3)=1/4 korrekt? Sonst NICHTS am Store verändert (allocate_node/clear/
  init_head/Seed byte-identisch)?
- **F2-Test:** Alt-Referenz-Nachbau korrekt (mt19937_64(0xC0FFEEu), gleiche Konsum-Reihenfolge wie draw_level)?
  Statistik-Toleranzen nicht-flaky (100k draws, ±0.02 bei p=0.25 / ±0.01 bei 0.0625)? Konformitäts-Treiber
  paargenau (occupied_count-Invarianten, erase-Rückgaben, for_each_record exactly-once, clear+Wiederbefüllung)?
  Alle genutzten APIs existieren (ComposedSkipListSearch: insert/lookup/erase/occupied_count/clear/for_each_record;
  SkipListNodePoolStore<Shape>::draw_level public)?
- **F1-Test:** static_asserts (kMaxKeys 3/5/15/31; Alias-Identität BTreeSearchOrgan==Shaped<Kt4>) korrekt?
  count_reachable_nodes: terminiert (kNil/leaf), Zyklus-geschützt (seen), B-Baum-Invariante (innere Knoten n+1
  Kinder != kNil) korrekt gegen die BTreeNodePoolStore-API (root/node_n/node_leaf/node_child_at via pool())?
  Ist EXPECT_GT(kt2_nodes, kt16_nodes) bei 200 distinkten Keys MATHEMATISCH sicher (kein flakiness)?
  Konformitäts-Treiber paargenau; alle APIs real (ComposedBTreeSearch occupied_count()==pool_.size(), pool() const)?
- **Isolation:** beide Tests kompilieren flag-unabhängig (nutzen Strategie-TYPEN direkt, nicht Registry-EnabledShapes)?
  Include-Pfade lösbar über den 4bb0-Include-Satz (libs/cache_engine + include + src + generated + per-axis-dirs)?
- **Gefahren:** UB/Overflow in Testhelfern; nicht-deterministische Seeds; versteckte Abhängigkeit auf
  COMDARE_MEASUREMENT_ON o.ä. Defines (Tests werden OHNE die Mess-Defines gebaut — comdare_add_test-Standard)?
  → Falls einer der Composed-Header unter fehlendem Define anders aussieht, melden.

Bericht: je Anspruch 1-2 Sätze mit file:line; BLOCKER/MAJOR/NIT; Verdikt.
