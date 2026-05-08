# STRUKTUR_NOTIZ — P06b bart-master (Cross-Algorithm-Vergleichsbasis)

**Paper:** P06 — Schmeisser/Schuele/Leis/Neumann/Kemper 2022 — Begleit-Code-Sammlung mit ART, BART, B²Tree, BTree, HAT-Trie, PBTreeStatic-Varianten
**Repo:** Erhaltener Code-Drop, 2026-05-08 (Begleitsammlung zu b2-tree-master)
**Lokal:** `Forschungsarbeiten/code/P06-B2tree/bart-master/`
**Lizenz:** **KEINE LICENSE-Datei** — PENDING formell (Task #74). Architekt-Direktive 2026-05-08: keine-Lizenz im akademischen Forschungskontext zulaessig. Vendored cpp-btree-1.0.1 ist Apache-2.0 — getrennt im NOTICE auszuweisen.
**Voranalyse:** `_voranalyse_output_klasse_a/P06-B2tree__bart-master.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (Begleit-Drop zur b2-tree-master Veroeffentlichung) |
| Originalpaper-Code? | JA (Cross-Algorithm-Vergleichsbasis fuer B²-Tree-Paper) |
| C++-Standard (CMake) | C++17 (`set(CMAKE_CXX_STANDARD 17)`) |
| Build-System | CMake (42 Zeilen) + Makefile (2 Zeilen) — Mehrkanal-Build |
| Compiler-Anforderungen | GCC-modern (Datei-Datum 2019-12-05) |
| ISA-Anforderungen | impliziert SSE/AVX (prefetch in 5 Dateien) |
| Externe Abhaengigkeiten | `cpp-btree-1.0.1/` (Google's cpp-btree) als Vendored-Code, `lib/`, `third_party/` |
| LOC (gesamt source) | 11 996 (ohne `cpp-btree-1.0.1/btree.h` 2 394 LOC = ca. 9 600 eigentlicher Code) |
| Top-LOC-Datei | `bart.cpp` (1 652) — die BART-Hauptimpl. |

## 2. Verzeichnis-Hierarchie + Datei-Klassifikation

| Datei | LOC | Algorithmus | Bemerkung |
|-------|-----|-------------|-----------|
| `ART.cpp` | 685 | klassisches ART | Vergleichs-Baseline |
| `bart.cpp` | 1 652 | **BART (B-Tree+ART-Hybrid)** | Paper-Hauptbeitrag (Kandidat) |
| `b2tree_int.cpp` | 833 | B²-Tree mit Integer-Keys | Variante zu b2-tree-master |
| `btree.cpp` | 293 | klassischer B-Tree | Vergleichs-Baseline |
| `hattrie.cpp` | 701 | **HAT-Trie** (HashArray-Mapped-Trie) | Konzept-Vorlage fuer Hash-Hybrid |
| `pbtreestatic.cpp` | 448 | Static B-Tree (kompiliert für feste Daten) | Konzept-Vorlage |
| `pbtreestatic_opt.cpp` | 575 | Static B-Tree mit Optimierungen | Vergleichsvariante |
| `pbtreestatic_trie.cpp` | 1 240 | **Static B-Tree mit Trie-Suche innerhalb Page** | Hochrelevant |
| `pbtreestaticart.cpp` | 924 | **Static B-Tree mit ART innerhalb Page** | Hochrelevant — direkte PRT-ART-Vorlage! |
| `profile.cpp` | 139 | Profiling | — |
| `cpp-btree-1.0.1/btree.h` | 2 394 | Google cpp-btree (vendored) | Apache-2.0-Lizenz aus cpp-btree |
| `bench.sh` | — | Benchmark-Treiber | — |

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | **PageBartHybrid_P06**, **PageHATTrie_P06**, **PagePBTreeStatic_P06**, **PagePBTreeStaticOpt_P06**, **PagePBTreeStaticTrie_P06**, **PagePBTreeStaticArt_P06** — sechs Page-Varianten direkt vergleichbar! | je `<algo>.cpp` |
| **2 Node** | **NodeBartHybrid_P06**, **NodeHATTrieHashBucket_P06**, **NodePBTreeStaticNode_P06** | `bart.cpp`, `hattrie.cpp`, `pbtreestatic*.cpp` |
| **3 Traversal** | **TraversalBartHybridDispatch_P06**, **TraversalHATTrieHashThenTrie_P06**, **TraversalPBTreeStaticPrefetch_P06** | `bart.cpp`, `hattrie.cpp`, `pbtreestatic_trie.cpp` |
| **4 ValueHandle** | uint64_t (Integer-Variante), Zeiger (Variant-abhaengig) | je nach Datei |
| **5 MemoryLayout** | **Static B-Tree** Layouts (kompiliert fuer feste Datenmenge) — sehr nah am paper-Konzept "Layout-Invariant" | `pbtreestatic*.cpp` |
| **6 Allocator** | Standard-`new`; cpp-btree fuer btree-Variante | (implizit) |
| **7 Prefetch** | **5 Dateien mit prefetch** — sehr aktiv, gerade in pbtreestatic_*.cpp | grep |
| **8 Concurrency** | nicht primaer — Single-Thread Compare-Suite | — |
| **9 ISA** | popcnt nicht im grep, prefetch ja | (grep) |
| **10 Measurement** | `bench.sh` + `profile.cpp` (139 LOC) | `bench.sh`, `profile.cpp` |
| **11 Telemetry-Strategy** | Counter (3 Dateien grep) | grep |

**Hervorhebung — Cross-Algorithm-Vergleichsbasis (Task #84):**
- bart-master ist die einzige Klasse-A-Quelle, die ART, B-Tree, B²-Tree, BART, HAT-Trie, PBTreeStatic, PBTreeStatic+Trie, PBTreeStatic+ART als **Same-Workload-Vergleichsbasis** anbietet.
- Direkter Konzept-Vorlauf der PRT-ART ist **`pbtreestaticart.cpp`** (924 LOC) — Static B-Tree mit ART-Innenstruktur. Sehr zu studieren.
- **`bart.cpp`** (1 652 LOC) — BART = B-Tree+ART-Hybrid; der genaue Hybrid-Mechanismus ist Konzept-Quelle fuer PRT-ART.

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **Code-Adapter MOEGLICH** — Architekt-Direktive 2026-05-08 erlaubt keine-Lizenz im Forschungskontext. Bausteine_Matrix listet alle BART-MASTER-Bausteine direkt mit Code-Pfad. |
| Compiler-Layering (F-EXTRA-1) | Bausteine-Internals mit GCC 9+ (Paper-Original-Compiler); Modul-Wrapper C++23 |
| Cross-Algorithm-Vergleich | bart-master ist **Bauszenario-Vorlage**: PRT-ART soll im Phase-7-Experiment-Loop genau diesen Cross-Algorithm-Vergleich automatisieren — der Code ist bereits Vergleichs-Suite |
| Lizenz-Vermerk | NOTICE (PENDING — keine LICENSE) + cpp-btree (Apache-2.0) muss separat erfasst werden |
| Concurrency | nicht uebernommen (single-threaded Suite); concurrency aus P01/P02 nehmen |
| LEGACY_REIMPL-Bedarf | **NEIN** — alle 8 Algorithmus-Varianten (ART, BART, B²Tree, BTree, HAT-Trie, PBTreeStatic, PBTreeStatic+Trie, PBTreeStatic+ART) als Originalcode-Bausteine direkt einbindbar |
| Bausteine_Matrix-Verankerung | ✅ erledigt (Task #84): BART-MASTER-BONUS Bausteine in Achse 1, 2, 3 dokumentiert; Pfade `ext/P06-B2tree/bart-master/<algo>.cpp` |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★ | Datei-Datum 2019-12, kein erkennbarer Wartungs­zyklus seitdem |
| Doku-Qualitaet | ★ | KEIN README, KEINE Architektur-Doku, KEINE LICENSE |
| Test-Abdeckung | ★ | KEIN Test-Verzeichnis sichtbar; nur `bench.sh` und `profile.cpp` |
| Ueberein­stimmung mit Originalpaper | ★★★★★ | Cross-Algorithm-Vergleichsbasis, exakt was das Paper benoetigte |
| Adapter-Aufwand | ★★★ — Flat-File-Struktur, Vendored cpp-btree (Apache-2.0); Bauteile separat als Bausteine kompilierbar |
| **Bauszenario** | **Quelle:** Cross-Algo-Vergleichsbasis ohne Lizenz/Doku → **Ziel:** Originalcode-Bausteine in Bausteine_Matrix als Cross-Algorithm-Vergleichsbasis → **Aenderung:** keine im Originalcode; Wrapper in `adapters/P06-B2tree-bart/<algo>.hpp` exportiert je Algorithmus die Concept-Bindung. Phase-7-Experiment-Loop iteriert ueber alle 8 Bauteile. |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) Lizenz-Klaerung (formell) | OFFEN — Task #74; fachlich nicht blockierend |
| (c) CMake-Build der 8 Algorithmus-Bausteine mit GCC 9+ | OFFEN — Phase 6 |
| (d) Cross-Algo-Vergleich-Lauf zum Paper-Reproduce | OFFEN — Phase 7 |

## 7. Offene Punkte / Beobachtungen

- **KEINE LICENSE — Architekt-Direktive 2026-05-08 (Re-Verifikation 2026-05-09):** akademische Nutzung im Forschungskontext zulaessig. cpp-btree-1.0.1 hat Apache-2.0 (separat im NOTICE ausweisen).
- **`pbtreestaticart.cpp` 924 LOC:** **direkte konzeptuelle Vorlage** fuer PRT-ART (Static B-Tree + ART-Inner). Lesen!
- **`bart.cpp` 1 652 LOC:** BART (B-Tree+ART-Hybrid) ist eigene Hybrid-Form. Vermutlich der Paper-Beitrag.
- **`hattrie.cpp` 701 LOC:** HAT-Trie — Konzept fuer Hash-then-Trie-Pfade.
- **`pbtreestatic_trie.cpp` 1 240 LOC:** Static B-Tree mit Trie-Suche innerhalb Page — Konzept-Vorlage fuer Page-internen Trie.
- **Vendored cpp-btree:** Apache-2.0; muss in NOTICE separat erfasst werden.
- **Datei-Mix `.cpp` ohne Header:** untypisch — alle Algorithmen sind Single-File-Programme. Erschwert Adapter, aber gut fuer Re-Impl.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P06-B2tree__bart-master.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (KEINE LICENSE — akademische Nutzung gemaess Architekt-Direktive 2026-05-08; cpp-btree Apache-2.0 separat)
- **Bausteine_Matrix:** ✅ Task #84 erledigt — `PAGE_BART_HYBRID_P06`, `PAGE_HATTRIE_P06`, `PAGE_PBTREESTATIC_P06`, `PAGE_PBTREESTATIC_OPT_P06`, `PAGE_PBTREESTATIC_TRIE_P06`, `PAGE_PBTREESTATIC_ART_P06` + Node + Traversal-Bausteine
- **Re-Impl. Modul:** kein LEGACY_REIMPL — Originalcode-Bausteine direkt einbindbar via Compiler-Layering (F-EXTRA-1)
- **Email-Tracking:** Task #74 (formelle Lizenz-Klaerung)
- **Cross-Algorithm-Vergleich-Strategie:** Phase 7 wird die paper-Reproduktion durch eigene Cross-Algorithm-Loop ersetzen
