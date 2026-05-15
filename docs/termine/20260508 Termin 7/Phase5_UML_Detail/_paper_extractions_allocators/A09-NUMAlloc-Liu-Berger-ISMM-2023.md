# A09 — NUMAlloc: A Faster NUMA Memory Allocator

## Bibliographie
- **Titel:** NUMAlloc: A Faster NUMA Memory Allocator
- **Autoren:** Hanmei Yang, Xin Zhao, Jin Zhou, Wei Wang, Sandip Kundu, Bo Wu, Hui Guan, Tongping Liu (UMass + Berger)
- **Venue:** ISMM 2023 (ACM SIGPLAN International Symposium on Memory Management), pp. 97-110
- **DOI:** 10.1145/3591195.3595276
- **NSF Public Access:** [par.nsf.gov/biblio/10418579](https://par.nsf.gov/biblio/10418579)
- **YouTube Talk:** [youtube.com/watch?v=nFwDxS-oG8I](https://www.youtube.com/watch?v=nFwDxS-oG8I)
- **Status:** Forschungs-Allokator, scalable bis 128 Threads

## Kerninnovation

NUMAlloc adressiert die **NUMA-Architektur-Luecke** in modernen Allokatoren. Selbst Top-Allokatoren (jemalloc, tcmalloc, mimalloc) sind nicht **NUMA-aware** im strikten Sinne — sie kennen Per-Thread-Caches, aber nicht **NUMA-Origin**.

**Zwei Hauptbeitraege:**
1. **Origin-Aware Memory Management** (Binding-basiert) — garantiert NUMA-Locality fuer Alloc + Free
2. **Incremental Sharing** — balanciert Performance vs Memory-Overhead bei Transparent Hugepages

## Origin-Aware Memory Management

**Problem:** Bei klassischen Allokatoren kann ein Thread auf NUMA-Node A einen Block freien, der auf Node B alloziert wurde → bei Re-Use = Cross-Node Memory Access = hohe Latenz.

**NUMAlloc-Loesung:**
1. Bei Allocation: Block wird **NUMA-Node-IDs getaggt** (in metadata)
2. Bei Free: Block geht zurueck zu Free-List **des Origin-Nodes**
3. Bei Re-Allocation: Thread bekommt einen Block aus seinem **eigenen NUMA-Node** Free-Pool

→ **Garantie:** Alloc + Free + Re-Use bleiben NUMA-lokal.

## Incremental Sharing (Transparent Hugepages)

**Problem mit THP:** Hugepage = 2 MiB ~ ueberdeckt mehrere NUMA-Nodes wenn shared zwischen Threads → Memory-Bandwidth-Penalty.

**NUMAlloc-Loesung:** Hugepages werden **inkrementell** geshared:
- Initial: jeder Thread bekommt private Hugepage-Subset
- Bei Memory-Pressure: hugepage-Sharing schrittweise erlaubt
- Trade-off **Performance** (private hugepages) vs **Memory** (shared hugepages) konfigurierbar

## Performance-Resultate

- **+15.7% schneller** als mimalloc (zweitbester)
- **+20.9% schneller** als Default Linux Allokator (glibc/ptmalloc2)
- Skalierbar bis **128 Threads**
- Reasonable Memory-Overhead

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | NUMAlloc-Konkretisierung |
|-------|---------------------------|
| **AA1 FreeList-Topologie** | Pro NUMA-Node eigene Free-Lists; Per-Thread Cache mit NUMA-Origin-Tag |
| **AA2 Size-Class-Schema** | Wahrscheinlich aehnlich Hoard/jemalloc (Power-of-2-Variants), Paper detail in arXiv-Vollext |
| **AA3 Thread-Locality** | NUMA-Origin-Aware (stronger than thread-local); Threads ziehen aus eigenem NUMA-Pool |
| **AA4 Synchronization** | Per-NUMA-Node-Lock; reduziert Cross-Node-Coherence-Verkehr |
| **AA5 Allocation-Policy** | Origin-Aware: Re-Use bleibt auf gleichem NUMA-Node |
| **AA6 Reclamation** | Block geht zurueck zu Free-List des **Origin-Nodes**, nicht des freeing-thread Nodes! |
| **AA7 Fragmentation-Strategy** | Incremental Hugepage-Sharing balanciert Performance + Memory; gegen False-Sharing zwischen NUMA-Nodes |

## Bedeutung fuer Comdare-CacheEngine

1. **NUMA-Origin-Aware** = **Pflicht-Konkretisierung** fuer Comdare's Block-AO Multi-Socket-Plattformen — `c06_allocation_engine.aa5_allocation_policy.NumaOriginAware` Atom
2. **Incremental Hugepage-Sharing** = perfekt fuer **Workload-adaptive `c10_topologie_engine`** — Pflicht-Atom fuer NUMA-aware Workloads
3. **Re-Use auf Origin-Node** = wertvolle Erweiterung fuer **PRT-ART Pool A/B/C/D** auf Multi-Socket-Systemen
4. Direkte Interaktion mit **A23 Vmem hierarchical arenas** moeglich: NUMA-Arenas als oberste Hierarchie-Schicht

## Lizenz + Code-Verfuegbarkeit

- **Code:** Forschungsprototyp, vermutlich GitHub bei UMass-Group (Tongping Liu)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A09-numalloc/` (sobald Code-Repo identifiziert; sonst eigene NUMA-Awareness-Re-Implementierung als Studie)

## Verwandte Werke

- Hoard (A01, Berger 2000) — gleiche Forschungsgruppe (Berger), Vorlaeufer
- mimalloc (A04, Leijen 2019) — wurde als Baseline benchmarked, NUMAlloc ist 15.7% schneller
- TCMalloc-NUMA (siehe A14 ASPLOS 2024) — alternative NUMA-Strategie ueber NUCA-aware transfer caches
