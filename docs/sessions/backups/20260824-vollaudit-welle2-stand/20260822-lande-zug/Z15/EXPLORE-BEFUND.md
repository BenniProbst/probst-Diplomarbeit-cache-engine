# Z15 EXPLORE-BEFUND (vor Merge) -- 24.08.2026, Fable-max-Lande-Schritt

Ziel: prt-art bau/w1luecken-prtart (B14) @ 3710ac4c --no-ff auf den pinduo-Stand
(development @ 7a658fe = Z14-Merge), dann W1L-4-Kombibau + Dual-Push + Branch-CI-Beweis
(Rezept #107 Schritte 2-3). Merge-Ort: Standalone-Klon
/home/comdare/Projekte/Research/comdare-prt-art (development @ 7a658fe, ahead 4, porcelain 0).

## Achse 1 STRUKTURELL (eigene Messung)

- B14 = GENAU 1 Commit 3710ac4c "ci(w1-luecken/B14): ce-Determinismus-Pin fuer
  build:standalone(:debug) und build:clang(:debug)" auf Basis 777fff7e;
  numstat 777fff7..3710ac4c = `50 16 .gitlab-ci.yml` (NUR YAML, keine weitere Datei).
- `git merge-tree --write-tree HEAD 3710ac4c` -> MT_RC=1, literal
  "CONFLICT (content): Merge conflict in .gitlab-ci.yml"; Konfliktflaeche = AUSSCHLIESSLICH
  .gitlab-ci.yml (3 Blob-Stufen), alle anderen Baeume sauber. Deckt die W1L-2-Praemisse
  (Audit r1 P-10 + r2 R2-P-15 massen denselben Konflikt an 4941c41 bzw. 25bbf2e).
- B14-Inhalt gegen D-10a (eigene Diff-Lektuere): B14 pinnt GLOBAL auf den AELTEREN Wert
  196a621a, deckt nur 4 der 5 Klassen-Jobs (sanitize:asan-ubsan 0 Diff-Zeilen), nutzt
  !reference-Template `.ce-pin-klon` und ENTFERNT die job-lokale registry-roundtrip-Variable.
  D-10a (am HEAD wirksam) ist STRIKT reicher: 5 Jobs inkl. sanitize, globaler Pin 66de5c09,
  Anker `.ce-pin-clone`, registry-roundtrip behaelt die EIGENE Job-Variable 196a621a
  (Job>global-Praezedenz, BEWUSST), + registry_roundtrip.cmake-Kopf (FINDINGS#13).

## Achse 2 DESIGN (Audit-/Fahrplan-Quellen VOLL gelesen)

- SYNTHESE-S1-AUDIT.md + SYNTHESE-S2-AUDIT.md + GEGENLESE-GATE.md VOLL (Auftrags-Pflicht).
  Massgeblich fuer Z15: S2 D-3.3 W1L-1..W1L-9 + T9b/T10/T10b + [KORR-D2] (T9 NICHT erneut
  ausfuehren, ist per 25bbf2e VOLLZOGEN, F-146); S1 L-16/L-18(b); GEGENLESE Teil III
  (H-18-Konformitaet pinduo, Tips unveraendert).
- KONFLIKT-REZEPT (dreifach uebereinstimmend: Board-#107-Rezept lt. Audit P-10,
  SYNTHESE-S2 W1L-2, w1-luecken-ergebnis.md "Disposition zu V-F2"):
  Konflikt ZUGUNSTEN D-10a aufloesen (5 Jobs, Pin 66de5c09, Anker .ce-pin-clone);
  EINZIGER B14-Mehrwert = die Bau-Proben-Notiz in den D-10a-variables-Kommentar:
  Wortlaut "lokale Bau-Probe 2026-08-21: Configure gelingt ohne ce mit Warnung, der BUILD
  bricht [rc=1]; mit ce 60/60 Targets" (empirischer Beleg, den D-10a nicht fuehrt;
  D-10a belegt via Pipeline 16048 / Job 382653).
- H-18: ce-Pin bleibt BEWUSST 66de5c09 (Audit I-2: Range 66de5c09..ed9f1a3c = 4 Commits,
  KEIN Fund; H-18 woertlich "Der ce-Pin bleibt 66de5c09 ... unabhaengig davon, wie weit
  ce/development bei der Landung ist"); registry-roundtrip-Pin bleibt 196a621a
  (F-86/W1L-7: Bump NUR mit XML-Byte-Beleg, NACHLANDE, Range gewachsen auf >41 Commits).
- T10b/W1L-5: Protokollzahl ".gitlab-ci.yml 58+/5- (Summe 63)" (numstat-Literal der
  pinduo-YAML-Aenderung; die "63" war die --stat-Summenspalte). In Z14 selbst bestaetigt.
- W1L-4: prt-art-Kombibau sinngemaess EINMAL am gemergten Endstand (4 Zellen
  {gcc,clang}x{Release,Debug}, ctest-Bilanz je Zelle literal) -- Z14-Entscheid deklarierte
  ihn "nach B14, vor Push"; CI-aequivalentes Layout nach T9-ERGEBNIS.md-Rezept
  (ce-pin-Klon @ 66de5c09 in der Wurzel, -DCOMDARE_CACHE_ENGINE_DIR=$PWD/ce-pin,
  ccache-Launcher = belegtes Lead-GO).
- W1L-6/T10: FINDINGS#13 als ERLEDIGT-DURCH-OBJEKT gegen f1fc5d8 quittieren -- Lead-docs,
  KEIN prt-art-Edit; geht als Restposten-Wortlaut an den Lead zurueck.

## Achse 3 HISTORISCH (eigene Live-Messung 24.08. ~12:1xZ)

- `git ls-remote origin`: refs/heads/bau/w1luecken-prtart = 3710ac4c (== quelle_tip,
  JUENGSTER Stand, origin-gesichert, ci.skip lt. w1-luecken-Bericht "Ref-Sicherung");
  bau/pinduo = 25bbf2e; development = 777fff7e (origin noch OHNE Z14 -- ahead 4 lokal,
  erwartet). github: nur development @ 777fff7e (flache Sicherung, ordnungsgemaess).
- B14-Historie: w1-luecken-ergebnis.md B14-Abschnitt (GEBAUT 21.08.) + A2.5-FIX-NACHTRAG
  "Disposition (zu V-F2, ERNST) -- B14 = KOLLISION_VERTAGT an den prt-art-Lande-Zug" mit
  exakt dem 3-Punkte-TASK, dessen Punkt 1 (pinduo zuerst) Z14 vollzogen hat und dessen
  Punkt 2 DIESER Schritt ist. Kein juengerer B14-Commit, kein Ueberholt-Marker; die
  juengste Schicht (SYNTHESE-S2 Dritt-Abgleich 24.08. + GEGENLESE-GATE Teil III) fuehrt
  exakt dieses Rezept fort.

## Betriebs-/API-Lage (fail-closed-Checks VOR dem Eingriff)

- df / = 16G frei (> 5G-Gate). Bauslots: slot2.d = dieser Zug (Z15-Uebergabedatei
  geschrieben, wer unangetastet); slot3.d = fremd (#139-Fixfahrer, unangetastet);
  slot1-ph89fix.d GERAEUMT (durch #139, lt. dessen wer-Text) -- 2 aktive Bauer am
  Deckel 3, mein Bau faehrt sequentiell mit gedrosseltem -j.
- OFFENE FRAGE 13 BEANTWORTET: GET /api/v4/projects/287 -> id 287,
  path comdare/research/comdare-prt-art (default_branch main). 287 IST prt-art.
- W1L-1c/SPANNUNG-5 AM API AUFGELOEST: GET /projects/286/job_token_scope/allowlist ->
  [(286, ce), (287, comdare-prt-art), (288, super)] -- die Allowlist-Eintragung 287->ce
  EXISTIERT; GitLab-Job-Token-Scope ist projekt-scharf, deckt damit alle Jobs des
  Projekts 287 (auch die 5 neu gepinnten). Kein Einrichtungs-Schritt vor der Branch-CI
  noetig; finaler Beleg = die 6 Klon-Steps der echten Branch-CI.
- gitleaks 8.30.1 vorhanden; prt-art traegt EIGENE .gitleaks.toml; prt-art hat KEIN
  scripts/pre_push_lande_gates.sh (ce-spezifisch) -- Push-Wache lt. Ziel: gitleaks
  (Koeder glpat-+20 rc=1, Echt-Scan rc=0, commits-scanned == rev-list --count
  --no-merges) + R4-Pipelines-Lage.
- Toolchain: g++ 15.3.0, clang++ 22.1.8, ccache -- deckt die 4 Zellen.

## Entscheid

Merge fahren: `git merge --no-ff 3710ac4c`, Konflikt in .gitlab-ci.yml ZUGUNSTEN HEAD
(D-10a) aufloesen (checkout --ours), DANN die Bau-Proben-Notiz als Kommentar-Zeilen in den
D-10a-variables-Kommentar einfuegen (einziger B14-Mehrwert), YAML-Wohlform + Anker-/Pin-
Invarianten messen (16 Top-Level-Keys, 5x Anker, global 66de5c09, Job-Var 196a621a),
ASCII-0-Probe auf dem Delta. Botschaft mit Strang/Tip/Audit-Verdikt/Restposten-Traegern +
Fable-Trailer (prt-art ist nicht thesis). Danach W1L-4-Kombibau (4 Zellen, CI-aequivalentes
Layout), dann gitleaks + R4 + Dual-Push (origin OHNE ci.skip = echte Branch-CI; github
flache Sicherung) + CI-Beweis Projekt 287 (Pin-Log 6/6 + Allowlist-Beleg + Job-Bilanz).
