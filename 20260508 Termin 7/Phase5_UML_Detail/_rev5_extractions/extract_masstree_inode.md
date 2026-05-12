# Masstree INode-Konzept - Korrektur fuer REV5 UML

**Datum:** 2026-05-11
**Quellen:**
- Originalcode P03 Masstree (Mao/Kohler/Morris EuroSys 2012) unter
  `Forschungsarbeiten/code/P03-Masstree/masstree-beta/` (Header `masstree.hh`,
  `masstree_struct.hh`, `kpermuter.hh`, `string_slice.hh`, `masstree_key.hh`)
- `_paper_extractions/cluster_B_hybrid_bplus.md` Abschnitt P03
- Paper-PDF nur als Image-PDF zugaenglich -> Code + Cluster-B-Notizen sind
  primaere Quelle, abgesichert durch B+/Cache-Layout-Standardliteratur

**User-Korrektur 2026-05-11:**
> "Eine INode ist laut Masstree eine einzelne Repraesentation eines Mikro-Verweises auf
> weitere Nodes auf SearchPages, also ein Speichereintrag in einer Liste eines Fanouts
> fuer die Weiterleitung an eine weitere Referenz oder das Value-Ziel eines keys.
> Jeder Fanout hat zwar INodes, aber diese befinden sich auf ISearchPages,
> daher eine physische Cache Verteilung auf mehreren ISearchPages.
> Jede ICachePage hat also multiple ganze oder im schlimmsten Fall auch
> fragmentierte INodes."

Diese Aussage ist mit dem Masstree-Quellcode KOMPATIBEL, sobald man die
Masstree-Begriffe sauber auf die REV5-Konzepte abbildet. Die bisherige
REV5-Skizze (`22_architektur_skizze_REV5_2026_05_11.md` Z. 84-91) hatte
"INode" als generische "Verzweigungs-/Daten-Einheit" modelliert - das ist
zu grob und vermischt zwei Masstree-Begriffe (slot vs. node-objekt).
Der Bericht extrahiert die korrekte Granularitaet.

---

## A) Was ist in Masstree wirklich eine "Node"?

Im Masstree-Code sind ZWEI Granularitaeten zu unterscheiden:

### A.1 Die Knoten-Objekte (`internode<P>` und `leaf<P>`)

Quelle: `masstree_struct.hh` Z. 99-192 (`internode`) und Z. 247-538 (`leaf`).
Beide erben von `node_base<P>` (Z. 41-97).

**`internode<P>`** (Interior-Node, Verzweigungsknoten zwischen Layern):
```cpp
uint8_t       nkeys_;                   //  1 B
uint32_t      height_;                  //  4 B
ikey_type     ikey0_[width];            //  width * 8 B (width=15 -> 120 B)
node_base<P>* child_[width + 1];        // (width+1) * 8 B (=128 B)
node_base<P>* parent_;                  //  8 B
```
Header (`nodeversion`) + obige Felder = ~256 B = **4 Cache-Lines** bei
64-Byte Lines (`prefetch()`-Schleife in Z. 149-152 prefetcht
`min(16*width+1, 4*64) = 256 B`).

**`leaf<P>`** (Border-Node, traegt Schluessel + Werte ODER Layer-Pointer):
```cpp
int8_t                     extrasize64_;
uint8_t                    modstate_;
uint8_t                    keylenx_[width];          // 15 B
permuter_type::storage_type permutation_;            // 8 B (kpermuter<15>::storage = uint64_t)
ikey_type                  ikey0_[width];            // 15 * 8 B = 120 B
leafvalue_type             lv_[width];               // 15 * 8 B = 120 B
external_ksuf_type*        ksuf_;                    // 8 B
union { leaf<P>* ptr; uintptr_t x; } next_;          // 8 B (B-link)
leaf<P>*                   prev_;                    // 8 B
node_base<P>*              parent_;                  // 8 B
phantom_epoch_type         phantom_epoch_[...];
internal_ksuf_type         iksuf_[0];                // optionaler Inline-Suffix-Bag
```
Allokation immer als Vielfaches von 64 B (Z. 289 `sz % 64 == 0`).

**Default `width = 15`** (Z. 29 in `masstree.hh`: `template <int LW = 15, int IW = LW>`).
Empirisch optimal laut Cluster-B-Notiz: 4 Cache-Lines = 256 B = Fanout 15.

### A.2 Die Slot-Eintraege INNERHALB eines Knotens

Innerhalb eines `leaf` gibt es `width = 15` parallele Slots (`ikey0_[i]`,
`keylenx_[i]`, `lv_[i]`). Jeder Slot ist ein **Mikro-Verweis**: er enthaelt
entweder einen Wert (`leafvalue.value`) oder einen Pointer auf den Root-Node
des naechsten Layers (`leafvalue.layer()`, Z. 228-230 in `masstree_struct.hh`),
oder einen Pointer in den Suffix-Bag (`ksuf_`).

Der `keylenx_[p]`-Wert (Z. 270, plus Konstanten Z. 261-262) entscheidet:
- `keylenx == ksuf_keylenx (=64)` -> Schluessel hat Suffix in `ksuf_`
- `keylenx == layer_keylenx (=128)` -> Slot zeigt auf den Root des
  next layer (8-Byte slice voll konsumiert, weiter im Sub-Trie)
- sonst: `keylenx in [0..ikey_size]` -> kompletter Schluessel passt in `ikey0_[p]`

**Genau dieser Slot ist die "INode" laut User-Korrektur**: ein Mikro-Verweis
in der Liste eines Fanouts, der ein Value oder eine weitere Referenz
adressiert.

---

## B) Was ist eine "Page" oder "Layer" in Masstree?

Masstree spricht NICHT von "Pages" im Disk-Sinn. Es gibt zwei Begriffe:

### B.1 Layer

Ein **Layer** ist ein eigener B+-Tree, der genau einen 8-Byte slice eines
Schluessels indiziert (Cluster B Z. 26: "Layer 0/Layer 1 ... jeder Layer
indexiert genau 8 Bytes (eine slice)"). Layer h ist verantwortlich fuer
Schluesselbytes [8h ... 8h+8). Wenn mehrere Schluessel in den ersten 8h+8
Bytes uebereinstimmen, wird ein neuer Layer h+1 erzeugt
(Border-Node-Slot wird mit `keylenx = layer_keylenx` markiert,
`leafvalue.layer()` zeigt auf den Wurzelknoten des Sub-Layers,
`make_layer_root()` Z. 79-82 in `masstree_struct.hh`).

### B.2 Knoten = Cache-bewusste Speichereinheit

Eine "Page" im Masstree-Sinn ist also der **Knoten** (`internode` oder
`leaf`). Jeder Knoten ist 256 B = 4 Cache-Lines gross (siehe A.1).
Cluster B Z. 17: "Vier Cache-Lines (256 Byte) ergeben den hoechsten
Durchsatz (Fanout 15) - empirisch verifiziert."

Knoten zu Layern:
- Ein Layer ist eine **Sammlung von Knoten** (Internodes + Leaves)
  in B+-Topologie mit doppelt verlinkten Leaves (B-link-Tree-Variante,
  `next_`/`prev_` in `leaf`).
- Layer-Wurzel: ein `node_base` mit `is_root() == true`
  (`make_layer_root()` setzt `parent = nullptr` und `mark_root()`).

---

## C) Was ist der "Fanout"?

Der **Fanout** in Masstree ist der **Verzweigungsfaktor pro Knoten**:
`width = 15` (Default-Template-Parameter). Pro `internode`:
- 15 Splitter-Schluessel
- 16 Child-Pointer
Pro `leaf`:
- 15 Schluessel-Slots (ikey + keylenx + leafvalue)
- 1 Permutation-Wort (16 4-Bit-Indizes + 4-Bit nkeys = 64 Bit)

Container fuer den Fanout = der Knoten-Heap-Block selbst (kontiguierlich
allokiert). Strategie: Slots sind **physisch unsortiert**, die logische
Sortierung steckt in `permutation_` (Indirection-Vektor).

---

## D) Mapping Node -> Page -> Cache-Line

```
Logische Ebene                  Speicher-Ebene                Cache-Ebene
+------------------+            +------------------+          +-----------+
| Layer (B+-Tree)  |            |                  |          |           |
|  +------------+  |   1:1      |  Knoten-Block    |   1:N    | 4 Cache-  |
|  | internode  |--+----------->|  (256 B aligned, |--------->| Lines     |
|  | / leaf     |  |            |   pool_allocate) |          | je 64 B   |
|  +------------+  |            +------------------+          +-----------+
+------------------+
        |                                |
        | enthaelt                       | 16 B Header + 15 Slots
        v                                v
   15 Slots (Mikro-Verweise)         physisch verteilt ueber 4 Lines:
                                       Line 0: nodeversion + permutation + ikey0_[0..3]
                                       Line 1: ikey0_[4..11]
                                       Line 2: ikey0_[12..14] + lv_[0..4]
                                       Line 3: lv_[5..14] + next_/prev_/parent_
```

`prefetch()`-Schleife (Z. 461-468 fuer leaf): laedt alle 4 Lines parallel
(`for i = 64; i < 256; i += 64`). Dadurch ueberlappen DRAM-Latenzen.

**Bei Suffix-Externalisierung** (`ksuf_` extern statt inline): zusaetzliche
Cache-Lines werden geprefetcht (Z. 466-468).

---

## E) Permutation-Field-Konzept (16 x 4-Bit-Slots)

Quelle: `kpermuter.hh` Z. 41-105.

Bei `width = 15` wird `sized_kpermuter_info<2>` aktiviert
(Z. 52-57): `storage_type = uint64_t`, `value_type = uint64_t`,
`max_width = 15`.

```
64-Bit permutation_  =  [ idx[14] | idx[13] | ... | idx[1] | idx[0] | nkeys ]
                          4 Bit     4 Bit         4 Bit     4 Bit    4 Bit
                                                                     (low)
```
- `nkeys`: Anzahl belegter Slots (low 4 Bit, Z. 95-97).
- `idx[i]` (4 Bit): physischer Slot-Index, der an logischer Position i steht
  (Z. 103-105: `(x_ >> ((i << 2) + 4)) & 15`).

Initial-Layout (`make_empty()` Z. 78-81): `0x0123456789ABCDE0`
(noch keine logische Reihenfolge, freie Slots werden in dieser Reihenfolge
allokiert). `make_sorted(n)` (Z. 87-92): erzeugt Permutation [0..n-1] sortiert.

**Wozu?** Inserts/Deletes aendern NUR `permutation_` atomar (single 64-Bit
Write), die physikalischen Slot-Positionen werden NICHT verschoben. Dadurch
sind Reader lock-frei: sie lesen `permutation_` einmal, navigieren ueber die
Indirektion, und falls sich `permutation_` zwischendurch geaendert hat,
wiederholen sie ueber `nodeversion`.

**Wie passt das zu einer "INode"?**
- Eine logische Position 0..nkeys-1 entspricht einem **Slot-Index**.
- Der **Slot** (ikey0_[idx], keylenx_[idx], lv_[idx]) ist die "INode"
  (Mikro-Verweis).
- Die Permutation gibt eine **logische Reihenfolge** ueber die physischen
  Slots, ohne die Slots selbst zu verschieben.

---

## F) 8-Byte-Slices und ihre Arbeitsweise mit Nodes/Pages

Quelle: `string_slice.hh` Z. 25-80, `masstree_key.hh` Z. 36-77.

`string_slice<uint64_t>::make_comparable(s, len)` (Z. 63-65):
- Liest 8 Bytes aus dem Schluessel-Praefix.
- Wendet `net_to_host_order` an (Byte-Swap auf little-endian),
  damit der `uint64_t`-Vergleich lexikografisch korrekt ist.
- Cluster-B-Notiz: "improving performance by 13-19%" gegenueber `memcmp`.

`key<uint64_t>` (`masstree_key.hh` Z. 36-100):
- Haelt `ikey0_` (1x slice = 8 B) plus optional einen Suffix.
- `shift()` konsumiert 8 Bytes und ruft die slice der naechsten 8 Bytes
  ab -> Layer-Descent.

**Slice -> Node -> Cache-Line:**
- `ikey0_[p]` in `leaf<P>` ist genau eine 8-Byte-Slice = 1/8 einer Cache-Line.
- 15 ikeys = 120 B = ~2 Cache-Lines reine Schluesseldaten.
- Vergleich mit Suchschluessel-Slice = 1-Cycle-int-Compare (statt strncmp).

**8-Byte Slice operiert NICHT auf einer "Page", sondern auf einer Slot-Position
INNERHALB eines Knotens.** Pro Layer ist genau ein Slice in jedem Knoten
relevant (`internode::ikey0_[i]` als Splitter, `leaf::ikey0_[i]` als
Schluessel-Praefix dieses Layers).

---

## G) Korrekte Konzept-Modellierung fuer REV5-UML

### G.1 Mapping Masstree -> REV5

| Masstree-Begriff (Code/Paper) | REV5-Konzept | Multiplizitaet |
|---|---|---|
| Layer (B+-Tree pro 8-Byte slice) | ISearchPagesStrategy + ISearchPagesStrategyPattern | 1 pro IFanout-Ebene des Layers |
| `internode` / `leaf` (256 B Knoten-Objekt) | **ISearchPage** (logische Such-Seite) | N pro IFanout |
| Slot innerhalb leaf (1 Mikro-Verweis: ikey0_[i] + keylenx_[i] + lv_[i]) | **INode** (Mikro-Verweis) | 15 pro ISearchPage (=leaf) |
| Splitter-Slot innerhalb internode (ikey0_[i] + child_[i+1]) | **INode** (Mikro-Verweis) | 15 pro ISearchPage (=internode) |
| 256 B kontiguierlicher Heap-Block (4 Cache-Lines) | **ICachePage** (physische Speicher-Repraesentation) | 1 pro ISearchPage bei Aligned-Allokation; 2 wenn Knoten Cache-Line-Grenze ueberlappt (fragmentiert) |
| `permutation_` (Indirection) | ISearchPageStructure / ISearchPageStructureInterpreter (REV5 NEU) | 1 pro ISearchPage |
| `next_`/`prev_` B-link Pointer | INode-Sub-Variante "Sibling-Pointer" oder explizites IFanout-Sibling-Edge | 2 pro leaf |
| `child_[i+1]` in internode | INode-Sub-Variante "Child-Pointer" | 16 pro internode |
| `lv_.layer()` (Layer-Pointer im Border-Slot) | INode-Sub-Variante "Layer-Edge" - verbindet zwei IFanout-Instanzen | 0..15 pro leaf |

### G.2 Korrekte Concept-Definitionen (REV5.1)

```
«concept» IFanout<F>                    (Verzweigungs-Abstraktion)
   composes [N] ISearchPage  via «contains»
   has EXACTLY 1 ISearchPagesStrategy
   has EXACTLY 1 ISearchPagesStrategyPattern
   // GEAENDERT: kein direktes "composes [N] INode" mehr - INodes sitzen
   // ausschliesslich AUF ISearchPages.

«concept» ISearchPage<S>                (logische Such-Seite = Knoten-Objekt)
   contains [W] INode                   // W = Fanout-Width (15 bei Masstree)
   has EXACTLY 1 ISearchPageStructure   // z.B. PermutationField bei Masstree
   has EXACTLY 1 ISearchPageStructureInterpreter
   mapped onto [1..K] ICachePage  via «ICacheStrategy»
   // K = 1 wenn ICachePage = Aligned-Block ueber alle 4 Cache-Lines des Knotens;
   // K > 1 wenn Knoten Cache-Page-Grenze ueberspannt (fragmentiert)

«concept» INode<N>                       (Mikro-Verweis = Slot-Eintrag)
   resides on EXACTLY 1 ISearchPage
   has 1 of {ValueRef, ChildRef, LayerRef, SiblingRef, SuffixRef}
   // Masstree-konkret: ValueRef = lv_.value, ChildRef = child_[i+1],
   // LayerRef = lv_.layer (Border-Slot mit keylenx==layer_keylenx),
   // SiblingRef = next_/prev_, SuffixRef = ksuf_ + offset
   addressed via permutation_index by ISearchPageStructureInterpreter
   // INode hat KEINE eigenstaendige Speicher-Adresse - es ist ein
   // logischer Eintrag in einer Slot-Liste der ISearchPage.

«concept» ICachePage<C>                  (physische Speicher-Repraesentation)
   has size = N x ICacheLine.size       // bei Masstree N=4 (256 B)
   carries [0..M] INode (ganz oder fragmentiert)
   carries [0..K] ISearchPage            // typischerweise K=1 wenn Page-aligned
   // Aussage User: "multiple ganze oder im schlimmsten Fall auch
   // fragmentierte INodes" - eine ICachePage kann mehrere INodes
   // VOLLSTAENDIG enthalten oder eine INode an Cache-Line-Grenze splitten.
```

### G.3 Verbindungs-Diagramm

```
                          IFanout
                         /   |    \
                        /    |     \
                contains    has   has
                       /      |     \
                      v       |      v
              [N] ISearchPage |     ISearchPagesStrategy/Pattern
                  /  |  \     |
        contains/  has \      |
              /    has  \     |
             v      |    \    v
         [W] INode  |   ISearchPageStructure (Permutation-Indirection)
                    |
                    | mapped via ICacheStrategy
                    v
              [1..K] ICachePage  ----> [N] ICacheLine
                    ^
                    |
         physisch gespeichert
                    |
              [0..M] INode (ganz oder fragmentiert)
```

**Zentrale Korrekturen gegenueber bisheriger REV5-Skizze:**

1. INode wird NICHT direkt vom IFanout "composed" - das war zu grob.
   IFanout enthaelt ISearchPages, ISearchPages enthalten INodes.
2. INode hat KEINE eigenstaendige Speicher-Identitaet - es ist ein
   **Slot-Eintrag** auf einer ISearchPage.
3. ICachePage und ISearchPage sind verschiedene Granularitaeten:
   ISearchPage = logischer Knoten (256 B in Masstree),
   ICachePage = physische Cache-Page-Einheit (typisch 64 B = 1 Cache-Line,
   kann aber auch eine Speicher-Page = 4096 B sein, je nach Mapping).
4. Eine INode kann an einer ICachePage-Grenze fragmentiert werden
   (User-Aussage). Der Cache-Strategy-Visitor muss dies erkennen
   und ggf. mehrere ICachePages prefetchen.
5. INode-Subtypen sollten in der UML als Tagged Union oder
   Enum-Discriminator modelliert werden (Masstree nutzt `keylenx` als
   Discriminator), nicht als 5 disjunkte Concept-Klassen.

---

## H) Ableitung aus B+-Tree- und Cache-Layout-Theorie

Da das Masstree-PDF nur als Image-PDF vorlag, wurde die Modellierung
gegen Standard-Literatur abgesichert:

### H.1 B+-Tree-Standard (Cluster B P11/P12/P13)

- Klassischer B+-Tree-Knoten hat **Slots** (Eintraege) mit Schluessel
  und entweder Wert (im Leaf) oder Child-Pointer (im Internode).
- Slot = "Mikro-Verweis" (User-Terminologie) = INode (REV5).
- Knoten = "Page" im Datenbank-Sinn (P11 CSS-Tree: cache-line-sized;
  P12 CSB+-Tree: cache-line-sized mit firstChild-Pointer;
  P13: 256-512 B, multi-cache-line).
- Knoten = ISearchPage (REV5).

### H.2 Cache-Layout-Theorie (Cluster C P15/P16/P17)

- Eine ICachePage = "page" der CPU-Speicherhierarchie (64 B Cache-Line,
  4096 B virtuelle Speicher-Page, oder 2 MB Hugepage).
- Die ISearchPage (logischer Knoten) muss auf 1 oder mehrere
  ICachePages abgebildet werden (Page-Layout-Strategie ist Teil von
  ICacheStrategy).
- Bei aligned-Allokation: 1 ISearchPage = M ICachePages (Vielfaches).
- Bei nicht-aligned (z.B. nach Pool-Reuse): Slot kann
  Cache-Line-Grenze kreuzen -> "fragmentierte INode".

### H.3 Validierung gegen Code

Der Masstree-Code verwendet:
- `ti.pool_allocate(sizeof(internode<P>), ...)` (Z. 121) -> Pool sichert
  64-Byte-Alignment, aber die ISearchPage = 256 B passt in 4 aufeinander-
  folgende ICachePages (=Cache-Lines).
- `prefetch()` (Z. 149-152, 461-468) prefetcht alle 4 Lines parallel
  -> bestaetigt 1 ISearchPage = 4 ICachePages bei 64-B-Lines.
- `permutation_` als 64-Bit single-atomic Write -> bestaetigt INode-Slots
  als physisch fixiert, logisch ueber Indirection-Vector adressiert.

### H.4 Worst-Case Fragmentierung

Wenn eine ISearchPage NICHT 256-B-aligned ist (bei Embedded-Pages,
geshiftem Pool-Allocator, oder Custom-Memory-Region), kann eine 8-Byte-
Slice an einer 64-B-Cache-Line-Grenze gesplittet werden -> 2 ICachePage-
Loads fuer 1 INode-Lookup. Das ist die User-erwaehnte Worst-Case-
Fragmentierung. Eine korrekte ICacheStrategy modelliert diesen Fall
explizit (z.B. via Alignment-Constraint im Visitor).

---

## Aktionspunkte fuer REV5.1-UML-Korrektur

1. **K02 Korrektur:** INode-Definition in `22_architektur_skizze_REV5...md`
   Z. 84-86 ueberarbeiten - "Verzweigungs-/Daten-Einheit" -> "Mikro-Verweis
   (Slot-Eintrag) auf ISearchPage".
2. **IFanout-Komposition (Z. 79-83):** `composes [N] INode via contains`
   ENTFERNEN. INodes sind nur indirekt ueber ISearchPage erreichbar.
3. **ISearchPage (Z. 87-91):** Multiplizitaet `contains [N] INode` ->
   `contains [W] INode` mit W = Fanout-Width des Algorithmus.
4. **ICachePage (Z. 107-...):** Erweitern um `carries [0..M] INode (ganz
   oder fragmentiert)` und `carries [0..K] ISearchPage`.
5. **NEU U09:** ICacheEngine-Familien-UML muss
   Alignment-Constraints zwischen ISearchPage und ICachePage modellieren
   (Aligned/Unaligned als Strategy-Parameter).
6. **INode-Subtypen:** Als Tagged Union mit Discriminator (analog
   `keylenx_` in Masstree) modellieren - {ValueRef, ChildRef, LayerRef,
   SiblingRef, SuffixRef}.

---

**Wortzahl:** ~2050 Woerter (im Limit von 2500).
