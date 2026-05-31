# ER-Modell — Entity-Relationship (Konsolidiert)

> ⚠️ **SUPERSEDED (2026-05-31):** Überholter Planungs-/Architektur-Stand (axis-zentrische Restruktur F.2, Plugin-Prüfling-Modell, DLL-F15-Pipeline, sezierte Organe). IST-treue Single-Source-of-Truth: `comdare-cache-engine/docs/sessions/architektur-ziele-offene-punkte-ledger.md` + `…/20260531-e2e-abnahme-audit-und-entscheidungen.md`. Niemals löschen — nur Banner.

**Stand:** 2026-05-15 (K-C.7)
**Quelle:** `Phase5_UML_Detail/07_er_model.md` (281 Z)
**Bezug:**
- ADR F5 (eigene InMemoryMeasurementBuffer; Disk-Dump Binary/CSV)
- ADR F10-K (PermutationFlags strukturiertes Flag-System)
- Block AO (Production-Plattform-Spez)

---

## §1 ER-Diagramm Top-Level

```
                       +------------------+
                       |   ExperimentRun  |
                       +------------------+
                       | * run_id (PK)    |
                       | timestamp        |
                       | platform_sig     |   1
                       | dataset_id       +----+
                       | mode             |    |
                       | module_id (FK)   |    |
                       +--------+---------+    |
                                |              |
                            1   |              |
                                v              v
                       +------------------+   +-----------------+
                       | MeasurementRecord|   | DatasetMetadata |
                       +------------------+   +-----------------+
                       | * record_id (PK) |   | * dataset_id (PK)
                       | run_id (FK)      |   | name            |
                       | category         |   | type            |
                       | algo_detail      |   | size_bytes      |
                       | metric_value     |   | distribution    |
                       | timestamp_ns     |   | source          |
                       | thread_id        |   +-----------------+
                       +------------------+

                       +------------------+   +-----------------+
                       | PermutationFlags |   | BuildArtefakt   |
                       +------------------+   +-----------------+
                       | * flags_id (PK)  |   | * module_id (PK)|
                       | bank_page        |   | source_path     |
                       | bank_node        |   | binary_path     |
                       | bank_traversal   |   | flags_id (FK)   |
                       | bank_value_h.    |   | platform_sig    |
                       | bank_memory      |   | compile_time    |
                       | bank_allocator   |   | size_bytes      |
                       | bank_prefetch    |   +-----------------+
                       | bank_concurrency |
                       | bank_isa         |
                       +------------------+
```

---

## §2 Entitaeten (5 Haupt-Entitaeten + 1 Querschnitt)

### 2.1 ExperimentRun

| Spalte | Typ | Bedeutung |
|---|---|---|
| `* run_id` (PK) | uint64_t | Eindeutige Run-ID |
| `timestamp` | timepoint | Run-Start |
| `platform_sig` | string | Hash der Plattform-Properties (Block AO) |
| `dataset_id` | uint64_t (FK) | Verweis DatasetMetadata |
| `mode` | enum | StaticEngine / CacheEngine / Hybrid |
| `module_id` | uint64_t (FK) | Verweis BuildArtefakt |

**Beziehungen:**
- 1:N → MeasurementRecord
- N:1 → DatasetMetadata
- N:1 → BuildArtefakt
- N:1 → PermutationFlags (via BuildArtefakt.flags_id)

### 2.2 MeasurementRecord

| Spalte | Typ | Bedeutung |
|---|---|---|
| `* record_id` (PK) | uint64_t | Eindeutige Record-ID |
| `run_id` (FK) | uint64_t | Verweis ExperimentRun |
| `category` | enum | MeasurementCategory (Throughput, Latency, CacheMiss, ...) |
| `algo_detail` | enum | AlgorithmDetail (PerLookup, PerInsert, ...) |
| `metric_value` | double | Wert der Messung |
| `timestamp_ns` | uint64_t | Timestamp ns since epoch |
| `thread_id` | uint32_t | Thread-ID (fuer Multi-Thread-Runs) |
| `workload_used` | WorkloadId | (V20.1) Welcher YCSB-Workload tatsaechlich gelaufen ist |
| `telemetry_strategy` | enum | (Achse 11 NEU REV v7 Kuehn) |

### 2.3 DatasetMetadata

| Spalte | Typ | Bedeutung |
|---|---|---|
| `* dataset_id` (PK) | uint64_t | Eindeutige Dataset-ID |
| `name` | string | YCSB-A, YCSB-B, ..., Custom-Dataset-Name |
| `type` | enum | YCSB / Synthetic / Custom |
| `size_bytes` | uint64_t | Speichergroesse |
| `distribution` | enum | Uniform / Zipf / Latest / ... |
| `source` | string | Quellen-URL oder Dateipfad |

### 2.4 PermutationFlags (F10-K Flag-System)

Siehe `../bausteine/05_flag_system.md` Detail. 9 Banken (uint64_t je Bank):

| Bank | Name |
|---|---|
| 1 | PageBank |
| 2 | NodeBank |
| 3 | TraversalBank |
| 4 | ValueHandleBank |
| 5 | MemoryLayoutBank |
| 6 | AllocatorBank |
| 7 | PrefetchBank |
| 8 | ConcurrencyBank |
| 9 | IsaBank |

### 2.5 BuildArtefakt

| Spalte | Typ | Bedeutung |
|---|---|---|
| `* module_id` (PK) | uint64_t | Eindeutige Module-ID |
| `source_path` | string | Codegen-Sources |
| `binary_path` | string | Compiled .dll / .so |
| `flags_id` (FK) | uint64_t | Verweis PermutationFlags |
| `platform_sig` | string | Plattform-Signature |
| `compile_time` | uint64_t | Build-Zeit in Sekunden |
| `size_bytes` | uint64_t | Binary-Groesse |

---

## §3 Relations-Cardinalities

| Beziehung | Cardinality | Bedeutung |
|---|---|---|
| ExperimentRun → MeasurementRecord | 1:N | Pro Run viele Mess-Records |
| ExperimentRun → DatasetMetadata | N:1 | Mehrere Runs koennen gleiches Dataset nutzen |
| ExperimentRun → BuildArtefakt | N:1 | Mehrere Runs koennen gleiches Modul nutzen |
| BuildArtefakt → PermutationFlags | N:1 | Mehrere Builds koennen gleiche Permutation haben (z.B. fuer mehrere Plattformen) |

---

## §4 Persistierung-Ebene

| Format | Wofuer | Speicherort |
|---|---|---|
| **In-Memory (F5)** | Hot-Path waehrend ExperimentRun | `InMemoryMeasurementBuffer` (RAM) |
| **Binary Disk-Dump** | Am Ende des Runs (sparse-serialisiert) | `Diplomarbeit/Code/measurement_data/*.bin` |
| **CSV** | Konvertiert fuer Analyse | `Diplomarbeit/Code/measurement_data/*.csv` |
| **LaTeX-Tabelle** | Konvertiert fuer thesis | `thesis/chapters/06_auswertung.tex` |

**V31 Code:**
- Binary → CSV: `Diplomarbeit/Code/binary_to_csv/`
- CSV → LaTeX: `Diplomarbeit/Code/csv_to_latex/`
- LaTeX → PDF: `Diplomarbeit/Code/latex_to_pdf/build_thesis.sh`

---

## §5 V31 ER-Updates

| Sprint | Update | Spalte |
|---|---|---|
| V20.1 | PermutationResult.workload_used | MeasurementRecord.workload_used (NEU) |
| V25.B | `<expected_workload>` Tag | DatasetMetadata.expected_workload (NEU, optional) |
| V29 | `<allocator_override>` Tag | PermutationFlags.allocator_override (NEU, optional) |
| V31 | 22 V31-Adapter | PermutationFlags-Werte fuer alle 22 Adapter setzbar |

---

## §6 Querverweise

- Original-Quelle (UNVERAENDERT): `../termine/20260508 Termin 7/Phase5_UML_Detail/07_er_model.md`
- UML-Klassen Persistence: `05_uml_klassen.md` §7 (K-C.6)
- F1-F15 Architekturentscheidungen: `../bausteine/04_architekturentscheidungen_F1_F15.md`
- Flag-System: `../bausteine/05_flag_system.md`
- Cross-Reference Bausteine ↔ UML ↔ ER: `07_cross_reference.md` (K-C.8)
- Begriffsglossar v7: `../glossar/01_begriffsglossar_v7_master.md` (BLOCK U Datasets, BLOCK AC ExperimentRun)
