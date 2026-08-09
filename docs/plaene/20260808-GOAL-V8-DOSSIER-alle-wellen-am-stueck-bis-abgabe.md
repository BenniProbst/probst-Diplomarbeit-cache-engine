# GOAL v8 — ALLE WELLEN AM STÜCK BIS ZUR ABGABE

> **Version:** v8 · **Gesetzt:** 08.08.2026 abends · **Gültig bis:** 15.09.2026 (Abgabe)
> **Status:** AKTIV — supersedet v1…v6 vollständig
> **Autorität:** Owner-KERN 08.08.2026, wörtlich: *„direktes blanko volles GO alle zukünftigen
> Phasen autonom abzuarbeiten…wirklich ALLE am Stück"*

---

## VERSIONSHISTORIE UND ABLÖSUNG

| Version | Zeitraum | Gegenstand | Status |
|---|---|---|---|
| v1–v2 | 31.05.–05.06. | Maschinerie-Grundlagen, Permutations-Baum, Matrix-Grundlagen | **abgelöst** |
| v3 | 27.06.–08.07. | Drift/CI-Wins, strikt-grün, AP-Strecke, Opus-4.8-Strecke | **abgelöst** |
| v4–v5 | 06.–07. | Zwischenfassungen der Matrix-/Audit-Strecke | **abgelöst** |
| v6 | 02.06.–13.06. | Phase E, Cross-ABI, Lücken-Ledger, autonome Abarbeitung | **abgelöst** |
| **v8** | **08.08.–15.09.** | **Alle Wellen am Stück bis zur Abgabe** | **AKTIV** |

*v7 wurde nie vergeben — die Belege dafür sind Substring-Zufälle. Die Zählung springt bewusst,
damit v8 unverwechselbar über allen Vorgängern steht.*

**Was diese Fassung anders macht als alle Vorgänger:** Die früheren Goals beschrieben Bau-Strecken.
v8 beschreibt zusätzlich, **woran man erkennt, dass eine Aussage über den Bau stimmt** — weil die
teuersten Fehler dieses Projekts nicht im Bau entstanden, sondern in der Berichterstattung darüber.
Am 08.08. wurden fünf blockierende Defekte gefunden; **dreimal war der Test selbst der Defekt**, und
von 40 geprüften Widerrufen fielen **13 selbst**. Ein Goal, das das nicht adressiert, adressiert das
teuerste Problem nicht.

**Vorgänger nicht löschen** — Doku wird nur deprecatet (Hausdoktrin). Sie bleiben als Historie
lesbar; sie sind nur nicht mehr die geltende Fassung.

---

# TEIL I — DER AUFTRAG

## I.1 In einem Satz

Arbeite den Wellenplan v2 von W-1 bis W5 **am Stück und autonom** ab, liefere an jedem der fünf
Freitage einen für sich stehenden Stand, und gib am 15.09.2026 eine Diplomarbeit ab, deren jede
ausgewiesene Zahl von einer Messung gedeckt ist, **die älter ist als der Satz, der sie behauptet.**

## I.2 Die drei bindenden Dokumente

| Rolle | Dokument |
|---|---|
| **Was gebaut wird** | `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md` — **inkl. §11 (Erkenntnis-Konsolidierung) und §12 (Test-Kritik eingearbeitet)** |
| **Wie geprüft wird** | `docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md` |
| **Wie gearbeitet wird** | `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` v3.1 |

Dazu als Stand-Quelle: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` (Nachträge **oben**, per
`scripts/ledger_nachtrag.sh`).

Und als Erfahrungsgrundlage: `docs/sessions/20260808-SESSION-ERKENNTNISSE-widerlegte-befunde-und-learnings.md`.

**Der TDD-Vertrag T-1…T-9 ist über §12 in den Wellenplan eingearbeitet und damit bindend** — er
ergänzt V-1…V-7 um die Testseite und wird bei jeder Wellen-Abnahme mitgeprüft. §12.5 weist den
Kapazitätskonflikt offen aus: **W1 trägt 99 h Band A auf einer Woche, die schon voll ist.**

## I.3 Der Rahmen — nicht verhandelbar

**Frist.** Endtermin **Dienstag 15.09.2026**. Lieferung **freitags**: 14.08. · 21.08. · 28.08. ·
04.09. · 11.09. **Jeder Freitag steht allein** — nach jedem muss ein abgabefähiger Stand existieren,
auch wenn danach alles abbricht.

**Eigentum.** Thesis = Benjamin-Elias Probst **privat**. CacheEngine / PRT-ART / super = **BEP
Venture UG, Marke Comdare**. Zwei Rechtsträger; Lizenzen und Copyright niemals vermengen, die
Comdare-Lizenz nie eigenmächtig setzen.

**Zwei Bleche, ein Lager.** *(Fassung 09.08.2026 — sie ersetzt die ursprüngliche „Ein Blech"-Regel,
deren Begründung am Objekt widerlegt und deren Deutung vom Owner richtiggestellt wurde.)*

Es gibt **zwei** bare-metal-Runner: **id=16 = prod1** (AMD Zen 5, uniform, L3-asymmetrisch, **mit**
AVX-512) und **id=17 = prod2** (Intel Alder Lake, hybrid P/E-Cores, **ohne** AVX-512). **45 von 51 tag-tragenden
Jobs beider Repos** tragen nur `tags:[baremetal]` *(Zahl korrigiert 09.08. spaet — 44/48 war falsch;
Verfahren im Ledger-Nachtrag „Lagerhaltung und AVX-Maximum“)* und landen auf beiden. Belegt an Pipeline `15412`:
`test:coverage-guard` lief auf prod2 (`== Host ==`: `Linux prod2`, `GenuineIntel`, i9-12900K) und
meldete vier AVX-512-gegatete Tests als unsichtbar. prod1 ist zugleich die lokale Maschine; der
Runner liegt auf derselben Platte.

**Das Floaten ist der Entwurf, nicht sein Fehlen.** Owner, wörtlich: *„das war so geplant, dass über
das Lager die Maschinen abstimmen, wer welches Batch verarbeitet und es können auch erstmal alle
Maschinen alle Jobs aufnehmen."* Die Koordination sitzt im **Lager** und in der **Filterung der
Compiles je Hardware-Freigabe** — siehe das Kettenglied *Hardware-Job-Pool* in §VI.1 —, nicht in
GitLab-Tags. Ein fehlender Tag-Pin ist deshalb **kein Befund**.

**Was daraus für den Betrieb folgt, in drei Sätzen:**
1. **Pipeline-Abnahmen bleiben seriell** — aber als *meine* Arbeitsdisziplin (ich kann nur eine
   Abnahme zur Zeit beurteilen), nicht als Maschinen-Kapazitätsaussage.
2. **Jede Wache, die ihren Nenner aus der Hardware zieht, muss die Maschine mit ausweisen.**
   »457 sichtbar« ohne »auf prod2« ist eine Zahl ohne Gegenstand. Werkzeug dafür existiert:
   `scripts/ci_host_klassen_bericht.sh`.
3. **Die beiden Mess-Jobs sind echt gepinnt** (`tags:[prod, baremetal, amd]`, `.gitlab-ci.yml`
   :923 und :1015) — Messdaten können nicht zwischen CPUs floaten. Das ist die Stelle, an der der
   Schaden unheilbar gewesen wäre.

Volltext und Fehlerklasse: Ledger, „RICHTIGSTELLUNG 09.08.2026 — der Befund hält, meine Deutung
nicht".

**Autonomie.** Phasengrenzen sind **kein** Haltepunkt. Standardzustand ist Weiterarbeiten.
**Melden ≠ fragen** — Vollzüge werden gemeldet, ohne auf Antwort zu warten.

**Rückfrage nur bei** (a) nicht billig rücknehmbarem Schaden oder (b) teurem Umbau — beides mit dem
Recherche-Weg, der schon gegangen wurde. Ein **Defekt** ist nie ein Grund zu fragen: *„wenn es einen
Defekt gibt, egal wie groß, muss er behoben werden."*

**Eine nicht auflösbare Frage ist zuerst eine eigene Gedächtnislücke, kein Owner-Entscheid.** Erst
vier bis sechs Wochen Bestand durchsuchen — Ledger, Sessions, Backups, Code —, dann vorlegen.

---

# TEIL II — DIE ARBEITSWEISE

Führende Fassung: `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` v3.1 (552 Zeilen). Sie gilt vollständig.
Die folgenden Punkte sind die, an denen in dieser Woche nachweislich Arbeit verloren ging.

## II.1 A2.0 — Die Reihenfolge ist selbst eine Regel

**Gedächtnis → Review → Explore → Design → Bauen → Verify.**

Kein Agentenstart ohne vorausgehenden Gedächtnis-Befund. Der Befund ist entweder eine Fundstelle
oder der ausdrückliche Satz *„GEDÄCHTNIS GEPRÜFT, KEIN TREFFER: `<suchmuster>`"*. Ein Explore für
Dokumentiertes ist ein Arbeitsfehler.

**Warum sie zuerst fällt** — am Objekt gemessen: *„die zuerst fallende Stufe ist das Gedächtnis,
weil sie vorne kostet und hinten nichts Sichtbares liefert, während ein Explore-Agent wie
Fortschritt aussieht."*

### II.1a Der Explore ist Pflicht — je Welle und je Strang *(Owner 09.08.2026)*

Owner-Wortlaut, als Präzisierung dieses Auftrags:

> „…einen Sonnet 5 max effort »very thourough« explore über die letzten 9 Wochen **(gilt auch für
> die Planung jeder Welle und jedes Strangs in der Explore Phase, die vor jeder Design und
> Bau-Phase Pflicht ist)** an session-log/Planung/sessions/memory/code/alles, um exakt
> herauszufinden was in der Vergangenheit zu deinem fehlenden Thema geplant war. Fahre auch immer
> einen Explore wenn du sonst raten müsstest - **rate NIE.**"

Damit ist der Explore **keine Notmaßnahme bei Unklarheit mehr, sondern eine unüberspringbare
Stufe**: kein Design und kein Bau ohne vorgeschalteten Explore — **auch dann nicht, wenn der Plan
eindeutig scheint.** Gerade dann, denn ein eindeutiger Plan verdeckt die Frage, worauf er beruht.

**Korpus:** neun Wochen zurück, über **`session-log` (die rohen JSONL-Transkripte, nicht nur
`docs/sessions/`)** · `docs/plaene/` · `docs/sessions/` · das Memory-Verzeichnis · den **Code**
beider Repos · die **Thesis** — „alles".
**Modell:** Sonnet 5, max effort, Auftrag wörtlich *„very thorough"*.

**Drei Regeln, ohne die die Stufe nichts wert ist:**
1. Die Leitfrage lautet **„was wurde dazu festgelegt?"**, nicht „wie baue ich das?".
2. **Jeder Nichtfund braucht eine Gegenprobe** — ein Muster, das sicher trifft, mit Trefferzahl.
   Ohne sie ist ein Nichtfund von einem kaputten Kommando nicht zu unterscheiden. Genau diese
   Verwechslung hat schon zweimal einen falschen Befund erzeugt.
3. Findet der Explore **gar nichts**, ist die Festlegung **neu** und wird als neu protokolliert —
   damit sie später nicht als „war schon immer so" durchgeht.

**Der Anlass:** am 09.08. startete der Lead zwei Bau-Stränge, deren Annahmen allein aus **einem
einzigen Dokument** stammten. Unmittelbar davor war bereits eine Fehldeutung entstanden, weil eine
vorhandene Owner-Festlegung nicht gesucht worden war. Bei Widerspruch gilt die Rangfolge
**OWNER > PLAN > THESIS** *(Fassung 09.08.2026 — sie ersetzt die zuvor hier stehende, falsche
Ordnung „THESIS > OWNER > PLAN")*, innerhalb derselben Stufe **neuer schlägt alt**. Ein Plan kann
also von etwas Älterem geschlagen werden, und wer nur den Plan liest, sieht das nie.

**Aber die Rangordnung ist Stufe 3, nicht Stufe 1.** Owner wörtlich: *„Bei Konflikt gilt in der
Regel diese Rangordnung, oder wo **mehr Gründlichkeit** erreicht werden kann, ein **merge zweiter
Eigenschaften**. Die Frage ist auch immer, **ob sich das eine mit dem anderen ausschließt**.
**Thesis entsprechend Plan und Owner nachziehen ist erlaubt.**"* Daraus die Prüffolge:

1. **Schließt es sich überhaupt aus?** Zwei Aussagen über **verschiedene Schichten** widersprechen
   sich nicht, auch wenn sie dasselbe Wort benutzen.
2. **Lässt sich mehr Gründlichkeit erreichen?** Dann wird **gemergt**, nicht verdrängt.
3. **Erst dann** die Rangordnung.

**Die Thesis steht unten und wird nachgezogen** — sie ist die *Beschreibung* des Baus, nicht das
Gesetz darüber. Eine Thesis-Stelle blockiert deshalb **nie** einen Bau; sie ist Kandidat für
Nachzug oder Merge. Präsens-Zusagen bleiben trotzdem ernst: wird nicht gebaut, **muss** der Text
nachgezogen werden, sonst steht am 15.09. eine Behauptung ohne Deckung im Dokument.

## II.2 V11 — Die Belegzeile, in beide Richtungen

**Die Messung muss älter sein als der Satz.** Eine Messung, die *nach* der Aussage erfolgt, ist eine
**Korrektur**, kein Beleg. Belegt: **6 von 6** Selbstwiderlegungen kamen, nachdem die falsche
Aussage bereits beim Owner oder einem Agenten war; wo die Messung vorher lief, fing sie **4 von 4**.

**Und die Umkehrung, am 08.08. an D1 gelernt:** eine Messung, die *lange vor* der Aussage erfolgte —
etwa in einem Kommentar dokumentiert — ist **keine Bestätigung**. Der Kommentar trug eine Zahl mit
Nenner und einen Beleg, also genau die Merkmale guter Befunde; was fehlte, war die Frage *„gilt das
noch?"*. **Jeder aus Kommentar, Ledger oder Bericht übernommene Zahlenwert braucht eine eigene
Ist-Messung, bevor daraus ein Bau-Posten wird.**

## II.3 V1 — Berichte sind Beweismaterial, kein Beweis

Jede Zahl, jeder SHA und jede Zustandsaussage aus einem Agentenbericht wird vor Weitergabe selbst
gemessen **oder ausdrücklich als ungeprüft gekennzeichnet**. Das gilt auch für Berichte, die richtig
aussehen — gerade für die.

## II.4 V4 — Verdächtige das eigene Messverfahren

Erste Rückfrage bei jedem überraschenden Ergebnis: **kann mein Verfahren das erzeugt haben?**
Belegte Fälle: 1133 Phantom-ASCII-Verstöße durch Locale-Artefakte (`od -c` fand 0 Bytes) ·
„Ersatztexte fehlen im PDF" durch Textextraktion ohne Trenner · `grep -v '/build'` frisst `/builder/`.

## II.5 Der Nenner — nie eine nackte Zahl

Nicht „3 Fehler", sondern **„3 von 14 Jobs"**. Eine Wache ohne Nenner meldet Vollständigkeit und
deckt nichts. Eine Null ohne Nenner ist von einem echten Freispruch nicht zu unterscheiden.

**Der wirksame Fix ist immer derselbe: den Nenner in die AUSGABE des Werkzeugs zwingen.**

## II.6 K13 — Der Köder muss erst beißen

Eine Wache gilt **erst dann als gebaut**, wenn ein **zufällig erzeugter** Köder sie zum Beißen
bringt — `/dev/urandom`, nie aus einer Doku abgeschrieben. **Beide Richtungen fahren:** der
Positiv-Fall ist der Nenner; ohne ihn könnte die Wache konstant rot sein.

**Neu gelernt am 08.08.:** ein Test, der einen Randfall **nur auf Absturzfreiheit** prüft,
unterschreibt stillschweigend die Semantik, die er dabei vorfindet. Genau so wurde ein Defekt vom
eigenen Test zementiert.

## II.7 Fail-closed

Kann eine Wache nicht prüfen — Werkzeug fehlt, API antwortet nicht, Verzeichnis fehlt —, ist das
**rot oder Abbruch, nie grün**. Ein stiller Rückfall ist ausdrücklich ein Fehler.

## II.8 Weitere tragende Regeln

- **Widersprüche nicht glattrechnen.** Beide Seiten zeigen, den Widerspruch benennen.
- **Drei Ebenen trennen:** OWNER-WORT (Gesetz) · AGENT-BEHAUPTUNG (Material) · OBJEKT-BEFUND (gemessen).
- **Explore ist zweistufig:** Stufe 1 kartiert mit Datei:Zeile, Stufe 2 liest **jede tragende
  Referenz selbst** nach. Nie nur eine Stufe.
- **Invalidieren ist gewollt.** Den Bestand zu brechen ist Zweck; Pflicht ist nur, dass der Bruch
  **laut** ist (compile-time). Migration ist ein eigenes Paket.
- **Objekt vor Aggregat.** Zuerst die Datei, die Zeile, der Lauf — dann die Zusammenfassung.

---

# TEIL III — DIE FÜNF PRÜFFRAGEN VOR JEDEM PAKET

Sie ersetzen keine Wache. Sie stehen **davor**, weil sie billig sind und die Klasse, um die es geht,
**kein Fehlersignal erzeugt**.

### 1. Der Nenner
Über welcher Grundgesamtheit rechne ich, und steht sie in der **Ausgabe**? — die Menge, die mein
Muster überhaupt finden **kann** · die Jobs, die wirklich **liefen** · die Commits, die wirklich
**gescannt** wurden · die Fälle, über die der Fakt etwas **sagt** · der **Zeitpunkt**, zu dem die
Aussage galt.

### 2. Der Gegenstand
Misst mein Beleg **die Sache** — oder etwas Benachbartes, das billiger zu messen war?
Belegte Vertauschungen: Diff statt Funktion · Gesamtstatus statt Jobliste · `rc=0` statt „0 commits
scanned" · Worktree statt Klon · `$?` statt `PIPESTATUS` · Endpunkt-Liste statt Basisrate ·
Tagesfenster statt Historie · ODER-Aggregat statt vier Zählern.

### 3. Die Zeitrichtung
Lief die Messung **vor** dem Satz? Und: ist eine ältere dokumentierte Messung wirklich noch gültig?

### 4. Die Deckung
Was erzwingt, dass diese Regel **morgen noch hält** — Werkzeug, Disziplin oder Zufall?
**Nur die erste Antwort zählt.**

### 5. Der Widerruf
Wenn ich gerade korrigiere: prüfe ich die neue Aussage **genauso hart wie die alte**?
In **13 von 40** Fällen war die Antwort nein — *Korrektur-Momentum ersetzt die Prüfung der neuen
Aussage.*

---

# TEIL IV — DIE FEHLERKLASSE, DIE KEIN SIGNAL ERZEUGT

## IV.1 Der Stellvertreter

Alle belegten Klassen sind derselbe Griff: **etwas Benachbartes, Billigeres wird für den Gegenstand
genommen.** Fünfzehn Belege nach demselben Schnittmuster.

Und der Satz, der die Abnahmen ändert:

> **Ein falsches Messgerät fällt irgendwann auf. Ein richtiges Messgerät am falschen Gegenstand
> nie — es gibt nichts, was klappern könnte.**

Die Messung ist korrekt, die Zahl belastbar, das Gate grün, das Gewissen rein.

## IV.2 Disziplin trägt hier strukturell nicht

Am Objekt gemessen: von zehn Verschärfungen hielten **7 von 10** — und es sind genau die, die **in
ein Werkzeug gebrannt** wurden. Die **drei rein disziplinären** sind exakt die, die zurückkamen.
Die einzige durchgängig gehaltene (cf22-Selbstcheck, **6 von 6**) steht **in einem Skript**.

Dreimal hielt eine Regel nur scheinbar: die gitleaks-Deckung hielt **zufällig** (27 von 37 Pushes
ohne Lauf, unbemerkt); die Ein-Schreiber-Regel hielt, weil fremde Agenten 21 Stunden **still waren**.

> **Zufall, Disziplin und Maschine sehen im Rückblick identisch grün aus.** Unterscheidbar sind sie
> nur an der Frage: **was erzwingt das Halten?**

## IV.3 Die Schleife, die den Plan selbst gefährdet

Gemessene Rückkopplung: **Breite → Takt → Stellvertreter → Aussage vor Messung → Korrekturschleife →
weniger Zeit → mehr Breite.** Belegt an 9 Workflows mit 114 Agenten, von denen **1 von 9** auf dem
fristkritischen Pfad lag.

> **Ein Workflow ist kein Fortschritt**, solange sein Ergebnis nicht in einem Bau-Paket auf dem
> kritischen Pfad gelandet ist. Vor jeder Fan-out-Runde: *liegt das, was ich breit untersuche, auf
> dem Weg zum 15.09.?* Wenn nein → W7-Behälter.

## IV.4 Wo Fehler entstehen — ein Datum, kein Urteil

Die Lead-Prämissen waren häufiger falsch als die Arbeit der Agenten. **Kein Agent widerlegte je den
Owner am Objekt.** Der Owner formulierte keine Werkzeug-Falle, aber die tragenden Architektur-KERNe
— und korrigierte sich zweimal selbst.

> **Fehler entstehen dort, wo aggregiert wird, nicht dort, wo Objekte angefasst werden.**
> Aggregation ist genau die Operation, **die Nenner verschluckt.**

---

# TEIL V — DIE WERKZEUG-FALLEN

Jede hat mindestens einmal zugeschlagen.

| Falle | Wirkung |
|---|---|
| `/usr/bin/grep` **ist ugrep** | `-P`-Muster brechen mit **stiller 0** ab — jedes so gemessene Gate meldet falsches Grün |
| `grep -v '/build'` | frisst auch `/builder/` — immer `/build/` mit **beiden** Schrägstrichen |
| **`rc=$?` nach einer Pipe** | misst das **letzte Glied**, nicht den Befehl davor → `PIPESTATUS` oder ohne Pipe messen |
| gitleaks im Worktree | scannt **0 Commits** und meldet trotzdem grün → echter Klon oder Push-Bereich `origin/<branch>..HEAD` |
| gitleaks stdin ohne `--config` | läuft **ohne Regeln**, meldet immer „no leaks" |
| zufällige `AKIA…`-Köder | fallen meist **unter die Entropie-Schwelle** — „no leaks" auf einem Eigenköder beweist nichts |
| `git` ohne `-C` | es gibt viele Arbeitsbäume; das cwd ist keine verlässliche Aussage |
| `git add` mit verschobenem Pfad | bricht den **ganzen** Aufruf ab; `2>/dev/null` verschluckt es → danach `git status --short` |
| Vault greppen | gibt Klartext aus → nur blind (`mapfile`), über die **Länge** selektieren, Kandidaten **rückwärts** prüfen |
| XML-Kommentare | `--` ist ausnahmslos verboten — und bei **generierten** Dateien den **Generator** mitheilen |

**Weiter:** nie `rebase`, immer `merge` · main-FF nur `push origin <VOLLER-SHA>:refs/heads/main` ·
Transkripte nie committen · Messdaten nie löschen · Doku nur deprecaten.

---

# TEIL VI — DIE ARCHITEKTUR

## VI.1 Die Kette

Es gibt **zwei** Ketten, und sie sind nicht dieselbe. Die eine beschreibt die Übergabe von
Verantwortung im Code, die andere den Weg eines Prüflings von der XML bis ins PDF. Wer sie
verwechselt, beurteilt die richtige Sache auf der falschen Schicht.

**(a) Die Architektur-Kette — wer trägt wann:**

```
[PLANER] fragt (Laufzeit) → [CEB] trägt (Compile-Zeit) → [HYBRID] adaptiert → [TIER] läuft
```

**(b) Die Verarbeitungskette — der Weg des Prüflings.** Owner-Wortlaut vom 09.08., bindend:

```
XML
 → Planer
 → CEB
 → Tier-Binaries BAUEN     mit Lagerhaltung + Hardware-Job-Pool über Maschinenfähigkeiten
                            (gleiche CI für alle Maschinen,
                             custom Filterung der Compiles je Hardware-Freigabe)
 → Tier-Binaries MESSEN    mit Lagerhaltung
 → Tier-Binaries AUSWERTEN
 → Tier-Binaries RELEASE   + Hybrid-Bau
 → Messwerte als LaTeX und PDF VERÖFFENTLICHEN
```

**Der Hardware-Job-Pool ist damit ein benanntes Kettenglied, kein Betriebsdetail.** Alle Maschinen
fahren **dieselbe** CI und dürfen zunächst **alle** Jobs aufnehmen; was eine Maschine tatsächlich
übernimmt, entscheidet die **Filterung der Compiles nach ihrer Hardware-Freigabe** — und die
Abstimmung darüber, *wer welches Batch verarbeitet*, läuft **über das Lager**. Owner, wörtlich:

> „das war so geplant, dass über das Lager die Maschinen abstimmen, wer welches Batch verarbeitet
> und es können auch erstmal alle Maschinen alle Jobs aufnehmen."

Daraus folgt unmittelbar die Frage, an der die Datenintegrität hängt und die separat zu klären ist:
**baut jede Maschine zum Maximum ihrer eigenen Möglichkeiten** — prod1 mit AVX-512, prod2 mit AVX2 —
**und unterscheidet das Lager die beiden Ergebnisse?** Trügen sie dieselbe Kennung, wäre der SKIP
falsch: eine Maschine überspränge eine Binary, die sie selbst nie hätte bauen können.

**Diese acht Stationen sind zugleich die Explore-Auslöseliste.** Owner-Anweisung vom 09.08.:
komme ich zu einem Thema dieser Kette nicht weiter, wird **zuerst** ein Sonnet-5-max-effort-Explore
(*„very thorough"*) gefahren, der herausfindet, **was in der Vergangenheit dazu geplant war** —
und ebenso immer dann, wenn ich sonst raten müsste. **Raten ist nie zulässig.** Der Anlass für diese
Regel steht im Ledger unter „RICHTIGSTELLUNG 09.08.2026": ein korrekt gemessener Befund, den ich
gedeutet habe, ohne vorher nach dem vorhandenen Entwurf zu suchen.

## VI.2 HYBRID — Pflicht, eigene Gattung, 0 % gebaut

Owner-KERN 08.08.: Gattung **`HEURISTIK-ADAPTER`**, Genus **`Function-Interface-Reroute`**.

Sie erbt **compile-time** die Interfaces einer Gattung+Genus und stellt sie nach heuristischer
Entscheidung an die eigentlichen Tier-Binary-Interfaces durch — *„wie ein heuristik-gesteuertes
Mutex"*. Sie rechnet nicht selbst; sie entscheidet, wer durchdarf.

**Eigene Macro-Benchmarking-Schicht:** die drei Mess-Ebenen werden im Hybrid-Fall auf **vier**
erweitert — die neue wird **dazwischengeschoben**, nicht angehängt. Gemessen wird der **Overhead des
Reroutes zu multiplen Tier-Zielen am Hybrid-Prüfdock**.

**Verschränkung:** wie `SearchAlgorithm` die Container-Gattung nutzt, kann die
Heuristik-Tier-Binary-Strategie **direkt im SearchAlgorithm-Hauptalgorithmus** als
Heuristik-Hybrid-Achse aufgerufen werden, mit zwei Ausgängen: direkter Tier-Aufbau **oder**
Hybrid-Mehrfach-Aufbau. **Sie wirkt auf den Bauplan, nicht nur auf den Bauinhalt** —
`--check-size` muss sie mitrechnen, sonst ist jede Größenrechnung strukturell zu klein.

## VI.3 Metaprogrammierung

Compile-Time-Dispatch statt Laufzeit-`switch` · Pre-Build-Codegen · CRTP + Concept-Guard · nur
Lehrbuch-Entwurfsmuster, zero-cost · **kein `std::variant`** über statische Achsen (Ausnahme:
`DockSlot` im Hybrid).

## VI.4 Lagerhaltung

**EIN** Storage-Tree im Code, **ZWEI** Filesystem-Wurzeln (`binaries` / `measurements`), **lazy**
angelegt, in **zwei Durchläufen** — erst bauen, dann messen. Gültiger Bestand ⇒ **SKIP**, für
Messdaten **und** Binaries. Neue Binary-Version ⇒ neuer Datensatz **neben** dem alten.

**Die Ausgabe ist xlsx. CSV wird NIE verwendet.**

## VI.5 Messung

Drift-Gate **5 %** über **3** Wiederholungen; bei Überschreitung den **ganzen Lauf** neu starten —
ein fremder Verbraucher ist aktiv, den man abwarten muss. Beim **Scheitern** bis zu **5**
Wiederholungen. Ein gescheiterter Algorithmus schreibt **„failed"** in die Zelle — nie null, nie
leer — und der Lauf misst weiter:

> *„In der Wissenschaft geht nicht immer alles glatt, aber das muss SICHTBAR sein."*

**Wir arbeiten NIE mit Zufall** — außer für Köder. Die Gap-Statistik der k-Wahl braucht eine
Zufalls-Referenz und fällt damit aus; die k-Wahl stützt sich auf Silhouette + Elbow + Domänen-Anker
**k ≈ 6…14**.

---

# TEIL VII — DIE WELLEN

## VII.1 Der Fahrplan

```
15.09. Di   ABGABE
11.09. Fr   F5  PDF final, Anhang gegen Nenner, P-1 3/3      <- LETZTE LIEFERUNG
04.09. Fr   F4  Kampagne gemessen + Rückschrieb mit Substanz
28.08. Fr   F3  Bestand gebaut + USER-GO-VORLAGE             <- danach NULL-Bump
21.08. Fr   F2  Statistik-Kanon + Menge rechenbar + HY-A     <- IDENTITÄTS-FREEZE
14.08. Fr   F1  Nenner-Ehrlichkeit + DURCHSTICH
```

| Welle | Fenster | Kern | Parallelität |
|---|---|---|---|
| **W-1** | Sa 08.–So 09.08. | Landung + Bauweg-Wahrheit, Diff-Neuerhebung | 1 |
| **W0a** | Mo 10.–Mi 12.08. | **DIE WAAGE** — jede Zählung ehrlich, Perzentil-Kanon vorgezogen | 2 |
| **W0b** | Mi 12.–Fr 14.08. | **DIE NÄHTE + DURCHSTICH** | 2 |
| **W1** | Mo 17.–Fr 21.08. | Statistik-Glied + Menge + **HY-A** | 2 |
| **W2** | Mo 24.–Fr 28.08. | **EIN** Bump, Anker, Bau (~41,4 h) | 1 |
| **W3-MESS** | Sa 29.08.–Do 03.09. | **DIE KAMPAGNE** + HY-B | 1 |
| **W4** | Mo 07.–Fr 11.09. | Auswertung + Text + **HY-C** | 2 |
| **W5** | Sa 12.–Di 15.09. | Sicherung, PDF, Abgabe | — |
| **W7** | nach der Abgabe | §75, Restbau, HY-Vollausbau, `checkpoint_measure` | — |

## VII.2 Betriebsregeln über allen Wellen

- **EIN-BLECH-REGEL:** höchstens **ein** Pipeline-Abnahme-Paket zur Zeit; zweiter Slot nur lokal.
  Bau und Kampagne sind **exklusiv**.
- Jede Abnahme trägt **Nenner**, **Rot- und Grün-Lauf**, **frisch gewürfelten Köder**.
- **Eine Welle ohne beißende Wache gilt als nicht abgenommen** — und beidseitig: ein Paket ohne
  Abnahmezeile ebenso wenig wie eine Abnahmezeile ohne Paket.
- **Zu jeder Abnahme gehört die Antwort auf „was erzwingt das Halten?"** Zulässig: **ein Werkzeug**
  oder **eine ausdrücklich als ungedeckt benannte Stelle**. *„Wir achten darauf"* = **nicht
  abgenommen**.
- Während **W2** (Bau) und **W3** (Kampagne): **null** CI- und Agenten-Last auf prod1. Fremde Last
  kontaminiert Latenzen — **kontaminierte Daten sind die unheilbare Klasse.** Textarbeit über
  Overleaf-Remote.

## VII.3 Der DURCHSTICH (F1, 14.08.)

Die wichtigste frühe Abnahme: ein am Mittwoch **frisch gemessener** Mini-Messwert liegt am Freitag
als Tabellenzeile im Thesis-Submodul — durch die komplette Kette
`CSV → persist → xlsx → anhang:forward → PDF`. Jede Stufe druckt ihren Nenner.

**Ein Durchstich beweist mehr als jede Einzelwache.**

---

# TEIL VIII — DER TDD-VERTRAG

## VIII.1 Warum nicht Abdeckungsprozente

Von den fünf Defekt-Familien des 08.08. war **dreimal der Test selbst der Defekt**:
`test_commands.cpp:183-190` sichert Welch `t=0, p=1` über konstanten Gruppen als **Sollverhalten**
zu · `SummarizeEmptyZeroWinRate` zementiert `win_rate=0.0` über leerer Menge · die Abdeckungs-Wache
blieb grün gegen den korrekten 431-Baum.

**Eine Abdeckungszahl hätte in allen drei Fällen gut ausgesehen** — die Zeilen *werden* ausgeführt,
sie sichern nur nichts zu.

> **Abdeckung misst Berührung. Wir messen Beißfähigkeit — mit gefahrenem Biss.**

## VIII.2 Die Prüfnorm

Ein Test zählt nur, wenn **drei Dinge benannt** sind:
1. welche **Aussage** er sichert,
2. welcher **Eingang** sie fällen würde,
3. **woher sein Nenner** stammt — **nicht aus dem Prüfling**.

## VIII.3 Die sieben Testklassen (117 Posten, 386 h)

| Klasse | Anzahl | Muster |
|---|---|---|
| `keine-negativprobe` | 29 | Zusicherung ohne Eingang, bei dem sie fällt |
| `anwesenheit-statt-bedingung` | 25 | geprüft wird, dass etwas **da** ist, nicht dass es **gilt** |
| `kein-nenner` | 23 | Zahl ohne Grundgesamtheit, Kennzahl ohne „nicht bestimmbar" |
| `unerreichbarer-block` | 16 | Test existiert und läuft nie — **Registrierung ist Teil des Tests** |
| `test-zementiert-defekt` | 10 | Test schreibt falsches Verhalten als Soll fest |
| zwei weitere | 12 | — |
| Einzelfälle | 2 | nach Hausregel keine Klasse |

Jeder Posten trägt **Band** (A = landet im Fenster · B = nur bei freiem Slot · C = W7), **Welle** und
Stundenschätzung.

## VIII.4 Was der zweistufige Aufbau belegt hat

**157 Behauptungen** durch die Meta-Objektprüfung: **117 bestätigt**, **40 gefallen** (ein Viertel),
**62 Funde hatte erst die Meta-Stufe**.

> **Einstufige Kritik verliert am Objekt ein Viertel ihrer Behauptungen und übersieht zusätzlich
> einen Bestand von mehr als der Hälfte ihres Fundvolumens.**

**13 der 40 Gefallenen waren Fehler der ersten Schärfungsstufe selbst** — Testentwürfe, die am
*gesunden* Objekt rot oder am *kranken* grün gewesen wären. **Ein Testentwurf ist eine Behauptung
wie jede andere.**

## VIII.5 Codex als stehender Kritiker

Codex (GPT-5, read-only) bleibt eingebunden — **als Kritiker, nicht als Zusammenfasser**, und
**immer mit nachgeschalteter Objektprüfung**. Sein Verdikt ist Beweismaterial.

---

# TEIL IX — STAND DER DEFEKTE

| ID | Gegenstand | Stand |
|---|---|---|
| **D3** | Voll-Messlauf akzeptierte leeres Messfenster | **geheilt** `super ce7d4007` |
| **D4** | Drift-Gate erklärte degenerierte Messung für stabil | **geheilt** `ce 5922bb99` |
| **D3-5** | `[MESS-TESTAT]` wurde unbedingt gedruckt | **geheilt** `ce 7bcf353b` |
| **D1** | `make check` ohne Reconfigure | **FEHLBEFUND** — zweifach widerlegt |
| **D2** | Abdeckungs-Wache über zu kleinem Nenner | **offen** — **18** bedingte Registrierungen unter **14** Bedingungen (09.08. am Objekt bestätigt, drei ce-Stände, `scripts/ci_abnahme06_bedingungs_tabelle.sh`); `STATUS_OUT` deckt davon ~~2~~ → **4 von 18** (22 %). Die „2" traf die *Blöcke ohne Registrierung* (`_pa_status`, `_fj_status` — in jeder CI unerreichbar), nicht die gedeckten Registrierungen. **Teilstück D2-G4 ERLEDIGT 09.08.**: Formel ##06 auf „erfüllt ODER Allowlist mit Begründung" korrigiert, Zähl-Skript + `ci/abnahme06_bedingungs_allowlist.txt` gelandet. |
| **D5** | fünf Median-Implementierungen, drei Antworten | **offen** |
| **D3-4** | Ausgabe-Gate in `allow_failure`-Job wirkungslos | **offen** — gehört in einen Folge-Job |

**`allow_failure: true` am Mess-Batch ist korrekt** und doktrinär begründet (Sichtbarkeits-Doktrin).
Es zu entfernen wäre eine **Regression**.

---

# TEIL X — BERICHTERSTATTUNG

Nach jedem Paket, **ohne auf Antwort zu warten**:

1. **Was gelandet ist** — SHA, Branch, Repo
2. **Womit es belegt ist** — Nenner, Köder, literale Ausgabe
3. **Was dabei widerlegt wurde** — auch eigene frühere Aussagen
4. **Was offen bleibt** — ausdrücklich, nicht durch Weglassen

**Eine Korrektur an der eigenen Arbeit ist kein Makel, sondern der Regelfall.** Sie gehört genauso in
den Bericht wie der Erfolg.

Der **Ledger** ist die einzige Wahrheitsquelle für den Stand. Nachträge stehen **oben**, per
`scripts/ledger_nachtrag.sh` — weil die Regel „neueste oben" im Kopf unter Takt zuerst fallengelassen
wurde. **Eine Regel gehört ins Werkzeug, nicht in den Kopf.**

---

## SCHLUSSSATZ

Dieses Goal ist erfüllt, wenn am 15.09.2026 eine Diplomarbeit abgegeben ist, in der **jede
ausgewiesene Zahl** von einer Messung gedeckt ist, die **älter ist als der Satz**, der sie
behauptet — und in der **jede Regel, die das sichert, in einem Werkzeug steht und nicht in einem
Kopf.**
