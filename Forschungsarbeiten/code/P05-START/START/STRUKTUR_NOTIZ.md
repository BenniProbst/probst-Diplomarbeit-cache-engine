# STRUKTUR_NOTIZ — P05 START (jungmair/START)

**Paper:** P05 — Fent/Jungmair/Kipf/Neumann 2020 — "Self-Tuning, Elastic and Online Adaptive Radix Tree" (BTW 2020 / paper-Webseite)
**Repo:** `jungmair/START`
**Lokal:** `Forschungsarbeiten/code/P05-START/START/`
**Lizenz:** MIT (Copyright 2020 Michael Jungmair)
**Voranalyse:** `_voranalyse_output_klasse_a/P05-START__START.txt` (2026-05-09)
**Stand der Notiz:** 2026-05-09

---

## 1. Repository-Klassifikation

| Feld | Wert |
|------|------|
| Klasse | A — geklonter Originalcode (Author = Michael Jungmair, einer der Autoren) |
| Originalpaper-Code? | JA |
| C++-Standard (CMake) | C++17 (`set(CMAKE_CXX_STANDARD 17)`) |
| Build-System | CMake (sehr schlank, 9 Zeilen Top-Level) |
| Compiler-Anforderungen | nicht im README spezifiziert; impliziert GCC-modern |
| ISA-Anforderungen | x86 mit `mfence`/`rdtsc`/`clflush` (Cache-Estimator-Messung) |
| Externe Abhaengigkeiten | Linux Kernel Module (LKM) fuer "rewiring" — `util/rewiring/lkm_rewiring_provider.hpp` |
| LOC (gesamt source) | 1 493 — sehr kompakt fuer ein Tuning-System |
| Top-LOC-Datei | `measurements/measurements.cpp` (280) — Cache-Cost-Messung mit `mfence`/`rdtsc`/`clflush` |
| Datei-Mix | viele `.tcc` (Template-Compile-Time-Code) statt `.hpp` |

## 2. Verzeichnis-Hierarchie

```
START/
├── art_impl.tcc              (17 700 Bytes)  — kanonische ART-Impl. mit compile-time switch
├── leaf.tcc / statistics.tcc — Leaf-Knoten + Statistics-Sammlung
├── sosd-competitor-adapter-{ART,START}.h    — SOSD-Benchmark-Adapter
├── config/
│   ├── machine_facts.h       — Cache-Hierarchie-Annahmen (L1/L2/L3-Groessen)
│   └── node_costs.h          — Cost-Modell pro Node-Typ + Cache-Status
├── nodes/
│   ├── standard/             — Klassische ART-Nodes 4/16/48/256
│   ├── simple/               — MultiNode4 (kompakte Multi-Level)
│   ├── rewired/              — Rewired64K + Rewired16M (LKM-rewiring)
│   └── migrate/              — Migration zwischen Node-Typen
├── tuning/                   — Self-Tuning-Komponente (Cache-Estimator + DP)
│   ├── tuning.tcc            — Hauptprozedur: Cache-Estimation + DP + Replacement
│   └── util/                 — costmodel.tcc, cache_estimator.tcc, dp_data.tcc, tag_manager.tcc
├── measurements/             — Cache-Cost-Messung (mfence/rdtsc/clflush)
├── tests/                    — Tests + Datasets + zipf.h
└── util/rewiring/            — LKM + mmap-basierte Page-Rewiring-Provider
```

## 3. Bausteine-Klassifikation (Achsen 1-11)

| Achse | Identifizierte Implementierung | Quelldatei(en) |
|-------|-------------------------------|----------------|
| **1 Page** | **Rewired64K + Rewired16M** Page-Klassen (kernel-rewiring) | `nodes/rewired/`, `util/rewiring/page_squeezer.h` |
| **2 Node** | **Node4/16/48/256** + **MultiNode4** (kompakte Multi-Level-Knoten) — Compile-Time-Polymorphie via Template-Trait | `nodes/standard/`, `nodes/simple/`, `art_impl.tcc` |
| **3 Traversal** | klassische ART-Traversierung; mit DP-getunter Knoten-Wahl | `art_impl.tcc` |
| **4 ValueHandle** | Template-Param via Trait | `art_impl.tcc` |
| **5 MemoryLayout** | **Page-Rewiring** via LKM (umrouting physikalischer Pages) — sehr ungewoehnlich, paper-spezifisch | `util/rewiring/` |
| **6 Allocator** | LKM-Provider + mmap-Provider | `util/rewiring/lkm_rewiring_provider.hpp`, `mmap_rewiring_provider.hpp` |
| **7 Prefetch** | nicht ausgepraegt | (grep: 0 Treffer) |
| **8 Concurrency** | nicht primaer; START ist Tuning-System auf single-threaded ART | (single-threaded) |
| **9 ISA** | `mfence`/`rdtsc`/`clflush` fuer Cache-Estimator | `measurements/measurements.cpp` |
| **10 Measurement** | **Cache-Cost-Messung** mit drei Cases (cached/header-cached/uncached) — direkt relevant fuer PRT-ART F11-Telemetrie | `measurements/measurements.cpp` |
| **11 Telemetry-Strategy** | **Statistics-Sammlung** als Compile-Zeit-Trait + Tag-Manager (Prefix-Field-Hijack waehrend Tuning) — verwandt mit Kuehn-Erkenntnis `RetroactiveAggregation` (Wurzel-Up-Traversal in Single-Threaded-Phase, Glossar v7 BLOCK AK) | `tuning/util/tag_manager.tcc`, `statistics.tcc` |

**Hervorhebung:** START liefert die **Cache-Cost-Modellierung mit DP** und **Tag-Manager (Prefix-Hijack)** — beides sehr nah am COMDARE-Forschungsziel (cache-aware adaptation).

## 4. Adapter-Strategie fuer comdare-cache-engine

| Strategie-Punkt | Entscheidung |
|-----------------|--------------|
| Einbindung-Form | **HOCHRELEVANT als Konzept-Quelle** — Cache-Estimator + Cost-Modell + Tag-Manager-Pattern direkt einsetzbar |
| Code-Adapter? | Eingeschraenkt — `art_impl.tcc` und `nodes/standard/*` bilden eine Vorlage, aber LKM-rewiring ist NICHT auf Talos OS portierbar (Talos = Read-Only-Root, keine Custom-Kernel-Module) |
| Lizenz-Vermerk | NOTICE-Datei (MIT) bereits erstellt (Task #73) |
| Talos-Kompatibilitaet | **Konflikt:** LKM-rewiring funktioniert nicht in Talos; mmap-Provider ist Fallback. Wir bauen **eigene Page-Rewiring-Variante** ueber huge pages, ohne LKM. |
| Concurrency-Brueck­e | start ist single-threaded; concurrency aus P01/P02 nehmen |
| LEGACY_REIMPL-Bedarf | **NEIN** — Adapter-Pfad mit Konzept-Uebernahme empfohlen, da Lizenz und Code-Qualitaet beide passen |

## 5. Code-Qualitaets-Bewertung (Habich H2: Quelle/Ziel/Aenderung)

| Kriterium | Bewertung (★ 1-5) | Begruendung |
|-----------|-------------------|-------------|
| Quelle gepflegt | ★★★ | TUM-Universitaetsprojekt, kein erkennbarer Industrie-Wartungs­zyklus |
| Doku-Qualitaet | ★★★★ | README sehr ausfuehrlich (6.5 KB) und konzeptuell stark — beschreibt Tuning-Phasen detailliert |
| Test-Abdeckung | ★★ | nur 5 Test-Dateien (`tests/range.cpp`, `tests/art.cpp`, etc.) |
| Ueberein­stimmung mit Originalpaper | ★★★★★ | Author = Co-Autor; Reference Implementation; Code spiegelt 1:1 die Paper-Konzepte |
| Adapter-Aufwand | ★★★ | LKM-Bridge schwierig auf Talos; aber Konzept klar separierbar |
| **Bauszenario** | **Quelle:** MIT, C++17, LKM-spezifisch → **Ziel:** C++23 in COMDARE, mmap-only → **Aenderung:** LKM-Provider durch huge-pages-mmap ersetzen, Cache-Estimator + DP-Tuning uebernehmen |

## 6. Compile-Test-Plan

| Aktion | Erfolgs-Kriterium |
|--------|-------------------|
| (a) Klon im Cluster | ✅ erledigt |
| (b) CMake-Build (ohne LKM) | OFFEN — Phase 6 |
| (c) Testsuite-Lauf | OFFEN — Phase 6 |
| (d) Adapter-Build | OFFEN — Phase 6, LKM-Code per `#ifdef` ausschliessen |

## 7. Offene Punkte / Beobachtungen

- **LKM auf Talos OS:** UNMOEGLICH (Read-Only-Root, kein Custom-LKM-Pfad). Alternative: mmap mit `MAP_HUGETLB` oder DAX-Pages via PMEM.
- **Cache-Estimator-Messung mit `mfence`/`rdtsc`/`clflush`:** muss fuer ARM angepasst werden (NEON+`dmb` statt `mfence`+`rdtsc`). Fuer Production-Plattform (Block AO): direkt anwendbar auf Ryzen 9 9950X3D + i9-14900KS. **Hybrid-CPU-Anforderung i9-14900KS:** cpu_core/* vs cpu_atom/* perf-Counter trennen. **Ryzen 9950X3D-Asymmetrie:** Cache-Estimator muss zwischen V-Cache-CCD (96 MiB) und Standard-CCD (32 MiB) unterscheiden — START's Pinning-Logik braucht hier eine Erweiterung.
- **Tag-Manager-Pattern (Prefix-Field-Hijack):** elegantes Speicher-Sparen, ABER Konflikt mit MV-Konkurrenz; kompatibel nur waehrend Quiescent-Phasen.
- **Compile-Time-Switch-Statement (`util/compile-time-switch.tcc`):** wahrscheinlich C++23 `if constexpr` ersetzbar.
- **F11-Telemetrie-Brueck­e:** START's `node_costs.h` definiert Cache-Cost-Modell direkt — IDEAL als Konzept-Quelle fuer F11.
- **Achse 11 (Telemetry-Collection-Strategy, Kuehn 2026-05-09) Bezug:** Tag-Manager-Pattern (Prefix-Field-Hijack waehrend Tuning) ist konzeptuell verwandt mit Kuehn's `RetroactiveAggregation`-Strategie — beide sind Single-Threaded-Phasen, die Telemetrie-Daten von Blattnaehe nach Wurzel propagieren ohne Hot-Path-Cache-Kohaerenz-Druck.
- **Forschungs-Mission-Statement (Block AP):** START steht klassisch fuer **informierte** Architektur-Entscheidungen (Cache-Estimator + DP-Tuning) — direkt der Vergleichsachse heuristisch ↔ informiert.

## 8. Verweise

- **Voranalyse-Output:** `_voranalyse_output_klasse_a/P05-START__START.txt`
- **NOTICE-Eintrag:** `comdare-cache-engine/NOTICE` (MIT, Copyright Michael Jungmair 2020)
- **Bausteine_Matrix:** Achse 1 PAGE_REWIRED (P05), Achse 11 TELEMETRY_TAG_MANAGER (P05), Achse 10 CACHE_COST_MEASUREMENT (P05)
- **Re-Impl. Modul:** Adapter-Pfad mit teilweiser Code-Uebernahme; KEIN LEGACY_REIMPL-Skelett noetig
