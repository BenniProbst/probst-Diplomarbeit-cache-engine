# PLAN B1/E-18 — LaTeX-Anhang-VORWAERTS-Kanal je CI (Owner-GO abend-5; Sweep-Fund B1)

Stand: 2026-08-05. Planungs-Session READ-ONLY (kein Edit am Objekt, kein Push/Merge — Lead-Sache
nach Dual-Review; Landung nur nach Lebend-Check). Objekt: /home/comdare/wt-b1-e18 (ce,
Branch b1-e18-vorwaerts-kanal, Basis b4110cd0 = Gate 405). super-IST gegengelesen an
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine @ 52f3c988 (development) —
ACHTUNG Zeilen-Drift: ALLE super-Zeilenangaben sind IST-Anker dieses Stands; Umsetzung ankert
AM JOB-NAMEN (D3-Plan-Doktrin, docs/sessions/20260727-PLAN-d3-ci-paket.md:28-29).

---

## 1) E-18-SOLL-DEFINITION (aus dem Korpus erhoben — NICHT geraten; Zitate mit Quelle)

### 1.1 Owner-Dekret (KERN=Gesetz)

- **LEDGER:3554** (super docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md, Sec §68c, 26.07., Owner):
  > "**E-18** = LaTeX-Anhang-VORWAERTS-Kanal je CI (= HAUPT-ZIEL des Gesamt-Systems). Beide
  > [E-04+E-18] sind als eigene Bau-Pakete VOR dem Voll-Bau-4-Trigger einzuplanen."
- **LEDGER:4212** (Vor-Trigger-Checkliste): "B1 E-18 LaTeX-Anhang-VORWAERTS-Kanal je CI bauen
  (benanntes Vor-Trigger-Bau-Paket, Owner: HAUPT-ZIEL; LEDGER:3554 — GROESSTER FUND, fehlte in
  jedem Board)".
- **Owner verbatim nr529** (jsonl:38737; docs/sessions/backups/20260726-wahrheits-anker-voll-
  abgleich-workflow/ergebnisse/09-batch-09-a4821fda.md:126):
  > "Das Generieren der Latex-Anhaenge im Diplomarbeit-Code ist HAUPT-ZIEL des Gesamt-Systems
  > und kombiniert das automatische Erstellen der Ergebnisse in die Diplomarbeit-PDF mit
  > Auswertungsautomatisierung aus der xml-Kette bis zu den fertigen Ergebnissen (Voll-Matrix
  > mit Tabellen, Formeln und Diagrammen der echten Messwerte). Bitte konsolidiere die
  > xml-bis-pdf-Kette gegen die im cache-engine-Tool gemessenen Messwerte der Konfigurationen."
  > sowie: "Zu Frage 1: A wird eingebaut, das schliesst aber B nicht logisch aus (beides
  > umsetzen mit Prioritaet auf A)." und "Zu Frage 4: Option A, Overleaf GO."
- **Owner verbatim nr541** (jsonl:39254; ebd.:170): "Ja B1/B2 auto befuellen bzw. bei jedem CI
  neu setzen".
- **982er-Synthese E-18** (docs/sessions/20260726-SESSION-wahrheits-anker-voll-abgleich-982-
  E01-E26.md:83-90): "persistiert ist nur der Rueckwaerts-Kanal (persist:measurements ->
  measurement/<ts>/). Der VORWAERTS-Kanal (anhang/{de,en}/tabellen/*.tex je CI ins
  Overleaf-Submodul, Projekt 289, eigener Write-Token, Post-measure-Rebuild) fehlt -> PDF-
  Tabellen bleiben stale. [...] Koppelt an D-03." D-03 = Frist-Semantik "erste echte Mess-CSV
  auf NAS; LaTeX/PDF DANACH aus der Auswertung" (Memory project_20260726_chunk_delta, D-03).
- **02.08.-Katalog** (docs/sessions/20260802-KATALOG-offene-strecke-gesamtplan.md:91): "E-18 =
  LaTeX-Anhang-VORWAERTS-Kanal je CI (HAUPT-ZIEL) — CI regeneriert .tex nur als Artefakt; es
  fehlen Push nach anhang/{de,en}/tabellen/, eigenes 289-Write-Token, Post-measure-Rebuild."

### 1.2 SOLL-Kern (kompakt, ableitungsfrei aus 1.1)

Bei JEDEM CI werden die aus den ECHTEN Messwerten regenerierten `anhang/{de,en}/tabellen/*.tex`
automatisch VORWAERTS ins Overleaf-gekoppelte thesis-Submodul (GitLab-Projekt 289,
20260931-overleaf-diplomarbeit) geschrieben (EIGENER Write-Token), der super-Gitlink
nachgezogen und der Thesis-PDF-Rebuild angestossen. Damit ist die E4-Kette CSV->LaTeX->PDF
vorwaerts geschlossen; die PDF-Tabellen sind nie mehr stale. "Beides mit Prio A": Weg A
(honest-empty `\InputIfFileExists`-Wiring) ist GEBAUT (GO-1 12.07., LEDGER:571; INC-7 14.07.,
LEDGER:540); Weg B (Auto-Befuellung/Neu-Setzen je CI) ist der offene E-18-Kern. "Bei jedem CI
neu setzen" heisst: idempotentes Neu-Setzen auch OHNE frische Messung (Quelle = persistierter
measurement/-Korpus); ein Commit entsteht nur bei Byte-Delta.

### 1.3 ABGRENZUNG (was E-18 NICHT ist)

- **E-04** (= B2, ANDERE Welle): CI-Live-Fortschritt + generische Interface-Nachtests je
  Tier-Binary (Marker-Familie v2, [TESTAT]-Kanal, director:1145ff; LEDGER:3554 erster Halbsatz).
  Beruehrt E-18 nicht — E-18 konsumiert nur fertige CSV/.tex, keine Marker.
- **B12-xlsx** (anderes Fenster): xlsx-Default-Writer #46b/A9. E-18 transportiert .tex; das
  xlsx-Format ist NICHT Teil des Kanals.
- **B5 T6-Einsammel-Naht** (eigener Posten): die Grandchild-Mess-CSV (dynamischer
  planer:delegate-Pfad, Stufe-2 stages NUR tier-build+measure, ce
  experiment_plan_director.hpp:1022-1024) erreichen den Parent-/persist-Fluss heute nicht.
  E-18 dockt an der PERSISTIERTEN Ebene an (Parent-Artefakte + measurement/-Korpus); die
  Grandchild-Vorwaerts-Verlaengerung ist deklariertes FOLGE-Paket hinter B5.
- **G8 Anhang-B/E-Prosa** (M-TH-01/02, Overleaf-/Owner-gegatet): Inhalts-Befuellung von
  B_code_structure/E_architecture_decisions ist Owner-Content, KEIN Kanal-Thema.
- **M-CE-18 ce tools/latex_anhang**: tot ("nie aufgerufen, aktive Strecke super
  Code/08_appendix_generator; je-GO-Deprecate", LEDGER:559). Deprecation NICHT in B1 —
  Kandidaten-Liste des Aufraeumpasses fortschreiben (Owner-KERN
  feedback_abschluss_aufraeumpass_deprecated_code_entfernen).

---

## 2) IST-ANDOCKPUNKTE (am Objekt verifiziert)

### 2.1 super (52f3c988, .gitlab-ci.yml, Anker=Job-Name)

- stages :25-36 (persist ist letzte Stage :36).
- `measure:smoke` :649 + `measure:golden-320` :736: regenerieren den Anhang bereits aus
  Live-Messdaten (#24): WIDE-Aggregat = Konkatenation der per-Perm result.csv (:795-801),
  `appendix_generator_cli` -> `measure_out*/appendix/{de,en}/tabellen/*.tex`, Artefakt
  `Code/measure_out*/appendix/**/*.tex` (:720, :813). NUR Artefakt — kein Push (= die Luecke).
- `persist:measurements` :834 (RUECKWAERTS-Kanal, Muster-Spender): INERT-by-default
  (COMDARE_PERSIST_MEASUREMENTS), Write-Token 288 (COMDARE_WRITEBACK_USER/TOKEN, PAT id=54
  write_repository-only, Bot `_bot_`), Loop-Schutz DREIFACH (`push -o ci.skip` + `[skip ci]` +
  rules `_bot_`->never), non-ff-MERGE-Retry-Schleife (:934-956), additiv nach
  `measurement/<RUN_TS>/`.
- `thesis:pdf` :546 (COMDARE_TEXLIVE_AVAILABLE-gegatet, baut aus dem Submodul-Checkout am
  Gitlink) · `trigger:thesis` :276 (Bridge auf Projekt 289 branch **main**, strategy:depend,
  changes-gegated auf thesis-Gitlink).
- `verify:submodules` :294ff: REV-CI-04 prueft Checkout==Gitlink (NICHT Gitlink==289-Tip) —
  ein frischer Gitlink-Bump bricht nichts.
- .gitmodules: `thesis/diplomarbeit` -> `../20260931-overleaf-diplomarbeit.git`, branch
  **development**, update=merge. Gitlink aktuell 29a1700 (== lokaler 289-development-HEAD).
- Rueckschreibe-Korpus: `measurement/20260726-164259-d03-strukt-r-erstbeleg/` mit
  measurements.csv + per_binary/*.result.csv (echte D-03-Erstbeleg-Daten, committet).

### 2.2 Generator + Thesis-Seite

- super `Code/08_appendix_generator/`: CLI `appendix-generator <wide.csv> <out_root>
  [--langs=de,en]` (main_cli.cpp:31-33); schreibt je Sprache `<out_root>/<lang>/tabellen/`:
  12 Kern-.tex + 5 Darstellungs-.tex (seg_attribution/latency_range/latency_ecdf/
  exchange_forest/observer_detail) + axis_inventory.tex (appendix_generator.hpp:137-149);
  Tests + Fixtures unter tests/ (fixtures/cached).
- thesis-Submodul (289, HEAD 29a1700 auf development): `anhang/de/A_measurements.tex` traegt
  die 6 `\InputIfFileExists{anhang/de/tabellen/...}`-Bloecke (:83/:93/:104/:106/:129; EN
  spiegelbildlich) — Weg A KOMPLETT verdrahtet (docs/thesis-anhang-wiring-READY.md ist
  eingeloest). `anhang/de/tabellen/` traegt 18 committete .tex (manueller Altbestand); die 5
  Darstellungs-.tex fehlen dort (honest-empty-Fallback aktiv). 289 hat EIGENE CI (lint +
  thesis-pdf de+en, REV 3) — der Post-measure-Rebuild-Traeger existiert also schon.
- Overleaf-Kopplung: Overleaf synct GitHub **main** (Memory reference_thesis_git_topology_
  remotes_overleaf); 4-Spitzen-Synchronitaet + main-FF = bestehende Lead-/Watcher-Mechanik
  (reference_diplom_finale_linie_identitaet_overleaf, reference_main_ff_watcher_pin_sha).

### 2.3 ce (wt-b1-e18, b4110cd0)

- Mess-Kette (result.csv -> measure_out -> Bestandslog/MinIO) und Planer-Emission
  (profile_facade/planner/experiment_plan_director.hpp) sind fuer E-18 QUELLEN, keine
  Baustellen: der Kanal konsumiert die bereits emittierten CSV/.tex.
- `tools/latex_anhang/` = toter Alt-Parser (M-CE-18, je-GO-Deprecate; s. 1.3).
- Frozen-Vektor 0fe275bd in genau 3 TUs verifiziert: tests/unit/test_m_w12_stamp_bausteine.cpp,
  test_w10_system_cell_values.cpp, test_g3_sha512_index.cpp. abi/ =
  libs/cache_engine/include/cache_engine/abi/.

**KERN-BEFUND: E-18 ist ein super+289-Paket. Der ce-Anteil am E-18-KERN ist NULL Code.**

---

## 3) SOLL-DESIGN des Kanals (neuer super-Job `anhang:forward`)

Ein Job, Stage `persist` (KEINE neue Stage), Muster-Spiegel von persist:measurements:

a) **Quellen-Kaskade (deterministisch):**
   1. Frische Pipeline-Artefakte: `Code/measure_out*/appendix/<lang>/tabellen/*.tex`
      (needs measure:smoke + measure:golden-320, beide optional+artifacts:true).
   2. Sonst Korpus-Regeneration: NEUESTER `measurement/<RUN_TS>/`-Ordner mit
      `**/ *.result.csv` (replace-Semantik = neuester Lauf gewinnt; merge/fulljoin =
      Planer-KERN-Folgearbeit, Memory project_planer_mess_schema_kern...), WIDE-Konkatenation
      (Literal-Spiegel der measure-Jobs :795-801), `cmake --build build --target
      appendix_generator_cli` + `appendix-generator WIDE out --langs=de,en`.
   3. Sonst honest-empty: NO-OP-Testat, exit 0, KEIN Commit (InputIfFileExists haelt die PDF
      gruen — Weg A traegt).
b) **Ziel-Schreiben (289):** frischer Klon von `../20260931-overleaf-diplomarbeit.git` via
   `COMDARE_THESIS_WRITEBACK_USER/TOKEN` auf Branch **development** (= Submodul-Branch;
   main-Nachzug bleibt D-06-/Watcher-Mechanik). NUR Dateien `anhang/<lang>/tabellen/<name>.tex`
   aus dem Generator-Output kopieren (Whitelist = Output-Verzeichnis-Inhalt); NIE loeschen,
   NIE ausserhalb tabellen/ schreiben (Overleaf-Owner-Prosa in kapitel/ disjunkt geschuetzt).
c) **Idempotenz:** `git diff --quiet` im 289-Klon -> "0 Aenderungen -> kein Commit", exit 0.
   Sonst Commit mit Provenance (pipeline-id, RUN_TS/Quelle, super-SHA) und Push OHNE ci.skip —
   die 289-Pipeline (lint+thesis-pdf de+en) IST der Post-measure-Rebuild. 289->288 existiert
   kein Ruecktrigger => kein Loop.
d) **Gitlink-Bump 288:** danach im super-Checkout `thesis/diplomarbeit` auf den neuen 289-SHA
   setzen, Commit + Push nach development mit dem BESTEHENDEN 288-Token
   (COMDARE_WRITEBACK_USER/TOKEN), Loop-Schutz-Spiegel: `-o ci.skip` + `[skip ci]` +
   `_bot_`-rule + non-ff-MERGE-Retry (Literal-Reuse persist:measurements :934-956; Pfade
   Gitlink vs measurement/ disjunkt => mechanisch konfliktfrei).
e) **Aktivierung:** INERT-by-default hinter `COMDARE_ANHANG_FORWARD == "true"` (+ hartes
   Fail-loud, wenn Token-Vars fehlen — Muster persist :869-871). "Jeder CI"-Scharfschaltung =
   spaeterer Flip auf Projekt-Var NACH Lebend-Check (Idempotenz macht sie rausch-frei: Commits
   nur bei neuem Mess-Byte-Stand). Rules zusaetzlich: `_bot_`->never; nur
   `$CI_COMMIT_BRANCH == "development"`.
f) **Kern-Logik als Script:** `ci/anhang_forward_core.sh` (Quellen-Kaskade, WIDE-Aggregat,
   Whitelist-Kopie, Idempotenz-Check; env-parametrisiert SRC/DEST/LANGS, DRY_RUN-Modus ohne
   jeden Netz-/Push-Pfad) — die YAML umhuellt nur Creds+Push. Grund: der Kanal MUSS ohne CI
   und ohne Messung am Fixture beweisbar sein (Abschnitt 5), eine Quelle statt zwei.

---

## 4) AENDERUNGS-PLAN je datei:zeile (ce und super GETRENNT)

### 4.1 super-Anteil — HINWEIS AN DEN LEAD: EIGENER super-Worktree noetig
(z.B. `git -C <super> worktree add /home/comdare/wt-super-b1-e18 -b b1-e18-vorwaerts-kanal-super
development`; **wt-super-w1 und wt-e24 TABU** — Bau-Session. Kollisionsregel: Substanz gewinnt,
W1-Welle laeuft parallel an derselben .gitlab-ci.yml -> am Job-Namen ankern, obenauf mergen.)

- **S1 `.gitlab-ci.yml`** (Anker: NACH Job `persist:measurements` [:834-972], VOR
  `planer:delegate` [:974]): NEU Job `anhang:forward` (Stage persist) nach Design §3, inkl.
  Kommentar-Kopf (E-18/LEDGER:3554-Referenz, INERT-Modell, Loop-Schutz-Begruendung,
  Doku-Wahrheit "289-Push ohne ci.skip = gewollter Rebuild"). ~95-110 Zeilen.
- **S2 `.gitlab-ci.yml:36`** (stages-Kommentar `- persist`): additiv um "+ anhang:forward
  (E-18 Vorwaerts-Kanal, inert)" fortschreiben; ebenso den persist-Block-Kopf :826-833 um den
  Schwester-Kanal ergaenzen (sonst Doku-Luege, D3-Edit-C-Lehre).
- **S3 NEU `ci/anhang_forward_core.sh`** (super ci/ existiert): Kern-Logik nach §3f,
  set -euo pipefail, ASCII-only, Testat-Zeilen mit literalen Zaehlern ("kein Haken ohne
  Ausgabe").
- **S4 docs:** NEU `docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md` (dieses Dossier,
  Doku-Policy neue Session-Docs) + additiver Ledger-Eintrag bei Landung (Lead).
- **S5 INFRA-HANDOUT (E-20-Kanal, §69.5; GATE fuer den Lebend-Check, NICHT fuer die Landung):**
  NEU `Cluster/docs/sessions/2026-08-05-DIPLOM-AN-INFRA-e18-289-thesis-writeback-token.md`
  (+ Push durch Lead, BRING-Pflicht): (i) Project-Access-Token AUF PROJEKT 289
  `writeback-thesis-anhang`, Scope write_repository-ONLY, Rolle Developer, expires ~90 Tage
  (Sicherheits-Spiegel von PAT id=54/288, Memory reference_measurement_writeback_token_288);
  (ii) CI-Vars auf 288: `COMDARE_THESIS_WRITEBACK_USER` (protected) +
  `COMDARE_THESIS_WRITEBACK_TOKEN` (masked+hidden+protected); (iii) 289-Branch-Protection
  pruefen: development muss Developer-Bot-Push erlauben (288-Modell).

### 4.2 ce-Anteil (DIESER Worktree /home/comdare/wt-b1-e18)

- **C0 BEFUND (bindend): KEINE ce-Code-Aenderung.** Kein kuenstlicher Commit; Default =
  Branch bleibt auf b4110cd0. Fingerprint-Neutralitaet damit per Identitaet erfuellt — die
  Dauer-Auflagen werden TROTZDEM literal am Commit-Objekt erbracht (Abschnitt 5, B-4).
- **C1 OPTIONAL (docs-only, golden-neutral, Lead-Entscheid):** additive Notiz im ce-Ledger
  `docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md`: "E-18-Kern liegt
  super-seitig (anhang:forward); ce-Beitrag = 0 Code; tools/latex_anhang bleibt
  je-GO-Deprecate-Kandidat (M-CE-18)". Zweck: E-02-Vier-Ledger-Audit findet die Abgrenzung.
- **C2 EXPLIZIT NICHT in B1:** tools/latex_anhang/{CMakeLists.txt,main.cpp} +
  tests/unit/test_latex_anhang.cpp + tools/CMakeLists.txt-Eintrag deprecaten/entfernen
  (Owner-GO-pflichtig; in die Aufraeumpass-Kandidaten-Liste).
- **C3 FOLGE-PAKET (hinter B5, nicht B1):** Grandchild-Vorwaerts-Verlaengerung — erst wenn die
  T6-Einsammel-Naht die Stufe-2-CSV in Parent/persist holt, lohnt ein Anhang-Hook in der
  Director-Emission (experiment_plan_director.hpp:1022ff). Bis dahin traegt der
  measurement/-Korpus-Zweig (§3a-2) auch den dynamischen Pfad.

### 4.3 thesis-Anteil (289)

- **KEINE Aenderung noetig.** Weg A (InputIfFileExists + tabellen/-Ziel) ist komplett; der
  Kanal befuellt nur. (Owner nr529: "Option A, Overleaf GO" ist bereits vollzogen.)

---

## 5) COMMIT-SCHNITT + TU-/BEWEIS-DESIGN

### 5.1 Commit-Schnitt (KEIN Push/Merge aus dieser Session)

1. super Commit 1: `ci(e18): anhang:forward -- LaTeX-Anhang-Vorwaerts-Kanal je CI
   (inert-by-default) + ci/anhang_forward_core.sh` (S1+S2+S3).
2. super Commit 2: `docs(e18): Plan-Session-Doc + Infra-Handout-Verweis` (S4; Handout selbst =
   eigener Commit im Cluster-Repo, Infra-Kanal).
3. ce: 0 Commits (Default) ODER 1 docs-only Commit (C1) — Lead-Entscheid.

### 5.2 Beweis-Design — MINIMAL-Fixture, OHNE echte Messung (Messung ist USER-GO)

- **B-1 Generator-Beweis (bestehend):** super Code: Target appendix_generator_cli bauen +
  ctest test_08_appendix_generator (fixtures/cached) — Exit 0 literal.
- **B-2 Kanal-Kern-Beweis (neu, lokal Mode A, Herzstueck):** Fixture-Harness im Scratch:
  (i) Quelle = die BEREITS COMMITTETEN echten D-03-Erstbeleg-CSV
  (measurement/20260726-164259-d03-strukt-r-erstbeleg/per_binary/*.result.csv, WIDE-Konkat)
  — keine neue Messung; (ii) appendix-generator -> out/{de,en}/tabellen/*.tex; (iii) Ziel =
  lokales Fixture-Repo (git init; anhang/{de,en}/tabellen/ + 1 Fremd-Datei + 1 kapitel-Datei)
  mit file://-Remote; (iv) `ci/anhang_forward_core.sh` 4 Laeufe: Lauf1 Commit mit N .tex
  (N literal); Lauf2 byte-identische Regeneration -> "0 Aenderungen -> kein Commit"
  (Idempotenz + Generator-Determinismus BYTE-bewiesen — Loop-Rausch-Wache); Lauf3 leere
  Quelle -> NO-OP-Testat; Lauf4 Negativ: Fremd-/kapitel-Datei byte-unberuehrt, kein Loeschen.
  Alle Literale in das Paket-/Doppellauf-Backup.
- **B-3 YAML-/Inertness-Beweis:** .gitlab-ci.yml nach Edit parsebar (yaml.safe_load);
  rules-Beleg: ohne COMDARE_ANHANG_FORWARD existiert der Job NICHT (Muster persist, Praezedenz
  Inert-Check am realen Pipeline-Objekt #10015); `_bot_`-never + development-only zitiert.
- **B-4 ce-DAUER-AUFLAGEN am Commit-Objekt (auch bei 0-Diff PFLICHT, literal):** Doppellauf
  2x seriell mit FRISCHEM Configure, Basis-N live erheben (erwartet 405) — Literale ins
  Backup; golden-CRC + golden-320 3/3; abi/-Diff 0
  (libs/cache_engine/include/cache_engine/abi/); Frozen-Vektor 0fe275bd in GENAU 3 TUs
  (test_m_w12_stamp_bausteine.cpp / test_w10_system_cell_values.cpp / test_g3_sha512_index.cpp);
  XML byte-stabil; cf22 = ECHTES Binary /home/comdare/tools/cf22/usr/bin/clang-format-22 mit
  Datei-Argumenten (nur falls doch C++-Dateien beruehrt; Soll: keine); ASCII-Selbstcheck-grep
  leer; 3-Marker-grep in ZEILENANFANGS-Form 0 (LEDGER:4009-Lehre).
- **B-5 Lebend-Check (NACH Landung; Lead + Infra-Token; NICHT diese Session):** 1 getriggerte
  development-Pipeline mit COMDARE_ANHANG_FORWARD=true -> 289-Commit sichtbar, 289-Pipeline
  gruen (thesis-pdf de+en = Post-measure-Rebuild-Beleg), Gitlink-Bump [skip ci] gelandet,
  KEINE Echo-Pipeline auf 288. ERST DANACH Scharfschaltung "jeder CI" (Projekt-Var-Flip,
  Owner/Lead).

---

## 6) RISIKEN

- **R1 289-Token fehlt (Infra-Gate):** Lebend-Check blockiert bis Infra das Handout (S5)
  umsetzt; Landung selbst bleibt moeglich (Job inert). Fail-loud-Guard verhindert stilles Gruen.
- **R2 Branch-/Overleaf-Naht:** Push-Ziel development (Submodul-Branch) != trigger:thesis-
  Bridge-Ziel main != Overleaf-Sync (GitHub main). Sichtbarkeit im Live-Overleaf erst nach
  main-FF + GitHub-Sync (bestehende D-06-/Watcher-Mechanik). Falls Owner Direkt-Sichtbarkeit
  in Overleaf je CI will: Ziel-Branch-Entscheid an Lead/Owner eskalieren (VERBOSE).
- **R3 Overleaf-Divergenz/Prosa-Kollision:** Overleaf committet auf GitHub main, Owner
  editiert kapitel/de/* — tabellen/-Pfad disjunkt + Whitelist + nie-loeschen + Merge-statt-
  Rebase-Retry => strukturell kollisionsfrei; Restrisiko dokumentiert.
- **R4 Commit-Rauschen/Loop bei nicht-deterministischem Generator-Output:** durch B-2-Lauf2
  BYTE-bewiesen ausgeschlossen, sonst NO-GO fuer die Projekt-Var-Scharfschaltung (Job bleibt
  dann Trigger-gebunden).
- **R5 Race persist:measurements vs anhang:forward auf development:** disjunkte Pfade
  (measurement/ vs Gitlink) + beidseitige non-ff-MERGE-Retry-Schleifen — mechanisch
  konfliktfrei; Retry-Erschoepfung bricht laut ab (kein --force).
- **R6 Gitlink-Bump mit ci.skip feuert trigger:thesis NICHT:** gewollt — der Rebuild laeuft
  ueber die direkte 289-Pipeline (c); im YAML-Kommentar festschreiben (sonst spaetere
  "Warum-kein-Bridge"-Verwirrung).
- **R7 Zeilen-Drift/W1-Parallel-Welle an .gitlab-ci.yml:** Job-Namen-Anker + Substanz-gewinnt-
  Merge obenauf; keine Zeilennummern in Kommentare uebernehmen.
- **R8 Scope-Creep:** E-04/B12/B5/G8/M-CE-18 sind per §1.3 ausgegrenzt; jede Ausweitung =
  neues Paket.
- **R9 Korpus-Schema-Drift:** measurement/-Korpus (result.csv-Header) vs Generator-Erwartung
  koennte bei kuenftigen Spalten-Aenderungen brechen — der Generator ist honest-empty-tolerant
  (n/a-Spalten, :709); B-2 bindet den Beweis an echte committete Daten.
- **R10 289-Protection-Fehlkonfiguration:** Bot-Push auf development scheitert 403 -> Job
  bricht laut (Retry-Schleife erschoepft); Handout S5 enthaelt den Protection-Check explizit.
