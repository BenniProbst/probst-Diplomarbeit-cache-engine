# F-EXTRA Status (Q.4)

**Stand:** 2026-05-21 (Q.4 unter V33-Architektur-Bezug)
**Quelle:** `docs/termine/20260508 Termin 7/Architekturentscheidungen_F1_F15.txt`, §F-EXTRA-1 bis F-EXTRA-8
**Trigger:** User-Direktive 2026-05-21 — Q-Phase implementieren

---

## §1 F-EXTRA-Status-Uebersicht

| F-EXTRA | Titel | Status | Implementations-Anker |
|---|---|---|---|
| **F-EXTRA-1** | Original-Compiler pro fremdem Algorithmus | ⚠️ **PENDING** (Cluster-Aufgabe #77) | siehe §2 Compiler-Matrix |
| **F-EXTRA-2** | Custom-Dataset-Generator | ✅ DONE V190 | `apps/ycsb_cli/` (V31) |
| **F-EXTRA-3** | Heuristik-Kompositionsmuster (DecisionLambdaTree) | ✅ DONE V149 | `libs/cache_engine/builder/decision_lambda_trees/` |
| **F-EXTRA-4** | ABI-stabiles C++23-Modul-Interface | ✅ DONE V177 | `libs/cache_engine/include/cache_engine/abi/` |
| **F-EXTRA-5** | CMake/Shell-Codegen (statt Python) | ✅ DONE V107 | `libs/cache_engine/builder/codegen/` (sh/bat) |
| **F-EXTRA-6** | DecisionLambdaTree pro Baustein | ✅ DONE V149 | gleicher Code wie F-EXTRA-3 |
| **F-EXTRA-7** | libs/-Layout (V30 Konsolidierung) | ✅ DONE V30.D.1-D.5 | `libs/{search_engine,cache_engine,execution_engine,common,test_infra}/` |
| **F-EXTRA-8** | Architekt-Direktive II (Lizenz-Reframing) | ✅ DONE V31.A | `NOTICE` |

**Bilanz:** 7/8 operational. Nur F-EXTRA-1 pending — Cluster-Aufgabe.

---

## §2 F-EXTRA-1 Compiler-Matrix pro Adapter

**Trigger:** F-EXTRA-1 Direktive (Termin 2): "Pro fremdem Algorithmus den Original-Compiler verwenden".

**Stand V31:** Hauptcompiler ist C++23 (MSVC 14.44 + GCC 13+ + Clang 16+). Pro Adapter kann ein abweichender Compiler erforderlich sein.

### §2.1 Adapter-Compiler-Anforderungen

| Adapter | Quelle | Min. Compiler | Notes |
|---|---|---|---|
| `P01-ART` (unodb) | github.com/laurynas-biveinis/unodb | GCC 11+ / Clang 13+ | C++20, Apache 2.0 |
| `P02-HOT` | github.com/speedskater/hot | GCC 9+ | C++17, Apache 2.0 |
| `P03-Masstree` | github.com/kohler/masstree-beta | GCC 7+ / Clang 8+ | C++11, MIT-like |
| `P04-CoCo-trie` | github.com/aboffa/CoCo-trie | GCC 11+ | C++20, **GPL-3 ⚠️** |
| `P05-START` | github.com/maximilianfent/START | GCC 9+ | C++17, Apache 2.0 |
| `P06-B2tree` (Schmeisser) | TU Muenchen-intern via Schuele | GCC 11+ | C++20, **No-LICENSE ⚠️** |
| `P06-bart-master` | Schuele 2024 (Mail Anhang) | GCC 11+ | C++20, **No-LICENSE ⚠️** |
| `P07-Wormhole` | github.com/wuxb45/wormhole | GCC 9+ | C, **GPL-3 ⚠️** |
| `P08-ART-Sync` (OLC) | unodb + Synchronization-Patches | GCC 11+ | C++20, Apache 2.0 |
| `P10-SuRF` | github.com/efficient/SuRF | GCC 9+ | C++17, BSD-3 |
| `P20-BTreesAreBack` | github.com/leanstore/leanstore | GCC 11+ | C++20, MIT |
| `P21-P22-Chen` (LEGACY_REIMPL) | Eigene Re-Impl | GCC 11+ / MSVC 14.30+ | C++20 |
| `P27-hp-soft` | Zhang/Grot Email-Anhang 2026-05-14 | C++17, GCC 11+ | unklare Lizenz, eigene Wrapper |
| `P28-Kuehn-DAMON` | Kuehn 2026-05-21 (siehe `Forschungsarbeiten/code/P28-Kuehn-DAMON/`) | C++17, GCC 7+ | Lizenz-Klaerung pending |
| `P30-HazardPointers` | Folly Hazard-Pointer | GCC 9+ / Clang 10+ | Apache 2.0 |
| `A01-A20` (Allokatoren) | Diverse | GCC 9+ bis GCC 13+ | siehe `02_allokator_matrix.md` |

### §2.2 Multi-Compiler-Build-Strategie

**Option A: Docker/Podman pro Compiler** (Cluster-Migration #77)

```dockerfile
# Beispiel: GCC9 fuer P02-HOT
FROM gcc:9 AS gcc9_builder
WORKDIR /build
COPY adapters/P02-HOT/ ./P02-HOT/
RUN cmake -B build -DCMAKE_CXX_STANDARD=17 P02-HOT/ \
 && cmake --build build -j

# Beispiel: GCC11 fuer P04-CoCo
FROM gcc:11 AS gcc11_builder
WORKDIR /build
COPY adapters/P04-CoCo-trie/ ./P04-CoCo-trie/
RUN cmake -B build -DCMAKE_CXX_STANDARD=20 P04-CoCo-trie/ \
 && cmake --build build -j
```

**Option B: CMake-toolchain.cmake pro Adapter** (kein Container)

```cmake
# adapters/P02-HOT/toolchain_gcc9.cmake (Beispiel)
set(CMAKE_C_COMPILER /usr/bin/gcc-9)
set(CMAKE_CXX_COMPILER /usr/bin/g++-9)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
```

Aufruf:
```bash
cmake -B build/p02_hot -DCMAKE_TOOLCHAIN_FILE=adapters/P02-HOT/toolchain_gcc9.cmake adapters/P02-HOT/
```

**Aktuelle Entscheidung:** Option B (CMake-Toolchain) als Sub-Build pro Adapter. Option A (Container) bleibt als Cluster-Backup wenn Compiler nicht auf Host verfuegbar.

### §2.3 Cluster-Provisioning-Spec (Backlog V34+)

**Vorraussetzungen Cluster-Migration #77:**
- Multi-Compiler-Pod auf Talos: GCC 9, 11, 13 + Clang 13, 16
- Pro Pod ein Build-Verzeichnis mit toolchain.cmake
- CI-Workflow `multi_compiler_build.yml` triggert pro Adapter den richtigen Compiler

**Backlog-Eintrag fuer V34+ Sprint:**
1. `Cluster/sessions/`: NEUE Session-Doku "F-EXTRA-1 Multi-Compiler Cluster-Setup"
2. Talos-Pod-Manifest pro Compiler-Version
3. CI-Pipeline-Update fuer Multi-Compiler-Matrix
4. Verifikation: jeder Adapter baut mit seinem Original-Compiler

---

## §3 V33-Integration-Status pro F-EXTRA

| F-EXTRA | V33-Integration |
|---|---|
| F-EXTRA-1 | wird via Cluster-Migration in V34+ adressiert |
| F-EXTRA-2 | YCSB-CLI generiert auch V32-Workloads (siehe `messung_driver/v32_orchestrator.hpp` Workload-Struct) |
| F-EXTRA-3 | DecisionLambdaTree wird im V33 Default-Lookup-Mechanik genutzt (auto_permutator) |
| F-EXTRA-4 | ABI-V1-zu-V2-Mapper in `cache_engine/abi/abi_v1_to_v2_mapper.hpp` (V32.EE.3) |
| F-EXTRA-5 | Codegen bleibt sh/bat (kein Python — Memory-Direktive bestaetigt) |
| F-EXTRA-6 | gleich F-EXTRA-3 (DecisionLambdaTree pro Baustein) |
| F-EXTRA-7 | V33 nutzt libs/-Layout fuer alle neuen Module (welch_t_test.hpp, default_lookup_registry.hpp) |
| F-EXTRA-8 | NOTICE-Update bleibt gueltig — V33 fuegt keine neuen 3rd-party-Quellen hinzu (eigene Welch-Impl, eigene Bridge) |

---

## §4 Querverweise

- Original F-EXTRA-Doku: `docs/termine/20260508 Termin 7/Architekturentscheidungen_F1_F15.txt`
- Konsolidierungs-Doku: `04_architekturentscheidungen_F1_F15.md` (§F-EXTRA)
- T-Phase Adapter-Status: `../adapters/T_PHASE_ADAPTER_STATUS.md`
- Cluster-Migration: `Cluster/sessions/` + INFRA-Task #77
- P28 Kuehn Code (NEU 2026-05-21): `../../Forschungsarbeiten/code/P28-Kuehn-DAMON/`

---

**Q.4 Akzeptanz-Kriterien erfuellt:**
- [x] 8 F-EXTRA-Status-Eintraege (§1)
- [x] F-EXTRA-1 Compiler-Matrix pro Adapter (§2.1)
- [x] Cluster-Provisioning-Spec als V34+ Backlog-Eintrag (§2.3)

**Ende docs/bausteine/09_f_extra_status.md (Q.4 DONE).**
