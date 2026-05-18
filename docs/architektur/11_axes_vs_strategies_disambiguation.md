# Achsen vs Strategien vs CE-Services — Anti-Vermischungs-Master

**Stand:** 2026-05-18 (Phase R.11)
**Trigger:** User-Direktive 2026-05-18 + 12 identifizierte Vermischungen in K-Bildern (R.1-R.10)
**Zweck:** Eindeutige Trennung der **4 unabhaengigen Konzept-Ebenen** im Cache-Engine-Modell.

---

## §1 Das Problem (was die K-Bilder unscharf machen)

In den 44 REV7-drawio-Tabs werden 4 verschiedene Konzept-Ebenen sprachlich vermischt:

1. **Bausteine-Achsen 1-13** (Algorithmus-Permutations-Dimensionen)
2. **CE-Sub-Engines C1-C12** (CE-INTERNAL Services)
3. **Cache-Strategien F1-F29** (konkrete Implementations der CE-Sub-Engines)
4. **Such-Engine-Familien S1-S30** (konkrete Implementations der Algorithmus-Achsen)

Typische Vermischungen (siehe Sessions 4800 §5):
- "F9-F14 PREFETCH" — ist das Achse 7 PREFETCH oder C3 Cache-Prefetch-Engine?
- "C8 Hardware-Probing" (K09 Cluster) — ist das CE-Heuristik oder die neue Achse 12 HARDWARE?
- "K10 vs K06 Hybrid-Aufloesungen" — auf welcher Ebene?

Dieses Dokument loest die Vermischung mit einer 4-Schichten-Hierarchie.

---

## §2 Die 4 Konzept-Ebenen (formal)

### §2.1 Ebene I — Bausteine-Achsen (Algorithmus-Permutations-Dimensionen)

**Was:** Pro Algorithmus VARIIERT eine Achse seinen Wert. Beispiel: ART variiert auf Achse 1 PAGE-TYPE zwischen Node4/Node16/Node48/Node256.

**Wer benutzt das?** Bausteine-Matrix `docs/bausteine/01_bausteine_matrix.md` listet alle Bausteine pro Achse. Pro Algorithmus eine eigene Spalte mit "welcher Baustein wird auf Achse X verwendet?".

**Anzahl:** 13 Hauptachsen (Stand 2026-05-18 nach N-Phase):
```
1   PAGE-TYPE
2   NODE-TYPE
3.A SearchAlgo-Traversal
3.B Cache-Memory-Traversal
3.M Traversal-Mapping
4   VALUEHANDLE
5   MEMORY-LAYOUT
6.1 Allocation-Strategy
6.2 Reclamation-Policy
6.3 NUMA-Affinity
6.4 Huge-Page-Policy
6.5 Free-List-Strategy
7   PREFETCH
8.1 Concurrency-Pattern
8.2 Locking-Mode
9   ISA
10  MEASUREMENT
11  TELEMETRY-COLLECTION
12  HARDWARE-STRATEGY    (NEU)
13  SCHEDULING-STRATEGY  (NEU)
```

**Konsequenz pro Achse:** Pro Algorithmus muss eine konkrete Baustein-Klasse existieren (PRT-ART-Pflicht: alle 13 Achsen, mind. 1 voellig neuartige Implementation in mind. 1 Achse).

### §2.2 Ebene II — CE-Sub-Engines (CE-INTERNAL Services)

**Was:** CacheEngine bietet als WERKZEUG eine Reihe von Sub-Engines, die ALLE Algorithmen konsumieren koennen. Beispiel: C3 Cache-Prefetch-Engine bietet Prefetch-Service jedem Algorithmus, der PRT-ART-spezifischen Prefetch nutzt.

**Wer benutzt das?** Pruefling (z.B. PRT-ART) ruft Services dieser Sub-Engines waehrend Lookup. Siehe `10_schichten_modell_M.md` §3.2 Richtung (b).

**Anzahl:** 12 Sub-Engines (K15, ICacheEngine-Familien-Taxonomie):
```
C1  Cache-Layout-Engine          (~28 Atome)
C2  Cache-Pinning-Engine         (~10 Atome)
C3  Cache-Prefetch-Engine        (~25 Atome)
C4  Cache-Coherence-Engine       (~12 Atome)
C5  Cache-Telemetry-Engine       (~22 Atome)
C6  Cache-Allocation-Engine      (~17 Atome)
C7  Cache-Migration-Engine       (~12 Atome)
C8  Cache-Encoding-Engine        (~28 Atome)
C9  Cache-Heuristik-Familie      (~73 Atome ORTHOGONAL)
C10 Cache-Topologie-Engine       (~17 Atome)
C11 Cache-Scheduler-Engine       (~13 Atome)
C12 Cache-Filter-Engine          (~9 Atome)
```

### §2.3 Ebene III — Cache-Strategien (Implementations von CE-Sub-Engines)

**Was:** Konkrete Strategie-Klassen, die einer CE-Sub-Engine zugeordnet sind. Beispiel: F11 EmbeddedSecondaryIndex-Strategy ist eine Cache-Strategie, die zu C3 Cache-Prefetch-Engine gehoert (Encoded Secondary Index = Prefetch-Hint-Mechanik).

**Wer benutzt das?** CE-Sub-Engines instantiieren Strategien per Permutations-Config. Ein CE-Pipeline-Lauf waehlt fuer jede Sub-Engine eine konkrete Strategie aus.

**Anzahl:** 29 Strategien F1-F29 (K10):
```
F1-F8   LAYOUT-Familien      (gehoeren zu C1)
F9-F14  ENCODING + PREFETCH  (gehoeren zu C8 + C3)
F15     HERZSTUECK Vergleich (gehoert zu C9 Heuristik — Forschungs-F)
F16-F19 NODE-Familien        (gehoeren zu C1 + C8)
F20-F25 CONCURRENCY-Familien (gehoeren zu C4 Coherence)
F26-F29 TELEMETRIE-Familien  (gehoeren zu C5)
```

### §2.4 Ebene IV — Such-Engine-Familien (Implementations von Algorithmus-Achsen)

**Was:** Konkrete Such-Algorithmus-Strategie-Klassen, die einer ALGORITHMUS-Achse zugeordnet sind. Beispiel: S22 BPlus-Familie ist eine Auswahl-Familie auf Achse 1 PAGE-TYPE (Klassen wie BPlusTreePerLayerStrategy P03, etc.).

**Wer benutzt das?** Pro Algorithmus-Permutation: pro Achse 1-13 wird eine S-Familie ausgewaehlt + ihre Strategien konfiguriert.

**Anzahl:** 30 Such-Engine-Familien S1-S30 (K06):
```
S1-S10  Komposition-Patterns
S11-S16 Adaptivitaet-Patterns
S17-S21 Aufbauverfahren-Patterns
S22-S26 Plural-Strategien (BPlus/Trie/Hybrid/Layout-Theorie/Adaptive-Selectors)
S27-S30 Singular-Strategien (Intra-Page-Search/Update/Layout/Concurrency)
```

---

## §3 Die Tatsachen-Tabelle: Achsen × Ebenen (Anti-Vermischung)

Pro Algorithmus-Achse 1-13: welche Ebene-IV-Familien (S*) implementieren sie + welche Ebene-II-Sub-Engines (C*) + welche Ebene-III-Strategien (F*) konsumiert sie?

| Achse | S-Familien (Ebene IV) | C-Sub-Engines (Ebene II) konsumiert | F-Strategien (Ebene III) konsumiert |
|---|---|---|---|
| 1 PAGE-TYPE | S22 BPlus, S23 Trie, S24 Hybrid | C1 Layout, C8 Encoding | F1-F8 Layout, F9-F14 Encoding |
| 2 NODE-TYPE | S27 Intra-Page | C1 Layout, C8 Encoding | F16-F19 NODE |
| 3.A Algo-Traversal | S22, S23, S24 (traversal-spezifisch) | (keine direkt) | (keine direkt) |
| 3.B Cache-Traversal | (keine — CE-seitig) | C1 Layout, C3 Prefetch | F1-F8, F9-F14 |
| 3.M Mapping | (keine — CE-seitig) | C1, C10 Topologie | F1-F8 |
| 4 VALUEHANDLE | S28 Insert/Update | C8 Encoding | (keine direkt) |
| 5 MEMORY-LAYOUT | S29 Intra-Page-Layout | C1 Layout, C2 Pinning | F1-F8, (C2-Atome) |
| 6.1 Allocation-Strategy | (keine — Allokator-spez.) | C6 Allocation | (C6-Atome) |
| 6.2 Reclamation-Policy | (keine) | C4 Coherence, C6 Allocation | F20-F25 |
| 6.3 NUMA-Affinity | (keine) | C2 Pinning, C10 Topologie | (C2/C10-Atome) |
| 6.4 Huge-Page-Policy | (keine) | C6 Allocation | (C6-Atome) |
| 6.5 Free-List-Strategy | (keine) | C6 Allocation | (C6-Atome) |
| 7 PREFETCH | (keine direkt) | C3 Prefetch | F9-F14 Prefetch |
| 8.1 Concurrency-Pattern | S30 Concurrency-innerhalb-Page | C4 Coherence | F20-F25 Concurrency |
| 8.2 Locking-Mode | S30 (sub) | C4 Coherence | F20-F25 |
| 9 ISA | (keine direkt) | C9 Heuristik (Hardware-Probing) | (C9-Atome Hardware-Heuristik) |
| 10 MEASUREMENT | (keine — Mess-spez.) | C5 Telemetry | F26-F29 Telemetrie |
| 11 TELEMETRY | (keine direkt) | C5 Telemetry | F26-F29 |
| 12 HARDWARE (NEU) | (Achse-spez. Familien noch zu definieren) | C2 Pinning, C9 Hardware-Probing, C11 Scheduler | (C2/C9/C11-Atome) |
| 13 SCHEDULING (NEU) | (Achse-spez. Familien noch zu definieren) | C11 Scheduler | (C11-Atome) |

**Beobachtung:** Achsen 12 + 13 (NEU) brauchen neue S-Familien — Phase N.3 + N.4 + Phase O.3 fuer PRT-ART-Spiegel.

---

## §4 Konkrete Beispiel-Disambiguation (10 typische Verwirrungen)

| Verwirrung | Korrekt | Falsch | Ebene |
|---|---|---|---|
| "F9-F14 PREFETCH" | Cache-Strategie-Familie (Ebene III), gehoert zu C3 Cache-Prefetch-Engine (Ebene II) | "F9-F14 ist Achse 7 PREFETCH" | III, NICHT I |
| "C8 Hardware-Probing" | CE-Heuristik-Cluster aus C9 (Ebene II) | "C8 ist Achse 12 HARDWARE" | II, NICHT I |
| "Achse 7 PREFETCH" | Algorithmus-Permutations-Dimension (Ebene I) | "Achse 7 ist F9-F14" | I, KONSUMIERT III |
| "C3 Cache-Prefetch-Engine" | CE-INTERNAL Service (Ebene II) | "C3 ist Achse 7 PREFETCH" | II, NICHT I |
| "S22 BPlus-Familie" | Such-Engine-Strategie-Familie (Ebene IV) | "S22 ist Achse 1 PAGE-TYPE" | IV, IMPLEMENTIERT I |
| "K04 4-Ebenen-Strategien A/B/C/D" | Implementations-Tiefe pro S-Familie (kein Ebene-IV-Aspekt) | "4 Ebenen = 4 Achsen" | OBJ-DESIGN-Aspekt, nicht Permutation |
| "K03 V1-V4 Builds" | ENGINE-CHOICE-DIMENSION (4-fache Permutations-Multiplikation) | "V1-V4 sind Cache-Strategien F1-F4" | Meta-Achse fuer F15-Vergleich |
| "F15 HERZSTUECK Vergleich" | F15-Familie ist Cache-Strategie (Ebene III) + F15-Mission ist Forschungs-Ziel (Meta) | "F15 ist nur eine Cache-Strategie" | III + META |
| "12 Sub-Engines C1-C12" | CE-INTERNAL Services (Ebene II) | "C1-C12 sind Algorithmus-Achsen" | II, KONSUMIERT VON I |
| "29 Cache-Familien F1-F29" | Implementations der CE-Sub-Engines (Ebene III) | "F1-F29 sind Algorithmus-Bausteine" | III, NICHT I |

---

## §5 Disambiguation pro K-Tab (REV7 IST-Stand)

| Tab | Welche Ebene zeigt es? | Falsches-Verstaendnis-Risiko |
|---|---|---|
| K01 Drei-Ebenen-Architektur | Saeule-A vs Saeule-B (Konzept-Architektur, OBJ-DESIGN) | (kein Ebene-Konflikt — Architektur-Sicht) |
| K02 3-Schichten Konzept-Strategie-Physisch | OBJ-DESIGN-Schichten | (kein Konflikt) |
| K03 ICacheStrategy + 4 Builds | Meta-Achse ENGINE-CHOICE (R.9) | "V1-V4 = Cache-Familien" — FALSCH (V1-V4 = Permutations-Multiplikator) |
| K04 4-Ebenen-Strategien | OBJ-DESIGN-Implementations-Tiefe pro S-Familie | "4 Ebenen = 4 Achsen" — FALSCH (4 Implementations-Schichten pro Ebene IV) |
| K05 PRT-ART Bausteinkombination | Ebene IV (PRT-ART als Algorithmus-Implementation) | (kein Konflikt) |
| K05b-h PRT-ART Detail | Ebene IV PRT-ART-INTERNAL Details | "K05b 4 Suchtypen = Achse 2" — FALSCH (Sub-Permutation D10) |
| K06 ISearchEngine-Familien S1-S30 | Ebene IV (Implementations der Algorithmus-Achsen) | "S22 = Achse 1" — FALSCH (S22 ist EINE Familie unter Achse 1) |
| K07/K07a-d IPlatformProbe | Ebene II (CE-INTERNAL Service) | (kein Konflikt) |
| K08/K08a-d Plattform-Modell | Ebene II CE-Sub-Engine-Detail | (kein Konflikt) |
| K09 IHeuristic 8 Cluster | Ebene II (C9 Heuristik-Familie) | "C8 Hardware-Probing = Achse 12" — FALSCH (R.3) |
| K10 29 Cache-Familien F1-F29 | Ebene III (Cache-Strategien) | "F9-F14 = Achse 7 PREFETCH" — FALSCH (R.1) |
| K11 Phase 1-7 Pipeline | OBJ-DESIGN-Workflow CEB | (kein Ebenen-Konflikt, aber CEB-Owner unklar — siehe M.1) |
| K12 F15-Forschungsmission | Meta-Forschungs-Ziel | "F15-Familie = F15-Mission" — FALSCH (R.10) |
| K13 Future-Proof-Prinzipien | OBJ-DESIGN-Direktiven | (kein Konflikt) |
| K14 Layer-Matrix-Hybrid + DSM | Layer-vs-Matrix-Modell | (kein Ebenen-Konflikt) |
| K15 ICacheEngine-Familien C1-C12 | Ebene II (CE-INTERNAL Services) | "C-Familie = Algorithmus-Achse" — FALSCH (R.2) |
| U01-U10 UML | OBJ-DESIGN UML-Klassen | (kein Ebenen-Konflikt direkt) |
| U10 prt_art + IPermutationEngine + CEB | OBJ-DESIGN-Beziehung CEB <-> Pruefling | "CEB steuert" — UNVOLLSTAENDIG (bidirektional fehlt) |

---

## §6 Konsequenzen fuer kuenftige drawio-Tabs (P-Phase)

| Pflicht | Wofuer | Task |
|---|---|---|
| **Ebene-Label am Tab-Titel** | "K10 — Ebene III Cache-Strategien" anstatt nur "K10 29 Cache-Familien" | P.3 (#482) + alle anderen Tabs |
| **Anti-Vermischungs-Banner** | Pro Tab eindeutige Ebene-Zuordnung im Subtitle | P-Phase generell |
| **Visualisierungs-Tab** | NEUER Tab "4-Schichten Anti-Vermischung" (R.12) | R.12 (#501) |
| **Cross-Ref-Tabelle** | §3 Tabelle ALS Tab in drawio | R.12 (#501) |

---

## §7 Konsequenzen fuer Bausteine-Matrix (N-Phase)

- Achse-Tabelle muss klar Ebene I markieren
- Pro Achse 1-13: Verweis auf relevante Ebene-II (C-Sub-Engines), Ebene-III (F-Strategien), Ebene-IV (S-Familien) — siehe §3 Tabelle
- N.7 (#470) Index-Doku: 14-Achsen-Tabelle mit Ebenen-Trennung

---

## §8 Konsequenzen fuer PRT-ART (O-Phase)

PRT-ART als Pruefling implementiert Ebene IV (Such-Engine-Familien) fuer alle 13 Algorithmus-Achsen.

PRT-ART KONSUMIERT Ebene II (C-Sub-Engines) der CacheEngine ueber Service-API.

PRT-ART ist NICHT verantwortlich fuer Ebene II oder Ebene III — das ist CE-Eigentum.

**Pflicht:** PRT-ART-Klassen explizit als Ebene-IV markieren in `comdare-prt-art/prt_art/include/prt_art/*` Headers (Doku-Kommentar). O.5 (#478) + O.6 (#479).

---

## §9 Cross-Refs

- **M-Phase 4-Subsystem-Modell:** `10_schichten_modell_M.md` (komplementaer — Subsysteme vs Konzept-Ebenen)
- **K-Tabs in drawio:** REV7-Tabs (44 Stueck) — alle mit Ebenen-Label versehen nach P-Phase
- **Bausteine-Matrix:** `../bausteine/01_bausteine_matrix.md` — Ebene I Master
- **Saeule A Konzepte:** `03_konzepte_saeule_a.md` — Ebene IV Master
- **Saeule B Konzepte:** `04_konzepte_saeule_b.md` — Ebene II Master
- **Cache-Strategien-Taxonomie:** `09_taxonomien.md` — Ebene III Master
- **drawio REV8 Anti-Vermischung-Tab:** R.12 (#501)

---

**Ende docs/architektur/11_axes_vs_strategies_disambiguation.md (Phase R.11 DONE).**
