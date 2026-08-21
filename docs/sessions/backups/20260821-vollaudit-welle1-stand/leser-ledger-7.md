# Sammelstrecke Leser 7 -- Segment Zeilen 27601-32210 (Ledger hat nur 32210 Zeilen, nicht 32300)

| Kuerzel/Name | Klasse | Quelle (Z-Anker) | Status laut Quelle | Traeger/Task |
|---|---|---|---|---|
| O-A Modi-Sequenz compare vor release | OWNER-ENTSCHEID | Z27619-27632 | GELANDET (ce 491fff65, Pipeline 15189 gruen, Z27996) | Registry-Nachzug measure->compare->release |
| Sec.62-C (alte Reihenfolge release dann compare) | REGRESSION/GESTRICHEN | Z27627-27629 | UEBERHOLT/SUPERSEDED durch O-A | LEDGER:3343 |
| O-B/W-3 Ebene-2 strengere Variante (Schritte+Checkpoints) | OWNER-ENTSCHEID | Z27634-27649 | ENTSCHIEDEN | Profil je Mess-Layer als zeitl. Chart = xlsx-Traeger |
| O-C Distributions-Matrix 21 Images (7 OS x 3 Versionen) | OWNER-ENTSCHEID | Z27651-27660 | ENTSCHIEDEN | beantwortet Gate W10-00 |
| O-E Anhang D an Plan-Realitaet anpassen (4 RunMethodology-Typen) | OWNER-ENTSCHEID | Z27662-27666 | AUFGABE offen (Textnachzug) | O-4-GO, DE fuehrend |
| O-F 'cpe'-Kuerzel = HW-Flag-STRING statt char | OWNER-ENTSCHEID | Z27668-27693 | Lead-Fehlfrage korrigiert; AUFGABE offen | Explore wf_acd866c1-fc8 |
| O-F Nachtrag: Flags gelten fuer Stempel UND xlsx/CSV | OWNER-ENTSCHEID | Z27695-27719 | ENTSCHIEDEN, 3-Glieder-Bau-Folge offen | Stempel-Grammatik/Freigabe-Kette/Mess-Ausgabe |
| cpe kollidiert mit experimental-'e' | REGRESSION (Design-Konflikt) | Z27720-27761 | OFFEN -- VORGELEGT (3 Fragen an Owner) | algo_semver.hpp |
| Benchmark-Zuordnung E1 Micro / E2 Macro timed / E3 Macro large scope | FEATURE (Konzept beantwortet) | Z27771-27793 | GEKLAERT/ENTSCHIEDEN | Owner-Auftrag O-B |
| Bruecke Profil -> xlsx (Zeitreihen-Traeger fehlt) | AUFGABE | Z27795-27804 | ECHT_OFFEN, Owner-Entscheid noetig | xlsx-Writer |
| 'cpe' bereits geplant (Owner-Annahme) | REGRESSION (widerlegt) | Z27806-27845 | GESTRICHEN/widerlegt -- 0 Treffer, Ein-Zeichen-Regel dreifach ratifiziert | Explore wf_acd866c1-fc8 |
| V-08 branch_misses "real erhoben" (alte Entlastung) | REGRESSION | Z27847-27937 | TEILWEISE WIDERLEGT (2/3 richtig: L1/L3 real, branch_misses honest-0) | M-3a offener Posten |
| tests/unit/CMakeLists.txt:5338 alter Text "branch_misses real erhoben" | REGRESSION | Z27921-27923 | BEHOBEN (auf honest-0/M-3a gezogen) | CMakeLists.txt |
| A15/Sec.55-Gesamt-Reconcile nie vollzogen | REGRESSION (Ledger-Prozess) | Z27871-27880 | OFFEN | tmp/wisfvjd8z.output zu ueberfuehren |
| A14/FF0 Multi-Plattform-Generalitaet | AUFGABE | Z27877-27878 | OFFEN (Abgabe-Blocker, nie bearbeitet) | -- |
| GN-9 Feasibility-/Kalibrierungs-Gate | AUFGABE | Z27879 | OFFEN (kein Fahrplan-Slot) | -- |
| V-03 Entlastung "nur un-included Dateien" | REGRESSION | Z27944-27958 | TEILWEISE (Formel falsch, Sachaussage haelt) | 26/92 in eingebundenen Dateien, 2 Anhaenge |
| 06_evaluation_methodology.tex ohne Deprecation-Kopf | REGRESSION | Z27954-27955 | BEHOBEN (GESETZT, DE+EN) | -- |
| V-05 "Stub-Quarantaene vollzogen" (alte Entlastung) | REGRESSION | Z27959-27985 | WIDERLEGT (weder delegiert noch hart gegated) | Task #37 angelegt |
| Task #37 / W4 Prt-Art-Quarantaene als Gate | AUFGABE/FEATURE | Z28012-28024 | GELANDET (ce 2f9c6abc, 421/421 gruen) | kQuarantinedPrtArtProfileId |
| Falsches ROT durch stale Generator-Binary | REGRESSION (Bau-Falle) | Z28026-28043 | BEHOBEN (Neubau; ins Fallen-Register) | comdare_system_axis_registry_gen |
| T-9 axis_optimization_catalog.hpp (19 Achsen, 45 Zielgroessen) | FEATURE | Z28055-28071 | GELANDET (ce 875a57cd, Welle A) | Break-Even-Vergleich |
| Lead-Vorerhebung 13 MAX/19 MIN | REGRESSION (Zaehlfehler) | Z28073-28078 | BEHOBEN (korrekt 17 MAX/32 MIN Nennungen, 45 Zielgroessen) | -- |
| T19 persistence_target ohne Katalog-Zeile | OWNER-ENTSCHEID (angefragt) | Z28080-28087 | OFFEN -- Owner-Frage gestellt | catalog_axis_from_name honest-empty |
| Explore "ungelesene Workflows" (34/375 Agenten ohne Ergebnis) | REGRESSION (Prozess) | Z28091-28100 | teilweise -- wf_90b95e92 selbst zur Haelfte gestorben (4/8 Lenses Spend-Limit) | -- |
| Generator csv_to_latex.cpp dreht Thesis-Korrektur (L1/L3 honest-0) still zurueck | REGRESSION | Z28103-28125 | OFFEN (ZU TUN, Owner-Pause, nicht gebaut) | super/Code/04_csv_to_latex/csv_to_latex.cpp:985-986 |
| 6 STOPP-Gate-Entscheide E-A..E-F (Versionierungs-Interface Sec.5) | REGRESSION (Ledger-Luecke) | Z28127-28135 | OFFEN -- blockiert Owner-KERN F7=b vollstaendig | naechste Owner-Vorlage |
| 3 stale Ledger-Anker (LEDGER:5328 Zeilendrift, Dossier:1302, LEDGER:7282 off-by-one 8 statt 7) | REGRESSION | Z28137-28143 | dokumentiert, Substanz unberuehrt | -- |
| "RAPL ist root-only" als Tatsache fortgeschrieben ohne Probe | REGRESSION (Doku) | Z28145-28151 | OFFEN (0 Treffer Beleg; Vorschlag RAPL-Probe im Job-Trace) | Gesamtdossier Sec.16.7 |
| 79 von 220 CMake-Zielen tot (35 namentlich+44 schleifengeneriert) | AUFGABE | Z28153-28157 | OFFEN (fehlt in Sec.-75-Kandidatenliste) | tests/unit/CMakeLists.txt |
| Workflow-Empfehlung "E18-SNAP mergen" | REGRESSION (falsche Empfehlung) | Z28160-28161 | GESTRICHEN -- NICHT-LANDEN-Verdikt steht | -- |
| Workflow-Empfehlung "Gate-8 mergen" | REGRESSION (falsche Empfehlung) | Z28162 | GESTRICHEN -- laengst Vorfahr von thesis 19e1592 | -- |
| 7 unreferenzierte Alt-Workflows 06.08. | AUFGABE | Z28166-28171 | ENTLASTET -- als Commits materialisiert, kein Arbeitsverlust | -- |
| Wellenplan 5 Wellen (A T-9, B fail-closed+macOS-offbyone+Phantom, E resource_group PMU, C T-8 Pareto-Front, D T-10 Workload-Cluster) | FEATURE | Z28175-28186 | GELANDET (ce 875a57cd/0c08fa15/0c80aa78/21560a2e/a1d0c201) | je eigener temp. Branch, geloescht nach Merge |
| Welle C: best_binary_selector_main lieferte DOMINIERTE Binary aus (Tie-Break-Fehler) | REGRESSION (schwer, Auslieferungspfad) | Z28188-28197 | BEHOBEN (echtes Paritaets-Gate, static_assert-Drift-Schutz) | rank_binaries/best_binary_selector_main |
| Welle D: worktree --force loeschte ungetrackte Arbeit | REGRESSION (Prozess-Fehler) | Z28199-28217 | GEBORGEN aus Transkript, 2. Anlauf gehaertet | docs/sessions/backups/20260807-welleD-... |
| Welle D 1. Anlauf: gtest-Makros nicht uebersetzbar (Komma in Template-Args) | REGRESSION | Z28205-28209 | erkannt, NICHT uebernommen | cluster_offline<Linkage,2> |
| Welle D: k-Wahl fuer Cluster fehlte ganz | FEATURE | Z28210-28213 | GEBAUT (Sweep+Silhouette/Elbow-Votum+Domaenen-Anker, gemeldet nie erzwungen) | -- |
| Talos-Tempus-Korrektur (Praesens->Sollform+Vollzugsstand) | AUFGABE ("vergessene Arbeit V2") | Z28219-28229 | GELANDET (thesis eaf7fe8), chktex 0/0 DE+EN | 3 Stellen je Sprache, ADR-12 |
| OWNER-KERN Flag-Grammatik NEU: Punkt-Notation, Komposit-Flags {x512.f.vl.bw.dq}, 'e'=EFFICIENCY (deprecates experimental) | OWNER-ENTSCHEID | Z28233-28270 | ENTSCHIEDEN, Bestaetigung Notation ausstehend | achse@X.Y.Z.<flag>.{<komposit>...} |
| Flag-Grammatik-Umbau bricht 138 Bestands-Literale, B12-Wache, Negativtests, POD-Kodierung | REGRESSION (angekuendigter Breaking Change) | Z28279-28287 | AUFGABE offen (Bau folgt Invalidierungs-Direktive) | algo_semver.hpp |
| Freigabe-Kette (System-Achse->SIMD-Signatur) bereits geplant, Leiter gebaut aber INERT | FEATURE (bestaetigt) | Z28289-28303 | GEBAUT/INERT (alle 9 Organ-Klassen leere Anforderung) | simd_build_gate.hpp, simd_organ_requirement.hpp |
| x128/x256/x512-Notation vor Owner-Nachricht | REGRESSION (Nullbefund bestaetigt) | Z28305-28309 | GESTRICHEN/bestaetigt neu (0 Treffer vorher) | -- |
| Vereinigungs-Workflow wf_2d080235-585 (Grammatik-Historie/Meta-Meta/SIMD/P-E-Core) | AUFGABE | Z28311-28314 | LAUFEND | -- |
| abend-1 Lead-Fehlzuordnung "Phase 3/4" = XML-Roadmap (Dossier17) | REGRESSION (Lead-Fehler) | Z28318-28340 | BEHOBEN -- richtig ist Fahrplan-Phase (20260803-FAHRPLAN:7-42) | -- |
| Null Binaries gemessen; Phase 5/6 nicht begonnen | AUFGABE | Z28343-28345 | OFFEN (fakt. Stand) | -- |
| Task #36 Flag-Grammatik = Phase-4-Vorarbeit (A4/12-Perm) | AUFGABE | Z28348-28351 | zugeordnet | -- |
| B9 "Phasen 3-5 ausfalten; Blackbox=Verlustklasse" | AUFGABE | Z28355-28358 | OFFEN seit 06.08. | -- |
| O-KERN abend-2: BESTAND INVALIDIEREN IST DAS ZIEL (kein Migrationszwang, Bruch muss LAUT sein) | OWNER-ENTSCHEID | Z28378-28392 | ENTSCHIEDEN, gebucht als Memory | Fenster 0 (0 Binaries) guenstigster Zeitpunkt |
| Vorstufen (Lager-Rest-Welle, W10, E-24 Major7->8, A2-Eichung) | FEATURE | Z28397-28399 | ALLE ERLEDIGT | f40dfb4b/51c012c5/86be2420 |
| Phase 1 #230 run_profile | FEATURE | Z28400-28402 | ERLEDIGT (Aufrufer in super, ce-intern nur TEILWEISE) | ExperimentDriver Opt-in |
| Phase 2 #221 RC-Setter | FEATURE | Z28403 | ERLEDIGT (5 reale Pfade) | abi_adapter.hpp:437-498 |
| Phase 3 #188 search_organ_ Entfernung | FEATURE | Z28404-28405 | ERLEDIGT (nur noch Kommentare, 0 lebende Deklarationen) | -- |
| Phase 4 #229-Kern (comdare_attach_generated_catalog, PilotEngine, golden_320_catalog) | FEATURE | Z28406-28413 | TEILWEISE lt. abend-2, siehe WIDERRUF abend-4 | -- |
| DEG-AP6-A: allocators/*.profile.xml (23 Akten) vom Parser nicht geladen | REGRESSION (vergessener Posten, 2x entdeckt 04.07.+22.07., nie im Ledger) | Z28415-28431 | OFFEN -- Entscheid noetig (Doku-only ODER Coverage-Gate-Test nachbauen) | xml_config_parser.cpp:79-80 |
| R4/R5/R6/R7 des Nacht-Audits 22.07. (im Ledger als "UNBELEGT" gefuehrt) | REGRESSION (Ledger stale) | Z28433-28442 | tatsaechlich BEHOBEN (Code-Belege gefunden); R9 kein Treffer, R3 nicht verifizierbar | experiment_plan_director.hpp, profile_run_facade.cpp, merge_plan.hpp, experiment_golden_kern.xml |
| SIMD-Katalog vollstaendig (6 Lenses, 32+64bit; 4-teilige Basis MMX/3DNow/3DNowExt/MMXExt; Punkt-Kollision sse4.1; 3 Namensraeume) | FEATURE (Recherche) | Z28444-28458 | GEKLAERT, fliesst in Grammatik v2 | docs/sessions/backups/20260807-explores-und-simd-katalog/ |
| XML-Roadmap-Doku stale (ABI-MAJOR==4 statt 8, main.cpp:513-521 existiert nicht mehr) | REGRESSION (Doku) | Z28460-28464 | OFFEN | docs/architektur/17_E4_XML_VOLLVISION_ROADMAP.md |
| Berichtigung 1: mindestens DREI Phase-Nummernkreise (Dossier16 Phase4=#31 zusaetzlich) | REGRESSION (Doku-Praezisierung) | Z28496-28512 | dokumentiert, Sprachregelung reicht nicht | LEDGER:812 |
| Berichtigung 2: Kausalzusammenhang Flag-Grammatik<->Phase4 war Interpretation, kein Beleg | REGRESSION (Praezisierung) | Z28514-28519 | markiert als Interpretation | -- |
| Berichtigung 3: Lead committet (09b85095) waehrend laufender Verifikation | REGRESSION (Prozessfehler, neue Facette Klasse 7) | Z28521-28533 | dokumentiert/Lehre gezogen | -- |
| Task #40 (Limits-Entkopplung/Phase4-XML) war als "entscheidungsfrei" gebucht | REGRESSION (Lead-Fehleinordnung) | Z28535-28549 | korrigiert: war OWNER-GATED (golden-heikel), GO stand aus | LEDGER:812 |
| WIDERRUF abend-4: Limits-Entkopplung IST VOLLZOGEN (Lead-Fehlbefund abend-2 falsch) | REGRESSION (Lead-Fehler, 3. Mal am Tag) | Z28553-28600 | GELANDET/bereits GEBAUT -- 3 Codebelege, GN-2/S26.6-Guard haerter als geplant | profile_run_entry.hpp:29, CMakeLists.txt:120-121, super CMakeLists.txt:30/48 |
| 3 gemeldete Luecken (attach nur Test, golden_320_catalog Alias, PilotEngine hardcodiert) | REGRESSION (Fehlbefunde) | Z28581-28594 | ALLE DREI FALSCH/widerlegt (a falsch, b Absicht=Messdaten-Erhalt, c kein Teil des Postens) | -- |
| Task #40 final | AUFGABE | Z28617 | ERLEDIGT (war Fehlbefund), Rest = Doku-Nachzug | -- |
| Roadmap 17_E4_XML_VOLLVISION bestaetigt STALE (ABI-MAJOR==4 statt 8, main.cpp-Andockpunkt weg) | REGRESSION (Doku) | Z28608-28615 | OFFEN -- einziger echter Bau-Rest | docs/architektur/17_... |
| Acht parallele Straenge (Owner-Auftrag abend-5): Flag-Grammatik-v2/allocators-Gate/Trigger-Restposten/PMC-Ehrlichkeit/Lageplan-Disponent/Stale-Doku/STOPP-Gates/Thesis-DE-EN | AUFGABE | Z28621-28665 | ANGELEGT, disjunkte Worktrees | 2 BAU-Branches: flag-grammatik-v2-s1, allocators-coverage-gate |
| abend-6: allocators/*.profile.xml als "vergessen" gebucht (abend-2) | REGRESSION (Lead-Fehleinordnung, 4. Mal ders. Klasse) | Z28669-28702 | WIDERLEGT -- alle 23 tragen DOKU-AKTE-Kopf, Frage 22.07. selbst beantwortet | -- |
| Kein Gate schuetzt allocators-Aktenbestand (Thesis-Tabelle 10 Profile) | AUFGABE | Z28704-28711 | ERKANNT (Grund: Abgabe-Beleg-Schutz) | -- |
| README allocators/ gedriftet "Mitglieder (10)" bei 23 realen Akten | REGRESSION | Z28712-28714 | OFFEN (dokumentiert) | -- |
| test_allocator_profile_bestand.cpp (205 Z., Bestands-Gate) | FEATURE/AUFGABE | Z28716-28722 | GEBAUT (Branch bau/allocators-coverage-gate, 077e6e61), wartet auf Landung | -- |
| Strang 8 Thesis DE/EN-Drift | AUFGABE | Z28728-28747 | ENTLASTET -- Drift klein, 100% Struktur-Paritaet, 0 Widersprueche | -- |
| Scheinfehler E_architecture_decisions.tex 2^17 vs 2^18-Erwartung | REGRESSION (Scheinfehler) | Z28749-28761 | AUFGEKLAERT -- Thesis rechnet richtig (persistence_target gepinnt); Empfehlung Halbsatz-Ergaenzung | source_catalog.hpp:135,139 |
| Strang 5 Disponent: weitere disjunkte Straenge gesucht | AUFGABE | Z28763-28772 | ERGEBNIS: nur 1 (= Strang 6, laeuft schon) | -- |
| Stichprobe "16 verwaiste Thesis-Alt-Kapitel" | REGRESSION (Scheinfund) | Z28776-28779 | ZERFALLEN -- laengst dokumentiert+Selbst-Marker seit bdd1e16 | -- |
| Stichprobe "Geschwister von allocators/" (sota/load_profiles/thesis_profiles) | REGRESSION (Scheinfund) | Z28780-28782 | ZERFALLEN -- alle 3 aktiv gelesen | -- |
| §58-REPLAY (kOrganAxisVersionLine) | AUFGABE | Z28783-28784 | bewusst NICHT vergeben (Kollision mit Flag-Grammatik-Schicht) | -- |
| git -C im Submodul-Worktree liefert Elternrepo-Pfad (wt-super-landung) | REGRESSION (Tooling-Falle) | Z28786-28791 | BESTAETIGT/dokumentiert, unabhaengig wiederentdeckt | -- |
| P-1 branch_misses nackte Null, kann strukturell nie "n/a" werden | REGRESSION | Z28800-28813 | BESTAETIGT -- latent, 0 Downstream-Konsumenten (nicht ausgeliefert) | pmc_source.hpp:24, M-3a |
| P-2 L3-auf-AMD Pfad A (golden/CI) | REGRESSION-Verdacht | Z28815-28820 | WIDERLEGT -- Guard haelt (n/a korrekt) | cache_engine_builder_iterator.hpp:828-842 |
| P-2 L3-auf-AMD Pfad B (f15_compare/measurement_snapshot.hpp) | REGRESSION | Z28821-28827 | BESTAETIGT -- behauptet faelschlich alle 6 real, aber latent (0 CI-Jobs) | measurement_snapshot.hpp:140-143 |
| P-3 P/E-Core-Trennung (HybridCorePinning) | AUFGABE/FEATURE | Z28829-28839 | BESTAETIGT OFFEN (Messung fehlt); Vorstufe Topologie-Erkennung HEUTE gebaut | numa_cpu_pin_process_probe_linux.hpp |
| SW-3 PMC-Preflight vier Wachen | REGRESSION | Z28841-28855 | UEBERWIEGEND GEHEILT (Wache1+2 geheilt/gelandet 8894d983, Wache3 Absicht, Wache4 jetzt sinnvoll) | ceb_pmc_compile_define() |
| Strang 9 bau/m3a-branch-misses-ehrlichkeit | AUFGABE | Z28867-28876 | LAEUFT (vierter Zaehler PERF_COUNT_HW_BRANCH_MISSES) | -- |
| T-A P3-TRIGGER-Blocker (Lese-Punkt toter Winkel bei resumiertem Lauf) | REGRESSION | Z28889-28900 | BESTAETIGT, tiefer als behauptet; BEHOBEN (lies_plan_werte an 2 Lesepunkten), Tests in CI | profile_run_facade.hpp/.cpp |
| T-D Dringlichkeits-Framing "vor erstem Batch" | REGRESSION (Lead-Fehler) | Z28902-28916 | FALSCH -- richtig ist "vor Voll-Messung"; Faktor16 aus 3 vermischten Ebenen (Organ-Fenster/System-Perms/line_size) | source_catalog.hpp, all_axes_golden.profile.xml |
| T-E Frist 08.08. | AUFGABE | Z28918-28922 | ENTLASTET -- keine aktive Stelle rechnet dagegen | -- |
| T-F acht Owner-Entscheide R-3/G-1..G-7 | OWNER-ENTSCHEID (Bestandsaufnahme) | Z28924-28941 | ALLE BESTAETIGT am Objekt | -- |
| G-7 LEDGER:7330 "cpe Bau-Auftrag ohne Entscheid" | REGRESSION/GESTRICHEN | Z28943-28948 | KORRIGIERT/UEBERHOLT (Flag-Grammatik 07.08. neu definiert, altes cpe existiert nicht mehr) | -- |
| Fail-closed-Wache fuer target_isa.numa_node/.page fehlt | AUFGABE | Z28951-28953 | OFFEN | validate_profile.hpp:1058-1071 |
| COMDARE_VARIANT_GATE funktional obsolet, nicht entfernt | REGRESSION/AUFGABE | Z28953-28958 | OFFEN (bestaetigt durch Ledger selbst) | anatomy_fingerprint.hpp:299-306 |
| ce 5adf59ea allocators-coverage-gate GELANDET | FEATURE | Z28964-28977 | GELANDET, 7 Bissproben rot->zurueckgebaut, gitleaks sauber | -- |
| KF-1-Reader fehlertolerant statt validierend (Falschaussage im Kommentar) | REGRESSION | Z28970-28974 | GEFUNDEN+BEHOBEN durch Biss B (Pflichtfeldpruefung ergaenzt) | -- |
| Agent-Verfahrensfehler git checkout -- README.md vor commit | REGRESSION (Prozess) | Z28975-28977 | erkannt, Lehre: erst committen dann bissen | -- |
| Drei Lizenz-Abweichungen Thesis<->Akte (michael_lockfree/tcmalloc/lrmalloc) | REGRESSION | Z28986-28996 | OFFEN fuer Owner (Gate faengt es nicht, anderes Repo) | -- |
| ext/A05-jemalloc getrackte Dublette | REGRESSION (Nebenbefund) | Z28996 | OFFEN | ext/allocator/A05-jemalloc |
| STOPP-GATES E-A..E-F Owner-Vorlage (537 Z.) | AUFGABE | Z28998-29001 | FERTIG, alle sechs OFFEN | docs/sessions/20260807-OWNER-VORLAGE-stopp-gates-E-A-bis-E-F.md |
| Plangrundlage STOPP-Gates (Format 3/8 Glieder) | REGRESSION (Plan stale) | Z29003-29009 | UEBERHOLT -- development traegt Format 4/9 Glieder (MessGatesGlied) | anatomy_fingerprint.hpp:106,369 |
| Empfehlung STOPP-Gates b/ii/b/a/b/a -> b/ii/a/a/a/a | OWNER-ENTSCHEID (Vorschlag) | Z29011-29020 | VORGESCHLAGEN (E-C entlastet, E-E verbilligt) | -- |
| E-E Fenster-0-Kosten (0 .fingerprint-Dateien) | AUFGABE | Z29022-29029 | teuerster Aufschub bestaetigt; 3 Unterfragen ungenannt | anatomy_fingerprint.hpp:120-123 |
| E-F Section43.b-Kollision (Planer keine Achsen-Arrays) | AUFGABE | Z29031-29034 | Owner-Bestaetigung noetig | planner_version.hpp:4-7 |
| STOPP-Doktrin deckt nicht E-A/E-F | REGRESSION (Doku-Luecke) | Z29036-29040 | dokumentiert | -- |
| E-x Namenskollision mit altem DD-A..DD-E-Satz | REGRESSION (Namenskollision, 3.) | Z29041-29044 | Vorschlag: Umbenennung VS-A..VS-F | -- |
| FLAG-GRAMMATIK v2 (Branch bau/flag-grammatik-v2-s1, ab0b352e+44397f58) | FEATURE | Z29048-29052 | GEBAUT, NOCH NICHT GELANDET (ctest-Lauf fehlt) | 181 Dateien, 2537+/1916- |
| Lead-Compiler-Beweis 4 static_asserts (Alt-Form schlaegt an, neue Form gueltig) | AUFGABE | Z29054-29063 | VERIFIZIERT, EXIT=0 | g++ -std=c++23 -fsyntax-only |
| Owner-Bedingung "Bruch muss LAUT sein" | OWNER-ENTSCHEID | Z29065-29073 | ERFUELLT -- static_assert an 6 realen Versions-Stellen | ce_owned_version_is_wellformed |
| Acht Regeln Flag-Grammatik-Parser (R1-R4+) | FEATURE | Z29075-29084 | COMPILE-TIME BEWIESEN je Regel Pos+Neg-Fall | -- |
| Bedeutungswechsel 'e' experimental->efficiency dokumentiert | AUFGABE | Z29085-29090 | GEBAUT, 0 Bestandsfaelle betroffen (Nenner erhoben) | -- |
| Repraesentation flach (array<FlagToken,96>) statt verschachtelt | FEATURE | Z29092-29097 | GEBAUT, Deckel am SIMD-Katalog bemessen (nicht geraten) | kMaxFlagNodes=96, kMaxFlagTokenLen=16, kMaxFlagDepth=4 |
| avx10.1/avx10.2 Punkt-Kollision (unbeauftragter Fund) | REGRESSION-Klasse | Z29100-29103 | BEHOBEN -- bricht laut statt still zu zerfallen | -- |
| Vor Landung offen: voller ctest-Lauf, Migrations-Geraten-Pruefung, Negativ-Test-Batterie-Schicksal | AUFGABE | Z29105-29110 | OFFEN (angefordert) | -- |
| FLAG-GRAMMATIK v2 GELANDET | FEATURE | Z29114-29128 | GELANDET (ce 5060489e, 422/422 gruen), Pipeline 15221 kritisch LAEUFT | 178 Dateien, 2518+/1553- |
| guard_all_registered_organ_versions() deckte NICHT organ_stamp_line<Comp> (jede Composition), 18x @0.0.0 durchgerutscht | REGRESSION (Luecke im eigenen Neubau) | Z29130-29140 | GESCHLOSSEN (static_assert an Stempel-Stelle, 4->7 static_asserts) | anatomy_version_stamp.hpp:125/185 |
| Knoten-Deckel 32 zu klein (echter Bedarf 58) | REGRESSION (Selbstkorrektur) | Z29147-29152 | BEHOBEN (auf 96 erhoeht, CT-Beweis Vollausbau) | -- |
| Negativ-Test-Batterie Q3 testete tote Regeln | REGRESSION | Z29153-29156 | NEU GEDACHT statt umgeschrieben (v1.0.0e zu Positiv-Probe gedreht) | -- |
| Migration 143 Bestands-Quellen (97x1.0.0.c+2x1.0.1.c+24x1.0.2.c+20 Nicht-Organ) | AUFGABE | Z29158-29164 | ERLEDIGT, Nenner exakt, kein Flag erfunden/weggelassen | -- |
| 2 Stellen Flag-Kombination erfunden (Testmaterial, kein Bestandsanspruch) | REGRESSION (Nebenbefund) | Z29165-29168 | dokumentiert, selbst gemeldet | hardware_meta_meta_axis.hpp:164, test_v41_...cpp:210 |
| Nicht gebaut (Flag-Grammatik v2, selbst gemeldet): Katalog-Wache S2, S3b unangetastet, cppcheck lokal nicht fahrbar, nur gcc-release keine clang/MSVC | AUFGABE | Z29189-29199 | OFFEN (mehrteilig) | -- |
| Owner-Entscheid MMX-Basis-Frage (Top-Level-Token vs eigene Basis) | OWNER-ENTSCHEID (angefragt) | Z29201-29204 | OFFEN | -- |
| Owner-Entscheid Praefix-Stripping-Kurzform x128{2.3.41.42} | OWNER-ENTSCHEID (angefragt) | Z29205-29206 | OFFEN | -- |
| Platz-Inventar 57GB risikofrei (21 Worktrees 38,47GB alle sauber+gemergt, stale builds ~5GB, comdare-web-builds 12,5GB) | AUFGABE (Analyse) | Z29210-29253 | VORLAGE (nichts geloescht) | -- |
| Zaehlfehler "lokale Maschine" vs prod1 (sind identisch, nur 2 Hosts) | REGRESSION (Zaehlfehler) | Z29214-29220 | KORRIGIERT, gebucht als Memory | -- |
| Sechs Worktrees KEIN Kandidat (Branch nicht gemergt) | AUFGABE/Info | Z29255-29261 | OFFEN (bei Loeschung unwiederbringlich) | wt-checkheft-nachtrag, wt-b-e18snap, wt-pmc-errno, wt-w2-E02-* |
| wt-ce-pmc als "nur lokal" im Inventar gelistet | REGRESSION (Inventar stale) | Z29258-29261 | UEBERHOLT -- Branch inzwischen gepusht | bau/m3a-branch-misses-ehrlichkeit |
| getrackte Messdaten-CSV im ce build/ | AUFGABE (Bestaetigung) | Z29263-29267 | BESTAETIGT versioniert, entkraeftet rm-build-Falle NUR fuer diesen Fall | build/thesis_tiere/tier150_measurements.csv |
| sudo/admin-management NOPASSWD nicht funktionsfaehig | REGRESSION (Infra) | Z29269-29274 | dokumentiert, nicht weitergeraten | -- |
| M-3a branch_misses real erhoben GELANDET | FEATURE | Z29278-29282 | GELANDET (ce 6a8ab995), 419/419 gruen ueber gemergten Stand | -- |
| Last-Design fuer branch_misses (Pointer-Chasing verworfen, xorshift64 gewaehlt) | AUFGABE | Z29284-29300 | VALIDIERT (Compiler-Barrier tragend, 3 Messungen) | -- |
| branch_misses AMD Zen5 Ergebnis 4.202.818 (50,1%) | FEATURE (Messung) | Z29302-29304 | VERIFIZIERT (clang-Gegenprobe 50,06%) | -- |
| M-3a-Gate Regression simuliert | AUFGABE | Z29305-29310 | Gate beisst (EXIT=1), Gegenprobe gruen | -- |
| pmc_available=1 UND branch_misses n/a-Unterscheidung | FEATURE | Z29311-29320 | GEBAUT (Flag traegt Unterscheidung, nicht Zahlenwert) | -- |
| PmcCounters POD-ABI-Grenze Feldzusatz | AUFGABE | Z29321-29328 | GEPRUEFT, unberuehrt (0 static_assert(sizeof) Treffer) | -- |
| PmcSystemAxis::do_collect mark_ok bei 0-Wert (AMD L3) | REGRESSION | Z29329-29334 | BEHOBEN (ueber Auftrag hinaus geschlossen) | system_axis.hpp:413 |
| PmcSourceAdapter::read_delta grobkoernige valid-Marke | REGRESSION | Z29332-29336 | BEHOBEN (per-Event-Gueltigkeit) | -- |
| CSV-Schema pipeline16 traegt nicht pmc_available | AUFGABE | Z29342-29347 | ZURUECKGEHALTEN -- Owner-Entscheid noetig fuer neue CSV-Spalten | -- |
| Vier rote Tests beim M-3a-Verify (EXCLUDE_FROM_ALL Generatoren) | REGRESSION (Falle, nicht Code) | Z29349-29353 | BEHOBEN durch expliziten Bau, keine Code-Regression | -- |
| Lead-Zahl "0 Treffer branch_misses-Konsumenten" | REGRESSION (Lead-Zaehlfehler) | Z29355-29361 | KORRIGIERT -- real 14+3 Treffer, alle im ce-Baum selbst | -- |
| P1 P/E-Core Bau | AUFGABE | Z29370-29452 | BEWUSST ANGEHALTEN (nichts gebaut, richtiges Ergebnis) | docs/plaene/20260807-DESIGN-pe-core-getrennte-messung.md |
| prod1 nicht Hybrid, aber Kern-asymmetrisch (X3D, 2 L3-Domaenen 96MB/32MB) | FEATURE (Erkenntnis) | Z29375-29390 | VERIFIZIERT, eigenes Cache-Engine-Ergebnis | -- |
| Topologie-Probe (L3-Domaenen-Erkennung+Pinning) | FEATURE | Z29392-29400 | GEBAUT, ehrlich (findet keine Hybrid-PMU, behauptet nichts) | -- |
| probe_numa_cpu_pin_process_topology() Produktionscode 0 Aufrufe | REGRESSION (unaufgerufener Code) | Z29402-29412 | BESTAETIGT -- Resolver fehlt fuer alle 3 RT-Unter-Achsen | hardware_probe_factory.hpp:481 |
| Lead-Vorschlag hybrid_core_aware "wahrheitsgemaess setzen" | REGRESSION (Lead-Vorschlag) | Z29414-29422 | ABGELEHNT vom Agenten (waere Feigenblatt), richtig so | i_measurement_source.hpp:55 |
| core_class als Stempel/Byte-Ereignis | AUFGABE | Z29424-29434 | KEIN Byte-Ereignis (dreifach belegt), Falle RT vs CT-Welt benannt | system_axis_registry.xml:10 |
| Ω-1/Ω-2/Ω-3 (Resolver-Zuschnitt/Ablage-Form/Scharfschaltung P/E) | OWNER-ENTSCHEID (angefragt) | Z29436-29445 | OFFEN, je mit Empfehlung | -- |
| G-8 echte PMU-Trennung ohne prod2 | AUFGABE | Z29447-29452 | UNERREICHBAR (wartet auf prod2/#207) | -- |
| Vor-Push-Wache vor_push_alle_wachen.sh (2-Punkt- statt 3-Punkt-Diff) | REGRESSION (Wache-Defekt, heute gebaut) | Z29461-29479 | BEHOBEN (962457b0, Drei-Punkt-Semantik) | -- |
| RESTPOSTEN 1 fail-closed target_isa.numa_node/.page/core_class fehlt | AUFGABE | Z29486-29502 | ABSICHT (vierfach belegt), NICHTS GEBAUT -- Resolver-Luecke OD-11-RT-K | xml_config_parser.hpp:234-235 |
| RESTPOSTEN 2 COMDARE_VARIANT_GATE "tot" | REGRESSION (Fehlannahme) | Z29504-29517 | KORRIGIERT -- wirkt (10 Fundstellen), steht als AP-11 in Aufraeumpass-Liste, Ledger:8161-8162 war ueberholt | build_orchestrator.hpp:702-703 |
| Kommentar "Cross-Maschinen-Gate ueber .variant-Mismatch" | REGRESSION (stale Kommentar) | Z29518-29523 | BEHOBEN ([NACHGEFUEHRT 2026-08-07]-Block, Mechanismus existiert seit A2-Eichung nicht mehr) | -- |
| S2-KATALOGWACHE (flag_grammar_catalog.hpp, 660Z, 104 static_asserts) | FEATURE | Z29530-29563 | GELANDET (ce 5788dc12), 419/419 gruen | 62 zugelassene+14 abgelehnte Token |
| Fall 4 MMX eltern_alternativ (6 offene Entscheide) | OWNER-ENTSCHEID (angefragt) | Z29556-29563 | OFFEN GEHALTEN, static_assert-gesichert | flag_catalog_offene_entscheide()==6 |
| 15 Bissproben+5 Positiv-Proben S2-Katalog | AUFGABE | Z29565-29574 | VERIFIZIERT, alle wie erwartet | -- |
| Drei Abweichungen von Lead-Vorgabe (aes/pclmulqdq=x128 nicht Companion; xop/fma4 nicht im Katalog; 3dnowprefetch=Skalar) | REGRESSION (Lead-Vorgabe falsch) | Z29575-29584 | KORRIGIERT durch Agent, jede belegt | -- |
| Wache schlug richtig an, berichtete falsch (algo_version ohne CPU-Basis trotz 'c') | REGRESSION | Z29585-29589 | BEHOBEN (8 Meldungen korrigiert) | -- |
| 3 Meldungstexte veraltet ("experimentelles e", "GENAU c/ce") | REGRESSION | Z29590-29591 | BEHOBEN (Erbstueck v2-Umbau) | -- |
| Nicht gebaut S2 (Doppelungen x512{f.f}, nackte Breiten-Basis, Abhaengigkeitsketten, Maschinen-Verfuegbarkeit) | AUFGABE | Z29593-29600 | OFFEN, namentlich benannt (nicht als geprueft ausgegeben) | -- |
| SHA-im-Auftrag als Momentaufnahme statt Basis-Berechnung | REGRESSION (Arbeitsfehler-Klasse 9) | Z29602-29613 | BEHOBEN/Regel gesetzt (Basis benennen statt beziffern) | -- |
| A9-S1 xlsx-Vendoring (libxlsxwriter/zlib gepruned, Lizenzen live erhoben) | FEATURE | Z29619-29644 | GELANDET (ce 351205f5), 420/420, gitleaks sauber | 767 KB ueber Spiegel |
| Diff-Hygiene-Wache pruefte nur ueber Dateiendung (20 Treffer alle Fremdcode) | REGRESSION (Wache-Defekt) | Z29629-29638 | BEHOBEN (Marker COMDARE-VENDOR-PROVENANCE.md statt pauschaler ext/-Ausnahme) | -- |
| A9-S2 (lager_pfad_grammatik.hpp konsumiert xlsx) | FEATURE | Z29641-29643 | offenbar bereits ERLEDIGT (Nebenfund) | -- |
| liburing in keiner Lizenzdatei trotz Snapshot seit 23.07. | REGRESSION | Z29644 | OFFEN, gehoert zu Task #42 | -- |
| §55-RECONCILE: 43 Meldungen = 36 unikate Posten | AUFGABE (Ledger-Konsolidierung) | Z29646-29650 | 5 VOLLZOGEN / 5 SUPERSEDED / 7 DUPLIKAT / 5 OWNER-FRAGE / 19 OFFEN / 2 NICHT ENTSCHEIDBAR | docs/sessions/20260807-RECONCILE-43-positionen-disposition.md |
| Sieben Duplikat-Paare (Vortriage nannte nur fuenf) | REGRESSION (Vortriage-Fehler) | Z29652-29654 | KORRIGIERT | #1-19,#3-26,#6-21,#12-40,#13-41,#14-36,#18-35 |
| #24 D-4 Fingerprint-Injektivitaet | FEATURE | Z29657-29660 | VOLLZOGEN (Audit hatte faelschlich als WIDERSPRUCH gefuehrt) | ceb_version_stamp.hpp:26-28,179-180 |
| #37 T-9 und #2 branch_misses | FEATURE | Z29661 | VOLLZOGEN (nach Audit-Erhebung gelandet) | -- |
| #3 "Anhaenge B/E nur 4-Zeilen-Stubs" | REGRESSION (Fehlbehauptung) | Z29662-29663 | WIDERLEGT (B=257/256, E=156/158 Zeilen) | -- |
| Ledger-Eintraege LEDGER:7885 (GN-9 als offen) und LEDGER:7016 (entlastet nicht-existenten xlsx-Writer) | REGRESSION (Ledger irrt beide Richtungen) | Z29665-29669 | dokumentiert, kein Ledger-Satz = Beleg | -- |
| Neun Kuerzel-Kollisionen (A15,O-A,D-4,R-2,F3,E18-SNAP,P-1,T-n,B-1) | REGRESSION (Namenskollision) | Z29670-29674 | tabelliert, P-1 schaerfste (KK-5 vs 30 Review-TODOs) | -- |
| Suchfalle grep 'ESET' ohne Wortgrenze (26 vs 0 Treffer) | REGRESSION-Klasse | Z29676-29678 | erkannt, haette #33 faelschlich erledigt gemeldet | -- |
| Stale-Thesis-Klon-Falle (main=29a1700 vs origin/development=eaf7fe8) | REGRESSION (Falle, wiederholt) | Z29679-29681 | erkannt | -- |
| A5/ETA-Kalibrierung | FEATURE | Z29699-29701 | GELANDET (ce 73f9a56f), 422/422 | -- |
| Lead-Lagebeschreibung "project_slice_eta_s kein Aufrufer" | REGRESSION (Lead-Ungenauigkeit) | Z29703-29712 | PRAEZISIERT -- war verdrahtet, aber ETA-Zweig ist Vorhaltung A-4, nie uebernehmbar | builder_registration.hpp:282-284 |
| BEFUND 1 A5: Merge verwirft stille periodische ETA-Fortschreibung | REGRESSION (hart) | Z29718-29729 | Fix: Schrieb je Block statt No-Op; OWNER-ENTSCHEID noetig (Konfliktaufloesung vs Ordnungsfeld) | test_a5_eta_kalibrierung.cpp:309,314 |
| BEFUND 2 A5: Live-Takeover-Pfad 30min-pauschal -> 1,5xETA | FEATURE (Verhaltensaenderung, benannt) | Z29731-29742 | GELANDET, als revidierbar markiert | -- |
| set_on_binary_done ueberschreibt Push-Pump-Hook | REGRESSION | Z29761-29765 | BEHOBEN (add_on_binary_done, mit Test) | -- |
| Kampagnen-Projektion 0 Produktions-Aufrufer (BatchReservierung ohne Perm-Feld) | REGRESSION (ehrlich gemeldet) | Z29768-29771 | OFFEN (Nachruesten = syntax_version-Bump) | -- |
| E-E OWNER-GO (Konkatenation, feste Achsen-Ordnung) | OWNER-ENTSCHEID | Z29782-29789 | ERTEILT (weicht von Lead-Empfehlung ab) | -- |
| Overlay-Naht Position 7/9 (kAnatomyFingerprintOverlayGlied) | FEATURE (teilweise) | Z29791-29800 | Naht GEBAUT, Fueller fehlt (COMDARE_OVERLAY_SOURCE_HASH="") | anatomy_fingerprint.hpp:407,106,125-127 |
| 2 von 3 E-E-Unterfragen (Sortier-Ordnung, Hash-vs-Konkatenation) | AUFGABE | Z29802-29814 | BEANTWORTET (existierender Code kCompositionAxisNames/kSystemAxisOrder) | -- |
| E-E Verzeichnis-Schnitt (welche Dateien = Overlay) | AUFGABE | Z29815-29829 | OFFEN, Vorschlag vorgelegt (topics/ vs ext/) | -- |
| Bruchliste E-E VIER Anker (kCebFingerprint war Lead-Liste nicht bekannt) | REGRESSION (Lead-Liste unvollstaendig) | Z29831-29837 | KORRIGIERT | test_d4_ceb_schluessel_wahl |
| Nebenbefund S1: StampGliedKategorie/kStampKategorieCount existieren nicht (Plan-Wache waere 8!=9) | REGRESSION (Plan-Luecke) | Z29854-29858 | Nachzug noetig, faellt sofort an | version_stamp_interface.hpp |
| FK-3/FK-4 (axis_error_traits.hpp 20 Familien, _organ.hpp 18 Slots T0-T17) | FEATURE | Z29862-29866 | GELANDET (ce f2709599), 424/424, 8 Bissproben | -- |
| Agent hatte {Failed} geraten, am Code korrigiert (observer_snapshot/pmc rufen mark_failed nie) | REGRESSION (Selbstkorrektur) | Z29870-29876 | BEHOBEN vor Landung | axis_error_traits.hpp:387 |
| Zwei eigene Fehler FK-3 (Separat-Header falsche Praemisse; Bissprobe faelschlich GRUEN nach clang-format) | REGRESSION (2x, selbst gemeldet) | Z29885-29892 | BEIDE BEHOBEN (Hermetik-Wache jetzt mit Anschlag-Nachweis) | -- |
| std::variant-Verbot Speicher-Mathematik-Begruendung (7,5TB vs 256-640GB) | FEATURE (Verifikation) | Z29899-29921 | EINGEHALTEN -- 68 Treffer geprueft, KEIN Verstoss (1 dokumentierte Ausnahme HybridDockVariant, noch nicht gebaut) | -- |
| Owner-Sidecar-Frage (.fingerprint/.version/.algos/.variant Sinnhaftigkeit) | OWNER-ENTSCHEID (beantwortet) | Z29923-29967 | .fingerprint+.version UNENTBEHRLICH, .algos+.variant technisch entbehrlich | -- |
| Owner-Plan-Stelle "alles in C++ in Binaries" nicht woertlich gefunden | AUFGABE | Z29962-29966 | EHRLICH NICHT GEKLAERT | -- |
| Versionierungs-Plan zitiert ueberholten golden-CRC (0xF1C1F26A1232073B statt 0x56F1B721C72DC10E) | REGRESSION (Plan stale, 3. Stale-Punkt) | Z29972-29982 | OFFEN (Korrektur noetig vor Bau) | source_catalog.hpp:187 |
| E-B: Owner-behauptete Lagerhaltungs-Planung fuer Namen-im-Symbol | REGRESSION/AUFGABE | Z29984-30005 | NICHT GEFUNDEN -- offen gemeldet statt konstruiert bestaetigt | -- |
| OWNER-FREIGABEN E-A bis E-F + Ω-1..Ω-3 | OWNER-ENTSCHEID | Z30045-30056 | ENTSCHIEDEN (E-A SHA256/E-B(i) CRC bricht/E-C mitziehen/E-D Ordnernamen/E-E Konkatenation/E-F honest-empty) | -- |
| Vier Punkte ohne Pauschalfreigabe (MMX-Basisfrage, Bau-Menge D-2, ETA-Merge-Konflikt, Lizenzen) | OWNER-ENTSCHEID (angefragt) | Z30073-30081 | OFFEN | -- |
| Frage: darf Lead die Thesis anfassen? | OWNER-ENTSCHEID (angefragt) | Z30082-30084 | OFFEN (ohne Wort nicht angefasst) | -- |
| NAS/Storage 3 Befunde widersprechen Owner-Anweisung (backup1.comdare.de-Host-Widerspruch, 8TB unbelegt, Runner duerfen NFS nie lesen) | REGRESSION | Z30086-30100 | OFFEN, vor jeder Ablage zu klaeren | scripts/copy_results_to_nas.sh:4 |
| Lager-Struktur A/B/C (18.07., GATED auf User-GO) | AUFGABE | Z30102-30116 | 6 offene Entscheidungen blockieren Aktivierung, Transport-Widerspruch (POSIX-Mount vs HTTPS-PUT) | -- |
| "buildsystem Ordner" existiert woertlich nicht (nur MinIO-Bucket buildsystem-cache) | REGRESSION (Begriffsklaerung) | Z30110-30111 | geklaert | -- |
| A12/E-14 NAS-Creds | AUFGABE | Z30113-30116 | OFFEN vor Abgabe (kein Vor-Trigger-Blocker) | -- |
| Erst-Klammerung Mess/System/Organ-Typen (19./20.07. Owner-Zitat + Sofort-Korrektur) | OWNER-ENTSCHEID (Rueckbeleg) | Z30127-30152 | gefunden, erklaert E-E-Vorgabe (keine Neuerfindung) | verlauf-23/24.txt |
| §43 als E-B-Begruendung (Stempel muss IN Binary, selektive Cache-Wiederverwendung) | OWNER-ENTSCHEID (praezisiert) | Z30154-30175 | belegt einkompiliert (ii), Symbolnamen-Form (i) ist Owner-Setzung darueber hinaus | LEDGER:2441 |
| Lager-Pfad-Grammatik (LB-0) Fortschreibung oder Neukonzeption von §43/§58? | AUFGABE | Z30184-30187 | OFFEN (nicht Wort-fuer-Wort verglichen) | -- |
| A3 ETA-System-Verstaendnis (Lease-Formel, 3-fach gehaertetes has_usable_eta) | AUFGABE | Z30191-30221 | VERIFIZIERT am Code | eta_estimator.hpp:32-43 |
| Q3 Merge-Konflikt-Dringlichkeit | REGRESSION (eigene Ueberzogenheit) | Z30223-30235 | ENTSCHAERFT -- heute kein Live-Pfad, gehoert ins F5-Paket | -- |
| last_update_utc-Feld (loest Merge-Konflikt+Uhr-Anker in einem Zug) | FEATURE (Design-Vorschlag) | Z30237-30250 | VORGESCHLAGEN, noch nicht gebaut | -- |
| ETA-Verbraucher fuer Disposition/Kapazitaetswert | OWNER-ENTSCHEID (angefragt) | Z30252-30261 | OFFEN | avg_size_bytes ungenutzt |
| A8-Praemissen (Cross-VLAN, Cluster_NFS write-only, Ziel backup1) | REGRESSION (3 Praemissen falsch) | Z30263-30279 | WIDERLEGT (prod1 hat 3 Beine, rw verifiziert, Ziel ist backup2 nicht backup1) | -- |
| Kapazitaet backup2 (nicht 16TB sondern 7,3T/6,5T frei) | REGRESSION (Kapazitaetsannahme) | Z30270-30272 | KORRIGIERT -- 8TB passen NICHT | -- |
| A8 Mount-Blocker (kein sudo NOPASSWD) | AUFGABE | Z30276-30279 | OFFEN zu diesem Zeitpunkt (siehe abend-27) | -- |
| E-E Overlay-Glied (711 Dateien, 12 static_assert) | FEATURE | Z30285-30290 | GELANDET (ce a2b928eb), 428/428 | -- |
| A6 NAS-Kommentar "backup1 abgeschaltet" | REGRESSION | Z30289 | WIDERLEGT am Objekt, korrigiert | -- |
| lint:static-Heilung (cppcheck-suppress falsche Zeile + nur-erster-Fehler-je-Datei) | REGRESSION (2 Fehler in erster Heilung) | Z30292-30313 | BEIDE BEHOBEN, rc=0 Volllauf | ci-templates/base-pipeline.yml:337 |
| vor_push_alle_wachen.sh meldet cppcheck faelschlich "lokal nicht vorhanden" | REGRESSION (Wache-Defekt) | Z30315-30319 | erkannt (Tool existiert exakt in CI-Version), Fix in abend-29 | -- |
| Drei weitere eigene Fehler abend-26 (2 Agenten auf altem Checkout 14 Commits zurueck, E-E gegen unvollstaendigen Bau 4/424 rot, rc=$? nach Pipe) | REGRESSION (3x selbst gefangen) | Z30321-30331 | ALLE BEHOBEN (428/428 nach Korrektur) | -- |
| Platte 97%->frei (7 build/-Verzeichnisse entfernt) | AUFGABE (Wartung) | Z30333-30337 | ERLEDIGT, 0 Datenverlust (getrackte CSV via git checkout -- build/ erhalten) | -- |
| OWNER-ENTSCHEID F4: mmx bleibt deklariert (RISC-V VisionFive2 relevant) | OWNER-ENTSCHEID | Z30339-30347 | ENTSCHIEDEN | -- |
| A8 NAS lesbar+schreibbar, reboot-fest (backup1+backup2) | AUFGABE | Z30351-30372 | VOLLZOGEN (Owner loeste Blocker durch Passwort-Commit) | /etc/fstab noauto,x-systemd.automount |
| F1 8TB passen NICHT auf backup1 (19T/15T belegt/3,6T frei) | REGRESSION (Kapazitaet hart belegt) | Z30384-30402 | BESTAETIGT kritisch; Weg zu mehr Platz (sort/gharchive) = Owner-Entscheidung | -- |
| Eigener Fehler: Vault-Wert (samba-comdare-socks-pw) ins Transkript geraten | REGRESSION (Sicherheitsvorfall, selbst gemeldet) | Z30404-30414 | gilt als kompromittiert, Rotationsliste; Regel gebucht (Vault nie greppen) | -- |
| A9 Jitter-Review Achsen-Kern | AUFGABE | Z30418-30491 | SAUBER -- compile-time dispatcht wie Doktrin verlangt (L1-L6 Klassen geprueft) | origin/development fea430d0 |
| Ein virtueller Aufruf im heissen Pfad (tier_insert, architektonisch erzwungen fuer ABI-Faehigkeit) | REGRESSION (kein Fix ohne Architekturwechsel) | Z30440-30452 | DOKU-Auflage (Pfad A immer, Pfad B nur Fuellstand) | host_measure_loop.hpp:43-47 |
| Toter V32-Demo-Pfad (std::function, nur Kommentar-Erwaehnung) | REGRESSION | Z30454-30461 | BESTAETIGT tot, kein Fix noetig | execute_engine_command.hpp:51 |
| Unverdrahtetes Geruest (12 Engine-Interfaces c01-c12 etc, 465 virtual-Treffer teils tot) | AUFGABE (Aufraeum-Kandidat) | Z30463-30469 | kein Risiko, aber Rauschen | -- |
| cppcheck-Gate in vor_push_alle_wachen.sh | FEATURE/REGRESSION-Fix | Z30494-30521 | GELANDET (ce db6cc047), beide Richtungen bewiesen (mit/ohne Koeder) | -- |
| K13 Koeder-muss-erst-beissen (3x faellig an einem Tag) | REGRESSION-Klasse | Z30524-30533 | Lehre gebucht | -- |
| A1 Medien-Basis m64 (MMX+3DNow als eine Gruppe, nicht x64) | FEATURE | Z30545-30575 | GELANDET (ce 15522cdc), 428/428, Entscheide-Zaehler 6->0 | -- |
| N-1 mmxext falsch unter -m3dnowa katalogisiert | REGRESSION (Katalog-Fehler) | Z30563-30566 | BEHOBEN -- korrekt -msse | -- |
| Zwei Nachbesserungen A1 (clang-format 2/3 abweichend, Testzahl 424 vs 428 Reihenfolge-Fehler) | REGRESSION (2x) | Z30568-30576 | BEIDE BEHOBEN | -- |
| A4 Thesis nachgezogen (B1 ADR-2 Pinning, B2 Lizenzen 8 Fundorte, B3 Flag-Grammatik v2, B4 branch_misses) | AUFGABE | Z30577-30596 | GELANDET (thesis 798e946), DE 204/EN 194 Seiten, chktex 0 | -- |
| Zwei Erweiterungen ueber A4-Auftrag hinaus (Namens-Ebene statt Namens-und-Suffix; 4 statt 3 generische Zaehler) | REGRESSION (Korrekturen) | Z30585-30589 | BEIDE korrekt eingearbeitet | -- |
| Eigener Fehlalarm grep -ci warning auf .blg (BibTeX-Statistikzeile) | REGRESSION (Teilwort-Falle) | Z30594-30596 | erkannt, 0 echte Warnungen | -- |
| A2 Permutationen (Einschraenkungsfaktor 3.972; Paper-Repliken 132; prod1 1.572.864; prod2 1.048.576) | AUFGABE (Analyse) | Z30598-30631 | GERECHNET | -- |
| Paper-Kopplung heute NICHT verdrahtet (0 statt 132, drop_tier_level zieht ab) | REGRESSION | Z30613-30619 | BESTAETIGT, ehrliche Antwort "heute 0" | -- |
| Fuenfter D-2-Kandidat 917.504 (7 base_tiers x 2^17) uebersehen | REGRESSION (fehlender Kandidat) | Z30620-30623 | ERGAENZT (wird aktiv bei build_axis_levels) | -- |
| compare vergleicht heute nichts | REGRESSION/FEATURE-Luecke | Z30624-30625 | static_assert bestaetigt (Etikett-Stand, Vollzug D2) | run_methodology_registry.hpp:144-148 |
| L3-Asymmetrie prod1: 8 physische Kerne je Domaene (nicht 16) | REGRESSION (eigene Korrektur) | Z30627-30629 | KORRIGIERT, verdoppelt Messungen nicht Binary-Zahl | -- |
| PHASE 6 ist STOPP nicht Ziel (vierfach belegt, Phase 5 autonom) | AUFGABE/OWNER-Klaerung | Z30633-30651 | GEKLAERT -- Phasen 1-3 gelandet, Phase 4 vollzogen, Phase 5 nicht begonnen | -- |
| F1 Kapazitaetsfrage abschliessend (backup1 3,6T+backup2 6,5T=~10,1T; 16T existiert nirgends) | AUFGABE | Z30655-30678 | BEANTWORTET (8TB nur verteilt moeglich) | -- |
| git describe Suffix als Datumsangabe missverstanden | REGRESSION (Falle, gefangen) | Z30691-30698 | erkannt, kein Alarm noetig, Falle gebucht | -- |
| F1 GELOEST: Buildsystem-Volume (Comdare-Buildsystem, 20T/15T frei) | AUFGABE GELOEST | Z30702-30743 | Owner stellt dritten Export bereit, verdrahtet+verifiziert | 10.0.20.241:/nfs/Comdare-Buildsystem |
| Export-Reichweite Unterschied (Buildsystem auf *, Cluster_NFS nur V20) | REGRESSION-relevante Beobachtung | Z30720-30732 | dokumentiert (Isolationsbegruendung greift hier nicht) | -- |
| Frage 2: A03/michael_lockfree LGPL in KEINEM Bau aktiv (3 unabhaengige Blocker) | AUFGABE (beantwortet) | Z30746-30799 | BEANTWORTET -- kein LGPL-Objektcode in Abgabe-Artefakt | COMDARE_HAVE_MICHAEL_LF ohne Setzer |
| Verbleibende Frage Sperrvermerk/Veroeffentlichung LGPL-Repo-Text | AUFGABE | Z30774-30777 | OFFEN (eigenstaendige Frage) | -- |
| Namenskollision Schalter-Familien (ext/ CACHE FORCE ueberschreibt adapters/) | REGRESSION (Nebenbefund) | Z30780-30786 | dokumentiert, betrifft hoard/mimalloc/jemalloc/tcmalloc/snmalloc/scalloc | -- |
| golden_fullpilot_131072_binary_ids.txt referenziert aber fehlt (bewusst, Repo-Bloat) | REGRESSION (2 Agenten widersprachen sich) | Z30787-30792 | AUFGELOEST -- Absicht, kein Fehler | source_catalog.hpp:178 |
| Namenskollision fast als Bug gemeldet | REGRESSION (Fehleinschaetzung) | Z30801-30826 | KORRIGIERT -- ist Absicht (zwingende Compile-Belange snmalloc/mimalloc) | CMakeLists.txt:641-654 |
| Restrisiko stale CMakeCache-Eintrag (bereits einmal passiert bei mimalloc) | REGRESSION-Klasse | Z30828-30834 | bekannt, Gegenmassnahme = frisches Build-Verzeichnis je Messung | -- |
| OWNER-KERN Messkette 3 Stufen 6 CEBs + `cache_engine --check-size` | OWNER-ENTSCHEID (Feature-Auftrag) | Z30838-30926 | AUFTRAG ERTEILT, noch nicht gebaut | -- |
| Ruege "Rechne diese bitte NIE mehr pauschal nach" | REGRESSION (Lead-Verfahrensfehler) | Z30840-30846 | Regel: Zahl gehoert ins Programm (--check-size), nicht in den Kopf | -- |
| Warum Bau-Menge kleiner ist (XML-Freigabe/Bau!=Mess-Menge/Full-Join je Achse) | OWNER-ENTSCHEID (Klaerung) | Z30860-30867 | GEKLAERT | -- |
| PAPER = ein Experiment-XML (Missverstaendnis "Kandidaten" korrigiert) | OWNER-ENTSCHEID | Z30869-30882 | GEKLAERT -- keine Kandidaten, nur XML-Ermittlung je Paper | -- |
| Messkette 3 Stufen (Checkpoints Micro/Macro/combined load) | OWNER-ENTSCHEID (Spec) | Z30884-30911 | SPEZIFIZIERT | -- |
| 3 Stufen 6 CEBs (3! Permutationen Messfuehler-Elimination) | OWNER-ENTSCHEID (Spec, klaert "5. Ebene"-Frage) | Z30901-30911 | GEKLAERT (nicht 5, war Lead-Fehler) | -- |
| Break-Even Spline B=3, als String serialisierbar+parsbar | OWNER-ENTSCHEID (Spec) | Z30913-30926 | SPEZIFIZIERT, Fortsetzung angekuendigt | -- |
| Experiment-B+-Baum = Vergleichs-Ordnung (Geschwister-Vergleich gleiche Tiefe) | OWNER-ENTSCHEID (Kernkonzept) | Z30929-30956 | SPEZIFIZIERT, erklaert Erst-Klammerung 19./20.07. | -- |
| Auswertungs-Schleife (sequentiell jede Achse durchpermutieren gegen andere Paper) | OWNER-ENTSCHEID (Spec) | Z30958-30968 | SPEZIFIZIERT | -- |
| Break-Even-Konsolidierung (heuristik:: + best_binary:: zusammenfuehren) | OWNER-ENTSCHEID | Z30970-30974 | ENTSCHIEDEN (kein Entweder-Oder) | -- |
| Nachbau-Regel: Messung ohne Bau-Material = Warnung+Nachbau (fail-open) | OWNER-ENTSCHEID | Z30976-30982 | ENTSCHIEDEN | -- |
| Fuenf Mess-Ebenen vollstaendig (Planer-CLI/Pruefdock-Gesamt/Pruefdock-Interface/Macro/Micro) | OWNER-ENTSCHEID (Spec, Frage 5 beantwortet) | Z30984-31003 | SPEZIFIZIERT, klaert Stufen-vs-Ebenen-Verwechslung | -- |
| Vier Entscheide in einer Nachricht (Planer-Interpreter loest Baum-Pfad ab; Paper-Kopplung ja bauen; LaTeX in Abgabe; Textbausteine jetzt erlaubt trotz Habich H3) | OWNER-ENTSCHEID (4x) | Z31005-31011 | ENTSCHIEDEN | -- |
| Owner versteht Lead-Fragen 4/9/10/11/12 nicht (zu kryptisch) | REGRESSION (Lead-Kommunikationsfehler) | Z31013-31018 | erkannt, Fragen neu zu stellen | -- |
| Mess-Baum 3 Ebenen (Wurzel/Macro/Micro) vs Experiment-Baum -- Verwechslungsgefahr | OWNER-ENTSCHEID (Spec) | Z31022-31047 | SPEZIFIZIERT, ausdruecklich getrennt | -- |
| 6 CEBs Begruendung (Messfuehler ist Verbraucher, Elektrotechnik-Analogie) | OWNER-ENTSCHEID (Spec) | Z31049-31059 | SPEZIFIZIERT (Planer-Auftrag) | -- |
| Break-Even dreimal (Micro/Macro/combined, je Baum-Knoten-Tiefe) | OWNER-ENTSCHEID (Spec) | Z31061-31077 | SPEZIFIZIERT | -- |
| Flattern ist Signal fuer Hybriden, keine Hysterese noetig | OWNER-ENTSCHEID (Korrektur Lead-Annahme) | Z31079-31092 | GEKLAERT -- Stufe1 mittelt, Stufe2 sucht Flattern gezielt | -- |
| Erstes TODO: Groesse Gesamtexperiment erheben (Planer, in CEB berechnet) | AUFGABE | Z31094-31097 | OFFEN ("Wir kennen die Groesse nicht genau") | -- |
| Schicht-Doktrin GO (Gattung->Genus->Implementierungen, container_framework.hpp verletzt sie) | OWNER-ENTSCHEID | Z31100-31107 | GO FUER SOFORT | anatomy/container_framework.hpp:37 |
| Weiter NFS-Export ist gewollt (alle Maschinen bedienen Lagerhaltung, V60 sollen direkt mounten) | OWNER-ENTSCHEID | Z31113-31123 | ENTSCHIEDEN, Lead-Befund entkraeftet aber Absicht bestaetigt; Explore-Auftrag offen | -- |
| LGPL-Frage erledigt (Habich-Freigabe, wird ohne Sperren verwendet) | OWNER-ENTSCHEID | Z31125-31131 | Task #42 GESCHLOSSEN | -- |
| Check-Size-Bericht Befund 1: Paper-Auftrag 3 Monate alt, 2/3 erfuellt (33 SOTA-Profile, kein Experiment-XML je Paper) | REGRESSION/AUFGABE | Z31136-31144 | Faden am 20.07. gerissen (faelschlich als "post-v3" gebucht) | profile_ref geparst, nie dereferenziert |
| Check-Size-Bericht Befund 2: nur max 2 von 6 CEBs heute herstellbar (macro/micro nicht trennbar) | REGRESSION (echter Konflikt) | Z31146-31154 | BESTAETIGT, kein Versaeumnis (Doktrin nennt Grenze selbst) | mess_achsen_naht.hpp |
| Check-Size-Bericht Befund 3: Break-Even 4 Forderungen alle nirgends (3 statt 2 Code-Orte, x=Last statt x=Zeit) | REGRESSION | Z31156-31164 | Nullbefunde mit Gegenprobe; Datenquelle (Checkpoint-Spalte) fehlt auch | heuristik/, curve_fit/, best_binary_selector/ |
| Check-Size-Bericht Befund 4: --check-size 3 Entwuerfe fielen durch (Planer=Groesse, CEB=Dauer) | AUFGABE/FEATURE (Aufloesung) | Z31166-31181 | GEKLAERT -- liefert nebenbei erste Messfehler-Messung | -- |
| F-3-Alarm (Trennung der Mess-Combos als "Regression") | REGRESSION (eigener Fehlalarm) | Z31187-31194 | ZURUECKGENOMMEN -- Halbsatz nicht gelesen, kein Konflikt | all_axes_golden.profile.xml:220-226 |
| Echter Blocker: G2/G3 teilen ein Gate (macro/micro heute nicht trennbar) | REGRESSION/AUFGABE | Z31196-31209 | benannter Rueckstand, Folgepaket noetig (G3 aus STATISTICS-Gate loesen) | mess_achsen_naht.hpp:81-95 |
| OWNER-KERN Record-and-Replay als Mess-Vertrag (Aufruf/Zeitpunkt/Zustand als Snapshot) | OWNER-ENTSCHEID (Spec) | Z31211-31223 | SPEZIFIZIERT | -- |
| OWNER-KERN Release = Rekonstruktions-Anfrage, kein Bau-Modus (Binaries muessen nicht aufbewahrt werden) | OWNER-ENTSCHEID (grosse Konsequenz) | Z31225-31240 | SPEZIFIZIERT -- entlastet Platzfrage vollstaendig | -- |
| XLSX-Definition existiert seit 26.07., Writer fehlt (Owner-Ruege 5x gesagt) | REGRESSION (Lead-Versaeumnis) | Z31249-31258 | A9-S1 gelandet, S3/S4/S5 nie begonnen | -- |
| Sheet-Definition 3 Fassungen (26.07. Kern=Gesetz, 02-03.08. Dossier, 06-07.08. Mess-Profil) | FEATURE-Spec | Z31260-31283 | SPEZIFIZIERT, Bruecke zw. Fassung1/2 und 3 offen | -- |
| WritebackMethod-Registry ohne xlsx-Wert | REGRESSION/AUFGABE | Z31298-31303 | FEHLT -- Schalter unwirksam ohne 4. Registry-Wert | writeback_method_registry.hpp |
| Datei-Flut (320 Einzel-CSV je Binary + aggregierte) | REGRESSION | Z31305-31309 | BELEGT | cache_engine_builder_iterator.hpp:1119-1126 |
| CSV XOR XLSX Kanon (strategy pattern, xlsx default) | OWNER-ENTSCHEID | Z31311-31317 | ENTSCHIEDEN (05.08.) | LEDGER:4163-4166 |
| A9-Bauliste (S2 halb, ergebnis_dateiname.hpp/S3 IErgebnisBlatt/S4 CLI/S5 Erstbeleg alle fehlen) | AUFGABE | Z31319-31335 | GROSSTEILS OFFEN, Schnitt: Fassung1/2 jetzt bauen, Fassung3 wartet | -- |
| Overleaf-Zeiger Code/external/20260931-overleaf-diplomarbeit als "tot" gemeldet | REGRESSION (Lead-Fehlbefund) | Z31341-31354 | KORRIGIERT -- bleibt, ist Vertrag fuer CI+Lokal-Sync, .gitmodules-Kommentar veraltet | -- |
| LEDGER §75 Zustand ("kritisch halb fertig"?) | AUFGABE | Z31356-31360 | zu ermitteln (Owner-Auftrag) | main.cpp:359,432 |
| Code/tools/ verbotene Behelfswege, offizieller Bauweg configure.sh/make/make install/make check | OWNER-ENTSCHEID | Z31362-31385 | ENTSCHIEDEN, Repo-Grenze super=Anwender vs ce=Framework | -- |
| tier150_measurements.csv archivieren (nicht loeschen) | OWNER-ENTSCHEID/AUFGABE | Z31387-31391 | ENTSCHIEDEN | -- |
| OWNER-ENTSCHEID Blattform (Fassung 3): CSV flach mit Zeitraeumen, XLSX compare/Macro/Micro-Sheets, Blattzahl=1+Funktionen+Achsen | OWNER-ENTSCHEID (grosse Spec) | Z31395-31466 | VOLLSTAENDIG SPEZIFIZIERT, Mess-Baum = Aufruf-Stack | -- |
| Separater Messpunkt Gattungs-Interfaces (Macro-Gesamt minus Summe Micros) | OWNER-ENTSCHEID (Spec) | Z31446-31456 | SPEZIFIZIERT, muss separat gemessen werden | -- |
| A9-S3-Bau Folgen (2 Blatt-Familien Ergebnis+Profil, gleiche Factory) | AUFGABE | Z31458-31466 | GEKLAERT, kein Widerspruch | -- |
| OWNER-NACHTRAG Aufrufer=Prozess+Thread, Visitor-Pattern, N-1 bis N-7 (Stack-Bewegung, IN/OUT-Checkpoints, INVARIANTE Regression bei IN-ohne-OUT) | OWNER-ENTSCHEID (Spec) | Z31470-31567 | VOLLSTAENDIG SPEZIFIZIERT | -- |
| §75 Kandidatenliste 12 Tage stale (Commit 813c3232 entfernte Kandidaten ohne §75-Bezug) | REGRESSION (Ledger-Prozess) | Z31571-31600 | BESTAETIGT "kritisch halb fertig" -- Ist-Stand je Kandidat geprueft (teils entfernt, teils unveraendert) | b4be362f0, 813c3232 |
| §75 Kandidaten an 14 Quellen verstreut (nicht 4) | REGRESSION (Ledger-Prozess) | Z31610-31625 | VOLLZOGEN 08.08.: zentrale Liste 133 Kandidaten (104 offen/14 erledigt/8 gesperrt/6 unbelegt/1 widerlegt) | docs/plaene/20260808-KANDIDATENLISTE-75-... |
| §75-Kette zerrissen (3 kollidierende Nummernkreise, Anker grossflaechig gewandert) | REGRESSION | Z31627-32100 (Zitat) | dokumentiert (a/b/c-Befunde) | -- |
| 5 Flaechen erklaeren sich selbst fuer tot, sind aber NICHT frei entfernbar | REGRESSION | Z31642-31645 | erkannt (Test/Bauweg haengt dran) | -- |
| scheduling_strategy.hpp Selbstaussage "0 Konsumenten" | REGRESSION (Kommentar falsch) | Z31644-31645 | WIDERLEGT -- 2 Konsumenten real (davon static_assert-Wache) | test_striktheit_axis_dach_guard.cpp:81 |
| OWNER-ENTSCHEID: checkpoint_measure(...,IN\|OUT) ist EINE uniforme Funktion (C-1 bis C-6) | OWNER-ENTSCHEID (Spec) | Z31659-31742 | SPEZIFIZIERT -- CT-Tag, Sparsamkeit hart, Thread-lokale Puffer empfohlen, Ueberlauf=Befund | -- |
| OWNER-ENTSCHEID: eigener Stacktrace statt std::stacktrace, Ebene als CMake-Flag (C-7 bis C-13) | OWNER-ENTSCHEID (Spec) | Z31745-31851 | SPEZIFIZIERT -- Rekonstruktion O(n), Kosten im Hot-Path null | -- |
| Lead-Schaetzung C-5(b) (clock_gettime 20-25ns, rdtsc 10x billiger) | REGRESSION (eigene Schaetzung falsch) | Z31801-31822 | KORRIGIERT -- gemessen: steady_clock 16,5ns, rdtsc 6,8ns (Faktor 2,4 nicht 10) | prod1, GCC 15.3 |
| C-13 drei offene Bau-Detailfragen (Mess-Ebene je Target eindeutig? Gattungs-Interface-Ebene? Ebenen-Flags=CEB-Gates ein Mechanismus?) | AUFGABE | Z31841-31851 | OFFEN, vor CMake-Flag-Bau zu klaeren | -- |
| OWNER-ENTSCHEID: virtuelle Thread-Slots, ein int genuegt (C-14 bis C-17) | OWNER-ENTSCHEID (Spec) | Z31854-31907 | SPEZIFIZIERT -- kein OS-Aufruf, statische Slot-Puffer | -- |
| C-17 Fehlerfall "mehr Threads als Slots" | AUFGABE | Z31903-31906 | OFFEN, braucht benannte Fehlerklasse (laut scheitern) | -- |
| E-E-Zyklus-Heilung falsch beschrieben (Bericht + Gitlink-Commit super 56ffab37) | REGRESSION (Lead-Fehlbeschreibung) | Z31910-31982 | RICHTIGGESTELLT -- Wache statt Ausnahme, Codegen erbt Kante nicht mehr (Wurzel geheilt) | cmake/overlay_source_hash.cmake:105-118 |
| Lead-vorgeschlagener Heilungsweg (Ziel von Kante ausnehmen) | REGRESSION (Lead-Vorschlag unsicher) | Z31927-31933 | VERWORFEN vom Agenten (haette still gegen veralteten Header uebersetzen koennen) | -- |
| OWNER-KERN: Defekt wird behoben, egal wie gross (Dauerregel) | OWNER-ENTSCHEID | Z31985-32016 | ENTSCHIEDEN -- Lead-Klausel "melden statt bauen" gestrichen | -- |
| OWNER-KERN: xlsx ist Ausgabe, Skip bei gleicher Binary, CSV NIE (7x wiederholt) | OWNER-ENTSCHEID | Z32020-32058 | ENTSCHIEDEN -- Skip-Logik ueber Fingerprint-Identitaet | -- |
| Lead-Befund result.csv trunc ohne Sicherung = Doktrin-Verletzung | REGRESSION (Fehlbefund, falscher Gegenstand) | Z32046-32049 | KORRIGIERT -- result.csv ist internes Zwischenformat, CSV produktiv nie verwendet | cache_engine_builder_iterator.hpp:2800 |
| OWNER-KERN Fortsetzung: Skip gilt auch fuer Binaries, EIN Baum fuer beide (Preimage/Grammatik/Policies) | OWNER-ENTSCHEID | Z32061-32100 | ENTSCHIEDEN, am Code bereits so gebaut | lager_baum_writer.hpp:1-45 |
| Ebenen-Reihenfolge je Realm verschieden (Messdaten vs Binaries) | AUFGABE (2 Lesarten) | Z32090-32100 | nicht selbst entschieden, benannt statt uebergangen | -- |
| Baum-Frage bestaetigt: EIN Writer (LagerBaumWriter), ZWEI Policies (Binaries/Messdaten) | FEATURE (bestaetigt) | Z32109-32126 | KONFORM, zweite Lead-Lesart (Kaskade=Defekt) GESTRICHEN | lager_baum_writer.hpp:76,387,419,454-455,533-534,600 |
| Restfrage "synchron angelegt" (create_directories nur an einer Stelle) | AUFGABE | Z32128-32132 | zunaechst offen gefuehrt, dann geklaert (siehe naechste Zeile) | :482 |
| "synchron" ist konzeptionell, angelegt wird LAZY, ZWEI Durchlaeufe (Bau dann Messung) | OWNER-ENTSCHEID (Klaerung) | Z32134-32157 | BEANTWORTET als NICHT-Luecke -- 2 getrennte Praefix-Zaehler (kompiliert/gemessen) | -- |
| W0b-1/D3-3 Rueckschrieb (persist:measurements Commit-Gate ueber datenzeilen_gesamt) | AUFGABE | Z32159-32174 | GELANDET (4e0b7e0d), T-1 11/11 gehalten, Selbstbiss 4/4 | ci/persist_sammler.sh |
| git add -- measurement/ staged falschen Laufordner (Fall P11, Mutant m4) | REGRESSION (zweiter Defekt, gleich mitgeheilt) | Z32168-32169 | BEHOBEN (git add -- "$DEST") | -- |
| Netz-Push-Retry-Pfad und prebackup()-Kollisionspfad (return 3) | AUFGABE | Z32173-32174 | UNGEDECKT, ausdruecklich benannt | -- |
| Schwesterstelle ci/anhang_forward_core.sh (3 Stellen derselben Fehlerklasse: Z133/Z167/Z226) | REGRESSION | Z32181-32194 | BESTAETIGT, Liegenlassen PLAN-KONFORM (gegatet OV-17, Pfad doppelt tot) | -- |
| "Push->gruen verifizieren" GitLab-Instanz HTTP 500 auf allen authentifizierten Pfaden | REGRESSION (Infra-Blocker) | Z32196-32207 | BELEGT+VERBUCHT, Modus a reaktiviert, offene Batch-Schuld Pipelines 4e0b7e0d..HEAD | docs/sessions/20260809-INFRA-HANDOVER-... |
| github/development hinter origin (5 Folge-Landungen nur auf origin) | REGRESSION (Dual-Remote-Drift) | Z32205-32207 | BEHOBEN (github zieht mit 4e0b7e0d nach) | -- |
| W0b-1/D3-3 Restbogen (D3-7, D3-1-Resthaelfte, D3-4+D3-5 OV-16, ##20+D3-6 OV-17, D3-8) | AUFGABE | Z32209-32210 | OFFEN, mit Besitzer gefuehrt (W0b-1/D3-3 selbst ABGESCHLOSSEN) | -- |

## ENDE SEGMENT -- Datei endet bei Zeile 32210 (Auftrag nannte 32300, Ledger ist kuerzer)
