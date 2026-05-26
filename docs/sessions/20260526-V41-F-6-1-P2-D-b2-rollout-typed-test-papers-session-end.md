# V41.F.6.1.P2.D.b2 Session-Ende — Roll-out + TYPED_TEST + Papers-Sortierung (2026-05-26 spaeter)

**Stand:** 2026-05-26 spaeter (Kontext-Ende nach 9 substantiellen Sub-Phasen)
**Vorgaenger:** `20260526-V41-F-6-1-P2-mass-sprint-session-end.md`
**Master-Doc:** `docs/architektur/13_paper_legacy_code_architektur.md` (jetzt 1010+ Zeilen, 4-teilig A+B+C+D)
**Pflicht-Pre-Read fuer naechste Session:** dieses Dokument + Doku 13 Teil C+D + Memory `[[cross-axis-defaults-no-bloat]]`

---

## §1 Session-Zusammenfassung — 9 Sub-Phasen (Fortsetzung Mass-Sprint)

Diese Session begann nach Audit-Pause der vorigen Session ("8 Phasen abgeschlossen"). Sie liefert die Fortsetzung mit weiteren Roll-out + Pattern-Disziplin-Refactors auf direkte User-Kritik:

1. **Konsistenz-Audit** der letzten 3 User-Unterbrechungen (alle ✅)
2. **P2.D Roll-out 1**: jemalloc + snmalloc (tcmalloc deferred)
3. **User-Kritik #1** (Property-Redundanz + Code-Bloat + CMake-Flag-Fehlend): P2.C-Refactor
4. **User-Kritik #2** (49 Wrappers vs Realitaet — viele haben Source!): Audit + Roll-out
5. **Phase A** TYPED_TEST_SUITE Refactor (Test-Bloat raus)
6. **Phase B** Allocator-Roll-out Batch 2 (dlmalloc + rpmalloc + lrmalloc)
7. **Phase C** Audit andere Achsen (traversal hat P0X-Submodule!) — als TODO
8. **Phase D** Papers-Sortierung Diplomarbeit/Forschungsarbeiten/ (37 PDFs → 6 Topic-Ordner)
9. **Phase E** Doku 13 Teil C+D + Memory-Updates fuer ALLE Session-Themen

---

## §2 P2.D Roll-out 1 — jemalloc + snmalloc

Pattern analog mimalloc-Pilot, manuelle Block-Wiederholung (vor User-Kritik):

| Paper | get_compiler | Source-File | Tool-Output |
|---|---|---|---|
| A05 JemallocAllocator | "gcc-9.5" | src/jemalloc.c (je_aligned_alloc + je_free) | ALL ORIGINAL |
| A07 SnmallocAllocator | "clang-12" | src/snmalloc/global/libc.h (aligned_alloc + free_aligned_sized) | ALL ORIGINAL |

**Wichtig:** snmalloc nutzt C++ namespace (snmalloc::libc::) — Tool-Regex-Auto-Discovery
funktioniert trotzdem (nicht nur `extern "C"` Symbole). A06 tcmalloc DEFER (Bazel-Mangling).

**Commit:** cache-engine `f3e3d8a`, Diplomarbeit `22296b2`.

---

## §3 User-Kritik #1 — P2.C-Refactor (Property-Redundanz + Code-Bloat + CMake-Flag)

User-Stop (verbatim):
> "Das sieht aber noch nicht nach einer compile time dynamischen Auswertung der
> Code-Validitaet aus, das ist einfach hardcoded. Wo ist das cmake flag fuer alle
> Funktionen, welches mit der app die Originalitaet beweist? `is_original_module` ist
> keine Metaprogrammierung, welche die Originalen Funktionen ueber ein AND prueft.
> [...] Weiterhin ist das doppelt, weil entweder ist der paper code original und
> damit auch das Modul UND UMGEKEHRT. [...] Das ist Code-Bloat statt generischer
> Modularisierung!"

**3 Kritikpunkte adressiert:**

| Kritik | Loesung |
|---|---|
| Redundanz `has_original_paper_code` + `is_original_module` | `has_original_paper_code` komplett entfernt (eine Property reicht) |
| Hardcoded `false` 10× in CRTP-Bases/q2-Wrappers | `AxisBase::is_original_module() = false` Default → 0 hardcoded |
| Fehlt zentrales CMake-Flag | `option(COMDARE_CE_ENABLE_ORIGINAL_CODE_VALIDATION ON)` neu |

**Refactor-Mass:** AxisBase erweitert + LegacyOriginalCodePflicht reduziert + 6 Achs-Permutation-Concepts ergaenzt + mimalloc-using bereinigt + 10 CRTP-Bases/q2-Defaults revertet + Tests angepasst. 587/587 grün.

**Commits:** cache-engine `41b643c`, Diplomarbeit `23bb18c` + Doku 13 Teil C `4ef66c8`.

---

## §4 User-Kritik #2 — Allocator hat dutzende Paper, nicht 3

User-Stop (verbatim):
> "Hast du geprueft, ob die uebrigen Allokator Achse Algorithmen wirklich keine valide
> Implementierung haben? Du ruehmst dich damit 49 redundante Eigenschaften aus dem Weg
> geraeumt zu haben...Wir haben also noch nicht alle Paper-source-codes in die
> Allokator Achse per Pilot-Vorlage eingebunden. Fuer Allokatoren gibt es dutzende
> Paper mit source code, bitte pruefe auch alle uebrigen Achsen [...] Mir ist bei den
> letzten Tests aufgefallen, dass wir wieder sehr aehnliche Code bloat Tests haben,
> die wir per template Tests kompakter darstellen koennen."

**Audit-Ergebnis ext/:**

| ext/ Vendor | Wrapper | Vorher | Heute Roll-out |
|---|---|---|---|
| ext/A04-mimalloc | MimallocAllocator | ✅ P2.B | — |
| ext/A05-jemalloc | JemallocAllocator | ✅ P2.D | — |
| ext/A06-tcmalloc | TCMallocAllocator | DEFER | — |
| ext/A07-snmalloc | SnmallocAllocator | ✅ P2.D | — |
| **ext/A20-dlmalloc** | **DlmallocAllocator** | nicht | **✅ P2.D.b2** |
| **ext/A10-rpmalloc** | **RPMallocAllocator** | nicht | **✅ P2.D.b2** |
| **ext/A11-lrmalloc** | **LRMallocAllocator** | nicht | **✅ P2.D.b2** |
| ext/A01-hoard | HoardAllocator | nicht | DEFER P2.D.t2 (Custom-Shim) |
| ext/A03-michael-lockfree | MichaelLockFreeAllocator | nicht | DEFER P2.D.t2 (Custom-Shim) |
| ext/A08-scalloc | ScallocAllocator | nicht | DEFER P2.D.t2 (Custom-Shim) |

**Plus Entdeckung:** ext/ enthaelt **auch P0X-Submodule** fuer traversal-Wrappers!
- ext/P01-ART/unodb → Array256 (Leis ICDE 2013)
- ext/P02-HOT/hot → VectorU8U8 (Binna PVLDB 2018)
- ext/P05-START/START → VectorU16U16 (Mertens ICDE 2024)
- + P03 Masstree, P04 CoCo-trie, P06 B²-tree, P07 Wormhole, P10 SuRF, P20 BTreesAreBack, P25, P29 RCU, P30 HazardPointers

---

## §5 Phase A — TYPED_TEST_SUITE Refactor (Test-Bloat raus)

Vorher: pro Paper-Wrapper 4-5 redundante Smoke-Tests (TEST(P2B_MimallocPilot, ...),
TEST(P2D_JemallocPilot, ...), TEST(P2D_SnmallocPilot, ...)) — 3 × 4-5 = 12-15 kopierte Tests.

Nachher TYPED_TEST_SUITE:
```cpp
using PaperWrapperList = ::testing::Types<
    MimallocAllocator, JemallocAllocator, SnmallocAllocator,
    DlmallocAllocator, RPMallocAllocator, LRMallocAllocator
>;
template <typename W> class PaperWrapperConformance : public ::testing::Test {};
TYPED_TEST_SUITE(PaperWrapperConformance, PaperWrapperList);

TYPED_TEST(PaperWrapperConformance, AxisBaseConcept) { ... }
// 8 Tests total
```

Plus analog `NonPaperWrapperDefaults` (5 Tests × 6 Wrappers cross-topic).

**Effekt:** bei Roll-out weiterer Paper-Wrappers nur Type-List erweitern → automatisch 8 weitere Tests.

---

## §6 Phase B — Allocator-Roll-out Batch 2 (3 Wrappers)

Pattern-disziplin via **Helper-Funktion** `comdare_register_paper_wrapper()` (in cmake/is_original_codegen.cmake). Pro Paper 1 Aufruf statt 12-Zeilen-Block.

| Paper | get_compiler | Source-File | Paper-API |
|---|---|---|---|
| A20 DlmallocAllocator | "gcc-9.5" | malloc.c | public_mEMALIGn + public_fREe (via #define) |
| A10 RPMallocAllocator | "gcc-9.5" | rpmalloc/rpmalloc.c | rpaligned_alloc + rpfree |
| A11 LRMallocAllocator | "gcc-9.5" | lrmalloc.cpp (C++!) | lf_aligned_alloc + lf_free |

**Wichtig:** dlmalloc nutzt Preprocessor-Renames (`#define public_fREe dlfree`). Tool sucht im Source vor Preprocessing → Manifest mit `paper_fn = public_fREe`. lrmalloc ist C++ — Tool funktioniert auch fuer `extern "C"` Functions im .cpp.

**Pro Wrapper:** legacy_code-Skelett (5-6 Files) + CMakeLists-Helper-Aufruf + Wrapper-Refactor (include + Inheritance + 4 using-Statements).

**Commit:** cache-engine `aba3da4`, Diplomarbeit `96b52d0`.

**DEFER P2.D.t2** (separater Sprint Task #685): A06 tcmalloc, A01 Hoard, A03 Michael-LF, A08 Scalloc.

---

## §7 Phase C — Andere Achsen Audit (traversal Roll-out TODO #686)

**TODO P2.D.tr Plan:**
- ext/P01-ART/unodb → Array256 Wrapper Inherit-Refactor
- ext/P02-HOT/hot → VectorU8U8 Wrapper
- ext/P05-START/START → VectorU16U16 Wrapper
- SearchAlgoOriginalCodeMixin (P2.F) bereits da — Tool generiert 4-Function PaperManifest

**TODO P2.D.q Plan (Task #687):** queuing-Achse Audit fuer DeltaChain (Bw-Tree Levandoski), SkiplistBuffer (RocksDB), EpochBuffer (SMART ART OSDI 2023), AdaptiveLsmFlush (RocksDB DynamicLevel) — Paper-Source-Verfuegbarkeit pruefen.

---

## §8 Phase D — Papers-Sortierung Diplomarbeit/Forschungsarbeiten/

37 Papers in 6 Topic-Unterordner ([[never-delete-documentation]]: git mv, nie loeschen):

| Topic-Unterordner | Anzahl | Inhalt-Beispiele |
|---|:-:|---|
| traversal/ | 17 | ART, HOT, START, B+/B²/CSB+-Trees, CoCo-trie, SuRF, Wormhole, Masstree |
| prefetch/ | 8 | Hardware/Software-Prefetching + Fractal B+ + Aprefetching + Zhang ASPLOS 2025 |
| concurrency/ | 3 | Hazard Pointers, RCU, ART of Practical Synchronization |
| memory_layout/ | 5 | Cache-Sensitive Layouts (×2), Tree Layout Multilevel, Space-efficient static trees |
| general/ | 1 | Overview Hardware Optimizations |
| hardware/ | 1 | vampir-poster (ZIH) |

**Special-Char-Notiz:** 4 Files mit Non-Breaking Space im Namen → via `find -exec mv` statt `git mv` (gleicher Effekt, git rename-detection greift).

**Commit:** Diplomarbeit `8c5fad2`.

---

## §9 Phase E — Doku 13 Teil D + Memory-Updates

**Doku 13 Teil D** (§20-§25, +131 Zeilen):
- §20 Helper-Refactor `comdare_register_paper_wrapper()`
- §21 TYPED_TEST_SUITE Refactor
- §22 Roll-out Status 24 Allocator-Wrappers
- §23 Traversal-Achse Roll-out TODO
- §24 Papers-Sortierung Diplomarbeit/Forschungsarbeiten/
- §25 Tests-Stand Endstand

**Commit Diplomarbeit:** `c240145`.

**Memory-Updates:**
- `[[cross-axis-defaults-no-bloat]]` erweitert um TYPED_TEST + Helper-Pattern als Beispiele
- `[[paper-original-code-pattern]]` Roll-out-Status (6/10 integriert, 4 deferred, 14 ohne ext)

---

## §10 Tests-Bilanz Endstand

| Test-Target | Vorher (P2.D b1) | Nachher (P2.D.b2) | Delta |
|---|:---:|:---:|:---:|
| test_v41_topic_allocator_axis_06 | 252 | 252 | 0 |
| test_v41_topic_queuing | 205 | 205 | 0 |
| test_v41_topic_traversal | 95 | 95 | 0 |
| test_v41_paper_legacy_code | 41 (vor Refactor) | **102** | **+61** |
| **TOTAL cache-engine** | **593** | **654** | **+61** |

Davon:
- TYPED_TEST PaperWrapperConformance: 8 × 6 Wrappers = 48 Tests
- TYPED_TEST NonPaperWrapperDefaults: 5 × 6 Wrappers = 30 Tests
- Andere alte Tests: 24
- = 102 ✓

Diplomarbeit-Container: 104/104 unveraendert.

---

## §11 Commits Endstand heute (chronologisch)

| # | Commit | Repo | Inhalt |
|:-:|---|---|---|
| 1 | `f3e3d8a` | cache-engine | P2.D Roll-out 1 (jemalloc + snmalloc) |
| 2 | `22296b2` | Diplomarbeit | Submodule-Bump P2.D |
| 3 | `41b643c` | cache-engine | P2.C Refactor (Concept-Reduktion + CMake-Option) |
| 4 | `23bb18c` | Diplomarbeit | Submodule-Bump P2.C |
| 5 | `4ef66c8` | Diplomarbeit | Doku 13 Teil C |
| 6 | `aba3da4` | cache-engine | TYPED_TEST + 3 weitere Paper-Wrappers (Batch 2) |
| 7 | `96b52d0` | Diplomarbeit | Submodule-Bump P2.D.b2 |
| 8 | `8c5fad2` | Diplomarbeit | Papers-Sortierung Forschungsarbeiten/ (35 git renames) |
| 9 | `c240145` | Diplomarbeit | Doku 13 Teil D |
| 10 | (pending) | Diplomarbeit | **Diese Session-End-Doku** |

---

## §12 Architektur-Endstand P2.D.b2

| Sub-Task | Status | Bemerkung |
|---|---|---|
| ~~P2.A0.x~~ Tool-Refactor | ✅ vorherige Session | 4 Iterationen |
| ~~P2.C.1~~ AxisBase Mass-Update | ✅ vorherige Session | 10 Files |
| ~~P2.E~~ Doku 13 Teil B | ✅ vorherige Session | 478 Zeilen |
| ~~P2.F~~ 12 Achsen-Mixin-Templates | ✅ vorherige Session | 6 Achsen × 2 |
| ~~P2.A~~ CMake-Infrastruktur | ✅ vorherige Session | 4 Module + Helper |
| ~~P2.B~~ mimalloc Pilot | ✅ vorherige Session | First Pilot |
| ~~P2.C~~ Refactor + Concept-Pflicht | ✅ **heute** | 6 Concept-Anhaenge + AxisBase Default |
| ~~P2.D~~ Roll-out 1 (jemalloc/snmalloc) | ✅ **heute** | tcmalloc deferred |
| ~~P2.D.b2~~ Roll-out 2 (dlmalloc/rpmalloc/lrmalloc) | ✅ **heute** | + TYPED_TEST + Helper |
| ~~Papers-Sortierung~~ | ✅ **heute** | 37 PDFs / 6 Topic-Ordner |
| ~~Doku 13 Teil C+D~~ | ✅ **heute** | +284 Zeilen total |
| **P2.D.t2** Hoard/Michael-LF/Scalloc/tcmalloc | **pending** Task #685 |
| **P2.D.tr** traversal Array256/VectorU8U8/VectorU16U16 | **pending** Task #686 |
| **P2.D.q** queuing DeltaChain/Skiplist/Epoch/AdaptiveLsm | **pending** Task #687 |

---

## §13 Detaillierte Pending-Tasks fuer naechste Session

### Prioritaet HOCH

**Task #686 P2.D.tr Traversal Roll-out** (substantieller Sprint, 3 Wrappers):
1. Audit P01-ART/unodb Source-Function-Names: vermutlich UnoDB-Templated-API
   (z.B. `unodb::db<...>::insert/find/remove`)
2. Audit P02-HOT/hot: HOTRowex insert/lookup/remove
3. Audit P05-START/START: ART-Variant
4. legacy_code/paper_p01_art/ + paper_p02_hot/ + paper_p05_start/ Skelett (5-6 Files je)
5. CMakeLists Helper-Aufrufe (analog Allocator)
6. Wrapper-Refactor in Array256/VectorU8U8/VectorU16U16 (Inheritance vom Mixin + using fuer 4-Function-API)
7. TYPED_TEST PaperWrapperList erweitern (Array256/VectorU8U8/VectorU16U16 hinzu)

**Achtung:** Achsen-Mixin `SearchAlgoOriginalCodeMixin` (P2.F) hat 4 Functions
(`insert/lookup/erase/clear`) — Tool-Output muss 4-Felder-PaperManifest erzeugen.
Funktioniert prinzipiell, aber pruefen.

### Prioritaet MITTEL

**Task #685 P2.D.t2 Deferred Allocator** (4 Wrappers, hoeher Komplex):
- A06 tcmalloc: Bazel-Build, Symbol-Mangling — eventuell Bazel-Adapter oder
  Source-Snapshot der tatsaechlichen Function-Definitionen (CamelCase-Methods)
- A01 Hoard: Custom-Shim hoard_memalign — Original-Symbol `Hoard::xxmalloc` o.ae.
- A03 Michael-LF: Custom-Shim michael_lf_alloc — Original Header-only Michael & Scott
- A08 Scalloc: Custom-Shim scalloc_malloc — Original C++ namespace
Pro Wrapper: Strategie-Entscheidung notwendig (eventuell Shim-File selbst als manifest source).

**Task #687 P2.D.q Queuing-Audit:**
- DeltaChain (Bw-Tree Levandoski 2013) — Microsoft Bw-Tree Repo verfuegbar?
- SkiplistBuffer (LSM RocksDB) — RocksDB als ext-Submodul?
- EpochBuffer (SMART ART Wang OSDI 2023) — Paper-Repo?
- AdaptiveLsmFlush (RocksDB DynamicLevel) — analog RocksDB

### Prioritaet NIEDRIG

- Memory-Update: `[[forschungsarbeiten-topic-sortierung]]` als neues Memory anlegen
  (Pattern-Disziplin: Papers strikt nach Topic-Achse organisieren, nicht flach)
- Test-Verification: alle 654 cache-engine Tests + 104 Diplomarbeit grün nach
  jedem Roll-out-Batch

---

## §14 Lessons-Learned heute (4 Hauptpunkte)

1. **Voreilig "fertig"-Klassifikation gefaehrlich** — Ich behauptete "49 Wrappers
   brauchen 0 Code", aber 6 davon hatten **echte Paper-Source in ext/**! Audit-Pflicht
   vor solchen Verallgemeinerungen: pruefen welche ext-Submodule wirklich existieren.

2. **TYPED_TEST_SUITE skaliert linear** — Vor Refactor: 5 Tests × 6 Wrappers = 30 Code-
   Tests + Auto-skalierung NULL. Nach Refactor: 8 Test-Funktionen + Type-List → 48 Tests
   automatisch + bei Roll-out auto-skaliert. Pattern-Disziplin fuer alle zukuenftigen
   Cross-Wrapper-Tests.

3. **CMake-Helper-Funktion ist Pflicht-Pattern bei N≥3 Roll-outs** — Helper
   `comdare_register_paper_wrapper()` ersetzt 12-Zeilen-Block pro Paper. Bei 6 Wrappers:
   72 Zeilen → 60 Zeilen (incl. Helper-Definition). Bei 10+ Wrappers (vollausgebaut):
   massiv kompakter + Single-Source-of-Truth fuer Pattern-Aenderungen.

4. **C++ namespace-Functions funktionieren mit Tool** — snmalloc::libc::aligned_alloc
   wurde von Tool-Regex `\baligned_alloc\s*\(` korrekt gefunden. Auch dlmalloc mit
   Preprocessor-Renames (`#define public_fREe dlfree`) klappt — Tool sucht im Source
   vor Preprocessing. Pattern ist robust gegen verschiedene C/C++ API-Stile.

---

## §15 Repo-Stand Endstand heute

| Repo | HEAD | Aenderung heute |
|---|---|---|
| Diplomarbeit (PUBLIC) | `c240145` (+ pending Session-Doku) | 5 Commits: 3 Submodule-Bumps + Doku 13 Teil C/D + Papers-Sortierung |
| cache-engine standalone | `aba3da4` | 3 Code-Commits (Roll-out 1 + P2.C-Refactor + Roll-out 2) |
| prt-art | unveraendert | — |

---

## §16 Naechste Session beginnt mit

**Pflicht-Pre-Read (in dieser Reihenfolge):**
1. `MEMORY.md` (Index)
2. **Dieses Dokument** (`20260526-V41-F-6-1-P2-D-b2-rollout-typed-test-papers-session-end.md`)
3. `docs/architektur/13_paper_legacy_code_architektur.md` (4-teilig A+B+C+D, 1010+ Zeilen)
4. Memory `[[cross-axis-defaults-no-bloat]]` (Pattern-Disziplin, ergaenzt um TYPED_TEST)
5. Memory `[[paper-original-code-pattern]]` (Roll-out-Status 6/10)
6. Memory `[[axis-base-pattern]]` (Wurzel-Pattern + is_original_module Default)
7. Memory `[[compile-time-only-no-runtime]]` (kritische Pflicht-Direktive)

**Build-Verifikation:** 252 + 205 + 95 + 102 = **654 cache-engine gruen** + **104 Diplomarbeit gruen**.

**Empfohlene Start-Reihenfolge (3 TODO-Tasks):**
1. **P2.D.tr** Task #686 (traversal Roll-out — substantieller Sprint)
2. **P2.D.t2** Task #685 (4 deferred Allocator — strategie-abhaengig)
3. **P2.D.q** Task #687 (queuing-Audit — wenn ext-Source verfuegbar)

---

## §17 Forschungsarbeiten/ Endstand (Diplomarbeit-Reorganisation)

37 Papers in 6 Topic-Unterordnern + 2 vorhandene (code/ + low priority/):

```
Diplomarbeit/Forschungsarbeiten/
├── traversal/         (17)  ART, HOT, START, B+/B²/CSB+, CoCo-trie, SuRF, Wormhole, Masstree
├── prefetch/          (8)   Hardware/Software-Prefetching + Fractal-B+ + Zhang ASPLOS 2025
├── concurrency/       (3)   Hazard Pointers + RCU + ART of Practical Sync
├── memory_layout/     (5)   Cache-Sensitive Layouts + Tree Layout Multilevel
├── general/           (1)   Overview Hardware Optimizations
├── hardware/          (1)   vampir-poster ZIH
├── code/              (existing) — P0X Source-Code (ART/HOT/Masstree/CoCo-trie/START/B²/Wormhole/ARTSync/LOUDS/etc)
└── low priority/      (existing) — spaeter zu sichten
```

---

**Ende Session-End-Doku 2026-05-26 spaeter (9 Sub-Phasen Endstand P2.D.b2).**
