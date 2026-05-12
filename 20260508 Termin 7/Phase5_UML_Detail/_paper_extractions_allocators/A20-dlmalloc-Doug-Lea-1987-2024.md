# A20 — Doug Lea's malloc (dlmalloc)

## Bibliographie
- **Autor:** Doug Lea (SUNY Oswego, USA)
- **Erste Version:** 1987 (kontinuierlich gepflegt bis 2024+)
- **Online-Doku:** [gee.cs.oswego.edu/dl/html/malloc.html](https://gee.cs.oswego.edu/dl/html/malloc.html)
- **Tufts-Mirror:** [www.cs.tufts.edu/~nr/cs257/archive/doug-lea/malloc.html](https://www.cs.tufts.edu/~nr/cs257/archive/doug-lea/malloc.html)
- **Code-Repos:**
  - [github.com/sailfish009/malloc](https://github.com/sailfish009/malloc)
  - [github.com/ennorehling/dlmalloc](https://github.com/ennorehling/dlmalloc)
  - [github.com/ARMmbed/dlmalloc](https://github.com/ARMmbed/dlmalloc) (embedded variant)
- **Status:** **Klassiker** — Vorlage fuer ptmalloc2 (A21) → glibc-malloc; embedded verwendung weit verbreitet

## Kerninnovation

**Boundary Tags + Bins**: dlmalloc kombiniert die zwei klassischen Storage-Allokator-Strategien zu einem **single-thread-effizienten** Algorithmus mit:
- **Boundary Tags** fuer schnelles Coalescing (von Knuth)
- **Best-Fit via Binning** fuer Speed
- **Heuristische Verbesserungen:** Locality-Preservation, Wilderness-Preservation, mmap-Threshold

## Chunk-Struktur

```
Allocated Chunk:                  Free Chunk:
+----------------+                +-------------------+
| prev_size      | ← only valid   | prev_size         |
|   (8 bytes)    |   if previous  | size + flags      |
+----------------+   is FREE      | fwd ptr to next   | ← in bin's
| size + flags   | ← always       | bwd ptr to prev   |   doubly-linked
| (PREV_INUSE,   |                | ... user data     |   list
|  IS_MMAPED,    |                | (unused)          |
|  NON_MAIN_ARENA)|               +-------------------+
+----------------+
| user data...   |
| ...            |
+----------------+
```

- **8-Byte aligned** chunks
- Header overhead: **8 oder 16 Byte** je nach Architektur
- **Minimum chunk size:** 24 Bytes
- **prev_size field:** valid nur wenn previous chunk free (otherwise overlaid by user data!)

## Bin-Struktur

| Bin-Typ | Range | Mechanismus |
|---------|-------|-------------|
| **Smallbin** | < 256 Byte | Power-of-2-best-fit, doubly-linked list pro Size |
| **Treebin** | ≥ 256 Byte | Trie/Tree-basiert fuer best-fit unter den varying Sizes |
| **Top Chunk (Wilderness)** | residual heap | Niemals coalesced, immer am Ende |
| **mmap-Chunks** | > mmap_threshold (~128 KiB) | Direkt mmap, getrennt vom main heap |

## Algorithmus

```
malloc(size):
  if (size < 256):
      bin = smallbin[ceil(size / 8)]    # 32 smallbins (24-256 byte chunks)
      if (bin.has_chunk):
          return bin.pop_first()
      # Spill to next-larger smallbin
  if (size < 256):
      bin = smallbin[next_larger_index]
      if (bin.has_chunk):
          chunk = bin.pop_first()
          split chunk; return larger half;
  # Large request: search treebin
  if (size >= 256):
      tree_node = treebin.find_best_fit(size)
      if (found):
          return split + return;
  # Try wilderness
  if (top_chunk.size >= size):
      return split top_chunk;
  # Last resort: sbrk or mmap
  if (size >= mmap_threshold):
      return mmap_chunk(size);
  else:
      sbrk(more_memory); retry;
```

## Bausteine-Achsen-Mapping (AA1-AA7)

| Achse | dlmalloc-Konkretisierung |
|-------|--------------------------|
| **AA1 FreeList-Topologie** | Smallbin: 32 doubly-linked lists; Treebin: Trie-basiert fuer >256 Byte; Wilderness top chunk |
| **AA2 Size-Class-Schema** | 32 Smallbins (8-Byte steps bis 256 Byte) + Trie fuer Large; mmap-Threshold separation |
| **AA3 Thread-Locality** | **NEIN** (single-thread original); ptmalloc2 (A21) erweitert um Multi-Thread |
| **AA4 Synchronization** | Single global lock (single-thread original); ptmalloc2 fuegt per-arena lock hinzu |
| **AA5 Allocation-Policy** | Best-fit via binning; first-fit fallback; wilderness preservation |
| **AA6 Reclamation** | Boundary-Tag-Coalescing in O(1) bei Free; consolidate-on-failure |
| **AA7 Fragmentation-Strategy** | Boundary-Tag-Coalesce + 8-Byte alignment + mmap-cutoff fuer large reduces external frag |

## Wichtige Heuristics

- **Locality Preservation:** Free-blocks bleiben im selben Bin → re-use is cache-hot
- **Wilderness Preservation:** Top-chunk wird nicht consolidiert → kann immer wachsen
- **mmap Threshold:** large allocs ≥ 128 KiB → direkt mmap, getrennt vom heap
- **fastbins** (in newer versions): Cache fuer kleinste sizes ohne coalesce

## Bedeutung fuer Comdare-CacheEngine

1. **Boundary Tags Pattern** = bekannt + bewaehrt — Pflicht-Studie als Algorithmus-Vorlage; aber NICHT als Default in modernen Per-CPU-Cache-Allokatoren
2. **mmap-Threshold-Pattern** = Pflicht-Konkretisierung fuer Large-Object-Handling in Comdare (analog A04 mimalloc Huge Objects > 512 KiB)
3. **Wilderness Preservation** = analog Comdare's Pool-Reservoir-Konzept
4. **dlmalloc als Vergleichs-Baseline** in Phase-7 Experiment-Loop — historischer Kontext
5. **Embedded-Use-Cases** (ARMmbed, microcontroller) = bestaetigt dlmalloc fuer **resource-constrained Comdare-Variants** (Embedded-Block-AO Pflicht-Plattformen)

## Lizenz + Code-Verfuegbarkeit

- **Lizenz:** **Public Domain** (Creative Commons CC0-equivalent — Doug Lea explicit released)
- **Repos:** mehrere Mirrors, alle Public Domain
- **Plattformen:** universal — embedded, Linux, Windows, macOS, BSD, RTOS
- Klone-Pfad fuer Phase 6.2.C: `comdare-cache-engine/ext/A20-dlmalloc/` (vollstaendig + STRUKTUR_NOTIZ.md)

## Verwandte Werke

- A21 ptmalloc2 (Wolfram Gloger) — Multi-Thread-Erweiterung von dlmalloc-2.7.0
- glibc malloc — basiert auf ptmalloc2
- Knuth Buddy (A19) — Vorlaeufer-Algorithmus
- Hoard (A01) — moderner Multi-Thread-Konkurrent
- A18 Exgen-Malloc (2025) — moderner Single-Thread-Konkurrent (1.17× faster than dlmalloc)
