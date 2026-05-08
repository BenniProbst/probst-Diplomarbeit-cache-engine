# STRUKTUR_NOTIZ — Konsolidiertes Inventar (Klasse A + B + C)

**Phase 4.B-detail · OPEN-1 · Task #108** · TU Dresden Diplomarbeit PRT-ART
**Stand:** 2026-05-09 (REV 2 nach Re-Verifikation der Architektur-Schluesseldokumente)
**Bezug:** `KARTOGRAFIERUNG_PLAN_2026_05_09.md`

## Kritische Korrekturen REV 2 (2026-05-09)

Nach erneutem Lesen aller fuenf Architektur-Schluesseldokumente (`Habich_Feedback_2026_05_08.txt`, `Architekturentscheidungen_F1_F15.txt`, `Kuehn_Erkenntnisse_Einarbeitung_2026_05_09.txt`, `Begriffsglossar_v7_FINAL.txt`, `Bausteine_Matrix.txt`) wurden folgende Klassifikations-Fehler aus REV 1 korrigiert:

1. **Architekt-Direktive 2026-05-08 zu Lizenzen:** GPL-3.0/LGPL/keine-Lizenz sind KEIN Hinderungsgrund (modularisierte Bruchstuecke + C++23-Metaprogrammierung = neues Werk; akademische Nutzung im Forschungskontext erlaubt). REV 1 hatte das fehlerhaft als Distribution-Block interpretiert.
   → Korrekturen in: P04, P07, P25, P29, P06a, P06b, P30
2. **F-EXTRA-1 Compiler-Layering:** Hauptcompiler IMMER C++23, NUR Bausteine-Internals werden mit IHREM Original-Compiler kompiliert und statisch gelinkt. KEINE „Aufwertung von C++X auf C++23" der Originalcode-Bausteine.
   → Korrekturen in: P02, P03 (HOT, Masstree)
3. **F12-K betrifft CacheEngine-Lokation, NICHT Hazard-Pointers:** REV 1 hatte irrtuemlich „F12-K verbietet Hazard" geschrieben. Korrekt: Bausteine_Matrix Achse 8 listet OLC/ROWEX/RCU; Hazard ist nicht im aktuellen Permutations-Raum, aber kein Verbot.
   → Korrektur in: P30
4. **Achse 11 (Telemetry-Collection-Strategy, Kuehn 2026-05-09):** Bezuege ergaenzt fuer P05 (Tag-Manager ↔ RetroactiveAggregation) und P20 (Worker-Counter ↔ LeafOnlyCounter-Alternative).
5. **Production-Plattform Block AO:** Ryzen 9 9950X3D X3D-V-Cache + i9-14900KS Hybrid-CPU; Bezuege ergaenzt in P05 (Cache-Estimator) und P20 (cpu_core/cpu_atom-Trennung) und P25 (NUMA-Allocator-Tausch).

---

## 1. Klasse A — 13 geklonte Originalcode-Repos (KARTOGRAFIERT)

Alle 13 STRUKTUR_NOTIZ.md sind erstellt. Zugang via Repo-Pfad:

| P-ID | Repo | LOC | Original-Compiler-Std | Lizenz (akademisch OK) | Adapter via F-EXTRA-1? | Re-Impl. noetig? | STRUKTUR_NOTIZ.md |
|------|------|-----|---------|--------|---------|-------------------|-------------------|
| **P01** | unodb (laurynas-biveinis) | 31 052 | C++20 (GCC 10+) | Apache-2.0 | ✅ ja | ❌ nein | `P01-ART/unodb/STRUKTUR_NOTIZ.md` |
| **P02** | hot (speedskater) | 42 322 | C++14 (GCC 5+, BMI2/AVX2) | ISC | ✅ ja | ❌ nein | `P02-HOT/hot/STRUKTUR_NOTIZ.md` |
| **P03** | masstree-beta (kohler) | 14 990 | C++03/11 (GCC 4.6+) | MIT/W3C | ✅ via Autotools-Bridge | ⚠ Fallback wenn Bridge versagt | `P03-Masstree/masstree-beta/STRUKTUR_NOTIZ.md` |
| **P04** | CoCo-trie (aboffa) | 24 191 | C++20 (GCC 11+) | GPL-3.0 (akademisch OK) | ✅ ja | ❌ nein | `P04-CoCo-trie/CoCo-trie/STRUKTUR_NOTIZ.md` |
| **P05** | START (jungmair) | 1 493 | C++17 (GCC 7+) | MIT | ✅ ja | ❌ nein | `P05-START/START/STRUKTUR_NOTIZ.md` |
| **P06a** | b2-tree-master | 2 617 | C++17 (GCC 9+) | KEINE (akademisch OK) | ✅ ja | ❌ nein | `P06-B2tree/b2-tree-master/STRUKTUR_NOTIZ.md` |
| **P06b** | bart-master (Cross-Algo-Vergleich) | 11 996 | C++17 (GCC 9+) | KEINE (akademisch OK) | ✅ ja | ❌ nein | `P06-B2tree/bart-master/STRUKTUR_NOTIZ.md` |
| **P07** | wormhole (wuxb45) | 10 214 | C (GCC 7+, SSE4.2/CRC) | GPL-3.0 (akademisch OK) | ✅ ja (extern "C") | ❌ nein | `P07-Wormhole/wormhole/STRUKTUR_NOTIZ.md` |
| **P10** | SuRF (efficient) | 8 303 | C++11 (g++ -mpopcnt) | Apache-2.0 | ✅ ja | ❌ nein | `P10-SuRF/SuRF/STRUKTUR_NOTIZ.md` |
| **P20** | leanstore (FSU Jena) | 23 730 | C++20 (GCC modern) | MIT | ⚠ Konzept (zu viele Deps) | ❌ nein | `P20-BTreesAreBack/leanstore/STRUKTUR_NOTIZ.md` |
| **P25** | prefetching (HPI Mahling) | 17 044 | C++20 (GCC 11+) | KEINE (akademisch OK) | ✅ ja, Allocator-Achse via F4 | ❌ nein | `P25-Mahling-FillBuffer/prefetching/STRUKTUR_NOTIZ.md` |
| **P29** | userspace-rcu (Desnoyers/McKenney) | 31 228 | C (GCC 4+) | LGPL-2.1+ (Linkage erlaubt) | ⚠ F2-Beschluss eigene RCU | ✅ via Task #104 | `P29-RCU-McKenney/userspace-rcu/STRUKTUR_NOTIZ.md` |
| **P30** | haz_ptr (huangjiahua) | 453 | C++11 | KEINE (akademisch OK) | ⚠ Achse 8 listet kein Hazard | ❌ nein (nicht im Permutations-Raum) | `P30-Hazard-Pointers/haz_ptr/STRUKTUR_NOTIZ.md` |

### Cross-Reference Bausteine ↔ Repo

| Bausteine-Achse | Klasse-A-Quelle(n) |
|-----------------|---------------------|
| **1 Page** | P05 (Rewired64K/16M), P06a (B²-Tree-Page), P06b (PBTreeStatic-Varianten), P07 (Triple-Layer), P20 (Buffer-Pool-Page) |
| **2 Node** | P01 (Node4/16/48/256), P02 (HOT-Compound), P03 (Masstree-Border), P04 (CoCo-Compact), P06b (BART/HAT-Trie/PBTree-Static-Knoten), P10 (LOUDS-Dense/Sparse) |
| **3 Traversal** | P01 (path compression), P02 (Multi-Mask Partial-Key), P03 (slice-based), P06b (PBTree+Trie-Dispatch), P07 (Triple-Layer), P10 (rank/select) |
| **4 ValueHandle** | P01 (Template+QSBR), P03 (3 Varianten value_*) |
| **5 MemoryLayout** | P03 (Permuter), P04 (Succinct+Elias-Fano), P10 (LOUDS), P05 (Page-Rewiring) |
| **6 Allocator** | P03 (jemalloc/tcmalloc/Flow), P05 (LKM+mmap), P25 (NUMA+Fujitsu) |
| **7 Prefetch** | P02 (4-5 Dateien), P25 (35+43 Treffer, **Hauptquelle**), P07 (6 Dateien) |
| **8 Concurrency** | P01 (OLC+QSBR), P02 (ROWEX+Epoch), P03 (Permuter+Versioned), P06a (OLC+Epoch+Hazard), P07 (rwlock+QSBR), P20 (OCC+SI+MVCC), P25 (OLC+Coroutinen), P29 (6 RCU-Flavors) |
| **9 ISA** | P01 (SSE4.1+AVX2+AVX-512+NEON), P02 (popcnt+AVX-512), P07 (SSE4.2+CRC), P10 (popcnt+Fallback) |
| **10 Measurement** | P05 (Cache-Cost mfence/rdtsc/clflush), P25 (22 Mikrobenchmarks), P20 (Profiling-Tabellen) |
| **11 Telemetry-Strategy** | P05 (Tag-Manager), P20 (Counter-Suite, 53 Treffer) |

### Schluesselerkenntnisse Klasse A (REV 2)

1. **Architekt-Direktive 2026-05-08:** GPL-3.0/LGPL/keine-Lizenz sind im akademischen Forschungskontext zulaessig (modularisierte Bruchstuecke + C++23-Metaprogrammierung = neues Werk). KEIN Distribution-Block. Formelle Lizenz-Klaerung mit Authoren wuenschenswert (Task #74), aber nicht fachlich blockierend.
2. **F-EXTRA-1 Compiler-Layering:** Hauptcompiler IMMER C++23 (Modul-Wrapper). Originalcode-Bausteine werden mit ihren ORIGINAL-Compilern kompiliert (GCC 4.6 fuer Masstree, GCC 5+ fuer HOT, GCC 7+ fuer Wormhole, GCC 9+ fuer B²Tree, GCC 10+ fuer unodb, GCC 11+ fuer CoCo-trie und Mahling). Statisches Linking der Object-Files in den Modul-Wrapper.
3. **Direkte Adapter (alle 13)** technisch moeglich via F-EXTRA-1 Compiler-Layering. Einzelne Sonderfaelle: P03 Masstree benoetigt Autotools-Bridge; P20 leanstore hat zu viele Pakete (Konzept-Studie sinnvoller); P29 userspace-rcu via F2-Beschluss durch eigene RCU ersetzt.
4. **F12-K (CacheEngine-Lokation):** Heap-Singleton im Builder-Prozess — betrifft NICHT Hazard-Pointers (Klassifikations-Fehler in REV 1, korrigiert).
5. **F2-Beschluss eigene RCU:** P29 ist Konzept-Quelle, nicht Code-Lieferant; Task #104 — bleibt unveraendert.
6. **Bart-Master Cross-Algorithm-Vergleichsbasis (P06b):** liefert ART/B-Tree/B²-Tree/BART/HAT-Trie/PBTreeStatic-Familie als bereits implementierte Vergleichsbasis fuer Phase 7 — alle 8 Bauteile direkt einbindbar.
7. **Achse 11 (Telemetry-Collection-Strategy, Kuehn 2026-05-09):** Cross-Bezuege identifiziert in P05 (Tag-Manager ↔ RetroactiveAggregation) und P20 (Worker-Counter als Cache-Coherence-Anti-Pattern-Vermeidung). Hauptquelle bleibt P28 Kuehn (Klasse C).
8. **Production-Plattform Block AO (Ryzen 9 9950X3D + i9-14900KS, 64 GB DDR5-5600 CL36):** X3D-V-Cache-Asymmetrie (96+32 MiB L3) + Hybrid-CPU-Pflicht (cpu_core/cpu_atom getrennt) — Plattform-Adaptionen in P05 (Cache-Estimator), P20 (Counter-Suite), P25 (NUMA-Allocator-Tausch via F4) ergaenzt.

---

## 2. Klasse B — 14 LEGACY_REIMPL (kein Originalcode)

**Status (Update 2026-05-09):** Klasse-B-Skelette existieren physisch in `C:/Users/benja/OneDrive/Desktop/Projekte/Research/comdare-cache-engine/prt_art/legacy_reimpl/<paper>/README.md` (alle 14 vorhanden, Task #72). Zwei private GitHub-Repos sind 2026-05-09 angelegt (Task #110):
- https://github.com/BenniProbst/comdare-cache-engine (Library)
- https://github.com/BenniProbst/probst-Diplomarbeit-cache-engine (Diplomarbeit-Wrapper)

Die READMEs koennen jetzt direkt mit Pseudocode-Auszuegen erweitert werden.

| P-ID | Paper | Bausteine-Achse(n) | Pseudocode-Klarheit (★ 1-5) | Status STRUKTUR_NOTIZ |
|------|-------|--------------------|------------------------------|------------------------|
| P11 | CSS-tree (Rao/Ross 1999) | 1 Page (Cache-Sensitive Search) | ★★★★ | ⏳ Nach Repo-Setup |
| P12 | CSB+-tree (Rao/Ross 2000) | 1 Page + 5 Memory-Layout | ★★★★ | ⏳ Nach Repo-Setup |
| P13 | Hankins (2003) | 2 Node-Size | ★★★ | ⏳ Nach Repo-Setup |
| P14 | Samuel CSB-Conscious (2005) | 1 Page (Processor-Conscious) | ★★★ | ⏳ Nach Repo-Setup |
| P16 | Bender Tree Layout (2002) | 5 Memory-Layout | ★★★★★ | ⏳ Nach Repo-Setup |
| P17 | Bender Cache-Oblivious (2005) | 5 Memory-Layout (CO) | ★★★★★ | ⏳ Nach Repo-Setup |
| P18 | Saikkonen Multi-Level (2008) | 1 Page + 2 Node | ★★★ | ⏳ Nach Repo-Setup |
| P19 | Saikkonen Layout-Invariant (2016) | 5 Memory-Layout | ★★★ | ⏳ Nach Repo-Setup |
| P21 | Chen Prefetching B+ (2001) | 7 Prefetch | ★★★★ | ⏳ Nach Repo-Setup |
| P22 | Chen Fractal (2002) | 7 Prefetch (Fractal) | ★★★★ | ⏳ Nach Repo-Setup |
| P23 | Khan Adaptive Prefetch (2010) | 7 Prefetch (Adaptive) | ★★★ | ⏳ Nach Repo-Setup |
| P24 | NaderanTahan (2016) | 7 Prefetch | ★★ | ⏳ Nach Repo-Setup |
| P26 | Q. Zhang FGCS Prefetch (2024) | 7 Prefetch | ★★★ | ⏳ Email offen (Task #74) |
| P27 | T. Zhang ASPLOS Hierarchical (2025) | 7 Prefetch (Hierarchisch) | ★★★ | ⏳ Email offen (Task #74) |

### Klasse-B-Vorgehen nach Repo-Setup

1. Pseudocode-Auszug aus jedem Originalpaper-PDF extrahieren
2. In `prt_art/legacy_reimpl/<paper>/README.md` einbauen
3. Klarheits-Bewertung des Paper-Pseudocodes (★ 1-5) eintragen
4. Re-Impl. ist Aufgabe von Phase 6+ (Task #86)

---

## 3. Klasse C — 5 INSTITUTION_INTERN + 2 ORIGINALPAPER-KONZEPT

**Status:** Verweis-Eintraege; Code teilweise zugesagt, teilweise nicht zu erwarten.

| P-ID | Quelle | Status | Bemerkung |
|------|--------|--------|-----------|
| P09 | Jacobson 1989 LOUDS | ❌ NO-CODE (Originalpaper-Konzept) | SDSL-Lite als Drittanbieter-Inspiration via F3-Portierung (Task #105) |
| P15 | Graefe Survey 2001 | ❌ NO-CODE (Survey, kein Code) | Konzept-Verweise in Diplomarbeit |
| P28 | Kuehn DAMON 2023 | ⏳ ZUGESAGT (aufgeraeumt) | Email Roland Kuehn, Code-Drop nach Aufraeumen (Task #95) |
| P31 | Ungethuem TUD 2017 | ⏳ ANFRAGE OFFEN | Habich-Direktanfrage (Task #74) |
| P32 | Schmidt TUD 2025 (To Stride) | ⏳ ANFRAGE OFFEN | Habich-Direktanfrage (Task #74) |
| P33 | VAMPIR Poster 2023 | ⏳ ANFRAGE OFFEN | Habich-Direktanfrage (Task #74) |
| P08 | ART of Practical Synchronization (Leis 2016) | ✅ in P01-Repo (unodb-OLC) integriert | OLC+QSBR-Implementation in P01 |

---

## 4. Lieferungs-Status

| Lieferung Plan | Status | Bemerkung |
|----------------|--------|-----------|
| KARTOGRAFIERUNG_PLAN_2026_05_09.md | ✅ Erledigt | im selben Verzeichnis |
| Voranalyse-Skript (Bash, NO-PYTHON) | ✅ Erledigt | `_voranalyse_klasse_a.sh` |
| Voranalyse-Output (13 Dateien) | ✅ Erledigt | `_voranalyse_output_klasse_a/*.txt` |
| 13 × STRUKTUR_NOTIZ.md (Klasse A) | ✅ Erledigt + REV 2 | je Repo-Wurzel |
| Konsolidiertes UEBERSICHT.md (dieses Dokument) | ✅ Erledigt + REV 2 | jetzt |
| Re-Verifikation gegen Architektur-Schluesseldokumente | ✅ Erledigt 2026-05-09 | 6 Lizenz-Korrekturen + F-EXTRA-1 + F12-K + Achse 11 + Block AO |
| GitHub-Repos angelegt (Task #110) | ✅ Erledigt 2026-05-09 | 2 private Repos auf BenniProbst |
| 14 × Erweiterung der Skelett-READMEs (Klasse B) | ⏳ Naechster Schritt | Skelette existieren in `comdare-cache-engine/prt_art/legacy_reimpl/` |
| Verweis-Eintraege Klasse C | ✅ in diesem Dokument enthalten | Tabelle oben |

---

## 5. Bezug zu anderen Tasks

- **Task #80** (STRUKTUR_NOTIZ.md pro Repo) → durch dies erfuellt fuer Klasse A; Klasse B nach Repo-Setup
- **Task #79** (Adapter-Skelette) → kann jetzt mit Klasse-A-Erkenntnissen begonnen werden
- **Task #101** (Code-Qualitaets-Bewertung pro Bausteine-Quelle, Habich H2) → in jeder STRUKTUR_NOTIZ.md eingearbeitet (Abschnitt 5)
- **Task #110** (zwei private GitHub-Repos) → blockiert die physische Anlage von Klasse-B-Skeletten und Klasse-C-Code-Eintraegen
- **Task #104** (eigene RCU) → konzept-Quelle P29 dokumentiert
- **Task #105** (SDSL-Lite C++23-Portierung) → konzept-Quellen P04 + P10 dokumentiert
- **Task #84** (bart-master Cross-Algo-Vergleich) → P06b STRUKTUR_NOTIZ erfasst es vollstaendig

---

## 6. Naechste Schritte (in Reihenfolge, REV 2)

1. **OFFEN extern (Task #74):** Email-Antworten zu P06, P25, P26, P27, P28, P31, P32, P33 — formelle Lizenz-Klaerung; fachlich nicht blockierend
2. **JETZT moeglich:** 14 LEGACY_REIMPL READMEs in `comdare-cache-engine/prt_art/legacy_reimpl/<paper>/README.md` mit Pseudocode-Auszuegen erweitern (Skelette existieren physisch)
3. **Naechste Architekt-Aufgaben (Task #107, #99, #79):**
   - #107 F-EXTRA-5 KORREKTUR: Python-Codegen → CMake/Shell ersetzen
   - #99 PHASE 5 REV 2: Voll-detaillierte UML + ER-Modell (Habich H1)
   - #79 Adapter-Skelette in `adapters/<paper>/` fuer alle 13 Klasse-A-Repos
4. **Klasse C (nach Code-Erhalt):** P28-Code-Drop von Kuehn (Task #95) auswerten + in Klasse A einsortieren; Habich-Antworten zu P31/P32/P33
5. **Phase 6+ (Task #85-#88, #104, #105, #106):** PRT-ART Implementation, eigene RCU, SDSL-Portierung, HBM-Hierarchie, Permutations-Builds, LaTeX-Anhang
