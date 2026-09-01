# GOAL v8 — ALLE WELLEN AM STÜCK BIS ZUR ABGABE

> **DEPRECATED/SUPERSEDED (01.09.2026, #157(a)):** Diese 241-Z.-Lesefassung ist ueberholt durch
> docs/plaene/20260826-GOAL-V8-DICHT.md (LEBENDE DICHTE FASSUNG). Sie traegt u.a. die VI.4-csv-Korrektur
> NICHT (GOAL-DICHT W-09) -- NICHT als Einstieg nutzen; das Einlese-Ritual laeuft ueber die DICHT-Fassung.
> Der folgende Text bleibt additiv als historischer Stand vom 08.08.2026 erhalten (Doku nie loeschen).

> **Version:** v8 · **Gesetzt:** 08.08.2026 · **Gültig bis:** 15.09.2026 (Abgabe)
> **Dossier:** `super docs/plaene/20260808-GOAL-V8-DOSSIER-alle-wellen-am-stueck-bis-abgabe.md` (`e26ba1d3`)
> **Autorität:** Owner-KERN, wörtlich: *„direktes blanko volles GO alle zukünftigen Phasen autonom abzuarbeiten…wirklich ALLE am Stück"*

---

## I. DER AUFTRAG

Arbeite den Wellenplan v2 von W-1 bis W5 **am Stück und autonom** ab, liefere an jedem der fünf Freitage einen für sich stehenden Stand, und gib am 15.09.2026 eine Diplomarbeit ab, deren jede ausgewiesene Zahl von einer Messung gedeckt ist, **die älter ist als der Satz, der sie behauptet.**

### Die vier bindenden Dokumente

| Rolle | Pfad (alle in `super`) |
|---|---|
| **Das Ziel** | `docs/plaene/20260808-GOAL-V8-DOSSIER-…md` |
| **Was gebaut wird** | `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md` — **inkl. §11 und §12** |
| **Wie geprüft wird** | `docs/plaene/20260808-DESIGNPLAN-tdd-testabdeckung-alle-wellen.md` |
| **Wie gearbeitet wird** | `docs/ARBEITSWEISE-GESAMT-DOKTRIN.md` v3.1 |

Stand-Quelle: der **Ledger** (Nachträge **oben**, via `scripts/ledger_nachtrag.sh`).
Erfahrungsgrundlage: `docs/sessions/20260808-SESSION-ERKENNTNISSE-widerlegte-befunde-und-learnings.md`.

**Versionierung:** v8 supersedet v1–v6. **v7 wurde nie vergeben** — die Belege dafür sind Substring-Zufälle. Vorgänger **nicht löschen**, nur deprecaten.

### Was v8 anders macht als alle Vorgänger

Die früheren Goals beschrieben **Bau-Strecken**. v8 beschreibt zusätzlich, **woran man erkennt, dass eine Aussage über den Bau stimmt** — weil die teuersten Fehler dieses Projekts nicht im Bau entstanden, sondern in der Berichterstattung darüber. Am 08.08. wurden fünf blockierende Defekte gefunden; **dreimal war der Test selbst der Defekt**, und von 40 geprüften Widerrufen fielen **13 selbst**.

### Der Rahmen — nicht verhandelbar

**Frist:** Di 15.09.2026. Lieferung freitags: 14.08. · 21.08. · 28.08. · 04.09. · 11.09. **Jeder Freitag steht allein.**

**Eigentum:** Thesis = Benjamin-Elias Probst **privat** · CacheEngine/PRT-ART/super = **BEP Venture UG, Marke Comdare**. Zwei Rechtsträger, nie vermengen.

**Ein Blech:** alle super-CI-Jobs `tags:[baremetal]` → nur prod1, `concurrent=2`. prod1 **ist** die lokale Maschine, der Runner liegt auf derselben Platte. Zwei Pakete mit „Pipeline grün" als Abnahme sind **seriell**.

> ⚠️ **KORREKTUR-EINSCHUB 09.08.2026 — dieser Absatz ist überholt; er bleibt als Wortlaut stehen, weil dieses Dokument verbatim ist.**
> Der Satz *„`tags:[baremetal]` → nur prod1"* ist **am Objekt widerlegt**: es gibt **zwei** bare-metal-Runner (id=16 prod1/AMD **mit** AVX-512, id=17 prod2/Intel **ohne**), und **47 von 53 tag-tragenden Jobs beider Repos** landen auf beiden *(Stand `super af82a611`/`ce 59cc9428`; die Zahl wandert mit jedem neuen Job — 44/48 falsch, 45/51 bei `f2ea8fcd` 06:58, 47/53 heute Mittag. **Eine Zahl über eine lebende Datei gilt nur mit Commit-Anker.**)*. Pipeline `15412` hat es bewiesen (`== Host ==`: `Linux prod2`, `GenuineIntel`, i9-12900K).
> **Und die Folgerung, die ich daraus zog, ist ebenfalls falsch.** Der Owner, wörtlich: *„das war so geplant, dass über das Lager die Maschinen abstimmen, wer welches Batch verarbeitet und es können auch erstmal alle Maschinen alle Jobs aufnehmen."* **Das Floaten ist der Entwurf.** Die Koordination sitzt im **Lager** und in der **Filterung der Compiles je Hardware-Freigabe** (Kettenglied „Hardware-Job-Pool über Maschinenfähigkeiten"), nicht in GitLab-Tags.
> **Was bleibt:** die Serialität von Pipeline-Abnahmen ist *meine* Arbeitsdisziplin — ich kann nur eine Abnahme zur Zeit beurteilen — und nicht länger eine Maschinen-Kapazitätsaussage. Neu hinzu kommt: **jede Wache, die ihren Nenner aus der Hardware zieht, muss die Maschine mit ausweisen.**
> Volltext, Fehlerklasse und Beleg: Ledger, Abschnitt „RICHTIGSTELLUNG 09.08.2026 — der Befund hält, meine Deutung nicht". Die gültige Kettenfassung steht im Dossier §VI.1.

**Autonomie:** Phasengrenzen sind **kein** Haltepunkt. Standardzustand ist Weiterarbeiten. **Melden ≠ fragen.** Rückfrage nur bei nicht billig rücknehmbarem Schaden oder teurem Umbau. **Ein Defekt ist nie ein Grund zu fragen.** Eine nicht auflösbare Frage ist zuerst eine **eigene Gedächtnislücke** — erst vier bis sechs Wochen Bestand durchsuchen.

---

## II. DIE ARBEITSWEISE

**A2.0 Reihenfolge:** Gedächtnis → Review → Explore → Design → Bauen → Verify. Kein Agentenstart ohne Gedächtnis-Befund — eine Fundstelle oder der Satz *„GEDÄCHTNIS GEPRÜFT, KEIN TREFFER: `<muster>`"*. Warum sie zuerst fällt: *sie kostet vorne und liefert hinten nichts Sichtbares, während ein Explore-Agent wie Fortschritt aussieht.*

**V11 Belegzeile, in beide Richtungen:** Die Messung muss **älter** sein als der Satz. Eine Messung *danach* ist eine Korrektur (belegt: 6 von 6 Selbstwiderlegungen kamen zu spät; wo die Messung vorher lief, fing sie 4 von 4). Und die Umkehrung, an D1 gelernt: eine Messung *lange vorher* — etwa in einem Kommentar — ist **keine Bestätigung**.

**V1:** Berichte sind Beweismaterial, kein Beweis. Gerade die, die richtig aussehen.

**V4:** Verdächtige das eigene Messverfahren. Erste Rückfrage bei jedem überraschenden Ergebnis: *kann mein Verfahren das erzeugt haben?*

**Der Nenner:** nie eine nackte Zahl — „3 von 14 Jobs", nicht „3 Fehler". **Den Nenner in die Ausgabe des Werkzeugs zwingen.**

**K13:** Eine Wache gilt erst als gebaut, wenn ein **zufällig erzeugter** Köder sie zum Beißen bringt. **Beide Richtungen** — der Positiv-Fall ist der Nenner.

**Fail-closed · Widersprüche nicht glattrechnen · Owner-Wort / Agent-Behauptung / Objekt-Befund trennen · Explore zweistufig · Invalidieren ist gewollt, solange der Bruch laut ist · Objekt vor Aggregat.**

---

## III. DIE FÜNF PRÜFUNGEN VOR JEDEM PAKET

1. **Der Nenner** — über welcher Grundgesamtheit rechne ich, und steht sie in der **Ausgabe**?
2. **Der Gegenstand** — misst mein Beleg *die Sache*, oder etwas Benachbartes, das billiger war?
3. **Die Zeitrichtung** — lief die Messung **vor** dem Satz? Gilt eine ältere dokumentierte Messung noch?
4. **Die Deckung** — was erzwingt, dass die Regel morgen hält: Werkzeug, Disziplin oder Zufall?
5. **Der Widerruf** — prüfe ich die neue Aussage **so hart wie die alte**?

---

## IV. DIE FEHLERKLASSE, DIE KEIN SIGNAL ERZEUGT

**Der Stellvertreter** — etwas Benachbartes, Billigeres wird für den Gegenstand genommen. Fünfzehn Belege nach demselben Schnittmuster: Diff statt Funktion · Gesamtstatus statt Jobliste · `rc=0` statt „0 commits scanned" · Worktree statt Klon · `$?` statt `PIPESTATUS`.

> **Ein falsches Messgerät fällt irgendwann auf. Ein richtiges Messgerät am falschen Gegenstand nie — es gibt nichts, was klappern könnte.**

**Disziplin trägt hier strukturell nicht.** Von zehn Verschärfungen hielten **7 von 10** — genau die, die in ein **Werkzeug** gebrannt wurden. Die drei rein disziplinären kamen zurück. Dreimal hielt eine Regel nur scheinbar: gitleaks **zufällig** (27 von 37 Pushes ohne Lauf), die Ein-Schreiber-Regel, weil Agenten 21 Stunden still waren.

> **Zufall, Disziplin und Maschine sehen im Rückblick identisch grün aus.** Unterscheidbar nur an: **was erzwingt das Halten?**

**Die Schleife, die den Plan gefährdet:** Breite → Takt → Stellvertreter → Aussage vor Messung → Korrekturschleife → weniger Zeit → mehr Breite. Belegt an 9 Workflows mit 114 Agenten, davon **1 von 9** auf dem fristkritischen Pfad.

> **Ein Workflow ist kein Fortschritt**, solange sein Ergebnis nicht in einem Bau-Paket auf dem kritischen Pfad gelandet ist. Sonst → W7.

**Wo Fehler entstehen** — ein Datum, kein Urteil: Lead-Prämissen waren häufiger falsch als die Arbeit der Agenten. **Kein Agent widerlegte je den Owner am Objekt.** *Fehler entstehen dort, wo aggregiert wird — Aggregation ist genau die Operation, die Nenner verschluckt.*

---

## V. DIE WERKZEUG-FALLEN

| Falle | Wirkung |
|---|---|
| `/usr/bin/grep` **ist ugrep** | `-P` bricht mit **stiller 0** ab |
| `grep -v '/build'` | frisst `/builder/` — immer `/build/` mit **beiden** Schrägstrichen |
| **`rc=$?` nach einer Pipe** | misst das **letzte Glied** → `PIPESTATUS` oder ohne Pipe |
| gitleaks im Worktree | scannt **0 Commits**, meldet grün → Push-Bereich `origin/<branch>..HEAD` |
| gitleaks stdin ohne `--config` | läuft **ohne Regeln** |
| eigene `AKIA…`-Köder | fallen unter die **Entropie-Schwelle** — „no leaks" beweist nichts |
| `git` ohne `-C` | viele Arbeitsbäume; cwd ist keine Aussage |
| `git add` mit verschobenem Pfad | bricht den **ganzen** Aufruf ab → danach `git status --short` |
| Vault greppen | gibt Klartext aus → blind, über **Länge**, **rückwärts** prüfen |
| XML-Kommentare | `--` verboten — bei **generierten** Dateien den **Generator** mitheilen |

Weiter: nie `rebase` · main-FF nur mit vollem SHA · Transkripte nie committen · Messdaten nie löschen · Doku nur deprecaten.

---

## VI. DIE ARCHITEKTUR

**Die Kette:** `[PLANER] fragt (RT) → [CEB] trägt (CT) → [HYBRID] adaptiert → [TIER] läuft`

**HYBRID** — Pflicht, eigene Gattung `HEURISTIK-ADAPTER` / Genus `Function-Interface-Reroute`. Erbt **compile-time** die Interfaces, stellt sie heuristisch durch — *„wie ein heuristik-gesteuertes Mutex"*. Eigene Macro-Schicht als **4. Mess-Ebene dazwischen**. Aufrufbar im SearchAlgorithm als Heuristik-Hybrid-Achse mit zwei Ausgängen — **sie wirkt auf den Bauplan, nicht nur auf den Bauinhalt.**

**Lagerhaltung:** EIN Storage-Tree, ZWEI FS-Wurzeln, lazy, zwei Durchläufe. Gültiger Bestand ⇒ **SKIP**. **xlsx ist die Ausgabe, CSV nie.**

**Messung:** Drift **5 %** über **3** Wiederholungen → ganzen Lauf neu. Beim Scheitern bis zu **5**. Gescheiterter Algorithmus ⇒ **„failed"**, Lauf misst weiter. **Nie mit Zufall** — außer für Köder.

---

## VII. DIE WELLEN

```
15.09. Di   ABGABE
11.09. Fr   F5  PDF final, Anhang gegen Nenner
04.09. Fr   F4  Kampagne gemessen + Rückschrieb
28.08. Fr   F3  Bestand gebaut + USER-GO-VORLAGE      <- danach NULL-Bump
21.08. Fr   F2  Statistik + Menge + HY-A              <- IDENTITÄTS-FREEZE
14.08. Fr   F1  Nenner-Ehrlichkeit + DURCHSTICH
```

| Welle | Fenster | Kern | Testlast Band A |
|---|---|---|---|
| **W-1** | 08.–09.08. | Landung + Bauweg-Wahrheit | 1 Posten, **3 h** |
| **W0a** | 10.–12.08. | **Die Waage** | 3, **9 h** |
| **W0b** | 12.–14.08. | **Nähte + Durchstich** | 15, **40 h** |
| **W1** | 17.–21.08. | Statistik + Menge + HY-A | 23, **99 h** ⚠️ |
| **W2** | 24.–28.08. | Ein Bump, Anker, Bau | 8, **21 h** |
| **W3-MESS** | 29.08.–03.09. | **Kampagne** + HY-B | **0 h** |
| **W4** | 07.–11.09. | Auswertung + Text + HY-C | 3 + HY, **34 h** |
| **W5** | 12.–15.09. | Sicherung, PDF, Abgabe | — |
| **W7** | danach | Behälter, **gezählte Warteliste** | 5, 13 h + Rest B |

**Betriebsregeln:** EIN-BLECH-REGEL · jede Abnahme mit Nenner, Rot- **und** Grün-Lauf, frischem Köder · **eine Welle ohne beißende Wache gilt als nicht abgenommen** · während W2 und W3 **null** CI-Last auf prod1 — *kontaminierte Daten sind die unheilbare Klasse*.

> **Die Abnahme-Regel:** Zu jeder Wellen-Abnahme gehört die Antwort auf **„was erzwingt das Halten?"**. Zulässig sind **ein Werkzeug** oder eine ausdrücklich als **ungedeckt** benannte Stelle. *„Wir achten darauf"* = **nicht abgenommen**.

**Der DURCHSTICH (F1):** ein am Mittwoch frisch gemessener Mini-Messwert liegt am Freitag als Tabellenzeile im Thesis-Submodul — durch `CSV → persist → xlsx → anhang:forward → PDF`, jede Stufe mit Nenner. **Ein Durchstich beweist mehr als jede Einzelwache.**

---

## VIII. DER TDD-VERTRAG *(neu über §12)*

> **Abdeckung misst Berührung. Wir messen Beißfähigkeit — mit gefahrenem Biss.**

Von den fünf Defekt-Familien war **dreimal der Test selbst der Defekt**. `test_commands.cpp:183-190` sichert Welch `t=0, p=1` über konstanten Gruppen als **Sollverhalten** zu; `SummarizeEmptyZeroWinRate` zementiert `win_rate=0.0` über leerer Menge. **Eine Abdeckungszahl hätte in allen drei Fällen gut ausgesehen.**

**T-1** ROT ZUERST · **T-2** AUSSAGE, NICHT ANWESENHEIT · **T-3** NENNER, FREMD · **T-4** GEGENEINGANG · **T-5** ORAKEL UNABHÄNGIG · **T-6** SCHWESTERPFLICHT · **T-7** REGISTRIERUNG IST TEIL DES TESTS · **T-8** ATOMARE LANDUNG · **T-9** TESTKRITIK.

**Sieben Testklassen, 117 Posten, 386 h:** `keine-negativprobe` 29 · `anwesenheit-statt-bedingung` 25 · `kein-nenner` 23 · `unerreichbarer-block` 16 · `test-zementiert-defekt` 10 · 12 weitere · 2 Einzelfälle.

**Was die Methode belegt:** 157 Behauptungen → 117 bestätigt, **40 gefallen** (ein Viertel), **62 Funde hatte erst die Meta-Stufe**.

> **Einstufige Kritik verliert am Objekt ein Viertel ihrer Behauptungen und übersieht zusätzlich mehr als die Hälfte ihres Fundvolumens.**

**13 der 40 Gefallenen waren Fehler der ersten Schärfungsstufe selbst.** **Ein Testentwurf ist eine Behauptung wie jede andere.**

**Codex:** nur auf frisch gepinntem SHA, beide Repos, `tests/` gesamt · Output ist **Kartierung, nie Zitat** · **Meta-Stufe Pflicht** · je Welle ein Pass über die neuen Tests der Vorwelle · **nicht** für Aufwandsschätzung, Wellen-Zuordnung, Owner-Entscheide.

### ⚠️ Der bekannte Engpass

**W1 trägt 99 h Band A auf einer Woche, die schon mit 26 von 27 Werktagen gefüllt ist.** Reißt W1, reißt der Freeze — und mit ihm die Kette dahinter. **Dort gilt Band B als nicht eingeplant** (nicht „nachrangig"); wird es eng, fallen die 62 h geschlossen nach W7 — **mit Zahl im Protokoll**, nicht durch Weglassen.

---

## IX. STAND DER DEFEKTE

| ID | Gegenstand | Stand |
|---|---|---|
| **D3** | leeres Messfenster als Erfolg | **geheilt** `super ce7d4007` |
| **D4** | Drift-Gate bei Median 0 | **geheilt** `ce 5922bb99` |
| **D3-5** | `[MESS-TESTAT]` unbedingt gedruckt | **geheilt** `ce 7bcf353b` |
| **D1** | `make check` ohne Reconfigure | **FEHLBEFUND** — zweifach widerlegt |
| **D2** | Abdeckungs-Wache | **offen** — 18 Registrierungen unter 14 Bedingungen, `STATUS_OUT` deckt **2** |
| **D5** | fünf Median-Implementierungen | **offen** |
| **D3-4** | Gate in `allow_failure`-Job wirkungslos | **offen** — eigener Folge-Job |

~~`allow_failure` am Mess-Batch ist **korrekt** — es zu entfernen wäre eine **Regression**.~~

> ⚠️ **KORREKTUR-EINSCHUB 09.08.2026 — dieser Satz ist WIDERLEGT; er bleibt als Wortlaut stehen,
> weil dieses Dokument verbatim ist.**
> Owner-Direktive OV-16, wörtlich: *„Das ist falsch, allow failure ist verboten … allow failure war
> schon IMMER verboten."* Dreifach im Roh-Transkript belegt (06.07. · 26.07. · 09.08.).
>
> **Die Verwechslung, aus der der Satz entstand:** die Sichtbarkeits-Doktrin galt der **CSV-ZELLE**,
> nicht dem **CI-JOB**.
>
> | Ebene | Verhalten bei einem Messfehler |
> |---|---|
> | **CSV-Zelle** | trägt `failed` (nicht `null`), plus Warnung an den Anwender, Messung wird übersprungen |
> | **CI-Job** | fällt **immer hart rot** — nie `allow_failure` |
>
> *Owner (09.08.): „Wenn dann muss ein Fehler sauber mit einer Warnung an den Anwender angezeigt und
> die Messung übersprungen werden, aber der CI job failed immer hart."*
>
> **Warum dieser Einschub nötig ist, obwohl das Dossier längst korrigiert wurde:** zwei andere
> überholte Stellen dieses Dokuments (die „Ein Blech"-Regel und die D2-Zahl) tragen bereits
> Korrektur-Einschübe — **diese nicht**. Wer die Lesefassung als Einstieg nimmt, was ihr Zweck ist,
> hätte hier die widerlegte Fassung gelesen und die beiden anderen für vollständig gehalten.
> Der Code hat das Dossier ohnehin überholt: `ce a558e87c` entfernt `allow_failure: true` aus der
> emittierten Mess-Job-YAML. **Offen bleibt eine zweite, lebende Stelle:** `super .gitlab-ci.yml`
> (`ergebnis:holen`, `when: manual`) — eigener Posten, nicht mit diesem Satz verwechseln.

> **NACHTRAG 09.08.2026 (Posten D2-G4) — die Tabelle oben bleibt wörtlich stehen, eine Zahl darin
> ist überholt.** Zeile **D2**: `18` Registrierungen unter `14` Bedingungen ist am Objekt
> **bestätigt** (drei ce-Stände, `scripts/ci_abnahme06_bedingungs_tabelle.sh`). „`STATUS_OUT` deckt
> **2**" ist **falsch** — gedeckt sind **4 von 18** (22 %). Die 2 traf die zwei STATUS_OUT-Blöcke
> **ohne** Test-Registrierung (`_pa_status`, `_fj_status`, in jeder CI unerreichbar), nicht die
> gedeckten Registrierungen. Der Teilposten **D2-G4 ist erledigt**; geltende Fassung der Abnahme
> ##06 ist die Fußnote D2-G4 in `docs/plaene/20260808-WELLENPLAN-ENDFASSUNG-v2-geschaerft-fable5.md`.

---

## X. BERICHTERSTATTUNG

Nach jedem Paket, ohne auf Antwort zu warten: **was gelandet ist** (SHA) · **womit belegt** (Nenner, Köder, literale Ausgabe) · **was widerlegt wurde** (auch eigene frühere Aussagen) · **was offen bleibt**.

**Eine Korrektur an der eigenen Arbeit ist der Regelfall, kein Makel.**

---

> **Dieses Goal ist erfüllt, wenn am 15.09.2026 eine Diplomarbeit abgegeben ist, in der jede ausgewiesene Zahl von einer Messung gedeckt ist, die älter ist als der Satz, der sie behauptet — und in der jede Regel, die das sichert, in einem Werkzeug steht und nicht in einem Kopf.**

---

Ich beginne jetzt mit **W-1 / ST-CTestWache**, dem Eingangs-Gate des Plans. Dabei ist die Divergenz zu klären, die §12.4 offen führt: Material erwartet 429 → 456, §1 zählt 428 + 27 = 455. **W-1 erhebt neu und benennt beide Nenner.**
