# KONTEXTÜBERGABE 08.08.2026 — Messkette, xlsx, Repo-Scope

**ERST-ANKER für den nächsten Kontext.** Dieses Dokument ist so geschrieben, dass ein Wiederanlauf
allein damit möglich ist.

| Repo | Ref | Zustand |
|---|---|---|
| **ce** `development` | **`e347d313`** | Pipelines grün |
| **super** `development` | **`fb0071e9`** | grün |
| **thesis** `development` | `798e946` | DE 204 / EN 194 Seiten |
| **cluster** | `cd7c64d` | unberührt |

---

## 1. WAS GELANDET IST

| Paket | Ref | Beleg |
|---|---|---|
| **E-E Overlay-Glied** | ce `986c0a8c` | 711 Dateien im Schnitt, 428/428, sechs Anker (drei auf Literale gezogen) |
| **`lint:static` geheilt** | ce `a2b928eb` | `development` war **zwei Pipelines lang rot** |
| **cppcheck-Gate in der Vor-Push-Wache** | ce `db6cc047` | beide Richtungen bewiesen |
| **`m64`-Medien-Basis** | ce `15522cdc` | Entscheide-Zähler 6 → 0, vier Bissbeweise |
| **SF-1 Schichtschnitt** | ce `b000ccc6` | `anatomy/` kennt kein `builder/` mehr + neue Wache |
| **CE-Namensdoppelung** | ce `e347d313` | `architektur/` → `architecture/` |
| **Thesis nachgezogen** | thesis `798e946` | 8 Lizenz-Fundorte, Flag-Grammatik v2, chktex 0 |
| **NAS vollständig** | — | drei Mounts reboot-fest, **Buildsystem-Volume 15 T frei** |
| **Wurzel aufgeräumt** | super `00c5c1cf` | `measurement/` + `Messdaten-Backup/` in die Mess-Planung |

**Sechs Ultracode-Läufe, ~110 Agenten.** Ihre Produkte liegen einzeln in `docs/plaene/` und
`docs/sessions/` (Liste unter *Wiederanlauf*).

---

## 2. DIE ARCHITEKTUR, WIE DER OWNER SIE MEINT

### 2.1 Der Experiment-B+-Baum IST die Vergleichs-Ordnung
Die statische Achsen-Reihenfolge (Mess → System → Organ) legt fest, auf welcher **Tiefe** welche Achse
sitzt. Zwei Binaries, die sich **nur in einem Knoten derselben Tiefe** unterscheiden und **denselben
Teilbaum darunter** tragen, sind ein **kontrolliertes Experiment mit genau einer unabhängigen
Variablen**. Der Vergleich ist ein **Geschwister-Vergleich bei identischem Nachfolge-Pfad** — deshalb
ist die Achsen-Sortierung keine Kosmetik, sondern die Voraussetzung fürs isolierte Messen.

**Die wissenschaftliche Frage der Arbeit:** nicht *„welche Komposition ist die beste"*, sondern
**„wäre Papers X Algorithmus für Achse A besser gewesen als der von Paper Y, bei sonst gleicher
Konfiguration?"** — je Achse einzeln, sequentiell durchpermutiert über die Paper-XMLs.

### 2.2 Der Mess-Baum — drei Ebenen (≠ Experiment-Baum)
Wurzel = Gesamtverlauf aller parallelen Achsen-Observer-Streams (`wallclock CEB root am Prüfdock`) ·
Mitte = Macro über **exakt einen** Interface-Funktionsaufruf, exponiert alle Observer-Streams seiner
Achsen · Unten = die Achsen selbst mit eingebautem Micro-Benchmarking, Checkpoint vor/nach **jedem**
Achsen-Aufruf.

**Die fünf Mess-EBENEN** (andere Achse als die drei Stufen — Stufen = *wie fein*, Ebenen = *wo der
Messpunkt sitzt*): Planer-CLI · Prüfdock Gesamt-Last · Prüfdock je Interface-Aufruf · Tier-Binary Macro ·
Tier-Binary Micro.

### 2.3 Die 6 CEBs — der Messfühler ist ein Verbraucher
**3! = 6 Varianten** mit ein-/ausgebauten Messgeräten, **vom Planer kompiliert**. Die **Differenz
zwischen „mit Fühler" und „ohne Fühler" IST der Messfehler**. Deshalb müssen die Messebenen
compile-time ausbaubar sein — nicht als Komfort.

> Owner: *„Wird nicht je Mess-Stufe mal mit und mal ohne Mess-Einrichtung gebaut, dann klappt es nicht."*

**Record-and-Replay als Mess-Vertrag:** `(Aufruf, Zeitpunkt, Zustand)` wird als Snapshot eingefangen und
**einzeln nachgespielt**, im originalen RAM-Zustand mit warmem Cache — statt alles gleichzeitig zu
messen, wobei sich die Sonden stören.

### 2.4 Release ist eine Rekonstruktions-Anfrage
> *„Wenn wir die Messwerte haben, kennen wir ja die Eigenschaften der Binary dazu und müssen diese nicht
> mehr vorhalten und können auf Anfrage gezielt nachbauen."*

**Binaries müssen nicht aufbewahrt werden.** Release = Anfrage an eine dokumentierte compare-Bibliothek
der Messwerte → perfekte Tier-/Hybrid-Binary je Ziel-Architektur rekonstruieren, ohne Messfühler nur mit
Wallclock nachmessen, **gegen die Prüfdock-Tests verifizieren**.

### 2.5 Break-Even
Kubischer **B-Spline (B=3)**, als **String serialisierbar und wieder parsbar**, erster Messwert = Basis
bei 0. **Dreimal querschneidend** berechnet: Achsen-Ebene (Micro) · Funktions-Ebene (Macro) ·
Gesamt-Ebene (combined) — **je isolierter Achsen-Permutation, also je Baum-Knoten-Tiefe**.

**Das Flattern ist das Signal, nicht die Störung:** Stufe 1 mittelt, **Stufe 2 sucht das Flattern
gezielt** — wo die beste Binary wechselt, arbeitet der Hybrid. Keine Hysterese, **Bereichs-Erkennung**.

### 2.6 Paper = ein Experiment-XML
Jedes Paper wird als eigenes Experiment **reproduziert**; die compile time stellt aus dem gesplitteten
Entwurfsmuster die **Original-Binary** wieder her, und der **PRT-ART-Prüfling wird in dieselben Achsen
eingesetzt**. *„Es gibt keine Kandidaten."*

### 2.7 Mengen NIE pauschal rechnen
> *„Rechne diese bitte NIE mehr pauschal nach"* → **`cache_engine --check-size "FILE"`**: läuft auf der
> Zielmaschine, Hardware-Erkennung, baut die CEB vorsorglich, **rechnet AUF der CEB**.

**Die Auflösung der „leeren Naht":** der Planer rechnet die **Größe** (aus der XML-Freigabe), die CEB
liefert die **Dauer** — weil die Instrumentierung **in sie einkompiliert** ist. Und weil es sechs
Varianten gibt, liefert die Befragung nebenbei **die erste Messung des Mess-Overheads**.
**`--check-size` und die Messfehler-Elimination sind dasselbe Werkzeug.**

### 2.8 xlsx ist der Standard — seit dem 26.07. als KERN=Gesetz
> *„xlsx = künftig DEFAULT, CSV einstellbar + Fallback. CSVs werden im **FACTORY PATTERN je Sheet
> einzeln** gebaut; **xlsx = EINE Datei mit EINEM Sheet je gewählter Unter-Achsen-Permutation +
> zusätzlichem INFO-Sheet** (Sysinfo + verwendete Haupt-Achsen)."*

Kanon 05.08.: *„entweder **CSV xor xlsx** … **strategy pattern**, keine chain of responsabilities."*

### 2.9 Die Repo-Grenze — über die AUSFÜHRUNG, nicht über Dokumente
> Owner 08.08.: *„**super Entscheidet mit der XML was und wie ausgewertet wird**, aber **die gesamte
> Mechanik liegt als Framework in der Cache engine samt Planer/CEB/Tier-Binaries**. Der Anwender ruft
> also die **CLI des Planers** auf, nachdem er sie per install kompiliert hat."*

Deckungsgleich mit der Fassung vom **13.05.**: *„Die Diplomarbeit bestimmt **WAS** getestet wird, die
CacheEngine bestimmt **WIE** es getestet wird."*

**Der offizielle Bauweg:** `configure.sh` / `make` / `make install` / `make check` — **alle im
Wurzelordner, in BEIDEN Repos**, plus ein bauendes CMake-Skript. `Code/tools/` sind damit **verbotene
Behelfswege**; `make check` ersetzt `run_all_tests.sh`.

---

## 3. DIE HÄRTESTEN BEFUNDE

### 3.1 Phase 3 ist nicht fertig — 6 von 16 Posten belegt
Von den zwölf Landungen des 07.08. berührten **nur zwei** die Fahrplan-Phase-3-Zeile.
**A9-S3/S4/S5 nie begonnen:** der xlsx-Weg ist **reiner Vendor ohne Schreiber** — das ist die Wurzel,
warum die Owner-Ansage „xlsx ist Standard" fünfmal folgenlos blieb.

### 3.2 Von den 6 CEBs sind heute **maximal 2** herstellbar
`mess_achsen_naht.hpp:81` sagt es selbst: *„EHRLICHE GRENZE — macro UND micro SIND HEUTE NICHT
TRENNBAR. G2 und G3 teilen sich EIN Gate … Ein solches Gate hier zu ERFINDEN hieße, Semantik zu
behaupten, die der Code nicht trägt."* **Das Herauslösen von G3 ist ein benanntes Folgepaket** und
berührt `abi_adapter.hpp` im Hot-Path. **`wallclock` ist gar nicht ausbaubar.**
**Kein Versäumnis, sondern ein bewusst benannter Rückstand.** Der F-3-Kommentar im golden-Profil steht
**nicht** dagegen — *„getrennt/Teilmengen bleibt XML-Recht"*.

### 3.3 Der Scope-Bruch ist am CE-Quellcode belegt
**12 Stellen** in der CE nennen `super docs/` als *„QUELLE (bindend)"* — **10 davon sind in einem
CE-Only-Klon nicht auflösbar.** Bissbeweis: `heuristik/break_even.hpp:27` zitiert eine Quelle, deren
entscheidende Spalte **„Optimum hängt ab von" nicht übertragen wurde** (gemessen: `haengt ab` 0,
`Zipf` 0, `Fuellstand` 0; Gegenprobe `CatalogAxis` 94 — die Suche ist nicht stumm). **Genau diese
Spalte ist der Break-Even.**

### 3.4 Nicht ungetrackt — sondern ohne Eintrittspunkt
Die Owner-Sorge „Doku nicht getrackt" traf **nicht** zu (3047 Dateien, 0 ungetrackt nach `a15a74a0`).
**Der echte Befund ist größer:** `docs/INDEX.md` (Umbrella, Stand **15.05.**) nennt `plaene`
**0 Mal** — 119 Plandokumente sind aus dem Index unsichtbar. Der CE-Index (Stand **08.05.**)
verschweigt **99 von 160** eigenen Dateien. Ein `docs/plaene/INDEX.md` existiert in **keinem** Repo.

### 3.5 Die CE hat kein docs-only-Gate
`changes:`/`docs-only` — Umbrella **30**, CE **0**. Jeder Doku-Commit in der CE zieht die **volle**
Pipeline auf dem Runner, der auf dieser Platte liegt.

---

## 4. WAS LÄUFT

| Vorgang | Zustand |
|---|---|
| **A9-S3 xlsx-Writer** (Bau) | Factory · Xlsx-/Csv-Mappe · `ErgebnisSchreibFehler` · 31-Zeichen-Wache · INFO-Sheet · `WritebackMethod::Xlsx`. **Abnahme = Erstbeleg**: echte xlsx aus dem 26.07.-Archiv, Sheets zählen, Zelle zurücklesen |

**Bewusst NICHT gebaut:** die Zeitreihen-/Chart-Form fürs Mess-Profil (Owner-Fassung 3) — dazu ist die
Blattform-Frage offen, und Raten hat hier schon genug gekostet.

---

## 5. WAS BEIM OWNER LIEGT

1. ~~Blattform fuers Mess-Profil~~ — **BEANTWORTET am 08.08.**, siehe Ledger-Nachtrag *OWNER-ENTSCHEID:
   DIE BLATTFORM*. Kurz: **ein Sheet je FUNKTION (Macro) bzw. je ACHSE (Micro), die Aufrufe werden
   ZEILEN** mit den Spalten *Aufrufer* und *Zeitpunkt*; darüber **ein compare-Sheet je
   Last-Messungs-Rekombination**. Blattzahl = `1 + |Funktionen| + |Achsen|` — fest, nicht mit der
   Lauflänge wachsend. Verbunden über **interne Hyperlinks** zum Hinabsteigen. CSV bleibt flach, mit der
   **Ebene anführend** und dem **Zeitraum parsebar** im Namen.
   **Zwei Folgen, die über die Blattform hinausgehen:** die Mess-Ebenen **sind** das Stack-Aufrufmuster
   der drei Layer — die Spalte *Aufrufer* ist die Stack-Kante —, und die **Gattungs-Interface-Ebene muss
   separat über Macro gemessen werden**: sie verbindet die Achsen-Aufrufe, überwacht sie aber nicht. Ihr
   Anteil ist *Macro-Gesamt minus Summe der Micros*. **Wer Macro aus den Micros errechnet, verliert genau
   diesen Anteil und schreibt ihn fälschlich den Achsen zu.**
   **NACHTRAG desselben Tages** (Ledger N-1..N-7): der *Aufrufer* ist **kein Name, sondern ein Paar —
   ein Prozess UND einer seiner Threads**. Der Thread ist systemisch ein **Visitor** über alle
   Mess-Ebenen und bewegt sich immer von einer höheren Stufe in eine tiefere und **auf dem Stack sauber
   zurück**. Je Aufruf gibt es **zwei Checkpoints: IN** (Interface-enter) und **OUT** (return) — als
   **zwei Zeilen**, denn eine Zeile je *abgeschlossenem* Aufruf würde einen nie zurückkehrenden Aufruf
   gar nicht erst schreiben, und **genau der ist die Regression**, die erkannt werden soll: *„Wenn ein
   Thread ein Interface betritt, aber es nicht wieder verlässt, ist das eine Regression."* Mehrere
   Threads schreiben **eingedampft ins selbe Blatt** (die Blattzahl bleibt fest), müssen aber beim Lesen
   **je Thread zerlegbar** sein — Thread-Kennung und Zeitpunkt gehören deshalb in **jede** Zeile.
   Und die schärfste Ortsangabe bisher: **die compare-Ebene liegt IN DER CEB, noch vor dem Prüfdock**;
   die CEB — genauer einer ihrer Threads — ist am Prüfdock der Aufrufende einer
   Tier-Binary-Interface-Funktion. Damit ist die Aufrufer-Kette geschlossen.
2. **Ledger §75** — Zustand des V32-Aufräumpasses (*„kritisch halb fertig"*), Explore beauftragt, noch
   nicht gelaufen.
3. **Der Sortier-Vollzug** — das Konsolidierungs-Dossier liegt vor (253 Dokumente zugeordnet, 115 nach
   CE), aber **alle drei Pläne fielen adversarisch durch** (0/3, 1/3, 1/3). Vor dem Vollzug lesen.

**Erledigt und nicht mehr offen:** NFS-Export bleibt weit (alle Maschinen bedienen die Lagerhaltung,
Sync per File, V60-Runner sollen mounten) · LGPL (Habich hat freigegeben) · `mmx` bleibt deklariert
(RISC-V) · Bau-Menge folgt dem angeforderten Algorithmus · Ebenen-Zuordnung per **tree-fold** ·
`Code/external/20260931-overleaf-diplomarbeit` **bleibt** (Sync-Vertrag für CI **und** netzloses Lokal) ·
`tier150_measurements.csv` **archivieren** (veraltet, Gesamtstrang wird neu gemessen).

---

## 6. MEINE FEHLER — als Muster, nicht als Liste

Das Gesamt-Dossier über sechs Kontext-Fenster (360 Owner-Nachrichten, 79 Paare) fand **vierzehn**
Fälle, in denen ich fragte, obwohl es beantwortet war. Der gemeinsame Nenner ist **nicht** die Frage:

> *„der Lead hat den Session-Log nicht gelesen, bevor er gefragt hat, und hat statt einer Recherche eine
> **Empfehlung** vorgelegt. In vier Fällen war die Empfehlung sachlich falsch. **Die Kosten sind nicht
> die Frage, sondern die Empfehlung: der Owner musste jedes Mal nicht nur antworten, sondern
> korrigieren.**"*

**Ein Werkzeugfehler erklärt einen Teil davon:** meine Memory führte *„`queued_command.prompt` existiert
seit 06.08. nicht mehr"* — **falsch**, nachgezählt 252 bzw. 1083 Treffer. **Rund 40 Owner-Nachrichten**
kamen über diesen Pfad, darunter *„Es ist IMMER alles geplant"*. Korrigiert und gebucht.

**Die Fehlerklasse, die sich heute am häufigsten wiederholte: nicht zu Ende gelesen.**
- Der F-3-Alarm fiel, weil ich den **Halbsatz nach dem Semikolon** nicht las (*„getrennt bleibt
  XML-Recht"*).
- Die „Namenskollision" war ein **dokumentiertes Design** — 14 Zeilen Begründung standen daneben.
- Zwei „Doktrin-Verstöße" lösten sich beim Lesen der **ersten vier Zeilen** auf (beide trugen längst
  Marker).
- `git describe`-Suffix als Datum gelesen (`…-20260603-…` war ein Commit von **heute 11:53**).
- Mein eigener `pgrep` fand **sich selbst** — die Regel steht wörtlich in meiner Memory.

**Weitere, alle am Objekt gefangen:** pauschal gerechnet statt ein Werkzeug zu bauen · die halbe
cppcheck-Heilung (Suppression vor dem `#if` statt vor dem `#error`, **und** nur die erste von zwei
Stellen) · **dreimal einen stummen Köder** gebaut (K13: der Köder muss **erst gegen das Werkzeug**
beißen, dann gegen die Wache) · `rc=$?` nach einer Pipe · zwei Agenten auf einen 14 Commits alten
Checkout · ein Vault-Klartextwert ins Transkript (an Infra gemeldet).

---

## 7. WIEDERANLAUF

1. **Dieses Dokument**, Abschnitt 2 (Architektur) und 5 (was offen ist).
2. `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — **die Nachträge vom 08.08.** tragen alle
   Owner-KERNe im Wortlaut.
3. `docs/sessions/20260808-GESAMT-DOSSIER-owner-fragen-und-antworten-sechs-kontexte.md` — 79
   Frage-Antwort-Paare, Direktiven nach Reichweite, die vierzehn doppelt gestellten Fragen.
4. `docs/plaene/20260808-GESAMTBILD-vergessene-arbeit-und-neuer-wellenplan.md` — Phasen 2/3/4 Posten für
   Posten am Objekt.
5. `docs/plaene/20260808-BERICHT-check-size-messkette-break-even.md` — `--check-size`-Entwurf, beide
   Break-Even-Implementierungen gegenübergestellt.
6. `docs/plaene/20260808-KONSOLIDIERUNG-umbrella-gegen-cache-engine.md` — die Scope-Grenze mit dem
   operativen Test.
7. `docs/architektur/measurement/README.md` — der Erstbeleg und der PDF-Export-Prototyp, eingeordnet.
8. `docs/sessions/20260808-SESSION-messkette-paper-xml-und-die-vier-ultracode-laeufe.md` — der Verlauf.

**Die Regel über allem** (Owner, 07.08. nachts): *„**Es ist IMMER alles geplant** und du leidest bei
nicht auflösbaren Fragen an einer ultracode explore Gedächtnislücke, die du selbst recherchierst."*
Erst suchen — 4 bis 6 Wochen, **beide** Transkript-Pfade — dann fragen. Und wenn gefragt wird:
**die Frage stellen, nicht die Empfehlung.**

**Der Stand in einem Satz:** die Maschinerie steht und ist grün, aber **es wurde noch nie eine einzige
Binary gemessen**. Phase 5 (Trigger-Sequenz) ist als **autonom** markiert und hat nicht begonnen;
Phase 6 (Messung) ist der **USER-GO-STOPP**.
