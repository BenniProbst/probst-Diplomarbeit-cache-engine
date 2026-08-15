# VERMERK: Thesis-Trailer-Rewrite 2026-08-15 (Task #61, Owner-Frage-3-GO)

Owner-Wortlaut: "Bitte history rewrite, Freigabe" -- Entfernung der
Co-Authored-By-Trailer aus der Historie des Thesis-Repos
(GitLab-Projekt 289, `comdare/research/20260931-overleaf-diplomarbeit`).

## Sicherungen (VOR dem Rewrite erzeugt, `git bundle verify` je "okay,
## records a complete history")

| Datei | Quelle | Inhalt |
|---|---|---|
| `thesis-pre-rewrite-20260815.bundle` | frischer Klon von origin (GitLab 289) | alle 3 GitLab-Branches + 1 Tag |
| `thesis-pre-rewrite-20260815-github.bundle` | frischer Klon von github | alle 4 GitHub-Branches + 2 Tags (deckt den github-only Vorsprung) |

SHA256: siehe `SHA256SUMS.txt` (geprueft mit `sha256sum -c`: beide OK).

## Alte Tip-SHAs (Stand vor dem Force-Push, gemessen 2026-08-15)

### Remote `origin` = https://gitlab.comdare.local/comdare/research/20260931-overleaf-diplomarbeit.git (Projekt 289, Default-Branch: main)

| Ref | alter Tip |
|---|---|
| refs/heads/main | 8197a2c095282b07eecd9481388a98a1fb3fbcd5 |
| refs/heads/development | 16c12c2dc4c59baafe92e1ba231ae564e8b5d63c |
| refs/heads/rescue/gate8-graph-abbildungen-8970465d | 8970465dcc6fff41a1e1ab74606d6dce2a457224 |
| refs/tags/backup-2026-06-29-pre-habich-restruktur (annotiert) | 83a58fa7b841addd63170896126c5fa8b4fae6aa -> Commit a361622014b5acc86740290a1f414a5920204240 |

### Remote `github` = https://github.com/BenniProbst/20260931-overleaf-diplomarbeit.git (Default-Branch: main)

| Ref | alter Tip |
|---|---|
| refs/heads/main | d0b2cc91c737c462c76f791864c3b35927a52bc0 (= GitLab-main + 2 trailerfreie Commits "Genus Interface" 7e5b093, "Vertragsdetails des Messsystems" d0b2cc9) |
| refs/heads/development | 16c12c2dc4c59baafe92e1ba231ae564e8b5d63c |
| refs/heads/overleaf-2026-06-22-1726 | 66674788a5bdcd304b1318818d57ef0bd7af35b1 (Ancestor von main) |
| refs/heads/rescue/gate8-graph-abbildungen-8970465d | 8970465dcc6fff41a1e1ab74606d6dce2a457224 |
| refs/tags/backup-2026-06-29-pre-habich-restruktur (annotiert) | 83a58fa7b841addd63170896126c5fa8b4fae6aa -> a361622014b5acc86740290a1f414a5920204240 |
| refs/tags/backup-2026-07-10-pre-h2 (lightweight) | 9f2546789a434b3af1dc68fac843c9c69d169d6b (Ancestor von main) |

## Trailer-Bestand vorher (gemessen)

- origin/main: 360 Commits gesamt; 97 Zeilen `^Co-Authored-By:`;
  98 Commits enthalten den String (97 Zeilenanfang + 1 Mid-Line).
- Alle Refs (beide Remotes): 372 Commits gesamt (GitLab-Seite 370 + 2
  github-only); 98 Zeilen `^Co-Authored-By:`; 99 Commits enthalten den
  String.
- NICHT Auftragsteil (gezaehlt, nicht entfernt): 1 Mid-Line-Vorkommen
  in Commit d5738a52a0731b61193eba6a1068185795f1cb5e ("...NICHT nach
  Overleaf gepusht (User-Entscheid ausstehend). Co-Authored-By: Claude
  Opus 4.8 ..."); 1 Subject-Erwaehnung "Claude" (Session-Backup
  2026-07-02: Migration auf neuen Claude-Account/Maschine);
  "Generated with": 0 Zeilen.

## Verfahren

`git-filter-repo --message-callback`, entfernt bytesweise EXAKT die
Zeilen (samt Newline), die mit `Co-Authored-By:` beginnen. Je Remote
ein eigener frischer Klon (GitHub-main ist divergent); Determinismus
der geteilten Historie wird ueber Gleichheit der commit-maps bewiesen.
Arbeitsklone (Zweitsicherung mit alten Objekten, bis Lead-Commit NICHT
loeschen): `/home/comdare/.claude/jobs/5a19728e/tmp/thesis-rewrite/`
und `.../thesis-rewrite-github/`.

## Ergebnis (nach Rewrite + Force-Push, alles literal verifiziert)

Zuordnung alter Tip -> neuer Tip (deterministisch, beide commit-maps
identisch fuer die geteilte Historie):

| Ref | alt | neu |
|---|---|---|
| main (GitLab) | 8197a2c095282b07eecd9481388a98a1fb3fbcd5 | 72602d884ce7bc3462ca309739218e3c3b6aab49 |
| development (beide) | 16c12c2dc4c59baafe92e1ba231ae564e8b5d63c | 26f88a0762ac41a04eb3124de565ab7c5778674d |
| rescue/gate8-graph-abbildungen-8970465d (beide) | 8970465dcc6fff41a1e1ab74606d6dce2a457224 | 52c405d0d44f26ecb4aedbd4b471ecf2b5ad1fb6 |
| main (GitHub) | d0b2cc91c737c462c76f791864c3b35927a52bc0 | d2f51ca68cf2d199c7e2e3cc2f8ab82d3fecc670 |
| overleaf-2026-06-22-1726 (GitHub) | 66674788a5bdcd304b1318818d57ef0bd7af35b1 | 9706e78dcb20d7aa45965bab054c2e9ab5092dc4 |
| Tag backup-2026-06-29-pre-habich-restruktur | 83a58fa7 -> a3616220 | a8a6a5d88ee632b6215ab18654feb23782664b59 -> adc6b6b32230f767407590c6891cb44694b9ed0d |
| Tag backup-2026-07-10-pre-h2 (GitHub) | 9f2546789a434b3af1dc68fac843c9c69d169d6b | 6e63d24ddb37fa1ad138b26a0b37669587f00a58 |

Beweise: `^Co-Authored-By:` ueber alle Refs = 0 (vorher 98);
Commit-Zahlen unveraendert (370 GitLab-Seite / 372 GitHub-Seite);
`git --no-replace-objects diff --exit-code --stat alt neu` fuer alle
7 Ref-Paare LEER (rc=0) -> Trees byteidentisch. Verbleibend wie
beauftragt gemeldet, nicht entfernt: 1 Mid-Line-Vorkommen (Commit alt
d5738a52, Text im Fliesstext), 1 Subject-Erwaehnung "Claude".
CI 289 nach Push: Pipelines 15876 (main), 15877 (development),
15878 (rescue) alle "success". Protected-Branch main: allow_force_push
temporaer true, danach exakt auf vorher zurueckgesetzt (40/40, false).

OFFEN (Owner/Lead-Entscheid): Nicht-Standard-Ref `refs/rescue/w3-thesis-c`
= b1ec8379f0b8a1f60fb79cba4e629c78fc67b3d3 liegt auf BEIDEN Remotes
ausserhalb heads/tags (Seitenlinie 02.08., 337 Commits, 95 Trailer-
Zeilen). Von Klonen/Bundles/Rewrite NICHT erfasst; als Rescue-Backup
bewusst NICHT angetastet.

Gitlink-Positionen (super, positionsgetreu gemappt):
- thesis/diplomarbeit: alt eaf7fe8770843f751b8055c0d2e459b9496f7508
  -> neu 9a2d695eb12c5b5aa679fa6cbea9c307a94a36bd
- Code/external/20260931-overleaf-diplomarbeit: alt
  19e159203ac8f6fe18db59d7a1bc71ad6dc00cfa
  -> neu 7a0dd8b763d382eba6ee81dc70749dcc6b44d520

## Absichtlich NICHT committet

Dieses Verzeichnis wird vom Lead zusammen mit dem Gitlink-Commit
committet (Ein-Schreiber-Doktrin).
