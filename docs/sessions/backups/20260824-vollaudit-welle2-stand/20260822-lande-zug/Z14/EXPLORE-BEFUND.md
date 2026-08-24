# Z14 EXPLORE-BEFUND (vor Merge) -- 24.08.2026, Fable-max-Lande-Schritt

Ziel: prt-art bau/pinduo @ 25bbf2e2 --no-ff in development (Rezept #107 Schritt 1, W1L-2).
Merge-Ort: Standalone-Klon /home/comdare/Projekte/Research/comdare-prt-art (development @ 777fff7e,
clean, == origin/development; wt-prt-pinduo ist linked worktree DESSELBEN Repos -> Branch lokal da, kein Fetch).

## Achse 1 STRUKTURELL (eigene Messung, Kopie: explore-strukturell-historisch.txt)
- merge-base(development, bau/pinduo) = 777fff7e == development-HEAD -> pinduo strikt +3 voraus.
- git merge-tree --write-tree development bau/pinduo = ef4c8c753c8e4238b45c36efba5fd785d914ef2b, RC=0,
  KEIN Konflikt; Ergebnisbaum == bau/pinduo^{tree} (identisch) -> Merge-Ergebnis byte-gleich zum
  auditierten/geprueften Tip 25bbf2e2.
- Delta 777fff7e..25bbf2e2 (numstat): .gitlab-ci.yml 58+/5- (Summe 63; W1L-5-Literal selbst bestaetigt),
  prt_art/registry_gen/registry_roundtrip.cmake 15+/0-, prt_art/registry_gen/CMakeLists.txt 3+/0-,
  tests/unit/support/lizenz_audit.hpp 7+/2-. Gesamt 83+/7- ueber 4 Dateien, 3 Commits
  (f1fc5d8 -> 4941c41 -> 25bbf2e).
- Kein .gitmodules (0), status porcelain 0, stash 0. Der bekannte .gitlab-ci.yml-Konflikt betrifft NUR
  pinduo x B14 (3710ac4c) und faellt erst beim B14-Merge an (Rezept: zugunsten D-10a).

## Achse 2 DESIGN (Audit-Berichte gelesen)
- 20260821-w2-audit-fixverify/pinduo/audit-runde-1.md (voll, inkl. R2-Nachtrag): r1 SITZT
  (0 ERNST/0 MILD/1 KLEIN A-1 Stat-Notation -> Traeger T10b), r2 SITZT (0 neue Funde), P-01..P-11 und
  R2-P-13/14/15/17/GOAL alle ERFUELLT bzw. ordnungsgemaess getragen.
- SYNTHESE-S2-AUDIT.md: T9-Block (Z.36-65), D-3.3 W1L-1..W1L-9, D-4-Urteil Zeile pinduo:
  "FREIGEGEBEN FUER DIE LANDUNG unter W1L-1..W1L-6; ERNST-Bedingung T9 ERFUELLT" -- BAU-Freigabe,
  CI-Freigabe erst mit W1L-1 (= Z15). [KORR-D2]: T9 (a)-(d) NICHT erneut ausfuehren.
- GEGENLESE-GATE.md: pinduo-Zeile SITZT/SITZT, F-146-Bestaetigung (origin-Tip, numstat, Beweisort 4 Dateien).
- T9-Beweisort EXISTIERT: /home/comdare/backups-workflow/20260822-parallel-heilung/pinduo-t9/
  (rot-beweis-vor-fix.log, gruen-beweis-nach-fix.log, ctest-224-gruen.log, ERGEBNIS.md).
  Literale aus den GESICHERTEN KOPIEN: ROT Z.736 "89% tests passed, 1 tests failed out of 9";
  GRUEN Z.21 "100% tests passed, 0 tests failed out of 9"; ctest-224-gruen.log Z.451
  "100% tests passed, 0 tests failed out of 224".
- Klon-Umzug ABGELEHNT bleibt eingehalten: Delta beruehrt .gitlab-ci.yml nur in der D-10a-Form
  (T9d-Wachen-Ergaenzung statt Umzug); dieser Schritt aendert NICHTS am YAML.

## Achse 3 HISTORISCH (eigene Live-Messung 24.08.)
- git ls-remote origin: refs/heads/bau/pinduo = 25bbf2e23c91821bd16511c097e76937ca590fda (== quelle_tip,
  JUENGSTER Stand, ci.skip-gesichert), refs/heads/development = 777fff7e (Basis UNBEWEGT),
  refs/heads/bau/w1luecken-prtart = 3710ac4c (B14-Faehrte gesichert). github: bau/pinduo LEER (RC=0,
  ordnungsgemaess -- GitHub = flache Sicherung).
- wt-prt-pinduo HEAD == 25bbf2e2 == origin-Tip; kein juengerer Commit, kein Ueberholt-Marker; juengste
  Schicht (SYNTHESE-S2 Drittabgleich 24.08. + GEGENLESE-GATE) fuehrt exakt diesen Tip mit Statuswechsel
  ZU GUNSTEN (T9 VOLLZOGEN, F-146).

## Entscheid
Merge fahren: --no-ff, Botschaft mit Strang/Tip/Audit-Verdikt/Restposten-Traegern + Trailer
(prt-art ist nicht thesis). KEIN Push (W1L-1/Branch-CI = Z15). Kein Bau noetig: Ergebnisbaum ==
gepruefter Tip-Baum (224/224-Probe + BAU-Freigabe decken); Kombibau T-11b faellt per Owner-Vorgabe/W1L-4
EINMAL am gemergten ENDSTAND (nach B14, vor Push) an. df / = 16G frei (Kopie df-vor-merge.txt).
