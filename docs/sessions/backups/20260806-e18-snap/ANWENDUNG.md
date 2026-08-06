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
| `ci/anhang_forward_core.sh` | gleicher Pfad | **im Tree angewandt**, 356 -> 873 Zeilen, Modus 0755 unveraendert |
| `gitlab-ci-delta.patch` | `.gitlab-ci.yml` | **VORSCHLAG, NICHT angewandt** (LEAD-ONLY-HOTSPOT), +91 / -9 Zeilen |
| `fixture/setup.sh` | -- | Fixture-Aufbau (jetzt mit echten bare-Remotes fuer 289 UND 288) |
| `fixture/proben.sh` | -- | 46 Zusicherungen ueber alle Heilungs-Pfade, mit Gegenproben gegen den Alt-Stand |

Die eine urspruenglich entfernte core.sh-Zeile ist `local log="$AF_TMP/pdf_gate.log"` ->
`local log="$AF_GATE_LOG"`: Gate-Log-Pfad wird EINE Quelle, weil E-18-SNAP genau diese Datei als
"compile-export" erntet.

## Codex-Heilungen (2. Runde, 06.08.)

Der Erstwurf (Commit `bda34e79`) hatte sechs Befunde. Alle sind geheilt; jede Heilung hat unten
eine eigene Probe **mit Gegenprobe gegen den Alt-Stand**.

| Befund | Kern der Heilung |
|---|---|
| **HOCH-1** Beleg hing am Anhang-Byte-Delta | Die Frage ist nicht mehr "gibt es ein Delta?", sondern **"gibt es zum 289-HEAD schon einen Beleg?"** -- gesucht wird `thesis_commit_sha=<HEAD>` in den `QUELLSTAND.txt` unter der Beleg-Wurzel, **lokal UND im REMOTE-Stand** des 288-Branches. Fehlt er, laeuft der Kanal im Modus `nachholen`: Gate bauen, ernten, ablegen -- **ohne** 289-Commit, **ohne** Push. Ein Marker im Workspace war bewusst **keine** Option (der Workspace stirbt mit dem Job); der 289-vs-288-Vergleich ist die kleinste Loesung, die den Abriss ueberlebt. |
| **HOCH-2** Kollisions-Race | Suffix-Wahl prueft je Kandidat **lokal** (`[ -e ]`), **remote** (`git cat-file -e <fetch>:<pfad>`) und nimmt den Ordner per **`mkdir` ohne `-p`** als atomaren Lock; verlorener Lock = naechstes Suffix (Retry-Schleife statt Abbruch). Ohne die Remote-Wache landen zwei Runner derselben Sekunde im **add/add-Merge-Konflikt** des 288-Writebacks -- literal nachgestellt. |
| **HOCH-3** non-FF-Retry dokumentierte divergent | Phase 2 laeuft jetzt **nach dem Push**. Der gelandete **Baum** wird gegen den gebauten geprueft: gleich -> Bau-Produkt gilt; ungleich (Merge-Commit) -> **Re-Ernte** aus dem gemergten Baum; scheitert die, wird **kein** Beleg abgelegt und der Kanal bricht laut ab. |
| **MITTEL-1** errexit-Luecken | In `if ! f`-Funktionen ist `set -e` **aus**. Jedes `mkdir`/`cp`/`sha256`/`>`-Ziel wird einzeln mit `\|\| return 1` geprueft; am Ende steht eine **Vollstaendigkeits-Wache** ueber die 3 Pflichtstuecke. Der Writeback stagt einen Beleg nur, wenn alle drei da und nicht leer sind. |
| **MITTEL-2** `AF_SNAPSHOT_ROOT`-Override | Der Job-Block definiert `SNAP_DIR` **einmal** und reicht denselben Pfad als `AF_SNAPSHOT_ROOT` an den Kern und als Stage-Pfad an den Writeback. |
| **MITTEL-3** Rollback-Loeschpfad | `COPIED_LIST` merkt den Zustand **vor** dem `cp` (`neu` / `getrackt` / `fremd`). Nur `neu` wird geloescht; `fremd` wird aus einer Sicherung **im Original-Inhalt wiederhergestellt**. |

Dazu, weil der Nachhol-Modus es sichtbar macht: die 288-Commit-Botschaft wird aus dem
**gestagten Ist** gebildet (Gitlink allein / Beleg allein / beides) statt pauschal behauptet --
**Commit-Text nie luegen**.

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
* **Phase 2 (schreiben, `4b`/`5b`)** laeuft **nach** dem Commit -- seit HOCH-3 sogar erst **nach dem
  Push**: vorher existiert die 289-SHA nicht, und nach einem Merge-Retry ist die lokale SHA nicht
  mehr die gelandete. Ohne Push (`AF_NO_PUSH=true`) ist der lokale Commit der Endstand, dann
  schreibt Phase 2 direkt dahinter.
* **Phase 3d (nachholen)** ist der Sonderweg ohne Delta: kein Commit, kein Push, nur der fehlende
  Beleg zum bereits gelandeten 289-HEAD.

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

`git apply --check -p1` ist literal **RC=0**, `--numstat` sagt `91 9 .gitlab-ci.yml`. Basis-Blob
der Datei unveraendert `3e0f7203b23ec4d5f6500e9e6a4707483f68562d` -- derselbe in `eb3d285a` wie in
`bda34e79` (beide Commits fassen `.gitlab-ci.yml` NICHT an, LEAD-ONLY-HOTSPOT).

Der Patch beruehrt **nur** `anhang:forward` Block (4) plus drei Kommentar-Stellen, die sonst
unwahr wuerden (Schwester-Kanal-Kopf und Merge-Retry-Kommentar behaupteten "disjunkte Pfade:
measurement/ vs. Gitlink" -- jetzt schreibt auch dieser Job nach `measurement/`, allerdings in den
disjunkten Unterbaum `thesis_compiles/`). Inhaltlich:

1. `SNAP_DIR` wird **einmal vor dem Kern-Aufruf** gesetzt und als `AF_SNAPSHOT_ROOT` an den Kern
   durchgereicht -- eine Quelle fuer beide Seiten (Heilung MITTEL-2). Zusaetzlich geht
   `AF_SNAP_REMOTE_BRANCH="$CI_COMMIT_BRANCH"` mit, damit die Remote-Wache denselben Branch sieht,
   auf den der Writeback schreibt.
2. `SNAP_PENDING` wird ermittelt (`git status --porcelain -uall`); der Frueh-Abbruch greift nur
   noch, wenn **Gitlink unveraendert UND kein neuer Schnappschuss**. Ohne das ginge ein frischer
   Compile-Beleg still verloren, sobald 289 sich einmal nicht bewegt -- genau der Nachhol-Fall.
3. **Vollstaendigkeits-Wache** vor dem Stagen: jeder Ordner mit ausstehender Aenderung muss
   `<haupt>.pdf` + `compile-export.txt` + `QUELLSTAND.txt` tragen, sonst bricht der Job LAUT ab und
   stagt nichts. Bereits committete Belege werden nicht angefasst.
4. Nach `checkout -B` wird `$SNAP_DIR` mitgestagt (untracked `measurement/` ueberlebt das
   `checkout -B` -- gleiche Mechanik wie bei `persist:measurements`).
5. Der Gitlink-Bump wird konditional (nur bei echter Aenderung); `git diff --cached --quiet`
   bleibt die eine Leer-Commit-Wache fuer beide Richtungen.
6. Die **Commit-Botschaft wird aus dem gestagten Ist gebildet** (Gitlink allein / Beleg allein /
   beides) -- der alte Text behauptete in jedem Fall beides.

**Unberuehrt:** das INERT-Gate `COMDARE_ANHANG_FORWARD`, beide `rules`-Eintraege, alle
Credential-Bloecke, der Dreifach-Loop-Schutz (`-o ci.skip` + `[skip ci]` + `_bot_ -> never`) und
die AF_PDF_GATE-Semantik. Der YAML-Parse-Vergleich unten zeigt die `rules` byte-identisch.

## Gates (literal)

| Gate | Ergebnis |
|---|---|
| `bash -n ci/anhang_forward_core.sh` | **RC=0** |
| `bash -n fixture/setup.sh` / `fixture/proben.sh` | **RC=0** / **RC=0** |
| `bash -n` ueber den gepatchten Job-Script-Block (132 Zeilen, aus YAML extrahiert) | **RC=0** (Original: 75 Zeilen, RC=0) |
| `git apply --check -p1` gegen die Basis-YAML aus `bda34e79` | **RC=0**, `91 9 .gitlab-ci.yml` |
| ASCII-Selbstcheck `grep -cP '[^\x00-\x7F]'` core.sh gesamt | **0** |
| ASCII-Selbstcheck ueber den gesamten Patch (inkl. Kontext) | **0** |
| ASCII-Selbstcheck `fixture/*.sh`, `ANWENDUNG.md` | **0** |
| YAML-Parse original vs. gepatcht | beide gruen, **33** Top-Level-Schluessel, einziger geaenderter Job-Schluessel ist `anhang:forward.script`; `rules`/`needs`/`variables` **identisch** |
| `fixture/proben.sh` (46 Zusicherungen, echte TeX-Toolchain) | **RC=0**, *"PROBEN GRUEN: alle Pfade belegt (0 Abweichungen)"* |
| `shellcheck` | nicht installiert -- **nicht** geprueft (kein Haken ohne Ausgabe) |

## Proben am Fixture (echte TeX-Toolchain, TeXLive 2026 / latexmk)

Das Fixture spiegelt **beide** Seiten: 289 mit EINEM Top-Level-Hauptdokument, `.gitignore`-Regel
`diplomarbeit*.pdf` und echtem bare-Remote (Push/non-FF-Merge fahrbar); 288 als Arbeitsklon mit
bare-Remote, Gitlink `thesis/diplomarbeit` und den super-`.gitignore`-Regeln. Ohne echte Remotes
waeren HOCH-1/HOCH-2/HOCH-3 gar nicht beweisbar.

`fixture/proben.sh` faehrt alle Pfade und schliesst mit `PROBEN GRUEN ... (0 Abweichungen)`,
**RC=0**. Wo es geht steht die Gegenprobe gegen den Alt-Stand daneben:

| Pfad | Alt-Stand (Gegenprobe) | Geheilt |
|---|---|---|
| **HOCH-1** Retry nach 289-Push + 288-Crash | *"IDEMPOTENT: 0 Aenderungen -> kein Commit"*, **0** Belege -- dauerhaft verloren | Modus `nachholen`: **1** Beleg, `thesis_commit_sha` == gelandeter 289-HEAD, `modus=nachholen`, 289 bekommt **keinen** neuen Commit |
| **HOCH-1** dritter Lauf | -- | *"Beleg LOKAL vorhanden"* -> echtes NO-OP, kein zweiter Compile |
| **HOCH-1** Beleg nur auf `origin` (Workspace auf aelterem Commit, CI-Normalfall) | -- | *"Beleg im REMOTE-Stand vorhanden"* -> kein Doppel-Compile |
| **HOCH-2** fremder Ordner bereits auf `origin`, lokal unsichtbar, fixer Zeitstempel | waehlt denselben Namen; der 288-Merge liefert literal `CONFLICT (add/add)` -> Writeback-Abbruch, Beleg weg | *"existiert bereits im REMOTE-Stand ... -> naechstes Suffix"*, Ordner `-2` |
| **HOCH-2** Lock verloren (Kandidat entsteht zwischen Pruefung und `mkdir`) | -- | *"mkdir-Lock verloren -> naechstes Suffix"*, Ordner `-2` |
| **HOCH-2** zwei ECHT parallele Laeufe, fixer Zeitstempel, gemeinsame Wurzel | -- | beide Belege existieren (`<TS>` und `<TS>-2`), keiner ueberschrieben |
| **HOCH-3** non-FF-Push (Fremd-Commit mit `\typeout`-Marker) | `thesis_commit_sha` != Branch-Spitze; Marker **nicht** im compile-export -> die PDF gehoert nicht zum gelandeten Stand | *"RE-ERNTE"*; `thesis_commit_sha` == Branch-Spitze; Marker **1x** im geernteten compile-export |
| **MITTEL-1** `cp` des compile-export schlaegt fehl | **RC=0** und ein HALBER Beleg (PDF + QUELLSTAND), dessen `compile_export=`-Zeile eine Datei behauptet, die fehlt | **RC=1**, **0** Dateien abgelegt, kein 289-Commit |
| **MITTEL-2** `AF_SNAPSHOT_ROOT` auf `measurement/eigene_beleg_wurzel` | Beleg **nicht** gestagt (**0** Dateien im Remote), Commit-Text behauptet trotzdem *"+ Compile-Schnappschuss"* | **3** Dateien im 288-Remote; Commit-Text *"Gitlink auf ... + Compile-Schnappschuss (3 Datei(en))"* |
| **patch:76** halber Beleg im Workspace | committet ihn klaglos (`create mode ...`) | **RC=1**, *"NICHTS wird gestagt (kein halber Beleg im Repo)"*, 0 gestagt |
| **Commit-Text** nur Beleg, Gitlink unbewegt | -- | *"Compile-Schnappschuss (3 Datei(en)), Gitlink unveraendert bei ..."* |
| **MITTEL-3** Rollback bei rotem Gate, fremde unversionierte Datei im Zielordner | fremde `T3.tex` **GELOESCHT** | `T3.tex` sha256-**identisch** erhalten, selbst angelegte `T2.tex` entfernt, unbeteiligte `FREMD.txt` unangetastet, RC=1 |
| **Grenze** `AF_PDF_GATE=off` | -- | *"KEIN Schnappschuss -- das PDF-Gate hat nicht gebaut"*, Ordnerzahl unveraendert, Kanal committet normal weiter |
| **Grenze** honest-empty | -- | NO-OP; die Beleg-Wurzel wird **nicht** angelegt |
| **Grenze** Wurzel ausserhalb eines git-Arbeitsbaums | -- | *"liegt in KEINEM git-Arbeitsbaum"* -> literale Degradierung auf lokal + Lock |

Die Grenzen sind **unveraendert**: ohne Compile kein Schnappschuss, statt eines leeren Ordners eine
literale Begruendung. E-18-SNAP erzwingt kein Gate und verschiebt keine Gate-Grenze.

**Offengelegte Hilfsmittel der Proben** (keines beruehrt die gepruefte Logik): ein `date`-Shim
friert nur `date -u +%Y%m%d-%H%M%S` ein (sonst ist eine Kollision nicht erzwingbar); ein
`cp`-Shim laesst nur das Schreiben von `compile-export.txt` scheitern (volle Platte); ein
`git`-Shim schluckt `remote set-url` und uebersetzt `push -o ci.skip`, damit der **literale**
Block (4) des gepatchten Job-Scripts lokal laeuft, ohne dass eine seiner Zeilen geaendert wird.

Reproduzieren:

```
export PATH="/usr/local/texlive/2026/bin/x86_64-linux:$PATH"
bash docs/sessions/backups/20260806-e18-snap/fixture/proben.sh    # alles, RC=0 = gruen

# oder nur ein einzelner Vollauf am Fixture:
bash docs/sessions/backups/20260806-e18-snap/fixture/setup.sh
AF_DEST_REPO=/tmp/e18snap-fixture/dest AF_WORK_ROOT=/tmp/e18snap-fixture/work \
AF_ARTIFACT_ROOTS="Code/measure_out/appendix" AF_PDF_GATE=on AF_NO_PUSH=true \
AF_PROV_SUPER_REF=development ci/anhang_forward_core.sh
```

## Neue ENV-Schalter

| Variable | Default | Wirkung |
|---|---|---|
| `AF_COMPILE_SNAPSHOT` | `true` | Schnappschuss an/aus |
| `AF_SNAPSHOT_ROOT` | `<AF_WORK_ROOT>/<AF_CORPUS_ROOT>/thesis_compiles` | "Wurzel der Messwerte"; MUSS im 288-Arbeitsbaum liegen, sonst kann der Writeback sie nicht committen (der Kanal sagt es literal) |
| `AF_SNAP_REMOTE` | `origin` | Remote fuer die REMOTE-Wache (Suffix- und Nachhol-Entscheidung) |
| `AF_SNAP_REMOTE_BRANCH` | `$AF_PROV_SUPER_REF` | Branch dort; leer/`NA`/fetch rot => Wache **aus**, literal gemeldet, Rueckfall auf lokal + `mkdir`-Lock |

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
   der Nie-loeschen-Doktrin ist das gewollt, sollte aber bewusst quittiert sein. Der Nachhol-Modus
   aendert daran nichts: er springt nur an, wenn zum 289-HEAD noch **gar kein** Beleg existiert.
5. **Nachholung bei rotem Bau ist LAUT.** Findet der Kanal 0 Delta und keinen Beleg, baut aber der
   bereits gelandete 289-HEAD nicht, endet der Job mit **RC=1** und der literalen Aussage, dass
   nichts geaendert wurde. Das ist bewusst (fail-loud statt stilles Gruen), aber es ist eine
   Situation, in der der Kanal rot meldet, ohne selbst etwas falsch gemacht zu haben.
6. **Re-Ernte kostet einen zweiten Compile.** Nur im non-FF-Fall (Merge-Commit) und nur, wenn der
   gelandete Baum vom gebauten abweicht. Der Alternativweg waere Abbruch ohne Beleg -- die Re-Ernte
   liefert stattdessen einen wahren Beleg.
