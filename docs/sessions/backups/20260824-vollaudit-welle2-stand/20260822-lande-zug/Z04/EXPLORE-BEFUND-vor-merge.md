# Z04 EXPLORE-BEFUND (3 Achsen) — VOR Merge 5/10: bau/pmcpaket -> lande/w2-s1s2

Erhoben: 22.08.2026, Fable-max-Lande-Schritt Z04 (Schreiber slot2 "lande-w2-zug").
Alle Messungen eigenhaendig am Objekt (Logs explore-01..06 in diesem Ordner).

## 1. HISTORISCHE ACHSE — quelle_tip 1d38263b IST der juengste Stand

- wt-ce-pmcpaket HEAD = 1d38263b, PORCELAIN=0; `git ls-remote origin refs/heads/bau/pmcpaket`
  = 1d38263b (explore-02). GitHub traegt den Branch nicht (nur origin-ci.skip-Sicherung,
  konsistent Fix-r1-Bericht).
- Audit-Kette (alle 4 Strang-Dateien VOLL gelesen): r1 FIXES_NOETIG (0 ERNST, A-1 MILD,
  A-2 KLEIN) -> fix-r1 quittiert 2/2 VERTAGT (0 Commits) -> r2 = juengste Runde: SITZT
  (2/2 VERTAGT-Quittungen mit gepruefen Traegern, 0 neue Funde, Objekt byte-identisch).
- Gegenlese-Gate G4 praezisiert: BEIDE Funde VERTAGT; T8b = neuer PFLICHT-Tip.
  Kein Ueberholt-Marker. Task #131 nennt denselben Tip 1d38263b als Merge 5/10.
- Nicht enthalten in lande/w2-s1s2: `merge-base --is-ancestor 1d38263b HEAD` rc=1 (explore-03).

## 2. STRUKTURELLE ACHSE — 16 Dateien, 3 Ueberlappungen, 2 Inhalts-Konflikte

- merge-base = 66de5c09 (== dokumentierte Strang-Basis). Diff-Flaeche 16 Dateien (11M+5A),
  deckungsgleich mit Audit-r1-Zaehlung; ausnahmslos libs/ + tests/unit/ (explore-03).
- Ueberlappung beider Seiten: cache_engine_builder_iterator.hpp, pmc_host_probe.hpp,
  tests/unit/CMakeLists.txt.
- merge-tree (explore-04): iterator AUTO-MERGED (H-3-Vorhersage "zeilendisjunkt" trifft;
  Endstand wird semantisch gegengelesen — S-5-Pflicht des Lande-Zugs); KONFLIKTE in
  pmc_host_probe.hpp + tests/unit/CMakeLists.txt.

### KERN-RISIKO (identifiziert, Harmonisierungs-Plan)

pmcpaket zog den Probe-Kern (koeder_pointer_chase + event_beisst) in der ALTEN Form nach
`measurement/pmc_event_biss.hpp` (NEUE Datei = konfliktfreies ADD!) und machte
`pmc_host_probe.hpp` zur Weiterleitung. Die Lande-Seite traegt dort aber den
PMC-Fenster-Fix 899645ef (CI 16073/Job 382856: read_format TIME_ENABLED|TIME_RUNNING,
LeseForm, kKoederFenster=5, Leer-Fenster-Wiederholung gedeckelt, fail-closed).
Naive Konflikt-Loesung zugunsten der Weiterleitungs-Fassung verloere den CI-Fix STILL
(die neue Kern-Datei ist kein Konflikt und truege die alte Logik weiter).

HARMONISIERUNG (A2.1b, "Landung harmonisiert Vertraege; Zaehlwerke EINMAL live"):
1. pmc_host_probe.hpp: Delegations-STRUKTUR von pmcpaket uebernehmen; Kopf-K13-Absatz und
   event_beisst-Doku auf die 899645ef-Fenster-Semantik gebracht (Wortlaut des Fixes).
2. pmc_event_biss.hpp: 899645ef-Kern VOLL portieren (Konstante kKoederFenster + Doku,
   LeseForm, Schleife) — damit erbt auch der CEB-Gegeneingang
   (builder/pmc_startup_pruefung.hpp) die Fenster-Haertung. Genau das ist die
   Ein-Wahrheit-Absicht BEIDER Seiten (pmcpaket-Kopf: "ein Koeder-Wechsel liesse den
   Gegeneingang still anders beissen"; ohne Port waere exakt diese zweite Wahrheit da).
3. Referenz-Sicherheit (explore-06): kKoederFenster/LeseForm nur in pmc_host_probe.hpp
   selbst referenziert; KEINE Test-Referenz auf read_format/TIME_RUNNING beiderseits;
   Konsumenten des Kerns @1d38263b = pmc_startup_pruefung.hpp + pmc_host_probe.hpp.
   Umzug der Mechanik in den Kern bricht nichts.
4. tests/unit/CMakeLists.txt: bekannte EOF-Harmonisierungs-Flaeche — Bloecke BEIDER Seiten
   VOLL, Trenner dazwischen (Muster 881d1a15/61d5d139).
- 899645ef zweite Haelfte (profile_run_facade.cpp stderr-Befund-Vermerk) liegt NICHT in
  der pmcpaket-Flaeche -> bleibt unberuehrt erhalten.

## 3. DESIGN-ACHSE — Vertraege/Nenner/Traeger

- Audit-Verdikt-Kette s.o.; SB-Literal ctest 512/512 gcc-Release am Tip (#511
  test_pmc_startup_pruefung, #512 test_pmc_raw_event_katalog); Endstand zaehlt neu (H-9).
- Labels der neuen Tests bewusst OHNE 'pmc'-Substring (F-43, `ctest -LE pmc` ist Regex).
- H-10 gewahrt: kampvor ist Merge 10/10, pmcpaket 5/10 — Reihenfolge zwingend erfuellt.
- S-5 (zwei Warnpfade messfenster-C-11 xlsx-INFO vs. pmcpaket-Gegeneingang stderr):
  laut Audit komplementaer (verschiedene Bedingungen/Kanaele/Nenner); Endstand-Gegenprobe
  = Pflicht dieses Zugs nach dem Merge (iterator-Auto-Union semantisch gegenlesen).
- TABU: Diff-Flaeche enthaelt 0 golden/axes/topics/heuristik/YAML (Audit r1/r2 je eigen
  gemessen; explore-03 name-status bestaetigt Pfade).
- Abnahme: Zwischenmerge — Endstand-Kombibau deckt (K17); wegen STRUKTUR-RISIKO
  (Kern-Umzug + Fix-Port) faehrt Z04 einen gcc-Release-Teilbau + gezielte Tests
  (test_pmc_startup_pruefung, test_pmc_raw_event_katalog, test_experiment_plan_director,
  test_a8s3_csv_klasse_c) nach df-Gate.

## RESTPOSTEN-TRAEGER (VERTAGT mit Platz im Zug — G4)

- T6 = A-1/F-40: NP-34-Patch (np34-csv-to-latex-umschrift.patch, sha256 60fa5504...) im
  super-Lande-Abschnitt = Z22; S1-Umhaengung an Z.99+Z.247 BEIDE.
- T8b = A-2: SIEBEN-static_asserts-Ledgerzeilen + Board-#82-Korrektur "6->7" = Z24
  (Lead-Anteil; woertliche Entwuerfe in pmcpaket/fix-runde-1.md).
- F-39 (Intel-RAW nach Intel-Kreuzprobe) · F-41 (W1-FATAL-Flip, super-Nachzug-Fenster,
  Board-#83-REST) · F-42 (Uncore-Rechte, Infra) — Bestand-Traeger unveraendert.

ENTSCHEID: Merge JETZT fahren (informiert), Harmonisierung wie oben.
