# SESSION 08.08.2026 — Der Zielgrößen-Katalog: alle 19 Achsen und 45 Parameter erklärt

> **Auftrag des Eigentümers, wörtlich (08.08.2026):**
> *„Die Default Zielgrößen-Menge ist gewhitelistet wie die Achsen und kann eingeschränkt werden in
> der XML auf die deep research parameter jeder Achse, die derzeit messbar und verfügbar sind, bitte
> liste diese für mich je Achse auf."*
> und danach: *„Alles korrekt, bitte dokumentiere diese wunderbare Tabelle als reiche Session mit
> schriftlicher Erklärung aller Achsen und Parameter"*
>
> **Belegstand:** alle Angaben am Objekt gelesen, nicht aus Dokumentation abgeschrieben.
> Primärquelle: `ce libs/cache_engine/heuristik/axis_optimization_catalog.hpp` (445 Zeilen).
> Messbarkeits-Angaben: `ce libs/cache_engine/include/cache_engine/measurement/` (`system_axis.hpp`,
> `linux_perf_pmc_source.hpp`, `pmc_source.hpp`, `measurement_category.hpp`).

---

# TEIL 1 — WARUM ES DIESEN KATALOG GIBT

## 1.1 Der Fehlbefund, der ihn erzwungen hat

Der Header nennt seinen eigenen Anlass im Kopf, und er ist gravierend:

> *„`break_even.hpp` trug bis heute die Zeile »KONVENTION ›besser‹ = KLEINERER y-Wert« — **PAUSCHAL
> für ALLE Achsen**. Der Katalog sagt für **15 der 19 Achsen-Zeilen** mindestens eine MAX-Zielgröße.
> Für jede solche Zielgröße meldete der Break-Even-Finder **die SCHLECHTERE Kurve als die bessere**
> — exakt umgekehrt."*

Das ist die schärfste Klasse von Messfehler, die es gibt: **die Messung ist korrekt, die Auswertung
dreht sie um.** Eine Kompressionsrate von 0,9 ist besser als eine von 0,4 — ein Finder, der
pauschal „kleiner ist besser" annimmt, kürt die 0,4 zum Sieger. Die Zahlen in der Tabelle sind
richtig, die Spalte „Gewinner" ist falsch, und nichts an der Ausgabe verrät es.

Der Katalog ist die Single-Source, aus der `break_even.hpp` die Richtung **je Zielgröße** bezieht.

## 1.2 Die zentrale Aussage — und warum das Datenmodell so aussieht, wie es aussieht

> *„Die Optimierungsrichtung ist **KEINE Eigenschaft der ACHSE**, sondern der **ZIELGRÖSSE**.
> Dieselbe Achse trägt gegenläufige Größen: T3 `path_compression` will MAX Kompressionsrate UND MIN
> Baumhöhe UND MIN Speicher. Eine Tabelle »Achse → eine Richtung« wäre eine **Fälschung des
> Katalogs**."*

Daraus folgt die Struktur: eine **flache Zielgrößen-Tabelle** (`kAxisObjectives`, 45 Einträge) plus
**Achsen-Zeilen mit einem `[begin, count)`-Fenster** (`kAxisOptimizationCatalog`, 19 Einträge). Jede
Achse besitzt ein zusammenhängendes Fenster in der flachen Tabelle. Drei `consteval`-Wachen sichern,
dass die Kachelung lückenlos, überlappungsfrei und vollzählig ist — ein stillschweigend
default-initialisiertes Fenster bricht sofort zur Compile-Zeit.

**Für die Excel-Ausgabe heißt das direkt:** Die Spalte „min oder max gilt hier als bester Wert" ist
**keine Achsen-Spalte, sondern eine Zielgrößen-Spalte.** Eine Achse kann in derselben Zeile drei
Zielgrößen mit drei verschiedenen Richtungen tragen.

## 1.3 Herkunft — verbatim übertragen, nicht interpoliert

Quelle ist `super docs/audits/20260709-axes-optimization-deep-research-BEFUND.md`, Abschnitt 1,
Zeilen 81–101. Der Header dokumentiert seine **Übertragungsregel** ausdrücklich, damit die Zählung
nachrechenbar bleibt:

- **(a)** Jede mit MIN/MAX ausgezeichnete Größe wird **eine** Zeile, in der Reihenfolge der Nennung.
- **(b)** Ein `=` ist eine **Operationalisierung** derselben Größe, keine zweite Größe.
  Beispiel T0: *„MIN Lookup-Latenz = MIN (Baumhöhe × Cache-Lines/Knoten + Vergleiche)"* → **eine** Zeile.
- **(c)** `^`, `/` und `vs.` trennen **echte** zweite Größen → je eigene Zeile.
- **(d)** Ein `->` bezeichnet eine Folge-Größe, die der Katalog selbst auszeichnet → eigene Zeile.

Diese Regel ist der Grund, warum 19 Katalogzeilen zu genau 45 Zielgrößen führen und nicht zu einer
beliebigen anderen Zahl.

---

# TEIL 2 — DIE LEGENDE

## 2.1 Die Mess-Kategorien (Spalte `mess_kategorien` je Achse)

| Kürzel | Bedeutung | Quelle im Apparat | heute erhoben? |
|---|---|---|---|
| **LAT** | Latenz je Operation | Wallclock (`WallClockSystemAxis`) | **ja**, als Mittelwert |
| **THR** | Durchsatz (Operationen/Zeit) | Wallclock | **ja** |
| **CM** | Cache-Misses | `perf_event_open`, `PERF_TYPE_HW_CACHE` | **L1 ja · L2 nie · L3 nur Intel** |
| **CLU** | Cache-Line-Auslastung | Observer-Snapshot, echte Formel | **ja** |
| **dTLB** | Data-TLB-Misses | `perf_event_open`, DTLB/READ/MISS | **ja** |
| **BM** | Branch-Misses | `perf_event_open`, `PERF_COUNT_HW_BRANCH_MISSES` | **ja**, seit M-3a |
| **IPC** | Instruktionen je Zyklus | — | **nein**, strukturell (s. 4.2) |
| **MEM** | Speicher-Fußabdruck | — | **nein**, Schema trägt nur Momentanwert |
| **EN** | Energie (Joule) | RAPL-sysfs | **best effort**, root-abhängig |

## 2.2 Die Parameter-Art (Spalte `parameter_art`)

Sie sagt, **wo** der Parameter einer Achse überhaupt verstellt wird — und damit, ob eine Variation
eine **neue Binary** erzeugt oder nicht. Das ist für die Lagerhaltung entscheidend.

- **CT** — *Compile-Time*. Die Achse wird zur Übersetzungszeit statisch gewählt; jede Ausprägung ist
  **eine eigene Binary** und trägt in die `binary_id` ein. Das ist der Regelfall (13 der 19 Achsen).
- **CT (Binary-Wahl)** — dasselbe, mit ausdrücklichem Vermerk, dass die Wahl die Binary bestimmt.
- **RC-Phantom** — *Runtime-Configurable*. Der Parameter wird zur Laufzeit gesetzt (`thread_count`,
  `batch_size`, `pool_budget_bytes`, `inline_threshold_bytes`, `prefetch_distance`). Er erzeugt
  **keine neue Binary**, sondern eine weitere Messzeile **derselben** Binary. „Phantom" heißt: er
  erscheint als Spalte im Ergebnis, aber nicht im Stempel.
- **CT+asp** — Compile-Time plus ein Aspekt-Parameter (Kapazität, Schwellwert), der zur Laufzeit
  nachgestellt werden kann.
- **CT+Verhalten** — die Achse wählt zur Compile-Zeit eine Strategie, deren Entscheidung aber zur
  Laufzeit fällt (T15 `migration_policy`).

**Warum das für die Messung zählt:** Eine RC-Phantom-Variation ist **billig** — dieselbe Binary,
neue Zeile. Eine CT-Variation ist **teuer** — neuer Bau, neuer Stempel, neuer Lagerplatz. Der
Experiment-Umfang wird von den CT-Achsen bestimmt, nicht von den RC-Achsen.

## 2.3 Pareto-Achsen

Drei Achsen sind ausdrücklich als **Pareto** markiert: **T5 `memory_layout`** (Space vs. Speed),
**T6 `allocator`** (Durchsatz vs. Speicher) und **T18 `queuing_q2`** (Write-Amplification vs.
Latenz). Bei ihnen gibt es **kein einzelnes Optimum** — der „beste" Wert hängt davon ab, welche der
gegenläufigen Größen Vorrang hat. Die Auswertung darf hier keinen Sieger küren, sondern muss die
Pareto-Front ausweisen.

---

# TEIL 3 — DIE 19 ACHSEN, EINZELN ERKLÄRT

Notation: **↓** = Minimieren, **↑** = Maximieren. „Messbar heute" bezieht sich auf den Stand
08.08.2026, am Objekt geprüft.

## T0 — `search_algo` (Suchalgorithmus)
*Kategorien: LAT, THR, CM, BM, IPC · Art: CT (Binary-Wahl) · Fenster [0,2)*

Die Wahl des Suchverfahrens im Baum. Sie bestimmt, wie viele Knoten ein Lookup berührt und wie
vorhersagbar die Sprünge dabei sind.

- **`lookup_latency` ↓** — *„Lookup-Latenz = Baumhöhe × Cache-Lines/Knoten + Vergleiche"*.
  Die Operationalisierung ist der eigentliche Gehalt: Latenz ist hier **keine Blackbox**, sondern
  ein Produkt aus drei zählbaren Anteilen. Wer die Baumhöhe senkt oder die Cache-Lines je Knoten
  reduziert, senkt die Latenz kausal, nicht statistisch.
- **`branch_misses` ↓** — *„Branch-Miss (SIMD/branch-free)"*. Ein branch-freier Suchschritt
  (SIMD-Vergleich statt `if`) hat keinen fehlvorhersagbaren Sprung. Das ist der Grund, warum
  branch-freie Verfahren bei gleicher Instruktionszahl schneller sind.

**Messbar heute: beide.** Latenz über Wallclock, Branch-Misses seit M-3a real erhoben — und der
Smoke-Test prüft ausdrücklich gegen den stillen Nullwert: ein geöffneter, aber 0 gebliebener
Branch-Zähler nach 8 388 608 unvorhersagbaren Zweigen ist `SMOKE_FAIL`.

## T1 — `cache_traversal` (Cache-Durchlauf)
*Kategorien: CM, CLU, dTLB, LAT · Art: RC-Phantom `batch_size` · Fenster [2,2)*

Wie der Baum bezüglich der Speicherhierarchie durchlaufen wird.

- **`cache_misses_per_traversal` ↓** — *„Cache-Misses/Memory-Transfers je Traversal (cache-oblivious
  O(log_B N))"*. Die Klammer benennt das theoretische Ideal: ein cache-obliviouses Layout erreicht
  die optimale Transferzahl **ohne** die Blockgröße B zu kennen.
- **`cache_line_utilization` ↑** — CLU. Wie viel einer geholten Cache-Line tatsächlich gebraucht
  wird. Eine Line von 64 Byte für 8 nützliche Byte ist 12,5 % CLU: 87,5 % der Bandbreite verschenkt.

**Messbar heute: beide** (L1-Misses und CLU). Der Parameter `batch_size` ist RC-Phantom, also
billig zu variieren.

## T2 — `mapping` (Abbildung)
*Kategorien: CM, CLU, LAT, BM · Art: CT · Fenster [4,2)*

Wie Schlüssel auf Speicherorte abgebildet werden.

- **`indirection_cache_misses` ↓** — *„Indirektions-Cache-Misses je Auflösung (Hash-Redirect
  O(logN)→O(1))"*. Ein Hash-Redirect ersetzt logarithmisch viele Zeigerschritte durch einen. Die
  Zielgröße ist nicht die Schrittzahl, sondern die **Cache-Misses** dabei — ein Zeigerschritt im
  L1 ist fast gratis, einer im DRAM kostet dreistellig viele Zyklen.
- **`cache_line_utilization` ↑** — *„Permuter: CLU + atomarer Reorder"*.

**Messbar heute: CLU ja.** Indirektions-Misses nur als L1-Proxy — es gibt keinen Zähler, der
Misses *nach Ursache* trennt.

## T3 — `path_compression` (Pfadkompression)
*Kategorien: MEM, CM, LAT, CLU · Art: CT (Binary-Wahl) · Fenster [6,3)*

Das Kollabieren von Knotenketten mit nur einem Kind.

- **`compression_ratio` ↑** — Kompressionsrate (Single-Child-Kollaps).
- **`tree_height` ↓** — Baumhöhe / Zahl der Zeiger-Indirektionen.
- **`memory_footprint` ↓** — Speicher und Cache-Misses.

**Diese Achse ist das Lehrbuchbeispiel für Abschnitt 1.2:** eine Achse, drei Zielgrößen, davon eine
zu maximieren und zwei zu minimieren. Ein pauschales „kleiner ist besser" hätte hier die
Kompressionsrate invertiert.

**Messbar heute: keine.** Und das ist bemerkenswert — siehe Teil 4.3: `compression_ratio` und
`tree_height` sind **keine Messgrößen, sondern Struktureigenschaften**. Sie fehlen nicht, weil ein
Zähler fehlt, sondern weil niemand die Abfrage gebaut hat.

## T4 — `node_type` (Knotentyp)
*Kategorien: MEM, CLU, CM, LAT · Art: CT · Fenster [9,2)*

Die Knotenrepräsentation — feste Größe gegen adaptive Größe.

- **`node_memory_waste` ↓** — *„Knoten-Speicher-Verschnitt (adaptiv ~52 B/Key)"*. Ein Knoten fester
  Größe für vier Kinder verschwendet Platz, wenn nur eines belegt ist. Adaptive Knoten (ART-Stil)
  wachsen mit der Belegung.
- **`fanout_utilization` ↑** — Verzweigungsgrad-Auslastung, eng an CLU gekoppelt.

**Messbar heute: keine** — beides Struktureigenschaften.

## T5 — `memory_layout` (Speicherlayout) · **PARETO**
*Kategorien: CLU, CM, MEM, dTLB · Art: CT (5 `RepresentationKind`) · Fenster [11,3)*

Die physische Anordnung im Speicher.

- **`cache_line_utilization` ↑**
- **`cache_misses_per_node_access` ↓** — *„CSB+: Pointer-Elimination"*. Cache-Sensitive B+-Bäume
  ersetzen Zeiger durch berechnete Offsets: weniger Speicher je Knoten, mehr Schlüssel je Cache-Line.
- **`memory_footprint` ↓** — *„LOUDS: MEM"*. Succinct-Kodierungen erreichen nahezu die
  informationstheoretische Untergrenze — auf Kosten der Zugriffszeit.

**Pareto-Achse:** Platz gegen Geschwindigkeit. LOUDS gewinnt bei MEM und verliert bei LAT; ein
Sieger existiert nur relativ zu einer Gewichtung.

**Messbar heute: CLU ja**, die anderen beiden nicht.

## T6 — `allocator` (Speicherverwalter) · **PARETO**
*Kategorien: THR, LAT(p99), MEM, EN · Art: RC-Phantom `pool_budget_bytes` · Fenster [14,3)*

- **`alloc_throughput` ↑** — Allokations-Durchsatz und Multicore-Skalierung.
- **`fragmentation` ↓** — Fragmentierung und Speicherverbrauch.
- **`p99_latency` ↓** — die 99. Perzentil-Latenz.

**Warum ausgerechnet p99 und nicht der Mittelwert:** Allokatoren sind im Normalfall schnell und
gelegentlich sehr langsam (wenn sie beim Betriebssystem nachfordern). Der Mittelwert verbirgt genau
das. Die Kategorien-Spalte schreibt darum ausdrücklich `LAT(p99)`.

**Messbar heute: Durchsatz ja.** p99 **ja über die Wide-CSV** (`op_<art>_p99_ns`), aber **nein über
die Kategorien-Achse** — dort ist `LATENCY_P99` bewusst als `not_applicable` gestempelt, mit der
Begründung im Code: *„`total_ns/op_count` ist ein MITTELWERT — ihn als Perzentil zu etikettieren
wäre ein Phantomwert."* Zwei Kanäle, ein Wert, unterschiedlicher Status. **Das ist eine Naht, die
vor der Messung geschlossen gehört.** Fragmentierung ist explizit als *nicht erhoben* gerendert
(`alloc_external_frag_milli`).

## T7 — `prefetch` (Vorabholen)
*Kategorien: LAT, CM, IPC, EN · Art: RC verdrahtet `prefetch_distance` (+MSR hw_pf) · Fenster [17,2)*

- **`effective_memory_latency` ↓** — *„Miss-Latenz verdecken"*. Prefetching senkt nicht die
  Miss-Zahl, sondern **verbirgt** ihre Kosten, indem es sie mit Rechenarbeit überlappt.
- **`memory_level_parallelism` ↑** — MLP: wie viele Speicherzugriffe gleichzeitig in Flug sind.

**Messbar heute: Latenz ja, MLP nein** — MLP setzt IPC voraus, und IPC ist strukturell nicht
erhebbar (Teil 4.2). Diese Achse ist damit **halb blind**: ihre Wirkung ist sichtbar, ihr
Mechanismus nicht.

## T8 — `concurrency` (Nebenläufigkeit)
*Kategorien: THR, LAT(tail), CM/CLU · Art: RC-Phantom `thread_count` · Fenster [19,2)*

- **`multicore_throughput` ↑** — Multicore-Durchsatz und Skalierung.
- **`coherence_traffic` ↓** — Kohärenz-Verkehr und Contention.

**Messbar heute: Durchsatz ja, Kohärenz-Verkehr NEIN** — und zwar hart: das Feld
`coherence_invalidations` wird von **keiner** heutigen PMC-Quelle je geöffnet. Der Code sagt es
selbst. Für eine Nebenläufigkeits-Achse ist das die zentrale Größe; ihr Fehlen ist die
schmerzhafteste Lücke im ganzen Katalog. `thread_count` ist RC-Phantom, die Variation also billig.

## T9 — `serialization` (Serialisierung)
*Kategorien: MEM, LAT, THR · Art: CT · Fenster [21,3)*

- **`compression_ratio` ↑** — Kompressionsrate.
- **`serialized_size` ↓** — *„succinct ~10 bit/Knoten"*. Die Zahl ist der Bezugspunkt: succinct
  kodierte Bäume nähern sich 10 Bit je Knoten, gegenüber 64 Bit je Zeiger im naiven Layout.
- **`decode_latency` ↓** — Dekodier-Latenz, der Preis dafür.

**Messbar heute: nur Latenz.** Größe und Rate sind Struktureigenschaften.

**Anmerkung zur Owner-Antwort G-2:** Diese Achse ist der Ort, an dem die Meta-Meta-Achse ansetzt —
Serialisieren auf Platte und Wiederladen. Der Katalog kennt hier bereits die drei Zielgrößen, die
eine solche Messung braucht.

## T10 — `telemetry` (Telemetrie)
*Kategorien: CM/CLU, THR/LAT, IPC · Art: CT · Fenster [24,1)*

Nur **eine** Zielgröße, und sie ist selbstbezüglich:

- **`observer_perturbation` ↓** — *„Observer-Perturbation = durch die Messung zugefügte
  Kohärenz-Invalidierungen (False-Sharing)"*.

**Das ist die Achse, die den Messapparat selbst misst.** Die Frage lautet: wie stark verfälscht das
Beobachten das Beobachtete? Der Bezug zu unseren eigenen Messungen ist direkt — gemessen wurde in
dieser Woche, dass normale Stores eine cache-residente Last um **+44,4 %** verfälschen, nicht-temporale
Stores nur um **+2,1 %**; und dass ein gemeinsamer Puffer statt Slot-je-Thread bei 16 Threads
**Faktor 69** kostet. Genau diese Effekte benennt `observer_perturbation`.

**Messbar heute: nein.** Sie bräuchte `coherence_invalidations` — den Zähler, der nie geöffnet wird.

**Zusatz:** T10 ist im Katalog eine eigene Achse, ist aber seit Bau-INC-2c/2d **aus der
Kompositions-Achsenmenge ausgetreten** und heute eine System-Achse. Der Katalog bildet damit einen
älteren Stand ab (siehe Teil 5.1).

## T11 — `value_handle` (Wert-Handhabung)
*Kategorien: CM, CLU, MEM, LAT · Art: RC-Phantom `inline_threshold_bytes` · Fenster [25,2)*

- **`value_indirection` ↓** — *„Wert-Indirektion (Inline); Optimum = Schwelle auf Wertgröße"*
- **`node_density` ↑** — *„Knoten-Dichte/CLU (External); Optimum = Schwelle auf Wertgröße"*

**Beide Zielgrößen tragen denselben Nachsatz, und das ist der Kern:** das Optimum ist **kein Wert,
sondern eine Schwelle**. Kleine Werte gehören inline (keine Indirektion), große ausgelagert (sonst
sinkt die Knotendichte). Gesucht ist der Umschlagpunkt — und genau dafür ist `inline_threshold_bytes`
als RC-Phantom verdrahtet: man kann die Schwelle durchfahren, ohne neu zu bauen.

**Messbar heute: keine direkt.** Aber die Wirkung ist über CLU und L1-Misses sichtbar, und da der
Parameter RC ist, lässt sich der Umschlagpunkt **empirisch** finden, auch ohne die Zielgröße direkt
zu messen. Das ist der billigste echte Erkenntnisgewinn im ganzen Katalog.

## T12 — `isa` (Befehlssatz)
*Kategorien: IPC, THR, BM, EN · Art: CT (Thesis: Compile-Time-Achse) · Fenster [27,4)*

- **`data_parallelism` ↑** — Daten-Parallelität je Instruktion (breitere SIMD).
- **`ipc` ↑** — Instruktionen je Zyklus.
- **`instructions_per_lookup` ↓** — Instruktionen je Lookup.
- **`branch_misses` ↓**

**Messbar heute: nur `branch_misses`.** Drei der vier Zielgrößen dieser Achse hängen an IPC, und IPC
ist strukturell nicht erhebbar. **T12 ist damit zu 75 % blind** — die am schlechtesten gedeckte
Achse des Katalogs. Für eine Thesis, die SIMD-Breite als System-Achse führt, ist das ein Befund von
Gewicht.

Wie T10 ist auch T12 heute eine System-Achse und nicht mehr Teil der Komposition.

## T13 — `index_organization` (Index-Organisation)
*Kategorien: CM/CLU, LAT, THR, MEM · Art: CT · Fenster [31,2)*

- **`storage_order_locality` ↑** — *„Scan: Storage-Order-Lokalität (clustered)"*
- **`redundancy` ↓** — *„Point+Sekundär: Redundanz (non-clustered)"*

**Die beiden Klammern sind der Gehalt:** die Richtung hängt von der **Zugriffsart** ab. Für Scans
gewinnt der geclusterte Index (physische Ordnung = logische Ordnung), für Punktabfragen mit
Sekundärindizes der nicht-geclusterte. Diese Achse lässt sich ohne Angabe der Last **nicht**
bewerten — sie ist der stärkste Beleg dafür, dass die Auswertung last-abhängig sein muss.

**Messbar heute: keine.**

## T14 — `io_dispatch` (E/A-Vermittlung)
*Kategorien: LAT, THR, dTLB, CM · Art: CT · Fenster [33,2)*

- **`io_throughput` ↑** — E/A-Durchsatz und Kontrolle (async/evict).
- **`page_fault_overhead` ↓** — *„Page-Fault/TLB-Shootdown-Overhead (mmap-Antipattern)"*.
  Das Wort **Antipattern** ist eine Wertung des Katalogs: `mmap` wirkt bequem, verlagert die Kosten
  aber in Page-Faults und TLB-Shootdowns, die in keiner Anwendungsmessung auftauchen.

**Messbar heute: näherungsweise** — Durchsatz direkt, Page-Fault-Overhead über dTLB-Misses als Proxy.

## T15 — `migration_policy` (Verdrängungsstrategie)
*Kategorien: LAT, CM, MEM, THR, EN · Art: CT+Verhalten (Laufzeit-Entscheidung, keine RC) · Fenster [35,2)*

- **`tier_weighted_latency` ↓** — *„durchschnittliche tier-gewichtete Latenz = Cold-Tier-Zugriffe je
  Speicherbudget"*.
- **`eviction_regret` ↓** — *„adaptiv (LeCaR): Eviction-Regret"*. Regret misst, wie viel schlechter
  die getroffene Entscheidung gegenüber der im Nachhinein besten war.

**Die Parameter-Art ist hier besonders:** *CT+Verhalten, Laufzeit-Entscheidung, keine RC*. Die
Strategie wird zur Compile-Zeit gewählt, ihre Entscheidungen fallen aber zur Laufzeit — sie ist
damit **weder** eine reine CT-Achse **noch** ein RC-Parameter. Für die Messung heißt das: jede
Strategie ist eine eigene Binary, aber ihr Verhalten hängt von der Last ab.

**Messbar heute: keine.**

## T16 — `filter` (Filter)
*Kategorien: MEM, CM, LAT, THR · Art: CT (+bits/Key-Config) · Fenster [37,2)*

- **`false_positive_rate_per_bit` ↓** — *„= bits/Key bei Ziel-FPR"*
- **`probe_memory_accesses` ↓** — *„Filter-Probe-Memory-Zugriffe (Xor=3, Cuckoo=2)"*

**Die Zahlen in der Klammer sind harte Konstanten der Verfahren**, keine Messwerte: ein Xor-Filter
braucht 3 Speicherzugriffe je Probe, ein Cuckoo-Filter 2. Sie sind **abzählbar, nicht zu messen** —
und deshalb ein guter Kandidat für eine Struktur-Abfrage statt einer Messung.

**Messbar heute: keine.**

## T17 — `queuing_q1` (Warteschlange 1)
*Kategorien: THR, LAT, MEM, CLU · Art: CT+asp (Kapazität) · Fenster [39,3)*

- **`buffer_throughput` ↑** — Puffer-Durchsatz und Batching.
- **`buffer_memory` ↓** — Puffer-Speicher und Drain-Latenz.
- **`producer_consumer_parallelism` ↑** — lock-free: Producer/Consumer-Parallelität.

**Messbar heute: nur Durchsatz.**

**Wichtige Abgrenzung, die der Code selbst zieht:** Die Mess-Kategorie `FILL_BUFFER_OCCUPANCY` meint
den **Hardware-Line-Fill-Buffer**, T17 `queuing_q1.peak_size` dagegen einen **Software-Puffer**. Der
Code stempelt die Kategorie deshalb als `not_applicable` mit der Begründung: *„physisch unverwandt,
kein Proxy"*. Das ist genau die Sorte Ehrlichkeit, die eine falsche Zahl verhindert.

## T18 — `queuing_q2` (Warteschlange 2) · **PARETO**
*Kategorien: THR, LAT, MEM, EN · Art: CT+asp (Threshold) · Fenster [42,3)*

- **`write_amplification` ↓** — *„(lazy)"*
- **`batching` ↑** — *„(lazy)"*
- **`staleness_tail_latency` ↓** — *„(eager)"*

**Pareto-Achse mit sichtbarem Gegensatz:** die ersten beiden Größen gehören zur *lazy*-Strategie,
die dritte zur *eager*-Strategie. Lazy sammelt und schreibt selten (wenig Amplification, gutes
Batching), zahlt aber mit Veraltung und Tail-Latenz. Eager ist umgekehrt. Ein Sieger existiert nur
relativ zur Frage, ob Frische oder Schreiblast wichtiger ist.

**Messbar heute: keine** (Tail-Latenz näherungsweise über p99 aus der Wide-CSV).

---

# TEIL 4 — DER MESSBARKEITS-BEFUND

## 4.1 Die Zahl

**Der Katalog kennt 45 Zielgrößen. Der Messapparat erhebt 6 Kategorien bedingungslos.**

Bedingungslos erhoben: **CLU · L1-Misses · dTLB-Misses · Branch-Misses · Latenz-Mittel · Durchsatz.**
Bedingt: **L3-Misses** nur auf Intel (auf AMD Zen 5 liefert `perf_event_open` für LL/READ/MISS
`ENOENT` — verifiziert auf identischer Hardware und identischem Kernel), **Energie** nur wenn RAPL
lesbar ist (seit Linux 5.10 oft root-only).

Nicht erhoben, obwohl deklariert: **L2-Misses** (von keiner Quelle je geöffnet), **Speicher-Fußabdruck**,
**IPC/CPI**, und die vier **Latenz-Perzentile** über den Kategorien-Kanal.

## 4.2 Warum IPC strukturell unmöglich ist

Das ist kein Konfigurationsproblem. Der Code sagt es wörtlich: *„das aktuelle `PmcCounters`-POD
enthält keine `instructions`/`cycles`-Spalten. IPC/CPI ist eine ECHTE PMC-Kategorie … es fehlen die
Zähler-QUELLEN."*

**Nicht die Öffnung fehlt, sondern das Feld.** Solange das POD keine zwei zusätzlichen Spalten
trägt, kann kein Aufruf der Welt IPC liefern. Mit IPC fallen: `ipc` (T12), `data_parallelism` (T12),
`instructions_per_lookup` (T12) und `memory_level_parallelism` (T7). **Vier Zielgrößen an einem
fehlenden POD-Feld.**

Der Aufwand ist klein: zwei weitere `perf_event_open`-Aufrufe mit `PERF_COUNT_HW_INSTRUCTIONS` und
`PERF_COUNT_HW_CPU_CYCLES` — beides generische Events, die auf jedem PMU existieren, ohne
Hybrid-Problematik.

## 4.3 Die nützlichste Einsicht: die Hälfte ist gar keine Messung

Von den nicht erhobenen Zielgrößen ist ein großer Teil **überhaupt keine Messgröße**, sondern eine
**Struktureigenschaft der Datenstruktur**:

`tree_height` · `compression_ratio` · `node_density` · `fanout_utilization` · `serialized_size` ·
`node_memory_waste` · `redundancy` · `probe_memory_accesses` · `false_positive_rate_per_bit`

**Die fragt man ab, die misst man nicht.** Ein Baum weiß seine Höhe. Ein Filter weiß seine Bits je
Schlüssel. Ein serialisierter Block weiß seine Größe. Diese Größen fehlen nicht, weil ein
Hardware-Zähler fehlt, sondern weil **niemand die Abfrage-Schnittstelle gebaut hat**.

Das ist der billigste Weg, die Liste der verfügbaren Zielgrößen substanziell zu verlängern: eine
Struktur-Abfrage je Achse, deterministisch, ohne Messrauschen, ohne PMC, ohne Plattform-Abhängigkeit.
**Und diese Werte sind exakt** — sie brauchen keine Wiederholung, keine 5 %-Drift-Prüfung und keinen
Warm-Cache.

## 4.4 Was hart fehlt und nicht billig zu haben ist

- **`coherence_invalidations`** — nie geöffnet, kein portabler generischer Zähler. Ohne ihn sind
  T8 `coherence_traffic` und T10 `observer_perturbation` blind.
- **`memory_footprint`** — der Code nennt den Grund: *„der Thesis-Kanon verlangt
  `bytes_in_use_peak` … das T6-Schema trägt nur den Momentanwert"*. Es fehlt eine Spitzenwert-Erfassung,
  nicht ein Zähler.
- **Die Perzentil-Naht** — p50/p99/p999 existieren real in der Wide-CSV, sind aber über den
  Kategorien-Kanal als `not_applicable` gestempelt. Zwei Kanäle, unterschiedlicher Status. **Vor der
  Messung zu schließen**, sonst tragen zwei Ausgaben desselben Laufs widersprüchliche Aussagen.

---

# TEIL 5 — WAS FÜR DEN BAU FOLGT

## 5.1 Der Katalog bildet einen älteren Achsenstand ab

Der Katalog führt **19** Achsen T0..T18 mit `telemetry` (T10) und `isa` (T12). Die aktive
Kompositions-Achsenmenge führt **18** Achsen T00..T17 **ohne** diese beiden, dafür **mit**
`persistence_target`. Der Header benennt den Widerspruch selbst und nennt ihn einen **Owner-Entscheid,
keinen Bau-Rückstand**: *„für `persistence_target` existiert KEINE Katalog-Zeile und damit hier KEINE
Richtung … liefert honest-empty."*

Ein Test verwacht den Drift: *„genau EINE Kompositions-Achse ohne Katalog-Zeile: `persistence_target`."*

**Zu entscheiden:** ob der Katalog um eine `persistence_target`-Zeile ergänzt wird (dann: welche
Zielgrößen und welche Richtungen) und ob `telemetry`/`isa` als System-Achsen im Katalog bleiben oder
in einen eigenen System-Katalog wandern.

## 5.2 Die XML-Whitelist je Achse — was zu bauen ist

Heute ist `<measurement_categories>` **flach und achsenlos**: eine Liste von Kategorien, die für
**alle** Achsen gleich gilt. Der Validator prüft die Namen gegen die Registry, leer bedeutet „alle 16".
Der geparste Wert wird durchgereicht, **filtert aber die geschriebenen Spalten nicht** — das ist als
eigener, noch nicht gebauter Posten benannt.

Das existierende Achsen-Whitelist-Muster, dem die Zielgrößen folgen sollen, ist
`<permute_axes><axis ref="X"><value>Y</value></axis></permute_axes>` — geprüft gegen die reale
Achsen-Registry, leere Werteliste = volle Liste.

**Der Bau ist damit gut umrissen:** dieselbe Grammatik eine Ebene tiefer, mit dem Katalog als
Prüfquelle statt der Achsen-Registry. Eine unbekannte Zielgröße muss dabei **laut** scheitern, nicht
still ignoriert werden.

## 5.3 Die Min/Max-Spalte in der Excel-Ausgabe

Nach der Owner-Antwort zu G-3 (08.08.): Die Kernlogik erhebt **nur**, min/max entsteht erst in der
compare-Phase über die exakten Messwerte. In den Excel-Tabellen soll je
**Achse-Algorithmus-Parameter** stehen, ob min oder max als bester Wert gilt.

Die Quelle dafür ist genau dieser Katalog — `OptimizationDirection::Minimize` bzw. `::Maximize` je
Zielgröße. Zwei Punkte sind dabei zwingend:

1. **Die Spalte gehört zur Zielgröße, nicht zur Achse** (Abschnitt 1.2). Eine Achse kann in
   derselben Zeile drei Richtungen tragen.
2. **Bei den drei Pareto-Achsen (T5, T6, T18) darf kein Sieger gekürt werden.** Dort ist die
   ehrliche Ausgabe die Pareto-Front, nicht ein bester Wert.

---

# TEIL 6 — DIE MESS-EBENEN: WO EINE ZIELGRÖSSE ÜBERHAUPT ERHOBEN WIRD

Die Zielgrößen aus Teil 3 sagen, **was** gemessen wird. Sie sagen nicht, **wo**. Das entscheidet die
Mess-Ebene — und dieselbe Zielgröße hat auf verschiedenen Ebenen verschiedene Bedeutung.

## 6.1 Die drei kanonischen Erhebungs-Ebenen

Belegt in `Ledger:7781-7782` (Owner-Auftrag O-B, 07.08.2026):

| Ebene | Gegenstand | Messort | Instrument |
|---|---|---|---|
| **E1 Micro** | **eine** Achse über ihr **Achsen**-Interface (nicht das Gattungs-Interface) | **in die Tier-Binary einkompiliert** | gemischt: Wallclock **und** PMC |
| **E2 Macro (timed)** | **eine** Gattung+Genus-Funktion | CEB-seitig **am Prüfdock** gegen die Tier-Binary | Wallclock + Schritt-Checkpoints |
| **E3 Macro large scope** | **ein** Lastprofil = Aggregat **aller** E2-Charts | CEB | aggregiert E2 |

E1 ist als 18-Zeilen-Tabelle T0…T17 ausgeschrieben
(`ce docs/architecture/20260803-a8_f2_benchmarking_schnitt_soll_design.md:187-211`). Bemerkenswert
darin: T6 `allocator` misst `allocate`/`deallocate` als **reale Operationen** — ausdrücklich **kein
Stats-READ als Zeit-Surrogat**. Das ist dieselbe Ehrlichkeitsregel wie bei den Kategorien: lieber
keine Zahl als eine Ersatzzahl.

**Der entscheidende Unterschied zwischen E1 und E2:** E1 misst **innerhalb** der Binary, durch das
Achsen-Interface — jede Achse einzeln, isoliert. E2 misst **von außen**, durch das Gattungs-Interface
am Prüfdock. Eine Achse, die in E1 gut aussieht, kann in E2 verlieren, weil ihr Gewinn im
Gesamtaufruf untergeht. **Beide Zahlen sind richtig und sie widersprechen sich nicht** — sie
beantworten verschiedene Fragen.

## 6.2 Der vierte Layer — Observer im Vertrag CEB ↔ Tier-Binary

Owner verbatim, 06.08.2026 (`Ledger:6806`):

> *„…dabei fehlt mir besonders welche Genus es unter jeder Gattung gibt, welchen Interface-Kern sie
> nach außen im gemeinsamen Gattungs-Kern teilen, und wie jeweils ihre Mikro-, Makro- und
> Wallclocktime-Messung eingebunden wird. **Das ist ein vierter Layer der Observer-Stufe im Vertrag
> zwischen CEB und Tier-Binary!**"* — und: *„der Architektur-Kern ist **VERGESSEN und GEPLANT**, aber
> er ist nicht neu."*

## 6.3 Die Wallclock-Korrektur

Owner verbatim, 06.08.2026 (`Ledger:6780`):

> *„Micro- und Macro-Benchmarking sind FALSCH und entsprechen nicht dem neuesten Stand der Planung im
> Ledger. **Wallclock time wird je Tier-Binary-Funktion und über eine Kombination einer Last JEWEILS
> gemessen.**"*

Die zugehörige Mechanik steht seit dem 31.05. in `messarchitektur_v5_design.md` als
**Zwei-Phasen-Op-Schleife**:

```
save_all  →  Erstausführung  →  rollback_all  →  op-measure
```

wallclock-umklammert, Observer gleichzeitig. Der Grund für die zwei Phasen: die Erstausführung
verändert den Zustand (füllt Caches, alloziert, wärmt Zweigvorhersage). Erst der `rollback_all`
stellt den Ausgangszustand wieder her, und **dann** wird gemessen — auf **warmem Cache im originalen
RAM-Zustand**. Das ist genau die „warm-cache Messung", auf die sich die 5 %-Regel bezieht.

## 6.4 Die fünfte Ebene — der Nullbefund, ehrlich benannt

Der Owner sprach am 08.08. von **fünf** querschneidenden Ebenen. Über den Ledger (10 840 Zeilen) und
das Break-Even-Plandokument (825 Zeilen) gesucht:
`"fuenf Ebenen"` = 0 · `"fünf Ebenen"` = 0 · `"5 Mess-Ebenen"` = 0 · `"vier Ebenen"` = 0.
**Gegenprobe, die treffen muss:** `"drei Ebenen"` = 4 Treffer im Ledger, 7 im Plandokument — die
Suche greift, der Nullbefund ist echt.

Zwei Lesarten sind möglich, keine ist belegt:
- **(i)** 3 Erhebungs-Ebenen + Observer-Layer 4 + **Release-Wallclock als Ebene 5** (die
  §61-Release-Nachmessung ohne Mess-Einrichtungen — eine eigene, querschneidende Zeitmessung).
- **(ii)** der Owner zählt die **fünf Genera** (`anatomy_base.hpp:98-107`: SearchAlgorithm + Set +
  Sequence + Adapter + View) als die fünf Vergleichsebenen. Das passt sprachlich zu
  *„Achsen-Algorithmen, Gattung/Genus-Interfaces und die Gesamtzeit"*.

**Bis zur Klärung ist die dokumentierte Zahl DREI.** Jede Bau-Aussage mit fünf Ebenen wäre erfunden.

## 6.5 `checkpoint_measure` — das Instrument, das die Ebenen verbindet

Spezifiziert in `ce docs/architecture/20260808-checkpoint_measure_soll_design.md` (Owner-KERN 08.08.).

**Die Signatur ist EINE uniforme Funktion.** `IN` und `OUT` sind ein Compile-Time-Tag, kein
Laufzeit-Parameter — es gibt nicht zwei Funktionen, sondern eine mit statischem Argument. Sie ist
`inline` und schreibt eine Steuerzeile auf einen **prozessweiten append-only Stack**.

**Der Aufrufer ist ein Tripel:**

1. **Prozessname**
2. **Funktionsname auf dem Stack** — über einen **eigenen** Stacktrace, ausdrücklich **nicht**
   `std::stacktrace`
3. **Thread-Nummer** — aus **virtuellen Slots**, deren Obergrenze die Thread-Unterachse zur
   Compile-Zeit festlegt. Jeder erlaubte Thread registriert sich einmal bei seiner Entstehung gegen
   eine eigene ID; im Hot-Path wird der Slot nur noch **gelesen**. Owner wörtlich: *„Ein int tut es."*

**Die Mess-Ebene ist ein CMake-Flag**, kein Laufzeit-Zustand. Der Aufrufer wird beim **Auslesen
rekonstruiert**, nicht beim Messen ermittelt — über die Ebenen-Ordnung `macro → micro` und
`compare → macro`. Ein Vorwärtsdurchlauf mit einem Stapel je Ebene löst das in **O(n)**.

**Regressionen fallen dabei als Nebenprodukt ab:** *„Wenn ein Thread ein Interface betritt, aber es
nicht wieder verlässt, ist das eine Regression."* Ein `IN` ohne zugehöriges `OUT` bleibt beim
Auslesen auf dem Stapel liegen — man muss nicht danach suchen, es ist der Rest.

### Warum kein `std::stacktrace` — die gemessenen Kosten

Alle Werte auf prod1, GCC 15.3, `-O2`, warme Werte, in dieser Woche gemessen:

| Mechanismus | Kosten je Aufruf |
|---|---|
| `source_location` als Default-Argument | **0,92 ns** |
| Thread-Kennung lesen | 3,5 ns |
| `__rdtsc()` | **6,8 ns** |
| `steady_clock::now()` | 16,5 ns |
| `std::stacktrace::current(1,1)` | **343 ns** |
| dieselbe, plus `description()` | **~26 900 ns** |

`<stacktrace>` ist verfügbar (GCC 15.3 und clang 22.1, beide libstdc++, `__cpp_lib_stacktrace 202011`)
— es ist also **keine Verfügbarkeitsfrage, sondern eine Kostenfrage.** 343 ns je Checkpoint sind
gegenüber 6,8 ns für einen Zeitstempel ein Faktor **50**; mit Symbolauflösung ein Faktor **4000**.
Ein Instrument, das teurer ist als das Gemessene, misst sich selbst.

Der eigene Stacktrace kostet stattdessen: ein `source_location`-Default-Argument (0,92 ns), ein
gelesener Thread-Slot (ein `int`) und ein `__rdtsc()` (6,8 ns).

### Drei weitere Messungen, die den Entwurf bestimmt haben

- **Gemeinsamer Puffer statt Slot je Thread: Faktor 69** bei 16 Threads. Daher die virtuellen Slots.
- **`relaxed` == `seq_cst` auf x86-64** — beides übersetzt zu `lock xadd`. Ein schwächeres
  Speichermodell bringt auf dieser Architektur nichts.
- **Normale Stores verfälschen eine cache-residente Last um +44,4 %, nicht-temporale nur um +2,1 %.**
  Das ist die `observer_perturbation` aus T10, in Zahlen.

## 6.6 Die Zuordnung Achse → Mess-Ebene

Die Ebene folgt aus der Parameter-Art (Abschnitt 2.2), nicht aus der Achse:

- **CT-Achsen** (Compile-Time, eigene Binary) werden in **E1** einzeln vermessen und gehen über die
  `binary_id` in den Vergleich ein. Ihr Beitrag ist zwischen zwei Binaries mit **einem Knoten
  Unterschied** im Experiment-B+-Baum ablesbar — das ist das kontrollierte Experiment.
- **RC-Phantom-Parameter** (`thread_count`, `batch_size`, `pool_budget_bytes`,
  `inline_threshold_bytes`, `prefetch_distance`) erzeugen **keine** neue Binary. Sie sind Zeilen
  **derselben** Binary und werden in **E2/E3** durchfahren — dort, wo eine Last anliegt, gegen die
  ein Schwellwert überhaupt einen Sinn hat.
- **T11 `value_handle`** ist das reinste Beispiel: sein Optimum ist laut Katalog **eine Schwelle auf
  die Wertgröße**. Eine Schwelle findet man nur, indem man sie durchfährt — also auf E2/E3, nicht E1.
- **T10 `telemetry`** misst den Messapparat selbst und ist damit **querschneidend zu allen Ebenen**.

---

# ANHANG — DIE TABELLE

| Achse | Kategorien | Art | Ebene | Zielgrößen (Richtung) | heute erhoben |
|---|---|---|---|---|---|
| T0 `search_algo` | LAT THR CM BM IPC | CT | E1 | lookup_latency ↓ · branch_misses ↓ | **2/2** |
| T1 `cache_traversal` | CM CLU dTLB LAT | RC `batch_size` | E1 + E2/E3 | cache_misses_per_traversal ↓ · CLU ↑ | **2/2** |
| T2 `mapping` | CM CLU LAT BM | CT | E1 | indirection_cache_misses ↓ · CLU ↑ | 1/2 |
| T3 `path_compression` | MEM CM LAT CLU | CT | E1 | compression_ratio ↑ · tree_height ↓ · memory_footprint ↓ | 0/3 |
| T4 `node_type` | MEM CLU CM LAT | CT | E1 | node_memory_waste ↓ · fanout_utilization ↑ | 0/2 |
| T5 `memory_layout` **P** | CLU CM MEM dTLB | CT | E1 | CLU ↑ · cache_misses_per_node_access ↓ · memory_footprint ↓ | 1/3 |
| T6 `allocator` **P** | THR LAT(p99) MEM EN | RC `pool_budget_bytes` | E1 + E2/E3 | alloc_throughput ↑ · fragmentation ↓ · p99_latency ↓ | 1/3 (+p99 via CSV) |
| T7 `prefetch` | LAT CM IPC EN | RC `prefetch_distance` | E1 + E2/E3 | effective_memory_latency ↓ · MLP ↑ | 1/2 |
| T8 `concurrency` | THR LAT(tail) CM/CLU | RC `thread_count` | E1 + E2/E3 | multicore_throughput ↑ · coherence_traffic ↓ | 1/2 |
| T9 `serialization` | MEM LAT THR | CT | E1 | compression_ratio ↑ · serialized_size ↓ · decode_latency ↓ | 1/3 |
| T10 `telemetry` | CM/CLU THR/LAT IPC | CT | **quer zu allen** | observer_perturbation ↓ | 0/1 |
| T11 `value_handle` | CM CLU MEM LAT | RC `inline_threshold_bytes` | **E2/E3** (Schwelle) | value_indirection ↓ · node_density ↑ | 0/2 |
| T12 `isa` | IPC THR BM EN | CT | E1 | data_parallelism ↑ · ipc ↑ · instructions_per_lookup ↓ · branch_misses ↓ | 1/4 |
| T13 `index_organization` | CM/CLU LAT THR MEM | CT | **E2/E3** (lastabh.) | storage_order_locality ↑ · redundancy ↓ | 0/2 |
| T14 `io_dispatch` | LAT THR dTLB CM | CT | E1 + E2 | io_throughput ↑ · page_fault_overhead ↓ | ~2/2 |
| T15 `migration_policy` | LAT CM MEM THR EN | CT+Verhalten | **E2/E3** (lastabh.) | tier_weighted_latency ↓ · eviction_regret ↓ | 0/2 |
| T16 `filter` | MEM CM LAT THR | CT (+bits/Key) | E1 | false_positive_rate_per_bit ↓ · probe_memory_accesses ↓ | 0/2 |
| T17 `queuing_q1` | THR LAT MEM CLU | CT+asp | E1 + E2 | buffer_throughput ↑ · buffer_memory ↓ · producer_consumer_parallelism ↑ | 1/3 |
| T18 `queuing_q2` **P** | THR LAT MEM EN | CT+asp | E1 + E2 | write_amplification ↓ · batching ↑ · staleness_tail_latency ↓ | 0/3 |

**P** = Pareto-Achse (kein einzelnes Optimum).
**Ebene:** E1 = Micro, in der Tier-Binary über das Achsen-Interface · E2 = Macro, am Prüfdock über
das Gattungs-Interface · E3 = Lastprofil-Aggregat. **Fett** markierte Ebenen sind solche, bei denen
E1 allein die Frage **nicht** beantworten kann: eine Schwelle (T11) und drei lastabhängige
Richtungsumkehrungen (T13, T15) sind ohne anliegende Last nicht bestimmbar.

## Die drei Achsen, bei denen E1 allein irreführt

- **T11 `value_handle`** — das Optimum ist laut Katalog *„eine Schwelle auf die Wertgröße"*. Ein
  einzelner E1-Messpunkt liefert einen Wert, aber nicht den Umschlagpunkt.
- **T13 `index_organization`** — die Richtung **kehrt sich mit der Zugriffsart um**: für Scans
  gewinnt geclustert, für Punktabfragen nicht-geclustert. Ohne Angabe der Last ist „besser"
  bedeutungslos.
- **T15 `migration_policy`** — die Strategie wird zur Compile-Zeit gewählt, ihre Entscheidungen
  fallen zur Laufzeit. Nur unter Last zeigt sich, ob sie gut entscheidet.

**Für die XML-Whitelist heißt das:** eine Zielgrößen-Einschränkung darf nicht nur „welche Größe",
sondern muss auch „auf welcher Ebene" tragen. Sonst schränkt man eine Größe auf eine Ebene ein, auf
der sie nichts aussagt.

---

## Belegstellen

| Aussage | Datei |
|---|---|
| Katalog, 45 Zielgrößen, 19 Achsen, Min/Max | `ce libs/cache_engine/heuristik/axis_optimization_catalog.hpp` |
| Break-Even-Fehlbefund (pauschal „kleiner ist besser") | ebd., Kopfkommentar |
| Übertragungsregel (a)–(d) | ebd., Kopfkommentar |
| Kategorien-Status (erhoben / n/a / Quelle fehlt) | `ce .../measurement/system_axis.hpp` |
| PMC-Öffnungen (L1, LL, dTLB, Branch) + RAPL | `ce .../measurement/linux_perf_pmc_source.hpp` |
| L2 und Kohärenz werden nie geöffnet; L3 ENOENT auf Zen 5 | `ce .../measurement/pmc_source.hpp` |
| 16 Kategorien, Single-Source | `ce .../measurement/measurement_category.hpp` |
| Kategorien-Whitelist flach, binary_id-neutral | `ce libs/cache_engine/profile_facade/validate_profile.hpp` |
| Achsen-Whitelist-Muster `<permute_axes>` | ebd. |
| Wide-CSV mit realen p50/p99 je Op-Art | `ce .../experiment_tree/cache_engine_builder_iterator.hpp` |
| Kompositions-Achsen (18, T00..T17) | `ce .../experiment_tree/axis_path_serialization.hpp` |
| Katalog-Drift verwacht | `ce tests/unit/test_heuristik_spline_break_even.cpp` |
