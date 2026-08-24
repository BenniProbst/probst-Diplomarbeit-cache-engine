# SOLL-KARTE -- Strang s13schema (#18-Vorstufe S-13-Schema-Kette)

Erhoben von: Sonnet-max Planungs-Erheber, 21.08.2026 (NUR LESEN, kein Fix).
Objekt: ce `bau/s13schema` @ ad5c6d66 (Basis 66de5c09, Worktree /home/comdare/wt-ce-s13schema,
HEAD+Commit-Text und Diffstat 10 Dateien +1091/-78 am Objekt bestaetigt) + super `bau/s13schema`
@ 1e92b77e (Basis a7e8e151, Worktree /home/comdare/wt-super-s13schema, HEAD+Commit-Text am
Objekt bestaetigt). Beide Worktrees `git status --porcelain` leer (sauber).
Strang-Bericht (voll gelesen): `/home/comdare/backups-workflow/20260820-w2-sofortstaffel/s13-schema-kette-ergebnis.md`.

Wahrheits-Rangfolge angewandt: Owner-Wort > juengere KON > Wellenplan par.21-23 > par.17-20 >
Designplan > W2-ABFOLGE-DESIGN > Strang-Bericht. Zusaetzlich herangezogen (nicht in der offiziellen
Quellenliste, aber von DESIGNPLAN-tdd par.10 Z.693 UND von W2-ABFOLGE-DESIGN als "K4:TEIL1/D1"
referenziert, und vom Strang-Bericht woertlich zitiert -- "Design 4.1/S13-02" etc.):
`docs/plaene/20260817-DESIGN-s13-buendel-di25.md` (1659 Z., Fassung 3, Stand 17.08.2026). Diese
Datei ist die einzige Quelle, die den Auftrag in Bau-Schritt-Aufloesung mit IST/LUECKE/SCHNITT/
ABNAHME/REIHENFOLGE traegt; ohne sie waere die PRUEFLISTE nur auf Stichwort-Ebene moeglich. Als
"[K4/D1]" zitiert.

--------------------------------------------------------------------------------

## VORBEMERKUNG -- DER STRANG-EIGENE SCOPE-SCHNITT

Der Strang-Bericht erklaert seinen eigenen Auftrag so (Zeile 4-5 des Ergebnis-Dokuments):
"Schema-Zug (X-1..X-9 soweit S13-01..03 brauchen) + S13-01 (CSV=Kind), S13-02 (Ziel-Filter,
4 Faelle), S13-03 (per-Binary-xlsx + Resume-Vertrag). NICHT: Arena, Lager, publish." Das deckt
sich mit LEAD-ENTSCHEIDE Punkt 17 ("... gehoert zu #18/S-13 (S13-03, Staffel-1-Strang
s13-schema-kette) ...") und mit dem Namen des Strangs in STAFFEL1-SYNTHESE Zeile 18
("s13-schema-kette (S13-01..03 + X-6)"). Der Steckbrief dieser Erhebung nennt zusaetzlich
"Export-Element Option b (KON27-02)" als Teil des Auftrags -- dazu siehe SPANNUNGEN Nr. 2, denn
der Strang selbst hat dieses Stueck NICHT gebaut und weist es aktiv einer Folgestaffel zu.

--------------------------------------------------------------------------------

## PRUEFLISTE

### Kern-Deliverables (S13-01/02/03 + Schema-Zug-Subset)

**P-01 | Schema-Zug-Subset X-6 (Kommentar-Fix, Registry=Single-Source)**
WAS: "X-6 Kommentar an RunMethodologyType (:289-291) und WritebackMethodsType (:308-310):
Registry ist Single-Source, die HAERTE liegt im Validator -> S13-19" [K4/D1 Abschnitt 5, Z.1225-1226].
D-3-Doktrin: "Alle XSD-Aenderungen des Buendels gehen in EINEN Commit. Alle neuen Elemente sind
minOccurs=0 ... Bestands-XMLs bleiben byte-unveraendert valide" [K4/D1 Z.246-252].
WIE pruefbar: `git show 1e92b77e` im super-Worktree (Kommentar-only-Diff an
`Code/test_data_xml/experiment_schema.xsd` :289-291/:308-310); Gegenprobe `git diff --stat
a7e8e151..1e92b77e` zeigt NUR die XSD-Datei; `xmllint --noout --schema experiment_schema.xsd`
gegen alle vier Instanzen (super `experiment_golden.xml`, super `experiment_golden_kern.xml`,
ce-Spiegel `experiment_golden.xml`, ce `experiment_kern_seam_fixture.xml`).
BEHAUPTET: JA -- "W-A/W-B-Beweis literal: xmllint validates fuer super experiment_golden.xml,
super experiment_golden_kern.xml, ce-Spiegel experiment_golden.xml, ce
experiment_kern_seam_fixture.xml ... Alle Instanzen byte-unveraendert."

**P-02 | S13-01 -- roher CSV-Strom wird KIND der Mappe (beide Naehte)**
WAS: "die CSV-Ausgabe wird zur Projektion der Mappe ... `emit` schreibt NUR noch in die Mappe;
die CSV entsteht am Lauf-Ende ... aus dem Stamm. Fehler im Stamm => KEINE CSV, Exit != 0. Die
Schwesterstelle `profile_run_entry.hpp` bekommt denselben Schnitt (T-6-Regel)" [K4/D1 S13-01,
Z.398-402]. Grund-Doktrin D-2 (Owner 09.08. 16:31 verbatim): "die csv wird doch aus der xlsx
gebildet, IMMER ... eine Zeile erreicht die CSV nur, wenn der Stamm sie angenommen hat" [K4/D1
Z.237-241]. Wellenplan B-11 "measure-drop-Kanal ZWEIFACH heilen ... -> S-13" [Wellenplan par.19.2
Z.2432]. Ledger KON32-01 (12.08., Owner-verbatim): "der Kanal bleibt falsch und muss behoben
werden wie definiert."
WIE pruefbar: `ergebnis_mappe_naht.hpp` (Projektions-Kanal, Stamm-Bruch entfernt CSV sofort);
`profile_run_entry.hpp` + `experiment_run_entry.hpp` (roher `std::ofstream csv` ENTFERNT, T-6
beidseitig); Test `test_s13_01_csv_kind_projektion` (Byte-Orakel golden-Gleichheit, Nur-xlsx-
Abwesenheit, Stamm-Bruch-Koeder, Scope-Zaehl-Wache); T-11c-Mutationen M2 (Naht-catch: remove()
raus -> FAILED StammBruchEntfernt) und M3 (Join ';'->',' -> FAILED ByteIdentisch).
BEHAUPTET: JA -- Bau vollzogen, Tests + zwei benannte Mutationen literal rot protokolliert.

**P-03 | S13-02 -- Ziel-Filter scharf: `<writeback_methods>` entscheidet die Persistenz**
WAS: "EIN Filter-Punkt. `FormatWahl` steuert ausschliesslich die PERSISTENZ-Aufrufe; die
In-Memory-Mappe bleibt bedingungslos ... Default bei fehlendem Block: xlsx" [K4/D1 S13-02,
Z.416-419]. Vier Faelle + Scope-Festlegung (golden-CSV nur aus Ergebnis-Blaettern, NIE aus
Profil-Blaettern) [K4/D1 Z.428-436]. ABNAHME woertlich: "vier Faelle mit literalem
Verzeichnis-Listing: nur-csv / nur-xlsx / beide / Block fehlt (an einem der drei genannten
Bestands-Profile) ... T-11c-Mutation" [K4/D1 Z.437-440]. Ledger KON32-01: "Zweifach zu heilen:
Ziel-Filter (nur Zusammenfassung+Angefordertes nach Ziel 3) UND per-Binary-Format xlsx."
WIE pruefbar: Test `test_s13_02_zielfilter_vier_faelle` (4 Faelle run_profile + 2 Faelle
run_experiment_profile, T-6-Spiegel); T-1-Rot-Protokoll (`[ERR] fall2_nur_xlsx: KEINE
measurements.csv`, `[ERR] fall4_block_fehlt: KEINE measurements.csv`); T-11c-Mutation M1 (roher
ofstream zurueck -> beide Faelle EXIT=1).
BEHAUPTET: JA, MIT DOKUMENTIERTER ABWEICHUNG vom woertlichen 4.-Fall-Rezept -- das Design verlangt
den vierten Fall ("Block fehlt") an einem ECHTEN Bestandsprofil (`base_pilot`, `m3v2_smoke` oder
`wdk_fairness_example`); der Strang hat am Objekt (20.08.) nachgemessen, dass alle 11 getrackten
Profile seit ce `fbe48f99` (14.08.) den Block tragen -- das Design-Fenster (Stand 17.08.) traegt hier
laut eigener IST-Tabelle noch "3 ohne Block" [K4/D1 Z.411-412, Z.421-423], was zum Objektstand
20.08. nicht mehr passt (siehe SPANNUNGEN Nr. 3). Der Strang hat den 4. Fall deshalb mit einem
TEST-LOKALEN Profil gefahren statt mit einem Bestandsprofil -- eine begruendete, selbst dokumentierte
Substitution (self-korrigiert als eigener Befund, in STAFFEL1-SYNTHESE als F-21 gefuehrt).

**P-04 | S13-03(a) -- per-Binary-xlsx statt 320 Einzel-CSVs**
WAS: "je Binary EINE Ergebnis-Mappe ueber dieselbe ErgebnisMappenFactory (der xlsx-Teil von
KON32-01)" [K4/D1 S13-03, Z.473-474]. ABNAHME woertlich: "Zaehl-Test N Binaries => N Mappen + 1
Aggregat-Mappe" [K4/D1 Z.484].
WIE pruefbar: `cache_engine_builder_iterator.hpp` (PerBinaryMappeFn + `cfg.per_binary_mappe`,
No-Op-Default, Aufruf NACH result.csv+stamp); Test `test_s13_03_per_binary_mappe` ("Zaehl-Abnahme
N=3 -> 3+1 Mappen").
BEHAUPTET: JA fuer die Sink-/Vertragsmechanik am Objekt (unit-gebunden). NICHT vollstaendig
gedeckt: die ECHTE Verdrahtung an der per-Binary-Naht im laufenden Mess-Lauf mit ladbaren
Tier-DLLs -- siehe P-22 (eigener Punkt, vom Strang selbst als "ehrliche Nicht-Deckung" deklariert).

**P-05 | S13-03(b) -- Resume-Vertrag `result.csv`+`.stamp` AUSSERHALB des Ziel-Filters**
WAS: "ENTSCHEIDUNG: `result.csv`+`.stamp` sind ein RESUME-VERTRAG und stehen AUSSERHALB des
Ziel-Filters ... werden WEITERHIN und BEDINGUNGSLOS geschrieben ... tragen einen Kommentar, der
genau das sagt" [K4/D1 Z.468-477]. Drei Koeder woertlich: "Koeder 1 -- ein Nur-xlsx-Profil, nach
dem lazy_try_resume_binary keinen Wiederanlauf mehr findet, wird ROT. Koeder 2 -- ein Lauf, nach dem
measurement_sink keine result.csv mehr gereicht bekommt, wird ROT. Koeder 3 -- eine Auswerte-CSV,
die den Resume-Vertrag ueberschreibt, wird ROT. Positivprobe: Nur-xlsx-Profil, Lauf abbrechen,
Wiederanlauf resumiert literal" [K4/D1 Z.484-488]. Diese Design-Entscheidung ist selbst eine
Interpretation der Owner-Worte -- siehe SPANNUNGEN Nr. 1 (load-bearing, nicht kosmetisch).
WIE pruefbar: `mach_per_binary_mappe_sink` (Fassaden-Sink, "result.csv wird NIE angefasst"),
Vertrags-Kommentar am Schreibblock in `cache_engine_builder_iterator.hpp`; Test
`test_s13_03_per_binary_mappe` (Koeder 1 = Resume-Ueberleben, Koeder 2+3 = Byte-Wache),
T-11c-Mutation M4 ("Sink ueberschreibt result.csv -> FAILED Koeder-1-Test UND Koeder-3-Byte-Wache,
2 Tests").
BEHAUPTET: JA -- alle drei benannten Koeder literal rot protokolliert plus Gegeneingang (fremder
Praefix resumiert nicht).

### Uebergreifende Kopplungs- und Prozess-Pflichten

**P-06 | H-6 -- Lande-Kopplung: ce+super im SELBEN Lande-Ereignis**
WAS: "super `bau/s13schema` (1e92b77e) und ce `bau/s13schema` im SELBEN Lande-Ereignis (bindend,
in beiden Commit-Texten). Kommentar-only-XSD => KEIN Instanzen-/Spiegel-Nachzug" [STAFFEL1-SYNTHESE
H-6, Zeile 58-60]; bestaetigt fortgeltend in STAFFEL2-SYNTHESE Zeile 102-103. Dies ist exakt die
"H-6"-Kopplung aus dem Aufgaben-Steckbrief.
WIE pruefbar: `git log -1 --format=%B` in BEIDEN Worktrees -- muss die Gegenseiten-Kopplung im
Commit-Text nennen. Bereits am Objekt bestaetigt: ce-Commit-Kopf "feat(s13/01-03): ... Schema-Zug-
Anfang", super-Commit-Kopf "schema(s13/x-6): Schema-Zug-Subset fuer S13-01..03". Die eigentliche
Kopplungs-Deklaration ("beide Branches im SELBEN Lande-Ereignis") steht laut Strang-ENDSTAND im
Commit-Volltext.
BEHAUPTET: JA -- "LANDE-KOPPLUNG (bindend, in beiden Commit-Texten deklariert): beide Branches im
SELBEN Lande-Ereignis." NOCH OFFEN (nicht Sache dieses Strangs, sondern des Lande-Zugs): die
tatsaechliche GEMEINSAME Landung selbst ist noch nicht erfolgt -- dieser Punkt ist eine ZUSAGE, kein
bereits vollzogener Merge.

### TDD-Vertrag par.3 (T-1..T-9) -- woertlich, je Punkt gegen den Strang gehalten

**P-07 | T-1 ROT ZUERST + T-11c Mutations-Protokoll (T-11c "verschaerft T-1")**
WAS: "T-1 ROT ZUERST. Der Test ist am ersten Tag rot, ODER sein Biss ist per protokollierter
Wegwerf-Mutation bewiesen" [Designplan par.3 Z.67]. "T-11c MUTATIONS-PROTOKOLL ALS ABNAHMEKLASSE
(KON57, verschaerft T-1): ... je neuem Test >=1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-
Gruen ... Koeder-LAENGE/-FORM wird geprueft, BEVOR die Mutation zaehlt" [Designplan par.11 Z.647].
WIE pruefbar: die 5 protokollierten Mutationen M1-M5 im Ergebnis-Bericht (je mit exakter
Fehlermeldung + EXIT=1); Gegenprobe "grep T-11c-MUTATION = 0 Treffer" am fertigen Baum (Reste
entfernt).
BEHAUPTET: JA -- T-1 fuer S13-02 explizit als eigenes "T-1 ROT-PROTOKOLL" mit Datumsstempel und
literalem Output gefuehrt; T-11c fuer alle drei neuen Tests mit 5 Mutationen (M1-M5), je mit
Vorher/Nachher-Zustand.

**P-08 | T-2 AUSSAGE, NICHT ANWESENHEIT**
WAS: "find(), Existenz, Exit 0, 'wirft nicht' sind keine Zusicherungen. Wert, Position, Menge,
Klasse." [Designplan par.3 Z.68].
WIE pruefbar: Pruefen, ob die drei neuen Tests literale WERTE/MENGEN pruefen (Byte-Gleichheit,
Zeilenzahl, Dateizahl N->N+1) statt nur Exit-Codes.
BEHAUPTET: PLAUSIBEL ERFUELLT, ABER NICHT ALS EIGENER T-2-PUNKT BENANNT -- der Bericht zeigt
literale Listings ("[LISTING fall2_nur_xlsx] 2 Datei(en): ...") und Byte-Orakel/Zaehl-Abnahmen,
was der T-2-Substanz entspricht; eine explizite Selbstzuordnung "das ist T-2" fehlt im Bericht.

**P-09 | T-3 NENNER, FREMD**
WAS: "Jeder Test nennt seine Grundgesamtheit und bezieht sie aus einer anderen Quelle als dem
Pruefling" [Designplan par.3 Z.69].
WIE pruefbar: `test_s13_03_per_binary_mappe` -- N=3 als Test-Setup-Konstante (fremde Quelle) gegen
3+1 Mappen aus dem Pruefling.
BEHAUPTET: PLAUSIBEL ERFUELLT (N ist eine Test-lokale, vom Pruefling unabhaengige Vorgabe), NICHT
explizit als T-3 benannt.

**P-10 | T-4 GEGENEINGANG**
WAS: "Zu jeder Zusicherung ein Eingang, bei dem sie nicht gilt." [Designplan par.3 Z.70].
WIE pruefbar: `test_s13_03_per_binary_mappe` -- "Gegeneingang (fremder Praefix resumiert NICHT)"
explizit im Bericht benannt.
BEHAUPTET: JA, EXPLIZIT -- einziger der neun T-Punkte, den der Bericht woertlich mit dem Begriff
"Gegeneingang" fuehrt.

**P-11 | T-5 ORAKEL UNABHAENGIG**
WAS: "Sollwerte im Test gerechnet oder als einmalig erhobene, dann eingefrorene Literale -- nie
aus der geprueften Funktion" [Designplan par.3 Z.71].
WIE pruefbar: Byte-Orakel (golden-Gleichheit) in `test_s13_01_csv_kind_projektion` -- Sollwert ist
die golden-Referenz, nicht die geprueft Funktion selbst.
BEHAUPTET: PLAUSIBEL ERFUELLT, NICHT explizit als T-5 benannt.

**P-12 | T-6 SCHWESTERPFLICHT**
WAS: "Jeder Fix und jeder Test sucht im selben Zug die Schwesterstelle (beide Writer, beide
Genera, beide Backends ...)" [Designplan par.3 Z.72]. Design-doc S13-01: "Die Schwesterstelle
`profile_run_entry.hpp` bekommt denselben Schnitt (T-6-Regel: derselbe Fix an BEIDEN Naehten)"
[K4/D1 Z.401-402].
WIE pruefbar: `profile_run_entry.hpp` + `experiment_run_entry.hpp` -- identischer Schnitt an
beiden Dateien; Test deckt "4 Faelle run_profile + 2 Faelle run_experiment_profile (T-6-Spiegel)".
BEHAUPTET: JA, EXPLIZIT -- der Bericht nennt "T-6" wortwoertlich als Regel-ID an drei Stellen
(Bau-Abschnitt und Test-Abschnitt).

**P-13 | T-7 REGISTRIERUNG IST TEIL DES TESTS**
WAS: "Ein Test existiert erst, wenn er in `ctest -N` erscheint und sein Binary im Bauweg haengt"
[Designplan par.3 Z.73]. Registrierung ans DATEIENDE von `tests/unit/CMakeLists.txt` (TABU-Regel
dieser Erhebung, siehe P-19).
WIE pruefbar: `ctest -N` am Objekt zeigt "#511 test_s13_02_zielfilter_vier_faelle, #512
test_s13_01_csv_kind_projektion, #513 test_s13_03_per_binary_mappe".
BEHAUPTET: JA, EXPLIZIT -- der Bericht fuehrt "T-7" wortwoertlich mit den drei Testnummern.

**P-14 | T-8 ATOMARE LANDUNG**
WAS: "Tag-1-Rot lebt im Feature-Branch; auf `development` landen Test + Minimalbau atomar
(Hart-Gruen-Doktrin bleibt intakt)." [Designplan par.3 Z.74].
WIE pruefbar: Erst am tatsaechlichen Merge nach `development` pruefbar (Merge-Commit traegt Test
+ Implementierung ATOMAR, keine getrennten Nachzuege).
BEHAUPTET: NOCH NICHT FAELLIG -- der Strang ist "LANDEREIF", aber NICHT gelandet; die
Feature-Branch-Rot-Historie liegt vor (T-1 protokolliert), die ATOMARE Landung selbst ist
Gegenstand des nachfolgenden Lande-Zugs, nicht dieses Strangs. Muss beim eigentlichen Merge
geprueft werden.

**P-15 | T-9 TESTKRITIK**
WAS: "Neue Tests jeder Welle gehen in der Folgewelle durch einen Codex-Pass + Objektpruefung."
[Designplan par.3 Z.75].
WIE pruefbar: Codex-Lauf ueber die drei neuen Tests in der NAECHSTEN Welle/Folgestaffel.
BEHAUPTET: NOCH NICHT FAELLIG -- per Definition ("Folgewelle") ausserhalb des Zeithorizonts dieses
Strangs; kein Fund/Anspruch im Bericht dazu.

**P-16 | T-11b KOMBIBAU-2x2-MATRIX**
WAS: "jede Landung ist erst gruen, wenn {clang, gcc} x {Debug, Release} = 4 Zellen je J-1..J-4 +
ctest durchlaufen sind" [Designplan par.11 Z.645]. Design-doc-Abnahme fuer D-1 (W2-ABFOLGE-DESIGN):
"Testseiten T-11c/T-12c/T-12d + alle benannten Koeder; Toleranz (a) endet mit (c); Debug+Release,
gcc+clang" [W2-ABFOLGE-DESIGN D-1, Z.294-295].
WIE pruefbar: 4 vollstaendige Zellen (gcc-Debug, gcc-Release, clang-Debug, clang-Release) je mit
literaler ctest-Bilanz am GEMERGTEN Endstand.
BEHAUPTET: TEILWEISE -- der Strang selbst hat NUR EINE Zelle gefahren ("GRUEN-PROBE (gcc-Release,
volle Treppe J-0b..J-4)"), und deklariert explizit: "4-Zellen-Kombibau T-11b (gcc+clang x
Debug+Release) = Lande-Zug am GEMERGTEN Endstand (Auftrags-Regel)." Das ist KEIN Strang-Defekt
(K17-/H-7-Doktrin verlangt den Kombibau genau einmal, am Endstand, nicht je Einzelstrang) -- aber
die volle Erfuellung von T-11b fuer dieses Paket ist zum Zeitpunkt dieser Erhebung noch NICHT
erbracht und haengt an einem spaeteren Schritt.

### Reihenfolge, Wachen, Formal-Gates

**P-17 | Reihenfolge-Zwang S13-01 -> S13-02 -> S13-03**
WAS: "Schema-Zug (X-1..X-9 + Validator) -> gibt S13-04, S13-05, ... frei ... S13-01 (CSV wird
Kind) -> S13-02 (Filter) -> S13-03 (per-Binary)" [K4/D1 par.6, Z.1314-1316]; identisch verdichtet in
W2-ABFOLGE-DESIGN C-8 (Z.764): "S13-01->02->03".
WIE pruefbar: Reihenfolge im Commit-Verlauf/Bau-Protokoll des Strangs.
BEHAUPTET: JA -- der Strang beschreibt sein eigenes Vorgehen explizit in dieser Reihenfolge
("Plan dieser Sitzung: 1. Schema-Zug ZUERST ... 2. T-1-ROT-Tests fuer S13-01/02/03, dann Bau ...").

**P-18 | W-A/W-B/W-C Schema-Zug-Wachen**
WAS: "(W-A) alle Bestands-XMLs validieren unveraendert; (W-B) die golden-XML bleibt byte-
identisch; (W-C) je neuem Element ein Koeder-XML, das ROT beisst, in Debug UND Release, gcc UND
clang." [K4/D1 par.5, Z.1298-1300].
WIE pruefbar: xmllint-Laeufe (W-A/W-B, siehe P-01); fuer W-C: Koeder-XML-Test nur dort noetig, wo
ein NEUES XSD-ELEMENT entsteht.
BEHAUPTET: W-A/W-B JA (siehe P-01, xmllint-Beweis literal). W-C NICHT ANWENDBAR fuer diesen
Commit -- X-6 ist reiner Kommentar-Fix OHNE neues Element (das neue `<export>`-Element ist X-1,
gehoert zu S13-04, nicht zu diesem Strang); ein Koeder-XML "das ROT beisst" ist daher hier
sachlich nicht gefordert.

**P-19 | TABU-Zonen + Formal-Gates**
WAS (Auftrags-Regeln dieser Erhebung, cross-referenziert mit Design-Doktrinen): nichts unter
axes/topics/heuristik/; golden-Dateien byte-stabil; tests/unit/CMakeLists.txt nur ans Dateiende;
ASCII-only in neuen Zeilen; clang-format-22 ueber jede geaenderte Lint-Datei.
WIE pruefbar: `git diff --name-only 66de5c09..ad5c6d66` gegen axes/topics/heuristik/ (0 Treffer
erwartet); `git diff 1e92b77e` Byte-Diff an golden-Dateien (nur Kommentar, keine Instanz-Datei
veraendert); Position des neuen CMakeLists-Blocks; ASCII-Scan; clang-format-22-Diff = leer.
BEHAUPTET: JA -- "TABU-/Verbotszonen-Probe: 0 Treffer (git diff --name-only). clang-format-22
ueber alle 8 geaenderten Lint-Dateien VOR dem Commit. ASCII-Wachen: 0 Treffer (2 Cyrillic-e-Funde
selbst gefangen und geheilt)."

**P-20 | U-1/Z-1 -- J-1-Rezeptfix (korrekte comdare_-praefixierte Target-Namen)**
WAS: "die realen TARGET-Namen tragen das comdare_-Praefix ... praefixlose ninja-Aufrufe = unknown
target + 'Not Run'-Klasse." Traeger: "ROT-Auflage am Task #18" [Wellenplan par.22.1 U-1, Z.3197-3204].
Wellenplan par.22.4 Z-1 (juengste Schicht): "s13-J-1-Rezeptfix als ROT-Vorbedingung VOR #18 (22.1
U-1; der Fix selbst laeuft FRUEHER im docs-Zug -- Di-25 prueft nur, dass er drin ist)"
[Wellenplan par.22.4, Z.3417-3418]. Bemerkenswert: DAS DESIGN-DOKUMENT SELBST traegt an dieser
Stelle den praefixlosen (fehlerhaften) Namen [K4/D1 par.7.2, Z.1384-1392] -- die Wellenplan-Korrektur
(juenger) ist massgeblich, nicht der Design-Text.
WIE pruefbar: `add_executable`-Zeilen fuer `comdare_adhoc_emitter_cli` / `comdare_anatomy_codegen_
cli`; Bau-Treppe-Log des Strangs (RC=0 je Werkzeug + RE-CONFIGURE).
BEHAUPTET: JA -- "Werkzeug-Treppe J-1 vor dem Bau gefahren (RC=0), RE-CONFIGURE RC=0"; die Vollbau-
Treppe ist mit den korrekten comdare_-Namen (aus dem Auftrags-Steckbrief dieser Erhebung
uebernommen) durchlaufen.

**P-21 | D-5 -- Golden-Neutralitaet des Buendels**
WAS: "Das S-13-Buendel ist NICHT golden-brechend und darf es nicht werden: der Ziel-Filter aendert
die PERSISTENZ, nicht die ZEILEN." [K4/D1 D-5, Z.264-267].
WIE pruefbar: Byte-Orakel-Test (S13-01) + xmllint-Beweis (Schema-Zug) zusammen als Nachweis, dass
weder Zeileninhalt noch Instanz-XMLs sich veraendert haben.
BEHAUPTET: JA -- golden-Byte-Gleichheit ist expliziter Testbestandteil von
`test_s13_01_csv_kind_projektion` sowie der W-A/W-B-Wachen des Schema-Zugs.

### Bewusst offen gelassene / an Folgestraenge verwiesene Punkte

**P-22 | per-Binary-Mappe -- ECHTE Verdrahtung im laufenden Mess-Lauf**
WAS: implizit Teil von S13-03/B-11 (KON32-01: der Kanal soll TATSAECHLICH per-Binary-xlsx
senden, nicht nur die Sink-Mechanik bereithalten).
WIE pruefbar: Iterator-Aufrufstelle `cfg.per_binary_mappe` bei ladbaren Tier-DLLs, in einem
echten (nicht Stub-)Mess-Lauf.
BEHAUPTET: NEIN, EXPLIZIT ALS LUECKE DEKLARIERT -- "EHRLICHE NICHT-DECKUNG: die Iterator-
Aufrufstelle von cfg.per_binary_mappe (echter Mess-Lauf mit ladbaren Tier-DLLs) ist unit-seitig
NICHT fahrbar (kein Stub-Messpfad); Mechanik am Sink + Arbiter bewiesen, Verdrahtung = 1 Zeile ...
Voll-Kette = Mess-Fenster Sa/So." Das ist eine korrekt benannte, nicht versteckte Nicht-Deckung.

**P-23 | S13-04 -- Export-Element Option b (KON27-02)**
WAS: siehe SPANNUNGEN Nr. 2 fuer die volle Quellenlage. Design-Katalog fuehrt es sowohl als Teil
von "Flaeche A / #18-Kern" [K4/D1 par.1.1, Z.122-123: "-> S13-01..S13-04"] als auch -- in der
Reihenfolge-Logik -- getrennt von S13-01-03: "REIHENFOLGE: gemeinsam mit S13-19 und S13-27 in
EINEM Schema-Zug (D-3)" [K4/D1 S13-04, Z.504].
WIE pruefbar: `<export>`-Kind an `OutputType` in `experiment_schema.xsd` (X-1); Additivitaets-
Probe + Koeder-XML mit unbekannter Methode.
BEHAUPTET: NEIN, EXPLIZIT -- "S13-04ff (Arena) ... Folgestaffel-Posten, ausdruecklich NICHT dieser
Strang" (OFFENE PUNKTE, letzter Absatz des Berichts). Der Steckbrief dieser Erhebung nennt
Export-Element als Teil des Auftrags -- die Nicht-Lieferung ist daher ein PRUEFPUNKT mit
Ergebnis "nicht geliefert", nicht automatisch ein Strang-Fehler (Begruendung in SPANNUNGEN Nr. 2).

**P-24 | D-2 -- Mappe bleibt bedingungslos im RAM (Owner-Doktrin, Grundannahme von S13-01/02)**
WAS: "(1) die Mappe entsteht IMMER im Speicher" [K4/D1 D-2, Z.239]. Diese Praemisse darf durch
den Ziel-Filter NICHT verletzt werden -- der Filter darf nur die PERSISTENZ-Kanaele steuern.
WIE pruefbar: Codelese `waehle_ergebnis_format()`/`FormatWahl` -- der In-Memory-Aufbau der Mappe
darf an keiner Stelle vom Filter-Ergebnis abhaengen.
BEHAUPTET: JA, IMPLIZIT -- die gesamte S13-02-Konstruktion ("EIN Filter-Punkt ... die In-Memory-
Mappe bleibt bedingungslos") setzt genau das um; kein gegenteiliger Befund im Bericht.

**P-25 | Vorbedingung #16 golden-Fenster gelandet (S-6-Verbotszonen aktiv)**
WAS: "#16 golden-Fenster -- ERLEDIGT (17.08., ce 04ac26fa, CI 15937 gruen)" [K4/D1 par.6(1),
Z.1311]. Ohne diese Landung waere S13-05..S13-13 (Arena/FullJoin) golden-riskant -- fuer S13-01-03
selbst ist die Abhaengigkeit schwaecher (D-5: das Buendel ist ohnehin nicht golden-brechend
angelegt), aber die VORBEDINGUNG fuer den GESAMTEN #18-Slot ist diese Landung.
WIE pruefbar: `git log --oneline` in ce zeigt `04ac26fa` als Vorfahr von `66de5c09` (Basis dieses
Strangs).
BEHAUPTET: n/a fuer diesen Strang -- die Vorbedingung war bereits VOR Strang-Start erfuellt
(Board-Task #16 "completed" laut Board; Strang-Basis 66de5c09 liegt zeitlich/kausal danach).

**P-26 | Gesamtschau KON32-01 -- "Zweifach zu heilen"**
WAS (Owner-verbatim, 12.08.2026): "GENEHMIGT: (a) TOLERIEREN -- ausdruecklich, UEBERGANGSWEISE,
bis (c) realisiert ist. BLEIBT: der Kanal ist FALSCH und wird behoben WIE DEFINIERT (S-13-Filter +
Export-Element, Task #18, W2 -- Vorziehen = (c) sobald machbar) ... Der Kanal ist damit ZWEIFACH zu
heilen: Ziel-Filter (nur Zusammenfassung+Angefordertes nach Ziel 3) UND per-Binary-Format xlsx."
[Ledger KON32-01, Z.8457-8473].
WIE pruefbar: siehe P-03 (Ziel-Filter) + P-04/P-05 (per-Binary-xlsx) zusammen.
BEHAUPTET: TEILWEISE -- beide genannten Heilungs-Haelften (Ziel-Filter, per-Binary-Format) sind
mechanisch GEBAUT (P-03/P-04/P-05 = JA). Der Owner-Satz nennt aber EXPLIZIT auch "Export-Element,
Task #18" als Teil dessen, was "(c)" (das Ende der Toleranz) ausmacht -- und dieser Teil ist NICHT
Teil der Lieferung dieses Strangs (P-23). Die Owner-Toleranz "(a)" bleibt daher nach diesem Strang
formal WEITER in Kraft; #18 als Ganzes ist am Board weiterhin "pending", nicht "completed".

--------------------------------------------------------------------------------

## ABNAHME-FORMELN (woertliche Zitate der Quellen)

**Ledger KON32-01 (Owner, 12.08.2026):**
> "Das kann nicht stimmen, weil es nur per Binary xlsx geben wird. Ich genehmige hiermit
> ausdruecklich uebergangsweise (a) bis wir (c) realisiert haben, der Kanal bleibt falsch und
> muss behoben werden wie definiert."
> "GENEHMIGT: (a) TOLERIEREN -- ausdruecklich, UEBERGANGSWEISE, bis (c) realisiert ist. BLEIBT: der
> Kanal ist FALSCH und wird behoben WIE DEFINIERT (S-13-Filter + Export-Element, Task #18, W2 --
> Vorziehen = (c) sobald machbar)."
> "ES WIRD NUR PER-BINARY-XLSX GEBEN ... Der Kanal ist damit ZWEIFACH zu heilen: Ziel-Filter ...
> UND per-Binary-Format xlsx."

**Ledger KON27-02 (Owner, 12.08.2026, F10 beantwortet):**
> "Option b. Das Element beschreibt konkret je ausgegebenes Format wohin das soll und bei Latex
> was genau ausgegeben werden soll. Der Block fuer PDF referenziert im xml lazy die Latex-
> Konstruktion und exportiert sie an ein bestimmtes Ziel unter hinzunahme der uebrigen Kapitel und
> Beschreibungen neben dem generierten Anhang."

**Ledger D-2 / Owner 09.08.2026 16:31 (zitiert in K4/D1 sowie im Naht-Kopf am Objekt):**
> "die csv wird doch aus der xlsx gebildet, IMMER. es wird nur entweder xlsx oder csv oder BEIDE
> auf Platte gesichert, was auf dem RAM liegt ist etwas voellig anderes."

**W2-ABFOLGE-DESIGN, D-1 (#18 S-13-KERN-LANDUNG), ABNAHME-Zeile woertlich:**
> "ABNAHME: Testseiten T-11c/T-12c/T-12d + alle benannten Koeder; Toleranz (a) endet mit (c);
> Debug+Release, gcc+clang."
(Hinweis: diese ABNAHME-Formel gilt fuer den GESAMTEN D-1-Block -- S13-01 bis S13-32 -- nicht fuer
diesen Strang allein; T-12c/T-12d [Arena/FullJoin] sind fuer S13-01-03 nicht einschlaegig.)

**Designplan par.3, T-1..T-9 (woertlich, vollstaendig -- siehe P-07 bis P-15 fuer die Einzelpruefung):**
> "T-1 ROT ZUERST. Der Test ist am ersten Tag rot, ODER sein Biss ist per protokollierter
> Wegwerf-Mutation bewiesen (Rot gesehen, dann zurueckgenommen). Beides fehlt = kein Test."
> "T-6 SCHWESTERPFLICHT. Jeder Fix und jeder Test sucht im selben Zug die Schwesterstelle."
> "T-7 REGISTRIERUNG IST TEIL DES TESTS. Ein Test existiert erst, wenn er in ctest -N erscheint
> und sein Binary im Bauweg haengt."
> "T-8 ATOMARE LANDUNG. Tag-1-Rot lebt im Feature-Branch; auf development landen Test +
> Minimalbau atomar (Hart-Gruen-Doktrin bleibt intakt)."

**Designplan par.11, T-11b/T-11c (woertlich):**
> "T-11b KOMBIBAU-2x2-MATRIX ALS PRUEFNORM (KON55): jede Landung ist erst gruen, wenn {clang,
> gcc} x {Debug, Release} = 4 Zellen je J-1..J-4 + ctest durchlaufen."
> "T-11c MUTATIONS-PROTOKOLL ALS ABNAHMEKLASSE (KON57, verschaerft T-1): der Biss jedes neuen
> Tests wird per protokollierter Wegwerf-Mutation belegt ... die Koeder-LAENGE/-FORM wird
> geprueft, BEVOR die Mutation zaehlt."

**K4/D1 (Design-Bundle), S13-01 ABNAHME:**
> "T-11c-Mutation je Naht; Koeder: eine Fassung, die bei ErgebnisSchreibFehler trotzdem eine CSV
> zuruecklaesst, wird ROT. Zusatz-Probe: golden-CSV byte-identisch vor/nach dem Umbau."

**K4/D1, S13-02 ABNAHME:**
> "vier Faelle mit literalem Verzeichnis-Listing: nur-csv / nur-xlsx / beide / Block fehlt (an
> einem der drei genannten Bestands-Profile). Koeder je Fall: eine Fassung, die die
> nicht-deklarierte Datei doch schreibt, wird ROT. Zusatz-Koeder zur Scope-Festlegung: eine
> Profil-Blatt-Zeile, die in der golden-CSV auftaucht, wird ROT."

**K4/D1, S13-03 ABNAHME:**
> "Zaehl-Test N Binaries => N Mappen + 1 Aggregat-Mappe. Koeder 1 -- ein Nur-xlsx-Profil, nach dem
> lazy_try_resume_binary keinen Wiederanlauf mehr findet, wird ROT. Koeder 2 -- ein Lauf, nach dem
> measurement_sink keine result.csv mehr gereicht bekommt, wird ROT. Koeder 3 -- eine Auswerte-CSV,
> die den Resume-Vertrag ueberschreibt, wird ROT."

**K4/D1, par.7.2 Abnahme-Normen ueber ALLEN Schritten:**
> "Ein gruenes Gate deckt nur seinen Gegenstand: vor jeder Freigabe BEIDE Mengen nennen -- was
> geprueft wurde UND was nicht."

--------------------------------------------------------------------------------

## NICHT-GEFORDERT (ausdruecklich Nachfolge-Zuege, keine Phantom-Funde bauen)

Alle folgenden Punkte sind Teil des GESAMTEN #18/S-13-Kern-Buendels (D-1) bzw. der Nachbar-Tasks
#57/#48, aber NICHT Teil des Auftrags dieses Strangs. Ein Audit-Fund "S13-05 fehlt" o.ae. waere
ein FALSCH-POSITIV gegen diesen Strang:

- **S13-05..S13-09 (Arena/Checkpoint-Kette, Flaeche B)**: 6-GB-Deckel, ram_warn/ram_oob, Thread-
  Slots, harter Abbruch, Hot-Path-Deskriptor, Drain-Schleife. Traeger: eigener Staffel-3-Zug
  ("S-13-Arena/Lager/publish-Ketten", LEAD-ENTSCHEIDE Punkt 14); ausserdem im Original-Slotplan
  ein eigener Worktree `wt-s13-buendel` vorgesehen [W2-ABFOLGE-DESIGN TEIL 3, Slot C/S3].
- **S13-10..S13-13, S13-31, S13-32 (Full-Join FJ-1..FJ-10, Flaeche C)**: Spaltenmenge E(A),
  markierter Leerwert, verlustfreier Join, Namens-Wache, E4-Aggregator. Designplan-Pflichten
  T-12d(1-4) gehoeren hierher, NICHT zu diesem Strang.
- **S13-14..S13-18 (Sheet-System/CSV-Factory, Flaeche D)**: Blattzahl-Formel, zwei Blatt-Familien,
  Filesystem-Hierarchie, CSV-Factory+Namens-Grammatik (=B-07-Migration csv_to_latex->
  measure_to_latex).
- **S13-19 (XSD-Enum-Wache, Flaeche E), S13-20 (B5 XML-Trennung Bau/Mess, Flaeche F)**: harte
  Registry-Enum-Durchsetzung ausserhalb des --validate-Zweigs (F-24 in STAFFEL1-SYNTHESE
  dokumentiert das als bestehende Rest-Luecke); Mengen-Trennung Bau/Mess.
- **S13-21..S13-26 (#57 Lager-Vollausbau, Flaeche G)**: LB-4/5/6, Host-Belegung, Plan-Ablage, zwei
  Wurzelebenen, rebuild-Flag. Eigener Landepunkt D-2 (#57 LAGER-LANDUNG).
- **S13-27..S13-28 (#48 publish-Sektion, Flaeche H)**: `<publish>`-Element, AF_BRANCH XML-
  erreichbar. Eigener Landepunkt D-3 (#48 PUBLISH-LANDUNG).
- **S13-29 (E-18 Token-Umstellung PAT->CI_JOB_TOKEN, Flaeche I)** und **S13-30 (Wache K-D1,
  MeasurementTooling->MessEbene-Abbildung)**: eigene, "Reihenfolge frei"-Posten, nicht an
  S13-01-03 gebunden.
- **X-1..X-5, X-7..X-9 (Rest des Schema-Zugs)**: vom Strang selbst explizit an "ihre Traeger
  S13-04ff" verwiesen; nur X-6 war fuer S13-01-03 noetig (siehe P-01 und SPANNUNGEN Nr. 2).
- **PDF-Erzeugung als Rueckschrieb-Methode**: laut Design ausdruecklich ausserhalb -- "die vier
  ct-gesicherten Methoden sind csv, latex_table, comparison_metrics, xlsx. PDF ist AUSSERHALB."
  [K4/D1 par.8].
- **Ebene A (GitLab-Runner-Cache), SOTA-/Break-Even-Ersatz, Planer<->CEB-Kanal-Naht (B-01/02/04/
  14), S-12-CI-Geruest (#3), voller Monolith-Split (#29-Rest/#88), Paper-Kopplung/PV-4, jegliche
  golden-Byte-wirksame Aenderung**: alle wortwoertlich in K4/D1 par.8 als NICHT-Buendel-Bestandteil
  benannt, a fortiori nicht Teil dieses schmaleren Strangs.
- **Vollstaendiger 4-Zellen-Kombibau (T-11b) und Codex-Testkritik (T-9)**: laut K17-/H-7-Doktrin
  erst am gemergten Endstand bzw. in der Folgewelle faellig (siehe P-14/P-15/P-16) -- keine
  Einzelstrang-Pflicht.

--------------------------------------------------------------------------------

## SPANNUNGEN (Widersprueche zwischen Quellen -- nicht glattgezogen)

**Nr. 1 -- Der Resume-Vertrag-Carve-out ist eine DESIGN-INTERPRETATION der Owner-Worte, keine
Owner-Ratifikation (hoechste Prioritaet fuer das Audit).**
Der Owner sagt am 12.08. woertlich und mit Betonung: "ES WIRD NUR PER-BINARY-XLSX GEBEN" (Ledger
KON32-01, Korrektur an seiner eigenen fruehreren Aussage "jede per-Binary-CSV"). Gelesen am
Wortlaut heisst das: keine per-Binary-CSV-Datei soll mehr entstehen. Das Design-Bundle (K4/D1,
S13-03, 17.08.) baut jedoch bewusst einen Carve-out: `result.csv`+`.stamp` bleiben "WEITERHIN und
BEDINGUNGSLOS" auf der Platte -- mit der Begruendung, das sei kein "Auswerte-Format" (also nicht
das, was der Owner meinte), sondern "BETRIEBSZUSTAND der Mess-Maschine". Das Design nennt selbst
die Alternative (Resume auf die Mappe umstellen) als "bewusst NICHT gewaehlt ... zu breit fuer
diesen Slot", also einen erkannten, aber vertagten Zielkonflikt (K4/D1 Z.481-483). Der Strang hat
GENAU diese Design-Interpretation gebaut (P-05) -- das ist die richtige Handlungsweise gegenueber
einem vorliegenden Design, aber es bedeutet: Nach diesem Strang existiert IMMER NOCH eine
per-Binary-CSV-Datei auf der Platte (`result.csv`), nur nicht mehr als AUSWERTE-Format sichtbar.
Ob das dem Owner-Satz "NUR per-Binary-xlsx" im engsten Wortsinn genuegt, ist NICHT explizit vom
Owner bestaetigt -- das Design traegt selbst den Vermerk "Alternative ... Als W3-Nachfolgeposten
vermerkt", erkennt also die Spannung. Das Audit sollte diese Zeile nicht als glatt erledigt
fuehren, sondern als "gebaut nach Design-Interpretation, Owner-Feinabstimmung offen".

**Nr. 2 -- S13-04 (Export-Element): gehoert es zu diesem Strang oder zur Folgestaffel?**
Drei Blickwinkel widersprechen sich graduell:
(a) Der Steckbrief dieser Erhebung nennt "Export-Element Option b (KON27-02)" ausdruecklich als
Teil des Auftrags "#18-Vorstufe S-13-Schema-Kette".
(b) K4/D1 par.1.1 fuehrt "Flaeche A -- #18-Kern" mit der Zuordnung "-> S13-01..S13-04" -- topisch also
EIN Bereich mit S13-01-03. Auch KON32-01 selbst (Owner, 12.08.) nennt "S-13-Filter + Export-
Element, Task #18" in einem Atemzug als das, was die Toleranz "(c)" beendet.
(c) K4/D1 par.6 (Reihenfolge-Zwang) und die S13-04-eigene REIHENFOLGE-Zeile widersprechen dem: die
Schema-Zug-Freigabe fuer S13-04 laeuft NICHT ueber die S13-01->02->03-Kette, sondern separat
("Schema-Zug -> gibt S13-04, S13-05, S13-19, S13-20, S13-26, S13-27, S13-32 frei"); S13-04 selbst
traegt die Zeile "REIHENFOLGE: gemeinsam mit S13-19 und S13-27 in EINEM Schema-Zug" -- also mit
zwei Posten gruppiert, die beide unbestritten Staffel 3 sind. LEAD-ENTSCHEIDE Punkt 14 (Staffel-3-
Liste) und STAFFEL1-SYNTHESE par.5 ("S-13-Folgeketten, ausdruecklich NICHT Staffel 1") fuehren
S13-04 explizit unter "S13-04ff (Arena)" als Staffel-3-Posten -- dieselbe Einordnung, die der
Strang selbst am Ende seines Berichts vornimmt.
BEWERTUNG: die juengere, operative Schicht (LEAD-ENTSCHEIDE + STAFFEL-SYNTHESEN, 20./21.08.,
UNMITTELBAR vor und waehrend des Baus entstanden) grenzt S13-04 klar aus Staffel 1 aus -- und die
eigene Reihenfolge-Logik des Design-Dokuments (K4/D1 par.6) stuetzt das strukturell (S13-04 haengt
NICHT an der S13-01->02->03-Kette). Die AELTERE Quelle (KON32-01/KON27-02, beide 12.08., sowie
K4/D1 par.1.1s topische Bezeichnung "Flaeche A") begruendet dagegen inhaltlich, warum S13-04 fachlich
zum selben Themenkomplex gehoert. Beide Lesarten sind mit Beleg vertretbar; das Audit sollte
NICHT werten "der Strang hat etwas vergessen", sondern feststellen: S13-04 ist ein offener,
korrekt weitergereichter Posten mit doppelter Verankerung (Staffel-3-Zuweisung UND KON32-01-
Nennung) -- der GESAMTE #18-Slot bleibt deshalb erst mit Lieferung von S13-04 (oder einer
expliziten Owner-Freigabe, es wegzulassen) vollstaendig geheilt.

**Nr. 3 -- Design-Dokument (17.08.) vs. Objektstand (20.08.) bei S13-02s vierter Abnahme-Fall.**
K4/D1s eigene IST-Tabelle (datiert 17.08., ce @ 04ac26fa) behauptet: "11 getrackte Profile, davon
8 mit `<writeback_methods>` und csv, 3 ohne Block, 0 mit xlsx" (K4/D1 Z.411-412, wiederholt
Z.421-423 mit den drei Namen `base_pilot`, `m3v2_smoke`, `wdk_fairness_example`). Der Strang hat
am 20.08. nachgemessen und fand 11/11 Profile MIT Block seit ce `fbe48f99` (datiert 14.08. --
zeitlich VOR dem Design-Stand 17.08.). Diese Diskrepanz ist selbst nicht restlos aufgeloest: ENTWEDER
war das Design-Dokuments Grep am 17.08. unvollstaendig (es haette `fbe48f99` bereits erfassen
muessen), ODER es gibt eine Objektbewegung zwischen 17.08. und 20.08., die K4/D1 nicht kennen
konnte. Der Strang hat die Konsequenz korrekt gezogen (test-lokales Profil statt Bestandsprofil
fuer den vierten Fall) und den Fund dokumentiert (STAFFEL1-SYNTHESE F-21) -- das Audit sollte NUR
pruefen, ob die Substitution die Abnahme-SUBSTANZ (ein Profil ohne Block verliert seine CSV) noch
trifft, nicht ob ein Bestandsprofil-Name woertlich vorkommt.

**Nr. 4 -- "EIN Schema-Zug"-Doktrin (D-3) vs. tatsaechliche Aufteilung in mindestens zwei Commits.**
K4/D1 D-3 sagt: "Alle XSD-Aenderungen des Buendels gehen in EINEN Commit." Die tatsaechliche
Staffel-Ausfuehrung baut jedoch mindestens ZWEI Schema-Commits: diesen Strang (X-6 allein, super
1e92b77e) und einen spaeteren Folge-Commit fuer X-1..X-5+X-7..X-9 (Traeger S13-04ff, Staffel 3).
Der Strang begruendet das selbst ("X-6 = einziges von S13-01..03 gebrauchtes X-Item"), aber das
ist eine ANDERE Lesart von "EIN Commit" als der Design-Text woertlich traegt (der spricht vom
GESAMTEN Buendel, nicht von "je Teilstrang ein Commit"). Diese Aufteilung folgt ersichtlich aus der
uebergeordneten Staffel-1/Staffel-3-Organisation (LEAD-ENTSCHEIDE), nicht aus einem Fehler dieses
Strangs -- trotzdem bleibt D-3 im engsten Wortsinn (fuer den GESAMTEN #18-Slot) erst mit dem
zweiten Schema-Commit erfuellt.

**Nr. 5 -- KON32-01s Toleranz-Ende "(c)" ist durch diesen Strang NICHT erreicht.**
Der Owner-Satz erlaubt die Toleranz "(a)" AUSDRUECKLICH NUR "bis wir (c) realisiert haben". Aus
KON32-01s eigenem Text folgt "(c)" = "S-13-Filter + Export-Element, Task #18" VOLLSTAENDIG. Dieser
Strang liefert den Filter (S13-02) und das per-Binary-Format (S13-03), NICHT das Export-Element
(S13-04, siehe Nr. 2). Damit ist "(c)" nach diesem Strang noch NICHT erreicht -- die Owner-Toleranz
bleibt formal in Kraft, und Board-Task #18 bleibt zu Recht "pending", nicht "completed". Das
Audit sollte diesen Strang als NOTWENDIGEN, aber NICHT HINREICHENDEN Schritt zur KON32-01-Heilung
bewerten.

**Nr. 6 -- T-11b (Kombibau) ist strang-lokal nur zu 1/4 erfuellt -- kein Defekt, aber ein offener
Nachweis.**
Design-Abnahme (D-1, W2-ABFOLGE-DESIGN) verlangt woertlich "Debug+Release, gcc+clang" fuer den
GESAMTEN #18-Slot. Dieser Strang hat nur eine Zelle (gcc-Release) gefahren und die uebrigen drei
Zellen ausdruecklich auf den Lande-Zug verschoben (K17-/H-7-Doktrin, uebereinstimmend mit ALLEN
18 Staffel-1+2-Straengen laut STAFFEL2-SYNTHESE Phase 4). Das ist korrektes, dokumentiertes
Verhalten nach der uebergeordneten Bau-Doktrin -- aber es bedeutet, dass die woertliche D-1-
Abnahmeformel ("Debug+Release, gcc+clang") zum Zeitpunkt dieser Erhebung fuer S13-01-03 NOCH NICHT
literal bewiesen ist; das steht noch aus.
