# A15 — HMalloc: A Hybrid, Scalable, and Lock-Free Memory Allocator for Multi-Threaded Applications

## Bibliographie
- **Titel:** HMalloc: A Hybrid, Scalable, and Lock-Free Memory Allocator for Multi-Threaded Applications
- **Autoren:** Li, Yao et al.
- **Venue:** IEEE Conference, 2019/2020 (genaues Jahr in REV-7-Liste TBD)
- **IEEE Xplore:** [ieeexplore.ieee.org/document/8975846/](https://ieeexplore.ieee.org/document/8975846/)
- **ResearchGate:** [researchgate.net/publication/338946528](https://www.researchgate.net/publication/338946528_HMalloc_A_Hybrid_Scalable_and_Lock-Free_Memory_Allocator_for_Multi-Threaded_Applications)
- **Status:** Forschungs-Allokator mit Fokus auf PDES (Parallel Discrete Event Simulation)

## Kerninnovation — Local vs Shared Memory Trennung

HMalloc adressiert die Beobachtung dass klassische Allokatoren **Thread-Local Memory** und **Shared Memory** **gleich behandeln** — was suboptimal ist:

- **Local Memory:** kein False-Sharing-Risk, kein Lock-Contention noetig
- **Shared Memory:** Lock-Contention + False-Sharing zentrale Concerns

**HMalloc-Loesung:** **Strikte Trennung** beider Memory-Klassen mit verschiedenen Algorithmen.

## Architektur

### Local Memory Management
- **No Lock-Contention** Concerns (per definition)
- **Coalescence-Free Method** fuer Free-Operations (vermeidet teure Coalescing-Algorithmen)
- Hot-Path = sehr schnell

### Shared Memory Management
- **Flag-basiert** (statt Lock-basiert)
- Lock-free allocation + deallocation
- Verwaltet Cross-Thread-Sharing

## Hybrid-Allokation

HMalloc-User muss explizit deklarieren:
- "Diese Allokation ist Thread-Local" → schneller Local-Path
- "Diese Allokation ist Shared" → robuster Shared-Path

→ Performance-Optimierung durch **explizites User-Knowledge** ueber Memory-Sharing-Pattern.

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | HMalloc-Konkretisierung |
|-------|--------------------------|
| **AA1 FreeList-Topologie** | Per-Thread (local) + Global (shared) Free-Lists separated; coalescence-free local |
| **AA2 Size-Class-Schema** | Klassisches Power-of-2 (Detail-Pflicht im Paper) |
| **AA3 Thread-Locality** | **Explizit deklariert** durch User — Local vs Shared |
| **AA4 Synchronization** | Local: keine; Shared: flag-basiert lock-free |
| **AA5 Allocation-Policy** | Bifurkation am API-Level: `hmalloc_local` vs `hmalloc_shared` |
| **AA6 Reclamation** | Coalescence-Free fuer Local; flag-basiert fuer Shared |
| **AA7 Fragmentation-Strategy** | Trade-off: explicite separation = bessere lokale Performance, aber hoeherer Cognitive Overhead fuer User |

## Performance-Resultate

- **Significant performance improvement** in Memory-Allocation-Benchmarks
- **Specifically optimized for PDES** (Parallel Discrete Event Simulation) Workloads
- Im Vergleich zu well-known Allokatoren bessere Performance bei PDES-Workloads

## Bedeutung fuer Comdare-CacheEngine

1. **Explicit Local vs Shared Allocation** = **interessante Idee** fuer Comdare-PRT-ART:
   - PRT-ART Pool A/B/C/D-Bloecke = lokal pro Thread (Search-Algorithm-Internal-State)
   - PRT-ART Value-Buffer (Pool V) = potenziell shared zwischen Threads
2. **Coalescence-Free Local Allocation** = wertvolle Hot-Path-Optimierung
3. **Flag-basierte Lock-Free Shared Memory** = alternative zu Atomic-CAS (eventuell weniger overhead bei seltener Contention)
4. **PDES-Anwendung** = relevant fuer Workloads wie **Database-Engine-Simulation** oder **Trie-Construction-Benchmarks** in Comdare-Phase-7
5. **Cognitive Overhead** = Drawback: User muss bei Allocation entscheiden lokal vs shared — passt **NICHT** zur Comdare-CacheEngine-Vision wo Cache-Engine selbst entscheidet
6. → Eher als **Informational** fuer Cluster AC4 zu fuehren, nicht als Pflicht-Konkretisierung

## Lizenz + Code-Verfuegbarkeit

- **Code:** Forschungs-Code, vermutlich nicht oeffentlich auf GitHub
- **IEEE-Paper-Zugang:** ueber Universitaetsbibliothek
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A15-hmalloc/` (klonen sobald Code verfuegbar; sonst Algorithmic-Reference-Datei)

## Verwandte Werke

- A03 Michael Lock-Free (PLDI 2004) — Vorlage fuer Shared-Memory-Lock-Free
- A11 LRMalloc — moderner lock-free Allokator
- PDES-Allokatoren (Domain-spezifische) — Anwendungs-Context
