---
name: feedback_only_one_official_xml_driven_program_no_behelfswege
description: "Ab 2026-07-11: NUR EIN offizielles Anwendungsprogramm (Diplomarbeit/messung_driver bzw. cache_engine_builder-App) darf den Gesamt-Mess-Ablauf orchestrieren, und AUSSCHLIESSLICH über XML. Alle Behelfsprogramme (run_lazy_150, *.ps1-Harness) sind zu löschen; die XML muss ALLE Belange des Mess-Systems steuern."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 46375cdc-821a-4bf9-93d4-fe0a5687f489
---

**User-Direktive 2026-07-11 (Produktions-Anspruch):** Ab sofort darf **nur noch EIN Anwendungsprogramm** (wie die
Diplomarbeit — `messung_driver` bzw. die `cache_engine_builder`-App, die die `ExperimentDriver`-Library treibt) den
**Gesamtablauf** der Messung orchestrieren, und **NUR über XML**. Die XML (`comdare_thesis_profile` wie
`m3v2_study.profile.xml` = golden-320, + die 4-Datei-Experiment-Config + `messreihen.xml`) muss **ausreichen, um ALLE
Belange des Mess-Systems zu steuern** (19 Achsen, dyn. RC-Achsen, Workload/Dataset, Mess-Kategorien, n_ops/repeats/
resume, Output, die 3 Messreihen A/B/C, SOTA-Profile).

**Was das heißt:**
1. **Behelfswege LÖSCHEN** (nicht nur deprecaten — der User sagte „lösche sie"): `run_lazy_150.cpp` + alle
   `tests/unit/thesis_tiere/*.ps1` (`build_and_measure_150_tiere.ps1`, `build_axis_sweep_pilot.ps1`,
   `k10_release_probe_only.ps1`, …) + jeder ad-hoc-Treiber, der Codegen→Build→Measure ausserhalb des offiziellen
   Wegs macht. VORHER die Abhängigkeiten umhängen (CI-Jobs/Tests, die darauf zeigen), damit nichts bricht.
   *(Ausnahme zur „Doku nie löschen"-Regel: hier ist explizit CODE-Behelf gemeint, nicht Doku.)*
2. **NUR die XML treibt.** Was heute aus `argv`/`env`/`#define`/CLI-Args kommt (z.B. `COMDARE_PILOT_INCLUDES`,
   n_ops, resume, max_binaries, workload-Hartkode `YcsbWorkload::C`), muss in die XML + den Parser wandern
   (XML-Suffizienz-Gap → nachimplementieren). Vgl. [[feedback_e4_xml_autoritative_bauanleitung_ceb_orchestriert]].
3. **Der offizielle Weg muss im Plan per ultracode findbar verankert sein** (docs/architektur, Doc 16/19, Ledger).
4. **Cross-Platform** (User-GO 11.07.): die Strecke muss auf **Linux/macOS/Windows** laufen — der C++-Kern
   (`ExperimentDriver`, `AnatomyModuleLoader` dlopen/.so/.dll/.dylib, CompileFn) ist portabel; der PowerShell-Behelf
   ist die zu tilgende Windows-Lücke.

**Warum:** [[feedback_immer_schwerer_offizieller_weg_keine_behelfswege]] + [[feedback_no_quick_fixes]] auf Produktions-
Ebene gehoben. Siehe [[feedback_production_track_full_golden_run_finds_errors]].

**Wie anwenden:** Bei jeder Mess-/Treiber-Arbeit prüfen: geht das über die EINE XML-getriebene App? Wenn ein
Behelfsweg gefunden wird → aufräumen+löschen (Abhängigkeiten zuerst umhängen), nicht parallel weiterpflegen.
Neue Steuerungs-Features IMMER in die XML + Parser, nie als CLI-Arg/env/define.
