"""Bulk-Konvertierung aller PDFs in ./Forschungsarbeiten zu Volltext.
Schreibt in _review/papers/_text/<paper-id>.txt. Mit Filename-zu-PaperID-Mapping."""
import sys
from pathlib import Path
from pypdf import PdfReader

SRC  = Path(r"C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\Forschungsarbeiten")
DEST = Path(r"C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\20260508 Termin 7\_review\papers\_text")
DEST.mkdir(parents=True, exist_ok=True)

# Filename -> Paper-ID Mapping (gemaess Tasks 3.B.2 ff)
MAPPING = {
    "The_adaptive_radix_tree_ARTful_indexing_for_main-memory_databases.pdf":
        "P01-ART-Leis2013",
    "HOT - A Height Optimized Trie Index for Main-MemoryDatabase Systems.pdf":
        "P02-HOT-Binna2018",
    "Cache Craftiness for Fast Multicore Key-Value Storage.pdf":
        "P03-Masstree-Mao2012",
    "CoCo-trie - Data-aware compressionandindexingofstrings.pdf":
        "P04-CoCo-trie-Boffa2024",
    "START– Self-Tuning Adaptive Radix Tree.pdf":
        "P05-START-Fent2020",
    "B2-Tree - Page-Based String Indexing in Concurrent Environments.pdf":
        "P06-B2tree-Schmeisser2022",
    "Wormhole - A Fast Ordered Index for In-memory DataManagement.pdf":
        "P07-Wormhole-Wu2019",
    "The ART of Practical Synchronization.pdf":
        "P08-ARTSync-Leis2016",
    "Space-efficient_static_trees_and_graphs.pdf":
        "P09-Jacobson1989-LOUDS",
    "SuRF Practical Range Query Filtering with Fast Succinct Tries.pdf":
        "P10-SuRF-Zhang2018",
    "Cache Conscious Indexing for Decision-Support in Main Memory.pdf":
        "P11-CSS-RaoRoss1999",
    "Making B+-Trees Cache Conscious in Main Memory.pdf":
        "P12-CSB-RaoRoss2000",
    "Effect of Node Size on the Performance ofCache-Conscious B+-trees.pdf":
        "P13-Hankins2003",
    "Making CSB+-Trees Processor Conscious - Paper.pdf":
        "P14-Samuel2005",
    "B-tree Indexes and CPU Caches.pdf":
        "P15-Graefe2001",
    "Tree Layout in Multilevel Memory (BenderDemaineFarach-Colton 2002).pdf":
        "P16-BenderTreeLayout2002",
    "CACHE-OBLIVIOUS B-TREES.pdf":
        "P17-BenderCacheObliv2005",
    "Cache-sensitive Memory Layout for Binary Trees.pdf":
        "P18-Saikkonen2008",
    "Cache-Sensitive Memory Layout for Dynamic Binary Trees.pdf":
        "P19-Saikkonen2016",
    "B-Trees Are Back - Engineering Fast and Pageable Node Layouts.pdf":
        "P20-BTreesAreBack-Mueller2025",
    "Improving Index Performance through Prefetching.pdf":
        "P21-ChenPB2001",
    "Fractal Prefetching B+-Trees (Chen et al. 2002).pdf":
        "P22-ChenFractal2002",
    "Data Cache Prefetching With DynamicAdaptation.pdf":
        "P23-Khan2010",
    "WhyDoes Data Prefetching Not Work for Modern Workloads.pdf":
        "P24-NaderanTahan2016",
    "Fetch Me If You Can - Evaluating CPU Cache Prefetching and Its Reliability on High Latency Memory.pdf":
        "P25-Mahling2025",
    "Aprefetching indexingschemeforin-memorydatabasesystems.pdf":
        "P26-ZhangFGCS2024",
    "ZhangEtalASPLOS2025HierarchicalPrefetching.pdf":
        "P27-ZhangASPLOS2025",
    "Towards Data-Based Cache Optimization of B+-Trees.pdf":
        "P28-Kuehn2023",
    "Read-Copy Update.pdf":
        "P29-RCU-McKenney2001",
    "Hazard Pointers - Safe Memory Reclamation for Lock-Free Objects.pdf":
        "P30-HazardPointers-Michael2004",
    "Overview on Hardware Optimizations for Database Engines.pdf":
        "P31-Ungethuem2017",
    "To stride or not to stride the memory access.pdf":
        "P32-ToStride2025",
    "vampir-poster-spp2377-p1-kickoff.pdf":
        "P33-VAMPIR-Berthold2023",
}

ok = 0
err = 0
for fname, pid in MAPPING.items():
    src = SRC / fname
    dst = DEST / f"{pid}.txt"
    if not src.exists():
        print(f"MISSING: {fname}", file=sys.stderr)
        err += 1
        continue
    try:
        r = PdfReader(str(src))
        parts = [f"=== PAPER: {pid}",
                 f"=== FILENAME: {fname}",
                 f"=== PAGES: {len(r.pages)}",
                 ""]
        for i, p in enumerate(r.pages):
            try:
                t = p.extract_text() or ""
            except Exception as e:
                t = f"<!-- EXTRACT ERROR PAGE {i+1}: {e} -->"
            parts.append(f"--- PAGE {i+1} ---")
            parts.append(t)
            parts.append("")
        dst.write_text("\n".join(parts), encoding="utf-8")
        size = dst.stat().st_size
        print(f"OK [{pid}] -> {dst.name} ({len(r.pages)} pages, {size} chars)")
        ok += 1
    except Exception as e:
        print(f"FAIL [{pid}]: {e}", file=sys.stderr)
        err += 1

print(f"\nGesamt: {ok} OK, {err} Fehler -> {DEST}")
