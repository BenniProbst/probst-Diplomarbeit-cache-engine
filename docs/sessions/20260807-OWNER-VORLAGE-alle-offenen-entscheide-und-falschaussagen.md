# OWNER-VORLAGE 07.08.2026: ALLE offenen Rueckfragen/Entscheide + die Falschaussagen

> Owner-Auftrag verbatim: "Bitte stelle mir ueber die letzten 3 compact alle noch
> offenen Rueckfragen und Entscheidungen, da war ein Haufen offen. Es wurden
> Falschaussagen in der Diplomarbeit behauptet, welche?"
> Quellen: Gesamt-Dossier §17.9 (Entscheid-Landkarte), Ledger-Nachtrag "07.08.
> morgen-1", Thesis-DIFF (863 Z.), Session-Log der letzten drei Kontexte.
> ORDNUNG NACH VERFALLSDATUM, nicht nach Wichtigkeit. ASCII (Paragraph erlaubt).

===============================================================================
## TEIL A -- DIE FALSCHAUSSAGEN IN DER ABGABE (das war deine Frage)
===============================================================================
Definition (DIFF-Doktrin): die Thesis ist SPEZIFIKATION, nicht Dokumentation.
Jede PRAESENS-Behauptung, die der Code nicht haelt, ist eine Falschaussage in
einer Pruefungsarbeit. Nur die 6 eingebundenen Kapitel + Anhaenge A-F zaehlen als
Zusage (die acht alten Kapitel-Dateien sind un-included). Es sind ZWEI harte
Faelle plus vier weiche Text-Posten.

### F-01 TALOS / "zwei Betriebssystem-Regime" -- HARTER FALL, ENTSCHEID OFFEN
WAS DIE ARBEIT SAGT (ADR-12 + zwei eingebundene Kapitel, DE+EN):
  "jede Messung unter zwei Betriebssystem-Regimes: einem immutablen
   Betriebssystem (Talos) [...] und einem root-Linux"
ERSTE DIAGNOSE (Thesis-DIFF, 06.08.): "0 Treffer im Code" -> Empfehlung war:
Aussage zuruecknehmen.
KORREKTUR 07.08. (nach deinem Hinweis, am Objekt nachgemessen): DIE ERSTE
DIAGNOSE WAR ZU SCHARF. Talos ist REAL -- das immutable K8s-OS der CI-/Cluster-
Schicht (Runner id15 prod-k8s-talos-runner, Control-Plane talos-prod2). FALSCH
IST NUR DER ALLQUANTOR "jede Messung ... ERHOBEN": die Erhebung laeuft
ausschliesslich unter root-Linux baremetal.
BELEG: measurements.csv 16 von 16 Zeilen platform=linux-x86_64; die Mess-Jobs
sind hart getaggt .gitlab-ci.yml:719 und :806 = [prod, baremetal, amd].
DRITTER WEG (Empfehlung): ROLLENTRENNUNG, nichts streichen --
  Talos      = immutable Bau-/CI-/Binary-/Cache-Schicht
  root-Linux = die zaehlerbasierte Erhebung
DREI im PDF wirksame Stellen (je mit EN-Pendant):
  kapitel/de/01_einleitung.tex:225-226
  kapitel/de/05_evaluation.tex:82-89
  anhang/de/E_architecture_decisions.tex:140-148 (ADR-12)
VIER Drift-Stellen (nicht \include'd, aber wortgleich -- mitziehen, sonst Drift):
  kapitel/de/01_introduction.tex:155-156
  kapitel/de/06_evaluation_methodology.tex:117-127  + die zwei EN-Pendants
NEBENBEFUND: minio.comdare.de ist durchgaengig das DEV-MinIO (.gitlab-ci.yml:55),
nicht prod -- im Text als "dev-MinIO" fuehren, um keine neue Ungenauigkeit zu
bauen.
>>> OFFEN: DEIN GO fuer den .tex-Edit (Aufwand < 1 h). Ich habe die
    Ersatzformulierungen fertig, aber ich aendere keine Abgabe-.tex ohne dein Wort.

### F-02 flat_hash_map -- HARTER FALL, GRUNDSATZ ENTSCHIEDEN, UMSETZUNG OFFEN
WAS DIE ARBEIT SAGT: in der GESETZTEN Aufgabenstellung namentlich zugesagt --
dem Text mit dem geringsten Aenderungsspielraum, weil er dem Betreuer vorlag.
IST: eine eigene SwissTable-Reimplementierung; ihr Mess-Pfad-Organ ist laut
eigenem Code-Kommentar noch offen.
DEIN ENTSCHEID (07.08. ~01:15, verbatim): "F-02: Option a" = die Zusage auf
"SwissTable-eigene Implementierung, API-kompatibel" PRAEZISIEREN.
>>> OFFEN: nur noch die UMSETZUNG (Textpass DE+EN). Kein neuer Entscheid noetig.
    (Die aeltere Empfehlung "beides -- bauen bis 21.08. + Text benennen" ist damit
    auf den Textteil reduziert; ein Abseil-Vendoring ist NICHT beauftragt.)

### VIER WEICHE TEXT-POSTEN (keine Luege, aber heute unwahr oder ungedeckt)
- B-P ANHANG-EHRLICHKEIT: die Limitierungs-Zeile "Cache-Misses L1-L3 derzeit
  0/nicht erhoben" ist HEUTE WIDERLEGT (Korpus mit pmc_available=1, L1/L3 real).
  Sie ist nicht mehr daten-gegatet und gehoert nachgezogen.
- L2/L3-URSACHE: vier Thesis-Stellen (je DE+EN) nennen NUR den Schalter als
  Ursache fuer L2/L3=0. Seit dem errno-Befund wissen wir: auf AMD existiert der
  L3-Zaehler in dieser Kodierung NICHT (errno=2 ENOENT) -- die Stellen tragen
  damit eine Halbwahrheit. (Seit dem amd_uncore-Load ist amd_l3 verfuegbar; der
  Folge-Code steht aus, s. Teil B/N-1.)
- C-1 "alle erdenklichen Binary-Permutationen": Wortlaut gegen die reale
  Deckelung -- praezisieren oder Deckelung benennen.
- C-2 std::map-VERTRAGS-LESART (06_fazit.tex:91-93): Lesart klaeren.
>>> OFFEN: alle vier als Textpass; ich schlage vor, sie MIT F-01/F-02 in EINEN
    Pass zu buendeln (ein Review, eine Landung).

===============================================================================
## TEIL B -- ALLE OFFENEN ENTSCHEIDE, nach VERFALLSFENSTER
===============================================================================

### FENSTER 0 -- "VOR DER ERSTEN .fingerprint-DATEI" (heute 0 h, danach 34,4 h
### Neubau PLUS Entwertung aller bis dahin erhobenen Messdaten; Sidecar-Bestand
### aktuell gemessen = 0, das Fenster steht also noch offen)
- **R-3 Mess-Defines im Fingerprint-Preimage.** COMDARE_MEASUREMENT_ON ist
  ABI-wirksam (schaltet die IObservableTier-Vererbung), steht aber NICHT im
  Preimage (am Objekt: 0 Treffer in beiden Preimage-Dateien; measurement_tooling
  steht nur in der lesbaren Stempel-Zeile). FOLGE: die geplante Release-
  Nachmessung wuerde still die MESS-Binary wiederverwenden (dll_is_current ist
  EIN Fingerprint-Vergleich) = stiller Falsch-Skip.
  >>> ENTSCHEID: Mess-Feld ins Toolchain-Glied aufnehmen? (Empfehlung: JA, jetzt --
      der M-1-Befund zeigte, dass das FORMAT dabei unveraendert bleiben kann.)
- **D-1 PMU-Domaene in der Mess-Identitaet?** Auf Hybrid-CPUs liefern zwei Kerne
  derselben Maschine verschiedene Zaehler -- "selbe Maschine" ist als Schluessel
  nicht mehr fein genug (kollidiert sonst mit deinem Reproduzierbarkeits-KERN).
  >>> Empfehlung: JA, als Feld der MESS-Achse, NIE als Preimage-Glied.
- **B-4 Break-Even-Tabelle als Lager-Objekt** mit eigenem Schluessel?

### FENSTER T1 -- VOR DEM ERSTEN 4096er-BATCH (blockiert die Messung)
- **D-2 BAU-MENGE (Faktor 16, der groesste offene Posten).** Vier Kandidaten:
  131.072 (Basis je System-Perm, compile-verankert) / **524.288** (4 System-Perms,
  realer Ist-Umfang, Akten-Empfehlung) / 1.572.864 (12 Perms, Doktrin V7.4) /
  2.097.152 (line_size-Faktor 4). `run_options cap` bestimmt sie NICHT (im
  golden-Zweig gar nicht geparst, im thesis-Zweig ein No-op min(131072,131072)).
  >>> ENTSCHEID noetig; naechster Schritt waere "Binaries zaehlen statt addieren"
      (2-3 h). Ohne die Zahl ist weder Wanduhr noch Plattenplatz seriös planbar.
- **D-3 MESS-TEILMENGE.** 216 Mess-Faecher x 524.288 Binaries ~ 71,7 Tage auf
  2 Lanes gegen 39 Tage Restfrist. >>> Empfehlung Weg C: 320er-Auswahl mit vollem
  Faecher (~2,1 h) + Vollmenge mit flachem Faecher (~3 Tage) = die einzige
  15.09.-haltende Variante.
- **D-4 allow_failure am Voll-Mess-Batch** (Preflight in einen eigenen harten Job;
  heute stirbt die Lane bei mehrtaegiger Messung still).
- **D-5 PMC fail-closed via kPmcExpected** (SKIP -> FAIL).
- **D-7 CORE-ACHSEN-FAKTORISIERUNG (nicht deckungsgleich!).** Betreuer-Plan
  Termin 3: {P|E} x {Single|All} + homogene Referenz (seit 09.04. pruefer-bindend).
  Achsen-Dossier/Code: {Unpinned | PCoresOnly | ECoresOnly | HybridAware}
  (im Code enum HeteroCoreDispatch, aber im Mess-Pfad nur None instanziiert;
  Namens-Diskrepanz: Code sagt None, CSV/Dossier sagt Unpinned).
  >>> ENTSCHEID: traegt pe_policy die 5-Modus-Thesis-Achse, oder wird der
      Thesis-Text auf das 4-Werte-Modell umgeschrieben? (Empfehlung: das Dossier-
      Modell, weil "Unpinned" wegen deines WARN-KERNs unverzichtbar ist.)
      Dazu O-C: Default Unpinned vs. Pflicht-Pinning.
- **R-2 XML-TRENNUNG Bau/Messung** ("sonst regression", dein Wort): die Mess-Seite
  faehrt heute das VOLLE Fenster in EINEM Treiber-Aufruf je Perm -- die
  4096er-Vorgabe gilt woertlich fuer "compile UND Messung", die Mess-Seite
  erfuellt sie NICHT (kein Wiederaufnahme-Korn; jeder Abbruch verloere Wochen).
  >>> Bau-Auftrag, sobald D-2/D-3 stehen.

### FREITAG 1 (heute, 07.08.)
- **A-1 = F-01 Talos** (s. Teil A) -- GO fuer den .tex-Edit.
- **A-2 = F-02 flat_hash_map** -- entschieden (Option a), Umsetzung offen.
- **C-1 / C-2** (s. Teil A, weiche Posten).
- **C-8 Schnitt-Termin 28.08. bestaetigen** (letzte Bau-Woche).
- **T-1 Was ist "die Abgabe morgen"?** Du benutzt den Ausdruck neben der
  15.09.-Frist. Zwischenabgabe 07./08.08.? Diese Frage bestimmt, ob die
  Auswertungs-/Hybrid-Kette T3 (vor 15.09.) oder T4 (danach) ist -- die einzige
  echte Reihenfolge-Unklarheit im Arbeitsplan.
- **T-6 termine/INDEX.md nachziehen** (Stand 15.05., listet T9-T11 nicht -- ein
  mechanischer Luecken-Erzeuger: wer ihm folgt, liest die juengsten Termine nie).
- **B-5a / O-4 ANHANG-A-REICHWEITE.** Anhang A deklariert je Sprache 44
  Fragmente: 16 mit echten Messdaten belegt, 28 leer (ueber \InputIfFileExists
  gegatet, im PDF unsichtbar). >>> Empfehlung Weg 1: bei 16/44 bleiben + eine
  Luecken-Zeile in le_limitierung.tex (DE+EN). KEINE Freigabe von dir; die
  "nach-Abgabe"-Praemisse ist durch den 15.09.-Termin widerlegt.

### BIS 21.08.
- **C-4 H2-Abbruchkriterium** (die Durchsatz-Spalte existiert nicht -- ohne sie
  ist H2 nicht beantwortbar).
- **C-5 vier fehlende Lastprofile** LP02/03/07/13.
- **T-3 Hybrid-Lane: eigene Maschine oder Gate?** ("Schweigen ist keine der
  erlaubten Optionen" -- ohne Entscheid faellt die getrennte P/E-Messung aus.)
- **W-3 Akzeptanzkriterium Ebene 2**: Zeitpaar vs. Checkpoints (dein KERN 11 setzt
  das strengere, KERN 12 das mildere Kriterium -- das ist ein echter Konflikt
  zwischen zwei deiner eigenen Saetze).

### 28.08. (SCHNITT)
- **C-6 PRT-ART ChainRef bauen** (traegt H3) + Prefetch textlich zuruecknehmen;
  ohne das faellt H3.

### T4 / PROZESS (nach 15.09. bzw. laufend)
- **B-2 Auswertungs-Rueckfragen, Stand: VIER von sechs sind beantwortet**
  (F1 jeder Achsenaufruf in der Tier-Binary · F3 Break-Even PRO Ebene ·
  F5 CT-Chain-of-Responsibility im hybrid_router · F6 mehrere Optima je Last-Kanal).
  >>> WIRKLICH OFFEN: **F4** "Orchestration ueber das Lager" -- umfasst sie nur
      Auswahl+Vergleich, oder auch das RUECKSCHREIBEN der gewaehlten Binary in den
      Hybrid? (Substanz: heute DEFERRED #156.) Plus je EIN Restentscheid bei
      **F2** (wandert der Messpunkt physisch ans Pruefdock, oder testiert das Dock
      ihn nur?) und **F5** (endgueltig CT-Einbau vs. RT-Dock-Tausch).
- **T-5 Wiederholungen**: bei 3 bleiben? (real gefahren war 1).
- **T-7 Kanonik der drei Synthese-Stacks** (heuristik/ als kanonisch, VOR dem
  Aufraeumpass).
- **T-8 "beste Binary"**: Sieger oder Pareto-Front?
- **T-9 Min/Max-Semantik je Achse** -- ohne sie ist der Kurvenvergleich fuer
  Max-Achsen systematisch falsch herum. Deep Research frueh starten.
- **T-10 Last-Erkennungsheuristik**: der EINZIGE Posten der ganzen Kette ohne
  Boden (0 Code, 0 Design, 0 Register) -- blockt den Hybrid-Bau.
- **D-6 branch_misses**: deklarieren statt verdrahten?
- **SW-5 / E-14 active_telemetry_is_silent() gibt konstant false zurueck**,
  obwohl >=10 Profile silent="true" deklarieren. Das Wiring ist bewusst
  golden-BRECHEND -> nur im GOLDEN-UPDATE-Fenster heilen, nie einzeln.
- **A10 HW-Erkennung P4-P6**: fuenfmal "Pflicht vor Trigger" genannt, nie gebucht,
  nicht gebaut.
- **A11 ccache-Allowlist-Widerspruch** · **A12/E-14 NAS-Creds** (0 Treffer in
  Ledger+Register) · **D-9 Backup-Ref-Bundle nach Abgabe** · **Trigger-Kopplung
  branch:main** (Empfehlung: an den Submodul-Gitlink binden).

===============================================================================
## TEIL C -- WAS BEREITS ENTSCHIEDEN IST (damit nichts doppelt gefragt wird)
===============================================================================
- FRIST: Endtermin 15.09.2026, Lieferung JEDEN Freitag (dein Wort 06.08.) --
  KEINE Rueckfrage noetig, das Dossier fuehrt es als KERN.
- F-02 = Option a (praezisieren).
- F-01-Sachlage geklaert (Rollentrennung); offen ist nur das .tex-GO.
- F7 Plan-Ablage = "Option b" im GRUNDSATZ (gesondertes Versionierungs-Interface);
  offen bleiben Termin/Ablageort/Env-vs-XML und der ungebaute super-Host-Binder.
- E-18-Zielbranch = development. F6 Mess-Tooling-Achse BLEIBT.
- Mess-Freigabe ERTEILT, greift aber erst nach den sechs Auflagen (die stehen
  oben als Fenster 0 + T1).

===============================================================================
## TEIL D -- MEIN VORSCHLAG ZUR REIHENFOLGE
===============================================================================
1. **Heute entscheidbar und billig:** F-01-GO + F-02-Umsetzung + die vier weichen
   Textposten in EINEM Textpass (DE+EN, ein Review, eine Landung, < 1 Tag).
2. **Fenster 0 zuerst, weil es sich SCHLIESST:** R-3 + D-1. Solange 0
   .fingerprint-Sidecars existieren, kostet die Aenderung nichts; nach dem ersten
   Batch kostet dieselbe Aenderung 34,4 h Neubau plus alle Messdaten.
3. **Dann T1:** D-2 (Bau-Menge zaehlen) -> D-3 (Mess-Teilmenge) -> D-4/D-5 ->
   R-2 (XML-Trennung + Mess-Slicing).
4. **Dann der erste 4096er-Batch** + die 320er-Folgemessung.
Alles andere ist terminiert und blockiert nichts.
