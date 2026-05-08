# Termin 4 — Konsolidierung

**Datum:** 2026-04-12
**Hauptthema:** Scope-Freeze v2 · **Grosse Cache-Engine-Forschungsdokumentation** mit 70 Referenzen
**Zustand:** Wissenschaftliche Position der Cache-Engine geschaerft

## Zentrale Texte

- `20260412 Termin 4__20260412_PRT_ART_Scope_Freeze_Termin4_final.docx`
- `20260412 Termin 4__Aktive Cache-Engine fuer trie-basierte In-Memory-Indizes_ Stand der Forschung_ Designmuster und Exper.docx` (35 KB!)
- `20260412 Termin 4__20260412_Arbeitsaufstellung_PRT_ART_Termin4_final.docx`

## Kernschaerfung: "Aktive vs Passive Cache-Awareness"

> "Die Literatur zu modernen Indexstrukturen hat in den letzten 25 Jahren primaer **passive Cache-Awareness** verfolgt: Datenstrukturen werden so entworfen, dass sie 'von Natur aus' cachefreundlich sind."
>
> "Die von dir vorgeschlagene **aktive Cache-Engine** fuer PRT-ART hebt sich qualitativ ab: Sie soll nicht nur Layouts bereitstellen, sondern aktiv (i) Page-Repraesentation waehlen, (ii) Platzierung/Allocator steuern, (iii) Prefetching orchestrieren, (iv) online Seiten/Nodes umlagern (Relocation) und (v) dabei Metriken wie CLU und Memory Footprint minimieren."

## Implementierungsprioritaeten P0-P3

| Prio | Ziel | Inhalt |
|---|---|---|
| **P0** | Mess- und Vergleichbarkeit zuerst | Lauffaehiger Kernpfad + Mess-Harness + Toolchain (perf, Intel Advisor) |
| **P1** | Regelbasierte Cache-Engine v1 | Page-Type-Selection Rules + Prefetch v1 (konservativ) |
| **P2** | Online-Relocation (Engine v2) | Telemetrie (Probability Sketches), Relocation (BFS-Fuellung), Safety (RCU/Epoch) |
| **P3** | Erweiterungen | Fingerprints, erweiterte Seitentypenmatrix, optionales Multiwriter |

## Quellenapparat (70 Referenzen mit konkreten URLs)

Termin 4 hat den vollstaendigsten Quellenapparat aller Termine. Wichtige Cluster:

### Stand der Forschung
- [1][7] ART (Leis 2013) → A2.2 ✓
- [2][59][60] Intel Advisor → C.1, C.2
- [3][23][58] Towards Data-Based Cache Optimization (Dortmund DAMON 2023) → B2.1 ✓
- [4][22][53] Saikkonen 2008 IFIP TCS → A1.8 ✓
- [5][19][47][52] Chen/Gibbons/Mowry Prefetching B+-Trees 2001 → B1.1 ✓
- [8] HOT 2018 → A2.4 ✓
- [9][50] START 2020 → A2.6 ✓
- [10][30] Masstree 2012 → A2.1 ✓
- [11][33] Wormhole 2019 → A2.5 ✓
- [12][35] CoCo-trie 2024 → A2.8 ✓
- [13] CSS-tree 1999 → A1.1 ✓
- [14][27] CSB+-tree 2000 → A1.2 ✓
- [15][37][51] Hankins/Patel 2003 → A1.4 ✓
- [16][68] B²-tree 2022 → A2.7 ✓
- [17][49] B-Trees Are Back 2025 → A1.10 ✓
- [18] Bender/Demaine/Farach-Colton Tree Layout 2002 → A1.6 ✓
- [20] Path-Prefetching FGCS 2024 → B1.6 ✓
- [21] Mahling/Weisgut/Rabl 2025 → B1.5 ✓
- [24][40] ART of Practical Synchronization → A2.3 ✓
- [43] Hierarchical Prefetching ASPLOS 2025 → B1.7 ✓
- [41][48] RCU → B3.1 ✓
- [42] Hazard Pointers → B3.2 ✓

### Hardware/Tools
- [25] tcmalloc → F.10
- [26] mimalloc → F.11
- [28] libart → F.4
- [29][66] HOT GitHub → F.2
- [31] Masstree HPTS → (F.3 verwandt)
- [32][67] Masstree GitHub → F.3
- [34] Wormhole GitHub → F.5
- [36][54] CoCo-trie GitHub → F.1
- [38] GCC builtins / [39] Function Multiversioning → C.4, C.5
- [44] Intel i7-1270P → D.1
- [45][69] ZIH HPC → C.9
- [56][65] Intel Xeon 8470 → D.2
- [61] Intel Advisor cachesim → C.2
- [62] perf tools ZIH → C.6
- [63] PIKA → C.7
- [64] Intel intrinsics → C.3
- [70] Barnard ZIH → C.8

### Datensaetze
- it-2004 → E.2
- Pizza&Chili → E.3
- TPC-DS → E.4

**Status:** Alle 70 T4-Referenzen sind im Quellenkatalog erfasst.

## Designmuster aus T4 (fuer Phase 3.D Domaenenmodell wichtig)

| Muster | Inspiration | PRT-ART-Rolle |
|---|---|---|
| Kostenmodelle als Entscheidungskern | START | Cache-Engine-Kalibrierung |
| Probability Hints / Histogramme im Header | Dortmund 2023 + Bender 2002 | Telemetrie-API |
| Online-Relocation als Engine-Faehigkeit | Saikkonen 2008 | Engine-Mechanik |
| Page-Typwechsel | B-Trees Are Back | "adaptive layout"-Idee zur Runtime |
| Sicheres Umschalten Lese/Schreibpfad | ART of Practical Sync (OLC/ROWEX) | Versionierte Optimistic-Lesewege |
| Memory Reclamation | RCU + Hazard Pointers | Grace Period / Lock-free |
| Prefetch als Breiten-Werkzeug | Chen 2001 | Wider Nodes ohne Latenz-Hit |
| Prefetch-Kandidaten aus Pfad-/Block-Countern | Path-Prefetching 2024 | Online-Adaption |
| Allocator/Pool-Strategien | tcmalloc, mimalloc, snmalloc | Hardware-conscious Allocator |
| Cache-Simulation als Mess-/Feedback-Loop | Intel Advisor MAP/CLU/Footprint | Closed-loop CLU-Optimierung |
| ISA-Multiversioning | GCC FMV | Build-/Dispatch-Schicht |

## Forschungsluecken (T4 explizit benannt)

| Luecke | Status |
|---|---|
| Eigenstaendige Cache-Engine als getrennte Meta-Ebene | **Unser Hauptbeitrag** |
| Konsistentes Modell fuer alle Seitentypen plattformbewusst | **Unser Hauptbeitrag** |
| Online-Relocation in echten mutierenden Indexstrukturen | **Unser Hauptbeitrag** |
| Sauber experimentell begruendete Kopplung Suchstruktur + Value-Handle + Cache-Line-Affinity | **Unser Hauptbeitrag** |
| Direkte Verwaltung von Hardware-Caches | **Vorsichtig formulieren** (nur indirekt moeglich) |
| Instruction-Cache-Steuerung im Kontext Suchindizes | **Schwache Literatur** — sekundaer behandeln |

## Konkrete Experimentagenda (T4 Abschnitt 7)

7 Experimente sind ausformuliert:
1. Seitentyp-Sweep (Heatmap CLU/Footprint/Misses)
2. Prefetch-Distanz-Sweep
3. TLB-Stress
4. Datensatzportfolio (6 Pflicht-Datensaetze)
5. Policy-Ablation (Engine off / nur PageType / nur Prefetch / nur Relocation / Full)
6. Hybrid-Split (P-Cores vs E-Cores)
7. AVX2 vs AVX-512 vs vanilla
