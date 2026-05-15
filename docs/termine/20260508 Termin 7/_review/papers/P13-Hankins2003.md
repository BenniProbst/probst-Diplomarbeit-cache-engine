# P13 — Hankins/Patel (Effect of Node Size)

**Voller Titel:** Effect of Node Size on the Performance of Cache-Conscious B+-trees
**Autoren:** Richard A. Hankins, Jignesh M. Patel (University of Michigan)
**Venue:** SIGMETRICS 2003, San Diego CA
**Volltext:** `_text/P13-Hankins2003.txt` (12 Seiten, 71 KB)

## 1. Konzeptionelle Identitaet

Empirische **Studie zur CSB+-Tree Knotengroesse**. Widerlegt den klassischen Glauben "Knotengroesse = Cache-Line-Groesse ist optimal".

> "We demonstrate that this choice [Cache-Line-Knotengroesse] is often suboptimal for cache-conscious access methods when running on modern processors." (P13:S.2/127-130)

**Klasse:** Empirisch-analytische Performance-Studie
**Hauptaussage:** **Knotengroesse 512 Bytes oder mehr** schlaegt typische Cache-Line-Groessen (64 B) auf Intel Pentium III um bis zu **17%** Speedup.

## 2. Analyse-Modell (P13:Sec.3)

Search-Cost-Modell als Funktion 4 Variablen:
- **I**: Instruction Count
- **M**: Number of Cache Misses
- **B**: Branch Mispredictions
- **T**: TLB Misses

| Output Parameter | Bedeutung |
|---|---|
| `Mbtree` | Cache misses fuer CSB+-Tree-Suche |
| `Ibtree` | Instruction count |
| `Bbtree` | Branch-Mispredictions |
| `Tbtree` | TLB misses |
| `space` | Speicherbedarf |
| `spacefull` | Speicher fuer Full CSB+-Tree |

## 3. Schluesselaussagen

### Knotengroesse > Cache-Line ist besser, weil:
1. **Weniger Tree-Levels** → weniger Pointer-Chasing
2. **Weniger TLB-Misses** (Knoten passen in weniger Pages)
3. **Weniger Branch-Mispredictions** (binary search innerhalb groesserer Knoten)
4. **Mehr Cache Misses pro Knoten — aber weniger Knoten insgesamt**

### Tradeoffs bei groesserer Knotengroesse:
- + Weniger Tree-Hoehe
- + Bessere TLB-Nutzung
- - Mehr Cache-Misses pro einzelnem Knotenzugriff
- = NETTO: oft besser fuer Suche!

## 4. Plattform

- Intel Pentium III (P13:S.4)
- L1 Data Cache + L2 Data Cache + TLB explizit modelliert
- Branch Mispredictions zaehlen zur Cost-Funktion

## 5. PRT-ART-Bezug (HOECHST RELEVANT!)

| Hankins-Konzept | PRT-ART-Bezug |
|---|---|
| **"Cache-Line-Groesse ist NICHT optimal"** | **Direkt-Stuetze fuer PRT-ART Cache-Engine!** Plattformabhaengige Schwellen statt fester Annahmen |
| **TLB als Mit-Kostenfaktor** | PRT-ART Cache-Engine MUSS TLB-Misses messen + adaptiv sein |
| **Multi-Variable Cost-Modell (I, M, B, T)** | DIREKT als Cache-Engine-Cost-Modell uebernehmbar — wie START's CL(n) (P05) |
| **Branch Mispredictions** | PRT-ART Plattform-Kalibrierung muss auch das messen |
| **Knoten 512 B optimal (vs 64 B)** | konzeptioneller Beleg fuer PRT-ART **adaptive Page-Groesse** |

## 6. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Hankins Cost-Modell (I/M/B/T) ↔ START Cost Model (P05)**: beide multivariate Performance-Modelle
- **Hankins TLB-Modellierung ↔ Saikkonen Multi-Level mit TLB als Block-Ebene (P18)**: beide explizit TLB-aware
- **Hankins "Knoten >> Cache-Line"-These ↔ ART Node256 (P01) ↔ Masstree 256B Knoten (P03)**: alle drei nutzen groessere als minimale Cache-Line-Knoten

## 7. Kernanschluss fuer PRT-ART (KRITISCH!)

Hankins/Patel ist die **wichtigste empirische Stuetze** fuer PRT-ART Cache-Engine-These:

> "Cache-Line-Groesse als Knoten-Default ist nicht optimal — es muessen mehrere Faktoren (Cache, TLB, Branch, Instructions) zusammen modelliert werden."

PRT-ART Cache-Engine **muss** ein multivariates Cost-Modell ueber:
- **Cache Misses** (perf cache-misses, LLC-misses)
- **TLB Misses** (perf dTLB-misses)
- **Branch Mispredictions** (perf branch-misses)
- **Instructions** (perf instructions)

implementieren — das ist genau START's CL(n) (P05) erweitert auf alle 4 Variablen. Hankins zeigt bereits 2003, dass das noetig ist; PRT-ART macht es generalisiert + adaptive.
