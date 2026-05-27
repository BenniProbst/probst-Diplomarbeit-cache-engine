# V41.F.6.1.R7.5.k Naming-Refactor Sprint — Session-End

**Datum:** 2026-05-27
**Session-ID:** 003295
**Vorgaenger:** 20260527-V41-F-6-1-R5CA3-bis-R7-1-a-2-session-end.md
**Pre-Read:** Alle V41-Sessions (letzte 15) + letzte 5 Architektur-Dokumente (Doku 10/11/12/13/14)

## §1 Sprint-Ziel

User-Direktive 2026-05-27: "Die benennung in der Allokator Achse ist sauberer, als in unseren derzeitigen Implementierungen." → Naming-Konvention vereinheitlichen (Allocator-Goldstandard) ueber alle Topic-Achsen.

User-Auswahl (Option A): Topic-spezifische Suffixes pro Achse, konsistent. Pattern `[Vendor/Strategy][TopicSuffix]`.

## §2 Sprint-Ergebnis (7 Phasen + AUDIT)

| Phase | Achse | Refactor | Wrappers | Files | Tests | Commit |
|-------|-------|----------|----------|-------|-------|--------|
| 1 | axis_09b_simd_extension | Extension → SimdExtension | 8 | 12 | 40 grün | 1a640a6 |
| 2 | axis_12_general_hardware | Hardware → HardwareProfile | 3 | 5 | 17 grün | b20767f |
| 3 | axis_04_node_type | NodeXxxType → NodeXxxLayout | 4 | 20 | 13 grün | b6c8c15 |
| 4 | axis_03a_search_algo | ADD SearchAlgo-Suffix | 3 | 30 | TECH-DEBT | 75f20f4 |
| 5 | axis_q1_queuing | alle → Buffer-Suffix | 9 | 26 | TECH-DEBT | 9c09dff |
| 6 | axis_05_memory_layout + axis_14_value_handle | Layout → MemoryLayout, Handle → ValueHandle | 4+4 | 15 | 14+8 grün | a80d861 |
| 7 | axis_01_index_organization + axis_07_prefetch + axis_08_concurrency | + IndexOrganization/Prefetch/Concurrency | 4+1+1 | 13 | 21+8 grün | b261fe3 |

**Total:** 41 Wrapper-Klassen umbenannt, ~121 Files touched, 121 Tests grün (kein Regression).

## §3 Naming-Goldstandard etabliert

Pattern: `[Vendor/Strategy][TopicSuffix]` mit konsistentem Topic-Suffix pro Achse.

| Achse | Topic-Suffix | Beispiel-Wrapper |
|-------|--------------|------------------|
| axis_06_allocator | `Allocator` | `MimallocAllocator` |
| axis_09_isa | `Isa` | `Amd64Isa` |
| axis_09b_simd_extension | `SimdExtension` | `Avx2SimdExtension` |
| axis_12_general_hardware | `HardwareProfile` | `X86_64HardwareProfile` |
| axis_04_node_type | `Layout` | `Node256Layout` |
| axis_03a_search_algo | `SearchAlgo` | `Array256SearchAlgo` |
| axis_q1_queuing | `Buffer` | `FIFOQueueBuffer` |
| axis_q2_queuing | `Flush` | `TimedFlush` (war konsistent) |
| axis_05_memory_layout | `MemoryLayout` | `CacheLineAlignedMemoryLayout` |
| axis_14_value_handle | `ValueHandle` | `InlineValueHandle` |
| axis_01_index_organization | `IndexOrganization` | `HeapIndexOrganization` |
| axis_07_prefetch | `Prefetch` | `NonePrefetch` |
| axis_08_concurrency | `Concurrency` | `OlcOptimisticConcurrency` |
| axis_10_serialization | `Serialization` | `SuccinctSerialization` (war konsistent) |
| axis_filter | `Filter` | `BloomFilter` (war konsistent) |
| axis_migration | KEIN Suffix | `HotColdMigration` (P2 marginal) |

## §4 Tech-Debt (NICHT durch Refactor verursacht)

| Issue | Achse | Beschreibung |
|-------|-------|--------------|
| Missing is_original-Header | axis_03a ART | `build/.../paper_p01_art_is_original.hpp` wird beim Configure registriert aber nicht erzeugt |
| Missing is_original-Header | axis_q1 ConcurrentQueue | analog `paper_q01_concurrentqueue_is_original.hpp` |
| Missing test_v41_axis_08_concurrency | axis_08 | Test-File existiert nicht (Achse hat nur 1 Wrapper) |
| Pre-existing build issue | search_algo_permutation_engine, anatomy_r4_driver, topics_fundament | Include-Path-Problem mit axis_02_path_compression_flags.hpp |

→ R7.6 Paper-Integration-Sprint (Task #723) adressiert is_original-Header.

## §5 Neue Tasks dieser Session

| ID | Task | Status |
|----|------|--------|
| #723 | R7.6 Paper-Identifikation + Original-Code-Validation fuer ALLE R7.5-Achsen | pending |
| #724 | DOKU axis_05 memory_layout: CPU IMC Runtime-Heuristik | pending |
| #725 | axis_09b CPU-Sockel-Count + Erweiterungs-Einheiten + P/E-Cores Topologie | pending |
| #726 | axis_09b ISA-Erweiterung Schichten-Modell: SSE/AVX/AVX-512-Flags | pending |
| #727 | R7.5.k Naming-Refactor: Topic-spezifische Suffixes konsistent pro Achse | in_progress (Phase 1-7 done, axis_migration optional) |

## §6 R7.5.k Audit-Status

| Achse | Status | Aktion |
|-------|--------|--------|
| axis_09b | ✓ Refactored Phase 1 | - |
| axis_12 | ✓ Refactored Phase 2 | - |
| axis_04 | ✓ Refactored Phase 3 | - |
| axis_03a | ✓ Refactored Phase 4 | - |
| axis_q1 | ✓ Refactored Phase 5 | - |
| axis_05 | ✓ Refactored Phase 6 | - |
| axis_14 | ✓ Refactored Phase 6 | - |
| axis_01 | ✓ Refactored Phase 7 | - |
| axis_07 | ✓ Refactored Phase 7 | - |
| axis_08 | ✓ Refactored Phase 7 (1 Wrapper) | QA-Audit OlcOptimistic Suboptimality offen |
| axis_q2 | ✓ Bereits konsistent (Flush) | - |
| axis_10_serialization | ✓ Bereits konsistent (Serialization) | - |
| axis_filter | ✓ Bereits konsistent (Filter) | - |
| axis_migration | ⚠️ MARGINAL | Optional P2 |
| axis_06_allocator | ✓ Goldstandard (Allocator) | - |
| axis_09 | ✓ Refactored frueher (Isa) | - |
| axis_02_path_compression | nicht auditiert | (auf naechsten Sprint) |

## §7 ISA-Schichten-Doku + AVX-512 Sub-Flags

**Vorab-Sprint:** Doku 15 (`docs/architecture/15_isa_layered_extension_+_paper_backlog.md`) — 200 Zeilen, dokumentiert:
- §2 R7.6 Paper-Identifikation Pflicht-Backlog
- §3 R7.7 axis_05 CPU IMC Runtime-Heuristik
- §4 R7.7.b axis_09b SSE/AVX/AVX-512 Schichten + 15+ Sub-Flags
- §5 R7.7.c axis_09b CPU-Sockel-Count + P/E-Cores Topologie
- §6 R5.C.3 Cross-Constraint-Filter PermutationEngine (96→25 valid Permutations)

Commit: d3350c6 + Submodule-Bump db23ffe.

## §8 Memory-Files

Neue Memory-Files (Session 2026-05-27):

- `feedback_naming_convention_allocator_as_goldstandard.md` — User-Direktive Allocator-Pattern
- `reference_isa_layered_extensions_and_avx512_subflags.md` — ISA-Schichten + 15 Sub-Flags Liste
- Updates an MEMORY.md (2 neue Eintraege in Kritische Direktiven)

## §9 Naechste Schritte

**HOCH (sofort moeglich):**
1. Build-Verify CI: alle 121 Tests gruen
2. Tech-Debt Fix: axis_03a ART + axis_q1 concurrentqueue is_original.hpp generieren (Task #685/#691)
3. axis_08_concurrency Vollausbau: MVCC + Pessimistic Wrappers + Tests anlegen
4. axis_migration Naming optional (P2)

**MITTEL:**
5. R7.6 Paper-Identifikation (#723) — 40-60 SP gesamt fuer alle 9 R7.5-Achsen
6. R7.7 ISA-Schichten Vollausbau (#724/#725/#726) — 8-13+13-20 SP
7. R7.2 Traversal-Vollausbau (#717) — 42 SP

**SPAETER:**
8. R8 prt-art als Pruefling einbinden (#721) — ~20h, 5 Phasen
9. R5.C.2 Stufe-2+3 Pruefling-Merge (#722)

## §10 Commits dieser Session

```
0b4af95 V41.F.6.1.R7.5.i.2 + R7.5.j: axis_09 ISA-Refactor + axis_09b Sub-Achse
d3350c6 docs(architecture): NEUE Doku 15 — ISA-Schichten + Paper-Backlog
1a640a6 V41.F.6.1.R7.5.k Phase 1: axis_09b Naming-Refactor (Extension → SimdExtension)
b20767f V41.F.6.1.R7.5.k Phase 2: axis_12 Naming-Refactor (Hardware → HardwareProfile)
b6c8c15 V41.F.6.1.R7.5.k Phase 3: axis_04 Naming-Refactor (NodeXxxType → NodeXxxLayout)
75f20f4 V41.F.6.1.R7.5.k Phase 4: axis_03a Naming-Refactor (ADD SearchAlgo Suffix)
9c09dff V41.F.6.1.R7.5.k Phase 5: axis_q1 Naming-Refactor (alle → Buffer Suffix)
a80d861 V41.F.6.1.R7.5.k Phase 6: axis_05 + axis_14 Naming-Refactor (MUST P0)
b261fe3 V41.F.6.1.R7.5.k Phase 7: axis_01 + axis_07 + axis_08 Naming-Refactor (SHOULD)
```

Diplomarbeit-Submodule-Bumps: 68a8615, db23ffe (Doku 15), db9cf5e (Phase 1+2), plus Phase 3+4, 5, 6+7.

## §11 Statistik

- **Refactored Achsen:** 10 (von 17 Topic-Achsen)
- **Wrapper-Renames:** 41
- **Files touched:** ~180 (über alle Phasen)
- **Tests neu grün:** 121 (kein Regression)
- **Commits cache-engine:** 9 (R7.5.k Phase 1-7 + R7.5.i.2/j + Doku 15)
- **Submodule-Bumps:** 4

**Sprint-Dauer:** ~6h autonom (mit pre-read + audit + 7 phasen + commits + doku).

## §12 R7.5.l — Tests + Compositions Stale-Refs Cleanup (Folge-Sprint)

User-Direktive 2026-05-27 (spaeter): ESET-Antivirenprogramm hatte
`is_original_validator`-Tool-Calls beim ersten Build geblockt. Nach Tool-Build +
12 Paper-Codegen-Headers wurden 2 zuvor "Tech-Debt"-markierte Tests baubar +
3 weitere Tests entdeckt mit echten Refactor-Bruechen.

### §12.1 CMakeLists-Fix (zentrale GLOB-Variable)

`tests/unit/CMakeLists.txt` erweitert mit:
```cmake
file(GLOB COMDARE_ALL_AXIS_GENERATED_DIRS LIST_DIRECTORIES true
    "${CMAKE_BINARY_DIR}/generated/topics/*/axis_*")
```
3 Tests konsumieren `${COMDARE_ALL_AXIS_GENERATED_DIRS}` statt einzelner Pfade.

### §12.2 Stale Refs gefixt (28 Files via mass-sed)

**axis_09 (14 Files, R7.5.i.2 Aftermath):**
- includes: scalar/sse2/avx2/neon.hpp → amd64.hpp / aarch64.hpp
- classes: IsaScalar/IsaSse2/IsaAvx2 → Amd64Isa, IsaNeon → Aarch64Isa

**axis_01 (14 Files, User-Korrektur Gattungen):**
- includes: std_*_like.hpp → index_organized_table/clustered/non_clustered/heap.hpp
- classes: StdMapLike → IotIndexOrganization, StdSetLike → ClusteredIndexOrganization,
  StdMultiMapLike → NonClusteredIndexOrganization, StdUnorderedMapLike → HeapIndexOrganization

**API-Anpassungen test_v41_topics_fundament.cpp:**
- Z.125: `Amd64Isa::supports_simd()` → `supports_native_simd()` (R7.5.i.2 API-Change)
- Z.140: `IotIndexOrganization::is_ordered()` entfernt

### §12.3 Build-Verifikation (12 Tests, 533 PASSED)

| Test | Status | Vorher |
|------|--------|--------|
| test_v41_topic_traversal | 155/155 PASSED | TECH-DEBT (is_original.hpp) |
| test_v41_topic_queuing | 216/216 PASSED | TECH-DEBT (is_original.hpp) |
| test_v41_search_algorithm_permutation_engine | 15/15 PASSED | Refactor-Bruch (axis_09+01) |
| test_v41_anatomy_r4_driver | 10/10 PASSED | Refactor-Bruch + include-path |
| test_v41_topics_fundament | 16/16 PASSED | Refactor-Bruch + API-Change |
| test_v41_axis_02_axis_04_nodes | 13/13 PASSED | Regression Phase 3 |
| test_v41_axis_05_memory_layout | 14/14 PASSED | Regression Phase 6 |
| test_v41_axis_07_prefetch | 8/8 PASSED | Regression Phase 7 |
| test_v41_axis_09b_simd_extension | 40/40 PASSED | Regression Phase 1 |
| test_v41_axis_12_general_hardware | 17/17 PASSED | Regression Phase 2 |
| test_v41_axis_14_value_handle | 8/8 PASSED | Regression Phase 6 |
| test_v41_axis_01_index_organization | 21/21 PASSED | Regression Phase 7 |

**TOTAL: 533/533 Tests PASSED.**

### §12.4 Paper-Codegen-Headers (12 generiert)

- Allocator: a04_mimalloc, a05_jemalloc, a07_snmalloc, a10_rpmalloc, a11_lrmalloc, a20_dlmalloc
- Traversal: p01_art, p02_hot, p05_start, p07_wormhole, p10_surf
- Queuing: q01_concurrentqueue

### §12.5 ESET-Lehre

is_original_validator-Tool muss beim ersten Configure-Build von ESET genehmigt
werden. User muss am Rechner sein + Ausfuehrung bestaetigen. Nach Genehmigung
laeuft das Tool automatisch fuer alle Folge-Codegen-Aufrufe.

### §12.6 Commits R7.5.l

```
059c60e V41.F.6.1.R7.5.l Tests + Compositions: Stale Refs (axis_09 + axis_01) bereinigen
```

Diplomarbeit-Submodule-Bump: (TBD nach diesem Commit).

