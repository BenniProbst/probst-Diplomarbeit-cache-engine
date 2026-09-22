# ANALYSE DES VERTEIDIGUNGSVORTRAGS (EN-Deck 19.09.2026) -- Order 289, Lead 5a19728e

Erstellt 2026-09-21 (Owner-Order 289 vom 20.09.2026 21:18Z). Gegenstand: die fuenf vom Owner hochgeladenen Dateien in
docs/presentation/ (Deck pptx 23 Folien, Speaker Guide, Summary, Review + Examiner Q&A, pilot_paired_effects.csv),
vollstaendig gelesen (Extrakte im Beweisort 20260920-order-289-praesentation/, LQ 55.466wm). Diese Analyse aendert
NICHTS am Deck. Owner-Rahmen (verbatim-Kern): "der Vortrag folgt unserer thesis, nur das Vortrags Design, Anordung,
Grafiken bleiben in etwa wo sie sind"; "Die Bearbeitung des Vortrages erfordert allerdings zuerst die Fertigstellung
der Thesis"; Redezeit "19 bis 20 Minuten (harte Grenze)" + "5 Minuten Fragen". Verteidigungstermin laut Deck:
28.09.2026. Order 258 (Thesis = oberste Prioritaet) bleibt unberuehrt; der Abgleich (Abschn. 9) startet erst nach
der Thesis-Endlandung.

## 1 Bestand

| Datei (docs/presentation/) | Umfang | Rolle |
|---|---|---|
| 20260919 Cache_Engine_Defense_EN-cache-awareness_Composition.pptx | 23 Folien = 15 Hauptroute + 8 Backup | Vortrag |
| Cache_Engine_Speaker_Guide_EN_Composition.docx | 15 Folien: Zeitfenster, Sprechtext, Quellappendix | Redeskript |
| Cache_Engine_Defense_Summary_EN.docx | 1 Seite: Forschungsfrage, Beitrag, Reproduzierbarkeit, Grenzen | Handout |
| Cache_Engine_Defense_Review_and_QA_EN.docx | Evidenz-Review, 12 Pruefer-Fragen, Gates, Quellindex R1-R18 | Review |
| pilot_paired_effects.csv | 133 Zeilen: gepaarte Effekte des Pilots 18.06.2026 (3 Wiederholungen) | Folien 12-14 |

Quellstand des Decks (Speaker-Guide-Appendix + Review Tabelle 1): Thesis development 56a8fe08 (Lesung ueber den GitHub-
Connector, 6 DE-Hauptkapitel + 6 DE-Anhaenge, EN NICHT re-reviewed), Snapshot 16.09.2026: super d738e80b, ce eb69abc1,
prt-art b539d6ee, thesis 784aae15. Pilot-CSV tier150_measurements_INDEX320_cowfix-v1_2026-06-18.csv (sha256
  c04f622a...).
Deck-Zusicherung: keine neue Messung, kein neuer Vollbau, keine CI-Ausloesung fuer die Praesentation.

## 2 Zeitbudget der Hauptroute (aus dem Speaker Guide, Sekunden)

| Folie | Titel (Kurzform) | Fenster | s |
|---|---|---|---|
| 01 | Titel: Active Cache-Aware Hardware Adaptation | 00:00-00:20 | 20 |
| 02 | What is an index for? | 00:20-01:25 | 65 |
| 03 | Roadmap -- following the thesis | 01:25-01:45 | 20 |
| 04 | Existing indexes make different choices | 01:45-03:15 | 90 |
| 05 | From design axes to a storage organ | 03:15-04:30 | 75 |
| 06 | Wire organs into a complete algorithm | 04:30-05:55 | 85 |
| 07 | Three design spaces, two binding times | 05:55-07:10 | 75 |
| 08 | The profile binds the pieces of the anatomy | 07:10-08:35 | 85 |
| 09 | Build and measure the assembled algorithm | 08:35-10:10 | 95 |
| 10 | Measure the algorithm and its organs | 10:10-11:30 | 80 |
| 11 | Evaluation: define the comparison first | 11:30-12:30 | 60 |
| 12 | Experiment 1: node capacity | 12:30-14:20 | 110 |
| 13 | Experiment 2: workload changes the ranking | 14:20-16:10 | 110 |
| 14 | Experiment 3: alignment has a cost | 16:10-18:00 | 110 |
| 15 | Conclusion: test cache-aware design choices | 18:00-19:00 | 60 |
| Summe | 15 Hauptfolien | | 1140 = 19:00 |

Befund Z-1: Die Hauptroute ist auf exakt 19:00 geplant. Gegen den Owner-Rahmen (19-20 min hart) ist das 0 s Puffer zur
Untergrenze und 60 s Reserve bis zur harten Obergrenze. Die drei Ergebnisfolien 12-14 (je 110 s) tragen 29 % der Zeit
und sind das Ueberzieh-Risiko (drei Sprechtexte mit je fuenf Absaetzen).
Befund Z-2: Deck und Speaker Guide planen "approximately 6 minutes for questions"; Owner-Rahmen = 5 Minuten. Der
Fragenteil ist keine Redezeit; die Zahl 6 ist im Deck/Guide nachzuziehen (Abgleichspunkt A-01).
Befund Z-3: Acht native Klick-Animationen (clickEffect im Roh-XML: je zwei auf den Folien 5, 6, 8 und 9; Messung am
Original-Deck 22.09.2026, md5 43f805b8; KORREKTUR V-8-02 der Tiefenanalyse 353, hier stand "Zwoelf ... Folien 4-8");
die PDF-Fassung zeigt Endzustaende. Die Probe der Klickfolge gehoert in die Rehearsal-Gates (Review Abschn. 6), nicht
in diese Analyse.
Empfehlung (erst im Abgleichs-Zug): Sollzeit 19:20-19:40 mit benannter Kuerzungsreserve je Ergebnisfolie (z. B. der
letzte Absatz von 12/13/14 als optional markiert), damit 19:00 nicht unterschritten und 20:00 nicht ueberschritten wird.

## 3 Quellstand-Drift gegen die laufende Thesis

Das Deck folgt der Thesis @56a8fe08; die Thesis steht heute bei 3f589ea5 (development == main, GitLab + GitHub) und
wird im Order-272-Zug weiter bearbeitet (Stufe 0 FF-Commit 19893a89 auf bau/thesis-121-de, danach N286, T2, Sprach-
Tafel, Kommentar-Audit, T3, EN-Bau), anschliessend Endlandung, EN-Zug und T1 (Anhang-Figuren nach der Kampagne).
Drift-Klassen, die den Vortragstext beruehren:
- D-1 FORSCHUNGSFRAGEN (Order 283/286): FF-Block Kap. 1.3 rueckgebaut (FF2.d Workload-Frage 15.06. zurueck, FF4.a-
  Etikett, Meta-Meta O3-Umschreibung). Das Deck nennt eine "research question" (Summary) und die "central question"
  (Folie 1/15), nicht FF0-FF4 einzeln. -> A-02 (Abschn. 5).
- D-2 BEGRIFFS-KANON (Order 286/287): Gattung statt Algorithmus-Kategorien, Haupt-/Unter-Achse statt -Entscheidung,
  Binary-Identitaet statt Permutations-Identifier, Entwurfsbestandteile statt Erweiterungs-Bausteine, Erweiterungs-
  Hardware statt Hardware-Erweiterungen; kein Begriff vor seiner Erklaerung. Der Terminology Freeze des Reviews
  ("34 SOTA paper profiles", "18 current Map organ slots", "five canonical organ groups", "interface family", "Tier
  class", "test dock", "compile-time composition, runtime parameterization, measurement-driven binary selection",
  "design realm" vs "artifact-storage realm") ist gegen den DE-Kanon zu spiegeln. -> A-03.
- D-3 META-META-ACHSE: Thesis Kap. 1.4 (Fassung 3f589ea5) fuehrt die neunzehnte Organ-Meta-Meta-Achse; das Deck sagt
  "18 organ slots" und im Speaker-Guide-Appendix ausdruecklich "instead of creating a universal extra layer or an
  additional nineteenth slot"; B8 traegt "an organ can itself be composed" (zwei Abstraktionsebenen). Das ist der
  zentrale inhaltliche Abgleichspunkt; Vorgabe = Owner-Antwort N-02 (Meta-Meta O2/O3) des Pakets N286. -> A-04.
- D-4 SPRACHSTIL/PLATZHALTER (Order 270/272, T3): 245 Sprach-Stellen + Platzhalter-Familien -> Tabellen; betrifft
  Zitate des Decks aus der Thesis nur indirekt (das Deck zitiert nicht woertlich), aber die Roadmap (Folie 3) und der
  Crosswalk (B7) referenzieren Kapitelnamen -> A-05.
- D-5 EN-STAND: Das Deck ist englisch; der EN-Zug der Thesis kommt NACH dem DE-Zug. Die englischen Fachbegriffe des
  Decks sind vor dem EN-Zug festzuziehen, damit Deck und EN-Thesis dieselben Woerter tragen -> A-03/A-06.
- D-6 ERGEBNISFOLIEN 11-14 = historischer Pilot 18.06.2026 mit explizitem Replacement Gate (Review Abschn. 3/6). Die
  Ersatzdaten kommen aus der Kampagne (Trigger-Pfad ##49, Thesis-T1 #254); bis dahin bleibt die Beschriftung
  "historical pilot" Pflicht -> A-07.
- D-7 QUELLINDEX R1-R18 pinnt Dateien am Snapshot 16.09.; nach der Endlandung sind die Pins zu erneuern (B7 nennt
  diplomarbeit.tex @56a8fe08) -> A-08.

## 4 Folienweise Abgleichspunkte (Kandidaten fuer den Abgleichs-Zug, keine Aenderung jetzt)

| Nr | Folie(n) | Gegenstand | Thesis-Anker (Fassung 3f589ea5, nach Endlandung neu messen) |
|---|---|---|---|
| A-01 | Guide-Kopf | 6 min Fragen -> 5 min (Owner) | Owner-Order 289 |
| A-02 | 1, 15, Summary | FF0-FF4 implizit -> Zuordnung je Ergebnisfolie in den Notizen | Kap. 1.3 nach Paket FF |
| A-03 | 5-10, B3, B4 | EN-Terminologie gegen DE-Kanon (Gattung, Haupt-/Unter-Achse, Binary-Identitaet) | O.286/287 |
| A-04 | 5, 6, B3, B8 | 18 Slots / "no 19th slot" vs Meta-Meta-Achse Kap. 1.4 | N-02 (N286), Kap. 1.4/3 |
| A-05 | 3, B7 | Kapitelnamen der Roadmap und des Crosswalks | diplomarbeit.tex Endstand |
| A-06 | alle | EN-Wortlaut gegen die EN-Thesis nach dem EN-Zug | EN-Zug |
| A-07 | 11-14, B6 | Pilot-Panels -> Kampagnendaten (Replacement Gate) | T1 #254, ##49 |
| A-08 | B7, Notizen, Guide-Appendix | Quell-Pins 56a8fe08 / 16.09.-Snapshot | Endlandungs-Tips |
| A-09 | 1 | Titel des Decks vs Titel der Thesis | \title in diplomarbeit.tex |
| A-10 | 8 | ART-Profil-Extrakt vs art.profile.xml (profile_ref-Kanon OV-1(b), K-1 Option C) | ce sota/art.profile.xml |
| A-11 | 9, 10 | Rollen Planner/CEB/Tier, Messebenen w/ma/mi (wallclock/macro/micro) | Kap. 3/4 |
| A-12 | B5 | Publikationsweg (PDF-Writeback Order 288) bleibt Backup; Betreuer deprioritisierte Automation | Review 6 |
| A-13 | 4 | Related Work (CSS/CSB+, ART, HOT, Masstree) vs Kap. 2 Zitate | Kap. 2, bib |
| A-14 | 12-14 | Zahlen der Folien gegen pilot_paired_effects.csv (Abschn. 7) | CSV im selben Ordner |

## 5 Forschungsfragen-Abbildung

Das Deck listet FF0-FF4 nicht explizit. Die drei Ergebnisfolien beantworten je eine Vergleichsfrage (Knotenkapazitaet,
Workload-Abhaengigkeit der Suchmethode, Alignment-Kosten); Folie 15 fasst zusammen. Nach der Konvergenz des Pakets FF
(Lens 0/0) ist je Ergebnisfolie in den Notizen die FF-Nummer zu vermerken, ohne Folienbau: die Zuordnung ist ein
Sprechtext-Zusatz. Bis dahin ist keine Aussage darueber moeglich, ob FF2.d (Workload-Frage) im Deck durch Folie 13
gedeckt ist -- das ist der wahrscheinlichste Fall und wird im Abgleich geprueft (A-02).

## 6 Backup-Folien B1-B8 (ausserhalb der Zeitroute)

| Folie | Inhalt | Bewertung |
|---|---|---|
| B1 | Drei Vergleichsarten (Original, Rekonstruktion, isolierter Organ-Test) | Deckt "34 Profile = Original?" |
| B2 | PRT-ART als Extension Probe (Plugin, nicht Startgeschichte) | Konsistent mit K-1 Option C (Plugin-Projekt) |
| B3 | Volles Organ-Inventar (18 Slots, 5 Gruppen) | A-04: gegen Meta-Meta-Achse abgleichen |
| B4 | Interface families + compositions | A-03 Begriffs-Kanon |
| B5 | Application and publication output ("moved to backup as requested in the rehearsal") | A-12; Writeback = Backup |
| B6 | From pilot data to final evidence | A-07 Replacement Gate |
| B7 | Thesis-to-talk crosswalk @56a8fe08 | A-05/A-08 neu ziehen |
| B8 | An organ can itself be composed (zwei Abstraktionsebenen) | A-04; Owner-Konzept Meta-Meta O2/O3 anwenden |

## 7 CSV-Konsistenz (pilot_paired_effects.csv, 133 Zeilen)

Die im Speaker Guide und Review genannten Effekte (Node16 -9.52 / -8.22 / -7.89 % gegen Node4; Node256 +3.70 / +3.70 /
+3.77 %; je 480 gepaarte Kontexte; 320 Binaries; 120.960 Rohzeilen / 109.440 behalten; ycsb_e + lp_range_scan
ausgeschlossen) wurden bei der Volllesung (K238, LQ 55.466wm) gegen die CSV gelesen und stimmen ueberein. Der
Abgleichs-Zug wiederholt die Nachrechnung maschinell (A-14), weil die Panels 12-14 spaeter durch Kampagnendaten
ersetzt werden und dieselbe Rechnung dann am neuen Datensatz laufen muss (Review Abschn. 3, Replacement Gate:
CSV/XLSX + Commits + Profil + Hardware/ISA + Datensatz-Checksummen + Ausschlusskriterien + Validitaetsbeleg).
NACHTRAG V-8-04 (22.09.2026): 480 gepaarte Kontexte gelten fuer die Achsen node_type und search_algo; Folie 14
(memory_layout) nutzt 384 gepaarte Kontexte je Lauf/Workload/Variante; hier fehlte die 384. CSV-Messung 22.09. je
Achse (Spalte pairs): node_type 480, search_algo 480, memory_layout 384 und 768, prefetch 9120 (132 Datenzeilen).

## 8 Q&A-Katalog (Review Abschn. 4/5) -- Deckung und Ergaenzungskandidaten

Vorhanden (12 Fragen): Neuheit gegen OpenTuner/SPIRAL; Separation != Unabhaengigkeit; "active" bei statischer
Kompilation; PRT-ART-Rolle; 34 Profile != Originaltreue; ganze Indizes vs Komponenten; Cache-Kontrolle; Beweiskraft der
Pilotplots; Mediane je Wiederholung; Noise-Winner-Vermeidung; Hybrid-Runtime (MaxDocks == 1); ABI-Stabilitaet.
Ergaenzungskandidaten aus dem Thesis-Stand (nach Endlandung zu formulieren, nicht jetzt): (Q-a) Was ist die Organ-
Meta-Meta-Achse und warum keine 19. Slot-Zeile (A-04)? (Q-b) Wie lauten FF0-FF4 und welche Folie beantwortet welche
(A-02)? (Q-c) Stand der Kampagne / wann ersetzt die finale Messreihe den Pilot (A-07, T1)? (Q-d) Binary-Identitaet und
Fingerprint-Doktrin (Mess-, System-, Organ-Achsen identisch -> identische Binary) als Antwort auf Reproduzierbarkeit.
(Q-e) Lizenz-/Veroeffentlichungsstand (CC-BY der Thesis, Apache-2.0 des Codes) falls gefragt.

## 9 Abgleichs-Fahrplan (Start ERST nach Thesis-Fertigstellung; Design, Anordnung und Grafiken bleiben)

V-1 Quellstand neu pinnen: Endlandungs-Tips der vier Repos + Thesis-Endstand; B7/Guide-Appendix/Notizen-Pins (A-08).
V-2 Begriffs-Abgleich: Terminology Freeze gegen den DE-Kanon (Order 286/287) und die EN-Thesis nach dem EN-Zug; jede
    Abweichung als Zeile Deck-Wort | Thesis-Wort | Entscheid (A-03/A-06).
V-3 Meta-Meta-Achse: B3/B8/Folien 5-6 gegen Kap. 1.4/3 nach N-02 (A-04) -- Sprechtext und Notizen, keine neue Folie.
V-4 FF-Zuordnung in den Notizen der Folien 11-15 (A-02, Abschn. 5).
V-5 Roadmap/Crosswalk/Titel gegen die finale Kapitelstruktur (A-05/A-09).
V-6 Zeitprobe: Speaker Guide auf 19:20-19:40 mit Kuerzungsreserve; Fragenteil 5 min (Z-1/Z-2/A-01).
V-7 Ergebnisfolien nach der Kampagne (A-07/A-14): Panels 12-14 + Captions + Evidence-Manifest gemeinsam ersetzen.
V-8 Begleitdokumente (Guide, Summary, Review) nachziehen; Extrakte per python-pptx/python-docx im Beweisort
    gegenlesen; Owner-Probe des Klick-Ablaufs in PowerPoint (Review Abschn. 6).
Werkzeuge: uv run --with python-pptx --with python-docx (Extraktion), keine Layout-Aenderung durch die Session;
Deck-Aenderungen = Owner-Handgriff oder Lead-Vorlage je Folie (Text der Notizen), nie Grafik-/Anordnungs-Umbau.

## 10 Kenntnisnahmen fuer den Owner

K-1 Fragenteil: Deck 6 min vs Rahmen 5 min (Z-2).
K-2 Redezeit exakt 19:00 ohne Puffer nach unten; Reserve 60 s nach oben (Z-1).
K-3 Deck-Quellstand 56a8fe08 / 16.09. liegt hinter 3f589ea5 + Order-272-Zug + EN-Zug; Abgleich nach Endlandung.
K-4 Meta-Meta-Achse (Kap. 1.4) vs "18 organ slots / no 19th slot" = inhaltlicher Kernabgleich (A-04).
K-5 Folien 11-14 haengen an der Kampagne (Replacement Gate = T1 #254 / ##49); gleiche Abhaengigkeit wie Thesis-T1.
K-6 Review-Vermerk B5: Betreuer deprioritisierte Overleaf/PDF-Automation gegenueber wissenschaftlichen Ergebnissen;
    der PDF-Writeback (Order 288) bleibt Werkzeug fuer den Abgabeweg, nicht Vortragsstoff.
K-7 Review-Regel "Do not spend main-talk time on repository churn, credential incidents or agent workflow logs" wird
    fuer alle Vortragsvorlagen uebernommen.

## 11 Nachtrag 22.09.2026 (Order 404 + Korrekturen V-8-02/03/04 der Tiefenanalyse 353)

Owner-Order 404 (22.09.2026 13:53Z): der Deck-Dateiname traegt "-cache-awareness" statt des Betreuer-Segments; die
"Composition"-Fassungen von Deck und Speaker Guide waren die korrekte Vorlage der Ueberarbeitung. Vollzug: git mv des
Originals auf "20260919 Cache_Engine_Defense_EN-cache-awareness_Composition.pptx" (Inhalt unveraendert, md5 43f805b8);
Abschn. 1 nachgezogen. Die ueberarbeiteten Abgabe-Kopien (Suffix -396, Zug Order 353/396 mit Diff-Protokoll) liegen
ausserhalb des Repos im Abgabe-Paket; die Landung im Repo folgt nach Lens und Owner-Sicht (Order 353 (2)).
Korrekturen dieser Analyse nach der Tiefenanalyse 353 (Beweisort 20260920-order-289-praesentation/): V-8-02 acht
Klicks auf den Folien 5/6/8/9 statt zwoelf auf 4-8 (Abschn. 2, Z-3); V-8-03 zwoelf Pruefer-Fragen statt elf (Abschn. 1
und 8; die Liste in Abschn. 8 zaehlte bereits zwoelf Eintraege); V-8-04 384 gepaarte Kontexte der Folie 14 ergaenzt
(Abschn. 7). Stand der Zeilenanker: Momentaufnahme dieses Nachtrags.
