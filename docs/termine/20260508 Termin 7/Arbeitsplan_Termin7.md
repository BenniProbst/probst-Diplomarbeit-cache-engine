# Arbeitsplan Termin 7 — PRT-ART Diplomarbeit (2026-05-08, rueckwirkend konsolidiert 2026-05-15)

**Stand:** 2026-05-15 (K-J.1 — rueckwirkend erstellt fuer Konsistenz mit Termin-1-6 + Termin-8 Office-Trio)
**Vorgaenger:** Termin 6 (2026-04-16, Architektur REV4 + Scope-Freeze)
**Quelle:** `HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md` + `REVIEW_PLAN_6_TAGE.md` + Phase5_UML_Detail Doks 00-30

---

## §1 Was geplant war (zur Vorbereitung Termin 7)

Termin 7 sollte konsolidieren:
- UML-Detail-Architektur (REV5 → REV6 → REV7 → REV7.6) abgeschlossen
- Habich-Direktiven aus Sprechstunde 2026-05-08 verankert
- 33-Paper-Cluster-Tieflektuere abgeschlossen
- Bausteine-Matrix + Allokator-Matrix als zentrale Permutations-Doku
- Begriffsglossar v3 → v7 konsolidiert
- F1-F15 + 8 F-EXTRA Architektur-Entscheidungen verbindlich
- Drei-Repo-Aufteilung (cache-engine WIE / prt-art Pruefling / Diplomarbeit Code/ WAS)

---

## §2 Sprint-Plan vor Termin 7 (Phase 3.B → 3.D → Phase 5 PRE-UML → Phase 6+)

### 2.1 Phase 3.B (RIGOROSE Tieflektuere ALLER 33 Paper)
- Pro Paper-Notiz in `_review/papers/P*-*.md` (Cluster A-F)
- Cross-Paper-Konzeptmatrix (18 Konzepte ueber 33 Paper)
- Eigenschaften pro Algorithmus (23 Algorithmen, 4 Kategorien A-D)

### 2.2 Phase 3.C (Begriffsglossar v3 mit Paper-Belegen)
- Jeder Begriff hat min. 1 Paper-Quelle mit P-ID
- Cross-Paper-Identitaetsmatrix erweitert auf 33 Paper
- 4 Domaenen geschaerft

### 2.3 Phase 3.D (Domaenenmodell v3 + v4 Korrekturen)
- 7 Domaenen: Search Engine, Cache Engine & Builder, Measurement, Hardware/ISA, Engine-Choice, Bausteine-Matrix
- F1-F15 + F-EXTRA-Beschluesse eingearbeitet

### 2.4 Phase 5 PRE-UML (15 Design-Entscheidungs-Fragen + 8 F-EXTRA)
- 15 F-Fragen mit Architekt geklaert
- F10-K + F12-K Korrekturen
- F-EXTRA-1 bis F-EXTRA-8 Beschluesse

### 2.5 Phase 6 (Implementations-Inkremente INK-1 bis INK-8)
- INK-1: PermutationFlags + Event + ObserverRegistry
- INK-2: DecisionLambdaTrees (10+ Familien)
- INK-3: ConcurrencyManager (8 Disziplinen + 3 Mechaniken)
- INK-4: TelemetryStrategy Achse 11 (Kuehn 5 Strategien)
- INK-5: Plattform-Auto-Discovery (REV 3 K3.2)
- INK-6: CacheHierarchy + LiveModel + Scheduler + Heuristik + Mode
- INK-7: HybridCompositionCommand (Command-Pattern, REV 3 K3.4)
- INK-8: InMemoryMeasurementBuffer + Measure-Matrix (F5 + F1)

### 2.6 Phase 6.2 (Custom Allokation als Cache-Engine-Basisdisziplin)
- 5 Cluster AC1-AC5 (Foundation, Modern, NUMA, Concurrent, Standard)
- 23 Allokator-Paper A01-A23
- 7 Achsen AA1-AA7

### 2.7 Phase 6.3-6.6 (ABI + Builder + TestData + Mikrobenchmark)
- ABI-stabiles C++23-Modul-Interface
- CacheEngineBuilder als eigenstaendiges Programm
- TestDataSetAccumulationEngine
- Mikrobenchmark-Suite

### 2.8 Phase 7 (Permutations-Builds + Experiment-Loop)
- 7.1 Workload-Generator (YCSB-style + synthetic)
- 7.2 Echte cmake-Module-Build-Pipeline
- 7.3 ResultAggregator + Baseline-Vergleich
- 7.4 Experiment End-to-End Demo

---

## §3 Was zu Termin 7 fertig war (siehe `Arbeitsergebnis_Termin7.md`)

Alle Sprints aus §2 wurden erfolgreich abgeschlossen.
**Stand 2026-05-13 (Termin 7):** V1-V7 in `HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md` Tabelle.

**Drei-Repo-Architektur etabliert:**
- `cache-engine` (HEAD V7, "Demo pipeline OK" mit 54 DLLs)
- `prt-art` (REV 7.1 stabil)
- `Diplomarbeit/Code/` (5 Module: messung_driver, binary_to_csv, csv_to_latex, diagram_generator, latex_to_pdf)

---

## §4 Pflicht-Diskussionspunkt fuer Termin 7

**Granularitaet Messreihe B** (Cache-Engine-Permutationen):
- Allokator × Layout × Prefetch × Density × Sync = bis zu mehrere 100 DLLs
- Frage: Reduzierung auf Teil-Auswahl (3 × 3 × 2)?
- **Antwort des Architekten:** Nein, vollstaendige Messung erforderlich.

---

## §5 Naechste Sprints nach Termin 7

V8-V31 (siehe `HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md` NACHTRAG §7 + §8):
- V8-V11: User-Direktiven Implementations + 30 SOTA-Profile + ABI-Operations + CI
- V12-V15: std-API + Naming + thesis-Skelett + Manuskript Kapitel 01-07
- V16-V18: Build-Verifikation + Codegen-Templates
- V19-V22: Profile-Stack `<expected_workload>` + Mess-Pipeline E2E
- V23-V24: cache-engine Layout-Refactoring (libs/-Migration)
- V25-V29: Profile-Stack-Erweiterung + Allokator-Override
- V30: libs/-Migration vollstaendig (ohne `domain/`-Zwischenebene)
- V31: 22 Adapter-Inhalte + P27 hp-soft + NOTICE Architekt-Direktive II

(Detail siehe `../20260515 Termin 8/Arbeitsplan_Termin8.md`)

---

## §6 Querverweise

- Termin-7-Original-Vorbereitung: `HABICH_TERMIN7_ZUSAMMENFASSUNG_2026_05_13.md` (mit V12-V31 NACHTRAG)
- 6-Tage-Review-Plan: `REVIEW_PLAN_6_TAGE.md`
- Habich-Feedback 2026-05-08: `Habich_Feedback_2026_05_08.txt`
- Kuehn-Erkenntnisse 2026-05-09: `Kuehn_Erkenntnisse_Einarbeitung_2026_05_09.txt`
- Phase5_UML_Detail (Doks 00-30): `Phase5_UML_Detail/`
- Termin-8-Folge: `../20260515 Termin 8/`
- Master-Plan Konsolidierung: `../../MASTERPLAN_KONSOLIDIERUNG_TERMINE.md`
