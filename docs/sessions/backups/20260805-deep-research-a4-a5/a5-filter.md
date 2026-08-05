# DEEP-RESEARCH-LENS A5 — Key-Filter-Klasse vs. Value-Filter-Klasse in Map-Strukturen (K→V)

**Stand:** 2026-08-05 · **Lens:** a5-filter · **Tiefe:** very thorough (Web/Paper-Recherche + Code-Gegenprüfung)

---

## 0. KORREKTUR (vor allem Weiteren, verifiziert gegen die kanonische Quelle)

Der Auftrag benennt die Filter-Achse als **„T14"**. Das ist **falsch** — live gegen die autoritative Quelle geprüft
(`thesis/diplomarbeit/kapitel/de/04_concept_architecture.tex`, `tab:axes-overview`, Zeile 104) und exakt der Fehler,
den das Projekt-Memory `reference_thesis_axis_t_ids_vs_dir_numbers.md` bereits als bekannte Verwechslungsfalle
führt („Wert-Hülle als T14 statt T11" — dasselbe Muster, hier auf die Filter-Achse übertragen):

| T-ID | Name | Inhalt lt. tab:axes-overview |
|---|---|---|
| **T14** | **I/O-Dispatch** (F) | Buffered, mmap, Direct-IO — „mmap als Anti-Pattern"; „Persistenz von der Suchstruktur entkoppelt" |
| **T16** | **Filter** (F) | Bloom, Cuckoo, SuRF-Range, Xor — „Filter nie mit Such-Achsen integriert"; **„Filter als orthogonales Organ"** |

Der Code bestätigt T16 exakt: `axis_filter_registry.hpp` listet `AllFilters = mp_list<BloomFilter, CuckooFilter,
RangeSurfFilter, XorFilter>` — wortgleich mit der T16-Zeile der Tabelle. T14 (I/O-Dispatch) ist eine völlig andere
Achse (Persistenzschicht). Alle folgenden Aussagen dieses Berichts verwenden **T16** für die heutige Key-Filter-Achse;
„T14" wird nur noch zitiert, wenn ein Quelltext des Auftrags wörtlich wiedergegeben wird.
Zusatz-Fund: T16 ist im Code als `OrganAxis`-CRTP (`FilterStrategyBase<Derived> : OrganAxis<Derived>`) implementiert,
mit einem gemeinsamen `FilterStrategy`-Concept, das ein `supports_range_query()`-Flag trägt — d.h. Membership- und
Range-Filter sind bereits heute UNTER einem gemeinsamen Interface vereinigt. Das ist ein direktes Vorbild dafür, wie
ein analoges `ValueFilterStrategy`-Concept aussehen könnte (s. §5).

Zusätzliche Ist-Fakten aus der Tabelle (relevant für §5 Einordnung):
- **T11 Value-Handle** (F): Inline, External-Pool, Immutable-Shared (RCU), Versioned — regelt **wo/wie** der Wert
  physisch liegt (Platzierung/Ownership/Versionierung). KEINE Filter-Semantik.
- **T13 Index-Organization** (B): Clustered, IOT, Non-Clustered, Heap — „Storage-Order als eigene Achse". Regelt
  **ob/wie sortiert** physisch gespeichert wird — separate Achse von T16.
- Gesamtzahl: **19 Hauptachsen (T0–T18)**, durchgängig nummeriert, bei der SearchAlgorithm-Anatomie. Eine NEUE Achse
  wäre in dieser Zählung **T19** (nicht „die 19.", sondern die 20. in der 0-indexierten Reihe — die Formulierung
  „19. Organ-Achse" im Auftrag zählt vermutlich 1-basiert oder meint informell „eine weitere/neue Achse").
- Codebase-Grep bestätigt: **kein** `value_filter`, `ValueFilter` o.ä. existiert irgendwo im Repo — das Value-Filter-
  Konzept ist vollständig unbesetztes Terrain, keine Altlast, kein Namenskonflikt.
- Posten 60 `SortedArrayKeySet` (`anatomy/set_default_organ.hpp`) lebt in der **Container-Gattung → Set-Genus**
  (`anatomy_base.hpp`-Dreiebenen-Modell), NICHT in der SearchAlgorithm-Anatomie (T0–T18). Set hat 15 eigene
  Achsen-Slots; die Map-Gattung (K→V) ist laut `37_ap15_container_typen_sequence_plan.md` zum Stand 2026-07-16 noch
  nicht als eigene Gattung/Genus verankert (Set wurde per User-GO promoted, Map wird im Auftrag als in Arbeit
  vorausgesetzt — dort dokumentiert diese Recherche keine weitere Quelle, das ist der Stand der Anfrage selbst).

---

## 1. Kernthese (Zusammenfassung vorab)

1. Die **Key-Filter-Klasse** ist in der Literatur ein reifes, klar benanntes Feld: **Approximate-Membership-Query
   (AMQ) Filter** (Bloom → Cuckoo → Xor → Ribbon/Binary-Fuse) und **Range-Filter** (SuRF → Rosetta → SNARF → Grafite
   → Memento → Oasis → GRF, seit 2024/25 auch Aleph/Zeno-Filter für dynamische Fälle). T16 deckt mit
   Bloom/Cuckoo/SuRF-Range/Xor die Membership-Seite solide und die Range-Seite genau EINEN von mindestens acht
   konkurrierenden State-of-the-Art-Ansätzen ab (SuRF, Stand 2018) — SNARF/Rosetta/Grafite/Memento/Oasis/GRF sind
   NICHT vertreten (Lücke, kein Neubau nötig, nur zur Kenntnis).
2. Sortierte Strukturen (Zonemaps/Min-Max, Small Materialized Aggregates, Fence Pointers, LSM Sorted Runs) werden in
   der DB-Literatur **funktional identisch als Pruning-/Skipping-Mechanismus** beschrieben wie AMQ-Filter — nur mit
   anderem Vokabular („data skipping" statt „filtering"). Das stützt den Owner-Kern direkt: Sortierung IST
   literatur-anerkannt ein Vorfilter-Mechanismus, auch wenn sie in unserer T-Tabelle unter T13 (Index-Organization)
   und nicht unter T16 (Filter) geführt wird — ein struktureller Bruch zwischen Code-Taxonomie und
   Literatur-Funktion, den §5 offen benennt.
3. Die **Value-Filter-Klasse** ist ebenso ein reifes, aber literatur-technisch GETRENNT geführtes Feld — primär in
   der OLAP/Spalten-Store-Community (Zonemaps/SMA dual-use auf Werten, Column Sketches, BitWeaving, Column Imprints,
   Data Blocks) und in der Query-Optimierungs-Community (Predicate Caching, Predicate/Bloom-Join-Transfer). Erst in
   den letzten Jahren erscheinen Arbeiten, die Value-Filter EXPLIZIT im K→V-Store-Kontext ansiedeln, nicht nur im
   Tabellen-Kontext: Sekundär-Attribut-Indizierung auf LSM-KV-Stores (NEXT 2025, Perseid 2024, UCR-Linie seit 2015)
   und — als modernstes, sehr sauberes Analogon — Pre-/Post-/In-Filtering in gefilterter Vektorsuche (2024–2026),
   wo Key-Seite (ANN-Graph/Index über die Vektor-ID) und Value-Seite (Metadaten-Prädikat) explizit als zwei
   getrennte, aber koordinierte Filter-Pfade behandelt werden.
4. **Papers, die explizit BEIDE Seiten EINER Struktur behandeln**, sind selten und meist implizit statt
   programmatisch benannt. Die stärkste Übereinstimmung mit der Owner-These „MAP soll grundsätzlich eine Key- UND
   eine Value-Filter-Achse haben" liefert Idreos' Design-Space-Linie (**Data Calculator** / **Periodic Table of Data
   Structures**): dort ist „Filters" EINE von fünf generischen, node-agnostischen Design-Primitiv-Klassen — ein
   Filter ist dort kein Key-exklusives Konzept, sondern eine orthogonale Eigenschaft, die auf JEDEN Knoten/JEDE
   Dateneinheit anwendbar ist. Das ist keine wörtliche „Key-Filter + Value-Filter"-Nomenklatur, aber die
   architektonisch nächstliegende Bestätigung, dass „Filter" als generisches, seitenunabhängiges Entwurfsprinzip in
   der Literatur ANERKANNT ist (s. §4.1). Konkreter/operationaler ist die Sekundärindex-Literatur (NEXT/Perseid):
   dort trägt EIN System buchstäblich zwei parallele Filterpfade — Primärschlüssel-Bloom/Range-Filter UND
   Sekundärattribut(Value)-Filter — allerdings ohne das vereinheitlichende Vokabular „Key-Filter-Achse/
   Value-Filter-Achse", das der Owner vorschlägt. Diese Vereinheitlichung selbst ist, soweit recherchierbar, eine
   Synthese/Architekturentscheidung des Projekts, keine wörtliche Zitat-Übernahme — das sollte bei der Doku-Führung
   so transparent gemacht werden (Owner-Kern ist Syntheseleistung, durch Literatur GESTÜTZT, nicht 1:1 zitiert).

---

## 2. Key-Filter-Klasse: Membership/Range VOR Key-Zugriff

### 2.1 Klassische AMQ-Filter (Membership) — Stammbaum von T16

| Filter | Kernidee | Paper | Venue/Jahr | Bezug zu T16 |
|---|---|---|---|---|
| Bloom Filter | k-Hash-Bitmap, keine False Negatives | Bloom, *Space/Time Trade-offs in Hash Coding with Allowable Errors* | CACM 13(7), 1970 · DOI 10.1145/362686.362692 | ✅ im Code (`BloomFilter`) |
| Cuckoo Filter | Bucketed Cuckoo-Hashing + Fingerprints, löschbar | Fan, Andersen, Kaminsky, Mitzenmacher, *Cuckoo Filter: Practically Better Than Bloom* | CoNEXT 2014 · DOI 10.1145/2674005.2674994 | ✅ im Code (`CuckooFilter`) |
| Xor Filter | Statisches XOR-Hash, ~9 Bit/Key, schneller & kleiner als Bloom/Cuckoo | Graf, Lemire, *Xor Filters: Faster and Smaller Than Bloom and Cuckoo Filters* | ACM JEA 25, 2020 · DOI 10.1145/3376122 | ✅ im Code (`XorFilter`) |
| Ribbon Filter | Banded Boolean-Gleichungssystem (Dietzfelbinger/Walzer), nahe Informationstheorie-Optimum | Dillinger, Walzer, *Ribbon Filter: Practically Smaller Than Bloom and Xor* | 2021 · arXiv:2103.02515 | ❌ nicht im Code — Kandidat für T16-Erweiterung |
| Binary Fuse Filter | Weiterentwicklung von Xor, ~13% über der Speicher-Untergrenze, ohne Geschwindigkeitsverlust | Graf, Lemire, *Binary Fuse Filters: Fast and Smaller Than Xor Filters* | ACM JEA, 2022 · arXiv:2201.01174 | ❌ nicht im Code — Kandidat |
| Learned Bloom Filter | ML-Modell + Backup-Bloom-Filter statt reiner Hash-Streuung | Kraska et al., *The Case for Learned Index Structures* | SIGMOD 2018 | ❌ nicht im Code |
| Sandwiched Learned Bloom Filter | Modell + zwei Bloom-Filter (Pre-/Post-Modell), formale Analyse | Mitzenmacher, *A Model for Learned Bloom Filters and Optimizing by Sandwiching* | NeurIPS 2018 | ❌ nicht im Code |

Übersichtsquelle (Taxonomie AMQ-Filter allgemein): Wikipedia, *Approximate membership query filter*
(https://en.wikipedia.org/wiki/Approximate_membership_query_filter); VMware Research,
*Approximate Membership Query Data Structures* (https://research.vmware.com/projects/approximate-membership-query-data-structures).

### 2.2 Range-Filter (Key-Vorfilterung für Bereichsanfragen, NICHT nur Punkt-Existenz)

Range-Filter sind die logische Erweiterung von AMQ-Filtern: statt „ist Key k enthalten?" beantworten sie
„schneidet der Bereich [lo,hi] die Keymenge?" — mit Falsch-Positiv-Garantie, aber ohne Falsch-Negative. Das ist
exakt die Kategorie, in der T16 mit `RangeSurfFilter` NUR einen von acht recherchierten SOTA-Vertretern abdeckt:

| Filter | Kernidee | Paper | Venue/Jahr |
|---|---|---|---|
| **SuRF** (im Code) | LOUDS-Bitmap-Trie („Fast Succinct Trie", FST), 10 Bit/Knoten, Punkt+Bereich | Zhang, Lim, Leis, Andersen, Kaminsky, Keeton, Pavlo, *SuRF: Practical Range Query Filtering with Fast Succinct Tries* | SIGMOD 2018 · DOI 10.1145/3183713.3196931 (erweitert: ACM TODS 2020, DOI 10.1145/3375660) |
| Rosetta | Hierarchie von Bloom-Filtern über alle Binärpräfixe eines Keys; Bereichsanfrage → mehrere Präfix-Proben | Luo, Chatterjee, Ketsetsidis, Dayan, Qin, Idreos, *Rosetta: A Robust Space-Time Optimized Range Filter for Key-Value Stores* | SIGMOD 2020 · DOI 10.1145/3318464.3389731 |
| SNARF | Lernt Datenverteilungsmodell, bildet Keys auf komprimiertes Bit-Array ab; bis 50× bessere FPR als SuRF/Rosetta | Vaidya, Chatterjee, Knorr, Idreos, Mitzenmacher, Kraska, *SNARF: A Learning-Enhanced Range Filter* | PVLDB 15(8), 2022 · DOI 10.14778/3529337.3529347 |
| Grafite | Erstes Range-Filter mit BEWIESENER FPR-Obergrenze l/2^(B−2), robust gegen adversariale/korrelierte Queries | Costa et al., *Grafite: Taming Adversarial Queries with Optimal Range Filters* | SIGMOD 2024 · arXiv:2311.15380 · DOI 10.1145/3639258 |
| Memento Filter | Erstes DYNAMISCHES Range-Filter (Insert/Delete, wachsend), integriert in WiredTiger (B-Tree-KV-Store) | Eslami, Dayan, *Memento Filter: A Fast, Dynamic, and Robust Range Filter* | SIGMOD 2025 · arXiv:2408.05625 · DOI 10.1145/3698820 |
| Oasis / Oasis+ | Disjunkte Intervall-Segmentierung, lineares Modell pro Segment → komprimiertes Bitmap, bis 100× bessere FPR | Chen, He, Li, Luo, *Oasis: An Optimal Disjoint Segmented Learned Range Filter* | PVLDB 17(8), 2024, S. 1911–1924 · DOI 10.14778/3659437.3659447 |
| GRF | GLOBALES Range-Filter über den GESAMTEN LSM-Baum (statt je Run/Level einzeln); Shape-Encoding via SNARF-Kern | Wang, Guo, Yang, Zhang, *GRF: A Global Range Filter for LSM-Trees with Shape Encoding* | SIGMOD 2024 · DOI 10.1145/3654944 |
| Aleph Filter | Dynamisches Range-Filter, „to infinity" (unbegrenztes Wachstum in konstanter Zeit) | *Aleph Filter: To Infinity in Constant Time* | PVLDB 2024 · DOI 10.14778/3681954.3682027 · arXiv:2404.04703 |
| Zeno Filter | Nachfolger von Aleph, feingranulareres inkrementelles Wachstum | *Zeno Filter: To Infinity in Tiny Steps* | PACMMOD 2025 · DOI 10.1145/3802128 |

**Überblicks-/Synthesequelle:** Pandey, Farach-Colton, Dayan, Zhang, *Beyond Bloom: A Tutorial on Future
Feature-Rich Filters*, SIGMOD/PODS 2024 Companion, DOI 10.1145/3626246.3654681 — eine explizite Tutorial-Landkarte
der gesamten Membership+Range-Filter-Familie durch genau die Autoren, die auch Memento Filter (Dayan) und
SuRF/GRF (Zhang) geschrieben haben; dient als guter Einstiegspunkt für eine spätere T16-Erweiterungsentscheidung.

### 2.3 Sortierte Strukturen als IMPLIZITER Key-Vorfilter — direkte Stütze für Posten 60

Der Owner-Kern verlangt explizit die Prüfung, ob Sortierung selbst als Key-Vorfilter-Kandidat literaturfähig ist.
Befund: **ja, durchgängig**, nur unter anderem Vokabular („Pruning"/„Skipping" statt „Filter"):

- **Zone Maps / Min-Max-Pruning** (Netezza, Vertica, Oracle Exadata, Snowflake Micro-Partitions): pro Datenblock
  wird MIN/MAX gespeichert; Anfragen, die außerhalb liegen, überspringen den Block VOR jedem Wertezugriff. Zitat
  aus der Praxisliteratur: „Zone Maps help determine where to **not** look for data" — funktional deckungsgleich
  mit der Owner-Definition „Vorfilterung … die vor Betrachtung aller Werte überhaupt in Frage kommen kann".
  Akademisch: Ziauddin et al., *Dimensions Based Data Clustering and Zone Maps*, PVLDB 10(12), 2017,
  DOI 10.14778/3137765.3137769; Praxis: mehrere Netezza-Blogposts (Ross Leishman, Medium) und
  15-721-CMU-Foliensatz (Andy Pavlo) zu Zone-Maps/Data-Skipping.
- **Small Materialized Aggregates (SMA)**: MIN/MAX/COUNT/SUM je Bucket, explizit als „Light Weight Index Structure"
  betitelt — historisch DER Ursprung des Zonemap-Konzepts. Moerkotte, *Small Materialized Aggregates: A Light
  Weight Index Structure for Data Warehousing*, VLDB 1998, S. 476–487
  (https://www.vldb.org/conf/1998/p476.pdf). SMA ist wichtig, weil es explizit **beidseitig** einsetzbar ist
  (s. §3.1) — dieselbe Struktur liefert Key-Pruning UND Value-Pruning, je nachdem, auf welche Spalte sie
  angewendet wird.
- **Fence Pointers** (LSM-Trees/B-Bäume): In-Memory Min/Max-Key je Datenblock/Run — „Lookup durchsucht zuerst die
  Fence Pointers; ist es eine Punktsuche, liest sie dann die passende Seite mit einem I/O." Quelle: Dayan,
  Athanassoulis, Idreos, *Monkey: Optimal Navigable Key-Value Store*, SIGMOD 2017
  (https://nivdayan.github.io/monkeykeyvaluestore.pdf) — Fence Pointers sind dort explizit NEBEN Bloom-Filtern als
  zweite, komplementäre Pruning-Schicht behandelt (Bloom filtert Nicht-Existenz, Fence Pointers filtern die
  Ziel-Seite unter den existierenden Keys) — ein Präzedenzfall dafür, dass „Filter" (Bloom) und „Sortierung als
  Vorfilter" (Fence Pointers) in EINEM Paper als zwei komplementäre Mechanismen derselben Funktionsklasse
  auftreten, exakt die Owner-These.
- **LSM Sorted Runs** selbst: die Eigenschaft „sortiert" ist die Voraussetzung dafür, dass Fence Pointers und
  Zonemaps überhaupt funktionieren (Min/Max EINES Blocks ist nur aussagekräftig, wenn der Block eine geordnete
  Teilmenge des Schlüsselraums ist) — d.h. Sortierung ist nicht nur EIN Vorfilter-Kandidat unter vielen, sondern
  die STRUKTURELLE VORAUSSETZUNG für die gesamte Zonemap/Fence-Pointer-Familie. Für `SortedArrayKeySet` (Posten 60)
  heißt das konkret: die Sortiertheit selbst (binäre Suche, O(log n)) UND ein daraus ableitbares Min/Max-Paar
  (O(1)-Bereichsausschluss, „liegt Ziel-Range überhaupt im [min,max]-Fenster dieses Arrays?") sind zwei
  UNABHÄNGIGE, aufeinander aufbauende Vorfilter-Ebenen — das Array liefert die zweite „gratis", ohne Zusatzspeicher
  über die zwei Endwerte hinaus.

---

## 3. Value-Filter-Klasse: Predicate Pushdown auf VALUES vor Voll-Betrachtung

### 3.1 Zonemaps/SMA — dieselbe Struktur, jetzt auf der Value-Seite

Der wichtigste Befund für §3: **Zonemaps und SMA sind nicht Key-exklusiv.** In Spalten-Datenbanken werden sie auf
JEDE Spalte angewendet, die als Prädikat-Ziel dient — bei Netezza/Vertica/Snowflake typischerweise auf
Nicht-Schlüsselspalten (Preis, Datum, Menge). Das ist bereits der einfachste, am längsten produktiv laufende
Value-Filter überhaupt: „WHERE price > 100" überspringt Blöcke anhand von MAX(price) < 100, exakt symmetrisch zur
Key-Seite. Gleiche Quellen wie §2.3 (Moerkotte VLDB'98; Ziauddin et al. PVLDB 2017; Netezza/Snowflake-Praxisdokus).

### 3.2 SIMD-Scan-Filter / Column-Sketch-Familie (Werte VOR Voll-Dekodierung prüfen)

| System | Kernidee | Paper | Venue/Jahr |
|---|---|---|---|
| BitWeaving | Bit-Ebenen-Parallelität; BitWeaving/V (spaltenartig) und /H (horizontal gepackt) für Prädikat-Scans im Hauptspeicher | Li, Patel, *BitWeaving: Fast Scans for Main Memory Data Processing* | SIGMOD 2013 |
| Column Imprints | Bitmap-Index je Cache-Line-Bereich (Histogramm-Bucket pro Zeile) als Sekundärindex | Sidirourgos, Kersten, *Column Imprints: A Secondary Index Structure* | SIGMOD 2013 |
| Column Sketches | Verlustbehaftete Kompressions-Sketches je Spalte; Prädikat wird für die meisten Werte SOFORT (ohne Dekompression) affirmativ/negativ entschieden, nur Rest greift auf Basisdaten zu; 3–6× schneller als Standard-Scan, 1.4–4.8× schneller als Column Imprints/BitWeaving | Hentschel, Kester, Idreos, *Column Sketches: A Scan Accelerator for Rapid and Robust Predicate Evaluation* | SIGMOD 2018 · DOI 10.1145/3183713.3196911 |
| Data Blocks (+ Positional SMA) | Leichtgewichtige Kompression + neuer Index „Positional SMA", der den Scan-Bereich INNERHALB eines Blocks verengt; hybrid OLTP/OLAP | Lang, Mühlbauer, Funke, Boncz, Neumann, Kemper, *Data Blocks: Hybrid OLTP and OLAP on Compressed Storage using both Vectorization and Compilation* | SIGMOD 2016 · DOI 10.1145/2882903.2882925 |

Gemeinsamer Nenner: alle vier prüfen ein Prädikat auf einer **kompakten Stellvertreter-Repräsentation des Wertes**
(Sketch/Bitmap/Bit-Slice/Positional-SMA), BEVOR der volle (ggf. dekomprimierte) Wert gelesen wird — exakt die vom
Auftrag verlangte „Vorfilterung auf Values vor Voll-Betrachtung". Verwandt/zusätzlich: *Tree-Encoded Bitmaps*,
SIGMOD 2020, DOI 10.1145/3318464.3380588 (kompaktere Bitmap-Indexvariante, selbe SIGMOD-2020-Session wie Rosetta).

### 3.3 Predicate Caching — query-getriebener, adaptiver Value-Filter (Cloud-DW)

Schmidt, Kipf, Horn, Saxena, Kraska, *Predicate Caching: Query-Driven Secondary Indexing for Cloud Data
Warehouses*, SIGMOD-Companion 2024 (Santiago, Chile), DOI 10.1145/3626246.3653395
(PDF: https://assets.amazon.science/11/0e/3a9288554485b616fa0c99fe4067/predicate-caching-query-driven-secondary-indexing-for-cloud-data-warehouses.pdf).
Kernidee: speichert für wiederkehrende Scan-/Join-Prädikate direkt die Bereiche qualifizierender Tupel als
leichtgewichtigen, on-the-fly bauenden Sekundärindex; in Amazon Redshift prototypisiert, bis 10× schnellere
Query-Laufzeiten. Wichtig für unsere Einordnung: das ist ein **adaptiver, workload-gelernter** Value-Filter (Analog
zu Database Cracking/Adaptive Indexing, s.u.), kein statischer wie Zonemap/SMA — zeigt, dass die Value-Filter-Klasse
dieselbe Lern-/Adaptions-Entwicklung durchläuft wie die Key-Filter-Klasse (Rosetta→SNARF→Oasis).

Verwandt (adaptive Value-seitige Partitionierung, Vorläufer-Konzept): Idreos et al., *Database Cracking* /
*Stochastic Database Cracking* (u.a. PVLDB 2012, arXiv:1203.0055) — Spalten werden inkrementell bei jeder Anfrage
in Wertebereiche partitioniert, sodass spätere Anfragen ganze Bereiche ausschließen können, OHNE vorab einen festen
Index zu bauen. Funktional ein sich selbst bauender, adaptiver Value-Vorfilter.

### 3.4 Sekundär-Attribut-Filter in KV-Stores — direkt im Map(K→V)-Kontext, nicht nur Tabellen

Diese Linie ist die literaturnächste zum Owner-Anliegen, weil sie **exakt in der K→V-Store-Welt** (nicht im
Tabellen-/Spalten-Store) operiert:

- Xie et al. (UCR DB Lab), *Efficient Secondary Attribute Lookup in Key-Value Stores*, IEEE BigData 2015
  (http://dblab.cs.ucr.edu/projects/KeyValueIndexes/IEEE-big-data-15.pdf) — frühe, explizite Behandlung von
  Sekundärattribut-Indizierung (= Value-Feld-Filterung) in generischen KV-Stores, getrennt vom Primärschlüssel-Index.
- *Perseid: A Secondary Indexing Mechanism for LSM-Based Storage Systems*, ACM Transactions on Storage 2024,
  DOI 10.1145/3633285 — PM-DRAM-Hybridlayout + „hash-based validation to filter obsolete entries" — ein
  Wert-seitiger Filtermechanismus NEBEN dem Primärschlüssel-Filter derselben LSM-Struktur.
  Repository: https://dl.acm.org/doi/10.1145/3633285
- *NEXT: A New Secondary Index Framework for LSM-based Data Storage*, PACMMOD 2025, DOI 10.1145/3725330 — baut
  Sekundärindex-Blöcke je LSM-Disk-Komponente, die Sekundärattribute (= Werte) auf Datenblöcke abbilden, PLUS einen
  globalen Index darüber; explizit motiviert damit, dass „aktuelle LSM-KV-Stores Suchanfragen mit
  Sekundärschlüssel-Prädikaten nicht verarbeiten können, weil ihnen die Logik fehlt, Sekundärschlüssel aus Werten
  zu extrahieren und Prädikate zu prüfen" — das ist praktisch eine wörtliche Beschreibung der fehlenden
  Value-Filter-Achse in einem klassischen KV-Store.

**Architektonisch zentraler Befund:** NEXT/Perseid sind Systeme, in denen EIN LSM-Baum GLEICHZEITIG (a) einen
Primärschlüssel-Filterpfad (klassisches Bloom/Range-Filter, Key-Seite) UND (b) einen Sekundärattribut-Filterpfad
(Value-Seite) trägt — beide koexistieren im selben Store, sind aber als getrennte Subsysteme implementiert, nicht
als vereinheitlichte „eine Achse mit zwei Seiten". Das stützt die Owner-These strukturell (zwei Filterrollen
gehören zusammen zu EINER Map-Struktur), zeigt aber auch, dass die Literatur sie bislang NICHT unter einem
gemeinsamen Achsen-/Interface-Dach führt — genau die Lücke, die eine neue Value-Filter-Achse schließen würde.

### 3.5 Filtered Vector Search (2024–2026) — modernstes K/V-Analogon mit explizit benannten Filter-Strategien

Vektor-Datenbanken sind strukturell K→V (Key = Vektor-ID, Value = Vektor + Metadaten) und haben seit 2024 eine
eigene, sehr präzise Taxonomie für „Filter auf der Value/Metadaten-Seite koordiniert mit Key/Index-Seite"
entwickelt — die derzeit sauberste, explizit benannte Zwei-Seiten-Terminologie, die die Recherche gefunden hat:

- **Pre-Filtering**: Prädikat wird VOR der Vektorsuche auf den Metadaten (= Values) angewendet, dann Brute-Force
  nur auf der gefilterten Teilmenge — volle Recall-Garantie, aber schlecht skalierend ohne Query-spezifischen Index.
- **Post-Filtering**: erst ANN-Suche über den ungefilterten Key/Vektor-Index (z.B. HNSW), danach Prädikat auf den
  Kandidaten-Values angewendet — benötigt Overfetching.
- **In-Filtering**: Prädikat wird WÄHREND der Graph-Traversierung dynamisch angewendet, nur gültige (Value-Prädikat
  erfüllende) Knoten werden überhaupt exploriert — die engste Verzahnung von Key-Struktur und Value-Filter.

Quellen: *Approximate Nearest Neighbor Search with Window Filters*, arXiv:2402.00943 (2024, Grundlagenarbeit zu
Window/Range-Filtern auf ANN); Jin et al., *Curator: Efficient Vector Search with Low-Selectivity Filters*,
PACMMOD 2026, arXiv:2601.01291, DOI 10.1145/3786635 (partitionsbasierter Index, der sich pro Label/Metadatenwert
spezialisiert — bis 20.9× schnellere Low-Selectivity-Queries ggü. Pre-Filtering-Fallback); Übersichtsartikel
„The Achilles Heel of Vector Search: Filters" (https://yudhiesh.github.io/2025/05/09/the-achilles-heel-of-vector-search-filters/).
Diese Systeme benennen explizit, dass Pre-/Post-/In-Filtering **verschiedene Kopplungsgrade zwischen Key-seitigem
Index und Value-seitigem Prädikat** sind — direkt übertragbar auf die Frage „wo dockt eine Value-Filter-Achse an
die bestehende Key-Struktur an?" (s. §5: analoge Optionen „vor", „nach", „während" des Key-Zugriffs).

### 3.6 Sideways Information Passing / Bloom-Join — Filter AUS Values GEGEN Keys (Grenzfall)

Ein struktureller Grenzfall, der K- und V-Seite explizit koppelt, aber in anderer Richtung als „Value prüfen,
bevor Value gelesen wird": beim Bloom-Join wird ein Bloom-Filter über die JOIN-SCHLÜSSELWERTE einer Relation
gebaut (das sind aus Sicht der anderen Relation Werte, aus Sicht der bauenden Relation Keys) und zum Vorfiltern der
Tupel der anderen Relation verwendet, BEVOR der eigentliche Hash-Join-Probe erfolgt. Quelle: Yang, Zhao, Yu,
Koutris, *Predicate Transfer: Efficient Pre-Filtering on Multi-Join Queries*, CIDR 2024, arXiv:2307.15255
(erweitert: *Accelerate Distributed Joins with Predicate Transfer*, PACMMOD 2025, DOI 10.1145/3725259) —
generalisiert Bloom-Join von einem einzelnen Join auf beliebige Multi-Join-Graphen, 3.1× schneller als klassischer
Bloom-Join auf TPC-H. Relevanz für unsere Achsen-Frage: zeigt, dass „Filter, gebaut aus Werten der einen Seite,
angewendet auf Keys der anderen Seite" ein etabliertes drittes Muster ist — weder reiner Key- noch reiner
Value-Filter, sondern ein Kreuzungsfall, der bei einer sauberen Achsen-Trennung ggf. gesondert benannt werden
müsste (nicht Teil der ursprünglichen Frage, aber Kollateralbefund).

---

## 4. Papers, die BEIDE Seiten einer Map-/Dictionary-Struktur behandeln

### 4.1 Data Calculator / Periodic Table of Data Structures (Idreos et al.) — Filter als generisches, seitenunabhängiges Primitiv

- Idreos, Zoumpatianos et al., *The Data Calculator: Data Structure Design and Cost Synthesis From First
  Principles, and Learned Cost Models*, SIGMOD 2018, DOI 10.1145/3183713.3199671
  (https://faculty.cc.gatech.edu/~jarulraj/courses/8803-f18/papers/data_calculator.pdf); Detailband: Idreos,
  Zoumpatianos, *The Internals of the Data Calculator*, arXiv:1808.02066.
- Idreos, Zoumpatianos, Athanassoulis, Dayan, Hentschel, Kester, Guo, Maas et al., *The Periodic Table of Data
  Structures*, IEEE Data Eng. Bull. 2018 (https://scholar.harvard.edu/files/stratos/files/periodictabledatastructures.pdf,
  Volltext-Fetch in dieser Recherche 403/nicht dekodierbar — Aussage daher NUR über Suchresultat-Snippets
  verifiziert, nicht über Volltext-Zitat; als Grenze der Recherchetiefe hier transparent vermerkt).

**Kernaussage (aus mehreren übereinstimmenden Suchergebnissen, nicht aus Volltext):** Die Design-Primitive
gliedern sich in fünf Klassen — *wie Knoten organisiert, gefiltert und partitioniert werden, das Layout der
Kind-Knoten, und ob Rekursion erlaubt ist*. **„Filtered" ist damit KEINE Eigenschaft, die exklusiv am Schlüssel
hängt, sondern eine orthogonale Eigenschaft JEDES Knotens** — ein Knoten kann grundsätzlich Nutzdaten
unterschiedlichster Art tragen (bei B-Bäumen/LSM typischerweise Keys+Pointer, bei Blattknoten auch Values). Die
konkreten Beispiel-Instanzen, die in den Suchergebnissen auftauchen (Bloom-Filter-Bit-Budget pro LSM-Level),
sind zwar sämtlich Key-seitig — das Prinzip selbst wird aber nicht auf „nur Keys" beschränkt formuliert.
**Einordnung:** Das ist die stärkste literaturseitige Bestätigung, dass „Filter" als generische Design-Kategorie
(nicht an eine Seite gebunden) ANERKANNT ist — aber KEIN Beleg dafür, dass Idreos selbst je einen expliziten
„Value-Filter" instanziiert oder benannt hat. Für eine belastbare 1:1-Zitatstütze der Owner-These müsste der
Volltext (Konferenzband/ACM DL, hinter Paywall in dieser Session nicht erreichbar) geprüft werden — als offene
Nachrecherche vermerkt, nicht als abgeschlossen behauptet.

### 4.2 NEXT / Perseid (s. §3.4) — EIN System, ZWEI koexistierende Filterachsen

Bereits in §3.4 im Detail: die operational konkreteste Bestätigung, dass eine Map/KV-Struktur sinnvoll ZWEI
getrennte Filterrollen tragen kann (Primärschlüssel-Filter + Sekundärattribut/Value-Filter), auch wenn die
Literatur dafür keinen gemeinsamen Achsen-Namen verwendet.

### 4.3 Explizite Negativ-Feststellung (Sondierungsergebnis)

Die Recherche hat **kein Paper gefunden**, das wörtlich von „key filter axis" + „value filter axis" (oder
äquivalenter fester Zwei-Achsen-Nomenklatur für EINE Map-Struktur) spricht. Die Owner-Formulierung „Dies wird auch
in einigen Papern betrachtet" ist nach dieser Recherche am ehesten so zu lesen: das ZUGRUNDELIEGENDE PRINZIP
(Filter als generisches, seitenunabhängiges Vorfilter-Konzept; zwei Filterpfade in einem KV-System) ist mehrfach
und unabhängig belegt (§4.1, §4.2, §3.4–3.6) — die EXPLIZITE, vereinheitlichte Zwei-Achsen-Benennung „Key-Filter +
Value-Filter für Map" ist, soweit diese Recherche reicht, eine **projekteigene Synthese auf gut gestützter
Literaturbasis**, kein wörtliches Zitat einer Einzelquelle. Das ist eine für die Doku-Führung wichtige
Unterscheidung (Owner-Kern korrekt als „Architekturentscheidung, literaturgestützt" statt „Literaturzitat"
einordnen).

---

## 5. Einordnung in die Achsen-Architektur (Optionen skizziert, KEINE Entscheidung getroffen)

### 5.1 Ist-Zustand

- **T16 (Filter)** ist heute eine reine **Key**-Filter-Achse: 4 Wrapper (Bloom/Cuckoo/SuRF-Range/Xor), alle prüfen
  „ist Key k (bzw. Bereich) potenziell vorhanden", bevor der eigentliche Key-Zugriff (Baum-Traversal/Hash-Probe)
  erfolgt. Sitzt in der **SearchAlgorithm-Anatomie** (T0–T18, 19 Hauptachsen), als „orthogonales Organ" (per
  Tabellen-Wortlaut) — d.h. bereits heute so konzipiert, dass es NICHT an eine einzelne andere Achse gebunden ist,
  sondern querschnittlich einhängbar sein soll.
- **Posten 60 `SortedArrayKeySet`** sitzt architektonisch getrennt in der **Container-Gattung → Set-Genus**
  (`anatomy/set_default_organ.hpp`), nicht in T0–T18. Als K=V-Struktur (Set) hat es aktuell keine V-Filter-Frage
  (Value ≡ Key) — die Frage wird erst mit der **Map-Gattung (K≠V)** scharf, für die laut Auftrag noch keine
  Achsen-Verankerung existiert (bestätigt durch leeren Treffer auf „value_filter" im gesamten Repo).
- **T11 (Value-Handle)** und **T13 (Index-Organization)** sind die beiden Nachbar-Achsen, die man bei einer neuen
  Value-Filter-Achse NICHT duplizieren darf: T11 regelt Value-PLATZIERUNG (wo/wie gespeichert), T13 regelt
  KEY-STORAGE-ORDER (sortiert/heap). Eine Value-Filter-Achse würde eine dritte, bisher fehlende Frage beantworten:
  „muss dieser Value überhaupt gelesen/dekodiert werden, gegeben ein Prädikat?" — orthogonal zu beiden.

### 5.2 Wo Sortierung als Vorfilter andockt

§2.3 zeigt: Sortierung (Posten 60) liefert ZWEI Vorfilter-Ebenen gratis oder fast gratis:
1. **Binäre Suche selbst** (O(log n) statt O(n)) — das ist im engeren Sinn kein „Filter" (kein Bit-Budget, keine
   FP-Rate), sondern die BASIS-Zugriffsmethode; funktional aber identisch zum Owner-Kriterium „kann Keys VOR
   Betrachtung aller Werte ausschließen".
2. **Implizites Min/Max-Fenster** (die zwei Endwerte des sortierten Arrays) — das IST ein echter O(1)-Zonemap-Filter
   ohne Zusatzstruktur, direkt aus §2.3/§3.1 übertragbar.
Für die Achsen-Frage heißt das: Sortierung als Vorfilter ist kein Kandidat für eine NEUE eigene Filter-Instanz,
sondern ein **Attribut/Nebenprodukt jeder ohnehin sortierten Organ-Variante** (SortedArrayKeySet heute, potenziell
später ein `SortedMap`-Organ) — literaturseitig eher ein Argument dafür, T16 (bzw. eine künftige Value-Filter-Achse)
so zu konzipieren, dass sortierte Basis-Organe eine „kostenlose" Filter-Instanz (Min/Max) beisteuern können, OHNE
dass dafür zwingend ein separates Bloom/SuRF-artiges Objekt alloziert werden muss (vgl. Fence-Pointer-Präzedenz aus
Monkey, §2.3, wo genau diese Zweiteilung — Bloom-Filter UND Fence-Pointer als zwei komplementäre, aber technisch
verschiedene Mechanismen — bereits einmal produktiv umgesetzt wurde).

### 5.3 Optionen für eine Value-Filter-Achse (unbewertet nebeneinandergestellt)

| Option | Beschreibung | Literatur-Präzedenz | Offene Frage |
|---|---|---|---|
| **A — Neue Hauptachse (T19)** | Eigenständige Achse neben T16, analog strukturiert (eigenes `ValueFilterStrategy`-Concept, eigene Wrapper-Familie: Zonemap/SMA, Column-Sketch-artig, ggf. Predicate-Cache-artig) | Data Calculator/Periodic Table: „Filter" ist generisch, zwei Instanzen (K-seitig, V-seitig) sind mit dem Primitiv vereinbar (§4.1) | Gehört T19 zur SearchAlgorithm-Anatomie (T0–T18) oder zur Map-Gattung? Aktuell sind T0–T18 laut Doku an die SearchAlgorithm-Anatomie gebunden — Map ist eine andere Gattung/Genus (§0). |
| **B — Unter-Achse von T16** | Value-Filter als Sub-Slot INNERHALB der bestehenden Filter-Achse (T16 bekäme zwei Sub-Familien: Key-seitig/Value-seitig) | NEXT/Perseid (§3.4): ein System, zwei Filterpfade, aber NICHT als eine gemeinsam parametrisierte Achse geführt — eher Gegenbeleg als Stütze für „eine Achse, zwei Sub-Rollen" | Verletzt das „orthogonales Organ"-Designprinzip von T16 (Tabellen-Wortlaut), wenn T16 plötzlich wissen müsste, ob es auf K oder V sitzt |
| **C — Unter-Achse/Slot der Map-Gattung selbst** | Value-Filter als einer der (analog zu Set: 15) Achsen-Slots im künftigen Map-Genus/Gattung, strukturell parallel zu T16, aber NICHT Teil von T0–T18 | Set-Genus-Präzedenz: eigene `ISetTier`/`SetObserverSnapshotV1`-ABI mit eigenem Achsen-Satz, unabhängig von T0–T18 (§0, `37_ap15_container_typen_sequence_plan.md` §6) | Würde T16 (Key-Filter, SearchAlgorithm-seitig) und den neuen Value-Filter (Map-Gattung-seitig) in zwei verschiedenen Anatomien verankern — Frage, ob/wie ein Map-Organ dann BEIDE referenziert (Cross-Genus-Komposition existiert laut `cross_genus_organ.hpp`/`cross_genus_composition.hpp` bereits als Muster) |
| **D — Kombiniertes Dual-Filter-Organ** | EIN Organ-Typ, der intern zwei unabhängige Filter-Sub-Objekte trägt (K-Filter-Instanz + V-Filter-Instanz), als geschlossene Einheit an der Map-Gattung hängend | Curator/Pre-Post-In-Filtering (§3.5): dort sind K-Struktur (ANN-Index) und V-Filter (Metadaten-Prädikat) bewusst getrennte, aber im selben Objekt koordinierte Komponenten — engster Analogiefall | Kopplungsgrad (Pre/Post/In-Filtering-Analogon, §3.5) müsste mitentschieden werden: wird der Value-Filter VOR, NACH oder WÄHREND des Key-Zugriffs ausgewertet? |

### 5.4 Spannungsfeld T13 (Index-Organization) vs. T16 (Filter) vs. neue Achse

Ein Befund, der über die reine Value-Filter-Frage hinausgeht, aber direkt aus §2.3 folgt und für die
Doku-Konsistenz relevant ist: die kanonische T-Tabelle trennt heute **T13 (Storage-Order: sortiert/heap)** und
**T16 (Filter: Bloom/Cuckoo/SuRF/Xor)** als zwei UNABHÄNGIGE Achsen. Der Owner-Kern („Sortierungen zählen unter Key
Filter") postuliert dagegen eine FUNKTIONALE Zusammengehörigkeit (beide schließen Keys vor Vollbetrachtung aus).
Die Literatur (§2.3, Monkey/Fence-Pointer) bestätigt die FUNKTIONALE Nähe, OHNE die strukturelle Trennung
aufzuheben — Fence Pointers und Bloom-Filter bleiben bei Dayan/Idreos zwei verschiedene Objekte im selben System,
nicht eine gemeinsame Achse. Diese Recherche liefert dafür keine Auflösung (das wäre eine Architekturentscheidung),
sondern hält fest: **beide Lesarten sind literaturkonform** — „T13 und T16 bleiben getrennt, aber ein Organ kann
aus beiden Achsen gleichzeitig Vorfilter-Nutzen ziehen" (wie bei Monkey) ist ebenso belegbar wie „Sortierung ist
konzeptionell eine Filter-Spielart und gehört semantisch zu T16" (wie vom Owner postuliert). Für Posten 60 heißt
das praktisch: `SortedArrayKeySet` liefert schon heute (ungeplant) einen T16-artigen Nutzen, ohne dass es unter T16
geführt wird — die Frage, ob man das explizit macht (z.B. ein `MinMaxHint`-Interface, das sortierte Organe
zusätzlich zu ihrer T13-Rolle optional erfüllen können), ist eine der offenen Optionen aus §5.3, nicht Teil dieser
Recherche-Entscheidung.

---

## 6. Vollständige Quellenliste

**Key-Filter (Membership):**
- Bloom, *Space/Time Trade-offs in Hash Coding with Allowable Errors*, CACM 13(7) 1970 — DOI 10.1145/362686.362692
- Fan, Andersen, Kaminsky, Mitzenmacher, *Cuckoo Filter: Practically Better Than Bloom*, CoNEXT 2014 — DOI 10.1145/2674005.2674994
- Graf, Lemire, *Xor Filters: Faster and Smaller Than Bloom and Cuckoo Filters*, ACM JEA 25, 2020 — DOI 10.1145/3376122
- Dillinger, Walzer, *Ribbon Filter: Practically Smaller Than Bloom and Xor*, 2021 — https://arxiv.org/abs/2103.02515
- Graf, Lemire, *Binary Fuse Filters: Fast and Smaller Than Xor Filters*, ACM JEA 2022 — https://arxiv.org/abs/2201.01174
- Kraska, Beutel, Chi, Dean, Polyzotis, *The Case for Learned Index Structures*, SIGMOD 2018 — https://www.cl.cam.ac.uk/~ey204/teaching/ACS/R244_2018_2019/papers/Kraska_SIGMOD_2018.pdf
- Mitzenmacher, *A Model for Learned Bloom Filters and Optimizing by Sandwiching*, NeurIPS 2018 — https://www.semanticscholar.org/paper/ed376accc7ff119afdf9535c16f24dfb8031d714
- Wikipedia, *Approximate membership query filter* — https://en.wikipedia.org/wiki/Approximate_membership_query_filter
- VMware Research, *Approximate Membership Query Data Structures* — https://research.vmware.com/projects/approximate-membership-query-data-structures

**Key-Filter (Range):**
- Zhang, Lim, Leis, Andersen, Kaminsky, Keeton, Pavlo, *SuRF: Practical Range Query Filtering with Fast Succinct Tries*, SIGMOD 2018 — DOI 10.1145/3183713.3196931 (TODS-Fassung: DOI 10.1145/3375660)
- Luo, Chatterjee, Ketsetsidis, Dayan, Qin, Idreos, *Rosetta: A Robust Space-Time Optimized Range Filter for Key-Value Stores*, SIGMOD 2020 — DOI 10.1145/3318464.3389731 — https://chatterjeesubarna.github.io/files/rosetta.pdf
- Vaidya, Chatterjee, Knorr, Idreos, Mitzenmacher, Kraska, *SNARF: A Learning-Enhanced Range Filter*, PVLDB 15(8) 2022 — DOI 10.14778/3529337.3529347 — https://www.vldb.org/pvldb/vol15/p1632-vaidya.pdf
- Costa et al., *Grafite: Taming Adversarial Queries with Optimal Range Filters*, SIGMOD 2024 — https://arxiv.org/abs/2311.15380 — DOI 10.1145/3639258
- Eslami, Dayan, *Memento Filter: A Fast, Dynamic, and Robust Range Filter*, SIGMOD 2025 — https://arxiv.org/abs/2408.05625 — DOI 10.1145/3698820
- Chen, He, Li, Luo, *Oasis: An Optimal Disjoint Segmented Learned Range Filter*, PVLDB 17(8) 2024 — DOI 10.14778/3659437.3659447 — https://www.vldb.org/pvldb/vol17/p1911-luo.pdf
- Wang, Guo, Yang, Zhang, *GRF: A Global Range Filter for LSM-Trees with Shape Encoding*, SIGMOD 2024 — DOI 10.1145/3654944 — https://people.iiis.tsinghua.edu.cn/~huanchen/publications/grf-sigmod24.pdf
- *Aleph Filter: To Infinity in Constant Time*, PVLDB 2024 — DOI 10.14778/3681954.3682027 — https://arxiv.org/abs/2404.04703
- *Zeno Filter: To Infinity in Tiny Steps*, PACMMOD 2025 — DOI 10.1145/3802128
- Pandey, Farach-Colton, Dayan, Zhang, *Beyond Bloom: A Tutorial on Future Feature-Rich Filters*, SIGMOD/PODS 2024 Companion — DOI 10.1145/3626246.3654681 — https://prashantpandey.github.io/uploads/sigmod24-tutorial.pdf

**Sortierte Strukturen als Key-Vorfilter:**
- Moerkotte, *Small Materialized Aggregates: A Light Weight Index Structure for Data Warehousing*, VLDB 1998, S. 476–487 — https://www.vldb.org/conf/1998/p476.pdf
- Ziauddin et al., *Dimensions Based Data Clustering and Zone Maps*, PVLDB 10(12) 2017 — DOI 10.14778/3137765.3137769
- Dayan, Athanassoulis, Idreos, *Monkey: Optimal Navigable Key-Value Store*, SIGMOD 2017 — https://nivdayan.github.io/monkeykeyvaluestore.pdf
- Leishman, *Netezza Zone Maps and I/O Avoidance* / *Tearing Down the Netezza Technocracy* (Praxis) — https://medium.com/@rleishman/netezza-zone-maps-theyre-the-same-as-indexes-right-fb3249f01cea

**Value-Filter (OLAP/Spalten-Store):**
- Li, Patel, *BitWeaving: Fast Scans for Main Memory Data Processing*, SIGMOD 2013
- Sidirourgos, Kersten, *Column Imprints: A Secondary Index Structure*, SIGMOD 2013 — https://homepages.cwi.nl/~manegold/COMMIT/imprints.pdf
- Hentschel, Kester, Idreos, *Column Sketches: A Scan Accelerator for Rapid and Robust Predicate Evaluation*, SIGMOD 2018 — DOI 10.1145/3183713.3196911 — https://15721.courses.cs.cmu.edu/spring2023/papers/04-olapindexes/hentschel-sigmod18.pdf
- Lang, Mühlbauer, Funke, Boncz, Neumann, Kemper, *Data Blocks: Hybrid OLTP and OLAP on Compressed Storage using both Vectorization and Compilation*, SIGMOD 2016 — DOI 10.1145/2882903.2882925 — https://db.in.tum.de/downloads/publications/datablocks.pdf
- *Tree-Encoded Bitmaps*, SIGMOD 2020 — DOI 10.1145/3318464.3380588
- Schmidt, Kipf, Horn, Saxena, Kraska, *Predicate Caching: Query-Driven Secondary Indexing for Cloud Data Warehouses*, SIGMOD-Companion 2024 — DOI 10.1145/3626246.3653395 — https://assets.amazon.science/11/0e/3a9288554485b616fa0c99fe4067/predicate-caching-query-driven-secondary-indexing-for-cloud-data-warehouses.pdf
- Idreos et al., *Stochastic Database Cracking: Towards Robust Adaptive Indexing in Main-Memory Column-Stores*, PVLDB 2012 — https://arxiv.org/abs/1203.0055

**Value-Filter (KV-Store-Sekundärindex):**
- Xie et al., *Efficient Secondary Attribute Lookup in Key-Value Stores*, IEEE BigData 2015 — http://dblab.cs.ucr.edu/projects/KeyValueIndexes/IEEE-big-data-15.pdf
- *Perseid: A Secondary Indexing Mechanism for LSM-Based Storage Systems*, ACM Transactions on Storage 2024 — DOI 10.1145/3633285
- *NEXT: A New Secondary Index Framework for LSM-based Data Storage*, PACMMOD 2025 — DOI 10.1145/3725330

**Value-Filter (modern, Vektor-Suche):**
- *Approximate Nearest Neighbor Search with Window Filters*, arXiv:2402.00943, 2024
- Jin et al., *Curator: Efficient Vector Search with Low-Selectivity Filters*, PACMMOD 2026 — DOI 10.1145/3786635 — https://arxiv.org/abs/2601.01291
- *The Achilles Heel of Vector Search: Filters* (Übersichtsartikel) — https://yudhiesh.github.io/2025/05/09/the-achilles-heel-of-vector-search-filters/

**Beide Seiten / Grenzfälle:**
- Idreos, Zoumpatianos et al., *The Data Calculator: Data Structure Design and Cost Synthesis From First Principles, and Learned Cost Models*, SIGMOD 2018 — DOI 10.1145/3183713.3199671 — https://faculty.cc.gatech.edu/~jarulraj/courses/8803-f18/papers/data_calculator.pdf
- Idreos, Zoumpatianos, *The Internals of the Data Calculator*, arXiv:1808.02066
- Idreos et al., *The Periodic Table of Data Structures*, IEEE Data Eng. Bull. 2018 — https://scholar.harvard.edu/files/stratos/files/periodictabledatastructures.pdf (Volltext in dieser Session nicht zugänglich, nur Snippet-verifiziert)
- Yang, Zhao, Yu, Koutris, *Predicate Transfer: Efficient Pre-Filtering on Multi-Join Queries*, CIDR 2024 — https://arxiv.org/abs/2307.15255 (erweitert: PACMMOD 2025, DOI 10.1145/3725259)

**Codebase (interne Grounding-Quellen, dieser Recherche-Session gelesen):**
- `Code/external/comdare-cache-engine/libs/cache_engine/axes/filter_axis/axis_filter_registry.hpp`
- `Code/external/comdare-cache-engine/libs/cache_engine/axes/filter_axis/PAPER_REFERENCES.md`
- `Code/external/comdare-cache-engine/libs/cache_engine/axes/filter_axis/axis_filter_strategy_base.hpp`
- `Code/external/comdare-cache-engine/libs/cache_engine/axes/filter_axis/concepts/axis_filter_concept.hpp`
- `Code/external/comdare-cache-engine/libs/cache_engine/anatomy/set_default_organ.hpp` (Posten 60, SortedArrayKeySet)
- `Code/external/comdare-cache-engine/docs/architecture/18_achsen_algorithmus_paper_code_map.md` (§axis_filter)
- `Code/external/comdare-cache-engine/docs/architecture/37_ap15_container_typen_sequence_plan.md` (Container-Gattung/Set-Genus)
- `thesis/diplomarbeit/kapitel/de/04_concept_architecture.tex` (tab:axes-overview, Zeile 88–106 — kanonische T0–T18-Tabelle, Korrektur-Quelle für §0)
- `docs/HANDOVER-ANHANG-MEMORIES-20260705/reference_thesis_axis_t_ids_vs_dir_numbers.md` (Memory-Warnung T-ID vs. axis_NN)
