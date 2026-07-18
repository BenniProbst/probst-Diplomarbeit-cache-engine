# DOSSIER W2/F4 — HashProbeShape real: LF aus Shape (Organ) + Chaining-Vollausbau (Store⊕Organ⊕Concept⊕Walk)

Du bist der IMPLEMENTIERUNGS-Agent. Implementiere GENAU diesen Increment im Arbeitsbaum. NICHT committen/pushen/
builden (kein lokaler Compiler; statisch prüfen). Abschlussbericht: Datei-Liste + je Baustein 2-3 Sätze + Risiken.
Dies ist das TIEFSTE der 4 Familien-Increments (User-Entscheid R2: „Hash VOLL: open-addressing↔chaining SOFORT").

## 1) Repo/Stand/Kontext (alle file:line verifiziert auf HEAD `f31a5c4`)
C++23, GTest 1.15.2. #234-K hat gelegt: `topics/nodes/axis_hash_probe_shape/` (Strategien
`HashOaLf70(kLoad 7/10)|HashOaLf50(5/10)|HashOaLf90(9/10)|HashChaining(kOpenAddressing=false, kLoad 1/1)`);
`HashBucketPoolStore` = `template <typename Shape = HashOaLf70>` mit `static_assert(Shape::kOpenAddressing, ...)`-
Anker (`axes/lookup/composable/hash_bucket_pool_store.hpp:30`) — Shape-Konstanten werden noch NICHT gelesen;
Alias `HashSearchOrganShaped<Shape>` (`tier_to_organ_mapping.hpp:60`). Ist-Bausteine:
- Store (`hash_bucket_pool_store.hpp`): OA-Slot-Array `vector<Slot{key,val,SlotState}>`, mask_ (Power-of-2, Start 16),
  3-State-Tombstones, `hash_index(k)` PRIVAT mit kFibonacciMul (Store-seitige rehash-Redistribution = Präzedenz!),
  API = slot_is_empty/occupied/deleted, slot_key/value, occupied(), tombstones(), place_occupied, set_slot_value,
  mark_deleted, rehash(new_cap), clear().
- Organ (`hash_probe_traversal_organ.hpp`): Load-Trigger HART `:48-49`
  `if ((p.occupied() + p.tombstones()) * 10 >= p.bucket_count() * 7) p.rehash(p.bucket_count() * 2);`
  + Linear Probing insert/lookup/erase mit Tombstone-Reuse; `index_of<Pool>(k, cap)` public static.
- Concept (`hash_bucket_pool_concept.hpp:27-49`): verlangt die VOLLE OA-API (POD-frei, uint64-Keys).
- Hülle (`composed_hash_search.hpp:38-47`): `for_each_record(Sink)` = OA-Scan
  `for i<bucket_count: if slot_is_occupied → sink(key,value)` (DEG-1, exactly-once-Kontrakt).

## 2) SOLL — 5 Dateien
### (A) `hash_bucket_pool_store.hpp` — Shape-Konstanten re-exportieren + Chaining-Datenpfad
1. Re-Export (public, direkt nach kInitialCapacity):
   `static constexpr bool kOpenAddressing = Shape::kOpenAddressing;`
   `static constexpr int  kLoadNumerator = Shape::kLoadNumerator;`
   `static constexpr int  kLoadDenominator = Shape::kLoadDenominator;`
   Den 234-K-`static_assert(Shape::kOpenAddressing, ...)`-Anker ENTFERNEN (wird jetzt eingelöst).
2. Zwei Datenpfade OHNE Verhaltens-Drift für OA (Level-0 byte-identisch!):
   `struct OaData { std::vector<Slot> buckets; };`
   `struct ChainData { std::vector<std::size_t> heads; std::vector<ChainSlot> nodes; std::vector<std::size_t> free; };`
   (`ChainSlot{key,val,SlotState state,std::size_t next}`; `kNil = size_t max` als Ketten-Ende)
   `using storage_t = std::conditional_t<kOpenAddressing, OaData, ChainData>; storage_t st_;`
   — die BESTEHENDEN OA-Methoden arbeiten via `if constexpr (kOpenAddressing)` auf st_.buckets EXAKT wie heute
   (gleiche Reihenfolge/Buchung; Konstruktor initialisiert OA wie bisher bzw. chaining heads(kInitialCapacity, kNil)).
3. CHAINING-Substrat-API (nur sinnvoll definiert wenn !kOpenAddressing; `requires`-Methoden oder if-constexpr-Body):
   - `chain_head(bucket) const → size_t` (Knoten-Index/kNil), `node_next(node) const → size_t`
   - `slot_key/slot_value/set_slot_value/slot_is_occupied` KNOTEN-indexiert (Namen wiederverwendet — der
     Inspektions-Kontrakt bleibt einheitlich; slot_is_empty/deleted liefern chaining-seitig sinnvolle Werte:
     empty = Slot nicht live (Free-List), deleted = immer false — KEINE Tombstones bei chaining)
   - `node_slot_count() const → size_t` (Größe des Knoten-Arrays, für Diagnose/Walk)
   - `allocate_chained(bucket, k, v)` (Knoten aus free/append, state=Occupied, next=alter Head, heads[bucket]=neu, ++size_)
   - `unlink_erase(bucket, node, prev)` (prev==kNil → heads[bucket]=next(node), sonst next(prev)=next(node);
     Knoten state=Empty + in free; --size_) — Organ liefert prev aus seinem Walk (Navigation=Organ, Links=Substrat).
   - `rehash(new_bucket_count)`: heads auf new_count(kNil) + ALLE live-Knoten via hash_index(key)&new_mask neu
     an Ketten-Köpfe linken (Knoten-Array bleibt, nur next/heads neu — Präzedenz: OA-rehash ist auch Store-seitig).
   - `bucket_count()` = heads.size() (Power-of-2-Bedeutung bleibt); `occupied()` = live; `tombstones()` = 0.
   - `clear()`: heads auf kNil, nodes/free leeren, size_=0.
4. Banner-Kommentar: 2 Datenpfade + warum (Shape-Achse OA↔chaining, User R2), Task-Tag `#234-F4`.

### (B) `hash_probe_traversal_organ.hpp` — LF aus Pool + Chaining-Zweige
1. OA-Load-Trigger generalisieren (Zeile :48-49), EXAKT:
   `if ((p.occupied() + p.tombstones()) * static_cast<std::size_t>(Pool::kLoadDenominator) >=`
   `        p.bucket_count() * static_cast<std::size_t>(Pool::kLoadNumerator))`
   `    p.rehash(p.bucket_count() * 2);`
   Level-0-Beweispflicht im Kommentar: 7/10 ⇒ `*10 >= *7` = das alte Prädikat Term-für-Term.
2. insert_into/lookup_in/erase_from: `if constexpr (Pool::kOpenAddressing) { …bestehender Body… } else { …chaining… }`:
   - insert: Trigger wie (1) (chaining: occupied()*1 >= bucket_count()*1 ⇒ load 1.0; tombstones()==0);
     `b = index_of<Pool>(k, p.bucket_count())`; Walk `chain_head(b)`→`node_next` mit Key-Vergleich:
     Duplikat → `set_slot_value(node, v)`; Ende → `allocate_chained(b, k, v)`.
   - lookup: Walk, bei Key-Treffer `slot_value(node)`, sonst nullopt.
   - erase: Walk mit prev-Tracking; Treffer → `unlink_erase(b, node, prev)`, true; sonst false.
3. Concept `HashProbeTraversal` (in dieser Datei, :27-33) bleibt UNVERÄNDERT (insert_into/lookup_in/erase_from).
   Datei-Ende: ZUSÄTZLICHER Selbstbeweis `static_assert(HashProbeTraversal<HashProbeTraversalOrgan,
   HashBucketPoolStore<nodes::axis_hash_probe_shape::HashChaining>>);` (+Include des Strategie-Headers).

### (C) `hash_bucket_pool_concept.hpp` — Kern + 2 Zweige (bestehende Erfüller bleiben erfüllt)
`concept HashBucketPoolCore` = Typen/uint64 + bucket_count/occupied/tombstones/clear/rehash + die 3 Konstanten
(`{ S::kOpenAddressing } -> convertible_to<bool>` etc.). `concept HashBucketPoolOpenAddressing` = Core + volle
Slot-OA-API (heutiger Block) + `S::kOpenAddressing == true`. `concept HashBucketPoolChaining` = Core + chain-API
(A3) + `S::kOpenAddressing == false`. `concept HashBucketPool = HashBucketPoolOpenAddressing<S> ||
HashBucketPoolChaining<S>;` — Kommentar-Block entsprechend erweitern (Tombstone-Absatz bleibt für OA).

### (D) `composed_hash_search.hpp` — NUR for_each_record um chaining-Zweig
`if constexpr (Pool::kOpenAddressing) { …bestehender Scan… } else { für b<bucket_count: node=chain_head(b);
while node!=Pool::kNil: sink(slot_key,slot_value); ++visited; node=node_next(node); }` — exactly-once bleibt
(jeder live-Knoten hängt in GENAU einer Kette). Kommentar :36 um chaining-Reihenfolge ergänzen. SONST NICHTS.
(Pool::kNil: beim chaining-Store als public `static constexpr std::size_t kNil` definieren — Teil von (A).)

### (E) NEU `tests/unit/test_234_f4_hash_probe_shape.cpp` (gtest; Oracle-Muster = test_188_4bb0_...)
1. Konformität OaLf50 + OaLf90 + Chaining: `HashSearchOrganShaped<Shape>` paargenau vs `std::map<u64,u64>`
   (insert/update/lookup/erase/clear; weite Keys {0,7,65535,65536,1ull<<32,1ull<<40,UINT64_MAX} + ≥5000 random;
   `for_each_record` exactly-once via seen-Set; auch NACH clear() + Wieder-Befüllung).
2. LF-Wirkungs-Beweis: gleiche Insert-Zahl N=64 → `pool().bucket_count()` differiert zwischen Lf50 und Lf90
   (früherer vs späterer Rehash; konkrete Erwartungswerte im Test herleiten und asserten).
3. Chaining-Eigenschaften: `pool().tombstones()==0` IMMER (auch nach vielen erases); erase→insert-Zyklen
   recyceln Knoten (node_slot_count() wächst nicht unbegrenzt bei stabiler Live-Menge).
4. Level-0-Anker: `static_assert(std::is_same_v<HashSearchOrgan, HashSearchOrganShaped<HashOaLf70>>)` (zuerst
   prüfen ob wahr) + Lf70-Verhalten: bucket_count-Wachstumspunkte identisch zur Alt-Rechnung ((occ+tomb)*10>=cap*7).
5. Deutsche Banner, Task-Tag `#234-F4`.

## 3) Verbote/Constraints (STRIKT)
- NUR die 5 genannten Dateien. NICHT anfassen: CMakeLists (Root+tests — Registrierung macht der Integrator!),
  .gitlab-ci.yml, modules/**, ext/**, cmake/**, abi_adapter.hpp, organ_for_search_algo.hpp,
  observable_composed_container.hpp, tier_to_organ_mapping.hpp, topics/** (Strategie-Header fertig), andere
  composed_*/Organe/Stores/Tests.
- **Level-0/OA-Bit-Identität ist HARTES Gate:** für OA-Shapes sind Probe-Reihenfolge, Tombstone-Semantik,
  Rehash-Zeitpunkte (7/10) und Slot-Layout EXAKT wie heute; die conditional-storage-Umstellung darf die
  OA-Codepfade nur syntaktisch (st_.buckets statt buckets_) berühren.
- Keine Such-LOGIK in den Store verlagern (Navigation/Key-Vergleich/prev-Tracking = Organ; Slots/Links = Store).
- uint64-Key-Kontrakt + [[allocation-failure-exception]] (rehash/allocate dürfen werfen) beibehalten.

## 4) DoD + Bericht
5 Dateien; alle bestehenden static_asserts weiter erfüllt + neuer Chaining-Selbstbeweis; Test-Suite
`Comdare234F4HashProbeShape` ≥6 TESTs. Bericht: (i) die exakte neue Trigger-Zeile + Level-0-Termgleichheit;
(ii) chaining-Datenstruktur (heads/nodes/free, kNil) + warum for_each_record exactly-once bleibt; (iii) Concept-
Aufteilung und dass HashBucketPoolStore<HashOaLf70> den OA-Zweig weiter erfüllt; (iv) Risiken/Abweichungen —
falls eine beschriebene Ist-Signatur nicht stimmt, exakt benennen statt raten.
