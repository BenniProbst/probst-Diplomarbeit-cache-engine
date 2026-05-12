# A11 — LRMalloc: A Modern and Competitive Lock-Free Dynamic Memory Allocator

## Bibliographie
- **Titel:** LRMalloc: A Modern and Competitive Lock-Free Dynamic Memory Allocator
- **Autoren:** Ricardo Leite (Univ. of Porto, DCC/LIAAD), Ricardo Rocha (Univ. of Porto, DCC/CRACS-INESC)
- **Venue:** **VECPAR 2018** (High Performance Computing for Computational Science) — proceedings published 2019 — NICHT ICAPDS! (Korrektur zu REV-7-Liste)
- **PDF-Quelle:** [www.dcc.fc.up.pt/~ricroc/homepage/publications/2018-VECPAR.pdf](https://www.dcc.fc.up.pt/~ricroc/homepage/publications/2018-VECPAR.pdf)
- **MSc-Thesis:** [www.dcc.fc.up.pt/~ricroc/homepage/alumni/2018-leiteMSc.pdf](https://www.dcc.fc.up.pt/~ricroc/homepage/alumni/2018-leiteMSc.pdf)
- **Code-Repo:** [github.com/ricleite/lrmalloc](https://github.com/ricleite/lrmalloc) (MIT-Lizenz)
- **Status:** Forschungs-Allokator + Vorlage fuer Ralloc (Recoverable LRMalloc)

## Kerninnovation

LRMalloc kombiniert:
1. **Modern Memory Allocator Features** (Thread-Caches, Allocator/User-Memory-Segregation)
2. **Lock-Free Properties** (siehe A03 Michael 2004)

Ziel: zeigen dass **lock-free + competitive performance** machbar ist (Michael 2004 hatte schon bewiesen dass lock-free machbar — LRMalloc beweist dass **competitive** ohne Performance-Sacrifice).

## Ableitung von Michael 2004

LRMalloc ist **direkter Nachfolger** von Michael's PLDI-2004-Allokator (A03):
- Anchor-Strukturen (avail/count/state/tag) erweitert
- Procheap-Konzept beibehalten
- **Plus:** Thread-Caches als modernes Feature (analog tcmalloc/jemalloc)
- **Plus:** Allocator-/User-Memory-Segregation

## Lock-Free Properties (von A03 geerbt)

| Property | Bedeutung |
|----------|-----------|
| Deadlock-Immune | Kein Lock = kein Deadlock |
| Livelock-Immune | Lock-free progress garantie |
| Async-Signal-Safe | Verwendbar in Signal-Handlers |
| Kill-Tolerant | Thread-Termination wirft Allokator nicht aus dem Concept |
| Preemption-Tolerant | Scheduling-tolerant |
| Priority-Inversion-Tolerant | Real-Time-tauglich |

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | LRMalloc-Konkretisierung |
|-------|---------------------------|
| **AA1 FreeList-Topologie** | Per-Thread Cache + Per-Procheap Active+Partial (von Michael 2004) |
| **AA2 Size-Class-Schema** | Power-of-2 (von Michael 2004) |
| **AA3 Thread-Locality** | **Modernisierung:** Thread-Caches als Common-Path |
| **AA4 Synchronization** | Lock-free CAS (Anchor-Updates), Hazard-Pointer-style fuer Descriptor-Reclamation |
| **AA5 Allocation-Policy** | Hot: thread cache; Slow: lock-free procheap operations (Michael 2004 Active/Partial/NewSB pattern) |
| **AA6 Reclamation** | Thread-Caches → Procheap Partial-Lists → Procheap NewSB allocation |
| **AA7 Fragmentation-Strategy** | Allocator-/User-Memory-Segregation reduce Cross-Pollution |

## Performance

LRMalloc zeigt **competitive Performance** zu state-of-the-art (Hoard, ptmalloc, jemalloc, tcmalloc) **mit** den lock-free Garantien.

In mimalloc-Paper-Reference (A04) NICHT direkt benchmarked — eher in Forschungs-Konkurrenz-Studien sichtbar.

## Bedeutung fuer Comdare-CacheEngine

1. **Lock-Free + Thread-Caches kombiniert** = **Pflicht-Konkretisierung** fuer `c06_allocation_engine.aa4_synchronization.LockFreeWithThreadCache`
2. **Allocator-/User-Memory-Segregation** = wichtige Trennung — Allokator-Metadata-Korruption durch User-Bug-Out-of-Bounds vermieden
3. **Vorlage fuer PRT-ART OLC mit Thread-Caches:** PRT-ART nutzt schon OLC + reservierte Value-Bloecke (REV 6 §5.17); Thread-Caches als zusaetzliche Hot-Path-Optimization
4. **Direkte Linie:** A03 Michael 2004 → A11 LRMalloc → A17 Crystalline (PLDI 2024) → Comdare's Lock-Free-Variant

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** MIT (im github.com/ricleite/lrmalloc Repo)
- **Repo:** [github.com/ricleite/lrmalloc](https://github.com/ricleite/lrmalloc)
- **Plattformen:** Linux primarily; portierbar
- **Verwandtes Projekt Ralloc:** [github.com/urcs-sync/ralloc](https://github.com/urcs-sync/ralloc) (Recoverable LRMalloc fuer NVM)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A11-lrmalloc/`

## Verwandte Werke

- A03 Michael Lock-Free (PLDI 2004) — direkter Vorgaenger
- Ralloc — Recoverable LRMalloc fuer Persistent-Memory (NVRAM)
- A17 Crystalline (PLDI 2024) — moderne Reclamation-Family
- A07 snmalloc (ISMM 2019) — alternative lock-free approach mit message-passing
