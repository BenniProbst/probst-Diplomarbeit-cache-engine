# Chunk 9/30 — Extraktion (chronologisch)

**Rahmen:** Diplomarbeit-Managersession (comdare@prod1, TU Dresden, "cache-engine"). Der Chunk beginnt mitten in einer Kontext-Fortsetzung (Produktions-Track-Direktive bereits gesetzt), enthält ~12 Stop-Hook-Zyklen, eine `/compact`-Grenze (Z. 799–896) und endet mit einem laufenden Deep-Research-Workflow. Keine Secret-Werte werden zitiert.

---

## (a) User-Direktiven (chronologisch, wörtlich wo bindend)

**A0 — Produktions-Track (aus dem Eingangs-Summary, bindend, doppeltes „merke dir das"):**
> „Bitte lösche die alten Behelfsprogramme wie run_lazy_150. Ab sofort darf nur noch ein Anwendungsprogramm wie die Diplomarbeit den Gesamtablauf orchestrieren, und NUR noch über xml, bitte merke dir das. Das Gesamtstystem ist fertig, also erkennen wir nur Fehler, wenn wir es auch voll durchlaufen lassen. […] Wir sind jetzt mit dem Anspruch auf Produktion unterwegs, bitte merke dir das."

**A1 — GitFlow-Kontrollfrage (Z. 600):**
> „Gut und du hast dir gemerkt, dass main immer ein Vorfahr von development brancht ist?"

**A2 — Autonomie-GO (Z. 695):**
> „Ich gebe mein go, dass du die übrigen Punkte komplett selbst erledigst"

**A3 — Push-GO / Merge-GO (aus Summary Z. 861/864):** „Ja pushe auf beide remotes" · „Bitte merge das Problem autonom Zeile für Zeile"

**A4 — Autonomes Messen via CI (Summary Z. 866, als Memory persistiert):**
> „Bitte merke dir, dass du ab jetzt autonom messen darfst mithile der CI als job und dass du aufgrund dessen autonom fortfährst und unbekannte Punkte in den 4 Projekten cross mit ultracode recherchierst, es ist alles da und geplant und definiert"

**A5 — CI-Fix-GO (Summary Z. 867):** „Hinweis: Die Diplomarbeit CI funktioniert nicht, du hast mein volles GO dieses Problem autonom zu beheben"

**A6 — Task #18 Coverage-Auftrag (Summary Z. 863):**
> „Bitte plane als eine weitere Aufgabe nach dem aktuellen Strang, den 320er Lauf so zu erweitern, dass er je Achse eine Konfiguration berührt und auch sonst alle Features, Frameworks und Lastprofile fordern, damit haben wir einen goldenen Test. die Anzahl der steuerbaren achsen hatte sich zuletzt auch erweitert…"

**A7 — Compaction-Auftrag (Z. 799):** „Bitte merke dir alle TODOs, den aktuellen Aufgabenbereich und Verlauf, sowie -stack und alle Learnings […] Lies alle Memory vollständig ein und das gesamte ledger."

**A8 — Fortsetzungs-Befehl (Z. 897):** „Bitte fahre mit offener Arbeit aus der letzten Session fort"

**A9 — CI-Gesamtlauf muss durchlaufen (Z. 963, bindend):**
> „Als der diplomarbeit Gesamtlauf ist immer noch rot, Wenn wir messen, muss der gesamte Lauf durch, um die Messwerte in die diplomarbeit pdf zu kompilieren"
> Ergänzende Klarstellung (Z. 969, als Memory verankert): der **CI-Gesamtlauf = Diplomarbeit-Pipeline mit ABGESCHALTETER Messung** (sonst alles an) — trennt CI-Grün vom mehrtägigen wissenschaftlichen Messlauf.

**A10 — ZIELAUFTRAG ÜBER ALLES (Z. 1231, wörtlich, bindend):**
> „Gut, der Zielauftrag über alles lautet, dass eine Diplomarbeit pipeline beim Durlauf über die cache-engine die Auswertungsdokumente erzeugt (latex pdf, messwerte csv) und diese im Pipelinedurchlauf zum schluss automatisch auf development pushed und damit zurückschreibt. Sonst gehen die Messergebnisse zum Schluss einfach verloren. Wir haben ja grundsätzlich im overleaf Projekt den Grundsatz der latex Diplomarbeit und hatten bestimmt, dass in die Sektion der messwerte automatisch alle Auswertungsformate generiert werden, bitte füge diese Anforderung als weiteres TODO in den Ledger und die sichtbare TODO Liste hinzu. Ich wünsche mir, dass jeder generierte Messwert Stand in einen neuen Ordner im Diplomarbeit root unter "measurement" Ordner versioniert in einem datierten Unterordner eingefügt wird mit YYYYMMTT-HH:SS Format, um die Ergebnisverarbeitung einer fertigen Diplomarbeit mit daneben liegenden Messwertebaum für jeden Durchlauf und damit commit zu persistieren - über die Akkumulation großer git Datenmengen bin ich mir bewusst, aber es ist erstmal die einfachste Variante. Später will ich diese Version zusätzlich durch das Schreiben nach backup1.comdare.de/Cluster_NFS/cache-engine-experiment mit den gleichen datierten Ordnern zusätzlich absichern (parallel beides)."

**A11 — Rahmungs-Korrektur (Z. 1237):** Das ist **keine neue Zielsetzung, sondern eine Erweiterung des bestehenden §0-Ziels** (Mess→PDF-Fluss).

**A12 — Merge statt Rebase (Z. 1294, bindend):** Die Rückschreibung erfolgt per **MERGE, nicht rebase**; bei fortgewandertem development wird gemergt.

**A13 — Workflow-Backup (Z. 1492/1494/1496, 3× wiederholt wegen API-Fehler):** „Bitte sichere den fertigen Workflow in einem backup Ordner in den Sessions"

**A14 — Stop-Hook (Goal-V3, ~12× wiederholt):** alle sichtbaren TODOs + offene Pläne chronologisch als Stack + Goal-Text V3 im Ledger; Striktheit Organisationsform/Modulreferenzierung/Metaprogrammierung; **unbenannte Achsen-/Tier-Metapher-Eigenschaft → Deep-Research starten und den Code in den gesetzten Grenzen fertigstellen**.

---

## (b) Architektur-/Scope-Entscheidungen (mit Begründung)

| # | Entscheidung | Begründung |
|---|---|---|
| B1 | **Der EINE offizielle Weg = `Code/02_messung_driver`** (E4-XML-Block `main.cpp:516-584`), cross-platform via g++/`posix_spawnp`. `cache_engine_builder` bezeichnet sich selbst als Demo → nicht der Weg. | Audit `wf_d5e03598-b5a` (4 Agenten, 408k Token) |
| B2 | **P0 zuerst (HEBUNG statt Löschung)** — 4 Header aus `tests/unit/thesis_tiere/` nach `libs/cache_engine/profile_facade/` | löscht nichts (geringeres Risiko), entsperrt spätere Löschung; die 18 `.ps1` waren **nicht referenzlos** (Kommentar-Refs in Keeper-Headern) → Löschung an P0/P5 gekoppelt |
| B3 | **P4 (RC-Achsen ins golden-Profil) = DEFER** | Ledger `:408(b)`: Verdrahtung gebaut (ce `1f9c2eef`) und **revertiert** (ce `290e306c`) wegen Max-Effort-Review mit **15 Mess-Defekten (8 CONFIRMED)**; DD-C „RC-Rest deferred"; DATA-gated auf #156 |
| B4 | **Audit-Fehler korrigiert:** `test_profile_roundtrip` + `test_ap2_katalog_pfad_stubfrei` sind **echte Gates**, keine löschbaren Behelfe | Behelfswege-Finder hatte sie falsch als Tier-2 klassifiziert |
| B5 | **P1/G1-Design: `<workloads>` wird autoritativer Filter** (statt Default auf ganzes Verzeichnis) | `load_profiles/` enthält **21** Profile (ycsb_*, lp_*, coco_*, ih, lh), golden will nur 6 → Default aufs Verzeichnis wäre Mess-Regression; direkter id-Set-Schnitt statt „A"→„ycsb_a"-Magie-Mapping |
| B6 | **G4 ist nur Kosmetik**, G5 echte Lücke | `cfg.n_repeats` wird nirgends geloopt (vestigial); echte Wiederholungen kommen aus `<repetitions count>`→DynDim |
| B7 | **P5: `resume` war bereits XML-honored** (`profile_run_entry.hpp:142`) — kein Fix nötig; nur `--validate` migrieren, `sweep_axis` gehört zu #18 | korrektheitskritischer Teil des mehrtägigen Laufs bereits gesichert |
| B8 | **P6 (Legacy-Entfernung) echt gegatet** auf golden-320-Subsumtion; umgesetzt als **Default-Umkehr statt Löschung** (E4 = Alleinweg, Legacy nur via `COMDARE_LEGACY_MESSREIHEN=1`) | Legacy fährt eine andere Maschinerie (3 Messreihen A/B/C via ExperimentDriver); byte-äquivalente Ablösung erst im Voll-Lauf beweisbar; voreiliges Löschen = Verlust der 3-Messreihen-Fähigkeit |
| B9 | **Task #18: „alle Lastprofile" = alle 21** (Klärung autonom aufgelöst) | User sagte „alle"; Filter (P1) greift bereits |
| B10 | **#18-Maschinerie: neues Template `AxisSweepCatalogFull` mit 19 Slots** statt Erweiterung des 4-Slot-`AxisSweepCatalog`; Proof-of-Pattern mit **einer** Achse zuerst | Maschinerie deckte nur 8/19 Achsen ab (4 Basis + 4 vertieft); 11 fehlten. Inkrementell, weil Metaprog-Fehler „kompiliert aber falsch" wären |
| B11 | **Anti-Null-Consumer:** neuer registrierter Gate `test_axis_sweep_coverage` als echter Konsument der 11 Kataloge | Doc 20 §I |
| B12 | **Lokaler golden-320-Lauf = Pipeline-Validierung, NICHT finale Datenbasis** | T8-Phantom (thread_count) + `hw_prefetcher` nur per MSR auf Cluster |
| B13 | **T8-Fix B (honest/label-only) statt Fix A (wire-it)** | Fix A = echtes In-Prozess-Threading wurde bei #221 wegen 8 Mess-Defekten revertiert → würde neue Artefakte einführen. Vertrag `resource_controllable_tier.hpp:66-67`: „Zahl der Achsen, die den Wert real angenommen haben" → Phantom-„applied" ist Vertragsbruch |
| B14 | **T2-Ontologie-Fix nutzt reservierten POD-Slot `axis_stats[2][6]`** (war `nullptr`) | sizeof-neutral (`const char*[19][8]` fix), kein neuer Achsenwert (MP03/MP04 blieben GO-pflichtig, würden Gate-1 verdoppeln), 1416-POD-TABU unberührt |
| B15 | **#22-Job `persist:measurements` inert-by-default** + neue `persist`-Stage; FS-sicheres Datum `YYYYMMDD-HHMMSS-p{pipeline}` statt `YYYYMMTT-HH:SS` | `:` illegal auf Windows/msvc-Build-Matrix; Auto-Push auf geteilte Branch + neues Write-Credential = bewusste User-Entscheidung |
| B16 | **#22-Writeback merge-basiert** (Workflow hatte rebase vorgeschlagen) | explizite User-Direktive A12 |
| B17 | **H-2 (MEMORY_FOOTPRINT-Peak) = NICHT bauen, honest-0 ist korrekt** — via Deep-Research aufgelöst, nicht deferred | `is_cleanly_buildable:false`, 3 Disqualifikatoren: (1) kein Chokepoint — 123 Call-Sites in 26 Dateien, `AllocatorStrategyBase` bewusst EBO-CRTP ohne Basis-Datenmember; (2) 7 Pool-Familien-Stores ohne in-use-Gauge → eine CSV-Spalte bedeutete je Familie Verschiedenes = Phantom; `restore_statistics`-Memento macht Fenster-Semantik unbestimmt; (3) Read-Path an heterogene Quelle = Phantom-Etikett. Direktive „Min/Max erforschen nie erfinden" + „falscher Wert schlimmer als honest-0" |
| B18 | **Phantom-Gaps adversarial ausgesiebt:** Container-Genera-Messung, Graph-Gattung, Latenz-Perzentile = `is_real=false` | bewusst-deferred bzw. „schon da, zweimal" — Bauen hätte TABU gebrochen / Redundanz erzeugt |
| B19 | **Goal-V3-Restposten sind Text-Agent-Domäne** (AP-H2-12/13, Habich-Runde 2, thesis `a457018`/`4eeb83c` vollzogen); DD-A..DD-E sind Entscheidungs-Leitlinien, keine offenen Impl-TODOs | Ledger :532-576 |

---

## (c) Paketmeldungen / Abnahmen / Commits

### ce (`comdare-cache-engine`, Branch `development`)
| Commit | Inhalt | Nachweis |
|---|---|---|
| `6b384d6e` | **P0 HEBUNG** — 4 Header → `libs/cache_engine/profile_facade/`; `git mv` + Codegen-String (`catalog_codegen_tool/main.cpp:280` bare) + Attach-Root (`catalog_codegen.cmake:50`) + 3 Include-Listen | configure grün · Katalog `static permutations=320` · **ctest 209/209** · beide Round-Trip-Gates grün · clang-format-22 sauber · kein Mojibake · `golden_fullpilot_320` unberührt |
| `fbc0411b` | **P1/G1** — Fassade defaultet co-lokalisierte `../load_profiles`, `<workloads>` = autoritativer Filter (toter Parse belebt), `<algorithm>`-Include, m3v2 `<workloads>ycsb_a..f` | 209/209 · Round-Trip „Diff leer" · **Filter deduktiv = 6 statt 21** |
| `adbb5f42` | **P2/G3** — `<working_set_sweep>` autoritativ, env `COMDARE_WORKLOAD_RECORDS` nur Fallback | 209/209 · Round-Trip `{16384..8388608}` Diff leer |
| `e72dba1d` | **P3/G5+G4** — `n_ops` als `<run_options>`-Attribut (`ThesisRunOptions`-Feld + Parse + Fassaden-Feed), `n_repeats` aus `<repetitions>` | 209/209 · run_options-Parse-Pfad grün |
| `dd0fe177` | **P5 `--validate`** — `validate_profile.hpp` gehoben, `validate_profile_facade(profile_path, os)` | `messung_driver --validate` → „VALIDAT OK: 19 Achsen, 32 Werte, 8 axis_sweeps, 21 sota_series", exit 0, kein Bau · **ce-CI 9597 SUCCESS** |
| `e3adec03` | **Behelfsweg-Löschung — 37 Dateien** (`run_lazy_150`, `test_run_profile_union`, 15 Orphans, **18 `.ps1`**, 2 Keeper-Header-Kommentar-Fixes) | reconfigure grün · Voll-Build grün · 209/209 · **ce-CI 9623 SUCCESS** |
| `e1784e26` | **#18 Slice 1** — `AxisSweepCatalogFull`-Template + **11 neue SweepCataloge** (8→19 Achsen) + `test_axis_sweep_coverage` | **ctest 210/210** · Round-Trip golden==320 |
| `fc855b20` | **#18 Slice 2** — `m3_golden_coverage.profile.xml` (19 axis_sweeps + 21 Lastprofile + 7 Lebewesen × 3 Stufen) | `--validate`: „19 Achsen, 19 axis_sweeps, 21 sota_series — VALIDAT OK" · **ce-CI 9632 SUCCESS** |
| `fa9f31ac` | **T8 Fix B** — `thread_count` label-only (abi_adapter `apply1` aus applied-Zähler raus), `test_e2:99` applied==4, m3v2 `<thread_count>1</thread_count>`, `test_kf1:91` | test_e2 passed · Golden-Roundtrip „ALLE OK, Diff leer" · **ce-CI 9678 FAILED** (siehe D6) |
| `b3224369` | **T8-Nachzug** — `test_d13_dll_runtime_measure` zum T8-Phantom-Guard (`applied == 0`) | Test passed · volle ce-Suite CTEST-RC=0 |
| `895546f4` | **Ontologie T5/T16/T2** — toter `stride_pattern_tag` raus; `filter_bit_capacity()`/`bits_per_key()` constexpr an alle 4 Filter; T2-Indirektionskosten in reservierten POD-Slot `[2][6]` | Full-Build grün, 186/186 · **ce-CI 9769 FAILED** (nur lint:format) |
| `270c6c8c` | **Format-Fix** `abi_adapter.hpp` (die T2-`r[6]`-Zeile) | **ce-CI 9776 SUCCESS** |

### super (`development`)
| Commit | Inhalt |
|---|---|
| `80f3c14` | P1-Treiber-Edit (FATAL für leeres `COMDARE_LOAD_PROFILE_DIR` entfernt) |
| `ccf960f` | **Cross-Agent-Merge** mit User-`cc4582a` („track development": `.gitmodules branch=development` + README + ce-Bump `c022ce05→22ddf94c`); Gitlink bewusst auf `dd0fe177` gesetzt (sonst kein `validate_profile_facade` → super baut nicht) |
| `46d55d8` + `0eb130e` | P5-Treiber `--validate` + Docs |
| `a708790` | Handover-Docs + Gitlink → `e3adec03` |
| `c8ec3c2` / `54ef01f` | **P6** — `e4_opt_in_enabled()` entfernt (E4 = Default), `return e4_overall_rc` nach E4-Block, Legacy nur via `COMDARE_LEGACY_MESSREIHEN=1`; Merge mit Parallel-Agent |
| `5a81a17` | Handover + CI-Trigger-Plan-Backup |
| `c21b9a1` | Session-Ende-Handover `docs/sessions/20260711-SESSION-ENDE-produktions-ci-fix-golden-run-achsen.md` |
| `1f55d67` / `d094487` | CI-Fix REV 13/14 (insteadOf CI_JOB_TOKEN → Deploy-Token) — **beide gescheitert** |
| `ab1fc71` | **CI-Fix REV 15** (`GIT_SUBMODULE_STRATEGY:none` + before_script + extraheader-Reset) — Isolations-Branch `ci-fix-submodule-deploy-token`, **Pipeline 9731 = SUCCESS inkl. `thesis:pdf`**; FF nach development, **Pipeline 9770 = SUCCESS** |
| `bda2383` | Gitlink → `270c6c8c` — **Pipeline 9777 FAILED** (echter Fetch nötig) |
| `468cbc9` | **Forward-Revert** Gitlink → `fc855b20` (development sofort un-rot) |
| `e59ceb9` | **REV 16** (DIAG + 3-Wege-extraheader-Neutralisierung) — Pipeline 9787, DIAG deckte die wahre Ursache auf |
| `38d411f` | **REV 17** — Deploy-Token-URLs direkt in `.gitmodules` (ephemer) — **Pipeline 9791 = SUCCESS, alle Jobs, mit NEUEM ce-Commit** |
| `e855f75` | REV 17 + Gitlink → `270c6c8c` nach development — **Pipeline 9801 = SUCCESS, alle grün inkl. `thesis:pdf`** ← Kern-Abnahme zu A9 |
| `b7364bf` | Ledger-Erweiterung §0-DoD-6 + §11-G + §12-Log (Zielauftrag A10) |
| `3a2d06d` | **#22 `persist:measurements`** (merge-basiert, inert) FF nach development — **Pipeline 9816 = SUCCESS, 13 Jobs, persist korrekt inert** |
| `633dc50` | Ledger §12 Impl-Zyklus-Fortschreibung |
| `955fefe` | Ledger §11-H (Tier/System-Verifikation, 2 buildbare Wiring-Increments) |
| `b717942` | Workflow-Backups in `docs/sessions/backups/` + Ledger §11-H: H-2 aufgelöst |

### Abnahmen / Verifikationen
- **GitFlow bestätigt (A1):** ce `origin/main`=`22ddf94c` ⊂ `origin/development`=`fc855b20` (8 voraus); super `cc4582a` ⊂ `676f37b` (8 voraus). `main` nie angefasst; Promotion bleibt User-Release-Gate.
- **g++-Linux-Vollpilot-Milestone: ERFOLG** — E4 feuert · Workload-Filter=6 ohne env (P1 live) · `working_set_n=4` trotz `COMDARE_WORKLOAD_RECORDS=4096` (G3 live) · `basis_count=320 (N=2)` · `perm.cpp` codegen't · 8× cc1plus · 2 valide `perm.dll` (~230 KB, Compile-Log 0 Fehler) · **323-Zeilen-CSV mit echten Messwerten**.
- **golden-320-Vollmesslauf GESTARTET** (PID 2218234, `setsid` detached, `~/measurements/golden-320-run1/`, m3v2 cap=320, resume-fähig, mehrtägig; 256 perm.dll ccache-beschleunigt; Direktive: **nicht pollen**).
- **Memories geschrieben/aktualisiert:** `feedback_only_one_official_xml_driven_program_no_behelfswege`, `feedback_production_track_full_golden_run_finds_errors`, `feedback_autonomous_measurement_via_ci_job_authorized`, `feedback_ci_gesamtlauf_ist_messung_abgeschaltet_pdf_kompiliert`, `project_mess_ergebnis_rueckschreibung_pipeline_persistiert`, `reference_super_ci_cannot_fetch_new_ce_submodule_commits` (2× korrigiert, final REV 17), Tier/System-Ontologie-Memory. MEMORY.md kompaktiert 19.9→18.5 KB, 111 Zeiger valide.
- **Tasks:** #17 (Produktions-Single-XML-Path), #18 (Coverage), #20 (Ontologie), #21 (CI-Fix), #22 (Rückschreibung), #23 (H-1/H-2).

---

## (d) Fehler + Fixes

| # | Fehler | Ursache / Fix |
|---|---|---|
| D1 | `no type named 'L00' in AxisSweepCatalogFull` | `catalog_static_levels<T>` reflektiert `T::L00..L18` als **Member-Typen**. Fix: Template-Params → `P00..P18` + `using L00 = P00; …` (vom Proof-of-Pattern gefangen, bevor er sich 11× vervielfachte) |
| D2 | `pkill/pgrep -f "comdare-messung-driver"` **killte die eigene Shell** (Exit 144) | Pattern matchte die eigene bash-Kommandozeile. Fix: `pgrep -x` (exact) bzw. kill-by-PID |
| D3 | Pilot/golden-Lauf mehrfach fälschlich als „Prozess weg" gemeldet | (a) pgrep-Pattern-Fehler; (b) stdout **block-gepuffert** bei Datei-Umleitung (`stdbuf -oL` vergessen); (c) `find -name "*.so"` übersah die auf Linux erzeugten **`perm.dll`** (~230 KB, valide .so) |
| D4 | ce-HEAD **detached** → `git push` meldete „Everything up-to-date" | Commits lagen auf detached HEAD, `development` stand noch auf `22ddf94c`. Fix: `development` angehängt → Fast-Forward `22ddf94c..dd0fe177` |
| D5 | Monitor-Bug: `[ "$sha" = "d094487" ]` (7 Zeichen) vs. `d0944875` (8) → Endlos-Warten | direkte Pipeline-Abfrage statt Loop |
| D6 | **ce-Pipeline 9678 (T8) FAILED** — `test_d13_dll_runtime_measure` (#194) asserted `applied_axis_count > 0` | Lokaler Lauf war **gezielt statt voll** (nur Mock-d13 #123). Die CI fing korrekt, dass der Test das Phantom-Verhalten festschrieb. Fix: Test → T8-Phantom-Guard (`applied == 0`, label-only), ce `b3224369`, volle Suite CTEST-RC=0. **Learning: volle Suite, nicht gezielt.** |
| D7 | **ce-Pipeline 9769 FAILED** — nur `lint:format`, `abi_adapter.hpp:1130` (T2-`r[6]`-Zeile) | Datei bei der Ontologie-format-Prüfung übersehen. Fix: Kommentar über die Zeile, `270c6c8c` → 9776 grün. **Learning: ALLE geänderten Dateien in die format-Liste.** |
| D8 | **CI-Fix REV 13/14 (insteadOf, CI_JOB_TOKEN bzw. Deploy-Token) — gescheitert** | Hypothese „Token in URL eingebettet" war falsch |
| D9 | **CI-Fix REV 15/16 (extraheader-Reset) — gescheitert**; 9731/9770 waren **trügerisch grün** | Grün nur, weil das ALTE ce-Commit `fc855b20` im Runner-Build-Dir **gecacht** war (kein echter Fetch). Der Gitlink-Bump auf `270c6c8c` erzwang echten Fetch → 9777 rot. Der DIAG-Dump (REV 16) widerlegte die extraheader-Hypothese: Runner setzt **keinen** Auth-extraheader (nur `X-Gitaly-Correlation-ID`) |
| D10 | **WAHRE Ursache (REV 17):** relative `.gitmodules`-URLs lösen gegen `origin=CI_REPOSITORY_URL` auf → `git submodule update --init` **schreibt diese origin-aufgelöste CI_JOB_TOKEN-URL in `.git/config` und überschreibt jedes vorherige `submodule.<>.url`-Override**. CI_JOB_TOKEN hat kein Cross-Projekt-Klon-Recht (meldete sich als „cd-buildsystem-construct"). | **Fix REV 17:** Deploy-Token-URLs **ephemer direkt in `.gitmodules`** schreiben (dort liest `sync`+`init` sie, statt sie zu überschreiben) + `GIT_SUBMODULE_STRATEGY:none`. Verifiziert: 9791 alle grün mit neuem ce-Commit, 9801 auf development grün |
| D11 | Allowlist-Fehldiagnose (Vorsession) | Alle 3 inbound-Allowlists Admin-verifiziert korrekt; `GIT_STRATEGY=clone` machte es schlimmer (alle 3 Submodule statt nur ce) |
| D12 | super-Pipeline 9815: **0 Jobs / skipped** nach dem #22-Push | GitLab-Push-Dedup-Quirk, **kein** Config-Bruch (`yaml_errors: None`); frische Pipeline 9816 = 13 Jobs, alle grün |
| D13 | `toolchain:probe` failed in 9782, grün in 9791 (gleicher Code) | Runner-Infra-Flake (bekannte ICE-Instabilität); `GIT_STRATEGY:none` → gitlink-unabhängig |
| D14 | Design-Workflow für #22 lieferte **rebase**-Writeback | Verstößt gegen A12. Umgebaut auf merge; lokal bewiesen (`persist_merge_test.sh`: erzwungener non-ff → fetch+merge → push, concurrent-Commit bewahrt, `[skip ci]` gesetzt) |
| D15 | 3 Refute-Agenten des H-2-Workflows: `API Error: Unable to connect to API (ConnectionRefused)`; 3 Assistant-Turns fielen aus | User wiederholte A13 3×; danach normal fortgesetzt |

---

## (e) Offene Fäden am Chunk-Ende

1. **LAUFEND — Deep-Research H-1** (`wknybgga7`, Workflow gestartet Z. 1548): „Ist SystemAxis→E4-Reporting eine echte buildbare Lücke (bauen) ODER ist der 0-Consumers-Phase-6-Vorbau intentional/korrekt (nicht bauen, wie H-2)?" Kernfrage: sind CLU/LATENCY_MEAN/THROUGHPUT redundant mit bestehenden `measurements.csv`-Spalten? **Notification eingegangen (Z. 1552–1557), Ergebnis im Chunk NICHT mehr verarbeitet.** Scout-Vorbefund: E4-Kette (`result_ingest`/`host_measure_loop`/`node_value_measurement`) nutzt noch nichts von SystemAxis; im Messung-AUS-Pfad ist `observer_real=false` → mess-gated.
2. **LAUFEND — golden-320-Lokallauf** (PID 2218234, ~4,5 h, 99 % CPU, detached, mehrtägig, resume-fähig). **Nicht pollen.** Phantom-limitiert (thread_count vor dem T8-Fix, hw_prefetcher MSR-only) → Pipeline-Validierung, keine finale Datenbasis.
3. **OFFENE USER-ENTSCHEIDUNG ① — Cluster-Mess-Infra bereit?** `perf_event_open`-PMC + MSR 0x1A4 + Schreib-Ziel (NAS/MinIO) auf `prod-baremetal-prod1`. Bei „ja": inerter opt-in Mess-CI-Job (golden-320, `tags:[baremetal]`, `timeout:0`) bauen + triggern → entsperrt H-1, #11, HYBRID, IPC/PMC, echte CSV für #22.
4. **OFFENE USER-ENTSCHEIDUNG ② — #22 scharfschalten (G-b):** `write_repository`-Project-Access-Token (masked+protected) als `COMDARE_WRITEBACK_USER`/`COMDARE_WRITEBACK_TOKEN` + `COMDARE_PERSIST_MEASUREMENTS=true`. Plus **Lauf-Frequenz**: jeder development-Lauf (einfachst, git-Bloat) vs. nur echte Mess-Läufe (Empfehlung des Assistenten).
5. **OFFENE USER-ENTSCHEIDUNG ③ — H-1 jetzt bauen** (vorerst leere CSV-Spalten = verfrühte Schema-Änderung an der thesis-konsumierten `measurements.csv`) **oder** als mess-gated Folge-Increment stehen lassen.
6. **#22 Phase 2** — Parallel-Schreiben nach `backup1.comdare.de/Cluster_NFS/cache-engine-experiment` mit gleichen datierten Ordnern (Ledger-notiert, nicht begonnen).
7. **P6-Rest** — V38.B/V38.C-Legacy-Microbench-Gating (`main.cpp:280-475`, skippen heute harmlos); vollständige Legacy-Entfernung erst nach golden-320-Subsumtionsprüfung.
8. **Gated-Tasks:** #3/#5/#8/#9 (Design-/Extern-GO, Mess-Signal-Routing/NUMA — **nicht ändern, solange ein Lauf den Mess-Code nutzt**), #11 Messkurven-Typsystem (#156-DATA-gated), #17 (auf golden-Lauf), FILL_BUFFER_OCCUPANCY (Design-GO: Proxy-Quelle oder Regime-Reklassifikation), Graph-Gattung + Container-Genera-Messung (Design-GO; adversarial als Phantom-Gaps klassifiziert), HYBRID-Heuristik-Systemachse (= eigentliches Diplomarbeits-Ziel, #156-DATA-gated), IPC_CPI (privilegierter Cluster-PMC + POD-Feld-Append).
9. **`development → main`-Promotion** bleibt explizites User-Release-Gate (Frage 2× gestellt, unbeantwortet).
10. **AP-H2-12/13** (Thesis-Quellen-Abgleich) — Text-Agent-Domäne, nicht Impl.
11. **Ungeklärter Hook-Vorwurf:** eine „§13-Goal-V3-Sektion" im Ledger sei nicht erstellt/konsolidiert worden (Assistant verankerte stattdessen §0-DoD-6, §11-G, §11-H, §12-Log).
12. **super-`M Code/external/comdare-cache-engine`** — erwarteter Gitlink-Lag-Zustand; nach REV 17 + `e855f75` steht der Gitlink auf `270c6c8c`, ce-HEAD kann davor liegen. Nicht bumpen ohne grüne ce-Pipeline.
13. **Latenter CI-Bug R1** (dokumentiert, nicht gefixt): `analyse:thesis-data:164` nutzt Target-Namen `comdare-messung-driver` statt `messung_driver`.