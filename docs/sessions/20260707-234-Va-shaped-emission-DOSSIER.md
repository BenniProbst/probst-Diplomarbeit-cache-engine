# DOSSIER 234-V-a — Shaped-Emission Mechanik + btree_order-Beweis (2026-07-07, default-OFF)

**Board:** Task #26 / #234-Rest (Strang B) · **User-GO 07.07.:** G-234V-a = Option A per-Source-Emission; G-234V-b = binary_id-Shape-Segment erlaubt (Pool-Familien, default-OFF) — das SEGMENT selbst ist 234-V-b-Scope (Rest-Familien + Kardinalitäts-Formalisierung). **Kadenz-Hinweis:** Codex-Impl nicht möglich (bwrap-Defekt, Memory) → manuell + adversarialer Review-Agent.

## 0. Ist-Stand (am aktiven Stand 655c0314 re-verifiziert, Tabu-Regel)
- `builder/codegen/adhoc_emitter.hpp:50-77` `adhoc_macro_args<C>()` webt NUR die 19 Slot-Typen; `render_adhoc_module_source` emittiert `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC(...)`. Kein Shape/BuildVariant.
- `abi/anatomy_module_abi_v1.hpp:47-82`: Basis-Makro instanziiert `SearchAlgorithmAbiAdapter<SearchAlgorithmAnatomy<C>>`; BUILDVARIANT-Präzedenz = benannte Args ZUERST, dann 19 variadisch (+ separates Inspection-Symbol).
- `anatomy/abi_adapter.hpp:156` `template <AnatomyConcept A> class SearchAlgorithmAbiAdapter final`; Naht `:1932-1948`: `pool_family_` + `container_algorithm_t` über EINARMIGES `organ_for_search_algo_t<SearchAlgo>` (`SearchAlgo = Composition::search_algo`, `:1911-1912`) → Pool-Pfad nimmt IMMER das Default-Organ.
- `axes/lookup/composable/tier_to_organ_mapping.hpp:44-57`: Shaped-Aliase existieren (`BTreeSearchOrganShaped<Shape>` u.a.), 0 Konsumenten.
- `experiment_tree/registry_to_axis_levels.hpp`: T22 `axis_btree_order::EnabledShapes` (+T23-T25) bereits als statische Baum-Ebenen registriert (Level-0/default-OFF) — der Baum ZÄHLT, materialisiert aber nicht (W1).
- Golden-Schutz: FullSourceCatalog OHNE Shape-Achse; Guards test_profile_roundtrip/test_axis_sweep_pilot; F1-Anker `BTreeSearchOrgan == BTreeSearchOrganShaped<BtreeOrderKt4>`.

## 1. Soll (Option A, additiv, golden-neutral)
1. **Neuer Sibling-Header** `axes/lookup/composable/organ_for_search_algo_shaped.hpp` (einarmige Naht UNANGETASTET):
   - Primär `organ_for_search_algo_shaped<S,Shape>::type = organ_for_search_algo_t<S>` (deckt Shape=void UND familienfremd — keine Scheinmultiplikation auf Typ-Ebene).
   - Partial-Spez. `<BTreeSearchAlgo, Shape>` → `BTreeSearchOrganShaped<Shape>`; Voll-Spez. `<BTreeSearchAlgo, void>` → einarmiger Default (Kt4-Anker). Rest-Familien = 234-V-b.
   - Self-proving static_asserts (void-Neutralität + Kt8-Selektion + fremde Familie → void).
2. **ABI-Makro** `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC_SHAPED(ShapeType, <19>)` in `anatomy_module_abi_v1.hpp` — SELBSTSTÄNDIG (4 Symbole dupliziert statt Basis-Makro-Refactor = null Risiko am Golden-Pfad); create nutzt `SearchAlgorithmAbiAdapter<Anatomy, ShapeType>`. KEIN 20. Slot; `organ_count()==19`, POD, MAJOR 4 unverändert.
3. **Adapter-Träger:** `template <AnatomyConcept A, class ShapeCarrier = void>`; Naht-Zeilen (`pool_family_`, `container_algorithm_t`) auf `organ_for_search_algo_shaped_t<SearchAlgo, ShapeCarrier>`. Default void ⇒ typ-identisch zu heute (byte-identisch, alle Bestands-Instanzen `Adapter<Anatomy>` unverändert gültig).
4. **Emitter:** `render_adhoc_module_source_shaped(idx, shape_fq, args)` (SHAPED-Makro, Shape ZUERST) + `emit_adhoc_modules_shaped<Engine, Shape>` mit Filter `organ_for_search_algo_t<typename C::search_algo> != void` (exakt die Adapter-Ableitung) → nur organ-backed Kompositionen erhalten Shaped-Quellen. Default-Pfad (`emit_adhoc_modules`, apps/main.cpp) UNVERÄNDERT = default-OFF.
5. **Beweis-Test** `tests/unit/test_234_va_shaped_adapter.cpp` (S7-2-Muster): (a) Trait-Asserts; (b) Adapter-Verhaltensbeweis Kt2-vs-Default: gleiche 15 Keys, `axis_stats[6][2]` (alloc_cnt) Kt2 > Default (Shape erreicht den Pool DURCH den Adapter); (c) Render-Text-Beweis (SHAPED-Makro + Shape-FQ; Default-Render unverändert ohne SHAPED); (d) Filter-Beweis: MiniEngine {BTree-Komposition, Array256-Komposition} → `emit_adhoc_modules_shaped` schreibt EXAKT 1 Datei (per-user tmp via comdare_test_tmp.hpp); (e) Neutralitäts-Guards (MAJOR 4, Snapshot 1416, Version 5) + golden-Regression via bestehender Suite.

## 2. Nicht-Ziele (V-b)
Rest-Familien-Spezialisierungen, binary_id-Shape-Segment + Inspection-Symbol, Baum→Emitter-Verdrahtung (Engine-Iteration über T22-Werte), Kardinalitäts-Formalisierung (S1/S2/S3-Kopplung).

## 3. Beweise vor Push
ce-Suite lokal: neuer Test + Regressionen (test_234_f1, test_s7_2, test_profile_roundtrip, test_axis_sweep_pilot, conformance) EXIT 0; clang-format 22.1.8; Mojibake 0; ce-Push erst nach Terminal der laufenden super-Welle (8207-Regel), dann ce-Pipeline strikt grün; super-Bump danach.
