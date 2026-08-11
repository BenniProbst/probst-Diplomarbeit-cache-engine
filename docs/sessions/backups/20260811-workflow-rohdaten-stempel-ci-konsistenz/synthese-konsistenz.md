# SYNTHESE — Korrekturliste, offene Fragen, Entlastungen

**Grundlage:** 6 Prüfschnitte, 20 gegengeprüfte Korrekturvorschläge (9 hielten vollständig, 3 im Kern mit widerlegtem Zusatz, 2 nur in der Diagnose, 6 fielen ganz), dazu ~40 Befunde ohne Gegenprobe. Objektstände: `ce 670483c0`, super `32b1947d` (development). Wo eine Aussage nur aus einem Bericht stammt, steht es dabei.

---

## TEIL 1 — W-1: aufgelöst. Und zwar anders, als *beide* Seiten es geschrieben haben.

### Die Auflösung steht seit dem 11.08., 16:12 Uhr im Ledger — als Owner-Wort

**KON8-12, Owner verbatim (16:12:20Z), gegen das Rohtranskript geprüft, Klammern korrekt gesetzt:**

> „die Teilmengen Prüfung [gilt] damit zwar insbesondere für **System-Achse und Organ-Achse als ZWEIPHASIGE Komponenten mit Freigabe → Ausführung** […] aber […] es ist auch möglich, dass durch **Mess-Achsen** und deren Meta-Meta-Achsen […] auch Teilmengen über die **DREIPHASIG** nachfolger Träger-Stufen entstehen können."

Das ist die Antwort auf W-1, ohne Hybrid-Vorbehalt, vier Stunden **vor** KON9-04. Bestätigt durch zwei weitere Owner-Sätze derselben Sitzung:

- **KON8-01** (~16:0x): der Vertrag gilt nur für die Mess-Achse; System- und Organ-Achse haben „kein synchron zu haltender Vertrag".
- **42174 / KON9-03 (17:41:20Z)**, Antwort auf die ausdrücklich gestellte Frage (C) „reicht der Hybrid die Freigabe weiter oder schneidet er sie?": „das Hybrid erreicht maximal die Spezifikation der System-Achsen Freigabe und die Tier-Binaries erreichen **SEPARAT** maximal die Spezifikations-Freigabe der System-Achsen, **ABER UNABHÄNGIG VON HYBRID**, weil die CEB das Hybrid und jede Tier-Binary **GLEICHRANGIG** aufbaut" — und die Begründung im selben Satz: „**das Hybrid kann nicht bauen**, sondern nur Tier-Binaries messen, die schon gebaut sind."

Dieses Zitat wurde zweimal unabhängig am Objekt gelesen (Explore und Gegenprobe; die Gegenprobe hält ausdrücklich fest: „real und korrekt zitiert, keine Erfindung").

### Der Mechanismus — das war die Lücke hinter „Da fehlt noch was"

Der Hybrid ist Glied der **MESS**-Kette, nicht der **BAU-/FREIGABE**-Kette. Weil er nicht bauen kann, nur messen.

| | ohne Hybrid | mit Hybrid |
|---|---|---|
| **Mess** (Planer → CEB → [Hybrid →] Tier) | 3 | **4** |
| **System** (CEB → Tier ‖ CEB → Hybrid, parallel) | 2 | **2** |
| **Organ** (CEB → Tier) | 2 | **2** |

„Da fehlt noch was" fiel gegen 16:12; die Antwort auf (C) um 17:41 — 89 Minuten später, in derselben Sitzung. Weder KON7-03 noch KON9-04 haben das eingearbeitet. **W-1 war nie eine offene Owner-Frage, sondern ein Agenten-Widerspruch gegen einen bereits vorliegenden Owner-Satz.**

**Ein Auslegungsschritt stammt von mir, nicht vom Owner:** KON9-01 (17:45:59Z/17:46:15Z, die zeitlich *jüngste* Aussage) sagt „der Hybrid wird bei den Trägern vor das Tier-Binary eingefügt wie gehabt" und liest sich seriell. Ich lese ihn als **ORT**-Aussage (Bau-/Messort), nicht als Freigabe-Reihenfolge — gedeckt durch die Hausdoktrin „ORT und ZEIT sind zwei Ordnungen, nie vermengen" und durch den fünf Minuten älteren Satz „das Hybrid kann nicht bauen". Widerrufbar mit einer Zeile (TEIL 3, F-1).

### Für die ZAHL der Grammatiken folgt: nichts. Sie war nie in Gefahr.

Owner-Wort (A), dieselbe Nachricht 42174: „zwei Grammatiken für DREIPHASIG und VIERPHASIG und eine Grammatik für ZWEIPHASIG" → **drei**. Das ist eine Stückzahl, keine Achsen-Zuordnung.

Und die Zahl bleibt in **beiden** denkbaren Lesarten drei:

| | Lesart A (System immer zweiphasig) | Lesart B (System mit Hybrid dreiphasig) |
|---|---|---|
| ZWEIPHASIG | System, Organ | System ohne Hybrid, Organ |
| DREIPHASIG | Mess ohne Hybrid | Mess ohne Hybrid, **System mit Hybrid** |
| VIERPHASIG | Mess mit Hybrid | Mess mit Hybrid |
| **Summe** | **3** | **3** |

**Damit ist der Wellenplan-Satz „Ohne diesen Entscheid ist die Grammatik-Zahl nicht schneidbar" (§14.2/§14.3) doppelt falsch:** die Zahl ist owner-gesetzt und in jeder Lesart drei. **S-2 ist nicht gesperrt.** Offen ist ausschließlich, in welcher der drei Grammatiken die Zeile „System mit Hybrid" steht.

### Was das mit KON7-03 macht

- „**Organ bleibt hybrid-unberührt**" — bestätigt, dreifach durch Owner-Wort.
- „**Die Ketten dehnen sich auf 4/3/2**" — die 4 hält (Mess mit Hybrid), die 2 hält (Organ), die **3 für System hält nicht**: 3 ist die Phasigkeit von *Mess ohne Hybrid*. KON7-03 ist ein Agenten-Diagramm, kein Owner-Wort (so auch die Gegenprobe).
- Einziger Beleg, der gegen die System-Hälfte spricht: die Formel „SYSTEM ZWEISTUFIG DEHNBAR" aus der owner-abgenommenen 05.08.-Doktrin — **aus Bericht, nicht nachgemessen**, und sie trägt beide Lesarten (Verbreiterung auf einen zweiten Empfänger vs. Verlängerung auf eine dritte Stufe). Daraus die eine Frage F-1. Nach Rangfolge (Neueres, Owner-Wort) ist sie bereits durch den 11.08. entschieden; ich stelle sie nur, weil ich die 05.08.-Formulierung nicht selbst am Objekt gelesen habe.

---

## TEIL 2 — Die Korrekturliste, nach Schwere

### A — blockiert den Bau

**A-1 · WIDERSPRUCH · Wellenplan §14.3 Regel 2 + §14.7 gegen Ledger KON12-01**
*Steht dort:* „Kein Planer-Kopf ohne P-0" · „der ExperimentPlanDirector … unangeschlossen im Submodul".
*Soll gelten:* Der Director ist gebaut, konstruiert und in jedem Nicht-Fehler-Pfad benutzt (`profile_run_facade.cpp`, ce 670483c0) — zweimal unabhängig am Objekt bestätigt. P-0 wird von **blockierend vor S-8** zu **begleitend zu S-8** herabgestuft („die super-Seite auf das ce-seitige Skelett ziehen, wenn S-8 gebaut wird").
*Warum:* KON12-01 ist sieben Minuten jünger als §14 und wurde nie nachgezogen; die Wiederverwendungs-Linie ruht zusätzlich auf einem wörtlichen User-GO vom 19./20.07. Nachtragen, nicht überschreiben.

**A-2 · WIDERSPRUCH · Wellenplan §13.3 gegen §14.3 (Regel 3)**
*Steht dort:* §13.3 lässt die Ordnungs-Relation (S-3) als „mengen-, nicht preimage-wirksam" zuerst nach W2 fallen; §14.3 zeichnet S-5 als abhängig von S-1, S-2 **und S-3** und führt S-5 als preimage-kritisch vor F2.
*Soll gelten:* S-3 ist über S-5 **transitiv preimage-wirksam** und fällt nicht; Regel 3 lautet „S-1, S-2, **S-3**, S-5, S-6, S-7" (deckt sich mit Kipppunkt K-2, der ohnehin „S-1…S-7" sagt). Nur #68 fällt.
*Warum:* Ohne S-3 kein S-5, ohne S-5 hält der Freeze nicht. Die Gegen-Option (S-5-Kante abschwächen) ist im Dokument durch nichts belegt.

**A-3 · WIDERSPRUCH · Wellenplan §14.2/§14.3/§14.4/§14.5 — der O-2-Nachzug (erst durch TEIL 1 schreibbar)**
*Steht dort:* O-2 an **sechs** Stellen als offener, blockierender Owner-Entscheid (Blocker-Zeile in §14.2 · Graph-Kante O-2→S-2 in §14.3 · Regel 2 „Kein Grammatik-Bau ohne O-1 und O-2" · W0b-Zeile „O-1…O-5" mit Fünfer-Zählung in §14.4 · WE-Zeile „setzt O-1/O-2 voraus" · **Kipp-Punkt K-1** in §14.5), dazu die S-2-Definitionszeile, die die Antwort schon enthält.
*Soll gelten:* An allen sechs Stellen entfällt O-2; S-2 hängt nur noch an O-1. Die S-2-Definitionszeile trägt die Zuordnung aus TEIL 1.
*Warum:* Diese Korrektur war in der Gegenprobe **zu Recht gefallen** — sie deckte nur 2 der 6 Stellen und tilgte die *technische* Abhängigkeit unbelegt. Beides ist jetzt gedeckt: die Vollständigkeit durch die Stellenliste, die Technik durch Owner-Wort (TEIL 1). K-1 ist die operativ wichtigste Stelle, weil sie an der Frist Fr 14.08. hängt.

**A-4 · LÜCKE · Wellenplan §14.4 — S-17 ohne Wellen-Platz**
*Steht dort:* §14.4 ordnet P-0 und **16 von 17** S-Posten einer Welle zu. S-17 (Lager-Baum-Writer) fehlt — es wurde erst in §14.7 nachgetragen.
*Soll gelten:* S-17 bekommt einen Wellen-Platz oder wird ausdrücklich als „blockiert durch O-9, Welle offen" geführt.
*Warum:* Der einzige echte Null-Befund unter den 17 Bau-Teilen. (Der weitergehende Vorwurf, alle 17 hätten keine Zuordnung, ist widerlegt — siehe TEIL 4.)

### B — verzerrt eine Owner-Frage · **Klasse VORWEGNAHME** (die Klasse, vor der der Owner warnt)

**B-1 · KON9-04 + KON9-12 Punkt 4 — die Grammatik-Zuordnung**
*Steht dort:* „DREIPHASIG: Mess ohne Hybrid; **System/Organ MIT Hybrid**" und der Schlusssatz „Dieselbe Organ-Achse trägt im reinen Tier-Zweig eine andere Grammatik als im Hybrid-Zweig."
*Soll gelten:* Die Tabelle aus TEIL 1. Die Zeile „System/Organ MIT Hybrid" wird aus DREIPHASIG gestrichen; die Organ-Zeile ist durch Owner-Wort entschieden, die System-Zeile trägt bis zur Bestätigung (F-1) den Vermerk „Lesart A gilt; Lesart B verschiebt nur diese eine Zeile".
*Warum:* Owner-Wort deckt nur die **Stückzahl** drei, nie die Achsen-Zuordnung. Die Zuordnung ist agenteneigen und widerspricht einem vier Stunden älteren Owner-Satz (KON8-12). Die Diagnose hielt in **zwei unabhängigen Schnitten**; nur die Rezepte differierten — TEIL 1 entscheidet zwischen ihnen mit Owner-Wort, nicht mit Herleitung. *Die Fassung dieser Korrektur, die die Gegenprobe bestanden hat („für Organ offenlassen, System-Zeile stehen lassen"), ist damit überholt — schärfer, nicht schwächer.*

**B-2 · Memory `feedback_ort_und_zeit_sind_zwei_ordnungen_nie_vermengen.md`, Abschnitt „BEIDES GILT ZUGLEICH"**
*Steht dort:* „Daraus folgt die PHASIGKEIT: Mess vierphasig, System/Organ dreiphasig (mit Hybrid)."
*Soll gelten:* „Aus dem ORT-Satz folgt **keine** Phasigkeit. ORT ist eine andere Ordnung als die Freigabe-Kette; die Phasigkeit steht in KON8-12 (Owner, 16:12) und 42174-(C) (Owner, 17:41)."
*Warum:* Die Memory leitet aus einem Owner-Satz über die Träger-*Position* eine Aussage über die *Freigabe-Stufen* ab. Genau diese Vermengung verbietet ihr eigener Titel. Eine Memory wirkt in jede künftige Sitzung ungeprüft hinein — deshalb steht sie hier höher als ihr Umfang vermuten lässt.

**B-3 · KON10-03 „Die zwei Ablagen sind entworfen"**
*Steht dort:* Das Owner-Zitat zur „Wurzel des Buildsystem-Caches (bereits auf NAS aufgebaut)" wird neben §31-A4 (dev-/prod-MinIO) gestellt; Schluss: „Damit ist auch Rolle (2) des Stempels entworfen."
*Soll gelten:* Titel und Schlusssatz mit Vorbehalt: die **Storage-Architektur** ist entworfen (seit 19.07.), die **Identität** der NAS-Wurzel mit §31-A4 ist offen (O-9) und blockiert S-13/S-17. Rolle (2) ist damit nur teilweise entworfen.
*Warum:* KON10-03 beantwortet stillschweigend mit „ja, dasselbe" genau die Frage, die die Owner-Vorlage desselben Abends als O-9 offen und blockierend führt.

**B-4 · KON10, Kopfabsatz des Nachtrags**
*Steht dort:* „Der Entwurf existiert vollständig, seit dem 19.07.2026 … und er trägt **JEDE** Festlegung dieser Nacht im Kern."
*Soll gelten:* „…und er trägt die Ketten-, Dock-, CI- und Storage-Architektur dieser Nacht im Kern." Die konkrete Drei-Grammatiken-Taxonomie und die **Benennung** der fünf Stempel-Rollen sind eigene Leistung dieser Nacht.
*Warum:* Der Vollständigkeitsanspruch ruht auf fünf Zitaten, die alle die Kette/Storage betreffen. (Der weitergehende Widerruf ist widerlegt: „AxisCommand" gehört gar nicht zu KON9-06 — es ist seit 06.07. gebaut —, und der Owner selbst sagte in Echtzeit „Du hattest das schon entworfen". Siehe TEIL 4.)

### C — sachlich falsch

**C-1 · KON11-01 „Die Inventur des Unverdrahteten"**
*Steht dort:* „Elf Positionen. **Neun** davon sind gebaut und nicht verdrahtet."
*Soll gelten:* Vier Kategorien statt einer, und **vorerst keine Summenzahl**:
- *0 Aufrufer, gesichert (2):* LagerBaumWriter · Hybrid-Header.
- *Verdrahtet, Wirkung unvollständig (1):* axis_version_lock (Job `contract:axis-version-lock` läuft real).
- *Bereits aktiv genutzt (5):* catalog_codegen.cmake (unbedingtes `include`) · IResourceControllableTier (Basisklasse, 21 Dateien) · AxisCommand (concept-Constraint mit static_assert) · ram_probe_chain (echter Aufruf in `hardware_probe_factory.hpp`) · ExperimentPlanDirector (in die Gegenrichtung falsch etikettiert).
- *Erreicht, aber wirkungslos (1):* run_selection_filter_chain → C-2.
- *Noch nicht nachgemessen (2):* i_command.hpp (konsumiert, aber ABI-Fläche default OFF) · v32_messreihe_antrieb (super-Repo; das eigene Testfile nennt es „GENUTZTE Antriebs-Quelle").
*Warum:* Drei Tabellenzeilen beschreiben sich selbst als aktiv und werden trotzdem mitgezählt. Weder „neun" noch die zuerst vorgeschlagene Ersatzzahl „drei bis vier" ist belegt — erst die zwei offenen Positionen messen, dann zählen.

**C-2 · KON11-01, Zeile `run_selection_filter_chain`**
*Steht dort:* „existiert, 0 Produktions-Konsumenten — nur ein Test".
*Soll gelten:* **4 Produktionsaufrufer** über `resolve_selection` (3× `profile_run_entry.hpp`, 1× `experiment_run_entry.hpp`), aber **stets mit leerer Kette** (Default `{}`) → golden-neutrale Identität. Der einzige konkrete Handler `ResumeFilter` hat 0 Produktionsinstallationen; der reale Reduktions-Handler ist #156, ausdrücklich deferred.
*Warum:* Es ist eine Aktivierungslücke am Filter, keine fehlende Verdrahtung des Einhängepunkts. Die Anker als **Symbol** führen, nicht als Zeile — die Zeilen sind binnen 5 Tagen um ~220 gewandert.

**C-3 · Memory `reference_stempel_traegt_fuenf_rollen…`, MEMORY.md-Zeile „STEMPEL", Pause-Doku 3.2**
*Steht dort:* „**Vier** der fünf Rollen sind im Code bereits durchgesetzt."
*Soll gelten:* **Zwei** von fünf (IDENTITÄT, EINORDNUNG) laufen über den produktiv verdrahteten Fingerprint-Mechanismus. LAGER-SCHLÜSSEL und SKIP-MARKE sind **entworfen und getestet, nicht durchgesetzt**: die einzigen Aufrufer von `make_binaries_baum_writer`/`make_messdaten_baum_writer` bzw. `make_messwert_key_fn` stehen in je einer Testdatei. Rolle (2) CACHE-SCHLÜSSEL bleibt offen.
*Warum:* Ein Kommentar in einer Klasse ohne Produktionsaufrufer erzwingt zur Laufzeit nichts. Der Ledger selbst sagt es zweimal später in derselben Nacht (KON11-01, KON12-03), der Code sagt es selbst (`skip_manifest.hpp`: „wird real nirgends konstruiert, nur in Tests"). Alle drei Dokumente entstanden 18:15–18:18, vor KON10/11/12 — und MEMORY.md lädt jede künftige Sitzung ungeprüft.

**C-4 · KON12-02 „S-14 neu erhoben: 7 von 130"**
*Steht dort:* „7 Dateien mit AXIS_ALGO_VERSION-Marker (grep -rl)" · „die Lock-Datei trägt 9 Einträge (die Differenz zu 7 ist nicht aufgeklärt)".
*Soll gelten:* **6** echte Marker-Träger (`csv_cell_reader.hpp` nennt den Marker nur in einer Prosa-Zeile über eine *andere* Datei). Die Lock-Datei hat **9 Zeilen, davon 6 Datenzeilen** — dieselben 6 Dateien, die auch als CLI-Argumente im CI-Job stehen: **keine unaufgeklärte Differenz**. Und: **„X von 130" ist keine Deckungsquote.** Die 6 Marker-Träger liegen sämtlich unter `libs/cache_engine/heuristik/`, die 130 Dateien sind `axes/`-Header — Schnittmenge **0** (`comm -12`), und **keiner** der 130 trägt irgendeinen `*_VERSION`-Marker. Weder 123 noch 124 ist eine belastbare Zahl.
*Warum:* Zwei disjunkte Dateimengen sind hier nur über das gemeinsame Wortfragment „axis/axes" zusammengeraten. Vor dem Ausrollen muss der Nenner neu definiert werden.

**C-5 · Wellenplan §14.4 (Frist-Zeile) und §14.5 (K-1); Owner-Vorlage Kopfzeile und O-1-Absatz — „Do 14.08."**
*Soll gelten:* **„Fr 14.08."** an allen vier Stellen. 14.08.2026 ist ein Freitag; 8 weitere Stellen derselben Dokumente tragen es korrekt.
*Warum:* Die Frist steht am Kipp-Punkt K-1 und ist inzwischen in die lebende Owner-Vorlage gewandert. Alle 30+ Wochentag/Datum-Paare in §13/§14 wurden nachgerechnet — sonst keine Abweichung.

### D — ungenau · **aus Bericht, nicht gegengeprüft**

| Stelle | Steht dort | Soll gelten |
|---|---|---|
| KON9-06, Owner-Zitat | „…zur Laufzeit wird auf der CEB die hardware analysiert" | „…auf der CEB **(explore über 10 Wochen)** die hardware…" — unmarkierte Kürzung, die **zweite** in diesem Zitat (die erste ist als E-1 bereits korrigiert) |
| KON9-03, Owner-Zitat | „gleichrangig, das Hybrid kann nicht bauen" | „gleichrangig **auf**, …" — trennbares Präfix fehlt; die Parallel-Synthese derselben Nacht hat es korrekt |
| KON10-02, D17-Zitat | „Bau-Fläche" | „**Build**-Fläche" (Original: 1 Treffer; „Bau-Fläche": 0) |
| KON10-01, Überschrift | „D5 ist der Owner-Satz von heute, **wörtlich** vorweggenommen" | „…**inhaltlich** vorweggenommen" — die Doktrin ist dieselbe, der Wortlaut nicht |
| KON10-06 | „…fand **einen** BLOCKER" | Die BAUPLAN-Kritik nennt **6** Befunde; zitiert ist 1. Besonders Kritik 4 (resolve_selection) fehlt |
| KON12-01 | „erscheint **ausschließlich in zwei Testdateien**" | 9 super-eigene Dateien, davon 2 Tests; `main.cpp` enthält einen echten, aber **doppelt präprozessor-gegateten** Aufruf. Der Substanzbefund „kein Produktionspfad" hält, die Dateizahl nicht |
| Owner-Vorlage O-1 | „295 static_assert" | **294** (zwei Zählweisen; KON7-08 führt im selben Ledger bereits 294) |
| Memory Selbstkompilation | „builder/commands/ trägt **18** Dateien" | **16 .hpp** (19 inkl. README/CMakeLists/Doxyfile) — Zahl ohne Nenner |
| Pause-Doku, Quellentabelle | Ledger-Zeilenanker `:10617`, `:11529`, `:12242` | Über KON-Kennung/§ ankern. Drift binnen Stunden ~840 Zeilen; die Code-Anker derselben Tabelle sind exakt |
| Pause-Doku §5, Punkt 5 | unter „Owner-Entscheid" | KON8-12 nennt es „offener **Explore-Gegenstand**, kein Bauauftrag" — eigene Kategorie |
| Owner-Vorlage, Kopf | „die **einzigen**, die eine Recherche nicht auflösen konnte" | Fork E ist seit 19.07. GO-pflichtig, blockiert S-8 und fehlt → „die zehn dringendsten bis F1" |
| Owner-Vorlage, Kopf | „…weil er sich als eigener Interpretationsfehler **erwies**" | KON11-02 sagt „mit hoher Wahrscheinlichkeit". *(Mit TEIL 1 wird der Satz ohnehin neu: aufgelöst durch Owner-Wort.)* |
| Wellenplan §13.3, #67 | (P)-getaggt, fehlt in „Nie fallen darf"; „142 Include-Kanten / 29 Wanderungen" | Aufnehmen oder begründen; die Zahlen haben im 21.270-Zeilen-Ledger **0** Belegstellen |
| Wellenplan §13.3/§13.4c/§14 | 62 h Band B als Entlastung | §12.5 führt dieselben 62 h bereits als Voraussetzung der alten Last — einmal buchen. §14 nennt **keine** Stundenzahl für S-1…S-17+P-0 |
| GOAL v8 §VI.2 | „HYBRID — 0 % gebaut" | 4 Header, 943 Zeilen (11.08. gemessen). §13.5 führt dieselbe Korrektur für die Wellenplan-Zeile, nicht für GOAL v8 |
| Wellenplan §14.2 / §14.3 | O-5 blockiert „S-10" (Tabelle) vs. „→ S-15" (Graph) | Eines von beiden; inhaltlich passt S-15 |

---

## TEIL 3 — Die Fragen an den Owner

Nur was der Explore nicht auflösen konnte. **O-2 bleibt draußen** — jetzt aus einem stärkeren Grund als am 11.08.: nicht „wahrscheinlich meine Fehlinterpretation", sondern durch Owner-Wort aufgelöst.

**F-1 · Bestätigung, eine Zeile.** Meinte „SYSTEM ZWEISTUFIG DEHNBAR" (05.08.) eine **Verbreiterung** (die System-Freigabe geht zusätzlich an einen zweiten, gleichrangigen Empfänger — jede Kette bleibt zweiphasig) oder eine **Verlängerung** (mit Hybrid läuft System seriell CEB→Hybrid→Tier, also dreiphasig)?
- *Verbreiterung:* System steht in derselben Grammatik wie Organ. Deckt sich mit KON8-12 (16:12) und 42174-(C) (17:41).
- *Verlängerung:* die Zeile „System mit Hybrid" wandert in die DREIPHASIG-Grammatik zu „Mess ohne Hybrid". Dann ist zusätzlich zu klären, wie das mit „die Tier-Binaries erreichen separat … unabhängig von Hybrid" zusammengeht.
- *Freischaltet/blockiert:* **nichts wird blockiert.** In beiden Fällen sind es drei Grammatiken; entschieden wird genau eine Tabellenzeile in S-2. Wenn der Satz so gemeint war wie in TEIL 1 gelesen, ist nichts zu tun.

**F-2 · Arität der VIERPHASIG-Grammatik (Mess mit Hybrid).** Ist der vierphasige Mess-Vertrag eine echte **Vier-Parteien-Kette** (Planer/CEB/Hybrid/Tier synchron zu halten) oder ein **Zwei-Partner-Vertrag** CEB↔{Tier | Hybrid} plus eine Durchreichungsregel?
- *Vier Parteien:* S-4 baut einen vierstelligen mp11-Filterketten-Concept.
- *Zwei Partner + Durchreichung:* S-4 erweitert den bestehenden Vertrag um eine Durchreichungsregel und eine eigene Hybrid-Stempelzeile.
- *Freischaltet/blockiert:* blockiert **S-4**, nicht S-2; die Zahl drei bleibt in beiden Fällen. Der Explore konnte es nicht auflösen, weil der Owner-Satz „reicht sie dann weiter durch" (KON9-03) die **System**-Freigabe betrifft, nicht den Mess-Vertrag.

**F-3 · O-9, geschärft.** Im Korpus sind **vier** unterscheidbare Objekte im Umlauf, die alle „buildsystem"/Cache heißen. Welches ist „die Wurzel des Buildsystem-Caches (bereits auf NAS aufgebaut)" — oder ist es ein fünftes?
1. NAS-Mount `/mnt/comdare-buildsystem` (08.08. vermessen; 0 Treffer in ce/libs+ce/apps),
2. MinIO-Bucket `buildsystem-cache` (Ebene A, GitLab-Runner-Cache, VERORTUNGS-BRIEF 18.07.),
3. prod-MinIO aus §31-A4 / `COMDARE_MINIO_BUCKET` (Ebene B — der Code sagt selbst „getrennt vom buildsystem-cache"),
4. der live genutzte NAS-Unterordner `Cluster_NFS/cache-engine-experiment/` (Ledger 07.08.).
- *Freischaltet/blockiert:* blockiert **S-13, S-17** und Rolle (2) des Stempels; entscheidet zugleich, ob die gebaute, aber unkonfigurierte Typweiche `BinaryAufNasZiel` einen Pfadwert bekommt.

**F-4 · Verfahren, eine Zeile.** Fork E (XML-Kanal-Konvergenz Experiment- vs. Thesis-Profil, seit 19.07. GO-pflichtig, blockiert S-8) — als elfter Punkt **jetzt**, oder separat kurz vor S-8-Start (ca. 24.08.)? Gleiches für Fork B und R1.
- *Jetzt:* die Vorlage wird vollständig, die Frist Fr 14.08. trägt einen Punkt mehr.
- *Später:* die Vorlage bleibt bei zehn, dafür muss der Vollständigkeitssatz („die einzigen") entschärft werden.

### Prüfung der bestehenden zehn

| | Befund |
|---|---|
| **O-1** | **Bleibt wie gestellt.** Der Einwand „die Empfehlung nimmt die Setzung vorweg" hat der Gegenprobe nicht standgehalten: die Vorlage rahmt jede Empfehlung als „ein Vorschlag, kein Vorgriff", O-1 trägt als **einziges** Item zusätzlich den Satz „Das ist eine Setzung, keine Ableitung", und die Folgekette ist bis zur echten Antwort gesperrt. Nur die Zahl korrigieren: **294** statt 295. |
| **O-3** | Bleibt. Die Frage steht wörtlich im Code selbst (`algo_semver.hpp`, „fordert das Flag die Voraussetzung, oder impliziert es sie?"). |
| **O-4** | **Falsch gestellt.** Die Teilfrage „und gibt es sie dort überhaupt?" ist für Organ bereits entschieden — Owner-E2 (02.08.), verbatim im Header `organ_meta_meta_axis.hpp`: „Die Meta-Meta-Achsen … sind wie alle Hauptachsen **PFLICHT** … da eine Meta-Meta-Achse immer zu den Mess-Achsen, System-Achsen oder Organ-Achsen gehört." Offen ist nur der **Inhalt**. *Aus Bericht, nicht nachgemessen — vor dem Umformulieren einmal am Objekt lesen.* |
| **O-5** | Bleibt, aber das Ziel ist im Wellenplan uneindeutig (Tabelle „S-10", Graph „S-15"). Vor dem Stellen klären. |
| **O-6** | **Prämisse prüfen.** „Keine Quelle im gesamten Korpus" steht gegen Ledger §40.b (19.07., Owner verbatim): „Stufe 1 = Planer emittiert die CEB-Bau-Jobs (Child-Pipeline 1) … Stufe 2 = jede CEB emittiert ihre Tier-Binary-Bau-Jobs (Child-Pipeline 2)". Ob das den **Hybrid**-Fall trägt oder eine andere Frage ist, blieb in der Gegenprobe ausdrücklich ungeklärt. *Aus Bericht.* Die Empfehlung selbst muss nicht geändert werden. |
| **O-7 · O-10** | In diesem Durchgang **nicht geprüft** — kein Befund, aber auch keine Entlastung. |
| **O-8** | Bleibt unverändert. Die Drei-Optionen-Form wurde ausdrücklich als offen und nicht vorentschieden bestätigt. |
| **O-9** | Bleibt, geschärft → F-3. |
| **O-11** | Bleibt. Die Prämisse „keine Quelle" wurde am Ledger gegengeprüft (nur die eine Owner-Zeile). |

**Keine der zehn kann ersatzlos entfallen.** Eine ist falsch gestellt (O-4), eine trägt eine fragliche Prämisse (O-6), eine ist zu unscharf gestellt (O-9), eine trägt eine falsche Zahl (O-1).

---

## TEIL 4 — Was bestätigt wurde

### 1. Elf von 20 Korrekturvorschlägen fielen — der Bestand war richtig

| Angegriffen | Ergebnis |
|---|---|
| **KON11-01, „Hybrid-Header: 0 Stempel-Bezug"** | **Hält.** Die 8 „Stempel"-Treffer in den 943 Zeilen sind samt und sonders Prosa oder Diagnosetext; `version_stamp\|fingerprint\|algo_version` = **0 in 4 von 4** Dateien. KON9-02 hatte genau so gemessen und im selben Absatz zwischen SOLL und IST getrennt; KON9-12 Punkt 6 führt die Lücke bereits als Bau-Posten. |
| **Owner-Vorlage O-1** | **Hält** (siehe TEIL 3). Der Owner-Arbeitsmodus „wir konvergieren mit Verbesserungsrunden" ist wörtlich belegt; 32 Ledger-Stellen mit „wie empfohlen". |
| **Owner-Vorlage O-9** | **Hält, besser belegt als die Kurzfassung.** `comdare-buildsystem` ist kein falsches Wort, sondern der reale NAS-Mount. Der als Gegenbeleg angeführte Kommentar sagt „**getrennt vom** buildsystem-cache" — das Gegenteil der Gleichsetzung. `lager_ziel_strategie.hpp` ist eine Typebene ohne Produktionskonsument (einziger Aufrufer: ein Test, Platzhalter `/mnt/measure-drop`). |
| **Owner-Vorlage O-6** | **Hält als Frage.** O-6 verweist offen auf O-8, statt zu verschweigen; die Empfehlung ist dokumentweit als „Vorschlag, kein Vorgriff" markiert. Der Korrekturvorschlag hätte eine offene Entscheidung Richtung Child-Pipeline vorentschieden. |
| **Wellenplan §14.2 (O-2/S-2 als Vorwegnahme)** | **Fällt.** Die Sperre steht bereits dreimal im selben Abschnitt („blockiert: S-2", „Kein Grammatik-Bau ohne O-1 und O-2", „setzt O-1/O-2 voraus"). |
| **Wellenplan, HY-A-Wochenende 22./23.08.** | **Fällt.** §14.6 weist den Entzug ausdrücklich mit Zahl aus („Nach dieser Gliederung ist die Reserve null"), und §14 zitiert das Owner-Wort „volles Risiko … alles in Reihenfolge". Zwei der drei Ersatzvorschläge waren am Objekt falsch (15./16.08. ist bereits mit S-2 belegt). *Rest:* für den Fall, dass HY-A das Wochenende doch braucht, fehlt eine Ausweichregel. |
| **Wellenplan §12.2/V-6 („17 Bau-Teile ohne Abnahme")** | **Fällt.** §14.4 ordnet P-0 und **16 von 17** S-Posten einer Welle zu; „Band A/B/C" ist keine Bau-Posten-Kategorie, sondern eine Test-Stunden-Kategorie ab §12.4. *Rest:* S-17 → A-4. |
| **KON10-Kopfabsatz (Vollständigkeitsanspruch)** | **Fällt bis auf die Präzisierung** (→ B-4). „AxisCommand" gehört gar nicht zu KON9-06 (seit 06.07. gebaut, fünf Wochen älter); KON10-03 beansprucht ohnehin nur 1 von 5 Rollen; und der Owner sagte in Echtzeit „Du hattest das schon entworfen" — das war der Auslöser des Nachtrags. |
| **KON12-02 (Schlusssatz „124 statt 123")** | **Fällt** — und deckt dabei die tiefere Kategorienvermischung auf (→ C-4). Der Kern (6 statt 7) hält. |
| **KON9-04-Diagnose (zwei Schnitte)** | **Hält doppelt.** Nur die Rezepte differierten; TEIL 1 entscheidet mit Owner-Wort. |
| **Wellenplan-O-2-Streichung** | Befund hält, Fassung war unvollständig (2 von 6 Stellen) → jetzt vollständig in A-3. |

### 2. Die Festlegungen dieser Nacht, die am Objekt standhielten

**Owner-Zitattreue** — wörtlich gegen das Rohtranskript geprüft: KON8-12 (inklusive korrekt gesetzter `[gilt]`/`[…]`-Marken — lehrbuchhaft), KON9-01 (zwei aufeinanderfolgende Owner-Nachrichten korrekt verbunden), KON9-02, KON9-08, KON9-09 (Filter A monoton / Filter B zweischneidig).

**Die Zahlen, mit Nenner:**
- `hybrid/`: **4 Header, 943 Zeilen** (189 + 256 + 246 + 252) — in 6 unabhängigen Arbeitskopien byte-identisch.
- Fünf Versionierungs-Dateien: **56 / 619 / 208 / 399 / 85** Zeilen — alle fünf exakt.
- `algo_semver.hpp`: **1535** Zeilen, **54** constexpr, **294** static_assert; `flag_grammar_catalog.hpp`: **755** Zeilen, **21** constexpr; `teilmenge|dominiert|ist_hoeher` = **0 in beiden** → der „die Ordnung fehlt"-Befund von KON9-05/O-1 hält.
- `kVollausbau`: static_assert beweist `.flags.count == 59`.
- **371** `axes/`-Header, davon **130** mit `algo_version` — KON12-02s Basiszahlen exakt reproduziert.
- **5** handgeschriebene Dock-Versionen, alle `1.0.0.c` (die rohe grep-Zahl 8 zählt static_assert-Fehlertexte mit).
- LagerBaumWriter: **1** Datei in ce/libs+ce/apps (die eigene), **0** Produktionskonstruktionen im ganzen Baum. Gegenprobe `BuildOrchestrator`: **11** Treffer im selben Scope (**18** im Gesamtbaum — zwei Nenner, beide genannt). Die Null ist real, kein Suchfehler; der Code sagt es selbst.

**Die Sachbefunde:** KON12-01 (ExperimentPlanDirector ist ein echter, benutzter Aufruf — zweimal unabhängig bestätigt, Task #91 zu Recht geschlossen) · KON12-03/S-17 (hält exakt) · KON7-03s Satz „Organ bleibt hybrid-unberührt" (durch Owner-Wort bestätigt, siehe TEIL 1) · O-8s Drei-Optionen-Form · O-11s „keine Quelle" · der Kalender in §13/§14 (30+ Paare, genau 2 Abweichungen) · die S-4-vor-S-8-Kante im Graph · die Registry-Zahl 22→23 an drei Stellen konsistent.

**Der Hybrid-Scheinwiderspruch:** „kein eigener ABI-Schritt" (Wellenplan) gegen „Hybrid ist selbst ein Genus mit Fläche 2" (KON9-02) — **kein Widerspruch**: ABI-Major-Mechanik gegen Identitäts-*Inhalt*. Erst auf Fehlinterpretation geprüft, dann verworfen, genau wie Konfliktregel Rang 3 es vorschreibt.

### 3. Was die Nacht methodisch gewonnen hat

- Die **Konfliktregel** (KON11-02) hat zweimal getragen: sie hat O-2 aus der Owner-Vorlage genommen (richtig) und in dieser Prüfung 11 von 20 Widerrufen abgefangen.
- Die **Zeilenanker-Regel** (KON10-08/KON11-05) hat sich selbst bestätigt: die Ledger-Anker im Pause-Doku sind binnen Stunden um ~840 Zeilen gedriftet, die Code-Anker (ce auf 670483c0) sind exakt geblieben. Deshalb steht in dieser Liste keine einzige Ledger-Zeilennummer.

### 4. Was **nicht** geprüft wurde — damit die Freigabe ihren Gegenstand kennt

- **O-7 und O-10** der Owner-Vorlage: kein Befund, aber auch keine Entlastung.
- **14 von 17 Bau-Teilen** (S-1…S-9, S-11…S-13, S-15, S-16) sind nie gegen den Code-Objektstand geprüft worden; nur P-0, S-14, S-17 (**3 von 17**). Weitere „billiger/teurer als angenommen"-Befunde sind vor F2 nicht auszuschließen.
- Der **Stunden-/Tage-Aufwand** von S-1…S-17+P-0 steht an keiner Stelle im Text; „Termine unverändert" ist aus dem Dokument allein nicht entscheidbar.
- Die **Owner-Zitattreue von KON9-11 und KON10-01** wurde nicht gegen das Rohtranskript geprüft (nur die Design-Dokument-Zitate D1/D5/D17/D18/§38 gegen ABSTRACT/BAUPLAN).
- Die **CI-Explore-Schnitte 2 und 3** und die zwei `synthese-*.md` (19:43/19:50) sind in keinen der sechs Schnitte eingegangen.
- **`i_command.hpp`** und **`v32_messreihe_antrieb`**: die Einordnung in der Inventur (C-1) steht aus — vorher darf keine neue Summenzahl in den Ledger.
- **#67s Zahlen** „142 Include-Kanten / 29 Wanderungen": im gesamten Ledger 0 Belegstellen, nur im Wellenplan und in einer Session-Datei wortgleich. Herkunft ungeklärt.
- Ob **#67** preimage-relevante Bezeichner betrifft oder nur Datei-/Include-Organisation, ist eine Code-Frage, die ein dokumentenbasierter Schnitt nicht klären konnte.