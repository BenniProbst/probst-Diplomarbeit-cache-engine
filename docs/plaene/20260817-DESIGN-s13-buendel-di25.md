# DESIGN S-13-BUENDEL -- Di 25.08.2026 (Welle W2, engster Slot)

Stand: 17.08.2026 | Klasse (M) = vor Trigger Mi 26.08. 06:00 | Gegenstand: Task #18 (S-13) samt
#57 (Lager), #48 (publish), Arena E1-E11, Full-Join FJ-1..FJ-10, Sheet-System, CSV-Factory,
E-18-Token-Umstellung, B5 (XML-Trennung Bau-/Mess-Menge).

Zweck: am Di 25.08. wird NUR NOCH GEBAUT. Dieses Dokument traegt je Posten IST-am-Objekt,
Luecke, Schnitt, Abnahme und Reihenfolge-Zwang. Es ist ein DESIGN -- kein Code wurde geaendert.

    FASSUNG 2 -- A2.5-FIX-RUNDE 17.08.2026 (unabhaengiger Review-Lens, Urteil TRAEGT_MIT_FIXES)
    Alle 13 Funde sind eingearbeitet; jeder Beleg wurde VOR der Aenderung am Ledger-Original bzw.
    am Objekt selbst nachgelesen (OV-Doktrin: nie die Nummer, immer den Gegenstand).
    Die vier MUSS-Funde haben das Buendel substantiell verschoben:
      1. Arena-Ueberlauf: von "weiterlaufen+zaehlen" auf HARTEN ABBRUCH (Owner > Plan) -> 4.2/S13-07
      2. Sechs fehlende FJ-/Schema-Posten nachgezogen                 -> S13-31, S13-32, X-8, X-9
      3. Zeilenlimit: von "Wurf zementieren" auf FOLGE-BLATT-Politik (E5)          -> S13-18
      4. result.csv ist ein RESUME-VERTRAG und steht ausserhalb des Ziel-Filters   -> S13-03
    Aufwand dadurch 17,1 -> 20,9 Slots (Abschnitt 9). Die Stellen tragen einen A2.5-Fix-Vermerk.

    FASSUNG 3 -- A2.5-RUNDE 2 (Folge-Lens, TRAEGT_MIT_FIXES; 12/13 Erst-Funde bestaetigt behoben)
    Fuenf Rest-Posten, alle eingearbeitet:
      NEU-M1  W5 in S13-27 stand gegen den Resume-Vertrag -> auf AUSWERTE-Persistenz gescopet,
              S13-03 als benannte Ausnahme referenziert                            -> 4.8/S13-27
      NEU-S1  X-9 ohne Wirkungs-Traeger: Inertness-Wache ergaenzt + Ordnungs-Frage
              (KON91-01(3) gegen gebaute Ebene-3-Realm) mit Traeger ausgewiesen    -> 5/X-9, OV-S13-6
      NEU-S2  S13-18-Doppel-Residuum (6(4) "frei", Abschnitt-9-Zeile 0,2) nachgezogen -> 6(4), 9
      NEU-S3  Ueberlauf-Residuen in 1.1/7.1 markiert; 7.3-Struktur richtiggestellt -> 1.1, 7.1, 7.3
      NEU-K1  X-8 Opt-in-Koeder ergaenzt                                           -> S13-32

    ERHEBUNGS-BASIS (Datum ist load-bearing)
    ce-HEAD  Code/external/comdare-cache-engine @ development, Commit 04ac26fa, gemessen 17.08.2026
             (Stand NACH der golden-Fenster-Landung 90ee6809 -> 04ac26fa, CI 15937 gruen)
    super    Repo-Wurzel @ development, gemessen 17.08.2026
    Methode  READ-ONLY. Gesucht wurde nach dem GEGENSTAND, nicht nach dem Konsumenten
             (BESTANDS-PFLICHT). Nichtfunde nur mit Gegenprobe.

    MASSSTAB / QUELLEN
    Wellenplan  docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md
                Par.19.2 (Korb B, B-01..B-20, Z.2278-2325) | Par.19.5 (FJ-1..FJ-10 + E1-E11, Z.2427-2447)
                Par.18.4 (W2-Slot-Tabelle, Z.2148-2163) | Par.19.1/A-09 (FullJoin-Umbenennung, im #15-Bruch)
    Designplan  docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md
                Par.12/T-12c (Arena) | Par.12/T-12d (Full-Join) | Par.11/T-11b (Kombibau) | Par.11/T-11c (Mutation)
    Karten      docs/sessions/backups/20260817-drift-konsolidierung-rohdaten/
                rest_karte_r5.md (A1-A22 Messkette/Sheets, A41-A52 Lager/xlsx/ETA)
                rest_karte_r4.md (B-01..B-12 W2-Buendel, C-2 w/ma/mi-Widerspruch)
                rest_karte_r3.md (B1-B9 Lager-Basis/Host/XML-Trennung)
                explore_karte_e3.md (A9-Schreiber "GEPRUEFT UND ALS ERLEDIGT VERWORFEN")
                DOSSIER.md (R-01..R-38 Ur-Ledger-Rueckkehrer) | LESE-SYNTHESE-kontext10.md
    Vorschlag   docs/sessions/backups/20260815-folge-bu-kontext7/dumps/xml_ziel_sektion_vorschlag.md
                (#48 publish-Sektion, 9 Abschnitte + O1-O10) | lager_minio_explore_RAWDATA.md

--------------------------------------------------------------------------------------------------

## 0. KURZBILANZ -- DER BEFUND, DER DAS BUENDEL VERSCHIEBT

**Die A9-Bauliste aus r5 A45 (Anker 09.08.) ist am heutigen Objekt weit ueberwiegend STALE.**
Was dort als "Fehlt/nie begonnen" gefuehrt wird, existiert am 17.08. gebaut, getestet und in
Teilen produktiv verdrahtet. Gemessen (ce @ 04ac26fa):

    A45 sagt "fehlt"                       IST 17.08.2026
    -------------------------------------- --------------------------------------------------------
    IErgebnisBlatt / IErgebnisMappe        DA  builder/lager_ablage/ergebnis_mappe.hpp:367 / :390
    ErgebnisMappenFactory                  DA  ergebnis_mappe.hpp:631 (+ Fabrikfunktion :638)
    XlsxErgebnisMappe (eigene TU, PRIVATE) DA  builder/lager_ablage/xlsx_ergebnis_writer.cpp, Target
                                               comdare_lager_ablage, PRIVATE-Link auf
                                               comdare::vendored_xlsxwriter (lager_ablage/CMakeLists.txt)
    CsvErgebnisMappe                       DA  ergebnis_mappe.hpp:488 (+ CsvErgebnisBlatt :428)
    ErgebnisSchreibFehler                  DA  ergebnis_mappe.hpp:246
    INFO-Sheet-Inhalt (Sysinfo etc.)       DA  kInfoBlattName :310 | MaschinenSysinfo :122 |
                                               HauptAchsenBelegung :110 | KonstantenMeta :115
    WritebackMethod::Xlsx                  DA  measurement/writeback_method_registry.hpp:34,
                                               kWritebackMethodCount = 4 (:38), Registry-Zeile :51,
                                               static_asserts :75/:80 -- Kommentar datiert A9-S3 08.08.
    S4 CLI tools/mess_report/              DA  main.cpp + mess_report_render.hpp + realm_scan.hpp +
                                               skip_manifest.hpp + dynamic_axis_filter.hpp
    -------------------------------------- --------------------------------------------------------
    ergebnis_dateiname.hpp                 FEHLT (Gegenprobe: `find -name "ergebnis_dateiname*"`
                                               ausserhalb build/ und .git/ = 0 Treffer)

**Zusaetzlich gebaut und im Massstab nirgends gefuehrt:** die Gegenstands-Ebene
`enum class MessEbene { Compare, Macro, Micro }` (ergebnis_mappe.hpp:206) mit `MessEbenenSchluessel`
(:231) und `mess_ebene_sheetname()` (:320); der Checkpoint-Tag `enum class Checkpoint { In, Out }`
(:218); die 31-Zeichen-Wache (`kXlsxSheetNameMaxLen` :268, `xlsx_sheetname_zulaessig` :275); das
Zeilenlimit (`kXlsxZeilenlimit = 1'048'576` :340, `xlsx_zeile_erlaubt` :346).

**Und die Arena-/Checkpoint-Kette ebenso.** Zwei Verzeichnisse, die keine Karte fuehrt:
`libs/cache_engine/mess/` (genus_kaskade.hpp, konfiguration.hpp, mess_naht.hpp, pilot_achsen.hpp,
pilot_suche_impl.hpp, steuer_dock.hpp) und `libs/cache_engine/builder/measure_storage/`
(checkpoint_measure.hpp "DAS ZENTRALE MESSINSTRUMENT DES SYSTEMS (Owner-KERN 09.08.2026)",
checkpoint_speicher.hpp, mess_arena.hpp, stapel_arena.hpp, mess_speicher_kanon.hpp; zusammen
1207 Zeilen). Beide Arenen existieren mit GETRENNTEN Fehlerklassen, der Ueberlauf ist als
`UeberlaufBefund` gebaut, und der Aufnahme-Aufruf nimmt einen DESKRIPTOR-INDEX. Abnahme-Tests:
`test_ck1_messkette_koeder.cpp` (455 Z., Owner-KERN 09.08.),
`test_ms1_arenen_kein_alloc_im_fenster.cpp` (1443 Z.), `test_ms2_pre_touch_seitenfehler.cpp`
(236 Z.). Details und die drei verbliebenen Luecken: Abschnitt 4.2.

**Und die Naht lebt produktiv.** `profile_facade/ergebnis_mappe_naht.hpp` (730 Z.) ist per
`profile_facade/CMakeLists.txt:101` als PFLICHT-Link (ODR-Use) gezogen; der Lauf ruft sie in
`profile_facade/experiment_run_entry.hpp:267-270` (`MappenNaht mappe; mappe.oeffnen(a.out_csv,
ep.writeback_methods)`), die Zeilen gehen im `emit`-Lambda (:272-284) aus DERSELBEN In-Memory-Quelle
in beide Senken.

**Daraus folgt der Zuschnitt des Buendels:** S-13 ist zu ~70 % ein VERDRAHTUNGS-, WACHEN- und
SCHEMA-Paket und nur zu ~30 % Neubau. Der einzige grosse echte Neubau liegt im Lager (#57,
LB-4/LB-5/LB-6) und in der publish-Sektion (#48). Die verbliebene Kern-Luecke der xlsx-Haelfte
benennt der Code SELBST, woertlich in `ergebnis_mappe_naht.hpp:13-15`:

> "ADDITIV HEISST WOERTLICH: der bestehende rohe CSV-Pfad (std::ofstream csv{a.out_csv...}) wird
> NICHT angefasst, nicht umgeleitet, nicht ersetzt. golden bleibt byte-identisch. Das ERSETZEN des
> rohen CSV-Pfads ist ein spaeterer, Owner-freizugebender Schritt und ausdruecklich NICHT dieses
> Paket."

Genau dieses Ersetzen IST der Kern des Di-25.08.-Buendels -- zusammen mit dem Ziel-Filter und der
per-Binary-Mappe (KON32-01 "bleibt falsch und muss behoben werden").

--------------------------------------------------------------------------------------------------

## 1. GEGENSTAND UND ABGRENZUNG

### 1.1 Die neun Flaechen des Buendels (32 Bau-Schritte, Stand Fassung 2)

    A  #18-Kern      Ziel-Filter | roher CSV-Strom wird KIND der Mappe | per-Binary-xlsx |
                     Export-Element (KON27-02 Option b)                          -> S13-01..S13-04
    B  Arena         E1-E11 (Kapazitaet 6 GB statisch, Deskriptor-Regel, Thread-Slots,
                     Ueberlauf = HARTER ABBRUCH [Owner KON93/94; die aeltere Lesart
                     "Ueberlauf=BEFUND" ist UEBERHOLT, s. 4.2], Drain E6)         -> S13-05..S13-09
    C  Full-Join     FJ-1..FJ-10: Spaltenmenge E(A) mit Bezugsgroesse, markierter Leerwert,
                     verlustfreier Join, Namens-Wache                             -> S13-10..S13-13
                     + E4-Aggregator (Join-Ort, ZWEI Modi)                        -> S13-31
                     + FJ-1 schicht-parametrisch, FJ-2 gegen BEIDE Quellen        -> S13-32
    D  Sheet/CSV     Blattzahl-Formel + Hyperlinks | zwei Blatt-Familien EINE Factory |
                     Filesystem-Hierarchie | CSV-Factory + Namens-Grammatik       -> S13-14..S13-18
    E  Schema-Wache  XSD-Enum-Wache fuer writeback_methods (A43-Rest)             -> S13-19
    F  B5            XML-Trennung BAU-Menge / MESS-Menge                          -> S13-20
    G  #57 Lager     LB-4/LB-5/LB-6 | Host-Belegung | Plan-Ablage | zwei Wurzelebenen |
                     rebuild-Flag + Teilprojekt-Skip                              -> S13-21..S13-26
    H  #48 publish   <publish>-Sektion | AF_BRANCH XML-erreichbar                 -> S13-27..S13-28
    I  E-18          Token-Umstellung PAT -> CI_JOB_TOKEN (KON86, G2 frei seit 19.1.4) -> S13-29
    +  Wache K-D1    Abbildung MeasurementTooling -> MessEbene mit static_assert (aus D-1) -> S13-30

### 1.2 Zuordnung ALLER 20 Korb-B-Posten (Wellenplan Par.19.2)

    IM BUENDEL (12)
    B-03  Arenen je Tier/Hybrid, ram_warn 6GB / ram_oob AUS, XML-einstellbar   -> S13-05, S13-19
    B-05  MeasureStorage: 8 Owner-Festlegungen, ZWEI Arenen, Allokations-Verbot -> S13-05..S13-08
    B-06  Ursache-Kette variadische Mess-Template-Variablen durch Gattung+Genus -> S13-09 (Beleg)
    B-07  Bestands-Fallen (Anti-Vorlagen) + csv_to_latex -> measure_to_latex     -> S13-17 (Migration)
    B-08  Lagerbaum ZWEI NEUE WURZELEBENEN Gattung->Genus                        -> S13-25
    B-09  Bestandslog nicht scharf (mess_bestandslog_active=false)               -> S13-21
    B-10  Hybrid: Tier-Bau/-Laden IMMER durch die CEB delegiert (Lager-Teil)     -> S13-22
    B-11  measure-drop-Kanal ZWEIFACH heilen (Ziel-Filter UND per-Binary-xlsx)   -> S13-02, S13-03
    B-12  Export-Element Option b + vier ct-gesicherte Rueckschrieb-Methoden     -> S13-04, S13-19
    B-13  Drei-Ziele-Struktur je XML separat; Runner lesen nur ccache+NAS        -> S13-27
    B-15  Default-Doktrin constexpr-Defaults, XML ueberschreibt (S-13-Teil)      -> S13-04, S13-27
    B-18  vierte Mess-Ebene = SPALTE der Macro-Stufe                             -> S13-10 (Spalte)

    NICHT IM BUENDEL (8) -- Ziel steht daneben, hier nur zur Vollstaendigkeit
    B-01  Naht-Schablone Planer<->CEB, 3 Nachrichtenklassen hinauf   -> S-8/S-10/#20
    B-02  Steuer-Naht spricht gefiltertes XML, sparse binary         -> #20
    B-04  Inter-Experiment-Fenster = bidirektionale Sync-Barriere    -> S-8 + S-10
    B-14  SECHS STEUERDOCKS, zwei Rechtsakte, Sammel-Release         -> S-8/S-10
    B-16  Zielform-Pflicht S-8/S-9 in Vier-Unterprojekt-Form         -> W2-Struktur (#29)
    B-17  Emissions-Doktrin fuer S-12 (KEINE YAML)                   -> #3
    B-19  <measurement_tooling> + Stufen-Dimension                   -> #24-B1
    B-20  System B umstellen, "Steuerung -> Compile"                 -> #24-B4

--------------------------------------------------------------------------------------------------

## 2. DIE TRAGENDEN DESIGN-ENTSCHEIDUNGEN

### D-1 | w/ma/mi: der Streit ist IM CODE entschieden -- Instrument und Gegenstand sind BIJEKTIV gebunden

Der Widerspruch (rest_karte_r4.md, Abschnitt C-2) lautete: schneidet die Achse {wallclock, macro,
micro} INSTRUMENTE (Beleg `measurement_tooling_registry.hpp`) oder GEGENSTAENDE (KON88-P1: "unter
`ma` je Genus-Interface, `mi` je Achsen-Microbenchmark")? Die Karte verlangt die Entscheidung im
#18-Design, sonst Owner-Vorlage. **Am Objekt (17.08.) lautet die Antwort: BEIDES -- und ohne
Konflikt, weil die Bindung compile-time erzwungen ist.**

`libs/cache_engine/mess/konfiguration.hpp:106-130` deklariert drei Instrumente, jedes mit einem
Pflichtfeld `static constexpr ms::MessEbene ebene`:

    struct Wallclock  ebene = MessEbene::Compare  kennung 'WCLK'  (:107-112)
        Doku: "die VERGLEICHS-Ebene: grobe Aussenmessung eines ganzen Laufs"
    struct Makro      ebene = MessEbene::Macro    kennung 'MAKR'  (:114-119)
        Doku: "die Batch-Ebene: EIN Paar je Batch im Hauptalgorithmus"
    struct Mikro      ebene = MessEbene::Micro    kennung 'MIKR'  (:126-130)
        Doku: "die Achsen-Ebene: EIN Paar je Achsen-Aufruf" -- und weiter, woertlich:
        "sie ist der Grund, warum die Mess-Naht am GENUS-Interface sitzt und nicht tiefer: der
        Hauptalgorithmus RECHNET NICHT, er ORCHESTRIERT Achsen."

`InstrumentConcept` (:133-139) VERLANGT das Feld `ebene`; drei `static_assert` (:141-143) erzwingen
es. `Voll = Konfiguration<Wallclock, Makro, Mikro>` (:218); `Leer = Konfiguration<>` (:215) ist
"Messung aus" als eigener TYP, kein Flag. Die Ebenen-Zugehoerigkeit ist eine Traits-Faltung
`EbeneIn<MK, E>` (:233-236). Die Gegenseite ist `enum class MessEbene { Compare, Macro, Micro }`
(builder/lager_ablage/ergebnis_mappe.hpp:206) mit den Labels "compare"/"macro"/"micro" (:208-214),
`MessEbenenSchluessel` (:231) und `mess_ebene_sheetname()` (:320).

**ENTSCHEIDUNG D-1:** `w/ma/mi` bezeichnen DREI MESS-BEREICHE. Jeder Bereich ist zugleich ein
INSTRUMENT (was einkompiliert wird) und eine GEGENSTANDS-EBENE (was gemessen wird); die Bindung ist
bijektiv und compile-time erzwungen. **Verzeichnis- und Blatt-Hierarchie tragen `MessEbene`
{compare, macro, micro}** -- und sind damit automatisch auch der Instrument-Schnitt. Es gibt hier
nichts zu waehlen; das Design stellt fest und bewacht.

**Was wirklich offen war, ist PMC -- und das faellt anders.** PMC ist KEIN viertes Instrument dieser
Liste; sie ist per `kMeasurementToolingCount = 3` compile-time geschlossen. PMC ist Meta-Meta und
erscheint nach KON88-P3 als compound-SPALTEN. Der Satz aus r4 B-03 ("E1 GEMISCHT: Wallclock UND
PMC") meint deshalb NICHT, dass das Wallclock-INSTRUMENT auf E1 laeuft, sondern dass im mi-Blatt
neben der Zeit auch PMC-Spalten stehen. Zeitquelle und Counter sind orthogonal zur Ebene und immer
SPALTEN, nie eine Pfad-Ebene. Dasselbe sagt B-18 fuer die vierte Mess-Ebene: SPALTE der Macro-Stufe.

**Damit ist r4 C-2 ohne Owner aufgeloest:** die befuerchtete Fehl-Ablage ("E1-Wallclock-Zeilen landen
unter `w` statt unter `mi`") kann nicht eintreten -- eine Zeile traegt die Ebene ihres Instruments,
und Wallclock erzeugt per `ebene = Compare` ausschliesslich Compare-Zeilen. Auch die Benennung ist
entschieden: der Code fuehrt beide Namen bereits nebeneinander -- `MeasurementTooling::WallClock`
mit id `"wallclock"` ist die TOKEN-Seite (XML + Stempel), `MessEbene::Compare` mit Label
`"compare"` ist die PFAD-/BLATT-Seite. Wer `w/ma/mi` schreibt, meint die Token-Seite.

**Die echte Gefahr liegt woanders, und dieses Design deckt sie ab (Wache K-D1):** das Tripel ist
ZWEIMAL deklariert -- `mess_axes/measurement_tooling_registry.hpp:28-34`
(`MeasurementTooling {WallClock, Macro, Micro}`, XML-Token + Stempel-Segment
`measurement_tooling=<id>@X.Y.Z`) und `mess/konfiguration.hpp:107/114/126` (die Instrument-Typen mit
`ebene`). Verbunden sind sie heute NUR ueber Namen und Ordinal: `mess_achsen_naht.hpp` indiziert die
Tooling-Menge per `static_cast<std::size_t>(cm::MeasurementTooling::Micro)` (:440), `::Macro`
(:422-423) und `::WallClock` (:502). Ein Positionstausch oder ein vierter Registry-Wert liefe still
auseinander.
- SCHNITT: eine `constexpr`-Abbildung `MeasurementTooling -> ms::MessEbene` mit `static_assert`, dass
  (a) `kMeasurementToolingCount == 3`, (b) jeder Registry-Wert genau eine `MessEbene` trifft,
  (c) die Abbildung total UND injektiv ist. Danach indiziert `mess_achsen_naht.hpp` ueber die
  Abbildung statt ueber rohe Ordinale.
- ABNAHME: Compile-Time-Negativprobe im `#error`-Muster (Vorbild B2-Gate-Trennung), Debug UND
  Release, gcc UND clang. Koeder: ein vertauschtes Paar bzw. ein vierter Registry-Wert ohne Ebene
  muss compile-time brechen, nicht zur Laufzeit.
- ZUORDNUNG: eigener Bau-Schritt **S13-30**, Reihenfolge frei, Aufwand klein.

### D-2 | Die Mappe ist der STAMM, die CSV ihr KIND (Owner 09.08. 16:31, verbatim)

Zitiert in `ergebnis_mappe_naht.hpp:17-24`: *"die csv wird doch aus der xlsx gebildet, IMMER. es
wird nur entweder xlsx oder csv oder BEIDE auf Platte gesichert, was auf dem RAM liegt ist etwas
voellig anderes."* Daraus die drei Saetze, die der Bestand schon traegt: (1) die Mappe entsteht
IMMER im Speicher; (2) eine Zeile erreicht die CSV nur, wenn der Stamm sie angenommen hat;
(3) `<writeback_methods>` entscheidet allein die PERSISTENZ.

**Heute ist (2) NICHT erfuellt** -- der rohe `std::ofstream csv` (experiment_run_entry.hpp:256)
laeuft neben der Mappe her, nicht unter ihr. S13-01 stellt (2) her.

### D-3 | Ein Schema-Zug, additiv, kein Bump

Alle XSD-Aenderungen des Buendels gehen in EINEN Commit (Abschnitt 5). Alle neuen Elemente sind
`minOccurs="0"` und werden ans ENDE der jeweiligen Sequenz gehaengt; Bestands-XMLs bleiben
byte-unveraendert valide, `version` des Wurzelelements bleibt v2. Haus-Muster: XSD prueft STRUKTUR,
`validate_profile.hpp` prueft HART und fail-loud (verifiziert 17.08.: validate_profile.hpp:1164-1177
traegt den {local,minio}-Enum, die XSD nur `xs:string`).

### D-4 | Der Lager-Baum bleibt EIN Writer mit ZWEI Realms

r5 A41 (Owner): *"beide verwenden exakt denselben Baum"*, *"Eine wurzel binaries, eine wurzel
measurements"*. Die abweichende Ebenen-Reihenfolge je Realm (D-12: Messdaten MESS->SYSTEM->ORGAN,
Binaries SYSTEM->ORGAN->MESS) ist die Detail-Pattern-Differenz und KEIN Defekt. Bau- und
Messfortschritt sind ZWEI getrennte Praefix-Zaehler (`kompiliert`/`gemessen`) und duerfen nicht
vermischt werden -- sie zaehlen zwei DURCHLAEUFE, nicht zwei Sichten auf einen.

### D-5 | Was das Buendel NICHT anfasst: golden-Bytes

Das golden-Fenster ist am 16./17.08. gelandet (#16, ce 90ee6809 -> 04ac26fa, CI 15937). Das
S-13-Buendel ist NICHT golden-brechend und darf es nicht werden: der Ziel-Filter aendert die
PERSISTENZ, nicht die ZEILEN. Wo eine Aenderung Byte-Wirkung haette (Spaltenmenge, Header), steht
sie in Abschnitt 8 als ausdruecklich ausgeschlossen oder unter Reihenfolge-Zwang zum #15-Bruch.

--------------------------------------------------------------------------------------------------

## 3. IST AM OBJEKT -- 17.08.2026, ce @ 04ac26fa

    Gegenstand                              Stand      Fundstelle / Befund
    --------------------------------------- ---------- --------------------------------------------
    Ergebnis-Mappen-Schicht (A9-S3)         DA         ergebnis_mappe.hpp, 645 Z., 13 top-level-Typen
    xlsx-Backend als eigene TU              DA         xlsx_ergebnis_writer.cpp + Target
                                                       comdare_lager_ablage, PRIVATE-Vendor-Link
    Vendor libxlsxwriter                    DA         ext/io/libxlsxwriter (A9-S1, 351205f5)
    Naht Lauf -> Mappe (A9-S5)              DA         ergebnis_mappe_naht.hpp, 730 Z.
    Naht produktiv verdrahtet               DA         profile_facade/CMakeLists.txt:101 (PFLICHT,
                                                       ODR-Use) | experiment_run_entry.hpp:267-270
    Format-Wahl aus writeback_methods       DA         waehle_ergebnis_format() naht:201, FormatWahl
                                                       :150, FormatLage :144, TokenSorte :123
    Mess-Report-CLI (A9-S4)                 DA         tools/mess_report/{main.cpp, render, realm_scan,
                                                       skip_manifest, dynamic_axis_filter}
    WritebackMethod::Xlsx                   DA         writeback_method_registry.hpp:34, Count=4
    31-Zeichen-Wache                        DA         ergebnis_mappe.hpp:268/:275
    Zeilenlimit 1'048'576                   DA         ergebnis_mappe.hpp:340/:346
    ErgebnisSchreibFehler                   DA         ergebnis_mappe.hpp:246
    INFO-Blatt-Bausteine                    DA         :310 kInfoBlattName, :122 MaschinenSysinfo
    MessEbene (Gegenstands-Ebene)           DA         ergebnis_mappe.hpp:206 + :231 + :320
    Instrument -> MessEbene, CT-gebunden    DA         mess/konfiguration.hpp:107/114/126,
                                                       InstrumentConcept :133, 3 static_assert :141
    Checkpoint {In,Out}                     DA         ergebnis_mappe.hpp:218
    Mess-/Kaskaden-Schicht                  DA         libs/cache_engine/mess/ (6 Header)
    ZWEI Arenen (append + LIFO)             DA         measure_storage/mess_arena.hpp (313 Z.) +
                                                       stapel_arena.hpp (277 Z.)
    CheckpointMeasure + Deskriptor-Index    DA         checkpoint_measure.hpp:197 / :245
    UeberlaufBefund (mit Nenner)            DA         checkpoint_measure.hpp:139 / :144;
                                                       mess_arena.hpp:213 kUeberlaufSlot, :266
    Zwei getrennte Fehlerklassen je Arena   DA         checkpoint_measure.hpp:132,
                                                       checkpoint_speicher.hpp:18
    Kapazitaets-Rechnung (constexpr)        DA         checkpoint_speicher.hpp:131;
                                                       planner_mengen_types.hpp:157/:181/:332
    Arena-Abnahme-Tests                     DA         test_ck1_messkette_koeder.cpp (455 Z.),
                                                       test_ms1_arenen_kein_alloc_im_fenster.cpp
                                                       (1443 Z.), test_ms2_pre_touch_... (236 Z.)
    Lager-Pfad-Grammatik (LB-0)             DA         test_lb0_lager_pfad_grammatik.cpp, 39 TESTs
    Knoten-/Heuristik-Log (LB-1)            DA         test_lb1_knoten_heuristik_log.cpp, 26 TESTs
    Lager-Baum-Writer, EIN Writer 2 Realms  DA         builder/bestandslog/lager_baum_writer.hpp
                                                       (945 Z.): LagerRealm :101, LagerRealmPolicy
                                                       :688, MessdatenRealmPolicy :693,
                                                       BinariesRealmPolicy :732, 3 static_assert
                                                       :782-784, LagerBaumWriter<Policy> :869
    B-08 ZWEI WURZELEBENEN Gattung->Genus   DA         lager_baum_writer.hpp:14-20 -- Ebene 1
                                                       gattung, Ebene 2 genus, Ebene 3 realm;
                                                       Owner verbatim: "Binary-Ordner und
                                                       Messung-Ordner branchen unter Gattung->
                                                       Genus->Binary/Messung"; consteval-Wurzel-
                                                       Wache (:60) bricht den BAU bei fehlendem
                                                       Lager-Token
    Ebenen je Realm ausgeschrieben          DA         Messdaten 11 Ebenen (:33-40), Binaries
                                                       7 Ebenen mit Mess-Typ als tiefstem Knoten
                                                       (:42-48) = D-12, bestaetigt
    Hybrid als regulaere Gattung+Genus      DA         K1 (09.08.) hob das "hybrid"-Token-Verbot
                                                       auf (:57, :443-446)
    --------------------------------------- ---------- --------------------------------------------
    Arena-Deckel 6 GB (KON93-C6)            FEHLT      Kapazitaet wird aus der Last GERECHNET, nicht
                                                       gedeckelt; Gegenprobe "6 GB|6GB|6144" ueber
                                                       measure_storage/ + mess/ = 0 Treffer
    ram_warn / ram_oob (XML, B-03)          FEHLT      0 Treffer im ganzen Baum (ohne build/)
    Thread-SLOT-Vergabe + Obergrenze        FEHLT      thread_nr existiert als uint16_t
                                                       (mess_arena.hpp:94, stapel_arena.hpp:81),
                                                       aber keine Slot-Vergabe: Gegenprobe
                                                       "slot|kMaxThread|max_threads" ueber
                                                       mess/*.hpp = 0 Treffer
    LB-2..LB-6 eigene Test-TU               FEHLT      `ls tests/unit/test_lb*` = genau 2 Dateien
                                                       (lb0, lb1)
    Planer-Blattfunktion im Baum-Writer     FEHLT      VERIFIZIERT 17.08.: "planner", "planer" und
                                                       "plan_" je 0 Treffer in
                                                       lager_baum_writer.hpp (945 Z.)
    CEB-Vollplatzierung                     HALB       nur 2 Treffer: der Praefix-Kommentar (:47)
                                                       und ceb_blatt_ebenen(Spec) (:770)
    Roher CSV-Strom als KIND der Mappe      FEHLT      experiment_run_entry.hpp:256 schreibt
                                                       unabhaengig; Naht-Kopf :13-15 sagt es selbst
    Ziel-FILTER (Persistenz-Wirkung)        HALB       Format-Wahl gebaut; der rohe Strom ignoriert
                                                       sie -> Ebene-C-Kanal bleibt unbedingt
    per-Binary-xlsx                         FEHLT      heute je Binary eine result.csv
    ergebnis_dateiname.hpp                  FEHLT      Gegenprobe: 0 Treffer ausserhalb build/.git
    XSD-Enum-Wache <method value=...>         FEHLT      experiment_schema.xsd:294-298 (run_methodology)
                                                       und :313-317 (writeback_methods): beide
                                                       `xs:string use="required"`, KEINE Enumeration
    <export>/<publish>-Element              FEHLT      OutputType (xsd:665-680) kennt nur
                                                       binary_path/csv_path/latex_path/
                                                       comparison_metrics/storage
    B5 XML-Trennung Bau/Mess                FEHLT      nur Env-Asymmetrie im Planer-Emitter:
                                                       COMDARE_GOLDEN_N_PROVISION_ONLY gesetzt bei
                                                       experiment_plan_director.hpp:1529/:1739/
                                                       :2047/:2104, bewusst weggelassen :1589/:2109;
                                                       experiment_golden_kern.xml:270 sagt woertlich
                                                       "Diese XML deklariert also die BAU-Menge, der
                                                       Planer die MESS-Menge."
    B3 Host-Belegung (Ebene 1)              FEHLT      `grep -c batch_plan_datei
                                                       Code/02_messung_driver/main.cpp` = 0
                                                       => PlanPersistenz inert im Trigger-Lauf
    xlsx im super-Pipeline-Rohr             FEHLT      `grep -rl xlsx` ueber Code/01..09 = 0 Treffer
                                                       => alles faellt auf CSV zurueck
    measure_to_latex (B-07-Migration)       FEHLT      0 Treffer; `csv_to_latex` hat 9 benannte
                                                       Konsumenten in Code/CMakeLists.txt +
                                                       .gitlab-ci.yml => echte Migration
    Sheets im super                         FEHLT      0 Treffer "Sheet|Blatt" in 07_/08_
    AF_BRANCH XML-erreichbar                FEHLT      .gitlab-ci.yml:2660 `AF_BRANCH="development"`
                                                       hart; Kern parametrierbar
                                                       (ci/anhang_forward_core.sh:308)
    E-18 auf CI_JOB_TOKEN                   FEHLT      anhang:forward (.gitlab-ci.yml:2584) verlangt
                                                       ZWEI PAT-Paare (:2614 289-PAT id=98, :2619
                                                       288-PAT id=54)

Die Flaechen G (Lager LB-2..LB-6) und B (Arena-Detailposten E1-E11) werden in 4.2 und 4.7 je
Einzelposten aufgeschluesselt; wo dort "IST unverifiziert" steht, ist das eine ausgewiesene
Nicht-Deckung dieses Dokuments und KEINE Behauptung.

--------------------------------------------------------------------------------------------------

## 4. POSTEN -> BAU-SCHRITT-MATRIX

Legende je Schritt: **IST** (am Objekt, Datum) | **LUECKE** | **SCHNITT** (was gebaut wird) |
**ABNAHME** (Designplan-Pflicht + Koeder) | **REIHENFOLGE** (Zwang).

### 4.1 FLAECHE A -- #18-Kern

**S13-01 | Der rohe CSV-Strom wird KIND der Mappe**
- IST (17.08.): `experiment_run_entry.hpp:256` oeffnet `std::ofstream csv{a.out_csv,trunc}` und
  schreibt in :272-284 parallel zur Mappe aus derselben In-Memory-Quelle. Der Naht-Kopf erklaert das
  ausdruecklich als Zwischenstand (naht:13-15).
- LUECKE: Owner-Satz D-2(2) ("eine Zeile erreicht die csv NUR, wenn der Stamm sie angenommen hat")
  ist nicht durchgesetzt. Bricht die Mappe, entsteht heute trotzdem eine vollstaendige CSV.
- SCHNITT: die CSV-Ausgabe wird zur Projektion der Mappe. `MappenNaht` bekommt
  `schreibe_csv_projektion(pfad)`; `emit` schreibt NUR noch in die Mappe; die CSV entsteht am
  Lauf-Ende (bzw. inkrementell) aus dem Stamm. Fehler im Stamm => KEINE CSV, Exit != 0.
  Die Schwesterstelle `profile_run_entry.hpp` bekommt denselben Schnitt (T-6-Regel: derselbe Fix an
  BEIDEN Naehten).
- ABNAHME: T-11c-Mutation je Naht; Koeder: eine Fassung, die bei `ErgebnisSchreibFehler` trotzdem
  eine CSV zuruecklaesst, wird ROT. Zusatz-Probe: golden-CSV byte-identisch vor/nach dem Umbau
  (die Zeilen aendern sich nicht, nur ihr Weg).
- REIHENFOLGE: VOR S13-02 und S13-03. Nach dem golden-Fenster (#16, erledigt).

**S13-02 | Ziel-Filter scharf: `<writeback_methods>` entscheidet die Persistenz**
- IST: `waehle_ergebnis_format()` (naht:201) wertet die Token aus und liefert `FormatWahl`
  (:150) / `FormatLage` (:144); `mappe.ziele()` nennt sie. Der rohe Strom liest sie nicht.
  11 getrackte Profile: 8 mit `<writeback_methods>` und `csv`, 3 ohne Block, 0 mit `xlsx`
  (Zaehlung im Naht-Kopf :36-39, am Bestand nachgemessen).
- LUECKE: KON32-01 (Owner) -- der `measurement_sink`-Kanal ist unbedingt. Deklariert ein Profil nur
  `xlsx`, entsteht trotzdem eine CSV; deklariert es nur `csv`, entsteht trotzdem die Mappe auf
  Platte (die Mappe im RAM soll bleiben -- das ist D-2(1) und richtig).
- SCHNITT: EIN Filter-Punkt. `FormatWahl` steuert ausschliesslich die PERSISTENZ-Aufrufe; die
  In-Memory-Mappe bleibt bedingungslos. Kein zweiter stiller Kanal daneben (Wache W5 des
  publish-Vorschlags). Default bei fehlendem Block: `xlsx` (Owner-KERN 26.07., im Naht-Kommentar
  :265-267 bereits so festgehalten).
- **ZWEI FOLGEWIRKUNGEN, benannt statt uebersehen (A2.5-Fix 17.08., Fund 12):**
  **(1) Der FEHLEND-Fall trifft drei Bestands-Profile.** Am Objekt (Naht-Kopf :36-38):
  11 getrackte Profile, davon **3 ganz OHNE `<writeback_methods>`** -- namentlich `base_pilot`,
  `m3v2_smoke`, `wdk_fairness_example`. Mit Default-xlsx verlieren genau diese drei ihre CSV.
  Kein golden-Byte-Bruch (golden traegt einen Block), aber ihre Konsumenten sind NICHT erhoben.
  **Auflage vor dem Bau:** je Profil erheben, wer seine CSV liest (CI-Job, Test, Skript); ergibt
  sich ein Leser, bekommt das Profil einen expliziten `csv`-Block, statt den Default zu drehen.
  Die Abnahme bekommt einen VIERTEN Fall: "Block fehlt" an einem echten Bestands-Profil.
  **(2) Der Projektions-Scope ist zu definieren.** Wenn S13-09 die gedrainten Arena-Zeilen in den
  Mappen-Stamm legt und die CSV eine Projektion des Stamms ist (D-2), muss festgelegt sein, WELCHE
  Blaetter die golden-CSV-Projektion speisen. Sonst faengt erst der Byte-Identitaets-Koeder aus
  S13-01 den Arena-Zeilen-Zufluss -- als Ueberraschungs-Rot am Bau-Tag.
  **FESTLEGUNG:** die CSV-Projektion speist sich AUSSCHLIESSLICH aus den Ergebnis-Blaettern
  (Zeile pro Messergebnis, `SheetSchluessel`), NIE aus den Profil-Blaettern
  (`MessEbenenSchluessel`, Zeile pro Aufruf). Die Arena-/Checkpoint-Zeilen aus S13-09 landen in der
  Profil-Familie und damit NICHT in der golden-CSV. Begruendung: die golden-CSV ist die
  Mess-ERGEBNIS-Tabelle; Aufruf-Profile sind eine andere Beobachtung mit anderer Zeilen-Semantik.
- ABNAHME: vier Faelle mit literalem Verzeichnis-Listing: nur-csv / nur-xlsx / beide / Block fehlt
  (an einem der drei genannten Bestands-Profile). Koeder je Fall: eine Fassung, die die
  nicht-deklarierte Datei doch schreibt, wird ROT. Zusatz-Koeder zur Scope-Festlegung: eine
  Profil-Blatt-Zeile, die in der golden-CSV auftaucht, wird ROT. T-11c-Mutation.
- REIHENFOLGE: nach S13-01. Vor S13-09 (die Scope-Festlegung ist die Vorbedingung des Drains) und
  vor S13-27 (publish liest denselben Filter).

**S13-03 | per-Binary-xlsx statt 320 Einzel-CSVs -- MIT Resume-Vertrag**
*(A2.5-Fix 17.08., Fund 4 -- MUSS. Die erste Fassung nannte die produktiven result.csv-Konsumenten
nicht; ein Nur-xlsx-Profil haette Resume, Status und Drop-Kanal blind gemacht.)*
- IST (17.08., am Objekt nachgemessen -- der A44-Anker war gewandert, hier die HEUTIGEN Stellen in
  `libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp`, 3336 Z.):
  bei per-Binary-Ablage bekommt JEDE Tier-Binary ihr eigenes `result.csv` im eigenen Unterordner
  (Schreibstellen `:3101` `result.csv` und `:3110` `result.csv.stamp`); dazu die aggregierte
  `measurements.csv`. Bei 320 Binaries sind das 320 Einzeldateien plus Aggregat.
  **UND: diese Datei ist kein blosses Ausgabe-Artefakt, sondern ein VERTRAG an drei Stellen:**

      Resume-Arbiter   :318-320  "per-Binary result.csv+stamp-Naht (T2-A/K2)";
                       :1364     lazy_try_resume_binary(dir, stamp_prefix, out_rows) prueft
                                 dir/result.csv + dir/result.csv.stamp auf Stamp-Match +
                                 Header-Identitaet + Zeilenzahl -- jede Abweichung => false
      measure-drop     :3170-3172 cfg.measurement_sink(rcsv, <stem>/result.csv) -- Ebene C nimmt
                                 den PFAD der result.csv entgegen
      Planer-Status    planner_status_types.hpp:33-35  kResultCsvName = "result.csv",
                                 kResultStampName = "result.csv.stamp",
                                 kResultStaleName = "result.csv.stale"

- LUECKE: KON32-01 Owner woertlich "nur per Binary xlsx"; die Toleranz (a) endet mit (c). Wuerde
  S13-02 die CSV-Erzeugung eines Nur-xlsx-Profils unterbinden, verloeren Resume, Status-Bericht und
  Drop-Kanal ihre Grundlage -- ohne dass irgendetwas rot wuerde. Das ist genau die Klasse Defekt,
  die dieses Buendel beheben soll, nur an anderer Stelle.
- SCHNITT -- **ENTSCHEIDUNG: `result.csv`+`.stamp` sind ein RESUME-VERTRAG und stehen AUSSERHALB des
  Ziel-Filters.** Begruendung: der Filter regelt die AUSGABE an den Anwender (`<writeback_methods>`
  = "was auf die Platte geht" fuer die Auswertung); der Resume-Vertrag ist BETRIEBSZUSTAND der
  Mess-Maschine, kein Auswerte-Format. Zwei Dinge, die zufaellig dasselbe Dateiformat benutzen.
  Konkret:
  (a) je Binary EINE Ergebnis-Mappe ueber dieselbe `ErgebnisMappenFactory` (der xlsx-Teil von
      KON32-01), Datei-Name aus S13-17;
  (b) `result.csv` + `result.csv.stamp` werden WEITERHIN und BEDINGUNGSLOS geschrieben -- sie sind
      vom Filter ausgenommen und tragen einen Kommentar, der genau das sagt (sonst entfernt sie der
      naechste Leser als "vom Filter vergessen");
  (c) die AUSWERTE-CSV je Binary (die, die der Anwender bekommt) ist die Projektion aus S13-01 und
      faellt unter den Filter. Sie ist NICHT dieselbe Datei wie der Resume-Vertrag und darf ihn
      nicht ueberschreiben -- Namens-Trennung ueber S13-17.
  **Alternative, bewusst NICHT gewaehlt:** Stamp/Resume auf die Mappe umstellen. Das waere sauberer,
  zieht aber `lazy_try_resume_binary`, den measure-drop-Kanal und `planner_status_types` in EINEN
  Umbau mitten vor dem Trigger -- zu breit fuer diesen Slot. Als W3-Nachfolgeposten vermerkt.
- ABNAHME: Zaehl-Test N Binaries => N Mappen + 1 Aggregat-Mappe. **Zusaetzlich, Fund-4-Abnahme:**
  Koeder 1 -- ein Nur-xlsx-Profil, nach dem `lazy_try_resume_binary` keinen Wiederanlauf mehr
  findet, wird ROT. Koeder 2 -- ein Lauf, nach dem `measurement_sink` keine `result.csv` mehr
  gereicht bekommt, wird ROT. Koeder 3 -- eine Auswerte-CSV, die den Resume-Vertrag ueberschreibt,
  wird ROT. Positivprobe: Nur-xlsx-Profil, Lauf abbrechen, Wiederanlauf resumiert literal.
- REIHENFOLGE: nach S13-01/-02, vor S13-14 (Blattzahl-Formel setzt die Mappen-Menge voraus) und
  vor S13-17 (die Namens-Trennung (c) gehoert in die Grammatik).

**S13-04 | Export-Element (KON27-02 Option b) + vier ct-gesicherte Rueckschrieb-Methoden**
- IST: `OutputType` (xsd:665-680) kennt `binary_path`, `csv_path`, `latex_path`,
  `comparison_metrics?`, `storage?`. Kein Export-/Ziel-Element. Die vier Methoden existieren
  ct-gesichert in `writeback_method_registry.hpp` (Count=4 seit A9-S3).
- LUECKE: die XML kann die vier Methoden nicht je ZIEL adressieren; PDF ist ausdruecklich draussen
  (KON27-02 + KON23-03).
- SCHNITT: `<export>` als additives Kind von `OutputType`, ans Sequenz-Ende, `minOccurs="0"`.
  Inhalt: je `<target>` eine Rueckschrieb-Methode + Ziel-Klasse. Der Validator prueft die Methode
  gegen `kWritebackMethodRegistry` (Single-Source) und die Klassen-Methoden-Matrix. Default-Doktrin
  B-15: `constexpr`-Defaults im Code, XML ueberschreibt temporaer.
- ABNAHME: Additivitaets-Probe (alle Bestands-XMLs validieren unveraendert) + Koeder-XML mit
  unbekannter Methode => ROT in Debug UND Release, gcc UND clang.
- REIHENFOLGE: gemeinsam mit S13-19 und S13-27 in EINEM Schema-Zug (D-3).

### 4.2 FLAECHE B -- Arena / Checkpoint-Kette E1-E11

Vorbemerkung -- **die Kette ist weit ueberwiegend GEBAUT**, und zwar mit den Owner-Auflagen bereits
eingearbeitet. Am Objekt (17.08.) liegt unter `libs/cache_engine/builder/measure_storage/`
(1207 Zeilen in 5 Dateien):

    checkpoint_measure.hpp  318 Z.  Kopf woertlich: "DAS ZENTRALE MESSINSTRUMENT DES SYSTEMS
                                    (Owner-KERN 09.08.2026)". CheckpointMeasure<MK> (:197),
                                    ProzessAnker (:94), MessMasse (:121), zeit_ticks_jetzt() (:79),
                                    FlushBefundMess (:138) / FlushBefundStapel (:153).
                                    Der Aufnahme-Aufruf lautet
                                    checkpoint(std::uint32_t deskriptor_ix, std::uint64_t messwert,
                                               std::uint16_t thread_nr) (:245) -- also ein
                                    DESKRIPTOR-INDEX, keine ausgeschriebene Achsen-Kette.
    checkpoint_speicher.hpp 140 Z.  kapazitaet_zeilen_rechnen(...) constexpr (:131) +
                                    KapazitaetRechnung; Kopf :18 woertlich: "UEBERLAUF ist ein
                                    FEHLERKLASSEN-Unterschied: volle Mess-Arena = Datenverlust;
                                    voller Stapel = [Programmierfehler]".
    mess_arena.hpp          313 Z.  die APPEND-Arena; kUeberlaufSlot (:213) und die
                                    Kapazitaets-Pruefung (:266) -- Ueberlauf gibt einen Slot
                                    zurueck, er blockiert NICHT.
    stapel_arena.hpp        277 Z.  die LIFO-/Stapel-Arena (ZWEITE Arena, B-05).
    mess_speicher_kanon.hpp 159 Z.  Kanon; Selbstcheck :5 "enthaelt KEINE Arena, KEINEN Zaehler und
                                    KEINE Ueberlauf-Politik".

Dazu die Abnahme-Tests: `test_ck1_messkette_koeder.cpp` (455 Z.) nimmt laut eigenem Kopf genau die
B-06-Kausalkette ab -- variadische Mess-Template-Variable durch die Gattung+Genus-Kaskade -> Kanal
kommt im Tier-Binary an -> `init()` beider Arenen beauftragbar -> `flush()` JE ARENA getrennt
beauftragbar -> Signale am Pruefdock. `test_ms1_arenen_kein_alloc_im_fenster.cpp` (1443 Z.) belegt
die Allokations-Freiheit im Fenster mit einer eigenen Observablen (operator-new-Zaehler),
`test_ms2_pre_touch_seitenfehler.cpp` (236 Z.) die Vorab-Beruehrung mit `ru_minflt`.

**Damit sind B-05 (ZWEI Arenen, getrennte Fehlerklassen, Allokations-Verbot), B-06 (Ursache-Kette)
und T-12c(4) (Deskriptor-Index statt Achsen-Kette) IN DER SUBSTANZ GEBAUT.**

> **KORREKTUR 17.08.2026 (A2.5-Fix-Runde, Fund 1 -- MUSS).** Die erste Fassung dieses Abschnitts
> zaehlte auch **T-12c(3) (Ueberlauf = BEFUND, weiterlaufen+zaehlen+melden)** zum gebauten Bestand
> und schnitt S13-07 nur als Auswerte-Wache. **Das ist falsch, und zwar nicht am Code, sondern am
> MASSSTAB.** Die juengere Owner-Linie kehrt die Semantik um. Ledger verbatim (KON93-02-Einordnung,
> von mir am Original nachgelesen):
>
>     "Der Ueberlauf-Pfad bleibt per P2-Wort: harter Abbruch NUR wenn die Mess-Arena voll ist;
>      das heute gebaute 'Ueberlauf zaehlen+weitermessen' (mess_arena.hpp:36-38,213,266) ist in
>      dieser Lesart zu heilen (stiller Datenverlust)."
>
> und KON94-02, Schicht (3): *"Kapazitaet 6GB STATISCH je MESS-PROZESS-Arena, voll = harter Abbruch
> (KON93; Abbruch-Semantik per Bestands-Doktrin: failed ohne Retry, Arena-Bestand persistieren)"*,
> dazu die Delta-Zeile: *"7 DELTAS: Kern = Ueberlauf zaehlen+weitermessen ... heilen auf
> fest+Abbruch"*. Der Ledger fuehrt den Posten bereits benannt: **E5 "Folgeblatt statt Wurf"** und
> die Ueberlauf-Heilung stehen in der E1-E10-Bauliste.
>
> **RANGFOLGE OWNER > PLAN.** Der Designplan-Par.12-Wortlaut zu T-12c(3) ("weiterlaufen") traegt
> dieselbe ueberholte Lesart; er ist damit selbst ueberholt. Dieses Design fasst den Designplan
> NICHT an -- der UEBERHOLT-Marker dort ist ein eigener Zug (VL-5, Lead). Hier gilt ab sofort die
> Owner-Semantik, und S13-07 wechselt vom "Wache nachziehen" zum **Umbau-Posten**.

Es bleiben damit VIER echte Luecken: die 6-GB-Doktrin, die **Abbruch-Semantik** (neu), die
Thread-Slot-Obergrenze und die XML-Schalter.

**S13-05 | E11 Arena-Kapazitaet: 6 GB FEST/STATISCH gegen die heutige Rechnung**
- IST (17.08., verifiziert): die Kapazitaet wird GERECHNET, nicht gesetzt --
  `kapazitaet_zeilen_rechnen(n_ops, zeilen_je_op, drift_faktor)` (`checkpoint_speicher.hpp:131`,
  `constexpr`), der Planer NIMMT die Zahl und raet sie nicht
  (`mess/pilot_suche_impl.hpp:198`, `builder/measure_storage/checkpoint_measure.hpp:119`), die
  Planer-Seite fuehrt sie als `zeilen_je_op_batch` (`planner/planner_mengen_types.hpp:157`) mit
  eigener Ueberlauf-Wache VOR dem Aufruf (:332), weil die Funktion drei Faktoren ungewacht
  multipliziert (:181). Eine 6-GB-Konstante existiert NICHT (Gegenprobe: `grep "6 GB|6GB|6144"` ueber
  `measure_storage/` und `mess/` = 0 Treffer).
  `ram_warn` / `ram_oob` = **0 Treffer im gesamten Baum** (Gegenprobe ohne `build/`) -- die
  B-03-XML-Schalter existieren nicht.
- LUECKE: KON93-C6 setzt die Arena auf **6 GB FEST/STATISCH**, Planer-Reservierung nur zu
  Experiment-Beginn aenderbar. Die heutige Rechnung ist damit nicht falsch, aber sie ist ein
  ANDERES Objekt: sie bemisst die ZEILENZAHL aus der Last, KON93-C6 deckelt den SPEICHER.
- SCHNITT: eine `constexpr` Kapazitaets-Obergrenze (6 GB) tritt NEBEN `kapazitaet_zeilen_rechnen` und
  deckelt deren Ergebnis; ueberschreitet die Rechnung den Deckel, ist das ein BEFUND am
  Planer-Dock (Deckelurteil VOR Messstart), kein stilles Kuerzen. Die Planer-Reservierung zu
  EXPERIMENT-BEGINN bleibt der einzige Freiheitsgrad -- kein Wachsen zur Laufzeit.
  **DREI SCHICHTEN AN ZWEI SPEICHERN (KON94-02, nicht vermengen):** (1) Warnschwelle 6 GB
  delayed-informativ am CEB-AGGREGAT (KON51/52, bleibt) | (2) OOB-Opt-in hart am CEB (KON52,
  bleibt -- dort ist OOB GENAU das Fertig-Signal, kein Fehler) | (3) Kapazitaet 6 GB STATISCH je
  MESS-PROZESS-Arena, voll = harter Abbruch (S13-07). Die 6 GB SCHICHTEN sich ueber die
  KON51-Warnschwelle, sie loesen sie NICHT ab -- als Abloesung waere die Warnung unerreichbar.
  XML-Schalter: siehe **X-4** in Abschnitt 5 (Element `<mess_speicher>`, Fund-7-korrigiert).
  Die x5-Retry-Klammer (#13/T-15b) muss den Deckel ZUSAETZLICH decken (KON26-04) -- und darf den
  Arena-voll-Abbruch NICHT wiederholen (S13-07 Koeder 3).
- ABNAHME: **T-12c(1)** -- Koeder: Laufzeit-Resize wird ROT; zweiter Koeder: eine Rechnung ueber dem
  Deckel, die still kuerzt statt zu melden, wird ROT; dritter Koeder: eine Fassung, die Schicht (1)
  durch Schicht (3) ERSETZT (Warnung unerreichbar), wird ROT.
- REIHENFOLGE: **nach dem Schema-Zug** (X-4 traegt die Reservierungs-Groesse) und vor #13 (T-15b)
  ODER mit ihm im selben Mess-Fenster Sa/So 22./23.08.; binary-beruehrend, also VOR dem Trigger.
  S13-05 vor S13-07 (der Deckel ist der Abbruch-Ausloeser).

**S13-06 | Virtuelle Thread-Slots, Obergrenze = Thread-Unterachse**
- IST (17.08., verifiziert): `thread_nr` ist als `std::uint16_t` in BEIDEN Arenen gefuehrt
  (`mess_arena.hpp:94` mit dem Vermerk "bleibt im Satz, auch wenn Measure 1-Faden ist
  (Debug=parallel)", `stapel_arena.hpp:81`) und wird als Parameter durchgereicht
  (`checkpoint_measure.hpp:245`, :250, :265). Eine SLOT-VERGABE oder Obergrenze existiert nicht
  (Gegenprobe: `grep "slot|Slot|kMaxThread|max_threads"` ueber `mess/*.hpp` = 0 Treffer; in
  `measure_storage/` trifft nur `kUeberlaufSlot`, ein anderer Gegenstand).
- LUECKE: Owner-Entscheid r5 A9: *"Thread Nummer wird geloest, indem zu Beginn virtuelle Thread
  slots (maximale die Anzahl der Thread Unterachse) formal zugewiesen wird [...] Ein int tut es."*
  Obergrenze compile-time bekannt, Puffer statisch, keine Allokation/Sperre. Ausdruecklich als
  Fehlerklasse gefordert: mehr Threads als Slots = LAUTER Fehlerfall, kein Wrap-around.
- SCHNITT: `kThreadSlots` aus der Thread-Unterachse (CT); Slot-Vergabe zu Beginn; die vorhandene
  `thread_nr` wird zur SLOT-Nummer statt zu einer freien Zahl; Ueberschreitung = laute Fehlerklasse
  in derselben Familie wie `FlushBefundStapel` (Programmierfehler, nicht Datenverlust).
- ABNAHME: **T-12c(2)** -- Koeder: Slot-Ueberschreitung ohne LAUTEN Fehler wird ROT.
- REIHENFOLGE: mit S13-05.

**S13-07 | Ueberlauf-Semantik UMBAUEN: von "zaehlen+weitermessen" auf HARTEN ABBRUCH**
*(A2.5-Fix 17.08., Fund 1 -- der Posten war vorher als reine Auswerte-Wache geschnitten und ist
hiermit zum Umbau-Posten aufgewertet.)*
- IST (17.08., verifiziert): der Ueberlauf ist als BEFUND gebaut und laeuft WEITER.
  `UeberlaufBefund` traegt "Kapazitaet, Versuche, belegt, verloren -- mit Nenner"
  (`checkpoint_measure.hpp:139`); `FlushBefundMess::vollstaendig()` ist
  `senke_bedient && !befund.hat_verlust()` (:144); die Arena blockiert nicht, sondern gibt
  `kUeberlaufSlot` zurueck (`mess_arena.hpp:213`, Kapazitaets-Pruefung :266); die beiden Arenen
  tragen VERSCHIEDENE Fehlerklassen (`checkpoint_measure.hpp:132`, `checkpoint_speicher.hpp:18`:
  volle Mess-Arena = Datenverlust, voller Stapel = Programmierfehler).
- LUECKE: **das Weiterlaufen selbst.** Owner-Linie (KON93-02/KON94-02, P2-Wort 16.08.): volle
  Mess-Arena = HARTER ABBRUCH, `failed` OHNE Retry, Arena-Bestand PERSISTIEREN. Das gebaute
  Zaehlen+Weitermessen ist im Ledger woertlich als "stiller Datenverlust" benannt und als
  Kern-Delta "heilen auf fest+Abbruch" gefuehrt. Zusaetzlich weiterhin offen: **T-12c(5)**, die
  IN-ohne-OUT-Invariante je (Prozess, Thread, Interface) als Auswerte-Wache (r5 A12/N-6) -- der
  O(n)-Vorwaerts-Durchlauf mit je einem offenen Stapel pro Ebene liefert sie als Nebenprodukt
  (r5 A6/C-9); eine woertliche Rueckwaertssuche waere quadratisch.
- SCHNITT, drei Teile:
  (a) **Abbruch statt Weiterlauf.** Erreicht die Mess-Arena ihre Kapazitaet, bricht der Mess-Prozess
      ab: Status `failed`, KEIN Retry (die Retry-Klammer aus #13/T-15b darf diesen Fall nicht
      wiederholen -- ein zweiter Lauf traefe dieselbe Wand), und der bis dahin gefuellte
      Arena-Bestand wird VOR dem Abbruch persistiert (sonst tauscht man stillen Datenverlust gegen
      lauten Totalverlust).
      Die STAPEL-Arena behaelt ihre eigene Fehlerklasse (Programmierfehler) -- der Abbruch gilt
      der MESS-Arena; die Trennung der zwei Klassen (checkpoint_speicher.hpp:18) bleibt.
  (b) **`UeberlaufBefund` bleibt und wird zum Abbruch-Protokoll.** Die Felder (Kapazitaet,
      Versuche, belegt, verloren) sind genau die Zahlen, die der Abbruch melden muss. Nicht
      loeschen -- umwidmen.
  (c) **T-12c(5)-Auswerte-Wache** wie bisher geplant, plus Legenden-Zeile im INFO-Blatt (Flaeche D).
- ABNAHME: Koeder 1 -- eine Fassung, die bei voller Mess-Arena WEITERMISST, wird ROT (das ist der
  Gegen-Koeder zum heutigen Bestand und der Beweis, dass der Umbau greift). Koeder 2 -- ein Abbruch,
  der den Arena-Bestand NICHT persistiert, wird ROT. Koeder 3 -- ein Retry auf den Arena-voll-Fall
  wird ROT. Koeder 4 (T-12c(5)) -- ein IN-Ueberhang, der die Auswertung passiert, wird ROT.
  T-11c-Mutation je Koeder.
  **Achtung Abnahme-Konflikt:** der Designplan-Par.12-Text zu T-12c(3) verlangt heute das Gegenteil
  ("weiterlaufen + zaehlen"). Er ist per Rangfolge OWNER > PLAN ueberholt; der UEBERHOLT-Marker
  dort ist ein FREMDER Zug (VL-5, Lead) und NICHT Teil dieses Buendels. Wer am Di 25.08. baut,
  folgt der Owner-Semantik.
- REIHENFOLGE: mit S13-05 (der Deckel definiert, WANN die Arena voll ist -- ohne ihn hat der
  Abbruch keinen Ausloeser) und VOR #13/T-15b (die Retry-Klammer muss den Nicht-Retry-Fall kennen).
  Die Legenden-Haelfte nach S13-14.

**S13-08 | Hot-Path-Reinheit -- Bestand pruefen, Rest-Regel schliessen**
- IST (17.08., verifiziert): die Deskriptor-Regel ist im Aufruf bereits durchgesetzt --
  `checkpoint(std::uint32_t deskriptor_ix, ...)` (`checkpoint_measure.hpp:245`) nimmt einen INDEX.
  `test_ms1_arenen_kein_alloc_im_fenster.cpp` deckt die Allokations-Freiheit.
- LUECKE: die Deskriptor-TABELLE selbst und ihre Aufloesung beim Auslesen sind nicht als eigene
  Wache belegt; und die Mess-Ebene als CMake-Flag ist noch nicht gesetzt.
  r5 A3 (C-4), Owner-begruendet: die CT-Achsen-Parameter duerfen zur Laufzeit NICHT
  zusammengebaut oder kopiert werden -- in den Stack gehoert EIN Verweis auf einen statischen
  Deskriptor (Zeiger/Index), nicht die ausgeschriebene Achsen-Kette, *"sonst Latenz proportional zur
  Achsenzahl, also dort am staerksten, wo am feinsten gemessen wird"*. Kein Alloc, kein I/O.
  Mess-Grundlage r5 A7 (prod1, GCC 15.3, -O2, 200 000 Aufrufe, warm): `source_location` 0,92 ns |
  Thread-Kennung 3,5 | `__rdtsc()` 6,8 | `steady_clock::now()` 16,5 | `std::stacktrace::current(1,1)`
  343 | `std::stacktrace` + `description()` ~26 900. Folge: `std::stacktrace` waere je
  Interface-Aufruf mit 19 Achsen / 38 Checkpoints rund 13 us -- mehr als die gemessene Operation.
  Deshalb r5 A5 (C-7/C-8): EIGENES C++-Stacktrace, `std::stacktrace` wird gar nicht verwendet,
  auch nicht im Fehlerpfad; Aufloesung erst BEIM AUSLESEN, Hot-Path-Kosten null.
- SCHNITT: Deskriptor-Tabelle (CT) + Index im Stack-Eintrag; Aufloesung im Auswerte-Durchlauf.
  Mess-Ebene als CMake-Flag in den Checkpoint einkompiliert; die drei r5-A11-Punkte VOR dem Setzen
  der Flags klaeren (Ebene je Target eindeutig? | wohin gehoert die Gattungs-Interface-Ebene? |
  Ebenen-Flags und CEB-Gates als EIN Mechanismus).
- ABNAHME: **T-12c(4)** -- Koeder: eine Aggregations-Allokation wird ROT; zweiter Koeder: eine
  Fassung, die die ausgeschriebene Achsen-Kette in den Stack legt, wird ROT (Groessen-Assert).
- REIHENFOLGE: der A11-Punkt (2) beruehrt KON95-O2/W3 und damit S13-10 -- VOR S13-10 klaeren.

**S13-09 | E6 Drain-Schleife = measurement_sink-Heilung**
- IST: `flush()` je Arena getrennt beauftragbar ist per `test_ck1_messkette_koeder.cpp` abgenommen
  (Punkt 4 seiner eigenen Abnahme-Liste).
- LUECKE: die Drain-Schleife an den HOL-Punkten (B-03: "Flush nur an Hol-Punkten") und ihre
  Kopplung an den Ziel-Filter S13-02.
- SCHNITT: Drain am Hol-Punkt; die gedrainten Zeilen gehen in den Mappen-Stamm (D-2), nicht in einen
  eigenen Kanal.
- ABNAHME: Deckungs-Test, dass zwischen zwei Hol-Punkten KEIN Flush stattfindet; Koeder: ein Flush
  im Fenster wird ROT.
- REIHENFOLGE: nach S13-02 (der Filter muss stehen, sonst entsteht der zweite stille Kanal neu).

### 4.3 FLAECHE C -- Full-Join FJ-1..FJ-10

**S13-10 | Spaltenmenge E(A) MIT Bezugsgroesse**
- IST: die Segment-Spalten stammen aus einem SEPARATEN 19-Segment-Lauf (`run_workload_segmented`,
  `cache_engine_builder_iterator.hpp`). An echten golden-320-Daten verifiziert (r1, Anker Z.18711):
  `Summe(19 Organ-seg + seg_framework_ns) == seg_run_total_ns` exakt, `seg_coverage` 0,99999.
  Gegen `total_ns` ergibt dieselbe Summe 3x-29x, variabel je Zeile.
- LUECKE: KON95-O2 definiert `E(A) = kV3AxisSchema + seg_*`, nennt aber KEINE Bezugsgroesse.
- SCHNITT: die Bezugsgroesse wird Bestandteil der Spalten-Definition und der Blatt-Legende:
  `seg_*_ns` sind kommensurabel mit `seg_run_total_ns`, NIE mit `total_ns`.
- ABNAHME: **T-12d(1)** -- Koeder: ein Test, der `seg_*_ns` gegen `total_ns` stapelt, wird ROT
  (Phantom). Der Summen-Test laeuft gegen golden-Daten.
- REIHENFOLGE: nach S13-08-A11(2) (Ebenen-Zuordnung der Gattungs-Interface-Ebene).

**S13-11 | Markierter Leerwert (KON95-O1) -- die Form ist gebaut**
- IST: die honest-empty-Praezedenz existiert (r4 B-06): drei Zell-Klassen ueber EINE Wache
  (`cell_displayable`) -- positiv = log-Meta | ECHT-0 = eigene Farbklasse eine Dekade unter der
  kleinsten Mess-Dekade mit literalem `$0$`-Tick (symlog-Muster) | nicht ausgefuehrt = NaN-Auslass.
  3D: Loecher via `unbounded coords=jump`; die z-Achse faellt bei echter 0 auf LINEAR, weil
  `zmode=log` die 0 LAUTLOS verschluckt.
- LUECKE (17.08. NACHGEMESSEN -- A2.5-Fix, Fund 9; die r4-B-07-IST-Haelfte war stale):
  **Die "blinde Kopie" gibt es seit dem 07.08. nicht mehr.** `measurement_snapshot.hpp:145-146`
  sagt es literal: *"M-3a (2026-08-07) -- KEINE BLINDE KOPIE MEHR. Vorher uebernahm dieser Zweig bei
  `pmc.available` ALLE sieben Zaehler, ohne die feinkoernigen PmcCounters::*_source_available zu
  befragen."* Heute ist jede Uebernahme einzeln gegated (:175-179, je
  `if (pmc.<counter>_source_available)`); nur L1D/dTLB haengen begruendet noch an `pmc.available`.
  **Tragend bleibt die ZWEITE Haelfte, und sie ist unveraendert wahr:** der Ziel-POD kennt nur die
  grobkoernige Marke `pmc_available` (:53) -- *"Ein Zaehler ohne Quelle landet daher weiterhin als
  [0]"* (:159). In der CSV steht damit weiterhin eine 0 neben `pmc_available = 1`, ohne dass die
  Zeile sagen kann, welcher Zaehler eine Quelle hatte. Heilbar nur ueber Flag-Felder im POD und
  damit NEUE CSV-Spalten -- golden-byte-wirksam, deshalb OV-S13-3.
- SCHNITT: ECHT-0 und Auslass sind ZWEI Klassen, durchgaengig vom POD bis ins Blatt. Die
  POD-Erweiterung (Flag je Counter) ist Schema-wirksam => Abstimmung mit dem #15-Bruch
  (Abschnitt 6), NICHT im S-13-Slot allein entscheidbar.
- ABNAHME: **T-12d(2)** -- Koeder: ein `zmode=log`-Pfad, der eine echte 0 verschluckt, wird ROT.
- REIHENFOLGE: die Darstellungs-Haelfte sofort; die POD-Haelfte NUR gemeinsam mit dem #15-Bruch.

**S13-12 | Full-Join verwirft nichts**
- IST: Doktrin KON91-P1 -- Wurzel per XML `artifacts` ODER `binaries+measurement` (Default getrennt)
  -> Gattung+Genus-Baum -> Lagerbaum je Genus-Tier-Binary; ab ma-Ebene ALLE Parameter inkl. PMC =
  FULL JOIN der mi-Achsen-Erfolgs-Parameter.
- LUECKE: die Verlustfreiheit ist nicht bewacht.
- SCHNITT: je Achse bleibt jede mi-Erfolgs-Spalte erhalten; Join-Ergebnis ist eine Obermenge.
- ABNAHME: **T-12d(3)** -- Koeder: Spalten-Drop wird ROT.
- REIHENFOLGE: nach S13-10.

**S13-31 | E4-AGGREGATOR: der mechanische Join-Ort, mit ZWEI Modi** *(A2.5-Fix 17.08., Fund 2 (a)+(e))*
- IST: 0 Treffer im Design und -- soweit hier erhoben -- kein benannter Bau-Ort. Der Ledger fuehrt
  ihn als Kernstueck: *"Full Join = Ziel-Schema, E4-Aggregator = mechanischer Join-Ort (Pivot
  deskriptor_ix->Spalte), E6-Drain = Sheet-Regel-Konsument"*, und FJ-3/FJ-4 sind ihm zugeordnet.
- LUECKE: der Ort, an dem aus Roh-Checkpoint-Zeilen (deskriptor_ix + Messwert) eine Sheet-Zeile
  wird, fehlt als Schritt -- und mit ihm die von KON95-01 verlangten ZWEI MODI. Owner verbatim
  (KON95-01, am Ledger nachgelesen): *"Nur wenn w nach einer ma Zusammenfassung fragt, laesst sich
  die Akkumulation aller Zeilen nachtraeglich als eine Zeile zusammenfassen."* Ledger-Festschreibung:
  *"BAU-WIRKUNG: FJ-3/FJ-4 (E4-Aggregator) bekommt ZWEI Modi -- Block-Durchreichung (Default) +
  w-getriebene Ein-Zeilen-Zusammenfassung."*
- SCHNITT: EIN Aggregator mit zwei Betriebsarten.
  **Modus 1 (DEFAULT) -- Block-Durchreichung:** die ma-Sicht ist ein GESAMMELTER BLOCK ueber viele
  zeitlich versetzte mi-Zeilen; jede Zeile bleibt erhalten, Leerstellen sind markierte Leerwerte
  (S13-11). Nichts wird zusammengefasst.
  **Modus 2 -- w-getriebene Ein-Zeilen-Zusammenfassung:** erst wenn `w` nach einer ma-ZUSAMMENFASSUNG
  fragt, wird die Zeilen-Akkumulation NACHTRAEGLICH zu EINER Zeile verdichtet.
  **Die tragende Regel:** Aggregation ist ABFRAGE-getrieben, nie Schreib-Default. Wer sie in den
  Schreibweg legt, hat den Rohbestand verloren, bevor jemand ihn abfragen konnte.
  Der Pivot ist `deskriptor_ix -> Spalte` -- damit haengt S13-31 direkt an der Deskriptor-Tabelle
  aus S13-08.
- ABNAHME: Koeder 1 -- eine Fassung, die im Schreibweg zusammenfasst (Modus 2 als Default), wird
  ROT. Koeder 2 -- eine w-Abfrage, die mehr als eine Zeile zurueckgibt, wird ROT. Koeder 3 -- eine
  Modus-1-Durchreichung, die eine mi-Zeile verliert, wird ROT (deckt zugleich T-12d(3)).
- REIHENFOLGE: nach S13-08 (Deskriptor-Tabelle) und S13-10 (Spaltenmenge), vor S13-09 (die
  Drain-Schleife ist sein Konsument) und vor S13-14 (die Blattform setzt die Zeilenform voraus).

**S13-32 | FJ-1 schicht-parametrische Spaltenfunktion + FJ-2 E(A) gegen BEIDE Quellen**
*(A2.5-Fix 17.08., Fund 2 (c)+(d))*
- IST: das Design fuehrte E(A) bisher als EINE Spaltenmenge mit Bezugsgroesse (S13-10). Das ist die
  halbe Wahrheit.
- LUECKE, zwei Teile:
  **(a) FJ-1 wird SCHICHT-PARAMETRISCH.** Owner (KON95-03) verbatim: *"je Zeile nur die Werte einer
  betroffenen mi Achse festgehalten werden, die dann einfach union Akkumulieren ueber die
  uebergreifenden hoeheren Schichten im Messbaum groeberer Gliederung."* Ledger-Festschreibung:
  *"FJ-1 (Spaltenfunktion) wird SCHICHT-PARAMETRISCH (Union je Messbaum-Knoten statt einer globalen
  Konstante); ... KON94-01-Bildungsregel-Zeile 'ma UND w = Union aller E(A)' gilt PRO KNOTEN des
  Messbaums, nicht global."* Die Spaltenfunktion nimmt also einen Knoten und liefert die Union
  SEINER Kinder -- nicht eine globale Konstante.
  **(b) FJ-2 registriert E(A) gegen ZWEI Quellen.** Ledger (KON95-02): *"FJ-2 (E(A)-Registrierung)
  baut gegen BEIDE Quellen: Code-Kandidat + Dossier-Katalog (Abgleich, Luecken laut)."* Die zweite
  Quelle ist `docs/sessions/20260804-DOSSIER-achsen-qualitaets-parameter-katalog.md` (855 Z.,
  27 Parameter-je-Achse-Eintraege, per KON64-02/C11 als A1-Durchzug-Quelle freigegeben).
- SCHNITT: (a) Signatur der Spaltenfunktion nimmt den Messbaum-Knoten; Union rekursiv nach oben.
  (b) Registrierungs-Lauf gegen beide Quellen mit LAUTEM Diff: eine Achse, die nur in einer der
  beiden Quellen steht, ist ein Befund, kein stilles Ignorieren.
- ABNAHME: Koeder 1 -- eine globale Spaltenkonstante statt der Knoten-Union wird ROT (deckt den
  DEFAULT-Fall). Koeder 2 -- ein Registrierungs-Lauf, der eine nur-im-Dossier-Achse verschweigt,
  wird ROT. **Koeder 3 (A2.5-R2/NEU-K1, der OPT-IN-Fall zu X-8):** ein XML MIT gesetztem
  uniform-Schalter, das trotzdem feingliedrig-disjunkte Spalten liefert, wird ROT -- und
  spiegelbildlich ein XML OHNE Schalter, das global-uniform liefert, ebenfalls. Ohne dieses Paar
  prueft nur W-C die Schema-Gueltigkeit des Schalters, nicht seine WIRKUNG; ein Schalter, dessen
  Wirkung niemand prueft, ist derselbe Deklariert-Inert-Fall wie in X-9(a).
  Deckt zusammen mit S13-10 die T-12d(1)-Pflicht.
- REIHENFOLGE: vor S13-31 (der Aggregator braucht die Spaltenfunktion) und vor S13-12.

**S13-13 | Namens-Wache `FullJoin`**
- IST: `FullJoin` (Pruefling-`MergeStrategy`) ist ein ANDERES Objekt als KON91-"FULL JOIN". Die
  Umbenennung ist Wellenplan Par.19.1/A-09 und liegt im #15-Bump-Buendel VOR F2 (Fr 21.08.), weil sie
  golden-byte-wirksam ist.
- LUECKE: bis zur Umbenennung braucht es eine Kollisions-Wache; danach eine, die den alten Namen
  nicht zurueckkommen laesst.
- SCHNITT: zweistufig -- Stufe 1 (bis A-09): Kollisions-Koeder; Stufe 2 (nach A-09): Verbots-Koeder
  auf den Alt-Namen.
- ABNAHME: **T-12d(4)**.
- REIHENFOLGE: haengt an A-09 (#15, vor F2). Faellt A-09 aus, bleibt Stufe 1 stehen -- das ist
  KEIN Blocker fuer S-13, aber im Protokoll auszuweisen.

### 4.4 FLAECHE D -- Sheet-System, CSV-Factory, Namens-Grammatik

**S13-14 | Blattzahl-Formel + interne Hyperlinks**
- IST: die Blattsorten existieren (`MessEbene` :206, `mess_ebene_sheetname` :320,
  `kInfoBlattName` :310, 31-Zeichen-Wache :268/:275); `sheet_label_fuer_index` (:299) ist da.
  V-A9-6 ist entschieden: **S001 ENTFAELLT**, sparse Namen (KON87).
- LUECKE: die FORMEL und die Hyperlinks. Owner (r5 A21): *"die sheets einer jeden Achse in den
  Micro-benchmarks stattdessen zusammenlegen und den Aufrufer und den Zeitpunkt des Aufrufes
  sequentiell dort mit allen messwerten loggen [...] Dasselbe machen wir fuer das Macro-Benchmarking,
  sodass jede FUNKTION einen sheet bekommt."* => **Blattzahl = 1 + |Funktionen| + |Achsen|**,
  unabhaengig von der Lauflaenge. Abstieg ueber anklickbare interne Links (`write_url` auf
  `'Sheetname'!A1`): compare -> Funktions-Sheet -> Achsen-Sheet. KON88 traegt die
  Sheet-je-Achse-Regel, NICHT die Hyperlink-Mechanik und NICHT die Formel.
- **HARMONISIERUNG mit der juengeren Owner-Linie (A2.5-Fix 17.08., Fund 11 -- MERGE statt
  Verdraengung).** Die Formel stammt aus r5 A21 (~09.08.). KON88-P1 (16.08.) ist juenger und
  schneidet ANDERS. Ledger verbatim (am Original nachgelesen):

      "Die w/ma/mi-HIERARCHIE lebt im FILESYSTEM, NICHT in Sheet-Namen: [...] unter ma ein weiterer
       Layer je GENUS-INTERFACE des Subjekts, darunter mi je ACHSEN-MICROBENCHMARK-Interface; die
       BLAETTER dieses Baums sind die xlsx-DOKUMENTE (je Feinkategorie [...]). IM Dokument: EIN
       Sheet je UNTER-ACHSE; darin ALLE Laufzeit-Permutationen als SEQUENTIELL ABGETRENNTE
       TABELLEN im selben Sheet."

  dazu KON91-01: *"EIN Sheet je Unter-Achse gilt JE der 3 [Ebenen], SOFERN verfuegbar."*
  **Damit sind es ZWEI Schnitte, nicht einer:**
  (i) |Funktionen| und |Achsen| werden zu ORDNER-Ebenen im Filesystem (ma-Layer je Genus-Interface,
      mi-Layer je Achsen-Microbenchmark) -- nicht zu Sheets;
  (ii) INNERHALB eines xlsx-Dokuments zaehlt EIN Sheet je **UNTER-Achse** (nicht je Achse!), und
      die Laufzeit-Permutationen sind sequentiell abgetrennte TABELLEN im selben Sheet.
  **Achse (18 Stueck) und Unter-Achse sind verschiedene Dinge** -- eine Zaehl-Abnahme auf
  "|Achsen|" wuerde den falschen Schnitt festschreiben.
- SCHNITT (gemerged): die A21-Formel gilt NICHT als Sheet-Zahl je Dokument, sondern als
  **Navigations-Bild ueber den Baum**: die "1" ist das compare-Blatt (`MessEbene::Compare`, D-1),
  |Funktionen| und |Achsen| sind die ma-/mi-ORDNER darunter. Was A21 substantiell beitraegt und was
  KON88 NICHT regelt, ist die **Hyperlink-Mechanik** (`write_url` auf `'Sheetname'!A1`) als
  Abstiegsweg -- die bleibt, jetzt als Absprung compare-Dokument -> ma-Dokument -> mi-Dokument
  bzw. INNERHALB eines Dokuments zwischen INFO-Blatt und den Unter-Achsen-Sheets.
  Die Sheet-Zahl JE DOKUMENT ist damit `1 (INFO) + |Unter-Achsen der Feinkategorie|`.
- ABNAHME: Zaehl-Test **je Dokument**: `sheets == 1 + |unter_achsen|` bei zwei verschiedenen
  Lauflaengen (die Zahl darf sich NICHT aendern -- Permutationen werden Tabellen, keine Sheets;
  das ist zugleich der S13-16-Koeder). Struktur-Test **je Baum**: die ma-/mi-Ordner-Ebenen
  existieren, die Blaetter sind Dokumente. Link-Test: jeder Link zeigt auf ein existierendes
  Blatt bzw. Dokument; Koeder: ein Link ins Leere wird ROT.
- REIHENFOLGE: nach S13-03 (per-Binary-Mappen bestimmen die Grundgesamtheit) und mit S13-16
  (dieselbe Hierarchie-Entscheidung, zwei Seiten).
- **REST-RISIKO / Owner-Ein-Satz (OV-S13-5, siehe 10.2):** die Harmonisierung ist eine Auslegung
  zweier Owner-Saetze aus verschiedenen Wochen, keine dritte Erfindung. Sollte der Owner die
  A21-Formel als SHEET-Zahl gemeint haben, kippt (i) -- dann waeren |Funktionen|/|Achsen| doch
  Sheets in EINER grossen Mappe. Der Bau haengt daran, deshalb steht die Frage in 10.3, nicht 10.2.

**S13-15 | Zwei Blatt-Familien, EINE Factory**
- IST: `ErgebnisMappenFactory` (:631) + `IErgebnisBlatt`/`IErgebnisMappe` sind da; `SheetSchluessel`
  (:90) traegt die Ergebnis-Familie, `MessEbenenSchluessel` (:231) die Profil-Familie.
- LUECKE: r5 A22 verlangt ausdruecklich KEINEN zweiten Writer: Ergebnis-Blaetter (Zeile pro
  Messergebnis je Permutation) und Profil-Blaetter (compare / je Funktion / je Achse, Zeile pro
  Aufruf) teilen dieselbe Factory, dieselbe 31-Zeichen-Wache, dasselbe INFO-Sheet.
- SCHNITT: Blattsorte als Parameter der Factory, nicht als zweite Factory. Die beiden
  Schluessel-Typen bleiben getrennt; die Anlage-Reihenfolge kommt aus dem jeweiligen Schluessel
  (so bereits im Header dokumentiert, :230).
- ABNAHME: ein Test, der BEIDE Familien in EINE Mappe legt und die gemeinsamen Wachen (31 Zeichen,
  Zeilenlimit, INFO) an beiden nachweist. Koeder: eine zweite Factory-Instanz wird ROT.
- REIHENFOLGE: mit S13-14.

**S13-16 | Hierarchie im FILESYSTEM (KON88-P1), nicht in Sheet-Namen**
- IST: die Sheet-Namens-Wache existiert; die Filesystem-Hierarchie unterhalb der Lager-Grammatik ist
  Flaeche G.
- LUECKE: KON88-P1-Korrektur: die Hierarchie liegt im FILESYSTEM; Blaetter sind xlsx; EIN Sheet je
  Unter-Achse; Permutationen sind sequentiell abgetrennte TABELLEN im selben Sheet (nicht je eine
  Datei, nicht je ein Sheet). KON88-P2 (Kalt-Diff): +/-x je Spalte, KEINE zweite Zeile;
  Arenen ZUERST, dann Folge-Blaetter; Limit = RAM.
- SCHNITT: Verzeichnis-Ebenen aus `MessEbene` (D-1) + Unter-Achsen-Schluessel; im Sheet die
  Permutationen als abgetrennte Tabellenbloecke mit Trennzeile.
- ABNAHME: Struktur-Test ueber ein Mini-Experiment: erwartete Verzeichnis-/Blatt-/Tabellen-Zahl
  literal; Koeder: eine Permutation, die ein eigenes Sheet bekommt, wird ROT.
- REIHENFOLGE: nach S13-25 (Lager-Wurzelebenen), da die Verzeichnis-Wurzel dort entsteht.

**S13-17 | CSV-Factory (KON89-D3) + Namens-Grammatik (r5 A47)**
- IST: die CSV-Seite ist heute flach und hart benannt. Verifiziert 17.08. im super:
  `02_messung_driver/main.cpp:1293/:1351` schreiben `measurements.csv`, :796 `permutation_stats.csv`,
  :828 `permutation_stats_per_axis.csv`, :885 `welch_pairwise.csv`;
  `messreihe_report_exporter.hpp:41` `results.csv`. Keine Ebene im Namen, kein parsbarer Zeitraum.
- LUECKE: KON89-D3 -- CSV = FACTORY als verschachteltes Filesystem: Gesamt-Ordner -> Ordner je Sheet
  -> CSVs je Unter-Achsen-Fahrt. Dazu r5 A47 (Owner): *"welche die Zeitraeume parse-bar im Namen
  tragen und anfuehrend im Namen ihre Ebene fuer das Messblatt benennen."* KON89 legt die
  Ordner-Verschachtelung fest, NICHT die Namens-Grammatik -- die hat kein juengeres Gegenwort.
  Dateiname-Grammatik aus r5 A46: `datum "-" zeit "_" kvkette "." endung`, `endung := "xlsx"|"csv"`;
  mit A47 tritt die EBENE anfuehrend davor.
- SCHNITT: **`ergebnis_dateiname.hpp`** (der einzige echte Neubau der Flaeche D) als Namens-Fassade
  mit Wachen: Ebene anfuehrend, Zeitraum parsbar, Endung aus `ErgebnisFormat`. Die Factory legt die
  verschachtelten Ordner an. B-07-Migration `csv_to_latex` -> `measure_to_latex` mit ihren
  9 benannten Konsumenten (Code/CMakeLists.txt:343/:380/:388/:399/:429/:496/:524,
  .gitlab-ci.yml:1481/:1564) ist Teil dieses Schnitts.
- ABNAHME: Round-Trip-Test: Name bilden -> Name parsen -> Ebene und Zeitraum zurueckgewinnen.
  Koeder: ein Name ohne fuehrende Ebene ODER mit unparsbarem Zeitraum wird ROT.
  Migrations-Abnahme: ALLE 9 Konsumenten zeigen auf den neuen Namen; Koeder: ein zurueckgebliebener
  Alt-Name wird ROT (ABSCHRIFT schlaegt LOESCHUNG -- der Alt-Name wird umgeschrieben, nicht
  geloescht, sonst bricht die Suche nur bei Aufrufern).
- REIHENFOLGE: nach S13-03, vor S13-27 (publish adressiert Dateien ueber diese Namen).

**S13-18 | FOLGE-BLATT-POLITIK statt Wurf am Zeilenlimit (E5)**
*(A2.5-Fix 17.08., Fund 3 -- MUSS. Die erste Fassung schnitt hier einen Abnahme-Test, der das
WERFEN zementiert haette. Das ist die falsche Richtung: der Wurf ist per Owner-Wort ueberholt.)*
- IST (17.08., verifiziert): `kXlsxZeilenlimit = 1'048'576` (ergebnis_mappe.hpp:340) und
  `xlsx_zeile_erlaubt(...)` (:346) existieren; `ErgebnisSchreibFehler` (:246) ist die Fehlerklasse.
  Der Wurf lebt also im Code.
- LUECKE: **die Doktrin dahinter ist ueberholt.** KON88-P2, Owner verbatim 16.08. (von mir am
  Ledger-Original nachgelesen):

      "Harter Abbruch am Excel-Limit ist SYSTEMFREMD: Messwerte liegen ZUERST in ARENEN,
       xlsx-Persistierung folgt nachgelagert -> sequentielle Folge-Blaetter bis die Arena
       geleert ist; einziges hartes Limit = RAM der Mess-Arena."

  Der Ledger fuehrt die Konsequenz benannt: unter UEBERHOLT (D1-D6) steht
  *"ErgebnisSchreibFehler{zeilenlimit}-Doktrin (per KON88 SYSTEMFREMD; Code lebt noch -> E5)"*,
  und die E-Bauliste traegt **"E5 Folgeblatt statt Wurf"**. Die KON87-P2-Fortsetzungsblatt-
  Empfehlung ist damit *"in der Sache bestaetigt"*.
- SCHNITT: **E5 -- Folge-Blatt-Politik.** Erreicht ein Blatt das xlsx-Zeilenlimit, wird ein
  FOLGE-BLATT eroeffnet und der Schreibstrom laeuft dort weiter, bis die Arena geleert ist. Der
  Folge-Blatt-Name folgt der Sheet-Namens-Grammatik (Flaeche D) und bleibt in der 31-Zeichen-Wache.
  `kXlsxZeilenlimit` bleibt als Schwelle bestehen -- es wird vom ABBRUCH-Kriterium zum
  BLATT-WECHSEL-Kriterium. `ErgebnisSchreibFehler{zeilenlimit}` verliert seinen Anlass und wird
  NICHT geloescht, sondern auf echte Schreibfehler zurueckgeschnitten (ABSCHRIFT schlaegt
  LOESCHUNG). Das einzige harte Limit ist der Arena-RAM -- und der gehoert zu S13-05/S13-07.
- ABNAHME: Koeder 1 -- eine Fassung, die am Zeilenlimit WIRFT statt ein Folge-Blatt zu eroeffnen,
  wird ROT (der Gegen-Koeder zum heutigen Bestand). Koeder 2 -- ein Folge-Blatt-Name, der die
  31-Zeichen-Wache reisst, wird ROT. Koeder 3 -- ein still verworfener Rest nach dem Blattwechsel
  wird ROT. Positivprobe: ein Strom von n > 1'048'576 Zeilen landet vollstaendig, verteilt auf
  ceil(n / Limit) Blaetter, ohne Verlust. T-11c-Mutation je Koeder.
- REIHENFOLGE: **nach S13-14/-15** (die Blatt-Familien und die Namens-Grammatik muessen stehen,
  bevor ein Folge-Blatt benannt werden kann) und gemeinsam mit S13-09 (die Drain-Schleife ist die
  Quelle, die das Blatt fuellt). Der Posten ist damit NICHT mehr der billigste des Buendels.

### 4.5 FLAECHE E -- XSD-Enum-Wache (der lebende Rest von A43)

**S13-19 | `<method value="..."/>` bekommt eine Enum-Wache**
- IST (17.08., verifiziert): `WritebackMethod` traegt **vier** Werte inkl. `Xlsx`
  (writeback_method_registry.hpp:30-35, `kWritebackMethodCount = 4` :38, Registry-Zeile :51,
  static_asserts :75/:80). **Die A43-Haelfte "Enum dreiwertig" ist STALE.**
  Die XSD-Haelfte gilt unveraendert: `WritebackMethodsType` (experiment_schema.xsd:311-319) und
  `RunMethodologyType` (:292-300) deklarieren `<method>` mit
  `<xs:attribute name="value" type="xs:string" use="required"/>` -- freier String, KEINE
  `xs:enumeration`. Wer `value="tippfehler"` schreibt, bekommt keinen Schema-Fehler.
- LUECKE: genau diese fehlende Enum-Wache. Der vierte Registry-Wert ist ueber KON23-03 gedeckt,
  die XSD-Luecke nicht.
- SCHNITT: **Haus-Muster beibehalten (D-3): die XSD bleibt FUER DIE REGISTRY-UNTERACHSEN-TYPEN
  strukturell, die HAERTE kommt in
  `validate_profile.hpp`** -- dort liegt bereits der {local,minio}-Enum (:1164-1177) als Vorbild.
  Neu: `writeback_methods`-Token gegen `kWritebackMethodRegistry` und `run_methodology`-Token gegen
  `kRunMethodologyRegistry`, je fail-loud als ERROR mit gezaehltem Pruef-Zaehler.
  *Begruendung fuer "Validator statt xs:enumeration": die Registries sind Single-Source im Code;
  eine XSD-Enumeration waere eine zweite Wahrheit und liefe bei jedem Registry-Zuwachs auseinander --
  genau der Drift, den `kWritebackMethodCount` compile-time verhindert.*
  Die XSD bekommt stattdessen einen Kommentar, der auf die Registry als Single-Source zeigt.
- ABNAHME: drei Koeder-XMLs (unbekannte writeback-Methode | unbekannte run_methodology | leerer
  Wert) muessen ROT beissen, in Debug UND Release, gcc UND clang. Gegenprobe: die 11 getrackten
  Profile validieren unveraendert.
- REIHENFOLGE: im Schema-Zug mit S13-04 und S13-27.

### 4.6 FLAECHE F -- B5: XML-Trennung BAU-Menge / MESS-Menge

**S13-20 | Die Trennung wird XML-faehig**
- IST (17.08., verifiziert): die Trennung existiert AUSSCHLIESSLICH als Env-Asymmetrie des
  Planer-Emitters. `COMDARE_GOLDEN_N_PROVISION_ONLY=true` wird gesetzt in
  `profile_facade/planner/experiment_plan_director.hpp:1529`, `:1739`, `:2047`, `:2104` (Bau-Jobs)
  und BEWUSST weggelassen bei `:1589` ("Er baut+misst OHNE COMDARE_GOLDEN_N_PROVISION_ONLY")
  und `:2109` ("realer Mess-COMMAND -- OHNE COMDARE_GOLDEN_N_PROVISION_ONLY (=> misst)").
  Die golden-XML sagt es selbst (`Code/test_data_xml/experiment_golden_kern.xml:270`):
  *"Diese XML deklariert also die BAU-Menge, der Planer die MESS-Menge."*
  *(Hinweis fuer Sucher: die Datei liegt heute unter `profile_facade/planner/`, nicht unter
  `planner/`; die in r3 B5 genannten Zeilen 1247/1406/1696/1753 sind gewandert.)*
- LUECKE: Owner verbatim (06.08.): *"nur weil sie kompiliert werden sollten, heisst es nicht dass
  sie auch gemessen werden muessen, das muss die XML getrennt fuer build und Messung definieren
  koennen sonst regression."*
- SCHNITT: vier Teile, in dieser Reihenfolge -- (1) XSD: additive Mengen-Deklaration je Zweck;
  (2) Parser + `ExperimentProfile`-Felder; (3) Planer-Emission liest die beiden Mengen statt der
  hartkodierten Asymmetrie; (4) Wache, dass BEIDE Mengen unterscheidbar sind und die Bau-Menge die
  Mess-Menge umfasst (D-3-Regel aus r4 C-4: "Bau-Menge folgt Mess-Menge" ist eine REGEL, keine Zahl).
- ABNAHME: ein XML mit Bau != Mess erzeugt literal unterschiedliche Job-Kommandos; Koeder: eine
  Fassung, die die Mess-Menge aus der Bau-Menge ableitet, wird ROT. Zusaetzlich: die golden-XML
  bleibt byte-unveraendert valide (Abwesenheit = heutiges Verhalten).
- REIHENFOLGE: Schema-Anteil im Schema-Zug; der Emitter-Anteil NACH S13-19 (der Validator muss die
  neuen Felder schon hart pruefen, bevor der Emitter sie liest).

### 4.7 FLAECHE G -- #57 Lager-Vollausbau

Owner 15.08.: *"Wir sollten die Luecken ALLE schliessen"*; Owner-Rang (r3 B4): *"der Voll-Bau-Trigger
IST der Baum-Vollausbau"*. Der Paketschnitt (Owner 01.08.) lautet:
**LB-0** Pfad-Grammatik | **LB-1** Knoten-Log + Truncate-Zustandsmaschine | **LB-2** Baum-Writer
Binaries-Realm | **LB-3** Baum-Writer Messdaten-Realm + xlsx | **LB-4** Bestandslog<->Baum-Integration |
**LB-5** Planer/CEB-Scharfschaltung | **LB-6** Beweise.

Stand am Objekt (17.08., soweit hier erhoben): LB-0 und LB-1 haben eigene Test-TUs
(`test_lb0_lager_pfad_grammatik.cpp` = 39 TESTs, `test_lb1_knoten_heuristik_log.cpp` = 26 TESTs);
fuer LB-2..LB-6 existiert **keine eigene Test-TU** (Gegenprobe: `ls tests/unit/test_lb*` liefert
genau diese zwei Dateien). LB-6 Stufe 1 ist laut r3 B4 gelandet (ce `b241a272`).

**S13-21 | LB-4: Bestandslog <-> Baum-Integration, Bestandslog scharf stellen**
- IST (17.08., NACHGEMESSEN -- A2.5-Fix, Fund 8; die aus r3 B6 uebernommene Dreier-Liste war
  teilweise stale, die Nachmessung hatte 7.3 selbst verlangt):
  **Haerte 3 (Korn-Divergenz) ist GESCHLOSSEN.** `plan_slice_korn(cfg)`
  (`experiment_tree/cache_engine_builder_iterator.hpp:1478`) ist laut Kopfkommentar :1473
  *"DIE EINE KORN-QUELLE DER PLAN-KETTE"*; beide Wege holen ihr Korn dort ab (Bau :1744, Mess-Front
  :3291). Am Mess-Weg steht der Vollzug woertlich (:3286): *"Hier stand bis hierher
  bestandslog::kBuildSliceGrain als Literal"*. Die r3-B6-Anker :2340/:1109 tragen heute anderen Code.
  **Haerte 2 (F4-Bau-Zaehler) ist TEIL-GEHAERTET.** Der Zaehler bleibt eine eigene Skip-Quelle vor
  `dll_is_current`, traegt aber seit T2-A/F4-NB2/NB3 eine Bau-Identitaets-Bindung und einen
  fail-closed-Anker (:3280-3284: *"Ohne Anker ... kein Plan-Zaehler"*; :3290: der Mess-Lauf findet
  den Plan seines Bau-Laufs nur, wenn er GEGEN DENSELBEN BAU-STAND misst).
  **Haerte 1 (Praefix-Ignoranz) besteht unveraendert -- und zwar ABSICHTLICH.**
  `planner_status_reader.hpp:22-25` und :140-141 sagen es literal: *"Der PRAEFIX wird bewusst NICHT
  geprueft"*.
  Dazu B-09 unveraendert: `mess_bestandslog_active=false`; Restliste `main.cpp ~:1112-1114/:1349-1351`
  + `COMDARE_BESTANDSLOG_MESS_DOC_KEY` in die Planer-Forward-Liste.
- LUECKE: Leitsatz (bindend): **"der Zaehler-Resume darf NIE mehr behaupten, als der Fingerprint
  deckt."** Nach der Nachmessung bleibt genau EINE offene Frage plus die Scharfschaltung.
- SCHNITT (gegenueber der ersten Fassung geschrumpft):
  (a) **Haerte 1 ist keine Reparatur, sondern eine PRUEFUNG der Entscheidung:** der Praefix wird
      bewusst nicht geprueft. Zu belegen ist, dass diese Absicht heute noch traegt -- oder sie wird
      widerrufen. Das ist ein Ein-Satz-Befund, kein Umbau.
  (b) **Haerte 2 schrumpft auf die Rest-Frage:** deckt der fail-closed-Anker den VOLLEN
      v6-Fingerprint-Umfang, oder nur einen Teil davon? Am Objekt zu messen, dann ggf. erweitern.
  (c) **ENTFAELLT** -- die Korn-Parametrierung ist gebaut. Statt Bau: eine Wache, die
      `plan_slice_korn` als EINZIGE Quelle festschreibt (Koeder: ein zweites `kBuildSliceGrain`-
      Literal im Plan-Stempel-Weg wird ROT). Damit bleibt die geschlossene Haerte geschlossen.
  (d) `mess_bestandslog_active` scharf mit der Restliste (unveraendert).
- ABNAHME: Koeder zu (c) wie oben; zu (b) ein Fingerprint-Feld ausserhalb des Ankers, das den
  Plan-Zaehler passieren laesst, wird ROT; zu (a) eine Aktenzeile im Design/Ledger, kein Test.
- REIHENFOLGE: VOR S13-22 (Scharfschaltung ohne Integration ist wertlos) und VOR dem Trigger.

**S13-22 | LB-5: Planer-Blattfunktion | CEB-Vollplatzierung | Hybrid-Push-Pfad**
- IST (17.08., verifiziert): #57 bestaetigt sich am Objekt. In `lager_baum_writer.hpp` (945 Z.)
  liefern "planner", "planer" und "plan_" je **0 Treffer** -- der Planer hat KEINE Blattfunktion.
  "ceb_" liefert genau **2 Treffer**: den Praefix-Kommentar (:47) und `ceb_blatt_ebenen(Spec)`
  (:770) -- also der Praefix (Ebene 1), nicht die Vollplatzierung. Die Hybrid-GRAMMATIK ist dagegen
  frei (K1 vom 09.08. hob das Token-Verbot auf, :57/:443-446); was fehlt, ist der PUSH-Pfad, nicht
  die Einsortierung.
- LUECKE: der Planer hat weder Gattung noch Genus -- KON9-11 ("wenn sie Gattung und Genus haben")
  liess ihn offen. Eine Blattfunktion fuer einen Traeger OHNE Gattung/Genus ist Design UND Bau.
  B-10: Tier-Bau/-Laden IMMER durch die CEB delegiert; Standard-`compare`->`release` VOR dem
  Hybrid-Dock; Loader stufen-neutral.
- SCHNITT: drei getrennte Blattfunktionen am EINEN Baum-Writer (D-4), je Realm-Policy. Der Planer
  bekommt eine eigene Blatt-Regel, die den Stempel als Schluessel nimmt und ohne Gattung/Genus
  auskommt. Der Hybrid-Push nutzt den Tier-Mechanismus erweitert, keinen zweiten Pfad.
- ABNAHME: je Stufe ein Ablage-Test mit literalem Pfad; Koeder: eine Stufe, die im Baum landet,
  ohne dass ihre Blattfunktion sie platziert hat, wird ROT. Der publish-Validator (S13-27, R9)
  meldet "deklariert, aber Bau fehlt" LAUT, solange eine Blattfunktion fehlt -- Doktrin
  "erst laute Compile-/Validierungs-Fehler, dann verschieben".
- REIHENFOLGE: nach S13-21, vor S13-27.

**S13-23 | LB-6: die Basis-Tests des Lagersystems (Owner-KERN, r3 B1)**
- IST: keine eigene Test-TU fuer LB-2..LB-6 (Gegenprobe oben). `lager_baum_writer` wird ausserhalb
  von LB-0/LB-1 nur von drei `test_s5_*_alloc_conformance` mitberuehrt.
- LUECKE: Owner verbatim: *"Ich erwarte laut Plan eine dummy Strategie fuer den Tests des Lagers um
  aus simulierten Textdokumenten die Stempel auszulesen und jede Zeile verbatim auszuwerten und
  dasselbe mit compile Binary stubs fuer das Stempelsystem zu wiederholen (Binary compile der
  eigentlich nur das statische Stempel interface der Versionierung enthaelt als leere Tier-Binary).
  Das sind die erwarteten Basis Tests fuer das Lagersystem."*
  Produktiv-Ziel dahinter: eine **FACTORY fuer die Stempel-ERKENNUNG** aus zwei Quellklassen --
  (a) gebaute Tier-Binaries, (b) Messwerttabellen: xlsx, dort im LEGENDEN-/INFO-Sheet.
- SCHNITT: Strategy-Muster mit zwei Produktiv- und zwei Dummy-Strategien.
  Stufe 1: Textdokument, jede Zeile verbatim ausgewertet.
  Stufe 2: echt kompilierter, sonst leerer Tier-Binary-Stub, der NUR das statische
  Stempel-Interface traegt -- das ist der Uebergang vom Mock zum echten ABI-Traeger.
  Die xlsx-Quelle liest den Stempel aus dem INFO-Blatt (`kInfoBlattName`, ergebnis_mappe.hpp:310) --
  damit haengt LB-6 an Flaeche D und schliesst den Kreis.
- ABNAHME: Google-Tests, Debug UND Release; je Strategie ein Koeder (verfaelschte Stempelzeile im
  Textdokument / Stub ohne Stempel-Symbol) muss ROT beissen. Ohne diese Tests ist der Lager-Aufbau
  (Bestandslog, Inventar-Batch-Cache, Rueckschreibung) unbelegt.
- REIHENFOLGE: nach S13-22 und nach S13-14/-15 (INFO-Blatt muss die Stempel-Zeile tragen).

**S13-24 | B3 Host-Belegung + B9 Plan-Ablage (EIN Vertrag, EIN Schnitt)**
- IST (17.08., verifiziert): `grep -c "batch_plan_datei" Code/02_messung_driver/main.cpp` = **0**
  => `PlanPersistenz::aktiv() == false` im echten Trigger-Lauf; die gesamte Ebene 1
  (`PhasenZaehler{kompiliert, gemessen}`, Praefix-Sprung ueber vollstaendig gedeckte 4096er-Faecher)
  ist INERT. Ebene 2 (`filter_window_for_build`, PresenceFn je Binary) laeuft produktiv.
  `LazyRunConfig::batch_plan_korn` hat ausser Tests keinen Produzenten.
  B9: drei multiplizierende Schleifen um `make_cfg` (opt x simd-Perms x Selektions-Paesse x
  SOTA-Reihen) => am `all_axes_golden` bis zu **156 Ueberschreibungen je Lauf**.
- LUECKE: der Host-Bau-Auftrag (Spezifikation liegt fertig vor) und eine driftfreie Plan-Ablage.
- SCHNITT: **Option 2** -- stempel-abgeleiteter Name IM ITERATOR; `batch_plan_datei` wird
  **Praefix statt Pfad**, weil nur der Iterator die Pass-Selektion NACH der `max_binaries`-Kappung
  kennt. Gemeinsam mit B3 als EIN Vertrag. **Option 3 (Pass-Index-Suffix in `make_cfg`) ist
  ausdruecklich falsch** -- sie deckt die Perm-/SOTA-Achse nicht und leitet die Selektion ein
  zweites Mal ab.
  Owner-Gruendungssatz fuer den Zweck (r3 B2): der Batch persistiert den sortierten Build-Plan fuer
  einen Sammel-Batch mit mehreren Segmenten; es muessen nur noch nicht gebaute und nicht
  dokumentierte Binaries geprueft werden, ob sie nicht doch abgelegt wurden, um sie nachtraeglich
  zu inventarisieren. **"NICHTS muss neu KONZIPIERT werden"** -- beide Ebenen existieren im Code.
- ABNAHME: Ueberschreibungs-Zaehler == 1 je Lauf (statt bis 156); Koeder: zwei Paesse, die
  denselben Plan-Pfad schreiben, werden ROT. Host-Belegung: der Trigger-Lauf zeigt
  `PlanPersistenz::aktiv() == true` mit literaler Ausgabe.
- REIHENFOLGE: VOR dem Bau-Trigger Mi 26.08. -- sonst faehrt die Kampagne mit inerter Ebene 1.

**S13-25 | B-08: ZWEI WURZELEBENEN Gattung -> Genus -- GEBAUT, nur die Beweis-Seite fehlt**
- IST (17.08., verifiziert): **B-08 ist gebaut.** `lager_baum_writer.hpp` (945 Z.,
  `builder/bestandslog/`) fuehrt im Kopf (:14-20) die Ebenen aus: `1 gattung=<token>` (Ebene 1 der
  Anatomie), `2 genus=<token>` (Ebene 2), `3 realm=<binaries|messdaten>`. Owner verbatim ebenda:
  die Hybrid-Gattung ist *"einfach eine weitere Gattung+Genus, die parallel zu allen anderen
  Gattung+Genus in den beiden wurzel-Ordner-Ebenen des Lagerbaumes mit einsortiert wird"* und
  *"Binary-Ordner und Messung-Ordner branchen unter Gattung->Genus->Binary/Messung"*. Eine
  `consteval`-Wurzel-Wache (:60) bricht den BAU, wenn eine Gattung ohne Lager-Token auftritt.
  Die Ebenen je Realm stehen ausgeschrieben: Messdaten 11 Ebenen (:33-40), Binaries 7 Ebenen mit dem
  Mess-Typ als tiefstem Haupt-Achsen-Typ (:42-48, Ebene 7 literal bei :45) -- das ist D-12, am Objekt bestaetigt. Die
  Realm-Policies sind CT-vertraglich getrennt (`LagerRealmPolicy` :688, drei `static_assert`
  :782-784, darunter `MessdatenRealmPolicy::realm() != BinariesRealmPolicy::realm()`).
- LUECKE: nicht die Ebenen -- die **Beweis-Seite**. Fuer LB-2 (Binaries-Realm) und LB-3
  (Messdaten-Realm + xlsx) existiert KEINE eigene Test-TU; `lager_baum_writer` wird ausserhalb von
  LB-0/LB-1 nur mitberuehrt.
- SCHNITT: kein Grammatik-Umbau. Zwei Test-TUs (LB-2, LB-3) mit literalen Pfaden je Realm, die die
  bereits gebauten Ebenen abnehmen; darin die Hybrid-Gattung als regulaerer Fall (K1 hob das
  "hybrid"-Token-Verbot am 09.08. auf, :57/:443-446).
- ABNAHME: je Realm ein literaler Pfad Ende-zu-Ende; Koeder: ein Pfad ohne Genus-Ebene wird ROT;
  zweiter Koeder: eine Gattung ohne Lager-Token muss weiterhin compile-time brechen (die
  `consteval`-Wache darf nicht versehentlich entschaerft werden).
- REIHENFOLGE: **frei** -- da nichts an der Grammatik geaendert wird, faellt die urspruengliche
  Bindung an den #15-Bruch WEG. (Die S-6-VERBOTSZONEN, Wellenplan Par.19.1/A-10, nennen die
  Lager-Kaskaden; ein reiner Test-Zubau beruehrt sie nicht. Wer die Ebenen doch anfasst, faellt
  wieder unter die Sperre.)

**S13-26 | rebuild-Flag je Stufe + Teilprojekt-Commit-Skip**
- IST: laut #57 heute 0 Treffer fuer die Teilprojekt-Skip-Logik. Owner 15.08.: *"Wenn die CI im
  Lager exakt den Stempel schon findet, der jetzt per Versionierung gebaut werden sollte,
  ueberspringt sie das Ziel, es sei denn, wir setzen ein spezielles rebuild flag je Planer bzw.
  Traeger Stufe ... Wir lassen also rebuild erstmal dauerhaft an."*
- LUECKE: Flag und Skip-Kriterium fehlen; solange sie fehlen, ist das XML-Flag DEKLARIERT-INERT.
- SCHNITT: `<rebuild><stage name="planner|ceb|tier|hybrid" force="true"/></rebuild>` (Abschnitt 5),
  Default `force=true`. `force=false` erlaubt den ZWEIGLEISIGEN Skip: exakter Stempel-Fund im Lager
  UND gleicher Teilprojekt-Commit. Ausdruecklich NICHT beruehrt: die Compiler-Doktrin
  ("Gebaut wird immer", gcc+clang) fuer den Nicht-Skip-Fall und die VOLL-ctest-Pflicht
  (kein Test-Skip).
- ABNAHME: Skip-Test mit beiden Kriterien; Koeder: ein Skip bei gleichem Stempel aber ANDEREM
  Teilprojekt-Commit wird ROT; zweiter Koeder: ein uebersprungener ctest wird ROT.
- REIHENFOLGE: nach S13-21/-22 (ohne Bestandslog-Integration ist der Stempel-Fund nicht belastbar).

### 4.8 FLAECHE H -- #48 publish-Sektion

**S13-27 | `<publish>` in die XML**
- IST: der vollstaendige Syntax-Vorschlag liegt (`xml_ziel_sektion_vorschlag.md`, 9 Abschnitte,
  Owner-GO 14.08.). Owner-Entscheide dazu: Topologie (a) -- Lager = Wahrheit auf NAS, minio haelt
  Ebene A + Nicht-Lager-Gut, ArtifactCache-Bucket = optionaler CI-Spiegel; Frage 2 = (a) -- Ebene A
  bleibt config.toml-nativ. Der Bestand: `storage`-Slot inert deklariert (xsd:673-678),
  `{local,minio}` hart im Validator (validate_profile.hpp:1164-1177, 17.08. unveraendert).
- LUECKE: die Sektion selbst.
- SCHNITT: exakt der Vorschlag -- 7 Artefakt-Klassen (`planner_binary`, `ceb_binary`, `tier_binary`,
  `hybrid_binary`, `measurement`, `latex`, `pdf`), 4 Ziel-Typen (`lager`, `minio`, `filesystem`,
  `git`), Scope `{local|ci|all}`, XML > Env temporaer, Provenienz in den Lauf-Sidecar.
  Validator-Regeln R1-R9 des Vorschlags uebernehmen; **R9 ist load-bearing**: `planner_binary@lager`
  bzw. `hybrid_binary@minio` sind ERROR "deklariert, aber Bau fehlt", solange S13-22 nicht steht.
- ABNAHME: W1 golden-Byte-Stabilitaet (publish-freie XMLs bleiben byte-identisch) | W2
  XSD-Additivitaets-Probe | W3 Koeder-Pflicht (unbekannte class/type/Weich-Attribut je ROT, Debug
  UND Release, gcc UND clang) | W4 Sidecar-Provenienz | **W5 (A2.5-R2/NEU-M1 GESCHAERFT):** die
  measurement-Ziel-Auswertung ersetzt den unbedingten `measurement_sink`-Kanal **fuer die
  AUSWERTE-PERSISTENZ** -- kein zweiter stiller Auswerte-Kanal daneben.
  **AUSGENOMMEN, benannt und nicht verhandelbar: der RESUME-VERTRAG aus S13-03.**
  `measurement_sink` bekommt weiterhin bedingungslos die `result.csv` gereicht
  (Iterator :3170-3172); das ist kein "stiller Kanal", sondern der Betriebszustand der
  Mess-Maschine (Resume-Arbiter :1364, Planer-Status `planner_status_types.hpp:33-35`).
  Die erste Fassung dieses Satzes stand frontal gegen S13-03-Koeder 2 -- wer sie woertlich gebaut
  haette, haette den MUSS-4-Defekt ueber die publish-Flanke wieder eingebaut. S13-03 warnt selbst,
  der naechste Leser werde die Ausnahme "als vom Filter vergessen" entfernen; W5 WAR dieser Leser.
  Abnahme-Kopplung: der S13-03-Koeder 2 gilt auch fuer publish-Profile -- ein publish-Lauf, nach
  dem `measurement_sink` keine `result.csv` mehr sieht, wird ROT.
- REIHENFOLGE: Schema-Anteil im Schema-Zug; die Wirkung erst NACH S13-02 (Filter) und S13-22
  (Blattfunktionen). Harmonisierungs-Flaeche bei der Landung: O5 des Vorschlags nennt
  `lager_ziel_strategie.hpp` (Genus-Matrix, KON66-05) als in einem Checkout nicht auffindbar -- beim
  Landen auf dem Zweig aufsetzen, der die Genus-Matrix wirklich traegt (v4.2/A2.1b).

**S13-28 | AF_BRANCH XML-erreichbar machen**
- IST (17.08., verifiziert): `.gitlab-ci.yml:2660` setzt `AF_BRANCH="development"` hart; der
  Shell-Kern ist parametrierbar (`ci/anhang_forward_core.sh:308`
  `AF_BRANCH="${AF_BRANCH:-development}"`, Doku :241). Zusaetzlich haengt die Job-Regel am
  Branch-Literal (`.gitlab-ci.yml:2606`: `$CI_COMMIT_BRANCH == "development"`) -- der Branch ist also
  ZWEIMAL hart.
- LUECKE: genau der publish-Hebel aus #48 (3).
- SCHNITT: `<artifact class="latex"><target type="git" repo="..." branch="..."/></artifact>` speist
  `AF_BRANCH`; das Job-Regel-Literal bleibt (es steuert, WANN der Kanal laeuft, nicht WOHIN er
  schreibt) -- dieser Unterschied gehoert als Kommentar an beide Stellen, sonst wird beim naechsten
  Lesen wieder eine Kopplung vermutet.
- ABNAHME: ein Lauf mit abweichendem `branch`-Attribut schreibt literal auf diesen Branch; Koeder:
  eine Fassung, die den XML-Wert ignoriert, wird ROT.
- REIHENFOLGE: nach S13-27.

### 4.9 FLAECHE I -- E-18-Token-Umstellung

**S13-29 | `anhang:forward` von zwei PATs auf `CI_JOB_TOKEN`**
- IST (17.08., verifiziert): der Job `anhang:forward` (.gitlab-ci.yml:2584) bricht fail-loud ab,
  wenn `COMDARE_THESIS_WRITEBACK_USER`/`_TOKEN` fehlen (:2614-2617, PAT id=98 auf Projekt 289) oder
  `COMDARE_WRITEBACK_USER`/`_TOKEN` fehlen (:2619-2621, PAT id=54 auf Projekt 288). Der Kommentar
  :2580-2583 begruendet die Trennung mit Least-Privilege je Projekt.
- LUECKE: KON86 -- seit GitLab 19.1.4 ist G2 FREI: der `CI_JOB_TOKEN` kann per Job-Token-Allowlist
  projektuebergreifend (288 -> 289) schreiben. Damit entfaellt die PAT-Haltung samt Ablaufdatum
  (id=98 laeuft am 2026-10-15 ab -- nach der Abgabe, aber vor jeder Nacharbeit).
- SCHNITT: (1) Allowlist-Eintrag auf 289 fuer 288 (Infra-Schritt, ausserhalb des Repos);
  (2) im Job die Credential-Aufloesung auf `CI_JOB_TOKEN` umstellen, die PAT-Zweige als
  FALLBACK stehen lassen und erst nach EINEM gruenen Beweis entfernen (ABSCHRIFT schlaegt
  LOESCHUNG); (3) die fail-loud-Pruefung auf den neuen Kanal umschreiben -- sie darf NICHT
  schweigend gruen werden, wenn beide Wege fehlen.
- ABNAHME: EIN gruener `anhang:forward`-Lauf mit literalem Beweis (289-Commit-SHA + Push-Zeile) OHNE
  gesetzte PAT-Variablen; Koeder: ein Lauf mit leerer Allowlist muss ROT werden, nicht still
  ueberspringen.
- REIHENFOLGE: unabhaengig von A-H; kann parallel laufen. Die Infra-Haelfte (Allowlist) ist
  Voraussetzung und sollte VOR dem 25.08. gesetzt sein.

--------------------------------------------------------------------------------------------------

## 5. XSD-AENDERUNGS-LISTE -- EIN SCHEMA-ZUG (D-3)

Datei: `Code/test_data_xml/experiment_schema.xsd` (682 Z., Stand 17.08.). Alle Aenderungen additiv,
`minOccurs="0"`, ans Sequenz-ENDE; `version` bleibt v2; Bestands-XMLs byte-unveraendert valide.

    X-1  OutputType (:665-680): neues Kind <export> ans Sequenz-Ende            -> S13-04
         <export><target method="..." class="..." scope="..."/>...</export>
    X-2  OutputType: neues Kind <publish> ans Sequenz-Ende                      -> S13-27
         <publish><artifact class="..."><target type="..." .../></artifact>...</publish>
    X-3  OutputType: neues Kind <rebuild> ans Sequenz-Ende                      -> S13-26
         <rebuild><stage name="..." force="..." scope="..."/>...</rebuild>
    X-4  NEU <mess_speicher arena_reserve_bytes ram_warn_bytes ram_oob_bytes>
         als GESCHWISTER von <drift_gate> -- NICHT an run_options              -> S13-05 (B-03)
    X-4b drift_gate-XSD-Luecke im SELBEN Zug schliessen (KON94-02-Auflage)     -> S13-05
    X-5  Root-Sequenz bzw. Mengen-Block: BAU-Menge / MESS-Menge getrennt        -> S13-20 (B5)
    X-6  Kommentar an RunMethodologyType (:289-291) und WritebackMethodsType
         (:308-310): Registry ist Single-Source, die HAERTE liegt im Validator  -> S13-19
    X-7  Kommentar an OutputType: <storage> bleibt der inerte 59-C-Slot; bei
         Widerspruch zu <publish> gewinnt <publish> (+ Warnung)                 -> S13-27/R7
    X-8  uniform-SCHALTER in die publish/export-Familie (KON95-03(d))           -> S13-32/S13-27
    X-9  WURZEL-WAHL: 'artifacts' ODER 'binaries+measurement' (KON91-01)        -> S13-12/S13-27

**X-4 -- KORREKTUR 17.08.2026 (A2.5-Fix, Fund 7).** Die erste Fassung setzte `<arena>` mit den
Attributen (ram_warn, ram_oob, capacity) an die Root-Sequenz. Das weicht unbegruendet vom
KON94-02-Hebel ab und traegt zwei Risiken. Ledger verbatim (am Original nachgelesen):

    "XML-HEBEL-VORSCHLAG: neues Element <mess_speicher arena_reserve_bytes ram_warn_bytes
     ram_oob_bytes> als Geschwister von <drift_gate> (dessen Parser-Muster inkl. Doppel-Speisung),
     NICHT an run_options (ctest-Zeichengleichheits-Wache); XSD ohne Schema-Defaults;
     drift_gate-XSD-Luecke im selben Zug."

Uebernommen wird der Hebel woertlich: Element `<mess_speicher>`, Platz als Geschwister von
`<drift_gate>`, Parser-Muster von `<drift_gate>` inklusive Doppel-Speisung, **keine
Schema-Defaults** (die Defaults leben als `constexpr` im Code, D-3). Das Attribut heisst
`arena_reserve_bytes` und benennt damit, was es ist: die PLANER-RESERVIERUNG zu Experiment-Beginn.
Das urspruengliche `capacity` faellt ersatzlos -- es war undefiniert und laed dazu ein, als
aenderbare Arena-Groesse gelesen zu werden; genau das verbietet KON93-C6 ("FEST/STATISCH").
Die Reservierung ist nach oben durch den 6-GB-Deckel begrenzt (S13-05); eine Reservierung ueber
dem Deckel ist ein Validator-ERROR, keine Anhebung.
**X-4b** zieht die vom Ledger im selben Zug verlangte `drift_gate`-XSD-Luecke mit -- sie ist die
Vorlage, deren Parser-Muster X-4 kopiert; beide im selben Commit, sonst kopiert X-4 ein Muster,
das im Schema gar nicht steht.

**X-8 (uniform-Schalter).** Ledger (KON95-03(d)): *"GLOBAL-UNIFORM ist eine NACHTRAEGLICH per XML
forderbare Umschaltung, KEIN Default"* und *"der XML-Hebel (uniform-Schalter) geht in die S-13-
<publish>/<export>-Familie (#18/#48/#57, Di 25.08.)"*. Der Schalter kippt die Spaltenbildung aus
S13-32 von feingliedrig-disjunkt (Default) auf global-uniform. Abwesend = Default = disjunkt.

**X-9 (Wurzel-Wahl).** KON91-01(3), am Ledger-Original nachgelesen: *"WURZEL-WAHL per XML: gemeinsam
'artifacts' ODER getrennt 'binaries'+'measurement' **VOR dem Gattung+Genus-Baum** (getrennt =
DEFAULT)"*. Das Design zitierte die Regel in S13-12-IST, ohne sie zu bauen; hiermit ist sie ein
Schema-Posten mit Validator-Wache (unbekannte Wurzel-Form = ERROR).

**X-9 -- ZWEI NACHTRAEGE aus der A2.5-Runde 2 (NEU-S1):**

*(a) INERTNESS-WACHE, sonst verletzt X-9 das eigene R9-Muster.* Schema + Validator allein machen
den Nicht-Default `artifacts` zu einer Deklaration ohne Wirkung -- genau die Klasse
DEKLARIERT-INERT, die R9 (S13-27) fuer `planner_binary@lager` als ERROR fuehrt und die das
`<storage>`-Slot-Vorbild als abschreckendes Beispiel traegt. **Auflage:** solange die
`artifacts`-Wurzel im Baum-Writer nicht umgesetzt ist, meldet der Validator sie als ERROR
*"artifacts deklariert, aber Baum-Umsetzung fehlt"* -- LAUT statt still (Doktrin: erst laute
Fehler, dann verschieben). Der Default `binaries`+`measurement` bleibt davon unberuehrt und
valide. Koeder: ein `artifacts`-XML, das ohne Fehler durchlaeuft, wird ROT.

*(b) DIE ORDNUNGS-FRAGE IST OFFEN und bekommt hiermit einen Traeger.* Zwei owner-verankerte
Ordnungen stehen gegeneinander, und dieses Design fuehrte sie bis zur Runde 2 unmarkiert
nebeneinander (S13-12-IST gegen S13-25):

    KON91-01(3), 16.08.  die Wurzel-Wahl liegt VOR dem Gattung+Genus-Baum
    K1-Owner-Wort, 09.08. (gebaut)  lager_baum_writer.hpp:14-16 -- Ebene 1 gattung,
                                    Ebene 2 genus, Ebene 3 realm=<binaries|messdaten>,
                                    also die Realm-Wahl UNTER dem Baum

  Das juengere Wort (KON91-01) gewinnt nach Rangfolge -- aber die Umsetzung waere eine
  UMSTELLUNG DER LAGER-KASKADE, und die steht in den S-6-VERBOTSZONEN (Wellenplan Par.19.1/A-10),
  die S13-25 selbst zitiert. **GRENZE, ausdruecklich:** X-9 baut in diesem Buendel NUR Schema,
  Validator und die Inertness-Wache aus (a). Die BAUM-Umstellung ist NICHT Teil des
  Di-25.08.-Buendels und darf nicht nebenbei mitgemacht werden.
  **Traeger:** OV-S13-6 (10.3) -- Owner-Ein-Satz, ob die Wurzel-Wahl wirklich VOR den Baum soll
  (dann Kaskaden-Umbau nach dem #15-Bruch, eigener Posten) oder ob die gebaute Ordnung
  (realm auf Ebene 3) das juengere Wort bereits sachgerecht umsetzt. Faellt die Antwort auf
  "vor den Baum", ist das ein W3-Posten mit Verbotszonen-Freigabe, kein W2-Nebenzug.

Gegenstueck im Code (EIN Commit mit X-1..X-9): `validate_profile.hpp` bekommt die harten Pruefungen
R1-R9 (publish), die Registry-Enum-Wachen (writeback_methods, run_methodology), die
Mengen-Trennungs-Wache und die rebuild-Stage-Wache -- je mit eigenem Pruef-Zaehler, alle fail-loud
als `errors`, benannte Ausnahmen als `warnings`.

**Wachen ueber dem Schema-Zug:** (W-A) alle Bestands-XMLs validieren unveraendert; (W-B) die
golden-XML bleibt byte-identisch; (W-C) je neuem Element ein Koeder-XML, das ROT beisst, in Debug
UND Release, gcc UND clang.

--------------------------------------------------------------------------------------------------

## 6. REIHENFOLGE-ZWANG

    (1) VOR dem Buendel, fremde Pakete
        #15-Bump-Bruch (F2, Fr 21.08.) -- traegt A-09 (FullJoin-Umbenennung, golden-byte-wirksam)
        und die S-6-VERBOTSZONEN. Solange er nicht gelandet ist, bleibt die POD-Haelfte von
        S13-11 GESPERRT. (S13-25 haengt NICHT mehr daran: die Wurzelebenen sind gebaut, der
        Schritt ist reiner Test-Zubau -- siehe 4.7.)
        #16 golden-Fenster -- ERLEDIGT (17.08., ce 04ac26fa, CI 15937).

    (2) Innerhalb des Buendels
        Schema-Zug (X-1..X-9 + Validator)      -> gibt S13-04, S13-05, S13-19, S13-20, S13-26,
                                                  S13-27, S13-32 frei   [X-4 -> S13-05: A2.5-Fund 7]
        S13-01 (CSV wird Kind)                 -> S13-02 (Filter)  -> S13-03 (per-Binary)
        S13-02                                 -> S13-09 (Drain), S13-27 (publish-Wirkung)
        S13-03                                 -> S13-14/-15 (Blattzahl, Familien)
        S13-03                                 -> S13-17 (Namens-Trennung Resume/Auswerte-CSV)
        S13-05 (6-GB-Deckel)                   -> S13-07 (Abbruch braucht den Ausloeser)
        S13-07                                 -> #13/T-15b (Retry darf Arena-voll nicht wiederholen)
        S13-08/A11(2) (Ebenen-Zuordnung)       -> S13-10 (Spaltenmenge)
        S13-08 (Deskriptor-Tabelle)            -> S13-31 (Pivot deskriptor_ix -> Spalte)
        S13-10                                 -> S13-12
        S13-32 (Spaltenfunktion)               -> S13-31 (Aggregator) -> S13-09, S13-14
        S13-14                                 -> S13-07-Legendenhaelfte (Ueberlauf-Zeile im INFO)
        S13-14/-15                             -> S13-18 (Folge-Blatt braucht Namens-Grammatik)
        S13-14/-15                             -> S13-23 (INFO-Blatt traegt die Stempelzeile)
        S13-21 (LB-4)                          -> S13-22 (LB-5) -> S13-23 (LB-6) und -> S13-26
        S13-22                                 -> S13-26 (Stempel-Fund erst mit Blattfunktion)
        S13-22                                 -> S13-27 (R9 meldet sonst dauerhaft ERROR)
        S13-25 (frei, kein #15-Zwang)          -> S13-16 (Filesystem-Hierarchie)
        S13-16                                 <-> S13-14 (dieselbe Hierarchie, zwei Seiten)
        S13-17 (Namens-Fassade)                -> S13-27 (publish adressiert ueber diese Namen)
        S13-27                                 -> S13-28 (AF_BRANCH liest die publish-Klasse)

    (3) VOR dem Trigger Mi 26.08. 06:00, unabhaengig von der Buendel-Reihenfolge
        S13-05/-06/-07 (Arena, binary-beruehrend; mit #13/T-15b im Mess-Fenster Sa/So 22./23.08.)
        S13-24 (Host-Belegung -- sonst faehrt die Kampagne mit inerter Ebene 1)
        S13-21 (Bestandslog scharf -- sonst ist der Skip nicht belastbar)

    (4) Frei / parallel
        S13-29 (E-18-Token) | S13-13 Stufe 1 (Kollisions-Wache) |
        S13-30 (K-D1 Tooling->MessEbene-Abbildung)
        [S13-18 stand hier bis zur A2.5-Fix-Runde; seit dem Umschnitt auf die Folge-Blatt-Politik
         ist er gebunden -- nach S13-14/-15 und mit S13-09, s. 6(2). Nicht mehr frei.]

    (5) Lande-Ordnung
        Parallel bauen, sequentiell landen. Die Landung harmonisiert Vertraege und Schnittstellen:
        `validate_profile.hpp`, `experiment_schema.xsd` und die Test-CMakeLists sind die
        Ueberschneidungs-Flaechen aller Straenge -- dort wird harmonisiert, nicht nur gemergt.
        Geteilte Zaehlwerke (ctest-Bilanz, Inventar-Floor) am Ende EINMAL live messen, nie Deltas
        addieren. Ein Auto-Merge auf diesen drei Dateien ist Anfangsverdacht.

--------------------------------------------------------------------------------------------------

## 7. ABNAHME

### 7.1 Gezaehlte Designplan-Pflichten, je Schritt zugeordnet

    T-12c(1) Kapazitaet 6 GB fest/statisch, Reservierung nur zu Beginn       -> S13-05
    T-12c(2) virtuelle Thread-Slots, Obergrenze CT-bekannt, Puffer statisch  -> S13-06
    T-12c(3) UEBERHOLT -- der Designplan-Wortlaut "weiterlaufen + zaehlen +
             melden" ist durch KON93-02/KON94-02 (P2-Wort 16.08.) umgekehrt:
             volle Mess-Arena = HARTER ABBRUCH, failed ohne Retry, Bestand
             persistieren. Gebaut wird die OWNER-Semantik (Rangfolge OWNER >
             PLAN); der UEBERHOLT-Marker im Designplan ist ein FREMDER Zug
             (VL-5, Lead) und NICHT Teil dieses Buendels.               -> S13-07
    T-12c(4) Hot-Path-Reinheit (kein Alloc, kein I/O, EIN Deskriptor)        -> S13-08
    T-12c(5) IN-ohne-OUT-Invariante je (Prozess, Thread, Interface)          -> S13-07
    T-12d(1) Spaltenmenge E(A) MIT Bezugsgroesse seg_run_total_ns            -> S13-10
    T-12d(2) markierter Leerwert: ECHT-0 != Auslass                          -> S13-11
    T-12d(3) Full-Join verwirft nichts                                       -> S13-12
    T-12d(4) Namens-Wache FullJoin bis 19.1/A-09                             -> S13-13

### 7.2 Abnahme-Normen ueber ALLEN Schritten

- **T-11b Kombibau-2x2-Matrix:** jede Landung ist erst gruen, wenn {clang, gcc} x {Debug, Release}
  = 4 Zellen je J-1..J-4 + ctest durchlaufen sind, je mit literaler ctest-Bilanz. Der Kombibau
  zaehlt als EIN Bau-Slot, die Zellen laufen sequentiell.
- **T-11c Mutations-Protokoll:** je NEUEM Test mindestens eine protokollierte Wegwerf-Mutation mit
  literalem Rot und Gegenprobe-Gruen. **Die Koeder-LAENGE/-FORM wird geprueft, BEVOR die Mutation
  zaehlt** (M-F2-Lehre: 63-statt-64-Zeichen biss aus dem falschen Grund).
- **Vollbau-Luecken:** Werkzeuge zuerst (`adhoc_emitter_cli`, `anatomy_codegen_cli`, alle
  `*_registry_gen`), dann RE-CONFIGURE, dann Vollbau -- sonst ist das Gruen falsch.
- **Warnungs-Review zweimal:** GCC, dann aufraeumen und clang-Bau, dann clang.
- **Bauweg:** `configure.sh` / `make` / `make install` / `make check` im WURZELORDNER beider Repos.
  Keine Shell-Proben statt Google-Tests; Debug UND Release.
- **Ein gruenes Gate deckt nur seinen Gegenstand:** vor jeder Freigabe BEIDE Mengen nennen --
  was geprueft wurde UND was nicht.

### 7.3 Was dieses Design NICHT abgenommen hat (ehrliche Nicht-Deckung)

Die folgenden IST-Aussagen stammen aus den Karten bzw. der Task-Karte #57 und wurden hier NICHT am
heutigen Objekt nachgemessen. Sie sind vor dem Bau je Posten zu erheben (Verify-Anhang, Schritt 0
des Bau-Tages):

    S13-26  Teilprojekt-Commit-Skip ("0 Treffer" aus #57 uebernommen, hier nicht nachgemessen)
    NEU-S1  Ordnungs-Frage der Lagerbaum-WURZEL (X-9 / S13-25): siehe die Traeger-Zuweisung in 5/X-9
            und OV-S13-6 in 10.3 -- am Objekt gemessen, aber owner-seitig unaufgeloest

**ERLEDIGT 17.08. (A2.5-Fix-Runde) -- diese Posten standen bis dahin in der Liste oben und sind
NACHGEMESSEN.** Sie bleiben hier NUR als Spur ihrer Herkunft stehen, nicht als offene Punkte:

    S13-21  die drei Resume-Haerten -- NACHGEMESSEN: zwei GESCHLOSSEN (Korn-Divergenz per
            plan_slice_korn :1478; F4-Zaehler teil-gehaertet :3280-3284), eine ist ABSICHT
            (Praefix, planner_status_reader :22-25/:140-141) -> Schnitt geschrumpft, s. 4.7
    S13-03  die heutigen Iterator-Zeilennummern -- NACHGEMESSEN: :318-320, :1364, :3101/:3110,
            :3170-3172 in experiment_tree/cache_engine_builder_iterator.hpp (3336 Z.), s. 4.1
    S13-11  ob `measurement_snapshot.hpp` blind kopiert -- NACHGEMESSEN: NEIN, seit M-3a
            (:145-146, Gates :175-179); tragend bleibt die POD-Haelfte (:53/:159), s. 4.3
    S13-22  Planer-Blattfunktion -- NACHGEMESSEN: 0 Treffer im Baum-Writer, Befund BESTAETIGT
    S13-25  Ebenen-Bestand -- NACHGEMESSEN: gattung/genus/realm :14-20, Realms :33-40/:42-48,
            Befund BESTAETIGT (B-08 gebaut)

**Nachgemessen und damit GEDECKT sind:** die gesamte A9-/Ergebnis-Mappen-Schicht, die
Naht-Verdrahtung, `WritebackMethod::Xlsx`, die XSD-Enum-Luecke, die Arena-/Checkpoint-Schicht samt
Ueberlauf-Befund und Deskriptor-Index, die Instrument-zu-MessEbene-Bindung, die B5-Emitter-
Asymmetrie, die B3-Host-Belegung, die CSV-Namenslage im super, `csv_to_latex`-Konsumenten,
`AF_BRANCH`, der E-18-Kanal, der Lager-Baum-Writer samt B-08-Wurzelebenen und Realm-Policies,
die Planer-Null und der CEB-Teilstand.

--------------------------------------------------------------------------------------------------

## 8. WAS AUSDRUECKLICH NICHT INS BUENDEL GEHOERT

    PDF-Erzeugung als Rueckschrieb-Methode
        KON27-02 + KON23-03: die vier ct-gesicherten Methoden sind csv, latex_table,
        comparison_metrics, xlsx. PDF ist AUSSERHALB. <publish class="pdf"> adressiert nur die
        ABLAGE eines fertigen PDFs, nie seine Erzeugung.

    Ebene A (GitLabs eigener Runner-Cache)
        Owner-Antwort auf Frage 2 = (a): Ebene A bleibt config.toml-nativ. Sie traegt nur
        ccache + Tools, kann keine Traeger-Stufen unterscheiden und existiert bei der lokalen
        Komplett-Durchfuehrung gar nicht. Eine XML-Wahl waere technisch leer.

    Ersatz der SOTA-/Vergleichs-Rechnung, Break-Even, Selektor-Richtungen
        Break-Even lebt in der CEB nach Messungs-Schluss im RAM (r4 C-3); die zwei divergierenden
        Implementierungen (heuristik/ gegen best_binary_selector/) und die MAX/MIN-Richtungsfrage
        (r4 C-5) sind eigene Posten -> W4-Vorbereitung bzw. Owner-Vorlage.

    Die Kanal-Naht Planer<->CEB (B-01, B-02, B-04, B-14)
        Drei Nachrichtenklassen hinauf, gefiltertes XML, Sync-Barriere, sechs Steuerdocks:
        gehoeren zu S-8/S-10/#20, nicht in dieses Buendel.

    S-12 CI-Geruest (#3) und System B (#24-B4)
        Landen am selben Tag, sind aber eigene Taskkarten mit eigener Abnahme.

    Der volle Monolith-Split (#29-Rest / #88)
        W7, "beim Aufraeumen" (Owner).

    Paper-Kopplung / PV-4
        Owner-GO 08.08. existiert ("Ja unter sorgfaeltiger Design Planung bitte bauen, Ruecksprache
        mit mir im Detail"), aber das Feature hat 0 Code-Treffer und keine Owner-Vorlage. Es gehoert
        NICHT in diesen Slot; es braucht zuerst die Ruecksprache.

    Alles Golden-Byte-Wirksame
        gehoert in den #15-Bruch (F2, Fr 21.08.), nicht hierher: A-09-Umbenennung und die
        POD-Erweiterung aus S13-11. (Die Lager-Kaskaden bleiben unangetastet -- S13-25 ist reiner
        Test-Zubau und faellt deshalb NICHT unter die S-6-Verbotszonen.)

    Der Ersatz des rohen CSV-Pfads OHNE Owner-Deckung
        Der Naht-Kopf nennt ihn "Owner-freizugebend". Die Freigabe LIEGT (Owner 09.08. 16:31, die
        CSV ist Kind der xlsx) -- deshalb ist S13-01 im Buendel. Eine darueber hinausgehende
        Aenderung der SPALTEN oder des HEADERS ist es nicht.

--------------------------------------------------------------------------------------------------

## 9. AUFWANDS-/SLOT-SCHAETZUNG -- ALLES SCHAETZUNG, KEINE MESSUNG

Kein Posten dieser Spalte ist gemessen. Grundlage: Vergleich mit gelandeten Paketen aehnlichen
Zuschnitts (S-1 Stempel-Basisklasse = 13 Dateien / 1 Slot; S-14a Riegel = 3 Slots; B2 Gate-Trennung
= 1 Slot + Nachstufe). "Slot" = ein Bau-Abschnitt nach A2.1, der Kombibau zaehlt als EIN Slot.

    Schritt              Zuschnitt                                    Slots (SCHAETZUNG)
    -------------------- -------------------------------------------- ------------------
    Schema-Zug X-1..X-9  XSD additiv (jetzt 9 Posten inkl. mess_speicher,
                         drift_gate-Luecke, uniform-Schalter, Wurzel-Wahl)
                         + Validator R1-R9 + 3 Enum-Wachen                     1,4
    S13-01/-02           CSV wird Kind + Ziel-Filter (2 Naehte, T-6) +
                         Fehlend-Fall + Projektions-Scope (A2.5-Fund 12)      1,3
    S13-03               per-Binary-Mappe + Resume-Vertrag (A2.5-Fund 4)      0,9
    S13-04               Export-Element (Code-Anteil)                         0,3
    S13-05..-09          Arena-REST: 6-GB-Deckel + Slots + Drain + AUSWERTE-
                         Wache -- PLUS Ueberlauf-UMBAU auf Abbruch
                         (A2.5-Fund 1; vorher als Wache mit 0,8 gefuehrt)     1,6
    S13-30               K-D1 Tooling->MessEbene-Abbildung + static_assert     0,3
    S13-10..-13          Full-Join (4 gezaehlte T-12d-Pflichten)              1,0
    S13-31               E4-Aggregator: Join-Ort + ZWEI Modi (A2.5-Fund 2)    1,0
    S13-32               FJ-1 schicht-parametrisch + FJ-2 beide Quellen       0,8
    S13-14/-15           Blatt-Harmonisierung A21<->KON88 + Hyperlinks +
                         eine Factory (A2.5-Fund 11)                          1,2
    S13-16               Filesystem-Hierarchie                                0,5
    S13-17               ergebnis_dateiname.hpp + CSV-Factory + Migration     1,5
    S13-18               E5 Folge-Blatt-Politik statt Wurf (A2.5-Fund 3;
                         vorher als reiner Test mit 0,2 gefuehrt)             0,8
    S13-20               B5 XML-Trennung (Emitter-Anteil)                     0,8
    S13-21               LB-4 + EINE Rest-Haerte + Korn-Wache (A2.5-Fund 8;
                         vorher drei Haerten mit 1,5 -- zwei sind zu)         0,8
    S13-22               LB-5 drei Blattfunktionen                            1,5
    S13-23               LB-6 Basis-Tests (2 Dummy- + 2 Produktiv-Strategien) 1,5
    S13-24               B3 + B9 (EIN Vertrag)                                1,0
    S13-25               B-08 Beweis-Seite LB-2/LB-3 (Ebenen sind gebaut)     0,6
    S13-26               rebuild-Flag + Teilprojekt-Skip                      0,8
    S13-27/-28           publish-Wirkung + AF_BRANCH                          1,0
    S13-29               E-18-Token (Repo-Anteil; Infra separat)              0,3
    -------------------- -------------------------------------------- ------------------
                         SUMME (22 Posten)                                   ~20,9 Slots

**Der ehrliche Satz dazu:** ~21 Slots passen NICHT in den einen Tag Di 25.08. Der Tag traegt die
LANDUNG des Buendels, nicht seinen Bau. Der Bau verteilt sich auf das WE 22./23.08. (Vorstaffel,
parallel zu #7/S-19 und #13/T-15b) und Mo 24.08.; disjunkte Straenge laufen parallel (6+ zugelassen,
sofern DISJUNKT), die Landung ist seriell. Reisst der Slot, ist die Fall-Reihenfolge nach
Wirkungsklasse: zuerst fallen S13-13-Stufe-2, S13-16, S13-30, S13-25; **NIE fallen duerfen**
S13-24 und S13-21 (Trigger-Voraussetzungen), S13-01/-02 (der Owner-Satz KON32-01),
**S13-05/-07 (die Arena-Abbruch-Semantik -- sie ist binary-beruehrend und nach dem Trigger
entwertet)** und **S13-03 (der Resume-Vertrag; ohne ihn faehrt die Kampagne ohne Wiederanlauf)**.

**Die Fix-Runde hat den Slot-Bedarf um rund 4 Slots erhoeht** (17,1 -> 20,9): S13-07 wurde vom
Wach- zum Umbau-Posten (+0,8), S13-18 vom Test- zum Bau-Posten (+0,6), S13-03 traegt den
Resume-Vertrag (+0,4), zwei FJ-Schritte kamen neu hinzu (+1,8), der Schema-Zug waechst um zwei
Posten (+0,4), S13-14/-15 und S13-01/-02 tragen die Harmonisierungen (+0,5) -- gegengerechnet
schrumpft S13-21 um 0,7, weil zwei der drei Haerten am Objekt bereits geschlossen sind. Das ist
kein Umfangs-Zuwachs des Gegenstands, sondern eine Korrektur der Schaetzung an der Wirklichkeit.

Diese Zahlen sind vor dem Bau gegen die S-19-Ergebnisse (Sa 22.-Mo 24.08.) zu halten -- S-19
produziert die Bau-Nenner und kann die Arena-Posten verschieben.

--------------------------------------------------------------------------------------------------

## 10. OFFENE DESIGN-ENTSCHEIDE UND OWNER-VORLAGEN

### 10.1 Im Design ENTSCHIEDEN (kein Owner noetig)

    D-1  w/ma/mi = drei MESS-BEREICHE; Instrument und Gegenstands-Ebene sind BIJEKTIV und
         compile-time gebunden (konfiguration.hpp:107/114/126 + InstrumentConcept + 3 static_assert).
         Pfad und Blatt tragen MessEbene {compare, macro, micro}; PMC und Zeitquelle sind SPALTEN.
         Kein Owner noetig -- der Schnitt IST gebaut. Neue Wache K-D1 (S13-30) gegen den Drift der
         zwei Deklarationen desselben Tripels.
    D-2  Mappe = Stamm, CSV = Kind (Owner 09.08. 16:31 verbatim).
    D-3  EIN additiver Schema-Zug, XSD strukturell, Validator hart.
    D-4  EIN Baum-Writer, ZWEI Realms, ZWEI Praefix-Zaehler (kompiliert/gemessen).
    D-5  Nichts Golden-Byte-Wirksames im Buendel.
    B9   Option 2 (stempel-abgeleiteter Name im Iterator, batch_plan_datei = Praefix).
         Option 3 ist ausdruecklich falsch.
    S13-19  Enum-Haerte im Validator statt xs:enumeration (Single-Source-Argument).

### 10.2 Owner-Vorlagen -- je EIN Satz, kein Bau haengt daran

    (keine. Die urspruenglich hier vorgesehene Benennungs-Frage `w` gegen `compare` ist am Objekt
    beantwortet: der Code fuehrt BEIDE Namen bereits nebeneinander -- `"wallclock"` als Token-Seite
    im Stempel und in der XML, `"compare"` als Pfad-/Blatt-Seite. Es gibt nichts vorzulegen.)

### 10.3 Owner-Vorlagen -- hier HAENGT Bau daran

    OV-S13-2  ETA-Merge (r5 A48/A50): `merge_documents` verwirft heute still -- bei gleichem Rang
              gewinnt die gefuellte `eta_s`, jede zweite Fortschreibung derselben offenen
              Reservierung faellt weg, waehrend `store()` `true` meldet. Der Schnitt liegt fertig:
              EIN `last_update_utc` (syntax-Bump, ans ENDE der Feld-Folge wegen Byte-Stabilitaet)
              loest Merge-Konflikt UND Uhr-Anker -- "ein Feld, zwei Defekte, ein Bump".
              FRAGE: geaenderte Konflikt-Aufloesung ODER monotones Ordnungsfeld?
              ZUSATZ: ist ETA nur der Lease-Timer oder auch Dispositions-/Kapazitaetswert? Davon
              haengt ab, ob `avg_size_bytes` der Eingang in die df-Wache wird (Par.V7.4).
              Heute kein Live-Pfad -- wird scharf, sobald periodische Updates gebaut werden.

    OV-S13-3  PMC-Flag-Felder im Mess-POD (r4 B-07): die feinkoernige PMC-Wahrheit geht am POD
              verloren; heilbar nur ueber Flag-Felder und damit NEUE CSV-Spalten. Das ist
              golden-byte-wirksam und muss deshalb in den #15-Bruch ODER ausdruecklich vertagt
              werden. FRAGE: mit in den Bruch, oder markierter Leerwert vorerst nur in der
              Darstellung?

    OV-S13-6  LAGERBAUM-WURZEL-ORDNUNG (A2.5-R2/NEU-S1): KON91-01(3) vom 16.08. setzt die
              Wurzel-Wahl ('artifacts' ODER 'binaries'+'measurement') VOR den Gattung+Genus-Baum;
              der gebaute Writer traegt `realm` auf EBENE 3 UNTER gattung->genus (K1-Owner-Wort
              09.08., aelter). Beide Saetze sind owner-verankert, das juengere gewinnt formal --
              aber die Umsetzung waere ein Kaskaden-Umbau in den S-6-VERBOTSZONEN (A-10).
              FRAGE: soll die Wurzel-Wahl wirklich VOR den Baum (dann eigener Posten NACH dem
              #15-Bruch, mit Verbotszonen-Freigabe), oder setzt die gebaute Ordnung das juengere
              Wort bereits sachgerecht um? Am X-9-Schema-Anteil haengt nichts davon; an der
              Baum-Umsetzung haengt alles. Bis zur Antwort baut S13-25 NICHTS an den Ebenen.

    OV-S13-5  BLATTZAHL-SCHNITT (A2.5-Fund 11): r5 A21 (~09.08.) gibt die Formel
              "1 + |Funktionen| + |Achsen|"; KON88-P1 (16.08., juenger) legt w/ma/mi ins
              FILESYSTEM, macht die Baum-BLAETTER zu xlsx-DOKUMENTEN und zaehlt IM Dokument
              EIN Sheet je UNTER-Achse. Das Design merged (4.4): |Funktionen|/|Achsen| werden
              ORDNER, die Formel wird zum Navigations-Bild, die A21-Hyperlink-Mechanik bleibt.
              FRAGE: traegt dieser Merge -- oder war die A21-Formel als SHEET-Zahl EINER grossen
              Mappe gemeint? Am Merge haengt die Zaehl-Abnahme von S13-14 und der Schnitt von
              S13-16.

    OV-S13-4  B7/F8 (r3 B7, nie beantwortet): gilt "gleicher Fingerprint => Messwerte uebertragbar,
              AUCH nach einem Neubau" uneingeschraenkt? Gebaut wurde bewusst KEIN Verbot, nur eine
              Erwartung. Hinweis zur Aufloesung: die KON64/65-Idempotenz-Doktrin ("je Kind-Belegung
              perfekt angepasstes CEB-Kompilat") beantwortet die Frage der Sache nach mit JA -- es
              fehlt nur der Marker. Ein-Satz-Bestaetigung genuegt.

--------------------------------------------------------------------------------------------------

## SELBSTCHECK

ASCII-only: ja (keine Umlaute, keine Sonderzeichen ausserhalb ASCII). Zeilenlaenge: <= 120 Zeichen.

Datierung: alle IST-Aussagen tragen ihr Erhebungsdatum; die am 17.08.2026 am Objekt gemessenen
Posten sind als "verifiziert" markiert, die uebernommenen Karten-Befunde als solche kenntlich, und
Abschnitt 7.3 nennt die NICHT nachgemessenen Posten vollstaendig und namentlich.

Jede Zahl traegt Nenner oder Fundstelle. Nichtfunde sind mit Gegenprobe versehen:
`ergebnis_dateiname.hpp` | `measure_to_latex` | `batch_plan_datei` im Mess-Driver | xlsx im super |
Sheets im super | LB-2..LB-6-Test-TUs | `ram_warn`/`ram_oob` | "6 GB"-Konstante in
`measure_storage/` und `mess/` | Thread-Slot-Vergabe in `mess/*.hpp`.

Owner-Zitate sind verbatim mit Karten-Anker. Die Schaetzspalte in Abschnitt 9 ist als SCHAETZUNG
deklariert und nirgends als Messung ausgegeben.

Der w/ma/mi-Schnitt (r4 C-2) ist in D-1 ENTSCHIEDEN -- und zwar nicht durch Setzung, sondern durch
Befund: die Bindung Instrument <-> Gegenstands-Ebene ist am Objekt compile-time erzwungen
(`konfiguration.hpp:107/114/126` + `InstrumentConcept` + drei `static_assert`). Es bleibt keine
Owner-Frage; stattdessen deckt der neue Schritt S13-30 den einzigen realen Drift-Pfad (zwei
Deklarationen desselben Tripels, heute nur ueber Ordinale verbunden).

WARNUNG AN DEN LESER: dieses Dokument widerspricht der A9-Bauliste r5 A45 und der A43-Haelfte
"Enum dreiwertig" AM OBJEKT. Wer diese Karten spaeter zitiert, zitiert einen Stand vom 08./09.08.
Der hier belegte Stand ist der vom 17.08. an ce 04ac26fa. Vor jedem Bau ist er erneut zu erheben --
dieselbe Regel, die diesen Befund ueberhaupt erst zutage gefoerdert hat.

ZWEITE WARNUNG, aus der A2.5-Fix-Runde gelernt: **dieselbe Regel gilt fuer den MASSSTAB, nicht nur
fuer den Code.** Drei der vier MUSS-Funde waren nicht falsche Code-Aussagen, sondern richtige
Aussagen gegen einen ueberholten Massstab -- die Arena-Ueberlauf-Semantik, das xlsx-Zeilenlimit und
die Blattzahl-Formel standen alle korrekt im Designplan bzw. in den Karten und waren dennoch durch
juengere Owner-Worte (KON88, KON93/94) umgekehrt worden. Wer aus diesem Dokument baut, prueft die
Owner-Linie ebenso frisch wie den Code. Rangfolge OWNER > PLAN, und "der Plan sagt es auch" ist
kein Beleg, sondern ein zweiter Kandidat fuer denselben Irrtum.

FIX-RUNDEN-BILANZ (A2.5, 17.08.):

**Runde 1 -- 13 Funde, 13 BEHOBEN, 0 ENTLASTET, 0 VERTAGT.** Kein Fund liess sich am Objekt
widerlegen; alle Belege des Lens haben der Gegenprobe standgehalten. Neu entstanden: zwei
Bau-Schritte (S13-31, S13-32), zwei Schema-Posten (X-8, X-9), ein Schema-Zusatz (X-4b), eine
Owner-Vorlage (OV-S13-5) und sechs Kanten in Abschnitt 6.

**Runde 2 (Folge-Lens) -- 12 der 13 Erst-Funde als behoben bestaetigt, MUSS-4 teil-behoben;
5 Rest-Posten, alle 5 BEHOBEN, 0 ENTLASTET, 0 VERTAGT.** Der eine unharmonisierte Rest war der
wichtigste: **W5 in S13-27 haette den soeben geschlossenen MUSS-4-Defekt ueber die publish-Flanke
wieder aufgerissen** -- zwei Abschnitte desselben Dokuments, die sich gegenseitig widersprachen,
und der spaetere haette gewonnen, weil er wie eine Abnahme-Regel aussah. Das ist die Lehre dieser
Runde: **ein Fix ist erst fertig, wenn seine Ausnahme an JEDER Stelle steht, die den Gegenstand
regelt** -- nicht nur dort, wo der Fund gemeldet wurde. Dieselbe Klasse trug NEU-S2 (ein
unpropagierter Edit hinterliess zwei Residuen) und NEU-S3 (die alte Ueberlauf-Lesart stand nach dem
Umbau noch an zwei Stellen unmarkiert -- exakt der "zweite Kandidat fuer denselben Irrtum", vor dem
der Absatz oben warnt; er stand im selben Dokument, das ihn benennt).
Neu entstanden in Runde 2: die Inertness-Wache und die Ordnungs-Grenze an X-9, der X-8-Opt-in-
Koeder an S13-32 und eine zweite Owner-Vorlage (OV-S13-6).
