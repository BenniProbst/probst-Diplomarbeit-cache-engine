## NACHTRAG 11.08.2026 NACHTS — KON14: ZWEI SYNTHESEN ÜBER DENSELBEN DATENSATZ, UND WAS SIE AN MEINER ARBEIT WIDERLEGEN

**Owner-Doktrin, während des Laufs gesetzt (Arbeitsweise v3.4 / A1):** *„bitte merke dir in Zukunft
immer mit **Fable 5 max** die Synthese auszuwerten."* Die laufende Opus-Synthese wurde zu Ende
geführt, die Fable-Fassung im selben Zug nachgeholt — **beide über denselben Datensatz** (6
Schnitte, 107 Funde, 35 Gegenproben). Beide sind gesichert.

**Die Fable-Fassung ist an den Belegen gründlicher:** sie hat vier Punkte **selbst am Objekt
nachgeprüft** statt sie zu übernehmen (S-6 an beiden Stellen · die sechs Marker-Träger · Wellenplan
§15.1 · die KON13-Wortlaute im Ledger-Kopf) und liefert vier Befunde, die Opus nicht hat.

---

### KON14-01 — 🔴 DREI MEINER EIGENEN MESSUNGEN SIND WIDERLEGT. ALLE AUS DERSELBEN URSACHE.

| Meine Aussage | Am Objekt | Warum ich falsch lag |
|---|---|---|
| *„`LagerBaumWriter` — 0 Aufrufer überhaupt, auch kein Test"* (KON11-01, KON12-03) | **9 Test-Aufrufe** in `test_lb0_lager_pfad_grammatik.cpp` über `make_binaries_baum_writer` / `make_messdaten_baum_writer` | Ich suchte den **Klassennamen**; die Tests rufen die **Factory** |
| *„die Compile-Zeit-Pflicht für `algo_version` ist nie gebaut"* | **18 Basis-Header** tragen `static_assert(requires { Derived::algo_version; })` | Meine Messung durchsuchte nur die **62 `concepts/`-Header** (dort 0 von 62) — der Zwang liegt in den **Basen** |
| *„7 Marker gegen 9 Lock-Einträge, Differenz nicht aufgeklärt"* (KON12-02) | **6 gegen 6, kein Rest** | Die 7 zählte den Prosa-Fehltreffer in `csv_cell_reader.hpp` mit, die 9 zählte **3 Kommentarzeilen** mit |

**Die gemeinsame Ursache ist genau die, gegen die Arbeitsweise A2.2 heute geschrieben wurde:** ich
habe über den **Namen** gesucht, nicht über den **Gegenstand**. *Kategorie 4 der Inventur („0
Aufrufer überhaupt") ist damit leer* — es gibt keine solche Position.

**Und die Falle mit den Schrägstrichen hat wieder zugeschlagen:** die erste Messung der
axes-Header lief mit `-path '*/build*/*' -prune` und fraß dabei `libs/cache_engine/**builder**/` —
**370 statt 371**. Per Gegenprobe gefangen. *Das ist derselbe Griff wie `grep -v /build`, der
`/builder/` frisst; er steht seit Wochen im Fallen-Register und ist heute erneut passiert.*

---

### KON14-02 — 🔴 S-6 IST GEBAUT UND FALSCH HERUM. AN BEIDEN STELLEN REPRODUZIERT.

    IST   anatomy_fingerprint_glieder(organ, system, measurement, ...)
          AnatomyVersionLines:  organ_line -> system_line -> measurement_line
    SOLL  MESS -> SYSTEM -> ORGAN   (Stufigkeits-Ordnung, Owner 11.08.)

**Von der Fable-Synthese an beiden Stellen unabhängig nachgemessen** (`anatomy_fingerprint.hpp` für
die Signatur, `anatomy_module_abi_v1_decl.hpp` für die POD-Feldfolge).

**Das ist preimage-wirksam und damit an F2 gebunden** — und **heute kostenlos**, weil nie eine
Flotte gebaut wurde. Nach dem Bau-Trigger am Mi 26.08. entwertet dieselbe Änderung 41,4 h Bau.
Posten **#87**.

---

### KON14-03 — 🔴 VIER UNMARKIERTE EINGRIFFE IN EINEM OWNER-ZITAT (KON9-11)

Die Fable-Synthese hat die Zitattreue von KON9-11 gegen das Rohtranskript geprüft — die Prüfung,
die KON13-08 ausdrücklich als **nicht durchgeführt** ausgewiesen hatte. Ergebnis: **vier
Eingriffe, keiner markiert:**

1. ein **fehlendes „Ja korrekt, "** am Satzanfang,
2. ein **still gestrichenes Wort** („Version"),
3. **zwei Satzumstellungen**,
4. ein **unmarkiert gekapptes Ende — vor einem Blocker-Folgesatz.**

**Der Kerninhalt (die Fünf-Rollen-These) bleibt gedeckt.** Aber Punkt 4 wiegt schwerer als eine
Formalie: **was abgeschnitten wurde, war ein Blocker.** Ein gekapptes Zitat kann einen Blocker
unsichtbar machen, ohne dass irgendwo eine Lücke entsteht.

**Das ist der dritte Fall dieser Klasse in einer Nacht** (nach E-1 in KON11-03 und der zweiten
Kürzung in KON9-06). ⇒ **Regel, ab sofort ohne Ausnahme: jede Kürzung in einem Owner-Zitat trägt
`[…]`. Ein still gekürztes Zitat ist ein verändertes Zitat.**

---

### KON14-04 — VIER ZAHLEN, NEU ERHOBEN

| Stelle | alt | neu | Nenner / Zählweise |
|---|---|---|---|
| KON9-05 | 295 `static_assert` | **294** | zwei Zählweisen; KON7-08 führte 294 bereits |
| KON9-05 | „137 Flag-Literale" | **123** | 97× `1.0.0.c` · 24× `1.0.2.c` · 2× `1.0.1.c`. **Differenz 14 unaufgeklärt**; die Kernaussage *„praktisch nur `c`"* ist identisch |
| KON2-19 | 124 | **130** | Header unter axes-Pfad mit Substring `algo_version`; davon **104 mit echter Zuweisung**, 26 nur Prosa |
| Task #89 | 13 Dateien / 7967 Z. | **14 / 8528** | `ci/tests/*.sh`; **0 von 14 retired** |

**Und die 130 sind nicht die bump-pflichtige Menge:** die belastbare Grundgesamtheit ist **152**
(130 axes + 22 Queuing-Varianten unter `topics/`). **0 von 123 Literalen tragen einen
Hardware-Anteil** — das ist der Gegenstand von O-1 und S-7.

---

### KON14-05 — DIE WACHE LIEF DREI WOCHEN FAKTISCH TOT

`tools/axis_version_lock` prüft eine **hartkodierte Sechs-Pfad-Liste aus der YAML** — kein
Autodiscovery —, SHA-256 über rohe Bytes, Substring-Parser. **Sie lief drei Wochen faktisch tot**
durch eine YAML-Doppeldefinition (Letzter-gewinnt) und ist erst seit dem **06.08.** vereinigt; die
zwei Fix-Commits `597ecffe` und `557d8023` sind **beide Vorfahren von HEAD**.

⇒ **S-14 ist damit doppelt entlastet:** die Wache existiert, läuft unbedingt, und die Fixes sind
gelandet. Was fehlt, ist allein der **Scope** — 6 von 152.

⇒ **Und die Frage nach der Bauform ist offen** (Fable-Frage 17): die heuristik-Wache um `axes/`
**erweitern** (ein Lockfile, ein Job, aber L5-Heuristik und Organ-Achsen in einem Regime) oder eine
**zweite Wache** daneben (saubere Stufen-Trennung, zwei Jobs). **Beide Lesarten sind mit dem
Owner-Wort „trennen UND verdrahten" vereinbar.**

---

### KON14-06 — DIE ENTLASTUNGEN, AUSGEWIESEN

**13 von 35 Gegenproben sind gefallen.** Sieben davon sparen Bau-Arbeit:

* **S-11** war als *„ungedeckte Regression"* geführt — das Interim wurde am **05.08. selbst
  geschlossen**, ist gebaut und wird gerufen. Rest: der Default-Pfad liest weiter `getenv`.
* Die zwei Wachen-Fixes galten als **ungelandet** — beide sind Vorfahren von HEAD.
* *„`hybrid/` = nur `README.md`"* stand an **drei** Ledger-Stellen — es sind **4 Header, 943 Zeilen**.
* *„`ExperimentPlanDirector` unangeschlossen"* — produktiv konstruiert.
* *„`run_selection_filter_chain` 0 Produktionskonsumenten"* — **4 Aufrufer**, der Einhängepunkt
  steht; leer ist nur die **Kette**, nicht die Verdrahtung.
* *„Drei Grammatiken je Phasigkeit"* — **zwei**, und eine existiert bereits.
* Die offene Differenz „7 gegen 9" — aufgeklärt.

**Zwei weitere Korrekturen an meiner Arbeit:**
* **KON10-01s Überschrift** *„D5 ist der Owner-Satz **wörtlich** vorweggenommen"* hält nicht — es
  gibt **kein geteiltes charakteristisches Wort**. Die Beziehung ist **konzeptionell**; der Kern
  hält. → „inhaltlich vorweggenommen".
* Der **`i_command`-Kopfkommentar** behauptet, eine ABI-Fläche konsumiere ihn *„hart"* hinter einem
  default-OFF-Gate. **Das Gate ist funktionslos** — `COMDARE_V32_ENABLE` wird **nirgends** per
  `#ifdef` abgefragt; wirksam ist allein `COMDARE_BUILD_TESTS` (Default **ON**).

---

### KON14-07 — WAS BEIDE SYNTHESEN ÜBEREINSTIMMEND SAGEN

**F-1 ist beantwortet** — die neue exakte Fassung ist KON13-01/02/03, verankert auf die
Owner-Nachricht **21:24:47Z**. Beide Synthesen zeichnen dieselbe Fassungskette über **sechs**
Stufen (05.08. mittag-9/10/11 → 06.08. Klärungsdokument STUFE-vs-PHASE → KON7-03 → KON8-01/02/12 →
KON9-04 → KON13).

**Eine unabhängige Bestätigung, die Fable zusätzlich fand:** sechs Minuten nach der Owner-Nachricht
korrigiert sich das Memory `feedback_ort_und_zeit_sind_zwei_ordnungen_nie_vermengen` (21:30:50Z)
**selbst auf exakt dieselbe Tabelle** — ohne dass die Tabelle dort vorlag.

**Für die System-Achse heißt „dehnbar" in der neuen Fassung keine Phasenzunahme mehr:** 2/2, weil
die CEB Hybrid und Tier **gleichrangig und parallel** bedient. Nur MESS dehnt sich (3→4 am Ort;
konzeptionell zwei parallele dreiphasige Verträge).

---

### KON14-08 — WAS AUCH JETZT UNGEPRÜFT BLEIBT

* Die **ältere Session-Linie `46375cdc`** (~300 MB, bis 06.08.) wurde **nicht direkt durchsucht**.
  Die übrigen 17 `.jsonl` waren als Gegenprobe leer; im Ledger gibt es **einen** Treffer
  „vier Parteien" — keinen zweiten unabhängigen Fundort der Formel.
* **S-4, S-8, S-10** — im gesamten Material **kein Befund**, nicht gemessen.
* Die **Einzelzuordnung** der 35 Gegenproben lag dem Synthese-Eingang nicht bei, nur die Bilanz.
* Die **Differenz 14** zwischen „137" und „123" Flag-Literalen ist unaufgeklärt.
* Der **Stunden-/Tage-Aufwand** von S-1…S-18 steht weiterhin an keiner Stelle.

---

### KON14-09 — DIE FRAGEN STEHEN BEI NEUNZEHN

Aus meinen ursprünglich vier sind es nach beiden Synthesen **neunzehn** — nicht weil neue Probleme
entstanden, sondern weil die alten **präzise** wurden. Sie liegen gruppiert vor: Grammatik/Stempel
(2, fristnah an K-1) · CI-Gerüst (5, blockieren S-12 vollständig) · Cache-Landschaft (8, vor jedem
S-13-Bau) · Inventur/Buchführung (4).

**Volltext beider Synthesen:**
`docs/sessions/backups/20260811-workflow-rohdaten-stempel-ci-konsistenz/synthese-nachtrag-{OPUS,FABLE}.md`

**Ein Befund entwertet eine meiner eigenen Empfehlungen:** die kursierende Zuordnung „Mini-Pipeline
je Träger-**Typ**" stammt **nachweislich von mir** — drei von drei Fundstellen sind
`type=assistant`, keine ist Owner-Wort. Sie steht in der Owner-Vorlage als Empfehlung bei O-10 und
ist als solche zu kennzeichnen.
