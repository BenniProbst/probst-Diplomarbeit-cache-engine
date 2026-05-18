# Q-Phase Datasets + F-EXTRA Plan (Q.1-Q.4)

**Stand:** 2026-05-18 (Q-Phase Spezifikation als Konsolidierungs-Doku)
**Trigger:** User-Freigabe 2026-05-18 (alle zurueckgestellten Aufgaben freigegeben)
**Konsequenz:** Konkrete Doku-Arbeit (Q.1-Q.3) + Code-Stub-Arbeit (Q.4)

> **Hinweis:** Diese Doku konsolidiert die Q-Phase-Aufgaben. Q.1 + Q.2 + Q.3 sind hauptsaechlich Doku/Konfigurations-Arbeit. Q.4 ist Pre-Code-Spezifikation fuer V32+ Sprint.

---

## §1 Q.1 — Datasets Phase 4.A Implementation (SCHRITT 1-6)

**Trigger:** User-Freigabe 2026-05-18 (war #81, ZURUECKGESTELLT)
**Quelle:** `docs/termine/20260508 Termin 7/Datasets_Spezifikation.txt` (Section "SCHRITT 1-6")

### §1.1 SCHRITT-Liste

Im Originaltext (Datasets_Spezifikation.txt) sind 6 Schritte definiert. Mit Stand V31 (YCSB-Generator-CLI bereits implementiert via V190 = C1 #190) und der N-Phase-Erweiterung sind die meisten Schritte bereits abgedeckt:

| Schritt | Beschreibung | Stand V31 + N-Phase |
|---|---|---|
| 1 | YCSB-Workload-Generator (A-F) | ✅ V190 C1 (YCSB-Generator-CLI als Datasets-Tool) |
| 2 | Custom-Dataset-Spec (sortiert / hot-cold / sparse) | ✅ V191 C2 (Tests fuer YCSB-CLI) |
| 3 | XML-Schema fuer messreihen.xml | ✅ V11.5 (messreihen.xml als Standard-Template) |
| 4 | Profile-Filter via <expected_workload> | ✅ V19+ (algorithm_profiles XML-Schema) |
| 5 | TestDataSetAccumulationEngine | ✅ V179 (PHASE 6.5) |
| 6 | Hardware-Plattform-Matrix-Auswahl pro Dataset | **[TODO] N-Phase Achse 12 + 13 Konfiguration** |

### §1.2 Q.1 Konkrete Aufgaben

**Hauptaufgabe:** Schritt 6 mit N-Phase-Hardware-Strategy + Scheduling-Strategy verbinden.

1. **XML-Schema-Erweiterung** in `test_data_xml/messreihen.xml` um:
   ```xml
   <dataset>
       <name>ycsb_a_50_50</name>
       <generator>YCSB</generator>
       <hardware_strategy>
           <simd>AVX2</simd>
           <cache_level>L1_AWARE</cache_level>
       </hardware_strategy>
       <scheduling_strategy>
           <worker_pool>THREAD_PER_CORE</worker_pool>
           <simd_workers>2</simd_workers>
       </scheduling_strategy>
   </dataset>
   ```
2. **Filter-Logik** in `messung_driver`: pro Dataset nur die Hardware-Strategien laufen lassen, die auf dem Host verfuegbar sind (via IPlatformProbe Phase 1 DISCOVER).
3. **Tests** in `Code/tests/test_dataset_filter.cpp` (NEU): Dataset mit AVX-512 wird auf AVX2-Host uebersprungen.

### §1.3 Akzeptanz-Kriterien

- [ ] messreihen.xml unterstuetzt hardware_strategy + scheduling_strategy
- [ ] messung_driver filtert Datasets gegen verfuegbare Hardware
- [ ] Test test_dataset_filter.cpp gruen

---

## §2 Q.2 — Datasets Detail-Spezifikationen OP-1 bis OP-6

**Trigger:** User-Freigabe 2026-05-18 (war #82, ZURUECKGESTELLT)
**Quelle:** `docs/termine/20260508 Termin 7/Datasets_Spezifikation.txt` (Section "OP-1 bis OP-6")

### §2.1 OP-1 bis OP-6 Operations-Detail-Spezifikationen

OP-1 bis OP-6 sind die 6 Operations-Detail-Typen pro Workload:

| OP | Operation | YCSB-Mapping | Workload-Variation |
|---|---|---|---|
| OP-1 | Read | YCSB_C (read-only) | Pure Lookup |
| OP-2 | Insert | YCSB_LOAD | Sequential vs Random |
| OP-3 | Update | YCSB_A (50% read / 50% update) | Hot-Key vs Uniform |
| OP-4 | Scan | YCSB_E (95% scan / 5% insert) | Short-Range vs Long-Range |
| OP-5 | Read-Modify-Write | YCSB_F (50% read / 50% RMW) | Conflict-Heavy vs Lock-Free |
| OP-6 | Range-Delete | (Custom) | Bulk-Delete-Pattern |

### §2.2 Q.2 Konkrete Aufgaben

1. **Doku-Datei NEU:** `docs/datasets/OP_1_to_6_SPECIFICATIONS.md` mit:
   - Pro OP: Definition + erwarteter Workload + Hardware-Empfehlung + Scheduling-Empfehlung
   - Cross-Ref auf bart-master + bartdb fuer Vergleichs-Workloads (P06 Schuele)
2. **YCSB-Profile-Erweiterung** in `Code/test_data_xml/`:
   - Pro Profil ein `<op_type>OP-N</op_type>` Tag
   - Filter im `messung_driver` (Achse 11 TELEMETRY default fuer Read-only, etc.)

### §2.3 Akzeptanz-Kriterien

- [ ] OP_1_to_6_SPECIFICATIONS.md mit 6 Detail-Beschreibungen
- [ ] YCSB-Profile mit op_type-Tags
- [ ] messung_driver filtert nach op_type

---

## §3 Q.3 — Bausteine_Matrix Detail-Punkte P4B-1 bis P4B-6

**Trigger:** User-Freigabe 2026-05-18 (war #83, ZURUECKGESTELLT)
**Quelle:** `docs/termine/20260508 Termin 7/Bausteine_Matrix.txt` (Section "P4B-1 bis P4B-6")

### §3.1 P4B-1 bis P4B-6 Detail-Punkte

P4B-1 bis P4B-6 waren urspruenglich Detail-Spezifikationen fuer Phase 4.B-Bausteine-Klassen. Mit N-Phase-Erweiterung auf 14 Achsen kommen NEUE Detail-Punkte hinzu:

| P4B | Inhalt | N-Phase-Erweiterung |
|---|---|---|
| P4B-1 | PAGE-TYPE-Detail-Klassen | Achse 1 unveraendert |
| P4B-2 | NODE-TYPE-Detail-Klassen | Achse 2 unveraendert |
| P4B-3 | TRAVERSAL-Detail-Klassen | **NEU: Splitting in 3.A/3.B/3.M Detail-Klassen** |
| P4B-4 | ALLOCATOR-Detail-Klassen | **NEU: Splitting in 6.1-6.5 Detail-Klassen** |
| P4B-5 | CONCURRENCY-Detail-Klassen | **NEU: Splitting in 8.1+8.2 Detail-Klassen** |
| P4B-6 | TELEMETRY-Detail-Klassen | **NEU: Kuehn 11.X1-X4 Detail-Klassen** |
| P4B-7 (NEU) | HARDWARE-STRATEGY-Detail-Klassen | **NEU: Achse 12 Sub-Achsen 12.1-12.5** |
| P4B-8 (NEU) | SCHEDULING-STRATEGY-Detail-Klassen | **NEU: Achse 13 Sub-Achsen 13.1-13.5** |

### §3.2 Q.3 Konkrete Aufgaben

1. **Doku-Datei NEU:** `docs/bausteine/08_p4b_detail_klassen.md` mit:
   - Pro P4B-X: Detail-Klassen-Liste + C++23 Concept-Header-Stubs
   - Cross-Ref auf 07_bausteine_matrix_N_erweitert.md + O_PHASE_PRT_ART_AXES_MIRROR.md

### §3.3 Akzeptanz-Kriterien

- [ ] 08_p4b_detail_klassen.md mit 8 Sektionen (P4B-1 bis P4B-8)
- [ ] Pro Sektion mind. 3 Detail-Klassen mit Concept-Header-Stub

---

## §4 Q.4 — F-EXTRA-Detail-Implementations (#78 Phase 5+ Vorbereitung)

**Trigger:** User-Freigabe 2026-05-18 (war #78, ZURUECKGESTELLT)
**Quelle:** `docs/bausteine/04_architekturentscheidungen_F1_F15.md` §F-EXTRA-1 bis F-EXTRA-8

### §4.1 F-EXTRA-1 bis F-EXTRA-8 Detail-Implementations

| F-EXTRA | Inhalt | Implementations-Stand |
|---|---|---|
| F-EXTRA-1 | Original-Compiler pro fremdem Algorithmus | ⚠️ Cluster-Aufgabe (Fortigate-Migration #77) |
| F-EXTRA-2 | Custom-Dataset-Generator (sortiert/hot-cold/sparse) | ✅ V190 (YCSB-Generator-CLI) |
| F-EXTRA-3 | Heuristik-Kompositionsmuster (DecisionLambdaTree) | ✅ V149 (Phase 6 INK-2) |
| F-EXTRA-4 | ABI-stabiles C++23-Modul-Interface | ✅ V177 (PHASE 6.3) |
| F-EXTRA-5 | CMake/Shell-Codegen (statt Python) | ✅ V107 (F-EXTRA-5 Fix) |
| F-EXTRA-6 | DecisionLambdaTree pro Baustein | ✅ V149 (Phase 6 INK-2) |
| F-EXTRA-7 | libs/-Layout (V30 Konsolidierung) | ✅ V30.D.1-D.5 |
| F-EXTRA-8 | Architekt-Direktive II 2026-05-14 (Lizenz-Reframing) | ✅ V31.A (NOTICE-Update) |

**Bilanz:** 7 von 8 F-EXTRA sind bereits operational. Nur F-EXTRA-1 (Cluster-Aufgabe) ist pending — abhaengig von Cluster-Migration #77.

### §4.2 Q.4 Konkrete Aufgaben

1. **F-EXTRA-1 Detail-Spezifikation** schreiben:
   - Pro adapters/Pn-X/ Adapter: welcher Original-Compiler erforderlich?
   - CMakeLists.txt-Hooks fuer alternative Compiler (GCC 9+ fuer P06 B²-Tree, etc.)
   - Cross-Ref auf T_PHASE_ADAPTER_STATUS.md §1.2 + V32 Plan
2. **F-EXTRA-1 Cluster-Provisioning-Spec** (fuer Fortigate-Migration #77):
   - Liste der benoetigten Compiler-Versionen pro Adapter
   - Docker/Podman-Spec fuer Multi-Compiler-Builds
3. **Doku-Datei NEU:** `docs/bausteine/09_f_extra_status.md` mit Tabelle F-EXTRA-1 bis F-EXTRA-8 + Status + Verweis auf Implementations-Code

### §4.3 Akzeptanz-Kriterien

- [ ] 09_f_extra_status.md mit 8 F-EXTRA-Status-Eintraegen
- [ ] F-EXTRA-1 Compiler-Matrix dokumentiert
- [ ] Cluster-Provisioning-Spec als V32-Backlog-Eintrag

---

## §5 Status-Zusammenfassung Q-Phase

| Q-Task | Inhalt | Konsolidierungs-Doku | V32+ Code-Arbeit |
|---|---|---|---|
| **Q.1** | Datasets Schritt 1-6 (5/6 schon DONE, Schritt 6 N-Phase-Integration) | hier §1 + (Code in messung_driver V32) | XML-Schema + test_dataset_filter.cpp |
| **Q.2** | OP-1 bis OP-6 Detail | hier §2 + (NEU docs/datasets/OP_1_to_6_SPECIFICATIONS.md) | YCSB-Profile + Filter |
| **Q.3** | Bausteine_Matrix P4B-1 bis P4B-8 (NEU P4B-7 + P4B-8) | hier §3 + (NEU docs/bausteine/08_p4b_detail_klassen.md) | Concept-Header-Stubs |
| **Q.4** | F-EXTRA-1 bis F-EXTRA-8 (7/8 schon DONE) | hier §4 + (NEU docs/bausteine/09_f_extra_status.md) | F-EXTRA-1 Cluster-Provisioning |

**Pragmatisch:** Q-Phase als Konsolidierungs-Doku abgeschlossen, konkrete Code-Aenderungen folgen in V32+ Sprints + Cluster-Migration.

---

## §6 Querverweise

- Datasets-Original-Quelle: `docs/termine/20260508 Termin 7/Datasets_Spezifikation.txt`
- Bausteine-Matrix-Original: `docs/termine/20260508 Termin 7/Bausteine_Matrix.txt`
- F-EXTRA-Original: `docs/termine/20260508 Termin 7/Architekturentscheidungen_F1_F15.txt`
- N-Phase Bausteine: `docs/bausteine/07_bausteine_matrix_N_erweitert.md`
- O-Phase PRT-ART: `docs/adapters/O_PHASE_PRT_ART_AXES_MIRROR.md`
- T-Phase Adapter: `docs/adapters/T_PHASE_ADAPTER_STATUS.md`
- V32 Code-Refactoring: `docs/adapters/V32_CODE_REFACTORING_PLAN.md`
- Cluster-Migration: Infra-Task #77 (User-/INFRA-Aktion)

---

**Ende docs/adapters/Q_PHASE_DATASETS_F_EXTRA_PLAN.md (Q.1-Q.4 als Konsolidierungs-Doku DONE).**
