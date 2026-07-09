Ich habe alle vorgegebenen Dokumente gelesen und den Ist-Stand live gegen den Code auf Platte verifiziert (Verzeichnisbaum, `.gitmodules`, `Code/CMakeLists.txt`, `02_messung_driver/main.cpp`, `experiment_config/`). Hier die vollständige Top-Down-Kartierung.

---

# TOP-DOWN-ARCHITEKTUR — Diplomarbeit cache-engine

## 0. Ein-Bild-Überblick (Anwender → cache-engine)

```
thesis/diplomarbeit (PDF-Manuskript)        ◄══ konsumiert .tex-Artefakte  [Layer 4]
        ▲
Code/ Anwender-Schicht (WAS + Auswertung)                                    [Layer 1]
  experiment_config/*.xml ──► 02 messung_driver ──► 03..06 Auswerte-Pipeline
        │ (linkt/inkludiert nach unten)
        ▼
comdare-cache-engine (WIE: Framework + Interpretations-Bibliothek           [Layer 2]
  + Plugin-Controller)  ExperimentDriver · xml_config_parser · codegen ·
  module_loader · workload_generator · Prüf-Dock/F15 · latex_toolchain
        ▼ ··plugin·· (Compile-Time-Slot je Achse)
comdare-prt-art (Prüfling, füllt optional_prt_art_impl)                       [Layer 3]
```

Belegte SOT-Kette: `docs/TEILPROGRAMM-ABHAENGIGKEITSBAUM.md:42-113` (ASCII-Baum), `:236-263` (Legende).
Wichtig: Die UML-Docs `Y3/Z3/Y4/Z4/Z5` sind **SUPERSEDED** (altes in-process `register_engine`-Modell) — Banner jeweils in Zeile 3. IST-treue Quelle = das cache-engine-Ledger (`docs/sessions/20260531-gesamtkontext-maschinerie-und-goal.md:7-8`). Ich habe die aktuelle Topologie deshalb aus `TEILPROGRAMM-ABHAENGIGKEITSBAUM.md` + `Code/CMakeLists.txt` + der On-Disk-Struktur abgeleitet, nicht aus den Y/Z-Docs.

---

## 1. Die vier Teilprogramme — Rolle + Kopplung

Bestätigt aus `.gitmodules` (super, 3 Submodule) + `TEILPROGRAMM-ABHAENGIGKEITSBAUM.md:236-263`:

| # | Teilprogramm | Pfad | Rolle | Kopplung nach unten |
|---|---|---|---|---|
| **1** | **Diplomarbeit-Super-Repo (Anwender)** | `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/` + `Code/` | Anwender-Schicht: definiert **WAS** gemessen wird (XML-Profile) + wertet Binary-Ergebnisse aus (CSV→LaTeX→PDF). Orchestriert die 6-Stufen-Pipeline. | **Lose externe Abhängigkeit (A):** bindet CE + prt-art als *parallele* Submodule via `add_subdirectory(... EXCLUDE_FROM_ALL)` — `Code/CMakeLists.txt:183-194`. Baut nur, was ein Pipeline-Modul per `target_link_libraries` anzieht. |
| **2** | **comdare-cache-engine (Framework + Interpretations-Bibliothek + Plugin-Controller)** | `Code/external/comdare-cache-engine/` | Der „Stand der Technik": bestimmt **WIE** gemessen wird. Interpretiert die XML-Profile, generiert/kompiliert/lädt Permutations-DLLs, führt sie aus und misst (Prüf-Dock/F15). | Wird von `02_messung_driver` **gelinkt** (`comdare_builder_experiment_driver`, `comdare::workload_generator`) — `TEILPROGRAMM-…:88-92`. **Lädt prt-art als Plugin (B).** |
| **3** | **comdare-prt-art (Prüfling)** | `Code/external/comdare-prt-art/` | Experimenteller Hybrid-Suchalgorithmus, der gegen den Stand der Technik geprüft wird. Konsumiert CE als **Werkzeug** (nie umgekehrt — REV 6 „PRT-ART = Prüfling, CacheEngine = Werkzeug"). | **Meta-Programmier-Kopplung (B):** `-DCOMDARE_CE_PRUEFLINGE=<prt-art>` → CE inkludiert `comdare_pruefling.cmake` → prt-art **spezialisiert je Achse** den reservierten Compile-Time-Slot `comdare::cache_engine::<axis>::optional_prt_art_impl` (`axis_centric_namespaces.hpp:146-170`). Header: `comdare_prt_art_core` (INTERFACE) zieht CE-Includes — `TEILPROGRAMM-…:75-81`, `:247-254`. |
| **4** | **thesis/diplomarbeit (Manuskript)** | `thesis/diplomarbeit` (Submodule, Overleaf-Remote) | LaTeX-Manuskript, das die Mess-Artefakte einbindet. | **Artefakt-Konsum (C):** *keine* Code-Kante. Konsumiert die von Stufe 04/05 erzeugten `.tex`-Dateien, gebaut von Stufe 06 mit der aus CE kopierten `latex_toolchain.cmake` — `TEILPROGRAMM-…:255-257`. |

Die drei Kopplungsstärken (A lose Abhängigkeit / B Meta-Programmier-Plugin-Slot / C Artefakt-Konsum) sind tabellarisch in `TEILPROGRAMM-ABHAENGIGKEITSBAUM.md:16-20`.

---

## 2. Die Schichtung — welche „4 Layer"?

Es gibt **zwei** legitime „Vierer", die nicht verwechselt werden dürfen:

**(a) 4 Teilprogramme = 4 Repo-Layer** (aktuelle, autoritative Topologie, s. §1): Anwender → Framework → Prüfling → Manuskript. Das ist die *Build-/Kopplungs-Schichtung*.

**(b) 4 M-Modell-Subsysteme** (Laufzeit-Rollen *innerhalb* des WIE-Mechanismus; aus den superseded UML-Docs, konzeptionell aber weiter gültig) — `Z4_soll_uml_cross_repo_bidi.md:15-31`:
1. **Subsystem 1** — `Code/02_messung_driver` (Outer-Loop / Auswertungs-Orchestrator)
2. **Subsystem 2** — `CacheEngineBuilder` / `ExperimentDriver` (autonomes Plattform-Ausmess-System)
3. **Subsystem 3** — `CacheEngine` (Werkzeug-Bibliothek: Sub-Engines + Strategien)
4. **Subsystem 4** — Prüfling PRT-ART (`IExecutingEngine` / `optional_prt_art_impl`)

### Die Grenze „stellt Profile bereit" vs. „interpretiert/führt durch" — WAS vs. WIE

Das ist die zentrale Architektur-Grenze, autoritativ als User-Direktive fixiert in `STRUCTURAL_CORRECTION_diplomarbeit.md:863-923` („NACHTRAG: Klarstellung WAS vs WIE"):

| Verantwortung | Repo/Layer | Konkret |
|---|---|---|
| **WAS** getestet wird (Definition) + Compile-Time-Ausprägung | **Diplomarbeit/Code/** (Layer 1) | `experiment_config/config_{a,b,c}*.xml` + `messreihen.xml`; `02_messung_driver` — `STRUCTURAL_CORRECTION_…:883-884` |
| **Binary-Ergebnis-Auswertung** | **Diplomarbeit/Code/** (Layer 1) | `03_binary_to_csv` · `04_csv_to_latex` · `05_diagram_generator` · `06_latex_to_pdf` — `:885` |
| **WIE** gemessen wird (Mechanismus) | **comdare-cache-engine** (Layer 2) | `ExperimentDriver`-Lib, `ModuleLoader`, `Codegen`, `xml_config_parser`, `workload_generator`, Builder-Executable, Mikrobenchmark-Suite — `:880-882` |

**Die Grenze verläuft physisch mitten durch die XML-Verarbeitung:** Die XML-Profil-*Dateien* liegen in Layer 1 (`Code/experiment_config/`), aber der *Parser* der sie interpretiert (`xml_config_parser.hpp`) lebt in Layer 2 (cache-engine). Verifiziert in `Code/02_messung_driver/main.cpp:28-34` — der Driver `#include`t genau über die Grenze:
```
#include "experiment_driver/experiment_driver.hpp"   // WIE (cache-engine)
#include "xml_config_parser/xml_config_parser.hpp"    // WIE (cache-engine)
#include <comdare/workload_generator/workload_generator.hpp>  // WIE (cache-engine)
```
Merksatz aus `Y3_diplomarbeit_code_ist_kartografie.md:193-195`: „messung_driver = WAS gemessen wird; CacheEngineBuilder = WIE gemessen wird."

---

## 3. Die 6-Stufen-Mess-Pipeline — Datenfluss top-down

Verzeichnisse On-Disk bestätigt (`Code/01_*` … `06_*`, plus ein **07** — s. Caveat unten). Die CMake-Konvention `XX_operation/` mit zweistelligem Präfix: `feedback_thesis_divide_and_conquer` / `USAGE.md:37-42`.

```
experiment_config/*.xml  (Profil-Definition, Layer 1 = WAS)
   │
[01] sample_data_generator  ──► synthetische 16-Spalten-CSV   (standalone, KEIN CE-Link)
   │      (Demo-/Abnahme-Pfad; ersetzt reale HW-Messung)
   │
[02] messung_driver         ──► measurement_record (*.bin, magic 0xC0FFEE02)
   │      linkt comdare_builder_experiment_driver + workload_generator (CE)
   │      inkludiert prt_art-Header  → treibt Permutations-DLLs, misst
   ▼
[03] binary_to_csv          ──► 16-Spalten-CSV  (deserialisiert CE-ABI module_abi_v1.hpp)
   ▼
   ├──► [04] csv_to_latex        ──► booktabs-LaTeX-Tabelle (*.tex)
   └──► [05] diagram_generator   ──► TikZ/pgfplots-Diagramm (*.tex, --by-workload)
                 │
                 ▼
[06] latex_to_pdf   ──► pdflatex 2× + bibtex  (via CE latex_toolchain.cmake)
   ▼
thesis/diplomarbeit  ──► Diplomarbeit-PDF
```

Belege:
- Datenfluss-Diagramm: `TEILPROGRAMM-ABHAENGIGKEITSBAUM.md:117-140`; `gesamtkontext-…:20-25`.
- **CMake-Orchestrierung** `comdare_pipeline_e2e` (treibt EINEN Datensatz geschlossen durch): `Code/CMakeLists.txt:328-353`. Der Demo-Pfad überspringt 02/03: `sample_data_generator → 04 + 05 → 06` (`CMakeLists.txt:342-351`).
- **Realer Pfad** `comdare_pipeline_release` (#279, opt-in, nicht in Standard-CI): `messung_driver → measurements/all_permutations.bin → binary_to_csv → 04/05/06` — `Code/CMakeLists.txt:383-400`.
- 16-Spalten-Schema (kanonisch): `gesamtkontext-…:26-29`. Spalten 7-12 (cache_misses_l1/l2/l3, dtlb_misses, coherence_invalidations, energy) sind **heute Platzhalter 0** — sie werden erst durch die geplante Mess-Abstraktion (Goal I1-I4) mit echten HW-Countern gefüllt (`gesamtkontext-…:28-29,61-69`).

Zwei Achsen sauber trennen (`TEILPROGRAMM-…:258-261`): **Build-Abhängigkeit** (add_subdir/link/include, §1) ≠ **Laufzeit-Datenfluss** (bin/CSV/tex/PDF, dieser §3).

---

## 4. EIN Experiment top-down (Messreihe A)

Konkreter Fluss vom Profil bis zur Auswertung — verifiziert an `messreihen.xml`, `02_messung_driver/main.cpp` und `Code/CMakeLists.txt`:

1. **Profil-Definition (WAS, Layer 1).** `Code/experiment_config/messreihen.xml:16-31` definiert `<messreihe id="A_defined">` mit `<mode>defined</mode>` + 8 Tier-1-SOTA-Profilen (`art`, `hot`, `masstree`, `coco_trie`, `start`, `b2tree`, `wormhole`, `surf`). `defined` = vorhandene Profile; `full` = jede Rekombination gegen jede (`STRUCTURAL_CORRECTION_…:102`).

2. **messung_driver liest Profil (Grenze WAS→WIE).** `02_messung_driver/main.cpp` (`MessreiheKind::A_PrtArtVsSota`, `main.cpp:107-120`) iteriert über die Messreihen; pro Messreihe wird der cache-engine-`ExperimentDriver` mit passendem Mode + `sota_profile_filter` gestartet. Der XML wird vom CE-Parser (`xml_config_parser.hpp`) interpretiert, nicht vom Driver selbst (`main.cpp:28-29`). Aufruf-Signatur: `Code/CMakeLists.txt:385-388` (`<config_dir> <output_dir> --messreihen-xml=…`).

3. **cache-engine-Interpretation + Durchführung (WIE, Layer 2/3).** Der `ExperimentDriver` fährt die Phasen (`USAGE.md:183-192`): **1 Enumeration** (XML→Permutationsliste) → **2 Codegen** (`comdare_perm_<fp>.cpp` je Permutation) → **3 Compile** (Sub-Build der DLLs) → **4 Load** (`dlopen`/`LoadLibrary` über `module_abi_v1`) → **5 Execute** (`workload_generator` speist Zipfian/YCSB) → **6 Measure** → **7 Persist**. Der Prüfling prt-art steckt dabei über den Compile-Time-Slot `optional_prt_art_impl` je Achse ein (Plugin-Controller, `TEILPROGRAMM-…:70-72`) — statischer Dispatch, kein Runtime-Switch (konform zu Memory `feedback_no_runtime_switch` / `feedback_compile_time_only_no_runtime`).

4. **Messung → Binärcontainer.** Ausgabe: `measurement_record`-Binaries (`*.bin`, magic `0xC0FFEE02`) bzw. `measurements.{csv,json}` unter `<output_dir>/<id>/` (`USAGE.md:189-192`).

5. **Auswertung (WAS zurück in Layer 1).** `03_binary_to_csv` deserialisiert die CE-ABI-Binaries → 16-Spalten-CSV → `04_csv_to_latex` (booktabs-Tabelle + Baustein-Steckbrief) + `05_diagram_generator` (TikZ `--by-workload`) → `06_latex_to_pdf` (pdflatex 2×) → einbindbar in `thesis/`.

**Autoritative Hand-Bedienung** (User-Self-Test): `Code/MANUAL_RUN.md` ist gegenüber `USAGE.md` autoritativ (`USAGE.md:3`; `MANUAL_RUN.md:3`). Empfohlen ist dort **Weg A** = Profil-Flow über `tests/unit/thesis_tiere/build_and_measure_150_tiere.ps1` (`MANUAL_RUN.md:11-26`); **Weg B** = `messung_driver` hat noch offene Fixes (`MANUAL_RUN.md:39-59`, Lücke #1: `COMDARE_EXPERIMENT_MODE=ON` ist nicht Preset-Default).

---

## 5. Verifizierte Drifts / Caveats (live gegen Platte geprüft)

1. **„6-Stufen" ist präzise die Daten-Pipeline 01–06 — aber On-Disk existiert ein `07_tier_binary_report/`** (`Code/CMakeLists.txt:318`). Das ist KEINE Daten-Fluss-Stufe, sondern das #279-Build-Sichtbarkeits-/Interface-Roster-Tool (`comdare_tier_binary_visibility`, `CMakeLists.txt:410-427`). Nicht mit den 6 Mess-Stufen vermischen.
2. **Spalten-Zahl-Drift:** `Code/README.md:35` sagt „15-Spalten", `USAGE.md` teils auch. **Kanonisch sind 16 Spalten** (`gesamtkontext-…:26-29`, `CMakeLists.txt:344-347`, Stand 2026-05-31). 16 gilt.
3. **UML-Docs `Y3/Z3/Y4/Z4/Z5` sind SUPERSEDED** (Banner Zeile 3 in jeder Datei) — sie zeigen das alte in-process `register_engine`-Modell (`Z4:104-147`) mit prt-art als *genestetem* Submodul und `CacheEngineBuilder` als separater Executable-Subsystem. Der Code ist heute **axis-zentrisch + Plugin-Controller + DLL/F15**. Für Rollen/WAS-WIE bleiben sie brauchbar, für die konkrete Kopplungs-Mechanik NICHT — dort gilt `TEILPROGRAMM-ABHAENGIGKEITSBAUM.md` (2026-06-25) + `Code/CMakeLists.txt`.
4. **prt-art-Kopplung ist NICHT klassischer Library-Link**, sondern Plugin-Controller-Slot-Merge (Compile-Time-Metaprogrammierung). Im Diplomarbeit-Build ist prt-art zusätzlich mit `COMDARE_PRT_ART_USE_CACHE_ENGINE=OFF` eingebunden, um doppelten CE-Sub-Build zu vermeiden (`Code/CMakeLists.txt:190-194`).

---

## Relevante Datei-Pfade (absolut)

- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/.gitmodules` — 3 Submodule (prt-art, cache-engine, thesis)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/TEILPROGRAMM-ABHAENGIGKEITSBAUM.md` — **autoritativer Kopplungs-/Datenfluss-Baum**
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/STRUCTURAL_CORRECTION_diplomarbeit.md:863-923` — **WAS-vs-WIE-Grenzdefinition (User-Direktive)**
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/PROJECT_LAYER_MAP.md` — Repo-Rollen (Teil A/B/C)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/CMakeLists.txt` — Build-Orchestrierung, `comdare_pipeline_e2e:328-353`, `comdare_pipeline_release:383-400`
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/02_messung_driver/main.cpp:28-34` — die WAS→WIE-Grenze im Include
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/experiment_config/messreihen.xml` — 4 Pflicht-Messreihen (A_defined/A_full/B/C)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/Code/MANUAL_RUN.md` — autoritativer Hand-Flow (Weg A Profil-Flow)
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/sessions/20260531-gesamtkontext-maschinerie-und-goal.md` — 16-Spalten-Schema + Mess-Abstraktions-Goal
- UML (SUPERSEDED, nur für M-Modell-Rollen): `docs/uml_planning/{Y3,Z3,Y4,Z4,Z5}_*.md`