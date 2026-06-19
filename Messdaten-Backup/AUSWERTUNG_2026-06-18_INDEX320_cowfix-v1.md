# Auswertung Messlauf `INDEX320_cowfix-v1` (2026-06-18)

Datei: `tier150_measurements_INDEX320_cowfix-v1_2026-06-18.csv` (163 MB, `;`-getrennt, 154 Spalten,
**120.960 Messzeilen**). Bezugsrahmen: Diplomarbeit, Hauptthema **cache-line-aware / aktiv cache-bewusste
Hardware-Adaption** trie-basierter Indexstrukturen.

---

## 1. Datengrundlage & Versuchsaufbau
- **320 Lebewesen-Binaries** = Vollfaktoriell **memory_layout (5) × node_type (4) × prefetch (4) × search_algo (4)**.
- **Fixiert** (nicht variiert): `isa = amd64`, `cache_traversal = linear_fanout`, `allocator = std_malloc`.
  → **Über SIMD/ISA, Traversierungs- und Allokator-Achse ist in diesem Lauf KEINE Aussage möglich.**
- **21 Workloads × 3 Wiederholungen** (+ weitere Sub-Settings); je Workload 5.760 Zeilen.
- „cowfix-v1" = Lauf nach dem Copy-on-Write-Memento-Fix (#133). Messmodell: **Wall-Clock + Per-Achsen-Observer**
  (`ns_per_op`, Per-Op-p50/p99, `seg_<achse>_ns`). **Keine Hardware-/PMC-Zähler** (keine L1/L2/L3-/dTLB-Misses) —
  konsistent mit dem Thesis-Stand „PMC noch ausstehend". Cache-Verhalten ist hier nur **indirekt** (über Latenz
  + die — s.u. defekte — Layout-Statistik) beobachtbar.

## 2. Methodik-Hinweis (wichtig für die Interpretation)
- **Median statt Mittelwert.** Die Mittelwerte sind durch einen schweren rechten Tail verfälscht
  (Gesamt: Mittel 51.743 ns/op vs. **Median 15.760 ns/op**; Max **8,6 ms/op**). Es werden durchgängig **Mediane** berichtet.
- **Marginal vs. kontrolliert.** „Marginal" = Median je Achsenwert über alle anderen Achsen/Workloads
  (bias-freier Erstordnungseffekt, aber konfundiert). „Kontrolliert" = ein sauberer Workload (ycsb\_c, read-only)
  + fixierter search\_algo (k\_ary), um den reinen Achseneffekt zu isolieren.

## 3. Verbesserungen / Verschlechterungen je Dimension

### 3.1 search\_algo — **stärkster Hebel (klar cache-line-konform)**
| search\_algo | Median ns/op (marginal) | vs. linear\_scan |
|---|---|---|
| **k\_ary** | **6.844** | **−70 %** |
| eytzinger | 13.636 | −39 % |
| interpolation | 16.440 | −27 % |
| linear\_scan | 22.506 | Baseline (schlechtester) |
→ **k-äre Mehrwege-Suche** (Schlegel/Gemulla/Lehner, DaMoN 2009) ist mit Abstand am schnellsten; das
cache-line-freundliche k-Wege-Layout schlägt den linearen Scan um den Faktor ~3,3. **Stützt das Hauptthema.**

### 3.2 node\_type — kleiner, workload-abhängiger Effekt
| node\_type | Median (marginal) | Median (ycsb\_c, k\_ary) |
|---|---|---|
| node16 | 12.704 | **2.798 (best)** |
| node48 | 14.673 | 2.864 |
| node256 | 16.525 | **3.016 (worst)** |
| node4 | **20.095 (marginal worst)** | 2.823 |
→ Kontrolliert ist **node256 konsistent am schlechtesten** (+7,8 %; große Knoten verschwenden Cache-Line-Platz
bei dünner Belegung) — **mild cache-line-konform**. Der marginale „node4 = schlechtester" ist hingegen ein
**Tiefen-Artefakt schreib-/scan-lastiger Workloads** (node4 → tiefer Baum → mehr Pointer-Chasing), nicht der
Lese-Latenz.

### 3.3 memory\_layout — **kein robuster Effekt (Schwachpunkt)**
| memory\_layout | Median (marginal) | Median (ycsb\_c, k\_ary) |
|---|---|---|
| packed\_bitmap | 13.865 | 2.859 |
| aosoa | 15.802 | 2.904 |
| cache\_line\_aligned | 16.255 | 2.843 |
| aos\_strict | 16.293 | 2.831 |
| soa | 16.829 | 2.847 |
→ **Marginal** sieht packed\_bitmap ~21 % besser aus als soa — **kontrolliert schrumpft die Spanne auf 2,6 %**
(2.831–2.904), ohne klaren Gewinner. **Die zentrale cache-line-aware Achse zeigt in diesem Lauf KEINEN
belastbaren, isolierten Latenzvorteil.** Zusammen mit der defekten CLU-Metrik (§5) ist der Layout-Nutzen
hier **nicht nachgewiesen**.

### 3.4 prefetch — **Verschlechterung (Overhead ohne Nutzen)**
| prefetch | Median ns/op (marginal) |
|---|---|
| **none** | **15.379 (best)** |
| hardware | 15.652 |
| path\_oriented | 15.723 |
| distance\_estimator | 16.301 (+6,0 %, worst) |
→ **Alle Prefetch-Organe sind langsamer als „kein Prefetch".** Bei kleinem Arbeitssatz (10.000 Ops, passt in den
Cache) ist Prefetch reiner Overhead. Für die These „aktives cache-bewusstes Prefetching" ein **negativer Befund** —
mit dem Caveat, dass größere, cache-sprengende Arbeitssätze nötig wären, um den Prefetch-Nutzen überhaupt zu testen.

### 3.5 Workload-Dimension (Kostenspanne ~36×)
- **Leicht** (read-only/negativ): lp\_read\_uniform 4.379, ycsb\_c 4.484, coco\_p04\_neg-Sweep 4.409→8.857.
- **Schwer** (write/scan/concurrent/bulk): lp\_bulk\_insert 156.402, ih 117.701, lp\_delete\_heavy 108.010,
  lp\_concurrent\_rmw 87.767, lp\_balanced\_5050 66.078, ycsb\_a 65.652, ycsb\_e 64.105.
→ Die Achsen-Effekte sind **stark workload-abhängig**; eine faire Aussage erfordert die Per-Workload-Matrix
(alle-gegen-alle), nicht nur Marginale.

## 4. Bezug zum cache-line-aware Hauptthema (Fazit)
- **Gestützt:** Cache-line-freundliche **Suche** (k\_ary) ist der dominante Gewinn; große Knoten (node256)
  sind konsistent am teuersten — beides im Sinne der These.
- **Nicht gestützt / offen:** Die **memory\_layout-Achse** (Kern der „cache-line-aware"-Idee) liefert isoliert
  keinen messbaren Vorteil; die **Prefetch-Organe verschlechtern** die Latenz; die **CLU-Kennzahl** (eigentliche
  Cache-Line-Auslastung) ist defekt (§5). Der „aktive" Teil der These (Layout/Prefetch-Adaption) ist mit diesen
  Daten **noch nicht belegt**.
- **Methodische Lücke:** Ohne PMC (L1/L2/L3-, dTLB-Misses) und ohne ISA/SIMD-Variation kann der eigentliche
  cache-line-Mechanismus nur über Latenz angenähert werden.

## 5. Mutmaßliche Messfehler / unzuverlässige Werte
1. **CLU-Instrumentierung defekt (kritisch).** `stat_memory_layout_field_bytes` ist über **alle 5 Layouts
   identisch (46.509)**, ebenso `records` (11.627); nur `cache_lines` variiert als feste Records-Vielfache
   (cache\_line\_aligned/soa/aosoa = 1×, packed\_bitmap = 2×, **aos\_strict = 16×**). 16 Cache-Lines pro Record
   ist physikalisch unmöglich; field\_bytes ≈ 4 B/Record ignoriert die (key,value)=16-B-Breite. Ergebnis: CLU
   0,4–6,2 % — **unrealistisch niedrig und nicht layout-differenzierend**. → Die zentrale Cache-Line-Metrik ist
   in diesem Lauf **nicht verwertbar** (Instrumentierungs-Bug, vor der Abgabe zu fixen).
2. **Mittelwerte outlier-kontaminiert.** 9,08 % der Zeilen (10.983) liegen > 10× Median (>158.000 ns/op),
   Max 8,6 ms/op (~560× Median). → **Nur Median/Perzentile verwenden, Mittelwerte verwerfen.**
3. **Tail ist gemischt, nicht reiner Warmup.** Die Ausreißer verteilen sich **gleichmäßig über alle 3
   Wiederholungen** (rep0/1/2 ≈ 3.681/3.628/3.674) → kein Warmup-Leak; sie ballen sich in **realen schweren
   Workloads** (bulk\_insert, ih, delete\_heavy, range\_scan, rmw). Der Tail ist also **größtenteils echt**
   (teure Operationen), aber die **Einzel-Extreme** (Mehr-Millisekunden) sind System-Artefakte (OS-Scheduling,
   OneDrive-Sync, Thermik auf der Messmaschine) — für die Abgabe als getrimmte/winsorisierte Perzentile behandeln.
4. **op\_lookup\_p99 ist sauber** (Mittel 16.684 ns, nur 2 Zeilen > 1 ms) → die Extreme stammen aus
   Insert/Scan/RMW/Clear, nicht aus Lookups (plausibel).

## 6. Empfehlung für die Abgabe (morgen)
- Headline-Aussagen **nur auf Median/Perzentilen**; Mittelwerte nicht zeigen.
- **k\_ary-Suche** als Kernbeleg des cache-line-aware Vorteils herausstellen; node256-Nachteil als Stütze.
- memory\_layout + prefetch **ehrlich als (noch) nicht belegt / verschlechternd** ausweisen.
- **CLU-Werte NICHT berichten** (defekt) — oder explizit als „Instrumentierung fehlerhaft, wird nachgemessen" kennzeichnen.
- Als nächste Messung: ISA/SIMD variieren + PMC aktivieren + cache-sprengende Arbeitssätze, sonst bleibt der
  cache-line-Mechanismus unbeobachtet.
