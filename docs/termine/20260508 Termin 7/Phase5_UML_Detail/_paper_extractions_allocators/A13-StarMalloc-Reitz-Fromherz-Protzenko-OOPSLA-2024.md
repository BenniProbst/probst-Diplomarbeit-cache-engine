# A13 — StarMalloc: A Formally Verified, Concurrent, Performant, and Security-Oriented Memory Allocator

## Bibliographie
- **Titel:** StarMalloc: Verifying a Modern, Hardened Memory Allocator
- **Autoren:** Antonin Reitz, Aymeric Fromherz, Jonathan Protzenko (Inria Prosecco) — **NICHT** Bourgeat/Erbsen wie in REV-7-Liste! (Korrektur)
- **Venue:** **OOPSLA 2024** — Proc. ACM Program. Lang. Vol 8 — NICHT nur arXiv!
- **DOI:** 10.1145/3689773
- **arXiv:** [arxiv.org/abs/2403.09435](https://arxiv.org/abs/2403.09435) (March 2024 preprint)
- **Code-Repo:** [github.com/Inria-Prosecco/StarMalloc](https://github.com/Inria-Prosecco/StarMalloc)
- **Artifact:** [zenodo.org/records/12670476](https://zenodo.org/records/12670476)
- **Status:** **Erster verifizierter, hardened Allokator** der Drop-in-Replacement-faehig ist

## Kerninnovation — Formale Verifikation eines hardened Allokators

StarMalloc ist die **erste Verifikation eines modernen Hardened Memory Allocators** der **production-ready** ist (drop-in fuer Firefox getestet).

**Verwendete Verification:**
- **Steel** Separation Logic Framework (F* + SteelCore)
- **Dependent Types** + Modulare Abstraktionen
- Effizient verifizierbar trotz komplexer concurrent + low-level data structures

## Verifizierte Komponenten

StarMalloc verifiziert:
1. **Slabs** (analog A02 Bonwick)
2. **Separate Metadata** (gehaerteter Speicher fuer Bookkeeping)
3. **Contiguous Size Classes**
4. **Bitmaps + Bit-level Arithmetic** (lock-free Free-Tracking)
5. **Doubly-linked Lists within static array** (kein Pointer-Spaghetti)
6. **AVL Trees** mit Constant-Time Metadata-Access
7. **FIFO Queues** (lock-free reclamation)
8. **Security Mechanisms:**
   - Zeroing on free
   - Guard Pages between slabs
   - Quarantine fuer recently-freed memory

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | StarMalloc-Konkretisierung |
|-------|----------------------------|
| **AA1 FreeList-Topologie** | Bitmap pro Slab + AVL-Tree fuer Slab-Metadata + FIFO Queue fuer Reclamation |
| **AA2 Size-Class-Schema** | Contiguous Size Classes (analog jemalloc/tcmalloc) |
| **AA3 Thread-Locality** | Concurrent design; details siehe Paper |
| **AA4 Synchronization** | **Verifiziert lock-free** wo eingesetzt; AVL-Trees mit Constant-Time-Operations |
| **AA5 Allocation-Policy** | Standard-Hierarchie: Slab-Hit → Slab-Allocation; durchweg verified |
| **AA6 Reclamation** | Lock-free FIFO + Quarantine (security feature); Zeroing-on-Free |
| **AA7 Fragmentation-Strategy** | Hardening: Guard-Pages zwischen Slabs (Detection von Heap-Overflows); Separate Metadata-Region |

## Hardening-Features (Security-Oriented)

| Feature | Schutz-Wirkung |
|---------|----------------|
| **Zeroing on Free** | Verhindert Information-Leakage an naechsten Allocator-User |
| **Guard Pages** | Heap-Overflow → Page-Fault → klare Crash-Diagnose |
| **Quarantine** | Use-After-Free wird detektiert (Page bleibt nicht-mapped fuer N Frees) |
| **Separate Metadata** | Heap-Overflow ueberschreibt nicht Allokator-Bookkeeping |
| **Bitmap-based Free-Tracking** | Double-Free wird detektiert (bitmap state check) |

## Performance-Resultate

- Eval gegen **10 state-of-the-art Allokatoren**
- Drop-in-Replacement in **Firefox** getestet → produktionstauglich
- Performance-Overhead durch Verification + Hardening: typisch **2-5%** vs hardened tcmalloc, akzeptabel fuer Security-Critical Apps

## Steel Separation Logic Framework

**Steel** = Erweiterung von F* mit:
- **Separation Logic** (Reasoning ueber Memory Aliasing)
- **Concurrent Logic** (Reasoning ueber atomics, locks, lock-free patterns)
- **SteelCore** = Foundation
- **Pulse** = neuere DSL-Variante (relevante Folge-Arbeit)

→ ermoeglicht Verifikation ohne **manuelle Proofs** ueberall — viele Beweise automatisierbar.

## Bedeutung fuer Comdare-CacheEngine

1. **Formal Verified Allokator** = wertvolle **Pflicht-Permutations-Option** fuer **Trust-Critical Workloads** (Database-Engines, Crypto-Code)
2. **Hardening-Features** = direkt anwendbar fuer Comdare's Security-Variante (analog smimalloc in A04)
3. **Steel + F\* Verification-Toolchain** = Forschungs-Reference; **NICHT** als Diplomarbeit-Pflicht-Implementation, aber als **akademische Reference** im Vergleich
4. **Quarantine + Guard Pages** als optionale `c10_topologie_engine` Atome
5. **Bitmap-Free-Tracking + AVL-Tree-Metadata** = sehr saubere Datenstrukturen — **gute Vorlage** fuer Comdare's eigenes Allokator-Skelett-Design

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** im Repo zu pruefen (vermutlich Apache-2.0 oder MIT)
- **Repo:** [github.com/Inria-Prosecco/StarMalloc](https://github.com/Inria-Prosecco/StarMalloc) (Maintainer: @cmovcc)
- **Build:** F* + Steel Verification-Stack noetig (komplexer Build)
- **Plattformen:** Linux primarily; verifiziert
- **Artifact:** Vollstaendiges OOPSLA-2024-Artifact auf Zenodo
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A13-starmalloc/` (klonen + STRUKTUR_NOTIZ + nicht in Default-Build wegen F\*-Build-Komplexitaet)

## Verwandte Werke

- A04 mimalloc (smimalloc Variant) — Hardening ohne formale Verifikation
- A07 snmalloc — verwendet in Verona, aehnliche Sicherheits-Awareness
- F\* / Steel — Verification Framework
- Pulse — moderne Steel-DSL
- DieHard (Berger, Zorn) — Random-Allocation als Heap-Hardening
- DieHarder — Improved DieHard
