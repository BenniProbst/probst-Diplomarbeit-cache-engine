# RUECKWAERTS-KONSOLIDIERUNG: KON101 V-Antworten (10 von 12, ausgenommen V-02R/V-10b)

**Methodischer Vorbehalt vorab (FALLE bestaetigt):** Mehrere Ledger-Anker, die die Restfragen-Vorlage (`docs/sessions/20260817-OWNER-VORAB-15-restfragen.md`) selbst zitiert, sind zwischen deren Entstehung und dieser Konsolidierung um **exakt +475 bis +480 Zeilen** gewandert (KON21-03: dort `:7695`, heute `:8170`; E-1/09.08.: dort `:15868`, heute `:16347`) — Folge derselben Nachtragswelle, die zwischen beiden Zeitpunkten oben eingefuegt wurde. Alle Zeilenangaben unten sind **heutige, in dieser Sitzung nachgemessene** Positionen in `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (30693 Z.), nicht die in der Vorlage zitierten. Code-Fundstellen wurden, wo als "AM OBJEKT gelesen" markiert, in dieser Sitzung selbst per Read/Grep gegen `Code/external/comdare-cache-engine/` verifiziert (Branch development, read-only); alle uebrigen Code-Aussagen sind Ledger-zitierte Befunde frueherer Sitzungen. `docs/termine/` und `docs/termine_konsolidiert/` wurden gegen alle zehn Themenbegriffe gegengeprueft — **0 Treffer** (Betreuer-Termine liegen auf Architektur-Detailebene unterhalb dieser zehn Fragen; Gegenprobe bestanden, keine Uebersehens-Luecke).

---

## V-01R — AxisKind dreht mit + Haupt-/Unter-Achsen-Zuordnung

**VORGESCHICHTE:**
- 17.07.2026 (Bau-INC-1, Schritt 1a; Ledger-Beleg heute `:20500`): `topics::AxisKind` GEBOREN als reiner "Layer Supertype"-Diskriminator, urspruenglich DREI Werte `{organ, system_measurement, system_config}`. AM OBJEKT bestaetigt (`topics/axis.hpp:17-20`, in dieser Sitzung gelesen): Dateikopf sagt ausdruecklich "Semantik-FREIES Dach ... traegt NUR Identitaet + Familien-Diskriminator".
- 10.08.2026 (KON5-04/05, heute `:11173-11209`): der aeltere Owner-Satz "System vorn, Organ hinten" wird gegen drei Kosten-Ebenen (Makro-Argumente/POD-Feldfolge/Preimage-Glied-Folge) geprueft; KON5-05 stellt per Volltextsuche fest, es habe **nie** eine Preimage-Reihenfolge-Festlegung gegeben, und zitiert exakt das damals dreiwertige `AxisKind{organ, system_measurement, system_config}` als Beleg fuer "organ zuerst".
- 12.08.2026 (KON21-03, heute `:8170-8206`, Owner verbatim "Ja genau, meint auch #87 und #78"): SOLL `MESS,SYSTEM,ORGAN` gilt fuer alle drei Aussen-Ebenen; S-6-Bauauftrag wird in S-6a/b/c/d geschnitten; **VERBOTSZONE gesetzt**: `kOrganGruppen*`, `kSystemAxisOrder`, `kCompositionAxisNames`, Hash-Mechanik, Messwert-2-Tupel duerfen NICHT angefasst werden.
- 26.07.-02.08.2026: AxisKind waechst zweimal rein APPEND-ONLY (Ledger `:14954-14998`, `organ_meta_meta_axis.hpp:4-7`): `system_meta_meta`+`measurement_meta_meta` (Lane A/C), dann `organ_meta_meta` (Owner-Entscheid E2, 02.08., verbatim: "Da eine Meta-Meta-Achse immer zu den Mess-, System- oder Organ-Achsen gehoert ... wird sie einfach dynamisch ans Ende der Kette angehaengt"). AM OBJEKT bestaetigt: `topics/axis.hpp:17-49` traegt heute **sechs** Werte in genau dieser Reihenfolge.
- 16.08.2026 (KON96-01, Korb A, Punkt 4+10): "VOR dem Bruch entscheiden: Glied-FOLGE + AxisKind-Ordnung im SELBEN Bruch mitnehmen (KON5-04/05 -- sonst steht der teuerste Bruch spaeter erneut an)" — als lebender #15-Bruch-Posten gefuehrt.
- 17.08.2026 vormittags (Restfragen-Vorlage): Lead-EMPFEHLUNG war "unveraendert lassen ... ein Ordinal-Dreh waere ein zusaetzliches Byte-Ereignis ohne Ordnungs-Gewinn" — Fortschreibung der 10.08.-Linie.

**DELTA DER HEUTIGEN ANTWORT:** Der Owner UEBERSTIMMT die Lead-Empfehlung ("definitiv mit drehen, sonst ergibt es keinen Sinn") und fordert zusaetzlich eine **CT-ZUORDNUNGS-MECHANIK**, die in keiner Vorgeschichte-Stelle vorkam: Unter-Achse→Haupt-Achse UND Haupt-Achse→Kategorie als GEPRUEFTE Beziehung im Enum-Umfeld. Bisher existierte diese Beziehung nur INFORMELL als lose String-Vergleiche einzelner Unter-Achsen (`SimdSubAxis::parent_axis_label=="extension_hardware"`, analog `compiler`/`opt_level`) — nie als Teil von `AxisKind` selbst oder einer geprueften Struktur. Das ist eine strukturelle ERWEITERUNG, kein blosser Ordinal-Dreh.

**UEBERHOLT-MARKER-LISTE:**
- `docs/sessions/20260817-OWNER-VORAB-15-restfragen.md`, Abschnitt V-01R, EMPFEHLUNG-Zeile: durch KON101-01 ueberstimmt — Marker im Dokument selbst noetig (es bleibt laut KON101-03 als Vorlage in Gebrauch, bis B-1..B-11 starten).
- `topics/axis.hpp:1-6` (Dateikopf, "Semantik-FREIES Dach ... traegt NUR Identitaet + Familien-Diskriminator"): wird durch die Zuordnungs-Erweiterung sachlich falsch, sobald B-5 baut — Marker am Dateikopf faellig.
- Ledger KON5-04 (`:11173-11190`), "EMPFEHLUNG: Option (1)" (nur Makro-Ebene aendern): bereits durch KON21-03 einmal, jetzt durch V-01R ein zweites Mal ueberholt.

**FEHLENDE BAU-FOLGEN:**
1. KON101-02 nennt keine Auflage gegen die 12.08.-VERBOTSZONE `kSystemAxisOrder` — die neue Zuordnung muss diese KONSULTIEREND, nicht ERSETZEND bauen (sonst "zweite Wahrheit", exakt das 12.08. Verbotene). Fehlt als explizite Auflage vor B-5.
2. Ungeklaert, ob die VIER additiven Meta-Meta-Diskriminatoren in der neuen Unter→Haupt-Zuordnung selbst als "Haupt-Achsen" zaehlen (dann brauchen sie eine Kategorie-Zuordnung) oder eine dritte Ebene bilden.
3. V-01R und V-06 treffen sich am selben Layout-6→7-Bump und denselben ABI-Dateien, werden aber in KON101-02 als getrennte Baupunkte gefuehrt, ohne den gemeinsamen Bau-Schnitt zu benennen.

---

## V-03R — avx512 Pflicht ("wir bauen nach Plan")

**VORGESCHICHTE (volle Kette):**
- 17.07.2026 (H-7/H-10-Owner-Antworten, heute `:20211/:20347`): AVX512 von Anfang an als STEUERBARE Systemachsen-Groesse angelegt ("speziell einkompiliert ODER zum Vergleich bewusst NICHT — volle Kontrolle"); selber Tag, Bau-INC-1 1d: `ExtensionHardwareSystemAxis` mit `no_extension/avx2/avx512` real gebaut.
- 20.07.2026 (§40.a, Flag-Signatur-Modell) + (B3/T5, `:21238-21287`): AVX512 wird NICHT ausgeschlossen, sondern IMMER FEINER modelliert (Flag-genaue Signatur statt Grob-Level, eigene Meta-Meta-Achse geplant).
- 21.-24.07.2026: Capability-Tags real gesetzt (prod1 `+avx512`), 3-stufiges Runner-Tag-Routing gebaut; **24.07.2026 (§46, `:20963`)**: "avx512 ist NICHT im Profil-System-Satz ... Anschluss-Increment" — HIER, und nur hier, vorlaeufige Auslassung als Kapazitaets-, nicht Verbots-Entscheidung.
- **26.07.2026 (Owner-KERN, per KON100-S7 heute `:442-446` mit Stichprobe gegen Roh-Transkript `46375cdc` BESTANDEN):** *"AVX512 GEHOERT MIT ... Das golden-Profil hatte avx512 faelschlich als 'nicht universell' herausdefiniert -- das ist der Filter, der ENTFAELLT."* Die 24.07.-Auslassung wird als einer von "drei schwerwiegenden Opus-Achsen-Fehlern" benannt; Matrix korrigiert auf 12 System-Perms = O0-O3 × {no_extension,avx2,avx512}. Zusaetzlich zwei GOAL-Dokument-Nachtraege desselben Datums, die dieselbe Korrektur an zwei Versionsstaenden verankern (`:18575` V7.3-Fehlerklassen-Nachtrag, `:20965` V7.2-Kopfnotiz).
- 09.08.2026 (`:11017-11018`, Owner verbatim): "Wenn prod2 kein AVX512 hat, dann kann sie es auch nicht compilieren" — bestaetigt den Skip-Mechanismus (maschinenseitig, nicht profilseitig).
- 17.08.2026 vormittags (KON100-S7): Zehn-Wochen-Explore bestaetigt die Kehrtwende foermlich als "EMPFEHLUNGS-UMKEHR" gegen die fruehere Vorlage-Empfehlung "kein AVX-512 in golden"; erzeugt Korrektur-Posten K1 (zwei stale XML-Filter-Stellen).

**DELTA DER HEUTIGEN ANTWORT:** Rein technisch nichts Neues seit 26.07. Der DELTA liegt im VERFAHREN: die Owner-Formulierung ("Keine Chance, damit kommst du nicht durch, wir bauen nach Plan") ist eine BINDUNGS-Praezisierung — der 26.07.-Plan ist unter Zeitdruck (9 Tage vor F2) NICHT verhandelbar, auch nicht als stillschweigende Sparmassnahme. Zusaetzlich neu: die Owner-seitige BUENDELUNG von A-09+E-B+S-6a-Makro+K1 zu EINEM golden-Ereignis (vorher nur Lead-Empfehlung, jetzt Owner-Wort) sowie die neue Auflage "K1 faehrt zwingend im Buendel (kein Vorlauf-Posten)" — das widerspricht der aelteren KON100-01-Einordnung von K1 als AUTONOM (kein Owner-Bedarf) nicht, verengt sie aber zeitlich.

**UEBERHOLT-MARKER-LISTE:**
- Jede noch existierende Kopie des 24.07.-Zwischenstands ("avx512 NICHT im Profil-System-Satz") ausserhalb der bereits selbst-markierten Ledger-Stelle (`:20965`, dort schon "damit Historie" vermerkt) — in `docs/plaene/` nicht erschoepfend durchsucht (EXPLORE-LUECKE).
- Die zwei stale golden-XML-avx512-Filter-Stellen aus K1 (KON100-01) sind nach heutigem Stand NOCH NICHT korrigiert — kein Marker-, sondern Bau-Fall; Wirksamkeits-Pruefung VOR Edit bleibt Auflage.

**FEHLENDE BAU-FOLGEN:**
1. Keine Kapazitaets-Aussage fuer das GOLDEN-Fenster selbst (avx512 nur auf capability-getaggten Nodes, laut 20.-24.07.-Historie ein Engpass) — welcher Node den avx512-Zweig des Buendels faehrt, ist ungebucht.
2. V-03R (avx512-Pflicht) und V-09R (prod2-Umbenennung, selbe Sitzung) betreffen dieselbe Maschine (prod2 kann laut 09.08. kein avx512) — kein Querverweis zwischen beiden KON101-02-Absaetzen.

---

## V-04R — Ebenen-Wrap (Hybrid-Rekursion)

**VORGESCHICHTE:**
- 09.08.2026 ("E-1", heute `:16336-16349` — **NUMMERN-KOLLISION**: es existiert eine ZWEITE, spaetere "E-1" in der 17.08.-20-Fragen-Vorlage, thematisch unverwandt, Vorsicht bei Zitat): Owner benennt die Hybrid-Gattung (HEURISTIK-ADAPTER/Function-Interface-Reroute) und beschreibt die Rekursion woertlich: "baumfoermig compile-time bis zu begrenzter Tiefe ... Tiefe bei 1 belassen, muss aber funktionieren ... **Tiefe und Heuristik-Funktions-Stufen-IDs im Stempel ablesbar**." Dies ist die woertliche Quelle des in der Restfragen-Vorlage zitierten Anspruchs.
- 12.08.2026 (KON45-01, Altanker `:4539-4542`): Hybrid-Komposit-Zeile (10. Preimage-Glied) beschlossen — Existenz+Position+Map-VALUE=Tier-SHA, aber ohne Aussage zur Tiefen-Ablesbarkeit.
- 17.08.2026, VOR der Owner-Antwort gelandet (KON103-03, V-02R-Explore): "die Verkettung IST der Ebenen-Wrap; Rekursion strukturell ... kein `d=<Tiefe>`-Feld" — technisch bereits dieselbe Antwort, unabhaengig vom Owner hergeleitet.

**DELTA DER HEUTIGEN ANTWORT:** Bestaetigt wortwoertlich, was der PARALLEL laufende V-02R-Explore am selben Tag bereits technisch herleitete — beide Quellen KONVERGIEREN, ohne dass eine von der anderen wusste. Der eigentliche Delta-Gehalt: der Owner liefert den NAMEN "Ebenen-Wrap" und die Formel "Abfrage ueber die Flaeche" (Flaeche-2-Vokabular aus KON7-01), die die Vorgeschichte nie benannt hatte — nur technisch (SHA-Verkettung) beschrieben.

**UEBERHOLT-MARKER-LISTE:**
- Lead-Vorschlag "d=<tiefe>-Feld" in der Restfragen-Vorlage: DOPPELT ueberholt (durch KON103-03 technisch, durch KON101-01 als Owner-Wort) — sollte in EINEM Marker zusammengefuehrt werden (KON101-02 warnt selbst bereits: "Konsistent mit V-02R").

**FEHLENDE BAU-FOLGEN:**
- Kein Testfall fuer Tiefe>1 (verschachteltes Hybrid) gebucht, obwohl die Ur-Quelle (09.08.) ausdruecklich "muss aber funktionieren" fordert, auch wenn Tiefe heute bei 1 bleibt.

---

## V-05R — Name in AnatomyVersionLines

**VORGESCHICHTE:**
- **06.08.2026 (F7, heute `:25106-25108`, Owner verbatim):** *"Bitte Option b: ... Wir erzeugen eine Funktion, die zur compile time auch den Namen der Funktion aus dieser Rekombination in die binary schreibt und durch ein eigenes Interface der Stempel-Versionierung an jeder Planer/CEB/Tier-Binary anbietet. Dies soll ein gesondertes Versionierungs-Interface sein."* — Geburtsstunde von "Name = Funktion des Fingerprints".
- 11.08.2026 spaetabends (KON7-01, `:10640-10662`): das "gesonderte Versionierungs-Interface" aus F7 wird zur "Flaeche 2"-Doktrin ausgearbeitet (compile time factory, separat auf JEDER Binary-Aussenseite) — F7 ist Saatsatz, KON7-01 fuenf Tage spaeter die Architektur.
- 17.08.2026 vormittags (KON100-S4/Restfragen-Vorlage): bestaetigt "F7 legt CT-Name + eigenes Stempel-Interface fest; Rest = VERORTUNG" und stellt fest: die Altplan-Praemisse (separater POD+6. Symbol, weil ein AnatomyVersionLines-Bump "ohne Gegenwert" waere) ist ENTFALLEN, weil der 6→7-Bump ohnehin im selben Fenster faellt (V-01R/S-6a).
- AM OBJEKT bestaetigt (`anatomy_module_abi_v1_decl.hpp:267,274`): `kAnatomyVersionLinesLayout = 6`, `static_assert(sizeof(AnatomyVersionLines) == 120)` — der Bump ist HEUTE noch nicht gebaut, alles Folgende ist Planung.

**DELTA DER HEUTIGEN ANTWORT:** Kuerzeste aller V-Antworten, inhaltlich NICHTS Neues — der Entscheidungsraum war durch KON100-S4 bereits auf eine fast entschiedene Frage reduziert. Bemerkenswert: die "12-Wochen-Vorgeschichte" (F7, 06.08.) hatte die Antwort faktisch schon geliefert; die heutige Owner-Antwort bestaetigt nur die am 17.08. gezogene ABLEITUNG.

**UEBERHOLT-MARKER-LISTE:**
- Der "Altplan" (separater POD+6. Symbol) ist als Design-Option endgueltig verworfen; in dieser Sitzung nur in der Restfragen-Vorlage selbst dokumentiert (dort bereits als "Altplan" gekennzeichnet — kein zusaetzlicher Marker noetig).

**FEHLENDE BAU-FOLGEN:**
- Zielgroesse "sizeof 120→152" (aus dem KON45-01-Budget-Umfeld) rechnet die Hybrid-Komposit-Zeile (V-02R) ein, NICHT ausdruecklich das zusaetzliche Namensfeld aus V-05R — Nachrechnung vor B-5 fehlt.

---

## V-06 — Gattung+Genus als zwei Symbole

**VORGESCHICHTE:**
- **11.08.2026 spaetabends (KON7-01, `:10646-10662`):** *"IST-STAND, gemessen: die Identitaets-Flaeche ist heute OPTIONAL, nicht Pflicht ... Der Loader verlangt weiterhin NUR die VIER Pflicht-Symbole -- ein Modul ohne Stempel laedt unveraendert, es traegt hier eben nullptr." → SOLL: Pflicht.* Geburtsstunde des "5. Symbols" — aber NUR EIN Symbol, bezogen auf Traeger-STUFEN (Planer/CEB/Tier/Hybrid).
- 16.08.2026 (KON96-01, Korb A, Punkt 11): "5. ABI-Symbol Stempel: OPTIONAL → PFLICHT (KON7-01)" als lebender #15-Bruch-Posten.
- 17.08.2026 vormittags (Restfragen-Vorlage, KON100): verengt die Frage — KON7-01 nannte nur STUFEN, nicht GATTUNGEN: "vier der fuenf Gattungs-ABI-Koepfe (set_/sequence_/view_/adapter_module_abi_v1.hpp) definieren das Symbol nicht (0 VERSION_STAMP-Treffer)". Echte Luecke in KON7-01 selbst: die 11.08.-Festlegung dachte die Gattungs-Fragmentierung nicht mit.

**DELTA DER HEUTIGEN ANTWORT:** Der Owner beantwortet nicht nur "gattungs-agnostisch ja" (bereits Lead-Vorschlag), sondern fuegt eine in KEINER Vorgeschichte-Stelle vorkommende Verdopplung hinzu: *"Aber Genus spezifiziert Gattung und das muss als ZWEI SYMBOLE mitgefuehrt werden."* KON7-01 sprach durchgehend von EINEM (5.) Symbol; die heutige Antwort macht daraus ZWEI getrennte ABI-Symbole (Gattung + Genus) am selben Traeger-Schnitt — eine echte strukturelle Erweiterung ueber den gesamten bisherigen Bestand (auch KON7-02/-03/-04, die das Genus-Interface nur als EIN zusammengesetztes Objekt fuehren).

**UEBERHOLT-MARKER-LISTE:**
- KON7-01, Formulierung "der Versionsstempel ist das FUENFTE [Symbol]" (Singular; heute `:10646`): ueberholt, sobald B-7/A-11 baut (dann zwei zusaetzliche, nicht eines).
- Code-Kommentar an `abi/anatomy_module_abi_v1_decl.hpp:136` ("vier Pflicht-Symbole"-Zaehlung, Ledger-zitiert, nicht in dieser Sitzung selbst nachgegrept): Marker faellig, sobald auf fuenf/sechs umgestellt wird.

**FEHLENDE BAU-FOLGEN:**
- Ungeklaert, ob "der gemeinsame Traeger-Schnitt" (KON101-02) die vier luecken-behafteten Gattungs-Koepfe (set_/sequence_/view_/adapter_) automatisch mitdeckt oder jeder einzeln nachgezogen werden muss — entscheidend fuer den B-7/A-11-Umfang.

---

## V-08R — Planer-SHA nur ueber die Versionsnummer

**VORGESCHICHTE:**
- **10.08.2026 (KON2-06, `:12057-12075`, Owner verbatim, selbentags bestaetigt "Das ist jetzt alles korrekt."):** *"Der Planer ... hat laut Plan eine simple X.Y.Z Versionierung und einen Fingerprint SHA wie alle Planer/CEB/Tier-Binary/Hybrid-Tier-Binary."* — Quelle von "SHA wie alle".
- Kurz danach, selbe Konsolidierungsrunde (`:10126/:10977/:12278-12280`): Luecke gemessen — "Planer hat KEINEN Fingerprint-SHA (0 Treffer 'fingerprint'/'sha')".
- AM OBJEKT bestaetigt (`planner_version.hpp:79-83`, in dieser Sitzung gelesen): Luecke ist LAUT deklariert — `fingerprint_sha()` liefert `{}`, `kFingerprintShaBewusstLeer = true`, Begruendung: *"der Planer traegt noch keinen SHA-512-Fingerprint; Fuellung = eigener Posten (Preimage-/Glied-Entscheid nicht in S-1)"* — das Feld wartet buchstaeblich auf V-08R.
- 17.08.2026 vormittags (Restfragen-Vorlage): fasst DASS (10.08.) und WIE-Luecke (Code) zusammen, stellt die enge Frage: eigene Preimage-Glieder + Einzug ins Tier-Preimage, oder BewusstLeer bis spaeter?

**DELTA DER HEUTIGEN ANTWORT:** KON2-06 sagte nur "SHA wie alle" — WELCHE Bytes hineingehen, war offen (Tier/CEB/Hybrid verketten MEHRERE Preimage-Glieder). Die heutige Antwort verengt radikal: *"Der Planer traegt ja nur eine Versionsnummer und die wird fuer seinen SHA256 gehasht."* Schliesst explizit aus, dass ISA/OS (die laut `planer_gesamt_stempel_teile()` bereits im Gesamt-Stempel stehen, AM OBJEKT bestaetigt) ins SHA-Preimage eingehen. "Kein Einzug in das Tier-Preimage" (KON101-02) ist eine LOGISCHE FOLGE der Lead aus "nur Versionsnummer", nicht woertlich vom Owner gesagt — moegliche stille Interpretation, vor B-6 zu pruefen.

**UEBERHOLT-MARKER-LISTE:**
- `planner_version.hpp:79-83` (Code, `kFingerprintShaBewusstLeer`+Begruendungstext): ab B-6-Bau ueberholt, der Code sagt es selbst ("Fuellung = eigener Posten" — V-08R IST jetzt dieser Posten).

**FEHLENDE BAU-FOLGEN:**
- KON101-02 nennt (im V-02R-Absatz) einen Konsistenz-Anker "SHA-256-Linie wie E-A (Name) und V-08R (Planer)" — dieser Bezug wird in der V-08R-eigenen Buchung NICHT gespiegelt. Drei Stellen (E-A/Hybrid-Map/Planer) muessen im SELBEN Muster gebaut werden, sonst drei verschiedene SHA-256-Konstruktionen im selben Bruch.

---

## V-09R — prod2_alder_lake + RMA additiv

**VORGESCHICHTE (volle prod2-Identitaets-Kette):**
- bis 09.07.2026: prod2 = Intel i9-14900KS (Raptor Lake) — durchgehende Referenz (`:19181/:19277`).
- 09.07.2026 (`:19277-19279`): CI-Haenger auf prod2 als Kernel/D-State-Problem des 14900KS diagnostiziert.
- **10.07.2026 (`:19338-19345`, USER-INFO):** *"i9-14900KS GESTORBEN, RMA/Austausch; Rueckkehr erst ~September 2026"* — `COMDARE_PROD2_AVAILABLE=false`.
- ~10.07.2026 (RMA-Ersatz): physischer Tausch gegen i9-12900K (Alder Lake) — seither durchgehend belegt (`:7203`).
- **09.08.2026 ("Kleinentscheide"-Absatz, unmittelbar vor der Hybrid-Gattungs-Findung desselben Tages):** *"prod2 wird umbenannt -- 'Ja umbenennen', weil es dauerhaft so bleibt. Byte-Ereignis: der Registry-Generator spiegelt den Namen ⇒ in ein Fenster legen, in dem ohnehin ein Bump ansteht."* Das DASS ist hier bereits entschieden, nur Token+RMA-Rueckkehr-Verfahren blieben offen.
- 15.-16.08.2026 (`:17860-17973`, Owner-Wort 10.08. "Wenn prod2 kein AVX512 hat..."): **STALE-BEFUND** — `machine_simd_signature.hpp:90` deklariert weiterhin "Intel Core i9-14900KS (Raptor Lake)": ZWEIFACH falsch (Modell UND Microarchitektur-Familie). Thesis hat es bereits korrekt ("Alder Lake"); Rangfolge THESIS>OWNER>PLAN>LEAD greift.
- 16.08.2026 (KON96-01, Korb A, Punkt 8): "prod2-Registry-Umbenennung" als lebender #15-Bruch-Posten.
- **Querbezug, 10.08.2026 (`:10999/:12178`):** die allgemeine Doktrin "Hardware-Erweiterung ist ADDITIV" wird etabliert — dort AUSSCHLIESSLICH fuer Erweiterungs-FLAGS (SIMD/bvset: neue Faehigkeit zwingt nicht die ganze Flotte zum Neubau), NICHT fuer Maschinen-Identitaeten.

**DELTA DER HEUTIGEN ANTWORT:** Owner bestaetigt exakt den Lead-Vorschlag. Der Delta-Gehalt: die am 10.08. NUR fuer Hardware-FLAGS etablierte Additivitaets-Doktrin wird HEUTE ERSTMALS EXPLIZIT auf eine GANZE MASCHINEN-IDENTITAET ausgedehnt — kehrt der 14900KS im September zurueck, entsteht eine DRITTE, neue `machine_id` NEBEN `prod2_alder_lake` (kein Ueberschreiben). Praezedenzfall-Erweiterung eines bestehenden Axioms auf einen bisher nie behandelten Fall.

**UEBERHOLT-MARKER-LISTE:**
- **`machine_simd_signature.hpp:90`** (Code, Ledger-belegt): hoechstpriorisierter Fund — traegt technische FEHLINFORMATION (Raptor Lake ≠ Alder Lake), nicht nur einen veralteten Namen.
- Jede Ledger-Stelle vor dem 10.07., die "prod2 = i9-14900KS" als AKTUELL (nicht Historie) fuehrt — mehrere gefunden, NICHT erschoepfend durchsucht (EXPLORE-LUECKE, insb. `docs/plaene/`).

**FEHLENDE BAU-FOLGEN:**
1. Der Raptor-Lake-Fehlbefund ist WEDER in KON101-02 noch in KON96-Korb-A als eigener Korrektur-Posten (analog K1 fuer avx512-XML) gefuehrt — droht im reinen Umbenennungs-Bau unterzugehen.
2. Kein Namensschema fuer die kuenftige RMA-Rueckkehr-machine_id (z. B. `prod2b_raptor_lake`) — ohne Schema kann der additive Eintrag im September nicht mechanisch erzeugt werden.
3. Reihenfolge-Abhaengigkeit zu V-03R (avx512-Matrix) ungebucht: die Umbenennung muss vor der naechsten Voll-Messung stehen, sonst tragen CSVs zwei Bezeichner fuer dieselbe Hardware.

---

## V-11R — PrueflingVerbundStrategy (Verbund1/2/3 + XML-Token "union")

**VORGESCHICHTE:**
- **12.08.2026 (KON30-02, `:7015-7044`, Owner verbatim "R-2 BEANTWORTET"):** das "Pruefling-Test-Konzept" wird als DRITTES, eigenstaendiges Konzept etabliert (weder Traeger-Stufe noch Phase); Konsequenz: "die drei `MergeStrategy`-Werte sind Pruefungs-Verbund-Varianten (CeOnly/PrueflingReplace/FullJoin)"; der kuenftige Name wird ausdruecklich **"beim S-6-Fenster-Bau vorgeschlagen"**.
- 12.08.2026 (KON36-02, Fakt F1): konsolidiert dieselbe Aussage.
- 06.08.2026 (parallel im 12-Wochen-Fenster): "F3: fixture sauber nachziehen" → 689-Z.-Plan `20260806-PLAN-scheibe6-weg-a-fixture-entflechtung.md` — der Bau-Kontext, in dem der neue Bezeichner ueberhaupt gebraucht wird.
- **16.08.2026 (KON91-01, `:946-965`, Owner verbatim Teil 37, EINEN TAG VOR V-11R):** definiert fuer die Lager-/xlsx-Ausgabe eine VOELLIG ANDERE Bedeutung von "FULL JOIN": *"ab der ma-Ebene tragen ALLE Sheets ALLE moeglichen Parameter ... als FULL JOIN der jeweils spezifischen ACHSEN-ERFOLGS-PARAMETER"* — ein Spalten-/Sheet-Mechanismus im MessStorage-Export, thematisch unverwandt mit der C++-`MergeStrategy`.
- 16.08.2026 (KON96-01, Korb A, Punkt 9): benennt die Kollision explizit: "FullJoin-MergeStrategy UMBENENNEN (Namens-Kollision mit KON91-Full-Join; KON30-02)".
- 17.08.2026 vormittags (Restfragen-Vorlage): schlaegt "PrueflingVerbundStrategy" mit "Verbund1_CeOnly/Verbund2_Replace/Verbund3_Union" + Token "union" statt "fulljoin" vor.

**DELTA DER HEUTIGEN ANTWORT:** Owner bestaetigt exakt ("Vorschlag angenommen. Genau so."). Delta: dies ist der letzte Schritt einer Kette, die am 12.08. MIT DER ERWARTUNG begann, der Name werde "beim S-6-Fenster-Bau" kommen — jetzt eingetreten. Zusaetzlich loest die Antwort eine Kollision, die bei KON30-02s urspruenglicher Benennung NOCH GAR NICHT existieren konnte (KON91-01 mit der konkurrierenden Bedeutung entstand erst vier Tage spaeter) — die alte Empfehlung war zum Entstehungszeitpunkt korrekt und wurde durch spaeteres, unabhaengiges Vokabular ueberholt, nicht durch einen Fehler.

**UEBERHOLT-MARKER-LISTE:**
- Jede Code-/XSD-Stelle mit "FullJoin"/"fulljoin" fuer die Pruefling-Verbund-Achse (laut Restfragen-KONTEXT: XSD-Werte "Stufe1_CeOnly|Stufe2_PrueflingReplace|Stufe3_FullJoin" + C++ `MergeStrategy::FullJoin`) — wird durch B-2 vollstaendig ersetzt.
- KON30-02s eigener Satz "wird beim S-6-Fenster-Bau vorgeschlagen" ist jetzt erfuellt — Statuswechsel, kein Fehler.

**FEHLENDE BAU-FOLGEN:**
1. KON91-01s "full join" (Lager/xlsx) bleibt bestehen — keine Sprachregel gebucht, die die Doppel-Verwendung des Wortes in Kommentaren/Dossiers vermeidet.
2. Namensverkuerzung "Verbund2_Replace" (heute) vs. "PrueflingReplace" (KON30-02, ohne "Verbund"-Praefix) — nicht ausdruecklich vom Owner auf Wortlaut-Ebene bestaetigt (er sagte "genau so" zur VORGELEGTEN Schreibweise); Wortlaut-Abgleich vor B-2 ratsam (Stempel-Syntax-Doktrin verlangt besondere Sorgfalt bei Kuerzeln).

---

## V-12 — work_mode/RunMethodology-Ordinale

**VORGESCHICHTE:**
- 20.07.2026 (Code-Kopfkommentar `run_methodology_registry.hpp:1-8`, AM OBJEKT gelesen): `RunMethodology` geboren mit `{Debug, Measure, Release}` — "historische Reihenfolge ihrer Entstehung".
- 26.07.2026 (Code-Kommentar `:7-8`): Compare wird 4. Registry-Modus.
- **07.08.2026 (Owner-Entscheid O-A, Code-Kommentar `:10-24`, AM OBJEKT gelesen, woertlich):** *"formal kommt compare als Stufe mit eigenen Optionen vor dem release"* — Ablauf-Ordnung auf measure→compare→release festgelegt. Der Code haelt EXPLIZIT fest: *"Die Enum-Reihenfolge wurde bewusst NICHT umgestellt: sie ist stempel-/ABI-relevant, und der Owner-Entscheid O-A betrifft die formale STUFEN-Ordnung, nicht die Aufzaehlung"* — Geburtsstunde der spaeter "G-5" genannten offenen Frage.
- 09.08.2026 spaet (`:14529-14570`+`:14760-14930`, "EIN Muster, FUENF Begriffe"): Owner korrigiert einen ERSTEN FALSCHEN Modellierungsversuch der Session (Debug als 5. gleichrangiger State, `kRunMethodologyCount` 4→5 — VERWORFEN); stellt klar: Debug ist FLAG, nicht State; neue States `{build, measure, compare, release}` — Build ersetzt Debug (4 Werte bleiben 4, nur Debug raus/Build rein).
- 16.08.2026 (KON96-01, Korb A, Punkt 5): "work_mode-Enum-Umbau Debug raus/Build rein, `kWorkModeCount=4`" — bestaetigt die 4er-Zahl (korrigierte Linie, nicht der erste Fehlversuch mit 5).
- 17.08.2026 vormittags (Restfragen-Vorlage, wortgleich mit Code `run_methodology_registry.hpp:19-24`, AM OBJEKT verifiziert — stabiler Anker, weil Code-, nicht Ledger-Zeile): fasst zusammen, DASS die Umbenennung entschieden ist, aber die ORDINAL-WERTE bewusst offen blieben (G-5).

**DELTA DER HEUTIGEN ANTWORT:** "Bitte wie empfohlen mit drehen" bestaetigt exakt. Delta: DIES ist der Moment, in dem zwei seit Wochen bewusst GETRENNT gehaltene Fragen (07.08.-Ablaufordnung O-A und 09.08.-Debug/Build-Umbenennung) ERSTMALS zusammengefuehrt werden. Der Code-Kommentar selbst warnte bisher ausdruecklich vor genau dieser Vermengung ("Wer eine Ablauf-Ordnung braucht, leitet sie aus der Enthaltungs-Ordnung ab ... nicht aus dem Enum-Index"). V-12 hebt diese Trennung foermlich auf: ab dem #15-Bruch fallen Enum-Index und Ablauf-Reihenfolge zusammen — eine Architektur-Vereinfachung, die weder am 07.08. noch am 09.08. explizit angeordnet war.

**UEBERHOLT-MARKER-LISTE:**
- **`run_methodology_registry.hpp:19-24`** (AM OBJEKT AKTUELL/LIVE bestaetigt): der komplette Absatz ist ab B-5d in ALLEN DREI Teilaussagen ueberholt — (a) Enum-Name "debug" verschwindet, (b) Enum-Reihenfolge WIRD umgestellt (Gegenteil der dortigen Aussage), (c) Begruendung "stempel-/ABI-relevant, daher eingefroren" entfaellt.
- Zeilen 54-58 (Enum-Definition) + 62 (`kRunMethodologyCount`): direkt mitbetroffen.

**FEHLENDE BAU-FOLGEN:**
1. KON96-01 nennt "kWorkModeCount", der Code kennt nur "kRunMethodologyCount"/Typ "RunMethodology" — ungeklaert, ob der C++-Typname mitumbenannt wird oder nur Werte/Ordinale; Ledger-Sprache ("work_mode") und Code-Sprache ("RunMethodology") drohen sonst weiter auseinanderzulaufen.
2. Owner-Entscheid O-A (07.08.) bezog sich NUR auf compare/release (Build gab es als State noch nicht) — die heutige Zuweisung `{Build=0,Measure=1,Compare=2,Release=3}` setzt Build VOR Measure, eine neue Aussage, die nur indirekt aus der 09.08.-Rollentabelle (Beschreibung, kein Ordinalwert) folgt; Anker-Nachtrag fehlt.

---

## V-13 — CEB-Legenden NUR wallclock/macro/micro (syntaktisch erzwungen)

**VORGESCHICHTE:**
- 07.08.2026 (D-4/R-3, Code-Kommentar `ceb_version_stamp.hpp`, AM OBJEKT gelesen): D-4-Defekt benannt — "`kCebFingerprint` rendert das ANGEBOT der Registry statt der einkompilierten WAHL ... Zwei CEBs mit `[wallclock]` und `[macro]` tragen DENSELBEN `ceb_key_sha512`" (ein VERSCHIEDENER Fehler als V-13: Injektivitaets-Bruch zwischen UNGLEICHEN Auswahlen). R-3 fuehrt danach `kCebFingerprint` als eigenstaendiges Preimage-Konzept ein (Format 3→4).
- **Unmittelbar im selben Kommentarblock, Abschnitt "EHRLICHE GRENZE: PERMUTIERTE LEGENDEN UEBERUNTERSCHEIDEN" (AM OBJEKT gelesen, gemessene Werte):** *"'[wallclock,micro]' und '[micro,wallclock]' liefern VERSCHIEDENE Schluessel (gemessen: 250be8b2... bzw. a30fe495...)"* — woertlich die von der Restfragen-Vorlage zitierte Messung. Der Code erklaert selbst, warum das bewusst so bleibt (gemeinsamer Runtime-Renderer haelt Eingabe-Reihenfolge; eine Kanonisierung nur an EINER Stelle waere eine NEUE Drift) und schliesst: *"Eine Kanonisierung muesste BEIDE Zwillinge zugleich erfassen und ist damit ein Byte-Ereignis am Tier-Preimage -- also eine EIGENE SCHEIBE MIT OWNER-ENTSCHEID, kein Nebenprodukt."* Dies ist woertlich die "0-Treffer-Gegenprobe"-Selbstdeklaration, die die Restfragen-Vorlage zitiert.
- 15.08.2026 (B2, Code-Kommentar `mess_gate_segment_timing.hpp:1-38`, AM OBJEKT gelesen): loest einen VERWANDTEN Altfall — bis B2 teilten sich `[wallclock,macro]` und `[wallclock,micro]` EIN Gate; B2 trennt sauber. Zeigt: die Legenden-Mehrdeutigkeit hat bereits einmal echten Schaden (Gate-Vermengung) verursacht, wurde aber NUR fuers Gate-Verhalten repariert, nicht fuer die Schluessel-Kanonisierung.
- 16.08.2026 (KON96): kein eigener Korb-A-Punkt — konsistent mit der Selbstdeklaration im Code als bereits erkannte "eigene Scheibe".

**DELTA DER HEUTIGEN ANTWORT:** Der Owner beantwortet nicht nur die Grundsatzfrage ("falten" — bestaetigt), sondern legt die KONKRETE Form fest, die weder Code-Kommentar noch Restfragen-Vorlage vorschlugen: *"Es wird nur die Reihenfolge wallclock/macro/micro erlaubt, alles andere ist syntaktisch falsch."* Das ist STRENGER als gewoehnliche Kanonisierung (stille Normalisierung in Registry-Reihenfolge — genau wovor der Code-Kommentar warnte, weil das den Tier-Preimage-Zwilling nicht automatisch mitzieht). Stattdessen: WURF-Semantik (Ablehnung als Syntaxfehler) statt stiller Normalisierung — deckt sich mit der 13.08. etablierten "fail loud"-Doktrin (KON103-01: "Stille nullen gibt es bei Messung nicht"), hier ERSTMALS auf die CEB-Legenden-Grammatik angewendet.

**UEBERHOLT-MARKER-LISTE:**
- `ceb_version_stamp.hpp`, Block "EHRLICHE GRENZE: PERMUTIERTE LEGENDEN UEBERUNTERSCHEIDEN" (AM OBJEKT lokalisiert, unmittelbar vor "R-3"): die Schlussfolgerung "sie ist fail-CLOSED ... kostet nichts" gilt nach B-5f nicht mehr (dann koennen gar keine zwei Schluessel fuer dieselbe Menge mehr entstehen) — datierter UEBERHOLT-Kopf faellig, Herleitung bleibt wertvoll.
- `ceb_tooling_list()`-Funktionskommentar, Satz "sonst: die Tokens in EINGABE-Reihenfolge (nicht Registry-Reihenfolge)" — praeziser Ersetzungs-Ort fuer B-5f.

**FEHLENDE BAU-FOLGEN:**
- Der Code-Kommentar nennt selbst DREI betroffene Stellen: `ceb_tooling_list()` (CEB-Seite), `abi::measurement_stamp_line_from_combo_legend()` (Tier-Preimage-Seite, laut Kommentar der eigentliche Ordnungs-Ursprung), `mess_achsen_defines()` (`profile_facade/mess_achsen_naht.hpp`, Emissions-Seite). KON101-02 bucht nur die ERSTE ("`ceb_tooling_list` wird im Bruch (B-5f) auf Ordnungs-Validierung umgestellt") — die zwei vom Code selbst als GLEICHERMASSEN BETROFFEN benannten Stellen fehlen in der Buchung. Ohne sie bliebe ein Tier-Binary theoretisch ueber einen anderen Aufrufpfad mit nicht-kanonischer Legende baubar, waehrend "die permutierten Zwillings-Schluessel verschwinden dadurch klassenweise" (KON101-02) nur zutrifft, wenn ALLE drei Stellen denselben Wurf bekommen.

---

## GEPRUEFT/NICHT GEPRUEFT

**GEPRUEFT** (Vorgeschichte gehoben mit primaeren Ledger-Ankern + Code-Gegenprobe, Delta benannt, Ueberholt-Orte lokalisiert, Bau-Folgen-Luecken identifiziert): V-01R, V-03R, V-04R, V-05R, V-06, V-08R, V-09R, V-11R, V-12, V-13 — alle zehn zugewiesenen Entscheide.

Einschraenkungen (ehrlich zu benennen, kein NICHT-GEPRUEFT im Kern, aber Restlueken):
- Owner-KERN 26.07. (V-03R) und Owner E2 02.08. (V-01R) wurden ueber bereits BESTANDENE Stichproben fruehere Sitzungen (KON100-S7, Memory-Zitat) uebernommen, nicht in dieser Sitzung selbst gegen das Roh-Transkript `46375cdc` erneut verifiziert — Stichprobe war bereits bestanden, hier nicht wiederholt.
- `docs/plaene/` wurde NICHT vollstaendig durchsucht (nur zwei namentlich referenzierte Plaene geoeffnet: `20260806-PLAN-scheibe6-weg-a-fixture-entflechtung.md`-Existenz bestaetigt, `20260806-PLAN-versionierungs-interface-stempel.md`-Existenz bestaetigt, Inhalte nicht vollstaendig gelesen) — moegliche weitere Fundstellen fuer V-09R (stale Raptor-Lake-Kopien) und V-03R (weitere 24.07.-Zwischenstand-Kopien) bleiben ungehoben.
- `docs/sessions/backups/` (kon64_sammlung.md Roh-Verbatims) wurde in dieser Sitzung NICHT geoeffnet — die Ledger-Zitate selbst tragen bereits Datum+Wortlaut+teils Stichproben-Vermerk, gelten hier als hinreichend fuer die Buchungstiefe.
- Gegenprobe `docs/termine/` + `docs/termine_konsolidiert/`: 0 Treffer fuer alle zehn Themen — bestanden, dokumentiert oben.

**Uebergreifender Befund (gehoert an keinem einzelnen V-Punkt, sondern faellt gemeinsam):** Fuenf der zehn Antworten (V-01R, V-06, V-09R, V-12, V-13) folgen demselben Muster — eine bereits vor Wochen etablierte DOKTRIN oder STRUKTUR (Additivitaet, Flaeche-2, Fail-loud, Append-only) wird HEUTE ERSTMALS auf einen bisher nie behandelten NEUEN ANWENDUNGSFALL derselben Doktrin ausgedehnt (Maschinen-Identitaet statt Feature-Flag; zwei Symbole statt eines; Legenden-Syntax statt Messwert-Nullen; Enum-Index statt nur Ablaufordnung; Zuordnungs-Graph statt nur Reihenfolge). Diese fuenf teilen eine gemeinsame, bisher NICHT gebuchte Bau-Folge: die jeweils "ausgedehnte" Alt-Doktrin sollte an ihrem URSPRUENGLICHEN Ort (Memory-Dokument bzw. Ur-Ledger-Stelle) einen Nachtrag "gilt jetzt auch fuer X" erhalten, sonst bleibt die Verallgemeinerung nur an der neuen Stelle sichtbar und ein spaeterer Leser des Alt-Ortes haelt die Doktrin faelschlich fuer eng (nur Flags/nur Stufen/nur Reihenfolge).