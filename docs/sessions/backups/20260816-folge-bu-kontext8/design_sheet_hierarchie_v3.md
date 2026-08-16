# DESIGN SHEET-HIERARCHIE V3 (Owner-Vorlage, Fable 5 max)

Stand: 16.08.2026. Setzt den Owner-KERN KON80-01/V3 (Ledger:99-105; Rohwortlaut kon64_sammlung.md:1334-1354,
Backup 20260816-folge-bu-kontext8) vollstaendig um. Vorstufen: Blattform-Entscheid 08.08. (Ledger:28650-28722),
Mess-Baum 08.08. (Ledger:28277-28314), KON34-Karte 12.08. (Ledger:5562-5618), V7 16.08. (Ledger:93-98),
KERN 26.07. Fassung 1/2 (Ledger:28515-28534). Alle Code-Anker am Objekt verifiziert (Pfade unten).

Der V3-Kern in vier Saetzen (Owner verbatim, 16.08.):
(1) S001..Snnn ist ABGELEHNT ("Holzweg"). (2) Die w/ma/mi-Mess-Hierarchie fuehrt zur Hierarchisierung der
Sheets; der Schnitt ist "im Kern auch nur ... die Traeger-Stufe in Kombination mit der erhobenen Messebene".
(3) "alle Parameter stehen dann im Blatt". (4) Doppeltes Sparse-Prinzip: die xlsx ist "sparse als
Lagereinordnung in einer Kette benannt", die Sheets "nur sparse benannt gegen ihre eigene Funktion im
sheet System".

---

## 1. HIERARCHIE-MODELL: Traeger-Stufe x erhobene Messebene

Traeger-Stufen (physische Binaries, Reihenfolge Ledger:5844): p=Planer -> b=CEB -> t=Tier -> h=Hybrid.
Messebenen (Mess-Baum 08.08.): w=wallclock (Wurzel, "wallclock CEB root am Pruefdock") -> ma=Macro (EIN
Funktionsaufruf) -> mi=Micro (die Achsen selbst). Code-Gleichsetzung: `struct Wallclock { ebene =
MessEbene::Compare; }` (libs/cache_engine/mess/konfiguration.hpp:106-108) — die w-Ebene IST die
compare-Blattsorte der Blattform.

### 1.1 Existenz-Matrix (welche Zellen real sind)

Grundlage: KON34-02/-03-Karte ("Die drei Instrumente wohnen NICHT an einem Ort... die CEB misst UM das
Tier herum, das Tier misst IN sich", Ledger:5562-5618) + iw/ima/imi-Interface-Satz (KON72-02,
Ledger:714-719) + Hybrid-4.-Ebene (Ledger:13827-13854, 17127-17142).

| Traeger \ Ebene | w (wallclock)            | ma (Macro)                    | mi (Micro)                  |
|-----------------|--------------------------|-------------------------------|-----------------------------|
| p Planer        | NEIN (traegt iw: Aufzeichner der b-Fuehler) | NEIN          | NEIN                        |
| b CEB           | JA (Schalter an/aus; SOLL-Ort der Karte)    | NEIN (traegt ima: Leser der t/h-Fuehler) | NEIN (traegt imi) |
| t Tier          | NEIN (w wohnt an b)      | JA (an/aus; 1 Blatt je FUNKTION) | JA (an/aus; 1 Blatt je ACHSE) |
| h Hybrid        | NEIN                     | JA (eigene ma-Schicht; nur Hybrid-Zweig) | JA (eigene mi; nur Hybrid-Zweig) |

Real existieren genau: **b x w** · **t x ma** · **t x mi** · im Hybrid-Zweig zusaetzlich **h x ma** · **h x mi**.
Der Planer erhebt NIE eine Ebene — er erscheint ausschliesslich als Wert der Aufrufer-Spalte (Stack-Kante,
Ledger:28692-28711). PMC wohnt am CEB/Host (Karte), ist Meta-Meta-Achse mit eigener Permutation
(AMD != Intel, dreiphasig, KON65-03/F1) und erweitert den NENNER, nicht die Blatt-Dimension (s. 3.4, P3).

### 1.2 Die vier Tore je Zelle (warum das Kreuz SPARSE ist)

Ein Blatt (s,e) existiert in einer Mappe genau dann, wenn ALLE Tore offen sind:
1. **Zweig-Tor**: single-Zweig hat 3 Ebenen (b,t), Hybrid-Zweig 4 (b,t,h) — Owner: "statt 3 Ebenen 4
   Ebenen", dazwischengeschoben, nicht angehaengt (Ledger:13827ff).
2. **Schalter-Tor**: jede Messeinrichtung ist je Stufe an/aus schaltbar ("AUSWAHLfrage", KON34-03;
   compile-time konfigurierbar und wieder ausbaubar, Ledger:28277ff).
3. **Interface-Tor (Freigabe)**: die vorangehende Stufe muss das Aufzeichnungs-Interface tragen
   (Planer: iw fuer b-w; CEB: ima/imi fuer t/h-Fuehler). Owner: "Wenn eine vorangehende Traeger-Stufe das
   Interface der nachfolgenden nicht lesen kann, koennen keine Messdaten zu diesem Thema erhoben werden"
   (KON72-02) — keine Daten => kein Blatt.
4. **Umwelt-Tor (V7)**: Mess- und System-Achse geben je fuer Tier/Hybrid FREI, was gemessen werden kann;
   sie selbst liefern nur die Permutation der aeusseren Rahmenbedingungen (V7, Festschreibe-Order,
   Ledger:93-98) — sie wohnen daher in Kette+INFO, nie im Blatt-Schnitt.

**Nenner-Doktrin**: Die Zahl der real erhobenen Zellen/Blaetter je Versuch ist DYNAMISCH (PMC erweitert die
Permutation gegen w/ma/mi; Mess-Permutation > 32, nur S-19 rechnet sie — Owner-Ruege 15.08., dritte). Dieses
Design legt darum KEINE statischen Nenner vor; alle Blattzahlen sind Formeln ueber den konkreten Versuch:

    |Blaetter| = 1 (INFO) + Sum ueber offene Zellen (s,e): |Gegenstaende(s,e)|
    Gegenstaende(b,w) = Last-Messungs-Rekombinationen des Versuchs (>=1)
    Gegenstaende(t|h,ma) = am Pruefdock gerufene Interface-FUNKTIONEN
    Gegenstaende(t|h,mi) = beteiligte ORGAN-ACHSEN (max. 18, kCompositionAxisNames)

Die Owner-Formel "Blattzahl = 1 + |Funktionen| + |Achsen|" (08.08.) ist der Spezialfall EINER Rekombination.
Blattzahl waechst NIE mit der Lauflaenge: Aufrufe werden ZEILEN, nie Sheets (ergebnis_mappe.hpp:154-155).

### 1.3 Hybrid ohne vierten Ebenen-Wert

Die "4. Messebene" des Hybrid-Zweigs ist im Sheet-System KEIN neues Ebenen-Token und KEIN 4. Enum-Wert,
sondern Traeger-Differenzierung: h x ma / h x mi ("Heuristik-Tier-Binary hat eine eigene
Macro-Benchmarking schicht", Ledger:17131-17133). Damit entfaellt konstruktiv die stille
uint8_t-Umnummerierung von `MessEbene` (Gefahr S7-HY-4TE-MESSEBENE, Test #465, Konformitaets-Register
teil2:109/205): das Enum {Compare, Macro, Micro} bleibt dreiwertig und bekommt einen Anzahl-Anker (D4).
Die POSITION der eingeschobenen Hybrid-Schicht ist Sache des Mess-Baums/der CEB-Permutation (3! bzw. 4!,
vom Planer kompiliert; Ebenen-Ordnung ist Konfigurations-Permutation, konfiguration.hpp:37) — sie steht
NICHT im Namen, sondern hoechstens in der Blatt-REIHENFOLGE der Mappe und in der INFO-Legende. Namen
bleiben dadurch stabil gegen jede Ordnungs-Entscheidung.

### 1.4 Realm

Mappen wohnen ausschliesslich im Ast `realm=messdaten` der K1-Wurzelkette (gattung -> genus -> realm,
lager_baum_writer.hpp:12-46). Der binaries-Realm traegt keine Mappen. Der Traeger-Stufen-Anteil der
IDENTITAET (welche Binary vermessen wurde) liegt bereits in der Kette (Gattung/Genus; Hybrid ist per K1
regulaere Gattung+Genus) — deshalb braucht der DATEINAME kein Traeger-Glied, nur die Sheets (1.1).

---

## 2. BENENNUNGS-GRAMMATIK (doppeltes Sparse-Prinzip)

### 2.1 xlsx-DATEINAME: sparse als Lagereinordnung in einer Kette

Der V3-Satz ist fuer die Datei-Haelfte BEREITS GEBAUT und consteval-getestet — "das ist detailliert
geplant" verifiziert sich am Objekt: `bestandslog::blatt_dateiname()` (lager_pfad_grammatik.hpp:398-436,
static_assert-Batterie :498-575) plus Kette des Baum-Writers (lager_baum_writer.hpp:12-47). Die Kette, deren
LETZTES GLIED die Datei ist (Messdaten-Realm, Wurzel -> Blatt):

    1 gattung=<token> / 2 genus=<token> / 3 realm=messdaten /
    4 mess=<tooling>+load_framework=on|off        (Mess-Kombinatorik; PMC/Meta-Metas: s. P3)
    5 System-Haupt-Rekombination (EIN Ordner, Meta-Metas HINTEN, D-09)
    6-10 die 5 englischen Organ-Gruppen-Ordner (Speicherhierarchie-Reihenfolge)
    11 Haupt-Blatt (vollstaendige Haupt-Achsen-Bindung)
    12-14 mess_unter -> system_unter -> organ_unter (nur soweit noetig)
    Blatt: DATEI nach blatt_dateiname()

**EBNF Dateiname** (IST-Grammatik, V3-konform; Zeichenklassen aus lager_pfad_grammatik.hpp:173-188/246-260):

    dateiname   = datum "-" zeit [ "_" kvkette ] "." endung ;
    datum       = 8 * ziffer ;                        (* YYYYMMDD *)
    zeit        = 6 * ziffer ;                        (* HHMMSS *)
    kvkette     = kvpaar { "+" kvpaar } ;             (* SPARSE: NUR die unter dem Blatt-Ordner noch
                                                         VARIIERENDEN Unter-Achsen; Konstanten werden
                                                         weggelassen und als 'konstante'-Zeilen im INFO
                                                         gefuehrt; LEER ist der Normalfall *)
    kvpaar      = achsenname "=" wert ;
    achsenname  = zeichen { zeichen } ;               (* [a-z0-9_] *)
    wert        = wertzeichen { wertzeichen } ;       (* [a-z0-9._-], via sanitisiere_wert *)
    endung      = "xlsx" | "csv" ;

Sparse-Beweis gegen die eigenen Wachen: (a) Haupt-Achsen stehen NIE im Namen (Ordner-Glieder + INFO,
Karte A / A-15: "Unter-Achsen erscheinen NIE im Stempel, wohl aber im DATEINAMEN"); (b) konstante
Unter-Achsen fallen aus dem Namen (KERN 26.07. Section 6, KonstantenMeta ergebnis_mappe.hpp:112-115);
(c) der Normalfall ist die LEERE Kette `<datum>-<zeit>.<endung>` — maximal sparse (Grammatik-Kopf :400-407,
mappen_stamm() ergebnis_mappe_naht.hpp:318-344 nutzt genau das); (d) Ueberlauf > 200 Byte je Komponente ->
deterministisch `<datum>-<zeit>_H=<hex16>.<endung>` MIT Voll-Kette im Ergebnis/INFO (kein stilles Kuerzen).
Fuer Dateinamen gilt NICHT die 31er-Grenze, sondern die 200-Byte-Komponenten-Wache dieser Grammatik.

### 2.2 SHEET-NAME: sparse gegen die Funktion im Sheet-System

Die Funktion eines Blatts im System ist sein Schluessel (Traeger-Stufe, Messebene, Gegenstand) — genau
das traegt der Name, sonst nichts ("alle Parameter stehen dann im Blatt"). S001..Snnn entfaellt als
Namensschema (V3); die V-A9-6-Geschmacksfrage ist damit entschieden (Klartext statt Kurzcode+Legende als
Primaernamen; die Legende bleibt als Resolver, 4.). Tokens = das vom Owner in V3 selbst adoptierte
w/ma/mi-Vokabular; Glied-Trenner "." (in der Wert-Zeichenklasse und xlsx-legal; kommt in keinem
C++-Bezeichner vor -> kollisionsfreies Parsen).

**EBNF Sheet-Name**:

    sheetname     = "INFO" | messblatt ;
    messblatt     = ebene [ "." traeger ] "." gegenstand ;
    ebene         = "w" | "ma" | "mi" ;               (* anfuehrend — Owner-CSV-Regel 08.08.:
                                                         "anfuehrend im Namen ihre Ebene" *)
    traeger       = "b" | "t" | "h" ;                 (* SPARSE-Regel: NUR wenn dieselbe Ebene im
                                                         Versuch auf mehr als einer Traeger-Stufe
                                                         erhoben wird — real: ma/mi im Hybrid-Zweig.
                                                         "p" nie: der Planer erhebt keine Ebene. *)
    gegenstand    = rekombination | funktion | achse | ueberlauf ;
    funktion      = identifikator ;                   (* kOpKindNames: insert lookup erase clear scan rmw *)
    achse         = identifikator ;                   (* kCompositionAxisNames, 18 Namen *)
    rekombination = wertkette ;                       (* sanitisiere_wert(<Last-Mess-Rekombinations-
                                                         Bezeichner>) — RT-String *)
    ueberlauf     = "h16." hex16 ;                    (* deterministisch: sha512-hex16 des Voll-
                                                         Bezeichners; Voll-Name in der INFO-Legende —
                                                         ersetzt den bisherigen S00N-Fallback *)
    identifikator = [a-z0-9_]+ ;   wertkette = [a-z0-9._-]+ ;   hex16 = 16 * hexziffer ;

Beispiele: `w.baseline` · `ma.insert` · `mi.search_algo` · Hybrid-Zweig: `ma.h.lookup` gegen `ma.t.lookup`
· `mi.h.persistence_target` · Ueberlauf: `w.h16.3fa9c2d114e07b58`.

**31-Zeichen-Beweis** (Wache: `xlsx_sheetname_zulaessig`, ergebnis_mappe.hpp:268-293 — <=31, verboten
`[ ] : * ? / \`, nicht leer):

| Fall | laengster konstruierbarer Name | Laenge | Beleg |
|---|---|---|---|
| INFO | `INFO` | 4 | kInfoBlattName :310-311 |
| mi (Maximum) | `mi.h.persistence_target` / `mi.h.index_organization` | **23** | laengste der 18 Achsen = 18 Z. (axis_path_serialization.hpp:40-43); 2+1+1+1+18 |
| ma | `ma.h.lookup` | 11 | laengste Funktion = 6 Z. (kOpKindNames, harness/perm_runner.hpp:116); Budget fuer kuenftige Funktionen: 31-5 = 26 |
| w (RT) | `w.` + sanitisierte Rekombination | Wache | verletzt der Kandidat die Wache -> Ueberlauf-Zweig |
| Ueberlauf | `<ebene>.h16.<hex16>` | max **23** (`mi.h16.` + 16); `w.h16.` = 22 | dieselbe Ueberlauf-Doktrin wie die Datei-Grammatik (hex16 + Voll-Name in Legende) |
| Fortsetzungs-Reserve | max. Name + `.99` | 26 | nur falls P2 mit Fortsetzungsblatt beantwortet wird |

Konstruktiv: alle CT-erzeugbaren Namen sind <= 23 <= 31 (Reserve 8); jeder RT-Name laeuft durch
sanitisiere_wert (Zeichenklasse [a-z0-9._-], enthaelt keines der 6 verbotenen Zeichen) und die Wache;
Wachen-Verletzung muendet deterministisch im 22-23 Zeichen langen h16-Namen — nie Truncate, nie S00N,
nie Fehler wegen Laenge. Ebenen-Praefixe machen die Familien untereinander und gegen INFO kollisionsfrei;
`worksheet_write_url("internal:'<name>'!A1")` funktioniert mit allen erzeugten Namen (empirischer
write_url-Beleg ergebnis_mappe.hpp:197-203; Punkte sind in gequoteten Sheet-Referenzen zulaessig).
Stabil vorhersagbare Namen sind tragend, nicht kosmetisch: die compare->ma->mi-Hyperlinks (Owner 08.08.)
adressieren Blattnamen.

### 2.3 CSV-Kinder (Strategy derselben Factory, OV-17 / KON60-05)

xlsx = STAMM, csv = KIND; ein Ordner statt der xlsx, je Sheet eine Datei. Owner-Regel 08.08. (verbatim):
Ebene ANFUEHREND im Namen, Zeitraum parse-bar. Daraus:

    csv-kind   = sheetname "__" stamm ".csv" ;        (* sheetname beginnt mit der Ebene ->
                                                         Verzeichnis sortiert/filtert ohne Werkzeug *)
    stamm      = datum "-" zeit [ "_" kvkette ] ;     (* = Dateiname der Mappe ohne Endung; traegt den
                                                         parse-baren Zeitraum *)
    info-kind  = "INFO" "__" stamm ".csv" ;

Laengen: sheetname <= 31, stamm >= 15; Gesamt weit unter der 200-Byte-Komponenten-Wache. ACHTUNG
IST-Delta: der gebaute Writer benennt heute `<stamm>__<label>.csv` (ergebnis_mappe.hpp:573/582/590) —
Stamm fuehrend statt Ebene fuehrend; Umbau D3.

---

## 3. BLATT-INHALT: "alle Parameter stehen dann im Blatt"

### 3.1 Spaltenmenge — die eine Quelle

Der Writer definiert KEINE eigene Spaltenmenge; er konsumiert AUSSCHLIESSLICH `lazy_csv_header()`
(WIDE-CSV, aktuell 189 Spalten, header-getrieben; KON74-04, Owner-Klarstellung 15.08.: "die xlsx traegt
auch in allen Tabellen die verfuegbaren CSV Spalten"). Fehlende Spalten alter CSVs: leer/n-a. Die
Spaltenfamilien am Objekt (cache_engine_builder_iterator.hpp:555-604): `binary_id;setting;repetition;
n_ops;total_ns;ns_per_op` + `op_<art>_{n,p50_ns,p99_ns}` je Interface-Funktion + `seg_<achse>_ns` je
Organ-Achse + seg_framework/seg_run_total/seg_coverage + Zaehlwerke + `stat_<achse>_<feld>`
(V3-Observer-Schema) + Selektions-/Lauf-Tags. Das erfuellt V7 woertlich: gemessene Parameter sind
ORGAN-Achsen-Parameter in w/ma/mi; Mess/System liefern die Umwelt-Permutation (-> Kette + INFO, nie
Blatt-Schnitt).

### 3.2 Profil-Zeilenschema (checkpoint_measure-Soll)

Zusaetzlich traegt jede hierarchische Blattzeile das 8-Spalten-Schema (20260808-checkpoint_measure_
soll_design.md:125-128; ergebnis_mappe.hpp:167-183): **Prozess | Thread | Mess-Ebene | Ziel | Aufrufer |
Checkpoint (in/out) | Zeitpunkt | Messwerte...**. JE AUFRUF ZWEI ZEILEN (In/Out — nie zurueckkehrende
Aufrufe muessen sichtbar sein); mehrere Threads schreiben in ANKUNFTSFOLGE ins selbe Blatt (Zerlegung je
Thread beim LESEN); der Aufrufer wird in der AUSWERTUNG rekonstruiert (Stapel je Ebene), nicht gemessen;
Zeitbasis = monotoner Zaehler, einmal je Prozesslauf gegen Systemzeit verankert. Die Aufrufer-Spalte ist
die Stack-Kante der Architektur-Layer (compare=Lastprofil, ma=Gattung+Genus-Interface, mi=Achsen-
Interface) — hier erscheint auch p/b als Wert, obwohl p nie ein Blatt traegt (1.1).

### 3.3 Verhaeltnis zu den 26.07.-Permutations-Sheets: ERSETZT den Blatt-Schnitt, ERHAELT die Inhalte

Quellenlage: Fassung 1 (26.07., KERN=Gesetz): EIN Sheet je gewaehlter Unter-Achsen-Permutation, gegen
Sheet-Explosion die 3 Unter-Ebenen; 08.08.: "zwei Blatt-Familien in derselben Mappe, kein Widerspruch";
KON74-04 (15.08.) restatet Fassung 1; V3 (16.08., juenger): der Schnitt geht "IM KERN AUCH NUR" um
Traeger x Messebene, und ALLE Parameter stehen IM Blatt.

Ableitung (Merge, nicht Verdraengung): Der abgelehnte S001-Vorschlag war das Namensschema der
Permutations-Familie; V3 verwirft mit ihm die PRAEMISSE des dichten Permutations-Schnitts. Die
Permutation ist in der Zeilenform laengst SPALTE (`binary_id;setting;...` — binary_id ist der
materialisierte Ketten-Pfad), und die wallclock-Zellen (total_ns/ns_per_op) sind Bestandteil derselben
Zeile. Also geht die Ergebnis-Familie im Traeger-x-Ebene-Schnitt AUF:

* **w-Blatt (b x w)** traegt die bisherige Ergebnis-Zeilenform: Zeile pro Messergebnis, ALLE
  Permutationen als Zeilen (binary_id/setting = Zeilen-Schluessel), akkumulierte Werte + write_url-
  Verweise hinab (compare-Funktion der Blattform).
* **ma-/mi-Blaetter** tragen die Profil-Zeilen (3.2) je Funktion bzw. Achse.
* Die drei Unter-Ebenen Mess->System->Organ bleiben in BEIDEN Rollen erhalten, die sie ausserhalb des
  Blatt-Schnitts schon haben: als Ketten-Glieder 12-14 (Ordnung im Lager) und als Zeilen-/Gruppen-
  Schluessel im Blatt (`SheetSchluessel{mess_unter,system_unter,organ_unter}` wandert vom Blatt-
  Schluessel zum Zeilen-Gruppen-Schluessel; Typ bleibt).

Der verbleibende echte Widerspruch (KON74-04 15.08. "EIN Sheet je Permutation" vs. V3 16.08.) ist
offener Punkt **P1** — die Vorlage empfiehlt die Aufgehen-These oben; INFO-Sheet und EINE-Datei-Doktrin
stehen in keiner Fassung im Widerruf.

### 3.4 PMC

PMC-WERTE stehen als Spalten im Blatt (Owner 07.08.: "Die cacheline aware dTLB und Cache Layer PMC
Werte ... ALLE"). Die PMC-PERMUTATION (Meta-Meta, dreiphasig, AMD != Intel) ist Umwelt im Sinne von V7
und wohnt als Meta-Meta HINTEN im System-Rekombinations-Glied der Kette (D-09) + im INFO — sie schneidet
KEINE Blaetter. Restfrage als **P3**.

---

## 4. INFO-SHEET-ROLLE: der Resolver des doppelten Sparse-Prinzips

Sparse Namen sind nur zulaessig, weil das INFO-Blatt jede Auslassung verlustfrei aufloest. Sechs
Funktionen (IST-Kategorien am Objekt: ergebnis_mappe.hpp:539-559, Schema `kategorie;schluessel;wert`):

1. **Sysinfo/Umwelt** (`sysinfo;...`): 8 Felder der messenden Maschine inkl. identity_verdict,
   n/a-statt-Null-Doktrin (:117-131) — die V7-Umwelt-Seite der Messung.
2. **Haupt-Achsen-Spiegel** (`hauptachse;...`): die Ordner-Glieder der Kette in der Mappe — macht die
   Datei selbsttragend, obwohl ihr Name sparse ist (Namen disjunkt ueber Mess/System/Organ, :107-110).
3. **Konstanten-Meta** (`konstante;...`): die aus dem Dateinamen weggelassenen, nicht variierenden
   Unter-Achsen — das Komplement der Datei-Sparsity; nichts verschwindet still (:112-115).
4. **Sheet-Legende** (`sheet_legende;...` / `mess_ebene_legende;...`): je Blattname der VOLLE
   Funktions-Schluessel (ebene|traeger|gegenstand; bei h16-Ueberlauf der Voll-Bezeichner; nach P1 die
   Zeilen-Gruppen-Schluessel) — der formale Resolver der Namens-Sparsity und Ersatz der S001-Legende.
5. **Stempel-/Erkennungs-Quelle**: die Lager-Factory erkennt Stempel aus Messwerttabellen "im
   LEGENDEN-/Info-Sheet" (Owner 06.08., Ledger:23684-23688) — das INFO wird maschinell konsumiert,
   seine Zeilenformen sind Vertragsflaeche, nicht Kosmetik.
6. **Freigabe-Karte** (Design-Zusatz dieser Vorlage, aus der honest-Doktrin): je (Traeger x Ebene)-Zelle
   der Schalter-/Interface-Zustand des Versuchs (`freigabe;<zelle>;an|aus|kein_interface`) — erklaert
   beim Lesen, WARUM ein Blatt fehlt (Falsch-Null-Schutz), und traegt die Ebenen-ORDNUNG des Versuchs
   (kompilierte CEB-Permutation), damit Blattfolge und Mess-Baum rekonstruierbar sind.

Position: INFO als ERSTES Blatt der Mappe (Einstieg + Legende vor Daten; Festlegung dieser Vorlage,
keine Owner-Frage). CSV-Kind: `INFO__<stamm>.csv` (2.3). Beide Blatt-Familien-Erben nutzen DASSELBE
INFO (08.08.: "dieselbe Factory, dieselbe 31-Zeichen-Wache, dasselbe INFO-Sheet").

---

## 5. OFFENE OWNER-PUNKTE (nur echte)

**P1 — Aufgehen der Permutations-Familie**: KON74-04 (15.08.) restatet "EIN Sheet je gewaehlter
Unter-Achsen-Permutation"; V3 (16.08.) setzt den Schnitt auf Traeger x Messebene mit allen Parametern im
Blatt. Vorlage-Empfehlung (3.3): die 26.07.-Familie geht in der w-Ebene auf, die Permutation wird
Zeilen-Schluessel (binary_id/setting), SheetSchluessel wird Zeilen-Gruppen-Schluessel. Bestaetigt der
Owner das Aufgehen — oder bleiben beide Familien als getrennte Blaetter in der Mappe?

**P2 — Zeilenlimit-Politik der hierarchischen Blaetter**: Profil-Blaetter schreiben 2 Zeilen je Aufruf;
1.048.576 ist real erreichbar. Geltende Doktrin: harter `ErgebnisSchreibFehler{zeilenlimit}` statt
stillem Truncate (Fassung 2). Soll das fuer Traeger-x-Ebene-Blaetter so bleiben (Messlauf bricht), oder
ist ein deterministisches Fortsetzungsblatt gewollt (Namens-Glied `.2`, `.3`, EBNF-Reserve vorhanden,
max. 26 Zeichen)?

**P3 — PMC-Einordnung im Sheet-System**: PMC-Werte als Spalten und PMC-Permutation als Umwelt-Glied der
Kette (D-09, Meta-Meta hinten) ist die Ableitung dieser Vorlage (3.4). Bestaetigt der Owner, dass die
dreiphasige PMC-Permutation (AMD != Intel) NUR Kette+INFO permutiert (ggf. mehrere Mappen je Phase) und
keine eigene Blatt-Dimension (Traeger x Ebene x PMC-Phase) aufspannt?

Nicht offen (in den Quellen entschieden, hier nur dokumentiert): w/ma/mi-Tokens (Owner adoptiert sie in
V3 selbst); "compare" als Begriff der w-Ebene (Code-Gleichsetzung Wallclock=Compare); Ebene anfuehrend
im CSV-Namen (Owner 08.08. woertlich); Traeger-Glied nur bei Mehrdeutigkeit (= "nur sparse benannt");
EINE Datei je Versuch + INFO-Sheet (26.07., nirgends widerrufen); Spaltenmenge = lazy_csv_header
(KON74-04, von V3 unberuehrt); compare-Blattzahl >= 1 (Code loest die 1-vs-je-Rekombination-Spannung
durch Allgemeinheit, ergebnis_mappe.hpp:145-151).

---

## 6. BAU-DELTAS IST -> SOLL (Landungs-Liste, kein Owner-Input noetig)

* **D1** `mess_ebene_sheetname()` (ergebnis_mappe.hpp:320-332): Praefixe `C_/M_/X_` -> Tokens
  `w./ma./mi.` + Traeger-Glied-Regel (nur Hybrid-Zweig ma/mi) + h16-Ueberlauf statt S00N-Fallback;
  `sheet_label_fuer_index()` verliert die Namensrolle (S001 abgelehnt), bleibt hoechstens interner Index.
* **D2** (nach P1) `blatt(SheetSchluessel)` von Blatt-Schluessel auf Zeilen-Gruppierung umstellen;
  `sheet_legende`-Zeilen tragen dann Gruppen- statt Blatt-Aufloesung.
* **D3** CSV-Kind-Namen invertieren: `<stamm>__<label>.csv` -> `<label>__<stamm>.csv` (Owner 08.08.:
  Ebene anfuehrend; IST-Stellen :505/521/532/573/582/590).
* **D4** `MessEbene` bekommt einen Anzahl-Anker (static_assert == 3) + Kommentar, dass Hybrid als
  Traeger-Differenzierung laeuft, nie als 4. Enum-Wert (entschaerft Test-#465-Risiko).
* **D5** Verdachts-Notiz: Kommentar "17 seg_<axis>_ns-Spalten" bei 18er-Schleife ueber
  kCompositionAxisNames (cache_engine_builder_iterator.hpp:572-Umfeld) — am Bau verifizieren
  (ORG-18-Nachzug), reine Doku-Drift.
* **D6** INFO um `freigabe;`-Kategorie erweitern (4.6) — additiv, bestehende Kategorien unveraendert.

Selbstcheck: Alle Behauptungen tragen Quell-Anker (Ledger-Zeilen, Session-Backups, Code file:line);
keine statischen Nenner vorgelegt (S-19-Doktrin); Kuerzel zerlegt (w/ma/mi = wallclock/macro/micro;
p/b/t/h = Planer/CEB/Tier/Hybrid; iw/ima/imi = Aufzeichnungs-Interface-Flags, NICHT Ebenen).
