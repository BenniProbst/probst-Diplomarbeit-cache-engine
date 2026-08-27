# DESIGNPLAN TDD -- LEBENDE DICHTE FASSUNG (26.08.2026)

Dies ist die LEBENDE DICHTE FASSUNG dieses Referenzdokuments (Owner-Order 26.08.2026, KON130). Sie traegt
die GESAMTE geltende Substanz des Originals plus alle Nachtraege; ueberholte Zwischenstaende stehen nur als
datierte Historie-Verweise. Bei Widerspruch: Owner-Wort schlaegt alles, Neueres schlaegt Aelteres.
STAND-KOPF: Original 08.08.2026 (docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md, 1021 Z.,
Marker-Kette par.9 -> 10 -> 11 -> 12 -> 13.1-13.5) + Nachtraege bis KON129 (Ledger 25.08.) + Owner-Tranche
26.08. (memory/project_owner_kerne_20260825_a1_a6_b1_b10_scope_split_public.md, verbatim) + 3-Kontexte-
Verbuchung 26.08. (Beweisort ~/backups-workflow/20260826-konsolidierung-dichte-fassungen/). Objekt-Anker:
super 54b25e2f / ce-Gitlink d3b5a393 (26.08.).
PFLEGE-REGEL: Aenderungen additiv AM ORT mit Datum; hinten-Anfuegen verboten; Stand-Kopf-Bump je
Konsolidierung; das Original bleibt unveraendert als Beleg-Archiv liegen (Doku nie loeschen); jeder
Abschnitt traegt seine Quell-Anker (par./KON/Symbol).
BELEG-ARCHIV: docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md (1021 Z., alle Marker-/
Nachzugs-Ketten und der par.9-Berichtigungs-Apparat am Ort). Historie, Anlassfaelle, Beleg-Zahlen und
Marker-Wortlaute leben NUR dort; diese Fassung verweist praezise.
Status-/Zahlen-Felder sind datierte Momentaufnahmen (V11): vor Verwendung am Objekt neu messen; Quelle-
zitierte Staende sind als solche markiert (V1).
ROLLE: Haupt-Referenzdokument der Testseite (KON19-00); ergaenzt den Wellenplan-Verifikationsvertrag um die
Testseite, ersetzt nichts. NOTATION: Posten-IDs MT=Messkette-Treiber, ST=Statistik-Glied, PK=Perzentil-
Kanon, PE=Planer-Emission, LG=Lagerhaltung, AS=Achsen-Stempel, PM=PMC-Messfuehler, AG=Anatomie-Gattung,
XL=xlsx-Ausgabe, HY=Hybrid; je Posten [Band Welle h]; Band A = landet im Fenster, B = nur bei freiem Slot,
C = Herkunftsklasse "W7" -- GELTEND seit par.21.3: Band C = W2/W4 fahrbar, W7 ist KEIN Endlager.
META-REGEL 26.08. (T26-9): vor JEDER Testseiten-Rueckfrage an den Owner 12W-Absicherungs-Explore.

## D1 PRUEFNORM (par.1, woertlich-kern)

Ein Test zaehlt nur, wenn drei Dinge benannt sind -- welche AUSSAGE er sichert, welcher EINGANG sie faellen
wuerde, und WOHER SEIN NENNER stammt (nicht aus dem Pruefling). Abdeckung misst Beruehrung; wir messen
BEISSFAEHIGKEIT, und zwar mit gefahrenem Biss (K13: der Koeder muss erst beissen). Tests sind Gegenstand
der Kritik, nicht nur ihr Werkzeug: jede Welle nimmt ihre eigene Testseite in die Objektpruefung.
Herkunft: 3 der 5 Defekt-Familien des 08.08. waren der Test selbst (Welch t=0/p=1 zementiert, win_rate=0.0
zementiert, Abdeckungs-Wache gruen gegen den korrekten Baum). B-1-Zahl heute: 45 Stellen / 24 Dateien @
Gitlink d3b5a393 (Archiv par.9.1: die 47 war mit keiner Zaehlweise reproduzierbar; 29/17 = Stand 08.08.).
Methoden-Zahlen (par.0, Aussage der Meta-Stufe, nicht nachgezaehlt): 157 Behauptungen -> 117 bestaetigt
(386 h), 40 gefallen (~ein Viertel; davon 13 Fehler der ersten Schaerfungsstufe), 62 Funde erst durch die
Meta-Stufe. "Prosa wird nicht rot" -- deshalb sind die Zahlen bewacht (D9).

## D2 DIE TESTKLASSEN + DER 117er-KATALOG (par.2, Postenlisten WOERTLICH = Verify-Nenner)

Nenner: 117 Posten = 29+25+23+16+10+9+3 in sieben Klassen + 2 Einzelfaelle.
K1 keine-negativprobe (29): Zusicherung ohne Eingang, bei dem sie faellt.
   MT-L7 Nullcontainer [A W2 3] * MT-L8 Legacy-Mikrobench [C W7* 0] * MT-L11 Vendor-Injektion [B W4 2] *
   ST-Diskrepanz Welch/MWU [A W1* 2] * ST-Winsor NaN [A W0b 1.5] * ST-DriftBestwahl [B W1 1] *
   ST-BreakEvenKreuz [B W2 3] * PK-Kreuztest 6/8 Stellen [A W1 6] * PK-NullMedian [B W2 2] *
   PE-Rules on_success [A W0b 1.5] * PE-WarnPfade 10/14 [B W2 2] * LG-Lazy 0/2->2/2 [B W0b 2] *
   LG-LoadWache beide Genera [A W1 4] * LG-Kollision je Backend [B W0b 3] * LG-NoThrow-Inhalt [B W0b 2] *
   LG-CommitAtom [B W1 3] * AS-GenusLaut [B W2 3] * AS-Aritaet requires [B W1 2] * AS-NameClean [B W1 1.5]
   * PM-NichtGelesen [A W2*(Seam)/C(HW) 4] * AG-Sentinel46 [B W2* 3] * AG-Concepts11 [B W1 8] *
   AG-LayoutPin [B W2 3] * XL-L6 Dangling-Link [B W2 2] * XL-L8 ZahlText [B W2 3] * XL-L9 Abbruch/tmp
   [B W2 3] * HY-Reroute-Vertrag [A W1* 12] * HY-Ausgaenge [A W4 10] * HY-HonestEmpty [A W4 8]
K2 anwesenheit-statt-bedingung (25): geprueft wird, dass etwas DA ist, nicht dass es GILT.
   MT-L1 Exit0-ohne-Messwert [A W2* 3] * MT-L9 T17-Gleichheit [B W1 2] * MT-L10 TikZ [B W4 2] *
   ST-CLITestat statt Regex [A W1* 3] * ST-RankingTie [B W1 3] * PK-DeleteP99-Wache [A W1* 3] *
   PE-BauTestat else [A W0b* 2] * PE-PruefXOR [A W0b* 1] * PE-PMCPreflight-Kette [A W0b 1] *
   LG-SkipCallback==0 [A W1 6] * LG-NAZelle [B W0b 3] * LG-DepthFirst-Protokoll [B W0b 2] *
   LG-WritebackXlsx [A W1 3] * AS-KatalogTab 19 [B W1 2] * AS-ORG18 DOM+CRC64 [B W1 2] * AS-OsPin
   [A W0b 0.5] * PM-m3v2Spalten [B W1 2] * PM-WinPCM [C W7* 3] * AG-C1C4 6 Orakel [B W0b 3] *
   AG-IsComposition [B W1 4] * XL-L2 Token zellgenau [A W1 4] * XL-L3 INFO lesen [B W1 3] *
   XL-L5 Hyperlink-Menge [B W1 4] * HY-Label-Gate [A W0a 3] * HY-Kurvenlage [A W4 8]
K3 kein-nenner (23): Zahl ohne Grundgesamtheit; Heilform Nenner aus fremder Quelle, ASSERT vor der Schleife.
   MT-L2 ns_per_op-Token [A W2* 5] * MT-L6 Stichprobe beide Writer [A W2 3] * MT-L12 Golden-320-Menge
   [B W4 2] * MT-QFlag Unbestimmt [B W2 2] * ST-MultiCompare bestimmbar [A W1* 3] * ST-Export Robust-Felder
   [A W1* 2] * ST-Perzentile optional [A W0b 2.5] * ST-HeurIdentisch [B W2 2] * PK-SuperFixture n=4
   [B W2 4] * PK-KlemmJson n-Spalten [A W1 4] * PK-P999 Produzent [B W2 4] * PE-JobBindung [B W1 2] *
   LG-Idempotenz 2x3 [A W1 4] * LG-Rueckschrieb7 [B W1 1] * AS-OrganOrdnung 18/18 [B W1 4] * AS-DupReject
   [B W1 2] * PM-m3v2Zero 8/8 [A W2* 1] * PM-RAPL 4 Eingaenge [A W2* 2] * AG-GenusCount [B W4 5] *
   XL-L11 Mapping-Funktion [A W0b 3] * HY-Ebene4 Label+Datensatz [A W1*(a)/W4(b) 12] *
   HY-Gleichstand+Beruehrpunkt [A W0b 7] * HY-DokuAnker [B W0a 5]
K4 unerreichbarer-block (16, inkl. test-unsichtbar-durch-registrierung): der Test laeuft nie;
   Registrierung IST Teil des Tests (T-7).
   MT-L4 vier Unregistrierte+Wache [A W0a 3] * MT-L5 V32-Flag+CI-Job [A W0b 4] * ST-CTestWache 0/429
   [A W-1 3] * PK-F15Frei aus if-Block [A W0b 1] * LG-HostBinder 3 Felder [A W1 5] * LG-Zeilenlimit
   Verwendungsstelle [B W0b 3] * AS-Bewaffnung Roundtrips==3 [A W0a 3] * PM-Outcome Teil 1/2 [B W1 4] *
   PM-OffZwilling [B W0b 1.5] * PM-CTZweig 2 TUs [B W1 2] * AG-Noexcept-Haertung [B W1 6] *
   AG-DllRoundtrip [B W2 4] * XL-L7 Limit-Aufruf [B W2 5] * XL-L10 Praefix/S00N [B W2 3] *
   XL-L12 Idempotenz/Degradation [B W2 3] * XL-SheetZaehler gemischt [B W2 3]
K5 test-zementiert-defekt (10, inkl. selbstreferenzielles-orakel): Fix muss den Alt-Test im selben Commit
   umschreiben.
   MT-L3 Schema-Orakel 47/47 [B-1] [A W1 5] * ST-Welch bestimmbar [A W1* 2] * ST-MWU n=1 [A W0b 2] *
   PK-KanonWert [A W1 4] * PK-DriftGrenz absolut [B W2 2] * LG-XlsxAlt nie vernichten [A W1 4] *
   LG-CsvAlt Schwester [A W0b 2] * PM-Kreuz16 Offen-Liste [B W2 2] * PM-Scaled beobachtbar [A W2* 2] *
   AG-PunktFixes [C W7* 2]
K6 kein-test / code-ohne-test (9): tragender Produktionscode ohne einen Testtreffer.
   PE-AllowFailure [A W0b 1] * PE-Startgate-Vertrag [B W1 2.5] * PM-PAPI [C W7* 3] * PM-Naht
   perm_runner->CSV [A W1 2] * PM-Errno Voll-Sweep [B W1 1] * PM-AmdL3 (Teil 0 sofort) [C W7* 3] *
   PK-QFlagWache Erstwache [B W2 5] * AS-LegacyPin [B W0b 2] * HY-ModulGrenze 4 Symbole [A W1* 8]
K7 produktionsweg-ungetestet (3): gebaut, aber unverdrahtet oder asymmetrisch.
   XL-L1 Facade zweistufig [A W0b(A-Stufe)/W1(B-Stufe) 10] * LG-E2Exlsx Facade [A W1 6] *
   XL-CsvDtor-Leck [B W2 2]
Einzelfaelle (2): PK-WinsorWert (absturzfreiheit-statt-aussage) [B W2 2] * XL-L4 n/a-Konkurrenz
   (kennzahl-ohne-nicht-bestimmbar) [A W1 3].
D-5-STAND (K7-Zeile "xlsx null Aufrufer"): 0 von 11 thesis_profiles xlsx-blind (R1 15.08., ce 04f76b65;
Historie 8/9 -> Archiv par.2-Marker); OFFEN: T-3-Klasse-Posten mit Profil-Nenner (Wache-Luecke) + X2
CSV-Factory-Semantik (XML-abhaengig; Design-Eingang B0-B10 -> #18, Fenster 04.-11.09.).

## D3 DER TDD-VERTRAG (par.3 woertlich-kern + Nachtrags-Klassen mit Status)

Gilt fuer jedes Paket aller Wellen; ergaenzt V-1..V-7 des Wellenplans. Deckungsfrage: "was erzwingt das
Halten?" -- zulaessig nur ein Werkzeug oder eine benannt ungedeckte Stelle.
T-1 ROT ZUERST: Test am ersten Tag rot ODER Biss per protokollierter Wegwerf-Mutation bewiesen; ein Test,
    der am gesunden Objekt nie gruen wird, ist ebenso unzulaessig (Daueralarm).
T-2 AUSSAGE, NICHT ANWESENHEIT: find(), Existenz, Exit 0, "wirft nicht" sind keine Zusicherungen --
    Wert, Position, Menge, Klasse.
T-3 NENNER, FREMD: Grundgesamtheit aus anderer Quelle als dem Pruefling; ASSERT auf die Zahl VOR der
    Schleife.
T-4 GEGENEINGANG: zu jeder Zusicherung ein Eingang, bei dem sie nicht gilt; Randfall nur auf
    Absturzfreiheit ist keiner.
T-5 ORAKEL UNABHAENGIG: Sollwerte im Test gerechnet oder eingefroren -- nie aus der geprueften Funktion,
    nie aus Kritik-Material abgeschrieben.
T-6 SCHWESTERPFLICHT: jeder Fix/Test sucht im selben Zug die Schwesterstelle (beide Writer, beide Genera,
    beide Backends, beide Break-Even-Engines, beide Serialisierer).
T-7 REGISTRIERUNG IST TEIL DES TESTS: existiert erst, wenn er in ctest -N erscheint und sein Binary im
    Bauweg haengt; Registrierungs-Bissprobe gehoert zur Abnahme.
T-8 ATOMARE LANDUNG: Tag-1-Rot im Feature-Branch; auf development landen Test + Minimalbau atomar
    (Hart-Gruen-Doktrin intakt); Rot-Lauf vor der Heilung + Gruen-Lauf danach sind Paketbestandteil.
T-9 TESTKRITIK: neue Tests jeder Welle gehen in der Folgewelle durch Codex-Pass + Objektpruefung.
T-11a WARMUP-PAAR-PFLICHTTEST (KON47-04; Status: GEBAUT, harness/mess_warmup_paar.hpp @ d3b5a393;
    Koeder-Nachweis (1)-(3) = Verify-Luecke): (1) Paar-Zaehlung 2x3 = 6 Messaufrufe / 3 persistierte Werte
    einzeln, nie gemittelt (Koeder: 3 Laeufe oder 1 Wert -> ROT); (2) --debug-Zweig genau 1x kalt
    (Koeder: --debug mit 2 Laeufen -> ROT); (3) Verwerf-Beweis: Lauf-1-Wert erscheint NICHT im
    persistierten Satz (Koeder: Lauf 1 gespeichert -> ROT).
T-11b KOMBIBAU-2x2 ALS PRUEFNORM (KON55): {clang,gcc} x {Debug,Release} = 4 Zellen je J-1..J-4 + ctest,
    je LITERALE Bilanz; EIN Bau-Slot bei sequentiellen Zellen; Abnahme-Regel je Stempel-/Mess-Paket.
    Nenner = Floor 545/541/539 (Datei-Stand 26.08.; 546/542/540 am pmckoeder-Branch, ungelandet).
    D-11 (+1-Regel): Floor-Datei + Gate-Erwartung im SELBEN Zug jeder +1-Landung (vollzogen 24.08. Z12:
    4/4 Zellen "545", Gate [5/6] exakt). D-13 K17-STANDBINDUNG: (a) Commit-Stand im Protokoll-Kopf,
    (b) Endstand = dev-Tip am Zugtag (frisch), (c) rc=${PIPESTATUS[0]} + explizite Build-Pfade.
    H-1-GATE-REGEL (KON129-07, Branch 4488d24f ungelandet): COMDARE_PRE_PUSH_BUILD_DIR PFLICHT (Exit 2
    ohne Var), Gegenstands-Proben (CMakeCache/CTestTestfile), LastTest.log-Schutz um ctest -N.
T-11c MUTATIONS-PROTOKOLL (KON57): je neuem Test >=1 protokollierte Wegwerf-Mutation mit literalem Rot +
    Gegenprobe-Gruen; Koeder-LAENGE/-Form pruefen, BEVOR die Mutation zaehlt (M-F2/19-20-Klasse).
T-12a DRIFT-GATE-DEBUG-AUSNAHME [OFFEN, kampagnenkritisch; #125; RunMethodology = 0 Treffer 26.08.]:
    (1) unter --debug schaltet das Drift-Gate ab (Koeder: Debug-Zellen drift-geprueft -> ROT);
    (2) Debug-Zahlen tragen AdmissionStatus::Gesperrt, erreichen NIE das Messwertlager (Koeder ROT);
    (3) Nenner-Zeile: BEIDE Zweige mit literalem Rot/Gruen. Ohne Bau ist ab 29.08. JEDE Zelle rot.
T-12b WARMUP-PAAR AM LEGACY-PFAD [Status: ANGEPASST statt ausgebucht (Task #13); run_observable_perm
    weiter vorhanden; Koeder-Nachweis offen]: Paar-Zaehlung auch am Legacy-Pfad ODER Ausbuchungs-Beweis.
T-12c ARENA-KAPAZITAETS-TESTS (E11) [GELTENDE FASSUNG 16.08.; Bau OFFEN]: (1) Kapazitaet 6 GB
    FEST/STATISCH, Planer-Reservierung zu Experiment-Beginn [OWNER-GATED W-1 gegen B6-F2]; (2) virtuelle
    Thread-Slots compile-time, Puffer statisch [OWNER-GATED W-1]; (3) GELTEND (Owner 16.08., verbatim:
    "Der harte Abbruch kann also nur am RAM Limit sterben, wenn die Mess-Arena voll ist"): volle Arena =
    HARTER ABBRUCH, failed ohne Retry, Bestand persistieren -- die Alt-Fassung "weiterlaufen+zaehlen" ist
    UEBERHOLT; Koeder "still verworfene Zeilen -> ROT" bleibt; Code-Bestand mess_arena.hpp "ZAEHLEN,
    MELDEN, WEITERMESSEN" = zu heilender Bestand (S13-05/07); (4) Hot-Path-Reinheit: kein Alloc, kein I/O,
    EIN Deskriptor-Verweis (Koeder: Aggregations-Allokation -> ROT); (5) IN-ohne-OUT-Invariante je
    (Prozess, Thread, Interface) als Auswerte-Wache.
T-12d FULL-JOIN-SCHEMA-TESTS FJ-1..FJ-10 [Traeger #18/s13schema ad5c6d66 gelandet; Einzelnachweise offen]:
    (1) Spaltenmenge E(A) = kV3AxisSchema + seg_* MIT Bezugsgroesse (seg_*-Summe == seg_run_total_ns;
    Koeder: seg_*_ns gegen total_ns gestapelt -> ROT); (2) markierter Leerwert: ECHT-0 eigene Klasse !=
    Auslass (Koeder: verschluckte echte 0 -> ROT); (3) Full-Join verwirft nichts (Koeder: Spalten-Drop ->
    ROT); (4) FullJoin-Namens-Wache bis zur Umbenennung.
T-12e S-3-KOMBIBAU-NACHWEIS: (1) 2x2-Matrix einmal real [ERFUELLT: K17 522/522 21./22.08. + 545er-Serie
    24.08.]; (2) Aktivierungs-Beweis "gebaut UND inert" mit ZWEI Zahlen [2 Produktions-Treffer bestaetigt,
    inert wird gemessen]; (3) Koeder (token, eltern)-flache Kuerzel-Pruefung -> ROT [offen].
T-13 WORKAROUND-KONFORMITAET (24.08., Board #135; Owner-Dauerregel 23.08. verbatim-Kern: "'geloest'
    [heisst] nicht automatisch konform ... workarounds [muessen] konform nach Plan gegengeprueft und als
    Struktur-Regression behandelt werden."): jeder Heilungs-/Workaround-Commit braucht VOR Abnahme ein
    dokumentiertes Urteil KONFORM / REGRESSION / OWNER-ENTSCHEID gegen Designplan + Wellenplan + GOAL v8 +
    KONs, MIT Zitat der geprueften Plan-Stelle (Urteil ohne Zitat = nicht geprueft); CI-gruen allein ist
    KEIN Konformitaets-Beweis. REGISTER: W135-1..7 (vl3-Maskierung a/b/c, PMC-Riegel+AUSWEIS, B06-Test-
    Harmonisierung, TemplateWithUnknownRef, stringop-overflow-Duldung, NSDMI-Fixmuster; Wellenplan
    par.27.1.E) -- Stand 26.08.: 0/7 verdiktet, Frist "VOR main-FF" GERISSEN (W-2); Nachtrags-Kandidaten
    Gate-Default H-1 + Director-Fix (KON129-07) noch NICHT im Register.
SUMMEN-REGEL (unveraendert, mehrfach gesetzt): 117/386 h bleiben unangetastet; T-11a-c, T-12a-e und T-13
sind erst zu addieren, wenn die S-Strecke (D-4) mit-durchgezaehlt wird -- sonst der T-3-Fehler aus par.9.

## D4 TESTARBEIT JE WELLE (par.4 verdichtet; Postenlisten s. D2)

EINFUEGE-REGELN (woertlich-kern): (1) die Landung eines Begleit-Tests folgt der Bauwelle seines
Gegenstands (Tests entstehen frueher, landen atomar); (2) W3-MESS ist blechexklusiv -- alles "W3-MESS"
landet BIS F3, in W3 laufen nur die Gates; (3) HY-A-Vertraege VOR den Bau (TDD-Fall; GELTEND-Vermerk D-1:
der Vertrag PINNT kGenusCount, definiert nicht grundauf). Sonderfall PM-NichtGelesen: Seam-/HW-Teil
getrennt; GELTEND: prod2 ist als Intel-CI-Host aktiv, der HW-Teil ist fahrbar (Platz via #96 zuweisen).
W-1/W0a/W0b/W1 = GELANDET (W-1 super ca901c50/ce 1f88cfec; F1 14.08. KON63; F2/Freeze 21.08.; Details +
Posten-Slots: Archiv par.4). Landestand JE POSTEN existiert im Designplan nicht = offene Verify-Tafel.
W2 (Mo-Fr 24.-28.08., F3) LAEUFT: Band A 8 Posten/21 h = Kampagnen-Wahrheit (MT-L1, MT-L2, MT-L6, MT-L7,
PM-m3v2Zero, PM-RAPL, PM-Scaled, PM-NichtGelesen-Seam), Landung bis F3 als Teil der GO-Vorlage; Band B
23/67 h nur bei freiem Slot. Trigger-Termin = SPAETESTE Frist (A2 volles GO "direkt so bald wie moeglich").
W3-MESS: 0 h neue Testarbeit; W0b/W2-Gates SIND die Batch-Abend-Instrumente; Band B nur in Batch-Pausen
[lok] ohne Landung. W4: HY-Kurvenlage/HY-Ausgaenge/HY-HonestEmpty mit HY-C + HY-Ebene4b (34 h) + B 4/11 h;
danach MT-L10/L12 (hinter MT-L5-Flag), MT-L11, AG-GenusCount; Zugaenge aus der Wiederaufnahme: MT-L8,
PM-PAPI, AG-PunktFixes. W5: keine Test-Eingriffe, nur Nachweise (Koeder-Protokolle, Nenner-Zeilen) in die
Abgabe-Doku.
W7 = KEIN ENDLAGER (Owner 18.08. par.21.0: "Es wird NIE etwas ausgebucht oder verschoben"; Owner C-2
17.08.: "NICHTS nach der Abgabe"; Owner A5 25.08.: W7/#88-Split VOR der Abgabe). Band C (5/13 h):
PM-WinPCM -> W2/W4 (Windows-Runner 4/4 online), PM-AmdL3 1-2 -> Talos-Lane #87, MT-L8/PM-PAPI/
AG-PunktFixes -> W4. Band B/W1 (22 Posten/62 h) wiederaufgenommen; Band-B-Rest 37/~104,5 h -> W3-[lok] +
W4/W4-Fangnetz; Feinplatzierung = #96/RN-26 (Namensmengen-Divergenz W-11: #96 muss BEIDE Mengen nennen).

## D5 DIE SEQUENTIELLE KETTE (par.5 woertlich; Status 26.08. in Klammern)

1. ST-CTestWache (VOLLZOGEN W-1) 2. MT-L4 + AS-Bewaffnung + HY-Label (VOLLZOGEN W0a) 3. Rote Statistik-
Suite ST-Welch -> ST-MultiCompare -> ST-Diskrepanz/ST-Export -> ST-CLITestat (VOLLZOGEN, D4-Landung)
4. PE-BauTestat -> PE-PruefXOR im D3-Bogen; PE-AllowFailure/Rules/Preflight dort (Status offen)
5. XL-L11 -> XL-L1-B; LG-CsvAlt unabhaengig (offen) 6. HY-Gleichstand vor jedem Router-Code (offen)
7. MT-L5(b) CI-Job COMDARE_V32_DRIVER_ENABLE=ON -- Stand NICHT belegt; entsperrt MT-L10/L12 8. D5-1-Kanon
(VOLLZOGEN W0a) entsperrt PK-KanonWert -> PK-Kreuztest -> PK-KlemmJson; PK-DeleteP99 mit D5-4 9. MT-L3
VOR D4d und VOR jeder End-Append-Spalte (VOLLZOGEN 10.08.; Ledger-CAVE: D4d haengte 'degeneriert' am
09.08. VOR MT-L3 an -- formal verletzt, sachlich anderer Gegenstand) 10. HY-Reroute -> HY-ModulGrenze ->
HY-Ebene4a (VOLLZOGEN, HY-A 18.08.) 11. LG-HostBinder -> LG-SkipCallback -> LG-E2Exlsx; LG-LoadWache/
LG-Idempotenz nach ihrem Produktionsbau (offen) 12. PM-m3v2Spalten vor PM-Naht (offen) 13. ST-HeurIdentisch
vor ST-BreakEvenKreuz (offen) 14. AS-DupReject vor AS-OrganOrdnung (offen) 15. AG-Concepts11 vor
AG-IsComposition vor AG-Noexcept (offen) 16. W4: HY-Kurvenlage/Ausgaenge/HonestEmpty nach HY-C-Stub;
MT-L10/L12 nach 7 (Zukunft).

## D6 CODEX ALS STEHENDER KRITIKER (par.6)

EINSATZREGELN: (1) nur auf frisch gepinntem SHA, beide Repos, tests/ gesamt; (2) Output ist KARTIERUNG,
nie Zitat -- jede tragende Referenz selbst lesen; keine Codex-Zeile/-Zahl ungeprueft in einen Test (K13);
(3) Pflicht-Meta-Stufe (einstufig faellt ein Viertel); (4) je Welle ein Codex-Pass ueber die NEUEN Tests
der Vorwelle (T-9); (5) NICHT einsetzen fuer Aufwandsschaetzung, Wellen-Zuordnung, Owner-Entscheide.
BETRIEB 26.08.: bwrap DAUERHAFT defekt -> Plan-B codex exec CLI mit Diff-VOLLTEXT im Prompt; Ersatz-Lens-
Klausel nur mit frischer Defekt-Probe; Login GEHEILT 26.08. ~11:03Z ("Logged in using ChatGPT");
Einsatz-Gate-Smoke je Session Pflicht. Befund-Historie (SHAs 85847715/7bcf353b): Archiv par.6.

## D7 WAS NICHT GETESTET WIRD (par.7)

BEWUSST NIE GETESTET (woertlich): Holm/Bonferroni bei malformten p-Werten (Erzeuger liefern [0,1]) *
v32_orchestrator-Stub (dokumentiertes Soll auf totem Pfad) * alpha=1-Konstruktion (kein realer Eingang) *
HDR-Histogramm [STATUS: Bedingung "falls gefuehrt" ist EINGETRETEN -- D5-5 gefuehrt + getestet seit 09.08.
(test_d55_hdr_verdrahtung.cpp); Verdrahtungs-Rest = #105]. Band-B/C-Kostenabsaetze: Archiv par.7 +
Wellenplan par.21.3 (Wiederaufnahme).

## D8 AUFWAND / NENNER (par.8)

117 Posten = 385,5 h (~386 h): Band A = 53 Posten/206 h, B = 59/166,5 h, C = 5/13 h; Konsistenz
53+59+5 = 117 und 206+166,5+13 = 385,5; Klassen 29/25/23/16/10/9/3 + 2 (par.9.6-geprueft).
Kapazitaets-/Deckungsrechnung 08.08. (~118/~131,5/~30/~75 h) = HISTORIE; geltend: Kapazitaets-Ehrlichkeit
Wellenplan par.21.3 (">200 h zusaetzlich auf 19 Kalendertage"; Owner: volles Risiko + Mehr-Kontingent-
Parallelitaet + [lok]-Klasse); Stempel-Strecke kommt ZUSAETZLICH und faellt NIE (D-2).
NIE-FALLEN-LISTE (woertlich): ST-CTestWache, MT-L4, die Statistik-Begleittests, PK-KanonWert, LG-XlsxAlt/
LG-CsvAlt (Messdaten nie loeschen), die HY-Vertraege -- "Owner: ALLES PFLICHT".
BEDINGUNG (4) (woertlich-kern): TDD wird als ERSATZ, nicht als Zusatz gebucht -- der Test ist die Abnahme
des Pakets, keine zweite Abnahme daneben.

## D9 DIE ZAHLEN-WACHE (par.9 verdichtet)

ANKERTAFEL (Stand 25.08., 26.08. reproduziert; SOLL aus dem Plan, IST aus dem Code -- zwei Quellen, T-3):
    PZW-CE-SHA         = d3b5a3936d1136c86003bdbabff668a21a85378f
    PZW-SCHEMA-STELLEN = 45      PZW-SCHEMA-DATEIEN = 24
    PZW-SCHEMA-LITERAL = 2       PZW-CI-AUFRUFE     = 2       PZW-CI-ALTMUSTER = 0
    Nenner: 564 Test-.cpp / 2968 Z. .gitlab-ci.yml. Wache ci/plan_zahlen_wache.sh; Bissproben
    ci/tests/plan_zahlen_probe.sh + mess_ausbeute_bissprobe.sh (beide Richtungen; D-3: Form = Alt-Last,
    Migration zu Google Tests im S-16-Zug #28).
ZWEI EINHEITEN, ZWEI ZAHLEN: die PZW-Tafel zaehlt lazy_csv_header()-STELLEN; der FLOOR-ANKER (T-11b/T-17-
Kombibau-Nenner, scripts/ci_test_inventory_floor.txt, heute 545/541/539) ist der ctest-Gesamtnenner --
wer sie verwechselt, wiederholt die Fehlerklasse, die par.9 korrigiert.
ZAEHL-REGELN (7): Baum am Gitlink-SHA, nie Arbeitskopie (Submodul-M-Falle) | Kommentar-Abzug VOR der
Datei-Zaehlung | 4-Felder-Schnitt bei git grep -n <SHA> | Anker nach dem Setzen nochmals gegen das Objekt
fahren | Nenner zaehlt DATEIEN, Anker zaehlen STELLEN | PZW != Floor | Vorher-Nachher-Sprung nur aus
DEMSELBEN Zustand (B-2: vier ctest-Zustaende einzeln nennen).
B-4-REGEL: Muster mit $( nur mit grep -cF; eine Null gilt erst nach beissendem Koeder.
NICHT GEDECKT (par.9.6, woertlich-kern): die vier ctest-Zustaende (Deckung = ce-Sichtbarkeits-Wache
1f88cfec) | Saetze ohne Zahl (Deckung = Codex-Pass + T-9) | die Aufwaende (Schaetzungen; einzige geprueft
Eigenschaft = innere Konsistenz) | die 157/117/40 (Aussage der Meta-Stufe, nicht nachgezaehlt).
Historie: 22 Nachzuege 09.08.-25.08. + Berichtigungen B-1..B-4 am Objekt = Archiv par.9.1-9.5.

## D10 DRIFT-REGISTER D-1..D-13 (geltende Fassung je Posten)

D-1 Hybrid-Bestand nicht null: der HY-Vertrag PINNT kGenusCount (4 Header/943 Z.); HY-A gelandet 18.08.
D-2 Stempel-Strecke ZUSAETZLICH, faellt NIE; "Band B/W1 gestrichen" = Historie (wiederaufgenommen 18.08.).
D-3 Shell-Bissproben = Alt-Last -> Google Tests; S-16 heute 14 Dateien/8902 Z. super, 0 retired; #28.
D-4 S-Strecke (S-6, S-13, S-14, S-17..S-21, +S-22) OHNE Testposten im 117er-Katalog -- Luecke OFFEN seit
    12.08.; am Objekt existieren S-Tests (S-19: 89+20 Pruefungen) UNGEZAEHLT; Summen-Sperre bis
    Durchzaehlung (I-25/(01)).
D-5 xlsx-Nenner: 0 von 11 xlsx-blind (15.08.); T-3-Profil-Nenner-Wache offen; X2-Factory -> #18.
D-6 PMC-Vertragsfolge: Paket #82/#83 gelandet (fail-loud, n/a-Token); dtlb-Koeder-Fix auf Branch;
    CEB->Tier-CT-Vertragsanpassung weiter OHNE Katalog-Posten.
D-7 Floor-Anker-Einheit: o2-Landung hob 544/540/538 -> 545/541/539 (+1-Regel); PZW != Floor.
D-8 Vendor-O3: OWNER-ENTSCHIEDEN X4/OS-1 = (b) GLOBAL O2, O3 nur auf XML-Wunsch; "(a) De-facto" =
    HISTORIE; Bau laeuft (VO3-1 @ 9c75bad0, B1-B4 erledigt); Text-Marker im Archiv-par.13.2 ausstehend.
D-9 M13-Absorption VOR erster produktiver Konsumierung von kBegriffsAliasRegistry (Design-Entscheid
    24.08.; Praemisse "0 Konsumenten" = Stand 24.08., vor Bau neu messen).
D-10 T-13 (s. D3). D-11 Floor-Gate-Zug (s. T-11b). D-12 #114-Beweislaeufe: Lauf 1 NO-GO 9/10 (Ursache =
    pmc-Koeder-Defekt, kein Produktivdefekt), Lauf 2 GO 10/10 + 23/23 + 0 Befunde; BLEIBENDE PFLICHT: EIN
    #114-E07-Q1-Re-Run <1 h nach JEDER Linienbewegung (final eingefrorene Trigger-Linie).
D-13 K17-Testat-Standbindung (s. T-11b).

## D11 OFFENE TESTPFLICHTEN -- GEZAEHLTE LEBENDE WARTELISTE (Stand 26.08., 18 Posten)

(01) S-Strecken-Durchzaehlung S-6..S-22 in den Katalog (D-4; hebt die Summen-Sperre)
(02) T-12a Drift-Gate-Debug-Ausnahme BAUEN (vor W3-Generalprobe 29.08.; #125)
(03) T-12c-Heilung Arena harter Abbruch (mess_arena.hpp; S13-05/07-Traeger)
(04) T-13-Verdikte W135-1..7 (0/7; Frist war "VOR main-FF" -- gerissen, s. D13/W-2)
(05) T-13-Nachtraege Gate-Default H-1 + Director-Fix (KON129-07; Urteile + Landung)
(06) test_rcu unter Parallel-Last (F3-01b)
(07) D3-7b dritter Modus pruef_only in der Treiber-Bilanzzeile
(08) MT-L5(b) CI-Job COMDARE_V32_DRIVER_ENABLE=ON -- Stand erheben (entsperrt MT-L10/L12)
(09) T-12d-Einzelnachweise FJ (1)-(4) am Objekt
(10) T-12e Rest: (2) inert-Messung dokumentieren + (3) Paar-Identitaets-Koeder
(11) D-5-Wache: T-3-Posten mit thesis_profiles-Nenner (11)
(12) D-6 CEB->Tier-CT-Vertragsanpassungs-Posten
(13) OS-2: hartes CMake-Gate (Vendor-Toolchain-Deklaration, FATAL_ERROR) + Original-Compiler-Nachweis-
     System (#130 SCHARF; Reichweiten-Frage W-9)
(14) S-19-Verdrahtung: golden_n-Wache + COMDARE_GN_TOTAL aus simulate-Ausgang (T-3 FREMD), GN-Divergenz
     FATAL statt Hinweis (Owner B6-F1; B1 EXPECTED_N hart / B2 YAML-Literal)
(15) F-17-Umbau: Koeder-Tests test_s8kopf_planner_kopf + test_ck1_messkette_koeder ROT-ZUERST auf 1 Dock;
     static_assert(anzahl==6) faellt (#24/B4-Scope)
(16) X3-S8 Scheduling-Stempel-Glied [11] + "Stempel Teil 2" (Kandidat B-7/RN-78; Objekt-Abgleich vor Bau)
     -- VOR dem Trigger (Owner F-X3-1 = A)
(17) VO3-1-Testseite: T-1-Koeder O2-Dreh + Glied [5] vendoropt (Bau B1-B4 @ 9c75bad0; REST B5-B7 +
     OS-2-Gate + K17) + pmc-dtlb-Koeder-Landung (20d6dd2c) mit Floor 546/542/540 + PZW-/Ledger-Nachzug
(18) EIN K17 am zusammengesetzten Landewellen-Endstand + EIN #114-Re-Run (KON129-07; T-11b/D-13/D-12)
FUSSNOTE (Stand-Verbuchung 26.08.): E-10-FIX-1..7 und VO3-1-FIX-1..5 (3-Lenses-/2-Lenses-Verifies,
TRAEGT_MIT_FIXES) leben als Bau-Auflagen in den gepatchten Workflow-Skripten (K1c F-04/F-05) und werden
nach Bau-Ende als T-13-/Board-Nachtraege verbucht (Boards #133/#145 tragen noch die Kurzform).

## D12 OWNER-TRANCHE 26.08. -- TESTSEITEN-WIRKUNG (T26-1..T26-9; verbatim: Memory owner-kerne)

T26-1 OS-1 = R1: "Ja, die ausdrueckliche definition von O2 UND O3 ist von mir gewollt. Der default waere
      auch nur O2. Wir bleiben dennoch bei O2 und O3 zum Testen." -> Trigger-XML {O2,O3}, n_bau 524288.
T26-2 F-X3-1 = (A) VOR dem Trigger + "bitte auch den vergessenen Stempel Teil 2 suchen und mit
      implementieren vor dem Trigger." -> zwei Vor-Trigger-Bauposten mit T-1/T-11c-Pflicht (D11/(16)).
T26-3 KN-1..KN-4: "alle genau wie empfohlen durchziehen. Volles Go." -> E-10-Bau #133; EIN K17 am
      Endstand, Floor +N (D11/(17)(18)).
T26-4 OS-2: hartes CMake-Gate nachbestellt + "selbst dafuer sorgen, dass die compiler und tools auf einer
      Ziel-Maschine mit dem Systemcompiler nachgebaut werden koennen, um ihrerseits den code correkt
      originalgetreu zu bauen." -> neue Testpflicht-Klasse (D11/(13)); Nummern-Vergabe = Lead; W-9 offen.
T26-5 F-17: "Die CEB ist kein hybrid und hat daher nur ein Pruefdock, nur bei der Hybrid-Tier-Binary ist
      das dynamisch wie empfohlen. [...] Aber korrekt ist dynamisch je Planer." -> CEB = EIN Dock,
      Hybrid-Tier dynamisch je Planer; 2 Koeder-Tests + static_assert-Umbau ROT-ZUERST (D11/(15)).
T26-6 B6-F1 (verbatim-Kern): "es gibt ohne die Planer Direktive wie im PLAN BESCHRIEBEN keine
      errechenbare Obergrenze [...] das --simulate flag im Planer zu integrieren, um aus einer golden XML
      die Tatsaechliche Simulation der Experiment Groesse zu berechnen [...] Also grundsaetzlich ja."
      -> S-19 IST gebaut+gelandet (a1b348ae Ancestor von dev); Ruege trifft LANDUNG+SICHTBARKEIT+
      VERDRAHTUNG (B1/B2, GN-Divergenz FATAL) = T-3-/T-2-Pflichtposten (D11/(14)).
T26-7 B6-F2: "hart ist in diesem System nichts, es ist ALLES dynamisch und muss ausgerechnet werden."
      -> Widerspruch W-1 zu T-12c(1)/(2) -- OWNER-GATED, nichts drehen (D13).
T26-8 CODEX-LOGIN VOLLZOGEN 26.08. ~11:03Z -> D6 (Zweit-Lens einsatzfaehig; Gate-Smoke Pflicht).
T26-9 META-REGEL: "Bitte Block F erst durch explores ueber 12 Wochen absichern und dann nur die wirklich
      offenen Fragen fragen. [...] es war alles schon beantwortet." -> Prozessregel jeder Rueckfrage.
Nicht testseiten-wirksam: E1/E2/E3 + Lizenzpunkte (Testseite nur als kuenftiges reuse-CI-Gate D3b),
D1/NAS, Block-D-Rotationen, Thesis-Sync (#121), Aufgabenblatt-PDF (Owner-Bericht geschuldet).

## D13 WIDERSPRUECHE / OWNER-GATED (nie selbst entscheiden; Volltext K3-designplan-drift.md Abschnitt 4)

W-1 [OWNER-GATED] T-12c(1)/(2) "6 GB FEST/STATISCH, compile-time" (16.08.) vs. B6-F2 "ALLES dynamisch"
    (26.08., Kontext Ziel-N/Planer) -- ob der Satz die Arena-Kapazitaet dreht, ist NICHT ableitbar;
    bis zur Owner-Antwort 16.08.-Fassung bauen, nichts still drehen.
W-2 [REGRESSIONS-BEFUND] W135-Verdikte 0/7 trotz vollzogenem main-FF (Frist "VOR main-FF" gerissen) --
    Heilung = Verdikte nachholen (#135/#128), KEINE Ausbuchung; Kenntnisnahme-Zeile in die Owner-Vorlage.
W-9 [OWNER-GATED nach Explore] OS-2-Gate-Reichweite: nur ext/traversal/P0x-Original-Papers oder AUCH
    vendorierte Allokatoren A01/A04/A05/A07/A08? Owner-Vorlage vor dem Bau, kein Rateversuch.
W-11 [QUELLEN-DIVERGENZ] Band-B/W1-Namensliste Wellenplan par.21.3 vs. Designplan-Katalog (Summe je 22
    Posten/62 h, Namensmengen weichen ab) -- massgeblich = Designplan-Katalog; #96 nennt BEIDE Mengen.
Weitere (aufgeloest/Lead-Posten): W-3 D-8-Text-Marker ausstehend | W-5 Summen-Sperre ungeheilt seit
12.08. | W-6 F-17-Folgefragen S3-L1/L2/L3 nach 12W-Explore | W-7 mess_arena-Kommentar != Doktrin |
W-8 HDR-Zeile veraltet (Statusvermerk gesetzt) | W-10 "Stempel Teil 2"-Referent: Objekt-Abgleich, keine
neue Owner-Frage | W-4 Platz vs. {O2,O3} (T1 = (c) NFS; Testseite: K17 + Re-Run vor Trigger).

## D14 HISTORIE-VERWEISE (nur im Beleg-Archiv)

par.0-Zahlenprosa * par.9.1-9.4-Berichtigungsprosa (B-1..B-4) * par.9.5-Nachzugskette (22 Nachzuege) *
par.13.4/13.5-Abnahmevermerke (TRAEGT-Urteile, Pruefumfaenge 829/191/701) * W-1..W1-Wellentermine *
par.8-Kapazitaetsrechnung * Marker-Wortlaute (UEBERHOLT/WIEDERAUFNAHME/EINPLANUNG) * Lehr-Saetze am Ort:
"Prosa wird nicht rot" / "Zwei Einheiten, zwei Zahlen" / "gefallen heisst nicht erledigt" / L-4 "jede
'existiert nicht'-Aussage traegt ein Verfallsdatum" / "Registrierung IST Teil des Tests" / "ein gruenes
Gate deckt nur seinen Gegenstand".
