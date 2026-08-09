# MeasureStorage — DESIGN und DEEP RESEARCH, 09.08.2026

> **Auftrag:** Owner 09.08.: *„wir brauchen einen **deep research**, wie aggregierte Parameter
> latenzarm für checkpoint_measure in einen möglichst großen **vor-reservierten custom
> Speicherbereich per APPEND** gepusht werden können, weil **neue Allokationen für die
> Messwert-Aggregation VERBOTEN sind, weil sie das Bild der Messungen verzerren**."*
>
> **Verfahren:** Strang 30 (`wdp4w6qs6`) — drei Bestands-Linsen (Sonnet 5 max) plus ein
> Web-Research über den Stand der Technik, dann Design mit Fable 5 max.

---

## ⭐ OWNER-FREIGABE 09.08.2026: VOLLES GO — und die Zwei-Arenen-Struktur

> **„Alle anderen Annahmen von dir: volles GO, alles korrekt."**

Damit sind die acht Punkte unten **Festlegung, nicht Vorschlag**. Und der Owner hat dabei die
innere Struktur präzisiert:

> „es gibt also eine **Arena für die Messergebnisse mit nur append und Auswertung zum Schluss**,
> und es gibt einen **Stack, der von checkpoint_measure in einer GETRENNTEN custom Arena** prüft,
> **auf welcher Mess-Ebene wir uns befinden und in welchem Modul+Funktion**. checkpoint_measure hat
> also **2 interne Systeme — Mess-Arena und Stack-Arena, custom**."

### ZWEI GETRENNTE ARENEN — nicht ein Bereich mit zwei Abschnitten

| | **MESS-ARENA** | **STACK-ARENA** |
|---|---|---|
| **Zweck** | die Messergebnisse | **wo bin ich gerade?** — Mess-Ebene + Modul + Funktion |
| **Zugriff** | **nur APPEND** | **LIFO** — push beim Eintritt, pop beim Austritt |
| **Wachstum** | **monoton** über den ganzen Lauf | **auf und ab** mit der Verschachtelung |
| **Dimension** | erwartete **Ereigniszahl** (`--check-size`) | maximale **Verschachtelungstiefe** |
| **Auswertung** | **zum Schluss**, nach dem Lauf | **während** des Laufs, bei jedem Checkpoint |
| **Inhalt** | Records (POD) | **Referenzen** (Index/Offset), keine Kopien |

**Warum die Trennung wesentlich ist — vier Konsequenzen für den Bau:**

**1. Die Dimensionierung ist grundverschieden.** Die Mess-Arena skaliert mit der Zahl der
Messpunkte (potenziell Millionen), die Stack-Arena mit der **Schachtelungstiefe** (typisch
einstellig). Beide in **einen** Bereich zu legen hieße, die kleine Struktur an der großen zu
dimensionieren — oder umgekehrt einen Überlauf zu riskieren.

**2. Die Lebensdauer ist verschieden.** Die Mess-Arena wird **nie** zurückgesetzt (bis zum
Lauf-Ende), die Stack-Arena **ständig**.

**3. Das Überlauf-Verhalten ist verschieden — und das ist ein Fehlerklassen-Unterschied.**
Eine volle Mess-Arena bedeutet **Datenverlust** und muss **laut** werden. Ein voller Stack
bedeutet **zu tiefe Verschachtelung** — ein **Programmierfehler**, kein Kapazitätsproblem. Zwei
verschiedene Diagnosen, die nicht dieselbe Meldung teilen dürfen.

**4. Getrennte Cachelines.** Der Stack wird bei **jedem** Checkpoint gelesen **und** geschrieben,
die Mess-Arena nur geschrieben. Sie in derselben Cacheline zu führen wäre ein selbstgemachtes
**False-Sharing-Problem** — in genau dem Modul, das solche Effekte messen soll.

**Was daraus für die Aufrufer-Rekonstruktion folgt:** der Stack trägt **Mess-Ebene · Modul ·
Funktion**. Das erklärt, warum das Aufrufer-Tripel beim **Auslesen** rekonstruiert wird statt bei
jedem Checkpoint mitgeschrieben zu werden — **im Log steht der Verweis, im Stack die Herkunft.**

---

## DIE EMPFEHLUNG IN ACHT PUNKTEN

**1. Reservierung: EIN anonymer `mmap`**, dimensioniert über den `--check-size`-Hook.
**`std::pmr::monotonic_buffer_resource` als KONZEPT, nicht als Typ** — es fügt einen virtuellen
`do_allocate`-Aufruf ein, den niemand braucht, weil keine STL-Container gefüttert werden, sondern
POD-Records geschrieben. Virtueller Adressraum ist auf 64 Bit billig; **physisch committen nur so
viel, wie der Checkpoint-Zähler vorhersagt** — nicht den ganzen „möglichst groß"-Bereich.

> **Das Prinzip läuft bereits im eigenen Forschungskorpus:** `leanstore` reserviert seinen
> kompletten Puffer-Pool in **einem** `mmap`-Aufruf (`BufferManager.cpp:41`).

**2. Struktur: linear wachsendes Append-Log je Thread, KEIN Ring.**
Alle gefundenen Referenzsysteme konvergieren **unabhängig** auf dasselbe Muster — Perfetto
(TraceWriter-Chunk je Producer), LTTng (Subbuffer je CPU), Tracy (Queue je Thread), moodycamel
(Sub-Queue je Producer). **Ein Ring löst ein Problem, das hier nicht existiert:** der Owner
verlangt „nie überschreiben", und es gibt keinen nebenläufigen Leser. Selbst LTTng degeneriert im
Discard-Modus funktional zum linearen Log mit Überlaufzähler.

**3. Kein Lock, kein zwingendes Atomic im Hot-Path** — solange die Messung singlethread läuft.
Das Thread-Feld bleibt trotzdem im Record (für Debug=parallel).

**4. Der „Stack" ist NICHT das Append-Log.** Er ist die **LIFO-Buchhaltung für die
Aufrufer-Rekonstruktion** und hält nur **Referenzen** (Index/Offset), keine Kopien. Seine Kapazität
ist durch die **maximale Verschachtelungstiefe** begrenzt, nicht durch die Ereigniszahl — ein
Array plus Top-Zähler genügt.

**`std::stack` wäre aus drei unabhängigen Gründen schädlich**, nicht nur einem:
- der Default-Container `std::deque` **alloziert bei jedem Blockübertritt** — schon ein einzelnes
  Element alloziert den vollen Block (auf 64-Bit-libstdc++ das **Achtfache** der Objektgröße),
- eine zusätzliche **Zeiger-Indirektion** pro Zugriff,
- die Adapter-Schicht bringt gegenüber einem rohen Index-Array **keinen Mehrwert**.

**5. Cache-Alignment mit einer verifizierten HAUSKONSTANTE**, **nicht** mit
`std::hardware_destructive_interference_size` — dessen Wert ist laut Clang-Dokumentation *„not
stable between releases"* und hängt von Compiler-Flags ab. **Bei sechs CEB-Varianten mit
verschiedenen Flags ist das ABI-Risiko real, nicht theoretisch.**

**6. Keine pauschalen Huge Pages.** Systemweites THP `always` kann **synchrone Compaction**
auslösen — **Latenzspitzen genau in dem Moment, den man messen will**. Sicher ist nur gezieltes
`madvise(MADV_HUGEPAGE)` auf **diese eine** Reservierung, **plus Pre-Touch VOR dem Lauf**: die
Kosten wandern in die Initialisierung statt in die Messung.

**7. Roh aufnehmen, nicht bucket-komprimieren.** Der Owner-Kanon ist eindeutig: die Hauptmessung
erfasst **stumpf in voller Granularität**, die Perzentil-Ableitung erst nachgelagert.
**HdrHistogram ist Vorbild für das ALLOKATIONSPRINZIP** (einmal großzügig reservieren, danach nur
Index-Arithmetik) — **nicht für die verlustbehaftete Bucket-Politik.** Die fertige
`LatencyHdrHistogram` gehört in die **compare-Phase**, nicht in `checkpoint_measure`.

**8. Der Export darf frei allozieren** — er läuft strikt **nach** der Messung. Die bereits gebaute
`ErgebnisMappe` ist genau dafür da (*„der Writer schreibt, er bewertet nicht"*) und sollte
**Konsument** von `measure_to_latex` sein, statt dass MeasureStorage einen zweiten xlsx-Schreiber
bekommt.

---

## ⚠️ DIE GEFÄHRLICHSTEN BESTANDS-FALLEN

**Zwei Kandidaten sehen aus wie die gesuchte Vorlage und sind es nicht.** `ThreadArena` und
`InMemoryMeasurementBuffer` tragen die richtigen Namen, den Kommentar *„Hot-Path… kein Lock"* und
`alignas(64)` — **verletzen aber genau die Randbedingung**, um die es geht.

**`LIFOStackBuffer` ist eine Queuing-Achse des GEMESSENEN Containers**, kein Mess-Aggregat. Wer
nach „Stack" greppt, findet überwiegend False Positives.

**Der einzige wirklich allokationsfreie Mechanismus im Haus** (`IMeasurableWorkloadV3` /
`ComdareSegmentLatencyV2`) hat **0 Aufrufer** in der Produktionskette — fertig implementiert,
interface-getestet, nie angeschlossen. **Warum, ist ungeklärt.**

**Und `csv_to_latex` ist kein totes Auslaufmodell**, sondern ein großes, aktives, getestetes Modul
mit CLI und mehreren Konsumenten in der Thesis-Anhang-Pipeline. *„measure_to_latex bauen"* heißt
also **Ablösung mit Migrationspfad**, nicht Neubau auf der grünen Wiese.

---

Alle tragenden Befunde sind am Objekt nachgeprüft. Ich habe genug für das vollständige Design und liefere es jetzt als Ergebnis.

# MeasureStorage — DESIGN (Strang 30, Stand 09.08.2026)

---

## TEIL 1 — NACHPRÜFUNG DER TRAGENDEN BEFUNDE

Jeder Befund selbst am Objekt gelesen, nicht aus den Linsen übernommen. Ergebnis: **Kern bestätigt, 4 Korrekturen, 3 Neufunde, die keine Linse hatte.**

**Bestätigt (selbst gelesen):**
- **Live-Allokationspfad 1 [LAEUFT]:** `workload_orchestrator.hpp` — genau 6 `push_back` (Z.86,103,114,125,141,157) in 6 leer initialisierte Vektoren (Z.49–54); genau 2 `reserve` im File (Z.188: `results`, Z.210: ein String) — **keiner betrifft die 6 Latenz-Vektoren** (Nenner: 7 push_back-Zeilen gesamt, die 7. ist `results.push_back` Z.196). `WorkloadRunResult r;` ist stack-lokal je Zelle (Z.72).
- **PMC-Fenster [LAEUFT]:** `perm_runner.hpp:323–326` — `pmc->begin()` … `run_workload_profile` … `pmc->end()`. Die 6 push_backs liegen **im** Fenster.
- **Live-Allokationspfad 2 [LAEUFT]:** `tier_observe_trace_abi.hpp` — 8 `push_back` (Z.149,167,176,185,228,253,267,274), 0 `reserve` (grep rc=1, leere Ausgabe).
- **ThreadArena-Defekt [DEKLARIERT, unverdrahtet]:** `thread_arena.hpp:18–21` — `records_.push_back(record)` ohne jedes reserve, Member `std::vector<MeasurementRecord>` (Z.35).
- **CustomAllocation1 [DEKLARIERT]:** `custom_allocation_1_measurements.hpp:53–73` — 1 GiB Default, `memset`-Pre-Touch mit wörtlichem Kommentar Z.58 „Pre-touch (Pflicht: kein page-fault zur Laufzeit!)", `fetch_add`-Slot, Sentinel `UINT64_MAX` bei Überlauf. Detail über die Linsen hinaus: `next_slot_` zählt **weiter** — die Verlustzahl ist als `next_slot_ − capacity` ablesbar (Z.69–70,76–78).
- **T-15 [LAEUFT]:** Marker Z.2873/2878 in `cache_engine_builder_iterator.hpp`, Wache `test_t15_drift_gate_messschleife.cpp` existiert; Kommentar Z.2867–2869: „kein Mess-Aufruf AUSSERHALB dieser Klammer".
- **drive_segment_latencies [BEIDES]:** nur Definition `perm_runner.hpp:371` + Kopfkommentar Z.18; 0 Aufrufer in libs/apps/tests; `run_workload_segmented_v2` im Iterator: 0 Treffer (echte „0" + rc=1).
- **Gates [LAEUFT]:** `mess_achsen_naht.hpp:36–98` — Vollzensus: genau 2 Mess-Gate-Makros (STATISTICS 39, MEASUREMENT_ON 36 Vorkommen), G2+G3 teilen ein Gate, G3-Herauslösung „EIGENES FOLGEPAKET"; `mess_gates_glied.hpp:64–67` verlangt die Glied-Erweiterung dann static_assert-/test-hart.
- **Xlsx ohne Fan-out [DEKLARIERT]:** `writeback_method_registry.hpp:7–12` wörtlich „reine Identitaet, kein Fan-out/Vollzug (der liegt in der Lager-Ablage-Strecke …) … der Fan-out/Vollzug gehoert S5".
- **XML-Muster [LAEUFT]:** `xml_config_parser.cpp` (libs/common/serialization/…): A9.1-Blöcke in **beiden** Kanälen als **separater, fast identischer Code** (Thesis Z.440–449, Experiment Z.543–551); `<system_axes>` dagegen über die **geteilte** `parse_system_axes`-Naht (Z.434, „EINE Funktion, kein dupliziertes Lese-Muster" Z.552–554). `validate_profile.hpp:471–495`: Registry-Check + exactly-one für run_methodology. XSD `Code/test_data_xml/experiment_schema.xsd:102–124`: `<hybrid_tier>`-Kommentar-Reserve als Staging-Muster.
- **golden = 1-Thread [LAEUFT]:** `run_methodology_registry.hpp:56` „Measure … 1-Thread/deterministisch, die golden-Messung".
- **ErgebnisMappe [LAEUFT als Code, 0 Produktions-Konsumenten]:** Fassung 3 komplett (`MessEbene` Z.196, `Checkpoint::In/Out` Z.208, 8-Spalten-Präzisierung Z.157–159, Sheet-Präfixe C_/M_/X_ Z.310–322, CSV-Strategie `<stamm>__<label>.csv` + tmp+rename Z.495–580); Kopfkommentar Z.178–185: Prozess/Thread-Identität erreicht den Writer heute an KEINER Stelle, checkpoint_measure ist „die dafuer zustaendige, NOCH NICHT gebaute Spezifikation".

**Korrekturen an den Linsen:**
- **K-a (Zählung):** Die „11 nearest_rank_median-Aufrufe" (Ledger heute Z.359) sind **6 Aufrufe in csv_to_latex.cpp** (Z.216,411,513,1245,1367,1414) **+ 5 in diagram_generator.cpp** (Z.735,1205,1548,1783,1784) = 11 über **zwei** Module; dazu **2 separate Definitionen** (Z.48 bzw. Z.653) und 1 Kommentar (Z.289). Linse 1 („8 Fundstellen") zählte nur csv_to_latex.cpp und ohne Modul-Trennung.
- **K-b (tier_observe):** nicht „8 push_back in 3 Vektoren", sondern 6 in die 3 ns-Vektoren + 2 in den 4. Vektor `trace.checkpoints` (Z.185,274).
- **K-c (Ledger-Zeilen):** Der MeasureStorage-Eintrag steht heute bei **Z.365–379**, der Kanon-Entscheid bei Z.349–361 (Linsen nannten 184–207) — Prepend-Wanderung am Objekt erneut belegt.
- **K-d (D5-1):** Linse 3 hatte den Kanon „nur über den Ledger-Bericht übernommen". Selbst verifiziert: `builder/commands/latency_stats.hpp` trägt den D5-1-Kanon-Block (nearest_rank_index, k=ceil(q·n)−1, H&F Typ 1) **und läuft im Live-Pfad**: `perm_runner.hpp:336–337` ruft `st::percentile_ns(v, 0.5/0.99/0.999)` — nach `pmc->end()` (Z.326), also außerhalb des Fensters. [LAEUFT]

**Neufunde (keine Linse hatte sie):**
- **N-1 — Die super-Kopien rechnen die verworfene Formel.** Beide Definitionen (csv_to_latex.cpp:48–54, diagram_generator.cpp:653–659) rechnen `rank = size_t(0.5·(n−1)+0.5)` = `round(q·(n−1))` — exakt die Formel, die der D5-1-Block als „KEIN round(q*(n-1)) … trug den Namen ‚Nearest-Rank' zu Unrecht und lieferte bei 1..100 p50=51 statt 50 … ERSATZLOS GELOESCHT" verwirft. Beider Kommentar beruft sich auf „konsistent zur Mess-Seite, nearest_rank_p(0.5)" — **eine seit heute gelöschte Funktion**. Bei geradem n weichen **alle 11 Aufrufstellen** um eine Rangstelle vom Kanon ab (n=100: Wert Nr. 51 statt 50). Der D5-1-Selbstcheck benennt das selbst als offen: „ZUSICHERT NICHT: nichts ueber die super-Werkzeuge … die tragen eigene Kopien (Paket D5-2/D5-3)".
- **N-2 — `--check-size` ist selbst ungebaut.** Soll-Design OP-4 verweist zur Kapazität auf „--check-size, das die Größe ohnehin auf der CEB rechnet" — Code-Treffer: **0** (`check-size`: nur die Soll-Design-Zeile 283 selbst; `check_size`: 0). Die im Soll-Design benannte Dimensionierungsquelle ist [DEKLARIERT], nicht existent.
- **N-3 — Kein Page-Fault-Zähler im Bestand.** `PmcCounters` (pmc_source.hpp:19–83): 8 uint64-Zähler + 9 Flags, **kein** page_faults-Feld; `PAGE_FAULT` in linux_perf_pmc_source.hpp: 0 Treffer. `mlock|madvise|MAP_POPULATE` im ce-Messcode: 0 (2 Kommentar-Treffer in SUT-Achse/Test; Gegenprobe `mmap`: 8 Files, alle SUT-Achsen/Memento/io_uring — nicht Mess-Speicher). Der Pre-Touch-Gedanke existiert im Haus **genau einmal**: im unverdrahteten CustomAllocation1.

---

## TEIL 2 — DER ENTWURF

Modul-Ort (Empfehlung, mit Beleg): **ce, `libs/cache_engine/builder/measure_storage/`**, neben `lager_ablage/`. Owner-KERN B-4 (07.08., Ledger): „Break even lebt nur in der CEB nach Messungs-Schluss und wird dort im RAM … ausgewertet, um dann **von der CEB** … in Latex Dokumente, PDF oder xlsx Tabellen … zu gießen" — der Guss ist CEB-seitig, super konsumiert über den Vendor (lager_ablage ist dort bereits byte-identisch vendoriert). Die VORLAGE vom 08.08. (`<report>`/`10_report_composer`, super-seitig) ist einen Tag älter als der Owner-Kern; nach RANGFOLGE Owner>Plan gewinnt der Name `measure_to_latex`, die VORLAGE-Substanz (E-18-Manifest-Kanal, Fehlerklassen) bleibt Fundus zum Mergen.

### (a) AUFNAHME — der vor-reservierte Append-Bereich

**Datenstruktur.** Drei Bausteine, alle POD/trivial:

1. **`MessCheckpointZeile`** — 32-Byte-POD, `alignas(32)`, `#pragma pack` nicht nötig bei sauberem Layout. **Dritter Name zwingend**: `measurement::MeasurementRecord` (32 B) und `benchmark_suite::MeasurementRecord32` (32 B) sind vergeben — Verwechslungsrisiko ist im Bestand real. Felder (nach Soll-Design §5d „Deskriptor-Verweis · Thread-Nr · Zeit · Tags"): `uint64 zeit_ticks` (billiger monotoner Zähler, einmal je Lauf gegen Systemzeit verankert — Soll-Design §6, in ergebnis_mappe.hpp:171–172 als „entschieden" gespiegelt) · `uint32 deskriptor_ix` (Index in statische Deskriptor-Tabelle: Ziel-`source_location`, Ebene, Achsen-Parameter — **das Byte-genaue Layout hängt an Soll-Design OP-1/OP-2 und ist dort offen; hier schweige ich**) · `uint16 thread_nr` · `uint8 tag` (2 Bit Ebene, 1 Bit IN/OUT — beides compile-time gesetzt) · `uint8 reserviert` · `uint64 messwert`. `static_assert(sizeof==32 && is_trivially_copyable_v)` wie das Vorbild. Konvergenz-Notiz: Tracy nutzt extern dieselben 32 B — die Hausgröße ist state-of-the-art-konform.

2. **`MessLog`** — lineares Append-Log, **kein Ring**: Owner verbietet Überschreiben, es gibt keinen nebenläufigen Leser („geschrieben wird beim Auslesen", R3), und LTTngs Discard-Modus degeneriert genau zu „linear + Verlustzähler". Bauform nach CustomAllocation1, aber **je Thread eines** unter einem prozessweiten Sammler (Soll-Design §9 — und §5d macht daraus eine **Richtigkeits**-Frage: geteilter Stack fände fremde Aufrufer). Im golden-Messpfad (1-Thread, run_methodology_registry.hpp:56) existiert genau 1 Puffer; der Bump-Index braucht dort kein atomic, im Debug=parallel-Modus ist er `fetch_add` (relaxed) — ein RMW, keine Allokation. Hot-Teil `{ MessCheckpointZeile* basis; uint64 kapazitaet; uint64 belegt; }` — trivially copyable, damit static_assert-fähig (fängt die ThreadArena-Fehlerklasse compile-hart: ein vector-Member zerstörte die Eigenschaft).

3. Reservierung im **Setup, vor dem Fenster** (dort ist Allokation erlaubt): ein `mmap(MAP_PRIVATE|MAP_ANONYMOUS)` je Thread-Puffer, dann Pre-Touch (Teil 4). Kein `std::pmr::monotonic_buffer_resource` als Typ (stiller Upstream-Fallback auf malloc bei Erschöpfung = exakt die verbotene versteckte Allokation), wohl als Konzept.

**Dimensionierung — woher weiß man vorher, wie viel?** Der Planer weiß es: `run_options.n_ops` steht im XML (Parser Z.452), die aktiven Ebenen stehen im Tooling-Segment. Zeilen je Op = 2 (Macro-Paar) + 2×|Achsen| (Micro-Paare). Achszahl-Diskrepanz im Bestand, nicht geglättet: perm_runner.hpp:366 sagt „ALLER 18 SearchAlgorithm-Achsen (T0..T17)", ergebnis_mappe.hpp:143 „der 18 Organ-Achsen", das Soll-Design §5(b) rechnet „bei 19 Achsen … 38 Checkpoints". Rechnung mit der Obergrenze 40 Zeilen/Op: golden 2^17 = 131.072 ops × 40 × 32 B = **167.772.160 B = 160 MiB je Zelle** (Nenner: ops×zeilen×bytes). Der CustomAllocation1-Default 1 GiB = 33.554.432 Records = 6,4× golden-Reserve. **Formel: `kapazitaet_records = n_ops × zeilen_je_op(aktive Ebenen) × 2` (Faktor 2 Sicherheit)** — Quelle der Zahl ist OE-1, weil `--check-size` (Soll-Design OP-4) nachweislich ungebaut ist (N-2).

**Überlauf — die kritische Stelle.** Owner hat die Politik entschieden (Soll-Design §8): nicht verwerfen (Messung lügt), nicht blockieren (verbotene Latenz), sondern **weiterlaufen, zählen, beim Auslesen melden**. Mein Design macht den Befund dreifach laut, damit „melden" nicht zum stillen Verlust degeneriert:
1. Hot-Path: Bump-Index läuft **weiter** (CustomAllocation1-Mechanik) — `verloren = belegt − kapazitaet` ist ohne Extra-Zähler exakt.
2. Auslesen: `verloren > 0` ⇒ jede betroffene Mappe bekommt im INFO-Blatt die Zeile `ueberlauf_verloren = N von M` (M = kapazitaet+N), und **jedes** Ebenen-Blatt den Status nach dem INC-29.1-Muster (perm_runner.hpp:354–356: „failed"-Zelle statt Null + Log) — Daten bleiben, sind aber als unvollständig gebrandmarkt.
3. Prozess-Ebene: die Auswertephase (nicht der Hot-Path) endet mit rc≠0 — CI wird rot. Das adressiert zugleich Soll-Design OP-5 (Prozess-Ende ohne Auslesen): ein atexit-/Destruktor-Pfad im Sammler schreibt bei nicht-ausgelesenem, nicht-leerem Log eine stderr-Deklaration; die harte Abnahme bleibt beim Ausleser.

### (b) AGGREGATION — der custom Stack

**Zuerst der Widerspruch, den keine Quelle auflöst** (Linse 3, offene Frage — bestätigt): Der Owner-Kern (3) nennt **einen** „Stack"; das Soll-Design kennt **zwei** Stapel-Begriffe — den „prozessweiten Speicher-Stack" („Der Stack ist memory", §1/R3) und die LIFO-Buchhaltung der Rekonstruktion („je einem offenen Stapel pro Ebene", §5d). Keine Quelle setzt sie gleich oder auseinander. Das Design bedient **beide** mit genau zwei Strukturen — eine dritte gibt es nicht:

- **Der Speicher-„Stack"** ist das MessLog aus (a): append-only, oben anfügen, nie überschreiben.
- **Der Aggregations-Stapel** ist der **`EbenenStapel`**: je Mess-Ebene (compare/macro/micro, plus der vierte Rang, falls OP-3/Hybrid ihn bringt — offen, s. LESEFALLE im Soll-Design OP-3) ein festes Array von **Indizes** (`uint32`) in das Log + ein Top-Zähler. Er läuft im **einen O(n)-Vorwärts-Durchlauf beim Auslesen**: IN legt seinen Log-Index auf den Stapel seiner Ebene, OUT nimmt ihn herunter, jeder Checkpoint bekommt als Aufrufer die Spitze der nächsthöheren Ebene; **Rest auf einem Stapel am Ende = exakt die §7-Regressionen** — die Balance-Invariante fällt als Nebenprodukt ab (Soll-Design §5d, wortgleich in ergebnis_mappe.hpp:166–168 gespiegelt). Je Thread getrennt (§5d: sonst falscher Aufrufer).

**Warum LIFO:** Checkpoint-Paare sind eine Klammerstruktur — ein OUT schließt immer das **jüngste** offene IN seiner Ebene in seinem Thread. Verschachtelung (macro ruft micro ruft …) ist genau die Struktur, die ein Stapel verlustfrei abbildet; FIFO ordnete OUT dem ältesten IN zu und löste jede Verschachtelung falsch auf.

**Warum nicht `std::stack` — die Technik, nicht die Doktrin:**
1. **Default-Container ist `std::deque`**: libstdc++ chunked mit `__deque_buf_size = 512/sizeof(T)` Elementen je Block — schon das **erste** push alloziert die Zeiger-Map plus einen vollen 512-Byte-Block, jeder Block-Übertritt alloziert erneut. Für einen Stapel, der (Variante Live-Nutzung im Hot-Path) unter R2 fällt, ist das disqualifizierend.
2. **Der Adapter bietet keine Kapazitäts-API**: `std::stack` exponiert weder `reserve()` noch `capacity()`; selbst `std::stack<T, std::vector<T>>` lässt sich über den Adapter nicht vorreservieren (nur über einen vorkonstruierten, hineingemovten Container), und nichts hindert den vector danach am reallozierenden Wachsen — es gibt **keine compile-time-Kapazitätsgarantie**.
3. **Der Adapter verbietet Inspektion**: nur `top()/push()/pop()` — der §7-Befund verlangt aber, die **verbliebenen** Einträge auszulesen und zu melden (welcher IN blieb offen, Funktion/Ebene/Thread/Zeit). Beim custom Array ist das ein Slice; bei `std::stack` nur destruktiv.
Die Kapazität ist durch **Verschachtelungstiefe** begrenzt, nicht durch Ereigniszahl — der Bestand schweigt zur maximalen Tiefe; konservativ 64 Slots je Ebene×Thread = 64×4 B×3 Ebenen = 768 B, als `std::array` im Ausleser, Null Allokation by construction, static_assert-fähig. Überlauf des Stapels selbst (Tiefe>64) ist derselbe laute Befund wie (a)-Überlauf, nie still.

Die eigentliche **Wert-Aggregation** (Perzentile, Mediane) passiert **nach** dem Durchlauf, in der compare-Phase, und ruft ausschließlich `st::nearest_rank_index`/`percentile_ns` (D5-1) — dort darf frei alloziert werden (Owner-Kanon Ledger Z.349–357: „stumpf in voller Granularität … Kanon erst in der compare-Auswertungsphase").

### (c) EXPORT — xlsx-Mappe, CSV als Strategie derselben Mappe

**Kein Neubau.** `IErgebnisMappe`/`ErgebnisMappenFactory` (lager_ablage) ist exakt die verlangte Form und liegt fertig: Fassung-3-Blattsorte je Ebene (`mess_ebene_blatt`, Sheets C_/M_/X_…), Namens-Wache ≤31 Zeichen, Zeilenlimit-Wache 1.048.576, atomarer tmp+rename, INFO-Blatt, interne Hyperlinks compare→Funktion→Achse (empirisch belegt, Z.187–193). CSV ist dort bereits **Strategie derselben Factory**: `CsvErgebnisMappe` schreibt je Sheet eine Datei `<stamm>__<label>.csv` in **einen** Ordner (Z.410, 495–580) — wortgleich zum Owner-Kern „(2) als xlsx (oder optional die Sheets als csv)". MeasureStorage wird der **erste Produktions-Konsument** (heute: 3 Test-Targets, 0 Produktions-Targets — CMake-Kommentar „kein bestehendes ce-Ziel haengt daran") und schaltet damit zugleich `WritebackMethod::Xlsx` erstmals scharf (heute reine Registry-Identität ohne Fan-out — das „S5"-Versprechen aus writeback_method_registry.hpp:16).

**Kein Weg von CSV zurück:** MeasureStorage besitzt **keinen** CSV-Leser; `measure_to_latex` konsumiert ausschließlich das In-RAM-Aggregat (bzw. das MeasureStorage-Objekt) im selben Prozess. CSV/xlsx sind reine **Senken**. Konsequenz für (d)/(6): die drei CSV-Parser des Altmoduls werden **nicht** portiert.

### (d) LaTeX — `measure_to_latex` nach eigenem XML-Segment

**Orientierung am Bestand statt neuer Grammatik** — das Segment folgt Zeichen für Zeichen dem A9.1-/`<writeback_methods>`-Muster (Element-Liste mit Attribut-Werten aus einer constexpr-Registry):

```xml
<!-- additiv, minOccurs=0, unter BEIDEN Wurzeln; Platz in der Root-Sequenz hinter writeback_methods -->
<measure_to_latex>
  <!-- jede <ausgabe> = genau EIN .tex-Fragment; Dokument-Reihenfolge = Schreib-Reihenfolge -->
  <ausgabe form="balance_befunde"          ebene="micro"   lang="de en"/>
  <ausgabe form="konfig_median_longtable"  ebene="compare" lang="de en"/>
  <ausgabe form="ebenen_uebersicht"        ebene="macro"   lang="de"/>
</measure_to_latex>
```

**Syntax:** `form` = Token aus neuer `kMeasureToLatexFormRegistry` (Bauform exakt writeback_method_registry.hpp:30–94: enum + `std::array<Info,Count>` Index==Enum + consteval-Vollständigkeitswache + Namen-Anker-static_assert + Count-Pin hinter letztem Enumerator + `for_each_`-Fold — kein Runtime-Switch). `ebene` = Token aus `mess_ebene_label` (Single-Source, ergebnis_mappe.hpp:198–205). `lang` = Whitespace-Liste {de,en} (Muster `split_ws` wie `<combo tools>`; DE führt, EN zieht nach). **Semantik:** Abwesenheit des Segments = keine LaTeX-Ausgabe, byte-identisch heute (honest-empty). Duplikat (form,ebene,lang) = validate-Fehler (zwei identische Zieldateien wären eine stille Kollision). Zielpfade stehen **nicht** im Segment — der Bestand (Owner-Kern) schweigt dazu; die VORLAGE schlug `anhang/<lang>/generated/` vor, das bleibt zu mergen (Lücke, benannt).

**Parsen:** common-Schicht liest **roh** (nur Attribut-Strings, keine Enums — Baseline-Layering, Parser-Kommentar „prueft die ids NICHT"), und zwar über **eine gemeinsame Funktion `parse_measure_to_latex`** für beide Kanäle — dem `parse_system_axes`-Muster folgend, **nicht** dem A9.1-Duplikat-Muster (die Linsen-Fallstrick-Frage „Duplikation oder Teilung" wird zugunsten Teilung entschieden: „Sauberste, nicht einfachste"; eine dritte Konvention entsteht nicht). **Validieren:** `validate_profile.hpp` prüft form/ebene/lang gegen die Registries (Muster `check_measurement_sub_axis`, Z.475 ff.). **Durchreichen:** der Planer interpretiert `form` **nicht** — er reicht die validierte Rohliste als Ganzes an measure_to_latex (Owner wörtlich: „zur finalen Auswertungsanforderung einfach durchgereicht wird vom Planer an dieses Modul"). XSD: `MeasureToLatexType` additiv; keine Kommentar-Reserve-Phase nötig (das hybrid_tier-Staging gilt für wartende Pakete — dieses baut sofort).

Initiale Formen-Registry bewusst klein (3 Einträge oben); die volle Formenliste (Übernahmen aus csv_to_latex, Teil 6) wächst additiv — jede neue Form ist eine Registry-Zeile + ein Writer, die Wachen brechen bei Drift compile-time.

---

## TEIL 3 — DIE MESSWEG-GARANTIE (Prüfung 4: was erzwingt das Halten?)

**Der Punkt, den alle vier vorgeschlagenen Mechanismen erst nach einer Unterscheidung treffen:** Im Messfenster allozieren **die SUT-Achsen legitim** (tier_insert baut Knoten; die Allocator-Achse ist selbst Messgegenstand — test_phase_b zählt genau deren Allokationen als Feature). Verboten ist Allokation **durch den Messapparat**. Ein globaler Riegel im echten Messlauf kann beide nicht unterscheiden.

Bewertung der vier:

1. **`operator new`-Riegel im Messmodus (Produktionsbinary): keine Werkzeug-Qualität, Selbstwiderspruch.** Global scharf → falsch-positiv an jeder SUT-Allokation. Selektiv scharf (nur um Apparat-Code armiert) → zirkulär: er prüft nur Code, den man dafür markiert hat. Und der Hook selbst kostet je SUT-Allokation einen Branch — **der Messapparat berührte den Messgegenstand**, die Doktrin, die er schützen soll. Nicht bauen.
2. **Concept/static_assert auf die Typen: WERKZEUG, aber nur für Struktur.** `static_assert(std::is_trivially_copyable_v<MessLogHot> && is_trivially_copyable_v<MessCheckpointZeile> && sizeof(...)==32)` + `noexcept`-Pflicht am Append. Das hätte den ThreadArena-Defekt **compile-hart** gefangen (vector-Member zerstört trivially_copyable). Es beweist aber nicht, dass keine allozierende freie Funktion im Aufrufpfad steht — **notwendig, nicht hinreichend**.
3. **Laufzeit-Zähler, der in Produktion hart bricht: dieselben Einwände wie (1)** — in der Measure-Schiene Scheinsicherheit plus Binary-Veränderung. In der Debug=parallel-Schiene zulässig (Debug darf anders gebaut sein), beweist aber nichts über das Measure-Binary.
4. **Test mit instrumentiertem Allocator: DAS Werkzeug.** Testbinary mit globaler `operator new/new[]/delete`-Ersetzung + thread_local-Zähler (Haus-Technik existiert: test_a1_wurf_vertrag_allokator_store.cpp, test_phase_b…:121–143 — dort allerdings typ-lokal für die SUT-Achse; die globale Ersetzung ist der neue Schritt), **Dummy-SUT ohne jede Allokation** → im Fenster IN…OUT ist dann **jede** Zählung Apparat-Schuld; Abnahme `zaehler==0`. Deckt exakt Register-Idee S5-16 („>0 wird rot — sonst ist die Sparsamkeit wieder nur ein Kommentar"). Zwei Pflicht-Zusätze: **(i) Positivkontrolle (K13):** ein absichtlich allozierender Köder-Checkpoint MUSS >0 zählen, sonst misst der Test nichts; **(ii) malloc-Pfad:** operator-new-Ersetzung sieht C-`malloc` nicht (vendorierte C-Pfade wie hdr) — zweite Stufe per malloc-Interposition im Testbinary bzw. LD_PRELOAD-Zähler (beide in S5-16 benannt).

**Antwort auf die Frage:** (2)+(4) sind **Werkzeuge** (compile-hart + test-hart in jeder Pipeline); (1)+(3) sind in der Measure-Schiene **Disziplin in Werkzeug-Kostüm** — sie versprechen Zwang, den sie ohne Verfälschung des Messgegenstands nicht ausüben können. Dritte Schiene, Haus-üblich: eine **Text-/Verdrahtungs-Wache** nach T-15-/A8-S4-Muster auf den Hot-Header (verbotene Tokens `std::vector`/`push_back`/`new`/`malloc`/`std::string` innerhalb der markierten Hot-Klammer) — grob, aber sie bricht den Bau dessen, der den Apparat „nur kurz" bequem macht. Und das **empirische** Schlussglied bleibt die 6-CEB-Differenz (Soll-Design §6: „Diese Wahl muss nicht geglaubt werden") — heute strukturell auf max. 2 von 6 Varianten begrenzt, bis G3 herausgelöst ist (mess_achsen_naht.hpp, OE-4).

---

## TEIL 4 — DIE PAGE-FAULT-FRAGE

**Befund:** reserviert ≠ belegt. `mmap` liefert virtuellen Raum; der erste Schreibzugriff je 4-KiB-Seite kostet einen Minor Fault — bei 160 MiB je Zelle sind das 40.960 Seiten, deren Faults ohne Gegenmaßnahme **mitten im Messfenster** lägen. Der Bestand kennt die Lösung an genau einer Stelle: CustomAllocation1 Z.58–59, `memset`-Pre-Touch mit Kommentar „Pflicht: kein page-fault zur Laufzeit!" — sonst nirgends (N-3).

**Lösung (Setup, vor dem Fenster):** (1) `mmap(MAP_PRIVATE|MAP_ANONYMOUS)`; (2) optional `madvise(MADV_HUGEPAGE)` auf genau diese Reservierung (OE-2; niemals systemweites THP „always" — synchrone Compaction erzeugte Latenzspitzen im Messmoment); (3) **Pre-Touch als Pflicht**: `memset` über die volle Kapazität (CustomAllocation1-konform; verschiebt die Kosten in die Initialisierung); (4) optional `mlock` als harte Garantie gegen Reclaim — `MAP_POPULATE` allein genügt laut man-page nicht („no guarantee that no major faults will happen later … pages might have been reclaimed"). **Lücke, benannt:** `RLIMIT_MEMLOCK` auf prod1 ist ungeprüft; bei „möglichst groß" (1 GiB) kann mlock am Limit scheitern → OE-2.

**Messbar? Ja, zweifach:**
1. **Im Test (Paket P7):** `getrusage(RUSAGE_SELF).ru_minflt` unmittelbar vor IN-Armierung und nach OUT — Delta==0 mit Pre-Touch ist die Abnahme; der Köder (Pre-Touch weggelassen, 64-MiB-Arena) MUSS Delta>0 liefern (Positivkontrolle, beißt beobachtbar: 64 MiB/4 KiB = 16.384 erwartete Faults, gemessen wird die reale Zahl).
2. **Produktiv, optional (OE-6):** dieselben zwei getrusage-Syscalls liegen **außerhalb** des Fensters (vor begin/nach end) — eine `pf_delta`-Spalte je Zelle im INFO-Blatt macht die Garantie im echten Lauf beobachtbar statt geglaubt. Eine PMC-Erweiterung (`PERF_COUNT_SW_PAGE_FAULTS`) wäre additiv möglich, ist aber ein eigener POD-Eingriff (PmcCounters hat heute kein Feld, N-3) und für die Garantie nicht nötig.

---

## TEIL 5 — PAKETE

Köder-Werte **frisch gewürfelt** (dieser Lauf, /dev/urandom): 94579096 · 80206379 · 1695760600 · 3108531695 · 2833566270 · 3782649822 · 3042439659 · 1363607749 · 0x7fb416df15ea97ef · 0x6f341ef74bd9adc6.

**P1 — MessLog (Aufnahme-Speicher).**
T-1 (Tag 1 ROT): `test_ms1_messlog_kein_alloc_im_fenster.cpp` — globale operator-new-Ersetzung + Zähler; N appends zwischen arm()/disarm(); Abnahme zaehler==0 **und** Positivkontrolle: ein absichtlich allozierender Dummy zählt >0. Rot, weil der Header nicht existiert.
Bauschritte: Header (POD+Log+Sammler, static_asserts) → mmap+Pre-Touch-Setup → Append+Sentinel → Verlustzähler.
Abnahme: ctest grün beide Richtungen (0 beim Apparat, >0 beim Köder); static_asserts im Header.
Köder (K13, beobachtbar): Kapazität 3 Records; append von zeit_ticks 94579096, 80206379, 1695760600, dann **3108531695** → der vierte MUSS Sentinel liefern, snapshot() zeigt exakt 3, und der Wert 3108531695 darf **nirgends** im Export auftauchen, während verloren==1 gemeldet wird. Beobachtbarkeit geprüft: zwei **unabhängige** Assertions (Wert fehlt UND Zähler==1) — ein Mutant, der nur den Zähler streicht, stirbt an Assertion 2, einer, der die Kapazitätsprüfung streicht, schreibt out-of-bounds und stirbt an Assertion 1/ASAN; keine fängt die andere verdeckend (verschiedene Observablen, kein gemeinsamer rc-Pfad).
was_erzwingt_das_halten: static_asserts (jeder Bau) + ctest im Pflichtsatz (jede Pipeline).
Aufwand ehrlich: 2–3 Tage.

**P2 — checkpoint_measure-Anschluss (Aufnahme-API).** Uniforme Funktion, IN/OUT- und Ebenen-Tag compile-time, Deskriptor-Index, innerhalb der T-15-Klammer (Wache mitnehmen, sonst reißt test_t15). **Blockiert durch OE-3** (Soll-Design OP-1/OP-2: Deskriptor-Layout, Ebene je TU oder je Aufruf). T-1: Balance-Test — Folge mit einem offenen IN (deskriptor_ix aus 0x6f341ef74bd9adc6 & 0xFFFF = beliebig konkret) wird als Regression gemeldet, nicht als Messwert. Köder: das offene IN trägt zeit_ticks 2833566270 — der Befundtext MUSS genau diesen Wert nennen (beobachtbar: der Mutant „Balance-Prüfung entfernt" liefert einen Export ohne Befundzeile — eigenes Blatt, kein anderer Zweig erzeugt sie). was_erzwingt: test + die T-15-Textwache. Aufwand: 3–5 Tage.

**P3 — EbenenStapel + O(n)-Rekonstruktion.** T-1: handkonstruierte verschachtelte Folge (macro-IN, micro-IN, micro-OUT, micro-IN, micro-OUT, macro-OUT) → Aufrufer-Zuordnung exakt; Köder: ein Log mit gewürfeltem Fremd-Thread-IN (thread_nr = 3042439659 mod 65536 = 27819) dazwischen — die Auflösung DARF ihn nicht als Aufrufer der anderen Thread-Kette liefern (beobachtbar: die Aufrufer-Spalte der betroffenen Zeile unterscheidet sich zwischen korrekter und mutierter Fassung — Eingang existiert, bei dem sich MIT und OHNE unterscheiden). std::stack-frei per Bauform (Array+Top, static_assert). Aufwand: 3–4 Tage.

**P4 — Export-Anschluss (ErgebnisMappe konsumieren, Überlauf→laut).** Erste Produktions-Verdrahtung von lager_ablage (heute 0/3 Produktions-/Test-Targets). T-1: Mappe aus einem MessLog mit verloren==2 → INFO-Blatt trägt „ueberlauf_verloren = 2 von N" und der Ausleser endet rc≠0. Köder: Rekombinations-Bezeichner „K3782649822" — MUSS als Sheet C_K3782649822 erscheinen (Namens-Wache-Pfad real durchlaufen). Beobachtbar: Mutant „INFO-Zeile weggelassen" stirbt am INFO-Blatt-Assert, Mutant „rc immer 0" am Prozess-rc — getrennte Observablen. Aufwand: 2–3 Tage.

**P5 — XML-Segment (`<measure_to_latex>`).** XSD + gemeinsame parse-Funktion (beide Kanäle) + Formen-Registry + validate. T-1: validate lehnt das gewürfelte Token `form="form_1363607749"` mit Registry-Preview ab und akzeptiert die 3 echten Tokens; Roundtrip byte-identisch bei Abwesenheit des Segments. Köder: genau dieses Unsinns-Token. Beobachtbar: der Mutant „validate-Check entfernt" lässt das Token durch → measure_to_latex erhielte eine unbekannte Form — der Test prüft die **validate-Fehlerliste selbst**, nicht einen nachgelagerten Effekt (kein verdeckender Zweig). was_erzwingt: Registry-static_asserts + validate-Tests + XSD. Aufwand: 2–3 Tage.

**P6 — measure_to_latex (Übernahme + Kanon).** Writer-/Statistik-Substanz aus csv_to_latex+diagram_generator umhängen, Quelle = In-RAM-Aggregat, **Kanon via ce-Vendor** (`latency_stats.hpp` konsumieren statt einer dritten Kopie — heute existieren bereits 2 Duplikate der Median-Funktion, N-1). T-1: `nearest_rank`-Kanon-Test: Stichprobe 1..100 → p50==50 — **gegen die heutigen Kopien wäre er rot (51)**, das ist der geborene Tag-1-Rot-Test. Köder: Stichprobe {94579096, 80206379, 1695760600, 3042439659} sortiert → p50 MUSS das 2. Element (untere Mitte, n=4 gerade) = 94579096 sein; die Alt-Formel lieferte das 3. (1695760600) — Mutant beobachtbar an genau dieser Differenz. Aufwand ehrlich: 5–8 Tage (1442+2064 Zeilen Bestand sichten, 19+46 Fixture-Tests mitziehen — die brechen LAUT, Invalidieren ist Ziel).

**P7 — Page-Fault-Wache.** T-1: ru_minflt-Delta==0 nach Pre-Touch; Köder: 64-MiB-Arena ohne Pre-Touch → Delta>0 (Positivkontrolle; erwartete Größenordnung 16.384 Seiten). Beobachtbar: die zwei Fälle unterscheiden sich in derselben Observable. Aufwand: 1–2 Tage.

**P8 — Stilllegung csv_to_latex.** CMake-Target/CLI raus, die 3 CI-Aufrufstellen (inkl. der `|| echo`-Ummantelung, die heute JEDEN Exit-Code schluckt — Fallstrick übernommen und zu beheben) auf measure_to_latex ziehen. **OE-5-pflichtig** (Zeitpunkt; Thesis-Anhang hängt an 12 hart-ge-`\input`-teten Kern-.tex). Aufwand: 2–4 Tage.

Summe seriell, ehrlich: **20–32 Tage**; P1/P5/P7 parallelisierbar, P2 wartet auf OE-3.

---

## TEIL 6 — DER ÜBERGANG VON csv_to_latex

**Was es heute kann [LAEUFT]:** 3 Parser (16-Spalten-Legacy, WIDE ';'-getrennt header-getrieben, WIDE-FULL 17-Achsen) · 9+ Writer (booktabs-Tabelle, Bias-Matrix, 4 Exchange-Longtables, pgfplots-Forest-Plot, statische Limitierungs-Longtable, SOTA-Serie, Sweep, seg-coverage, Baustein-Beschreibung) · Statistik (Median/Quartile, Geschwister-Paar-Erkennung über 4 variable Achsen, Referenz-Drehung d′=−d/(1+d)) · bilingual de/en · escape_latex · 19 Fixture-Tests · CLI in 2 CMake-Targets + 3 CI-Stellen.

**Übernehmen:** die gesamte Writer- und Statistik-Substanz (mathematisch heikel, getestet — neu bauen hieße gefixte Fehler wiederholen), Lokalisierung, escape. **Wegfallen:** die 3 CSV-Parser und der CSV-Datei-Eintrittspunkt (Owner: kein Weg von CSV zurück; Quelle wird das In-RAM-Aggregat) sowie der Name.

**Wo wird der Kanon eingebaut — alt oder neu?** **Im neuen, und nur dort.** Drei Gründe: (1) Der Ledger hat es entschieden (heute Z.359–361): „Der Umbau gehört in `measure_to_latex`, **nicht** in eine Reparatur des Auslaufmodells." (2) Mein Objektbefund N-1 verschärft das: beide Kopien rechnen die **ersatzlos gelöschte** Formel `round(q·(n−1))` und berufen sich im Kommentar auf die gelöschte `nearest_rank_p` — eine „Reparatur" des Altmoduls erzeugte die dritte Kopie einer Funktion, deren Single-Source (`latency_stats.hpp`, D5-1-Selbstcheck: „die EINZIGE Umrechnung … im Auswertungs-Baum") seit heute existiert und deren Selbstcheck die super-Kopien ausdrücklich als offenes Paket D5-2/D5-3 führt. (3) Konsequenz beziffert: bei geradem n ändern sich die Ausgaben aller 11 Aufrufstellen um bis zu eine Rangstelle (n=100: 51→50) — dieser Bruch soll **einmal** passieren, im neuen Modul, laut (Fixture-Tests werden rot und mit-aktualisiert), nicht zweimal. Empfehlung konkret: measure_to_latex linkt den ce-Vendor-Header und löscht beide lokalen Definitionen ersatzlos.

---

## TEIL 7 — OWNER-ENTSCHEIDE (nur teuer / nicht billig rücknehmbar)

**OE-1 — Kapazitätsquelle des MessLog.** A: Planer-Formel `n_ops × zeilen_je_op(Ebenen) × 2` aus dem XML (sofort baubar; Folge: Fehlkalkulation bei künftigen Ebenen/Hybrid → Überlauf-FAILED-Läufe, bei mehrtägigen Läufen teuer, aber laut). B: warten auf `--check-size` (Soll-Design OP-4) — **das ist heute ungebaut (0 Code-Treffer)**; Folge: MeasureStorage wartet auf ein unbebautes Vorpaket. Empfehlung A, mit XML-Override-Attribut als Ventil.

**OE-2 — mlock und MADV_HUGEPAGE.** Ja: harte Fault-Garantie + TLB-Gewinn; Folge: RLIMIT_MEMLOCK-Abhängigkeit (prod1 ungeprüft — Infra-Berührung, ggf. Deploy-Schritt) und Setup-Zeit proportional zur Größe. Nein (nur memset-Pre-Touch): keine Infra-Berührung, Restrisiko Reclaim unter Speicherdruck; P7 misst, ob das Restrisiko real auftritt. Empfehlung: Nein zum Start, P7-Messwert entscheidet nach.

**OE-3 — Soll-Design OP-1/OP-2/OP-3 schließen (Deskriptor-Konsolidierung; Ebene je TU oder je Aufruf; vierte Ebene/Gattungs-Interface — LESEFALLE beachtet: nicht die Hybrid-4.-Ebene).** Ohne Entscheid kein Byte-Layout → **P2 blockiert**. Rücknahme nach Baubeginn = ABI-Bruch des Records. Muss vor P2 fallen.

**OE-4 — G3-Herauslösung vor oder nach checkpoint_measure.** Vorher: 6-CEB-Overhead-Nachweis sofort möglich, aber Hot-Path-Eingriff in abi_adapter.hpp + Preimage-Glied-Erweiterung vorab. Nachher (Soll-Design §10: „kann vor G3 gebaut werden"): MeasureStorage liefert früher, §4-Nachweis („was der Checkpoint kostet") bleibt bis dahin unbelegt — maximal 2 von 6 CEB-Varianten herstellbar. Empfehlung: nachher, mit datiertem G3-Folgepakettermin.

**OE-5 — Schicksal von Code/04 (und der 5 Kanon-Aufrufe in Code/05).** Sofort stilllegen: Owner-Wortlaut erfüllt, aber Thesis-Anhang-Kette (12 hart-\input-Kern-.tex, comdare_pipeline_e2e, 3 CI-Stellen) bricht, solange measure_to_latex nicht liefert. Erst nach P6: Übergangszeit mit zwei Werkzeugen, davon eines mit falscher Median-Formel. Empfehlung: P6 zuerst, P8 unmittelbar danach im selben Fenster; bis dahin **kein** Fix am Altmodul (Ledger-Entscheid).

**OE-6 — `pf_delta`-Spalte produktiv (2 getrusage-Syscalls außerhalb des Fensters je Zelle).** Ja: Garantie bleibt im echten Lauf beobachtbar. Nein: 2 Syscalls weniger, Garantie nur test-seitig. Billig rücknehmbar — nur der Vollständigkeit halber gelistet.

**Benannte Lücken (Bestand schweigt):** maximale Verschachtelungstiefe je Ebene (Stapel-Dimension) · Zielpfad-Namensraum der .tex-Fragmente (VORLAGE-Merge offen) · Identität „Owner-Stack" vs. „Soll-Design-Speicher-Stack" (Design deckt beide, Gleichsetzung nirgends belegt) · Achszahl 18 vs. 19 (drei Quellen, zwei Werte) · RLIMIT_MEMLOCK auf prod1 · ob dieser Strang selbst „Strang 30" abschließt (Ledger vermerkt ihn als laufend).