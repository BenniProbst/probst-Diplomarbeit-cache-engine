---
name: feedback_serialization_flat_systemaxis_folders_deep_tier_tree_dynamic_only_columns
description: "Ergebnis-Serialisierung — Systemachsen flach als Ordnerstruktur, Tier-Binary-Achsen als tiefer serialisierter Permutationsbaum mit CSVs; statische compile-time-Achsen + Systemachsen in Ordner+Datei-Beschriftung (NICHT als Spalten), nur dynamische Unter-Achsen als CSV-Spalten; Reihe C = Option C (beides)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

Serialisierung des Ergebnis-Baums (User 2026-07-16, verfeinert die E1-„Spalte je Achse"-Entscheidung; beantwortet zugleich F3(i)/Reihe C). Der Permutationsraum ist ein **layer-sortierter, lazy durchlaufener, NICHT materialisierter Baum** — muss aber **serialisiert MIT den Endergebnissen** vorliegen können.

- **Systemachsen-Ebene → FLACH als Ordnerstruktur** serialisiert (je Systemachsen-Kombination ein Ordner).
- **Tier-Binary-Achsen + CSV-Messwerte → serialisierter TIEFER Baum** über alle Achsen + Permutationen.
- **Spalten-Sparsamkeit (keine Redundanz):** die **statischen compile-time-Achsen** (Algorithmus-Wahl je Achse, binary_id-bestimmend) UND die **Systemachsen** werden NICHT als CSV-Spalten geschrieben (in jeder Zeile identisch = Verschwendung) — stattdessen in die **Ordnerstruktur + die Beschriftung/Metadaten der Mess-Datei** gepackt. **NUR die dynamischen Unter-Achsen** (laufzeit-veränderlich: Workload, RC-Settings, P/E-Core, NUMA, Multithreading) bleiben als **Spalten** in den Messwerttabellen (Spalten + Einstellungen aufgeführt, weil sie sich zur Laufzeit ändern).
- **Reihe C = Option C (BEIDES):** der SdT-vs-Prüfling-Vergleichs-View UND die build-über-Build-Regression — ermöglicht durch den serialisierten Baum-mit-Ergebnissen (Vergleich über serialisierte Builds).

**Why:** legt die Ergebnis-Serialisierung + das CSV-Spalten-Schema fest — verfeinert E1 (statische Achsen wandern aus den Spalten in Struktur+Beschriftung) und prägt die Brücken-CSV (I5/I6) + den Ergebnis-Rückschrieb.

**How to apply:** Mess-CSV trägt nur dynamische-Unter-Achsen-Spalten; statische Achsen + Systemachsen stehen in der Ordner-Serialisierung (Systemachsen flach) + dem tiefen Tier-Achsen-Permutationsbaum + der Datei-Beschriftung; Reihe C = beides. Siehe [[feedback_measurement_modes_debug_parallel_measure_singlethread_planer_generates_ci_cmake]], [[feedback_ceb_config_cmake_interface_static_registry_paths_prt_module]], [[feedback_thesis_universelle_baum_anatomie_und_prinzipsuche]].

**Q1–Q4 FIXIERT (User 2026-07-16, Gesamtkonzept-Abklärung):** **Q1** = (b) flach je Binary + Sidecar-Manifest (Achsen-Wahl als Metadaten) + separater Baum-Index. **Q2** = JA (statische per-Achsen-Spalten fallen weg, nur `binary_id`+Ordner+Metadaten; `;phase;engine` + dynamische Unter-Achsen bleiben Spalten) — ABER jede compile-time-statische **HAUPT-Achse trägt weiterhin ihre geplanten dynamischen Laufzeit-UNTER-Achsen** (die als Spalten bleiben); der **Experiment-Baum wandert in den Experiment-Planer** und filtert System- + Tier-Binary-Achsen rekursiv beim Bau. **Q3** = additiv gespiegelt (Systemachsen-Ordner + Tag-Spalten resume-sicher, später deprecaten; schützt `test_profile_roundtrip==320`), Reihenfolge grob→fein **Host→OS→Toolchain→ISA**. **Q4** = (b) On-Disk-Baum + maschinenlesbarer Index-Manifest (speist CoR-Auswertung + beide Reihe-C-Views) + CEB erzeugt im Build-Pfad + **atomarer build→ziel-Copy** in den XML-`<output>`-Pfad. Plus [[feedback_measurement_failure_visibility_csv_failed_not_null_plus_log]] (Zelle="failed" statt null bei Algo-Fehler).
