# Glossar + Domaenenmodell — Versionshistorie

**Stand:** 2026-05-15 (K-D.4)
**Zweck:** Versions-Diff-Tabelle ueber alle Begriffsglossar- + Domaenenmodell-Versionen mit Datum, Aenderungs-Schwerpunkt und Auswirkung.

---

## §1 Begriffsglossar v1 → v7 — Aenderungs-Tabelle

| Version | Datum | LOC | Was wurde NEU/GEAENDERT | Warum (Auslaeser) | Konsequenz |
|---|---|---|---|---|---|
| **v1** (Vorstufe) | (initial) | 496 | Erste Begriffs-Sammlung Domaenenmodell-Vorstufe | Auftakts-Konsolidierung Termin 1-3 | Basis fuer Phase 3 |
| **v2** (legacy) | (Phase 3 PRE) | (n/a) | Erste konsolidierte Form | Phase 3 PRE-UML-Klaerung | Wird durch v3 abgeloest |
| **v3 FINAL** | 2026-05-04 | 1287 | Master mit Paper-Belegen P01-P33; **JEDER Begriff** hat min. 1 Paper-Quelle mit P-ID; Cross-Paper-Identitaetsmatrix erweitert auf alle 33 Paper; geschaerfte Domaenen-Trennung; 4 Domaenen | Phase 3.C abgeschlossen (33-Paper Tieflektuere) | Strukturell gueltig fuer alle Folge-Versionen; Hauptmasse der Begriffs-Definitionen |
| **v4 FINAL** | (Phase 5) | 533 | Architektur-Pattern (Observer, Visitor, Strategy, Adapter, Singleton, Command), Engine-Choice (CACHE/STATIC), Cache Engine Builder + Runtime, Familien-Klassifikation, std::map-API-Vertrag, C++23 Concepts, ConcurrencyManager (Singleton), Permutation Engine, Habich-Direktive (Adapter-Pattern fuer Originalcode), COMDARE-MODULES-SUBMODULES (Ausnahme zur No-Submodules-Regel), KORREKTUR ValueHandle, RCU-Reclaim BLEIBT (Hazard Pointers ENTFERNT — F12-K) | Phase 5 PRE-UML Architekturklaerung; F1-F15 + F-EXTRA-Beschluesse | Architektur-Vokabular eingefroren |
| **v5 FINAL** | (F1-F15 Beschluss) | 462 | DecisionLambdaTree, Konsolidierungsbarriere, In-Memory Measurement Buffer, ABI-Stabiles C++23-Modul, Modul-Permutation, PERM_ID, Module Loader, Permutations-Build-Pipeline, Original-Compiler-Pipeline (F7), CacheEngine.reset(), Experiment-Loop, Compile-Time-Modus vs Runtime-Modus, Mess-Kategorie x Algorithmus-Detail Matrix, Bausteine-Quer-Permutation (F15), Bausteine-Matrix, Plattform-Workflow, SOCKS5-Lieferung, Concurrency Composition (Policy-Template) | F1-F15 als kanonische Beschluesse | Beschluss-Begriffe konkretisiert |
| **v6 FINAL** | (F-EXTRA) | 366 | Permutations-Flag-System, Flag-Bank, Permutation-Identifier (wohl geordnet), ConstraintFilter als Bit-Maskierung, CacheEngine-Lokation (KORRIGIERT), Ressourcen-Injektion, Hauptcompiler vs Original-Compiler, Static Linking, ABI-Multi-Compiler-Pipeline, Compiler-Provisioning, Bausteine-DecisionLambdaTree, Tree-Komposition, Metaprogrammierung vs Binary-Identitaet, Cross-Build auf x86-Host, Stage-2 Native Build (Verifikation), Permutation-Codegen-Skript, Default-Mess-Hook, Algo-spezifischer Override, HasMeasurement-Concept-Constraint, Generische + Spezifische Google Tests, ABI-Stabilitaets-Test (CI), Habich-Log (Bei Bit-Abweichung), SOCKS5-ZIH-Lieferung (Default), GitLab-CI-Push-Erweiterung, Fortigate-31G-Edge | F-EXTRA-1 bis F-EXTRA-8 Beschluesse | Korrekturen + F-EXTRA-Operationalisierung |
| **v7 FINAL** | 2026-05-09 | 284 | Cache-Coherence-Anti-Pattern (Cacheline-Ping-Pong) aus Kuehn 2026-05-08 P28 Mailverlauf; Not-In-Top-Levels-Constraint; LeafOnly-Counter (Kuehn NEU); RetroactiveAggregation (Kuehn NEU); LeafOnly-Sampled-Counter<N> (Kuehn NEU); Sampling-Rate-Adjustment-Tree (PRT-ART eigene Erweiterung); Cache-Coherence-Cost (Cost-Funktion in MemoryAccessConcurrency::Write); Production-Cluster-Spez (Talos OS, 9950X3D + 14900KS); X3D-V-Cache-Awareness; Forschungs-Mission-Statement (heuristisch vs informiert vs automatische Anpassung) | Kuehn-Antwort-Erkenntnisse (P28-Mailverlauf 2026-05-08) + Probst-Antwort an Kuehn 2026-05-08 mit Plattform-Spezifikation + Forschungs-Mission | Operationalisierung Telemetrie + Plattform-Konkretisierung |

**Konfliktregel:** spaetere Version gewinnt (v7 > v6 > v5 > v4 > v3 > v2 > v1).

---

## §2 Domaenenmodell v1 → v4 — Aenderungs-Tabelle

| Version | Datum | LOC | Was wurde NEU/GEAENDERT | Warum (Auslaeser) | Konsequenz |
|---|---|---|---|---|---|
| **v1** | (urspruenglich) | 623 | Erste Domaenen-Definition Suchalgorithmen | Domaenen-Identitaeten Initial | Basis |
| **v2** | (Phase 3.D REV 2) | 1025 | Architektur-Korrekturen Nutzer | Phase 3.D REV 2 Beschluss | Erweitert um Cache-Engine-Bausteine als 2. Domaene |
| **v3** | 2026-05-04 | 742 | F1-F15 eingearbeitet als Konsequenzen; Bausteine-Matrix als zentrale F15-Konstruktion; 7 Domaenen (Search Engine, Cache Engine & Builder, Measurement, Hardware/ISA, Engine-Choice + Bausteine-Matrix als Querschnitt) | F1-F15 Beschluss-Doku abgeschlossen | Strukturell gueltig fuer alle Folge-Versionen |
| **v4 (DELTA)** | 2026-05-04 | 429 | 8 KORREKTUREN D-1 bis D-8: F-EXTRA-Beschluesse + F10-K + F12-K Korrekturen; Compiler-Layering klargestellt (Hauptcompiler vs Original-Compiler); KEIN Python in Build (D-4); Mess-Matrix Default+Override (D-5); Original-Compiler-Pipeline KRITISCH klargestellt (D-6) | F-EXTRA-1 bis F-EXTRA-8 + F10-K + F12-K Beschluss | Korrekturen ueberlagern v3, ergaenzen aber nicht Re-Strukturierung |

**Konfliktregel:** v4 KORREKTUR > v3 Original.

---

## §3 Wichtigste Aenderungen pro Version-Sprung

### v3 → v4 (Begriffsglossar)
- ValueHandle als KORRIGIERT (Concept-Constraint geklart)
- Hazard Pointers ENTFERNT (F12-K Beschluss: memory-leak == undefined behavior, RCU bevorzugt)
- Habich-Direktive zentral verankert (Adapter-Pattern fuer Originalcode)
- COMDARE-MODULES-SUBMODULES als Ausnahme zur No-Submodules-Regel

### v4 → v5 (Begriffsglossar)
- DecisionLambdaTree als zentraler F2-Mechanismus
- In-Memory MeasurementBuffer (kein externer DB-Stack)
- ABI-Stabiles C++23-Modul + ModuleLoader-Pattern
- F15 Bausteine-Quer-Permutation als zentrales Forschungs-Prinzip operationalisiert

### v5 → v6 (Begriffsglossar)
- Permutations-Flag-System (Bit-basierte Permutation-Identifier)
- Compiler-Layering (Hauptcompiler vs Original-Compiler) klargestellt
- Default-Mess-Hooks pro Algorithmus-Detail + Algo-spezifischer Override
- HasMeasurement-Concept-Constraint
- ABI-Stabilitaets-Test in CI (Habich-Log bei Bit-Abweichung)

### v6 → v7 (Begriffsglossar)
- Cache-Coherence-Anti-Pattern aus Kuehn-Mail (Multi-Core-Telemetrie-Falle)
- LeafOnly-Counter-Familie (4 Begriffe: LeafOnly, Retroactive, Sampled<N>, Adjustment-Tree)
- Cache-Coherence-Cost als Cost-Funktion in MemoryAccessConcurrency
- Production-Cluster-Spez (9950X3D + 14900KS)
- X3D-V-Cache-Awareness als neue Plattform-Disziplin
- Forschungs-Mission-Statement (heuristisch vs informiert vs adaptive)

### v3 → v4 (Domaenenmodell)
- 8 Korrekturen D-1 bis D-8
- D-1: CacheEngine-Lokation Klarstellung
- D-2: DecisionLambdaTrees pro Baustein (statt zentral)
- D-3: Builder-Lifecycle mit Compiler-Layering
- D-4: Pre-Build ohne Python
- D-5: Mess-Matrix Default+Override
- D-6: Original-Compiler-Pipeline KRITISCH klargestellt
- D-7: Plattform-Workflow + SOCKS5/Cross-Compile
- D-8: Projekt-Struktur erweitert

---

## §4 Begriffs-Migrations-Notizen

### Begriffe, die ENTFERNT wurden
| Begriff | Entfernt in | Grund |
|---|---|---|
| Hazard Pointers | v4 (F12-K) | memory-leak == undefined behavior; RCU bevorzugt |

### Begriffe, die KORRIGIERT wurden
| Begriff | Korrigiert in | Korrektur |
|---|---|---|
| ValueHandle | v4:321 | Concept-Constraint klargestellt |
| CacheEngine-Lokation | v6:84 | Klarstellung (vgl. v3 §1(C) → v4 D-1) |

### Begriffe, die durch v7-Mailverlauf NEU dazugekommen sind
| Begriff | Quelle | Bedeutung |
|---|---|---|
| Cache-Coherence-Anti-Pattern | v7:33, Kuehn 2026-05-08 | Cache-Kohaerenz-Ping-Pong bei Multi-Core-Schreibern |
| LeafOnly-Counter | v7:71, Kuehn NEU | Counter nur in Blatt-Knoten (Multi-Core-tauglich) |
| RetroactiveAggregation | v7:95, Kuehn NEU | Wurzel-Up-Traversal vor Reordering |
| LeafOnly-Sampled-Counter<N> | v7:117, Kuehn NEU | Sampling-Variante (nur jeder N-te Zugriff zaehlt) |
| Sampling-Rate-Adjustment-Tree | v7:141, PRT-ART eigene Erweiterung | DecisionLambdaTree fuer N-Anpassung |
| X3D-V-Cache-Awareness | v7:207, Probst-Antwort an Kuehn | Ryzen 9950X3D asymmetrischer L3 (96+32 MiB) |
| Forschungs-Mission | v7:224, Probst-Antwort an Kuehn | Heuristisch vs informiert + automatische Anpassung |

---

## §5 Querverweise

- Begriffsglossar v7 Master: `01_begriffsglossar_v7_master.md` (K-D.2)
- Domaenenmodell v4 Master: `02_domaenenmodell_v4_master.md` (K-D.3)
- Original-Quellen (UNVERAENDERT):
  - `../termine/20260508 Termin 7/Begriffsglossar_v*.txt`
  - `../termine/20260508 Termin 7/Domaenenmodell_PRT_ART*.txt`
- Kuehn-Erkenntnisse: `../termine/20260508 Termin 7/Kuehn_Erkenntnisse_Einarbeitung_2026_05_09.txt`
- Habich-Feedback: `../termine/20260508 Termin 7/Habich_Feedback_2026_05_08.txt`
- Mailverlauf P28: `../../Code/external/comdare-cache-engine/docs/email/20260508-1900-mailverlauf_kuehn_p28_eingang.md`
