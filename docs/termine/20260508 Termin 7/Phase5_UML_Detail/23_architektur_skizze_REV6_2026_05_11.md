# Architektur-Skizze REV 6 (2026-05-11, korrigiert 2026-05-12)

**Status:** REV 6 = REV 5.3 + PRT-ART-ERWEITERUNG (NICHT Ersatz!) aus 35 GPT-Antworten + 3 Fallbeispielen
**Vorgaenger:** `22_architektur_skizze_REV5_2026_05_11.md` (REV 5.3 mit 32 drawio-Tabs)
**Neue Quelle:** `C:\Users\benja\OneDrive\Desktop\Projekte\Research\comdare-prt-art\GPT questions to prt art.txt` (35 Fragen + 3 Fallbeispiele)
**Scope:** **REIN ADDITIVE ERWEITERUNG** um PRT-ART-spezifische Bausteine. Alle 32 REV-5.3-Tabs sind **unveraendert**. PRT-ART wird als **eigenstaendige zusaetzliche Variante** im selben Permutations-Framework der Cache-Engine getestet.

---

## 0. KORREKTUR-VERMERK 2026-05-12

**WICHTIG (User-Direktive 2026-05-12):**

Die urspruengliche REV-6-Version vom 2026-05-11 hatte faelschlicherweise die "6 Seitentypen" aus Termin 4 durch "2 PRT-ART-Node-Typen" **ersetzt**. Das war im Cache-Engine-Sinne **FALSCH**.

**Korrekte Sicht:**

| Perspektive | Aussage |
|-------------|---------|
| **Cache-Engine-Perspektive (universell)** | Die Cache-Engine permutiert **alle** Seitentypen aus den 33 Papern als Baseline-Familie. **Die 6 Seitentypen aus Termin 4 bleiben permutierbar.** |
| **PRT-ART-Perspektive (spezifisch)** | PRT-ART ist EINE konkrete Algorithmus-Variante, die je Baustein-Familie **zusaetzliche** Permutations-Optionen liefert. Im PRT-ART-Code selbst sind nur 2 Node-Typen (Redirect + B+) verwendet. |

PRT-ART zeigt die **Erweiterbarkeit** des Cache-Engine-Frameworks: ein neuer Algorithmus kann hinzugefuegt und gegen alle existierenden Baselines unter denselben Bedingungen gemessen werden.

**Korrektur-Aktion:**
- §5.2 und §5.3 (REV-5 Stand mit 6 Seitentypen + 7-Quellen-Hybrid) **bleiben gueltig**, wie in `22_architektur_skizze_REV5_2026_05_11.md`
- PRT-ART-spezifische Erweiterungen sind ab §5.17 NEU **ANGEHAENGT**, klar markiert
- drawio K05b umgestaltet als "PRT-ART-Erweiterung" statt "Korrektur" (siehe Aktualisierung des Tab-Inhalts)

---

## 0.1 Zusammenfassung der REV-6-Erweiterungen (KORRIGIERT 2026-05-12)

| Sektion / Tab | REV 5.3 Stand | REV 6 ERWEITERUNG (additive) |
|---------------|---------------|------------------------------|
| **K05 §5.2** "7-Quellen-Hybrid" | unveraendert (6 Seitentypen aus Termin 4 + Baseline-Quellen-Inventar) | **UNVERAENDERT** — die 6 Seitentypen bleiben Pflicht-Baseline |
| **K05 §5.3** "6 Seitentypen P0/P1/P2" | unveraendert | **UNVERAENDERT** — alle 6 Pflicht-Permutationsachsen bleiben |
| **K05 §5.4** ValueHandle | unveraendert | **ERGAENZT (Anmerkung)**: Keys sind eindeutig (Frage 1) — ChainRef bleibt fuer Multi-Value-Erweiterung |
| **K05 §5.5** Iteratoren | unveraendert | **ERGAENZT**: Prefix-with-Flag-Modus (Frage 2) liefert `tuple<Key-Rest, Value>`-Sequenzen |
| **K05 §5.17 NEU** PRT-ART-Spezifika | nicht vorhanden | **NEU ANGEHAENGT als Anhang**: 2 Node-Typen + 4 Suchtypen + Dichte-Schwellen + virtuelle Adressierung + Linearer Value-Buffer + 4+2 Allokator-Pools + Signaling-Bits-Serialisierung + Multi-RW-Concurrency + Compile-Time-Templates |
| **K12 §7 NEU** D10-D13 Permutationsdimensionen | D1-D9 vorhanden | **ERGAENZT**: D10 Suchtyp-Reihenfolge, D11 Dichte-Schwellen, D12 Fingerprint-Filter, D13 Serialization-Wahl (alle PRT-ART-spezifisch) |
| **U10 NEU** comdare::prt_art Template-Klasse + IPermutationEngine | nicht vorhanden | **NEU**: PRT-ART Template-Vollklasse + Beziehung zu IPermutationEngine + CacheEngineBuilder |
| K01-K04, K06-K15 + U01-U09 + K07a-d + K08a-d | unveraendert | unveraendert |

**Kern-Aussage:**
- Die Cache-Engine-Perspektive ist **universell** und faehig, beliebige Algorithmen als Permutations-Baselines aufzunehmen.
- PRT-ART ist eine **Beispiel-Algorithmus-Erweiterung**, die zeigt:
  1. Wie ein neuer Algorithmus in das Framework integriert wird
  2. Wie er gegen die 33 Paper-Baselines getestet wird
  3. Wie die Cache-Engine ihn beschleunigt
- Je Baustein-Familie (Allokatoren, Fanouts, Nodes, etc.) liefert PRT-ART **experimentelle Permutations-Optionen**, die zusammen mit den existierenden Algorithmus-Varianten aus dem Stand der Technik permutierbar sind.

---

## 1. ERWEITERUNGEN GEGENUEBER REV 5.3

### 1.1 Was bleibt UNVERAENDERT vs REV 5.3

Alle Sektionen §1 bis §16 in `22_architektur_skizze_REV5_2026_05_11.md` bleiben **unveraendert gueltig**. Insbesondere:

- §1 Drei-Ebenen-Architektur (Wurzel-Sicht)
- §2 Saeule A ISearchEngine (Concept-Hierarchie, Visitor, 4-Ebenen-Strategien)
- §3 ICacheStrategy als Permutationsdimension
- §4 4-Ebenen-Strategien (K04)
- **§5 PRT-ART vollstaendige Bausteinkombination (K05) — bleibt mit 7-Quellen-Hybrid und 6 Seitentypen!**
- §6 ISearchEngine-Familien-Taxonomie (S1-S30)
- §7-§8 IPlatformProbe + Plattform-Modell (28 Concept-Klassen)
- §9 IHeuristic-Familie
- §10 29 Cache-Strategie-Familien F1-F29
- §11 Phase-1-7-Pipeline
- §12 Forschungsmission F15 + Cache+Search-Cross
- §13 Future-Proof-Prinzipien
- §14 Layer-Matrix-Hybrid + DSM
- §15 Tab-Inventar
- §16 Naechste Schritte
- §17 REV-5.1-Korrekturen
- §18 Status / Naechste Entscheidungen

### 1.2 Was REV 6 ZUSAETZLICH liefert (rein additive Anhang-Sektionen ab §5.17)

Die GPT-Antworten zur PRT-ART liefern Praezisierungen zur **PRT-ART als spezifischer Beispiel-Algorithmus** — sie ersetzen NICHT die universelle Cache-Engine-Sicht. Daher werden alle PRT-ART-Spezifika ab §5.17 als **HINTERER ANHANG** angefuegt:

- §5.17 PRT-ART-spezifische Node-Typen (2 statt 6 — gilt NUR fuer den PRT-ART-Algorithmus)
- §5.18 4 interne Suchtypen mit Dichte-Schwellen
- §5.19 Virtuelle Memory-Offset-Adressierung (TLB-inspired)
- §5.20 Linearer Value-Buffer mit Lazy Deletion
- §5.21 4+2 Allokator-Pools fuer PRT-ART
- §5.22 Signaling-Bits-Serialisierung
- §5.23 Multi-Reader-Writer-Concurrency
- §5.24 Compile-Time-Template-Parameter
- §5.25 3 kanonische Fallbeispiele
- §5.26 Split-/Compaction-Logik
- §5.27 Beziehung PRT-ART <-> Cache-Engine-Framework (KRITISCH)
- §7' Erweiterung K12 Permutationsdimensionen (D10-D13 zusaetzlich)
- §8' Tab-Inventar-Erweiterung
- §9' Verzeichnis-Struktur fuer PRT-ART in comdare-cache-engine
- §10' Glossar-Update

Diese Anhang-Sektionen ergaenzen, ohne den universellen Charakter der Cache-Engine zu beeintraechtigen.

---

## 2. Klare Trennung PRT-ART vs. Cache-Engine (KRITISCH)

| Aspekt | Cache-Engine (universell) | PRT-ART (spezifisch) |
|--------|----------------------------|-----------------------|
| **Node-Typen** | 6 aus Termin 4 + alle Erweiterungen permutierbar | 2 Node-Typen (Redirect + B+) als spezifische Variante des Algorithmus |
| **Page-Layouts** | 6 Pflicht-Baselines + adaptive Mischformen | 4 dynamische Suchtypen im B+-Knoten |
| **Allokator** | Generischer Pool-Manager (C6 Sub-Engine) | 4+2 spezielle Pools mit Bucket-Vektor |
| **Concurrency** | Generisches Visitor-Pattern (C4 Sub-Engine) | OLC + reservierte Value-Bloecke pro Writer |
| **Permutations-Achsen** | D1-D9 aus REV 5.3 + D14 Baselines | D10-D13 zusaetzlich (Suchtyp-Reihenfolge, Dichte-Schwellen, Fingerprint, Serialization) |
| **Rolle** | Forschungs-Framework | Beispiel-Algorithmus + Erweiterungs-Beweis |

Die Cache-Engine ist **NICHT** spezifisch fuer PRT-ART. PRT-ART ist nur EINER der vielen Algorithmen, die durch das Framework permutiert und beschleunigt werden.

---

## 3. Anhang ab §5.17 — PRT-ART-Spezifika

### §5.17 NEU — PRT-ART hat 2 Node-Typen (im Spezifik-Sinne)

**KLARSTELLUNG:** Diese 2 Node-Typen sind PRT-ART-spezifisch. Die universelle Cache-Engine permutiert weiterhin alle 6 Seitentypen aus §5.3 (Termin 4 Scope-Freeze) als Baseline-Familie.

```
«concept» IPrtArtNode (Wurzel der PRT-ART-eigenen Knotenfamilie)
   |
   +-- «concrete» PrtArtRedirectNode
   |     - kompaktiert eindeutige Substrings (vermeidet Pointer-Chasing)
   |     - enthaelt: komprimierter Byte-String + optional ValueHandle
   |     - terminale Form moeglich (z.B. nur "haus" gespeichert)
   |     - Quelle: CoCo-trie-Idee
   |
   +-- «concrete» PrtArtBPlusNode
         - enthaelt EINEN von 4 internen Suchtypen (siehe §5.18)
         - dynamische Layout-Transition bei Dichte-Schwellen 25/50/75%
         - Quelle: ART-Idee in PRT-ART-Verallgemeinerung
```

**Beziehung zu den 6 universellen Seitentypen (§5.3):**

PRT-ART verwendet von den 6 Termin-4-Seitentypen **2 als seine eigenen Bausteine**:
- `PrtArtRedirectNode` = Konkretisierung von Redirect-Knoten (CoCo)
- `PrtArtBPlusNode` = Konkretisierung mit 4 inneren Sub-Varianten

Die anderen 4 Seitentypen (Dense-Byte ART, Multilevel START, Sparse-Patricia HOT, Decision-Span B^2, Custom-Aligned) bleiben als **Baselines (D14)** in der Cache-Engine permutierbar und werden gegen PRT-ART gemessen.



PRT-ART hat **einen** B+-Knotentyp, der intern **4 dynamisch wechselbare Suchtypen** anbietet. Die Transition zwischen Suchtypen erfolgt bei festen Dichte-Schwellen:

| Suchtyp | Datenstruktur | Slot-Breite | Anzahl Felder | Dichte-Schwelle (Transition aus) |
|---------|---------------|-------------|---------------|----------------------------------|
| **Typ A** | `Array[256]` | 1 Byte | 256 | initial; bei > 25 % Belegung -> Merge zwei Ebenen zu Typ B |
| **Typ B** | `Array[65535]` | 2 Bytes | 65 535 | aus A; bei > 50 % Belegung -> Split zwei Ebenen zu Typ C |
| **Typ C** | `Vector<tuple<u8,u8>>` Range Scan, **sortiert nach Auftrittswahrscheinlichkeit** | 2 Bytes | variabel | aus B; bei > 75 % Belegung -> Merge zwei Ebenen zu Typ D |
| **Typ D** | `Vector<tuple<u16,u16>>` Range Scan, **sortiert nach Auftrittswahrscheinlichkeit** | 4 Bytes | variabel | terminale Form (dichteste Belegung) |

**Wichtige Eigenschaften (Frage 4, Frage 25-29):**
- Alle 4 Strukturen sind so dimensioniert, dass sie **Vielfache der Memory-Seitengroesse (4 KiB)** sind. Dadurch garantiertes perfektes Memory-Alignment.
- Jeder Suchtyp hat **eigenen Allokator-Pool** (siehe §5.11) fuer Alignment-Garantie.
- Die Sortierung nach Auftrittswahrscheinlichkeit in Typ C+D ist Teil des **adaptiven Verhaltens**.

**Forschungsfrage (Frage 4 explizit):**
> Wir wollen weiterhin herausfinden, ob jeweils die Anordnung von Array[65535] vielleicht je Punktsuche oder unsigned short Rangesuche zuerst besser ist oder nicht, und welche Reihenfolge der 4 Methoden zu welchen Fuellstaenden der Indexierung am besten passt.

Diese Suchtyp-Reihenfolge-Wahl wird Teil der **F15-Permutationsdimension** (siehe K12 in REV 5.3): die 4-er-Reihenfolge ist eine zusaetzliche Permutationsachse.

---

## §5.19 NEU — Virtuelle Memory-Offset-Adressierung (Frage 6, 12, 13)

Der Algorithmus heisst "PRT-ART" weil er einen **ART** ist im Sinne der adaptiven Knotengeometrie, aber mit dem Zusatz einer **virtuellen Memory-Offset-Berechnung** wie sie aus CPU-TLBs bekannt ist.

**Kernidee:**

Fuer einen Key der Laenge `k_count` mit Bytes `k[0], k[1], ..., k[k_count-1]` ergibt sich die **virtuelle Position** der Value-Node:

```
virtuelle_position = sum(k[i] * 256^(k_count - 1 - i))   fuer i = 0..k_count-1
```

Das ist die Annahme "die Tiefe des Baumes waere vollstaendig reserviert" — als ob jeder moegliche Praefix eine eigene Value-Adresse haette.

**Mapping virtuell -> physisch:**
- Die virtuelle Adresse wird durch den Custom-Pool-Allocator auf einen tatsaechlichen physischen Speicherbereich gemappt.
- Aehnlich CPU-TLBs verwaltet PRT-ART einen "Virtual-to-Physical"-Translation-Layer.
- **Redirect-Knoten** zaehlen virtuell wie ein "festes Sub-Pfad-Character 0" pro komprimiertem Byte (Frage 12, 13).

**Vorteil:** Lineare arithmetische Adressberechnung statt Pointer-Chasing fuer die Value-Position.

**Konkrete Konsequenz:** PRT-ART benoetigt eine eigene `IVirtualOffsetCalculator`-Concept-Klasse (NEU REV 6), die die Offset-Formel berechnet.

```
«concept» IVirtualOffsetCalculator (NEU REV 6)
   - compute(key : KeyView) const : VirtualOffset
   - virtuelle Anzahl moeglicher Strings = 256^k_count
   - physische Adresse durch Mapping ueber Pool-Allocator
```

---

## §5.20 NEU — Linearer Value-Buffer (Frage 9, 14, 21, 22)

**Speicher-Modell der Values:**

```
+-------------------+---------+---------+---------+ ... +-----+-------+
| Value 0           | Value 1 | Value 2 | dirty  |     | ... | EOF   |
+-------------------+---------+---------+---------+ ... +-----+-------+
                                          ^
                                          | gelöschter Slot (lazy deletion)
```

**Eigenschaften:**
- Values werden **streng in Insert-Order** linear angehaengt.
- Values werden **NIE bewegt** waehrend des Betriebs (Performance-Garantie).
- Loeschen markiert die Stelle als "dirty" (lazy deletion), die Bytes bleiben physisch.
- Pointer-Pfade durch den Trie zeigen auf den Offset im Value-Buffer.

**Konsolidierung (Frage 22):**
- Trigger: wenn `dirty_bytes > nutzbare_bytes` (also > 100 % Verschwendung)
- ODER bei vollstaendiger Loeschung
- ODER bei expliziter User-Anforderung
- Aktion: Value-Buffer wird einmalig in Order rekopiert; alle Trie-Pointer werden auf neue Offsets umgebogen
- Es entstehen "dirty holes" — werden toleriert (Frage 14: "Wir sind schlecht mit Loeschen")

**Adressierung der Value-Position:**
- `IsValidValuePointer(offset) := offset < high_water_mark AND NOT marked_deleted(offset)`
- Wenn der virtuelle Pointer ausserhalb des allokierten Bereichs zeigt -> Key ist nicht valide -> empty Value oder Exception (gemaess C++23-Metaprogrammierung des Users)

---

## §5.21 NEU — Allokator-Pool-Strategie fuer PRT-ART (Frage 25, 28, 29)

**HINWEIS:** Diese 4+2 Pools sind PRT-ART-spezifisch und ergaenzen die generische C6 Cache-Allocation-Engine-Familie (siehe REV 5.1 K15). Andere Algorithmen koennen andere Pool-Strukturen verwenden.

PRT-ART verwendet **4 + 2 Allokator-Pools** mit perfektem Alignment:

| Pool | Inhalt | Alignment | Allokator-Strategie |
|------|--------|-----------|---------------------|
| **Pool A** | B+-Knoten mit Suchtyp A (Array[256]) | 256 B (Cache-Line / Page-Multiple) | Fixed-Size Slab-Allocator |
| **Pool B** | B+-Knoten mit Suchtyp B (Array[65535]) | 64 KiB (16 Pages) | Fixed-Size Slab-Allocator |
| **Pool C** | B+-Knoten mit Suchtyp C (Vector<u8,u8>) | 4 KiB (1 Page), variable Fuellung | Pool mit variabler Vektor-Groesse |
| **Pool D** | B+-Knoten mit Suchtyp D (Vector<u16,u16>) | 4 KiB+ (Vielfache), variable Fuellung | Pool mit variabler Vektor-Groesse |
| **Pool R** | Redirect-Knoten (Byte-String + optional Value-Pointer) | 64 B (Cache-Line) | Variable-Size Slab-Allocator |
| **Pool V** | Linearer Value-Buffer | bucket-basiert mit dynamischer Erweiterung | Append-only Vector + Bucket-Vektoren (Frage 15) |
| **Pool V-static** | Values mit statischer Groesse (kein Serializer noetig) | bucket-basiert | Append-only mit fixer Slot-Groesse |
| **Pool V-dynamic** | Values mit dynamischer Groesse | bucket-basiert | Append-only mit Signaling-Bits-Header (siehe §5.12) |

**Frage 15 wortwoertlich:**
> Wir verwenden dasselbe Prinzip, das je allocator bucket ein vector verwendet, wenn wir weitere Elemente einfuegen. Weil wir eh selbst allozieren und verwalten, gehen wir von sparse Speichernutzung und custom alignment aus.

```
«concept» IPrtArtAllocator (NEU REV 6)
   - allocate(pool_kind : PoolKind, size_hint : size_t) : VirtualOffset
   - deallocate(pool_kind, offset) : void  // markiert dirty, nicht physisches Free
   - consolidate(pool_kind) : ConsolidationStats  // re-copy + Pointer-Adjust
   - bucket-Strategie pro Pool: Vector<Bucket>, Append-only

«concrete» Pool-A / Pool-B / Pool-C / Pool-D / Pool-R / Pool-V-static / Pool-V-dynamic
   - implementieren IPrtArtAllocator pro Pool-Familie
```

---

## §5.22 NEU — Custom Serialisierung mit Signaling Bits (Frage 5, 10)

Fuer **dynamische** Value-Groessen verwendet PRT-ART eine **sparse length serialization** mit Signaling Bits:

```
| Header (1 Byte)                | Length-Bytes (ser_length)        | Payload (value_bytes)  |
| signaling_bits + len_info_size | tatsaechliche Laenge des payloads | rohe value-Bytes       |
```

**Header-Byte:**
- Niedrigste Bits beschreiben, **wieviele Bytes** zur Laengen-Encodierung folgen (1-8 Bytes typischerweise)
- Signaling-Bits markieren Spezialfaelle (z.B. statischer Typ, Compression-Flag, etc.)

**Vorteile:**
- Kleine Values (z.B. 0-127 Byte) brauchen nur 1+1+payload = minimaler Overhead
- Grosse Values (z.B. > 65 KiB) erlauben bis zu 8 Bytes Laengen-Header
- Der Typ ist fuer PRT-ART transparent — User-Templates definieren statisch zur Compile-Zeit

**Frage 5 wortwoertlich:**
> Ein value ist formal ein vom Nutzer serialisiertes Datenobjekt, um dessen Form wir uns nicht scheren, wir speichern alles als unsigned char, also als Bytes ab.

**Frage 10 wortwoertlich:**
> Wir merken uns eine dynamische Serialisierung (ein Byte mit gesetzten signaling bits fuer die Beschreibung der Bytes die verwendet werden, um den Typ des folge Elementes zu beschreiben -> sparse length serialization mit folgendem Informationsstring, die Laenge der value ist also 1 + ser_length + value_bytes).

```
«concept» IValueSerializer (NEU REV 6)
   - serialize(value : Value const&, out : ByteBuffer&) : void
   - deserialize(bytes : span<byte const>) : optional<Value>
   - is_static_size() : bool  // wenn true, kein Header noetig (Pool V-static)

«concrete» StaticSizeSerializer / DynamicSignalingBitsSerializer
```

---

## §5.23 NEU — Multithreaded Read + Write Concurrency (Frage 33)

PRT-ART unterstuetzt **von Anfang an** sowohl paralleles Lesen als auch paralleles Schreiben (im Gegensatz zur Invariante I6 aus REV 5, die nur Single-Thread + Read-Scaling-Vorbereitung vorsah).

**Konkurrente Operationen:**
- **Read:** Standard parallel ohne Synchronisation (Lock-free dank linearem Value-Buffer)
- **Write:** parallel **wenn die zu beruehrenden Nodes nicht konfligieren** ueber den Gesamtbereich
- Values werden in **sequentiell reservierte Speicher-Bloecke** kopiert (jeder Writer hat eigenen Bloeck-Reservation-Token)
- Index-Updates erfolgen parallel auf disjunkten Node-Bereichen

**Anpassung von Invariante I6 (Termin 2):**

> **I6 (REV 6 PRAEZISIERT):** Concurrency ist **NICHT** auf spaetere Erweiterung begrenzt. PRT-ART unterstuetzt Multi-Threading fuer Read und Write durch:
> 1. Lock-free Reader (Standard)
> 2. Reservierte Value-Speicher-Bloecke pro Writer (sequentielle Allokation)
> 3. Parallele Index-Updates auf disjunkten Node-Bereichen (Konflikt-Detection notwendig)
> 4. Konflikt-Resolution via OLC (Optimistic Lock Coupling, siehe S30 in K06)

```
«concept» IPrtArtConcurrencyManager (NEU REV 6)
   - reserve_value_block(writer_id, size_hint) : VirtualOffset
   - lock_node_range(start, end, mode : Read|Write) : NodeLock
   - detect_conflict(write_set_a, write_set_b) : bool
   - resolve_conflict(strategy : OlcRestart|Wait|Abort) : ResolutionResult
```

---

## §5.24 NEU — Compile-Time Metaprogrammierung (Frage 30, 31)

Aus Frage 30+31:
> Die Suchstrategien (fuer B+ nodes) lassen sich ebenfalls als Metaprogrammierung auf compile Time setzen, zusaetzlich zu den allokatoren.

**Template-Parameter-Set fuer `comdare::prt_art<...>`:**

```cpp
template <
    typename Key,                                     // KeyView (immer unsigned char Bytes intern)
    typename Value,                                   // beliebiger User-Typ
    typename SerializationStrategy = AutoSerializer,  // statisch/dynamisch
    typename AllocatorA = DefaultPoolA,               // 4 Pools + Value-Pool optional eigen
    typename AllocatorB = DefaultPoolB,
    typename AllocatorC = DefaultPoolC,
    typename AllocatorD = DefaultPoolD,
    typename AllocatorR = DefaultPoolR,
    typename AllocatorV = DefaultPoolV,
    typename TypeTransitionPolicy = StandardThresholdsPolicy,  // 25/50/75% Standard
    typename FingerprintFilter = NoFingerprint,                // optional Vorfilter
    typename ConcurrencyStrategy = OlcMultiWriter
>
class prt_art;
```

**Fingerprint-Vorfilter (Frage 31):**
- Optional als Compile-Time-Hook
- Erzeugt aus dem Original-Key einen **stabilen Fingerprint** (z.B. Hash-Praefix)
- Wird intern wie ein normaler Praefix-Key verarbeitet
- **Performance-Hypothese:** kuerzere/konsistentere Darstellung -> bessere Performance (Frage 31 explizit als Experiment-Frage formuliert)

---

## §5.25 NEU — 3 Konkrete Fallbeispiele (aus GPT Fall 1-3)

Diese 3 Beispiele sind kanonische Test-Faelle fuer die Implementation (Phase 6+).

### Fall 1: Trie mit "hallo" + "halter"

```
Root: PrtArtRedirectNode("hal")
  |
  +-- PrtArtBPlusNode (Suchtyp A: Array[256])
        | index['l'] = Slot 0
        | index['t'] = Slot 1
        | alle anderen = invalid (Pointer ausserhalb Value-Horizont)
        |
        +-- Slot 0: PrtArtRedirectNode("lo") + ValueHandle -> "hallo"-Value
        +-- Slot 1: PrtArtRedirectNode("ter") + ValueHandle -> "halter"-Value
```

**Lookup von "hallo":**
1. Root Redirect: vergleicht "hal" mit Key-Praefix -> match
2. B+-Node Array[256]: index['l'] = Slot 0
3. Slot 0 Redirect: vergleicht "lo" mit Key-Rest -> match
4. ValueHandle laden + zurueckgeben

### Fall 2: Trie startet mit nur "ab", danach "abc" hinzu

**Schritt 1: nur "ab" gespeichert:**
```
Root: PrtArtRedirectNode("ab") + ValueHandle -> "ab"-Value
```

**Schritt 2: "abc" wird eingefuegt:**
```
Root: PrtArtRedirectNode("ab") + ValueHandle -> "ab"-Value
  |
  +-- (NEU eingefuegte B+-Node) PrtArtBPlusNode (Suchtyp A: Array[256])
        | index['c'] = Slot 0
        |
        +-- Slot 0: ValueHandle -> "abc"-Value
```

**Wichtig (Frage 16):**
> Eine redirect node hat ebenfalls keinen nullpointer als value, sondern einen Wert, wenn der Rest string nicht fuer das letzte Element in einer B+ Knoten node (regulaer) landen sollte.

D.h. Root-Redirect kann sowohl Value haben (fuer "ab") als auch B+-Sub-Node (fuer Erweiterungen).

### Fall 3: nur "haus" gespeichert, Lookup von "hafen"

```
Root: PrtArtRedirectNode("haus") + ValueHandle -> "haus"-Value
```

**Lookup von "hafen":**
1. Root Redirect: vergleicht "haus" mit "hafen"
2. Byte-by-Byte-Compare (Frage 17): "h" = "h" ok, "a" = "a" ok, "u" != "f" MISMATCH
3. Algorithmus liefert leere Value oder Exception (gemaess C++23-Metaprogrammierung)

---

## §5.26 NEU — Split- und Compaction-Logik (Frage 23, 24)

**Split bei Redirect-Knoten-Divergenz:**

| Divergenz-Position | Aktion |
|---------------------|--------|
| **Anfang** (erstes Byte) | Erstes Byte wird in neue B+-Node extrahiert, restlicher String in Redirect-Node verschoben |
| **Mitte** | Aufteilung: 1. Redirect-Node vor Stelle, B+-Node an Stelle, 2. Redirect-Node nach Stelle |
| **Ende** | Letztes Byte als B+-Node-Eintrag, restlicher String bleibt in Redirect-Node |

**Compaction beim Loeschen:**
- Knoten ohne Kind koennen wieder in Redirect-Knoten **gemergt** werden (Frage 24)
- B+-Node wird geloescht, Byte wird zurueck in Redirect-String eingefuegt
- Nodes vor und nach Redirect werden verbunden

---

## §5.27 NEU — Beziehung PRT-ART <-> Cache-Engine-Framework (KRITISCH)

User-Direktive 2026-05-12:
> "Jede ExecutionEngine muss durch eine PermutationEngine fuer die Feature Permutation, gesteuert durch die CacheEngineBuilder, gesteuert werden, aber das ist noch nicht sichtbar und fuer den speziellen Fall des PRT_ART noch nicht gezeigt."

### §5.27.1 IPermutationEngine als zentrale Permutations-Steuerung

```
CacheEngineBuilder
    |
    | konfiguriert + startet
    v
IPermutationEngine
    |  steuert Permutationen ueber:
    |   - 4-Ebenen-Strategien (S1-S30 in K06)
    |   - 12 Sub-Engine-Familien (C1-C12 in K15)
    |   - Engine-Choice-Varianten V1-V4 (K03)
    |   - PRT-ART-spezifische Erweiterungen (D10-D13 unten)
    v
ISearchEngine-Permutation N        ISearchEngine-Permutation M       ... (alle Cross-Tupel)
```

### §5.27.2 PRT-ART als experimentelle Permutations-Erweiterung pro Baustein-Familie

PRT-ART liefert je **Suchalgorithmus-Baustein-Familie** experimentelle Optionen, die im selben Permutations-Setup wie die existierenden Stand-der-Technik-Varianten getestet werden:

| Baustein-Familie | Cache-Engine generisch (Baseline) | PRT-ART-Erweiterung (zusaetzlich permutierbar) |
|------------------|------------------------------------|------------------------------------------------|
| **Node-Typen** | 6 Seitentypen aus §5.3 (Redirect/Dense/Multilevel/Sparse/Decision-Span/Custom) | + 2 PRT-ART-Node-Typen (PrtArtRedirectNode + PrtArtBPlusNode) |
| **B+-Internes Layout** | Existierende Algorithmus-Layouts (Node4/16/48/256, HOT-Compound, START-Multilevel, etc.) | + 4 PRT-ART-Suchtypen (Array[256] / Array[65535] / Vector<u8,u8> / Vector<u16,u16>) |
| **Allokator-Pools** | C6 generic Cache-Allocation-Engine (~17 Atoms) | + 4+2 PRT-ART-Pools mit Bucket-Vektor |
| **Adressierung** | Pointer-basiert (Default) | + Virtuelle Memory-Offset-Berechnung (TLB-inspired) |
| **Concurrency-Mechanik** | S30 (9 Atoms) + C4 generic | + OLC + reservierte Value-Bloecke fuer PRT-ART |
| **Serialisierung** | Generic Static/Dynamic | + Signaling-Bits-Sparse-Length-Serialisierung |
| **Iteratoren** | 3 Pflicht-Iteratoren (REV 5) | + Prefix-with-Flag fuer tuple<Key-Rest, Value> |

**Wichtige Pruefung:** Je Baustein-Familie muessen sowohl die **bestehenden 33-Paper-Varianten** als auch die **PRT-ART-Erweiterungen** als Permutations-Optionen aufschaltbar sein. Die `IPermutationEngine` ist agnostisch gegenueber der Quelle der Variante.

### §5.27.3 Permutations-Setup-Beispiel (Cross-Algorithmus)

Beispiel-Konfiguration einer F15-Cross-Permutation:

```
PermutationDescriptor = {
    Algorithm:       PRT-ART  (oder ART, HOT, START, B^2, etc.)
    Pattern (S):     S2 LayerMix
    Plural (S):      S23.AdaptiveRadixTree  (oder S22.CSBPlus / S23.HOT / etc.)
    Singular (S):    S27.SimdParallelKeyComparison-AVX2
    Heuristic:       AdaptivePrefetchDistanceHeuristic (P23 Khan)

    CacheFamily (C): C03 Prefetch
    CacheAtom:       JumpPointerArrayPrefetch (P21 Chen) -- oder PRT-ART-Suchtyp-Atom

    EngineChoice:    V3 INFORMED_KALIBRIERT

    PRT-ART-Spezifisch (NUR wenn Algorithm == PRT-ART):
      D10 Suchtyp-Reihenfolge: [A, C, B, D]  (Permutation)
      D11 Dichte-Schwellen:    {30%, 55%, 80%}  (kalibriert statt 25/50/75)
      D12 Fingerprint-Filter:  aktiv
      D13 Serialization:       DynamicSignalingBits
}
```

Die Cache-Engine permutiert systematisch ueber alle gueltigen Kombinationen — PRT-ART-spezifische Achsen D10-D13 sind nur fuer den PRT-ART-Algorithmus relevant, fuer alle anderen Algorithmen werden sie ignoriert.

---

## §5.28 NEU 2026-05-12 — CacheEngineBuilder Kompilations-Mechanismus + ABI-stabiles C++23-Modul-Interface

Diese Sektion praezisiert, wie der CacheEngineBuilder die zwei Saeulen permutiert + verbindet (User-Direktive 2026-05-12: "der CacheEngineBuilder kompiliert permutation-getriebene ExecutionEngines als Experimente und reicht ihnen ueber ein ABI-stabiles C++23-Modul-Interface die CacheEngine als Visitor-Pattern").

### §5.28.1 Permutations-Lebenszyklus pro Experiment

```
Phase 1 — ENUMERATION  (CacheEngineBuilder Master)
    |  Master enumeriert alle gueltigen PermutationDescriptors
    |  via IPermutationEngine (siehe §5.27)
    v
Phase 2 — COMPILE-TIME-CONFIG  (Saeule A komplett)
    |  Pro Permutation P_i wird ein ExecutionEngine-Build vorbereitet:
    |   - Template-Parameter setzen (z.B. SearchEngine<P_i.pattern, P_i.plural, P_i.singular, ...>)
    |   - PRT-ART-spezifisch: D10-D13 als Template-Parameter (Suchtyp-Reihenfolge, Schwellen, Fingerprint, Serializer)
    |   - Algorithmus-Baseline-Wahl: PRT-ART / ART / HOT / START / B^2 / CoCo / Masstree / Wormhole
    v
Phase 3 — COMPILE  (CacheEngineBuilder ruft CMake/Compiler)
    |  Pro Permutation entsteht eine eigene C++23-Modul-Binary:
    |   - SearchEngine vollstaendig Compile-Time-fixiert
    |   - ABI-stabiles Export-Interface fuer ICacheEngine* + Workload-Treiber
    v
Phase 4 — LINK + LOAD  (ABI-stabiler Modul-Bridge)
    |  Master ladet das Permutations-Modul + reicht ICacheEngine-Pointer
    |   ueber das ABI-stabile C++23-Modul-Interface hinein
    |  (das Modul ruft selbst nichts vom Master direkt - nur Visitor-Pattern)
    v
Phase 5 — EXECUTE  (Runtime-Anteil der CacheEngine)
    |  Die SearchEngine fuehrt Workload aus, ruft pro Op
    |  cache_engine.advise(RequestContext) ueber den Visitor-Pattern-Aufruf
    |  CacheEngine entscheidet Runtime ueber 12 Sub-Engines C1-C12 (siehe U09)
    v
Phase 6 — MEASURE  (CacheEngineBuilder misst aus)
    |  Master sammelt Throughput / Latency / CLU / Cache-Miss /
    |  Bandwidth / Coherence-Verkehr / Energie pro Permutations-Run
    |  via MeasurementBuffer + Disk-Dump (siehe §3 in 22_architektur_skizze_REV5)
    v
Phase 7 — TEARDOWN  (CacheEngineBuilder)
    |  Permutations-Modul wird entladen, naechste Permutation startet bei Phase 2
```

### §5.28.2 Die zwei Saeulen-Permutations-Charakteristik

| Saeule | Permutations-Zeitpunkt | Mechanismus | Begruendung |
|--------|------------------------|-------------|-------------|
| **Saeule A — ExecutionEngine/SearchEngine** | **KOMPLETT Compile-Time** | Template-Instantiation pro Permutation | Maximaler Inlining-Headroom, Dead-Code-Elimination, optimale CPU-Cache-Lokalitaet im Hot-Pfad. Saeule A muss "stark in Stein gemeisselt" sein, damit Saeule B sie aussen optimieren kann. |
| **Saeule B — CacheEngine** | **HYBRID Compile-Time + Runtime** | siehe naechste Tabelle | Saeule B braucht beides: harte Code-Pfade fuer Hot-Operations + adaptive Reaktion auf Live-Plattform-Zustand. |

### §5.28.3 CacheEngine HYBRID-Permutation (Compile-Time + Runtime)

**Compile-Time-Anteil der CacheEngine** (festgelegt im Permutations-Build):
- Welche der 12 Sub-Engine-Familien C1-C12 sind aktiv?
- Welches Atom innerhalb jeder Familie ist initial gewaehlt?
- ICacheStrategy-Variant (V1 BaseEngine / V2 Static / V3 Warmup / V4 Adaptive)
- Heuristik-Set (welche der ~80 IHeuristic-Konkretisierungen)
- Pipeline-Reihenfolge (deterministisch: C05->C10->C09->C01->C08->C06->C02->C07->C03->C04->C12->C11)
- ISA-Feature-Gate (per F-EXTRA-1 entweder zur CT pinniert oder per Runtime-Dispatch via F9)

**Runtime-Anteil der CacheEngine** (entscheidet sich erst pro Such-Algorithmus-Anfrage):
- `PressureState`-Klassifikation (Idle/Warmup/Saturated/CoherenceStorm/Recovery)
- Konkrete CacheRecommendation per `advise(RequestContext)`-Aufruf
- Sub-Engine-Reaktion auf Live-Counter (z.B. C05 Telemetry liest perf-counter, C09 Heuristik entscheidet)
- Adaptive Pinning (C02), Migration (C07), Prefetch-Distance (C03) basierend auf Live-Daten
- Mediator-Events zwischen Sub-Engines via `notify(SubEngineEvent)`

**F9-Architekturentscheidung Praezisierung 2026-05-12:**
F9 (`COMDARE_DETECTION_MODE = COMPILE_TIME | RUNTIME`) gilt **nur fuer die ISA-SIMD-Feature-Detection** (z.B. AVX-512 ja/nein). Die anderen Cache-Engine-Aspekte sind sowieso **hybrid**:
- CT: welche Atome verfuegbar sind + Pipeline-Reihenfolge
- RT: welches Atom JETZT aktiv ist (basierend auf PressureState)

### §5.28.4 ABI-stabiles C++23-Modul-Interface

Jede compilierte ExecutionEngine-Permutation exportiert ein **ABI-stabiles C-API** (das ueber C++23-Modul implementiert wird, aber als reine C-Schnittstelle erscheint):

```c
// extern "C" Exports der Permutations-Binary
struct ComdarePermutationModule_v1 {
    uint32_t abi_version;          // = 1
    uint64_t permutation_fingerprint;

    // Lebenszyklus
    void* (*create_instance)(comdare_cache_engine_v1* engine);
    void  (*destroy_instance)(void* instance);

    // Workload-Treiber (ruft intern die Search-Operations)
    void  (*run_workload)(void* instance,
                          const comdare_workload_descriptor_v1* workload,
                          comdare_measurement_record_v1* out_record);

    // Telemetry-Pulls vom CacheEngineBuilder waehrend Workload
    void  (*pull_live_counters)(void* instance, comdare_hw_counters_v1* out_counters);
};

// Master reicht die CacheEngine als Visitor hinein
struct comdare_cache_engine_v1 {
    uint32_t abi_version;          // = 1
    comdare_cache_recommendation_v1 (*advise)(void* engine_state,
                                              const comdare_request_context_v1* ctx);
    void (*notify)(void* engine_state, const comdare_sub_engine_event_v1* event);
    void (*snapshot)(void* engine_state, comdare_platform_snapshot_v1* out);
};
```

**Eigenschaften:**
- ABI-Versionierung (uint32_t abi_version) erlaubt parallelen Betrieb verschiedener Builder-Versionen
- POD-Structs (kein std::* in der ABI), Pointer-Adressen + Function-Pointer
- C++23-Module sind ein Compile-Time-Mechanismus; das ABI bleibt C
- Master und Modul koennen mit unterschiedlichen Compilern gebaut sein (F-EXTRA-1: Original-Bausteine mit Original-Compiler)
- Visitor-Pattern: das Modul ruft den `advise()`-Function-Pointer pro Op (gleicher Mechanismus wie U09 ICacheEngine.advise(RequestContext))

### §5.28.5 CacheEngineBuilder-Verantwortlichkeiten (Konsolidierung)

```
«concept» CacheEngineBuilder (siehe U10 + diese Sektion)
   ━━━━━━━ Phase 1 — ENUMERATION ━━━━━━━
   + enumerate_permutations() : list<PermutationDescriptor>
   ━━━━━━━ Phase 2-3 — COMPILE ━━━━━━━
   + compile_permutation(desc : PermutationDescriptor) : path-to-binary
       internally: generiert CMake-Targets pro Permutation, ruft cmake --build
       Resultat: comdare_perm_<fingerprint>.{dll, so, dylib}
   ━━━━━━━ Phase 4 — LINK + LOAD ━━━━━━━
   + load_permutation_module(path) : ComdarePermutationModule_v1*
       internally: dlopen / LoadLibrary
   ━━━━━━━ Phase 5 — EXECUTE ━━━━━━━
   + execute_one(module, workload) : MeasurementRecord
       internally: module->create_instance(cache_engine);
                   module->run_workload(instance, workload, &record);
                   module->destroy_instance(instance);
   ━━━━━━━ Phase 6 — MEASURE ━━━━━━━
   + collect_results() : MeasurementBuffer&
   ━━━━━━━ Phase 7 — TEARDOWN ━━━━━━━
   + unload_permutation_module(module) : void
```

### §5.28.6 Beziehung zu der bestehenden Planung

Diese Praezisierung ergaenzt:
- K03 §3.1+§3.2: Compile-Time-Wahl _ist_ jetzt der Standardweg fuer Saeule A
- K12 §12.2 Cross-Permutation: jede Cross-Permutation wird **als eigenes kompiliertes Modul** instanziiert
- U09 Visitor-Pattern: bleibt unveraendert; ICacheEngine.advise() ist die Runtime-Bruecke
- U10 IPermutationEngine: bleibt unveraendert; IPermutationEngine ist der Master-Enumerator
- Phase 4 + 7 in K11 Pipeline: Phase 4 = Modul kompilieren + laden, Phase 7 = im Modul ausfuehren

**KEINE bestehende Architektur wird widersprochen** — diese Sektion macht nur explizit, was vorher implizit war.

---

## 6. K06 / K10 / K15 — Unveraendert vs REV 5.3

Die Strategie-Familien-Taxonomien S1-S30 (K06) + F1-F29 (K10) + C1-C12 (K15) bleiben **unveraendert**. Sie definieren die **Vergleichs-Algorithmen (D14 Baselines)** und die **interne Cache-Engine-Struktur**.

Die PRT-ART-Praezisierungen in REV 6 betreffen **nur** den eigenen Algorithmus, nicht die Baseline-Sicht.

---

## 7. K12 PRAEZISIERT — D14 Baselines + 4 PRT-ART-Suchtypen als Permutationsdimension

§12.2 REV 5 wird erweitert um die **PRT-ART-interne Suchtyp-Reihenfolge** als **eigene Permutationsdimension**.

### 7.1 Permutationsdimensionen REV 6 (erweitert vs REV 5)

```
D1  Plattform                  : 9 Pflicht-Plattformen (Block AO)
D2  ISA                        : 5 Pflicht-Pfade (scalar / AVX2 / AVX-512 / NEON / SVE2)
D3  Core-Typ                   : 2 (P / E Cores) bei Hybrid-CPUs
D4  Cache-Engine-Modus         : 3 (passiv / Warmup / online-adaptiv)
D5  Search-Engine-Permutation  : Saeule-A-Tupel S-Familien (siehe K06)
D6  Cache-Family-Permutation   : Saeule-B-Tupel C-Familien (siehe K15)
D7  Engine-Choice (REV 5 K3)   : V1-V4 (Base + 3 CacheEngine-Modi)
D8  Workload-Family (Termin 6) : YCSB A-F + Pflicht-Korpora
D9  Workload-Operation         : Exact / Prefix / Range / Insert / Update / Delete / BulkBuild / Compact
D10 PRT-ART-Suchtyp-Reihenfolge (NEU REV 6 aus Frage 4)
     : Permutation der 4 internen Suchtypen-Auswahl-Reihenfolge:
       (A, B, C, D)  Standard-Reihenfolge
       (A, B, D, C)  Alternative
       (A, C, B, D)  Alternative
       (A, C, D, B)  Alternative
       (A, D, B, C)  Alternative
       (A, D, C, B)  Alternative
       => 6 Variant-Permutationen pro Knoten-Familie
D11 PRT-ART-Dichte-Schwellen   : Standard {25,50,75} oder kalibriert
D12 Fingerprint-Filter         : aktiv / inaktiv (Compile-Time)
D13 Serialization              : statisch / dynamisch (Compile-Time)
D14 Suchalgorithmus-Baseline   : PRT-ART / ART / HOT / Masstree / B^2-tree / CoCo-trie / START / Wormhole
```

### 7.2 F15-Forschungsmission (REV 6 unveraendert in Grundaussage)

PRT-ART vs. Baselines (D14) x Cache-Engine-Modi (D4+D7) x Plattform (D1) x ISA (D2) x Core-Typ (D3) x Workload (D8+D9), zusaetzlich pro PRT-ART-Konfiguration die Permutation der 4 Suchtypen (D10) und Dichte-Schwellen (D11).

---

## 8. Tab-Inventar REV 6 fuer drawio (KORRIGIERT 2026-05-12)

Bestehende 32 Tabs bleiben **UNVERAENDERT**. Die 8 NEUEN Tabs sind PRT-ART-spezifische Anhaenge, die die Cache-Engine-Universalitaet NICHT beeintraechtigen:

| Tab-ID | Status | Inhalt | Sicht |
|--------|--------|--------|-------|
| K01-K15 + K07a-d + K08a-d (32 Tabs) | **UNVERAENDERT** vs REV 5.3 | Cache-Engine-Universal-Sicht | universell |
| U01-U09 (9 Tabs) | **UNVERAENDERT** vs REV 5.3 | Cache-Engine-Universal-Sicht | universell |
| **K05b** | **NEU REV 6 (PRT-ART-Anhang)** | PRT-ART-spezifisch: 2 Node-Typen + Beziehung zu den 6 universellen Seitentypen aus §5.3 | PRT-ART-Erweiterung |
| **K05c** | **NEU REV 6 (PRT-ART-Anhang)** | PRT-ART-spezifisch: Virtuelle Memory-Offset-Adressierung (TLB-inspired) | PRT-ART-Erweiterung |
| **K05d** | **NEU REV 6 (PRT-ART-Anhang)** | PRT-ART-spezifisch: Linearer Value-Buffer + Lazy Deletion + Konsolidierung | PRT-ART-Erweiterung |
| **K05e** | **NEU REV 6 (PRT-ART-Anhang)** | PRT-ART-spezifisch: 4+2 Allokator-Pools + Bucket-Erweiterung (ergaenzt C6) | PRT-ART-Erweiterung |
| **K05f** | **NEU REV 6 (PRT-ART-Anhang)** | PRT-ART-spezifisch: Signaling-Bits-Serialisierung (ergaenzt C8) | PRT-ART-Erweiterung |
| **K05g** | **NEU REV 6 (PRT-ART-Anhang)** | PRT-ART-spezifisch: Multithreaded Read+Write (ergaenzt S30 + C4) | PRT-ART-Erweiterung |
| **K05h** | **NEU REV 6 (PRT-ART-Anhang)** | PRT-ART-spezifisch: 3 kanonische Fallbeispiele + Split-/Compaction-Logik | PRT-ART-Erweiterung |
| **U10** | **NEU REV 6 (PRT-ART-Anhang + IPermutationEngine)** | UML `comdare::prt_art<K, V, ...>` Template-Vollklasse + Beziehung zu IPermutationEngine + CacheEngineBuilder | PRT-ART-Erweiterung + Permutations-Steuerung |

**WICHTIG:** Die 8 PRT-ART-Anhang-Tabs ersetzen NICHTS aus den 32 universellen Tabs. Sie zeigen nur, **wie ein neuer Algorithmus** in das Framework integriert wird und welche **zusaetzlichen Permutations-Optionen** je Baustein-Familie er liefert.

**U10 wurde am 2026-05-12 erweitert** um die Beziehung zur `IPermutationEngine` und `CacheEngineBuilder` — das war zuvor nicht sichtbar gemacht (siehe §5.27).

---

## 9. Verzeichnis-Struktur fuer Migration (Vorbereitung Phase 6 Schritt a)

Im comdare-cache-engine Skelett werden die PRT-ART-spezifischen REV-6-Concepts unter `prt_art/include/prt_art/concepts/` abgelegt:

```
comdare-cache-engine/
└── prt_art/
    ├── include/prt_art/concepts/                          ← REV 5 Concepts
    │   ├── i_node.hpp                                     (Mikro-Verweis aus REV 5.1)
    │   ├── i_root_node.hpp
    │   ├── i_fanout.hpp
    │   ├── i_search_page.hpp                              (Knoten-Objekt)
    │   ├── i_search_page_structure.hpp                    (Strategy + Facade)
    │   ├── i_search_page_structure_interpreter.hpp        (Singleton)
    │   ├── i_cache_page.hpp                               (physische Page)
    │   ├── i_executing_engine.hpp
    │   ├── i_search_engine.hpp
    │   ├── value_handle.hpp
    │   └── prt_art/                                       ★ NEU REV 6
    │       ├── prt_art_node.hpp                           (PrtArtRedirectNode + PrtArtBPlusNode)
    │       ├── search_types/
    │       │   ├── search_type_a_array256.hpp             (NEU)
    │       │   ├── search_type_b_array65535.hpp           (NEU)
    │       │   ├── search_type_c_vector_u8.hpp            (NEU)
    │       │   └── search_type_d_vector_u16.hpp           (NEU)
    │       ├── density_threshold_policy.hpp               (NEU - 25/50/75)
    │       ├── virtual_offset_calculator.hpp              (NEU - TLB-inspired)
    │       ├── value_buffer.hpp                           (NEU - linear append)
    │       ├── allocator_pools.hpp                        (NEU - 4+2 Pools)
    │       ├── value_serializer.hpp                       (NEU - Signaling Bits)
    │       └── concurrency_manager.hpp                    (NEU - Multi-RW)
    ├── search_types/                                      ← echte Implementierungen
    │   ├── type_a/  (Array[256])
    │   ├── type_b/  (Array[65535])
    │   ├── type_c/  (Vector<u8,u8>)
    │   └── type_d/  (Vector<u16,u16>)
    ├── pools/                                             ← Allokator-Pool-Implementierungen
    │   ├── pool_a/  pool_b/  pool_c/  pool_d/  pool_r/  pool_v/
    ├── concurrency/                                       ← Multi-Reader/Writer
    ├── value_buffer/                                      ← linearer Buffer + Konsolidierung
    └── tests/                                             ← inkl. 3 Fallbeispiele
        ├── fall_1_hallo_halter.cpp
        ├── fall_2_ab_then_abc.cpp
        └── fall_3_haus_lookup_hafen.cpp
```

---

## 10. Naechste Schritte

1. **REV 6 Architekt-Freigabe**: User reviewed §5.2-§5.16 + neue K05b-h Tabs (in der drawio-Datei)
2. **drawio REV 6**: 8 neue Tabs (K05b-K05h + U10) zur bestehenden 32er-Datei hinzufuegen
3. **NACH Freigabe**: Migration in comdare-cache-engine (Schritt a):
   - Namespace-Refactor `prt_art::*` -> `comdare::*`
   - Header-Migration in `comdare-cache-engine/prt_art/include/...`
   - Multi-OS-CMake-Module migrieren
   - F-EXTRA-5 Fix
   - Tests migrieren
   - Diplomarbeit/code/ archivieren

---

## 11. Glossar-Update REV 6

| Begriff | Definition |
|---------|-----------|
| **PrtArtRedirectNode** | Komprimiert eindeutige Substrings, vermeidet Pointer-Chasing. Aus CoCo-trie-Idee. |
| **PrtArtBPlusNode** | Knoten mit einem von 4 internen Suchtypen, dynamisch wechselbar bei Dichte-Schwellen. |
| **Suchtyp A/B/C/D** | Die 4 internen Layout-Varianten eines B+-Knotens (siehe §5.8) |
| **Dichte-Schwelle 25/50/75** | Standard-Triggerpunkte fuer Suchtyp-Transition (kalibrierbar) |
| **Virtuelle Memory-Offset-Adressierung** | TLB-inspirierte Linear-Berechnung der Value-Position aus Key-Bytes |
| **Linearer Value-Buffer** | Append-only Speicherung der Values mit Lazy-Deletion und Re-Copy-Konsolidierung |
| **Pool A/B/C/D/R/V** | 6 (4+2) Allokator-Pools fuer perfektes Alignment pro Knotenfamilie und Values |
| **Signaling-Bits-Serialisierung** | 1+ser_length+payload Encoding fuer dynamisch grosse Values |
| **Fingerprint-Filter** | Optionaler Compile-Time-Vorfilter ueber Original-Keys |
| **Multi-Reader-Writer-Concurrency** | Parallele Reads (lock-free) + parallele Writes (auf disjunkten Node-Bereichen + reservierten Value-Bloecken) |

---

## ENDE REV 6

REV 6 ist eine **chirurgische Praezisierung** der PRT-ART-Sektion. Alle anderen Architektur-Aspekte bleiben gueltig wie in REV 5.3.

Wortzahl: ca. 3200.

**Aktion nach Freigabe:** 8 neue drawio-Tabs hinzufuegen (K05b-K05h + U10), dann Migration nach comdare-cache-engine (Schritt a).
