# P31 — Overview on Hardware Optimizations for Database Engines (Ungethuem/Habich et al. 2017)

**Voller Titel:** Overview on Hardware Optimizations for Database Engines
**Autoren:** Annett Ungethuem, **Dirk Habich**, Tomas Karnagel, Sebastian Haas, Eric Mier, Gerhard Fettweis, **Wolfgang Lehner** (TU Dresden — Database Systems Group + Vodafone Chair Mobile Communications)
**Venue:** BTW 2017 (LNI, Gesellschaft fuer Informatik), Bonn
**Volltext:** `_text/P31-Ungethuem2017.txt` (20 Seiten, 64 KB)

## 1. Konzeptionelle Identitaet

**TUD/Habich-Linie Survey** ueber Hardware/Software-Co-Design fuer Database Engines. Fokus auf:
1. **Instruction Set Extensions** der Prozessoren
2. **Memory-Controller-Offloading** (intelligent DMA / iDMA)
3. **Tomahawk Database Accelerator** als Beispiel-Implementierung

> "We give an overview of our currently ongoing as well as already conducted research work to support database systems by customizing hardware components." (P31:S.2/69-72)

**Klasse:** TUD-Forschungsprogramm zur Hardware-Customization fuer Datenbanken
**Hauptbeitrag:** Konkrete Beispiele (Tomahawk Platform) + ISA-Extensions

## 2. Drei Forschungsbereiche (P31:Fig.1/S.2)

| Bereich | Aktuelle Trends | DB-Implikation |
|---|---|---|
| **Processing Elements** | Cores ↑, AVX, Pre-Fetching, Branch Prediction | + GPUs, FPGAs als Alternativen |
| **Main Memory** | Capacity ↑, NV-RAM disruptive | Full Database in RAM moeglich |
| **Network** | Mehr Cores → komplexer, NUMA, RDMA | Node-Boundaries verschwimmen |

## 3. Tomahawk Database Accelerator (P31:Sec.2)

### Architektur
- **Heterogeneous MPSoC** (Multiprocessor System-on-Chip)
- **Control-Plane**: App-Core (Fat Core) + Global Memory + Peripherals
- **Data-Plane**: Multiple PEs (Processing Elements) mit Scratchpad Memory
- **Core Manager**: Task-Scheduling + Frequency Scaling der PEs
- **DMA Controller** (iDMA): Memory-Controller mit DB-Logik

### Tomahawk DB Accelerator (3rd Revision)
- 4 PEs mit specialized DB-ISA
- Tensilica LX5 RISC als Basis (32-bit, 80 Instructions)
- ISA-Extensions fuer DB-Operationen:
  - Bitmap Compression
  - Hashing
  - Pointer Chasing offloaded to iDMA

## 4. PRT-ART-Bezug (Habich-Bezug HOECHST WICHTIG!)

| Ungethuem-Konzept | PRT-ART-Bezug |
|---|---|
| **TUD-Methodik fuer Hardware-aware DB** | **DIREKTE Sprache + Methodik** fuer PRT-ART (Habich ist Hauptbetreuer!) |
| **Instruction Set Extensions** | konzeptionell: PRT-ART nutzt SIMD (AVX2/AVX-512/NEON/SVE2) als ISA-Extensions |
| **Memory-Controller-Offloading** | NICHT in PRT-ART (CPU-only Scope) |
| **Tomahawk DBA mit specialized ISA** | analog: PRT-ART Cache-Engine waehlt ISA-Pfade (Function Multiversioning) |
| **Hardware/Software Co-Design** | konzeptionell: PRT-ART Software-Cache-Engine ueber Hardware-Caches |

## 5. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Ungethuem TUD-Linie ↔ Saikkonen Multi-Level (P18) ↔ Hankins TLB-Mit-Modellierung (P13)**: drei Forschungsprogramme fuer Hardware-aware DB
- **Ungethuem ISA-Extensions ↔ HOT BMI2/AVX2 (P02) ↔ ART SSE2 (P01)**: drei ISA-spezifische DB-Optimierungen
- **Ungethuem TUD-Linie ↔ To Stride or Not to Stride (P32 — auch TUD)**: Habich/Lehner-Forschungsprogramm
- **Ungethuem Tomahawk Custom Hardware ↔ START Cost Model (P05)**: zwei Plattform-bewusste Methodiken

## 6. Kernanschluss fuer PRT-ART

Ungethuem 2017 ist die **methodische Sprache + Vorbereitung** der TUD/Habich-Linie:

1. **Hardware-aware DB-Optimierung** als Habich-Forschungsthema (PRT-ART direkter Anschluss)
2. **ISA-Extensions** als Performance-Stellschraube (PRT-ART Cache-Engine plant ISA-Wahl)
3. **Plattform-Variabilitaet** als Designherausforderung (PRT-ART Plattformkalibrierung)

PRT-ART positioniert sich in der **Habich/Lehner/Fettweis-Linie**: hardware-bewusste, plattform-kalibrierte DB-Optimierung. Diese Quelle ist **Argumentationsbasis** fuer:
- "Plattformkalibrierung ist wissenschaftlich begruendet"
- "ISA-Extensions sind ein Performance-Hebel"
- "Hardware/Software Co-Design ist zukunftsorientiert"

→ Termin 1+5 referenzieren das Paper als L13 / A3.1: "TUD Hardware-Metrikstil" — Ungethuem ist die Sprache.
