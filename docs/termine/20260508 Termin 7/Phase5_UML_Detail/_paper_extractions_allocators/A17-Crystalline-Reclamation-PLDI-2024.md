# A17 — A Family of Fast and Memory Efficient Lock- and Wait-Free Reclamation (Crystalline)

## Bibliographie
- **Titel:** A Family of Fast and Memory Efficient Lock- and Wait-Free Reclamation
- **Autoren:** (Hauptautor Ruslan Nikolaev — siehe scispace Ref) — Dakota State / Penn State
- **Venue:** PLDI 2024 (45th ACM SIGPLAN Conference on Programming Language Design and Implementation), June 2024
- **DOI:** 10.1145/3658851
- **Slides-PDF:** [rusnikola.github.io/files/crystalline-pldi24-slides.pdf](https://rusnikola.github.io/files/crystalline-pldi24-slides.pdf)
- **PLDI24 Paper-Page:** [pldi24.sigplan.org/details/pldi-2024-papers/89](https://pldi24.sigplan.org/details/pldi-2024-papers/89/A-Family-of-Fast-and-Memory-Efficient-Lock-and-Wait-Free-Reclamation)
- **Status:** **State-of-the-art** Memory-Reclamation-Family (2024)

## Kerninnovation — Crystalline Reclamation Family

Crystalline ist eine **Familie** von non-blocking Memory-Reclamation-Schemes, die **gleichzeitig**:
1. **High Performance** (vergleichbar mit Epoch-Based-Reclamation)
2. **High Memory Efficiency** (vergleichbar mit Hazard-Pointers)
3. **Wait-Freedom** (echter wait-free, nicht nur lock-free!)

erreicht.

## Hintergrund — 3 klassische Memory-Reclamation-Approaches

| Approach | Performance | Memory Efficiency | Progress Garantie |
|----------|-------------|---------------------|-------------------|
| **Reference Counting** | NIEDRIG (atomic incr/decr) | Mittel | lock-free |
| **Epoch-Based Reclamation (EBR)** | **HOCH** | NIEDRIG (unbounded memory) | **blocking** |
| **Hazard Pointers (HP)** | NIEDRIG (per-access overhead) | **HOCH** | non-blocking |
| **Crystalline** | **HOCH** | **HOCH** | **wait-free** |

→ Crystalline ist **Pareto-frontier-Verbesserung**.

## Crystalline Algorithmus (high-level)

Crystalline nutzt:
- **Asynchrone Reclamation:** jeder Thread kann von jedem anderen Thread retired-Memory reclaimen
- **Balanced Workload:** kein Thread macht alle Reclamation-Arbeit
- **Wait-Freedom auch bei dynamic Thread-Recycling**
- **Architektur-Support:** ubiquitous x86-64 + ARM64

## Bausteine-Achsen-Mapping (AA1-AA7) — Reclamation-fokussiert

Crystalline ist **kein vollstaendiger Allokator**, sondern eine **Reclamation-Subsystem-Familie**. Mapping:

| Achse | Crystalline-Konkretisierung |
|-------|------------------------------|
| **AA1 FreeList-Topologie** | Crystalline-spezifische Retired-Object-Lists (per-thread mit cross-thread access) |
| **AA2 Size-Class-Schema** | Allocator-agnostic — kann mit jedem Slab-Allokator kombiniert werden |
| **AA3 Thread-Locality** | Per-Thread Retired-List + asynchrone Cross-Thread-Reclamation |
| **AA4 Synchronization** | **Wait-free** (stronger als lock-free!); ubiquitous x86-64 + ARM64 atomics |
| **AA5 Allocation-Policy** | N/A (allocation outside Crystalline-Scope) |
| **AA6 Reclamation** | **Kern-Beitrag:** wait-free, asynchrone, balanced reclamation |
| **AA7 Fragmentation-Strategy** | Bounded memory usage (im Gegensatz zu EBR's unbounded growth) |

## Performance-Eigenschaften

- **Throughput superior to EBR** als Thread-Count waechst
- **Memory bounded** (unlike EBR which grows unbounded under contention)
- **Wait-free progress** auch bei dynamic thread recycling

## Bedeutung fuer Comdare-CacheEngine

1. **Wait-Free Reclamation** = staerkstes mathematisches Garantielevel — wertvoll fuer **Real-Time Comdare-Variants** (analog A12 CAMA fuer cache-aware RT)
2. **Pflicht-Konkretisierung** fuer `c04_coherence_engine.aa6_reclamation.WaitFreeCrystalline` Atom
3. **Allocator-agnostic** — Crystalline kann mit Comdare's eigenem Allokator kombiniert werden (nicht entweder/oder)
4. **Bridge zu PRT-ART OLC + Reservierte Value-Bloecke (REV 6 §5.17):** Crystalline ist Reclamation-Level; OLC ist Concurrency-Control-Level → komplementaer
5. **Direkter Bezug zu Task #104 RCU-Implementation:** Crystalline ist eine moderne Alternative/Erweiterung zu RCU
6. **2024-State-of-the-Art** = Diplomarbeit-Aktualitaets-Pflicht: muss zitiert/erwaehnt werden in Comdare's Concurrency-Sektion

## Lizenz + Code-Verfuegbarkeit

- **Code:** vermutlich oeffentlich bei Ruslan Nikolaev (Penn State); GitHub-Suche notwendig
- **PDF Slides:** kostenlos via Slides-Link
- **Paper:** ACM-Open-Access (PLDI 2024)
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A17-crystalline-reclamation/`

## Verwandte Werke

- **Hazard Pointers** (Michael 2004 IEEE TPDS) — alternative non-blocking reclamation, langsamer als Crystalline
- **Epoch-Based Reclamation (EBR)** — schneller aber blocking + unbounded memory
- **Reference Counting** — einfach aber langsam
- **A03 Michael Lock-Free (PLDI 2004)** — historisch erster lock-free Allokator (Allocator-Level)
- **A11 LRMalloc** — moderne lock-free Allokator mit Hazard-Pointer-style descriptor reclamation
- **Wait-Free Weak Reference Counting** (ISMM 2023) — verwandte Reclamation-Innovation
- **Task #104 RCU-Implementation** — Comdare-internes Reclamation-Subsystem
