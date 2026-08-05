# OWNER-VORLAGE V4 (Neuauflage, entscheidungsreif) — Mess-Vorfeld-Entscheide + NUR-KENNTNIS-Bestand

Stand: 05.08.2026 abend · super HEAD 52f3c988 (Ledger 4234 Z.) · ce 18fbb950/60c7c56a (Gate 405)
Ersetzt die NIE UEBERGEBENE V4 vom 04.08. (`docs/sessions/20260804-OWNER-VORLAGE-v4-nur-kenntnis-struktur-audit-und-e24-nachlese.md`); V3b-Paragraphen gelten fort, soweit hier nicht neu gefasst.

**KLASSE DIESER NACHRICHT (E-21/Freeze-Regel):** KEIN Arbeitsauftrag. Teil A = ENTSCHEIDE
(Rueckmeldung erbeten; je Punkt ist ein DEFAULT BEI SCHWEIGEN benannt — es passiert nichts
Unbenanntes). Teil B = NUR-KENNTNIS (keine Antwort noetig, Einspruch jederzeit).
Kalender-Rahmen unveraendert: Trigger-Ziel Do 07.08., Abgabe Fr 08.08., Messung = USER-GO.

---

## TEIL A — ENTSCHEIDE (9)

### A1 · Posten 74 — OOM-Absturzpfad im layout_aware-Knotenspeicher (einziger echter Vor-Mess-BAU-Kandidat)

**Sachlage.** Der Knotenspeicher `layout_aware` (der Baustein, der die 5 Speicher-Layouts der
Messung traegt) fordert seine Datensatz-Bytes direkt bei der Allokator-Strategie an und prueft
die Antwort nicht: Meldet die Strategie "kein Speicher" (per Null-Zeiger — bei Budget-/NUMA-
Strategien ein regulaerer, kein exotischer Fall), schreibt der Code trotzdem hinein
(`axis_04_node_type_layout_aware_store.hpp:269-270`, ebenso Kopierpfad `:631-634`) — das ist
undefiniertes Verhalten, praktisch ein Absturz. Der parallele Weg ueber den Chunk-Index wurde
mit Posten 64 bereits geheilt (dort wird der Null-Zeiger in eine ordentliche C++-Ausnahme
uebersetzt, `axis_06_allocator_strategy_base.hpp:222-224`); genau dieser Wurf-Vertrag fehlt am
Roh-Pfad noch. Zusatz-Nuance: Wirft beim Kopieren der Index mitten im Vorgang, leckt bereits
gezogener Speicher und verfaelscht die Allokator-Statistik-Spalten. Am golden-Stand (grosse
Budgets) wird der Pfad nie getroffen — das Risiko liegt ausschliesslich in der Mess-Matrix mit
knappen Budget-/NUMA-Zellen.

**Konsequenz fuers Messbild.** Ungeheilt erzeugt ein OOM waehrend eines Messlaufs statt einer
sauberen `failed`-CSV-Zeile einen Absturz des Messprozesses — eine Zelle kann den ganzen
Mess-Job samt Nachbar-Zellen mitreissen (Kanon-Konflikt: Fehler muessen als 'failed' sichtbar
werden koennen).

**Optionen.**
- **(A) Wurf-Vertrag nachziehen (Posten-64-Klasse):** Null-Zeiger pruefen, `std::bad_alloc`
  werfen, Kopierpfad exception-sicher rueckbauen; kleine Scheibe (2 Funktionen + 1 Negativ-Test
  nach test_h64-Vorbild), golden-neutral. Messbild: OOM wird zur 'failed'-Zeile, Lauf ueberlebt.
- **(B) Deklarieren statt heilen:** Mess-XML so schneiden, dass budget-knappe Allokator-Zellen
  nie mit layout_aware kombiniert werden. Kein Code-Risiko, aber stille Vertragsluecke im
  Messfenster.
- **(C) Nichts tun:** verletzt die eigene Ledger-Deklaration ("VOR Messbeginn") und den
  Fehlerklassen-Kanon.

**EMPFEHLUNG + DEFAULT BEI SCHWEIGEN: (A)** als kleine Scheibe VOR Messbeginn (exakt die
bereits gelandete Entscheid- und Test-Schablone von Posten 64). Traegt das Kalenderfenster die
Scheibe nicht, Rueckfall (B) mit expliziter Budget-Headroom-Deklaration im Mess-Dossier und
offen markiertem Posten.

### A2 · Posten 77 — SuRF-Suffix R16 kollabiert auf kurzen Schluesseln (papertreu; reiner Interpretations-Entscheid)

**Sachlage.** Der Trie-Filter SuRF kann je Schluessel zusaetzliche "Suffix-Bits" speichern
(4/8/16), die Falsch-Positive reduzieren. Sind die Schluessel zu kurz (dichte Integer-
Schluessel: unterhalb des Baum-Blatts bleiben nur 8 Bit Rest), gibt es fuer 16 Suffix-Bits
nichts zu speichern — der Filter speichert "keine Info" und verhaelt sich wie ohne Suffix,
zahlt aber weiterhin 16 Bit pro Schluessel (Satz A literal: R16 identisch zu "ohne Suffix" bei
bpk 30.09 statt 14.09; die Kurve Falsch-Positiv-Rate vs. Bits/Schluessel ist dort NICHT
monoton, R8 schlaegt R16). **Verifiziert: exakt dieselbe Semantik im mitgefuehrten Original**
(`ext/.../SuRF/include/suffix.hpp:43-46,216-219`) — kein Bug der Adaption, papertreu; Membership
bit-identisch belegt. Liegt NICHT im T14-Messpfad, sondern in den SuRF-Tuning-Kurven.

**Konsequenz fuers Messbild.** Wer die Kurve ohne Schluessel-Verteilungs-Kontext liest, haelt
den Knick fuer einen Messfehler; tatsaechlich ist er eine echte, thesis-taugliche Eigenschaft
von SuRF auf dieser Verteilung. Nur eine automatische Min/Max-Heuristik wuerde R16 faelschlich
als generell dominiert verwerfen.

**Optionen.**
- **(A) Behalten + Lese-Regel festschreiben:** Kollaps-Bedingung (Suffix-Laenge vs. Rest-Bits)
  als Fussnote an die betroffenen Kurven; Schluessel-Saetze der Mess-XML bewusst waehlen
  (kurze UND lange Schluessel als getrennte Zellen).
- **(B) Zusaetzlich billige Test-Wache:** Bestandstest um einen Tief-Schluessel-Satz erweitern,
  der den Kollaps als GEPINNTES Verhalten dokumentiert (heutiger Test prueft nur flache Keys).
- **(C) Semantik aendern:** verletzt Papertreue-Doktrin, risse Bit-Identitaets-Beleg und
  Wachen — ausgeschlossen vor Abgabe.

**EMPFEHLUNG + DEFAULT BEI SCHWEIGEN: (A)+(B)** — kein Code-Eingriff am Filter, Doku- und
Test-Aufwand in Minuten, kalender-ehrlich.

### A3 · Posten 78 — XorFilter meldet 30/256 gespeicherte Schluessel als "nicht enthalten" (deklarierter Adaptions-Abstrich, direkt im T14-Messpfad)

**Sachlage.** Der Xor-Filter der Filter-Achse ist eine eigene, paper-referenzierte
Nachimplementierung (unter `ext/` existiert KEIN Xor-Original — die Faithful-Doktrin ist
NICHT beruehrt) und verzichtet bewusst auf das "Peeling" des Original-Verfahrens (im Code-Kopf
`axis_filter_xor.hpp:43-46` seit 04.06. selbst deklariert). Folge: echte False Negatives —
im 256er-Scan werden 30 von 256 gespeicherten Schluesseln (~11,7%) als "nicht enthalten"
gemeldet. Das verletzt den Vertrag der Filter-Achse (Falsch-Positive erlaubt, Falsch-Negative
verboten) und liegt — anders als A2 — DIREKT im T14-Messpfad. Die Zeit-/Multiplizitaets-
Messung des Abfrage-Pfads (3 Slot-Reads) ist dagegen papertreu und vergleichbar. Eine
Test-Wache pinnt den Befund beidseitig und faellt absichtlich, sobald jemand heilt.

**Konsequenz fuers Messbild.** Ohne Entscheid stuende die xor-Zeile gleichberechtigt neben den
FN-freien Filtern in derselben CSV — jede aus pos/neg abgeleitete Groesse waere fuer xor
nicht vertrags-vergleichbar (stille Verfaelschung).

**Optionen.**
- **(A) Jetzt heilen (Offline-Peeling):** Der Bau-Schritt ist "Setup, nicht gemessen", die
  Heilung waere mess-neutral fuer den Abfrage-Pfad — aber eine echte Bau-Scheibe in der
  knappsten Phase (Heap im bisher heap-freien Organ, Wache drehen, neue Tests).
- **(B) Behalten + deklarieren:** xor-Zelle im Dossier/Thesis verbindlich als
  "Probe-Kosten-Messpunkt, KEIN Membership-Beleg" markieren (der rigorose Membership-Beleg
  laeuft ohnehin ueber Bloom/Cuckoo); pos/neg der xor-Zelle aus Vertrags-Vergleichen
  ausschliessen; Heilung als registrierter Nach-Abgabe-Posten (die Wache ist als
  Heilungs-Detektor gebaut).
- **(C) xor aus der Matrix nehmen:** verliert den 4. Familien-Kontrastpunkt (Multiplizitaet 3
  zwischen Cuckoo 2 und Bloom 4) ohne Not.

**EMPFEHLUNG + DEFAULT BEI SCHWEIGEN: (B)** fuer die Abgabe-Strecke, (A) als Nach-Abgabe-
Posten registriert. (A) nur vorziehen, falls Sie den Membership-Vertrag ALLER vier Filter fuer
die Messung als KERN einstufen.

### A4 · KF-6-Warnung — Mess-Puffer-Konstante wird bei Cache-Lines > 64 zum Ueber-Lesen (Terminierungs-Zusage, KEIN Sofort-Bau)

**Sachlage.** Der Mess-Treiber legt seinen Layout-Scan-Puffer mit der fixen Konstante
"64 Byte je Datensatz = groesstmoeglicher Layout-Schritt" an (`abi_adapter.hpp:460-464`,
Spiegel-Stellen `:560`/`:691`). Das stimmt nur, solange die Cache-Line-Groesse fest 64 ist —
heute der Fall. Das KF-6-Fenster (Posten 62) macht die Line-Groesse permutierbar, und die
Studien-XML fuehrt bereits 128/256: dann laese der Scan weit hinter das Pufferende — kein
erzwungener Absturz, sondern **stumm plausible, systematisch verfaelschte Kurven genau in der
Dimension, die die Cacheline-Studie messen will** (gefaehrlichste Verfaelschungs-Klasse).
Die Datei ist G8-gesperrt (ABI-Flaeche, Owner-Fenster); die Konstante dupliziert zudem
Achsen-Wissen im Treiber und kollidiert mit Ihrer generalisierten Schnitt-Regel vom 04.08.

**Konsequenz fuers Messbild.** Am Ist (Line fest 64) ist NICHTS betroffen; das Risiko gilt
exklusiv der ersten Cacheline-Studie nach dem KF-6-Fenster.

**Optionen.**
- **(A) Parametrisch aus der Achse ableiten** (Puffergroesse = Datensaetze x maximaler
  Layout-Schritt aus der Cacheline-/Layout-Achse, Schnitt-Regel-konform) **+ static_assert-
  Wache**, die den Vergessens-Fall compile-hart macht; Spiegel-Stellen im selben Zug.
- **(B) Fixe Ober-Kappe 256:** simpel, dupliziert aber XML-Wissen und bricht bei der
  naechsten XML-Erweiterung stumm — dieselbe Falle eine Stufe hoeher.
- **(C) Studie auf Line <= 64 kappen:** verstuemmelt die Studie (These verlangt 32/64/128) —
  keine echte Option.

**EMPFEHLUNG + DEFAULT BEI SCHWEIGEN: (A), fest als Pflicht-Item an die KF-6-Scheibe
gebunden** (nicht frueher: G8-Sperre; nicht spaeter: sonst misst die erste Cacheline-Studie
hinterm Puffer). Erbeten ist hier nur Ihre Bestaetigung der Fenster-Bindung — kein Bau jetzt.

### A5 · Posten 60 — Terminierung der benannten Regression "SortedArrayKeySet" (Auflagen-Erfuellung)

**Sachlage.** Ein selbst als Interim deklarierter Such-Baustein im Anatomy-Teil
(`anatomy/set_default_organ.hpp:18-38`) ist ein Organ-Algorithmus OHNE Achsen-Zuordnung —
nach Ihrer Regressions-Definition (Ledger:3931) eine benannte Regression. Ihre Auflage war,
die Terminierung im naechsten Kenntnis-Block vorzulegen — das geschieht hiermit.

**Optionen.**
- **(A) NACH Abgabe im Aufraeumpass** durch echten search_algo-Achsen-Wrapper ersetzen
  (Ledger:3952 bereits so deklariert). Kein Messeinfluss.
- **(B) Vor Messbeginn ersetzen:** semantischer Umbau in der knappsten Phase ohne Messgewinn.

**EMPFEHLUNG + DEFAULT BEI SCHWEIGEN: (A)** — Terminierung: Abschluss-Aufraeumpass nach
Abgabe; Einspruch jederzeit moeglich.

### A6 · SF-1 — Heilungs-Fenster der einzigen Layering-Verletzung (GO-Frage aus Alt-V4 Par.2, unveraendert offen)

**Sachlage.** Der Struktur-Audit fand genau EINEN Schnitt-Fehler: eine einzige Aufwaerts-Kante
vom Fundament (anatomy) in die darueberliegende Bau-Schicht (builder)
(`container_framework.hpp:37` -> `genus_binding_traits.hpp`). Compile-sauber, golden-gruen,
kein Datei-Zyklus — aber eine Verletzung des in Stein gemeisselten Baseline-Layerings. Die
Heilung (Traits-Split) ist rein strukturell; die Datei ist jedoch ABI-sichtbare G8-Flaeche
und wird darum NIE still geheilt, nur in einem Owner-Fenster.

**Optionen.** (a) Fenster nach Anker VOR Trigger (Re-Pruef-Kosten im engen Kalender) ·
(b) NACH Abgabe im Abschluss-Aufraeumpass · (c) dauerhaft belassen.

**EMPFEHLUNG + DEFAULT BEI SCHWEIGEN: (b)** — strukturell, nicht funktional; kein
Messeinfluss; benannter Posten, keine stille Ausfuehrung.

### A7 · F27/#48 — Wiedervorlage: Sync-Gate-Umhaengung auf die kanonische golden-XML (3 Wochen Stillstand)

**Sachlage.** Die kanonische `experiment_golden_kern.xml` existiert und IST seit 27.07. der
Kanon. Offen ist seit 16.07. (user-gated) einzig die Umhaengung des Sync-Gates: die Wache
`fixture_sync_check.cmake:3` prueft noch das ALT-Paar. Der Sweep empfiehlt nach 3 Wochen ohne
Bewegung die Wiedervorlage.

**Optionen.**
- **(A) GO zur Umhaengung** aufs kanonische Kern-Paar: kleine, klar umrissene Aenderung;
  danach wacht das Gate ueber das richtige Paar. Beruehrt aber das golden-Gate in der
  heissen Phase (Re-Pruef-Lauf noetig).
- **(B) Ausdruecklich weiter parken** mit benanntem Wiedervorlage-Traeger (naechster
  Owner-Block bzw. Aufraeumpass).

**EMPFEHLUNG: OFFEN** — die Recherche gibt keine belastbare zeitliche Empfehlung her; sachlich
spricht nichts gegen (A), das Timing haengt allein an Ihrer Risiko-Abwaegung fuers golden-Gate
vor dem Trigger. **DEFAULT BEI SCHWEIGEN: (B)** (Status quo, Wiedervorlage im Aufraeumpass).

### A8 · G5-Pruning "#35 verify_remote_then_prune" — Vollzug oder ausdrueckliches Supersede (O-3-Gate benennen)

**Sachlage.** Die Direktive #35 ("Lager-Pruning lokal auf 0, erst nach Remote-Verifikation")
wurde nie vollzogen und nie ausdruecklich zurueckgenommen. Die Anker-Inventur legte fest:
"Alt-Bestaende bleiben ADDITIV liegen — KEIN Loesch-Schritt" (Ledger:4171) — das deckt das
Nicht-Vollziehen faktisch, aber ein Vermerk fehlt, und das dritte Owner-Gate O-3 (Loesch-GO)
fehlt laut Sweep im Board.

**Optionen.**
- **(A) Ausdrueckliches SUPERSEDE vermerken:** #35 gilt als durch die Anker-Inventur gedeckt;
  O-3 als Gate im Board nachtragen; jede spaetere Loeschung bleibt hinter O-3. Kein
  Loesch-Vorgang, reine Buchfuehrung.
- **(B) Vollzug jetzt:** kollidiert mit der additiven Doktrin der Anker-Inventur und dem
  Kalender.

**EMPFEHLUNG + DEFAULT BEI SCHWEIGEN: (A)** — Supersede-Vermerk + O-3-Board-Eintrag; geloescht
wird weiterhin nichts ohne Ihr explizites GO.

### A9 · Loesch-Fragen der O-3-Klasse: /tmp-Alt-Wurzel + 2,4-GB-Referenz-Build

**Sachlage.** Zwei konkrete, klar abgegrenzte Loesch-Kandidaten warten auf explizites GO:
1. **/tmp/comdare_test_1001** (16.119 Eintraege): alte Test-Temporaer-Wurzel; seit
   Haertung [69] laufen alle Tests in build-getaggte neue Wurzeln, die Alt-Wurzel bekommt
   0 neue Eintraege. Reine Testreste, KEINE Messdaten — die Messdaten-Doktrin ist nicht
   beruehrt. Die Loesch-Frage wurde ausdruecklich in diesen Block gelegt.
2. **wt-w10/build-lc.stale-pfad, 2,4 GB** (Alt-V4 Par.8): Vor-W10-Referenz-Build, Zweck
   erfuellt und dokumentiert; prod1 war bei 95% Plattenfuellung.

**Optionen je Kandidat:** GO loeschen · liegen lassen bis Aufraeumpass.

**EMPFEHLUNG:** (1) **GO zum Loeschen empfohlen** (Testreste ohne Schutzwuerdigkeit, Platz +
Hygiene). (2) **loeschbar**; vor jedem rm eines Build-Verzeichnisses gilt die Auflage der
Mess-CSV-Pruefung (Kanon: Build-Verzeichnisse koennen getrackte Mess-CSV tragen).
**DEFAULT BEI SCHWEIGEN fuer beide: bleibt liegen bis Aufraeumpass** — geloescht wird nur auf
Ihr explizites GO.

---

## TEIL B — NUR-KENNTNIS (kompakt; keine Antwort noetig, Einspruch jederzeit)

**B0 · Status der Alt-Vorlage V4 (04.08., nie uebergeben).** Par.1 (Struktur-Audit-Quittung:
genau EIN Schnitt-Fehler = SF-1, alles andere bestaetigt), Par.3 (E-24-Nachlese) und Par.4
(E4 + E14 nach Abgabe) gelten unveraendert als Kenntnis. Par.7b ist VOLLZOGEN quittiert
(EV-4-Grenzen in 01c-3 an original_* deklariert + bewiesen). Par.7 war STALE und ist hier
ersetzt durch B1.

**B1 · Lage neu (ersetzt Alt-Par.7).** Anker VOLLZOGEN (GATE 5), Job-Sperre BEENDET;
S4/S5/01a-01c/Q-Welle/Phase B/A2-Eichung gelandet; W1 Planer-Split gelandet (Gate 405).
Kalenderteil gilt fort: Trigger-Ziel Do 07.08., Messung = USER-GO.

**B2 · K1-K4 XML-Rueckfrage-Kandidaten (Nach-Abgabe-Default steht).** K1 per-K-Handschreibung
(4 Leaf-Klassen nur wegen grep-Literal des F30-Guards) · K2 = Posten 81 (gesamte
D1-Fassaden-Ebene nur wegen literaler type=/wrapper=-Spiegelung; Belegstand nach 22 Organen
liegt vor) · K3 ORGAN_LOCATION-Literal-Duplikation (Gate beweist Identitaet bereits) ·
K4 Sichtbarkeit der 18 Default-OFF-Organe (heute nur Abwesenheits-Beweis; die offene
Q-1-Rueckfrage beruehrt K4). Alle vier werden NACH Abgabe gebuendelt VERBOSE vorgelegt
(E-21-Form); Grundlage Ihr KERN nacht-2 (XML-Syntax-Aenderungen als Rueckfrage-Gate).

**B3 · Platten-/Tempdir-Vollzuege (kein GO noetig).** Alt-Mess-CSV-Loeschung war am 21.07.
punktuell owner-gedeckt vollzogen; Ebene-B-Alt-Bestaende bleiben additiv liegen
(Anker-Inventur); Tempdir-Neubau laeuft build-getaggt (Haertung [69]).

**B4 · Posten-Register-Stand (Sweep Kat. C — geparkt MIT Beleg).** Nach-Abgabe-Band
unveraendert owner-gedeckt (R3-Rest, #35-.so, #54-b, W3-Vollausbau, W2-Codegen-Zielform,
K1-K4, Posten-Register, Hybrid-Bau, #32, PL-21, #47) · L21-Behaelter: Rest nach Abgabe
PFLICHT (Ihr H.7) · f2/f3-Remote-GOs terminiert · Posten 43/67/81/90/50 je mit Beleg ·
R6 "Planer taktet selbst" Nach-Abgabe (nur Board-Namensnennung fehlt) · Mess->PDF-E2E =
Phase 6 · S-7 geparkt · INC-5/6 infra-delegiert · Datensatz 6-vs-48 user-gated ·
3 Overlay-Festlegungen nicht-blockierend, Wiedervorlage-Traeger = genau dieses Buendel ·
pre-rescrub-Backup bleibt (additiv) · rescue/e24-c3-wip als Quelle im W3-Posten vermerken ·
PhasenCheck-5.16-Rest nach Phase 7; §75-Aufraeumpass wird im Board namentlich verankert.

**B5 · Vermerk-Nachzuege (Sweep Kat. D — unverbucht erledigt, nur Quittung).** L20-NEIN-Liste
stale: 8 Worktrees nur noch abraeumbar · rescue/w2c-* patch-aequivalent gelandet ·
D-11-Rename (external_utils) faktisch gelandet · K4-Doku-Frage der ce-Doku-Liste (NICHT das
XML-K4 aus B2) laengst per Ihr mittag-11 superseded — Vermerk an Design-Doc:443-444 +
hybrid/README.md:54-56 wird nachgezogen · Posten 30 / W12-B / Coverage-#18 je wohl subsumiert
(Vermerke werden nachgezogen) · §52-B14-Rest durch W5-Kern gedeckt.

**B6 · R-G2 / Folge-Posten (92) — bewusste Abweichung beim W1-Planer-Split.** Die
Registry-Kanon-Divergenz (validate-Pfad nutzt die 2er-, plan-Pfad die 3er-Form) wurde beim
W1-Split MITGENOMMEN statt vereinheitlicht, weil die Vereinheitlichung die validate-Semantik
unter Frist geaendert haette; als benannter Folge-Posten (92) registriert (Ledger:4154).
Owner-Einspruch moeglich, sonst Nach-Abgabe.

**B7 · Weiter OFFENE Fenster ohne belastbare Empfehlung (ehrlich markiert).**
(i) Alt-Par.5-Fenster: Katalog P2-P8 = CSV-Schema-Ereignisse (Fenster-Zuordnung offen) und
Peak-Quelle Wire-Slot vs. Zeitreihe (Spalte 'n/a') — beide weiter unentschieden; die
Recherche gibt hier KEINE Empfehlung her; Wiedervorlage spaetestens vor der betroffenen
Auswertungs-Phase. (ii) Alt-Par.6/L18: die ETA-Teilmenge (--print-env, %/ETA, JSON-Marker)
haengt per Ledger:3861 an Phase 5/6, waehrend der Ist-Anker den R3-Rest pauschal nach Abgabe
fuehrt — der Zuordnungs-Entscheid ist noetig, aber ohne Empfehlungs-Grundlage aus der
Recherche; Wiedervorlage im naechsten Owner-Block.
