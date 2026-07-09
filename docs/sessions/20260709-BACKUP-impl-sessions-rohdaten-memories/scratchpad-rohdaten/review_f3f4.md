# ADVERSARISCHER REVIEW #234-F3 + #234-F4 — BST-Kapazitätsschutz + Hash LF-aus-Shape/Chaining-Vollausbau

READ-ONLY, keine Edits. Prüfe im Arbeitsbaum (HEAD f31a5c4 + uncommittet) GENAU diese 7 Dateien:
F3: `libs/cache_engine/axes/lookup/composable/tree_node_pool_store.hpp` (Diff: length_error-Guard + Doku) +
`tests/unit/test_234_f3_bst_shape.cpp` (NEU).
F4: `hash_bucket_pool_store.hpp` (conditional_t OA/Chain-Datenpfade + Shape-Konstanten-Reexport) +
`hash_probe_traversal_organ.hpp` (Shape-LF-Trigger + chaining-Zweige) + `hash_bucket_pool_concept.hpp`
(Core+OA+Chaining-Union) + `composed_hash_search.hpp` (for_each_record chaining-Walk) +
`tests/unit/test_234_f4_hash_probe_shape.cpp` (NEU).
(Andere Baum-Änderungen = bereits separat reviewte Increments — ignorieren.)
Aktiv widerlegen. Verdikt: SHIP / SHIP-WITH-NITS / FIX (BLOCKER mit file:line).

## Prüf-Checkliste
1. **OA-Level-0-BIT-IDENTITÄT (härtestes Gate):** Für OA-Shapes (Lf70 Default) müssen Probe-Reihenfolge,
   Tombstone-Verbuchung, Rehash-ZEITPUNKTE und -Redistribution EXAKT dem alten Code entsprechen. Der neue
   Trigger `(occ+tomb)*kLoadDen >= cap*kLoadNum` mit 7/10: term-für-term == `*10 >= *7`? Die
   conditional_t-Umstellung (st_.buckets statt buckets_): rein syntaktisch? place_occupied/mark_deleted mit
   `requires (kOpenAddressing)` auf Member-Funktionen eines Klassen-Templates: g++-C++23-legal und für
   OA-Instanzen identisch nutzbar?
2. **Chaining-KORREKTHEIT:** insert (Duplikat-Walk→set_slot_value; sonst allocate_chained Kopf-Insert);
   erase (prev-Tracking, unlink_erase: heads/next-Umverkettung, Free-List, --size_); lookup-Walk;
   rehash (heads neu, nur Occupied-Nodes relinkt, Nodes-Array stabil — Achtung: `hash_index(key) & new_mask`
   nach `mask_ = new_mask` = doppelt maskiert, idempotent?); clear (heads=kNil, nodes/free leer).
   Kann ein Free-List-Knoten je in einer Kette hängen (state Empty + next=kNil gesetzt)?
   Load-Trigger chaining 1/1: rehash bei occupied>=bucket_count VOR dem Duplikat-Walk — kann ein reines
   Update dadurch unnötig rehashen, und ist das konsistent zum OA-Verhalten (dort trigger auch vor Probe)?
3. **for_each_record chaining:** exactly-once über heads+next; kein Besuch von Free-List-Knoten möglich?
   Rückgabe == occupied()?
4. **Concept-Union:** HashBucketPoolStore<HashOaLf70> erfüllt OpenAddressing-Zweig; <HashChaining> den
   Chaining-Zweig; die 3 Konstanten-Requirements im Core korrekt; KEINE bestehenden Erfüller gebrochen
   (das Organ + composed_hash_search + 4bb0/4bbV-Tests nutzen die API weiter)?
5. **F3:** Guard `if (idx >= static_cast<std::size_t>(kNilIndex)) throw std::length_error` NUR im
   Append-Zweig — korrekt (Free-List-Recycling ungeschützt ok)? Level-0 (size_t) verhaltensneutral?
   Test: U16-Overflow-Test füllt bis Store::kNilIndex exakt, wirft dann; Recycling-Beweis; Laufzeit ok?
6. **F4-Test:** LF-Wirkungs-Beweis (Lf50 vs Lf90 bucket_count nach N=64) — sind die ERWARTETEN Werte
   korrekt hergeleitet (Rehash-Kaskade nachrechnen!)? Chaining-Tests (tombstones==0 immer;
   node_slot_count wächst nicht unbegrenzt bei erase/insert-Zyklen) korrekt gegen die Implementierung?
   Konformitäts-Treiber paargenau inkl. for_each_record-exactly-once + clear+Wiederbefüllung?
   Alle genutzten APIs existieren (pool()-Getter, occupied_count, node_slot_count nur chaining)?
7. **Keine verbotenen Dateien:** abi_adapter/organ_for_search_algo/observable_composed_container/
   tier_to_organ_mapping/topics/** unangetastet durch F3/F4 (git status/diff)?
8. **CRLF:** die 4 F4-Header kamen mit CRLF (git normalisiert beim add) — enthält der Diff DARÜBER hinaus
   unbeabsichtigte Ganzzeilen-Rewrites oder Encoding-Schäden (Umlaute/⊕/→ in Kommentaren)?

Bericht: je Punkt 1-3 Sätze mit file:line; BLOCKER/MAJOR/NIT-Liste; Verdikt.
