# ERGEBNIS — FRAGE D-2a (nearest-rank-KANON als kanonischer Statistik-Kern)

## VERDIKT: **ENTSCHIEDEN** — mit exakt dem einen eng umrissenen Rest, den die Frage selbst schon vermutet

Der nearest-rank-Kanon (Hyndman/Fan 1996 Typ 1, `k = ceil(q*n)-1`) ist als **der einzige** Quantil→Feld-Index-Umrechner im gesamten Auswertungsbaum entschieden **und gebaut**, live am heutigen HEAD beider Repos, seit dem 09.08. unverändert und seither in keiner der zehn nachfolgenden Konsolidierungsrunden (KON60…KON104, bis heute) in Frage gestellt.

---

## 1. Der Kanon selbst — ENTSCHIEDEN, GEBAUT, LIVE (Lead-Setzung, nicht Owner-Zitat)

**Fundstelle Code (objektiv, selbst gelesen, HEAD `04ac26fa8` von heute 07:23 UTC):** `Code/external/comdare-cache-engine/libs/cache_engine/builder/commands/latency_stats.hpp:26-34` — SELBSTCHECK-Block: *"ZUSICHERT: nearest_rank_index ist die EINZIGE Umrechnung Quantil -> Feld-Index im Auswertungs-Baum … Jede Perzentil-Zahl, die dieses Repo ausgibt, kommt ueber diese eine Funktion."* Commit `c98b4b95`, 2026-08-09 (D5-1). `git log` zeigt: seit diesem Commit wurde die Datei **nicht mehr angefasst** (letzter Touch 09.08., Stand heute 17.08.).

**Wer hat's gesetzt — Owner oder Lead?** Das Ledger beantwortet das selbst, explizit: `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:17592-17601` (NACHTRAG 09.08., Abschnitt K3): *"Die Formel `ceil(q*n)-1` (Hyndman/Fan 1996 Typ 1), die Median-Regel 'untere Mitte = Fall q=0.5' und der Interpolations-Ausschluss stammen **allein aus dem Bau vom 08./09.08**. Vier Linsen fanden unabhängig nichts Älteres, jede mit Gegenprobe."* Und wörtlich: *"Kein Rücknahme-Fall. **Die Index-Formel war neun Wochen lang unreguliert**."* — Das ist eine **Lead/Bauer-Entscheidung**, kein Owner-Zitat zur Formel selbst. Ich habe das unabhängig gegengeprüft: `grep -rl Hyndman`/`ceil(q\*n)` über `docs/sessions/`, `docs/plaene/`, `docs/termine/`, `docs/audits/` liefert **0 Treffer vor 08.08.**; ältere Treffer zu "nearest_rank" (z. B. 20260628, 20260711) beziehen sich nachweislich auf die **alte, seither gelöschte** `nearest_rank_p`/obere-Mitte-Funktion, nicht auf den neuen Kanon. Getragen wird die Entscheidung nur indirekt vom allgemeinen Owner-Dauersatz *"Invalidieren ist das Ziel, der Bruch muss laut sein"* (MEMORY: `feedback_bestand_invalidieren_ist_gewollt_kein_migrationszwang`) — der deckt das *Recht zu invalidieren*, nicht die *Formelwahl*.

**Baufolge:** `nearest_rank_p` (alt, `round(q*(n-1))`) wurde **ersatzlos gelöscht**, damit jede übersehene Aufrufstelle compile-time laut bricht — 38 Aufrufstellen betroffen, alle vor der Landung geprüft (`LEDGER:17286-17296`).

## 2. D5-2 (super delegiert statt kopiert) — ENTSCHIEDEN, GEBAUT, LIVE (nicht mehr "offen 12.08.")

Die 12.08.-Wellenkonsolidierung (`docs/plaene/20260812-WELLENKONSOLIDIERUNG-...md:31`) führte D5-2 noch als offen. Das ist **überholt**: Commit `08cab824` *"fix(D5-2): der Median-Kanon auf der super-Seite -- Aufruf statt Abschrift"* liegt in der Historie **beider** Konsumenten. Selbst gelesen und live bestätigt:
- `Code/common/percentile_canon.hpp` (super) — reine Aufruf-Fassade, **enthält keine eigene Rangformel**, `#include <cache_engine/builder/commands/latency_stats.hpp>`, delegiert an `ce_canon::nearest_rank_index`. Kommentar wörtlich: *"DIE ANTWORT DARAUF IST AUFRUF, NICHT BESSERE ABSCHRIFT."*
- `Code/04_csv_to_latex/csv_to_latex.cpp` und `Code/05_diagram_generator/diagram_generator.cpp` inkludieren beide `percentile_canon.hpp` und rufen `nearest_rank_median`/`nearest_rank_quartiles` an je 7-9 Stellen — **objektiv am Quelltext verifiziert, kein Doku-Zitat**.
- Das ce-Gitlink im super-Repo zeigt exakt auf den heutigen ce-HEAD (`04ac26fa8`) — die 98-Commit-Vendoring-Lücke, die D5-2/D5-3 am 09.08. noch blockierte, existiert nicht mehr.

Die HDR-Wiring-Aufgabe (D5-5, siehe unten) ist ebenfalls bereits gebaut: Commits `b2d0b5de`/`7cde00e6` (09.08.), Produktions-Konsument `libs/cache_engine/builder/commands/hdr_perzentil_auswertung.hpp` existiert (nicht mehr nur der Test).

## 3. REV-DATA-12 — Ihre Hypothese ist zutreffend: NUR NOCH die Architektur-Frage, nicht die Formel

Bestätigt an **drei unabhängigen Stellen**:
- `LEDGER:3525-3527` (KON60-NACHTRAG A, 14.08.): *"verankert ist seit D5-2 (08cab824) die using-Zeile … **REV-DATA-12 bleibt OFFEN** (ce-Selector lower_median, heute `best_binary_selector.cpp:196`, Aufrufer `:219/:221`)."*
- `LEDGER:13757`: *"`nearest_rank_median` — `:2551`; **nur Label-Drift gegen 'REV-DATA-12', inhaltlich gedeckt**."*
- **Live-Code, selbst gelesen**, `best_binary_selector.cpp:186-199` (unverändert seit `c98b4b95`, 09.08., kein Commit seither): *"ZUSICHERT: (n-1)/2 IST der Kanon-Fall q=0.5 … Dieses Werkzeug rechnet also seit jeher kanonisch … **ZUSICHERT NICHT: Gleichstand mit den super-Werkzeugen**… Das ist REV-DATA-12 und wird in D5-2/D5-3 im super-Repo geschlossen, NICHT hier."*

Die **Werte** sind seit D5-1 bewiesen identisch (Test `D51PerzentilKanon.MedianIstQGleichEinHalb`, n=1…64). Offen ist ausschließlich die **DRY-Architektur**: soll `lower_median` (eigene Lambda) durch einen literalen Aufruf von `ce_canon::nearest_rank_index`/`nearest_rank_quantile` ersetzt werden? Das ist ein reiner Bauposten (Abschrift→Aufruf), **kein Erkenntnis- oder Entscheidungsbedarf**, und er ist bis heute unangetastet (`git log` bestätigt: letzter Touch der Datei = 09.08.).

## 4. HDR-Zusage — Ort, Status, und "Gegenprobe-Nische" widerlegt

**Ort der Zusage:** Thesis, dreifach im gepinnten Stand `798e946`: `aufgabenstellung/de.tex:130`, `kapitel/de/03_messsystem_prtart.tex:552`, `kapitel/de/05_evaluation.tex:129`. Owner-Primärquelle **Termin 3, 09.04.**, nie widerrufen: *"Perzentile werden nicht gemittelt. **Je Lauf werden HDR-Histogramme persistiert**; Auswertung erfolgt auf den separaten Rohläufen oder über korrekt zusammengeführte Histogramme."*

**Der Wortlaut "HDR nur Gegenprobe-Nische" kommt im gesamten Korpus 0-mal vor** (geprüft) — er trifft nicht den dokumentierten Stand. Der dokumentierte Stand ist das Gegenteil: **Owner-Ruling 09.08.** (`LEDGER:17515-17527`, Rangfolge-Korrektur, wörtlich): *"Es gilt Owner > Plan > Thesis. Bei Konflikt gilt in der Regel diese Rangordnung, oder wo mehr Gründlichkeit erreicht werden kann, **ein merge zweiter Eigenschaften**. … Für D5-5 heißt das: … **Das Ergebnis (HDR bleibt und wird verdrahtet) steht** … HDR ist eine Erhebungsstruktur, der Perzentil-Kanon eine Index-Formel — zwei Schichten, **kein Gegensatz; beides zu führen ist gründlicher**."* Die Option "entfernen" wurde damit **rangwidrig gestrichen** (`LEDGER:634` Wellenplan, K1). HDR ist gleichrangige, pflichtgebaute zweite Schicht — bereits verdrahtet (s. Pkt. 2), nicht Nische.

## 5. Ein bereits geschlossener Nebenbefund, den Sie erwähnen sollten

Der K3-Konflikt (alte, ungültig erklärte p50/p95/p99-Zahlen stehen unmarkiert im lebenden Thesis-Anhang, `A_measurements.tex:46-49`, `bias_matrix_table.tex:2`) war seit 09.08. offen (`LEDGER:17588-17601`: *"nirgends festgelegt"*). Er ist **heute** entschieden worden — als "D-6" der **heutigen 20er-Owner-Vorlage** (`docs/sessions/20260817-OWNER-VORLAGE-fragenbuendel-parallelstart.md:277-292`; Owner-Antwort `LEDGER:24-25,45-46`, KON104): *"D-6: Wie empfohlen, wir muessen sie spaeter neu erheben"* → Altzahlen als überholt MARKIEREN, Neu-Erhebung mit der Kampagne ab 26.08.

## ⚠️ Nummern-Falle, ausdrücklich benannt

Das heutige **"D-2"** aus der 20er-Owner-Vorlage (KON104, *"D-2 KURVEN-STACKS: Owner braucht Kontext"*) ist **ein anderer Gegenstand** als Ihr **"D-2a"**: Es betrifft die drei Kurven-Fit-/Heuristik-Stacks (`heuristik/`, `builder/curve_fit`+`decision_lambda_trees`, `best_binary_selector`-Hälfte-B — Regressionsmodell-Auswahl für Hybrid-Tier-Selektion), nicht die Perzentil-Index-Formel. Ebenso ist die heutige **"C-3 best_binary-RICHTUNGEN"**-Antwort (KON103) über die **6 Selektor-Metriken** ein drittes, wieder anderes Thema. Keines der beiden berührt den hier untersuchten Kanon.

---

## GEPRÜFT / NICHT GEPRÜFT

**GEPRÜFT:** Ledger-Volltext (D5-1…D5-5, REV-DATA-12, HDR, K3, KON60/102/103/104) · Wellenplan v2 · MEASURESTORAGE-Design-Dossier · heutige Owner-Vorlage + Owner-Antworten · Live-Quellcode beider Repos (ce `latency_stats.hpp`, `best_binary_selector.cpp`; super `percentile_canon.hpp`, `csv_to_latex.cpp`, `diagram_generator.cpp`) am aktuellen HEAD · Git-Historie beider Repos (Commit-Daten, letzter Touch je Datei) · Korpusweite Gegenprobe auf "Hyndman"/"ceil(q*n)" vor 08.08. (0 Treffer). **NICHT GEPRÜFT:** die vollständigen Rohtranskripte hinter den vier "Linsen" des 09.08.-Selbstchecks (nur deren destillierte Ledger-Aussage plus eigene Gegenprobe); D5-4 (`delete_p99_ns`) im Detail, da außerhalb des D-2a-Scopes nur am Rand berührt.