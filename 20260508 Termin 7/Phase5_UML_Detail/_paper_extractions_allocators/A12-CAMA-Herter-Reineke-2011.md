# A12 — CAMA: A Predictable Cache-Aware Memory Allocator

## Bibliographie
- **Titel:** CAMA: A Predictable Cache-Aware Memory Allocator
- **Autoren:** Joerg Herter, Peter Backes, Florian Haupenthal, Jan Reineke (Universitaet des Saarlandes)
- **Venue:** **ECRTS 2011** (Euromicro Conference on Real-Time Systems) — NICHT RTAS! (Korrektur zu REV-7-Liste)
- **PDF-Quelle:** [www.rw.cdl.uni-saarland.de/people/jherter/private/papers/CAMAecrts11.pdf](https://www.rw.cdl.uni-saarland.de/people/jherter/private/papers/CAMAecrts11.pdf)
- **IEEE Xplore:** [ieeexplore.ieee.org/document/6001767](https://ieeexplore.ieee.org/document/6001767/) (RTAS 2011 — der Eintrag verweist zur Konferenz, der Volltext ist ECRTS-2011-Variante)
- **Status:** **Niche** — Real-Time Systems / WCET-Analysis Domain

## Kerninnovation

CAMA ist ein **WCET-analysefaehiger** (Worst-Case Execution Time) Allokator fuer **Real-Time Systems**:

1. **Constant-Time** Allocations + Deallocations
2. **Cache-Set-Directed** Allocations: User kann Cache-Set spezifizieren, in den ein neuer Block gemappt werden soll → predictable cache behavior
3. **Keine** unkontrollierte Cache-Pollution

## Cache-Set-Directed Allocation

```c
void* cama_alloc(size_t size, cache_set_t target_set);
```

- Klassische Allokatoren: `malloc(size)` → Adresse = unbekannt → Cache-Mapping = unkontrolliert
- CAMA: `cama_alloc(size, set)` → Adresse so gewaehlt, dass **`addr & cache_index_mask == set`** → Block landet **garantiert** in `target_set`

→ Ermoeglicht **statische Cache-Behavior-Analyse**:
- Welche Blocks sind im Cache zur Zeit T?
- Welche Cache-Misses sind moeglich?
- Was ist die WCET einer Funktion?

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | CAMA-Konkretisierung |
|-------|----------------------|
| **AA1 FreeList-Topologie** | Pro Cache-Set eine eigene Free-List → User waehlt Set, allociert daraus |
| **AA2 Size-Class-Schema** | Power-of-2 mit Cache-Line-Multiplikator (Cache-Aware-Padding) |
| **AA3 Thread-Locality** | Originale Form: nicht thread-aware (single-threaded RT-Apps); Erweiterungen moeglich |
| **AA4 Synchronization** | Single-Lock (RT-Apps oft single-threaded) oder per-Cache-Set-Lock |
| **AA5 Allocation-Policy** | **Cache-Set-Directed** — User-controlled placement |
| **AA6 Reclamation** | Constant-Time Free durch Cache-Set-spezifische Free-Liste |
| **AA7 Fragmentation-Strategy** | Etwas Memory-Overhead durch Cache-Set-Padding; aber WCET-faehig |

## Bedeutung fuer Comdare-CacheEngine

1. **Cache-Set-Directed Allocation** = **innovative** Alternative zu Slab-Coloring (A02 Bonwick) — statt zufaelliger Cache-Verteilung **deterministische** Set-Wahl
2. **Constant-Time Garantien** = wertvoll fuer **PRT-ART Real-Time-Variants** (z.B. Search-Latency-Garantien fuer Database-Workloads)
3. **WCET-Analysis** = aus akademischer Sicht **analytisch relevant** fuer Diplomarbeit-Performance-Modelle (analog SuRF P10's I/O-bound vs CPU-bound-Modelle)
4. **Niche-Allokator** = **NICHT** als Default-Achse-Wert empfohlen, aber als **Pflicht-Permutations-Option** fuer Latency-Sensitive-Tests
5. Direkte Verbindung zu **PRT-ART Density-Tracker** (REV 6 §5.17): Density-aware cache-set-targeted allocation koennte Cache-Conflict-Misses minimieren

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** Forschungs-Code, Lizenz unklar — direkt bei Autoren erfragen
- **Repo:** vermutlich Universitaet Saarland intern; nicht oeffentlich auf GitHub gefunden
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A12-cama-herter/` (eigene Re-Implementation der Cache-Set-Directed-Allocation als Algorithmus-Studie analog zu A19 Buddy)

## Verwandte Werke

- Bonwick Slab Coloring (A02, 1994) — alternative Cache-Aware-Strategy (zufaelliges Coloring statt Cache-Set-Directed)
- Cache Index-Aware Memory Allocation (Afek, ISMM 2011) — verwandte Idee zur gleichen Zeit
- PRADA: Predictable Allocations by Deferred Actions — verwandtes RT-Allokator-Konzept
- Linux CMA (Contiguous Memory Allocator) — Embedded RT-Kontext
