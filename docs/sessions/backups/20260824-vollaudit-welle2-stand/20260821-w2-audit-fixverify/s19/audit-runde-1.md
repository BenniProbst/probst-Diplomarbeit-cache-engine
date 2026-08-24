# AUDIT RUNDE 1 — Strang s19 (#7/S-19 PLANUNGS-SIMULATION, C-1)

Auditor: Fable-max-AUDITOR (W2-Audit-Fix-Verify, 22.08.2026).
Objekt: ce `bau/s19` @ `a1b348aefd31883fbfb35c3ff2a76b66c87be653` (Basis `66de5c0972`,
merge-base gegen `development` = `66de5c09` gemessen, 1 Commit, 7 Dateien +1661/-67).
origin-Gegenprobe: `git log -1 origin/bau/s19` = `a1b348ae...` (RC=0) — Ref-Sicherung steht.
Commit-Trailer `Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>` im Body vorhanden (git show).
Alle Objekt-Zugriffe read-only am ce-Hauptklon (git show/log/diff); KEIN eigener Vollbau gefahren
(kein Bau-Slot gezogen; Begruendung s. P-12/P-18-Zeilen: Lande-Zug-K17 ist die gesetzte Wiederholung).

VERDIKT: **SITZT** (0 ERNST, 0 MILD, 2 KLEIN).

--------------------------------------------------------------------------------
## 1. PUNKT-FUER-PUNKT-TAFEL (P-01..P-24 der Soll-Karte, dreiwertig)

| P | Urteil | Literal-Beleg (Datei:Zeile / Kommando-Ausgabe) |
|---|--------|-----------------------------------------------|
| P-01 Mandat/Vorbedingung | ERFUELLT | Ledger Z.105-106: "W1-V1-LEDGER-ZEILE: #17/g2 completed -- dev-CI 16031 SUCCESS ... Freigabe #7/S-19 damit WIRKSAM (KON17-01)". OF-2: Ledger Z.6913 "KON42: OF-2-NEU BEANTWORTET" + Z.6975 "Der Owner hat OF-5, OF-1, OF-2 und OF-3 beantwortet". Board #15/#16/#17 completed (Task-Liste 22.08.). Wellenplan Z.2249 nennt exakt diese Vorbedingung. |
| P-02 Zwei-Schritt-Weg (gruppieren/kategorisieren -> B+-Baum-Permutation) | ERFUELLT | planner_simulation.hpp Kopf Z.11-12 zitiert KON30-03 woertlich; Kategorien-Typen `SimAchse`/`SimDynDim`/`SimulationsEingang`/`SimulationsSicht` (Z.~60-120); Sammler haengt am SELBEN Director-Walk wie check-size: profile_run_facade.cpp-Diff `class SimulationsSollBuilder final : public planner::IPlanBuilder` umhuellt `MengenSollBuilder` (Diff-Plus-Z.19-21), `begin_perm`-Zaehlung + `walk_schritte` on_step-gesamt = GESAMTER Baum, nicht XML-lokale Teilmenge. Wellenplan §17.5 (Z.2185) deckungsgleich gelesen. |
| P-03 Planer-Etappe, nur Zahlen | ERFUELLT | main.cpp:364-365 "PLANER-ETAPPE (D.1/O1 ausdruecklich): ... diese Etappe rechnet im Planer und SAGT es"; main.cpp:647-648 (help simulate) "Baut KEINE DLL, misst NICHT ... PLANER-ETAPPE: der CEB-Rechen-Ort folgt mit dem CEB-Rechen-Vertrag (S-10/S-22)". `simulate` liegt im comdare_experiment_planner-Binary (main.cpp:960 Dispatch). Etappen-Freigabe selbst = O1-Vorlage (P-11). |
| P-04 C.8(a) Freigabe-PRODUKT je Organ-Achse | ERFUELLT | planner_simulation.hpp `s.organ_produkt` mit `mul_sicher` je Achse + Faktor-Zeile `freigabe[<name>]` je Achse; Echtlauf-Datei (s19-simulation-echtlauf-golden320.txt, 11502 B, 20.08. 18:13): 18 einzelne `freigabe[...]`-Zeilen (search_algo=4, node_type=4, memory_layout=5, prefetch=4, 14x =1), `organ_produkt 320 gerechnet prod(|Freigabe-Werte|) ueber 18 Organ-Achsen`. Produkt nachgerechnet: 4*4*5*4=320. |
| P-05 C.8(b) dyn-Produkt OHNE repetition | ERFUELLT | Kopf-Kommentar "DOPPELZAEHL-FALLE ... repetition zaehlt GENAU EINMAL -- als kf10_repetitions" (planner_simulation.hpp Z.18-24); Echtlauf: `dyn_produkt 72 ... prod(|values|) ueber 4 dynamic_dims OHNE repetition` (1*3*6*4=72 nachgerechnet). |
| P-06 C.8(c) T-15xKF-10=9 + x5-Klammer eigene Zeile | ERFUELLT | Echtlauf: `messungen_je_einstellung 9 gerechnet T-15 x KF-10 ... (C-04)` (3*3 nachgerechnet); `t15b_fehlversuch_klammer je 5 (Build UND Messung) ... NICHT in die geplante Menge multipliziert; Eigentuemer measure_storage/#13` als EIGENE Zeile; `drift_worst_arena 18` als dritte, getrennte Zeile. 18->120-Nachzug = getragenes H-5/F-10 (Lande-Zug, s. Abschnitt 3). |
| P-07 C.8(d) PMC-Tor + n! als AUSGANG, kein 24/48-Literal | ERFUELLT | grep "320\|131072\|24\|48" in planner_simulation.hpp trifft NUR Kopf-Kommentar Z.14-16 (das Verbots-Statement selbst); Code: `rekombination = fakultaet_sicher(messgeraete)` mit `messgeraete = basis + (pmc_tor?1:0)`; Echtlauf: `pmc_tor an ... GEMESSEN auf diesem Host: Lage 'amd' ... events=3/4` -> `messgeraete 4` -> `rekombination 24 ... AUSGANG dieses Laufs, NIE Vorgabe`. Fremde Lane fail-closed n/a ("wird nicht erfunden"). |
| P-08 C.8(e) Deckel als AUSGANG, fail-closed UNBESTIMMBAR | ERFUELLT | planner_simulation.hpp: `zeit_urteil = Deckelurteil::Unbestimmbar` + Nenner "O4: GN-9-Slot oder deklarierte Herabstufung -- fail-closed" wenn Kalibrierung fehlt; CLI-Test test_s19_simulation_cli.cpp:128-130 (L6: `--t3-fenster-tage=1` ohne Kalibrierung -> rc=1 + "unbestimmbar") und :141-144 (L9/L9b Grenzwert-Paar: Budget==136960000 haelt rc=0, 136959999 "GERISSEN" rc=1). Echtlauf: `lager: haelt (lager_bytes=136960000 gegen 6000000000000)`, `zeit: kein_deckel` (bewusst ohne Fenster). |
| P-09 C.8(f) Kampagnen-Aggregation | ERFUELLT | `kampagnen_aggregation` (Summe `add_sicher`, FULL-JOIN-Union je Achse via std::map/set, `kandidaten_gegenprobe` nimmt Kandidaten NUR als Parameter); Echtlauf: Kampagnen-Block mit `n_bau[m3v2_study...]=320`, 18 union[...]-Zeilen, `s19_kampagne profile=1 summe_n_bau=320 union_produkt=320 urteil=ok`; Kandidaten 131072/524288/1572864/2097152 weichen ab (nachgerechnet: 131072 mod 320 = 192 usw., alle !=0). Mehr-Profil-Mechanik im Rechnung-Test F-Block synthetisch (P1+P2: summe=14, union=16, Hand-Orakel). Mehr-Profil-ECHTLAUF = Sa-Lauf, NICHT-GEFORDERT. |
| P-10 Abnahme-Satz C-1 woertlich | ERFUELLT | (i) B-4-Zahl liegt vor: 320 mit vollem Rechenweg + Echtlauf-Datei; (ii) je C.8-Posten eigene Ausgabe: Faktor-Zeilen (a)-(f) einzeln im Echtlauf belegt (s.o.); (iii) D.1-D.10 benannt: Ergebnis-Datei Abschnitt 4 fuehrt alle 10 je GEBAUT/DEKLARIERT; (iv) C-04-Verdreifachung: `messungen_je_einstellung 9`-Zeile in der Rechnung. |
| P-11 O1-O4 nur Vorlage | ERFUELLT | Ergebnis-Datei Abschnitt 5: exakt 4 Zeilen "VORLAGE O1..O4", Ueberschrift "NUR VORLAGE-ZEILEN (nicht entschieden, nicht gebaut)"; am Objekt keine Schema-Erweiterung (kein XSD im Diff), Mess-Teilmenge nur als CLI-Flag `--mess-teilmenge` (main.cpp-Flags), D.4 rechnet Defaults "markiert 'default'" (Echtlauf: `n_ops 10000 default ... NICHT im Profil erklaert`). |
| P-12 T-1..T-9 je neuem Test | ERFUELLT | T-1 via T-11c (2 Mutationen, s. P-14); T-3/T-5: test_s19_simulation_rechnung.cpp Kopf Z.4-27 "KEIN Soll-Wert dieser Datei stammt aus simulation_rechnen(). Alle sind von Hand gerechnet (und mit GNU bc ... gegengerechnet)" + volle Hand-Tabelle; test_s19_simulation_cli.cpp Kopf Z.4-15: Orakel "aus dem PROFIL-XML SELBST ... von Hand gezaehlt"; Rekombination als KONSISTENZ statt Host-Annahme. T-4: Gegeneingaenge dokumentiert+gebaut (Rechnung-Kopf Z.28-31: 0-Werte/Ueberlauf/21!/Kampagnen-Loch; CLI: rc2/rc5/L6-fail-closed). T-7: `add_test(NAME test_s19_simulation_rechnung ...)` + `add_test(NAME test_s19_simulation_cli ... $<TARGET_FILE:comdare_experiment_planner>` + `add_dependencies` in tests/unit/CMakeLists.txt (Diff @7574ff); Bericht-Literal ctest -N "#511/#512, Total 512". T-8 = Lande-Zug (Status LANDEREIF, deklariert). |
| P-13 T-11b 4-Zellen-Kombibau | ERFUELLT (als deklarierte Lande-Zug-Pflicht) | Designplan Z.645 selbst: "Abnahme-Regel, kein Einzeltest-Posten: sie gehoert in die Wellen-Abnahme"; W2-ABFOLGE-DESIGN Z.807 Slot [C] "kein Vollbau-Bedarf ausser Smoke"; Strang deklariert offen (Abschnitt 9: "clang-Zelle lief hier nicht ... gehoert dem Lande-Zug"). Kein Strang-Defizit. |
| P-14 T-11c Mutationen | ERFUELLT | Ergebnis-Datei Abschnitt 3: Mutation 1 (fakultaet_sicher i=2->i=3): "ROT: 89 Pruefungen, 15 rot" RC=1, Revert "GRUEN: 89, 0 rot" RC=0; Abschnitt 7: Mutation 2 (run_simulate_guarded verliert --bytes-je-dll): "ROT: 20 Pruefungen, 2 rot" RC=1 mit L9/L9b-Literalen, Revert "GRUEN: 20, 0 rot" RC=0. Je neuer Testdatei 1 Protokoll = 2/2. |
| P-15 Bau-Slot-Doktrin | ERFUELLT | Bericht-Literale: "BAU-SLOT: slot2 (slot1 haelt prtart-pin-duo, fremd, unangetastet). df 32G frei" + Abschnitt 9 "Bau-Slot 2 freigegeben ... porcelain 0". SPANNUNG 6 (Vollbau statt Smoke) AUFGELOEST: LEAD-ENTSCHEIDE Nr. 18 (Owner-Order 20.08. abends) "BAUEN STRIKT SEQUENTIELL -- Staffel 1 als for-Schleife (1 Strang zur Zeit)" -> keine Slot-Konkurrenz moeglich; NIE-KUERZEN-Dauerregel deckt die Gruendlichkeit. |
| P-16 Hygiene/TABU | ERFUELLT | (i) clang-format-22: eigene Audit-Probe mit Projekt-.clang-format ueber alle 6 Lint-Dateien am Tip: je RC=0, SUMME_RC=0 (Erstprobe ohne Stildatei war Audit-Methodenfehler, verworfen); (ii) ASCII: `git diff 66de5c09..a1b348ae | grep '^+' | grep -cP '[^\x00-\x7F]'` = 0; (iii) TABU: `git diff --stat -- axes/ topics/ heuristik/` = 0 Zeilen; (iv) CMakeLists NUR ans Dateiende: Diff-Hunk `@@ -7574,3 +7574,39 @@` = reine Anfuegung nach dem letzten Alt-Block. |
| P-17 Beweis-Doktrin/Anker | ERFUELLT | Stichprobe am Objektstand 66de5c09: experiment_plan_director.hpp:543 = Kopf-Kommentar "PlanSizeBuilder -- ConcreteBuilder...", :552 = `class PlanSizeBuilder final : public IPlanBuilder` — beide Anker STIMMEN (D.10/F-01 bestaetigt, 4. Bestaetigung). F-04-Heilung haelt: 0 Treffer "Ledger :<Zahl>" in Datei und Diff-Plus (beide Zaehlungen 0). |
| P-18 Gruen-Probe-Treppe | ERFUELLT mit KLEIN-Vermerk (FUND-2) | Bericht Abschnitt 8: Treppe RC=0 je Stufe, --target all 2519 Ziele, ctest Lauf 1 "99% ... 1 failed out of 512" (F-04) -> Heilung -> Abschnitt 9 "100% tests passed, 0 tests failed out of 512 (CTEST2_RC=0)". ABER: die protokollierte J-1-Liste nennt 6 Werkzeuge — `comdare_overlay_source_hash_gen` fehlt im Protokoll (s. FUND-2). Deckung faktisch durch RE-CONFIGURE + `--target all` + vollen ctest. Audit-Grenze benannt: die ctest-Bilanz selbst ist Bericht-Literal vom Strang-Worktree; das Audit verifizierte Registrierung, Testinhalt und Echtlauf-Artefakt am Tip, fuhr aber KEINEN eigenen Bau — die gesetzte Wiederholung ist der Lande-Zug-K17-Kombibau (beide Mengen genannt). |
| P-19 origin-Sicherung + Trailer | ERFUELLT | `git log -1 origin/bau/s19` = a1b348ae (RC=0); Commit-Body traegt "Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>" (git show --format=%B). |
| P-20 H-5-Kopplung 18->120 | ERFUELLT (als getragene Lande-Zug-Pflicht, KEIN neuer Fund) | Am Objekt KEIN 18-Literal: `drift_worst = drift_faktor_rechnen(reps, max_reruns)` gerechnet (3*(5+1)=18 am Basis-Default); Bericht D.7 weist beide Lesarten + Eigentuemer measure_storage/#13 aus. F-10/H-5 = STAFFEL1-SYNTHESE Z.115 "OFFEN -> LANDE-ZUG (Pflicht)". Hinweis an den Lande-Zug: nach dem messfenster-Merge Bericht-/Orakel-Zeilen gegenlesen (Rechnung-Test setzt reps/max_reruns von Hand in den Eingang — er bricht nur, wenn messfenster die drift_faktor_rechnen-FORM aendert; die Formel-Aenderung ist messfenster-Eigentum). |
| P-21 GN-9-Lauf ausserhalb | ERFUELLT | C-1 (Z.179-180): "O4/GN-9-Kalibrierlauf entscheidet ueber fail-closed-Bestimmbarkeit"; "Bau haengt laut D4 NICHT daran". Der Strang liefert den Mechanismus (P-08 belegt). F-73-FRIST "vor Sa 22.08." ist HEUTE (22.08.) erreicht — Owner-Posten V-10, Traeger Task #117 (variant-Audit -> O2 -> GN-9-Kalibrierlauf); kein s19-Delta. |
| P-22 GOAL VI.2 Hybrid-Mehrfach-Aufbau | LUECKE (KLEIN, FUND-1) | Am Objekt gemessen: 0 "hybrid"-Treffer im gesamten s19-Diff (einziger Datei-Treffer profile_run_facade.cpp:460 "A2-Hybrid" = Altbestand ausserhalb des Diffs); HINWEISE-Sektion des Berichts listet 4 Nicht-gemessen-Punkte + GN-Divergenz — Hybrid fehlt. Aufloesung der SPANNUNG 3 am Ledger: KON42-01(3) (12.08., JUENGER als GOAL VI.2): "die GROESSEN der Permutations-Schichten kommen AUSSCHLIESSLICH aus der S-19-Simulation · die Hybrid-Dock-Zahl ist davon unabhaengig. => S-19 hat seinen Mess-Faktor sauber definiert"; KON42-01(4): Hybrid-Belegung per XML statisch waehlbar -> XML-Freigaben zaehlt der S-19-Mechanismus strukturell. Wellenplan Z.2249 bindet #7 selbst an "KON42-01/3". Damit KEINE Rechen-Luecke fuer die vorliegenden Kampagnen (golden-320 und die 33 Paper-XMLs deklarieren keinen Hybrid) — aber die GOAL-VII.2-Pflicht "ausdruecklich als ungedeckt benannte Stelle" ist fuer den Mehrfach-Aufbau-Zweig nicht erfuellt (der Bericht weist D.2-Tore aus, Hybrid nicht). Schwere KLEIN (Doku-/Ausweisungszeile), fix_weg s. FUND-1. |
| P-23 Echtlauf golden-320 | ERFUELLT | Datei existiert: /home/comdare/backups-workflow/20260820-w2-sofortstaffel/s19-simulation-echtlauf-golden320.txt (11502 B, mtime 20.08. 18:13); traegt vollen Bericht inkl. Schlusszeilen `s19_simulation ... n_bau=320 ... rekombination=24 pmc_tor=an ... urteil=ok` + `s19_kampagne profile=1 summe_n_bau=320 union_produkt=320 urteil=ok`. Alle Zahlen nachgerechnet: 4*4*5*4=320; 1*3*6*4=72; 3*3=9; 10000*72*9=6.480.000; 320*6.480.000*1*24=49.766.400.000; 320*428000=136.960.000; 320*1282,5/3600=114,0 h (1282,5=45,6h*3600/128, konsistent Wellenplan C-03 "~45,6h@16W"). |
| P-24 Pruefling = drittes Konzept | ERFUELLT (strukturell) mit Rest-Vermerk | Der Freigabe-Mechanismus zaehlt JEDE XML-deklarierte Werte-Liste je Organ-Achse (SimAchse.werte aus permute_axes/allowed_variants; Registry-Fallback "leer=volle Liste" = build_axis_levels-Regel, profile_run_facade.cpp-Diff `is_organ_composition_axis`-Filter 2x) — ein per XML freigegebener Pruefling-Algorithmus (D-09: "je Organ-Achse zusaetzliche Algorithmen") erscheint als zusaetzlicher Achsen-Wert und multipliziert strukturell mit. Kein separater Faktor noetig, keiner erfunden. Expliziter Pruefling-DURCHLAUF (33 ph89-Paper-XMLs) = Sa-Lauf, deklarierte Nachfolge — kein Strang-Defizit. |

Abnahme-Formeln 1-11 der Soll-Karte: alle an den Originalstellen stichprobenverifiziert
(Wellenplan Z.2249/2185/2460-2464 wie zitiert; Designplan Z.67/645/647 woertlich; GOAL Z.55-56 +
Z.502-506 woertlich; OG-13 Z.538-541 via Grep; Kritischer Pfad Z.780 via Grep) — kein Zitat-Drift
gegen die Soll-Karte gefunden.

--------------------------------------------------------------------------------
## 2. FUNDE (nur echte Deltas)

**FUND-1 [KLEIN] — GOAL-VI.2-Hybrid-Ausweisung fehlt in den HINWEISEN des Simulationsberichts.**
Beleg: 0 "hybrid"-Treffer im s19-Diff (Zaehlung je Datei am Tip; einziger Datei-Treffer ist
Altbestand profile_run_facade.cpp:460 ausserhalb des Diffs); simulations_bericht-HINWEISE
(planner_simulation.hpp, Funktion `simulations_bericht`) fuehren 4 Nicht-gemessen-Punkte
(mess-teilmenge, rekombination/D.2-Tore, arena-widerspruch, lastsequenz) — der GOAL-VI.2-Zweig
"Hybrid-Mehrfach-Aufbau wirkt auf den Bauplan ... sonst ist jede Groessenrechnung strukturell zu
klein" (GOAL Z.502-506) ist NICHT als ungedeckte Stelle benannt (GOAL VII.2 verlangt: "ein
Werkzeug oder eine ausdruecklich als ungedeckt benannte Stelle"). Inhaltlich KEINE falsche Zahl:
KON42-01(3)/(4) (juengere Owner-Schicht, vom Wellenplan Z.2249 selbst als #7-Quelle gefuehrt)
entkoppelt die Dock-Zahl und macht die Hybrid-Belegung XML-steuerbar (XML-Freigaben zaehlt der
Mechanismus); golden-320 und die 33 Paper-XMLs deklarieren keinen Hybrid.
fix_weg: EINE Hinweis-Zeile "5. hybrid: der Hybrid-Mehrfach-Aufbau (GOAL VI.2) ist nicht
modelliert; Hybrid-Belegung kommt per XML (KON42-01(4)) und zaehlt dann als Freigabe — die
Dock-Zahl ist Programm-Deckel (KON42-01(3)), kein Faktor" in
`libs/cache_engine/profile_facade/planner/planner_simulation.hpp`, Funktion `simulations_bericht`,
nach dem Hinweis-4-Block (reiner o+=-String, kein Rechen-Delta); danach clang-format-22 -i +
Kurzlauf test_s19_simulation_rechnung/cli (kein Test ankert auf die Hinweis-Anzahl — Gegenprobe:
CLI-Test prueft Textmarken, nicht Zaehlungen). Traegbar im Lande-Zug (Komplex-Fix-Traeger s19)
ODER als deklarierte Zeile im ##51-/Vorlagen-Text, falls der Lead den Code-Weg nicht vor dem
Sa-Lauf fahren will. KEIN Blocker.

**FUND-2 [KLEIN] — J-1-Protokoll des Strangs nennt 6 statt 7 Werkzeuge.**
Beleg: Ergebnis-Datei Abschnitt 8 listet die J-1-Treppe mit comdare_adhoc_emitter_cli,
comdare_anatomy_codegen_cli, comdare_catalog_codegen_cli, comdare_axis_registry_gen,
comdare_measurement_axis_registry_gen, comdare_system_axis_registry_gen "(Auftrags-Liste)" —
`comdare_overlay_source_hash_gen` (7. Werkzeug der Session-Bau-Doktrin "J-1 = SIEBEN Werkzeuge")
fehlt im Protokoll. Faktische Deckung: RE-CONFIGURE + `--target all` RC=0 (2519 Ziele, baut auch
den Overlay-Hash-Gen) + voller ctest 512/512 inkl. golden-/Ratsche-Wachen — kein Falsch-Gruen-Indiz
am Ergebnis. fix_weg: KEIN s19-Nachbau; der ohnehin gesetzte Lande-Zug-K17-Kombibau am gemergten
Endstand faehrt die VOLLE 7er-J-1-Liste (inkl. comdare_overlay_source_hash_gen) — im
Lande-Protokoll die 7er-Liste literal ausweisen; Lehre fuer kuenftige Strang-Prompts: J-1-Liste
stets als 7er-Block zitieren.

--------------------------------------------------------------------------------
## 3. GETRAGENE OFFENE POSTEN (aus F-01..F-123 — KEINE neuen Funde, nur Liste)

- F-10/H-5: 18->120-Zahlen-Nachzug beim s19-Merge (Eigentuemer measure_storage/#13; Lande-Zug-PFLICHT).
- H-9/H-1: tests/unit/CMakeLists.txt-Dateiende-Harmonisierung ueber alle Straenge (Lande-Zug; Endstand-Soll ctest 520).
- F-01/D.10: Wellenplan-Anker-Pflegepass :489 -> :543/:552 (Lead; ENTWURF-2 liegt im Strang-Ergebnis; Audit = 4. Bestaetigung).
- F-03/O3 + O1/O2/O4 (OG-13): Owner-Vorlagen im F2-Fenster (LITERAL dort getragen, STAFFEL1-SYNTHESE Z.195-208).
- F-73/O4: GN-9-Kalibrierlauf ODER deklarierte Herabstufung — FRIST "vor Sa 22.08." ist HEUTE erreicht; Traeger Task #117/Owner (V-10). Ohne ihn rechnet der Sa-Lauf-Zeit-Deckel fail-closed UNBESTIMMBAR (so gebaut und belegt, P-08).
- F-04/H-7: Anker-Ratsche am Endstand EINMAL messen (drei lokale Heilungen s19/pmc/skip97; s19-Heilung am Objekt verifiziert: 0 rohe Anker).
- F-05: Kandidaten 131072+ beschreiben die Voll-Katalog-Kampagne (dokumentiert; Sa-Lauf faehrt die Kampagnen-XMLs).
- T-11b-Kombibau (4 Zellen) + clang-Warnungs-Runde: EINMAL am gemergten ce-Endstand (STAFFEL1-SYNTHESE Phase 3).

--------------------------------------------------------------------------------
## 4. ZUSATZ-PRUEFUNGEN (Auftrag (a)-(d))

(a) TDD je neuem Test: T-1 via 2 T-11c-Protokolle (literal Rot RC=1 + Revert-Gruen RC=0, P-14);
T-3-Nenner fremd (Hand+bc / XML-selbst, P-12); T-4-Gegeneingaenge gebaut (Ueberlauf/0-Werte/21!/
Kampagnen-Loch/rc2/rc5/L6); T-7-Registrierung am Objekt (add_test + add_dependencies + Label,
CMakeLists-Diff) + ctest-N-Literal #511/#512; T-11c 2/2.
(b) GOAL-Doktrinen: ASCII 0 Verstoesse (Diff-Plus-Messung); allow_failure nicht beruehrbar (kein
YAML im Diff); TABU-Zonen 0 Treffer; Ledger/Board/Memory unberuehrt (Diff = 7 Code-/Test-Dateien;
Ledger-Zeilen nur als ENTWURF in der Ergebnis-Datei); golden byte-stabil (keine golden-Datei im
Diff); xlsx-Doktrin nicht beruehrt (reine Rechen-/CLI-Etappe).
(c) Abnahme-Formeln: alle 11 woertlich gegen die Originalstellen gehalten — erfuellt bzw.
ausdruecklich dem Lande-Zug/Owner zugewiesen, wo die Formel selbst das sagt (T-11b Z.645
"Wellen-Abnahme"; O1-O4 OG-13-Vorlagen).
(d) Bericht-Behauptungs-Stichproben, alle HALTEN: Anker :543/:552 (gemessen); origin-Tip+Trailer
(gemessen); clang-format RC=0 (eigene Probe, 6/6); Kandidaten-Abweichung (nachgerechnet, 4/4 kein
ganzzahliges Verhaeltnis); alle Echtlauf-Zahlen (nachgerechnet, s. P-23); "kein Nenner-Literal im
Code" (grep: nur Kopf-Kommentar); "7 Dateien +1661/-67" (git show --stat identisch); Ratsche-
Heilung (0 rohe Anker). Einzige Protokoll-Abweichung: J-1 6/7 (FUND-2). Kosmetik-Beobachtung ohne
Fund-Rang: die t15b-Klammer-Zeile ueberschreitet das 22-Zeichen-MENGE-Feld, ART klebt am Wert
(geerbtes breit()-Verhalten der check-size-Form, Lesbarkeit gegeben).

--------------------------------------------------------------------------------
SELBSTCHECK: Soll-Karte VOLL gelesen (496 Z., 24 P-Punkte, 11 Abnahme-Formeln, 13 NICHT-GEFORDERT,
6 SPANNUNGEN); Strang-Bericht VOLL (255 Z.); LEAD-ENTSCHEIDE VOLL (87 Z.); W2-ABFOLGE-DESIGN
C-1-Block + Slot-/Pfad-Zeilen; Wellenplan/Designplan/GOAL/Ledger per Grep+Fenster an den
zitierten Stellen; STAFFEL1+2-SYNTHESE s19-Bezuege. Objekt: voller Diff-Stat, planner_simulation.hpp
komplett (670 Z.), beide Tests (Koepfe+Gegeneingaenge), main.cpp-simulate-Block, facade-Diff-Symbole,
CMakeLists-Hunk, Echtlauf-Datei komplett gelesen. Keine Schreiboperation an ce/super/prt-art;
kein Bau-Slot gezogen; SPANNUNGEN 1-6 der Karte je aufgeloest oder als getragen ausgewiesen,
keine glattgezogen. 2 Funde (beide KLEIN), 0 ERNST, 0 MILD -> SITZT.
