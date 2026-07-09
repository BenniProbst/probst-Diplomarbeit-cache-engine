Verification complete. All facts confirmed against files. Here is the mapping.

---

# #31 (F7 Mess-Frameworks × Workloads 2D-Matrix) — Verortung + Fehl-Bau-Bewertung

## TL;DR-Verdikt
Der Fehl-Bau ist **doppelt fehlplatziert**: falsches Repo (ce-Monolith statt `comdare-measurement-all`) UND falsche Ebene (compile-time-Konstante in der Interpretations-Bibliothek statt Experiment-Konfigurations-DATEN in der Diplomarbeit-Profil-Ebene). Der User hat recht. Nicht committen — die 48-Zellen-Matrix + 16-Kategorien-Achse gehören als XML-Auswahl in `Code/experiment_config/`, nicht als `mp_product` in die ce.

## #31-Verortung (datei:zeile → Ebene)

| Belang | Korrekte Ebene | Fundort (datei:zeile) |
|---|---|---|
| **Auswahl/Aufzählung der Matrix** (welche Workloads × Datasets × Kategorien je Messreihe) = Experiment-**DATEN** | **Diplomarbeit-Profil-Ebene (XML)** | `Code/experiment_config/messreihen.xml` (4 Messreihen A/B/C); `Code/experiment_config/config_a_prt_art_vs_sota.xml:72-79` (`<workloads><workload type="ycsb">A..F`), `:81-89` (`<parameters>` num_keys/zipfian/seed), `:97` (`<diagram type="heatmap" plot="workload_vs_permutation_throughput"/>` = 2D-Matrix als Output) |
| **Orchestrierung** (liest XML, treibt Bibliothek) | Diplomarbeit-Consumer | `Code/02_messung_driver/main.cpp:173` (`load_messreihen`), `:124-145` (`WorkloadOptions`/`wg::YcsbWorkload`), `:34` (`#include <comdare/workload_generator/...>`) |
| **Interpretations-Bibliothek** (Modul-Struktur der 2D-Achsen) | **`comdare-measurement-all`-Familie** | `/home/comdare/Projekte/Modules/comdare-measurement-all/` (baseline_0-core/comdare-metrics · baseline_1-instrumentation/comdare-pmc · baseline_2-workloads/comdare-workloads) |
| **Interpretations-Vokabular** (Enums, die ein Profil interpretieren) | ce-Monolith (Quelle, wird nach measurement-all gesplittet, Schritt-13 GATED) | `YcsbWorkload` @ `libs/test_infra/workload_generator/include/comdare/workload_generator/workload_generator.hpp:22`; `MeasurementCategory` (committed) @ `libs/cache_engine/include/cache_engine/measurement/measurement_category.hpp` |
| **Fehl-Bau (NICHT committen)** | — | siehe unten |

---

## 1. Was ist #31 top-down GENAU, welche Ebene?
#31 = F7-Auftrag (User 07.07., **Ledger:298**): „die gesamte Matrix aller Mess-Frameworks × Workloads muss noch als Module mit feingliedriger Baseline-2D-Matrix-Struktur abstrahiert werden". Top-down zerfällt das in **zwei Ebenen**, die der Fehl-Bau zu einer falschen zusammenzieht:

- **(A) Die Matrix-AUSWAHL** (welche Zellen des Kreuzprodukts je Messreihe laufen) ist Experiment-Konfiguration = **Diplomarbeit-Profil-Ebene (`Code/experiment_config/*.xml`)**. Sie liegt dort bereits teilweise (config_a:72-79 = Achse W; :81 = Parametrisierung; :97 = 2D-Heatmap-Output) und wird von `02_messung_driver` orchestriert.
- **(B) Die Interpretations-BIBLIOTHEK** (Modul-Struktur, gegen die ein Profil interpretiert wird) = **`comdare-measurement-all`-Familie**. Hier greift Doc-15-Option A/B/C.

Der **ce-Monolith ist KEINE der beiden End-Heimaten** — er ist nur die aktuelle, noch nicht gesplittete Quelle der Interpretations-Implementierung (Migrationsplan-Schritt 13, GATED). #31 gehört daher NICHT als compile-time-Matrix in `builder/workload_driver/`.

## 2. Was sagt Doc 15 (F7)?
`docs/architektur/15_F7_mess_frameworks_workloads_2d_matrix_plan.md`:
- **§1 (Z. 9-18):** Ist = `comdare-measurement-all` ist strikt **1D**-Baseline (metrics b0 / pmc b1 / workloads b2 — LoadGen+Dataset **gebündelt** / analysis b3 nur vorgesehen). Achsen der 1D-Schichtung sind Mess-**BELANGE**, NICHT Framework×Workload. **Z. 18:** der gleichnamige ce-Ort `builder/measurement_matrix/` ist ein **leeres Skelett** (verifiziert: nur `.gitkeep`+`CMakeLists.txt`).
- **§2 (Z. 22-28):** Achse M (16 Mess-Kategorien; zeit/observer vs. zähler/PMC) × Achse W (YCSB × 6er-Dataset-Kanon; „Workload als dynamische Achse").
- **§3 (Z. 30-38) Struktur-Fork:** **Option A** (2. Dim. compile-time IN den Zellen, F6, golden-neutral — EMPFOHLEN) / **B** (je Profil/Kategorie eine Zelle → Explosion) / **C** (getrennte Familien-Achse → bricht die eine Familie).
- **§4/§5 (Z. 40-55):** Option-A-Ziel verankert die Achsen **in den `comdare-measurement-all`-Zellen** (workloads b2, metrics b0+pmc b1, analysis b3) — Roadmap-Schritt 4 GATED hinter Migrationsplan-Schritt 13.

Entscheidend: **Doc 15 verortet die Achsen in der measurement-all-FAMILIE, nicht im ce-Monolith.** Der Fehl-Bau baute sie in den Monolith `builder/workload_driver/` — schon gegen Option A falsches Modul.

## 3. Ist `workload_matrix.hpp` die falsche Ebene? JA — gegen die Rollen-Trennung
1. **Falsches Repo/Modul:** liegt im ce-Monolith (`libs/cache_engine/builder/workload_driver/`). Selbst Doc-15-Option A verlangt die measurement-all-Familie. Der Monolith wird gesplittet (Schritt 13) — #31 hinein zu bauen vertieft das aufzulösende Ding.
2. **Falsche EBENE (User-Punkt):** `workload_matrix.hpp:128-134` fixiert compile-time via `mp_product` das konkrete Grid — WELCHE 8 Workloads × WELCHE 6 Datasets = 48 Läufe; `measurement_category_axis.hpp:37-55` fixiert WELCHE 16 Kategorien. Das ist Experiment-DATEN, die bereits in `config_a...xml:72-79/:81/:97` und `messreihen.xml` als XML liegen und von `02_messung_driver/main.cpp:173` (`load_messreihen`) selektiert werden. Eine Bibliothek, die „das Experiment IST genau diese 48×16" einfriert, ist per Messreihe nicht mehr aus XML wählbar — sie usurpiert die Profil-Ebene.
3. **Rollen-Trennung verletzt:** ce = Interpretations-Bibliothek → liefert das *Vokabular* (`YcsbWorkload`, `MeasurementCategory`, workload_generator, ExperimentDriver, Snapshot-POD), NICHT die *Aufzählung des Grids*. (Der Enum-**REUSE** des Fehl-Baus ist korrekt; das Verpacken als compile-time-Matrix-ACHSEN/`mp_product`-Zellen ist der Ebenen-Fehler.)
4. **Greift in ce-Command-Infrastruktur für einen Diplomarbeit-Belang:** der Diff fügt `InsertHeavy=6, LookupHeavy=7` in den committeten `WorkloadKind`-Command-Enum (`commands/workload.hpp:22-28`) ein, um die Matrix zu füttern — falsche Abhängigkeitsrichtung (die Profil-Ebene soll aus der Bibliothek wählen, nicht Mitglieder in deren Enum erzwingen). Werte 6/7 liegen in der Lücke vor 100 → ABI-wert-neutral in Isolation, was den Ebenen-Fehler nicht heilt, ihn nur billig reversibel macht.
5. **Widerspricht sogar der Hybrid-Auflösung selbst:** Ledger:371 hält fest, Workload sei „die DynamicVariableNode-Seite des experiment_tree, KEINE Binary-Identitäts-Achse". Der Hybrid (Ledger:369e) meint compile-time-**Experiment-Baum-STRUKTUR** + runtime-Wertmenge — nicht ein hart kodiertes mp11-Enum der konkreten 48×16-Wertmenge (die ist gerade die runtime/XML-Seite).

## 4. „Schon geplant" vs. konkret fehlend + korrekter nächster Schritt
**Geplant/erledigt:** Doc 15 (Fork A/B/C, Ledger:353); Fork-Auflösung = **Hybrid** (User 08.07., Ledger:369e, reine Option A verworfen); Schritt-1 (ce `88738285`) + Schritt-1b (ce `4d8aedce`, 36 Zellen 6×6) committed — **aber auch diese sitzen im ce-Monolith `builder/workload_driver/` und teilen denselben Ebenen-/Modul-Fehler** (bei der Korrektur mitzudenken).

**Konkret fehlend (was der Fehl-Bau falsch substituiert hat):**
- XML-Profil-Schema für die volle 2D-Matrix: `experiment_config/*.xml` trägt Achse W (A-F) + Params, aber KEINE explizite **Dataset-Achse D** (6er-Kanon nur als #25-Referenz, nicht als `<dataset>`) und KEINE **Mess-Kategorie-Auswahl M** je Messreihe. Genau diese zwei fehlen — und gehören als XML-Elemente in `experiment_config/` + Parser/`messreihe_v32_validator.hpp` in `02_messung_driver`, NICHT als mp11-Listen in die ce.
- `comdare-measurement-all` bündelt LoadGen+Dataset noch in einer b2-Zelle (Doc 15 §1), b3-analysis fehlt; der Bibliotheks-Refactor ist GATED (Schritt 13).

**Korrekter nächster Schritt:**
1. **Fehl-Bau NICHT committen** — verwerfen (workload_matrix.hpp-48er, measurement_category_axis.hpp, test_31b, workload.hpp-Enum-Edit, test/CMake-Edits); zusätzlich prüfen, ob die committete 36er-Schritt-1b überhaupt in den ce-Monolith gehört.
2. **#31 in die Profil-Ebene verlagern:** `experiment_config/*.xml`-Schema um Achse D (`<datasets>`, 6er-Kanon) und Achse M (Kategorie-Auswahl je Messreihe) neben den bestehenden `<workloads>` erweitern; `02_messung_driver` (Parser + `messreihe_v32_validator.hpp`) interpretiert sie und treibt die ce-Bibliothek. ce/measurement-all behalten NUR das Vokabular (YcsbWorkload/MeasurementCategory-Enums, workload_generator, ExperimentDriver).
3. Jede Modul-Struktur-Arbeit (Doc 15 A/B/C) zielt auf die **measurement-all-Familie**, nicht den Monolith, und bleibt GATED hinter Migrationsplan-Schritt 13 + User-A/B/C-Wahl.

---

**Fehl-Bau-Dateien (alle uncommitted, `Code/external/comdare-cache-engine`):**
- `M libs/cache_engine/builder/workload_driver/workload_matrix.hpp` (36→48 Zellen: `workload_profile_list`=8 × `dataset_list`=6, Z. 128-134)
- `M libs/cache_engine/builder/commands/workload.hpp` (`InsertHeavy=6, LookupHeavy=7` in committeten Enum)
- `?? libs/cache_engine/include/cache_engine/measurement/measurement_category_axis.hpp` (16 Kategorien Achse M)
- `?? tests/unit/test_31b_measurement_category_axis.cpp`
- `M tests/unit/CMakeLists.txt` · `M tests/unit/test_31_workload_matrix.cpp`

Committete Basis: ce `4d8aedce` (36 Zellen). Leeres Doc-15-Skelett: `builder/measurement_matrix/` (nur `.gitkeep`).