# G5-DESIGN-FORK-VORLAGE — measurement-all-Migration (#274, §0-V5-G5)

Stand: 2026-07-16 · READ-ONLY-Kartierung · **STOP-Punkt eingehalten: NICHTS entschieden, NICHTS gebaut.**
Zweck: Der User entscheidet **Umfang + Schnitt** der measurement-all-Migration. Diese Datei legt die
Entscheidung entscheidungsreif vor — Optionen + Empfehlung je Fork, aber keine Vorwegnahme.

Pfad-Legende:
- **MEAS** = `/home/comdare/Projekte/Modules/comdare-measurement-all` (Umbrella, GitLab-Projekt-ID 300)
- **SUP** = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`
- **CE** = `SUP/Code/external/comdare-cache-engine`
- **super Code/0X** = `SUP/Code/0X_*` (Mess-/Auswertungs-Stufen der Diplomarbeit)
- **LED** = `SUP/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
- **DOSSIER13** = `SUP/docs/sessions/backups/20260713-g5-facade-fork-dossier/DOSSIER.md` (Vorgänger-Vorlage, F0–F6)

---

## 0. WORUM ES GEHT (Klartext)

§0-V5-G5 nennt ZWEI Richtungen unter einem Dach:

- **5a EXTRAKTION (der INHALT / die Nutzlast).** Die wiederverwendbaren Mess-Teile DER DIPLOMARBEIT
  — sowohl `super Code/0X`-Mess-Stufen als auch `CE measurement/instrumentation` — nach
  `Modules/comdare-measurement-all` zergliedern: als **source-only Template-Module** mit
  **dokumentierten Quellreferenzen (Quell-Repo + SHA + Datum + Kopie-Beleg)**. Seit 2026-07-07 galt 5a
  als „vergessen".
- **5b STRUKTUR (die FORM / der Container).** Das Umbrella in
  `baseline_0-core / _1-instrumentation / _2-workloads` in Einzelmodule je Belang, nach der
  Facade-Konvention (`comdare-baseline_N-<name>/comdare-<zelle>/include/comdare/<ns>/`).

Kurzformel: **5b = WOHIN** (Modul-Grenze / Baseline-Stufe / Facade), **5a = WAS** (welcher
Diplomarbeit-Mess-Teil). Das Gate ist **Umfang** (wie viel jetzt) × **Schnitt** (welcher Teil → welches
Baseline-Modul), gebunden an das Baseline-Layering n→n-1 und die WAS/WIE-Trennung.

### 0.1 KRITISCHE PRÄMISSEN-KORREKTUR (bitte zuerst lesen)

Die G5-Formulierung (LED:138, 2026-07-15) reaktiviert die **stale** Prämisse „metrics-Transfer Schritt 3
VERGESSEN seit 2026-07-07" und zitiert `MEAS/README.md:7`. **Diese Prämisse ist am Ist-Stand WIDERLEGT:**

- **5b ist im Kern bereits REALISIERT.** Es existieren DREI **gefüllte** Zellen (kein Tombstone), je
  eigenes Repo unter derselben Gruppe, source-only INTERFACE-Targets, Facade-Konvention gewahrt.
- **5a ist nur zur HÄLFTE offen.** Alle bisherigen Transfers speisten sich AUSSCHLIESSLICH aus der
  **ce-Monolith-Seite** (Scratch `_ce-scratch-split-20260707` @ `d6d0744a`). Die **super-Seite
  (`Code/0X`-Mess-Stufen)** wurde **noch gar nicht** zergliedert. Der echte offene Rest ist schmal.
- Belege der Korrektur: DOSSIER13 §0 (bereits korrigiert); LED:398 „#18 ist als ‚vergessen' obsolet";
  LED:1129 (Audit F42/F45) „Schritte 0–7 real vollzogen … ‚KEIN Schritt ausgeführt' ist ÜBERHOLT".
  **Stale geblieben ist nur `MEAS/README.md:7`+`:11` (Umbrella-README) — nie nachgezogen.**

Konsequenz für die Vorlage: Der Fork dreht sich **nicht** um „ob überhaupt extrahieren", sondern um
**Schnitt-Tiefe** und **Ziel-Zelle** des schmalen Rests.

---

## 1. IST-ZUSTAND (belegt, datei:zeile)

### 1.1 Ziel-Repo `comdare-measurement-all` (STRANG A)

- Existiert lokal: `MEAS/` · Remote `origin` = `gitlab.comdare.de/comdare/modules/comdare-measurement/comdare-measurement-all.git` (README.md:23) · Projekt-ID 300.
- Umbrella-Branch **development** (up-to-date), **main** existiert, **kein master** → gitflow-sauber. `git status` clean. Nur **2 Umbrella-Commits**: `62cbd48` (Schritt-0-Skelett), `ad8df1f` (Schritt-3 .gitignore).
- Umbrella getrackt: `CMakeLists.txt` (Aggregator, ruft 3 Zellen-Subdirs, Zeilen 18-25), `configure.sh/bat`, `.gitlab-ci.yml`, `.gitattributes`, `LICENSE`, `README.md`, `sessions/20260707-schritt0-anlage.md`, `tests/.gitkeep`, `.gitignore`.
- **`.gitignore` Zeile 2 `/comdare-*/`** → die eingebetteten Zellen-Klone sind vom Umbrella **NICHT** getrackt (Owner-Konvention; Umbrella trackt alles AUSSER Baseline-Zellen-Inhalte).
- Drei Baseline-Stufen als Ordner: `comdare-baseline_0-core/`, `_1-instrumentation/`, `_2-workloads/`. **`baseline_3-analysis` existiert NICHT** (README.md:11: „per F14 VORGESEHEN, leere Baseline = kein Ordner").

### 1.2 Die drei GEFÜLLTEN Zellen (Twin-Abgleich — verhindert Doppel-Extraktion)

| Baseline | Zelle | Lokaler Branch | Inhalt (Header) | Commit(s) | Provenienz |
|---|---|---|---|---|---|
| 0-core | comdare-metrics | development | 7: `IMeasurementObserver`, `MeasurementSubject`, `Metrics`, `LoggingObserver`, `TestObserver`, `latency_hdr_histogram`, `latency_stats` + vendored `hdr_histogram.c`/`vendor/include/hdr/` (CC0) + 13 Tests | `a7c5093`, `7e027d1` | foundation-Transfer (Schritt 3) + HDR aus Scratch `d6d0744a` (Schritt 6); NS `comdare::cache_engine::measurement`→`comdare::metrics`; Target INTERFACE + STATIC `comdare-metrics-hdr` |
| 1-instrumentation | comdare-pmc | **main** | 4: `pmc_source`, `linux_perf_pmc_source`, `windows_pcm_pmc_source`, `pmc_source_factory` + 1 Test | `26ee7dc` | Scratch `d6d0744a`; NS `comdare::cache_engine::builder`→`comdare::pmc`; INTERFACE header-only |
| 2-workloads | comdare-workloads | **main** | `workload_generator` + `dataset/{dataset_akte,dataset_loader}` + `driver/{workload_config,workload_generator,workload_profiles}` + 2 src + 1 Test | `518ac35` | Scratch `d6d0744a`, 3 Quellorte; bewusste Auslassungen `to_abi_descriptor`/`workload_orchestrator`/`load_profile_parser`; Target INTERFACE + STATIC `comdare-workloads-core` |

- **Stale Umbrella-Doku:** `README.md:7-9` + `CMakeLists.txt:18/21/24` + `sessions/20260707-schritt0-anlage.md:7` sagen noch „Transfer folgt in #274 Schritt 3/5/7". Real sind **alle drei** ausgeführt — nur nie nachgezogen.
- **Provenienz-Artefakte** stecken IN den Zell-READMEs (Repo + SHA `d6d0744a` + Datum), **nicht** als separate `REPOS_OVERVIEW.md` (ADDENDUM-3-Muster nur teil-erfüllt).
- **Twin-Bestätigung:** Der 0-core-Header `latency_stats.hpp` nennt im Kommentar (`:4`) als Nachbarn „`welch_t_test.hpp` + `multiple_comparison.hpp` + `result_aggregator.hpp`" — **genau diese Nachbarn wurden NICHT mittransferiert** ⇒ die Lücke ist damit direkt am Twin-Header belegt.

### 1.3 Migrierbare Quell-Teile — der ECHTE offene Rest (STRANG B)

**Bereits transferiert (5 Twin-Familien) — NICHT re-extrahieren, nur konsumieren:**
`pmc_source*`, `dataset_loader`, `hdr_histogram`, `latency_stats`, `workload_generator`.

**Offene, SOURCE-ONLY-SAUBERE Kandidaten (kein Ziel-Zwilling, STL-only, layering-abwärts):**

- **Stats-/Aggregations-Cluster** `CE/libs/cache_engine/builder/commands/` — der HAUPT-GAP. Alle STL-only, interner DAG bleibt im Cluster, referenziert nur `latency_stats`(=0-core):
  - `welch_t_test.hpp` (`welch_t_test():113`) · `mann_whitney_u_test.hpp` (`:51`, Cliff's delta) · `multiple_comparison.hpp` (Holm/BH, `:18-22`) · `workload.hpp` (STL, `:7-10`) · `execution_result.hpp` (`#include "workload.hpp":7`) · `result_aggregator.hpp` (CSV/JSON-Export, `make_execution_result():77`) · `multi_compare.hpp` (`:17-21`) · `drift_detector.hpp` (`latency_stats:26`).
  - Layering: `pmc`-frei, `anatomy`-frei ⇒ landet konsistent in **reservierter baseline_3-analysis** (3→0 abwärts).
- **Mess-PODs (STRITTIG)** `CE/libs/cache_engine/include/cache_engine/measurement/` — self-contained, aber **experiment-formatgebunden**:
  - `measurement_category.hpp` (16er-Taxonom, `kMeasurementCategoryCount=16`) · `measurement_record.hpp` (`alignas(32)` 32-Byte Disk-Dump-POD) · `measure.hpp` (`Measure<Cat,Detail>` constexpr + `AlgoDetail`-Enum mit ART_NODE*/HOT/SURF/PRTART) · `in_memory_measurement_buffer.hpp` + `thread_arena.hpp`.
  - Technisch extrahierbar (rein STL-intern), aber Semantik (16er-Taxonom / 32B-Disk-Format / AlgoDetail) ist **Diplomarbeit-/cache-engine-DEFINITION** ⇒ die Zuordnung ist eine SCHNITT-Entscheidung.
- **super-Seite `Code/0X` (bislang 0% extrahiert):**
  - `Code/01_sample_data_generator/sample_data_generator.cpp` → Kandidat baseline_2-workloads.
  - `Code/02_messung_driver/stats_aggregator.hpp` — EINZIGES mess-nahes super-Stück, aber KONSUMENT (`#include <cache_engine/builder/commands/welch_t_test.hpp>:12`; `compute_stats():66`, `t_critical_95():48`); dupliziert ce-welch + metrics-latency_stats.
  - `Code/02_messung_driver/{measurement_writer.hpp:17, hardware_filter.hpp, plugin_loader.hpp}` — `measurement_writer` ist ABI-gebunden (`module_abi_v1`, Binär-Dump); `hardware_filter`/`plugin_loader` generischer.
  - `Code/03_binary_to_csv/binary_to_csv.hpp:5` (`#include <cache_engine/abi/module_abi_v1.hpp>`, magic `0xC0FFEE02`) → per F14 vorgesehene **baseline_3-analysis**, aber ABI-/Experiment-glue.
  - `Code/04_csv_to_latex` (STL, `:11-18`) + `05_diagram_generator` (`:19`) — generische CSV→LaTeX/tikz-Primitiven, aber Thesis-Schema eingebacken; **mess-FERN** (Darstellung).
  - `Code/09_tex_formatter/tex_formatter.hpp` — VOLL generisch (UTF-8-codepoint-genau, STL, `:18-19`), aber **mess-FERN** (Satz-Tooling).
  - `Code/{06,07,08}` — latexmk-Wrapper / tier-spezifisch / thesis-Facade ⇒ NICHT generisch.

**Bleibt Research (Aufwärts-/Domänen-Verletzung bei naiver Extraktion):**
`system_axis.hpp` (`#include ../../../anatomy/observable_tier.hpp:9` + `builder/pmc_source.hpp:10`; bindet `ComdareTierObserverSnapshot` + `kV3AxisSchema`) · `measurement_axis_registry.hpp` (erbt Anatomie-Kopplung transitiv) · `i_measurement_source.hpp` (`PmcSourceAdapter:136` sitzt ÜBER pmc) · `execution_engine/.../result_aggregator.hpp` (`comdare::experiment`, `module_abi_v1`) · `03`/`07`/`02-writer` (ABI/tier).
**Phantom (nur `.gitkeep`, nichts zu extrahieren):** `advisor_wrapper`, `papi_wrapper`, `perf_wrapper`, `platform_probe`, `run_recorder`, `measurement_matrix`, `in_memory_measurement_buffer` (ce-common-Slots). Einziger un-migrierter ce-Generik-Rest: `CE/libs/cache_engine/builder/measurement/thread_pinning.hpp` (2931 B) → baseline_1-instrumentation.

### 1.4 Doktrin-Constraints (bindend, STRANG C)

- **§9 Metaprog-/Instanziierungs-Doktrin (LED:237/1080):** Matrix 3D (Familien × Baseline-Stufen × Module); Module = **source-only Template-Code**; Template-Metaprog. IN der Matrix erlaubt, NUR an Produkt-ABI-Grenzen verboten. „Research = early Products": die Diplomarbeit konsumiert die Matrix **über eine EIGENE Research-Instanziierungs-Zelle**, nicht über nackte Direkt-Links (supersediert die alte „Research darf direkt konsumieren"-Ableitung).
- **Baseline-Layering n→n-1 „in Stein" (LED:100 V5.7, INV-2):** nur abwärts. Kette: `workloads(b2) → pmc(b1) → metrics(b0)`; `b3-analysis → b2/b1/b0`.
- **Umbrella trackt alles AUSSER Baseline-Zellen-Inhalte;** „leere Baseline = kein Ordner" (LED:576).
- **WAS/WIE-Trennung (DOSSIER13:19):** Diplomarbeit = WAS (Experiment-/Dataset-/Ausgabe-Definition = super Code/0X + F1-XML); CacheEngine = WIE (Framework/Bibliothek: Concepts/Achsen/Permutation/Mess-Instrumentierung). Der 5a-Schnitt MUSS trennen: generische Mess-WIE-Teile → Modul; experiment-/thesis-gebundene WAS-Teile bleiben Research und konsumieren das Modul.
- **Quellreferenz-Pflicht bei jeder Auslagerung:** Repo + SHA + Datum + Kopie-Beleg; Präzedenz-Muster `CE/libs/common/platform/vendor/REPOS_OVERVIEW.md` (Tabelle: Zelle | Quell-Repo | Quell-SHA | Kopiert am | Lizenz | Pattern; „byte-identisch, diff -r==0"; KEIN Submodul, KEIN FetchContent; `comdare::`-Alias + Target-Guards; Update-Prozedur).

---

## 2. DIE ZU ENTSCHEIDENDEN FORKS (Optionen + Empfehlung — NICHTS entschieden)

> Alle Empfehlungen sind Vorschläge zur Beschleunigung der User-Entscheidung, **keine Vorwegnahme**.
> Umsetzung erst nach explizitem User-GO. Vorgänger DOSSIER13 (F0–F6) ist §9-konform und deckt
> Umfang+Schnitt bereits ab — diese Vorlage baut darauf auf und aktualisiert die Prämisse.

### F1 — Umbrella-Doku-Nachzug (stale „Transfer folgt" → DONE)
**Frage:** `MEAS/README.md:7-9` + `CMakeLists.txt:18/21/24` + `sessions/20260707-schritt0-anlage.md:7`
von „Transfer folgt in #274 Schritt 3/5/7" auf DONE-Stand aktualisieren — oder belassen?
- **Opt A:** Jetzt korrigieren (KORRIGIEREN, nicht löschen — Doku-Erhalt-Regel). Kanten-ärmster Schritt.
- **Opt B:** Belassen, bis der 5a-Rest entschieden ist, dann in einem Zug.
- **EMPFEHLUNG:** **Opt A** als erster GO-Increment. Die stale README ist die Wurzel der G5-Fehlprämisse; ihre Korrektur ist risikofrei, berührt keine Zelle, kein CI-Verhalten.

### F2 — Umfang der 5a-Extraktion JETZT vs. deferred (Kern-Fork „wie viel")
**Frage:** Welcher Schnitt-Tiefengrad des offenen Rests wird jetzt gezogen?
- **Opt (i) SCHMAL:** nur der Stats-/Aggregations-Cluster (`welch`, `mann_whitney`, `multiple_comparison`, `workload`, `execution_result`, `result_aggregator`, `multi_compare`, `drift_detector`).
- **Opt (ii) MITTEL:** (i) + Mess-PODs 2c (`measurement_record`/`thread_arena`/`measure`/`measurement_category`/`in_memory_measurement_buffer`).
- **Opt (iii) BREIT:** (ii) + generische Reporting-Primitiven aus `04_csv_to_latex`/`05_diagram_generator`/`09_tex_formatter` + super `01/02`-Generika.
- **Trade-off:** Je weiter, desto mehr **Thesis-Semantik wandert ins Modul** (widerspricht „generischer Mess-Kern"). Je schmaler, desto sauberer, aber mehr Rest-Increments später.
- **EMPFEHLUNG:** **Opt (i) jetzt**, Rest als eigener je-GO-Strang parken. Der Stats-Cluster ist der einzige kanten-freie, Twin-freie, source-only-saubere Block — maximaler Wert bei minimalem Doktrin-Risiko.

### F3 — Ziel-Zelle des Stats-Clusters: neue baseline_3-analysis vs. 0-core-Erweiterung
**Frage:** Wohin landet der Stats-Cluster?
- **Opt A:** Neue **reservierte `baseline_3-analysis`** anlegen (per README/F14 vorgesehen). Erfordert **neues Zell-Remote** ⇒ je-Repo-GO.
- **Opt B:** In **0-core/comdare-metrics** erweitern (neben `latency_stats`). Kein neues Remote.
- **Layering:** erlaubt beides (Cluster referenziert nur STL + `latency_stats`=0-core; als 3-analysis wäre 3→0 abwärts, als 0-core-intern wäre es koplanar).
- **EMPFEHLUNG:** **Opt A (baseline_3-analysis)**. Post-Processing/Statistik ist konzeptionell eine eigene Baseline-Stufe (Analyse konsumiert Metrik/Instrumentierung/Workload); die Vermischung mit 0-core-Primitiven würde die Stufen-Semantik verwässern. Bedingt je-Repo-GO für das neue Remote (siehe F8/F10).

### F4 — Mess-PODs (2c): generisch nach 0-core vs. domänengebunden Research lassen
**Frage:** Sind `measurement_record`(32B)/`measure`/`AlgoDetail`/16er-Taxonom generischer Mess-Kern oder Thesis-Definition?
- **Opt A:** Generisch → 0-core (rein STL-intern, technisch sauber).
- **Opt B:** Domänengebunden Research lassen (32B-Disk-Format + `AlgoDetail` mit ART_NODE/HOT/SURF/PRTART + 16er-Taxonom sind cache-engine-/thesis-DEFINITION = WAS, nicht WIE).
- **EMPFEHLUNG:** **Opt B (Research lassen)**. Das Disk-Format und die Kategorien sind experiment-spezifische WAS-Artefakte; ein generisches Mess-Modul darf sie nicht als „Kern" führen. Falls später doch nötig: nur das **format-neutrale Gerüst** (`thread_arena`) generisch, die format-gebundenen PODs bleiben Research.

### F5 — Reporting-Heimat: `09_tex_formatter` (+ evtl. 04/05) — measurement-all vs. eigene Tooling-Familie
**Frage:** Wo landen generische-aber-mess-FERNE Satz-/Export-Primitiven?
- **Opt A:** In `baseline_3-analysis` als „Export-Generika".
- **Opt B:** Eigene **build-/thesis-tooling-Familie** (nicht measurement-all) — denn `09_tex_formatter` ist Satz-Tooling, nicht Messung.
- **EMPFEHLUNG:** **Opt B / deferred**. `09_tex_formatter` ist voll generisch, aber mess-FERN; es in measurement-all zu ziehen würde die Modul-Semantik überdehnen. Als eigener Strang außerhalb G5 behandeln.

### F6 — Namensdopplung `result_aggregator` (Kollisions-Risiko)
**Frage:** Zwei gleichnamige Header — welcher wandert, welcher bleibt?
- **Fakt:** `builder/commands/result_aggregator.hpp` (STL, extrahierbar) ≠ `execution_engine/.../result_aggregator.hpp` (`comdare::experiment`, `module_abi_v1`, bleibt Experiment).
- **Opt A:** Beim Transfer explizit umbenennen (z. B. `stats_result_aggregator` im Modul), um Verwechslung auszuschließen.
- **Opt B:** Namespace-Trennung genügt (`comdare::analysis` vs. `comdare::experiment`).
- **EMPFEHLUNG:** **Opt B + Klartext-Notiz im Provenienz-Eintrag.** Namespace trennt sauber; ein Rename bricht Twin-Nachvollziehbarkeit. Der Schnitt MUSS die zwei aber explizit dokumentieren.

### F7 — Twin-Politik (Doppel-Extraktion verhindern)
**Frage:** Wie mit den 5 bereits transferierten Familien umgehen?
- **Fakt:** `pmc` / `dataset_loader` / `hdr` / `latency_stats` / `workload_generator` liegen bereits als Zwillinge im Ziel.
- **EMPFEHLUNG (unstrittig):** **NICHT re-extrahieren.** Research künftig auf **Konsum** umstellen (additiv, kein Löschen im Monolith bis Schritt 13). Kein Fork im engeren Sinn — nur als Leitplanke festhalten.

### F8 — Provenienz-Formalisierung (ADDENDUM-3)
**Frage:** Separate Provenienz-Datei je Zelle statt nur README-Absatz?
- **Opt A:** Pro Umbrella eine `REPOS_OVERVIEW.md`-Tabelle (Präzedenz `CE/libs/common/platform/vendor/REPOS_OVERVIEW.md`): Zelle | Quell-Repo | Quell-SHA | Kopiert am | Lizenz | Pattern.
- **Opt B:** Weiter Provenienz-Absatz je Zell-README (heutiger Ist-Stand).
- **EMPFEHLUNG:** **Opt A** ab dem nächsten Increment. Die Tabellenform ist die bindende §9(c)-Referenz und macht künftige Update-Prozeduren (origin/development ziehen → byte-treu neu kopieren → SHA-Spalte updaten → diff-Beweis im Commit) mechanisch nachvollziehbar.

### F9 — workloads Generator-Welten-Konsolidierung (geparkt, README.md:26)
**Frage:** Kern-Generator vs. driver-Generator zusammenführen?
- **Opt A:** Jetzt konsolidieren.
- **Opt B:** Geparkt lassen (bewusster Entscheid der workloads-Zelle).
- **EMPFEHLUNG:** **Opt B (geparkt)**. Berührt keine offene 5a-Lücke; separater Entscheid außerhalb G5.

### F10 — Reihenfolge / Increment-Granularität / Remote-Anlage je-GO
**Frage:** In welcher Reihenfolge, wie granular, welche Remotes?
- **Doktrin:** Je Modul-Split = **eigener Increment** (ctest-grün + je-GO + separates Remote). Neue Remotes (baseline_3-analysis + jede neue Zelle) = **je-Repo-GO** (nie ohne explizite Autorisierung anlegen).
- **Opt A (bottom-up):** README-Fix → baseline_3-analysis mit dem kanten-ärmsten Kandidaten → restlicher Stats-Cluster → optional PODs/Reporting.
- **Opt B (batch):** Alles in einem Schnitt.
- **EMPFEHLUNG:** **Opt A bottom-up, ein Increment pro je-GO.** Jeder Increment lokal grün + beide-Remotes-Batch (Modus a, da GitLab-origin infra-blockiert).

### Branch-Hygiene-Notiz (nur FLAGGEN, keine Aktion, READ-ONLY)
`comdare-pmc` + `comdare-workloads` sind lokal auf **`main`** ausgecheckt, `comdare-metrics` + Umbrella auf **`development`**. Reiner lokaler Checkout-Zustand, **keine Divergenz**, `main` überall Vorfahr. Vor dem nächsten Zell-Commit lokal auf `development` wechseln (gitflow). Keine Remote-Aktion nötig.

---

## 3. TABU- / LAYERING-NACHWEISPLAN (vor jedem Increment abzuhaken)

**Layering-Beweis (n→n-1 in Stein):**
- Stats-Cluster → baseline_3-analysis referenziert nur STL + `latency_stats`(0-core) ⇒ 3→0 abwärts. `pmc`-frei, `anatomy`-frei nachweisen (grep auf `pmc_source`/`observable_tier` = 0 Treffer im Transfer-Set).
- Kein Kandidat mit Aufwärtskante extrahieren: `system_axis`/`measurement_axis_registry`/`i_measurement_source`-Adapter (→ anatomy/pmc) + `execution_engine::result_aggregator` (→ module_abi) + `03`/`07`/`02-writer` bleiben Research — vor Transfer per grep gegen `abi/module_abi_v1`, `observable_tier`, `pmc_source` verifizieren.

**Tabu-Checkliste:**
- Extraktion = **KOPIE**; Forschungs-Monolith / Pipeline **286 UNANGETASTET** bis Schritt 13.
- `golden_fullpilot_320` / ABI-MAJOR==4 / `permutation_axes.xml` / POD 1416+32 / `kV3AxisSchema` / WIDE-Schema **unantastbar**; Auswertungs-Code liest `kV3AxisSchema` nur.
- **Quelle gegen aktives `development` re-verifizieren** (bisher aus Scratch `d6d0744a` extrahiert; Decoy-Pfad-Invariante LED:239/1080).
- **Remote-Anlage nur mit je-Repo-GO** (baseline_3-analysis-Remote + jedes neue Zell-Projekt). GitLab-Migration nur per Transfer/Rename OHNE Löschen.
- **Kein Umbrella-0-Superrepo**; **kein `comdare-cache-engine-all`-Name** (A7-Verbot); **kein `buildsystem.xml`** in Zellen; **kein Python** in Buildchain.
- Doku nie löschen — `MEAS/README.md:7` nur KORRIGIEREN.
- §9-Konsum-Kante: Schritt 13 nur über eigene **Research-Instanziierungs-Zelle**, kein nackter Direkt-Link.
- **Cluster/Runner strikt READ-ONLY;** GitLab-origin infra-blockiert (G1) → Modus a (lokal grün + github, origin/CI batch).
- Provenienz-Pflicht je Transfer: Repo + SHA + Datum + `diff -r == 0`-Beweis im Commit.

---

## 4. GROBE INCREMENT-SKIZZE (NACH GO — nur Ablauf, nicht ausgeführt)

Voraussetzung je Schritt: eigener je-GO, ctest-grün, lokal-doppelt-verifiziert, beide-Remotes-Batch.

1. **INC-0 (kanten-frei, empfohlen zuerst):** `MEAS/README.md:7-9` + `CMakeLists.txt:18/21/24` + session-Note von „Transfer folgt" auf DONE korrigieren (F1/Opt A). Keine Zelle, kein CI-Verhalten berührt.
2. **INC-1:** `baseline_3-analysis` anlegen (F3/Opt A) — **je-Repo-GO für neues Remote** — und mit dem **kanten-ärmsten** Kandidaten befüllen (Vorschlag: Stats-Cluster-Blätter `workload.hpp`/`execution_result.hpp` + `welch_t_test.hpp`). Provenienz als `REPOS_OVERVIEW.md`-Tabelle (F8/Opt A), Quelle gegen `development` re-verifiziert.
3. **INC-2:** restlicher Stats-Cluster (`mann_whitney`, `multiple_comparison`, `result_aggregator`, `multi_compare`, `drift_detector`) additiv; `result_aggregator`-Namensdopplung via Namespace + Provenienz-Notiz (F6/Opt B).
4. **INC-3 (optional, nur bei GO auf F2-Opt ii/iii):** Mess-PODs (F4) bzw. Reporting-Generika (F5) als eigene Increments/Familien.
5. **Schritt 13 (später, §9-gebunden):** Research-Konsum-Umstellung über eigene Instanziierungs-Zelle; Monolith bleibt lebende Quelle bis dahin.

---

*Ende der Vorlage. STOP-Punkt: NICHT entschieden, NICHT gebaut. Umsetzung erst nach User-GO je Fork.*
