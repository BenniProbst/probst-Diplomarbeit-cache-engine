# P27 — Zhang et al. ASPLOS 2025 (Hierarchical Prefetching)

**Voller Titel:** Hierarchical Prefetching: A Software-Hardware Instruction Prefetcher for Server Applications
**Autoren:** Tingji Zhang, Boris Grot, Wenjian He, Yashuai Lv, Peng Qu, Fang Su, Wenxin Wang, Guowei Zhang, Xuefeng Zhang, Youhui Zhang (Tsinghua + Edinburgh + Huawei + Zhongguancun National Lab)
**Venue:** ASPLOS 2025, Rotterdam NL
**DOI:** 10.1145/3676641.3716260
**Volltext:** `_text/P27-ZhangASPLOS2025.txt` (17 Seiten, 88 KB)

## 1. Konzeptionelle Identitaet

**Software-Hardware-cooperative Instruction-Prefetcher** fuer Server-Workloads. Adressiert **Front-End-Bottleneck** durch grossgranularen "Bundle"-Prefetch.

> "Hierarchical Prefetching, a software/hardware cooperative scheme to achieve high prefetch coverage, accuracy and timeliness without profiling or programmer's involvement. Hierarchical Prefetching identifies the code sequences forming high-level functionalities (referred to as Bundles)" (P27:S.3/256-261)

**Klasse:** Instruction-Prefetcher (NICHT Data-Prefetcher!)
**Performance:** **6.6% Average Speedup** ueber FDIP (Fetch-Directed Instruction Prefetching)

## 2. Hauptkonzept: Bundles

> "Bundles are significantly larger than typical prefetch targets, encompassing tens to hundreds of kilobytes of code." (P27:S.2/146-148)

- **Bundle**: Code-Region, die eine "high-level Funktionalitaet" repraesentiert
- **Static Call Graph Analyse** identifiziert Bundles (zur Link-Zeit)
- **Bundle Entry Points** in Hardware getrackt
- **Hardware Record-and-Replay**: Hardware speichert tatsaechlichen Bundle-Footprint zur Runtime und prefetcht beim naechsten Bundle-Eintritt

## 3. Hardware-Anforderungen

- **<2 KB on-chip Storage** (Metadaten in Hauptspeicher)
- Coarse-grained Prefetching → keine Reaktionspflicht auf intra-Bundle Control Flow Varianten

## 4. PRT-ART-Bezug

| Hierarchical-Prefetching-Konzept | PRT-ART-Bezug |
|---|---|
| **Instruction Prefetching (Front-End)** | NICHT in PRT-ART Pflichtkern (Termin 5 explizit ausgeschlossen) |
| **Bundle als coarse-grained Unit** | **konzeptionell aequivalent** zu PRT-ART **Page als Cache-Engine-Unit** |
| **Software-Hardware-Cooperation** | konzeptionell relevant: PRT-ART Cache-Engine ist Software-Layer ueber Hardware-Caches |
| **Coarse-grained vs feine-grained** | wichtig: PRT-ART Cache-Engine arbeitet auf Page-Ebene (coarse), nicht Cache-Line-Ebene (fein) |
| **Record-and-Replay-Mechanik** | konzeptionell verwandt zu PRT-ART **Telemetrie-basierte Hot-Path-Detektion** |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Hierarchical Prefetching Bundle ↔ PRT-ART Page**: beide sind coarse-grained Optimierungs-Einheit
- **Hierarchical Prefetching Software/Hardware Co-Design ↔ PRT-ART Software-Layer Cache-Engine**: gleiche Architektur-Philosophie
- **Hierarchical Prefetching Record+Replay ↔ Zhang FGCS Read Counter (P26) ↔ Dortmund Hot-Path (P28)**: drei "messen-und-wiederholen"-Strategien

## 6. Kernanschluss fuer PRT-ART (Beschraenkte Relevanz)

Hierarchical Prefetching adressiert **Instruction Cache** — bei PRT-ART explizit als **sekundaer / out-of-scope** behandelt (Termin 5 nachgezogen):

> "Behauptungen zur expliziten Programm-/Instruction-Cache-Steuerung [...] sind vorsichtig zu behandeln; die Literaturbasis ist hier deutlich schwaecher."

Aber **konzeptionell wichtig**:
- **Coarse-grained Software-Hardware-Cooperation** als Architektur-Pattern
- **Bundle ↔ Page** als Unit-of-Optimization
- **<2KB Hardware-Storage** = "leichtgewichtige" Hardware-Anforderung

PRT-ART **lernt von Hierarchical Prefetching**: Cache-Engine soll **leichtgewichtig** sein (kein grosser Hardware-Footprint, kein komplexer Software-Overhead).
