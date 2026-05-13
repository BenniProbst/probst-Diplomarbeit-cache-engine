# Architektur-Delta REV 7.2 — 14 LEGACY_REIMPL Skelette ausgefuellt (2026-05-13)

**Status:** Delta-Erweiterung zu `24_architektur_skizze_REV7_2026_05_13.md`
**Anlass:** User-Direktive 2026-05-13: "B: 14 LEGACY_REIMPL Skelette ausfuellen"

---

## §1 Was wurde umgesetzt

Die 14 Skelette unter `comdare-cache-engine/prt_art/legacy_reimpl/` waren bislang
nur `pragma once`-Stubs mit `TODO Phase 5+`-Markern. Sie sind jetzt mit
funktionierenden C++23-Re-Implementations gefuellt (Original-Paper als
Konzept-Quelle, **kein** Copy aus den `ext/`-Originalrepos).

| # | Skelett | Paper | Concept | Header | Tests | Status |
|---|---|---|---|---|---|---|
| P11 | CSS-tree | Rao/Ross 1999 | Page | `css_node_page.hpp` | 6 | OK |
| P12 | CSB-tree | Rao/Ross 2000 | Page | `csb_node_group_page.hpp` | 4 | OK |
| P13 | Hankins | Hankins/Patel 2003 | Page | `wider_bplus_page.hpp` | 4 | OK |
| P14 | Samuel | Samuel et al. 2005 | Page | `config_table_bplus_page.hpp` | 4 | OK |
| P16 | Bender-TreeLayout | Bender et al. 2002 | MemoryLayout | `probability_layout.hpp` | 3 | OK |
| P17 | Bender-CacheOblivious | Bender et al. 2005 | MemoryLayout | `cache_oblivious_layout.hpp` | 3 | OK |
| P18 | Saikkonen-MultiLevel | Saikkonen 2008 | Allocator+Relocation | `multi_level_reloc.hpp` | 4 | OK |
| P19 | Saikkonen-LayoutInvariant | Saikkonen 2016 | MemoryLayout | `layout_invariant.hpp` | 6 | OK |
| P21 | Chen-PrefetchBPlus | Chen et al. 2001 | PrefetchStrategy | `prefetch_bplus.hpp` | 4 | OK |
| P22 | Chen-Fractal | Chen et al. 2002 | Page+PrefetchStrategy | `fractal_prefetch_bplus.hpp` | 4 | OK |
| P23 | Khan-AdaptivePrefetch | Khan 2010 | PrefetchStrategy | `adaptive_prefetch_distance.hpp` | 4 | OK |
| P24 | Naderan-Tahan | Naderan-Tahan 2016 | Telemetry | `useless_prefetch_study.hpp` | 5 | OK |
| P26 | Zhang-FGCS | Q. Zhang 2024 | Prefetch+Telemetry | `path_jumppointer_prefetch.hpp` | 4 | OK |
| P27 | Zhang-ASPLOS-Hierarchical | T. Zhang 2025 | PrefetchStrategy | `hierarchical_bundle_prefetch.hpp` | 5 | OK |

**Summe: 14 Headers + 14 Tests + 14 CMakeLists.txt = 42 Dateien, 60 neue Unit-Tests.**

---

## §2 Architektur-Konventionen

1. **Status-Codes errno-style** (`int`-Returns aus Schreiboperationen, analog
   `prt_art/identity/status.hpp` — siehe Delta REV 7.1):
   - `0` = success
   - `1` = key_already_exists
   - `2` = key_not_found
   - `4` = invalid_argument
   - `5` = capacity_exceeded
   - `7` = out_of_range
2. **Header-only** als `INTERFACE`-Library (`comdare::legacy_pNN_<name>`).
3. **CMakeLists.txt** registriert pro Skelett ein `comdare_add_test(...)`,
   das durch `gtest_setup.cmake` (cache-engine global) bereitgestellt wird.
4. **add_subdirectory(legacy_reimpl)** wurde in `prt_art/CMakeLists.txt`
   ergaenzt — vorher Skelett-Block ohne Subdir-Inkludierung.
5. **Cache-Line-Awareness:** `static_assert(sizeof(...)  <= kCacheLineBytes)`
   in Page-Familien (P11, P22).
6. **Concept-Anbindung** (REV 5 K05) via Namespace + Bausteine-Matrix-Verweis
   in jedem Header-Header-Kommentar.

---

## §3 Verifikation

```text
Build (MSVC 19.39, Visual Studio 17 2022, Debug C++23):
  alle 14 Test-EXEs gebaut, 0 compile errors.

Test-Run (jedem einzelne EXE direkt):
  P11: 6 tests OK
  P12: 4 tests OK
  P13: 4 tests OK
  P14: 4 tests OK
  P16: 3 tests OK
  P17: 3 tests OK   (VebLayout-Skelett mit BFS-basierter Top/Bottom-Layouting,
                     volles vEB-Layout folgt in Phase 5+)
  P18: 4 tests OK
  P19: 6 tests OK
  P21: 4 tests OK
  P22: 4 tests OK
  P23: 4 tests OK
  P24: 5 tests OK
  P26: 4 tests OK
  P27: 5 tests OK
  ────────────────
  Gesamt: 60 / 60 Tests PASSED
```

---

## §4 Offene Items

- **P17 echtes vEB-Layout** — aktuelles Skelett nutzt rekursive Top/Bottom-BFS
  als Vereinfachung; volle van-Emde-Boas-Rekursion mit
  `Math.sqrt(B)`-Hierarchie kommt in Phase 5+.
- **CTest-Integration** — die `gtest_discover_tests()`-Phase wirft
  `MSB3073`-Discovery-Errors, die jedoch nur kosmetisch sind (EXEs gebaut +
  laufen direkt). Behebung: separate ctest-Phase nach allen .exes oder
  expliziter `--no-pretty-values`-Workaround.
- **PRT-ART-Integration** — die 14 Skelette sind eigenstaendige Bausteine.
  Phase 7.2 (Permutations-Build-Pipeline) wird sie in PRT-ART-Permutationen
  als Achsen-Choices einbinden.

---

## §5 Querverweis

- REV 7 §2: 21 Allokator-Paper (A01-A23) — paralleler Recherche-Stack
- REV 7 §3.2: Pflicht-Container-Matrix-Tests fuer jeden Adapter
- Delta REV 7.1: Hybride `PrtArtSearchEngine` mit status_t errno-style
- Memory: [[feedback-phase-completeness-discipline]] (Phasen-Disziplin)
- Code: `comdare-cache-engine/prt_art/legacy_reimpl/P{11..27}/include/*.hpp`
- Tests: `comdare-cache-engine/prt_art/legacy_reimpl/P{11..27}/tests/*.cpp`
