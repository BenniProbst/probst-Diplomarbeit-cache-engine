# Termin 6 — Konsolidierung

**Datum:** 2026-04-16
**Hauptthema:** Plattformmatrix · Benchmarks · **Messalgorithmen zur Verifikation der automatischen Cache-Engine-Funktionalitaet**
**Zustand:** Verifikationsstrategie eingefroren

## Zentrale Texte

- `20260416 Termin 6__20260416_PRT_ART_Termin6_Scope_Freeze_final.docx`
- `20260416 Termin 6__20260416_Arbeitsaufstellung_PRT_ART_Termin6_final.docx`

## Leitfrage (Schluessel-Statement!)

> "Die Cache-Engine wird **ueber Architektur-Extrema verifiziert**. Sie ist nur dann erfolgreich, wenn sie auf deutlich unterschiedlichen Plattformen automatisch andere, aber konsistent bessere Seitentyp-, Layout-, Prefetch- und Value-Ablage-Entscheidungen hervorbringt als ein passives, statisches Layout."

## Pflichtplattformen + Rolle

| Plattform | Klasse / ISA | Hardwarepunkt | Rolle |
|---|---|---|---|
| VisionFive 2 | RISC-V RV64GC, scalar | quad-core JH7110, 2 MB L2, LPDDR4 | Skalare Untergrenze ohne Server-/Desktop-SIMD |
| Raspberry Pi 5 | Arm Cortex-A76, arm_neon | 4 Kerne, 512 KB L2/Kern, 2 MB L3 | Kleine Arm-Cache-Hierarchie + Embedded-Latenz |
| Mac mini M1 | Apple arm64, NEON/Apple SIMD | 8 Kerne (4P+4E), Apple-Silicon | macOS, asymmetrische Cores, Process Pinning |
| ODROID-H4 Ultra | x86 E-core-only, AVX2 | Intel N305, 8C/8T, single-channel DDR5-4800 | x86 ohne P-Cores, AVX2 auf kleiner Cache-Basis |
| i7-1270P | x86 Hybrid, AVX2 | 4P+8E, 18 MB Smart Cache | Lokaler Hybrid-Hauptpfad |
| i9-14900KS | x86 Hybrid Desktop, AVX2 | 8P+16E, DDR5-5600, 36 MB Smart Cache | Grosser Intel-Desktoppfad ohne AVX-512 |
| Ryzen 9 9950X3D2 | x86 Zen 5 + 3D V-Cache, AVX-512 | 16C/32T, 192 MB L3, DDR5-5600 | Grosser AMD-Desktoppfad mit massivem LLC |
| Barnard | Intel Sapphire Rapids, AVX-512 | 2× Xeon 8470, DDR5-4800, AVX-512/AMX | **Server-x86-Pflichtplattform** |
| Grace Hopper GH200 | Arm Server, arm_sve2 | 72 Neoverse V2, 480 GB LPDDR5X, 900 GB/s C2C | **Arm-Server-Pflichtplattform** mit SVE2 |
| Capella (optional) | AMD EPYC 9334 | 8 NUMA-Domains | AMD-Servergegenpol zu Barnard |

## Kalibrierungs-Mikrobenchmarks (Cache-Engine-Vorbereitung)

| Familie | Pflichttests | Zielgroesse | Nutzen |
|---|---|---|---|
| Kalibrierung | Working-set staircase, stride sweep, dependent pointer chase, prefetch-distance sweep, TLB/page sweep | L1/L2/L3/DRAM-Knicke, Seiten-/TLB-Kosten | Grundwahrheiten fuer Schwellen, Prefetch, Poolwahl |
| Seitentypen | Dense page, START-multibyte, sparse HOT, redirect path, inline vs handle value | Lokale Latenz, CLU, Footprint, Miss-Verhalten | Seitentyp- und Value-Policy entscheiden |
| PRT-ART Suche | exact hit/miss, prefix hit/miss, prefix enumeration, sequential lex-scan | End-to-End-Latenz, Durchsatz, Suchpfadlaenge | aktive vs passive Cache-Awareness verifizieren |
| Mutation | bulk build, insert, update, delete, rebuild | Reorganisations- und Nachkalibrierungskosten | Online-Adaption tragfaehig? |
| Mischlasten | YCSB-A/B/C/E/F-Profile | read-mostly, read-only, scan-lastig, RMW | Robustheit gegenueber realistischeren Lasten |

## 3 Cache-Engine-Modi (NEU IN T6!)

| Modus | Beschreibung | Vergleichszweck |
|---|---|---|
| **Modus 1: passiv/statisch** | Feste Seitentypen + feste Schwellen ohne Plattformkalibrierung | **Baseline** (passive cache-awareness) |
| **Modus 2: Warm-up-kalibriert** | Einmalige Mikrobenchmarks bei erster Instanz, daraus feste Plattformregeln | Mittelweg |
| **Modus 3: online adaptiv** | Warm-up + laufende Rekalibrierung bei veraenderten Zugriffsmustern | **Voll-Cache-Engine** |

**Erfolgskriterium:** Cache-Engine erzeugt auf derselben Hardware konsistent **bessere Entscheidungen als statischer Modus**, sichtbar in End-to-End-Latenz UND Miss/CLU/Footprint-Metriken.

## Messstack pro Plattform-Klasse

| Klasse | Primaerwerkzeug | Ergaenzung | Pflichtmetriken |
|---|---|---|---|
| Linux allg. | perf stat | perf record/report | cycles, instructions, branches, branch-misses, cache-misses, dTLB-misses, wall time |
| Intel-Hybrid lokal | perf cpu_core/* + cpu_atom/* | Intel Advisor MAP/CLU/Footprint | Miss getrennt nach P/E, CLU, Footprint |
| Intel-Server | perf + PAPI | Advisor + optional Intel MLC lokal | LLC, Memory-Naehe, AVX-512-Pfade |
| AMD x86 | perf + PAPI | eigener ISA-/working-set Sweep | LLC, 3D-V-Cache-Effekt, AVX-512 |
| macOS / Apple | Instruments / Time Profiler | eigener Harness mit Run-Logs | CPU-Zeit, P/E-Verteilung, End-to-End-Latenz |
| ZIH | PAPI + perf | PIKA nur falls aktiviert | Rohcounter; exklusive Messjobs `--no_monitoring` |

## Termin-6-Nichtziele (explizit)

- KEINE GPU-Kerneloptimierung (Grace Hopper -> nur CPU/Speicherpfad)
- KEINE erzwungene Neuimplementierung fremder Algorithmen (Wrapper)
- KEIN Multiwriter als Pflichtkern
- KEINE Volltheorie fuer Instruction Cache als eigener Forschungspfad

## Erwaehnte Quellen — Cross-Referenz

| Erwaehnt | Katalog | PDF/Tool |
|---|---|---|
| ZIH HPC Compendium (Barnard, Capella, GH, perf, PAPI, PIKA) | C.6, C.7, C.8, C.9, C.10 | n/a (Tools) |
| Intel Spezifikationen (i7-1270P, i9-14900KS, Xeon 8470) | D.1, D.2, D.3 | n/a (Hardware-Doku) |
| Intel Advisor User Guide | C.1, C.2 | n/a |
| AMD Ryzen 9 9950X3D / 9950X3D2 | D.4 | n/a |
| Apple Mac mini M1 | D.7 | n/a |
| Raspberry Pi 5 | D.6 | n/a |
| StarFive VisionFive 2 | D.5 | n/a |
| Hardkernel ODROID-H4 Ultra | D.8 | n/a |
| Google Benchmark + YCSB | C.12, C.11 | n/a |

**Status:** Alle T6-erwaehnten Werkzeuge/Hardware sind als Tools/Hardware-Doku im Quellenkatalog.
