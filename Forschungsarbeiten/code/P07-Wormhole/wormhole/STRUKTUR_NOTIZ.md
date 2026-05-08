# STRUKTUR_NOTIZ — P07 wormhole (wuxb45/wormhole)

**Paper:** P07 — Wu/Ni/Jiang 2019 — "Wormhole: A Fast Ordered Index for In-memory Data Management" (EuroSys 2019)
**Repo:** `wuxb45/wormhole`
**Lokal:** `Forschungsarbeiten/code/P07-Wormhole/wormhole/`
**Lizenz:** GNU GPL v3 (Architekt-Direktive 2026-05-08: GPL-3.0 KEIN Hinderungsgrund — modularisierte Bruchstuecke + C++23-Metaprogrammierung = neues Werk; akademische Nutzung im Forschungskontext erlaubt)
**Voranalyse:** `_voranalyse_output_klasse_a/P07-Wormhole__wormhole.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (Author = Xingbo Wu, Erstautor des Papers) |
| Originalpaper-Code? | JA |
| **Sprache** | **C** (nicht C++!), single-file mega-source style |
| Build-System | Makefile (klassisch, 45 Zeilen) — kein CMake |
| Compiler-Anforderungen | GCC; Linux/FreeBSD/MacOS auf x86_64+AArch64 |
| ISA-Anforderungen | **SSE4.2 mandatorisch** auf x86_64; NEON+CRC auf AArch64 (Raspberry Pi 4 / Jetson Nano getestet) |
| Externe Abhaengigkeiten | nur libc + pthread |
| LOC (gesamt source) | 10 214 |
| Top-LOC-Datei | `wh.c` (3 873) — Wormhole-Hauptimpl., `lib.c` (3 026), `kv.c` (1 131) |
| Bonus | Python-Wrapper (`wh.py`), `wh.strip` (Symbol-Strip), `easydemo.c`, `concbench.c` |

## 2. Verzeichnis-Hierarchie

```
wormhole/  (FLACH)
├── wh.{c,h}          (3873+313)  — Wormhole-Index-API
├── lib.{c,h}         (3026+688)  — Hilfsbibliothek (allgemein)
├── kv.{c,h}          (1131+554)  — Key-Value-Datenstruktur
├── ctypes.h          (40)        — C-Type-Helfer
├── easydemo.c        (91)        — User-Demo
├── concbench.c       (144)       — Concurrency-Benchmark
├── stresstest.c      (354)       — Stress-Test
├── wh.py / wh.strip              — Python-Wrapper, Symbol-Strip-Skript
├── Makefile / Makefile.common    — Build
├── LICENSE                       — GPL-3.0 (35.8 KB)
└── README.md                     — sehr ausfuehrlich (21 KB)
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | implizit — Wormhole = Hash-mapped Trie + Linked-List der Leaf-Knoten + B+-Tree der Anker-Schluessel (Triple-Layer) | `wh.c` |
| **2 Node** | drei Knotentypen: **Leaf** (mit Anchor-Key), **Hash-Index-Knoten**, **B+-Hop-Knoten** | `wh.c` |
| **3 Traversal** | **drei-stufiger Traversal**: Hash-Lookup → B+-Tree-Hop → Leaf-Linked-List (paper-Hauptidee „Wormhole") | `wh.c` |
| **4 ValueHandle** | uint8_t* mit explizit angegebener `klen` (32-bit) | `kv.{c,h}` |
| **5 MemoryLayout** | binary string keys mit 0-Bytes erlaubt; klen <= UINT32_MAX | `kv.h` |
| **6 Allocator** | eigene Speicherverwaltung in lib.c (3 026 LOC) | `lib.c` |
| **7 Prefetch** | **6 Dateien mit prefetch-Treffern** — aktiv eingesetzt | grep |
| **8 Concurrency** | **user-space rwlocks + QSBR RCU** (paper-Beschreibung); thread-safe ohne Background-Threads | `wh.c`, `lib.c` |
| **9 ISA** | SSE4.2 mandatorisch (x86); NEON+CRC (ARM); AVX2 (2 Dateien), AVX-512 (1 Datei) | `wh.c`, `lib.c` |
| **10 Measurement** | `concbench.c`, `stresstest.c` | direkt |
| **11 Telemetry-Strategy** | bitmap-Treffer in 2 Dateien — wahrscheinlich populated/used Bits-Counter | grep |

**Hervorhebung:** Wormhole ist die einzige Klasse-A-Quelle mit **Triple-Layer-Index** (Hash + B+ + LinkedList). Konzeptuell sehr nah an PRT-ART (mehrstufiges Lookup mit Cache-Locality).

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **Code-Adapter MOEGLICH** — Architekt-Direktive 2026-05-08 erlaubt GPL-3.0-Bruchstuecke. Bausteine_Matrix verweist `PAGE_METATRIEHT_WORMHOLE` und `TRAVERSAL_HASH_ANCHOR` auf `ext/P07-Wormhole/wormhole/`. |
| Compiler-Layering (F-EXTRA-1) | C-Bausteine mit GCC 7+ kompiliert (Wormhole's Original-Compiler), `extern "C"`-Anbindung im C++23-Modul-Wrapper |
| Konzept-Quelle | JA — Triple-Layer-Index-Konzept als Knoten-Multi-Level-Hierarchie. Direkte Code-Anbindung jetzt moeglich. |
| Lizenz-Vermerk | NOTICE-Datei (GPL-3.0) bereits erstellt (Task #73) — als Originalcode-Quelle gefuehrt |
| Concurrency-Brueck­e | user-space rwlocks + QSBR RCU als Konzept-Quelle fuer F2-Beschluss (eigene RCU, Task #104) — wird NICHT direkt verlinkt, weil F2 eigene Implementation will |
| Talos-Kompatibilitaet | C-Code mit pthread → portierbar |
| LEGACY_REIMPL-Bedarf | **NEIN** — Adapter-Pfad direkt verfuegbar; LEGACY_REIMPL-Skelett P07 entfaellt |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★★ | aktiv bis 2024 (anchor-key Limit entfernt, merge/delr Operationen) |
| Doku-Qualitaet | ★★★★ | README sehr ausfuehrlich (21 KB), Highlights-Liste, 2 NEWS-Punkte, klare API |
| Test-Abdeckung | ★★★ | concbench + stresstest, kein Unit-Test-Framework |
| Ueberein­stimmung mit Originalpaper | ★★★★★ | Author = Erstautor; Reference Implementation |
| Adapter-Aufwand | ★★★ — C-Bausteine mit GCC 7+ bauen, statisch in C++23-Modul-Wrapper linken (F-EXTRA-1) |
| **Bauszenario** | **Quelle:** GPL-3.0, C, Triple-Layer-Index → **Ziel:** Modul-Wrapper in C++23 mit GCC 7+ kompilierten C-Bausteinen → **Aenderung:** keine im Originalcode; Adapter-Header in `adapters/P07-Wormhole/` re-exportiert via `extern "C"` |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) Make-Build der C-Bausteine mit GCC 7+ | OFFEN — Phase 6 |
| (c) concbench/stresstest-Lauf | OFFEN — Phase 6 |
| (d) Adapter-Build im COMDARE-Modul-Wrapper (F-EXTRA-1) | OFFEN — Phase 6 |

## 7. Offene Punkte / Beobachtungen

- **GPL-3.0 — Architekt-Direktive 2026-05-08 (Re-Verifikation 2026-05-09):** GPL-3.0 ist KEIN Hinderungsgrund. Modulare Bruchstuecke + C++23-Wrapper = neues Werk. Korrektur der ersten Fassung dieses Dokuments, die GPL-3.0 als Distribution-Block darstellte.
- **C nicht C++:** Compiler-Layering (F-EXTRA-1) loest das: C-Bausteine mit GCC 7+ kompiliert, `extern "C"`-Anbindung im C++23-Modul-Wrapper.
- **wh.c 3 873 LOC monolithisch:** schwer zu navigieren; aber alle Triple-Layer-Logik in einer Datei.
- **QSBR RCU als single-file:** vermutlich in `lib.c`. Konzept-Quelle fuer Task #104.
- **SSE4.2 mandatorisch:** CRC32-Instruktionen fuer Hash-Berechnung. Wir nutzen wahrscheinlich anderes Hashing.
- **0-Byte-Schluessel erlaubt:** Wormhole's KV-API explizit `klen + Bytes`. Wichtig fuer F2-Schluessel-Kodierung der PRT-ART.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P07-Wormhole__wormhole.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (GPL-3.0, Originalcode-Quelle, Copyright Wu/Ni/Jiang)
- **Bausteine_Matrix:** `PAGE_METATRIEHT_WORMHOLE` und `TRAVERSAL_HASH_ANCHOR` → ext/P07-Wormhole/wormhole/. Achse 8 USER_SPACE_RWLOCK+QSBR ist Konzept-Bezug zu F2-eigene-RCU (Task #104).
- **Re-Impl. Modul:** kein LEGACY_REIMPL-Skelett notwendig; Originalcode direkt einbindbar via Compiler-Layering (F-EXTRA-1)
