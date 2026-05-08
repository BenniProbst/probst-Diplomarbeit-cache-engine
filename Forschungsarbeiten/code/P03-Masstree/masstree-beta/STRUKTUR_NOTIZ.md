# STRUKTUR_NOTIZ — P03 masstree-beta (kohler/masstree-beta)

**Paper:** P03 — Mao/Kohler/Morris 2012 — "Cache Craftiness for Fast Multicore Key-Value Storage" (EuroSys 2012)
**Repo:** `kohler/masstree-beta`
**Lokal:** `Forschungsarbeiten/code/P03-Masstree/masstree-beta/`
**Lizenz:** MIT-Variante mit W3C-Klausel
**Voranalyse:** `_voranalyse_output_klasse_a/P03-Masstree__masstree-beta.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (Eddie Kohler ist Co-Autor des Originalpapers) |
| Originalpaper-Code? | JA (Maintainer = Eddie Kohler, einer der drei Autoren) |
| C++-Standard | klassisches C++03/C++11 (Autotools-aera, kein modernes CMake) |
| Build-System | Autotools (`configure.ac` 455 Zeilen, `bootstrap.sh`, `GNUmakefile.in`) — **NICHT CMake** |
| Compiler-Anforderungen (README) | gcc; getestet auf Debian/Ubuntu/macOS |
| ISA-Anforderungen | x86_64; impliziert SSE2 — keine AVX-Treffer im grep |
| Externe Abhaengigkeiten | jemalloc / tcmalloc / Hoard / Flow-Allocator (auswaehlbar via configure) |
| LOC (gesamt source) | 14 990 |
| Top-LOC-Datei | `clp.c` (2 506 LOC, command-line-parser von Kohler-Lib), `mtclient.cc` (1 724), `mtd.cc` (1 715), `mttest.cc` (1 432) |
| Source-Sprache-Mix | C (clp.c) + C++ (.cc, .hh) — **flache Datei-Struktur, keine include-Hierarchie** |

## 2. Verzeichnis-Hierarchie

```
masstree-beta/
├── (Quellen flach im Top-Level — KEINE src/-Struktur)
│   ├── checkpoint.{cc,hh}            — Checkpoint Persistence
│   ├── compiler.{cc,hh}              — Compiler-Builtins-Wrapper (38 KB Header)
│   ├── kpermuter.hh, ksearch.hh      — Permutation + Suchhilfen fuer Knotenzugriff
│   ├── btree_leaflink.hh             — B-Tree Leaf-Verkettung
│   ├── circular_int.hh               — Versions-Counter
│   ├── json.{cc,hh}                  — eigene JSON-Bibliothek (1 233 + 94 KB)
│   ├── kvthread.{cc,hh}              — Threading-Hilfen
│   ├── log.cc, query_masstree.cc     — Logging + Anfragen
│   ├── memdebug.cc                   — Memory-Debug
│   ├── mtclient.cc, mtd.cc, mttest.cc — Server (mtd), Client (mtclient), Tester (mttest)
│   ├── string.{cc,hh}, str.{cc,hh}, straccum.{cc,hh}, string_slice.{cc,hh} — String-Hilfen
│   ├── value_array.cc, value_string.cc, value_versioned_array.cc — Value-Storage-Varianten
│   └── perfstat.cc                   — Performance-Stats
└── doc/                              — Algorithmus-Spezifikation (PDF/MD)
```

**Beobachtung:** masstree-beta hat **keine Verzeichnis-Hierarchie** — alle Quellen liegen flach. Das ist Kohler-Stil (vgl. `clp.c` ist Eddie Kohlers Command-Line-Parser-Bibliothek).

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | Masstree = Trie of B+-Tree-Schichten; **Leaf-Page** = `btree_leaflink.hh`-strukturiertes Knoten | `btree_leaflink.hh` |
| **2 Node** | Masstree-Border-Node + Internal-Node (B+-Tree-Layer auf 8-Byte-Slices) | `query_masstree.cc` |
| **3 Traversal** | Slice-basiert (8-Byte-Schluessel-Slices), Linked-Lists pro Trie-Level | `query_masstree.cc`, `ksearch.hh`, `kpermuter.hh` |
| **4 ValueHandle** | drei Varianten: `value_array`, `value_string`, `value_versioned_array` (versioned fuer Concurrency) | `value_*.cc` |
| **5 MemoryLayout** | Cache-line aligned Knoten; **Permuter-basierte Sortierung** statt Schluessel-Verschiebung | `kpermuter.hh` |
| **6 Allocator** | konfigurierbar zur Compile-Zeit: jemalloc/tcmalloc/Hoard/Flow | `configure.ac` |
| **7 Prefetch** | implizit ueber Cache-Line-Layout; keine `prefetch`-Treffer im grep — Masstree setzt auf "Cache Craftiness" durch Layout, nicht Prefetch-Anweisungen | (durch Layout) |
| **8 Concurrency** | **Permuter** + **Versioned Optimistic Concurrency** (RCU-aehnlich, 1 RCU-Treffer im grep) | `kpermuter.hh`, `circular_int.hh` |
| **9 ISA** | x86_64, keine expliziten SIMD-Treffer | (compiler.hh nutzt builtins) |
| **10 Measurement** | `perfstat.cc`, `mttest.cc` — eigene Test- und Benchmark-Infrastruktur | `perfstat.cc`, `mttest.cc` |
| **11 Telemetry-Strategy** | nicht ausgepraegt; ggf. log-basiert via `log.cc` | `log.cc` |

**Hervorhebung:** Masstree ist die einzige Klasse-A-Quelle, die **B+-Tree-of-Trie** Hybrid mit **slice-basiertem Schluessel-Schnitt** implementiert (paper-Hauptidee).

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **Schwierig** — Autotools-Build, flache Datei-Struktur, kein Header-only-Pfad. Bausteine_Matrix verweist trotzdem `PAGE_BPLUS_MASSTREE`, `NODE_INTERNAL_MASSTREE`, `NODE_BORDER_MASSTREE`, `TRAVERSAL_LAYER_SLICE` auf `ext/P03-Masstree/masstree-beta/`. |
| Compiler-Layering (F-EXTRA-1) | Bausteine-Internals mit GCC 4.6+ (Original-Compiler) bauen — Autotools muss in den Pre-Build-Step eingebunden werden. Modul-Wrapper bleibt C++23 und linkt die object-files statisch. |
| Allocator-Brueck­e | jemalloc/tcmalloc/Flow ist orthogonal zu PRT-ART; eigene Allocator-Achse (F4/F6 Abstract Factory) |
| Lizenz-Vermerk | NOTICE-Datei (MIT/W3C) bereits erstellt (Task #73) |
| Concurrency-Brueck­e | Permuter-Konzept (`kpermuter.hh`) ist eigene Idee — Konzept-Quelle, nicht im aktuellen F2-Beschluss |
| LEGACY_REIMPL-Bedarf | **OPTIONAL** — Adapter-Pfad erfordert Autotools-Bridge (riskant fuer COMDARE-BuildSystem). Falls Bridge-Aufwand zu hoch, alternativer LEGACY_REIMPL-Pfad in `prt_art/legacy_reimpl/P03-Masstree/`. Entscheidung in Phase 6. |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★ | "beta"-Status seit 2012; kein erkennbarer aktiver Wartungs­zyklus |
| Doku-Qualitaet | ★★★ | README + Algorithmus-Spec im `doc/`; flache Datei-Struktur erschwert Navigation |
| Test-Abdeckung | ★★★ | `mttest.cc` (1 432 LOC), `unit-mt.cc`, `test_atomics.cc`, `test_string.cc`, `jsontest.cc`, `msgpacktest.cc`, `scantest.cc` — eigenstaendige Test-Programme |
| Ueberein­stimmung mit Originalpaper | ★★★★★ | Maintainer = Co-Autor; algorithm-spec im doc/-Ordner; Reference Implementation |
| Adapter-Aufwand | ★★ | Hoch: Autotools-Bridge + flache Struktur + C/C++-Mix. Aber Originalcode bleibt unangetastet (Habich-Direktive). |
| **Bauszenario** | **Quelle:** Autotools, flach, C++03/C++11 mit GCC 4.6+ → **Ziel:** Bausteine-Internals direkt aus Originalcode-Bauteilen kompiliert + statisch in C++23-Modul-Wrapper gelinkt (F-EXTRA-1) → **Aenderung:** keine im Originalcode; Wrapper-Header in `adapters/P03-Masstree/`. Falls Autotools-Bridge zu komplex: Fallback LEGACY_REIMPL. |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) Autotools-Bridge im COMDARE BuildSystem | OFFEN — Phase 6 (Pre-Build-Step `bootstrap.sh && configure && make` als Bauteil-Build, in den Modul-Wrapper-Build integriert) |
| (c) Testsuite-Lauf (`mttest`, `unit-mt`, etc.) | OFFEN — Phase 6 |
| (d) Adapter-Build im COMDARE-Modul-Wrapper (F-EXTRA-1) | OFFEN — Phase 6 |

## 7. Offene Punkte / Beobachtungen

- **Autotools-Konflikt mit COMDARE-BuildSystem — Re-Verifikation 2026-05-09:** Masstree's `configure.ac` (455 Zeilen) muss als Pre-Build-Step in den Modul-Wrapper-Build integriert werden (analog `add_custom_command` mit Bash, gemaess F-EXTRA-5 KORREKTUR / Memory `feedback_no_python_in_buildchain`). Falls der Aufwand zu gross wird, Fallback: LEGACY_REIMPL.
- **F-EXTRA-1 Compiler-Layering:** Originalcode bleibt C++03/C++11 und wird mit GCC 4.6+ gebaut. KEINE Aufwertung auf C++23 im Originalcode-Bauteil.
- **Flache Datei-Struktur:** Erschwert selektive Header-Inkludierung; aber via Autotools-Build entstehen vollstaendige Object-Files, die selektiv ge-archiveBack werden koennen.
- **`json.hh` 94 KB:** Kohler eigene JSON-Lib — unverwendbar fuer COMDARE (eigene JSON-Impl. per S2666 K22 verbindlich).
- **Permuter-Konzept (`kpermuter.hh` 11 KB):** Sehr lesbar — gute Konzept-Quelle, aber neu schreiben.
- **„Cache Craftiness" — Layout-First:** Wichtig zu erfassen: Masstree erreicht Cache-Effizienz durch Layout, nicht durch Prefetch-Anweisungen. Das ist Kontrast­position zu P25 (Mahling-FillBuffer-Prefetching).

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P03-Masstree__masstree-beta.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (MIT/W3C, Copyright Mao/Kohler/Morris)
- **Bausteine_Matrix:** `PAGE_BPLUS_MASSTREE`, `NODE_INTERNAL_MASSTREE`, `NODE_BORDER_MASSTREE`, `TRAVERSAL_LAYER_SLICE` → ext/P03-Masstree/masstree-beta/. Auch Konzept-Bezug zu Achse 5 (Permuter-Layout).
- **Re-Impl. Modul:** primaer Adapter-Pfad mit Autotools-Bridge (F-EXTRA-1 Compiler-Layering); Fallback LEGACY_REIMPL nur bei Bridge-Versagen
