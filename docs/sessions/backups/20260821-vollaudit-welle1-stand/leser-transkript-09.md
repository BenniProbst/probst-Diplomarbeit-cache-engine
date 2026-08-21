# Sammelstrecke — Leser 09 (gruppe_09.txt)

Quelle: `/home/comdare/.claude/jobs/5a19728e/tmp/vollaudit/gruppe_09.txt`
Umfang: KONTEXT-FENSTER 12 (Z20032-Z21996), 1197 Zeilen gesamt.

| KUERZEL/Name | Klasse | Quelle | Status LAUT QUELLE | Traeger/Task |
|---|---|---|---|---|
| `checkpoint_measure` uniforme Funktion (IN/OUT compile-time Tag, Aufrufer-Tripel, eigener Stacktrace, virtuelle Thread-Slots) | FEATURE | Z20032 Summary Pkt.2/Owner-KERN 1 | GEPLANT (spezifiziert, nicht gebaut) | Owner-KERN 08.08. |
| C++23 `<stacktrace>` Recherche (GCC 15.3+clang 22.1, `__cpp_lib_stacktrace 202011`) | AUFGABE | Z20032 Pkt.3, Z46 | GEBAUT (Research abgeschlossen, Ergebnis: NICHT verwendet, eigenes Stacktrace) | Assistant/Research |
| Owner-KERN: xlsx IST die Ausgabe, CSV NIE verwendet; valider Bestand=SKIP; neue Binary-Version=neuer Datensatz daneben | OWNER-ENTSCHEID | Z20032 Pkt.4/Owner-KERN 3 | GESETZT | Owner |
| Owner-KERN: EIN Storage-Tree im Code, ZWEI FS-Wurzeln (binaries/measurements), lazy, ZWEI Durchläufe (bauen dann messen) | OWNER-ENTSCHEID | Z20032 Pkt.4/Owner-KERN 4 | GESETZT | Owner |
| Owner-KERN: „wenn es einen Defekt gibt, egal wie groß, muss er behoben werden" | OWNER-ENTSCHEID | Z20032 Owner-KERN 2 | GESETZT | Owner |
| `ledger_nachtrag.sh` (NEU, POSIX sh, Nachtrag nach Kopf statt Dateiende) | FEATURE | Z44 | GEBAUT (dreimal eingesetzt) | Assistant |
| `ce docs/architecture/20260808-checkpoint_measure_soll_design.md` (NEU, 269 Zeilen) | FEATURE | Z46 | GEBAUT (Design/Spec) | Assistant |
| cppcheck-Auswertung Fix in `vor_push_alle_wachen.sh` (Nenner nennt jetzt N Befundzeilen + M Severity error) | REGRESSION | Z48-54 | BEHOBEN (ce `2f8aba58`) | Assistant |
| `pmc_counter_outcome.hpp` (NEU, B-5, enum PmcCounterOutcome: EventNichtVorhanden, ZugriffVerweigert, NichtGelesen) | FEATURE | Z56-63 | GEBAUT, gepusht nicht gelandet (`3910b9e9`, B-5 Runde 1) | Agent B-5 |
| CMake-Zyklus an Wurzel (`overlay_source_hash.cmake`, `_comdare_overlay_gen_schliessung` als WACHE/FATAL_ERROR statt Ausnahme) | REGRESSION | Z65 | BEHOBEN (`52e9f3ba`) | Assistant |
| Doktrin v3.1 (`super docs/ARBEITSWEISE-GESAMT-DOKTRIN.md`, 552 Zeilen, +153 additiv: A2.0 REIHENFOLGE, V11 BELEGZEILE, A2 Landungsklassen, A3 gitleaks, A1 kein effort-Feld) | FEATURE | Z38-43 | GELANDET (super `cd802dfe`) | Assistant |
| Python-SyntaxError beim Übergabe-Nachzug (Anführungszeichen im Text) | REGRESSION | Z78 | BEHOBEN (Datei-basierter Ansatz) | Assistant |
| `git add` mit bereits verschobenem Pfad bricht Aufruf ab, `2>/dev/null` verschluckt es (Commit enthielt nur Rename) | REGRESSION | Z79 | BEHOBEN (`--amend`); gleicher Fehler erneut bei Agent `b5176877`, von ihm selbst gefunden | Assistant + Agent |
| gitleaks über Worktree: „no leaks found" bei 0 commits scanned | REGRESSION | Z80 | BEHOBEN (echter Klon nachgeholt, dann Umstellung auf Push-Bereich mit `--config` Pflicht im stdin-Modus) | Assistant |
| `rc=$?` nach Pipe misst `tail` statt gitleaks; `gitleaks git -C /repo` existiert nicht | REGRESSION | Z81 | BEHOBEN (Teil der Push-Bereich-Umstellung) | Assistant |
| Grüne Pipeline als Beleg genommen, in der `build:clang` übersprungen war (3 statt 14 Jobs) | REGRESSION | Z82 | BEHOBEN/korrigiert (echter Beleg `51eebbfe`/`56ffab37` success, `a9a0754c` failed) | Assistant |
| Zyklus-Heilung falsch beschrieben („Ausnahme aus dem Graphen abgeleitet" statt Wache) | REGRESSION | Z83 | RICHTIGGESTELLT (Ledger super `743b93da`) | Agent + Assistant |
| Falsche Ausschluss-Liste an Agent übergeben („string_view-Konstruktor funktioniert") | REGRESSION | Z84 | BEHOBEN (Agent maß selbst nach: bricht bei 3 wie bei 24 Zeichen) | Agent |
| Testzahl ohne Nenner weitergegeben (432 statt „428 mit -LE pmc") | REGRESSION | Z85 | BEHOBEN (korrekte Zahl 428 dokumentiert) | Assistant |
| `result.csv` statt xlsx analysiert | REGRESSION | Z86 | BEHOBEN (nach siebenmaliger Owner-Korrektur) | Assistant |
| Zwei Memories ohne Index-Eintrag (wären nie geladen worden) | REGRESSION | Z87 | OFFEN-REGRESSION (Befund, kein expliziter Fix in diesem Abschnitt) | Assistant |
| Workflow gestartet trotz „warte erst" | REGRESSION | Z88 | BEHOBEN (gestoppt) | Assistant |
| main-FF auf laufende Pipeline (Fehler wiederholt beim Audit-Befund-Nachholen) | REGRESSION | Z89 | BEHOBEN (super korrekt auf belegt-grünen Stand `2a830103`, 14 Jobs statt `cb4a2f38` mit 3 Jobs) | Assistant |
| Thesis-Stolperstelle fälschlich als Lücke geführt (Erklärung stand im selben Satz: 18 Achsen, 1 gepinnt, 17 frei=2^17) | REGRESSION | Z90 | RICHTIGGESTELLT (keine echte Lücke) | Assistant |
| `waiting_for_resource` fälschlich als „Wache wirkt" gedeutet | REGRESSION | Z91 | RICHTIGGESTELLT (Agent maß live: drei Pipelines standen still) | Agent |
| Behauptung „pmc:intel seit 06.08. rot" | REGRESSION | Z92 | WIDERLEGT (auf development durchgehend grün, 9 Pipelines) | Assistant |
| Wellenplan gestoppt und nie neu gestartet | REGRESSION | Z93 | BEHOBEN (Owner musste fragen, dann neu gestartet — Pending Tasks: läuft) | Assistant |
| Wache mit unvollständigem Nenner: `run_all_tests.sh` (13x NOT FOUND, exit 0) | REGRESSION | Z101 | BEHOBEN | Assistant |
| Wache mit unvollständigem Nenner: `build:clang` (`COMDARE_CLANG_MATRIX` in ce nirgends gesetzt — Job lief NIE) | REGRESSION | Z101 | BEHOBEN | Assistant |
| Wache mit unvollständigem Nenner: cppcheck-Anzeige (rotes Verdikt, leere Liste) | REGRESSION | Z101 | BEHOBEN | Assistant |
| Wache mit unvollständigem Nenner: Handliste verschluckte 2 Tests (429 vs 431) | REGRESSION | Z101 | BEHOBEN | Assistant |
| §75-Kandidatenliste: 133 Kandidaten, 104 offen; „wer nur den Ledger liest, sieht 74 von 92" | AUFGABE | Z103 | OFFEN (104 von 133) | Assistant/§75 |
| Zehn Owner-Entscheide vom 07.08.: fünf entlastet (R-1, R-2, R-3, G-6, G-7) | OWNER-ENTSCHEID | Z105 | TEILWEISE ERLEDIGT (5 von 10 entlastet) | Owner/Assistant |
| Platte 94%->86% durch `git clean -xfd build/` in fertigen Worktrees | AUFGABE | Z107 | BEHOBEN | Assistant |
| GitHub-Spiegel Nachzug (33+54, dann 7 Commits) | AUFGABE | Z109 | GEBAUT, aber veraltet strukturell (kein CI-Job synchronisiert) | Assistant |
| Owner: Thread ist systemisch Visitor in allen Mess-Ebenen; Thread betritt Interface ohne Verlassen = Regression | OWNER-ENTSCHEID | Z113 | GESETZT | Owner |
| Owner: checkpoint_measure(...,IN/OUT) inline Steuerzeile auf globalem memory stack, uniforme Funktion | OWNER-ENTSCHEID | Z114 | GESETZT | Owner |
| Owner: Aufrufender = Prozessname + aufrufende Funktion auf Stack + Thread-Nummer | OWNER-ENTSCHEID | Z115 | GESETZT | Owner |
| Owner: eigenes C++ stacktrace, nicht std::stacktrace; Filterung Macro/Micro, Compare/Macro | OWNER-ENTSCHEID | Z117 | GESETZT | Owner |
| Owner: checkpoint_measure komplett compile-time; virtuelle Thread-Slots (Obergrenze=Thread-Unterachse) | OWNER-ENTSCHEID | Z119 | GESETZT | Owner |
| Owner: Thread-Nummer als Laufzeit-Variable, „Ein int tut es", Registrierung gegen custom ID | OWNER-ENTSCHEID | Z120 | GESETZT | Owner |
| Owner: binaries/measurements teilen sich denselben Lagerhaltungs-Baum, nur unterschiedliche factory/detail pattern | OWNER-ENTSCHEID | Z122 | GESETZT | Owner |
| Owner: Realms per Filesystem getrennt, Strategy-Storage-Tree im Code derselbe, zwei FS-Wurzeln synchron gepflegt | OWNER-ENTSCHEID | Z123 | GESETZT | Owner |
| Owner: Wurzeln konzeptionell synchron, real lazy angelegt; Binaries zuerst, Messungen im zweiten Durchlauf | OWNER-ENTSCHEID | Z124 | GESETZT | Owner |
| Owner: „Alles korrekt, Bitte Zwischenstandsdoku reich" | OWNER-ENTSCHEID | Z125 | GESETZT | Owner |
| Owner: Präzisierungen wirken sich auf xlsx-Writer aus, alle Workflows prüfen/updaten; Blanko-GO; Regressionen in Session dokumentieren; nur unauflösbare Entscheidungen vorlegen | OWNER-ENTSCHEID | Z126 | GESETZT | Owner |
| Owner: Featureliste aus Ledger -> Code-Review -> Diff -> neuer Wellenplan, mit ultracode, Fable 5 max effort | OWNER-ENTSCHEID | Z127 | GESETZT | Owner |
| Owner: „Bitte warte einmal die Fertigstellung ALLER workflows ab" | OWNER-ENTSCHEID | Z128 | GESETZT | Owner |
| Owner: Audit gegen eigene Arbeitsweise fahren, Sequenz Gedächtnis-Review-Explore-Design-Bauen-Verify | OWNER-ENTSCHEID | Z129 | GESETZT | Owner |
| Owner: „Bitte stelle mir Rückfragen und alle jetzt noch offene Entscheidungen hier." | OWNER-ENTSCHEID | Z132 | GESETZT | Owner |
| Wellenplan-Workflow (`w1buo8hac`, Run wf_0c3dafdf-4c9, 6 Phasen ~24 Agenten) | AUFGABE | Z139 | GEPLANT/läuft | Workflow |
| Vergessene-Arbeit-Workflow (`wdtdyqbmh`, Run wf_293c0ffc-c6e, liest 300-MB-Session davor) | AUFGABE | Z140 | läuft | Workflow |
| B-5 Runde 2 (PMC-L3-Heilung): PMU-Auflösung als Mechanismus (Intel-Hybrid), Spalte `pmc_l3_miss_uncore_systemweit`, Richtigstellung zu `5c102e05` | AUFGABE | Z141 | OFFEN | Agent B-5 |
| A9-S4/S5 | AUFGABE | Z142 | VERTAGT/im Landeanflug (3 Commits auf `bau/a9-s4-mess-report`) | Assistant |
| `checkpoint_measure` BAUEN | AUFGABE | Z143 | OFFEN (spezifiziert, nicht gebaut) | offen |
| G-1 (sechs STOPP-Gates, Empfehlungen b/ii/b/a/b/a) | OWNER-ENTSCHEID | Z144 | OFFEN | Owner ausstehend |
| G-2 (T19-Semantik) | OWNER-ENTSCHEID | Z144 | OFFEN | Owner ausstehend |
| G-3 (Welle C) | OWNER-ENTSCHEID | Z144 | OFFEN | Owner ausstehend |
| G-4 (Welle D) | OWNER-ENTSCHEID | Z144 | OFFEN | Owner ausstehend |
| G-5 (Enum, ABI-Ereignis) | OWNER-ENTSCHEID | Z144 | OFFEN | Owner ausstehend |
| Board-Posten: `--check-size`, compare-Stufe D2, LaTeX-Anlage, Paper-Research, L3-Asymmetrie-Messung, zwei Bäume im Buildsystem, Phase 5 | AUFGABE | Z145 | OFFEN | offen |
| PMC-DIAG Zeilen fehlen im CI-Trace (`pmc:intel`, Job 368144, 533 Zeilen; null Treffer PMC-DIAG/perf_event_open/errno) | REGRESSION | Z151 | OFFEN-REGRESSION („Eine Diagnose, die im Fehlerfall nicht sichtbar ist, ist keine.") | Assistant |
| PMC-FEHLER: COMDARE_ENABLE_PMC einkompiliert, Quelle meldet available=0 (missing_pmc_cols=0 pmc_available=0 counters_all_zero=1 pmc_expected_by_build=1 pmc_seam_ok=0, SMOKE_FAIL, prod2 i9-12900K hybrid, perf_event_paranoid=1) | REGRESSION | Z154-164 | OFFEN-REGRESSION (Klasse `NichtGelesen`/Multiplexing-Verdrängung identifiziert, Bestand kann Fall nicht benennen) | Agent B-5 Runde 2 |
| pmc:intel flaky (SHA `0ef4ef4f`: development #15343 SUCCESS 13:52:37-52, main #15349 FAILED 13:57:26-45, gleicher Runner, kein PMC-Job überlappte aber lint:static+sanitize:asan-ubsan parallel) | REGRESSION | Z166 | OFFEN-REGRESSION (betrifft Phase 6, Owner-Frage 1 gestellt) | Assistant |
| m3v2-Vermutung (Assistant) war falsch | REGRESSION | Z168 | WIDERLEGT (Agent widerlegte am Objekt, `2b5ecd29` auf main) | Assistant/Agent |
| PMU-Typ-Kodierung: Kernel-Header (`PERF_PMU_TYPE_SHIFT`) generische Kodierung in unteren 32 Bit | FEATURE | Z168 | GEPRUEFT/bestätigt als richtiger Weg | Agent B-5 |
| Warnung: nicht-existenter PMU-Typ wird NICHT abgewiesen, Kernel fällt still zurück (`type=9999 -> wert=1`) | REGRESSION | Z168 | GEFUNDEN, OFFEN-REGRESSION | Agent B-5 |
| XML-Wohlgeformtheit heilen (5 XML-Dateien, darunter beide Thesis-Profile + System-Achsen-Registry) | AUFGABE | Z184-199 | GESTARTET (Agent general-purpose, background) | Agent |
| Explore: die 5-Prozent-Regel | AUFGABE | Z198-200 | GESTARTET (Agent Explore, sonnet) | Agent |
| Explore: Zielgroessen je Achse | AUFGABE | Z201 | GESTARTET (Agent Explore, sonnet) | Agent |
| CI main-FF bei Gruen | AUFGABE | Z202 | GESTARTET (Agent general-purpose) | Agent |
| Worktree-Aufraeumung (47 -> 9 Baeume, Platte 88%->79%, 51G frei) | AUFGABE | Z207-228 | BEHOBEN/erledigt | Assistant |
| 4 Worktrees mit Submodulen anfangs von git abgelehnt (wt-b14-golden, wt-b-graph, wt-b-honest-empty, wt-super-zyklus) | REGRESSION | Z217-227 | BEHOBEN (nach Submodul-Deinit entfernt, alle dirty=0 orphan=0 geprueft) | Assistant |
| Wellenplan-Dokument vorliegend (420 Zeilen, Stand 2026-08-08, TEIL C Wellen 0/A/B/C/D/E/F) | FEATURE | Z236-237 | GEBAUT (Planungsdokument) | Assistant |
| G-4 GEFUNDEN: „k" ist die Cluster-Anzahl beim Workload-Clustering (Ursprung Deep-Research-Befund 09.07., Sektion 3; seit 07.08. echter Code-Parameter) | OWNER-ENTSCHEID | Z292-296 (Task #66) | ERLEDIGT/GEFUNDEN | Assistant/Explore |
| XML-WOHLGEFORMTHEIT GEHEILT (ce 90a31961, super 49114430) — golden-Profil der Abgabe; 2 der 5 Dateien maschinell erzeugt, Generatoren schrieben Defekt mit, beide Generatoren mitgeheilt | REGRESSION | Z255, Z294-295 (Task #67) | BEHOBEN | Agent |
| GitLab-Projekte sind `private` (286/288/289), nicht public — nur GitHub-Spiegel public | AUFGABE | Z216 | GEKLAERT/festgestellt | Assistant |
| Deploy-Key statt statischem Token/OIDC recherchiert (OIDC nur fuer Drittdienste, deploy key = saubere Trennung) | AUFGABE | Z216-234 | GEBAUT/recherchiert | Assistant |
| B3: die fuenf querschneidenden Mess-Ebenen (Owner-Ausloeser) | FEATURE | Z219, Z220 | dokumentiert (Session-Ergaenzung) | Assistant |
| Session-Dokument `20260808-SESSION-zielgroessen-katalog-alle-19-achsen-erklaert.md` | AUFGABE | Z268-291 | GEBAUT/GELANDET (super `2dbb85c6`) | Assistant |
| Zielgroessen-Katalog `axis_optimization_catalog.hpp` (45 Zielgroessen ueber 19 Achsen, Min/Max-Richtung je Achse) | FEATURE | Z260 | GEBAUT (existiert bereits im Code), Katalog-Luecke gefunden (Detail Z400-cut) | Assistant |
| PMC-Agent-Korrektur: `[PMC-DIAG]`-Zeilen werden NICHT ausgeloest (nicht: erreichen Trace nicht) — Diagnose fehlt fuer Lese-Fehlschlag, nur fuer Oeffnen vorhanden | REGRESSION | Z261 | RICHTIGGESTELLT (fruehere Assistant-Aussage korrigiert); Kern-Luecke OFFEN-REGRESSION | Agent B-5/Assistant |
| Owner: „Bitte dokumentiere ALLE Erkenntnisse dieser Session und der letzten 5 Kontexte nochmal separat als reiche Session, also Widerlegte Befunde und Learnings" | OWNER-ENTSCHEID | Z297 | GESETZT | Owner |
| Ultracode-Workflow „erkenntnisse-fuenf-kontexte" (8 Sammler, Transkripte+Sessions+119 Tagescommits, Task woyg2c61o) | AUFGABE | Z301-303 | GESTARTET | Workflow |
| Wellenplan-Ergebnis: 23 Agenten, 6,24 Mio Tokens, 369 SOLL-Posten, 211 IST geprueft, 103 IST-Luecken (27 fehlt/14 nur spezifiziert/62 teilweise), 39 Regressionen, 46 Skeptiker-Einwaende (20 tragend) | FEATURE | Z304-332 | GELANDET (super `a6f1e1b6`) | Workflow/Assistant |
| Fuenf blockierende Defekte (D1-D5), schaerfster: Drift-Gate erklaert degenerierte Messung bei Median 0 fuer stabil | REGRESSION | Z311, Z353 (Task #69) | OFFEN-REGRESSION | Assistant |
| Owner BLANKO-GO: „Bitte arbeite alles autonom ab... blanko volles GO alle zukuenftigen Phasen autonom abzuarbeiten...wirklich ALLE am Stueck" | OWNER-ENTSCHEID | Z324 | GESETZT | Owner |
| Memory `feedback_blanko_go_alle_phasen_autonom_am_stueck` (NEU) | AUFGABE | Z326-330 | GEBAUT | Assistant |
| Owner Antwort Frage 1: Messlauf sobald funktionsfaehig unter eigener Empfehlung durchfuehren, volles GO, Aufwands-Berechnung als Task nach Planung aufnehmen | OWNER-ENTSCHEID | Z365 | GESETZT | Owner |
| Owner Antwort Frage 2: Deploy Key ja, NUR privates CI-Template (nicht public sichtbar, nicht in public Diplomarbeit-Repos), Keys im Cred-Vault, volles GO | OWNER-ENTSCHEID | Z365 | GESETZT | Owner |
| Owner Antwort Frage 3: HYBRID ist Pflicht — neue Gattung HEURISTIK-ADAPTER + Genus „Function-Interface-Reroute"; Hybrid-Tier-Binary erbt compile-time Interfaces von Gattung+Genus, heuristisch durchgestellt; eigene Macro-Benchmarking-Schicht (3->4 Mess-Ebenen bei Hybrid); misst Overhead des Hybrid-Tier-Reroutes am Hybrid-Pruefdock; Gattung/Achse darf andere Gattungen aufrufen; Heuristik-Tier-Binary-Strategie in SearchAlgorithm als Heuristik-Hybrid-Achse aufrufbar -> Tier-Binary-Aufbau oder heuristischer Mehrfachaufbau im Hybrid-Binary | OWNER-ENTSCHEID | Z331 | GESETZT (volles GO, alles Pflicht) | Owner |
| Memory `project_hybrid_heuristik_adapter_gattung_reroute_genus` (NEU) | AUFGABE | Z333-334 | GEBAUT | Assistant |
| Memory `feedback_deploy_key_nur_privates_ci_template_nie_in_public_repos` (NEU) | AUFGABE | Z335-336 | GEBAUT | Assistant |
| Ledger-Nachtrag: BLANKO-GO + drei Owner-Entscheide — HYBRID ist eine GATTUNG, nicht Sonderstufe | AUFGABE | Z396-399 | GELANDET (super `05181169`) | Assistant |
| Task #51: PHASE 6 IST FREIGEGEBEN (Owner 08.08. abends) | AUFGABE | Z347-348 | aktualisiert/pending | Assistant |
| Task #52: `--check-size` IST JETZT VORBEDINGUNG DER MESSPLANUNG | AUFGABE | Z349-350 | aktualisiert/pending | Assistant |
| Task #68: HYBRID = Gattung HEURISTIK-ADAPTER + Genus Function-Interface-Reroute — Pflicht, 0% | AUFGABE | Z351-352 | OFFEN (0% begonnen) | offen |
| Task #69: D1-D5 — fuenf blockierende Defekte zwischen heute und belastbarer Messung | AUFGABE/REGRESSION | Z353-354 | OFFEN | offen |
| XML-Heilung Landung ce (Merge sauber, 160 XML / 0 kaputt; Wache `ci_xml_wellformed_guard` 160/0 gruen, Koeder 161/1 rot) | REGRESSION | Z356-363, Z417-426 | BEHOBEN/GELANDET | Assistant |
| super-Seite: an Gitlink gekoppelte Ausnahme in `golden_n_consistency_check.cmake:101` (`PROFILE_ALLOW_COMMENT_TEX...`), selbst-zurueckziehend | REGRESSION | Z364-372 | BEHOBEN (Zeile entfernt, Historie im Kommentar) | Assistant |
| D3: measure:golden-320 Erfolgsbedingung defekt — Zeile gibt Zeilenzahl aus statt zu pruefen (urspr. 910/911, im frischen Baum 796/797 bzw. 885/886) | REGRESSION | Z377-388 | BEHOBEN (eigener Baum `bau/d3-leeres-messfenster`) | Assistant |
| `ci/mess_ausbeute_wache.sh` (NEU, Werkzeug statt zwei kopierter Zeilen) | FEATURE | Z390-397 | GEBAUT (sechs Koeder inkl. Positiv-Fall alle wie erwartet) | Assistant |
| ce-Bau (XML-Zweig) fertig, exit 0 | AUFGABE | Z475 | GEBAUT/GRUEN | Assistant |
| ctest ueber gemergten XML-Stand: 429/429 gruen, Nenner deckt sich | AUFGABE | Z438-439 | BEHOBEN/GRUEN | Assistant |
| Login-Unterbrechung (mehrere `/login`-Versuche, dann erfolgreich) | REGRESSION | Z403-427 | BEHOBEN (Login successful) | System |
| Owner: „Bitte resume alle fehlgeschlagenen Agenten, Pause ist beendet und mein letzter Befehl zum Durchziehen gilt wieder." | OWNER-ENTSCHEID | Z428 | GESETZT | Owner |
| Eigene Fehldiagnose: Workflows als abgebrochen gemeldet (48/8 bzw. 19/18), tatsaechlich liefen sie noch (Zeitstempel 45s/3min alt) | REGRESSION | Z432-437, Z588 | RICHTIGGESTELLT (kein Resume ausgefuehrt, laufende Arbeit nicht abgeschnitten) | Assistant |
| XML-Heilung ce gelandet auf `development` (`25fe4fbf`) | AUFGABE | Z444-448 | GELANDET | Assistant |
| XML-Heilung+Gitlink super gelandet (`2983e9ba` auf Zweig, final `4a9d3d02`) | AUFGABE | Z458-464 | GELANDET | Assistant |
| `rc=$?` nach Pipe misst `tail` statt `cmake` (eigene bekannte Falle erneut) | REGRESSION | Z621 | BEHOBEN (richtig gemessen: ohne Ausnahme rc=0, mit Koeder rc=1) | Assistant |
| D3 (measure:golden-320 Erfolgsbedingung) gelandet | REGRESSION | Z687 | BEHOBEN/GELANDET (super `ce7d4007`) | Assistant |
| D4: Drift-Gate — `if (v.median_ns > 0)` sonst `relative_drift=0.0`, `unstable=false`; DriftVerdict kennt keinen Zustand „unbestimmbar" | REGRESSION | Z489-500, Z691-700 | BEHOBEN (ce, gelandet `09d627c1`) | Assistant |
| Test `ZeroMedianGuardNoDivisionByZero` zementierte den Defekt (`EXPECT_FALSE(v.unstable)` bei Null-Messung) — dieselbe Klasse wie `m3v2_pmc_smoke` | REGRESSION | Z714 | BEHOBEN (Test umbenannt + 4 neue Faelle ergaenzt, 14/14 gruen) | Assistant |
| Nicht-ASCII-Zeichen (→, —) in eigenen Diff-Zeilen des D4-Fixes | REGRESSION | Z759-761 | BEHOBEN (3 Zeilen auf ASCII) | Assistant |
| clang-format „OK" faelschlich gemeldet (`&&` lief trotz Fehlschlag weiter) | REGRESSION | Z809 | BEHOBEN (Gegenprobe ohne `&&`, alle Dateien formatiert) | Assistant |
| D4 Beweis am Objekt: alter Code `stable=JA` bei reiner Null-Messung (1 Versuch, 0 Reruns, Warn-Log leer); neuer Code `stable=nein`, 3 Versuche, 2 Reruns, Warnung | REGRESSION | Z772-781 | BEHOBEN (beide Richtungen belegt) | Assistant |
| Eigener Fehlalarm: ctest-Zahl 429 blieb trotz 4 neuer Testfaelle gleich | REGRESSION | Z793-801 | WIDERLEGT/KLARGESTELLT (`comdare_add_test` registriert 1 ctest-Zeile je Binary, nicht je gtest-Fall; 14 Faelle laufen mit) | Assistant |
| D4 gelandet (ce `09d627c1`) | REGRESSION | Z820-823 | BEHOBEN/GELANDET | Assistant |
| Task #69 Update: „D1-D5: ZWEI GEFALLEN (D3 super ce7d4007, D4 ...)" | AUFGABE | Z553-554, Z826-827 | in_progress | Assistant |
| D1 „make check ohne Reconfigure" | REGRESSION | Z558-871 | FEHLBEFUND/WIDERLEGT (Agent las Kette falsch; `check: inventar`, `inventar: all` mit Reconfigure war schon im Basis-Commit; empirisch 429 vor/nach Bau identisch) | Assistant |
| D2: `comdare_adhoc_emitter_cli` wird von keinem ce-CI-Job gebaut (0 Vorkommen in `.gitlab-ci.yml`), zwei Tests fehlen selbst im lokal gebauten Baum | REGRESSION | Z862-869 | BESTAETIGT/ECHT, OFFEN (braucht echten Bau zur Heilung) | Assistant |
| Ledger-Nachtrag D1-Richtigstellung + D2-D4-Stand gelandet (super `e5ac6f9d`) | AUFGABE | Z877-878 | GELANDET | Assistant |
| Fuenf ce-Pipelines laufen, B-5-Landung (15370) gruen bestaetigt | AUFGABE | Z881-884 | GRUEN/bestaetigt | Assistant |
| Erkenntnisse-Workflow-Ergebnis (Task woyg2c61o): 8 Quellen, 381 Befunde roh/eindeutig, 1 bestaetigt, 1 gefallen, 9 ungeprueft, 316 Learnings, 103 Nichtfunde | AUFGABE | Z589-593 | GELANDET/dokumentiert (Ergebnis-Dokument in tasks/woyg2c61o.output) | Workflow |
| Drei verify-Agenten des Erkenntnisse-Workflows gescheitert (`verify:stale-doku-als-ist`, `verify:werkzeug-identitaet-geraten`, `verify:werkzeug-nicht-im-pfad`) — Session-Limit erreicht (reset 18:50 UTC) | REGRESSION | Z597-599 | OFFEN (Infra-Limit, nicht inhaltlich verifiziert) | Workflow |
| Widerruf „eine CEB je PMU-Domaenen-Satz" (Owner-Korrektur: CEB tragt beide Messfuehler, legt Ergebnisse je PMC getrennt ab, Wiederverwendung durch Achsen-Permutation; zweimal gepinnt gestartet wird die Tier-Binary, nicht die CEB) | REGRESSION | Z592 | BEHOBEN/WIDERRUFEN (Lead-Quittung 22:02:57 uuid `c4f2053e`; Code `numa_cpu_pin_process_probe.hpp:112-122`, `algo_semver.hpp:208`) | Owner+Lead |
| A-7-Widerruf importierte A-8-Belege in den A-7-Datensatz (Bezugsobjekt-Verwechslung) | REGRESSION | Z592 | dokumentiert/klassifiziert (Abschnitt 5.1 des Erkenntnisse-Berichts) | Assistant |
| Vier Fehler an einem Tag (Buendel): veraltetes Datum, case-sensitive Suche gg. VERSALIEN, `grep -v '/build'` frisst `/builder/`, Muster `DIFF-HYGIENE:` vs `DIFF-HYGIENE-WACHE:` verschluckt ROT, Pipeline 15110 fiel | REGRESSION | Z592 | dokumentiert (Ledger `:4705-4707`) | Assistant |
| „A1 nicht gelandet" Falschbefund (gemessen an lokalem `main` statt `origin/main`) | REGRESSION | Z592 | WIDERLEGT | Assistant |
| „Divergiert" Falschbefund (`merge-base` im Submodul-Checkout gerechnet, SHA dort unbekannt) | REGRESSION | Z592 | WIDERLEGT (Transkript 2026-08-08T11:53:04 uuid `9df70aa2`) | Assistant |
| Plandokumente verlesen an veraltetem Separat-Klon `29a1700` statt Submodul `19e1592` | REGRESSION | Z592 | BEHOBEN (O-4: „Zahlenbasis war falsch... am richtigen Objekt gemessen") | Assistant |
| Agent maß am ce-Submodul auf Feature-Branch-Checkout statt an der Spitze im Landungs-Worktree | REGRESSION | Z592 | dokumentiert (Memory K10 `:169-172`) | Agent |
| Wachen-Skript maß fremden Baum: `ci_diff_ascii_width_guard.sh:141-142` leitet Repo-Wurzel aus eigenem Ort ab (12578 statt 1450 Zeilen aus `wt-b14-ce`) | REGRESSION | Z592 | dokumentiert (Checkheft N-1 `:379-391`) | Assistant |
| Testbilanz zum falschen Quellstand: „406 von 406" gehoerten zu `3133f226`, nicht zur Landelinie; Zahl 409 aus Eingangsberichten bewusst nicht uebernommen | REGRESSION | Z592 | BEHOBEN/korrigiert (Nenner-Problem) | Assistant |
| Remote-Aussage aus lokaler Ref-Kopie: „GitHub-Sicherung vier Commits zurueck" aus `refs/remotes/*` | REGRESSION | Z592 | WIDERLEGT (Live-Messung per `git ls-remote`, Checkheft N-4 `:417-439`) | Assistant |
| gitleaks 5x „no leaks found" bei 0 commits scanned (Worktree/Submodul `.git` ist nur Zeiger) | REGRESSION | Z592 | BEHOBEN (echter Klon), 5 Vorfaelle dokumentiert 06.-08.08. | Assistant |
| Pipeline 15314 faelschlich als Beweis der CMake-Zyklus-Heilung genommen (`build:clang` lief nicht, `changes:`-Gate nicht ausgeloest, 3 statt 14 Jobs) | REGRESSION | Z592 | BEHOBEN (echter Beleg 15309/`51eebbfe`+15312/`56ffab37` success nach 15306/`a9a0754c` failed); Wiederholungsfrage 14:35 uuid `999af397` | Assistant |
| ugrep-stille-Null im ASCII-Gate (`grep -P` bricht auf prod1-ugrep mit Syntaxfehler ab, Pipe liefert 0, jedes Gate meldete falsches Gruen) | REGRESSION | Z592 | dokumentiert (L4181/L4206, Memory `reference_ugrep_ascii_gate_stille_null`) | Assistant |
| cf22-Mojibake-Pruefung meldete 0 bei nicht gelaufenem cf22 (false positive durch die Pipe) | REGRESSION | Z592 | dokumentiert | Assistant |
| `grep -r --include=*.hpp` uebersprang stumm `perm_runner.hpp` -> Ur-Irrtum B3-2 „#223 Gate fehlt" | REGRESSION | Z592 | dokumentiert (Methodik-Warnung Audit-Doc) | Assistant |
| „Voll-Bau" war keiner: Ninja uebersprang Targets, kalter 2-Pass-Configure ergab 404 statt 408 Tests, vier v41-Tests fehlten namentlich | REGRESSION | Z592 | dokumentiert (uuid `3d28e5cf`, 07.08. 10:11) | Assistant |
| Leeres PMC-Messfenster: `m3v2_pmc_smoke` misst nichts zwischen begin()/end(); Intel exakt 0 (fiel), AMD bestand durch 34-53 L1-Misses Syscall-Rauschen (13 Traces: 7/7 AMD nonzero, 6/6 Intel null, deterministisch) | REGRESSION | Z592 (Task #26) | dokumentiert, Bezug zu `m3v2_pmc_smoke.cpp:41-43` | Assistant |
| 1133 Phantom-ASCII-Verstoesse durch Locale-Artefakte (`od -c` fand 0 Bytes) | REGRESSION | Z592 | WIDERLEGT/Artefakt (uuid `eaa6bf75`) | Assistant |
| „Ersatztexte fehlen im PDF" — Artefakt der PDF-Textextraktion ohne Trenner, Texte standen wörtlich drin | REGRESSION | Z592 | WIDERLEGT/Artefakt (uuid `8b779ccd`, 20:00) | Assistant |
| Kerning-Artefakt und falsch gezaehlte Kapitelmenge (zwei weitere KLASSE-4-Faelle) | REGRESSION | Z592 | WIDERLEGT/Artefakt | Assistant |
| „1552 gitleaks-Treffer sind Fehlalarme" — Muster deckte `GR1348941` nicht ab, real 390 Runner-Token im Klartext | REGRESSION | Z592 | OFFEN-REGRESSION (echter Fund unter dem Fehlalarm; uuid `49ab5f39`, 20:45; Zahlen-Kollision 776 vs 390 ungeklaert) | Assistant |
| „13 MAX / 19 MIN" real 17/32; „0 dreiphasig-Treffer" real 8 (VERSALIEN uebersehen) | REGRESSION | Z592 | BEHOBEN/korrigiert (Agent-„KORREKTUR AN DER VORERHEBUNG") | Assistant |
| Erkenntnisse-Workflow Lauf 1: 38 von 49 Verifikations-Agenten am Session-Limit gescheitert, nur 11 fertig | REGRESSION | Z635, Z772 | BEHOBEN (nach Reset erneut gelaufen, s.u. 50/50) | Workflow |
| Erkenntnisse-Dokument „vorne abgeschnitten" (beginnt mitten im Satz, Journal-Fassung identisch abgeschnitten) | REGRESSION | Z650-653, Z918-929 | BEHOBEN (mit ehrlichem Kopf gelandet, der beide Einschraenkungen benennt; spaeter Synthese in zwei Haelften geteilt) | Assistant |
| Session-Dokument `20260808-SESSION-ERKENNTNISSE-widerlegte-befunde-und-learnings.md` (417 Zeilen) | AUFGABE | Z654-655 | GELANDET (super, Erstfassung) | Assistant |
| Schaerfungs-Workflow (w2mylldp8) fertig: 23/23 Agenten, 0 Fehler, 212 geschaerfte Posten, 850h Summe, 167 Querbefunde, 3 unabh. Wellendesigns | FEATURE | Z656-663 | GELANDET (super `ffa4b836`) | Workflow |
| Wellenplan v2 (Ketten-Entwurf gewaehlt, korrigiert v1 viermal, einziger Entwurf ohne HYBRID-KERN in Streichliste) | FEATURE | Z663 | GELANDET (super `ffa4b836`) | Workflow/Assistant |
| Owner: „Ist der andere Workflow auch fertig? Bitte resume den und alle fehlgeschlagenen Agenten und workflows." | OWNER-ENTSCHEID | Z664 | GESETZT | Owner |
| Limit-Sonde (Agent, haiku) prueft Session-Limit-Reset vor Resume | AUFGABE | Z669-670 | GEBAUT/bestaetigt (Limit frisch) | Agent |
| D3-Heilung hatte „falschen Weg gehaertet" — `allow_failure` in `experiment_plan_director.hpp`, `[MESS-TESTAT]` stand ausserhalb des `fi`: gescheiterte Zelle druckt beide Testate | REGRESSION | Z680-693 | BEHOBEN (Fix + Test, 429/429 gruen) | Assistant |
| Test fuer MESS-TESTAT pruefte nur Anwesenheit (`count_occurrences > 0`) statt Bedingung, blieb deshalb bei defekter Emission gruen | REGRESSION | Z21037-21039 | BEHOBEN (neue Semantik gepinnt, Test `TierCiYamlBuilder.MessTestatIsExclusiveWithFehlerTestat` ergaenzt, Koeder beisst) | Assistant |
| D3-Nachbesserung gelandet (ce, gitleaks „no leaks found") | REGRESSION | Z716 | BEHOBEN/GELANDET | Assistant |
| Resume Erkenntnisse-Workflow (`wounn9tiw`) gestartet (8 Sammler aus Cache, 38 Verifizierer neu) | AUFGABE | Z678-679, Z986-987 | GESTARTET, spaeter fertig (50/50, 0 Fehler) | Workflow |
| Owner: „Bitte konsolidiere den offenen Workflow dann in den Wellenplan und dann formuliere mir bitte einen reichen goal Text..." | OWNER-ENTSCHEID | Z718 | GESETZT | Owner |
| Goal-Text-Entwurf (`goal_entwurf.md`) | FEATURE | Z730-732 | GEBAUT (Entwurf, wartet auf Konsolidierung) | Assistant |
| v2-Nachmessung D2: nur 5 STATUS_OUT-Gates angenommen, real 18 Test-Registrierungen in if()-Bloecken unter 14 Bedingungen; STATUS_OUT deckt nur 2 von 14 | REGRESSION | Z739-1173 | RICHTIGGESTELLT/geschaerft (v2-Zahl war zu grob, nicht falsch) | Assistant |
| Owner: „Volle Freigabe für deine Methodik" | OWNER-ENTSCHEID | Z736 | GESETZT | Owner |
| Erkenntnisse-Verifikation final: 50/50 Agenten 0 Fehler; 40 Widerlegungsfaelle gesamt, 27/40 bestaetigt (67,5%), 13/40 selbst gefallen (32,5%); 316 Learnings, 9 ungeprueft, 24 Nichtfunde | FEATURE | Z761-799 | GELANDET (super `1510504c`) | Workflow |
| Konsolidierung Erkenntnisse in Wellenplan v2 | AUFGABE | Z782-786 | GELANDET (super `f92d5192`) | Assistant |
| GOAL-Text „Alle Wellen am Stück bis zur Abgabe am 15.09.2026" vorgelegt | FEATURE | Z787 | vorgelegt (Owner setzt GOAL nach Konsolidierung) | Assistant |
| Owner: „Weiterhin wünsche ich mir einen weiteren Designplan für erweiterte Testabdeckung... TDD... codex als Kritiker über die Testabdeckung... Fable xhigh Agent, der den review reviewed" | OWNER-ENTSCHEID | Z748 | GESETZT | Owner |
| Codex-Erreichbarkeitspruefung (GPT-5, read-only auf Baum) | AUFGABE | Z749-754 | GEPRUEFT/bestaetigt erreichbar | Assistant |
| TDD-Testabdeckung-Designplan-Workflow (`we4k74oyk`, 10 Teilgebiete, Codex-Kritiker + Fable-xhigh-Review je Teilgebiet) | AUFGABE | Z757-799 | GELANDET/fertig (21/21 Agenten, 0 Fehler) | Workflow |
| TDD-Designplan-Ergebnis: 157 Behauptungen, 117/157 bestaetigt/geschaerft (386h), 40/157 (~1/4) gefallen; 62 Funde nur durch Meta-Stufe (9 davon NEU-Posten) | FEATURE | Z794 | dokumentiert/GELANDET | Workflow |
| K1 keine-negativprobe (29 Testabdeckungs-Luecken): MT-L7 Nullcontainer, MT-L8 Legacy-Mikrobench, MT-L11 Vendor-Injektion, ST-Diskrepanz Welch/MWU, ST-Winsor NaN, ST-DriftBestwahl, ST-BreakEvenKreuz, PK-Kreuztest 6/8 Stellen, PK-NullMedian, PE-Rules on_success, PE-WarnPfade 10/14, LG-Lazy 0/2->2/2, LG-LoadWache beide Genera, LG-Kollision je Backend, LG-NoThrow-Inhalt, LG-CommitAtom, AS-GenusLaut, AS-Aritaet requires, AS-NameClean, PM-NichtGelesen, AG-Sentinel46, AG-Concepts11, AG-LayoutPin, XL-L6 Dangling-Link, XL-L8 ZahlText, XL-L9 Abbruch/tmp, HY-Reroute-Vertrag, HY-Ausgaenge, HY-HonestEmpty | AUFGABE | Z794 (TDD-Designplan) | OFFEN/GEPLANT (je Item Welle+Band+Aufwand im Dokument zugewiesen) | TDD-Workflow |
| K2 anwesenheit-statt-bedingung (25 Luecken): MT-L1 Exit0-ohne-Messwert, MT-L9 T17-Gleichheit, MT-L10 TikZ, ST-CLITestat statt Regex, ST-RankingTie, PK-DeleteP99-Wache, PE-BauTestat else, PE-PruefXOR, PE-PMCPreflight-Kette, LG-SkipCallback==0, LG-NAZelle, LG-DepthFirst-Protokoll, LG-WritebackXlsx, AS-KatalogTab 19, AS-ORG18 DOM+CRC64, AS-OsPin, PM-m3v2Spalten, PM-WinPCM, AG-C1C4 6 Orakel, AG-IsComposition, XL-L2 Token zellgenau, XL-L3 INFO lesen, XL-L5 Hyperlink-Menge, HY-Label-Gate, HY-Kurvenlage | AUFGABE | Z794 (TDD-Designplan) | OFFEN/GEPLANT | TDD-Workflow |
| K3 kein-nenner (23 Luecken): MT-L2 ns_per_op-Token, MT-L6 Stichprobe beide Writer, MT-L12 Golden-320-Menge, MT-QFlag Unbestimmt, ST-MultiCompare bestimmbar, ST-Export Robust-Felder, ST-Perzentile optional, ST-HeurIdentisch, PK-SuperFixture n=4, PK-KlemmJson n-Spalten, PK-P999 Produzent, PE-JobBindung, LG-Idempotenz 2x3, LG-Rueckschrieb7, AS-OrganOrdnung 18/18, AS-DupReject, PM-m3v2Zero 8/8, PM-RAPL 4 Eingaenge, AG-GenusCount, XL-L11 Mapping-Funktion, HY-Ebene4 Label+Datensatz, HY-Gleichstand+Beruehrpunkt, HY-DokuAnker | AUFGABE | Z794 (TDD-Designplan) | OFFEN/GEPLANT | TDD-Workflow |
| K4 unerreichbarer-block (16 Luecken, Registrierung fehlt/OFF-Flag/kranker Pfad nicht anspringbar): MT-L4 vier Unregistrierte+Wache, MT-L5 V32-Flag+CI-Job, ST-CTestWache 0/429, PK-F15Frei aus if-Block, LG-HostBinder 3 Felder, LG-Zeilenlimit Verwendungsstelle, AS-Bewaffnung Roundtrips==3, PM-Outcome Teil 1/2, PM-OffZwilling, PM-CTZweig 2 TUs, AG-Noexcept-Haertung, AG-DllRoundtrip, XL-L7 Limit-Aufruf, XL-L10 Praefix/S00N, XL-L12 Idempotenz/Degradation, XL-SheetZaehler gemischt | AUFGABE | Z794 (TDD-Designplan) | OFFEN/GEPLANT | TDD-Workflow |
| K5 test-zementiert-defekt (10 Luecken, nur teilweise sichtbar vor Kappung): MT-L3 Schema-Orakel 47/47, ST-Welch bestimmbar, ST-MWU n=1, PK-Kan[abgeschnitten] — u.a. Abdeckungs-Wache blieb gruen gegen korrekten 431-Baum, `test_commands.cpp:183-190` sichert Welch t=0/p=1 als Soll zu, `SummarizeEmptyZeroWinRate` zementiert win_rate=0.0 | REGRESSION | Z794 | OFFEN-REGRESSION/GEPLANT (Rest der Liste im Transkript-Extrakt gekappt) | TDD-Workflow |
| TDD-Erst-Schaerfungsstufe: 13 eigene Fehler (u.a. unerfuellbares P99IstNichtDasMaximum, falsches Winsor-Orakel bei geradem n, Tautologie-Schleife im Katalog-Entwurf, zwei falsche Ganzheits-Nenner im Planer-Gebiet) | REGRESSION | Z794 | WIDERLEGT/korrigiert (durch Meta-Stufe gefunden) | TDD-Workflow |
| TDD-Designplan gelandet | AUFGABE | Z801-806 | GELANDET (super `0c992af3`) | Assistant |
| Owner: „Bitte gib mir jetzt den vollständig elaborierten Goal Text aus und lege einen noch reicheren Goal Text mit Versionierung in das dossier... konsolidiere aber überschreibe besser eine neue goal Version." | OWNER-ENTSCHEID | Z812 | GESETZT | Owner |
| GOAL-Versionsrecherche: goalv6 dominant (2121 Belege), goalv3 juengste Session-Uebergabe (08.07.), „goalv7" existiert real nicht (51 Treffer Substring-Zufaelle) | AUFGABE | Z816-824 | GEKLAERT (neue Version wird v8) | Assistant |
| GOAL v8 Dossier (NEU, `20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md`, 456 Zeilen) | FEATURE | Z820-824 | GEBAUT/GELANDET (super `25040237`) | Assistant |
| Owner: „Bitte arbeite jetzt die Kritik in den Wellenplan ein und persistiere sie auch als Referenz." | OWNER-ENTSCHEID | Z825 | GESETZT | Owner |
| §12 im Wellenplan: TDD-Vertrag T-1...T-9 (u.a. T-1 ROT ZUERST, T-3 NENNER FREMD, T-4 GEGENEINGANG, T-7 REGISTRIERUNG-IST-TEST), 747 Zeilen | FEATURE | Z826-895 | GEBAUT/GELANDET (super `69639721`) | Assistant |
| GOAL-v8-Dossier-Referenz auf §12 nachgezogen (2 Stellen) | AUFGABE | Z858-860 | BEHOBEN | Assistant |
| Reihenfolge-Fehler beim Einfuegen: Erfahrungsgrundlage verrutschte hinter TDD-Absatz statt bei Quellen | REGRESSION | Z21340-21341 | BEHOBEN | Assistant |
| Memory `reference_goal_v8_und_tdd_vertrag` (NEU) | AUFGABE | Z865-866 | GEBAUT | Assistant |
| MEMORY.md-Index zu gross (20411 Bytes), auf 17507 Bytes kompaktiert (Grenze 17510), 185 Verweise gegengeprueft, 0 ins Leere | REGRESSION | Z869-897 | BEHOBEN | Assistant |
| Owner: „Bitte gib mir nochmal den aktualisierten elaborierten goal text" | OWNER-ENTSCHEID | Z896 | GESETZT | Owner |
| Owner: „OK bitte konsolidiere diese Version, die du mir ausgegeben hast und schreibe sie exakt so als session Dokument verbatim auf." | OWNER-ENTSCHEID | Z898 | GESETZT | Owner |
| GOAL v8 Konsolidierte Lesefassung verbatim (NEU, 203 Zeilen, Teile I-X) | FEATURE | Z899-903 | GEBAUT/GELANDET (super `2532426d`) | Assistant |
| Owner `/goal`-Setzung (Stop-Hook, bindend): GOAL-v8-Dossier vollstaendig abarbeiten, fertig erst nach Codex+Fable-xhigh-Review mit ultracode | OWNER-ENTSCHEID | Z904-908 | GESETZT (Session-Stop-Hook aktiv) | Owner |
| Owner-Praezisierung: erledigte Aufgaben je nach Code-Review (Codex+Fable max effort) im Dokument abhaken | OWNER-ENTSCHEID | Z924 | GESETZT | Owner |
| Owner-Praezisierung: jede Session beginnt mit Sonnet-5-max-Explore, Design mit Fable-5-xhigh, Bau mit passendem Modell/Effort, final verifizieren | OWNER-ENTSCHEID | Z956 | GESETZT | Owner |
| Owner-Praezisierung: Rollenwechsel — „Du bist CTO und manager der Arbeit... implementierst wenn möglich nichts selbst, delegierst an bis zu 10 weitere Arbeitsstränge/Workflows... Bau moeglichst Opus 5 max effort, Fable 5 xhigh nachsetzen wenn nicht zufriedenstellend" | OWNER-ENTSCHEID | Z986, Z993-994 | GESETZT | Owner |
| D2-G1 Objektbestaetigung: `enable_testing()` zu spaet (Zeile 717), 27 unsichtbare Testfaelle (20 in test_commands + 7 in test_engine_adapters, beide NICHT GEBAUT) | REGRESSION | Z915-937 | BESTAETIGT/ECHT (exakt bestaetigt, Mechanismus praeziser als Behauptung) | Assistant |
| Eigenes Messverfahren fehlerhaft: `grep -c` gibt bereits 0 aus, angehaengtes shell-OR `echo 0` haengt zweite Null an (Klasse V4) | REGRESSION | Z21475 | BEHOBEN (sauber neu gemessen) | Assistant |
| Fix: `enable_testing()` im ce-CMakeLists vor erstes `add_subdirectory` gezogen | REGRESSION | Z21513-21522 | BEHOBEN (429 -> 431 sichtbar, nach Bau 429 -> 456 Testfaelle) | Assistant |
| §12.4-Divergenz (Kritik-Material vs. §1-Zahl 455) entschieden — Kritik-Material lag richtig | REGRESSION | Z21531 | GEKLAERT | Assistant |
| `ci_test_sichtbarkeit_wache.sh` (NEU) — fand initial 14 unsichtbare Registrierungen (mehr als der Plan kannte) | FEATURE | Z21534-21549 | GEBAUT | Assistant |
| Eigene neue Wache hatte 2 Defekte: fehlender Newline am Dateiende verkettete zwei Namen; Artefakte aus vendoriertem `ext/`-Fremdcode (snmalloc/mimalloc/googletest) | REGRESSION | Z21553-21567 | BEHOBEN (14 -> 8 echte Befunde) | Assistant |
| Dritter Wache-Defekt: `gtest_discover_tests(X)` erzeugt `Suite.Fall` nicht `X.Fall`, Namensvergleich fand sie nicht | REGRESSION | Z21568-21570 | BEHOBEN (stattdessen Binary gemessen) | Assistant |
| Acht echte Befunde (2 aus TDD-Plan + 6 dem Plan unbekannt), alle hinter echten Bedingungen bestaetigt | AUFGABE | Z21583-21585 | BESTAETIGT/dokumentiert | Assistant |
| `ci_test_sichtbarkeit_allowlist.txt` (NEU, belegte Begruendung je Eintrag) | FEATURE | Z21592-21593 | GEBAUT | Assistant |
| W-1 baufertig, gruen mit vollem Nenner (157 CMake-Dateien gescannt) | AUFGABE | Z21602-21607 | fertig zur Uebergabe | Assistant |
| Workflow `w1-landung-und-w0a-vorbereitung` (`w9ifjj3an`): W-1 abnehmen+landen (Opus 5 max, Codex+Fable-Review), W-0a vorbereiten | AUFGABE | Z21612-21613 | GESTARTET | Workflow |
| Doktrin A1 ueberholt: Owner 06.08. „Fable wird nicht funktionieren und ist aufgebraucht, bitte wechsel auf Opus 5 max effort" — durch juengeres Owner-Wort (heute) ausser Kraft gesetzt (Widerspruchsregel: juengeres Wort gilt) | OWNER-ENTSCHEID | Z1000 | GESETZT/entschieden (A1-Eintrag geloescht) | Owner |
| Strang2-Workflow (`wy2te82mb`) mit falschem Auftrag gestartet | REGRESSION | Z1003-1009 | BEHOBEN (gestoppt via TaskStop, bevor Doktrin-Phase startete) | Assistant |
| A1-Eintrag in Doktrin geloescht statt markiert (Regel: Zustandsaussage -> Loeschen ist richtiger als Markieren; Pflegeregel 3 „nichts loeschen" hier ausdruecklich ausgesetzt) | REGRESSION | Z1010-1020 | BEHOBEN/GELANDET (super `66f8126b`) | Assistant |
| Ledger-Nachtrag sagte noch „A1 wird NICHT geloescht" — widersprach dem tatsaechlichen Loeschen | REGRESSION | Z1015-1019 | BEHOBEN (im selben Commit richtiggestellt) | Assistant |
| Strang2 neu gestartet (`w1rj749hy`, read-only, super-seitig: W0b-Explore+Design) | AUFGABE | Z1023-1024 | GESTARTET, spaeter fertig (8/8 Agenten, 0 Fehler) | Workflow |
| Owner: „Alles korrekt. gute weiterarbeite und eine autonome gute nacht" | OWNER-ENTSCHEID | Z1026 | GESETZT (Blanko-Fortsetzung bestaetigt) | Owner |
| W-1-Agent fand Defekt in eigener Sichtbarkeits-Wache: zeilenbasierte Regex blind fuer mehrzeilige Schreibweise `add_test(\n NAME test_x ...)`, 3 real registrierte Tests nie ins SOLL aufgenommen (u.a. `test_axis_registry_roundtrip`) | REGRESSION | Z1027, Z1033 | GEFUNDEN, in Heilung (Strang 1) | Agent |
| Strang3 (`wmrhmcf17`, read-only): HYBRID als reiner TDD-Fall + `--check-size` | AUFGABE | Z1031-1032 | GESTARTET | Workflow |
| Strang2 fertig (8/8, 0 Fehler): fand Schwesterstelle, die die eigene D3-5-Heilung uebersehen hatte | REGRESSION | Z1047 | GEFUNDEN | Agent |
| W0b-Designplan (4 Gebiete, 23 Pakete gesamt, 79 Stunden Summe) — im Extrakt nur 4 von 23 Paketen sichtbar (Rest bei „truncated 70990 chars" gekappt) | AUFGABE | Z1040, Z1723 | GEPLANT (Rest der Liste im Quelltext gekappt) | Workflow |
| W0b-0: Bissprobe + Abnahme-Schluss der gelandeten Mess-Ausbeute-Wache (D3-1/D3-2-Rest), 2h | AUFGABE | Z1040 | GEPLANT | Workflow-Design |
| W0b-1: D3-3 — persist zaehlt Zeilen statt Dateien, leeres Fenster = kein Commit; heute committet eine Kopfzeilen-only-CSV | REGRESSION | Z1040 | OFFEN-REGRESSION/GEPLANT (3h) | Workflow-Design |
| W0b-2: D3-7 — Lauf-Marker (`<out_csv>.lauf`) neben jeder offiziellen CSV fehlt (Wurzel des D3-Bogens) | REGRESSION | Z1040 | OFFEN-REGRESSION/GEPLANT (3h) | Workflow-Design |
| W0b-3: D3-5-Rest — Batch-Bilanz A+B==C + PE-BauTestat: Bau-[TESTAT] haengt am Objekt nachgewiesen HINTER dem `fi` (derselbe D3-5-Defekt im Bau-Batch) | REGRESSION | Z1040 | OFFEN-REGRESSION/GEPLANT | Workflow-Design |
| ce `1f88cfec`: eigener Fehler „429 -> 456 war ein Sprung ueber zwei Grundgesamtheiten" (429=frischer Configure, 456=Baum nach Bau der Binaries) | REGRESSION | Z1051-1058 | BEHOBEN (praezisiert, eigener Commit) | Assistant |
| Strang4 (`wzrunhdu8`, BAU super-Repo): vier sofort landbare W0b-Pakete | AUFGABE | Z1056-1057 | GESTARTET | Workflow |
| Strang3 fertig (5/5 Agenten): 15 Pakete, 161h, 8 gefallene Befunde, 9 Owner-Entscheide | AUFGABE | Z1064-1074 | GELANDET/dokumentiert | Workflow |
| HY-0: Hybrid-README sagt „Major 7", Decl-Header sagt „8" — ABI-Drift in der Dokumentation vor jedem Hybrid-Bau | REGRESSION | Z1065, Z1074 | GEFUNDEN/GEPLANT (6h, W0a) | Workflow-Design |
| HY-GLEICH: Break-Even-Engines divergieren real — `best_binary_selector` kennt keine Richtung (immer „kleiner ist besser"), `heuristik::find_break_even_points` schon; zusaetzlich Rasterluecken-Fall | REGRESSION | Z1065, Z1074 | GEFUNDEN/GEPLANT (9h, W0b) | Workflow-Design |
| HY-A1: Gattung HEURISTIK-ADAPTER + Genus Function-Interface-Reroute + Reroute-Vertrag (additiv, AnatomyGattung::HeuristikAdapter=3, AnatomyGenus::FunctionInterfaceReroute=5, kGenusCount 5->6) | FEATURE | Z1065 | GEPLANT (W1, 17.08., nach OV-13+OV-19) | Workflow-Design |
| Strang5 (`wbtxxi7ds`, BAU ce): Schwesterstelle zur eigenen D3-Heilung | AUFGABE | Z1075-1076 | GESTARTET | Workflow |
| Strang1/W-1-Landung fertig (8/8 Agenten, 12 Koeder, 17 Befunde davon 6 Eigenfehler), gelandet ce `1f88cfec` | AUFGABE | Z1083-1091 | GELANDET | Workflow |
| SCHWERSTER BEFUND Strang1: eigene D2-G1-Heilung haette neuen Defekt eingebaut — `comdare_tests` baut `test_commands`/`test_engine_adapters` NICHT (0 Kanten in `ninja -t query`); globale Liste `COMDARE_TEST_TARGETS` enthielt beide nie (#278 „Not-Run"-Klasse, ~60 Stellen) | REGRESSION | Z1084 | BEHOBEN (`set_property(GLOBAL APPEND...)`, 0 Platzhalter, ctest -N=456, clang rc=0) | Agent (W-1) |
| Wache `ci_test_sichtbarkeit_wache` war NICHT in CI verdrahtet (0 Nennungen vs. andere Wachen 1-6x) — sah aus wie ein Werkzeug, erzwang nichts | REGRESSION | Z1084 | BEHOBEN (verdrahtet in `test:coverage-guard`, rc=0 im echten CI-Lauf belegt) | Agent (W-1) |
| Nicht-ASCII in hinzugefuegten Zeilen: DIFF-HYGIENE-WACHE stand bereits ROT vor jeder eigenen Aenderung (`CMakeLists.txt:672`) + 3 weitere nicht-ASCII in neuer Allowlist (Kastengrafik, ausserhalb Wachen-Scope) | REGRESSION | Z1084 | BEHOBEN (alle 4 Stellen geheilt, 0 von 57 neuen Zeilen) | Agent (W-1) |
| T-6-Schwesterpflicht 4. Stelle: SOLL-Scanner blind fuer mehrzeilige `add_test(NAME ...)`-Schreibweise, 3 Tests fehlten im SOLL (`test_axis_registry_roundtrip`, `test_system_axis_registry_roundtrip`, `test_measurement_axis_registry_roundtrip`) | REGRESSION | Z1084 | BEHOBEN (SOLL 277 -> 280) | Agent (W-1) |
| 5. Stelle derselben Klasse: 19 Registrierungen mit Namen in CMake-Variable (foreach-Schleifen), statisch nicht schliessbar — braeuchte `cmake --trace` | REGRESSION | Z1084 | TEILWEISE (jetzt als Zahl mit Datei:Zeile ausgegeben statt Schweigen; echte Heilung offen) | Agent (W-1) |
| IST-Erkennung falsch in beide Richtungen: gieriges `sed` griff letzten Schraegstrich, verwechselte Datei-/Argumentnamen mit Testbinaries (446 Tokens, Mehrzahl kein Binary) | REGRESSION | Z1084 | BEHOBEN (jetzt feldgenau aus „Test command:"-Zeilen) | Agent (W-1) |
| Allowlist-Tabulator-Loch: `cut -d' ' -f2-` gab tab-getrennte Zeile ohne Leerzeichen komplett zurueck, galt faelschlich als BEGRUENDET (stiller Rueckfall in der Pruefung selbst) | REGRESSION | Z1084 | BEHOBEN (awk-Feldzerlegung, Mikro-Test + Koeder gegengeprueft) | Agent (W-1) |
| Fundstellen-Anzeige zeigte falschen Ort (Kommentar statt echte Registrierungszeile; mehrzeilige Form fand „unbekannt") | REGRESSION | Z1084 | BEHOBEN (exakte Datei:Zeile aus echter Registrierung) | Agent (W-1) |
| Allowlist-Eintraege, die ihren Grund ueberlebt haben: 4 von 8 Eintraegen im echten CI-Baum wirkungslos (Begruendung „existiert im CI-Baum nicht" stimmt dort nicht mehr) | REGRESSION | Z1084 | dokumentiert (als Bericht ergaenzt, nicht automatisch geprueft) | Agent (W-1) |
| gitleaks erkennt zufaellig erzeugtes AWS-Schluesselpaar NICHT (weder Projekt-Config noch Default-Regeln, beide rc=0 „no leaks found") — nur Private-Key-Block belegt den Biss | REGRESSION | Z1084 | dokumentiert (Fallen-Register: gruener gitleaks-Lauf ist KEINE Aussage ueber AWS-foermige Secrets) | Agent (W-1) |
| Eigenfehler 1 (W-1): grep nach „test_commands" in ctest -N fand 0 — gtest_discover_tests registriert unter GTEST-Namen, nicht Zielname | REGRESSION | Z1084 | BEHOBEN (ueber Binary-Basisnamen aus ctest -N -V gemessen) | Agent (W-1) |
| Eigenfehler 2 (W-1, Zeitrichtung): zurueckgedrehte Heilung an rekonfiguriertem statt frischem Baum geprueft, lieferte falsch 456 statt 429 | REGRESSION | Z1084 | BEHOBEN (frischer Baum lieferte ehrliche 429) | Agent (W-1) |
| Eigenfehler 3 (W-1): `run_in_background`+`nohup &` — gemeldete „exit code 0" war der Starter, Bau lief noch 15 Minuten weiter (Klasse K11) | REGRESSION | Z1084 | erkannt/dokumentiert | Agent (W-1) |
| Eigenfehler 4 (W-1): `until ! pgrep -f 'cmake --build...'` wartete auf sich selbst (Muster matcht eigene Kommandozeile), Endlosschleife trotz fertigem Bau | REGRESSION | Z1084 | erkannt/dokumentiert | Agent (W-1) |
| Eigenfehler 5 (W-1): `pkill -f 'until ! pgrep -f'` traf eigene Kommandozeile, erschoss eigene Shell (Exit 144) | REGRESSION | Z1084 | erkannt/dokumentiert | Agent (W-1) |
| Codex-Totalausfall in der Kritiker-Stufe: Codex antwortet nur aus Assistant-Kontext, nicht aus Workflow-Subagent | REGRESSION | Z1094-1097 | BEHOBEN/umgangen (Assistant fuehrt Codex-Review selbst, gibt Ergebnis an Fable weiter) | Assistant |
| Memory `reference_fallen_20260808_gitleaks_aws...` (NEU) | AUFGABE | Z1098-1099 | GEBAUT | Assistant |
| Ledger-Nachtrag mit Strang-1-Befunden gelandet | AUFGABE | Z1102-1107 | GELANDET (super `ca901c50`) | Assistant |
| Strang5 fertig (4 Agenten): 2 gebaut, 2 gelandet (W0b-3 `4dd5a1bc`, HY-0 `d47d1c74`), 1 nachgesetzt, 19 Schwesterstellen | AUFGABE | Z1113-1120 | GELANDET | Workflow |
| NEUER DEFEKT [PMC-TESTAT]: `ctest -L pmc` meldet bei 0 Treffern rc=0, damit ist `pmc=ok` kein Beleg | REGRESSION | Z1114 | BEHOBEN (`--no-tests=error`, eigener Test ueber ALLE emittierten ctest-Aufrufe) | Agent (Strang5) |
| HY-0-Schwesterstellen: `observable_tier.hpp:15/17/44` „aktuell Major 6" seit 26.07. falsch ueber zwei ABI-Bumps (13 Tage), `axis_stats[17][8]`/`seg_ns[17]` gegen `kV3AxisCount=18` | REGRESSION | Z1114 | BEHOBEN (SHA-gepinnte Historie erhalten, Zahl nur noch Verweis) | Agent (Strang5) |
| HY-0-Schwesterstelle im Design-Dokument (`hybrid_tier_stufe_soll_design.md:62-63,453-454`, „bindend"): dieselbe Major-7/Magic-.A7.-Aussage | REGRESSION | Z1114 | BEHOBEN (4 Stellen geheilt) | Agent (Strang5) |
| Kandidat 45 (super Kandidatenliste, seit 4 Tagen notiert „gleiche Klasse wie C11-OP-9, dort NICHT gezogen") | REGRESSION | Z1114 | BEHOBEN (mit HY-0 erledigt und werkzeuggedeckt) | Agent (Strang5) |
| Repo-weite Gegenprobe (2490 Dateien ce, 4873 super, nur lesend): genau 2 lebende ABI-Major-Zeilen gefunden, nur 1 falsch — keine weitere versteckte Stelle | AUFGABE | Z1114 | GEPRUEFT/bestaetigt vollstaendig | Agent (Strang5) |
| Zaehlfalle: `ctest -N` mit `grep -c 'Test #'` (1 Leerzeichen) zaehlt wegen Spaltenausrichtung nur 362 statt 461 (Test #28 traegt 2 Leerzeichen) | REGRESSION | Z1114 | dokumentiert (Fallen-Register, nirgends als Beleg verwendet) | Agent (Strang5) |
| `/home/comdare/keys/gitlab-pat`: 51-Byte-PAT ausserhalb des Vaults, HTTP 401 („Etikett ohne Deckung") | REGRESSION | Z1114 | dokumentiert (Vault-Weg funktioniert stattdessen) | Agent (Strang5) |
| `ci_hy_label_gate.sh` nimmt Repo-Wurzel aus PWD — Aufruf aus fremdem Worktree ergibt rc=2 mit irrefuehrender Meldung | REGRESSION | Z1114 | Beobachtung/kein Defekt (fail-closed korrekt, ctest-Registrierung fixiert cwd) | Agent (Strang5) |
| Review haelt NICHT stand fuer HY-0: geheilte Datei traegt weiter lebende Falschaussage (`observable_tier.hpp:74` „ALLE 17 Achsen" bei `kV3AxisCount=18`, 10 Zeilen unter der HY-0-Heilung) | REGRESSION | Z1124-1130 | BLOCKIEREND, dann behoben (s.u. Strang6) | Fable-Review |
| Eigener Memory-Eintrag (`reference_fallen_20260808_gitleaks...`) von vor einer Stunde korrigiert — Mechanismus war falsch benannt | REGRESSION | Z1124-1126 | BEHOBEN | Assistant |
| Strang6 (`wz0owhdjo`, Fable 5 xhigh): blockierenden Review-Mangel an HY-0 schliessen + 4 wichtige | AUFGABE | Z1128-1129 | GESTARTET, fertig (haelt_stand=true) | Workflow |
| BLOCKIEREND HY-0 bestaetigt: `observable_tier.hpp:74` „ALLE 17 Achsen" bei `kV3AxisCount=18` — die Wache selbst war der Defekt (Teil D kannte nur `axis_stats[N]`/`seg_ns[N]`) | REGRESSION | Z1137 | BEHOBEN (Teil D erweitert um „ALLE(R) N ...Achsen"/„T0..T<M>", Rot-Lauf protokolliert) | Agent (Strang6) |
| WICHTIG 1: `measurable_workload.hpp` gleiche Klasse (`seg_ns[17]`, ALLE(R) 17, T0..T16, 2 Assert-Texte, 6 Zeilen) | REGRESSION | Z1137 | BEHOBEN (Teil-D-Nenner jetzt 43 Angaben in 5 Dateien) | Agent (Strang6) |
| WICHTIG 2: e24-Dossier „Lebend gilt seitdem: Major 8" fuer Teil B unsichtbar (Koeder mit gewuerfelter Zahl blieb rc=0 gruen) | REGRESSION | Z1137 | BEHOBEN (Trigger auf „lebend gilt/seit/" erweitert) | Agent (Strang6) |
| WICHTIG 3: Teil C fail-open — unpruefbares SHA lief mit rc=0 als „nicht pruefbar" durch | REGRESSION | Z1137 | BEHOBEN (rc=1 im vollen Klon, rc=2 bei unbestimmbarer Klon-Beschaffenheit) | Agent (Strang6) |
| WICHTIG 4: SetEAbbruch-Marken strukturell ungeprueft | REGRESSION | Z1137 | BEHOBEN (neuer Test `SetEAbbruchMarkenSindWirklichSetEGebunden`) | Agent (Strang6) |
| WICHTIG 5: ctest-Leerlauf-Wache mit engem Nenner/weiter Annahme | REGRESSION | Z1137 | BEHOBEN (18 Formen geprueft, 1 dokumentierte Restunsicherheit) | Agent (Strang6) |
| WICHTIG 6: Debug-Zweig der Testat-Wachen ungeprueft | REGRESSION | Z1137 | BEHOBEN (4 Plaene getestet, 72/72 gruen) | Agent (Strang6) |
| NEUER FUND: `perm_runner.hpp` trug 4 weitere lebende 17er-Aussagen ausserhalb jeder Wache (`:17,18,221,357-358`) | REGRESSION | Z1137 | BEHOBEN | Agent (Strang6) |
| NEUER FUND (Koeder M2): neuer SetE-Test selbst hatte Defekt — Einrueckung der Markenzeile nicht geprueft, fand Vorgaenger-Block faelschlich gruen | REGRESSION | Z1137 | BEHOBEN (Marken-Zeile muss selbst Blockinhalt sein) | Agent (Strang6) |
| Wache selbst 7. Teil-B-Treffer: eigener Kopftext haette beim naechsten Bump unmarkiertes Eigen-Rot erzeugt | REGRESSION | Z1137 | BEHOBEN | Agent (Strang6) |
| Offen geblieben (Strang6): GitLab-Pipeline-Gruen nach Push auf `17a25fba` nicht selbst verifiziert (kein glab auf Maschine) | AUFGABE | Z1137 | OFFEN | Agent (Strang6) |
| Offen geblieben (Strang6): Repo-weite 17er-/Achsenzahl-Klasse ausserhalb der 5 Teil-D-Dateien nicht flaechig geheilt (161 Zeilen in 93 Dateien, ueberwiegend fremde Nenner) | AUFGABE | Z1137 | OFFEN (bewusster Scope-Entscheid) | Agent (Strang6) |
| Strang6 gelandet, haelt stand | AUFGABE | Z1144 | GELANDET (`17a25fba`) | Assistant |
| Pipeline 15412 (HY-0-Landung `d47d1c74`) ROT — „niemand hat es gemerkt" (23 Jobs: 21 success, 1 manual, 1 failed) | REGRESSION | Z1147-1149 | GEFUNDEN, wird untersucht | Assistant |
| Sichtbarkeits-Wache biss beim ersten CI-Kontakt echt: 2 Registrierungen lokal sichtbar, im CI-Baum unsichtbar (`test_ap5_simd_extension_coherence`, `test_buildvariant_dll_real`, hinter AVX2/AVX512-Bedingung) | REGRESSION | Z1153-1158 | GEFUNDEN, Ursache wird geklaert | Assistant |
| Strang7 (`wv02eag3y`): rote Pipeline 15412 — Sichtbarkeits-Wache vs. AVX-512-gegatete Tests | AUFGABE | Z1156-1157 | GESTARTET, fertig | Workflow |
| URSACHE 15412: zwei bare-metal-Runner teilen Tag `baremetal` (id=16 prod1 AMD Zen5 MIT AVX-512, id=17 prod2 Intel OHNE) — Job floatet, 15412 lief auf Intel-Host | REGRESSION | Z1165 | GEKLAERT (kein Defekt an der Erkennung, arithmetisch ausgeschlossen: 461 lokal vs. 457 CI, exakt die 4 AVX-512-Namen fehlen) | Agent (Strang7) |
| T-6-Zusatzfund: Hardware-Klasse hat 4 Mitglieder, Wache sah nur 2 — `test_simd_field_sum_dispatch_avx512`, `test_simd_add_u64_carry_avx512` haengen an derselben Bedingung, Namen stehen in `${_tgt}` | REGRESSION | Z1165 | GEFUNDEN/BEHOBEN (in neue Allowlist aufgenommen) | Agent (Strang7) |
| Allowlist-Entscheidung 15412 (8->6 bzw. je Baum unterschiedlich begruendet) | REGRESSION | Z1165 | BEHOBEN/GELANDET (ce `404ff6cf`) | Agent (Strang7) |
| Pipeline-Gruen fuer `404ff6cf`/`17a25fba` von Strang7 NICHT verifizierbar (kein Token im Subagenten) — Lead soll pruefen, Host-Block als direkter Beleg genannt | AUFGABE | Z1165 | OFFEN uebergeben, dann vom Assistant erledigt | Agent (Strang7) |
| R4-Spannung benannt: Push auf development waehrend 15414 evtl. noch lief (kein `interruptible`, kein Auto-Cancel, aber Abweichung genannt) | REGRESSION | Z1165 | dokumentiert, kein Auto-Cancel ausgeloest | Agent (Strang7) |
| Assistant-Gegenprobe bestaetigt Ursache am Objekt: Host-Block zeigt `Linux prod2`, `GenuineIntel`, i9-12900K (kein AVX-512) | AUFGABE | Z1172-1175 | BESTAETIGT | Assistant |
| Pipelines nach Strang7: 15414 (`17a25fba`) gruen, 15415 (`404ff6cf`) laeuft | AUFGABE | Z1177 | GRUEN/laeuft | Assistant |
| SCHWERSTER BEFUND DER NACHT: Wellenplan stuetzt gesamte Parallelitaets-/Kampagnenplanung auf „EIN-BLECH-REGEL" — am Objekt widerlegt (Jobs floaten zwischen mehreren Maschinen: super 23 floatend/2 gepinnt, ce 21 floatend/2 gepinnt) | REGRESSION | Z1178-1186 | GEFUNDEN, dann durch Owner als Fehlinterpretation korrigiert (s.u.) | Assistant |
| Entwarnung: Mess-Jobs selbst tragen Maschinen-Pin (`measure:golden-320 tags:[prod,baremetal,amd]`) — nur Nicht-Mess-Jobs floaten | REGRESSION | Z1184-1186 | TEILWEISE entschaerft | Assistant |
| Wellenplan §3 richtiggestellt (Floaten-Befund) | AUFGABE | Z1189-1190 | BEHOBEN/GELANDET | Assistant |
| Owner: „Ehm, das war so geplant, dass über das lager die maschinen abstimmen, wer welches batch verarbeitet und es können auch erstmal alle Maschinen alle jobs aufnehmen, bitte explore zur Lagerhaltung und wie ein Maschine zum Maximum ihrer technischen Möglichkeiten AVX binaries kompiliert" | OWNER-ENTSCHEID | Z1192 | GESETZT (EIN-BLECH-Befund war Assistant-Fehlinterpretation, Floaten ist geplantes Verhalten) | Owner |
| Eigener Fehler: „eine nicht aufloesbare Frage ist zuerst meine Gedaechtnisluecke, kein Befund" — Floaten als Risiko gemeldet statt zuerst zu pruefen, ob es geplant ist | REGRESSION | Z1193 | BEHOBEN/eingestanden | Assistant |
| Strang8 (`wfhjt8wzv`, read-only Explore): Lagerhaltung als Maschinen-Abstimmung + AVX-Maximum-Kompilierung je Maschine | AUFGABE | Z1195-1196 | GESTARTET | Workflow |
| Owner-Praezisierung (Stop-Hook, letzte Zeile der Quelldatei): bei Stillstand zu einem Thema der Kette XML->Planer->CEB->Tier-Binaries bauen->messen->auswerten->release+Hybrid-Bau->Messwerte als LaTeX/PDF veroeffentlichen immer Sonnet-5-max-„very thorough"-Explore fahren; „Fahre auch immer einen Explore wenn du sonst raten müsstest - rate NIE" | OWNER-ENTSCHEID | Z21989 (letzte Zeile) | GESETZT | Owner |
