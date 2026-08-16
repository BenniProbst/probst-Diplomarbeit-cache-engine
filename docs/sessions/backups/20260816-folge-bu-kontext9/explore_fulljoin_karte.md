# FULL-JOIN mi->ma (KON91-01) — KONSOLIDIERTE KARTE (Synthese beider Kartierungen + Arena-Zusammenfuehrung)

Synthese-Auftrag KON91-01: Konsolidierung von Karte 1 (Rohtranskripte) und Karte 2 (Plaene/Ledger/Code)
zu EINER Karte, zusammengefuehrt mit der Arena-Ketten-Karte (KON92, wf_eebc8294) gemaess Owner-Order
("mit Arena-Explore zusammenfuehren"). Fable 5 max. Schreibweise ASCII-transliteriert (Haus-Stil der
Ledger-Nachtraege); Owner-Originale tragen teils echte Umlaute (Rohtranskript ist die Buchstaben-Wahrheit).

Wurzeln: super = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine ·
ce = super/Code/external/comdare-cache-engine ·
Transkripte = /home/comdare/.claude/projects/-home-comdare/*.jsonl.

---

## 0. KERNBEFUND

1. **Der Mechanismus ist als PRINZIP alt und geplant, als SPALTEN-AUSPRAEGUNG neu.** Die Wortpraegung
   "full-join-Mechanismus mi->ma (Achsen-Erfolgs-Parameter -> Gesamt-Spaltenmenge)" entsteht am
   16.08.2026, 12:08:25 UTC (Teil 37) und hat davor 0 Fundstellen (doppelt gegengeprobter Nichtfund
   beider Kartierungen). Das vom Owner gemeinte "das ist geplant" ist gleichwohl BELEGT: die
   Drei-Stufen-Messkette vom 26.07. (Stufe 2 Macro = "Akkumulation ALLER verwendeten Achsen Parameter
   in der gemessenen Interface-Funktion", Ledger:28532-28547) und der Mess-Baum vom 08.08.
   (Ledger:28670-28707) SIND der Mechanismus in aelteren Worten — auf WERTE-Ebene. KON91-01 hebt ihn
   auf SCHEMA-Ebene (Spalten). Diese Zwei-Ebenen-Lesart (Schema = alle MOEGLICHEN Parameter; Werte =
   die tatsaechlich VERWENDETEN/akkumulierten) versoehnt 26.07. mit 16.08. und erzeugt zugleich
   zwingend die offene Abwesenheits-Frage (O1).
2. **"full join" ist im Projekt DREIFACH ueberladen** — (A) Algorithmen-Merge PRT-ART/CE seit 20.07.
   (GEBAUT: `AxisFullJoin`, `MergeStrategy::Stufe3_FullJoin`), (B) Fristschaetzungs-Aggregation 08.08.
   (Ledger:28514-28515), (C) Spalten-Union mi->ma 16.08. (NICHT gebaut, dieser Gegenstand). Eine
   Codesuche nach "FullJoin" trifft NUR (A) — Falsch-Positiv-Falle fuer jede kuenftige Suche/Review.
3. **CODE-IST vs. SOLL: 12 Deltas** (Abschnitt 3). Kein Code VERLETZT den Plan-Kern — er ist schlicht
   nicht gebaut; verletzt wird nur der measurement_sink-Entscheid (uebergangsweise toleriert, KON32-01).
4. **Der Join und der Arena-Drain sind EIN Bauwerk mit zwei Gesichtern**: der Full Join definiert das
   ZIEL-SCHEMA (Spalten je Ebene), der Arena-Drain (E4/E6) ist der MECHANISMUS, der schmale mi-granulare
   Checkpoint-Zeilen in genau dieses Schema pivotiert und auf die Sheets verteilt (Abschnitt 4).

---

## 1. OWNER-ZITATE (chronologisch, mit Quelle)

Z1 — **16.07./20.07.2026** (`46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl:44041` und `:66950`;
Ledger:20838 U-2): "full join" Bedeutung (A) — "... werden je Achse die Algorithmen nicht mehr
ersetzt, sondern in der Cache-Engine durch einen full join ersetzt, was dann den sogenannten
vollstaendig 'kombiniert' Modus ausmacht, bei dem durch den full join nichts verworfen wird."
Etabliert das PRINZIP "vereinigen, nichts verwerfen" — anderes Objekt (Pruefling-Algorithmen).

Z2 — **26.07.2026, 11:09 UTC** (`46375cdc:79417`; als "Owner-KERN 26.07." in Ledger:194-207,
Task #55): "... wenn du sagst, dass die Unter-Achsen eigene Spalten haben, ist das korrekt, die
Haupt-Achsen werden in einem separaten sheet fix definiert [...] dann erwarten wir zu diesem
Haupt-Achsen-Blatt 3 weitere Ebenen fuer die Zergliederung in Mess-Unter-Achsen, darunter
System-Unter-Achsen und darunter Organ-Unter-Achsen." — Erste Fixierung "Spalte/Sheet je Unter-Achse".
CAVE: diese Dreiheit sind ACHSEN-KATEGORIEN (Mess/System/Organ), NICHT die w/ma/mi-Messgranularitaet.

Z3 — **26.07.2026** (Fassung 1, verbucht 07.08. abend, Ledger:28532-28547): Drei-Stufen-Messkette —
Stufe 1 Micro: "Ein checkpoint steht immer VOR der Verwendung einer Achse..."; Stufe 2 Macro: "...
mit der Akkumulation ALLER verwendeten Achsen Parameter in der gemessenen Interface-Funktion";
Stufe 3 combined. — **Die geplante Sach-Wurzel des mi->ma-Join auf Werte-Ebene.**

Z4 — **07.08.2026, 12:19 UTC** (`5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl:13579`): "Frage 5: Alle
min/max Parameter kommen dort rein. Alle Zeiten von Micro/Macro Benchmarking und Wallclock time. Die
cacheline aware dTLB und Cache Layer PMC Werte ... ALLE." / "Frage 3: Bitte explore, das Blatt ist
schon im Session log geplant." — Erste ALLE-Parameter-inkl.-PMC-Aussage fuer das Blatt.

Z5 — **08.08.2026** (`5a19728e:17190`; Ledger:28514-28515): "full join" Bedeutung (B) —
Cross-Paper-Ergebnis-Aggregation fuer die Fristschaetzung. Dazu am selben Tag der Mess-Baum
(Ledger:28670-28707): jede Interface-Funktion "akkumuliert aus den Einzel-Aufrufen mit checkpoint
davor und danach jeden einzelnen Achsen Aufruf."

Z6 — **14.08.2026, 20:36 UTC** (`5a19728e:55065`; Ledger KON64, Marker Ledger:1990-1992): "F-G1-8:
Die PMC ist hardware und wird per dreiphasig als Meta-Meta-Achse als eigenstaendig eingepflegt, aber
nicht in der existierenden Achse, bitte lies den Plan, das ist geplant (explore!)." — Ueberholt
"PMC als Unter-Achse von micro" (20260806-PLAN...:363).

Z7 — **14.08.2026, 21:10 UTC** (`5a19728e:55213`; Ledger:1800-1804 KON65-02): "... dass die xlsx auch
in allen Tabellen die verfuegbaren CSV Spalten traegt. Die Aufmachung der xlsx ist geplant (10 Wochen
explore)." — CSV-Spalten-Identitaet je Tabelle + Explore-Order xlsx-Aufmachung (Task #55, S-13-Vorlauf).

Z8 — **14.08.2026, 21:35 UTC** (`5a19728e:55259`; Ledger:1809-1815 KON65-03 F1): "F1: [...] existiert
keine PMC, wird allerdings gar nicht erst eine eingetragen, das ist also eine Sonder-Grammatik fuer
diese Achse. Das PMC wird DREIPHASIG eingebaut, daher ist es auf CEB und Tier/Hybrid mit einzutragen
als permutierende Messeinrichtung, die als ZUSAETZLICHE Achse die Permutation gegen w/ma/mi erweitert."
— **Die kein-Eintrag-bei-Abwesenheit-Sondergrammatik der PMC-Schwester: BELEGT** (fuer den
ACHSEN-EINTRAG/Stempel-Glied; Ledger-Destillat: "Abwesenheit = KEIN Eintrag, kein leerer Slot").

Z9 — **16.08.2026, 10:22 UTC** (`5a19728e:58708`): "V3 - Hier bist du auf dem Holzweg, weil ueber
einen explore ueber 10 Wochen bewiesen werden kann, dass die Mess-Hierarchie von w/ma/mi Benchmarks
auch zu einer Hierarchisierung der Excel sheets fuehrt und das ist detailliert geplant [...] alle
Parameter stehen dann im Blatt [...]." — Vorstufe der P1/P2/P3-Runde am selben Vormittag.

Z10 — **16.08.2026, 11:47:48 UTC, Teil 35** (`5a19728e:59056`; kon64_sammlung.md:1411-1425; Ledger
KON88 :192-223): P1: w/ma/mi-Hierarchie lebt im FILESYSTEM neben der Binary, nicht im Sheet-Namen;
"Jedes sheet und deren Tabelle werden also zu genau einer Unter-Achsen-Einstellung erzeugt"; EIN Sheet
je Unter-Achse, darin alle Laufzeit-Permutationen als sequentiell abgetrennte Tabellen; "Leider sind
deine beiden Loesungsvorschlaege falsch." P2: EINE Zeile je Mess-Aufruf; Kalt-Aufruf bekommt KEINE
eigene Zeile, sondern je Spalte einen relativen KALT-DIFF (+/-x) im Feld der warmen Zeile; Messwerte
liegen ZUERST in ARENEN, xlsx nachgelagert, sequentielle Folge-Blaetter, einziges hartes Limit = RAM.
P3: "PMC ist eine Haupt-Meta-Meta-Achse, all deren gemessene Parameter bekommen Spalten in den
Blaettern und das ist damit eine compound-Dimension."

Z11 — **16.08.2026, 12:08:25 UTC, Teil 37 = DER FULL-JOIN-SATZ** (`5a19728e:59132`;
kon64_sammlung.md:1451-1471; Ledger:109-131 KON91-01): "In den Spalten aller sheets ab der ma Ebene
finden wir ALLE moeglichen Parameter, also auch die PMC Parameter, welche der full join aller
Parameter jeweils spezifischen Achsen-Erfolgs-Parameter aus der mi Ebene der einzelnen
Achsen-Interfaces ist (nochmal explore ueber 10 Wochen, das ist geplant). Ein sheet je Unter-Achse
gilt fuer jede der 3 w/ma/mi Ebenen, sofern die jeweilige Unter-Achse in der Messung verfuegbar ist,
weil ja die mi Ebene nur die eingeschraenkten Erfolgs-Parameter einer Achse messen kann. [...]
Ansonsten alles korrekt verstanden, volles GO." — Teil der Kontext-Ende-Nachricht; danach kein
weiterer Owner-Text zum Thema (Gegenprobe bis Dateiende :59464). "Alles korrekt verstanden" quittiert
zugleich die P1-Verstaendnis-Rueckgabe (KON88) — P1 damit bestaetigt.

Z12 — **16.08.2026 (Folge-Kontext)** (Ledger:44-63 KON93-02): "Die Kapazitaet wird auf 6GB
festgesetzt (bitte explore ueber 10 Wochen) und ist statisch, sie kann zu Beginn eines Experimentes
fuer die Reservierung auf dem Planer veraendert werden." — Entscheidet KON92-C6 (feste Kapazitaet);
"Weitermessen bei Ueberlauf" ist als stiller Datenverlust zu heilen. Arena-Seite desselben Buendels.

---

## 2. BILDUNGSREGEL DES FULL JOIN (praezise Definition, destilliert aus Z2/Z3/Z8/Z10/Z11)

**Objekt.** Die Messwert-Blaetter des w/ma/mi-Filesystem-Baums je CT-Binary (Z10: unter der Binary
w -> ma -> [Layer je GENUS-INTERFACE] -> mi je ACHSEN-MICROBENCHMARK-Interface; Blaetter = xlsx je
Feinkategorie). CSV = Kind: je Sheet ein Ordner, darin CSVs je Unter-Achsen-Fahrt (KON89-D3).

**Eingaben.** Je Unter-Achsen-Interface A der mi-Ebene die Menge E(A) seiner SPEZIFISCHEN
ACHSEN-ERFOLGS-PARAMETER. mi-Sheets von A tragen NUR E(A) (+ Profil-/Schluesselspalten), "weil ja die
mi Ebene nur die eingeschraenkten Erfolgs-Parameter einer Achse messen kann" (Z11). Der Wortlaut
schliesst damit funktionsgebundene op_*-Parameter und PMC-Spalten aus den mi-Sheets aus ("also auch
die PMC Parameter" erst AB ma). Naechstes Code-Analogon zu E(A):
`{seg_<A>_ns} UNION {stat_<A>_<f> : kV3AxisSchema[A].names[f] != nullptr}`
(observable_tier.hpp:68-99 + lazy_csv_header) — **Rekonstruktion dieser Karte, nirgends dokumentarisch
als "Erfolgs-Parameter" verknuepft** (-> O2).

**Vereinigung.** Spaltenmenge ab der ma-Ebene =
`UNION ueber alle A: E(A)` VEREINIGT MIT `P_funktional` (op_*-Parameter je Interface-Funktion,
Wallclock; Z3-Akkumulation) VEREINIGT MIT `P_PMC` (ALLE gemessenen PMC-Parameter als
compound-Spalten-Dimension, Z10-P3) VEREINIGT MIT der **Kalt-Diff-Anreicherung je Messwert-Spalte**
(Z10-P2: je Spalte relativer +/-x-Diff im Feld der warmen Zeile — die Diff-Traeger sind Teil von
"ALLE moeglichen Parameter"). **Geltungsbereich: ma UND w.** "Ab der ma Ebene" liest in Baumrichtung
aufwaerts (w liegt ueber ma, Z10-P1); mi ist die EINZIGE restriktive Ebene, und die SHEET-REGEL nennt
ausdruecklich alle 3 Ebenen. **Zwei Aussage-Ebenen trennen:** das Schema traegt alle MOEGLICHEN
Parameter; akkumuliert (Werte) werden die tatsaechlich VERWENDETEN (Z3) — die Differenz erzeugt
zwingend Union-Zellen ohne Quell-Beteiligung (-> O1).

**Spalten-Reihenfolge.** Vom Owner NICHT neu geordnet. Geltende Ordnungsquelle = das
Single-Source-Prinzip (KON74-04; KON87 Par. 3.1 "Spalten AUSSCHLIESSLICH lazy_csv_header()"):
KON91-01 ueberholt die MENGE je Ebene (mi = Teilmenge), nicht die Ordnungs-QUELLE. Ableitung: mi =
ordnungsstabile Teilmenge derselben Quelle; xlsx-Tabellen tragen die verfuegbaren CSV-Spalten
identisch (Z7). Die Zahl "189" (und "~150" der Arena-Karte) sind stale Momentaufnahmen — der Header
ist additiv gewachsen; eine feste Spaltenzahl darf der Mechanismus nie voraussetzen.

**Abwesenheits-Regel (drei belegte/ungeregelte Ebenen).**
(a) SHEET-Ebene, belegt (Z11): ein Sheet existiert NUR "sofern die jeweilige Unter-Achse in der
Messung verfuegbar ist" — Abwesenheit = KEIN Sheet, kein leeres. Die Verfuegbarkeits-Tore sind per
KON87 kodifiziert (4 Tore je Zelle: Zweig, Schalter, iw/ima/imi-Interface-Vorhandensein,
V7-Umwelt-Freigabe) — damit ist die i{w|ma|mi|pmc}-Interface-Grammatik (G-1 Par. 13 / PMC-Schwester
PM-15) als EINES der Tore mit der Blatt-Existenz verknuepft (Frage aus Karte 2 aufgeloest).
(b) ACHSEN-EINTRAG der PMC-Schwester, belegt (Z8): Sondergrammatik "existiert keine PMC, wird gar
nicht erst eine eingetragen" — kein Eintrag, kein leerer Slot; ausdruecklich als SONDER-Grammatik
"fuer diese Achse" markiert (Default anderer Achsen also nicht automatisch gleich). Belegt fuer das
Stempel-/Permutations-Glied, fuer Spalten/Zellen nur Analogie-Kandidat.
(c) ZELL-/SPALTEN-Ebene im Union-Schema: NICHT geregelt (doppelter Nichtfund beider Kartierungen;
Code-Randstelle honest-0 widerspricht der Analogie) — **einzige echte Definitions-Luecke, O1.**

---

## 3. CODE-IST vs. SOLL — DELTA-LISTE (12)

D1  **Spaltenfunktion einstufig statt zweistufig.** SOLL: mi restriktiv E(A), ma/w = Union. IST:
    `lazy_csv_header()` parameterlos, EIN globales flaches Schema, strukturell unfaehig eine Teilmenge
    zu liefern (ce .../experiment_tree/cache_engine_builder_iterator.hpp:555-703; Single-Source-Anker
    schema_freeze.hpp:29, pipeline_csv_schema.hpp:19).
D2  **EIN konstantes Sheet statt Sheet je Unter-Achse x Ebene.** `SheetSchluessel` existiert
    (ergebnis_mappe.hpp:90-95), der Live-Writer ruft ihn mit EINEM konstanten Wert
    (ergebnis_mappe_naht.hpp:370/450/466/497).
D3  **Ebenen-Praefix statt Filesystem-Baum.** `mess_ebene_sheetname()` traegt Alt-Praefixe C_/M_/X_
    (ergebnis_mappe.hpp:320-332); ein w/ma/mi-Baum-Writer existiert nicht (0 Treffer); KON87-Sheet-EBNF
    selbst per Z10-P1 TEIL-UEBERHOLT (Ebene/Traeger = Ordner, nicht Name).
D4  **Keine sequentiell abgetrennten Tabellen** je Laufzeit-Permutation im Sheet — der Writer kennt
    nur fortlaufende Zeilen; die 26.07.-Regel "je Einstellung" lebt im SOLL als Tabelle weiter (Z10-P1).
D5  **2 Zeilen je Aufruf statt 1 Zeile + Kalt-Diff.** Fassung 3 schreibt In/Out-Paare
    (ergebnis_mappe.hpp:157-165/:217-226); KEIN Kalt-/Diff-Feld irgendwo (0 Treffer); der Kalt-Rohwert
    wird an der einzigen Entstehungsstelle VERWORFEN (`(void)timed_op()`,
    tier_observe_trace_abi.hpp:137). Roh-Ebene In+Out bleibt (andere Granularitaet), nur die AUSGABE
    aggregiert — der Aggregator existiert nirgends (KON92-C1/C2).
D6  **Live-Pfad = Gegenteil von Arena-first.** ergebnis_mappe_naht persistiert synchron aus der
    Mess-Schleife; Zwei-Phasen-Werte per vector-push_back IM Messfenster
    (tier_observe_trace_abi.hpp:60-68). Drain-Schleife Arena->Blaetter existiert nicht; Arena und
    Writer kennen einander nicht (KON92-C4/C5).
D7  **Hard-Abort statt Folgeblatt + Arena bricht nie ab.** kXlsxZeilenlimit-Wurf
    (ergebnis_mappe.hpp:340/:374-376) ist per Z10-P2 SYSTEMFREMD; die gebaute Arena zaehlt Ueberlauf
    und misst weiter (mess_arena.hpp:36-38/:213/:266) — beides gegen die KON93-02-Politik (6GB fest,
    Abbruch NUR bei Arena-voll) zu heilen (stiller Datenverlust).
D8  **Arena-Zeile zu schmal fuer den Join.** MessCheckpointZeile = 32-Byte-POD mit EINEM Messwert +
    deskriptor_ix (mess_arena.hpp:60-100; Deskriptor-Tabelle traegt "Ziel, Ebene, Achse", :89) —
    strukturell das perfekte mi-Rohmaterial, aber zu schmal fuer die Union-Zeile + Kalt-Diff
    (KON92-C8; E1-Entwurf).
D9  **measurement_sink unbedingt statt gefiltert.** iterator:3089-3093 sendet jede result.csv
    ungefiltert; SOLL = Ziel-3-Filter (nur Zusammenfassung+Angefordertes) + per-Binary-xlsx
    (KON32-01, uebergangsweise (a) toleriert; Behebung = Task #18) — die EINZIGE echte
    Entscheid-Verletzung im Code, owner-bekannt.
D10 **PMC-Abwesenheit heute honest-0 statt kein-Eintrag.** `branch_misses` ohne
    `*_source_available`-Flag, immer emittiert (linux_perf_pmc_source.hpp:220-231,
    iterator:868-871); `pmc_available`-Spalte existiert — mindestens eine Randstelle gegen die
    Z8-Analogie; Klaerung haengt an O1.
D11 **"Achsen-Erfolgs-Parameter" hat keine benannte Heimat.** Einzige Code-Naehe = kV3AxisSchema +
    seg_<A>_ns (Rekonstruktion); measurement_axis_registry.hpp (16 MeasurementCategory) ist eine
    ANDERE Achsen-Familie (Hardware-Zaehlerkategorien), unverdrahtet ("Konsumenten = Folge-Increment").
    Drei getrennte Registries organ/system/measurement belegt (experiment_plan_director.hpp:445,463).
D12 **Doku-Deltas.** KON87 Par. 3.1/"NICHT OFFEN"-Vermerk ("Spaltenmenge = lazy_csv_header, 189") ist
    durch KON91-01 sachlich ueberholt, traegt aber keinen Ueberholt-Marker (anders als die
    Sheet-EBNF); Spaltenzahlen 189/~150 stale; dreifache full-join-Ueberladung nirgends abgegrenzt
    (Codesuche "FullJoin" -> nur permutation_engine.hpp:244-253 / pruefling_merge / validate_profile /
    merge_plan = Bedeutung A).

---

## 4. ABGLEICH: KON91-VOLLBILD und ARENA-POSTEN E1-E10 — WO SIE INEINANDERGREIFEN

### 4.1 Gegen das KON91-Vollbild (Ledger:109-131 + KON88/KON89)

| Vollbild-Element | Verhaeltnis zum Full Join |
|---|---|
| Baum-Ordnung (artifacts ODER binaries+measurement getrennt=Default; w/ma/mi-Baum neben der Binary) | Der Baum liefert die ORTE (Ebene x Feinkategorie); der Full Join liefert je Ort das SPALTEN-Schema. Ebene steht im PFAD, nie mehr im Sheet-Namen (D3). |
| EIN Sheet je Unter-Achse, je Ebene, Verfuegbarkeits-Tor | SHEET-REGEL = Abwesenheits-Regel (a); die 4 KON87-Tore (inkl. iw/ima/imi) sind ihre Kodifizierung. Sheet-Wahl ist Sache des Drains (E6), Spalten-Wahl Sache des Joins. |
| Sequentiell abgetrennte Tabellen je Laufzeit-Permutation im Sheet | ZWEITE Sequenzialitaet neben den Folge-Blaettern (E5) — Tabellen = Permutations-Schnitt, Folge-Blaetter = Limit-Fortsetzung. NICHT vermengen. Jede Tabelle traegt DASSELBE Ebenen-Schema des Joins. CSV-Factory (KON89-D3): Ordner je Sheet, CSV je Unter-Achsen-Fahrt = genau diese Tabellen — konsumiert dieselbe Spaltenfunktion. |
| KALT-DIFF-Felder (Z10-P2) | Bestandteil der Union: je Messwert-Spalte ein Diff-Traeger im Feld der warmen Zeile. Heute 0 Felder, Kaltwert verworfen (D5) — der Join definiert die Feldform mit (E3). |
| PMC compound-Dimension (Z10-P3) + Sondergrammatik (Z8) | PMC-Parameter = Spalten ab ma; PMC-Achsen-EINTRAG folgt kein-Eintrag-Grammatik; Zell-Ebene offen (O1/D10). |

### 4.2 Gegen die Arena-Bau-Posten E1-E10 (KON92; arena_kette_karte.md, Abschnitt E)

Der Verzahnungs-Kern: **Arena = mi-granulare Quelle, Full Join = Ziel-Schema, E4+E6 = die Bruecke.**

- **E1 (Zeilenformat-Entwurf)**: Die Union-BREITE entscheidet das Format — schmales 32-Byte-Paar
  behalten (dann pivotiert der Aggregator per deskriptor_ix->Spalte) ODER zweites, breites Arena-Paar
  (dann liegt die Join-Form schon in der Arena). Die Deskriptor-Tabelle ("Ziel, Ebene, Achse") ist in
  beiden Faellen der natuerliche mi-Schluessel des Joins. E1s Owner-Teilfrage (RAM-Politik) ist durch
  Z12/KON93-02 ENTSCHIEDEN: 6GB fest, statisch, Planer-Reservierung — E1 reduziert sich auf die
  Formatfrage, und die haengt direkt an FJ-1 (Spaltenfunktion zuerst).
- **E2 (Kaltwert verbuchen) + E3 (Kalt-Diff-Schema)**: liefern die Kalt-Diff-MITGLIEDER der Union.
  Ohne FJ-1 hat E3 kein Ziel-Schema; ohne E2 hat der Join keine Kalt-Eingaben.
- **E4 (Aggregator Roh->Sheet-Zeile)**: **DER Ort, an dem der Full Join mechanisch stattfindet** —
  viele schmale (Achse,Wert)-Checkpoint-Zeilen (In/Out-Rohebene bleibt) werden zu EINER breiten
  ma-Zeile ueber das Union-Schema pivotiert; mi-Sheets erhalten die restriktive Projektion E(A).
- **E5 (Folgeblatt statt Wurf)**: Limit-Sequenzialitaet; Namensform unter der KON88-P1-Ordnung neu
  herleiten; unabhaengig von der Spaltenmenge, aber Teil desselben Drain-Vertrags.
- **E6 (Drain-Schleife = S-13/#18-KERNSTUECK)**: konsumiert Aggregat-Zeilen und verteilt sie nach
  SHEET-REGEL (Unter-Achse x Ebene x Verfuegbarkeits-Tore) in Sheets/Tabellen/Folge-Blaetter bis die
  Arena leer ist. Der Drain BRAUCHT die Spaltenfunktion je Ebene als Vor-Vertrag; er heilt zusammen
  mit Export-Element+Ziel-Filter den measurement_sink-Kanal (KON32-01/D9).
- **E7 (Zwei-Phasen an die Arena)**: ersetzt push_back-im-Messfenster durch Arena-Ablage — erst damit
  fliessen Warm+Kalt ueberhaupt durch den Join-Weg (verbindet die zwei Welten von D6).
- **E8 (PAAR-Muster)**: bestimmt, WELCHE Werte je Wiederholung in die Arena gelangen (Lauf1 verwerfen,
  Lauf2 speichern) — Eingabe-Disziplin des Joins, kein Schema-Posten.
- **E9 (measure_storage produktiv)**: CMake+Verdrahtung; die statische Deskriptor-Tabelle wird dabei
  zur natuerlichen REGISTRIERUNGS-Stelle der Achsen-Erfolgs-Parameter (Abgleich mit kV3AxisSchema und
  der getrennten measurement_axis_registry — Familien nicht vermengen, D11).
- **E10 (Stale-Texte)**: um D12 erweitern (KON87-Par.-3.1-Marker, Spaltenzahl, full-join-Abgrenzung).

---

## 5. BAU-IMPLIKATIONEN S-13/#18-BUENDEL (Landung Di 25.08., W2, Buendel mit #48/#57; #18 = S-13
Export-Element F10-Design Option b + Drei-Ziele-Struktur, Ledger:6610/6115; #55 xlsx-Aufmachung im
S-13-Vorlauf; S-13 = Export/Lager-Daten-Weg, Ledger:4024)

FJ-1  **Spaltenfunktions-Vertrag ZUERST** (Entwurfs-Vorstufe mit E1): parametrisierte Single-Source
      `spalten(ebene [, achse])` — mi(A)=E(A) restriktiv; ma/w = Union (+op_*, +PMC, +Kalt-Diff-
      Traeger); loest lazy_csv_header als EINZIGE Quelle ab bzw. erweitert sie; jede alte
      Aufrufstelle bekommt erst eine LAUTE Compile-Zeit-Meldung, dann den Umbau (Haus-Regel).
      Blockiert E3/E4/E6 — deshalb erster Posten.
FJ-2  **E(A) registrieren**: kV3AxisSchema + seg_<A>_ns als explizite Achsen-Erfolgs-Parameter-
      Registrierung ausbauen (Owner-Ein-Satz-Vorlage O2 vorab); measurement_axis_registry als andere
      Familie abgrenzen, nicht einschmelzen (D11).
FJ-3  **E4-Aggregator baut den Join mechanisch**: Pivot Roh-Arena-Zeilen (deskriptor_ix -> Spalte)
      -> EINE Ausgabe-Zeile im FJ-1-Schema; In/Out-Rohebene unangetastet; OE-3-Blockade pruefen.
FJ-4  **Kalt-Diff in die Union** (E2+E3): Kaltwert einfangen statt `(void)`, Feldform (Warm+Diff im
      Feld, Z10-P2) im Entwurf festlegen; keine feste Spaltenzahl mehr annehmen (D12).
FJ-5  **E6-Drain + SheetSchluessel variabel**: konstante Naht (D2) auf SHEET-REGEL umstellen
      (Unter-Achse x Ebene, 4 Tore), sequentiell abgetrennte Tabellen je Laufzeit-Permutation,
      Folge-Blaetter (E5) — Arena-first, xlsx nachgelagert (D6/D7 heilen).
FJ-6  **#18-Kern Export-/Ziel-Filter**: Ziel 3 nur Zusammenfassung+Angefordertes, per-Binary-xlsx
      statt result.csv (KON32-01/D9); der Drain speist den Export — das FJ-1-Schema definiert, was
      "vollstaendig je Blatt" heisst; 376333-Ebene-C-Leak-Versiegelung faellt hierher (Ledger:1761).
FJ-7  **Arena-Bemessung gegen Union-Breite**: KON93-02 (6GB, Planer-Reservierung) x Zeilenformat aus
      E1xFJ-1 -> planner mengen_rechnen/zeilen_je_op nachziehen (drift_faktor <=18); Ueberlauf-
      Weitermessen zu hartem Abbruch-bei-voll heilen (D7).
FJ-8  **Baum+Namen bauen**: w/ma/mi-Ordner-Baum neben der Binary (heute 0 Treffer), C_/M_/X_-Praefixe
      abloesen (D3), CSV-Factory-Ordnerbaum (KON89-D3) aus derselben Spaltenfunktion.
FJ-9  **PMC-Randstellen an O1 koppeln**: branch_misses-honest-0 / pmc_available im selben Buendel
      heilen oder mit Owner-Wort ausbuchen (LUECKE=PFLICHT, D10).
FJ-10 **Doku-Pflege (mit E10)**: Ueberholt-Marker an KON87 Par. 3.1; drei full-join-Bedeutungen im
      Plan-Text abgrenzen; Spaltenzahl neu zaehlen und als dynamisch deklarieren — deprecaten, nie
      loeschen.

Reihenfolge-Logik: FJ-1/FJ-2 (Vertraege) -> FJ-3/FJ-4 (Join+Felder) -> FJ-5/FJ-6 (Drain+Export) ->
FJ-7/FJ-8 flankierend -> FJ-9/FJ-10 abschliessend. E1-Formatentscheid gehoert in die FJ-1-Entwurfs-
Vorstufe (wf-arena-Kern), nicht ans Ende.

## 6. OFFENE FRAGEN (kein Explore kann sie aufloesen — Nichtfund doppelt gegengeprobt; je mit Empfehlung als Ein-Satz-Vorlage)

O1  **Zell-/Spalten-Abwesenheit im Union-Schema**: Was traegt eine ma/w-Zelle, deren Quell-Achse an
    dieser Zeile nicht beteiligt war (und PMC-Spalten ohne PMC-Hardware) — Spalte weglassen, leer,
    oder markierter Leerwert? Belegt sind nur Sheet-Ebene (kein Sheet) und PMC-ACHSEN-EINTRAG
    (Sondergrammatik, Z8); der Owner liess genau diesen Kern mit "nochmal explore ueber 10 Wochen"
    offen, und der Explore ist erschoepft. EMPFEHLUNG: Schema stabil (Spalten bleiben), Abwesenheit
    als expliziter Leer-/Flag-Eintrag statt honest-0; PMC-Achsen-Eintrag folgt der belegten
    Sondergrammatik.
O2  **Begriffsumfang "Achsen-Erfolgs-Parameter"**: identisch mit
    `{seg_<A>_ns} UNION {stat_<A>_<f>: kV3AxisSchema[A]!=nullptr}` oder neuer Begriff? Keine Quelle
    definiert ihn. EMPFEHLUNG: JA zur kV3AxisSchema-Deckung, als explizite Registrierung ausbauen
    (FJ-2).
O3  **Reichweite der Union**: global-uniformes Schema fuer alle ma/w-Sheets ("ALLE moeglichen
    Parameter") ODER je Messung auf verfuegbare Achsen beschraenkt ("die verfuegbaren CSV Spalten",
    Z7)? EMPFEHLUNG: global-uniformes Schema; Verfuegbarkeit regelt Sheets (Regel a) und Werte (O1),
    nie das Schema.

Aufgeloest (NICHT offen, mit Beleg): w-Einschluss der Union (Wortlaut+Baumordnung, Abschn. 2) ·
Traegerfrage Arena-Pivot vs. Flat-Nachbearbeitung (Arena-first-Doktrin Z10-P2 -> Join lebt im
E4-Aggregator; Restentscheid = E1-Formatfrage als Bau-Entwurf) · i{w|ma|mi|pmc}-Verknuepfung
(= eines der 4 KON87-Tore der Blatt-Existenz) · P1-Bestaetigung ("Ansonsten alles korrekt
verstanden", Z11) · RAM-Politik der Arena (Z12/KON93-02).

---

**Primaerquellen**: Transkripte `5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl`
(:13579 :17190 :55065 :55213 :55259 :58708 :59056 :59132) · `46375cdc-821a-4bf9-93d4-fe0a5687f489.jsonl`
(:44041 :66950 :79417) · super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
(:44-131 KON91/92/93, :192-257 KON87/88, :1762-1900 KON64/65, :6103-6125 KON32-01, :6319-6320,
:6610 Task-Tabelle, :20838, :28514-28547, :28632-28707) ·
`docs/sessions/backups/20260816-folge-bu-kontext8/{kon64_sammlung.md:1411-1471,
design_sheet_hierarchie_v3.md, arena_kette_karte.md}` ·
`docs/plaene/{20260813-DESIGN-g1-grammatik...md Par.12-13, 20260816-DESIGN-pmc-schwester...md}` ·
ce `libs/cache_engine/{builder/experiment_tree/cache_engine_builder_iterator.hpp:555-703,3089-3093;
anatomy/observable_tier.hpp:68-99; builder/lager_ablage/ergebnis_mappe.hpp;
profile_facade/ergebnis_mappe_naht.hpp; builder/measure_storage/mess_arena.hpp:60-100;
builder/anatomy_commands/tier_observe_trace_abi.hpp; include/cache_engine/measurement/
measurement_axis_registry.hpp; src/permutations/permutation_engine.hpp:244-253}`.
