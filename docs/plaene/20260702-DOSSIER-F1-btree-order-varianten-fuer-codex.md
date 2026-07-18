# DOSSIER W2/F1 — BtreeOrder-Varianten real: Shaped-Store-Konformität + Bit-Treue-Anker (Test-only-Increment)

Du bist der IMPLEMENTIERUNGS-Agent. Implementiere GENAU diesen Increment im Arbeitsbaum. NICHT committen/pushen/
builden (kein lokaler Compiler; statisch sorgfältig gegen die genannten Vorlagen prüfen). Abschlussbericht:
Datei-Liste + je Baustein 1-2 Sätze + Risiken/offene Fragen.

## 1) Repo/Stand/Kontext
Repo-Wurzel = Arbeitsverzeichnis (comdare-cache-engine, main, HEAD `f31a5c4`, sauber). C++23, Boost.MP11, GTest 1.15.2.
#234-K hat gelegt: `topics/nodes/axis_btree_order/` (Strategien `BtreeOrderKt2|Kt3|Kt4|Kt8|Kt16`, je
`kT/kMaxKeys/kMaxChildren`, Concept erzwingt kMaxKeys==2kT-1); `BTreeNodePoolStore` ist
`template <typename Shape = nodes::axis_btree_order::BtreeOrderKt4>` und liest kT AUS Shape
(`axes/lookup/composable/btree_node_pool_store.hpp:28-45`); `tier_to_organ_mapping.hpp:66`:
`BTreeSearchOrganShaped<Shape> = ComposedBTreeSearch<BTreeTraversalOrgan, BTreeNodePoolStore<Shape>>`.
Das Traversal-Organ (`btree_traversal_organ.hpp`) konsumiert kT/kMaxKeys BEREITS pool-generisch via `Pool::kT`
(:80/:138/:165/:195/:254) + `Pool::kMaxKeys` (:109/:281) — Split/Merge/Borrow variieren also automatisch mit.
⟹ F1 ist ein VERIFIKATIONS-Increment: EIN neuer Test, der die 4 Varianten-Shapes real beweist. KEINE Store-/Organ-Edits.

## 2) SOLL — genau EINE neue Datei
`tests/unit/test_234_f1_btree_order_shape.cpp` (gtest, Muster = `tests/unit/test_188_4bb0_pool_organ_wide_key_conformance.cpp`
für Oracle-Paargenauigkeit; Includes/Namespaces von dort übernehmen):
1. **Konformität je Variante:** für JEDE der 4 Varianten-Shapes {Kt2, Kt3, Kt8, Kt16} das Organ
   `lookup::composable::BTreeSearchOrganShaped<Shape>` DIREKT instanziieren (Typen existieren unabhängig von den
   CMake-Default-OFF-Flags — `enabled` filtert nur die Registry) und paargenau gegen `std::map<uint64_t,uint64_t>`
   treiben: gemischte insert/update/lookup/erase/clear-Sequenz (deterministischer mt19937_64-Seed) über WEITEN
   Key-Raum inkl. {0, 7, 65535, 65536, 65537, 1ull<<32, 1ull<<40, UINT64_MAX} + ≥5000 random-wide Keys.
   Nach jeder Phase: size()-Gleichheit + Stichproben-lookups + Voll-Iteration via `for_each_record` gegen das
   Oracle (exactly-once: seen-Set, keine Duplikate, keine Fremd-Keys — Muster 4bb0/4bbV).
2. **Struktur-Wirkungs-Beweis (die Achse GREIFT):** `static_assert(BTreeNodePoolStore<BtreeOrderKt2>::kMaxKeys == 3)`
   … Kt16 == 31; PLUS Laufzeit-Anker: gleiche 200-Key-Insert-Sequenz in Kt2- und Kt16-Store → unterschiedliche
   Baum-Topologie belegen (z.B. via kleinem Traversal: Wurzel-`node_n` oder Knoten-Zahl differiert — über die
   public Store-API `root()/node_n()/node_leaf()/node_child_at()` einen einfachen Knoten-Zähler rekursiv bauen,
   NUR im Test).
3. **Level-0-Regressions-Anker:** `BTreeSearchOrganShaped<BtreeOrderKt4>` verhält sich identisch zum Default-Alias
   `BTreeSearchOrgan` (gleiche Sequenz → gleiche size/lookups; `static_assert(std::is_same_v<BTreeSearchOrgan,
   BTreeSearchOrganShaped<BtreeOrderKt4>>)` — wenn wahr, genügt der static_assert allein; prüfe das zuerst).
4. Deutsche Banner-Kommentare im Nachbar-Stil, Task-Tag `#234-F1`.

## 3) Verbote/Constraints (STRIKT)
- NUR diese eine neue Test-Datei. NICHT anfassen: CMakeLists.txt (Root UND tests/unit — die Target-Registrierung
  macht der Integrator!), .gitlab-ci.yml, modules/**, ext/**, cmake/**, alle Header unter libs/** (auch nicht
  btree_node_pool_store/btree_traversal_organ/composed_btree_search — sie sind bereits korrekt), andere Tests.
- Store-Nutzung IMMER `BTreeNodePoolStore<Shape>` bzw. via `BTreeSearchOrganShaped<Shape>`-Alias (nie nackter Name).
- Keine RTTI/keine Runtime-Switches; Header-Pfade wie in 4bb0 (`axes/lookup/composable/...` + `topics/nodes/...`).
- Der Test muss in JEDER Flag-Konfiguration kompilieren+laufen (nicht von COMDARE_AXIS_BTREE_ORDER_ENABLE_* abhängen).

## 4) DoD + Bericht
Eine Datei, ~250-400 Zeilen, gtest-Suite `Comdare234F1BtreeOrderShape` mit ≥4 TESTs (je Variante Konformität;
Struktur-Beweis; Level-0-Anker). Bericht: welche kT-abgeleiteten Werte je Shape static-geprüft; wie der
Topologie-Beweis funktioniert; Risiken (v.a. falls `for_each_record` oder eine Store-API-Annahme nicht wie
beschrieben existiert — dann exakt benennen statt raten).
