# Z07 EXPLORE-BEFUND (3 Achsen, VOR dem Merge dokumentiert) — 2026-08-22

Ziel: Merge 8/10 bau/trigfix @ 0f900dcf --no-ff in lande/w2-s1s2 (wt-ce-lande, HEAD a58f77b5).
Fahrplan-Pflichtlektuere VOLL: SYNTHESE-S1-AUDIT.md (118 Z.) + SYNTHESE-S2-AUDIT.md (83 Z.)
+ GEGENLESE-GATE.md (168 Z.) + trigfix/audit-runde-1.md (r1+ANNEX, 279 Z.) + trigfix/soll-karte.md (391 Z.).

## 1. HISTORISCH
- quelle_tip 0f900dcf ist der JUENGSTE Stand: `git ls-remote origin refs/heads/bau/trigfix`
  = 0f900dcf... (literal); lokal exakt 1 Commit auf Basis 66de5c09 (21.08. 12:28 UTC,
  "feat(w2-trigfix): R-12 E-07-Gate-Kriterien ausfuehrbar + R-13 bytes_in_use_peak wahr").
- github traegt den Zweig nicht (reine origin-Ref-Sicherung; deckt sich mit Audit-Literal
  "[new branch]-Push (ls-remote=0f900dcf)").
- KEIN Ueberholt-Marker: GEGENLESE-Tafel Zeile trigfix = "OK (T-9-Folgewelle getragen)";
  S2-Synthese-Tips T9-T13 aendern trigfix nicht; juengste Runde = audit-runde-1 + ANNEX
  (Wiederanlauf-Verifikation 22.08., alle Literale frisch re-deriviert), Verdikt SITZT 0/0/3 KLEIN.
- Board #114 (Lead-verbucht): E07_GATE=GO bereits mit DIESEM Pruefer @ 0f900dcf erbracht
  (Emitter-Beweislauf 22.08., BEWEIS.md liegt) — bestaetigt Tip-Aktualitaet und Funktion.
- wt-ce-trigfix: HEAD 0f900dcf, porcelain 0, build/ FEHLT (Strang selbst entfernt,
  Audit-verifiziert, heute erneut gemessen) -> Strang-Cache-Raeumung gegenstandslos.
- probe/rerun-20260822/ liegt im Audit-Ordner (20260821-w2-audit-fixverify/trigfix/probe/).

## 2. STRUKTURELL
- merge-base HEAD..0f900dcf = 66de5c09 (== Strang-Basis; kein Kreuz-Merge noetig).
- `git merge-tree --write-tree HEAD 0f900dcf`: EXAKT 1 Konflikt = tests/unit/CMakeLists.txt
  (Dateiende; bekannte H-9-Harmonisierungs-Flaeche, Muster der Merges 1-7).
- Die uebrigen 4 Dateien konfliktfrei: A libs/cache_engine/profile_facade/e07_gate_kriterien.hpp
  (H-16: profile_facade additiv, nur NEUE Dateien), A tests/unit/test_e07_gate_kriterien.cpp,
  A tests/unit/test_e8_bytes_in_use_peak_demo.cpp, M libs/execution_engine/include/comdare/
  experiment/experiment_demo.hpp — der Zielzweig hat von den 5 Pfaden seit Basis NUR
  tests/unit/CMakeLists.txt beruehrt (git diff 66de5c09..HEAD --name-status literal).
- Zaehlwerk comdare_add_test( EINMAL live: Basis 245 / HEAD 261 / Tip 247 -> SOLL nach Union 263.
- trigfix-CMakeLists-Block = 22 Add-Zeilen (Hunk @@ -7574,3 +7574,25 @@), beginnt mit
  Leerzeile + eigenem "# ===="-Trenner -> Harmonisierung: HEAD-Endstand VOLL erhalten,
  Block ans neue Dateiende (DATEIENDE-Regel: juengster Block zuletzt).

## 3. DESIGN
- Vertraege gewahrt: TABU-Zonen 0 Treffer im Diff (keine golden/axes/topics/heuristik, keine
  YAML), Header header-only/nur stdlib (Standalone-Bissprobe 2x, sha-identisch), Snapshot-POD
  unangetastet (A8-S3/B7 stehende Entscheidung), CLU-64-Heilung = c1c76c87 ANCESTOR der Basis.
- Audit-Verdikt SITZT 0/0/3 KLEIN; alle 19 Soll-Punkte ERFUELLT ausser P-17 (T-9, strukturell
  Folgewelle). Quer-Auflage G8/H5 (7er-J-1-Liste + reales Facade-Target) bindet den
  ENDSTAND-Kombibau (T-11b), nicht diesen Zwischenmerge.
- KLEIN-1 (ersetze()-npos, latenter Endlos-Pfad im Test-Helfer): Fix-Weg laut Audit woertlich
  "im Lande-Zug oder T-9-Pass"; der Z07-Arbeitsauftrag nennt die Haertung AUSDRUECKLICH ->
  wird als EIGENER Commit nach dem Merge gefahren (Audit-Rezept:
  `pos = (nl == std::string::npos) ? proto.size() : nl + 1;`).
- KLEIN-2 (setze()-end()-Guard) + KLEIN-3 (Tippfehler "Unguelig") bleiben beim T-9-Traeger
  (Ziel-besonderheiten: "NICHT dieser Zug").
- #114-VORBEHALT bleibt Restposten: E07-Q1-Default-A-Re-Run (<1h, Rezept BEWEIS.md par. 9)
  auf der FINAL eingefrorenen Trigger-Linie, nach Z10, vor Trigger Mi 26. 06:00
  (Ausfuehrender = offene Frage 8, Lead/Owner).

## ENTSCHEID
Merge freigegeben: --no-ff, Konflikt-Harmonisierung nur an tests/unit/CMakeLists.txt
(Union beider Seiten voll, Zaehlwerk-Soll 263), danach KLEIN-1-Haertungs-Commit,
Abnahme = gcc-Release-Teilbau (vorhandener konfigurierter Baum build/gcc-release,
COMDARE_CE_PRUEFLINGE gesetzt) + ctest -R der 2 neuen Tests; volle Matrix = Endstand-Kombibau.
