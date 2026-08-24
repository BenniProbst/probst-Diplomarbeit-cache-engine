# DESIGN #90 / P-A -- KANALWERK + ARENA (checkpoint_measure-Kanal-Hierarchie)

**Posten:** Board-#90 "P-A: Kanalwerk-/Arena-Designplan (Fable max; W1->vor Trigger, #53-Umfeld)"
= P-A aus KON110-06. **Auftraggebende Owner-Order:** KON110-02 ("Dieser Prozess ist beschrieben --
frische dein Gedaechtnis auf" -> 12W-Explore + gruendlicher Fable-5-max-Designplan PFLICHT vor dem
Bau). **Slot:** W2-D (design91-v2 Abschnitt 8) / E-2 der W2-Abfolge. **Stand:** 20.08.2026 (Abfassung
21.08. vormittags), ce/development = 66de5c09, super-Ledger-Kopf = KON119.

**WAS DIESES DOKUMENT TUT -- und was ausdruecklich NICHT:**
1. Es schreibt das **Kanal-ID-Schema (I-2) FEST** (Identitaets-Klasse C nach design91-v2:
   vor dem Trigger NUR festschreiben, Bau danach).
2. Es zieht die **Ueberlauf-Politik nach** (harter Abbruch am RAM-Limit, KON93/94) -- Pflichtteil
   von #90, KEINE Owner-Frage (A2.3a-Probe K7 in design91-v2: durch KON93/94 entschieden).
3. Es bettet die **Arena-Kette E1-E11** ein (Traeger-Zuordnung, keine Doppel-Entwuerfe).
4. Es legt den **Kollektor-SCHNITT** (nur Schnitt; der Kollektor-BAU bleibt NACH dem Trigger,
   [RT] nach 12W-Explore, im #53-Strang).
5. Es dokumentiert die **#53-Umfeld-Kette** (nicht isoliert bauen).
Es entwirft NICHTS neu, was in KON32-01/S13-Design/design91-v2 bereits entworfen ist
(Bestands-Pflicht); es fasst weder den TDD-Designplan noch fremde Plaene an (Marker-Kandidaten
werden BENANNT, gesetzt werden sie im docs-/Lande-Zug); es stellt KEINE neue Owner-Frage.

**QUELLEN-RANG (Owner > Plan > Thesis; je Aussage die juengste Owner-Linie):** Ledger KON110-02/
KON110-06, KON112-01 (RF-A-Konsolidierung mit Fundstellen), KON93-02/KON94-02/KON95-01..03,
KON101 (V-13), KON117 (S-22), KON65-02/-03, KON72-02, KON91-01; C-1..C-17 + N-1..N-7 (Ledger,
OWNER-NACHTRAG/-ENTSCHEID 08.08.2026); ce docs/architecture/20260808-checkpoint_measure_soll_
design.md (Par.1-10 + Offene Punkte 1-6 inkl. LESEFALLE HY-0); docs/plaene/20260809-MEASURESTORAGE-
design-und-deep-research.md (8 Festlegungen); docs/plaene/20260817-DESIGN-s13-buendel-di25.md
(4.2, S13-05..S13-09); docs/plaene/20260820-DESIGN-91-unifikation-ceb-modulsteuerung-v2.md
(M2, I-2, I-7, I-8).

--------------------------------------------------------------------------------------------------
## 1. OBJEKT-IST (nachgemessen am 21.08., ce 66de5c09) -- Substrat GEBAUT, Kanalwerk NICHT

- `libs/cache_engine/builder/measure_storage/` = **5 Dateien / 1207 Zeilen**:
  `checkpoint_measure.hpp` 318 (Instrument; Kopf: "Sie ist NICHT der Kanal. Der Kanal ... steht in
  mess/mess_naht.hpp und am Genus-Interface"), `checkpoint_speicher.hpp` 140 (ZWEI Systeme
  zusammengefuehrt + Cacheline-Trennungs-Beweis), `mess_arena.hpp` 313 (Append-Arena),
  `stapel_arena.hpp` 277 (LIFO-Arena), `mess_speicher_kanon.hpp` 159 (Kanon).
- `libs/cache_engine/mess/` = **6 Dateien / 1140 Zeilen** (= S-22-Subsystem, KON117):
  `genus_kaskade.hpp` 163 (Fuenf-Schichtung, MK-Durchreichung ohne Default), `konfiguration.hpp`
  272, `mess_naht.hpp` 190 (MessVisitor<MK>, RAII-Klammer, StillNaht; StationConcept = EIN
  statischer Deskriptor je (Gattung, Genus, Funktion, Station)), `pilot_achsen.hpp` 61,
  `pilot_suche_impl.hpp` 211, `steuer_dock.hpp` 243.
- Abnahme-Tests am Objekt: `test_ck1_messkette_koeder.cpp` (B-06-Kausalkette), `test_ms1_arenen_
  kein_alloc_im_fenster.cpp` (Allokations-Freiheit im Fenster, operator-new-Zaehler),
  `test_ms2_pre_touch_seitenfehler.cpp` (Pre-Touch/ru_minflt).
- **GEGENPROBEN (V0/V1, 21.08.):** `kanal_baum|kanalwerk|channel_tree` ueber libs+tests (ohne
  build/) = **0 Treffer**; `PROFILER` in mess/ + measure_storage/ = **0 Treffer**. Die
  design91-v2-M2-Zeile "Arenen gebaut; Kanalwerk 0 Treffer" ist am Objekt BESTAETIGT.
- Politik-Befund am Objekt (fuer Abschnitt 4): `mess_arena.hpp:36-38` "GEBAUT: ZAEHLEN, MELDEN,
  WEITERMESSEN", `:213` kUeberlaufSlot, `:263-269` anhaengen() zaehlt ueber die Kapazitaet weiter.
  Dazu stale: `:222-224` nennt als Planer-Formel "n_ops * zeilen_je_op * 2 (Sicherheitsfaktor 2)"
  -- verdrahtet ist `kapazitaet_zeilen_rechnen(n_ops, zeilen_je_op, sicherheitsfaktor)`
  (`checkpoint_speicher.hpp:140-141`, frisch gemessen 24.08. @ 943c70ee-Kette; Formel-Zeile
  `:117`, Faktor-Herleitung `:119-132`; Ledger-Name drift_faktor(<=18) KON94-02, ab
  messfenster-Landung arena_gesamt_faktor=120; KON92-Delta C7).
  [A-KW-1/K-01-Praezisierung 24.08.2026, W2-Abschluss-Fixzug #139: Parameter-Name am Objekt
  ist sicherheitsfaktor, nicht drift_faktor -- der Ledger-Name bleibt als Zitat daneben;
  Zeilen-Anker gegen den HEUTIGEN Stand neu gemessen (F3-13-Doktrin, alte S2-Anker :131-132
  waren gedriftet).]
- Deskriptor-Notiz: `mess_naht.hpp` bindet Soll-Design-OP-1 auf JA (EIN Deskriptor je Station);
  `mess_arena.hpp:88-91` fuehrt das 64-bit-Reservefeld noch als "OP-1/OP-2 NICHT entschieden,
  heute immer 0". Kein Defekt (Feld ist ehrlich reserviert), aber eine Kommentar-Divergenz,
  die der Kollektor-Bau-Zug beim Anfassen der Datei mitzieht.

--------------------------------------------------------------------------------------------------
## 2. DER KANAL-BAUM -- GEDAECHTNIS-DESTILLAT (Fundstellen je Zeile)

**Drei Mess-Ebenen** (N-5-Kette, 08.08.): CEB-Thread (compare, in der CEB VOR dem Pruefdock)
-> ruft am Pruefdock die Interface-Funktion der Tier-Binary (macro) -> Achsen-Aufrufe (micro).
Ebenen-Zuordnung juengste Fassung: **mi = Achsen-Interface, ma = Genus-Interface** (KON72-01/F-P5,
KON88-P1, KON91-01). Es gibt KEINE vierte Filter-Ebene: C-13.2 ist per KON110-02/KON112-01
beantwortet (Gattung+Genus = EINE Interface-Hierarchie; ma haengt am Genus-Interface).
**LESEFALLE HY-0 bleibt stehen:** die 4. HYBRID-Mess-Ebene (GO-3, dazwischengequetschte
Macro-Schicht) ist ein ANDERER Gegenstand als der Filter-Rang; wer beides gleichsetzt, baut die
falsche Schicht (Soll-Design, Offener Punkt 3, Nachtrag HY-0).

**Der KANAL-Begriff (Owner 17.08., KON110-02 -- die fuenf echten Praezisierungen):**
1. Das Wort KANAL + der Kanal-BAUM: **jedes Achsen-Interface = eigener Kanal -> gebuendelt in
   Genus-Interface-Kanaele -> gebuendelt in w-CEB-Aufruf-Pattern**.
2. **PROFILER** = Name der obersten w-Kategorie (das gemischte Aufruf-Profil der CEB).
3. Buendelungsregel: **multiple Genus-Kanaele werden ueber das LAST-PROFIL zusammengezogen**.
4. **Klammer-DEFAULT:** "default wird NUR die INNERSTE checkpoint_measure-Klammer gemessen";
   umklammernde checkpoint_measure messen selbst immer groebere Ein-/Ausstiegspunkte EINES
   Parameters ueber die inneren Klammern hinweg.
5. Daraus die **Arena-Auswertungs-PFLICHT**: die Auswertung MUSS die inneren Kanal-Klammern auf
   den Bereich der aeusseren ZUSAMMENFUEHREN.

**Was die Doku schon VOR dem Owner-Satz trug (KON112-01 "DOKU IST VORN"):** der Algorithmus der
Zusammenfuehrung = C-9 (EIN O(n)-Vorwaerts-Durchlauf, je ein offener Stapel pro Ebene; die
Kanal-Pflicht ERWEITERT C-9 um die Kanal-Dimension, ersetzt ihn nicht); Aufnahme-Felder C-3;
Kosten C-11 (gemessene Rangfolge, rdtsc 6,8 ns / steady_clock 16,5 ns); thread-lokal C-10;
Arena-Politik KON93/94 (Abschnitt 4); E(A)-Definition KON95-02 (kV3AxisSchema + seg_*).

**w-Begriff:** w = Wallclock-Instrument der CEB gegen Tier/Hybrid, JE ORGAN-ACHSE zusaetzlich zu
deren Spezialparametern erhoben (KON65-02, 18 seg_<achse>_ns); erweitert per KON110-02 zum
gemischten Aufruf-Profil (PROFILER) -- Spannung (b) in Abschnitt 5. w-AGGREGATION ist
ABFRAGE-getrieben: erst wenn w nach einer ma-Zusammenfassung fragt, wird die Zeilen-Akkumulation
nachtraeglich zu EINER Zeile zusammengefasst (KON95-01); die ma-Sicht ist ein GESAMMELTER BLOCK
ueber viele zeitlich versetzte mi-Zeilen; Union-Akkumulation gilt PRO Messbaum-Knoten (KON95-03).

**Die zwei Arenen + Allokations-Verbot (Owner 09.08., VOLLES GO):** "neue Allokationen fuer die
Messwert-Aggregation sind VERBOTEN, weil sie das Bild der Messungen verzerren" -- Append in einen
vor-reservierten custom Speicherbereich. checkpoint_measure hat **2 interne Systeme**: MESS-ARENA
(nur Append, monoton, Ereigniszahl-dimensioniert, Auswertung zum Schluss, POD-Records) und
STACK-ARENA (LIFO, Verschachtelungstiefe, Auswertung waehrend des Laufs, nur Referenzen).
**Die 8 MeasureStorage-Festlegungen** (Deep-Research, per Owner-GO Festlegung -- Volltext
docs/plaene/20260809-MEASURESTORAGE-design-und-deep-research.md "EMPFEHLUNG IN ACHT PUNKTEN"):
(1) EIN anonymer mmap, pmr nur als Konzept; (2) lineares Append-Log je Thread, KEIN Ring;
(3) kein Lock/kein zwingendes Atomic im Hot-Path; (4) Stack = LIFO-Buchhaltung mit Referenzen,
Feld + Top-Zaehler, kein std::stack; (5) Cacheline-Alignment per verifizierter Hauskonstante,
nicht hardware_destructive_interference_size; (6) keine pauschalen Huge Pages -- gezieltes
madvise(MADV_HUGEPAGE) + Pre-Touch; (7) roh aufnehmen, nicht bucket-komprimieren
(LatencyHdrHistogram gehoert in die compare-Phase); (8) der Export darf frei allozieren -- NACH
der Messung; ErgebnisMappe als KONSUMENT von measure_to_latex.
CAVE Bestands-Fallen (unveraendert gueltig): ThreadArena/InMemoryMeasurementBuffer sind KEINE
Vorlagen; LIFOStackBuffer ist eine Queuing-Achse des Gemessenen; csv_to_latex ist aktiv
(Abloesung mit Migrationspfad = S13-17).

--------------------------------------------------------------------------------------------------
## 3. I-2 -- KANAL-ID-SCHEMA: FESTSCHREIBUNG (Identitaets-Klasse C)

Klassifikation nach design91-v2 (Fix 2): **[ID/FIX] = vor dem Trigger NUR festschreiben; der
Kollektor-BAU bleibt [RT] nach dem Trigger.** Begruendung der Identitaets-Wirkung: Kanal-Tags
gehen in persistierte Bestand-2/3-Records und in die xlsx-Legenden (design91-v2, I-2-Eintrag) --
was die Kampagne ohne Tag misst, bleibt ohne Tag (Messdaten nie loeschen, nie nach-erheben).

### 3.1 Kanal-ADRESSE
- Die Kanal-Adresse ist eine **Registry-konforme Token-Kette entlang der Buendel-Hierarchie
  Achsen-Interface -> Genus-Interface -> w/PROFILER** (design91-v2 I-2-Teil; KON110-02-Baum).
  Ein Kanal ist damit IMMER ueber seinen Pfad im Baum adressiert, nie ueber einen freien Namen.
- Die Tokens folgen den GEBAUTEN Registry-/Stempel-Grammatiken (Registry-Achsen-Katalog,
  Stempel-Syntax-Doktrin): **Kuerzel werden NIE flach gelesen, Grammatik-Wache je Position**
  (KON72-02-Prinzip, z.B. pmc{c.{p.e}}.b.t; p(Suffix) vs p(P-Core) nur ueber Position getrennt).
- **ORG-19-Auflage (#86, KON112-01 BAU-FOLGEN):** store()/load() erweitert das Genus-Interface
  => ORG-19 wird als EIGENER Genus-Kanal im Kanalwerk registriert -- die Adresse entsteht aus
  derselben Baum-Regel, kein Sonderpfad.
- Die Hybrid-Reroute-Schicht (GO-3/HY-0) erhaelt ihre Kanal-Adresse ERST mit dem HY-C-Design;
  dieses Schema reserviert dafuer KEINEN Ad-hoc-Platz ausser dem in 3.4 benannten Enum-Wert.

### 3.2 REIHENFOLGE-KANON (V-13/KON101) -- der harte Teil der Festschreibung
- Owner verbatim (17.08., KON101-01): "V-13: Es wird nur die Reihenfolge wallclock/macro/micro
  erlaubt, alles andere ist syntaktisch falsch, bitte mit umstellen."
- FESTGESCHRIEBEN: In JEDER serialisierten Ebenen-Liste (CEB-Legenden, ceb_tooling_list,
  Kanal-Adress-Praefixe, xlsx-Legenden, Bestand-2/3-Record-Metadaten) ist
  **wallclock/macro/micro die EINZIG erlaubte Reihenfolge; jede andere Permutation ist
  SYNTAKTISCH FALSCH = Wurf, KEINE stille Normalisierung** (KON101-02: die permutierten
  Zwillings-Schluessel verschwinden dadurch klassenweise).
- Durchsetzungs-Traeger: **B-5f Ordnungs-Validierung an ALLEN DREI Stellen = Board-#99**
  (Di-25); dieses Dokument definiert die Regel, #99 baut die Validierung -- nicht doppeln.
- OBJEKT-BELEG (kein Umbau noetig): die gebaute Ordinal-Ordnung deckt den Kanon bereits --
  `mess_arena.hpp:59` MessEbene { Compare=0, Macro=1, Micro=2, Reserviert=3 }: 0/1/2 IST
  w-vor-ma-vor-mi. Der Kanon bindet die SERIALISIERTE Reihenfolge; die Ordinale muessen nicht
  gedreht werden.

### 3.3 ALIAS STATT RENAME (Namens-Paar compare/macro/micro vs w/ma/mi)
- Beide Namensreihen sind konsistent aufeinander abbildbar (KON112-01 Spannung (c):
  compare~w-nah, macro=ma am Genus-Interface, micro=mi). FESTGESCHRIEBEN: die Harmonisierung
  laeuft als **Alias-Deklaration in der R-2-Begriffs-Alias-Registry (M13), KEIN Rename** --
  compile-time dasselbe, Uebersetzen = Regression = CT-Fehler (KON110-05 R-2, design91-v2 I-2).
  I-7-Rangfolge (Alias VOR Rename) ist in design91-v2 bereits festgeschrieben und gilt hier.
- Quellen-Ehrlichkeit statt Glaettung: KON112-01(c) nennt dieses Paar den "ERSTEN
  ANWENDUNGSFALL" der Registry, KON112-09 reiht es als Kandidat (2) hinter SPARSE_NODE4_ART/
  node4. Beide Aussagen bleiben stehen; fuer dieses Design ist nur bindend, DASS es ein
  Alias-Fall ist -- die Einbau-Reihenfolge entscheidet der M13-Skelett-Zug.

### 3.4 TAG- UND DESKRIPTOR-BINDUNG (Hot-Path-Seite des Schemas)
- Im Hot-Path reist KEIN Kanal-String (R1: kein Text im heissen Pfad). Der Kanal reist als
  **deskriptor_ix (uint32)** in die statische Deskriptor-Tabelle; die Tabelle traegt je Eintrag
  (Gattung, Genus, Funktion, Station) -- `mess_naht.hpp` StationConcept, OP-1=JA -- und wird um
  die **Kanal-Spalte (Achse -> Genus -> Kategorie)** erweitert, compile-time befuellt.
  Die Aufloesung deskriptor_ix -> Kanal-Adresse geschieht NACH dem Fenster (C-8).
- Ebenen-/Richtungs-Tag bleibt wie gebaut: `tag_bauen()` = 2 Bit Ebene + 1 Bit Richtung,
  Bits 3..7 frei (`mess_arena.hpp:62-66`). **FESTGESCHRIEBEN: der Enum-Wert Reserviert=3 wird
  NICHT stillschweigend an die Hybrid-Ebene vergeben** -- ob die Hybrid-Macro-Schicht als
  vierter Flag-Wert eintritt, ist per LESEFALLE HY-0 ein EIGENER, noch nicht getroffener
  Entscheid (Traeger: HY-C-/GO-3-Design, nach Trigger). Bis dahin ist 3 reserviert und jede
  Verwendung ein Wurf.
- Die freien Tag-Bits 3..7 bleiben frei (Reserve); Kanal-Information gehoert in die
  Deskriptor-Tabelle, nicht in Tag-Bits (Tabelle ist erweiterbar, Bits sind ABI).

### 3.5 PERSISTENZ-KOPPLUNG (I-8)
- Mess-Records tragen ab der Kampagne **Kanal-Tag, Zustands-Dimension, machine_id/platform-Tag**
  (I-8, design91-v2; spaetestens VOR Sa 29.08., empfohlen im W2-Schema-Zug mit I-1).
  Das Kanal-ID-Schema dieses Abschnitts IST die Definitionsquelle des I-8-Feldes "Kanal-Tag";
  der Feld-EINBAU laeuft im Schema-Zug (D-2/#57-Umfeld), nicht hier.
- xlsx-Seite: die Legenden fuehren die Kanal-Tokens in Kanon-Reihenfolge (3.2); Spaltenmenge je
  Ebene nach KON94-01-Bildungsregel (mi(A) = E(A); ma und w = Union aller E(A) + op_*/Wallclock
  + PMC-compound + Kalt-Diff-Traeger, Union PRO Messbaum-Knoten, KON95-03).

### 3.6 WAS DIESES SCHEMA NICHT FESTLEGT (bewusst offen, mit Traeger)
- Kollektor-Interna (Abschnitt 7 legt nur den Schnitt): Bau nach Trigger, #53-Strang.
- Stapel-Kapazitaets-Formel (Soll-Design Offener Punkt 4: Verschachtelungstiefe unerhoben,
  64u ist Test-Konstante, kein Kanon) -- Erhebung gehoert zum Kollektor-/S13-06-Umfeld.
- Hybrid-Ebenen-Tag (3.4, HY-0) -- HY-C-Design.
- Zell-/POD-Haelfte des markierten Leerwerts: S13-11, POD-Haelfte NUR nach [OG-20].

--------------------------------------------------------------------------------------------------
## 4. UEBERLAUF-POLITIK-NACHZUG -- HARTER ABBRUCH AM RAM-LIMIT (KON93/94); T-12c-WORTLAUT UEBERHOLT

### 4.1 Beide Linien, chronologisch (nichts glattgerechnet)
- **08.08. (C-6):** "Der Ueberlauf ist ein Befund, kein Verlust ... weiterlaufen, aber den
  Ueberlauf zaehlen und beim Auslesen melden." So wurde am 09.08. gebaut (Abschnitt 1,
  mess_arena.hpp:36-38) und so stand es im TDD-Designplan Par.12 **T-12c(3)**.
- **16.08. (KON93-02, P2-Owner-Wort):** "Der harte Abbruch kann also nur am RAM Limit sterben,
  wenn die Mess-Arena voll ist." Kapazitaet = **6 GB FEST/STATISCH**, aenderbar NUR als
  Planer-Reservierung zu Experiment-Beginn; das gebaute Zaehlen+Weitermessen ist "in dieser
  Lesart zu heilen (stiller Datenverlust)".
- **16.08. (KON94-02):** SCHICHTUNG statt Abloesung -- **drei Schichten an zwei Speichern**:
  (1) Warnschwelle 6 GB delayed-informativ am CEB-AGGREGAT (KON51/52, bleibt) | (2) OOB-Opt-in
  hart am CEB (KON52, bleibt) | (3) Kapazitaet 6 GB STATISCH je MESS-PROZESS-Arena, **voll =
  harter Abbruch; failed OHNE Retry; Arena-Bestand VOR dem Abbruch persistieren**
  (Bestands-Doktrin). S-19-Formel n_ops x zeilen_je_op x drift_faktor(<=18) wird BEDARFS-/
  PRUEFGROESSE gegen die Reservierung (Deckelurteil VOR Messstart); der Laufzeit-Abbruch ist
  nur der Restschutz. XML-Hebel: `<mess_speicher>`-Element (X-4 im s13-Schema-Zug).
- **17.08. (KON100-02/KON100-04):** s13-Lens MUSS-1 stellte den Konflikt; **Rangfolge
  OWNER > PLAN**; der **UEBERHOLT-Marker steht seither am TDD-Designplan Par.12 T-12c(3)**
  (verifiziert am Objekt: docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md,
  Markerblock nach T-12c). Geltende Fassung: **s13-Design S13-05/S13-07**.

### 4.2 FESTSCHREIBUNG (deckungsgleich mit S13-05/06/07 -- hier gebuendelt, dort gebaut)
1. **Mess-Arena voll = harter Abbruch.** Status failed, KEIN Retry (die x5-Retry-Klammer
   #13/T-15b darf diesen Fall NICHT wiederholen -- ein zweiter Lauf traefe dieselbe Wand),
   Arena-Bestand vor dem Abbruch persistieren (sonst wird stiller Datenverlust gegen lauten
   Totalverlust getauscht). UeberlaufBefund bleibt und wird zum ABBRUCH-Protokoll.
2. **Stapel-Arena behaelt ihre EIGENE Fehlerklasse** (voller Stapel = Programmierfehler;
   AUS-ohne-EIN = zweite eigene Klasse) -- die Klassen-Trennung (checkpoint_speicher.hpp:18)
   bleibt; der Abbruch-Satz gilt der MESS-Arena.
3. **Die drei Schichten NIE vermengen:** wer Schicht (1) durch Schicht (3) ersetzt, macht die
   Warnung unerreichbar (S13-05-Koeder 3); OOB bleibt am CEB das Fertig-Signal, kein Fehler.
4. **Deckel-Mechanik:** 6-GB-constexpr-Deckel NEBEN kapazitaet_zeilen_rechnen; Rechnung ueber
   dem Deckel = BEFUND am Planer-Dock VOR Messstart, kein stilles Kuerzen (S13-05-Schnitt).
5. **Koeder-Fortbestand:** der T-12c(3)-Teil "still verworfene Zeilen werden ROT" bleibt
   gueltig; ersetzt ist NUR der Weiterlauf-Teil.
- **TRAEGER DES UMBAUS: S13-05/S13-06/S13-07 im D-1-Zug (#18, Di 25.08.).** Dieses Dokument
  definiert die Politik im Kanal-/Arena-Kontext; es eroeffnet KEINEN zweiten Bau-Ort.

### 4.3 Marker-/Nachzugs-Kandidaten (fuer den docs-/Bau-Zug, hier nur benannt)
- `mess_arena.hpp` Kopfblock Z.25-38 ("Drei Wege ... GEBAUT: ZAEHLEN, MELDEN, WEITERMESSEN")
  wird beim S13-07-Umbau auf die KON93/94-Linie umgeschrieben (Objekt-Nachzug, KON112-11(10));
  ebenso der stale Faktor-2-Kommentar Z.222-224 (KON92-C7) und die OP-1-Kommentar-Divergenz
  (Abschnitt 1). Kein Doku-Marker, sondern Code-Kommentar-Nachzug im Umbau-Commit.
- `docs/plaene/20260809-MEASURESTORAGE-design-und-deep-research.md` Ueberlauf-Absatz
  ("weiterlaufen, zaehlen, beim Auslesen melden") traegt noch die alte Linie: **UEBERHOLT-
  Marker-Kandidat** fuer den naechsten docs-Zug (analog T-12c-Marker; Doku nie loeschen).

--------------------------------------------------------------------------------------------------
## 5. SPANNUNGEN -- BEIDE SEITEN ZEIGEN (KON112-01; designpflichtig, NICHT glattrechnen)

### (a) Klammer-Default "nur innerste" (17.08.) vs C-1/N-4 "jede Ebene schreibt IN/OUT" (08.08.)
- SEITE 1 (08.08., C-1/N-4): checkpoint_measure ist EINE uniforme Funktion; je Aufruf ZWEI
  Checkpoints (IN bei Interface-enter, OUT bei return), auf JEDER aktiven Ebene -- zwingend,
  weil sonst ein nie zurueckkehrender Aufruf UNSICHTBAR waere (N-6-Regression) und die
  C-9-Rekonstruktion ihre Stapel-Kanten verloere.
- SEITE 2 (17.08., KON110-02): "default wird NUR die INNERSTE checkpoint_measure-Klammer
  gemessen"; aeussere Klammern messen groebere Ein-/Ausstiegspunkte EINES Parameters ueber die
  inneren hinweg; die Arena-Auswertung MUSS innere Kanal-Klammern auf den Bereich der aeusseren
  zusammenfuehren.
- Der WORTLAUT beider Seiten bleibt stehen. DESIGN-AUFLOESUNG dieses Plans (= der in KON112-01
  benannte Aufloesungs-Kandidat C-13.3, "Ebenen-Flags + CEB-Gates = EIN Mechanismus"), als
  DREI-EBENEN-TRENNUNG:
  1. **EINBAU (compile-time):** WELCHE Ebenen ueberhaupt Checkpoints tragen, entscheiden die
     CEB-Gates/Ebenen-Flags -- die sechs CEB-Varianten SIND ein- und ausgebaute Mess-Ebenen;
     es gibt keinen zweiten Schalter-Mechanismus daneben (C-13.3).
  2. **SCHREIBEN (Laufzeit, Rohdaten):** JEDE EINGEBAUTE Ebene schreibt IN/OUT-Paare (N-4
     unveraendert) -- die Rohdaten-Ebene kennt keinen "nur innerste"-Filter, sonst fielen
     N-6-Wache und C-9-Stapel.
  3. **AUSWERTEN (Kollektor, Default):** der Klammer-Default ist eine AUSWERTE-Regel: je
     Parameter traegt die INNERSTE Klammer den Messwert; aeussere Klammern gehen als
     Bereichs-/Grobpunkte in die Zusammenfuehrung (Pflicht (5), C-9 um die Kanal-Dimension
     erweitert). "Default" heisst: per XML/Registry umstellbar, ohne die Schreib-Ebene zu
     beruehren.
  Diese Aufloesung liegt INNERHALB der P-A-Design-Autoritaet (KON110-02 hat genau diesen
  Designplan beauftragt; KON112-01 adressiert die Spannung ausdruecklich an den P-A-Plan).
  Sie ist damit Design-Entscheid, KEINE neue Owner-Frage -- der Owner-Wortlaut beider Seiten
  wird nicht angetastet, und die Bau-Abnahme (Kollektor-Zug) muss BEIDE Seiten mit Koedern
  zeigen (ein Filter, der Roh-IN/OUT unterdrueckt, wird ROT; eine Auswertung, die aeussere
  Klammern doppelt zaehlt statt zusammenzufuehren, wird ROT).

### (b) w-Begriffserweiterung: Wallclock-Instrument (KON65-02) -> PROFILER (KON110-02)
- Kein Widerspruch (Wallclock bleibt TEILMENGE des gemischten Aufruf-Profils), aber eine
  DESIGN-NACHFUEHRUNG: die oberste w-Kategorie heisst PROFILER und buendelt multiple
  Genus-Kanaele uebers Last-Profil. Der F-G1-4(b)-Sonderfall (rein CEB-seitige
  checkpoint_measure-Klammer "entfernt ... bleibt Papier bis Wrapper gebaut", kon64_sammlung)
  bleibt PAPIER -- der Wrapper gehoert in den P-A-/Kollektor-Bau NACH Trigger (KON112-12(9)),
  nicht in diese Festschreibung.

### (c) compare/macro/micro vs w/ma/mi -> geloest als Alias-Fall, Abschnitt 3.3.

--------------------------------------------------------------------------------------------------
## 6. ARENA-KETTE E1-E11 -- EINBETTUNG (Traeger-Zuordnung, kein Doppel-Entwurf)

Die Bauliste E1-E10 stammt aus KON92 (Arena-Ketten-Karte), E11 aus KON94-02 ("KON93-Kapazitaets-
Vollzug", 5 Teilposten, **E11.1-3 VOR E9**). Getragen wird die Kette vom **D-1-Zug (#18,
S-13-KERN-LANDUNG, Di 25.08.)** -- W2-Abfolge D-1 fuehrt sie woertlich als "E1-E11-Arena-Kette
(E11=6GB; r5-C-1..C-17-Auflagen)"; B-05/B-06 (MeasureStorage-Festlegungen, variadische
Durchreichung) laufen als E1-E11-Traeger mit. Einbettung im Einzelnen (IST nach s13 4.2):

| Posten | Inhalt (Kurzform) | Traeger/Status |
|---|---|---|
| E1 | Arena-Grundpolitik | VERSCHLANKT -- Politik-Haelfte durch KON93 entschieden (Abschnitt 4) |
| E2/E3 | FELDER-Posten (Kalt-Diff-Feld, Zeilen-/Aggregat-Felder; KON92-Deltas C2/C8) | mit E4 als "Join+Felder": FJ-3/FJ-4 = E4/E2/E3 (KON94-01) |
| E4 | Aggregator Roh -> Sheet-Zeile, Pivot deskriptor_ix -> Spalte | S13-31: ZWEI Modi (Block-Durchreichung Default + w-getriebene Ein-Zeilen-Zusammenfassung, KON95-01) |
| E5 | Folgeblatt statt Wurf (kXlsxZeilenlimit) | S13-18-Familie |
| E6 | DRAIN-Schleife Arena -> Blaetter (measurement_sink-Heilung KON32-01) | S13-09; S-13/#18-Kernstueck |
| E7 | Zwei-Phasen an der Arena | S13-05-Umfeld |
| E8 | PAAR-Muster landen (Warmup) | mit #38b/T-12b-Umfeld |
| E9 | measure_storage produktiv anschliessen | NACH E11.1-3 |
| E10 | Rest-Posten der KON92-Liste (im Ledger-Kopf nicht einzeln ausbuchstabiert -- Kern war E4-E9) | Quelle bei Bedarf: arena_kette_karte.md (Folge-BU-2, 20260816-folge-bu-kontext8) |
| E11 | 6-GB-Kapazitaets-Vollzug: Deckel + Abbruch + Thread-Slots + XML-Hebel + Planer-Verdrahtung (5 Teilposten, E11.1-3 VOR E9) | S13-05/S13-06/S13-07 + X-4 `<mess_speicher>` |

- In der SUBSTANZ bereits gebaut (s13 4.2, am Objekt bestaetigt): B-05 (zwei Arenen, getrennte
  Fehlerklassen, Allokations-Verbot), B-06 (Ursache-Kette bis Pruefdock, test_ck1), T-12c(4)
  (Deskriptor-Index statt Achsen-Kette). Offene Luecken der Kette = genau die vier von s13:
  6-GB-Doktrin, Abbruch-Semantik, Thread-Slot-Obergrenze, XML-Schalter.
- **Beitrag dieses Designs zur Kette (die KANAL-DIMENSION):** E4 pivotiert nach deskriptor_ix --
  mit der Kanal-Spalte der Deskriptor-Tabelle (3.4) wird derselbe Pivot je KANAL schneidbar,
  und die Klammer-Zusammenfuehrung (5a, Ebene 3) setzt VOR dem E6-Drain an. Kein neuer Posten:
  die Kanal-Dimension reist als Tabellen-Spalte in E4 mit.
- Abnahmen bleiben die T-12c-Seiten (1) Deckel/kein Laufzeit-Resize, (2) Thread-Slots laut,
  (4) Hot-Path-Reinheit, (5) IN-ohne-OUT-Wache -- mit der 4.2-Ersetzung fuer (3).
- Die r5-C-1..C-17-Auflagen (r5-Karte der Drift-Konsolidierung hebt die 08.08.-Entscheide als
  E11-/T-12c-Auflagen) sind damit vollstaendig adressiert: C-14/C-15 -> S13-06; C-6 -> 4.2;
  C-8/C-9 -> 7.1; C-17-Slot-Fehlerfall -> S13-06-Fehlerklasse.

--------------------------------------------------------------------------------------------------
## 7. KOLLEKTOR -- NUR DER SCHNITT (Bau NACH dem Trigger)

Der Kollektor ist das Auswerte-Stueck, das aus den zwei Arenen den KANAL-BAUM macht. Er ist
HEUTE 0 Treffer am Objekt (Abschnitt 1) und wird NICHT vor dem Trigger gebaut (Board-#90:
"12W-Explore vor Bau"; design91-v2 M2: Kollektor-Bau [RT] nach 12W-Explore, #53-Strang).

### 7.1 WAS er tut (Pflichten, alle owner-/KON-gedeckt)
1. **C-9 + Kanal:** EIN O(n)-Vorwaerts-Durchlauf, je ein offener Stapel pro Ebene, erweitert um
   die Kanal-Dimension (KON112-01) -- Aufrufer-Aufloesung, Klammer-Paarung.
2. **N-6-Wache:** IN ohne OUT je (Prozess, Thread, Interface) = Regression, gezaehlt + gemeldet
   (T-12c(5)); faellt als Nebenprodukt desselben Durchlaufs ab.
3. **Klammer-Zusammenfuehrung:** innere Kanal-Klammern auf den Bereich der aeusseren (Pflicht
   (5), Default-Regel aus 5(a) Ebene 3).
4. **ma-Block + w-Abfrage:** ma = gesammelter Block ueber versetzte mi-Zeilen; Ein-Zeilen-
   Zusammenfassung NUR auf w-Abfrage (KON95-01; E4-Modus 2).
5. **PROFILER-Buendelung:** multiple Genus-Kanaele uebers LAST-PROFIL zusammenziehen
   (KON110-02(3)); Ausgabe konsumierbar fuer die ML-/Hybrid-Seite (ma x w-Wahrscheinlichkeiten,
   KON110-03 RF-D).

### 7.2 SCHNITT-FLAECHEN (bindend fuer den spaeteren Bau)
- EINGAENGE: `AusleseErgebnis` (Zeilen + Ueberlauf-/Abbruch-Befund UNTRENNBAR -- der Kollektor
  kann den Verlust nicht ignorieren, ohne es zu tun), `StapelArena::offene()` (Regressions-
  Restbestand), die statische Deskriptor-Tabelle MIT Kanal-Spalte (3.4), die Kanal-Registry
  (3.1) und die iw/ima/imi-Flags der Traegerstufe (KON72-02 -- was die Stufe nicht lesen kann,
  wird nicht erhoben).
- AUSGAENGE: kanal-getaggte Zeilen an den **E4-Aggregator (2 Modi)** -> **E6-Drain** -> S-13-
  Blattsystem/CSV-Factory. KEIN eigener Schreiber (Festlegung 8: Export via ErgebnisMappe/
  measure_to_latex-Strecke).
- ORT: auf der AUSWERTE-Seite -- curve_fit-/Auswertung NUR auf der (vollen) CEB zur Laufzeit
  (KON110-04); der Kollektor gehoert NICHT nach builder/measure_storage/ (dessen Kopf verbietet
  die Kanal-Rolle woertlich). ORDNUNGS-VORSCHLAG: Fassade im S-22-Subsystem mess/ (die INNERE
  Ordnung der S-22-Stufe entscheidet das Bau-Design, KON117) -- endgueltiger Datei-Schnitt im
  Bau-Zug nach dem 12W-Explore.
- NICHT-FLAECHEN: keine Steuer-Naht-Vermischung (Steuer-/Mess-Naht = zwei Vertragsformen, NIE
  verschmelzen, KON112-02); kein Zugriff auf axes/ topics/ heuristik/ (EISERNE REGEL).

### 7.3 BAU-VORBEDINGUNGEN (Reihenfolge, hart)
1. Trigger Mi 26.08. 06:00 vorbei (Kollektor ist nach-Trigger-Klasse, design91-v2 2d).
2. S13-05/S13-06/S13-07 GELANDET (Arena-Semantik zuerst -- der Kollektor darf nie auf der
   Weiterlauf-Semantik aufsetzen).
3. #53-Kette bedient (Abschnitt 8): Owner-Vorlage je Achse VOR Bau der jeweiligen Achsen-
   Kanal-Erhebung.
4. I-8-Felder im Schema-Zug gelandet (Kanal-Tag persistierbar VOR Kampagne Sa 29.08.).
5. 12W-Explore des Kollektor-Baus (Board-#90-Zeile) als Bau-Auftakt.

--------------------------------------------------------------------------------------------------
## 8. #53-UMFELD-KETTE (Abhaengigkeit -- NICHT isoliert bauen)

- **#53 = Board "DESIGN MESS-ACHSEN-FAMILIE: PMC-Schwester-Design ZUERST, dann Lastsequenz;
  Owner-Vorlage je Achse vor Bau" [in_progress].** P-A liegt per KON110-06 woertlich im
  "#53-Umfeld"; design91-v2 M2 setzt die Reihenfolge "#90 (Design W1->vor Trigger), dann #53".
- Konkrete Kopplungen:
  1. **PMC erweitert den Nenner:** PMC ist dreiphasig auf CEB UND Tier/Hybrid die permutierende
     Messeinrichtung, "die als ZUSAETZLICHE Achse die Permutation gegen w/ma/mi erweitert"
     (KON65-03/F1); PMC-Sondergrammatik: existiert keine PMC, wird KEIN Eintrag geschrieben.
     Die PMC-compound-Spalten der ma/w-Union (KON94-01) definieren sich im PMC-Schwester-Design
     (#53) -- der Kanal-Baum KONSUMIERT sie, er definiert sie nicht.
  2. **iw/ima/imi-Flags (KON72-02):** die vorangehende Traegerstufe traegt das Aufzeichnungs-
     Interface der nachfolgenden (CEB: ima/imi; Planer: iw). Kann eine Stufe das Interface
     nicht lesen, koennen keine Messdaten zu diesem Thema erhoben werden -- der Kollektor prueft
     diese Flags, er umgeht sie nie.
  3. **AND-FREIGABE (F-P8/KON72-02):** vorangehende Achsen-Kategorien schalten nachfolgende
     frei; das Kanalwerk erfindet KEINE eigene Freigabe-Logik.
  4. **Nenner-Doktrin:** Mess-Permutation DYNAMISCH > 32, NUR S-19 rechnet sie -- der Kanal-Baum
     legt KEINE statischen Kanal-/Permutations-Nenner vor (dritte 32er-Ruege, Owner 15.08.).
  5. **Owner-Vorlage je Achse VOR Bau (#53, owner-gated):** der Kollektor-BAU je Achsen-Kanal
     startet erst, wenn die #53-Vorlage der jeweiligen Achse durch ist. Diese FESTSCHREIBUNG
     (Abschnitte 3-5) ist davon NICHT gated -- sie ist Design, kein Bau (Klasse C).
- Folge fuer die Reihung: #90-DESIGN (dieses Dokument) vor Trigger; #53 liefert PMC-Schwester +
  Lastsequenz + Achsen-Vorlagen; DANN Kollektor-Bau im #53-Strang mit diesem Schnitt.

--------------------------------------------------------------------------------------------------
## 9. ABGRENZUNGEN / VERBOTE (unveraendert, hier nur gebuendelt)
- EISERNE REGEL: nichts unter axes/ topics/ heuristik/ (axes-Aenderung = golden-Ereignis, nur im
  dedizierten golden-Zug); golden-/TABU-Dateien byte-stabil.
- Steuer-Naht (S-10) und Mess-Naht bleiben ZWEI Vertragsformen (KON112-02); #20-Vereinigung ist
  INTRA-Naht.
- Dieses Dokument stellt KEINE neue Owner-Frage (K7-Probe: Ueberlauf-Politik durch KON93/94
  entschieden; Klammer-Aufloesung liegt in der beauftragten Design-Autoritaet, 5(a)).
- Owner-gated bleibt ausserhalb: #53-Achsen-Vorlagen (8.5); [OG-20]-POD-Haelfte (3.6).

## 10. VOLLZUGS-/ABNAHMEBILANZ #90
MIT DIESEM DOKUMENT ERLEDIGT: (a) Designplan P-A liegt (KON110-02-Pflicht); (b) I-2
festgeschrieben (Abschnitt 3; Klasse-C-Vollzugsbeleg fuer E-3/#91); (c) Ueberlauf-Politik-
Nachzug dokumentarisch vollzogen (Abschnitt 4; Bau-Traeger S13-05/06/07); (d) E1-E11
eingebettet (Abschnitt 6); (e) Kollektor-Schnitt gelegt (Abschnitt 7); (f) #53-Abhaengigkeit
dokumentiert (Abschnitt 8).
OFFEN MIT TRAEGER: Kollektor-Bau (#53-Strang, nach Trigger, 7.3); S13-05/06/07-Umbau (D-1,
Di 25.08.); B-5f-Validierung (#99); I-8-Feldeinbau (Schema-Zug); mess_arena-Kommentar-Nachzug
+ MEASURESTORAGE-Plan-Marker (4.3, docs-/Bau-Zug); F-G1-4(b)-Wrapper (Papier bis Kollektor-Bau).

SELBSTCHECK: ASCII-only; keine Owner-Frage neu gestellt; keine Datei ausser dieser hier
geschrieben; alle Zeilen-/Zahl-Angaben am Objekt bzw. an der benannten Quelle nachgelesen
(Stand ce 66de5c09, 21.08.2026).
