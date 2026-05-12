# Extraktion Termin 3 + Termin 4 - PRT-ART Architektur-Bausteine

**Stand:** 2026-05-11
**Quellen:** 5 Dokumente (Termin 3 Arbeitsaufstellung + Benchmark/Datensatzplan; Termin 4 Arbeitsaufstellung + Scope-Freeze + Cache-Engine-Forschungsdokument)
**Zweck:** Vorarbeit fuer Saeule A (ISearchEngine) vs. Saeule B (ICacheEngine) im REV5 UML-Modell.

---

## A) PRT-ART konkrete Bausteine, die in Termin 3+4 NEU oder PRAEZISIERT wurden

### A.1 Architektur-Freeze in 4 Schichten (Termin 4 Scope-Freeze)
Die PRT-ART Architektur ist nun verbindlich in **vier Schichten** eingefroren:

> "A. Trie-Huelle mit Redirect-Knoten fuer kollabierte Praefixpfade (CoCo-trie-Idee).
> B. Suchseitenfamilie mit mehreren implementierten Seitentypen.
> C. Terminale Knoten mit ValueHandle als Uebergang zur Payload.
> D. Cache-Engine als explizite Steuerungsschicht fuer Layout, Prefetch, Affinity und Rebuild."

### A.2 Suchseitenfamilie (Knotenklassen-Tabelle aus Scope-Freeze)
Sechs verbindliche Seitentypen mit Literaturanker und Prioritaet:

| Klasse | Literaturanker | Prioritaet |
|--------|---------------|-----------|
| Redirect-Knoten | CoCo-trie | P0 |
| Dense Byte Page | ART | P0 |
| Multilevel Dense Page | START | P1 |
| Sparse Patricia Page | HOT | P0/P1 |
| Decision-/Span-Page | B²-tree | P2 |
| Custom Aligned Page | PRT-ART intern | P2 |

### A.3 Cache-Engine als Mikro-Kern (NEU als eigene Schicht)
Aus Scope-Freeze, Abschnitt 6: Die Cache-Engine wird als **eigener, hochspezialisierter Abschnitt der Programmbinary** definiert. Sie ist **nicht nur Beobachter, sondern trifft aktive Entscheidungen**:
- Optimierung von Suchzugriffen innerhalb von Seiten (Cache-Line-Ausnutzung)
- Beruecksichtigung von Daten- UND Programmseiten gemeinsam
- **Header-Metadaten in Nodes/Pages mit quantisierten Wahrscheinlichkeiten** nachfolgender Seitentypen als Prefetch-Hinweis
- Modellierung von Cache-related blocks ueber L3/L2/L1
- Online-Umlagerung, Rebuild und Registrierung aktiver Seiten
- Eigene Kostenmodelle je Seitentyp, Datentyp, Speicherart, ISA-Pfad und Mikrobenchmarkklasse

### A.4 Value-Pfad als eingefrorener Datenpfad
> "Key -> Redirects / Suchseiten -> terminaler Knoten -> ValueHandle -> Inline-Value oder externer Payload-Speicher"

ValueHandle ist **Kernbestandteil**, keine spaetere Verzierung. Inline vs. external ist global, pro Seitentyp und pro Node-Familie parametrierbar.

### A.5 Build-/ISA-/Plattformmodell (Termin 4 NEU praezisiert)
- C++23-Modul-/Template-Aufbau, viele Varianten als eigene **ABI-stabile Modulkombinationen**
- **GNU Function Multiversioning / target(target_clones)** fuer ISA-Varianten
- Minimaler **C++23 variadischer Runtime-compiletime-hybrid-Resolver** statt grossem dynamischen Dispatcher
- Scalar / AVX2 / AVX-512 als Pflichtpfade
- Hybrid-Intel: P- und E-Cores **getrennt** gemessen

### A.6 Eingefrorene Hypothesen (NEU in Scope-Freeze)
- **H1**: Aktive Cache-Engine verbessert CLU, Footprint und Laufzeit gegenueber statischen Layouts.
- **H2**: Dense-, Sparse-, Multilevel-Seiten gewinnen abhaengig von Datensatz/ISA/Core-Typ/Ordnungsmodus unterschiedlich.
- **H3**: Inline-vs-ValueHandle-Grenze ist architektur- und workloadabhaengig, MUSS aktiv gewaehlt werden.
- **H4**: Online-Umlagerung + Prefetching helfen NUR wenn Seitentyp + Wertablage + Affinity gemeinsam modelliert werden.

### A.7 Termin-4-Prioritaetsmodell (Cut-Regeln verbindlich)
| Prio | Block | Inhalt |
|------|-------|--------|
| P0 | Erster lauffaehiger Kern | Plain-Byte-Keys, Trie-Huelle, Redirect, Dense-ART, Sparse-HOT, terminale Knoten mit ValueHandle, externer Payload, Scalar-Pfad |
| P1 | Forschungs-Kern | Cache-Engine v1, START-Multilevel-Seiten, Inline-vs-Handle-Umschaltung, drei Ordnungsmodi, P-/E-Core-Trennung, Barnard-AVX-512, Baseline-Wrapper |
| P2 | Ausbau im Kernscope | B²-artige Decision-/Span-Suche, PRT-Custom-Seite, Online-Umlagerung/Switching, Page-/Pool-Affinity, Code-/Daten-Prefetch, erste Kostenmodelle je Seitentyp und ISA |
| P3 | Spaeterer Pflichtblock | Fingerprint-/Hash-Overlays, volle Permutationslaeufe, Seitengroessen-Sweeps, Feinkalibrierung der Cache-Engine |
| OPT | Einzige Optional-Komponente | Multiples multithreaded Schreiben |

---

## B) Bausteine_Matrix - Achsen aus Termin 3+4

Die Termin-3-Dokumente nennen **explizit die folgenden Achsen** (Workload-/Policy-Matrix-Tabelle und verstreut):

1. **Operationen**: Bulk build, exact hit, exact miss, prefix hit, prefix miss, prefix enumeration, insert, update, delete
2. **YCSB-inspirierte Mischungen**: A (50/50), B (95/5), C (read only), D (latest), E (short ranges), F (read-modify-write)
3. **Ordnungsmodus**: unsortiert, lokal geordnet, lexikographisch (= 3 Modi)
4. **Value-Modus**: inline, external handle
5. **ISA-Modus**: scalar, AVX2, AVX-512
6. **Core-Modus**: Single P, Single E, All-P, All-E, Barnard homogeneous
7. **Wiederholungen**: 5 Laeufe pro Konfiguration, Rohwerte getrennt
8. **Plattform**: lokales Hybrid (i7-1270P) vs. Barnard/Sapphire Rapids (Xeon Platinum 8470)
9. **Datensatz**: 6 Pflichtdatensaetze (url, dna, tpcds-id, trec-terms, protein, xml) + Erweiterungspool
10. **Seitentyp** (in Termin 4 erst voll als Achse formuliert): Dense-ART, Sparse-HOT, Multilevel-START, Redirect-CoCo, B²-in-page, PRT-Custom (= 6 Typen)
11. **Inline-Grenze / Inline-Umschaltung** (Termin 3 Abschnitt 1 als Permutationsachse genannt): explizit als Achse "**Ordnung, Inline-Grenze, Seitentyp-Scheduler, ISA-Modus, Plattform und Workload**" aufgezaehlt

**Anmerkung:** Termin 3 listet als Pflicht-Permutationsachsen explizit: "Ordnung, Inline-Grenze, Seitentyp-Scheduler, ISA-Modus, Plattform und Workload". Termin 4 ergaenzt **Core-Typ** und **Wiederholung** als zusaetzliche Mess-Achsen.

**Termin 3 Fairnessregel:** Es gibt zwei orthogonale **Mess-Modi** (eigene Meta-Achse):
- **Common-Denominator-Modus** (externe Payload/Handle, fair fuer alle Baselines)
- **PRT-ART-Native-Modus** (Inline-Umschaltung, Cache-Engine, Seitentyp-Scheduler)

---

## C) Cache-Engine Designmuster aus dem speziellen Cache-Engine-Trie-Dokument

### C.1 Designmuster-Familien (explizit benannt)

#### C.1.1 Kostenmodelle als "Entscheidungskern"
- Hardwarekalibrierte Kostenmodelle (START-Vorbild): "**welcher Seitentyp auf dieser CPU, bei dieser ISA (AVX2/AVX-512/vanilla) und diesem Core-Typ**"
- Multi-Level-Kosten beruecksichtigen Cache UND TLB **gemeinsam** (Saikkonen/Soisalon-Soininen)
- Blockebenen L1/L2/L3/dTLB als formal modellierte Hierarchie

#### C.1.2 "Probability Hints" / Histogramme im Header als Telemetrie-API
- Per-Node Histogramme + relative Pfadwahrscheinlichkeiten (Kuehn et al. 2023, DBIS Dortmund)
- **Quantisierte Wahrscheinlichkeitsskizzen** in Page/Node-Headern
- Theoretische Basis: Bender/Demaine/Farach-Colton 2002 (Tree Layout)

#### C.1.3 Online-Relocation als Engine-Faehigkeit
- Multi-Level-Relocation: BFS-gefuellte Bloecke, Rekursion ueber Ebenen, "mindestens halb voll" Packing
- **Page-Typwechsel** (Dense <-> Sparse <-> Redirect/CoCo <-> B²-in-page) - analog "B-Trees Are Back" adaptive Layout
- Sicheres Umschalten via OLC/ROWEX (versionierte Optimistic-Lesewege), RCU/Hazard-Pointers/Epoch-Reclamation

#### C.1.4 Prefetch-Policies als regelbares Modul
- Prefetch macht Nodes effektiv breiter ohne Latenz zu erhoehen
- Prefetch-Kandidaten aus Pfad-/Block-Countern (Read Counters), online fortgeschrieben
- Policy-Parameter: **Prefetch-Distanz, Locality-Hints, Sampling, Abschalten bei geringer Trefferquote**
- Risiken explizit modelliert: i-cache/Overfetch-Rueckkopplungen

#### C.1.5 Allocator/Pool-Strategien als Teil der Cache-Engine
- "**hardware-conscious allocator**" als Infrastrukturbaustein
- tcmalloc (per-thread/per-cpu Caches), mimalloc (Free-List-Sharding), snmalloc
- Pattern: "**Seitentyp -> eigener Pool/Arena -> planbarer Alignment- und Packing-Spielraum (Cacheline und Page)**"

### C.2 Strategie-Familien (aus der Engine-Komponenten-Visualisierung)
Das Dokument zeigt einen flowchart, der die Cache-Engine in folgende **interne Strategie-Slots** zerlegt:
- **PT** (Page-Typen): Dense/START, Sparse/HOT, Redirect/CoCo, B²-in-page
- **VH** (ValueHandles): inline vs. external payloads
- **ALLOC** (Allocator/Pools): Arena pro Page-Typ
- **PF** (Prefetcher): Software hints + Distanzregeln
- **RL** (Relocation/Compaction): online page rebuild/move
- **TEL** (Telemetrie): Histogramme/Prob-Skizzen -> feedet RL

### C.3 Plattform-Anpassung (explizite Engine-Faehigkeit)
- Cache-Engine v1 (P1): Page-Type-Selection-Rules + Prefetch v1 (konservativ)
- Cache-Engine v2 (P2): Online-Relocation mit Telemetrie + Safety
- Cache-Engine P3: Fingerprints, erweiterte Seitentypenmatrix
- ISA-/Core-Adaptivitaet ist Pflichtfeature: "Auf Hybrid-CPUs (P-/E-Cores) kann die optimale Konfiguration **kippen**"

### C.4 Forschungsluecke (explizit als PRT-ART-Beitrag markiert)
> "Genau diese Luecke [Runtime-Re-Layouting] ist dein Forschungsbeitrag." (Kommentar zu Kuehn et al. 2023)

> "Relocation-Algorithmen existieren fuer 'klassische' (binaere) Baeume, aber nicht als direkte 'Page-Typ + Trie-Huelle'-Engine."

---

## D) ISearchEngine-Familien-Konzepte

**Direkte Antwort:** **NEIN**, in den Termin-3+4-Dokumenten wird **NICHT explizit von "Suchalgorithmus-Strategie-Familien" analog zu Cache-Strategy-Familien** gesprochen.

### D.1 Was es stattdessen gibt:
Die Dokumente behandeln Such-Algorithmen ausschliesslich als **Baseline-Katalog** zum Vergleich, nicht als interne PRT-ART-Strategien:

| Algorithmus | Quellenbasis | Geplanter Status |
|-------------|--------------|------------------|
| PRT-ART | eigene C++23-Implementierung | Pflichtimplementierung |
| ART | libart (C) / optional UnoDB (C++) | Wrapper |
| HOT | speedskater/hot | Wrapper |
| Masstree | kohler/masstree-beta | Wrapper |
| B+-Baum | habedi/bptree oder embedded2016/bplus-tree | Wrapper |
| Hash-Baseline | absl::flat_hash_map / node_hash_map | Wrapper |
| START, CSS-tree, CSB+-tree, B²-tree, CoCo-trie | Papier-Nachbarn | Literaturvergleich |

### D.2 Was implizit eine ISearchEngine-Strategie-Familie sein KOENNTE:
Die **Suchseitenfamilie** (Tabelle aus Scope-Freeze) ist die einzige explizite Strategy-Familie auf der Seite des Such-Algorithmus:
- Dense Byte Page (ART) - dichte lokale Byte-Navigation
- Sparse Patricia Page (HOT) - diskriminierende Bits, hoher Fanout
- Multilevel Dense Page (START) - mehrbyteige dichte Seitendarstellung
- Decision-/Span-Page (B²) - seitinterne Suchraum-Einengung
- Redirect-Knoten (CoCo) - kollabierte Praefixpfade
- Custom Aligned Page (PRT-ART intern)

### D.3 Konzeptliche Einordnung:
Die **eigentliche Strategy-Wahl auf Seite Saeule A (Suchalgorithmus)** ist im Dokumentenkorpus nur indirekt vorhanden:
- Permutationsdimension "**Seitentyp-Scheduler**" (Termin 3) ist eine implizite Strategy
- "**B²-style in-page narrowing**" wird als "**Schablone fuer deine Seitentypfamilie**" bezeichnet - das ist Strategy-Pattern in allem ausser dem Namen

**Fazit:** Die Strategy-Familien sind in den Dokumenten **monolithisch unter "Cache-Engine" subsumiert**. Eine saubere Trennung "Suchalgorithmus-Strategie-Familie" (= Saeule A) vs. "Cache-Strategy-Familie" (= Saeule B) MUSS im REV5-UML erst durch den Architekten gezogen werden. Die Dokumente liefern dafuer nur die **Bausteine**, nicht die Aufteilung.

---

## E) Hybrid-Strategien

### E.1 Genannte Hybrid-Strategien
Im Cache-Engine-Forschungsdokument explizit benannt:

1. **Masstree** (P03): "Trie-hybrid (Trie aus B+-Trees ueber 8-Byte Slices)" - kombiniert Trie + B+-Tree
2. **Wormhole** (P07): "kombiniert Hash + Trie + B+-Tree-Ideen, um die Suchkosten an die Schluessellaenge (log L) zu koppeln und schnelle Spruenge ('Anchors') zu ermoeglichen"
3. **B²-tree** (P06): "Outer ist B+-Tree/Page-Architektur, aber jede Page enthaelt einen eingebetteten trieartigen Suchbaum (Decision- und Span-Nodes)"
4. **CoCo-trie** (P04): "Subtries werden per Optimierung lokal kollabiert (Macro-Nodes) und mit einem Pool unterschiedlicher Encodings komprimiert"

### E.2 PRT-ART selbst als Hybrid-Strategy
Die Architektur ist **selbst ein Hybrid pro Knoten/Page**:
- Trie-Huelle (Wormhole/CoCo-Idee) UEBER Suchseiten (ART/HOT/START/B²-Idee)
- Cache-Engine entscheidet **per Page** den Typ -> de-facto **Composite + Strategy Pattern**

### E.3 Behandlung: Command-Pattern oder monolithisch?

**Klare Antwort:** Die Termin-3+4-Dokumente behandeln Hybrid-Strategien **NICHT explizit als Command-Pattern**. Das Wort "Command-Pattern" kommt in keinem der 5 Dokumente vor.

Es gibt aber **starke Indizien fuer einen Command-aehnlichen Ansatz**:
- "Online-Umlagerung" + "Page-Typwechsel zur Runtime" (Cache-Engine-Dokument): Diese Operationen werden als **diskrete Aktionen** beschrieben, die die Cache-Engine **entscheidet und ausfuehrt** - das ist faktisch Command-Pattern (Encapsulation einer Aktion + Policy-Trigger).
- "**Trigger, Kostenmodell, Stabilitaet**" (Forschungsluecken-Abschnitt): Diese drei Begriffe sind exakt die Terminologie von Command + Policy.

**Fazit fuer REV5:** Der Architekt muss entscheiden, ob die "**Online-Umlagerung von Pages**" als **Command-Pattern** modelliert wird (Empfehlung aus dem Dokumententext: ja). Die Hybrid-Search-Algorithmen selbst (Masstree, Wormhole, B²-tree) sind in den Dokumenten **monolithisch als Baselines** behandelt, NICHT als Bauteil-Hybrid den PRT-ART intern nachbaut.

---

## F) Permutations-Achsen / Permutationsraum-Definition

### F.1 Termin 3, Abschnitt 1: explizite Permutationsregel
> "**Volle Permutationsmatrix zulaessig**: Ordnung, Inline-Grenze, Seitentyp-Scheduler, ISA-Modus, Plattform und Workload werden systematisch permutiert. Eine Reduktion erfolgt nur dann, wenn ein Vergleich technisch nicht sinnvoll oder funktional nicht aequivalent ist."

Daraus die **Kern-Permutationsachsen** (6 Achsen):
1. Ordnung (3 Werte)
2. Inline-Grenze (Inline / external)
3. Seitentyp-Scheduler (6 Page-Typen)
4. ISA-Modus (scalar / AVX2 / AVX-512)
5. Plattform (lokal / Barnard)
6. Workload (Microbenchmarks + YCSB-Familien A-F)

### F.2 Termin 3, Abschnitt 5 Permutationsregel
> "Die Matrix darf gross sein. Trotzdem werden **Kern- und Erweiterungsmatrix getrennt berichtet**, damit Termin 4 einen verbindlichen Pflichtsatz fixieren kann."

### F.3 Termin 4 fixiert: Pflichtmatrix vs. Vollfaktor
> "Fuer Entwicklung und Debugging wird mit einer **Pflichtmatrix** gearbeitet; der **Vollfaktor** bleibt Pflichtziel der Batch-Laeufe."

> "Erst danach Vollfaktor- und Overlay-Sweeps anwerfen."

### F.4 Vollstaendiger Permutationsraum (aus den Dokumenten zusammengetragen)
- 6 Datensaetze x 6 Page-Typen x 3 Ordnungsmodi x 2 Value-Modi x 3 ISA x 5 Core-Modi x 6 YCSB-Workloads x 5 Wiederholungen = **97.200 Konfigurationen**
- Plus optional: Inline-Grenze als kontinuierlicher Sweep, Prefetch-Distanz {1,2,4,8}, Seitengroessen-Sweep
- Pflicht-Reduktion: Common-Denominator-Modus filtert die Kernmatrix

### F.5 Cut-Regel (Termin 4 explizit)
> "Zuerst werden reine Feinkalibrierungen, zusaetzliche Overlays und grosse Permutationsbloecke nach hinten verschoben."

---

## ZUSAMMENFASSUNG FUER REV5-UML

**Saeule A (ISearchEngine):**
- Ist in den Dokumenten **NICHT als Strategy-Familie** definiert
- Existiert implizit ueber Page-Typen + Permutationsdimension "Seitentyp-Scheduler"
- **Aufgabe REV5:** Strategy-Familie auf Saeule A nachtraeglich saubern

**Saeule B (ICacheEngine):**
- Ist in Termin 4 als **eigene Schicht D** explizit definiert
- Hat 5+ Sub-Strategie-Slots (PT, VH, ALLOC, PF, RL) + Telemetrie (TEL)
- 4 dokumentierte Designmuster-Familien (Kostenmodelle, Probability Hints, Online-Relocation, Prefetch-Policies, Allocator-Pools)

**Permutationsraum:** 6+ Achsen explizit, ~10^4 - 10^5 Konfigurationen, Pflicht- vs. Vollfaktor-Trennung

**Hybrid-Behandlung:** Online-Umlagerung implizit Command-aehnlich, Hybrid-Search-Algorithmen monolithisch als Baselines

**F15 BaseEngineStrategy vs CacheEngineStrategy auf Block AO:** Direkt ableitbar aus Common-Denominator-Modus (= BaseEngine, externe Payload + statisches Layout) vs. PRT-ART-Native-Modus (= CacheEngine, Inline-Umschaltung + Cache-Engine + Seitentyp-Scheduler).
