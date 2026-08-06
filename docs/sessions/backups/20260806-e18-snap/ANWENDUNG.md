# E-18-SNAP -- Compile-Schnappschuss im anhang:forward-Kanal

**Branch:** `b-e18-snap` (ab `origin/development`, Basis `eb3d285a`) -- **kein Push**, ein Commit.

## OWNER-KERN (Ledger frueh-6, VERBATIM)

> "in Zukunft soll die Diplomarbeit einerseits fertig auf den branch gepusht werden, aber
> andererseits wird sie zusaetzlich in einen Ordner an der Wurzel der Messwerte kopiert, samt
> latex compile-export (Benennung nach Datum und Uhrzeit). so laesst sich ein compile
> nachvollziehen."

Umgesetzte ARBEITS-ANNAHME (dokumentiert, unwidersprochen):
`measurement/thesis_compiles/<JJJJMMTT-HHMMSS>/` mit kompiliertem PDF + Compile-Log +
Quellstand-SHA-Datei (289-SHA + 288-SHA + Kanal-Lauf-ID).

## Was gebaut wurde

| Datei | Ziel | Art |
|---|---|---|
| `ci/anhang_forward_core.sh` | gleicher Pfad | **im Tree angewandt**, +191 / -1 Zeilen (356 -> 546), Modus 0755 unveraendert |
| `gitlab-ci-delta.patch` | `.gitlab-ci.yml` | **VORSCHLAG, NICHT angewandt** (LEAD-ONLY-HOTSPOT), +49 / -9 Zeilen |
| `fixture/setup.sh` | -- | Fixture-Aufbau, damit die Proben unten reproduzierbar sind |

Die eine entfernte core.sh-Zeile ist `local log="$AF_TMP/pdf_gate.log"` -> `local log="$AF_GATE_LOG"`:
Gate-Log-Pfad wird EINE Quelle, weil E-18-SNAP genau diese Datei als "compile-export" erntet.

### Mechanik in einem Satz

Das PDF-Gate baut die Thesis-PDF im 289-Klon ohnehin schon -- E-18-SNAP **erntet dieses
Bau-Produkt**, statt ein zweites Mal zu kompilieren. Der Kern *legt den Ordner nur an*; in das
super-Repo bringt ihn der **bestehende 288-Writeback** des Job-Blocks (Block 4, heute der
Gitlink-Bump). Genau dafuer ist der Patch-Vorschlag noetig.

Zwei Phasen, und die Reihenfolge ist load-bearing:

* **Phase 1 (ernten, `3c`)** laeuft **vor** `pdf_gate_aufraeumen`. Das Aufraeumen holt getrackte
  Dateien ausserhalb `anhang/` per `git checkout` zurueck -- waere die gebaute PDF getrackt, zeigte
  der Schnappschuss eine **alte** PDF und taeuschte genau die Nachvollziehbarkeit vor, die er
  herstellen soll. Im 289-Stand vom 06.08. ist `diplomarbeit.pdf` per `.gitignore`
  (`diplomarbeit*.pdf`) ignoriert, die frische PDF ueberlebt also *zufaellig* -- auf dieses
  Zufallsglueck baut der Kanal bewusst nicht.
* **Phase 2 (schreiben, `4b`)** laeuft **nach** dem Commit: vorher existiert die 289-SHA nicht, und
  ohne sie ist der Compile nicht nachvollziehbar.

## FUND (load-bearing): `compile.log` waere still verschwunden

Die super-`.gitignore` ignoriert global `*.log` (Zeile 49) und hat -- anders als fuer `*.csv`
(Zeile 43 `!measurement/**/*.csv`) -- **keine** Gegenausnahme fuer `measurement/`. Ein
`compile.log` im Schnappschuss wuerde vom `git add` des Writebacks **stumm weggeworfen**; der
Ordner kaeme ohne sein Kernstueck an, und zwar ohne jede Fehlermeldung.

Am Objekt gegengeprueft (echte `.gitignore`, echter `git add`):

```
GESTAGT:   measurement/thesis_compiles/20260806-084009/QUELLSTAND.txt
GESTAGT:   measurement/thesis_compiles/20260806-084009/compile-export.txt
GESTAGT:   measurement/thesis_compiles/20260806-084009/diplomarbeit.pdf
IGNORIERT: !! measurement/thesis_compiles/20260806-084009/compile.log
```

**Gewaehlt:** der latex-compile-export heisst `compile-export.txt` (Owner-Vokabular), Inhalt
unveraendert der volle `latexmk`/`pdflatex`-Lauf. Damit ist der Schnappschuss **ohne**
`.gitignore`-Aenderung trackbar.

**Alternative (Entscheid Lead):** `!measurement/**/*.log` analog zur CSV-Zeile ergaenzen und die
Datei `compile.log` nennen. Das beruehrt eine repo-weite Ignore-Regel und lag ausserhalb des
Commit-Scopes dieses Pakets ("core.sh + Backup-Verzeichnis"), darum nicht getan.

## Patch anwenden

```
SUPER=<eigener super-Worktree ab development>
git -C "$SUPER" apply -p1 docs/sessions/backups/20260806-e18-snap/gitlab-ci-delta.patch
```

`git apply --check -p1` gegen `eb3d285a` ist literal **RC=0**. Basis-Blob der Datei:
`3e0f7203b23ec4d5f6500e9e6a4707483f68562d`.

Der Patch beruehrt **nur** `anhang:forward` Block (4) plus drei Kommentar-Stellen, die sonst
unwahr wuerden (Schwester-Kanal-Kopf und Merge-Retry-Kommentar behaupteten "disjunkte Pfade:
measurement/ vs. Gitlink" -- jetzt schreibt auch dieser Job nach `measurement/`, allerdings in den
disjunkten Unterbaum `thesis_compiles/`). Inhaltlich:

1. `SNAP_PENDING` wird ermittelt; der Frueh-Abbruch greift nur noch, wenn **Gitlink unveraendert
   UND kein neuer Schnappschuss**. Ohne das ginge ein frischer Compile-Beleg still verloren,
   sobald 289 sich einmal nicht bewegt.
2. Nach `checkout -B` wird `measurement/thesis_compiles` mitgestagt (untracked `measurement/`
   ueberlebt das `checkout -B` -- gleiche Mechanik wie bei `persist:measurements`).
3. Der Gitlink-Bump wird konditional (nur bei echter Aenderung); `git diff --cached --quiet`
   bleibt die eine Leer-Commit-Wache fuer beide Richtungen.

**Unberuehrt:** das INERT-Gate `COMDARE_ANHANG_FORWARD`, beide `rules`-Eintraege, alle
Credential-Bloecke, der Dreifach-Loop-Schutz (`-o ci.skip` + `[skip ci]` + `_bot_ -> never`) und
die AF_PDF_GATE-Semantik. Der YAML-Parse-Vergleich unten zeigt die `rules` byte-identisch.

## Gates (literal)

| Gate | Ergebnis |
|---|---|
| `bash -n ci/anhang_forward_core.sh` | **RC=0** |
| `bash -n` ueber den gepatchten Job-Script-Block (97 Zeilen, aus YAML extrahiert) | **RC=0** |
| `git apply --check -p1` gegen `eb3d285a` | **RC=0**, `49 9 .gitlab-ci.yml` |
| ASCII-Selbstcheck `grep -cP '[^\x00-\x7F]'` core.sh gesamt | **0** |
| ASCII-Selbstcheck ueber den gesamten Patch (inkl. Kontext) | **0** |
| YAML-Parse original vs. gepatcht | beide gruen, 33 Top-Level-Schluessel, `anhang:forward`-Schluessel und `rules` **identisch** |
| `shellcheck` | nicht installiert -- **nicht** geprueft (kein Haken ohne Ausgabe) |

## Proben am Fixture (echte TeX-Toolchain, TeXLive 2026 / latexmk 4.88)

Das Fixture spiegelt 289 in den load-bearing Punkten: EIN Top-Level-Hauptdokument mit
`\documentclass`, `.gitignore`-Regel `diplomarbeit*.pdf`, `anhang/<lang>/tabellen/` als Ziel.

| Probe | Erwartung | Ergebnis |
|---|---|---|
| **A** honest-empty, `COMDARE_ANHANG_FORWARD` ungesetzt | inert: kein Ordner, kein Commit | Exit 0, Schnappschuss-Wurzel **nicht** angelegt, dest-Commits 1 -> 1 |
| **B** Vollauf mit echtem `latexmk` | Schnappschuss mit 3 Dateien | Exit 0, `20260806-083937/` mit `diplomarbeit.pdf` (37511 B) + `compile-export.txt` (40 Zeilen) + `QUELLSTAND.txt` |
| **B'** Wahrheits-Gegenprobe | SHAs muessen echt sein | `thesis_commit_sha` == dest-HEAD `949ef2f9...`; `pdf_sha256` == sha256 der gebauten PDF; `file` sagt `PDF document, version 1.7` |
| **C** Kollision + Additivitaet | Suffix, nichts ueberschrieben | 3 Zeitstempel-Ordner vorbelegt -> neuer Ordner `20260806-084009-**2**`; alle `fremd.txt` und der 1. Schnappschuss sha256-**identisch** vorher/nachher |
| **C'** echter Neu-Compile | PDF Lauf1 != PDF Lauf2 | `ff7a6a00...` vs. `4827e7a8...` -- keine Kopie, echter Bau |
| **D** `AF_PDF_GATE=off` | kein Compile -> kein Schnappschuss, literal begruendet | Ordnerzahl 5 -> 5, Log: *"KEIN Schnappschuss -- das PDF-Gate hat nicht gebaut"*; Kanal committet trotzdem normal weiter |
| **E** PDF-Gate ROT (Regression) | Rollback intakt, kein Schnappschuss | Exit **1**, Ordnerzahl 5 -> 5, dest-Commits 4 -> 4, Arbeitsbaum sauber |
| **F** Writeback unter echter `.gitignore` | `.pdf`/`.txt` gestagt, `.log` geschluckt | s. FUND oben; `SNAP_PENDING=1` korrekt erkannt |

Probe **D** und **E** belegen zusammen die deklarierte Grenze: **ohne Compile kein
Schnappschuss** -- statt eines leeren Ordners gibt es eine literale Begruendung. Die
AF_PDF_GATE-Semantik ist unveraendert; E-18-SNAP erzwingt kein Gate und verschiebt keine
Gate-Grenze, es erntet nur, was das Gate ohnehin baut.

Reproduzieren:

```
bash docs/sessions/backups/20260806-e18-snap/fixture/setup.sh
export PATH="/usr/local/texlive/2026/bin/x86_64-linux:$PATH"
AF_DEST_REPO=/tmp/e18snap-fixture/dest AF_WORK_ROOT=/tmp/e18snap-fixture/work \
AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_NO_PUSH=true \
  ci/anhang_forward_core.sh
```

## Neue ENV-Schalter

| Variable | Default | Wirkung |
|---|---|---|
| `AF_COMPILE_SNAPSHOT` | `true` | Schnappschuss an/aus |
| `AF_SNAPSHOT_ROOT` | `<AF_WORK_ROOT>/<AF_CORPUS_ROOT>/thesis_compiles` | "Wurzel der Messwerte" |

`thesis_compiles/` ist ein **Geschwister** der `measurement/<RUN_TS>/`-Laufordner. Vertraeglich mit
der Korpus-Kaskade (1b), weil deren Laufordner-Auswahl einen Ordner nur nimmt, wenn er
`*.result.csv` enthaelt -- der Schnappschuss legt ausschliesslich `.pdf`/`.txt` ab. **Wer hier je
eine `*.result.csv` ablegt, bricht diese Zusage** (im Code als Kommentar festgehalten).

## Offene Punkte fuer den Lead

1. **Patch landen** -- ohne ihn entsteht der Ordner im CI-Workspace und wird am Pipeline-Ende
   verworfen: kein Datenverlust, aber auch kein Nutzen.
2. **`compile-export.txt` vs. `.gitignore`-Negation** -- Entscheid s. FUND oben.
3. **Ohne TeX-faehigen Runner kein Schnappschuss.** Der Job koppelt `AF_PDF_GATE` an
   `COMDARE_TEXLIVE_AVAILABLE`; ist das nicht `true`, laeuft `auto` und baut nichts. Wer den
   Schnappschuss je CI garantiert haben will, braucht `COMDARE_TEXLIVE_AVAILABLE=true` auf dem
   Runner -- das ist eine **Infra**-Voraussetzung, keine Kanal-Aenderung.
4. **Repo-Wachstum:** jede scharfe Pipeline mit Byte-Delta legt eine ~1-5 MB PDF additiv ab. Unter
   der Nie-loeschen-Doktrin ist das gewollt, sollte aber bewusst quittiert sein.
