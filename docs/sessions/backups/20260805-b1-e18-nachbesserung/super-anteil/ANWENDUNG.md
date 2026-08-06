# super-Anteil B1/E-18 -- Patch-VORSCHLAG (NICHT im super-Tree angewandt)

Diese Session hat **nur den ce-Anteil** am Objekt gebaut (`/home/comdare/wt-b1-e18`). Der
super-Anteil liegt hier als anwendbarer VORSCHLAG; der Lead landet ihn koordiniert in einem
**eigenen** super-Worktree (`wt-super-w1` und `wt-e24` sind TABU).

> **Stand nach der NACHBESSERUNGS-Welle 2026-08-05 (FABLE-B-1..B-4):** hinzugefuegte Zeilen sind
> ASCII-only transliteriert, der PDF-Gate-Geltungsbereich ist als deklarierte Grenze im Kopf
> vermerkt, der core.sh-Header sagt die Rollback-Wahrheit, und die Zahlen unten sind am Objekt
> nachgezaehlt (vorher inkonsistent: Report 162 / ANWENDUNG 160 / real 163).

Basis-Stand, gegen den erstellt und geprueft wurde: `.gitlab-ci.yml` von
`probst-diplomarbeit-cache-engine`. Die Datei ist seit `94f960dd` unbewegt und an den Staenden
`d08f5dde`, `626aee36`, `61548676` und `7d468505` (aktueller development-HEAD, 05.08. abends)
byte-identisch -- `git apply --check` gegen den aktuellen HEAD ist literal gruen (RC=0).

## Inhalt

| Datei hier | Ziel im super-Repo | Art |
|------------|--------------------|-----|
| `gitlab-ci.yml.patch` | `.gitlab-ci.yml` | unified diff, **0 entfernte / 173 hinzugefuegte Zeilen** (rein additiv) |
| `ci/anhang_forward_core.sh` | `ci/anhang_forward_core.sh` | NEUE Datei, 356 Zeilen, Modus 0755 |
| `docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md` | gleicher Pfad | NEUE Datei |
| `Cluster/docs/sessions/2026-08-05-DIPLOM-AN-INFRA-e18-289-thesis-writeback-token.md` | Cluster-Repo, gleicher Pfad | NEUE Datei (eigener Commit im Infra-Repo) |
| `work/.gitlab-ci.yml` | -- | das fertige Ergebnis zum Gegenlesen (1105 -> 1278 Zeilen) |
| `work/.gitlab-ci.yml.orig` | -- | der Ausgangsstand, gegen den gediffed wurde (1105 Zeilen) |
| `work/job_block.yml` | -- | nur der eingefuegte Job-Block, 164 Zeilen (Anker: **Job-Name**, nicht Zeilennummer) |

Zaehl-Aufschluesselung der 173 hinzugefuegten Zeilen: 2 (stages-Kommentar) + 6 (persist-Block-Kopf,
Schwester-Kanal-Hinweis) + 165 (Job-Block inkl. der einen Trenn-Leerzeile davor).

## ASCII-Selbstcheck (HARTE AUFLAGE)

`grep -P "[^\x00-\x7F]"` ueber die **hinzugefuegten** Patch-Zeilen == **0**
(vorher 18 Zeilen: em-dash, box-drawing, Paragraph-Zeichen -> jetzt `--` bzw. `Sec-`).
`grep -cP "[^\x00-\x7F]" ci/anhang_forward_core.sh` == **0**.
Ueber den GESAMTEN Patch bleiben **5** Treffer -- alle in **KONTEXT**-Zeilen (fuehrendes Blank),
byte-identisch mit dem Bestand von `HEAD:.gitlab-ci.yml` und daher vom Patch unveraendert:
die `- persist`-stages-Zeile (Paragraph-Zeichen U+00A7), der Submodul-Auth-Kopf (box-drawing
U+2500 + U+00A7), die persist:measurements-MERGE-Zeile (U+201E Anfuehrung + U+2192 Pfeil) und die
beiden planer:delegate-Kopfzeilen (U+2500/U+00A7/U+2014/U+201E).
Sie ehrlich auszuweisen ist Absicht: sie zu transliterieren wuerde den
Patch von "rein additiv" auf "veraendert Bestand" heben und die Merge-Flaeche gegen die parallele
W1-Welle unnoetig vergroessern. **Entscheid liegt beim Lead.**

## Anwenden

```
SUPER=<eigener super-Worktree ab development>
git -C "$SUPER" apply -p1 <hier>/gitlab-ci.yml.patch
install -m 0755 <hier>/ci/anhang_forward_core.sh "$SUPER/ci/anhang_forward_core.sh"
install -m 0644 -D <hier>/docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md \
  "$SUPER/docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md"
```

**Zeilen-Drift / W1-Parallelwelle:** der Patch haengt am Kontext um `persist:measurements` und
den `planer:delegate`-Kopf. Bewegt eine parallele Welle dieselbe Datei, gilt die Kollisionsregel
"Substanz gewinnt": den Job-Block **am Job-Namen** wieder einsetzen (obenauf mergen), nicht an
Zeilennummern.

## Commit-Schnitt (Vorschlag)

1. `ci(e18): anhang:forward -- LaTeX-Anhang-Vorwaerts-Kanal je CI (inert-by-default) + ci/anhang_forward_core.sh` (Patch + Script)
2. `docs(e18): Plan-/Beweis-Dossier B1 + Verweis auf das Infra-Handout` (Session-Doc; Ledger-Eintrag additiv bei Landung)
3. Cluster-Repo: eigener Commit fuer das Infra-Handout.

## VOR der Scharfschaltung

- 289-Write-Token + 2 CI-Vars auf 288 + Branch-Protection-Check. **Hinweis 05.08. abends
  (super-Ledger `7d468505`):** das 289-Write-Token liegt moeglicherweise bereits im Cred-Vault
  (Cluster git) -- dort ZUERST suchen, bevor das Infra-Handout ausgeloest wird.
- **Lebend-Check (B-5):** eine getriggerte development-Pipeline mit `COMDARE_ANHANG_FORWARD=true`
  -> 289-Commit sichtbar, 289-Pipeline gruen, Gitlink-Bump `[skip ci]` gelandet, **keine**
  Echo-Pipeline auf 288.
- **Erst danach** der Projekt-Var-Flip auf "jeder CI".
- **Achtung (Fixture-Fund):** solange der Flaechen-Writer der Stufe 05 fuer datenlose Metriken
  eine 0.0000-Heatmap schreibt, faellt das PDF-Gate bei Teil-Korpora wie D-03 rot aus und der Kanal
  landet bewusst nichts. Das ist gewolltes Verhalten, aber es heisst: der Lebend-Check braucht
  entweder einen vollstaendigen Mess-Korpus oder das Folge-Paket "honest-empty im Flaechen-Writer".
- **Deklarierte Grenzen des PDF-Gates** (jetzt im Kopf von `ci/anhang_forward_core.sh` und im
  YAML-Kommentar festgeschrieben): es baut NUR das erste Top-Level-Haupt-.tex (heute
  deckungsgleich: 289 traegt genau `diplomarbeit.tex`), und `AF_PDF_GATE=auto` prueft ohne
  TeX-Toolchain GAR NICHTS (loggt das literal). Restnetz ist die 289-Pipeline nach dem Push.
