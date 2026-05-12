# A10 — rpmalloc: Public Domain Lock-Free Thread-Caching Allocator

## Bibliographie
- **Autor:** Mattias Jansson (Rampant Pixels, danach Eigenprojekt)
- **Venue:** Kein formal-publiziertes Paper — Code + README
- **Code-Repo:** [github.com/mjansson/rpmalloc](https://github.com/mjansson/rpmalloc)
- **Lizenz:** **Public Domain** (Unlicense) ODER MIT (User-Choice)
- **Code-Groesse:** ~2000 LOC C (single source file)
- **Status:** Production-grade — verwendet in Game Engines, Embedded Systems, MS Hyper-V, Coherent Labs Forks

## Kerninnovation

**Lock-frei + Thread-Caching + 16-Byte (oder 32-Byte) Aligned + Cross-Platform** — minimalistischer, hochperformanter Allokator als **single-file C library**.

## Architektur

```
malloc(size)
   ↓
[1] Thread Cache (per-thread, no lock)
   ↓
[2] Global Cache (cross-thread, lock-free)
   ↓
[3] mmap/VirtualAlloc (OS)
```

### Adaptive Thread Cache Sizing
- Each cache limited by **% of max allocation count** of corresponding size class
- **Adaptive scheme** — passt sich an Workload an

### Global Cache Bounding
- Multiple of max thread cache size
- Acts als Reservoir fuer Cross-Thread-Frees

### 16-Byte vs 32-Byte Alignment
- Default: **16-Byte aligned** (mjansson Variant)
- Alternative: **32-Byte aligned** (readablesystems Fork — fuer SIMD-AVX2 Workloads)

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | rpmalloc-Konkretisierung |
|-------|---------------------------|
| **AA1 FreeList-Topologie** | Thread-local + Global Cache; intern aehnlich tcmalloc-style |
| **AA2 Size-Class-Schema** | Power-of-2 + Padding fuer 16-Byte Alignment; Konstante Anzahl Size-Classes |
| **AA3 Thread-Locality** | Per-Thread Cache + Global Reservoir |
| **AA4 Synchronization** | **Vollstaendig lock-free** (atomics only) |
| **AA5 Allocation-Policy** | Hot: thread cache pop; Slow: global cache; OS-fall-back: mmap |
| **AA6 Reclamation** | Adaptive size based on max allocation count; cache-spillover to global at threshold |
| **AA7 Fragmentation-Strategy** | Aequivalente Fragmentation zu tcmalloc (vergleichbare Power-of-2 size classes) |

## Performance

Aus rpmalloc README:
- **Faster** als tcmalloc, hoard, ptmalloc3 (without extra memory overhead)
- "Without causing extra allocated memory overhead in the thread caches compared to these allocators"
- Im mimalloc-Paper Figure 2: rpmalloc (rp) ist **competitive** auf cfrac/espresso/barnes (~1.13× vs mi), aber **schwach** auf larsonN (3.14×) und sh6benchN (2.36×)

## Bedeutung fuer Comdare-CacheEngine

1. **Public Domain Lizenz** = **maximale Freiheit** fuer Comdare-Integration — kein License-Concern
2. **Single-File-C-Library (~2000 LOC)** = trivial zu **embeddable** in Comdare-Cache-Engine; ideal fuer Talos-OS-Plattformen mit minimalem Footprint
3. **16- vs 32-Byte Alignment Variant** = Pflicht-Konkretisierung fuer SIMD-Workloads (AVX2/AVX-512 Pflicht-Block-AO-Plattformen)
4. **Adaptive Cache-Sizing** als `c09_heuristik_engine` Atom — Beispiel fuer einfache Workload-Adaption
5. **Game-Engine + Embedded-Use-Case** = bestaetigt rpmalloc fuer **Real-Time/Latency-Sensitive** Workloads

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** Public Domain (Unlicense) ODER MIT
- **Repo:** [github.com/mjansson/rpmalloc](https://github.com/mjansson/rpmalloc) (aktiv)
- **Plattformen:** Linux, FreeBSD, macOS, Windows, iOS, Android
- **Embedded-Friendly:** kein OS-spezifisches Coding noetig, simple `mmap`/`VirtualAlloc` API
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A10-rpmalloc/` (vollstaendig, single-file)

## Forks

- **CoherentLabs/rpmalloc** — C++ port
- **readablesystems/rpmalloc** — 32-Byte aligned variant
- **FeralInteractive/rpmalloc** — Linux Game-Porting Fokus
- **zelang-dev/rpmalloc** — modernes Update

## Verwandte Werke

- mimalloc (A04, 2019) — moderner Konkurrent mit Free-List-Sharding
- tcmalloc (A06, Google) — schwergewichtiger Konkurrent
- jemalloc (A05, Evans) — schwergewichtig
- snmalloc (A07) — moderner Message-Passing-Konkurrent
