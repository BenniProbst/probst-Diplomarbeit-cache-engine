# GESAMT-DOSSIER 06.08.2026 — DIE ARCHITEKTUR, DIE BEFUNDE UND DIE SECHS FREITAGE

*Konsolidierung aus zehn Erzeugnissen, 86 Wellen-Journalen und dem Verbatim-Transkript einer Session.*

**Erstellt:** 2026-08-07, 00:20–01:37 Z (Fenster-Ende = letzter Inhalts-`mtime` der Datei, `stat`; die frueher genannte „02:10 Z" lag in der Zukunft)
**Gemessen gegen:** ce `origin/development` = `c4c04315` · ce `origin/main` = `2b5ecd29` · super `origin/development` = `5a98036d` · super `origin/main` = `71591a24` · thesis `origin/main` = `origin/development` = `19e15920`
**Alle Suchlaeufe:** `/usr/bin/grep`, durchgaengig `-i`, Verzeichnisse als **Positivliste** (nie `grep -v "/build"` — das frisst `/builder/`). Jede Null traegt Nenner und Gegenprobe.

---

## VORWORT — was diese Session war und wie dieses Werk zu lesen ist

### Der Anlass

Am 06.08.2026 war ein CI-Job rot. `pmc:intel` lieferte auf der Intel-Produktionsmaschine keine Hardware-Zaehler, waehrend die AMD-Lane grune Werte schrieb. Ein einzelner roter Job, spaet am Abend, zwei Tage vor dem, was alle fuer die Abgabe hielten.

Was daraus wurde, ist die einzige zusammenhaengende Darstellung der Mess-Kette, die es in diesem Projekt gibt: von der Frage, **welche Hardware-Zaehler-Domaene eine Maschine hat**, bis zu der Frage, **welche Binary ein Anwender am Ende bekommt**. Zwischen 21:45 und 23:48 Uhr — in etwas ueber zwei Stunden — hat der Owner zwoelf Praezisierungen gegeben, die das gesamte Bauwerk von der PMU-Domaene bis zum Hybrid-Schaltungs-Adapter durchdefinieren. Drei davon korrigieren Lesarten des Leads, die falsch waren und Bauarbeit im Umfang von 34,4 Stunden plus dem Verlust aller bis dahin erhobenen Messdaten ausgeloest haetten.

### Warum die Session dicht war — und warum sie es nicht haette sein muessen

Der Owner-Auftrag, aus dem der Ledger-Nachtrag `abend-4` entstand, sagt es selbst, verbatim:

> *„Bitte schreibe eine exzessive reiche Zwischenstandsdoku mit ALLEN in diesem Kontext geklaerten Architektur-Praezisierungen und schreibe diese detailliert in das Ledger als Konsolidierung. Wir haben bestimmt die letzten 10 Turns nicht ausreichend dokumentiert und muessen das im Ledger nachholen, weil wir hier alles kurz im Zusammenhang erklaeren konnten — **in der Dichte einmalig**."*

Die Dichte ist real. Sie ist aber **nicht** das Verdienst des Abends, sondern seine Rechnung. Der Grund, warum zwoelf Praezisierungen an einem Abend noetig waren, steht in einem Owner-Satz vom 22:22:43Z, verbatim:

> **„Ich sag es dir ja: Gedaechtnisluecken, es ist alles geplant und du musst bitte mit explore lesen"**

Und fuenf Minuten spaeter, 22:27:36Z, verbatim:

> **„Mal eine andere Frage: Die Diplomarbeit ist ja die Anforderung an den Code, hast du da mal rein gelesen? Dort ist ja alles definiert, was im Ledger als TODO deklariert sein muss."**

Die Antwort auf beide Fragen war **nein**. Zwei Primaerquellen lagen den ganzen Tag ungeoeffnet:

1. **`docs/termine/`** — 11 Betreuer-Termine, **309 Dateien**. Dort steht seit dem **09.04.2026** die Hybrid-Regel woertlich: *„P- und E-Cores werden nicht zusammenaggregiert. perf dokumentiert dafuer getrennte PMUs `cpu_core` und `cpu_atom`."* Dort steht die Risikozeile *„Hybrid-CPU-Zaehler werden falsch aggregiert"* mit ihrer Gegenmassnahme. Und dort steht ein **fertiger Baustein-Entwurf** `HybridCorePinning` mit `pin_thread(core_class:{Performance|Efficient})` und `measure_per_class() -> {p_core, e_core}`.
2. **Die Thesis als Spezifikation** — nicht als Bau-Artefakt, das kompiliert werden muss, sondern als der Text, der sagt, **was gebaut werden muss**.

Der rote `pmc:intel` war damit **keine Panne, sondern die vorhergesagte Risikorealisierung**. Der Plan hatte die Fehlerklasse vier Monate vorher benannt, den Baustein gezeichnet und die Gegenmassnahme aufgeschrieben. Gebaut wurde er nie. Der Preis, den der Lead selbst beziffert hat, verbatim:

> *„Ein roter CI-Job, drei falsche Ursachenvermutungen, eine beinahe ausgefuehrte Cluster-Rechte-Aenderung — waehrend die Antwort seit dem 12.04. dort stand."*

Das ist die ehrliche Fassung dieses Werks: **die dichteste Klaerung dieses Strangs seit seinem Bestehen war noetig, weil niemand nachgeschlagen hatte.**

### Was an diesem Tag sonst noch geschah

Der Architektur-Abend war das Ende eines Tages, der ohnehin der dichteste dieser Arbeit war. Gemessen (`git log --since 06.08. 00:00`, auf `development`, mit Merges):

| Repo | Commits | Merges | Diffstat |
|---|---:|---:|---|
| **super** | 175 | 4 | 716 Dateien, +243.985 / −131 |
| **ce** | 90 | 16 | 145 Dateien, ~+29.450 / −742 |
| **thesis** | 6 | 0 | — |

Neun Bau-Bloecke landeten (Kapitel IV.1), vier Wachen bissen zum ersten Mal, ein CI-Tripwire lief nachweislich **drei Wochen lang gar nicht** und wurde geheilt, drei stille Nullen wurden gefunden, und elf Mal hat ein beauftragter Agent die **Praemisse** seines Auftrags zurueckgewiesen statt ihn auszufuehren — in keinem dieser elf Faelle war die Zurueckweisung falsch.

### Wie dieses Werk zu lesen ist

Es ist eine **Konsolidierung, kein elftes Analyse-Dokument**. Die Einzelbefunde stehen bereits in zehn Dokumenten; die Landkarte im Anhang sagt, welches Detail wo liegt. Was hier neu ist, ist der **Zusammenhang** — und der stand nirgends.

- **Kapitel I** ist die Architektur: die Kette Planer → CEB → [Hybrid] → Tier, die drei Achsen-Arten und ihre Stufigkeit, PMC als Menge statt als Einrichtung, die Wallclock auf drei Ebenen. **Wer nur ein Kapitel liest, liest dieses.**
- **Kapitel II** ist die Auswertung: von der Messung ueber die Funktions-Synthese zu den Schnitt-Kurven und damit zu der Binary, die der Hybrid-Adapter waehlt. Break-Even ist ein **Kipppunkt, kein Optimum** — und die operative Form der Hypothese H2 aus Termin 1.
- **Kapitel III** ist die Fehlerlehre. Es ist das unangenehmste und vielleicht nuetzlichste Kapitel: alle Fehler dieses Tages haben **eine** Gestalt, und diese Gestalt hat eine **Bauform**. Die Gestalt heisst *eine korrekte Messung, die die falsche Frage beantwortet*. Die Bauform heisst *stiller Rueckfall*, und der Owner hat sie verboten.
- **Kapitel IV** ist die Bilanz: was steht, was fehlt, in welcher Reihenfolge gebaut werden muss und **warum die Reihenfolge keine Geschmacksfrage ist**. Der Schluessel ist eine gemessene Null: es existieren heute **0 `.fingerprint`-Sidecars**. Solange das so ist, kostet jede Identitaets-Entscheidung nichts.
- **Kapitel V** ist die Abgabe: die Thesis als Anforderung, zwei Falschaussagen darin, und die sechs Freitage bis zum 15.09.2026 — fuer die es **drei verschiedene Planungen** gibt, die einander an einer Stelle widersprechen.
- **Kapitel VI** ist die Nachschlage-Seite: die zwoelf Owner-KERNe verbatim und nummeriert.
- Der **Anhang** ist die Dokumenten-Landkarte.

### Drei Lesehilfen, ohne die einzelne Zahlen missverstanden werden

**Erstens: jede Zahl traegt ihr Erhebungsdatum, und das ist kein Zierrat.** Der Ledger wuchs an diesem Tag von 4975 ueber 6735 auf 7248 Zeilen und existierte zeitweise in zwei divergierenden Fassungen. Jede Ledger-Zeilennummer in diesem Werk ist eine Momentaufnahme; wer eine Zeile nachschlaegt, prueft sie am Text, nicht an der Nummer. Der Auftrag zu diesem Dossier selbst nennt Staende (ce `2b5ecd29` auf dev **und** main, super `33edd4cd`), die bei seiner Erteilung richtig und beim Schreiben ueberholt waren.

**Zweitens: die drei Widersprueche zwischen den Kapiteln sind stehen geblieben.** Sie sind nicht glattgebuegelt, sondern in **Abschnitt 0** dieses Werks als eigene Befunde gefuehrt, mit Nachmessung. Zwei von ihnen sind lehrreicher als das, was sie widerlegen.

**Drittens: `grep` immer mit `-i`.** Der Owner schreibt Fachbegriffe in VERSALIEN. Eine case-sensitive Suche hat an diesem Tag real eine falsche Null erzeugt — in einem Bericht, der den gesuchten Satz woertlich zitierte und im selben Dokument meldete, es gebe ihn nicht.

### Der Satz, auf den alles hinauslaeuft

Er stammt vom Owner, 22:59:15Z, und er ist als **Konstruktionsauftrag** zu lesen, nicht als Ermahnung:

> **„Stiller Rueckfall geht fuer uns nicht: Regressionen oder Fehler gehoeren angezeigt, das ist ein weiterer Fall fuer das Anzeigen von error"**

Er hat ihn ueber die Fehlerausgabe eines Messprogramms gesagt. Er gilt fuer eine Wache, fuer eine CSV-Zelle, fuer einen CI-Job und fuer ein Manuskript wortgleich.

---

## INHALT

- [VORWORT](#vorwort--was-diese-session-war-und-wie-dieses-werk-zu-lesen-ist)
- [ABSCHNITT 0 — DIE DREI WIDERSPRUECHE ZWISCHEN DEN KAPITELN](#abschnitt-0--die-drei-widersprueche-zwischen-den-kapiteln)

**[KAPITEL I — DIE ARCHITEKTUR, wie sie an diesem Abend geklaert wurde](#kapitel-i--die-architektur-wie-sie-an-diesem-abend-geklaert-wurde)**
- [I.0 Vorbemerkung und Erhebungsanker](#i0-vorbemerkung-und-erhebungsanker)
- [I.1 Die Kette in einem Bild](#i1-die-kette-in-einem-bild)
- [I.2 Die Schlangen-Mechanik](#i2-die-schlangen-mechanik)
- [I.3 Die drei Typen — und warum genau einer dreiphasig ist](#i3-die-drei-typen--und-warum-genau-einer-dreiphasig-ist)
- [I.4 PMC ist eine MENGE, keine Einrichtung](#i4-pmc-ist-eine-menge-keine-einrichtung)
- [I.5 Die P/E-Trennung ist eine PERMUTATION, kein zweiter Bau](#i5-die-pe-trennung-ist-eine-permutation-kein-zweiter-bau)
- [I.6 Wenn nicht gepinnt werden kann — und die Schwere-Leiter](#i6-wenn-nicht-gepinnt-werden-kann--und-die-schwere-leiter)
- [I.7 Wallclock auf drei Ebenen — und ihre Verortung](#i7-wallclock-auf-drei-ebenen--und-ihre-verortung)
- [I.8 Das Ende der Kette: wozu die vierte Stufe existiert](#i8-das-ende-der-kette-wozu-die-vierte-stufe-existiert)
- [I.9 Bilanz: was von dieser Architektur heute steht](#i9-bilanz-was-von-dieser-architektur-heute-steht)
- [I.10 Was offen ist — und nur der Owner entscheiden kann](#i10-was-offen-ist--und-nur-der-owner-entscheiden-kann)

**[KAPITEL II — VON DER MESSUNG ZUR BINARY-WAHL](#kapitel-ii--von-der-messung-zur-binary-wahl)**
- [II.1 Vier Owner-Nachrichten in einundvierzig Minuten](#ii1-vier-owner-nachrichten-in-einundvierzig-minuten)
- [II.2 Die Kette, Glied fuer Glied](#ii2-die-kette-glied-fuer-glied)
- [II.3 Break-Even ist ein Kipppunkt, kein Optimum](#ii3-break-even-ist-ein-kipppunkt-kein-optimum)
- [II.4 Break-Even ist die operative Form von H2](#ii4-break-even-ist-die-operative-form-von-h2)
- [II.5 Die drei Benchmark-Ebenen und was jede beitraegt](#ii5-die-drei-benchmark-ebenen-und-was-jede-beitraegt)
- [II.6 Die Arbeitsteilung — und was O-100 wirklich korrigiert](#ii6-die-arbeitsteilung--und-was-o-100-wirklich-korrigiert)
- [II.7 Die Fritsch-Carlson-Wahl und warum sie noetig ist](#ii7-die-fritsch-carlson-wahl-und-warum-sie-noetig-ist)
- [II.8 Der Ist-Stand — mit Nennern](#ii8-der-ist-stand--mit-nennern)
- [II.9 Was in diesem Kapitel offen ist](#ii9-was-in-diesem-kapitel-offen-ist--und-wem-es-gehoert)
- [II.10 Zusammenfassung in fuenf Saetzen](#ii10-zusammenfassung-in-fuenf-saetzen)

**[KAPITEL III — DIE FEHLER UND WAS SIE LEHREN](#kapitel-iii--die-fehler-und-was-sie-lehren)**
- [III.0 Vorbemerkung](#iii0-vorbemerkung-was-dieses-kapitel-ist)
- [III.1 Die Gestalt: eine korrekte Messung, die die falsche Frage beantwortet](#iii1-die-gestalt-eine-korrekte-messung-die-die-falsche-frage-beantwortet)
- [III.2 Die drei stillen Nullen](#iii2-die-drei-stillen-nullen)
- [III.3 Die vier Auspraegungen des falschen Ausschnitts](#iii3-die-vier-auspraegungen-des-falschen-ausschnitts)
- [III.4 Die drei widerlegten Lesarten](#iii4-die-drei-widerlegten-lesarten)
- [III.5 Die Fehler, die keine Messfehler waren](#iii5-die-fehler-die-keine-messfehler-waren)
- [III.6 Die Gegenseite I: Wachen, die gebissen haben](#iii6-die-gegenseite-i-wachen-die-gebissen-haben)
- [III.7 Die Gegenseite II: Selbstkorrekturen und zurueckgewiesene Praemissen](#iii7-die-gegenseite-ii-selbstkorrekturen-und-zurueckgewiesene-praemissen)
- [III.8 Die Gegenseite III: der Owner als Pruefer](#iii8-die-gegenseite-iii-der-owner-als-pruefer)
- [III.9 Die Schwere-Leiter als Ergebnis dieser Erfahrung](#iii9-die-schwere-leiter-als-ergebnis-dieser-erfahrung)
- [III.10 Die Meta-Lehre: Merksaetze tragen nicht, Werkzeuge tragen](#iii10-die-meta-lehre-merksaetze-tragen-nicht-werkzeuge-tragen)
- [III.11 Schlussbemerkung](#iii11-schlussbemerkung)

**[KAPITEL IV — WAS STEHT, WAS FEHLT](#kapitel-iv--was-steht-was-fehlt)**
- [IV.0 Der Stand, gegen den alles zu messen ist](#iv0-der-stand-gegen-den-alles-zu-messen-ist)
- [IV.1 Was heute gelandet ist](#iv1-was-heute-gelandet-ist)
- [IV.2 Was gebaut und nicht gelandet ist](#iv2-was-gebaut-und-nicht-gelandet-ist)
- [IV.3 Die Bau-Reihenfolge B-1 .. B-10](#iv3-die-bau-reihenfolge-b-1--b-10)
- [IV.4 Was VOR der Messung stehen muss — und warum](#iv4-was-vor-der-messung-stehen-muss--und-warum)
- [IV.5 Die offenen Posten, nach Dringlichkeit](#iv5-die-offenen-posten-nach-dringlichkeit)
- [IV.6 Die Entlastungen — was NICHT gebaut werden muss](#iv6-die-entlastungen--was-nicht-gebaut-werden-muss)
- [IV.7 Was in diesem Kapitel nicht belegt werden kann](#iv7-was-in-diesem-kapitel-nicht-belegt-werden-kann)
- [IV.8 Die eine Zeile, auf die dieses Kapitel hinauslaeuft](#iv8-die-eine-zeile-auf-die-dieses-kapitel-hinauslaeuft)

**[KAPITEL V — DIE ABGABE UND DIE SECHS FREITAGE](#kapitel-v--die-abgabe-und-die-sechs-freitage)**
- [V.1 Die Umkehrung — die Thesis ist die Anforderung](#v1-die-umkehrung--die-thesis-ist-die-anforderung-nicht-das-protokoll)
- [V.2 Die Quellen-Rangfolge](#v2-die-quellen-rangfolge--an-einem-abend-zweimal-gedreht)
- [V.3 Die zwei Falschaussagen](#v3-die-zwei-falschaussagen)
- [V.4 Was an der Voll-Messung haengt](#v4-was-an-der-voll-messung-haengt)
- [V.5 Der Terminplan — sechs Freitage, drei Plaene, ein Widerspruch](#v5-der-terminplan--sechs-freitage-drei-plaene-ein-widerspruch)
- [V.6 Die offenen Owner-Entscheide](#v6-die-offenen-owner-entscheide)
- [V.7 Die Fenster, die sich schliessen](#v7-die-fenster-die-sich-schliessen)

**[KAPITEL VI — DIE ZWOELF KERNE ALS REFERENZ](#kapitel-vi--die-zwoelf-kerne-als-referenz)**

**[ANHANG — DIE DOKUMENTEN-LANDKARTE](#anhang--die-dokumenten-landkarte)**

---

## ABSCHNITT 0 — DIE DREI WIDERSPRUECHE ZWISCHEN DEN KAPITELN

Die fuenf Kapitel wurden von verschiedenen Erhebern in derselben Nacht geschrieben, jedes mit eigener Messung am Objekt. An drei Stellen sagen zwei Kapitel Verschiedenes ueber dieselbe Sache. **Das ist nicht glattgebuegelt worden.** Zwei der drei sind lehrreicher als das, was sie widerlegen — sie sind Instanzen genau der Fehlerklassen, die Kapitel III beschreibt, angewandt auf dieses Werk selbst.

Alle drei sind am 07.08.2026 zwischen 00:45 und 01:10 Z nachgemessen.

### W-1 · Der Anhang-A-Eintragszaehler: 28 gegen 30

| Kapitel | Aussage |
|---|---|
| **IV** (§IV.1.2 thesis-Block, §IV.5.5) | *„jeder der **28** Anhang-A-Eintraege traegt seinen EIGENEN Ersatztext"* · *„**28** Eintraege, 0 existierende Zieldateien"* |
| **V** (§V.6.6) | *„Gemessen an thesis `19e1592`: **30** `InputIfFileExists` je Sprache, 0 stumme `}{}{}`"* |

**Nachmessung, thesis `19e15920`, `anhang/de/A_measurements.tex` und `anhang/en/A_measurements.tex`:**

```
/usr/bin/grep -c -i "InputIfFileExists{anhang"  ->  28   (DE)   28   (EN)
/usr/bin/grep -c -i "InputIfFileExists"         ->  30   (DE)   30   (EN)
/usr/bin/grep -c -i '}{}{}'                     ->   0   (DE)    0   (EN)
```

Die Differenz sind **zwei Kommentarzeilen**, die die Doktrin selbst beschreiben:

```
:71  %  \InputIfFileExists: kompiliert auch VOR dem ersten Messlauf sauber.
:78  %  JEDER \InputIfFileExists-Eintrag traegt seinen EIGENEN Ersatztext. Er
```

**Verdikt: beide Kapitel haben korrekt gemessen und Verschiedenes gezaehlt.** 28 ist die Zahl der Eintraege, 30 die Zahl der Vorkommen des Bezeichners. **Keines der beiden Kapitel nennt seine Zaehlmethode.**

**Warum das ein Befund ist und keine Fussnote:** Das ist woertlich Regel **R-19** aus Kapitel III (*„eine Zusage ueber eine Anzahl ist eine Vollstaendigkeitsaussage — ersetze sie durch die Liste"*) und woertlich der Selbstkorrektur-Fall G-8 (*„meine erste Zaehlung lieferte 18 statt 17, weil der Container mitzaehlt … eine Zahl ohne genannte Zaehlmethode ist nicht nachpruefbar"*). Das Dossier hat die Regel aufgeschrieben und sie im selben Werk zweimal verletzt.

**Verbindlich fuer die Abgabe: es sind 28 Eintraege.** Das Task-Register fuehrt dieselbe Zahl (Task #18: *„28/28 Eintraege"*). Wer die 30 zitiert, zitiert einen Bezeichner-Zaehler.

### W-2 · Die Referenz-Staende: vier Kapitel, drei Zahlenpaare, ein Fehl-Label

| Kapitel | ce `development` | super |
|---|---|---|
| **I** | `c4c04315` | dev `5a98036d`, main `71591a24` |
| **II** | `c4c04315` | „super `71591a24`" *(ohne Qualifier)* |
| **III** | **`bba4d90f`** | „super **`origin/development`** = `71591a24`" |
| **IV** | `c4c04315` | dev `5a98036d`, main `71591a24` |
| **V** | `c4c04315` | `5a98036d` |

**Nachmessung:**

```
ce    bba4d90f  2026-08-07T00:06:25Z  Merge b-m1-identitaetsnaht
ce    c4c04315  2026-08-07T00:14:47Z  Merge b-pmc-l3-honest
      git merge-base --is-ancestor bba4d90f c4c04315  ->  JA
      dazwischen genau EINE Landung: 5c102e05

super 71591a24  2026-08-06T23:59:57Z  (origin/main, origin/HEAD, github/main)
super 5a98036d  2026-08-07T00:15:28Z  (origin/development)
      git merge-base --is-ancestor 71591a24 5a98036d  ->  JA
```

**Zwei verschiedene Dinge, und nur eines davon ist ein Fehler.**

**(a) Der ce-Unterschied ist korrekt und traegt eine Sachfolge.** Kapitel III hat um 00:05–00:40 gemessen; die Landung `c4c04315` fiel um 00:14:47 mitten in sein Fenster. Kapitel III fuehrt deshalb die PMC-L3-Ehrlichmachung als **uncommitteten WIP-Patch** (`/home/comdare/backups-workflow/20260806-pause-wip/pmc-l3-honest-WIP.patch`, 18.294 B), Kapitel IV fuehrt dieselbe Arbeit als **gelandet** (§IV.1.1, Block I). **Beide sind richtig, acht Minuten auseinander.** Verbindlich ist der spaetere Stand: **der Posten ist gelandet.**

**(b) Das super-Label in Kapitel III ist falsch.** `71591a24` ist super `origin/**main**`, nicht `origin/development`. Kapitel II nennt dieselbe SHA ohne Qualifier und ist damit nicht falsch, nur unbestimmt.

**Die Klasse, in die das gehoert, ist Regel-Zeile 17** aus Kapitel III: *„Ein Datum an einem Fund ist kein Verfallsdatum, das man ignorieren darf, sondern ein PFLICHTFELD fuer die Nachmessung."* Dieses Werk demonstriert sie an sich selbst — und der Auftragskopf tut es ebenfalls: er nennt ce `2b5ecd29` auf dev **und** main, was zum Zeitpunkt der Erteilung stimmte und zehn Landungen spaeter nicht mehr.

**Und eine dritte, gleichartige Drift derselben Klasse, die derselben Nachmessung auffiel:**

| Gegenstand | Auftragskopf | Kapitel III | gemessen 07.08. |
|---|---:|---:|---:|
| `20260806-DOSSIER-regressionen-checkheft.md` | 1590 Z. | 2486 Z. | **2486** |
| `20260806-UEBERBLICK-workflow-ergebnisse.md` | 677 Z. | 718 Z. | **677** |
| Wellen-Journale | 77 | 79 | **86** |
| `result`-Ereignisse | 250 | — | **265** |
| Journal-Volumen | 3,76 MB | — | **4,29 MB** |

Vier von fuenf Zeilen dieser Tabelle waren zum Zeitpunkt ihrer Niederschrift richtig. **Keine ist es heute.**

### W-3 · Ebene 2 der Mess-Kette: „gebaut" gegen „fehlt"

Das ist der einzige der drei Widersprueche, aus dem ein **Owner-Entscheid** folgt.

| Kapitel | Gegenstand | Verdikt |
|---|---|---|
| **I** (§I.7.3) | Ebene **E2** = *„fuer jeden Funktionsaufruf durch die CEB AUF dem Pruefdock"* | **„gebaut + live, aber nicht auf dem Dock"** — `workload_orchestrator.hpp:65-164` misst 6/6 Op-Arten mit eigenem `clock::now()`-Paar |
| **II** (§II.8.3) | Ebene **MACRO (timed)** = *„Gesamt-Messprofile timed einer Funktion ueber die Schritte und checkpoints ihrer Ausfuehrung"* | **„fehlt"** — `lap_ns` 0 · `split_ns` 0 · `phase_ns` 0 · `stage_ns` 0 · `step_ns` 0 · `marker_ns` 0 · `trace_point`/`tracepoint` 0 |

**Nachmessung, ce `c4c04315`, `git grep` gegen den Ref (nicht gegen den Arbeitsbaum):**

```
clock::now in workload_orchestrator.hpp        ->  12 Treffer     (Kapitel I hat recht)
lap_ns|split_ns|phase_ns|stage_ns|step_ns
  |marker_ns|trace_point|tracepoint  ueber libs ->  0 / 0 / 0 / 0 / 0 / 0 / 0 / 0
Gegenprobe seg_ns ueber libs                    -> 117 Treffer     (die Suche greift)
Pruefdock: Dateien 18, clock::now darin         ->  0              (beide Kapitel bestaetigt)
```

**Beide Messungen halten. Der Widerspruch liegt im Akzeptanzkriterium, und das Akzeptanzkriterium stammt aus zwei Owner-Saetzen, die sechs Minuten und dreiundfuenfzig Sekunden auseinanderliegen:**

- **23:20:06Z** (KERN 11, siehe Kapitel VI): *„Gesamt-Messprofile **timed** einer Funktion **ueber die Schritte und checkpoints ihrer Ausfuehrung** zur Detail-Analyse ueber alle Achsen die sie verwendet hat"* → verlangt **Checkpoints innerhalb** des Aufrufs.
- **23:26:59Z** (KERN 12): *„fuer jeden **Funktionsaufruf** durch die CEB AUF dem Pruefdock ueber die Tier-Binary"* → verlangt **einen Zeitpunkt je Aufruf**.

Kapitel I misst gegen den zweiten Satz und findet die Ebene gebaut. Kapitel II misst gegen den ersten und findet sie leer. **Niemand hat entschieden, welcher der beiden das Abnahmekriterium ist.**

> **Neuer Owner-Entscheid, der aus diesem Werk hervorgeht — gefuehrt als W-3:**
> Ist Ebene 2 erfuellt, wenn ein Zeitpaar den ganzen Gattungs-Funktionsaufruf klammert (dann ist sie **gebaut**, nur am falschen Ort) — oder erst, wenn Checkpoints **innerhalb** des Aufrufs die Zeit je Achse zurechnen (dann **fehlt** sie, und der Posten ist der teuerste der Mess-Kette)?
> **Er ist nicht kosmetisch:** nur die zweite Lesart macht Break-Even auf **Achsen**-Ebene bestimmbar, und genau das verlangt Hypothese H2. Mit der ersten Lesart weiss man, **dass** eine Konfiguration besser ist, nicht **warum**.
> Fenster: **vor Freitag 3 (21.08.)**, weil davon abhaengt, ob Ebene 2 im Abgabe-Messlauf ueberhaupt vorkommt.

**Zwei Nebenbefunde derselben Nachmessung**, die keine Widersprueche sind, aber genannt gehoeren, weil sie beide aus einem **ungenannten Nenner** entstehen:

- Kapitel I: Pruefdock = *„17 Dateien, 3161 Zeilen"*. Gemessen an `c4c04315`: **18 Dateien**.
- Kapitel II: `seg_ns` = *„326"* — **nicht reproduzierbar**. Kapitel-Nachmessung ueber `libs`: **117** (`git grep -n seg_ns 54106bc9 -- libs` = 117 Treffer, korrekt). Ueber den in Kapitel II genannten Suchraum `libs apps tools tests adapters modules` misst dieselbe Methode an ce `54106bc9` **308** Treffer (`git grep -n seg_ns 54106bc9 -- libs apps tools tests adapters modules`), nicht 326; ueber den ganzen Baum sind es 424 Treffer in 65 Dateien. Die `libs`-Zahl traegt ihren Nenner und stimmt; „326" ist an keinem dieser Nenner belegbar und wird hier durch die real gemessene **308** (Nenner: sechs genannte Verzeichnisse, ce `54106bc9`) ersetzt.
- Kapitel I: `perf_event_open` = *„18 Treffer"*; Kapitel V: *„3 Dateien"*. Gemessen an `c4c04315`: **18 Treffer ueber 4 Dateien**. Kapitel V hat gegen den **ausgecheckten Arbeitsbaum** gemessen, und der steht auf `90bca126` (Zweig `b-m2-pmc-invariante`) — also auf einem fremden Wellen-Branch.

> **Der letzte Punkt ist mehr als eine Fussnote.** Checkheft-Posten **N-AD** („beide Hauptklone stehen auf fremden Wellen-Branches") wird in Kapitel III und IV als offene Hygiene-Frage gefuehrt. **Er hat in diesem Werk real zwei divergierende Zahlen erzeugt.** Live gemessen, 07.08. 00:50 Z: super-Hauptklon HEAD `18a0bdf3` auf `b-ci-rueckschrieb-beide-zeiger`, ce-Submodul-Checkout HEAD `90bca126` auf `b-m2-pmc-invariante`. **Wer im Hauptklon misst, misst nicht `development`.** Ab sofort bindend fuer jede Erhebung: `git grep <muster> origin/development -- <pfad>` gegen den **Ref**, nie gegen den Arbeitsbaum.

---

## KAPITEL I — DIE ARCHITEKTUR, wie sie an diesem Abend geklaert wurde

### I.0 Vorbemerkung und Erhebungsanker

Am Abend des 06.08.2026 wurde zwischen 22:02 und 23:28 Uhr die Architektur dieses Systems in einem Zug erklaert — vom Hardware-Zaehler bis zu der Frage, **welche Binary ein Anwender am Ende bekommt**. Sie stand vorher **nirgends im Zusammenhang**: verstreut in Betreuer-Terminen (seit 09.04.), in Ledger-Paragraphen (§30 vom 19.07., §57/§64 vom 20./22.07., Nachtraege mittag-9/-10/-11 vom 05.08.), in Memory-Dateien und in Einzelantworten. Zum Grund dafuer siehe das Vorwort; der Owner-Satz `bak 3319` (22:22:43Z) benennt ihn.

Dieses Kapitel bindet die zwoelf Praezisierungen dieses Abends zusammen und stellt sie **gegen den Code**.

**Erhebungsanker** — jede Objekt-Aussage unten ist am 07.08.2026 zwischen 00:20 und 00:50 Uhr an diesen Staenden gemessen:

| Ref | SHA | Anmerkung |
|---|---|---|
| ce `origin/development` | **`c4c04315`** | zehn Landungen nach dem Stand, den der Auftrag nennt (`2b5ecd29`) |
| ce `origin/main` | `2b5ecd29` | zehn Commits zurueck |
| super `origin/development` | **`5a98036d`** | |
| super `origin/main` | `71591a24` | |
| thesis | `19e15920` | |

#### I.0.1 Ein Befund ueber die Quelle selbst, der vor allem anderen stehen muss

Die kanonische Owner-Extraktion aus dem Session-Transkript filtert `type=="user"` ∧ `promptSource ∈ {typed,queued}` ∧ `origin.kind=="human"`. Ueber die Vollspanne der Session (`5a19728e-…jsonl`, 8.070 Zeilen, 1.524 `user`-Datensaetze) liefert dieser Filter **106 Owner-Nachrichten**.

**Er findet die Architektur-KERNe dieses Kapitels nicht.**

Gemessen: 111 `queue-operation`-Datensaetze mit `operation=="enqueue"` und nicht-technischem Inhalt; davon haben **34 keinerlei Entsprechung in irgendeinem `user`-Datensatz** (Textabgleich ueber die ersten 80 Zeichen gegen den vollstaendigen `user`-Korpus). 14 dieser 34 sind Agenten-Rueckmeldungen, **20 sind Owner-Text**. Und **acht** dieser zwanzig sind genau die KERNe, aus denen dieses Kapitel besteht:

| live | Zeit (Z) | Inhalt |
|---|---|---|
| **7166** | 22:09:48 | der WARN-Kompromiss samt woertlichem Warntext |
| **7219** | 22:17:04 | „Die Pinning Faehigkeit prueft der Planer zur Laufzeit …" |
| **7256** | 22:20:04 | **„der Kopf der schlange ist Laufzeit …"** + „es gibt 3 Typen in diesem System" |
| **7387** | 22:37:57 | die Namensvorgabe `numa_cpu_pin_process_probe` |
| **7601** | 23:10:06 | die Funktions-Definition der Hybrid-Binary |
| **7716 / 7761** | 23:24:34 / 23:26:59 | Wall Clock time auf drei Ebenen; „das dritte Glied" |
| **7776** | 23:28:07 | **die Verortung** der Wallclock je Ebene |
| **7777** | 23:28:59 | Quellen-Rangfolge: „die Diplomarbeit zaehlt und der neuere Stand schlaegt den alten" |

Gegenprobe, dass das Verfahren sieht: derselbe Textabgleich findet die 106 gefilterten Owner-Nachrichten problemlos wieder, darunter den CEB-KERN (`bak 3141`) und die Namens-Ratifizierung (`bak 3445`). Die acht sind keine Suchfehler, sondern **ein anderer Datensatztyp**.

**Konsequenz, die ins Register gehoert:** Jede Erhebung, die „alle Owner-Aussagen" ueber `type=="user"` zaehlt, ist um diese zwanzig zu klein — und die Luecke faellt ausgerechnet auf die dichteste Stunde des Tages. Das gesicherte Verbatim-Transkript enthaelt die `queue-operation`-Datensaetze **mit** — die Sicherung ist also vollstaendiger als der Filter, der sie liest.

---

### I.1 Die Kette in einem Bild

```
  [PLANER]        laeuft (RT)   prueft Faehigkeiten, gibt frei, bewegt Unter-Achsen
      |                            baut ->
  [CEB]           laeuft (RT)   traegt CT die freigegebenen Routinen einkompiliert
      |                            baut ->
  [HYBRID]        laeuft (RT)   Schaltungs-Adapter: waehlt je Last-Kanal      (noch ungebaut)
      |                            baut ->
  [TIER-BINARY]   laeuft (RT)   das gemessene Objekt

  MESSUNG -> FUNKTIONS-SYNTHESE -> SCHNITT-KURVEN (break even) -> optimale Konfiguration
          == die zu WAEHLENDE Binary -> zurueck in den HYBRID als Schaltlogik
```

Das ist keine Datenfluss-Skizze. Es ist eine **Folge von Vertraegen**: jedes Glied laeuft, baut das naechste, und friert dabei dessen Eigenschaften ein. Der Owner hat genau diese Beschreibungssprache eingefordert, als der Lead die Architektur zuerst als Pipeline erklaerte (`live 2155`, 11:15:10Z, verbatim):

> „Es existiert kein CSV Lager. xlsx ist default. Und ich lese nichts ueber den Planer, CEB und die Tier-Binaries in **aufeinander aufbauenden Vertraegen**"

Die beiden Vertragsnaehte der Kette haben Namen und Orte im Code:

- **Experiment-Dock** — Planer ↔ CEB. Job-Emission (Ledger `:4076`, §40.b Dynamic-Child-Pipelines; Bare-Metal-Zwilling `experiment_plan.cmake`).
- **Pruef-Dock** — CEB ↔ Tier, bidirektional. Die CEB kompiliert, laedt per `dlopen`, und fuehrt den bindenden Ablauf *import → GATE → messen* (Ledger `:4076`).

---

### I.2 Die Schlangen-Mechanik

#### I.2.1 Der Satz

Owner, **verbatim**, Transkript `live 7256` (2026-08-06T22:20:04Z) — vollstaendig als **KERN 3** in Kapitel VI:

> „Moment: Die CEB baut die Compile time der Tier-Binaries und fuehrt dann deren Laufzeit aus. Also der **Kopf der schlange ist Laufzeit** und kontrolliert **durch den Bau immer die compile time des naechsten gliedes** und dann die **freigegebenen Laufzeit-Eigenschaften dieses Gliedes**. Bitte Schau nochmal nach ZWEIPHASIG und DREIPHASIG per Explore Agent, denn **es gibt 3 Typen in diesem System**"

Das ist kein neues Bild. Es ist die Verallgemeinerung eines Satzes vom 20.07., Ledger `:3095` (§57, „User-Praezisierung, massgeblich, verbatim-treu"):

> „Bei der CEB sind System-Achse und Organ-Achse noch runtime und die Mess-Achse fest einkompiliert (bis auf Variablen des Planers ueber dynamische Unter-Achsen); **die CEB baut zu ihrer Laufzeit die compile-time Tier-Binaries auf**, welche dann den System-Achse x Organ-Achse Typ+Versions-Stempel erhalten. Die CEB hat ihren eigenen Typ+Versions-Stempel ueber die Mess-Achse des Planers."

Und als Gesetz, Ledger `:3097-3100`:

> „**Planer:** traegt die Mess-Achse; baut je Mess-Tooling-Wahl EINE CEB. — **CEB:** die **Mess-Achse ist FEST EINKOMPILIERT** … **System-Achse und Organ-Achse sind an der CEB NOCH RUNTIME** — die CEB haelt sie als Bau-Raum. Die CEB **baut zu IHRER LAUFZEIT die COMPILE-TIME Tier-Binaries** (ihre Laufzeit = Bau-Zeit der Tier-Binaries). — **Tier-Binary:** compile-time-Artefakt; ein festes (System x Organ)-Kompilat."

Die Ketten-Laenge steht seit dem 19.07. fest, Ledger `:2261` (§30, Punkt 6):

> „**3 bis 4 Binaries in EINER Kette**, die **vom Kopf bis Fuss top-down nacheinander in sequentieller Abhaengigkeit, Steuerung und Ausrichtung GENERIERT werden**"

#### I.2.2 Die vier Glieder, am Objekt

| Glied | laeuft | baut | Beleg (ce `c4c04315`) |
|---|---|---|---|
| **Planer** | RT | die CEB, je Mess-Tooling-Wahl eine | eigene Binary `apps/experiment_planner/main.cpp:8-11` nennt sie den „TRAEGER der Mess-Achsen-STUFE-1-RT-FREIGABE"; `experiment_plan_director.hpp:34` bestaetigt: der Planer baut nichts und misst nichts selbst |
| **CEB** | RT | die Tier-`.so` | Perm-Walk `experiment_plan_director.hpp:2101-2102` (`for (opt_id) for (simd_id)`) mit dem Kopfkommentar `:161`: „EINE opt x simd Permutation (system_config => NIE binary_id, NIE N; nur BAU-/MESS-Matrix + build_version-Suffix)" |
| **Tier** | RT (per `dlopen` im Host) | **nichts** | Nullbefund mit Nenner: `posix_spawn\|std::system(\|execvp\|popen(` ueber `anatomy/` + `axes/` (der Code, der in die Tier-`.so` geht) → **0 Treffer bei 399 Dateien**; Gegenprobe dasselbe Verfahren ueber `builder/` → **24 Treffer** |
| **Hybrid** | — | — | **heute kein Glied.** `libs/cache_engine/hybrid/` enthaelt genau eine Datei: `README.md:1` — „`# hybrid/ -- RESERVIERTER STUB der Hybrid-Tier-Stufe (KEIN CODE)`". Nachgezaehlt am Ref `c4c04315`: **1 Datei**. Gegenprobe: `hybrid` in `libs/cache_engine/CMakeLists.txt` = 0 Treffer, waehrend dieselbe Datei 5 `add_subdirectory`-Zeilen traegt, die dasselbe Verfahren findet |

**Ist: dreigliedrig. Soll: dehnbar auf vier.** Das ist kein Versaeumnis, sondern die richtige Reihenfolge — siehe I.8.

---

### I.3 Die drei Typen — und warum genau einer dreiphasig ist

#### I.3.1 Die Typen sind die Achsen-Arten

Der Owner-Satz „es gibt 3 Typen in diesem System" (`live 7256`) loest sich gegen seine eigene Definition vom 01.08. auf, verbatim:

> „E-1: Thesis ist veraltet und kennt noch nicht mal **die 3 Typen der Mess-Achsen, System-Achsen und Organ-Achsen**."

Ratifiziert am 06.08. um 22:40:07Z mit zwei Worten (`bak 3445`): **„Alles korrekt erkannt"**.

#### I.3.2 Die Stufigkeit je Achsen-Art — die kanonische Form

Sie stammt nicht von diesem Abend, sondern vom 05.08., und der Owner hat sie dort in zwei aufeinanderfolgenden Korrekturen praezisiert und dann abgenommen.

**Ledger mittag-9, Owner verbatim:**

> „Das war nur fast richtig: Die Mess-Achsen sind DREISTUFIG Symmetrisch, die Sytem-Achsen sind ZWEISTUFIG symmetrisch und die Organ-Achsen sind ZWEISTUFIG symmetrisch, wobei die **erste stufe immer Runtime Freigabe** und die nachfolgenden Stufen **compile time Einbau** sind Planer->CEB-TierBinaries. Wenn wir die Hybriden betrachten und sie als vierte Stufe eingeschoben sind, **erben sie ALLE Eigenschaften vorausgegangener Stufen** und geben die Eigenschaften der Mess-Achse an ihre Tier-Binaries zur compile Zeit weiter"

**Ledger mittag-10, Owner verbatim:**

> „Die System-Achse ist exakt wie die Messachse **dehnbar stufig** gegen die eingeschobenen Hybriden und die Hybriden geben sich selbst und ihren Tier-Binaries die System-Achsen-config per compile time mit. Die Organ-Achsen sind eigentlich **nur in den Tier-binaries verbaut** und beruehren die Hybriden nicht direkt, da die Hybriden ein **factory pattern - facade - Adapter** sind"

**Ledger mittag-11, Owner verbatim:** „Jetzt ist alles korrekt, wie du es beschrieben hast … Volles go".

Die kanonische Gesamtform (Ledger `:4090`):

| Achsen-Art | Kette | Stufen | Dehnbar? |
|---|---|---|---|
| **MESS** | Planer (RT-Freigabe) → CEB (CT) → **[Hybrid (CT)]** → Tier (CT) | **3** | ja |
| **SYSTEM** | CEB (RT-Freigabe HW) → **[Hybrid (CT)]** → Tier (CT) | **2** | ja, exakt wie Mess |
| **ORGAN** | CEB (RT-Freigabe der Permutations-Wahl) → Tier (CT) | **2** | **nein** — hybrid-unberuehrt |

**GESETZ:** Stufe 1 ist **immer** Runtime-Freigabe in der Traeger-Binary; alle Folgestufen sind Compile-Time-**Einbau** entlang Planer → CEB → Tier.

#### I.3.3 Warum die Mess-Achse eine Stufe mehr hat

Nicht weil sie wichtiger waere, sondern weil sie **ein Glied weiter oben ansetzt**. System- und Organ-Achsen beginnen erst *in* der CEB; die Mess-Achse beginnt *davor*, im Planer.

Am Code belegt: die Mess-Combo wird an den `ceb_combo_compile_define()`-Naehten compile-hart in die CEB gegossen — die Planer-Binary ist der Traeger der Stufe-1-Freigabe (`apps/experiment_planner/main.cpp:8-11`). **Einschraenkung, die genannt gehoert:** `experiment_plan_director.hpp:39-40` vermerkt „INERT-by-default: nichts ruft den Director ausser dem opt-in Contract-Test". Der CI-Job `super/.gitlab-ci.yml:1263-1270` ruft die Planer-**Binary** allerdings real (`"$PLANNER" plan ci …`). Kein Widerspruch, aber eine Pruefregel: **wer „die Mess-Achse startet im Planer" pruefen will, muss den CI-Pfad pruefen, nicht die Bibliotheks-Aufrufe.**

#### I.3.4 Die Fortpflanzungs-Asymmetrie — der teuerste Satz der Architektur

Owner-KERN vom selben Abend, `bak 1738` (19:37:43Z), Frage 2, verbatim:

> „Bitte fixen und neu messen ist Pflicht. Wenn eine Messachse sich aendert, dann wirkt sich das bei Veraenderung des Messsystems in der CEB bezueglich **DREIPHASIG und ZWEIPHASIG** (im Plan) auf die nachfolgenden Stufen aus (bitte explore). Dadurch muss bei einem neuen Messsystem auch **die CEB und ALLE Binaries** fuer die Mess-Achsen-Einstellung **neu gebaut** werden. Bitte beachte dabei den Vertrag CEB vs Tier-Binary bzw CEB vs Tier-Hybrid-Binary. Das ist eine Gedaechtnisluecke."

Daraus die Regel, die jede Bau-Entscheidung dieses Projekts bindet:

> **Eine MESS-Achsen-Aenderung baut CEB UND alle Binaries neu. Eine SYSTEM- oder ORGAN-Aenderung baut nur die Tiers.**

Der Grund ist rein die Stufenzahl aus I.3.2: die Mess-Achse haengt oberhalb der CEB, also faellt die CEB mit.

#### I.3.5 Phase gegen Stufe — die Vokabel-Falle

**Die Stufenzahl ist dehnbar, die Typenzahl nicht.**

> **STUFE** = wie viele Glieder eine **Achsen-Art** besetzt. Achsen-relativ (3 / 2 / 2), **dehnbar** durch Hybrid-Einschub (4 / 3 / 2).
> **PHASE** = **Position in der Kette**, also der Traeger-Typ. Fester Bestand: **3** (Planer / CEB / Tier). Nicht dehnbar.

Wer „3 Stufen" sagt, sagt etwas, das mit dem ersten eingeschobenen Hybrid falsch wird. „3 Typen" bleibt wahr. Der Hybrid ist naemlich **selbst eine Tier-Binary** — Ledger `:4076`: „HYBRID-Ruf: Heuristik **SELBST als Tier-Binary** am selben Pruef-Dock (**kein dritter Dock-Typ**) … **Tier-Neubau IMMER delegiert durch CEB**."

Und darin steckt der eigentliche Inhalt der „Gedaechtnisluecke": **zwei** der drei Typen sind zweiphasig, nur **einer** ist dreiphasig. Wer die Paar-Formel „DREIPHASIG und ZWEIPHASIG" ohne die drei Traeger liest, ordnet „ZWEIPHASIG" genau einer Sache zu und uebersieht den zweiten Zweiphasigen.

#### I.3.6 Eine Beleg-Korrektur, die stehen bleiben muss

Eine fruehere Erhebung stuetzte dieselbe — richtige — Schlussfolgerung auf ein **falsches Argument**: sie meldete „null `dreiphasig`-Treffer im gesamten docs-Baum". Real sind es **8**. Der Owner schreibt `DREIPHASIG` in **VERSALIEN**, die Suche lief case-sensitiv. Der Bericht war blind gegen seinen eigenen Text — er zitierte den Satz und meldete im selben Dokument, es gebe ihn nicht.

**Die Schlussfolgerung traegt** (unabhaengig durch Ledger `:4082`/`:4095`), **das Argument nicht — es darf nicht weiterzitiert werden.** Daher die `-i`-Auflage fuer jede Suche in diesem Korpus. Der Fall wird in Kapitel III als **FA-2** vollstaendig eingeordnet.

---

### I.4 PMC ist eine MENGE, keine Einrichtung

#### I.4.1 Der KERN

Owner, verbatim, `bak 3103` (21:55:10Z) — vollstaendig als **KERN 4** in Kapitel VI:

> „Soweit ich mich erinnere muessen **ALLE per deep research belegbaren Architekturen von AMD und Intel** mit PMC unterstuetzt werden. Dazu gehoeren **Performance Core und E-Core PMC Einrichtungen, die getrennt gemessen und ausgewertet werden**. **Damit hat die Intel Maschine effektiv 2 PMC und nicht nur eins.** Dieses muss **je Konfiguration compile time nach der Freigabe durch den Planer in die CEB eingearbeitet werden**"

Vier Festlegungen:

1. **Die Frage lautet nie „ist PMC verfuegbar", sondern „welche PMU-Domaenen hat diese Maschine und welche Zaehler traegt jede".** prod2 (i9-12900K, Alder Lake, 8P+8E) hat **zwei** (`cpu_core` / `cpu_atom`), prod1 (Ryzen 9 9950X3D, Zen 5) **eine**.
2. **P-Core und E-Core werden getrennt gemessen UND getrennt ausgewertet.** Nicht gemittelt, nicht zusammengefasst, nicht „die erste, die antwortet".
3. **Die Abdeckung ist Deep-Research-Pflicht**, kein Best-Effort — Ereignis-Kodierungen je Mikroarchitektur (Zen 3/4/5, Alder Lake, Raptor Lake) als RAW-Events. Der generische `PERF_TYPE_HW_CACHE` kennt die Trennung gar nicht.
4. **Einbau je Konfiguration, compile time, in die CEB, nach Planer-Freigabe** — exakt die Stufen-Doktrin aus I.3.2 am Einzelfall.

#### I.4.2 Das ist seit dem 09.04.2026 Pflicht

Termin 3, „Hybrid-Regel lokal", verbatim aus dem Betreuer-Korpus:

> „P- und E-Cores werden nicht zusammenaggregiert. perf dokumentiert dafuer getrennte PMUs **cpu_core** und **cpu_atom**; gruppierte Events ueber beide PMUs werden vermieden."

Mit Risiko-Zeile („Hybrid-CPU-Zaehler werden falsch aggregiert" / Gegenmassnahme „strikte Trennung cpu_core/cpu_atom") und **fertigem Baustein-Entwurf** im Domaenenmodell: `HybridCorePinning` mit `pin_thread(thread_id, core_class:{Performance|Efficient})` und `measure_per_class() -> {p_core, e_core}`.

Die Hybrid-CPU ist ausserdem ein **Term der Forschungsfrage** (Termin 4, Scope-Freeze 12.04.): „… gegenueber passiven, statischen Layouts **auf Hybrid-CPUs und Sapphire-Rapids-Systemen**?"

**Der Plan hat die Fehlerklasse benannt und den Baustein gezeichnet — gebaut wurde er nicht.** Vollstaendige Herleitung: `docs/plaene/20260806-KANON-termine-plan-soll-gegen-ist.md`.

#### I.4.3 Ist-Stand, heute gemessen (ce `c4c04315`)

| Gegenstand | Befund | Nenner / Gegenprobe |
|---|---|---|
| PMU-Domaenen-Trennung im Code | **0** | `cpu_atom` in `libs/` = **0 Treffer**; Gegenprobe `perf_event_open` = **18 Treffer ueber 4 Dateien** — die Suche sieht |
| Vokabular dafuer | **existiert, ist aber bewusst leer** | `platform/i_platform_probe.hpp:15,19,20`: `has_hybrid_cores`, `cpu_core_atom_perf_separation`, `preferred_pinning_policy` — und `platform_probe/cpuid_platform_probe.hpp:38-39` verbatim: „AP-13: **Topologie/Pinning bleibt bewusst ungesetzt**" |
| Der Aktuator | **gebaut, nicht gerufen** | `builder/measurement/thread_pinning.hpp` (105 Z., `wc -l` an ce `54106bc9`): `class ScopedThreadPin` mit `sched_setaffinity` (`:61`) / `SetThreadAffinityMask` (`:47`), RAII-restore (`:70-78`), plus `NoPinPolicy`/`CorePinPolicy` (`:96-104`). Kein Doppelstart, kein Aufrufer im Mess-Loop |
| Die Collector-Achse | drei Bausteine, PMC traegt 7 Kategorien | `measurement_axis_registry.xml:25-42`: `WallClockSystemAxis` · `ObserverSnapshotSystemAxis` · `PmcSystemAxis` (`CACHE_MISS_L1/L2/L3`, `DTLB_MISS`, `BRANCH_MISS`, `IPC_CPI`, `ENERGY_J`), alle `binary_id="never"` |

**Zur `thread_pinning.hpp`-Zeile eine Warnung fuer jeden Folge-Agenten:** ein erster Sweep meldete `sched_setaffinity` = 0 Treffer im ce. **Falsch.** Der Filter lautete `grep -v "/build"` und frisst `/builder/` mit — und genau dort liegt der einzige Aktuator des Repos. Die falsche Null haette einen Neubau ausgeloest, den es nicht braucht. (Kapitel III, **FA-3**.)

#### I.4.4 Der L3-Befund — und seine Landung in dieser Nacht

Der errno-Kanal (ce `22e17f57`) machte sichtbar, was vorher als Null aussah. Auf prod1 (Zen 5) liefert `PERF_TYPE_HW_CACHE / LL / READ / MISS`:

```
event=cache_misses_l3_ll  type=3  config=65538  errno=2 (No such file or directory)
```

**L2 und L3 sind auf AMD nicht „null" — sie existieren in dieser Kodierung nicht.** Auf Intel liefert derselbe Zaehler 3,2–4,1 Mio. Waere der Voll-Lauf so gestartet, haetten alle AMD-Zeilen eine Null getragen, die eine Messung behauptet; eine Reparatur danach haette frueh und spaet erhobene Zeilen mit **verschiedener Semantik unter derselben Ueberschrift** hinterlassen — ein Datenbruch ohne Neubau, schlimmer als ein Neubau, weil unsichtbar.

**Neuer Stand gegenueber allen drei Bestandsaufnahmen dieses Dossiers:** der Posten ist **gelandet**, ce `5c102e05`, Merge `c4c04315`, 07.08.2026 00:13 UTC. `PmcCounters` traegt jetzt vier Pro-Zaehler-Verfuegbarkeitsflags — `pmc_source.hpp:37-43` (ce `54106bc9`): `cache_misses_l2_source_available` (`:37`), `cache_misses_l3_source_available` (`:38`), `coherence_invalidations_source_available` (`:39`), `energy_micro_joules_source_available` (`:43`), alle Default `false` (Fail-Safe). Die CSV-Zelle rendert `SourceUnavailable`/`n/a` statt einer erfundenen 0 — **nur wenn die Zeile ueberhaupt real gemessen wurde**; eine echte 0 bleibt 0, und PMC-off-Zeilen sind byte-identisch unveraendert.

> **Siehe Abschnitt 0 / W-2:** Kapitel III fuehrt diesen Posten noch als uncommitteten WIP-Patch. Beide Angaben sind korrekt, acht Minuten auseinander. **Verbindlich ist: gelandet.**

Die Commit-Nachricht traegt ausserdem das Deep-Research-Ergebnis der Owner-Auflage: ein AMD-Rohevent fuer L3-Misses **existiert konzeptionell**, aber die dafuer noetige `amd_l3`-Uncore-PMU ist auf identischer Hardware/Kernel wie prod1 zwar als Modul vorhanden, **aber nicht geladen — eine Infra-, keine Code-Frage.** Ein eigener Versuch, den Zaehler ueber die Core-PMC-Rohkodierung zu erraten, scheiterte an einer Skalierungsprobe (weniger Treffer bei 1 GiB als bei 32 MiB Arbeitslast) und wurde verworfen statt geglaubt.

**Was offen bleibt (M-3a), heute nachgemessen:** `branch_misses` hat **kein** Verfuegbarkeitsflag und wird von **keiner** `IPmcSource` je geschrieben — die einzige Zuweisung im gesamten `libs/`-Baum ist die Kopie `measurement_snapshot.hpp:145` (`m.branch_misses = pmc.branch_misses`) aus einem POD, den niemand fuellt. Die CSV-Spalte `pmc_branch_misses` existiert seit dem 04.08. im Header (`cache_engine_builder_iterator.hpp:557`). Sie traegt immer den Default 0.

---

### I.5 Die P/E-Trennung ist eine PERMUTATION, kein zweiter Bau

#### I.5.1 Die Lead-Lesart, die widerlegt wurde

Der Lead hatte aus I.4.1 („je Konfiguration compile time") gelesen: **eine CEB je PMU-Domaenen-Satz**, also eine Verdopplung der Flotte, ein Preimage-Eingriff und ein Neubau von 34,4 Stunden plus aller bis dahin erhobenen Messdaten.

Die Antwort beginnt mit dem Satz, der ihr Gewicht gibt — Owner verbatim, `bak 3141` (22:02:43Z), vollstaendig als **KERN 5** in Kapitel VI:

> „**Du hast ein Verstaendnis-Problem ueber die CEB**, bitte Explore Agent dazu: Die CEB **kann beide Messfuehler tragen**, aber legt die Ergebnisse **je PMC getrennt** ab. Die Tier-Binary wird ueber die **Permutation aller Achsen** insbesondere ueber die **Permutation der NUMA Achse und deren Core-Unterachse** zur Laufzeit der CEB und zur Runtime der Tier-Binary gemessen. Kurz und knapp: Die CEB kann alles messen, aber startet **einmal die Tier-Binary gepinnt auf einen E-Core und einmal gepinnt auf einen P-Core** und misst die Tier-Binary dann mit dem entsprechenden PMC durch. Das ist eine **reine Wiederverwendung durch Achsen-Permutation durch die CEB auf einer dafuer zustaendigen SYSTEM-Achse**."

Daraus hart:

- **EINE CEB**, die beide Messfuehler traegt. Die Trennung liegt in der **Ablage**, nicht in der Binary.
- **KEINE zweite Tier-Binary.** Dieselbe wird **zweimal gestartet**, je gepinnt.
- **Die Flotte verdoppelt sich nicht.**
- **Zwei Zeitpunkte** sind zu unterscheiden: *Laufzeit der CEB* (sie pinnt und waehlt den PMC) und *Runtime der Tier-Binary* (sie wird gemessen).

**Merksatz: die Hybrid-Trennung ist eine PERMUTATION, kein zweiter Bau.**

#### I.5.2 Der Registry-Vertrag, der das traegt — nicht Absicht, sondern Struktur

Heute am Objekt nachgelesen, `libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml`:

- **`:10`** — `<axis id="target_isa" … binary_id="never" stage="ct" …>`. **Die Achse kann die Tier-Binary-Identitaet strukturell nicht anfassen.** Kein Fingerprint-Eingriff, kein Neubau.
- **`:38`** — `<sub_axis id="numa_node" parent="target_isa" stage="runtime" value_type="token" option_source="machine_resolved"/>`.
- **`:5-7`** (Registry-Kopf) — „Haupt-Achse=CT-statisch (stage=ct, in die CEB/Tier-Binary einkompiliert); **Unter-Achse=dynamisch (stage=runtime, vom Planer permutiert)**."
- **`:2-4`** — „GENERIERT von `tools/system_axis_registry_gen` … **NICHT von Hand editieren**." Wer hier etwas aendert, aendert den Generator.

Der Weg, den der Owner beschreibt, ist damit im **Vertrag** verankert, nicht in einer Absicht. Die Kostenrechnung des Leads war gegenstandslos.

#### I.5.3 Wer die Faehigkeit prueft — der Planer, nicht die CEB

Die zweite widerlegte Lead-Lesart lautete: „das Pinning IST die Laufzeit-Freigabe IN der CEB." Owner, verbatim, `live 7219` (22:17:04Z), vollstaendig als **KERN 6** in Kapitel VI:

> „Die **Pinning Faehigkeit prueft der Planer zur Laufzeit**, sodass die **CEB zur compile Zeit die korrekten Binary-Code-Routinen traegt** (Interfaces zur Pinning Abfrage an das korrekte OS Interface -> **je OS anders hard compiled** - oder **keine Pin Interfaces da nicht vorhanden**) und der **Planer bewegt die System-Unterachsen unter den System-Haupt-Achsen**, sodass **CEB ein bestimmtes Verhalten der Tier-Binaries faehrt**."

| Stufe | Wer | Wann | Was |
|---|---|---|---|
| 1 | **PLANER** | **Laufzeit** | prueft die Pinning-Faehigkeit → Freigabe |
| 2 | **CEB** | **Compile-Zeit** | traegt die OS-spezifischen Routinen einkompiliert — **oder gar keine** |
| 3 | **Tier** | Laufzeit der CEB | die CEB faehrt ueber die bewegten Unter-Achsen ein **Verhalten** |

Vier Folgerungen:

- **Die CEB ist je OS anders kompiliert.** Das Pinning-Interface wird hart einkompiliert, nicht zur Laufzeit gewaehlt. Der bestehende `thread_pinning.hpp` bildet das bereits ab — `#if defined(_WIN32) / #elif defined(__linux__) / #else` (`:42-67`), und der `#else`-Zweig ist funktionslos.
- **„Keine Pin-Interfaces" ist ein gueltiger Bauzustand**, kein Fehler.
- **Der Planer BEWEGT die System-Unter-Achsen** unter den Haupt-Achsen; die CEB entscheidet die Kern-Klasse nicht, sie faehrt die gestellte Auspraegung ab.
- **Die CEB steuert ein VERHALTEN**, nicht den Inhalt der Tier-Binary.

**Merksatz: der Planer FRAGT (RT), die CEB TRAEGT (CT), die Tier-Binary LAEUFT (unveraendert).**

#### I.5.4 Was sich stattdessen verdoppelt: die Mess-Zeit, und nur auf prod2

Die Flotte bleibt bei 524.288. Was sich verdoppelt, sind die **Settings je Binary auf der einen Hybrid-Maschine**:

```
prod2:  216 Settings x 2 Kern-Klassen  =  432 Settings je Binary
prod1:  216 Settings x 1               =  216 Settings je Binary   (honest-0)
```

Die 216 = 6 workloads × 4 working_set × 3 hw_prefetcher × 1 thread × 3 repetitions (`all_axes_golden.profile.xml:112,126,156,157,160`). Bei 109,4 ms je Messung ergibt das fuer den flachen Faecher ueber alle Binaries ~3,0 d heute → **~6,0 d bei gleicher Lane-Aufteilung**, **~4,0 d bei optimaler Umverteilung** (Anteil f auf prod2 mit 2f = 1−f, also f = 1/3).

**Zwei ehrliche Einschraenkungen**: (1) 109,4 ms ist eine **Untergrenze** — der Korpus wurde bei `working_set_n = 4096` erhoben, der golden-Sweep geht bis 8.388.608, und `total_ns` enthaelt weder Working-Set-Aufbau noch Warmup noch Rollback. (2) Die Umverteilungs-Rechnung setzt gleiche Durchsatzraten beider Lanes voraus — **nicht belegt**; diese Zeile ist eine Rechnung, keine Messung.

**Kernaussage:** die Verdopplung trifft **die Mess-Zeit auf einer Maschine** — nicht die Bau-Zeit, nicht die Flotte. Und die Mess-Zeit war ohnehin schon als der Engpass ausgewiesen. Vollstaendige Rechnung: `20260806-PLAN-hybrid-pmc-numa-core-permutation.md` §7.3.

#### I.5.5 Die fehlende Unter-Achse

Owner, verbatim, `bak 3415` (22:36:35Z), vollstaendig als **KERN 8** in Kapitel VI:

> „**Warte:** numa page ist eine **Cache-Seiten Koordination von Cache-Seiten lokalitaet**. Jetzt brauchen wir ein pendant numa_process_probe dazu, welche sich damit beschaeftigt, **wo Programme ausgefuehrt werden, nicht welche Speicherseiten wo liegen**, sie sind aber beide **strukturell aehnliche Unterachsen**. Das ist also eine **fehlende neue Unterachse, sie existiert nur im Plan, nicht gebaut**"

Und die Namensvorgabe, `live 7387` (22:37:57Z): „Ich moechte numa_process_probe besser **numa_cpu_pin_process_probe** nennen" — der Name benennt **das Pinning** als Gegenstand, nicht bloss den Prozess.

| Unter-Achse | Gegenstand | Zustand |
|---|---|---|
| `numa_page_probe` | **Speicher**-Lokalitaet — wo liegen die Seiten | gebaut (OD-10-RT), **nicht angeschlossen** |
| **`numa_cpu_pin_process_probe`** | **Ausfuehrungs**-Lokalitaet — wo laeuft der Code | **fehlt**, nur im Plan |

**Heute nachgemessen:** die Registry fuehrt **11 `sub_axis`-IDs** (`:13, :29, :38, :39, :45, :46, :47, :51, :109, :112, :139`) — **keine** enthaelt „core", „pin" oder „process". Gegenprobe: `numa_page_probe` = 67 Treffer im Repo, die Suche sieht also. Der ce-Anteil des Pakets liegt als Zweig `b-numa-process-probe` (`b4cebdc4`, 18 Dateien, +2800/−33, inkl. `tests/unit/test_od11_numa_process_probe.cpp` mit 841 Zeilen) **ungelandet** vor; der zugehoerige XSD-Delta im super (`Code/test_data_xml/experiment_schema.xsd`, +24 Zeilen) ist **nicht einmal committet** (Kapitel IV.2.3 — der gefaehrlichste Einzelposten der Bilanz).

**Eine Namensfalle, die in diesem Zusammenhang toedlich ist:** die Registry fuehrt bei `:34` bereits `hetero_core_dispatch` — das ist eine **CT-POLICY** unter `scheduling` (`stage="ct"`). `core_class` waere ein **RT-FAKTUM**. Wer die beiden verwechselt, baut die Erhebung in die falsche Stufe.

---

### I.6 Wenn nicht gepinnt werden kann — und die Schwere-Leiter

Owner, verbatim, `bak 3189` (22:08:13Z), vollstaendig als **KERN 7** in Kapitel VI:

> „hat eine CPU nicht das pinning Feature (**zusammen mit einem OS Kernel der das auch unterstuetzen und durchreichen muss**), kann eine Maschine nicht pinnen und **muss die PMC Werte tatsaechlich mit der Warnung ausgeben, dass die Werte nicht tragen, weil der Ort der Ausfuehrung nicht bekannt ist**."

Und die Schwere-Entscheidung, `live 7166` (22:09:48Z), verbatim:

> „Nun bei diesem fehlenden Pinning Feature gibt es ja **ehrliche Messwerte**, aber ob man sie **gebrauchen** kann ist fraglich. Ich wuerde **nur hier** einen **Kompromiss** eingehen und **kein „fatal" ausgeben aber „warn: no pinned locality on hybrid architecture"**"

**Der Warntext ist woertlich vorgegeben.** Die Faehigkeit haengt an **zwei** Bedingungen — CPU **und** Kernel, der es **durchreicht** —, beide zur Laufzeit zu pruefen. Merksatz: **ehrlich erhoben, fraglich verwendbar → WARN.** Ausdruecklich als Einzelfall markiert („nur hier"), keine allgemeine Absenkung.

Die vollstaendige Leiter, Owner verbatim `bak 3226` (22:13:48Z) — **KERN 9**:

> „**Error** waere etwa, wenn der Kunde in der XML eine GPU Variante der Binary bauen will, aber gar keine GPU im System registriert ist. Also etwas, das mit **fehlenden grundlegenden Systemeigenschaften** zu tun hat. **Fatal** waere: Abbruch des Compile oder Messung durch Kappen von Kabeln, Verbindungsabbrueche, unerwarteter Speicherverlust, **Lager-Inkonsistenz**."

| Stufe | Natur | Der Lauf |
|---|---|---|
| **WARN** | der Wert **existiert**, seine **Verwendbarkeit** ist fraglich | laeuft weiter, Wert wird ausgegeben, Vorbehalt reist mit |
| **ERROR** | die **Anforderung** trifft auf eine fehlende grundlegende Systemeigenschaft | nicht erfuellbar — **kein Ersatzwert** |
| **FATAL** | die **Integritaet** ist zerstoert | Abbruch von Compile oder Messung |

Zwei Trennlinien: *WARN gegen ERROR — gibt es einen Wert?* · *ERROR gegen FATAL — war der Zustand vorher konsistent?* Und: **Lager-Inkonsistenz ist FATAL**, nicht ERROR.

**Und die vierte Zeile derselben Leiter**, `bak 3547` (22:59:15Z), verbatim — **KERN 10**: „**Stiller Rueckfall geht fuer uns nicht: Regressionen oder Fehler gehoeren angezeigt, das ist ein weiterer Fall fuer das Anzeigen von error**". Damit ist die Leiter nicht mehr nur ueber Systemeigenschaften definiert, sondern ueber **Verhalten**: was zurueckfaellt, muss es sagen. Der stille Rueckfall ist **die Bauform** hinter der These des Regressions-Dossiers — jene beschreibt das Symptom, dieser die Konstruktion. Vollstaendige Herleitung: Kapitel III.1.2 und III.9.

**Bestandsbeleg, der die Session-Lehre traegt:** `measurement/axis_error.hpp` (655 Zeilen, ce `c4c04315`) fuehrt die Zell-Zustaende **bereits kanonisch** — `SampleStatus{Ok, NotApplicable, SourceUnavailable, Failed}`, dazu `AdmissionStatus`, `BuildCellStatus` und `CompilerCompilerErrorClass` mit `HardwareErweiterungFehlt` („ISA-/Beschleuniger-Erweiterung auf dem Host nicht verfuegbar (AVX512, **GPU**, FPGA)") und `BetriebssystemFeatureFehlt` als OS-Analogon. **Das GPU-Beispiel des Owners steht seit dem 26.07. woertlich im Code.** Die Leiter musste an diesem Abend nicht erfunden, sondern wiedergefunden werden. Detail: `20260806-PLAN-warnungen-und-ausgabe-bei-messfehlern.md`.

---

### I.7 Wallclock auf drei Ebenen — und ihre Verortung

#### I.7.1 Der KERN

Owner, verbatim, `live 7761` (23:26:59Z), Endfassung der zweiteilig gesendeten Nachricht — **KERN 12**:

> „Hinweis: **Wall Clock time** wird daher auch **fuer jeden Achsenaufruf IN der Tier-Binary**, **fuer jeden Funktionsaufruf durch die CEB AUF dem Pruefdock ueber die Tier-Binary**, und ebenfalls als **large scope im selben Zug zu den Last-Profilen ueber den Verlauf mehrerer Funktionsaufrufe der Tier-Binaries ueber eine gemessene Last-Sequenz**, erhoben. Die **Wallclock time ist das dritte Glied**, welches in der **Messachse in die CEB und damit DREIPHASIG in die Tier-Binaries eingearbeitet** wird und **lebt per Planung und Definition in der Mess-Achse**."

Und — 68 Sekunden spaeter — die **Verortung**, `live 7776` (23:28:07Z), verbatim:

> „Korrekt: **fuer die Erhebung des Micro-Benchmarkings ist die Wallclock time zusaetzlich IN der Tier-Binary einkkompiliert. Ansonsten ist sie wie gehabt in der CEB.**"

> ⚠ **Dieser zweite Satz fehlt in der Ledger-Konsolidierung `abend-4`.** Er traf **nach** dem Konsolidierungs-Auftrag ein (23:21:57Z, `bak 3728`) und ist heute nur an zwei Stellen im Bestand: im Verbatim-Transkript und in `super docs/sessions/20260806-PAUSE-abbruchsicher-nachts-nach-architektur-konsolidierung.md:123-124`. Gegenprobe, dass die Suche sieht: derselbe Lauf findet `no pinned locality on hybrid architecture` in drei Dateien. **Nachzutragen.**

Er praezisiert im Uebrigen exakt eine aeltere Owner-Direktive, Ledger `:3403` (§64-Schichten-Zuordnung, 22.07.): „**Makro- und Micro-Benchmarking** muss durch **CEB UND TIER-BINARY einkompiliert ueber das PRUEFDOCK** unterstuetzt werden (beidseitig: die CEB traegt die Pruef-Tools, das Tier-Binary die Observer)."

#### I.7.2 Zwei orthogonale Dimensionen, nicht eine

Das ist die Aufloesung der Verwechslung, die den Abend gekostet hat: **Tooling** und **Ebene** sind zwei Achsen, keine.

- **Tooling** (Auffaecherungs-Achse, Mengenwert): `wallclock` / `macro` / `micro`. Am Objekt (ce `54106bc9`): `measurement_tooling_registry.hpp:27-31` (`enum class MeasurementTooling`), `kMeasurementToolingCount = 3` (`:34`) als Single-Source gegen stille Drift, Registry-Tabelle `:46-50` — **Index == Enum-Wert, `static_assert`-gesichert**.
- **Ebene** (Erhebungs-**Ort**): E1 Achsenaufruf · E2 Gattungs-Funktionsaufruf · E3 Last-Sequenz.

**Beleg, dass es zwei sind:** `profile_facade/profile_run_facade.cpp:273-275` emittiert eine **feste** Define-Menge; die Tooling-Wahl kommt darin nicht vor. Kein Timer-Ort im Code ist heute durch `wallclock`/`macro`/`micro` gegatet. Waere „wallclock" eine Ebene, muesste sie es koennen. Die Thesis sagt dasselbe (`kapitel/de/03_messsystem_prtart.tex:1305-1312`): der Apparat misst „**zusaetzlich** drei *Wallclock-Ebenen*" — das Wort „zusaetzlich" traegt die Orthogonalitaet.

**Die vier Dreien, die auseinanderzuhalten sind** — Verwechslungsschutz, ohne den dieselbe Konfusion ein zweites Mal entsteht:

| # | Drei | Elemente | Anker |
|---|---|---|---|
| 1 | **Bau-Phasen** der Mess-Achse | Planer (RT) → CEB (CT) → Tier (CT) | Ledger `:4258` |
| 2 | **Tooling-Werte** | `wallclock` / `macro` / `micro` | `measurement_tooling_registry.hpp:46-50` |
| 3 | **Erhebungs-Ebenen** (Orte) | Achsenaufruf / Gattungs-Funktionsaufruf / Last-Sequenz | `03_messsystem_prtart.tex:1310-1312` |
| 4 | **Collector-Bausteine** | `WallClockSystemAxis` / `ObserverSnapshotSystemAxis` / `PmcSystemAxis` | `measurement_axis_registry.xml:26-41` |

In #2 und #4 steht Wallclock an **erster** Stelle, in #3 als Groesse **auf allen drei** Elementen. Die Registry-Ordnung ist **nicht** die Glieder-Ordnung und darf nicht angefasst werden — jede Umordnung bricht Stempel und golden-Fingerprints.

#### I.7.3 Die drei Ebenen, ihre Verortung und ihr Ist-Stand

| Ebene | Owner-Wortlaut | Verortung (`live 7776`) | Ist-Stand |
|---|---|---|---|
| **E1** | „fuer **jeden Achsenaufruf IN der Tier-Binary**" | **IN der Tier-Binary einkompiliert** (Micro-Erhebung) | **gebaut + live, aber aggregiert und synthetisch.** 18 Segment-Timer `seg_ns[18]`, einer je Achse T0..T17 (`anatomy/abi_adapter.hpp:1781-2035`, `observable_tier.hpp:50`: `kV3AxisCount = 18`), plus Huelle `seg_run_total_ns` und benannter Rest `seg_framework_ns`. **Luecke gegen „jeden Achsenaufruf":** die Timer klammern eine **Schleife** ueber einen **synthetischen Nachlauf** — die reale Gattungs-Funktion `tier_lookup` (`:1253-1298`) fuehrt 7 Achsen-/Organ-Aufrufe aus, **0 davon gemessen**; der Bereich `:1128-1780` ist clock-frei |
| **E2** | „fuer jeden Funktionsaufruf durch die CEB **AUF dem Pruefdock**" | **in der CEB** | **gebaut + live, aber nicht auf dem Dock.** `builder/workload_driver/workload_orchestrator.hpp:65-164` misst 6/6 Op-Arten mit eigenem `clock::now()`-Paar (nachgemessen: 12 `clock::now`-Treffer). Das laeuft im **Host-Orchestrator**. Das Pruef-Dock (`builder/pruef_dock/`, **18 Dateien**) enthaelt **0 Zeilen Zeitcode** (nachgemessen: `clock::now` = 0); `IPruefDock::measure()` hat **0 Produktionsaufrufer** (12 `.measure(`-Treffer, alle in `tests/unit/`) — **⚠ siehe Abschnitt 0 / W-3: Kapitel II verdiktiert dieselbe Ebene als „fehlt", weil es das strengere Owner-Kriterium anlegt** |
| **E3** | „**large scope** … ueber den Verlauf mehrerer Funktionsaufrufe … ueber eine gemessene Last-Sequenz" | **in der CEB** | **fehlt.** `total_ns` ist eine **Summe** der Op-Zeiten, kein Verlaufs-Zeitraum; `run_workload_profile`/`run_measurement_plan` haben **0 aeussere `clock::now()`**; `total_ns` steht **nicht in der CSV**. **Die Zeit ZWISCHEN den Funktionsaufrufen ist unsichtbar.** Der fertige Verlaufs-Treiber existiert (`builder/anatomy_commands/tier_observe_trace_abi.hpp:131/:180`), haengt aber am toten Dock-Pfad |

**Die Matrix Tooling × Ebene ist keine volle 3×3** — der Plan besetzt asymmetrisch, der Bau noch schiefer. `micro` (PMC) hat heute **genau eine gebaute Zelle**: eine Delta-Klammer um die ganze Run-Phase (`harness/perm_runner.hpp:196-197/:314-318`). PMC ist damit **eine Ebene-3-Klammer, keine Micro-/Achsen-Messung** — genau das, was der Owner-KERN „PMC ins Pruefdock" verlangt. Volle Matrix und alle Nenner: `20260806-DOSSIER-messachse-wallclock-und-mess-kette.md` §2/§3.

#### I.7.4 „Das dritte Glied" — was gesichert ist und was nicht

Das Wort **Glied** hat im Bestand eine harte Bedeutung: eine Position im Fingerprint-Preimage bzw. in der Stempel-Zeile. Und dort ist die **Mess-Zeile tatsaechlich Glied [3]** — nach Format-Kennung [0], Organ-Zeile [1], System-Zeile [2]. Dreifach belegt: Preimage-Ordnung `abi/anatomy_fingerprint.hpp:428-431` mit `kAnatomyFingerprintGliedCount = 8` (`:341`); ABI-POD-Reihenfolge `anatomy_module_abi_v1_decl.hpp:180-192`; Stempel-Zeilen `anatomy_version_stamp.hpp` (organ `:82` → system `:144` → measurement `:216`).

**Ehrliche Einschraenkung:** die Gleichsetzung „drittes Glied = Preimage-Glied [3]" ist eine **Rekonstruktion aus drei unabhaengigen Objektbefunden, keine zitierbare Textstelle** (Nenner: „drittes glied" ueber `plaene/`, Ledger und `termine/` = 11 Treffer, **keiner** zur Mess-Achse; Gegenprobe `dreiphasig` = 30+ Treffer). Alternativ plausibel: drittes Glied der Kette Planer→CEB→Tier, wofuer der Anschluss-Halbsatz „…in die CEB und damit DREIPHASIG…" spricht. **Owner-Entscheid offen.**

**Und eine Falle fuers Register:** die Termin-Dokumente kennen die Groesse ausschliesslich als **`wall time` / `walltime_ns`**, nie als „Wallclock" (Nenner: 309 Dateien, `wallclock` = 2 Treffer, beide in zitierten Fremd-Papers; Gegenprobe `wall` = 18 Dateien mit den drei tragenden Treffern). **Wer nach „wallclock" sucht, meldet eine falsche Null.**

#### I.7.5 Die eine Stelle, an der ein gebautes Paket dem KERN widerspricht

Das Paket M-1 (gelandet als ce `bba4d90f`) ordnet in `mess_achsen_naht.hpp:48-55/:77-82` zu: „`wallclock` : braucht G1 … `micro` : braucht G1+G2+G3". Folge: eine `[wallclock]`-Binary traegt `MEASUREMENT_ON` **ohne** `CE_ENABLE_STATISTICS` und **verliert alle 18 Ebene-1-Achsen-Timer**. In der Serie selbst gemessen (`8f70898a`, H-B): `[all] observable_axes=9` gegen `[wallclock] observable_axes=0`.

**Das widerspricht dem Owner-KERN direkt** — Wallclock ist auf **allen drei** Ebenen zu erheben. Empfehlung, die im Wallclock-Dossier §8.1 begruendet steht: die Wallclock-Ebenen-Timer gehoeren in **jede** Tooling-Wahl, die `wallclock` enthaelt; die Gates trennen dann Observer-Statistik (macro) und PMC (micro), **nicht die Wallclock-Orte**. Owner-Entscheid, dann korrigieren.

---

### I.8 Das Ende der Kette: wozu die vierte Stufe existiert

Die Architektur ist erst vollstaendig, wenn man weiss, wofuer gemessen wird. Owner, verbatim, `live 7601` (23:10:06Z) — **KERN 1**:

> „Korrekt. Die **erste Stufe der Rangbildung** ist, dass die **Tier-binaries einfach direkt drangehaengt werden**. Aber was passiert bei **gemischten Lasten des Suchalgorithmus**? Dann muss dieser **jede Linie an Last-Kanaelen einwandfrei unterstuetzen** und das braucht dann **nicht nur eine, sondern multiple optimale binaries je Last-Kanal**, daher der **Hybrid-Schaltungs-Adapter dazwischen, der die richtige Tier-Binary waehlt**."

```
  STUFE 1 (homogene Last):    EINE beste Binary je Schnitt, direkt drangehaengt
  STUFE 2 (gemischte Lasten): jede Linie an Last-Kanaelen muss getragen werden
                              -> MULTIPLE optimale Binaries, je eine pro Kanal
                              -> HYBRID-SCHALTUNGS-ADAPTER waehlt
```

Damit ist erklaert, warum die Auswertung eine **Funktionalitaets-Voraussetzung** ist und nicht Nachbereitung (`bak 3597`, 23:06:15Z: „**Das ist ein Teil der Hybrid-Binary Definition und deren Funktionalitaet-Voraussetzung**"): **ohne die Synthese weiss der Adapter nicht, welche Binary fuer welchen Kanal optimal ist.** Er ist kein Zwischen-Layer, sondern der Schalter zwischen mehreren gemessenen Optima.

Das erklaert rueckwirkend auch die GoF-Beschreibung aus mittag-10 als **Bauanleitung** statt als Muster-Aufzaehlung: **Factory** (haelt die passende Binary) · **Facade** (der Aufrufer sieht EINE Schnittstelle) · **Adapter** (dahinter mehrere Tier-Binaries). Und die Vererbungs-Zeile aus mittag-9 („erben sie ALLE Eigenschaften vorausgegangener Stufen") ist keine Formalie: er **muss** deren Ausstattung kennen, um zwischen ihnen schalten zu koennen. Er traegt Mess- und System-Stempel seiner Kette, aber **keine Organ-Permutations-Identitaet** — `binary_id` bleibt Organ-only bei echten Tiers.

Die Auswertungs-Kette selbst — Messwerte → Funktions-Synthese → Schnitt-Kurven → optimale Konfiguration ≙ die zu waehlende Binary — und die drei Benchmark-Ebenen sind Gegenstand von **Kapitel II**. Fuer die Architektur genuegt der Schluss-Satz des Owners (`bak 3691`, 23:14:14Z): die optimale Konfiguration ist „**aequivalent mit der zu waehlenden Binary**" — der Adapter braucht **keine Empfehlung, sondern die Schnittpunkte**. **Die Auswertung produziert eine Schaltlogik, keinen Rat.**

---

### I.9 Bilanz: was von dieser Architektur heute steht

Erhebung 07.08.2026, ce `c4c04315` / super `5a98036d`.

| Bestandteil | Zustand | Beleg / Nenner |
|---|---|---|
| Kette Planer → CEB → Tier | **gebaut, dreigliedrig** | I.2.2 |
| Vierte Stufe (Hybrid) | **reserviert, 0 Code** | `hybrid/README.md`, 1 Datei (an `c4c04315` nachgezaehlt); `hybrid` in `CMakeLists.txt` = 0 bei 5 `add_subdirectory` |
| Stufen-Doktrin je Achsen-Art | **doktrinaer vollstaendig, Owner-abgenommen** | Ledger `:4082`/`:4090`, mittag-9/-10/-11 |
| Mess-Achse Stufe 1 (Planer-Freigabe) | **gebaut, wirkt heute nur als Lane-Scheduling** | `experiment_plan_director.hpp:102-107`, `:600-602` |
| Mess-Achse Stufe 2 (CEB-CT-Einbau der WAHL) | **geheilt und gelandet** | M-1/D-1 `b9fd81ff`, D-4 `62a5b6f7`, Merge `bba4d90f` |
| Mess-Achse Stufe 3 (Tier-Deklaration + Leser) | **erster Leser gebaut** | M-1/D-2 `246b2793` (`mess_konsistenz_gate.hpp`) |
| PMC-Pflicht als Invariante | **gelandet, 4/4 Bissbeweis** | `8894d983` |
| PMC-Ehrlichkeit L2/L3/coherence/energy | **gelandet in dieser Nacht** | `5c102e05` / `c4c04315`; `pmc_source.hpp:37-43` |
| PMC `branch_misses` (M-3a) | **offen** | keine Quelle schreibt das Feld; einzige Zuweisung ist eine Kopie (`measurement_snapshot.hpp:145`) |
| **PMU-Domaenen-Trennung P/E** | **fehlt** | `cpu_atom` in `libs/` = **0**; Gegenprobe `perf_event_open` = **18 ueber 4 Dateien** |
| Hybrid-Erkennung | **Vokabular da, bewusst leer** | `i_platform_probe.hpp:15,19,20`; `cpuid_platform_probe.hpp:38-39` |
| Pinning-Aktuator | **gebaut, kein Aufrufer im Mess-Loop** | `thread_pinning.hpp` (105 Z.) |
| **Pinning-Permutation (Doppelstart)** | **fehlt** | kein Doppelstart; Planer-Abfrage fehlt |
| `numa_cpu_pin_process_probe` | **fehlt** | 11 `sub_axis`-IDs, keine mit „core"; ce-Anteil ungelandet (`b4cebdc4`), super-Anteil **uncommittet** |
| Warntext `warn: no pinned locality on hybrid architecture` | **nicht im Code** | 0 Treffer; Gegenprobe `sched_setaffinity` = 2 |
| Schwere-Leiter als **Typ** | **fehlt** — die Zell-Zustaende gibt es | `axis_error.hpp` (655 Z.), aber `fatal\|warn` als Stufen-Typ = 0 |
| Wallclock E1 | **gebaut, aggregiert + synthetisch** | I.7.3 |
| Wallclock E2 | **gebaut, nicht auf dem Dock** — Kriterium strittig, siehe W-3 | I.7.3 |
| Wallclock E3 | **fehlt** | I.7.3 |
| Pruef-Dock als Messort | **gebaut, produktiv umfahren** | `IPruefDock::measure()` = 0 Prod-Aufrufer |
| Auswertung / Break-Even | **Bibliothek gebaut, 0 Treiber** | Kapitel II.8.1 |

**Die Reihenfolge der offenen Posten ist nicht Geschmack, sondern Abhaengigkeit:** der Hybrid-Adapter braucht die Break-Even-Rechnung, die braucht Micro- und Macro-Benchmarks, die brauchen die Messung, und die braucht **vorher** die getrennte Ablage je PMU-Domaene und die ehrlichen Zaehler-Zustaende — sonst tragen die Daten falsche Semantik und das Nachziehen erzeugt einen unsichtbaren Datenbruch. Ausgefaltet in **Kapitel IV.3**.

---

### I.10 Was offen ist — und nur der Owner entscheiden kann

1. **Gehoert die PMU-Domaene (P-/E-Kern-Klasse) in die Mess-IDENTITAET?** Der Reproduzierbarkeits-KERN (`bak 1738`, Frage 6) lautet verbatim: „die gleiche binary auf der selben Maschine mit den selben Messachsen liefert **identische Ergebnisse uneingeschraenkt**, das ist die **Hauptidee des Systems und des Lagers**." Auf einer Hybrid-CPU koennen aber **zwei Kerne derselben Maschine** verschiedene Zaehler liefern — „selbe Maschine" ist dort nicht mehr fein genug. Der Permutations-KERN (I.5) entschaerft das weitgehend, weil `binary_id="never"` einen Neubau strukturell ausschliesst; die Frage nach der **Identitaet der Messzeile** bleibt. **Fensterkritisch:** heute kostet die Entscheidung 0 h; nach dem ersten Batch kostet sie den Neubau plus alle bis dahin erhobenen Messdaten. *(Gefuehrt als **D-1** in Kapitel V.6.4.)*
2. **„Drittes Glied" — Stempel-Glied [3] oder drittes Kettenglied?** (I.7.4)
3. **Die M-1-Zuordnung `wallclock → nur G1`** — sie widerspricht dem KERN und ist am Objekt widerlegt (I.7.5).
4. **Ebene 2 „AUF dem Pruefdock"** — wandert der bestehende Messpunkt dorthin, oder **testiert** das Dock ihn nur? Der heutige Vertrag (`pruef_dock.hpp:74-79`) erlaubt beide Lesarten. **Und: welches Akzeptanzkriterium gilt** — Zeitpaar je Aufruf oder Checkpoints darin? *(Abschnitt 0 / W-3.)*
5. **Die Verortungs-Zeile (`live 7776`) ist im Ledger nicht nachgetragen** — sie kam 6 Minuten nach dem Konsolidierungs-Auftrag.

---

## KAPITEL II — VON DER MESSUNG ZUR BINARY-WAHL

> **Stand aller Ist-Angaben:** eigene Erhebung am Objekt, **2026-08-07, 00:15–00:40 Z**, gegen ce `development` = **`c4c04315`**, thesis `19e15920`, Ledger 7248 Zeilen. Alle `grep` als `/usr/bin/grep`, durchgaengig `-i`, Verzeichnisse als Positivliste statt `-v`.
> **Wo dieses Kapitel nur verweist:** die Einzelbefunde stehen ausgeschrieben in `docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md` (825 Z.), `docs/plaene/20260806-PLAN-messkurven-synthese-und-hybrid-binary.md` (768 Z., **seit super `1aba34f8`/00:30:30 Z versioniert**, zum 00:20-Messstand noch untracked) und `LEDGER` Nachtrag **abend-4**, Abschnitte 9–12.

### II.1 Vier Owner-Nachrichten in einundvierzig Minuten

Zwischen 23:06 und 23:47 des 06.08. hat der Owner die Auswertungs-Kette in vier Nachrichten vollstaendig ausgesprochen. Sie standen bis dahin verstreut in Termin-Dokumenten, Memory-Dateien und Ledger-Paragraphen — **nirgends im Zusammenhang**. Sie sind die Spezifikation dieses Kapitels und stehen vollstaendig als **KERN 1, 2, 11 und der Nachtrag O-100** in Kapitel VI.

**O-095 · 23:06:15Z · typed · live 7563 · bak 3597** — *die Terminlage und die Rolle:*

> „Nun die geplante Auswertung der Binaries mit bestimmen der besten Binaries aus der Messkurven-Synthese ist ja nach der Abgabe morgen dran und sie ist ebenfalls detailliert geplant. **Das ist ein Teil der Hybrid-Binary Definition und deren Funktionalitaet-Voraussetzung**"

**O-096 · 23:14:14Z · queued · live 7657 · bak 3691** — *die Kette:*

> „Korrekt und die Auswertung braucht wiederum die Messwerte, aus der sie **Funktions-Synthese** und optimale Verarbeitung durch **Schnitt-Kurven zwischen den Parametern verschiedener Achsen und Gattungs/Genus-Funktionsinterfaces** ableiten kann. Die Messung fuehrt zur Funktions-Synthese und diese zum erkennen der **optimalen Konfiguration der Tier-Binaries, was aequivalent mit der zu waehlenden Binary ist**"

**O-097 · 23:20:06Z · typed · live 7675 · bak 3709** — *der Name des Verfahrens und die drei Ebenen:*

> „Korrekt: das ist als **‚break even'** geplant. **Es gibt Schnittpunkte zwischen Parameter-Funktionskurven, die anzeigen, wann ein Algorithmus in einem Parameter ueber eine Achse als Organ effektiver wird.** Wenn wir das mit gemischten **Micro-Benchmarks** ueber alle Achsen (siehe Parameter Benchmarks der Achsen) und **Macro-Benchmarks** (siehe alle Achsen Parameter bei Aufruf einer beliebigen Funktion der verwendeten Achsen einer Gattung+Genus -> Gesamt-Messprofile timed einer Funktion ueber die Schritte und checkpoints ihrer Ausfuehrung zur Detail-Analyse ueber alle Achsen die sie verwendet hat) und **Macro-Benmarking large scope** ueber die Gesamtheit der Macro-Benchmark charts ALLER fuer ein Lastprofil aufgerufenen Gattung+Genus Funktionen auf dem Tier-Binary interface. Bitte explore Agent dazu, das ist geplant und muss dokumentiert werden."

**O-100 · 23:47:31Z · queued · live 7889** *(ausserhalb des gesicherten Transkripts)* — *die Rollen-Korrektur:*

> „break even ist korrekt und **der best_binary_selector hat eigentlich ganz andere Aufgaben, und zwar die messwerte nehmen und die Orchestration der Auswahl und Berechnung ueber das Lager durchfuehren.** Zu Punkt B: Dann gerne Rueckfragen um die Planung zu vervollstaendigen, **weil diese Plaene 6 Wochen alt sind**"

Vier Saetze, vier verschiedene Ebenen: **wann** (nach der Abgabe), **was** (die Kette), **wie** (Break-Even), **wer** (die Arbeitsteilung). Die letzte war eine Korrektur — der Lead hatte `best_binary_selector` fuer den Break-Even-Rechner gehalten.

---

### II.2 Die Kette, Glied fuer Glied

Das Kettenbild steht in **I.1** und wird hier nicht wiederholt. Was hier zaehlt, ist der Zustand jedes Gliedes (Ledger `:4229`):

| # | Glied | Gegenstand | Traeger im Code | Zustand 07.08. |
|---|---|---|---|---|
| 1 | **Messwerte** | reale Mess-CSV | `builder/experiment_tree/cache_engine_builder_iterator.hpp` (173 Spalten) | GEBAUT, **16 Zeilen erhoben** |
| 2 | **Einlesen** | (x,y)-Reihen je Gruppe | `heuristik/measurement_curve_loader.hpp` (12,1 kB) | GEBAUT |
| 3 | **Funktions-Synthese** | f(x) je Achsen-Variante | `heuristik/axis_spline.hpp` (13,6 kB) | GEBAUT, **zweifach** |
| 4 | **Schnitt-Kurven** | Break-Even-Punkte | `heuristik/break_even.hpp` (6,8 kB) | GEBAUT, **zweifach** |
| 5 | **optimale Konfiguration** | Rueckwaerts-Wahl je Last | `builder/best_binary_selector/` (50,1 kB) | GEBAUT als **SKELETON** |
| 6 | **Hybrid-Schaltlogik** | Adapter je Last-Kanal | `libs/cache_engine/hybrid/` | **1 README, 0 Code** |

Der entscheidende Satz von O-096 ist der letzte Halbsatz: **„aequivalent mit der zu waehlenden Binary"**. Er sagt, dass am Ende der Kette keine Empfehlung steht, sondern eine Schaltbedingung. Der Ledger buchstabiert es aus (`:4536`):

> „**Der letzte Halbsatz ist die Bruecke:** *‚aequivalent mit der zu waehlenden Binary'* — der Hybrid-Adapter braucht **keine Empfehlung**, sondern **die Schnittpunkte**. Sie sagen ihm, bei welchem Last-Kanal er umschaltet. **Die Auswertung produziert eine Schaltlogik, keinen Rat.**"

Warum die Kette keine Nachbereitung, sondern **Funktionalitaets-Voraussetzung** der vierten Stufe ist, steht in **I.8** (Owner-KERN 1, die Rangbildung in zwei Stufen). Die Reihenfolge ist damit keine Geschmacksfrage: **B-10 braucht B-9 braucht B-7/B-8 braucht die Messung braucht B-3/B-5** (Ledger `:4642`).

---

### II.3 Break-Even ist ein Kipppunkt, kein Optimum

Das ist die begriffliche Mitte des Kapitels, und sie wird leicht ueberlesen.

Ein Optimum beantwortet *„welche ist die beste"*. Ein Break-Even beantwortet *„ab wo ist welche besser"*. Der Owner formuliert es in O-097 als Wirkungsaussage: Schnittpunkte, *„die anzeigen, **wann** ein Algorithmus in einem Parameter ueber eine Achse als Organ effektiver wird"*.

Der Code traegt genau diese Semantik — und zwar in der Datenstruktur selbst. `libs/cache_engine/heuristik/break_even.hpp:43-48`:

```cpp
struct BreakEvenPoint {
    double x             = 0.0;        ///< Schnittpunkt-Position (Parameter-Achse)
    double y             = 0.0;        ///< Funktionswert am Schnittpunkt (Mittel aus f,g)
    Curve  links_besser  = Curve::Tie; ///< welche Kurve unmittelbar LINKS niedriger liegt
    Curve  rechts_besser = Curve::Tie; ///< welche Kurve unmittelbar RECHTS niedriger liegt
};
```

**Zwei Sieger, kein Sieger.** Der Typ kann gar keinen Gesamtsieger ausdruecken; er drueckt einen Fuehrungswechsel aus. Dieselbe Form auf der zweiten Seite, `best_binary_selector.hpp:321-327`: `winner_below` / `winner_above`.

Die Konvention, was „besser" heisst, ist hart fixiert (`break_even.hpp:17`):

> „KONVENTION ‚besser' = KLEINERER y-Wert (Performance: niedrigere Latenz/Kosten ist besser)."

**Das ist zugleich eine bekannte Verengung.** Die Owner-Doktrin „Min/Max → Heuristik" (09.07.) verlangt je Achse eine **Optimierungs-Eigenschaft = Min ODER Max**; Max-Achsen (etwa Kompressionsverhaeltnis von Nodes) sind von `break_even.hpp:17` nicht abgedeckt. Der Ledger fuehrt den Min/Max-Entscheid als **Deep-Research-Posten „nach Trigger / vor Auswertung"**. Fuer dieses Kapitel heisst das: die Break-Even-Mathematik ist heute **einseitig kalibriert** und weiss es.

Die Mathematik selbst ist seit dem 19./20.07. als Owner-Text festgeschrieben, `LEDGER:2301`:

> „**Ergaenzung F8 — Break-Even-Mathematik:** Switch-Thresholds = **Schnittpunkte zwischen den f(x)-Spline-Funktionen** der Performance-Modellierungen zweier Algorithmen derselben Achse (Beispiel: Allokatoren fuer grosse vs kleine Dateien — Kurven uebereinandergelegt ergeben den Break-Even-Punkt). Da eine **voll permutierte Baum-Matrix** aufgebaut ist, ist der **Messwert-Diff jeder Ebene** bekannt und **gegen andere Parameter isolierbar** → ein **vollstaendig isolierbares Modell aus jeder einzelnen gemessenen Organ-Achse**."

Status im Ledger (`:2958`): *„Break-Even = Spline-Schnittpunkte (**ENTSCHIEDEN / IMPL-OFFEN**, hoch)"*. Abgabe-Klassifikation (`:2296`): **ABGABE-PFLICHT**.

#### II.3.1 Das Verfahren — weder Regression noch reine Interpolation

`break_even.hpp:10-15`, verbatim:

> „VERFAHREN: d(x) = f(x) - g(x). Auf dem UEBERLAPPUNGS-Intervall [max(f.x_min,g.x_min), min(f.x_max,g.x_max)] wird ueber die **Vereinigung beider Knoten-Gitter** ein gemeinsames, aufsteigend sortiertes Auswerte-Gitter gebildet. Je aufeinanderfolgendem Segment-Paar [a,b] entscheidet der **Vorzeichenwechsel** von d: sign(d(a)) != sign(d(b)) -> genau eine Nullstelle im Inneren -> **BISEKTION** (deterministisch, feste Iterationszahl) auf d==0."

Also: **Interpolation als Modell, Bisektion als Nullstellensuche.** Kein Fit, keine Ausgleichsrechnung, keine Iteration mit Abbruchkriterium — 100 feste Bisektionsschritte (`:125`), exakte Knotentreffer separat und ohne Doppelzaehlung erfasst. Determinismus ist hier kein Luxus: ein Switch-Threshold, der zwischen zwei Laeufen wandert, ist als Schaltbedingung unbrauchbar.

**Honest-empty ist eingebaut, nicht nachgeruestet.** Keine Ueberlappung der Definitionsbereiche → `return out` mit dem Kommentar *„kein Break-Even (ehrlich leer)"* (`:80`). Weniger als zwei Stuetzstellen → `std::nullopt` (`axis_spline.hpp:206`). Beides ist die Ausgabe-Richtung des Owner-KERNs „stiller Rueckfall geht fuer uns nicht" (KERN 10): Es wird nichts erfunden.

**Bewiesen ist das Verfahren am Owner-eigenen Beispiel.** `tests/unit/test_heuristik_spline_break_even.cpp:28-59` nimmt den Allokator-Fall aus `LEDGER:2301` woertlich — `f_A(x) = 50 + 2x` gegen `f_B(x) = 170 + 0,5x`, analytisch `x = 80, y = 210` — und prueft nicht nur die Position, sondern die **Fuehrungsrichtung**: `EXPECT_EQ(p.links_besser, Curve::F)`, `EXPECT_EQ(p.rechts_besser, Curve::G)`. Der Test misst also die Kipppunkt-Eigenschaft, nicht bloss die Nullstelle.

---

### II.4 Break-Even ist die operative Form von H2

Das ist die Verbindung, die dem Kapitel seine wissenschaftliche Rechtfertigung gibt — und sie ist am Termin-Text belegbar, nicht behauptet.

Hypothese **H2**, eingefroren am **30.03.2026** (Termin 1), verbatim:

> „**H2: Es gibt keine universell beste lokale Seitendarstellung**; die beste Wahl haengt von lokaler Dichte, Praefixstruktur, Zugriffsmix, Anwendungsdatensatz und Zielarchitektur ab."

Und die Forschungsfrage aus dem Exposé vom **26.03.2026**:

> „Wie sollten direkte, kompakte und HOT-inspirierte Patricia-/Mehrbit-Seiten kodiert werden, und **wann sollte zwischen ihnen umgeschaltet werden?**"

Der Schluss ist zwingend und steht so im Ledger (`:4606-4612`): **Wenn es keine universell beste gibt, ist „welche ist die beste" die falsche Frage. Die richtige lautet „ab wo ist welche besser" — und genau das liefert ein Schnittpunkt.** H2 wird dadurch von einer plausiblen Behauptung zu einer messbaren.

Die Termin-Reihe zeigt, dass der Gedanke **vier Termine lang gereift** ist, unter einem anderen Wort — dort heisst Break-Even durchgaengig **Umschaltpunkt** oder **Schwellwert**:

| Termin | Datum | Zitat | Bedeutung |
|---|---|---|---|
| **1** | 26./30.03. | „wann sollte zwischen ihnen umgeschaltet werden?" · H2 · „**Kriterien bzw. experimentelle Schwellen fuer den Wechsel zwischen Seitentypen**" | die Frage wird gestellt und eingefroren |
| **2** | 05.04. | Invariante **I5**: „Seitentyp-Umschaltungen sind explizite Policy-Entscheidungen; **feste universelle Schwellwerte werden nicht behauptet.**" · Risiko: „**Schwellwerte kippen je CPU**" | Konstanten werden ausdruecklich **verboten** |
| **3** | 09.04. | „Value-Modi \| inline, external handle \| **Umschaltpunkt explizit vermessen**" · „**Umschaltpunkt als eigene Messachse**" | der Umschaltpunkt wird **Messgegenstand** |
| **4** | 12.04. | „der **Umschaltpunkt wird global, pro Seitentyp und pro Node-Familie parametrierbar** gedacht" | er wird **parametrierbar** |
| **6** | 16.04. | drei Kalibrierungs-Modi; Kalibrierungs-Familie liefert „L1/L2/L3/DRAM-**Knicke** … **Grundwahrheiten fuer Schwellen**" | die **Erhebung** der Schwellen wird geplant |

Und der Literatur-Anker: `docs/termine/…/_review/papers/P14-Samuel2005.md:44` traegt die Ueberschrift **„Crossover Points"**, der Fliesstext: *„the **crossover** between a node size where linear [search is] beneficial depends on key size. With 8B keys, the **crossover point** [~384B] … 512B."*

**Ein methodischer Vorbehalt, der dazugehoert.** Der Begriff *break even* selbst kommt in `docs/termine/` **nicht vor** — Nenner **309 Dateien**, davon **38** `.docx`/`.pptx` volltext-entpackt; Muster `break.{0,2}even|schnittpunkt|kipppunkt` case-insensitiv → **0**. Gegenprobe am selben Entpack-Pfad: `benchmark` = **24 von 38**, `mikrobench|microbench` = **13 von 38**. Die Suche greift; die Null ist echt. Break-Even ist damit **Projekt-Vokabular fuer eine Betreuer-Anforderung**, nicht selbst Betreuer-Auftrag. Das ist keine Schwaeche — die Anforderung ist viermal schriftlich gestellt —, aber es muss so benannt werden.

---

### II.5 Die drei Benchmark-Ebenen und was jede beitraegt

O-097 nennt drei Ebenen. Sie sind nicht drei Genauigkeitsgrade derselben Messung, sondern **drei verschiedene Gegenstaende**.

| Ebene | Gegenstand | Owner-Definition (O-097, verbatim) | Beitrag zum Break-Even |
|---|---|---|---|
| **MICRO** | eine **Achse** | „gemischte Micro-Benchmarks ueber alle Achsen (siehe **Parameter Benchmarks der Achsen**)" | liefert die **Kurven, die geschnitten werden** — f(x) je Achsen-Variante |
| **MACRO (timed)** | eine **Gattungs+Genus-Funktion** | „Gesamt-Messprofile **timed** einer Funktion **ueber die Schritte und checkpoints ihrer Ausfuehrung** zur Detail-Analyse **ueber alle Achsen die sie verwendet hat**" | liefert die **Zurechnung**: welche Achse hat innerhalb des Aufrufs die Zeit gekostet |
| **MACRO large scope** | ein **Lastprofil** | „ueber die **Gesamtheit der Macro-Benchmark charts ALLER** fuer ein Lastprofil aufgerufenen Gattung+Genus Funktionen **auf dem Tier-Binary interface**" | liefert den **Last-Kanal**, fuer den der Hybrid-Adapter schalten muss |

**Warum die mittlere Ebene die anspruchsvollste ist**, sagt der Ledger (`:4600-4605`):

> „Checkpoints **innerhalb** einer Funktion. Damit misst man nicht mehr ‚die Funktion war X ns schnell', sondern **wo innerhalb ihrer Ausfuehrung welche Achse Zeit gekostet hat**. Erst das macht Break-Even auf **Achsen**-Ebene bestimmbar — sonst wuesste man nur, **dass** eine Konfiguration besser ist, nicht **warum**."

Das ist der Punkt, an dem die drei Ebenen aufeinander angewiesen sind: **Micro liefert die Kurven, Macro-timed liefert die Ursache, large scope liefert den Anwendungsfall.** Faellt die mittlere aus, bleibt Break-Even auf der Binary-Ebene stehen und wird nie zur Achsen-Aussage — genau das, was H2 verlangt.

> ⚠ **Hier liegt der Widerspruch W-3 aus Abschnitt 0.** Kapitel I fuehrt dieselbe mittlere Ebene (dort E2) als **gebaut**, weil es das Kriterium des spaeteren Owner-Satzes (23:26:59Z: „fuer jeden Funktionsaufruf") anlegt. Dieses Kapitel fuehrt sie als **fehlend**, weil es das Kriterium des frueheren Satzes (23:20:06Z: „ueber die Schritte und **checkpoints**") anlegt. Beide Messungen halten; **das Abnahmekriterium ist unentschieden.**

**Die Aufbaurichtung ist im Plan methodisch begruendet**, nicht bloss gereiht. Thesis `kapitel/de/03_messsystem_prtart.tex:1315-1318`:

> „Genau diese Methodik ist die Antwort auf das **Trennbarkeits-Problem**: Indem jeder Bestandteil **zunaechst isoliert ueber sein Achsen-Interface vermessen wird, bevor er im Operations- und Gesamt-Kontext erscheint**, werden die Beitraege getrennt messbar, statt im Gesamtdurchsatz vermengt zu bleiben."

Dazu die quantitative Klammer als Invariante, `ce/docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md:229-230`: **Σ(E1-konstitutiv) ≤ E2 ≤ E3**, „jeder Rest EXPLIZIT benannt (framework/orchestration)". Die Ebenen sind also nicht nur geordnet, sie sind **gegeneinander pruefbar** — eine Verletzung der Ungleichung ist ein Messfehler-Signal.

#### II.5.1 Ein Namens-Konflikt, der geklaert gehoert

Es existieren **drei Triaden**, die alle „drei" heissen (die vollstaendige Verwechslungskarte mit vier Dreien steht in **I.7.2**):

1. **Die drei Granularitaeten** Micro / Makro / Gesamt — gesetzte Aufgabenstellung, `aufgabenstellung/de.tex:87-96`.
2. **Die drei Wallclock-Ebenen** E1 / E2 / E3 — F2-Gesetz, Owner 01.08., ausdruecklich als **Gegenprobe** zur internen Mikro-Messung, also *zusaetzlich*.
3. **Die Mess-Tooling-Haupt-Achse** `{WallClock, Macro, Micro}` — `measurement_tooling_registry.hpp:27-31`.

**Die Owner-Ebenen sind (2), nicht (3).** Drei Gruende, alle am Objekt: `WallClock` ist ein Instrument, kein Granularitaetsrang; die Registry deklariert `Micro` selbst als *„feinkoernige PMC/Counter-Instrumentierung"* (`:30`) und widerspricht damit F2, das Micro als **Achsen-Interface** definiert; und die Ebene „Lastprofil" hat in der Achse **kein Gegenstueck**.

Die Thesis setzt (3) mit (1) gleich — `03_messsystem_prtart.tex:992` — und ihr **eigenes Kapitel 4 stellt das bereits richtig**, `04_implementierung.tex:499-502`: *„**Dieser Registry-Schnitt ist Implementierungs-\emph{Stand}, nicht Soll**"*. Zwei eingebundene Kapitel, zwei Aussagen. Der Ledger fuehrt die Abgrenzung als **offen** (`:4655`).

> **🔴 Eigener Befund, 07.08.: die Begruendung dieser offenen Frage ist seit 00:06 ueberholt.** Die Klaerung stuetzte sich darauf, dass `MeasurementTooling::` **0 funktionale Konsumenten** habe. Heute gemessen ueber `libs apps tools tests adapters modules`: **8 Treffer** — 3 in der Registry-Tabelle selbst, 1 in einem Test, und **4 produktive** in `libs/cache_engine/profile_facade/mess_achsen_naht.hpp:363,364,422,558`. Diese Datei stammt aus **M-1/D-1** (`b9fd81ff`, gelandet in `bba4d90f` um 00:06) und ist real eingebunden von `profile_run_facade.cpp:25` und `lazy_adhoc_source_gen.hpp:77` — beides Produktionspfade. Ihr eigener Kopf benennt den geheilten Defekt: *„Eine [wallclock]-Binary und eine [micro]-Binary bekamen byte-gleiche Compile-Kommandos und damit identische Mess-Ausstattung — ihr Stempel behauptete Verschiedenes. **Der Stempel log.**"* — **Die Mess-Tooling-Achse hat seit heute Nacht Wirkung.** Die Abgrenzungsfrage bleibt offen, aber ihr staerkstes Argument ist weggefallen und muss neu gestellt werden.

---

### II.6 Die Arbeitsteilung — und was O-100 wirklich korrigiert

**Was `best_binary_selector` nach O-100 tun soll:** (1) „die messwerte nehmen", (2) „die Orchestration der Auswahl und Berechnung ueber das Lager durchfuehren".

**Was er heute tut** — verifiziert am Objekt, ce `c4c04315`:

| Aufgabe | Traeger | O-100-Deckung |
|---|---|---|
| Messwerte nehmen | `parse_measurement_csv` (strikt, nur `two_phase_valid`-Zeilen) | ✅ |
| Orchestrierung ueber das Lager | `TiereDllRepository` (binary_id → `perm.dll` via `orch_make_stem`) + `ShippedArtifactBuilder` (DLL-Kopie, `.version`/`.algos`-Sidecars, Manifest mit ABI-Major/Minor/Magic) | ✅ |
| Auswahl | `rank_binaries` — **stratifiziert je Mess-Zelle**, Zellschluessel `workload\|working_set_n\|platform\|build_version\|series\|setting` (`hpp:143`), Aggregation `median_of_cell_medians(nearest_rank_lower)` (`cpp:380`), unvollstaendige Kandidaten werden **disqualifiziert statt bevorteilt** (`hpp:208-213`) | ✅ |
| **Berechnung** | — ruft die Splines **nicht** an: `/usr/bin/grep -c -i "axis_spline\|heuristik/"` ueber `best_binary_selector.hpp` **= 0**, ueber `.cpp` **= 0** | ❌ |

**Die Mathematik liegt woanders**, und dort ist sie sauber gebaut: `heuristik/break_even.hpp` + `heuristik/axis_spline.hpp` + `heuristik/measurement_curve_loader.hpp`. Diese drei Flaechen stehen unter **§75-Nicht-Kandidaten-Schutz** (`LEDGER:3602`), duerfen im Aufraeumpass „**weder entfernt noch umbenannt**" werden, Begruendung: „**Speisung des Break-Even-Routers HY-B2**". Der Owner hat die Arbeitsteilung also nicht erfunden, sondern **erinnert**: sie steht seit dem 02.08. im Ledger.

#### II.6.1 Der eigentliche Ertrag von O-100: eine zweite Break-Even-Implementierung wird zum Fremdkoerper

`best_binary_selector` traegt **einen eigenen, zweiten Break-Even-Rechner**. Beide existieren gleichzeitig, im selben Repo, mit unterschiedlichem Kurvenmodell:

| | `heuristik::BreakEvenPoint` | `best_binary::BreakEvenPoint` |
|---|---|---|
| Datei | `heuristik/break_even.hpp:43-48` | `best_binary_selector.hpp:321-327` |
| Felder | `x, y, links_besser, rechts_besser` (`enum Curve`) | `x, cost, winner_below, winner_above` (`std::string`) |
| Kurvenmodell | **monotone kubische Hermite (Fritsch-Carlson)** | **stueckweise linear** + lineare Extrapolation (`cpp:437-442`) |
| Auswerte-Gitter | **Vereinigung der echten Knoten** beider Splines | **festes 256-Raster** (`hpp:345`) |
| Bisektion | **100** Iterationen, `y_tol`-Toleranz | **60** Iterationen, exakter `!= 0.0`-Vergleich (`cpp:478`) |
| §75-geschuetzt | ja, + CI-Tripwire | nein |

Der Selektor deklariert seinen Zustand selbst (`:263`, `:274-276`): „HYBRID-BREAK-EVEN-SELEKTOR-**SKELETON** … der Kandidaten-Kurven-Traeger ist hier ein std-only **STUECKWEISE-LINEARES** Modell ueber **SYNTHETISCHEN** Stuetzstellen".

Das ist ehrlich deklariert — und trotzdem ein Risiko: **das feste 256-Raster kann Schnittpunkte zwischen zwei Rasterpunkten ueberspringen**, die das knotenbasierte Gitter der ersten Implementierung strukturell findet. Und das stueckweise lineare Modell ignoriert genau die numerische Begruendung, mit der die erste ihr Verfahren waehlt (§II.7). Das SOLL-Design legt den Router auf die **erste** fest (`20260802-hybrid_tier_stufe_soll_design.md:195`) — die zweite ist damit ein **ungegateter Parallelpfad**.

> **Lesart, die dem Owner vorzulegen ist (kein Faktum, ein Entscheid):** Wenn `best_binary_selector` „Messwerte nehmen und ueber das Lager orchestrieren" ist, dann gehoert ihm die Break-Even-**Rechnung** nicht — dann ist die zweite Implementierung eine Zustaendigkeits-Ueberschreitung, die entweder gestrichen oder ausdruecklich als Uebergangs-Geruest befristet werden muss.

#### II.6.2 Und die dritte Definition, die niemand aufgeloest hat

Es gibt **drei nebeneinanderstehende Antworten auf „was ist die beste Binary"**:

- **(A) Ist:** genau **ein** globaler Sieger je Metrik, ueber alle Workloads und Working-Sets gemittelt (`rank_binaries`). Wer entscheidet: der Bediener, per `--metric`.
- **(B) Soll (F8/Owner):** **eine beste Binary je Eingangslast**, und ueber multiple Lasten multiple beste Binaries. Owner verbatim, `LEDGER:4176` (05.08.): *„die **Messwerte zu Messkurven synthetisiert**, die **Messskurven je Eingangslast verglichen**, um die **beste binary zu finden** […] An dieser stelle koennen dann auch **ueber multiple Lasten multiple beste Binaries** bestimmt werden"*.
- **(C) Pareto:** eine **Front-Menge** nicht-dominierter Konfigurationen statt eines Einzelsiegers, mit Objective-Tag und „**getrennte Kurvenscharen je Objective, keine Mittelung**" — `docs/audits/20260710-kardinalitaeten-deep-research-BEFUND-KARDINALITAETEN.md:158`, verbucht als Fork **§H-6**.

(A) und (B) unterscheiden sich in der Kardinalitaet des Ergebnisses; (A) und (C) widersprechen sich frontal. **Das ist ein Owner-Entscheid, kein Bau-Posten.**

---

### II.7 Die Fritsch-Carlson-Wahl und warum sie noetig ist

Von allen Verfahrensentscheidungen der Kette ist diese die am besten begruendete — und sie ist es, weil sie **aus der Break-Even-Korrektheit hergeleitet** wurde, nicht aus Glaettungs-Aesthetik.

`libs/cache_engine/heuristik/axis_spline.hpp:15-25`, verbatim:

> „**VERFAHRENS-WAHL (numerisch begruendet): DEFAULT = monotone kubische Hermite (Fritsch-Carlson 1980)** — Performance-Kurven (Latenz ueber Working-Set / Value-Size) sind auf ihren Segmenten typisch MONOTON. Ein NATUERLICHER kubischer Spline erzwingt C2-Glattheit global und kann zwischen zwei Stuetzstellen **UEBERSCHWINGEN** (Oszillation / kuenstliche lokale Extrema), obwohl die Daten dort monoton sind. **Diese falschen Extrema erzeugen SCHEIN-Schnittpunkte im Break-Even-Finder -> falsche Switch-Thresholds.** Fritsch-Carlson begrenzt die Hermite-Steigungen (alpha^2+beta^2 <= 9 je Segment) und GARANTIERT damit die Monotonie-Erhaltung auf jedem Segment, auf dem die Daten monoton sind. Fuer Break-Even-Mathematik ist das die korrekte Wahl: **kein kuenstlicher Nulldurchgang von f-g.**"

Die Argumentationskette in vier Schritten:

1. Ein natuerlicher kubischer Spline erzwingt **globale C²-Glattheit**. Um sie zu erreichen, muss er zwischen Stuetzstellen ausschwingen.
2. Ein Ueberschwinger erzeugt ein **kuenstliches lokales Extremum** — eine Delle oder Spitze, die in den Daten nicht steht.
3. Break-Even sucht die Nullstellen von `d(x) = f(x) − g(x)`. Eine kuenstliche Delle in `f` kann `d` ein **zusaetzliches Mal** durch null fuehren.
4. Jeder solche Nulldurchgang wird zu einem **Switch-Threshold**, an dem der Hybrid-Adapter umschaltet. **Ein Interpolations-Artefakt wuerde zu einer Schalthandlung in der ausgelieferten Binary.**

Deshalb: Monotonie-Erhaltung ist hier keine numerische Feinheit, sondern eine **Korrektheitsbedingung der Auslieferung**. Fritsch-Carlson kauft sie mit dem Verzicht auf C² — die Kurve ist nur noch C¹. Fuer einen Kipppunkt-Finder ist das der richtige Tausch: Break-Even braucht Vorzeichen, nicht Kruemmung.

Die Wahl ist als **Compile-Time-Strategy (GoF), per Concept gehaertet** implementiert (`axis_spline.hpp:11-13`, `:200`) — der natuerliche kubische Spline bleibt als Alternative verfuegbar, aber die Wahl ist statisch und explizit. Das erfuellt zugleich die CT-Doktrin: kein Runtime-Switch, kein `std::variant`.

**Die zweite Implementierung teilt die Begruendung, nicht das Verfahren.** `builder/curve_fit/curve_fit.hpp:318` traegt denselben Satz ueber *„SCHEIN-Break-Even-Punkte"* — `best_binary_selector` dagegen rechnet stueckweise linear. Damit gilt: **die Begruendung ist dreimal aufgeschrieben, das Verfahren zweimal implementiert und einmal unterlaufen.**

---

### II.8 Der Ist-Stand — mit Nennern

Alle Zahlen: eigene Messung am **07.08., ce `development` = `c4c04315`**.

#### II.8.1 Die Mathematik ist gebaut und hat null produktive Konsumenten

Suchraum `libs apps tools tests adapters modules benchmarks`, Endungen `.hpp/.cpp`, Build-Baeume per **Positivliste** ausgeschlossen (nicht per `grep -v`, siehe die `/builder/`-Falle):

| Symbol | Definition | Aufrufer ausserhalb der Definition |
|---|---|---|
| `find_break_even_points` | `heuristik/break_even.hpp:74` | **nur** `tests/unit/test_heuristik_spline_break_even.cpp:50,76` |
| `build_axis_splines` | `heuristik/measurement_curve_loader.hpp:218` | **nur** `test_heuristik_spline_break_even.cpp:166` |
| `find_break_evens` | `best_binary_selector.cpp:455` | **nur** `test_hybrid_spline_selector_scaffold.cpp:131` |
| `HybridBinarySelector` | `best_binary_selector.cpp:500,520` | **nur** `test_hybrid_spline_selector_scaffold.cpp:141,152` |
| `break_even_table` | `best_binary_selector.cpp:520` | **nur** `test_hybrid_spline_selector_scaffold.cpp:147` |

Includes von `heuristik/` ausserhalb des Verzeichnisses selbst: **9 Treffer**, davon **4 Kommentar-Verweise** und **5 Test-Includes**. **Null produktive Includes.**

**Nenner:** `tests/unit/CMakeLists.txt` traegt **203** `comdare_add_test`-Eintraege; genau **zwei** davon fahren Break-Even. `apps/` enthaelt **9 Anwendungen**; **keine** davon ruft die Kette.

**Und die CLI erreicht ihren eigenen Break-Even-Teil nicht.** `best_binary_selector_main.cpp` (148 Zeilen) ruft ausschliesslich `parse_measurement_csv` (`:82`), `rank_binaries` (`:100`), `TiereDllRepository` (`:122`), `ShippedArtifactBuilder` (`:132`). **Null Aufrufe** von `HybridBinarySelector`, `find_break_evens` oder `break_even_table` — sie liegen in derselben `.cpp` und sind vom `main` aus tot.

**Die Rueckfuehrung ist als offen deklariert**, `builder/experiment_tree/selection_filter_chain.hpp:119-122`: *„**DEFERRED (#156):** … er wird additiv als weiteres Ketten-Glied nachgezogen, **wenn die Mess-Rueckfuehrung (best_binary_selector -> resolve_selection) verdrahtet ist. Bis dahin bleibt die Einhaengung eine reine Identitaet.**"*

**Bilanz:** Die Rechnung kann ausgefuehrt werden. Nichts faehrt sie. Das ist **kein stiller Rueckfall** — es ist ueberall deklariert (`SKELETON`, `DEFERRED (#156)`, `IMPL-OFFEN`, README-Stub) —, aber der Zustand ist „Geruest mit Test", nicht „Kette".

#### II.8.2 🔴 Der haerteste Befund: die Mathematik hat keinen Input, und zwar aus einem strukturellen Grund

Die gesamte reale Messdatenbasis des Projekts sind **zwei CSV-Dateien mit je 17 Zeilen = 16 Datenzeilen**:

- `measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` — 173 Spalten
- `Code/measure_out_d03/e4_xml/measurements.csv` — identischer WIDE-Dialekt, **untracked und nirgends gesichert**

Der Loader gruppiert nach `(sweep_axis, binary_id, workload)` und nimmt `x = working_set_n`, `y = ns_per_op` (`measurement_curve_loader.hpp:20`, `:57-58`). Die 16 Zeilen selbst ausgezaehlt:

```
Datenzeilen:                          16
distinkte Gruppen:                    16
maximale Punktzahl je Gruppe:          1
distinkte Werte von working_set_n:     1   (= 4096)
```

**Jede Gruppe hat genau einen Punkt, und die Parameter-Achse hat ueber den gesamten Korpus einen einzigen Wert.** Der Spline verlangt ≥ 2 Stuetzstellen (`axis_spline.hpp:206`). **Ergebnis ueber den gesamten realen Messbestand: 16 von 16 Gruppen liefern `std::nullopt`. Null Splines. Null Schnittpunkte.**

Das ist **kein Datenmangel im Sinne von „zu wenige Wiederholungen"** — es ist ein fehlender Sweep. Der Break-Even braucht Variation *auf der x-Achse*; erhoben wurde bisher nur ein Punkt darauf.

**Die Entlastung, und sie ist wichtig:** die golden-XML plant diesen Sweep bereits. `all_axes_golden.profile.xml:112`:

```xml
<working_set_sweep>16384 131072 1048576 8388608</working_set_sweep>
```

Vier x-Werte, autoritativ aus dem Profil (`profile_run_entry.hpp:531,534`), pro Zeile in die CSV-Spalte `working_set_n` geschrieben. Dazu **17 `<axis_sweep>`** (`:66-84`, nachgezaehlt) und **6 Workloads** (`:126`).

> **Die Zahl, auf der die gesamte Break-Even-Auswertung ruhen wird, ist damit: VIER Stuetzstellen je Gruppe.** Eine monotone kubische Hermite-Interpolation ueber vier Knoten sind drei Segmente. Das reicht formal (≥ 2) und ist fuer Fritsch-Carlson die richtige Wahl gerade *weil* wenige Knoten Overshoot-anfaellig waeren — aber jeder Switch-Threshold der Arbeit wird aus **vier Messpunkten je Kurve** interpoliert. Das gehoert in die Limitierungen der Thesis, und es ist heute nirgends notiert. **Vor dem ersten Batch ist zu entscheiden, ob vier x-Punkte genuegen — danach kostet die Entscheidung einen Neu-Lauf.**

#### II.8.3 Die drei Ebenen einzeln

| Ebene | Zustand | Beleg, heute |
|---|---|---|
| **MICRO** | **halb** | Traegt: 17 `<axis_sweep>` + 18 Per-Achsen-Zeitspalten `seg_*_ns` (CSV-Spalten 25–42) + `sweep_axis`-Tag. Traegt **nicht**: was heute „Micro" heisst, sweept die **Algorithmen-Wahl** einer Achse und misst am **Gattungs-Interface** (`ns_per_op`) — nicht einen *Parameter* ueber das *Achsen-Interface*. Beide dafuer angelegten Orte sind leer: `benchmarks/microbenchmarks/` = `.gitkeep` (0 Byte) + CMakeLists mit **einer** Kommentarzeile; `builder/runtime_micro_benchmarks/` = `.gitkeep` + `add_library(… INTERFACE)` mit dem Kommentar „**Skelett (Phase 4.B) — keine Implementation**". Nenner `benchmarks/`: **7 Dateien**, davon 3 `.gitkeep` und 4 CMakeLists |
| **MACRO (timed)** | **fehlt** | Suche nach Schritt-Zeitnahmen: `lap_ns` 0 · `split_ns` 0 · `phase_ns` 0 · `stage_ns` 0 · `step_ns` 0 · `marker_ns` 0 · `trace_point`/`tracepoint` 0. **Gegenprobe `seg_ns` = 308** (Suchraum `libs apps tools tests adapters modules`, `git grep -n` an ce `54106bc9`; ueber `libs` allein: 117; ganzer Baum 424) — die Suche greift. Vorhanden sind zwei Halbstuecke, die nicht verbunden sind: `op_lat[6]` (p50/p99 je Op-Art) und `seg_ns[18]` (lauf-aggregiert je Achse). Die `fill_checkpoints{10,100,1000}` sind **Fuellstands**-Stuetzpunkte auf der Datenmengen-Kurve, nicht Punkte innerhalb eines Aufrufs — und ihre CSV exportiert **2 von 18 Achsen** (hartkodiert `axis_stats[0]` und `[6]`). **⚠ W-3** |
| **MACRO large scope** | **Traegerschicht ja, Auswertung nein** | 21 Lastprofil-XML unter `algorithm_profiles/load_profiles/`, 6 davon im golden, `workload` als CSV-Spalte 155, unbekannte id = **harter Fehler** (`validate_profile.hpp:463`, exit 4, kein stiller Rueckfall). Was fehlt: **kein Aggregations-Artefakt** „Gesamtheit der Macro-Charts eines Lastprofils" — weder Writer noch Schema |

**Und die Pointe des Ist-Stands:** `Code/05_diagram_generator/diagram_generator.hpp:397-405` **zeichnet** genau die Kurven, die sich schneiden muessten — „Working-Set-Sweep-Kurve (Metrik ueber `working_set_n`) … eine Kurve je gesweepter Achsen-Auspraegung". Er legt sie uebereinander. **Niemand schneidet sie.** Gegenprobe mit Nenner: `break.even|schnittpunkt|crossover|intersect` ueber `Code/05_diagram_generator Code/08_appendix_generator Code/tools Code/02_messung_driver Code/04_csv_to_latex` = **0 Treffer**; derselbe Ausdruck findet im ce ueber 50 Treffer. Der super-Auswertungspfad kennt den Begriff nicht.

#### II.8.4 Die vierte Stufe

`libs/cache_engine/hybrid/` enthaelt heute **genau eine Datei: `README.md`** (3820 Byte, am Ref `c4c04315` nachgezaehlt). Die neun geplanten Dateien sind dort namentlich tabelliert, darunter `hybrid_router.hpp` = „Break-Even-Router". Bau-Zeitpunkt laut README: **Auswertungsphase, nach Voll-Bau-4 und nach E-24**.

Das SOLL steht ausgeschrieben in `ce/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:192-197`:

> „`hybrid_router.hpp` konsumiert **AxisSpline-Kurven** (`heuristik/measurement_curve_loader.hpp`) und **BreakEvenPoint-Listen** (`heuristik/break_even.hpp`) und bildet daraus die **Compile-Time-Chain-of-Responsibility der Heuristik-Ebene**."

Konfiguriert additiv per XML (`:232`). Arbeitspaket **HY-B2**, Reihenfolge `HY-B1a → HY-B1b → HY-B2 → HY-B3 → HY-B4`.

**Der Ledger nennt den Zustand ausdruecklich richtig** (`:4525`): *„Das ist kein Versaeumnis, sondern die richtige Reihenfolge: sie kann ohne Messdaten nicht wissen, was sie auswaehlen soll."*

#### II.8.5 Was die Thesis dazu sagt — und was nicht

**Der Begriff Break-Even kommt in der Pruefungsarbeit nicht vor.** Eigene Messung an thesis `19e15920`:

- **Nenner:** die **sechs eingebundenen** Kapitel (`diplomarbeit.tex:280-285`) in **beiden Sprachen** plus `aufgabenstellung/de.tex` und `en.tex` = **14 Dateien**.
- **Muster** (case-insensitiv): `break.?even|breakeven|schnittpunkt|kipppunkt|crossover|umschaltpunkt|spline`
- **Ergebnis: 0 in allen 14 Dateien.**
- **Gegenprobe, dieselben Dateien:** `03_messsystem_prtart.tex` → heuristik **20**, achse **277**, benchmark **18**; `05_evaluation.tex` → 9 / 15 / 2; `06_fazit.tex` → 5 / 42 / 3. **Der Zaehler greift; die Null ist echt.**

Die Thesis beschreibt an dieser Stelle nur das *Ergebnis*, nie den *Mechanismus* — `03_messsystem_prtart.tex:1461` — und markiert den Kurven-Teil selbst als Zielbild (`:1481-1483`): *„im heutigen Stand existiert davon erst der **Keim**"*.

**Das Verfahren, das laut Ledger `:3284` das Ziel des Gesamtprojekts traegt** — *„Messwerte -> Break-Even-Heuristik -> Hybrid-Tier-Binaries -> final schnellste Binary"* — **ist in der Pruefungsarbeit namenlos.** Das ist keine Falschaussage, aber eine Luecke: der Owner hat in O-097 ausdruecklich gesagt „**das ist geplant und muss dokumentiert werden**".

**Was die Thesis dagegen sehr wohl zusagt, haelt.** Die `best_binary_selector`-Zusage steht dreimal, und alle drei sind vorsichtig formuliert (`01_einleitung.tex:231-233`, `03_messsystem_prtart.tex:1401-1403`, `06_fazit.tex:192-197`) — durchgehend mit dem Zusatz „ein erstes Inkrement" und „die heuristik-gesteuerte Vollautomatisierung bleibt Ausblick". **Die Zusage haelt am Objekt und ist nicht ueberzogen.** Der Kontrast zu den beiden Falschaussagen aus Kapitel V (Talos, `flat_hash_map`) ist lehrreich.

> **Methoden-Hinweis, der einen Falschbefund verhindert hat:** In LaTeX heisst das Werkzeug `best\_binary\_selector` mit maskiertem Unterstrich. Der erste Suchlauf mit `best_binary_selector` lieferte **0 Treffer im gesamten `kapitel/`-Baum** — eine falsche Null derselben Klasse wie die Versalien-Falle. Erst `best.binary.selector` als Muster fand die sechs realen Stellen. **Jede Thesis-Suche nach einem Bezeichner muss die TeX-Maskierung mitdenken.**

#### II.8.6 Zwei Befunde in der Eingangsstufe, die die Ergebniszahlen betreffen

**(1) Stiller Gruppen-Kollaps im Kurven-Loader.** `measurement_curve_loader.hpp:50-51`, verbatim: *„**Fehlt eine Gruppen-Spalte im Header, faellt ihre Dimension auf ‚-'** (ehrlich, kein Absturz). x/y MUESSEN existieren, sonst leeres Ergebnis."* — x und y sind honest-empty geschuetzt, **die Gruppendimensionen nicht**. Fehlt `workload`, werden **alle Lasten still zu einer Gruppe verschmolzen**, und die Kurve, die „je Eingangslast" verglichen werden soll, ist eine ueber alle Lasten gemittelte. Der Aufrufer bekommt kein Signal. **Empfehlung: Gruppendimensions-Kollaps zaehlen und diagnostizieren, analog `skipped_rows` — nicht nur kommentieren.**

**(2) Median-Divergenz REV-DATA-12.** `best_binary_selector.cpp:184` verwendet `lower_median`, waehrend `csv_to_latex.cpp:48-54` und `diagram_generator.cpp:414-420` die nearest-rank-**obere** Mitte verwenden. Bei geradem *n* divergieren sie. **Konsequenz: die Zahl, die als Median in einer Thesis-Tabelle steht, kann von der Zahl abweichen, mit der der Sieger bestimmt wurde.**

**Und ein dritter, der 18 Tage lang unbemerkt lief — heute geheilt.** Der CI-Tripwire, der die drei Heuristik-Header per SHA-256-Digest gegen `tools/axis_version_lock/axis_version.lock` schuetzt, stand **zweimal** in `.gitlab-ci.yml`; YAML verwirft bei doppeltem Schluessel kommentarlos alles ausser der letzten Definition, und die letzte war `rules`-gegated auf ein nirgends gesetztes `COMDARE_AXIS_LOCK_CHECK`. **Der Tripwire lief seit dem 19.07. in keinem einzigen Lauf.** In dieser Zeit driftete `measurement_curve_loader.hpp` **zweimal semantisch** ohne Versions-Bump (`150b0ede` 26.07., `0fdeccff` 02.08.) — und beide Aenderungen bestimmen, **welche CSV-Zeilen zu Kurvenpunkten werden**. Geheilt durch `597ecffe` und `557d8023`. **Die Drift kam nicht durch, weil sie erlaubt war, sondern weil niemand hinsah.** (Kapitel III.6.4.)

---

### II.9 Was in diesem Kapitel offen ist — und wem es gehoert

| # | Punkt | Klasse | Fenster |
|---|---|---|---|
| **II-1** | **Vier x-Stuetzstellen je Kurve** (`working_set_sweep`) — genuegen sie als Beweisgrundlage aller Switch-Thresholds? | Owner-Entscheid | **vor dem ersten Batch** |
| **II-2** | **Was ist „die beste Binary"** — Einzelsieger (A) / je Eingangslast (B) / Pareto-Front (C)? | Owner-Entscheid, Fork §H-6 | vor B-9 |
| **II-3** | **Min/Max je Achse** — `break_even.hpp:17` fixiert „kleiner = besser"; Max-Achsen nicht abgedeckt | Deep-Research | „nach Trigger, vor Auswertung" |
| **II-4** | **Zwei divergierende Break-Even-Implementierungen** — welche gilt, und darf `best_binary_selector` nach O-100 ueberhaupt eine tragen? | Owner-Entscheid + Aufraeumpass | nach Abgabe |
| **II-5** | **Achsen-kreuzender Schnitt und Gattungs/Genus-Interface-Schnitt** — O-096 verlangt beide; geplant und gebaut ist **nur** der Schnitt *innerhalb einer Achse*. Nenner/Gegenprobe: 0 Treffer fuer einen achsen-kreuzenden Schnitt bei 30+ Treffern fuer achsen-internen Break-Even in denselben Dateien | **Planungsluecke gegen den Owner-KERN** | vor B-9 |
| **II-6** | **Keine Hysterese / Schaltstabilitaet** — ein Router, der exakt am Schnittpunkt schaltet, flattert bei Last nahe `x_be`. Muster `hysterese\|hysteresis\|flapping\|schwing`: **1 Treffer, unverwandt**. Gegenprobe: `verdraeng` trifft mehrfach | ungeplant | vor B-10 |
| **II-7** | **Stiller Gruppen-Kollaps** im Loader (§II.8.6/1) | Bau, klein | **vor der Messung** |
| **II-8** | **Median-Divergenz** REV-DATA-12 (§II.8.6/2) | Bau, klein | vor der Ergebnis-Tabelle |
| **II-9** | **Last-Erkennungsheuristik** — das Bindeglied zwischen „multiple beste Binaries" und dem Hybrid-Adapter. Im HY-D2-Design-Doc **nicht ausgearbeitet** (grep im Doc = 0) | **schmalste Stelle der Funktionalitaets-Voraussetzung** | vor B-10 |
| **II-10** | **Break-Even in der Thesis benennen** — O-097: „muss dokumentiert werden"; heute 0 von 14 eingebundenen `.tex` | Text | nach Abgabe |
| **II-11** | **Die Abgrenzungsfrage Mess-Tooling-Achse ↔ die drei Ebenen** ist neu zu stellen — ihr Hauptargument („0 Konsumenten") ist seit M-1 (00:06) ueberholt | Klaerung | Freitag |
| **II-12** | **Das Akzeptanzkriterium fuer Ebene 2** — Zeitpaar je Aufruf oder Checkpoints darin? *(neu, aus W-3)* | Owner-Entscheid | vor Freitag 3 |

Die Bau-Posten selbst sind im Ledger als **B-7 … B-10** verbucht (`:4637-4643`), alle mit dem Vermerk „**nach Abgabe**".

---

### II.10 Zusammenfassung in fuenf Saetzen

1. **Die Kette ist vollstaendig ausgesprochen** — Messwerte → Funktions-Synthese → Schnitt-Kurven → optimale Konfiguration ≡ die zu waehlende Binary → Hybrid-Schaltlogik —, und sie ist keine Nachbereitung, sondern die **Funktionalitaets-Voraussetzung** der vierten Stufe.
2. **Break-Even ist ein Kipppunkt, kein Optimum**; er ist die operative Form von H2 aus Termin 1, die dort seit dem 30.03. als Frage steht und ueber vier Termine unter dem Wort *Umschaltpunkt* praezisiert wurde.
3. **Die Mathematik ist gebaut, deterministisch, honest-empty und am Owner-eigenen Beispiel bewiesen** — Fritsch-Carlson gerade deshalb, weil ein ueberschwingender Spline **Schein-Schnittpunkte und damit falsche Schalthandlungen in der ausgelieferten Binary** erzeugen wuerde.
4. **Die Arbeitsteilung ist seit O-100 klar:** `break_even.hpp` rechnet, `best_binary_selector` nimmt die Messwerte und orchestriert ueber das Lager. Heute erfuellt er drei seiner vier Aufgaben und traegt eine **zweite, groebere Break-Even-Implementierung**, die ihm nach dieser Rollenzuweisung nicht gehoert.
5. **Der Ist-Stand ist: Bibliothek fertig, Kette offen, Input null.** 0 produktive Konsumenten bei Nenner 203 Tests / 9 Anwendungen; 16 Messzeilen in 16 Gruppen mit **einem einzigen x-Wert**, also 0 konstruierbaren Splines; und nach dem geplanten Voll-Lauf **vier Stuetzstellen je Kurve** — die Zahl, auf der jeder Switch-Threshold dieser Arbeit ruhen wird, und die heute nirgends als Limitierung notiert ist.

---

## KAPITEL III — DIE FEHLER UND WAS SIE LEHREN

### III.0 Vorbemerkung: was dieses Kapitel ist

Dieses Kapitel schreibt die Einzelbefunde der Session nicht noch einmal ab. Sie stehen bereits, mit vollem Kontext, an vier Orten: `docs/sessions/20260806-DOSSIER-regressionen-checkheft.md` (**2486** Zeilen — die Posten N-1..N-AE, SW-1..SW-4, Z-1..Z-8 und die Regel-Zeilen), `docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md` (**677** Zeilen — §4.1 Widersprueche W-1..W-21, §4.2 zwanzig Selbstkorrekturen mit Bericht-ID, §4.3 der Codex-Kipp-Zaehler), die Ledger-Nachtraege abend-1 bis abend-4, und `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` (v3, ce-Repo, Commit `77993f6e`, Teil V — die sechzehn Arbeitsfehler des Leads in fuenf Klassen).

Was hier neu ist, ist der **Zusammenhang**: dass diese Befunde ganz ueberwiegend **eine Gestalt** teilen — die **Hauptklasse**, nicht die vollstaendige Typologie —, dass diese Gestalt einen **Namen vom Owner** bekommen hat, dass sie eine **Gegenseite** hat, die genauso systematisch ist wie die Fehlerseite, und dass am Ende dieser Erfahrung eine **Schwere-Leiter** steht, die nicht erfunden, sondern erarbeitet wurde. (Das Checkheft prueft die These in **VII.5** ausdruecklich nach und haelt fest: *„Die These bleibt richtig und bleibt die Hauptklasse. Sie ist aber nicht vollstaendig"* — es fuehrt dort drei Gestalten, die sie nicht abdeckt.)

**Erhebungsdatum: 2026-08-07, 00:05–00:40 Z.** Gemessen gegen ce `origin/development` = `bba4d90f` / `origin/main` = `2b5ecd29`, super `71591a24`, thesis `19e15920`.

> ⚠ **Siehe Abschnitt 0 / W-2:** Dieses Kapitel hat acht Minuten vor der Landung `c4c04315` gemessen und traegt deshalb einen aelteren ce-Stand als die Kapitel I, II, IV und V. Sein super-Label `origin/development = 71591a24` ist ausserdem falsch — `71591a24` ist super `origin/main`. Beide Punkte sind in Abschnitt 0 nachgemessen; **verbindlich ist der spaetere Stand.** Dass dieses Kapitel ausgerechnet an der Regel scheitert, die es selbst als Regel-Zeile 17 formuliert, ist kein Zufall, sondern ihre staerkste Bestaetigung.

Und gleich die zweite Anwendung des eigenen Kapitels auf sich selbst: **der Auftrag zu diesem Dossier nennt als Messstand super `33edd4cd` und ce `2b5ecd29` auf dev und main.** Beides war zum Zeitpunkt der Auftragserteilung richtig und ist beim Schreiben ueberholt. Ebenso gilt: **jede Ledger-Zeilennummer in diesem Kapitel ist eine Momentaufnahme.** Der Ledger wuchs an diesem Tag von 4975 ueber 6735 auf 7248 Zeilen und existierte zeitweise in zwei divergierenden Fassungen (Worktree 6758 gegen 6735, `cmp` = VERSCHIEDEN).

---

### III.1 Die Gestalt: eine korrekte Messung, die die falsche Frage beantwortet

#### III.1.1 Der Satz und woher er kommt

Der Satz ist keine nachtraegliche Zuspitzung. Er steht woertlich in einer Commit-Nachricht dieses Tages, geschrieben in dem Moment, in dem sein Autor den eigenen Fehler verstanden hatte — ce `fb9aefdc`, verbatim aus dem Repo verifiziert:

> *„Dieselbe Fehlerklasse wie die stillen Nullen des Abends: **eine korrekte Messung, die falsch gelesen wurde.** Konsequenz: die Wachen-Ausgabe wird ab jetzt vollstaendig gelesen, nicht gefiltert."*

Und er steht in der Selbstkritik-Datei des Leads (`memory/feedback_eigene_arbeitsfehler_lead_berichte_nie_uebernehmen.md`, geschrieben 06.08. 20:08:14 Z) als das Band, das alle fuenf Fehlerklassen zusammenhaelt:

> *„Alle fuenf Klassen sind dieselbe Gestalt wie die Regressionen im Code: **eine Messung war fuer sich korrekt und beantwortete die falsche Frage.** Meine Berichte waren korrekt fuer das, was ich gelesen hatte — und falsch fuer das, was war."*

Die Formel hat drei Bestandteile, und alle drei sind noetig:

1. **Das Werkzeug ist in Ordnung.** gitleaks funktioniert. `grep` funktioniert. `perf_event_open` funktioniert. Der Testrahmen funktioniert. Kein einziger der Befunde dieses Kapitels ist ein Werkzeugdefekt.
2. **Die Antwort ist wahr.** „0 Commits gescannt, keine Leaks" ist keine Luege. „`tail` liefert RC=0" ist keine Luege. „In `/tmp/x` gibt es keine Treffer" ist keine Luege.
3. **Der Gegenstand der Frage ist ein anderer als der beabsichtigte.** Und genau das steht nirgends in der Ausgabe.

Der dritte Punkt ist der ganze Befund. Eine Messung traegt ihre Frage nicht mit sich. Wer sie spaeter liest, liest die Antwort und ergaenzt die Frage aus dem Gedaechtnis — und ergaenzt sie so, wie er sie gestellt zu haben glaubt.

#### III.1.2 Die Bauform: der stille Rueckfall

Der Owner hat der Sache ihren zweiten, haerteren Namen gegeben. Transkript `bak 3547` / `live 7513`, 2026-08-06T22:59:15Z, verbatim (**KERN 10**):

> **„Hinweis: Stiller Rueckfall geht fuer uns nicht: Regressionen oder Fehler gehoeren angezeigt, das ist ein weiterer Fall fuer das Anzeigen von error"**

Damit ist die Diagnose von der Erhebungsseite auf die **Konstruktionsseite** gedreht. Eine korrekte Messung, die die falsche Frage beantwortet, entsteht nicht zufaellig — sie entsteht ueberall dort, wo ein System **auf ein Ersatzverhalten zurueckfaellt, ohne es zu sagen**. Ein Scan, dessen Ziel leer ist, faellt auf „nichts gefunden" zurueck. Ein Zaehler, den die Hardware nicht kennt, faellt auf `0` zurueck. Ein Filter, der zu viel wegwirft, faellt auf „keine Treffer" zurueck. Ein Job, der einen Testsatz nicht sieht, faellt auf „alle bestanden" zurueck.

Und der Rueckfall ist in jedem dieser Faelle **gruen**. Das ist der Kern von **Regel-Zeile 15**, Ledger `:4754`, verbatim:

> *„**Eine Pruefung, die ihren eigenen Gegenstand nicht erreicht, meldet GRUEN.** Nicht ROT, nicht ‚unbekannt' — gruen. […] Konsequenz: jede Pruefung muss ihren NENNER mitfuehren. Eine Wache ohne Nenner ist kein Beweis, sondern eine Behauptung ueber sich selbst."*

Der Owner-Satz und die Regel-Zeile sind dasselbe von zwei Seiten. Die Regel sagt, was passiert; der Owner sagt, was daraus zu folgen hat: **es gehoert angezeigt, und zwar als `error`.**

Die Erkennungsmuster, wie sie der Ledger fuehrt: Fehlschlag endet in `return 0;` / `return {};` / `return default;` **ohne Log** · `catch (...) { }` ohne Anzeige · `|| true`, `2>/dev/null`, ignorierter Exit-Code · Default-Parameter, der einspringt, wenn die echte Quelle fehlt · eine Zelle mit `0`, weil die Quelle nicht existiert · **eine Wache, die bei leerem Gegenstand GRUEN meldet**.

Ein frueherer Owner-Satz desselben Tages hat dieselbe Familie schon einmal verboten, nur an der anderen Stelle — Transkript `live 3041`, 13:11:01Z:

> **„Ein Ausschluss loest die Wurzel des Problems NICHT, das ist verboten."**

Mittags der stille **Ausschluss**, nachts der stille **Rueckfall**. Elf Stunden auseinander, dieselbe Doktrin: *was das System aus dem Blick nimmt, muss es benennen.*

---

### III.2 Die drei stillen Nullen

Alle drei fielen an **einem** Abend an, alle drei in **eigenen** Pruefungen, alle drei bei einem Werkzeug, das seinen Job korrekt tat.

#### III.2.1 SN-1 — „no leaks found" bei „0 commits scanned"

Ledger abend-2 §B. Der Aufruf lautete sinngemaess:

```
podman run ... gitleaks git /repo --log-opts "47c4ef1d..b241a272"
-> no leaks found          <- beruhigend
-> 0 commits scanned       <- in derselben Ausgabe
```

Beide Zeilen standen **nebeneinander**. Die erste wurde gelesen, die zweite nicht.

Die Ursache ist strukturell und lehrreich: im Submodul ist `.git` keine Verzeichnis-, sondern eine **Datei** mit `gitdir: ../../../.git/modules/…`. Im Container war das Elternrepo nicht gemountet, der Zeiger lief ins Leere. Das Werkzeug fand ein gueltiges Repo-Layout vor, konnte die Objekte aber nicht erreichen — und das Verhalten fuer „keine erreichbaren Commits" ist eben nicht „Fehler", sondern „keine Funde".

Geheilt durch `-v <super>:/super:ro,Z` und ein Scan-Ziel innerhalb des gemounteten Elternbaums: `4 commits scanned, no leaks found`.

Der Rest, ehrlich stehen gelassen, verbatim aus dem Ledger: *„Wenn frueheren ce-Pushes dieselbe Aufrufform zugrunde lag, waren sie **ungeprueft**. Das ist nicht nachtraeglich feststellbar, ohne die Aufrufe zu rekonstruieren."* — **Der Umfang des Schadens ist unbekannt und bleibt es.** Das ist der Preis dafuer, dass eine stille Null keine Spur hinterlaesst.

#### III.2.2 SN-2 — die Vorpruefung, die 776 Tokens fuer Fehlalarme hielt

Der sicherheitsrelevante Fall. Ausgeloest durch zwei Owner-Nachrichten in Folge, die zweite verbatim (`bak 2203`, 20:32:48Z):

> **„Bitte erst kopieren und dann Geheimnispruefung, der Kontext reihct nciht"**

Diese Reihenfolge — erst sichern, dann pruefen — ist der einzige Grund, warum der Befund ueberhaupt entstand. Haette der Lead in der Reihenfolge gearbeitet, die er selbst gewaehlt haette (pruefen, dann kopieren), waere die Menge nie in einem Zustand gewesen, in dem sie ein Werkzeug vollstaendig sehen konnte.

gitleaks meldete **1552 Treffer**. Die eigene Vorpruefung suchte `glpat-`, `gldt-`, `ghp_`, `github_pat_`, `PRIVATE-TOKEN`, `Bearer` und PEM-Bloecke → **0 Funde** → Schluss: *„vermutlich Fehlalarme auf deutschem Fliesstext"*.

Das war falsch. `outputs/bnpj776mm.output` enthielt **GitLab-Runner-Registration-Tokens im Klartext**, Praefix **`GR1348941`** — verbatim: *„ein Format, das keines meiner Suchmuster abdeckte"*. 1552 Vorkommen = 776 Funde × zwei Ausgabezeilen.

Die Herkunft ist der eigentliche Skandal: die Datei war der woertlich mitgeschriebene Konsolen-Auswurf eines **frueheren gitleaks-Laufs**. gitleaks druckt in den Feldern `Finding:` und `Secret:` den **Klartextwert**, und ein Agent hatte diese Ausgabe ungefiltert in seinen Bericht kopiert. Die Werte stammen aus `docs/sessions/backups/20260802-e23-suchlauf-belege/e23/projects_all.ndjson` (390 Vorkommen) und `group_projects.ndjson` (386), Feld `runners_token` — **also genau aus den Daten, die der E23-Scrub vom 02.08. per filter-branch aus der Historie entfernt hatte.** Sie waren im Begriff, ueber die Hintertuer eines Agenten-Berichts auf einen zum Push vorgesehenen Pfad zurueckzukehren.

Auch die zweite Erwartung war falsch: alle 1552 Treffer stammten aus **einer** Regel (`gitlab-rrt`) in **einer** Datei; `generic-api-key` konnte durch die repo-eigene `.gitleaks.toml` gar nicht ausloesen.

Abgefangen: das Original liegt in `/home/comdare/backups-workflow/QUARANTAENE/bnpj776mm.output` (Modus 0600, 479.544 Byte — heute als vorhanden verifiziert); im Repo steht `bnpj776mm.output.REDACTED`, bit-gleich bis auf 1552 mechanisch ersetzte Werte. Nachgemessen: 0 volle Tokens im Commit `2a6f35d8`, Gegenprobe am Original findet 1552 — **das Verfahren misst also.**

**Und hier steht die Stelle, die Regel-Zeile 15 ueberhaupt erst erzwungen hat.** Ledger `:4800`, verbatim:

> *„Mein erster Rotations-Test suchte die Zuordnung Token→Projekt in der Quarantaene-Datei und fand **0 Paare**. Das war **kein Befund, sondern ein Verfahrensfehler**: gitleaks schneidet den Kontext so eng, dass im `Finding:`-Fragment kein `id`-Feld steht. Erst die Gegenprobe (‚findet das Verfahren ueberhaupt?' → 1552 Werte vorhanden) hat den Fehler aufgedeckt."*

Der Test wurde daraufhin als **Mengentest ohne Zuordnung** neu gebaut und lieferte sofort:

```
ce     (286): HEUTIGER TOKEN IST IN DER LECK-MENGE -> NICHT ROTIERT
super  (288): ... NICHT ROTIERT
thesis (289): ... NICHT ROTIERT
```

Ledger-Fazit: *„Der Scrub vom 02.08. hat die SPUR beseitigt, aber nicht die WIRKUNG."*

**Zwei Ehrlichkeits-Vorbehalte, die zum Befund gehoeren:**

- Die Pruefwelle `wf_d976ea96-862 #1` fuehrt den Rotationsposten als **`[?] UNBELEGT`**: *„In den 121 Berichten steht **keine** Messung, kein API-Abruf, kein Vergleich alter gegen aktueller Token-Werte."* Der Beleg steht im Ledger abend-2 §D, nicht in den Wellenberichten. Die Aussage ist also belegt, **aber nur an einer Stelle**.
- **Die Zahl 390 ist die falsche Bezugsgroesse.** 390 ist das Vorkommen in *einer* der beiden Dateien; zusammen mit `group_projects.ndjson` (386) sind es **776**. Wo „390 Tokens" geschrieben steht, gehoert „390 in einer von zwei Dateien, 776 gesamt" hin.

Die Rotation selbst ist an Infra abgegeben — Owner `bak 3463` (22:44:53Z): *„Bitte handout mit commit und push an den infra Agenten fuer rotationen, keys und allgemeine infra Probleme. **Das ist nicht mehr dein Problem.**"* (Handout `docs/infra/I113_…`, 188 Z., super `cc431b01`.)

#### III.2.3 SN-3 — dieselbe Falle, zwei Stunden nach der Regel

Ledger abend-3 §D. Der gitleaks-Lauf ueber das **thesis**-Submodul lief in exakt dieselbe Falle: `no leaks found` bei `0 commits scanned`; der Elternrepo-Mount heilte es (1 Commit gescannt).

Der Kommentar des Leads dazu, verbatim, ist die wichtigste Zeile dieses Abschnitts:

> *„Die Regel greift nur, weil jemand hinsieht — **sie gehoert in ein Skript.**"*

**Sie ist bis heute nicht in einem Skript.** Der gitleaks-Aufruf ist weiterhin eine Handlung, kein Gate. Das ist ein offener Posten, und es ist derselbe Posten, den III.10 als Meta-Lehre fuehrt: eine Regel, die auf Aufmerksamkeit angewiesen ist, ist keine Wache.

---

### III.3 Die vier Auspraegungen des falschen Ausschnitts

Der Lead hat sie selbst zusammengefasst, Transkript `bak 3458`, 22:41:04Z, verbatim:

> *„Vier Fehler, eine Gestalt: **nicht das Werkzeug war falsch, sondern der Ausschnitt, den es sah.** Falsches Datum (veralteter Befund), falsche Schreibweise (case-sensitiv gegen VERSALIEN), falscher Pfad-Filter (`grep -v "/build"` frisst `/builder/`), falsches Ausgabe-Muster (mein `DIFF-HYGIENE:` gegen `DIFF-HYGIENE-WACHE:`)."*

Vier Dimensionen: **Zeit, Schreibweise, Ort, Form.** Zusammen sind sie eine vollstaendige Typologie dafuer, wie ein Suchraum an seinem Gegenstand vorbeigehen kann.

#### III.3.1 FA-1 — Zeit: der Bau-Auftrag fuer einen bereits geheilten Defekt

Die Posten A-7 und A-8 wurden aus dem Checkheft als Bau-Pakete vergeben. Beide waren erledigt. **Zwei Fixe, die genau dieselben Zeilen heilten, waren zum Zeitpunkt der Verdichtung bereits gelandet** — `c1c76c87` (B14-NB4) und `0b5ed557` (A1-Scheibe), beide **vom selben Tag**; A-7 zusaetzlich durch einen Owner-Entscheid von vorgestern. Zwei der vier A-8-Fundstellen waren obendrein falsch zugeordnet: `measure.hpp:38` ist toter Beispielcode, `axis_05…:60` gehoert einer anderen Fehlerklasse an.

**Regel-Zeile 17**, Ledger `:7246`, verbatim aus der Datei verifiziert:

> *„Ein Datum an einem Fund […] ist kein Verfallsdatum, das man ignorieren darf, sondern ein PFLICHTFELD fuer die Nachmessung: JEDE Zeile eines aelteren Berichts, die zum Bau-Auftrag wird, verlangt zuerst `git log -1 -- <Datei>` bzw. eine frische Lektuere der zitierten Zeilen am aktuellen HEAD — nicht das Vertrauen auf die Verdichtung. Ein widerlegter Befund, der so entdeckt wird, ist kein Fehlschlag der Pruefung, sondern ihr Erfolg; ein ungeprueft gebauter Befund, der sich als bereits geheilt herausstellt, waere teurer als der urspruengliche Defekt."*

**Und die Klasse traf das Checkheft selbst.** Die Pruefwelle `wf_d976ea96-862 #2` fand zwei harte Fehler *im* Checkheft, gemessen gegen den Stand, den das Checkheft in seinem eigenen §0.3 als seinen nennt (`8e58f691`): **G-1** („`axis_inventory.tex` wird 0-mal referenziert" — falsch, zwei Treffer) und **G-2** („7 der 8 Alt-Kapitel sind unmarkiert" — falsch, es sind 0). Beide Heilungen lagen um **19:34**, also vor der Abfassung des Dokuments, das sie als offen fuehrte. Ein Verdichtungsdokument, das seinen eigenen Messstand nennt und ihn dann nicht anwendet, ist ein Musterfall der Klasse.

> **Und dieses Gesamt-Dossier ist der naechste Musterfall:** Abschnitt 0 / W-2 fuehrt drei eigene Instanzen auf. Die Regel ist nicht schwer zu verstehen; sie ist schwer einzuhalten, weil sie Disziplin verlangt statt Konstruktion — siehe III.10.

#### III.3.2 FA-2 — Schreibweise: der Bericht, der blind gegen seinen eigenen Text war

Ledger `:4266-4272`, verbatim:

> *„Eine fruehere Erhebung stuetzte dieselbe (richtige) Schlussfolgerung auf ein **falsches Argument** — sie meldete ‚null `dreiphasig`-Treffer im gesamten docs-Baum'. Real sind es **8**. Der Owner schreibt `DREIPHASIG` in **VERSALIEN**, die Suche lief case-sensitiv. **Der Bericht war blind gegen seinen eigenen Text: er zitierte den Satz und meldete im selben Dokument, es gebe ihn nicht.** Die Schlussfolgerung traegt (unabhaengig durch LEDGER:4082/4095), das Argument nicht — es darf nicht weiterzitiert werden."*

Dieser Fall ist die **schwerste Variante der ganzen Familie**, und zwar aus einem Grund, der leicht uebersehen wird: **das Ergebnis war richtig.** Die Aussage ueber die Dreiphasigkeit stimmte; sie wurde vom Owner am selben Abend ratifiziert (`bak 3445`: „Alles korrekt erkannt"). Wer nur Ergebnisse prueft, findet hier nichts. Der Defekt sitzt ausschliesslich in der Begruendung — und eine falsche Begruendung wandert weiter, wird zitiert und traegt beim naechsten Mal ein Ergebnis, das nicht stimmt.

Daraus die Auflage, unter der auch dieses Dossier erhoben wurde: **`grep` immer mit `-i`.**

#### III.3.3 FA-3 — Ort: `grep -v "/build"` frisst `/builder/`

Zweimal unabhaengig gefunden, im selben Wellenbuendel, von zwei verschiedenen Agenten.

`wf_5e16833d-6e7__03`, verbatim:

> *„**EIGENER ARBEITSFEHLER, korrigiert und benannt:** mein erster Pinning-Sweep filterte mit `grep -v "/build"` — das frisst `/builder/` mit. Die erste Runde meldete deshalb `sched_setaffinity` = 0 Treffer im ce. Das war **falsch**. Nach Ersetzen des Filters durch explizite Verzeichnislisten erscheint der reale Aktuator. Jede Null unten ist mit diesem korrigierten Filter erhoben und traegt eine Gegenprobe."*

`wf_5e16833d-6e7__02`, verbatim:

> *„**Methodik-Warnung fuer Folge-Agenten:** `git grep … | /usr/bin/grep -v "/build"` schluckt **alle** `libs/cache_engine/builder/`-Dateien (Substring `/build`). Zwei meiner ersten Suchen liefen deshalb falsch-negativ (u.a. `linux_perf_pmc_source.hpp` und `thread_pinning.hpp` verschwanden). Nur `/build/` mit Schluss-Slash filtern."*

Was dabei verschwunden war, ist am Objekt nachgeprueft und existiert: `libs/cache_engine/builder/measurement/thread_pinning.hpp`, `class ScopedThreadPin`, `sched_setaffinity` in **Zeile 61** (Setzen) und **Zeile 75** (RAII-Restore). **Das ist die einzige Pinning-Stelle im Repo** — und exakt der Baustein, den Owner-KERN 5 braucht.

**Die falsche Null haette einen Neubau ausgeloest, den es nicht braucht.** Das ist die Kostenseite dieser Fehlerklasse in ihrer reinsten Form: nicht ein verpasster Defekt, sondern **erfundene Arbeit**.

Die Lehre ist noch in derselben Nacht in die Methode eingegangen. `wf_f94d1373-f7b__03`, verbatim: *„Nenner: 2233 tracked Dateien (**explizite Verzeichnisliste**; `ext/` und `docs/` bewusst ausgeschlossen, aber **per Positivliste, nicht per `grep -v`**)."*

#### III.3.4 FA-4 — Form: der eigene Filter, der das eigene Verdikt wegfilterte

Checkheft-Posten **N-AE**. Die Verdikt-Zeilen der super-Diff-Hygiene-Wache heissen literal `DIFF-HYGIENE-WACHE: GRUEN.` beziehungsweise `… ROT.` Der Filter, mit dem der Lead die Ausgabe las, lautete `DIFF-HYGIENE:`. Ein `grep -c 'DIFF-HYGIENE:'` ueber das Skript liefert **0**.

Der Vorfall: die Wache meldete `CMakeLists.txt:82 (127 Byte)` korrekt **ROT**. Die Meldung wurde weggefiltert, „gelandet" gemeldet, **Pipeline 15104 fiel**.

Commit `fb9aefdc`, aus dem Repo verifiziert, verbatim:

> *„Die Zeile stand mit 127 Byte im PMC-Paket und hat test:coverage-guard rot gemacht. Mein lokaler Vorlauf hat es NICHT gesehen: das grep-Muster, mit dem ich die Wachen-Ausgabe gefiltert habe, traf die Verdikt-Zeile nicht ('DIFF-HYGIENE:' gegen 'DIFF-HYGIENE-WACHE:'). Die Wache war rot und meldete es korrekt — ich habe die Meldung weggefiltert. Dieselbe Fehlerklasse wie die stillen Nullen des Abends: eine korrekte Messung, die falsch gelesen wurde. Konsequenz: die Wachen-Ausgabe wird ab jetzt vollstaendig gelesen, nicht gefiltert."*

Die Einordnung im Checkheft ist die schaerfste Formulierung der Rekursion, um die es geht:

> *„Der Selbstcheck der Selbstcheck-Ausgabe hat **dieselbe Gestalt wie der urspruengliche Fehler** […] **Das ist SW-4, eine Ebene hoeher, nach der Heilung von SW-4.** Naechste Handlung: keine Filterung der Wachen-Ausgabe; der **Exitcode** ist das Verdikt, nicht ein Suchbegriff."*

Der letzte Halbsatz ist die verallgemeinerbare Lehre des ganzen Abschnitts III.3: **ein Verdikt gehoert in einen Kanal, der nicht durchsucht werden muss.** Ein Exitcode kann man nicht falsch schreiben, nicht case-sensitiv verfehlen und nicht mit einem Pfadfilter wegwerfen.

Und der ergaenzende Beleg, dass es nicht nur um Wachen-Ausgaben geht: `wf_d976ea96-862 #2`/G-6, verbatim: *„mein erster Biss-Lauf meldete `RC=0` fuer den Fehlerfall — **weil ich `$?` hinter einer Pipe nach `tail` gelesen habe. Die Messung war korrekt und beantwortete die Frage ‚was liefert `tail`?'.** Dieselbe Gestalt wie die These des Dossiers; die korrigierte Messung ohne Pipe liefert RC=1."* Auch der Exitcode ist nur so gut wie die Stelle, an der man ihn abgreift.

---

### III.4 Die drei widerlegten Lesarten

Ledger-Nachtrag **abend-4** traegt es im Titel: *„ZWOELF Owner-Praezisierungen in einem Zug […]; **drei davon KORRIGIEREN Lead-Lesarten, die falsch waren**"*. Alle drei betreffen dieselbe Naht — Planer, CEB, Tier-Binary — und alle drei haetten Bauarbeit ausgeloest.

#### III.4.1 LL-1 — „eine CEB je PMU-Domaenen-Satz"

Der Lead hatte die Owner-Vorgabe „je Konfiguration compile time" so gelesen, dass **eine CEB pro PMU-Domaenen-Satz** zu bauen sei, und daraus eine Flottenverdopplung samt Preimage-Aenderung abgeleitet: 34,4 Stunden Neubau plus alle bis dahin erhobenen Messdaten.

Der Owner leitet seine Korrektur mit sechs Worten ein, die keinen Zweifel lassen: **„Du hast ein Verstaendnis-Problem ueber die CEB"** (`bak 3141`, 22:02:43Z). Der vollstaendige Wortlaut steht als **KERN 5** in Kapitel VI, die Mechanik in **I.5.1**.

Der Objekt-Beleg, der die Korrektur traegt und sie von einer Absichtserklaerung in einen Vertrag verwandelt: `system_axis_registry.xml:10` — `target_isa` traegt `binary_id="never"`. Sie kann die Identitaet der Tier-Binary **strukturell nicht anfassen**.

Die unabhaengige Nachpruefung am gebauten Paket bestaetigt es, `wf_f94d1373-f7b__05`, verbatim: *„VERDIKT: **HAELT** — A-15-Stempel-Neutralitaet ist strukturell erzwungen, nicht nur zugesichert. Kein erhobener Wert erreicht Stempel, Preimage oder binary_id. Kein Flotten-Neubau. Der Owner-KERN ‚reine Wiederverwendung, kein zweiter Bau' ist mechanisch gedeckt."*

#### III.4.2 LL-2 — „das Pinning IST die Laufzeit-Freigabe in der CEB"

Die Owner-Korrektur steht als **KERN 6** in Kapitel VI, die Stufen-Tabelle in **I.5.3**.

Das Eingestaendnis des Leads, Transkript `live 11863`: *„Aufgenommen — und das ist die **dritte Korrektur meiner Lesart** heute Abend an derselben Stelle. Ich hatte gesagt: ‚das Pinning ist die Laufzeit-Freigabe in der CEB.' Falsch. Die Freigabe sitzt im **Planer**."*

Bemerkenswert ist die Reaktion: die betroffene Memory-Datei wurde **nicht ueberschrieben, sondern markiert** — Punkt 5 traegt seither den Vermerk *„ACHTUNG — die Stufigkeit steht in Punkt 9, meine erste Lesart (‚das Pinning IST die RT-Freigabe IN DER CEB') war FALSCH."* Das ist die Anwendung der Projektdoktrin *„Doku deprecaten statt loeschen"* auf die eigene falsche Doktrin-Zeile. **Eine geloeschte Falschaussage kehrt zurueck; eine markierte nicht.**

#### III.4.3 LL-3 — `pmc:intel` als Rechteproblem: die teuerste Lesart, weil sie beinahe ausgefuehrt wurde

Dieser Fall ist der Kern von Kapitel III und verdient die volle Chronologie.

**1. Die Vermutung.** Der Lead an den Owner (`live 11023`): *„Auf prod1 lieferte PMC real (`cache_misses_l1 = 4194647`); auf intel greift **vermutlich** `perf_event_paranoid` oder eine fehlende Capability."*

**2. Der Owner entscheidet auf diesen Rat hin.** Transkript `bak 3048` / `live 7014`, 21:45:51Z, verbatim:

> **„Zu Entscheidungen: Bitte (a) fuer intel die perf-Rechte geben, was muss ich dafuer tun? Ein skip ist keine Loesung. Wir machen das richtig"**

**3. Der Lead liefert die Anleitung** (`live 11213-11227`): `cat /proc/sys/kernel/perf_event_paranoid`, Reboot-Festigkeit, Warnung vor `--privileged` und `paranoid=-1`. An dieser Stelle war eine dauerhafte Lockerung der Cluster-Rechte einen Handgriff entfernt.

**4. Der Teammate misst nach** (`codex-t2a-final`), verbatim: *„ENTKRAEFTET: perf_event_paranoid ist NICHT der Unterschied. Beide Traces zeigen `perf_event_paranoid = 1` — **WORTGLEICH identisch** auf prod1 (AMD, gruen) und prod2 (Intel, rot). Gleicher Kernel (6.17.0-35-generic), gleiches Ubuntu 24.04."*

**5. Der Lead misst es selbst nach**, an beiden Job-Traces (365186 amd, 365187 intel): `Job 365187 paranoid: 1` / `Job 365186 paranoid: 1`.

**6. Der Lead an den Owner** (`live 11287`), verbatim: *„**Es ist kein Rechteproblem.** Haetten wir die perf-Rechte vergeben, haette sich nichts geaendert — **meine Empfehlung von vorhin war falsch, und ich bin froh, dass sie geprueft wurde, bevor du sie umgesetzt hast.**"*

**7. Und an den Teammate** (`live 11327`): *„Eine Cluster-Rechte-Lockerung haette nichts geaendert und waere eine **dauerhaft geoeffnete Flanke** gewesen, ohne den Fehler zu beheben. Das ist genau die Fehlerklasse dieses Abends: **eine plausible Ursache, die niemand gemessen hat.**"*

**Dann kippt es ein zweites Mal.** Die Ersatzthese (die Hybrid-PMU sei der Grund) wurde ihrerseits widerlegt, **von drei Agenten unabhaengig** (`wf_49b32e04-eb8`, Ueberschriften woertlich: *„KERNBEFUND, DER DEN AUFTRAG UMSTOSST"* · *„Die Praemisse des Auftrags ist widerlegt. Die intel-Lane HAT PMC-Zugriff."*). Der Beleg steht **im selben roten Job** 365257, 0,47 Sekunden nach dem Fehlschlag:

```
329: delta.available       = 1
329: delta.cache_misses_l1 = 6701028
329: delta.cache_misses_l3 = 4048837
329: delta.dtlb_misses     = 3314004
329: SMOKE_OK
```

**Der echte Defekt, dritte Korrektur:** Test 304 `m3v2_pmc_smoke` mass ein **leeres Fenster**. Im **Vor-Heilungs-Stand** `2b5ecd29~1` am Objekt verifiziert, `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp:41-42` (an ce-HEAD `54106bc9` **geheilt**: dort klammert `begin()/end()` ein reales Pointer-Chasing-Fenster ueber 32 MiB, `:62-69`) —

```cpp
// (1) begin()/end() um den (hier leeren) Mess-Batch — genau das Muster aus run_observable_perm. Delta = 0/false.
pmc->begin();
::comdare::cache_engine::measurement::PmcCounters const delta = pmc->end();
```

und der Dateikopf `:12` sagte es in diesem Stand selbst: *„befuellt row.pmc EXAKT ueber die EINE PMC-Quelle (begin()→[leerer Batch]→end())"*. Folge: `d.t_running == 0` → `read_scaled` liefert `ok=false` → `delta.available = 0`, obwohl die Quelle offen ist. **An ce-HEAD `54106bc9` liest dieselbe Zeile `:12` jetzt** *„begin()->[ECHTES Messfenster]->end()"* (ASCII-Pfeil im Quelltext) — der Defekt ist geschlossen (`2b5ecd29`).

**Und der unangenehmste Teil**, verbatim aus dem Wellenbericht: *„Auf AMD besteht derselbe Test **durch Zufall**. 34–53 L1-Misses, 5–6 dTLB — das ist der Overhead der ioctl/read-Syscalls selbst, Rauschgrenze. 13 Job-Traces ausgewertet: **7/7 AMD nonzero, 6/6 Intel exakt null**, keine Ausnahme. Deterministisch, nicht flaky. **Die intel-Lane hat diesen Test NIE bestanden — sie hat ihn stillgeschaltet.**"*

#### III.4.4 Was LL-3 lehrt: die neue Fehlerklasse R-11

Der eigentliche Fund ist nicht der Zugriff, sondern die **Fehlermeldung**. `wf_d976ea96-862 #1`, verbatim:

> *„`m3v2_pmc_smoke.cpp:92-95` druckt: `[PMC-FEHLER] … Ursache pruefen: perf_event_paranoid, CAP_PERFMON/Executor-Rechte, Container ohne perf.` — **die zitierte Ursachenliste ist eine hartkodierte Vermutung im Testcode, keine Messung.** Und `linux_perf_pmc_source.hpp:111-114` verwirft `errno` ersatzlos: `if (r < 0) { fd_ = -1; return false; }`. **Sie hat drei Fehldiagnosen und einen beinahe ausgefuehrten Cluster-Rechte-Eingriff erzeugt.** Das ist R-1 in der Ausgabe-Richtung: **keine Ursache ohne Messung.**"*

Beide Stellen sind am Objekt verifiziert — die zitierten Zeilennummern gehoeren dem **Vor-Heilungs-Stand** (`2b5ecd29~1`). An ce-HEAD `54106bc9` gilt: die **hartkodierte Ursachenliste steht weiter** (jetzt `m3v2_pmc_smoke.cpp:124-126`, die Ursachen-Zeile `:125`), die **`errno`-Verwerfung ist geheilt** — `linux_perf_pmc_source.hpp` sichert `errno` heute sofort (`:116` *„`int const eno = errno;`"*, Heilung `22e17f57`).

**Die Pointe, die dieses Kapitel traegt: die falsche Lead-Empfehlung war nicht aus der Luft gegriffen. Sie war woertlich aus einer Fehlermeldung im eigenen Code abgeschrieben, die selbst nie gemessen hatte.** Der Fehler war im Produkt vorprogrammiert; der Lead war nur sein Uebertraeger. Eine Vermutung, die einmal als Hilfetext in eine Ausgabe geschrieben wurde, wird beim naechsten Lesen zur Diagnose — und beim uebernaechsten zur Handlungsanweisung an den Owner.

Geheilt in ce `22e17f57` — *„diag(pmc): errno-Sichtbarkeit bei perf_event_open-Fehlschlag — reine Diagnose, kein Verhaltenswechsel"*. Der Kanal liefert seither auf AMD literal:

```
event=cache_misses_l3_ll  type=3  config=65538  errno=2 (No such file or directory)
```

**Das ist keine Null, das ist eine Nichtexistenz** — und der Unterschied zwischen beiden ist genau das, was die Schwere-Leiter abbilden muss.

---

### III.5 Die Fehler, die keine Messfehler waren

Nicht alles laesst sich auf den falschen Ausschnitt zurueckfuehren. Vier weitere Klassen gehoeren ins Kapitel, weil sie denselben Ursprung haben: **eine Aussage ueber die Welt, die nicht gegen die Welt geprueft wurde.**

#### III.5.1 Die sechzehn Arbeitsfehler und ihre Chronologie

Die vollstaendige Liste steht in `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` v3, Teil V (ce `77993f6e`). Ihre fuenf Klassen in einem Satz:

1. **Berichte als Tatsachen uebernommen** — drei falsche Commit-Zuordnungen an den Owner; „B14 ist geheilt" gemeldet, danach fand die Gegenpruefung zwei Blocker; „+26 clang-format-Abweichungen sind kosmetisch" uebernommen, ohne zu fragen, welches Gate sie prueft — **sie waren der Blocker**.
2. **Luecken gemeldet statt uebernommen** — *„ob die Arbeit baut, weiss niemand"* → Owner: **„nun du bist hier um das herauszufinden"**. Und vier Pushes ausgeloest, **keine** Pipeline verifiziert.
3. **Ketten nicht vollendet** — T-1 hat fuenf Schritte (dev-Push → Pipeline gruen → main-FF → Submodul-Bump → super gruen); gestoppt wurde bei Schritt 1. Nur **einer von zwei** Thesis-Zeigern nachgezogen — die CI las den anderen und baute die alte Fassung.
4. **Selbst produzierte Messfehler** — die PDF-Textextraktion ohne Trenner erzeugte den Befund „die Ersatztexte fehlen"; er war falsch (LaTeX-Kerning verkettet Woerter). Der Lead dazu: *„haette ich es nicht hinterfragt, haette jemand funktionierende Arbeit ‚repariert'."*
5. **Ungepruefte Parameter in Auftraegen** — Pruefbereich zu eng (`16a173f2` statt der merge-base `c837d830`): ueber den Lead-Bereich haette die Wache **gruen** gemeldet und waere in der Pipeline rot geworden; **der Agent hat es gefangen.**

**Die Chronologie ist der eigentliche Befund.** Diese Liste wurde am 06.08. um **20:08:14 Z** geschrieben, auf Owner-Auftrag (`bak 2008`, 20:07:01Z: *„Bitte merke dir die Erkenntnis deiner Arbeitsfehler in memory"*). **Saemtliche Fehler aus III.2, III.3 und III.4 sind danach passiert.** Die Selbstkritik hat den Abend nicht verhindert. Das ist kein Vorwurf an die Selbstkritik — es ist der empirische Kern der Meta-Lehre in III.10.

#### III.5.2 Zwei Commits in fremde Wellen-Branches

Ledger abend-3 §D, verbatim: *„Ich habe **zweimal in den Arbeitsbranch einer laufenden Welle committet**, weil der Hauptklon nicht mehr auf `development` stand […] Kein Datenverlust — beide Wellen hatten ihre Arbeit gesichert. **Konsequenz, ab sofort bindend: Landungen laufen ueber eigene Worktrees**."*

Fall 1 (ce, 21:25:02Z): *„**Fehler — und ein gefaehrlicher.** Der ce-Hauptklon steht auf `b-m2-pmc-invariante`, wo die PMC-Welle **gerade mit ungespeicherten Aenderungen arbeitet**."* Fall 2 (super, 21:28:14Z), Symptom war ein irrefuehrendes „Everything up-to-date": *„**Zweiter Fehlgriff derselben Art.**"*

Die Folgekosten trug ein anderer — der Bau-Agent des Zweiges, verbatim: *„Waehrend meines Laufs committete ein anderer Agent `e36071f9` **auf meinen Branch** […] Mein Branch haette die Dublette in den Merge getragen. Repariert **ohne rebase**: `git commit-tree` + `git reset --soft`. Der Baum ist bitgleich."*

**Und die Klasse ist groesser, als der Lead sie fuehrt.** `wf_d976ea96-862 #2`, Befund G-11: *„Die Klasse ‚zwei Schreiber auf einem Objekt' trat heute **DREIMAL** auf"* — (1) der A1-NB-Zwei-Schreiber-Alarm, (2) eine SendMessage-Nachreichung, die einen Agenten als **zweite, workflow-unabhaengige Instanz** resumte, waehrend die erste weiterlief: *„**Beide schrieben in dieselben Dateien.**"*, (3) die zwei Fehl-Commits. *„**Strukturelle Antwort erst im dritten Fall.** Die Owner-Liste fuehrt nur Fall 3."*

**Live gemessen, 07.08. 00:50 Z:** super-Hauptklon HEAD `18a0bdf3` auf `b-ci-rueckschrieb-beide-zeiger`, ce-Submodul-Checkout HEAD `90bca126` auf `b-m2-pmc-invariante`. **Beide Hauptklone stehen bis heute auf fremden Wellen-Branches.** Checkheft-Posten **N-AD** ist offen; die Vorbedingung ist nicht beseitigt, nur umgangen.

> **Und sie hat in diesem Werk zugeschlagen:** Abschnitt 0 / W-3 zeigt, dass zwei Kapitel fuer `perf_event_open` verschiedene Zahlen fuehren, weil eines gegen den Ref und eines gegen den ausgecheckten Arbeitsbaum gemessen hat — und der Arbeitsbaum steht auf `b-m2-pmc-invariante`. **N-AD ist keine Hygiene-Frage. Es ist eine Messfehler-Quelle.**

#### III.5.3 Die falsche Frist

Der ganze Abend wurde gegen den 08.08. priorisiert. Der Owner nennt in `bak 1738` (19:37:43Z) den **15.09.2026** als Endtermin und *„JEDEN Freitag neue Ergebnisse"*. Die Termin-Korrektur stand vorher **0/0** in Ledger und Register: `grep "15.09\|Freitag\|woechentlich"` ueber Ledger und `docs/` lieferte **0 Treffer**. Ledger abend-1 nennt es *„den schwersten Einzelverlust des Tages"*.

Das ist keine Messfehler-Klasse, sondern eine **Buchfuehrungs-Klasse**: eine Groesse, die jede Priorisierung des Tages bestimmte, existierte in keiner gefuehrten Quelle. Ausgefaltet in **Kapitel V.5.1**.

#### III.5.4 Zwei Primaerquellen, die den ganzen Tag ungeoeffnet blieben

Der Owner musste dreimal darauf hinweisen. Die beiden tragenden Saetze stehen im Vorwort und als **KERN 13/14** in Kapitel VI. Der Preis, vom Lead selbst beziffert (`live 7310`), verbatim: *„Ein roter CI-Job, drei falsche Ursachenvermutungen, eine beinahe ausgefuehrte Cluster-Rechte-Aenderung — waehrend die Antwort seit dem 12.04. dort stand."* Und: *„Ich habe eine ganze Session darin gearbeitet, ohne sie ein einziges Mal zu oeffnen."*

Was dort stand, haette LL-3 in fuenf Minuten aufgeloest — siehe **I.4.2**. **Der Plan hatte die Fehlerklasse benannt und den Baustein entworfen; gebaut wurde er nie.**

Daraus **Regel-Zeile 18** und die neue Quellen-Rangfolge (**Kapitel V.2**): **1. Thesis = geltende Spezifikation · 2. Ledger/Plaene nach Datum · 3. `docs/termine` = Historie.**

#### III.5.5 Der Fehler, der dieses Dossier ausgeloest hat

Owner `bak 2533` / `live 6499`, 21:05:18Z, verbatim:

> **„Hattest du gruendlich alle workflow Ergebnisse aus dem letzten Kontext im Backup gelesen und Anknuepfungspunkte zu den aktuellen Aufgaben daraus verglichen?"**

Nein. Ledger abend-3, **Regel-Zeile 16** (`:4695`), verbatim:

> *„**Gesicherte Vorarbeit, die niemand liest, ist verlorene Vorarbeit.** Sechs Bau-Wellen wurden gestartet, bevor die gesicherten Ergebnisse der frueheren Wellen abgeglichen waren. **Die erste Stichprobe warf sofort einen Auftrag um** (M-1). Vor jeder Welle gehoert der Abgleich gegen das, was schon gemessen wurde — nicht danach."*

**Und dieselbe Regel wurde 65 Minuten spaeter ein zweites Mal am selben Tag verletzt.** Owner `live 8014`, 23:59:11Z, verbatim:

> **„Wir hatten doch gerade einen Workflow dazu gefahren und nur die Auswertung des dossiers war offen, hast du die backups aufgesucht und den workflow dort beruecksichtigt?"**

Der Lead hatte das Gesamt-Dossier begonnen, ohne die Wellen-Journale und die beiden Rohdaten-Ablagen zu oeffnen — obwohl der Workflow **gerade** gefahren worden war und nur die Auswertung offenstand. **Die Regel war zu diesem Zeitpunkt sechs Stunden alt und im Ledger festgeschrieben.** Dieses Werk ist die Antwort darauf: die Journale wurden zuerst gelesen (86 Dateien, 265 `result`-Ereignisse, 4,29 MB), dann die verdichteten `.md`.

Der umgeworfene Auftrag, den die erste Stichprobe fing, ist es wert, genannt zu werden: der erste M-1-Bauauftrag liess ein Feld ins Fingerprint-Preimage einbauen und einen **Format-Bump 3→4** fahren. Der bereits gesicherte F2-Deep-Research hatte gemessen, dass die Mess-Zeile dort **laengst steht — als Glied [3] von 8**. Die Welle wurde gestoppt und korrigiert neu gestartet; das Paket landete am Ende **ohne** Format-Bump (ce `bba4d90f`).

Ehrlich dazu: **der Stopp war richtig, seine Begruendung traegt nur auf einem Stand.** `wf_22b0822f-81d__006`, verbatim: *„Die Aussage ‚Format-Bump 3→4 voraussichtlich NICHT noetig' steht gegen drei fruehere Berichte, die genau diesen Bump als den Kern-Bau empfehlen — und zwar **nicht, weil Glied [3] fehlt, sondern weil Glied [3] NICHT AUSREICHT**."* Der Posten bleibt offen.

---

### III.6 Die Gegenseite I: Wachen, die gebissen haben

Dieses Kapitel waere unehrlich, wenn es dort endete. Der Tag hat mehr geheilt als beschaedigt, und die Heilungen folgen einem erkennbaren Bauprinzip.

**Der Satz, der die Gegenseite traegt** — Memory `feedback_eigene_arbeitsfehler_…`, verbatim:

> *„Was zuverlaessig funktioniert hat: **jeder ernsthafte Fund kam daher, dass jemand die EIGENE fruehere Aussage widerlegt hat** — eine Sonde, die die falsche Frage stellte; eine Empfehlung an einer ungemessenen Zahl; ein Schluss aus einem abgebrochenen Werkzeuglauf; meine drei Commit-Zuordnungen. Deshalb: **Doppelpruefung ist kein Luxus, sondern die Arbeitsform.** Und die eigene vorige Aussage ist der erste Kandidat fuer die naechste Pruefung."*

#### III.6.1 Die super-Diff-Hygiene-Wache (super `7780c6af`)

Sie hat **zuerst ihren eigenen Autor gebissen**: sie liegt als `.sh` im eigenen Pruefbereich, und der erste Lauf meldete vier ueberlange Zeilen im eigenen Skript (152/229/251/132 Byte). Erst nach deren Korrektur wurde sie gruen.

Ihr Grenzverhalten wurde gemessen, nicht angenommen: **120 Byte durch, 121 Byte rot**; eine zweite unabhaengige Probe mit 129 Byte ebenfalls gefangen.

Und sie ist so gebaut, dass sie die Fehlerklasse dieses Kapitels **nicht produzieren kann** — am Objekt verifiziert:

- `scripts/ci_diff_ascii_width_guard.sh:537` gibt einen Block `NENNER (nie eine nackte Null):` aus;
- uebersprungene Dateien werden **namentlich** genannt: `Uebersprungene Dateien (namentlich, keine zweite stille Null):`;
- `:197` — `DIFF-HYGIENE-WACHE: ABBRUCH -- $1` auf stderr, mit dem Zusatz *„KEINE stille Null, echter Abbruch"*, wenn `git diff` selbst scheitert (rc=129);
- die ASCII-Erkennung laeuft byteweise ueber eine awk-Zustandsmaschine statt ueber eine Regex-Vermutung, jede Stufe wird einzeln per `$?` geprueft, ein fehlendes Werkzeug ist **FATAL statt stiller Null**.

**Die Lehre steckt hier im Werkzeug statt in der Disziplin.** Das ist der Unterschied, auf den III.10 hinauslaeuft.

#### III.6.2 Die PMC-Invariante (ce `8894d983`) — der Bissbeweis 4/4

Das Flag wurde einzeln an jeder der vier Traegerstellen entfernt, neu gebaut, der Test gefahren → **4/4 rot, gtest-exit=1**.

Und die Zahl vier wurde **hergeleitet, nicht geglaubt**: der Agent suchte nach dem **Kriterium** (`--target comdare-messung-driver`), nicht nach „den vieren". Gegenprobe mit Nenner: 15 `cmake -B`-Stellen gesamt = 4 Emissionen + 1 Kommentar + 4 in `permutation_build_command.hpp` (baut kein Mess-Target) + 6 in Tests. **Keine fuenfte Traegerstelle.**

Der Satz, der dabei entstand und in die Konstruktion selbst einging: *„Ein Pruefer, der nicht nachweislich findet, taugt nicht als Zeuge fuer eine Null"* — die Gegenprobe wanderte in den **Test**, nicht in ein Protokoll.

#### III.6.3 Die Thesis-Gitlink-Paritaetswache (super `3ccbc501`)

Ihr Biss-Nachweis lief sechsstufig in einem isolierten Klon. Die entscheidende Zeile, verbatim: *„**Die alte Wache ist blind.** `REV-CI-04: GRUEN — 0 Treffer bei Nenner 2. Die alte Wache SIEHT die Divergenz NICHT.`"* Sie pruefte **Worktree gegen Gitlink**, nicht **Gitlink gegen Gitlink**.

Sie ist bewusst **ohne grep in der Kernlogik** gebaut (`ls-tree` / `ls-files --stage` plus awk `$1 == "160000"`), also strukturell immun gegen die `^\+\+\+`-Falle, kein `|| true`, kein Zweig, der bei leerem Ergebnis 0 liefert.

Und der Strukturfund dahinter: *„die CI **ERZEUGT** die Divergenz bei jedem Rueckschrieb selbst"*, dazu ein Fruehausstieg, der nur den ersten Zeiger pruefte — *„die Divergenz war nicht nur erzeugt, sondern auch **selbstverriegelt**"*.

#### III.6.4 Die YAML-Schluessel-Wache (ce `597ecffe`)

Commit-Betreff am Objekt verifiziert: *„ci(r4): doppelter Job-Schluessel contract:axis-version-lock zusammengefuehrt — der Heuristik-Tripwire war 3 Wochen faktisch AUS; Schluessel-Wache gegen die Rueckkehr der Klasse"*.

Der Job war zweimal definiert (`:393` ohne `rules` = hart, `:574` mit inertem `rules`), last-wins ⇒ **der Tripwire lief seit dem 19.07. in keinem einzigen Lauf.** Empirischer Beleg: 31 Schluessel-Zeilen gegen 30 geparste Schluessel, nach der Heilung 30/30.

**Und der Tripwire biss unmittelbar danach:** `measurement_curve_loader.hpp` war seit `e016eccc` (19.07.) zweimal semantisch gedriftet, geheilt durch `557d8023` (`AXIS_ALGO_VERSION 1→2` plus Lock-Regeneration). Was diese Drift betrifft, steht in **II.8.6**.

Bemerkenswert ist, dass der Autor die **Grenze seiner eigenen Wache** benennt, verbatim: *„wird der tragende Job `test:coverage-guard` selbst dupliziert und inert ueberschrieben, faehrt die Wache nicht — **innerhalb der Datei nicht loesbar**, bewusst so stehen gelassen."* **Eine Wache, die weiss, was sie nicht sieht, ist die Umkehrung der stillen Null.**

#### III.6.5 Der Wurzelschnitt `test:coverage-guard` (ce `dcb2f08f`)

Commit-Kommentar, verbatim: *„R4 — DER WURZELSCHNITT. Bis hierher stand hier `COMDARE_TEST_CTEST_ARGS: "-LE contract\|pmc"` … am 2026-08-06 liefen **9 Tests in KEINEM Job**"* — namentlich aufgezaehlt.

Das ist die direkte Umsetzung des Owner-Verbots aus `live 3041`: *„Ein Ausschluss loest die Wurzel des Problems NICHT, das ist verboten."* Statt des einen beauftragten Tests wurde eine **strukturelle Invariante** gebaut: 407/407, eine Wahrheitsquelle fuer alle ctest-Auswahlen, ein Gate ueber den Gates.

---

### III.7 Die Gegenseite II: Selbstkorrekturen und zurueckgewiesene Praemissen

#### III.7.1 Die Selbstkorrektur als Arbeitsform

Der Ueberblick (§4.2) fuehrt **zwanzig** Selbstkorrekturen mit Bericht-ID; sie werden hier nicht wiederholt. Was dort **fehlt**, weil das Dokument um 20:32 aus dem Backup-Stand erhoben wurde, sind die Abend-Wellen. Eine eigene Nachzaehlung ueber alle Journale (Muster `selbstkorrektur|EIGENER ARBEITSFEHLER|praemisse|widerlegt|zurueckgewiesen|TRIFFT NICHT ZU|korrigiert und benannt|ich rate nicht`, case-insensitiv, `grep -iEc` ueber die `"type":"result"`-Zeilen) findet das Signal mit **exakt diesem ASCII-Muster in 101 von 265 `result`-Ereignissen** (Stand 07.08., 265 = alle `result`-Ereignisse; mit Umlaut-Varianten wie `Prämisse`/`zurückgewiesen` sind es 108 — die Zahl ist markermusterabhaengig, die urspruenglich genannte „104" ist mit dem Rezept nicht mehr reproduzierbar, da die Journale wachsen). Fuenf davon gehoeren ins Kapitel, weil sie die These an ihrem eigenen Werkzeug zeigen:

**Die schaerfste**, verbatim: *„**EHRLICHE SELBSTKORREKTUR:** meine TSAN-Sonde des Erst-Reviews hatte genau diesen Fall nachgestellt und als [OK] gebucht — **ich hatte gefragt ‚haengt drain()?' (nein) statt ‚haelt die Barriere?' (nein)**. Der Befund kam von Codex; **ich hatte ihn in der Hand und nicht gesehen.**"* — Die Sonde lief korrekt. Sie beantwortete die falsche Frage. Der Satz ist die These, geschrieben von jemandem, der sie nicht als These kannte.

**Die zweite** ist besonders, weil sie im Produktivcode steht: `libs/cache_engine/builder/linux_perf_pmc_source.hpp:9-17` **ist selbst eine Selbstkorrektur vom 06.08.**, verbatim aus der Datei:

> *„WAS SIE REAL LIEFERT (B5/M-2-KORREKTUR 2026-08-06): der Kopf sagte frueher ‚+6 HW-Counter (… best-effort L2/coherence, RAPL-energy)'. Das war die aeltere, zu optimistische Fassung und widersprach dem eigenen Code weiter unten. TATSAECHLICH GEOEFFNET werden DREI generische Counter […] branch_misses wird von KEINER PMC-Quelle befuellt (offener Posten M-3a). Diese honest-0-Spalten sind im Anhang als solche zu fuehren, nicht als gemessen."*

**Und die korrigierte Fassung war auf prod1 wieder falsch.** Sie schrieb `cache_misses_l3 (LAST-LEVEL/READ/MISS, ehrlich LL)` — aber `PERF_COUNT_HW_CACHE_LL` laesst sich auf Zen 5 gar nicht oeffnen (`errno=2`, per strace belegt). **Die Ehrlichmachung selbst war auf der Haupt-Mess-Lane erneut unehrlich.** Der Wellenbericht nennt das *„hoechste Dringlichkeit unter allen Befunden"*. **Geheilt seit 07.08. 00:14 (ce `5c102e05` / `c4c04315`)** — siehe I.4.4 und Abschnitt 0 / W-2.

**Drei weitere in Kurzform:**

- `wf_d976ea96-862 #2`/G-8: *„mein erster Zaehlversuch mit `grep -o "<axis_sweep"` lieferte **18** statt 17, weil der Container `<axis_sweeps>` mitzaehlt. … **Eine Zahl ohne genannte Zaehlmethode ist nicht nachpruefbar** — hier an mir selbst."* **Genau diese Klasse ist in diesem Werk als W-1 wieder aufgetreten.**
- *„Die Zahl ‚8439→8444' ist **nicht reproduzierbar** — 178 von 407 ctest-Binaries sind gar keine gtest-Binaries; je nach Zaehlregel 3137 / 7967 / 8463. **Die Aussage haelt, der Beleg nicht.**"* — dieselbe Trennung wie in FA-2.
- Die Fingerprint-Haertung durchlief **drei eigene Selbstkorrekturen**, darunter *„die Zusage ‚einziger nicht umgehbarer Ort' war **schlicht UNWAHR**: `.value` war public und mutierbar"* und *„die erste Fassung `explicit X(std::string&&) = delete` **brach den Bau flottenweit**"*.

Und die Haltung, die keine Korrektur ist, sondern ihre Voraussetzung: *„Die zwei moeglichen `ok=false`-Zweige sind aus dem Trace nicht unterscheidbar. **Ich rate nicht.**"*

#### III.7.2 Wo ein Agent die Praemisse seines Auftrags zurueckwies

Elf Faelle sind belegt; sie stehen vollstaendig in `wf_d976ea96-862 #1`, Kapitel A. Fuenf zeigen die Bandbreite:

| Praemisse (vom Lead) | Widerlegung | Was sie verhinderte |
|---|---|---|
| „`pmc:intel` hat keinen PMC-Zugriff" | *„Die Praemisse des Auftrags ist widerlegt. Die intel-Lane HAT PMC-Zugriff."* — drei Agenten unabhaengig, Beleg im selben roten Job | Cluster-Rechte-Eingriff (III.4.3) |
| „xmllint ist bereits im Einsatz" | *„**PRAEMISSEN-KORREKTUR meines Auftrags: TRIFFT NICHT ZU**"* — keine Fundstelle ausser Kommentaren; Runner-Praesenz ist *„Annahme, nicht Beleg"* | Scharfschalten auf ungeprüfter Infrastruktur |
| „der Wurzelpfad in `target_include_directories` ist toter Ballast" | 146 woertliche Treffer, 143 distinkte Ziele, 17 generierte Achsen-Flag-Header, 187 von 429 TUs haengen daran: *„Ein pauschaler Streich-Refactor waere eine **Regression**."* | einen Bau-Auftrag, der den Bau gebrochen haette |
| „`pmc_branch_misses` wird real erhoben" (so steht es im Kommentar `cache_engine_builder_iterator.hpp:499`) | *„**Praemisse am Objekt falsch; der absichernde Test setzt den Wert selbst.**"* — 14 Treffer, genau eine Zuweisung, keine PMC-Quelle schreibt das Feld je. **Drei Kommentare am selben HEAD, zwei behaupten das Gegenteil des dritten.** | eine Falschaussage in der Abgabe (offen, M-3a) |
| „`TargetIsaAxisSel::numa_node` hat null Leser" | *„die Praemisse ist **widerlegt**, und es gibt eine **Namensfalle** — die zweite, voll verdrahtete Unterachse `alloc_hw.numa_node` (152 gegen 23 Treffer). **Wer hier ungeprueft ‚anschliesst', trifft die falsche Achse.**"* | einen Anschluss an der falschen Achse |

Ein sechster Fall zeigt die Klasse in ihrer heimtueckischsten Form: *„Ein Explore hat `22_CI_…:97` ohne den Zusatz **‚bis #26'** zitiert und als geltende Regel gefuehrt; **#26 ist am 12.07. vollzogen**. Fehlerklasse: **eine Entlastung, die auf einer ungeprueften Praemisse steht** — hier durch ein abgeschnittenes Zitat, **das die Verfallsbedingung wegschneidet**."* Ein falscher Ausschnitt kann also nicht nur eine Sperre verbergen, sondern auch **eine abgelaufene Sperre am Leben halten**.

**Was daraus folgt, ist eine Aussage ueber die Arbeitsform, nicht ueber einzelne Agenten:** In elf Faellen hat ein beauftragter Agent den Auftrag zurueckgewiesen, statt ihn auszufuehren. In keinem dieser Faelle war die Zurueckweisung falsch. Das ist die staerkste Einzelbeobachtung der Gegenseite — und sie funktioniert nur, wenn ein Auftrag als **Hypothese** formuliert wird, die geprueft werden darf, nicht als Anweisung, die auszufuehren ist.

#### III.7.3 Der Pruefer als Struktur

Der Codex-Kipp-Zaehler, Ueberblick §4.3, verbatim:

> *„honest-empty, E18-SNAP-1, A1, B14, Teil-2, E18-SNAP-NB, A1 — in **7 von 7 Faellen** sagte Fable ‚LANDEBEREIT', Codex ‚NICHT LANDEN', **der Lead folgte Codex**."*

Der Tagesanker nennt am Ende **elf** Kipps. Der Owner-Satz dahinter: *„codex findet nuetzliche Regressionen"*.

Und die Ehrlichkeit ueber den Ausfall des Pruefers gehoert dazu: *„**Codex-Ausfall zweifach hart belegt** (nicht angenommen) — in beiden Review-Runden auf prod1 antwortete Codex nicht → Gate-Erfuellung ueber Option (b)."*

---

### III.8 Die Gegenseite III: der Owner als Pruefer

Von den zehn Owner-Korrekturen dieser Session, die eine Lead-Lesart widerlegt haben, war **keine einzige falsch**. Das ist eine Bilanz, die im Kapitel stehen muss, weil sie die Delegationslogik veraendert: die Rueckfrage an den Owner ist kein Eskalationsmittel, sondern die zuverlaessigste Pruefung im System.

Vier Eingriffe, die je einen Fehler aufdeckten, den der Lead allein nicht gefunden haette — der Lead hat sie selbst gezaehlt (`live 7509`), verbatim:

> 1. *„Hast du die Backups gelesen?"* → Ein Bauauftrag stand auf ueberholten Annahmen, Welle gestoppt.
> 2. *„Es ist alles geplant, lies mit Explore"* → `docs/termine/` war die ganze Session ungeoeffnet.
> 3. *„Die Diplomarbeit ist die Anforderung"* → Die Thesis hatte ich nur als Bau-Artefakt behandelt, nie als Spezifikation.

**Der vierte kam 65 Minuten nach dieser Bilanz** (`live 8014`, III.5.5). Die Zaehlung war zum Zeitpunkt ihrer Aufstellung bereits unvollstaendig — auch das gehoert ins Kapitel.

Zwei weitere Owner-Eingriffe mit unmittelbarer Wirkung:

- **„Es existiert kein CSV Lager. xlsx ist default."** (`live 2155`, 11:15:10Z) — eine direkte Widerlegung einer Lead-Beschreibung, die ein Datenfluss-Bild statt der geltenden Vertrags-Sprache verwendete (siehe I.1).
- **„Es gibt keine Unklarheiten nach ueber 1500 beantworteten Fragen — nur Gedaechtnisluecken."** (`live 2189`, 11:18:32Z) — die Abschaffung der Kategorie „offen": jede „offene Frage" ist bis zum Gegenbeweis eine **Lesepflicht**, keine Owner-Pflicht.

Und die eine Stelle, an der der Owner **seine eigene Planung** als Fehlerquelle benennt — `live 2704`, F4, verbatim: *„es gibt 3 Versionen dieser UML Zusammenfassung und die letzte ist nicht superseded, sondern nur vorlaeufig und braucht unbedingt immer Verifikation, bevor das geglaubte auch bewiesen ist — **die Planung war teils ungenau.**"* Der Halbsatz *„bevor das geglaubte auch bewiesen ist"* ist die Kurzform der ganzen Doktrin dieses Kapitels.

**Die lehrreichste Stelle der Session ist allerdings die, an der der Owner-Entscheid richtig und seine Begruendung ueberholt war.** In `bak 3048` verlangt er (a) die perf-Rechte und (b) „Wir machen das richtig". (a) erwies sich als wirkungslos — es war kein Rechteproblem. (b) wurde erfuellt, und zwar **staerker**, als (a) es vorsah: der Fehler wurde im eigenen Code repariert, statt eine Flanke zu oeffnen. **Ein Prinzip ueberlebt seine eigene Handlungsanweisung, wenn jemand nachmisst.**

---

### III.9 Die Schwere-Leiter als Ergebnis dieser Erfahrung

Die Leiter selbst — WARN / ERROR / FATAL mit ihren Owner-Definitionen und Beispielen — steht in **I.6** und wird hier nicht wiederholt. Was hier zaehlt, ist ihre **Entstehung**: sie ist keine Designentscheidung am Reissbrett, sondern an drei aufeinanderfolgenden Vorfaellen erarbeitet, und der Owner hat sie in drei Nachrichten binnen 51 Minuten definiert.

| Zeit (Z) | Fundstelle | Was hinzukam | Anlassfall |
|---|---|---|---|
| **22:08:13** | `bak 3189` (KERN 7) | **WARN** — ehrlich erhoben, Ort unbestimmt | fehlendes Pinning |
| **22:13:48** | `bak 3226` (KERN 9) | **ERROR** (fehlende Systemeigenschaft) und **FATAL** (Integritaet zerstoert) | GPU-Beispiel; Lager-Inkonsistenz |
| **22:59:15** | `bak 3547` (KERN 10) | **ERROR (b)** — der **stille Rueckfall** | Regressionen, die sich nicht melden |

Die entscheidende Abgrenzung, die der Owner im selben Zug mitgab und die der wichtigste Teil der Leiter ist:

- **Pinning fehlt** = ein ehrlicher Messwert, nur der Ort ist unbestimmt → **warn**.
- **`cache_misses_l3_ll` mit `errno=2`** = **gar kein Messwert**, der Zaehler existiert in dieser Kodierung nicht → **nicht warn**, denn eine Zahl auszugeben waere **Erfindung**.

Die zweite Zeile ist seit 07.08. 00:14 im Code (`5c102e05`): die Zelle rendert `SourceUnavailable`/`n/a`, und **eine echte 0 bleibt 0**. Das ist die erste gebaute Umsetzung von KERN 10.

#### III.9.1 Der Nachweis, der die Leiter zu einer Wiederentdeckung macht

Und hier schliesst sich der Kreis dieses Kapitels auf die unangenehmste Weise. Noch am selben Abend (`live 7352`) wurde festgestellt:

**Die GPU-Definition von `error` steht seit dem 26.07. woertlich im Code** — `axis_error.hpp`, 655 Zeilen, mit `BetriebssystemFeatureFehlt` als exakter Klasse fuer „der Kernel reicht Pinning nicht durch". Und das Muster existiert fuer AVX512 bereits ausgebaut, Ledger `:2492`, verbatim:

> *„ein avx512-Ausschluss erfolgt **NUR maschinenseitig mit WARNUNG** (Fehlerklasse `HardwareErweiterungFehlt`, **es wird weitergemessen**), NIE als stiller Profil-Filter."*

**Das ist buchstaeblich der Pinning-Kompromiss, nur fuer eine andere Hardware-Eigenschaft.** Der Owner-KERN vom 06.08. war keine neue Anforderung, sondern die Wiederentdeckung des eigenen, elf Tage alten Kanons — Gedaechtnisluecke in Reinform, genau wie `live 2189` es gesagt hatte.

Die Leiter ist damit **nicht zu erfinden, sondern anzuschliessen**: die Fehlerklassen existieren, die Doktrin existiert, was fehlt, ist die Verdrahtung von Pinning-Pruefung und PMC-Nichtexistenz an dieses vorhandene System.

**Die Luecke, die der Ledger daraus zieht** (abend-4 §6): die **Zell**-Zustaende sind kanonisch, die **Doktrin**-Vokabeln (`honest-0`, `honest-empty`, `honest-100%`) sind ueber Ledger, Thesis und Session-Dokumente **verstreut** — **kein Dokument fuehrt beide gemeinsam auf.** Genau deshalb konnte an diesem Abend eine Zustands-Leiter „neu erarbeitet" werden, die es laengst gibt.

---

### III.10 Die Meta-Lehre: Merksaetze tragen nicht, Werkzeuge tragen

#### III.10.1 Der empirische Befund

Checkheft-Posten **N-Y**, `[ ] OFFEN`, verbatim: *„Der Weg ‚Regel dokumentieren' ist hier nachweislich schon beschritten worden und hat nicht getragen."*

Die Belege aus dieser einen Session:

- **Regel-Zeile 15** („eine Pruefung, die ihren Gegenstand nicht erreicht, meldet gruen") wurde **zweimal binnen zwei Stunden nach ihrer Formulierung verletzt** — SN-3 und FA-4.
- **Regel-Zeile 16** („gesicherte Vorarbeit, die niemand liest, ist verlorene Vorarbeit") wurde **am selben Tag ein zweites Mal verletzt**, sechs Stunden nach ihrer Niederschrift, und zwar beim Start genau dieses Dossiers.
- **Regel-Zeile 17** („jeder Befund traegt sein Erhebungsdatum") wurde in diesem Gesamt-Dossier **dreimal** verletzt — Abschnitt 0 / W-2.
- **R-19** („eine Anzahl ist eine Vollstaendigkeitsaussage — ersetze sie durch die Liste") wurde in diesem Gesamt-Dossier **zweimal** verletzt — Abschnitt 0 / W-1.
- **Die sechzehn Arbeitsfehler** wurden um 20:08 dokumentiert; die schwersten Fehler des Tages passierten **danach**.
- **Zwoelf Format-Gate-Nachzuege an einem Tag** (ce 7, super 5). Bewertung des Pruefers, verbatim: *„die Zahl **12/1 Tag** als Klassen-Signal geben — **Disziplin traegt hier messbar nicht.**"*

Dem gegenueber steht, was **getragen hat** — ausnahmslos: eine Nenner-Ausgabe im Skript · ein fail-closed-Zweig · ein `test -x`-Gate · eine awk-Zustandsmaschine statt einer Regex-Vermutung · ein Exitcode statt eines Suchbegriffs · eine Gegenprobe **im Test** statt im Protokoll · eine Fundstellen-Liste statt einer Anzahl.

**In dieser Session hat kein einziger Merksatz einen Fehler verhindert. Jedes Werkzeug, das den Fehler bauartbedingt nicht zulassen konnte, hat gebissen.**

#### III.10.2 Die abgeleiteten Regeln, mit ihrem Anlassfall

Die Regeln sind Kondensat, nicht Ersatz. Ihr Wert liegt darin, dass sie sagen, **welche Wache gebaut werden muss** — nicht darin, dass jemand sie sich merkt.

| Regel | Anlassfall in dieser Session |
|---|---|
| **R-1** Keine Null ohne Nenner | ugrep/GNU-BRE-Doppelbruch; „ASCII: 0" ohne Bezugsgroesse |
| **R-2** Pruefbereich = Dateimenge **und** Commit-Bereich; Bereich = merge-base | `16a173f2` statt `c837d830`: der enge Bereich verbarg **890 von 1448 Zeilen = 61 %** |
| **R-3** „X liest niemand" ist eine Vollstaendigkeitsaussage | Kostenklammer `plan_identitaet_of`; „AP-04 hat 0 Aufrufer" war falsch |
| **R-4** Bei generierten Artefakten beweist Abwesenheit im Quell-Repo nichts | `COMDARE_BESTANDSLOG` (IV.6.6) |
| **R-5** Zur Testzahl gehoert der Bau-Zustand | falsches Gruen 404 statt 408: configure → **BAU** → configure |
| **R-6** Ein gruenes Gate deckt nur seinen eigenen Gegenstand | 12 Format-Nachzuege an einem Tag |
| **R-8/R-12** Ein Submodul-Zeiger kann rueckwaerts zeigen; **Richtung ist nicht Erreichbarkeit** | die vorgeschlagene Gitlink-Wache haette den live stehenden Fall **durchgewunken**: `merge-base --is-ancestor b241a272 90bca126` = wahr, aber `90bca126` liegt **auf keinem Remote** |
| **R-9** Eine rescue-Ref ist keine Landung | 13 von 18 ce-rescue-Refs fuhren rot, alle inhaltlich korrekt |
| **R-11** **Keine Ursache ohne Messung** | die hartkodierte Ursachenliste in `m3v2_pmc_smoke.cpp` (ce-HEAD `54106bc9`: `:124-126`, Ursachen-Zeile `:125`; Anlassfall-Stand `2b5ecd29~1`: `:94-95`) bei — im Anlassfall — verworfenem `errno` (seit `22e17f57` gesichert) — drei Fehldiagnosen, ein beinahe ausgefuehrter Cluster-Eingriff |
| **R-13** Eine Wache darf nicht im Gegenstand ihrer eigenen Fehlerklasse wohnen; ihr Sollwert nicht aus demselben Commit stammen wie ihr Istwert | `557d8023` setzte die Version **und** erzeugte die Lock-Datei neu ⇒ **gruen per Konstruktion** |
| **R-14** **Eine Migration erbt die Fehlerklasse, die sie beseitigt** | die xmllint-Migration baute **elf neue False-Green-Pfade** ein; `2c631551` sagt es selbst: *„Die Befunde hier sind LUECKEN DER MIGRATION SELBST."* |
| **R-17** Die Ablage darf ihren eigenen Beleg nicht verschlucken | `.gitignore:49` = `*.log`; von 155 `.log` unter `docs/sessions/backups/` kennt git **77**, die anderen **78 liegen in keinem git-Objekt** |
| **R-18** Jeder Befund traegt Erhebungsdatum und Zweigkopf | A-7/A-8; G-1/G-2 **im Checkheft selbst**; **W-2 in diesem Werk** |
| **R-19** Eine Zusage ueber eine **Anzahl** ist eine Vollstaendigkeitsaussage — ersetze sie durch die **Liste** | „der EINE literale Pin" → zweimal widerlegt, zweimal stehen gelassen, beim naechsten Bump waren es **vier** (`4b38d072`); **W-1 in diesem Werk** |
| **R-20** Ein Code-Kommentar ist Beleg fuer den Code, nie fuer die Absicht | `read_batch_plan`; `.gitlab-ci.yml:476-478`; `cache_engine_builder_iterator.hpp:499` |
| **RZ-15** Eine Pruefung, die ihren Gegenstand nicht erreicht, meldet **gruen** | die drei stillen Nullen |
| **RZ-16** Gesicherte Vorarbeit, die niemand liest, ist verlorene Vorarbeit | sechs Wellen vor dem Abgleich gestartet; die erste Stichprobe warf M-1 um |
| **RZ-17** Ein Datum an einem Fund ist ein PFLICHTFELD fuer die Nachmessung | A-7/A-8 als Bau-Auftraege fuer bereits geheilte Defekte |
| **RZ-18** Vor jeder Ursachensuche `docs/termine/` lesen; die Thesis ist Spezifikation | zwei Primaerquellen den ganzen Tag ungeoeffnet |

**R-19 verdient die letzte Bemerkung des Kapitels**, weil sie die reinste Formulierung des ganzen Problems ist. Commit `4b38d072`, verbatim: *„er sprach von ‚dem EINEN literalen Pin', E-24 C8 fand einen ZWEITEN und stellte ihn um, **liess den Wortlaut aber stehen. Beim naechsten Bump waren es dann VIER.**"* Und die Ehrlichkeit dazu: *„**GEFUNDEN HAT SIE NICHT DIESER KOPF, SONDERN DER ctest-DOPPELLAUF**"* — es gab keine Wache, nur den Bump.

Eine Anzahl ist eine Behauptung ueber das, was man **nicht** gesehen hat. Eine Liste ist eine Behauptung ueber das, was man gesehen hat. Der Unterschied zwischen beiden ist derselbe wie der zwischen einer gruenen Null und einem genannten Nenner.

#### III.10.3 Was aus diesem Kapitel als Arbeit folgt

Fuenf Posten, die aus III.1 bis III.9 unmittelbar hervorgehen und heute offen sind:

1. **Der gitleaks-Aufruf gehoert in ein Skript mit Nenner-Ausgabe** (`commits scanned` als Abbruchbedingung, nicht als Fussnote) — SN-1/SN-3, bis heute Handlung statt Gate.
2. **Die Schwere-Leiter an `axis_error.hpp` anschliessen**: Pinning-Pruefung (CPU **und** Kernel) → `BetriebssystemFeatureFehlt` mit WARN nach dem AVX512-Muster. Die PMC-Nichtexistenz-Haelfte ist seit 00:14 gebaut; die Pinning-Haelfte fehlt.
3. **`m3v2_pmc_smoke` misst ein echtes Fenster** — geheilt in ce `2b5ecd29`, aber die Frage, warum ein Test, der auf einer von zwei Lanes seit jeher fehlschlaegt, sechs Laeufe lang niemandem auffiel, ist eine **Gate-Frage, keine Testfrage**.
4. **Die Zwei-Schreiber-Vorbedingung beseitigen** — beide Hauptklone stehen bis heute auf fremden Wellen-Branches (N-AD), und die Klasse hat in diesem Werk real eine Zahlendifferenz erzeugt.
5. **`branch_misses` (M-3a)** — drei Kommentare am selben HEAD, zwei behaupten das Gegenteil des dritten; die CSV-Spalte steht seit dem 04.08. im Header und traegt immer den Default 0.

---

### III.11 Schlussbemerkung

Die Fehler dieses Tages sind nicht deshalb interessant, weil sie schwer waren. Sie sind interessant, weil sie ganz ueberwiegend **eine** Gestalt teilen — die Hauptklasse, nicht die vollstaendige Typologie (das Checkheft nennt in VII.5 drei Gestalten, die sie nicht abdeckt) — und weil diese Gestalt eine Bauform hat.

Die Gestalt: **eine korrekte Messung, die die falsche Frage beantwortet.** Sie entsteht aus vier Ausschnitten — Zeit, Schreibweise, Ort, Form — und aus einer Lesart, die zwischen die Messung und ihre Auswertung tritt.

Die Bauform: **der stille Rueckfall.** Ein System, das auf Ersatzverhalten zurueckfaellt, ohne es zu sagen, produziert gruene Antworten auf Fragen, die niemand gestellt hat.

Das Gegenmittel ist an keiner Stelle dieses Tages ein Vorsatz gewesen. Es war jedes Mal eine Konstruktion: ein Nenner in der Ausgabe, ein Exitcode statt eines Suchbegriffs, eine namentliche Liste statt einer Anzahl, eine Gegenprobe im Test statt im Protokoll, ein `FATAL` statt einer stillen Null. Und, an den vier folgenreichsten Stellen des Tages, jemand, der nachgefragt hat, bevor jemand anderes gehandelt hat.

---

## KAPITEL IV — WAS STEHT, WAS FEHLT

> **Erhebungsdatum: 2026-08-07, 00:20 UTC.** Gemessen am Objekt, nach `git fetch`, gegen `origin/*` — nie gegen die lokalen Zweige (die sind in allen drei Repos veraltet, siehe IV.0.2). Jede Zahl traegt ihren Stand. Wer dieses Kapitel spaeter liest, misst zuerst nach: **Regel R-18 gilt auch fuer dieses Kapitel.**

### IV.0 Der Stand, gegen den alles zu messen ist

#### IV.0.1 Die Refs, jetzt

| Ref | SHA | Zeit | Abstand |
|---|---|---|---|
| ce `origin/development` | **`c4c04315`** | 07.08. 00:14 | — |
| ce `origin/main` | **`2b5ecd29`** | 06.08. 22:16 | **10 Commits zurueck** |
| super `origin/development` | **`5a98036d`** | 07.08. 00:15 | — |
| super `origin/main` | **`71591a24`** | 07.08. 00:04 | **1 Commit zurueck** |
| thesis `origin/main` == `origin/development` | **`19e15920`** | 06.08. 21:08 | gleichauf |
| super-Gitlink auf ce | **`2b5ecd29`** | in `origin/development` | **10 Landungen hinter ce-`development`** |

**Der Auftragskopf dieses Dossiers nennt ce `2b5ecd29` auf dev UND main und super `33edd4cd`. Beide Angaben sind ueberholt** — und zwar nicht durch Nachlaessigkeit, sondern weil zwischen der Auftragserteilung (23:32) und dieser Erhebung **vier weitere Landungen** stattfanden: super `71591a24` (23:59), ce `bba4d90f` (00:06), ce `c4c04315` (00:14), super `5a98036d` (00:15). **Derselbe Gegenstand traegt an einem Abend fuenf Zahlen.** Fuer dieses Kapitel folgt daraus die Arbeitsform: keine Zeile ohne Uhrzeit.

#### IV.0.2 Die Falle, die jede Lagemeldung dieses Tages verzerrt hat

Die **lokalen** `main`-Zweige sind in allen drei Repos Karteileichen:

- super lokal `main` = `9d0f1bad` (27.07. 04:34), **425 Commits** hinter `development`
- ce lokal `main` = `b241a272` (06.08. 20:06), hinter `origin/main`
- thesis lokal `main` = `95db7793`, hinter `origin/main` = `19e15920`

Alle main-FFs des Tages liefen ueber Worktrees oder direkte Pushes; der lokale Zeiger blieb stehen. **Wer `git rev-parse main` statt `git rev-parse origin/main` misst, bekommt in allen drei Repos eine falsche Antwort.** Genau dieser Fehler hat am Abend einmal real zugeschlagen: der Test „liegt der Fingerprint-Block auf `main`?" meldete faelschlich NEIN, weil er gegen einen 50 Commits alten lokalen Zweig lief (Checkheft **N-4**). Die Checkheft-Posten **N-3** und **NS-3** sind damit **unveraendert offen**, und die super-Zahl ist nicht 406, sondern **425**.

---

### IV.1 Was heute gelandet ist

**Bilanz seit 06.08. 00:00** (`git log --since`, auf `development`, mit Merges): siehe die Tabelle im Vorwort — super 175 Commits / ce 90 / thesis 6.

Die super-Zahl ist zu rund 96 % Dokumentation, Ledger, Session-Sicherungen und die 333 Rohdaten-Dateien des Workflow-Backups. **Die ce-Zahl ist der Code.** Sie wird nach Bloecken gefuehrt, weil die Bloecke die Abhaengigkeiten tragen — nicht die Chronologie.

#### IV.1.1 ce — die neun Bloecke

**Block A · T2-A / Neuanker Format 3** (04:55–17:14, Merge `86be2420`) — der P0 des Tages.
`27adebc1` (CX-3 Compiler-Realversion CT + CX-2 Renderer-Injektivitaet + CX-1 RT-Format-Wache) · `77095354` (CX-4 Live-Injektion der Preimage-Glieder [5]/[6]) · `aa46c524` (EINE Preimage-Quelle, fail-closed cxx-Feld) · `cb9a7204` (**Fremd-Vorarbeit der Zwillings-Session uebernommen und fertiggestellt**) · `dbdd2f9b` (T2-B: Glied [5] wird PER-PERM — O2/O3 derselben Zelle wieder unterscheidbar) · `bbd72c2a` (T2-C: Tier-Realversion wird **erhoben** statt geerbt) · `e2c95179` · `a6a6875b` · `faa525d7` · `61a95bae` · `b4c343b9` (K2: Mess-Resume am VOLLEN Fingerprint) · `3a42bf90` (F4: **der Batch-Plan liegt VOR dem Lauf**) · `511671c9`/`bcc49119`/`823f6eb5`/`6c300e68` · `847c93c9` (**F4-BILANZ — der Trigger-Blocker: ein voll resumiertes Fenster ist kein Fehlschlag mehr**) · `41091cb4` · `3a88eb88`/`a9a352bb` · `71b5586a`/`034e0068`/`b6d87c08`.

**Block B · B14 / CLU-Kette + Cacheline-Unterachse** (Merge `f577f886`, 17:20).
`c1c76c87` (Landeblocker: CLU-Kette bis zum LETZTEN Verbraucher) · `a402cfbc` (CEB-Contract-codegen 8.0 → 8.1) · `6a40071f`/`0680eff1`/`16a173f2` (`kLbufBytes`, `scan_field_sum`, `cache_lines_touched` folgen `line_bytes_of<MemLayout>()` statt Literal 64) · `1fe3f6a9` · `0ae12811`/`bfa75431` · `4b38d072` (**die vier UEBERSEHENEN literalen ceb-Pins** — Anlassfall fuer Regel R-19).

**Block C · CI-Wurzel / Abdeckungs-Invariante** (Merge `b5e0e4e7`, 17:25).
`baaaea62` · `dcb2f08f` (**Wurzelschnitt**, III.6.5) · `597ecffe` (doppelter Job-Schluessel — **der Heuristik-Tripwire war 3 Wochen faktisch AUS**, III.6.4) · `557d8023` (`AXIS_ALGO_VERSION 1→2`) · `3133f226` (DIFF-HYGIENE-WACHE ersetzt die grep-Kette).

**Block D · A1 / Allokator-Achse** (Merge `47c4ef1d`, 19:14).
`0b5ed557` · `62d8c715` · `ce8fb2aa` · `8810cc7f` · `4cdb829a` · `9eb1e7d6` (reallocate-Statistik symmetrisch — **Phantom-Bytes in allen 24 Strategien**) · `f3600109` · `fdfa68ee` · `8a89f9fc` · `d56529e7` (Pin-Kette: 24× v1.0.2c + 2× v1.0.1c **namentlich** statt uniformem Literal) · `b20eeabc`.

**Block E · LB-6 Stufe 1 — die Lager-Basis-Tests** (Merge `b241a272`, 20:06).
`ed9fca8e` · `5e6048ff` (**Ruecklese-Biss**: der Stempel wird vom Dateisystem zeilenweise verbatim geprueft) · `3558466d` (echte Dateisystem-Konkurrenz, 2 bzw. 4 `std::thread`) · `678a4487` (die fehlende `comdare_attach_generated_catalog`-Kante). — Dieser Block ist die direkte Antwort auf den Owner-Satz (15:35:22Z): *„Wie die Stempel Test-Zeichenkette fuer die Pruefung des lager-Aufbaus mithilfe von Dummy-Textdokumenten wurde nicht gelesen??"*

**Block F · Codegen-Haertung und E14** (21:18–21:25).
`6ddd7fd4` (`generated_source_catalog.hpp` in ein eigenes `generated/limits`) und `b708c572` (**3/3 deterministischer Compile-Fehler beim Attach-Entzug**) · `ed67661c`/`77ed15fa` (**E14 NoneFilter**, Owner verbatim: *„E14/Nofilter volles go - die Eingabe ist einfach die ausgabe."* — golden-320 Round-Trip diff-leer, id-Liste byte-unveraendert, Default OFF).

**Block G · PMC** (21:13–22:16).
`8894d983` (**M-2: PMC-Pflicht als INVARIANTE**, 4/4-Bissbeweis, III.6.2) · `fb9aefdc` · `22e17f57` (errno-Sichtbarkeit — der Kanal, der `errno=2` sichtbar machte) · `2b5ecd29` (**`m3v2_pmc_smoke` misst ein echtes Fenster statt eines leeren Batches**).

**Block H · M-1 Identitaets-Naht** (Merge `bba4d90f`, **07.08. 00:06**).
`b9fd81ff` (D-1: die Mess-Achse bekommt Wirkung) · `62a5b6f7` (D-4: der CEB-Schluessel rendert die **WAHL**, nicht das **ANGEBOT**) · `246b2793` (D-2: der Vertrag CEB↔Tier am Pruefdock) · `8f70898a` (vier Restluecken, jede mit Rot-Nachweis) · `89bf2ee6` · `4fdedbbf`. Zusammen 24 Dateien, +3114/−149, darunter zwei neue Tests.

**Block I · PMC-L3-Ehrlichmachung** (Merge `c4c04315`, **07.08. 00:14**) — `5c102e05`, 5 Dateien, +136/−13.
Dies ist der Posten, den der Auftragskopf noch als **uncommitteten WIP-Patch** fuehrt und den Kapitel III als offen fuehrt (Abschnitt 0 / W-2). **Er ist seit 00:14 gelandet.** Die Commit-Nachricht verbatim:

> „`pmc_cache_misses_l3` zeigte auf AMD Zen5 eine falsche 0, wenn `PERF_TYPE_HW_CACHE/LL/READ/MISS` mit ENOENT scheiterte — **ununterscheidbar von einer echten Null-Messung.** PmcCounters traegt jetzt vier Pro-Zaehler-Verfuegbarkeitsflags; die CSV-Zelle rendert `SourceUnavailable`/`n/a` statt einer erfundenen 0, nur wenn die Zeile ueberhaupt real gemessen wurde. **Eine echte 0 bleibt 0.** PMC-off-Zeilen sind byte-identisch unveraendert."

Und die Selbstkorrektur, die er mittraegt: *„Zusaetzlich korrigiert: die falsche Zusage ‚PmcCounters ERHEBT branch_misses real' zurueckgenommen — keine `IPmcSource` weist das Feld je zu (offener Posten **M-3a**)."*

Damit ist Checkheft-Posten **P-3** (erste Haelfte) erledigt — **und Owner-KERN 10 („Stiller Rueckfall geht fuer uns nicht") hat seine erste gebaute Umsetzung.**

#### IV.1.2 super und thesis — die tragenden Landungen aus 175

**Struktur und CI:** `7780c6af` (super-eigene ASCII-/Breiten-Wache, III.6.1) · `3ccbc501` (Rueckschrieb bumpt **BEIDE** Thesis-Gitlinks + `ci/thesis_gitlink_parity.sh`, III.6.3) · `85b74237` → `72eab9ae` → `46824fba` → `123b2f32` (**vier** Thesis-Zeiger-Nachzuege an einem Tag; die erste CI baute nachweislich die ALTE Fassung) · `b00638f2`/`863efddc`/`33edd4cd` (drei ce-Gitlink-Bumps) · `cb4b15e9` (**XXE an der Wurzel** geschlossen) · `2c631551` (**die sechs False-Green-Pfade der xmllint-Migration selbst** — Anlassfall fuer R-14) · `1ba29b63` · Graph-Umbau 2D/3D (`4610cf5d`, `03d16985`, `5481e94a`, `31af5a92`) auf Owner-Auftrag: *„eine Heatmap ist vielleicht nicht die geeignete Form, wie machen das die anderen Paper? Orientiere dich daran und verwende 2D und 3D Graphen."*

**Sicherung und Buchfuehrung:** `2a6f35d8` (Workflow-Rohdaten dauerhaft: 269 outputs + 63 journals, **1 Datei redigiert** — der Runner-Token-Fund) · `1f2d476c` (Session-Transkript verbatim) · `9c858a73` (die NB3-Gate-Belege **aus der `.gitignore`-Falle geholt: 12 von 18 waeren stumm verschluckt worden**) · `cea05adc` (Ledger abend-4) · `38381ac8` (A-7/A-8 als ENTKRAEFTET, **Regel-Zeile 17**) · `cc431b01` (Infra-Handout I113, 188 Z.) · `dd786310` (der ERST-ANKER, 175 Z.) · `5a98036d` (**I113 P-6: die `amd_l3`-Uncore-PMU ist nicht geladen**).

**thesis — 6 Landungen, alle heute:** `8970465` (23 Anhang-A-Abbildungen DE+EN) → `bdd1e16` (7 unmarkierte Alt-Kapitel gekennzeichnet) → `df54a2c` (Anhang D Achsen-Inventar eingebunden) → `a6c7598` (privilegiertes Regime: Zugang und tatsaechlich gefuellte Zaehler getrennt) → `8e58f69` → **`19e1592` (jeder der 28 Anhang-A-Eintraege traegt seinen EIGENEN Ersatztext, DE+EN)**.

> **Zur Zahl 28 siehe Abschnitt 0 / W-1:** es sind **28 Eintraege** (`\InputIfFileExists{anhang/…}`) und **30 Vorkommen des Bezeichners** — die zwei zusaetzlichen sind Kommentarzeilen (`:71`, `:78`), die die Doktrin beschreiben. Verbindlich: **28**.

---

### IV.2 Was gebaut und nicht gelandet ist

#### IV.2.1 Die Kurzantwort: die Liste ist fast leer geworden

Die `§3.2`-Liste des Ueberblick-Dokuments („Fertig gebaut, ungelandet") fuehrt **32 ce-SHAs und 18 super-SHAs**. Gegen `origin/development` per `merge-base --is-ancestor` geprueft: **32 von 32 ce-SHAs sind gelandet, 15 von 18 super-SHAs sind gelandet.** Die Liste ist zu 94 % ueberholt. Was bleibt, sind **drei** Posten — und die haben es in sich, weil zwei von ihnen **nur an einer Stelle existieren**.

#### IV.2.2 (1) E-18-SNAP — super, `b-e18-snap`, 3 Commits ahead

`bda34e79` → `1ae02cdf` → **`5c4cf900`**, Worktree `/home/comdare/wt-b-e18snap`, sauber.

**Beleg der Nicht-Landung, nicht nur Ancestry:** `git cat-file -e origin/development:docs/sessions/backups/20260806-e18-snap/ANWENDUNG.md` → **existiert nicht**. Gegenprobe: 23 andere `20260806-*`-Backup-Verzeichnisse sind auf `development` vorhanden, dieses eine nicht. Zusaetzlich: `ci/anhang_forward_core.sh` ist auf `development` **18.503 Byte**, auf dem Zweig **83.951 Byte**. Diffstat 6 Dateien, **+2673/−37**.

**Grund:** Codex-**NICHT-LANDEN**-Verdikt mit ausdruecklich benannter Pruefgrenze („kein Shell-Exec"). Offene Punkte: den `.gitlab-ci.yml`-Patch landen · `.gitignore`-Negation ja/nein · `COMDARE_TEXLIVE_AVAILABLE=true` setzen (sonst laeuft `auto` und baut nichts) · Repo-Wachstum 1–5 MB je Lauf · `PENDING-*.txt`-Aufraeumpolitik · und der eine Fortschritt, der bereits drinsteckt: **eine falsche `AF_SNAPSHOT_ROOT` macht den Job jetzt rot statt gruen-ohne-Beleg.**

**Gesichert:** drei rescue-Refs, **beidseitig** (origin + github).

#### IV.2.3 (2) OD-11-RT `numa_cpu_pin_process_probe` — ein Paket in zwei Haelften an zwei Orten

**ce-Haelfte:** `b-numa-process-probe`, **`b4cebdc4`**, 1 Commit ahead, 18 Dateien, +2800/−33, darunter `tests/unit/test_od11_numa_process_probe.cpp` (**841 Zeilen, neu**). Harter Beleg: `git cat-file -e origin/development:tests/unit/test_od11_numa_process_probe.cpp` → **existiert nicht**. rescue-Ref beidseitig vorhanden.

**super-Haelfte:** `Code/test_data_xml/experiment_schema.xsd`, **+24 Zeilen**, `<xs:element name="core_class" minOccurs="0">` mit Begruendung (offener `xs:string` statt Enumeration; Namensfalle „scheduling"/„hetero_core_dispatch" = **CT-POLICY** gegen `core_class` = **RT-FAKTUM**, siehe I.5.5). Live nachgemessen: `git status --porcelain` liefert ` M Code/test_data_xml/experiment_schema.xsd`. **Uncommittet. Kein Commit, kein rescue-Ref, keine zweite Kopie.**

**Das ist der gefaehrlichste Einzelposten dieses Kapitels.** Wenn jemand den super-Hauptklon zuruecksetzt — und der Hauptklon steht auf einem fremden Wellen-Branch (IV.2.6) — ist die super-Haelfte weg, und die ce-Haelfte landet gegen ein Schema, das ihr Element nicht kennt.

Die Herkunft ist Owner-**KERN 8** (22:36:35Z) samt Namensratifizierung *„Alles korrekt erkannt"* (22:40:07Z).

#### IV.2.4 (3) Drei Plandokumente, die erst nach der Messung versioniert wurden

Zum Erhebungszeitpunkt (00:20 Z) im super-Hauptklon untracked, live gegen `origin/development` nachgemessen:

| Datei | Zeilen | erstellt |
|---|---:|---|
| `docs/plaene/20260806-ANWEISUNG-pmc-intel-perf-rechte.md` | **622** | 22:02 |
| `docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md` | **1043** | 22:20 |
| `docs/plaene/20260806-PLAN-messkurven-synthese-und-hybrid-binary.md` | **768** | 23:27 |

**2433 Zeilen.** Die Gegenprobe ist wichtig: die **zehn** anderen untracked Plan-/Session-Dokumente desselben Klons sind **alle** auf `development` vorhanden — sie erscheinen nur deshalb als untracked, weil der Hauptklon auf einem 20 Stunden alten Arbeitszweig steht. **Diese drei waren es zum Messzeitpunkt nicht.**

> **Nachtrag (Landung):** Der Befund war zu 00:20 Z korrekt, ist aber **10 Minuten spaeter geheilt worden**: super `1aba34f8` („docs(plaene): drei Wellen-Dokumente sichern, die auf KEINEM Zweig lagen", 00:30:30 Z) versioniert alle drei; sie stehen heute auf `origin/development` **und** `origin/main` (per `git cat-file -e` verifiziert). Genau das Muster, das dieses Werk beschreibt — eine Zahl/Aussage traegt ihren Erhebungsstand.

Das erste ist unmittelbar messkritisch: es beruft sich auf die ce-Laeufe **15104/15110** und die Jobs `pmc:intel` (365187/365257) / `pmc:amd` (365186/365256) — genau die zwei roten Laeufe, aus denen der `pmc:intel`-Befund stammt. Das dritte ist die Ausarbeitung der Break-Even-Kette. **Beide sind Primaermaterial fuer die Kapitel II und V dieses Werks und liegen in keinem git-Objekt.**

#### IV.2.5 (4) Rohmessdaten ohne jede Sicherung

`Code/measure_out_d03/` im super-Hauptklon: **66 Dateien, 3.651.143 Byte** (heute exakt nachgemessen), untracked. Enthaelt `progress.cursor`, `e4_xml/measurements.csv` und je DLL-Zelle `perm.cpp`, `perm.dll`, `result.csv`, `result.csv.stamp`, `perm.dll.cxx.log`, `perm.dll.version`, `perm.dll.rsp`, `perm.dll.algos`.

**Gegenproben, beide gefahren:** `git log --all -- Code/measure_out_d03` = **0 Commits**. `find /home/comdare/backups-workflow -iname 'measure_out_d03*'` = **0 Treffer**.

**Und die `.gitignore` verschluckt sie strukturell:** Zeile 39 `*.csv`, Negationen nur `!measurement/**/*.csv` (Z. 43) und `!Code/**/tests/fixtures/**/*.csv` (Z. 46). `Code/measure_out_d03/` faellt unter **keine** davon. Der Owner-KERN *„Messdaten nie loeschen, ABI darf brechen"* hat hier **kein Netz** — Checkheft **NS-2** ist zur Haelfte offen.

#### IV.2.6 Die Vorbedingung, die noch steht

Beide Hauptklone stehen bis heute auf fremden Wellen-Branches: super-Hauptklon HEAD `18a0bdf3` auf `b-ci-rueckschrieb-beide-zeiger`, ce-Submodul-Checkout HEAD `90bca126` auf `b-m2-pmc-invariante`. **Checkheft NS-3 / N-AD ist unveraendert offen.** Die Antwort auf die zwei Fehl-Commits war ein Verfahren (Landungen ueber `wt-landung` / `wt-super-landung`), **nicht** die Beseitigung der Vorbedingung. Sie ist umgangen, nicht behoben — und die uncommittete XSD-Haelfte aus IV.2.3 liegt genau dort. **Und sie hat in diesem Werk zwei divergierende Zahlen erzeugt** (Abschnitt 0 / W-3).

#### IV.2.7 Die rescue-Refs, vollstaendig

**super: 9 Refs**, jede auf origin **und** github. Alle ausser den drei E18-SNAP-Refs sind inzwischen gelandet.
**ce: 18 Refs**, beidseitig — **alle 18 sind gelandet.**

Damit ist R-9 (*„eine rescue-Ref ist keine Landung"*) heute in ihrer freundlichen Richtung erfuellt: was gesichert war, ist angekommen. Die drei E18-SNAP-Refs sind die Ausnahme, und sie sind es **absichtlich**.

---

### IV.3 Die Bau-Reihenfolge B-1 .. B-10

#### IV.3.1 Warum die Reihenfolge keine Geschmacksfrage ist

Es gibt genau **einen** Grund, und er ist eine Zahl. Der Bau-Plan `docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md` (1019 Z., §3.2) teilt jedes Paket in eine von drei Neubau-Klassen:

| Klasse | Was sie beruehrt | CEB | Tier-Binaries | Kosten |
|---|---|---:|---:|---|
| **CEB-ONLY** | Treiber-Compile-Graph (`comdare-messung-driver`) | 1 | **0** | ~77 s + Pipeline `[BERICHT]` |
| **TIER** | die Define-Menge, mit der `g++` `perm_<id>.cpp` uebersetzt | 1 | **524.288** | ~34,4 h `[BERICHT]` |
| **FINGERPRINT** | das Preimage von `anatomy_fingerprint_hex` bzw. das Skip-Kriterium `dll_is_current` | 1 | **524.288, aber nur die bereits GEBAUTEN** | **heute 0 h** · **nach dem ersten Batch: 34,4 h + alle Messdaten wertlos** |

Und die Zahl, die alles entscheidet — **jetzt nachgemessen**, nicht uebernommen:

```
Bestand an .fingerprint-Sidecars, 07.08. 00:50  :  0
Gegenprobe (findet das Verfahren ueberhaupt?)    :  10 Treffer auf *.stamp
```

`find . -name "*.fingerprint" -not -path "./.git/*"` = **0** im super-Wurzelbaum. Das Suchverfahren funktioniert (Gegenprobe 10 `.stamp`), also ist die Null echt und keine stille Null im Sinne von Regel-Zeile 15.

> **Das Fingerprint-Fenster schliesst mit dem ersten `.fingerprint`, den `provision_core` schreibt** — und das tut auch ein reiner `provision_only`-Bau (`build_orchestrator.hpp:378-385`). **Ein „Bau-Batch ohne Messung" schliesst das Fenster genauso wie ein Mess-Batch.** Jedes Paket der Klasse FINGERPRINT und jedes Paket der Klasse TIER muss **vor dem ersten Batch** landen, oder es kostet einen zweiten Voll-Neubau.

#### IV.3.2 Was die Reihenfolge seit ihrer Aufstellung eingeholt hat

Der Bau-Plan wurde an ce `b241a272` geschrieben und ordnete **M-1 → M-6 → M-2 → M-3 → M-5**, mit M-1 „ZUERST, alles haengt daran". Seitdem sind **drei** seiner sechs Pakete gelandet: **M-2** (`8894d983`, 21:13), **M-1** (`bba4d90f`, 00:06) und die **L3-Ehrlichmachung** (`c4c04315`, 00:14).

**Und M-1 hat die zentrale Annahme des Plans widerlegt.** Der Plan verlangte einen **Format-Bump 3→4** (§4.2.2: „**sehr hoch**, Identitaet") und stufte M-1b/c als Klasse FINGERPRINT ein — also fensterkritisch. Am Objekt gemessen: **das Paket aendert das Preimage-Format nicht. Die drei ABI-Dateien sind sha256-identisch zu `development`.** Der Grund: die Mess-Zeile steht bereits als **Glied [3] von 8** im Preimage (`anatomy_fingerprint.hpp:341`, `:431-432`).

Das ist eine der wichtigsten Entlastungen des Tages (IV.6.1) — **und sie war beinahe eine teure Fehlarbeit**, denn der erste M-1-Bauauftrag hatte den Bump ausdruecklich beauftragt. Er wurde gestoppt, weil ein gesicherter Deep-Research-Bericht aus dem Backup die Glied-[3]-Messung schon enthielt. Das ist Regel-Zeile 16 in ihrer produktiven Richtung: *gesicherte Vorarbeit, die jemand liest, spart eine Woche.*

**Die Vorsicht bleibt trotzdem geboten** (III.5.5): ein Pruefbericht widerspricht der Stopp-Begruendung — *„nicht, weil Glied [3] fehlt, sondern **weil Glied [3] NICHT AUSREICHT**"*. Der Stopp war richtig; **ob die Begruendung auf jedem ce-Stand traegt, ist nicht abschliessend belegt.**

#### IV.3.3 Die zehn Schritte

Neu abgeleitet gegen den Stand von 00:20, nicht als Abschrift des Plans. Die Spalte „Klasse" entscheidet ueber die Position; die Spalte „braucht" ueber die Kanten.

---

**B-1 · DIE KETTE T-1: Gitlink-Nachzug + `main`-FF in beiden Repos**
*Klasse: keine · braucht: nichts · blockiert: alles*

ce-`main` steht 10 Commits hinter `development`, der super-Gitlink zeigt auf `2b5ecd29`. **Die super-Pipeline triggert ce fest auf `branch: main`** (`.gitlab-ci.yml:297-315`; Ledger `:2044` nennt das *„dokumentiert-absichtlich"*).

**Solange `main` zurueckhaengt, prueft jeder super-Lauf einen ce-Stand ohne M-1 und ohne die L3-Ehrlichmachung.** Das ist keine theoretische Zeitbombe: sie ist **jetzt scharf**. Jede gruene super-Ampel der naechsten Stunden ist eine Aussage ueber Code, den niemand mehr faehrt.

Das ist **die am haeufigsten wiedergekehrte Fehlerklasse des Tages** — sie trat **fuenfmal** auf, wurde fuenfmal geheilt, und steht zum sechsten Mal offen. Sie steht deshalb an Position 1: sie ist Minuten Arbeit und entwertet jeden Beweis, den man ohne sie fuehrt.

Naechste Handlung, in dieser Reihenfolge: ce-Pipeline auf `c4c04315` verifizieren → ce-`main`-FF **auf den gepinnten SHA des Paket-Merges, nie ueber `HEAD`** (Owner-Ruege des Tages) → super-Gitlink-Bump → super-Pipeline → super-`main`-FF.

---

**B-2 · DIE BAU-MENGE KLAEREN: zaehlen statt addieren**
*Klasse: keine (Messung an vorhandenem Code) · braucht: nichts · blockiert: B-3, jede Kalibrierrechnung*

**Drei Quellen nennen drei Zahlen, und keine ist gemessen:**

| Quelle | Zahl |
|---|---:|
| `05_evaluation.tex:94-101` | 524.288 |
| `experiment_golden_kern.xml:285` | 2.097.152 |
| `FAHRPLAN:412-422` | 131.072 |

**Faktor 16.** Dazu ein zweiter Befund: `<run_options cap="131072"/>` ist **dekorativ** — `parse_experiment_profile` enthaelt null Treffer auf `run_options`/`cap`. Gepinnt wird real ueber `COMDARE_GN_TOTAL: "131072"` (`super/.gitlab-ci.yml:79`), **aber je System-Permutation** (`experiment_plan_director.hpp:989-990`).

**Warum das vor allem anderen kommt, was mit Zeit rechnet:** der Owner hat die fehlende Kalibriergroesse selbst geliefert (20:25:12Z, **KERN-Nachtrag**):

> „Hinweis: **die grosse Maschine schafft den compile von einem Batch in 11 Sekunden fuer eine Tier-Binary.** Kannst du ja ueberschlagen ob das passt. **Den build hatten wir schon einzeln gemessen.**"

4096 × 11 s = 45.056 s ≈ **12,5 h seriell** je Batch-Segment. Auf die drei Kandidatenmengen angewandt: **400 h / 1.602 h / 6.408 h seriell.** Der Faktor 16 in der Bau-Menge ist damit **die teuerste unbeantwortete Zahl der Session** — jede Zeitplanung gegen den 15.09. steht auf ihr.

Und: **ein Attribut, das kein Parser liest, ist eine stille Luege in der autoritativen Bauanleitung.** `cap` muss entweder wirken oder laut abgelehnt werden.

---

**B-3 · M-6: DIE XML TRENNT BAU UND MESSUNG**
*Klasse: CEB-ONLY (1 CEB, 0 Tier-Binaries) · braucht: B-2 · blockiert: B-8*

Owner (19:37:43Z), verbatim:

> „**nur weil sie kompiliert werden sollten, heisst es nicht dass sie auch gemessen werdne muessen, das muss die XML getrennt fuer build und Messung definieren koennen sonst regression**"

Der Ist-Stand (Bau-Plan I-8): **die Trennung existiert nicht.** `struct ThesisProfile` hat kein Feld; die Trennung lebt nur in einer Env-Variablen und einer Emitter-Asymmetrie.

**Warum an dieser Position:** (1) **vor B-8**, weil die Selektion bestimmt, **welche** Zellen ueberhaupt gemessen werden. (2) **nach B-2**, weil die Selektion auf Bau-Identitaeten zeigt. (3) **nicht nach dem ersten Batch** — der Bau-Plan §2.3: *„Der Batch kann nicht sagen, was er baut und was er misst — das ist woertlich die vom Owner benannte Regression."*

Kostenlos in der Neubau-Bilanz: **M-6 aendert kein Compile-Define.** Parser + Emission, sonst nichts. **Neue Grammatik — deshalb die hoechste Review-Last aller CEB-ONLY-Pakete.**

---

**B-4 · M-3a `branch_misses` + M-3d RAPL-Probe + der Zugriffs-Beweis auf beiden Lanes**
*Klasse: CEB-ONLY · braucht: nichts · blockiert: B-8 (fail-closed), B-9 (Zaehler-Menge)*

**M-3a — `branch_misses` verdrahten.** `PERF_COUNT_HW_BRANCH_MISSES` als vierter generischer Counter in `linux_perf_pmc_source.hpp` (Muster `:202-207`). **Kein RAW-Event, gleiche open/read/close-Mechanik wie die drei laufenden.** Der Termin ist **jetzt oder nie**: bis heute stand im Code die ausgeschriebene Zusage *„PmcCounters ERHEBT branch_misses real"* (`cache_engine_builder_iterator.hpp:499`) — sie war **falsch**. `5c102e05` hat die Zusage **zurueckgenommen**. Die CSV-Spalte steht aber seit dem 04.08. im Header. **Entweder wird sie wahr, oder sie muss aus dem Header.** Ein Drittes gibt es nicht.

**M-3d — RAPL-Probe.** Existiert `/sys/class/powercap/intel-rapl:0/energy_uj` auf der **AMD**-Lane und ist es lesbar? Ein `cat` im Job-Trace. Entscheidet, ob `ENERGY_J` real oder honest-0 gefuehrt wird.

**Der Zugriffs-Beweis.** Auf `pmc:amd` **und** `pmc:intel`: literal `pmc_available=1` plus ein `cache_misses_l1 != 0` aus dem Job-Trace. **Er ist Vorbedingung fuer O-2** (Haertegrad der PMC-Wache), denn eine fail-closed-Wache, deren Voraussetzung ungeprueft ist, toetet den ersten Batch.

**Der Anlass fuer diese Position** ist die teuerste Fehldiagnose des Abends — vollstaendig in **III.4.3**. Kurz: der Owner entschied auf Lead-Rat *„Bitte (a) fuer intel die perf-Rechte geben … Ein skip ist keine Loesung. Wir machen das richtig"*; die Nachmessung ergab `perf_event_paranoid = 1` auf **beiden** Maschinen. **Es war kein Rechteproblem.** Und die Wurzel lag im eigenen Produkt: eine hartkodierte Ursachenliste bei verworfenem `errno`. Daraus **R-11: keine Ursache ohne Messung.**

---

**B-5 · OD-11-RT `numa_cpu_pin_process_probe` — beide Haelften landen**
*Klasse: RT-Sonde, stempel-neutral · braucht: B-1 · blockiert: B-6*

Der ce-Teil ist gebaut (`b4cebdc4`). Der super-Teil (XSD `core_class`, +24 Z.) ist **uncommittet** (IV.2.3). Erste Handlung ist deshalb nicht das Landen, sondern das **Sichern der super-Haelfte** — sie hat heute keine zweite Kopie.

**Warum es vor B-6 steht:** die Unterachse ist das **RT-Faktum**, auf dem die Permutation operiert (I.5.5). Der Fehler, der sie beinahe verhindert haette, ist einer der lehrreichsten des Tages: der erste Sweep filterte mit `grep -v "/build"` und meldete `sched_setaffinity` = **0 Treffer** (III.3.3). **Eine falsche Null haette hier einen Neubau ausgeloest, den es nicht braucht.**

**Die Entlastung, die dieses Paket mitbringt** (Verdikt aus der Pruef-Welle): *„VERDIKT: **HAELT** — A-15-Stempel-Neutralitaet ist strukturell erzwungen. **Kein Flotten-Neubau.**"* Der Registry-Vertrag traegt es (I.5.2). **B-5 ist damit nicht fensterkritisch.**

---

**B-6 · DIE CORE-PERMUTATION IN DER CEB: einmal E-Core, einmal P-Core**
*Klasse: CEB-ONLY (nach Owner-KERN: „reine Wiederverwendung") · braucht: B-5 · blockiert: B-7*

Dies ist der Bau-Posten zu **KERN 5** und **KERN 6** (Kapitel VI; Mechanik in I.5). **Was diese KERNe an Bauarbeit ersparen:** die Lead-Rechnung „34,4 Stunden plus alle Messdaten" ist **gegenstandslos**. Es gibt keine CEB-Vervielfachung; die Trennung geschieht in der **Ablage** und in der **Permutation**, nicht im Bau.

**Merksatz, der die ganze Bauform traegt: *der Planer FRAGT (RT), die CEB TRAEGT (CT), die Tier-Binary LAEUFT (unveraendert).*** Daraus folgen vier Auflagen an B-6: die CEB ist **je OS anders kompiliert** · „keine Pin-Interfaces" ist ein **gueltiger Bauzustand** · der Planer **bewegt** die Unterachsen · die CEB steuert ein **Verhalten**.

**Und die Plan-Deckung ist alt** (I.4.2): Scope-Freeze 12.04. nennt „Hybrid-CPUs" in der Forschungsfrage; Termin 3 traegt die Hybrid-Regel woertlich; es existiert ein fertiger Baustein-Entwurf `HybridCorePinning`. **Der Plan hat die Fehlerklasse benannt, den Baustein entworfen — gebaut wurde er nicht.** Der Owner musste dreimal darauf hinweisen (KERN 13).

---

**B-7 · GETRENNTE ABLAGE JE PMU-DOMAENE im CSV- und Lager-Schema**
*Klasse: CEB-ONLY im Bau — aber **datenbruch-kritisch** · braucht: B-6 · blockiert: die zu behaltende Messung*

„legt die Ergebnisse **je PMC getrennt** ab" (KERN 5) ist keine Ablage-Kosmetik, sondern eine Schema-Aenderung. Und sie kollidiert mit dem Reproduzierbarkeits-Axiom, das der Owner sechs Stunden vorher gesetzt hatte (**KERN-Nachtrag F6**):

> „die gleiche binary auf der selben Maschine mit den selben Messachsen liefert **identische Ergebnisse uneingeschraenkt**, das ist die **Hauptidee des Systems und des Lagers**. Daher: **Mess-Achsen + System-Achsen + Organ-Achsen identisch → fingerprint fuer identische binary fuer identische Messdaten**"

**Auf einer Hybrid-CPU koennen zwei Kerne derselben Maschine verschiedene Zaehler liefern. „Selbe Maschine" ist dort nicht mehr fein genug.** Die Frage, **ob die PMU-Domaene Teil der Mess-Identitaet werden muss**, ist am Sessionende **unentschieden** — und sie ist der einzige offene Punkt, der das Fingerprint-Fenster beruehrt.

KERN 5 entschaerft sie teilweise (`binary_id="never"` schliesst einen Neubau strukturell aus), aber **die Ablage-Seite bleibt offen**: wenn die PMU-Domaene nur eine Spalte ist und nicht Teil des Identitaetsschluessels, dann liegen zwei physikalisch verschiedene Messungen unter demselben Schluessel im Lager. Das ist **Lager-Inkonsistenz** — und die ist nach KERN 9 ausdruecklich ein **FATAL**-Fall.

**Das ist ein Owner-Entscheid, kein Bau-Posten** — er steht in V.6.4 als **D-1**. Aber der Bau kann nicht davor gefahren werden.

**Fensterkritisch:** heute 0 h (Sidecar-Bestand 0, gemessen). Nach dem ersten scharfen Batch: **34,4 h Neubau plus alle bis dahin erhobenen Messdaten.**

---

**B-8 · M-5a: DAS PRUEFDOCK-TESTAT ALS BATCH-PREFLIGHT + O-1 `allow_failure` entfernen**
*Klasse: CEB-ONLY · braucht: B-3 (Selektion), B-4 (Zugriffsbeweis) · blockiert: den scharfen Batch*

Das Pruefdock **ist gebaut** — und im Produktionspfad **nicht befahren** (I.7.3, Bau-Plan I-7). B-8 haengt `testat_pmc` plus die sieben vorhandenen Testate als Preflight vor den Batch.

**Warum nach B-3 und B-4:** jedes Testat muesste sonst zweimal geschrieben werden — einmal gegen die alte, einmal gegen die neue Zaehler- bzw. Selektionsmenge.

**Im selben Zug O-1:** `experiment_plan_director.hpp:1373` traegt `allow_failure: true` am Mess-Batch (am Objekt ce `54106bc9`, `git grep -n allow_failure` = genau **1** Treffer, Zeile 1373; `:1332` ist der Batch-Kommentarkopf, nicht die Zeile). Der Owner-Kanon dazu ist eindeutig (#278, 06.07., PFLICHT, `LEDGER:1140`: *„in einer harten Pipeline darf es kein allow_failure geben"*; Endstand `LEDGER:692`: *„0 allow_failure im GESAMTEN Matrix-System, einzige Ausnahme by design: ce `is_original:relock`"*). Der Code begruendet die Zeile mit der Sichtbarkeits-Doktrin — **aber das ist eine Zell-Doktrin (CSV `failed` + Log), keine Job-Doktrin.** Gegenprobe mit Nenner: 20 `allow_failure`-Treffer im Ledger, **keiner autorisiert diese Zeile**.

**Ein mehrtaegiger Lauf kann heute komplett scheitern, und die Ampel bleibt gruen.** Eine Zeile, jederzeit reversibel; der verlorene Messlauf ist es nicht. — Die Pruef-Welle hat es bewusst **nicht** gebaut, und die Begruendung gehoert ins Dossier, weil sie vorbildlich ist: *„Ich habe es bewusst nicht gebaut — der Auftrag sagt ‚nicht anfassen', und das Ledger-Schweigen zu dieser Zeile ist **kein Beweis der Abwesenheit einer Owner-Entscheidung**."*

---

**B-9 · M-3b/c: L2 UND KOHAERENZ UEBER RAW-EVENTS JE MIKROARCHITEKTUR**
*Klasse: CEB-ONLY im Neubau — aber **Datenbruch ohne Neubau** · braucht: B-4 · blockiert: die zu behaltende Messung*

Gefordert durch **KERN 4** und den Owner-Nachtrag F3: *„Es ist PFLICHT, dass das gemessen wird, was gemessen werden kann … **NIE abkuerzen, immer mit deep research fixen bitte.**"*

**Der Stand nach der Landung von 00:14 ist ungewoehnlich gut dokumentiert**, weil das Paket seine eigene Grenze mitgeliefert hat. Commit `5c102e05` verbatim:

> „Deep-Research-Ergebnis (Owner-Auflage): ein AMD-Rohevent fuer L3-Misses existiert konzeptionell, aber die dafuer noetige **`amd_l3`-Uncore-PMU ist auf identischer Hardware/Kernel wie prod1 als Modul vorhanden, aber nicht geladen** — eine **Infra-, keine Code-Frage**. Ein eigener Versuch, den Zaehler ueber die Core-PMC-Rohkodierung zu erraten, **scheiterte an einer Skalierungsprobe** (weniger Treffer bei 1 GiB als bei 32 MiB Arbeitslast). Der ehrliche Token ist deshalb die richtige Wahl, **nicht eine geratene Ersatzmessung**."

Der Befund ist als **I113 P-6** an Infra abgegeben (super `5a98036d`, 00:15), mit Gegenprobe-Auflage und der ausdruecklichen Warnung, **keine** Ersatzmessung ueber eine geratene Rohkodierung zu bauen.

**Der Ist-Zustand:** die beiden Mess-Maschinen haben **unterschiedliche Spalten-Semantik** — Intel liefert 4,0–4,1 Mio L3-Werte (4/4 Traces), AMD liefert `errno=2 ENOENT`. Per `strace` belegt: `PERF_COUNT_HW_CACHE_LL` **laesst sich auf Zen 5 gar nicht oeffnen**.

**Und die Intel-Haelfte hat einen eigenen Vorbehalt:** prod2 traegt einen **i9-12900K** (Alder Lake), nicht den im Ledger `:785` gefuehrten **i9-14900KS** (Raptor Lake) — RMA-Tausch vom 13.07., der Ledger-Eintrag wurde nie nachgezogen. **Fuer die Thesis ist das dokumentationspflichtig:** `pmc:intel` misst Alder-Lake-Mikroarchitektur, nicht Raptor Lake.

---

**B-10 · DER VIERTE OBSERVER-LAYER (Gattung/Genus) — deklarierte zweite Bau-Kampagne**
*Klasse: **TIER**, 524.288 Neubauten, ~34,4 h · braucht: den ersten Mess-Korpus · blockiert: nichts, was vorher faellig ist*

Owner (11:27:10Z), verbatim:

> „Alle Beschreibungen waren richtig, bis auf den Fakt, dass du in den Layern **Gattung und Genus** nicht korrekt einsortiert hast, sie fehlen aber sind wichtig, dabei fehlt mir besonders **welche Genus es unter jeder Gattungen gibt**, welchen **Interface Kern** sie nach aussen im gemeinsamen Gattungs-Kern teilen, und wie jeweils ihre **Mikro-, Makro- und Wallclocktime-Messung** eingebunden wird. **Das ist ein vierter Layer der Observer Stufe im Vertrag zwischen CEB und Tier-Binary!**"

Und die Praezisierung (09:34:13Z), 14 Stunden frueher gesetzt und deshalb die eigentliche Spezifikation: *„aus einer Interface Funktion einer Gattung→Genus [sind] **immer alle in der interface Funktion vollzogenen Messparameter abrufbar**, die waehrend des Aufrufs durchlaufen wurden, **zusammen mit einem zeitlich geloggten Profil der Achsen-Zugriffsmuster**"*.

**Er lebt in der Tier-Binary** (`abi_adapter` / `observable_tier`). Damit ist er Klasse TIER: **524.288 Neubauten.**

**Warum er ans Ende gehoert, und zwar bewusst:** ins Buendel gezogen verschiebt er den Voll-Bau um mindestens zwei Wochen und die Messung um drei. Als deklarierte **zweite** Bau-Kampagne kostet er einen zweiten Voll-Bau (34,4 h) und erzeugt **zwei Mess-Korpora, die nicht fingerprint-identisch sind** — ein Preis, aber ein sichtbarer und benannter. **Owner-Entscheid, V.6.4.**

#### IV.3.4 Die Kanten in einem Bild

```
   B-1  T-1-Kette (Gitlink + main-FF beide Repos)     [blockiert ALLES]
    |
    +-- B-2  Bau-Menge zaehlen (Faktor 16) + cap wirksam-oder-abgelehnt
    |         |
    |         +-- B-3  M-6 XML trennt Bau/Messung ------------+
    |                                                          |
    +-- B-4  M-3a branch_misses + M-3d RAPL + Zugriffsbeweis --+
    |         |                                                |
    |         +-- (entscheidet O-2 fail-closed)                |
    |                                                          v
    +-- B-5  numa_cpu_pin_process_probe (BEIDE Haelften)   B-8  Pruefdock-Preflight
              |                                                 + O-1 allow_failure raus
              +-- B-6  Core-Permutation E/P in der CEB          |
                        |                                       |
                        +-- B-7  Ablage je PMU-Domaene  <-- D-1: PMU-Domaene in die Identitaet?
                                  |                             |
                                  v                             v
   ================== HIER SCHLIESST DAS FINGERPRINT-FENSTER ====================
                                  |
                        ERSTER SCHARFER 4096er-BATCH
                                  |
                        B-9  RAW-Events L2/Kohaerenz  (vor der zu BEHALTENDEN Messung)
                                  |
                        VOLL-BAU -> VOLL-MESSUNG
                                  |
                        B-10  Vierter Observer-Layer   [zweite Bau-Kampagne]
```

---

### IV.4 Was VOR der Messung stehen muss — und warum

#### IV.4.1 Die zwei Fehlerarten sind nicht gleich teuer

Es gibt zwei Wege, eine Aenderung zu spaet zu machen, und sie unterscheiden sich fundamental.

**Der erste: die Aenderung erzwingt einen Neubau.** Kosten: 34,4 h Wanduhr plus die Entwertung aller bis dahin erhobenen Messwerte. **Das ist teuer — aber es ist laut.** `dll_is_current` vergleicht das ganze Preimage; jede gebaute Binary faellt sofort aus der Gueltigkeit, das Lager sagt es, der Batch baut neu. Man merkt es in derselben Minute.

**Der zweite: die Aenderung erzwingt keinen Neubau.** Man aendert die **Menge der real erhobenen Zaehler** — B-9, oder das L3-Ehrlichkeitspaket, oder `branch_misses`. Der Fingerprint traegt nach der Empfehlung des Bau-Plans den **Define-Satz** (bau-wirksam), **nicht** die **Zaehler-Menge** (laufzeit-wirksam und CEB-only). Das haelt die Pakete nachziehbar. Es hat aber eine Folge, die der Bau-Plan §3.5 in vier Worten benennt:

> **„Datenbruch ohne Neubau."**

**Die vor der Aenderung erhobenen Zeilen tragen andere Spalten-Semantik als die danach — unter demselben Fingerprint.** Das Lager kann sie nicht unterscheiden, weil ihre Identitaet identisch ist. Es gibt keine Wache, die anschlaegt; keine rote Ampel; keinen Neubau. Es gibt nur zwei Zahlenkolonnen, die aussehen, als gehoerten sie zusammen, und die es nicht tun.

**Und genau das ist die These dieser Session in ihrer Datenform:** *eine Messung war korrekt und beantwortete die falsche Frage.* Beide Zeilen sind korrekt erhoben. Beide sind ehrlich. Sie beantworten verschiedene Fragen und liegen im selben Feld.

**Deshalb ist der Datenbruch schlimmer als der Neubau: der Neubau kostet Zeit, der Datenbruch kostet Wahrheit — und er bleibt unsichtbar, bis jemand die Rohdaten gegen das Datum ihrer Erhebung haelt.** In einer Diplomarbeit, deren Kernaussage aus genau diesen Kurven besteht, ist das kein Betriebsunfall, sondern ein Befundfehler.

#### IV.4.2 Der konkrete Fall, der heute schon eingetreten waere

Bis 00:14 rendete `pmc_cache_misses_l3` auf AMD eine **`0`**, wo der Zaehler gar nicht geoeffnet werden konnte (`errno=2`). Seit 00:14 rendert dieselbe Zelle `SourceUnavailable`/`n/a`. **Eine echte 0 bleibt 0** — das ist die entscheidende Eigenschaft des Pakets.

Haette man vor dieser Landung gemessen, staenden im Korpus AMD-Zeilen mit `pmc_cache_misses_l3 = 0` neben Intel-Zeilen mit `4048837`. **Der Anhang der Arbeit haette daraus abgeleitet, dass die AMD-Architektur keine L3-Misses produziert.** Das ist keine Uebertreibung: der Pruefbericht hat es so formuliert — *„und im Anhang stuende L3 als gemessen"*.

**Es ist heute kostenlos, weil noch nichts Behaltenes gemessen wurde** (0 `.fingerprint`-Sidecars, `measure_out_d03` ist ein Kratz-Korpus). Nach dem ersten scharfen Batch waere es die teuerste Zeile des Projekts.

#### IV.4.3 Die Ehrlichkeits-Auflage, formal

Die Schwere-Leiter steht in **I.6**, ihre Entstehung in **III.9**. Fuer die Messung folgt daraus genau eine Auflage und genau eine Abgrenzung:

> **Was nach B-9 nicht real erhoben wird, muss als solches im Datenmodell stehen — nicht als 0.**

- **Pinning fehlt** = ein ehrlicher Messwert, nur der Ort ist unbestimmt → **`warn`** mit dem woertlich vorgegebenen Text.
- **`cache_misses_l3` ENOENT** = gar kein Messwert → **`n/a`**, denn eine Zahl auszugeben waere Erfindung.

Der offene Rest ist heute genau einer: `branch_misses`. Die Zusage im Quelltext ist seit 00:14 zurueckgenommen; **die Spalte im CSV-Header ist es nicht.** Entweder wird sie wahr (B-4/M-3a) oder sie wird zurueckgenommen. Ein Drittes waere wieder ein stiller Rueckfall.

**Bemerkenswert:** das Muster existierte im Projekt bereits seit Wochen ausformuliert — Ledger `:2492` (AVX512-WARNUNG mit `HardwareErweiterungFehlt`, es wird weitergemessen). Der Owner-KERN vom Abend war eine **Wiederentdeckung des eigenen Kanons** (III.9.1).

---

### IV.5 Die offenen Posten, nach Dringlichkeit

Termin-Klassen wie im Checkheft: **T1** = vor dem ersten 4096er-Batch · **T2** = vor der Voll-Messung · **T3** = vor dem 15.09. · **T4** = danach.

#### IV.5.1 SOFORT — vor jeder weiteren Handlung

| # | Posten | Beleg | Stand 00:50 |
|---|---|---|---|
| **S-1** | ce-`main`-FF (10 zurueck) + super-Gitlink-Bump + super-`main`-FF | `.gitlab-ci.yml:297-315` `branch: main` | **GESCHLOSSEN ~00:43 Z** — ce `main`-FF auf `54106bc9` (Merge-Zeit 00:34:58 Z), super-Gitlink-Bump + `main`-FF auf `2871fabf` (00:43:39 Z); Kette T-1 vollzogen. War bei Aufstellung dieser „Stand 00:50"-Tabelle bereits erledigt |
| **S-2** | super-Haelfte von OD-11-RT sichern (XSD +24 Z., uncommittet, keine zweite Kopie) | `git status --porcelain` live | **OFFEN — Verlustrisiko** |
| **S-3** | 3 Plandokumente (2433 Z.) versionieren | `git cat-file -e` → jetzt alle drei present | **GELANDET** — super `1aba34f8` („docs(plaene): drei Wellen-Dokumente sichern, die auf KEINEM Zweig lagen", 00:30:30 Z) sichert alle drei; heute auf `origin/development` und `origin/main` (per `git cat-file -e` verifiziert). Bei Aufstellung dieser Tabelle bereits erledigt |
| **S-4** | `Code/measure_out_d03/` (66 Dateien, 3.651.143 B) sichern + `.gitignore`-Negation fuer Messpfade | `.gitignore:39/43/46`; `git log --all` = 0 | **OFFEN** |
| **S-5** | Beide Hauptklone von den fremden Wellen-Branches nehmen | HEAD `18a0bdf3` / `90bca126` | **OFFEN (N-AD)** — hat in diesem Werk eine Zahlendifferenz erzeugt (Abschnitt 0 / W-3) |

#### IV.5.2 T1 — vor dem ersten Batch

**B-2** (Bau-Menge, Faktor 16) · **B-3** (M-6 XML-Trennung) · **B-4** (branch_misses + RAPL + Zugriffsbeweis) · **B-5** (OD-11-RT) · **B-6** (Core-Permutation) · **B-7** (Ablage je PMU-Domaene) · **B-8** (Pruefdock-Preflight + `allow_failure`).

Dazu die Posten, die nicht Bau sind:
- **`m3v2_pmc_smoke`** — geheilt in `2b5ecd29`, **aber der Zweitbefund steht**: *„Auf AMD besteht derselbe Test **durch Zufall** … 7/7 AMD nonzero, 6/6 Intel exakt null … **Die intel-Lane hat diesen Test NIE bestanden — sie hat ihn stillgeschaltet.**"* Ob die Heilung das Kriterium (`>=1 counter populated`) mitkorrigiert hat, ist **nachzupruefen**, nicht anzunehmen.
- **Der Verwurfs-Beschluss fuer einen Kalibrier-Batch muss VOR dem Batch schriftlich erklaert werden.** Klarstellung zum Memory *„Messdaten nie loeschen"*: verworfen werden **Binaries und `.fingerprint`-Sidecars**, **nicht** die erhobenen Messwerte; die CSV-Zeilen werden additiv gesichert und als „Vor-Buendel" gekennzeichnet.

#### IV.5.3 Owner-Entscheide

Die vollstaendige, kollisionsfrei nummerierte Sammlung steht in **Kapitel V.6**. Fuer die Bau-Reihenfolge sind es sieben, und einer davon ist fensterkritisch:

| Kennung (V.6) | Entscheid | Dringlichkeit |
|---|---|---|
| **D-1** | **Gehoert die PMU-Domaene in die Mess-Identitaet?** KERN 4 gegen das Reproduzierbarkeits-Axiom | 🔴 **T1, fensterkritisch** — heute 0 h, nach dem Batch 34,4 h + alle Messdaten |
| **D-2** | Welche Bau-Menge gilt? Faktor 16 | 🔴 vor dem ersten Batch |
| **D-3** | Welche Mess-Teilmenge? 71,7 d gegen ~40 d verfuegbar | 🔴 vor dem ersten Batch |
| **D-4** | `allow_failure: true` am Mess-Batch entfernen? | T1 |
| **D-5** | PMC-Wache fail-closed? | T1, **nach B-4** |
| **D-6** | Zaehler-Menge: was ist „was gemessen werden kann"? | T1/T2 |
| **D-7** | Faktorisierung der Core-Achse — Betreuer-Matrix gegen Achsen-Dossier | 🔴 vor dem Bau der Unter-Achse |

#### IV.5.4 T2/T3 — nach dem ersten Batch

**B-9** (RAW-Events, blockiert auf I113 P-6) · **B-10** (vierter Observer-Layer) · **E-18-SNAP** (Codex-Pass + `.gitlab-ci.yml`-Patch + `COMDARE_TEXLIVE_AVAILABLE=true`) · **Anhang-A-Abbildungen** · **chktex-Heilung** (`chktex -q -n36 -n17` → **EXIT 123, 31 Warnungen ueber 8 Dateien**; **Biss unbewiesen**, siehe V.6.6) · **Overleaf-Naht** · **Aufraeumpass**.

#### IV.5.5 Die Thesis-Posten, sauber getrennt

**Erledigt und am Objekt belegt:**
- **C-1(a)** — 17 stumme Anhang-A-Eintraege: am Stand `19e1592` **28 Eintraege**, **0 stumme `}{}{}`**, alle mit Ersatztext, DE und EN identisch (heute nachgemessen; zur 28-gegen-30-Frage siehe Abschnitt 0 / W-1).
- **C-1(c)** — `axis_inventory.tex` eingebunden (`df54a2c`).
- **C-2** — Alt-Kapitel markiert (`bdd1e16`); das Checkheft hat sich selbst als **K-1** korrigiert.
- **Z-4** — Gate 8 (`8970465d`) ist Vorfahr von `19e1592` = thesis `origin/main`.

**Weiterhin offen:**
- **Z-8 / C-1-Kern** — **28 Eintraege, 0 existierende Zieldateien.** Im Baum liegen 18 Dateien unter `anhang/de/tabellen/` — aber die **2D**-Varianten; eingebunden sind die **3D**-Varianten (`lc_surface3d_*`). **Die Ehrlichmachung ist erfolgt, die Abbildungen fehlen weiter.**
- **C-1(b)** — kein Zaehl-Gate fuer Anhang A im `thesis:pdf`-Job.

**Die Verzeichnis-Falle, die jeder Thesis-Pruefer kennen muss:** `kapitel/en/01_einleitung.tex` **ist** der englische Text. **Die Verzeichnisse tragen die Sprache, die Dateinamen sind durchgaengig deutsch.** Und: **nur sechs Kapitel sind eingebunden**, belegt ueber die `.fls`-Dateien eines echten Laufs. Siehe **V.1.2**.

---

### IV.6 Die Entlastungen — was NICHT gebaut werden muss

Dieser Abschnitt ist kein Anhang. Er ist die andere Haelfte der Bilanz, und er hat an einem Tag mehr Arbeit gespart als die Bau-Bloecke gekostet haben. **Jede Position ist am Objekt entkraeftet, mit Beleg. Keine darf als offener Posten zurueckkehren.**

**IV.6.1 · Der Format-Bump 3→4 — nicht noetig.** Der teuerste Einzelposten, der sich in Luft aufgeloest hat. **Gemessen, nicht angenommen: die drei ABI-Dateien sind sha256-identisch zu `development`.** Die Mess-Zeile steht bereits als **Glied [3] von 8** im Preimage. **Die M-1-Landung war damit nicht fensterkritisch.** (Vorbehalt aus IV.3.2 bleibt notiert.)

**IV.6.2 · Die Hybrid-Trennung ist eine Permutation, kein zweiter Bau.** Strukturell gedeckt durch `binary_id="never"` — Herleitung in **I.5.2**, unabhaengiges Verdikt in **III.4.1**. **Gespart: 34,4 h plus alle Messdaten**, gegen die erste Lead-Rechnung.

**IV.6.3 · Die perf-Rechte mussten nicht gelockert werden.** `perf_event_paranoid = 1` auf prod1 **und** prod2, wortgleich, gleicher Kernel, gleiches Ubuntu. Vollstaendige Chronologie in **III.4.3**. Der Owner-Satz *„Wir machen das richtig"* wurde damit **staerker erfuellt als seine eigene Handlungsanweisung (a)**.

**IV.6.4 · PMC ist heute Klasse CEB-ONLY, nicht Klasse ALPHA.** Der Vertiefungs-Plan fuehrte PMC unter *„KLASSE ALPHA — aendert das Fingerprint-Preimage, entwertet 100 % der Flotte"*. **Am Objekt trifft das nicht zu:** `add_compile_definitions(COMDARE_ENABLE_PMC)` (`CMakeLists.txt:77`) wirkt auf den **CMake**-Teilbaum; die Tier-`.so` entsteht ueber einen eigenen `g++`-Subprozess (`grep -c COMDARE_ENABLE_PMC` im `build_orchestrator` = **0**); `perm_mess_defines()` fuehrt das Flag nicht. **1 CEB, 0 Tier-Binaries, ~77 s.**
Mit der Auflage, die die Entlastung schaerft: **PMC ist heute billig und wird durch die Identitaets-Entscheidungen teuer.**

**IV.6.5 · Die §64-Vollmengen-Combo ist bereits gebaut.** **EINE** Vollmengen-Combo `[all]` (`all_axes_golden.profile.xml:221-226`). Es gibt **eine** CEB je Plattform × Mess-Aufgabe, nicht eine je Konfiguration. Kein Bau-Posten.

**IV.6.6 · `COMDARE_BESTANDSLOG` — die Anklage war ein Messfehler.** Behauptung: *„wird nirgends gesetzt, die ganze Ebene ist totes Holz."* **Widerlegt:** die Variable wird ueber den **Emissions-Weg** durchgereicht (`experiment_plan_director.hpp:952-955`), belegt durch einen bestehenden Test (`test_experiment_plan_director.cpp:845-860`, erwartet sie literal im emittierten YAML). **Das eingecheckte `.gitlab-ci.yml` ist nicht der Ort, an dem die Mess-Jobs entstehen — sie werden generiert.** → **Regel R-4.**

**IV.6.7 · `COMDARE_VARIANT_GATE` — Einschalten waere eine Regression.** Nicht „nie aktiviert = Loch", sondern **funktional obsolet per F7-(b)**, abgeloest durch **Glied [6] = bvset** im Format-3-Preimage. §61-Vergleichbarkeit haengt am Tupel (Fingerprint, Zelle), nicht an der Env-Var.

**IV.6.8 · 234-V-b Shaped-Emission — „fertig gebaut, nie angeschlossen" ist der spezifizierte Zustand.** Owner-Entscheid G-234V-b (`LEDGER:1309`): *„**Ja** (default-OFF → golden-neutral)"*. Die Achsen sind `AxisObserverKind::DefinitionOnly` = **nicht im Mess-Kreuz**; golden traegt kein Shape-Segment (**0 von 326** Zeilen); beide Tests laufen in der CI und werden **wirklich ausgefuehrt**. **Es fehlen keine Messreihen.**

**IV.6.9 · `target_isa`-Unterachsen — im Kern entlastet.** Behauptung *„ohne jeden Konsumenten"* ist **falsch**: `tools/system_axis_registry_gen/main.cpp:375-376` konsumiert generator-seitig; `numa_page_probe.hpp` (OD-10-RT) laufzeit-seitig; plus zwei Tests. Die Doktrin *„System gibt frei, Organ setzt durch"* ist woertlich umgesetzt. **Restluecke, klein und benannt:** fehlende Validierung, Exposition **0 von 68** Profil-XMLs. **Und die Namensfalle:** es gibt eine **zweite**, voll verdrahtete Unterachse `alloc_hw.numa_node` (152 gegen 23 Treffer), die an der **Organ**-Achse haengt.

**IV.6.10 · `lint:static` / cppcheck — false positive, isoliert statt vermutet.** Drei Minimalproben: Lambda **mit** for-Schleife im `static_assert` → `syntaxError`; Lambda **ohne** Schleife → still; Schleife in benannter constexpr-Funktion → still. **Weder Schleife noch Lambda fuer sich, sondern genau ihre Kombination.** `g++-15 -std=c++23 -fsyntax-only` RC=0. → eng begrenzte Inline-Unterdrueckung mit gemessener Begruendung, **Wache unveraendert**.

**IV.6.11 · Der Wurzelpfad in `target_include_directories` ist kein toter Ballast.** Gemessen: **146 woertliche Treffer, 143 distinkte Ziele; 17 generierte Achsen-Flag-Header und 187 von 429 TUs haengen daran.** *„Ein pauschaler Streich-Refactor waere eine **Regression**."* **Ein abgewendeter Bauauftrag.**

**IV.6.12 · A-7 / A-8 waren bereits erledigt, als sie beauftragt wurden.** Vollstaendig in **III.3.1**. Gelandet als Entkraeftung in super `38381ac8`, mit **Regel-Zeile 17** als Konsequenz. **Und dieselbe Klasse traf das Checkheft selbst** (G-1, G-2) — und dieses Werk (Abschnitt 0 / W-2).

**IV.6.13 · K-04 und die zwei Zusatz-Wachen — die Entlastung war die Anklage.** Praemisse *„die Zusatz-Wachen sind irrelevant, weil K-01 tot ist"* — **widerlegt**, weil K-01 selbst *„einen Repo-Grep als Laufzeit-Aussage genommen"* hatte. Beide Wachen sind damit genau die vom Owner benannte **Ausnahme**: fail-closed-Korrektheitswachen. **Sieben Entlastungen aus diesem einen Scope.**

**IV.6.14 · Drei Delta-Befunde und ein Zaehlartefakt.** **V-03** nur un-included Dateien (die kompilierten Kapitel sagen korrekt 18/T0–T17) · **V-05** in Quarantaene seit 07.07. · **V-08** misst real (L1/L3/branch_misses — mit dem heutigen Vorbehalt zu `branch_misses`). Dazu die Wachen-Koordinaten-Beobachtung: **kein Defekt**, die abweichenden Angaben stammten von einem Zweig, der sich unter der Messung bewegte. **Posten geschlossen, nicht vertagt.**

**IV.6.15 · Die Praemissen-Zurueckweisungen als Klasse.** Elf Auftraege wurden **an der Praemisse** zurueckgewiesen (III.7.2). Der Satz, der die Oekonomie beschreibt: *„Netto aus diesem Scope vor der Abgabe: **kein Bau-Paket.**"* **Ein Pruef-Scope, der zuerst die Planung las, entlastete zwei von drei Anklagepunkten.** Das ist der staerkste Beleg fuer den Owner-Auftrag (18:36:46Z): *„starte einen Explore dazu, ob du nicht selbst die Antworten im Plan findest. **Stelle dann tatsaechlich nur Fragen, die du nicht gefunden hast**"*.

---

### IV.7 Was in diesem Kapitel nicht belegt werden kann

Ausdruecklich ausgewiesen, weil eine unbelegte Zahl in einem Bilanzkapitel schlimmer ist als eine fehlende.

1. **Die ~34,4 h Voll-Bau** `[BERICHT]` — aus `docs/sessions/20260723-SESSION-mittag-neustart-zug-vollbau4.md:41-45` (19,4 min amd / 32,25 min intel je 4096er-Scheibe, 128 Scheiben, 2 Lanes). **Nicht nachgemessen.** Die *Richtung* (Bau unkritisch, Messung Engpass) folgt aus der Rechnung; die *Groesse* nicht.
2. **Die ~77 s CEB-Neubau** `[BERICHT]` — aus P-PMC-1 §5.1. Nicht wiederholt.
3. **Die 109,4 ms je Einzelmessung** und die daraus folgenden 71,7 d / 3,1 d — uebernommen aus dem Vertiefungs-Plan R-1. Die XML-Faecher-Rechnung (216 = 6 × 4 × 3 × 1 × 3) ist nachgeprueft; **der Zeit-Mittelwert nicht.**
4. **Die 11 s Compile je Tier-Binary** stammen vom Owner selbst. Die Hochrechnungen in B-2 sind abgeleitet, die Eingangsgroesse ist seine — **nicht nachgemessen.**
5. **Ob `perm_compile_flags()` ausser `perm_mess_defines()` weitere mess-wirksame Defines fuehrt** — die vier Gruppen sind gelesen, **aber nicht bis in ihre Aufrufer verfolgt.**
6. **Ob die `m3v2_pmc_smoke`-Heilung (`2b5ecd29`) auch das Erfolgskriterium `>=1 counter populated` korrigiert hat** — nicht am Objekt geprueft. Der Zweitbefund ist deshalb **nicht** als geheilt zu fuehren.
7. **Der Ebene-B-/minio-Bestand** — Cluster read-only, von dieser Rolle nicht enumerierbar.
8. **Ob `/sys/class/powercap/intel-rapl:0` auf der AMD-Lane existiert und lesbar ist** — **UNBELEGT.** Genau das schliesst B-4/M-3d.
9. **„Last-Level == L3" auf prod1/prod2** — eine Hardware-Aussage, hier nicht am Objekt erhoben. Pruefbar mit einem `lscpu`-Einzeiler im pmc-Job.
10. **Die Aufwandsschaetzungen in B-1..B-10** sind **Schaetzungen, keine Messungen.** Sie stuetzen sich auf die Dateimengen (gemessen) und die bindende Kadenz (zitiert), nicht auf vergleichbare vergangene Wellen mit Stoppuhr.

---

### IV.8 Die eine Zeile, auf die dieses Kapitel hinauslaeuft

> **Es ist heute alles noch billig. Der Sidecar-Bestand ist 0, gemessen und mit Gegenprobe. Jede Entscheidung ueber Identitaet, Ablage und Zaehler-Menge kostet in dieser Stunde nichts und nach dem ersten scharfen Batch 34,4 Stunden plus die Wahrheit aller bis dahin erhobenen Zeilen. Die Reihenfolge B-1 bis B-10 ist keine Ordnung nach Wichtigkeit — sie ist eine Ordnung nach dem Zeitpunkt, ab dem ein Fehler unsichtbar wird.**

---

## KAPITEL V — DIE ABGABE UND DIE SECHS FREITAGE

> **Erhebungsstand:** 2026-08-07, 00:20–00:45 Z. Gemessen gegen ce `origin/development` = **`c4c04315`**, ce `origin/main` = `2b5ecd29`, super `origin/development` = **`5a98036d`**, super `origin/main` = `71591a24`, thesis `origin/main` = `origin/development` = **`19e15920`**, beide super-Gitlinks auf die Thesis in Paritaet auf `19e1592`.
> **Was hier neu ist:** dass die drei Plandokumente dieses Tages **dieselben sechs Freitage dreimal verschieden verplanen**, dass sie sich an einer Stelle **direkt widersprechen**, und dass die 31 Ledger-Zeilen, die sie erzeugt haben, **bis heute in keinem Register stehen**.

### V.1 Die Umkehrung — die Thesis ist die Anforderung, nicht das Protokoll

Um 22:27:36Z stellte der Owner eine Frage, die die Richtung des ganzen Projekts umdrehte (`live 7319` / `bak 3353`, **KERN 14**):

> „Mal eine andere Frage: **Die Diplomarbeit ist ja die Anforderung an den Code, hast du da mal rein gelesen? Dort ist ja alles definiert, was im Ledger als TODO deklariert sein muss.** Wir brauchen bitte ein diff mit Opus 5 max effort ‚very thourough'"

Drei Saetze, drei Festlegungen. Die Thesis ist **Spezifikation**, nicht Bau-Artefakt. Was dort definiert ist, **muss im Ledger als TODO stehen** — das Ledger ist gegenueber dem Manuskript rechenschaftspflichtig, nicht umgekehrt. Und die Pruefform: ein Diff, mit maximalem Aufwand.

Die Antwort auf die eingebettete Frage war **nein**. Der Lead hatte die Thesis den ganzen Tag als Bau-Ausgabe behandelt: als etwas, das kompiliert werden muss, dessen Gitlink nachzuziehen ist, dessen Anhang zu fuellen ist. Nicht als den Text, der sagt, **was gebaut werden muss**.

#### V.1.1 Warum ein Satz im Praesens Indikativ eine Zusage ist

Das erzeugte Dokument formuliert den Grundsatz in einem Satz (`20260806-DIFF-thesis-soll-gegen-ledger-und-code.md:18`):

> „Was in der Arbeit steht, ist keine Beschreibung des Gebauten, sondern eine **Zusage an Leser und Betreuer**. Ein Satz im Praesens Indikativ (»der Apparat misst …«, »ist implementiert«) ist eine Tatsachenbehauptung. Haelt der Code sie nicht, ist das keine Ungenauigkeit — es ist eine **Falschaussage in der Abgabe**."

Und daraus die Handlungsregel, die dieses ganze Kapitel traegt (`:26`):

> „Fuer jede Luecke gilt: **zwei Wege sind zulaessig — bauen ODER die Aussage in der Arbeit korrigieren. Aber einer muss gegangen werden.** Nichts tun heisst: die Arbeit behauptet etwas Unwahres."

Das ist derselbe Satz, den der Owner elf Stunden vorher ueber den Code gesagt hatte (13:11:01Z: *„Ein Ausschluss loest die Wurzel des Problems NICHT, das ist verboten"*) und den er neun Stunden spaeter ueber die Fehlerausgabe wiederholte (KERN 10). **Eine unkorrigierte Falschaussage im Manuskript ist der stille Rueckfall in Textform.** Sie ist die dritte Auspraegung derselben Doktrin, und sie ist die teuerste, weil sie erst in der Verteidigung sichtbar wird.

#### V.1.2 Die Struktur-Vorbedingung: nur sechs Kapitel sind ueberhaupt eine Zusage

`diplomarbeit.tex:280-285` bindet genau sechs Kapitel ein, sprachaufgeloest ueber `\thesislang`: `01_einleitung`, `02_suchbaeume_grundlagen`, `03_messsystem_prtart`, `04_implementierung`, `05_evaluation`, `06_fazit`; dazu die Anhaenge A–F und ueber `zihpub.cls:267/883` die **gesetzte Aufgabenstellung**. Das Manuskript sagt es selbst (`:278-279`): *„Habich-Restruktur 2026-06-29: 8->6 Kapitel (SKELETT). Die alten 01_..08_-Dateien bleiben als Inhalts-Quelle auf der Platte (un-included)"*.

Zwei methodische Punkte, die **schon Falschbefunde erzeugt haben**:

**(1) Der Einbindungsstatus wurde nicht aus dem Quelltext geschlossen, sondern aus dem Bau-Trace gemessen.** Die Gegenprobe lief ueber die `.fls`-Dateien beider Sprachen — die Liste dessen, was LaTeX bei einem echten Lauf tatsaechlich gelesen hat. Nur die sechs oben erscheinen als `INPUT`. Das ist der Unterschied zwischen „ich habe das `\include` gesehen" und „das Dokument hat die Datei geoeffnet".

**(2) Die Verzeichnis-Falle.** `kapitel/en/01_einleitung.tex` **ist** der englische Text. Die Sprache waehlt das *Verzeichnis*, die Dateinamen sind durchgaengig deutsch. Wer nach `kapitel/en/01_introduction.tex` greift, landet im Alt-Material — und das Alt-Material traegt noch die ueberholte Neunzehner-Achsenzaehlung. Das Dokument haelt fest (`:52`): *„Ein frueherer Falschbefund entstand genau daran."*

Damit ist die Grundlage gelegt: **acht Alt-Kapitel je Sprache sind keine Zusage.** Sie duerfen falsch sein. Sie tragen seit `bdd1e16` alle einen Selbst-Marker. Wer sie reaktiviert, holt sich die Falschbefunde zurueck — `05_implementation.tex:5` traegt zum Beispiel dasselbe `\label{ch:impl}` wie `04_implementierung.tex:1`.

#### V.1.3 Der Befund, der die Owner-Auflage bis heute unerfuellt laesst

Der Owner-Satz war eindeutig: *„Dort ist ja alles definiert, was im Ledger als TODO deklariert sein muss."* Das Diff-Dokument hat daraufhin **23 uebernahmefertige Ledger-Zeilen** formuliert (`§63-T-01` … `§63-T-23`), im Format des bestehenden Ledgers, mit Uebernahme-Hinweis und der Gegenprobe *„`grep -c "§63-T-" LEDGER` → 0"*.

**Gemessen, 07.08. 00:31 Z:**

| Ziel | Nenner | Treffer `63-T-` | Treffer `V-09a` | Gegenprobe `§62` |
|---|---:|---:|---:|---:|
| `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` | **7248 Zeilen** | **0** | **0** | **25** |
| `docs/sessions/20260806-REGISTER-todo-konsolidierung-14-tage.md` | **474 Zeilen** | **0** | **0** | — |

Die Gegenprobe belegt, dass die Suche funktioniert. **Die 23 thesis-abgeleiteten Posten und die acht Auswertungs-Posten (`V-09a-1..8`) stehen in keinem Register.** Sie leben ausschliesslich in zwei Plandokumenten, von denen eines nicht einmal versioniert ist (IV.2.4).

Das ist genau die Klasse, vor der das Diff-Dokument in seinem eigenen §0.2 warnt: *„es gibt Zusagen, die im PDF stehen, die niemand baut, und die niemand mehr auf dem Zettel hat — sie fallen erst bei der Verteidigung auf."* **Das ist Regel-Zeile 16 in ihrer teuersten Form: gesicherte Vorarbeit, die niemand einbucht, ist verlorene Vorarbeit.**

> **Erste Handlung dieses Kapitels, ohne Owner-Entscheid ausfuehrbar:** die 23 `§63-T-*`-Zeilen und die acht `V-09a-*`-Zeilen als neuen Ledger-Abschnitt uebernehmen. Kostet keine Bau-Zeit; ohne sie ist jede Wochen-Planung unten eine Planung ueber unsichtbare Posten.

---

### V.2 Die Quellen-Rangfolge — an einem Abend zweimal gedreht

Die Rangfolge, nach der dieses Projekt entscheidet, welcher Text gilt, wurde am 06.08. **innerhalb von fuenf Stunden zweimal bewegt**. Beide Bewegungen waren richtig, und die Reihenfolge ist der Punkt.

#### V.2.1 Bewegung 1 (22:22 Uhr) — die Termine werden zur Primaerquelle erhoben

Ausloeser war der `pmc:intel`-Abend (III.4.3). Der Owner, **KERN 13**: *„Ich sag es dir ja: **Gedaechtnisluecken, es ist alles geplant** und du musst bitte mit explore lesen"*.

Der Fund bestaetigte ihn vollstaendig. Der Betreuer-Korpus — **11 Termine, 309 Dateien** — trug die Antwort seit vier Monaten (Belege in **I.4.2**). Daraus entstand `20260806-KANON-termine-plan-soll-gegen-ist.md` (894 Z.) und die Memory-Regel mit dem Titel *„docs/termine ist die Primaerquelle"*.

#### V.2.2 Bewegung 2 (nachts) — der Owner dreht sie um

Der Owner korrigierte die frisch gesetzte Regel, verbatim (**KERN 15**):

> „Die **Betreuer Plaene sind wochen alt und nicht mehr aktuell**, **die Diplomarbeit zaehlt** und der **neuere Stand schlaegt den alten**."

**Die geltende Rangfolge:**

| Rang | Quelle | Rolle |
|---|---|---|
| **1** | **Die Diplomarbeit** — die sechs eingebundenen Kapitel + die gesetzte Aufgabenstellung | **Die geltende Spezifikation.** Was dort steht, ist die Zusage. |
| **2** | Ledger + Plandokumente, **nach Datum** | juengerer Stand schlaegt aelteren |
| **3** | `docs/termine/` (11 Betreuer-Termine, 309 Dateien) | **Historie und Herkunft** — wertvoll, aber wochen alt |

Der Lead nahm es im selben Turn an (`live 7804`): *„Ich hatte `docs/termine/` zur Primaerquelle erklaert — **falsch**. […] Wo ein Termin der Thesis widerspricht, **gilt die Thesis**."*

#### V.2.3 Warum beide Bewegungen richtig waren

Die zweite hebt die erste nicht auf. Sie trennt zwei Fragen, die vorher in einem Wort steckten:

| Frage | Quelle | Warum |
|---|---|---|
| **„Was gilt?"** | Thesis, dann Ledger/Plaene nach Datum | Der Betreuer liest das Manuskript. Die Zusage steht dort. |
| **„Warum ist X so — und welche Fehlerklasse wurde vorhergesagt?"** | `docs/termine/`, besonders die **Risikotabellen** | Der Plan hat die Hybrid-Fehlerklasse vier Monate vorher benannt. |

**Die Termine sind entlastet und aufgewertet zugleich.** Sie sind keine Rechtsquelle mehr — und genau deshalb darf man sie lesen, ohne bei jedem Fund einen Bau-Auftrag daraus ableiten zu muessen.

**Ein struktureller Erzeuger der Luecke, der bis heute offen ist:** `docs/termine/INDEX.md` — der als Wegweiser gedachte Pflicht-Pre-Read — traegt `**Stand:** 2026-05-15` (Z. 3) und listet die Termine 1–8. Treffer fuer „Termin 9|Termin 10|Termin 11" = **0** bei Nenner 174 Zeilen, Positivkontrolle „Termin 8" = **4**. **Wer dem Index folgt, liest die drei juengsten und damit geltenden Termine systematisch nicht.** Das ist keine Nachlaessigkeit eines Lesers, das ist ein **defektes Werkzeug** — und damit exakt die Meta-Lehre aus III.10 in ihrer Doku-Form.

---

### V.3 Die zwei Falschaussagen

Das Diff-Dokument fand **zwoelf** Positionen, an denen die Arbeit etwas behauptet, das der Code nicht haelt (F-01 … F-12). Zehn davon sind Praezisions-, Kardinalitaets- oder Beleg-Fehler; sie sind einzeln in `DIFF §1` belegt, und die Sammel-Empfehlung dort ist durchgehend **(b) Text korrigieren**.

**Zwei Positionen sind von anderer Art.** Sie sind Existenz-Behauptungen ohne jeden Datenpunkt, sie stehen im Praesens beziehungsweise Perfekt, und — das ist das Entscheidende — sie werden von **keinem** der zwanzig Limitierungs-Punkte der Arbeit entlastet. Die Arbeit fuehrt eine ausdrueckliche Ehrlichkeits-Doktrin und eine lange Grenzen-Liste (40 Entlastungen E-01 … E-40). Diese beiden Aussagen fallen durch jede Masche. Sie sind **unbeantwortet** beim Owner.

#### V.3.1 F-01 · Talos als zweites Betriebssystem-Regime

**SOLL — verifiziert am Stand `19e15920`, 07.08. 00:26 Z:**

`anhang/de/E_architecture_decisions.tex:140` traegt die Ueberschrift *„ADR-12 — Mess-Regime-Doppel: immutables Talos und root-Linux"*, `:144` den Text:

> „**jede Messung** unter zwei Betriebssystem-Regimes: einem immutablen Betriebssystem (Talos) […] und einem root-Linux mit vollem Hardware-Zaehler-Zugriff (`perf`/MSR)"

Paritaetisch in `anhang/en/E_architecture_decisions.tex:141,146`. Gestuetzt und verschaerft an zwei weiteren Stellen je Sprache: `kapitel/de/05_evaluation.tex:85` und `kapitel/de/01_einleitung.tex:226` (je mit EN-Pendant). **Also: sechs Fundstellen in eingebundenem Text, drei je Sprache.**

**IST — verifiziert an ce `c4c04315`, 07.08. 00:28 Z:**

```
/usr/bin/grep -rliw "talos" libs apps tools tests modules adapters benchmarks
  -> 0 Treffer
Gegenprobe im selben Suchraum, dasselbe Verfahren:
/usr/bin/grep -rli "perf_event_open" libs apps tools tests
  -> Dateien mit Treffern (an c4c04315: 4 Dateien / 18 Treffer in libs)
```

Die Null hat ihren Nenner und ihre Gegenprobe. Ergaenzend: die OS-Achse kennt genau drei Auspraegungen — `operating_system_axis.hpp:76,83,89` = `LinuxOperatingSystem`, `WindowsOperatingSystem`, `MacosOperatingSystem`. **Talos ist kein Baustein.** Die Datenlage: `measurements.csv`, Spalte `platform` (Feld 160), ueber **alle 16 Datenzeilen ein einziger Wert** `linux-x86_64`. Ledger: **ein** Treffer (`:791`), und der ist Infrastruktur. Register: **0**.

**Verdikt: FEHLT.** Eine Allquantor-Behauptung („jede Messung") ohne einen einzigen Datenpunkt, ohne Bau-Spur, ohne CI-Spur, und **ohne Entlastung**.

| Weg | Was zu tun ist | Aufwand | Konsequenz |
|---|---|---|---|
| **(a) Bauen** | Talos-Lane als vierte Auspraegung der OS-Achse, Runner-Installation auf **beiden** Produktionsmaschinen, Mess-Strang anschliessen | **mehrere Tage Infra** — und der Cluster ist fuer diesen Agenten read-only | ADR-12 haelt |
| **(b) Aussage zuruecknehmen** | ADR-12 auf ein Regime zurueckziehen, die beiden Kapitelstellen gleichlautend abschwaechen (je DE+EN = **sechs Stellen**), einen Limitierungs-Punkt ergaenzen | **unter einer Stunde** | Die Arbeit verliert die Doppelregime-Aussage und gewinnt einen sauber formulierten Ausblick |

**Empfehlung: (b).** Drei Gruende. Erstens steht die Aussage heute im Perfekt und ist nachweislich unwahr — das Risiko in der Verteidigung uebersteigt den Nutzen bei weitem. Zweitens ist der Aufwand asymmetrisch: mehrere Tage Cluster-Arbeit gegen eine Stunde Text, in einem Zeitfenster, dessen Engpass die Messung ist. Drittens: selbst wenn Talos installiert wuerde, muesste **jede** Messung doppelt gefahren werden — die Behauptung sagt „jede" —, und das verdoppelt exakt den Posten, der ohnehin nicht in die Zeit passt.

**Formulierungsvorschlag fuer den Limitierungs-Punkt:**
> „Die Erhebung erfolgt unter einem root-Linux mit vollem Hardware-Zaehler-Zugriff. Das zweite, immutable Betriebssystem-Regime (Talos) ist konzipiert, aber im Rahmen dieser Arbeit nicht erhoben; ADR-12 beschreibt insoweit ein Zielbild."

#### V.3.2 F-02 · `flat_hash_map` als namentlich zugesagte Baseline

Diese ist die schwerere von beiden, weil sie in dem Text steht, der **den geringsten Aenderungsspielraum** hat.

**SOLL — verifiziert am Stand `19e15920`:** `aufgabenstellung/de.tex:114` (gesetzt ueber `zihpub.cls:883`, also bindender Abgabetext, dem Betreuer vorgelegt):

> „vergleicht die Konfigurationen gegen etablierte Baselines, darunter eine nicht-baumartige Hash-Tabelle (`flat_hash_map`) als Gegenprobe innerhalb derselben Gattung."

`aufgabenstellung/en.tex:105` paritaetisch.

> **Methoden-Nebenbefund:** Die erste Suche nach `flat_hash_map` ueber die Thesis lieferte **null** — weil LaTeX den Unterstrich escapt: im Manuskript steht `\texttt{flat\_hash\_map}`. Die Null war ein Suchartefakt, nicht ein Befund. **Dieselbe Klasse wie FA-2 und FA-3 aus Kapitel III: nicht das Werkzeug war falsch, sondern der Ausschnitt, den es sah.**

**IST — verifiziert an ce `c4c04315`:**

```
/usr/bin/grep -rli "flat_hash_map" libs apps tools tests   -> 0 Treffer
Gegenprobe: /usr/bin/grep -rli "swisstable" libs           -> 11 Dateien (ce 54106bc9; identisch via `git grep -il swisstable 54106bc9 -- libs`)
```

Repoweit trifft `flat_hash_map` zehnmal, **keiner** davon ist Projektcode — drei Thesis-Spiegel, einer in der googletest-Doku, sechs im vendorten Fremdtest `ext/allocator/A06-tcmalloc/…`. Was existiert, ist eine **eigene Re-Implementierung**: `axis_03a_search_algo_swisstable.hpp:4` „@family S22 SwissTableSearchAlgo", und `:12` sagt selbst *„AP-7b: Weg-B-Organ (SwissTableOrgan) fuer den echten Mess-Pfad noch offen"*. Ledger: **0**. Register: **0**.

**Und eine Textlage, die den Fall schaerft:** In **keiner** der zwoelf gebundenen DE-Dateien kommt `flat_hash_map` vor. Es lebt ausschliesslich in der gesetzten Aufgabenstellung und in totem Kapitelmaterial. **Die Zusage steht im unveraenderlichsten Text und wird von keinem lebenden Kapitel aufgegriffen. Sie ist nicht widerrufen, sie ist verwaist.**

**Verdikt: FEHLT** (im Code) beziehungsweise **ABGEWICHEN** (eigene SwissTable statt der namentlich genannten Bibliothek).

| Weg | Was zu tun ist | Aufwand |
|---|---|---|
| **(a) Bauen** | `absl::flat_hash_map` vendoren und als Baseline-Baustein registrieren | **~1 Tag** — plus die **Messung** |
| **(b) Text nachziehen** | Die **eingebundenen Kapitel** nehmen die Gegenprobe namentlich auf und weisen aus, dass sie ueber eine eigene SwissTable-Reimplementierung (S22) erfolgt | wenige Stunden, DE+EN |
| **(c) Beides** | bauen **und** die Abweichung erklaeren | ~1 Tag + Text |

**Empfehlung: (c).** Die Aufgabenstellung sagt *„vergleicht … gegen etablierte Baselines, darunter …"* — das ist ein **Vergleich**, also eine Messaussage. Weg (a) allein loest die Bindung deshalb **nicht**: ein registrierter, aber nie gemessener Baustein erfuellt „vergleicht" nicht. Weg (b) allein laesst eine namentliche Zusage im gesetzten Text unwidersprochen. **Wichtig fuer die Reihenfolge:** (a) muss **vor** dem Abgabe-Messlauf stehen. Das pinnt den Posten auf spaetestens Freitag 3 (21.08.).

#### V.3.3 Die anderen zehn — Verweis, nicht Wiederholung

| # | Kurzfassung | Verdikt | Weg |
|---|---|---|---|
| F-03 | `docs/quality_audit` zeigt ins Leere; das beschriebene 7-Achsen-Verfahren ist nicht das implementierte | ABGEWICHEN, zwei Defekte | (a) Pfad, (b) Verfahren |
| **F-04** | **Die PMC-Limitierung ist in Gegenrichtung falsch** — die Arbeit spricht sich ihre staerkste vorhandene Messgroesse selbst ab (`le_limitierung.tex:20` sagt „0 / nicht erhoben", die CSV fuehrt `pmc_cache_misses_l1 = 756.895.968`) | ABGEWICHEN | **(b), mit Vorrang** |
| **F-05** | **PRT-ART ueberschreibt sechs Slots — im Code ist es einer.** Drei namentlich zugesagte Slots sind literal CE-Standard | ABGEWICHEN — 1 statt 6 | (a) fuer Prefetch+ValueHandle, (b) fuer den Rest — **H3 haengt daran** |
| F-06 | `resolve_baustein.hpp` als Beleg — quarantaeniert seit 18.07., TEST-ONLY, deckt elf statt vierzehn Achsen | ABGEWICHEN (Beleg, nicht Sache) | (b), Beleg-Tausch |
| **F-07** | **Zwei der Ersatztext-Begruendungen im Anhang sind sachlich unwahr** — `working_set_n` existiert (Feld 159, Wert 4096), und `linear_scan` ist mit **21 Medianen** gemessen, zwei Tabellen vor dem Ersatztext, der behauptet, es gebe keinen Nenner | ABGEWICHEN — **eine Ehrlichkeits-Konstruktion, die eine unwahre Behauptung transportiert** | (a) pruefen, dann (b) |
| **F-08** | **Die Anhang-Tabellen sind aus keinem Repo-Bestand reproduzierbar.** Genau ein echter Mess-Lauf (16 Datenzeilen); die WIDE-CSV ist unauffindbar | **UNBELEGBAR** | (a) mit Frist, sonst (b) — **teuerster Einzelposten der Verteidigung** |
| F-09 | Der Anhang fuehrt 19 Achsen, die Kapitel fuehren einhellig 18 — Widerspruch **im selben PDF** | ABGEWICHEN | (b), zwingend |
| F-10 | „320 registrierte Tests" — stale **und** kollidiert mit der anderen 320 (golden-Katalog) sechs Zeilen spaeter | ABGEWICHEN + mehrdeutig | **Zahl streichen**, Invariante behalten |
| F-11 | `T11` statt `T10` fuer den ChainRef-Slot, beide Sprachen | ABGEWICHEN | (b) |
| F-12 | Zehn Kardinalitaets-Abweichungen (25→26 Allokatoren, 21/17→22 Suchalgorithmen, 3→8 Fingerprint-Glieder, `curve_fit` als „Skeleton" bei 537 Zeilen …) | ABGEWICHEN | durchgehend (b) — **Ausnahme F-12d**: vier Lastprofile existieren nirgends |

**Zwei Beobachtungen, die erst im Zusammenhang sichtbar werden:**

Erstens: **vier der zwoelf Positionen machen die Arbeit kleiner, als sie ist** (F-04, F-06, F-12c, F-12h). Der Reflex „die Arbeit uebertreibt" trifft hier nur zur Haelfte. **Ein Drittel der Abweichungen ist Untertreibung**, entstanden dadurch, dass der Text aelter ist als der Code. Das ist die Rangfolge V.2 von der anderen Seite: auch die Thesis kann gegenueber dem Ledger veraltet sein, und dann gilt sie trotzdem — nur muss sie **nachgezogen**, nicht bestaetigt werden.

Zweitens: **F-07 ist der einzige Punkt, an dem die Ehrlichkeits-Doktrin der Arbeit gegen sich selbst arbeitet.** Die Doktrin (`anhang/de/A_measurements.tex:77-88`, „honest-100%") verlangt, dass jeder fehlende Eintrag einen eigenen Ersatztext traegt. Heute gemessen an `19e1592`: **28 Eintraege je Sprache, 0 stumme `}{}{}`** — die Doktrin ist mechanisch erfuellt. Nur transportieren zwei der Begruendungen eine unwahre Tatsachenbehauptung. **Eine Ehrlichkeits-Konstruktion, die falsch informiert, ist schlechter als eine Luecke** — sie verbraucht das Vertrauen, das sie herstellen soll.

---

### V.4 Was an der Voll-Messung haengt

Der Grundsatz steht in einem Satz (`DIFF §4`): **„Was nicht gemessen wird, kann die Arbeit nicht behaupten."**

#### V.4.1 Die drei Aussagen, die heute unbelegbar sind

`DIFF §4.1` fuehrt M-01 bis M-12 einzeln. Hier nur, was **strukturell** haengt, nicht bloss quantitativ:

| # | Aussage | Warum sie nicht bloss „mehr Daten" braucht |
|---|---|---|
| **M-04 / H2** | „Der Qualitaets-Score korreliert **messbar** mit dem Durchsatz" | **UNBELEGBAR — keine der drei Voraussetzungen liegt vor.** (i) Der Score: ≤11 von 33 numerisch, CSV-Spalte durchgaengig `-`. (ii) Der **Durchsatz**: die Spalte **existiert gar nicht**; die Arbeit sagt selbst `:192-193` „wird als Schema-Erweiterung ergaenzt". (iii) Datenpunkte fuer eine Korrelation. **Die einzige statistische Hypothese der Arbeit.** |
| **M-05 / H3** | „Die ValueHandle-Verteilung korreliert mit der Page-Dichte" | **UNBELEGBAR — die Achse ist gepinnt.** `le_limitierung.tex:21` fuehrt `value_handle` unter den gepinnten Achsen, PRT-ART belegt sie literal mit `InlineValueHandle`. **Kein Lauf der Welt loest das** — es braucht die E6-Anbindung des ChainRef-Organs. **M-05 haengt an F-05.** |
| **M-07** | „Der Beitrag jeder Entwurfsentscheidung wird **erstmals** unter sonst gleichen Bedingungen separierbar und messbar zurechenbar" | **Die staerkste wissenschaftliche Behauptung** — und sie braucht Reihe B als echten Achsen-Sweep. `messreihen.xml:48-56` sagt ueber Reihe B selbst: *„Im aktuellen Skelett identisch zu A_full"*. Kein Sweep. |
| **M-06** | Der heuristische **Gegenbeweis** als vierte Evaluations-Dimension | Braucht die Bau-Varianten-Matrix — die Arbeit erklaert ausdruecklich, dass sie **nicht existiert** (E-11). Der Hybrid-Modus: nur `README.md`. Und: **M-06 steht in keiner Limitierungs-Liste.** |

**Die Kopplung, die im Terminplan alles ordnet:**

```
F-05 (PRT-ART-Slots)          ->  M-05  ->  H3     Voraussetzung, nicht Datenmenge
Durchsatz-Spalte im Record    ->  M-04  ->  H2     Voraussetzung, nicht Datenmenge
messreihen.xml Reihe B Sweep  ->  M-07             Voraussetzung, nicht Datenmenge
```

**Alle drei sind Bau-Posten von 0,5 bis 3 Tagen, und alle drei muessen VOR dem Abgabe-Messlauf stehen.** Wer sie verpasst, muss drei Hypothesen streichen — nicht abschwaechen, streichen. **Das ist die haerteste Kopplung im ganzen Terminplan, und sie war in keiner Wochenplanung vor dem 06.08. sichtbar.**

#### V.4.2 Der Messumfang, der sich daraus ergibt

`DIFF §4.2` leitet sieben Mindestanforderungen ab, nach Kosten sortiert:

1. **Reihe B als echter Achsen-Sweep** — traegt M-07. *1 Tag.*
2. **`value_handle` entpinnt + PRT-ART-ChainRef im Messpfad** — traegt M-05/H3. *2–3 Tage.*
3. **Durchsatz-Spalte im Mess-Record** — traegt M-04/H2. *0,5 Tag.*
4. **≥3 Stuetzpunkte `working_set_n`** statt des einen 4096 — traegt drei Darstellungen und heilt F-07a endgueltig. *0,5 Tag.* **(Siehe II.8.2: der golden-Sweep plant vier.)**
5. **YCSB-E im Workload-Satz** — traegt H1 vollstaendig (heute nur A/C). *0,5 Tag.*
6. **Reihe A ueber ≥8 Rang-1-Profile**, mit gefuellter `series`-Spalte (heute `-` in allen 16 Zeilen).
7. **≥2 Wiederholungslaeufe je Konfiguration** mit HDR-Perzentilen.

Alles darueber hinaus — 2¹⁷ × 4, Full-Sampled, zweites OS, zweite Maschinen-Lane — ist bis zum 15.09. **nicht erreichbar** und gehoert in die Limitierungen (V.5.5).

#### V.4.3 Die Zahl, die niemand kennt — und die eine, die der Owner selbst geliefert hat

Die Bau-Mengen-Frage (Faktor 16) steht vollstaendig in **IV.3.3/B-2** und wird hier nicht wiederholt. Fuer die Terminplanung zaehlt nur die Folgerechnung:

| Bau-Menge | seriell (11 s/Binary) | auf 24 Workern |
|---:|---:|---:|
| 131.072 | 400 h ≈ 16,7 d | ~16,7 h |
| 524.288 | 1.602 h ≈ 66,8 d | ~66,8 h ≈ 2,8 d |
| 2.097.152 | 6.408 h ≈ 267 d | ~11,1 d |

Und die **Mess**-Seite ist der eigentliche Engpass: 216 Mess-Faecher × 524.288 = 113.246.208 Messungen × 0,1094 s = **143,4 Tage 1-Thread = 71,7 Tage auf zwei Lanes** — gegen etwa 40 verfuegbare. Die 109,4 ms sind ausdruecklich als **Untergrenze** ausgewiesen (IV.7).

> **Der Faktor 16 entscheidet, ob der Bau 17 Stunden oder 11 Tage kostet — und damit, ob Freitag 5 als Messwoche ueberhaupt existiert.** Die naechste Handlung ist billig: **Binaries zaehlen statt addieren**, 2–3 Stunden.

#### V.4.4 Die Freigabe-Bedingung des Owners — vier Auflagen, keine davon erfuellt

Der Owner hat die Voll-Messung freigegeben, aber an Bedingungen gebunden (19:37:43Z, Frage 1, verbatim):

> „Die Freigabe ist erteilt, sobald **alle Binaries gebaut** sind und das **erste batch korrekt gemessen** werden kann (Bitte beachte die batch Einteilung in **maximal 4096 jobs** fuer compile und Messung). Also volles GO der voll-Messung sobald **ALLE bekannte offene Arbeit aller Phasen und wellen steht** und grundsaetzlich gemessen werden kann in **vollem definierten Umfang der Mess-Parameter**."

**Stand heute, gegen diese Auflagen gemessen:**

| Auflage | Stand 07.08. | Beleg |
|---|---|---|
| alle Binaries gebaut | **offen** — die Bau-Menge ist unbekannt | IV.3.3/B-2 |
| erstes Batch korrekt messbar | **teilweise** — PMC-Invariante gelandet, Messfenster geheilt, L3-Ehrlichmachung gelandet. Offen: RAW-Events, getrennte Ablage je PMU-Domaene | IV.3.3/B-7, B-9 |
| ALLE bekannte offene Arbeit steht | **offen** — E18-SNAP ungelandet, `numa_cpu_pin_process_probe` ungelandet, die super-Haelfte nicht einmal committet | IV.2 |
| voller Umfang der Mess-Parameter | **offen** — die Reihe-B/Durchsatz/ValueHandle-Kette steht nicht | V.4.2 |
| **XML trennt Bau von Messung** | **offen, am Objekt belegt** | IV.3.3/B-3 |
| Mess-Seite in 4096er-Scheiben | **offen** — der Bau slict korrekt, die Messung faehrt „das VOLLE `[0:COMDARE_GN_TOTAL)` … einmal je Batch" | `experiment_plan_director.hpp:1410-1413` (Kommentar `:1410`, `export COMDARE_GOLDEN_N_RANGE` `:1412-1413`, ce `54106bc9`; `:1367-1369` ist die `rules:`-Emission) |

**Die Freigabe ist erteilt und greift heute nicht.** Das ist kein Widerspruch und keine Blockade — es ist eine Liste. Sechs Posten trennen den Stand von der Voll-Messung, und fuenf davon sind Bau-Arbeit von Stunden bis wenigen Tagen.

#### V.4.5 Der Identitaets-Widerspruch, der vor dem ersten Batch entschieden werden muss

Zwei Owner-KERNe stehen unaufgeloest gegeneinander — der Reproduzierbarkeits-KERN („die gleiche binary auf der selben Maschine … liefert identische Ergebnisse uneingeschraenkt") und **KERN 4** („Damit hat die Intel Maschine effektiv 2 PMC"). Die vollstaendige Darstellung steht in **I.10/1** und **IV.3.3/B-7**; hier nur die Terminfolge:

> **Sidecar-Bestand heute 0 (gemessen, mit Gegenprobe) ⇒ eine Preimage-Aenderung kostet 0 Stunden. Nach dem ersten Batch kostet sie 34,4 h Neubau plus alle bis dahin erhobenen Messdaten. Das Fenster schliesst mit der ersten geschriebenen `.fingerprint`-Datei.**

Gefuehrt als Owner-Entscheid **D-1** in V.6.4.

---

### V.5 Der Terminplan — sechs Freitage, drei Plaene, ein Widerspruch

#### V.5.1 Der Rahmen

Der Owner hat den Termin am 06.08. um 19:37:43Z gesetzt (verbatim):

> „Nun der **End-Termin ist der 15.09.2026** und wir muessen **JEDEN Freitag neue Ergebnisse liefern**. Und **morgen sollten wir schon messen koennen** mit allen paramtetern, wenn auch nur das erste batch mit 4096 Einheiten und danach die 320er XML Einstellung auf der Basis ALLER kompilierter binaries"

**Nachgerechnet, verifiziert:** der 15.09.2026 ist ein **Dienstag**. Zwischen dem 06.08. und ihm liegen genau sechs Freitage — **07.08. · 14.08. · 21.08. · 28.08. · 04.09. · 11.09.** —, danach vier Restkalendertage.

Das Ledger bucht die Korrektur als **N-1** und nennt sie *„den schwersten Einzelverlust des Tages"*. Der Grund steht im Buchungsstand daneben: `15.09` = **0 Treffer im Ledger (damals 6169 Z.), 0 Treffer im 14-Tage-Register (474 Z.)**. Die Quelle, woertlich:

> „FRIST-KORREKTUR: Endtermin ist der 15.09.2026, mit woechentlicher Lieferung jeden Freitag. **Der 08.08. war ein Zwischenziel. Jede Priorisierung, die gegen den 08.08. gerechnet wurde, ist falsch.**"

**Die Termin-Klassen:** **T1** = vor dem ersten 4096er-Batch · **T2** = vor der Voll-Messung · **T3** = vor dem 15.09. · **T4** = danach. Das Checkheft formuliert die Umwertung praezise: *„aus ‚unrealistisch' wird ‚nicht in dieser Woche'; aus ‚nach der Abgabe' wird ‚in einem der sechs verbleibenden Freitags-Pakete'. Kein Befund verfaellt dadurch — aber die Dringlichkeitsstufen, die aus dem 08.08. abgeleitet wurden, tragen nicht mehr. **Die Rangfolge bleibt, der Ausschluss faellt.**"*

> **Eine Mehrdeutigkeit, die noch aufzuloesen ist.** Der Owner spricht am Abend des 06.08. mehrfach von „der Abgabe morgen" (O-095: *„nach der Abgabe morgen dran"*). Das Ledger N-1 sagt dagegen, der 08.08. sei ein Zwischenziel. **Beides kann stimmen** — eine Zwischenabgabe am 07./08.08. und der Endtermin am 15.09. —, aber die Wochenplanung sieht verschieden aus. Siehe V.6.5/T-1.

#### V.5.2 Drei Plaene fuer dieselben sechs Freitage

Am 06.08. entstanden **drei** Wochenplanungen, jede in einem eigenen Dokument, jede aus einer anderen Primaerquelle abgeleitet, keine mit Kenntnis der beiden anderen. **Das ist der Zusammenhang, der nirgends stand.**

| Freitag | **Plan A** — Thesis-getrieben<br>`DIFF-thesis §7` | **Plan B** — Betreuer-Plan-getrieben<br>`KANON-termine §6` | **Plan C** — Auswertung/Hybrid-getrieben<br>`PLAN-messkurven §8` |
|---|---|---|---|
| **07.08.** | Falschaussagen tilgen — reine Textpaesse DE+EN, **kein Codebau** | **Mess-Validitaet klaeren + Stempel** (D-17, D-08) | Abgabe + **Register-Nachtrag V-09a-1..8** |
| **14.08.** | **WIDE-Rohdaten zurueckholen** (F-08) + Durchsatz-Spalte | **Hybrid-Lane** (D-02, D-29) — der Term der Forschungsfrage | **V-09a-8 Datenkorrektheit (T2)** |
| **21.08.** | **Reihe B wird echter Sweep** + `working_set_n` + YCSB-E | **Vertikaler Beweis-Schnitt: PRT-ART + SOTA messen** (D-01, D-07) | **V-09a-2 Auswertungs-Orchestrator** |
| **28.08.** | **PRT-ART in den Messpfad** — *danach Schnitt* | `page_type` permutieren + Ablation (D-05, D-04) | **V-09a-4 Multi-Last → multiple beste Binaries** |
| **04.09.** | **Der Abgabe-Messlauf** (2–3 Tage Rechenzeit) | Billige Deklarationen + Datensatz-Konsum | Design-Auflagen + **HY-B1a** |
| **11.09.** | Text an die Daten, Grenzen ziehen, **einfrieren** | Kapitel 7 + Anhang + EN-Sync + Limitierungsliste | **HY-B1b + HY-B2** (Break-Even-Router) |
| **nach 15.09.** | Puffer 12.–14.09., kein Bau mehr | — | HY-B3, HY-B4, V-09a-7 |

**Die Konflikte, benannt:**

1. **Woche 3 (21.08.) ist dreifach belegt** mit drei verschiedenen Bauten von je etwa einem Tag. Sie schliessen sich nicht logisch aus, aber sie passen nicht in eine Woche.
2. **Woche 4 (28.08.) ebenso** — und Plan A legt hier den **Schnitt**. Die Plaene B und C kennen keinen Schnitt und bauen bis 11.09. weiter.
3. **Woche 5 (04.09.):** Plan A braucht die Woche vollstaendig fuer den Messlauf. Plan C legt in dieselbe Woche den Hybrid-Bau HY-B1a. **Plan B plant ueberhaupt keinen Voll-Lauf** — sein 21.08. ist ein vertikaler Schnitt, nicht die Abgabe-Messung.
4. **Plan C erklaert den Voll-Lauf ausdruecklich fuer nicht kritisch:** *„Was NICHT auf diesen Pfad gehoert: der Voll-Lauf [1] selbst."* Plan A macht ihn zum Zentrum der Abgabe. **Das ist keine Terminfrage, das ist eine Zieldivergenz.**

#### V.5.3 Der eine echte Widerspruch — PRT-ART

Zwei Dokumente desselben Tages geben auf dieselbe Frage die entgegengesetzte Antwort.

**Plan A, `DIFF §8/O-8`:** *„(a) Prefetch **und** ChainRef verdrahten (2–3 Tage, Freitag 4). Traegt H3. […] **Empfehlung: (b) als Minimum, (a) wenn Freitag 4 haelt.** ChainRef ist die Voraussetzung von H3."*

**Plan B, `KANON §7/O-2`:** *„Empfehlung: **umrahmen, nicht vertikalisieren.** Die Vertikalisierung ist in 6 Wochen neben allem anderen nicht sicher zu schaffen, und T11 hat die Arbeit bereits als »**Framework-Arbeit**« neu gefasst."*

Beide Empfehlungen sind in sich schluessig. Sie folgen verschiedenen Prioritaeten: Plan A will **H3 retten**, Plan B will **den Rahmen der Arbeit anpassen**.

**Aufloesung nach der geltenden Rangfolge (V.2):** Rang 1 ist die Thesis. Die Thesis fuehrt H3 als Hypothese (`05_evaluation.tex:19-21`) und sagt die sechs ueberschriebenen Slots an **drei Stellen je Sprache** zu (F-05). Der T11-Satz „Framework-Arbeit" ist Rang 3 — Historie, und noch dazu eine, die nicht im Manuskript angekommen ist. **Also gilt Plan A**, solange der Owner die Hypothese H3 nicht streicht.

**Aber:** Plan B hat mit seiner Zeitschaetzung recht, und die Kopplung aus V.4.1 gibt den Ausweg. Es gibt einen **minimalen** Weg, der H3 traegt: **nur ChainRef**, nicht Prefetch. ChainRef ist die Voraussetzung von H3; Prefetch traegt „nur" die Sechs-Slot-Zusage, und die ist **textlich heilbar**. Das halbiert den Posten und erhaelt die Hypothese.

> **Vorgeschlagene Aufloesung: ChainRef bauen (H3 ueberlebt), Prefetch textlich zuruecknehmen (F-05 Weg b fuer den Rest).** Der Owner entscheidet — es ist Entscheid **C-6** in V.6.3.

#### V.5.4 Der zusammengefuehrte Vorschlag

Ordnungsprinzip, in dieser Reihenfolge: **(1)** Rangfolge V.2 — Textkorrekturen, die eine Falschaussage tilgen, kosten nichts und gehen zuerst. **(2)** Die T-Gatter — Datenkorrektheit vor Datenmenge. **(3)** Die Owner-Auflagen aus V.4.4 — nicht verhandelbar, nur terminierbar. **(4)** Was die Thesis als Grenze erklaert, ist kein Bau-Posten: E-12 sagt ausdruecklich, dass nur Modus 1 heutiger Betrieb ist. **Damit ist die Hybrid-Kette aus Plan C ueberwiegend T4** — der Owner sagt dasselbe (O-095: *„nach der Abgabe morgen dran"*). Was von Plan C **vor** die Voll-Messung gehoert, ist genau ein Posten: **V-09a-8 (Datenkorrektheit)**, und der ist T2.

| Freitag | Lieferung | Woher | Warum genau hier |
|---|---|---|---|
| **07.08.**<br>*„Falschaussagen und Buchfuehrung"* | **(1)** Textpaesse A: F-04 PMC-Limitierung differenzieren · F-09 auf 18 Achsen · F-11 T11→T10 · F-10 Testzahl streichen · F-06 Beleg tauschen · F-12-Sammelpass — **DE+EN**<br>**(2)** die **31 Register-Zeilen** uebernehmen (23 × `§63-T-*` + 8 × `V-09a-*`)<br>**(3)** F-07 Generator-Lauf **pruefen**<br>**(4)** die zwei ungelandeten Pakete landen oder verwerfen — **inklusive der uncommitteten super-Haelfte** | A + V.1.3 | Kostet **keine Bau-Zeit** und tilgt sofort jede Aussage, die das heutige Repo widerlegt. Der Register-Nachtrag ist Voraussetzung dafuer, dass die Wochen 2–6 ueberhaupt sichtbare Posten haben. Punkt (4) ist eine Verlustsicherung: die super-Haelfte von `core_class` hat **keinen rescue-Ref** |
| **14.08.**<br>*„Datenkorrektheit und Rohdaten"* — **T2-Woche** | **(1)** **F-08: WIDE-Rohdaten zurueckholen**<br>**(2)** **V-09a-8 Datenkorrektheit**<br>**(3)** **Mess-Validitaet** aus Plan B (D-17)<br>**(4)** **Durchsatz-Spalte** — Voraussetzung H2<br>**(5)** **Bau-Menge messen**, 2–3 h | A + B + C | **Alles hier ist T2** — es entscheidet, ob die spaeteren Zahlen etwas bedeuten. Plan B hat mit seiner Prioritaet recht: das eigene Messverfahren verdaechtigen kommt **vor** dem Messen |
| **21.08.**<br>*„Der Sweep und die zweite Lane"* | **(1)** **Reihe B auf echten Achsen-Sweep**<br>**(2)** **≥3 Stuetzpunkte `working_set_n`** + **YCSB-E**<br>**(3)** **Hybrid-Lane / getrennte P-E-Messung** (Plan B, D-02)<br>**(4)** F-02 `flat_hash_map` **bauen**<br>**(5)** LP02/03/07/13 bauen **oder** Tabelle kuerzen | A + B | Die drei Sweep-Posten sind **Voraussetzungen, keine Datenmenge**. Die Hybrid-Lane gehoert hierher: sie braucht die PMC-Grundlage aus Woche 2. `flat_hash_map` muss vor dem Lauf registriert sein |
| **28.08.**<br>*„Letzte Bau-Woche — danach Schnitt"* | **(1)** **PRT-ART-ChainRef-ValueHandle** verdrahten — traegt H3<br>**(2)** Sechs-Slot-Aussage im Text auf das Erreichte ziehen<br>**(3)** Restliche Freigabe-Auflagen: **XML trennt Bau/Messung** · Mess-Seite in 4096er-Scheiben | A (mit V.5.3) | **Ab hier wird nicht mehr gebaut, sondern als Grenze formuliert.** Der Schnitt laesst zwei Freitage plus drei Tage Puffer — bei **zwei Sprachfassungen** ist das die Reserve, die man nicht einsparen darf |
| **04.09.**<br>*„Der Abgabe-Messlauf"* | **(1)** **320er-Katalog-Lauf** ueber Reihe A und Reihe B, ≥2 Wiederholungen, HDR-Perzentile, PMC an, batchweise à 4096<br>**(2)** Auswertungskette `binary_to_csv` → `csv_to_latex` → `diagram_generator` → Anhang-Generator<br>**(3)** pruefen, welche der 28 fehlenden Anhang-Darstellungen der Lauf schliesst | A | Die Woche gehoert **allein** dem Lauf. Plan C's HY-B1a faellt hier heraus — er ist T4 |
| **11.09.**<br>*„Text an die Daten, einfrieren"* | **(1)** Zahlen auf den Abgabestand ziehen<br>**(2)** **Limitierungs-Kapitel schliessen** — alle Grenzen aus V.5.5, **DE+EN**<br>**(3)** **EN-Sync**<br>**(4)** Schlussdurchlauf DE+EN, `.blg` alphadin, 0 undefinierte Referenzen | A + B | Die Limitierungsliste ist der Posten, an dem die Arbeit ihre Ehrlichkeits-Doktrin einloest. Sie ist **kein Anhaengsel** — sie ist die Haelfte, die die andere Haelfte verteidigbar macht |
| **12.–14.09.** | **Puffer. Kein Bau.** | A | |
| **nach 15.09. (T4)** | Die Auswertungs-/Hybrid-Kette: V-09a-1..7, HY-B1a…B4 | C | Von der Thesis selbst als Ziel deklariert (E-12); vom Owner terminiert |

#### V.5.5 Was nicht mehr hineinpasst — und deshalb als Grenze formuliert werden muss

Der Betreuer-Plan verlangt genau das, ausdruecklich (T10): *„Der aktuelle Fortschritt wird **ehrlich** kommuniziert … Die entdeckte Methodik-Luecke wird **nicht versteckt**, sondern als wissenschaftlich korrekter Audit-Befund eingeordnet."* Und T11: *„Diese Punkte **nicht verstecken** — aktiv als wissenschaftliche Sorgfalt zeigen."*

| Posten | Warum nicht schaffbar | Wo die Grenze hin muss |
|---|---|---|
| **Talos / zweites OS-Regime** (F-01) | Infra read-only, Installation auf zwei Produktionsmaschinen | **Neuer Limitierungs-Punkt** + ADR-12 zurueckziehen — heute in **keiner** Liste |
| **ZIH Barnard / Sapphire Rapids** | Kein Zugang, keine Zeit fuer Slurm-Integration | Scope-Grenze mit Begruendung; **der Plattformterm der Forschungsfrage ist explizit einzuschraenken**, nicht stillschweigend |
| **Zweite Maschinen-Lane im Messstrang** | Mess-Jobs sind einlanig `tags: [prod, baremetal, amd]`; das **Zaehler-Gate** ist zweilanig, der **Mess-Strang** nicht | „Der Zaehler-Nachweis erfolgt zweilanig (AMD und Intel, beide Pflicht ohne `allow_failure`); der Mess-Strang laeuft im Stand dieser Arbeit einlanig auf der AMD-Produktionsmaschine." |
| **2¹⁷ × 4 = 524.288 Binaries** | Mess-Seite allein 71,7 Tage auf zwei Lanes | Bereits Grenze — **praezisieren**: gefahren wurde der 320er-Katalog |
| **Vierte Evaluations-Dimension / heuristischer Gegenbeweis** (M-06) | Bau-Varianten-Matrix existiert nicht; Hybrid-Modus = nur `README.md` | **Fehlt bislang in jeder Limitierungs-Liste** — muss ergaenzt werden |
| **H2-Korrelation**, falls die Durchsatz-Spalte nicht bis 21.08. steht | drei fehlende Voraussetzungen | Streichen oder auf „qualitative Einordnung" zuruecknehmen — **Entscheid C-4** |
| **Drei Ordnungsmodi / T1-H4** | Achse existiert nicht | Als **nicht bearbeitete Hypothese** ausweisen, nicht streichen |
| **Prefix-Operationen im Dominanzanspruch** | wenn 21.08. nicht reicht | FF3/H3 ausdruecklich auf Exact-Operationen einschraenken — **Eingriff in den Dominanzanspruch, Owner-Entscheid** |
| **Original-Compiler-Binary-Linking** | acht fremde Codebasen gegen den eigenen Bau zu linken | „Die Rekonstruktion erfolgt als registrierte Re-Implementierung gegen das jeweilige Original." |
| **Intel Advisor / CLU nach Plan** | Werkzeug nicht verfuegbar | Das strukturelle CLU-Surrogat ist verteidigbar, **muss aber als Surrogat benannt werden** |
| **Drei Wallclock-Ebenen im Datenbestand** | `seg_*_ns`-Spalten existieren im Schema, sind aber teils ungefuellt (I.7.3) | Praesens auf das Erreichte ziehen oder als Zielbild markieren |

---

### V.6 Die offenen Owner-Entscheide

Dieser Abschnitt ist die vollstaendige Sammlung, aus fuenf Quellen zusammengezogen — `DIFF §8` (10), `KANON §7` (7), `PLAN-messkurven §9` (8), `UEBERBLICK §J` (~27 Kennungen) und dem Transkript (die sechs Planungs-Rueckfragen). **Die Nummerierungen der Quelldokumente kollidieren** — es gibt drei verschiedene „O-1" und zwei „O-4" — deshalb tragen die Eintraege hier eigene, kollisionsfreie Kennungen. Jeder Eintrag hat eine Empfehlung und ein **Fenster**.

#### V.6.1 Rang 1 — die beiden Falschaussagen (Fenster: Freitag 1)

| # | Frage | Empfehlung | Fenster |
|---|---|---|---|
| **A-1** | **Talos:** bauen oder zuruecknehmen? | **(b) zuruecknehmen** — sechs Textstellen, unter einer Stunde, plus ein Limitierungs-Punkt (V.3.1) | **07.08.** — jeder Tag, an dem sie steht, ist ein Tag mit einer unwahren Abgabe |
| **A-2** | **`flat_hash_map`:** bauen, Text nachziehen oder beides? | **(c) beides** — Baustein bis 21.08. registrieren, Abweichung in den gebundenen Kapiteln benennen (V.3.2) | Entscheid **07.08.**, Bau bis **21.08.** |

#### V.6.2 Rang 2 — die sechs Planungs-Rueckfragen (unbeantwortet, vom Owner ausdruecklich erbeten)

Der Owner hat sie um 23:47:31Z freigegeben (O-100, siehe II.1). Das ist ein bemerkenswerter KERN: die Dauerregel *„Es gibt keine Unklarheiten … nur Gedaechtnisluecken"* wird fuer **diesen** Bereich befristet aufgehoben. Bei sechs Wochen alten Plaenen sind Rueckfragen erwuenscht. Der Lead stellte daraufhin sechs Fragen — **alle sechs unbeantwortet**.

| # | Frage, verbatim aus dem Turn | Der Befund dahinter | Empfehlung |
|---|---|---|---|
| **B-1** | „Soll **jeder einzelne Achsenaufruf** im Hot-Path getimt werden — oder je Achse ein **Aggregat innerhalb der echten Last** statt im Nachlauf? Ein Timer je Aufruf kostet bei Millionen Operationen mehr als die Operation selbst." | Die 18 Segment-Timer klammern heute **Schleifen** und laufen als **synthetischer Nachlauf**. Die echte `tier_lookup` macht **7 Achsenaufrufe, davon 0 gemessen** (I.7.3) | **Aggregat innerhalb der echten Last.** Ein Timer je Aufruf verletzt die eigene Limitierung E-30 in verschaerfter Form — der Overhead wuerde das Messobjekt dominieren |
| **B-2** | „**Wandert die Messung ins Pruefdock**, oder ist der Orchestrator der richtige Ort?" | Gemessen wird heute im `workload_orchestrator`; das **Pruefdock hat null Zeitmessung** (18 Dateien, `clock::now` = 0), und `IPruefDock::measure()` ist im Produktionspfad **tot** | **Ins Dock** — aber als T4-Posten. Ein Umbau des Messortes vor der Abgabe waere genau der Eingriff, der die vorhandenen Daten entwertet |
| **B-3** | „Gibt es **Break-Even-Punkte je Ebene**?" | Der Plan schneidet auf **einer** Ebene: `working_set_n` gegen `ns_per_op` | **Eine Ebene bis 15.09., alle drei danach.** |
| **B-4** | „Liest der Selector die Messwerte **aus** dem Lager und legt das Ergebnis **dort** ab? Und ist die **Break-Even-Tabelle ein Lager-Objekt** mit eigenem Schluessel?" | O-100 laesst beides zu | **Lesen und ablegen, nicht verwalten** — und die Break-Even-Tabelle **als Lager-Objekt mit eigenem Schluessel**. Sonst hat das Ergebnis keine Identitaet, und die Reproduzierbarkeits-Doktrin greift fuer die Auswertung nicht |
| **B-5** | „Bekommt der Hybrid-Adapter die Schnittpunkte **einkompiliert** (CT) oder liest er sie **zur Laufzeit** aus dem Lager?" | Die Stufen-Doktrin und die Aenderbarkeit der Schaltlogik ziehen in verschiedene Richtungen | **Offen lassen bis nach der Abgabe** — aber die Frage jetzt buchen. Sie entscheidet die Bauform von HY-B2 |
| **B-6** | „Ist ein Kanal ein Schnitt durch **einen** Parameter bei festgehaltenen anderen — oder braucht es **mehrdimensionale Kipp-Flaechen**?" | `BreakEvenPoint` traegt heute **einen** x-Wert; ein Last-Kanal hat mehrere Dimensionen | **Ein Parameter bei festgehaltenen anderen**, dokumentiert als Einschraenkung. Kipp-Flaechen sind mathematisch sauber und in sechs Wochen nicht belegbar |

> **Zum Zusammenhang:** Alle sechs betreffen die Auswertungs-Kette, und die ist ueberwiegend **T4**. Sie sind **nicht abgabekritisch** — mit **einer** Ausnahme. **B-4** beruehrt die Identitaet der Break-Even-Tabelle, und Identitaet ist ein T1-Thema. **B-4 gehoert deshalb vor den ersten Batch, die anderen fuenf nicht.**

#### V.6.3 Rang 3 — Thesis-Entscheide (Fenster: Freitag 1 bis Freitag 4)

| # | Frage | Empfehlung | Fenster |
|---|---|---|---|
| **C-1** | **„alle erdenklichen Binary-Permutationen"** steht in `aufgabenstellung/de.tex:74-75` **ohne jede Einschraenkung**; `03_messsystem:1237-1239` gesteht die Deckelung ein — aber im Kapitel, nicht in der gesetzten Aufgabenstellung | **(a)** Die Deckelung in einem gebundenen Kapitel **ausdruecklich gegen den Aufgabenstellungs-Wortlaut stellen** | 07.08. |
| **C-2** | **Was heisst „der `std::map`-Vertrag"** in `06_fazit.tex:91-93`? Die 5er-Kernteilmenge oder die 17 Vertragsoperationen? Bei der zweiten Lesart kann **heute keine Plattform als verifiziert gelten** | **Formulierung eindeutig machen** — „den Kern-Vertrag (Einfuegen, Suchen, Loeschen, Leeren, Groesse)" — und die 17 als Folgeschritt daneben | 07.08. |
| **C-3** | **Die bias-freie Vollmatrix** — in drei gebundenen Kapiteln zugesagt, im Register auf „reine Doku-Vermerke, kein Bau" abgestuft | **(a) hochstufen, aber begrenzt:** ueber den **320er-Katalog**, nicht ueber 2¹⁷. Die Bias-Freiheit ist der methodische Kern | 04.09. (Lauf), Entscheid bis 21.08. |
| **C-4** | **Hypothese H2** — braucht Score, Durchsatz-Spalte (existiert nicht) und Datenpunkte | **(a) mit Abbruchkriterium:** Durchsatz-Spalte bauen (Freitag 2). **Wenn die Spalte nicht bis Freitag 3 steht, dann (b) streichen.** Eine unbelegte statistische Aussage ist teurer als eine fehlende | Abbruchkriterium **21.08.** |
| **C-5** | **Vier fehlende Lastprofile** LP02/03/07/13 (Thesis nennt 14, real 10) | **(a) bauen.** Profile sind XML, kein Code | 21.08. |
| **C-6** | **PRT-ART-Slots** — der Widerspruch aus V.5.3 | **ChainRef bauen** (traegt H3), **Prefetch textlich zuruecknehmen** | 28.08. — danach faellt H3 |
| **C-7** | **WIDE-Rohdaten** — wie weit soll die Suche gehen, bevor auf Wiederholungslauf umgeschaltet wird? | **Ein Tag Suche, dann umschalten.** Wichtig: **entweder alles neu oder alles gefunden, nicht gemischt** | 14.08. |
| **C-8** | **Der Schnittpunkt** — ab wann wird nicht mehr gebaut? | **28.08. bestaetigen.** Bei zwei Sprachfassungen ist der Puffer die riskanteste Einsparung | **07.08.** — der Schnitt muss frueh feststehen, sonst wirkt er nicht |

#### V.6.4 Rang 4 — Mess- und Bau-Entscheide (Fenster: T1/T2)

| # | Frage | Empfehlung | Fenster |
|---|---|---|---|
| **D-1** | **Gehoert die PMU-Domaene in die Mess-Identitaet?** (I.10/1, IV.3.3/B-7, V.4.5) | **Ja, als Feld der Mess-Achse** — nicht als Preimage-Glied. KERN 5 hat geklaert, dass die Trennung eine **Permutation** ist; damit gehoert die Kern-Klasse in die **Mess**-Identitaet (welche Zeile), nicht in die **Binary**-Identitaet (welches Artefakt). `binary_id="never"` bleibt unberuehrt | 🔴 **VOR DEM ERSTEN BATCH.** Heute 0 Sidecars ⇒ 0 h. Danach 34,4 h + alle Messdaten |
| **D-2** | **Welche Bau-Menge gilt?** Faktor 16 | **Erst messen, dann entscheiden.** Binaries zaehlen statt addieren (2–3 h); `cap` muss wirken oder laut abgelehnt werden | 🔴 vor dem ersten Batch |
| **D-3** | **Welche Mess-Teilmenge?** 71,7 d gegen ~40 verfuegbare | **Weg C** (320er-Auswahl voll + alle Binaries flach, ≈ 3,1 d). Die einzige Variante, die den 15.09. haelt, und sie deckt sich mit der Thesis-Zusage | 🔴 vor dem ersten Batch |
| **D-4** | **`allow_failure: true` am Voll-Mess-Batch** | **Preflight in einen eigenen harten Job trennen.** Solange die Zeile steht, ist auch ein roter PMC-Preflight unsichtbar — **der stille Rueckfall in CI-Form**, und der ist per KERN 10 verboten | 🔴 vor dem ersten Batch |
| **D-5** | **Fail-closed:** die gruene PMC-Ampel ist heute eine Aussage ueber den **Compile**, nicht ueber den **Hardware-Zugriff** | **Fail-closed umbauen** ueber `kPmcExpected`; SKIP → FAIL | 🔴 T1 |
| **D-6** | **Anhangsumfang PMC:** `branch_misses` jetzt verdrahten? RAPL-Zone auf der AMD-Lane unbelegt | **Nicht verdrahten, sondern deklarieren** — und die Deklaration muss **ehrlich** sein. Das L3-Paket ist gelandet; `branch_misses` ist der letzte offene Rest | T2 |
| **D-7** | **Die Faktorisierung der Core-Achse.** Betreuer-Plan (09.04.): `{P\|E} × {Single\|All}` + Referenz. Achsen-Dossier (16.07.): `{Unpinned\|PCoresOnly\|ECoresOnly\|HybridAware}`. **Nicht dasselbe** | **Das Dossier**, nach Rangfolge V.2 — **und `Unpinned` ist unverzichtbar**, weil KERN 7 den Fall „kann nicht pinnen" ausdruecklich als gueltigen, warn-behafteten Zustand definiert | 🔴 vor dem Bau der Unter-Achse |
| **D-8** | **NoFilter=Identitaet vor dem Trigger mit golden-Neuanker?** | **Gegenstandslos in der Bau-Frage** — E14 ist **gebaut und gelandet** (`ed67661c`). Offen bleibt nur, ob der golden-Katalog neu angeankert wird. **Empfehlung: nein** vor der Abgabe | T2 |
| **D-9** | **`refs/backup/pre-secret-scrub-20260802`** auf origin (776 Runner-Token). Verifiziert: der Ref liegt **nur auf GitLab**, Gegenprobe github = 0 | Owner-Entscheid „stehen lassen" gilt; die **Rotation** ist an Infra abgegeben (I113) und dort **unerledigt**. Ein Loeschen erfordert ausdrueckliche Owner-Autorisierung | offen |

#### V.6.5 Rang 5 — Termin- und Prozess-Entscheide

| # | Frage | Empfehlung | Fenster |
|---|---|---|---|
| **T-1** | **Was ist „die Abgabe morgen"?** (V.5.1) | **Klaeren, ob am 07./08.08. ein Betreuer-Dokument abgeht.** Wenn ja, ist Freitag 1 kein reiner Textpass | 🔴 sofort |
| **T-2** | **Welche Frist gilt?** 15.09. mit woechentlicher Lieferung gegen „Abgabe Fr 08.08." im Projektgedaechtnis | **15.09. bestaetigen** — die gesamte Wochenplanung haengt daran | 🔴 sofort |
| **T-3** | **Hybrid-Lane: Maschine oder Gate?** T11 M2 verlangt bei fehlendem Zugang „ein **klar dokumentiertes Gate**" | **Eine Woche (21.08.) reservieren; wenn er scheitert, am selben Freitag das Gate schreiben.** **Schweigen ist laut M2 keine der erlaubten Optionen** | 21.08. |
| **T-4** | **T1-H4 (Ordnungspolitik): bearbeiten oder streichen?** | **Als nicht bearbeitete Hypothese ausweisen, nicht streichen.** Streichen veraenderte den Hypothesensatz gegenueber T1 stillschweigend | 11.09. |
| **T-5** | **Wiederholungen 3 oder 5?** Plan sagt 5, ein frueherer Owner-Entscheid sagt 3, real gefahren wurde **1** | **Bei 3 bleiben** und die Abweichung benennen — aber **mindestens 3 tatsaechlich fahren**. Eine 1 erfuellt auch den Owner-Entscheid nicht | 04.09. |
| **T-6** | **Darf `docs/termine/INDEX.md` nachgezogen werden?** Er endet bei Termin 8 und ist der mechanische Erzeuger der heutigen Luecke | **Ja, additiv** — Termine 9/10/11 ergaenzen, Stand-Datum hochziehen, **nichts loeschen** | 07.08. — kostet Minuten und schliesst einen strukturellen Erzeuger |
| **T-7** | **Welcher der drei Synthese-Stacks ist kanonisch?** 1802 Zeilen, 0 Produktions-Konsumenten | **`heuristik/` als kanonisch** (plan- und schutzgedeckt, einzige Fassung mit der Fritsch-Carlson-Begruendung, II.7), die zweite als Konsument umbauen, die dritte zurueckbauen. **Der Entscheid muss vor dem §75-Aufraeumpass fallen**, sonst entscheidet der Pass implizit | vor dem Aufraeumpass |
| **T-8** | **„Beste Binary" = EIN Sieger oder Pareto-Front?** Drei Definitionen koexistieren (II.6.2) | **Erst `21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md` lesen** — dort sollen die sieben §H-Forks entschieden sein; **nicht am Objekt geprueft**. Wenn dort offen: **Pareto-Front je Workload-Cluster mit Objective-Tag** | T4 |
| **T-9** | **„Min/Max-Semantik je Achse" — existiert die Festlegung?** `break_even.hpp:17` setzt „besser = kleinerer y-Wert" als **Konvention**, nicht als Achsen-Eigenschaft | **Als eigenen Posten fuehren.** Ohne die Min/Max-Zuordnung je Achse ist der Kurvenvergleich fuer Max-Achsen **systematisch falsch herum** | T4, aber Deep Research **frueh starten** |
| **T-10** | **Die Last-Erkennungsheuristik ist NICHT detailliert geplant** — 0 in Code, 0 im Design-Doc, 0 im Register | **Als Luecke melden und als Deep-Research-Posten frueh starten.** Sie ist der einzige Posten der Kette **ohne Boden** und blockt HY-B2 | Start 21.08. |
| **W-3** | **Das Akzeptanzkriterium fuer Ebene 2** — Zeitpaar je Aufruf oder Checkpoints darin? *(neu, aus Abschnitt 0)* | **Checkpoints**, wenn H2 auf Achsen-Ebene beantwortet werden soll; **Zeitpaar**, wenn die Ebene nur als Klammer dient. Die Entscheidung bestimmt, ob Ebene 2 als „gebaut" oder als „fehlend" in die Limitierungen geht | vor Freitag 3 |

#### V.6.6 Was sich beim Zusammenziehen als erledigt herausstellte

Ehrlichkeit ueber den Nenner: nicht jeder Eintrag der Sammellisten ist noch eine Frage. Drei sind es nicht mehr, und das gehoert ins Kapitel, weil sonst jemand sie baut (Regel-Zeile 17).

| Ehemals offen | Stand heute |
|---|---|
| „Zwei Gitlinks auf dasselbe Thesis-Repo, `thesis/diplomarbeit` nicht gebumpt ⇒ Gate 8 fehlt im gebauten PDF" | **ERLEDIGT und bewacht.** Heute gemessen an super `5a98036d`: **beide** Gitlinks stehen auf `19e159203ac8f6fe18db59d7a1bc71ad6dc00cfa`. Der Rueckschrieb bumpt seit `3ccbc501` beide Zeiger, und `ci/thesis_gitlink_parity.sh` prueft **Gitlink gegen Gitlink** |
| „17 von 28 Anhang-A-Eintraegen voellig stumm" | **ERLEDIGT.** Gemessen an thesis `19e1592`: **28 Eintraege je Sprache, 0 stumme `}{}{}`** (zur 28-gegen-30-Frage: Abschnitt 0 / W-1). Offen bleibt allein F-07: zwei der Begruendungen sind sachlich falsch |
| „Darf der §63-T-23-Vor-Abgabe-TODO gestrichen werden?" | **Gegenstandslos** — er verlangt „§50-K-5 vor Abgabe schliessen"; der Code steht seit drei Nachzuegen auf `kAbiMajor=8` mit Paritaets-`static_assert` |

**Und ein Posten, dessen Biss unbewiesen ist** — er darf nicht als Blocker gefuehrt werden, ohne das zu sagen: der chktex-Blocker („EXIT 123, 31 Warnungen ueber 8 Dateien"). In der Thesis-CI nachgelesen: der Job `lint:latex` traegt `rules: - if: '$COMDARE_TEXLIVE_AVAILABLE == "true"'`. **Er laeuft nur, wenn diese Variable gesetzt ist.** Ob sie auf den Runnern gesetzt ist, ist von hier aus nicht entscheidbar. Der Blocker ist also entweder scharf oder inert, und **niemand hat es gemessen**. **Dieselbe Klasse wie die stillen Nullen aus Kapitel III — eine Wache, deren Erreichbarkeit unbekannt ist, ist kein Beweis. Naechste Handlung: einen Lauf ansehen, nicht die Datei.**

---

### V.7 Die Fenster, die sich schliessen

Zum Schluss die einzige Ordnung, die operativ zaehlt: nicht nach Wichtigkeit, sondern nach **Verfallsdatum**. Eine Entscheidung, die heute nichts kostet und morgen 34 Stunden, ist dringender als eine wichtigere ohne Frist.

| Fenster | Was darin entschieden werden muss | Kosten heute | Kosten danach |
|---|---|---|---|
| **Vor der ersten `.fingerprint`-Datei** | **D-1** PMU-Domaene in der Mess-Identitaet · **B-4** Break-Even-Tabelle als Lager-Objekt | **0 h** (Sidecar-Bestand = 0, gemessen) | **34,4 h Neubau + alle bis dahin erhobenen Messdaten** |
| **Vor dem ersten 4096er-Batch (T1)** | **D-2** Bau-Menge · **D-3** Mess-Teilmenge · **D-4** `allow_failure` · **D-5** fail-closed PMC · **D-7** Core-Achsen-Faktorisierung | Stunden bis 1 Tag | Ein Lauf, der Daten mit falscher Semantik erzeugt — und „fixen und neu messen ist Pflicht" macht das zum Doppelaufwand |
| **Freitag 1 — 07.08.** | **A-1** Talos · **A-2** `flat_hash_map` · **C-1** Permutations-Wortlaut · **C-2** `std::map`-Vertrag · **C-8** den Schnitt auf 28.08. bestaetigen · **T-1/T-2** Frist-Klaerung · **T-6** INDEX nachziehen · **die 31 Register-Zeilen buchen** | **< 1 Arbeitstag insgesamt** | Jeder weitere Tag ist ein Tag mit zwei unwahren Aussagen in der Abgabe — und die Wochen 2–6 planen ueber unsichtbare Posten |
| **Vor Freitag 3 — 21.08.** | **C-4** H2-Abbruchkriterium · **A-2** Bau-Haelfte · **T-3** Hybrid-Lane: Maschine oder Gate · **W-3** Akzeptanzkriterium Ebene 2 | 1–2 Tage Bau | H2 muss gestrichen werden; `flat_hash_map` bleibt ungemessen; der Plattformterm bleibt unbelegt |
| **Freitag 4 — 28.08., der Schnitt** | **C-6** PRT-ART: ChainRef ja oder nein | 2–3 Tage | **H3 muss gestrichen werden** — nicht abgeschwaecht, gestrichen |
| **T4 — nach dem 15.09.** | **B-1, B-2, B-3, B-5, B-6** · **T-8** Pareto-Front · **T-9** Min/Max je Achse · **T-10** Last-Erkennung | — | Kein Verfall. Aber **T-9 und T-10 brauchen langen Vorlauf** und sollten trotzdem am 21.08. gestartet werden |

**Zwei Saetze zum Schluss, und sie gehoeren zusammen.**

Der erste steht im Diff-Dokument und ist die Regel dieses Kapitels: *„Zwei Wege sind zulaessig — bauen ODER die Aussage in der Arbeit korrigieren. Aber einer muss gegangen werden."*

Der zweite ist vom Owner (**KERN 10**): *„**Stiller Rueckfall geht fuer uns nicht: Regressionen oder Fehler gehoeren angezeigt.**"*

Er hat ihn ueber die Fehlerausgabe eines Messprogramms gesagt. Er gilt fuer ein Manuskript wortgleich. Eine Zusage, die der Code nicht haelt und die niemand zuruecknimmt, ist ein stiller Rueckfall — mit dem Unterschied, dass sie nicht in einer Logdatei steht, sondern in der Arbeit, die verteidigt wird.

**Von den zwoelf Falschaussage-Positionen sind zehn in einem Arbeitstag Text zu heilen. Zwei brauchen eine Entscheidung. Beide liegen seit dem 06.08. abends beim Owner.**

---

## KAPITEL VI — DIE ZWOELF KERNE ALS REFERENZ

> **Das ist die Seite, die man aufschlaegt, wenn man spaeter nachsehen will, was genau gesagt wurde.**
>
> **Wortlaut-Quelle:** `super docs/sessions/backups/20260806-session-transkript-verbatim/session-ab-vorletzter-kompaktierung.jsonl` (Fundstellen mit `bak`) und die Vollspanne `/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl` (Fundstellen mit `live`). Wo beide existieren, sind beide genannt.
>
> **Eine Warnung zur Vollstaendigkeit, die vor die Liste gehoert (I.0.1):** die gesicherte Fassung deckt **43 von 104** Owner-Nachrichten dieses Kontextes ab, und der kanonische Extraktionsfilter (`type=="user"` ∧ `promptSource ∈ {typed,queued}` ∧ `origin.kind=="human"`) **findet acht der zwoelf KERNe unten gar nicht** — sie liegen als `queue-operation`-Datensaetze vor. Wer diese Liste nachpruefen will, muss beide Datensatztypen lesen.
>
> **Und eine Warnung zur Verdichtung:** die Ledger-Fassung in `abend-4` kuerzt mehrere dieser Zitate (Anreden, Zwischensaetze). Wo dieses Kapitel und der Ledger auseinandergehen, **gilt das Transkript**.

---

### VI.1 Die zwoelf Architektur-KERNe des Abends

Sie fielen zwischen **21:55:10Z** und **23:28:07Z** — in **93 Minuten**. Hier in **thematischer**, nicht chronologischer Ordnung: von der Hardware-Zaehler-Domaene bis zur Binary-Wahl. Die Uhrzeit steht bei jedem.

---

#### KERN 1 · Wozu die Hybrid-Binary da ist
`live 7601` · **2026-08-06T23:10:06Z** · queued

> „Korrekt. Die **erste Stufe der Rangbildung** ist, dass die **Tier-binaries einfach direkt drangehaengt werden**. Aber was passiert bei **gemischten Lasten des Suchalgorithmus**? Dann muss dieser **jede Linie an Last-Kanaelen einwandfrei unterstuetzen** und das braucht dann **nicht nur eine, sondern multiple optimale binaries je Last-Kanal**, daher der **Hybrid-Schaltungs-Adapter dazwischen, der die richtige Tier-Binary waehlt**."

*Einordnung:* Erklaert, warum die vierte Stufe kein Zwischen-Layer ist, sondern der **Schalter zwischen mehreren gemessenen Optima** — und damit, warum die Auswertung eine Funktionalitaets-Voraussetzung und keine Nachbereitung ist. → I.8, II.2

---

#### KERN 2 · Die Auswertungs-Kette
`live 7657` / `bak 3691` · **2026-08-06T23:14:14Z** · queued

> „Korrekt und die Auswertung braucht wiederum die Messwerte, aus der sie **Funktions-Synthese** und optimale Verarbeitung durch **Schnitt-Kurven zwischen den Parametern verschiedener Achsen und Gattungs/Genus-Funktionsinterfaces** ableiten kann. Die Messung fuehrt zur Funktions-Synthese und diese zum erkennen der **optimalen Konfiguration der Tier-Binaries, was aequivalent mit der zu waehlenden Binary ist**"

*Einordnung:* Der letzte Halbsatz ist die Bruecke des ganzen Systems — **die Auswertung produziert eine Schaltlogik, keinen Rat.** Und er nennt **zwei** Schnitt-Dimensionen, von denen heute nur eine gebaut ist (II-5). → II.1, II.2

---

#### KERN 3 · Die Schlangen-Mechanik und die drei Typen
`live 7256` · **2026-08-06T22:20:04Z** · queued

> „Moment: Die CEB baut die Compile time der Tier-Binaries und fuehrt dann deren Laufzeit aus. Also der **Kopf der schlange ist Laufzeit** und kontrolliert **durch den Bau immer die compile time des naechsten gliedes** und dann die **freigegebenen Laufzeit-Eigenschaften dieses Gliedes**. Bitte Schau nochmal nach ZWEIPHASIG und DREIPHASIG per Explore Agent, denn **es gibt 3 Typen in diesem System**"

*Einordnung:* Die Verallgemeinerung des §57-Kettengesetzes vom 20.07. auf **jedes** Glied — und der Satz, der die Vokabel-Falle „Stufe gegen Phase" ausloest: die Stufenzahl ist dehnbar, die Typenzahl nicht. → I.2.1, I.3

---

#### KERN 4 · PMC ist eine Menge, keine Einrichtung
`bak 3103` / `live 7069` · **2026-08-06T21:55:10Z**

> „Soweit ich mich erinnere muessen **ALLE per deep research belegbaren Architekturen von AMD und Intel** mit PMC unterstuetzt werden. Dazu gehoeren **Performance Core und E-Core PMC Einrichtungen, die getrennt gemessen und ausgewertet werden**. **Damit hat die Intel Maschine effektiv 2 PMC und nicht nur eins.** Dieses muss **je Konfiguration compile time nach der Freigabe durch den Planer in die CEB eingearbeitet werden**"

*Einordnung:* Vier Festlegungen in vier Saetzen — und der Satz, der mit dem Reproduzierbarkeits-Axiom kollidiert, weil „selbe Maschine" auf einer Hybrid-CPU nicht mehr fein genug ist (Owner-Entscheid **D-1**, fensterkritisch). Seit **09.04.2026** Betreuer-Pflicht, nie gebaut. → I.4, IV.3.3/B-6, V.4.5

---

#### KERN 5 · Die Permutation, kein zweiter Bau *(Lead-Korrektur 1)*
`bak 3141` / `live 7107` · **2026-08-06T22:02:43Z**

> „**Du hast ein Verstaendnis-Problem ueber die CEB**, bitte Explore Agent dazu: Die CEB **kann beide Messfuehler tragen**, aber legt die Ergebnisse **je PMC getrennt** ab. Die Tier-Binary wird ueber die **Permutation aller Achsen** insbesondere ueber die **Permutation der NUMA Achse und deren Core-Unterachse** zur Laufzeit der CEB und zur Runtime der Tier-Binary gemessen. Kurz und knapp: Die CEB kann alles messen, aber startet **einmal die Tier-Binary gepinnt auf einen E-Core und einmal gepinnt auf einen P-Core** und misst die Tier-Binary dann mit dem entsprechenden PMC durch. Das ist eine **reine Wiederverwendung durch Achsen-Permutation durch die CEB auf einer dafuer zustaendigen SYSTEM-Achse**."

*Einordnung:* Der teuerste widerlegte Irrtum des Abends — er haette 34,4 h Neubau plus alle Messdaten gekostet. Strukturell gedeckt durch `binary_id="never"`, nicht bloss zugesichert. **Merksatz: die Hybrid-Trennung ist eine PERMUTATION, kein zweiter Bau.** → I.5.1, III.4.1, IV.6.2

---

#### KERN 6 · Der Planer prueft, die CEB traegt *(Lead-Korrektur 2)*
`live 7219` · **2026-08-06T22:17:04Z** · queued

> „Die **Pinning Faehigkeit prueft der Planer zur Laufzeit**, sodass die **CEB zur compile Zeit die korrekten Binary-Code-Routinen traegt** (Interfaces zur Pinning Abfrage an das korrekte OS Interface -> **je OS anders hard compiled** - oder **keine Pin Interfaces da nicht vorhanden**) und der **Planer bewegt die System-Unterachsen unter den System-Haupt-Achsen**, sodass **CEB ein bestimmtes Verhalten der Tier-Binaries faehrt**."

*Einordnung:* **Merksatz: der Planer FRAGT (RT), die CEB TRAEGT (CT), die Tier-Binary LAEUFT (unveraendert).** Und die Nebenaussage, die leicht ueberlesen wird: „keine Pin-Interfaces" ist ein **gueltiger Bauzustand**, kein Fehler. → I.5.3, III.4.2

---

#### KERN 7 · Wenn nicht gepinnt werden kann — der WARN-Kompromiss
`bak 3189` / `live 7155` · **2026-08-06T22:08:13Z**, ergaenzt durch `live 7166` · **22:09:48Z**

> „hat eine CPU nicht das pinning Feature (**zusammen mit einem OS Kernel der das auch unterstuetzen und durchreichen muss**), kann eine Maschine nicht pinnen und **muss die PMC Werte tatsaechlich mit der Warnung ausgeben, dass die Werte nicht tragen, weil der Ort der Ausfuehrung nicht bekannt ist**."

und, 95 Sekunden spaeter:

> „Nun bei diesem fehlenden Pinning Feature gibt es ja **ehrliche Messwerte**, aber ob man sie **gebrauchen** kann ist fraglich. Ich wuerde **nur hier** einen **Kompromiss** eingehen und **kein „fatal" ausgeben aber „warn: no pinned locality on hybrid architecture"**"

*Einordnung:* Der Warntext ist **woertlich vorgegeben** und steht heute **nicht im Code** (0 Treffer, Gegenprobe `sched_setaffinity` = 2). Die Faehigkeit haengt an **zwei** Bedingungen: CPU **und** Kernel, der es durchreicht. Ausdruecklich als Einzelfall markiert („nur hier"). **Merksatz: ehrlich erhoben, fraglich verwendbar → WARN.** → I.6, V.6.4/D-7

---

#### KERN 8 · Die fehlende Unter-Achse
`bak 3415` · **2026-08-06T22:36:35Z**, Namensvorgabe `live 7387` · **22:37:57Z**

> „**Warte:** numa page ist eine **Cache-Seiten Koordination von Cache-Seiten lokalitaet**. Jetzt brauchen wir ein pendant numa_process_probe dazu, welche sich damit beschaeftigt, **wo Programme ausgefuehrt werden, nicht welche Speicherseiten wo liegen**, sie sind aber beide **strukturell aehnliche Unterachsen**. Das ist also eine **fehlende neue Unterachse, sie existiert nur im Plan, nicht gebaut**"

und:

> „Ich moechte numa_process_probe besser **numa_cpu_pin_process_probe** nennen"

*Einordnung:* Die Trennung **Speicher**-Lokalitaet (`numa_page_probe`, gebaut) gegen **Ausfuehrungs**-Lokalitaet (fehlt). Der Name benennt **das Pinning** als Gegenstand, nicht bloss den Prozess. Ratifiziert um 22:40:07Z mit zwei Worten: *„Alles korrekt erkannt"*. Der ce-Anteil liegt ungelandet (`b4cebdc4`), die super-Haelfte ist **nicht einmal committet** — der gefaehrlichste Einzelposten der Bilanz. → I.5.5, IV.2.3

---

#### KERN 9 · Die vollstaendige Schwere-Leiter
`bak 3226` / `live 7192` · **2026-08-06T22:13:48Z**

> „Sieht gut aus, akzeptiere ich. Volles GO. **Error** waere etwa, wenn der Kunde in der XML eine **GPU Variante der Binary bauen will, aber gar keine GPU im System registriert ist**. Also etwas, das mit **fehlenden grundlegenden Systemeigenschaften** zu tun hat. **Fatal** waere: **Abbruch des Compile oder Messung durch Kappen von Kabeln, Verbindungsabbrueche, unerwarteter Speicherverlust, Lager-Inkonsistenz**."

*Einordnung:* Die drei Stufen haben verschiedene **Naturen**, nicht bloss verschiedene Lautstaerken. Zwei Trennlinien: *WARN gegen ERROR — gibt es einen Wert?* · *ERROR gegen FATAL — war der Zustand vorher konsistent?* Und: **Lager-Inkonsistenz ist FATAL.** Das GPU-Beispiel steht seit dem **26.07. woertlich im Code** (`axis_error.hpp`) — die Leiter musste nicht erfunden, sondern wiedergefunden werden. → I.6, III.9, IV.4.3

---

#### KERN 10 · Stiller Rueckfall ist verboten
`bak 3547` / `live 7513` · **2026-08-06T22:59:15Z**

> „Hinweis: **Stiller Rueckfall geht fuer uns nicht: Regressionen oder Fehler gehoeren angezeigt, das ist ein weiterer Fall fuer das Anzeigen von error**"

*Einordnung:* **Der wichtigste Satz dieser Session.** Er dreht die Diagnose von der Erhebungsseite auf die **Konstruktionsseite**: die These *„eine korrekte Messung, die die falsche Frage beantwortet"* beschreibt das Symptom — der stille Rueckfall ist die Bauform, die es erzeugt. Erste gebaute Umsetzung: ce `5c102e05` (07.08. 00:14). Gilt fuer Wachen, CSV-Zellen, CI-Jobs **und Manuskripte**. → III.1.2, IV.4, V.7

---

#### KERN 11 · Break even und die drei Benchmark-Ebenen
`live 7675` / `bak 3709` · **2026-08-06T23:20:06Z** · typed

> „Korrekt: das ist als **‚break even'** geplant. **Es gibt Schnittpunkte zwischen Parameter-Funktionskurven, die anzeigen, wann ein Algorithmus in einem Parameter ueber eine Achse als Organ effektiver wird.** Wenn wir das mit gemischten **Micro-Benchmarks** ueber alle Achsen (siehe Parameter Benchmarks der Achsen) und **Macro-Benchmarks** (siehe alle Achsen Parameter bei Aufruf einer beliebigen Funktion der verwendeten Achsen einer Gattung+Genus -> Gesamt-Messprofile timed einer Funktion ueber die Schritte und checkpoints ihrer Ausfuehrung zur Detail-Analyse ueber alle Achsen die sie verwendet hat) und **Macro-Benmarking large scope** ueber die Gesamtheit der Macro-Benchmark charts ALLER fuer ein Lastprofil aufgerufenen Gattung+Genus Funktionen auf dem Tier-Binary interface. Bitte explore Agent dazu, das ist geplant und muss dokumentiert werden."

*Einordnung:* Break-Even ist ein **Kipppunkt, kein Optimum** — und die operative Form von Hypothese H2 aus Termin 1 (30.03.). Der Halbsatz „**ueber die Schritte und checkpoints ihrer Ausfuehrung**" setzt das strengere der beiden Akzeptanzkriterien fuer Ebene 2 (**Widerspruch W-3**). Der Schlusssatz ist ein Auftrag: „das ist geplant und **muss dokumentiert werden**" — in der Thesis kommt der Begriff heute **0-mal** vor. → II.1, II.3, II.5, Abschnitt 0/W-3

---

#### KERN 12 · Wallclock auf drei Ebenen — und ihre Verortung
`live 7761` · **2026-08-06T23:26:59Z**, Verortung `live 7776` · **23:28:07Z**

> „Hinweis: **Wall Clock time** wird daher auch **fuer jeden Achsenaufruf IN der Tier-Binary**, **fuer jeden Funktionsaufruf durch die CEB AUF dem Pruefdock ueber die Tier-Binary**, und ebenfalls als **large scope im selben Zug zu den Last-Profilen ueber den Verlauf mehrerer Funktionsaufrufe der Tier-Binaries ueber eine gemessene Last-Sequenz**, erhoben. Die **Wallclock time ist das dritte Glied**, welches in der **Messachse in die CEB und damit DREIPHASIG in die Tier-Binaries eingearbeitet** wird und **lebt per Planung und Definition in der Mess-Achse**."

und, 68 Sekunden spaeter:

> „Korrekt: **fuer die Erhebung des Micro-Benchmarkings ist die Wallclock time zusaetzlich IN der Tier-Binary einkkompiliert. Ansonsten ist sie wie gehabt in der CEB.**"

*Einordnung:* Trennt zwei orthogonale Dimensionen, die den Abend gekostet hatten: **Tooling** (`wallclock`/`macro`/`micro`) gegen **Ebene** (Erhebungs-**Ort**). Der Halbsatz „fuer jeden **Funktionsaufruf**" setzt das mildere der beiden Akzeptanzkriterien fuer Ebene 2. **Der zweite Satz — die Verortung — fehlt bis heute in der Ledger-Konsolidierung**, weil er sechs Minuten nach dem Konsolidierungs-Auftrag eintraf. Ebenfalls offen: ob „drittes Glied" das Preimage-Glied [3] oder das dritte Kettenglied meint. → I.7

---

### VI.2 Die drei Quellen-KERNe, die den Abend erklaeren

Ohne sie ist die Liste oben unverstaendlich: sie sagen, **warum** zwoelf Praezisierungen an einem Abend noetig waren.

---

#### KERN 13 · „Es ist alles geplant"
`bak 3319` / `live 7285` · **2026-08-06T22:22:43Z**

> „Ich sag es dir ja: **Gedaechtnisluecken, es ist alles geplant und du musst bitte mit explore lesen**"

*Einordnung:* Die Ruege, die `docs/termine/` aufschloss — 11 Betreuer-Termine, **309 Dateien**, eine ganze Session lang ungeoeffnet. Dort stand die Hybrid-Regel seit dem **09.04.**, mit Risikozeile und fertigem Baustein-Entwurf. Der Preis: *„Ein roter CI-Job, drei falsche Ursachenvermutungen, eine beinahe ausgefuehrte Cluster-Rechte-Aenderung."* Sie ist die Anwendung eines aelteren Satzes desselben Tages (`live 2189`, 11:18:32Z): *„Es gibt keine Unklarheiten nach ueber 1500 beantworteten Fragen — nur Gedaechtnisluecken."* → Vorwort, III.5.4, V.2.1

---

#### KERN 14 · Die Diplomarbeit ist die Anforderung
`bak 3353` / `live 7319` · **2026-08-06T22:27:36Z**

> „Mal eine andere Frage: **Die Diplomarbeit ist ja die Anforderung an den Code, hast du da mal rein gelesen? Dort ist ja alles definiert, was im Ledger als TODO deklariert sein muss.** Wir brauchen bitte ein diff mit Opus 5 max effort ‚very thourough'"

*Einordnung:* Die Umkehrung der Richtung des ganzen Projekts: **das Ledger ist gegenueber dem Manuskript rechenschaftspflichtig, nicht umgekehrt.** Ergebnis: zwoelf Falschaussage-Positionen, davon zwei ohne jede Entlastung. Und die **23 abgeleiteten Ledger-Zeilen stehen bis heute in keinem Register** (V.1.3). → V.1

---

#### KERN 15 · Die Quellen-Rangfolge
`live 7777` · **2026-08-06T23:28:59Z**, uebernommen in Memory `reference_docs_termine_ist_die_primaerquelle:20-21`

> „Die **Betreuer Plaene sind wochen alt und nicht mehr aktuell**, **die Diplomarbeit zaehlt** und der **neuere Stand schlaegt den alten**."

*Einordnung:* Dreht die fuenf Stunden zuvor gesetzte Regel um — und beide Bewegungen waren richtig, weil sie zwei Fragen trennen: *„Was gilt?"* (Thesis, dann Ledger nach Datum) gegen *„Warum ist X so, und welche Fehlerklasse wurde vorhergesagt?"* (`docs/termine/`, besonders die Risikotabellen). **Die Termine sind entlastet und aufgewertet zugleich.** → V.2

---

### VI.3 Die Rahmen-KERNe desselben Tages

Kuerzer gefuehrt, aber im Werk laufend zitiert. Sie sind die Bedingungen, unter denen die zwoelf oben gelten.

| # | Zeit (Z) | Fundstelle | Verbatim (Kern) | Einordnung |
|---|---|---|---|---|
| **N-1** | 19:37:43 | `bak 1738` | „Nun der **End-Termin ist der 15.09.2026** und wir muessen **JEDEN Freitag neue Ergebnisse liefern**." | Der schwerste Einzelverlust des Tages: stand vorher **0/0** in Ledger und Register. Setzt die sechs Freitage. → V.5.1 |
| **N-2** | 19:37:43 | `bak 1738`, F1 | „Die Freigabe ist erteilt, sobald **alle Binaries gebaut** sind und das **erste batch korrekt gemessen** werden kann (… **maximal 4096 jobs** …). Also volles GO … sobald **ALLE bekannte offene Arbeit aller Phasen und wellen steht**" | Die Voll-Messung ist freigegeben und greift heute nicht — sechs Auflagen offen. → V.4.4 |
| **N-3** | 19:37:43 | `bak 1738`, F1e | „**nur weil sie kompiliert werden sollten, heisst es nicht dass sie auch gemessen werdne muessen, das muss die XML getrennt fuer build und Messung definieren koennen sonst regression**" | Bau-Posten **B-3 / M-6**. Existiert heute nicht. → IV.3.3 |
| **N-4** | 19:37:43 | `bak 1738`, F2 | „Wenn eine Messachse sich aendert … muss bei einem neuen Messsystem auch **die CEB und ALLE Binaries** … **neu gebaut** werden. … **Das ist eine Gedaechtnisluecke.**" | Die Fortpflanzungs-Asymmetrie: Mess-Aenderung baut CEB **und** Flotte neu; System/Organ nur die Tiers. → I.3.4 |
| **N-5** | 19:37:43 | `bak 1738`, F3 | „Es ist PFLICHT, dass das gemessen wird, was gemessen werden kann … also MUSS es auch mit eingebaut und gemessen werden und zwar in die CEB fuer deren Pruefdock. **NIE abkuerzen, immer mit deep research fixen bitte.**" | Bau-Posten **B-9**; heute blockiert auf einer nicht geladenen `amd_l3`-Uncore-PMU (Infra, I113 P-6). → IV.3.3 |
| **N-6** | 19:37:43 | `bak 1738`, F6 | „die gleiche binary auf der selben Maschine mit den selben Messachsen liefert **identische Ergebnisse uneingeschraenkt**, das ist die **Hauptidee des Systems und des Lagers**." | Kollidiert mit KERN 4 auf Hybrid-CPUs — **Owner-Entscheid D-1, fensterkritisch.** → V.4.5 |
| **N-7** | 20:25:12 | `bak 2120` / `live 6086` | „**die grosse Maschine schafft den compile von einem Batch in 11 Sekunden fuer eine Tier-Binary.** Kannst du ja ueberschlagen ob das passt. **Den build hatten wir schon einzeln gemessen.**" | Der Owner liefert die Kalibriergroesse, die der Lead als „fehlend" gemeldet hatte. Sie war bekannt, nur nicht gebucht. → IV.3.3/B-2 |
| **N-8** | 21:45:51 | `bak 3048` / `live 7014` | „Bitte (a) fuer intel die perf-Rechte geben, was muss ich dafuer tun? **Ein skip ist keine Loesung. Wir machen das richtig**" | Der Entscheid war richtig, seine Begruendung (a) wirkungslos — es war kein Rechteproblem. **(b) wurde staerker erfuellt als (a) es vorsah.** → III.4.3 |
| **N-9** | 13:11:01 | `live 3041` | „**Ein Ausschluss loest die Wurzel des Problems NICHT, das ist verboten.**" | Mittags der stille **Ausschluss**, nachts der stille **Rueckfall** (KERN 10) — elf Stunden auseinander, dieselbe Doktrin. Fuehrte zum Wurzelschnitt `dcb2f08f`. → III.1.2, III.6.5 |
| **N-10** | 11:15:10 | `live 2155` | „Es existiert kein CSV Lager. xlsx ist default. Und ich lese nichts ueber den Planer, CEB und die Tier-Binaries in **aufeinander aufbauenden Vertraegen**" | Fordert die Beschreibungssprache ein, in der Kapitel I geschrieben ist: **Vertraege, nicht Pipeline.** → I.1 |
| **N-11** | 11:27:10 | — | „…du [hast] in den Layern **Gattung und Genus** nicht korrekt einsortiert … **Das ist ein vierter Layer der Observer Stufe im Vertrag zwischen CEB und Tier-Binary!**" | Bau-Posten **B-10**, Klasse TIER: 524.288 Neubauten. Owner-Entscheid: erste oder zweite Bau-Kampagne. → IV.3.3 |
| **N-12** | 21:05:18 | `bak 2533` / `live 6499` | „Hattest du gruendlich alle workflow Ergebnisse aus dem letzten Kontext im Backup gelesen und **Anknuepfungspunkte zu den aktuellen Aufgaben** daraus verglichen?" | Nein — daraus **Regel-Zeile 16**. Und 65 Minuten spaeter dieselbe Frage erneut (`live 8014`, 23:59:11Z), die dieses Gesamt-Dossier ausloeste. → III.5.5 |
| **N-13** | 20:32:48 | `bak 2203` | „Bitte **erst kopieren und dann Geheimnispruefung**, der Kontext reihct nciht" | Die Reihenfolge — erst sichern, dann pruefen — ist der einzige Grund, warum 776 Runner-Tokens ueberhaupt gefunden wurden. → III.2.2 |
| **N-14** | 23:47:31 | `live 7889` | „**der best_binary_selector hat eigentlich ganz andere Aufgaben, und zwar die messwerte nehmen und die Orchestration der Auswahl und Berechnung ueber das Lager durchfuehren.** … Dann gerne Rueckfragen um die Planung zu vervollstaendigen, **weil diese Plaene 6 Wochen alt sind**" | Rollen-Korrektur **und** befristete Aufhebung der Dauerregel „keine Unklarheiten, nur Gedaechtnisluecken" fuer diesen Bereich. Die sechs daraufhin gestellten Rueckfragen sind **alle unbeantwortet**. → II.6, V.6.2 |
| **N-15** | 22:44:53 | `bak 3463` | „Bitte handout mit commit und push an den infra Agenten fuer rotationen, keys und allgemeine infra Probleme. **Das ist nicht mehr dein Problem.**" | Die Token-Rotation ist abgegeben (I113, 188 Z., super `cc431b01`) und dort **unerledigt**. → III.2.2 |
| **N-16** | 18:36:46 | — | „starte einen Explore dazu, ob du nicht selbst die Antworten im Plan findest. **Stelle dann tatsaechlich nur Fragen, die du nicht gefunden hast**" | Der Auftrag, dem die elf Praemissen-Zurueckweisungen ihre Oekonomie verdanken: *„Netto aus diesem Scope vor der Abgabe: kein Bau-Paket."* → IV.6.15 |

---

## ANHANG — DIE DOKUMENTEN-LANDKARTE

**Damit niemand sucht.** Alle Zeilenzahlen am 07.08.2026 gemessen (`wc -l`), alle Pfade absolut oder repo-relativ mit genanntem Repo. `<super>` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine` · `<ce>` = `<super>/Code/external/comdare-cache-engine` · `<thesis>` = `<super>/thesis/diplomarbeit`.

### A.1 Die Erzeugnisse dieser Session — wo welches Detail steht

| Dokument | Zeilen | Was **nur dort** steht | Kapitel, das darauf verweist |
|---|---:|---|---|
| `<super>/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` | **7248** | **SSOT.** Nachtrag **abend-4** ab `:4202` = die zwoelf Architektur-KERNe in ihrer ersten Konsolidierung; abend-1..3 = Regel-Zeilen 15–18, die drei stillen Nullen, die sechs Landungen; §57 `:3095-3100` Kettengesetz; §30 `:2261`; §64 `:3403`; §32-F8 `:2296/:2301` Break-Even-Mathematik; §75 `:3602` Schutzflaechen; `:4082/:4090/:4095` Stufen-Doktrin mittag-9/-10/-11 | alle |
| `<super>/docs/sessions/20260806-DOSSIER-regressionen-checkheft.md` | **2486** | Die Posten **N-1..N-AE, NS-1..NS-3, SW-1..SW-4, Z-1..Z-8, P-1..P-3** mit Termin-Klassen T1–T4; die zwanzig Regeln R-1..R-20 im Volltext | III (Fehlerklassen), IV.5 |
| `<super>/docs/sessions/20260806-UEBERBLICK-workflow-ergebnisse.md` | **677** | §3.2 die 50 „gebaut-ungelandet"-SHAs · §4.1 Widersprueche **W-1..W-21** · §4.2 die **zwanzig Selbstkorrekturen mit Bericht-ID** · §4.3 Codex-Kipp-Zaehler · §J die ~27 Owner-Entscheid-Kennungen | III.7, V.6 |
| `<super>/docs/sessions/20260806-ANKNUEPFPUNKTE-vorarbeit-je-aufgabe.md` | **1350** | **Vorarbeit je Aufgabe**, mit den Widerspruechen zuoberst — die Datei, deren Nichtlesen Regel-Zeile 16 ausloeste | III.5.5 |
| `<super>/docs/plaene/20260806-KANON-termine-plan-soll-gegen-ist.md` | **894** | Der **Betreuer-Korpus**: 11 Termine, 309 Dateien; Forschungsfrage, H1–H4, die Hybrid-Regel seit 09.04., Risikotabellen mit Gegenmassnahmen, `HybridCorePinning`-Entwurf; **Plan B** der Wochenplanung | I.4.2, II.4, V.2, V.5.2 |
| `<super>/docs/plaene/20260806-DIFF-thesis-soll-gegen-ledger-und-code.md` | **863** | **F-01..F-12** einzeln mit Fundstelle und beiden Wegen · **M-01..M-12** messdatenabhaengige Aussagen · die **40 Entlastungen E-01..E-40** · die **23 `§63-T-*`-Ledger-Zeilen** · die `.fls`-Methode · **Plan A** der Wochenplanung | V.1, V.3, V.4, V.5.2 |
| `<super>/docs/plaene/20260806-PLAN-warnungen-und-ausgabe-bei-messfehlern.md` | **848** | Die **Zustands-Leiter** im Volltext, Anschluss an `axis_error.hpp`, Schwere-Stufen je Fehlerklasse | I.6, III.9 |
| `<super>/docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md` | **825** | Break-Even-Mathematik ausgeschrieben, die drei Ebenen mit allen Nennern, Abschnitte 1–9 | II |
| `<super>/docs/plaene/20260806-KLAERUNG-zweiphasig-dreiphasig-drei-typen.md` | **632** | **Phase gegen Stufe**, Kollisionskarte, alle Nullbefunde mit Gegenprobe | I.3 |
| `<super>/docs/plaene/20260806-DOSSIER-messachse-wallclock-und-mess-kette.md` | **436** | Die volle **Matrix Tooling × Ebene** (§2/§3), drei harte Negativ-Befunde, §8.1 die M-1-Zuordnungs-Empfehlung | I.7 |
| `<super>/docs/plaene/20260806-PLAN-hybrid-pmc-numa-core-permutation.md` | **1025** | Permutations-Mechanik, **Kostenrechnung §7.3**, Bau-Reihenfolge B-5..B-7 im Detail | I.5.4, IV.3.3 |
| `<super>/docs/plaene/20260806-PLAN-messkette-ceb-observabletier.md` | **1019** | **M-1..M-6**, die **Neubau-Bilanz §3** (die drei Klassen), Zeitplan §4, Owner-Entscheide §5, ObservableTier-Audit | IV.3.1, IV.4.1 |
| `<super>/docs/infra/I113_RUNNER_TOKEN_ROTATION_UND_INFRA_RESTPOSTEN.md` | **188** | Die an Infra abgegebenen Posten, inkl. **P-6 `amd_l3`-Uncore-PMU nicht geladen** | III.2.2, IV.3.3/B-9 |
| `<super>/docs/sessions/20260806-PAUSE-abbruchsicher-nachts-nach-architektur-konsolidierung.md` | **175** | **Der ERST-ANKER** fuer den Wiederanlauf. `:123-124` traegt die Wallclock-**Verortung**, die im Ledger fehlt | I.7.1 |

### A.2 🔴 Die vier Bestaende, die **nur an einer Stelle** existieren

Sie sind der Grund, warum IV.5.1 die Posten S-2 bis S-4 als SOFORT fuehrt.

| Bestand | Umfang | Zustand |
|---|---:|---|
| `<super>/docs/plaene/20260806-ANWEISUNG-pmc-intel-perf-rechte.md` | 622 Z. | zum 00:20-Messstand **untracked**, seit super `1aba34f8` (00:30:30 Z) versioniert (auf `development` + `main`). Beruft sich auf die ce-Laeufe 15104/15110 und die Jobs 365186/365187/365256/365257 |
| `<super>/docs/plaene/20260806-PLAN-hybrid-architektur-pmc-achsen-zuordnung.md` | 1043 Z. | zum 00:20-Messstand **untracked**, seit super `1aba34f8` (00:30:30 Z) versioniert |
| `<super>/docs/plaene/20260806-PLAN-messkurven-synthese-und-hybrid-binary.md` | 768 Z. | zum 00:20-Messstand **untracked**, seit super `1aba34f8` (00:30:30 Z) versioniert. Primaermaterial fuer Kapitel II und V |
| `<super>/Code/test_data_xml/experiment_schema.xsd` (Delta) | +24 Z. | **uncommittet**, kein rescue-Ref, keine zweite Kopie. Die super-Haelfte von OD-11-RT |
| `<super>/Code/measure_out_d03/` | 66 Dateien, 3.651.143 B | **untracked und nirgends gesichert**; von der `.gitignore` strukturell verschluckt |

### A.3 Die Rohquellen

| Quelle | Umfang | Wofuer |
|---|---:|---|
| `/home/comdare/.claude/projects/-home-comdare/5a19728e-…/subagents/workflows/*/journal.jsonl` | **86 Journale, 265 `result`-Ereignisse, 4,29 MB** | **Die ergiebigste Quelle.** Jedes `result` traegt den vollen Agenten-Bericht einer Welle: Rohbefunde, Gegenproben, Selbstkorrekturen, Nenner. Lesen: je Zeile ein JSON, `type=="result"` filtern, Feld `result` nehmen; Ordnername = Wellen-Kennung, `label` = Agent. **Signal-Nachzaehlung: 101 von 265 Ereignissen enthalten Selbstkorrektur- oder Praemissen-Marker** (`grep -iEc` mit dem ASCII-Muster ueber die `result`-Zeilen; Umlaut-Varianten: 108) |
| `<super>/docs/sessions/backups/20260806-session-transkript-verbatim/session-ab-vorletzter-kompaktierung.jsonl` | 3847 Z. | **Wortlaut-Quelle** der `bak`-Fundstellen. Deckt **43 von 104** Owner-Nachrichten; enthaelt die `queue-operation`-Datensaetze **mit** |
| `/home/comdare/.claude/projects/-home-comdare/5a19728e-f6e1-4736-a246-e3fda9ac35a1.jsonl` | 8070 Z. | Vollspanne, Quelle der `live`-Fundstellen. **1.524 `user`-Datensaetze, davon 106 nach dem kanonischen Filter — acht der zwoelf KERNe liegen ausserhalb** |
| `<super>/docs/sessions/backups/20260806-workflow-rohdaten/` | 269 outputs + 63 Journale | Im Repo gesichert (`2a6f35d8`), **1 Datei redigiert** |
| `/home/comdare/backups-workflow/` | u. a. `QUARANTAENE/bnpj776mm.output` (479.544 B, Modus 0600), `20260806-pause-wip/pmc-l3-honest-WIP.patch` (18.294 B), `20260806-session-transkript/session-5a19728e-ROH.jsonl` | Ausserhalb des Repos. Der WIP-Patch ist seit `c4c04315` **gelandet** und damit historisch |
| `<super>/docs/termine/` | **11 Termine, 309 Dateien** (117 .md, 80 .txt, 27 .docx, 11 .pptx, 8 .drawio, 61 .jpg, 5 .py) | Rang 3 der Quellen-Rangfolge: **Historie und Herkunft**. **`INDEX.md` endet bei Termin 8 — wer ihm folgt, liest die drei juengsten Termine nicht** (Entscheid T-6) |

### A.4 Die Code-Orte, die dieses Werk laufend zitiert

| Ort (in `<ce>`) | Was dort steht |
|---|---|
| `libs/cache_engine/include/cache_engine/measurement/system_axis_registry.xml` | `:10` `target_isa` mit `binary_id="never"` · `:38` `numa_node` als RT-Unterachse · `:5-7` Haupt-/Unter-Achsen-Vertrag · **generiert, nie von Hand editieren** |
| `libs/cache_engine/include/cache_engine/measurement/measurement_axis_registry.xml` | `:25-42` die drei Collector-Bausteine, PMC mit 7 Kategorien |
| `libs/cache_engine/include/cache_engine/measurement/axis_error.hpp` (655 Z.) | `SampleStatus{Ok, NotApplicable, SourceUnavailable, Failed}` · `HardwareErweiterungFehlt` (mit dem **GPU**-Beispiel des Owners seit 26.07.) · `BetriebssystemFeatureFehlt` |
| `libs/cache_engine/builder/measurement/thread_pinning.hpp` (105 Z., `wc -l` an ce `54106bc9`) | `class ScopedThreadPin`, `sched_setaffinity` `:61` / `SetThreadAffinityMask` `:47`, RAII-restore `:70-78` — **der einzige Pinning-Aktuator des Repos** |
| `libs/cache_engine/builder/linux_perf_pmc_source.hpp` | `:9-17` die Selbstkorrektur vom 06.08. · `:111-114` der frueher verworfene `errno` · `:201-207` die drei generischen Counter |
| `libs/cache_engine/include/cache_engine/measurement/pmc_source.hpp` | `:37-43` die vier Pro-Zaehler-Verfuegbarkeitsflags (`:37/:38/:39` L2/L3/coherence, `:43` energy_micro_joules; seit `5c102e05`) |
| `libs/cache_engine/heuristik/{axis_spline,break_even,measurement_curve_loader}.hpp` | Die Break-Even-Mathematik. `axis_spline.hpp:15-25` die Fritsch-Carlson-Begruendung · `break_even.hpp:10-17` Verfahren und Konvention · **§75-geschuetzt** |
| `libs/cache_engine/builder/best_binary_selector/` | `rank_binaries` (produktiv) + die **zweite, groebere** Break-Even-Implementierung (`hpp:263`, `:321-327`) |
| `libs/cache_engine/hybrid/README.md` | **Die einzige Datei der vierten Stufe.** „RESERVIERTER STUB … KEIN CODE" |
| `libs/cache_engine/include/cache_engine/abi/anatomy_fingerprint.hpp` | `:341` `kAnatomyFingerprintGliedCount = 8` · `:428-431` die Preimage-Ordnung, Mess-Zeile = **Glied [3]** |
| `libs/cache_engine/profile_facade/mess_achsen_naht.hpp` | Seit M-1 (00:06) die **vier produktiven Konsumenten** der Mess-Tooling-Achse. Kopf: *„Der Stempel log."* |
| `libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml` | `:66-84` 17 `<axis_sweep>` · `:112` `<working_set_sweep>` mit **vier** x-Werten · `:126` 6 Workloads · `:221-226` die eine Vollmengen-Combo `[all]` |
| `tests/unit/thesis_tiere/m3v2_pmc_smoke.cpp` | ce-HEAD `54106bc9`: `:12` sagt *„[ECHTES Messfenster]"*, reales Fenster `:62-69` (das leere Fenster war der Vor-Heilungs-Stand `2b5ecd29~1:41-42`, geheilt `2b5ecd29`) · `:124-126` die **hartkodierte Ursachenliste** (Anlassfall R-11; im Anlassfall-Stand `:92-95`) |
| `libs/cache_engine/profile_facade/planner/experiment_plan_director.hpp` | `:34/:39-40` INERT-by-default · `:1373` `allow_failure: true` (`:1332` = Batch-Kommentarkopf) · `:1410-1413` die ungeslicte Mess-Seite (`export COMDARE_GOLDEN_N_RANGE="0:${COMDARE_GN_TOTAL:-16}"`; `:1367-1369` ist die `rules:`-Emission) · `:2101-2102` der Perm-Walk |

| Ort (in `<super>`) | Was dort steht |
|---|---|
| `scripts/ci_diff_ascii_width_guard.sh` | `:197` FATAL statt stiller Null · `:537` die Nenner-Ausgabe — **die Wache, die ihre eigene Fehlerklasse nicht produzieren kann** |
| `ci/thesis_gitlink_parity.sh` (145 Z.) | Prueft **Gitlink gegen Gitlink**, ohne grep in der Kernlogik |
| `scripts/ci_yaml_key_guard.sh` | Schluessel-Wache gegen doppelte Job-Definitionen (last-wins) |
| `.gitlab-ci.yml` | `:79` `COMDARE_GN_TOTAL` · `:297-315` die drei Bridges auf **`branch: main`** · `:447` `contract:axis-version-lock` (jetzt einmalig, ohne `rules`) |
| `Code/05_diagram_generator/diagram_generator.hpp` | `:397-405` zeichnet genau die Kurven, die sich schneiden muessten — **niemand schneidet sie** |

| Ort (in `<thesis>`) | Was dort steht |
|---|---|
| `diplomarbeit.tex:278-285` | Die **sechs** eingebundenen Kapitel; alles andere ist keine Zusage |
| `aufgabenstellung/de.tex` / `en.tex` | Gesetzt ueber `zihpub.cls:267/883`. `:74-75` „alle erdenklichen Binary-Permutationen" · `:114` **`flat_hash_map`** · `:87-96` die drei Granularitaeten |
| `anhang/de/A_measurements.tex` | `:71`, `:78` die Doktrin-Kommentare (die zwei „ueberzaehligen" Bezeichner-Vorkommen aus W-1) · `:77-88` die honest-100%-Doktrin · **28 `\InputIfFileExists`-Eintraege** |
| `anhang/de/E_architecture_decisions.tex:140,144` | **ADR-12 Talos** — die erste der beiden Falschaussagen |
| `kapitel/de/03_messsystem_prtart.tex` | `:992` Tooling = Granularitaeten (von Kap. 4 richtiggestellt) · `:1305-1318` die drei Wallclock-Ebenen „zusaetzlich" · `:1481-1483` „erst der Keim" |
| `kapitel/de/06_fazit.tex:141-179` + `anhang/de/tabellen/le_limitierung.tex` | Die zwanzig Limitierungs-Punkte. **Talos, `flat_hash_map` und M-06 stehen in keinem davon** |

### A.5 Die Merksaetze in einem Kasten

> **Kette:** der Planer FRAGT (RT) · die CEB TRAEGT (CT) · die Tier-Binary LAEUFT.
> **Hybrid:** die P/E-Trennung ist eine PERMUTATION, kein zweiter Bau.
> **Stufe gegen Phase:** die Stufenzahl ist dehnbar (Hybrid-Einschub), die Typenzahl nicht — drei bleibt drei.
> **Fortpflanzung:** eine MESS-Aenderung baut CEB **und** Flotte neu; System/Organ nur die Tiers.
> **Break-Even:** ein Kipppunkt, kein Optimum — „ab wo ist welche besser", nicht „welche ist die beste".
> **Auswertung:** sie produziert eine **Schaltlogik**, keinen Rat.
> **Fehlerklasse:** eine korrekte Messung, die die falsche Frage beantwortet — vier Ausschnitte: **Zeit, Schreibweise, Ort, Form**. Das ist die **Hauptklasse**, nicht die vollstaendige Typologie (Checkheft VII.5 fuehrt drei Gestalten, die sie nicht abdeckt).
> **Bauform:** der stille Rueckfall. Er ist gruen. Er ist verboten.
> **Schwere:** WARN = der Wert existiert, seine Verwendbarkeit ist fraglich · ERROR = die Anforderung trifft auf eine fehlende Systemeigenschaft, **oder etwas faellt still zurueck** · FATAL = die Integritaet ist zerstoert, **Lager-Inkonsistenz gehoert hierher**.
> **Beweis:** eine Null braucht Nenner **und** Gegenprobe. Eine Anzahl ist eine Behauptung ueber das, was man nicht gesehen hat — eine **Liste** ist eine Behauptung ueber das, was man gesehen hat.
> **Werkzeug:** in dieser Session hat kein einziger Merksatz einen Fehler verhindert. Jedes Werkzeug, das den Fehler bauartbedingt nicht zulassen konnte, hat gebissen. **Auch dieser Kasten ist nur ein Merksatz.**

---

*Gesamt-Dossier erstellt am 07.08.2026, 00:20–01:37 Z (Fenster-Ende = realer letzter Inhalts-`mtime`; „02:10 Z" war Zukunft), gegen ce `c4c04315` / `2b5ecd29`, super `5a98036d` / `71591a24`, thesis `19e15920`. Alle Objekt-Aussagen dieses Werks sind entweder in den fuenf Quell-Kapiteln am Objekt erhoben oder bei der Zusammenstellung nachgemessen; die drei Widersprueche zwischen den Kapiteln sind in Abschnitt 0 mit Nachmessung gefuehrt und **nicht** geglaettet. Als **unbelegt** gefuehrt bleiben die in IV.7 aufgezaehlten zehn Punkte sowie die Gleichsetzung „drittes Glied" = Preimage-Glied [3] (I.7.4). READ-ONLY eingehalten — ausser dieser Datei wurde kein Repo-Zustand veraendert.*
