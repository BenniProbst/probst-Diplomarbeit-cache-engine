# D-2 KURVEN-STACKS — Kartierung der drei Statistik-/Kurven-Stacks (E-5) + Zusatz K4 mess/-S-Position

**Status:** reine Erhebung, read-only. Keine Datei geändert, kein Commit. `LEDGER` = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`. Alle Pfade relativ zu `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`, ce-Pfade unter `Code/external/comdare-cache-engine/` (READ-ONLY @ development `04ac26fa`).

**Vorab-Korrektur zur Auftragszeile:** Der Auftrag zitiert „Ledger:16327". Am Objekt steht dort ein anderer Absatz (OV-16 allow_failure, `LEDGER:16314-16327`). Der zitierte Satz *„welcher der drei Kurven-Stacks ist kanonisch? Ohne Entscheid entscheidet der Aufräumpass Par.75 implizit"* steht **wörtlich bei `LEDGER:16788-16790`**, nicht bei 16327. Die Zahl 16327 ist vermutlich stale (Ledger ist seit Auftragsformulierung gewachsen). Ich zitiere im Folgenden die verifizierte Stelle.

---

## 0. Kurzfassung

Es gibt am Objekt **genau drei real existierende, unabhängig implementierte** Median-/Perzentil-Rechnungen in der Auswertung, plus einen vierten Kandidaten (xlsx-Aggregat), der sich als **nicht existent** erweist:

1. **HDR-Histogramm-Stack** (ce, `builder/commands/hdr_perzentil_auswertung.hpp`, Konsument `apps/f15_compare`)
2. **best_binary_selector-Stack** (ce, `builder/best_binary_selector/best_binary_selector.cpp`)
3. **csv_to_latex/diagram_generator-Stack** (super, `Code/04_csv_to_latex` + `Code/05_diagram_generator`, seit 09.08. über `Code/common/percentile_canon.hpp` an ce gebunden)
4. **„xlsx-Aggregat-Strecke"** — am Objekt **nicht vorhanden**: der xlsx-Writer (`builder/lager_ablage/xlsx_ergebnis_writer.cpp`, 284 Z.) enthält **0** Treffer für median/percentile/quartile — reiner Zeilen-/Sheet-Schreiber. Die geplante eigenständige „Aggregation als Stack" lebt ausschließlich als **noch nicht gebautes** MeasureStorage/`measure_to_latex`-Modul (`LEDGER:16369-16383`: „Deep Research ausdrücklich beauftragt (Strang 30 läuft)"; 0 Treffer für `class/struct MeasureStorage` oder `measure_to_latex` im gesamten Repo).

Der aktuellste Ledger-Kopf (KON104, **heute** 17.08., `LEDGER:19,35-37`) bestätigt, dass genau diese Explore-Aufgabe bereits als „gestartet" geführt wird und die Gegenüberstellungs-Vorlage (drei Stacks + K4 mess/-S-Position) **heute** als eigenes Fenster folgen soll — mit einer expliziten Sperre: *„Bis dahin waehlt KEIN Aufraeumpass implizit (Par.75-Sperre)."* (`LEDGER:37`).

---

## 1. E-5 im Ledger — Fundstelle + Kontext

**Ort:** `LEDGER:16717` (Nachtrag-Kopf) bis `:16790` (Ende des E-5-Absatzes); die 60 Zeilen danach (`:16791-16848`) gehören zu einem **anderen, unverwandten** Nachtrag (Datenintegritäts-Alarm `COMDARE_GN_SIMD`) — nicht Teil von E-5s eigenem Kontext, nur zufällig im ±60-Fenster.

**Überschrift des Nachtrags** (`LEDGER:16717`): *„NACHTRAG 09.08.2026 — HYBRID: nicht 0 % gebaut, sondern 0 % ANGESCHLOSSEN. Und 14 Entscheide stehen davor."*

**Struktur:** Der Nachtrag listet 14 offene Hybrid-Entscheide. Eine Tabelle (`:16777-16786`) zeigt nur vier als „bau-blockierend" (E-1, E-2=K1, E-3=K2, E-4=K5) plus E-10 (`:16784-16786`, HY-A/B/C-Zerlegung, Frist war der Folgetag). **E-5 steht NICHT in dieser Blocker-Tabelle**, sondern als eigener Fließtext-Absatz danach:

> **`LEDGER:16788-16790`:** *„**E-5 ist der teuerste, wenn er ausbleibt:** welcher der drei Kurven-Stacks ist kanonisch? **Ohne Entscheid entscheidet der Aufräumpass §75 implizit** — und dann ist die Wahl getroffen, ohne dass jemand sie getroffen hat."*

Direkt davor, im selben Nachtrag, zwei Belege, die den Gegenstand vorbereiten:

- **`LEDGER:16744-16747`** (Sieger-Definition, nicht Median-Formel): *„Zwei unvereinbare Definitionen von 'beste Binary': `best_binary_selector` … kürt **einen globalen Sieger je Metrik, gemittelt über alle Lasten** — F8 verlangt **einen Sieger JE Eingangslast, mehrere gleichzeitig**. Der Fork ist real und **nicht aufgelöst**."*
- **`LEDGER:16002-16004`**: *„Und `csv_to_latex` ist KEIN totes Auslaufmodell. Es ist ein großes, aktives, getestetes Modul mit CLI und mehreren Konsumenten in der Thesis-Anhang-Pipeline. 'measure_to_latex bauen' heißt **Ablösung mit Migrationspfad**, nicht Neubau auf grüner Wiese."*
- **`LEDGER:16000`**: *„[IMeasurableWorkloadV3/ComdareSegmentLatencyV2] … dieselbe Klasse wie die **Kurven-Synthese bei HYBRID**: gebaut, getestet, nicht verbunden."* (Begriffs-Herkunft „Kurve" — Break-Even-Spline, nicht Bestandteil der D-2-Frage, aber Namensnachbar; siehe `LEDGER:16725`, Fritsch-Carlson-Spline.)

**Index-Verweise auf E-5** (bestätigen den Gegenstand, keine neue Substanz): `LEDGER:35-37` (KON104-02, **heute**) und `LEDGER:611-614` (KON96-03, „DREI ECHTE OWNER-FRAGEN"): *„(b) KURVEN-STACK (E-5 + K4, Z16005/Z15076): kanonischer Statistik-/Kurven-Stack der Auswertung festlegen (sonst entscheidet der Aufraeumpass implizit) + das nie gestellte K4 (mess/-Subsystem ohne S-Position) — GETRENNT vorzulegen."* Das bestätigt: E-5 (Kurven-Stack) und K4 (mess/ S-Position) sind **zwei separate** Owner-Fragen, die zusammen **in einer Vorlage** (Gegenüberstellung) erscheinen sollen — exakt der Auftrag D-2 samt Zusatz (b).

---

## 2./3. Die drei Stacks — Orte, Eingang, Statistik-Kern, Ausgang, Konsumenten

### Stack 1 — HDR-Histogramm

**Orte (Objekt):**
- `Code/external/comdare-cache-engine/libs/cache_engine/builder/commands/hdr_perzentil_auswertung.hpp` (309 Z., D5-5, 09.08.2026) — Kern
- `Code/external/comdare-cache-engine/libs/common/measurement/hdr_histogram_wrapper/vendor/` — gevendorte C-Library `HdrHistogram_c`
- Konsument: `Code/external/comdare-cache-engine/apps/f15_compare/main.cpp` (666 Z.)

**Eingang:** LIVE-Rohsamples `std::span<const int64_t>` (ns), direkt aus einer **in-Prozess ausgeführten** Permutations-`.so` via `IMeasurableWorkload::run_workload` (`f15_compare/main.cpp:15-49` Include-Kopf, `:479` „das p50-Ranking"). f15_compare liest **keine** CSV — es misst selbst. Als **einziger** der drei Stacks sieht dieser die echten Einzel-Latenzen; die anderen beiden sehen nur bereits aggregierte p50-Werte (Beleg unten, Stack 2/3).

**Statistik-Kern:** Bucket-Histogramm (`HdrGeometrie<sig_figures>`, `hdr_perzentil_auswertung.hpp:114-121`), hergeleitet aus `significant_figures`; `hdr_value_at_percentile` liefert die **Bucket-Oberkante**, keinen real gemessenen Wert. Explizite Toleranz-Herleitung `kRelativeToleranz = 1/half_count` (`:105-120`, für sf=3 → 0.0977 %). `PerzentilPaar` (`:130-139`) trägt **beide** Zahlen (Kanon UND HDR) + Abweichung + Toleranz-Urteil nebeneinander — bewusst **kein** Ersetzen des Kanons: *„Der Vergleich beider … ist die Gegenprobe gegen Überschärfe"* (`:34-35`). Nenner-Disziplin: `HdrAuswertung` führt `vorgelegt/aufgezeichnet/verworfen_null/verworfen_negativ/verworfen_ausserhalb` (`:147-152`) — honest-empty-Muster.

**Ausgang:** (a) Konsolen-Report (`f15_compare/main.cpp:571-593`), (b) optional `--hdr-out=DIR` → **eine** `.hdr.hgrm`-Datei je gemessenem Binary (`hdr_lauf_persistieren`, `hdr_perzentil_auswertung.hpp:256-307`; Verwurf-Kopf **vor** der Verteilung im selben Strom, `:230-238`), (c) optional `--csv=`/`--json=` — **eine andere Tabelle** (`stats::report_to_csv/report_to_json`, Welch/Holm-FWER-Vergleichsbericht, NICHT das WIDE-Schema).

**Konsumenten:** 0 Treffer im Repo für nachgelagerte Verarbeitung von `.hdr.hgrm`-Dateien oder f15_compares eigenem `--csv=`/`--json=` (kein Fund, keine CI-Wiring über `.gitlab-ci.yml`). Der HDR-Pfad ist ein Stand-alone-Diagnose-Ausgang der **compare-Phase**, ausdrücklich **nicht** an den golden-Messpfad angeschlossen (`hdr_perzentil_auswertung.hpp:43-54`: die Rohwerte sterben im golden-Pfad bereits in `harness/perm_runner.hpp:331-339` auf `{n,p50,p99,p999}` — dort ist HDR strukturell gar nicht mehr baubar).

---

### Stack 2 — best_binary_selector (ce-Selector, „Sieger-Kürung")

**Orte (Objekt):**
- `Code/external/comdare-cache-engine/libs/cache_engine/builder/best_binary_selector/best_binary_selector.hpp` (470 Z.)
- `.../best_binary_selector.cpp` (754 Z.) — `lower_median`-Lambda `:196-199`, stratifizierte Aggregation `:201-231`
- Tests: `tests/unit/test_best_binary_selector_parse_rank.cpp`

**Eingang:** WIDE-CSV-Zeilen (`;`-getrennt), gefiltert auf `two_phase_valid`; gelesen werden **bereits p50-aggregierte** Spalten `op_insert_p50_ns … op_rmw_p50_ns` (`best_binary_selector.cpp:97-102/150-154`). Keine Rohsamples.

**Statistik-Kern:** Exakter Rangwert, **eigene**, nicht-geteilte Formel `vals[(vals.size()-1)/2]` („untere Mitte", `best_binary_selector.cpp:196-198`) — **zweistufig**: Median je Zelle (`search_algo × workload`-Raster), dann Median der Zell-Mediane (`:212-221`), plus ein **Vollständigkeits-Gate**: ein Kandidat, der nicht alle beobachteten Zellen abdeckt, wird disqualifiziert statt aus leichten Restzellen zu profitieren (`:204-211`). Das Selbstcheck im Code (`:186-195`, datiert D5-1/09.08.) beweist die **Werte**-Äquivalenz zu `q=0.5` des Kanons für **jedes** n (getestet 1..64 in `test_d51_perzentil_kanon.cpp`, Fall `MedianIstQGleichEinHalb`) — bleibt aber **bewusst auf der eigenen Integer-Form**, weil hier über bereits aggregierte `double`-Kriterien gemittelt wird, nicht über ns-Rohsamples.

**Ausgang:** `manifest.txt` je gekürtem Binary (`median_ns`, `ranking_metric`, `cells`, `aggregation=median_of_cell_medians(nearest_rank_lower)`, `missing_cells_policy=disqualify(...)`, optional Pareto-Front — `best_binary_selector.cpp:527-544`) + Kopie der gewinnenden `.dll` (+ `.algos`-Sidecar) in `out_dir_`.

**Konsumenten:** **0 Treffer** für `best_binary_selector`/`best-binary` in `.gitlab-ci.yml` — der Tool-Aufruf ist in der geprüften CI-YAML nicht sichtbar (Standalone-Builder-CLI `best_binary_selector_main.cpp`, vermutlich Lager-/Deploy-seitig oder programmatisch aus dem CEB heraus aufgerufen). **NICHT GEPRÜFT:** ob andere Skripte/Shells außerhalb `.gitlab-ci.yml` ihn aufrufen — nur die YAML-Datei wurde durchsucht.

---

### Stack 3 — csv_to_latex / diagram_generator (geteilter Kanon)

**Orte (Objekt):**
- `Code/common/percentile_canon.hpp` (100 Z., D5-2, 09.08.2026) — der **geteilte** super-seitige Adapter
- `Code/04_csv_to_latex/csv_to_latex.hpp` (279 Z.) / `.cpp` (1439 Z.)
- `Code/05_diagram_generator/diagram_generator.hpp` (575 Z.) / `.cpp` (2164 Z.)
- Kanon-Ursprung in ce: `Code/external/comdare-cache-engine/libs/cache_engine/builder/commands/latency_stats.hpp` (148 Z., `nearest_rank_index` `:71-78`, `percentile_ns` `:82-88`)

**Eingang:** WIDE-CSV-Zeilen — **dieselbe** Datenform wie Stack 2 (`two_phase_valid`, `op_<art>_p50_ns`-Spalten; `csv_to_latex.cpp:301-352`, `diagram_generator.cpp:891-1008`). Zwei Grundgesamtheiten laut `percentile_canon.hpp:34-37`: (a) über **Messproben** (rohe `abs_`/`rel_`-Δ-Vektoren aus den CSV-Zahlen gebildet, `csv_to_latex.cpp:219/401/1242/1411`), (b) über **Konfigurationen** — Median **über bereits aggregierte** p50/p99-Werte je Algorithmus×Op-Art, also „Median über Mediane" (`diagram_generator.cpp:1883-1884`, `p50_median`/`p99_median`).

**Statistik-Kern:** **EIN** zentraler Kanon, `nearest_rank_index(n,q) = ceil(q·n)-1` (Hyndman/Fan Typ 1, 0-basiert; `latency_stats.hpp:68-78`), mit Rundungsschutz `rang_schutz` gegen IEEE-754-Kantenfälle (`:57-66`). super ruft ihn **nicht ab** (keine eigene Formel mehr) — `percentile_canon.hpp:74-98` (`nearest_rank_quantile`/`nearest_rank_median`/`nearest_rank_quartiles`) delegiert vollständig an `ce_canon::nearest_rank_index` (`:69,77,94-96`). Verankert per `using`-Zeile: `csv_to_latex.cpp:57`, `diagram_generator.cpp:710`. Eine eigene CI-Wache (`docs:anker-wache`, `.gitlab-ci.yml:1048-1057`, Skript `ci/anker_wache.sh`) hält diese Zeilennummern gegen Drift fest.

**Ausgang:** `.tex`-Fragmente (LaTeX-Tabellen, `\addplot`-Koordinaten, Forest-Plots, Pareto-Streuung, p50–p99-Spannen-Whisker) für den Thesis-Anhang.

**Konsumenten:** CI-gebunden und aktiv — `.gitlab-ci.yml:1481` (`cmake --build … comdare_csv_to_latex comdare_diagram_generator`), `:1564` (Integrationssmoke), `:2086-2306` (`appendix_generator_cli` konsumiert die erzeugten `.tex` für den Anhang, 12 Kern- + 5 Darstellungs-Fragmente je Sprache, `:2295-2296`), danach `06_latex_to_pdf` → PDF. Das ist die **einzige** der drei Stacks mit durchgehendem, geprüftem CI-Pfad bis zum Thesis-Artefakt.

---

## 4. Wo sie sich widersprechen — drei getrennte Divergenz-Typen

**Typ A — HDR vs. Kanon: deklarierte, tolerierte Methoden-Differenz (kein Bug).** Bucket-Oberkante (approximiert) vs. exakter Ordnungswert. Formal toleriert (±0,098 % bei sf=3, `hdr_perzentil_auswertung.hpp:105-120`), **aber mit dokumentiertem Extremfall**: bei vielen 0-ns-Samples (Timer-Auflösungsgrenze) liefert der Kanon exakt 0, HDR verwirft die Nullen VOR der Verteilung → *„maximal UNEINIG"* (Codebeispiel 400 von 780 Nullen, Kanon=0 ns, HDR≈464895 ns; `:161-168`). Diese Divergenz ist **absichtlich als Gegenprobe gebaut**, nicht als zu behebender Fehler — HDR ersetzt den Kanon nirgends produktiv (`f15_compare/main.cpp:562`).

**Typ B — best_binary_selector vs. csv_to_latex/diagram_generator: formal offen, aber wertgleich seit 09.08.** Formal getrackt als **`REV-DATA-12`** (P2, „Median-Divergenz", `docs/audits/20260716-wp5-rev-mining-DISPOSITION.md:58`), Status **„offen"**, zuletzt bestätigt am **14.08.2026** (`LEDGER:3526-3527`, KON60-Nachtrag A): *„REV-DATA-12 bleibt OFFEN (ce-Selector lower_median, heute best_binary_selector.cpp:196, Aufrufer :219/:221)"*. **Wichtige Präzisierung, am Code direkt verifiziert:** die Disposition-Tabellenzeile (`DISPOSITION.md:58`) beschreibt csv_to_latex/diagram_generator textlich noch mit der **alten** Formel „obere Mitte, rank=0.5·(n−1)+0.5" — das ist **stale**: seit D5-2 (Commit `08cab824`) rufen beide Tools den **nearest-rank-Kanon** (untere Mitte) auf, exakt wie `best_binary_selector`s eigene Formel. Für `q=0.5` sind beide Werte **mathematisch bewiesen identisch** (`best_binary_selector.cpp:186-195`, Test `test_d51_perzentil_kanon.cpp`). Offen bleibt **nicht der Zahlenwert**, sondern die **Architektur**: `best_binary_selector` ruft die geteilte Funktion nicht auf, sondern hält eine **eigene, unabhängige** Formel — exakt das „Abschrift statt Aufruf"-Muster, das `percentile_canon.hpp:6-18` für csv_to_latex/diagram_generator ausdrücklich behoben hat. Nichts erzwingt, dass beide bei einer künftigen Kanon-Änderung synchron blieben; ein A/B-Test, der `best_binary_selector.cpp`s Lambda **gegen** `percentile_canon.hpp` direkt gegeneinander laufen lässt, existiert nicht (nur die Index-Formel selbst ist bewiesen, nicht die beiden konkreten Aufrufstellen im Vergleich).

**Typ C — best_binary_selector vs. F8 (Sieger-Semantik, schwerer als die Formel-Frage).** `LEDGER:16744-16747`: `best_binary_selector` kürt **einen globalen Sieger je Metrik, gemittelt über alle Lasten**; F8 verlangt **einen Sieger je Eingangslast, mehrere gleichzeitig**. Das ist keine Formel-, sondern eine **Zweck**-Divergenz — *„der Fork ist real und nicht aufgelöst"* (wörtlich). Diese Spannung besteht unabhängig davon, ob Typ B je geschlossen wird: selbst mit identischer Median-Formel bliebe offen, WORÜBER (welche Population, welche Gruppierung) der Median gebildet werden soll.

---

## 5. Was der Aufräumpass §75 implizit wählen würde

Rein strukturell begründet (keine Owner-Setzung, meine Einschätzung aus dem Objektbefund):

Der **geteilte Kanon** (`percentile_canon.hpp` / ce `latency_stats.hpp::nearest_rank_index`) würde faktisch gewinnen — nicht weil er als „richtig" entschieden wäre, sondern weil er der einzige der drei Stacks ist, der **alle** folgenden Eigenschaften gleichzeitig trägt: (a) ce selbst führt ihn als *„DER KANON … EINZIGE Umrechnung Quantil→Feld-Index"* mit eigenem SELBSTCHECK-Vertrag (`latency_stats.hpp:26-34`), (b) er versorgt die **aktive, CI-bewiesene, nicht-deprecated** Thesis-Anhang-Pipeline (`csv_to_latex`/`diagram_generator`, oben Abschnitt 3), explizit als „KEIN totes Auslaufmodell" geschützt (`LEDGER:16002-16004`), (c) `best_binary_selector.cpp`s eigener Code rahmt sich selbst als das, was sich ggf. **anpassen** müsste, nicht umgekehrt (`:187-195`, „wird in D5-2/D5-3 im super-Repo geschlossen"), (d) HDR ist per Selbstauskunft ausdrücklich **kein** Ersatz für den Kanon, sondern eine Gegenprobe nur in der f15-compare-Nische (`hdr_perzentil_auswertung.hpp:20-35`).

Ein Aufräumpass, der ohne Owner-Entscheid entlang „was ist aktiv, getestet, nicht als tot markiert" räumt, würde also: den Kanon als de-facto-Standard für alles LaTeX-/Anhang-Nahe belassen; `best_binary_selector`s Formel-**Architektur**-Divergenz (Typ B) stillschweigend **nicht** anfassen (kein aktiver Wellenplan-Posten berührt das Tool derzeit — 0 CI-Wiring gefunden, siehe Abschnitt 3); HDR dauerhaft als Seitenkanal ohne Aufwertung in Richtung zitierfähiger Thesis-Zahlen belassen. Genau das ist die im Ledger benannte Gefahr: eine Wahl entsteht **durch Untätigkeit an den aktiveren zwei Dritteln**, nicht durch eine geprüfte Entscheidung über den dritten (F8-Zweck-Frage, Typ C) oder vierten Aspekt (MeasureStorage/`measure_to_latex` als geplanter Ersatz aller drei, `LEDGER:16371`: *„csv_to_latex darf es nicht mehr geben, sondern measure_to_latex"* — noch ungebaut).

---

## Zusatz (b) — K4: trägt `mess/` eine eigene S-Position im Zielstruktur-Schnitt?

**Nur Stand, keine Empfehlung**, wie beauftragt.

**Ausgangslage (K4, Register-Lücke, `LEDGER:8208-8209`, KON20-04, ~09.08.):** *„K4 das mess/-SUBSYSTEM (Steuerkanal, Konfiguration) hat KEINE S-Position — S-9/S-10 naheliegend, unbelegt. Zuordnen oder als 19. Position benennen."*

**Zwischenschritt (`LEDGER:6649-6652`, KON36/WF7, ~12.08.):** *„K4 das mess/-Subsystem hat keine S-Position (Klärung in der W1-Planung; durch KON34/B4 jetzt **teilweise beantwortet**: System B wird umgestellt und über den Builder angeschlossen)."*

**Aktuellster Stand (13.08., #29-Zielstruktur-Schnitt):** `docs/plaene/20260813-DESIGN-zielstruktur-vier-traeger-unterprojekte.md` (Commit `85c1174d`, verifiziert per `LEDGER:3216`). Die Besitzkarte (§2a) weist `mess/` explizit einer der **vier Träger-Stufen** zu:

> `docs/plaene/20260813-...:65`: **`mess/` | 6 Dateien | 1.140 Zeilen | TIER (3) | „genus_kaskade, steuer_dock, mess_naht = Tier-Laufzeit-Messkaskade (Fläche 3); Naht-TYPEN → Querschnitt, s. K2"**

Das ist **keine eigene/exklusive** Position: `mess/` teilt den TIER-Eimer mit `harness/` (`:66`), und die **geteilten** Naht-Typen (`MessEbene`, `MessCheckpointZeile`, Arena-Formel-PODs) sollen laut Vorschlag **in den Querschnitt** wandern (`:130`, K2 = „ZYKLUS builder↔mess", ein aktiver 3-Kanten-Include-Zyklus zwischen `builder/measure_storage/checkpoint_measure.hpp` und `mess/konfiguration.hpp`/`mess_naht.hpp`). Das Dokument führt diese Zuordnung explizit als **offenen Owner-Punkt**, nicht als Entscheid:

> `docs/plaene/20260813-...:179` (§6, Punkt 3): *„**mess/-Schnitt:** Default Kaskade→TIER, geteilte Naht-Typen→Querschnitt (löst K2); Zeitpunkt der Typ-Hebung: mit #18/S-13 oder erst #88."*

**Fazit STAND:** `mess/` hat heute (17.08.) **keine eigene S-Position** im Sinne der ursprünglichen K4-Frage (kein „19. Slot", kein dediziertes S-N). Es existiert seit 13.08. ein **Default-Vorschlag**, der es der TIER-Trägerstufe zuordnet (geteilt mit `harness/`) und seine Querschnitts-Typen auslagert — als **Default-Vorschlag**, ausdrücklich mit „Owner kann drehen" (`docs/plaene/20260813-...:175`), nicht als Freigabe. Der heutige Ledger-Kopf führt K4 weiterhin als offene, mit E-5 gebündelte Owner-Frage (`LEDGER:36`, `:611-614`).

**S-9/S-10-Nachbarschaft (Kontext, nicht Auflösung):** `LEDGER:5291` nennt S-9 = „CEB-Generierung" (Vier-Unterprojekt-Zielform); `LEDGER:4756-4758`/`4592`/`4694` beschreiben S-10 als **Steuerkanal**-Baustelle (Barriere-Protokoll, Control-Interface, Prioritätsklassen/OOB) — inhaltlich nahe an K4s eigener Beschreibung „mess/ (**Steuerkanal**, Konfiguration)". Ob S-10 das gesuchte Zuhause für den Steuerkanal-Anteil von `mess/` ist oder ein eigenständiger Posten bleibt, ist am Objekt **nicht entschieden** — reine Beobachtung, keine Wertung.

---

## Nebenbefund: Label-Kollisionen (Vorsicht bei Weiterverwendung)

Beide im Auftrag verwendeten Kürzel sind im Korpus **mehrfach belegt** — Fundstellenprüfung nötig, nicht die Nummer allein (`LEDGER:6613-6614`: „Nummern sind kein Autoritätsbeleg").

**„E-5" — drei verschiedene Gegenstände:**
1. Kurven-Stack-Frage (relevant hier): `LEDGER:16788-16790`.
2. „Posten 92 Registry-Kanon-Divergenz" (validate-2er vs. plan-3er): `LEDGER:25485`, unter NACHTRAG `:25479` (06.08.).
3. Owner-Zitat zur CEB-Zahlenkorrektur 6→12: `LEDGER:12803-12805` (W-3-Block, Owner 10.08. 07:27, „im Ledger 0 Treffer" vor diesem Zitat — der Owner nummeriert eine eigene, externe Liste, keine Ledger-interne).

**„K4" — mindestens fünf verschiedene Gegenstände:**
1. Register-Lücke „mess/ ohne S-Position" (relevant für Zusatz b): `LEDGER:8208-8209`, `:6649-6652`.
2. Hybrid-Design-Doc „Systemachsen-Framing" (seit 02.08. entschieden, dann superseded): `LEDGER:18474-18475`; explizit als eigene Verwechslungsgefahr benannt in `LEDGER:15815-15829` („LÜCKE 1 (HOCH) — ich habe K4 stillschweigend durch E-1 ersetzt").
3. §59-KERN-Mess-Schema „Director/Projektion" (Bau-Baustein K1–K8): `LEDGER:21544`, `:21558`.
4. OS-U3/OD-10 „K4-Fehlerklassen" (HardwareProbeErrorClass/CompilerCompilerErrorClass-Variant): `LEDGER:22047,22069,22100,22148,22152,23751`.
5. Das #29-Zielstruktur-Dokument selbst führt ein **eigenes lokales** K4 = „PLANER→TIER (1 Kante)" (Include-Richtungsverstoß, `docs/plaene/20260813-...:132`) — unabhängig von Gegenstand 1.

---

## GEPRÜFT / NICHT GEPRÜFT

**GEPRÜFT (am Objekt, mit Fundstelle):**
- Die drei realen Stacks (HDR / best_binary_selector / csv_to_latex+diagram_generator) samt Eingang/Kern/Ausgang, per direkter Lektüre der genannten Dateien.
- `percentile_canon.hpp` delegiert vollständig an ce, keine zweite Formel in super (Datei komplett gelesen).
- `best_binary_selector.cpp` hält eine eigene, nicht-geteilte Median-Formel, wertgleich zum Kanon bei q=0,5 (Code + Test-Referenz gelesen).
- REV-DATA-12-Status „offen" per 14.08. bestätigt, inkl. der Feststellung, dass die Divergenz inzwischen architektonisch, nicht mehr numerisch ist (drei unabhängige Quellen: Code, `DISPOSITION.md`, `LEDGER:3509-3530`).
- xlsx-Writer ohne eigene Statistik (Datei-Grep, 0 Treffer).
- MeasureStorage/`measure_to_latex` nicht gebaut (repo-weiter Grep, 0 Treffer).
- E-5-Fundstelle inkl. Korrektur der im Auftrag genannten Zeilennummer.
- K4-STAND inkl. #29-Design-Doc-Tabellenzeile und offenem §6-Punkt.
- CI-Konsumenten von csv_to_latex/diagram_generator (`.gitlab-ci.yml`, mehrere Stellen).
- Label-Kollisionen E-5 (3×) und K4 (5×).

**NICHT GEPRÜFT (Grenzen dieser Erhebung):**
- Ob `best_binary_selector` außerhalb von `.gitlab-ci.yml` (z. B. aus C++-Code des CEB heraus, aus Shell-Skripten unter `ci/` oder `scripts/`) programmatisch aufgerufen wird — nur die YAML-Datei wurde durchsucht.
- Ob ein direkter A/B-Regressionstest existiert, der `best_binary_selector.cpp`s Lambda und `percentile_canon.hpp` am selben Datensatz gegeneinanderlaufen lässt (nur die Index-Formel-Äquivalenz ist testbelegt, nicht die zwei konkreten Aufrufstellen im Vergleich).
- Exaktes Datum von KON96-03 (`LEDGER:606-619`) — aus der Ledger-Rückwärts-Ordnung als „nahe 16./17.08." erschlossen, kein expliziter Datums-Stempel an der Stelle selbst gelesen.
- Vollständigkeit der HDR-Konsumenten-Suche jenseits von Repo-Grep (z. B. externe/manuelle Auswertung der `.hdr.hgrm`-Dateien außerhalb des versionierten Baums).