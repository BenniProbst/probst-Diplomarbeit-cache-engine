# P19 — Saikkonen/Soisalon-Soininen 2016 (Cache-Sensitive Memory Layout for Dynamic Binary Trees)

**Voller Titel:** Cache-Sensitive Memory Layout for Dynamic Binary Trees
**Autoren:** Riku Saikkonen, Eljas Soisalon-Soininen (Aalto University, formerly Helsinki UoT)
**Venue:** Computer Journal Oxford, Vol. 59 No. 5, 2016 (Online ePub Nov 2015)
**DOI:** 10.1093/comjnl/bxv090
**Volltext:** `_text/P19-Saikkonen2016.txt` (20 Seiten, 97 KB)

## 1. Konzeptionelle Identitaet

**Erweiterung von Saikkonen 2008 (P18)** fuer rein dynamische Binary Trees (AVL/Red-Black) mit **Layout-Invariante** statt globaler Relocation.

> "We use cache-sensitive memory layouts to improve search performance in ordinary binary search trees, without increasing the time complexity of insertion or deletion. Our approach does not require changes to the structure of the nodes or the rebalancing strategy of the tree." (P19:S.1/15-19)

**Klasse:** Cache-Sensitive Layout-Invariante mit konstanter Update-Komplexitaet
**Hauptbeitrag:** **Layout-Invariante**: Non-leaf Knoten teilt Cache-Block mit Parent ODER Child

## 2. Hauptbausteine

### 2.1 Layout-Invariante (parameterisiert)

> "In its simplest form, we require a non-leaf node to be located on the same cache block as either its parent or its child. We re-establish the invariant in constant time whenever the tree changes" (P19:S.2/93-95)

**Erweitert (parameter α):** Subtree mit α > 2 connected nodes auf gleichem Cache-Block.

### 2.2 Update-Mechanik

- **Worst-Case konstante** Operationen bei Insert/Delete
- **Erhaltung** der Invariante bei Rotationen (AVL/RB)
- **Keine Aenderung** der Node-Struktur oder Rebalancing-Strategie

## 3. Performance-Ergebnisse (P19:Sec.5)

### Search-Verbesserung
- AVL/Red-Black Trees: **26-32% schneller** auf 10^7 Keys
- α=1 simple Invariante: ca. 33% weniger Cache-Block-Misses
- α>2 erweiterte Invariante: bis zu 50% weniger Cache-Block-Misses

### Versus Multi-Level non-dynamic Layout (= Saikkonen 2008 P18)
- Non-dynamic: 51-56% schneller
- Dynamic (P19): 26-32% schneller
- → "26-32% sehr gut im Vergleich zu 51-56% des viel komplexeren non-dynamic Layouts" (P19:S.2/132-135)

### Insert/Delete-Overhead
- Insert: ~50% bis 100% slower
- Delete: leicht slower oder sogar schneller (Search ist faster)
- TPC-C Benchmark mit ~9% Inserts: 9% Improvement (statt 26-30% bei nur Search)

## 4. Cache Model (P19:Sec.2)

Wie P18 Saikkonen 2008:
- B_0 = Node Size
- B_1 < B_2 < ... < B_k = Cache-Block-Sizes
- B_{k+1} = ∞
- TLB als zusaetzliche Cache-Ebene

## 5. PRT-ART-Bezug

| Saikkonen-2016-Konzept | PRT-ART-Bezug |
|---|---|
| **Layout-Invariante** | konzeptionell uebernehmbar fuer PRT-ART **Page-Layout-Invariante** |
| **Konstante Update-Operationen** | wichtig fuer PRT-ART **Update-Pfad-Effizienz** |
| **Parameter α (≥2 Knoten/Block)** | konzeptionell aequivalent zu PRT-ART **Cache-Engine Density-Threshold** |
| **Real-World Inputs (TPC-C)** | wichtig fuer PRT-ART Evaluation (Termin 3 Datensatz `tpcds-id`) |
| **Insert-Overhead-Tradeoff** | klassisches Pattern: Search-Speedup kostet Insert-Slowdown |

## 6. Identifizierte Konzept-Identitaeten (Cross-Paper)

- **Saikkonen 2016 Layout-Invariante ↔ B²-Tree Embedded Tree pro Page (P06)**: beide Container-Layout-Garantien
- **Saikkonen 2016 vs 2008 ↔ Saikkonen Online vs Offline Layout (P18)**: Update-faehige Variante des frueheren globalen Algorithmus
- **Saikkonen TPC-C Benchmark ↔ ART TPC-C HyPer Eval (P01)**: gleicher Benchmark, andere Strukturen
- **Saikkonen Layout-Invariante ↔ ROWEX atomic level field (P08)**: beide nutzen Datenstruktur-Invariants als Layout-Basis

## 7. Kernanschluss fuer PRT-ART

Saikkonen 2016 zeigt: **Layout-Invarianten + konstante Update-Operationen koennen Cache-Sensitivity dynamisch erhalten**. Das ist eine andere Strategie als PRT-ART Online-Relocation:

- Saikkonen: **lokale Invariante** (Parent-Child same block)
- PRT-ART: **globale Cache-Engine** (Page-Type-Wahl + Online-Relocation)

Saikkonen ist **Methodik-Vorbild** fuer PRT-ART Cache-Engine-Updates: Wenn Updates Layout-Invarianten verletzen, koennen sie in konstanter Zeit wiederhergestellt werden.

Die **26-32%** Search-Speedup von Saikkonen 2016 ist ein **Vergleichspunkt** fuer PRT-ART Cache-Engine: PRT-ART will mehr (durch adaptive Page-Wahl + Multi-Level-Optimierung).
