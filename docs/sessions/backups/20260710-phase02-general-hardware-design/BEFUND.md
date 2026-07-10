# BEFUND — Phase 0.2 „general_hardware (12) verdrahten": Prämisse widerlegt, Design-Forks offen

> Deep-Research-Workflow wf_7bba0921 (2 Thesis-/Constraint-Reader → Design-Synthese → 2 adversariale Kritiker,
> beide **NEEDS-REVISION** inkl. golden-**BLOCKER**) + eigene Verifikation am Code (ce). Basis-Pfad
> `ce/ = Code/external/comdare-cache-engine/`. Rohdaten: `rohdaten/journal.jsonl`, `workflow-ergebnis.json`.

## Kernbefund (verifiziert)
Die Audit-Rahmung von Phase 0.2 — „memory_layout/node/allocator lesen `cache_line_size/numa/page` aus axis_12
**statt eigener cacheline-Unterachse**" — ist **so nicht umsetzbar** und teils **fehldiagnostiziert**:

1. **`cache_line_size()` in den Layout-Strategien ist KEIN HW-Deskriptor**, sondern **intrinsische
   Layout-Semantik**: `packed_bitmap → 8` (`axis_05_memory_layout_packed_bitmap.hpp:28`, „64 bit = 1 word"),
   `aos_strict → 1` (`..._aos_strict.hpp:28`, „strict packed, kein alignment"), `cache_line_aligned/soa/aosoa → 64`.
   Diese aus axis_12 (immer 64 auf x86) zu speisen würde die Layout-Bedeutungen von packed_bitmap/aos_strict
   **zerstören**. → Es gibt hier keine „duplizierte Hardware-64" zum Dedup.
2. **golden-BLOCKER:** `CacheLineAlignedMemoryLayout` (`..._cache_line_aligned.hpp:20`) ist eine **konkrete Klasse**
   in `AllLayouts = mp_list<CacheLineAlignedMemoryLayout, …>` (`..._registry.hpp:36`). Der Synthese-Vorschlag
   „Klassen-Template additiv um `class Hw = …` erweitern" bräche die Permutations-Enumeration →
   `permutation_axes.xml` / `golden_fullpilot_320_binary_ids.txt` gefährdet. (Ein defaulted Template-Param
   erhält Quellkompatibilität nur für eine bereits-Template-Entität; ein konkretes Permutations-Blatt zu
   templatisieren ist brechend.)
3. **axis_12 IST bereits konsumiert** — nur nicht von den Organen: `build_variant_definition.hpp:66` liest
   `HW::cache_line_size()`/`HW::numa_capable()` in den ABI-POD `BuildVariantDefinitionV1` (hw_cache_line/
   hw_numa_capable); zusätzlich als Build-Permutations-Achse (`topic_hardware_config_set.hpp:106`). Die HW-
   Wahrheit „Cache-Line = Kompilations-Input" (Thesis 02_fundamentals.tex:97-104) fließt also **schon** in die
   Binary — über den Build-Variant-Pfad, nicht die Organe. Die Organe nutzen korrekt intrinsische Layout-Werte
   + den `CacheLineConfig`-NTTP (die permutierbare **Mess-Achse = Thesis-Kern**, muss unangetastet bleiben).
4. **node** trägt `kLineBytes=64` (`layout_aware_store.hpp:64`, load-bearing Mess-Stride via
   `record_phys_bytes()`, `:93`, assert-relevant) zusätzlich zu `kChunkAlign=64` (`:360`). Umhängen an eine
   HW-Quelle koppelt **lebende Mess-Konstanten** — bewusster Entscheid, kein Literal-Dedup.
5. Datei-Topologie: `topics/memory_layout/axis_05_memory_layout/axis_05_memory_layout_cache_line_aligned.hpp`
   ist ein **6-Zeilen-Re-Export-Shim**; die einzige physische Definition liegt in `axes/layout/…`. (Die erste
   Ist-Verifikation hatte das invertiert; kein „Doppel-Kopie"-Problem.)

## Was Phase 0.2 WIRKLICH offen lässt (thesis-motiviert, aber under-specified)
Die einzige **legitime, noch fehlende** axis_12-Organ-Konsumption ist **NUMA/Page → allocator** (nicht
cache_line): `numa_capable` → NUMA-Origin-Policy (Thesis AA5/NUMAlloc, D_building_block_matrix.tex:295,318),
`memory_page_size`/`huge_page_capable` → Huge-Page-Pools + dTLB-Reach (02_fundamentals.tex:51-53). allocator
liest heute **gar nichts** davon → das wäre **NEU-Verdrahtung** (kein Literal-Ersatz), thesis-**motiviert** aber
**nicht wörtlich mandatiert**.

## Offene Design-Forks (Thesis schweigt → User-Entscheid)
- **F-A (Scope):** Phase 0.2 als „HW-Cache-Line fließt bereits via Build-Variant → nur Audit-/Doc-21-
  Fehldiagnose korrigieren" behandeln, ODER die neue NUMA/Page→allocator-Verdrahtung jetzt bauen (design-loaded)?
- **F-B (Feld-Verdrahtung, falls neu):** welche Organe konsumieren welche Felder (allocator numa/page sicher;
  node/layout page für dTLB-bewusste Knotengröße fraglich)? compile-time-gated (`numa_capable=false` →
  NUMA-Pinning wegkompiliert) vs. reine Varianten-Auswahl?
- **F-C (Mess-Achse, separat):** Werteset-Divergenz Thesis KF-5 `{32,64,128}` vs. Code `{B64,B128,B256}`; +
  Line-**Größe** vs. Knoten-**Breite-in-Cache-Lines** (FF2: 1 vs. 16) = vermutlich zwei getrennte Unterachsen.
  Berührt den Thesis-Kern (die unangetastete Permutations-Achse) → separat vom Verdrahtungs-Scope.

## Empfehlung
(1) Audit-/Doc-21-Fehldiagnose korrigieren (axis_12 IST via Build-Variant konsumiert; Organ-`cache_line_size()`
ist intrinsisch — NICHT aus axis_12 speisen). (2) Die NUMA/Page→allocator-Verdrahtung als **design-gated Slice**
parken bis F-A/F-B entschieden. (3) Bis dahin auf **Phase 0.3 (Allocator-Adapter / Hebel B)** vorziehen — die
klarere, mechanischere Utilization-Lücke (axis_06 `as_std_allocator`/`StdAllocatorAdapter` in die 11 Pools + 4
Shapes statt `std::allocator`, `tier_to_organ_mapping.hpp:46-115`).
