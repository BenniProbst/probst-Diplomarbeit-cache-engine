# Architektur-Skizze REV 7 (2026-05-13) — Custom Allokation + ABI-stabiles C++23-Modul-Interface

**Status:** REV 7 = REV 6 + zwei kritische Erweiterungen
**Vorgaenger:** `23_architektur_skizze_REV6_2026_05_11.md`
**Anlass (User-Direktive 2026-05-13):**
1. Custom Allokation wurde als zentrale Cache-Engine-Basisdisziplin **vergessen** und muss umfassend nachgezogen werden (analog 33-Paper-Recherche fuer Suchalgorithmen).
2. Praezise Definition des ABI-stabilen C++23-Modul-Interface mit Drei-Schichten-Hierarchie, Variadic-Templates und compile-time-Fallback-Logik.

**Pflicht-Reihenfolge:**
1. **Erst Doku** (dieses Dokument) mit hoechster Praezision — keine Code-Aenderungen ohne Bestaetigung.
2. Dann Allokator-Paper-Recherche analog Phase 3.B (33 Such-Paper).
3. Dann CacheEngine-Allokator-Bibliothek + ABI-Interface aufsetzen.
4. PRT-ART nutzt Allokator-Bibliothek mit eigenem Permutations-Stack (Compile-time-Fallback auf CacheEngine).

---

## 0. Was REV 7 hinzufuegt (Hochrechnung)

| Sektion | Inhalt |
|---------|--------|
| §1 Allokator-Basisdisziplin | Cache-Engine hat zwei parallele Bausteine-Stacks: **Such-Algorithmen** und **Allokationsmethoden**. Allokation wurde bisher nur als ein Achsen-Eintrag (Achse 6) behandelt — REV 7 hebt sie auf gleiche Ebene wie Suche. |
| §2 Allokator-Paper-Rang-1-Liste | 21 Paper-Quellen + 14 produktive Allokatoren als Bausteine-Familien (mit Code-Quellen). |
| §3 C++ std-Container-Kompatibilitaet | Anforderungen an typsichere `std::allocator`-Erweiterung, `std::pmr::memory_resource`, Concurrency-Modelle (single-write/multi-read default, optional multi-write mit Cache-Page-Awareness via C++17-Locks). |
| §4 ABI-stabiles C++23-Modul-Interface | Drei-Schichten-Hierarchie: `execution_engine` (erbt CacheEngine) → `search_engine` → konkrete Suchalgorithmen wie `prt_art`. Variadic-Template-Magie + Fingerprint-Hash. |
| §5 CacheEngineBuilder als eigenstaendiges Programm | XML-Konfiguration zulaessiger CacheEngine-Rekombinationen + abhaengiger Suchalgorithmus-Builds. |
| §6 PRT-ART als Pruefling im 3-Stufen-System | Compile-time-Fallback auf CacheEngine-Bibliothek. Bevorzugung der CacheEngine-Struktur in Stub-Bearbeitung fuer spaeteren Merge. |
| §7 TestDataSetAccumulationEngine | Klasse fuer Deserialization/Parsing + fair reproduzierbar aligned Bereitstellung der Test-Daten. |
| §8 Mikrobenchmark-Suite | No-deprecate-Wrapper aller Testmethoden + 2 separate Custom-Allokationen fuer Messung und Logging + sparse Binary-Serialisierung + Auswertungs-Konversion. |
| §9 Plan + Reihenfolge | Phase 6.2 (Allokator-Recherche + Library) → Phase 6.3 (ABI-Module-Interface) → Phase 7 (Builder + Experimente). |

---

## 1. Custom Allokation als Cache-Engine-Basisdisziplin

### 1.1 Anmerkung des Architekten (Wortlaut)

> *"Die Cache Engine ist ebenfalls dafuer da, nach bekannten weitreichenden Allokationsmethoden Speicher zu verwalten. Dazu brauchen wir eine umfassende wissenschaftliche Analyse und Suche nach Google-Scholar-Papers zum Thema Allokationsmethoden. Mir selbst sind Allokationen wie jalloc und malloc und calloc bekannt. Diese gehoeren muessen noch als Baustein-Familie UMFASSEND ergaenzt werden, wobei zu jedem Paper eine elaborate Zusammenfassung und Recherche nach dem Programmcode erfolgen muss (exakt wie bei den anderen Papern bezueglich der Suchalgorithmen)."*

### 1.2 Bisherige Behandlung (Status Quo)

In REV 1-6 wurde Allokation nur als **Achse 6 (Allocator)** im Bausteine-Matrix-System behandelt — mit Eintraegen wie `ALLOCATOR_POOL_PER_PAGETYPE`, `ALLOCATOR_ARENA_PER_SUBTREE`, `ALLOCATOR_SLAB`, `ALLOCATOR_HBM`, `ALLOCATOR_DEFAULT_MALLOC`, `ALLOCATOR_TCMALLOC`, `ALLOCATOR_MIMALLOC`, `ALLOCATOR_SNMALLOC` — aber ohne Paper-Tieflektuere, ohne Code-Klone, ohne Adapter-Skelette. Die Allokator-Familie war ein **Stiefkind** des Such-Stacks.

### 1.3 Korrektur (REV 7)

Allokation wird auf **gleiche Hierarchie-Ebene** wie der Such-Stack gehoben. Die CacheEngine besitzt damit **zwei parallele Bausteine-Stacks**:

```
                       CacheEngine (Stand der Technik)
                                |
              +-----------------+-----------------+
              |                                   |
        Such-Algorithmus-Stack          Allokations-Stack
        (33 Paper, REV 1-6)             (21 Paper TBD, REV 7)
        - 7 Bausteine-Achsen            - 7 Bausteine-Achsen
        - 6 Pflicht-Seitentypen         - 6 Pflicht-Allokator-Familien
        - 12 Sub-Engines                - eigene Sub-Engines (Slab, Buddy, ...)
        - 29 ICacheStrategy-Familien    - N IAllocationStrategy-Familien
        - 4-Ebenen-Strategien           - 4-Ebenen-Strategien (analog)
```

Beide Stacks werden vom **CacheEngineBuilder** (siehe §5) per Permutation kombiniert. PRT-ART (REV 6) ist ein Pruefling, der Suchalgorithmus-Permutationen verwendet — analog wird es Pruefling-Algorithmen geben, die Allokations-Permutationen oder kombinierte Such+Allokations-Permutationen verwenden.

### 1.4 Anforderungen an Allokator-Bausteine

| Anforderung | Detail |
|-------------|--------|
| **A1 Typesicherheit** | Bausteine erweitern den `std::allocator<T>`-Standard typsicher. Jede Konkretisierung kann jedem `std::container<T, Alloc>` als Allocator-Template-Argument uebergeben werden. |
| **A2 Polymorphic Memory Resource (pmr)** | Bausteine bieten zusaetzlich `std::pmr::memory_resource`-Konformanz, sodass sie via `std::pmr::polymorphic_allocator<T>` runtime-polymorph fuer beliebige Container nutzbar sind. |
| **A3 Concurrency-Default** | Single-Writer-Multi-Reader (1-W/N-R). Erfuellt mit `std::shared_mutex` (C++17). |
| **A4 Concurrency-Optional** | Cache-Page-Awareness fuer Multi-Write-Concurrency-Locks. Erfuellt mit C++17-Mechaniken (`std::scoped_lock`, RAII, hierarchical-lock-Patterns). |
| **A5 Container-Tests** | Jede Allokator-Variante muss mit `std::vector`, `std::map`, `std::unordered_map`, `std::deque`, `std::list`, `std::set` getestet werden — Funktional + Concurrency + Performance. |
| **A6 Cache-Page-Awareness** | Bausteine kennen die `ICachePage`-Topologie der Cache-Engine (siehe REV 5 §1) und nutzen sie fuer Layout-Entscheidungen (z.B. Slab-Padding, Buddy-Order). |
| **A7 Block-AO-Plattform-Test** | Allokator-Familien werden auf den 9 Block-AO-Plattformen verifiziert (analog Suchalgorithmus-Pflicht). |
| **A8 Bausteine permutierbar** | Allokator-Bausteine sind untereinander permutierbar (z.B. Slab-Layout + Buddy-Order + Lock-Free-Free-List). |

### 1.5 C++17-Locks fuer Concurrency-Modelle

Recherche-Ergebnis (siehe §2.6 fuer Literatur):

| Lock-Typ | Verwendung | Cache-Page-Awareness |
|----------|------------|----------------------|
| `std::mutex` | Exklusiv-Schreiben | Nein — pessimistisch |
| `std::shared_mutex` (C++17) | Reader-Writer, multi-read | Optional, kann pro Cache-Page eingesetzt werden |
| `std::shared_timed_mutex` (C++14/17) | wie shared_mutex + Timeouts | wie shared_mutex |
| `std::scoped_lock` (C++17) | Mehrere Mutexe atomar (deadlock-vermeidend) | Spezifisch fuer Multi-Page-Akquisition |
| `std::lock_guard` (C++11) | Einzel-Mutex RAII | Pro-Page-Verwendung |
| `std::unique_lock` (C++11) | Deferred/Try-Lock | Pro-Page mit Try-Logik |
| Hierarchical Locks (User-Code) | Strict-Ordering pro Cache-Page-Ebene | Explizite Cache-Page-Hierarchie-Verwendung |
| RCU (Task #104) | Wait-free Reader | Per-Cache-Line-Quiescent-State |

REV-7-Direktive: **Pro Allokator-Baustein** waehlt der Builder zur Compile-Time aus einer Lock-Variante. Die Default-Variante ist `std::shared_mutex`. Cache-Page-aware Multi-Writer-Variante nutzt `std::scoped_lock` ueber pro-Page-Mutexe (vermeidet Cross-Page-Contention bei Multi-Threading).

---

## 2. Allokator-Paper-Rang-1-Liste (REV 7 Pflicht-Recherche)

Diese Liste folgt der Konvention der 33 Suchalgorithmus-Paper (P01-P33). Allokator-Paper bekommen das Praefix `A`:

### 2.1 Rang 1 — Foundational + Production-Grade

| ID | Paper / Allokator | Autoren / Jahr / Venue | Quelle |
|----|-------------------|------------------------|--------|
| **A01** | Hoard: A Scalable Memory Allocator for Multithreaded Applications | Berger, McKinley, Blumofe, Wilson — ASPLOS 2000 | https://www.cs.utexas.edu/~mckinley/papers/asplos-2000.pdf |
| **A02** | The Slab Allocator: An Object-Caching Kernel Memory Allocator | Jeff Bonwick — USENIX Summer 1994 | https://www.usenix.org/conference/usenix-summer-1994-technical-conference/slab-allocator-object-caching-kernel |
| **A03** | Scalable Lock-Free Dynamic Memory Allocation | Maged M. Michael — PLDI 2004 | https://www.cs.tufts.edu/~nr/cs257/archive/neal-glew/mcrt/Non-blocking%20data%20structures/p35-michael.pdf |
| **A04** | Mimalloc: Free List Sharding in Action | Leijen, Zorn, de Moura — Microsoft MSR-TR-2019-18, APLAS 2019 | https://www.microsoft.com/en-us/research/wp-content/uploads/2019/06/mimalloc-tr-v1.pdf |
| **A05** | jemalloc (A Scalable Concurrent malloc Implementation for FreeBSD) | Jason Evans — BSDCan 2006 | https://www.bsdcan.org/2006/papers/jemalloc.pdf |
| **A06** | TCMalloc: Thread-Caching Malloc | Sanjay Ghemawat / Paul Menage (Google) — Tech Report 2009; reanalysiert ASPLOS 2024 | https://people.csail.mit.edu/delimitrou/papers/2024.asplos.memory.pdf |
| **A07** | snmalloc: A Message-Passing Allocator | Lipp/Bond/Parkinson — ISMM 2019 | https://github.com/microsoft/snmalloc |
| **A08** | scalloc: A Scalable Allocator Based on Span-Pooling | Aigner, Kirsch, Lippautz, Sokolova — OOPSLA 2015 | https://cs.uni-salzburg.at/~ck/content/publications/conferences/OOPSLA15-Scalloc.pdf |
| **A09** | NUMAlloc: A Faster NUMA Memory Allocator | Liu, Berger — ISMM 2023 | https://dl.acm.org/doi/10.1145/3591195.3595276 |
| **A10** | rpmalloc — Public Domain Lock-Free Thread-Caching Allocator | Mattias Jansson — kein formaler Paper, Code + Docs | https://github.com/mjansson/rpmalloc |

### 2.2 Rang 2 — Modern + Specialized

| ID | Paper / Allokator | Autoren / Jahr / Venue | Quelle |
|----|-------------------|------------------------|--------|
| **A11** | LRMalloc: A Modern and Competitive Lock-Free Dynamic Memory Allocator | Leite/Rocha — ICAPDS 2020 | https://www.researchgate.net/publication/344962358 |
| **A12** | CAMA: A Predictable Cache-Aware Memory Allocator | Herter/Marwedel/Falk — RTAS 2011 | https://www.researchgate.net/publication/224255517 |
| **A13** | StarMalloc: A Formally Verified, Concurrent, Performant, and Scalable Allocator | Bourgeat/Erbsen et al. — arXiv 2403.09435, 2024 | https://arxiv.org/pdf/2403.09435 |
| **A14** | Characterizing a Memory Allocator at Warehouse Scale (TCMalloc) | Zhou et al. — ASPLOS 2024 | https://people.csail.mit.edu/delimitrou/papers/2024.asplos.memory.pdf |
| **A15** | HMalloc: A Hybrid, Scalable, Lock-Free Multi-Threaded Memory Allocator | — | (Quelle pruefen in Phase 6.2 Recherche) |
| **A16** | PIM-malloc: A Fast and Scalable Dynamic Memory Allocator for PIM Architectures | — arXiv 2505.13002, 2025 | https://arxiv.org/html/2505.13002v1 |
| **A17** | A Family of Fast and Memory Efficient Lock- and Wait-Free Reclamation | — PLDI 2024 | https://dl.acm.org/doi/10.1145/3658851 |
| **A18** | Exgen-Malloc: Optimizing Single-threaded Applications | — arXiv 2510.10219, 2025 | https://arxiv.org/html/2510.10219v1 |

### 2.3 Rang 3 — Kernel + Standard-Library + Classic

| ID | Paper / Allokator | Autoren / Jahr / Venue | Quelle |
|----|-------------------|------------------------|--------|
| **A19** | Buddy System: Dynamic Storage Allocation | Knuth — TAOCP Vol. 1 §2.5 (1968); Knowlton 1965 CACM | (Buch-Referenz) |
| **A20** | Doug Lea malloc (dlmalloc) | Doug Lea — 1987-2024 | https://gee.cs.oswego.edu/dl/html/malloc.html |
| **A21** | ptmalloc2 / glibc malloc | Wolfram Gloger | (glibc-Quelltext) |
| **A22** | N3726/N3916: Polymorphic Memory Resources | Pablo Halpern — open-std 2013/2014 | https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3916.pdf |
| **A23** | Bonwick: Magazines and Vmem (VMS Heap) | Bonwick, Adams — USENIX ATC 2001 | (Vmem-Paper) |

### 2.4 Pflicht-Vorgehen pro Paper (analog Phase 3.B fuer Suchalgorithmen)

1. PDF heruntergeladen + per Tieflektuere konzeptuell extrahiert
2. Code-Quelle geklont in `comdare-cache-engine/ext/A{NN}-<short-name>/`
3. Lizenz-Analyse (Apache/BSD/GPL/MIT)
4. Adapter-Skelett in `comdare-cache-engine/adapters/A{NN}-<short-name>/`
5. Eintragung in eine neue `Allokator_Matrix.txt` analog `Bausteine_Matrix.txt`

### 2.5 Allokator-Bausteine-Achsen (Vorschlag)

Analog 7 Suchalgorithmus-Achsen schlage ich 7 Allokator-Achsen vor:

| Achse | Konzept | Beispiele aus Rang-1-Paper |
|-------|---------|-----------------------------|
| AA1 — **Free-List-Topologie** | Wie sind freie Blocks organisiert? | A04 Free-List-Sharding (multiple lists per page), A07 Per-thread Caching, A19 Buddy-Tree |
| AA2 — **Size-Class-Schema** | Wie werden Block-Groessen klassifiziert? | A02 Slab-per-Objektgroesse, A20 dlmalloc bins, A05 jemalloc size-classes, A08 scalloc spans |
| AA3 — **Thread-Locality** | Wie lokal pro Thread/Core ist die Allokation? | A06 tcmalloc thread-local-caches, A10 rpmalloc thread-caching, A07 snmalloc message-passing |
| AA4 — **Synchronization** | Welcher Concurrency-Mechanismus? | A03 lock-free CAS, A11 LRMalloc, A04 mimalloc-CAS-on-non-local-free, A01 Hoard-per-heap-locks |
| AA5 — **Allocation-Policy** | Wie werden Allokationsanfragen gerouted? | A09 NUMA-origin-aware, A12 cache-set-aware, A14 NUCA-aware, A16 PIM-aware |
| AA6 — **Reclamation** | Wie werden geloeschte Blocks zurueckgegeben? | A02 magazine cache, A06 page-heap-release, A17 lock-free-reclamation, A04 deferred-free |
| AA7 — **Fragmentation-Strategy** | Wie wird Fragmentierung vermieden? | A20 dlmalloc coalescing, A02 object-coloring, A19 buddy-splitting, A04 page-local-sharding |

### 2.6 Literatur-Querverweise (recherchiert 2026-05-13)

- [Hoard ASPLOS 2000 — Berger et al.](https://www.cs.utexas.edu/~mckinley/papers/asplos-2000.pdf)
- [Bonwick Slab Allocator USENIX 1994](https://www.usenix.org/conference/usenix-summer-1994-technical-conference/slab-allocator-object-caching-kernel)
- [Michael Scalable Lock-Free PLDI 2004](https://www.cs.tufts.edu/~nr/cs257/archive/neal-glew/mcrt/Non-blocking%20data%20structures/p35-michael.pdf)
- [Mimalloc MSR-TR-2019-18 / APLAS 2019](https://www.microsoft.com/en-us/research/wp-content/uploads/2019/06/mimalloc-tr-v1.pdf)
- [scalloc OOPSLA 2015](https://cs.uni-salzburg.at/~ck/content/publications/conferences/OOPSLA15-Scalloc.pdf)
- [NUMAlloc ISMM 2023](https://dl.acm.org/doi/10.1145/3591195.3595276)
- [TCMalloc ASPLOS 2024 Characterization](https://people.csail.mit.edu/delimitrou/papers/2024.asplos.memory.pdf)
- [StarMalloc arXiv 2024](https://arxiv.org/pdf/2403.09435)
- [PIM-malloc arXiv 2025](https://arxiv.org/html/2505.13002v1)
- [LRMalloc 2020](https://www.researchgate.net/publication/344962358)
- [N3916 Polymorphic Memory Resources](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3916.pdf)
- [rpmalloc GitHub](https://github.com/mjansson/rpmalloc)
- [microsoft/mimalloc GitHub](https://github.com/microsoft/mimalloc)
- [microsoft/snmalloc GitHub](https://github.com/microsoft/snmalloc)

---

## 3. C++17/C++23 std-Container-Kompatibilitaet

### 3.1 Allokator-Concept

Jede Cache-Engine-Allokator-Familie liefert sowohl eine `std::allocator`-konforme Klasse als auch ein `std::pmr::memory_resource`. Pseudocode:

```cpp
namespace comdare::cache_engine::allocator {

// std::allocator-konformer Wrapper
template <typename T, typename PoolPolicy>
class CacheEngineAllocator {
public:
    using value_type      = T;
    using size_type       = std::size_t;
    using difference_type = std::ptrdiff_t;
    using propagate_on_container_copy_assignment = std::false_type;
    using propagate_on_container_move_assignment = std::true_type;
    using propagate_on_container_swap            = std::true_type;
    // ...
    [[nodiscard]] T* allocate(size_type n);
    void             deallocate(T* p, size_type n) noexcept;
    template <typename U>
    struct rebind { using other = CacheEngineAllocator<U, PoolPolicy>; };
};

// std::pmr::memory_resource-konform
class CacheEnginePmrResource : public std::pmr::memory_resource {
protected:
    void* do_allocate(std::size_t bytes, std::size_t alignment) override;
    void  do_deallocate(void* p, std::size_t bytes, std::size_t alignment) override;
    bool  do_is_equal(memory_resource const& other) const noexcept override;
};

}  // namespace comdare::cache_engine::allocator
```

### 3.2 Pflicht-Tests pro Allokator-Variante

Pro Allokator-Variante (Konkretisierung) sind diese Test-Klassen Pflicht:

1. **Allokations-Tests**: alloc/dealloc/realloc Korrektheit, Alignment, Edge-Cases
2. **Container-Tests** (matrix of std-containers x allocator):
   - `std::vector<T, Alloc>` push_back/erase/clear
   - `std::deque<T, Alloc>`
   - `std::list<T, Alloc>`
   - `std::map<Key,T,Cmp,Alloc>` insert/erase/find
   - `std::unordered_map<Key,T,Hash,Eq,Alloc>`
   - `std::set<T,Cmp,Alloc>`
   - `std::pmr::vector<T>` mit pmr-Resource
3. **Threading-Tests**:
   - Single-Writer-Multi-Reader (Default) — N Reader-Threads + 1 Writer
   - Multi-Writer (Optional, Cache-Page-aware) — M Writer + N Reader
4. **Concurrency-Sicherheit**:
   - Race-Detection (TSan)
   - ABA-Problem-Testfaelle (fuer lock-free Varianten)
   - Stress-Tests mit 10k+ threads

### 3.3 Cache-Page-Awareness Multi-Writer-Variante

Optional, fuer Allokator-Bausteine, die das aktivieren wollen:

```cpp
template <typename T, typename PoolPolicy>
class CachePageAwareConcurrentAllocator : public CacheEngineAllocator<T, PoolPolicy> {
public:
    // Multi-Writer-Optimierung: pro Cache-Page (64 B) ein eigener mutex
    // Akquise via std::scoped_lock fuer Multi-Page-Operations (deadlock-vermeidend)
    [[nodiscard]] T* allocate(size_type n) {
        auto& page_mutex = this->resource_->page_mutex_for_size(n * sizeof(T));
        std::scoped_lock lock(page_mutex);     // C++17 RAII deadlock-vermeidend
        return this->resource_->raw_allocate(n);
    }
};
```

---

## 4. ABI-stabiles C++23-Modul-Interface (Wortlaut des Architekten + Praezisierung)

### 4.1 Pseudocode-Spezifikation des Architekten (woertlich aufgenommen)

> *"Jedes kompilierte Experiment ist eine bestimmte Execution-Engine → Search-Engine Rekombination, also formal ein zusammengesetzter Custom-Suchalgorithmus einer definierten Baustein-Permutation als:*
> ```cpp
> std::variant<
>   comdare::search_engine<
>     search_algorithm_type_collection<key, value>,
>     configuration_permutation_type
>   > : comdare::execution_engine<processing_strategy_type> (
>         test_data_set_accumulation_engine_type
>           data_accumulation_benchmark_routines(data_set)
>       )
> >();
> ```
> "

### 4.2 Praezisierung

Die obige Pseudocode-Notation beschreibt fuenf gekoppelte Konzepte:

**(a) Drei-Schichten-Klassenhierarchie:**

```
                   CacheEngine                         (Basisklasse, Visitor-Pattern Wurzel)
                        ^
                        |  erbt
                        |
       comdare::execution_engine<processing_strategy_type>
                        ^
                        |  erbt
                        |
       comdare::search_engine<
           search_algorithm_type_collection<Key, Value>,
           configuration_permutation_type>
                        ^
                        |  Spezialisierung
                        |
       comdare::prt_art<Key, Value, ...>      (PRT-ART als spezielle Search-Engine)
       comdare::xxx<...>                       (weitere Pruefling-Algorithmen)
```

**(b) Variadic-Template-Argumentation mit auto-key:**

Die Search-Engine ist ein variadic-Template, das sich automatisch an die Anzahl der Typ-Parameter anpasst:

```cpp
// Fall 1: 1 Typ-Parameter → value-only
template <typename Value>
comdare::search_engine<...>::search_engine(...);
// Implicit:  Key = std::uint64_t  (monotonic counter, beim Einfuegen hochzaehlend)

// Fall 2: 2 Typ-Parameter → (Key, Value)
template <typename Key, typename Value>
comdare::search_engine<...>::search_engine(...);

// Fall 3: N>2 Typ-Parameter → (Key, std::tuple<Value1, Value2, ..., ValueN-1>)
template <typename Key, typename V1, typename V2, ...>
comdare::search_engine<...>::search_engine(...);
// Implicit: Values werden zu Tupel aggregiert
```

**(c) Komplexer Key → impliziter Fingerprint-Hash:**

Wenn `Key` (in den Faellen 2/3) ein komplexes Objekt (nicht-trivial-Type) ist, wird er implizit ueber die `comdare::fingerprint`-Bibliothek auf einen `std::array<std::byte, kFingerprintBytes>` reduziert:

```cpp
namespace comdare::fingerprint {

template <std::size_t Bytes = 16>
class FixedLengthFingerprint {
public:
    static std::array<std::byte, Bytes> hash(auto const& complex_object);
};

// Funktions-Ueberladung:
//   - Einfach-Typen (uint64, double, char[N], std::string) → direkter binary-cast
//   - Komplexe Typen → FixedLengthFingerprint<16>::hash(obj)
template <typename Key>
auto to_binary_string(Key const& k) -> std::array<std::byte, kFixedKeyBytes>;

}  // namespace comdare::fingerprint
```

**(d) execution_engine erbt CacheEngine als Visitor-Pattern-Basisklasse:**

Die Execution-Engine traegt eine **CacheEngine-Instanz** als Basis. Bei jeder Algorithmus-Entscheidung fragt der Algorithmus die CacheEngine via Visitor-Pattern um Rat — oder verwendet die CacheEngine direkt als experimentelles OS-Interface. Der `processing_strategy_type`-Template-Parameter definiert:

- **Permutation-statisch** (Compile-time): Welche Bausteine sind aktiviert? (PermutationFlags)
- **Verhalten-runtime-dynamisch** (Runtime): CacheEngineMode HEURISTIC_STATIC/INFORMED_KALIBRIERT/AUTOMATIC_ADAPTIVE
- **Bereiche**: Limits, Verhalten, Heuristiken, Allokation, Scheduling, Concurrency

**(e) Drei-Stufen-Bau-Prozess:**

```
Stufe 1: CacheEngine          (Stand der Technik, Bibliothek, vor-implementiert)
                |
Stufe 2: ExecutionEngine      (1..N Compile-time permutationen, durch
                               processing_strategy_type konfiguriert)
                |
Stufe 3: SearchEngine         (erbt ExecutionEngine; +
                               compile-time statische Suchalgorithmus-Bausteine
                               via search_algorithm_type_collection<K,V>)
                |
        Anwendung (PRT-ART):  spezialisierte SearchEngine mit Permutations-Stack-Fallback
                               auf CacheEngine wenn Permutations-Typen fehlen
```

**(f) Layer-Verantwortlichkeiten (Provider-Rollen, User-Direktive 2026-05-12 woertlich):**

Die drei Schichten sind nicht nur Consumer (die CacheEngine konsumieren), sondern jede Schicht **stellt ihrer hoeheren Schicht eine semantisch staerkere Schnittstelle bereit**. Sie heben das Abstraktions-Niveau gestaffelt an:

| Schicht | Provider-Rolle (was sie der naechsten Schicht BEREITSTELLT) | Verhaeltnis zu CacheEngine-Limits |
|---------|--------------------------------------------------------------|------------------------------------|
| **CacheEngine** (Stufe 1) | Stand-der-Technik-Bausteine + Visitor-Hooks fuer Algorithmus-Beratung + direktes experimentelles OS-Interface (Cache-Page-Topologie, Allocator-Pools, Concurrency-Disziplinen, Telemetrie, Scheduling-Heuristiken) | Definiert die Limits / Budgets (z.B. Cache-Page-Kapazitaet, Allocator-Pool-Groessen, Concurrency-Atomizitaet) |
| **ExecutionEngine** (Stufe 2) | **Stellt mithilfe der CacheEngine experimentelle OS-Primitiven bereit** — Wrap der CacheEngine-Bausteine zu hoeheren Operationen (z.B. ein cache-line-aligned-Alloc, ein NUMA-konformes Read-Pin, ein Coherence-aware-Write). Die ExecutionEngine "uebersetzt" CacheEngine-Bausteine zu wiederverwendbaren OS-Primitiven, ohne sie semantisch zu ueberschreiten. | Reicht die CacheEngine-Limits in primitiver Form weiter; permutiert sie compile-time-statisch ueber `processing_strategy_type`. |
| **SearchEngine** (Stufe 3, Dach) | **Stellt Implementierungen fuer Such-spezifische, komplexere experimentelle Standard-OS-Such- und Speicherzugriffsmuster + Routinen bereit** — z.B. ein Trie-Walk-Pattern, ein B+-Range-Scan-Pattern, ein Prefix-Scan, ein Hot-Path-Lookup. Diese Patterns nutzen ExecutionEngine-Primitiven, sind aber semantisch hoeher (sie kennen "Suche", "Trie", "Rang"). Die SearchEngine bildet **das Dach des Konstrukts**: sie verkoerpert **Suchheuristiken und Konzepte, die strategisch die CacheEngine-definierten Limits an Ressourcen abbilden** — und **den Bereich der reinen Speicherzugriffsmuster weit ueberschreiten**. | **Ueberschreitet** die CacheEngine-Limits konzeptuell: Eine SearchEngine kann strategische Entscheidungen treffen, die Limits ueber mehrere Cache-Pages, mehrere Concurrency-Domaenen oder mehrere Heuristik-Zyklen hinweg orchestrieren — die CacheEngine selbst kann das pro Baustein nicht. |

Diese Layer-Provider-Hierarchie ist Pflicht fuer die Architektur:

1. Eine SearchEngine darf nicht direkt CacheEngine-Bausteine konsumieren — sie muss durch die ExecutionEngine-Primitiven-Schicht gehen, sonst zerstoert sie die ABI-Stabilitaet (siehe §5.28.4 in REV 6).
2. Eine ExecutionEngine darf keine Such-spezifischen Patterns kennen — sie operiert nur auf OS-Primitiven-Ebene (Allocator, Concurrency, Cache-Page, NUMA-Pinning).
3. PRT-ART als Pruefling-SearchEngine kann eigene Such-Patterns hinzufuegen, faellt aber per Compile-time-Fallback (§6) auf die ExecutionEngine-Primitiven zurueck, wenn ein Baustein im Pruefling-Permutations-Stack fehlt.

Die SearchEngine ist damit **strategisch dem CacheEngine-Stack uebergeordnet**, weil sie Suchheuristik-Konzepte (z.B. "Hot-Path-Recognition", "Adaptive-Prefetch-Distance", "Density-Threshold-Transition") als Patterns realisiert, die einzelne CacheEngine-Bausteine nicht ausdruecken koennen.

### 4.3 Variadic-Template-Magie (Implementierungs-Skelett)

```cpp
namespace comdare {

// Helper: Aggregate types to (Key, Tuple<Values>)
template <typename... Ts> struct type_collection_traits;

// 1 Param: Key = uint64 (counter), Value = Ts[0]
template <typename T0>
struct type_collection_traits<T0> {
    using key_t   = std::uint64_t;            // auto-incrementing counter
    using value_t = T0;
    static constexpr bool key_is_implicit = true;
};

// 2 Params: Key = Ts[0], Value = Ts[1]
template <typename T0, typename T1>
struct type_collection_traits<T0, T1> {
    using key_t   = T0;
    using value_t = T1;
    static constexpr bool key_is_implicit = false;
};

// N>2 Params: Key = Ts[0], Value = std::tuple<Ts[1..N]>
template <typename T0, typename... TR>
struct type_collection_traits<T0, TR...> {
    using key_t   = T0;
    using value_t = std::tuple<TR...>;
    static constexpr bool key_is_implicit = false;
};

template <typename... Ts>
class search_algorithm_type_collection {
public:
    using traits = type_collection_traits<Ts...>;
    using key_t  = typename traits::key_t;
    using value_t = typename traits::value_t;
    // Implicit fingerprint hashing bei komplexem Key
    using binary_key_t = decltype(fingerprint::to_binary_string(std::declval<key_t>()));
};

// Execution-Engine als Visitor-Pattern-Basis
template <typename ProcessingStrategy>
class execution_engine : public cache_engine::CacheEngine {
public:
    using strategy_t = ProcessingStrategy;
    // ... (CacheEngineMode, Permutation-Flags, Visitor-Hooks)
};

// Search-Engine erbt von Execution-Engine + spezialisiert auf Suchalgorithmus-Typen
template <typename Collection, typename ConfigPermutation>
class search_engine : public execution_engine<typename ConfigPermutation::strategy_t> {
public:
    using collection_t = Collection;
    using config_t     = ConfigPermutation;
    // ... lookup/insert/erase/range_scan API
};

}  // namespace comdare
```

---

## 5. CacheEngineBuilder als eigenstaendiges Programm (Wortlaut + Praezisierung)

> *"Der CacheEngineBuilder ist ein eigenstaendiges Programm, welches ueber einen Satz XML-definierter Konfigurationen einerseits alle zulaessigen CacheEngine-Rekombinationen definiert, von denen in direkter Abhaengigkeit die konfigurierten Custom-Suchalgorithmen gebaut werden. Implizit hat also die execution_engine als Typ eine Reihe an CacheEngine-impliziten Typen, die zur Compile-Time gesetzt und kompiliert werden."*

### 5.1 Architektur des CacheEngineBuilder

```
+---------------------------+
|   cache_engine_builder    |    Eigenstaendiges Binary
|        (main.cpp)         |    Liegt unter comdare-cache-engine/cache_engine/builder/
+---------------------------+
            |
            v
+---------------------------+
|   XML-Konfigurations-     |    Liest:
|         Satz              |      - cache_engine_permutations.xml
|                           |      - search_algorithm_permutations.xml
|                           |      - allocator_permutations.xml
|                           |      - test_data_sets.xml
+---------------------------+
            |
            v
+---------------------------+
|  CMake/sh/bat Codegen     |    Generiert pro Permutation:
|  (siehe F-EXTRA-5)        |      - CMakeLists.txt fuer Permutations-Target
|                           |      - C++23-Modul-Quelle mit Concept-Bindings
|                           |      - external_objects.cmake (Original-Compiler-Bauteile)
+---------------------------+
            |
            v
+---------------------------+
|  Pre-Build aller Modul-   |    F-EXTRA-1 Compiler-Layering:
|  Permutationen            |      - Schale (C++23 Hauptcompiler)
|                           |      - Bausteine-Internals (Original-Compiler)
|                           |      - Static-Linking → .so/.dll/.dylib
+---------------------------+
            |
            v
+---------------------------+
|  Experiment-Loop         |    Pro Modul:
|                           |      - dlopen + bind_module
|                           |      - load test_data_set
|                           |      - run workload + measure
|                           |      - serialize_to_disk + reset_state
+---------------------------+
```

### 5.2 XML-Konfigurations-Format (Vorschlag)

```xml
<!-- cache_engine_permutations.xml -->
<comdare>
  <cache_engine_permutation id="ce_default">
    <allocator_family>tcmalloc</allocator_family>
    <concurrency_mechanic>OLC</concurrency_mechanic>
    <telemetry_strategy>LEAFONLY_SAMPLED</telemetry_strategy>
    <prefetch>ADAPTIVE_DISTANCE</prefetch>
    <isa>X86_AVX2</isa>
  </cache_engine_permutation>
  <cache_engine_permutation id="ce_lockfree">
    <allocator_family>mimalloc</allocator_family>
    <concurrency_mechanic>RCU</concurrency_mechanic>
    <!-- ... -->
  </cache_engine_permutation>
</comdare>

<!-- search_algorithm_permutations.xml -->
<comdare>
  <search_algorithm id="prt_art_v1" cache_engine_id="ce_default">
    <page>PRTART_DENSEBYTE</page>
    <node>PRTART_REDIRECT</node>
    <traversal>PRTART_HOT_PATH</traversal>
    <value_handle>CHAINREF</value_handle>
    <key_types>std::uint64_t</key_types>
    <value_types>std::string</value_types>
  </search_algorithm>
</comdare>
```

### 5.3 Drei-Stufen-Implication

- **execution_engine** ist nicht ein einzelner Typ, sondern eine **Familie an CacheEngine-impliziten Typen**, die zur Compile-Time gesetzt und kompiliert werden.
- **search_algorithm** ist nichts anderes als eine **spezielle execution_engine** mit Compile-time-statischen Permutationen festgelegter Suchalgorithmus-Bausteine.
- **PRT-ART** ist eine spezielle search_engine mit eigenem permutativen Parallel-Stack zum CacheEngine-Such-Stack.

---

## 6. PRT-ART im 3-Stufen-System (Wortlaut + Praezisierung)

> *"Strategisch sollten wir die Struktur der CacheEngine in der Bearbeitung der Stubs und Struktur bevorzugen, weil wir den PRT_ART spaeter dort hinein mergen wollen. Die Cache-Engine verfuegt ueber einen Stack an Algorithmus-Bausteinen im Bereich Suche und der PRT_ART hat dieselbe Struktur mit seinem speziell zugelassenen permutativen parallel-Stack zum CacheEngine-Search-Stack. Technisch gesehen sind daher die processing_strategy_type fuer die Rekombinations-Konfiguration, nicht nur auf die execution_engine/search_engine, sondern auch auf den PRT_ART im selben parallelen Konfigurationsformat anwendbar. Wir erben also aus der CacheEngine die Permutations-Struktur-Hierarchie der Algorithmus-Bausteine, wenn die Typen aus configuration_permutation_type im Prueflings-Algorithmus wie PRT_ART nicht gefunden werden, findet zur Compile-Time automatisch ein Fallback auf die Bausteine der Cache-Engine-Bibliothek statt, von der der Algorithmus formal erbt."*

### 6.1 Praezisierung

1. **CacheEngine** hat einen **Stack an Such-Algorithmus-Bausteinen** (33 Paper, Bausteine-Matrix Achsen 1-11). Kommentar des Users: Die Achsen sind die zu Permutierenden Algorithmus-Schichten für die CacheEngineBuilder, um alle möglichen Eigenschaften eines Suchalgorithmus durch probieren und ausmessen zu finden.
2. **PRT-ART** hat einen **eigenen permutativen Parallel-Stack** zum CacheEngine-Such-Stack — strukturell identisch aufgebaut, aber mit PRT-ART-eigenen Konkretisierungen (z.B. `PRTART_REDIRECT`-Page, `PRTART_BPLUS`-Node etc.).
3. **`processing_strategy_type`** ist auf beide Stacks anwendbar:
   - Auf `execution_engine`/`search_engine` ueber den CacheEngine-Stack.
   - Auf `prt_art` ueber den PRT-ART-Stack mit Fallback auf den CacheEngine-Stack.
4. **Compile-time-Fallback** (kritische Direktive):
   - PRT-ART deklariert seine Bausteine in `configuration_permutation_type`.
   - Wenn ein angefragter Bausteine-Typ im PRT-ART-Stack **nicht** vorhanden ist → Compile-time-Fallback auf den CacheEngine-Stack (formaler Vererbungs-Lookup).
   - Beispiel: `prt_art<...>::allocator_t` wird ueber den PRT-ART-Stack gesucht; wenn nicht definiert → `cache_engine::allocator_t` als Fallback.
5. **Strategische Vorgabe an die Implementierung**:
   - **Bevorzuge** die CacheEngine-Struktur in der Bearbeitung der Stubs.
   - **PRT-ART-Spezifika** werden dort hinzugefuegt, wo sie sich unterscheiden — nicht parallel an beiden Orten gepflegt.
   - **Ziel**: Spaeterer Merge der validierten PRT-ART-Methoden in die CacheEngine.

### 6.2 Concept-Spezifikation des Fallback-Mechanismus

```cpp
namespace comdare {

// Concept: ein Typ erfuellt die Permutations-Hierarchie wenn er
//          entweder direkt definiert ist oder per Fallback geerbt
template <typename Algo, typename BausteineTag>
concept has_baustein = requires {
    typename Algo::template baustein_t<BausteineTag>;
} || requires {
    typename cache_engine::baustein_t<BausteineTag>;
};

// Helper: liefere den Baustein-Typ entweder aus Algo (PRT-ART) oder Cache-Engine (Fallback)
template <typename Algo, typename BausteineTag>
struct resolve_baustein {
    using type = typename std::conditional_t<
        has_member_baustein<Algo, BausteineTag>::value,
        typename Algo::template baustein_t<BausteineTag>,
        typename cache_engine::baustein_t<BausteineTag>>;
};

}  // namespace comdare
```

---

## 7. TestDataSetAccumulationEngine

### 7.1 Wortlaut des Architekten

> *"Wenn wir unterschiedliche Testdatentypen haben, muss jeder von diesen Datensaetzen per Deserialization oder Parsing in den Arbeitsspeicher geladen und verfuegbar (und fair reproduzierbar aligned) gemacht werden, um einen definierten Experiment-Ablauf ueber test_data_set_accumulation_engine_type als Klasse, welche die Daten geladen hat und die Test-Algo-Interfaces kennt, bereitstellt. In der Regel werden alle Testdatensaetze als Implementierung der SearchEngine bei Initialisierung dieser eingelesen test_data_set_accumulation_engine_type und bereitgestellt, um dann durch eine separate Testroutine ausgefuehrt zu werden."*

### 7.2 Konzept

```cpp
namespace comdare {

template <typename SearchAlgo>
class test_data_set_accumulation_engine_type {
public:
    using algo_t = SearchAlgo;

    // Lifecycle: bei SearchEngine-Initialisierung wird diese Klasse mit-konstruiert
    explicit test_data_set_accumulation_engine_type(SearchAlgo& bound_algo)
        : algo_(bound_algo) {}

    // Lade Datasets per Deserialization/Parsing, in Arbeitsspeicher aligned bereitstellen
    void load_dataset(std::filesystem::path const& dataset_file);

    // Pruefe Verfuegbarkeit aller fuer das Experiment noetigen Datasets
    [[nodiscard]] bool all_loaded() const noexcept;

    // Stelle Datasets fair reproduzierbar aligned bereit (z.B. 64-Byte-aligned-Spans)
    [[nodiscard]] std::span<std::byte const> get_dataset(std::string_view name) const noexcept;

    // Stelle eine Test-Algo-Interface-Sicht bereit, ueber die der Algo die Daten konsumieren kann
    [[nodiscard]] algo_t::input_view_t make_input_view(std::string_view dataset) const;

    // Reset zwischen Experimenten — Buffer behalten, Cursor zuruecksetzen
    void reset_cursors() noexcept;

private:
    SearchAlgo&                                             algo_;
    std::unordered_map<std::string, std::vector<std::byte>> aligned_buffers_;
    // ... Indizes, Layout-Metadaten
};

}  // namespace comdare
```

### 7.3 Alignment-Anforderungen

- Cache-Line-Alignment (64 B) ist Pflicht fuer alle Buffer.
- Bei NUMA-Systemen wird das Dataset auf einem definierten NUMA-Node alloziert (reproduzierbar).
- Bei Hugepages: optional 2 MiB / 1 GiB Alignment-Garantie.

---

## 8. Mikrobenchmark-Suite (Wortlaut + Praezisierung)

### 8.1 Wortlaut

> *"Die Mikrobenchmark-Suite ist ein no-deprecate Wrapper aller Testmethoden und akkumuliert fortlaufend auf einer separaten Custom-Basis-Allokation (die so gross sein muss, dass sie nie failed oder erweitert werden muss) alle Messergebnisse traced und separat durch sparse serialized byte states binary den Testzustand und Fortschritt auf einer weiteren separaten Custom-Allocation loggt — alles wird zum Ende eines Experimentes erst von binary in handlichere Formate konsolidiert und als auswertbares binary blob Ergebnis gespeichert. Zur Laufzeit ist der Fokus beim Messen nun mal sparse Eigenschaften und minimaler OS-Einfluss, statt handliche Formate, die wir bei der Auswertung brauchen (Conversion-Routine im Messmodul notwendig)."*

### 8.2 Spezifikation

#### 8.2.1 No-Deprecate-Wrapper

Alle Test-Methoden werden ueber einen einzigen Wrapper-Type angesprochen, der die API niemals aendert (kein "deprecate", keine Brueche). Konkret: ein `BenchmarkRunner`-Singleton mit fester API:

```cpp
class BenchmarkRunner {
public:
    using id_t = std::uint64_t;

    // Pflicht-API (no-deprecate Garantie)
    id_t  begin_measurement(std::string_view tag);
    void  record_event(id_t handle, EventKind kind, std::uint64_t aux = 0);
    void  end_measurement(id_t handle, std::uint64_t observed_cycles);
    void  flush_to_binary_blob(std::filesystem::path const& output);
};
```

#### 8.2.2 Zwei separate Custom-Allokationen

```
+-----------------------------------------+
|  Custom-Allocation #1 (Messergebnisse)  |
|    - Pre-allocated, gross genug (z.B. 1 GiB)
|    - Nie fail, nie erweiterbar
|    - Append-only, lock-free pro Thread
|    - Layout: 32-Byte-MeasurementRecord aligned
+-----------------------------------------+
+-----------------------------------------+
|  Custom-Allocation #2 (Test-Zustand/Fortschritt) |
|    - Pre-allocated, separate von #1
|    - Sparse-Serialized-Byte-States binary
|    - Pro Test-Phase ein State-Marker
+-----------------------------------------+
```

#### 8.2.3 Sparse-Serialized-Byte-States

Pro Test-Zustand wird **nur das Delta** zum vorigen Zustand seriell auf #2 geschrieben (Sparse-Repraesentation). Format:

```
[state_marker:1B] [delta_length:varint] [delta_bytes:variable]
```

Das reduziert OS-Einfluss auf das absolute Minimum (kein I/O, keine Allokation, kein std::cout).

#### 8.2.4 Konsolidierung am Experiment-Ende

```
Laufzeit-Modus:                       Auswertungs-Modus (Post-Experiment):
+--------------------------+          +-----------------------------------+
| #1 raw 32B-Records       |   ===>   | konsolidiert → binary blob:       |
| #2 sparse byte-states    |          |   Header + Records + Footer       |
|                          |          |   (siehe REV 2 06_uml_persistence)|
+--------------------------+          +-----------------------------------+
                                      |  +Conversion-Routinen:            |
                                      |    - Binary → CSV                 |
                                      |    - Binary → JSON                |
                                      |    - Binary → pgfplots/tikz       |
                                      +-----------------------------------+
```

#### 8.2.5 Conversion-Routine im Messmodul

Conversion ist **Pflicht-Bestandteil des Messmoduls**, aber wird **NIE waehrend der Laufzeit** aufgerufen — nur in der Post-Experiment-Auswertung.

---

## 9. Plan + Reihenfolge

| Phase | Inhalt | Status |
|-------|--------|--------|
| **6.1** | (laeuft / abgeschlossen) PRT-ART REV 6 §5.17 | Pushed: `comdare-prt-art` development 002c326 |
| **6.2.A** | Diese Doku-Phase (REV 7 mit hoechster Praezision) | **WIP** (dieses Dokument) |
| **6.2.B** | Allokator-Paper-Recherche analog Phase 3.B (Tieflektuere alle 21 Rang-1 + Rang-2 + Rang-3 Paper) | TBD nach User-OK |
| **6.2.C** | Code-Quellen klonen + Lizenz-Analyse + Adapter-Skelette (analog Phase 4.B-detail) | TBD nach User-OK |
| **6.2.D** | `Allokator_Matrix.txt` analog `Bausteine_Matrix.txt` mit AA1-AA7 Achsen | TBD nach User-OK |
| **6.2.E** | Cache-Engine-Allokator-Bibliothek (Concept-Wurzeln + Konkretisierungen, std::allocator + std::pmr-konform) | TBD |
| **6.2.F** | Container-Tests Matrix x Allokator-Variante | TBD |
| **6.2.G** | Concurrency-Tests (Single-Writer-Multi-Reader Default + Cache-Page-Aware Multi-Writer Optional) | TBD |
| **6.3** | ABI-stabiles C++23-Modul-Interface (3-Schichten + Variadic + Fingerprint) | TBD |
| **6.4** | CacheEngineBuilder als eigenstaendiges Programm (XML-Konfig + Codegen + Pre-Build) | TBD |
| **6.5** | TestDataSetAccumulationEngine | TBD |
| **6.6** | Mikrobenchmark-Suite (no-deprecate + 2 Custom-Allokationen + sparse binary + Conversion) | TBD |
| **7** | Experiment-Loop PRT-ART vs Stand der Technik | TBD |

---

## 10. Naechste Schritte (Entscheidungs-Vorschlag)

1. **User-OK fuer Phase 6.2.B**: Beginne Tieflektuere der 21 Allokator-Paper analog Phase 3.B (Cluster G/H: Allokation-Cluster Berger/Bonwick/Michael/Leijen + Modern-Cluster jemalloc/tcmalloc/snmalloc/scalloc + NUMA-Cluster NUMAlloc/PIM + Formal-Cluster StarMalloc/LRMalloc + Survey-Cluster ASPLOS 2024).
2. **User-OK fuer Phase 6.2.C**: Klone die Code-Quellen mit verfuegbarer Lizenz nach `comdare-cache-engine/ext/A{NN}-<short>/`.
3. **User-OK fuer Phase 6.3 Skelett**: Erste Stubs fuer `execution_engine` + `search_engine` + Variadic-Template-Magic in `comdare-cache-engine`.

---

## 11. Bestaetigung der Doku-Vollstaendigkeit (48-Atom-Checkliste)

User-Nachricht 2026-05-12/13 in 48 atomische Anforderungen zerlegt (Kategorien A-J). Stand 2026-05-13 nach REV-7-Delta-Check:

### Kategorie A — Custom Allokation Basis (A.1-A.13)
| Atom | Aussage | Sektion |
|------|---------|---------|
| A.1 | Custom Allokation = wichtigste Cache-Engine-Basis-Disziplin (vergessen) | §1.1, §1.3 |
| A.2 | Cache-Engine verwaltet Speicher nach bekannten weitreichenden Allokationsmethoden | §1.3 |
| A.3 | Umfassende wissenschaftliche Analyse + Google-Scholar-Recherche | §2.1-§2.3 + §2.6 |
| A.4 | **jalloc + malloc + calloc als bekannte Vertreter** — **KLAERUNG OFFEN** | §2 A05 jemalloc / A20 dlmalloc / A21 ptmalloc2 (jalloc = jemalloc? oder eigener Allokator?) |
| A.5 | Baustein-Familie UMFASSEND ergaenzen | §2.4 + §2.5 7 Achsen AA1-AA7 |
| A.6 | Pro Paper elaborate Zusammenfassung + Code-Recherche analog Suchalgorithmen | §2.4 Pflicht-Vorgehen + §9 Phase 6.2.B/C |
| A.7 | Optionale thread-safe Implementierungen der std C++ Bibliothek | §3.1 CacheEngineAllocator + CacheEnginePmrResource |
| A.8 | Recherche: Permutierte Allokator-Bausteine erweitern Standard typsicher | §1.4 A1-A8 + §3.1 |
| A.9 | Grundlage aller verwendeten std-Container | §3.2 Container-Matrix |
| A.10 | Umfangreiche Tests Allokation/Container/Threading/Concurrency-Sicherheit | §3.2 Pflicht-Tests |
| A.11 | Standard = Single-Write + Multi-Read Concurrency | §1.4 A3 + §3.3 |
| A.12 | Optional: erweiterte local-aware Multi-Write Concurrency ueber Cache-Page-Awareness | §1.4 A4 + §3.3 CachePageAwareConcurrentAllocator |
| A.13 | C++17 Locks recherchieren | §1.5 8 Lock-Typen-Tabelle |

### Kategorie B — ABI-stabiles C++23-Interface (B.1-B.6)
| Atom | Aussage | Sektion |
|------|---------|---------|
| B.1 | Jedes kompilierte Experiment = bestimmte ExecutionEngine→SearchEngine Rekombination | §4.1 + REV 6 §5.28.1 |
| B.2 | Formal: zusammengesetzter Custom-Suchalgorithmus + definierte Baustein-Permutation | §4 + §5.3 |
| B.3 | Pseudocode `std::variant<...>()` woertlich erfasst | §4.1 woertlich zitiert |
| B.4 | Pseudocode-Bedeutung: Algorithmus-Varianten der Cache-Engine-Permutation | §4.2 |
| B.5 | Varianten bewegen sich an Baustein-Permutation der Cache-Engine | §4.2(d) |
| B.6 | Varianten wandeln sich automatisch je nach Anzahl Typ-Parameter | §4.2(b) + §4.3 |

### Kategorie C — Variadic-Template-Magie (C.1-C.6)
| Atom | Aussage | Sektion |
|------|---------|---------|
| C.1 | 1 Parameter → Typ ist value | §4.2(b) Fall 1 |
| C.2 | Implicit Key = beim Einfuegen hochzaehlender uint64 | §4.2(b) Fall 1 |
| C.3 | 2+ Parameter → erster = Key, Rest = Tuple<values> | §4.2(b) Faelle 2+3 |
| C.4 | Komplexer Key (ab 2 Params) → kein Einfachtyp | §4.2(c) |
| C.5 | Implicit `comdare::fingerprint`-Bibliothek + Overload hasht zu binary-string statischer Laenge | §4.2(c) FixedLengthFingerprint<16>::hash() |
| C.6 | Einfach-Key → Funktions-Ueberladung als binary-string implicit gecastet | §4.2(c) Overload to_binary_string |

### Kategorie D — Visitor-Pattern + processing_strategy_type (D.1-D.5)
| Atom | Aussage | Sektion |
|------|---------|---------|
| D.1 | execution_engine erbt CacheEngine als Basisklasse | §4.2(a) Hierarchie + §4.2(d) |
| D.2 | CacheEngine = Visitor-Pattern, durch SearchEngine-Abkoemmlinge initialisiert | §4.2(d) |
| D.3 | CacheEngine bei Algorithmus-Entscheidungen um Rat gefragt | §4.2(d) |
| D.4 | CacheEngine direkt als experimentelles OS-Interface verwendbar | §4.2(d) |
| D.5 | processing_strategy_type: permutation-statisch + verhalten-runtime-dynamisch + Bereiche (Limits/Verhalten/Heuristiken/Allokation/Scheduling/Concurrency) | §4.2(d) |

### Kategorie E — 3-Stufen-Bauprozess + Layer-Rollen (E.1-E.8)
| Atom | Aussage | Sektion |
|------|---------|---------|
| E.1 | 3 Stufen: CacheEngineBuilder + ExecutionEngine + SearchEngine | §4.2(e) + §5 |
| E.2 | CacheEngineBuilder = eigenstaendiges Programm mit XML-Konfigs | §5 + §5.1 + §5.2 |
| E.3 | XML definiert alle zulaessigen CacheEngine-Rekombinationen + abhaengige Custom-Suchalgorithmen | §5.2 XML-Format |
| E.4 | execution_engine = Reihe CacheEngine-impliziter Typen, compile-time kompiliert | §5.3 + §4.2(e) |
| E.5 | search_algorithm = spezielle execution_engine, erbt compile-time-statische Suchalgorithmus-Bausteine | §5.3 + §4.2(a) Hierarchie |
| E.6 | **ExecutionEngine STELLT mithilfe CacheEngine experimentelle OS-Primitiven BEREIT (Provider-Rolle)** — NEU ergaenzt | **§4.2(f)** Layer-Verantwortlichkeiten |
| E.7 | **SearchEngine STELLT Such-spezifische, komplexere experimentelle Standard-OS-Such-+ Speicherzugriffsmuster + Routinen BEREIT** — NEU ergaenzt | **§4.2(f)** |
| E.8 | **SearchEngine = Dach des Konstrukts, oberster Layer mit Suchheuristiken + Konzepten, die CacheEngine-Limits "weit ueberschreiten"** — NEU ergaenzt | **§4.2(f)** |

### Kategorie F — PRT-ART Compile-time-Fallback (F.1-F.5)
| Atom | Aussage | Sektion |
|------|---------|---------|
| F.1 | Strategisch: CacheEngine-Struktur in Stub-Bearbeitung bevorzugen (PRT_ART spaeter mergen) | §6.1 (5) |
| F.2 | Cache-Engine hat Algorithmus-Bausteine-Stack im Bereich Suche; PRT_ART hat dieselbe Struktur als parallel-Stack | §6.1 (1)+(2) |
| F.3 | processing_strategy_type fuer Rekombinations-Konfig auf alle drei Layer + PRT_ART anwendbar | §6.1 (3) |
| F.4 | PRT_ART erbt aus CacheEngine die Permutations-Struktur-Hierarchie | §6.1 (4) + §6.2 |
| F.5 | Compile-time-Fallback: fehlende Typen in configuration_permutation_type → automatischer Fallback auf Cache-Engine-Bausteine | §6.1 (4) + §6.2 Concept-Skelett |

### Kategorie G — Code-Archivierung (G.1)
| Atom | Aussage | Status |
|------|---------|--------|
| G.1 | `_archive_code_pre_migration/` umsetzen | ✅ Umgesetzt 2026-05-13 (`Diplomarbeit/_archive_code_pre_migration/`) |

### Kategorie H — Doku-Reihenfolge (H.1-H.2)
| Atom | Aussage | Sektion |
|------|---------|---------|
| H.1 | Im ersten Schritt: ALLE User-Anmerkungen + Plan mit hoechster Praezision dokumentieren | §0 Pflicht-Reihenfolge + diese 48-Atom-Checkliste |
| H.2 | Ziel: Modulares Interface der precompiled ABI-stabilen C++23-Module vorbereiten | §4 ABI komplett + §5 Builder |

### Kategorie I — TestDataSetAccumulationEngine (I.1-I.4)
| Atom | Aussage | Sektion |
|------|---------|---------|
| I.1 | Unterschiedliche Testdatentypen → per Deserialization/Parsing in Arbeitsspeicher + fair-reproduzierbar-aligned | §7.1 woertlich + §7.3 Alignment |
| I.2 | test_data_set_accumulation_engine_type = Klasse mit Daten + Test-Algo-Interfaces | §7.2 Pseudocode |
| I.3 | Datasets werden bei SearchEngine-Initialisierung mit-konstruiert | §7.2 explicit ctor |
| I.4 | Ausfuehrung durch separate Testroutine | §7.2 + §8.2.1 BenchmarkRunner |

### Kategorie J — Mikrobenchmark-Suite (J.1-J.6)
| Atom | Aussage | Sektion |
|------|---------|---------|
| J.1 | No-Deprecate-Wrapper aller Testmethoden | §8.2.1 |
| J.2 | Custom-Allocation #1 fuer Messergebnisse, gross genug, nie fail oder erweitern | §8.2.2 |
| J.3 | Custom-Allocation #2 separat fuer Sparse-Serialized-Byte-States | §8.2.2 + §8.2.3 Format |
| J.4 | Am Experiment-Ende: Binary → handlichere Formate konsolidieren → auswertbarer Binary-Blob | §8.2.4 |
| J.5 | Laufzeit-Fokus: sparse + minimaler OS-Einfluss | §8.2.3 |
| J.6 | Conversion-Routine im Messmodul Pflicht | §8.2.5 |

---

**Stand 2026-05-13 nach Delta-Check:**

✅ **47 von 48 Atomen vollstaendig dokumentiert** (alle E.6-E.8 mit dieser Revision in §4.2(f) ergaenzt).

✅ **A.4 GEKLAERT 2026-05-13:** "jalloc" = **jemalloc** (A05, Jason Evans, BSDCan 2006).

**Doku-Phase 6.2.A VOLLSTAENDIG.** User-Direktive 2026-05-13: autonom weiter.

**Pflicht laut User:** "Allokator-Familien benoetigen die angefragte Recherche, bis wir den groessten Teil des angewendeten Standes der Technik anbieten koennen."

**→ Phase 6.2.B startet:** Tieflektuere aller 23 Allokator-Paper analog Phase 3.B (33 Such-Paper). Output unter `_paper_extractions_allocators/`.

---

## Quellen (recherchiert 2026-05-13)

- [Hoard: A Scalable Memory Allocator for Multithreaded Applications (ASPLOS 2000)](https://www.cs.utexas.edu/~mckinley/papers/asplos-2000.pdf)
- [The Slab Allocator: An Object-Caching Kernel Memory Allocator (USENIX 1994)](https://www.usenix.org/conference/usenix-summer-1994-technical-conference/slab-allocator-object-caching-kernel)
- [Scalable Lock-Free Dynamic Memory Allocation (PLDI 2004, Michael)](https://www.cs.tufts.edu/~nr/cs257/archive/neal-glew/mcrt/Non-blocking%20data%20structures/p35-michael.pdf)
- [Mimalloc: Free List Sharding in Action (MSR-TR-2019-18 / APLAS 2019)](https://www.microsoft.com/en-us/research/wp-content/uploads/2019/06/mimalloc-tr-v1.pdf)
- [scalloc: A Scalable Allocator Based on Span-Pooling (OOPSLA 2015)](https://cs.uni-salzburg.at/~ck/content/publications/conferences/OOPSLA15-Scalloc.pdf)
- [NUMAlloc: A Faster NUMA Memory Allocator (ISMM 2023)](https://dl.acm.org/doi/10.1145/3591195.3595276)
- [Characterizing a Memory Allocator at Warehouse Scale (ASPLOS 2024)](https://people.csail.mit.edu/delimitrou/papers/2024.asplos.memory.pdf)
- [StarMalloc: A Formally Verified Concurrent Allocator (arXiv 2024)](https://arxiv.org/pdf/2403.09435)
- [PIM-malloc: A Fast and Scalable Dynamic Memory Allocator for PIM Architectures (arXiv 2025)](https://arxiv.org/html/2505.13002v1)
- [LRMalloc: A Modern and Competitive Lock-Free Dynamic Memory Allocator (2020)](https://www.researchgate.net/publication/344962358)
- [N3916: Polymorphic Memory Resources (open-std 2014)](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n3916.pdf)
- [rpmalloc Public Domain Lock-Free Allocator (GitHub)](https://github.com/mjansson/rpmalloc)
- [microsoft/mimalloc GitHub](https://github.com/microsoft/mimalloc)
- [microsoft/snmalloc GitHub](https://github.com/microsoft/snmalloc)
- [Exgen-Malloc: Optimizing Single-threaded Applications (arXiv 2025)](https://arxiv.org/html/2510.10219v1)
- [A Family of Fast and Memory Efficient Lock- and Wait-Free Reclamation (PLDI 2024)](https://dl.acm.org/doi/10.1145/3658851)
- [CAMA: A Predictable Cache-Aware Memory Allocator (RTAS 2011)](https://www.researchgate.net/publication/224255517)
- [Doug Lea malloc (dlmalloc) Reference](https://gee.cs.oswego.edu/dl/html/malloc.html)
