# DOSSIER #188-4c-ii — Faithful Traversal-Organe für die 4 markerlosen Flach-Wrapper

**Für: codex exec (workspace-write) im Repo `comdare-cache-engine` (HEAD `0052a53`).**
**Increment-Tag:** `#188-4c-ii (2026-07-02)`. Masterplan §2 Zeile 4c-ii; USER-Entscheid E1: faithful Organe
(KEIN Compile-time-Ausschluss). Nach diesem Increment ist der search_organ_+Spiegel-Zweig für ALLE
Kompositionen tot → 4c-iii entfernt ihn. **abi_adapter.hpp ist in DIESEM Increment TABU** (god-header-Regel;
die Weiche greift automatisch über den StoreTraversable-Marker — keinerlei abi_adapter-Edit nötig).

## 1. Ist (verifiziert am HEAD)
Die 4 letzten Spiegel-Zahler (flags default-OFF, nicht in golden-320):
- `axis_03a_search_algo_array256.hpp:42` **Array256SearchAlgo** (S01): key_type=u8, DIREKTADRESSIERT
  `std::array<optional,256>` — `data_[k]`, O(1), ART-Node256-Charakteristik (dense).
- `axis_03a_search_algo_array65535.hpp:54` **Array65535SearchAlgo**: key_type=u16, DIREKTADRESSIERT
  `data_[k]` (65536 Slots) — gleiche Charakteristik, 2-Byte-Discriminator.
- `axis_03a_search_algo_vector_u8u8.hpp:50` **VectorU8U8SearchAlgo** (S02): key_type=u8, SORTIERTES
  Vektor-Paar + `std::lower_bound` (O(log N)); trägt iterable_aspect (density_threshold — NUR
  Klassifizierung, orthogonal zur Suche; verifizieren, nicht anfassen).
- `axis_03a_search_algo_vector_u16u16.hpp:42` **VectorU16U16SearchAlgo**: key_type=u16, lower_bound analog.

**Vorbild-Mechanik (k_ary, #188-4a-C5 + per-K):** Marker `static constexpr bool
axis_03a_store_traversable = true;` (k_ary.hpp:67/:307 + static_asserts :511-512) → erfüllt
`StoreTraversableSearchAlgo` → abi_adapter-Weiche wählt `flat_container_t` mit
`traversal_for_search_algo_t` (traversal_for_search_algo.hpp:36-63, Spezialisierungen + static_asserts
:66-89) → container_ authoritativ, `routes_through_store()==true`, search_organ_ ungenutzt. KAryTraversal
(k_ary_traversal_organ.hpp) zeigt den Organ-Stil: eigener `lookup_in`-Kern über die Store-API
(key_at/slot_count), insert/erase/scan an SortedBinary-Semantik delegiert (traversal_for:12-14).

## 2. Auftrag
### 2.1 Zwei neue faithful Traversal-Organe (in `libs/cache_engine/axes/lookup/composable/`, Stil/Datei-
Konvention exakt an `k_ary_traversal_organ.hpp` + `interpolation_traversal_organ.hpp` anlehnen):
- **DirectAddressTraversal** (für Array256 + Array65535; wenn sinnvoll mit Template-Parameter für die
  Domänen-Breite, sonst EIN Typ — am Bestand entscheiden): `lookup_in` bildet die DIREKTADRESS-Charakteristik
  über den kompaktierten sortierten Flach-Store ab: berechnete Direktposition als Sprungziel
  (key − store.key_at(0), auf [0, slot_count) geklemmt; leerer Store → miss), dann LOKALE
  Korrektur-Suche zum exakten Key (linear/galloping — Korrektheit hat VORRANG, das Conformance-Gate ist
  das Netz). Doxygen MUSS ehrlich dokumentieren: „Direktadress-SCHÄTZUNG über kompaktiertem sortierten
  Store — O(1)-Sprung + lokale Korrektur; die Original-Wrapper adressieren lückenlos direkt". KEIN
  synthetischer Zusatzspeicher im Organ (stateless wie die Vorbilder).
- **SortedVectorTraversal** (für VectorU8U8 + VectorU16U16; Namen an Bestandskonvention anpassen):
  lower_bound über den sortierten Store = EXAKT die Suchsemantik der Wrapper. Eigener benannter Typ für
  die Achsen-Identität; Kern darf die SortedBinary-Mechanik wiederverwenden/delegieren (wie KAry
  insert/erase/scan delegiert) — bit-gleiche lower_bound-Suche, eigenes lookup_in-Etikett.
Beide erfüllen das TraversalOrgan-Concept (composable_search.hpp — Signaturen exakt ablesen).

### 2.2 Marker + Mapping + Beweise
- In den 4 Wrapper-Headern: `static constexpr bool axis_03a_store_traversable = true;` an der
  Konventions-Stelle (wie k_ary:67) + ggf. dortige Kommentar-Zeile; die schmalen key_types/Eigen-APIs der
  Wrapper NICHT ändern (Familien-Identität; die u64-Suche läuft künftig über das Traversal am Store —
  behebt zugleich K9-(d)-Truncation für diese 4).
- `traversal_for_search_algo.hpp`: 4 Spezialisierungen + Forward-Declarations + static_asserts nach
  Muster :66-89; Kopf-Kommentar (:11-16) um die neuen Mappings ergänzen.
- Prüfe `store_traversable_search_algo.hpp` + `axis_03a_search_algo_registry.hpp` auf static_asserts/
  Kommentare, die für diese 4 NEGATIV asserten (Muster: registry:90-91/:101) → auf die neue Wahrheit
  flippen. NUR Asserts/Kommentare — die Registry-mp_list (Struktur/Reihenfolge/Einträge) ist TABU.
### 2.3 Neuer Gate-Test `tests/unit/test_188_4cii_flat_wrapper_traversal.cpp`
Nach dem Muster von test_188_4c0 (aber NEUE Datei; test_188_4c0 NICHT anfassen): für je eine
AdHoc-Komposition pro Wrapper (Vorlage: die in test_seg_coverage.cpp:43 / test_obs_phaseB_pilot.cpp:50
seit 4c-i-T verwendeten StoreBackedAdHocComposition-Konstruktionen): (a) run_conformance_gate
(std::map-Orakel, seed 42, 2000 Ops — first_fail ist 1-BASIERT) grün; (b)
`tier_search_routes_through_store()==true` je Wrapper (EXPECT_TRUE, RecordProperty); (c) Size/Clear/
Reuse-Rundlauf; (d) Measurement-OFF → GTEST_SKIP (Muster 4c-0). KEINE CMakeLists-/CI-Registrierung
(macht der Integrator).

## 3. TABU / Leitplanken
`abi_adapter.hpp` · `modules/**` · `ext/**` · golden-Dateien · Registry-mp_list ·
`tests/unit/CMakeLists.txt` · `.gitlab-ci.yml` · test_188_4c0 · die 5 in 4c-i-T angepassten Tests
(deren StoreBackedAdHoc-Beweise bleiben durch 4c-ii gültig — im Bericht ARGUMENTIEREN: T0-Quelle wechselt
für Flach-AdHoc von search_organ_ auf container_, die Stats-/seg-Erwartungen bleiben erfüllt, weil
container_ weiterhin store-backed ist und beide Zähl-Wege op-äquivalent sind). Kein git. Keine
$null-/~NNNNN-Artefakte. EOF genau EIN Newline, LF. C++23; Kommentar-Idiom deutsch mit Increment-Tags.

## 4. Bericht
(a) Diff je Datei; (b) Organ-Design-Begründung (Direktadress-Schätzung + lower_bound-Delegation);
(c) Bestätigung TABU + golden-Neutralität (Wrapper default-OFF, mp_list unberührt); (d) Argument, warum
die 5 4c-i-T-Tests grün bleiben; (e) Risiken; (f) Liste evtl. gefundener weiterer Negativ-Asserts.
