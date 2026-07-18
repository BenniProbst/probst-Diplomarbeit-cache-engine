Verifikation abgeschlossen. Alle tragenden Fakten gegen Platte geprüft (git-Status/-Log der ce, beide Fehl-Bau-Dateien wörtlich, committed-vs-uncommitted-Schnitt, `experiment_config/`-XMLs, measurement-all-Familie on-disk). Hier die schonungslose Ebenen-Synthese.

---

# CHEF-ARCHITEKT-VERDIKT: #31-Verortung + Fehl-Bau-Korrektur

**Pfad-Kürzel:** `SUP` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` · `CE` = `SUP/Code/external/comdare-cache-engine` · `MALL` = `/home/comdare/Projekte/Modules/comdare-measurement-all`

**Ein-Satz-Befund:** Der Fehl-Bau friert die *Aufzählung eines konkreten Experiments* (W×D=48-Lauf-Grid + 6 Datensätze als `mp_product`/Enum) compile-time in die Interpretations-Bibliothek ein — das ist genau die Profil-Ebene der Diplomarbeit, die er usurpiert. Und er ist **nicht nur uncommitted, sondern zur Hälfte schon committed** (36 Zellen in `88738285`+`4d8aedce`), beide im *falschen Modul* (ce-Monolith statt measurement-all).

---

## 1. DIE VIER LAYER TOP-DOWN + die WAS/WIE-Grenze

Es gibt **drei** legitime „Vierer", die auseinandergehalten werden müssen — nur der erste ist die *Architektur-Schichtung*:

**(a) Die 4 Teilprogramme = die autoritative Layer-Schichtung** (Build-/Kopplungs-Topologie, `SUP/docs/TEILPROGRAMM-ABHAENGIGKEITSBAUM.md:236-263`, `SUP/.gitmodules` = 3 Submodule):

| Layer | Teilprogramm | Rolle | Kopplung |
|---|---|---|---|
| **L1 Anwender** | Diplomarbeit `SUP/Code/` | **WAS** gemessen wird (Profil-XML) + Auswertung (CSV→LaTeX→PDF) | bindet L2/L3 als parallele Submodule, `Code/CMakeLists.txt:183-194` |
| **L2 Framework** | comdare-cache-engine | **WIE** gemessen wird (interpretiert Profile, generiert/lädt/misst DLLs) | wird von `02_messung_driver` gelinkt |
| **L3 Prüfling** | comdare-prt-art | Prüfling, füllt compile-time-Slot `optional_prt_art_impl` je Achse | Plugin-Controller-Merge (Metaprogrammierung), kein Library-Link |
| **L4 Manuskript** | thesis/diplomarbeit | konsumiert `.tex`-Artefakte | reiner Artefakt-Konsum, keine Code-Kante |

**(b) 4 M-Modell-Subsysteme** (Laufzeit-Rollen *innerhalb* L2; aus den SUPERSEDED UML-Docs `Z4:15-31`, konzeptuell gültig): messung_driver / ExperimentDriver / CacheEngine-Werkzeug / Prüfling.

**(c) Das „4-Schichten-Dossier"** ist eine FALLE: seine 4 Layer (`experiment_tree` / `builder` / `anatomie` / `mess_achsen`) sind **ce-INTERNE read-only-Kartierungsachsen EINES Programms** (Wurzel hart auf CE gepinnt, `SUP/docs/sessions/backups/20260709-wf-4layer-experiment-tree/workflow-script.js:10`) — sie haben mit den 4 Teilprogrammen **nichts** zu tun. Das Dossier relativiert sich selbst: „**nicht** vier gleichrangige Hierarchie-Schichten, sondern ein Zwei-Ebenen-System (compile-time ⊥ runtime) plus eine orthogonale dritte (Mess-)Ebene" (`workflow-result-full.json:12`).

### Die Grenze „stellt Profile bereit" (L1) vs. „interpretiert" (L2)

Autoritativ als User-Direktive fixiert in `SUP/STRUCTURAL_CORRECTION_diplomarbeit.md:863-923` (WAS vs WIE). **Physisch verläuft die Grenze mitten durch die XML-Verarbeitung:**

- **L1 stellt bereit** (Daten): die Profil-*Dateien* `SUP/Code/experiment_config/{messreihen.xml, config_[abc].xml}` + `SUP/Code/test_data_xml/*.test_data.xml`. Das ist Experiment-**DATEN**.
- **L2 interpretiert** (Mechanismus): der *Parser* `xml_config_parser.hpp`, `discover_load_profiles`/`parse_load_profile`, `ExperimentDriver`, `run_profile` — die Bibliothek. Das ist der Interpretations-**Mechanismus**.
- Belegt am Include-Sprung über die Grenze, `SUP/Code/02_messung_driver/main.cpp:28-34`: der Driver (L1) `#include`t `experiment_driver/…`, `xml_config_parser/…`, `<comdare/workload_generator/…>` (alle L2).

**Merksatz:** L1 selektiert/skaliert Profile; L2 definiert/interpretiert die Wertemengen. Die maßgeblichen Kataloge (Workload-Achse 2 = `CE/libs/cache_engine/algorithm_profiles/load_profiles/*.xml`; 11 Struktur-Achsen = `permutation_axes.xml`; SOTA-Punkte = `sota/*.profile.xml`) liegen in L2; die `experiment_config`-XMLs sind **dünne Selektoren**, die diese referenzieren.

---

## 2. DER PROFILE-FLUSS TOP-DOWN

```
L1  experiment_config/messreihen.xml   [comdare_messreihen v1] — DÜNNER Selektor:
       <messreihe id><mode>defined|full</mode><profile>…</profile>   (messreihen.xml:14-64)
       │  (+ Detail-config_a: <workloads> ycsb A–F :72-79/104-111,
       │     <parameters> num_keys/zipfian/seed :81-88, <axes_source>→permutation_axes.xml :42,
       │     <output><diagram type="heatmap" plot="workload_vs_permutation_throughput"/> :97)
       ▼
L1  02_messung_driver/main.cpp
       load_messreihen()  (main.cpp:173, Regex-Parse NUR von messreihen.xml)
       reicht config_dir OPAK an L2 durch (main.cpp:410, :467)
       ▼  ── WAS→WIE-Grenze (main.cpp:28-34) ──
L2  xml_config_parser  — liest per FIXEN Dateinamen:
       cache_engine_permutations.xml · search_algorithm_permutations.xml ·
       allocator_permutations.xml · test_data_sets.xml (+ messreihen.xml)
       (xml_config_parser.cpp:72-82)
       ▼
L2  ExperimentDriver::run_pipeline_full  (Phasen 1–7, experiment_driver.cpp:534-586):
       1 enumerate (XML→kartesisches Produkt) · 2 codegen je Permutation ·
       3 compile DLLs · 4 dlopen (module_abi_v1) · 5 run_workload (workload_generator,
       profil-abhängiges Routing) · 6 measure · 7 export csv/json
       ║  parallel (NEUER, deklarativer Pfad — Achse 2):
       ║  discover_load_profiles(COMDARE_LOAD_PROFILE_DIR) → parse_load_profile
       ║  je comdare_load_profile.xml → map<id,WorkloadConfig>  (Achse-2-Wertemenge, runtime)
       ▼
Messung  measurements.csv/json  (ExperimentDriver-Pfad)  bzw.
         all_permutations.bin  magic 0xC0FFEE02  (Mikrobench-Pfad, measurement_writer.hpp:29)
       ▼
L1  03_binary_to_csv (kBinaryMagic 0xC0FFEE02, binary_to_csv.hpp:43) → 16-Spalten-CSV
       → 04_csv_to_latex + 05_diagram_generator (--by-workload/heatmap) → 06_latex_to_pdf
       ▼
L4  thesis/diplomarbeit-PDF
```

**Trag-Schemata (3 Generationen):** G1 produktiv = `comdare_messreihen`/`comdare_experiment` (experiment_config/*.xml) → `xml_config_parser`. G2 = `messreihe version="32"` XSD (`SUP/Code/test_data_xml/messreihe_v32_schema.xsd`) — richer (Tupel W×op_type×hw/sched/compiler-Strategie, 2-EE-Vergleich), **aber keine Prod-Instanz, nicht in main.cpp verdrahtet** (opt-in `COMDARE_V32_ENABLE`). Katalog = `comdare_load_profile` (L2, Achse 2, laufzeit-interpretiert).

**Wichtige Ist-Nuance:** Die geplante EINE Eintritts-API `run_profile` liegt heute in `CE/tests/unit/thesis_tiere/profile_run_entry.hpp:104` (Harness, katalog-schwer) — **nicht als Lib-Target exportiert**. Die Diplomarbeit linkt weiterhin den ALTEN `comdare_builder_experiment_driver`. Das ist eine offene L2-Lücke, aber orthogonal zu #31.

---

## 3. #31 KORREKTE VERORTUNG

#31 = F7-Auftrag (Ledger:298): „Matrix aller Mess-Frameworks × Workloads als Module mit feingliedriger 2D-Matrix-Struktur". Top-down zerfällt #31 in **zwei Ebenen + eine Nicht-Achse**, die der Fehl-Bau zu einem compile-time-`mp_product` zusammenzieht:

| #31-Belang | Natur | Korrekte Ebene | Beleg |
|---|---|---|---|
| **AUSWAHL** welche W×D-Zellen je Messreihe laufen | Experiment-**DATEN** (runtime) | **L1 Profil-Ebene** `experiment_config/messreihen` | config_a:72-79 (W da), :97 (Heatmap-Output da); **`<datasets>` D FEHLT**, **`<measurement_categories>` M FEHLT** |
| **Achse W** (Workloads) | Mess-**INPUT**, lauf-multiplizierend | **runtime** — dynamische `AxisLevel{is_static=false}` / DynamicVariableNode; Wertmenge aus `discover_load_profiles` | F7:15,26; profile_to_tree runtime-Ebene |
| **Achse D** (Datasets) | Mess-**INPUT**, lauf-multiplizierend | **runtime** — konzeptuell dyn. Achse; Daten liegen als `test_data_xml/*.test_data.xml` (L1) | F7:26; **im ce-experiment_tree noch NICHT als AxisLevel verdrahtet, Lücke A-G2** |
| **Achse M** (16 Mess-Kategorien) | Mess-**OUTPUT** = Spalten-**PROJEKTION** | **KEINE Lauf-Achse** — compile-time-Liste + Regime-Trait; niemals `mp_product`-Faktor | F7:22-24; SYNTHESE:84 („×16-Blähung sonst") |
| **Modul-STRUKTUR / Vokabular** der 2D-Achsen | Interpretations-Bibliothek | **measurement-all-Familie** (Doc 15 Option A, GATED Schritt 13) — NICHT ce-Monolith | F7:9-18,40-55; `MALL/README.md:1-8` |
| **Achsen-Algorithmen** (19 Achsen) | Binär-Identität | **compile-time L2** (`permutation_axes.xml`/golden_320) — UNBERÜHRT, orthogonal | F7:59 („Mess-Matrix orthogonal zur Anatomie") |

**Der ce-Monolith ist KEINE der End-Heimaten** — er ist nur die noch nicht gesplittete Quelle der Interpretations-Impl (Migrationsplan-Schritt 13, GATED). measurement-all existiert bereits als eigenständiger 3. Baustein: `MALL/comdare-baseline_{0-core/comdare-metrics, 1-instrumentation/comdare-pmc, 2-workloads/comdare-workloads}` (on-disk verifiziert), Geschwister des super-Repos, GitLab-ID 300.

**„Schon geplant":** Doc 15 (Fork A/B/C), Hybrid-Auflösung (User 08.07., Ledger:369e), die 6 Kanon-Datensätze existieren als `test_data_xml/*.test_data.xml`, der 2D-Heatmap-**Output** ist in config_a:97 deklariert, measurement-all-Familie steht (metrics/pmc/workloads, CI-grün, Ledger:328).

**Konkret FEHLT** (was der Fehl-Bau falsch substituiert): (1) `<datasets>`-Element (Achse D) als Selektor in `experiment_config`/`messreihen` + v32-XSD + Parser; (2) `<measurement_categories>`-Element (Achse M = Projektion) je Messreihe + Parser; (3) measurement-all `baseline_3-analysis` (leer); (4) L2-seitig eine runtime Dataset-`AxisLevel` im experiment_tree.

---

## 4. KORREKTUR DES FEHL-BAUS — was bleibt, was fliegt

**Ist-Schnitt (verifiziert, `git status`/`git log` der ce):**

- **Committed im ce-Monolith `builder/workload_driver/` (falsches Modul):** `88738285` (Bridges + `ycsb_profile_list`), `4d8aedce` (`CanonicalDataset`-Enum + `mp_product` = **36 Zellen**). → `git show 4d8aedce --stat`.
- **Uncommitted (der geflaggte Fehl-Bau):** `M workload_matrix.hpp` (36→48), `?? measurement_category_axis.hpp` (M=16 + Regime), `M commands/workload.hpp` (`InsertHeavy=6, LookupHeavy=7` in den committeten Command-Enum), `M/? test_31*`, `M tests/unit/CMakeLists.txt`.

Ebenen-saubere Dreiteilung des Inhalts (V = Vokabular/library, **E = Enumeration/Profil-Ebene**, A = Achsen-Algorithmen/unberührt):

| Artefakt | datei:zeile | Klasse | Verdikt |
|---|---|---|---|
| `matrix_cells = mp_product<…> = 48` | workload_matrix.hpp:128-134 | **E** | **VERWERFEN** — friert „Experiment IST 48 Läufe" compile-time ein = Kern-Ebenen-Fehler |
| `workload_profile_list`/`ycsb_profile_list` (Achse W als Liste) | :65-84 | **E** | **VERWERFEN** — W-Mitgliedschaft gehört in Profil-XML (`<workloads>`/`<profile>`), nicht mp11 |
| `CanonicalDataset`-Enum + `dataset_name` + `dataset_list` | :101-123 | **E** | **VERWERFEN** — dupliziert L1-Daten (`test_data_xml/{url,dna,protein,xml,tpcds-id,trec-terms}`) in einen library-Enum |
| `InsertHeavy=6/LookupHeavy=7` in Command-Enum | commands/workload.hpp:25-27 (WT-Diff) | **E→V-Leck** | **VERWERFEN** — falsche Abhängigkeitsrichtung (Profil zwingt Member in L2-Enum). ABI-wert-neutral (Lücke vor 100), heilt Ebenen-Fehler nicht |
| `ycsb_token` / `config_for` (compile→runtime-Brücke) | :48-63, :88-90 | **V** | Vokabular-legitim, ABER im falschen Modul (Monolith); nicht als „Matrix" festhalten → **re-homen** nach measurement-all b2, sonst verwerfen |
| `MeasurementRegime` + `category_regime` + `category_needs_pmc` + `regime_name` | measurement_category_axis.hpp:57-108 | **V** | **einziges konzeptuell wertvolles Stück** — echter constexpr-Interpretations-Trait (Observer/Counter/Derived + PMC-Privileg, Doc-15-§2-Zweiteilung). ABER falsches Modul → **Idee bewahren, Code verwerfen**, neu in measurement-all metrics/pmc (GATED Schritt 13) |
| `measurement_category_list` (16er mp_list) | :37-53 | **V(-ish)** | reine Enum-Iteration, kein Lauf-Multiplikator (Header sagt es selbst :7-11 korrekt) → harmlos, aber unnötig im Monolith → verwerfen |
| `MeasurementCategory`-Enum, `WorkloadKind`-Enum (ohne Edit), `profile_by_name`/`make_insert_heavy`/`make_lookup_heavy` | committed | **V** | **UNBERÜHRT** — korrektes Bestands-Vokabular |
| `permutation_axes.xml` / golden_fullpilot_320 | L2 | **A** | **UNBERÜHRT** — orthogonal |

**Der Impl-Agent hat EINE Sache richtig gesehen** (measurement_category_axis.hpp:7-11): M ist eine Projektion, kein Run-Multiplikator — deshalb korrekt eine Liste statt `mp_product`-Faktor. Das entkräftet den Ebenen-Fehler des W×D-`mp_product` aber nicht; und die *Verortung* (ce-Monolith `include/cache_engine/measurement/` = gerade der duplizierte Alt-Code, der per Schritt 13 aufgelöst wird) ist falsch. **Nichts Neues darf in den Monolith-`measurement/`-Dir landen.**

**Verdikt:** Nicht „ein Teil hat Berechtigung im Monolith". Die *Konzepte* Regime-Trait + Workload-Brücke haben Berechtigung — **in measurement-all, gated**. Am aktuellen Ort: alles verwerfen. Und die zwei committeten Commits tragen denselben E-Fehler und dürfen nicht bleiben.

---

## 5. KORREKTER NÄCHSTER SCHRITT für #31 (ebenen-richtig, geordnet)

**Stufe 0 — Ebenen-Wiederherstellung (sofort):**
1. Uncommitteten Fehl-Bau reverten: `git checkout --` auf `libs/cache_engine/builder/workload_driver/workload_matrix.hpp`, `libs/cache_engine/builder/commands/workload.hpp`, `tests/unit/test_31_workload_matrix.cpp`, `tests/unit/CMakeLists.txt`; `rm` `libs/cache_engine/include/cache_engine/measurement/measurement_category_axis.hpp` + `tests/unit/test_31b_measurement_category_axis.cpp`. (Kein Commit-Verlust — WT-only.)
2. Die zwei committeten Fehl-Platzierungen `88738285`+`4d8aedce` per **forward `git revert`** (keine History-Rewrite) zurücknehmen — **braucht User-GO** (committed history, geteiltes Repo; Memory: keine unautorisierten Remote-/History-Eingriffe). Die konzeptuelle Regime-/Brücken-Idee vorher in eine Design-Notiz für measurement-all sichern (Doku nie löschen).

**Stufe 1 — Profil-Ebene L1 (das eigentliche #31-Deliverable, dünne Selektoren):**
3. Schema erweitern in `SUP/Code/experiment_config/` (G1 `comdare_experiment`) **und** `SUP/Code/test_data_xml/messreihe_v32_schema.xsd` (G2) um zwei Elemente je `<messreihe>`:
   - `<datasets>` (**Achse D**, runtime): Liste von Dataset-`id`s, die auf `test_data_xml/*.test_data.xml` (6er-Kanon) verweisen. Auswahl je Messreihe, KEIN compile-time-Enum.
   - `<measurement_categories>` (**Achse M**, Projektion): Auswahl der auszugebenden/plottenden Spalten (Teilmenge der 16); optional, Default = alle 16. KEIN Lauf-Faktor.
   (Achse W ist bereits da: `<workloads>`/`<profile>`; der Heatmap-Output ebenfalls, config_a:97.)
4. Parser in `SUP/Code/02_messung_driver/` erweitern: `load_messreihen` (main.cpp:173) + `messreihe_v32_validator.hpp` lesen `<datasets>` + `<measurement_categories>` und reichen sie an den ExperimentDriver durch — D als **runtime-Auswahl** (später dynamische AxisLevel), M als **Output-Projektion** an 03/04/05. NICHT als mp11-Listen.

**Stufe 2 — Bibliotheks-Ebene, measurement-all (GATED hinter Migrationsplan-Schritt 13):**
5. Das Interpretations-Vokabular in die measurement-all-Zellen, nicht den Monolith: Regime-Trait (Observer/Counter/Derived + `needs_pmc`) → `MALL/comdare-baseline_0-core/comdare-metrics` (Observer) + `…1-instrumentation/comdare-pmc` (Counter/Derived); Workload/Dataset-Loader → `…2-workloads/comdare-workloads`. Das ist Doc-15 Option A („2. Dimension compile-time IN den Zellen"), GATED. **Jetzt NICHT im Monolith bauen.**
6. L2-Nachzug (ce-Team, separat): runtime Dataset-`AxisLevel` (`is_static=false`) im experiment_tree, damit Achse D real getrieben wird (schließt Lücke A-G2 / Interpretations-API-Frage-3-Punkt-3 „keine Dataset-Achse").

**Ordnungs-Rationale:** Erst reverten (Ebenen-Sauberkeit), dann L1-XML+Parser (der Kern von #31 — dünne Selektoren), dann (gated) das Vokabular in measurement-all. Durchgehend gilt: **W/D = Mess-INPUT → runtime aus Profilen; M = Mess-OUTPUT → Projektion (nie Lauf-Multiplikator); 19 Achsen-Algorithmen = compile-time L2, unberührt.** Der Fehl-Bau verletzte alle drei Regeln in einer `mp_product`-Zeile.

---

**Load-bearing Dateien (absolut):**
- Fehl-Bau (uncommitted, verwerfen): `CE/libs/cache_engine/builder/workload_driver/workload_matrix.hpp:128-134` (mp_product 48), `:101-123` (CanonicalDataset), `CE/libs/cache_engine/include/cache_engine/measurement/measurement_category_axis.hpp`, `CE/libs/cache_engine/builder/commands/workload.hpp:25-27` (Enum-Edit)
- Committete Fehl-Platzierung (revert braucht GO): ce-Commits `88738285`, `4d8aedce`
- Profil-Ebene (hier entsteht #31): `SUP/Code/experiment_config/{messreihen.xml, config_a_prt_art_vs_sota.xml:72-79/97}`, `SUP/Code/test_data_xml/{*.test_data.xml, messreihe_v32_schema.xsd}`, `SUP/Code/02_messung_driver/main.cpp:173`
- Korrektes Ziel-Modul (gated): `MALL/comdare-baseline_{0-core,1-instrumentation,2-workloads}/`
- Direktiven: `SUP/STRUCTURAL_CORRECTION_diplomarbeit.md:863-923` (WAS/WIE), `SUP/docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md:9-18,40-55` (F7/Option A), `SUP/docs/TEILPROGRAMM-ABHAENGIGKEITSBAUM.md:236-263`