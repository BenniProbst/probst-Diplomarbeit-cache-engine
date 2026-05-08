# STRUKTUR_NOTIZ — P06a b2-tree-master (Schmeisser/Schuele/Leis/Neumann/Kemper Code-Drop)

**Paper:** P06 — Schmeisser/Schuele/Leis/Neumann/Kemper 2022 — "B²-Tree: Cache-Friendly String Indexing within B-Trees" (BTW 2022 / TUM)
**Repo:** Erhaltener Code-Drop von einem TUM-Mitarbeiter, 2026-05-08 (kein oeffentliches GitHub-Repo bekannt)
**Lokal:** `Forschungsarbeiten/code/P06-B2tree/b2-tree-master/`
**Lizenz:** **KEINE LICENSE-Datei** — PENDING formell (Task #74). Architekt-Direktive 2026-05-08: keine-Lizenz im akademischen Forschungskontext zulaessig (modularisierte Bruchstuecke + C++23-Metaprogrammierung = neues Werk). Bausteine_Matrix listet bereits `PAGE_DECISION_B2TREE` und `PAGE_SPAN_B2TREE` auf `ext/P06-B2tree/b2-tree-master/`.
**Voranalyse:** `_voranalyse_output_klasse_a/P06-B2tree__b2-tree-master.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (privater Code-Drop am 2026-05-08) |
| Originalpaper-Code? | wahrscheinlich JA (PENDING Verifikation) |
| C++-Standard (CMake) | C++17 (`set(CMAKE_CXX_STANDARD 17)`) |
| Build-System | CMake (CMakeLists.txt 60 Zeilen) |
| Compiler-Anforderungen | nicht spezifiziert (kein README); GCC-modern impliziert |
| ISA-Anforderungen | AVX-512 (1 Datei) — optionale Optimierung |
| Externe Abhaengigkeiten | `third_party/`, `lib/` Unterordner (nicht voranalysiert) |
| LOC (gesamt source) | 2 617 — kompakt |
| Top-LOC-Datei | `src/tree.cpp` (1 387) |
| Datei-Mix | klassisch include/ + src/ getrennt |

## 2. Verzeichnis-Hierarchie

```
b2-tree-master/
├── include/
│   ├── BufferManager.hpp     — Buffer-Manager (Page-Verwaltung)
│   ├── Database.hpp          — Wrapper
│   ├── Page.hpp              — Page-Layout
│   ├── tree.hpp              — Tree-API
│   ├── search.hpp            — Such-Hilfen
│   ├── optimistic_lock.hpp   — OLC
│   ├── epoch.hpp             — Epoch-Based Reclamation
│   ├── hazard.hpp            — Hazard-Pointers (alternative MV-Strategie)
│   └── NonCopyable.hpp       — Hilfen
├── src/
│   ├── tree.cpp              (1 387 LOC) — B²-Tree-Algorithmus
│   ├── BufferManager.cpp     — Buffer-Manager-Impl.
│   ├── Database.cpp          — Database-API
│   ├── Page.cpp              — Page-Impl.
│   ├── bench.cpp (176 LOC)   — Benchmark
│   └── main.cpp              — Demo-Programm
├── test/test_tree.cpp        — Tests
├── lib/                      — Hilfsbibliotheken
└── third_party/              — Externe
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | **Page-Klasse** mit BufferManager-Verwaltung — "B²-Tree Within B-Trees" Paper-Schwerpunkt | `include/Page.hpp`, `src/Page.cpp` |
| **2 Node** | B²-Tree-Knoten als Subordnung innerhalb einer B-Tree-Page (B-Tree-mit-Trie-im-Page) | `src/tree.cpp` |
| **3 Traversal** | innerhalb-Page-Trie + Inter-Page B-Tree-Hierarchie | `include/search.hpp`, `src/tree.cpp` |
| **4 ValueHandle** | nicht prominent — wahrscheinlich `uint64_t`-Werte | (implizit) |
| **5 MemoryLayout** | **Cache-Friendly String-Layout** in Page (Paper-Hauptidee) | `include/Page.hpp` |
| **6 Allocator** | BufferManager als Page-Allocator | `include/BufferManager.hpp` |
| **7 Prefetch** | nicht im grep — implizit ueber Cache-Friendly-Layout | (durch Layout) |
| **8 Concurrency** | **OLC** + **Epoch** + **Hazard-Pointers** (alle drei!) | `include/optimistic_lock.hpp`, `epoch.hpp`, `hazard.hpp` |
| **9 ISA** | AVX-512 (1 Datei, optional) | (grep: 1) |
| **10 Measurement** | `src/bench.cpp` (176 LOC), `test/test_tree.cpp` | `src/bench.cpp` |
| **11 Telemetry-Strategy** | Counter (1 Datei grep) — wahrscheinlich Stats-Counter | (grep: 1) |

**Hervorhebung:** b2-tree-master ist die einzige Klasse-A-Quelle, die **alle drei** Concurrency-Strategien (OLC + Epoch + Hazard) parallel anbietet — wahrscheinlich als Vergleichsbasis im Paper.

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **Code-Adapter MOEGLICH** — Architekt-Direktive 2026-05-08 erlaubt keine-Lizenz-Code im Forschungskontext. Bausteine_Matrix verweist `PAGE_DECISION_B2TREE` und `PAGE_SPAN_B2TREE` auf diesen Repo. |
| Compiler-Layering (F-EXTRA-1) | Bausteine-Internals mit GCC 9+ kompiliert (Paper-Original-Compiler); Modul-Wrapper bleibt C++23 |
| Lizenz-Vermerk | NOTICE-Datei (PENDING) — formelle Klaerung wuenschenswert (Task #74), aber kein Block |
| Concurrency-Wahl | OLC + Epoch sind Klasse-A-Vorlagen — werden konzeptuell uebernommen; Hazard ist NICHT im aktuellen Bausteine-Permutations-Raum (Achse 8 listet OLC/ROWEX/RCU) |
| Page-Layout-Brueck­e | "Cache-Friendly String-Layout" ist Paper-Hauptidee → Konzept-Quelle fuer F1-Page; ABER `MEMORY_EMBEDDED_TREE` in Bausteine_Matrix Achse 5 verweist bereits direkt auf diesen Repo |
| LEGACY_REIMPL-Bedarf | **NEIN** — Adapter-Pfad direkt verfuegbar via Compiler-Layering; LEGACY_REIMPL-Skelett P06 entfaellt |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★ | Code-Drop, kein erkennbarer Wartungs­zyklus, keine Doku |
| Doku-Qualitaet | ★ | KEIN README, KEINE Architektur-Doku, KEINE LICENSE |
| Test-Abdeckung | ★★ | 1 Test-Datei (`test/test_tree.cpp` 91 LOC) |
| Ueberein­stimmung mit Originalpaper | ★★★★ (PENDING) | wahrscheinlich Reference Code, aber Verifikation der Lizenz/Authorship offen |
| Adapter-Aufwand | ★★★★ — Code-Struktur sauber (include/src/test), keine-Lizenz im Forschungskontext OK |
| **Bauszenario** | **Quelle:** B²-Tree-Code-Drop, KEINE Lizenz, C++17 → **Ziel:** Modul-Wrapper in C++23 mit GCC 9+ kompilierten Bausteinen → **Aenderung:** keine im Originalcode; Adapter-Header in `adapters/P06-B2tree/` re-exportiert die Bausteine. Lizenz-Klaerung mit Author wuenschenswert (Task #74). |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) Lizenz-Klaerung mit Author (formell) | OFFEN — Email-Antwort abwarten (Task #74); fachlich nicht blockierend |
| (c) CMake-Build der Bausteine mit GCC 9+ | OFFEN — Phase 6 |
| (d) Adapter-Build im COMDARE-Modul-Wrapper (F-EXTRA-1) | OFFEN — Phase 6 |

## 7. Offene Punkte / Beobachtungen

- **KEINE LICENSE — Architekt-Direktive 2026-05-08 (Re-Verifikation 2026-05-09):** akademische Nutzung im Forschungskontext zulaessig. Korrektur der ersten Fassung dieses Dokuments, die das als Block darstellte. Formelle Klaerung mit Author wuenschenswert (Task #74).
- **OLC + Epoch + Hazard parallel:** seltene Kombination; legt nahe, dass das Paper diese drei Strategien empirisch vergleicht. Hochrelevant fuer F8-Diskussion.
- **`tree.cpp` 1 387 LOC:** ungewoehnlich gross fuer eine kompakte Code-Basis; dort steckt wahrscheinlich die ganze B²-Tree-Logik.
- **AVX-512 in nur 1 Datei:** vermutlich SIMD-Suche innerhalb der Page.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P06-B2tree__b2-tree-master.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (PENDING — akademische Nutzung im Forschungskontext, Architekt-Direktive 2026-05-08)
- **Bausteine_Matrix:** `PAGE_DECISION_B2TREE`, `PAGE_SPAN_B2TREE`, `NODE_DECISION_B2TREE`, `NODE_SPAN_B2TREE`, `MEMORY_EMBEDDED_TREE`, `TRAVERSAL_EMBEDDED_DEC_TREE` → ext/P06-B2tree/b2-tree-master/. Achse 8 OLC+EPOCH-Vergleich (P06).
- **Re-Impl. Modul:** kein LEGACY_REIMPL-Skelett — Originalcode direkt einbindbar via Compiler-Layering (F-EXTRA-1)
- **Email-Tracking:** Task #74 (formelle Lizenz-Klaerung; fachlich nicht blockierend)
