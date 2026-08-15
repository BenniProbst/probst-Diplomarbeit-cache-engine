# FOLGE-BU Kontext 7 (Session 5a19728e) — 15.08.2026

Additive Sicherung der Workflow-Journale, Task-Outputs und tmp-Design-Dumps
dieses Kontexts (Posten #68, Folge-BU nach der 5-Kontexte-BU bau/bu-workflows-5-kontexte).
Quelle ist die LIVE-Session 5a19728e-f6e1-4736-a246-e3fda9ac35a1; Zaehlstaende sind
Snapshot-Werte vom 15.08. ca. 09:26-09:32 (laufende Workflows erzeugten waehrend der
Sicherung weitere Dateien, siehe Abweichungen).

## Inhalt mit Nennern

- `journale/` — 298 von 298 `wf_*/journal.jsonl` (Stand Kopierzeitpunkt) als
  `<runid>-journal.jsonl`. NUR journal.jsonl; agent-*.jsonl (Live-Tokens) NIE kopiert.
  Erstzaehlung wenige Minuten frueher: 296 Journale auf 298 wf-Verzeichnisse —
  2 Journale entstanden zwischen den Messungen (laufende Workflows).
- `task-outputs.tar.gz` — 1531 von 1531 echten `*.output`-Dateien des Snapshots
  (Listen-Snapshot /tmp 09:27; Test je Datei: regulaere Datei UND kein Symlink).
  Zum Erstzaehlzeitpunkt: 1609 Eintraege gesamt, davon 79 Symlinks auf
  agent-Transkripte — ausgeschlossen. sha256 der tar.gz: siehe
  `task-outputs.tar.gz.sha256`.
- `task-outputs.sha256` — 1531 von 1531 Datei-Hashes.
- `dumps/` — 5 von 5 tmp-Primaerquellen aus /home/comdare/.claude/jobs/5a19728e/tmp/:
  1. `kon64_sammlung.md` (65359 B) — VERBATIM-Sammlung, Primaerquelle KON64-KON73
  2. `design_pmc_grammatik.md` (41749 B) — PMC-Design PM-1..PM-10
  3. `xml_ziel_sektion_vorschlag.md` (23726 B) — Design-Grundlage #57/#48
  4. `lager_minio_explore_RAWDATA.md` (27916 B) — Explore-Rohdaten Lager/MinIO
  5. `komplexfix_design.md` (70184 B)

## Abweichungen / Vorfaelle

1. `ban6hb3h2.output` verschwand ZWISCHEN tar-Erstellung und sha256-Lauf
   (tmp-Rotation, bekannter Hazard aus #45). Die tar.gz traegt die Datei vollstaendig
   (tar rc=0, 1531 Member); ihr Hash wurde aus dem tar-Extrakt rekonstruiert —
   Liste damit 1531/1531 vollstaendig.
2. Zaehlstaende beweglich (live Session): Journale 296->298, Outputs 1530->1531
   zwischen Erst- und Snapshot-Zaehlung. Die BU ist der Snapshot, kein Endstand.

## Secret-Scan (gitleaks 8.30.1, Repo-Config .gitleaks.toml)

Verfahren: Scan-Kopie unter /tmp mit ENTPACKTEN Outputs (der tar.gz-Inhalt ist im
Datei-Scan und in `git log -p` sonst unsichtbar), Koeder-Gegenprobe (glpat-Muster,
20-Zeichen-Suffix aus /dev/urandom, Laengen-Assert als eigenes Kommando, neutrales
Label wegen Koeder-Allowlist-Regex Zeile 46):

- Scan A (Kopie MIT Koeder, 319.29 MB): rc=1, 1555 Funde — Koeder biss.
- Befund-Triage der 1555: 1 Koeder + 2 Koeder-Zitate in Journalen + 1552 gitlab-rrt
  in EINER Datei (`bnpj776mm.output`).
- Scan B (Kopie nach Redaktion, ohne Koeder, 319.28 MB): rc=0 "no leaks found".
- Scan C (echtes BU-Verzeichnis wie committet): rc=0 "no leaks found".

## Redaktionen (4 von 1836 Dateien; Original bleibt an der Quelle auf Platte)

1. `bnpj776mm.output` (im tar): podman-gitleaks-Scanlog vom 06.08., zitiert
   1552 Treffer (390 DISTINKTE Werte) ECHTER `runners_token` (Regel gitlab-rrt)
   aus dem historischen Commit 44820451 (`group_projects.ndjson`, roher API-Dump).
   ECHTE Tokens -> nicht committen -> Muster `GR...`+20 durch `[MASKIERT-gitlab-rrt]`
   ersetzt. Original-sha256 vor Redaktion:
   `922de20f8ada3e9503c932757be442aaff402bee4d51431938448e3ef5760c5d`.
   Einordnung: die HEUTIGE Tree-Fassung der ndjson ist bereits redigiert
   (Commit 5b763179); die Roh-Tokens liegen nur in der Historie (A2-Slot bekannt).
   GitLab 19.1 kennt keine Runner-Registration-Tokens mehr (Funktion entfernt),
   trotzdem gilt: echte Treffer werden nicht committet.
2. `journale/wf_2444c5ec-399-journal.jsonl`: 1 dokumentiertes Koeder-Literal
   (gitlab-pat, Zufallswert aus /dev/urandom einer Push-Waechter-Probe) ->
   `[MASKIERT-KOEDER-glpat]` (Allowlist-Zeilenklasse griff nicht: kein
   Koeder-Wort vor dem Token in derselben Zeile).
3. `journale/wf_aa90e8b0-ab2-journal.jsonl`: 1 dokumentiertes Koeder-Literal
   (github-pat, Zufallswert aus /dev/urandom, im Text explizit als eigener Koeder
   deklariert) -> `[MASKIERT-KOEDER-ghp]` (Allowlist deckt nur das glpat-Muster).

4. `journale/wf_4f8a80f3-c1e-journal.jsonl`: 3 dokumentierte Koeder-Literale
   (gitlab-pat-Muster, Zufallswerte, Prosa der Form "Koeder 'glpat-...' mit
   Laengen-Assert") -> `[MASKIERT-KOEDER-glpat]`. Diese waren fuer gitleaks
   durch die Koeder-Allowlist (Zeile 46 der .gitleaks.toml, Wort Koeder vor dem
   Token) ENTLASTET und daher in Scan A-C unsichtbar; die GitHub Push Protection
   kennt diese Allowlist nicht und blockierte den Push (3 Funde, GH013) —
   deshalb nachtraeglich maskiert und der Branch VOR der GitHub-Annahme als
   EIN sauberer Commit neu gesetzt (der zuvor nur auf origin gepushte
   Erst-Commit 5ec1d787 trug ausschliesslich diese Koeder-Zufallswerte,
   keine echten Secrets).

Ergebnis: 0 echte Secrets im Commit; 390 distinkte historische runners_token
GEMELDET und redigiert; 5 Koeder-Literale (Zufallswerte, keine Credentials)
vorsorglich maskiert.
