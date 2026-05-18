# P06-B2tree — Status

**Paper:** B²-tree (Schmeisser 2022) — Page-Based String Indexing in Concurrent Environments
**Status:** CLONED (nachtraeglich erhalten via direkter Quelle, 2026-05-08)
**Verzeichnis:** `Forschungsarbeiten/code/P06-B2tree/`

## Klon-/Implementierungs-Hinweis

- **Repository (extracted):** `b2-tree-master/` + `bart-master/`
- **Erhaltsart:** Direkter Download (nicht oeffentlich auf GitHub)
- **Original-Compiler:** GCC 9+ (CMakeLists fordert C++17, BMI2-Befehle vermutlich)
- **Erhaltsdatum:** 2026-05-08
- **Original-ZIPs:** `_original_b2-tree-master.zip` + `_original_bart-master.zip`

## Inhalt der zwei Quellen

### `b2-tree-master/` — Haupt-B²-tree-Implementation
- `include/Page.hpp`, `tree.hpp`, `search.hpp` — Page-/Tree-/Search-Layouts
- `include/epoch.hpp`, `hazard.hpp`, `optimistic_lock.hpp` — Concurrency (OLC + Epoch + Hazard)
- `include/BufferManager.hpp`, `Database.hpp`, `NonCopyable.hpp`
- `src/tree.cpp` (48 KB Hauptimplementation), `Page.cpp`, `bench.cpp`, `main.cpp`
- `lib/jevents.cmake`, `gtest.cmake`, `benchmark.cmake`
- `test/test_tree.cpp`

Bemerkung: enthaelt eigene Hazard-Pointer- UND Epoch-basierte Reclamation,
**OBWOHL wir Hazard Pointers bei PRT-ART entfernt haben** (F12-K). Das ist
NICHT widerspruechlich: Schmeisser nutzt beide Strategien. Wir nutzen
B²-tree als FREMD-Algorithmus via Adapter — die internen Mechanismen
bleiben unangetastet (Habich-Direktive).

### `bart-master/` — Schmeisser-Vergleichs-Repository (F15-RELEVANT!)
Enthaelt mehrere Algorithmen, die Schmeisser fuer Vergleichsmessungen nutzte:
- `bart.cpp` (54 KB) — Hauptprogramm BART (B-Tree + ART hybrid)
- `ART.cpp` — Adaptive Radix Tree (P01-Variante)
- `b2tree_int.cpp` — B²-tree mit Integer-Schluesseln
- `btree.cpp` — klassischer B+-Tree
- `hattrie.cpp` — HAT-Trie (Hash Array Trie)
- `pbtreestatic.cpp`, `pbtreestatic_opt.cpp`, `pbtreestatic_trie.cpp` — PB-Tree-Static-Varianten
- `pbtreestaticart.cpp` — Hybrid PB-Tree-Static + ART
- `cpp-btree-1.0.1/` — Google's cpp-btree (Apache 2.0)

**Bonus fuer F15:** Hochwertige Vergleichsbasis — dieselben Algorithmen
werden hier bereits als Vergleichsbasis kompiliert! Die `bart`-Hybrid-
Variante ist relevant fuer die PRT-ART-Forschungsthese.

## Habich-Direktive (F-EXTRA-1)

Originalcode wird EXAKT KOPIERT uebernommen. Anbindung ueber Adapter-Pattern in
`comdare-cache-engine/adapters/P06-B2tree/`. Compiler-Layering: B²-tree-Bausteine
mit `GCC 9+` kompiliert, statisch in C++23-Modul-Wrapper gelinkt.

## Naechste Schritte (Phase 4.B)

1. ⚠️ **Lizenz unklar** — keine LICENSE-Datei in beiden Repos. Mit Schmeisser
   klaeren (Email-Kontakt nochmal nachhaken).
2. Code-Struktur-Analyse:
   - b2-tree-master = Page/Node/Concurrency-Bausteine
   - bart-master = ART + B²-tree + HAT-Trie + PB-Tree-Bausteine (Cross-Algorithm)
3. Adapter-Skelett in `comdare-cache-engine/adapters/P06-B2tree/`
4. Compiler-Provisioning verifizieren (GCC 9+ verfuegbar?)
5. **bart-master Varianten als zusaetzliche Bausteine** in `Bausteine_Matrix.txt`
   markieren (PB-Tree-Static, HAT-Trie, BART-Hybrid).

---

## L.2 Update 2026-05-18 (Email-Verlauf + N-Phase Achsen-Zuordnung)

**Email-Verlauf:** `../../../E-Mail Schüle – benjamin-elias.probst@mailbox.tu-dresden.de.pdf`

**Schuele-Antwort 2026-05-08 23:37:22:** Code via 2 Nextcloud-Links transferiert
- Link 1: `https://nextcloud.in.tum.de/index.php/s/xXEw2SGfGeWNfjA`
- Link 2: `https://nextcloud.in.tum.de/index.php/s/63M9YqazFQDS2TR`

**User-Quote 2026-05-13 23:35:** "Dankeschoen, das hat geklappt"

### Achsen-Zuordnung nach N-Phase (2026-05-18)

Mit der Bausteine-Matrix-Erweiterung auf 14 Achsen (siehe `../../../docs/bausteine/07_bausteine_matrix_N_erweitert.md`):

| Achse | P06 B²-Tree Auspraegung |
|---|---|
| 1 PAGE-TYPE | `PAGE_DECISION_B2TREE` / `PAGE_SPAN_B2TREE` (K05 PRT-ART Bausteinkombination) |
| 2 NODE-TYPE | `NODE_DECISION_B2TREE` / `NODE_SPAN_B2TREE` |
| 3.A SearchAlgo-Traversal | Decision-Tree-Walk + Span-Scan (NEU via 3-Split) |
| 3.B Cache-Memory-Traversal | L2-aware Decision-Tree-cache (NEU via 3-Split) |
| 3.M Mapping | Embedded-Decision-Tree-Offset (NEU via 3-Split) |
| 6.2 Reclamation-Policy | epoch + hazard-pointer (eigen, NICHT PRT-ART) |
| 8.1 Concurrency-Pattern | OLC (optimistic_lock.hpp) |
| 8.2 Locking-Mode | optimistic-validation |
| 12.1 SIMD-Family | scalar (BMI2-Befehle moeglich) |
| 12.2 Cache-Level-Targeting | L2-aware (Decision-Tree-cache) |
| 13.1 Worker-Pool-Layout | thread-per-core |

### Pending Folge-Tasks aus L.2

1. **[TODO]** Adapter-Skelett aktualisieren: `Code/external/comdare-cache-engine/adapters/P06-B2tree/p06_b2tree_adapter.hpp` mit Verweis auf `b2-tree-master/` als ext/-Quelle
2. **[TODO]** LICENSE-Audit: keine LICENSE-Datei im Drop. Per Architekt-Direktive II 2026-05-14 verwendbar mit korrekter Zitation (Schmeisser/Schuele 2022 Datenbank-Spektrum).
3. **[TODO]** bart-master Cross-Algorithm-Vergleichsbasis ist schon in Bausteine-Matrix verankert (PAGE_BART_HYBRID_P06 / PAGE_HATTRIE_P06 / PAGE_PBTREESTATIC_P06, siehe Bausteine_Matrix:139-189). Adapter-Hooks pro Variante in `adapters/P06-B2tree/sub/` planen.

### Querverweise

- Bausteine-Matrix (P06 verankert): `../../../docs/bausteine/01_bausteine_matrix.md` §3
- Bausteine N-Phase Erweiterung: `../../../docs/bausteine/07_bausteine_matrix_N_erweitert.md`
- Forschungslandkarte Cluster B (Hybrid + B+): `../../../docs/forschungslandkarte/03_cluster_B_hybrid_bplus.md`
- E-Mail-Verlauf: `../../../E-Mail Schüle – benjamin-elias.probst@mailbox.tu-dresden.de.pdf`
