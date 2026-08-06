# Workflow-Rohdaten 06.08.2026 -- Agenten-Berichte und Wellen-Journale

Dauerhafte Einlagerung der Workflow-Rohdaten der Session vom 06.08.2026.
Die Daten lagen zuvor ausschliesslich im fluechtigen `/tmp` und waren nicht
versioniert; sie wurden von dort gerettet, auf Geheimnisse geprueft und hier
abgelegt.

## Herkunft

- Quelle: Laufzeit-Verzeichnis der Workflow-Maschinerie (`/tmp`, fluechtig).
- Zwischenstation: `/home/comdare/backups-workflow/20260806-workflow-rohdaten/`.
- Anlass: die `.output`-Dateien tragen die vollstaendigen Agenten-Berichte der
  Session. Ohne Einlagerung waeren sie beim naechsten Neustart verloren und im
  Folgekontext nicht mehr nachlesbar.

## Zeitraum

Der Schwerpunkt liegt auf dem 06.08.2026. Einzelne Berichte zitieren aelteren
Bestand, daher reichen die im Text vorkommenden Datumsangaben vom 21.07.2026
bis zum 06.08.2026; die im Transkript eingebetteten Zeitstempel spannen
2026-07-04T06:44 bis 2026-08-06T20:32.

## Inhalt

### `outputs/` -- 269 Dateien, rund 23 MB

Je Datei das Ergebnis eines Workflow-Laufs: der vollstaendige Bericht des
jeweiligen Agenten. Das ist der eigentliche Erkenntnistraeger dieses Backups.
Der Dateiname ist die Lauf- bzw. Agenten-Kennung. Ein Teil der Dateien enthaelt
zusaetzlich eingebettete Transkript-Zeilen im JSONL-Format.

Eine dieser 269 Dateien ist eine redigierte Fassung, siehe Abschnitt
"Sicherheitsbefund":

- `outputs/bnpj776mm.output.REDACTED`

### `journals/` -- 63 Dateien, rund 1,9 MB, zusammen 257 Zeilen

Je Datei das Ereignis-Journal einer Welle (`wf_<id>.journal.jsonl`), eine
JSON-Zeile je Ereignis. Verteilung ueber alle 63 Journale:

| Ereignistyp | Zeilen |
| --- | --- |
| `started` | 136 |
| `result`  | 121 |
| Summe     | 257 |

Die `result`-Ereignisse tragen den vollstaendigen Agenten-Bericht im Feld
`result` -- die Journale sind also nicht bloss Start-/Ende-Protokolle. Sie
liefern zusaetzlich die Zuordnung Wellen-Kennung (`wf_<id>`) zu Agenten-Kennung
(`agentId`) und damit den Index, ueber den sich eine `.output`-Datei ihrer
Welle zuordnen laesst.

Notiz zur Groesse: die Journale sind mit 1,9 MB nur rund 7,6 Prozent des
Backups; die 23 MB liegen in `outputs/`. Ein Weglassen der Journale wuerde
also kaum Platz sparen, aber den einzigen Wellen-Index kosten. Beide Baeume
werden daher eingelagert.

## Sicherheitspruefung

Werkzeug: `gitleaks` v8.30.1 (Container `docker.io/zricethezav/gitleaks`),
Konfiguration: die repo-eigene `.gitleaks.toml` des Super-Repos.

### Bilanz vor der Bereinigung: 1552 Treffer

| RuleID | Treffer | Dateien | Bewertung |
| --- | --- | --- | --- |
| `gitlab-rrt` | 1552 | 1 | **echter Fund** -- siehe unten |

Alle 1552 Treffer entfielen auf **eine einzige** Datei und **eine einzige**
Regel. Die Erwartung, der Grossteil sei `generic-api-key` auf deutschem
Fliesstext, trifft **nicht** zu: die repo-eigene `.gitleaks.toml` schaltet
`generic-api-key` ausdruecklich ab (`disabledRules = ["generic-api-key"]`),
diese Regel konnte also gar nicht ausloesen.

### Bilanz nach der Bereinigung: 0 Treffer

Mit der repo-eigenen `.gitleaks.toml`: `no leaks found` ueber alle 332 Dateien.

Gegenprobe mit dem vollstaendigen Standard-Regelsatz (also zusaetzlich mit
`generic-api-key`): 2 Treffer, beide Fehlalarm, beide in
`outputs/a0a5982f72e650725.output`, Zeilen 433 und 441, Entropie je 3,52 --
es sind C++-Testnamen. Woertlich der gemeldete Treffer:

> `test_f3_lager_key_provider_iterator, test_lb0_lager_pfad_`

Der Bezeichner enthaelt `key`, erfuellt aber weder Entropie- noch
Struktur-Erwartung eines Schluessels. Kein Handlungsbedarf.

### Weitere Muster: gezielte Gegenprobe

Ueber den gesamten Baum (332 Dateien) mit `/usr/bin/grep -rIlE`:

| Muster | Dateien mit Wert | Befund |
| --- | --- | --- |
| `glpat-<Wert>` | 0 | nur Prosa-Erwaehnungen, siehe unten |
| `glrt-<Wert>` | 0 | nur Prosa |
| `gh[pousr]_<Wert>` | 0 | -- |
| `github_pat_` | 0 | nur Prosa (Trefferzaehlung eines fremden Scans) |
| `PRIVATE-TOKEN` | 0 | nur Prosa (Nennung im Suchmuster eines Pruefberichts) |
| `Authorization: Bearer` | 0 | -- |
| `AKIA<Wert>` | 0 | -- |
| `BEGIN ... PRIVATE KEY` | 0 | nur Prosa (Nennung im Suchmuster) |
| `https://<user>:<wert>@` | 0 | -- |
| `xox[baprs]-` | 0 | -- |

Die Zeichenkette `glpat` kommt 56 mal in 11 Dateien vor -- **ausnahmslos als
Fliesstext**, nie als Wert. Drei Auspraegungen, woertlich:

> `=== CREDENTIAL-SCAN (glpat / token / secret / password / Authorization / PRIVATE-TOKEN / Bearer / ssh-Key / AWS) ===`

> `[glpat Regex](reference_gitlab_pat_format_dots_regex.md)`

> `39 glpat-Treffer in Dateien fremder, teils laufender Agenten`

Auf keinem dieser Vorkommen folgt ein Token-Wert; die strenge Suche nach
`glpat-` mit nachfolgendem Wert liefert 0 Treffer.

## Sicherheitsbefund: 1 Datei mit echten Zugangsdaten (in Quarantaene)

**Betroffen:** `outputs/bnpj776mm.output` (479 544 Bytes, 9318 Zeilen).

**Was:** die Datei ist der woertlich mitgeschriebene Konsolen-Auswurf eines
frueheren `gitleaks`-Laufs ueber das Super-Repo. `gitleaks` gibt zu jedem
Fund die Zeilen `Finding:` und `Secret:` mit dem **Klartextwert** aus. Die
Datei enthielt dadurch **390 verschiedene GitLab-Runner-Registration-Tokens**
im Klartext, verteilt auf 1552 Vorkommen (776 Funde mal zwei Ausgabezeilen).

**Woher:** die Tokens stammen aus zwei GitLab-API-Abzuegen, die am 02.08.2026
im Super-Repo lagen und dort das Feld `runners_token` je Projekt fuehrten:

- `docs/sessions/backups/20260802-e23-suchlauf-belege/e23/projects_all.ndjson` (390 Funde)
- `docs/sessions/backups/20260802-e23-suchlauf-belege/e23/group_projects.ndjson` (386 Funde)

Diese beiden Dateien wurden am 02.08.2026 bereinigt ("gitleaks-rrt-Scrub der
E23-NDJSON, 776 `runners_token` nach [REDACTED], filter-branch aus ungepushter
Serie"). Der heutige Arbeitsbaum und `development` sind token-frei (Gegenprobe:
0 Treffer). Der Vorzustand lebt nur noch in den lokalen Refs
`refs/backup/pre-secret-scrub-20260802` und
`refs/original/refs/heads/development`; der Commit 44820451 ist **kein**
Vorfahr von HEAD.

**Warum das zaehlt:** haette man die Rohdaten ungeprueft eingelagert, waeren
genau die 776 Werte, die der Scrub vom 02.08. aus der Historie entfernt hat,
ueber die Hintertuer des Agenten-Berichts wieder ins Repo gelangt -- diesmal
auf einem Pfad, der zum Push vorgesehen ist.

**Behandlung:**

1. Das Original liegt unter `/home/comdare/backups-workflow/QUARANTAENE/bnpj776mm.output`
   (Modus 600, Verzeichnis 700). Es ist **nicht** eingelagert und wird **nicht**
   versioniert.
2. Eingelagert ist stattdessen `outputs/bnpj776mm.output.REDACTED`: bit-gleich
   bis auf die 1552 ersetzten Token-Werte. Die Ersetzung ist mechanisch und
   nachpruefbar:
   `GR1348941[A-Za-z0-9_-]{20}` nach `GR1348941<<REDACTED-RUNNER-TOKEN>>`.
   Gegenprobe: 1552 Redaktions-Marker, 0 verbliebene Token-Werte.

Der Bericht behaelt so seinen Beweiswert (welcher Lauf, welche Dateien, wie
viele Funde), traegt aber keine Zugangsdaten mehr.

**Offener Punkt fuer den Betrieb:** ob die 390 Runner-Registration-Tokens seit
dem 02.08. rotiert wurden, ist aus diesen Daten nicht ersichtlich. Solange das
nicht belegt ist, sind sie als kompromittiert zu behandeln.

## Reproduktion

Bereinigter Stand, repo-eigene Konfiguration, erwartet `no leaks found`:

```
podman run --rm \
  -v <dieser Ordner>:/scan:ro,Z \
  -v <repo>/.gitleaks.toml:/cfg.toml:ro,Z \
  docker.io/zricethezav/gitleaks:v8.30.1 \
  detect --no-git --source /scan --config /cfg.toml
```

Gegenprobe auf verbliebene Token-Werte, erwartet 0:

```
/usr/bin/grep -rIoE 'GR1348941[A-Za-z0-9_-]{20}' <dieser Ordner> | wc -l
```

## Hinweise

- `.gitignore` des Super-Repos fuehrt `*.log`. Die hier abgelegten Dateien
  tragen die Endungen `.output`, `.REDACTED` und `.jsonl`; `git check-ignore`
  ueber alle 332 Dateien meldet 0 ignorierte Pfade. Es wird nichts verschluckt.
- Die Rohdaten sind Bestand, kein Arbeitsmaterial: nicht bearbeiten, nur lesen.
