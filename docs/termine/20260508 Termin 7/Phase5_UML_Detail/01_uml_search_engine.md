# UML — Search Engine Klassen

**Bezug:** Bausteine_Matrix Achse 1-7 (Page / Node / Traversal / ValueHandle / MemoryLayout / Allocator / Prefetch). Achse 8 (Concurrency) und Achse 11 (Telemetry-Collection-Strategy) sind in `02_uml_cache_engine.md`. Achse 9 (ISA) in `04_uml_hardware_isa.md`. Achse 10 (Measurement) in `03_uml_measurement.md`.

**Wichtige ADR-Bezuege:**
- F-EXTRA-1: Bausteine-Internals mit Original-Compiler kompiliert; Concept-Interface in C++23
- F3 (Visitor mid-granularity): `visit(IPage*)`, `visit(INode*)` — keine ValueHandle/TraversalStep-Visit
- F8 (ValueHandle): `std::variant<...>` + Concept-Constraint, Algorithmus-spezifische Untermenge
- F-EXTRA-6: DecisionLambdaTrees PRO Baustein — keine globalen Default-Trees

---

## 1. Bausteine-Concept-Hierarchie (top-level)

```
<<concept>> Page<P>
<<concept>> Node<N>
<<concept>> TraversalAlgorithm<T>
<<concept>> ValueHandleStrategy<S, V>
<<concept>> MemoryLayout<L>
<<concept>> Allocator<A>
<<concept>> PrefetchStrategy<P>
```

Alle Concepts sind in `prt_art/concepts/<axe>.hpp` als C++23-Templates definiert. Jedes erfuellt:

```cpp
template<typename T>
concept Page = requires(T page) {
    { page.lookup(std::declval<KeyView>()) } -> std::same_as<LookupResult<T>>;
    { page.insert(std::declval<KeyView>(), std::declval<typename T::Value>()) } -> std::same_as<InsertResult>;
    { page.bytes() } -> std::convertible_to<std::span<std::byte const>>;
    typename T::Value;
    typename T::PageHeader;
};
```

(Analog fuer alle weiteren Concepts.)

---

## 2. Achse 1 — Page-Type (PageBank)

```
<<concept>> IPage<P>
   ^
   |____ implements
   |
+--+--+ ... (alle PAGE_*-Eintraege aus Bausteine_Matrix)
|     |
PAGE_DENSEBYTE_ART256        : ext/P01-ART/unodb/  (GCC 4.7+/10+)
PAGE_SPARSE_NODE4_ART        : ext/P01-ART/unodb/
PAGE_NODE16_ART              : ext/P01-ART/unodb/
PAGE_NODE48_ART              : ext/P01-ART/unodb/
PAGE_COMPOUND_HOT            : ext/P02-HOT/hot/   (GCC 5+, BMI2/AVX2)
PAGE_BPLUS_MASSTREE          : ext/P03-Masstree/masstree-beta/  (GCC 4.6+)
PAGE_MACRO_COCO              : ext/P04-CoCo-trie/CoCo-trie/  (GCC 11+, GPL-3.0 akademisch OK)
PAGE_MULTIBYTE_START         : ext/P05-START/START/  (GCC 7+)
PAGE_DECISION_B2TREE         : ext/P06-B2tree/b2-tree-master/  (GCC 9+)
PAGE_SPAN_B2TREE             : ext/P06-B2tree/b2-tree-master/
PAGE_METATRIEHT_WORMHOLE     : ext/P07-Wormhole/wormhole/  (GCC 7+, SSE4.2/CRC, GPL-3.0 akademisch OK)
PAGE_LOUDS_DENSE_SURF        : ext/P10-SuRF/SuRF/  (g++ -mpopcnt)
PAGE_LOUDS_SPARSE_SURF       : ext/P10-SuRF/SuRF/
PAGE_LOUDS_JACOBSON          : prt_art/legacy_reimpl/Jacobson-LOUDS/  (Konzept-Re-Impl. C++23)
PAGE_ADAPTIVE_BTREESAREBACK  : ext/P20-BTreesAreBack/leanstore/  (Konzept-Studie, zu viele Dependencies fuer Adapter)
PAGE_CSS_NODE                : prt_art/legacy_reimpl/P11-CSS-tree/
PAGE_CSB_NODEGROUP           : prt_art/legacy_reimpl/P12-CSB-tree/
PAGE_WIDER_HANKINS           : prt_art/legacy_reimpl/P13-Hankins/
PAGE_CONFIGTABLE_SAMUEL      : prt_art/legacy_reimpl/P14-Samuel/
PAGE_PREFETCH_CHEN           : prt_art/legacy_reimpl/P21-Chen-PrefetchBPlus/
PAGE_FRACTAL_CHEN            : prt_art/legacy_reimpl/P22-Chen-Fractal/

# BART-MASTER BONUS (P06b, F-EXTRA-1, akademisch OK):
PAGE_BART_HYBRID_P06         : ext/P06-B2tree/bart-master/bart.cpp           (GCC 9+)
PAGE_HATTRIE_P06             : ext/P06-B2tree/bart-master/hattrie.cpp        (GCC 9+)
PAGE_PBTREESTATIC_P06        : ext/P06-B2tree/bart-master/pbtreestatic.cpp   (GCC 9+)
PAGE_PBTREESTATIC_OPT_P06    : ext/P06-B2tree/bart-master/pbtreestatic_opt.cpp
PAGE_PBTREESTATIC_TRIE_P06   : ext/P06-B2tree/bart-master/pbtreestatic_trie.cpp
PAGE_PBTREESTATIC_ART_P06    : ext/P06-B2tree/bart-master/pbtreestaticart.cpp

# PRT-ART eigene Page-Familie:
PAGE_PRTART_DENSEBYTE        : prt_art/pages/dense_byte/        (C++23)
PAGE_PRTART_EXTENDEDDENSE    : prt_art/pages/extended_dense/
PAGE_PRTART_SPARSEPATRICIA   : prt_art/pages/sparse_patricia/
PAGE_PRTART_REDIRECT         : prt_art/pages/redirect/
PAGE_PRTART_CUSTOMCACHE      : prt_art/pages/custom_cache/
```

### Beispiel-Klasse: PAGE_DENSEBYTE_ART256

```
class Art256Page <<adapter>> {
    ' Wrapper um ext/P01-ART/unodb/ Node256-Implementation
    -- Attribute --
    - inner : unodb::node256*   ' Pointer ins Originalcode-Bauteil
    - parent_redirect : RedirectHandle
    -- Methoden (Page-Concept) --
    + lookup(key : KeyView) const : LookupResult<Art256Page> <<inline>>
    + insert(key : KeyView, value : Value) : InsertResult <<inline>>
    + bytes() const noexcept : span<byte const>
    + value_type() : type_info  ' fuer Reflection im Builder
    -- DecisionLambdaTrees (F-EXTRA-6) --
    + page_relocation_tree() : PageRelocationTree<Art256Page>&
    + page_type_change_tree() : PageTypeChangeTree<Art256Page>&  ' ART → Node48 bei Schrumpfung
    -- Constraints --
    inv: bytes().size() % CACHE_LINE_BYTES == 0   ' Alignment
    inv: parent_redirect.is_set() ⇒ inner != nullptr
}

Page <|.. Art256Page  ' implements
Art256Page o--> "1" unodb::node256  ' aggregation (Originalcode-Lebenszeit)
Art256Page *--> "1" PageRelocationTree  ' composition
Art256Page *--> "1" PageTypeChangeTree
```

(Analoge Diagramme fuer alle ~30 Page-Bausteine — fuer drawio-Tab "01 Page-Bausteine".)

---

## 3. Achse 2 — Node-Type (NodeBank)

```
<<concept>> INode<N>
   ^
   |
+--+--+ ... (alle NODE_*-Eintraege)
|     |
NODE_NODE4 / NODE_NODE16 / NODE_NODE48 / NODE_NODE256  (P01)
NODE_HOT_COMPOUND_K32 / NODE_HOT_BINODE  (P02)
NODE_INTERNAL_MASSTREE / NODE_BORDER_MASSTREE  (P03)
NODE_MACRONODE_COCO  (P04)
NODE_MULTIBYTE_START  (P05)
NODE_DECISION_B2TREE / NODE_SPAN_B2TREE  (P06a)
NODE_HATTRIE_HASHBUCKET_P06 / NODE_PBTREE_STATIC_NODE_P06 / NODE_BART_HYBRID_P06  (P06b)
NODE_CSS_NODE / NODE_CSB_NODEGROUP / NODE_WIDER_BPLUS_HANKINS  (P11/P12/P13)
NODE_PRTART_*  (PRT-ART eigen)
```

### Beispiel-Klasse: NODE_HOT_COMPOUND_K32

```
class HotCompoundNode <<adapter>> {
    -- Attribute --
    - bi_node_subtree : hot::commons::BiNode*    ' internal HOT Discriminative-Bits-Baum
    - node_type_tag : hot::commons::NodeType
    - partial_key_mapping : hot::commons::PartialKeyMappingBase*
    -- Methoden (Node-Concept) --
    + visit_each_child(visitor : auto&&) const : void
    + value_handle_for(byte : uint8_t) : ValueHandle <<inline>>
    + bytes() const noexcept : span<byte const>
    + load_factor() const : double
    -- ValueHandle-Selektion --
    + can_use_handle<HandleKind>() : constexpr bool
}

Node <|.. HotCompoundNode
HotCompoundNode o--> "1" hot::commons::BiNode  ' Bauteil (GCC 5+)
```

---

## 4. Achse 3 — Traversal (TraversalBank)

```
<<concept>> ITraversalAlgorithm<T>
   ^
   |
+--+--+ ...
|     |
TRAVERSAL_BYTEBYBYTE                    (P01) ' Path-Compression + Lazy Expansion
TRAVERSAL_DISCRIMINATIVE_BITS           (P02) ' BMI2 PEXT
TRAVERSAL_LAYER_SLICE                   (P03) ' 8-Byte-Slice an Layer-Grenze
TRAVERSAL_MACRO_NODE                    (P04) ' Macro-Node Pattern-Match
TRAVERSAL_MULTIBYTE_SPAN                (P05)
TRAVERSAL_EMBEDDED_DEC_TREE             (P06a)
TRAVERSAL_HATTRIE_HASH_THEN_TRIE_P06    (P06b) ' Hash-Bucket-Lookup an Blaettern
TRAVERSAL_PBTREE_STATIC_PREFETCH_P06    (P06b) ' Static-Layout-Walk mit Prefetch-Distanz
TRAVERSAL_BART_HYBRID_DISPATCH_P06      (P06b) ' Hybrid B-Tree/ART Dispatch
TRAVERSAL_HASH_ANCHOR                   (P07)  ' Triple-Layer (Hash → B+ → LinkedList)
TRAVERSAL_RANK_SELECT                   (P09/P10) ' SDSL/eigene rank/select
TRAVERSAL_LOWER_BOUND                   (P10)
TRAVERSAL_POINTER_ARITHMETIC            (P11 CSS)
TRAVERSAL_OFFSET                        (P12 CSB+)
TRAVERSAL_PREFETCH_AHEAD                (P21 Chen)
TRAVERSAL_ADAPTIVE_PREFETCH_DIST        (P23 Khan)
TRAVERSAL_PRTART_HOT_PATH               (PRT-ART eigen)
TRAVERSAL_PRTART_PREFETCH_AWARE         (PRT-ART eigen)
```

### Beispiel-Klasse: TRAVERSAL_ADAPTIVE_PREFETCH_DIST

```
class AdaptivePrefetchTraversal <<adaptive>> {
    -- Attribute --
    - prefetch_distance_limit : uint8_t = 64
    - hot_path_recognizer : HotPathRecognizer&
    - prefetch_decision_tree : PrefetchAdjustmentTree<AdaptivePrefetchTraversal>&
    -- Methoden (TraversalAlgorithm-Concept) --
    + traverse_to(key : KeyView, page : IPage&) : LookupResult <<inline>>
    + suggest_distance() const : uint8_t   ' adaptiv per DecisionTree
    -- Adaptive-Logik --
    - adjust_distance(observed_miss_rate : double) : void
    -- DecisionLambdaTrees (F-EXTRA-6) --
    + prefetch_adjustment_tree() : PrefetchAdjustmentTree&
    + hot_path_recognition_tree() : HotPathRecognitionTree&
}

ITraversalAlgorithm <|.. AdaptivePrefetchTraversal
AdaptivePrefetchTraversal *--> "1" PrefetchAdjustmentTree
AdaptivePrefetchTraversal *--> "1" HotPathRecognitionTree
AdaptivePrefetchTraversal o--> "1" HotPathRecognizer
```

---

## 5. Achse 4 — ValueHandle (F8 — `std::variant<...>` + Concept-Constraint)

```
<<concept>> IValueHandle<S, V>

# Konkrete Strategien (alle als Klassen):
VALUEHANDLE_INLINE          : prt_art/value_handles/inline/         ' Wert direkt im Node-Slot
VALUEHANDLE_POINTER         : prt_art/value_handles/pointer/        ' External Pointer
VALUEHANDLE_REDIRECT_TO_NODE: prt_art/value_handles/redirect_to_node/ ' Patricia-Style
VALUEHANDLE_REDIRECT_TO_PAGE: prt_art/value_handles/redirect_to_page/
VALUEHANDLE_DYNAMIC         : prt_art/value_handles/dynamic/        ' switch_array
```

```
class ValueHandle<Algo> <<variant>> {
    ' F8: std::variant<...> mit Concept-Constraint AllowedHandle<HandleKind, Algo>
    -- Attribute --
    - storage : variant<InlineHandle, PointerHandle, RedirectToNodeHandle, RedirectToPageHandle, DynamicHandle>
    -- Methoden --
    + visit(visitor : auto&&) const : auto
    + which() const noexcept : HandleKind
    -- Constraints --
    inv: requires AllowedHandle<which(), Algo>   ' Compile-Time-Validierung
}

class DynamicValueHandle <<switch_array>> {
    -- Attribute --
    - runtime_index : uint8_t
    - allowed_kinds : array<HandleKind, MAX_KINDS>   ' algorithmus-spezifische Untermenge
    -- Methoden --
    + select(kind : HandleKind) : ValueHandle
    -- Konzept-Bezug zu Glossar v6 BLOCK G --
}
```

---

## 6. Achse 5 — MemoryLayout (MemoryLayoutBank)

```
<<concept>> IMemoryLayout<L>
+--+--+ ...
|     |
MEMORY_CACHELINE_ALIGNED        ' default 64 B
MEMORY_HUGEPAGE_2MB_ALIGNED     ' P32-Lehre
MEMORY_HUGEPAGE_1GB_ALIGNED
MEMORY_POINTER_FREE_CONTIG      ' P11 CSS
MEMORY_SIBLING_CLUSTER          ' P12 CSB+
MEMORY_INLINE_SLOT
MEMORY_METADATA_HEADER          ' Telemetrie-Slots
MEMORY_EMBEDDED_TREE            ' P06 B²-tree
MEMORY_PROBABILITY_LAYOUT       ' P16 Bender
MEMORY_CACHE_OBLIVIOUS          ' P17 Bender
MEMORY_LAYOUT_INVARIANT         ' P19 Saikkonen
MEMORY_MULTI_LEVEL_RELOC        ' P18 Saikkonen
```

---

## 7. Achse 6 — Allocator (AllocatorBank)

```
<<concept>> IAllocator<A>
+--+--+ ...
|     |
ALLOCATOR_POOL_PER_PAGETYPE
ALLOCATOR_ARENA_PER_SUBTREE
ALLOCATOR_SLAB
ALLOCATOR_HBM                    ' P32/P33 — Plattform-spezifisch via Abstract Factory (F4)
ALLOCATOR_DEFAULT_MALLOC         ' Baseline
ALLOCATOR_TCMALLOC               ' Library-Wrapper
ALLOCATOR_MIMALLOC
ALLOCATOR_SNMALLOC
```

### F4 Abstract Factory fuer Plattform-Allocator

```
abstract class IPlatformAllocatorFactory <<abstract factory>> {
    + create_for_platform(probe : PlatformProbe&) : IAllocator&
}

IPlatformAllocatorFactory <|-- IntelHBMAllocatorFactory       ' hbwmalloc
IPlatformAllocatorFactory <|-- GraceHopperHBMAllocatorFactory ' CUDA/UCM-API
IPlatformAllocatorFactory <|-- StandardDIMMOnlyFactory        ' Fallback
IPlatformAllocatorFactory <|-- X3DAwareFactory                ' Ryzen 9950X3D V-Cache-CCD-Pinning (Block AO)
```

---

## 8. Achse 7 — Prefetch (PrefetchBank)

```
<<concept>> IPrefetchStrategy<P>
+--+--+ ...
|     |
PREFETCH_NONE                   ' Baseline
PREFETCH_SOFTWARE_FIXED         ' P21 Chen
PREFETCH_ADAPTIVE_DISTANCE      ' P23 Khan + DecisionTree
PREFETCH_HIERARCHICAL_BUNDLE    ' P27 Zhang ASPLOS
PREFETCH_FILL_BUFFER_AWARE      ' P25 Mahling — direkt einbindbar via F-EXTRA-1
PREFETCH_HOT_PATH               ' P26 Zhang FGCS — Read-Counter + HotPath-Detection
```

---

## 9. Komposition pro Algorithmus-Modul

Pro Permutation entsteht eine Modul-Klasse:

```
class PermutationModule<Page, Node, Trav, VH, Mem, Alloc, Pref, Conc, Isa>
    <<requires Compatible<Page, Node, Trav, VH, Mem, Alloc, Pref, Conc, Isa>>> {
    ' Compile-Time-Komposition aus 9 Bausteine-Achsen + ISA
    -- Attribute --
    - root_page : Page
    - allocator : Alloc&
    -- Methoden (std::map-aehnliches Public-Interface) --
    + lookup(key : KeyView) const : optional<Value>
    + insert(key : KeyView, value : Value) : InsertResult
    + erase(key : KeyView) : EraseResult
    + range_scan(begin : KeyView, end : KeyView) : RangeIterator
    -- Modul-Identitaet --
    + flags() : constexpr PermutationFlags   ' aus Flag_System.txt
    + identifier() : constexpr string_view   ' z.B. "PAGE_DENSEBYTE_ART256.NODE_NODE256.TRAVERSAL_BYTEBYBYTE..."
    -- DecisionLambdaTrees (Composition aus den Bausteinen) --
    + decision_trees() : PermutationDecisionTreeBundle  ' Vereinigung der Trees
}

PermutationModule <|.. ICacheAwareSearchAlgorithm   ' Final-Concept
```

---

## 10. Aussichten REV 2

Die Klassendiagramme oben sind die textuelle Vorbereitung der drawio-Diagramme fuer Tab "01 Search Engine". Das eigentliche drawio enthaelt:
- pro Achse einen Sub-Tab mit allen ~20-30 Bausteinen
- Farbcodierung nach Quelle (Originalcode = blau, LEGACY_REIMPL = orange, PRT-ART eigen = gruen)
- Compiler-Annotation pro Bauteil (F-EXTRA-1)
- Lizenz-Annotation (Architekt-Direktive 2026-05-08)
