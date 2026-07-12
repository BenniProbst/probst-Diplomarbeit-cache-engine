# DOSSIER — GO 3 / Task #5 „Hebel-A-Rest" (*_scan-Routing + 09b→Flag)

> **Auftrag:** Ledger §11-I Nr. 2 (Z.271): „**GO 3 FREIGEGEBEN** — #5 Hebel-A-Rest (*_scan-Routing): Design via
> Deep-Research-Dossier + autonome Umsetzung der saubersten Option." Task-#5-Kurzform: „*_scan-Routing
> korrumpiert Mess-Signale; 09b→Flag = Build-Infra."
> **Erstellt:** 2026-07-12, rein lesend (kein Commit). ce-Stand `f0f20acc`, Repo-Root
> `/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`, ce-Submodul `Code/external/comdare-cache-engine`.
> Alle Pfade unten relativ zum ce-Submodul, sofern nicht anders markiert.
> **Harte Grenzen (bindend):** compile-time-Metaprogrammierung, kein Runtime-Switch im Hot-Path
> ([[feedback_no_runtime_switch]], [[feedback_compile_time_only_no_runtime]]), CRTP+Concepts
> ([[feedback_crtp_concept_guard_mix_pattern]]), benannte Lehrbuch-Patterns
> ([[feedback_lehrbuch_design_patterns_only_zero_cost_metaprog]]); **TABU:** golden-320
> (`golden_fullpilot_320_binary_ids.txt`), POD-1416, ABI-MAJOR==4, `permutation_axes.xml`
> (`libs/cache_engine/algorithm_profiles/permutation_axes.xml`), Messdaten. Rahmung Doc 21:
> „CI grün + messfähig — nur punktuelle Refactorings" (`docs/architektur/21_...md:5-6`, super-Repo).

---

## 0. Executive Summary

Der „Hebel-A-Rest" zerfällt beweisbar in **drei Teilstücke** (Quelle: ce-Commit `8175c802`, Commit-Message
„Offener Folge-Slice: produktive Kopplung 09b-Achse -> ISA-Flag via isa_features.cmake; aarch64-NEON/
riscv-RVV-simd_field_sum; Routing der uebrigen *_scan-Kerne ueber isa"):

| # | Teilstück | Re-Diagnose | Dossier-Ergebnis |
|---|-----------|-------------|------------------|
| R1 | 09b-Achse → Compiler-ISA-Flag (Build-Verdrahtung) | „Build-Infra" — fehlt komplett (§2) | **BAUEN** (Empfehlung §4, Option 1) |
| R2 | Routing der übrigen `*_scan`-Kerne über `isa` | korrumpiert Mess-Signale (§1) | **NICHT bauen**; Reinheit kodifizieren (Option 1, Teil A2) |
| R3 | NEON/RVV-`simd_field_sum` | sauber, aber HW-/INFRA-gated (Doc 21 §F Z.223-224) | **dokumentierter Folge-Slice**, nicht Teil von GO 3 |

**Empfehlung (eine, sauberste):** Option 1 „Deklarations-Wahrheit + Mess-Kern-Reinheit" — (A1) die je Binary
DEKLARIERTE 09b-SIMD-Extension wird per additivem CMake-Helper + compile-time-Kohärenz-Guard an die real
kompilierte ISA-Stufe gekoppelt (Deklaration == Maschinencode, `static_assert`-erzwungen); (A2) die bewusste
Skalarität der `*_scan`-Mess-Kerne wird als stehende compile-time-Invariante kodifiziert (Striktheit-Guard-Muster,
Präzedenz Ledger §12 2026-07-08 „METAPROG-STRIKTHEITS-GUARD"). Golden/ABI/POD/permutation_axes bleiben
byte-unberührt; kein Mess-Signal ändert sich.

---

## 1. Befund (a): WELCHES *_scan-Routing korrumpiert WELCHE Mess-Signale WIE

### 1.1 Was die *_scan-Kerne sind und wo sie gemessen werden

Die `*_scan`-Kerne sind die **verhaltens-tragenden statischen Treibe-Ops** der Achsen-Strategien. Der
Mess-Aufrufer ist `SearchAlgorithmAbiAdapter::run_workload_segmented_v2` → `do_seg19`
(`libs/cache_engine/anatomy/abi_adapter.hpp:632-800`): **je Achse ein eigener steady_clock-Timer** —
„Je Achse ein eigener steady_clock-Timer, über die batches AUFSUMMIERT → echte per-Achsen-ns für T0..T18"
(`abi_adapter.hpp:528-530`). Die per-Achse-Attribution ist der Sinn des Segments-Splits.

Vollständige Kernel-Landkarte (Aufrufstellen in `do_seg19` + Definitionsorte):

| Slot | Achse | Kernel | Aufruf (abi_adapter.hpp) | Strategie-Definitionen (Beispiele) |
|------|-------|--------|--------------------------|-------------------------------------|
| T3 | path_compression | `path_descend_scan` | `:661-662` | `axes/path_compression/axis_02_path_compression_patricia.hpp:63` |
| T4 | node_type | `node_find_scan` | `:676` | `axes/node/axis_04_node_type_node4.hpp:38`, `node16.hpp:36`, `node48.hpp:37`, `node256.hpp:36` |
| T5 | memory_layout | `scan_field_sum` | `:681` | s. 1.2 |
| T7 | prefetch (Re-Scan) | `scan_field_sum` | `:717-718` | wie T5 („Re-Scan: Prefetch-Hint-Wirkung auf den Layout-Scan") |
| T9 | serialization | `serialize_scan` | `:741` | `axes/serialization_axis/axis_10_serialization_var_len.hpp:38-53` |
| T11 | value_handle | `value_access_scan` | `:758` | `axes/value_handle_axis/axis_14_value_handle_inline.hpp:40`, `chain_ref.hpp:47` |
| T12 | **isa (eigene Achse)** | `simd_field_sum` | `:764` | `axes/simd/axis_09_isa_amd64.hpp:83-131` (Phase 0.1 ✅) |
| T13 | index_organization | `index_org_scan` | `:769` | `axes/index_organization/axis_01_index_organization_non_clustered.hpp:45` |
| T14 | io_dispatch | `io_dispatch_scan` | `:774` | `axes/io_dispatch/axis_io_mmap.hpp:44`, `buffered.hpp:43`, `direct.hpp:44` |
| T15 | migration_policy | `migration_decide_scan` | `:779` | `axes/migration_policy/axis_migration_hot_cold.hpp:42`, `tier_based.hpp:42`, `none.hpp:39` |
| T16 | filter | `filter_probe_scan` | `:784` | `axes/filter_axis/axis_filter_bloom.hpp:100`, `xor.hpp:105`, `range_surf.hpp:116` |

Zusätzlich treiben `run_workload`/`run_workload_segmented` (4-Segment-Variante) `scan_field_sum` (Seg 3) und
`serialize_scan` (Seg 4): `abi_adapter.hpp:421/425/502/504`.

### 1.2 Das Signal IST das Zugriffsmuster — der Beleg am Layout-Beispiel

Der Layout-Puffer ist absichtlich auf **kRecordSize=48** kalibriert, damit die Strategien im STRIDE divergieren
(LAYOUT-FIX X-§4): „kRecordSize=48 (NICHT 64) — sonst fiele cache_line_aligned (aligned_stride=round_up(48,64)=64)
mit aos_strict (Stride 48) zusammen und die Layout-Achse differenzierte nicht" (`abi_adapter.hpp:380-389`).
Die fünf Kernel-Varianten (alle skalar, `std::memcpy` je Feld):

- `aos_strict`: Stride = `record_size` (48) — `axes/layout/axis_05_memory_layout_aos_strict.hpp:45-54` („AoS: strided").
- `cache_line_aligned`: Stride = `round_up(record_size,64)` = 64 — `axis_05_memory_layout_cache_line_aligned.hpp:52-63`.
- `soa`: Stride = 4 B kontiguierlich — `axis_05_memory_layout_soa.hpp:48-57` („SoA: contiguous").
- `packed_bitmap`: Stride = 2 B kontiguierlich — `axis_05_memory_layout_packed_bitmap.hpp:48-57`.
- `aosoa`: Block-Layout `block*block_stride + within*4` — `axis_05_memory_layout_aosoa.hpp:64-76`.

Das Wall-Clock-Differenzsignal T5 entsteht AUSSCHLIESSLICH aus diesen Adress-Strömen (Cache-Lines je Record:
CLA 1,0 vs. aos_strict 0,75 vs. SoA 1/16). Genau das dokumentiert die Observable-Hülle: „Die Layout-Achse misst
Cache-Effekte des Zugriffs-Patterns […] der reine Latenz-Unterschied der Patterns bleibt der Wall-Clock-Messung
vorbehalten" (`axes/layout/axis_05_memory_layout_observable.hpp:10-14`). Analog ist T9 ein reines
CPU-Kosten-Ordnungssignal („raw=Byte-Sum < compressed=Delta+Zigzag < var_len=LEB128 < succinct=Bit-Packing",
`abi_adapter.hpp:423-424`; LEB128+FNV-Schleife `axis_10_serialization_var_len.hpp:38-53`), T4 ein
ART-Format-divergenter, order-sensitiver Probe-Scan (`abi_adapter.hpp:674`), T16 eine Filter-Proben-Kostenkurve.

### 1.3 Die Korruptions-Mechanik (vier Vektoren)

Würden diese Kerne „über isa geroutet" (= mit `Isa::simd_field_sum`-artiger Vektorisierung versehen), passiert:

1. **Muster-Kollaps:** Ein Vektor-Load liest 16/32/64 B kontiguierlich. Für stride-tragende Kernel (CLA: 4 Nutz-B
   je 64-B-Schritt) müsste entweder gather-geladen (anderes µArch-Profil) oder kontiguierlich gelesen werden
   (dann berühren CLA und aos_strict identische Byte-Mengen) → die Layout-Differenzierung, die der kRecordSize-48-Fix
   (`abi_adapter.hpp:380-383`) gerade herstellt, kollabiert. Dito T9: SIMD beschleunigt raw/compressed stark,
   var_len (datenabhängige LEB128-Schleife, `var_len.hpp:45-50`) kaum → die deklarierte Kosten-ORDNUNG verzerrt.
2. **Attributions-Bruch:** `do_seg19` attribuiert je Achse EIN Segment (`abi_adapter.hpp:528-537`); die isa-Achse
   hat ihr EIGENES Segment T12 (`:761-766`). Isa-Effekt in T3-T16 hieße: dieselbe Bau-Variable wirkt in 10+
   Segmenten → T5 misst layout×isa statt layout. Das verletzt den Attributions-Constraint des Modells
   (Doc 21 §B-H7) und entwertet die Segment-Zeitreihen für die Heuristik-Kurven (Doc 20).
3. **Zähler-Desynchronisation:** Die Observable-Snapshots modellieren die Scan-Aktivität aus dem BEKANNTEN Muster:
   `MemoryLayoutSnapshot.cache_lines_touched` = „record_size-basierte AoS-Strided-Schätzung"
   (`axis_05_memory_layout_observable.hpp:14, :28-34`); `IsaStatistics.simd_iterations/scalar_fallback_count`
   spiegeln exakt die 16/8/4-Kaskade (`axes/simd/axis_09_isa_observable.hpp:17-27, :43-49`). Ein verändertes
   Kernel-Muster macht diese Zähler still zur Lüge (Phase-0.1-Lektion: `lane_width_()` musste mitgezogen werden,
   Commit `8175c802`).
4. **Ergebnis-Drift:** Die Kernel-Rückgaben sind `last_checksum`-Korrektheits-Anker
   (`axis_05_memory_layout_observable.hpp:34`). Phase 0.1 bewies (Review `wf_fd87be00`, Backup
   `docs/sessions/backups/20260710-phase01-simd-dispatch/DOSSIER.md:12-15`, super-Repo): schon die
   Akkumulations-BREITE divergiert build-abhängig unter Überlauf — jede Vektorisierung braucht
   uint64-Widening-Beweise je Kernel, für ~30 Strategie-Kernel (Zählung: 9 Kernel-Familien × 3-5 Strategien).

**Autoritative Re-Diagnose (bestätigt):** Doc 21 §F Meta-Befund (super-Repo
`docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md:219-222`): „die *_scan-Kerne sind bewusst
**strided Mess-Kerne**, deren ZUGRIFFSMUSTER das Achsen-Signal IST […] SIMD würde das Muster ändern →
**Signal korrumpiert**. NICHT das saubere simd_field_sum-Muster (das war der kontiguierliche Sum der isa-EIGENEN
Achse, Phase 0.1). → Fehldiagnose wie 0.2." Dieses Dossier verifiziert das am Code (1.2/1.3) und bestätigt:
**R2 ist keine Utilization-Lücke, sondern Mess-Design.** Die ursprüngliche Audit-Rahmung „(A) SIMD-Dispatch: isa/simd
(09/09b) als echten SIMD-Dispatch in ALLE *_scan-Kerne ziehen" (Doc 21:83-85) ist damit für die Nicht-isa-Kerne
widerlegt.

**SOTA-Absicherung (Primärquellen):** Die Datenbank-Literatur bindet SIMD-Scans an KONTIGUIERLICHE (kolumnare)
Layouts: Zhou/Ross, „Implementing Database Operations Using SIMD Instructions" (SIGMOD 2002); Willhalm et al.,
„SIMD-Scan: Ultra Fast in-Memory Table Scan using on-Chip Vector Processing Units" (VLDB 2009);
Polychroniou/Raghavan/Ross, „Rethinking SIMD Vectorization for In-Memory Databases" (SIGMOD 2015; gather-basierte
strided Zugriffe haben dort ein eigenes, NICHT äquivalentes Kostenmodell). D.h. SIMD-Fähigkeit ist selbst eine
LAYOUT-Eigenschaft — sie über alle Layouts zu erzwingen zerstört genau den Unterschied, den die Achse misst.
(Khuong/Morin JEA 2017 bereits in Doc 21 §E als Prefetch-Quelle verankert.)

**Bereits korrekt gelöste Cross-Achsen-SIMD (Präzedenz, NICHT Teil des Rests):** Wo ein Organ SIMD ECHT als
Verhalten (nicht als Mess-Muster) braucht, liegt die Primitive IN der isa-Achse und wird via `C::isa` konsumiert —
`Amd64Isa::group_match_mask` (SSE2-movemask + consteval-/Skalar-Fallback, `axis_09_isa_amd64.hpp:44-67`),
konsumiert vom Swiss-Pfad (7b-3 DONE, ce `9f60216f`, Ledger §12 2026-07-08). Das ist das Muster für ZUKÜNFTIGE
echte SIMD-Verhaltens-Primitive; es ändert keine Mess-Kernel.

---

## 2. Befund (b): Was „09b→Flag = Build-Infra" KONKRET bedeutet

### 2.1 Ist-Architektur der 09b-Achse

- axis_09b `simd_extension` ist eine **Build-Varianten-Achse, KEIN Composition-Slot**: das 19-Achsen-Tupel hat nur
  `C::isa` (axis_09); 09b gehört zum Build-Achsen-Tripel page_type(01)/simd_extension(09b)/general_hardware(12)
  — „diese Achsen sind reine Build-Time-Konstanten […] EXPLIZIT als realer, flacher POD je Knoten getragen"
  (`libs/cache_engine/anatomy/build_variant_definition.hpp:2-9`; POD-Felder `simd_width_bits`/`simd_avx512`
  `:23-25`; Reader `:62-74`). Verifiziert bereits in Ledger §12 2026-07-08 (composition_concept.hpp:43,
  kein `::simd_extension`-Slot).
- Die 8 Extension-Klassen sind reine compile-time-Deklarationen (CRTP-Basis + Concept):
  `Sse2SimdExtension::vector_width_bits()==128` (`topics/hardware/axis_09b_simd_extension/
  axis_09b_simd_extension_sse2.hpp:26`), Avx2==256 (`..._avx2.hpp:26`), Avx512==512 (`..._avx512.hpp:26`),
  NoSimdExtension==0 + `is_active()==false` (`..._no_extension.hpp:25-26`). Registry = mp_list + enabled-Filter
  (`..._registry.hpp:22-30`).
- Die CMake-Seite generiert NUR den Registrier-Flags-Header: `COMDARE_AXIS_09B_ENABLE_*` → `configure_file`
  → `axis_09b_simd_extension_flags.hpp` (`CMakeLists.txt:1182-1194`; Template `..._flags.hpp.in`). Diese Flags
  schalten Klassen-Registrierung — **sie setzen KEINE Compiler-ISA-Flag**.
- Je Binary wird die Build-Identität als extern-C-Symbol eingebacken:
  `COMDARE_DEFINE_BUILD_VARIANT_INSPECTION(SymbolName, PT, SE, HW)`
  (`include/cache_engine/abi/build_variant_inspection.hpp:17-21`), gebündelt im Emissions-Makro
  `COMDARE_DEFINE_ANATOMY_MODULE_ADHOC_BUILDVARIANT(PT, SE, HW, ...)`
  (`include/cache_engine/abi/anatomy_module_abi_v1.hpp:76-83`).
- Der isa-Kernel dispatcht seit Phase 0.1 (`8175c802`) auf die **Compiler-Makros** `__AVX512F__`/`__AVX2__`
  (`axes/simd/axis_09_isa_amd64.hpp:15-19, :83-131`) — d.h. die BUILD-FLAG entscheidet den Pfad; der Kommentar
  benennt die Lücke selbst: „Verdrahtung 09b->Flag = Folge-Slice; heute noch nicht in cmake/isa_features.cmake
  gekoppelt" (`axis_09_isa_amd64.hpp:73-75`).

### 2.2 Die Lücke, exakt

- `cmake/isa_features.cmake` liefert Detection (`COMDARE_HAS_AVX2/AVX512/BMI2/NEON/SVE2`, Z.11-77) und den
  Target-Helper `COMDARE_apply_simd_flags(target)` (Z.103-124). Es wird eingebunden (`CMakeLists.txt:454`),
  aber: **grep über den gesamten Tree = 0 produktive Aufrufer** von `COMDARE_apply_simd_flags` (einzige
  Fundstelle die Definition selbst). Zudem appliziert der Helper ALLE detektierten Stufen gleichzeitig —
  je-Extension-Auswahl (das, was 09b braucht) existiert nicht.
- Die Phase-0.1-Testvarianten setzen Flags manuell je Test-Target (`tests/unit/CMakeLists.txt:2681-2690`,
  `-mavx2`/`-mavx512f`) — bewusst isoliert, keine Produktiv-Kopplung (Phase-0.1-Verbot (b), Backup-DOSSIER Z.9-11).
- Der Legacy-V36.B-Permutations-Codegen hat einen EIGENEN String-Kanal (`_p_simd` ∈ scalar/sse4/avx2[/avx512])
  mit per-Target-Generator-Expressions (`tools/permutation_codegen/codegen.cmake:564-576, :599-604`) — dieser
  Kanal ist NICHT aus den 09b-Klassen abgeleitet und steht seit #25-B unter einem **Byte-Identitäts-Vertrag**
  mit dem C++23-Backend (`libs/cache_engine/builder/permutation_codegen_tool/permutation_codegen_tool.cpp`,
  ce `4fc267e9`+`f0f20acc`: „cpp==cmake byte-identisch") → jede Änderung dort müsste doppelt-synchron erfolgen
  und kollidiert mit GO 2 (Swap-to-Default ZULETZT). **Nicht anfassen.**
- Die `isa`-Achse in `permutation_axes.xml:115-125` (X86_BASELINE…ARM_SVE) ist ein dritter, unabhängiger
  Vokabular-Kanal — **TABU, bleibt unberührt.**

### 2.3 Der resultierende Ehrlichkeits-Bruch (warum R1 bauen)

Heute kann eine Binary `Avx2SimdExtension` deklarieren (POD `simd_width_bits=256` via
`build_variant_definition.hpp:69`; Inspection-Symbol via `build_variant_inspection.hpp:17-21`), während ihr
Maschinencode mangels `-mavx2` den SSE2-Pfad fährt (`axis_09_isa_amd64.hpp:107-120`). Genau diese Diskrepanz
existiert im Tree: die „echten Wrapper"-Beweis-DLLs `perm_buildvariant_real_avx2/_real_avx512` deklarieren
Avx2/Avx512 OHNE die zugehörigen Compile-Flags (`tests/unit/CMakeLists.txt:2331-2360`). Für die Messung heißt
das: die per dlsym abfragbare Build-Identität (L-74a) kann vom realen Compute abweichen → **Mess-Etikett ≠
Mess-Gegenstand**. „09b→Flag = Build-Infra" bedeutet also: die fehlende Kopplung ist CMake-/Emissions-Arbeit
(welche Flags ein Target bekommt), NICHT Achsen-Code — und sie ist die Voraussetzung dafür, dass die 09b-Achse
je Tier-Binary WAHR wird (F4-Vision: „Programme automatisch mit Beschleuniger-Code bestücken", Ledger §12
2026-07-07, Z.432).

---

## 3. Lösungs-Optionen (in den gesetzten Grenzen)

### Option 1 — „Deklarations-Wahrheit + Mess-Kern-Reinheit" (additiv, zweiteilig) ⭐ EMPFEHLUNG

**A1 (R1, Build-Infra): 09b→Flag-Kopplung mit compile-time-Kohärenz-Guard.**
1. `cmake/isa_features.cmake`: neue Funktion `comdare_apply_simd_extension_flags(<target> <EXT>)` — bildet GENAU
   EINE 09b-Extension auf ihre Flags ab (NO_EXTENSION/SSE2→keine Flag [x86-64-ABI-Baseline], AVX2→`-mavx2`
   bzw. `/arch:AVX2`, AVX512→`-mavx512f`… bzw. `/arch:AVX512`, NEON→keine [aarch64-Baseline], SVE2/RVV→`-march=…`
   nur wenn `COMDARE_HAS_*` detektiert, CUDA_GH200→FATAL mit Verweis). Nutzt die BESTEHENDE Detection;
   `COMDARE_apply_simd_flags` (alles-auf-einmal) bleibt unangetastet daneben (Doku-Hinweis, nie löschen).
2. Neuer Header `topics/hardware/axis_09b_simd_extension/axis_09b_build_coherence.hpp`:
   `template<class SE> consteval bool declared_extension_matches_build()` — vergleicht `SE::vector_width_bits()`
   mit der realen Build-Stufe (`__AVX512F__`→512, sonst `__AVX2__`→256, sonst x86_64→128, `__ARM_NEON`→128,
   sonst 0). `NoSimdExtension` (width 0, `is_active()==false`) ist auf SIMD-Baseline-Plattformen exempt
   (dokumentiert: „deklariert Nicht-NUTZUNG, nicht Nicht-Existenz" — die x86-64-ABI erzwingt SSE2).
   Benanntes Muster: **Meta-driven Concept Hardening** ([[reference_meta_driven_concept_hardening_pattern]]) —
   eine Deklaration wird per consteval-Prädikat gegen den Ist-Build gehärtet.
3. Neues, ADDITIVES Emissions-Makro `COMDARE_DEFINE_BUILD_VARIANT_INSPECTION_CHECKED(SymbolName, PT, SE, HW)`
   (in `build_variant_inspection.hpp`, direkt unter dem bestehenden): identisch + 
   `static_assert(declared_extension_matches_build<SE>(), "axis_09b: deklarierte SIMD-Extension != Build-ISA-Stufe — comdare_apply_simd_extension_flags(<target>, <EXT>) fehlt")`.
   Der Golden-Pfad (`COMDARE_DEFINE_ANATOMY_MODULE`/`_ADHOC`/`_BUILDVARIANT`) bleibt byte-unberührt —
   exakt die SHAPED-Präzedenz („Der Golden-Pfad wird nicht angefasst", `anatomy_module_abi_v1.hpp:85-92`).
4. Beweis-Verdrahtung: die realen Wrapper-DLLs `perm_buildvariant_real_avx2/_real_avx512`
   (`tests/unit/CMakeLists.txt:2331-2360`) auf CHECKED-Makro + `comdare_apply_simd_extension_flags` heben
   (Build-Gate: nur wenn `COMDARE_CXX_HAS_MAVX2/512F`, Muster Z.2681-2690); Ausführung host-gated
   (`__builtin_cpu_supports`-Probe, Muster `test_simd_field_sum_dispatch`). Damit ist end-to-end bewiesen:
   POD sagt 256/512 UND der T12-Kernel fährt real den AVX2/AVX-512-Pfad.

**A2 (R2, Mess-Design): Reinheit der *_scan-Kerne als stehende Invariante.**
1. Neuer Guard-Test `tests/unit/test_striktheit_scan_kernel_purity.cpp` (Striktheit-Guard-Familie, Präzedenz
   `test_striktheit_metaprog_guard.cpp` etc., Ledger §12 2026-07-08): friert per requires-Ausdrücken das
   Kernel-Interface ein — für alle Strategien der 9 Kernel-Familien gilt compile-time:
   (i) die kanonische Signatur `static uint64_t kernel(unsigned char const*, size_t, size_t)` (bzw. die
   query-Formen T4/T16) existiert; (ii) KEINE Isa-parametrisierte Überladung existiert
   (`!requires { S::template kernel<simd::Amd64Isa>(...); }` + `!requires { S::kernel(buf,n,rs, Isa{}); }`).
   Prospektiv bricht jedes künftige „Routing über isa" den Build — die Entscheidung wird erzwungen, nicht nur
   dokumentiert ([[feedback_metaprogrammierung_compile_time_zwingend_durchsetzen]]).
2. Doku-Anker: ein Satz am `do_seg19`-Kopf (`abi_adapter.hpp` Kommentarblock 528-537, NUR Kommentar) +
   Auflösungs-Absatz in Doc 21 §F (super-Repo; Hebel-A-Rest = R1 gebaut / R2 by-design-skalar / R3 HW-gated) +
   Ledger-§12-Eintrag. Doku nie löschen, nur ergänzen.

**Trade-offs Option 1:** (+) golden/ABI/POD/permutation byte-neutral (nur additive Header/Makros/Tests/CMake);
(+) kein einziges Mess-Signal ändert sich (Messdaten-Kontinuität); (+) schließt den EHRLICHEN Teil der
Utilization-Lücke (09b wirkt real auf den Compute des T12-Kernels je Variante) und macht den Rest als Design
explizit; (+) reine compile-time-Mechanik (consteval + static_assert + Generator-Expressions), kein Runtime-Switch;
(+) benannte Muster (Concept-Hardening, Guard-Test-Präzedenz). (−) Der `*_scan`-Utilization-Eintrag des Audits
wird formal NICHT „geschlossen", sondern als Fehldiagnose reklassifiziert (belegt in §1 — das ist die Wahrheit,
nicht Bequemlichkeit); (−) zwei Inspection-Makros (CHECKED + Legacy) koexistieren, bis die Alt-Stub-Tests
migriert sind (bewusst: Additivität vor Zwang).

### Option 2 — Harter Kohärenz-Zwang im BESTEHENDEN Inspection-Makro

Wie Option 1, aber der `static_assert` wandert direkt in `COMDARE_DEFINE_BUILD_VARIANT_INSPECTION`
(`build_variant_inspection.hpp:17-21`) — JEDE Deklaration wird sofort erzwungen, kein zweites Makro.
**Trade-offs:** (+) stärkste Härtung, keine Makro-Dualität; (−) NICHT additiv: bricht sofort die bestehenden
Stub-/Real-DLL-Tests, die Avx512/Avx2 absichtlich OHNE Flags deklarieren (`tests/unit/genus_buildvariant_avx512.cpp:32`,
`genus_buildvariant_avx2.cpp:26`, `test_d7a_build_inspection.cpp:36-38`, real-DLLs Z.2331-2360) — deren Zweck ist
POD-Roundtrip-Identität, nicht Build-Wahrheit; sie müssten im selben Slice auf Flags/Stub-Exemptions umgebaut
werden (Stubs haben erfundene widths → bräuchten ein Opt-out-Trait = zusätzliche API nur für Tests); (−) berührt
den ABI-Header, den der Golden-DLL-Pfad inkludiert — jede Regression dort ist golden-nah. Verstößt gegen die
Additiv-Präferenz des Ledgers (§0) und die SHAPED-Präzedenz („Golden-Pfad nicht anfassen"). **Nicht empfohlen
als Erst-Slice; als Folge-Konsolidierung möglich, wenn alle Emittenten CHECKED nutzen.**

### Option 3 — Pattern-treue partielle SIMD-Einspeisung (nur kontiguierliche Strategien)

Nur die Kernel, deren Muster BEREITS kontiguierlich ist (soa 4-B, packed_bitmap 2-B, aosoa-Blockläufe;
Belege §1.2), delegieren ihre Läufe an `Isa::simd_field_sum`-artige Primitive; strided Kernel bleiben skalar
(SOTA-konform: SIMD-Scan setzt Kontiguität voraus, Willhalm 2009 / Polychroniou 2015 — die layout×SIMD-Interaktion
wäre REAL, nicht erfunden). **Trade-offs:** (+) einzig fachlich vertretbare Form eines *_scan-SIMD; (−) bricht
die Segment-Attribution TROTZDEM: der isa-/Build-Stufen-Effekt erschiene in T5/T7 UND T12 → Achsen-Kurven nicht
mehr einzel-attribuierbar (Verstoß Doc 21 H7); (−) Signatur-/Konsum-Problem: `scan_field_sum` ist static ohne
Isa-Zugang; sauber ginge nur (a) Signatur-Erweiterung (bricht Concept + alle 5 Strategien + Hüllen + 4 Aufrufer)
oder (b) Templatisierung der konkreten mp_list-Registry-Klassen — genau das §F.1-Verbot (Permutations-Enumeration
→ permutation_axes/golden-TABU) — oder (c) hart eingebundene Plattform-Isa = verdeckte Kopplung am
Composition-Vertrag vorbei (Anti-Pattern zu D2 „Achse konsumiert Achse ÜBER die Composition"); (−) ~10 neue
uint64-Invarianz-Beweise. **Verworfen für GO 3; nur denkbar als SEPARATER, User-GO-pflichtiger Umbau mit
explizitem Zwei-Segment-Attributionsdesign (z.B. eigene „vektorisierte Layout-Unter-Achse" statt stiller Kopplung).**

### (Verworfen, dokumentiert) Option 0 — Volles Isa-Routing ALLER *_scan-Kerne

Die Original-Audit-Rahmung (Doc 21:83-85). Nach §1 signal-korrumpierend auf allen vier Vektoren; von Doc 21 §F
bereits als Fehldiagnose eingestuft; hier code-verifiziert. **NICHT bauen** (Phantom-Schutz analog
[[reference_tier_metaphor_system_axis_properties_verified_complete]]).

---

## 4. Empfehlung (sauberste, nicht einfachste)

**Option 1** — mit dieser Begründungskette: (1) sie stellt die einzige BEWEISBARE Wahrheit her, die der
Hebel-A-Rest noch schuldet (Deklaration == Maschinencode je Binary), compile-time-erzwungen; (2) sie lässt die
Mess-Kerne unangetastet, deren Skalarität Mess-DESIGN ist (§1), und macht diese Entscheidung als stehende
Invariante prüfbar statt als Wissens-Stand vergänglich; (3) sie ist vollständig additiv → golden-320/POD-1416/
ABI-4/permutation_axes byte-unberührt, Messdaten-Kontinuität garantiert; (4) sie folgt ausschließlich
vorhandenen Haus-Präzedenzen (SHAPED-Makro-Additivität, Striktheit-Guard-Familie, Dispatch-Test-Varianten,
Concept-Hardening). Die „einfachste" Alternative (nur Doku-Satz „machen wir nicht") würde die 09b-Lüge
(§2.3) stehen lassen; die „maximal-invasive" (Option 2/3) riskiert Golden-Nähe bzw. Attribution für null
Mess-Mehrwert.

---

## 5. Implementierungs-Plan (für den Hauptagenten)

**Reihenfolge = 2 granulare Increments (je Kadenz: Selbst-Impl → adversarialer Review → doppelt-literal g++-16 →
granulare Commits beide Remotes → CI strikt grün).**

### Increment 1 — A1 „09b→Flag + Kohärenz-Guard"
| Datei | Änderung |
|-------|----------|
| `cmake/isa_features.cmake` | NEU `comdare_apply_simd_extension_flags(<target> <EXT>)` (Mapping §3-Option-1-A1-1; MSVC+GCC/Clang-Zweige wie `COMDARE_apply_simd_flags` Z.103-124; unbekannte EXT → `message(FATAL_ERROR)`) |
| `libs/cache_engine/topics/hardware/axis_09b_simd_extension/axis_09b_build_coherence.hpp` | NEU: `consteval bool declared_extension_matches_build<SE>()` + `actual_build_simd_width_bits()` (Makro-Kaskade, exakt die 512/256/128-Logik von `axis_09_isa_amd64.hpp:83-131` gespiegelt); NoSimdExtension-Exemption dokumentiert |
| `libs/cache_engine/include/cache_engine/abi/build_variant_inspection.hpp` | NEU additives Makro `COMDARE_DEFINE_BUILD_VARIANT_INSPECTION_CHECKED` (bestehendes Makro + static_assert); Legacy-Makro + Golden-Pfad UNVERÄNDERT |
| `tests/unit/genus_buildvariant_real_avx2.cpp` / `_real_avx512.cpp` | auf CHECKED-Makro umstellen |
| `tests/unit/CMakeLists.txt` | `perm_buildvariant_real_avx2/_real_avx512` (Z.2331-2360): `comdare_apply_simd_extension_flags(... AVX2/AVX512)` + Build-Gate `COMDARE_CXX_HAS_MAVX2/512F` (Muster Z.2681-2690); NEU `test_ap5_simd_extension_coherence` (Standalone): lädt die real-DLLs, prüft POD `simd_width_bits`==256/512 UND (host-gated via `__builtin_cpu_supports`) dass `Isa::simd_field_sum`-Timing/Verhalten dem breiten Pfad entspricht — mindestens aber Compile-Beweis des static_assert-Pfads (Negativ-Probe: CHECKED ohne Flag DARF NICHT kompilieren → als `check_cxx_source_compiles`-Negativtest in CMake, Muster `isa_features.cmake`) |
| KEINE Änderung | `tools/permutation_codegen/*` + `libs/cache_engine/builder/permutation_codegen_tool/*` (Byte-Identitäts-Vertrag #25-B, GO 2 zuletzt); `permutation_axes.xml`; alle Golden-Emissions-Makros; `COMDARE_apply_simd_flags` |

### Increment 2 — A2 „Scan-Kernel-Reinheits-Guard"
| Datei | Änderung |
|-------|----------|
| `tests/unit/test_striktheit_scan_kernel_purity.cpp` | NEU (Guard-Familie): requires-basierte Interface-Freeze-Asserts über die 9 Kernel-Familien (Strategie-Listen aus den Achsen-Registries; leichte Header bevorzugen, Cold-Cache-ICE-Lektion: schwere config_set-Includes vermeiden bzw. separat halten) |
| `tests/unit/CMakeLists.txt` | Test registrieren (Label `striktheit;axes`) |
| `libs/cache_engine/anatomy/abi_adapter.hpp` | NUR Kommentar am do_seg19-Kopf (Z.528-537): „*_scan-Zugriffsmuster = Achsen-Signal; bewusst skalar; SIMD-Verhaltens-Primitive gehören in die isa-Achse (group_match_mask-Muster)" |
| super `docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md` | §F: Hebel-A-Rest-Auflösung nachtragen (R1 gebaut+CI-Beleg, R2 by-design + Guard, R3 HW-gated offen) |
| super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md` | §12-Eintrag + Task #5 auf DONE (nach CI-Grün-Beleg) |

### Verifikation (DoD, doppelt-literal)
1. g++-16: voller `ctest` 100% (inkl. der 3 bestehenden Dispatch-Varianten + neue Tests) — WÖRTLICHE Ausgabe.
2. Negativ-Beweis: CHECKED-Emission ohne passende Flag kompiliert NICHT (literaler Compiler-Fehltext im Log).
3. TABU-Beweis per `git status`/`git diff --stat`: `golden_fullpilot_320_binary_ids.txt`, `permutation_axes.xml`,
   alle POD-Header, `anatomy_module_abi_v1_decl.hpp` (MAJOR==4), Registries' mp_lists byte-unberührt.
4. clang-format-22==0 (`~/tools/cf22/usr/bin/clang-format-22`); Mojibake-grep==0; ue/ae/oe-Konvention.
5. CI beide Remotes strikt grün ([[feedback_verify_gitlab_pipeline_green_after_push]]); der laufende
   golden-320-Lauf (#9916) wird NICHT gestört (kein Mess-Pfad-Byte ändert sich; nicht aktiv pollen).

### Explizit AUSSERHALB des Scopes (dokumentierte Folge-Slices)
- R3 NEON/RVV-`simd_field_sum` (HW-/INFRA-gated; auf prod1 nur compile-only — Doc 21 §F Z.223-224).
- Option-3-artige „vektorisierte Layout-Unter-Achse" (nur mit neuem User-GO + Attributionsdesign).
- Konsolidierung Option 2 (CHECKED wird einziges Makro), wenn alle Emittenten migriert sind.
- E2-Voll-Matrix-Emission je 09b-Variante (gehört zur #276-/Build-Matrix-Doktrin, 8er-Docker/ISA-Matrix).

---

## 6. Risiken

| Risiko | Schwere | Mitigation |
|--------|---------|-----------|
| Kohärenz-Kaskade weicht künftig vom Kernel-Dispatch ab (dritte Spiegelung der 512/256/128-Logik neben `simd_field_sum` + `lane_width_`) | mittel | Kaskade EINMAL in `axis_09b_build_coherence.hpp::actual_build_simd_width_bits()` zentralisieren; Folge-Refactor: `lane_width_()` daraus ableiten (separater Slice, T12-Messzeile → Doppel-Kartierung) |
| MSVC-Makro-Divergenz (`/arch:AVX512` definiert `__AVX512F__`, aber Teil-Feature-Sets divergieren) | niedrig | Guard prüft nur die F-Stufe (wie der Kernel); MSVC-CI-Variante vorhanden |
| Negativ-Compile-Test flakt auf exotischen Compilern | niedrig | via `check_cxx_source_compiles` konfigurationszeitig, nicht als ctest; nur GCC/Clang/MSVC-Zweige |
| Alt-Stub-Tests erwecken weiter den Anschein flag-loser Avx-Deklaration | niedrig | Doku-Kommentar in beiden genus_buildvariant-Stubs („POD-Roundtrip-Beweis, KEINE Build-Wahrheit — dafür CHECKED"); Konsolidierung als Folge-Slice |
| Guard-Test zieht schwere Header → Cold-Cache-ICE auf CI | mittel | Präzedenz `test_striktheit_axes_guard` (bewusst separate Datei); max 1× Retry-Doktrin ([[reference_ci_runner_ice_cold_cache_instability]]) |
| Fehl-Lesart „Hebel A bleibt offen" in künftigen Audits | mittel | Doc-21-§F-Nachtrag + Ledger-§12 + Guard-Test machen die Reklassifizierung maschinen- und menschenlesbar |

---

## 7. Beleg-Register (vollständig)

**Super-Repo** (`/home/comdare/Projekte/Research/probst-diplomarbeit-cache-engine`):
- `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`: Z.70 (#5 gated), Z.271 (GO 3), Z.428/432 (G-7b3/F4-Vision),
  Z.468 (09b ≠ Composition-Slot, Doppel-Kartierung), Z.541 (Doc-21-Session, „Nächster Increment Phase 0.1"),
  Z.891/903 (7b-3-W2 + isa-Kopplungs-Entscheid), Z.969 (G-7b3=axis_09b).
- `docs/architektur/21_SESSION_PLAN_TYPSYSTEM_ACHSEN_ENTSCHEIDUNGEN.md`: Z.82-85 (Hebel A Original),
  Z.98 (L0-Schichtung), Z.153-155 (Phase 0.1 ✅), Z.213-228 (§F Meta-Befund; Hebel-A-Rest Z.219-222;
  NEON/RVV Z.223-224), Z.230-233 (Design-Forks).
- `docs/sessions/backups/20260710-phase01-simd-dispatch/DOSSIER.md`: Z.9-11 (Verbot Build-Flag-Änderung),
  Z.12-15 (uint64-Invarianz-Lektion), Z.23-26 (Lücke 2-teilig; (ii)=Folge-Slice), Z.51-52 (Scope-Grenze).

**ce-Submodul** (`Code/external/comdare-cache-engine`, Stand `f0f20acc`):
- Mess-Maschinerie: `libs/cache_engine/anatomy/abi_adapter.hpp` Z.380-389, 398-439, 421/425/502/504, 528-537,
  632-800 (T3:661-673, T4:676, T5:679-683, T7:705-720, T9:739-743, T11:756-760, T12:761-766, T13:769, T14:774,
  T15:779, T16:784).
- Layout-Kernel: `axes/layout/axis_05_memory_layout_{aos_strict:45-54, cache_line_aligned:52-63, soa:48-57,
  packed_bitmap:48-57, aosoa:64-76}.hpp`; Hülle `axis_05_memory_layout_observable.hpp:10-14, 28-34`.
- Weitere Kernel: `axis_10_serialization_var_len.hpp:38-53`; `axis_02_path_compression_patricia.hpp:63`;
  `axis_04_node_type_node{4:38,16:36,48:37,256:36}.hpp`; `axis_14_value_handle_{inline:40,chain_ref:47}.hpp`;
  `axis_01_index_organization_non_clustered.hpp:45`; `axis_io_{mmap:44,buffered:43,direct:44}.hpp`;
  `axis_migration_{none:39,hot_cold:42,tier_based:42}.hpp`; `axis_filter_{bloom:100,xor:105,range_surf:116}.hpp`.
- isa-Achse: `axes/simd/axis_09_isa_amd64.hpp` Z.15-19, 44-67 (group_match_mask), 70-77 (Folge-Slice-Kommentar),
  83-131 (Dispatch); `axes/simd/axis_09_isa_observable.hpp` Z.10-27, 43-49.
- 09b-Achse: `topics/hardware/axis_09b_simd_extension/axis_09b_simd_extension_{sse2:23-35, avx2:25-26,
  avx512:25-26, no_extension:25-26}.hpp`; `..._registry.hpp:22-30`; `..._flags.hpp.in`;
  Cross-Constraint `topics/hardware/topic_hardware_config_set.hpp:41-59`.
- Build-Achsen-ABI: `anatomy/build_variant_definition.hpp` Z.2-9, 17-31, 41-56, 59-74;
  `include/cache_engine/abi/build_variant_inspection.hpp:14-21`;
  `include/cache_engine/abi/anatomy_module_abi_v1.hpp:76-83 (BUILDVARIANT), 85-92 (SHAPED-Präzedenz)`.
- Build-Infra: `cmake/isa_features.cmake` (Detection Z.11-77, `COMDARE_apply_simd_flags` Z.103-124; 0 produktive
  Aufrufer per grep); `CMakeLists.txt:454 (include), 1182-1194 (09b ENABLE→USE→configure_file)`;
  `tools/permutation_codegen/codegen.cmake:41-47 (eigener simd-String-Kanal), 564-576 + 599-604 (per-Perm-Flags)`;
  C++23-Backend `libs/cache_engine/builder/permutation_codegen_tool/` (ce `4fc267e9`/`f0f20acc`, byte-identisch);
  Tests `tests/unit/CMakeLists.txt:2277-2363 (buildvariant-DLLs; real-DLLs OHNE Flags 2331-2360), 2633-2690
  (Dispatch-Test-Varianten)`; `tests/unit/genus_buildvariant_avx2.cpp:16-26`, `genus_buildvariant_avx512.cpp:32`,
  `test_d7a_build_inspection.cpp:36-38`.
- TABU-Referenz: `libs/cache_engine/algorithm_profiles/permutation_axes.xml:115-125` (isa-Achse, unberührt).
- Commits: `8175c802` (Phase 0.1 + Folge-Slice-Definition), `9f60216f` (7b-3 Swiss-ISA, Ledger §12 08.07.),
  `4fc267e9`/`f0f20acc` (#25-B Codegen-Port, Byte-Identitäts-Vertrag).

**Primärquellen (SOTA):** Zhou & Ross, SIGMOD 2002 („Implementing Database Operations Using SIMD Instructions");
Willhalm et al., VLDB 2009 („SIMD-Scan"); Polychroniou, Raghavan & Ross, SIGMOD 2015 („Rethinking SIMD
Vectorization for In-Memory Databases"); Khuong & Morin, ACM JEA 22 (2017) — bereits Doc 21 §E.
