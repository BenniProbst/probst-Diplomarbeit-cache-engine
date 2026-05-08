# STRUKTUR_NOTIZ — P04 CoCo-trie (aboffa/CoCo-trie)

**Paper:** P04 — Boffa/Ferragina/Tosoni/Vinciguerra 2024 — "CoCo-trie: Data-aware compression and indexing of strings" (Information Systems 120, 2024)
**Repo:** `aboffa/CoCo-trie`
**Lokal:** `Forschungsarbeiten/code/P04-CoCo-trie/CoCo-trie/`
**Lizenz:** GNU GPL v3 (Architekt-Direktive 2026-05-08: GPL-3.0 KEIN Hinderungsgrund — modularisierte Bruchstuecke + C++23-Metaprogrammierung = neues Werk; akademische Nutzung im Forschungskontext erlaubt)
**Voranalyse:** `_voranalyse_output_klasse_a/P04-CoCo-trie__CoCo-trie.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (Author = Antonio Boffa, Co-Autor des Papers) |
| Originalpaper-Code? | JA |
| C++-Standard (CMake) | C++20 (`set(CMAKE_CXX_STANDARD 20)`) |
| Build-System | CMake (CMakeLists.txt 34 Zeilen, sehr klein); benoetigt `git submodule update --init --recursive` + Hilfs-Skript `lib/adapted_code/move.sh` |
| Compiler-Anforderungen | GCC mit C++20-Support; build_test.yml im `.github/` |
| ISA-Anforderungen | popcnt (1 Datei), prefetch (3 Dateien); SIMD eher nebensaechlich, fokus auf succinct |
| Externe Abhaengigkeiten | **sdsl-lite** + **sux** (Sebastiano Vigna succinct utilities) + **ds2i** als Submodule |
| LOC (gesamt source) | 24 191 (davon 17 959 = `test/catch.hpp` Catch2 Single-Header-Framework) |
| Top-LOC-Datei (eigentlicher Code) | `include/uncompacted_trie.hpp` (809), `include/CoCo-trie_v1.hpp` (479), `include/CoCo-trie_v2.hpp` (389), `include/CoCo-trie_dfuds.hpp` (350) |

## 2. Verzeichnis-Hierarchie

```
CoCo-trie/
├── benchmark.cpp / example.cpp
├── include/
│   ├── CoCo-trie_v1.hpp / _v2.hpp / _dfuds.hpp   — drei CoCo-trie-Varianten
│   ├── alphabet_remapping.hpp                    — Alphabet-Reduktion
│   ├── array.hpp                                 — Array-Typ
│   ├── dfuds.hpp                                 — Depth-First Unary Degree Sequence
│   ├── louds_sux.hpp                             — LOUDS-Wrapper (sux-basiert)
│   ├── uncompacted_trie.hpp                      — Vorstufe (uncompressed Trie)
│   ├── synthetic.hpp                             — Synthetische Daten-Erzeugung
│   ├── utils.hpp / MAX_L_config.h                — Hilfen + Tuning-Parameter
├── lib/
│   ├── adapted_code/                             — angepasste Bibliotheken (bit_vector, broadword, compact_elias_fano, intrinsics, Vector)
│   ├── ds2i/                                     — Submodule
│   ├── sdsl-lite/                                — Submodule
│   └── sux/                                      — Submodule
├── dataset/, script/, static/, test/
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | nicht klassisch — succinct trie als Bit-Sequenz | `dfuds.hpp`, `louds_sux.hpp` |
| **2 Node** | **Compressed/Compacted Subtrie-Knoten**; pool von succinct encoding schemes (DFUDS, LOUDS, etc.) | `CoCo-trie_v1.hpp`, `_v2.hpp`, `_dfuds.hpp` |
| **3 Traversal** | succinct rank/select-Operationen statt Pointer-Dereferenzen | `dfuds.hpp`, `louds_sux.hpp` |
| **4 ValueHandle** | Strings als komprimierte Sequenzen | `CoCo-trie_v*.hpp` |
| **5 MemoryLayout** | **Succinct Bit-Vector** + **Compact Elias-Fano** Kompression | `lib/adapted_code/bit_vector.hpp`, `compact_elias_fano.hpp` |
| **6 Allocator** | Standard, da succinct-Layout den Hauptteil ausmacht | (implizit) |
| **7 Prefetch** | 3 Dateien mit prefetch-Treffern; nicht aggressives Prefetching | (grep) |
| **8 Concurrency** | KEINE Treffer fuer RCU/OLC/Hazard — single-threaded read-only Index | (single-threaded) |
| **9 ISA** | popcnt (1 Datei) — typisch fuer succinct rank/select | `lib/adapted_code/intrinsics.hpp` |
| **10 Measurement** | `benchmark.cpp` (125 LOC), eigene Test-Suite mit Catch2 | `benchmark.cpp` |
| **11 Telemetry-Strategy** | nicht ausgepraegt | — |

**Hervorhebung:** CoCo-trie ist die einzige Klasse-A-Quelle mit **succinct rank/select + LOUDS + DFUDS + Elias-Fano** Kombination. Ist Konzept-Quelle fuer Architekt-Beschluss F3 (SDSL C++23-Portierung).

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **Code-Adapter MOEGLICH** — Architekt-Direktive 2026-05-08 erlaubt GPL-3.0-Bruchstuecke als modulare Bausteine. Bausteine_Matrix verweist `PAGE_MACRO_COCO` und `NODE_MACRONODE_COCO` und `TRAVERSAL_MACRO_NODE` auf `ext/P04-CoCo-trie/CoCo-trie/`. |
| Compiler-Layering (F-EXTRA-1) | Bausteine-Internals werden mit GCC 11+ (CoCo-trie's Original-Compiler fuer C++20) kompiliert; Modul-Wrapper bleibt C++23. KEIN „Aufwertung von C++20 nach C++23" der Originalcode-Bausteine. |
| Lizenz-Vermerk | NOTICE-Datei (GPL-3.0) bereits erstellt (Task #73) — als Originalcode-Quelle gefuehrt. |
| sdsl-lite-Beziehung | sdsl-lite (Submodule in CoCo-trie) ist parallel als F3-Beschluss eigene C++23-Portierung (Task #105 `comdare-succinct`); COCO-Bausteine koennen gegen die portierte Lib verlinkt werden |
| LEGACY_REIMPL-Bedarf | **NEIN** — Adapter-Pfad direkt moeglich. Eine eigenstaendige `comdare-succinct`-Lib (Task #105) ergaenzt das Bausteine-Inventar um sdsl-Konzepte, ersetzt aber nicht den CoCo-Adapter. |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★★★ | Aktive Wartung, GitHub Actions, Software Heritage Archive Badge |
| Doku-Qualitaet | ★★★★ | README ausfuehrlich (7.6 KB), CITATION.cff, codemeta.json (FAIR-Metadaten) |
| Test-Abdeckung | ★★★★ | umfangreiche Tests (`tests_entire_trie_*`, `tests_serialize_load`, `tests_single_encoders_128`) |
| Ueberein­stimmung mit Originalpaper | ★★★★★ | Author = Co-Autor des Papers; Reference Implementation |
| Adapter-Aufwand | ★★★ — Bausteine-Internals mit GCC 11+ kompilieren, statisch in C++23-Modul-Wrapper linken (F-EXTRA-1) |
| **Bauszenario** | **Quelle:** GPL-3.0 succinct-trie in C++20 → **Ziel:** Modul-Wrapper in C++23 mit GCC 11+ kompilierten Originalcode-Bausteinen → **Aenderung:** keine im Originalcode (Habich-Direktive: exakt kopiert); Adapter-Header in `adapters/P04-CoCo-trie/` re-exportiert die Bausteine via Concept-Constraints |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) CMake-Build mit Submodulen (sdsl-lite + sux + ds2i) — Originalcode-Bauteil | OFFEN — Phase 6 |
| (c) Testsuite-Lauf | OFFEN — Phase 6 |
| (d) Adapter-Build im COMDARE-Modul-Wrapper (F-EXTRA-1 Compiler-Layering) | OFFEN — Phase 6 |

## 7. Offene Punkte / Beobachtungen

- **GPL-3.0 — Architekt-Direktive 2026-05-08 (Re-Verifikation 2026-05-09):** GPL-3.0 ist KEIN Hinderungsgrund. Modularisierte Bruchstuecke + C++23-Metaprogrammierung erzeugen ein neues Werk. Korrektur der ersten Fassung dieses Dokuments, die GPL-3.0 als Distribution-Block darstellte.
- **sdsl-lite Submodule:** Originalcode-Bauteil von CoCo-trie. Parallel-Aufgabe Task #105 (eigene `comdare-succinct` C++23-Lib) erweitert sdsl-Konzepte, ersetzt aber nicht den CoCo-Adapter.
- **`.gitmodules` mit 3 Eintraegen (sdsl-lite, sux, ds2i):** muessen vor dem Originalcode-Build initialisiert werden — andernfalls schlaegt der Bauteil fehl.
- **MAX_L-Konfiguration (`include/MAX_L_config.h`):** „Maximum Length"-Tuning-Parameter — relevant fuer F2-Schluessel-Laenge der PRT-ART.
- **DFUDS-Encoding-Verfahren (`include/dfuds.hpp` 131 LOC):** sehr kompakt — gute Studienvorlage.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P04-CoCo-trie__CoCo-trie.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (GPL-3.0, Originalcode-Quelle, Copyright Boffa et al.)
- **Bausteine_Matrix:** `PAGE_MACRO_COCO` → ext/P04-CoCo-trie/CoCo-trie/; `NODE_MACRONODE_COCO`; `TRAVERSAL_MACRO_NODE`. Auch Achse 5 MEMORY_LAYOUT_SUCCINCT-Konzept (P04+P10).
- **Re-Impl. Modul:** kein Klasse-B-Skelett; Adapter direkt einbindbar via Compiler-Layering (F-EXTRA-1). `comdare-succinct` (Task #105) ist parallele Eigenleistung fuer sdsl-Konzept-Erweiterungen.
