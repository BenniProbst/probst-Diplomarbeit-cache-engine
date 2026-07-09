# DOSSIER AP-7a/#241 — SwissTable-Baustein S22 (faithful + konform + golden-neutral registriert)

> Für Codex (`--sandbox workspace-write`, `model_reasoning_effort=xhigh`). Arbeite DIREKT als EIN
> Agent — KEINE Sub-Agenten/Orchestrator/collab-Route. Setze §6 vollständig um, halte §4 strikt ein,
> verifiziere §7 lokal (Kommandos + literale Ergebnisse), gib §8-Report aus. **NICHT committen, KEINE
> git-Operationen** — nur Dateien editieren; Claude reviewt jede Datei manuell + committet selbst.

## 1. Auftrag (eine Zeile)
Füge SwissTable als eigenen, faithful T0-Such-Baustein `S22` (`SwissTableSearchAlgo`, family_id 22)
hinzu, verifiziere ihn per Konformitätstest gegen std::map, und registriere ihn **golden-neutral**
(AllStrategies-END-Append + Default-OFF-Flag, exakt wie die per-K-Wrapper S18–S21).

## 2. Fachliche Substanz (SwissTable ≠ S14-Hash)
SwissTable (Google/abseil `raw_hash_set`, „Swiss Tables" CppCon 2017): offene Adressierung mit
**1 Control-Byte je Slot** (`kEmpty=0x80`, `kDeleted=0xFE`, sonst 7-Bit-H2-Fingerprint ∈ [0,127]),
**Gruppen von 16 Slots**, Hash-Split **H1** (obere Bits → Gruppen-Startposition) / **H2** (untere 7 Bit
→ Fingerprint), Gruppen-Probe scannt die 16 Control-Bytes gegen H2, Tombstone via `kDeleted`, Resize
bei Last-Grenze. DISTINKT von S14 (`HashSearchAlgo`: 1 Slot/Position, sequenzielles Linear-Probing,
3-Zustands-`SlotState`-Enum). Der S22-Wrapper trägt diese Mechanik FAITHFUL (Control-Bytes + Gruppen-
Probe), KEIN `std::unordered_map`/`SortedBinary`-Delegat.

## 3. Scope-Abgrenzung (HART)
- **IN (AP-7a, dieser Increment):** `SwissTableSearchAlgo`-Wrapper (eigene faithful insert/lookup/erase/
  clear-Logik) + Konformitätstest + golden-neutrale OFF-Registrierung (flags + CMake + AllStrategies-End-Append).
- **OUT (AP-7b, SEPARAT — im Code-Kommentar + Report als Voraussetzung-vor-Messung markieren):** das
  Weg-B-Pool-Organ `SwissTableOrgan` + `organ_for_search_algo<SwissTableSearchAlgo>`-Eintrag, das den
  ECHTEN Mess-Pfad treibt (analog `HashSearchAlgo→HashSearchOrgan`, `organ_for_search_algo.hpp:92-95`).
  OHNE AP-7b fiele S22 im Mess-Pfad auf den flachen SortedBinary-Fallback → würde NICHT als echte
  SwissTable gemessen. Deshalb bleibt das Flag OFF bis AP-7b (wie S18–S21: „bloße Registrierung baut nichts").
- **OUT:** SIMD-Gruppen-Probe (`_mm_cmpeq_epi8`) — nur **Scalar**-Gruppen-Probe in AP-7a
  (`supports_simd()=false`); SIMD als `// AP-7-Follow:` markieren.

## 4. HARTE Auflagen (Verstoß = Abbruch, Claude verwirft)
1. **ABI-NEUTRAL:** `COMDARE_ANATOMY_ABI_MAJOR` bleibt **4**. Der Such-Algo-Header inkludiert KEINE
   `abi/`-Header, kein `extern "C"`, kein `modules/**`. Mess-POD `SearchAlgoStatistics` wiederverwendet
   (nicht ändern). Ein neuer Wrapper = Compile-Time-Kompositions-Option → ABI-neutral.
2. **GOLDEN-NEUTRAL (kritisch, verifiziert):** Registrierung NUR als **END-Append** an `AllStrategies`
   in `axis_03a_search_algo_registry.hpp` (nach `KArySearchAlgoK16`, Z.83, vor `>;` Z.88) + **Default-OFF**-
   Flag. NIEMALS: bestehende `AllStrategies`-Reihenfolge umsortieren, einen der 4 aktiven (k_ary/
   interpolation/eytzinger/linear_scan) berühren, oder das Flag Default-ON setzen. Beleg dass korrekt:
   `EnabledStrategies = mp_filter<is_enabled>` (registry.hpp:93) filtert OFF heraus → `mp_take_c<…,4>`
   (golden-320-First-4) byte-identisch (exakt der S18–S21-Präzedenzfall, registry.hpp:73-83).
3. **TABU (nicht mutieren):** golden-`mp_list`-POPULATION (die aktivierten Strategien / First-4),
   `modules/**`, `ext/**`. `permutation_axes.xml` trägt KEINE search_algo-Achse → NICHT anfassen.
4. **Faithful, kein Surrogat:** echte Control-Byte-Metadaten + Gruppen-Probe. Fibonacci-Mix wie S14
   (`hash_search.hpp:190`) wiederverwendbar. `is_original=false` (CE-native Reimpl, kein ext-Wrap; Zitat korrekt).
5. **Concept-Pflicht** (sonst `SearchAlgoBase`-CTOR-`static_assert` schlägt fehl, `axis_03a_search_algo_base.hpp:31-36`):
   `SearchAlgoVariant` (`axis_03a_search_algo_concept.hpp:36-49`: key_type/value_type/size_type; insert(k,v)→void;
   erase(k)→bool; lookup(k)const→optional<value_type>; occupied_count()const noexcept; density_percent()const→double;
   clear()noexcept; + topic_tag) UND `CacheEngineSearchAlgoPermutationStrategy`
   (`…permutation_concept.hpp:58-92`: axis_tag, family_id, is_thread_safe, max_fanout, name/family_name/
   flag_suffix, supports_simd/supports_range_scan/is_dense/has_cache_line_alignment; + STATISTICS-Block wie S14).
   `hash_search.hpp` 1:1 als Struktur-Checkliste. `#217-2a`: **KEIN** `container_capacity()` (Hash = Advisory/unbounded).
6. **Klassifikation:** SwissTable = ungeordnete Pool-Familie → **NICHT** store-traversierbar. KEIN
   `axis_03a_store_traversable`-Marker setzen (fehlender Marker ⇒ konservativ false = korrekt). Ergänze
   in registry.hpp ein `static_assert(!composable::StoreTraversableSearchAlgo<SwissTableSearchAlgo>, "AP-7:
   SwissTable = Pool-Familie (Hash, ungeordnet) -> Weg-B (G3); Organ-Backing = AP-7b")` analog Z.127-128.
7. **Stil:** exakt `axis_03a_search_algo_hash_search.hpp` als Vorlage spiegeln (Aufbau/Kommentar-Dichte/Guards).
   Namespace `comdare::cache_engine::lookup`, C++23.

## 5. Kartierung (file:line — verifiziert Explore+Codex+Claude)
- **5.1 Vorlage S14:** `axis_03a_search_algo_hash_search.hpp` `class HashSearchAlgo` (:42). Properties
  :44-66 (enabled/key_type uint16/value_type uint64/axis_tag sparse_access_tag/family_id 14/is_thread_safe
  false/max_fanout 65536/name/family_name/flag_suffix "HASH_SEARCH"/supports_range_scan false/is_dense false).
  API insert:76 lookup:102 erase:127 occupied_count:148 density_percent:149 clear:150. STATISTICS :163-179.
  Interna: SlotState :182, Slot :183, hash_index(Fibonacci) :190, rehash :194. Guards :236-238.
- **5.2 Faithful (kein ext-Wrap):** kein abseil/swiss in ext/ vendored → CE-native Eigenimpl.
- **5.3 family_id 22 frei** (belegt 1–17; S18–S21=Labels mit family_id-Fallback auf 10). Vergabe rein
  Konvention im family_id-Kommentar + AllStrategies-Reihenfolge (`registry.hpp:52-88`).
- **5.4 Registrierung (3 Stellen):** (a) `axis_03a_search_algo_flags.hpp.in` — `#cmakedefine01`-Block (~:9-66)
  + `inline constexpr bool …_enabled` (~:68-89); (b) `CMakeLists.txt` — `option(...)` bei den anderen
  `COMDARE_AXIS_03A_ENABLE_*` (~:246-259) + **`SWISSTABLE` in die `foreach(_s03a …)`-Liste (~:852)** (sonst
  wird das USE-Makro nie gesetzt) + optional Message (~:891); (c) `axis_03a_search_algo_registry.hpp` —
  `#include` (~:35) + AllStrategies-END-Append (nach Z.83) + static_assert(!StoreTraversable) (bei Z.127).
  EXAKTE Zeilen selbst verifizieren (grep der Nachbar-Einträge, z.B. `KArySearchAlgoK16`, `hash_search_enabled`,
  `COMDARE_AXIS_03A_ENABLE_K_ARY`).
- **5.5 Concept/Klassifikation:** s. §4.5/§4.6. Weg-B (nicht store-traversierbar), Advisory-Kapazität.
- **5.6 ABI-Neutralität:** header-only Compile-Time-Typ; COMDARE_ANATOMY_ABI_MAJOR (modules/**, TABU)
  unberührt; SearchAlgoStatistics-POD unverändert; OFF-default ⇒ nicht in Golden-Binaries instanziiert.
- **5.7 Test-Vorlagen:** `tests/unit/support/std_map_equivalence_harness.hpp` `verify_matches_std_map<Wrapper>(key_mod,
  query_max)` (:29, 600-Op-Stream, occupied_count==ref.size()); Hash-Shape-Analogie `tests/unit/test_234_f4_hash_probe_shape.cpp`
  (:54 for_each vs std::map-Orakel, tombstones==0 nach clear); CMake-Muster `tests/unit/CMakeLists.txt:438-447`
  (comdare_add_test + Boost::mp11).

## 6. Soll-Umsetzung (konkret — 2 neu + 4 Edits)
1. **NEU** `libs/cache_engine/axes/lookup/axis_03a_search_algo_swisstable.hpp`: `class SwissTableSearchAlgo :
   public SearchAlgoBase<SwissTableSearchAlgo>`; Struktur 1:1 von hash_search.hpp; `enabled=flags::swisstable_enabled`;
   `key_type=uint16_t`(wie S14)/`value_type=uint64_t`; `axis_tag=subaxes::sparse_access_tag`; **`family_id=integral_constant<int,22>`**;
   `name()="swisstable"`, `family_name()="SwissTableSearchAlgo (Google Swiss Tables, CppCon 2017 / abseil raw_hash_set — CE-native Reimpl, is_original=false)"`, `flag_suffix()="SWISSTABLE"`;
   `is_thread_safe()=false`, `max_fanout()=65536`, `supports_simd()=false`, `supports_range_scan()=false`, `is_dense()=false`, `has_cache_line_alignment()=false`;
   STATISTICS-Block wie S14; faithful Kern: `std::vector<Slot>` + paralleles `std::vector<uint8_t> ctrl_`
   (1 Control-Byte/Slot), Gruppen à 16, H1/H2-Split, **Scalar**-Gruppen-Probe (16-Byte-Fingerprint-Schleife),
   Tombstone (kDeleted), Resize bei Last-Grenze; Fibonacci-Mix wie hash_search.hpp:190. Schluss-Guards
   `SearchAlgoVariant` + `CacheEngineSearchAlgoPermutationStrategy` (+ optional DensityClassifiedStrategy).
   Kopf-Kommentar: `// AP-7b: Weg-B-Organ (SwissTableOrgan) für den echten Mess-Pfad noch offen — bis dahin
   Flag Default-OFF (nur registriert/konform, wie S18–S21 per-K).`
2. **NEU** `tests/unit/test_ap7_swisstable.cpp`: `#include` + `verify_matches_std_map<SwissTableSearchAlgo>(100000u,2000u)`
   (Konformität) + ein Gruppen-Probe/H2-Shape-Test (analog test_234_f4: insert/update/lookup/erase/clear,
   occupied_count vs std::map-Orakel, nach clear leer). `COMDARE_MEASUREMENT_ON`-neutral (roher Wrapper, kein Adapter).
3. **Edit** `axis_03a_search_algo_flags.hpp.in`: `#cmakedefine01 COMDARE_AXIS_03A_USE_SWISSTABLE` (im cmakedefine-Block)
   + `inline constexpr bool swisstable_enabled = COMDARE_AXIS_03A_USE_SWISSTABLE;` (im enabled-Block), an der
   alphabetisch/muster-passenden Stelle neben `hash_search`.
4. **Edit** `CMakeLists.txt`: `option(COMDARE_AXIS_03A_ENABLE_SWISSTABLE "Search-Algo S22 SwissTable (Scalar-Gruppen-Probe, opt-in, AP-7a)" OFF)`
   bei den anderen ENABLE_*-Options + `SWISSTABLE` in die `foreach(_s03a …)`-Konfigurier-Liste + optional Message.
5. **Edit** `axis_03a_search_algo_registry.hpp`: `#include "axis_03a_search_algo_swisstable.hpp"` (bei den anderen
   Includes) + `SwissTableSearchAlgo // S22, Google Swiss Tables (CppCon 2017) — Control-Byte-Gruppen-Probe, Weg-B`
   als END-Append (nach `KArySearchAlgoK16`, vor `>;`) + `static_assert(!composable::StoreTraversableSearchAlgo<SwissTableSearchAlgo>, "...")` (bei Z.127-130).
6. **Edit** `tests/unit/CMakeLists.txt`: `comdare_add_test(test_ap7_swisstable SOURCES test_ap7_swisstable.cpp)`
   + `target_include_directories(...)` + `target_link_libraries(... Boost::mp11)` (Muster Z.438-447).

## 7. Verifikation (PFLICHT — Codex, Kommandos + literale Ergebnisse)
- Konfiguriere mit `-DCOMDARE_AXIS_03A_ENABLE_SWISSTABLE=ON` (damit der neue Baustein + Test kompiliert
  werden; Golden-320-Default bleibt OFF). Baue `test_ap7_swisstable` + einen bestehenden Registry-/Konformitäts-
  Test (z.B. `test_v41_axis_03a_cross_variant_equivalence` ODER `test_conformance_gate`) → beide grün (literal).
- Konformität: `test_ap7_swisstable` PASS (verify_matches_std_map + Shape). Golden-Neutralität: der bestehende
  Test bleibt grün bei Default-Konfig (Flag OFF) → EnabledStrategies unverändert. Kein Commit, keine git-Ops.

## 8. Ausgabe an Claude (strukturiert)
(a) neue+geänderte Dateien (Liste, je Datei was), (b) SwissTable-Kern-Mechanik (Control-Bytes/Gruppen/H1H2),
(c) ABI-Neutralität + Golden-Neutralität (Beleg: EnabledStrategies/First-4 unverändert, MAJOR 4, POD unberührt),
(d) exakte Registrierungs-Zeilen (file:line), (e) Compile-/Test-Ergebnisse literal, (f) AP-7b (Weg-B-Organ) +
SIMD explizit als offen markiert.
