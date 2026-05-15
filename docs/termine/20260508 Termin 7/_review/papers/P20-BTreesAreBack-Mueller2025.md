# P20 — B-Trees Are Back (Mueller/Benson/Leis 2025)

**Voller Titel:** B-Trees Are Back: Engineering Fast and Pageable Node Layouts
**Autoren:** Marcus Mueller, Lawrence Benson, Viktor Leis (TU Munich)
**Venue:** Proc. ACM Manag. Data 3, 1 (SIGMOD), Article 14, Februar 2025
**Volltext:** `_text/P20-BTreesAreBack-Mueller2025.txt` (15 Seiten, 92 KB)

## 1. Konzeptionelle Identitaet

**Modernes Engineering von B-Trees** mit **6 evaluierten Node-Layout-Optimierungen** + **adaptive Layout-Wahl zur Runtime**. Adressiert variable-sized records.

> "We describe an efficient B-Tree implementation supporting variable-sized records containing six known node layout optimizations. We evaluate each optimization to guide future implementations, and propose an optimized adaptive layout that can even compete with pure in-memory structures for many workloads." (P20:S.1/28-32)

**Klasse:** B+-Tree-Engineering mit adaptiver Runtime-Layoutwahl
**Zielsystem:** Hybrid in-memory + flash storage (vmcache, LeanStore)

## 2. 6 Layout-Optimierungen (Hauptbeitrag)

| Optimierung | Bedeutung |
|---|---|
| **Prefix Truncation** | Common prefix nur einmal pro Node speichern |
| **Heads** | Erste Bytes der Schluessel als 32-bit Integer in Slot fuer schnellen Vergleich |
| **Hints** | Sortierte Bins von Heads fuer Branch-Predictor-friendly Search |
| **Fingerprinting** | Hash-Bit-Vector pro Schluessel fuer schnellen Praefilter |
| **Semi-Dense Leaves** | Dichte Speicherung mit kleinen Luecken |
| **Fully Dense Leaves** | Komplett dichte Speicherung (NEU in dieser Arbeit!) |

## 3. Slotted Page Layout (P20:Fig.2/S.2)

Klassische Slotted-Page-Architektur:
- **Header**: count, tag, heapUsed, heapStart, prefixLength, fences, upperChild
- **Slots** (top): offset, key len, val len
- **Heap** (bottom): keys + values direkt

## 4. Adaptive Layout-Wahl (Sec.5)

> "We present an adaptive B-Tree that selects the best node layout at runtime." (P20:S.2/151-152)

Pro Knoten wird **basierend auf Inhalt** (variable-sized records, dichte vs sparse, prefix-strukturierte vs nicht) das passende Layout gewaehlt.

## 5. Performance (P20:Fig.1/S.1)

| Datensatz | Vanilla B-Tree | Optimized B-Tree | Wormhole |
|---|---|---|---|
| url | 1.0× | -28% | -53% (better) |
| sparse int | 1.0× | -26% | -60% (better) |
| dense int | 1.0× | +27% (better!) | -60% |

→ Optimized B-Tree **uebertrifft Wormhole bei dense int** und schliesst die Luecke bei strings.

## 6. Konzeptioneller Beitrag fuer PRT-ART

| B-Trees-Are-Back-Konzept | PRT-ART-Bezug |
|---|---|
| **Adaptive Node-Layout zur Runtime** | **DIREKTES Vorbild fuer PRT-ART Cache-Engine Page-Type-Selection** |
| **6 Layout-Optimierungen-Familie** | konzeptionell aequivalent zu PRT-ART **5er Page-Type-Familie** |
| **Variable-sized Records** | NICHT in PRT-ART (PRT-ART nutzt feste Byte-Granularitaet) |
| **Hybrid In-Memory + Flash** | NICHT in PRT-ART (PRT-ART CPU-only) |
| **Heads + Hints + Fingerprinting** | OPTIONAL als zusaetzliche PRT-ART Page-Optimierungen (Termin 1: optional!) |
| **Slotted Page Layout** | konzeptionell verwandt zu PRT-ART Custom Cache Page |
| **Intra-node vs Inter-node Trennung** | konzeptionell aequivalent zu PRT-ART **Such-Logik vs Cache-Engine Trennung** |

## 7. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **B-Trees-Are-Back 6 Optimierungen ↔ HOT 9 Layouts (P02) ↔ SuRF LOUDS-DS (P10) ↔ START Multilevel (P05)**: vier Layout-Familien mit Runtime-Wahl
- **B-Trees-Are-Back Heads/Hints ↔ Masstree Adaptive Keysuffix (P03) ↔ ART Combined slot (P01)**: drei Inline-Optimierungen
- **B-Trees-Are-Back Fingerprinting ↔ SuRF Hash Bits (P10)**: beide nutzen Hash-Praefilter
- **B-Trees-Are-Back adaptive Runtime Layout ↔ START Cost Model + Optimizer (P05)**: zwei runtime-adaptive Strategien
- **B-Trees-Are-Back Intra/Inter-Node Decoupling ↔ PRT-ART Such-Engine/Cache-Engine Decoupling**: gleiches Architektur-Prinzip!

## 8. Kernanschluss fuer PRT-ART

B-Trees-Are-Back ist **methodisch sehr nahe** an PRT-ART:
1. **"Adaptive Node-Layout zur Runtime"** = PRT-ART **Cache-Engine Page-Type-Selection**
2. **6er Optimierungs-Familie** = PRT-ART **5er Page-Type-Familie**
3. **Intra-Node vs Inter-Node decoupling** = PRT-ART **Such-Engine vs Cache-Engine decoupling**

PRT-ART unterscheidet sich:
- B-Trees-Are-Back: **B+-Tree-basiert** mit Layout-Variantenfamilie pro Node
- PRT-ART: **Trie-basiert** mit Page-Type-Familie + getrennter Cache-Engine

PRT-ART verallgemeinert das Konzept "Adaptive Layout zur Runtime" von **Knoten-intern** (B-Trees-Are-Back) auf **Page-extern als Cache-Engine-Modul**. Das ist der **inkrementelle Forschungsbeitrag** von PRT-ART gegenueber B-Trees-Are-Back.
