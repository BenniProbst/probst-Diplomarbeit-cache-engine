# EXPLORE-ERGEBNIS 07.08.2026: die "offenen Fragen" sind ueberwiegend GEPLANT

> Owner-Auftrag: "Bitte starte bezueglich der Fragen an mich umfassende Explore Agenten nach
> Claude Code Arbeitsweise" + Diagnose "Gedaechtnisluecke".
> Verfahren: 7 Explore-Agenten (Sonnet-5, max effort, very thorough) ueber Thesis/Ledger/
> Plaene/Termine/Memory/Code. Workflow wf_f4ebffd6-fff (7/7 durch).
> ERGEBNIS: Die Owner-Diagnose war RICHTIG. Von 26 geprueften Fragen sind 12
> GEPLANT_UND_BEANTWORTET, 13 TEILWEISE_GEPLANT, nur 1 ECHT_OFFEN.
> ASCII (Paragraph erlaubt). Rohdaten: ~/backups-workflow/20260807-workflow-ergebnisse-gerettet/

===============================================================================
## A. DREI BEFUNDE, DIE KEINE OWNER-FRAGE SIND, SONDERN BAU-RUECKSTAND
===============================================================================
Das ist der wertvollste Teil: drei Posten, die ich als "offene Entscheidung" gefuehrt habe,
sind in Wahrheit ENTSCHIEDEN -- der Code hinkt nur hinterher. Sie brauchen KEINE Rueckfrage,
sondern Arbeit.

### A-1  T-8 "beste Binary" = PARETO-FRONT (entschieden 10.07.2026)
Der Owner hat am 10.07. SIEBEN Fork-Entscheidungen auf einmal getroffen; eine davon ist
"Pareto-Front, nicht Einzelsieger". Das Plandokument sagt es explizit.
IST: rank_binaries im best_binary_selector implementiert de facto einen EINZELSIEGER je Metrik.
=> BAU-RUECKSTAND gegen einen bereits getroffenen Entscheid, KEINE offene Planungsfrage.

### A-2  T-9 MIN/MAX-SEMANTIK je Achse -- der Katalog EXISTIERT (04.08.2026)
Ein vollstaendiger, je Achse ausformulierter Min/Max-Katalog liegt vor (T0..T17+), gestuetzt auf
einen eigenen Deep-Research-BEFUND vom 09.07. und die Doktrin "Min/Max erforschen, nie erfinden";
multi-objektive Achsen (T5/T6/T18) sind als Pareto- statt Einzelextremum gesondert behandelt.
IST: der Katalog wird von heuristik/break_even.hpp NICHT konsumiert -- dort gilt pauschal
"kleinerer y-Wert = besser".
=> KONSEQUENZ, die in die Prioritaet gehoert: solange der Katalog nicht eingespeist ist, ist der
   Kurvenvergleich fuer JEDE Max-Achse systematisch FALSCH HERUM. Das ist keine Kosmetik,
   sondern eine Auswertungs-Korrektheitsfrage vor der Break-Even-Rechnung.

### A-3  T-10 LAST-ERKENNUNGSHEURISTIK -- der Plan existiert seit 09.07.2026
Frueherer Befund (zweimal unabhaengig erhoben): "0 Code, 0 Design, 0 Register -- der einzige
Posten der Kette ohne Boden". DAS WAR FALSCH. Es existiert ein 327-zeiliger, committeter,
literaturgestuetzter Deep-Research-BEFUND (OtterTune SIGMOD 2017, QueryBot 5000 SIGMOD 2018,
Self-Driving-DBMS CIDR 2017) mit: Merkmalsvektor, Clusterverfahren (offline hierarchisch +
k-Means, online modifiziertes DBSCAN), Cluster-Anzahl-Methodik und -- Abschnitt 5 -- der
Laufzeit-Zuordnung ankommender Last zum naechsten Cluster inkl. sicherem Default-Fallback.
URSACHE DES UEBERSEHENS (exemplarisch fuer die ganze Klasse): die Suchbegriffe der beiden
juengsten Untersuchungen ("Last-Erkennung", "Erkennungsheuristik") treffen die Terminologie des
BEFUNDS nicht -- der arbeitet durchgehend mit "Workload-Cluster".
=> LEHRE: eine Negativ-Suche ist nur so gut wie ihr VOKABULAR. Kuenftig bei jedem "0 Treffer"
   mindestens EINEN Synonym-Durchgang fahren, bevor "existiert nicht" behauptet wird.

===============================================================================
## B. WAS GEPLANT UND BEANTWORTET IST (keine Rueckfrage noetig)
===============================================================================
- WINDOWS: vier Windows-VMs existieren als eigene GitLab-Runner -- prod1 id53 (Win2022) + id55
  (Win11), prod2 id54 (Win2022) + id19 (Win11). Zugang = VM (12 vCPU/12 G je), NICHT Dual-Boot.
  Nur id19 ist online; id53/54/55 registriert aber nie verbunden (offen: Auth-Token-Reset +
  Vault-Windows-Creds + In-VM-Runner-Install). Die Thesis-OS-Achse fuehrt Win11 + WinServer 2022
  ausdruecklich als "reale Flotte". In der cache-engine-CI: 0 Windows-Jobs.
- SWISSTABLE-EINORDNUNG: SwissTable liegt unter Genus SearchAlgorithm, und der gehoert per
  gattung_of() zur Gattung MAP -- nicht Container. Die Aufgabenstellung selbst sagt "als
  Gegenprobe INNERHALB DERSELBEN Gattung", also genau dort, wo die Baum-Baselines sitzen.
  Die Owner-Begruendung (Achsen-Steuerbarkeit) traegt vollstaendig: sie heisst im Plan
  SUBSTITUTIONS-PRINZIP + vendor->faithful->self-Doktrin, mit SwissTable als Praezedenzfall;
  am Objekt durchgesetzt (SwissTable alloziert zwingend ueber axis_06, kein abseil-Wrap).
- T-5 WIEDERHOLUNGEN: 3 (Owner-Entscheid E3 vom 16.07., ersetzt die 5 aus T3/T4/T6). Alle
  produktiven Profile tragen count="3". Real gefahren wurde bisher 1.
- T-1 TERMINE: 15.09.2026 ist der bindende Endtermin mit Freitags-Kadenz; der 08.08. ist NICHT
  die Abgabe, sondern die erste Wochen-Lieferung. Die alte Achse "Trigger 07.08./Abgabe 08.08."
  ist ausdruecklich ueberholt.
- D-7 CORE-FAKTORISIERUNG: es gilt das Achsen-Dossier-Modell {Unpinned | PCoresOnly | ECoresOnly
  | HybridAware} -- begruendet ueber die am 06.08. beschlossene Quellen-Rangfolge (docs/plaene
  Rang 2 vor docs/termine Rang 3), nicht ueber blosses "neuer".
- P/E-TRENNUNG als PFLICHT: dreifach dokumentiert -- T3-Methodikregel + Risiko/Gegenmassnahme
  (09.04.), Konsolidierungs-Dossier, und als veroeffentlichte Zusage ueber die Hauptdatei.
  Baustein HybridCorePinning ist im Domaenenmodell (T7, 08.05.) vollstaendig signiert:
  pin_thread(thread_id, core_class:{Performance|Efficient}) + measure_per_class() ->
  {p_core: Counters, e_core: Counters}.
- C-4 H2: woertlich in der gebundenen Thesis definiert; braucht zwingend die Durchsatz-Spalte,
  die im kanonischen Mess-Record fehlt (Thesis gesteht es selbst ein).
- C-5 LASTPROFILE: alle 14 inkl. LP02/03/07/13 sind mit Op-Mix definiert; es fehlt nur die
  Materialisierung als XML (10 von 14 lp_id im Code). Aufwand ~0,5-1 Tag.
- C-6 ChainRef: geplant bis Fr 4 (28.08.), Prefetch wird textlich zurueckgenommen statt gebaut.
- F5 CT/RT: die Aufteilung ist owner-entschieden und eingefroren (E1, 02.08.) -- die SCHALTLOGIK
  ist CT-Chain-of-Responsibility, der Binary-TAUSCH am Dock ist RT (dlopen/dlclose ueber
  HybridBinaryProxy). Kein Widerspruch: CT entscheidet WANN, RT fuehrt AUS.

===============================================================================
## C. WAS WIRKLICH OFFEN BLEIBT (Owner-Entscheid noetig)
===============================================================================
FENSTER 0 (vor der ersten .fingerprint-Datei -- heute 0 h, danach 34,4 h + alle Messdaten):
- D-1 PMU-Domaene in die MESS-Identitaet (NICHT in den Fingerprint): vorgeschlagenes Tupel
  (binary_fingerprint, Maschine, pe_policy, pmu_domain, Mess-Setting). Empfehlung liegt fertig,
  Ratifizierung fehlt.
- B-4 Break-Even-Tabelle als Lager-Objekt mit eigenem Schluessel. Empfehlung JA ("sonst hat das
  Ergebnis keine Identitaet"). Als einzige der sechs Planungs-Rueckfragen fensterkritisch.
- R-3 Mess-Defines ins Preimage: DESIGN LIEGT VOR (Fable, 07.08.), Verdikt format_bump_noetig=
  TRUE mit Begruendung (M-1 bewegte kein Preimage-Byte, R-3 MUSS eines bewegen; kein bestehendes
  Glied kann das Feld tragen -> neuntes Glied -> Format 4).
T1 (vor dem ersten 4096er-Batch):
- D-2 BAU-MENGE: Empfehlung 524.288 (4 System-Perms x 2^17), doppelt hergeleitet, cap
  nachweislich wirkungslos. Ratifizierung fehlt.
- D-3 MESS-TEILMENGE "Weg C": 216er-Kartesik auf dem 320er-Katalog (~2,1 h) + flacher 9er-Sweep
  ueber alle 524.288 (~3,0 d) = ~3,1 Tage gegen 71,7 Tage Vollmessung bei ~39 Resttagen.
- O-C Default Unpinned vs Pflicht-Pinning: Vorschlag = Pflicht-Pinning NUR auf der Hybrid-
  Maschine prod2, Unpinned-Default auf uniformen Maschinen. Der Plan-Autor sagt woertlich, dass
  er diese Entscheidung nicht selbst trifft.
SPAETER:
- W-3 Akzeptanzkriterium Ebene 2: ZWEI Owner-Aussagen, 6 Minuten 53 Sekunden auseinander,
  unterschiedlich streng (KERN 11 Checkpoints = strenger, KERN 12 Zeitpaar = milder). Eine reine
  "juenger schlaegt aelter"-Anwendung auf 7 Minuten Abstand waere Extrapolation -- gehoert
  entschieden, nicht abgeleitet.
- B-5 Break-Even-Schwellenwerte: CT-Konstanten oder RT aus dem Lager? (bis nach der Abgabe offen)
- O-4 ANHANG-A-REICHWEITE: hier steht ein WIDERSPRUCH ZWISCHEN ZWEI GLEICH DATIERTEN
  Plandokumenten (06.08.) -- das eine empfiehlt Weg 1 (bei 16/44 bleiben + Luecken-Zeile), das
  andere behauptet, ein "Scope 4"-Lauf habe alle 28 Positionen bedient. Am eingecheckten
  Thesis-Objekt sind die 28 weiterhin ueber \InputIfFileExists gegatet -- der Scope-4-Claim ist
  im Repo NICHT nachvollziehbar. Vor dem Entscheid ist zu klaeren, welches Dokument stimmt.

===============================================================================
## D. DIE EINE ECHT OFFENE FRAGE (neue Owner-Festlegung noetig)
===============================================================================
DEBUG-MODE-MESSUNG ALS "OS-SUPPORT-BUILD": Der Owner hat am 07.08. festgelegt, dass auf
Nicht-baremetal-Plattformen (Docker-Distro-Matrix, macOS, RISC-V, Pi5) im DEBUG-Modus gemessen
wird, "weil wir nicht bare metal laufen und die Ergebnisse formal ungenau sein werden ->
OS support builds". KEIN Dokument im geprueften Korpus definiert bisher die Unterscheidung
"Unterstuetzungs-Nachweis" vs "valide Messung", und keines legt eine CSV-Spalte oder
Anhang-Kennzeichnung dafuer fest.
=> RISIKO: ohne Kennzeichnung sehen formal ungenaue Debug-Werte in den Daten aus wie echte.
=> LAUFENDER EXPLORE (wf_0167179d-686) prueft, ob die MODI-Doktrin ("die Modi, in denen die
   cache engine ausgefuehrt werden kann, sind XML-Pflicht") die Antwort bereits traegt --
   Owner-Diagnose: auch das ist eine Gedaechtnisluecke.

===============================================================================
## E. METHODEN-LEHRE AUS DIESEM LAUF
===============================================================================
1. Eine Negativ-Suche ist nur so gut wie ihr VOKABULAR (T-10: "Last-Erkennung" fand nichts,
   "Workload-Cluster" haette den 327-Zeilen-Plan gefunden). Jede "existiert nicht"-Aussage
   braucht kuenftig einen Synonym-Durchgang.
2. "Offene Frage" und "Bau-Rueckstand" sind verschiedene Dinge. Drei Posten (T-8, T-9, T-10)
   standen faelschlich in der Owner-Vorlage -- sie kosten Arbeit, nicht Entscheidung.
3. Zwei gleich datierte Plandokumente koennen sich ueber den IST-Stand widersprechen (O-4).
   Der eingecheckte Code/Text entscheidet, nicht das Dokument.
