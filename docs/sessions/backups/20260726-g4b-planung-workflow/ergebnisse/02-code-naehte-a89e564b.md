Verification complete. Findings below.

---

## (0) Pfad-Korrektur (2 der 6 Lesepfade im Auftrag existieren nicht)

| Auftrag | Ist (literal) |
|---|---|
| `builder/cache_engine_builder_iterator.hpp` | `builder/experiment_tree/cache_engine_builder_iterator.hpp` (1305 Z.) |
| `builder/build_orchestrator.hpp` | `builder/build_orchestrator/build_orchestrator.hpp` |
| `bestandslog/bestandslog_document.hpp` -> `make_planer_block_reservation` | **NICHT dort.** Liegt in `profile_facade/planner/experiment_plan_director.hpp:1263-1270` |

---

## (a) Die 4 Agent-Fakten

**1. `bestand_key_of`-Signatur — BESTAETIGT.**
`experiment_tree/cache_engine_builder_iterator.hpp:216`
```cpp
std::function<std::optional<std::string>(std::filesystem::path const&)> bestand_key_of;
```
Konsument: `:964` `auto const key = cfg.bestand_key_of(b.output);` -> `lager.observe(key.value_or(std::string{}), ...)` (`:969`). nullopt => leerer Key => keine Registrierung. Gate `bestandslog_active` an `:927-929` = `transport.fetch && transport.store && bestand_key_of && !bestand_doc_key.empty()`.
*Achtung Namens-Kollision:* `ex::FingerprintFn` (`build_orchestrator.hpp:174`) ist `std::function<std::string(std::string const&)>` (binary_id -> hex), also ein ANDERER Typ als `bestand_key_of`. `make_fingerprint_key_fn()` muss den `path`-Typ liefern, nicht `FingerprintFn`.

**2. `fingerprint_sidecar_path` — BESTAETIGT, aber falscher Header/Namespace fuer (A).**
`build_orchestrator/build_orchestrator.hpp:298-300`, `namespace ...builder::experiment` (`:56`), `return path{output.string() + ".fingerprint"}`. Schreiber: `write_fingerprint_sidecar` `:303-307` (nur bei `status==0`), injiziert via `set_fingerprint_provider` (`:330`), gesetzt in `cache_engine_builder_iterator.hpp:938`.

**3. `make_bestand_transport` — BESTAETIGT.**
`bestandslog/artifact_cache_transport.hpp:37-53`, nimmt `artifact_transport::ArtifactCache const&`, haelt **Referenz** (Lebensdauer-Vertrag Z. 20-24), belegt alle 4 Verben. Datei ist heute 55 Zeilen; einziger Includer ist der Test (`test_g3_artifact_cache_transport.cpp:16`).

**4. „Treiber injiziert Cache" — TEILWEISE WIDERLEGT.**
Der Treiber baut den Cache (`main.cpp:840`, `shared_ptr<ArtifactCache>`), injiziert aber **nicht den Cache**, sondern nur 4 Closures. Und: Die Injektion in `xa`/`pa` liegt **nicht** bei :852-863 (dort werden nur die Closures gebaut, `:852-876`), sondern bei **`:962-968` (xa)** und **`:1056-1062` (pa)`**.

---

## (b) Naht-Risiken

**R1 (BLOCKER fuer B+D): Die Naht ist DREI-schichtig, (B) nennt nur eine Schicht.**
Der Treiber setzt `pf::ProfileRunArgs` / `pf::ExperimentRunArgs` — definiert in **`profile_run_facade.hpp:35` bzw. `:111`** (`cache_push/pull/measurement_sink` dort `:75-77` / `:140-142`). Erst `profile_run_facade.cpp:559-561` (in `run_profile_facade`, ab `:404`) bzw. `:907-909` (in `run_experiment_profile_facade`, ab `:787`) kopiert sie in die Entry-Args (`profile_run_entry.hpp:72 RunProfileArgs`, Felder `:98-100`), und erst `make_cfg` (`profile_run_entry.hpp:434`) in die `LazyRunConfig`. Fuer die vom Treiber sichtbare Verdrahtung muessen also **mindestens 3 Dateien** angefasst werden: `profile_run_facade.hpp` + `profile_run_facade.cpp` + `profile_run_entry.hpp`. Der genehmigte Schnitt (B) nennt nur die letzte.

**R2 (BLOCKER fuer d1 „xa"): Der Experiment-Pfad hat gar keine bestand-Naht.**
`grep 'bestand' experiment_run_entry.hpp` = **0 Treffer** — kein `bestand_fingerprint_fn`, kein `bestand_zelle`, nichts. `xa.bestand_* = ...` kompiliert nicht ohne zwei weitere, nicht genehmigte Dateien (`profile_run_facade.hpp` ExperimentRunArgs + `experiment_run_entry.hpp`). Entweder (d1) auf `pa` beschraenken oder den Schnitt erweitern.

**R3 (Byte-Neutralitaets-Beweis ist heute trivial erfuellt):**
Repo-weiter grep nach `bestand_transport =` / `bestand_key_of =` / `bestand_doc_key =` / `bestand_owner_uuid =` / `bestand_maschine =` / `bestand_present =` -> **0 Treffer**. `bestandslog_active` (`:927`) ist heute IMMER false; auch `run_planer_driven_provision` (`:980`) und der Lager-Flush (`:992-997`) sind tot. Jede neue Belegung ist daher der erste scharfe Pfad ueberhaupt.

**R4 (doppelte ArtifactCache-Instanz — real, aber praezedenziert):**
Die `--emit-tier-*`-Zweige liegen in der argv-Schleife `main.cpp:320` und **`return`en**, lange bevor `artifact_cache` bei `:840` entsteht. (d2) braucht dort zwingend eine **zweite** `ArtifactCache::from_env()`. Praezedenz existiert: `main.cpp:779` (`atp::ArtifactCache::from_env()` im Prune-Pfad). Unschaedlich, weil `object_fetch/store/remove/stat` (`artifact_cache.hpp:486/506/534/...`) den `object_key` **ohne** `run_stamp_` bilden; `run_stamp_` (`:185`) betrifft nur `sink_measurement` (`:460`) und `push_chunk_partial_marker` (`:434`). Kosten: 1 zusaetzlicher `from_env()`-Scan, kein Key-Drift.

**R5 (Env-Forwards: VORHANDEN, Treiber kennt sie NICHT).**
`experiment_plan_director.hpp:734-737` forwarded literal `COMDARE_BESTANDSLOG`, `_DOC_KEY`, `_OWNER_UUID`, `_MASCHINE` (+ `COMDARE_VARIANT_GATE` `:738`), byte-gewacht in `tests/unit/thesis_tiere/test_experiment_plan_director.cpp:657-659, 763-778`. **Aber:** `grep COMDARE_BESTANDSLOG 02_messung_driver/main.cpp` = **0 Treffer**; einziger Leser ist heute `profile_run_entry.hpp:312` (nur der bool-Schalter). `_DOC_KEY/_OWNER_UUID/_MASCHINE` werden von **niemandem** gelesen — reine Durchreiche ins Leere. (d1)/(d2) muessen sie im Treiber erstmals auswerten; die Namen sind durch die Forward-Liste + Byte-Wache bereits fixiert (kein neuer Name erfinden).

**R6 (L2-Id kollidiert mit dem existierenden Helfer):**
`make_planer_block_reservation(std::string owner_uuid, std::size_t seq, ...)` (`experiment_plan_director.hpp:1263-1270`) baut die id hart als `owner_uuid + "/" + std::to_string(seq)`. Die geforderte L2-Form `owner_uuid + "/plan/" + doc_key` ist damit **nicht erzeugbar**. Entweder direkt `bl::make_pro_forma_reservation(id, BatchTyp::planer_block, maschine, threads, 0, 0, ...)` (`reservation_lifecycle.hpp:62-79`) aufrufen, oder L2 auf die seq-Form anpassen. Zusatz: das Include des Directors in `main.cpp` ist teuer/riskant — `profile_run_facade.cpp:1` bezeichnet sich als „die einzige umbrella-ziehende Uebersetzungseinheit"; der Treiber inkludiert heute nur `<profile_facade/profile_run_facade.hpp>` (`main.cpp:51`). Empfehlung: `<builder/bestandslog/reservation_lifecycle.hpp>` direkt (leicht), Director-Header meiden.

**R7 ((A) zieht einen schweren Header):**
`fingerprint_sidecar_path` liegt in `build_orchestrator.hpp` (zieht `experiment_tree.hpp`, `spawn.h`, `<thread>`, `<condition_variable>`, `<expected>`, `simd_build_gate.hpp` …, `:18-50`). Der Binder ist heute bewusst leichtgewichtig (2 Includes, `artifact_cache_transport.hpp:28-32`). Entweder Kosten akzeptieren (Test-Include-Dirs decken `builder/` bereits ab, `tests/unit/CMakeLists.txt:3995-3999`) oder das `".fingerprint"`-Suffix duplizieren = Drift-Risiko gegen `build_orchestrator.hpp:299`. Kein dritter Weg.

**R8 ((C) Terminalitaets-Test koennte CMake erzwingen):**
Test-Include-Dirs sind `builder`, `include`, `src`, `common` (`tests/unit/CMakeLists.txt:3995-3999`) — **`profile_facade` fehlt**. Ein Test gegen `planner::make_planer_block_reservation` waere daher nicht ohne CMake-Aenderung baubar; gegen `bl::make_pro_forma_reservation` + `mark_done`/`mark_released` (`reservation_lifecycle.hpp:91-92`) schon. Der Fake-Transport ist ebenfalls dep-frei moeglich (`BestandTransport` = 4 `std::function`, `bestandslog_lock.hpp:50-59`); Union-per-id kommt aus `store_document_merged` (`bestandslog_lock.hpp:262-276`, Sort nach id `:250-251`). Der geforderte Neutralitaets-Test ist heute schon halb da (`test_g3_artifact_cache_transport.cpp:33-42, 58-66`).

---

## (c) Exakte heutige Zeilennummern der Einbauorte

**(A)** `bestandslog/artifact_cache_transport.hpp` — Datei endet `:53` (`return t;`) / `:55` (namespace-close). Additiv nach `:53`. Neuer Include noetig fuer `fingerprint_sidecar_path` (heute nur `:28-29` + `<optional>/<string>` `:31-32`).

**(B)** `profile_facade/profile_run_entry.hpp`
- Args-Felder: nach `:100` (`measurement_sink`), Struct `RunProfileArgs` `:72-143`.
- Env-Gate-Muster zum Spiegeln: `:311-316` (`COMDARE_BESTANDSLOG`), `:325-330`, `:338-348`.
- `make_cfg`: `:434-436` (Lambda-Kopf); Zuweisungen `:458-460` (`bestand_fingerprint_fn` / `build_variant_sig` / `bestand_zelle`), `:464-466` (`cache_push/pull/measurement_sink`).
- 3 `make_cfg`-Aufrufer: `:555`, `:605`, `:678`.
- **Zusaetzlich noetig (nicht im Schnitt):** `profile_run_facade.hpp:75-77` (Args-Felder) und `profile_run_facade.cpp:559-561` (Durchreiche).

**(C)** `tests/unit/test_g3_artifact_cache_transport.cpp` — 104 Zeilen, 5 TESTs (`:33, :47, :58, :72, :96`); Ziel registriert `tests/unit/CMakeLists.txt:3993-4000`. Anhaengen ab `:104`.

**(D)** `02_messung_driver/main.cpp`
- (d1) Cache-Bau `:840`; Closures `:852-876`; **Injektion xa `:962-968`**, **Injektion pa `:1056-1062``.
- (d2) `--emit-tier-ci` `:439-452` (facade-call `:451`), `--emit-tier-cmake` `:457-470` (facade-call `:469`), `--dump-plan` `:363-369` (rein lesend, korrekt ausgenommen). argv-Schleife `:320`; alle drei Zweige `return`en vor `:840`.
- Includes: `:51` `<profile_facade/profile_run_facade.hpp>`, `:52` `<builder/artifact_transport/artifact_cache.hpp>`.

**Selbstcheck:** `grep -P '[^\x00-\x7F]'` auf dieser Meldung — nur `§`, `->`, `x` (keine `─`/`—`); alle Aussagen aus Read/grep der genannten Dateien belegt.