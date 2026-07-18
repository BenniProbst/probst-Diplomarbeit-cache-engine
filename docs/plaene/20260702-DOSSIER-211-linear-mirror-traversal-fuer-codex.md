> ⛔ **VERWORFEN (2026-07-02, VOR Ausführung — User-Architektur-Einwand bestätigt):** Dieses Dossier hätte den
> nicht-authoritativen container_-Spiegel OPTIMIERT und damit ZEMENTIERT. Prüf-Paar (Explore+Codex, gegen Code +
> Architektur-Docs + Thesis) bestätigte: Der Spiegel ist ein Architektur-DEFEKT (store_traversable_search_algo.hpp:16-22
> „BUG, kein gewolltes Design … search_organ_ ENTFÄLLT"; Doc 30 Befund 2; Doc 34 §9 Apparat-Reinheit) und wird via
> **#188-4c ELIMINIERT** (Kontext-Dossier 20260628 §17: „#211 + #216 fallen WEG"). Kein Code aus diesem Dossier wurde
> implementiert. Erhalten als Planungs-Historie + Konsumenten-Matrix-Referenz (§1/§5-Recherche bleibt gültig).

# DOSSIER #211 — container_-Spiegel: LinearMirrorTraversal + O(1)-swap-erase (K5c/P4/M8-Fix)

**Für: codex exec (workspace-write) im Repo `comdare-cache-engine` (HEAD `a1f6024`).**
**Increment-Ziel:** Der NICHT-authoritative container_-Spiegel (Fallback-Zweig) pflegt sich ohne
O(n)-flatten+rebuild je Mess-Op: Insert = Duplikat-Scan+Update ODER O(1)-Append; Erase = Duplikat-Scan +
O(1)-Swap-Erase. Audit-Forderung wörtlich (Synthese:46): „LinearScanTraversal für container_ (Append-Pfad)
oder Append-basierte Slot-Ops"; A2.2-Plan: „Append-Pfad (kein Doppel-O(n) je Op)".

---

## 0. BINDENDE ENTSCHEIDE + TABUS

1. **NEUES, EIGENES Traversal `LinearMirrorTraversal`** — NICHT `LinearScanTraversal` ändern und NICHT
   `SortedBinaryTraversal` ändern! Begründung: `LinearScanTraversal` ist das AUTHORITATIVE Traversal des
   golden-320-Algos linear_scan (`traversal_for_search_algo.hpp:41-43`) — jede Änderung dort bewegt
   golden-320-Messwerte. Der Spiegel-Fix gilt NUR dem Fallback-Zweig.
2. **abi_adapter.hpp: EXAKT EINE Typ-Änderung** — in `container_traversal_t` (:1931-1934) den
   else-Ast `SortedBinaryTraversal` → `LinearMirrorTraversal`. Sonst NUR die in §5 benannten
   Kommentar-Wahrheits-Fixes. KEINE weiteren Code-Zeilen (god-header-Regel).
3. **Die golden-320 bleiben byte-identisch:** k_ary/interpolation/linear_scan (StoreTraversable, if-Ast)
   + eytzinger (organ-backed) berühren den else-Ast nie (`:1955-1960`). Test §6(e) beweist das per
   static_assert.
4. **Semantik-Erhalt (Konsumenten-Matrix, verifiziert):** Der Spiegel braucht (a) insert_or_assign-Semantik
   (Duplikatfreiheit + Wert-Aktualität — occupied_count/is_new/tier_scan-Prüfsumme), (b) geordnete
   tier_scan-Ausgabe (via scan_into-partial_sort, NICHT via physischer Sortierung), (c) exact-once-Records.
   Append-only OHNE Duplikat-Scan ist damit VERBOTEN (bricht Conformance-Gate insert_or_assign,
   conformance_gate.hpp RF-Regeln).
5. **TABU:** `modules/**`, `ext/**`, golden-Dateien, Registry-mp_list, `LinearScanTraversal`/
   `SortedBinaryTraversal`/`KAryTraversal`-Bodies, alle authoritative Pfade, CMakeLists.txt +
   `.gitlab-ci.yml` (**Integrator macht CMake/CI — bewusste Arbeitsteilung, im Review NICHT als
   fehlend melden**). Kein git, keine Commits, keine Editor-Temp-Dateien (`*~NNNNN`, `$null`).
6. Kommentar-Stil der Nachbardateien spiegeln; Increment-Tag `#211 (2026-07-02)`. C++23.

## 1. IST (verifiziert, Fundament)

- Fallback-Weiche `abi_adapter.hpp:1931-1934`: `container_traversal_t = conditional_t<StoreTraversable,
  traversal_for_search_algo_t<SearchAlgo>, SortedBinaryTraversal>`; flat_container_t :1936-1940 =
  `ObservableComposedSearch<container_traversal_t, LayoutAwareChunkedStore<N,L,A>>`.
- Zahler des else-Asts (`container_is_authoritative_==false`, :1959-1960): markerlose Flach-Wrapper
  (Array256/VectorU8U8/VectorU16U16/Array65535) + die 11 Reference-/PaperBinding-Compositions
  (u64-Organ-Hülle als search_algo). Doppelbuchung: tier_insert :755-760, tier_erase :888-894.
- Der O(n)-Kern: `SortedBinaryTraversal::insert_into/erase_from` (`composable_search.hpp:141-164`) rufen
  `insert_slot_at/erase_slot_at`; im `LayoutAwareChunkedStore` (`axes/node/axis_04_node_type_layout_aware_store.hpp:196-205`)
  sind BEIDE als `flatten_() → mutieren → rebuild_(flat)` implementiert — `rebuild_` (:433-435) re-appendet
  ALLE Slots mit Chunk-Neu-Allokationen (`++chunk_allocs_` :189; Zähler-API `chunk_alloc_count()` :123).
  `RawSlotStore` (composable_search.hpp:37-55) macht vector-emplace/erase (memmove O(n)).
- prefetch-descent `descent_slot_for_` :1904-1918 = lower_bound-Position; die Schätz-Semantik bei
  unsortiertem Store ist dort :1894-1903 BEREITS dokumentiert (nur nachschärfen, §5).
- LinearScanTraversal-Vorlage: `composable_search.hpp:79-125` (insert :80-88 Scan+Update/Append;
  erase :96-103 Scan+erase_slot_at; scan_into :109-124 O(n)-collect+partial_sort in Key-Ordnung).

## 2. NEU: `swap_erase_slot_at` an den Stores (O(1)-Löschung für unsortierte Substrate)

1. **`RawSlotStore`** (`composable_search.hpp:37-55`): Methode ergänzen —
   `void swap_erase_slot_at(std::size_t i) { slots_[i] = slots_.back(); slots_.pop_back(); }`
   (bei i == letzter Index degeneriert das zu pop_back; Doku-Kommentar: „O(1)-Erase für UNSORTIERTE
   Substrate — Positionsstabilität bewusst aufgegeben (#211); sortierte Traversale nutzen weiter
   erase_slot_at").
2. **`LayoutAwareChunkedStore`** (`axis_04_node_type_layout_aware_store.hpp`): Methode
   `swap_erase_slot_at(std::size_t i)` FLATTEN-FREI über die bestehenden Slot-Primitiven implementieren:
   letzten Slot (Index n-1) lesen, an Position i schreiben, dann den letzten Slot entfernen
   (Slot-Count dekrementieren; wird der letzte Chunk leer, freigeben — analog zur bestehenden
   Chunk-Verwaltung, KEIN rebuild_, KEIN flatten_). WICHTIG: Der Store trägt seit #167 FÜNF reale
   memory_layout-Repräsentationen (aos/cache_line_aligned/soa/aosoa/packed_bitmap) — die Methode MUSS
   für alle 5 korrekt sein. Wenn es eine bestehende interne „Slot i überschreiben"-Primitive gibt
   (set_value_at existiert; ein set_key_at ggf. nicht), implementiere das Überschreiben je
   Repräsentations-Zweig dort, wo auch key_at/value_at/append_slot je Repräsentation verzweigen —
   EXAKT deren Muster spiegeln. Falls eine Repräsentation ein O(1)-Entfernen strukturell nicht
   hergibt (z.B. packed_bitmap-Verdichtung), dokumentiere die tatsächliche Kostenklasse der
   Repräsentation im Kommentar — aber KEIN flatten_/rebuild_-Aufruf.
   Statistik: KEIN ++chunk_allocs_ (es wird nichts alloziert); vorhandene Zähler-Semantik unangetastet.
3. Beide Stores: static_asserts/Concepts NICHT verschärfen — `swap_erase_slot_at` ist eine ADDITIVE
   Capability (das TraversalOrgan-Concept bleibt unverändert; LinearMirrorTraversal prüft sie per
   `requires` mit erase_slot_at-Fallback, §3).

## 3. NEU: `LinearMirrorTraversal` (composable_search.hpp, nach LinearScanTraversal einfügen)

`struct LinearMirrorTraversal` — Kopf-Kommentar: „#211 (2026-07-02): Mirror-Traversal für den
NICHT-authoritativen container_-Spiegel (Fallback in abi_adapter::container_traversal_t). Semantik =
LinearScan (unsortiert, Duplikat-Scan + Update/Append), Erase = O(1)-swap-erase statt
flatten+rebuild — entfernt den K5c/P4/M8-Apparat-O(n) je Mess-Op. BEWUSST eigenes Organ: das
authoritative LinearScanTraversal (golden-320 linear_scan) bleibt byte-identisch."

- `insert_into<Store>`: EXAKT die LinearScan-Logik (:80-88) — Scan über slot_count/key_at; Treffer →
  set_value_at; sonst append_slot. (Kein Code-Sharing-Umbau der bestehenden structs — kleine, bewusste
  Duplikation der 8 Zeilen ist hier wartbarer als eine CRTP-Basis über fremden Organen; Kommentar-Verweis
  auf die Vorlage genügt.)
- `erase_from<Store>`: Scan; Treffer → `if constexpr (requires { s.swap_erase_slot_at(i); })
  s.swap_erase_slot_at(i); else s.erase_slot_at(i);` → true; sonst false. (requires-Fallback hält das
  Organ für JEDEN StorageOrgan-Store gültig.)
- `scan_into<Store, Sink>`: an `LinearScanTraversal::scan_into<Store>(...)` DELEGIEREN (statische
  Weiterleitung — identische geordnete Ausgabe, kein Duplikat-Code; Muster „Interpolation/Galloping
  delegieren ihr scan_into an SortedBinary" composable_search.hpp:245).
- Selbstbeweis am Dateiende ergänzen: `static_assert(ScannableTraversalOrgan<LinearMirrorTraversal,
  RawSlotStore>);` (Muster :246-247).

## 4. abi_adapter.hpp — DIE eine Typ-Zeile

In `container_traversal_t` (:1931-1934) den else-Ast von
`...composable::SortedBinaryTraversal` auf `...composable::LinearMirrorTraversal` umstellen
(voll qualifiziert wie der bisherige Typ; gleicher Namespace `comdare::cache_engine::traversal::
axis_03a_search_algo::composable` — verifiziere den tatsächlichen Qualifizierungs-Pfad am Bestand).
KEINE weitere Code-Änderung.

## 5. Kommentar-Wahrheits-Fixes (NUR Kommentare; Zeilen driften — per grep verifizieren)

- :1927-1934-Kommentarblock: „Weg-B-Algos: SortedBinary-Fallback" → „nicht-authoritativer Spiegel:
  LinearMirrorTraversal (#211 — Append/Swap statt O(n)-flatten+rebuild; K5c/P4/M8)".
- :1955-1958 (markerlose Default-Flach-Gruppe „bleibt search_organ_+Spiegel"): ergänzen „Spiegel seit
  #211 unsortiert (LinearMirror, kein O(n)-Rebuild je Op)".
- :1894-1903 (descent-Schätzung): präzisieren, dass der Fallback-Spiegel seit #211 UNSORTIERT ist →
  descent_slot = lower_bound über unsortierte Keys = bewusste Schätzung (in-range, geklemmt :1917),
  Organ-exakt nur bei sortiert-authoritativen Stores. KEINE Code-Änderung an descent_slot_for_.
- :1630-1631 (CoW-Historie „SortedBinary insert_slot_at/erase_slot_at = flatten+rebuild; trifft über
  container_ JEDE Komposition"): historisieren — „(bis #211; seither LinearMirror-Fallback ohne Rebuild;
  organ-backed/store-traversierbare Kompositionen längst spiegelfrei)".
- Doppelbuchungs-else-Kommentare :755-760/:888-894: falls sie „SortedBinary(-Spiegel)" nennen →
  auf LinearMirror-Spiegel aktualisieren.
- grep nach weiteren „SortedBinary"-Nennungen im abi_adapter, die den FALLBACK meinen (nicht die
  authoritativen sortierten Traversale!) → analog fixen; im Bericht je Stelle die echte Zeile nennen.

## 6. NEUER TEST `tests/unit/test_211_mirror_append.cpp` (GTest; NICHT in CMake registrieren — Integrator)

Muster test_234_f*/test_188_4a (benannte Konstanten, deutsche Kommentare). Inhalt:

- **(a) Spiegel-Semantik gegen std::map:** `ObservableComposedSearch<LinearMirrorTraversal,
  LayoutAwareChunkedStore<Default-N,L,A>>` (die konkreten Default-Achsen-Typen aus flat_container_t
  am Bestand ablesen — z.B. wie test_m8_storetrav_segment sie zieht) über eine gemischte
  deterministische Sequenz (insert/update/erase/lookup, mehrere hundert Ops, fester Seed):
  lookup-Antworten + occupied_count == std::map; insert-is_new-Flags korrekt.
- **(b) O(1)-Beweis über chunk_alloc_count() (timing-frei, DER K5c-Beweis):** N=kSweepN (z.B. 512)
  sequenzielle NEU-Inserts in einen frischen LayoutAwareChunkedStore via LinearMirrorTraversal →
  `chunk_alloc_count()` wächst LINEAR (<= N/cap + Konstante; Konstanten benannt, cap aus der
  Store-API/Konstante ablesen, nicht raten). GEGENPROBE mit SortedBinaryTraversal auf einem zweiten
  frischen Store: chunk_alloc_count() ist STRENG größer (quadratische Klasse) — als
  `EXPECT_GT(sorted_allocs, mirror_allocs * kFactorMin)` mit dokumentiertem, konservativem
  kFactorMin (z.B. 4) statt exakter Formel (robust gegen cap-Details).
- **(c) swap-erase-Korrektheit:** Erase des ERSTEN, eines MITTLEREN und des LETZTEN Keys →
  occupied_count sinkt je um 1, alle verbleibenden Keys weiter auffindbar mit korrekten Werten,
  erneutes erase desselben Keys → false; chunk_alloc_count() unverändert durch die Erases.
- **(d) tier_scan-Ordnung:** scan_range ab start_key über den Mirror liefert Keys AUFSTEIGEND mit
  aktuellen Werten (nach Updates), Anzahl <= max_count (Muster test_v41_scan_range_organ).
- **(e) 320-Nicht-Betroffenheits-Anker (compile-time):** static_asserts —
  `traversal_for_search_algo_t<KArySearchAlgo> == KAryTraversal<4>`,
  `traversal_for_search_algo_t<InterpolationSearchAlgo> == InterpolationTraversalOrgan`,
  `traversal_for_search_algo_t<LinearScanSearchAlgo> == LinearScanTraversal`,
  `organ_for_search_algo_t<EytzingerSearchAlgo> == EytzingerOrgan` — die vier golden-320-Algos
  hängen NICHT am Fallback. Plus `ScannableTraversalOrgan<LinearMirrorTraversal, RawSlotStore>`.
- **(f) RawSlotStore-swap_erase:** direkter Mini-Test (3 Slots, mittleren swap-erasen → letzter
  steht an Position i, count==2).

## 7. VERIFIKATIONSPUNKTE im Abschlussbericht (prüfen + berichten, nichts umbauen)

- V1: Memento/CoW kompiliert unverändert (saved_container_-Copy :1672/:2109; restore_state via
  Traversal::insert_into `composable_search.hpp:230-233` läuft jetzt als Append-Aufbau — Verhalten
  korrekt, eher schneller; bestätigen dass ComposedSearch<LinearMirrorTraversal,...> das
  MementoAxis-Muster weiter erfüllt).
- V2: `test_cow_memento`/Äquivalenz-Tests (Referenz-Compositions = Zahler-Menge) bestehen semantisch
  weiter (keine Sortier-Assertion auf dem Spiegel — verifizieren per grep in den Test-Dateien).
- V3: Alle 5 Layout-Repräsentationen des LayoutAwareChunkedStore von swap_erase_slot_at abgedeckt
  (je Zweig file:line nennen).
- V4: conformance_gate-Anforderungen (insert_or_assign, Duplikat-false, Größe) durch LinearMirror
  erfüllt (Begründung mit conformance_gate.hpp-Zeilen).

## 8. ABSCHLUSSBERICHT

(a) neue/angefasste Dateien mit Kurzinhalt; (b) die EINE abi_adapter-Typ-Zeile (echte Zeilennummer) +
je §5-Kommentarstelle die echte Zeile; (c) V1-V4-Befunde mit file:line; (d) Abweichungen mit
Begründung; (e) offene Punkte/Risiken. KEINE CMake-/CI-Edits, kein git.
