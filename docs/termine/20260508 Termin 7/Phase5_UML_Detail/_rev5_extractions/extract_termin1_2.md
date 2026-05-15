# Extract: Termin 1 + Termin 2 — PRT-ART Bausteinkombination & Architektur

Quellen-Korpus: 13 .docx-Texte (Stand 2026-03-09 bis 2026-04-05) aus
`C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\20260508 Termin 7\_extracted_text\`

---

## A) PRT-ART Bausteinkombination — welche Algorithmen sind kombiniert?

PRT-ART = "Comdare Predix-Trie-ART" — **explizit KEIN neuer Grundtyp**, sondern eine
gezielte **Kombination komplementärer Prinzipien** aus 7 Quellfamilien. Die Kombination
hat sich von Termin 0 (CPU-only ART-artig) ueber Termin 1 (HOT-cacheline) bis Termin 2
(START + CoCo + Custom-Cache-Page) entwickelt.

### Vollstaendige Bausteinkombination (Stand Termin 2 Architektur-Freeze):

| Baustein | Quelle | Rolle in PRT-ART |
|----------|--------|------------------|
| **Redirect-Page / Trie-Huelle** | CoCo-trie (Belazzougui/Boffa et al.) | Globale praefixorientierte Huelle; data-aware Collapse von Subtries; eindeutige Restpfade als komprimierter Reststring |
| **Dense-Byte-Page** | ART (Leis/Kemper/Neumann 2013) | Dichte lokale Uebergaenge ueber 1 Byte; Node4/16/48/256-aehnliche adaptive Direktseiten; ordnungserhaltende Praefixnavigation |
| **Extended Dense Page** | START (Fent et al.) | Mehrbyteige (multilevel) lokale Seiten; Kostenmodell + Optimierer fuer Platzierung; Schwellwert-/budgetbasiertes Umschalten |
| **Sparse Patricia Page** | HOT (Binna et al. 2018) | Diskriminierende Bits, k-constrained trie, bis zu 31 Bitpositionen bei Fanout 32, 9 Layouts; Patricia-/Mehrbit-Seiten fuer sparse Suchraeume |
| **PRT-Custom-Cache-Page** | B²-Tree (Schmeisser et al. 2022) + CSS-tree + CSB+-tree | Page-lokale Decision-/Span-Suche; cache-line-grosse pointerfreie Directory-Nodes; kontiguierliche Node-Groups + erster Child-Pointer + Offsets; pool-relative Handles |
| **Subbaumgrenzen / Fences / Layer-Regeln** | Masstree (Mao/Kohler/Morris 2012) | Vorbild fuer Fences, Subbaumgrenzen, Erstellungsregeln lokaler Suchraeume, getrange-Semantik; **NICHT als lokaler B+-Baum im Kern** uebernommen |
| **Hardwareprofil-Kalibrierung** | Processor-conscious CSB+ (Samuel/Pedersen/Bonnet 2005) | Methodik: keine universellen Konstanten, Hardware-Discovery + ISA-spezifische Schwellwerte (AVX2 Intel i7-1270P + optional AVX-512 ZIH) |

### Zusatzbausteine die in spaeteren Termin-1-Iterationen aufgenommen wurden:

- **HOT-cacheline** (Termin-1-Variante "20260326 ... HOT_cacheline_final"): cache-line-aligned custom nodes als Bruecke ART <-> HOT
- **START + CoCo + sort/compact** (Termin-1-Variante "20260330 ... START_CoCo_sort_compact"): Ordnungsachse explizit als Policy
- **ValueHandle::Inline / External / ChainRef** (Termin 2): hot/cold split mit drei Auspraegungen

### Zentrale Architektur-Aussage (Termin 2, eingefroren):

> "PRT-ART ist kein einzelner Knotentyp, sondern eine kleine, bewusst begrenzte **Familie
> lokaler Seitentypen** unter einer **praefixorientierten Trie-Huelle**. Die Navigationsstruktur
> bleibt heiss und kompakt; Payload liegt standardmaessig ausserhalb des Suchpfads."

> "Der Beitrag liegt in der Kombination aus **hot/cold split, lokaler Seitenauswahl,
> praefixkomprimierter Navigation, cache-line-orientierter Kodierung, expliziten
> Value-Referenzen** und einer **policy-basierten, compile-time wartbaren Zusammensetzung**
> bekannter Einzelprinzipien."

---

## B) Konkrete Klassen/Konzepte fuer die ISearchEngine

In den Termin 1+2 Dokumenten **werden noch keine Interface-Namen wie ISearchEngine, IFanout,
ISearchPage, ISearchPageStructure, ISearchPageStructureInterpreter, ISearchPagesStrategy etc.
explizit verwendet**. Die Dokumente bleiben auf konzeptioneller / architektonischer Ebene und
sprechen von **Bausteinen, Seitentypen, Policy-Achsen, Modulen**.

### Implizit vorhandene Konzepte (mappen auf das ISearchEngine-Schema):

| Termin-1/2 Konzept | Mapping auf User-Saeule A |
|--------------------|---------------------------|
| "Trie-Huelle" + "Wegbeschreibung zur Information" | **ISearchEngine** (Top-Level Navigations-Engine) |
| "Lokale Suchseite" / "page-lokale Suchstruktur" | **ISearchPage** |
| Family of Seitentypen (Redirect/Dense/Extended/Sparse/Custom) | **ISearchPageStructure** (5 Auspraegungen) |
| "Lokale Seitencodierung darf variieren" / "page-lokale Suche statt Pointer-Chasing" | **ISearchPageStructureInterpreter** (decoder per Struktur) |
| "Seitentyp-Scheduler" / "Wahl der lokalen Seitendarstellung ist Teil der Forschungsfrage" / Cache-Engine als Entscheidungswerk | **ISearchPagesStrategy** + **ISearchPageStrategy** |
| "Fanout 32" (HOT), "Node4/16/48/256" (ART) | **IFanout** (variabler lokaler Fanout pro Page) |
| "Knoten" (Redirect-/Suchseite-/Terminal-Knoten) | **INode** |
| "Pool-relative Handles" / "ValueHandle::Inline/External/ChainRef" | **ICacheStrategy** (was/wie wird gecacht) |
| "Hardware-Discovery, ISA-Profile (AVX2/AVX-512)" | **HybridCompositionCommand** (bauzeit + laufzeit) |
| "Prefix Enumeration" / "getrange-Semantik" / "lexikographischer Modus" | **Iteratoren** (forward/range/prefix) |

### Direkte Zitate die das ISearchPage-Konzept stuetzen:

> "Lokale Suchseiten statt eines universellen Knotentyps. Unterhalb der Trie-Huelle werden
> keine starren Einheitsknoten erzwungen. Stattdessen besitzt PRT-ART eine kleine **Familie
> lokaler Seitentypen**: (i) direkte ART-artige Byte-Seiten, (ii) START-inspirierte mehrbyteige
> Seiten, (iii) HOT-inspirierte Patricia-/Mehrbit-Seiten, (iv) cache-line-ausgerichtete Custom Nodes."
> — Termin 1, START_CoCo_sort_compact

### Direkte Zitate die das ISearchPagesStrategy-Konzept stuetzen:

> "Welche Darstellung lokal verwendet wird, ist selbst Teil der Forschungsfrage und soll ueber
> **experimentell begruendete Umschaltregeln** entschieden werden."

> "Seitentyp-Scheduler: **compile-time gewaehlte Seitenfamilie**, deren **Umschaltregeln erst
> zur Laufzeit** anhand lokaler Dichte bzw. Zugriffsmuster greifen." — Termin 1 final

---

## C) ISearchPageStructureInterpreter — existiert es schon? Welche Rolle?

**Direkte Antwort:** Der Begriff "ISearchPageStructureInterpreter" wird in den Termin 1+2
Dokumenten **nicht woertlich** verwendet. **Konzeptionell existiert die Rolle aber implizit**
und ist in mehreren Aussagen verankert:

### Implizite Rolle "Interpreter pro Seitenstruktur":

In Termin 2 (Ausarbeitung, "Cache-line-aware Entwurf") werden **5 logische Seitentypen**
definiert, von denen **jeder eine eigene Such-/Decode-Logik** benoetigt:

| Seitentyp | Implizit benoetigter Interpreter |
|-----------|----------------------------------|
| Redirect-Page | Vergleicht komprimierten Reststring direkt |
| Dense-Byte-Page | Direkte oder nahezu direkte Adressierung (1-Byte slot) |
| Extended Dense Page | Mehrbyteige Adressierung mit kostenmodellgestuetzter Suche |
| Sparse Patricia Page | Suche ueber diskriminierende Bits, page-lokale Suche statt Pointer-Chasing |
| PRT-Custom-Cache-Page | Page-lokale Decision-/Span-Suche, B²-aehnliche Suchraum-Einengung |

### Stuetzendes Zitat:

> "Lokale Seitencodierung darf variieren, solange die Ordnungsrelation der rohen Byte-Keys
> nicht verletzt wird." (Invariante I4, Termin 2)

Diese Invariante macht den Interpreter zur PFLICHT-Komponente: Wenn die Codierung variiert,
muss es eine austauschbare Decodier-Logik pro Struktur geben.

### Bewertung:

Die Rolle "ISearchPageStructureInterpreter" ist eine **konsequente Weiterfuehrung** der
Termin-1/2-Architektur — sie macht das implizite "decoder-per-page-type" explizit. Aus dem
Termin 2 Architektur-Freeze laesst sich der Interpreter direkt ableiten:
- Eingabe: ISearchPageStructure (Encoding) + (Teil-)Key
- Ausgabe: naechster lokaler Slot/Handle/Pointer + ggf. ValueHandle bei Terminal

Die "Cache-Engine" aus Termin 2 (siehe Abschnitt E) entscheidet WANN welcher Strukturtyp
gewaehlt wird; der Interpreter entscheidet WIE diese Struktur gelesen wird. **Saubere
Trennung: Strategy waehlt, Interpreter dekodiert.**

---

## D) Iteratoren-Pflicht — welche Iteratoren werden gefordert?

In den Termin 1+2 Dokumenten werden **konkrete Operationen genannt, die zwingend Iteratoren
voraussetzen**:

### Operations-Inventar (Pflicht-Benchmarks und API-Operationen):

| Operation | Quelle (Termin 1+2) | Iterator-Typ |
|-----------|---------------------|--------------|
| **Exact Lookup** (successful) | Alle Termine, Pflicht | Punkt-Abruf (kein Iterator) |
| **Exact Lookup** (unsuccessful) | Termin 1 final, Pflicht | Punkt-Abruf (kein Iterator) |
| **Prefix Lookup** | Alle Termine, Pflicht | **Praefix-Iterator** (Range-of-prefix) |
| **Prefix Enumeration** | Termin 1 final, Pflicht ("complete oder incomplete multi target") | **Forward-Iterator** ueber Subtree |
| **Range-Scans** ("getrange-Semantik" aus Masstree) | Termin 2 als Policy-Modus | **Range-Iterator** (lexikographisch) |
| **Insert / Update / Delete** | Pflicht-Benchmark | Mutating-Iterator / direkter Pfad |
| **Bulk Build** | Termin 1 Vergleichsmatrix | Bulk-Build-Iterator |
| **Konsolidierter Rebuild** | Termin 1 Vergleichsmatrix | Compaction-Iterator |

### Stuetzende Zitate:

> "Die staerkste Zieloperation ist **Exact/Prefix Lookup inklusive Prefix Enumeration**;
> globale lange Range-Scans sind nicht der primaere Dominanzanspruch." (H3, Termin 1 final)

> "Vergleichsmatrix fuer Operationen: **successful exact lookup, unsuccessful exact lookup,
> prefix lookup, prefix enumeration, insert, delete, bulk build, konsolidierter Rebuild.**"
> — Termin 1 START_CoCo_sort_compact

> "Lex-Modus: expliziter, global lexikographischer Betriebsmodus fuer **Prefix Enumeration
> und Range-aehnliche Ausgaben**." (Termin 2)

### Ordnungsachse (Iterator-Semantik-Modi, Termin 2):

Drei Iterator-Semantik-Modi sind explizit Policy-Achse:

1. **Default-Modus** — keine garantierte Enumerationsreihenfolge (nur Punkt-Suche)
2. **Lokaler Ordnungsmodus** — geordnete Eintraege innerhalb einer Seite/Knotengruppe (lokal sortierter Iterator)
3. **Lex-Modus** — global lexikographischer Iterator fuer Prefix Enumeration + Range

### Bewertung mit User-Direktive:

User-Direktive: *"Iterator wird in all unseren Arbeiten immer vollstaendig implementiert"*
=> Im PRT-ART-Kontext bedeutet dies **mindestens 3 Iteratoren**:

1. **PrefixIterator** — fuer Prefix Lookup
2. **EnumerationIterator** (forward) — fuer Prefix Enumeration
3. **RangeIterator** (lexikographisch, getrange) — fuer Lex-Modus

Plus zugehoerige **bidirektionale Varianten** (Termin 2 erwaehnt explizit Modus
"absteigend/aufsteigend/custom" als API-Entscheidung fuer Termin 2/3).

---

## E) Architekturentscheidungen die das Konzeptmodell beeinflussen

### E1) Trennung Trie-Engine vs. Cache-Engine (Termin 2 Kernentscheidung)

> "Die Cache-Engine ist **logisch von der Trie-Engine getrennt**. Sie ist keine neue
> Query-Engine, sondern ein **lokales Entscheidungswerk**, das Seitentyp, Ausrichtung und
> Handle-Strategie auswaehlt. Damit wird Cache-Awareness explizit statt implizit."

=> **Direktes Mapping auf User-Zwei-Saeulen-Modell**: Saeule A (ISearchEngine) = Trie-Engine,
Saeule B (ICacheEngine) = Cache-Engine mit Plattform-Modell + Heuristiken.

### E2) Cache-Engine-Eingaben (= Plattform-Modell + Heuristiken)

Die Cache-Engine beobachtet:
- lokale Dichte und Fanout im aktuellen Teilbaum
- Praefixentropie / Laenge gemeinsam geteilter Restpfade
- erwartete beruehrte Cache-Lines + Pages pro Lookup
- Key- und Value-Groesse + Inline-Eignung
- ISA- und Hardwareprofil (AVX2 verfuegbar, optional AVX-512)

Cache-Engine entscheidet:
- Seitentyp
- Alignment
- lokale Ordnung
- Inline-vs.-Pointer-Value
- Reorganisation von Node-Gruppen

### E3) Hot/Cold Split (Pflicht-Architektur)

> "hot/cold split. Der Suchpfad enthaelt standardmaessig keine grossen Nutzdaten; kleine Werte
> duerfen im Inline-Modus direkt im terminalen Knoten liegen."

=> ValueHandle::Inline / External / ChainRef — mit ChainRef als explizit vertagte Erweiterung.

### E4) Compile-time vs. Runtime Hybrid-Komposition

> "Seitentyp-Scheduler: **compile-time gewaehlte Seitenfamilie**, deren **Umschaltregeln
> erst zur Laufzeit** anhand lokaler Dichte bzw. Zugriffsmuster greifen."

=> Direktes Mapping auf User-Konzept "HybridCompositionCommand".

### E5) 6 Invarianten (Termin 2 hart eingefroren)

| ID | Invariante |
|----|------------|
| I1 | Jeder Lookup traversiert ausschliesslich Navigationsknoten bis zu terminalem Knoten oder Miss |
| I2 | Terminaler Knoten besitzt genau ein ValueHandle; Payload standardmaessig extern, optional inline |
| I3 | Redirect-Knoten komprimieren eindeutige Restpfade, ersetzen NICHT echte Mehrfachverzweigung |
| I4 | Lokale Seitencodierung darf variieren, solange Ordnungsrelation der rohen Byte-Keys nicht verletzt wird |
| I5 | Seitentyp-Umschaltungen sind explizite Policy-Entscheidungen; KEINE festen universellen Schwellwerte |
| I6 | Concurrency bleibt im Kernumfang auf spaetere Erweiterung begrenzt; Single-Thread + Read-Scaling-Vorbereitung |

### E6) Harte Scope-Grenzen (was NICHT in den Kern gehoert, Termin 2)

- Multi-Writer-Concurrency
- GPU
- vollstaendige DBMS-IAM-Integration
- generischer Sortieralgorithmus-Vergleich auf jeder Ebene
- Fingerprint-/Hash-Framework als Hauptpfad

### E7) Erlaubte Erweiterungshinweise (Termin 2)

- **Observer-/Visitor-Stellen** fuer spaetere Parallelitaet (Hooks!)
- optionale SIMD-Kernels
- optionale Fingerprint-Pfade fuer reine Exact-Lookups

### E8) Hardwareprofil-Discovery statt statischer Annahmen

> "**keine statischen Architekturannahmen als allgemeine Regel**. Stattdessen Hardware-Discovery
> plus anfaenglicher Referenzpfad fuer Intel Core i7-1270P (AVX2) und optional AVX-512-faehige
> ZIH-Ziele."

=> Mapping: ICacheEngine besitzt Plattform-Modell-Komponente die Hardware enumeriert.

### E9) Risiko-Liste (Termin 2 Termin-2-spezifisch)

| Risiko | Gegenmassnahme |
|--------|----------------|
| Framework-Explosion | Kern auf 5 Seitentypen + ValueHandle + Ordnungsmodus + Cache-Engine begrenzen |
| Architekturabhaengigkeit | Hardwareprofile statt universeller Konstanten |
| Zu komplexe Cache-Engine | Termin 2 nur Entscheidungsgeruest; numerische Kalibrierung auf Termin 3 verschieben |
| Inline-Value-Fehlannahmen | Inline nur als messbare Policy, nicht Default |
| Concurrency-Scope | Observer-/Visitor-Stellen notieren, aber Multi-Writer NICHT im Kernumfang |

---

## Schlussfolgerungen fuer das REV5-Konzeptmodell

1. **PRT-ART = 7-Quellen-Hybrid** (CoCo + ART + START + HOT + Masstree + CSS/CSB+ + B²-Tree)
   mit **5 logischen Seitentypen** unter **1 Trie-Huelle**.

2. **Saeulen-A/B-Modell ist im Termin 2 Doku bereits explizit verankert** als Trennung
   Trie-Engine vs. Cache-Engine.

3. **ISearchPageStructureInterpreter existiert konzeptionell** als logische Notwendigkeit
   aus Invariante I4 (variable lokale Codierung) — der Begriff ist neu, die Rolle nicht.

4. **Iteratoren mindestens 3 Pflicht-Auspraegungen**: Prefix, Enumeration (forward),
   Range (lexikographisch). User-Direktive "vollstaendig implementiert" = beide Richtungen
   (asc/desc) sind in Termin 2 schon als API-Entscheidung gelistet.

5. **HybridCompositionCommand mappt direkt** auf "compile-time Seitenfamilie + runtime
   Umschaltregeln" (Termin 1 final, Section 4 Cache-Engine + Termin 2 Architekturachse).

6. **Architektur-Freeze ist Termin 2** — Termin 3+ (Datasets, Baselines, Kalibrierung)
   baut darauf auf, aendert das Konzeptmodell aber nicht mehr fundamental.
