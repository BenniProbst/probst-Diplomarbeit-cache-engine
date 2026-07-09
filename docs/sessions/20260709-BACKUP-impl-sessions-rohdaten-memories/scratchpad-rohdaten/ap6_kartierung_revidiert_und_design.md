# AP-6/#240 REVIDIERT — Kartierung (Explore a30cda73, 2026-07-04) + Design-Entscheidungen

## Kern-Befunde (verifiziert, file:line)
1. **SOTA-Schema** `sota/art.profile.xml`: `<comdare_algorithm_profile id paper_ref>` + `<metadata>`(name/authors/year/venue/doi, DEKORATIV) + `<axes>`(11: page/node/traversal/value_handle/concurrency/allocator/prefetch/telemetry/isa/layout/reclamation) + `<key_value_signature>` + `<expected_workload>`. Wurzel-Attr NUR `id`+`paper_ref`. Parser-Struct `AlgorithmProfile` xml_config_parser.hpp:49-57 = {id,paper_ref,axes-map,key/value_types,expected_workload,allocator_override}. **KENNT `pruefling_type` NICHT.**
2. **30 sota-Profile**, P08/P09/P33 FEHLEN (Beleg …P33.md:8, README.md:19-27). Ziel 33/33 = +P08/P09/P33.
3. **pruefling_type (#171)** NUR auf `<sota_series>` (thesis_profiles), abgeleitet aus merge (Stufe1=full, Stufe2/3=abstract) via sota_catalog.hpp:238-249. NICHT am sota-Profil. → für „abstract-Profil P08/P09" ist **Parser-Erweiterung nötig** (AlgorithmProfile + parse_profile, ADDITIV, ABI-neutral).
4. **prt-art-Profil** `comdare-prt-art/prt_art/algorithm_profiles/prtart_pruefling.profile.xml` = FULL-Form (alle 11 Achsen mit eigenen PRTART_*-Organen + pruefling_status/hybrid_api_modes/pruefling_metrics). KEINE „nur-Achsen-Referenz"-Vorlage im Repo.
5. **P08=OlcOptimisticConcurrency** axis_08 → `axes/concurrency_axis/axis_08_concurrency_olc.hpp` (Doc18:66/281/382). **P09=PackedBitmapMemoryLayout** axis_05 → `axes/layout/axis_05_memory_layout_packed_bitmap.hpp` (Doc18:127/383). Beide Organe existieren als Code → abstraktes Profil zeigt via `<concurrency>`/`<layout>` darauf.
6. **P33 = VAMPIR-Poster** `Forschungsarbeiten/hardware/vampir-poster-spp2377-p1-kickoff.pdf` (1 Seite). Agent hat es VOLL gelesen: Projektstruktur-Kickoff (WP1-6, V-malloc, NFP-API, Mitglieder, Xeon-Phi-SUT). **KEIN Algorithmus, KEIN Pseudocode, KEINE Datenstruktur.** „Haargenauer Nachbau" faktisch UNMÖGLICH (nichts zu reproduzieren). Repo-Aussage deckungsgleich (REPO_INVENTAR_FINAL.md:53, …P33.md:16/23-27).
7. **Allokator-Schema** `allocators/hoard.profile.xml`: `<comdare_allocator_profile id family_ref>` + metadata(+license/repo) + axes(granularity/numa/thread_local/fragmentation_strategy/thread_safety) + abi(c_api[+cpp_overload]) + expected_workload. **13 fehlen: A02,A09,A12-A19,A21,A22,A23.** Metadaten `PAPER_REFERENCES.md §2` Z.9-36; A17 Crystalline FEHLT in §2 (nur REPOS_OVERVIEW.md:48, URL pending → ehrlich „unknown").
8. Alle 23 `families/aXX_*`-Dirs + `axes/alloc/axis_06_allocator_<name>.hpp` existieren → axes-Werte ableitbar.
9. **Coverage:** Verzeichnis-Scanner = `XmlConfigParser::load_sota_profiles` (xml_config_parser.hpp:187/.cpp:100-107). Nur sota/ verdrahtet (experiment_driver.cpp:152-157). **`allocators/` wird von KEINEM Parser geladen** (nur Doku) → 23/23-Gate braucht neuen Dir-Scan. CMake: thesis_tiere-Standalone `add_executable`+`add_test` (Vorlage test_harness_compile CMakeLists:1659-1674) ODER gtest `comdare_add_test`.
10. **P33-Text/Metadaten** auch als `docs/termine/.../P33-VAMPIR-Berthold2023.md` + `.txt`.

## Design (revidiert #170) — Vorschlag
- **Parser-Erweiterung (ABI-neutral):** optionales `pruefling_type="abstract"` am `<comdare_algorithm_profile>` → AlgorithmProfile+parse_profile additiv (default ""=full).
- **P08 `sota/olc.profile.xml`**: paper_ref=P08, pruefling_type=abstract, `<concurrency>OLC</concurrency>` + Baseline-Rest, Metadaten Doc18 (DaMoN2016/DEBULL2019, 10.1145/2933349.2933352), Annotation „abstrakter Prüfling-Marker → axis_08 OlcOptimisticConcurrency".
- **P09 `sota/louds.profile.xml`**: paper_ref=P09, abstract, `<layout>PACKED_BITMAP</layout>` + Baseline, Metadaten Jacobson FOCS1989 (10.1109/SFCS.1989.63533), Annotation → axis_05 PackedBitmapMemoryLayout.
- **P33 `sota/vampir.profile.xml`**: paper_ref=P33, abstract, **ehrliche Annotation „Kickoff-Poster ohne Algorithmus → kein Nachbau möglich; NFP-Konzept-Marker"** (KEINE fabrizierte Datenstruktur). ← USER-BESTÄTIGUNG offen.
- **13 Allokator-XMLs** A02/A09/A12-19/A21-23 aus §2 (+A17 ehrlich unknown).
- **Coverage-Gate** (read-only Test): sota/-Scan → paper_ref {P01..P33} == 33/33; allocators/-Scan → family_ref {A01..A23} == 23/23. + CI-contract-Job (Verify infra-gated).

## OFFENE USER-RÜCKFRAGE
P33-Poster hat KEINEN Algorithmus → „haargenau nachbauen" = müsste fabriziert werden (verboten). Empfehlung: P33 als **ehrlicher abstrakter Konzept-Marker** (wie P08/P09), mit Annotation. Bestätigung nötig.
