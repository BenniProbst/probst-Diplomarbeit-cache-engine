# Domaenenmodell v4 — Konsolidierter Master

**Stand:** 2026-05-15 (K-D.3)
**Quelle:** Konsolidierung von `Domaenenmodell_PRT_ART.txt` (v1) bis `Domaenenmodell_PRT_ART_v4_DELTA.txt`
(alle in `../termine/20260508 Termin 7/`)
**Aufbau:** v3 ist die strukturelle Master-Version (742 Zeilen, 7 Domaenen + Bausteine-Matrix); v4 sind 8 KORREKTUREN (D-1 bis D-8) — bei Konflikt v4 > v3.

---

## §1 Versions-Stack

| Version | Datum | LOC | Status | Aenderungs-Schwerpunkt |
|---|---|---|---|---|
| v1 | (urspruenglich) | 623 | abgeloest | Erste Domaenen-Definition |
| v2 | (legacy) | 1025 | abgeloest | Architektur-Korrekturen Nutzer |
| v3 | 2026-05-04 | 742 | strukturell gueltig | Phase 3.D REV 3, F1-F15 eingearbeitet |
| v4 | 2026-05-04 | 429 (Delta) | aktiv | F-EXTRA-1 bis F-EXTRA-8 + F10-K + F12-K Korrekturen |

**Konfliktregel:** v4 KORREKTUR > v3 Original.

---

## §2 v3 Strukturelle Basis (742 Zeilen, 7 Domaenen)

### 2.1 Architektur-Grundprinzipien (REV 3)
- Quelle: `../termine/20260508 Termin 7/Domaenenmodell_PRT_ART_v3.txt:28-94`
- Inhalt: F1-F15 Konsequenzen
- Kern: F12 (CacheEngine im Builder, kein separater Singleton), F1 (Mess-Kategorie x Algorithmus-Detail Matrix), F2 (Observer Push synchron + Command-Lambda-Trees), F5 (In-Memory MeasurementBuffer), F7+F9+F10 (Module-Permutationen via CMake Pre-Build), F15 (Bausteine-Quer-Permutation als zentrales Forschungs-Prinzip)

### 2.2 Bausteine-Matrix (NEU — zentral fuer F15)
- Quelle: `Domaenenmodell_PRT_ART_v3.txt:96-239`
- Inhalt: 11 Achsen Bausteine x Algorithmen-Variation
- Cross-Refs: `../bausteine/01_bausteine_matrix.md` (K-E.2)

### 2.3 Domaene 1 — Search Engine (REV 3)
- Quelle: `Domaenenmodell_PRT_ART_v3.txt:241-320`
- Sub-Sektionen:
  - 3.1 Algorithmus-Module als C++23 ABI-stabile Module (F9)
  - 3.2 Observer-Push + Command-Lambda-Trees (F2) — KORRIGIERT in v4 D-2
  - 3.3 Visitor-Mid-Granularitaet (F3)
  - 3.4 ValueHandle: std::variant + Concept-Constraint (F8)
  - 3.5 ConcurrencyManager: Klassen + Policy-Template (F6)

### 2.4 Domaene 2 — Cache Engine & Builder (komplett neu strukturiert, F12)
- Quelle: `Domaenenmodell_PRT_ART_v3.txt:322-469`
- Sub-Sektionen:
  - 4.1 Oberste Einheit: CacheEngineBuilder (= main.cpp Orchestrator) — KORRIGIERT in v4 D-3
  - 4.2 Permutations-Build-Pipeline (F10) — KORRIGIERT in v4 D-4
  - 4.3 Cache Engine (Komponente innerhalb des Builders)
  - 4.4 Singleton-Mechanik (F1)
  - 4.5 Mess-Kategorie × Algorithmus-Detail Matrix (F1, zentral) — KORRIGIERT in v4 D-5

### 2.5 Domaene 3 — Measurement (3 Bestandteile, In-Memory)
- Quelle: `Domaenenmodell_PRT_ART_v3.txt:471-503`
- Sub-Sektionen:
  - 5.1 Mikrobenchmark-Triggering (F11)
  - 5.2 In-Memory MeasurementBuffer (F5)
  - 5.3 Mikrobenchmarks-Packages (Bibliothek)

### 2.6 Domaene 4 — Hardware / ISA (F9 + F13)
- Quelle: `Domaenenmodell_PRT_ART_v3.txt:505-543`
- Sub-Sektionen:
  - 6.1 ISA-Dispatch
  - 6.2 Plattform-Workflow (F13) — KORRIGIERT in v4 D-7
  - 6.3 Original-Compiler-Pipeline (F7) — KORRIGIERT in v4 D-6 (KRITISCH)

### 2.7 Domaene 5 — Engine-Choice
- Quelle: `Domaenenmodell_PRT_ART_v3.txt:545-...`
- Inhalt: StaticEngine vs CacheEngine, Compile-Time-Wahl

---

## §3 v4 Delta — 8 Korrekturen (F-EXTRA-1 bis F-EXTRA-8 + F10-K + F12-K)

### D-1 (Z 22-59) — §1(C) CACHEENGINE-LOKATION (F12-K)
**v3 sagt:** CacheEngine lebt im CacheEngineBuilder, KEIN separates Singleton.
**v4 KORREKTUR:** (siehe Original-Datei `Domaenenmodell_PRT_ART_v4_DELTA.txt:32-59` fuer voll-ausgeschriebene Korrektur)

### D-2 (Z 60-109) — §3.2 DECISIONLAMBDATREES PRO BAUSTEIN (F-EXTRA-6)
**Inhalt:** Pro Baustein eigener DecisionLambdaTree statt zentralem Tree.

### D-3 (Z 110-139) — §4.1 BUILDER-LIFECYCLE (F-EXTRA-1, Compiler-Layering)
**Inhalt:** Builder-Lifecycle-Klarstellung mit Compiler-Layering (Hauptcompiler vs Original-Compiler).

### D-4 (Z 140-163) — §4.2 PRE-BUILD-PIPELINE (F-EXTRA-5)
**Inhalt:** Pre-Build-Pipeline ohne Python (CMake/sh/bat). KEIN Python in PRT-ART-Build (Memory-Direktive).

### D-5 (Z 164-195) — §4.5 MESS-MATRIX MIT DEFAULT+OVERRIDE (F-EXTRA-7)
**Inhalt:** Mess-Matrix mit Default-Mess-Hooks pro Algorithmus-Detail + Algo-spezifische Override-Moeglichkeit.

### D-6 (Z 196-230) — §6.3 ORIGINAL-COMPILER-PIPELINE (F-EXTRA-1, KORRIGIERT)
**Inhalt (KRITISCH):** Original-Compiler-Pipeline-Klarstellung. Bausteine werden mit ihrem Original-Compiler kompiliert; statisches Linken in den C++23-Modul-Wrapper.

### D-7 (Z 231-260) — §7 PLATTFORM-WORKFLOW ERWEITERT (F-EXTRA-3, F-EXTRA-4)
**Inhalt:** Plattform-Workflow um SOCKS5-ZIH-Lieferung + Cross-Compile-Infrastruktur erweitert.

### D-8 (Z 261-...) — §11 PROJEKT-STRUKTUR ERWEITERT (alle F-EXTRA)
**Inhalt:** Projekt-Struktur erweitert um alle F-EXTRA-Beschluesse.

---

## §4 Domaenen-Uebersicht (konsolidiert)

| # | Domaene | Verantwortlich | Hauptkonzepte (v3+v4) | Quelle (Z in v3) |
|---|---|---|---|---|
| 1 | **Search Engine** | Pruefling | C++23 ABI-Module, Observer+Command-Lambda-Trees, Visitor, ValueHandle (std::variant), ConcurrencyManager | v3:241 |
| 2 | **Cache Engine & Builder** | WIE | CacheEngineBuilder als main.cpp Orchestrator, Permutations-Build-Pipeline, Singleton-Mechanik, Mess-Matrix | v3:322 |
| 3 | **Measurement** | WIE | Mikrobenchmark-Triggering (F11), In-Memory MeasurementBuffer (F5), Mikrobenchmark-Bibliothek | v3:471 |
| 4 | **Hardware / ISA** | Querschnitt | ISA-Dispatch, Plattform-Workflow (F13), Original-Compiler-Pipeline (F7+F-EXTRA-1) | v3:505 |
| 5 | **Engine-Choice** | WIE | StaticEngine vs CacheEngine, Compile-Time-Wahl | v3:545 |
| (zusaetzl.) | **Bausteine-Matrix** | F15 zentrales Forschungs-Prinzip | 11 Achsen Bausteine x Algorithmen-Variation | v3:96 |

---

## §5 Aktueller Code-Stand-Bezug (V12-V31, post Termin 7)

Die Domaenen sind bis V31 (2026-05-14) inkrementell implementiert:

| Domaene | V12-V31 Implementations-Status |
|---|---|
| 1 Search Engine | V12 hybride PrtArtSearchEngine (Vector/Map/Tuple) + status_t errno-style ABI |
| 2 Cache Engine & Builder | V13 runtime_codegen + functional_tests + CMake Stage-1/2; V30 libs/-Migration; V25-V26 Profile-Stack mit `<expected_workload>` + `<allocator_override>` |
| 3 Measurement | V20 PermutationResult.workload_used Field; V21-V22 Sample-Mess-Daten + diagram_generator E2E |
| 4 Hardware / ISA | (unverandert seit Termin 7) |
| 5 Engine-Choice | V30.D.3 engine_choice/ -> libs/common/config/ (umbenannt + ALIAS comdare::common::config) |
| Bausteine | V25.B+V26.A 30 SOTA + 10 Allokator-Profile mit Workload-Tag; V31 22 Adapter-Inhalte |

---

## §6 Querverweise

- Original-Quellen (UNVERAENDERT, Memory-Direktive "niemals Doku loeschen"):
  - `../termine/20260508 Termin 7/Domaenenmodell_PRT_ART_v4_DELTA.txt` (Korrekturen)
  - `../termine/20260508 Termin 7/Domaenenmodell_PRT_ART_v3.txt` (strukturell gueltig)
  - `../termine/20260508 Termin 7/Domaenenmodell_PRT_ART_v2.txt` (legacy)
  - `../termine/20260508 Termin 7/Domaenenmodell_PRT_ART.txt` (v1, Vorstufe)
- Begriffsglossar v7 Master: `01_begriffsglossar_v7_master.md` (K-D.2)
- Versionshistorie Detail: `03_versionshistorie.md` (K-D.4)
- Architekturentscheidungen F1-F15: `../bausteine/04_architekturentscheidungen_F1_F15.md` (K-E.5)
- Bausteine-Matrix: `../bausteine/01_bausteine_matrix.md` (K-E.2)
- Architektur REV7.7 Master: `../architektur/02_aktueller_master_REV7_7.md` (K-C.3)
