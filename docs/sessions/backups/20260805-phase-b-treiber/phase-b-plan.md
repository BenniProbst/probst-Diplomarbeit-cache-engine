# PHASE-B-PLAN: abi_adapter-Treiber-Durchbindung (EffectiveSearchAlgo) + Organ-Pfad-Faden + Traversal-Mapping-Symmetrie

Stand der Erhebung: 2026-08-05, am Objekt b09ebb8a (wt-e24, tree-identisch zu fce1274f, `git diff --stat fce1274f b09ebb8a` leer, working tree clean).
Basis-Verifikation reproduziert: `grep -rn 'search_algo_for_composition|EffectiveSearchAlgo' libs/cache_engine/anatomy/abi_adapter.hpp` = 0 Treffer.
Die 3 Treiber-Stellen live bestaetigt: abi_adapter.hpp:444 / :549 / :666 (`SearchAlgo algo;` + 256-Insert-Schleife :445/:550/:667), alle DREI innerhalb des `#if COMDARE_MEASUREMENT_ON`-Blocks :433..:935 (Mess-only; Pfad A run_workload / run_workload_segmented / run_workload_segmented_v2).
Pflicht-Vorlauf gelesen: Ledger-Nachtraege 04./05.08. (Rezept-Kanon nacht-4/-5, h81-Lehre nacht-3, 05q-Lehren vormittag-1), Pause-Doc Par.3+Par.6, Design-Backup designs[0].r.t6_durchbindung, abi_adapter :400-:700 + :2195-:2284, search_algo_rebind.hpp komplett, traversal_for_search_algo.hpp komplett, organ_for_search_algo(.hpp/_shaped.hpp) komplett, beide tier_to_organ_mapping-Wurzeln, 02a-HERZ-Vorbild (axis_04_node_type_layout_aware_store.hpp:40-42/:192 + tests/unit/test_s5_02a_layout_alloc_conformance.cpp:306-330).

---

## (a) REBOUND-LEAF-INVENTAR — VOLLSTAENDIG (22/22 der AllStrategies, Registry axis_03a_search_algo_registry.hpp:54-92)

Befund-Kern: ALLE 22 Organe tragen seit 01c-1..01c-3 einen Rebound-Leaf (`rebind_allocator<A2>`).
Das Traversal-Mapping (axes/lookup/composable/traversal_for_search_algo.hpp) mappt 11 FASSADEN non-void;
von deren Rebound-Leaves ist heute NUR die per-K-Familie gemappt (partielle Spezialisierung :112-115).
ES FEHLEN GENAU 7 Rebound-Spezialisierungen. Die 11 void-Fassaden sind void-KORREKT auch fuer ihre
Rebounds (Primaer-Template :57-60 liefert void — Symmetrie besteht dort bereits; KEINE Eintraege ergaenzen).

Alle Pfade relativ zu libs/cache_engine/axes/lookup/ (Datei axis_03a_search_algo_<name>.hpp); Traversal-Zeilen = traversal_for_search_algo.hpp; organ_for-Zeilen = composable/organ_for_search_algo.hpp.

| # | Organ (Fassade, Registry S-Nr) | Rebound-Leaf (rebind-Alias : Klassen-Def) | Fassaden-Mapping | Rebound-Mapping |
|---|---|---|---|---|
| 1 | Array256SearchAlgo (S01) | Array256SearchAlgoRebound — array256.hpp:247 : :254 | DirectAddressTraversal (trav:62) | **FEHLT** |
| 2 | VectorU8U8SearchAlgo (S02) | VectorU8U8SearchAlgoRebound — vector_u8u8.hpp:319 : :326 | SortedVectorTraversal (trav:70) | **FEHLT** |
| 3 | VectorU16U16SearchAlgo (S03) | VectorU16U16SearchAlgoRebound — vector_u16u16.hpp:304 : :314 | SortedVectorTraversal (trav:74) | **FEHLT** |
| 4 | OriginalArtSearchAlgo (S04) | OriginalArtSearchAlgoRebound — original_art.hpp:272 : :279 | void (Pool; organ_for:70 ArtTrieOrgan) | void-korrekt |
| 5 | OriginalHotSearchAlgo (S05) | OriginalHotSearchAlgoRebound — original_hot.hpp:325 : :332 | void (organ_for:74) | void-korrekt |
| 6 | OriginalStartSearchAlgo (S06) | OriginalStartSearchAlgoRebound — original_start.hpp:316 : :324 | void (organ_for:78) | void-korrekt |
| 7 | OriginalWormholeSearchAlgo (S07) | OriginalWormholeSearchAlgoRebound — original_wormhole.hpp:288 : :296 | void (organ_for:82) | void-korrekt |
| 8 | OriginalSurfSearchAlgo (S08) | OriginalSurfSearchAlgoRebound — original_surf.hpp:298 : :306 | void (organ_for:86) | void-korrekt |
| 9 | Array65535SearchAlgo (S09) | Array65535SearchAlgoRebound — array65535.hpp:286 : :293 | DirectAddressTraversal (trav:66) | **FEHLT** |
| 10 | KArySearchAlgo (S10, HAUPT K=4) | KArySearchAlgoRebound — k_ary.hpp:369 : :376 | KAryTraversal<4u> (trav:86) | **FEHLT** |
| 11 | InterpolationSearchAlgo (S11) | InterpolationSearchAlgoRebound — interpolation.hpp:338 : :348 | InterpolationTraversalOrgan (trav:82) | **FEHLT** |
| 12 | EytzingerSearchAlgo (S12) | EytzingerSearchAlgoRebound — eytzinger.hpp:312 : :319 | void (organ-backed, organ_for:112 EytzingerOrgan) | void-korrekt |
| 13 | SkipListSearchAlgo (S13) | SkipListSearchAlgoRebound — skip_list.hpp:407 : :414 | void (organ_for:90) | void-korrekt |
| 14 | HashSearchAlgo (S14) | HashSearchAlgoRebound — hash_search.hpp:352 : :359 | void (organ_for:94) | void-korrekt |
| 15 | LinearScanSearchAlgo (S15) | LinearScanSearchAlgoRebound — linear_scan.hpp:323 : :334 | LinearScanTraversal (trav:78) | **FEHLT** |
| 16 | BinarySearchTreeSearchAlgo (S16) | BinarySearchTreeSearchAlgoRebound — bst.hpp:364 : :372 | void (organ_for:102) | void-korrekt |
| 17 | BTreeSearchAlgo (S17) | BTreeSearchAlgoRebound — btree.hpp:579 : :586 | void (organ_for:106) | void-korrekt |
| 18 | KArySearchAlgoK2 (S18) | KArySearchAlgoKRebound<2,A2> — k_ary.hpp:795 (Leaf-Template :768) | KAryTraversal<2u> (trav:94) | VORHANDEN (trav:112-115) |
| 19 | KArySearchAlgoK4 (S19) | KArySearchAlgoKRebound<4,A2> — k_ary.hpp:806 | KAryTraversal<4u> (trav:98) | VORHANDEN (trav:112-115) |
| 20 | KArySearchAlgoK8 (S20) | KArySearchAlgoKRebound<8,A2> — k_ary.hpp:817 | KAryTraversal<8u> (trav:102) | VORHANDEN (trav:112-115) |
| 21 | KArySearchAlgoK16 (S21) | KArySearchAlgoKRebound<16,A2> — k_ary.hpp:828 | KAryTraversal<16u> (trav:107) | VORHANDEN (trav:112-115) |
| 22 | SwissTableSearchAlgo (S22) | SwissTableSearchAlgoRebound — swisstable.hpp:390 : :397 | void (organ_for:98) | void-korrekt |

Nachzuziehende Mapping-Spezialisierungen (7): Array256 / Array65535 / VectorU8U8 / VectorU16U16 / LinearScan / Interpolation / KAry-HAUPT — je `template <class A2> struct traversal_for_search_algo<XxxSearchAlgoRebound<A2>> { using type = <dasselbe Organ wie die Fassade>; };` nach dem Muster der per-K-Zeile trav:112-115.

Trait-Grundlage (search_algo_rebind.hpp): Level-0-is_same-Vorrang :69-78 (Default-/golden-Pfad bleibt die FASSADE — kein Rebound-Typ auf dem golden-Pfad), Level-1-Rebind :91-94, Level-2-Identitaet :86-89; `IsReboundSearchAlgoLeaf` :116-117 (Ebenen-Ausweis fuer die Adapter-Wache).

## (b) WURZEL-ENTSCHEID tier_to_organ_mapping — SUBSTANZ = axes/, WEITERLEITUNG = topics/

- **Substanz-Wurzel: libs/cache_engine/axes/lookup/composable/tier_to_organ_mapping.hpp** (128 Zeilen; ALLE Organ-Alias-Definitionen :41-117, TierOrganPair :122-126).
- **Weiterleitungs-Wurzel: libs/cache_engine/topics/traversal/axis_03a_search_algo/composable/tier_to_organ_mapping.hpp** = GENAU 5 Zeilen: `#include <axes/lookup/composable/tier_to_organ_mapping.hpp>` + `using namespace comdare::cache_engine::lookup;`-Re-Export. NULL Substanz.
- Zusatz-Beleg: UML-Atlas-Census (Ledger vormittag-2): "topics/traversal-1 = reine Weiterleitungsheader, Census-bestaetigt 0 Typ-Definitionen".
- Konsumenten (z.B. compositions/art_paper_binding_reference.hpp:19) inkludieren den topics/-Pfad und bleiben ueber den Re-Export versorgt. **ENTSCHEID: NUR axes/lookup/composable/tier_to_organ_mapping.hpp aendern; topics/-Header BYTE-UNANGETASTET.**
- Hinweis Zeilen-Drift: Die Pause-Doc-Referenz ":46-64" stammt von einem aelteren Stand; am Ist b09ebb8a ist der Organ-Alias-Block :41-117 (Kern der Faden-Aenderung: :44-64 Shaped-/Plain-Aliase + :75-97 Original-Organe + :63-64 Eytzinger).

## (c) EXAKTER AENDERUNGS-PLAN JE DATEI:ZEILE

### C1 — Traversal-Mapping-Symmetrie + Kommentar-Reste (substanz-eng, kein Adapter-Touch)

1. **libs/cache_engine/axes/lookup/composable/traversal_for_search_algo.hpp**
   - Nach :47 (Vorwaerts-Deklarationen der Fassaden): 7 Template-Vorwaerts-Deklarationen der Rebound-Leaves ergaenzen, exakt nach dem per-K-Muster :51-52 (`template <class A2> class LinearScanSearchAlgoRebound;` usw. — OHNE `final` in der Fwd-Decl). Betroffen: Array256/Array65535/VectorU8U8/VectorU16U16/LinearScan/Interpolation/KAry(HAUPT).
   - Nach :108 (vor der per-K-Rebound-Spezialisierung :109-115): 7 partielle Spezialisierungen `template <class A2> struct traversal_for_search_algo<XxxSearchAlgoRebound<A2>> { using type = <Fassaden-Organ>; };` (Ziel-Typen exakt wie Inventar-Spalte "Fassaden-Mapping").
   - KEINE In-Header-static_asserts mit Allokator-Typen: der Header kennt bewusst keine Strategie (dokumentierte Include-Disziplin :157-163, Klasse Boost-Link-Hotfix cda964e0). Pins gehen in die Familien-Wache (Punkt 2).
   - Keine neuen Includes -> kein Link-Satz-Delta.
2. **tests/unit/test_s5_01c_fassaden_conformance.cpp** (bestehende Gate-TU, 730 Z.; ctest-N UNVERAENDERT)
   - ABGELEITETER Symmetrie-Pin ueber die REGISTRY-Population (kein Namenslisten-Zement, Muster :252/:274ff): fuer JEDE S in lk::AllStrategies mit `Rebound = comp::search_algo_for_composition_t<S, KompositionsAllokator>`: `static_assert(std::is_same_v<comp::traversal_for_search_algo_t<Rebound>, comp::traversal_for_search_algo_t<S>>, ...)` — beisst BEIDSEITIG: non-void-Fassade mit void-Rebound (die heutige 7er-Luecke) UND jede kuenftige Asymmetrie. Genau der in traversal_for_search_algo.hpp:157-163 angekuendigte Ort.
   - ANTI-ZEMENTIERUNGS-BISS Pflicht-Nachweis des Bauers: Pin am VOR-Stand (ohne die 7 Spezialisierungen) kompilieren -> MUSS mit erklaerender Meldung brechen; echten Compile-Befehl nehmen (ninja -t commands-Falle: NICHT den C++20-Modul-Scan `-E`, Pause-Doc Par.6).
3. **Kommentar-Reste 01c-2-B2 (substanz-neutral, ASCII-only):**
   - libs/cache_engine/axes/lookup/axis_03a_search_algo_flags.hpp.in:33 — "(KArySearchAlgoT<K>)" auf die gehobenen Leaf-Klassen KArySearchAlgoK2..K16 umformulieren (reiner Kommentar; erzeugtes flags.hpp ist KEIN golden-TABU).
   - CMakeLists.txt:278 (Kommentar) und :280-283 (option-Beschreibungstexte "KArySearchAlgoT<2>" usw. -> "KArySearchAlgoK2" usw.). KEINE option-NAMEN aendern (COMDARE_AXIS_03A_ENABLE_K_ARY_K2..K16 bleiben byte-gleich — Cache-/CI-Schnittstelle).
   - NICHT anfassen: die HISTORISCHEN Erklaer-Kommentare k_ary.hpp:463-481 und traversal_for_search_algo.hpp:39-43 (beschreiben den Alt-Zustand korrekt als Geschichte).

### C2 — Organ-Pfad-Faden (konstitutiver Pfad; Alloc-Durchreichung an die Pool-Organe)

4. **libs/cache_engine/axes/lookup/composable/tier_to_organ_mapping.hpp** (NUR Substanz-Wurzel, s. (b))
   - Die von organ_for/shaped konsumierten Organ-Aliase erhalten Alloc-PARAMETRISIERTE Formen; die bestehenden Namen bleiben als DEFAULT-Instanziierungen byte-/typ-identisch (`is_same` mit heute — Level-0-Neutralitaet per Konstruktion, alle 12 Stores tragen den Alloc-Parameter seit 01a live: z.B. btree_node_pool_store.hpp:56-58 `template <Shape, class Alloc = ExgenAllocator>`).
   - Konkret: (i) die 4 Shaped-Aliase :44-45/:48-49/:54-55/:57-58 um `class Alloc = ExgenAllocator` als 2. Parameter erweitern (Store-Position `XxxPoolStore<Shape, Alloc>`); (ii) fuer die 7 shape-losen organ_for-Familien (:51 Swiss, :63-64 Eytzinger, :75 Art, :79 Hot, :85-86 Start, :91 Wormhole, :96 SuRF) je eine `template <class Alloc> using XxxOrganBound = Composed...<..., XxxStore<Alloc>>;`-Form ergaenzen und den bestehenden Alias als `using XxxOrgan = XxxOrganBound<ExgenAllocator>;` erhalten (bzw. Default-Param, wo der Store nur Alloc traegt). MasstreeOrgan (:115, kein Registry-Organ) NUR mitziehen, wenn trivial — sonst unveraendert.
   - Observable*-Aliase :105-117 UNVERAENDERT (organ_for liefert das ROHE Organ; der Adapter wrappt selbst).
5. **libs/cache_engine/axes/lookup/composable/organ_for_search_algo_shaped.hpp**
   - Dritter Template-Parameter `class CompAlloc = ExgenAllocator` am Trait (Primaer :28-31 bleibt Alloc-INERT = familienfremde Kombinationen unveraendert, 234-V-Disziplin). Fuer ALLE 11 organ-backed Familien Spezialisierungen (Shape-Familien BTree/BST/Hash/SkipList in BEIDEN Armen <Shape,CompAlloc> + <void,CompAlloc>; die 7 shape-losen als <void,CompAlloc>-Arm), die CompAlloc in die Store-Position binden.
   - Die EINARMIGE Naht organ_for_search_algo.hpp bleibt UNANGETASTET (golden-Anker, Header-Kommentar :8-10; alle bestehenden static_asserts :120-189 bleiben gueltig).
   - Bestehende Level-0-Asserts des Shaped-Headers (:88-105) bleiben kompilierbar (Default-Param); ZUSAETZLICH je Familie Level-0-Pin `is_same_v<shaped_t<S, Shape, ExgenAllocator>, shaped_t<S, Shape>>` im Header (Exgen ist dort bereits transitiv bekannt) + Level-1-Pins mit fremder Strategie in der Familien-TU (Include-Disziplin).
6. **libs/cache_engine/anatomy/abi_adapter.hpp — NUR die 2 Trait-Konsum-Stellen**
   - :2235 (pool_family_-Praedikat) und :2243-2244 (container_algorithm_t): `organ_for_search_algo_shaped_t<SearchAlgo, ShapeCarrier>` -> `organ_for_search_algo_shaped_t<SearchAlgo, ShapeCarrier, typename Composition::allocator>` (beide Stellen identisch, sonst Typ-Drift zwischen Praedikat und Typwahl).
   - Damit kommt die T6-Wahl der Komposition auch im KONSTITUTIVEN Container-Pfad der Pool-Familien an (der flache Store-Pfad konsumiert sie bereits: :2224-2228 LayoutAwareChunkedStore<node,layout,allocator>; A8-S4-Pin :2271-2273 bewacht die Kette weiter).
   - EHRLICHE GRENZE (deklarieren, nicht bauen): der organ_hull_-Zweig :2236-2237/:2245 (Reference-/PaperBinding-Kompositionen, search_algo = Observable*Organ-Alias, z.B. art_paper_binding_reference.hpp:55 mit MimallocAllocator :66) bleibt Level-2-Identitaet — ObservableComposedContainer traegt kein rebind_allocator (observable_composed_container.hpp:67 nur allocator_type). Als NEUEN Posten fuer den Owner-Block registrieren (Klasse EV-4/Level-2, ausserhalb der 320-Registry), NICHT still erweitern.
   - builder/anatomy_commands/anatomy_execution_context.hpp:50-63 (zweiter Trait-Konsument, einarmig) bleibt in Phase B UNANGETASTET (nicht der Genus-Erst-Instanziierungs-Punkt; als Faden-Rest im selben Posten mit-registrieren).

### C3 — EffectiveSearchAlgo an den 3 Treiber-Stellen + Kontrast-Beweis (G8-Flaeche, kleinster Diff)

7. **libs/cache_engine/anatomy/abi_adapter.hpp**
   - Include-Block :72-74: `#include <axes/lookup/composable/search_algo_rebind.hpp>` ergaenzen (Header ist BEWUSST boost-frei, search_algo_rebind.hpp:50-52 — kein neuer Link-Satz; .d-Detektor trotzdem fahren, Pause-Doc Par.6).
   - Nach :2209 (`using Composition` :2208 / `using SearchAlgo` :2209, Klassen-Ebene der EINEN Klasse SearchAlgorithmAbiAdapter :229-:2431 — Member-Bodies sehen Klassen-Aliase unabhaengig von der Deklarationsreihenfolge):
     `using EffectiveSearchAlgo = ::comdare::cache_engine::lookup::composable::search_algo_for_composition_t<SearchAlgo, typename Composition::allocator>;`
     + IDENTITAETS-PIN aus dem D1-Design: `static_assert(!::comdare::cache_engine::lookup::composable::IsReboundSearchAlgoLeaf<SearchAlgo>, ...)` (Composition::search_algo darf NIE ein Rebound-Typ sein — schuetzt adhoc_emitter-type_name-Reise und serialize-Schluessel strukturell).
   - Die 3 Treiber-Ersetzungen (je 2 Zeilen, Mess-Block :433-:935):
     * run_workload: :443 `using K = typename SearchAlgo::key_type;` -> `typename EffectiveSearchAlgo::key_type;` und :444 `SearchAlgo algo;` -> `EffectiveSearchAlgo algo;`
     * run_workload_segmented: :548 (K) und :549 (algo) analog.
     * run_workload_segmented_v2: :663 (K) und :666 (algo) analog.
   - SONST NICHTS in dieser Datei (G8, s. (e)). Die lokalen `using SearchAlgo/Allocator/...`-Zeilen bleiben stehen (Allocator :446/:551/:682 wird weiter fuer Churn/lbuf gebraucht).
8. **tests/unit/test_phase_b_effective_search_algo_contrast.cpp (NEU) + tests/unit/CMakeLists.txt (ctest-N steigt um 1: 402 -> 403)**
   - Ziel-Target nach dem MEASURED-Muster CMakeLists.txt:2312-2328: `COMDARE_MEASUREMENT_ON=1 COMDARE_CE_ENABLE_STATISTICS=1 COMDARE_EXPERIMENT_MODE_ON=1`; Boost-Link-Satz SOFORT pruefen/setzen (TU zieht Registry/mp11 -> `Boost::mp11` explizit linken; Lehre cda964e0, lokal-gruen beweist hier NICHTS — CI-Job-Form mit frischem Configure ins Scratchpad nachstellen).
   - KONTRAST-BEWEIS nach 02a-HERZ-Vorbild (test_s5_02a_layout_alloc_conformance.cpp:306-330 — die Aussage MUSS am Alt-Stand FALLEN, ein blosses ">0" pinnt nichts):
     * (K-1, Typ-Ebene) Fuer eine Test-Komposition mit fremder Strategie: `search_algo_for_composition_t<Fassade, FremdAlloc>` == Rebound<FremdAlloc> (Level-1) UND fuer die Default-Komposition == Fassade selbst (Level-0-golden-Pin, is_same-Einzeiler wie im D1-Design).
     * (K-2, HERZ-Kontrast am Mess-Pfad) Zaehl-Allokator-Strategie mit statischen (typ-globalen) Zaehlern als Composition::allocator (AllocatorStrategy-konform inkl. h81-Weiterleiter-Regeln; bestehende Test-Strategie-Probes der 01c-/S7-TUs zuerst am Objekt sichten und wiederverwenden statt neu erfinden). `SearchAlgorithmAbiAdapter<A>.run_workload(ops, 1, seed, out, 1)` fahren. ERWARTUNGS-ARITHMETIK deterministisch: Treiber-eigene Allokationen ueber `Allocator alloc;` = 1x lbuf (:463) + 2x kChurn=2048 (Warmup :524 + 1 Mess-Batch; allocate-Aufrufe :495) = 4097. ALT-Stand: Zaehler == 4097 EXAKT (die 256 algo-Inserts liefen unsichtbar ueber den Organ-Default Exgen). NEU-Stand: Zaehler == 4097 + Delta, Delta > 0 UND EXAKT gleich dem per Direkt-Materialisierung von `EffectiveSearchAlgo` (256 identische Inserts) erhobenen Instanz-Zaehlerstand — der Zaehler-KONTRAST Fassade vs EffectiveSearchAlgo: dieselbe Sequenz auf der FASSADE bewegt den Fremd-Zaehler um 0 (ihre Allokationen liegen auf dem Achsen-Default).
     * (K-3, Segment-Kohaerenz) derselbe Beweis einmal ueber run_workload_segmented_v2 (die 3. Treiber-Stelle; :666), damit alle drei Stellen abgedeckt sind (run_workload_segmented teilt den Aufbau — Abdeckung 2/3 direkt + strukturgleiche 3. per identischem Muster; alle drei werden per grep-Wache im Review belegt: `EffectiveSearchAlgo algo;` == 3 Treffer, `SearchAlgo algo;` == 0).
   - Fassaden-Wache mitziehen: `search_algo_name_is_allocator_invariant_v<Fassade, FremdAlloc>` (search_algo_rebind.hpp:109-111) fuer die Test-Familie — name()/binary_id-Reise bleibt allokator-invariant.

## (d) COMMIT-SCHNITT (3 Commits, JE Commit das VOLLE Gate)

- **PB-1** = C1 (traversal_for_search_algo.hpp + Familien-TU-Symmetrie-Pin + Kommentar-Reste flags.hpp.in/CMakeLists). ctest-N erwartet: unveraendert (Basis am Commit-Objekt LIVE erheben; Ausgangs-Erwartung 402).
- **PB-2** = C2 (tier_to_organ_mapping.hpp Substanz-Wurzel + organ_for_search_algo_shaped.hpp 3. Parameter + abi_adapter :2235/:2243-2244 Konsum + Level-0/Level-1-Pins). ctest-N: unveraendert (402). Der konstitutiv riskanteste Schnitt — golden-320 3/3 + Roundtrip sind HIER der Substanz-Beweis (Praezedenz: 02a-Store-Faden landete golden-neutral).
- **PB-3** = C3 (abi_adapter Include + Klassen-Alias + Rebound-Wache + 3 Treiber-Ersetzungen + Kontrast-TU + CMakeLists-Target). ctest-N: +1 (erwartet 403 — am Commit-Objekt erheben, NICHT am warmen Bau ablesen; Falle real, Ledger vormittag-1: warmer build-e24 zeigte 401 statt 400 durch untracked Vorgaenger-TU).
- Reihenfolge-Begruendung: PB-1 ist inert-konsumlos (Mapping-Schicht komplett, bevor irgendein Konsument Rebounds materialisiert), PB-2 stellt den konstitutiven Faden unter eigenes Gate, PB-3 ist der kleinste, sauber isolierte G8-Flaechen-Diff mit seinem Beweis IM SELBEN Commit.
- GATE JE COMMIT (bindend): Voll-Bau (build-e24 warm; -j MAX 8, nice) + 2x voll-ctest SERIELL + golden-320 3/3 + Roundtrip + TABU-diff LEER (golden_fullpilot_320*, permutation_axes.xml, cache_engine_axis_registry.xml, system_axis_registry.xml, CRC-Anker, binary_id, fingerprint_format=2) + Working-Tree-Freeze + diff-stat dokumentiert + cf22 NUR echtes Binary /home/comdare/tools/cf22/usr/bin/clang-format-22 MIT Datei-Argumenten ueber den vollen Commit-Diff (nie ohne Datei-Argumente — stdin-Haenger) + 3-Marker-grep in Zeilenanfangs-Form + ASCII-only-Selbstcheck der ADDED-Zeilen + .d-Datei-Detektor (grep /usr/include/boost ueber den Bau-Baum) bei Include-Wachstum.
- ORT/DISZIPLIN: /home/comdare/wt-e24, Branch **phase-b-treiber ab b09ebb8a NEU** (aktuell steht wt-e24 auf s5-05q-queuing @ fce1274f, tree-identisch — Branch trotzdem explizit ab b09ebb8a anlegen). KEIN Push, KEIN Merge (Landung ist Lead-Sache nach Review).

## (e) RISIKEN + G8-GRENZEN (was NICHT angefasst werden darf)

1. **G8/ABI (abi_adapter.hpp = ABI-Flaeche):** IAnatomyBase/IMeasurableWorkload/IObservableTier-Overrides — Reihenfolge/Signaturen EINGEFROREN (u.a. :406-:412, :434-:437, :537-:539, :637-:639); PODs/Wire TABU (SegmentAccumulator :419-421 ist Mess-intern, NICHT anfassen; ComdareSegmentLatencyV1/V2-Layouts TABU). Erlaubt sind AUSSCHLIESSLICH: 1 Include, 1 Klassen-using + 1 static_assert (Klassen-Ebene, kein Member, kein Byte), 6 Body-Zeilen (:443/:444, :548/:549, :663/:666), 2 Trait-Argument-Stellen (:2235/:2243-2244). KEINE neue virtuelle, KEIN Member, KEINE Reihenfolge-Aenderung.
2. **golden-Neutralitaet:** Die 3 Treiber-Stellen liegen KOMPLETT unter `#if COMDARE_MEASUREMENT_ON` (:433..:935) — CI-Gesamtlauf/golden = Messung AUS. Fuer Mess-Builds gilt der Level-0-is_same-Vorrang (search_algo_rebind.hpp:72-78): Default-Kompositionen materialisieren weiter EXAKT die Fassade (kein neuer Symbolname auf dem golden-Pfad). PB-2 beruehrt den konstitutiven Pfad: Typ-Identitaet fuer Alloc=Exgen ist per Konstruktion gegeben (Store-Defaults) und wird je Familie compile-hart gepinnt; Verhaltens-Pin-Klasse "Rebind aendert Strategie, nie Algorithmus" (01c-2, 4/4) gilt; golden 3/3 + CRC-Anker je Commit sind der Beweis. XML-Regeneration findet NICHT statt (F30-Guard: type_name der Fassaden byte-identisch; Rebounds/Alloc-Formen tragen KEIN ORGAN_LOCATION und duerfen keins bekommen).
3. **CT-Doktrin:** kein std::variant, kein Runtime-Switch, keine type-erasure (Wiedergaenger-Kommentar search_algo_rebind.hpp:18-31 gilt woertlich — der T6-Messpfad vertraegt keine Indirektion je Allokation).
4. **Doppelwurzel:** topics/.../composable/tier_to_organ_mapping.hpp (5-Zeilen-Weiterleitung) NICHT anfassen; ebenso topics/traversal-Weiterleitungsheader generell.
5. **Ehrliche Grenzen (deklarieren + als Posten registrieren, NICHT bauen):** (i) organ_hull_-Kompositionen (Observable*Organ als search_algo, z.B. art_paper_binding_reference) bleiben Level-2 — kein rebind am Hull; (ii) anatomy_execution_context.hpp bleibt einarmig; (iii) original_*-CODEGEN-Pfade bleiben T6-blind (EV-4, faithful).
6. **Fallen-Kanon aktiv:** ninja -t commands-Modul-Scan-Falle bei allen Compile-Biss-Nachweisen; warmer-Bau-N-Falle (N NUR am Commit-Objekt); Boost-Link-Falle bei JEDEM Include-Wachstum (CI-Job-Form mit frischem Configure ist der einzige lokale Beweis); cf22 nie ohne Datei-Argumente; 3-Marker-grep in Zeilenanfangs-Form (naiver grep liefert ~729 Kommentar-Trennlinien); h81-Klasse bei etwaigen neuen CRTP-Weiterleitern in der Test-Strategie (self-proving static_asserts).
7. **Job-Sperre/Betrieb:** KEIN Push/Merge/Remote-Touch aus dieser Phase; Messung (Phase 6) bleibt USER-GO-STOPP; nach Phase B folgt EIN ANKER-Vollzug (Pause-Doc Par.3 Punkt 2).
8. **Rest-Unschaerfe (Bauer verifiziert am Objekt, NIE raten):** (i) exakte Wiederverwendbarkeit einer bestehenden Zaehl-Strategie-Probe aus den S7-/01c-TUs; (ii) ob MasstreeOrgan-Alias trivial mitziehbar ist; (iii) exakte Zeilen verschieben sich durch PB-1/PB-2 — vor jedem Edit frisch greppen.
