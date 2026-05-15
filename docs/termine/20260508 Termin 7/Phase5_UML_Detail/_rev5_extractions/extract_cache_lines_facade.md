# EXTRACT: Cache Lines, Cache Pages, Facade Pattern fuer ICacheEngine-Familien

**Stand:** 2026-05-11
**Kontext:** REV5.1 Recherche fuer Phase 5 UML Detail (PRT-ART)
**Architektur-Bezug:** 3-Schichten-Modell KONZEPT / STRATEGIE (Kleber/CacheEngine) / PHYSISCH
**Recherche-Methode:** WebSearch + WebFetch (cppreference, ACM, arxiv, CMU PDL, Stony Brook)

---

## 1. Cache-Line-Architektur in modernen CPUs

### 1.1 Typische Cache-Line-Groessen (Stand 2026)

| Architektur | L1 Cache-Line | Bemerkung |
|---|---|---|
| **x86-64 (Intel/AMD)** | **64 B** | Universaler de-facto Standard seit P6/Athlon-Zeit. Gilt fuer Skylake, Zen 1-5, Granite Rapids. Nur AMD Bulldozer-Familie hatte teils 32 B L1, aber 64 B L2. |
| **ARM Cortex-A (mainstream)** | **64 B** | A53/A55/A72/A76/A78/X1-X4 sowie Neoverse N/V Server-Cores. |
| **Apple Silicon (M1-M4)** | **128 B** | P-Cores (Firestorm/Avalanche/Everest). E-Cores teilweise 64 B - Heterogenitaet erfordert max-Wert! |
| **Fujitsu A64FX (Fugaku)** | **256 B** | Speziell fuer 512-bit SVE designed. Nur 4-way associativ. Begruendung: SVE-Vector entspricht halber Line. |
| **IBM POWER9/POWER10** | **128 B** | Schon laenger 128-B-Line, plus L1 sektoriert in 64-B-Sektoren. |

**Konsequenz fuer PRT-ART:** Eine fest-codierte 64-B-Annahme **scheitert** auf Apple Silicon (unnoetiges False Sharing zwischen 64-127) und auf A64FX (unnoetig haeufige Cache-Misses bei 64-B-Padding). Die `ICacheStrategy` MUSS `hardware_destructive_interference_size` plattformabhaengig dynamisch laden. C++17 stellt `std::hardware_destructive_interference_size` und `std::hardware_constructive_interference_size` zur Verfuegung; GCC liefert fuer generic AArch64 destructive=256, constructive=64.

### 1.2 Layout-Konsequenzen

Cache-Lines sind die kleinste Transfer-Einheit zwischen RAM und L1. Drei direkte Konsequenzen fuer Suchstruktur-Layouts:

1. **Atomicity der Misses:** Jede gelesene Adresse zieht *die ganze Line* in L1. INodes deutlich kleiner als L (z.B. 16 B INode bei 64 B L) verschwenden 75% Bandbreite, wenn Nachbarn nicht gemeinsam genutzt werden. INodes deutlich groesser als L (z.B. 256 B INode bei 64 B L) erzwingen 4 Misses pro Knoten - akzeptabel falls Hardware-Prefetcher die naechsten Lines streamen kann.
2. **Alignment-Pflicht:** Ein INode kostet (ceil(size/L) + 1) Lines, wenn die Startadresse nicht Vielfaches von L ist. Cache-bewusste Layouts erzwingen `alignas(L)` und vermeiden Spanning ueber Line-Grenzen (vergl. Rao/Ross 2000: "Nodes should not cross a B0 boundary").
3. **False Sharing:** Mehrere Threads, die unterschiedliche Variablen in derselben Line modifizieren, invalidieren gegenseitig die L1-Kopien (MESI-ping-pong). Padding via `alignas(std::hardware_destructive_interference_size)` ist Pflicht fuer write-shared Felder (Lock-Counter, Versions-Stamps in ART/HOT/Masstree).

### 1.3 Cache-Line-Aware Algorithmen (Familien)

- **CSS-Tree (Rao/Ross 1999):** Knotensize EXAKT eine Cache-Line, Pointer-Eliminierung durch arithmetische Index-Berechnung in Array-Layout.
- **CSB+-Tree (Rao/Ross 2000):** Geschwister-Knoten zusammenhaengend, nur First-Child-Pointer; Line-Aligned.
- **FAST (Kim/Chhugani 2010, SIGMOD):** **3-stufige Hierarchie** Page-Block / Cache-Line-Block / SIMD-Block. Erstmals echte Mehrebenen-Embedding.
- **HOT (Binna/Leis 2018):** SIMD-friendly bitstring layout, k-constrained sub-trees compaktiert in eine kompakte SIMD-vergleichbare Bitstring.
- **ART (Leis/Kemper/Neumann 2013):** Adaptive Knotengroessen 4 / 16 / 48 / 256 - gewaehlt so, dass jede Variante Line-aligned ist (16 B = SIMD-128-Vergleich, 256 B fuellt 4x64-B-Lines).

---

## 2. Cache-Page vs Cache-Line Hierarchie

### 2.1 Hierarchie-Schichtung (drei Granularitaeten)

In der modernen Speicher-Hierarchie unterscheidet die Architektur DREI verwandte aber verschiedene Granularitaeten:

| Ebene | Typische Groesse | Verwaltet von | Zweck |
|---|---|---|---|
| **Cache-Line (B0)** | 64-256 B | Hardware (MESI) | Atomic Transfer L1<->L2<->L3 |
| **Cache-Page / Block (B1)** | 4 KiB (Standard), 2 MiB (Huge) | OS (mmap/MMU) + TLB | Virtual Memory Mapping |
| **Disk-Page** | 4-64 KiB (klassisch), 4 MiB+ (NVMe) | DBMS-Buffer-Pool | Persistenz |

Eine ICachePage entspricht in PRT-ART-Terminologie eindeutig der OS-Page (4 KiB Default) - sie deckt typisch **64 Cache-Lines** ab (bei x86 64 B Line). Eine ICacheLine ist die Hardware-Transfer-Einheit.

### 2.2 Wie Pages auf Lines liegen

Ein 4-KiB OS-Page besteht aus 64 contiguous 64-B-Cache-Lines (oder 32 lines x 128 B auf Apple Silicon, 16 lines x 256 B auf A64FX). Critical: Die OS-Page ist *physisch* contiguous, aber Hardware-Prefetcher arbeiten nur innerhalb einer Page (next-line, stride). Ein PRT-Knoten DARF eine Page-Grenze ueberschreiten, **muss aber dann mit explizitem prefetch() gehandhabt werden**, sonst leidet Range-Scan-Performance massiv.

### 2.3 Verhinderung "falschen Fragmentierens"

Falsches Fragmentieren entsteht in drei Auspraegungen:

1. **Inter-Line-Fragmentation (within page):** INode liegt zwischen zwei Lines (z.B. Bytes 60-92 ueber Line 0/1). Loesung: `alignas(64)` pro INode-Allocation.
2. **Inter-Page-Fragmentation (within huge-page):** INode wird ueber 4-KiB-Page-Grenze gesplittet, TLB muss zwei Eintraege halten. Loesung: Page-aligned Pool-Allocator, oder INode-Size <= 1 Page.
3. **False Sharing (Concurrency):** Hot-Locks mehrerer INodes in derselben Line. Loesung: `alignas(std::hardware_destructive_interference_size)` fuer Sync-Felder.

Das Rao/Ross-Prinzip "Nodes should not cross a B1-block boundary so that it is never necessary to fetch two cache blocks" ist genau diese Regel - in PRT-ART ist das Sache der `ISearchPageStructure` (Layout-Strategie). Sie waehlt INode-Groessen, die "ganzes Vielfaches einer Cache-Line bei minimalem Padding" sind.

### 2.4 Konkrete fpB+-Tree-Konstruktion (Chen et al. 2002)

Fractal-Prefetching B+-Trees embedden cache-optimierte interne Trees innerhalb disk-optimierter Trees. Ein Disk-Page (z.B. 8 KiB) enthaelt einen kleinen B+-Tree mit Cache-Line-grossen Knoten (z.B. 64 B). Beim Search-Pfad wird der Disk-Page einmal in den Cache geladen, danach laeuft die innere Suche komplett in L1. **Das ist das Praezedenz-Beispiel fuer das PRT-ART-Mapping ISearchPage -> ICachePage -> mehrere ICacheLines.**

---

## 3. Facade-Pattern fuer Datenstruktur-Decoder

### 3.1 Klassisches GoF-Facade

Facade definiert ein vereinfachtes Interface fuer ein komplexes Subsystem. Der Subsystem-Aufrufer muss interne Strukturen NICHT kennen. Im Standardfall: `Compiler.compile()` als Facade ueber Lexer, Parser, Optimizer, CodeGen.

### 3.2 Facade als Datenstruktur-Decoder ("Interpreter-Facade-Singleton")

Die User-Idee "Singleton-Interpreter ist ein Element der ISearchPageStructure" verbindet drei Patterns:

- **Strategy** (austauschbares Layout: CSS, CSB+, FAST, HOT, ART, vEB)
- **Interpreter** (jede Layout-Strategie weiss, wie SIE selbst dekodiert wird)
- **Facade** (einheitliches Such-Interface nach aussen)
- **Singleton** (eine Instanz pro Layout-Variante; Layout-Wahl ist statisch pro Tree-Instanz, NICHT pro INode)

**Praezedenz-Pattern aus der Literatur:** Compiler-Backends (LLVM TargetInfo, Java HotSpot CodeBlob), Serialization-Frameworks (Protobuf MessageLite, Cap'n Proto Reader/Builder), Filesystem-Layouts (ext4 inode iterator, B+-tree page formats). Alle teilen das Schema: **die Datenstruktur weiss, wie sie zu lesen ist; der Aufrufer ruft eine schmale Facade**.

### 3.3 Konkrete Implementierung

```cpp
class ISearchPageStructureInterpreter {  // Facade
  virtual INode* find(const Key&) const = 0;
  virtual Iterator scan(const Range&) const = 0;
  virtual void prefetch(Hint) const = 0;
};

class CSBPlusInterpreter : public ISearchPageStructureInterpreter {
  // Singleton, kennt Layout-Konvention CSB+
  static const CSBPlusInterpreter& instance();
  INode* find(...) override;  // arithmetische Child-Berechnung
};

class HOTInterpreter : public ISearchPageStructureInterpreter {
  // Singleton, kennt Layout-Konvention HOT
  static const HOTInterpreter& instance();
  INode* find(...) override;  // SIMD bit-string parallel compare
};
```

Die `ISearchPageStructure` haelt einen Verweis auf einen **konkreten** Singleton-Interpreter. Bei jedem `find(key)` an der Facade delegiert der Tree an `structure->interpreter()->find(key)`. Wechsel der Layout-Strategie zur Compile-Zeit (Template-Param) oder Lade-Zeit (Polymorphismus) moeglich.

### 3.4 Vorteile der Trennung

- **Layout-Variation ohne Algorithmus-Touch:** Neuer Layout-Typ = neuer Interpreter-Singleton. KONZEPT-Schicht (IFanout, INode) bleibt unangetastet.
- **Singleton statt Per-Node-vtable:** Spart 8 B vtable-Pointer pro INode (kritisch bei 16-B-INodes!).
- **Testbarkeit:** Mock-Interpreter fuer Unit-Tests der KONZEPT-Schicht moeglich.

---

## 4. Cache-Line-Aware Layout-Strategien aus der Forschung

### 4.1 False-Sharing-Avoidance via C++ Standard

C++17 fuehrte `std::hardware_destructive_interference_size` (im Header `<new>`) ein - die minimale Distanz, die zwei Variablen brauchen, um nicht auf gemeinsamer Cache-Line zu landen. Verwendung:

```cpp
struct alignas(std::hardware_destructive_interference_size) NodeLock {
  std::atomic<uint64_t> version;
  // ... Padding wird vom Compiler automatisch eingefuegt
};
```

GCC-Defaults (Stand 2025):
- x86-64: destructive=64, constructive=64
- generic AArch64: destructive=256 (A64FX-kompatibel!), constructive=64
- Apple Silicon (Clang): destructive=128, constructive=64

**Wichtig fuer PRT-ART:** Plattform-spezifische `ICachePlatform`-Adapter MUESSEN diese Werte zur Compile-Zeit pinnen, sonst entsteht ABI-Inkonsistenz zwischen Bibliotheken.

### 4.2 Cache-Line-Fitting Node Sizes (Wisconsin-Studie Hankins/Patel 2003)

Conventional Wisdom: Knoten-Groesse = Cache-Line-Groesse. Hankins/Patel widerlegten das: Optimum liegt bei **160-512 B**, nicht bei 64 B. Begruendung: zusaetzliche Misses sind billiger als Instruction-Count-Overhead bei zu kleinen Knoten (mehr Pointer-Verfolgung, mehr Vergleichs-Iteration). Apple Silicon (128 B) profitiert besonders, A64FX (256 B) hat Optimum bei 256-512.

### 4.3 Padding-Strategien

| Strategie | Anwendung | Vorteil | Nachteil |
|---|---|---|---|
| **End-padding** | Letzte L mod size Bytes pro B1 leer | Verhindert Cross-Line-Spanning | 5-15% Speicher-Overhead |
| **Begin-padding (alignas)** | Knoten ans naechste L-Multiple aligned | Garantiert L-aligned | Heap-Fragmentation moeglich |
| **Pool-Allocator** | Vorab L-aligned Bloecke | Beides automatisch | Eigener Allocator noetig |
| **Cache-line-color-padding** | Bewusste Distanz zur Vermeidung von L1-Set-Konflikten | Vermeidet Set-Konflikt-Misses | Architektur-spezifisch |

### 4.4 Hot/Cold-Split

In der Praxis (Mahling/Weisgut/Rabl 2025, Naderan-Tahan/Sarbazi-Azad 2016) wird vermehrt zwischen **hot** (haeufig zugegriffen, klein, im L1/L2 gehalten) und **cold** (selten, gross, RAM/SSD) gesplittet:

- INode-Header (Key-Hashes, Child-Bitmap) -> hot, in dichten Tabellen
- INode-Payload (Werte, Strings) -> cold, in separater Allocation
- Vermeidet Cache-Pollution durch grosse Payloads, die nur selten gelesen werden

Das passt direkt zum F-EXTRA-Modell, in dem ICacheLevel L1/L2/L3 unterschieden werden und ICacheStrategy Hot-Pfad explizit auf L1 sektoriert.

---

## 5. Mapping INode -> ISearchPage -> ICachePage -> ICacheLine in modernen Implementierungen

### 5.1 Klassisches B+-Tree (Rao/Ross 2000 CSB+)

- **INode = ISearchPage**: 1:1, jeder logische Knoten ist eine Page.
- **ISearchPage -> ICachePage**: Knoten werden line-aligned in 64-B-Bloecken gepackt; mehrere Knoten teilen 4-KiB-OS-Page.
- **ICachePage -> ICacheLine**: 1 Knoten = 1 Cache-Line direkt (64 B), oder mehrere Lines bei groesseren Fanouts.

### 5.2 ART (Leis 2013)

- **INode** existiert in vier Varianten: Node4 (16 B), Node16 (~144 B), Node48 (~656 B), Node256 (~2080 B). 
- **ISearchPage** = lineares Array aller INodes pro Tree.
- **Mapping**: Node4 sitzt in 1 Cache-Line; Node16 in ~3 Lines (aber alignas(16) reicht fuer SIMD); Node48 spannt ~10 Lines; Node256 spannt ~33 Lines (aber: nur Hot-Lines werden tatsaechlich angefasst -> Sparse-Access).

### 5.3 HOT (Binna 2018)

- **INode** = compound bit-string node, max k discriminative bits.
- **ISearchPage** = compact bitstring serialisiert in einem Memory-Pool.
- **Mapping**: Ein HOT-Knoten ist explizit so dimensioniert, dass er in **EINE Cache-Line passt** (32-64 B), inklusive SIMD-Vergleichs-Mask.

### 5.4 FAST (Kim 2010)

Explizites 3-Level-Embedding:
- **Page-Level Block** (4 KiB Page) enthaelt
- **Cache-Line-Level Block** (64 B Cache-Line) enthaelt
- **SIMD-Level Block** (16 B SIMD-Register).

Genau das User-Schema! Das KONZEPT von PRT-ART ("INodes auf mehreren ISearchPages, multipel auf ICachePages, fragmentiert ueber ICacheLines") ist eine **Verallgemeinerung des FAST-Schemas auf beliebige Layout-Strategien**.

### 5.5 Masstree (Mao/Kohler 2012)

- **INode** = Trie-of-B+-Trees Knoten, 8-Byte-Slice-Indexed.
- **ISearchPage** = einzelner B+-Tree-Knoten innerhalb eines Trie-Layers.
- **Mapping**: Jeder B+-Knoten ~256 B, alignas(64), Sync-Felder via padded version counters (Permuter).

### 5.6 vEB-Layout (Bender/Demaine 2005)

- **INode** = abstrakter Binary-Tree-Knoten (kein expliziter Speicher!).
- **ISearchPage** = vEB-rekursiv-strukturiert: bei N Knoten wird Baum bei sqrt(N) Hoehe geteilt, Top und Bottom rekursiv vEB-gelegt.
- **Mapping**: Cache-oblivious - garantiert O(log_B N) Misses fuer JEDEN B (Cache-Line-Groesse) ohne Tuning.

---

## 6. Cache-Layout-Familien aus der Praxis (Gesamttaxonomie)

| Familie | Beispiel-Algorithmen | Charakteristik | Pro | Contra |
|---|---|---|---|---|
| **Cache-Aware** | CSS, CSB+, FAST, HOT, ART | Kennt B explizit, optimiert Knoten=L | Maximale Performance auf bekannter Plattform | Re-Tuning bei Plattformwechsel (x86 -> M1/A64FX) |
| **Cache-Oblivious** | vEB-Layout, Funnel-sort, Bender's CO-B-Tree | Funktioniert ohne B/M-Wissen, asymptotisch optimal fuer ALLE B | Portable, robust ueber Hierarchien | 5-30% Konstant-Faktor schlechter als Tuned |
| **Hybrid (Fractal)** | fpB+ (Chen 2002), Masstree | Aussen disk-optimiert, innen cache-optimiert | Beide Welten | Komplexere Implementierung |
| **Pointer-Eliminated** | CSS, FAST, Implicit Heap | Kein Pointer-Storage, arithmetische Child-Berechnung | Hoechste Pack-Dichte | Statisch - schwer dynamisch zu updaten |
| **Hot/Cold-Split** | Naderan 2016, Mahling 2025 | Header/Payload separiert, Hot in L1 | Hohe Cache-Effizienz bei skewed Workloads | Komplexere Allocation, doppelte Indirektion fuer Cold |
| **Padding-Hardening** | jeder Multi-Threaded INode (Masstree, ART-Sync, B-link) | `alignas(L)` fuer Sync-Felder | Eliminiert False Sharing | 5-15% Speicher-Overhead |
| **vEB Layout** | Bender/Demaine (theoretisch), Brodal (praktisch) | Rekursive Aufteilung bei sqrt(h) | Cache-Optimum fuer ALLE Levels | Komplex, Insertions teuer |
| **SIMD-Aligned** | HOT, FAST-SIMD-Block, ART-Node16 | Knoten-Groesse = SIMD-Register-Vielfaches (16 B SSE, 32 B AVX2, 64 B AVX-512, 64 B SVE-512) | Vektor-parallele Vergleiche | Bindet an spezifische ISA |
| **NUMA-Aware** | B-Trees Are Back (Mueller 2025), Naderan 2016 | Knoten-Replikation pro NUMA-Node | Skaliert auf Multi-Socket | Konsistenz-Overhead |

### Praxis-Empfehlung fuer PRT-ART

PRT-ART sollte als **Cache-Aware mit Plattform-Adapter** implementiert werden:
1. ISearchPageStructure-Singletons fuer mindestens vier Familien: CSS-style, CSB+-style, ART-style, HOT-style, optional vEB-style.
2. ICacheStrategy laedt zur Initialisierung Plattform-spezifische Konstanten (`std::hardware_destructive_interference_size`, OS-Page-Size via `sysconf(_SC_PAGESIZE)`, Huge-Page via `MAP_HUGETLB`).
3. Hot/Cold-Split per ICacheLevel: L1 = haeufige Headers, L2 = normale INodes, L3/RAM = Cold-Payload.
4. Padding-Hardening durchgehend fuer Sync-Felder via `alignas(std::hardware_destructive_interference_size)`.
5. Facade-Singleton-Pattern wie in Sektion 3.3 - jede Layout-Strategie ist EIN Singleton, ein Tree haelt EINEN Verweis.

---

## Quellen

### Cache-Line-Architektur
- [Daniel Lemire's Blog: Measuring Cache Line Size Empirically (2023)](https://lemire.me/blog/2023/12/12/measuring-the-size-of-the-cache-line-empirically/)
- [Stony Brook A64FX Microarchitecture Manual](https://www.stonybrook.edu/commcms/ookami/support/_docs/A64FX_Microarchitecture_Manual_en_1.3.pdf)
- [Fujitsu A64FX Wikipedia](https://en.wikipedia.org/wiki/Fujitsu_A64FX)
- [LLVM D93169: A64FX 256-byte cache line support](https://reviews.llvm.org/D93169)
- [Mono ARM64 icache (Apple Silicon)](https://www.mono-project.com/news/2016/09/12/arm64-icache/)

### Cache-Conscious B+ Tree Research
- [Rao/Ross: Making B+-Trees Cache Conscious (SIGMOD 2000)](https://dl.acm.org/doi/10.1145/342009.335449)
- [Hankins/Patel: Effect of Node Size on Cache-Conscious B+-Trees (2003)](https://pages.cs.wisc.edu/~jignesh/publ/cci.pdf)
- [Chen et al.: Fractal Prefetching B+-Trees (SIGMOD 2002)](https://www.cs.cmu.edu/~chensm/papers/fpbtree.pdf)
- [Mueller/Benson/Leis: B-Trees Are Back (2025)](https://www.cs.cit.tum.de/fileadmin/w00cfj/dis/papers/btrees-are-back.pdf)

### Cache-Oblivious / vEB
- [Bender/Demaine/Farach-Colton: Cache-Oblivious B-Trees (SICOMP)](https://erikdemaine.org/papers/CacheObliviousBTrees_SICOMP/paper.pdf)
- [Demaine: Cache-Oblivious Algorithms (BRICS 2002)](https://erikdemaine.org/papers/BRICS2002/paper.pdf)
- [Ondracek: Cache-Oblivious Representation of B-Tree Structures (arxiv 2022)](https://arxiv.org/abs/2209.09166)
- [Brodal: Cache Oblivious Search Trees (SODA 2002)](https://www.cs.au.dk/~gerth/papers/soda02.pdf)

### Trie / ART / HOT / FAST
- [Leis et al.: ART - Adaptive Radix Tree (ICDE 2013)](https://www.db.in.tum.de/~leis/papers/ART.pdf)
- [Binna et al.: HOT - Height Optimized Trie (CMU 15-721 reading)](https://15721.courses.cs.cmu.edu/spring2019/papers/08-oltpindexes2/p521-binna.pdf)
- [Kim et al.: FAST - Fast Architecture Sensitive Tree (SIGMOD 2010)](http://kaldewey.com/pubs/FAST__SIGMOD10.pdf)
- [The Paper Trail: ART-ful radix trie summary](https://www.the-paper-trail.org/post/art-paper-notes/)

### CSS-Tree / Pointer Elimination
- [US Patent 6711562 - CSS Tree (Rao/Ross/Columbia)](https://patents.google.com/patent/US6711562B1/en)
- [Vinciguerra CSS-tree single-header C++11 implementation](https://github.com/gvinciguerra/CSS-tree)

### False Sharing / C++17 Hardware Interference
- [cppreference: hardware_destructive_interference_size](https://en.cppreference.com/w/cpp/thread/hardware_destructive_interference_size.html)
- [Wikipedia: False Sharing](https://en.wikipedia.org/wiki/False_sharing)
- [GCC Patch: Implement C++17 hardware interference size](https://www.mail-archive.com/gcc-patches@gcc.gnu.org/msg269055.html)
- [LLVM Discussion: hardware constructive/destructive interference size](https://discourse.llvm.org/t/rfc-c-17-hardware-constructive-destructive-interference-size/48674)

### Hot/Cold Split / Cache-Conscious Layouts
- [Microsoft Research: Cache-Conscious Data Structures](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/ccds.pdf)
- [VLDB 2020: Optimizing Cache Efficiency for In-memory KV Stores](http://www.vldb.org/pvldb/vol13/p1540-wang.pdf)

### Cache-Sensitive Memory Layout fuer Binary Trees
- [Bohannon/McIlroy/Rastogi: Cache-Sensitive Memory Layout (Springer)](https://link.springer.com/content/pdf/10.1007/978-0-387-09680-3_17.pdf)

### Design Patterns
- [Refactoring.guru: Facade Pattern](https://refactoring.guru/design-patterns/facade)
- [SourceMaking: Facade & Strategy](https://sourcemaking.com/design_patterns/facade)
- [VTNetzwelt: Facade and Strategy combined](https://www.vtnetzwelt.com/web-development-blog/design-patterns-a-deep-dive-into-facade-and-strategy-patterns/)

---

**Autor-Vermerk:** Diese Recherche stuetzt die Architektur-Korrekturen K02/K03/K14/U02/U09 fuer phase5_uml_detail_REV5 und liefert die Praezedenz fuer das 3-Schichten-Modell KONZEPT/STRATEGIE/PHYSISCH (Singleton-Interpreter-Pattern als Praezedenz aus FAST + LLVM TargetInfo).
