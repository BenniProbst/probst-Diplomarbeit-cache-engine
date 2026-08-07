# DOSSIER — CI-interaktive Diplomarbeit: Anhang-Automatisierung + datengetriebene Darstellung

> **Auftrag (User 2026-07-11):** Eine XML-Einstellung → über die gesamte Kette → eine Diplomarbeit-Evaluation
> mit dynamisch ausgewerteten Messwerten, Tabellen und Diagrammen. Die vorbereiteten Anhang-Kapitel automatisiert
> aus den aktuellen Messwerten befüllen; Darstellungsform datengetrieben (Sichtprüfung + Deep-Research) wählen.
> Vehikel = **saubere C++23-Teil-Anwendung** (kein Python/.ps1, keine Behelfswege), die LaTeX-Code generiert.
> **Grundlage:** 3 delegierte Analysen (Anhang-Audit + Viz-Deep-Research + ultracode-C++23-Ersetzungs-Audit
> `wf_2c594d82`). Rohdaten: `docs/sessions/backups/20260711-ci-interactive-thesis-analysis/`. Tasks #24/#25.

---

> ---
>
> ## ⚠️ STAND 2026-08-07: DIE IST-ANALYSE BESCHREIBT EINEN ZUSTAND, DEN ES NICHT MEHR GIBT
>
> **Der Auftrag und der Zuschnitt gelten weiter. Teil A ist ueberholt -- und zwar gruendlich:
> das Vehikel ist gebaut, die PowerShell-Skripte sind weg, und die Stufen-Nummern stimmen nicht.**
> Belege gegen super HEAD und ce `ba069e38`.
>
> ### Die Stufen-Nummern: 06 ist heute 08 und 09
>
> `:105`, `:138`, `:156` nennen `Code/06_appendix_generator` und `Code/06_tex_formatter`.
> **Ist:** `Code/08_appendix_generator/` und `Code/09_tex_formatter/` (je CLI, Lib und Tests);
> Stufe `06` ist `06_latex_to_pdf`. Die Pipeline laeuft `01_sample_data_generator` bis
> `09_tex_formatter`. Der R10-Nachtrag `:168` flaggt das bereits -- **der Haupttext bleibt
> irrefuehrend und ist die Stelle, die zuerst gelesen wird.**
>
> ### Vollzugs-Marken
>
> - `:31-40`, `:154-155` „Die **einzige** Verdrahtung sind **zwei Windows-only PowerShell-Skripte**:
>   `generate_measurement_appendix.ps1`, `generate_wide_appendix.ps1`" -- **BEIDE WEG.**
>   `find` ueber den super-Baum liefert **null `.ps1`-Dateien ueberhaupt** (ebenso im ce).
>   Ersetzt durch die In-Process-Fassade; der Ersatz ist im Header ausdruecklich benannt
>   (`Code/08_appendix_generator/appendix_generator.hpp:10-16`).
> - `:121-124` „**Pipeline-Stufe** (`.gitlab-ci.yml`): nach `measure` … regeneriert
>   `anhang/<lang>/tabellen/*.tex`" (im Futur formuliert) -- **VERDRAHTET.** Das Ziel
>   `appendix_generator_cli` wird in drei CI-Bloecken gebaut und ausgefuehrt
>   (`.gitlab-ci.yml:765`, `:857`, `:1136`). **Der Job heisst aber nicht „appendix_generator"**,
>   sondern **`anhang:forward`** (`.gitlab-ci.yml:1093`, Stage `persist`, opt-in ueber
>   `COMDARE_ANHANG_FORWARD`). Wer nach dem Doku-Namen sucht, findet nichts.
> - `:91-96` Status-Spalte B.3: P2 „`write_scatter_plot` existiert, **unverdrahtet**", P3 „neu",
>   P4 „neu", P5, P6 -- **P2 bis P6 sind gebaut.** Nur **P1 (Fit-Overlay)** fehlt weiterhin, und das
>   ist korrekt so: es ist daten-gated (`:144`).
> - `:157` „`ce/tools/permutation_codegen/codegen.sh` … ersetzt den Dreifach-Sync in
>   `cmake/permutations.cmake:60-84`" -- **alle drei Pfade existieren nicht.** Der Codegen liegt
>   heute in `cmake/anatomy_codegen.cmake`, `cmake/catalog_codegen.cmake`,
>   `cmake/adhoc_emitter.cmake`, `cmake/anatomy_codegen_runner.cmake`.
>
> **Weiterhin korrekt (nicht anfassen):** `:49` „`curve_fit::fit_log_linear` wird in **KEINEM**
> Diagramm genutzt" · `:144` P1 Working-Set-Kurve ohne Fit-Overlay, daten-gated ·
> `:47-48` `write_heatmap` weiterhin nur intern (fuer `write_scatter_plot` gilt das **nicht** mehr,
> s.o.).
>
> ---

## TEIL A — IST-ANALYSE

### A.1 Anhang-Automatisierbarkeit (A–F, DE+EN)

| Anhang | messwert-getrieben? | Automatisierbar aus der Messquelle? | IST-Zustand |
|---|---|---|---|
| **A_measurements** | **JA** (11/12 Tabellen; le_limitierung statisch) | **JA** — die einzige echt aus Messwerten regenerierbare Datei | echt-generiert, aber **statisch committet**; nur via Windows-`.ps1` |
| B_code_structure | nein | nein (Code-Layer-Map ≠ result.csv) | **leerer Stub** (DE+EN) |
| C_glossary | nein | nein (Definitionen) | handgeschrieben, DE/EN in Sync |
| D_building_block_matrix | nein | nein (Baustein-Katalog aus Code+Paper-Provenienz) | handgepflegt ~128 KB, DE/EN synchron |
| E_architecture_decisions | nein | nein (ADRs aus `docs/bausteine/04…md`) | **leerer Stub** (DE+EN) |
| F_comparison_interfaces | nein | nein (ISO-C++-Referenz) | handgeschrieben, DE/EN in Sync |

**Fazit:** Nur **A_measurements** ist aus der bewiesenen Messquelle automatisierbar. B/E sind inhaltslose Stubs mit
NICHT-Mess-Quellen (separate Extraktoren, kein Teil dieses Auftrags — als Folge-TODO notiert). C/D/F sind bewusst
handgepflegt. ⇒ Der Automations-Fokus ist **A_measurements**; die C++23-App muss NUR diese eine bedienen.

### A.2 Die Behelfsweg-Lücke

- Die 12 `\input{anhang/<lang>/tabellen/*.tex}` sind `% AUTO-GENERATED`, aber **einmalig statisch committet**.
- **Kein CMake/CI-Target** schreibt nach `anhang/<lang>/tabellen/`. Die `comdare_pipeline_*`-Targets schreiben
  woanders hin; `integration:smoke` läuft gegen Fixtures.
- Die **einzige** Verdrahtung der CLIs auf die Anhang-Tabellen sind **zwei Windows-only PowerShell-Skripte**:
  - `generate_measurement_appendix.ps1` (C1, **STALE**, 16-Spalten-Legacy) → nur v5_pipeline_demo.
  - `generate_wide_appendix.ps1` (L8, aktiv, 175-WIDE) → die 11 WIDE-Tabellen; msvc-g1-`.exe`-Pfade, 8 `.exe`-
    Spawns/Sprache, Stale-Binary-Guard.
- **Schema-Bruch in A:** v5_pipeline_demo + cartesian_smoke43 verlangen das **16-Spalten-Legacy-CSV**; bias/surface/
  exchange das **175-WIDE**. Der Legacy-Pfad kann WIDE nicht lesen → aus dem WIDE-result.csv sind die zwei ersten
  Tabellen aktuell nicht regenerierbar.

### A.3 Tool-Fähigkeiten (bereits vorhanden, C++-Libs)

- **`comdare::csv_to_latex`** (ALIAS-Lib): legacy-table · `--schema=wide` (Bias-Matrix) · `--exchange` (4 Longtables)
  · `--limitierung` (statisch) · `--sota-series` · `--sweep-axis` · `--seg-coverage`. Kern: `parse_wide_csv` (die
  perf-kritische Groß-Tabellen-Parse-Arbeit — bereits C++).
- **`comdare::diagram_generator`** (ALIAS-Lib): demo-bar · `--by-workload` · `--surface`/`--3d` (Heatmap) ·
  `--sweep-curve` (Working-Set-Kurve). **Nicht CLI-exponiert:** `write_scatter_plot`, generisches `write_heatmap`.
- **`curve_fit::fit_log_linear`** (y=a·log2(x)+b) existiert, wird aber in **KEINEM** Diagramm genutzt.

⇒ **Die Darstellungslogik ist zu ~80% da.** Die Lücke ist **Orchestrierung + Verdrahtung + wenige neue/exponierte
Writer**, nicht fehlende Kernlogik. Der perf-Anspruch (gigantische Tabellen) ist bereits erfüllt: das Groß-Parsen
sitzt in C++ (`parse_wide_csv`), nicht in Skripten (bestätigt vom C++23-Audit: **kein high-Perf-Kandidat**).

---

## TEIL B — DATENGETRIEBENE DARSTELLUNG (Viz-Deep-Research, feld-fundiert)

**Zwei Rahmen-Befunde:** (1) alle `pmc_*`-Spalten sind 0 (NullPmcSource) → jede Cache-Miss-Darstellung ist bis #26
honest-empty, NICHT bauen. (2) Der Log-Linear-Fit existiert, wird aber nirgends visualisiert = der größte
ungenutzte Hebel.

### B.1 Mapping Datentyp → optimale Darstellung (mit Feld-Beleg)

| Datentyp | Optimal | Quelle |
|---|---|---|
| Per-Op-Perzentile p50/p99 | **ECDF** + **p50→p99-Range-Balken** (KEIN Box mit erfundenen Quartilen) | HOT Fig.11, Marcus VLDB'21 Fig.6 |
| Gesamt ns_per_op | gruppierte Balken (klein) / Heatmap (groß), **LOG** (4 Dekaden!) | HOT Fig.8, Wormhole Fig.10 |
| Segment-Zeiten seg_*_ns | **gestapelte Balken** (Latenz-Attribution) | Ailamaki VLDB'99, HOT Fig.9 |
| Space-Time (peak vs. Latenz) | **Pareto-Front-Scatter** + Baseline-Linie | Marcus VLDB'21 Fig.7, SuRF Fig.8 |
| Cross-Perm Bias-Matrix | **Heatmap LOG-Farbskala** + Tabelle als Exakt-Backup | HOT/Wormhole |
| Achsen-Austauschbarkeit | **Forest-/Dot-Plot** (Punkt=median Δ, Whisker=IQR) + Longtable | — |
| Cache-Hierarchie-Kurve (working_set→Latenz) | **Log-x-Linie + Fit-Overlay + L1/L2/L3-Linien** | ART ICDE'13 Fig.10/13 |

### B.2 Bewertung der aktuellen Artefakte

- **bias_matrix_table** — VERBESSERBAR: reine Zahlentabelle (kein Farbcode), 4 Dekaden mit Auge nicht scanbar.
  Behalten als Exakt-Backup; Muster an die Heatmap delegieren.
- **lc_surface_* (6×)** — VERBESSERBAR, **gravierender Defekt: LINEARE viridis über 33…235805 ns → sättigt**, echte
  Unterschiede verschwinden. **Fix P6: logarithmische Farbskala.** Zudem nur 4 Zeilen (search_algo), andere 3 Achsen
  kollabiert.
- **ld_exchange_* (4×)** — VERBESSERBAR: Longtable als Referenz ok, Kernaussage begraben; Division-durch-~0-Ausreißer
  (scan n=11) ungewarnt. Longtable behalten + Forest-Plot ergänzen.
- **le_limitierung** — OPTIMAL (qualitative Prosa), behalten.
- **cartesian_smoke43 / v5_pipeline_demo** — ok; L1/L2/L3-Null-Spalten annotieren/streichen, Balken nach Wert sortieren.

### B.3 Neue Darstellungen (priorisiert)

| # | Darstellung | Hebel | Status |
|---|---|---|---|
| **P1** | Working-Set-Linie **+ Log-Linear-Fit-Overlay** + Cache-Grenzen | HÖCHSTER (Kern-Cache-Test) | Generator existiert, Fit ungenutzt; **#156-Sweep-Daten-gated** (`working_set_n`) |
| **P2** | Pareto-Front-Scatter Space-vs-Latenz | hoch | `write_scatter_plot` existiert, unverdrahtet |
| **P3** | Latenz-ECDF + p50→p99-Range-Balken | hoch | neu (Perzentil-Spalten da) |
| **P4** | Gestapelte-Balken **Segment-Attribution** (Kern-Beitrag!) | hoch | neu (19 seg_*_ns da) |
| **P5** | Forest-Plot Achsen-Austauschbarkeit | mittel | ergänzt ld_exchange |
| **P6** | **Log-Farbskala-Fix** für lc_surface | sofort, klein | Fix bestehend |
| — | pmc_cache_misses-Darstellungen | — | **NICHT bauen** (honest-empty bis #26) |

---

## TEIL C — DIE C++23-ANHANG-GENERATOR-APP

### C.1 Design

**`Code/06_appendix_generator`** (bzw. Subkommando des offiziellen XML-Treibers), C++23, CLI + Lib + ctest —
exakt nach dem Muster von 04/05.
- **Eingang:** die E4-XML (autoritative Bauanleitung; deklariert Matrix-CSV-Pfad, Sprachen {de,en}, Bias-Caption/
  Label, 6 surface-z_fields, exchange-Achsen, limitierung-Flag, optional m3v2-Gate) — bzw. gespiegelte CLI-Args.
- **Verarbeitung:** linkt `comdare::csv_to_latex` + `comdare::diagram_generator` als **Bibliotheken IN-PROCESS**
  (kein `.exe`-Spawn): `parse_wide_csv` **einmalig** → `aggregate_*` → `write_bias_matrix_latex`/`write_surface_*`/
  `write_exchange_longtables`/`write_limitations_longtable`. Der Stale-Binary-Guard entfällt ersatzlos.
- **Ausgang:** die 11 (+m3v2) `.tex`/Sprache nach `anhang/<lang>/tabellen/`.
- **Akzeptanz:** **`git diff --stat = 0`** gegen die committeten kanonischen `.tex` (byte-identische Reproduktion
  des IST-Standes als Regressionsnetz), DANN erst neue/verbesserte Darstellungen.

### C.2 Andockpunkt CMake/CI

- `add_executable(appendix_generator …)` + `target_link_libraries(… comdare::csv_to_latex comdare::diagram_generator)`
  analog zu den `*_cli`-Targets. Ggf. Kernfunktionen aus `04/05/main_cli.cpp` in die Lib-`.hpp/.cpp` heben (kleine
  Extraktion, damit exchange/limitierung/surface als Lib-API erreichbar sind).
- **Pipeline-Stufe** (`.gitlab-ci.yml`): nach `measure` (CSVs da) / im `thesis-pdf`-Vorlauf → `appendix_generator`
  regeneriert `anhang/<lang>/tabellen/*.tex` aus dem measure_out-WIDE-CSV → thesis-PDF kompiliert sie → persist.
  Cross-platform (Linux-CI + Windows), ersetzt beide `.ps1`.
- **⇒ Eine XML-Einstellung treibt die Kette bis zum evaluierten PDF** (CI-interaktive Diplomarbeit).

### C.3 Schema-Brücke (v5/cartesian)

Der Schema-Bruch (16-Spalten-Legacy für v5/cartesian) wird sauber gelöst durch einen **WIDE→Permutations-Tabelle-
Modus** in `csv_to_latex` (statt eine tote 16-Spalten-Quelle künstlich am Leben zu halten) — so speist EIN
175-WIDE-result.csv ALLE A-Sektionen.

---

## TEIL D — IMPLEMENTIERUNGS-ROADMAP (Increments, je test+review+CI-grün)

| Inc | Inhalt | Gate |
|---|---|---|
| **1** | `Code/06_appendix_generator` (CLI+Lib+ctest), in-process-Libs, byte-identische Reproduktion der 11 WIDE-`.tex` | `git diff --stat=0` |
| **2** | CMake/CI-Verdrahtung: measure→appendix_generator→anhang/tabellen→thesis-PDF→persist; beide `.ps1` deprecaten | CI grün, PDF enthält Tabellen |
| **3** | P6 (Log-Farbskala lc_surface) + Sichtprüfungs-Fixes (Null-PMC-Spalten, Sortierung) | Sicht-/Diff-Review |
| **4** | P4 Segment-Attribution (gestapelte Balken) + P3 ECDF/Range + P2 Pareto — je neuer Writer + ctest | ctest + Sichtprüfung |
| **5** | P5 Forest-Plot Achsen-Austauschbarkeit | ctest |
| **6** | Schema-Brücke WIDE→Permutations-Tabelle (v5/cartesian aus WIDE) | diff-Review |
| **P1** | Working-Set-Kurve + Fit-Overlay | **#156-Sweep-Daten-gated** (working_set_n) |

---

## TEIL E — C++23-ERSETZUNGS-TODOs (kette-weit, Task #25)

Aus `wf_2c594d82` (25 Kandidaten → 4 adversarial bestätigt; **kein high-Perf-Kandidat** — Groß-Parsen ist schon C++):

| Prio | Stelle | → C++23 |
|---|---|---|
| med (=#24) | `generate_wide_appendix.ps1` | = die Anhang-Generator-App oben |
| low (=#24) | `generate_measurement_appendix.ps1` (STALE) | faltet in die App |
| **med** | `thesis/diplomarbeit/tools/format_tex.py` | **`Code/06_tex_formatter`** (C++23-CLI, **UTF-8-Codepoint-Zählung** für Umlaute, ctest, in Makefile/CI verdrahten) |
| **med** | `ce/tools/permutation_codegen/codegen.sh` | **`comdare_permutation_codegen_cli`** über bestehende `CodegenEngine`-Lib; ersetzt cmake/sh/bat-Dreifach-Sync in `cmake/permutations.cmake:60-84` (Doku deprecaten, nicht löschen) |

**Direktive:** keine Behelfswege, immer der sauberste Weg ([[feedback_immer_schwerer_offizieller_weg_keine_behelfswege]]);
kein Python in der Build-Chain; die bestehenden Libs wiederverwenden statt Neucode.

---

## Nachträge — E2E-Re-Audit 2026-07-15 (Ausrichtung an §0-GOAL-V5 / erweiterte A-H-Architektur)

> Additive Ausrichtungs-Vermerke; der Originaltext oben bleibt unverändert (Doku nie löschen).

- **[R10 · Anker docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md:105]** Additive REV-Notiz an TEIL C/D/E setzen: das Stufen-Mapping auf den Ist-Stand der xml→pdf-Kette 01-09 nachziehen (appendix_generator = Stufe 08, tex_formatter = Stufe 09, latex_to_pdf = Stufe 06). Die alten "Code/06_*"-Bezeichnungen als historischen Planungsstand kennzeichnen (Dossier-Datum 2026-07-11, überholt am 07-12/07-13, als 06/07 bereits vergeben waren) — nicht löschen; die kanonischen Artefakte (Code + Ledger) tragen das korrekte 08/09/06-Mapping bereits.  \n  *(Bezug: veraltete Stufen-Nummerierung — "Code/06_appendix_generator"/"Code/06_tex_formatter" kollidiert mit der real vergebenen Stufe 06 = latex_to_pdf und kann die CMake/CI-Verdrahtung fehlleiten.)*
- **[R10 · Anker docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md:31]** Additive Ergänzung in TEIL B.3/C.1: die \InputIfFileExists-honest-empty-Verdrahtung für die additiven, mess-gegateten Darstellungen (P3 ECDF/Range, P4 Segment-Attribution, P5 Forest-Plot) als Pflicht festhalten, damit das PDF auch vor einem Messlauf sauber kompiliert; als Ist-Beleg auf `thesis/.../A_measurements.tex:82/92/103` verweisen (dort bereits bilingual, vorplatziert in der handgepflegten Konsum-Kapiteldatei verdrahtet).  \n  *(Bezug: die Doc beschreibt nur hartes \input der 12 als % AUTO-GENERATED markierten Tabellen; R10 verlangt \InputIfFileExists honest-empty für die kettengespeisten Anhänge — das Ist ist der Doc hier bereits voraus.)*
- **[R8 · Anker docs/architektur/22_CI_INTERAKTIVE_DIPLOMARBEIT_ANHANG_AUTOMATION.md:97]** Die honest-empty-Direktive beibehalten (Darstellungen auf Null-/NullPmcSource-Spalten bis #26 NICHT bauen) und lediglich um den R8-Quellen-Aspekt aus dem nächsten Befund ergänzen: reale Katalog-DLL statt Surrogat (PrtArtHashBackend/std::unordered_map), W4-Gate. Rein additiv — kein Bestandstext entfällt, es wird eine bereits bindende R8-Anforderung angewandt.  \n  *(Bezug: alle pmc_*-Spalten = 0 (NullPmcSource) → jede Cache-Miss-Darstellung ist bis #26 honest-empty, NICHT bauen; stark an R8/honest-100% ausgerichtet.)*
