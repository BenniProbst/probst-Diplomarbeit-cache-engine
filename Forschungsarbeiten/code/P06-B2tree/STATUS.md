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
