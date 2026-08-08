# SESSION 07./08.08.2026 — die Mess-Kette, Paper-als-XML, und vier Ultracode-Läufe

**Zeitraum:** 07.08. abends bis 08.08. mittags · **Refs bei Abschluss:** ce `15522cdc` · super `9ac3ca57`
· thesis `798e946` · cluster `cd7c64d` — alle Pipelines grün.

> **Wozu dieses Dokument.** Es ist die Übergabe für den nächsten Kontext. Es hält **erstens** fest, was
> gebaut wurde, **zweitens** — und das ist der wertvollere Teil — die Architektur-Erklärungen des Owners
> im Wortlaut, weil sie über Wochen verstreut waren und in dieser Session zum ersten Mal zusammenhängend
> gefallen sind. **Drittens** meine eigenen Fehler, weil sie ein Muster bilden, das der nächste Kontext
> kennen muss.

---

## 1. WAS GEBAUT UND GELANDET IST

| Paket | Ref | Was den Beleg trägt |
|---|---|---|
| **E-E Overlay-Glied** | ce `986c0a8c` | 711 Dateien im Schnitt, **428/428** über den gemergten Stand, 12 `static_assert` im Schnitt-Header, **sechs** Anker (drei auf Literale gezogen, weil ein wandernder Anker keiner ist) |
| **A6 NAS-Kommentar** | ce `a2b928eb` | die „backup1 ist abgeschaltet"-Begründung war falsch — am Objekt widerlegt |
| **`lint:static`-Heilung** | ce `a2b928eb` | Pipeline 15250 **grün**; `development` war davor **zwei Pipelines lang rot** |
| **cppcheck-Gate in der Vor-Push-Wache** | ce `db6cc047` | beide Richtungen bewiesen: ohne Köder grün, mit Köder rot |
| **`m64`-Medien-Basis** | ce `15522cdc` | 428/428, vier Bissbeweise mit echter Compiler-Ausgabe, Entscheide-Zähler 6 → 0 |
| **Thesis nachgezogen** | thesis `798e946` | DE 204 / EN 194 Seiten, chktex 0 Funde, acht Lizenz-Fundorte korrigiert |
| **Gitlinks** | super `6d8dd432` | ce 37 Commits, beide Thesis-Zeiger — je mit **Vorwärts-Beweis vor** dem Setzen |
| **A8 NAS vollständig** | — | drei Mounts reboot-fest, `/mnt/comdare-buildsystem` mit **15 T frei** |

**Vier Ultracode-Läufe, 73 Agenten:** LaTeX-Anlage (20) · vergessene Arbeit + Wellenplan (26) ·
Gesamt-Dossier über sechs Kontexte (6, Fable 5 xhigh) · `--check-size` + Messkette (21).
Ihre Produkte liegen als eigene Dokumente in `docs/plaene/` und `docs/sessions/`.

---

## 2. DIE ARCHITEKTUR, WIE DER OWNER SIE MEINT — der eigentliche Ertrag

### 2.1 Der Experiment-B+-Baum IST die Vergleichs-Ordnung

> *„Wenn nun Jede Achse über verschiedene geplante Permutation ein Glied in der **Sortierten Kette** von
> der **Mess-Achsen Wurzel** statischer Achsen Reihenfolge, über die **System-Achsen** statischer
> Reihenfolge, bis in die **Organ-Achsen** statischer Reihenfolge, ein Glied eines **lazy
> materialisierten Experiment-B+-Baum**-Konfiguration ist, dann ist es als **node** zu betrachten und
> definiert in einer **gleichen Baum-Tiefe** seiner Selbst eine bestimmte Achse im Gesamtbaum. Diese
> Eigenschaft eines Achsen-Algorithmus lässt sich **gegen alle nodes derselben Ebene vergleichen,
> insbesondere für den Fall derselben nachfolge Pfade unter der besagten Ebene."* — 08.08.

**Das Beispiel, das es trägt:** ein bestimmtes `memory` mit einem bestimmten `prefetching` laufen
lassen, dann die Unterschiede verschiedener `memory` verstehen — **bei identischen prefetching- und
tieferliegenden Algorithmen**, sodass der Achsen-Algorithmus die **einzige Änderung in der Binary** ist.
Über das **Diff** wird der Break-Even isoliert, für alle Binaries die Funktionskurve synthetisiert, und
abgelesen, **bei welcher Last-Art und -größe die Achse optimal läuft**.

**Warum das alles ändert:** die statische Achsen-Sortierung ist **keine Kosmetik**. Sie legt fest, auf
welcher Tiefe welche Achse sitzt — und nur dadurch existiert überhaupt ein **Geschwister-Vergleich bei
identischem Nachfolge-Pfad**, also ein kontrolliertes Experiment mit genau einer unabhängigen
Variablen. **Das ist der Grund für die Erst-Klammerung vom 19./20.07. und die drei kanonischen
Achsen-Ordnungen aus E-E.**

**Die wissenschaftliche Frage der Arbeit in einem Satz:** nicht *„welche Komposition ist die beste"*,
sondern **„wäre Papers X Algorithmus für Achse A besser gewesen als der von Paper Y, bei sonst gleicher
Konfiguration?"** — für jede Haupt- und Unter-Achse einzeln, sequentiell durchpermutiert.

### 2.2 Der Mess-Baum — drei Ebenen, nicht zu verwechseln mit dem Experiment-Baum

| Ebene | Ort | misst |
|---|---|---|
| **Wurzel** | CEB-Prüfdock | Gesamtverlauf: alle parallelen Achsen-Observer-Streams über gemischte Lasten und multiple Gattung+Genus-Aufrufe → `wallclock CEB root` |
| **Mitte** | CEB-Prüfdock | **exakt EIN** Funktionsaufruf am Tier-Binary-Interface, Checkpoint davor/danach, **exponiert alle Observer-Streams seiner intern verwendeten Achsen** |
| **Unten** | **Tier-Binary** | die Achsen selbst mit eingebautem Micro-Benchmarking; Checkpoint vor/nach **jedem einzelnen** Achsen-Aufruf, **akkumuliert** über die Aufrufe |

**Checkpoint-Semantik, verbatim:** *„Ein checkpoint steht immer **VOR** der Verwendung einer Achse und
verbindet die angewendeten **Achsen-Parameter** mit der **Wallclock time VOR** der Durchführung des
Algorithmus einer Achse, der Andere Checkpoint misst die Achsen-Parameter **NACH** der Ausführung … und
hält den wallclock time Zeitpunkt fest."*

**Die fünf Mess-EBENEN** (andere Achse als die drei Stufen — die Stufen sagen *wie fein*, die Ebenen
sagen *wo der Messpunkt sitzt*): Planer-CLI · Prüfdock Gesamt-Last · Prüfdock je Interface-Aufruf ·
Tier-Binary Macro · Tier-Binary Micro. **Also 5.**

### 2.3 Die 6 CEBs — der Messfühler ist ein Verbraucher

> *„Um den Messfehler herauszufiltern, der durch die Messung selbst an zusätzlicher Latenz entsteht,
> muss die CEB einmal gebaut werden, dass sie aus Micro/Macro/combined-Load insgesamt **3 fakultät
> Permutationen** an eingebauten und ausgebauten Last-Messgeräten an CEBs erzeugt … **Das ist wie in der
> Elektrotechnik, weil der Messfühler ein Verbraucher ist**, wir aber den Messfehler erkennen und dann
> für das reale Ergebnis eliminieren müssen, **damit break even stimmt**."*

**Deshalb müssen die Messebenen compile-time ausbaubar sein** — nicht als Komfort, sondern weil die
**Differenz zwischen „mit Fühler" und „ohne Fühler" der Messfehler selbst ist**. Der **Planer**
kompiliert die sechs Varianten; das ist der Grund, warum er als eigene Binary vom CEB getrennt wurde.

> Owner am 08.08., als er den Ist-Stand hörte: *„Ich bin schockiert das zu hören. Schließlich hatten wir
> nicht um sonst den Planer als Binary getrennt, um die CEBs nach den Anforderungen der Mess-Achsen zu
> bauen … **Wird nicht je Mess-Stufe mal mit und mal ohne Mess-Einrichtung gebaut, dann klappt es
> nicht.**"*

### 2.4 Record-and-Replay — wie gemessen wird, wenn eine Stufe fehlt

Die offene Folgefrage („wie holt man Ergebnisse, wenn die Macro-Akkumulation ausgebaut ist?") hat der
Owner selbst beantwortet:

> *„Jede Achse muss dazu in einem **original festgestellten RAM Zustandes einer Gattung** auf den **exakt
> festgehaltenen replay Achsen-Aufruf mit warmem Cache** einzeln durchgemessen werden. **Zwischen den 3
> Mess-Ebenen existieren Verträge**, die beinhalten, dass stets der **Aufruf, Zeitpunkt und der Zustand**
> des durchzumessenden Bestandteils als **snapshot** nach jedem Durchführungs-Zeitpunkt eingefangen
> werden muss, um ihn **per replay über jede einzelne Komponente zu wiederholen**, um nachträglich die
> **tatsächlichen Messergebnisse ohne Messfehler** zusammenzutragen."*

**Das ist Record-and-Replay als Mess-Vertrag.** Statt alles gleichzeitig zu messen — wobei sich die
Sonden gegenseitig stören —, wird `(Aufruf, Zeitpunkt, Zustand)` aufgezeichnet und **einzeln
nachgespielt**, mit warmem Cache im originalen RAM-Zustand.

### 2.5 Release ist eine Rekonstruktions-Anfrage, kein Bau-Modus

> *„Der **release Modus nach compare** ist nichts anderes als die **lazy Prüfung der gesamten Kette** und
> compile Ausgabe der Tier-Binary oder Hybrid-Tier-Binary-Kombination oder **Neu-Kompilation nur dieser
> exakten binaries, wenn die binaries zum Platz sparen gelöscht wurden während wir die Messwerte behalten
> haben** (Wenn wir die Messwerte haben, kennen wir ja die Eigenschaften der Binary dazu und müssen diese
> nicht mehr vorhalten und können auf Anfrage gezielt nachbauen). Release ist also eine **Anfrage an eine
> dokumentierte compare Bibliothek der Messwerte**, um je Ziel-Architektur der System-Achse die perfekte
> Tier-Binary oder Hybrid-Tier-Binary zu **rekonstruieren und auszuliefern** und bei Bedarf **nur mit
> Wall-clock time und ohne Messfühler** kompiliert erneut in ihrer Gesamt-Geschwindigkeit durchzumessen
> **gegen die Prüfdock google Tests als Verifikation dafür, dass sie funktioniert**."*

**Die Konsequenz, die alles entlastet: Binaries müssen nicht aufbewahrt werden.** Die Messwerte tragen
die Eigenschaften; die Binary ist daraus **gezielt nachbaubar**. Damit ist die Platzfrage keine
Platzfrage mehr, und `measure ⊂ compare ⊂ release` bekommt seine dritte Stufe eine echte Semantik.

### 2.6 Break-Even: kubischer B-Spline, als String serialisierbar

> *„Die Heuristik von Break even nimmt sich alle verfügbaren Messwerte und
> Zeitpunkt-Parameter-Checkpoints und interpoliert diese mit einer **möglichst scharfen Spline B=3** in
> eine mathematische Funktion, die **als String gespeichert und wieder geparst und interpretiert** werden
> kann … **Der erste Parameter-Messwert bildet im Ausgangszustand bei 0 die Basis.**"*

Berechnet wird er **dreimal querschneidend**: über die **Achsen-Ebene** (Micro) · über die
**Funktions-Ebene** (Macro, „Break-Even über Funktion") · über die **Gesamt-Ebene** (combined, die beste
Binary über einen gemischten Last-Ablauf) — und **je isolierter Achsen-Permutation, also je
Baum-Knoten-Tiefe**.

### 2.7 Das Flattern ist das Signal, nicht die Störung

Auf meine Hysterese-Frage:

> *„Für den ersten Schritt … die **durchschnittlich beste** Tier-Binary zu finden flattert der Schalter
> offiziell erstmal nicht, weil wir für das direkte Erkennen der perfekten Tier-Binary die
> **Parameter-Gesamtverläufe mitteln**. **ABER: für die Hybrid-Tier-Binary sind EXAKT DIESE flatternden
> Bereiche der besten Tier-Binary in einem Bereich zu erkennen** und die Synthetisierten Funktionen
> müssen anhand der erkannten Eingangslast ihr Verhalten so anpassen, dass die beste Binary für diese
> Situation geladen und durch den Hybriden orchestriert wird."*

**Stufe 1 mittelt (kein Flattern), Stufe 2 sucht das Flattern gezielt.** Wo die beste Binary wechselt,
liegt die Last-Region, in der der Hybrid arbeitet. Keine Hysterese — **Bereichs-Erkennung**.

### 2.8 Paper = ein Experiment-XML

> *„ein Paper genau ein Experiment-XML … welches wiederverwendbar bereit liegt. Die **compile time stellt
> aus dem gesplitteten Entwurfsmuster die original binary des Paper-Experimentes wieder her** … **Es gibt
> keine Kandidaten**, sondern nur das Ermitteln der XML Einstellung um ein Paper-Experiment zu
> reproduzieren und dann gibt es den **Nachweis des PRT-ART Prüflings und dessen Einsetzung in die
> Achsen**."*

Dazu die Mengen-Doktrin: **„Rechne diese bitte NIE mehr pauschal nach"** — stattdessen
`cache_engine --check-size "FILE"`, das auf der Zielmaschine läuft, per Hardware-Erkennung die
Systemeigenschaften bestimmt, die CEB **vorsorglich baut**, wenn sie fehlt, und **auf der CEB rechnet**.

---

## 3. DIE BEFUNDE — was am Objekt steht

### 3.1 Der Paper-Auftrag ist zu zwei Dritteln erfüllt, und der Faden riss an einem Datum

Der Auftrag existiert **seit drei Monaten** in vier Etappen (13./14.05., 27.05., 08.06., 20.07.).
Schon am **13./14.05.** verbatim: *„sodass die … Algorithmusbestandteile durch die
**Permutationsbeschreibung wiederherstellbar** sind."*

**Gebaut:** 33 SOTA-Profile `P01`–`P33` **lückenlos** · 23 Allokator-Profile · 21 Lastprofile ·
21 `PAPER_REFERENCES.md` · vendorierter Original-Code in 17 `paper_*`-Bäumen.

**Es fehlt genau der letzte Schritt:** kein **Experiment**-XML je Paper (die sota-Akten tragen
`comdare_algorithm_profile`, der Planer-Eingang heißt `comdare_experiment`) · `profile_ref` wird
**geparst und nie dereferenziert** · `drop_tier_level` zieht die Paper-Ebene ab · zwei Vokabulare ohne
Naht (`SPARSE_NODE4_ART` gegen `node4`).

**Der Faden riss am 20.07.**, als der Ledger den Posten als *„post-v3"* buchte — obwohl das GO stand.

### 3.2 Die 6 CEBs: die Doktrin erlaubt sie, der Code kann sie nicht

**Mein erster Alarm war überzogen und ist zurückgenommen.** Ich hatte gemeldet, das golden-Profil nenne
die Trennung „die F-3-Regression". Der Kommentar sagt aber vollständig:

> *„Die früheren 3 separaten Ein-Tool-Combos (3 CEB-Lanen) waren die F-3-Regression; **getrennt/Teilmengen
> bleibt XML-Recht** (s. `m3_smoke_coverage`)."*

Die Regression war, dass drei Lanen als **Default** liefen — **nicht** die Trennbarkeit.

**Der echte Blocker liegt tiefer, und der Code benennt ihn selbst** (`mess_achsen_naht.hpp:81`):

> *„**EHRLICHE GRENZE DIESER SCHEIBE — macro UND micro SIND HEUTE NICHT TRENNBAR.** G2 und G3 teilen sich
> EIN Gate. Es gibt im gesamten `anatomy/`-Baum kein drittes Makro … Ein solches Gate hier zu ERFINDEN
> hieße, Semantik zu behaupten, die der Code nicht trägt."*
> *„Das Herauslösen von G3 aus dem STATISTICS-Gate in ein eigenes Makro ist ein **EIGENES FOLGEPAKET** (es
> berührt `abi_adapter.hpp` im Hot-Path und die A8-S4-Präprozessor-Wache …)."*

**Das ist kein Versäumnis, sondern ein bewusst benannter Rückstand mit benanntem Folgepaket.**
Heute sind **maximal 2** der 6 Varianten herstellbar; `wallclock` ist zudem gar nicht ausbaubar, weil G1
von jedem Tooling gezogen wird. **Die Differenz-Arithmetik existiert nirgends** (Nullbefund über drei
Muster, Gegenprobe `measurement_combo` = 27 Dateien — die Suche greift).

### 3.3 Break-Even: drei Code-Orte, vier fehlende Eigenschaften

Nicht zwei Implementierungen, sondern **drei** (`heuristik/`, `builder/curve_fit/`,
`builder/best_binary_selector/`) — und `curve_fit` trägt bereits eine **Kopie** der
Fritsch-Carlson-Mathematik. Nullbefunde je mit Gegenprobe: **B-Spline** (6 Muster → 0) ·
**String-Serialisierung** (8 Muster → 0) · **Basis bei 0** · und der schärfste:

**Beide haben `x = Last`, nicht `x = Zeit`.** Die Owner-Kurve läuft über die **Zeitachse eines Laufs**
(aus den Checkpoints), die vorhandenen über die **Lastachse über Läufe hinweg**. **Beide werden
gebraucht — es sind zwei verschiedene Objekte.** Und die Datenquelle fehlt ohnehin: die CSV trägt weder
Checkpoint-Spalte noch Zeitstempel. **Erst Checkpoints, dann Spline.**

### 3.4 `--check-size`: die Prüfer fanden etwas Besseres als die Entwürfe

Alle drei Entwürfe fielen an derselben Stelle:

> *„Planer und CEB linken **dieselbe Bibliothek**. Alles, was ein Entwurf ‚auf der CEB' rechnen lassen
> wollte — CPU-Threads, Cache-Line, freier Platz — sieht der Planer auf derselben Maschine **selbst**.
> Eine Prozessgrenze, über die nur solche Werte reisen, ist eine **leere Naht**."*

**Die Auflösung:** der Planer rechnet die **Größe** (rein aus der XML-Freigabe), die CEB liefert die
**Dauer** — weil die **Instrumentierung in sie einkompiliert** ist und eine `[all]`-CEB langsamer misst
als eine `[wallclock]`-CEB. **Und weil es sechs Varianten gibt, liefert die Befragung nebenbei die erste
Messung des Mess-Overheads.** `--check-size` und die Messfehler-Elimination sind **dasselbe Werkzeug**.

### 3.5 Phase 3 ist nicht fertig — und die Buchführung war optimistisch

**6 von 16 Posten belegt erledigt, 2 teilweise, 8 offen oder nie begonnen.** Von den zwölf Landungen des
07.08. berührten **nur zwei** die Fahrplan-Phase-3-Zeile. Härtester Einzelbefund:
**A9-S3/S4/S5 nie begonnen** — der xlsx-Weg ist **reiner Vendor ohne einen einzigen Schreiber**, obwohl
xlsx **dreimal** als Mess-Default gesetzt wurde.

---

## 4. MEINE FEHLER — sie bilden ein Muster

Das Gesamt-Dossier über sechs Kontext-Fenster (360 Owner-Nachrichten, 79 Frage-Antwort-Paare) fand
**vierzehn** Fälle, in denen ich gefragt habe, obwohl der Owner es beantwortet hatte. Der gemeinsame
Nenner ist **nicht** die Frage:

> *„Alle 14 Fälle haben dieselbe Ursache: der Lead hat den Session-Log/Plan nicht gelesen, bevor er
> gefragt hat, und hat statt einer Recherche eine **Empfehlung** vorgelegt. In vier Fällen war die
> Empfehlung sachlich falsch. **Die Kosten sind nicht die Frage, sondern die Empfehlung: der Owner musste
> jedes Mal nicht nur antworten, sondern korrigieren.**"*

**Ein Werkzeugfehler erklärt einen Teil davon.** Meine Memory führte die Regel *„`queued_command.prompt`
existiert seit 06.08. nicht mehr"*. **Falsch** — nachgezählt in der laufenden Session:
`queued_command` **252×**, `queue-operation` **1083×**. Rund **40 Owner-Nachrichten** kamen über diesen
Pfad, darunter *„Es ist IMMER alles geplant"*. **Wer nur den anderen Pfad liest, sieht den Owner
schweigen, wo er gesprochen hat.** Korrigiert und als eigene Memory gebucht.

**Weitere eigene Fehler dieser Session, alle am Objekt gefangen:**
- **Pauschal gerechnet** statt ein Werkzeug zu bauen — fünf Mengen-Schätzungen, aus denen ich
  Frist-Aussagen ableitete. Owner: *„Rechne diese bitte NIE mehr pauschal nach."*
- **Die halbe Heilung:** die cppcheck-Suppression stand vor dem `#if` statt vor dem `#error`, **und**
  cppcheck meldet nur den *ersten* `preprocessorErrorDirective` je Datei — eine Heilung nur der ersten
  Stelle hätte die zweite nachrücken lassen.
- **Dreimal einen stummen Köder gebaut** (K13): eine Gegenprobe zählt erst, wenn der eingebaute Fehler
  **nachweislich direkt** gemeldet wird. Reihenfolge: Köder gegen das **Werkzeug**, dann gegen die
  **Wache**.
- **`rc=$?` nach einer Pipe** gemessen — das ist der Code des letzten Glieds.
- **Zwei Agenten auf einen Checkout gesetzt**, der 14 Commits zurücklag.
- **Ein Vault-Klartextwert ins Transkript**, weil meine Maskierung auf Zeilenenden zielte und der Vault
  eine Markdown-**Tabelle** ist. An Infra gemeldet.
- **Einen Fehlalarm fast weitergegeben** (Namenskollision im CMake) — es war ein dokumentiertes Design.
- **`git describe`-Suffix als Datum gelesen** — `pre-delegation-sweep-20260603-…` sah wie ein Juni-Stand
  aus, der Commit war von **heute 11:53**.
- **Mein eigener `pgrep` fand sich selbst** und ich hätte fast einen Bau als blockiert gemeldet.

**Und zweimal war der Owner derjenige, der auf eine Antwort wartete:** *„Was meinst du mit
mehrelementige Front?"* und *„(das ist doch jetzt unter der Container Gattung oder???)"* — beide
inzwischen beantwortet (mehrelementige Pareto-Front = mehrere nicht-dominierte Binaries; `flat_hash_map`
gehört unter die Container-Gattung, der Owner hatte recht).

---

## 5. WAS OFFEN IST

### Beim Owner
1. **Bau-Menge:** 19.07. *„bauen alles, messen mit der 320er"* gegen 07.08. *„nur die 320er die wir auch
   messen"*. Die Nachricht vom 08.08. stützt die erste Lesart. **`--check-size` kann nicht gebaut werden,
   solange unklar ist, welche Menge es ausrechnet.**
2. **A8-S2 / Ebenen-Etikettierung:** trägt die Mess-Zeile ihre Ebene mit? Ohne diese Spalte kann die
   Auswertung die fünf Ebenen nicht trennen — und die Differenzbildung über die CEB-Varianten braucht sie.
   Nachrüsten nach der Messung wäre ein Datenbruch.

### Als Bau eingereiht (GO liegt vor)
- **SF-1 Schichtschnitt** — läuft. Owner: *„Das Fenster ist jetzt, bevor es teuer wird."*
- **G3 aus dem STATISTICS-Gate lösen** — Vorbedingung für die 6 CEBs, vom Code selbst als Folgepaket
  benannt.
- **Paper-XMLs** (Stufe 3) · **`--check-size`** · **compare/D2** · **LaTeX-Anlage in die Abgabe** ·
  **Textbausteine auch in Evaluation/Auswertung** (mit dem Betreuer abgesprochen) ·
  **L3-Asymmetrie-Messung** (Pflicht) · **Record-and-Replay-Verträge** · **B-Spline mit Serialisierung**.

### Entschieden und erledigt
NFS-Export bleibt offen (**alle Maschinen bedienen die Lagerhaltung, Sync per File, V60-Runner sollen
mounten**) · LGPL-Frage erledigt (**Habich hat zur Weiterverwendung freigegeben**) · `mmx` bleibt
deklariert (**RISC-V im Messpark**) · `m64` statt `x64` als Medien-Basis · Baum-Pfad wird **durch den
Planer-Interpreter abgelöst** (beide Funktionen fallen).

---

## 6. WIEDERANLAUF

1. **Dieses Dokument**, Abschnitt 2 (die Architektur) und 5 (was offen ist).
2. `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`, Nachträge **08.08.** — dort stehen alle
   Owner-KERNe im Wortlaut.
3. `docs/sessions/20260808-GESAMT-DOSSIER-owner-fragen-und-antworten-sechs-kontexte.md` — 79
   Frage-Antwort-Paare, die Direktiven nach Reichweite, und die vierzehn doppelt gestellten Fragen.
4. `docs/plaene/20260808-GESAMTBILD-vergessene-arbeit-und-neuer-wellenplan.md` — Phasen 2/3/4 Posten für
   Posten am Objekt, plus Wellenplan.
5. `docs/plaene/20260808-BERICHT-check-size-messkette-break-even.md` — der Entwurf und die
   Break-Even-Gegenüberstellung.
6. `docs/plaene/20260808-VORLAGE-latex-anlage-xml-gesteuert.md` — mit dem Vorbehalt, dass sie **vor** der
   Owner-Präzisierung entstand: sie beschreibt Rohdaten-Ausgabe, gemeint ist **Auswertung**.

**Die Regel, die über allem steht** (Owner, 07.08. nachts): *„**Es ist IMMER alles geplant** und du
leidest bei nicht auflösbaren Fragen an einer ultracode explore Gedächtnislücke, die du selbst
recherchierst."* Erst suchen — 4 bis 6 Wochen, beide Transkript-Pfade — dann fragen. Und wenn gefragt
wird: **die Frage stellen, nicht die Empfehlung.**
