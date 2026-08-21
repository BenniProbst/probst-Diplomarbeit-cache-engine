# Sammelstrecken-Leser 3 — Ledger Zeilen 9201-13800

Quelle: `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
Segment: Zeilen 9201-13800 (exklusiv, Teil eines 32210-Zeilen-Ledgers)

Status LAUT QUELLE: GEPLANT/GEBAUT/GELANDET/CI-BEWIESEN/OFFEN/VERTAGT/GESTRICHEN/BEHOBEN/OFFEN-REGRESSION

| KUERZEL/Name | Klasse | Quelle (Z-Anker) | Status LAUT QUELLE | Traeger/Task |
|---|---|---|---|---|
| F7/STUFE Stufe=Binary vs Phase=Modi-Konzept, saubere Trennung (Frage seit KON16-09 Z10392-10397, OFFEN in KON18-02 Z10109-10111, Kollision real KON23-06 Z9487-9494) | OWNER-ENTSCHEID | KON25-07 Z9206-9227 (Ursprung KON16-09) | BEHOBEN (praezisiert KON16-09) | Umbenennungs-Regel Posten 5 Bauliste |
| E-F7 Explore geplante Stufe/Phase-Trennung im Bestand | AUFGABE | KON25-07 Z9226 | OFFEN | Explore-Auftrag |
| F8 Traeger-Rakete rueckwaerts aufgebaut, Emissionsliste=volle Pipeline | OWNER-ENTSCHEID | KON25-08 Z9230-9251 | BEHOBEN/GESCHLOSSEN | vervollstaendigt S-12-Zuschnitt |
| F9 prod2 bleibt, Multi-Runner gegen Lager geplant | OWNER-ENTSCHEID | KON25-09 Z9254-9262 | BEHOBEN/GESCHLOSSEN | E-F9 |
| KON3-02 prod2-Blockade seit 17.07. | REGRESSION | KON25-09 Z9259 | BEHOBEN (geschlossen durch F9) | - |
| E-F9 Explore Multi-Runner-gegen-Lager-Plan | AUFGABE | KON25-09/11 Z9260-9282 | OFFEN | Explore-Auftrag |
| F10 Kontext-Bitte (XML-Element fuer Ziel-3-Einzelnachweise) | AUFGABE | KON25-10 Z9265-9270 | OFFEN | neu vorgelegt KON25-11 |
| F1 (O-1 zu) | OWNER-ENTSCHEID | KON25-11 Z9276 | BEHOBEN/GESCHLOSSEN | - |
| F2 (Flaeche 3 = IMessVisitor, VEREINIGEN) | OWNER-ENTSCHEID | KON25-11 Z9276 | BEHOBEN/GESCHLOSSEN | - |
| F3 (NENNER=32, Selbstkorrektur dokumentiert) | OWNER-ENTSCHEID | KON25-11 Z9277 | BEHOBEN/GESCHLOSSEN | - |
| F4 (CiYamlBuilder bleibt, lokal) | OWNER-ENTSCHEID | KON25-11 Z9278 | BEHOBEN/GESCHLOSSEN | - |
| E-F5 Explore measure-drop-Entscheid im letzten Session-Log | AUFGABE | KON25-11 Z9280 | OFFEN | Explore-Auftrag |
| E-F3b Explore Verhaeltnis 32 zu "6 CEB-Builds" | AUFGABE | KON25-11 Z9282 | OFFEN | Explore-Auftrag |
| F6 (C-4-Scope) neu vorgelegt | AUFGABE | KON25-11 Z9283-9284 | OFFEN | mit Unterschieds-Erklaerung |
| F11 (Pruefdock-Zaehlung) von dieser Runde nicht beruehrt | AUFGABE | KON25-11 Z9285 | OFFEN | - |
| Q-a "Gebaut aber inert" ist Systemmuster (4 Quellen) | UNKLAR | KON24-01 Z9302-9304 | OFFEN (Befund) | Arbeit vor F2 = Aktivierung+Anschluss |
| Q-b Lager ist der kritische Pfad | AUFGABE | KON24-01 Z9305-9307 | OFFEN | S-17/S-13 auf kritischen Pfad |
| Q-c S-6-Umstellung + Umbenennung brechen dieselben Vertragsflaechen | AUFGABE | KON24-01 Z9308-9310 | OFFEN | EIN Aenderungsfenster vor F2 |
| Q-d drei Fingerprint-Glieder [1..3] ungeschuetzt (rohe string_view) | REGRESSION | KON24-01 Z9311-9313 | OFFEN (Luecke, Fix=Transpositions-Sperre mit S-6) | S-6b |
| Q-e "existiert nicht"-Aussagen tragen Verfallsdatum | UNKLAR | KON24-01 Z9314-9315 | OFFEN (Methodik-Hinweis) | - |
| Q-f WF3 Z34976: S-14/S-18 sind Build-Blocker, nicht CI-Kosmetik | AUFGABE | KON24-01 Z9316-9318 | OFFEN | - |
| V-1 Durchstich ##25 F1-Lieferung (Fr 14.08.), ohne Besitzer | AUFGABE | KON24-02 Z9323-9324 | OFFEN (dringendster Posten) | - |
| V-2 ce-Pipeline ROT (#84 Vorbestands-Rot + #80 coverage-guard) | REGRESSION | KON24-02 Z9325-9327 | OFFEN-REGRESSION | Owner-Doktrin "debugge alle pipelines" |
| V-3 main-FF beider Repos (super dev 20+ Commits voraus) | AUFGABE | KON24-02 Z9328-9329 | OFFEN | Hygiene-Wache vor FF |
| V-4 G-2-Semantik-Nachzug (Achsen-Nummerierungsreihenfolge) nie begonnen | AUFGABE | KON24-02 Z9330-9332 | OFFEN | O-1-Restschluss (F1) |
| V-5 Owner-Vorlage ueberholt -> UEBERHOLT-Kopf gesetzt | AUFGABE | KON24-02 Z9333 | BEHOBEN (diese Runde) | - |
| V-6 MinIO-Keys + 776 Runner-Token + prod2-test:secrets | AUFGABE | KON24-02 Z9334 | OFFEN | Task #10 |
| V-7 A-1-Vorlagetext vor jeder Backup-Ref-Loeschung lesen | AUFGABE | KON24-02 Z9335 | OFFEN | - |
| V-8 E-1..E-4 Neuvorlage verlangt, Vollzug unbelegt | AUFGABE | KON24-02 Z9336-9337 | OFFEN | - |
| V-9 Pruefdock-Zaehlung -> F11 (gerade Anzahl vs EIN Dock vs alle Pruefdocks) | REGRESSION | KON24-02 Z9338-9339 | OFFEN (Widerspruch) | F11 |
| V-10 W12-B (seit 19.07.) + #68-Forensik unveraendert | AUFGABE | KON24-02 Z9340 | OFFEN | - |
| V-11 MEMORY.md-Kopf "KON16" stale | REGRESSION | KON24-02 Z9341 | BEHOBEN (auf KON23 korrigiert, diese Runde) | - |
| S-19 Planungs-Simulation (Keim PlanSizeBuilder:489) | FEATURE | KON24-03 Z9349 | GEPLANT (neu geschnitten) | Wellenplan §16 |
| S-20 Sync-Kanal CEB<->Hybrid | FEATURE | KON24-03 Z9350 | GEPLANT (neu geschnitten) | Wellenplan §16 |
| S-21 Kategorien-Wache | FEATURE | KON24-03 Z9350-9351 | GEPLANT (neu geschnitten) | Wellenplan §16 |
| Wellenplan §16 Konsolidierung (O-1..O-14, S-6 entsperrt+geschnitten S-6a-d, S-12/S-13 neu gefasst) | AUFGABE | KON24-03 Z9347-9352 | BEHOBEN (gelandet diese Runde) | - |
| WF4 Referenz-Konsolidierung KON19-00 (vier /goal-Dokumente) | AUFGABE | KON24-03 Z9357-9359 | OFFEN (WF4 laeuft 14/20) | eigener Schritt danach |
| 2 GOs ohne benannten Gegenstand (Z36292/42737, "Dann weiter") | UNKLAR | KON24-04 Z9370 | OFFEN | Bezug nur aus Umfeld |
| K-5-Dateien enthalten Teammate-Berichte trotz Owner-only-Deklaration | REGRESSION | KON24-04 Z9371-9372 | OFFEN | Roh-Transkript bleibt Autoritaet |
| WF1 gelandet: neun Straenge Explore auf Owner-Antworten (45/46 Agenten) | AUFGABE | KON23 Kopf Z9373-9381 | BEHOBEN (gelandet) | docs/sessions/20260812-WF1-* |
| Platzhalter-Gate fuer kuenftige Workflows (3 "TEST"-Ausfaelle erkannt) | AUFGABE | KON23 Kopf Z9379-9381 | OFFEN (Vorschlag) | - |
| F1 Strang A: Flag-Grammatik v2, cp/ce KEINE Katalog-Token | FEATURE | KON23-01 Z9385-9402 | GEBAUT (07.08. algo_semver.hpp R1-R8 + flag_grammar_catalog.hpp, 62 zugelassen+14 ausgeschlossen) | -> Owner-Frage F1 (s.o. beantwortet KON25-11) |
| Strang B: Freigebende Seite SIMD (set_active_machine_declaration) | FEATURE | KON23-02 Z9406-9412 | GEBAUT-aber-INERT (0 Produktionsaufrufer) | S-3/S-7 Aktivierung |
| Strang B: Compile-Time Seite SIMD (simd_organ_requirement.hpp, 9 Organ-Klassen) | FEATURE | KON23-02 Z9413-9415 | GEBAUT-aber-INERT (required-Menge ausnahmslos leer, global inert) | S-3/S-7 Aktivierung |
| Strang C: 4 Rueckschrieb-Methoden Csv/LatexTable/ComparisonMetrics/Xlsx | FEATURE | KON23-03 Z9425-9437 | GEBAUT (xlsx scharf seit 09.08./10.08., golden waehlt csv+xlsx) | - |
| json/html/svg/png Rueckschrieb-Formate | REGRESSION | KON23-03 Z9430-9431 | OFFEN (belegte Nullen, "und so weiter" unbeantwortet) | Thesis-/Overleaf-Sektion ungeprueft |
| F5 measure-drop-Kanal: Ziel 2 oder Ziel 3? | OWNER-ENTSCHEID/AUFGABE | KON23-03 Z9439-9442 | OFFEN (Konflikt Verortungsbrief 18.07. vs KON13-04) | bis S-13 ungefiltert jede per-Binary-CSV |
| F6 beantwortet: KON17-01 (anforderungsgetrieben) ist die Antwort | OWNER-ENTSCHEID | KON23-04 Z9446-9449 | BEHOBEN | - |
| F3 Widerspruch Hybrid-Nenner 12 vs 24/48 (MEMORY vs Ledger) | REGRESSION | KON23-04 Z9451-9464 | OFFEN-REGRESSION (an Owner zurueckgegeben) | - |
| MEMORY.md fuehrt "3!=6 CEBs" statt korrekt 12 | REGRESSION | KON23-04 Z9461-9462 | OFFEN-REGRESSION (nachzuziehen) | Owner-Selbstkorrektur 10.08. |
| E: Traeger x Rolle-Tabelle (Planer kompiliert, CEB einzige Bauende, Hybrid kann nicht bauen) | OWNER-ENTSCHEID | KON23-05 Z9470-9472 | BEHOBEN (entschieden) | - |
| 0 von 4 Traegern haben eigenen Bau-/Test-Job (super/ce/hybrid je 0 Treffer) | REGRESSION | KON23-05 Z9472-9474 | OFFEN | Lint/Release-Deckung -> F8 |
| F: C-4-Wache deckt 6 Dateien, Grundgesamtheit >=152, Schnitt=0, Drift=0 | REGRESSION | KON23-05 Z9476-9481 | OFFEN | Scope-Frage F6 |
| hartkodierte 6-Pfad-Liste war Mitursache Drei-Wochen-Ausfall | REGRESSION | KON23-05 Z9479-9481 | OFFEN (Autodiscovery ueber Registry-Typlisten vorgezeichnet, test_a1 macht 1/18 vor) | - |
| G: Stufe=Phase-Kollision real (XSD phase-Enum Stufe1..3) | REGRESSION | KON23-06 Z9487-9494 | OFFEN (Zielbegriff -> F7, spaeter beantwortet KON25-07) | Golden-Byte-Bruch bei Umbenennung |
| H: Bau-Modul teils gebaut (Director+9 Builder+BuildOrchestrator), Hybrid-Anteil 0 | FEATURE | KON23-06 Z9496-9500 | GEBAUT-TEILWEISE | -> F4 |
| CiYamlBuilder/TierCiYamlBuilder emittiert GitLab-YAML, kein Owner-Wort nennt ihn | REGRESSION | KON23-06 Z9497-9499 | OFFEN (Widerspruch zu KON18-01) | -> F4 (beantwortet: bleibt, lokal) |
| IExperimentDock: 0 Code-Treffer | UNKLAR | KON23-06 Z9499-9500 | OFFEN (weder gebaut noch verworfen) | - |
| I: drei Flaechen konsistent, Flaeche-3-Kandidat NAHT-1 IMessVisitor/tier_measure_accept | FEATURE | KON23-06 Z9502-9505 | GEBAUT (Mechanismus komplett, 1 Biss-Test) | -> F2 (beantwortet) |
| Bauliste 11 Posten (Ledger-Korrekturen, Stempel, Planungs-Simulation, C-4-Wache, Umbenennung, Bau-Modul, S-13, Flaeche-3, S-3-Wache, HY-A2/A3, O-1-Restschluss) | AUFGABE | KON23-07 Z9511-9513 | GEPLANT (priorisiert) | WF1-Synthese §4 |
| K2 beantwortet: CEB orchestriert direkt ODER delegiert an Hybrid, Sync-Kanal (Frage seit KON18-02 Z10087-89, Rueckfrage KON19-02 Z9914-9916 "im session log geplant") | OWNER-ENTSCHEID | KON21-01 Z9616-9646 | BEHOBEN | S-15/HY Bau-Konsequenzen |
| Sync-Kanal CEB<->Hybrid als eigenes Bau-Teil | FEATURE | KON21-01 Z9648-9652 | GEPLANT | S-15/HY |
| O-14/Fork R1 beantwortet: Option 1, geschichtete Wahrheit (Code=Freigabe, XML=Realisierung) (Frage KON18-02 Z10096-97, Rueckfrage KON19-05 Z9958-9970) | OWNER-ENTSCHEID | KON21-02 Z9656-9683 | BEHOBEN | Registry-Arbeit S-2/S-9 entblockt |
| Fuenf S-6-Antworten (SOLL alle 3 Ebenen, Traeger-Kette dynamisch, Kategorien-Wache Ja, Sperre mit S-6, #67 explore+behalten) | OWNER-ENTSCHEID | KON21-03 Z9689-9695 | BEHOBEN | S-6 entsperrt |
| S-6a Preimage-/Argument-/POD-Umstellung auf MESS,SYSTEM,ORGAN | FEATURE | KON21-03 Z9706-9712 | GEPLANT (golden-Bruch, Layout-Bump noetig, VOR F2) | - |
| S-6b Transpositions-Sperre fuer 3 rohe string_view-Glieder | FEATURE | KON21-03 Z9713 | GEPLANT (mit S-6) | - |
| S-6c Kategorien-Ordnungs-Wache (neu, Owner-GO) | FEATURE | KON21-03 Z9714 | GEPLANT (mit S-6) | - |
| S-6d #67-Benennung: explore+schaerfen, BEHALTEN | AUFGABE | KON21-03 Z9715 | GEPLANT | Zahlen neu erheben |
| Kategorien-Ebene: 3 Ordnungen (aussen ORGAN>SYSTEM>MEASUREMENT vs Lager-Messdaten MESS>SYSTEM>ORGAN vs Lager-Binaries SYSTEM>ORGAN>MESS), keine Wache | REGRESSION | KON20-01 Z9739-9748 | OFFEN (nur Disziplin+Kopf-Kommentar haelt Konsistenz) | -> S-6c |
| SOLL MESS,SYSTEM,ORGAN ist Neuordnung, keine Wiederherstellung (0 Treffer vor 10.08. ueber 10 Wochen) | UNKLAR | KON20-02 Z9757-9759 | OFFEN (Praezisierung) | - |
| Eingriffskarte S-6: 3 Aussen-Kostenebenen (Makro-Argumentfolge, POD-Feldfolge ABI-Bruch, Preimage-Glied-Folge) + Verbotszonen | AUFGABE | KON20-02 Z9761-9772 | GEPLANT | S-6 |
| Fuenf S-6-Fragen an Owner | AUFGABE | KON20-03 Z9787-9799 | BEHOBEN (beantwortet in KON21-03) | - |
| Register leerer Klassen Erstbefuellung: KEINE einzige unbenannte Huelle gefunden | FEATURE/AUFGABE | KON20-04 Z9802-9809 | BEHOBEN (Nenner 1351 Quelldateien, 164 leere Ruempfe, 117 Tag-Dispatch, 34 einzeln gelesen) | WF2-Synthese |
| K2 P/E-Core-Cluster ohne Wellen-Platz (ICpuCore/ICoreLayout/CoreClass, CPUID-Leaf 0x1A nirgends gelesen) | REGRESSION | KON20-04 Z9817-9820 | OFFEN (kein Posten in S-1..S-18/O/HY, §16.3-E17 "deep research Pflicht" nicht eingeloest) | Owner-Entscheid noetig |
| K4 mess/-Subsystem (Steuerkanal, Konfiguration) hat keine S-Position | AUFGABE | KON20-04 Z9821-9822 | OFFEN | S-9/S-10 naheliegend, unbelegt |
| K5 drei Skelett-Testverzeichnisse (integration, generic_module_tests, module_specific_tests) seit 06.07. ohne Eigentuemer | REGRESSION | KON20-04 Z9823-9825 | OFFEN | fuellen/terminieren/deprecaten |
| K3 i_command.hpp Einordnung weiter offen (Nachfolger AxisCommand steht) | AUFGABE | KON20-04 Z9826 | OFFEN | - |
| K1 Register der leeren Klassen braucht Ablageort+Pflegeregel | AUFGABE | KON20-04 Z9827-9828 | OFFEN | Erstbefuellung liegt in WF2-Synthese |
| CodegenEngine ist KEINE Klassen-Huelle (substanziell, 1 Produktionsaufrufer) | UNKLAR | KON20-04 Z9830-9831 | BEHOBEN (Praezisierung/Klarstellung) | Grenze "NICHT erweitern" bleibt |
| BreakEvenPoint-SKELETON -> S-15/HY-B (echte Kurven) | FEATURE | KON20-04 Z9811-9812 | GEPLANT (Wellen-Platz terminiert) | HY-C |
| decision_lambda_trees -> HY-C | FEATURE | KON20-04 Z9812 | GEPLANT | HY-C |
| "ergebnis:holen"-Job-Skelett -> W2/D3-8 | FEATURE | KON20-04 Z9812-9813 | GEPLANT (Spannung zu KON16-03 "keine YAML", vor W2 zu klaeren) | W2/D3-8 |
| Koeder-Generator-Falle: Standard-Rezept liefert nicht-deterministisch 19/20 Zeichen | REGRESSION | KON20-05 Z9835-9842 | BEHOBEN (Fallen-Register ergaenzt: Koeder-Laenge pruefen) | gitleaks-Gegenprobe |
| Neuer Hauptauftrag: 8 Sessions+Plaene+Ledger einlesen, dann 4 /goal-Dokumente als Haupt-Referenz konsolidieren | AUFGABE | KON19-00 Z9852-9868 | GEPLANT (danach, wenn alle Workflows zurueck) | GOAL-V8 + WELLENPLAN-ENDFASSUNG-v2 + DESIGNPLAN-tdd + ARBEITSWEISE-DOKTRIN |
| O-4 beantwortet: SIMD=Meta-Meta-Achse System, Festplatten-IO=Meta-Meta-Achse Organ (Genus SearchAlgorithm nur RAM, kann IO erweitern), Bindung je Tier-Binary/Gattung+Genus | OWNER-ENTSCHEID | KON18-02 Z10084-86 (Frage) + KON19-01 Z9872-9891 (Antwort) | BEHOBEN | Explore E-A: Entscheidung in Sessions finden, SIMD kartieren |
| K5 beantwortet: Hybrid ist TRANSMITTER/MULTIPLEXER, KEINE Aggregations-Logik (je Thread nur 1 Tier-Binary) | OWNER-ENTSCHEID | KON18-02 Z10088-89 (Frage) + KON19-02 Z9895-9912 (Antwort) | BEHOBEN | deckt sich mit KON8/KON13 |
| O-12/Fork E beantwortet: EINE Einstiegs-XML (main.xml) rekursiv, XML-Syntax=Programmiersprache | OWNER-ENTSCHEID | KON18-02 Z10090-93 (Frage) + KON19-03 Z9920-9941 (Antwort) | BEHOBEN | S-8 entblockt, sobald parse_thesis_profile/parse_experiment_profile abgebildet |
| O-13/Fork B: --dump-plan/PlanTextBuilder = Director-Methode, vermutlich ueberholt, Quelle nicht vom Owner geprägt | OWNER-ENTSCHEID | KON18-02 Z10094-95 (Frage) + KON19-04 Z9945-9954 (Vorentscheid) | VERTAGT (Explore E-C noetig, dann streichen oder bauen) | S-8 |
| T-15a beantwortet: "ganzer Lauf" = ALLES (Planer->Lager-Pruefung->Builds->Messung Single+Multi->Auswertung->Release-Stufe) | OWNER-ENTSCHEID | KON18-02 Z10098-100 (Frage) + KON19-06 Z9974-9990 (Antwort) | BEHOBEN | Wiederaufsetzpunkt=Lager |
| T-15b beantwortet: 5 Wiederholungen = Retry GESAMTER CEB-Messdurchlauf bei failed (nicht max_reruns-Achse), 3 = normale success-Messung | OWNER-ENTSCHEID | KON18-02 Z10101-103 (Frage) + KON19-07 Z9994-10009 (Antwort) | BEHOBEN | Explore E-D: Bau-Posten von max_reruns auf Pruefdock-Retry umziehen |
| HYB beantwortet: ARBEITSANNAHME erstmal nur einfache CPU-Versionen mit SIMD-Permutationen; 24/48-Frage VERTAGT bis Planungs-Simulation | OWNER-ENTSCHEID | KON18-02 Z10104-106 (Frage) + KON19-08 Z10013-10026 (Antwort) | VERTAGT (Struktur bleibt Owner, Zahl aus Planungs-Simulation) | - |
| OD-7 beantwortet: 16 Kerne gelten (nicht 24), "schon entschieden" | OWNER-ENTSCHEID | KON18-02 Z10107-108 (Frage) + KON19-09 Z10030-10035 (Antwort) | BEHOBEN | Explore E-E: dokumentierte Entscheidung finden |
| E-A Explore Festplatten-IO-Entscheidung+SIMD-Meta-Meta am Objekt | AUFGABE | KON19-10 Z10041-10042 | OFFEN | - |
| E-B Explore alle Hybrid-Schichten/Eigenschaften aus Session-Log | AUFGABE | KON19-10 Z10043-10044 | OFFEN | -> dann K2 erklaeren (spaeter KON21-01 beantwortet) |
| E-C Explore Quelle/Herkunft --dump-plan/PlanTextBuilder | AUFGABE | KON19-10 Z10045-10046 | OFFEN | -> UEBERHOLT markieren falls bestaetigt |
| E-D Explore Pruefdock-Retry-Stellen woertlich, Bau-Posten umziehen | AUFGABE | KON19-10 Z10047-10048 | OFFEN | - |
| E-E Explore 16-Kerne-Entscheidung finden, OD-7-Stelle korrigieren | AUFGABE | KON19-10 Z10049 | OFFEN | - |
| Kern: Bau-Modul ist Planer-Bibliothek in C++23, keine Skripte ausser CMake | OWNER-ENTSCHEID | KON18-01 Z10057-10067 | BEHOBEN | Architektur-Invariante I24 |
| #89 14 Shell-Testproben (8528 Zeilen) waechst gegen Doktrin "keine Skripte" | REGRESSION | KON18-01 Z10070-10071 | OFFEN | - |
| Frage 6 beantwortet: Bau-Modul baut anforderungsgetrieben (Stufe N baut was N-1 wuenscht/anfordert/freigibt), nur Planer direkt kompiliert | OWNER-ENTSCHEID | KON17-01 Z10123-10146 | BEHOBEN | Neuer Bau-Posten: Planungs-Simulation (Pflicht nach Stempel) |
| Frage 7 beantwortet: Emission ist FERTIG <=> CEBs+Tier-Binaries+Hybrid stehen im LAGER (nicht bei "kompiliert/gelinkt/Tests gruen") | OWNER-ENTSCHEID | KON17-02 Z10154-10173 | BEHOBEN | J-1..J-4 muss mitemittiert werden; Stempel-Rollen 2+3 auf kritischem Pfad |
| Frage 12 beantwortet: Wache modular erweitern + in Detail-Klassen splitten (EINE Wache, kein zweites Werkzeug) | OWNER-ENTSCHEID | KON17-03 Z10179-10183 | BEHOBEN | C-4-Trennung als Klassen-Split |
| Frage 10 beantwortet: S-13 ist KERN der Ablage (nicht post-Abgabe); Bau-Reihenfolge nach Stempel: Planungs-Simulation -> XML bis PDF, alle Abzweigungen | OWNER-ENTSCHEID | KON17-04 Z10189-10215 | BEHOBEN | Explore: letzte 5 Kontexte einlesen |
| Eigener Arbeitsfehler: S-13 "still und heimlich ausgeklammert" (Wiederholungsfall, RUEGE) | REGRESSION | KON17-04 Z10189-10199 | BEHOBEN (durch Owner-Ruege korrigiert) | eigene Arbeitsfehler-Liste |
| Frage 1 beantwortet: Flag-Semantik c=CPU ist festgelegt, volle Syntax mehrstellig (cp/ce als Beispiele), ce=Fallstrick (auch cache_engine) | OWNER-ENTSCHEID | KON16-01 Z10238-10253 | BEHOBEN (spaeter praezisiert als c{p}/c{e} in KON23-01/F1) | Explore-Auftrag vollstaendige Grammatik |
| Frage 2 beantwortet: Flag-Bedeutung haengt von Seite ab (freigebend=impliziert, compile-time=fordert), Dreiphasig+Messfuehler-Vertrag als 3. Gegenstand | OWNER-ENTSCHEID | KON16-02 Z10257-10277 | BEHOBEN (spaeter kartiert KON23-02 Strang B) | S-3 zwei Orte |
| Frage 3/4 beantwortet: KEINE YAML, Planer emittiert direkt (Pipe/Prozess), zentrales wiederverwendbares Bau-Modul Builder Pattern | OWNER-ENTSCHEID | KON16-03 Z10283-10299 | BEHOBEN | raeumt halbe CI-Fragenliste weg (gegenstandslos) |
| Widerspruch CiYamlBuilder (19.07.-Entwurf) vs "keine YAML" ungeklaert | REGRESSION | KON16-03 Z10301-10304 | OFFEN (am Gegenstand zu klaeren) | spaeter F4 beantwortet: bleibt, lokal |
| Frage 5 beantwortet: Nesting-Budget kein Problem, Tiefe 3 (Planer->CEB->Tier, dann sequentiell Hybrid) | OWNER-ENTSCHEID | KON16-04 Z10309-10320 | BEHOBEN | bestaetigt ORT != ZEIT von Bau-Seite |
| Frage 8 beantwortet: "angefordert" = ganze Kette laeuft (super=Anwender, XML=Konfiguration) | OWNER-ENTSCHEID | KON16-05 Z10324-10334 | BEHOBEN | Explore: was war geplant (LaTeX/PDF/xlsx/"und so weiter") |
| Frage 9 beantwortet: DREI FLAECHEN nicht zwei (Genus=Flaeche1, Stempel=Flaeche2, measurement-Durchstich=Flaeche3) | OWNER-ENTSCHEID | KON16-06 Z10343-10370 | BEHOBEN | Nicht-Aenderungs-Zusage Gattung+Genus-Interfaces |
| Frage 11 beantwortet: leerer Einhaengepunkt ist gewollt, jetzt aktiv genutzt | OWNER-ENTSCHEID | KON16-07 Z10374-10379 | BEHOBEN | C-1-Bilanz korrigiert auf 6/11 (war 5) |
| Frage 13 beantwortet: GN-8-Rest Prioritaet HOCH (Ledger widersprach sich niedrig/hoch) | OWNER-ENTSCHEID | KON16-08 Z10383-10388 | BEHOBEN | Ledger-Korrektur naechster Durchgang |
| Ledger-Widerspruch GN-8-Rest-Prioritaet (niedrig vs hoch an zwei Stellen) | REGRESSION | KON16-08 Z10387 | BEHOBEN (Frage13-Antwort setzt HOCH) | - |
| Frage 6/7 neu gestellt (Bau-Vorschrift je Typ/Instanz; welche Schritte emittiert Traeger-Stufe) | AUFGABE | KON16-10 Z10409-10423 | OFFEN (spaeter beantwortet KON17-01/KON17-02) | Explore wf_eede2f12-7ed |
| Frage 12 (C-4 Wache erweitern oder zweite bauen) mehr Kontext noetig | AUFGABE | KON16-10 Z10411 | OFFEN (spaeter beantwortet KON17-03) | - |
| Frage 10 (S-13 post-Abgabe oder vorgezogen) NICHT beantwortet | AUFGABE | KON16-10 Z10412 | OFFEN (spaeter beantwortet KON17-04) | - |
| Explore-Lauf wf_eede2f12-7ed (neun Straenge, 45 Agenten) fuer Fragen 6/7/12 + KON16-01/-02/-05/-03/-06/-09 | AUFGABE | KON16-10 Z10425-10427 | GEPLANT/LAUFEND (spaeter gelandet, WF1 KON23) | - |
| Leere Klassen notieren statt uebergehen (nicht nur "0 Aufrufer", auch "leer im Inhalt") | OWNER-ENTSCHEID | KON15-01 Z10435-10447 | BEHOBEN | Neuer Bau-Posten Register leerer Klassen (Erstbefuellung KON20-04) |
| S-6 ist nicht "falsch herum" sondern ZWEI WELTEN (Lager vs ausserhalb, kontextabhaengig) | OWNER-ENTSCHEID | KON15-02 Z10451-10466 | BEHOBEN (praezisiert) | Explore vor jeder S-6-Aenderung; spaeter S-6a-d geschnitten |
| Zitat-Regel: jede Kuerzung traegt [...] — volles GO | OWNER-ENTSCHEID | KON15-03 Z10470-10476 | BEHOBEN | ab sofort ohne Ausnahme |
| Vier Zahlen nachgeholt: 295->294, 137->123 (Diff 14 unaufgeklaert), 124->130, 13/7967->14/8528, bump-pflichtig=152 | REGRESSION | KON15-04/KON14-04 Z10480-10488/10605-10614 | BEHOBEN (Zahlen korrigiert), Diff 14 und 0/14 retired bleiben OFFEN | - |
| 130 axes-Header: 104 mit echter Zuweisung, 26 nur Prosa; 0 von 123 Flag-Literalen tragen Hardware-Anteil | UNKLAR | KON14-04 Z10609-10614 | OFFEN (Gegenstand von O-1 und S-7) | - |
| Cache-Landschaft letztes Wort: local=Dateisystem lokal/Netz, minio=S3; Runner duerfen NUR ccache minio.comdare.de + Buildsystem-NAS lesen | OWNER-ENTSCHEID | KON15-05 Z10494-10514 | BEHOBEN (letztes Wort) | S-13, XSD-Enum {local,minio} traegt Semantik bereits |
| eigene Messung widerlegt: LagerBaumWriter "0 Aufrufer" falsch (9 Test-Aufrufe via Factory) | REGRESSION | KON14-01 Z10552 | BEHOBEN (widerlegt) | Ursache: Namenssuche statt Gegenstandssuche |
| eigene Messung widerlegt: algo_version Compile-Zeit-Pflicht "nie gebaut" falsch (18 Basis-Header static_assert) | REGRESSION | KON14-01 Z10553 | BEHOBEN (widerlegt) | - |
| eigene Messung widerlegt: "7 Marker gegen 9 Lock-Eintraege" falsch, tatsaechlich 6 gegen 6 | REGRESSION | KON14-01 Z10554 | BEHOBEN (widerlegt) | - |
| Schraegstrich-Falle: -path */build*/* -prune frisst builder/ (370 statt 371), wiederholter Fallentyp | REGRESSION | KON14-01 Z10560-10563 | BEHOBEN (per Gegenprobe gefangen) | Fallen-Register |
| S-6 IST gebaut und FALSCH HERUM: organ->system->measurement statt SOLL MESS->SYSTEM->ORGAN, Posten #87 | REGRESSION | KON14-02 Z10567-10578 | OFFEN (preimage-wirksam, an F2 gebunden, heute kostenlos/ab 26.08 teuer) | -> S-6a (spaeter geplant) |
| vier unmarkierte Eingriffe in Owner-Zitat KON9-11 (fehlendes Wort, gestrichenes Wort, 2 Satzumstellungen, gekapptes Ende vor Blocker-Folgesatz) | REGRESSION | KON14-03 Z10582-10599 | BEHOBEN (Kerninhalt bleibt gedeckt, Regel KON15-03 als Reaktion) | dritter Fall dieser Klasse in einer Nacht |
| Wache tools/axis_version_lock lief drei Wochen faktisch tot (YAML-Doppeldefinition, hartkodierte 6-Pfad-Liste) | REGRESSION | KON14-05 Z10618-10626 | BEHOBEN (seit 06.08. vereinigt, Fixes 597ecffe+557d8023 Vorfahren von HEAD) | S-14 entlastet, Scope 6/152 bleibt offen |
| Fable-Frage 17: Bauform Wache erweitern vs zweite Wache daneben | AUFGABE | KON14-05 Z10628-10631 | OFFEN | beide Lesarten mit "trennen UND verdrahten" vereinbar |
| S-11 "ungedeckte Regression" falsch, war 05.08. selbst geschlossen, gebaut+gerufen | REGRESSION | KON14-06 Z10639-10640 | BEHOBEN (Entlastung) | Rest: Default-Pfad liest weiter getenv (AUFGABE offen) |
| "hybrid/=nur README.md" falsch an 3 Ledger-Stellen, tatsaechlich 4 Header/943 Zeilen | REGRESSION | KON14-06 Z10642 | BEHOBEN (Entlastung) | - |
| "run_selection_filter_chain 0 Produktionskonsumenten" falsch, 4 Aufrufer (Einhaengepunkt steht, Kette selbst leer) | REGRESSION | KON14-06 Z10644-10645 | BEHOBEN (Entlastung) | dup/praezisiert C-2 KON13-06 |
| KON10-01-Ueberschrift "D5 woertlich vorweggenommen" haelt nicht, korrekt "inhaltlich vorweggenommen" | REGRESSION | KON14-06 Z10650-10652 | BEHOBEN | - |
| i_command-Kopfkommentar behauptet ABI-Flaeche konsumiert "hart" hinter Gate; Gate funktionslos (COMDARE_V32_ENABLE nirgends per #ifdef abgefragt) | REGRESSION | KON14-06 Z10653-10655 | OFFEN (Doku falsch, wirksam nur COMDARE_BUILD_TESTS Default ON) | - |
| F-1 beantwortet: Fassungskette ueber 6 Stufen verankert auf Owner-Nachricht 21:24:47Z | OWNER-ENTSCHEID | KON14-07 Z10661-10668 | BEHOBEN | System-Achse "dehnbar" ohne Phasenzunahme (2/2) |
| S-4, S-8, S-10 im gesamten Material kein Befund, nicht gemessen | AUFGABE | KON14-08 Z10681 | OFFEN | - |
| Stunden-/Tage-Aufwand von S-1..S-18 an keiner Stelle dokumentiert | AUFGABE | KON14-08/KON13-08 Z10684/10952 | OFFEN | - |
| Fragen stehen bei 19 (Grammatik/Stempel 2, CI-Geruest 5, Cache-Landschaft 8, Inventur/Buchfuehrung 4) | AUFGABE | KON14-09 Z10690-10693 | OFFEN (Bilanz) | Volltext synthese-nachtrag-{OPUS,FABLE}.md |
| eigene Empfehlung "Mini-Pipeline je Traeger-Typ" faelschlich als Owner-nah gefuehrt (3/3 Fundstellen type=assistant) | REGRESSION | KON14-09 Z10698-10701 | BEHOBEN (als Empfehlung zu kennzeichnen) | Owner-Vorlage O-10 |
| W-1 aufgeloest: Hybrid ist Glied der MESS-Kette, nicht Bau-/Freigabe-Kette (kann nicht bauen, nur messen) | OWNER-ENTSCHEID | KON13-01 Z10711-10735 | BEHOBEN | MESS 3->4, SYSTEM 2->2, ORGAN 2->2 |
| KON9-04-Zuordnung "System/Organ MIT Hybrid" faellt (Eigenfehler) | REGRESSION | KON13-01 Z10734 | BEHOBEN | - |
| F-2 beantwortet: echte Vier-Parteien-Kette mit dreiphasigem Kern, CEB hat 2 dritte Phasen, zwei Steuerungswege (Tausch am Pruefdock direkt / Beauftragung an Hybrid) | OWNER-ENTSCHEID | KON13-02 Z10739-10768 | BEHOBEN | - |
| ZWEI Grammatiken nicht drei: G-1 Mess-Achse dreiphasig (fehlt, Design vorzuschlagen), G-2 System+Organ-Achse zweiphasig (Syntax existiert, Semantik-Nachzug) | OWNER-ENTSCHEID | KON13-03 Z10774-10794 | BEHOBEN (Zuordnung); G-1 Design + G-2 Nachzug bleiben OFFEN | S-2 nicht mehr gesperrt |
| Wellenplan-Satz "ohne Entscheid Grammatik-Zahl nicht schneidbar" (§14.2/14.3) faellt | REGRESSION | KON13-03 Z10790-10791 | BEHOBEN | - |
| Cache-Landschaft: drei Orte zwei Backends eine XML (B-3 ersetzt): (1) CCACHE Tools/Compiler MinIO+FS (2) BUILDSYSTEM-CACHE Lager-Items MinIO+FS, isolierter Mount PR4100/backup1.comdare.de (3) CACHE-ENGINE-EXPERIMENT Ausgabe nur Zusammenfassung+LaTeX+PDF+Einzelnachweise | OWNER-ENTSCHEID | KON13-04 Z10798-10847 | BEHOBEN | S-13 praezisiert: 3 Ziele je 2 Backends |
| B-1 KON9-04 Grammatik-Zuordnung gestrichen (Eigenfehler, widersprach 4h aelterem Owner-Satz) | REGRESSION | KON13-05 Z10856-10859 | BEHOBEN (ersetzt durch KON13-03) | - |
| B-2 Memory "ORT-Satz -> Phasigkeit" falsch, korrigiert zu "folgt KEINE Phasigkeit" (Eigenfehler, Memory) | REGRESSION | KON13-05 Z10860-10864 | BEHOBEN | Memory ort_und_zeit |
| B-4 KON10-Kopf "traegt JEDE Festlegung" zu praezisiert (Grammatik-Taxonomie+5 Stempel-Rollen sind eigene Leistung) | REGRESSION | KON13-05 Z10866-10868 | BEHOBEN | - |
| C-3 "4 von 5 Stempel-Rollen durchgesetzt" FALSCH -> tatsaechlich NUR 2 von 5 (Identitaet+Einordnung); Lager-Schluessel+Skip-Marke nur in Testdateien; Cache-Schluessel offen; falsche Zahl in 3 Dokumenten inkl MEMORY.md | REGRESSION | KON13-06 Z10874-10881 | OFFEN (Lager-Schluessel/Skip-Marke nicht durchgesetzt, Cache-Schluessel offen) | Stempel-Nacht 12.08 |
| C-2 run_selection_filter_chain 4 Produktionsaufrufer (stets leere Kette, golden-neutral), ResumeFilter 0 Installationen | REGRESSION | KON13-06 Z10883-10887 | OFFEN (Aktivierungsluecke) | - |
| C-5 "Do 14.08." falsch an 4 Stellen, korrekt "Fr 14.08." (Kipp-Punkt K-1) | REGRESSION | KON13-06 Z10889-10890 | BEHOBEN | - |
| A-1 P-0 von blockierend auf begleitend (KON12-01 juenger als Wellenplan §14) | REGRESSION | KON13-06 Z10892-10894 | BEHOBEN | P-0 = super-Seite auf ce-Skelett ziehen wenn S-8 gebaut |
| A-2 S-3 faellt NICHT (transitiv preimage-wirksam ueber S-5), nur #68 faellt | REGRESSION | KON13-06 Z10896-10899 | BEHOBEN | - |
| A-3 O-2 entfaellt an sechs Ledger-Stellen (S-2 haengt nur an O-1) | REGRESSION | KON13-06 Z10901-10902 | BEHOBEN | - |
| A-4 S-17 hatte keinen Wellen-Platz (kam erst §14.7 dazu) | REGRESSION | KON13-06 Z10904-10905 | BEHOBEN | - |
| C-4 "7 von 130" ist KEINE Deckungsquote: echte 6 Marker-Traeger alle unter heuristik/, Schnittmenge zu 130 axes-Headern = NULL | REGRESSION | KON13-06 Z10907-10912 | OFFEN (eigener Bau-Posten, Explore laeuft) | Owner: "uebles Bilanz, trennen und verdrahten" |
| C-1 Inventur des Unverdrahteten braucht 4 Kategorien statt Summenzahl (2 Positionen nicht nachgemessen, 5/11 bereits aktiv) | AUFGABE | KON13-06 Z10914-10917 | OFFEN (bis Messung keine Summenzahl) | - |
| nicht geprueft: O-7, O-10 der Owner-Vorlage — kein Befund | AUFGABE | KON13-08 Z10949 | OFFEN | - |
| nicht geprueft: 14 von 17 Bau-Teilen nie gegen Code-Objektstand gemessen (nur P-0,S-14,S-17) | AUFGABE | KON13-08 Z10950-10951 | OFFEN | - |
| nicht geprueft: Owner-Zitattreue KON9-11/KON10-01 gegen Rohtranskript | AUFGABE | KON13-08 Z10954 | OFFEN (KON9-11 spaeter in KON14-03 geprueft) | - |
| nicht geprueft: i_command.hpp und v32_messreihe_antrieb Einordnung Inventur steht aus | AUFGABE | KON13-08 Z10955 | OFFEN (v32_messreihe_antrieb spaeter in KON12-01 als designiertes Skelett geklaert) | - |
| #67 Zahlen "142 Include-Kanten/29 Wanderungen": 0 Belegstellen im gesamten Ledger | REGRESSION | KON13-08 Z10956 | OFFEN | -> S-6d spaeter: behalten, Zahlen neu erheben |
| PHASE 0 ist KEIN Blocker: Planer-Kopf gebaut+verdrahtet (ExperimentPlanDirector 2352 Zeilen, 4 Dateien, produktiv konstruiert profile_run_facade.cpp:1034-1041) | REGRESSION | KON12-01 Z10966-10990 | BEHOBEN (Entlastung, widerlegte Blocker-Behauptung, groesste dieser Nacht) | Bauplan-Kritik im Header selbst zitiert+beantwortet |
| super-Seite v32_messreihe_antrieb.hpp (329 Zeilen) REAKTIVIERT ALS OFFIZIELLES SKELETT (PhaseStrategyFor+execute_messreihe), execute_messreihe nur in 2 Testdateien, kein Produktionspfad | FEATURE | KON12-01 Z10998-11017 | GEPLANT (Verdrahtungs-Posten bei S-8) | - |
| Task #91 (Phase 0 als Blocker) gegenstandslos, geschlossen | REGRESSION | KON12-01 Z11016 | BEHOBEN (geschlossen) | - |
| Korrektur KON11-01: "ExperimentPlanDirector existiert unangeschlossen" FALSCH, zurueckgezogen | REGRESSION | KON12-01 Z11020-11021 | BEHOBEN | - |
| S-14 neu erhoben: 7 von 130 (nicht 6 von 136); Lock-Datei traegt 9 Eintraege, Diff zu 7 unaufgeklaert | REGRESSION | KON12-02 Z11026-11038 | BEHOBEN (Zahl korrigiert) | S-14 bleibt Ausroll-Auftrag: Marker in verbleibende 123 Dateien (AUFGABE offen) |
| S-17 bestaetigt: LagerBaumWriter hat keinen Aufrufer (1 Datei=eigene, 0 externe kaskade()-Aufrufe) | REGRESSION | KON12-03 Z11048-11052 | OFFEN (Verdrahtungs-Posten) | setzt O-9 voraus (Cache-Wurzel) |
| Methoden-Erkenntnis: Baustein ohne Aufrufer nur durch gezielte Messung von fehlendem zu unterscheiden, nicht durch Suche | UNKLAR | KON12-04 Z11059-11070 | BEHOBEN (Erkenntnis dokumentiert) | Bilanz 3/17 Bau-Teile geprueft (1 entlastet, 1 praezisiert, 1 bestaetigt) |
| Arbeitsprinzip: KONSOLIDIEREN-ARCHIVIEREN-in ZIELFORM AKTIVIEREN (nicht neu bauen) | OWNER-ENTSCHEID | KON11-01 Z11081-11091 | BEHOBEN | tragende Arbeitsanweisung Wellenplan §14 |
| Inventur Unverdrahtetes: 11 Positionen, 9 von 11 gebaut nicht verdrahtet | AUFGABE | KON11-01 Z11093-11109 | BEHOBEN (Inventur erstellt) | 17 Bau-Teile §14.2 neu zu lesen |
| ram_probe_chain: concept-basierte CoR, gebaut, statisch verdrahtet | FEATURE | KON11-01 Z11101 | GEBAUT | - |
| AxisCommand existiert als C++23-concept (compile-time Command) | FEATURE | KON11-01 Z11102 | GEBAUT | topics/axis_command_base.hpp:20 |
| IResourceControllableTier existiert als Laufzeit-Pendant der Limitations-Auskunft | FEATURE | KON11-01 Z11103 | GEBAUT | anatomy/resource_controllable_tier.hpp:63 |
| i_command.hpp GEPARKT seit 06.07. (#267), Laufzeit-virtual, mit Nachfolger-Vermerk | REGRESSION | KON11-01 Z11104 | OFFEN (Einordnung offen, Nachfolger AxisCommand steht) | K3/S-6d |
| catalog_codegen.cmake laeuft (gebaute Selbstkompilations-Blaupause) | FEATURE | KON11-01 Z11106 | GEBAUT | :52-60 |
| Konfliktregel geschaerft: Rang1 Owner-Wort > Rang2 Neueres > Rang3 erst Explore auf Fehlinterpretation, dann Owner fragen | OWNER-ENTSCHEID | KON11-02 Z11130-11141 | BEHOBEN | ergaenzt Rangfolge OWNER>PLAN>THESIS |
| W-1 ist kein Owner-Entscheid mehr sondern Explore-Auftrag (O-2 wandert in Explore-Liste, Owner-Vorlage 11->10 Punkte) | REGRESSION | KON11-02 Z11143-11152 | BEHOBEN (spaeter final aufgeloest KON13-01) | - |
| E-1 Owner-Zitat war still gekuerzt (KON9-06: "siehe letzter Kontext und auch sonst" weggelassen, Beleg-Verweis) | REGRESSION | KON11-03 Z11158-11185 | BEHOBEN (Regel: Kuerzung immer [...]) | dritter Fall dieser Klasse (nach KON9-06 und einer zweiten) |
| W-6 Rechenfehler in weitergegebener Zahl: 96+2+24=122 nicht 153 (Memory reference_versionierung Z85-88) | REGRESSION | KON11-04 Z11189-11213 | OFFEN (Zahl zurueckgezogen, neu zu erheben mit Zaehlweise) | trifft auch nicht die 5 anderen Messungen 104/115/124/131, auch nicht Owner-Zahl "138" |
| W-7 Zeilenanker instabil (KON8-04 :165-168 vs :706 vs :531; Ledger wuchs 20430->20973 in einer Erhebung, Drift 543 Positionen) | REGRESSION | KON11-05 Z11219-11238 | BEHOBEN (Regel: Anker ueber KON-Kennung/Symbol, Commit-Anker Pflicht) | catalog_codegen.cmake :27-37->:52-60 als Beispiel |
| Owner-Vorlage schrumpft auf 10 Punkte (O-1,O-3..O-11); Concept-Zahl 321/228->339/229; mp11-Zahl 687/186->350/169 Quellcode-Dateien | REGRESSION | KON11-06 Z11249-11255 | BEHOBEN (Zahlen korrigiert) | - |
| Selbstkompilations-Entwurf vollstaendig gefunden (19.07., BAUPLAN 253 Zeilen + FINALES-DESIGN-ABSTRACT 114 Zeilen), Begriff "Selbstkompilation" kommt 0x vor (Sache unter Director/Builder+Command+Codegen) | AUFGABE | KON10 Kopf Z11258-11272 | BEHOBEN (Bestands-Pflicht erfuellt) | - |
| Filterkette aus KON9-06 nicht neu zu erfinden, sondern zu BAUEN (Durchsetzungsform fuer D5) | AUFGABE | KON10-01 Z11290-11291 | OFFEN | - |
| Mini-Pipeline je Traeger (D17, 5 CI-Stufen St.0-St.4: Start/Planer=Mess/CEB=System/Tier=Organ+opt Hybrid/Auswertung), CiYamlBuilder->Child-Pipeline | FEATURE | KON10-02 Z11295-11310 | GEPLANT (entworfen seit 19.07., groesstes Loch=Planer-Kopf PL-1) | -> spaeter Widerspruch "keine YAML" KON16-03, F4: bleibt lokal |
| Zwei Ablagen entworfen D18+§31-A4: CI-Cache(dev-MinIO)=nur Planer-Binary statisch; prod-MinIO=alle generierten Folge-Stufen+Sidecars/Provenienz; Lager=Gattung+Genus weitere Kategorien | FEATURE | KON10-03 Z11314-11330 | GEPLANT (entworfen, nicht gebaut) | Stempel-Rolle 2 "Cache-Schluessel" entworfen |
| Planer->CEB-Nutzlast = serialisierter Teilbaum (§38): Ranges je Achse hinab, sparser Fortschritts-Ruck-Kanal (Cursor/Delta, Mixed-Radix) hinauf | FEATURE | KON10-04 Z11337-11351 | GEPLANT | deckt KON8 exakt |
| Muster-Tabelle: Interpreter(XML->ExperimentPlan), Director(ExperimentPlanDirector), 2xConcreteBuilder(CMakeGraphBuilder+CiYamlBuilder), Template-Method(resolve_selection->emit_*), CoR(Filterkette), Abstract-Factory(IExperimentDock+Registry) | FEATURE | KON10-05 Z11357-11369 | GEPLANT/TEILGEBAUT (catalog_codegen.cmake laeuft fuer Katalog-Header) | - |
| BAUPLAN-Kritiker-Blocker: super-Repo v32_messreihe_antrieb "OFFIZIELLER Einstieg" waere DRITTE Enumerations-Engine, Projektstruktur-Analyse endete am Submodul | REGRESSION | KON10-06 Z11375-11385 | BEHOBEN (spaeter aufgeloest KON12-01: Phase0 kein Blocker) | - |
| Fork D: ceb_contract_version-Minor-Bump beim Planer-Emitter (kein Bump solange kein universeller Codegen beruehrt) | AUFGABE | KON10-06 Z11389-11390 | OFFEN | vor Merge verifizieren |
| Terminlage ueberholt: Entwurf rechnet gegen 28.07., heute HY-A in W1 (F2, 21.08.) | REGRESSION | KON10-06 Z11394-11396 | BEHOBEN | Fork-C-Schnittlinie gegenstandslos, neu zu ziehen |
| Bump-Pflicht (KON9-11) haengt an D18/§31-A4: Cache entworfen, aber die Wache dagegen NICHT | REGRESSION | KON10-07 Z11407-11408 | OFFEN | - |
| widerlegt-Flag war zu grob (23 bestaetigt/9 widerlegt war Fehllesung, tatsaechlich Praezisierungen) | REGRESSION | KON10-08 Z11417-11425 | BEHOBEN (dritter Zustand PRAEZISIERT eingefuehrt) | - |
| Zeilenanker Explore um ~444 Zeilen gedriftet (Ledger:10617 fuer §40.b) | REGRESSION | KON10-08 Z11427-11430 | BEHOBEN (Regel: Symbol/Commit-Anker) | - |
| ORT und ZEIT sind zwei Ordnungen: Hybrid steht VOR Tier (ORT), wird aber ZULETZT erzeugt (ZEIT, nach Einzelmessung) | OWNER-ENTSCHEID | KON9-01 Z11440-11458 | BEHOBEN | vier Ordnungen: Traeger-Ordnung/Erzeugungs-Ordnung/Lager-Kaskaden/Stempel-Zeilen-Ordnung |
| eigener Fehler: ORT/ZEIT vermengt, F1-Ableitung faelschlich zurueckgenommen (2. Beleg derselben Fehlerklasse an einem Tag) | REGRESSION | KON9-01 Z11454-11458 | BEHOBEN | - |
| Hybrid ist NICHT stempelfrei, selbst Genus mit Flaeche 2 (eigene Achsen=Stempel; Parameterfunktionen+Stempel der Tier-Binaries=Laufzeitanfrage durchgereicht) | OWNER-ENTSCHEID | KON9-02 Z11469-11483 | BEHOBEN | dieselbe CT/Laufzeit-Trennung wie CEB |
| Hybrid ist transparenter Multiplexer, KEINE Freigabe-Stufe (CEB hat genau 1 Pruefdock, baut Hybrid+Tier gleichrangig, Hybrid baut nicht nur misst, Kopplung=Interface nicht Hardware) | OWNER-ENTSCHEID | KON9-03 Z11496-11524 | BEHOBEN | Frage C beantwortet+Praemisse widerlegt |
| Ordnungs-Relation ueber Flag-Mengen bestaetigt (x512{f.vl} subset x512{f.vl.bw}), Hardware-Spezifikations-Stempel X.Y.Z mit voller Syntax+Semantik je Achsen-Algorithmus gefordert | OWNER-ENTSCHEID | KON9-05 Z11558-11574 | BEHOBEN | Ordnung fehlt heute im Code (0 Treffer teilmenge/dominiert/ist_hoeher) -> AUFGABE offen |
| Filterkette = Selbstkompilations-Mechanismus (C++23 concept+mp11 compile-time, CEB analysiert Hardware zur Laufzeit gegen Organ-Achsen), "Du hattest das schon entworfen" | OWNER-ENTSCHEID | KON9-06 Z11586-11616 | BEHOBEN | fuehrt zu KON10-Fund (Bestands-Pflicht) |
| eigene Gedaechtnisluecke protokolliert: Entwurf war im Bestand, mir nicht praesent | REGRESSION | KON9-06 Z11612-11615 | BEHOBEN (Explore gefahren) | "unloesbare Frage ist zuerst eigene Gedaechtnisluecke" |
| Explore-Auftrag Interface-Arten+Versionierungspunkte: 5 Versionierungs-Punkte gemessen | AUFGABE | KON9-07 Z11619-11635 | BEHOBEN (Explore gefahren) | - |
| CEB-System-Stempel ist leer (literal "","",Mess-Zeile), SOLL verlangt Mess+System | REGRESSION | KON9-07 Z11637-11640 | OFFEN | ceb_version_stamp.hpp |
| Genus-Versionen handgeschrieben (5 freie Literale, alle "1.0.0.c"), SOLL: zusammengesetzt compile-time | REGRESSION | KON9-07 Z11641-11642 | OFFEN | pruef_dock_version.hpp |
| Planer-SHA fehlt, SOLL: Fingerprint-SHA fuer alle 4 Binary-Typen | REGRESSION | KON9-07 Z11643 | OFFEN | - |
| KANN und MUSS: Freigabe eroeffnet, erzwingt nicht (System->Organ DARF volle Syntax; Planer->CEB KANN, MUSS NICHT) | OWNER-ENTSCHEID | KON9-08 Z11649-11658 | BEHOBEN | deckt KON8-05 |
| MIN als Querschnittskonzept mit zwei Filtern (A=Hardware monoton, B=Mess zweischneidig), Syntax+Semantik je Achsen-Kategorie Pflicht fuer Abgabe | OWNER-ENTSCHEID | KON9-09 Z11667-11681 | BEHOBEN | Pflicht und Basis fuer Abgabe |
| Plan wird nachgebessert nicht neu geschnitten: Reihenfolge 1.Neu gruenden(erledigt) 2.Stempel fertig planen+chatten 3.Pipeline debuggen 4.Konsolidierung #88 | OWNER-ENTSCHEID | KON9-10 Z11687-11697 | BEHOBEN | - |
| Stempel-Designplan (15 Pakete ST-00..ST-14) existiert NIRGENDS als Datei (0 Treffer ueber 180 Workflow-Outputs+docs/) | REGRESSION | KON9-10 Z11699-11703 | OFFEN (verloren, Neuschnitt statt Nachbesserung richtiger) | nur Paketnamen+4 Nachbesserungs-Befunde erhalten |
| Stempel traegt FUENF Rollen: Identitaet/Cache-Schluessel/Lager-Schluessel/Skip-Marke/Einordnung, Stempel=Schluessel zu Lager+Cache | OWNER-ENTSCHEID | KON9-11 Z11713-11736 | BEHOBEN | Owner: "ohne ihn geht nichts" |
| Fehlerklasse: Aenderung ohne X.Y.Z-Bump -> Binary wird nicht neu gebaut, sieht aus wie Cache-Treffer/Erfolg | REGRESSION | KON9-11 Z11738-11746 | OFFEN (Bump-Pflicht braucht Werkzeug, nicht Disziplin) | Schnitt 2 CI-Explore |
| Hybrid ist im Lager bereits regulaere Gattung+Genus (L3 Manager mit K1 aufgehoben) | FEATURE | KON9-11 Z11759-11763 | GEBAUT | - |
| CEB-Binaries liegen in Blaettern der System-Achsen-Knoten (ceb_blatt_ebenen, ABNAHME-5) | FEATURE | KON9-11 Z11764-11765 | GEBAUT | - |
| Messwert-Schluessel = hash(fingerprint,hardware_identitaet), fail-closed bei leerer Hardware-Identitaet | FEATURE | KON9-11 Z11767-11770 | GEBAUT | messwert_key_source.hpp:88-99 |
| "alle Blocker klemmen am Stempel" Einschraenkung faellt teilweise (Cache/Lager ja, ISA-Gattierung coverage-guard nein) | UNKLAR | KON9-11 Z11776-11784 | BEHOBEN (praezisiert) | - |
| Teilmengen-Pruefung gilt UEBERALL (3 Achsen-Arten), Vertrag entsteht nur EINMAL (Mess CEB<->Tier/Hybrid) | OWNER-ENTSCHEID | KON8-12 Z11805-11830 | BEHOBEN | KON8-01 praezisiert |
| Meta-Meta-Achsen System/Organ noch zu recherchieren (Owner-Wort) | AUFGABE | KON8-12 Z11834-11837 | OFFEN (spaeter beantwortet O-4/KON19-01) | eigener Explore-Gegenstand |
| PMC ist Meta-Meta-Mess-Achse mit eigener Permutation (AMD/Intel = 2 Komponenten, nicht 1 mit 2 Auspraegungen), bereits festgelegt | FEATURE | KON8-12 Z11839-11843 | GEPLANT | verbaut in CEB+Fingerprint wenn gebaut |
| Meta-Meta-Eintraege haengen dynamisch ans ENDE der Realm-Zeile (Owner E2 02.08.), 07.08.-Erstfassung falsch zurueckgenommen | REGRESSION | KON8-12 Z11844-11846 | BEHOBEN (E-6) | - |
| Mess-Meta-Meta-Achse kann CEB/Tier-Vertrag compile-time veraendern (PMC-Beispiel) | AUFGABE | KON8-12 Z11848-11862 | OFFEN | Vertrags-Riegel muss Dynamik tragen |
| Vertrag entsteht NUR bei Dreiphasigkeit (Mess CEB<->Tier/Hybrid), System/Organ kein Vertrag (nur 1 Umsetzer) | OWNER-ENTSCHEID | KON8-01 Z11883-11902 | BEHOBEN | - |
| eigener Fehler: Teilmengen-Pruefung faelschlich als Querschnittsregel ueber alle 3 Achsen formuliert | REGRESSION | KON8-01 Z11904-11906 | BEHOBEN | Fehlerklasse: einzelbelegte Regel verallgemeinert |
| Tier und Hybrid sind GLEICHAUF nicht nacheinander (CEB->Tier UND CEB->Hybrid parallel, Hybrid laedt CT-limitiert) | OWNER-ENTSCHEID | KON8-02 Z11909-11917 | BEHOBEN | korrigiert eigene lineare Darstellung (Eigenfehler) |
| CEB hat ZWEI System-Anzeigen: ① compile-time "womit gebaut" -> Stempel; ② Laufzeit/RAM "was Hardware kann" -> NICHT Stempel | OWNER-ENTSCHEID | KON8-03 Z11923-11941 | BEHOBEN | Bauauftrag: ① fuellen, ② nicht in Stempel (AUFGABE offen) |
| System-Achse gibt in der CEB AUCH Organ frei (Freigeber ist Achse, kein Traeger-Querkante) | OWNER-ENTSCHEID | KON8-04 Z11945-11952 | BEHOBEN | - |
| Stempel ist Resultat der B+-Baum-Materialisierung (faellt an, nicht zusaetzlich geschrieben; 3 Node-Achsen-Kategorie-Typen lazy) | OWNER-ENTSCHEID | KON8-05 Z11956-11965 | BEHOBEN | - |
| Freigabe gehoert NICHT in den Stempel (Anzeige ② kein Abdruck im Tier-Stempel, aus B+-Baum-Zustand abgefragt) | OWNER-ENTSCHEID | KON8-06 Z11969-11983 | BEHOBEN | Flaeche2 bleibt schlank |
| CEB-Anzeige ② faellt aus 7-Interfaces-Liste (KON7-04) heraus | REGRESSION | KON8-06 Z11984-11985 | BEHOBEN (Ledger-Korrektur) | - |
| Pruefrichtung echte Teilmengen mit Untergrenze: MIN subset implementiert subset freigegeben, Composite-Zulassungsmatrix dreiwertig (PFLICHT/ERLAUBT/VERBOTEN) | OWNER-ENTSCHEID | KON8-07 Z11989-12021 | BEHOBEN | beide Haelften getrennt im Haus (bvset_ist_teilmenge, F-10-Wache) |
| Klammer fehlt: MIN muss je Vertrag definiert werden (nur 1 Vertrag existiert, also 1 Definition) | AUFGABE | KON8-07 Z12013-12014 | OFFEN | - |
| Basis-Flags haben ALLE Achsen-Kategorien (nvcc=cg=CPU+GPU), Organ-Achsen durch System-Achsen freigegeben, tragen volle Grammatik | OWNER-ENTSCHEID | KON8-08 Z12024-12039 | BEHOBEN | eine Grammatik, drei Kategorien |
| eigene Komplexitaets-Leiter (KON7-06) war falsch formuliert (als Eigenschaft der Kategorie statt Freigabe-Kette) | REGRESSION | KON8-08 Z12031-12033 | BEHOBEN | - |
| Flag-Katalog kartiert: c/g/f/n Basis (g/f/n reserviert nicht produziert), p/e Sub unter c; TPU/ASIC/DSP/NUMA NICHT als Token gefunden; flag_grammar_catalog.hpp (755 Z.) vorher in keinem Ledger-Eintrag | FEATURE | KON8-09 Z12041-12067 | GEBAUT (Basis existiert, g/f/n reserviert ungenutzt) | Explore wf_283f202c-0ba, 173 Fundstellen |
| Namenskollision: f=FPGA(Tiefe0) vs f=AVX-512 Foundation(unter x512), heute per Eltern-Tracking unterschieden | REGRESSION | KON8-09 Z12070-12073 | OFFEN (Risiko sobald f als FPGA-Basis eigenen Sub-Katalog bekommt) | - |
| Drei Flaeche-2-Schichten nach Entstehungszeit: compile-time(sofort baubar) / Laufzeit-Umgebung(CEB②, gehoert zum Baum) / Laufzeit-Registrierung(Hybrid-Bereichskarte, erst nach HY-B/C) | FEATURE | KON8-10 Z12079-12089 | GEPLANT | - |
| Restlandung vollstaendig 4/4 (R1 E18SNAP neu, R2 super 9f8e2be8 CI-Invarianten, R3 super 75505b9d D3-7b, R4 super cf39dc19 Wachen-Paritaet #77, R5 ce 670483c0 r7-Wachen-Divergenz #79) | AUFGABE | KON8-11 Z12091-12101 | BEHOBEN (gelandet) | - |
| Lehre ueber Lenses: "bvset_ist_teilmenge existiert nicht" FALSCH in Task #82 uebernommen, Funktion existiert tatsaechlich (14 Commits alte Basis war Ursache) | REGRESSION | KON8-11 Z12124-12131 | BEHOBEN (14. Fall dieser Klasse von 40 im Projekt) | alle "existiert nicht"-Aussagen dieses Lens verdaechtig |
| Stempel-Designplan (15 Pakete) zweimal Nachbessern noetig (Basis 14 Commits alt, Kalenderfehler "Fr 15.08."=Samstag, W1-Kapazitaet 58h ueberzogen, ST-08 bumpt auf verbotenes Layout 7) | REGRESSION | KON8-11 Z12117-12122 | OFFEN (spaeter als verlorenes Dokument befunden KON9-10) | - |
| Vier Entlastungen: golden-320 stempel-neutral (0 @-Zeichen) / keine laufende Mehrtageskampagne seit 25.06. / nie Flotte gebaut / coverage-guard stempelfrei rot | UNKLAR | KON8-11 Z12133-12142 | BEHOBEN (Entlastungen dokumentiert) | - |
| Wellenplan ##58 nennt 28 InputIfFileExists-Ziele, gemessen im echten Klon nur 13 | REGRESSION | KON8-11 Z12148-12149 | OFFEN | vor F5-Anhang-Gate zu klaeren |
| Zwei Flaechen an jeder Binary-Aussenseite: Flaeche1=Vertrag/Funktion (abstract factory, Laufzeit), Flaeche2=Identitaet (compile time factory) | OWNER-ENTSCHEID | KON7-01 Z12159-12179 | BEHOBEN | - |
| eigener Fehler: Namensgleichheit "Factory" fuer Sachgleichheit genommen (Genus-Factory != Stempel-Factory) | REGRESSION | KON7-01 Z12183-12186 | BEHOBEN | dieselbe Fehlerklasse wie "Lager-Ordnung=Stufen-Ordnung" |
| IST: Identitaets-Flaeche heute OPTIONAL nicht Pflicht (Loader verlangt nur 4 Pflicht-Symbole, Versionsstempel 5tes optional, nullptr moeglich) | REGRESSION | KON7-01 Z12188-12193 | OFFEN (SOLL: Pflicht, konkreter Bauauftrag) | anatomy_module_abi_v1_decl.hpp:136/:304 |
| Achsen-Algorithmen und Genus-Interface tragen eigene Versionen, sind aber KEINE Traeger (fliessen in Stempel bzw. sitzen 1:1 auf Tier-Fläche 2) | UNKLAR | KON7-02 Z12203-12207 | BEHOBEN (Klarstellung) | - |
| Stufigkeit bestimmt Zeilenzahl: Mess dreiphasig, System/Organ zweiphasig; Traeger-Zeilen Planer=2,CEB=3,Tier=4,Hybrid=4+Durchreichung | OWNER-ENTSCHEID | KON7-03 Z12209-12231 | BEHOBEN | - |
| OFFEN vom Owner benannt: "Stufen-Ordnung ist DREIPHASIG oder ZWEIPHASIG, da fehlt noch was" (11x referenziert, nie hergeleitet) | AUFGABE | KON7-03 Z12233-12234 | OFFEN | - |
| Sieben Interfaces von Flaeche 2 (version_xyz/mess_zeile/system_zeile/organ_zeile/fingerprint_sha/gesamt_stempel/angeschlossene) | FEATURE | KON7-04 Z12236-12248 | GEPLANT (1-6 constexpr, 7=Laufzeit-Sammler noetig) | - |
| Hybrid = Bereichs-Karte keine Konkatenation (Break-Even-Punkte sind Bereichsgrenzen je Funktion+Parameterbereich -> Tier-Binary-Stempel) | OWNER-ENTSCHEID | KON7-05 Z12252-12274 | BEHOBEN | verbindet Break-Even (##57/OV-1/OV-6/HY-C) mit Hybrid-Identitaet |
| Komplexitaets-Leiter dreistufig: System=volle Grammatik, Organ=Erweiterungs-Flags c/g/f/n, Mess=DIESELBEN wie Organ | OWNER-ENTSCHEID | KON7-06 Z12283-12293 | BEHOBEN | eigene fruehere Notiz war zu eng (Eigenfehler, behoben) |
| Gemessene Luecke: Vollausbau 59 Knoten alle im c-Zweig, g/f/n haben 0 Sub-Token | REGRESSION | KON7-06 Z12297-12302 | OFFEN | Zehn-Wochen-Explore wf_283f202c-0ba laeuft |
| Fragen-Reihenfolge ist selbst Festlegung: 1.WO(Composite) 2.WAS(Composite) 3.WIE(Strategy+Builder) | OWNER-ENTSCHEID | KON7-07 Z12306-12318 | BEHOBEN | eigener Fehler: 3 vor 1 gestellt (behoben) |
| IST: Zulassungsmatrix nirgends durchgesetzt, CEB-System-leer ist Kommentar-Begruendung kein Riegel | REGRESSION | KON7-07 Z12319-12320 | OFFEN | ceb_version_stamp.hpp:590-594 |
| Vier Muster (Composite/Strategy/Builder/Compile Time Factory), Basisform+Vererbung Pflicht ("verschaerfen nie aufweichen") | OWNER-ENTSCHEID | KON7-08 Z12322-12338 | BEHOBEN | CRTP statt virtual ist Hausform (126 CRTP/204 Concepts im ce-Baum) |
| Andockstelle S2-KATALOG-ANDOCKSTELLE vorbereitet, Katalog selbst noch nicht recherchiert | AUFGABE | KON7-08 Z12340-12343 | OFFEN | algo_semver.hpp:73 |
| Asymmetrie POD AnatomyVersionLines: Organ voll (Kompositionsfunktion), System 2/3, Mess 1/3 (kein measurement_entries-Feld) | REGRESSION | KON7-09 Z12347-12360 | OFFEN | Feldreihenfolge organ->system->measurement gewachsen nicht entworfen |
| Was offen bleibt (KON7): weitere Basis-Flags jenseits c/g/f/n; Grenze Organ/Mess-Komplexitaet vs System; Stufen-Ordnungs-Luecke; MESS-Position im Preimage | AUFGABE | KON7-10 Z12364-12370 | OFFEN | Transpositions-Sperre unabhaengig sofort baubar (-> S-6b) |
| Landungen 11.08: super P-LIZENZ 15674 33/33 gruen; ce Sammellandung P-WARN+P-D37B 15675 23/24 (1 rot test:coverage-guard); super Zwischenstandsdoku; super R3-D37B offen | AUFGABE | KON6-01 Z12378-12383 | GELANDET (teilweise, 1 rot) | - |
| P-WARN neue SHA nach --amend (Herleitung Zahl 226 war falsch, urspr. aa65b527 existiert nicht mehr) | REGRESSION | KON6-01 Z12385-12387 | BEHOBEN | gelandet b2d713d4 |
| Bester Commit 346b6da9: Ausschliessung zweier Lauf-Modi DURCHGESETZT statt nur zugesagt (3 Ebenen zeigten 0 Code-Durchsetzung) | REGRESSION | KON6-01 Z12389-12393 | BEHOBEN | ex::lauf_modus_konflikt, fail-closed exit_code 7 |
| lint:format 3x hart rot gefangen (P-LIZENZ 159 Verstoesse, ce 10); Heil-Stufe hatte faelschlich landefaehig gemeldet | REGRESSION | KON6-01 Z12395-12398 | BEHOBEN (2. Lande-Stufe fing es) | - |
| Owner-Festlegung (1): Parallel bauen, sequentiell Landen als Workflow-Stufe | OWNER-ENTSCHEID | KON6-02 Z12402-12406 | BEHOBEN | A2.1 Arbeitsweise v3.2 |
| Owner-Festlegung (2): nie Flotte gebaut -> Identitaets-Umbauten heute kostenlos, ab Mi 26.08. 06:00 teuer, F2=Identitaets-Freeze | OWNER-ENTSCHEID | KON6-02 Z12407-12413 | BEHOBEN | eigener Fehler: Kostenaussage ohne Bestandsmessung |
| Owner-Festlegung (3): Stempel-Mechanik und vertauschte Variablen sind ZWEI getrennte Themen | OWNER-ENTSCHEID | KON6-02 Z12415-12416 | BEHOBEN | - |
| Owner-Festlegung (4): Funktions-Variablen in Stufigkeits-Ordnung MESS,SYSTEM,ORGAN, Lager-Ausnahme belegt | OWNER-ENTSCHEID | KON6-02 Z12418-12426 | BEHOBEN | Ursprung von S-6/SOLL (spaeter S-6a geplant) |
| Owner-Festlegung (5): alte Stempel werden NICHT zurueckgeholt (Referenz fuer Faehigkeit, keine Code-Vorlage) | OWNER-ENTSCHEID | KON6-02 Z12428-12430 | BEHOBEN | - |
| Owner-Festlegung (7): maximale Gruendlichkeit beim Stempel, keine Kompromisse | OWNER-ENTSCHEID | KON6-02 Z12436-12437 | BEHOBEN | - |
| Owner-Festlegung (8): Konsolidierungs-Architektur getrennt Code/Doku, 4 Repos, nichts loeschen, PRT-ART+Thesis synchron | FEATURE | KON6-02 Z12439-12440 | GEPLANT | -> #88 |
| Am Objekt beide Stempel-Teile ungeheilt: sota_catalog.hpp emittiert STAMP_M mit Organ VORN | REGRESSION | KON6-03 Z12470-12471 | OFFEN | -> spaeter S-6a geplant |
| Flag-Grammatik v2 mit Klammerung (geschweifte Klammern hierarchisch rekursiv), 8 Regeln R1-R8 compile-time bewiesen | FEATURE | KON6-03 Z12474-12484 | GEBAUT | Bau-Vorlage 20260807-DESIGN-flag-grammatik-v2 |
| Grammatik-Fassung entstand an einem Tag durch dreifache Schaerfung (02.08 Q3->07.08 v2->Section8 "bindend"->Section9 F-2-Korrektur c{p.e}), Etikett "bindend" hielt keine 3h | REGRESSION | KON6-03 Z12487-12491 | BEHOBEN | - |
| Vier IST-Luecken Stempel (10.08 bestaetigt): Planer kein Fingerprint-SHA; CEB-System-Anteil leer (Kommentar kein Riegel); Genus-Versionen handgeschrieben; KEINE Vererbungshierarchie (5 lose Strukturen ohne Basis) | REGRESSION | KON6-03 Z12493-12505 | OFFEN | - |
| Forensik: 19.07 EINE Wurzel (b23b7ee2), 22.07-04.08 DREI Pakete daneben statt darauf gebaut (vier Nummernkreise/Namensschemata) | REGRESSION | KON6-03 Z12507-12510 | OFFEN | - |
| 27.07 V-4 Permutations-Alt-Kanal retired entfernte selektiven-Rebuild-Mechanismus; heute dll_is_current vergleicht 128hex auf Gleichheit -> ganze Flotte muesste neu | REGRESSION | KON6-03 Z12511-12516 | OFFEN | Faehigkeit fuer "Hardware-Erweiterung additiv"-Regel fehlt |
| #82 UEBERLEBENDER MUTANT in gelandetem Code: bvset_ist_teilmenge for(a=1;a<2;++a), page_type+general_hardware voellig blind, 21/21 Tests gruen | REGRESSION | KON6-04 Z12523 | OFFEN | - |
| #83 lint:format ohne lokale Deckung (clang-format 22.1.8 nicht im PATH) | REGRESSION | KON6-04 Z12524 | OFFEN (Sofortmassnahme Symlink, Repo-Skript fehlt) | - |
| #85 Wechselwirkung Sammellandung | REGRESSION | KON6-04 Z12526 | BEHOBEN (entlastet durch Pipeline 15675) | - |
| #80 vollstaendig aufgeklaert: 5 Test-Differenz = 4 ISA-gegatet Sollverhalten + 1 echter Pruefling-Fixture-Befund | REGRESSION | KON6-04 Z12532-12538 | BEHOBEN (4/5 Sollverhalten) | 1 echter Befund offen, Host-Klassen-Achse noetig |
| ICH HABE DIE REGRESSION VERGROESSERT: mess_ausbeute_bissprobe.sh als Shell-Skript statt Google Test gebaut | REGRESSION | KON6-05 Z12560-12565 | OFFEN | 13 Dateien/7967 Zeilen wachsend (5->12->13) |
| Beleg Shell-Form versagt: Selbstbiss-Orakel zaehlte falsch, tr-Shim exit127 liess alle 5 Mutanten als gefangen durchgehen ("SELBSTBISS GRUEN") | REGRESSION | KON6-05 Z12567-12571 | OFFEN | - |
| Korpus-Befund: Explore-Korpus war zu schmal (Rohtranskripte nur ab 06.08.); 18.07-Konsolidierung (325 Docs, 6 Kategorien) wieder auf 19 Unterordner zerlaufen | REGRESSION | KON6-06 Z12578-12591 | OFFEN | Lehre: Zielbild ohne durchsetzende Wache haelt nicht (-> #88) |
| Drei Unordnungs-Belege #88: Thesis ZWEIMAL als Submodul eingebunden, beide Pfade LEER (nicht ausgecheckt) | REGRESSION | KON6-07 Z12616-12619 | OFFEN | Falle aus Arbeitsweise V3 |
| Was als naechstes faellt: Stempel-Explore->Designplan, Restlandung R5->R4->R2, Konsolidierungs-Explore #88, dann Gitlink-Bump+main-FF | AUFGABE | KON6-08 Z12626-12636 | GEPLANT | - |
| R1-E18SNAP wird NEU GESCHNITTEN statt gelandet wie vorgelegt (Wirksamkeit null, Patch nicht mehr anwendbar, wuerde 2 gelandete Pakete zuruckdrehen) | REGRESSION | KON6-08 Z12629-12632 | BEHOBEN (Neuschnitt statt fehlerhafter Landung) | Frist vor Bau-Trigger Mi 26.08. |
| KORREKTUR AN KON4-10: KEIN Stempel-Riss (measurement_line leer bei ungesetzter Combo ist dokumentiertes SOLLVERHALTEN, schuetzt golden-320 vor Byte-Drift) | REGRESSION | KON5-01 Z12645-12669 | BEHOBEN (widerrufen, "haette funktionierenden Mechanismus repariert") | - |
| Fehlerklasse wie KON4-09: Agentenbericht uebernommen ohne Kette zu Ende zu verfolgen (V1: Bericht ist Beweismaterial, kein Beweis) | REGRESSION | KON5-02 Z12671-12679 | BEHOBEN | Regel gilt auch fuer selbst geschriebene Posten |
| Richtige Aufgabe neu geschnitten: (A) Durchstich COMDARE_MEASUREMENT_COMBO-Emission pruefen (nur 2 Kommentare, keine sichtbare Emission = die Luecke) (B) Gate-Schaerfe Provisionierungs- vs Mess-Lauf | AUFGABE | KON5-03 Z12683-12689 | OFFEN | cache_engine_builder_iterator.hpp:152/:347 |
| Empfehlung Reihenfolge S-6: Option(1) Makro-Argumente zuerst, guenstigster Moment zusammen mit ohnehin faelliger Aenderung (EIN golden-Bruch statt zwei) | AUFGABE | KON5-04 Z12690-12713 | OFFEN | 3 Ebenen mit Kosten (dup Eingriffskarte KON20-02) |
| Nebenfund: Diff-Hygiene-Wache existiert in ZWEI Fassungen (ce 779 Zeilen --bereich, super 558 Zeilen --seit-basis/--bestand), gemeinsamer --stdin-Pfad ohne Abbruch, ce 221 Zeilen mehr = schwaechere Wache bei super-main-FF | REGRESSION | KON5-06 Z12731-12743 | OFFEN | Abschrift-Fall im Wachen-Werkzeug selbst |
| Sieben Kern-Explores: KEIN EINZIGES "stimmt" (SCHON_ERLEDIGT 5, STIMMT_TEILWEISE 2, STIMMT 0) | REGRESSION | KON4 Kopf Z12749-12760 | BEHOBEN (Erkenntnis dokumentiert) | 5/7 Pakete waeren neu gebaut obwohl fertig -> Zweite-Wahrheit-Risiko |
| Ledger-Korrektur D2-G1: waren ZWEI unabhaengige Defekte nicht einer (enable_testing-Reihenfolge + gtest_discover_tests-Defekt) | REGRESSION | KON4-01 Z12762-12780 | BEHOBEN (2. Defekt geschlossen mit ca6d8af1) | - |
| Zahlenkorrektur "27 ist heute 30" (test_commands.cpp=23+test_engine_adapters.cpp=7, 3 Welch-Faelle 09.08. dazu) | REGRESSION | KON4-02 Z12785-12789 | BEHOBEN | - |
| D1b ist zu STREICHEN nicht zu bauen (keine Prebuild-Liste mehr, COMDARE_TEST_PREBUILD_TARGET=0 aktive Zeilen) | REGRESSION | KON4-03 Z12791-12800 | BEHOBEN (Streichung statt Bau) | test:unit-Inventur-Verbraucher fehlt -> Stage-Topologie-Posten (AUFGABE offen) |
| Selektor NICHT MEHR DISJUNKT (Wellenplan Z.67 ueberholt): AF_RESULT_NAMEN traegt result.csv UND *.result.csv in einer Definition | REGRESSION | KON4-04 Z12812-12826 | BEHOBEN (D3-6 erledigt, Falle F1 geheilt, gelandet 6d2e3dce) | Selbstbiss 6/6 Mutanten rot |
| ##08 Auftrag hatte Namen missverstanden ("lazy" ist Lauf-Familie-Praefix, kein Emissionsverhalten) | REGRESSION | KON4-05 Z12828-12840 | BEHOBEN (Erkenntnis: NIE BAUEN, Schema-Freeze Stufe1+B-3 erledigt) | - |
| ##20 VORSCHRIFT ist falsch nicht Code ("OR true" beim git add faellt bei JEDEM DE-only-Lauf rc=128, blindes Entfernen macht Kanal rot) | REGRESSION | KON4-06 Z12842-12845 | BEHOBEN (Erkenntnis) | - |
| ##23 Auftrag vermischte 2 Nahtstellen (A ergebnis_mappe_naht.hpp im Lauf, B tools/mess_report/ CLI), Titel "Mess-CSV->xlsx" falsch herum | REGRESSION | KON4-07 Z12847-12855 | BEHOBEN (alle 4 Teile gebaut, gegen echtes 320er-Archiv abgenommen) | - |
| Restposten R1: acht vendorierte thesis_profiles sind xlsx-blind (mit_xlsx=1, ohne_xlsx=8 von 9) | REGRESSION | KON4-07 Z12856-12859 | OFFEN | Blocker fuer jede echte Kampagne, Gitlink-Stand neu auszuzaehlen |
| Fuenf neu geschnittene Restposten (Stage-Topologie, D3-7b dritter Modus fehlt, D3-3b Leerzeile-als-Messwert, ##20-B, ##23-R1) | AUFGABE | KON4-08 Z12863-12869 | OFFEN (keiner vermessen) | alte Aufwaende D1b/D2-G1 fallen, Restposten nicht gleich teuer |
| Allgemeine Lehre: 5/5 Kern-Explore-Faelle hatten Bauauftrag am Objekt falsch (aus veralteten Plaenen/Ledger-Zitaten), 4/5 Bauende widerlegten eigenen Auftrag | REGRESSION | KON4-09 Z12874-12879 | BEHOBEN (Lehre dokumentiert: "Plan ist Behauptung ueber Code, keine Quelle") | - |
| Schaerfster Einzelbeleg P5: Ledger korrigierte KON2-15 eine tote Zeilennummer auf eine ZWEITE tote Zeilennummer | REGRESSION | KON4-09 Z12881-12883 | OFFEN | drei Zahlen fuer einen unveraenderten Satz |
| STEMPEL SYSTEM VORN ORGAN HINTEN (Owner 10.08., Argument-Reihenfolge bildet Stufen-Ordnung ab) | OWNER-ENTSCHEID | KON4-10 Z12885-12891 | BEHOBEN | Ursprung von S-6/SOLL (spaeter S-6a geplant) |
| IST-Stand falsch herum: COMDARE_ANATOMY_VERSION_STAMP hat ORGAN zuerst; im Tier-Binary measurement_line len=0 (LEER), Kette bricht an Stufe 1 | REGRESSION | KON4-10 Z12893-12909 | OFFEN (spaeter differenziert KON5-01: dieser konkrete leere Wert war Sollverhalten, generelle Organ-vorn-Ordnung bleibt zu klaeren) | ZWEI Aenderungen noetig, MESS-Stufen-Position ungeklaert |
| Kette bis ##25 ist LEER, KON4-10 ist einziger verbleibender Blocker vor F1 (Fr 14.08.) | AUFGABE | KON4-11 Z12914-12918 | OFFEN | dup/Ursprung von V-1 |
| Gesicherte Abbruch-Arbeit liegt in Job-Verzeichnis das mit dem Job stirbt (/home/comdare/.claude/jobs/5a19728e/tmp/abbruch-bewahrt/, 103810 Byte, Worktree wt-super-d3 existiert nicht mehr) | REGRESSION | KON3-01 Z12951-12973 | OFFEN (BLOCKIEREND, Ledger-Stand FEHLT) | einzige Kopie der D2-Abdeckungs-Arbeit+3 Proben-Skripte |
| 102-Minuten-Haenger test:secrets auf prod2 (16s auf prod1 vs 102min prod2 stuck_or_timeout), Ursache geklaert (OOM, sequentiell) aber Job-Pool-Frage+Messung nicht gebucht | REGRESSION | KON3-02 Z12977-12994 | BEHOBEN (spaeter beantwortet F9, prod2 bleibt) | - |
| Vorgeschichte: 09.07. configure-Hang "prod2-Node-spezifisch" (gebucht) nie gegen "meine parallelen Pipelines"-Ursache (10.08.) geprueft | REGRESSION | KON3-02 Z12995-13003 | OFFEN | Verbindung zwischen 2 Ursachenzuschreibungen fehlt |
| XML-Wache hat zwei Zweighaelften die nachweislich nichts beobachten koennen (grep-Zweig nicht ausloesbar ohne root, Nenner-Mismatch-Zweig unbeobachtbar/Mutant ueberlebt) | REGRESSION | KON3-03 Z13014-13026 | OFFEN (BLOCKIEREND) | Nachpruef-Frage "unbeobachtbare Zweighaelfte zulaessig?" nie beantwortet |
| 117-Posten-Inventur ungedeckter Stellen vom 08.08. (7 Klassen: 29+25+23+16+10+9+3+2) nirgends gebucht | REGRESSION | KON3-04 Z13038-13052 | OFFEN (BLOCKIEREND) | einzige Gesamtzaehlung mit Klassenverteilung, fehlt als Nenner |
| Von 246 Ernte-Funden sind 161 als FEHLEND vermerkt (LEDGER-STAND), gebucht ist bislang nur die Zahl 246 | REGRESSION | KON3-05 Z13059-13083 | OFFEN (BLOCKIEREND) | 34 BLOCKIEREND-Positionen darunter |
| Bauweg-Wachen-Selbsttest hohl: 7 Mutationsbatterie, 5 ueberleben, Nenner rutscht still 473->451 | REGRESSION | KON3-05 Z13076-13077 | OFFEN | Teil der 246-Ernte |
| M4-Wache laesst 48,7% des Korpus ungesehen verschwinden bei 21 gruenen Tests | REGRESSION | KON3-05 Z13078 | OFFEN | Teil der 246-Ernte |
| gattung_of() faellt still auf eine gueltige falsche Gattung | REGRESSION | KON3-05 Z13078-13079 | OFFEN | Teil der 246-Ernte |
| Export verliert die statistische Gegenprobe vollstaendig (0 von 10 CSV-Spalten) | REGRESSION | KON3-05 Z13079-13080 | OFFEN | Teil der 246-Ernte |
| Bestandslog schreibt EINEN Eintrag je binary_id trotz vieler Bauweisen (leere Zelle, Fingerprint bei 320 ids unter [O2,avx2]+[O3,avx512] bit-identisch) | REGRESSION | KON3-06 Z13091-13101 | OFFEN (BLOCKIEREND) | Mess-Provenienz-Risiko, SKIP koennte falsch begruendet sein |
| Zwei Bau-Workflows mitten im Lauf gestoppt (wm1mm5nu2, w0kmlbvln), nie aufgeraeumt, Owner-Ruege "haengt in der Luft" | REGRESSION | KON3-07 Z13116-13124 | OFFEN (HOCH) | Owner-Regel [analysieren+aufraeumen+Strang wiederaufnehmen] nirgends niedergeschrieben |
| 6,8 GB im Job-Verzeichnis, 3 GB als "koennten Belege sein" geparkt (nachpruefung-w1 2.2G, l1_landing 792M, widerlege 440M, ce_audit 278M, audit-zahlen 263M +8 Klone) | REGRESSION | KON3-08 Z13140-13152 | OFFEN (HOCH) | Platte 87% belegt, unentschieden ob Belege noch tragen |
| Frage ans Pruefungsamt zum Ausfertigungsdatum (07.08.) nie nachverfolgt | REGRESSION | KON3-09 Z13163-13172 | BEHOBEN (spaeter beantwortet durch Owner KON22-01(1): Abgabe=Ausfertigungsdatum) | - |
| gitleaks-Vakuumfalle erneut zugeschnappt 10.08. 06:49 trotz Register (0 commits scanned, Push war schon vollzogen) | REGRESSION | KON3-10 Z13188-13198 | BEHOBEN (Fall sofort nachgeholt und geheilt) | zweite Eintrittsart (Klon origin==HEAD) nicht im Register benannt (AUFGABE offen) |
| Werkzeug-Ausfall als Erfolg gezaehlt: 3x StructuredOutput abgewiesen, Agent kapitulierte auf Platzhalter "test", Journal protokolliert Kapitulation als Erfolg | REGRESSION | KON3-11 Z13214-13226 | OFFEN (HOCH, neue Art stummer Workflow-Tod) | "menge-deckel"/"Platzhalter-Kapitulation" nicht registriert |
| Werkzeugfalle YAML-Flow-Syntax liefert Block-Listen-Parser stille Null (dreifache Fehlmessung 44/48, 42/48, 45/51) | REGRESSION | KON3-12 Z13237-13244 | OFFEN (HOCH) | K11-Klasse in neuem Gewand, VERFAHREN nicht im Fallen-Register |
| Zwei Bau-Straenge (9,10) liefen ohne Pflicht-Explore; angekuendigte Rueckbau-Folge blieb aus (sachlich abgewendet via Nearest-Rank) | REGRESSION | KON3-13 Z13258-13268 | BEHOBEN (Rueckbau abgewendet) | Eintrag fehlt: Konsequenz geprueft+nicht gezogen (AUFGABE offen) |
| Vorbedingung clang-Warnungsrunde ungeklaert (build:clang opt-in/advisory, laeuft normal nicht, skipped in Pipeline 15447) | REGRESSION | KON3-14 Z13280-13291 | OFFEN (HOCH) | Aufgabe #43 Vorbedingung, nicht als offene Frage markiert |
| Quellenlage: 3 von 5 genannten Kontextdateien enthalten KEINE Nachricht (nur 226 Byte Metadaten) | REGRESSION | KON3-15 Z13302-13322 | OFFEN (NORMAL, methodisch) | Deckungs-Irrtum fuer kuenftige Durchgaenge |
| Hybrid-Gattung auf Bibliotheksseite nicht registriert (hybrid in libs/cache_engine/CMakeLists.txt=0); test_hy_a1 war 0, jetzt 4 | REGRESSION | KON3-16 Z13333-13350 | TEILWEISE BEHOBEN (Testhaelfte erledigt) | Bibliothekshaelfte-Frage offen (header-only?) |
| Zwei benannte Leseluecken 07.08. nie geschlossen: (a) harness/perm_runner.hpp nicht gegengelesen (b) Verzeichnis-Schnitt des Overlays offen | REGRESSION | KON3-17 Z13360-13372 | OFFEN (NORMAL) | - |
| Owner-Auftrag "abbruchsichere Pause" ist Betriebsregel OHNE Niederschrift (2x gefordert 01.08./03.08., nur als Dokument-Name nicht als Verfahren) | REGRESSION | KON3-18 Z13378-13390 | OFFEN (NORMAL) | Bezug zu KON3-07 |
| dmidecode-Widerspruch prod2 DDR5 vs Schluessel ddr4_2x32 (27.07. dokumentiert) | REGRESSION | EHRLICHER REST Z13408-13411 | BEHOBEN (ram_pair=ddr5_2x32, 0 Treffer ddr4_2x32) | geprueft und entlastet statt gebucht |
| Dritte Falsch-Null-Klasse: Mixed Encoding, Gross/Klein, harter Zeilenumbruch ~95 Zeichen (9 Falsch-Nullen am 10.08. entstanden) | UNKLAR | LEDGER-KONS.II Kopf Z13464-13480 | BEHOBEN (Verfahren dokumentiert: geflachte Kopie+beide Encodings+-i) | Memory-Doktrin verankert |
| SIEBEN GitLab-Geheimnisse in Transkript geraten (Gruppe3: MINIO_SECRET_KEY,GITLAB_DEPLOY_TOKEN; Projekt288: CE_SUBMODULE_TOKEN,MINIO_ACCESS_KEY,MINIO_SECRET_KEY,COMDARE_NFS_DROP_TOKEN,COMDARE_THESIS_WRITEBACK_TOKEN; Projekt286 nicht betroffen) | REGRESSION | KON2-01 Z13486-13511 | BEHOBEN (spaeter Owner-GO Rotation KON22-01(6), 7 Variablen rotiert Task #70) | - |
| Folgeschaden: Verify-Agent hat CI/CD-API danach bewusst nicht mehr angefasst, Widerruf CMAKE_BUILD_PARALLEL_LEVEL=12 nur 1 statt 2 Messungen | REGRESSION | KON2-01 Z13513-13516 | OFFEN | Verifikationsluecke |
| 776 Runner-Token liegen weiter auf super origin (refs/backup/pre-secret-scrub-20260802), Loeschung braucht Owner-Autorisierung | REGRESSION | KON2-02 Z13518-13529 | OFFEN | dup/Ursprung V-6 (776 Runner-Token ungeprueft) |
| gitleaks meldete einmal 89 Funde bei exit 0, nur 3 sichtbar, Herkunft der uebrigen 86 unbelegt (VIERTE stille Null) | REGRESSION | KON2-03 Z13531-13539 | OFFEN | Re-Scan aller 4 Klone+thesis-Repo fehlt |
| gitleaks ist auf prod1 NIRGENDS dauerhaft installiert (2 unabhaengige Befunde, kein PATH) | REGRESSION | KON2-04 Z13541-13552 | OFFEN | Doktrin verlangt Lauf vor jedem Push |
| gitleaks-Vakuum am Worktree mit literaler Ausgabe (RC_GITLEAKS=0 trotz "not a git repository", 95s spaeter Push raus); Scan ueber Push-Inhalt lief an 0 von 49 Pushes | REGRESSION | KON2-05 Z13556-13568 | OFFEN | 0-von-49-Zahl nicht im Ledger |
| SOLL je Stufe Owner-Wort 10.08 verbatim, vom Owner selbst bestaetigt "das ist jetzt alles korrekt" (Achsen-Algorithmus eigene Version; Genus=CT-Zusammensetzung aller Achsen; Planer/CEB/Tier/Hybrid je mit SHA) | OWNER-ENTSCHEID | KON2-06 Z13576-13595 | BEHOBEN | Referenz-Tabelle fuer Stempel-Bau |
| Mechanismus Owner-Wort 10.08: Organ-Achsen Durchreichen+CT-Stempel in fester Reihenfolge; System isoliert Hardware; Mess isoliert bei CEB-Compile; CEB uebergibt Mess-Eigenschaften an Tier fuer CT-veraenderlichen Vertrag | OWNER-ENTSCHEID | KON2-07 Z13599-13607 | BEHOBEN | - |
| Mess-Achsen sind nicht gleich: measurement_tooling_registry=einzige Haupt-Achse mit System-Syntax, alle uebrigen nur X.Y.Z+hardware flags | OWNER-ENTSCHEID | KON2-08 Z13611-13621 | BEHOBEN | entlastet IST (3 Eintraege 1.0.0.c nie gebumpt = kein Mangel) |
| W12-B zur HAELFTE erledigt: Organ-Aenderung chirurgisch FUNKTIONAL ERFUELLT durch juengeren Kanal (A2-Eichung 05.08, dll_is_current SHA512 als Skip-Kriterium); System-Aenderung -> Vollbau, W12-B fehlt weiterhin | REGRESSION | KON2-09 Z13629-13655 | TEILWEISE BEHOBEN (Organ-Teil durch juengeren Kanal) | dup/Praezisierung zu V-10 (W12-B seit 19.07 unveraendert) |
| Kosten-Ursache ist der HASH nicht die Vergleichszeile (Alt-Kanal Klartext-Vergleich am 27.07. entfernt, heute SHA-512, Teilmenge auf Hash nicht pruefbar) | REGRESSION | KON2-10 Z13661-13671 | OFFEN | Bestandslog-v4-Muster als Vorbild (Version muss lesbar am Eintrag stehen) |
| Schriftliche Zusage verletzt: ERWEITERUNGS-LEITFADEN.md:116 verspricht Skip via .version-Sidecar, abgeschaltet seit 05.08. (F7 "NUR") | REGRESSION | KON2-11 Z13677-13683 | OFFEN | Leitfaden muss korrigiert werden |
| "Build unmoeglich"-Bruchstelle benannt: Hardware-Erweiterung ist ADDITIV BRICHT (dreifach belegt, jede Erweiterung kostet Vollbau statt neue Permutationen) | REGRESSION | KON2-12 Z13689-13703 | OFFEN | "wirtschaftlich unbezahlbar" bei 2^17-Flotte |
| Wiederaufbau-Plan sechs Pakete mit Reihenfolge-Begruendung (1.bvset Klartext ins Sidecar 2.Glied[6] recorded-subset-current 3.Bump-Erzwingung 17 Achsen 4.Hybrid versionieren 5.CEB-Array-Form §58-V 6.Doku) | AUFGABE | KON2-13 Z13705-13722 | GEPLANT | Pakete 1+5 invalidieren, buendelbar zu EINEM Vollbau |
| Beobachtbarkeits-Riegel geplant: Selbstbewachung A-subset-B-Test, Zaehler in Ausgabe (Lehre aus 3 Wochen stummes Gate) | AUFGABE | KON2-14 Z13724-13735 | GEPLANT | - |
| Luecke: "Job mit rules, dessen Variable nirgends gesetzt ist" NICHT durch YAML-Doppelschluessel-Wache gedeckt | REGRESSION | KON2-14 Z13735-13736 | OFFEN | eigener kleiner Posten |
| VERTRAG CEB<->TIER-BINARY EXISTIERT und ist PRODUKTIV VERDRAHTET (mess_konsistenz_gate.hpp, vor jeder Messung fail-closed, 6 Ablehnungsklassen, 3 Geschwister-Gatter) | FEATURE | KON2-15 Z13738-13760 | GEBAUT | staerkster Einzelfund des Tages |
| Befund geheilt: measurement_line hatte VOR D-2 NULL produktive Leser (Vollzensus 20 Treffer alle Deklaration/Test) | REGRESSION | KON2-15 Z13756-13759 | BEHOBEN | Gegenprobe organ_line/system_line: 31 Treffer, 2 produktiv |
| "hartkodierter 5er-Platzhalter" System-Zeile GESCHLOSSEN aber NICHT NACHGETRAGEN (kSystemAxisCodeCount 5->3, Owner-KERN: genau 3 System-Haupt-Achsen) | REGRESSION | KON2-16 Z13778-13784 | OFFEN (Doku-Nachzug, Ledger hat Schliessung nirgends vermerkt) | - |
| "Mess-Array FEHLT GANZ" (§58-V) GESCHLOSSEN UND bereits nachgetragen (kCebMeasurementStampFor existiert) | REGRESSION | KON2-16 Z13786-13789 | BEHOBEN (bestaetigt) | - |
