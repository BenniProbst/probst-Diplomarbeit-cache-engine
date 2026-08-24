# SOLL-KARTE — Strang trigfix (S2: E-7/R-12 E-07-Gate-Kriterien + E-8/R-13 unwahre Messgroessen)

Erhoben (NUR LESEND) fuer das W2-Audit-Fix-Verify. Objekt: ce `bau/trigfix` @ `0f900dcf`
(Basis ce `66de5c09` / super `a7e8e151` / prt-art `777fff7`). Strang-Bericht VOLL gelesen:
`/home/comdare/backups-workflow/20260820-w2-sofortstaffel/trigger-fixzellen-ergebnis.md`.

## VORBEFUND (Bestands-Pflicht vor Neubau — hier dokumentiert, nicht uebergangen)

An diesem exakten Pfad lag beim Start dieser Erhebung bereits eine SOLL-KARTE (21.08., 392 Z.)
UND ein `audit-runde-1.md` (21.08. + ANNEX 22.08., **VERDIKT: SITZT**, 0 ERNST/0 MILD/3 KLEIN,
alle P-01..P-19 am 22.08. mit frischen Git-Literalen re-verifiziert). Diese Erhebung wurde
GEGENSTAND-BLIND durchgefuehrt — alle SOLL-QUELLEN wurden unabhaengig neu gelesen, bevor die
Existenz der Vorlage per `ls` beim Anlegen des Zielordners auffiel. Die vorliegende Fassung ist
daher eine ECHTE zweite, unabhaengige Re-Derivation (kein Abschreiben), die im Ergebnis auf fast
allen Punkten mit Runde 1 KONVERGIERT (starke V11-Belegzeile-Bestaetigung: zwei unabhaengige
Messungen desselben Objekts treffen sich). Wo diese Fassung etwas NEUES traegt, das weder die
Runde-1-Soll-Karte noch der Audit aufgeworfen haben, ist es explizit als **[NEU ggue. Runde 1]**
markiert (drei Stellen: P-07a, SPANNUNG 5, SPANNUNG 6). Alles andere bestaetigt Runde 1 aus
unabhaengiger zweiter Quelle.

**NACHTRAG (23.08., selbiger Tag, spaeter):** eine DRITTE, wieder gegenstand-blind begonnene
Erhebung an diesem Pfad hat diese Fassung vollstaendig bestaetigt, inklusive einer gezielten
Nachpruefung der drei oben genannten [NEU]-Stellen (die `audit-runde-1.md` zeitlich nicht mehr
erreichen konnte) — s. Abschnitt **RUNDE 3** am Dateiende.

Wahrheits-Rangfolge angewandt: Owner-Wort > juengere KON > Wellenplan par.21-23 > par.17-20 >
Designplan > W2-ABFOLGE-DESIGN > Strang-Bericht. Ergebnis wie in Runde 1: **keine** der juengeren
Schichten (LEAD-ENTSCHEIDE 20.08. — voll gelesen, 87 Z., 0 trigfix-spezifische Eintraege; Wellenplan
par.21-23; Ledger-Nachtraege nach dem 21.08.) traegt einen eigenen, namentlichen Eintrag zu
R-12/R-13/E-07/CLU-64/bytes_in_use_peak. Die tragende Schicht ist durchgehend Wellenplan §19.7
(Zeilen 2646-2647) + der aeltere Ledger-Bereich um KON-Vorlaeufer (05.-06.08.), der selbst schon
Nachbuchungs-Charakter traegt. Das ist geprueftes NEGATIVES Ergebnis, kein Uebersehen.

---

## PRUEFLISTE

### A) R-12 — E-07-Gate-Kriterien (Position B10)

**P-01 — Grundauftrag: Kriterien muessen als Code existieren.**
WAS (woertlich): *"E-7 R-12 E-07-GATE-KRITERIEN (0 Treffer im Code; Position B10
TRIGGER-BLOCKIEREND). QUELLE K2:§19.7 R-12. ABNAHME: Kriterien implementiert."*
(`W2-ABFOLGE-DESIGN.md:472-473`, wortgleich in der Abhaengigkeits-Graph-Zeile `:771`). Primaerquelle:
`Wellenplan v2:2646` — `R-12 | E-07-Gate: Kriterien 0 Treffer im Code; Position B10
trigger-blockierend | r3 C4 | P | vor 26.08.`
WIE pruefbar: `grep -rn 'E07_' <ce, hpp/cpp/cmake/sh/yml, ohne build/>` — vor Fix 0 Treffer, nach
Fix >0 (Datei `libs/cache_engine/profile_facade/e07_gate_kriterien.hpp` + `ctest -N` zeigt den
neuen Test).
BEHAUPTET: JA — Strang-Bericht Abschn. 1.3 (V0/V1 am Objekt: 0 Treffer vor Fix, Gegenprobe
`COMDARE_GOLDEN_N_RANGE`=30 Treffer als Wirksamkeitsbeweis des Greps) + Abschn. 3 (Bau) + Abschn. 7
(Commit `0f900dcf`, Datei NEU, `BAU-OK`).

**P-02 — Vollstaendigkeit der 10 Kriterien / Pflicht-Literale gegen die 03.08.-Dossier-Definition.**
WAS (woertlich, Definitionsquelle `docs/sessions/backups/20260803-design-nachtraege-final/
E07-gate-definition-dossier.md:64`, per Ledger-Nachbuchung zitiert): *"GO-Kriterium E-07: K1-K5 UND
N1-N3 saemtlich mit literalen Zeilen erfuellt."* Kriterien-Katalog (Strang-Bericht Abschn. 1.2,
gegen die Dossier-Struktur gezaehlt): K1 (3 Literale) · K2 (1) · K3a (3) · K3b (3, davon 1 mit K3c
geteilt) · K3c (2 neue) · K4 (4 in der Primaerquelle, im Code auf 5 geschaerft, s. u.) · K5 (2) ·
N1 (1) · N2 (1) · N3 (2) = 10 Kriterien-Familien.
WIE pruefbar: `kPflichtLiterale`-Tabelle in `e07_gate_kriterien.hpp` gegen die Dossier-Tabelle
zaehlen; jede Kriteriums-Familie muss im Code als eigener Pruefzweig auftauchen.
BEHAUPTET: JA, mit offengelegter SCHAERFUNG: der Strang fuehrt 23 Literale (nicht 22 wie in der
Primaerquelle roh gezaehlt), weil `E07_WINDOW_COUNT` als zusaetzliches K4-Pflicht-Literal ergaenzt
wurde ("Schaerfungen (B5.a-Regel 'nur schaerfen/parametrisieren')", Abschn. 3). Das ist die in der
Primaerquelle selbst erlaubte Klasse (Dossier Abschn. 2, Stufe B5.a: schaerfen/parametrisieren
erlaubt, abschwaechen nicht) — keine stille Abweichung, sondern eine deklarierte, regelkonforme
Ergaenzung.

**P-03 — Fail-closed-Verhalten des Pruefers.**
WAS: *"Kann eine Wache nicht pruefen — Werkzeug fehlt, API antwortet nicht, Verzeichnis fehlt —,
ist das rot oder Abbruch, nie gruen. Ein stiller Rueckfall ist ausdruecklich ein Fehler."*
(`GOAL-v8:305-308`, TEIL II.7 "Fail-closed"). Ergaenzt durch die Dossier-eigene
"Ungueltigkeits-Regel: Differenz-Probe mit erwartetem Delta 0 ist UNGUELTIG (Anti-Schein-Gruen)."
WIE pruefbar: leeres Protokoll, unbekannter `E07_`-Schluessel, Wert-Widerspruch, nicht-dezimaler
Wert, 0/1-Flag>1, Delta-0-Probe muessen alle NO-GO/Befund erzeugen, niemals stillschweigend GO.
BEHAUPTET: JA — 6 Fehlerklassen benannt (FEHLT/UNBEKANNT/KONFLIKT/UNLESBAR/WERTEBEREICH/UNGUELTIG)
+ "leeres Protokoll = NO-GO"; zusaetzlich eine "Echo-Gruen-Sperre (Verdikt-Rueckeinspeisung faellt
durch)" als eigene Haertung ueber die genannten Klassen hinaus (Abschn. 3).

**P-04 — Nenner in der Ausgabe (kein nackter Boolean).**
WAS: *"Nicht 'drei Fehler', sondern 'drei von 14 Jobs'. ... Der wirksame Fix ist immer derselbe:
den Nenner in die AUSGABE des Werkzeugs zwingen."* (`GOAL-v8` TEIL II.5).
WIE pruefbar: Protokoll-Ausgabe muss `E07_GATE_KRITERIEN_ERFUELLT=<k>/10` und
`E07_GATE_PFLICHT_LITERALE=<p>/23` literal enthalten, nicht nur ein bestandenes/nicht-bestandenes
Flag.
BEHAUPTET: JA — "`protokoll()` emittiert IMMER `E07_GATE_KRITERIEN_ERFUELLT=<k>/10`,
`E07_GATE_PFLICHT_LITERALE=<p>/23`, `E07_GATE_BEFUNDE=<n>` + Befundzeilen, Schlusszeile
`E07_GATE=GO|NO-GO`" (Abschn. 3).

**P-05 — Koeder beidseitig (K13).**
WAS: *"Eine Wache gilt erst dann als gebaut, wenn ein zufaellig erzeugter Koeder sie zum Beissen
bringt ... Beide Richtungen fahren: der Positiv-Fall ist der Nenner; ohne ihn koennte die Wache
konstant rot sein."* (`GOAL-v8:295-299`, K13). Identisch im Aufgaben-Steckbrief gefordert: "Koeder
beidseitig".
WIE pruefbar: mindestens 1 gruener Positiv-Fall (echtes GO bei konsistentem Protokoll) UND je der
10 Kriterien/23 Literale mindestens 1 beissender Rot-Koeder.
BEHAUPTET: JA, woertlich "KOEDER BEIDSEITIG" als Abschnittstitel (Abschn. 3): Seite GRUEN
(arithmetisch konsistentes Protokoll -> GO 10/10, 23/23) + Seite ROT (leeres Protokoll; JEDES der
23 Literale einzeln entfernt in einer Schleife; >=1 Koeder je Kriterium; diverse Gegeneingaenge).

**P-06 — T-7 Registrierung ist Teil des Tests (+ TABU-Konformitaet DATEIENDE).**
WAS: *"Ein Test existiert erst, wenn er in `ctest -N` erscheint und sein Binary im Bauweg haengt;
Registrierungs-Bissprobe ... gehoert zur Abnahme."* (`Designplan-tdd:73`, T-7). Bindend zusaetzlich
per Workflow-Regel: "tests/unit/CMakeLists.txt NUR ans DATEIENDE".
WIE pruefbar: `ctest -N` zeigt `test_e07_gate_kriterien`; Eintrag liegt am Ende von
`tests/unit/CMakeLists.txt`, nichts folgt danach; Gesamt-ctest-Bilanz-Delta == Anzahl neuer TUs.
BEHAUPTET: JA — "Registrierung am DATEIENDE tests/unit/CMakeLists.txt (eigener Staffel-Block)",
Labels "e07;gate;kriterien;b10;wachen;koeder"; Bilanz "510 -> 512 = +2, Dedup-Gegenzaehlung stimmt"
(Abschn. 7).

**P-07 — Abgrenzung: "Kriterien implementiert" ist NICHT "Gate GO/Beweis erbracht".**
WAS: die ABNAHME-Formel selbst (`W2-ABFOLGE-DESIGN.md:473`) lautet nur *"Kriterien
implementiert"* — nicht "Gate bestanden". Der eigentliche Beweislauf (Stufe B5.b: Mini-Profil
<=8 Binaries + XML-Differenz-Laeufe je Achsen-Familie, der die realen `E07_*`-Zeilen emittiert) ist
in der Primaerquelle als SPAETERER, eigener Schritt definiert (Dossier, "empfohlen NACH
A13-M3+E-24").
WIE pruefbar: der 5-Dateien-Diff darf KEINEN Harness/Emitter enthalten, der `e07_gate_auswerten()`
gegen einen echten `profile_run_facade`-Lauf aufruft.
BEHAUPTET: konsistent NICHT geliefert, explizit als offen deklariert (Abschn. 8 Punkt 1: "B10-
BEWEISLAUF (B5.b) bleibt offen ... NICHT Teil dieser Fixzelle"), gedeckt durch STAFFEL2-SYNTHESE
F-100 (Z.190: "TEIL: Kriterien-PRUEFER GEBAUT ... B10-BEWEISLAUF ... OFFEN") und den
Aufgaben-Steckbrief selbst ("#114, NICHT Teil dieses Strangs").

**P-07a — [NEU ggue. Runde 1] Ist "Position B10" wirklich EIN Gegenstand, oder kollidiert das
Kuerzel mit einem zweiten, sachfremden Wellenplan-Posten?**
WAS: die VOR-TRIGGER-CHECKLISTE definiert `B10` (ohne Bindestrich) als *"V7.4-4+1-Beweise +
G6(J-0..J-5) auf GEEICHTEM Stand NEU erbringen (Variant-Gate-E2E seit A2 inert -- O-2-Kopplung)"*
(Ledger, Nachtrag 05.08.2026 abend-4 "LIEGENGEBLIEBENEN-SWEEP FERTIG"). Eine SPAETERE Nachbuchung
(Ledger, Nachtrag 06.08.2026 nachmittag-11 — Titel traegt selbst den Begriff "NAMENSKOLLISION")
bindet daran das E-07/B5-Kriterium: *"B10 traegt E-07/B5 (B+-Baum-Steuerungs-Nachweis),
trigger-blockierend. GO genau dann, wenn K1-K5 UND N1-N3 saemtlich mit literalen Zeilen erfuellt
sind."* UNABHAENGIG DAVON traegt der Wellenplan selbst, im GANZ ANDEREN Korb B (§19.2, Zeile ~303),
einen ZWEITEN, sachfremden Posten mit fast identischem Kuerzel: *"B-10 Hybrid-Delegation durch
CEB, compare->release VOR Hybrid-Dock (=HY-A-Vorbedingung)"* — ein Lager-/Hybrid-Thema, mit
E-07 inhaltlich NICHT verwandt (Bindestrich-Schreibweise `B-10` vs. `B10` in der Checkliste; beide
Schreibweisen kommen in den Quellen jeweils uneinheitlich vor).
WIE pruefbar: Audit sollte bei jeder Zitierung von "B10"/"B-10" den vollen Satzkontext lesen (nicht
nur das Kuerzel matchen) und im Zweifel per Volltext-Grep (nicht per Nummer) verifizieren, WELCHER
der beiden Gegenstaende gemeint ist.
BEHAUPTET: der Strang-Bericht selbst zieht die Trennung korrekt (zitiert nur die
VOR-TRIGGER-CHECKLISTE/E-07-Linie, nie die Hybrid-Delegation) — kein Fehler des Strangs, aber ein
Fallstrick, den weder die Runde-1-Soll-Karte noch `audit-runde-1.md` (Abschn. "Spannungen der
Soll-Karte") ausdruecklich benennen; ihre SPANNUNG 2 behandelt nur den Checklisten-Wortlaut
("generisch") vs. Nachbuchung, nicht die zweite, sachfremde `B-10`-Fundstelle in Korb B.

### B) R-13 — Zwei unwahre Messgroessen

**P-08 — Gegenstand + Frist.**
WAS: *"E-8 R-13 ZWEI UNWAHRE MESSGROESSEN (bytes_in_use_peak; CLU-64) vor erstem Batch heilen.
QUELLE K2:§19.7 R-13. ABNAHME: beide Groessen wahr/deklariert."* (`W2-ABFOLGE-DESIGN.md:474-475`).
Primaerzeile: `Wellenplan v2:2647` — `R-13 | Zwei unwahre Messgroessen (bytes_in_use_peak; CLU-64)
vor dem ersten Batch | r3 C5 | P | vor 26.08.` Ur-Fund (Ledger, Nachtrag "Zwei unwahre
Messgroessen vor der Messung", 06.08.): *"bytes_in_use_peak wird aus einem Momentanwert befuellt
(measurement_snapshot.hpp:124, der Kommentar sagt selbst 'END-Wert'); das Literal 64 ueberlebt die
B14-Heilung im CLU-Konsumenten (system_axis.hpp:336) ... Beide muessen vor dem ersten Batch
stehen -- danach tragen die vorher erhobenen Zeilen andere Semantik als die spaeteren: ein
Datenbruch ohne Neubau, unsichtbar."*
WIE pruefbar: je Groesse getrennt (P-09/P-10) einen Literal-Beleg verlangen; die ABNAHME-Formel
laesst ZWEI gueltige Erfuellungsklassen zu — "wahr" (Zahl korrekt) ODER "deklariert" (Zahl als
nicht-verfuegbar ausgewiesen, kein stiller Fehlwert).
BEHAUPTET: JA fuer beide, mit unterschiedlicher Erfuellungsklasse je Groesse (s. u.).

**P-09 — CLU-64: kein hartkodierter Divisor mehr, Verifikation statt Neubau.**
WAS: derselbe Ur-Fund wie P-08 (Literal 64 im CLU-Konsumenten `system_axis.hpp`).
WIE pruefbar: `system_axis.hpp`-CLU-Zweig darf `cache_lines`/`line_bytes` NICHT gegen ein
hartkodiertes `64` rechnen, sondern muss die Einheit aus dem Snapshot lesen und bei
`cache_lines==0 || line_bytes==0` fail-closed gehen; `test_b14_layout_scan_line_subaxis` +
`test_clu_per_layout` + `test_m_contract_system_axis_wurzel` muessen gruen laufen.
BEHAUPTET: JA, aber als **VERIFIKATION eines VOR diesem Strang bereits geheilten Zustands** — der
Strang-Bericht datiert die eigentliche Heilung auf den fremden Commit `c1c76c87` ("06.08.2026 …
die CLU-Kette bis zum LETZTEN Verbraucher geschlossen … B14-NB4") und liefert nur den
Testlauf-Beleg (Abschn. 2.1: "CLU-64 am Objekt = WAHR GEMACHT [Heilung zwischen Transkript-Anker
und Basis]; Rest-Auftrag = Verifikation per Testlauf"). Kein Code-Diff an `system_axis.hpp` im
Commit `0f900dcf` — konsistent mit dieser Einordnung. Zentraler SPANNUNGS-Punkt (s. u., SPANNUNG
1), aber keine Under-Delivery: die ABNAHME "wahr/deklariert" ist fuer CLU-64 in der Klasse
"wahr, per Verifikationslauf belegt" erfuellt.

**P-10 — bytes_in_use_peak: Schreiber-Zensus (T-6-Schwesterpflicht) + der eine echte Rest-Defekt.**
WAS: implizit aus der ABNAHME-Formel ("beide Groessen wahr/deklariert" deckt ALLE produktiven
Schreiber, nicht nur einen); ergaenzt um `Designplan-tdd:72` (T-6 Schwesterpflicht: "Jeder Fix und
jeder Test sucht im selben Zug die Schwesterstelle").
WIE pruefbar: vollstaendige Fundstellen-Liste aller produktiven `bytes_in_use_peak`-Schreiber
verlangen (nicht nur EIN Treffer); je Schreiber Klasse einordnen (WAHR / DEKLARIERT-EHRLICH /
UNWAHR-UNDEKLARIERT); nur bei UNWAHR-UNDEKLARIERT ist ein Fix mit Rot-vor-Fix Pflicht.
BEHAUPTET: JA — Strang-Bericht Abschn. 2.2 fuehrt einen Zensus von 6 Schreiber-Stellen
(`measurement_snapshot.hpp` DEKLARIERT/B7-Auflage · WIDE-Schema EHRLICH n/a · `system_axis.hpp`
MEMORY_FOOTPRINT EHRLICH SourceUnavailable · `f15_compare` Pfad A EHRLICH honest-0 · `f15_compare`
Pfad B deckt sich durch B7-Deklaration · `experiment_demo.hpp:79` **UNWAHR + UNDEKLARIERT**) und
fixt genau den einen unwahren Rest.

**P-10a — [Bezug NICHT-GEFORDERT/SPANNUNG 5] experiment_demo.hpp: live/peak-Zaehlung statt
kumulativer Summe.**
WAS: aus dem Zensus abgeleitet (kein eigener Wortlaut in den 6 SOLL-QUELLEN — diese Datei kommt
dort namentlich nicht vor; der Wellenplan-Posten deckt sie nur generisch als Teilmenge aller
Schreiber ab).
WIE pruefbar: `record.bytes_in_use_peak` darf NICHT mehr `stats.total_bytes_allocated` (monoton
wachsende Gesamtsumme) zuweisen, sondern muss `max(live_bytes)` ueber den tatsaechlichen
Alloc/Dealloc-Strom fuehren; Testfall mit >=1 Freigabe, bei dem `peak < total` gilt, ist Pflicht
(sonst waere `peak==total` auch im alten Fehlerfall zufaellig erfuellt).
BEHAUPTET: JA — `test_e8_bytes_in_use_peak_demo.cpp` (3 Tests): Peak-Strom live 1,2,3,2,1,2 ->
peak=384 < total=512 ("DER BISS"), plus monotoner Gegen-Strom (peak==total NUR ohne Freigaben) und
Read/Scan-Neutralitaet. T-1-Rot-Beleg literal: "512 / soll_peak ... 384" vor Fix, "[ PASSED ] 3
tests." danach.

**P-11 — Snapshot-POD-Pfad bleibt bewusst unangetastet (Owner-Auflage, keine Luecke).**
WAS: stehende Owner-/Katalog-Entscheidung "A8-S3" (04.08.) + "B7" + Katalog E2/E9 — Spaltenname
bleibt stabil, die ehrliche Aussage lebt in der parallelen WIDE-Schema-Spalte statt am
Momentanwert-POD selbst geaendert zu werden.
WIE pruefbar: `measurement_snapshot.hpp` darf im Diff NICHT auftauchen; WIDE-Schema
(`lazy_csv_header`) muss weiter `sample_status_token(SourceUnavailable)` == "n/a" fuer die
`alloc_`-Form liefern.
BEHAUPTET: JA — Abschn. 4: "Snapshot-Pfad (measurement_snapshot.hpp) NICHT angefasst: stehende
dokumentierte Entscheidung ... VORLAGE-ZEILE (owner-gated, NICHT gebaut)"; `measurement_snapshot.hpp`
fehlt im 5-Dateien-Diff.

**P-12 — CSV-Schema-Neutralitaet (kein ABI-/Spalten-Ereignis).**
WAS: implizit aus der Owner-Auflage A8-S3 (Spaltenname bleibt stabil) + der allgemeinen
Preimage-Klassen-Regel (§13.2 Wellenplan: nur echte PREIMAGE-wirksame Aenderungen brechen den
Freeze).
WIE pruefbar: Diff darf keine neue/umbenannte CSV-Spalte, keine XSD-Aenderung, keine ABI-Aenderung
tragen — nur eine Wertberechnung innerhalb einer bestehenden Struct-Zuweisung.
BEHAUPTET: JA — "Kein ABI-/CSV-Schema-Ereignis (gleiche Spalten, wahrer Wert)" (Abschn. 4).

### C) TDD-Vertrag (Designplan §3, T-1..T-9 — gilt "ab sofort fuer jedes Paket aller Wellen")

**P-13 — T-1 ROT ZUERST.** WAS (`Designplan-tdd:67`): *"Der Test ist am ersten Tag rot, ODER sein
Biss ist per protokollierter Wegwerf-Mutation bewiesen ... Beides fehlt = kein Test."* WIE
pruefbar: literaler Rot-Lauf je Testpaket. BEHAUPTET: JA fuer beide Pakete — R-13 echtes Rot am
unfixierten Objekt ("kein Wegwerf-Mutant noetig -- der Riss war der Bestand"); R-12
Wegwerf-Mutation `ergebnis.go = true || (...)` -> "20 FAILED TESTS von 22", nach Revert "22 tests"
gruen (Abschn. 5).

**P-14 — T-2 AUSSAGE, NICHT ANWESENHEIT.** WAS (`:68`): *"'find()', Existenz, Exit 0, 'wirft
nicht' sind keine Zusicherungen. Wert, Position, Menge, Klasse."* WIE pruefbar: Tests muessen
exakte Werte pruefen (`peak==384`, `E07_GATE_KRITERIEN_ERFUELLT=k/10` exakt). BEHAUPTET: JA — die
Koeder-Liste (Abschn. 3) zaehlt harte Werte ("K2=3", "K4 done=2" etc.), keine reinen
Existenzproben.

**P-15 — T-3 NENNER, FREMD** (`:69`) **+ T-5 ORAKEL, UNABHAENGIG** (`:71`). WAS: SOLL-Werte muessen
aus einer anderen Quelle als dem Pruefling stammen, gerechnet oder eingefroren, nie aus der
gepruexten Funktion selbst. WIE pruefbar: Testcode-Konstanten unabhaengig vom Header hergeleitet.
BEHAUPTET: JA — "SOLL-Nenner beider Tests im Test hergeleitet (Op-Strom-Zaehlung bzw.
2*3-Arithmetik + Dossier-Zaehlung 10/23), nie aus dem Pruefling gelesen" (Abschn. 5). *Hinweis:*
der Strang-Bericht selbst nennt diese Eigenschaft dort "T-4" — inhaltlich beschreibt sie aber T-3/
T-5, nicht T-4 (Gegeneingang, s. P-16); eine kleine Nummerierungs-Ungenauigkeit im Bericht selbst,
keine inhaltliche Luecke.

**P-16 — T-4 GEGENEINGANG** (`:70`). WAS: *"Zu jeder Zusicherung ein Eingang, bei dem sie nicht
gilt. Ein Randfall-Test, der nur Absturzfreiheit prueft, ist keiner."* WIE pruefbar: je Kriterium
mindestens eine Verletzungs-Probe MIT erwartetem Befund. BEHAUPTET: JA — lange Aufzaehlung in
Abschn. 3 (K1-Bruch, K1-Nullfenster, K2=3, K3a-Stale-Treffer, Delta-0-UNGUELTIG woertlich, K3b
ohne Delta, ID-Set-Bruch beisst K3b UND K3c, K4 Cursor-off-by-one, K4 done=2, K5 byte_equal=0,
N1=1, N2=1, N3 new_ids=1 + diverse Format-Gegeneingaenge, Flag=2, Konflikt-vs-Doppel,
Verdikt-Rueckeinspeisung). Fuer R-13: monotoner Gegen-Strom (peak==total NUR ohne Freigaben) ist
der T-4-Gegeneingang.

**P-17 — T-6 SCHWESTERPFLICHT** (`:72`, formal verankert — Ausfuehrung s. P-10). BEHAUPTET fuer
R-13: JA (der Zensus IST die Schwesterpflicht-Erfuellung). Fuer R-12: SACHLICH NICHT ANWENDBAR
(Neubau eines Headers, kein Fix-mit-Pendant-Muster) — keine Behauptung dazu, konsistent.

**P-18 — T-7 REGISTRIERUNG** (formal verankert, Ausfuehrung s. P-06 fuer R-12; fuer R-13 identisch:
`test_e8_bytes_in_use_peak_demo` ebenfalls am Dateiende registriert, Bilanz-Delta +1 je Paket, in
Summe +2).

**P-19 — T-8 ATOMARE LANDUNG / Hart-Gruen-Doktrin** (`:74`): *"Tag-1-Rot lebt im Feature-Branch;
auf development landen Test + Minimalbau atomar ... Rot-Lauf vor der Heilung und Gruen-Lauf danach
sind Paketbestandteil."* WIE pruefbar, zwei Teile: (a) Test+Fix in EINEM Commit — pruefbar am
Diff `0f900dcf` (1 Commit, 5 Dateien); (b) "auf development landen" — noch NICHT erwartbar in
diesem Strang (Lande-Zug ist eigene, spaetere Stufe: STAFFEL2-SYNTHESE §2.2 fuehrt `bau/trigfix`
als Schritt 8 einer 10-teiligen ce-Lande-Reihenfolge, NACH `ph89`, VOR `skip97`). BEHAUPTET: (a)
JA — genau 1 Commit; (b) korrekt als offen/ausstehend zu werten (Branch `bau/trigfix`, `git push
-o ci.skip`, kein Ledger-Schreib — Landung ist Lande-Zug-Sache).

**P-20 — T-9 TESTKRITIK** (`:75`, Folgewelle-Pflicht — strukturell NICHT durch diesen Strang
selbst erfuellbar, da sie eine SPAETERE, unabhaengige Pruefung der HEUTE neuen Tests verlangt).
BEHAUPTET: keine Behauptung im Strang-Bericht (korrekt, ausserhalb seines Zustaendigkeitsbereichs)
— als offener Punkt fuer die naechste Pruef-Instanz (u. a. dieses Audit) festzuhalten, nicht als
Luecke DIESES Strangs.

**P-21 — T-11c MUTATIONS-PROTOKOLL ALS ABNAHMEKLASSE** (`Designplan-tdd:647`: *"der Biss jedes
neuen Tests wird per protokollierter Wegwerf-Mutation belegt ... GEZAEHLTE Pflicht je Paket: je
neuem Test >=1 Wegwerf-Mutation mit literalem Rot + Gegenprobe-Gruen."*). Vom Strang selbst
zitiert ("T-1/T-11c R-12 Wegwerf-Mutation", Abschn. 5). BEHAUPTET: JA (deckt sich mit P-13);
*Hinweis:* T-11c/T-11a-c sind im Designplan-Summen-Modell budgetaer der S-Strecke zugeschlagen
(§10/D-4), nicht dem 117er-Kernkatalog — das aendert nichts an ihrer inhaltlichen Anwendbarkeit
hier, nur an ihrer Stunden-Zurechnung (nicht Gegenstand dieser Karte).

**P-22 — T-11b KOMBIBAU-2x2-MATRIX** (`:645`: 4 Zellen {gcc,clang}x{Debug,Release} je Landung).
WAS: gilt als Lande-Abnahme, nicht als Einzeltest-Posten ("sie gehoert in die Wellen-Abnahme (§4)
jedes Stempel-/Mess-Pakets"). WIE pruefbar: erst am LANDE-MERGE faellig. BEHAUPTET: korrekt NICHT
geliefert — "K17-Vollkombibau (gcc+clang, Debug+Release) macht der Lande-Zug; hier nur
gcc-Release-Gruen-Probe per Ladder (Regel-konform)" (Abschn. 8 Punkt 4).

### D) GOAL-v8- und Prozess-Doktrinen

**P-23 — EISERNE REGEL / TABU-Flaechen.** WAS: Workflow-Auftrag REGELN-Block: axes/topics/
heuristik/ NUR gelesen; golden-Dateien byte-stabil; `.gitlab-ci.yml` nur mit ausdruecklichem
Auftrag; `tests/unit/CMakeLists.txt` NUR ans Dateiende; ASCII-only; clang-format-22 ueber jede
geaenderte Lint-Datei. WIE pruefbar: Diff-Namen gegen die TABU-Liste pruefen; ASCII-Grep ueber
alle Zusatzzeilen; `clang-format-22 --dry-run -Werror` ueber die 4 Lint-Dateien. BEHAUPTET: JA —
"EISERNE REGEL eingehalten: axes/topics/heuristik/organ_axes NUR gelesen; .gitlab-ci.yml
unberuehrt; kein Ledger-Schreib; kein git add -A; nie rebase" (Abschn. 7) + "clang-format-22 ...
CF-GRUEN ... ASCII-Pruefung je Datei ... REIN" (Abschn. 5).

**P-24 — Bau-Slot-Protokoll (Deckel 3, df-Gate, Freigabe).** WAS: Workflow-Auftrag REGELN-Block:
atomares Slot-Verzeichnis vor Vollbau, df>5G-Gate, Freigabe nach ctest. WIE pruefbar: kein
verwaistes Slot-Verzeichnis mehr unter `~/.claude/jobs/.../bauslots/`; `build/` im Worktree
entfernt (`git ls-files build/` == 0). BEHAUPTET: JA — "Bau-Slot 2 genommen/freigegeben
(Deckel-3-Protokoll, df-Gate 29G>5G); build/ nach Belegpruefung entfernt (git ls-files build/=0,
*.csv/*.xlsx=0)" (Abschn. 7).

**P-25 — Push/Commit-Doktrin.** WAS: Workflow-Auftrag REGELN-Block: `git push -o ci.skip origin
<branch>` nach jedem Fix-Commit (Ref-Sicherung, keine Pipeline); Commit-Trailer
`Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>`. WIE pruefbar: `git ls-remote origin
refs/heads/bau/trigfix` muss auf `0f900dcf` zeigen; Commit-Body traegt den Trailer wortgleich.
BEHAUPTET: JA — "Branch-Sicherung `git push -o ci.skip origin bau/trigfix` -> `[new branch]`"
(Abschn. 7); lokaler Branch `bau/trigfix` UND `remotes/origin/bau/trigfix` existieren beide bei
`0f900dcf` (eigene git-Probe dieser Erhebung, s. u.).

**P-26 — V11/V1: Messung vor der Aussage, HEAD-Nachmessung statt Uebernahme.** WAS (`GOAL-v8`
TEIL II.2/II.3): *"Die Messung muss aelter sein als der Satz ... Jeder aus Kommentar, Ledger oder
Bericht uebernommene Zahlenwert braucht eine eigene Ist-Messung, bevor daraus ein Bau-Posten
wird."* / *"Jede Zahl, jeder SHA und jede Zustandsaussage aus einem Agentenbericht wird vor
Weitergabe selbst gemessen oder ausdruecklich als ungeprueft gekennzeichnet."* WIE pruefbar: der
Strang darf keine Ledger-Altbehauptung (z. B. "Literal 64 ueberlebt") ungeprueft uebernehmen,
sondern muss sie gegen den AKTUELLEN HEAD nachmessen. BEHAUPTET: JA, vorbildlich — Abschn. 2.1
stellt fest, dass die Karten-Behauptung zu CLU-64 "am Objekt UEBERHOLT" ist (Fix liegt bereits vor
der Strang-Basis) und baut folgerichtig NICHT blind nach der alten Kartenlage, sondern verifiziert
den Ist-Zustand zuerst — exakt das REGEL-ZEILE-17-Muster des Ledgers ("Ein Befund traegt sein
Erhebungsdatum ... wer ihn zur Handlung macht, misst ihn vorher gegen den heutigen HEAD").

---

## ABNAHME-FORMELN (woertlich, mit Quelle)

1. `W2-ABFOLGE-DESIGN.md:473` (R-12): **"ABNAHME: Kriterien implementiert."**
2. `W2-ABFOLGE-DESIGN.md:475` (R-13): **"ABNAHME: beide Groessen wahr/deklariert."**
3. `Wellenplan v2:2646`: `R-12 | E-07-Gate: Kriterien 0 Treffer im Code; Position B10
   trigger-blockierend | r3 C4 | P | vor 26.08.`
4. `Wellenplan v2:2647`: `R-13 | Zwei unwahre Messgroessen (bytes_in_use_peak; CLU-64) vor dem
   ersten Batch | r3 C5 | P | vor 26.08.`
5. Ledger, Nachbuchung (06.08.2026 nachmittag-11): **"B10 traegt E-07/B5 (B+-Baum-
   Steuerungs-Nachweis), trigger-blockierend. GO genau dann, wenn K1-K5 UND N1-N3 saemtlich mit
   literalen Zeilen erfuellt sind. ... Der Ledger-Vermerk 03.08. 'E-07-Luecke GESCHLOSSEN'
   bezeichnet die LANDUNG DES DOSSIERS, NICHT die Erfuellung des Gates."**
6. E07-gate-definition-dossier.md:64 (Primaerquelle, identisch in der 03.08.-Zweitfassung):
   **"GO-Kriterium E-07: K1-K5 UND N1-N3 saemtlich mit literalen Zeilen erfuellt."**
7. Ledger, Ur-Fund (06.08. abend, "Zwei unwahre Messgroessen vor der Messung"): **"Beide muessen
   vor dem ersten Batch stehen -- danach tragen die vorher erhobenen Zeilen andere Semantik als
   die spaeteren: ein Datenbruch ohne Neubau, unsichtbar."**
8. `Designplan-tdd:65` (TDD-Vertrag-Kopf, deckt R-12/R-13 als "Paket der Welle" mit ab): **"Gilt
   ab sofort fuer jedes Paket aller Wellen ... Deckungsfrage nach §11.3: 'was erzwingt das
   Halten?' -- zulaessig ist nur ein Werkzeug oder eine benannt ungedeckte Stelle."**
9. `Designplan-tdd:67` (T-1): **"Der Test ist am ersten Tag rot, ODER sein Biss ist per
   protokollierter Wegwerf-Mutation bewiesen ... Beides fehlt = kein Test."**
10. `GOAL-v8:305-308` (Fail-closed): **"Kann eine Wache nicht pruefen ... ist das rot oder
    Abbruch, nie gruen. Ein stiller Rueckfall ist ausdruecklich ein Fehler."**
11. `GOAL-v8:295-299` (K13): **"Eine Wache gilt erst dann als gebaut, wenn ein zufaellig
    erzeugter Koeder sie zum Beissen bringt ... Beide Richtungen fahren."**
12. `Wellenplan §13.2:1443-1444` (Klassen-Regel, bindet die "P"-Spalte von R-12/R-13): **"(P)
    PREIMAGE-WIRKSAM aendert die SHA JEDER Binary -> MUSS vor F2 (Fr 21.08.), sonst bricht der
    Identitaets-Freeze."** — s. SPANNUNG 6 fuer die Reibung gegen die Tabellenspalte "vor 26.08.".

---

## NICHT-GEFORDERT (verhindert Phantom-Funde)

- **B10-Beweislauf/Emitter (Stufe B5.b), Board #114.** Mini-Profil (<=8 Binaries),
  XML-Differenz-Laeufe je Achsen-Familie, eigener out-/dll-Ordner, golden-neutral — produziert die
  ECHTEN `E07_*`-Zeilen und damit das reale GO/NO-GO-Verdikt. Aufgaben-Steckbrief woertlich:
  "TRIGGER-BLOCKIEREND: B10-Beweislauf (Emitter) = #114, NICHT Teil dieses Strangs." Eigener
  Traeger, aktiver Agent dieser Session (`p12-b10-beweislauf`); nicht in `#114\b` als Board-Nummer
  in den 6 SOLL-QUELLEN selbst dokumentiert (nur im Aufgaben-Steckbrief und im Strang-Bericht
  indirekt via STAFFEL2-Findings) — das ist ein Dokumentations-Ort-Hinweis, keine Unsicherheit
  ueber die Existenz der Abgrenzung selbst.
- **G6(J-0..J-5) "auf GEEICHTEM Stand NEU erbringen"** — Teil der URSPRUENGLICHEN, breiteren
  B10-Checklisten-Definition (05.08.), NICHT durch R-12/R-13 gedeckt und in keiner der 6
  SOLL-QUELLEN einem eigenen Traeger zugewiesen. Unklar, ob dies im #114-Zuschnitt aufgeht oder
  ein DRITTER, noch unbenannter Folgeposten ist — als Audit-Hinweis, nicht als trigfix-Luecke.
- **Echte Peak-Quelle am Snapshot-POD** (`measurement_snapshot.hpp`, SA-T6-Wire-Slot ODER
  Zeitreihen-`tier_observe`) — ausdruecklich ABI-Ereignis, dem E-24-Fenster zugeordnet,
  owner-gated (Owner-Entscheid A8-S3/B7 steht bereits VOR trigfix). Kein Auftrag an diesen Strang.
- **CLU-64 Code-Fix** — der Code-Fix selbst (`system_axis.hpp`) liegt bereits VOR der
  Strang-Basis (`c1c76c87`, 06.08.); dieser Strang schuldet nur Verifikation, keinen neuen Diff.
- **T-11a (Warmup-Paar-Pflichttest), T-12a-e (Drift-Gate-Debug-Ausnahme, Warmup-Legacy,
  Arena-Kapazitaet, Full-Join-Schema, S-3-Kombibau)** — inhaltlich disjunkt von E-07/CLU-64/
  bytes_in_use_peak (`Designplan-tdd:640-713`); tauchen im Strang-Bericht folgerichtig nicht auf.
- **T-11b Kombibau-Quadmatrix** ({gcc,clang}x{Debug,Release}) — Pflicht des LANDE-MERGE, nicht
  dieses Bau-Strangs (s. P-22).
- **`axes/` `topics/` `heuristik/` `organ_axes/`-AENDERUNGEN** — der Strang LIEST
  `organ_axes/layout/axis_05_memory_layout_observable.hpp` nur zur CLU-Verifikation, aendert dort
  nichts (TABU gewahrt).
- **`.gitlab-ci.yml`-Aenderungen** — weder Wellenplan noch W2-ABFOLGE-DESIGN verlangen fuer
  R-12/R-13 eine CI-Verdrahtung; der Diff enthaelt folgerichtig keine YAML-Zeile.
- **Ledger-/Board-Eintragung** — die Ledger-Entwuerfe des Strangs (Abschn. 6) sind ausdruecklich
  "NICHT eingetragen -- Lead uebernimmt"; rollenkonform (Fix-Strang schreibt nie den Ledger).
- **K17-Vollkombibau (4 Zellen)** — s. P-22, Lande-Zug-Pflicht, nicht dieser Lieferung.
- **Karten-Konsolidierung** (`rest_karte_r3.md` C5-CLU-Teil als "GEHEILT" umschreiben) — vom
  Strang nur EMPFOHLEN ("bei naechster Karten-Konsolidierung"), nicht selbst vollzogen; passend zu
  STAFFEL2-Finding F-101 ("Karten-Konsolidierung Phase 5" als eigener Folgeschritt).

---

## SPANNUNGEN (Widersprueche/Reibung zwischen den Quellen — nicht glattgezogen)

1. **CLU-64: die Wellenplan-Quelle (08.08.) beschreibt einen Zustand, der am Objekt bereits VOR
   ihrer eigenen Niederschrift geheilt war.** `Wellenplan v2` traegt das Datum 08.08.2026 und
   listet R-13/CLU-64 (Zeile 2647, Quelle "r3 C5") unveraendert als zu heilenden Defekt. Der
   tatsaechliche Heilungs-Commit `c1c76c87` ("die CLU-Kette bis zum LETZTEN Verbraucher
   geschlossen") ist auf den 06.08.2026 datiert — zwei Tage VOR der Wellenplan-Niederschrift. Die
   NOMINELL juengere Planungsquelle war bei ihrer Entstehung bereits stale gegenueber dem
   Objekt-Stand. Fuer das Audit wichtig: KEINE Under-Delivery des Strangs — er hat die Staleness
   selbst aufgedeckt und per Testlauf belegt statt sie glattzuziehen oder doppelt zu bauen.
2. **"B10" in der VOR-TRIGGER-CHECKLISTE ist wortwoertlich generisch, nicht E-07-spezifisch,
   formuliert.** Der Original-Checklisteneintrag (Ledger, 05.08.2026 abend-4) lautet nur *"B10
   V7.4-4+1-Beweise + G6(J-0..J-5) auf GEEICHTEM Stand NEU erbringen (Variant-Gate-E2E seit A2
   inert -- O-2-Kopplung)"* — OHNE jede Nennung von E-07/K1-K5/N1-N3. Die Bindung an das exakte
   E-07-Kriterium existiert erst als SPAETERE Nachbuchung (06.08. nachmittag-11, deren eigener
   Nachtrags-Titel wortwoertlich von einem "VIERTEN Verlustmechanismus ... [NAMENSKOLLISION]"
   spricht). Wer nur den Checklisten-Wortlaut liest, erkennt den E-07-Bezug NICHT — er ist nur
   ueber die Nachbuchung herstellbar. Kein Cross-Source-Widerspruch (beide Stellen sind additiv im
   selben Ledger gemeint), aber eine reale Stolperfalle fuer jede kuenftige Lektuere.
3. **R-13-Frist: Tabellenspalte vs. Fliesstext-Begruendung laufen leicht auseinander.** Die
   Wellenplan-DEADLINE-SPALTE nennt fuer R-13 identisch zu R-12 "vor 26.08." (Trigger), waehrend
   die POSTEN-BEGRUENDUNG selbst "vor dem ersten Batch" sagt — der erste Mess-Batch faellt gemaess
   Kampagnen-Ablauf erst NACH dem Trigger (Sa 29.08.+). R-12 traegt zusaetzlich das explizite Wort
   "trigger-blockierend" in seiner eigenen Kurzbeschreibung, R-13 NICHT. Damit bleibt offen, ob
   R-13 wirklich bis Mi 26.08. 06:00 stehen MUSS (Tabellenspalte) oder ob "vor dem ersten Batch"
   (materiell die weniger strenge Frist) bindend waere. In der Praxis folgenlos (Lieferung 20./
   21.08., vor jeder Lesart) — als Formulierungs-Unschaerfe dennoch zu benennen.
4. **Zwei E-07-Gate-Definitionsdossiers, unterschiedlich datiert, Kriterien-Kern aber identisch.**
   `docs/sessions/backups/20260803-design-nachtraege-final/E07-gate-definition-dossier.md`
   (02./03.08.) und `docs/sessions/20260803-DOSSIER-e07-gate-definition-b5-zweistufig.md` (03.08.,
   als "NEUFASSUNG ... nie als Repo-Datei gelandet" markiert) liegen beide im Baum. Die
   K1-K5/N1-N3-Tabelle und die literalen `E07_*`-Namen sind in beiden Fassungen wortgleich; die
   zweite ergaenzt nur Anker-Kontext. Kein Kriterien-Widerspruch, nur eine
   Verwechslungsgefahr durch zwei aehnlich betitelte Dateien.
5. **[NEU ggue. Runde 1] Produktions-Reichweite von `experiment_demo.hpp` objektiv ungeklaert —
   dieselbe Fragestellung, die am 06.08. bei `measurement_snapshot.hpp`/`f15_compare` zur
   "Entkraeftung" der Urgency fuehrte, wurde fuer den TATSAECHLICH gefixten Ort nicht gestellt.**
   Eigene Objekt-Probe (read-only `git grep` gegen `0f900dcf`, diese Erhebung): `run_single_
   experiment` (die Funktion, die `experiment_demo.hpp` definiert und die den peak-Wert erzeugt)
   hat **0 Aufrufer ausserhalb von Unit-Tests** — nur `tests/unit/test_e8_bytes_in_use_peak_demo.cpp`
   (neu, dieser Strang) und `tests/unit/test_workload_and_experiment.cpp` (bereits vorhanden)
   rufen sie auf. Keines der 8 `apps/*/main.cpp`-Programme (u. a. `cache_engine_builder`,
   `f15_compare`, `experiment_planner`) includet die Datei. `cache_engine_builder_iterator.hpp`
   (der reale Voll-Lauf-CSV-Writer laut Ledger-Ur-Befund) referenziert weder `result_aggregator`
   noch `experiment_demo`. `.gitlab-ci.yml` enthaelt 0 Treffer fuer beide Namen. Der Datei-eigene
   Kopf-Kommentar nennt sie selbst *"ExperimentDemo -- End-to-End Mini-Experiment (Phase 7.4)"*.
   Andererseits ist `experiment_demo` laut einem AELTEREN, unabhaengigen Ledger-Fund (17.07.2026,
   F6-Nachzug-Nachtrag) ausdruecklich als "realer Lib-Konsument" von `module_abi_v1.hpp"
   eingestuft worden (nicht test-only, im Gegensatz zu mehreren dort explizit als DEPRECATED/
   test-only markierten Nachbar-Symbolen) — das Modul gilt projekt-intern also NICHT als totes
   Symbol, sondern als "lebender" Baustein der `libs/execution_engine`-Bibliothek, auch wenn keine
   `apps/`-Binary es heute aufruft. **Was das fuer das Audit bedeutet:** der Fix selbst ist
   harmlos, additiv und technisch korrekt (peak wird tatsaechlich zu einem echten Peak) — aber ob
   er die "vor dem ersten Batch"-DRINGLICHKEIT von R-13(b) tatsaechlich einloest (im Sinn von: eine
   Zahl heilen, die sonst in einen echten Mess-Batch/eine echte CSV/xlsx-Zeile der Kampagne
   eingeflossen waere), ist durch keine der 6 SOLL-QUELLEN und auch nicht durch den Strang-Bericht
   selbst belegt — dessen Abschn. 2.2/2.3 argumentiert ausschliesslich mit BILLIGER
   TECHNISCHER MACHBARKEIT ("'wahr machen' ist hier OHNE ABI-/Schema-Ereignis moeglich"), nie mit
   Produktions-Erreichbarkeit. Weder Runde-1-Soll-Karte noch `audit-runde-1.md` (P-06/P-07, beide
   pauschal "ERFUELLT") stellen diese Frage. Empfehlung an das Audit: pruefen, ob
   `PermutationResult`/`memory_ratio` aus `experiment_demo.hpp`/`result_aggregator.cpp` irgendwo
   in die produktive Kampagnen-Kette (CSV/xlsx) eingespeist wird — wenn NEIN, bleibt der Fix
   inhaltlich richtig, aber die "vor dem ersten Batch"-Einordnung von R-13(b) sollte pruezisiert
   (nicht zurueckgenommen) werden.
6. **[NEU ggue. Runde 1] Klassen-Deadline-Reibung: "P" (PREIMAGE-WIRKSAM) verlangt laut der
   allgemeinen Wellenplan-Regel "vor F2", die R-12/R-13-Tabellenzeile selbst nennt nur "vor
   26.08.".** `Wellenplan §13.2` definiert die Spalte "Kl." projektweit: *"(P) PREIMAGE-WIRKSAM
   aendert die SHA JEDER Binary -> MUSS vor F2 (Fr 21.08.), sonst bricht der Identitaets-Freeze."*
   R-12 UND R-13 tragen beide die Klasse "P" (§19.7-Tabelle) — nach der allgemeinen Regel muessten
   beide also bereits vor F2 (Fr 21.08.) gestanden haben, nicht erst "vor 26.08." (Trigger). Da
   §19.7 selbst Teil der "UR-LEDGER-RUECKKEHRER"-Rubrik ist ("NUR im Massstab wirklich
   Ungedecktes" — also spaet nachgetragene Funde), scheint die Tabellenzeile die allgemeine
   Klassen-Frist bewusst zu einer praktischeren "vor 26.08." aufzuweichen, statt einen bereits
   verstrichenen F2-Bruch zu erklaeren. Das ist NICHT als Kritik an trigfix zu lesen (F2 war zum
   Strang-Start am 20./21.08. bereits Geschichte, "vor 26.08." ist die einzig noch erreichbare,
   operative Lesart, und `W2-ABFOLGE-DESIGN` — die juengere, operative Schicht — bestaetigt in
   Slot [E] exakt diese Lesart: "S4 E-7/E-8-Fixzellen (klein, vor 06:00)"). Fuer das Audit dennoch
   festzuhalten: die konkrete Zeile (spezifischer, operativ juenger via W2-ABFOLGE-DESIGN)
   gewinnt gegen die allgemeine Klassen-Regel — kein Fund, aber eine dokumentierte Quellen-Reibung.

---

**Eigene Objekt-Proben dieser Erhebung (read-only, ergaenzend zum Strang-Bericht; NICHT als Ersatz
fuer einen Vollbau/ctest-Lauf gedacht — das bleibt Aufgabe der Bau-/Audit-Instanz):**
`git log --oneline -1 66de5c09` und `0f900dcf` bestaetigen Basis- und Ziel-Commit-Botschaft
wortgleich zum Aufgaben-Steckbrief; `git branch -a --contains 0f900dcf` zeigt `bau/trigfix` UND
`remotes/origin/bau/trigfix` (Push bestaetigt); `git worktree list` zeigt `/home/comdare/
wt-ce-trigfix` bei `0f900dcf`. `git grep -ln experiment_demo/run_single_experiment/apps` (s.
SPANNUNG 5) sowie `git grep -n R-12/R-13 DESIGNPLAN` (0 Treffer — kein eigener Katalog-Posten, nur
der generelle T-Vertrag greift) wurden fuer diese Karte frisch gefahren, nicht aus Runde 1
uebernommen.

**Quellenverzeichnis:** W2-ABFOLGE-DESIGN.md:472-475,771,782,826-828 (Slot E) ·
LEAD-ENTSCHEIDE-zum-w2-design.md (voll, 87 Z., 0 trigfix-Eintraege) · Wellenplan v2:1443-1447
(§13.2 Kl.-Legende),2646-2647 (§19.7 R-12/R-13 — einzige Fundstellen im 3627-Z.-Dokument; par.21-23
tragen keine eigene Fassung) · Designplan-tdd:63-76 (T-1..T-9),640-649 (T-11a-c, T-11c
anwendbar),661-713 (T-12a-e, keiner anwendbar) · GOAL-v8 TEIL II (Z.264-318: V11,V1,V4,Nenner,K13,
Fail-closed) · Ledger (Nachtraege 05.08. abend-4 "Liegengebliebenen-Sweep", 06.08. nachmittag-11
"Namenskollision", 06.08. abend "Zwei unwahre Messgroessen"/"A-7/A-8 ENTKRAEFTET"/REGEL-ZEILE 17)
· E07-gate-definition-dossier.md (Zitat via Ledger-Nachbuchung) · STAFFEL2-SYNTHESE.md:23,33,48,
86,119-135 (H-9/H-16, Lande-Reihenfolge Schritt 8),151,155,160,190-193 (F-100..F-103),228,244 ·
Strang-Bericht trigger-fixzellen-ergebnis.md (voll, 111 Z.) · vorbestehende
`soll-karte.md`/`audit-runde-1.md` an diesem Pfad (21./22.08., voll gelesen, s. VORBEFUND) ·
eigene git-Proben (ce-Hauptklon, read-only: log/branch/worktree/grep gegen 66de5c09/0f900dcf).

---

## RUNDE 3 — UNABHAENGIGE RE-VERIFIKATION 23.08.2026 (dritte, wieder GEGENSTAND-BLIND begonnene Lesart)

Diese Ergaenzung entstand aus einer DRITTEN Erhebung an diesem Pfad, erneut GEGENSTAND-BLIND
begonnen: alle 7 SOLL-QUELLEN + der Strang-Bericht + beide E-07-Gate-Definitionsdossiers wurden
unabhaengig neu gelesen (inkl. eigener Objekt-Proben — `git show --stat`/`--name-status 0f900dcf`,
`git ls-remote origin refs/heads/bau/trigfix`, `git worktree list`, `git log --oneline bau/trigfix`,
`grep -oE '"E07_[A-Z_]+' e07_gate_kriterien.hpp \| sort -u \| wc -l` = 28 [23 Pflicht- + 5 Meta-/
Ausgabe-Literale `E07_GATE`/`E07_GATE_BEFUND`/`E07_GATE_BEFUNDE`/`E07_GATE_KRITERIEN_ERFUELLT`/
`E07_GATE_PFLICHT_LITERALE` herausgerechnet; 23 gegen die K-Familien-Summe 3+1+3+3+2+5+2+1+1+2=23
nachgerechnet], `grep -cE '^\s*TEST(_F)?\(' test_e07_gate_kriterien.cpp` = 22,
`test_e8_bytes_in_use_peak_demo.cpp` = 3, Kommentarzeile `experiment_demo.hpp:39` gelesen) —
**bevor** die Existenz dieser Datei und von `audit-runde-1.md` per `ls` auffiel. Ergebnis: **volle
Konvergenz** mit der bestehenden Fassung; keine neue Diskrepanz in PRUEFLISTE/ABNAHME-FORMELN
gefunden, keine Korrektur noetig.

**Objekt-Stand unveraendert seit dieser Karte (23.08. Nachmittag) bestaetigt:** `bau/trigfix` @
`0f900dcf` lokal UND `remotes/origin/bau/trigfix` identisch; `wt-ce-trigfix` HEAD `0f900dcf`,
`git status --porcelain` leer. Ledger-Tail (letzte 400 Zeilen der jetzt **32387**-Zeilen-Datei,
gegenueber den zuvor zitierten Fenstern gewachsen) enthaelt **0** neue Treffer fuer `trigfix`,
`R-12`, `R-13`, `E-07`, `B10`, `#114` — keine Nachbuchung seit dieser Karte entstanden.

**Gezielte Nachpruefung der drei Stellen, die dieser Karte gegenueber Runde 1 NEU sind und die
`audit-runde-1.md` (Haupttext 21.08., Annex 22.08. — BEIDE zeitlich VOR dieser Datei) folglich noch
NICHT durchlaufen konnte, damit kein unaudited Fund unbestaetigt bleibt:**

1. **P-07a (B10/B-10-Namenskollision) — BESTAETIGT, eigener Fund.** `grep -n 'B-10\b'` ueber den
   Wellenplan liefert 3 Treffer, darunter **Zeile 2430**: *"B-10  Hybrid: Tier-Bau/-Laden IMMER
   durch die CEB delegiert; Standard-compare->release VOR..."* — ein sachfremder, in Korb B
   (§19.2) verankerter Hybrid-/Lager-Posten. Wortlaut und Zeilennummer decken sich exakt mit der
   Karten-Behauptung; eigener, unabhaengig gefahrener Suchlauf, nicht aus der Karte uebernommen.
2. **SPANNUNG 6 (Kl.-Legende §13.2) — BESTAETIGT, exakter Wortlaut und exakte Zeilen.** Eigener
   `Read`-Aufruf `Wellenplan Z.1435-1452` zeigt woertlich auf **Z.1443-1444**: *"(P)
   PREIMAGE-WIRKSAM aendert die SHA JEDER Binary -> MUSS vor F2 (Fr 21.08.), sonst bricht der
   Identitaets-Freeze."* — Zeilennummer UND Wortlaut der Karte treffen exakt.
3. **SPANNUNG 5 (Produktions-Reichweite `experiment_demo.hpp`) — BESTAETIGT, eigener Frisch-Grep.**
   `grep -rln 'experiment_demo\.hpp' --include=*.cpp --include=*.hpp .` im Worktree `wt-ce-trigfix`
   (heute gefahren) liefert AUSSCHLIESSLICH `tests/unit/test_workload_and_experiment.cpp` und
   `tests/unit/test_e8_bytes_in_use_peak_demo.cpp` — **0** Treffer unter den 9 einzeln aufgelisteten
   `apps/*/main.cpp`-Programmen; `grep -c 'experiment_demo\|run_single_experiment' .gitlab-ci.yml`
   = **0**. Deckt sich zeilengenau mit der Karten-Behauptung.

**Ergebnis dieser dritten Lesart:** keine der drei "[NEU ggue. Runde 1]"-Stellen war ein
Einzel-Fund ohne Gegenprobe geblieben — alle drei sind jetzt durch eine zweite, unabhaengig und
GEGENSTAND-BLIND begonnene Erhebung, mit frischen Kommandos am selben, unveraenderten Objektstand,
bestaetigt. Diese Karte gilt fuer jeden Punkt der PRUEFLISTE/SPANNUNGEN damit als zweifach
verifiziert (diese Runde gegen die vorherige UND die vorherige gegen Runde 1); `audit-runde-1.md`
selbst deckt weiterhin nur die Runde-1-Teilmenge formal per eigener Standalone-Compile-Probe — die
drei hier genannten Zusaetze waren bislang nur einfach belegt und sind mit diesem Absatz auf
denselben Beweis-Standard gehoben. Keine neue Spannung, kein neuer PFLICHT-Punkt, keine Korrektur
an NICHT-GEFORDERT. Empfehlung an die Synthese: `audit-runde-1.md` bei Gelegenheit um einen kurzen
Nachtrag ergaenzen, der P-07a/SPANNUNG-5/SPANNUNG-6 auch FORMAL in die P-Tafel uebernimmt (P-Nummer
+ ERFUELLT + Beleg) — inhaltlich ist nach dieser dritten Lesart nichts mehr offen, nur die
Tafel-Form fehlt noch.
