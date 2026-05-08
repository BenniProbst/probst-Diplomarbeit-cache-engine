# P33 — VAMPIR Poster (Berthold/Habich et al. 2023)

**Voller Titel:** VAMPIR — Virtualized Non-Functional Memory Properties for Data-Pipeline Scheduling
**Autoren:** Prof. Wolfgang Lehner (PI, TUD), Prof. Horst Schirmeier (PI), Prof. **Dirk Habich** (PI, TUD), Andre Berthold (RA), Lennart Schmidt (RA)
**Venue:** SPP2377 Phase-1-KICKOFF Poster (DFG SPP 2377 "Disruptive Memory Technologies")
**Volltext:** `_text/P33-VAMPIR-Berthold2023.txt` (1 Seite, 1 KB)

> Hinweis: Poster mit kompaktem Inhalt. Volltext-Extraktion liefert die wesentlichen Inhalte.

## 1. Konzeptionelle Identitaet

**DFG-Projekt** zur **virtualisierten Behandlung von Non-Functional Memory Properties (NFP)** fuer Data-Pipeline-Scheduling auf heterogenen Memory-Architekturen.

**Klasse:** Forschungsprojekt-Beschreibung (Poster)
**Ziel:** Effiziente Algorithmen + OS-Abstraktionen fuer heterogene Memory-Pipelines

## 2. Projekt-Struktur

### Phase 1 (Single-Query Pipeline Scheduling)
- **DB-Seite:** Effiziente Algorithmen fuer "heterogeneous memory pipeline orderings" considering NFPs
- **OS-Seite:** Abstraktionen fuer heterogene Memories; Virtualization + Compensation, transparent Migration/Replacement

### Phase 2 (Multi-Query Pipeline Scheduling)
- Global Schedule + Compensation Plan
- Negotiation at Query Compile Time

## 3. Current System Under Test (SUT)
- **Xeon Phi 7250**
- NUMA-Nodes
- Heterogeneous Memory: DRAM + HBM

## 4. Schlüssel-Konzepte

| Begriff | Bedeutung |
|---|---|
| **NFP** (Non-Functional Memory Properties) | Bandwidth, Latency, Energy, Capacity (vs Functional Properties wie Korrektheit) |
| **Virtualization** | OS-Layer abstrahiert von konkreten Memory-Typen |
| **Compensation** | Bei Memory-Migration: Performance/Energy-Compensation an Caller |
| **Pipeline Scheduling** | DB-Query-Operatoren auf Memory-Typen mappen |

## 5. PRT-ART-Bezug (HABICH-Direktbezug!)

| VAMPIR-Konzept | PRT-ART-Bezug |
|---|---|
| **NFP-Modell** | konzeptionell: PRT-ART Cache-Engine misst NFPs (CLU, TLB, Latenz) |
| **Virtualization von Memory-Typen** | NICHT in PRT-ART (PRT-ART arbeitet auf gegebener Hardware) |
| **Heterogeneous Memory (DRAM + HBM)** | PRT-ART Termin 6 Plattformmatrix: Grace Hopper hat DRAM + HBM |
| **Pipeline Scheduling** | NICHT in PRT-ART (PRT-ART hat kein Query-Pipeline-Scheduling) |
| **Habich Co-PI** | **DIREKTE Forschungslinie** — PRT-ART ist Habich-Diplomarbeit |

## 6. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **VAMPIR Heterogeneous Memory ↔ Mahling High-Latency Memory (P25) ↔ Schmidt Stride-Access HBM (P32)**: drei Untersuchungen zu modernen Memory-Architekturen
- **VAMPIR NFP-Modell ↔ START Cost Model (P05) ↔ Bender Probability Layout (P16)**: drei Modelle fuer hardware-aware Optimierung
- **VAMPIR Habich/Lehner ↔ Ungethuem Habich (P31) ↔ Schmidt Habich (P32)**: TUD/Habich-Forschungsprogramm

## 7. Kernanschluss fuer PRT-ART

VAMPIR ist die **Habich-Forschungsprogramm-Quelle** fuer:
1. **Heterogeneous Memory Modeling** — PRT-ART Cache-Engine sollte verschiedene Memory-Typen (DRAM/HBM/Remote) erkennen
2. **NFPs als Optimierungsziel** — PRT-ART Cache-Engine optimiert NFPs (CLU, Latenz, etc.)
3. **TUD-Forschungsprogramm** — PRT-ART steht in Habich/Lehner/Schirmeier-Linie

PRT-ART **erbt von VAMPIR** die Sprache und das Forschungsprogramm:
- Habich-Forschungsschwerpunkt: hardware-bewusste DB-Optimierung
- VAMPIR-Methodik: NFPs als Optimierungsziel
- TUD-Linie: Plattformkalibrierung + Hardware/Software Co-Design

PRT-ART ist die **CPU-/Cache-spezifische Auspraegung** dieser Forschungslinie:
- VAMPIR: Memory-Pipeline-Scheduling fuer Multi-Memory-Systeme
- PRT-ART: Cache-Optimierung fuer trie-basierte Suche

→ Termin 1+5 referenzieren das Paper als L15 / A3.2: "VAMPIR — Virtualisierte nicht-funktionale Speicher-Eigenschaften". P33 ist die direkte Quelle.
