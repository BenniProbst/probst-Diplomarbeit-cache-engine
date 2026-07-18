# DOSSIER #188-4a — EytzingerSearchAlgo store-traversierbar via organ_for (Option b)

**Für: codex exec (workspace-write) im Repo `comdare-cache-engine` (HEAD `9b52186`).**
**Increment-Ziel:** Die Eytzinger-T0-Messung läuft über die EINE reale Organ-Struktur (`container_` authoritativ)
statt über `search_organ_` + SortedBinary-Spiegel — als **10. organ_for-Familie** nach dem exakten Muster der
4 CE-Pool-Familien (BST/SkipList/Hash/BTree). **KEINE Verhaltensänderung an irgendeinem anderen Algo.**

---

## 0. BINDENDE ENTSCHEIDE + TABUS (zuerst lesen)

1. **USER-ENTSCHEID OPTION (b), FIX:** Mutations-Strategie = sortierte Basis + lazy Rebuild des BFS-Layouts
   über ein `dirty_`-Flag (die HEUTIGE Mechanik aus `libs/cache_engine/axes/lookup/axis_03a_search_algo_eytzinger.hpp:87-98,186-202`).
   KEIN inkrementelles BFS-Pflegen, KEIN separater nur-BFS-Store, KEINE Rebuild-Vermeidungs-Optimierung.
   Die Rebuild-Kosten stecken bewusst im ERSTEN Lookup nach einer Mutation und werden als Mess-Eigenschaft
   in Kommentaren DOKUMENTIERT. („Kein eigener BFS-Layout-Store" heißt: kein ZWEITER Speicher-Apparat, der
   NUR das BFS-Layout hält und gepflegt wird. Der EINE neue Store unten hält Primärzustand UND abgeleiteten
   Puffer zusammen — das IST Option b in Store-Form.)
2. **Integrations-Weg = organ_for (Integrator-Entscheid, beide Recherchen konvergent):** Eytzinger wird über
   `organ_for_search_algo<EytzingerSearchAlgo>` eingehängt (wie die 9 Pool-Familien). **NICHT** über den
   `axis_03a_store_traversable`-Marker / `traversal_for_search_algo` (der flat-Pfad hardcodet
   `LayoutAwareChunkedStore`, `abi_adapter.hpp:1934-1938` — dort KEINE Weiche einbauen!).
3. **abi_adapter.hpp: NULL Struktur-Änderungen.** Der Flip passiert AUTOMATISCH über die bestehenden Weichen
   (`pool_family_` Z.1943-1944 → `container_t` Z.1948-1952 → `container_is_authoritative_` Z.1957-1958).
   Erlaubt sind AUSSCHLIESSLICH die in §6 exakt benannten Kommentar-Wahrheits-Fixes (Zeilen dort).
4. **TABU (nicht anfassen):** `modules/**` (Submodule-Spiegel), `ext/**`,
   `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` + `gen_golden_fullpilot.cpp` (golden frozen —
   Eytzinger-binary_ids hängen nur an `name()=="eytzinger"` + Achsenpfad und bleiben textuell identisch),
   die `AllStrategies`-mp_list-Struktur/-Reihenfolge in `axis_03a_search_algo_registry.hpp:52-88`
   (First-4 = k_ary/interpolation/eytzinger/linear_scan ist golden-relevant), CMakeLists.txt und
   `.gitlab-ci.yml` (**CMake-/CI-Registrierung macht der Integrator — bewusste Arbeitsteilung, im Review
   NICHT als fehlend melden**).
5. **Der u16-Wrapper `EytzingerSearchAlgo` bleibt UNVERÄNDERT in Datenhaltung/Verhalten** (er bleibt
   Registry-Tier, Äquivalenz-Referenz und `search_organ_`-Member). Nur sein Doku-Kommentar Z.54-57 wird
   aktualisiert (§6). KEIN `axis_03a_store_traversable`-Marker am Wrapper (der Registry-static_assert
   `axis_03a_search_algo_registry.hpp:116-117` prüft `!StoreTraversableSearchAlgo<EytzingerSearchAlgo>` und
   MUSS wahr bleiben).
6. Kein Runtime-Switch; alles compile-time (MP11/Templates). C++23. Namespace
   `comdare::cache_engine::lookup::composable`. Kommentar-Stil/-Dichte der Nachbar-Dateien spiegeln
   (deutsche Fach-Kommentare, @topic/@achse-Kopf, Increment-Tag `#188-4a (2026-07-02)`).

## 1. IST-Zustand (verifiziert, als Fundament)

- `EytzingerSearchAlgo` (`axes/lookup/axis_03a_search_algo_eytzinger.hpp`): Primärzustand `keys_/values_`
  sortiert (u16/u64, Z.204-205), abgeleitet `mutable eyt_keys_/eyt_vals_` 1-indexed BFS (Z.206-207),
  `mutable dirty_` (Z.208). insert Z.89-104 (lower_bound + dirty), lookup Z.107-129 (lazy rebuild + branch-free),
  erase Z.131-143, clear Z.149-155, `rebuild_eytzinger()/fill_eytzinger` Z.186-202 (in-order-Fill des
  impliziten Baums). KEIN scan-Member, KEIN save_state/for_each_record.
- 3-Wege-Split (`axes/lookup/composable/organ_for_search_algo.hpp:19-26`): (1) Such-Methoden mit
  faithful-Traversal via `traversal_for_search_algo`; (2) 9 Pool-Familien via `organ_for_search_algo`;
  (3) markerlose Flach-Gruppe (Array256/Vector*/Array65535/**Eytzinger**/Masstree) = void in BEIDEN.
- abi_adapter-Weichen: `container_traversal_t` Z.1929-1932; `flat_container_t` Z.1934-1938; `pool_family_`
  Z.1943-1944 (`organ_for_search_algo_t != void`); `container_t` Z.1948-1952; `container_is_authoritative_`
  Z.1957-1958. Datenpfade: tier_insert Z.736-832 (else-Zweig Z.755-760 = Doppelbuchung search_organ_+Spiegel),
  tier_lookup Z.834-847, tier_erase Z.888-894, T0-Stats Z.1004-1013, Key-Ernte `fill_segment_timing_v3`
  Z.1298-1328 (**Eytzinger fällt HEUTE auf `keys={0}` Z.1327-1328 — einziger golden-320-Algo mit dieser
  Degeneration; der Flip + `for_each_record` behebt das über Zweig 2 Z.1308-1315**),
  `tier_search_routes_through_store()` Z.1771-1777.
- `ObservableComposedContainer<Container>` (`observable_composed_container.hpp:39-115`) fordert vom Organ:
  `key_type/value_type` (u64-Invariante Z.42), `insert(k,v)` void, `lookup(k) const → std::optional`,
  `erase(k) → bool`, `clear() noexcept`, `occupied_count() const noexcept`, default-konstruierbar; optional
  `for_each_record(sink)` (requires-gated Z.90-94). Statistik/CoW liegt in der Hülle, NICHT im Organ.
- Kanonische Organ-Vorlage: `composed_tree_search.hpp:21-60` (insert/lookup/erase delegieren an statisches
  Traversal; `for_each_record` Z.37-54 mit Doku „besucht JEDEN Record GENAU EINMAL … Reihenfolge
  familien-spezifisch, NICHT vertraglich; reines Lesen; Rückgabe == occupied_count()"). Traversal-Vorlage
  (Sortier-Pflege): `SortedBinaryTraversal` (`composable_search.hpp:128-178`). Aliase-Vorlage:
  `tier_to_organ_mapping.hpp:39-54` + Observable-Block `:88-105`. organ_for-Spezialisierungs-Muster:
  `organ_for_search_algo.hpp:71-106` + static_asserts `:112-138`.

## 2. NEU: `eytzinger_layout_store.hpp` (Store — Primärzustand + abgeleiteter Puffer in EINEM Apparat)

Pfad: `libs/cache_engine/axes/lookup/composable/eytzinger_layout_store.hpp`. Klasse `EytzingerLayoutStore`.

- `using key_type = std::uint64_t; using value_type = std::uint64_t;` (Organ-Invariante).
- Primärzustand: `std::vector<key_type> keys_; std::vector<value_type> values_;` — SORTIERT-aufsteigend
  gehalten (die Sortier-Invariante pflegt das Traversal-Organ, wie bei SortedBinary/RawSlotStore-Split).
- Abgeleiteter Zustand: `mutable std::vector<key_type> eyt_keys_; mutable std::vector<value_type> eyt_vals_;
  mutable bool dirty_ = false;` — 1-indexed BFS-Layout, EXAKT die Mechanik des Wrappers.
- **Slot-API (Primärzustand; Signaturen wie `RawSlotStore`, `composable_search.hpp:42-51`):**
  `slot_count() const noexcept`, `key_at(i) const noexcept`, `value_at(i) const noexcept`,
  `set_value_at(i,v) noexcept`→**setzt `dirty_=true`**, `insert_slot_at(i,k,v)`→**dirty_=true**,
  `erase_slot_at(i)`→**dirty_=true**, `append_slot(k,v)`→**dirty_=true**, `clear() noexcept` (leert ALLE
  4 Vektoren + `dirty_=true`, Vorlage Wrapper Z.149-155). **Jede Mutations-API invalidiert intern selbst**
  (kein vergessbares externes mark_dirty; Kohärenz per Konstruktion).
  Hinweis: `set_value_at` MUSS invalidieren (der Wrapper setzt auch beim Update dirty, Z.93 „Layout-Werte
  aendern sich -> dirty"); noexcept dabei beibehalten (bool-Set wirft nicht).
- **BFS-API (abgeleiteter Zustand):** `rebuild_if_dirty() const` — wenn `dirty_`: `eyt_keys_.assign(n+1, key_type{})`,
  `eyt_vals_.assign(n+1, value_type{})`, rekursives in-order-Fill EXAKT wie Wrapper Z.186-202
  (`fill(1,n,pos)`: erst `fill(2k)`, dann `eyt[k]=keys_[pos]; ++pos`, dann `fill(2k+1)`), danach `dirty_=false`.
  Plus `eyt_key_at(std::size_t k) const noexcept`, `eyt_value_at(std::size_t k) const noexcept`,
  `dirty() const noexcept` (für Tests/Doku). std::bad_alloc-Möglichkeit dokumentieren
  ([[allocation-failure-exception]]-Konvention wie Wrapper Z.28-29,88).
- **Doku-Kommentar (PFLICHT, Mess-Eigenschaft):** „Option (b) (User-Entscheid 2026-07-02): sortierte Basis =
  Quelle der Wahrheit; BFS-Layout lazy im ersten lookup nach Mutation neu gebaut (O(n) assign + rekursives
  Fill). Diese Rebuild-Kosten sind eine DOKUMENTIERTE Mess-Eigenschaft des Eytzinger-Tiers (erster Lookup
  nach Mutations-Burst trägt den Rebuild), NICHT wegzuoptimieren. Kein thread-safe const-lookup
  (mutable-Rebuild; is_thread_safe()==false wie der Wrapper)."
- Kopierbar/movebar per Default (Vektoren + bool — Memento-Pfad `abi_adapter.hpp:1670-1673` nutzt Copy;
  eine dirty-Kopie rebuildert selbständig beim nächsten Lookup: kurz dokumentieren).
- KEINE Statistik-Member (liegt in ObservableComposedContainer), KEIN Shape-Template-Parameter (bewusst —
  Shape-Achsen sind #234-Terrain der Pool-Familien, hier Nicht-Ziel).

## 3. NEU: `eytzinger_traversal_organ.hpp` (stateless Traversal-Organ)

Klasse `EytzingerTraversalOrgan` (struct, nur statische Template-Methoden — Organ, kein Tier;
Vorlage `tree_traversal_organ.hpp`-Stil + `SortedBinaryTraversal`-Logik):

- `insert_into<Pool>(Pool& p, k, v)`: lower_bound über `p.key_at(i)` (binäre Suche identisch
  `SortedBinaryTraversal::lower_bound_index`, `composable_search.hpp:129-140`); Treffer → `p.set_value_at(i,v)`
  (Update), sonst `p.insert_slot_at(i,k,v)`. (Invalidierung macht der Store intern.)
- `lookup_in<Pool>(Pool const& p, k) → std::optional<value_type>`: `p.rebuild_if_dirty();` dann der
  branch-free Kern **BIT-IDENTISCH** zum Wrapper Z.109-118 (nur über die Pool-API):
  `n = p.slot_count(); if (n==0) return nullopt; std::size_t j = 1; while (j <= n) j = 2*j + (p.eyt_key_at(j) < k ? 1u : 0u);
  std::size_t const idx = j >> (static_cast<unsigned>(std::countr_one(j)) + 1u);
  if (idx >= 1 && idx <= n && p.eyt_key_at(idx) == k) return p.eyt_value_at(idx); return nullopt;`
  (`<bit>` inkludieren). Kommentar: Khuong/Morin JEA 2017-Referenz wie Wrapper-Kopf Z.7-19 kurz zitieren +
  „lookup trägt ggf. den lazy Rebuild (Option b, Mess-Eigenschaft)".
- `erase_from<Pool>(Pool& p, k) → bool`: lower_bound; Treffer → `p.erase_slot_at(i); return true;` sonst false.
- KEIN scan_into nötig (tier_scan-Verhalten der organ_for-Familien bleibt Status quo — NICHT anfassen;
  siehe §7 Verifikationspunkt V6).

## 4. NEU: `composed_eytzinger_search.hpp` + `eytzinger_layout_pool_concept.hpp`

- **Concept-Datei** `eytzinger_layout_pool_concept.hpp` (Vorlage `tree_node_pool_concept.hpp`-Aufbau):
  `template<class P> concept EytzingerLayoutPool = requires(...)` über die KOMPLETTE in §2 definierte API
  (key_type/value_type-u64-Anforderung via `std::same_as`; Slot-API; rebuild_if_dirty/eyt_key_at/
  eyt_value_at/dirty; clear). Plus `template<class T, class P> concept EytzingerTraversalOrganConcept`
  (insert_into/lookup_in/erase_from — Muster `TreeTraversalOrgan` in `tree_node_pool_concept.hpp`).
  Selbstbeweis-static_asserts am Ende der Store-/Organ-Datei ODER hier (Muster „Vertrag == Ist-Implementierung,
  keine erfundene Abstraktion", `composable_search.hpp:239-247`).
- **Composed-Datei** `composed_eytzinger_search.hpp`: `template<class Traversal, class Pool> requires
  EytzingerTraversalOrganConcept<Traversal,Pool> class ComposedEytzingerSearch` — EXAKT das
  `composed_tree_search.hpp:21-60`-Muster: `key_type/value_type` aus Pool; `insert/lookup/erase` delegieren
  statisch; `occupied_count() = pool_.slot_count()`; `clear()`; `pool() const`;
  **`for_each_record(Sink&&) const`**: einfacher Index-Walk `for i in [0,slot_count): sink(key_at(i),
  value_at(i))`, Rückgabe = Anzahl (Doku wie composed_tree_search.hpp:34-36: „besucht JEDEN Record GENAU
  EINMAL … Reihenfolge hier: aufsteigende Key-Reihenfolge (sortierter Primärzustand), NICHT vertraglich;
  reines Lesen, KEIN Rebuild-Trigger, KEIN Statistik-Effekt"). Kopierbar per Default.

## 5. VERDRAHTUNG (bestehende Dateien, minimal-additiv)

1. `tier_to_organ_mapping.hpp`: Include der neuen Composed-Datei (Muster Z.19-32); im Organ-Block (nach
   BTree, Z.54) `using EytzingerOrgan = ComposedEytzingerSearch<EytzingerTraversalOrgan, EytzingerLayoutStore>;`
   mit #188-4a-Kommentar (Option b, 10. organ_for-Familie, KEIN Pool — Layout-Familie); im Observable-Block
   (bei Z.94-105) `using ObservableEytzingerOrgan = ObservableComposedContainer<EytzingerOrgan>;`.
2. `organ_for_search_algo.hpp`: Fwd-Decl `class EytzingerSearchAlgo; // S12 Eytzinger (Khuong/Morin JEA 2017)`
   im Fwd-Block (Z.45-53); Spezialisierung nach BTree (Muster Z.103-106):
   `template <> struct organ_for_search_algo<::comdare::cache_engine::lookup::EytzingerSearchAlgo> { using type = EytzingerOrgan; };`
   plus static_assert (Muster Z.136-138). **Header-Doku Z.6-26 + Primär-Kommentar Z.60-63 AKTUALISIEREN:**
   Gruppe (2) = „organ-backed Familien: 9 Pool-Familien + Eytzinger-Layout-Familie (#188-4a: flach-sortierter
   Primärzustand + abgeleiteter BFS-Puffer in EINEM Store, Option b)"; Eytzinger aus Gruppe (3) streichen;
   die „9"-Zählungen auf 10 heben, wo sie die organ-gemappte Menge meinen (Z.19, Z.41-44-Kommentar).
   Die Disjunktheits-Asserts Z.140-161 bleiben gültig (Eytzinger: traversal_for bleibt void) — optional
   einen Eytzinger-Assert ergänzen: organ_for non-void + traversal_for void.
3. `traversal_for_search_algo.hpp:14-15`: Kommentar aktualisieren — „Eytzinger (BFS-Layout) ist seit
   #188-4a organ-backed (organ_for_search_algo → EytzingerOrgan, Option b: lazy rebuild); im
   traversal_for-Trait bewusst void (kein faithful FLAT-Store-Traversal über LayoutAwareChunkedStore)."
4. `axis_03a_search_algo_eytzinger.hpp:54-57`: Kommentar-Update — die A2.5-Option ist EINGELÖST:
   „#188-4a (2026-07-02, Option b): store-traversierbar via organ_for_search_algo → EytzingerOrgan
   (EytzingerLayoutStore: sortierter Primärzustand + lazy BFS-Puffer). BEWUSST weiterhin KEIN
   axis_03a_store_traversable-Marker (der gilt dem FLAT-Store-Pfad); Registry-static_assert bleibt wahr.
   Dieser u16-Wrapper bleibt Registry-Tier + Äquivalenz-Referenz; die 320er-Messung läuft über das Organ."
   Datenhaltung/Methoden NICHT ändern.
5. `axis_03a_search_algo_registry.hpp:116-117`: static_assert bleibt; NUR den Begleit-Kommentar
   präzisieren (Eytzinger = organ-backed statt „Weg-B offen"), OHNE die mp_list anzufassen.

## 6. abi_adapter.hpp — AUSSCHLIESSLICH Kommentar-Wahrheits-Fixes (KEIN Code!)

Nach dem Flip wären diese Kommentare falsch (Fallstrick „vorbestehend/nachher falsche Kommentare"):
- Z.1942 + Z.1953-1956: „markerlose Default-Flach-Gruppe (Array256/Vector*/Eytzinger)" → Eytzinger
  STREICHEN; Gruppe = Array256/Vector*/Array65535; ergänzen „Eytzinger seit #188-4a organ-backed".
- Z.1007-1008 (T0-Stats-Kommentar „Weg-B-Algos (eytzinger/Tree/Trie/Hash): weiter aus search_organ_"):
  Eytzinger streichen — er ist jetzt authoritativ; Satz auf die verbleibende Flach-Gruppe umformulieren.
- Z.1775 (routes_through_store-Kommentar nennt „Eytzinger" als false-Beispiel): auf Array256/Vector*
  umstellen; Eytzinger liefert jetzt true.
- Falls weitere Kommentar-Nennungen von „eytzinger" im abi_adapter existieren (grep!): analog
  wahrheits-fixen. KEINE einzige Code-Zeile ändern; die Zeilennummern oben können leicht driften —
  IMMER per Banner/grep verifizieren, nicht blind zählen.

## 7. NEUER TEST `tests/unit/test_188_4a_eytzinger_organ.cpp` (+ Verifikationspunkte)

GTest, Muster der `test_234_f*`-Tests (benannte Konstanten statt Literale; deutsche Kommentare).
NICHT in CMake registrieren (Integrator). Enthält mindestens:

- **T1 Konformität:** `EytzingerOrgan` gegen `std::map<u64,u64>` über eine gemischte Sequenz
  (insert/update/erase/lookup, mehrere hundert Ops, deterministischer RNG mit festem Seed) — jede
  lookup-Antwort identisch; occupied_count == map.size() an Checkpoints.
- **T2 Wrapper-Äquivalenz:** `EytzingerSearchAlgo` (u16) vs `EytzingerOrgan` (u64) über eine Sequenz im
  u16-Keyraum — identische lookup-Treffer/Werte (der Organ-Key ist Obermenge; Vergleich auf gemeinsame Keys).
- **T3 Option-b-Lazy-Semantik (über die Store-API):** nach insert ist `store.dirty()==true`; erster lookup
  → Ergebnis korrekt UND `dirty()==false`; weiterer lookup ohne Mutation lässt `dirty()==false`;
  erase → wieder dirty; update via insert (vorhandener Key) → ebenfalls dirty (set_value_at-Invalidierung!).
- **T4 for_each_record:** N eingefügte Records (auch nach erases) → visited == occupied_count, Keys
  aufsteigend, Werte korrekt; DANACH `dirty()`-Zustand unverändert (kein Rebuild-Trigger durch die Ernte).
- **T5 Grenzfälle branch-free-Kern:** leeres Organ (miss), 1 Element (hit+miss), kleinster/größter Key,
  Nachbar-Keys (k±1-Misses), Duplikat-Update liefert neuen Wert.
- **T6 Kopier-Memento:** Kopie im dirty-Zustand ziehen → Original weiter mutieren → Kopie liefert nach
  eigenem Rebuild die ALTEN Werte (Unabhängigkeit der Vektoren inkl. dirty-Flag).
- **T7 Observable-Hülle:** `ObservableEytzingerOrgan` insert liefert is_new korrekt (neu true / update false);
  statistics()-Zähler laufen (unter COMDARE_CE_ENABLE_STATISTICS via #ifdef wie Nachbar-Tests).
- **T8 static_asserts (compile-time):** `organ_for_search_algo_t<EytzingerSearchAlgo> == EytzingerOrgan`;
  `traversal_for_search_algo_t<EytzingerSearchAlgo> == void`; `EytzingerLayoutPool<EytzingerLayoutStore>`;
  `!StoreTraversableSearchAlgo<EytzingerSearchAlgo>`.

**Verifikationspunkte im Abschlussbericht (nur PRÜFEN + berichten, nichts umbauen):**
- V6: `tier_scan`/authoritative-Zweig im abi_adapter kompiliert mit einem Organ OHNE `scan_range` — die 9
  Pool-Familien beweisen das (Pipeline 7372/7377 grün); bestätigen, dass Eytzinger denselben Zweig trifft.
- V7: Memento-/CoW-Pfade (`abi_adapter.hpp:1656,1666-1673,1706,1715-1722,2046,2085,2106`) kompilieren mit
  kopierbarem `container_t` — Vektoren-Store ist trivially copyable genug (copy-ctor + copy-assign).
- V8: `fill_segment_timing_v3` Zweig 2 (Z.1308-1315) greift jetzt für Eytzinger (pool_family_ +
  for_each_record) — die `keys={0}`-Degeneration Z.1327-1328 ist für Eytzinger Geschichte.

## 8. ABSCHLUSSBERICHT (dein finaler Text)

Liste: (a) angefasste/neue Dateien mit Kurzinhalt; (b) je §6-Kommentarstelle die tatsächliche Zeile;
(c) V6-V8-Befunde mit file:line; (d) alle Abweichungen vom Dossier MIT Begründung; (e) offene Punkte/Risiken.
KEINE CMake-/CI-Edits, keine Commits, kein git. Editor-Temp-Dateien (`*~NNNNN`) nicht zurücklassen.
