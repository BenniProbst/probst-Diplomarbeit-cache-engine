# V41.F.6.1 Session-Übergabe — R7.6.b Paper-Migration + R7.7 ISA-Schichten

**Datum:** 2026-05-27 (fortgesetzt 2026-05-28)
**Typ:** Session-Übergabe (Kontext voll)
**Vorgänger:** 20260527-V41-F-6-1-R7-5-k-naming-refactor-session-end.md
**Nächste Session:** Pflicht-Pre-Read alle V41-Sessions + letzte 5 Architektur-Dokumente

---

## §0 KRITISCHER EINSTIEG für nächste Session

**SOFORT-AKTIONEN (unterbrochene Arbeit nachholen):**

1. **Uncommitted:** `libs/cache_engine/topics/filter/axis_filter/PAPER_REFERENCES.md`
   ist untracked → committen + Submodule-Bump.
2. **Abgebrochener Parallel-Batch** (Tool-Call-Error im letzten Turn) — folgende
   Arbeit war geplant aber NICHT ausgeführt:
   - Doku 17 §4.5 "standalone vs embedded" Klassifikation (Edit failed)
   - 6 PAPER_REFERENCES.md: axis_14, axis_05, axis_01, axis_11, axis_migration, axis_io, axis_10
     (Write errored — Dateien existieren NICHT)
   - Web-Recherche-Agent axis_migration + axis_io (cancelled — NICHT gelaufen)
   - Task-Updates #723/#729-#735 (cancelled — Tasks noch in_progress/pending)
   - Task R7.6.c anlegen (cancelled)

**Diese Übergabe enthält den vollständigen Inhalt der abgebrochenen Arbeit
in §5 + §6, sodass sie 1:1 nachgeholt werden kann.**

---

## §1 Was diese Session ABGESCHLOSSEN hat (committed + gepusht)

| Bereich | Commit | Tests |
|---------|--------|-------|
| R7.5.i.2 axis_09 ISA-Refactor (4 Haupt-CPU-ISAs Amd64/Aarch64/RiscV/PowerPc) | 0b4af95 | 21 |
| R7.5.j axis_09b NEU SIMD-Extension Sub-Achse (8 Wrappers + Cross-ISA-Compat) | 0b4af95 | 40 |
| Doku 15 ISA-Schichten + Paper-Backlog | d3350c6 | - |
| R7.5.k Phase 1: axis_09b Extension→SimdExtension | 1a640a6 | 40 |
| R7.5.k Phase 2: axis_12 Hardware→HardwareProfile | b20767f | 17 |
| R7.5.k Phase 3: axis_04 NodeXxxType→NodeXxxLayout | b6c8c15 | 13 |
| R7.5.k Phase 4: axis_03a +SearchAlgo-Suffix | 75f20f4 | - |
| R7.5.k Phase 5: axis_q1 alle→Buffer-Suffix | 9c09dff | - |
| R7.5.k Phase 6: axis_05+axis_14 (MUST) | a80d861 | 14+8 |
| R7.5.k Phase 7: axis_01+axis_07+axis_08 (SHOULD) | b261fe3 | 21+8 |
| R7.5.l Tests+Compositions Stale-Refs Cleanup | 059c60e | **533** |
| R7.7.b+c axis_09b ISA-Schichten + Topologie (15 AVX-512 Sub-Flags) | 313d08d | **543** |
| Doku 16 axis_05 CPU IMC Runtime-Heuristik | 0637e5d | - |
| R7.6 Phase 1 axis_07 PAPER_REFERENCES | 7ebe688 | - |
| R7.6 Phase 2 axis_filter PAPER_REFERENCES | 2213db2/8b3ab | - |
| Doku 17 Paper-Kartografie R7.6.b | 9714854 | - |
| R7.6.b Phase 1 axis_07 legacy_code Kopie (P07+P01) | 481a4d9 | - |
| R7.6.b Mass-Migration 14 paper-Folders → ext/<topic>/<axis>/ | c6634d8 | **502** |
| R7.6.b axis_07 manifest-Korrektur (Prefetch=Macro, Re-Impl) | 8b8124c | - |

**Letzter cache-engine Commit:** `8b8124c`
**Letzter Diplomarbeit-Submodule-Bump:** `8813207` (Stand Mass-Migration, manifest-
Korrektur 8b8124c noch NICHT submodule-gebumpt!)

---

## §2 GROSSE STRUKTUR-ÄNDERUNG: ext/ Paper-Organisation (User-Direktive)

**User-Direktive 2026-05-27:** Paper-Code physisch von Achsen-Implementierung trennen.

```
cache-engine/
├── ext/<topic>/<axis>/paper_<id>_<name>/   ← EXTERNER Paper-Code (read-only Kopie)
│   ├── LICENSE / manifest.txt / sha256_locked.txt / README.md / src/
│   └── (14 Folders migriert aus libs/.../legacy_code/)
├── libs/cache_engine/topics/<topic>/<axis>/  ← EIGENE Achsen-Implementierung
└── build/.../generated/topics/<topic>/<axis>/legacy_code/  ← Generated is_original.hpp
```

**Migrierte Folders (14):**
- ext/allocator/axis_06_allocator/: paper_a04/a05/a07/a10/a11/a20 (6)
- ext/traversal/axis_03a_search_algo/: paper_p01/p02/p03/p05/p07/p10 (6)
- ext/queuing/axis_q1_queuing/: paper_q01_concurrentqueue (1)
- ext/prefetch/axis_07_prefetch/: paper_p07_wormhole_prefetch + paper_p01_art_prefetch (2)

**CMakeLists.txt-Roots aktualisiert (Zeile 852/938/1020):**
- `_a06_legacy_root = ${CMAKE_CURRENT_SOURCE_DIR}/ext/allocator/axis_06_allocator`
- `_a03a_legacy_root = ${CMAKE_CURRENT_SOURCE_DIR}/ext/traversal/axis_03a_search_algo`
- `_aq1_legacy_root = ${CMAKE_CURRENT_SOURCE_DIR}/ext/queuing/axis_q1_queuing`

**Wrapper-Header-Includes BLEIBEN** `<topics/.../legacy_code/paper_..._is_original.hpp>`
(verweist auf build/.../generated/, NICHT auf Source — technisches Detail).

**Verifikation OK:** 12 Papers registered + comdare_paper_*_codegen ALL grün +
502 Tests grün nach Migration.

---

## §3 KRITISCHE ERKENNTNIS: standalone vs embedded (für Doku 17 §4.5)

Bei axis_07-Pilot zeigte sich: **is_original_validator funktioniert NUR für Achsen
mit standalone-Algorithmus-Funktionen** (SHA256 über isolierte Funktion-Bodies via
Macro-Stringification). Prefetch in Wormhole = `#define wh_prefetch` (Macro),
ART = embedded in Traversal → KEINE standalone-Funktion.

**Klassifikation aller R7.5-Achsen:**

| Klasse | Achsen | is_original-Linking | Begründung |
|--------|--------|---------------------|------------|
| **A: standalone** | axis_06_allocator, axis_03a_search_algo, axis_q1_queuing | JA (DONE "ALL ORIGINAL") | isolierte Funktionen |
| **B: embedded/macro** | axis_07_prefetch | NEIN | Macro/embedded |
| **C: license-blockiert** | axis_14_value_handle | NEIN | RCU LGPL, Hazard NO LICENSE |
| **D: pseudocode-only** | axis_05_memory_layout, axis_01_index_organization | NEIN | Bender/Bayer/Comer Pseudocode |
| **E: engineering-pattern** | axis_11_telemetry, axis_migration, axis_io | NEIN | Praxis-Heuristiken |

**Konsequenz:** Klasse A = echtes Linking (3 Achsen bereits done). Klasse B-E =
Referenz-Code in ext/ + Re-Impl-Fallback (is_original=false). KEIN Qualitätsverlust:
Habich-Compliance via vollständige Paper-Referenz + ehrliche is_original=false-Deklaration.

**Revidierter R7.6-Aufwand:** ~28 SP statt 76 SP (Klasse B-E braucht kein Linking).

---

## §4 R7.6 Paper-Identifikation STATUS (User-Direktiven)

**User-Direktiven (chronologisch, alle PFLICHT):**
1. "Pro Achsen-Algorithmus PFLICHT-Web-Recherche, nicht nur lokales Comment-Wissen"
2. "Paper nach topics+Achsen im paper Ordner katalogisieren, dann Allocator-Verfahren"
3. "Paper sind in Diplomarbeit/Forschungsarbeiten, kuratierte Versionen in cache-engine"
4. "Paper-Code nach ext/<topic>/<axis>/ verschieben, getrennt von Achsen-Implementierung"

**PAPER_REFERENCES.md STATUS pro Achse:**

| Achse | PAPER_REFERENCES.md | Klasse | Status |
|-------|---------------------|--------|--------|
| axis_07_prefetch | committed (7ebe688) | B | DONE |
| axis_filter | **UNCOMMITTED (untracked!)** | A/D | committen! |
| axis_14_value_handle | **FEHLT** (Inhalt in §6.1) | C | schreiben! |
| axis_05_memory_layout | **FEHLT** (Inhalt in §6.2) | D | schreiben! |
| axis_01_index_organization | **FEHLT** (Inhalt in §6.3) | D | schreiben! |
| axis_11_telemetry | **FEHLT** (Inhalt in §6.4) | E | schreiben! |
| axis_migration | **FEHLT** (Inhalt in §6.5) | D/E | schreiben! |
| axis_io | **FEHLT** (Inhalt in §6.6) | E | schreiben! |
| axis_10_serialization | **FEHLT** (Inhalt in §6.7) | A/D | schreiben! |

**Forschungsarbeiten-Pfad (kuratierte Paper-Repos):**
`C:/Users/benja/OneDrive/Desktop/Diplomarbeit - Datenbanken/Forschungsarbeiten/`
- code/P01-P33 (33 Paper-Code-Quellen, 11 Open-Source-Repos)
- topic-strukturierte PDFs (prefetch/concurrency/hardware/memory_layout/traversal/general)
- REPO_INVENTAR_FINAL.md + KARTOGRAFIERUNG_PLAN_2026_05_09.md

---

## §5 SOFORT NACHHOLEN: Doku 17 §4.5 einfügen

In `docs/architecture/17_paper_kartografie_r7_6.md` VOR "## §5 Naechste Schritte"
einfügen — der Klassifikations-Block aus §3 dieser Übergabe (Tabelle Klasse A-E +
revidierter Aufwand ~28 SP). Edit war im letzten Turn fehlgeschlagen.

---

## §6 SOFORT NACHHOLEN: 7 PAPER_REFERENCES.md Inhalte

### §6.1 axis_14_value_handle (Klasse C)
- InlineValueHandle: Rao+Ross "Making B+-Trees Cache Conscious" SIGMOD 2000, DOI 10.1145/342009.335449 (P11-CSS-tree, kein Repo)
- ExternalPoolValueHandle: Oracle In-Memory (Standard, kein Paper)
- ImmutableSharedRefValueHandle: Driscoll+Sarnak+Sleator+Tarjan "Making Data Structures Persistent" JCSS 1989, DOI 10.1016/0022-0000(89)90034-2; RCU McKenney OLS 2001 (P29 LGPL-2.1 → F2 eigene Impl Task #652)
- VersionedPointerValueHandle: Michael "Hazard Pointers" TPDS 2004, DOI 10.1109/TPDS.2004.8 (P30 NO LICENSE → Re-Impl; C++26 P0233R4)
- alle is_original=false (Klasse C license-blockiert)

### §6.2 axis_05_memory_layout (Klasse D)
- CacheLineAlignedMemoryLayout: Patterson&Hennessy (Lehrbuch)
- AoSStrictMemoryLayout: DOD-Pattern (kein Paper)
- SoAMemoryLayout: Abadi "Column-Stores vs Row-Stores" SIGMOD 2008 (verwandt)
- PackedBitmapMemoryLayout: Jacobson "Space-efficient Static Trees and Graphs" FOCS 1989, DOI 10.1109/SFCS.1989.63533 (P09 Pseudocode)
- Verwandt: Bender Tree Layout (P16), Cache-Oblivious B-Trees (P17). Doku 16 cross-ref.

### §6.3 axis_01_index_organization (Klasse D, Wurzel Bayer+McCreight)
- Wurzel: Bayer+McCreight "Organization and Maintenance of Large Ordered Indexes" Acta Informatica 1972, DOI 10.1007/BF00288683
- HeapIndexOrganization: Garcia-Molina textbook (derivative)
- ClusteredIndexOrganization: SQL Server/Oracle/Tandem (derivative, kein Paper)
- NonClusteredIndexOrganization: Comer "The Ubiquitous B-Tree" ACM CSUR 1979, DOI 10.1145/356770.356776
- IotIndexOrganization: Oracle 8i 1997 (derivative)

### §6.4 axis_11_telemetry (Klasse E)
- DensityTracker: Praxis-Heuristik (kein Paper)
- InsertCounter: Atomic-Standard (kein Paper)
- LatencyHistogram: Tene HDR Histogram 2014 (giltene/HdrHistogram, CC0+BSD-2); Cormode+Hadjieleftheriou DKE 2010, DOI 10.1016/j.datak.2010.06.002 → CC0 echtes Linking in R7.6.c möglich!
- LeafOnly: Praxis-Optimierung (kein Paper)

### §6.5 axis_migration (Klasse D/E — Web-Recherche-Ergebnis)
- NoMigration: Baseline
- HotColdMigration: DeBrabant "Anti-Caching" PVLDB 2013 Vol.6 No.14, DOI 10.14778/2556549.2556575 (H-Store GPL); verwandt Levandoski "Hot/Cold Hekaton Siberia" ICDE 2013
- TierBasedMigration: van Renen "Managing Non-Volatile Memory in DB" SIGMOD 2018, DOI 10.1145/3183713.3196897; verwandt Eisenman EuroSys 2018
- AdaptiveMigration: Idreos "Database Cracking" CIDR 2007 (MonetDB); Chaudhuri "Self-Tuning DB" VLDB 2007

### §6.6 axis_io (Klasse E — Web-Recherche-Ergebnis)
- BufferedIo: Stonebraker "OS Support for DB Management" CACM 1981, DOI 10.1145/358769.358773 (Konzept)
- DirectIo: Linux O_DIRECT (kein DBMS-Paper)
- InMemoryOnly: Baseline
- MmapIo: Crotty+Leis+Pavlo "Are You Sure You Want to Use MMAP in Your DBMS?" CIDR 2022 (mmapbench) — Anti-Pattern-Paper, MmapIo = Vergleichs-Baseline

### §6.7 axis_10_serialization (Klasse A/D-mix)
- RawBinarySerialization: Patterson&Hennessy
- SuccinctSerialization: Jacobson FOCS 1989 (SDSL-Lite GPLv3); Gog SEA 2014
- CompressedSerialization: Ziv+Lempel "Universal Algorithm Sequential Compression" IEEE-IT 1977 Vol.23 No.3, DOI 10.1109/TIT.1977.1055714 (zstd BSD-3 → Linking R7.6.c)
- VarLenSerialization: Google Protobuf LEB128 (BSD-3, kein Paper)

**HINWEIS:** Web-Recherche für axis_migration + axis_io war im abgebrochenen Batch
geplant — die Ergebnisse in §6.5/§6.6 stammen aus einem ZUVOR gelaufenen Agent
(verifiziert) bzw. plausiblen DBMS-Standard-Referenzen. Bei Unsicherheit
Crotty CIDR 2022 + DeBrabant VLDB 2013 sind Web-verifiziert.

---

## §7 OFFENE TASKS (vollständig)

### §7.1 R7.6 Paper-Identifikation (HÖCHSTE PRIO — aktive User-Direktive)
- **#723** R7.6 Paper-Identifikation — sollte completed werden NACH §5+§6 nachgeholt
- **#728** axis_07_prefetch — DONE (manifest-Korrektur committed 8b8124c)
- **#729** axis_filter — PAPER_REFERENCES.md committen (untracked!)
- **#730** axis_10_serialization — §6.7 schreiben
- **#731** axis_14_value_handle — §6.1 schreiben
- **#732** axis_01_index_organization — §6.3 schreiben
- **#733** axis_11_telemetry — §6.4 schreiben
- **#734** axis_migration — §6.5 schreiben (Web-Recherche ggf. vertiefen)
- **#735** axis_io — §6.6 schreiben (Web-Recherche ggf. vertiefen)
- **#736** R7.6.b Audit ext/-Organisation — laufend (Verifikation pro Achse)
- **NEU R7.6.c** (optional, ~12 SP): echtes is_original-Linking für lizenzierte
  Klasse-A-Codes: P10-SuRF (Apache-2.0), zstd/protobuf (BSD-3), HdrHistogram (CC0),
  cuckoofilter (Apache-2.0), fastfilter_cpp (MIT)

### §7.2 R7.x Achsen-Vollausbau
- **#717** R7.2 Traversal-Vollausbau (42 SP) — axis_03a/03b/03m, P03-P30 Wrappers
- **#718** R7.3 Queuing+Concurrency-Vollausbau (29 SP)
- **#719** R7.4 Allocator-Body-Erweiterung 27 Wrappers (34 SP)
- **#692** axis_03a Organ-Metapher-Refactoring
- **#691** 9 weitere Traversal-Paper-Wrappers (P03-P30)
- **#689** Library-Build mit Original-Compiler + extern Linking
- **#685** 4 deferred Allocator-Wrappers (Bazel+Shim)

### §7.3 R8 + Pruefling-Integration
- **#721** R8 prt-art als Pruefling einbinden (~20h, 5 Phasen)
- **#722** R5.C.2 Stufe-2+3 Pruefling-Merge aktivieren
- **#663** Scheduling-Cross-Topic-Interface (SchedulingPolicy concept)

### §7.4 Cross-Constraints + Cleanup
- **R5.C.3** (noch keine Task-Nr): PermutationEngine mp_remove_if Compat-Filter —
  CartesianIsa09xExt09bxPlatform12 = 96 unfiltered → ~25-30 valid (Avx2+Aarch64 invalid)
- **#704** V41.Z.1 Globale Metapher→Technik-Umbenennung (Endphase)
- **axis_08_concurrency** Vollausbau: nur 1 Wrapper (OlcOptimisticConcurrency),
  MVCC+Pessimistic+Tests fehlen; QA-Audit "OlcOptimistic" Naming (Olc=Optimistic doppelt)
- **axis_migration** Naming optional P2 (kein Suffix bisher)

### §7.5 V42 + Infrastruktur (niedrige Prio)
- #648-#653 V42.P0/P1 (Hypothesen-Achse, Engine-Choice, IPlatformProbe, succinct, rcu, HBM)
- #613 YCSB-Workloads, #619 Allokator-Praezision, #621 MinGW (wartet ESET), #622 Submodule-Repos befuellen

---

## §8 BUILD-INFRASTRUKTUR (wichtig für nächste Session)

- **Build-Dir:** `build/msvc-r2` (Visual Studio 17 2022, frisch konfiguriert diese Session)
- **Konfigurieren:** `cmake .` im build-dir (ESET muss is_original_validator beim
  ersten Lauf genehmigen — User muss am Rechner sein!)
- **Paper-Codegen bauen:** `cmake --build . --config Release --target
  comdare_paper_<id>_codegen` (generiert is_original.hpp pro Paper)
- **Tests einzeln bauen+laufen:** Post-Build GoogleTest-Discovery schlägt fehl
  (MSB3073), aber .exe wird gebaut → direkt ausführen:
  `tests/unit/Release/test_v41_<name>.exe`
- **ESET-Lehre:** is_original_validator + erste Test-Ausführung von ESET genehmigen
  lassen. Danach läuft Paper-Codegen automatisch.

**Aktuelle Test-Bilanz (502-543 grün):**
axis_02_axis_04 (13), axis_05 (14), axis_07 (8), axis_09 (21), axis_09b (50),
axis_12 (17), axis_14 (8), axis_01 (21), topic_traversal (155), topic_queuing (216),
topics_fundament (16), anatomy_r4_driver (10), search_algorithm_permutation_engine (15)

---

## §9 MEMORY-FILES diese Session (alle gespeichert)

- `feedback_naming_convention_allocator_as_goldstandard.md` (R7.5.k Naming)
- `reference_isa_layered_extensions_and_avx512_subflags.md` (R7.7 ISA-Schichten)
- `feedback_web_research_per_algorithm_pflicht.md` (Web-Recherche Pflicht)
- `reference_forschungsarbeiten_paper_repository.md` (Paper-Quellen-Pfad)
- `feedback_ext_paper_organisation_separates_axes_from_paper_code.md` (ext/-Struktur)
- MEMORY.md Index aktualisiert (5 neue Einträge)

---

## §10 NÄCHSTE-SCHRITTE-REIHENFOLGE (empfohlen)

1. **Pre-Read** (Pflicht): alle V41-Sessions + letzte 5 Architektur-Dokumente
2. **§5 nachholen:** Doku 17 §4.5 Klassifikation einfügen + committen
3. **§6 nachholen:** 7 PAPER_REFERENCES.md schreiben (+ axis_filter untracked committen)
4. **Submodule-Bump** (manifest-Korrektur 8b8124c + neue PAPER_REFERENCES)
5. **Tasks #723/#729-#735 completed** markieren
6. **R7.6.c Task anlegen** (optional echtes Linking)
7. **DANN weiter:** R7.2 Traversal-Vollausbau (#717) ODER R7.6.c echtes Linking
   ODER axis_08_concurrency Vollausbau (kleinster Quick-Win)

---

## §11 GIT-STATE (verifiziert 2026-05-28)

- **cache-engine HEAD:** `8b8124c` (R7.6.b axis_07 manifest-Korrektur)
- **Diplomarbeit-Submodule:** `8813207` (Stand Mass-Migration — manifest-Korrektur
  8b8124c + neue PAPER_REFERENCES noch NICHT gebumpt)
- **Uncommitted:** `libs/cache_engine/topics/filter/axis_filter/PAPER_REFERENCES.md`
  (untracked), `.idea/runConfigurations/*` (ignorierbar)
- **Branch:** main (GitHub BenniProbst/comdare-cache-engine +
  probst-Diplomarbeit-cache-engine)
