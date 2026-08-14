# MANIFEST -- BU Workflow-Rohdaten der letzten 5 Kontexte (Session 5a19728e)

Erstellt: 2026-08-14 ~08:15 lokal. Basis: origin/development a103e518 (= FETCH_HEAD bei Anlage).
Worktree: /home/comdare/wt-super-bu-workflows, Branch: bau/bu-workflows-5-kontexte. KEIN Push (Stufe-3-Regel).
Fenster: mtime >= 2026-08-12 00:00 (additive Untergrenze, letzte 5 Kontexte). T0-Inventar ~08:02, T1 ~08:07.
BU additiv: Originale auf Platte unangetastet; hier nur Kopien. Session-Transkripte + agent-*.jsonl TABU.

## 1. Inventar-Nenner (T0)
- (a) tasks/: 1458 *.output gesamt = 1381 regulaer + 77 Symlinks auf agent-*.jsonl (TABU, 0 kopiert;
  davon 1 im Fenster: agut-wie-wirst-*). Regulaer im Fenster: 387 (67M).
- (b) Journale Hauptpfad: 275 wf_*-Verz., 273 journal.jsonl, davon 45 im Fenster. Gegenprobe Nebenpfade
  (-home-comdare--claude-jobs-5a19728e-tmp*, ...--memory, ...-workflows): nur workflows/scripts, 0 journal.jsonl.
- (c) jobs/5a19728e/tmp: 13745 Dateien, 1073 im Fenster. Benannt: 9 *_voll.md, 4 explore_*.md,
  komplexfix_design.md, welle2_findings_sammelliste.md, regressions-gesamtbild/ (165 = 152 json + 13),
  komplexfix_design_arbeit/ (486 Dateien, 32M), kf_arbeit/ leer. leser_*/abgleich_* liegen real in
  komplexfix_design_arbeit/, nicht in regressions-gesamtbild/ (Gegenprobe gefahren).
- (d) Repo-Bestand a103e518: docs/sessions/backups/ = 2015 Dateien; Anker: 20260813-luecken-und-
  vollstaendigkeit (7 w-JSONs, nicht 8), 20260811-*/alle-journale-20260812.tar.gz (233 Journale).

## 2. Gesichert (dieser Ordner)
- task-outputs/tasks-20260812-20260814-379.tar.gz: 379 *.output, flach, Task-ID im Namen.
  Datei-Liste + sha256 je Datei: task-outputs/LISTE-task-outputs-379.txt (379 Zeilen).
- journale/: 39 Einzeldateien <wf-id>-journal.jsonl (Endstaende; journal.jsonl erlaubt, Praezedenz Repo-Tarball).
- dumps/regressions-quell-jsons-145.tar.gz: 145 w*.json der Welle-2-Sammelrunde.
  Datei-Liste + sha256: dumps/LISTE-regressions-quell-jsons-145.txt (145 Zeilen).
- dumps/komplexfix-design-arbeit/: 24 Dateien (leser_01..12, leser_kern, leser09_part1..7, abgleich_ce/
  super/pausen/flaechen) -- Kerngegenstand leser-/abgleich-Dateien.
- dumps/: explore_rueckfragen, explore_synthese_grundlage, explore_kernaussagen_voll, explore_tief_voll,
  stufe1_result_voll (5 Dateien; nicht im KF-KERN-Satz, nicht in regressions-gesamtbild gespiegelt).
- .gitleaksignore: 1 aktiver Fingerprint (Endzustand), siehe Abschnitt 5.

## 3. Differenzmenge (schon gesichert, hier NICHT erneut)
- 7 Task-Outputs sha256-identisch in 20260813-luecken-und-vollstaendigkeit/: woio8wya0, w4lq4gi7g,
  w1k4xd0g6, w4ffuvkx9, wyurparc3, whfxvxf8q, w9ezc7zw6.
- 4 Journale sha256-identisch im Repo-Tarball alle-journale-20260812.tar.gz: wf_8f39354c-394,
  wf_c665d379-7b8, wf_91263b69-d40, wf_23fc24f2-08a. (wf_82a43408-b34 dort AELTER -> Endstand hier gesichert.)

## 4. Ueberschneidungs-Kandidaten (KF-Landung sichert parallel; hier gelistet statt doppelt committet)
- KF-KERNartefakte: komplexfix_design.md, welle2_findings_sammelliste.md, f1lens/luecken/s7/verify/
  wachen_dump_voll.md, design_g1.md, design_zielstruktur.md, 20260813-PAUSE-3-*.md, 20260814-a25-wachen-fix/.
- Session-Docs (kein BU-Gut per Doktrin): 20260813-PAUSE-2-*.md, 20260813-OWNER-VORLAGE-*.md, 00-INDEX.md,
  00-vorkontext-backups-in-super.txt.
- Interne Ueberschneidung (bewusst, additiv): 30 Fenster-w-Outputs im tasks-Tarball sind byte-identisch
  mit Quell-JSONs im regressions-Tarball (Rohbestand vs. kuratierter Satz; 37 Paare minus 7 Repo-Faelle).

## 5. Secret-Scan-Kette (gitleaks 8.30.1 lokales Binary, dir-Modus, Default-Config-Kanal)
- Grob-grep (Staging ungepackt, 593 Dateien): glpat-{20}, AKIA{16}, ASIA{16}, BEGIN PRIVATE KEY, ghp_{36},
  github_pat_{22}, xox[baprs]-, sk-ant-, AIza{35}, eyJhbGciOi = je 0 Dateien (PRIVATE KEY nach -e-Korrektur,
  rc=1). aws_secret_access_key: 20 Zeilen in 6 Dateien = Prosa ueber die Fallen-Register-Lehre.
- Vollscan UNGEPACKT (deckt Tarball-Inhalte): Koeder glpat-+20 (Laengen-Assert 20 OK vor Lauf, Literal im
  Commit-Text) in Staging-KOPIE -> rc=1 'leaks found: 21'. Echtlauf ohne Koeder -> rc=1 'leaks found: 20'.
- Klassifikation der 20 (12 unique Werte): ALLE Falsch-Positive, 0 echte Secrets, 0 Redaktionen.
- Endzustand (gepackt + MANIFEST): Koeder-Kopie MIT .gitleaksignore -> rc=1 'leaks found: 1' (nur Koeder);
  Echtlauf -> rc=0 'no leaks found'. Finaler Lauf nach MANIFEST-Erstellung wiederholt (Quittung im Commit).
- Koeder-Literale stehen NUR im Commit-Text und Workflow-Return, nicht hier (sonst Selbst-Trigger).

## 6. Entlastungs-Liste (20 Fundstellen, generic-api-key; Datei | Zeile | sha256-Praefix | Klasse)
- dumps/komplexfix-design-arbeit/leser_04.md | Z27 | sha256:28fb0e41386c | len=18 | Prosa (API-Error-Bericht)
- dumps/regressions-quell-jsons/wa91q7g1p.json | Z42 | sha256:e1d1060cb9dc | len=13 | CPU-Feature-Flag
- dumps/regressions-quell-jsons/wu5ujw3xn.json | Z11 | sha256:4e154b3cea5f | len=27 | ceb_key_sha512-Digest (Stempel)
- dumps/regressions-quell-jsons/wu5ujw3xn.json | Z11 | sha256:4e154b3cea5f | len=27 | ceb_key_sha512-Digest (Stempel)
- dumps/regressions-quell-jsons/wu5ujw3xn.json | Z11 | sha256:4e154b3cea5f | len=27 | ceb_key_sha512-Digest (Stempel)
- dumps/regressions-quell-jsons/wu5ujw3xn.json | Z11 | sha256:4e154b3cea5f | len=27 | ceb_key_sha512-Digest (Stempel)
- task-outputs/b81ozfhsc.output | Z1 | sha256:55df80092cc1 | len=16 | Prosa (Review-Kommentar)
- task-outputs/big4hmgvc.output | Z58 | sha256:55df80092cc1 | len=16 | Prosa (Review-Kommentar)
- task-outputs/b88ct44tk.output | Z102 | sha256:db276ab4ad3c | len=23 | Posten-Bezeichner
- task-outputs/boo5pzf40.output | Z1632 | sha256:7f80823f532c | len=128 | ceb_key_sha512-Digest (Stempel)
- task-outputs/boo5pzf40.output | Z2226 | sha256:deebb381198d | len=22 | Posten-Bezeichner
- task-outputs/boo5pzf40.output | Z2361 | sha256:075dcf7cadeb | len=33 | Posten-Bezeichner
- task-outputs/brbjn6ag1.output | Z98 | sha256:462a1deafe71 | len=19 | Posten-Bezeichner
- task-outputs/by1qhjqfg.output | Z836 | sha256:55df80092cc1 | len=16 | Prosa (Review-Kommentar)
- task-outputs/bolaqcici.output | Z300 | sha256:185d31f2c98d | len=13 | Posten-Bezeichner
- task-outputs/beamr2otc.output | Z285 | sha256:7f80823f532c | len=128 | ceb_key_sha512-Digest (Stempel)
- task-outputs/beamr2otc.output | Z402 | sha256:462a1deafe71 | len=19 | Posten-Bezeichner
- task-outputs/bqt2wy9eo.output | Z147 | sha256:185d31f2c98d | len=13 | Posten-Bezeichner
- task-outputs/bqt2wy9eo.output | Z165 | sha256:bf7633eef7eb | len=19 | Posten-Bezeichner
- task-outputs/bqt2wy9eo.output | Z361 | sha256:996dab7a8970 | len=15 | Begriff (Digest-Wort)

## 7. Nicht gesichert (Grund)
- 77 Symlink-.output -> agent-*.jsonl: TABU (Live-Tokens).
- 2 laufende Journale: wf_0d0d78f0-d38 (Komplex-Fix Stufe 2), wf_4f8a80f3-c1e (dieser BU-Workflow) --
  Sicherung nach Abschluss durch Folge-BU.
- erkenntnisse_voll.md (08.08.): ausserhalb Fenster (fruehere Kontexte).
- tmp-Tarball alle-journale-20260812.tar.gz (12.08. 07:59, sha 87eda72b... != Repo 0afefa0f...):
  Zwischenstand; Journale sind append-only, Endstaende hier bzw. im Repo-Tarball gedeckt; Original bleibt.
- komplexfix_design_arbeit Zwischenstaende (dump_*/_lesbar_*/_dump_*/_tmp_*/raw_*/pp_*/sec_*/part*/super_*/
  pruefer_*/sk_*/Skripte + 25 Unterverz.): alle 56 dump-w-IDs durch gesicherte Task-Outputs/Quell-JSONs
  gedeckt (ungedeckt=0, Join gefahren); Derivate des laufenden KF.
- Rotation beobachtet: bdcfpvlum.output zwischen T0 und Kopie rotiert (VERLUST, nicht mehr auffindbar);
  bj305s0gl.output transient (erschien und rotierte binnen Minuten).

## 8. Nenner-Bilanz
- Task-Outputs: 387 (T0) = 379 gesichert + 7 Differenzmenge + 1 Rotationsverlust.
- Journale: 45 Kandidaten = 39 gesichert + 4 Differenzmenge + 2 laufend.
- Quell-JSONs: 152 = 145 gesichert + 7 Differenzmenge.
- Scan: 593 Dateien grob-grep + Vollscan; 20 FP entlastet; 0 redigiert; 0 echte Reste.

## 9. ADDENDUM A2.5-FIX (14.08., Verify-Urteil TRAEGT; Funde F1-F4 + Neufund F5)
- F1 BEHOBEN: kf_arbeit/ war zu T0 (~08:02) NICHT leer -- Race zur Commit-Zeit 08:17:17Z, par.1c
  ('kf_arbeit/ leer') ist damit ueberholt; massgeblich ist dieses Addendum. Nachgesichert:
  kf_arbeit/phase0_explore_messprotokoll.md (4578 B, mtime 2026-08-14T08:02:09,
  sha256 7a7aa1ca70c9ae3ceaa8a2500feea30a5f4a4c884386f17b96c4f727b7e0679c, cmp gegen Quelle rc=0).
  Interim-Snapshot eines Derivats des LAUFENDEN KF wf_0d0d78f0; Endstand kommt per Folge-BU (par.7).
  Quelle auf Platte unangetastet (BU additiv).
- F2 ENTLASTET (gemessen statt angenommen): Der ECHTE lint:secrets-Job faehrt dir-Modus RELATIV
  ('gitleaks dir . -c ./.gitleaks.toml --no-banner --redact'; Cluster-ci-templates/base-pipeline.yml:251-258,
  Klon development@5f9e04b; Projekt-toml schlaegt Basis). generic-api-key ist in der Projekt-toml
  disabled -> der leser_04-FP kann in Stufe 3 nicht feuern. CI-Nachbau ueber den GANZEN Worktree
  (inkl. dieser BU + kf_arbeit-Datei): rc=0 'no leaks found'. Verify-Befund bleibt gueltig fuer
  dir-Scans mit absolutem Root: .gitleaksignore wirkt nur relativ -- fuer den CI-Lauf irrelevant.
- F3 GEMELDET (Alt-Bestand, Infra/Owner-Territorium, dieser Branch fasst NICHTS an): Base-Baum
  a103e518 traegt docs/sessions/backups/20260806-session-transkript-verbatim/
  session-ab-vorletzter-kompaktierung.jsonl (16286813 B, Session-Transkript; Transkript-Tabu-Doktrin
  vom 08.08. ist juenger als der Bestand). Branch-Diff-Gegenprobe: alle Diff-Pfade unter dieser BU
  bzw. .gitleaks.toml, 'transkript' im Diff = 0 Treffer. Rotation/Bereinigung = Infra-Territorium.
- F4 ENTLASTET: par.4-Kandidat '20260814-a25-wachen-fix/' existiert an keinem gemessenen Ort
  (find ueber jobs-tmp + wt-super-landung/docs/sessions, maxdepth 3 = 0 Treffer; Positiv-Gegenprobe
  im selben Aufrufmuster beisst 1/1). Reine Kandidaten-Listung, nichts verloren. Join-Universen
  (38 unique dump-w-IDs eigenes Muster vs. 56 deklariert): BEIDE ungedeckt=0.
- F5 NEU GEFUNDEN + BEHOBEN (Fallen-Klasse): d9ed8642 traegt zwei gitlab-pat-Koeder-LITERALE im
  COMMIT-TEXT (par.5-Praezedenz 'nur im Commit-Text'). Der CI-Job scannt Commit-Messages NICHT
  (dir-Modus), die lokale stdin-Push-Wache (git log -p | gitleaks stdin -c toml) SCHON:
  Echtlauf rc=1 'leaks found: 2' (Fingerprints :gitlab-pat:13 und :gitlab-pat:15, File leer =
  Message-Zeilen; strom-relativ, per .gitleaksignore NICHT stabil pinbar). Entlastung: eng
  geschnittene [[allowlists]]-Zeilen-Klasse in .gitleaks.toml (Wort 'Koeder' vor dem Token in
  derselben Zeile; eigener Commit). Beleg nach Fix: stdin-Koeder OHNE 'Koeder'-Wort beisst weiter
  (rc=1 'leaks found: 1'), Echtlauf rc=0 'no leaks found'. git-Modus (gitleaks git, gleiche toml,
  gleicher Bereich): rc=0 -- Messages nur im stdin-Strom. LEHRE: Koeder-Literale kuenftig AUCH in
  Commit-Texten maskieren.
- Scan-Kette dieses Fixes: Grob-grep 11 Muster ueber Stage (75 Dateien, danach final inkl. Addendum);
  Muster-Selbst-Treffer der par.5-Dokumentation in MANIFEST.md (PRIVATE-KEY-/sk-ant-/eyJ-Prosa je
  1 Datei, aws_secret_access_key 2 Dateien: MANIFEST.md + wf_f6ad95d0-e60-journal.jsonl Prosa) =
  Fallen-Register-Klasse, per gitleaks-Null mit Koeder-Beleg entlastet, UNredigiert (Praezedenz).
  dir-Default-Kanal und CI-Kanal: Koeder rc=1 literal, Echtlauf rc=0 literal. Endgueltige
  Zahlen-Quittungen im Commit-Text des Fix-Commits und im Workflow-Return (Koeder dort maskiert).
