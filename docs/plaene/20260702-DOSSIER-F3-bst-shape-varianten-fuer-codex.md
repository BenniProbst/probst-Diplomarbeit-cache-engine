# DOSSIER W2/F3 — BstShape-Varianten real: Index-Packing-Kapazitätsschutz + Konformität U32/U16

Du bist der IMPLEMENTIERUNGS-Agent. Implementiere GENAU diesen Increment im Arbeitsbaum. NICHT committen/pushen/
builden (kein lokaler Compiler; statisch prüfen). Abschlussbericht: Datei-Liste + je Baustein 1-2 Sätze + Risiken.

## 1) Repo/Stand/Kontext
Repo-Wurzel = Arbeitsverzeichnis (comdare-cache-engine, main, HEAD `f31a5c4`, sauber). C++23, GTest 1.15.2.
#234-K hat gelegt: `topics/nodes/axis_bst_shape/` (Strategien `BstPtrSizeT|BstPtrU32|BstPtrU16`, je
`index_type/kIndexBytes`); `TreeNodePoolStore` ist `template <typename Shape = BstPtrSizeT>` mit index_type
BEREITS VOLL verdrahtet (`axes/lookup/composable/tree_node_pool_store.hpp`: Node.left/right als index_type,
`kNilIndex = numeric_limits<index_type>::max()`, `kNil = size_t(kNilIndex)`, Accessor-Casts; Level-0 = size_t
identitätsäquivalent); Alias `BstTreeOrganShaped<Shape>` (`tier_to_organ_mapping.hpp:56`). Das BST-Traversal-Organ
(`tree_traversal_organ.hpp`, BSTTraversalOrgan) konsumiert nur die size_t-Außen-API + `Pool::kNil` — funktioniert
mit jedem Packing, WEIL kNil konsistent mitwandert. OFFEN: allocate_node hat KEINEN Kapazitätsschutz — bei U16
liefe Knoten-Index ≥65535 still in den Sentinel/Overflow (65535 == kNilIndex!). DAS ist der F3-Kern.

## 2) SOLL
### (A) `axes/lookup/composable/tree_node_pool_store.hpp` — Kapazitätsschutz in allocate_node
Im `else`-Zweig (Anhang, kein Free-List-Recycling) VOR dem push_back:
```cpp
// #234-F3 [[allocation-failure-exception]]: der Sentinel kNilIndex ist NIE ein gueltiger Knoten-Index —
// bei schmalem index_type (U16: max 65534 Knoten) ist Ueberlauf ein harter Fehler, kein stilles Wrappen.
if (idx >= static_cast<std::size_t>(kNilIndex))
    throw std::length_error("TreeNodePoolStore: index_type-Kapazitaet erschoepft (#234-F3)");
```
(`<stdexcept>` inkludieren; `idx = nodes_.size()` steht dort bereits. Free-List-Zweig braucht KEINEN Check —
recycelte Indizes waren schon gültig. allocate_node ist bereits als werfend dokumentiert/nicht-noexcept.)
Zusätzlich als Doku im Node-Kommentar: sizeof(Node) je Packing (size_t: 32 B; u32: 24 B; u16: 20→24 B mit
Padding — alignof(u64)-bedingt; der u16-Gewinn liegt im Index-Wertebereich, nicht im sizeof).
SONST NICHTS ändern (Level-0-Pfad bleibt byte-identisch; der Check feuert für size_t praktisch nie).

### (B) NEU `tests/unit/test_234_f3_bst_shape.cpp` (gtest; Oracle-Muster = test_188_4bb0_...)
1. **Konformität je Variante:** `BstTreeOrganShaped<BstPtrU32>` und `BstTreeOrganShaped<BstPtrU16>` paargenau
   gegen `std::map<uint64_t,uint64_t>`: gemischte insert/update/lookup/erase/clear, WEITE Keys inkl.
   {0,7,65535,65536,65537,1ull<<32,1ull<<40,UINT64_MAX} + random (U32: ≥5000 Keys; U16: ≤30000 Keys — Knoten-Zahl
   muss < 65535 bleiben; Keys selbst bleiben voll u64: das Packing betrifft NUR die internen Knoten-Indizes!);
   `for_each_record` exactly-once via seen-Set.
2. **Packing-static_asserts:** `sizeof`-Erwartungen je Node dokumentierend prüfen — über
   `TreeNodePoolStore<BstPtrU32>::index_type`==uint32_t etc.; falls die private Node nicht zugreifbar ist, NUR
   die index_type/kIndexBytes/kNil-Beziehungen asserten: `TreeNodePoolStore<BstPtrU16>::kNil ==
   static_cast<std::size_t>(std::numeric_limits<std::uint16_t>::max())`.
3. **U16-Überlauf-Test (der F3-Beweis):** `TreeNodePoolStore<BstPtrU16>` DIREKT (ohne Organ) mit
   `allocate_node(k,v)` bis exakt 65534 Knoten füllen (Schleife; das sind reine push_backs, schnell), dann
   `EXPECT_THROW(allocate_node(...), std::length_error)`. Danach `free_node` eines Index + erneutes
   allocate_node → OK (Free-List-Recycling funktioniert an der Kapazitätsgrenze).
4. **kNil-Konsistenz-Anker:** für U16-Store: frisch → `root() == TreeNodePoolStore<BstPtrU16>::kNil`; nach
   1 insert via Organ → root() != kNil; left/right des Wurzelknotens == kNil (Sentinel-Übersetzung wirkt).
5. **Level-0-Regressions-Anker:** `static_assert(std::is_same_v<BstTreeOrgan, BstTreeOrganShaped<BstPtrSizeT>>)`
   (zuerst prüfen; falls unwahr, Laufzeit-Äquivalenz).
6. Deutsche Banner, Task-Tag `#234-F3`.

## 3) Verbote/Constraints (STRIKT)
- NUR die 2 genannten Dateien. NICHT anfassen: CMakeLists (Root+tests — Registrierung macht der Integrator),
  .gitlab-ci.yml, modules/**, ext/**, cmake/**, tree_traversal_organ.hpp, composed_tree_search.hpp,
  tree_node_pool_concept.hpp, topics/** (Strategie-Header fertig), alle anderen Header/Tests.
- Level-0-Bit-Identität: der neue Check ändert für size_t-Shape kein beobachtbares Verhalten (Grenze 2^64-1).
- Store-Nutzung immer `TreeNodePoolStore<...>`/`BstTreeOrganShaped<...>`; Test flag-unabhängig kompilierbar.

## 4) DoD + Bericht
(A)-Diff minimal (Guard + include + Doku-Kommentar); (B) gtest-Suite `Comdare234F3BstShape` mit ≥5 TESTs.
Bericht: exakte Guard-Zeile + warum Free-List-Zweig ungeschützt bleiben darf; U16-Testlaufzeit-Einschätzung;
Risiken (falls eine angenommene API-Signatur abweicht — exakt benennen statt raten).
