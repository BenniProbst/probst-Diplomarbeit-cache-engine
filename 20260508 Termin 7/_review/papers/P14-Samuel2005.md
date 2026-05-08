# P14 — Samuel/Pedersen/Bonnet (Making CSB+-Trees Processor Conscious)

**Voller Titel:** Making CSB+-Tree Processor Conscious
**Autoren:** Michael Samuel, Anders Uhl Pedersen, Philippe Bonnet (University of Copenhagen)
**Venue:** DaMoN 2005, Baltimore MD (12 Juni 2005)
**Volltext:** `_text/P14-Samuel2005.txt` (7 Seiten, 31 KB)

## 1. Konzeptionelle Identitaet

Erweitert Hankins/Patel (P13) um **mehrere Parameter** (nicht nur Knotengroesse) fuer Plattform-Adaptierung. Empirische Studie auf **Itanium 2**.

> "Cache-conscious indexes, such as CSB+-tree, are sensitive to the underlying processor architecture. [...] We argue that it is necessary to consider a larger group of parameters in order to adapt CSB+-tree to processor architectures as different as Pentium and Itanium." (P14:S.2/40-49)

**Klasse:** Empirische Multi-Parameter-Plattform-Adaptierungsstudie
**Ziel:** Adaptive CSB+-Tree fuer MySQL Heap Storage Manager (Badger Project)

## 2. Adaptive Parameter (3 Schluessel)

> "When adapting CSB+-tree to a given processor architecture, the crucial parameters are: (1) Node size, (2) Number of keys per node, (3) Strategy for search within a node: binary vs. linear search with or without prefetching." (P14:S.3/229-235)

| Parameter | Bedeutung |
|---|---|
| **Node size** | Multiple of cache-line; Hankins/Patel: groesser besser |
| **Number of keys per node** | = Node-Size / Key-Size × Fill-Factor |
| **Search strategy within node** | Linear vs Binary, mit/ohne Prefetch |

## 3. Methodik (Configuration Experiment)

> "We propose to adapt a CSB+-tree by setting node search strategy and node size at index creation time based on the key size given by the user. In order to do that, we need to construct a CSB+-tree configuration table that associates search strategy and node size to key sizes." (P14:S.7/586-590)

**Configuration Experiment**:
1. Auf Zielplattform variiere Node-Size + Key-Size + Search-Method
2. Messe Performance fuer Point Query, Scan, Insertion
3. Speichere optimale Kombinationen in **CSB+-tree configuration table**
4. Bei Index-Erstellung: anhand Key-Size aus Tabelle parameter waehlen

## 4. Schluessel-Erkenntnisse auf Itanium 2

### Linear vs Binary Search
> "Linear search systematically outperforms binary search [auf Itanium 2]" (P14:S.7/612)

Grund: weniger Branch Mispredictions bei Linear, EPIC-Architektur erlaubt parallele Comparisons.

### Crossover Points
- 8 Byte Keys: Linear besser bis 384 B Node-Size
- 16 Byte Keys: Linear besser bis 512 B Node-Size

### Prefetching
- Itanium 2 hat **explicit prefetch API** (Compiler-Directives + Application-Level)
- Prefetching reduziert **Data Cache Stalls** signifikant
- "Linear+PF" (Prefetch) ist auf Itanium 2 die Default-Wahl

## 5. PRT-ART-Bezug (HOECHST WICHTIG fuer Cache-Engine!)

| Samuel-Konzept | PRT-ART-Bezug |
|---|---|
| **Configuration Experiment** | **= PRT-ART Cache-Engine Modus 2 (Warm-up Calibration)** |
| **CSB+-tree Configuration Table** | **= PRT-ART Cache-Engine Plattform-Profil** |
| **Multi-Parameter Adaption** | DIREKT: PRT-ART Cache-Engine variiert Node-Size + Page-Type + Search-Method + Prefetch |
| **Linear vs Binary Search** | PRT-ART: Cache-Engine waehlt Suchstrategie pro Knoten |
| **Prefetching auf Itanium 2** | PRT-ART: Cache-Engine entscheidet ob Prefetch aktiviert wird (vgl. P21 Chen, P25 Mahling) |
| **Pragmatische Methodik (kein analytisches Modell)** | passt zu PRT-ART Mess-getriebener Cache-Engine |

## 6. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Samuel Configuration Experiment ↔ START Cost Model Calibration (P05)**: beide messen-dann-tabellieren-dann-anwenden
- **Samuel Multi-Parameter ↔ Hankins Node-Size-Studie (P13)**: Erweiterung von 1 auf 3 Parameter
- **Samuel Linear vs Binary Search Wahl ↔ Khan Dynamic Adaptation Prefetch (P23)**: beide Plattform-spezifische Strategie-Wahl
- **Samuel Prefetching auf Itanium ↔ Chen Prefetching B+-Trees (P21) ↔ Mahling Fetch Me If You Can (P25)**: drei Untersuchungen wann Prefetch hilft

## 7. Kernanschluss fuer PRT-ART

Samuel/Pedersen/Bonnet liefert die **methodische Vorlage** fuer PRT-ART Cache-Engine **Modus 2 (Warm-up Calibration)**:

1. **Configuration Experiment auf Zielplattform** = Warm-up Mikrobenchmarks
2. **Configuration Table** = Cache-Engine Plattform-Profil
3. **Index-creation-time Parametrisierung** = PRT-ART Page-Type-Wahl bei Subtree-Creation

Aber **Samuel ist statisch** (Konfiguration einmal beim Index-Build); **PRT-ART Modus 3 macht das online adaptiv**. Samuel zeigt damit die untere Grenze (Modus 2), gegen die PRT-ART Modus 3 sich beweisen muss.

**Wichtige Beobachtung:** Auf Itanium 2 ist Linear Search besser als Binary — das Gegenteil dessen, was klassisch fuer x86 angenommen wird. Das ist ein **starkes Argument fuer Plattform-Kalibrierung**: One-size-fits-all funktioniert nicht.
