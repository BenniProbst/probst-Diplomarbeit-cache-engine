# Termin 3 — 2026-04-09

**Stand:** 2026-05-15 (K-G.4)
**Hauptthema:** Benchmark- und Datensatzplan
**Office-Dokumente:** 3 (alle in `../termine/20260409 Termin 3/`)

---

## §1 Office-Dokumente (Original)

| Datei | Inhalt |
|---|---|
| `20260409_Arbeitsaufstellung_PRT_ART_Termin3_final.docx` | Arbeitsaufstellung Termin 3 |
| `20260409_PRT_ART_Benchmark_und_Datensatzplan_Termin3_final.docx` | Benchmark- und Datensatzplan |
| `20260409_PRT_ART_Termin3_Praesentation_final.pptx` | Termin-3-Praesentation |

---

## §2 Was besprochen wurde

- Benchmark-Plan (YCSB-Vorbereitung)
- Datensatz-Spezifikation (welche Workload-Mix-Verteilungen)
- Mess-Methodik (Throughput, Latenz, Cache-Miss, dTLB-Miss, ...)
- Hybrid-CPU-Trennung (cpu_core/* vs cpu_atom/* perf-Counter) — TUD-spezifische Direktive

---

## §3 Was entschieden wurde

- **YCSB-Workloads A-F** als Pflicht-Korpus
- **Datensatz-Quellen:** YCSB-Generator + Custom-Datasets (vorbereitend fuer F-EXTRA-2)
- **Mess-Kategorien-Matrix** (Vorgaenger zu F1)
- **Hybrid-CPU-Pflicht:** cpu_core/* vs cpu_atom/* trennen

---

## §4 Was im Termin ENTSTAND

| Artefakt | Stand |
|---|---|
| Datasets-Spezifikation | (Vor-Termin-Doku, spaeter in `Datasets_Spezifikation.txt` konsolidiert) |
| Mess-Kategorien | Erste Liste (Throughput, Latenz, CacheMiss, dTLBMiss, BranchMiss, Memory, ...) |
| Hybrid-CPU-Direktive | TUD-Pflicht in Plattform-Modell |

---

## §5 Wie implementiert wurde

V19-V22 (Profile-Stack + Mess-Pipeline E2E):
- V19: algorithm_profiles XML-Schema +`<expected_workload>` (YCSB-Workload-Tag)
- V20: PermutationResult.workload_used + ResultAggregator CSV/JSON
- V21: Sample-Mess-Daten + thesis chapter 06 Sample-Diagramm
- V22: diagram_generator plot_by_workload + End-to-End Sample-Pipeline-Test

---

## §6 Querverweise

- Original-Termin-Verzeichnis: `../termine/20260409 Termin 3/`
- Termin-2 Vorgaenger: `02_termin_2.md`
- Termin-4 Folge: `04_termin_4.md`
- Datasets-Spezifikation: `../termine/20260508 Termin 7/Datasets_Spezifikation.txt`
- Mess-Pipeline V31: `../sessions/20260514-4600-fortschrittsdokumentation-v30-v31.md`
- Hybrid-CPU UML: `../architektur/05_uml_klassen.md` §5 Hardware/ISA
- Block AO Plattform-Modell: `../architektur/04_konzepte_saeule_b.md` §4
