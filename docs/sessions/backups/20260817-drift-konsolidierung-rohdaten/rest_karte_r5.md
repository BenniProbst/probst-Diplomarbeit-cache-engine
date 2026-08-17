# REST-KARTE r5 — Ledger Z. 27401–30077 (Datei-Ende)

**Segment-Korrektur vorab:** die Auftragsbeschreibung erwartete hier „Gate-Tabellen, K-Sektion/Lizenz,
FF-Katalog, Drei-Stufen-Messkette 26.07. [Ledger:28532ff], thematische Kapitel". Der Ist-Inhalt ist ein
anderer: Z. 27401–30077 ist die **Nachtrags-Kette 07.08. abend-16 … 09.08.** (E-A…E-F/Ω, A1–A9, §55-
RECONCILE, §75-RECONCILIATION, die **Owner-KERNe der Messkette/Blattform/Checkpoints**, Owner-Entscheide
Aufräumen/Bauweg, Lager-Realms). Die Drei-Stufen-Messkette steht bei **:28704ff (08.08.)**, nicht 26.07.;
:28532 ist die F1-Kapazitätstabelle. Der Rest-Ledger endet bei 30077 (Stand 09.08. war 29858) — alle
Anker aus Karten, die den 29858er- oder den 9619er-Stand benutzen, sind verschoben.

Gelesen: 27401–27900 · 27901–28400 · 28401–28900 · 28901–29400 · 29401–29800 · 29801–30077 (vollständig).

---

## (A) LEBEND-UNGEDECKT

### A-Korb 1 — Messkette / Checkpoints: der grösste ungedeckte Block des Segments

**A1 · `checkpoint_measure(..., IN|OUT)` ist EINE uniforme Funktion — Owner-Wort vom 08.08.**
*Anker: :29525–29537 (OWNER-ENTSCHEID 08.08.), C-1/C-2.* Owner verbatim: *„Ja das ist eine inline
Steuerzeile, die auf einen globalen memory stack schreiben soll […] checkpoint OUT unterscheidet sich
also in der checkpoint Funktion NICHT, sondern hat nur ein compile time ‚OUT' flag als Tag. Die Funktion
für `checkpoint_measure(...,IN bzw. OUT)` ist uniform."* Kein `enter()`/`leave()`; `IN`/`OUT` ist ein
**compile-time Tag**, kein Laufzeit-Enum ⇒ der `OUT`-Pfad darf per `if constexpr` anders übersetzt werden.
→ **Designplan-TDD** (und Korrektur der Gegenlese-Karte W16, s. (C1)).

**A2 · C-3: was ein Checkpoint aufnimmt — die Spalte *Ziel* kommt dazu.**
*Anker: :29552–29564.* Felder: Aufrufender (Laufzeit) · **gelandete Zielfunktion** (neu gegenüber N-1..N-7)
· Systemzeit · **alle CT-Parameter der/aller Achsen zu diesem Zeitpunkt** · Checkpoint-Flag (CT).
Erst das Paar **(Aufrufer, Ziel)** macht die Zeile zur vollständigen Stack-Kante. → **Designplan-TDD**
(Blattform-Spalten), berührt KON88/KON95-O2.

**A3 · C-4: drei ZWINGENDE Hot-Path-Bauregeln, Owner-begründet.**
*Anker: :29566–29579.* Owner: *„Das Verfahren muss besonders sparsam sein, weil wir Latenzen nicht in der
Messung dulden können."* Daraus: (1) **die CT-Achsen-Parameter dürfen zur Laufzeit NICHT zusammengebaut
oder kopiert werden** — in den Stack gehört **ein einziger Verweis auf einen statischen Deskriptor**
(Zeiger/Index), nicht die ausgeschriebene Achsen-Kette („sonst Latenz proportional zur Achsenzahl, also
dort am stärksten, wo am feinsten gemessen wird"); (2) kein Speicher im Hot-Path, Stack vorab alloziert,
feste Kapazität; (3) kein I/O im Hot-Path. → **Designplan-TDD / #18 Arena E1-E11** (KON94 kennt die Arena,
nicht die Deskriptor-Regel).

**A4 · C-6: der Überlauf ist ein BEFUND, kein Verlust.**
*Anker: :29601–29607.* Verwerfen lässt die Messung still lügen, blockieren erzeugt die verbotene Latenz ⇒
**weiterlaufen, Überlauf zählen, beim Auslesen melden** — dieselbe Behandlung wie ein `IN` ohne `OUT`.
→ **Designplan-TDD / #18** (Arena-Bau; KON94-E-Reihe führt keine Überlauf-Semantik).

**A5 · C-7/C-8: EIGENER Stacktrace, Mess-Ebene als CMake-Flag — Owner-Entscheid.**
*Anker: :29611–29649.* Owner verbatim: *„Also müssen wir zur compile time cmake Flags setzen, die
automatisch in die checkpoint_measure einkompiliert werden, in welcher Mess-Ebene sich der checkpoint
befindet, sodass er rückwärts den nächstgelegenen checkpoint eine Ebene höher finden und als aufrufende
Funktion uniform identifizieren kann. **Wir verwenden also ein eigenes C++ stacktrace und nicht das
standard stacktrace.**"* Der Aufrufende ist ein **TRIPEL** (Prozessname · Name der aufrufenden Funktion
auf dem Stack · Thread-Nummer). Aufgelöst wird **beim Auslesen**, Hot-Path-Kosten **null**.
`std::stacktrace` wird **gar nicht** verwendet — auch nicht im Fehlerpfad. → **Designplan-TDD**.

**A6 · C-9: die Rekonstruktion ist ein O(n)-Durchlauf, und die N-6-Invariante fällt als Nebenprodukt ab.**
*Anker: :29651–29657.* Ein Vorwärts-Durchlauf mit **je einem offenen Stapel pro Ebene**: `IN` legt auf,
`OUT` nimmt herunter, jeder Checkpoint bekommt als Aufrufer die Spitze des Stapels der nächsthöheren
Ebene. **Was am Ende liegen bleibt, sind exakt die Regressionen aus N-6.** Eine wörtliche Rückwärtssuche
wäre quadratisch. → **Designplan-TDD** (Auswerte-Algorithmus, gehört in die Wache).

**A7 · C-11: GEMESSENE ns-Zahlen des Mess-Overheads (prod1, GCC 15.3, -O2, 200 000 Aufrufe, warm).**
*Anker: :29667–29694.* `std::source_location` als Default-Argument **0,92** · Thread-Kennung
(`get_id()`+hash) **3,5** · `__rdtsc()` **6,8** · `steady_clock::now()` **16,5** ·
`std::stacktrace::current(1,1)` ein Frame **343** · `std::stacktrace`+`description()` **~26 900** ns.
Der **erste** Lauf jeder Binary war durchweg rund doppelt so teuer (Kalt-Cache; steady_clock 37,7 statt
16,5) — die Tabelle trägt die **Rangfolge**, nicht absolute Aussagen. Folgerechnung: `std::stacktrace`
wäre je Interface-Aufruf mit 19 Achsen/38 Checkpoints rund **13 µs** — mehr als die gemessene Operation.
**Die Zeitquelle bleibt der teuerste unvermeidbare Posten.** → **Designplan-TDD + #7 (S-19-Eingang für
den Mess-Overhead-Deckel)**. Kein Zählwerk dieser Art im Kopf.

**A8 · C-12: Toolchain-Ist auf prod1, am Objekt geprüft.**
*Anker: :29695–29705.* GCC 15.3.0 / libstdc++ 15 und **clang 22.1.8 / libstdc++ 16 (Default)**, beide
`__cpp_lib_stacktrace = 202011`; **libc++ ist gar nicht installiert.** → **Task-Karte / Designplan** —
trägt die Compiler-System-Achse ({clang,gcc}, Karte Korb D-5) mit konkreten Versionen.

**A9 · C-14/C-15/C-17: virtuelle Thread-Slots, ein `int` genügt — Owner-Entscheid.**
*Anker: :29720–29772.* Owner: *„Nun die ganze Funktion ist compile time. […] checkpoint_measure wird
inline angelegt."* und *„Thread Nummer wird gelöst, indem zu Beginn virtuelle Thread slots (maximale die
Anzahl der Thread Unterachse) formal zugewiesen wird […] Ein int tut es."* ⇒ **Obergrenze der Slots =
Anzahl der Thread-Unterachse ⇒ compile-time bekannt ⇒ Slot-Puffer STATISCH: keine Allokation, kein
Wachstum, keine Sperre.** Das Log ist **rein append**: ein Schreiber je Puffer, kein Leser zur Laufzeit,
keine Synchronisation. **Offen (ausdrücklich als Fehlerklasse gefordert):** was geschieht, wenn **mehr
Threads entstehen als Slots** — Fehlerfall, kein Wrap-around, muss laut scheitern. → **Designplan-TDD /
#18 Arena** — die Slot-Obergrenze ist eine harte Dimensionierungsvorgabe, die KON94 nicht kennt.

**A10 · C-10: Thread-lokale Puffer sind eine RICHTIGKEITS-, keine Sparsamkeitsfrage.**
*Anker: :29659–29665.* Auf einem echt geteilten Stack fände die Rückwärtssuche **den falschen Aufrufer**
(den zeitlich nächsten *fremden* `IN`). Wer einen geteilten Stack baut, muss bei der Auflösung zusätzlich
nach Thread filtern und hat die Sperren im Hot-Path umsonst bezahlt. → **Designplan-TDD**.

**A11 · C-13: drei Punkte, die VOR dem Setzen der CMake-Flags am Objekt zu klären sind.**
*Anker: :29707–29716.* (1) Ist die Mess-Ebene je Target eindeutig? (sonst muss die Ebene am Aufruf stehen)
(2) **Wohin gehört die Gattungs-Interface-Ebene — vierte Ebene im Filter oder Sonderfall von `macro`?**
Das entscheidet, gegen welche Ebene ein Micro-Checkpoint seinen Aufrufer sucht. (3) **Ebenen-Flags und
CEB-Gates sollten EIN Mechanismus sein, nicht zwei** — berührt unmittelbar das G3-Folgepaket (A14).
→ **Designplan-TDD** (Punkt 2 berührt KON95-O2/W3 direkt).

**A12 · N-1…N-7: wer der Aufrufer ist — Owner-Nachtrag 08.08.**
*Anker: :29336–29433.* Owner verbatim: *„Der Aufrufer ist also nicht uniform, sondern ein Prozess UND
einer von dessen Threads. […] Ein thread ist also systemisch ein visitor in allen Mess-Ebenen unter einem
Prozess […] Wenn ein Thread ein Interface betritt, aber es nicht wieder verlässt, ist das eine
Regression."* Daraus: **N-4 je Aufruf ZWEI Checkpoints (IN=Interface-enter, OUT=return)** — als *eine
Zeile je abgeschlossenem Aufruf* wäre der nie zurückkehrende Aufruf **unsichtbar**; **N-6 INVARIANTE:
je (Prozess, Thread, Interface) muss die Checkpoint-Folge BALANCIERT sein; ein IN-Überhang ist ein
BEFUND, gehört als Wache in die Auswertung**; **N-7** eingedampft schreiben (Ankunftsfolge), je Thread
zerlegbar lesen ⇒ Thread-Kennung und Zeitpunkt in JEDER Zeile, Zeitbasis über Threads vergleichbar.
→ **Designplan-TDD + Task-Karte (Wache)**.

**A13 · N-5: die compare-Ebene liegt IN DER CEB, noch VOR dem Prüfdock.**
*Anker: :29388–29401.* Schärfste Ortsangabe für die oberste Mess-Ebene; die Aufrufer-Kette schliesst sich:
`CEB-Thread (compare, vor dem Prüfdock) → Interface-Funktion der Tier-Binary (macro) → Achsen-Aufrufe
(micro)`. → **Designplan-TDD** (die Kopf-Steuerdock-Karte verortet compare nirgends).

**A14 · BAU-AUFTRAG: G3 aus dem `COMDARE_CE_ENABLE_STATISTICS`-Gate lösen — Vorbedingung für die 6 CEBs.**
*Anker: :29062–29075 (und :29012–29020).* `profile_facade/mess_achsen_naht.hpp:81-95` verbatim:
*„EHRLICHE GRENZE DIESER SCHEIBE — macro UND micro SIND HEUTE NICHT TRENNBAR. G2 und G3 teilen sich EIN
Gate. […] Das Herauslösen von G3 aus dem STATISTICS-Gate in ein eigenes Makro ist ein EIGENES
FOLGEPAKET (es berührt abi_adapter.hpp im Hot-Path und die A8-S4-Präprozessor-Wache)."*
**Heute sind maximal 2 der 6 CEB-Varianten herstellbar; `wallclock` ist gar nicht ausbaubar, weil G1 von
jedem Tooling gezogen wird.** Die Differenz-Arithmetik existiert nirgends (Nullbefund mit Gegenprobe:
`measurement_combo` = 27 Dateien, die Suche greift). → **Task-Karte: eigener Bau-Posten, Vorbedingung für
die Messfehler-Elimination.** Trägt heute KEINE Nummer im Kopf-Board.

**A15 · Break-Even: kubischer B-Spline (B=3), als String serialisierbar UND parsbar, erster Messwert = Basis 0.**
*Anker: :28779–28791 (Owner verbatim) + :29022–29030 (Befund).* Owner: *„interpoliert diese mit einer
möglichst scharfen Spline B=3 in eine mathematische Funktion, die als String gespeichert und wieder
geparst und interpretiert werden kann […] Der erste Parameter-Messwert bildet im Ausgangszustand bei 0
die Basis."* + *„Wir brauchen nur eine konsolidierte Implementierung, bitte führe beide zusammen."*
**Befund: DREI Code-Orte** (`heuristik/`, `builder/curve_fit/`, `builder/best_binary_selector/`),
`curve_fit` trägt eine **Kopie** der Fritsch-Carlson-Mathematik. Nullbefunde mit Gegenprobe: B-Spline
(6 Muster → 0) · String-Serialisierung (8 Muster → 0) · Basis-bei-0 (nirgends). **Der schärfste Punkt:
beide vorhandenen Implementierungen haben x = LAST, die Owner-Kurve läuft über die ZEITACHSE eines Laufs
(aus den Checkpoints). Beide werden gebraucht, es sind zwei verschiedene Objekte.** Datenquelle fehlt:
die CSV trägt weder Checkpoint-Spalte noch Zeitstempel — *„Erst Checkpoints + Wallclock, dann B-Spline."*
→ **Designplan-TDD + Task-Karte.** Der Kopf kennt nur V7 (Break-Even-SCOPE), nicht die Konstruktion.

**A16 · Break-Even wird DREIMAL berechnet, je Baum-node-Tiefe.**
*Anker: :28927–28943.* Micro (Achsen-Algorithmen querschneidend) · Macro (Akkumulation je Tier-Binary-
**Funktion**) · combined (Gesamtverlauf ⇒ beste Binary). Owner: *„Der Break even wird also je isolierter
Achsen-Permutation und damit je Baum-node-Tiefe verglichen. Das ist unser Ziel."* → **GOAL v8 / #7**.

**A17 · RECORD-AND-REPLAY als MESS-VERTRAG zwischen den 3 Ebenen.**
*Anker: :29077–29089, Owner verbatim.* *„Jede Achse muss dazu in einem original festgestellten RAM
Zustandes einer Gattung auf den exakt festgehaltenen replay Achsen-Aufruf mit warmem Cache einzeln
durchgemessen werden. Zwischen den 3 Mess-Ebenen existieren Verträge, die beinhalten, dass stets der
Aufruf, Zeitpunkt und der Zustand des durchzumessenden Bestandteils als snapshot nach jedem
Durchführungs-Zeitpunkt eingefangen werden muss, um ihn per replay über jede einzelne Komponente zu
wiederholen."* Statt alles gleichzeitig zu messen (Sonden stören sich) wird `(Aufruf, Zeitpunkt, Zustand)`
aufgezeichnet und EINZELN nachgespielt. → **GOAL v8 + Designplan-TDD.** **Im Kopf und in der Gegenlese-
Karte kommt Record-and-Replay nicht vor** — es ist aber der Träger der Messfehler-Elimination.

**A18 · RELEASE ist eine REKONSTRUKTIONS-Anfrage, kein Bau-Modus — und es löst W9.**
*Anker: :29091–29106, Owner verbatim.* *„Release ist also eine Anfrage an eine dokumentierte compare
Bibliothek der Messwerte, um je Ziel-Architektur der System-Achse die perfekte Tier-Binary […] zu
rekonstruieren und auszuliefern und bei Bedarf nur mit Wall-clock time und ohne Messfühler kompiliert
erneut in ihrer Gesamt-Geschwindigkeit durchzumessen gegen die Prüfdock google Tests als Verifikation
dafür, dass sie funktioniert."* ⇒ **Binaries müssen nicht aufbewahrt werden** („Wenn wir die Messwerte
haben, kennen wir ja die Eigenschaften der Binary dazu"). `measure ⊂ compare ⊂ release` bekommt in der
dritten Stufe eine prüfbare Semantik. → **GOAL v8 / Designplan-TDD.** **Auflösung für W9 der Gegenlese-
Karte** („Lager lagert Messdaten, nicht Binaries" vs. „Binaries→Lager gebaut"): beides gilt, weil die
Binary rekonstruierbar ist — kein Owner nötig.

**A19 · Die Klebe-Zeit der Gattungs-Interfaces ist ein SEPARATER Messpunkt.**
*Anker: :29312–29322, Owner verbatim.* *„Die Ebene der Gattungs-Interfaces und deren Funktions-
implementierung die zwischen den Achsen-Interface-Aufrufen liegt, muss über das Macro-Benchmarking
separat gemessen werden, weil es die Aufrufe an Achsen zwar verbindet aber nicht vollständig überwachen
kann."* = Macro-Gesamt **minus** Summe der zugehörigen Micros. **„Wer Macro aus den Micros errechnet,
verliert genau diesen Anteil und schreibt ihn fälschlich den Achsen zu."** → **Designplan-TDD (harte
Auswerte-Regel) + GOAL v8.**

**A20 · Die Mess-Ebenen SIND das Stack-Aufrufmuster der drei Architektur-Layer.**
*Anker: :29303–29310, Owner verbatim: „Die Mess-Ebenen entsprechen damit gleichzeitig dem Stack-
Aufrufmuster zwischen 3 Layern der Architektur."* compare = Lastprofil-Ebene · Macro = Gattung+Genus-
Interface · Micro = Achsen-Interface; die Spalte **Aufrufer** ist die **Stack-Kante**, nicht Buchhaltung.
→ **GOAL v8 / Designplan-TDD.**

**A21 · Blattzahl-Formel + interne Hyperlinks als Abstiegsweg.**
*Anker: :29281–29301.* Owner: *„die sheets einer jeden Achse in den Micro-benchmarks stattdessen
zusammenlegen und den Aufrufer und den Zeitpunkt des Aufrufes sequentiell dort mit allen messwerten
loggen […] Dasselbe machen wir für das Macro-Benchmarking, sodass jede FUNKTION einen sheet bekommt."*
⇒ **Blattzahl = 1 + |Funktionen| + |Achsen|**, unabhängig von der Lauflänge. Abstieg über **anklickbare
interne Links** (`write_url` auf `'Sheetname'!A1`): compare → Funktions-Sheet → Achsen-Sheet.
→ **Designplan-TDD.** KON88 trägt die Sheet-je-Achse-Regel, **nicht** die Hyperlink-Mechanik und nicht die
Blattzahl-Formel.

**A22 · Fassung 3 und Fassung 1/2 sind ZWEI Blatt-Familien in EINER Mappe, kein zweiter Writer.**
*Anker: :29324–29333.* Ergebnis-Blätter (Zeile pro Messergebnis je Permutation) und Profil-Blätter
(compare/je Funktion/je Achse, Zeile pro Aufruf) teilen **dieselbe Factory, dieselbe 31-Zeichen-Wache,
dasselbe INFO-Sheet**. → **Designplan-TDD / #18.**

---

### A-Korb 2 — Grösse, Paper, Planer

**A23 · `cache_engine --check-size "FILE"` — die vier bindenden Eigenschaften, Owner verbatim.**
*Anker: :28714–28724.* *„welche aus einer XML Datei wie geplant die vorraussichtliche Experiment Grösse
und Dauer berechnet, indem das Programm bereits auf der Zielmaschine läuft und per Hardware-Erkennung
eines zu bauenden CEB die Systemeigenschaften bestimmt (ist das CEB nicht vorhanden wird es vorsorglich
gebaut und dann vom Planer über den geplanten Vertrag befragt, die Berechnung findet ebenfalls auf der
CEB statt)."* Vier Bindungen: läuft auf der **Zielmaschine** · **Hardware-Erkennung** · baut die CEB
**vorsorglich** · **rechnet AUF der CEB**. Und die Rüge dazu: *„Rechne diese bitte NIE mehr pauschal
nach."* → **Task-Karte #7/S-19.** KON73 kennt die „check-size-Lücke Planer-statt-CEB" als Explore-Karte,
nicht die vier Bindungen.

**A24 · Die Auflösung, die den Owner-Satz substantiell macht: GRÖSSE ≠ DAUER.**
*Anker: :29032–29047.* Planer und CEB linken **dieselbe Bibliothek** (`comdare::profile_run_facade`) —
CPU-Threads, Cache-Line, freier Platz, SIMD-Freigabe sieht der Planer-Prozess auf derselben Maschine
selbst; *„eine Prozessgrenze, über die nur solche Werte reisen, ist eine leere Naht."* **Die GRÖSSE kann
der Planer allein** (XML-Freigabe + deterministischer Director-Walk). **Die DAUER kann nur die CEB**, weil
die Instrumentierung in sie einkompiliert ist — eine `[all]`-CEB misst langsamer als eine `[wallclock]`-
CEB. **Und weil es 6 Varianten gibt, liefert die Befragung nebenbei die ERSTE MESSUNG DES MESS-OVERHEADS
— `--check-size` und die Messfehler-Elimination sind dasselbe Werkzeug.** → **Designplan-TDD + #7.**

**A25 · Drei Owner-Gründe, warum die Menge kleiner ist als jedes Achsenraum-Produkt.**
*Anker: :28726–28733.* (1) *„lässt sich nur für die von mir in der XML freigegebenen
einstellungen/Algorithmen […] permutativ mathematisch bestimmen"* — **nicht der Achsenraum ist die Menge,
sondern die Freigabe**; (2) *„einen grösseren Satz an binaries zu bauen, aber nur einen Teil davon
durchzumessen"* — **Bau-Menge ≠ Mess-Menge**; (3) *„das full join Ergebnis je Achse über alle Achsen,
zusammengelegt über alle betrachteten Paper"*. → **GOAL v8 / #7** (stützt KON91/KON94-Full-Join;
Punkt 2 ist der offene D-5-Gegenstand der Gegenlese-Karte).

**A26 · PAPER = EIN EXPERIMENT-XML; „Es gibt keine Kandidaten" — und der Faden riss am 20.07.**
*Anker: :28735–28748 (Owner verbatim) + :29002–29011 (Befund).* Owner: *„dass ein Paper genau ein
Experiment-XML ist, welches wiederverwendbar bereit liegt. Die compile time stellt aus dem gesplitteten
Entwurfsmuster die original binary des Paper-Experimentes wieder her […] Es gibt keine Kandidaten […]
und dann gibt es den Nachweis des PRT-ART Prüflings und dessen Einsetzung in die Achsen."*
**Ist-Stand:** 33 SOTA-Profile P01..P33 lückenlos, 23 Allokator-Profile, 21 Lastprofile, 21
`PAPER_REFERENCES.md`, Original-Code in 17 `paper_*`-Bäumen. **Was fehlt:** kein einziges *Experiment*-XML
je Paper (sota-Akten tragen die Wurzel `comdare_algorithm_profile`, der Planer-Eingang heisst
`comdare_experiment`), `profile_ref` wird **geparst und nie dereferenziert**, `drop_tier_level` zieht die
Paper-Ebene ab ⇒ **die 7 base_tiers erzeugen heute keine einzige Binary**. Owner-GO liegt vor: *„Ja unter
sorgfältiger Design Planung bitte bauen, Rücksprache mit mir im Detail."* → **GOAL v8 + Task-Karte
(eigener Posten).** Weder Kopf noch Gegenlese-Karte führen diesen Auftrag.

**A27 · Owner-Entscheid: `build_axis_levels` UND `build_profile_basis_levels` fallen BEIDE.**
*Anker: :28874.* *„Das muss abgelöst werden durch den PLANER INTERPRETER."* Keine Wahl zwischen beiden.
**Falle dazu (:28486–28489):** ein **fünfter** D-2-Kandidat **917.504** (7 base_tiers × 2^17) entsteht,
sobald jemand `build_axis_levels` statt `build_profile_basis_levels` fährt — **beide liegen nebeneinander
in derselben Datei**, keiner der vier bekannten Kandidaten rechnet das mit. → **Task-Karte + Fallen-
Register.**

**A28 · `compare` vergleicht heute nichts.**
*Anker: :28490–28492.* `run_methodology_registry.hpp:144-148` nagelt per `static_assert`:
*„compare = {Release, misst NICHT, parallel} (Etikett-Stand, Vollzug D2)"*. → **Task-Karte** (stützt den
Karte-Kern „PHASE = vier Modi, 0 Code-Treffer, zu bauen").

**A29 · L3-Asymmetrie prod1: 8 physische Kerne je Domäne — verdoppelt die MESSUNGEN, nicht die Binaries.**
*Anker: :28493–28495.* SMT-Geschwister, `core_id` verifiziert; berührt die Binary-Zahl nicht (Pinning ist
dynamisch). Dazu **prod2 hat KEIN AVX-512** (:28470). → **#7 S-19-Eingang.** Beides fehlt im Kopf.

---

### A-Korb 3 — Stempel / Identität / golden

**A30 · Flag-Katalog: Identität ist das PAAR `(token, eltern)`, nie das Token.**
*Anker: :27401–27420.* Belegt: `flag_grammar_catalog.hpp:144` führt **`f` als FPGA** (Tiefe 0),
`:208` **`f` als AVX-512-Foundation** unter `x512`; ebenso `vnni` (`:189` avx_vnni/x256 gegen `:216`
avx512_vnni/x512 — verschiedene CPUID-Bits) und `ifma`. **„Wer nur Token prüft, kann diese Fälle nicht
unterscheiden."** Die Tiefe muss die Wache NICHT prüfen (die Eltern-Kette begrenzt sich selbst).
**Drei Wachen gegen die TABELLE selbst:** grammatische Erreichbarkeit jedes Katalog-Tokens · **Drift-
Brücke zu allen 23 Einträgen von `simd_feature_flag.hpp`** · Paar-Eindeutigkeit + Eltern-Existenz.
**Leere Felder sind Aussagen:** `cpuinfo == ""` heisst „über /proc/cpuinfo nicht signaturfähig" —
*„eine geratene Id wäre schlimmer als eine leere"*. → **ARBEITSWEISE (Stempel-Syntax) + Designplan-TDD.**
Ergänzt die Memory-Regel „Kürzel IMMER zerlegen" um die Eltern-Dimension.

**A31 · Owner-Entscheid F4 (07.08. abends): `mmx` BLEIBT deklariert — wegen RISC-V im Cluster.**
*Anker: :28205–28213.* *„Das ist technisch korrekt, wenn die Hardware vorhanden ist, dann wird sie
deklariert. wir haben auch einen Vision5 2 mit RISC-V, mmx ist nicht selbstverständlich."*
Der Katalog beschreibt eine **plattformübergreifende** Landschaft, nicht nur die x86-Zelle. → **Task-
Karte (Flotten-/OS-Realm) + Designplan.** Der **VisionFive 2 (RISC-V)** taucht im Kopf nirgends auf.

**A32 · A1: die Medien-Basis heisst `m64`, NICHT `x64` — mit Recherche-Beleg.**
*Anker: :28411–28432.* AMD APM Vol. 3 Anhang D §D.1: MMX und 3DNow! sind **eine** Gruppe („64-bit media
Instructions") auf **einem** Registersatz (MM0-MM7, x87-überlagert) mit vier Subsets. Härtester Beleg:
**3DNow! hat keinen einzigen Transferbefehl**, `MOVD`/`MOVQ` sind MMX-gegatet. Der Name `m64`, weil „x64"
die Architekturbezeichnung ist, „64" schon mit der Adressbreite belegt ist und das `x`-Präfix eine
gemeinsame Achse mit `x128/x256/x512` behaupten würde — **MM ist eine andere Registerdatei**.
**N-1 gemessen statt behauptet:** `gcc -mmmxext` ist *unrecognized*, ein mmxext-Makro existiert in GCC
überhaupt nicht; korrigiert auf `-msse`. → **Designplan-TDD / Bleib-Notiz.**

**A33 · E-A: der Name ist SHA-256 (64 Hex) und KEIN Präfix des Fingerprints.**
*Anker: :27914, :27924–27929.* Owner: *„wir verwenden dann bitte doch der Einfachheit wegen SHA256"*.
64 Hex passt unter `kStemMax = 120` — der 128-Hex-Konflikt mit dem Windows-MAX_PATH-Deckel fällt weg
(Vorfall 03.06.: ungekappter Stem → **stiller** `ofstream`-Fehlschlag, `built=0`). **ACHTUNG: der Name ist
ein EIGENER Hash über dasselbe Preimage, nicht `fingerprint[0:64]`** — gehört als Kommentar an die Stelle.
→ **Designplan-TDD / #15-Fenster.**

**A34 · E-B bricht den golden-CRC — und steht in KEINEM Kopf-Fenster.**
*Anker: :27915, :27931–27937, :28020–28041.* Owner: *„Wir brechen golden-CRC!"* ⇒ Variante **(i)**: der
Emitter schreibt den Namen in den generierten Quelltext. Der Explore fand die vom Owner genannte
Lagerhaltungs-Begründung **nicht** (vier Code-Belege: Identität über `key_sha512` aus dem **Sidecar**);
§43 (`:2441`) fordert *„als string_view in die Tier-Binary zur Versionierung einkompiliert"* — das ist
**Variante (ii)**, eine wörtliche Symbolnamen-Forderung enthält §43 nicht. **Der Bau folgt der Owner-
Setzung; der Kommentar sagt beides.** → **#16/#15 golden-Fenster.** Der Kopf führt EIN golden-Fenster
(B2+#16+organ_axes+#72-queuing) — **E-B ist ein weiterer golden-brechender Posten, der dort fehlt.**

**A35 · Ω-1/Ω-2/Ω-3: core_class-Resolver, Provenienz-Spalte, L3-Scharfschaltung.**
*Anker: :27920–27922.* Ω-1 Resolver **generisch** über alle drei RT-Unter-Achsen (löst OD-10 **und**
OD-11) · Ω-2 CSV-Spalten `core_class` **und** `core_class_source` — *„die Provenienz muss mit"* ·
Ω-3 auf prod1 an der **L3-Achse** scharfschalten, sobald der Resolver steht. → **Task-Karte.** Fehlt
vollständig im Kopf.

**A36 · §43 ist die belegte Begründung für den einkompilierten Stempel — und die Erst-Klammerung 19./20.07.**
*Anker: :27993–28048.* Owner 19.07.: *„Mess-Achse[a,b,c]→[a,b,c]CEB-Typ→CEB definiert System-Achsen
[d,e,f]→…→[d,e,f,g,h,i]Tier-Binary"*, Sofort-Korrektur 20.07. Rollenteilung:
`ceb:build:[a,b,c]` (Mess-Achse baut NUR die CEB) · `tier:build:[d,e,f][g,h,i]` (**Mess gehört NICHT
hinein**) · `measure:[a,b,c][d,e,f][g,h,i]`. §43: *„welche Tier-Binaries bei Update eines einzelnen
Achsen-Algorithmus neu gebaut werden müssen und welche nicht […] in 2 verschiedenen string_view-Zeilen:
eine für System-Achsen und eine für Organ-Achsen."* **Der Stempel muss IN der Binary sein, damit man VON
DER BINARY AUS entscheiden kann.** → **Designplan-TDD / Bleib-Notiz** (trägt die Skip-Ökonomie, Karte
Korb C-13).

**A37 · Sidecar-Verdikt: `.fingerprint` und `.version` sind UNENTBEHRLICH — Bleib-Notiz gegen Fehl-Abriss.**
*Anker: :27789–27826.* `.fingerprint`: **der Lookup läuft strukturell VOR dem Bau** — *„für eine Binary,
die in diesem Moment noch nicht existiert, ist ein Probe-Symbol strukturell unerreichbar"*; bis zu
**131.072-mal je Lauf**; zugleich **Lager-Index-Schlüssel für Cross-Maschinen-Transport über minio ohne
Laden** (F7 „eine Schlüssel-Welt": Skip-Gate == minio-Key == Bestandslog-Key == Baum-Blatt-Identität).
`.version`: **TRANSPORT-VOLLSTÄNDIGKEITS-SENTINEL** — die DLL wird zuerst, `.version` zuletzt geschrieben,
`prune_verdict` erlaubt lokales Löschen nur bei byte-gleicher Remote-Spiegelung; *„eine byte-perfekte DLL
mit abgebrochenem `.version`-Schreiben wäre selbst vollständig ladbar"*. `.algos`/`.variant` sind seit der
A2-Eichung **gate-los** und technisch entbehrlich. → **Designplan-TDD / Bleib-Notiz (Karte Korb D-24).**

**A38 · variant-Verbot: die Begründung ist SPEICHER-MATHEMATIK — und es gibt genau EINE Ausnahme.**
*Anker: :27765–27788, :29984–29989.* golden N = 131.072 × ~60 MB (variant-Bloat) = **7,5 TB > 6 TB
verfügbar**; bloat-reduziert (~2-5 MB) = **256-640 GB**. *„`std::variant` ist damit die dritte
Voraussetzung für das golden N überhaupt."* IST: 68 Treffer / 45 Dateien, **kein Verstoss** (~55
Doktrin-Zitate · 2 in Quarantäne test-only mit Compile-Guard `test_striktheit_metaprog_guard.cpp:85-97`
über alle 11 Referenz-Anatomien · 2 legitim ausserhalb: `BuildError`, `PressureState`). **Die eine
Ausnahme (Owner-KERN 02.08.): `HybridDockVariant` — nur die Hybrid-Stufe HINTER der CEB; „In den plain
Tier-Binaries bleibt std::variant verboten (uneingeschränkt)." Diese Stufe ist noch nicht gebaut; K1-K6
sind bindend VOR dem Bau.** Owner 07.08. *„Der Speicher ist kein Problem"* = kein Blocker für den Bau,
**nicht** „das Verbot fällt" (§66-N3: keine runtime→CT-Brücken). → **HY-Design-Register / #24.**

**A39 · Zwei Messpfade A/B — und eine Doku-Auflage, die NICHT durchgängig erzwungen ist.**
*Anker: :28300–28318.* **Pfad A** (in-DLL, segmentiert, `abi_adapter.hpp` — die Batch-Schleife läuft
komplett INNERHALB eines Aufrufs) · **Pfad B** (host-getrieben, pro Operation über die ABI-Grenze).
`host_measure_loop.hpp:43-47` + `tier_observe_trace_abi.hpp:141-174` umklammern mit `steady_clock`
**genau einen virtuellen Aufruf, pro Operation**. Kein Ersatz ohne Architekturwechsel (CRTP ist über eine
dynamisch geladene `.so`-Grenze unmöglich, ohne die ABI-Fähigkeit aufzugeben). **Auflage: Latenz-
kritisches IMMER über Pfad A; Pfad B nur für Füllstand/Observer-Snapshots — „an einer Stelle steht das
schon, durchgängig erzwungen ist es nicht."** → **Task-Karte (Wache) + Designplan-TDD.**

**A40 · Jitter-Review: was BEWUSST kein Verstoss ist (Bleib-Notiz).**
*Anker: :28337–28345.* ART-Trie `switch (ref_kind(r))` = **Node-KIND** (N4/N16/N48/N256), von der Baumform
zur Laufzeit abhängig — *Adaptive* Radix Tree per Definition, nicht CT-machbar · SuRF MurmurHash-Tail
(0-3 Restbytes) · wormhole `std::map` als interne Struktur EINER Suchstrategie · 17 `anatomy/*_tier.hpp`
mit `virtual` nach dem Muster *„Host fragt via `dynamic_cast` 1× KALT je Modul, nie im Hot-Loop"*.
→ **Bleib-Notiz / Designplan.**

---

### A-Korb 4 — Lager, xlsx-Rohr, ETA

**A41 · Owner: EIN Storage-Tree, ZWEI Filesystem-Wurzeln, ZWEI DURCHLÄUFE.**
*Anker: :29927–30023.* Owner: *„Die binaries und Messdaten teilen sich denselben Lagerhaltungs-Baum beim
Aufbau und haben nur unterschiedliche factory pattern und detail pattern […] beide verwenden exakt
denselben Baum."* + *„Ja die Realms sind per Filesystem getrennt aber der Strategy-Storage-Tree ist im
code derselbe […] Eine wurzel binaries, eine wurzel measurements."* + *„konzeptionell synchron angelegt,
in der Realität werden Ordner und Daten erst lazy erstellt […] Die Binaries werden erst gebaut und dann
in einem zweiten durchlauf die Messungen darüber erzeugt."*
**Am Objekt belegt:** `enum class LagerRealm { binaries, messdaten }` (:76) · `template <LagerRealmPolicy
Policy> class LagerBaumWriter` — **ein** Writer (:533-534) · `MessdatenRealmPolicy`/`BinariesRealmPolicy`
(:387/:419) · `static_assert(LagerRealmPolicy<…>)` für beide (:454-455) · `make_binaries_baum_writer`
(:600). **Die abweichende Ebenen-Reihenfolge (D-12: Mess-Typ als tiefster Knoten im Binaries-Realm) ist
die Detail-Pattern-Differenz, KEIN Defekt** — die zweite Lesart ist ausdrücklich gestrichen.
**Und die Folge, die im Ledger vorher nirgends in einem Satz stand:** Bau- und Mess-Fortschritt sind im
Batchplan **zwei getrennte Präfix-Zähler** (`kompiliert`/`gemessen`) und dürfen nicht vermischt werden —
**sie zählen zwei Durchläufe, nicht zwei Sichten auf einen.** → **Designplan-TDD + #57/#18.**

**A42 · SKIP gilt für Messdaten UND Binaries; neue Version tritt NEBEN die alte, nie ersetzend.**
*Anker: :29886–29908, :29933–29937.* Owner: *„Die operation bei Validen Messdaten ist skip für die XLSX,
sofern von der exakt gleichen binary gemessen wird. Jede neue Version dieser Binary erzeugt auch neue
Messdaten […] und behält die alte Version zusätzlich."* + *„Die Operation bei validen Binaries ist
ebenfalls skip."* ⇒ **es gibt kein Überschreib-Problem, weil nie überschrieben wird**; der Schlüssel ist
die Binary-Identität (Fingerprint). Der xlsx-Writer erfüllt das bereits: atomar-additiv über tmp+rename,
**null** Vorkommen von `stale` im Schreibweg, `ErgebnisSchreibFehler` statt stillem Truncate.
→ **Designplan-TDD / #18.**

**A43 · Das xlsx-Rohr fehlt an einer benennbaren Stelle: `WritebackMethod` kennt kein `xlsx`, und die XSD
fängt es nicht.** *Anker: :29164–29169.*
`measurement/writeback_method_registry.hpp`: `enum class WritebackMethod { Csv, LatexTable,
ComparisonMetrics }`, `kWritebackMethodCount = 3`, compile-time fixiert. **Die XSD prüft
`<method value="…"/>` nur strukturell (freier `xs:string`) — wer heute `value="xlsx"` schreibt, bekommt
keinen Compile-Bruch, sondern einen zur Laufzeit unbekannten Wert.** *„Ohne vierten Registry-Wert bleibt
der Schalter unwirksam, egal wie fertig der Writer ist."* → **#18 S-13-XSD.** Der vierte Registry-Wert
ist über KON23-03 gedeckt, **die XSD-Lücke (freier String ohne Enum-Wache) nicht.**

**A44 · Die Datei-Flut ist am Objekt belegt.**
*Anker: :29171–29176.* `cache_engine_builder_iterator.hpp:1119-1126, 1913`: bei `per_binary_subdirs=true`
bekommt **JEDE** Tier-Binary ihr eigenes `result.csv` im eigenen Unterordner — bei 320 Binaries **320
Einzeldateien** plus die aggregierte `measurements.csv`. → **#18** (anderer Ort als der in der Gegenlese-
Karte geführte `iterator:3089-3093`-Befund).

**A45 · A9-Bauliste: was vom xlsx-Writer wirklich fehlt.**
*Anker: :29185–29201.* Gelandet: S1 Vendor (`351205f5`). **Halb:** S2 `lager_pfad_grammatik.hpp` mit
`blatt_dateiname()`. **Fehlt/nie begonnen:** `ergebnis_dateiname.hpp` (Namens-Fassade + Wachen) ·
`ErgebnisSchreibFehler` · S3 `IErgebnisBlatt`/`IErgebnisMappe`/`ErgebnisMappenFactory` ·
`XlsxErgebnisMappe` (eigene TU, PRIVATE gegen den Vendor gelinkt) · `CsvErgebnisMappe` · INFO-Sheet-
Inhalt (Sysinfo, Haupt-Achsen, Sheet-Legende) · `WritebackMethod::Xlsx` · S4 CLI `tools/mess_report/` ·
S5 Erstbeleg-Render gegen das 26.07.-Archiv. **Die Wurzel der Rüge:** *„A9-S1 (Vendor) ist gelandet,
A9-S3/S4/S5 wurde nie begonnen. Die Bibliothek steht, das Rohr dahinter fehlt — also fällt alles auf CSV
zurück."* → **#18 Task-Karte** (der Kopf führt die Sheet-Systematik, nicht diese Bauliste).

**A46 · Zeilenlimit als Fehlerklasse statt stillem Truncate.**
*Anker: :29142–29145.* Zeilenlimit 1.048.576 → `ErgebnisSchreibFehler{zeilenlimit}` **statt stillem
Truncate**; Dateiname-Grammatik `datum "-" zeit "_" kvkette "." endung`, `endung := "xlsx" | "csv"`.
→ **Designplan-TDD** (KON87 deckt den 31-Zeichen-Beweis, nicht das Zeilenlimit).

**A47 · CSV-Dateiname-Grammatik: EBENE anführend, dann parsebarer ZEITRAUM.**
*Anker: :29263–29268.* Owner: *„welche die Zeiträume parse-bar im Namen tragen und anführend im Namen
ihre Ebene für das Messblatt benennen."* → **Designplan-TDD / KON89-D3-Nachzug.** KON89 legt die
Ordner-Verschachtelung fest, **nicht** die Namens-Grammatik — diese hat kein jüngeres Gegenwort.

**A48 · ETA-Merge verwirft STILL — offener Owner-Entscheid mit fertigem Ein-Feld-Schnitt.**
*Anker: :27584–27595, :28103–28116.* Am Objekt gemessen: `merge_documents(remote{offen, eta=100},
lokal{offen, eta=250})` liefert **100** (`pick_reservierung`, `bestandslog_lock.hpp:380-388`: bei gleichem
Rang gewinnt die gefüllte `eta_s`, sonst stabil `a`) — **jede zweite Fortschreibung derselben offenen
Reservierung wird verworfen, während `store()` `true` meldet.** Heute kein Live-Pfad (ETA-Zweig =
Vorhaltung), **wird scharf, sobald periodische Updates gebaut werden.** Zusätzlich: der Takeover-Uhr-Anker
misst an `reserviert_utc`, das sich nicht bewegt. **`BatchReservierung` trägt weder `last_update`- noch
Perm-Feld.** Der Schnitt liegt fertig vor: **ein `last_update_utc` (syntax-Bump, ans ENDE der Feld-Folge
wegen Byte-Stabilität) löst Merge-Konflikt UND Uhr-Anker — „ein Feld, zwei Defekte, ein Bump".**
Owner-Entscheid ausstehend: geänderte Konflikt-Auflösung **oder** monotones Ordnungsfeld.
→ **Task-Karte + Owner-Vorlage.**

**A49 · ETA-Doktrinzahlen und -Härtungen (Bleib-Notiz).**
*Anker: :28061–28087, :27610–27624.* `ETA = max(Sum(t_i)/N_threads, max(t_i))` — *„Amdahl in einer Zeile"*,
verhindert die unmöglich kurze Selbstfrist. Zweige: **ohne** brauchbare ETA pro-forma **30 min**
(`kProFormaMinutes`), **mit** `elapsed > 1.5 * eta_s` (`kTakeoverFactor`). *„Brauchbar"* dreifach gehärtet
(parsbar UND positiv UND **endlich**) — `0` ⇒ Falsch-Enteignung, `"inf"` ⇒ **permanente Verklemmung**.
Belastbarkeit ab `n_threads` Punkten (Doktrin-Zahl, LEDGER:3290); **Ausreisser getrennt nach Fall:** der
vermessene Block ist eine **Beobachtung** (Doktrin-Formel), das Rest-Fenster eine **Projektion** (Median).
Gemessen 31×2,0 s + 1×20,0 s / 32 Threads / 4096 Rest → Median 256,0 s gegen Mittelwert 328,0 s =
**28,1 % Aufschlag, den der Median nicht zahlt**; `longest_seen` überlebt den Block-Schnitt als
Untergrenze. Re-Kalibrierung je Block (Pflicht, LEDGER:3299) **plus** 25 % relative Abweichung — *„die 25
sind gewählt, nicht gemessen"*. → **Designplan-TDD / Bleib-Notiz.**

**A50 · Offene Owner-Frage: ist ETA nur der Lease-Timer oder auch Dispositions- und Kapazitätswert?**
*Anker: :28118–28127.* `eta_s` wird von **genau zwei** Stellen gelesen (Takeover-Prädikat +
`planner_status_reader.hpp:330`, der nur *zählt*, wie viele Reservierungen keine ETA haben). **Kein
Verbraucher nutzt die ETA für eine DISPOSITION**; `avg_size_bytes` wird eingetragen, aber **keine Stelle
rechnet daraus eine Platzvorhersage**. Die Antwort entscheidet, ob `avg_size_bytes` der Eingang in die
**df-Wache** wird, die §V7.4 für den Voll-Bau fordert. → **Owner-Vorlage.**

**A51 · Verhaltensänderung auf dem LIVE-Takeover-Pfad, bewusst gelandet und revidierbar benannt.**
*Anker: :27597–27608.* Ein Record, der mitten im Slice eine ETA bekommt, wechselt von pauschal 30 min auf
1,5 × ETA. **Der eigentliche Defekt heute: ein laufender 4096er-Slice ist nach 30 Minuten für eine fremde
Maschine übernehmbar.** Für kurze Slices verkürzt die Änderung das Fenster. → **Bleib-/Revisions-Notiz.**

**A52 · Falle: `set_on_binary_done` ÜBERSCHREIBT.**
*Anker: :27626–27629.* Der Iterator hatte den Hook bereits mit dem Push-Pump belegt (`:1849`) — **ein
zweites `set_` hätte den asynchronen Push-Pump STILL abgeschaltet.** Jetzt steht `add_on_binary_done`
daneben, mit Test. → **Fallen-Register.**

---

### A-Korb 5 — Bauweg, Repo-Grenze, Prozess, Infra, Register

**A53 · Owner: `configure.sh` / `make` / `make install` / `make check` IM WURZELORDNER — beider Repos.**
*Anker: :29228–29251.* Owner: *„Alte mittlerweile verbotene behelfswege. Das einzige auf linux offizielle
Verfahren ist ja configure.sh/make/make install oder make check […] diese 3 müssen im Wurzelordner
liegen."* + Schnitt-Doktrin: *„trenne dafür auch den aufrufenden Anwender-Code nach Super gegen die cache
engine Bibliothek. super Entscheidet mit der XML was und wie ausgewertet wird, aber die gesamte Mechanik
liegt als Framework in der Cache engine samt Planer/CEB/Tier-Binaries. Der Anwender ruft also die CLI des
Planers auf, nachdem er sie per install kompiliert hat."*
**`make check` ist der offizielle Weg, nicht `run_all_tests.sh`; `Code/tools/` ist damit ersetzt.**
→ **Task-Karte (#74 Repo-Rollen) + GOAL v8.** Der Kopf führt F6 (ce=Framework, super=Einstieg) — **dies
ist die Owner-Quelle davon UND enthält den konkreten Bauweg-Auftrag, den F6 nicht trägt.**

**A54 · Owner: der zweite Thesis-Zeiger `Code/external/20260931-overleaf-diplomarbeit` BLEIBT — er ist ein
VERTRAG.** *Anker: :29207–29220.* Owner: *„weil sie gegen remote synchronisiert genau dort liegen muss,
wenn unter Ausführung der CI dann das Latex Anlagen-Ergebnis in die Arbeit committet wird […] Wenn wir
lokal laufen sollten auf einer Maschine und nicht CI (das war gefordert beides möglich), dann muss sich
die Diplomarbeit auf der Testmaschine auch dort ohne Netzwerk-Laufwerke lokal zusammensetzen."*
**Die Doppelung ist die Voraussetzung dafür, dass CI-Lauf und Lokal-Lauf denselben Pfad sehen.** Der
`.gitmodules`-Kommentar, der ihn „TOT" nennt, ist veraltet und gehört richtiggestellt.
→ **Task-Karte.** **Schliesst den Triage-Posten „Thesis ZWEIMAL als Submodul" der Gegenlese-Karte
(Korb D-23) — kein Aufräum-Gegenstand, sondern ein Soll.**

**A55 · Owner: `tier150_measurements.csv` ARCHIVIEREN (nicht löschen) — und damit fällt das `rm -rf build`-Risiko.**
*Anker: :29253–29257.* Owner: *„Bitte archivieren, ist veraltet. Wir messen den Gesamtstrang neu."*
Sie ist die einzige getrackte Datei unter `ce/build/`. → **Task-Karte + Memory-Nachzug** (nach Vollzug
wird `reference_ce_build_dir_has_tracked_measurement_csv.md` gegenstandslos). Kein Vollzugsbeleg im
Segment.

**A56 · SCHICHT-DOKTRIN mit ausdrücklichem Sofort-GO — ein benannter Verstoss.**
*Anker: :28965–28973.* Owner: *„die Schichten sind strikt einsortiert und unter Gattung kommt Genus und
darunter die Implementierungen verschiedener realer gesamt-interface-factory-strategien. Alles andere ist
unsauber. Das Fenster ist jetzt, bevor es teuer wird."* **Konkreter Verstoss:
`anatomy/container_framework.hpp:37` → `builder/.../genus_binding_traits.hpp`** (untere Schicht kennt
Namen der oberen). **GO für sofort.** → **Task-Karte (Bau-Posten) / #20.** Fehlt im Kopf.

**A57 · §75-Aufräumpass: 133 Kandidaten, davon 104 OFFEN — vollständig ungedeckt.**
*Anker: :29437–29521.* Zentrale Liste `docs/plaene/20260808-KANDIDATENLISTE-75-abschluss-aufraeumpass.md`:
**133 Kandidaten** (92 Ketten-Posten + 6 Startlisten-Posten ohne Nummer + 1 Waisen-Sammelposten + 34 ohne
Ketten-Nummer), davon **104 offen**, 14 erledigt mit Commit-Beleg, 8 gesperrt, 6 unbelegt, 1 am Ist
widerlegt. Drei Struktur-Befunde: **(a)** die Kette ist zerrissen — Posten (1)–(18) stehen
**ausschliesslich** in `20260802-KATALOG-offene-strecke-gesamtplan.md:98`, (25)–(29) **ausschliesslich**
in `20260803-FAHRPLAN-gesamtkette-wellen-phasen.md:68`; **wer nur den Ledger liest, sieht 74 von 92**.
**(b)** DREI kollidierende Nummernkreise (Ledger-`(N)`, ce-G8-`33–38`, super-`AP-01…AP-13`); „Posten 62"
bezeichnet an zwei Ledger-Stellen zwei verschiedene Dinge. **(c)** die Zeilen-Anker sind grossflächig
gewandert (Stichprobe 5/5) — **kein Anker der Liste darf ungeprüft benutzt werden.**
Ausserdem: **fünf Flächen, die sich selbst für tot erklären, sind NICHT frei entfernbar**, und die
Selbstaussage *„0 Konsumenten"* im Kopf von `concepts/scheduling_strategy.hpp` ist am Ist **falsch**
(2 Konsumenten, davon eine `static_assert`-Wache in `test_striktheit_axis_dach_guard.cpp:81`).
**Lehre:** *„ein Aufräum-Auftrag, der als eigenes, gegatetes Paket vereinbart ist, darf nicht nebenbei
unter anderem Namen zur Hälfte ausgeführt werden."* → **Task-Karte (eigener Posten) + Wellenplan.**
Weder Kopf noch Gegenlese-Karte kennen die 133/104.

**A58 · §55-RECONCILE: 26 Posten tragen noch Arbeit — und „ein Ledger-Satz ist kein Beleg".**
*Anker: :27512–27552.* 43 Meldungen = **36 unikate Posten**: VOLLZOGEN 5 · SUPERSEDED 5 · DUPLIKAT 7 ·
OWNER-FRAGE 5 · OFFEN 19 · NICHT ENTSCHEIDBAR 2 ⇒ **26 Posten tragen noch Arbeit, davon 6 rein
dokumentarisch.** SIEBEN Duplikat-Paare (#1-#19, #3-#26, #6-#21, #12-#40, #13-#41, #14-#36, #18-#35) —
drei fehlten in der Vortriage. ZEHN der 43 tragen eine andere Disposition als ihr Audit-Status.
**Doktrin, belegt in BEIDE Richtungen:** `:7885` führt GN-9 als offen, obwohl das Dossier ihn superseded —
und `:7016` **entlastet wörtlich einen xlsx-Writer, der nicht existiert**. *„Deshalb gilt: ein Ledger-Satz
ist kein Beleg."* Für VOLLZOGEN wurde durchgehend eine Code-/Commit-Stichprobe verlangt.
→ **Task-Karte + ARBEITSWEISE.** Die 26 sind im Kopf nicht verbucht.

**A59 · Kürzel-Kollisions-Register: NEUN tabelliert + F5 als zehnte + A12 gegen den golden-CRC + V32.**
*Anker: :27536–27544, :27580–27582, :29517–29521.* Tabelliert: **A15, O-A, D-4, R-2, F3, E18-SNAP, P-1,
T-n, B-1**; die schärfste: **`P-1` bezeichnet gleichzeitig KK-5 `allow_failure` UND die 30 Review-TODOs**;
die zwei A15 am Objekt getrennt (`:8339` FK-3/FK-4, `:7878` §55-Reconcile). **Zehnte: ZWEI F5-Namensräume**
(ETA-F5 in `20260801-KONSOLIDIERT-…-eta-sha512.md:68` gegen F5 = golden-Update-Fenster im Aufräumpass-
Plan). **`A12` kollidiert mit dem golden-CRC `0xF1C1F26A1232073B`.** **„V32" ist KEINE Verifikations-
oder Versionszahl, sondern der Name der historischen Messreihen-Familie (`Code/02_messung_driver/
v32_*.hpp`) — wer nach „V32-Aufräumpass" sucht, sucht §75.** → **Register-/Vokabelpflege** (ergänzt die
V-1…V-8-Kollision der Gegenlese-Karte).

**A60 · Vier Phasen-Zählkreise nebeneinander — massgeblich ist Reihe A.**
*Anker: :28499–28517.* Reihe A = `docs/sessions/20260803-FAHRPLAN-gesamtkette-wellen-phasen.md`, 7 Phasen;
Reihe B (Dossier 17) **stale bestätigt**, Reihe C (Dossier 16) **superseded**. **Phase 6 = „Nach Trigger
(Messung USER-GO)"**, vierfach belegt (`:3774`, `:3991`, `:4119`, `:7105`); Phase 5 (Trigger-Sequenz) ist
im Fahrplan selbst als **AUTONOM** markiert; die Grenze liegt bei `E.0 KERN-Mess-Schema`.
**„Bauen ja, TRIGGERN ja — MESSEN nein."** → **Wellenplan** (Zählkreis-Autorität; der Stand selbst ist
überholt, s. (B9)).

**A61 · Suchfallen des Segments (Fallen-Register).**
*Anker: :27541–27544, :28169–28175, :28390–28399, :28557–28564.*
· **`grep 'ESET'` = 26 Treffer / `grep -w 'ESET'` = 0** (alle in *UMGESETZT/GESETZ/WERTESET/RESET*) —
*„ein Zähler ohne Wortgrenze hätte #33 als erledigt gemeldet."*
· **cppcheck meldet nur den ERSTEN `preprocessorErrorDirective` JE DATEI** ⇒ eine halbe Heilung sieht wie
eine ganze aus, und eine Änderung in Datei A macht einen Befund in Datei B sichtbar ⇒ **VOLLER Scope,
kein Diff-Scope**; `// cppcheck-suppress` gilt für die **unmittelbar folgende** Zeile.
· **Köder, die NICHT beissen:** `#if 1` (für cppcheck eindeutig, keine *bedingte* Direktive) und
`#if defined(NIE_DEFINIERT)` (cppcheck probiert solche Konfigurationen gar nicht durch) —
**Reihenfolge: Köder gegen das WERKZEUG → erst dann gegen die WACHE.**
· **Ein `git describe`-Suffix ist KEINE Datumsangabe** (`pre-delegation-sweep-20260603-…` an einem
Commit von *heute*) — wer das Alter wissen will, fragt `git log -1 --format=%ad`.
· **Ein stale Klon liefert eine überholte Fassung** — erst die Messung **am Ref** gibt den heutigen Stand.
→ **Fallen-Register / ARBEITSWEISE.**

**A62 · Werkzeug-Ist: cppcheck 2.21.0 liegt lokal und trägt EXAKT die CI-Version.**
*Anker: :28181–28185, :28362–28381.* `/home/comdare/tools/cppcheck-2.21.0/bin/cppcheck`; der CI-Aufruf
steht in `ci-templates/base-pipeline.yml:337`. Die Wache hatte es als *„lokal nicht vorhanden (MinIO-
Cache-Artefakt)"* geführt und dadurch an EINEM Tag zwei rote Pipelines durchgelassen — *„eine Wache, die
ein vorhandenes Werkzeug für fehlend erklärt, ist schlimmer als gar keine: sie erzeugt die Gewissheit,
geprüft zu haben."* Gebaute Regeln: Pfade aus der `.gitlab-ci.yml` statt aus einer Skript-Kopie; fehlt das
Werkzeug, wird gesagt **WO** gesucht wurde und das Gate gilt als **OFFEN**, nicht grün; POSIX `#!/bin/sh`
+ `set -eu`, keine Process Substitution, kein `while read` hinter einer Pipe, mit `dash -n` gegengeprüft.
→ **ARBEITSWEISE / Wachen-Register.**

**A63 · Diff-Hygiene: die Vendor-Ausnahme läuft über den PROVENANCE-Marker, nicht über `ext/`.**
*Anker: :27495–27506.* Die Wache versprach *„nur SELBST VERFASSTEN Code"* zu prüfen, implementiert war das
allein über die **Dateiendung**; 20 Treffer, **alle im Fremdcode** — *„sie hätte den Autor gezwungen,
FREMDEN Quelltext umzuschreiben"*, was die Vendoring-Doktrin auf der Stufe *faithful* verbietet. Geheilt
über `COMDARE-VENDOR-PROVENANCE.md`, **keine pauschale `ext/`-Ausnahme** (die hätte comdare-eigene Dateien
dort blind gestellt), und **nicht still**: die übersprungenen Bäume stehen namentlich im Verdikt.
→ **Wachen-Register** (ergänzt den Diff-Hygiene-Posten der Gegenlese-Karte).

**A64 · E-E-Zyklus: die Wurzelursache ist eine VERZEICHNIS-Kante vor `add_subdirectory(tools)`.**
*Anker: :29776–29840.* `CMakeLists.txt:637 link_libraries(comdare::vendor_mimalloc)` ist eine
Verzeichnis-Kante, `add_subdirectory(tools)` steht in `:708` — **der Codegen erbt sie**, obwohl
`tools/overlay_source_hash_gen/CMakeLists.txt:19` nur `Boost::mp11` nennt. Geheilt an der **Wurzel**
(Codegen erbt die Kante nicht mehr), **nicht** per Ausnahme; `cmake/overlay_source_hash.cmake:105-118` ist
eine **Wache** mit `FATAL_ERROR`. Beleg: **656 Kanten / 326 eindeutige Ziele vorher wie nachher**, Diff
**rein additiv** (116 Einfügungen, 0 Löschungen); zwei Köder (direkt + transitiv über eine INTERFACE-
Zwischenstufe) beissen beide in der Configure-Phase. Trifft auch den ce-Standalone-Weg
(`-DCOMDARE_BUILD_PERMUTATIONS=ON`). → **Fallen-Register / Bau-Doktrin.**

**A65 · Klasse 9: eine SHA im Auftrag ist eine Momentaufnahme.**
*Anker: :27468–27479.* Der Lead schrieb in **jeden** Bau-Auftrag *„Basis `origin/development` =
`5060489e`"*; der Agent fuhr seine Wachen gegen diese Zahl, **weil sie im Auftragstext stand**, nicht weil
er `git merge-base` gerechnet hätte. **Regel: Basis BENENNEN, nicht beziffern — und ausdrücklich
verlangen, die Abzweigung selbst zu rechnen. „Eine Zahl, die der Lead vorgab und zurückbekommt, ist ein
Echo, keine Bestätigung."** → **ARBEITSWEISE.**

**A66 · Owner-KERN „EIN DEFEKT WIRD BEHOBEN, EGAL WIE GROSS" — mit der präzisen Abbruch-Grenze.**
*Anker: :29851–29882.* Owner: *„die Sauberkeit und Gründlichkeit steht im Zentrum der Implementierung,
wenn es einen Defekt gibt, egal wie gross, muss er behoben werden."* Die Unterscheidung: **Defekt →
bauen, unabhängig vom Umfang** (wird es gross: in granulare Pakete teilen und den *Plan* melden — aber
bauen) · **Umbau ohne Defekt → Rücksprache**. **„Zu gross" ist kein Grund mehr anzuhalten — „die Doktrin
bricht" ist einer. Wer beim Heilen feststellt, dass eine Hausregel im Weg steht, legt den Architektur-
Entscheid vor, nicht die Aufwandsschätzung."** Bau-Aufträge tragen **keine** „melden statt bauen"-Klausel
mehr. → **ARBEITSWEISE** (die Abbruch-Grenze ist die Präzisierung, die in der Memory-Fassung fehlt).

**A67 · Owner-Lehre: eine wiederholte Aussage ist quittiert, aber nicht eingebaut.**
*Anker: :29917–29923.* Der Owner musste dieselbe Aussage **siebenmal** schreiben; jedes Mal quittiert,
ohne sie zum **Gegenstand** der Analyse zu machen — und dann eine Stunde lang das falsche Format
untersucht. **Regel: nicht erneut quittieren, sondern prüfen, wo der eigene Arbeitsgegenstand von ihr
abweicht.** → **ARBEITSWEISE.**

**A68 · Owner: die LGPL-Frage ist erledigt — Habich-Freigabe, „WIRD VERWENDET OHNE SPERREN".**
*Anker: :28991–28997.* Owner: *„wir ignorieren die Lizenz, weil Prof. Habich mir diese Arbeiten zur
Weiterverwendung freigegeben hat."* **Task #42 geschlossen** für A03. Die Thesis nennt seit `798e946` die
korrekte Lizenz — das bleibt richtig, unabhängig von der Nutzungsfreigabe. **NICHT mit abgedeckt:** der
GPL-3-`wh.c`-Schalter und die Betreuer-Namen in den Prüfungsunterlagen (Release-Checkliste der Gegenlese-
Karte, Korb D-12) — die Freigabe betrifft *Habichs Arbeiten*, nicht jeden Fremdcode. → **Release-
Checkliste / GOAL v8.**

**A69 · A03/LGPL ist dreifach blockiert — der Beleg, damit ihn niemand neu erheben muss.**
*Anker: :28612–28638, :28688–28700.* (1) `COMDARE_HAVE_MICHAEL_LF` hat **keinen Setzer** (repo-weit genau
ein Treffer: `CMakeLists.txt:843`, die `if()`-ABFRAGE) ⇒ `axis_06_allocator_michael_lf.hpp:36` ist
compile-time false; (2) `michael.c` wird **nirgends** als CMake-Source geführt (`git grep 'michael\.c'`
= 0, **mit Gegenprobe** `malloc\.c` = Treffer); (3) der Include zeigt auf `michael_lf.h`, die vendorierte
Datei heisst **`michael.h`**. Das Target **wird** gelinkt (`profile_facade/CMakeLists.txt:72`), ist bei
`OFF` aber **leer**. **Restrisiko: ein stale Cache-Eintrag** — `CACHE ... FORCE` überschreibt bei jedem
Configure, aber ein einmal auf `ON` gesetzter Eintrag bleibt stehen, wenn der Vendor später verschwindet
(*„hinterliess ein stale COMDARE_HAVE_MIMALLOC=ON"*). **Gegenmassnahme ist keine CMake-Änderung, sondern
die geltende Regel: für eine Messung ein FRISCHES Build-Verzeichnis** („Alt-Build-Dir = Gift", G6/J-0).
→ **Bleib-Notiz / Fallen-Register.**

**A70 · `ext/` gegen `adapters/`: die `CACHE BOOL "" FORCE`-Kollision ist ABSICHT, kein Bug.**
*Anker: :28646–28687.* `add_subdirectory(ext)` steht auf `:615`, `add_subdirectory(adapters)` auf `:679`
(**umgekehrt zur ersten Diagnose**); `option()` respektiert einen bestehenden Cache-Eintrag ⇒ der
`ext`-Wert gewinnt. **`CMakeLists.txt:641-654` erklärt das Muster selbst:** snmalloc/mimalloc tragen
**zwingende Compile-Belange** (`SNMALLOC_HEADER_ONLY_LIBRARY=1`, `-mcx16` auf x86_64), die **jedes**
Target erreichen müssen, das die Header transitiv über `topic_allocator` zieht. Bei `OFF` ist der Adapter
eine **leere INTERFACE-Library**, `link_libraries` darauf ist inert. **Keine Mess-Verfälschung.**
→ **Bleib-Notiz** (verhindert eine Fehl-Meldung als Mess-Integritätsproblem).

**A71 · `golden_fullpilot_131072_binary_ids.txt` existiert bewusst NICHT im Repo.**
*Anker: :28653–28658.* `source_catalog.hpp:178`: *„die Datei kommt NICHT ins git — Repo-Bloat"*, 62 MB.
Zwei Agenten widersprachen sich hier, beide hatten je die Hälfte (Referenz vs. fehlende Datei).
→ **Bleib-Notiz / Fallen-Register.**

**A72 · Infra-Ist prod1/NAS, selbst gemessen und reboot-fest verdrahtet.**
*Anker: :28217–28238, :28568–28608, :28129–28145.* **prod1 hat DREI Beine:** `br0` 10.0.10.211 ·
`br0.20` 10.0.20.211 · `br0.60` 10.0.60.211 — **kein Cross-VLAN-Problem**; 10.0.10.243 ist die **CARP-VIP**,
nicht das Gerät. Mounts (Lesen + Schreiben + Rücklesen je verifiziert, Bissprobe mit gelöstem Mount):
`/mnt/comdare-buildsystem` = `10.0.20.241:/nfs/Comdare-Buildsystem` (Volume_2, `/mnt/HD/HD_b2`) **20T /
15T frei, Export auf `*` (ALLE Netze)** · `/mnt/backup1-nfs` (Cluster_NFS, `/mnt/HD/HD_a2`, Export
`10.0.20.0/24`) 19T / **3,6T frei** · `/mnt/backup2-nfs` 7,3T / **6,5T frei**.
**Reboot-fest über `/etc/fstab` mit `noauto,x-systemd.automount,idle-timeout=600` und
`soft,timeo=100,retrans=2` — ausdrücklich NICHT hart, weil ein hängendes NFS den Boot blockiert und
prod1 den GitLab-Runner trägt.** Sicherung: `/etc/fstab.bak-20260807-comdare-nas`.
`/mnt/HD/HD_a2/sort` (~11 T) ist ein **privates Datenarchiv des Owners** — nicht verfügbar, nicht
anzufassen. → **Infra-Handout Teil B / Bleib-Notiz.**

**A73 · Owner-Entscheid: der weite NFS-Export ist GEWOLLT — mit offenem Explore-Auftrag.**
*Anker: :28979–28989.* Owner: *„Ja wir lassen ihn offen, es wollen ja auch alle Maschinen die Lagerhaltung
bedienen (explore bitte). **Sync per file war geplant.** Die **V60 runner SOLLEN ja direkt mounten.** Das
war der Plan."* Der `measure-drop`-Filterpod war die Antwort auf eine **andere** Frage (Cluster_NFS).
**Offener Explore-Auftrag, wörtlich vom Owner:** die Planung „alle Maschinen bedienen die Lagerhaltung" +
„Sync per file" heben und **gegen den Ist-Stand des Bestandslogs halten**. → **Task-Karte (Explore) +
Infra-Handout.**

**A74 · Ein Vault-Wert gilt als kompromittiert und steht in keiner Rotationsliste des Kopfes.**
*Anker: :28270–28280.* Beim maskierten `sed`-Lauf geriet **`samba-comdare-socks-pw` im Klartext ins
Session-Transkript** (der Vault ist eine Markdown-TABELLE, Werte stehen in Spalten). Entlastung, aber
keine Entschuldigung: das Konto existiert in Live-AD nicht (*„2026-06-01 verifiziert"*). **„Der Wert gilt
trotzdem ab jetzt als kompromittiert und gehört in die Rotationsliste."** Zusatzregel: über die **LÄNGE**
selektieren (`len:40`), nie über die Position — die positionsbasierte Regex griff **6 Zeichen statt 40**.
→ **Owner-Posten / Infra-Handout** (der Kopf führt nur V8 = GitHub-PAT).

**A75 · `liburing` steht in KEINER der beiden Lizenzdateien.**
*Anker: :27509–27510.* Der Snapshot liegt seit dem **23.07.** im Baum. Gehörte zu Task #42 — **#42 wurde
über die LGPL-Freigabe geschlossen (A68), dieser Teilposten aber nicht berührt.** → **Release-Checkliste.**

**A76 · A12/E-14 „NAS-Creds": das Skript ist deprecatet, die METHODE — nicht das ZIEL.**
*Anker: :27952–27982.* `scripts/copy_results_to_nas.sh` ist deprecatet als **rohe UNC/SMB-Kopie**;
spätere Dokumente referenzieren PR4100 weiterhin aktiv über den **CI-WRITE-Token-Weg**. **A12/E-14 ist
ohne Erledigungsbeleg, kein Vor-Trigger-Blocker, aber vor der Abgabe zu klären.** Weiter: Runner dürfen
`Cluster_NFS` nie lesen — nur schreiben über den Filterpod
(`PUT https://measure-drop.comdare.local/<ts>/<datei>`, Backend `nfsvers=3`); der **Buildsystem**-Export
ist davon nicht betroffen (A73). → **Release-Checkliste / Infra-Handout.**

**A77 · PMC-Ist: VIER generische Counter, IPC/CPI unverdrahtet.**
*Anker: :28454–28456, :28449.* `linux_perf_pmc_source.hpp:11-13` wörtlich: *„TATSÄCHLICH GEÖFFNET werden
VIER generische Counter"* (die Thesis sagte drei, korrigiert). `branch_misses` ist real erhoben,
**IPC/CPI bleibt unverdrahtet** — diese Aussage der Thesis ist weiter wahr. → **#53 PMC-Bau.**

**A78 · Owner-Entscheid: die LaTeX-Anlage kommt IN die Abgabe — und die Textbausteine ebenfalls.**
*Anker: :28876–28877.* *„In die Abgabe, das ist das Ziel eine Diplomarbeit mit Messwerten und Auswertung
generieren zu können, indem man nur seine Wünsche in die XML schreibt und die Auswertung kommt nach ein
paar Tagen von allein."* Und zu Habich H3: *„Jetzt mit in die Abgabe, die Entscheidung steht neu. Die
Bausteine dürfen jetzt nach sorgfältiger Planung auch in die Evaluation und Auswertung, sowie in den
Bereich der Implementierung, weil sich je Konfiguration der XML ja auch die compiled Realität ändert.
**Das ist abgesprochen.**"* (mit dem Betreuer) → **GOAL v8 + Thesis.** **Hebt eine frühere Betreuer-
Auflage auf — im Kopf nirgends verbucht.**

**A79 · Die wissenschaftliche Frage der Arbeit in einem Satz.**
*Anker: :28824–28834.* Owner: *„sequentiell JEDE Achse einzeln durch-permutieren, ob nicht die Algorithmen
der Anderen Paper in dieser Achse besser gewesen wären."* Also nicht *„welche Komposition ist die beste"*,
sondern **„wäre Papers X Algorithmus für Achse A besser gewesen als der von Paper Y, bei sonst gleicher
Konfiguration?"** — je Achse einzeln. *„Jede Haupt-Achse und Unter-Achse ist daher im Experiment-Baum
vollständig repräsentiert und typisiert (explore)."* → **GOAL v8 / Thesis.**

**A80 · Der Experiment-B+-Baum IST die Vergleichs-Ordnung, nicht nur eine Speicherform.**
*Anker: :28795–28822.* Owner: *„bei dem alle prefetching Algorithmen und im Baum tiefer liegenden
Algorithmen dieselben sind, um den Achsen-Algorithmus isoliert als einzige Änderung in der Binary
querschneidend zu betrachten und über das diff den break even point zu isolieren."* ⇒ **zwei Binaries,
die sich nur in EINEM Knoten derselben Tiefe unterscheiden und denselben Teilbaum darunter tragen, sind
ein kontrolliertes Experiment mit genau einer unabhängigen Variablen.** *„Deshalb ist die Sortierung der
Achsen keine Kosmetik, sondern die Voraussetzung dafür, dass überhaupt isoliert gemessen werden kann"* —
und deshalb die Erst-Klammerung 19./20.07. und die drei kanonischen Achsen-Ordnungen (E-E).
→ **GOAL v8 / Designplan-TDD.**

**A81 · Das FLATTERN ist kein Fehler, sondern das Auslöse-Signal für den Hybriden.**
*Anker: :28945–28958.* Owner: *„für die Hybrid-Tier-Binary sind EXAKT DIESE flatternden Bereiche der
besten Tier-Binary in einem Bereich zu erkennen und die Synthetisierten Funktionen müssen anhand der
erkannten Eingangslast ihr Verhalten so anpassen, dass die beste Binary für diese Situation geladen und
durch den Hybriden orchestriert wird."* **Stufe 1 mittelt (kein Flattern), Stufe 2 sucht das Flattern
gezielt — keine Hysterese nötig, sondern eine Bereichs-Erkennung.** → **HY-Design-Register / #24.**
Der Kopf kennt den Hybriden, nicht sein Auslöse-Kriterium.

**A82 · Dynamik + Nachbau-Regel: fail-open mit lauter Meldung.**
*Anker: :28842–28848.* Owner: *„Wird eine Messung angefragt, die per Bau-Material nicht freigegeben ist,
dann wird sie nachträglich noch gebaut und es wird auf der CLI eine Warnung ausgegeben, aber dennoch
vorbehaltslos gebaut (nur ein Definitionsproblem)."* ⇒ **die XML trennt Bau-Material von Messungen; eine
Messung ohne passendes Bau-Material ist KEIN Fehler, sondern Warnung + Nachbau.**
→ **Designplan-TDD / S-13-XSD.** Ergänzt die HART/SOFT-Regel (KON28-02) um einen dritten Fall.

**A83 · Anker-Warnung für alle §55-Zitate.**
*Anker: :27549–27552.* Mess-Stand des Reconcile: super `c26f8a77` (**Ledger 9619 Zeilen**), ce `5788dc12`,
thesis `eaf7fe8`, prt-art `c6f07540`. **Alle Ledger-Zeilennummern im Reconcile beziehen sich auf den
9619-Zeilen-Stand — die Audit-Zeilen ab 7250 sind um bis zu 1896 Zeilen verschoben.** Heute steht die
Datei bei 30077. → **Register** (jeder §55-/§75-Anker ist vor Gebrauch neu zu messen).

---

## (B) ÜBERHOLT-OHNE-MARKER — Liste für den Marker-Nachzug

| # | Anker | Was dort steht | Überholt durch |
|---|---|---|---|
| B1 | **:27422–27429** | *„FALL 4 OFFEN GEHALTEN"* + `static_assert(flag_catalog_offene_entscheide() == 6)`, MMX-Familie mit `eltern_alternativ` und `entscheid_offen` | **A1/m64 (:28411–28427, 07.08. abend-30): Entscheide-Zähler 6 → 0**, die MMX-Familie hat eine eigene Basis. Die Passage trägt keinen Marker. |
| B2 | **:27448–27449** | `3dnowprefetch` als Skalar = *„SETZUNG DES AGENTEN"*, `entscheid_offen` | **N-3 schliesst `3dnowprefetch` separat** (:28427). Kein Marker. |
| B3 | **:28463–28497** (A2-Dossier) | Permutationszahlen 524.288 · **132** Paper-Repliken · 1.572.864 · 1.048.576 · Einschränkungsfaktor **3.972** · fünfter D-2-Kandidat 917.504 | **Owner-Rüge im SELBEN Segment (:28706): „Rechne diese bitte NIE mehr pauschal nach"** + **KON71 (dritte Rüge): Mess-Permutation DYNAMISCH >32, NUR S-19 rechnet.** Kein Marker an der Tabelle. Die Zahlen sind Eingangs-Hypothesen für #7, keine Nenner. |
| B4 | **:28606–28608** | *„Der D-2-Zahlenkonflikt (131.072 / 524.288 / 917.504 / 1.572.864 / 2.097.152) ist damit KEINE Platzfrage mehr"* — als offene Mengen-Frage geführt | dito **KON71 + S-19 (#7)**; die Platz-Aussage bleibt richtig, die **Kandidatenliste** ist überholt. |
| B5 | **:29142–29145** (xlsx Fassung 2) | Sheet-Namen *„deterministisch `S001..Snnn` (mixed-radix über die Unter-Achsen-Permutationen) mit Klartext-Legende im INFO-Sheet"* | **KON87 (V-A9-6): S001 ENTFÄLLT** + **KON88: sparse Namen**. Kein Marker. |
| B6 | **:29263–29268** | CSV-Variante *„**flach** einzelne sheets"* | **KON89-D3: CSV = FACTORY als verschachteltes Filesystem (Gesamt-Ordner → Ordner je Sheet → CSVs je Unter-Achsen-Fahrt).** Überholt ist nur die **Flachheit**; die Namens-Grammatik (Ebene anführend + parsebarer Zeitraum) bleibt lebend (A47). |
| B7 | **:29891** | Owner-Absolutum *„Und CSV wird NIE verwendet"* | **KON60-Vorlage-B4 (xlsx = STAMM / csv = KIND, dreiwertig)** + **KON89-D3 (CSV-Factory)**. Der Satz gilt als *Ausgabe-Default*, nicht als Existenzverbot — der Ledger listet die legitimen CSV-Orte selbst bei :29181, aber **am Absolutum steht kein Marker.** |
| B8 | **:28443, :28457–28459** | Thesis-Stand *„DE 204 / EN 194 Seiten"* (thesis `798e946`) | **KON77: PDF DE 202 / EN 192.** Kein Marker. *(Nebenbefund: KON63 nennt „PDF 204 S." — die Kopf-Zahlen 204 und 202/192 sind untereinander unabgeglichen, s. (C10).)* |
| B9 | **:28516–28517** | *„Phasen 1-3 gelandet, Phase 4 vollzogen. **Phase 5 hat faktisch NICHT begonnen** (Null Binaries gemessen)."* | **KON63: F1 GELIEFERT 14.08., Durchstich komplett, Messung 377503, PDF 204 S.** Kein Marker. Die **Zählkreis-Autorität** (Reihe A) bleibt lebend (A60). |
| B10 | **:27594–27595** | *„OWNER-ENTSCHEID: geänderte Konflikt-Auflösung ODER ein monotones Ordnungs-Feld"* als offene Alternative | **:28103–28116 (A3, drei Tage später) legt den Schnitt fest: EIN `last_update_utc` löst beides.** Die frühere Stelle trägt keinen Verweis auf die Auflösung. Owner-Wort steht weiter aus (A48). |
| B11 | **:27509–27510** | *„damit ist **A9-S2 offenbar erledigt**"* | **:29189 führt S2 als „halb"** (`lager_pfad_grammatik.hpp` existiert aus der A1-Welle, `blatt_dateiname()` da, Namens-Fassade fehlt). Kein Marker an der früheren Stelle. |
| B12 | **:27957–27963** | NAS-Befunde *„backup1 abgeschaltet"*, *„die 8 TB sind nirgends belegt"*, *„Runner dürfen `Cluster_NFS` NIE lesen"* als generelle Aussage | **:28240–28248** widerlegt Punkt 1+2 am Objekt, **:28568–28597** liefert das Buildsystem-Volume (15 T, Export `*`), **:28979–28987 (Owner)** stellt klar, dass die V60-Runner **direkt mounten SOLLEN**. Die Nie-Lesen-Regel gilt **nur für `Cluster_NFS`**, nicht generell — an der frühen Stelle steht das nicht. |
| B13 | **:27968–27975** | Verortungs-Brief 18.07.: Ebene C auf einer **neuen `prod-longhorn`-NFS**; *„sechs offene Entscheidungen blockieren die Aktivierung"*; Transport-Widerspruch POSIX-Mount vs. HTTPS-PUT | **KON66/KON67 (Cache-Landschaft, Ebene A GitLab-cache / B+C eigene ArtifactCache-Klasse; Lager = NAS-Wahrheit)** + das Buildsystem-Volume + der Owner-Entscheid A73. Kein Marker. |
| B14 | **:27979–27980** | *„`scripts/copy_results_to_nas.sh` ist deprecatet"* — Aussage ohne Zielangabe | präzisiert **in derselben Zeile**: deprecatet ist die **METHODE** (rohe UNC/SMB-Kopie), **nicht das ZIEL**. Wer nur den ersten Halbsatz zitiert, buchte PR4100 fälschlich aus. Marker: „METHODE, nicht ZIEL" gehört an jede Zitierstelle. |
| B15 | **:29011** | *„Der Faden ist am 20.07. gerissen — der Ledger buchte den Posten als **post-v3** (`:3185`), obwohl das GO stand."* | Owner-GO 08.08. (*„Ja unter sorgfältiger Design Planung bitte bauen"*, :28875). **Die `post-v3`-Buchung bei `:3185` trägt bis heute keinen Marker** und würde den Paper-XML-Auftrag erneut ausbuchen. |
| B16 | **:27512–27552** | sämtliche §55-Zeilenanker (`:7885`, `:7016`, `:8339`, `:7878`, `:7100`, `:7105`, `:3290`, `:3299`, `:3413`, `:2441`, `:2425`, `:3066`, `:3185`, `:3599`, `:3601`) | **Datei-Stand-Drift**: der Reconcile misst gegen 9619 Zeilen, die Datei hat 30077. Der Ledger warnt nur *innerhalb* des Reconcile-Abschnitts. **Marker an jede Anker-Gruppe.** |
| B17 | **:29053–29060** | Der eigene F-3-Alarm (*„`all_axes_golden.profile.xml` nennt die Trennung der Mess-Combos die F-3-Regression und steht gegen den Owner-KERN"*) | **im selben Abschnitt zurückgenommen**: der Kommentar sagt vollständig *„getrennt/Teilmengen bleibt XML-Recht"*. Der Alarm steht bei **:29016–29019** aber weiter unmarkiert als *„echter Konflikt, kein Versäumnis"*. **Der Marker fehlt an der Alarm-Stelle, nicht an der Rücknahme.** |
| B18 | **:29962–29969** | die *„zwei Lesarten"* zum Lager-Baum (ob D-12 ein Defekt ist) | **:29975–29992 (Owner-Nachtrag): „die Realms sind per Filesystem getrennt, der Strategy-Storage-Tree ist im code derselbe"** ⇒ Lesart 2 ausdrücklich **gestrichen**; und **:30000–30011** beantwortet die Rest-Frage „synchron" als **NICHT-Lücke** (lazy ist das Soll). Der Ledger markiert das selbst — hier nur zur Sicherheit gelistet, damit die Lesart-2-Stelle nicht isoliert zitiert wird. |

---

## (C) WIDERSPRÜCHE zum Massstab ohne erkennbare Auflösung

**C1 · `checkpoint_measure` — die Gegenlese-Karte (W16) datiert die Namensvergabe SECHS TAGE zu spät.**
- *Gegenlese-Karte W16:* „**`checkpoint_measure`-Name:** „Erfindung, endgültig belegt" (09.08., dreifach)
  vs. KON60(iii) „Wallclock = CEB-seitiger checkpoint-measure-Wrapper". **Auflösung:** … der Owner hat den
  Namen **am 14.08. NEU vergeben** (aus Behauptung wurde Entwurf)."
- *Ledger :29537 (**08.08.**), Owner verbatim:* „*Die Funktion für `checkpoint_measure(...,IN bzw. OUT)`
  ist uniform.*" — dazu :29525–29537 (C-1/C-2), :29611–29649 (C-7/C-8), :29720–29772 (C-14/C-15).
- **Folge:** der 09.08.-Befund *„Erfindung, endgültig belegt (dreifach)"* ist **an seinem eigenen Datum
  falsch** — der Name war einen Tag vorher ein Owner-Wort mit ausgearbeiteter Semantik (IN/OUT als
  CT-Tag, Ebene per CMake-Flag, eigener Stacktrace, virtuelle Thread-Slots). **Empfehlung:** den
  „Erfindung"-Befund austragen, `checkpoint_measure` an **08.08./C-1..C-17** verankern, KON60(iii) als
  **Bestätigung** lesen, nicht als Neuvergabe. Kein Owner nötig.

**C2 · CSV-Ablage: flach (Owner 08.08.) gegen verschachtelt (KON89-D3).**
- *Ledger :29265, Owner:* „*Ich wünsche mir in der CSV Variante tatsächlich **flach** einzelne sheets,
  welche die Zeiträume parse-bar im Namen tragen und anführend im Namen ihre Ebene für das Messblatt
  benennen.*"
- *Kopf KON89-D3:* „CSV = FACTORY als **verschachteltes Filesystem** (Gesamt-Ordner → Ordner je Sheet →
  CSVs je Unter-Achsen-Fahrt)."
- **Empfehlung:** jüngeres Owner-Wort gewinnt für die **Struktur** (verschachtelt); die **Namens-
  Grammatik** (Ebene anführend, Zeitraum parsebar) hat kein jüngeres Gegenwort und ist in KON89 zu
  ergänzen — sonst geht der einzige Sortier-/Filterschlüssel der Blätter verloren. Kein Owner nötig.

**C3 · „CSV wird NIE verwendet" gegen den CSV-Wunsch desselben Tages und gegen csv=KIND.**
- *Ledger :29891, Owner:* „*Und CSV wird NIE verwendet, ich habe dir das jetzt in der letzten Stunde
  schon 7 Mal geschrieben.*"
- *Ledger :29265 (derselbe Tag), Owner:* „*Ich wünsche mir in der CSV Variante …*" · *Kopf KON60-B4:*
  „xlsx = STAMM / csv = KIND, dreiwertig" · *KON89-D3:* „CSV = FACTORY".
- **Empfehlung:** „nie" bezieht sich auf CSV als **Ausgabe-Default/Standardformat**; als KIND, Fallback,
  Eingabeformat der Heuristik-Strecke und Test-Fixture bleibt CSV (Ledger :29181 listet die Orte).
  Marker **am Absolutum**, nicht nur im Index. Kein Owner nötig.

**C4 · Mess-Ebenen: die „Fünf" der Gegenlese-Karte (W3) und die „Fünf" bei :28858 sind NICHT dasselbe Objekt.**
- *Gegenlese-Karte W3:* „…die **Fünf-Formel war bereits als gegenstandslos markiert** — Marker an alle
  drei Zählstellen."
- *Ledger :28850–28869, Owner verbatim:* „*der Planer gibt Messwerte für die CLI aus und fragt die CEB ab,
  die CEB hat ein Prüfdock, welches wallclock time für gesamt-Zeit eines Last-Ablaufes und einzelne
  Tier-Binary-Interface Funktions-Aufrufe durchmisst (daher 2 Ebenen) und die Tier-Binary enthält
  potentiell Macro- und Micro-Benchmarks … **Also 5.**"* — und der Ledger löst selbst auf (:28866):
  „*die **Stufen** sagen, WIE fein gemessen wird, die **Ebenen** sagen, WO der Messpunkt sitzt (Planer /
  CEB-Prüfdock / Tier-Binary)*."
- **Empfehlung:** der W3-„gegenstandslos"-Marker darf **NICHT** an :28858 gesetzt werden. Dort stehen
  **fünf ORTE**; die 3/4-Debatte betrifft **Stufen**. Marker: „ORT-Tabelle, nicht Stufen-Zählung".
  Kein Owner nötig — aber der Bau muss wissen, gegen welche der beiden Zählungen die CMake-Ebenen-Flags
  (A5/C-13) gesetzt werden.

**C5 · Wo die compare-Ebene sitzt: zwei Ortsangaben desselben Tages.**
- *Ledger :28861 (Fünf-Tabelle):* Ebene 2 „Prüfdock: Gesamt-Last — **CEB**" · Ebene 3 „Prüfdock: je
  Interface-Aufruf".
- *Ledger :29388–29392 (N-5, Owner):* „*die compare Messlayer liegt in der CEB **noch vor dem Prüfdock***".
- **Empfehlung:** N-5 ist später am selben Tag und präziser; die Fünf-Tabelle bei :28861 ist auf
  „CEB, **vor** dem Prüfdock" nachzuziehen. Kein Owner nötig.

**C6 · Sechs CEBs gefordert, zwei herstellbar — und kein Kopf-Posten trägt die Heilung.**
- *Owner :28772:* „*Es gibt also 3 Stufen und 6 CEBS (nicht 5 das war mein Fehler).*"
- *Ledger :29012, :29074:* „**VON DEN 6 CEBs SIND HEUTE MAXIMAL 2 HERSTELLBAR**"; `wallclock` ist gar
  nicht ausbaubar (G1 wird von jedem Tooling gezogen); G2/G3 teilen ein Gate.
- **Kein Widerspruch der Doktrin, aber eine ungedeckte Fähigkeitslücke:** der Bau-Auftrag („G3 aus dem
  STATISTICS-Gate lösen", A14) trägt in keinem der beiden Massstab-Dokumente eine Nummer, obwohl er die
  **Vorbedingung der Messfehler-Elimination** und damit von `--check-size` (A24) ist.
  **Empfehlung:** eigener Task-Posten, gebündelt mit C-13(3) („Ebenen-Flags und CEB-Gates = EIN
  Mechanismus"). Kein Owner nötig.

**C7 · E-B bricht den golden-CRC — der Kopf führt aber EIN geschlossenes golden-Fenster.**
- *Kopf KON70/KON78:* „EIN golden-Fenster (B2 + #16 + organ_axes(F5) + #72-queuing)".
- *Ledger :27915 (Owner):* „*Wir brechen golden-CRC!*" ⇒ E-B = Variante (i), der Emitter schreibt den
  Namen in den generierten Quelltext; :27884 belegt, dass der CRC am 26.07. schon einmal über ein
  dokumentiertes Verfahren gebrochen wurde (`gen_golden_fullpilot --crc64`, zwei Stellen nachtragen,
  Bissprobe).
- **Empfehlung:** entweder E-B ausdrücklich **in** das eine Fenster aufnehmen (dann Bissprobe + zwei
  Nachtrags-Stellen einplanen) oder als vollzogen/ausgebucht belegen. **Ohne Zuordnung droht ein zweiter
  golden-Bruch nach dem F2-Freeze** — genau das, was das Ein-Fenster-Prinzip verhindern soll.

**C8 · E-B: die Owner-Begründung ist am Code nicht auffindbar — ausdrücklich als SETZUNG gebucht.**
- *Owner :27851:* „*der Vorschlag ist irrsinnig und bereits präzise über die Lagerhaltung geplant.*"
- *Ledger :27856–27871 (vier Code-Belege):* Identität läuft über `key_sha512` aus dem **Sidecar**
  (`bestandslog_index.hpp:6,42`, `fingerprint_key_source.hpp`, `lager_pfad_grammatik.hpp:15`,
  Ledger `:3413`); §43 (`:2441`) fordert *„als string_view … einkompiliert"* = Variante **(ii)**,
  **eine Symbolnamen-Forderung enthält §43 nicht** (:28036–28041).
- **Empfehlung:** kein neuer Owner-Entscheid — der Bau folgt der Setzung, **aber der Kommentar an der
  Stelle muss beides sagen** (§43 belegt die Einkompilierung, die Symbolnamen-Form ist Owner-Setzung),
  sonst entsteht „eine Wache, die später niemand begründen kann" (:27895).

**C9 · Kürzel `F5` trägt mindestens DREI Bedeutungen, davon zwei im Kopf selbst.**
- *Ledger :27580–27582:* „**ZWEI F5-NAMENSRÄUME.** Das ETA-F5 steht nicht im Aufräumpass-Plan (dort ist F5
  das golden-Update-Fenster) … Zehnte Kürzel-Kollision."
- *Kopf KON73:* „**F5** DREI Homes (mess/system/ORGAN_AXES, 640 Records golden-brechend)" · *Kopf KON89:*
  „**F5** = MIRRORING-GO (nach V8)".
- **Empfehlung:** Register-Eintrag; jedes F5-Zitat muss den **Gegenstand** nennen (ETA-Paket · golden-
  Update-Fenster · DREI Homes · Mirroring). Kein Owner nötig. Gleiches Muster wie die V-1…V-8/V1-V10-
  Kollision der Gegenlese-Karte.

**C10 · Thesis-Seitenzahlen im Kopf untereinander unabgeglichen.**
- *Kopf KON63:* „PDF **204** S." · *Kopf KON77:* „PDF **DE 202 / EN 192**" · *Ledger :28443 (07.08.):*
  „DE **204** / EN **194**".
- **Empfehlung:** eine Zahl je Datum am Objekt neu erheben (`latexmk`-Lauf), die anderen mit Datum
  markieren. Kein Owner nötig — aber die 204 ist als F1-Beleg zitiert und sollte belastbar sein.

**C11 · „alles in C++ in den binaries abgebildet" (Owner-Prämisse) gegen die Unentbehrlichkeit der Sidecars.**
- *Owner :27790:* „*überprüfe die Sinnhaftigkeit von Sidecars, wenn doch eigentlich alles in C++ in den
  binaries abgebildet sein muss*."
- *Ledger :27823–27832:* die Prämisse trifft technisch für **drei von vier** zu; `.fingerprint` und
  `.version` beantworten Fragen, „*die sich nicht auf ‚was ist der Inhalt dieser Binary' reduzieren
  lassen*". **Und ehrlich vermerkt: die vom Owner genannte Plan-Stelle wurde NICHT wörtlich gefunden**
  (gesucht über vier Muster; nächstliegend `build_type_stamp.hpp:31`).
- **Empfehlung:** Explore statt Owner — der byte-genaue Formatvergleich `.algos` gegen die Organ-Zeile
  steht ebenfalls offen (:27831). Erst wenn er zeigt, dass `.algos` byte-äquivalent ist, ist eine
  Streichung von `.algos`/`.variant` überhaupt entscheidbar. **`.fingerprint`/`.version` bleiben in jedem
  Fall** (A37).

---

## (D) ARCHITEKTUR-KERNE DES SEGMENTS

1. **Der Messfühler ist ein Verbraucher.** Owner: *„Das ist wie in der Elektrotechnik, weil der Messfühler
   ein Verbraucher ist, wir aber den Messfehler erkennen und dann für das reale Ergebnis eliminieren
   müssen, damit break even stimmt."* (:28918) Deshalb sind die Messebenen **compile-time ausbaubar** —
   nicht als Komfort, sondern weil die Differenz „mit Fühler" minus „ohne Fühler" **der Messfehler selbst
   ist**. Daraus: **3 Stufen, 3! = 6 CEBs, vom Planer kompiliert.**
2. **Drei Stufen ≠ fünf Ebenen.** Die **Stufen** (Micro/Macro/combined) sagen, WIE fein gemessen wird; die
   **Ebenen** sagen, WO der Messpunkt sitzt (Planer-CLI / CEB-Prüfdock ×2 / Tier-Binary ×2). Zwei Achsen
   derselben Sache, nie zu vermengen. (:28866)
3. **Der Mess-Baum ist der Aufruf-Stack.** Owner: *„Die Mess-Ebenen entsprechen damit gleichzeitig dem
   Stack-Aufrufmuster zwischen 3 Layern der Architektur."* (:29304) compare = Lastprofil · Macro =
   Gattung+Genus-Interface · Micro = Achsen-Interface; die Spalte **Aufrufer** ist die Stack-Kante.
4. **Der Aufrufer ist ein Prozess UND einer seiner Threads — und der Thread ist ein Visitor.** Owner:
   *„Ein thread ist also systemisch ein visitor in allen Mess-Ebenen unter einem Prozess und kommt immer
   aus einer höhergelegenen Mess-Stufe in eine tiefer."* (:29346) **IN ohne OUT ist eine Regression.**
5. **Ein Checkpoint, zwei Tags, null Laufzeit-Verzweigung.** Owner: *„Die Funktion für
   `checkpoint_measure(...,IN bzw. OUT)` ist uniform."* (:29537) `IN`/`OUT` und die Mess-Ebene sind
   **compile-time**; der Aufrufer wird aus einem **eigenen** Stacktrace **beim Auslesen** rekonstruiert:
   *„Wir verwenden also ein eigenes C++ stacktrace und nicht das standard stacktrace."* (:29632)
6. **Sparsamkeit ist Randbedingung, nicht Stil.** Owner: *„Das Verfahren muss besonders sparsam sein, weil
   wir Latenzen nicht in der Messung dulden können."* (:29536) ⇒ statischer Deskriptor-Verweis statt
   ausgeschriebener Achsen-Kette · vorab allozierte Puffer · kein I/O · **virtuelle Thread-Slots, ein
   `int` genügt** (:29738) · Überlauf = Befund, nie stiller Verlust.
7. **Record-and-Replay ist der Mess-Vertrag.** Owner: *„Jede Achse muss … in einem original festgestellten
   RAM Zustandes einer Gattung auf den exakt festgehaltenen replay Achsen-Aufruf mit warmem Cache einzeln
   durchgemessen werden."* (:29080) Statt gleichzeitig zu messen (Sonden stören sich) wird
   `(Aufruf, Zeitpunkt, Zustand)` aufgezeichnet und **einzeln nachgespielt**.
8. **Der Experiment-B+-Baum IST die Vergleichs-Ordnung.** Owner: *„um den Achsen-Algorithmus isoliert als
   einzige Änderung in der Binary querschneidend zu betrachten und über das diff den break even point zu
   isolieren."* (:28810) Geschwister-Vergleich bei identischem Nachfolge-Pfad ⇒ **die Achsen-Sortierung
   ist die Voraussetzung dafür, dass überhaupt isoliert gemessen werden kann.**
9. **Die wissenschaftliche Frage in einem Satz:** nicht „welche Komposition ist die beste", sondern
   *„sequentiell JEDE Achse einzeln durch-permutieren, ob nicht die Algorithmen der Anderen Paper in
   dieser Achse besser gewesen wären"* (:28829) — je Achse einzeln, über die Paper-XMLs.
10. **Ein Paper ist ein Experiment-XML, keine Kandidatenliste.** Owner: *„Es gibt keine Kandidaten,
    sondern nur das Ermitteln der XML Einstellung um ein Paper-Experiment zu reproduzieren und dann gibt
    es den Nachweis des PRT-ART Prüflings und dessen Einsetzung in die Achsen."* (:28741)
11. **Die Menge folgt der FREIGABE, nicht dem Achsenraum** — und **Bau-Menge ≠ Mess-Menge** (:28727).
    Gerechnet wird auf der CEB, nicht im Kopf: *„Die Zahl gehört nicht in meinen Kopf, sondern in ein
    Programm."* (:28712)
12. **Break-Even ist eine Kurve über die ZEIT, nicht über die Last** — kubischer **B-Spline (B=3)**, als
    String serialisierbar und wieder parsbar, erster Messwert = Basis 0 (:28782); dreimal berechnet
    (Micro/Macro/combined), je Baum-node-Tiefe (:28941).
13. **Das Flattern ist das Signal für den Hybriden**, nicht ein Stabilitätsproblem: *„für die
    Hybrid-Tier-Binary sind EXAKT DIESE flatternden Bereiche … zu erkennen"* (:28949). Stufe 1 mittelt,
    Stufe 2 sucht das Flattern gezielt.
14. **Release ist Rekonstruktion, nicht Bau** — *„Anfrage an eine dokumentierte compare Bibliothek der
    Messwerte … zu rekonstruieren und auszuliefern … gegen die Prüfdock google Tests als Verifikation"*
    (:29096) ⇒ **Binaries müssen nicht aufbewahrt werden.**
15. **Ein Storage-Tree, zwei Wurzeln, zwei Durchläufe.** Owner: *„der Strategy-Storage-Tree ist im code
    derselbe … Eine wurzel binaries, eine wurzel measurements"* (:29978) — **lazy** angelegt, erst bauen,
    dann darüber messen; `kompiliert`/`gemessen` zählen **zwei Durchläufe**, nicht zwei Sichten.
16. **SKIP ist die Grundoperation, Überschreiben existiert nicht.** Gleiche Binary-Identität ⇒ skip; neue
    Version ⇒ neuer Datensatz **neben** dem alten (:29893).
17. **Die Schichtung ist strikt und das Fenster ist jetzt.** Owner: *„unter Gattung kommt Genus und
    darunter die Implementierungen … Alles andere ist unsauber. Das Fenster ist jetzt, bevor es teuer
    wird."* (:28967)
18. **Identität ist das Paar `(token, eltern)`.** Dasselbe Token trägt zwei Bedeutungen, entschieden
    allein durch das Elternteil (`f` = FPGA vs. AVX-512-Foundation) — *„wer nur Token prüft, kann diese
    Fälle nicht unterscheiden"* (:27407). Und: **leere Felder sind Aussagen, keine Lücken.**
19. **Der offizielle Bauweg ist `configure.sh` / `make` / `make install` / `make check` im Wurzelordner —
    beider Repos.** super = Anwender (XML: *was* und *wie*), ce = Framework (Planer/CEB/Tier-Binaries).
    *„Alte mittlerweile verbotene behelfswege."* (:29229)
20. **Ein Defekt wird behoben, egal wie gross** — *„zu gross"* ist kein Haltegrund mehr, *„die Doktrin
    bricht"* ist einer (:29853, :29877). Und: *„ein Ledger-Satz ist kein Beleg"* (:27533) — für VOLLZOGEN
    zählt nur eine Code- oder Commit-Stichprobe.
