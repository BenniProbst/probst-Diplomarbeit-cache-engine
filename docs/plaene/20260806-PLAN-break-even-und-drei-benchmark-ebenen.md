# Break-Even und die drei Benchmark-Ebenen

**Stand:** 2026-08-06, spaeter Abend. **Klasse:** PLAN-Dokument (Owner-Auftrag: *"das ist geplant und muss dokumentiert werden"*).
**Geltung:** Die Auswertung faellt **nach der Abgabe**; die Planung ist **jetzt** faellig und hier festgehalten.
**Beleg-Regel dieses Dokuments:** jede Aussage traegt Datei + Zeile. Wo der Plan schweigt, steht das ausdruecklich da — mit Nenner und Gegenprobe —, und erst danach folgt ein **als VORSCHLAG gekennzeichneter** Text, der keine Plan-Autoritaet hat.

**Basis-Pfade.**
`SUPER` = `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`
`CE` = `SUPER/Code/external/comdare-cache-engine`
`THESIS` = `SUPER/thesis/diplomarbeit`

---

## 1. Der Owner-KERN

### 1.1 Verbatim

> *"das ist als **'break even'** geplant. Es gibt **Schnittpunkte zwischen Parameter-Funktionskurven, die anzeigen, wann ein Algorithmus in einem Parameter ueber eine Achse als Organ effektiver wird.** Wenn wir das mit **gemischten Micro-Benchmarks ueber alle Achsen** (siehe Parameter Benchmarks der Achsen) und **Macro-Benchmarks** (siehe alle Achsen Parameter bei Aufruf einer beliebigen Funktion der verwendeten Achsen einer Gattung+Genus -> **Gesamt-Messprofile timed einer Funktion ueber die Schritte und checkpoints ihrer Ausfuehrung zur Detail-Analyse ueber alle Achsen die sie verwendet hat**) und **Macro-Benchmarking large scope ueber die Gesamtheit der Macro-Benchmark charts ALLER fuer ein Lastprofil aufgerufenen Gattung+Genus Funktionen auf dem Tier-Binary interface**. Bitte explore Agent dazu, **das ist geplant und muss dokumentiert werden**."*

Mitschrift im Ledger: `SUPER/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md:4584-4589` (Abschnitt `### 11. BREAK EVEN UND DIE DREI BENCHMARK-EBENEN`, `:4580`).

### 1.2 Die drei Ebenen, wie der Owner sie schneidet

| Ebene | Gegenstand | Was gemessen wird |
|---|---|---|
| **MICRO** | einzelne **Achsen-Parameter** | gemischte Micro-Benchmarks **ueber alle Achsen** — die Parameter-Benchmarks der Achsen selbst |
| **MACRO (timed)** | **eine** Gattungs+Genus-Funktion | alle Achsen-Parameter beim Aufruf; Gesamt-Messprofil **TIMED ueber die Schritte und CHECKPOINTS** ihrer Ausfuehrung, zur Detail-Analyse ueber **alle Achsen, die sie verwendet hat** |
| **MACRO large scope** | **ein Lastprofil** | die **Gesamtheit der Macro-Benchmark-Charts ALLER** fuer dieses Lastprofil aufgerufenen Gattung+Genus-Funktionen **auf dem Tier-Binary-Interface** |

Der Schnitt laeuft also nicht ueber *Instrumente*, sondern ueber **Gegenstaende**: Achse → Gattungs-Funktion → Lastprofil. Das ist fuer Abschnitt 6 entscheidend.

### 1.3 Der groessere Zusammenhang (Owner-KERNe desselben Abends, alle bindend)

Die Kette, verbatim aus dem Ledger-Bild `LEDGER:4229`:

```
  MESSUNG -> FUNKTIONS-SYNTHESE -> SCHNITT-KURVEN (break even) -> optimale Konfiguration
          == die zu WAEHLENDE Binary -> zurueck in den HYBRID als Schaltlogik
```

Und die Rolle der Hybrid-Binary, `LEDGER:4222-4225` (Bild der Dock-Kette): *"[HYBRID] laeuft (RT) Schaltungs-Adapter: waehlt je Last-Kanal"*. Sie braucht dafuer **multiple** optimale Binaries, nicht eine — `LEDGER:2692` (§49) gibt genau dafuer *"Array multipler Tier-Binaries hot an multiplen Docks + Verdraengungs-Strategie"* frei. Die Break-Even-Punkte sind ihre **Schaltlogik**, nicht ihre Empfehlung: `LEDGER:4575-4577` — *"Hybrid-Adapter braucht keine Empfehlung, sondern die Schnittpunkte. Sie sagen ihm, bei welchem Last-Kanal er umschaltet. Die Auswertung produziert eine Schaltlogik, keinen Rat."*

---

## 2. BREAK EVEN — was es ist

### 2.1 Die Definition aus dem Plan

`LEDGER:2301`, Ergaenzung zu §32-F8, verbatim:

> **"Break-Even-Mathematik:** Switch-Thresholds = **Schnittpunkte zwischen den f(x)-Spline-Funktionen** der Performance-Modellierungen zweier Algorithmen derselben Achse (Beispiel: Allokatoren fuer grosse vs kleine Dateien — Kurven uebereinandergelegt ergeben den Break-Even-Punkt). Da eine **voll permutierte Baum-Matrix** aufgebaut ist, ist der **Messwert-Diff jeder Ebene** bekannt und **gegen andere Parameter isolierbar** → ein **vollstaendig isolierbares Modell aus jeder einzelnen gemessenen Organ-Achse**, moeglicherweise mit erweiterter Interpretation unter Hinzunahme der System-Achsen."

Ein Break-Even-Punkt ist damit **ein Kipppunkt, kein Optimum**. Das ist im Code an der Datenstruktur ablesbar — `CE/libs/cache_engine/heuristik/break_even.hpp:43-48`:

```cpp
struct BreakEvenPoint {
    double x             = 0.0;        ///< Schnittpunkt-Position (Parameter-Achse)
    double y             = 0.0;        ///< Funktionswert am Schnittpunkt (Mittel aus f,g)
    Curve  links_besser  = Curve::Tie; ///< welche Kurve unmittelbar LINKS niedriger liegt
    Curve  rechts_besser = Curve::Tie; ///< welche Kurve unmittelbar RECHTS niedriger liegt
};
```

Der Punkt traegt **beide Fuehrungen** — links und rechts. Ein Optimum haette nur einen Gewinner. Die Konvention ist hart fixiert, `break_even.hpp:17`: *"KONVENTION 'besser' = KLEINERER y-Wert (Performance: niedrigere Latenz/Kosten ist besser)."*

### 2.2 Status im Plan

- `LEDGER:2296` — §32-F8 **ENTSCHIEDEN, ABGABE-PFLICHT**: *"Die Messungen muessen eine **Spline-Funktion auf jeder Achse** fuer die Modellierung der wichtigsten gemessenen numerischen Parameter bereitstellen, um diese Funktionen als **Heuristik-Abschaetzung** zu nutzen: bei Eingabe einer Anfrage auf das Interface (klassifizierte Operationen x Workload) **rueckwaerts die optimale Binary mit den optimalen Algorithmen-Saetzen** ... zu laden."*
- `LEDGER:2692` — §49: Break-Even-Uebergangs-Optionen **1 UND 3** freigegeben, Option 2 implizit.
- `LEDGER:2696` — §49-KORREKTUR: `std::variant` **nicht** fuer Break-Even-Algo-Swapping der Messkommunikation, nur fuer Pruefdock-Vertragsvarianz.
- `LEDGER:2958` — Status: *"Break-Even = Spline-Schnittpunkte (**ENTSCHIEDEN / IMPL-OFFEN**, hoch)"*.
- `LEDGER:3284` — Ziel des Gesamtprojekts: *"Messwerte -> **Break-Even-Heuristik** -> Hybrid-Tier-Binaries -> final schnellste Binary aus dem Mess-Modus."*
- `LEDGER:3602` — §75-NICHT-KANDIDATEN: `heuristik/axis_spline.hpp`, `heuristik/break_even.hpp`, `heuristik/measurement_curve_loader.hpp` duerfen im Abschluss-Aufraeumpass *"weder entfernt noch umbenannt"* werden — *"Speisung des Break-Even-Routers HY-B2"*.

### 2.3 Die Bruecke zu H2 — am Termin-Text belegt, nicht behauptet

**H2, eingefrorene Hypothese, Termin 1 (30.03.2026), verbatim:**

> *"H2: Es gibt **keine universell beste** lokale Seitendarstellung; die beste Wahl haengt von lokaler Dichte, Praefixstruktur, Zugriffsmix, Anwendungsdatensatz und Zielarchitektur ab."*
> — `SUPER/docs/termine/20260508 Termin 7/_extracted_text/20260330 Termin 1__20260330 Literatur_und_Arbeitsplanung_PRT_ART_Termin1_START_CoCo_sort_compact.docx.txt:7` (Vorfassung identisch in `20260323 Literatur_und_Arbeitsplanung_PRT_ART_Termin1_final.docx.txt:6`, ohne "Anwendungsdatensatz und Zielarchitektur")

**Wenn es keine universell beste gibt, lautet die Frage nicht "welche ist die beste", sondern "ab wo ist welche besser".** Genau diese Frage stellt schon die Forschungsfrage des Exposes:

> *"Wie sollten direkte, kompakte und HOT-inspirierte Patricia-/Mehrbit-Seiten kodiert werden, und **wann sollte zwischen ihnen umgeschaltet werden?**"*
> — `20260330 Termin 1__20260326 Expose_Diplomarbeit_PRT_ART_CPU_only_Habich_HOT_cacheline_final.docx.txt:9`

Die Termin-Kette macht daraus schrittweise einen **Messgegenstand**, und zwar in genau dieser Reihenfolge:

| Termin | Fundstelle (`_extracted_text/…`) | Wortlaut |
|---|---|---|
| **T1** (30.03.) | `…Technische_Skizze_Habich_termin1_START_CoCo_sort_compact.docx.txt:27` | *"Kriterien bzw. **experimentelle Schwellen** fuer den Wechsel zwischen Seitentypen"* — als einzufrierender Punkt |
| **T2** (05.04.) | `…Architekturentscheidungen_Termin2_final.docx.txt:57` | Invariante **I5**: *"Seitentyp-Umschaltungen sind explizite Policy-Entscheidungen; **feste universelle Schwellwerte werden nicht behauptet.**"* |
| **T2** | ebd. `:13` | *"Fuer Termin 2 reicht ein konkretes **Kostenmodell-Geruest**; **numerische Schwellwerte werden erst in Termin 3 kalibriert.**"* |
| **T2** | ebd. `:65` | Risiko: *"Architekturabhaengigkeit \|\| **Schwellwerte kippen je CPU** \|\| Hardwareprofile und Messkalibrierung statt universeller Konstanten."* |
| **T3** (09.04.) | `…Arbeitsaufstellung_PRT_ART_Termin3_final.docx.txt:79` | Workloadfamilien-Tabelle: *"Value-Modi \|\| inline, external handle \|\| **Umschaltpunkt explizit vermessen**"* |
| **T4** (12.04.) | `…Scope_Freeze_Termin4_final.docx.txt:29` | *"Inline-Values bleiben Pflichtachse der Arbeit; der **Umschaltpunkt wird global, pro Seitentyp und pro Node-Familie parametrierbar** gedacht."* |
| **T5** (12.04.) | `…Forschungslandkarte_Cache_Engine_Termin5_final.docx.txt:60` | **R2**: *"Plattformkalibrierung vor dem produktiven Betrieb ist wissenschaftlich gut begruendbar; **universelle Schwellwerte sind es nicht.**"* |
| **T6** (16.04.) | `…Termin6_Scope_Freeze_final.docx.txt:45` | Kalibrierungs-Familie: *"Working-set staircase; stride sweep; … → L1/L2/L3/DRAM-**Knicke** … liefert **Grundwahrheiten fuer Schwellen**, Prefetch und Poolwahl"* |
| **T6** | ebd. `:9` | Modus 1 *"feste Schwellen ohne Plattformkalibrierung"* / Modus 2 *"Warm-up-kalibriert … daraus folgen feste Plattformregeln"* / Modus 3 *"online adaptiv … laufende **Rekalibrierung/Umschaltung**"* |

**Damit ist die Bruecke belegt, nicht behauptet:** H2 sagt, dass es keinen universellen Gewinner gibt; I5/R2 verbieten ausdruecklich, feste Schwellwerte zu *behaupten*; T3 macht den Umschaltpunkt zur **Messgroesse**; T6 nennt die Kalibrierung, aus der die Schwelle folgt. **Break-Even ist die operative, messbare Form von H2** — es verwandelt eine plausible Behauptung ("es kommt darauf an") in eine pruefbare Zahl ("ab x = 80 fuehrt B").

**Ein wichtiger Nachbar-Befund, wortgleich in der Literatur:** die Paper-Extraktion kennt denselben Begriff auf Englisch — `crossover point` bei der Wahl zwischen linearer und binaerer Suche in Abhaengigkeit von Node- und Key-Groesse (P14-Samuel 2005, `_review/papers/P14-Samuel2005.md`, Abschnitt `### Crossover Points`). Der Begriff ist in der Datenbankforschung etabliert; die Arbeit erfindet ihn nicht.

### 2.4 Wichtige Praezisierung: welcher Schnitt geplant ist — und welcher nicht

Der Owner-KERN nennt Schnitt-Kurven *"zwischen Parametern verschiedener Achsen **und** der Gattungs-/Genus-Funktionsinterfaces"*.

**Geplant und gebaut ist bisher ausschliesslich der Schnitt INNERHALB einer Achse:**
- `break_even.hpp:3`: *"Schnittpunkt-Finder zweier AxisSpline f/g **DERSELBEN Organ-Achse**"*
- `LEDGER:2301`: *"zweier Algorithmen **derselben Achse**"*

Die Ausweitung auf **achsen-kreuzende** Schnitte steht im Ledger nur im **Konjunktiv**: *"**moeglicherweise** mit erweiterter Interpretation unter Hinzunahme der System-Achsen"* (`LEDGER:2301`). Ein Schnitt auf **Gattungs-/Genus-Funktionsinterface**-Ebene ist an keiner Stelle spezifiziert. Der zweite Implementierungsstrang (`best_binary_selector`) schneidet zwar ueber **ganze Kandidaten-Binaries** hinweg (`best_binary_selector.hpp:360` `break_even_table`), das ist aber die Binary-Ebene, nicht die Achsen-Parameter-Kreuzung.

⇒ Daraus folgt **offene Frage O-1** (Abschnitt 9).

---

## 3. Die drei Ebenen — je einzeln ausbuchstabiert

### 3.1 MICRO — Parameter-Benchmarks der Achsen

#### Was der Plan sagt

**Gegenstand:** eine Achse, vermessen ueber **ihr Achsen-Interface** — die Funktionsmenge, die *alle* Algorithmen dieser Achse liefern muessen.

Gesetzte Aufgabenstellung, `THESIS/aufgabenstellung/de.tex:87-92`:
> *"\emph{Micro-Benchmarking} (jeder einzelne Entwurfsbestandteil wird — innerhalb der Suchalgorithmus-Huelle wie der Algorithmus-Kategorie-Huelle — in jeder gemeinsamen Interface-Funktion seiner Kategorie **isoliert gegen Lastprofile gemessen**; die Algorithmen der Kategorie werden je Interface-Funktion untereinander vergleichend ausgewertet, unter Einhaltung latenzbewusster Best Practices der Datenbankforschung)"*

Kapitel-Text, `THESIS/kapitel/de/03_messsystem_prtart.tex:1300-1304`:
> *"\emph{Mikro-Benchmarking} vermisst jede Achse ueber ihr \emph{Achsen-Interface} — die Funktionsmenge, die \emph{alle} Algorithmen dieser Achse liefern muessen (jeder Allokator stellt Speicher bereit, gleich welcher): die achsen-spezifischen Haupteigenschaften, **intern gemessen**. Die Achse ist dabei \emph{keine} Interface-Funktion des Suchalgorithmus; dessen Gattungs-Interface-Funktionen \emph{verwenden} die Achsen-Interfaces"*

**Der Messvertrag je Achse ist ausgeschrieben** — 18-Zeilen-Tabelle *"Achsen-Interface-Kern (Ebene-1-Messvertrag)"*, `CE/docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md:187-206`:

| Achse | Achsen-Interface-Kern |
|---|---|
| T0 search_algo | insert/lookup/erase/clear (std::map-aequivalent) |
| T1 cache_traversal | register_entry/resolve |
| T2 mapping | register_slot/resolve_offset |
| T3 path_compression | compress (+ prefix-Ops) |
| T4 node_type | Slot-/Node-Find-Zugriff |
| T5 memory_layout | Feld-/Stride-Zugriff (record-scan ueber das reale Backing) |
| T6 allocator | allocate/deallocate (**REALE Ops, kein Stats-READ**) |
| T7 prefetch | prefetch-Hint je Descent |
| T8 concurrency | acquire/release |
| T9 serialization | encode/decode ueber reale Records |
| T10 value_handle | access/deref |
| T11 index_organization | Index-Ordnung-Scan/Lookup |
| T12 io_dispatch | dispatch |
| T13 migration_policy | decide (+ migrate_step) |
| T14 filter | probe (+ insert) |
| T15 queuing_q1 | put/get |
| T16 queuing_q2 | should_flush/on_flush_complete |
| T17 persistence_target | stage/writeback |

Und die Ehrlichkeits-Regel dazu, ebd. `:208-211`: *"(a) None-/0-Overhead-Strategien = deklarierte Vergleichs-Nullpunkte (ehrlich, kein n/a-Fake); (b) je Slot **AUSSCHLIESSLICH Achsen-Interface-Aufrufe der REALEN Komposition** (kein synthetischer Parallel-Puffer, kein Store-Umweg, kein Stats-READ als Zeit-Surrogat)."*

#### Was "Parameter" hier heisst

Der Owner sagt *"Parameter-Benchmarks der Achsen"* und *"wann ein Algorithmus **in einem Parameter** ueber eine Achse … effektiver wird"*. Der Parameter ist die **x-Achse der Kurve**. Im heutigen Kurven-Lader sind genau zwei x-Groessen kanonisiert — `CE/libs/cache_engine/heuristik/measurement_curve_loader.hpp:57-58`:

```cpp
std::string x_col = "working_set_n"; // Parameter-Achse
std::string y_col = "ns_per_op";     // Messwert
```

und die Gruppierung ebd. `:20`: *"Gruppe = (sweep_axis, binary_id, workload); x = working_set_n; y = ns_per_op."*

⇒ Der Plan kennt heute **eine** Parameter-Dimension (`working_set_n`). Die Thesis benennt das selbst als Keim, nicht als Vollausbau — `03_messsystem_prtart.tex:1481-1484`: *"im heutigen Stand existiert davon erst der **Keim** — eine Kurvenanpassung ueber **eine** Achse und **eine** x-Dimension —, die volle Struktur ist als Ziel formuliert."* Die volle Struktur ist ebd. `:1484-1486` beschrieben: *"je Mess-Achse eine Wall-Clock-Messkurve ueber das Working-Set … getrennt nach Lastprofil-Rahmenwerk, Workload-Typ, Working-Set-Groesse, Operationstyp und Beobachter-Typ."*

⇒ Daraus folgt **offene Frage O-2** (Abschnitt 9): welche Parameter ausser `working_set_n` traegt Micro?

### 3.2 MACRO (timed) — eine Funktion, ueber Schritte und Checkpoints

Das ist die anspruchsvollste Ebene. Sie beantwortet nicht *"die Funktion war X ns schnell"*, sondern **"wo innerhalb ihrer Ausfuehrung hat welche Achse Zeit gekostet"**. Erst das macht Break-Even auf **Achsen**-Ebene bestimmbar — sonst weiss man nur, *dass* eine Konfiguration besser ist, nicht *warum* (`LEDGER:4600-4605`).

#### 3.2.1 Was der Plan sagt — der Checkpoint-Begriff EXISTIERT und ist Owner-Direktive

**Owner-Direktive vom 30.05.2026**, verbatim festgehalten in `CE/docs/architecture/24_messmodell_korrektur_zwei_dimensionen.md:468-472`:

> *"die CacheEngineBuilder [erhebt] SOWOHL die allgemeinen Metriken wie wall clock, als auch die Achsen-observer-statistics vollstaendig. Dabei kann jeder wall clock time mit **sync nach Zeitschritten** oder **nach Manipulation des Suchalgorithmus-Zustandes** ein update der Observer getriggert werden, die dann einer wall clock time zugeordnet werden koennen."*

Daraus zwei Trigger-Modi (ebd. `:477-486`):
- **(a) Zeitschritt-Sync** — periodisches Sampling alle Δt ⇒ *"Observer-Trajektorie ueber die Zeit"*.
- **(b) Zustands-Manipulation** — ereignisgetrieben nach zustandsaendernder Op ⇒ *"das ist exakt der **Checkpoint-Modus** von `tier_observe_trace.hpp`, dort an **Fuellstands-Stuetzpunkte** gebunden"*.

Korrelations-Zusage ebd. `:487-491`: *"JEDER Observer-Snapshot traegt einen **Wall-Clock-Zeitstempel** → die Messung ist eine **korrelierte Zeitreihe** `[(t0, ObserverAggregate0), (t1, ObserverAggregate1), …]`"*.

#### 3.2.2 Was ein Checkpoint HEUTE ist — Instrumentierungsstelle, Anzahl, Setzer

**Definition im Code**, `CE/libs/cache_engine/builder/anatomy_commands/tier_observe_trace_abi.hpp:34-36`:

```cpp
std::vector<std::uint64_t> fill_checkpoints{10, 100, 1000}; // Element-Fuellstaende (Kurven-Stuetzpunkte)
std::uint64_t              lookups_per_checkpoint = 2000;
std::uint64_t              deletes_per_checkpoint = 200; // erase+reinsert -> Fuellstand stabil
```

und ebd. `:47`, `:52`:
```cpp
std::uint64_t  fill_level = 0; // = tier.tier_size() am Checkpoint
an::ComdareTierObserverSnapshot observer{}; // §8.7: EIN konsolidierter Observer-POD je Checkpoint, korreliert (I1)
```

| Frage | Antwort (belegt) |
|---|---|
| **Was ist ein Checkpoint?** | Ein **Fuellstands-Stuetzpunkt** einer Kurve ueber der Datenmenge — nicht eine Stelle *innerhalb* einer Funktionsausfuehrung. Die Schleife laeuft ueber `cfg.fill_checkpoints` (`tier_observe_trace_abi.hpp:133`, `:210`; Gattungs-Variante `genus_tier_observe_trace_abi.hpp:97`, `:157`; Nicht-ABI-Variante `tier_observe_trace.hpp:87`). |
| **Wie viele?** | Default **drei** (`{10, 100, 1000}`). Der einzige produktive Konsument setzt sie um: `CE/apps/f15_compare/main.cpp:241` → `opts.fill_checkpoints = {50, 200, 1000};` |
| **Wer setzt sie?** | Die **CEB-/Dock-Seite** in C++ ueber `AbiTierObserveTraceConfig`. Nicht der Achsen-Autor, nicht der Planer. **Ein XML-Feld fuer Checkpoints existiert nicht** (Suche ueber `CE/libs/cache_engine/algorithm_profiles/` und `SUPER/Code/test_data_xml/` — kein Treffer; Gegenprobe: `<axis_sweep`, `<workloads>`, `<measurement_tooling>` sind dort sehr wohl XML-gesteuert). |
| **Was faellt an?** | Je Checkpoint: `observe_wall_ns` (Zeitstempel), `fill_level`, r/w/d-Roh-ns-Kurven und **ein** konsolidierter `ComdareTierObserverSnapshot`. Persistiert als CSV (eine Zeile je Checkpoint) und JSON (zusaetzlich p50/p95/p99 der r/w/d-Kurven) — `tier_observe_trace_abi.hpp:275-297` bzw. `:299ff`. |
| **Wo landen sie?** | Pruef-Dock, `CE/libs/cache_engine/builder/pruef_dock/search_algorithm_dock.hpp:56-58` (`drive_two_phase_tier_trace_abi` → `serialize_abi_tier_trace_csv/json`); Gattungs-Docks `{set,sequence,adapter,view}_dock.hpp:43-45`. |

#### 3.2.3 Drei harte Abweichungen zum Owner-Wortlaut

| # | Owner-Wortlaut | Ist-Zustand | Beleg |
|---|---|---|---|
| **A** | *"ueber die **Schritte und checkpoints ihrer Ausfuehrung**"* (innerhalb **einer** Funktion) | Checkpoints liegen **zwischen** Ops auf der Fuellstands-Kurve des ganzen Lebewesens, nicht innerhalb einer Op | `tier_observe_trace_abi.hpp:34`, `:133`, `:47` |
| **B** | *"Detail-Analyse ueber **alle Achsen die sie verwendet hat**"* | Die Checkpoint-CSV exportiert **2 von 18 Achsen**: `axis_stats[0]` (search_algo, 6 Felder) und `axis_stats[6]` (allocator, 2 Felder) — hartkodiert | `tier_observe_trace_abi.hpp:281-290` (Header-String + Zeilen-Emission) |
| **C** | (der Ist-Traeger, der der Owner-Semantik am naechsten kommt) | `seg_ns[18]` misst die Zeit **je Achse** — das ist "alle Achsen, die sie verwendet hat", aber die "Schritte" **sind** die Achsen, keine frei gesetzten Checkpoints, und der Wert ist **ueber den ganzen Lauf aggregiert** | `CE/libs/cache_engine/anatomy/observable_tier.hpp:142` (`std::int64_t seg_ns[kV3AxisCount]`, `kV3AxisCount = 18` an `:50`) |

#### 3.2.4 NICHT GEFUNDEN — Schritt-/Phasen-Instrumentierung, mit Nenner und Gegenprobe

**Suchraum:** `CE/libs`, `CE/apps`, `CE/tools`, `CE/tests`, `--include=*.hpp --include=*.cpp`, ohne Build-Verzeichnisse. **Werkzeug:** `/usr/bin/grep -rn`, case-insensitiv.

| Muster | Treffer |
|---|---|
| `lap_ns` | 0 |
| `split_ns` | 0 |
| `phase_ns` | 0 |
| `stage_ns` | 0 |
| `step_ns` | 0 |
| `marker_ns` | 0 |
| `trace_point` / `tracepoint` | 0 |
| **Gegenprobe `seg_ns`** | **326** |

Die Gegenprobe zeigt, dass der Ausdruck greift. **Es gibt keine Schritt-Instrumentierung innerhalb einer Funktion.**

**Und in der Thesis kommt "Checkpoint" nicht vor.** Nenner: 30 `.tex` unter `THESIS/kapitel/` + `THESIS/aufgabenstellung/` (die sechs eingebundenen Kapitel in DE und EN plus die gesetzte Aufgabenstellung; `diplomarbeit.tex:280-285` bindet genau 01_einleitung, 02_suchbaeume_grundlagen, 03_messsystem_prtart, 04_implementierung, 05_evaluation, 06_fazit ein). Muster `checkpoint` — **0 Treffer**. Gegenprobe: `heuristik` in `kapitel/de/03_messsystem_prtart.tex` = **20 Treffer**.

⇒ **Die Owner-Ebene MACRO(timed) existiert heute NICHT und ist in der Thesis auch nicht zugesagt.** Vorhanden sind zwei Halbstuecke, die nicht verbunden sind:
1. **Welche Funktion** — `op_lat[6]` (p50/p99 je Op-Art insert/lookup/erase/clear/scan/rmw), `CE/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp:310`; im CSV die Spalten `op_insert_p50_ns … op_rmw_p99_ns`.
2. **Welche Achsen** — `seg_ns[18]`, im CSV die Spalten `seg_search_algo_ns … seg_persistence_target_ns` plus `seg_framework_ns`, `seg_run_total_ns`, `seg_coverage`.

Beide belegt am realen Datensatz `SUPER/measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` (Kopfzeile, semikolon-getrennt).

#### 3.2.5 VORSCHLAG (nicht Plan) — wie MACRO(timed) zu schneiden waere

> **Kennzeichnung: Das Folgende steht in keinem Plan-Dokument. Es ist ein Vorschlag des Autors dieses Dokuments und hat keine Plan-Autoritaet, bis der Owner ihn annimmt.**
>
> **V-1 — Checkpoint = Achsen-Interface-Aufruf-Grenze.** Ein "Schritt" einer Gattungs-Funktion ist genau der Uebergang in ein Achsen-Interface und zurueck. Die Schritt-Menge einer Funktion ist damit **nicht frei zu waehlen**, sondern folgt aus der Konstitutiv-Matrix, die im A8/F2-Design bereits gefordert ist (`20260803-a8_f2_benchmarking_schnitt_soll_design.md:196-201`: *"Je (Gattungs-Funktion x Achse) eine deklarierte Rolle: KONSTITUTIV … oder BEOBACHTEND … SOLL: die Konstitutiv-Matrix wird hergestellt und dokumentiert"*). Vorteil: kein neues Vokabular, keine Willkuer bei der Setzung, und die Zeitsumme ist gegen `seg_ns` pruefbar.
>
> **V-2 — Wer setzt sie.** Der **Achsen-Autor** deklariert nichts Zusaetzliches; die Grenzen entstehen aus dem bestehenden CT-Wrapper (derselbe Mechanismus, der heute `fill_segment_timing_v3` speist, `abi_adapter.hpp:1444`). Die **Anzahl** ist damit je Funktion = Zahl der von ihr konstitutiv verwendeten Achsen, nicht eine Konfigurationsgroesse.
>
> **V-3 — Was anfaellt.** Je (Funktionsaufruf-Klasse x Achse) ein `{eintritte, ns_gesamt, p50, p99}`. Das ist eine **Erweiterung von `op_lat` um die Achsen-Dimension** — heute `op_lat[6]`, kuenftig `op_axis_lat[6][18]`. Damit ist der Owner-Satz *"alle Achsen-Parameter beim Aufruf einer beliebigen Funktion"* woertlich erfuellt, ohne einen zweiten Mess-Pfad zu erfinden.
>
> **V-4 — Verhaeltnis zu den bestehenden Fuellstands-Checkpoints.** Die bleiben, was sie sind: die **x-Stuetzpunkte** der Kurve. V-1..V-3 liefern die **y-Zerlegung** an jedem Stuetzpunkt. Beide zusammen ergeben genau das, was der Owner *"Gesamt-Messprofile timed einer Funktion"* nennt: an jedem Fuellstand eine Achsen-Zerlegung je Funktion.
>
> **V-5 — Kosten-Warnung.** Eine Zeitnahme je Achsen-Eintritt ist teuer und verfaelscht die Messung, wenn sie im Hot-Path bleibt. Der Plan hat dafuer bereits das Mittel: Mess-Observer **per Metaprogrammierung abschaltbar** (`LEDGER:3284`, Paket HY-B4 in `20260802-hybrid_tier_stufe_soll_design.md:402`). V-1..V-3 gehoeren hinter denselben Schalter.

### 3.3 MACRO large scope — ein Lastprofil, alle Funktionen

#### Was ein Lastprofil ist — belegt und scharf definiert

`THESIS/kapitel/de/02_suchbaeume_grundlagen.tex:390-394`:
> *"Ein \emph{Workload} (in dieser Arbeit synonym: \emph{Lastprofil}) ist ein strukturiertes Profil solcher Operationen: ein Operations-Mix (etwa 50\,\% Lesen / 50\,\% Aktualisieren) ueber einer Schluessel-Zugriffsverteilung (gleichverteilt, Zipf-verteilt, juengste Werte) auf einem Datensatz definierter Groesse und Schluessel-Charakteristik."*

**Realisierung, nachgezaehlt:** `CE/libs/cache_engine/algorithm_profiles/load_profiles/` enthaelt **22 Eintraege = 21 XML + `SCHEMA.md`**: `ycsb_a..f` (6), `lp_balanced_5050`, `lp_bulk_insert`, `lp_concurrent_rmw`, `lp_delete_heavy`, `lp_dynamic_trace`, `lp_mixed_oltp`, `lp_range_scan`, `lp_read_uniform` (8), `coco_p04_neg{0,25,50,75,100}` (5), `ih`, `lh` (2).

Beispiel `ycsb_a.xml`:
```xml
<comdare_load_profile id="ycsb_a" paper_ref="YCSB" schema_version="1">
    <op_mix insert="0.50" lookup="0.50" erase="0" clear="0" scan="0" rmw="0"/>
    <key_distribution>zipfian</key_distribution>
    <zipfian_theta>0.99</zipfian_theta>
```

Katalog-Herleitung aus der 33-Paper-Analyse: `CE/docs/architecture/32_lastprofil_katalog_und_paper_bias.md:9-25` (LP01–LP14 mit op-mix, key-dist, neg%, records, Sweep je Profil); Thesis-Tabelle `tab:lp-catalog`, `03_messsystem_prtart.tex:353-360`.

**Im Abgabe-Lauf** ist die Auswahl `SUPER/Code/test_data_xml/experiment_golden_kern.xml:382`:
```xml
<workloads>ycsb_a ycsb_b ycsb_c ycsb_d ycsb_e ycsb_f</workloads>
```
Autoritaet: `CE/libs/cache_engine/profile_facade/profile_run_facade.cpp:552-553` — *"`<workloads>` im Thesis-Profil ist die AUTORITATIVE Achse-2-Auswahl: die ids der Lastprofile"*. Fail-closed: eine unbekannte id ist harter Fehler (`validate_profile.hpp:463`, *"eine unbekannte id matcht 0 Lastprofile"*) — **kein stiller Rueckfall**.

Das Lastprofil ist die **dynamische Achse 2**: `THESIS/kapitel/de/06_fazit.tex:68` — *"die bias-freie Vollmatrix … die im Gesamt-Benchmarking alle Lastprofile **als dynamische Achse** gegen alle Lebewesen-Binaries faehrt"*.

#### Was ein "Chart" ist — Diagramm, nicht Datenstruktur

**Es gibt keine Datenstruktur namens Chart/Diagramm im Mess-Kern.** Es gibt eine **Auswerte-Stufe**, die aus der Mess-CSV LaTeX-Diagramme erzeugt:
- `SUPER/Code/05_diagram_generator` — laut `THESIS/kapitel/de/05_evaluation.tex:198` *"A4-bewusste TikZ-Balkendiagramme, Scatter-Plots, Heatmaps"*.
- `SUPER/Code/08_appendix_generator` als Fassade ueber 04+05 (`LEDGER:852`).
- End-to-End an echten Daten belegt, `LEDGER:848`: *"`diagram-generator --surface=op_lookup_p50_ns` = valide pgfplots-Heatmap"*.
- Der Generator zeichnet bereits genau die Kurven, die sich schneiden muessten — `Code/05_diagram_generator/diagram_generator.hpp:397-405`: *"Working-Set-Sweep-Kurve (Metrik ueber working\_set\_n) … **eine Kurve je gesweepter Achsen-Auspraegung** (sweep\_axis-getrieben)"*, und `:409ff` *"Per-Achsen-Latenz-Attribution als GESTAPELTE Balken"*.

⇒ *"Die Gesamtheit der Macro-Benchmark-**Charts**"* liest sich damit als **die Menge der je-Funktion-Diagramme**, die fuer ein Lastprofil zusammengefasst werden. **Ein Aggregations-Artefakt dieser Art existiert nicht** — weder Writer noch Schema. Nenner: `Code/04_csv_to_latex`, `Code/05_diagram_generator`, `Code/08_appendix_generator` = **24 Dateien**; Gegenprobe: derselbe Suchraum liefert **36 Treffer** fuer `kurve|curve`, greift also. Die real erzeugten Anhang-Artefakte sind `bias_matrix`, 6x `lc_surface_*`, 4x `ld_exchange_*`, `le_limitierung` (`LEDGER:850`) — **kein Per-Funktion-Chart-Buendel darunter**.

⇒ Daraus folgt **offene Frage O-3** (Abschnitt 9).

---

## 4. Wie die Ebenen zusammenhaengen

### 4.1 Die Aufbaurichtung ist im Plan begruendet, nicht nur gereiht

`THESIS/kapitel/de/03_messsystem_prtart.tex:1315-1318`, verbatim:
> *"Genau diese Methodik ist die Antwort auf das **Trennbarkeits-Problem**: Indem jeder Bestandteil **zunaechst isoliert ueber sein Achsen-Interface vermessen wird, bevor er im Operations- und Gesamt-Kontext erscheint**, werden die Beitraege getrennt messbar, statt im Gesamtdurchsatz vermengt zu bleiben."*

`THESIS/kapitel/de/05_evaluation.tex:241-242` (wortgleich in `aufgabenstellung/de.tex:98-99`):
> *"aus der **Rangbildung ueber die drei Granularitaeten** folgt die Empfehlung von Standard-Konfigurationen je Workload-Klasse."*

### 4.2 Die quantitative Verknuepfung ist als Invariante formuliert

`CE/docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md:222`:
> *"Konsistenz-Invariante (P-MD3-Prinzip fortgefuehrt, vgl. abi_adapter.hpp:1694-1696): **Summe(E1-konstitutiv) <= E2 <= E3**; jeder Rest EXPLIZIT benannt (framework/orchestration), Coverage gegen den je-Ebene kommensurablen Nenner."*

Das ist der harte Aufhaenger: die drei Ebenen sind nicht drei unabhaengige Messungen, sondern eine **geschachtelte Zerlegung derselben Zeit**, mit einer pruefbaren Ungleichung und einem explizit benannten Rest. Der Rest ist im CSV real vorhanden: Spalten `seg_framework_ns` und `seg_coverage` (Beispielzeile: `seg_coverage = 0.999963`).

### 4.3 Die Abhaengigkeit, gezeichnet

```
  MICRO   (Achse ueber ihr Achsen-Interface)
    |                       liefert: je Achse eine f(x)-Kurve
    |                       Zerlegungs-Beitrag: Summe(E1-konstitutiv)
    v
  MACRO (timed)   (eine Gattungs-Funktion, ueber Schritte + Checkpoints)
    |                       liefert: je Funktion die ACHSEN-Zerlegung ihrer Zeit
    |                       Zerlegungs-Beitrag: E2, mit Summe(E1) <= E2
    v
  MACRO large scope   (ein Lastprofil, alle aufgerufenen Funktionen)
                            liefert: je Lastprofil x Binary die Gesamtzeit
                            Zerlegungs-Beitrag: E3, mit E2 <= E3

  Vertikal:   jede Ebene erklaert die naechsthoehere.
  Horizontal: innerhalb JEDER Ebene entstehen Kurven ueber den Parameter x
              -> und ueberall dort, wo zwei Kurven derselben Ebene sich
                 kreuzen, liegt ein BREAK-EVEN-PUNKT.
```

**Wichtig fuer die Erwartungshaltung:** Break-Even ist **kein vierter Schritt nach den drei Ebenen**, sondern die **Operation, die auf jeder Ebene anwendbar ist**. Der Plan hat sie heute nur auf einer Ebene ausformuliert (Achsen-intern, Abschnitt 2.4).

---

## 5. Der Weg von der Messung zur Binary-Wahl

Die vollstaendige Kette, mit den Ebenen an ihrem Platz. Jeder Pfeil traegt seine Fundstelle.

```
 (1) MESSUNG
     MICRO / MACRO(timed) / MACRO large scope
     -> measurements.csv (Spalten: sweep_axis, working_set_n, ns_per_op, workload,
        binary_id, op_*_p50/p99_ns, seg_*_ns, stat_*)
        Beleg: measurement_curve_loader.hpp:20; reale CSV-Kopfzeile
        SUPER/measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv
         |
 (2) FUNKTIONS-SYNTHESE
     je Gruppe (sweep_axis, binary_id, workload) eine Modellfunktion f(x)
     monotone kubische Hermite-Interpolation (Fritsch-Carlson 1980)
        Beleg: heuristik/axis_spline.hpp:15-25; measurement_curve_loader.hpp:218
        HONEST-EMPTY: < 2 verwertbare Punkte -> std::nullopt (axis_spline.hpp:27-28)
         |
 (3) SCHNITT-KURVEN (BREAK EVEN)
     d(x) = f(x) - g(x); Vereinigungs-Knotengitter auf dem Ueberlappungs-
     Intervall; Vorzeichenwechsel -> Bisektion; alle Punkte, deterministisch
        Beleg: heuristik/break_even.hpp:10-15
        Ergebnis: vector<BreakEvenPoint{x, y, links_besser, rechts_besser}>
         |
 (4) OPTIMALE KONFIGURATION == die zu WAEHLENDE BINARY
     rueckwaerts aus den Schwellen: welcher Algorithmen-Satz fuehrt in welchem
     x-Intervall
        Beleg: LEDGER:2296 ("rueckwaerts die optimale Binary mit den optimalen
        Algorithmen-Saetzen"); decision_lambda_trees.hpp:4-6
         |
 (5) HYBRID-ADAPTER schaltet je LAST-KANAL
     Compile-Time-Chain-of-Responsibility, gespeist aus (3)
        Beleg: 20260802-hybrid_tier_stufe_soll_design.md:192-197
        XML-Konfiguration ebd. :232:
          <router><break_even source="measurement_store" curves="axis_splines"/></router>
        Ruf-Kette: LEDGER:4076 ("CT-CoR-Break-Even-Router an STATISCH zugewiesene
        echte Tiers, traegt N dynamische Hybrid-Pruef-Docks")
         |
 (6) RELEASE
     Neu-Kompilation OHNE Mess-Einrichtungen; Wallclock-Beweis
        Beleg: LEDGER:3284; Paket HY-B4 (hybrid_tier_stufe_soll_design.md:402)
```

### 5.1 Das Verfahren in (3), praezise — es ist weder reine Regression noch reine Interpolation

`CE/libs/cache_engine/heuristik/break_even.hpp:10-15`, verbatim:
> *"VERFAHREN: d(x) = f(x) - g(x). Auf dem UEBERLAPPUNGS-Intervall [max(f.x_min,g.x_min), min(f.x_max,g.x_max)] wird ueber die **Vereinigung beider Knoten-Gitter** ein gemeinsames, aufsteigend sortiertes Auswerte-Gitter gebildet. Je aufeinanderfolgendem Segment-Paar [a,b] entscheidet der **Vorzeichenwechsel** von d: sign(d(a)) != sign(d(b)) -> genau eine Nullstelle im Inneren -> **BISEKTION** (deterministisch, feste Iterationszahl) auf d==0. Exakte Knoten-Treffer (d(a)==0) werden separat als Schnittpunkt erfasst (ohne Doppelzaehlung). ALLE Schnittpunkte, deterministisch, aufsteigend nach x."*

**Die Wahl des Kurvenmodells ist numerisch begruendet, nicht Geschmack** — `heuristik/axis_spline.hpp:15-25`:
> *"Ein NATUERLICHER kubischer Spline erzwingt C2-Glattheit global und kann zwischen zwei Stuetzstellen UEBERSCHWINGEN … Diese falschen Extrema erzeugen **SCHEIN-Schnittpunkte im Break-Even-Finder -> falsche Switch-Thresholds**. Fritsch-Carlson begrenzt die Hermite-Steigungen (alpha^2+beta^2 <= 9 je Segment) und GARANTIERT damit die Monotonie-Erhaltung … **kein kuenstlicher Nulldurchgang von f-g**."*

Benanntes Muster, `break_even.hpp:21-23`: *"Strategy (die f/g sind AxisSpline<Strategy> …). Die Bisektion ist ein klassisches, benanntes Wurzel-Einschluss-Verfahren (bracketing root-find), deterministisch."*

Bewiesen am F8-Owner-Beispiel, `CE/tests/unit/test_heuristik_spline_break_even.cpp:27-59`: `f_A(x)=50+2x` (klein-optimiert) gegen `f_B(x)=170+0.5x` (gross-optimiert) → analytisch `x=80, y=210`, links A besser, rechts B besser.

### 5.2 Was mit dem Schnittpunkt geschehen soll — und was heute geschieht

**Geplant:** Einspeisung in den Break-Even-Router. `CE/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md:192-197`:
> *"### 3.4 Break-Even-Router (§32-F8 / §49) — `hybrid_router.hpp` konsumiert AxisSpline-Kurven (`heuristik/measurement_curve_loader.hpp`) und BreakEvenPoint-Listen (`heuristik/break_even.hpp`) und bildet daraus die **Compile-Time-Chain-of-Responsibility der Heuristik-Ebene**."*

Der Ort ist bereits **reserviert und dokumentiert** — `CE/libs/cache_engine/hybrid/README.md` (58 Zeilen, **die einzige Datei im Ordner**), Kopfzeile: *"hybrid/ — RESERVIERTER STUB der Hybrid-Tier-Stufe (KEIN CODE)"*; die Tabelle *"Geplante Dateien (Auswertungsphase, Design Abschnitt 3)"* nennt neun Header, darunter `hybrid_router.hpp` = *"Break-Even-Router (Compile-Time-Chain-of-Responsibility)"*. Der Ordner ist ausdruecklich **nicht** in `libs/cache_engine/CMakeLists.txt` eingetragen und damit build- und byte-neutral.

**Heute:** der Schnittpunkt lebt als `std::vector<BreakEvenPoint>` im Speicher und wird **nur von Unit-Tests** gelesen. Es gibt keinen Serialisierer, keine CSV-Spalte, keine XML-Rueckschreibung, kein generiertes `constexpr`-Array. Belege in Abschnitt 6.4.

---

## 6. Der Ist-Stand

### 6.1 DIE KERNFRAGE: Sind `wallclock`/`macro`/`micro` der Mess-Tooling-Achse dieselben drei Ebenen?

**NEIN. Sie sind eine andere Kategorie — und sie sind ausserdem heute funktional wirkungslos.**

Das ist keine Nuance, sondern der Unterschied zwischen **Gegenstand** und **Instrument**.

#### 6.1.1 Was die Achse ist

`CE/libs/cache_engine/include/cache_engine/measurement/measurement_tooling_registry.hpp:26-34`:
```cpp
/// Die Mess-Tooling-HAUPT-Achse: WELCHE Mess-Instrumentierung fest einkompiliert wird (Section 47/55).
enum class MeasurementTooling : std::uint8_t {
    WallClock, ///< Wall-Clock-Zeit -- die Basis-Zeitmessung (immer verfuegbar, latenzarm)
    Macro,     ///< Makro-Benchmark -- Ende-zu-Ende-Durchsatz/Latenz ueber Observer
    Micro,     ///< Micro-Benchmark -- feinkoernige PMC/Counter-Instrumentierung
};
inline constexpr std::size_t kMeasurementToolingCount = 3;
```

Der Kommentar sagt es selbst: *"WELCHE Mess-**Instrumentierung**"*.

#### 6.1.2 Drei harte Gruende, warum das nicht die Owner-Ebenen sind

| # | Grund | Beleg |
|---|---|---|
| **1** | **`WallClock` ist ein Instrument, kein Granularitaets-Rang.** Die Owner-Ebene 3 (Lastprofil / large scope) hat in dieser Achse **kein Gegenstueck**. Die Menge ist {Instrument, Granularitaet, Granularitaet} — nicht {Ebene1, Ebene2, Ebene3}. | Registry `:27-31` gegen `LEDGER:4596-4598` |
| **2** | **`Micro` ist hier PMC/Counter** — Owner-KERN und Thesis definieren Micro als **Achsen-Interface**. Anderer Gegenstand. Das ist als Widerspruch bereits aktenkundig: *":30 deklariert Micro als 'feinkoernige PMC/Counter-Instrumentierung' — **widerspricht F2** (Micro = Achsen-Interface, nicht PMC)"* | `20260803-a8_f2_benchmarking_schnitt_soll_design.md:90-92` |
| **3** | **`Macro` ist hier "Ende-zu-Ende ueber Observer"** — beim Owner ist Ende-zu-Ende die **dritte** Ebene, und Macro ist **eine einzelne Funktion**. Die Namen kollidieren bei verschobener Bedeutung. | Registry `:29` gegen KERN-Tabelle 1.2 |

#### 6.1.3 Welches Konstrukt die Owner-Ebenen WIRKLICH abbildet: E1/E2/E3 (F2-Gesetz)

`CE/docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md:66-68`, Owner-Gesetz vom 01.08.:
> *"4. Die CEB misst ZUSAETZLICH drei Wallclock-Ebenen: **(E1)** Wallclock der ACHSEN-Interfaces unter jedem Algorithmus (Gegenmessung zur internen Micro), **(E2)** Wallclock der GATTUNGS-Interfaces, **(E3)** Wallclock einer Test-Last aus den Last-Frameworks (Benutzungs-Konfiguration)."*

**Die Gegenstaende von E1/E2/E3 sind exakt die Gegenstaende der Owner-Ebenen** (Achse / Gattungs-Funktion / Lastprofil). Der Unterschied ist das Instrument: E1/E2/E3 messen sie **von aussen per Wallclock**, Micro/Makro/Gesamt **intern**. Die Thesis fuehrt beides nebeneinander und nennt E1/E2/E3 ausdruecklich eine **Gegenprobe** — `03_messsystem_prtart.tex:1309-1312`: *"Als **Gegenprobe** zur internen Mikro-Messung misst der Apparat **zusaetzlich** drei \emph{Wallclock-Ebenen}"*.

**Saubere Antwort in einem Satz:** Die Owner-Ebenen sind ein Schnitt nach **Mess-Gegenstand** (Achse → Funktion → Lastprofil), die Mess-Tooling-Achse ist ein Schnitt nach **Mess-Instrument** (Wallclock / Observer / PMC); die beiden Dreiergruppen sind orthogonal und nur namensgleich.

#### 6.1.4 Und die Achse ist heute ohnehin wirkungslos — nachgezaehlt

**Nenner und Messung (heute, `/usr/bin/grep -rn --include=*.hpp --include=*.cpp` ueber `libs apps tools tests`, ohne Build-Verzeichnisse):**

| Muster | Treffer |
|---|---|
| `MeasurementTooling::` | **3 — alle drei in der Registry-Datei selbst** (`:47`, `:48`, `:49`, die Tabellen-Eintraege) |
| **Gegenprobe** `measurement_tooling` (Dateien) | **30** |

Die 30 Dateien konsumieren den Begriff ausschliesslich auf **Token-/String-Ebene**: Legenden (`profile_facade/planner/plan_legend.hpp`), Stempelzeile (`abi/anatomy_version_stamp.hpp`), Planer-Lanes (`profile_facade/planner/experiment_plan_director.hpp`). Vorbefund gleichen Inhalts vom 03.08., `20260803-a8_f2_benchmarking_schnitt_soll_design.md:93-97`:
> *"Repo-weiter grep 03.08.: `MeasurementTooling::` hat AUSSERHALB der Registry **0 Consumer** in libs/apps/tools (live nachgezaehlt). Die Tooling-Wahl faechert nur Planer-Lanes auf … und stempelt; sie **veraendert NICHT, welche Instrumentierung kompiliert wird**. Reale Schalter: COMDARE_MEASUREMENT_ON / COMDARE_CE_ENABLE_STATISTICS / COMDARE_ENABLE_PMC."*

**Verschaerfung im Abgabe-Lauf:** in der golden-XML kollabiert die Achse auf **eine** Combo — `CE/libs/cache_engine/algorithm_profiles/thesis_profiles/all_axes_golden.profile.xml:221-225`:
```xml
  <measurement_tooling>
    <!-- §64 (2026-07-22): EINE Vollmengen-Combo {wallclock,macro,micro} = EINE vereinte CEB (Default; Legende
         kollabiert auf [all], measurement_combos_of => 1 Combo). ... -->
    <combo tools="wallclock macro micro"/>
```

⇒ Im golden erzeugt die Mess-Tooling-Haupt-Achse **eine** Konfiguration, und selbst die Legenden-Unterscheidung verschwindet. Sie ist dort faktisch rangfrei.

### 6.2 MICRO — Ist-Stand

**Was existiert:**

| Artefakt | Fundstelle | Gehalt |
|---|---|---|
| **17 Achsen-Sweeps** | `all_axes_golden.profile.xml` — `grep -c "<axis_sweep "` = **17** | variiert je Pass **eine** Achse, Rest baseline |
| CSV-Tag `sweep_axis` | `builder/experiment_tree/cache_engine_builder_iterator.hpp:143` | *"gesweepte Achse (z.B. `migration_policy`) bzw. `-`"* |
| **18 Per-Achsen-Zeitspalten** | reale CSV: `seg_search_algo_ns … seg_persistence_target_ns` + `seg_framework_ns`, `seg_run_total_ns`, `seg_coverage` | Per-Achsen-Latenz-Attribution |
| Visualisierung | `Code/05_diagram_generator/diagram_generator.hpp:409ff` | *"Per-Achsen-Latenz-Attribution als GESTAPELTE Balken"* |

**Was NICHT existiert — mit Nenner:**

Beide fuer Micro angelegten Orte sind **leere Skelette**:
- `CE/benchmarks/` = **7 Dateien** gesamt: `CMakeLists.txt` + je `.gitkeep`+`CMakeLists.txt` in `ycsb/`, `microbenchmarks/`, `platform_calibration/`. `benchmarks/microbenchmarks/.gitkeep` = **0 Byte**.
- `CE/libs/cache_engine/builder/runtime_micro_benchmarks/` = **2 Dateien**: `.gitkeep` (**0 Byte**) und `CMakeLists.txt` (270 Byte) mit `add_library(comdare_runtime_micro_benchmarks INTERFACE)` und dem Kommentar *"Skelett (Phase 4.B) — keine Implementation"*.

**Bewertung (Owner-Doktrin: Abweichung vom KERN ist Regression).** Was heute "Micro" heisst, sweept die **Algorithmen-WAHL** einer Achse und misst am **Gattungs-Interface** (`ns_per_op`) — nicht einen **Parameter** ueber das **Achsen-Interface**. Das ist als Befund B-2/B-3 bereits aktenkundig, `20260803-a8_f2_benchmarking_schnitt_soll_design.md:100-118`: Pfad A treibt synthetische `*_scan`-Kerne auf einem Roh-Puffer (*"Mess-Sonder-Eintrittspunkte der Achsen-Strategien, NICHT das Achsen-Interface"*), Pfad B mischt drei Vertragsarten (echte Achsen-Ops, Mess-Huellen-Scans ueber das Store-Backing, Stats-READ).

### 6.3 MACRO (timed) und MACRO large scope — Ist-Stand

- **MACRO (timed): existiert nicht.** Vollstaendig belegt in Abschnitt 3.2.4 (0 Treffer fuer lap/split/phase/stage/step/marker/trace_point-Zeiten; Gegenprobe `seg_ns` = 326).
- **MACRO large scope: Traegerschicht ja, Auswertung nein.** 21 Lastprofile, 6 im golden, `workload`-Spalte im CSV, fail-closed Validierung — aber kein Aggregations-Artefakt ueber die Funktions-Charts eines Lastprofils (Abschnitt 3.3, Nenner 24 Dateien, Gegenprobe 36 Treffer).

### 6.4 BREAK EVEN — Code existiert, Kette nicht

**Fuenf reale Fundstellen:**

| # | Datei | Was |
|---|---|---|
| 1 | `CE/libs/cache_engine/heuristik/break_even.hpp` (148 Z.) | kanonischer Schnittpunkt-Finder, Hermite + Bisektion |
| 2 | `CE/libs/cache_engine/heuristik/axis_spline.hpp` | monotone Hermite-Interpolation (Fritsch-Carlson) |
| 3 | `CE/libs/cache_engine/heuristik/measurement_curve_loader.hpp` | liest **echte** Mess-CSV; `x_col="working_set_n"`, `y_col="ns_per_op"` (`:57-58`) |
| 4 | `CE/libs/cache_engine/builder/curve_fit/curve_fit.hpp:392` | `spline_intersections(AxisSpline, AxisSpline, samples=256, y_tol=1e-9)` |
| 5 | `CE/libs/cache_engine/builder/best_binary_selector/best_binary_selector.{hpp,cpp}` | `find_break_evens` (`hpp:345`/`cpp:455`), `HybridBinarySelector::break_even_table` (`hpp:360`/`cpp:520`) |

**Konsumenten — nachgezaehlt (Suchraum `libs apps tools tests`, `*.hpp`/`*.cpp`, ohne Build):**

| Symbol | Definition | Konsumenten ausserhalb der Definition |
|---|---|---|
| `find_break_even_points` | `heuristik/break_even.hpp:74` | **nur** `tests/unit/test_heuristik_spline_break_even.cpp:50,76` |
| `build_axis_splines` | `heuristik/measurement_curve_loader.hpp:218` | **nur** `test_heuristik_spline_break_even.cpp:166` |
| `spline_intersections` | `curve_fit.hpp:392` | `decision_lambda_trees.hpp:102` (selbst als `(SKELETON)` deklariert, `:55`) + `test_hybrid_spline_selector_scaffold.cpp:104,109,225,226` |
| `find_break_evens` | `best_binary_selector.cpp:455` | **nur** `test_hybrid_spline_selector_scaffold.cpp:131` |
| `HybridBinarySelector` | `best_binary_selector.cpp:500,520` | **nur** `test_hybrid_spline_selector_scaffold.cpp:141,152` |
| `break_even_table` | `best_binary_selector.cpp:520` | **nur** `test_hybrid_spline_selector_scaffold.cpp:147` |

**Nenner:** `CE/tests/unit/CMakeLists.txt` = **203** `comdare_add_test`-Eintraege; genau **zwei** davon fahren Break-Even. `CE/apps/` = **10** Anwendungen (adhoc_emitter, anatomy_codegen_tool, cache_engine_builder, catalog_codegen_tool, experiment_planner, f15_compare, h2_score_akte_tool, is_original_validator, perm_runner + CMakeLists) — **keine** davon ruft Break-Even.

**Kein Artefakt:** Suche nach `break_even|breakeven|BreakEvenPoint` gekreuzt mit `write|csv|serial|emit|persist|dump` ergibt ausschliesslich lokale Rueckgabevariablen (`std::vector<BreakEvenPoint> out;` an `break_even.hpp:76`, `best_binary_selector.cpp:457`, `:522`). Gegenprobe: derselbe Suchraum kennt sehr wohl Serialisierer (`builder/measurement_snapshot.hpp :: serialize_measurements_csv`, in `measurement_curve_loader.hpp:20` als Eingangsformat zitiert) — **die Faehigkeit existiert, sie ist auf Break-Even nur nicht angewandt.**

**Der super-Auswertungspfad kennt den Begriff nicht.** `/usr/bin/grep -rniE "break.{0,2}even|schnittpunkt|intersect|crossover"` ueber `Code/05_diagram_generator`, `Code/08_appendix_generator`, `Code/04_csv_to_latex`, `Code/02_messung_driver` = **0 Treffer**. Nenner: 24 Dateien; Gegenprobe `kurve|curve` in `05_diagram_generator` = **36 Treffer**. **Der Generator legt die Kurven uebereinander — niemand schneidet sie.** Das ist exakt die Luecke des Owner-KERNs.

### 6.5 Zwei divergierende Break-Even-Implementierungen — RISIKO

Es existieren **zwei `BreakEvenPoint`-Typen in zwei Namespaces** mit unterschiedlichen Feldern und unterschiedlichem Kurvenmodell:

| | `heuristik::BreakEvenPoint` | `best_binary::BreakEvenPoint` |
|---|---|---|
| Datei | `heuristik/break_even.hpp:43-48` | `builder/best_binary_selector/best_binary_selector.hpp:321-327` |
| Felder | `x, y, links_besser, rechts_besser` (enum `Curve`) | `x, cost, winner_below, winner_above` (`std::string`) |
| Kurvenmodell | monotone kubische Hermite (Fritsch-Carlson) | **stueckweise linear** + lineare Extrapolation (`cpp:434-453`) |
| Auswerte-Gitter | Vereinigung der **echten Knoten** beider Splines | **festes 256-Raster** |
| Geschuetzt | ja (§75, `LEDGER:3602`) | nein |

Der zweite Strang deklariert sich selbst als Geruest — `best_binary_selector.hpp:263`: *"HYBRID-BREAK-EVEN-SELEKTOR-**SKELETON** (Section 32-F8 / Section 49, 2026-07-20)"*, und `:274-276`: *"der Kandidaten-Kurven-Traeger ist hier ein std-only STUECKWEISE-LINEARES Modell ueber **SYNTHETISCHEN** Stuetzstellen … In S7 wird dieselbe eval()-Kontur vom engine-seitigen … Spline gespeist."*

**Das Risiko ist konkret:** ein festes 256-Raster kann Schnittpunkte zwischen zwei Rasterpunkten **ueberspringen**, die das knoten-basierte Gitter garantiert findet — und die lineare Interpolation ignoriert genau die Begruendung, mit der `axis_spline.hpp:15-25` sein Verfahren waehlt. Das SOLL-Design legt den Router auf den **ersten** Strang fest (`hybrid_tier_stufe_soll_design.md:195`, `:463`); der zweite ist damit ein Parallelpfad ohne Gate.

### 6.6 Was der `best_binary_selector` heute tut: er SORTIERT

`best_binary_selector.cpp:167-219`, `rank_binaries`: stratifizierte Aggregation (Median je Zelle, dann Median der Zell-Mediane, `lower_median` = nearest-rank untere Mitte), aufsteigend nach Median, Tie-Break nach Sample-Zahl und `binary_id`. Plus ein ehrliches Vollstaendigkeits-Gate (`:194-200`): wer nicht alle Mess-Zellen abdeckt, wird **disqualifiziert** statt still bevorteilt.

**Das CLI erreicht den Break-Even-Teil nicht.** `best_binary_selector_main.cpp` (148 Z.) referenziert `break`/`hybrid`/`Selector` nur im Werkzeugnamen. `find_break_evens`/`HybridBinarySelector` liegen in derselben `.cpp`, sind vom `main` aus aber **tot**.

⇒ Er liefert **die beste** Binary ueber alle Zellen — eine Rangliste. Der Owner-KERN verlangt das Gegenteil: nicht *die* beste, sondern **wo die Fuehrung wechselt**.

### 6.7 Nebenbefunde am Objekt (heute verifiziert)

1. **Der historische stille Messwert-Verlust `< 17` ist GEFIXT.** `abi_adapter.hpp:1102-1106` und `:2023-2027` iterieren ueber `kV3AxisCount` (=18, `observable_tier.hpp:50`), mit dem Kommentar *"A8-S1 (2026-08-04, Befund B-6): Grenze ist kV3AxisCount, NIE ein Literal. Bis hierher stand `< 17`"*, ebenso `:2087`. **Der Laufzeit-Beleg des Alt-Defekts liegt aber vor:** in der CSV vom 26.07. ist `seg_persistence_target_ns` = **0** bei `seg_coverage` = 0.999963. **Konsequenz: Messdaten, die vor dem 04.08. entstanden sind, tragen an T17 eine stille Null und sind fuer Break-Even auf der Persistenz-Achse unbrauchbar.**
2. **Die Datenbasis ist heute zu duenn fuer Kurven-Synthese.** `SUPER/measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` = **17 Zeilen** (16 Datenzeilen). Der Kurven-Lader braucht ≥ 2 verwertbare Punkte **je Gruppe** `(sweep_axis, binary_id, workload)` und liefert sonst HONEST-EMPTY (`axis_spline.hpp:27-28`). **Break-Even ist heute nicht rechenbar, weil die Messung fehlt — nicht, weil der Code fehlt.**
3. **Keine Hysterese / Schaltstabilitaet geplant.** Suchraum LEDGER (7248 Z.), `docs/plaene/`, `CE/docs/architecture/`, `CE/libs/cache_engine/heuristik/`. Muster `hysterese|hysteresis|flapping|schwing`: **1 Treffer**, und der ist unverwandt (`axis_spline.hpp:18` "UEBERSCHWINGEN" = Spline-Overshoot). Gegenprobe: `verdraeng` liefert in denselben Dateien mehrfach Treffer (Eviction ist geplant), der Suchraum ist also nicht stumm. **Ein Router, der genau am Schnittpunkt schaltet, flattert bei Last nahe `x_be`.** `LEDGER:2298` benennt das Problem implizit (*"wenn sie bei verschiedenen Lasten sonst **zu stark divergieren**"*), loest es aber ueber mehr Binaries, nicht ueber Schaltstabilitaet. ⇒ **offene Frage O-5**.

---

## 7. Die Thesis-Zusage

### 7.1 Was genau zugesagt ist

**Einleitung** (eingebunden, DE und EN), `THESIS/kapitel/de/01_einleitung.tex:212-214`:
> *"Ein Mess-Treiber mit Defined-/Full-Modus-Unterscheidung, profilbewusstem Workload-Routing und **drei Granularitaeten — Micro-, Makro- und Gesamt-Benchmarking (einzelne Bestandteile, Interface-Operationen, ganze Algorithmen)**."*

Die Zusage wiederholt sich an drei weiteren Stellen: `aufgabenstellung/de.tex:84-96` (gesetzt, EN-Pendant `en.tex` inhaltsgleich, dort `whole-system benchmarking`), `03_messsystem_prtart.tex:1299-1309`, `05_evaluation.tex:236-241`, `06_fazit.tex:69-72`.

### 7.2 Haelt sie? — differenziert, mit Belegen

| Zusage | Traeger im Ist | Haelt? |
|---|---|---|
| **Micro** = "einzelne Bestandteile", Achse ueber ihr Achsen-Interface | 17 `<axis_sweep>` + `seg_ns[18]` liefern reale Werte — aber sie sweepen die Algorithmen-**Wahl** und messen ueber Mischformen (echte Achsen-Ops / Store-Umweg / Stats-READ, `a8_f2…:100-118`); die dedizierten Micro-Bench-Verzeichnisse sind leer (7 bzw. 2 Dateien, `.gitkeep` = 0 Byte) | **halb** |
| **Makro** = "Interface-Operationen" | `op_lat[6]` p50/p99 je {insert, lookup, erase, clear, scan, rmw} ueber `two_phase_measure`; CSV-Spalten `op_*_p50_ns/p99_ns` | **ja, dem Wortlaut nach** |
| **Gesamt** = "ganze Algorithmen" / YCSB ueber jede Rekombination | 21 Lastprofile, 6 im golden als dynamische Achse 2; `total_ns` je (Binary x Lastprofil); bias-freie Vollmatrix | **ja, dem Wortlaut nach** |
| `03_messsystem_prtart.tex:992`: *"das \emph{Mess-Tooling} **spannt die drei Granularitaeten** des Benchmarkings auf"* | Die Achse hat **0 funktionale Konsumenten** (6.1.4) und definiert Micro selbst als PMC (Widerspruch zu F2) | **NEIN — unbelegt** |

**Die Thesis widerspricht sich an dieser einen Stelle selbst — und die ehrliche Fassung steht bereits im Text.** `04_implementierung.tex:496-502`:
> *"das Mess-Tooling mit genau drei versionierten Eintraegen — Wallclock, Makro, Mikro —, dessen Wache ein viertes, unabgestimmtes Tooling zum Uebersetzungsfehler macht. Ein eigenes PMC-Tooling existiert nicht: Die Zaehler-Instrumentierung steckt im Mikro-Tooling. **Dieser Registry-Schnitt ist Implementierungs-\emph{Stand}, nicht Soll:** Das Ziel-Schnittbild ist das Achsen-Interface-Modell aus Abschnitt~\ref{sec:mess-chain} … und die Registry zieht diesem Modell nach."*

Also: **Kapitel 4 sagt es richtig, Kapitel 3 Zeile 992 sagt es falsch.** Beide sind eingebunden.

**Die Kurven-Zusage ist dagegen ehrlich gehedged**, `03_messsystem_prtart.tex:1481-1484`: *"im heutigen Stand existiert davon erst der **Keim** — eine Kurvenanpassung ueber eine Achse und eine x-Dimension —, die volle Struktur ist als Ziel formuliert."*

### 7.3 Und: Break-Even steht in KEINER Zeile der Pruefungsarbeit

**Nenner:** 30 `.tex` unter `THESIS/kapitel/` (DE+EN der sechs eingebundenen Kapitel) + `THESIS/aufgabenstellung/`; Gesamtbestand 80 `.tex`.
**Suchmuster, case-insensitiv, `/usr/bin/grep -rniE`:** `break.{0,2}even|schnittpunkt|kipppunkt|crossover|umschaltpunkt|checkpoint`.
**Treffer: 0.**
**Zweite Suche** `funktionskurve|spline`: **1 Treffer** — `03_messsystem_prtart.tex:1461`: *"die Heuristik-Achse kann daher die **Mess-Funktionskurven** fuer Schaetzungen verwenden und eine optimale mehrdimensionale Rekombination kompilieren"*.
**Gegenprobe:** `heuristik` in derselben Datei = **20 Treffer**. Der Ausdruck greift; die Null ist echt.

**Auch die Betreuer-Termine kennen den Begriff nicht.** Nenner: `docs/termine/` = **309 Dateien**, davon **38** `.docx`/`.pptx` (ZIP-Archive) plus **30** fertige Text-Extraktionen unter `20260508 Termin 7/_extracted_text/`. Muster `break.{0,2}even|schnittpunkt|kipppunkt`: **0 Treffer**. **Gegenprobe auf denselben 30 Extraktionen:** `umschaltpunkt|schwellwert|schwellen|umgeschaltet` (case-insensitiv) = **19 Zeilen-Treffer ueber 13 der 30 Dateien** (Belege in Tabelle 2.3). Die Sache ist dort also durchgaengig vorhanden — **unter anderem Namen**.

⇒ **Bilanz:** Die Thesis beschreibt an der Stelle des Mechanismus nur das *Ergebnis* (*"optimale mehrdimensionale Rekombination"*), nie den *Mechanismus*. Das Verfahren, das laut `LEDGER:3284` das **Ziel des Gesamtprojekts** traegt, ist in der Pruefungsarbeit **namenlos**.

### 7.4 Zwei Wege — die Wahl gehoert dem Owner

**Weg A — BAUEN (die Zusage einloesen).**
- A1: Micro auf den Achsen-Interface-Kern schneiden (Tabelle 3.1, 18 Zeilen) — Posten B-7.
- A2: Checkpoint-/Schritt-Instrumentierung nach Vorschlag V-1..V-5 — Posten B-8.
- A3: Aggregations-Artefakt je Lastprofil ueber die Funktions-Charts — neu.
- **Kosten:** alle drei sind Nach-Abgabe-Posten (`LEDGER:4637-4640` fuehrt B-7/B-8/B-9/B-10 ausdruecklich als *"nach Abgabe"*). **Bis zur Abgabe aendert Weg A nichts am Textbestand.**
- **Konsequenz fuer die Abgabe:** die Zusage in `01_einleitung.tex:213` bliebe stehen, obwohl Micro heute halb und die Registry-Behauptung `03:992` unbelegt ist.

**Weg B — AUSSAGE PRAEZISIEREN (den Text auf den Stand ziehen).**
- B1: **`03_messsystem_prtart.tex:992` korrigieren.** Statt *"das Mess-Tooling spannt die drei Granularitaeten des Benchmarkings auf"* → *"das Mess-Tooling benennt die drei Mess-Instrumente (Wallclock, Makro-Observer, Mikro-Zaehler); die drei **Granularitaeten** sind davon unabhaengig ueber die Mess-Gegenstaende geschnitten (Achse / Gattungs-Operation / Lastprofil), siehe Abschnitt~\ref{sec:mess-chain}."* Das ist ein **Ein-Satz-Eingriff**, er macht Kapitel 3 mit dem bereits richtigen Kapitel 4 (`04:499-502`) konsistent und beseitigt den einzigen unbelegten Satz.
- B2: **Micro-Formulierung ehrlich hedgen** (nach dem Muster, das die Arbeit an `03:1481` bereits benutzt): ein Halbsatz, der sagt, dass der Achsen-Interface-Schnitt das Ziel-Schnittbild ist und der heutige Stand ueber die Achsen-Wahl misst.
- **Kosten:** zwei Saetze, keine Bau-Arbeit, vor der Abgabe machbar.
- **Risiko:** keins — beide Formulierungen sind schwaecher als der heutige Text und durch Kapitel 4 gedeckt.

**Empfehlung des Autors dieses Dokuments (nicht Plan):** **B jetzt, A nach der Abgabe.** B1 ist die einzige Aenderung, die eine **unbelegte Behauptung in einer Pruefungsarbeit** beseitigt; sie kostet einen Satz. A bleibt als B-7..B-10 im Ledger stehen und wird in der Auswertungsphase gebaut. Zusaetzlich **B3 (empfohlen, gering):** einen Satz in Kapitel 3 oder 6, der den **Begriff Break-Even** einmal nennt und mit H2 verbindet — heute traegt die Arbeit den Titel-Beitrag namenlos.

---

## 8. Was ins Ledger gehoert

Fertig formulierte Eintraege. Sie sind so geschrieben, dass sie ohne Umformulierung uebernommen werden koennen.

### 8.1 Bau-Posten (Ergaenzung/Praezisierung zu `LEDGER:4637-4640`)

```
| B-7  | MICRO auf den Achsen-Interface-Kern schneiden: je Achse T0..T17 den
|      | Ebene-1-Messvertrag aus 20260803-a8_f2_benchmarking_schnitt_soll_design.md:187-206
|      | als eigenen Micro-Treiber; KEIN synthetischer Parallel-Puffer, KEIN Store-Umweg,
|      | KEIN Stats-READ als Zeit-Surrogat (ebd. :208-211). Fuellt benchmarks/microbenchmarks/
|      | und libs/cache_engine/builder/runtime_micro_benchmarks/ (heute je .gitkeep, 0 Byte).
|      | Klasse: offen | Wann: nach Abgabe | Abh.: A8-S-Kette (Schnitt-Form B)

| B-8  | MACRO(timed): Checkpoint-/Schritt-Instrumentierung einer Gattungs-Funktion.
|      | Owner-KERN 06.08.: "Gesamt-Messprofile timed einer Funktion ueber die Schritte und
|      | checkpoints ihrer Ausfuehrung ... ueber alle Achsen die sie verwendet hat".
|      | Ist-Stand: EXISTIERT NICHT (0 Treffer lap/split/phase/stage/step/marker/trace_point;
|      | Gegenprobe seg_ns=326). Vorhandene fill_checkpoints (tier_observe_trace_abi.hpp:34)
|      | sind FUELLSTANDS-, keine Ausfuehrungs-Checkpoints; ihre CSV exportiert 2 von 18 Achsen
|      | (ebd. :281-290). Schnitt-Vorschlag liegt vor (PLAN 20260806, Abschnitt 3.2.5 V-1..V-5),
|      | Owner-Entscheid offen (O-4).
|      | Klasse: offen | Wann: nach Abgabe | Abh.: B-3/B-5 (Semantik der Rohdaten)

| B-9  | Funktions-Synthese + Break-Even-Rechnung als PRODUKTIVE Kette:
|      | measurement_curve_loader -> axis_spline -> break_even -> PERSISTIERTE Break-Even-Tabelle.
|      | Ist-Stand: die drei Header existieren und sind §75-geschuetzt (LEDGER:3602), haben aber
|      | 0 produktive Konsumenten (Nenner: 203 comdare_add_test, 10 apps; nur 2 Tests rufen sie).
|      | ES GIBT KEIN PERSISTENZ-ARTEFAKT: kein Serialisierer, keine CSV-Spalte, keine
|      | XML-Rueckschreibung, kein generiertes constexpr-Array. Das Zielformat ist zu entscheiden (O-6).
|      | Klasse: offen | Wann: nach Abgabe | Abh.: reale Messung (heute 16 Datenzeilen = zu duenn)

| B-10 | Hybrid-Schaltungs-Adapter libs/cache_engine/hybrid/ (heute NUR README.md, 58 Z.,
|      | reservierter Stub, NICHT in CMakeLists eingetragen). Neun geplante Header, darunter
|      | hybrid_router.hpp = Break-Even-Router (CT-CoR). Paketschnitt HY-B1a..HY-B4 liegt fertig
|      | in 20260802-hybrid_tier_stufe_soll_design.md:396-402.
|      | Klasse: TIER-beruehrend | Wann: nach B-9

| B-11 | NEU: Aggregations-Artefakt "MACRO large scope" — je Lastprofil die Gesamtheit der
|      | Macro-Charts aller aufgerufenen Gattungs+Genus-Funktionen auf dem Tier-Binary-Interface.
|      | Ist-Stand: NICHT GEFUNDEN (Nenner Code/04+05+08 = 24 Dateien; Gegenprobe kurve|curve = 36).
|      | Der Diagramm-Generator zeichnet die Einzelkurven bereits (diagram_generator.hpp:397-405),
|      | die Buendelung je Lastprofil fehlt. Form (Diagramm-Buendel vs. Datenstruktur) offen (O-3).
|      | Klasse: offen | Wann: nach Abgabe | Abh.: B-8
```

### 8.2 Risiko-/Bereinigungs-Posten

```
| R-1  | ZWEI divergierende Break-Even-Implementierungen ohne Gate:
|      | heuristik::BreakEvenPoint (break_even.hpp:43-48, Hermite + Knotengitter, §75-geschuetzt)
|      | gegen best_binary::BreakEvenPoint (best_binary_selector.hpp:321-327, stueckweise linear
|      | + festes 256-Raster, ungeschuetzt, selbst als SKELETON deklariert :263/:274-276).
|      | Das feste Raster kann Schnittpunkte UEBERSPRINGEN, die das Knotengitter garantiert findet.
|      | SOLL-Design legt den Router auf den ERSTEN Strang fest (hybrid_tier_stufe_soll_design.md:195).
|      | ⇒ Der zweite Strang braucht entweder eine Speisung aus dem ersten (S7-Zusage, :275)
|      | oder einen ausdruecklichen Deprecation-Vermerk. Entscheid offen (O-7).

| R-2  | ALT-MESSDATEN vor 2026-08-04 tragen an T17 (persistence_target) eine STILLE NULL.
|      | Ursache: `< 17` statt kV3AxisCount in abi_adapter.hpp (gefixt an :1102-1106 / :2023-2027 /
|      | :2087). Beleg des Alt-Defekts: measurement/20260726-164259-d03-strukt-r-erstbeleg/
|      | measurements.csv, seg_persistence_target_ns = 0 bei seg_coverage = 0.999963.
|      | ⇒ Diese CSVs sind fuer Break-Even auf der Persistenz-Achse UNBRAUCHBAR und muessen
|      | im Lager als solche markiert sein (Messdaten NIE loeschen — Doktrin).

| R-3  | KEINE SCHALTSTABILITAET geplant. Suchraum LEDGER + docs/plaene + CE/docs/architecture +
|      | heuristik/: Muster hysterese|hysteresis|flapping|schwing = 1 Treffer, unverwandt
|      | (axis_spline.hpp:18 "UEBERSCHWINGEN" = Spline-Overshoot). Gegenprobe: "verdraeng"
|      | trifft mehrfach, der Suchraum ist nicht stumm.
|      | Ein Router, der exakt am Schnittpunkt schaltet, flattert bei Last nahe x_be.
|      | ⇒ Hysterese-Band / Mindest-Verweildauer / Konfidenz auf x_be sind zu entscheiden (O-5).
```

### 8.3 Thesis-Posten (vor der Abgabe entscheidbar)

```
| T-1  | 03_messsystem_prtart.tex:992 behauptet, das Mess-Tooling "spanne die drei Granularitaeten
|      | des Benchmarkings auf". UNBELEGT: MeasurementTooling:: hat 3 Treffer, alle in der
|      | Registry selbst; die Achse veraendert keine kompilierte Instrumentierung
|      | (a8_f2…:93-97), und im golden kollabiert sie auf 1 Combo
|      | (all_axes_golden.profile.xml:221-225). 04_implementierung.tex:496-502 sagt es bereits
|      | richtig ("Implementierungs-Stand, nicht Soll") — Kapitel 3 widerspricht Kapitel 4.
|      | ⇒ EIN-SATZ-KORREKTUR vorgeschlagen (PLAN 20260806, Abschnitt 7.4 Weg B1). Owner-Entscheid.

| T-2  | Der Begriff BREAK-EVEN kommt in KEINER Zeile der Pruefungsarbeit vor.
|      | Nenner: 30 eingebundene .tex (DE+EN + Aufgabenstellung); Muster
|      | break.{0,2}even|schnittpunkt|kipppunkt|crossover|umschaltpunkt|checkpoint = 0 Treffer;
|      | Gegenprobe "heuristik" in 03_messsystem_prtart.tex = 20. Die Termine kennen die Sache
|      | unter "Umschaltpunkt/Schwellwert" (19 Zeilen / 13 von 30 Extraktionen), nicht "Break-Even".
|      | Die Arbeit beschreibt nur das ERGEBNIS ("optimale mehrdimensionale Rekombination", 03:1461),
|      | nie den MECHANISMUS — obwohl LEDGER:3284 ihn als Ziel des Gesamtprojekts fuehrt.
|      | ⇒ Ein Satz, der den Begriff nennt und mit H2 verbindet, wird empfohlen (7.4 B3). Owner-Entscheid.
```

### 8.4 Kanon-Eintrag (Formulierung fuer den stabilen Teil des Ledgers)

```
BREAK-EVEN-KANON (Owner-KERN 06.08.2026 abends):
 - Break-Even = Schnittpunkt zweier Parameter-Funktionskurven; er zeigt an, AB WANN ein
   Algorithmus in EINEM Parameter ueber EINE Achse als Organ effektiver wird.
   Es ist ein KIPPPUNKT, kein Optimum: der Punkt traegt links_besser UND rechts_besser.
 - Break-Even ist die OPERATIVE FORM VON HYPOTHESE H2 (Termin 1, 30.03.2026): wenn es
   keine universell beste Darstellung gibt, ist die Frage nicht "welche ist die beste",
   sondern "ab wo ist welche besser". Termin-Kette: T1 experimentelle Schwellen ->
   T2 I5 "feste universelle Schwellwerte werden nicht behauptet" -> T3 "Umschaltpunkt
   explizit vermessen" -> T4 parametrierbar -> T5 R2 -> T6 Kalibrierungs-Grundwahrheiten.
 - DREI EBENEN, geschnitten nach MESS-GEGENSTAND (nicht nach Instrument):
   MICRO = Achse ueber ihr Achsen-Interface;
   MACRO(timed) = eine Gattungs+Genus-Funktion, ueber ihre Schritte und Checkpoints,
                  zerlegt nach allen Achsen die sie verwendet hat;
   MACRO large scope = ein Lastprofil, ueber alle dafuer aufgerufenen Funktionen
                  auf dem Tier-Binary-Interface.
   Verhaeltnis: Summe(E1-konstitutiv) <= E2 <= E3, Rest explizit benannt
   (a8_f2_benchmarking_schnitt_soll_design.md:222).
 - ABGRENZUNG (ENTSCHIEDEN durch diesen Eintrag): die Mess-Tooling-Haupt-Achse
   {wallclock, macro, micro} ist NICHT diese Dreiergruppe. Sie schneidet INSTRUMENTE,
   die Ebenen schneiden GEGENSTAENDE; die Gruppen sind orthogonal und nur namensgleich.
   Das Gegenstands-Konstrukt im Kanon ist E1/E2/E3 aus dem F2-Gesetz (ebd. :66-68).
   ⇒ Beantwortet die offene Frage F6 (LEDGER:6260) in der Sache mit "nur die Fehl-Deutung
     ist verworfen, nicht das §47-Auswahl-Achsen-Konzept" — Owner-Bestaetigung noch offen (O-8).
```

---

## 9. Offene Fragen an den Owner — je mit Empfehlung

**O-1 — Welche Schnitt-Arten gelten?**
Der KERN nennt Schnitte *"zwischen Parametern verschiedener Achsen **und** der Gattungs-/Genus-Funktionsinterfaces"*. Geplant und gebaut ist nur der Schnitt **innerhalb einer Achse** (`break_even.hpp:3`, `LEDGER:2301`); die Ausweitung steht im Ledger nur im Konjunktiv (*"moeglicherweise … unter Hinzunahme der System-Achsen"*).
**Empfehlung:** achsen-intern bleibt der **Pflicht**-Schnitt (er ist mathematisch sauber isolierbar, weil die Baum-Matrix voll permutiert ist). Achsen-kreuzend und Gattungs-Interface-Schnitt als **zweite Stufe** nach der ersten Auswertung, weil sie ohne die Konstitutiv-Matrix (`a8_f2…:196-201`) nicht interpretierbar sind.

**O-2 — Welche Parameter traegt MICRO ausser `working_set_n`?**
Heute ist genau eine x-Dimension kanonisiert (`measurement_curve_loader.hpp:57`), und die Thesis nennt das selbst *"erst den Keim"* (`03:1481-1484`). Der volle Satz waere laut `03:1484-1486`: Lastprofil-Rahmenwerk, Workload-Typ, Working-Set-Groesse, Operationstyp, Beobachter-Typ.
**Empfehlung:** fuer die erste Auswertung `working_set_n` **plus** Operationstyp (letzterer liegt in `op_lat` bereits vor, kostet also keine neue Messung). Die uebrigen Dimensionen erst, wenn die Datenmenge sie traegt.

**O-3 — Ist ein "Chart" ein Diagramm oder eine Datenstruktur?**
Im Repo gibt es nur **Diagramme** (`Code/05_diagram_generator`), keine Chart-Datenstruktur. *"Die Gesamtheit der Macro-Charts eines Lastprofils"* kann also (a) ein Diagramm-Buendel im Anhang sein oder (b) eine aggregierte Tabelle, aus der die Diagramme folgen.
**Empfehlung:** **(b) zuerst** — eine Tabelle `(lastprofil, funktion, achse) -> {ns, anteil}` ist maschinenlesbar, speist den Break-Even-Rechner **und** den Diagramm-Generator. Das Diagramm-Buendel folgt daraus kostenlos; umgekehrt nicht.

**O-4 — Was ist ein "Schritt"/"Checkpoint" innerhalb einer Funktion?**
Der Plan schweigt dazu (Nachweis in 3.2.4: 0 Treffer bei 7 Mustern, Gegenprobe 326). Vorschlag V-1..V-5 liegt in 3.2.5 vor: Schritt = Achsen-Interface-Aufruf-Grenze, Anzahl = Zahl der konstitutiv verwendeten Achsen, Ergebnis = `op_axis_lat[6][18]`.
**Empfehlung:** V-1 annehmen. Er erfindet kein Vokabular, folgt der ohnehin geforderten Konstitutiv-Matrix, ist gegen `seg_ns` **verifizierbar** (Summenprobe) und braucht keinen zweiten Mess-Pfad.

**O-5 — Schaltstabilitaet: Hysterese, Mindest-Verweildauer, Konfidenz auf `x_be`?**
Nirgends geplant (Nachweis 6.7.3, 1 unverwandter Treffer, Gegenprobe positiv). Ein Router, der exakt am Schnittpunkt schaltet, flattert bei Last nahe `x_be`; jeder Umschalt-Vorgang kostet (Option 2 = Binary hot ans Dock laden, `LEDGER:2298`).
**Empfehlung:** Hysterese-Band als **Konfidenz-Band aus den Messdaten**, nicht als frei gesetzte Konstante — d.h. `x_be` wird nicht als Punkt, sondern als Intervall gefuehrt, dessen Breite aus der Streuung der Stuetzstellen folgt. Innerhalb des Bandes bleibt die zuletzt gewaehlte Binary aktiv. Das ist konsistent mit T2/I5 (*"feste universelle Schwellwerte werden nicht behauptet"*).

**O-6 — In welcher Form wird der Break-Even-Punkt persistiert?**
Heute gar nicht (6.4: nur lokale `std::vector`). Kandidaten: (a) CSV-Sidecar neben der Mess-CSV, (b) XML-Rueckschreibung ins Lastprofil-Ergebnis, (c) generierter `constexpr`-Header fuer den CT-Router.
**Empfehlung:** **(a) und (c)** — (a) fuer die Nachvollziehbarkeit in der Arbeit (ein Break-Even-Punkt ist ein Messergebnis und gehoert ins Lager), (c) weil der Router laut `hybrid_tier_stufe_soll_design.md:192-197` eine **Compile-Time**-CoR ist und die Schwellen zur Uebersetzungszeit braucht. (b) zusaetzlich, sobald die Aufgabenstellung-Zusage *"XML-Lastprofil-Ergebnis"* (`aufgabenstellung/de.tex:105`) eingeloest wird.

**O-7 — Welcher der zwei Break-Even-Straenge ist der maassgebliche?**
`heuristik::` (Hermite, §75-geschuetzt) gegen `best_binary::` (linear, 256-Raster, SKELETON). Das SOLL-Design nennt den ersten; der zweite ist ungegatet.
**Empfehlung:** `heuristik::` ist maassgeblich. `best_binary::find_break_evens`/`break_even_table` entweder auf `heuristik::` umstellen (die `eval()`-Kontur ist laut `best_binary_selector.hpp:275` genau dafuer vorgesehen) oder mit einem Deprecation-Kopf versehen. Ohne eine der beiden Handlungen bleibt eine zweite, numerisch schwaechere Wahrheit im Repo.

**O-8 — Bestaetigt der KERN die Aufloesung von F6?**
`LEDGER:6260` fuehrt als offene Frage F6: *"Verwirft 'Micro-/Macro-Benchmarking sind FALSCH' AUCH das aeltere §47-Auswahl-Achsen-Konzept selbst (CT-Achse Mess-Tooling), oder nur die Fehl-Deutung?"* Der KERN vom selben Abend stellt Micro/Macro als **Ebenen**-Vokabular wieder her.
**Empfehlung:** F6 mit **"nur die Fehl-Deutung"** schliessen und den Kanon-Eintrag 8.4 uebernehmen: die Mess-Tooling-Achse bleibt als **Instrumenten**-Achse gueltig (mit dem offenen Punkt der 0 Konsumenten), die drei **Ebenen** sind der Gegenstands-Schnitt E1/E2/E3. Damit ist der Namenskonflikt aufgeloest, ohne §47 zu verwerfen.

**O-9 — Reihenfolge gegen die Abgabe.**
Alle Bau-Posten B-7..B-11 sind *"nach Abgabe"* (`LEDGER:4637-4640`). Vor der Abgabe entscheidbar sind nur T-1 und T-2 (Textkorrekturen, zwei Saetze).
**Empfehlung:** T-1 vor der Abgabe ausfuehren (beseitigt die einzige unbelegte Behauptung), T-2 nach Owner-Ermessen. Kein Bau vor der Abgabe.

---

## 10. Herkunfts-Vermerk (Ehrlichkeits-Auflage)

Zwei Dinge muessen fuer die spaetere Lesbarkeit dieses Dokuments festgehalten werden:

1. **Der Ledger-Abschnitt `### 11. BREAK EVEN UND DIE DREI BENCHMARK-EBENEN` (`LEDGER:4580ff`) ist am Abend des 06.08.2026 entstanden** (Datei-Zeitstempel `2026-08-06 23:25:47`, Dokument-Erhebung ab ~23:20). Er ist die **Mitschrift des KERNs**, nicht ein Beleg dafuer, dass die drei Ebenen vorher als Break-Even-Traeger geplant gewesen waeren. Was **vorher** existierte und in diesem Dokument als BELEGT gefuehrt wird: die drei Granularitaeten (Aufgabenstellung, alle sechs Kapitel), Break-Even als Spline-Schnittpunkte (`LEDGER:2296-2301`, §32-F8, seit spaetestens 20.07.), die Checkpoint-Mechanik (Owner-Direktive 30.05., `24_messmodell_korrektur_zwei_dimensionen.md:468-491`), der Lastprofil-Katalog und die drei Wallclock-Ebenen E1/E2/E3 (F2-Gesetz 01.08.).
2. **Die Drei-Ebenen-Struktur stammt aus der Aufgabenstellung, nicht aus den Betreuer-Terminen.** Termin 3 — laut Auftrag die Primaerquelle fuer den Benchmark-Plan — traegt eine **andere** Dreiteilung: eine Metrik-Tabelle *"Ebene \|\| Pflichtmetriken \|\| Werkzeug"* = End-to-End / Counter lokal / Counter Barnard / Memory-Access-Analyse (`_extracted_text/20260409 Termin 3__20260409_PRT_ART_Benchmark_und_Datensatzplan_Termin3_final.docx.txt`, 112 Z., vollstaendig gelesen). Das ist {Aggregation, Counter, Simulation} — keine Granularitaets-Hierarchie. Die naechstliegende Termin-Wurzel ist Termin 6 und sie ist **zweistufig**: *"Die Verifikation wird zweistufig aufgebaut: zuerst Kalibrierungs-Mikrobenchmarks der Cache-Engine, danach eigentliche Such- und Mischlasten"* (`…20260416_Arbeitsaufstellung_PRT_ART_Termin6_final.docx.txt:6`). **Die drei Granularitaeten sind eine Eigen-Zusage der Arbeit** — was ihre Einloesung nicht weniger verbindlich macht, sondern mehr: es gibt keinen Betreuer-Text, auf den man sie zurueckdrehen koennte.

---

## 11. Fundstellen-Verzeichnis (absolute Pfade)

**Plan / SSOT**
- `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine/docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` — §32-F8 `:2296-2301`, §32-F8-3 `:2606`, §49 `:2687-2696`, Status `:2958`, Ziel `:3284`, §75-Freihaltung `:3602`, Ruf-Kette `:4076`, 4-Modi `:4178`, Ketten-Bild `:4229`, KERN + Ebenen `:4580-4624`, Bau-Posten `:4637-4643`, F6 `:6260`

**Architektur-Dossiers**
- `…/Code/external/comdare-cache-engine/docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md` (492 Z.) — F2-Gesetz `:60-68`, Registry-Widerspruch `:90-97`, drei Mess-Pfade `:100-118`, Achsen-Interface-Kern `:187-211`, Konsistenz-Invariante `:222`
- `…/Code/external/comdare-cache-engine/docs/architecture/20260802-hybrid_tier_stufe_soll_design.md` — Dateiliste `:90`, Break-Even-Router `:192-197`, XML `:232`, heuristik-API-Freeze `:296`, Pakete HY-B1a..B4 `:396-402`, Heuristik-Substrat `:463`
- `…/Code/external/comdare-cache-engine/docs/architecture/24_messmodell_korrektur_zwei_dimensionen.md` — Owner-Direktive Checkpoints `:468-491`
- `…/Code/external/comdare-cache-engine/docs/architecture/32_lastprofil_katalog_und_paper_bias.md` — LP01–LP14 `:9-25`

**Code (CE)**
- `…/libs/cache_engine/heuristik/break_even.hpp` · `axis_spline.hpp` · `measurement_curve_loader.hpp`
- `…/libs/cache_engine/builder/curve_fit/curve_fit.hpp` · `builder/decision_lambda_trees/decision_lambda_trees.hpp`
- `…/libs/cache_engine/builder/best_binary_selector/best_binary_selector.{hpp,cpp}` · `best_binary_selector_main.cpp`
- `…/libs/cache_engine/builder/anatomy_commands/{tier_observe_trace_abi,tier_observe_trace,genus_tier_observe_trace_abi}.hpp`
- `…/libs/cache_engine/anatomy/{observable_tier.hpp,abi_adapter.hpp}`
- `…/libs/cache_engine/builder/experiment_tree/cache_engine_builder_iterator.hpp`
- `…/libs/cache_engine/include/cache_engine/measurement/measurement_tooling_registry.hpp`
- `…/libs/cache_engine/hybrid/README.md` (reservierter Stub, einzige Datei)
- `…/libs/cache_engine/algorithm_profiles/load_profiles/` (21 XML + SCHEMA.md) · `thesis_profiles/all_axes_golden.profile.xml`
- `…/benchmarks/microbenchmarks/` · `…/libs/cache_engine/builder/runtime_micro_benchmarks/` (leere Skelette)
- `…/tests/unit/{test_heuristik_spline_break_even,test_hybrid_spline_selector_scaffold}.cpp`

**Code (super)**
- `…/Code/05_diagram_generator/diagram_generator.hpp` · `…/Code/08_appendix_generator/` · `…/Code/04_csv_to_latex/`
- `…/Code/test_data_xml/experiment_golden_kern.xml:382`
- `…/measurement/20260726-164259-d03-strukt-r-erstbeleg/measurements.csv` (17 Z.)

**Thesis**
- `…/thesis/diplomarbeit/aufgabenstellung/de.tex:84-105` (+ `en.tex`)
- `…/thesis/diplomarbeit/kapitel/de/01_einleitung.tex:212-214`
- `…/thesis/diplomarbeit/kapitel/de/02_suchbaeume_grundlagen.tex:390-394`
- `…/thesis/diplomarbeit/kapitel/de/03_messsystem_prtart.tex:992`, `:1299-1318`, `:1455-1465`, `:1478-1486`
- `…/thesis/diplomarbeit/kapitel/de/04_implementierung.tex:494-503`
- `…/thesis/diplomarbeit/kapitel/de/05_evaluation.tex:234-242`
- `…/thesis/diplomarbeit/kapitel/de/06_fazit.tex:64-72`

**Termine (Primaerquelle, 309 Dateien / 38 Archive / 30 Text-Extraktionen)**
- `…/docs/termine/20260508 Termin 7/_extracted_text/` — H2 `20260330 Termin 1__…Literatur_und_Arbeitsplanung…:7`; Forschungsfrage `20260330 Termin 1__20260326 Expose…:9`; I5 + Kalibrierungs-Zeitpunkt + Risiko `20260330 Termin 2__…Architekturentscheidungen…:57,:13,:65`; Umschaltpunkt-Messachse `20260409 Termin 3__…Arbeitsaufstellung…:79`; Parametrierung `20260412 Termin 4__…Scope_Freeze…:29`; R2 `20260412 Termin 5__…Forschungslandkarte…:60`; drei Kalibrierungs-Modi + Knicke `20260416 Termin 6__…Scope_Freeze…:9,:45`; Zweistufigkeit `20260416 Termin 6__…Arbeitsaufstellung…:6`
- `…/docs/termine/20260409 Termin 3/20260409_PRT_ART_Benchmark_und_Datensatzplan_Termin3_final.docx`
