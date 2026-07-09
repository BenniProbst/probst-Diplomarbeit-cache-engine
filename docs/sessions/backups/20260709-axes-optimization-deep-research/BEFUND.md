# BEFUND — Optimierungs-Semantik je Achse (Deep Research, 2026-07-09)

> **Zweck:** Für die TU-Dresden-Diplomarbeit „cache-engine" je der 19 Kompositions-Achsen (T0–T18) die
> **Optimierungs-Eigenschaft** bestimmen (Min ODER Max einer *messbaren* Größe), grounded in (a) der
> Thesis-LaTeX + Architektur-Doku (Ist-Stand) und (b) peer-reviewed DB-Index-/cache-conscious-Literatur.
> Ziel der Endauswertung: mehrdimensionale **statische Heuristik-Kurven** über die Achsen-Parameter, die je
> **Last** (YCSB A–F / LP01–LP14) + **Füllstand** (Einträge) + **Beschaffenheit** (Key/Value-Verteilung) die
> optimale per-Achse-Konfiguration abschätzen.
>
> **Autoritative Quellen dieses Befunds:**
> `thesis/diplomarbeit/kapitel/de/{03_messsystem_prtart,04_concept_architecture,06_evaluation_methodology}.tex`
> · `docs/architektur/16_E1_E4_KONSOLIDIERUNG_DOSSIER.md` · `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`
> · ce `libs/cache_engine/anatomy/resource_controllable_tier.hpp` (RC-POD) · ce
> `libs/cache_engine/anatomy/abi_adapter.hpp:205-244` (RC-apply) · ce
> `libs/cache_engine/builder/cacheline_policy/cacheline_policy_selector.hpp` (Heuristik-Kurve, bereits
> prototypisiert). Web-Belege je Achse unten zitiert.

---

## 0. Mess-Kategorien und das Runtime-/Compile-time-Fundament

### 0.1 Die Thesis-Mess-Kategorien (Kürzel für die Tabellen)

Aus `03_messsystem_prtart.tex:382-384`: **CLU** = Cache-Line-Auslastung · **CM** = Cache-Misses (L1/L2/L3) ·
**dTLB** = dTLB-Misses · **BM** = Branch-Misses · **IPC** = IPC/CPI · **LAT** = Latenz · **THR** = Durchsatz ·
**MEM** = Speicher-Fußabdruck · **EN** = Energie. Die zeit-/observer-basierten Kategorien (LAT, THR, CLU über
Observer, MEM) löst die eigene Apparatur bereits auf; die zählerbasierten PMC-Kategorien (CM, dTLB, BM, IPC,
EN) sind an privilegierten `perf`/MSR-Zugriff gebunden (`06_evaluation_methodology.tex:115-126`).

### 0.2 Der Runtime-Knopf (#221 / E1-RC) — die einzige harte Wahrheit für Deliverable (3)

Die SearchAlgorithm-Gattung trägt **genau EINEN** ABI-stabilen Laufzeit-Steuer-POD:
`ComdareResourceControlV1` (`resource_controllable_tier.hpp:34-43`) mit **5 laufzeit-steuerbaren
Achsen-Feldern**. Das ist die code-verankerte, autoritative Definition dessen, welche Achse einen „echten
Laufzeit-Knopf" hat (E1 = RC-Laufzeit; `16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:59-61,135`):

| RC-POD-Feld | Achse (T-ID) | Cap (`abi_adapter.hpp:215-220`) | Ist-Status Laufzeit-Wirkung |
|---|---|---|---|
| `prefetch_distance` | **T7 prefetch** | 64 CL | ✅ **REAL/verdrahtet** — `set_runtime_distance()` → realer Store-`_mm_prefetch`; literal verifiziert `default=4 / rc=2→2 / rc=9→9` (LEDGER Z.191). #221 für prefetch **geschlossen**. |
| `thread_count` | **T8 concurrency** | 64 | ⚠️ Cap deklariert, **Setter fehlt** → „Phantom-Zeile" (`abi_adapter.hpp:233` schreibt nur `applied_rc_`, wirkt nicht). #221-Rest. |
| `pool_budget_bytes` | **T6 allocator** | 1 GiB | ⚠️ Cap deklariert, **Setter fehlt** → Phantom. #221-Rest. |
| `batch_size` | **T1 cache_traversal** (axis_03a, Working-Set) | 4096 | ⚠️ Cap deklariert, **Setter fehlt** → Phantom. #221-Rest. |
| `inline_threshold_bytes` | **T11 value_handle** | 256 B | ⚠️ Cap deklariert, **Setter fehlt** → Phantom. #221-Rest. |

Zusätzlich **architektonische Laufzeit-Ausnahmen außerhalb des POD** (`runtime_variable_loop.hpp:11-12,63`):
`hw_prefetcher` via MSR `0x1A4` (SLURM-Launcher, `slurm_launcher.hpp:25,54`) und `thread_count` als
For-Schleifen-Dimension (`DynamicVariableNode`).

**„honest-0" (Direktive `feedback_compile_time_only_no_runtime`):** Alle übrigen 14 Achsen wählen ihre Variante
**compile-time** (E2 = Tier-Binary / E3 = Permutations-B+-Baum) und haben **keinen** RC-Laufzeit-Knopf; sie
degradieren ehrlich zu No-op auf dem RC-Kanal, statt einen Wert zu erfinden. Das ist **gewollt** (die *korrekte*
Metaprog-Grenze: `16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:184`) — kein Defekt.

### 0.3 Die Heuristik-Kurve ist bereits prototypisiert (Deliverable-4-Fund)

`cacheline_policy_selector.hpp` implementiert als GoF-Strategy (`ScanOptimizing`/`LatencyOptimizing`) **exakt
die Endauswertungs-Heuristik**: es leitet die 5 RC-Felder aus einem `WorkloadProfileAggregate`
(`scan_share`, `write_share`, `working_set_n`) ab. Die dort kodierten Stützstellen sind die konkreten
Heuristik-Kurven über den RC-Achsen:

- `prefetch_distance` **monoton mit scan_share**: scan≥50 %→16 CL, gemischt→8 CL, punkt→2 CL (`:122-125,149-152`).
- `batch_size` (T1) **skaliert mit Working-Set × scan_share**: scan→ws, gemischt→ws/4, punkt→1 CL (`:154-164`).
- `pool_budget_bytes` (T6) **linear im Working-Set**: ws × Record-Größe (`:166-167`).
- `inline_threshold_bytes` (T11) **getriggert von write_share**: write-heavy→64 B, read→16 B (`:169-170`).
- `thread_count` (T8) **ehrlich 0** bis ein Nebenläufigkeits-Signal vorliegt (`:172-173`) = honest-0 in-vivo.

Das ist der **empirische, messgetriebene Autotuning-Kreislauf** (measure→profile→config→filter,
`03_messsystem_prtart.tex:581-588`), in der Linie von OpenTuner/FFTW/ATLAS/OtterTune. Für die *compile-time*-Achsen
(honest-0) ist die Heuristik keine RC-Feld-Kurve, sondern eine **Binary-Auswahl-Kurve** (welche der E2/E3-Binaries
gewinnt je Lastprofil) — das ist die vorgesehene ML-Klassifikation nach der Persist-Phase
(`06_evaluation_methodology.tex:151-180`, Ausblick).

---

## 1. Übersichtstabelle — Achse → Min/Max-Größe → Parameter-Art → Last-Abhängigkeit

Legende Parameter-Art: **RC✅** = echter, verdrahteter Laufzeit-Knopf · **RC⚠** = RC-Feld deklariert, Setter
fehlt (#221-Phantom) · **CT** = compile-time (E2/E3), honest-0 auf RC-Kanal · **CT+asp** = compile-time, aber
mit konzeptuell laufzeit-tunbarem Aspekt (Kapazität/Schwelle), heute compile-time-Permutations-Aspekt.

| T | Achse | Optimierungs-Eigenschaft (Min/Max messbare Größe) | Haupt-Mess-Kat. | Parameter-Art | Optimum hängt ab von |
|---|---|---|---|---|---|
| T0 | search_algo | **MIN** Lookup-Latenz = MIN (Baumhöhe × Cache-Lines/Knoten + Vergleiche); **MIN** Branch-Miss (SIMD/branch-free) | LAT, THR, CM, BM, IPC | CT (Binary-Wahl) | Key-Typ (String↔Int), Op-Mix (Point↔Scan), Skew, Füllstand |
| T1 | cache_traversal | **MIN** Cache-Misses/Memory-Transfers je Traversal (→ O(log_B N), cache-oblivious); **MAX** CLU | CM, CLU, dTLB, LAT | **RC⚠** `batch_size` | scan_share, Working-Set vs. Cache-Größe (Füllstand) |
| T2 | mapping | **MIN** Indirektions-Cache-Misses je Auflösung (Hash-Redirect: O(logN)→O(1); Permuter: MAX CLU + atomarer Reorder) | CM, CLU, LAT, BM | CT | Key-Länge L, Insert-Anteil, Dichte |
| T3 | path_compression | **MAX** Kompressionsrate (Single-Child-Kollaps) ∧ **MIN** Baumhöhe → **MIN** MEM ∧ CM | MEM, CM, LAT, CLU | CT (Binary-Wahl) | Präfix-Sharing der Keys (Verteilung!), Füllstand |
| T4 | node_type | **MIN** Knoten-Speicher-Verschnitt (adaptiv ~52 B/Key) ∧ **MAX** Fanout/CLU | MEM, CLU, CM, LAT | CT | Fanout-Verteilung (skewed↔uniform), Füllstand |
| T5 | memory_layout | **MAX** Cache-Line-Auslastung / **MIN** CM je Knotenzugriff (CSB⁺: Pointer-Elim; LOUDS: MIN MEM) | CLU, CM, MEM, dTLB | CT (5 RepresentationKind) | Op-Mix (Scan/SIMD↔Point), Füllstand, Speicherbudget |
| T6 | allocator | **MAX** Alloc-Durchsatz/Multicore-Skalierung ∧ **MIN** Fragmentierung/MEM ∧ **MIN** p99-Latenz | THR, LAT(p99), MEM, EN | **RC⚠** `pool_budget_bytes` | Thread-Zahl, Alloc-Rate (Insert/RMW), Laufzeit-Dauer |
| T7 | prefetch | **MIN** effektive Memory-Latenz (Miss-Latenz verdecken) / **MAX** MLP/IPC | LAT, CM, IPC, EN | **RC✅** `prefetch_distance` (+MSR hw_pf) | scan_share (Distanz↑), Memory-Latenz (HBM↔DDR), Knotengröße |
| T8 | concurrency | **MAX** Multicore-Durchsatz/Skalierung ∧ **MIN** Kohärenz-Traffic/Contention | THR, LAT(tail), CM/CLU | **RC⚠** `thread_count` | Read/Write-Ratio, Thread-Zahl, Contention |
| T9 | serialization | **MAX** Kompressionsrate / **MIN** serialisierte Größe (succinct: ~10 bit/Knoten) vs. **MIN** Decode-Latenz | MEM, LAT, THR | CT | Read/Write-Ratio, Datenverteilung, Persistenz-Bedarf |
| T10 | telemetry | **MIN** Observer-Perturbation = MIN durch Messung *zugefügte* Kohärenz-Invalidierungen (False-Sharing) | CM/CLU, THR/LAT, IPC | CT | Write-/Insert-Rate, Thread-Zahl (Contention) |
| T11 | value_handle | **MIN** Wert-Indirektion (Inline) vs. **MAX** Knoten-Dichte/CLU (External); Optimum = Schwelle auf Wertgröße | CM, CLU, MEM, LAT | **RC⚠** `inline_threshold_bytes` | Wertgrößen-Verteilung, Page-Dichte (Füllstand) — **H3** |
| T12 | isa | **MAX** Daten-Parallelität/Instr. (breitere SIMD) → **MAX** IPC / **MIN** Instr./Lookup ∧ **MIN** BM | IPC, THR, BM, EN | **CT** (per Thesis „Compile-Time-Achse") | Vergleichs-Last (Scan/SIMD-Suche), Energie-Budget (AVX-512-Throttle) |
| T13 | index_organization | Scan: **MAX** Storage-Order-Lokalität (clustered); Point+Sekundär: **MIN** Redundanz (non-clustered) | CM/CLU, LAT, THR, MEM | CT | Scan-Anteil (YCSB-E), Insert-Anteil, #Sekundärindizes |
| T14 | io_dispatch | **MAX** I/O-Durchsatz + Kontrolle (async/evict) ∧ **MIN** Page-Fault/TLB-Shootdown-Overhead (mmap-Antipattern) | LAT, THR, dTLB, CM | CT | Füllstand vs. RAM (nur out-of-core aktiv), Scan-Anteil |
| T15 | migration_policy | **MIN** durchschn. tier-gewichtete Latenz = MIN Cold-Tier-Zugriffe je Speicherbudget (adaptiv: MIN Eviction-Regret) | LAT, CM, MEM, THR, EN | CT+Verhalten (Laufzeit-Entscheidung, keine RC) | Skew (Zipf!), Füllstand vs. Fast-Tier-Budget |
| T16 | filter | **MIN** False-Positive-Rate/Bit = MIN bits/Key @ Ziel-FPR ∧ **MIN** Probe-Memory-Zugriffe (Xor=3, Cuckoo=2) | MEM, CM, LAT, THR | CT (+bits/Key-Config) | Negativ-Anteil (neg%!), Range vs. Point, Static↔Delete |
| T17 | queuing_q1 | **MAX** Puffer-Durchsatz/Batching ∧ **MIN** Puffer-MEM/Drain-Latenz; lock-free: **MAX** Producer/Consumer-Parallelität | THR, LAT, MEM, CLU | CT+asp (Kapazität = compile-time-Aspekt) | Write-/Burst-Anteil, Nebenläufigkeit, Arrival-Rate |
| T18 | queuing_q2 | Pareto: **MIN** Write-Amplification/MAX Batching (lazy) ⊻ **MIN** Staleness/Tail-Latenz (eager) | THR, LAT, MEM, EN | CT+asp (Threshold = compile-time-Aspekt) | Read/Write-Ratio, Freshness-Bedarf, Burst |

---

## 2. Achsen-Einzelbefunde (mit Quellen)

### T0 — search_algo (Such-Paradigma)
**(1) Optimierung.** MIN Lookup-Latenz, operationalisiert als MIN (Baumhöhe × durchquerte Cache-Lines pro Knoten
+ Schlüsselvergleiche); für SIMD/branch-free Varianten zusätzlich MIN Branch-Misses. Äquivalent MAX Durchsatz.
Kern-Leitgröße der Thesis: nicht asymptotische Komplexität, sondern Cache-Line-Verhalten unter Last
(`03_messsystem_prtart.tex:17-20`).
**(2) Messbar.** LAT/THR primär; CM, BM, IPC als Mechanismus; CLU. Über den Micro-Bench isoliert (jeder
Suchbestandteil gegen das Kategorie-Interface, `06_evaluation_methodology.tex:26-37`).
**(3) Parameter.** **CT** — die Algorithmus-Identität ist eine E2/E3-Binary-Wahl; ein Laufzeit-„switch algorithm"
verstieße gegen die No-Runtime-Switch-Doktrin. honest-0 auf RC.
**(4) Abhängigkeit.** Tries (ART/HOT) gewinnen bei String-Keys mit Präfix-Sharing; Hash bei Point-only ohne Range
(YCSB-C); B⁺/CSB⁺ bei Range-Scan (YCSB-E); Interpolationssuche bei uniform-dichten Keys; Eytzinger bei großen
statischen sortierten Arrays. Wormhole garantiert O(log L) worst-case. Füllstand: Baumhöhe (→ CM) wächst mit N,
Hash bleibt ~O(1) ohne Range.
**(5) Quellen.**
- Leis et al., *The Adaptive Radix Tree (ART)*, ICDE 2013 — <https://db.in.tum.de/~leis/papers/ART.pdf>
- Wu, Ni, Jiang, *Wormhole: A Fast Ordered Index*, EuroSys 2019 (O(log L)) — <https://ranger.uta.edu/~sjiang/pubs/papers/wu19-wormhole.pdf>
- Schlegel, Gemulla, Lehner, *k-Ary Search on Modern Processors*, DaMoN 2009 — <https://event.cwi.nl/damon2009/DaMoN09-KarySearch.pdf>
- Khuong, Morin, *Array Layouts for Comparison-Based Searching*, ACM JEA 2017 — <https://arxiv.org/pdf/1509.05053>

### T1 — cache_traversal (Cache-Sicht getrennt von Algorithmus-Sicht) — **RC⚠ batch_size**
**(1) Optimierung.** MIN Cache-Misses/Memory-Transfers pro Traversal = MIN Anzahl durchquerter Cache-Lines/Blocks;
cache-oblivious erreicht asymptotisch optimale O(log_B N) Transfers **ohne** B zu kennen; MAX Cache-Line-Auslastung.
**(2) Messbar.** CM (L1/L2/L3) primär, CLU, dTLB, LAT.
**(3) Parameter.** **RC⚠** `batch_size` (Working-Set-Größe, Cap 4096) — deklariert, Setter fehlt (#221-Phantom).
Stride/Traversal-Muster sonst compile-time.
**(4) Abhängigkeit.** Scan-heavy (YCSB-E) profitiert von großem Working-Set/Stride (sequentielles Leaf-Prefetch);
point-heavy (YCSB-C) von minimalem Stride. Cache-oblivious gewinnt über **alle** Cache-Ebenen, sobald der
Working-Set eine Cache-Ebene überschreitet (füllstand-abhängig). Genau die `batch_size`-Kurve in
`cacheline_policy_selector.hpp:154-164`.
**(5) Quellen.**
- Chen, Gibbons, Mowry, *Improving Index Performance through Prefetching*, SIGMOD 2001 — <https://www.cs.cmu.edu/~chensm/papers/fpbtree.pdf> (fpB⁺, Nachfolgearbeit)
- Bender, Demaine, Farach-Colton, *Cache-Oblivious B-Trees*, FOCS 2000 / SICOMP — <https://erikdemaine.org/papers/CacheObliviousBTrees_SICOMP/paper.pdf>
- Frigo, Leiserson, Prokop, Ramachandran, *Cache-Oblivious Algorithms*, FOCS 1999.
> ⚠️ **Attributions-Warnung:** T1 überlappt konzeptuell mit T5 (Layout) und T7 (Prefetch) — die Thesis flaggt das
> selbst (`04_concept_architecture.tex:70-73`). Die *isolierte* Messbarkeit von T1 ist genuin schwer; siehe §4.

### T2 — mapping (logisch→physisch)
**(1) Optimierung.** MIN Indirektionskosten/Pointer-Chase-Cache-Misses pro Mapping-Auflösung. Hash-Redirect
reduziert O(log N)-Deszendenz auf ~O(1) (MIN Vergleiche für lange Keys); Permutations-Index (Masstree-„Permuter")
MAX Cache-Line-Auslastung + ermöglicht atomaren In-Place-Reorder (MIN Write-Cache-Line-Invalidierungen).
**(2) Messbar.** CM, CLU, LAT, THR; BM für den Permuter.
**(3) Parameter.** **CT** (Direct vs. Pool-Relative Mapping = E2). honest-0 auf RC.
**(4) Abhängigkeit.** Hash-Redirect gewinnt bei sehr langen Keys / tiefen Tries (großes L), Point-Queries.
Permutations-Index hilft insert-heavy (YCSB-A: sortierte Ordnung ohne physischen Move). Direct 1:1 am einfachsten,
best für klein/dicht.
**(5) Quellen.**
- Wu, Ni, Jiang, *Wormhole*, EuroSys 2019 (Hash-Redirect auf Trie) — <https://ranger.uta.edu/~sjiang/pubs/papers/wu19-wormhole.pdf>
- Mao, Kohler, Morris, *Cache Craftiness for Fast Multicore Key-Value Storage (Masstree)*, EuroSys 2012 (Permuter) — <https://dl.acm.org/doi/10.1145/2168836.2168855>
> ⚠️ **Dünn besetzt** — die Thesis nennt T2 selbst eine „dünn besetzte Achse" (`03_messsystem_prtart.tex:142-144`).
> **Braucht tiefere Einzel-Recherche** (siehe §4): Ist Mapping wirklich eine *separabel messbare* Achse oder ein
> Sub-Aspekt von T0/T11?

### T3 — path_compression (Pfadkompression)
**(1) Optimierung.** Dual: MAX Kompressionsrate (Single-Child-Ketten kollabieren) ∧ MIN Baumhöhe/Pointer-Indirektionen
→ MIN Speicher-Fußabdruck ∧ MIN Cache-Misses. Trade-off: Kompressions-Granularität vs. Decode-Kosten.
**(2) Messbar.** MEM (Fußabdruck) primär, CM, LAT, CLU.
**(3) Parameter.** **CT** (Kompressions-Granularität byte/Patricia/Macro/Multi-Byte = E2). honest-0 auf RC.
**(4) Abhängigkeit.** Hoher Nutzen bei Keys mit langen gemeinsamen Präfixen (Datensätze `url`, `xml`), spärlichem
Key-Raum; ~null Nutzen bei dicht-uniformen Integer-Keys (nichts zu komprimieren). **Verteilungs-getrieben.**
**(5) Quellen.**
- Leis et al., *ART*, ICDE 2013 (Path Compression + Lazy Expansion, ~52 B/Key gebounded) — <https://db.in.tum.de/~leis/papers/ART.pdf>
- Binna et al., *HOT: Height Optimized Trie*, SIGMOD 2018 (dynamische Bit-Span, minimale Höhe) — <https://15721.courses.cs.cmu.edu/spring2019/papers/08-oltpindexes2/p521-binna.pdf>
- Boffa, Ferragina et al., *CoCo-trie* (Compressed Collapsed Macro-Node) — Boffa 2024 (Thesis-Ref P04).

### T4 — node_type (adaptive Knotenklasse)
**(1) Optimierung.** MIN Knoten-Speicher-Verschnitt (adaptive Größe an tatsächlichen Fanout, ART: Node4/16/48/256)
∧ MAX Fanout/Cache-Line-Auslastung → MIN MEM + MIN CM. ART bounded auf ~52 B/Key worst-case.
**(2) Messbar.** MEM, CLU, CM, LAT.
**(3) Parameter.** **CT** Knotenklassen-Set (E2); das adaptive Umschalten ist datengetriebenes Struktur-internes
Laufzeit-Verhalten, aber **kein RC-Knopf**. honest-0 auf RC.
**(4) Abhängigkeit.** Adaptive Knoten gewinnen bei schiefer/variabler Fanout-Verteilung (Mix dichter/spärlicher
Subtrees — String-Daten); feste Knoten OK bei uniform-dicht. Die Knotentyp-Verteilung verschiebt sich mit N und
Key-Verteilung (Thesis-Hypothese **H1** Page-Type-Kosten, `06_evaluation_methodology.tex:53-55`).
**(5) Quellen.**
- Leis et al., *ART*, ICDE 2013 — <https://db.in.tum.de/~leis/papers/ART.pdf>
- Rao, Ross, *Making B⁺-Trees Cache Conscious (CSB⁺)*, SIGMOD 2000 (Knotengröße-Effekt) — <https://www.cs.duke.edu/courses/spring03/cps216/papers/rao-ross-2000.pdf>
- Binna et al., *HOT*, SIGMOD 2018 (SIMD-/Compound-Knoten) — <https://15721.courses.cs.cmu.edu/spring2019/papers/08-oltpindexes2/p521-binna.pdf>

### T5 — memory_layout (Speicher-Layout, 5 RepresentationKind)
**(1) Optimierung.** MAX Cache-Line-Auslastung / MIN Cache-Misses je Knotenzugriff. CSB⁺ eliminiert Kind-Pointer
(nur erster Kind-Offset) → höherer Fanout pro Cache-Line; LOUDS/succinct MIN Speicher-Fußabdruck. Trade-off Space
vs. Zugriffsgeschwindigkeit.
**(2) Messbar.** CLU primär, CM, MEM, dTLB, LAT.
**(3) Parameter.** **CT** Layout-Wahl (E2, `RepresentationKind`: 5 reale Repräsentationen,
`axis_05_memory_layout_strategy_base.hpp:18-24`, autoritativ konsumiert von `LayoutAwareChunkedStore<N,L,A>`,
LEDGER Z.516). **honest-0 auf RC** *heute* — die dokumentierte IMC-Runtime-Heuristik (NUMA-Channel-Interleave,
`ce docs/architecture/16_axis_05_imc_runtime_heuristik.md`) wäre ein künftiger Laufzeit-Knopf, ist aber **nicht
gebaut** (Doku-only Sprint).
**(4) Abhängigkeit.** SoA/AoSoA gewinnen bei Scan/SIMD (YCSB-E); AoS-aligned bei Point-Lookup; LOUDS bei
speicherbeschränkt/static-read-only; CSB⁺ bei update-leicht + Range. Füllstand-abhängig (sobald Struktur > Cache).
**(5) Quellen.**
- Rao, Ross, *Cache Conscious Indexing (CSS-Tree)*, VLDB 1999 & *CSB⁺*, SIGMOD 2000 — <https://www.cs.duke.edu/courses/spring03/cps216/papers/rao-ross-2000.pdf>
- Jacobson, *Space-efficient Static Trees and Graphs (LOUDS)*, FOCS 1989 (Thesis-Ref P, succinct).
- Zhang et al., *SuRF/FST*, SIGMOD 2018 (LOUDS-DS, 10 bit/Knoten) — <https://www.pdl.cmu.edu/PDL-FTP/Storage/surf_sigmod18.pdf>

### T6 — allocator (Allokation + Reklamation, 7 Sub-Familien) — **RC⚠ pool_budget_bytes**
**(1) Optimierung.** MAX Alloc-Durchsatz/Multicore-Skalierung ∧ MIN Fragmentierung/Speicher-Fußabdruck ∧ MIN
Alloc-Latenz (bes. p99/Tail). Trade-off Durchsatz vs. steady-state RSS. Reklamations-Sub-Achse: MIN Reklamations-Stall
/ MAX Reklamations-Sicherheit.
**(2) Messbar.** THR, LAT (p99), MEM, EN; CM/CLU sekundär (Allokations-Lokalität). Die S7-Serie (#261) hat die
per-Familie T6-Allokator-DEG **echt instrumentierbar** gemacht (10/10 Pool-Familien, alloc_cnt/bytes_alloc/
bytes_in_use), statt honest-0 (LEDGER Z.222).
**(3) Parameter.** **RC⚠** `pool_budget_bytes` (Cap 1 GiB) — deklariert, Setter fehlt (#221-Phantom). Allokator-
Identität selbst compile-time. Nur `pool_budget_bytes` ist der legitime Runtime-Kanal (LEDGER Z.534).
**(4) Abhängigkeit.** mimalloc/snmalloc/tcmalloc gewinnen bei high-thread alloc-heavy (YCSB-A Insert/Update, LP12
RMW); jemalloc bei Langläufer-Fragmentierungsresistenz; single-thread read-only (YCSB-C) stresst den Allokator kaum.
Die Thesis weist je Allokator-Profil ein `expected_workload` zu (`03_messsystem_prtart.tex:165-187` Tab.).
**(5) Quellen.**
- Berger et al., *Hoard*, ASPLOS 2000 (skalierbare Multicore-Allokation).
- Leijen et al., *mimalloc* (Microsoft Research) / Evans *jemalloc* / Google *TCMalloc* — Benchmark-Vergleich <https://arxiv.org/pdf/1503.09006> (scalloc, low-fragmentation) und mimalloc-bench.
- McKenney, *RCU*, 2001 (Thesis-Ref P29) / Michael, *Hazard Pointers*, IEEE TPDS 2004 (Reklamation).

### T7 — prefetch (Prefetching) — **RC✅ prefetch_distance (DER verdrahtete Runtime-Knopf)**
**(1) Optimierung.** MIN effektive Memory-Zugriffslatenz durch Verdecken der Cache-Miss-Latenz (Misses überlappen);
MAX Memory-Level-Parallelism (MLP) / IPC. Trade-off: zu tiefes Prefetch verschmutzt Cache / verschwendet Bandbreite.
**(2) Messbar.** LAT primär, CM (Misses→Hits/überlappt), IPC, EN (Bandbreite), CLU.
**(3) Parameter.** **RC✅** `prefetch_distance` — **vollständig verdrahtet + literal verifiziert** (`abi_adapter.hpp:238-242`,
`set_runtime_distance()` am realen Store-`_mm_prefetch`; `default=4 / rc=2→2 / rc=9→9`, LEDGER Z.191). #221 für
prefetch **geschlossen**. Zusätzlich `hw_prefetcher` via MSR `0x1A4` (architektonische Laufzeit-Ausnahme). **Die
einzige Achse mit fertigem, messbarem Laufzeit-Knopf.**
**(4) Abhängigkeit.** Optimale Distanz **monoton mit scan_share** (scan-heavy YCSB-E → tief ~16 CL; point-heavy
YCSB-C → flach ~2 CL — exakt die Heuristik in `cacheline_policy_selector.hpp:149-152`). Abhängig von Memory-Latenz
(HBM↔DDR), Knotengröße, Füllstand.
**(5) Quellen.**
- Chen, Gibbons, Mowry, *Improving Index Performance through Prefetching (pB⁺-Trees)*, SIGMOD 2001 — <https://www.cs.cmu.edu/~chensm/papers/fpbtree.pdf>
- Khan et al., *adaptive prefetch*, 2010 (Distance-Estimator, Thesis-Ref P23).
- Mahling et al., *Fetch Me If You Can (High-Latency-Memory-Prefetching)*, DaMoN 2025 — <https://hpi.de/oldsite/fileadmin/user_upload/fachgebiete/rabl/publications/2025/Mahling-DaMoN25-Prefetching.pdf>

### T8 — concurrency (Pattern ⊥ Reklamation) — **RC⚠ thread_count**
**(1) Optimierung.** MAX Multicore-Durchsatz/Skalierung (ops/s über Thread-Zahl) ∧ MIN Synchronisations-Overhead/
Contention (Cache-Line-Ping-Pong der Lock-Cachelines). Für read-heavy: OLC MAX Read-Skalierung. Trade-off:
Read-Skalierbarkeit vs. Mixed-Workload-Robustheit (OLC kollabiert unter mixed read-update).
**(2) Messbar.** THR (Skalierung primär), LAT (Tail unter Contention), CM/CLU (Kohärenz-Traffic), EN.
**(3) Parameter.** **RC⚠** `thread_count` (Cap 64) — deklariert, Setter fehlt (#221-Phantom), aber `thread_count`
ist die For-Schleifen-Dimension des `DynamicVariableNode`. Sync-Pattern selbst compile-time (No-Runtime-Switch).
**(4) Abhängigkeit.** OLC gewinnt read-heavy/read-only (YCSB-B/C, LP13 concurrent-read-scaling); lock-free/Hazard
bei high-contention writes; seriell best single-thread (kein Overhead). Skaliert mit Thread-Zahl (RC-Dimension) und
Read/Write-Ratio.
**(5) Quellen.**
- Leis, Scheibner, Kemper, Neumann, *The ART of Practical Synchronization (Optimistic Lock Coupling)*, DaMoN 2016 — <https://db.in.tum.de/~leis/papers/artsync.pdf>
- McKenney, *RCU*, 2001 (Thesis-Ref P29) · Michael, *Hazard Pointers*, IEEE TPDS 2004 (Thesis-Ref P30).
- Michael, Scott, *lock-free/wait-free queues*, PODC 1996 (Thesis-Ref).

### T9 — serialization (Kodierung/Kompression)
**(1) Optimierung.** MAX Kompressionsrate / MIN serialisierte Größe (Bytes) vs. MIN Encode/Decode-Latenz. Succinct:
MIN bits/Knoten (FST 10 bit/Knoten). Trade-off Space vs. Speed.
**(2) Messbar.** MEM (serialisierter Fußabdruck), LAT (Encode/Decode), THR; CM.
**(3) Parameter.** **CT** Kodierungs-/Kompressions-Wahl (E2). honest-0 auf RC.
**(4) Abhängigkeit.** Succinct/Varint gewinnen bei speicherbeschränkt + read-mostly static (YCSB-C); Raw-Binary bei
write/mutate-heavy (schnell in-place). LZ77 für kalte/Archiv-Tiers. Verteilung: schiefe Daten komprimieren besser.
**(5) Quellen.**
- Zhang et al., *SuRF/FST*, SIGMOD 2018 (succinct, 10 bit/Knoten) — <https://www.pdl.cmu.edu/PDL-FTP/Storage/surf_sigmod18.pdf>
- Jacobson, *LOUDS*, FOCS 1989 · Leis et al., *ART*, ICDE 2013 (Varint-Kodierung) — <https://db.in.tum.de/~leis/papers/ART.pdf>

### T10 — telemetry (Mess-Instrumentierung selbst)
**(1) Optimierung.** MIN Observer-Overhead/Kohärenz-Traffic, den **die Messung selbst** einführt (False Sharing /
Cache-Line-Ping-Pong) = MIN Perturbation der gemessenen Größe (MIN zugefügte Cache-Misses/Kohärenz-Invalidierungen).
Leaf-Only-Telemetrie minimiert Shared-Counter-Contention; der Zähler in **allen** Knoten gilt als Anti-Pattern
(`03_messsystem_prtart.tex:198-200`).
**(2) Messbar.** CM/CLU (Kohärenz, False Sharing), THR/LAT (Overhead), IPC.
**(3) Parameter.** **CT** (`COMDARE_MEASUREMENT_ON`; Observer-Platzierung). Sampling-Rate wäre laufzeit-tunbar, ist
heute compile-time. honest-0 auf RC.
**(4) Abhängigkeit.** Overhead skaliert mit Write-/Insert-Rate + Thread-Zahl (mehr Counter-Updates → mehr False
Sharing unter YCSB-A/concurrent). All-Node-Counter pathologisch unter concurrent writes (LP12/LP13).
**(5) Quellen.**
- Kuehn, *B⁺-Tree Leaf-Only-Counter*, 2023 (Thesis-Ref P28, kohärenz-schonend).
- Tene, *HdrHistogram* (Tail-Latenz-Erhebung, Thesis-Ref).
- False-Sharing-Kanon: Bolosky & Scott, *False Sharing and its Effect on Shared Memory Performance*, USENIX SEDMS 1993 (peer-reviewed Grundlage).
> ⚠️ **Meta-Achse** — T10 optimiert *Messmethodik*, nicht die Datenstruktur. Andere Kategorie als T0–T9; siehe §4.

### T11 — value_handle (Wert-Platzierung/Ownership/Versionierung) — **RC⚠ inline_threshold_bytes**
**(1) Optimierung.** MIN Wert-Zugriffs-Indirektion (Inline vermeidet einen Pointer-Chase-Cache-Miss) vs. MIN
Knoten-Bloat (External-Pool hält Knoten dicht → bessere CLU beim Key-Scan). Trade-off: Inline-Lokalität vs.
Knoten-Dichte. **Optimum = Schwelle auf Wertgröße.**
**(2) Messbar.** CM, CLU, MEM, LAT.
**(3) Parameter.** **RC⚠** `inline_threshold_bytes` (Cap 256 B) — deklariert, Setter fehlt (#221-Phantom).
**(4) Abhängigkeit.** **Thesis-Hypothese H3** (`06_evaluation_methodology.tex:58-61`): dichte Pages bevorzugen
Inline, spärliche External, PRT-ART-Heuristiken ChainRef. Kleine Werte (< Schwelle) → Inline; große → External.
Abhängig von Wertgrößen-Verteilung + Page-Dichte (Füllstand). Heuristik-Kurve `cacheline_policy_selector.hpp:169-170`
(write-heavy→64 B, read→16 B).
**(5) Quellen.**
- Leis et al., *ART*, ICDE 2013 (Inline- vs. External-Leaves) — <https://db.in.tum.de/~leis/papers/ART.pdf>
- Mao et al., *Masstree*, EuroSys 2012 (versionierter Pointer) — <https://dl.acm.org/doi/10.1145/2168836.2168855>
- McKenney, *RCU*, 2001 (immutable Shared-Ref).

### T12 — isa (Ziel-ISA + SIMD) — **CT, kanonische Compile-Time-Achse**
**(1) Optimierung.** MAX Daten-Parallelität pro Instruktion (breitere SIMD → mehr Vergleiche/Cache-Line pro Zyklus)
→ MAX IPC / MIN Instruktionen pro Lookup; MIN Branch-Misses (SIMD-Compare = branch-free). Trade-off: breitere SIMD
kann heruntertakten (AVX-512-Frequenz-Throttle → EN/THR).
**(2) Messbar.** IPC primär, THR, BM, EN (Frequenz/Power), LAT.
**(3) Parameter.** **CT** — die Thesis nennt sie explizit „Ziel-ISA als **Compile-Time-Achse**"
(`03_messsystem_prtart.tex:80`). Build-Achse. **Die kanonische honest-0-Achse** (per Design kein RC).
Platform-gated (`IPlatformProbe` meldet lauffähige ISA-Teilmenge, `06_evaluation_methodology.tex:104-113`).
**(4) Abhängigkeit.** SIMD-Nutzen am größten bei scan-/vergleichs-heavy (YCSB-E, k-ary/Eytzinger-Suche);
AVX-512-Energie-Trade-off relevant für sustained throughput.
**(5) Quellen.**
- Schlegel et al., *k-Ary Search (SIMD)*, DaMoN 2009 — <https://event.cwi.nl/damon2009/DaMoN09-KarySearch.pdf>
- Binna et al., *HOT* (SIMD-Knoten), SIGMOD 2018 — <https://15721.courses.cs.cmu.edu/spring2019/papers/08-oltpindexes2/p521-binna.pdf>
- Ungethüm et al., *Hardware-Conscious DB Survey*, 2017 (Thesis-Ref P31) · Schmidt et al., *HBM/AVX-512-Stride*, 2025 (Thesis-Ref P32).

### T13 — index_organization (Storage-Order)
**(1) Optimierung.** Für Scan/Range: MAX Storage-Order-Lokalität (clustered/IOT = sequentieller Scan minimiert
Cache-/Page-Misses); für Point + Sekundärzugriff: MIN Redundanz (non-clustered vermeidet Datenduplikation).
Trade-off: Scan-Lokalität vs. Update/Insert-Kosten + Sekundärindex-Pflege.
**(2) Messbar.** CM/CLU (Scan-Lokalität), LAT, THR, MEM.
**(3) Parameter.** **CT** Storage-Order (E2). honest-0 auf RC.
**(4) Abhängigkeit.** Clustered/IOT gewinnt Range-Scan (YCSB-E, LP08); non-clustered/Heap gewinnt insert-heavy +
Multi-Sekundärindex (YCSB-A writes). Sortierte vs. unsortierte Key-Ingestion (`tpcds-id`-Datensatz).
**(5) Quellen.**
- Bayer, McCreight, *Organization and Maintenance of Large Ordered Indexes (B-Tree)*, Acta Informatica 1972.
- Comer, *The Ubiquitous B-Tree*, ACM Computing Surveys 1979.
> ⚠️ Die IOT-Instanz stützt sich in der Thesis auf Oracle-Doku (nicht peer-reviewed). **Braucht stärkere
> akademische Zitat-Basis** für den clustered/non-clustered-Trade-off (siehe §4; z. B. Graefe, *Modern B-Tree
> Techniques*, FnT Databases 2011).

### T14 — io_dispatch (Persistenz-Ein-/Ausgabe)
**(1) Optimierung.** MAX I/O-Durchsatz + Kontrolle (async, Prefetch, Eviction) ∧ MIN Page-Fault/TLB-Shootdown-
Overhead und Vermeidung von Korrektheits-Hazards. Direct-IO/Buffered geben dem DBMS Kontrolle; mmap verliert async
+ verursacht TLB-Shootdowns → die Thesis-„Antithese" (mmap als Anti-Pattern). MIN I/O-Stall.
**(2) Messbar.** LAT, THR, dTLB (TLB-Shootdowns bei mmap!), CM, EN.
**(3) Parameter.** **CT** Dispatch-Wahl (E2), von der Suchstruktur entkoppelt. honest-0 auf RC. **Für einen reinen
In-Memory-Tier ist diese Achse weitgehend N/A / Durchreiche** (nur out-of-core aktiv).
**(4) Abhängigkeit.** Nur relevant, wenn Daten RAM überschreiten (out-of-core / Migrations-Tiers); scan-heavy leidet
am meisten unter mmaps fehlendem async-Prefetch (Crotty-Resultat). Weitgehend füllstand-abhängig.
**(5) Quellen.**
- Crotty, Leis, Pavlo, *Are You Sure You Want to Use MMAP in Your DBMS?*, CIDR 2022 — <https://db.cs.cmu.edu/papers/2022/cidr2022-p13-crotty.pdf>
- Stonebraker, *Operating System Support for Database Management*, CACM 1981 (Thesis-Ref P).

### T15 — migration_policy (Tiering/Anti-Caching)
**(1) Optimierung.** MIN durchschnittliche tier-gewichtete Zugriffslatenz = MIN Cold-Tier-Zugriffe (Miss-Rate) je
gegebenem Speicherbudget; adaptiv (LeCaR) MIN Eviction-Regret. Trade-off: Migrations-Overhead vs. Hit-Rate-Gewinn.
**(2) Messbar.** LAT (tier-gewichtet), CM (Tier-Miss-Analog), MEM (Budget), THR, EN.
**(3) Parameter.** Die Migrations-*Entscheidungen* sind inhärent Laufzeit/datengetrieben (Hot/Cold-Tracking läuft
zur Laufzeit), aber die Policy-*Selektion* ist compile-time (E2). **Kein RC-POD-Feld** → honest-0 auf RC-Kanal,
obgleich es die „laufzeit-adaptivste" der compile-time-gewählten Achsen ist (Nuance).
**(4) Abhängigkeit.** Nutzen skaliert mit Skew (zipfian YCSB-A/B → starkes Hot-Set → Migration gewinnt; uniform →
Migration nutzlos). Füllstand-kritisch: nur relevant, wenn Working-Set > Fast-Tier-Budget. LeCaR gewinnt bei
small-cache/adaptiven Regimes.
**(5) Quellen.**
- DeBrabant, Pavlo et al., *Anti-Caching*, VLDB 2013 — <https://www.vldb.org/pvldb/vol6/p1942-debrabant.pdf>
- Vietri et al., *LeCaR: Learning Cache Replacement*, USENIX HotStorage 2018.
- Leis et al., *LeanStore*, ICDE 2018 (Pointer-Swizzling-Tiering) — <https://db.in.tum.de/~leis/papers/leanstore.pdf>
> ⚠️ LeCaR ist ein Workshop-Paper (HotStorage). Für tier-Migration in-memory weitgehend inaktiv (füllstand-gated).
> **Braucht tiefere Recherche** wenn out-of-core-Tiers gemessen werden sollen (siehe §4).

### T16 — filter (Approximate Membership)
**(1) Optimierung.** MIN False-Positive-Rate pro Bit (MAX Space-Effizienz = MIN bits/Key bei Ziel-FPR) ∧ MIN
Filter-Probe-Memory-Zugriffe (Xor = 3 parallele Zugriffe, Cuckoo = 2). Trade-off: FPR vs. Space vs. supports
Range/Delete.
**(2) Messbar.** MEM (bits/Key), CM (Probe-Zugriffe), LAT, THR; der Filter senkt downstream die Negativ-Lookup-CM.
**(3) Parameter.** **CT** Filter-Typ + bits/Key-Konfiguration (E2). honest-0 auf RC.
**(4) Abhängigkeit.** Filter-Nutzen skaliert mit Negativ-Lookup-Anteil (**neg%** — LP06 negsweep, LP07 String-Korpus
50 % Miss); null Nutzen bei 0 % Negativen (all-positive read = LP04). SuRF für Range-Filterung (YCSB-E). Xor für
static read-only (build-once). Cuckoo wenn Deletes nötig.
**(5) Quellen.**
- Fan et al., *Cuckoo Filter: Practically Better Than Bloom*, CoNEXT 2014 — <https://www.cs.cmu.edu/~dga/papers/cuckoo-conext2014.pdf>
- Zhang et al., *SuRF*, SIGMOD 2018 (Range-Filter, 10 bit/Key) — <https://www.pdl.cmu.edu/PDL-FTP/Storage/surf_sigmod18.pdf>
- Graf, Lemire, *Xor Filters: Faster and Smaller Than Bloom and Cuckoo*, ACM JEA 2020 — <https://arxiv.org/pdf/1912.08258>
- Bloom, *Space/Time Trade-offs in Hash Coding with Allowable Errors*, CACM 1970.

### T17 — queuing_q1 (Buffer-Strategy)
**(1) Optimierung.** MAX Write-Buffer-Durchsatz/Batching-Effizienz (Write-Kosten amortisieren, Bursts absorbieren)
∧ MIN Puffer-MEM + Drain-Latenz; für concurrent: MAX Producer/Consumer-Parallelität (lock-free) / MIN Contention.
BoundedRing: cache-line-aligned Kapazität für Lokalität. Trade-off: Batching (THR) vs. Latenz + MEM.
**(2) Messbar.** THR (Write/Ingest), LAT (Drain/Tail), MEM (Puffergröße), CLU (Ring-Alignment), CM.
**(3) Parameter.** **CT+asp** — Kapazität (BoundedRing `iterable_aspect_t {8/64/1024/16384/65536}`,
`12_queuing_topic_achsen_eigenschaften.md:83`) ist **heute ein compile-time-Permutations-Aspekt**, kein RC-Feld.
Buffer-Strategie = compile-time. honest-0 auf RC; **Kandidat für einen künftigen Laufzeit-Knopf** (Kapazität).
**(4) Abhängigkeit.** Buffering gewinnt write/insert-heavy + bursty (YCSB-A, LP01/LP02 bulk-insert, LP12 RMW);
NoBuffer (Passthrough) best für read-only (YCSB-C). LSM-artig (AppendOnly/Delta/Tombstone) für write-optimiert.
Kapazität an Burst-Größe / Arrival-Rate getunt.
**(5) Quellen.**
- Thompson et al., *Disruptor* (lock-free Ring-Buffer), 2011 (Thesis-Ref).
- Levandoski et al., *The Bw-Tree* (Delta-Chain), ICDE 2013 (Thesis-Ref P).
- O'Neil et al., *The Log-Structured Merge-Tree (LSM)*, Acta Informatica 1996 · Michael/Scott 1996, Lamport SPSC (lock-free Queues).

### T18 — queuing_q2 (Flush-Policy)
**(1) Optimierung.** Pareto-Wahl der Flush-Zeitpunkte: MIN Write-Amplification / MAX Batching (lazy → weniger,
größere Flushes → höherer THR) **⊻** MIN Staleness/Tail-Latenz (eager → niedrigere Latenz, höhere Amplification).
Watermark = Schwelle auf fill/cap. Adaptive-EWMA MIN Flush-Entscheidungs-Regret. Also: MIN Write-Amplification XOR
MIN Latenz (ein tunbarer Pareto-Punkt).
**(2) Messbar.** THR (Write-Amplification, Batching), LAT (Staleness/Tail), MEM (Puffer-Fill), EN.
**(3) Parameter.** **CT+asp** — Watermark `threshold_pct {50/65/75/85/95}` und `window_ms` (Timed) sind heute
compile-time-Aspekte (`12_queuing_topic_achsen_eigenschaften.md:146,153`), kein RC. `AdaptiveLsmFlush` lernt zur
Laufzeit (datengetrieben), aber Policy-Selektion compile-time. honest-0 auf RC; **Kandidat für Laufzeit-Knopf**
(Schwelle).
**(4) Abhängigkeit.** Lazy/high-watermark gewinnt write-heavy-Durchsatz (YCSB-A, LP01); eager/low-watermark gewinnt
Read-after-Write-Freshness + niedrige Latenz (LP09/LP11 mixed); adaptiv best für wechselnde Workloads. Schwelle an
Read/Write-Ratio + Burst getunt.
**(5) Quellen.**
- O'Neil et al., *LSM-Tree*, Acta Informatica 1996 (Write-Amplification/Flush) — Grundlage.
- Dayan, Idreos, *Monkey / Dostoevsky* (LSM-Tuning, Merge-Policy-Trade-off), SIGMOD 2017/2018 — **empfohlene stärkere Zitat-Basis** (siehe §4).
- Levandoski et al., *Bw-Tree*, ICDE 2013. Die adaptive EWMA-Flush-Policy ist ein **Thesis-Eigenbeitrag** (nicht peer-reviewed).

---

## 3. Zusammenfassung Deliverable (3): Runtime-Knopf vs. honest-0

### 3.1 Echter Laufzeit-Knopf (RC / E1) — für #221
- ✅ **VERDRAHTET, messbar, #221-geschlossen:** **T7 prefetch** (`prefetch_distance`), + MSR-`hw_prefetcher`.
- ⚠️ **RC-Feld deklariert, Setter fehlt (Phantom, #221-Rest — die „4 übrigen RC-Achsen"):**
  **T8 concurrency** (`thread_count`, auch DynamicVariableNode-Schleifendimension),
  **T6 allocator** (`pool_budget_bytes`),
  **T1 cache_traversal** (`batch_size`/Working-Set),
  **T11 value_handle** (`inline_threshold_bytes`).

Das sind die **genus-invariant 5 steuerbaren Achsen** (`abi_adapter.hpp:208,220`). Die Heuristik-Kurve über
diese 5 ist bereits als GoF-Strategy prototypisiert (`cacheline_policy_selector.hpp`) und liefert die konkreten
Stützstellen für die Endauswertung (§0.3).

### 3.2 Ehrlich compile-time-only (honest-0 auf dem RC-Kanal) — 14 Achsen
**T0** search_algo · **T2** mapping · **T3** path_compression · **T4** node_type · **T5** memory_layout · **T9**
serialization · **T10** telemetry · **T12** isa · **T13** index_organization · **T14** io_dispatch · **T15**
migration_policy · **T16** filter · **T17** queuing_q1 · **T18** queuing_q2.

Untergruppen mit Nuancen:
- **Kanonisch compile-time (per Design):** T12 isa (Thesis nennt es explizit Compile-Time-Achse), T0/T3/T4/T5/T9/T13/T16.
- **Compile-time gewählt, aber laufzeit-*verhaltend*:** T15 migration (Entscheidungen laufen zur Laufzeit; nur die
  Policy-Wahl ist compile-time), T4 node_type (adaptives Umschalten datengetrieben).
- **Compile-time-Aspekt, konzeptuell laufzeit-tunbar (Kandidaten für künftige RC-Felder):** T17 queuing_q1
  (Kapazität), T18 queuing_q2 (Threshold), T5 memory_layout (IMC-NUMA-Interleave, dokumentiert aber ungebaut).

### 3.3 „honest-0" als Mess-Wahrheit (nicht Defekt)
Die Direktive verlangt ehrliche Lücken statt Fabrikation (LEDGER Z.568). Die S7-Serie (#261) hat die T6-Allokator-
DEG-Werte je der 10 Pool-Familien von honest-0 auf **echt** gehoben; das betrifft die *Observer*-Messbarkeit (nicht
den RC-Kanal). Für den RC-Kanal bleiben die 14 Achsen bewusst honest-0 — das ist die *korrekte* Metaprog-Grenze.

---

## 4. Offene Recherche-Lücken / Achsen, die tiefere Einzel-Recherche brauchen

| Achse | Lücke | Empfehlung |
|---|---|---|
| **T2 mapping** | Dünn besetzt; unklar, ob *separabel messbar* oder Sub-Aspekt von T0/T11. Optimierungsgröße am wenigsten scharf. | Einzel-Recherche: Ist „mapping" eine eigene messbare Achse? Ggf. als Interface-Verdrahtung (Direct/Pool-Relative) statt Mess-Achse framen. Belege: Masstree-Permuter, Wormhole-Meta-Trie. |
| **T1 cache_traversal** | Überlappt T5 (Layout) + T7 (Prefetch); die Thesis flaggt das selbst. Isolierte Attribution schwer. | Micro-Bench muss T1 gegen fixe T5/T7 isolieren; sonst ist die „T1-Differenz" ein Apparat-Artefakt (analog #188-Warnung). |
| **T10 telemetry** | Meta-Achse: optimiert Messmethodik, nicht die Datenstruktur — andere Kategorie. | Als „Mess-Overhead-Achse" separat behandeln; False-Sharing-Kanon (Bolosky/Scott 1993, Torrellas) als peer-reviewed Basis zitieren. |
| **T13 index_organization** | IOT-Beleg = Oracle-Doku (nicht peer-reviewed). | Graefe, *Modern B-Tree Techniques*, FnT Databases 2011 als akademische Basis für clustered/non-clustered-Trade-off. |
| **T14 io_dispatch** | Für reinen In-Memory-Tier weitgehend N/A (füllstand-gated). Crotty ist CIDR (peer-reviewed, aber vision-track). | Nur bei out-of-core-Messläufen vertiefen; LeanStore (ICDE 2018) als peer-reviewed Buffer-Management-Basis. |
| **T15 migration_policy** | LeCaR = Workshop (HotStorage). In-memory inaktiv. | Bei Tier-Messläufen: Anti-Caching (VLDB 2013, solide) + LeanStore als Kern; LeCaR nur als adaptive Referenz. |
| **T18 queuing_q2** | Adaptive-EWMA = Thesis-Eigenbeitrag; RocksDB/Kafka nicht peer-reviewed. | Dayan/Idreos *Monkey* (SIGMOD 2017) + *Dostoevsky* (SIGMOD 2018) als akademische LSM-Flush/Merge-Trade-off-Basis. |
| **T6 / T8 / T1 / T11 RC-Phantome** | 4 der 5 RC-Felder haben Cap, aber keinen Setter → „Phantom-Zeilen" bei #156. | #221-Rest: 4 Setter + apply1 verdrahten (Roadmap-Phase 2, `16_E1_E4_KONSOLIDIERUNG_DOSSIER.md:173`), bevor RC-Heuristik-Kurven über diese Achsen gemessen werden. |

### Ehrliche Rest-Unsicherheiten
- Die **Min/Max-Zuordnung** ist bei multi-objektiven Achsen (T6 Durchsatz *vs.* MEM; T18 Amplification *vs.* Latenz;
  T5 Space *vs.* Speed) **keine einzelne Größe**, sondern ein **Pareto-Punkt** — die Heuristik-Kurve wählt entlang
  einer Objective (vgl. `ScanOptimizing` vs. `LatencyOptimizing` in `cacheline_policy_selector.hpp:141-193`). Die
  Endauswertung sollte je Achse die *Objective* explizit machen, statt eine falsche Einzel-Extremal-Größe zu behaupten.
- Für die **compile-time-Achsen** ist „Optimierung" keine RC-Feld-Kurve, sondern eine **Binary-Auswahl** (welche
  E2/E3-Permutation gewinnt je Lastprofil) — das ist die vorgesehene, **noch nicht implementierte** ML-Klassifikation
  (`06_evaluation_methodology.tex:151-180`). Die „statische Heuristik-Kurve" existiert für diese Achsen erst nach
  dem Voll-Messlauf (#156/#162, HELD).

---

*Erstellt 2026-07-09. Nicht committet (per Auftrag). Web-Belege abgerufen 2026-07-09; alle datei:zeile-Belege gegen
den lokalen Klon-Stand super `probst-diplomarbeit-cache-engine` / ce `Code/external/comdare-cache-engine` verifiziert.*
