# Z19 EXPLORE-BEFUND (3 Achsen, VOR dem Merge dokumentiert) -- 2026-08-24

Ziel: super-Phase Merge 4: bau/w1luecken-super @ 8edc34a0 --no-ff in development
(#113-Rest: B11 skip_anker-Bissprobe + 13/13 B14-xmllint-Heilungen/GRENZE).
Schreiber: lande-w2-zug (slot2.d), super-Hauptklon
/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine, development @ 2e6f7a0b
(nach Z18 c27af110 + docs-Nachtrag). Kein Push in diesem Schritt (R4; Phasen-Push Z23).

## 1. STRUKTURELL

- Tip: bau/w1luecken-super = 8edc34a03ebad1f3b3d9ac14e5e17fcc0af67b96, GENAU 1 Commit
  "test(w1-luecken/B11): ROT-statt-SKIPPED-Bissprobe des B14-B4-Skip-Ankers" auf Basis
  8aae5cd2; merge-base(development, branch) = 8aae5cd2 = die Basis selbst -> kein Kreuz.
- Diff (numstat): Code/tests/CMakeLists.txt 13+/0- (Registrierung ans DATEIENDE) +
  Code/tests/skip_anker_bissprobe.cmake 42+/0- (NEU). Summe +55/-0, 2 Dateien.
- `git merge-tree --write-tree development bau/w1luecken-super` -> RC=0, Ausgabe = reine
  Tree-OID a078de8f (KEINE CONFLICT-Zeilen; Kopie: merge-tree-probe-vor-merge.txt)
  -> KONFLIKTFREI.
- Harmonisierungs-Flaechen-Check (A2.1b-Anfangsverdacht Dateiende): `git diff
  8aae5cd2..development -- Code/tests/` = LEER (0 Aenderungen seit Branch-Basis);
  Code/tests/CMakeLists.txt auf development = 420 Zeilen, Dateiende identisch mit dem
  Branch-Hunk-Kontext (@@ -418,3 +418,16 der Verify-Messung) -> reiner Anhang am
  Dateiende, KEIN Auto-Union-Fall, keine Harmonisierung noetig.
- Gitlink: `git diff development...bau/w1luecken-super -- Code/external` = LEER ->
  Gitlink-Sperre bis Z23 strukturell eingehalten (Gitlink bleibt 66de5c09 committed;
  Arbeitsbaum-dirty = normal vor Bump).
- Keine Beruehrung von ci/, docs/, .gitlab-ci.yml (Verify Abschnitt 1: 0 Treffer gegen
  ^(ci/|docs/|\.gitlab-ci\.yml); eigener numstat bestaetigt: nur Code/tests/*).

## 2. DESIGN

- Audit-/Verify-Berichte des Strangs (VOLL gelesen):
  ~/backups-workflow/20260821-w1-luecken/w1-luecken-ergebnis.md (B11-Abschnitt + ENDSTAND
  + A2.5-FIX-NACHTRAG) und verify-ergebnis.md (VERDIKT TRAEGT_MIT_FIXES; der super-Anteil
  B10 verifiziert / B11 gebaut TRAEGT).
- B11-Substanz: NEU Code/tests/skip_anker_bissprobe.cmake (Mutationsprobe ROT-statt-
  SKIPPED des B4-Skip-Ankers, F-E-13.2-Rest) + Registrierung ans DATEIENDE
  (Kollisionsschutz); Regex DRIFT-FREI per get_test_property aus der LIVE-Property
  (keine zweite Regex-Kopie); Test test_fixture_skip_anker_biss, Labels
  "da_unit;fixture_sync", TIMEOUT 60. Biss beidseitig bewiesen (Bau: Property gelockert
  -> "***Failed ... der B4-Anker ist gebrochen (ROT wuerde als SKIPPED verkleidet)" ->
  Revert -> gruen; Verify: ctest -R skip_anker 1/1 Passed am Tip 8edc34a0).
- 13/13 B14-xmllint-Disposition (B1..B11 GEHEILT + GRENZE-1 Namespace golden_n:51 +
  GRENZE-2 comdare_xml_count-Dezimal xml_canonical_utils:531/:549; dazu xs:include-
  1-Ebene fixture_schema:144 + CMake--P-Grenze :163 als weitere ausgewiesene Grenzen):
  Objekt-Befund am Basis-Stand -- der Branch AENDERT daran nichts (nur additiv die
  Probe); Abnahme = Marker-Gegenprobe am gemergten Stand.
- Nenner-Vertraege: da_unit-Bilanz ist KONFIGURATIONSABHAENGIG (V-F3: Bau-Baum 371 vs.
  Verify-Baum ninja-gcc-release 406; Code/tests/CMakeLists.txt traegt bedingte Bloecke,
  z.B. COMDARE_V32_ENABLE) -> Bilanz je Baum/Preset als Nenner nennen; Endstand-Nenner
  misst der Phasen-Kombibau (Z23, K17).
- V-F2 (ERNST) betraf AUSSCHLIESSLICH den prt-art-Anteil B14 (bau/w1luecken-prtart vs.
  pinduo) -- durch Z14/Z15 doktringerecht vollzogen (pinduo zuerst, Konflikt zugunsten
  D-10a, Merge 16c90628). KEIN super-Bezug. V-F1 (main.cpp) = reine ce-Flaeche, in der
  ce-Phase (Z02-Z10) bereits gelandet.

## 3. HISTORISCH

- Tip-Frische: `git ls-remote origin refs/heads/bau/w1luecken-super` = 8edc34a0 == lokal
  -> juengster Stand, origin-gesichert (ci.skip-Ref-Sicherung lt. Strang-Bericht);
  github traegt den Branch nicht (flache Sicherung, wie ZUG-BILANZ Abschn. Tafel).
- Kein Ueberholt-Marker: Sessions 22.08. ("w1luecken-super 8edc34a0 = Phase-2-Ziel"),
  A61-Fenster 24.08. (super-Phase inkl. w1luecken-super "frisch angelaufen"), Inventur
  L15 22.08. ("#113-Rest ... nested-Tips enthalten"); Ledger (Kopf KON121): 0 Treffer
  "w1luecken" = Landung erwartungsgemaess noch unverbucht (Lead-only Nachlande-Zug).
- Reihenfolge-Einordnung: Z16 s13schema (ff800699) -> Z17 cidual (e80286b0) -> Z18
  VF-Harmonisierung (c27af110) sind gelandet; w1luecken-super ist Merge 4 des
  Zug-Fahrplans. S2-Synthese D-3.2 fuehrt daneben S-2c kampvor-super @ 025e0c42 (Frist
  vor Sa 29.08.) -- disjunkte Flaechen (kampvor = ci/-Skripte; w1luecken = Code/tests/*),
  keine gegenseitige Kopplung; kampvor bleibt eigenes Folge-Ziel des Zugs.
- Die S1-/S2-Audit-Synthesen + GEGENLESE-GATE (Teil I-III) VOLL gelesen; w1luecken liegt
  ausserhalb des 19-Straenge-Mandats der Audits -- massgebliches Audit-Material ist der
  Strang-eigene Verify (TRAEGT_MIT_FIXES, super-Anteil traegt).

## 4. NESTED-GITS (nur Kenntnisnahme, Raeumung = Z26)

Quell-Worktree /home/comdare/wt-super-w1luecken traegt nested ce (detached 66de5c09)
+ nested prt-art (detached d11781fa) -- beide clean, Tips im jeweiligen HAUPTKLON
ENTHALTEN (Inventur-Beweis L15). Dieser Schritt fasst den Worktree NICHT an
(NESTED Worktrees sterben mit dem Eltern-Worktree; rekursive Einzelpruefung in Z26).

## VERDIKT VOR MERGE

Merge FREIGEGEBEN: konfliktfrei, additiv (+55/-0, 2 Dateien, Dateiende-Anhang),
Gitlink unberuehrt, Tip juengst + origin-gesichert, Verify-Verdikt traegt fuer den
super-Anteil. Abnahme nach Merge: (a) RE-CONFIGURE des bestehenden Abnahme-Baums
build-l4 (Ninja, Home=<super>/Code, CMakeCache 20.08.) -> ctest --no-tests=error
-R skip_anker (Bissprobe registriert + gruen) + -L fixture_sync (5 Wachen + Probe);
(b) 13/13-Marker-Gegenprobe per grep am gemergten Stand. Nenner der Abnahme wird
mitgemeldet (Baum build-l4, Submodul-Arbeitsstand des Hauptklons).
