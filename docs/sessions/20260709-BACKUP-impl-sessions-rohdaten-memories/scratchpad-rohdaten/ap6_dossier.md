# DOSSIER AP-6 / #240 — Allokator-Profil-Vollabdeckung (13 fehlende XML) + ehrliches SOTA/Allokator-Coverage-Gate (ABI-NEUTRAL)

> **Für Codex** (`--sandbox workspace-write`, `xhigh`). Arbeite DIREKT als EIN Agent — KEINE Sub-Agenten.
> §6 vollständig umsetzen, §4 strikt. **NICHT committen, keine git-Operationen.** Bei Unerfüllbarkeit: STOPP + §8.

## 1. Auftrag
(a) Die **13 fehlenden Allokator-Profil-XMLs** anlegen (Allokator-Abdeckung 10→23), Metadaten STRIKT aus
autoritativer Repo-Quelle. (b) Ein **rein-lesendes Coverage-Gate** (Test) ergänzen, das SOTA- UND Allokator-
Abdeckung ehrlich prüft — inkl. der #170-Entscheidung, dass P08/P09/P33 KEINE Profile sind.

## 2. Substanz + WARUM die SOTA-Seite NICHT „gefüllt" wird
`algorithm_profiles/sota/` hat 30/33 (P01-P07, P10-P32). **P08/P09/P33 wurden von #170 BEWUSST NICHT als
Profil angelegt** (`docs/sessions/20260620-HANDOUT-impl-an-text-agent-170-sota-vollabdeckung-P33.md`): P08
(OLC) + P09 (LOUDS) = abstrakte Achsen-Sätze (Wrapper existiert, in Profilen konsumiert) → „kein halbes
Tier"; P33 (VAMPIR/SPP2377) = thesis-survey, an Text-Agent. → AP-6 legt diese 3 NICHT an, sondern **deklariert
sie ehrlich als Nicht-Profile** im Gate. Die Allokator-Profile hingegen sind reale Daten-Vervollständigung
(Wrapper + Metadaten existieren bereits) — konsistent mit den 10 bestehenden Allokator-XMLs von #170.

## 3. Scope
- **IN:** 13 Allokator-`*.profile.xml` (`algorithm_profiles/allocators/`) + 1 Coverage-Gate-Test + CMake-Reg.
- **OUT (`// AP-6-Follow:` / Ledger):** echtes `is_original`-Linking der Allokatoren (= Task #19/#685);
  SOTA-P08/P09/P33-Profile (= #170-Entscheidung, NICHT anlegen); P33-thesis-Klärung (Text-Agent);
  veraltete READMEs (separat); Parser-Verdrahtung von `allocators/` (Discovery = separater Task, falls gewünscht).

## 4. HARTE Auflagen (Verstoß = Abbruch)
1. **KEINE FABRIKATION:** jede Metadatenzeile (name/authors/year/venue/doi/license/repo) MUSS aus einer der
   Repo-Quellen (§5.3) stammen. Fehlt ein Feld dort → Feld WEGLASSEN oder leer, NICHT erfinden.
2. **#170 EHREN:** KEINE neuen `sota/*.profile.xml` (insb. NICHT P08/P09/P33). Nur `allocators/` + Test.
3. **ABI-NEUTRAL:** reine `.xml` + rein-lesender Test. NICHT anfassen: `COMDARE_ANATOMY_ABI_MAJOR`/POD/
   extern-C, `permutation_axes.xml` (die 16-Wert-Allokator-Enum-Achse — separater Namensraum!), Registry/
   mp_list, `golden_fullpilot_320_binary_ids.txt`, `source_catalog.hpp`-320-Katalog, `modules/**`, `ext/**`
   (Original-Code). `family_ref="Axx"` ist Paper-Referenz-Metadaten — NICHT mit der Build-Enum vermengen.
4. **SCHEMA-TREUE:** neue Allokator-XMLs exakt im Schema der bestehenden (`allocators/hoard.profile.xml`,
   `allocators/jemalloc.profile.xml`): Wurzel `<comdare_allocator_profile id=".." family_ref="Axx">` +
   `<metadata>` + `<axes>` (granularity/numa/thread_local/fragmentation_strategy/thread_safety) + `<abi>`
   (`<c_api>` Pflicht) + `<expected_workload>`. Achsen-Werte plausibel je Allokator (aus dem Wrapper-Header
   `allocators/families/aXX_*/` ableiten, NICHT raten wo unklar → neutralen Default nehmen + Kommentar).
5. Kein `git`.

## 5. Kartierung (verifiziert)
- **5.1 Ziel-Verzeichnis:** `libs/cache_engine/algorithm_profiles/allocators/` — 10 vorhandene
  (`hoard/michael_lockfree/mimalloc/jemalloc/tcmalloc/snmalloc/scalloc/rpmalloc/lrmalloc/dlmalloc`).
- **5.2 A-Nummern-Kanon + Fehlliste:** `ext/allocator/REPOS_OVERVIEW.md` (A01-A23; die 13 nicht-geklonten
  in der Nicht-geklont-Tabelle) + die Code-Struktur `libs/cache_engine/include/cache_engine/allocators/families/aXX_*/`
  (autoritative A-Nummer↔Wrapper). **13 FEHLEN:** A02 Slab · A09 NUMAlloc · A12 CAMA · A13 StarMalloc ·
  A14 TCMalloc-Warehouse · A15 HMalloc · A16 PIM-malloc · A17 Crystalline · A18 Exgen-Malloc · A19 Buddy ·
  A21 ptmalloc2 · A22 N3916/PMR · A23 Vmem+Magazines. (A17 Crystalline ggf. nicht in PAPER_REFERENCES §2 —
  dann Metadaten aus REPOS_OVERVIEW/Wrapper-Header; fehlt alles → minimal + ehrlich „unknown".)
- **5.3 Metadaten-QUELLEN (autoritativ, NUR diese):** `libs/cache_engine/axes/alloc/PAPER_REFERENCES.md` §2
  (Z.10-36: je Wrapper Algorithmus·Paper·Venue/Jahr·DOI·Lizenz — z.B. SlabAllocator=USENIX Summer 1994,
  BuddyAllocator=CACM 1965, CAMA=ECRTS 2011, StarMalloc=OOPSLA 2024, NUMAlloc=ISMM 2023, HMalloc=ICPADS
  2019, PIM-malloc=HPCA 2026, Exgen=IEEE CAL 2025, ptmalloc2=LGPL, N3916=WG21/C++17, VmemMagazines=USENIX
  ATC 2001, TCMallocWarehouse=OSDI 2021/ASPLOS 2024) + `ext/allocator/REPOS_OVERVIEW.md` + die Wrapper-Header
  in `allocators/families/aXX_*/`.
- **5.4 Coverage-Test-Vorlage:** `tests/unit/thesis_tiere/test_validate_profile.cpp` (rein-lesend, gleicher
  Harness) + Verzeichnis-Scan via `libs/common/serialization/xml_config_parser` (`load_sota_profiles`). Reg:
  `tests/unit/CMakeLists.txt` (`comdare_add_test`).

## 6. Soll-Umsetzung
### 6.1 Die 13 Allokator-XMLs
- Zuerst `allocators/families/` LISTEN (welche aXX_-Dirs existieren) + `REPOS_OVERVIEW.md` + `PAPER_REFERENCES.md §2`
  lesen → exakte 13er-Liste (A-Nr↔Wrapper↔Metadaten) bilden.
- Je fehlendem Allokator eine `allocators/<name>.profile.xml` (Dateiname = Kurzname wie bestehende:
  `slab.profile.xml`, `numalloc.profile.xml`, `cama.profile.xml`, `starmalloc.profile.xml`, `tcmalloc_warehouse.profile.xml`,
  `hmalloc.profile.xml`, `pim_malloc.profile.xml`, `crystalline.profile.xml`, `exgen.profile.xml`, `buddy.profile.xml`,
  `ptmalloc2.profile.xml`, `pmr_resource.profile.xml`, `vmem_magazines.profile.xml`) im §4.4-Schema, Metadaten
  aus §5.3. `<expected_workload>` = YCSB_A..F (wie bestehende). Kommentar-Zeile mit der Metadaten-Quelle je Datei.
### 6.2 Coverage-Gate `tests/unit/thesis_tiere/test_profile_coverage.cpp` (+ `comdare_add_test`)
Rein-lesend (kein DLL-Bau), analog `test_validate_profile.cpp`:
- **SOTA:** `sota/`-Dir scannen → `paper_ref`-Menge; ASSERT die 30 code-mappbaren {P01-P07, P10-P32} sind
  vorhanden; die 3 {P08,P09,P33} als **erwartete Nicht-Profile** dokumentiert prüfen (ASSERT sie sind NICHT
  als sota-Profil vorhanden — die #170-Invariante festnageln, mit Kommentar-Referenz auf das #170-Handout).
- **Allokator:** `allocators/`-Dir scannen → `family_ref`-Menge; ASSERT {A01..A23} **vollständig** (23/23
  nach dem Fill). Bei Lücke → FAIL mit Liste.
- Pfad-Auflösung CWD-robust (Repo-Root via bekannter Marker/`COMDARE`-Env oder relativ zum Test — wie die
  anderen thesis_tiere-Tests). Ausgabe: „SOTA 30/30 code-mappbar + 3 deklarierte Nicht-Profile; Allokator 23/23".

## 7. Verifikation (PFLICHT — Codex, literal)
- Coverage-Test bauen+laufen (thesis_tiere-Harness, z.B. eigener cl/cmake-Aufruf wie `build_sota_pilot.ps1`
  ODER als ctest falls registrierbar) → `[ PASSED ]` literal + „Allokator 23/23" + „SOTA 30 + 3 Nicht-Profile".
- `git status --short allocators/` zeigt 13 neue `??`. Kein bestehendes sota/-Profil verändert. Kein Commit.

## 8. Ausgabe an Claude
(a) 13 neue XML-Dateien (Liste + je A-Nr + Metadaten-Quelle); (b) Bestätigung KEINE Fabrikation (jede Zeile
quellenbelegt) + KEINE SOTA-Profile angelegt (#170 geehrt); (c) Coverage-Gate-Logik + literales PASSED
(23/23 Allokator, 30+3 SOTA); (d) ABI-Neutralität; (e) etwaige Metadaten-Lücken (ehrlich „unknown" statt erfunden).
