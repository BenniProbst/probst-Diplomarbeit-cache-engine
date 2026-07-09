# DOSSIER #217-2a — Generische Container-Kapazitäts-Constraint + ehrlicher Guard (ABI-NEUTRAL)

> Für Codex (`--sandbox workspace-write`, `model_reasoning_effort=xhigh`). Implementiere GENAU
> den Scope unten. KEINE Änderung außerhalb der gelisteten Dateien. **NICHT committen, NICHT
> `git`-Operationen** — nur editieren; Claude reviewt jede Datei manuell + committet selbst.

## 1. Auftrag (eine Zeile)
Mache die Container-Kapazität EHRLICH: führe eine GENERISCHE, OPTIONALE Kapazitäts-Eigenschaft
(`max_fanout` verallgemeinernd) ein und erzwinge sie für Container mit HARTER statischer Kapazität
(Array256/Array65535) via Laufzeit-Guard in `tier_insert` (ehrliche Ablehnung statt stiller
Aufnahme) + `static_assert` (Compile-Time gegen künftigen Truncation-Wrap). Korrigiere die stale
„uint64-Organ-Invariante"-Kommentare. ALLES ABI-NEUTRAL.

## 2. Bindender User-Entscheid (Kontext, nicht verhandelbar)
- Array = spezieller Container STATISCHER Größe, ein **Container**, **KEINE neue Gattung**.
- Manche Container haben minimale/maximale Größen bzw. Füllmengen → **Kapazitäts-Constraint als
  (optionale) Container-Concept-Eigenschaft**, die `max_fanout` verallgemeinert (KEIN Array-Sonderfall).
- Key AUSSERHALB der deklarierten Kapazität = **ehrliche Limitierung** (Guard/Reject + Compile-Fehler
  wo statisch), **NIEMALS stille Trunkierung/Slot-Wrap**.

## 3. WICHTIGER IST-BEFUND (verifiziert 2026-07-03, Claude + Explore)
- **KEIN aktiver Trunkierungs-Bug** mehr: der trunkierende `search_organ_`-Pfad wurde mit #188-4c-iii
  entfernt; der Live-Datenpfad `tier_insert`→`container_algorithm_.insert` (abi_adapter.hpp:745) ist
  uint64-sauber (Beleg-Kommentar abi_adapter.hpp:1329-1330: Hot-Path :808/:866 trunciert nie).
- Die reale Unehrlichkeit = **`max_fanout` wird NIRGENDS erzwungen** (einzige Nutzung = die
  Concept-Existenz-Zeile) → ein Key jenseits der Kapazität wird STILL akzeptiert; Array65535 speichert
  faktisch uint64-Keys → sein Name ist unehrlich. 2a macht das ehrlich, ohne native Breite (=2b).

## 4. HARTE Auflagen (Verstoß = Abbruch, Claude verwirft)
1. **ABI-NEUTRAL:** `COMDARE_ANATOMY_ABI_MAJOR` bleibt **4** (eingefroren). NICHT ändern:
   - vtable `libs/cache_engine/anatomy/idriveable_tier.hpp:33-45` (tier_insert/lookup/erase/clear/size, uint64-only)
   - Mess-POD `libs/cache_engine/anatomy/observable_tier.hpp:127-147` (`ComdareTierObserverSnapshot`, standard_layout/trivially_copyable static_asserts)
   - extern-C `libs/cache_engine/include/cache_engine/abi/anatomy_module_abi_v1_decl.hpp:43-91` (Version/Magic/Factory)
   - `container_algorithm_` ist INTERNER privater Member (abi_adapter.hpp:1873) → Änderungen dort ABI-neutral.
2. **TABU (nicht editieren, nur lesen):** `modules/**`, `ext/**`, `axis_03a_search_algo_registry.hpp`
   (Golden-320 / Registry-`mp_list`), alle golden-Dateien. Die 2a-Constraint MUSS ohne Registry-Änderung
   auskommen (Default aus `max_fanout`).
3. **OPTIONAL, nicht Pflicht:** die neue Eigenschaft NIEMALS als hartes `requires` in ein Concept
   (`StorageOrgan`/`CacheEngineSearchAlgoPermutationStrategy`) aufnehmen — das bräche ALLE
   `static_assert(Concept)`-Selbstbeweise + Golden-320. Absente Eigenschaft ⇒ Default `Advisory`/unbounded.
4. **Static/Advisory-Split ZWINGEND:** nur `CapacityKind::Static` (Array256/Array65535, harte Array-Grenze)
   erzwingt den Guard. `Advisory` (vector/tree/hash/linear_scan/k_ary/skip_list/original_*) = heutige
   Semantik unverändert (deren `max_fanout` ist nur theoretisch). Ein pauschaler Guard über `max_fanout`
   wäre eine FUNKTIONALE REGRESSION.
5. **Kein Off-by-one:** Grenze ist `key >= max_size` (Array65535: reject ab 65536; Key 65535 BLEIBT gültig;
   Array256: reject ab 256; Key 255 gültig). test_v41_topic_traversal.cpp:241 (MaxDiscriminatorNoOutOfBounds)
   und test_188_4cii_flat_wrapper_traversal.cpp:85-98 MÜSSEN grün bleiben.
6. **Kanonische Kopie:** Concept-/Kommentar-Korrekturen an `axes/lookup/composable/*` (kanonisch), NICHT an
   der `topics/traversal/.../composable/*`-Re-Export-Hülle divergieren lassen.
7. **Stil:** umgebenden Code-Stil/Namens-/Kommentar-Dichte spiegeln. Namespace `comdare::*`, C++23,
   keine neuen externen Abhängigkeiten. `2b`-Auslassungen mit `// #217-2b:` markieren.

## 5. Kartierung (file:line, verifiziert)
- **5.1 Guard-Einfügepunkt:** `libs/cache_engine/anatomy/abi_adapter.hpp:733-745` `tier_insert(uint64 key,
  uint64 value)`; unmittelbar VOR `container_algorithm_.insert(key,value)` (Z.745). CoW-Block (Z.739,
  `#if COMDARE_MEASUREMENT_ON`) NICHT verschieben; der Guard gehört VOR CoW+insert (ein rejizierter Key
  darf keine CoW-Kopie auslösen).
- **5.2 SearchAlgo-Zugriff:** `SearchAlgo` ist ein im Adapter sichtbarer Typ-Alias (verwendet z.B.
  abi_adapter.hpp:1827/1840/1850). Die Kapazität gehört zum SearchAlgo (T0-Algorithmus), nicht zum Store.
- **5.3 `max_fanout`-Vorlage:** Concept-Existenz `axis_03a_search_algo_cache_engine_permutation_concept.hpp:64`
  (`{ S::max_fanout() } -> convertible_to<size_t>`). Werte: `axis_03a_search_algo_array256.hpp:56`=256,
  `axis_03a_search_algo_array65535.hpp:74`=65536 (+`kCapacity` :62). Dynamische (Advisory):
  vector_u8u8:74, vector_u16u16:56, linear_scan:55, k_ary:86/319, interpolation:62, hash_search:54,
  eytzinger:67, btree:61, bst:51, skip_list:68, original_*:59-77. **Enforcement heute: KEINE.**
- **5.4 Concept-Andockpunkt:** `libs/cache_engine/axes/lookup/composable/storage_organ_concept.hpp:29-47`
  (StorageOrgan; harte `same_as<uint64_t>`-Invariante :34-35 — BLEIBT in 2a) und
  `axis_03a_search_algo_cache_engine_permutation_concept.hpp:57-92` (wo `max_fanout`:64 lebt).
- **5.5 Stale Kommentare (nur Wortlaut korrigieren):**
  `direct_address_traversal_organ.hpp:44-46`, `observable_composed_search.hpp:33`,
  `observable_composed_container.hpp:58`, `composable_search.hpp:6-16`,
  `storage_organ_concept.hpp:34-35` (Constraint bleibt; Kommentar: „aktuelle Default-Breite, kein Verbot
  schmalerer Container — Lockerung = #217-2b"), Store-key_type-Kommentare
  `axis_04_node_type_layout_aware_store.hpp:24,73` (+ chunked:13,49 / composed:8,60 / slot:17,40 optional).
- **5.6 ABI-Naht-Beleg (NICHT ändern):** s. §4.1.
- **5.7 Betroffene Tests:** `tests/unit/test_v41_topic_traversal.cpp` (:91 max_fanout>0, :191 Array256=256,
  :228-230 Array65535=65536+kCapacity, :241-242 Grenzfall 65535), `tests/unit/test_188_4cii_flat_wrapper_traversal.cpp`
  (:71-75 static_asserts, :85-98 gappy in-range, :140 wide-uint64-Roundtrip),
  `tests/unit/test_188_4bb0_pool_organ_wide_key_conformance.cpp:72` (`static_assert key_type==uint64`).
  NEUER Test empfohlen (s. §6.4).
- **5.8 Cross-Check-Abgrenzungen (Codex+Explore, beide bestätigt):**
  - **ABGRENZUNG (kritisch):** Die neue Container-Kapazität verallgemeinert **`SearchAlgo::max_fanout()`**
    (Gesamt-Key-Raum des Such-Algorithmus) — NICHT `NodeTypeStrategy::max_capacity()`
    (`axis_04_node_type_concept.hpp:18`, Pro-Knoten-Format-Kapazität Node4=4/Node256=256) und NICHT die
    strukturellen kMaxKeys/kMaxChildren/kLoad*/kMaxLevel. Diese sind ORTHOGONAL → NICHT zusammenführen,
    NICHT die node_type-`max_capacity()` anfassen.
  - **VERWANDT, ABER OUT-OF-SCOPE (nur im Report FLAGGEN, NICHT fixen):** ungeguardeter Narrow-Cast im
    Mapping-Observer-Seitenpfad `abi_adapter.hpp:762` + `:831`
    (`static_cast<Composition::mapping::slot_index_type>(key)`, `slot_index_type=std::uint16_t` in
    `axis_03m_mapping_direct_placement.hpp:40` / `axis_03m_mapping_pool_relative.hpp:45`). Das ist der
    MAPPING-Achsen-Slot-Index (Observer/`#if COMDARE_MEASUREMENT_ON`), NICHT die Container-Key-Kapazität —
    separater latenter Befund, im 8-Punkte-Report als Follow-up notieren.

## 6. Soll-Umsetzung (konkret)
**6.1 Neuer Header** `libs/cache_engine/axes/lookup/composable/capacity_constraint.hpp` (Namespace
  `comdare::cache_engine::lookup::composable`):
  - `enum class CapacityKind { Advisory, Static };`
  - `struct CapacityConstraint { std::uint64_t min_fill = 0; std::uint64_t max_size = 0; CapacityKind kind = CapacityKind::Advisory; };`
    (`max_size==0` ⇒ unbounded/kein Guard.) `static_assert(std::is_standard_layout_v<CapacityConstraint>);`
  - Trait `template<class T> consteval CapacityConstraint capacity_constraint_of() noexcept` — wenn
    `requires { T::container_capacity(); }` → `T::container_capacity()`, sonst
    `{0, (requires{T::max_fanout();} ? 0 : 0), CapacityKind::Advisory}` (Default: Advisory, unbounded;
    `max_fanout` NICHT automatisch als Static behandeln — nur explizit deklarierte Static gilt).
**6.2 Array-Container** (`axis_03a_search_algo_array256.hpp`, `axis_03a_search_algo_array65535.hpp`):
  je eine `static constexpr CapacityConstraint container_capacity() noexcept { return {0, kCapacity_bzw_256,
  CapacityKind::Static }; }` ergänzen (Array256: max_size=256; Array65535: max_size=kCapacity=65536).
  `#include` des neuen Headers. `static_assert(<max_size-1 in key_type darstellbar>)` als Compile-Time-
  Ehrlichkeit (Array256 uint8: 255 ok; Array65535 uint16: 65535 ok).
**6.3 Guard in `abi_adapter.hpp` `tier_insert`** (vor Z.739 CoW):
  ```cpp
  if constexpr (constexpr auto cap =
                    ::comdare::cache_engine::lookup::composable::capacity_constraint_of<SearchAlgo>();
                cap.kind == ::comdare::cache_engine::lookup::composable::CapacityKind::Static
                    && cap.max_size != 0) {
      if (key >= cap.max_size) return false;  // #217-2a: ehrliche Kapazitäts-Ablehnung (kein stiller Slot-Wrap)
  }
  ```
  (Exakte Namespaces/Aliase an den Adapter anpassen. `if constexpr` mit init-statement ist C++23-ok; falls
  Stil-Konflikt, `constexpr auto cap = …;` als eigene Zeile davor + `if constexpr (cap.kind==Static && ...)`.)
**6.4 Neuer Test** `tests/unit/test_217_2a_capacity_guard.cpp` (in `tests/unit/CMakeLists.txt` registrieren,
  Muster eines bestehenden kleinen Unit-Tests spiegeln): Array65535 akzeptiert Key 65535, lehnt 65536/1e9 ab
  (tier_insert→false + Größe unverändert); Array256 akzeptiert 255, lehnt 256 ab; ein Advisory-Container
  (z.B. linear_scan/vector) akzeptiert einen großen Key UNVERÄNDERT (kein Guard). `capacity_constraint_of`
  liefert für Array Static+korrekte max_size, für Advisory-Container Advisory.
**6.5 Kommentar-Korrekturen** (§5.5) — nur Wortlaut, Semantik unverändert; `// #217-2b:`-Marker an
  `storage_organ_concept.hpp:34` (Lockerung same_as→unsigned_integral = 2b) und an den Wrapper-`key_type`.
**BEWUSST 2b (NICHT anfassen):** Lockerung `storage_organ_concept.hpp:34` `same_as<uint64_t>`→`unsigned_integral`;
  native Key-Breite durch LayoutAwareChunkedStore/DirectAddressTraversal/ObservableComposedSearch;
  Wrapper-`key_type`-Umbau (array256:48/array65535:66); Guard in `tier_lookup` (2a nur insert-seitig,
  da lookup eines Out-of-Cap-Keys ohnehin „nicht gefunden" liefert — im Report vermerken, nicht umsetzen).

## 7. Verifikation (PFLICHT — Codex führt lokal aus, nennt Kommandos + literale Ergebnisse)
- Compile die betroffene Lib + neuen Test (Linux g++ falls verfügbar, sonst der vorhandene Build). Nenne die
  cmake-Targets + Exit-Status.
- Baue+laufe: den neuen `test_217_2a_capacity_guard` UND `test_v41_topic_traversal` UND
  `test_188_4cii_flat_wrapper_traversal` — alle müssen PASS sein (Belege literal).
- Kein Commit, keine git-Operation.

## 8. Ausgabe an Claude (strukturiert)
(a) geänderte + neue Dateien (Liste, je Datei was), (b) exakte Guard-Wirkung + wo Static vs Advisory greift,
(c) ABI-Neutralitäts-Beleg (welche vtable/POD/extern-C-Signaturen NACHWEISLICH unverändert), (d) Compile-/
Test-Ergebnisse literal, (e) was für 2b offen bleibt. Keine Prosa-Einleitung.
