## VERDIKT: ENTSCHIEDEN

Die "Sieger-Semantik" (globaler Einzelsieger je Metrik, gemittelt über alle Lasten, vs. Sieger JE Eingangslast, mehrere gleichzeitig) ist Owner-entschieden — mehrfach, unabhängig voneinander, mit steigender Präzision über drei Termine (05.08. → 06.08. → 09.08.abends). Die im Auftrag zitierte Formulierung "Der Fork ist real und nicht aufgelöst" (Ledger:16744-16747, aus `docs/plaene/20260809-HYBRID-bauplan-und-entscheidungsvorlage.md`, NACHTRAG 09.08.) beschreibt eine **Code-vs-Entscheidung-Lücke** (`best_binary_selector`/`rank_binaries` ist noch nicht umgebaut), keine offene Design-Frage. Der Ledger selbst korrigiert das explizit unter der Überschrift "DREI POSTEN WAREN BAU-RUECKSTAND, KEINE ENTSCHEIDUNG".

## Owner-Wort wörtlich (drei unabhängige Fundstellen, konvergent)

**1) Ledger:15406-15414, Überschrift "09.08.2026 (abends) — DIE KETTE IST LÄNGER: zwei symmetrische Zweige nach AUSWERTEN (Owner)":**
> „Die Kette ist vollständig korrekt, aber nach auswerten kommt erst single bauen → single messen → single compare → single release optimal Tier-Binary für JEDE gemessene Last der Mess-Achse → Hybrid-Tier-Binary für optimale heuristische Performance multipler heuristisch erkennbarer Eingangslasten bauen → Hybrid-Tier-Binary messen → Hybrid-Tier-Binary compare → Hybrid-Tier-Binary multi release. […] wir müssen erst für jede Last das optimale Tier-Binary kennen, um über gemischte Lasten je erkannte Last automatisch über das hybrid anzupassen."

Explizierung direkt daneben (Ledger:15455-15456): „RELEASE heißt ‚das Optimum je Last', nicht ‚veröffentlichen'. Der single-Release ist eine Auswahlentscheidung je Last der Mess-Achse; der Hybrid-Release ist ein MULTI-Release."

**2) Ledger:22900-22906, Abschnitt "06.08.2026 abend-4", Owner-KERN verbatim:**
> „Die erste Stufe der Rangbildung ist, dass die Tier-binaries einfach direkt drangehaengt werden. Aber was passiert bei gemischten Lasten des Suchalgorithmus? Dann muss dieser jede Linie an Last-Kanaelen einwandfrei unterstuetzen und das braucht dann nicht nur eine, sondern multiple optimale binaries je Last-Kanal, daher der Hybrid-Schaltungs-Adapter dazwischen, der die richtige Tier-Binary waehlt."

**3) Ledger:22557, "05.08.2026 nachmittag-1", Owner-Nachricht verbatim (Auszug):**
> „…die Messwerte zu Messkurven synthetisiert, die Messskurven je Eingangslast verglichen, um die beste binary zu finden […] An dieser stelle koennen dann auch ueber multiple Lasten multiple beste Binaries bestimmt werden, die ueber eine Erkennungsheuristik der Last ein Hybrid-Tier-binary zur aktiven runtime Auswahl der optimalen Tier-Binaries erzeugt."

**Bestätigende Selbstkorrektur des Ledgers, Ledger:25899-25901 (Abschnitt vom 07.08., zeitlich VOR dem 09.08.-Bauplan, unter "3. DREI POSTEN WAREN BAU-RUECKSTAND, KEINE ENTSCHEIDUNG"):**
> „T-8 ‚beste Binary' = PARETO-FRONT, entschieden 10.07. (einer von 7 Forks). IST: `rank_binaries` im best_binary_selector rankt Einzelsieger je Metrik."

Und die Methoden-Lehre daraus (Ledger:25992): „‚Offene Frage' und ‚Bau-Rueckstand' sind verschiedene Dinge" — exakt die Unterscheidung, die diesen Fall auflöst. Selbst der Bauplan, der die Fork-Formulierung trägt, enthält an anderer Stelle (Zeile 96) bereits dasselbe zweistufige, entschiedene Modell ("Stufe 1 [homogene Last] = EINE beste Binary je Schnitt … Stufe 2 [gemischte Lasten] = multiple optimale Binaries, je eine pro Last-Kanal — der Hybrid-Schaltungs-Adapter wählt zur Laufzeit") mit eigenem (inzwischen durch spätere Prepends verschobenem, aber inhaltlich identischem) Ledger-Verweis.

## Was daraus für den Bau folgt
`best_binary_selector.cpp`/`rank_binaries` muss umgebaut werden, um **je gemessener Last** einen Sieger zu küren (statt eines global über alle Lasten gemittelten) — Ergebnis ist eine **Menge** optimaler Binaries (eine pro Last-Kanal). Diese Menge bildet den single-Zweig-Release; der Hybrid-Zweig fasst sie zu **einem** Multi-Release/Schaltungs-Adapter zusammen, der zur Laufzeit per Last-Erkennungsheuristik zwischen ihnen wählt. Der Ledger führt das explizit als Bau-Rückstand (Ledger:25955-25956: „T-8 Pareto statt Einzelsieger" in der Bau-Rückstandsliste), nicht als zu klärende Owner-Frage.

## Einordnung der vier Kandidaten aus dem Auftrag
- **(a) "beste Binary je Lastprofil"** — BESTÄTIGT als tragende Textspur: Thesis `06_evaluation_methodology.tex:173` ("Zielgröße ist die je Lastmuster gemessene Bestleistung"; Kapitel trägt DEPRECATED-Kopf, aber laut eigenem Vermerk vollständig in den aktiven Korpus [05_evaluation, 03_messsystem_prtart, 04_implementierung, 06_fazit] übernommen — "NICHT reaktivieren; nie loeschen") sowie `docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md:330` ("liefert: je Lastprofil x Binary die Gesamtzeit").
- **(b) Pareto-Front-Entscheid 10.07. (H6)** — real entschieden (Ledger:19210, "7 FORK-ENTSCHEIDUNGEN"), aber löst eine **andere** Achse: Mehrfach-Zielgrößen/Metrik-Ebene (T5/T6/T18, `tuple<property,time,objective_tag>`, `docs/architektur/20_HEURISTIK_...md:134/:161`), nicht die Last-Dimension. Der Ledger benutzt "Pareto-Front" als Kurzformel für "T-8 weg von Einzelsieger", die eigentliche Last-Dimension wird aber direkt durch die drei Owner-Zitate oben entschieden. Die im Auftrag zitierte Phrase „die Front ist das Ergebnis" ist im Korpus **0 Treffer** — nicht verifizierbar als Owner-Verbatim.
- **(c) xlsx/Export je Sheet = Unter-Achsen-Permutation** — nebensächlich: Layoutfrage der Ausgabe, keine Entscheidung über den Selektions-Algorithmus.
- **(d) UltiHash** — nicht einschlägig: der einzige Treffer (Ledger:12431) ist eine Urheberschafts-/Firmen-Zuschreibung ("das Achsen-Konzept stammt aus einer Vorarbeit des Autors, Comdare/BEP Venture, UltiHash"), kein Deploy-Konzept. Die tatsächliche Auflösung "ein Deploy-Artefakt trotz mehrerer Last-Sieger" liegt in der Owner-Kette selbst: der Hybrid-Zweig bündelt die Je-Last-Sieger zu einem Hybrid-Tier-Binary (ein Artefakt, viele eingebettete Sieger) — kein durch Mittelung gebildeter globaler Einzelsieger.

## GEPRÜFT
- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — Volltext-Greps über alle 30597 Zeilen + gezielte Chronologie-Rekonstruktion der Nachtrag-Reihenfolge (reverse-chronologischer Kopf ca. Z.1-18397 vs. forward-chronologisches Ur-Segment Z.18398-30597) + Lesepassagen um Z. 3500-3530, 6100-6150, 12400-12440, 15400-15810, 16680-16800, 19200-19220, 20650-20700, 21060-21075, 22550-22920, 25630-26000, 26430-26580, 27260-27320, 29490-29560
- `docs/plaene/20260809-HYBRID-bauplan-und-entscheidungsvorlage.md` (Quelle der Fork-Formulierung, Volltext-Grep + Lesestellen)
- `docs/plaene/20260806-PLAN-break-even-und-drei-benchmark-ebenen.md` (Abschnitte 4-8 gelesen)
- `docs/plaene/20260808-GOAL-V8-DOSSIER-*`, `20260808-WELLENPLAN-ENDFASSUNG-v2-*`, `20260808-DESIGNPLAN-*`, `20260810-KONSOLIDIERUNG-*` (Grep auf Schlüsselbegriffe — kein eigener F8/beste-Binary-Abschnitt gefunden, Themenführung liegt im Ledger)
- `thesis/diplomarbeit/kapitel/de/06_evaluation_methodology.tex`, `02_fundamentals.tex` (inkl. DEPRECATED-Kopfvermerk)
- `docs/architektur/19_SCHICHTEN_...md`, `20_HEURISTIK_MESSKURVEN_TYPSYSTEM_UND_FILTERKETTE.md` (Grep + gezielte Zeilen zu Pareto/T5-T6-T18)

## NICHT GEPRÜFT
- `docs/sessions/backups/` Rohtranskript-Dumps zu den drei zitierten Terminen (05./06./09.08.) — nicht einzeln gegen die Ledger-Blockquotes gegengelesen (die Ledger-Zitate sind selbst als direkte Blockquotes formatiert und über drei unabhängige Termine konsistent, daher als ausreichend belastbar eingestuft)
- `docs/audits/`, `docs/termine/` Rohglossare
- ce (`Code/external/comdare-cache-engine`) — die tatsächliche IST-Implementierung von `best_binary_selector.cpp` wurde nicht gegengelesen (Auftrag war Entscheidungsstatus, nicht Code-Verifikation)
- `docs/architektur/21_SESSION_PLAN...`, `23_SYSTEMACHSEN...` nur per Dateiname/Grep erfasst, nicht inhaltlich vollständig gelesen