# DESIGN G-1P v2 -- PMC-SCHWESTER: DUAL-KATEGORIE-GRAMMATIK der dreiphasigen PMC-Meta-Meta-Achse

> **Status: ENTWURF als OWNER-VORLAGE -- KEIN BAU.** Task #53, Schritt 2: v2 des PMC-Schwester-Designs
> NACH der komplett entschiedenen F-P-Runde (F-P1..F-P10, KON71/KON72) und der Familien-Runde F1-F7+R-F7.
> **Datum:** 15.08.2026 + **Quellen:** kon64_sammlung.md Teile 12-22 (Teile 12/13 = KON71-Stoff,
> Teile 14/15 = KON72-Stoff, Teile 16-22 = KON73-Stoff; "KON73" im Ledger 0 Treffer, Gegenprobe
> "KON72" = Ledger :19 -- die Teile 16-22 sind hier die Primaerquelle) + super-Ledger Kopf KON72/KON71
> + G-1-Design Par. 12 (Finalfassung, docs/plaene/20260813-DESIGN-g1-grammatik-dreiphasige-messachse.md)
> + V1-Vorlage tmp/design_pmc_grammatik.md (PM-1..PM-10, BP-1..BP-5) + Achsen-Hierarchie-Explore
> wf_1f981ed4 (Teil 21, Hybridform-Karte) + F-P8-Explore wf_3337a24d (Teil 16) + No-Bloat-Explore
> wf_9d604fea (Teil 14-B) + WEB-RECHERCHE 15.08. (Par. 8, Quellen dort zitiert).
> **Schwester-Dokument zu:** G-1 (Mess-Belegung) und V1 (G-1P). V1 bleibt stehen; dieses v2 traegt
> die Owner-Korrekturen und ERSETZT V1 in der Sache, wo unten ausdruecklich "UEBERHOLT" steht.
> **Syntax-Auflage 14.08. eingehalten:** jedes Kuerzel ZERLEGT gefuehrt (`c{p.e}` = Basis `c` +
> Sub-Flags; `pmc{c{p.e}}` = Basis `pmc` + Komposit; `iw` == `i{w}`) -- flache Formen existieren NICHT.
> **Zaehl-Auflage (dritte 32er-Ruege, F-P6):** dieses Dokument RECHNET KEINE Nenner. Die
> Mess-Permutation ist DYNAMISCH > 32; NUR die Planer-Simulation S-19 errechnet sie. Die
> V1-Zaehlung "5 Zustaende je pmc-Host" (V1 Par. 6) ist hiermit ZURUECKGEZOGEN.

---

## 0. Die Owner-Entscheide der Runden (verbatim-Kerne, mit Fundstelle)

**F-P1 FREIGEGEBEN + vier neue Kerne (Teil 12, KON71):**

1. BASIS-KLASSE: *"das PMC hat eine Basis-Klasse von der die jeweilig unterstuetzten PMC
   Implementierungen erben (Es gibt ja auch mehrere PMC-Typen auch wenn wir erstmal nur p und e
   unterstuetzen, es gibt ja auch Spezial-ISA die nochmal andere Kerne und PMC haben wird)."*
2. FACTORY-PARSER: *"Daher gibt es einen Factory parser, der zur Laufzeit des freigebenden Parsers
   voll ausgepraegt ist, aber zur Erkennung in den anderen DREIPHASIG Vertraegen werden compile time
   nur die Varianten mitgegeben, die wirklich potentiell vom Planer angefordert werden -> weitere
   echte compile time Permutation ueber nachfolgende Traeger-Stufen."*
3. EINE META-META-ACHSE: *"Das PMC bildet unter den Mess-Achsen, wenn vorhanden, eine einzige
   Meta-Meta-Achse mit Spezifikationen welche verschiedenen PMCs auf der CPU integriert sind."*
4. DOPPELTE VERSIONIERUNG: *"das PMC [benoetigt] eine Hardware Versionierung UND eine Software
   Versionierung unserer Algrithmik (das ist ein wenig wie bei TMP Modulen der Version 1.2 vs 1.3)
   und wir [muessen] aufgrund der Zuordnung zu Mess-Achsen und System-Achsen auch die Versionierung
   jeweils doppelt ausfuehren in korrekter Reihenfolge der Stapelung von
   Mess-Achsen/System-Achsen/Organ-Achsen."*
5. WEB-RECHERCHE-ORDER: *"Hardware bitte Web Recherche zu den vorhandenen CPUs je Kern-Typ"*
   (Zen 5 9950X3D / RaptorLake-Etikett i9-12900K P+E / kuenftige Spezial-ISA) -- geleistet in Par. 8.

**F-P2 SICHTEN-TRENNUNG (Teil 12) + NO-BLOAT (Teil 13, KON71):** *"Die Binaries interessiert nicht
das, was potentiell freigegeben werden kann, sondern was per Binary-Kompilat tatsaechlich dort
umgesetzt ist. Wir kennen kein Konzept fuer 'Software wurde eingebaut, aber wird nicht verwendet',
sondern nur 'Hardware ist vorhanden und wird nicht durch Software verwendet'."* Dazu: *"wir als
default nie Software bauen, die durch die Harware gar nicht gedeckt ist [...] Kompatibilitaet nur
durch das Abspecken der Binaries unter den Funktionsumfang der Hardware [...] Daher zeigt der
Stempel auch nur das was per Binary eingebaut ist [...] Es ist die Aufgabe des Planers fuer
dual-Bereich Sonder-Hardware wie PMC (Hybrid zwischen Mess-Achse und System-Achse), die Freigabe
der Hardware zu gewaehrleisten."*

**F-P3 BESTAETIGT + AUFZEICHNUNG != MESSFUEHLER (Teil 13, KON71):** *"Korrekt, das ist eine
Architektur-Regression, die CEB muss mindestens das unterstuetzen, was sie von nachfolgenden am
Pruefdock angeschlossenen Traeger-Stufen erwartet, aber: Das gilt nur fuer die
Aufzeichnungseinrichtung, nicht fuer die Messfuehler. [...] also muss zu w/ma/mi Benchmarking auch
die Flag-Dimension der Aufzeichnungs-Interface Flags einer niederen Traeger-Stufe gegen die
Nachfolgende integriert werden also ima/imi fuer das Vorhandensein der CEB Interface gegen
nachfolgende eingebaute Messfuehler der Tier/Hybrid. Dasselbe gilt fuer den Planer fuer iw [...]
Wenn eine vorangehende Traeger-Stufe das Interface der nachfolgenden nicht lesen kann, koennen
keine Messdaten zu diesem Thema erhoben werden."*

**F-P4 ENTSCHIEDEN (Teil 14, KON72):** *"Die technische Reihenfolge aller Traeger Stufen ist
Planer/CEB/Hybrid/Tier und daher p/b/h/t der Traeger-Stufen."* + *"Die Reihenfolge von p/b/h/t ist
strikt und h kann optional bei Vorhandensein von hybrid eingeschoben werden."* + *"Die PMC ist aus
der eingebauten dreiphasigen Sicht in der CEB immer mindestens ein System-Achsen-Eintrag und nur
wenn es der Planer ueber die Mess-Achsen zulaesst auch ein CEB Mess-Achsen Eintrag, es gibt also
Potentiell die Achsen-Grammatik fuer PMC in bis zu zwei Achsen-Kategorien zugleich, weil der Planer
hier die Dreiphasigkeit ueber CEB vs Tier/Hybrid freigibt."* SYNTAX-BEISPIELE (verbatim):
*"pmc{c.{p.e}}.b.t oder pmc{c.{p.e}}.b.h oder pmc{c.{p,e}}.h.t"*; p/e = *"Flags fuer zwei
verschiedene PMC"* unter c; AEQUIVALENZ: *"pmc{c.{p.e}}.b.t == {pmc{c.{p}}.b.t, pmc{c.{e}}.b.t}"*
(komprimierte vs. expandierte Form). Schreibweisen-Normalisierung der Transkript-Varianten: Par. 2.4.

**F-P7:** *"Korrekt Option A wie empfohlen."* (cpu_sub c{p}/c{e}/c{p.e}; W7-Andockstelle ZU.)
**F-P9:** *"Empfehlung ist jetzt korrekt, volles GO, genau so. Wir heben auf C++23
Metaprogrammierung an."* **F-P10:** *"korrekt."* (XML sagt WO, der Host sagt OB/WELCHER Vendor.)

**F-P8 VOLLES GO + AND-FREIGABE STATT PROXY (Teil 14, KON72):** *"die PMC-Mess-Achse [ist] schon
genau so geplant [...] diese Meta-Meta-Achse war schon immer der HAUPTTRAEGER AUF DEM PLANER ueber
ihre dreiphasige Eigenschaft."* KORREKTUR: *"Das System-Proxy ist nicht ganz korrekt, weil immer
vorangehende Traeger-Stufen nachfolgende freischalten, so wie auch vorangehende Achsen-Kategorien
nachfolgende freischalten, daher darf die System-Achse PMC nur umsetzen, wenn die Mess-Achse sie
erlaubt, auch wenn die Mess-Achse das Vorhandensein von PMC formal feststellt und Freigibt
(AND-Freigabe aus zwei Achsen-Kategorien in hierarchischer Reihenfolge)."*
(Wort-Hygiene, Teil 16: der Begriff "Haupttraeger" stammt aus der Session-Rueckfrage und wurde vom
Owner uebernommen -- der GEGENSTAND ist owner-gesetzt, das Wort ist Sitzungs-Vokabular.)

**F1 PLANER-VOLLBILD (Teil 19, KON73-Stoff), Kerne verbatim:** *"der Planer ist fest kompiliert und
hat Mess-Achsen Stempel ueber die Eigenschaften, die beim cmake compile und Erkennung auf dem
System erkannt werden koennen (compile time werden Mess-Meta-Meta-Achsen erkannt und als C++23 abi
stabiles Modul und Metaprogrammierung einkompiliert, der Planer ist zusaetzlich die einzige
Traeger-Stufe die Binary bloated mehr Funktionen einkompiliert haben darf, als sie benoetigt, um
ueber ALLE Systeme [...] kompatibel zu sein [...]). Das heisst alle Meta-Meta-Achsen werden durch
CMake im Planer gesetzt mit voller Funktonalitaet der Analyse. [...] fuer einen vollstaendigen
Systemtest [muss] der Planer erst gebaut werden, er in der Kette dann seinerseits die anderen
Traeger-Stufen angepasst an die XML und die Systemvorgaben baut. Grundsaetzlich hat der Planer
daher dann doch eine Stempel-Zeile ueber freigebbare Mess-Achsen und daher auch die
Meta-Meta-PMC-Achse auf den Mess-Achsen, aber System-Achsen sind weiterhin nur auf der CEB
aufwaerts zu erkennen. Die Mess-Interfaces sind technisch gesehen eine eigene Mess-Haupt-Achse,
weil unabhaengig vom Vorhandensein von Mess-fuehlern aller Traeger-Stufen trotzdem die Interfaces
gebaut werden koennen."*

**F2 CT-WACHE (Teil 19):** *"Ja korrekt, das ist eine Compile time Wache der dreiphasigen Freigabe
durch den Planer, der die CEB in ihrer Freigabe-Entscheidung gegenueber Vertraegen von sich selbst
gegen Tier/Hybrid begrenzt. Genau wie empfohlen."*

**F3 SYSTEM-ONLY (Teil 19):** *"Die System-Achse gibt ein potentielles Feature frei, welches die
XML per Planer und daher compile time CEB verbieten. Daher wird der System-Achsen Eintrag
mitgefuehrt kann aber mangels Mess-Achsen-Eintrag nicht ausgepraegt werden bzw. ist bereits in der
CEB implizit ausgebaut. Bestaetigte Lesart, Freigabe. Wieder ein Sonderfall in dualen
Achsen-Kategorie dreiphasigen Systemen."*

**F4 DUAL = WEG (b) + HYBRIDFORM (Teil 19):** *"Es ist in erster Linie Weg (b), aber gleich danach
auch durch die in den Plaenen beschriebene Hierarchisierung mehrerer geschachtelter Haupt-Achsen in
Verbindung zu Meta-Meta-Achsen Erweiterungen und Komplexen Achsen-Klammerungen, eine Hybridform aus
beiden."* (Explore-Order dazu gefahren: wf_1f981ed4, Teil 21 -- Synthese in Par. 3.)

**iw/ima/imi-ZUSAMMENHANGS-KERN (Teil 17):** *"sie [betreffen] speziell die Steuerungs- und
Mess-Flaechen-Interfaces an den Zwischenvertraegen [...] und deren Vorhandensein kennzeichnen [...]
Volles go hierfuer."* -- Zwischenvertraege = Planer<->CEB und CEB<->Tier/Hybrid; verbindet die
Flags mit Flaeche 3 (measurement-Durchstich) UND dem Steuerkanal (6 Steuerdocks).

---

## 1. Delta zur V1-Vorlage: was von PM-1..PM-10 steht, was faellt

| Regel (V1) | Stand nach den Runden |
|---|---|
| PM-1 EIN PARSER | UNVERAENDERT (Doppel-Version = Profil-Lesung, Par. 2.2 -- kein zweiter Zerleger) |
| PM-2 Abwesenheit = kein Eintrag | GESCHAERFT: F-P2-Sichten-Trennung; System-only-Sonderfall Par. 3 |
| PM-3 Vendor = Wert (amd|intel) | UNVERAENDERT; Doppel-Version haengt je Kategorie am Vendor-Eintrag |
| PM-4 Stufen-Menge IN der Klammer | UEBERHOLT (F-P4): Stufen wandern in die SUFFIX-KETTE strikter Ordnung |
| PM-5 CEB-Voraussetzung (b vor t/h) | BESTAETIGT (F-P3) + praezisiert: b-Pflicht = AUFZEICHNUNGS-Seite |
| PM-6 Spiegel-Ordnung zu m-Slots | UEBERHOLT (F-P4): Ordnung ist owner-fix p/b/h/t -- KEINE Anordnungs-Info |
| PM-7 Drei Phasen + Phase-1-Ausnahme | KORRIGIERT (F-P8): System-"Proxy" -> AND-FREIGABE zweier Kategorien |
| PM-8 pmc-fuehrender Kind-Stempel | BESTAETIGT (F-P5) + Micro je Achsen-/Macro je Genus-Interface dreiphasig |
| PM-9 Exaktheit + Vendor-Riegel | UNVERAENDERT + HW-Ver-Gleichheits-Wache ueber die zwei Kategorien |
| PM-10 CPU-Pflicht (.c) | UNVERAENDERT (M-10/M-11-Erbe gilt mit) |

Neu hinzu treten PM-11..PM-16 (Par. 2.3). Die V1-Paragrafen 6 (Zaehlung) und 8 (W7-Optionen) sind
GESCHLOSSEN: Zaehlung zurueckgezogen (F-P6, Kopf), W7 = Option A (F-P7).

---

## 2. Die Eintrags-Grammatik

### 2.1 EBNF (Profil der v2 -- Token-Syntax unveraendert, EIN Parser)

    -- (E1) DER EINE EINTRAG -- zeichengleich in BEIDEN Kategorien-Zeilen verwendbar:
    pmc_eintrag    := 'pmc' '=' vendor_id '@' doppel_version '.' cpu_pflicht '.' pmc_flag stufen_kette
    vendor_id      := 'amd' | 'intel'                -- WERT aus kPmcVendorRegistry (PM-3)
    doppel_version := hw_version '.' sw_version      -- DOPPELTE VERSIONIERUNG (F-P1(4)): HW VOR SW,
                                                     -- positionsfest: GENAU 6 UINTs vor 'c'
    hw_version     := UINT '.' UINT '.' UINT         -- Hardware-Version der PMC-Komponente (Par. 8.4)
    sw_version     := UINT '.' UINT '.' UINT         -- Software-Version "unserer Algorithmik"
    cpu_pflicht    := 'c' [ '{' kern_liste '}' ]     -- F-10/M-10-Erbe; Host-Kerntypen (G-2 cpu_sub)
    kern_liste     := kern [ '.' kern ]*             -- je Token hoechstens einmal (M-11-Erbe)
    kern           := 'p' | 'e'
    pmc_flag       := 'pmc' '{' typ_spec '}'         -- GENAU EIN pmc-Flag: die SPEZIFIKATION,
                                                     -- "welche verschiedenen PMCs auf der CPU
                                                     -- integriert sind" (F-P1(3))
    typ_spec       := 'c' '{' pmc_typ [ '.' pmc_typ ]* '}'   -- Komposit unter c (F-P4); {p} = Default
    pmc_typ        := 'p' | 'e'                      -- HEUTE p/e; Spezial-ISA-Typen ADDITIV (F-P1(1))
    stufen_kette   := ( '.' stufe )+                 -- STRIKTE ORDNUNG p,b,h,t (F-P4); jede Stufe
    stufe          := 'p' | 'b' | 'h' | 't'          -- hoechstens einmal; h optional einschiebbar

    -- (E2) DUAL-STAPEL (F-P4/F3): derselbe Eintrag in bis zu ZWEI Achsen-Kategorien-Zeilen,
    --      Stapel-Ordnung = Kategorien-Hierarchie MESS VOR SYSTEM (F-P1(4)/F-P8):
    pmc_dual       := [ pmc_mess ] pmc_system
    pmc_mess       := pmc_eintrag                    -- EINRICHTUNG: NUR bei Planer-Zulassung
    pmc_system     := pmc_eintrag                    -- FAKTUM/POLICY: IMMER bei Einbau (Par. 3)

    -- (E3) INTERFACE-ACHSE (F1(5)/F-P3/Teil 17): EIGENE Mess-HAUPT-Achse, eigener Registry-Eintrag:
    iface_eintrag  := iface_id '@' UINT '.' UINT '.' UINT '.' 'c' '.' iface_flag
    iface_flag     := 'i' '{' instrument [ '.' instrument ]* '}'
    instrument     := 'w' | 'ma' | 'mi'              -- ZERLEGT: "iw" == i{w}, "ima" == i{ma},
                                                     -- "imi" == i{mi} (Owner-Kurznamen der Elemente)

Tiefe des pmc-Baums: pmc=0, c=1, typ=2 -- unter kMaxFlagDepth == 4; Knoten je Eintrag maximal
1+1+2 (pmc,c,p,e) + Suffix-Stufen als Geschwister-Flags der Versionszeile: alles weit unter
kMaxFlagNodes == 96. Die Produktion ist ABSCHLIESSEND: zwischen cpu_pflicht und pmc_flag steht
NICHTS; hinter der stufen_kette steht NICHTS.

### 2.2 Die Doppel-Version im EINEN Parser (Stufe-A-Naht, benannt)

parse_algo_semver parst heute EIN X.Y.Z + Flags. Das Profil liest die 6 UINTs POSITIONSFEST
(erste drei = HW, naechste drei = SW) und reicht `sw_version.c...`-Rest als v2-Form durch --
die Zerlegung ist eine PROFIL-Regel der Wache `pmc_entry_version_is_wellformed()` (V1 Stufe C),
KEIN zweiter Parser. Fail-closed: nicht exakt 6 UINTs vor 'c' = Formfehler. Die Registry-Literale
bleiben BELEGUNGS-FREI und tragen kuenftig BEIDE Versionen getrennt (Par. 5).

### 2.3 Die neuen Regeln PM-11..PM-16

* **(PM-11) DOPPEL-VERSION JE KATEGORIE-STAPELPOSITION.** Jeder pmc-Eintrag traegt hw_version VOR
  sw_version (F-P1(4): TMP-Modul-Analogie). Er erscheint je Kategorie-Stapelposition ERNEUT mit
  beiden Versionen, in der Stapel-Reihenfolge Mess-Achsen VOR System-Achsen (Organ traegt nie PMC).
  WACHEN: vendor_id und hw_version beider Kategorien-Eintraege IDENTISCH (EIN Host, EINE Hardware,
  Owner 10.08.: "2 verschiedene hardware Komponenten", nie beide in einem Kompilat); sw_version
  DARF je Kategorie differieren (getrennte Algorithmik-Staende Mess-Einrichtung vs. System-Policy
  -- Empfehlung, Bestaetigungs-Punkt OP-4).
* **(PM-12) DUAL-ZUORDNUNG.** System-Eintrag IMMER bei Einbau (Faktum/Policy als mitgefuehrtes
  Potential); Mess-Eintrag NUR bei Planer-Zulassung (Einrichtung). AND-FREIGABE als CT-Wache:
  die System-Achse darf PMC nur UMSETZEN, wenn der Mess-Eintrag es erlaubt (F-P8/F2; Par. 3).
* **(PM-13) SUFFIX-ORDNUNG STRIKT.** Die stufen_kette folgt der Ort-Kette p,b,h,t; jede Stufe
  hoechstens einmal; h optional einschiebbar (F-P4). Die Kette traegt KEINE Anordnungs-Information
  (Kontrast zu M-6: dort ist Anordnung Information; hier ist sie owner-fix). `p` erscheint NUR auf
  der Planer-eigenen Mess-Zeile (freigebbare Sicht, Par. 4); System-Eintraege beginnen fruehestens
  bei `b` ("System-Achsen sind weiterhin nur auf der CEB aufwaerts zu erkennen", F1).
  Namensraum-Doktrin: p(Stufen-Suffix) und p(P-Core in c{}/typ_spec) sind GETRENNTE Elemente ueber
  Position ((token,eltern)-Paar; KON72-02 woertlich "Grammatik-Wache je Position").
* **(PM-14) KOMPRIMIERT == EXPANDIERT.** `pmc{c{p.e}}.b.t == { pmc{c{p}}.b.t , pmc{c{e}}.b.t }`
  (F-P4 verbatim). Die komprimierte Form ist der Stempel EINES Kompilats, das beide Werke traegt
  (W7 Option A: "eine CEB kann beide Messfuehler tragen"); die Expansion benennt die getrennten
  Mess-Welten je Werk (Pinning-Laeufe = System-Achsen-Permutation, Owner 06.08.). Der Parser
  NORMALISIERT NICHT (v2-Doktrin); die Aequivalenz ist WACHEN-/Planer-Wissen (Lager paart je
  expandierter Welt, PM-9).
* **(PM-15) INTERFACE-ACHSE.** i{w}/i{ma}/i{mi} bilden eine EIGENE Mess-HAUPT-Achse (F1: Interfaces
  sind unabhaengig vom Fuehler-Vorhandensein baubar). Jede Traeger-Stufe stempelt die Interfaces,
  die SIE gegen die NACHFOLGENDE Stufe traegt (Zwischenvertraege Planer<->CEB, CEB<->Tier/Hybrid;
  Teil 17). Planer traegt i{w} "in der Regel immer" (F-P3). Abwaerts-Funktionsumfangs-Regel gilt
  NUR fuer diese Aufzeichnungs-Seite, nicht fuer Fuehler. Kennzeichnung des PMC-Zwischenvertrags
  (Kandidat i{pmc}) ist Vokabular-Erweiterung -> OP-2.
* **(PM-16) FACTORY-PARSER-REGEL.** Beim FREIGEBER (Planer) ist der Factory-Parser zur Laufzeit
  VOLL ausgepraegt (alle registrierten Werke); in die dreiphasigen Vertraege werden compile time
  NUR die planer-angeforderten Varianten mitgegeben = weitere echte CT-Permutation ueber
  nachfolgende Traeger-Stufen (F-P1(2)). Umsetzung C++23-Metaprogrammierung (F-P9).

### 2.4 Schreibweisen-Normalisierung der Owner-Beispiele (deklariert, OP-5)

Die Transkript-Formen `pmc{c.{p.e}}` und `pmc{c.{p,e}}` werden normalisiert zu `pmc{c{p.e}}`:
(a) v2-R3 bindet die Basis DIREKT an ihre Klammer (kein Punkt zwischen c und {); (b) ein
Komma-Token existiert in der v2 nicht -- `{p,e}` liest sich als `{p.e}`; (c) die Zerlegungs-Pflicht
14.08. verlangt Basis+Sub-Flags. Der GEGENSTAND der Owner-Beispiele (p/e als Flags zweier PMCs
unter c; Suffixe hinter der Klammer) bleibt woertlich erhalten. Bestaetigung als OP-5 vorgelegt.

---

## 3. Die DUAL-Zuordnung: Weg (b) + Hybridform

**Owner-Karte (F4 + Teil 21(d), Explore-Synthese wf_1f981ed4 -- Cluster gegen Plan geprueft):**
die drei Mechanismen Hierarchisierung / Meta-Meta-Erweiterung / komplexe Klammerung wirken an PMC
GLEICHZEITIG, nicht alternativ. Fuer die Grammatik heisst das:

1. **System-Eintrag = FAKTUM + POLICY, IMMER bei Einbau, als MITGEFUEHRTES POTENTIAL (F3/F-P4).**
   Er dokumentiert genau die Owner-Kategorie "Hardware ist vorhanden und wird nicht durch Software
   verwendet" (F-P2) -- er ist Hardware-Faktum plus Freigabe-Policy, KEIN Software-Bloat. Die
   No-Bloat-Doktrin bleibt unverletzt: eingebaut wird Mess-seitig nichts, solange die Zulassung
   fehlt ("bzw. ist bereits in der CEB implizit ausgebaut", F3).
2. **Mess-Eintrag = EINRICHTUNG, NUR bei Planer-Zulassung (F-P4).** Eingebaut == verwendet; einen
   Drittzustand "eingebaut aber unverwendet" kennt die Software-Seite nicht (F-P2).
3. **AND-FREIGABE als CT-Wache (F-P8-Korrektur + F2).** Vorangehende Achsen-Kategorien schalten
   nachfolgende frei (wie Traeger-Stufen): die System-Achse darf PMC nur UMSETZEN, wenn die
   Mess-Achse sie erlaubt -- auch wenn die Mess-Achse das Vorhandensein formal feststellt.
   Form (Bau-Naht, kein Bau hier):
   `static_assert(!kPmcSystemUmsetzung || kPmcMessZulassung, "...")` als "Compile time Wache der
   dreiphasigen Freigabe durch den Planer, der die CEB in ihrer Freigabe-Entscheidung gegenueber
   Vertraegen von sich selbst gegen Tier/Hybrid begrenzt" (F2 verbatim). Fail-closed in jeder Lage.
4. **Sonderfall SYSTEM-ONLY (F3).** XML/Planer verbieten die Mess-Nutzung: der System-Eintrag wird
   mitgefuehrt, ist aber nicht ausgepraegt -- die Mess-Zeile traegt KEINEN pmc-Eintrag (PM-2), das
   Kompilat enthaelt keine Mess-Einrichtung. "Wieder ein Sonderfall in dualen Achsen-Kategorie
   dreiphasigen Systemen."
5. **Hybridform-Anteil (F4).** Die Traeger-Hierarchie faehrt DIREKT in der Klammer-/Suffix-Syntax
   (p/b/h/t, PM-13); Meta-Meta-Erweiterungen haengen ADDITIV am Ende der Realm-Zeile (E2-Regel);
   die komplexe Klammerung (Komposit-Rekursion c{p.e}) traegt die Werk-Spezifikation. Der
   Planer-Vertrags-Slot (G-1 Par. 12.4: eigene CEB-Zeile vor dem SHA, im Hashing) ist die
   Stempel-Stelle, an der Hierarchisierung und Klammerung zusammenlaufen.

**Abwesenheits-Matrix (PM-2 geschaerft):**

    Hardware fehlt                      -> KEIN Eintrag in KEINER Kategorie (Probe fail-closed)
    Hardware da, kein Einbau im Blick   -> KEIN Eintrag (Stempel = nur Umgesetztes)
    Hardware da, Einbau, keine Zulassung-> NUR System-Eintrag (mitgefuehrtes Potential, F3)
    Hardware da, Einbau, Zulassung      -> Mess-Eintrag UND System-Eintrag (Dual-Vollbild)

---

## 4. Das Planer-Kapitel (F1/F-P1(2)/F-P2erg/F-P9)

* **BLOAT-AUSNAHME:** der Planer ist die EINZIGE Traeger-Stufe, die mehr Funktionen einkompiliert
  haben darf als benoetigt -- Universal-Einstiegspunkt ueber ALLE Systeme, "nach seinem grob
  angepassten Selbst-compile" (F1). Fuer alle anderen Stufen gilt No-Bloat/Abspecken (F-P2erg).
* **CMAKE-META-META-ERKENNUNG:** alle Meta-Meta-Achsen werden beim CMake-Compile des Planers
  erkannt und "mit voller Funktonalitaet der Analyse" gesetzt -- als C++23 abi-stabiles Modul +
  Metaprogrammierung (F1/F-P9). Die PMC-Laufzeit-Probe (pmc_host_probe, je LAUF) bleibt daneben
  die Phase-1-Hardware-Wahrheit; CMake setzt die ANALYSE-Faehigkeit, die Probe den Host-BEFUND.
* **PLANER-STEMPEL-MESS-ZEILE UEBER FREIGEBBARE ACHSEN:** der Planer traegt eine Stempel-Zeile
  ueber FREIGEBBARE Mess-Achsen inkl. der PMC-Meta-Meta-Achse (F1) -- Lesart der freigebenden
  Seite (impliziert), NICHT Belegung. System-Achsen erscheinen erst ab CEB. Damit loest sich der
  Schein-Widerspruch aus Teil 16 auf: G-1 Par. 12.4 haelt "kein p-SLOT im m-Flag" (Belegungs-Welt),
  waehrend das p-SUFFIX der pmc-Eintraege auf der Planer-Zeile die freigebbare Sicht traegt --
  zwei verschiedene Gegenstaende, keine Kollision.
* **SYSTEMTEST-REIHENFOLGE:** Planer zuerst bauen; er baut seinerseits die Folgestufen angepasst
  an XML + Systemvorgaben (F1). Deckt sich mit der check-size-Befundlage (Teil 16: die
  CEB-Rechen-Haelfte fehlt -- S-19-Design-Input #7, NICHT dieses Dokument).
* **FACTORY-PARSER:** PM-16. Der Planer haelt laufzeit-voll ALLE Werk-Varianten; jeder emittierte
  Vertrag bekommt CT nur die angeforderten -- "weitere echte compile time Permutation ueber
  nachfolgende Traeger-Stufen" (F-P1(2)).
* **PLANER-PFLICHT FUER DUAL-HARDWARE:** "Es ist die Aufgabe des Planers fuer dual-Bereich
  Sonder-Hardware wie PMC (Hybrid zwischen Mess-Achse und System-Achse), die Freigabe der Hardware
  zu gewaehrleisten, um ein sinnvolles Software-Kompilat in den Grenzen der Hardware zu laufen"
  (F-P2erg) -- der Planer ist der AND-Knoten der beiden Kategorien (Par. 3.3).

---

## 5. Basis-Klasse, Vererbung, Registry- und Proben-Rollen, Achsen-Heimat

* **BASIS-KLASSE + VERERBUNG JE PMC-TYP (F-P1(1)):** eine Basis `PmcWerkBasis`, von der die
  unterstuetzten Werk-Implementierungen erben -- heute `PmcWerkP` / `PmcWerkE` (p/e), kuenftig
  Spezial-ISA-Werke ADDITIV (Hardware-Erweiterung ist additiv-Doktrin). Hausform: CRTP + Concept,
  statischer Dispatch; die Vererbung ist die TYP-Achse, der Vendor bleibt WERT (PM-3). Namen sind
  Vorschlag; verbindlich wird der Bau-Explore am Objekt.
* **REGISTRY-ROLLE:** `pmc_vendor_registry.hpp` bleibt die Identitaets-Quelle der Vendor-Werte und
  wird beim Registry-Neubau (KON37-02-Anschluss, F-P9-Paket) WERK-GENAU erweitert: je (vendor,
  pmc_typ) ein Eintrag mit hw_version (aus dem Katalog Par. 8.4) und sw_version (je Kategorie,
  PM-11). Die heutige vendor-genaue Ein-Versions-Form ("1.0.0.c" je Vendor) ist die Vorstufe.
* **PROBEN-ROLLE:** `pmc_host_probe` bleibt die Phase-1-Erkennung (Laufzeit je Lauf, cpuid +
  perf_event_open + Koeder-Biss, fail-closed) und wird um den WERK-BEFUND erweitert: welche
  PMC-Typen integriert sind (typ_spec-Quelle: c{p}/c{e}/c{p.e}) und welche hw_version je Werk
  (Katalog-Lookup). Vendor kommt NIE aus der XML (F-P10: XML sagt WO, Host sagt OB/WELCHER).
* **ACHSEN-HEIMAT (F-P8 GO + Teil 16 a1):** die Mess-Seite faehrt als ZWEITER Traeger der gebauten
  CRTP-Wurzel `MeasurementMetaMetaAxis` (`PmcMeasurementMetaMetaAxis`, Vorbild load_framework);
  `PmcSystemAxis` BLEIBT im collector als System-seitige UMSETZUNG -- nach der F-P8-Korrektur
  nicht mehr "Proxy", sondern AND-gebundener Umsetzer (setzt nur um, wenn Mess erlaubt).
  Meta-Meta ist KEINE vierte Kategorie: AxisKind traegt je Realm einen ADDITIVEN
  meta_meta-Diskriminator (Teil 16 a1); die Dual-Zuordnung lebt als ZWEI Realm-Vertreter
  (Mess-Realm-Diskriminator + regulaere System-Achse), nie als neue Kategorie.

---

## 6. Meta-Meta-Rekursion je Realm -- benannte Design-Entscheidung MMR-1

Teil 21(b) haelt die Rekursions-Frage NUR fuer system_meta_meta explizit offen; fuer
measurement/organ war sie ungeklaert (Design-Punkt dieses Dokuments). ENTSCHEIDUNG:

* **measurement_meta_meta: KEINE REKURSION.** Die PMC-Achse ist BLATT-Meta-Meta ("eine einzige
  Meta-Meta-Achse", F-P1(3)); Varianten-Vielfalt laeuft ueber VERERBUNG (Basis-Klasse) und die
  typ_spec-Klammer, nie ueber Meta-Meta-auf-Meta-Meta. Erweiterungen haengen ADDITIV am Ende der
  Realm-Zeile (E2-Anhaenge-Regel); eine Rekursionsebene waere eine zweite Anordnungs-/
  Identitaets-Wahrheit ohne Owner-Gegenstand.
* **organ_meta_meta: KEINE REKURSION.** Kein Traeger existiert; die Additiv-Doktrin (nie
  Umklassifizierung) genuegt fuer alles Kuenftige.
* **system_meta_meta: HIER NICHT ENTSCHIEDEN.** Der Owner haelt die Frage dort ausdruecklich
  offen; die PMC-System-Seite BRAUCHT die Rekursion nicht (regulaere System-Achse + additiver
  Diskriminator, Par. 5). -> OP-1, mit dieser Entlastungs-Feststellung vorzulegen.

---

## 7. Beispiele (BP-Reihe fortgeschrieben) und Negativ-Batterie

### BP-6 -- Dual-Vollbild auf der CEB (intel, beide Werke, Zulassung erteilt)

    Mess-Zeile:    pmc=intel@6.1.0.2.0.0.c{p.e}.pmc{c{p.e}}.b.t
    System-Zeile:  pmc=intel@6.1.0.1.0.0.c{p.e}.pmc{c{p.e}}.b.t
    Lesart: Mess = EINRICHTUNG (Planer hat zugelassen; CEB + Tier tragen eingebaute Einrichtungen);
    System = FAKTUM/POLICY desselben Sachverhalts. WACHEN: vendor und hw_version (6.1.0) identisch
    ueber beide Zeilen; sw_version differiert zulaessig (2.0.0 Mess-Algorithmik, 1.0.0 Policy).
    Kind-Stempel Tier (PM-8, pmc-fuehrend): pmc=intel@6.1.0.2.0.0.c{p.e}.pmc{c{p.e}}.b.t
    (eigene Stufe t + fuehrendes b; h-Geschwister-Slot entfiele).

### BP-7 -- System-only -- der F3-Sonderfall

    Mess-Zeile:    (kein pmc-Eintrag)
    System-Zeile:  pmc=amd@2.5.0.1.0.0.c.pmc{c{p}}.b
    Die XML verbietet per Planer die Mess-Nutzung: das Potential wird MITGEFUEHRT, ist aber nicht
    ausgepraegt -- "bzw. ist bereits in der CEB implizit ausgebaut" (F3). Kein Mess-Kompilat-Anteil,
    kein Bloat; die Differenz zum Dual-Vollbild ist Kompilat-Differenz und damit Stempel-Differenz.

### BP-8 -- Komprimiert gegen expandiert (PM-14, F-P4 verbatim)

    pmc{c{p.e}}.b.t  ==  { pmc{c{p}}.b.t , pmc{c{e}}.b.t }
    Links: EIN Kompilat traegt beide Werke (W7 Option A). Rechts: die zwei Mess-Welten je Werk;
    die Werk-WAHL je Lauf bleibt System-Achsen-Permutation (P/E-Pinning, Owner 06.08.).
    Der Parser haelt beide Formen als VERSCHIEDENE Werte (keine Normalisierung); Planer und
    Lager rechnen mit der Expansion (Paarung nie ueber Werk-Grenzen, PM-9).

### BP-9 -- Planer-Zeile (freigebbare Sicht) + Interface-Achse

    Planer-Mess-Zeile:   pmc=amd@2.5.0.1.0.0.c.pmc{c{p}}.p.b.h.t     -- FREIGEBBAR (impliziert)
    Planer-Interface:    <iface_id>@1.0.0.c.i{w}                     -- "iw i.d.R. immer" (F-P3)
    CEB-Interface:       <iface_id>@1.0.0.c.i{ma.mi}                 -- CEB liest Tier/Hybrid-Fuehler
    Der Planer stempelt, was er freigeben KANN (volle Analyse-Funktionalitaet, CMake-gesetzt);
    CEB-/Kind-Zeilen stempeln UMGESETZTES. Dieselbe Zeichenkette, zwei Seiten-Lesarten (PM-7-Erbe).

### BP-10 -- AND-Freigabe erfuellt (Positiv-Bild der F2-Wache)

    Befund (Phase 1):     Probe amd, Werk p, hw 2.5.0        (Laufzeit-Wahrheit je Lauf)
    Mess-Zulassung:       JA (XML/Planer)  ->  Mess-Eintrag entsteht
    System-Umsetzung:     JA, WEIL Mess erlaubt (AND aus zwei Kategorien in hierarchischer
                          Reihenfolge; static_assert-Wache Par. 3.3 ist erfuellt)

### Negativ-Batterie v2 (Auszug; Parser prueft FORM, Ablehnung ist Wachen-Sache)

    pmc=amd@2.5.0.1.0.0.c.pmc{c{p}}.t.b        ROT: Suffix-Ordnung verletzt (strikt p,b,h,t; PM-13)
    pmc=amd@2.5.0.1.0.0.c.pmc{c{p}}.t          ROT: t ohne b (PM-5; F-P3 "Architektur-Regression")
    pmc=amd@2.5.0.1.0.0.c.pmc{c{p}}.b.b        ROT: Stufen-Duplikat (PM-13)
    pmc=amd@2.5.0.1.0.0.c.pmc{c{p}}            ROT: leere Stufen-Kette -- kein Traeger benannt
    pmc=amd@2.5.0.1.0.0.c.pmc{}                ROT: leere Gruppe (v2-R4)
    pmc=amd@2.5.0.1.0.0.c.pmc{p.e}             ROT: Typ-Flags ohne c-Komposit (F-P4: p/e UNTER c)
    pmc=amd@2.5.0.c.pmc{c{p}}.b                ROT: nur EINE Version -- Doppel-Version Pflicht (PM-11)
    System-Zeile mit  ...pmc{c{p}}.p.b         ROT: p-Suffix auf System-Eintrag (F1: System ab CEB)
    Mess-Eintrag ohne System-Eintrag           ROT: System ist bei Einbau IMMER dabei (PM-12)
    System-Umsetzung ohne Mess-Zulassung       ROT: AND-Wache (F2/F-P8)
    hw_version Mess != hw_version System       ROT: EINE Hardware je Host (PM-11)
    pmc=amd@... und pmc=intel@... in einem     ROT: zwei Vendor-Werte in einem Kompilat (PM-3;
       Stempel                                      #error-Wache am Objekt)
    pmc{c{p,e}}                                ROT: Komma ist kein v2-Token (Normalisierung OP-5)
    m{b{w.pmc}}                                ROT: pmc unter m bleibt verworfen (F-G1-8)
    i{pmc} heute                               ROT bis Owner-Wort OP-2 (Interface-Katalog geschlossen)

---

## 8. WEB-RECHERCHE: PMC-Hardware je Kern-Typ (Owner-Order F-P1(5)) -- Stand 15.08.2026

### 8.1 AMD Zen 5 (Ryzen 9 9950X3D, prod1; Familie 1Ah Modelle 00h-0Fh)

* PMU-Architektur: **PerfMonV2** -- eingefuehrt mit Ryzen 7000/EPYC 9004 (Zen 4), Host-Support seit
  Linux 5.19; CPUID-Blatt 0x80000022 (ExtPerfMonAndDbg) meldet die Faehigkeiten (EAX Bit 0 =
  PerfMonV2; EBX traegt die Counter-Zahlen, u.a. NumCorePmc), globale Control/Status-MSRs.
  Quellen: https://lwn.net/Articles/892132/ +
  https://lore.kernel.org/all/CALMp9eSXTpkKpmqJiS=0NuQOjCFKDeOqjN3wWfyPCBhx-H=Vsw@mail.gmail.com/
* Werk-Klassen (Counter-Klassen) je Prozessor: **Core-PMC** (6 Counter je Kern, "number of core
  perf ctrs = 0x6" in den KVM-Selftest-Diskussionen), **L3-PMC** (je CCX), **Data-Fabric-PMC**,
  **UMC-PMC** (Unified Memory Controller; als PerfMonV2-Bestandteil seit Zen 4, je UMC eigener
  Counter-Satz fuer Bandbreite/Auslastung). Quellen: https://lwn.net/Articles/946708/ +
  https://lists.openwall.net/linux-kernel/2023/11/21/761
* Zen-5-Stand: AMD veroeffentlichte das PMC-Dokument "Performance Monitor Counters for AMD Family
  1Ah Model 00h-0Fh Processors"; Events/Metriken weitgehend Zen-4-aehnlich (Kern-Events Abschnitt
  1.4 des Dokuments). Quellen: https://www.phoronix.com/news/AMD-Zen-5-Perf-Monitoring-Patch +
  https://lkml.rescloud.iu.edu/2405.0/02414.html + https://www.illumos.org/issues/16408
* 9950X3D-Eigenheit: HOMOGENE Kerne (alle Zen 5) => EIN Core-Werk-Typ; die X3D-Asymmetrie
  (3D-V-Cache auf einem CCD) ist eine KAPAZITAETS-Eigenschaft der L3-Werke je CCD, KEINE eigene
  PMU-Version -- fuer die Grammatik bleibt amd heute bei typ_spec c{p} (Default, ein Werk-Typ).

### 8.2 Intel Hybrid (prod2 = i9-12900K; Owner-Etikett "RaptorLake")

* MASCHINEN-KARTE, ehrlich gefuehrt: der i9-12900K ist Alder-Lake-Generation (P = Golden Cove,
  E = Gracemont); "Raptor Lake" ist der Nachfolger (P = Raptor Cove, E = Gracemont). Fuer die
  PMU-Frage sind beide GLEICH GESCHICHTET: zwei getrennte PMUs je Paket.
* **Getrennte PMUs je Kern-Typ:** Golden-Cove-Kerne registrieren als "cpu_core"-PMU, Gracemont als
  "cpu_atom"-PMU; die Faehigkeiten sind NICHT gleich -- unterschiedliche Zahl an GP-/Fixed-Countern
  und Events; Topdown-Metrics nur cpu_core, PEBS-via-PT nur cpu_atom. Das deckt das Owner-Wort
  "Damit hat die Intel Maschine effektiv 2 PMC" (06.08.) woertlich. Quelle:
  https://lkml.kernel.org/lkml/1617635467-181510-21-git-send-email-kan.liang@linux.intel.com/
* Die EXAKTEN Counter-Zahlen je Kern-Typ (GP/Fixed) und die Architectural-PerfMon-Versionsnummer
  der Alder-/Raptor-Lake-Werke waren aus den Suchtreffern NICHT belegbar (Treffer nennen nur "die
  Zahl unterscheidet sich") -- PIN-POSTEN fuer den Bau: am Intel SDM Kap. Performance Monitoring
  nachschlagen und als Katalog-Literal festschreiben (Par. 8.4, Spalte PIN).

### 8.3 Kuenftige Kerne / Spezial-ISA (Owner: "Spezial-ISA die nochmal andere Kerne und PMC haben wird")

* **Lunar Lake / Arrow Lake:** neue PMU-Generation -- E-Core-Support fuer 3 NEUE Fixed-Counter,
  P-Core mit neuem PEBS-Data-Source-Format und MEHR GP-Countern, **Architectural PerfMon V6**
  (neues MSR-Aliasing, umask2, eq). Quelle:
  https://wccftech.com/intel-new-linux-patches-lunar-lake-arrow-lake-next-gen-performance-monitoring/
* **Arrow Lake-H: DREI Kern-Typen in EINEM Paket** (Lion Cove P + Skymont E + Crestmont LP-E) --
  die typ_spec-Vokabel p/e reicht dann NICHT mehr; ein dritter Typ (Arbeits-Kandidat `le` fuer
  LP-E) ist ADDITIV vorgesehen (PM-3/typ_spec offen erweiterbar; kein Grammatik-Umbau). Quelle:
  https://wccftech.com/intel-arrow-lake-h-cpus-lion-cove-p-skymont-e-crestmont-lp-e-cores/
  (Zweitquelle videocardz.com, Meldung "two types of Efficient cores", bestaetigt den Befund.)
* **AMD Zen 6:** das ERSTE offizielle Zen-6-Dokument ist ausgerechnet das PMC-Dokument -- der
  Katalog muss HW-Versionen je Familie/Modell fortschreiben koennen. Quelle:
  https://hothardware.com/news/amd-zen-6-performance-monitor-counters

### 8.4 HW-VERSIONS-KATALOG -- ENTWURF (alle Literale VORSCHLAG; Owner-Bestaetigung OP-3)

Schema hw_version = ARCH.KAT.REV: ARCH = PMU-Architekturversion des Vendors (belegt),
KAT = Katalog-Stand des Werks (fortlaufend je Vendor), REV = Erratum-/Dokument-Revision.

    Werk (vendor/kern-typ)      hw_version   Beleg-Lage
    amd / zen5-core  (c{p})     2.5.0        PerfMonV2 belegt; 6 Core-Counter belegt (8.1)
    amd / zen5-l3               2.5.0        Werk-Klasse belegt; Zaehler-Zahl PIN (PPR 1Ah)
    amd / zen5-df               2.5.0        Werk-Klasse belegt; Zaehler-Zahl PIN (PPR 1Ah)
    amd / zen5-umc              2.5.0        seit Zen 4 Teil von PerfMonV2, belegt (8.1)
    intel / adl-p    (c{p})     PIN.12.0     cpu_core-PMU belegt; ArchPerfMon-Nr + Counter PIN (SDM)
    intel / adl-e    (c{e})     PIN.12.0     cpu_atom-PMU belegt; ArchPerfMon-Nr + Counter PIN (SDM)
    intel / lnl-arl-p           6.15.0       ArchPerfMon V6 belegt (8.3); Details PIN
    intel / lnl-arl-e           6.15.0       3 neue Fixed-Counter belegt (8.3); Details PIN
    intel / arl-h-lpe (le NEU)  6.15.1       dritter Kern-Typ belegt (8.3); alles Weitere PIN

    PIN = beim Bau am Primaerdokument (Intel SDM / AMD PPR) nachschlagen und festschreiben;
    dieses Design uebernimmt KEINE ungepruefte Zahl in Registry-Literale (Nie-raten-Doktrin).

### 8.5 Konsequenzen fuer die Grammatik

1. hw_version haengt am WERK (vendor x kern-typ), nicht am Vendor allein -- die Registry wird
   werk-genau (Par. 5); die V1-Annahme "eine Version je Vendor" ist damit praezisiert.
2. typ_spec ist OFFEN erweiterbar (dritter Kern-Typ Arrow Lake-H; Spezial-ISA) -- additiv, ohne
   Umbau; die Werte-Menge bleibt registry-geschlossen (fail-closed bei Unbekanntem).
3. Die getrennten Intel-PMUs bestaetigen PM-14: komprimierte Form = ein Kompilat mit zwei Werken,
   expandierte Formen = getrennte Mess-Welten (cpu_core/cpu_atom sind auch kernel-seitig ZWEI PMUs).

---

## 9. Abgrenzung zu G-1 und V1 -- und die offenen Owner-Punkte

### 9.1 Abgrenzungstabelle (Delta-Sicht)

| Merkmal | G-1 `m` (Mess-Belegung) | G-1P v2 `pmc` (dieser Entwurf) |
|---|---|---|
| Kategorien | 1 (Mess-Zeile) | bis zu 2 ZUGLEICH: Mess (Einrichtung) + System (Faktum/Policy) |
| Version | X.Y.Z einfach | DOPPELT: hw_version VOR sw_version, je Kategorie-Stapelposition |
| Abwesenheit | leere Slots = Wert (Zeiger) | KEIN Eintrag (zweifach); System-only als dritter Fall |
| Stufen | Slots IN der Klammer; Anordnung = INFORMATION (M-6) | SUFFIX-Kette, Ordnung owner-fix p/b/h/t |
| Planer | kein p-Slot im m-Flag; Vertrags-Slot = eigene CEB-Zeile (12.4) | p-SUFFIX auf der Planer-Zeile (F1) |
| Klammer-Inhalt | Instrumente w/ma/mi je Stufe | WERK-Spezifikation c{p.e} (welche PMCs integriert) |
| Interface-Flags | (aus dieser Runde geboren) | i{w}/i{ma}/i{mi} = EIGENE Mess-Haupt-Achse der Familie |
| Freigabe-Logik | Planer impliziert, CEB fordert | zusaetzlich AND zweier Kategorien (Mess -> System) |
| Zaehlung | S-19 rechnet | S-19 rechnet; JEDE statische Nenner-Rechnung ist untersagt (F-P6) |
| Parser | parse_algo_semver | DERSELBE (Profil; Doppel-Version = Profil-Lesung, Par. 2.2) |

Gegen V1: Par. 1-Tabelle. Die V1-Kapitel W2-Aufloesung (Par. 7) und W7 (Par. 8) sind vollzogen
bzw. entschieden ("Tier-Fingerprint pmc-frei" final UEBERHOLT per F-P5; UEBERHOLT-Marker gesetzt).

### 9.2 Offene Owner-Punkte (NUR echte; alles andere ist entschieden)

* **OP-1 -- system_meta_meta-Rekursion:** vom Owner explizit offen gehalten (Teil 21(b)); die
  PMC-System-Seite braucht sie nicht (MMR-1, Par. 6). Entscheid kann liegen bleiben, bis ein
  System-Meta-Meta-Traeger real entsteht -- Vorlage mit dieser Entlastung.
* **OP-2 -- Interface-Kennzeichnung des PMC-Zwischenvertrags:** Vokabular-Erweiterung der
  Interface-Achse um ein PMC-Token (Kandidat `i{pmc}`), damit das Vorhandensein des
  PMC-Aufzeichnungs-Interfaces je Zwischenvertrag anzeigbar ist wie bei w/ma/mi. Empfehlung: ja,
  additiv; bis dahin bleibt der Katalog geschlossen (Negativ-Batterie).
* **OP-3 -- HW-Versions-Katalog-Literale (Par. 8.4):** Schema ARCH.KAT.REV und die
  Entwurfs-Literale bestaetigen; PIN-Posten (SDM/PPR) werden beim Bau als T-1-Stufe belegt.
* **OP-4 -- sw_version je Kategorie:** UNABHAENGIG je Kategorie (Empfehlung; Mess-Algorithmik und
  System-Policy versionieren getrennt) ODER ein gemeinsamer Stand. hw_version ist in beiden
  Faellen identisch (PM-11-Wache).
* **OP-5 -- Schreibweisen-Normalisierung:** `pmc{c.{p.e}}`/`{p,e}` -> `pmc{c{p.e}}` (Par. 2.4)
  bestaetigen -- reine Orthographie, kein Semantik-Delta.

GESCHLOSSEN (nicht wieder vorlegen): F-P1..F-P10 komplett (KON71/KON72) + RF-A/B/C == F1/F2/F3
der Familien-Runde (Teil 19) + W7 P/E = Option A (F-P7) + F7/R-F7 Concurrency (Teile 20/22;
prod1 = 32 Threads 9950X3D, prod2 = 24 Threads i9-12900K -- nicht Grammatik-Stoff) +
Benchmark-/w-Fragen per KON65 (G-1 Par. 12).

### 9.3 Grenzen dieses Entwurfs

1. **KEIN BAU.** Jede Zeile ist Vorlage; Bau als Stempel-Strecken-/W-Posten nach Owner-GO
   (Fable 5 max Strecken-Auflage KON38); Registry-Neubau-Anschluss KON37-02 + F-P9-Paket.
2. **Lastsequenz-Achse:** eigenes Schwester-Design NACH ihrem 10-Wochen-Explore (F-G1-9/KON64-03);
   hier nicht vorgegriffen.
3. **S-19 rechnet die Fahr-Zahlen** (Meilenstein, "Hauptziel der naechsten Wellen"); die
   check-size-CEB-Haelfte ist S-19-Design-Input (#7), nicht dieses Dokument.
4. **F-G1-4(b)-Klammer bleibt Papier**, bis der checkpoint_measure-Wrapper gebaut ist (Teil 21).
5. **Objekt-Naehte** (exakte Gate-Namen, Alias-Entscheide) fallen beim Bau-Explore am Objekt.
6. **Deklarierter Nichtfund** (Teil 21(e)): die Erst-Klammerung "Mess[System[Organ]]" woertlich
   ist ohne Voll-Gegenprobe nicht belegt -- als Explore-Behauptung markiert, nicht verbaut.

---

## 10. Erhebungs-Anhang: Fundstellen, Nichtfunde, Zahlen mit Nenner

* **Owner-Worte:** kon64_sammlung.md -- F-P1/F-P2 Teil 12 (:463-494) + No-Bloat/F-P3/F-P6 Teil 13
  (:500-548) + F-P4/7/8/9 Teil 14 (:578-620) + No-Bloat-Plan-Belege Teil 14-B (:622-640) +
  F-P8-Explore + Tieflesen Teil 16 (:718-759) + iw/ima/imi-Kern Teil 17 (:761-772) + F1-F6
  Teil 19 (:809-889) + F7 Teil 20 (:892-937) + Hybridform-Karte Teil 21 (:939-973) + R-F7
  Teil 22 (:975-984).
* **Ledger:** KON72 Kopf :19-204 (KON72-01/-02: F-P-Runde 10/10, Architektur-Kerne, p/b/h/t,
  AND-Freigabe, dritte 32er-Ruege, Namensraum-Wache je Position) + KON71 :206-292. NICHTFUND:
  "KON73" im Ledger 0 Treffer (rc=1), Gegenprobe "KON72" beisst (:19) -- KON73-Stoff ist zum
  Redaktionszeitpunkt ungebucht; Primaerquelle sind die Teile 16-22 der Sammlung.
* **G-1:** Par. 12.1-12.7 (Finalfassung; 12.4 Planer-Vertrags-Slot, 12.5 PMC-Korrektur mit
  F1/F2/F8-Zitaten, 12.7 Familien-Verweis auf Task #53).
* **V1-Vorlage:** tmp/design_pmc_grammatik.md (PM-1..PM-10 :183-241, BP-1..BP-5 :244-306,
  Objekt-Anker Par. 1: pmc_vendor_registry 167 Z./2 Eintraege, ceb_version_stamp :270-345,
  CI-Lanes amd+intel; Kollisions-Erhebung "pmc"/"amd"/"intel" 0 Treffer im 62er-Katalog mit
  beissender Positiv-Kontrolle "bw" = 2 Treffer).
* **Zahlen mit Nenner (Web, Par. 8):** 6 Core-Counter je Zen-Kern (NumCorePmc, KVM-Selftests) +
  2 getrennte Intel-PMUs je Hybrid-Paket (cpu_core/cpu_atom) + 3 neue E-Core-Fixed-Counter
  (Lunar/Arrow Lake) + 3 Kern-Typen im Arrow-Lake-H-Paket + PerfMonV2 seit Zen 4 (Linux 5.19),
  ArchPerfMon V6 mit Lunar/Arrow Lake. Exakte Intel-GP/Fixed-Zahlen je Kern-Typ: NICHT belegt,
  als PIN-Posten deklariert (keine ungeprueften Zahlen in Literale).
* **Web-Quellen:** die 12 URLs stehen inline in Par. 8.1-8.3 (Suchlaeufe 15.08.2026 via WebSearch;
  vier Anfragen: AMD PerfMonV2/Zen5, Intel Hybrid-PMU, CPUID 0x80000022, LNL/ARL PerfMon V6).

<!-- selfcheck: ASCII-only, Zeilen <= 120, ~600 Zeilen, KEIN BAU, kein Repo-Schreiben -->
