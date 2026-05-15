# A16 — PIM-malloc: A Fast and Scalable Dynamic Memory Allocator for Processing-In-Memory (PIM) Architectures

## Bibliographie
- **Titel:** PIM-malloc: A Fast and Scalable Dynamic Memory Allocator for Processing-In-Memory (PIM) Architectures
- **Autoren:** Dongjae Lee (KAIST), Bongjoon Hyun (KAIST), Youngjin Kwon (KAIST), Minsoo Rhu (KAIST/VIA Research Group)
- **Venue:** **HPCA-32 2026** (32nd International Symposium on High-Performance Computer Architecture), Sydney AU, Februar 2026
- **arXiv:** [arxiv.org/abs/2505.13002](https://arxiv.org/abs/2505.13002) (May 2025)
- **arXiv HTML v3:** [arxiv.org/html/2505.13002v3](https://arxiv.org/html/2505.13002v3)
- **IEEE Xplore:** [ieeexplore.ieee.org/document/11408588/](https://ieeexplore.ieee.org/document/11408588/)
- **Code-Repo:** [github.com/VIA-Research/PIM-malloc](https://github.com/VIA-Research/PIM-malloc)
- **Status:** **Cutting-edge** (2025-2026) — erster general-purpose PIM-Allokator mit echten PIM-Hardware-Resultaten

## Kerninnovation — PIM-Architektur-spezifischer Allokator

**Processing-In-Memory (PIM)** bewegt Compute zur Memory hin (z.B. UPMEM-PIM-Architektur). Klassische Allokatoren laufen am Host-CPU + Memory-Allocations werden ueber DRAM-PIM-Bus gesendet → **Bottleneck**.

**PIM-malloc Loesung:** **PIM-Metadata + PIM-Executed** Approach:
- Allokator-Metadata wird in PIM-Memory gespeichert (nicht Host-DRAM)
- Allocation-Routinen laufen auf PIM-Cores selbst
- → **kein Data-Transfer-Overhead** zwischen Host-DRAM und PIM
- Pro PIM-Core eigene Allocation-Requests parallel

## Architektur-Insights

| Aspect | Klassischer Allokator | PIM-malloc |
|--------|----------------------|------------|
| **Metadata Location** | Host DRAM | PIM Memory |
| **Allocation Compute** | Host CPU | PIM Cores |
| **Data Transfer** | Per Allocation Round-Trip | NUR fuer Allocated Data |
| **Parallelism** | Single CPU bottleneck | Per-PIM-Core parallel |

## Performance-Resultate

- **Software-only PIM-malloc:** **66× faster** als naiv-designed PIM-Allokator
- **+ Hardware-Cache (per-PIM-core, lightweight):** zusaetzlich **+31%** improvement
- Skalierbar mit Anzahl PIM-Cores

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | PIM-malloc-Konkretisierung |
|-------|----------------------------|
| **AA1 FreeList-Topologie** | Per-PIM-Core eigene Free-Lists in PIM-Memory; Per-PIM-Core lightweight Hardware-Cache |
| **AA2 Size-Class-Schema** | PIM-spezifisch (Paper: Power-of-2 wahrscheinlich); aufgrund DRAM-PIM-Architektur kleinere Wahl-Range |
| **AA3 Thread-Locality** | **Per-PIM-Core** (statt Per-Thread) — entspricht "PIM-Core-Locality" |
| **AA4 Synchronization** | Per-Core-lockless (PIM-Cores haben begrenzte Sync-Hardware); Inter-Core-Coordination via Host-CPU-Mediation |
| **AA5 Allocation-Policy** | PIM-Metadata + PIM-Executed = **kein** Host-CPU-Round-Trip im Common-Case |
| **AA6 Reclamation** | Lokal in PIM-Memory, kein Cross-PIM-Core-Transfer noetig |
| **AA7 Fragmentation-Strategy** | PIM-Memory ist begrenzt → fragmentation-conscious Design Pflicht |

## Bedeutung fuer Comdare-CacheEngine

1. **PIM-Hardware** ist **Future-Computing-Trend** (UPMEM, Samsung HBM-PIM, SK Hynix AIM)
2. PIM-malloc ist die **erste echte PIM-Production-Allokator** — Pflicht-Studie fuer Comdare's Future-Plattform-Roadmap
3. **PIM-Architektur** = analog Comdare's REV 7 Plattform-Modell K08 Storage-Concepts (NVRAM, Storage-Class Memory, near-memory compute)
4. **Per-PIM-Core Hardware Cache** = zukunftstraechtiges Feature; Pflicht fuer **Block AO Future-Plattform-Liste** (sobald PIM-Cluster verfuegbar)
5. **Software-Only PIM-malloc** ist auf UPMEM-PIM lauffaehig → Comdare's PRT-ART Pool-Manager **portierbar** zu PIM-Architektur
6. **NICHT** als Default-Achse-Wert empfohlen; aber als **Future-Permutations-Option** in CacheEngineBuilder XML
7. Direkter Bezug zu **Habich H4** (Memory-Bandwidth-Heuristics) — PIM ist ultimative Memory-Bandwidth-Loesung

## Lizenz + Code-Verfuegbarkeit

- **Code:** [github.com/VIA-Research/PIM-malloc](https://github.com/VIA-Research/PIM-malloc) (KAIST VIA Research Group)
- **Lizenz:** im Repo zu pruefen; akademisch
- **Plattformen:** UPMEM-PIM (commercially available), simulated environments
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A16-pim-malloc/` (klonen, STRUKTUR_NOTIZ.md, **NICHT** in Default-Build — als optional Future-Plattform-Variant)

## Verwandte Werke

- UPMEM-PIM Architektur (commercial PIM hardware)
- Samsung HBM-PIM (research/limited availability)
- McRT-Malloc (Hudson et al. ISMM 2006) — multi-core scalable transactional allocator (referenced in mimalloc paper)
- Hoard (A01) — Per-Processor heaps (Per-PIM-Core analog)
