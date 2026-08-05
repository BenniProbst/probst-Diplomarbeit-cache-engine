# super-Anteil B1/E-18 — Patch-Vorschlag (NICHT im super-Tree angewandt)

Diese Session hat **nur den ce-Anteil** am Objekt gebaut (`/home/comdare/wt-b1-e18`). Der
super-Anteil liegt hier als anwendbarer Vorschlag; der Lead landet ihn koordiniert in einem
**eigenen** super-Worktree (`wt-super-w1` und `wt-e24` sind TABU).

Basis-Stand, gegen den erstellt und geprueft wurde: super `d08f5dde` (development).
`git apply --check` gegen genau diesen Stand ist gruen (literal belegt).

## Inhalt

| Datei hier | Ziel im super-Repo | Art |
|------------|--------------------|-----|
| `gitlab-ci.yml.patch` | `.gitlab-ci.yml` | unified diff, **0 entfernte / 160 hinzugefuegte Zeilen** (rein additiv) |
| `ci/anhang_forward_core.sh` | `ci/anhang_forward_core.sh` | NEUE Datei (Modus 0755) |
| `docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md` | gleicher Pfad | NEUE Datei |
| `Cluster/docs/sessions/2026-08-05-DIPLOM-AN-INFRA-e18-289-thesis-writeback-token.md` | Cluster-Repo, gleicher Pfad | NEUE Datei (eigener Commit im Infra-Repo) |
| `work/.gitlab-ci.yml` | — | das fertige Ergebnis zum Gegenlesen |
| `work/.gitlab-ci.yml.orig` | — | der Ausgangsstand, gegen den gediffed wurde |
| `work/job_block.yml` | — | nur der eingefuegte Job-Block (Anker: **Job-Name**, nicht Zeilennummer) |

## Anwenden

```
SUPER=<eigener super-Worktree ab development>
git -C "$SUPER" apply -p1 <hier>/gitlab-ci.yml.patch
install -m 0755 <hier>/ci/anhang_forward_core.sh "$SUPER/ci/anhang_forward_core.sh"
install -m 0644 -D <hier>/docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md \
  "$SUPER/docs/sessions/20260805-PLAN-b1-e18-vorwaerts-kanal.md"
```

**Zeilen-Drift / W1-Parallelwelle:** der Patch haengt am Kontext um `persist:measurements` und
`# ── planer:delegate`. Bewegt eine parallele Welle dieselbe Datei, gilt die Kollisionsregel
„Substanz gewinnt": den Job-Block **am Job-Namen** wieder einsetzen (obenauf mergen), nicht an
Zeilennummern.

## Commit-Schnitt (Vorschlag)

1. `ci(e18): anhang:forward -- LaTeX-Anhang-Vorwaerts-Kanal je CI (inert-by-default) + ci/anhang_forward_core.sh` (Patch + Script)
2. `docs(e18): Plan-/Beweis-Dossier B1 + Verweis auf das Infra-Handout` (Session-Doc; Ledger-Eintrag additiv bei Landung)
3. Cluster-Repo: eigener Commit fuer das Infra-Handout.

## VOR der Scharfschaltung

- Infra-Handout umsetzen (289-Token + 2 CI-Vars auf 288 + Branch-Protection-Check).
- **Lebend-Check (B-5):** eine getriggerte development-Pipeline mit `COMDARE_ANHANG_FORWARD=true`
  -> 289-Commit sichtbar, 289-Pipeline gruen, Gitlink-Bump `[skip ci]` gelandet, **keine**
  Echo-Pipeline auf 288.
- **Erst danach** der Projekt-Var-Flip auf „jeder CI".
- **Achtung (Fixture-Fund):** solange der Flaechen-Writer der Stufe 05 fuer datenlose Metriken
  eine 0.0000-Heatmap schreibt, faellt das PDF-Gate bei Teil-Korpora wie D-03 rot aus und der Kanal
  landet bewusst nichts. Das ist gewolltes Verhalten, aber es heisst: der Lebend-Check braucht
  entweder einen vollstaendigen Mess-Korpus oder das Folge-Paket „honest-empty im Flaechen-Writer".
