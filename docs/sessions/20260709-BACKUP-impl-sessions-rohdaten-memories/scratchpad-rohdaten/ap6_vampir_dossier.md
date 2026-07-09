# DOSSIER P33-VAMPIR Nachbau (Option A) — VampirNfpAllocator (axis_06, golden-320-neutral, ABI-Major 4)

> **Für Codex** (`--sandbox workspace-write`, gpt-5.5, xhigh). EIN Agent, KEINE Sub-Agenten. Repo-Wurzel = `--cd`
> (comdare-cache-engine). **NICHT committen, KEINE git-Operationen.** Bei Unerfüllbarkeit: STOPP + §7.
> Quellen-Blueprint (bereits seziert, verbindlich): der Inhalt dieses Dossiers. Basis = ultracode-Dissect wf_5fcbf469.

## 1. Auftrag
Baue das EINZIGE faithful-baubare VAMPIR-Konzept — **Memory-Type-Virtualization** — als **neues axis_06-Allokator-Organ
`VampirNfpAllocator`** nach: ein polymorpher Allokator-Front, der Allokationen an einen NFP-getaggten Memory-Tier
(DRAM/HBM/NVRAM) routet, mit NFP-Descriptor als Metadatum. + 3 Wiring-Punkte (Default-OFF, golden-neutral) + ein
Konformitäts-Test + Aktualisierung des bestehenden `sota/vampir.profile.xml` (Marker zeigt nun auf das reale Organ).
**is_original=false.** Alles Übrige (Compensation/Scheduling/OS-Migration/Energy) = ehrliche Annotation, NICHT bauen.

## 2. HARTE Auflagen — Faithfulness/No-Fabrication (Verstoß = Abbruch + §7)
1. **KEINE FABRIKATION.** Das Poster (`docs/termine/20260508 Termin 7/_review/papers/_text/P33-VAMPIR-Berthold2023.txt`,
   1 S.) + Review (`.../P33-VAMPIR-Berthold2023.md`) liefern KEINE Kostenfunktion/Formel/Pseudocode. Der Allokator
   füllt die Interface-Slots NEUTRAL (Tier-Routing + NFP-Metadatum) — erfinde KEINE VAMPIR-spezifische Policy/Formel.
2. **NFP-Descriptor** = {bandwidth_class, latency_class, capacity}. **Energy WEGLASSEN** (cache-engine hat keinen
   Energie-Counter → wäre leeres Feld). NFP-Enumeration stammt NUR aus dem Review (`.md §4`), nicht aus dem Poster — im
   Header-Kommentar so vermerken.
3. **OUT-OF-SCOPE (annotieren im Header-Kommentar, NICHT bauen):** Compensation, transparent OS-Migration/Replacement,
   Pipeline-Orderings/Global-Schedule/Negotiation (Query-Scheduling), Energy-als-Metrik, laufende dynamische
   Re-Platzierung. Compensation/Migration NICHT auf die bestehende `axes/migration_policy/`-Achse umleiten.
4. **Begriffs-Ehrlichkeit:** „Micro-Allocators/Memory-Decorators" + „multidimensional" stehen NICHT in den VAMPIR-
   Quellen (grep-verifiziert 0 Treffer) — falls im Kommentar erwähnt, als *abgeleitete cache-engine-Pattern-Begriffe*
   kennzeichnen, NICHT als VAMPIR-Konzepte.
5. **is_original=false ZWINGEND:** KEIN `OriginalCodeMixin`, KEIN `COMDARE_*_IS_ORIGINAL_CODEGEN`-Gate, kein
   sha256_lock. Erbt `get_compiler()=="original"`/`is_original_module()==false` von AxisBase.
6. **NAMENSKOLLISION:** NICHT an `TelemetryVampirOtf2` (`baustein_variants.hpp:369`, „VAMPIR OTF2 trace") binden oder
   behaupten, die Engine „implementiere VAMPIR bereits". Anderer Gegenstand, nur Namensgleichheit.
7. **Metadaten** (für die Profil-Aktualisierung) NUR aus den Quellen: Titel „VAMPIR — Virtualized Non-Functional Memory
   Properties for Data-Pipeline Scheduling"; Autoren Lehner/Schirmeier/Habich (PIs) + Berthold/Schmidt (RAs); Venue
   „DFG SPP 2377, Phase-1-Kickoff POSTER"; Jahr 2023. **KEIN DOI erfinden, Poster NICHT zu Konferenz aufwerten.**

## 3. HARTE Auflagen — Golden-320-Neutralität + ABI (Verstoß = Abbruch)
1. **ABI-Major bleibt 4.** Organ nutzt den BESTEHENDEN `AllocationStatistics`-POD (7 Felder) als `snapshot_t` — KEIN
   neuer Observer-POD, KEINE Änderung an `COMDARE_ANATOMY_ABI_MAJOR`, extern-C, `kCompositionAxisNames`(19),
   AdHocComposition-Arität(==19).
2. **Allokator = GEPINNTE Achse (First-1, Index 0).** Der neue Typ wird an die `AllVendors`-mp_list angehängt
   (IRGENDWO AUSSER Index 0), Enable-Flag **Default-OFF**. Dadurch bleibt der golden-320-Katalog byte-identisch
   (P08/OLC- + AP-7/SwissTable-Präzedenz).
3. **TABU — NIE anfassen:** `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt`, `gen_golden_fullpilot.cpp`,
   `algorithm_profiles/permutation_axes.xml`-Enum, `source_catalog.hpp`-Katalog-Zahlen, `modules/**`, `ext/**`, der
   Index-0/First-N jeder Achse.

## 4. Kartierung (verifiziert — nutze GENAU diese Referenzen)
- **Organ-Interface (3 Concepts, alle Pflicht):** `concepts::AllocatorStrategy` + `concepts::CacheEnginePermutationStrategy`
  + `topics::AxisBaseConcept`. Enforced im CRTP-Base-Ctor + trailing static_asserts.
  Refs: `libs/cache_engine/axes/alloc/axis_06_allocator_strategy_base.hpp:57-101` (Base+Delegatoren, resource_ownership-Default :87);
  `concepts/axis_06_allocator_concept.hpp:75-86` (AllocatorStrategy: value_type/size_type/topic_tag, `void* allocate(size_t,size_t)`
  EXAKT void*, `deallocate(void*,size_t,size_t) noexcept`, operator==, copy_constructible, nothrow_destructible);
  `concepts/axis_06_allocator_cache_engine_permutation_concept.hpp:157-212` (axis_tag + family_id + 11 static-Properties + Legacy);
  `AllocationStatistics` 7-Feld-POD :55-63.
- **Vorlagen (LIES + spiegle):** `axis_06_allocator_pool_resource.hpp` (self-contained, kein vendor-HAVE-Gate, negative
  optional-Concept-static_asserts) + `axis_06_allocator_slab.hpp:84-131,195-200` (stats/observer-Wiring + trailing asserts)
  + `axis_06_allocator_exgen.hpp`. Subaxes: `axis_06_allocator_subaxes_aa1_to_aa7.hpp:30-90` (AA5=`allocation_policy_tag` passt
  für Tier-Routing).
- **3 Wiring-Punkte:** (1) `axis_06_allocator_registry.hpp:76-113` — `#include` + `VampirNfpAllocator` ans **ENDE** der
  `AllVendors`-mp_list; (2) `axis_06_allocator_flags.hpp.in:57-63` — `#cmakedefine01 COMDARE_AXIS_06_USE_VAMPIR_NFP` +
  `inline constexpr bool vampir_nfp_enabled = COMDARE_AXIS_06_USE_VAMPIR_NFP;`; (3) root `CMakeLists.txt` — `option(
  COMDARE_AXIS_06_ENABLE_VAMPIR_NFP ... OFF)` + `if()set(COMDARE_AXIS_06_USE_VAMPIR_NFP 1)else()...0` (self-contained-Muster
  wie POOL `:674-677`, KEIN COMDARE_HAVE-Gate) + Kürzel in die USE-foreach-Liste falls vorhanden.
- **family_id = 24 (A24, nächste freie).** axis_tag = `subaxes::allocation_policy_tag` (AA5, Tier-/Memory-Typ-Routing).
- **Tier-Modell existiert bereits:** `include/cache_engine/concepts/cache_recommendation.hpp:12-24`
  `MemoryAllocationHint::TierKind{Dram,Hbm,Nvram,VCache,PageCache,Heap}` — WIEDERVERWENDEN als NFP-Tier-Tag (nicht neu erfinden).
- **Golden-neutral-Präzedenz:** AP-7 `axis_03a_search_algo_swisstable.hpp` + `_registry.hpp:75-86` (End-Append+Default-OFF-
  Rationale) + Test `test_ap7_swisstable.cpp` (Vorlage für den Konformitätstest).
- **Profil:** `libs/cache_engine/algorithm_profiles/sota/vampir.profile.xml` (existiert, `pruefling_type="abstract"`, alle
  Achsen Baseline). SOTA-Achsen-Token-Konvention (Großbuchstaben): der Allokator-Token dort = `VAMPIR_NFP` (= flag_suffix).

## 5. Soll-Umsetzung
### 5.1 Neues Organ `libs/cache_engine/axes/alloc/axis_06_allocator_vampir_nfp.hpp`
CRTP `class VampirNfpAllocator : public AllocatorStrategyBase<VampirNfpAllocator>`, im Schema von `_pool_resource.hpp`.
Pflicht (aus §4): `enabled = flags::vampir_nfp_enabled`; `value_type=std::byte`; `size_type=std::size_t`;
`topic_tag=…AllocatorTopicTag`; `axis_tag=subaxes::allocation_policy_tag`; `family_id=std::integral_constant<int,24>`;
alle **11** static-Properties (`is_thread_safe/supports_pmr(true)/max_alignment/name()/family_name()/flag_suffix("VAMPIR_NFP")/
has_native_aligned_alloc/requires_explicit_init(false)/supports_numa_node_hint/supports_thread_local_cache/
progress_guarantee(Blocking)/requires_specialized_hardware(false)`); `operator==`; sized+aligned `allocate(size_t,size_t)`
(EXAKT `void*`) + `deallocate(void*,size_t,size_t) noexcept` mit stats_-Update + `observer_.notify(stats_)`; unter
`#ifdef COMDARE_CE_ENABLE_STATISTICS` den Mess-Block (`snapshot_t=AllocationStatistics`, `observer_t=MeasurableObserver<…>`,
`statistics()/snapshot()/reset()/observer()`); trailing `static_assert(AllocatorStrategy<…>)` + `static_assert(CacheEnginePermutationStrategy<…>)`.
**NFP-Substanz (faithful, neutral):** ein `enum class NfpTier` ODER Wiederverwendung von `MemoryAllocationHint::TierKind`
als `static constexpr` Tier-Ziel + NFP-Descriptor {bandwidth_class, latency_class, capacity} als static constexpr
Metadaten; `allocate` routet über eine `portable_aligned_alloc`-Basis (der Userspace-Analog der „Virtualisierung" — der
reale hardware-Tier-Bind DRAM/HBM ist Hardware-gegatet, im Kommentar als solches vermerkt). KEIN OriginalCodeMixin.
**Header-Kommentar-Block (Pflicht):** Quelle = P33-Poster+Review (kein Code/Pseudocode) → strukturelle Rekonstruktion
„wie beschrieben"; is_original=false; Scope = Memory-Type-Virtualization; OUT-OF-SCOPE-Liste (§2.3); Begriffs-Hinweis
(§2.4); Abgrenzung zu TelemetryVampirOtf2 (§2.6).
### 5.2 Wiring (§4, Default-OFF, END-Append)
Die 3 Punkte exakt nach POOL/SwissTable-Muster. Verifiziere nach dem Append, dass die First-N/Index-0-Semantik unberührt ist.
### 5.3 Konformitäts-Test `tests/unit/thesis_tiere/test_vampir_nfp_allocator.cpp` (+ `comdare_add_test`)
Nach Vorlage `test_ap7_swisstable.cpp`/allocator-Konformitätstests: instanziiert `VampirNfpAllocator` mit
`-DCOMDARE_AXIS_06_USE_VAMPIR_NFP=1`, treibt allocate/deallocate/reset + prüft die AllocationStatistics-Zählung +
die Concept-static_asserts (compile = konform). Registrierung in `tests/unit/CMakeLists.txt`.
### 5.4 Profil-Aktualisierung `sota/vampir.profile.xml` (ERWEITERN, nicht ersetzen)
`pruefling_type="abstract"` BLEIBT; ändere `<allocator>SYSTEM_MALLOC</allocator>` → `<allocator>VAMPIR_NFP</allocator>`
(Marker zeigt jetzt auf das REALE rekonstruierte Organ); erweitere den XML-Kommentar um „reales NFP-Virtualization-
Allokator-Organ (axis_06 VampirNfpAllocator, family A24, is_original=false); OUT-OF-SCOPE: Compensation/Scheduling/
OS-Migration/Energy". paper_ref P33 unverändert.

## 6. Verifikation (PFLICHT — Codex, literal)
- Baue das Organ + `test_vampir_nfp_allocator` mit `-DCOMDARE_AXIS_06_USE_VAMPIR_NFP=1` (cl/cmake, wie thesis_tiere-Tests)
  → literal `[ PASSED ]`; die 2 trailing static_asserts kompilieren = konform.
- Beweise golden-Neutralität: `git grep -c vampir_nfp golden_fullpilot_320_binary_ids.txt` == 0; die `AllVendors`-Änderung
  ist ein reiner End-Append; `COMDARE_ANATOMY_ABI_MAJOR` unverändert (4). (Falls `test_profile_roundtrip` lokal baubar:
  grün = 320 byte-identisch; sonst als CI-gedeckt vermerken.)
- `git status --short` zeigt NUR: neues `axis_06_allocator_vampir_nfp.hpp`, neues `test_vampir_nfp_allocator.cpp`,
  geänderte `registry.hpp`/`flags.hpp.in`/`CMakeLists.txt`/`tests/unit/CMakeLists.txt`/`sota/vampir.profile.xml`. Kein TABU.

## 7. Ausgabe an Claude
(a) Organ-Datei + Wiring-Diff (registry End-Append-Beleg) + Test + Profil-Diff; (b) Bestätigung: is_original=false,
kein OriginalCodeMixin, kein neuer POD/ABI-Bump (MAJOR 4), Default-OFF, golden-320-neutral (grep 0); (c) literales
PASSED des Konformitätstests; (d) Bestätigung KEINE Fabrikation (Energy weggelassen, keine erfundene Policy/DOI,
Begriffe korrekt annotiert, nicht an TelemetryVampirOtf2 gebunden); (e) etwaige STOPP-Punkte.
