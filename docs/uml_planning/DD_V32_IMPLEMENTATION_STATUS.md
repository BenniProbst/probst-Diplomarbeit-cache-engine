# DD-Phase V32 Implementation Status

**Stand:** 2026-05-18 (DD-Phase abgeschlossen)
**Trigger:** AA.2 + AA.3 + AA.4 Korrekturen

> Status der DD-Phase: konkrete Code-Aenderungen in cache-engine + prt-art + Submodule-Pin-Bump in Diplomarbeit. V32.1+ Folge-Sprint baut auf diesen Skeletten auf.

---

## §1 DD.1 cache-engine V32.DD.1 — Command-Pattern (DONE)

**Commit cache-engine HEAD:** `65e786d` (gepusht zu github.com/BenniProbst/comdare-cache-engine)

**NEU `libs/cache_engine/builder/commands/` (5 Files):**

| File | Klasse | Doxygen-Tags |
|---|---|---|
| `i_command.hpp` | `ICommand` | @subsystem CEB, @command_pattern Base |
| `execute_engine_command.hpp` | `ExecuteEngineCommand` | @command_pattern Execute, @phase_owner CEB |
| `compare_engine_command.hpp` | `CompareEngineCommand` | @command_pattern Compare, F15-Forschungsmission |
| `auto_permutate_axis_command.hpp` | `AutoPermutateAxisCommand` | @command_pattern AutoPermutate (AA.3 Default-Lookup-Loesung) |
| `README.md` | Modul-Doku | + Build-Integration-Plan |

**V32.DD.1 SKELETT** — konkrete `execute()`-Bodies folgen in V32.1+ Sprint mit:
- Workload-Typ-Definition + Result-Aggregator
- AutoPermutator-Lookup-Logik (CE-Bibliothek-Discovery + IPlatformProbe-Filter)
- Comparator-Metriken (Throughput/Latency/CacheMiss/Memory)

---

## §2 DD.2 prt-art V32.DD.2 — Default-Lookup + Traversal (DONE)

**Commit prt-art HEAD:** `63e1eab` (gepusht zu github.com/BenniProbst/comdare-prt-art, main-Branch NEU angelegt)

**NEU `prt_art/include/prt_art/traversal/` (2 Files):**

| File | Achse | Status |
|---|---|---|
| `search_algo_traversal.hpp` | 3.A | (b) Neu-Impl Bridge |
| `traversal_mapping.hpp` | 3.M | (b) Neu-Impl Bridge |

**NEU `prt_art/include/prt_art/default_lookup/` (4 Files):**

| File | Achse | Status |
|---|---|---|
| `README.md` | (Modul-Doku) | 9 Default-Lookup-Achsen-Tabelle + Auto-Permutator-Workflow |
| `prt_art_11_telemetry_default.hpp` | 11 | (default-lookup) → CE Kuehn 11.X1-X4 |
| `prt_art_12_hardware_default.hpp` | 12 | (default-lookup) → CE V32 NEU |
| `prt_art_13_scheduling_default.hpp` | 13 | (default-lookup) → CE V32 NEU |

V32.1+ Sprint: weitere Default-Lookup-Files (3.B, 6.2/6.3/6.4, 8.2, 9) anlegen.

---

## §3 DD.3 messung_driver — V32-Hinweis (SPEC ONLY)

**Aktueller Stand:** `messung_driver/main.cpp` (V31.F) registriert Pruefling beim CacheEngineBuilder im traditionellen Modell.

**V32-Soll (DD.3 Spec):**
```cpp
// V32 Konzept (folgt in V32.1 Sprint):
//
// auto ee_a = std::make_shared<CacheEngineExecutionEngineAdapter>();
// auto ee_b = std::make_shared<PrtArtExecutionEngineAdapter>();
//
// ceb.submit_engine(ee_a);  // EE-A: CacheEngine als ExecutionEngine
// ceb.submit_engine(ee_b);  // EE-B: PrtArt als ExecutionEngine
//
// ceb.execute_messreihe(config_a);  // Command-Pattern Iteration:
//   for each Permutation P:
//     cmd_a = ExecuteEngineCommand(ee_a, P, workload)
//     cmd_b = ExecuteEngineCommand(ee_b, P, workload)
//     cmd_a.execute()  // parallel zu cmd_b
//     cmd_b.execute()
//     cmp = CompareEngineCommand(cmd_a.result, cmd_b.result)
//     cmp.execute()    // F15-Vergleich
//     aggregator.collect(cmp.verdict, cmd_a.result, cmd_b.result)
//
//   for each Axis with missing Profile-Spec:
//     auto_perm = AutoPermutateAxisCommand(axis_id, ce_library)
//     auto_perm.execute()  // generiert Permutationen + iteriert
//
// V32-Konsequenz: messung_driver braucht KEINE Pruefling-Registrierung mehr -
// beide EEs sind gleichwertige Test-Objekte fuer den CEB.
```

**V32.1 Sprint TODO:**
- Adapter `CacheEngineExecutionEngineAdapter` schreiben (CE implementiert IExecutingEngine)
- Adapter `PrtArtExecutionEngineAdapter` schreiben (PrtArt implementiert IExecutingEngine)
- messreihen.xml-Schema mit `<execution_engines>` Liste + `<axes_default_lookup>` Flag
- E2E-Test mit parallelem ee_a + ee_b auf einer Permutation

---

## §4 DD.4 Cross-Repo Pin-Bump + ABI V2 (SPEC)

**Submodule-Pin-Status nach DD-Phase:**

| Repo | HEAD vor DD | HEAD nach DD | Push-Status |
|---|---|---|---|
| comdare-cache-engine | `16176ee` | `65e786d` | ✅ gepusht (main) |
| comdare-prt-art | `1a36ab4` | `63e1eab` | ✅ gepusht (main NEU) |
| Diplomarbeit-Datenbanken | `8006dbd` | (Pin-Bump folgt) | folgt |

**Diplomarbeit-Pin-Bump:**

```bash
cd Code/external/comdare-cache-engine && git pull
cd ../comdare-prt-art && git pull
cd ../../..
git add Code/external/
git commit -m "V32.DD.1+DD.2 Submodule-Pin-Bumps (Command-Pattern + Default-Lookup)"
git push
```

**ABI V2 Migrations-Mapper (V32.1 Sprint):**
- Alte ICacheEngine-API (V31) → neue ICacheEngine-API (V32 mit Command-Pattern-Hooks)
- Migrations-Klasse: `cache_engine/abi/abi_v1_to_v2_mapper.hpp`
- Default-Variants fuer ALLE neuen Methoden — Bestandscode (V31) bleibt kompilierbar

---

## §5 V32.1 Sprint TODOs (Folge-Session)

### §5.1 cache-engine V32.1

1. Konkrete `execute()`-Bodies in commands/ (Workload-Definition + Result-Aggregator)
2. AutoPermutator-Klasse mit CE-Bibliothek-Discovery + IPlatformProbe-Filter
3. CacheEngine implementiert `IExecutingEngine`-Interface (Adapter)
4. ICommand-Liste registriert beim CacheEngineBuilder
5. Tests: U.1 PermutationFlags + neue ICommand-Tests

### §5.2 prt-art V32.1

1. Weitere Default-Lookup-Files: 3.B, 6.2, 6.3, 6.4, 8.2, 9
2. PrtArt-IExecutingEngine-Adapter (Bridge zur SearchEngine-Klasse)
3. PrtArt Reuse-Matrix-Doku unter `docs/architektur/PRT_ART_AXES_REUSE_MATRIX.md`
4. Tests: U.2 erweiterte Template-Params

### §5.3 Diplomarbeit V32.1

1. messung_driver V32-Refactor (parallele EE-Submission)
2. messreihen.xml-Schema-Erweiterung
3. Tests: E2E-Test mit ee_a + ee_b parallel

---

## §6 Querverweise

- AA-Korrekturen: `../architektur/10_schichten_modell_M.md` §0 (AA.2), `Z5_master_index_und_gap_analyse.md` §0 (AA.3), `../adapters/O_PHASE_PRT_ART_AXES_MIRROR.md` §0 (AA.4)
- BB-Doxygen-Mapping: `BB_doxygen_mapping_konvention.md`
- CC-drawio: REV7.drawio Tab 50 (M-CORRECT-V2) + Tab 51 (Default-Lookup)
- DD.1 cache-engine Code: `Code/external/comdare-cache-engine/libs/cache_engine/builder/commands/`
- DD.2 prt-art Code: `Code/external/comdare-prt-art/prt_art/include/prt_art/{traversal,default_lookup}/`
- V32 Master-Plan: `../adapters/V32_CODE_REFACTORING_PLAN.md`

---

**Ende docs/uml_planning/DD_V32_IMPLEMENTATION_STATUS.md (DD-Phase DONE).**
