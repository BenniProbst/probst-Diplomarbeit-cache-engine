# ARENA-6GB — KONSOLIDIERTE KARTE (KON93-02): KAPAZITAET, RESERVIERUNG, SCHICHTUNG, BAU

Synthese (Fable 5 max) der zwei 10-Wochen-Kartierungen zum Owner-Auftrag KON93-02
("Herkunft/Bemessung der 6GB + Planer-Reservierungs-Mechanik + drift_faktor-Bezug").
Schnitt 1 = Rohtranskripte (36 jsonl, 3-Wege-Extraktor, Falsch-Null-Gegenproben);
Schnitt 2 = Plaene/Ledger/Code (alles am Objekt gelesen). Diese Karte hat zusaetzlich
vier Anker SELBST nachgelesen: Ledger:19-108 (KON93/KON92), Ledger:3800-3958 (KON51/52),
kon64_sammlung.md:1388-1430 (TEIL 35), experiment_schema.xsd:340-383, arena_kette_karte.md
komplett. Zitate ASCII-transliteriert, Wortlaut unveraendert.
Wurzeln: super = /home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine ·
ce = super/Code/external/comdare-cache-engine · Ledger = super docs/DIPLOMARBEIT-ZIELE-
OFFENE-PUNKTE-LEDGER.md · Transkript = ~/.claude/projects/-home-comdare/5a19728e-*.jsonl.

---

## 1. OWNER-ZITATE CHRONOLOGISCH (7 Stationen)

1. **09.08. 10:48Z — Genesis (keine Zahl):** "... latenzarm ... in einen moeglichst grossen
   Vor-Reservierten custom Speicherbereich per append gepusht ... weil neue Allokationen
   fuer die Messwert-Aggregation verboten sind weil sie das Bild der Messungen verzerren."
   [Transkript:23366; deep-research.md:3-6]
2. **09.08. 11:39Z — Zwei-Arenen-Namensgebung:** "... Mess-Arena und Stack-Arena custom"
   (append-only Mess-Arena, Auswertung zum Schluss; LIFO-Stack fuer Mess-Ebenen).
   [Transkript:23617; deep-research.md:20-23]
3. **09.08. 18:21Z — Variadik-Blocker** (Bau-Defekt der init-Kaskade, KEINE Kapazitaets-
   aussage). [Transkript:28251]
4. **12.08. 18:08Z — KON51: ERSTE Nennung der 6, als WARNSCHWELLE, CEB-seitig:**
   "... die Tier-Binary/Hybrid haben jeweils ihre eigenen bei Anforderung eingebauten
   Mess-Arenen fuer checkpoint-measure, die nur zu definierten Hol-Punkten in die CEB in
   die RAM Arena von dieser geflusht werden ... (**warnung an den Planer wenn die CEB mehr
   als 6GB RAM Messdaten haelt**)." [Transkript:47246; Ledger:3869-3890, kodifiziert :3925]
5. **12.08. 18:17Z — KON52 (V-F1/V-F2): Default UNBEGRENZT, OOB nur Opt-in:** "Wenn der
   RAM endet, dann geht das Programm sowieso in den OOM ..."; "In der XML soll es
   zusaetzlich moeglich sein einen RAM OOB zu konfigurieren, der hart ist (kein default)"
   -> Planer sendet CEB den Stopp-Befehl, Fehler auf der Kommandozeile; "V-F2: Default
   wie gesagt rein informativ, Grenze der Warnung und des OOB separat in der XML
   einstellbar, standard ist nur delayed Warnung und keine Begrenzung."
   [Transkript:47280; Ledger:3810-3866; formalisiert: ram_warn_grenze Default 6 GB hart
   einkompiliert + ram_oob_grenze ohne Default, Ledger:3843-3857]
6. **16.08. 11:47Z — P2: Endlichkeit + einziger legitimer harter Tod:** "Harter Abbruch
   ist nicht Moeglich und auch keine Option, weil alle Messwerte ja zuerst (geplant und
   dokumentiert, bitte explore ueber 10 Wochen ...) in Arenen abgelegt werden, bevor die
   xlsx Persistierung folgt. Wenn ein Blatt nicht reicht, muss eben ein weiteres eroeffnet
   werden ... **Der harte Abbruch kann also nur am RAM Limit sterben, wenn die Mess-Arena
   voll ist.**" [Transkript:59056 (typed); kon64_sammlung.md:1411-1422]
   DATIERUNG VERBINDLICH 16.08.: TEIL-35-Ueberschrift der Sammlung selbst sagt
   "OWNER 16.08." (kon64_sammlung.md:1388-1389) + Rohtranskript-Zeitstempel. Die
   12.08.-Datierung der Plaene/Code-Kartierung war ein Lesefehler (s. Abschnitt 8).
7. **16.08. 12:27Z — KON93-02: DIE ENTSCHEIDUNG (C6):** "**Die Kapazitaet wird auf 6GB
   festgesetzt (bitte explore ueber 10 Wochen) und ist statisch, sie kann zu Beginn eines
   Experimentes fuer die Reservierung auf dem Planer veraendert werden.**"
   [Transkript:59238, queued_command origin human, mit rueckgeschriebener C6-Frage
   (Optionen a/b, drift_faktor, S-19); Ledger:44-62, Commit 96c77b03 — Buchung am Objekt
   verifiziert]

KERNVERSCHIEBUNG 12.08. -> 16.08.: dieselbe Zahl 6 wandert von "Warnschwelle, Wachstum
unbegrenzt, rein informativ" (KON51/52) zu "Kapazitaet, statisch, Default, planer-
reservierbar" (KON93). Die Ledger-Einordnung formuliert "hebt sie von Warnung auf
KAPAZITAET" (Ledger:53-55) — praezise gelesen ist es KEINE Abloesung, sondern eine
SCHICHTUNG an zwei verschiedenen Speichern (s. Abschnitt 2).

## 2. DIE ENTSCHIEDENE MECHANIK + DREI-SCHICHTEN-MODELL

**Entschieden (KON93-02, schliesst KON92-C6 mit Variante a):**
- Mess-Arena-Kapazitaet = **6GB DEFAULT, FEST** (kein dynamisches Wachsen bis RAM-Ende;
  Variante b ist tot).
- **STATISCH ZUR LAUFZEIT**: waehrend des Experiments unveraenderlich. Der gebaute
  Mechanismus deckt das strukturell bereits: EIN mmap je Arena, seitengerundet, kein
  Remap-/Ring-/Wachstumspfad existiert (mess_speicher_kanon.hpp:100-137) — hier ist
  NICHTS umzubauen (Bestands-Pflicht).
- **EIN Freiheitsgrad**: die Reservierungs-Groesse, gesetzt **am PLANER zu EXPERIMENT-
  BEGINN** (XML-/Planer-Hebel, Abschnitt 6). Kein Laufzeit-Hebel, kein CEB-/Tier-Hebel.
- **Ueberlauf-Politik = fest+Abbruch** (P2-Wort): der harte Abbruch existiert GENAU EINMAL
  — wenn die Mess-Arena voll ist. Beide Gegenstuecke sind damit Fehler: der xlsx-
  Zeilenlimit-Wurf (systemfremd, KON88 -> Folgeblatt, Posten E5) UND das gebaute
  "Ueberlauf zaehlen+melden+WEITERMESSEN" (stiller Datenverlust, zu heilen, Delta-1).
  Owner-gedeckt dreifach: P2-Wort + unwidersprochene C6-Frage-Rahmung ("wird geheilt")
  + KON92-Wortlaut "in beiden Lesarten zu heilen" (Ledger:107-108).
- **Abbruch-Semantik nach Bestands-Doktrin** (keine neue Owner-Frage): harter Stopp
  schreibt failed OHNE Retry, der Lauf faehrt mit dem naechsten Experiment der main.xml-
  Sequenz fort ("sichtbar, nie still; der Lauf misst weiter" — deklarierte Ableitung
  KON52-02, Ledger:3859-3864, auf Arena-voll uebertragbar); bereits gemessene Arena-
  Inhalte werden regulaer persistiert (Messdaten-nie-loeschen-Doktrin).

**Die drei Schichten (von weich nach hart), an ZWEI verschiedenen Speichern:**

| Schicht | Regel | Speicher | Verhalten | Quelle |
|---|---|---|---|---|
| 1 Warnschwelle | KON51/52: `ram_warn_grenze`, Default 6 GB, XML-ueberschreibbar | CEB-RAM-Aggregat ueber alle Hol-Punkt-Flushes eines Experiments | delayed-informativ (queued bis Experiment-Break; nur das Fertig-Signal ist OOB) | Ledger:3843-3845, :3925 |
| 2 OOB-Opt-in | KON52: `ram_oob_grenze`, KEIN Default | CEB-RAM-Aggregat | hart, nur wenn konfiguriert: Warnung geht direkt durch -> Planer sendet CEB Stopp -> CLI-Fehler -> failed ohne Retry | Ledger:3837-3845, :3859-3864 |
| 3 Kapazitaet | KON93: 6GB Default, statisch, Planer-Reservierung zu Experiment-Beginn | Mess-Arena JE MESS-PROZESS (Tier/Hybrid, checkpoint_measure) | physische Grenze: voll -> harter Abbruch (einziger legitimer harter Tod) | Ledger:44-62 |

**Konsistenz-Aufloesung (Merge statt Verdraengung):** Laese man KON93 als ABLOESUNG der
KON51-Warnung am SELBEN Speicher, wuerde die Warnung sinnlos: an einem 6GB-gedeckelten
Objekt ist ">6GB haelt" unerreichbar, der ganze KON52-Zweck (Nachbetrachtungs-Indikator
"Experiment moeglicherweise zu gross angelegt") stuerbe. Konsistent ist NUR die
Schichtung: die Kapazitaet gilt der gebauten MessArena je Mess-Prozess (Gegenstand der
C6-Frage war "die gebaute Arena" = mess_arena.hpp; Bestand rechnet ausdruecklich je
Mess-Prozess: --max-bytes = "Deckel der Arena EINES Mess-Prozesses", main.cpp:534 /
A19-A20), die Warnschwelle gilt dem CEB-Aggregat, das ueber MEHRERE Flushes und
zusammengesetzte Experimente hinaus waechst und deshalb >6GB erreichen kann. Die
CEB-RAM-Arena selbst (B1-Kette, 0% Code) wird bei ihrem Bau eigens bemessen (planer-
bemessen, Summe erwarteter Flushes) und NICHT automatisch mit dem 6GB-Default gedeckelt.
KENNZEICHNUNG: Inferenz aus den Owner-Wortlauten (die KON51-Warnung muss erreichbar
bleiben), kein eigenes Owner-Wort — beim B1-Bau am Bestand zu verifizieren, analog der
KON51-02-Klausel "per Explore beim Bau — KEINE Owner-Frage" (Ledger:3920-3922).

## 3. CODE-IST vs. SOLL — DELTA-LISTE (7 Deltas + 1 gedeckter Punkt)

- **Delta-1 [KERN-HEILUNG] Ueberlauf-Politik:** IST "ZAEHLEN, MELDEN, WEITERMESSEN", nie
  Abbruch (mess_arena.hpp:36-38 Kommentar, kUeberlaufSlot :213, anhaengen() :263-269
  liefert bei voll kUeberlaufSlot und misst weiter) = STILLER DATENVERLUST: alle
  Messwerte nach voll landen nirgends, das Experiment gilt weiter als messend. SOLL:
  fest+Abbruch NUR bei Arena-voll (P2/KON93); Heilung = Abbruchpfad nach failed-Doktrin
  (Abschnitt 2), Arena-Bestand wird persistiert, der Ueberlaufzaehler darf als Diagnose
  bleiben, aber nie wieder "weitermessen" bedeuten. Spiegelposten: der xlsx-seitige
  Hard-Abort faellt umgekehrt WEG (E5 Folgeblatt) — beide Haelften zusammen ergeben
  exakt P2.
- **Delta-2 6GB-Default fehlt:** IST kein numerisches 6GB-Literal im gesamten ce-Baum
  (verifizierter Nichtfund: 6442450944/6'442'450'944/6e9/6000000000/"GB" in
  measure_storage/planner/apps = 0 Treffer); Kapazitaet kommt ausschliesslich als
  MessMasse.kapazitaet_zeilen vom heute toten Aufrufer. SOLL: hart einkompilierter
  Planer-Default (KON42-Muster, wortgleich fuer ram_warn_grenze dokumentiert,
  Ledger:3849-3852), XML-ueberschreibbar.
- **Delta-3 Bytes->Zeilen-Umrechnung fehlt:** IST rein zeilenbasiert (Zeile = 32 B,
  bytes = zeilen x 32 intern, mess_arena.hpp:227-253); kein Bytes-Eingang. SOLL: der
  Owner spricht Bytes ("6GB") -> Planer rechnet Bytes/32, seitengerundet auf 4096
  (mmap-Kanon). GiB-vs-GB-Festlegung s. Abschnitt 7.
- **Delta-4 Planer->Arena-Verdrahtung fehlt:** IST checkpoint_measure::init() hat 0
  Produktionsaufrufer (vierfach belegt, A18), und check-size --max-bytes ist eine
  beratende SACKGASSE: deckel_bytes speist nur das Deckelurteil-Reporting, fliesst
  nirgends in MessMasse (main.cpp:528-536/:678-720). SOLL: die Reservierung wirkt zu
  Experiment-Beginn real; EIN Wert speist BEIDE Verbraucher (echte Reservierung UND
  S-19-/check-size-Vorschau) — geteilte Zaehlwerke aus EINER Quelle
  (Harmonisierungs-Doktrin).
- **Delta-5 XML-Hebel fehlt:** IST 0 Code-Treffer fuer ram_warn_grenze/ram_oob_grenze,
  kein Kapazitaets-/Reservierungs-Attribut in XSD oder Parser. SOLL: Attribut-Familie
  im Mess-/Experiment-Kontext (KON52-02-Ort + neuer KON93-Hebel, Vorschlag Abschnitt 6).
- **Delta-6 Warn-/OOB-Schichten fehlen komplett:** IST 0 Code fuer Schicht 1+2 (auch der
  Kanal, der die delayed Warnung truege, ist S-10-Bauland). SOLL: Drei-Schichten-Modell
  Abschnitt 2. (Eigenstaendige Baustelle S-10/S-13; hier nur als Schichtungs-Kontext.)
- **Delta-7 Stale-/Widerspruchstexte:** IST Kommentar "Sicherheitsfaktor 2"
  (mess_arena.hpp:222-226, Ursprung deep-research.md:186) vs. verdrahteter drift_faktor
  bis 18 (checkpoint_speicher.hpp:121, planner_mengen_types.hpp:193-201/:321-322);
  planner_mengen_types waehlt explizit keine Seite und druckt beide (:27-29, :506-508);
  dazu wird der Ueberlauf-Kommentar :36-38 durch Delta-1 inhaltlich falsch. SOLL:
  deprecaten/berichtigen, nie loeschen (E10; C7/D6 der KON92-Karte).
- **[GEDECKT, kein Delta] "statisch":** einmaliges mmap ohne Remap/Ring erfuellt die
  Owner-Eigenschaft bereits strukturell — kein Umbau, nur nicht kaputtmachen.

## 4. EINORDNUNG IN DIE BAU-POSTEN E1-E10 (KON92) — E11 IST NOETIG

Befund am Wortlaut der Postenliste (arena_kette_karte.md:112-125):
- **E1 wird VERSCHLANKT:** E1 trug ZWEI Haelften — (i) Arena-Zeilenformat entscheiden
  (C8, ~150-Spalten-Frage) und (ii) "RAM-Politik-Vorlage an Owner: fest+zaehlen vs.
  fest+Abbruch vs. wachsend-bis-RAM (C6)". Haelfte (ii) ist durch KON93-02 ENTSCHIEDEN
  (fest+Abbruch, 6GB, Planer-Reservierung) — aus E1 zu streichen. E1 behaelt nur noch
  das Zeilenformat (bleibt Kern von wf-arena).
- **Kein bestehender Posten traegt den Kapazitaets-BAU:** E2-E8 sind Kalt-Diff/Ausgabe/
  Folgeblatt/Drain/Anschluss-Posten; E9 = CMake+Verdrahtung in die Mess-Schleife+
  Threading; E10 = Stale-Texte. Weder 6GB-Default noch Bytes->Zeilen noch Ueberlauf-
  Politik-Umbau noch XML-Hebel/Planer-Durchreichung kommen in E2-E10 vor. Die
  KON93-Zeile "BAU: geht in die Arena-Posten E1-E10" (Ledger:58-59) ist damit zu
  praezisieren: die ENTSCHEIDUNG landet in E1 (und schliesst dessen Haelfte ii), der
  VOLLZUG hat noch keinen Traeger.
- **=> E11 [NEU] "KON93-Kapazitaets-Vollzug"** (ein kohaerenter Posten, traegt
  Delta-1..Delta-5):
  1. Ueberlauf-Politik fest+Abbruch in MessArena (kUeberlaufSlot-Weitermessen ->
     Abbruchpfad nach failed-Doktrin; Arena-Bestand persistieren);
  2. einkompilierter 6GB-Planer-Default (EINE benannte Konstante);
  3. Bytes->Zeilen-Umrechnung (/32, seitengerundet);
  4. XML-Hebel `<mess_speicher>` (Abschnitt 6) inkl. der KON52-Attribute
     ram_warn_grenze/ram_oob_grenze als EINE Familie;
  5. Durchreichung Planer -> MessMasse.kapazitaet_zeilen + Vereinheitlichung mit
     check-size (deckel_bytes = derselbe Wert, Sackgasse aufloesen).
  ABHAENGIGKEITEN: E11.1-3 VOR E9 (die produktive Verdrahtung soll nie mit der falschen
  Ueberlauf-Politik landen); E11.4 liegt auf der S-13/B1-XSD-Familie (KON52-02,
  Ledger:3856-3857); E10 uebernimmt die Kommentar-Bereinigung aus Delta-7. E11 haengt
  NICHT an E1: das Zeilenformat aendert die Zeilen-BREITE, nicht die Kapazitaets-
  Mechanik (Bytes->Zeilen nimmt die Breite als Parameter, heute 32).

## 5. S-19-BEZUG: VORAUSBERECHENBARKEIT DER RESERVIERUNG

- **Formel-Bestand (seit 09.08., also VOR der ersten 6GB-Nennung gebaut):**
  kapazitaet_zeilen_rechnen(n_ops, zeilen_je_op, drift_faktor) ueberlaufgesichert
  (checkpoint_speicher.hpp:131-138; planner_mengen_types.hpp, Safe-Multiply);
  drift_faktor_rechnen(reps, max_reruns) = reps x (max_reruns+1), produktive Vorgaben
  3/5 => bis 18 (worst case: das Drift-Gate misst dieselbe Zelle bis zu 18x in dieselbe
  monoton wachsende Arena); Bemessung je MESS-PROZESS ueber die groesste Kombination
  (ODER ueber aktive Ebenen, profile_run_facade.cpp:1514-1517).
- **Rollenklaerung unter KON93:** Die Formel BEMISST die Arena nicht mehr (das tut der
  6GB-Default bzw. der Planer-Hebel), sie wird zur BEDARFS-/PRUEFGROESSE: S-19 kennt
  zur Planungszeit alle drei Faktoren (n_ops aus run_options/cap, zeilen_je_op aus den
  aktiven Mess-Ebenen/Schalter-Belegung, drift_faktor aus drift_gate) und rechnet den
  Worst-Case-Bedarf DETERMINISTISCH VORAUS -> Abgleich gegen die Reservierung mit dem
  bestehenden Deckelurteil {Haelt, Gerissen, Unbestimmbar} VOR dem Messstart
  (fail-closed bei zeilen_je_op==0 existiert). Damit wird der Laufzeit-Abbruch bei
  Arena-voll zum RESTSCHUTZ einer Invariante, die bei korrekter Vorausberechnung nie
  reisst — genau die C6-Empfehlung "(a) ... ueber den drift_faktor, deterministisch und
  von S-19 vorausberechenbar", die der Owner mit Struktur (a) beantwortet hat. (Dass
  seine Antwort drift_faktor/S-19 nicht woertlich wiederholt, ist unschaedlich: die
  Mechanik ist Bestand, die Antwort setzt Default-Zahl + Statik + Hebel-Ort obendrauf.)
- **Zahlenwerk (Skalen-Probe):** 1 Zeile = 32 B. Golden-Zelle 2^17 Ops x 40 Zeilen/Op
  = 160 MiB je Durchlauf; x18 (drift worst case) = 3,02 GB. 6GB-Default deckt damit
  die golden Worst-Case-Zelle mit ~2x Luft — die Reservierung ist fuer den Regelfall
  grosszuegig, der Hebel existiert fuer groessere Experimente.
- **Herkunft der Zahl 6 — dokumentarischer NICHTFUND, zwei unbelegte Kandidaten:**
  Keine Herleitung in Rohtranskripten, Plaenen, Ledger oder Code (beide Schnitte,
  Gegenproben gefahren; deep-research.md kennt keine 6GB). Kandidat A (rechnerisch
  frappierend, unbelegt): golden-Worst-Case x Ur-Sicherheitsfaktor 2 = 2^17 x 40 x 18
  x 2 x 32 B = 6,0398 GB dezimal (~0,7% neben glatt 6GB; enthielte elegant BEIDE
  C7-Faktoren 18 und 2). Kandidat B (unbelegt): 6GB = 10% von prod1-RAM 60GB
  (Ledger:18429 live-bestaetigt). KEIN Dokument stellt eine der Verbindungen her —
  beide sind als Rekonstruktion markiert, nichts davon ist Entscheidungsgrundlage.

## 6. XML-/PLANER-HEBEL — VORSCHLAG MIT ANKER IM BESTEHENDEN SCHEMA

**Vorschlag: EIN neues optionales Element im Mess-/Experiment-Kontext, Geschwister von
`<drift_gate>`/`<run_options>`:**

    <mess_speicher arena_reserve_bytes="6442450944"
                   ram_warn_bytes="6000000000"
                   ram_oob_bytes="8000000000"/>

  (alle drei Attribute xs:unsignedLong, optional; Abwesenheit = Code-Default:
   arena_reserve_bytes -> einkompilierte 6GB-Konstante · ram_warn_bytes -> 6-GB-Default
   KON52 · ram_oob_bytes -> aus/Opt-in. Beispielwerte illustrativ.)

**Anker und Begruendung, alles am Bestand:**
- **Muster-Anker `<drift_gate>`** (T-15-Familie): real wirksames Element mit typisierten
  Attributen, Defaults + `_declared`-Flags (xml_config_parser.cpp:357-365 ->
  TypedProfil-Feld xml_config_parser.hpp:285-288 -> ZWEI Verbraucher: echte Ausfuehrung
  profile_run_entry.hpp:963-969 + check-size-Vorschau profile_run_facade.cpp:1572-1597).
  Der neue Hebel folgt exakt diesem Muster — inklusive der Doppel-Speisung: derselbe
  Wert geht in die echte Reservierung UND in die S-19-Vorschau (heilt die
  --max-bytes-Sackgasse, Delta-4).
- **Orts-Anker KON52-02:** "S-13/B1-FAMILIE (XSD): zwei separate Attribute im Mess-/
  Experiment-Kontext (ram_warn_grenze ... ram_oob_grenze ...)" (Ledger:3856-3857). Der
  KON93-Hebel ist das dritte Mitglied derselben Familie; EIN Element haelt die drei
  Schichten an einem Ort und macht die Schichtung lesbar. (Attributnamen hier in
  Byte-Form vorgeschlagen, weil exakt; die KON52-Namen ram_warn_grenze/ram_oob_grenze
  sind gleichwertig moeglich — Bau-Festlegung, Abschnitt 7.)
- **Warum NICHT an `<run_options>` anbauen:** RunOptionsType (experiment_schema.xsd:
  364-370) traegt zwar schon n_ops/cap (zwei Bedarfs-Faktoren), ist aber laut eigenem
  XSD-Kommentar "Attribut-Satz ZEICHENGLEICH zum comdare_thesis_profile-Dialekt" mit
  ctest-Wache auf Gleichheit (:357-363) — ein Anbau risse die Wache oder erzwaenge
  einen Doppel-Bau im Schwester-Dialekt. Eigenes Element = sauberster Weg.
- **XSD-Doktrin beachten:** Die XSD fuehrt BEWUSST keine Schema-Defaults, Abwesenheits-
  Semantik lebt im Code (experiment_schema.xsd:348-349) — deckt sich exakt mit dem
  hart einkompilierten Planer-Default (KON42/KON52). Also: Attribute optional OHNE
  XSD-default-Angabe.
- **Mitzuheilende Bestandsluecke:** `<drift_gate>` ist in KEINER der beiden XSD-Dateien
  deklariert (0 Treffer, kein Wildcard; der Parser validiert nicht gegen die XSD) —
  Diskrepanz zwischen KON52-Doktrin (XSD als Ort) und gelebter Praxis. Beim Anlegen von
  `<mess_speicher>` in beiden XSDs wird `<drift_gate>` im selben Zug nachgezogen
  (Luecke-ist-Auftrag-Regel); gehoert zu E11.4.
- **Wirkungskette komplett:** XML -> Parser (TypedProfil) -> Planer rechnet Bytes/32
  seitengerundet -> MessMasse.kapazitaet_zeilen -> checkpoint_measure::init() VOR dem
  Messfenster (Reserve-vor-Fenster ist gebaut, :223-226) -> mmap fest -> Arena statisch.
  Parallel: derselbe Byte-Wert als Deckel in die S-19-/check-size-Rechnung.

## 7. BAU-FESTLEGUNGEN (ohne Owner-Bedarf) + OFFENE FRAGEN

**Bau-blockierende Owner-Fragen: NULL.**

Bau-Festlegungen, beim Bau zu treffen und zu dokumentieren (kein Owner-Wort noetig, da
Default ueberschreibbar bzw. Doktrin-gedeckt):
1. **GiB vs. GB fuer die Default-Konstante:** 6 GB dezimal = 187.500.000 Zeilen a 32 B;
   6 GiB = 201.326.592 Zeilen (~6,9% Differenz). Vorschlag: DEZIMAL 6.000.000.000 B
   (Owner-Sprachgebrauch "GB"; Kandidat-A-Arithmetik trifft dezimal). Der XML-Hebel
   nimmt ohnehin exakte Bytes — die Ambiguitaet existiert nur im Default.
2. **Attribut-Namen** (Byte-Suffix vs. KON52-Namen) und Element-Name `<mess_speicher>`
   (deckt alle drei Schichten; passt zur mess_speicher_kanon-Familie).
3. **Ort der Abbruch-Meldung:** ueber den KON50-Trace-/Status-Weg des Planers analog
   OOB-Stopp (Ledger:3858), failed ohne Retry.
4. **CEB-RAM-Arena-Bemessung beim B1-Bau** verifizieren (Schichtungs-Inferenz aus
   Abschnitt 2: nicht automatisch 6GB-gedeckelt) — explore-/bau-aufloesbar am Bestand.

**Offene Fragen (durch keinen Explore aufloesbar) — genau EINE, nachrangig:**
1. **Warum genau 6?** Dokumentarischer Nichtfund in beiden Schnitten (Korpus
   erschoepft: 36 Rohtranskripte, Plaene, Ledger, Code). Zwei markierte Rekonstruktions-
   Kandidaten in Abschnitt 5. NICHT bau-blockierend (die Zahl ist gesetzt und
   ueberschreibbar); nur falls die Thesis eine Herleitung des Defaults dokumentieren
   soll, waere es EIN Owner-Satz bei Gelegenheit.

## 8. KARTEN-ABGLEICH (Divergenzen der zwei Kartierungen, aufgeloest)

1. **P2-Datierung:** Plaene/Code-Karte schrieb "Owner 12.08." — WIDERLEGT durch die
   Quelle selbst (kon64_sammlung.md:1388-1389: "TEIL 35 — OWNER 16.08. P1/P2/P3/V8/F1")
   und den Rohtranskript-Zeitstempel 16.08. 11:47:48Z. Folge: der Arena-10-Wochen-
   Explore wurde am 16.08. (P2) erteilt und 40 Minuten spaeter in KON93-02 bekraeftigt;
   die Chronologie "Warnschwelle 12.08. -> Kapazitaet 16.08." bleibt unveraendert.
2. **"Hebt Warnung auf Kapazitaet" (Ledger/Karte 1) vs. "Ebenen-Vermischung"
   (Karte 2, Delta 1):** aufgeloest zur Drei-Schichten-Lesart (Abschnitt 2) — beide
   Regeln leben fort, an verschiedenen Speichern; die Zahl wird wiederverwendet.
3. **Karte-1-offene-Fragen 1/2/3/5:** durch Karte 2 bzw. diese Synthese geschlossen
   (1 Hebel-Ort per Praezedens+KON52-Familie, Abschnitt 6; 2 drift_faktor-Rolle =
   Bedarfs-/Pruefgroesse, Abschnitt 5; 3 ja, zwei Mechanismen — die Verdrahtung IST der
   Bau, Delta-4/E11; 5 KON93-Buchung im Ledger Z.44-62 am Objekt verifiziert).
4. **Karte-2-offene-Fragen 1-6:** 1 aufgeloest (Schichtung + B1-Verifikations-Vermerk),
   2 Bau-Festlegung (dezimal vorgeschlagen), 3 aufgeloest (Formel bleibt als
   Pruefgroesse, drift_faktor behaelt seine Rolle in S-19), 4 aufgeloest (fest+Abbruch;
   dreifach gedeckt, Abschnitt 2), 5 aufgeloest (beide: XSD gemaess Doktrin UND Parser;
   drift_gate-Luecke mitheilen), 6 aufgeloest (neuer wirksamer Pfad ueber TypedProfil
   -> MessMasse; check-size wird auf denselben Wert vereinheitlicht, nicht zum Traeger
   erhoben).
5. **Beitrag nur einer Karte, uebernommen:** Rohtranskript-Fund, dass die drift_faktor-
   Planer-Formel schon am 09.08. ~16:26Z als Compile-Fix-Ziel existierte — 3 Tage VOR
   der ersten 6GB-Nennung (Karte 1); XSD-Doktrin-Anker, ctest-Zeichengleichheits-Wache,
   failed-ohne-Retry-Ableitung, A19/A20-je-Prozess-Beleg (Karte 2 + eigene Nachlese).
