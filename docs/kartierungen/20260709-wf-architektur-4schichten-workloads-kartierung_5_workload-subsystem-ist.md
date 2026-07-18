Kartierung abgeschlossen. Hier der IST-Zustand mit datei:zeile und der vollständigen Consumer-Liste.

---

## Consumer-Liste `workload_matrix.hpp` (Grep über das ganze Repo)

Grep nach `workload_matrix` (alle Endungen) liefert genau **drei** Treffer — nur **einer** ist ein echter `#include`:

| datei:zeile | Art |
|---|---|
| `tests/unit/test_31_workload_matrix.cpp:7` | **einziger `#include`** (`#include <builder/workload_driver/workload_matrix.hpp>`) |
| `tests/unit/CMakeLists.txt:1814-1825` | Test-Build-Wiring (Target `test_31_workload_matrix`, linkt `Boost::mp11 comdare::workload_driver`) |
| `libs/cache_engine/include/cache_engine/measurement/measurement_category_axis.hpp:11` | **nur Prosa-Kommentar** (`// (workload_matrix.hpp): |Läufe| = W·D …`), kein Include |

Gegencheck `include.*workload_matrix` mit Ausschluss `tests/` → **„NONE outside tests/"**. Die Datei ist nicht in `workload_driver/CMakeLists.txt` genannt (header-only, wird nur von ihrem Includer gezogen).

Consumer der compile-time-Symbole selbst (`config_for`, `matrix_cells`, `ycsb_profile_list`, `workload_profile_list`, `dataset_list`): **ausschließlich** `workload_matrix.hpp` (Definition) + `test_31_workload_matrix.cpp` (Iteration/Asserts). Kein produktiver Consumer.

---

## 1. Wie Workloads HEUTE modelliert sind: runtime vs. compile-time

**Runtime ist das reale Modell** (der gesamte Mess-Pfad läuft hierüber):
- `WorkloadConfig` — POD mit `seed`/`num_operations`/`key_min`/`key_max`/Op-Mix-Prozenten/`key_distribution`; `workload_config.hpp:99`. Runtime-Struct, `is_valid()` runtime-geprüft (`:135`).
- `profile_by_name(tok, seed, ops)` — String-Token → `WorkloadConfig` per if/else-Kette über `"A".."F"/"IH"/"LH"`; `workload_profiles.hpp:23`. Unbekanntes Token → leerer `name` = „überspringen"-Marker (`:32-34`).
- `WorkloadGenerator` — Runtime-Objekt, xorshift64-PRNG, `generate_all()` materialisiert die Op-Sequenz zur Laufzeit; `workload_generator.hpp:32,55`.
- `WorkloadOrchestrator`: `run_workload_profile(...)` (`workload_orchestrator.hpp:65`) + `MeasurementPlan{ std::vector<WorkloadConfig> profiles }` (`:172`) + `run_measurement_plan(...)` (`:182`) — runtime über einen `std::vector<WorkloadConfig>`.

**Compile-time existiert NUR in `workload_matrix.hpp`:**
- `ycsb_profile_list` = `mp::mp_list<std::integral_constant<WorkloadKind, …>>` (6 YCSB A–F), `:66-72`; `workload_profile_list` = + IH/LH = 8, `:79-82`.
- `dataset_list` = mp_list aus `CanonicalDataset`-Tags (6), `:116-121`.
- `matrix_cells = mp::mp_product<mp::mp_list, workload_profile_list, dataset_list>` = 8×6 = **48** compile-time-Zellen, `:128`, `static_assert(matrix_cell_count == 48)` `:133`.
- `config_for(WorkloadKind, seed, ops)` — die einzige Brücke compile-time→runtime, delegiert via `ycsb_token()` bit-identisch an `profile_by_name`, `:86-90`.

Wichtig: Der Enum `WorkloadKind` wird **wiederverwendet** aus `builder/commands/workload.hpp:18` (kein eigener Workload-Enum); `workload.hpp` selbst ist reines Runtime-Datenmodell (`struct Workload{ kind; record_count; seed; … }`, `:40`).

## 2. Rolle von `workload_matrix.hpp` — verdrahtet oder toteliegend?

**Toteliegende / parallele Struktur.** Belege:
- Einziger Code-Consumer = `test_31_workload_matrix.cpp` (Include `:7`; iteriert `ycsb_profile_list`/`workload_profile_list`/`matrix_cells` per `mp_for_each` `:27,37,82`; prüft Kardinalität 6/8/48).
- Kein produktiver Include (Grep-Ausschluss `tests/` = leer). Nicht in einer produktiven CMake-Kompilationseinheit gezogen.
- Sie „beweist sich selbst" nur über `static_assert` (`:93-99, 131-134`) und wird vom Test durchzählt — aber **keine** Build-/Mess-Logik konsumiert die 48 Zellen.
- Der Header deklariert sich selbst explizit als **„golden/ABI-NEUTRAL … Workload ist Mess-INPUT, orthogonal zur Anatomie-Permutation"** (`:25-26`) und die compile-time-Liste als „wie eine DynamicVariableNode-Wertmenge des experiment_tree, **KEINE Binary-Identitäts-Achse**" (`:10-11`). Sie ist per Konstruktion nicht an die Permutation angeschlossen.

Kurz: ein compile-time-**Manifest** der Achsen-Wertemenge (+ typisierte Brücke `config_for`), das produktiv niemand liest.

## 3. Der PRODUKTIVE Mess-Pfad — String-AxisLevel-Injektion (`is_static=false`)

Der Produktiv-Pfad läuft komplett über Runtime-Strings, nicht über die compile-time-Matrix:

1. `discover_load_profiles(dir)` scannt `load_profiles/*.xml` → `[(id, pfad)]` = Wertemenge der dynamischen Workload-Achse (Achse 2); `load_profile_parser.hpp:120-133`.
2. In `run_profile(...)` wird die Achse als **dynamische** Ebene mit **String-Werten** in den Experiment-Baum injiziert: `basis_levels.push_back(ex::AxisLevel{"workload", a.workload_values, /*is_static=*/false, "workload_id", "workload"})`; `profile_run_entry.hpp:132-134`. `is_static=false` ⇒ verändert die `binary_id` **nicht** (`:130-131`).
3. `RunProfileArgs.workload_registry` (id→`WorkloadConfig`) wird „vom Host via `discover_load_profiles` gesetzt"; `profile_run_entry.hpp:74-76`. Analog `cache_engine_builder_iterator.hpp:81-84` (`std::map<std::string, wd::WorkloadConfig> workload_configs`; leer → Fallback auf `profile_by_name(env-String)`).
4. `run_workload_perm(..., std::string_view workload_id, …)` löst den **Runtime-String** auf: zuerst `registry->find(std::string(workload_id))` (XML-Config), sonst `wd::profile_by_name(workload_id, seed, n_ops)`; `perm_runner.hpp:204-229`. Danach `run_workload_profile` (Zwei-Phasen-Rollback).

Also: Achsen-Wert = Runtime-String `workload_id` → zur Laufzeit zu `WorkloadConfig` aufgelöst → `WorkloadGenerator`. Der compile-time-`WorkloadKind`/`matrix_cells`-Pfad wird an keiner Stelle berührt.

## 4. Wäre `mp_product(workload_profile_list, dataset_list)` konsistent oder ein Widerspruch?

Differenziert — es hängt daran, **wie** die Zellen konsumiert würden, nicht am `mp_product` an sich:

- **Als compile-time-Manifest der Domäne, das je Mess-Lauf runtime instanziiert wird** (genau die erklärte Absicht des Headers: „runtime instanziiert je Mess-Lauf (Hybrid)", `:126-127`): **konsistent** mit „Workloads=runtime". Es ist dann eine compile-time-**Beschreibung/Aufzählung** der Wertemenge der dynamischen Achse (+ typsichere `config_for`-Brücke zum selben runtime `profile_by_name`), keine compile-time-Vervielfältigung von Binaries. Deckt sich mit der Memory-Direktive „runtime Profile → Hybrid aus compile-time + runtime, passend zum Experiment-Baum" (DynamicVariableNode-Wertmenge compile-time aufgezählt, runtime instanziiert).

- **Als binary-identitäts-erzeugende Achse** (Zellen materialisieren distinkte Binaries / fließen in `binary_id` / speisen die Anatomie-Permutation wie die statischen Achsen): **Widerspruch**. Das verletzt `is_static=false` (`profile_run_entry.hpp:134`), die „golden/ABI-NEUTRAL"-Zusage (`workload_matrix.hpp:25`) und die Doktrin „Workload = Mess-INPUT ⊥ Build-Profil" (`workload_orchestrator.hpp:11`), und würde `binary_id`/`golden_fullpilot_320` sprengen. Datasets sind ebenso Runtime-Ladeeingaben (Dateien), keine Code-Identitäts-Achse.

Praktischer Ist-Befund: Die Frage ist heute **gegenstandslos**, weil die Matrix produktiv gar nicht konsumiert wird (test-only). In ihrer aktuellen Verwendung (Selbstbeweis per `static_assert` + `config_for`-Delegation an `profile_by_name`) steht sie nicht im Widerspruch zu „Workloads=runtime" — sie ist schlicht **unverdrahtet**.

---

**Ist-Zustand zusammengefasst:** Runtime-Modell (`WorkloadConfig`/`profile_by_name`/`WorkloadGenerator`/`MeasurementPlan`) trägt den gesamten Mess-Pfad; er wird über die dynamische String-Achse `workload`/`workload_id` (`is_static=false`, `discover_load_profiles`→XML→`AxisLevel`→`perm_runner::run_workload_perm`) getrieben. `workload_matrix.hpp` (compile-time `matrix_cells`/`ycsb_profile_list`/`config_for`) ist eine parallele, nicht in den Produktiv-Pfad verdrahtete Struktur, deren einziger Consumer der Unit-Test `test_31_workload_matrix.cpp:7` ist.