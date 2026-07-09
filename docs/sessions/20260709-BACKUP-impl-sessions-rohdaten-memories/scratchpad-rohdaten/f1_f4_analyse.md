# F1-F4 Ist-Analyse (HEAD b8761f0, für die 4 W2-Dossiers) — 2026-07-02

Alle file:line gegen `git show b8761f0:libs/cache_engine/axes/lookup/composable/…` (stabil, unabhängig vom 234-K-Diff).
234-K-Ist (Codex-Zwischenstand): Strategie-Header heißen `axis_btree_order_kt{2,3,4,8,16}.hpp`,
`axis_skip_list_shape_max{16_p50,8_p50,32_p50,16_p25}.hpp`, `axis_bst_shape_ptr_{size_t,u32,u16}.hpp`,
`axis_hash_probe_shape_{oa_lf70,oa_lf50,oa_lf90,chaining}.hpp` unter `topics/nodes/axis_*/` (+registry/strategy_base/flags.in/concepts/).

## F1 BtreeOrder — NUR Store-Konsum, Organ propagiert schon
- `btree_traversal_organ.hpp` liest Pool::kT (:80/:138/:165/:195/:254) + Pool::kMaxKeys (:109/:281) ⇒ speist der
  Store kT/kMaxKeys/kMaxChildren aus Shape (macht 234-K §3D), variiert Split/Merge/Borrow AUTOMATISCH. KEINE Organ-Edits.
- Store `btree_node_pool_store.hpp`: Node = alignas(64) {int16 n; bool leaf; array<u64,kMaxKeys> key; array<u64,kMaxKeys> val;
  array<u32,kMaxChildren> child} (:89-95). kMaxKeys=2*kT-1, kMaxChildren=2*kT MÜSSEN abgeleitet bleiben (nicht 3 freie Konstanten).
- F1-Inhalt: Varianten-CMake-Level real aktivierbar; Test Shaped-Store kT∈{2,3,8,16} paargenau vs std::map (insert/erase/clear);
  observe-Hooks/Observer-Frage gegen 234-K-Endstand klären (observer_classification aktuell DefinitionOnly).
- Bit-Neutralität L0: kT=4 ⇒ kMaxKeys=7, kMaxChildren=8, alignas(64) unverändert, kNilU32-Semantik unverändert.

## F2 SkipListShape — REIN Store-seitig (Organ voll generisch)
- `skip_list_traversal_organ.hpp` nutzt `std::array<size_t, Pool::kMaxLevel>` (:40/:57/:97) + p.draw_level() (:64)
  + p.list_level() ⇒ kMaxLevel=8/32 propagiert automatisch. KEINE Organ-Edits.
- Store: kMaxLevel=16 (:32), Head-Init mit kMaxLevel Slots (:85-89), draw_level `while ((rng_() & 1u) != 0u && lvl < kMaxLevel)` (:56-60), Seed 0xC0FFEEu.
- ⚠️ BIT-TREUE P-Formel (Level 0 MUSS RNG-Konsum + Prädikat EXAKT reproduzieren):
  Original P=½: `(rng_() & 1u) != 0u` ≡ `(rng_() & (kPDen-1)) >= (kPDen - kPNum)` für kPNum=1,kPDen=2.
  Verallgemeinerung: `while ((rng_() & (Shape::kPDenominator - 1)) >= static_cast<unsigned>(Shape::kPDenominator - Shape::kPNumerator) && lvl < Shape::kMaxLevel)`.
  p25: kPNum=1,kPDen=4 ⇒ `(rng_()&3u) >= 3` = P(weiter)=¼. kPDen MUSS Power-of-2 (static_assert; kein Modulo-Bias).
  FALSCH wäre `% kPDen < kPNum` (invertiert das ½-Prädikat ⇒ andere Level-Sequenz ⇒ nicht bit-identisch).
- clear() resized Head auf nodes_[kHead].next (kMaxLevel-Slots) — bleibt korrekt, da Head mit Shape::kMaxLevel initialisiert.

## F3 BstShape — REIN Store-intern + kNil-Übersetzung
- `tree_traversal_organ.hpp` (BSTTraversalOrgan :30) konsumiert NUR root/left/right/node_key/node_value/allocate_node/
  free_node/set_* mit size_t-Außen-API + Pool::kNil ⇒ KEINE Organ-Edits.
- Index-Packing: Node{key,val, Shape::index_type left,right}; intern kNilInternal = numeric_limits<index_type>::max().
  Außen-API bleibt size_t; Pool::kNil bleibt size_t::max ⇒ Accessoren ÜBERSETZEN: `left(i) = (n==kNilInternal)? kNil : size_t(n)`;
  Setter: `set_left(i,c) = (c==kNil)? kNilInternal : index_type(c)` (+Range-Check). L0 (size_t): Übersetzung degeneriert
  zur Identität ⇒ bit-neutral.
- ⚠️ Kapazitätsgrenze: u16 ⇒ max 65534 Knoten (65535=kNil), u32 ⇒ ~4,29e9. Working-Set 131072 > u16-Grenze!
  ⇒ allocate_node bei Überlauf: [[allocation-failure-exception]]-Muster (throw std::bad_alloc/length_error, dokumentiert),
  NIEMALS still wrappen. Im Dossier als Mess-Design-Hinweis (u16-Level nur für kleine N sinnvoll).
- free_-Liste bleibt vector<size_t> (Außen-Indizes) — ok.

## F4 HashProbeShape — Store + Organ (tiefste)
- Load-Trigger liegt HART im Organ `hash_probe_traversal_organ.hpp:49`: `if ((p.occupied()+p.tombstones())*10 >= p.bucket_count()*7) p.rehash(2*cap)`.
- SAUBERSTE Generalisierung (Präzedenz Pool::kT beim BTree): Store re-exportiert Shape-Konstanten
  (`static constexpr int kLoadNumerator/kLoadDenominator; static constexpr bool kOpenAddressing`), Organ liest
  `(p.occupied()+p.tombstones()) * Pool::kLoadDenominator >= p.bucket_count() * Pool::kLoadNumerator`.
  L0 lf70: kLoadNum=7,kLoadDen=10 ⇒ `*10 >= *7` EXAKT Original (Faktoren-Seiten beachten!).
- lf50/lf90: 5/10 bzw. 9/10 (gleiche Den=10 ⇒ keine Überlauf-Sorge; size_t-Arithmetik).
- chaining (VOLL, User-R2): kOpenAddressing=false ⇒ if-constexpr-Zweige in Store UND Organ:
  Store-Zweig braucht Kollisionsketten (Slot{key,val,state,next-Index} ODER bucket-head + node-pool);
  Organ-Zweig: insert=head-insert/append + Duplikat-Update, lookup=Ketten-Walk, erase=unlink (KEINE Tombstones).
  Rehash-Trigger bei chaining üblich load=1.0 — Dossier-Entscheid: eigener kLoad je chaining-Strategie (z.B. 10/10).
  ComposedHashSearch<Organ,Pool>-Signatur + tier_to_organ_mapping-Default-Aliase UNVERÄNDERT (if-constexpr, kein 2. Organ-Slot).
- DEG-1-Kopplung: `for_each_record` (Hash: slot_is_occupied-Scan, 46e6ce6) muss im chaining-Zweig die Ketten walken
  (composed_hash_search.hpp anfassen? NEIN — for_each_record lebt im Composed*Search; prüfen ob es Pool-API-generisch
  ist oder OA-Annahmen trägt → beim F4-Dossier gegen composed_hash_search.hpp verifizieren).

## Gemeinsames (alle 4 Dossiers)
- Disjunkte Dateisätze je F (Parallel-Fanout): F1={btree_node_pool_store, axis_btree_order/*, CMake-Level-Optionen F1, test_f1}
  F2={skip_list_node_pool_store, axis_skip_list_shape/*, test_f2} F3={tree_node_pool_store, axis_bst_shape/*, test_f3}
  F4={hash_bucket_pool_store, hash_probe_traversal_organ, axis_hash_probe_shape/*, test_f4}. CMakeLists-Root = GETEILT
  ⇒ Konflikt-Punkt: Test-Target-Registrierung je F in EIGENEM Block; Integration sequenziell BTree→SkipList→BST→Hash durch Claude.
- Jeder F-Test: Shaped-Store via `*OrganShaped<Shape>`-Alias (234-K §3D) paargenau vs std::map<u64,u64> inkl. weiter Keys
  (4bb0-Muster) + for_each_record-exactly-once (4bbV-Muster) je Varianten-Level.
- Varianten-Levels bleiben Default-OFF; Tests kompilieren die Shapes DIREKT (Typ-Instanziierung, unabhängig von CMake-ON/OFF
  der Registry-Flags — Strategie-TYPEN existieren immer, nur registry-EnabledShapes filtert).
- Konformitäts-Gatter + is_original/ext/** tabu + kein abi_adapter-Touch gelten weiter.
