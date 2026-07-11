# SESSION-ÜBERGABE 2026-07-11 — PRODUKTIONS-ANSPRUCH: EIN offizieller XML-getriebener Programmweg

> **Autor:** Impl-Agent (Claude, comdare@prod1) · **Branch:** `development` · **Vorgänger:** `20260710-SESSION-UEBERGABE-*`
> **Statuswechsel dieser Session:** von „autonom-buildbare Increments" → **Produktions-Track**. Das Gesamt-Mess-System
> gilt als **fertig gebaut**; Fehler erkennen wir nur noch durch den **vollen golden-320-Durchlauf**. Ab jetzt darf
> **nur EIN Anwendungsprogramm** (`messung_driver`) den Gesamtablauf orchestrieren, und **ausschließlich über XML**.
> **Merksätze persistiert** in Memory: `feedback_only_one_official_xml_driven_program_no_behelfswege`,
> `feedback_production_track_full_golden_run_finds_errors`.

---

## FORTSCHRITT 2026-07-11 (Fortsetzung, comdare@prod1)

- ✅ **P0 (HEBUNG) VOLLZOGEN + verifiziert** — ce commit `6b384d6e` (Branch `development`, **lokal, nicht gepusht** wg. Submodul-CI-Infra-Block §5). Die 4 Header (`profile_run_entry`/`source_catalog`/`sota_catalog`/`profile_runner.hpp`) liegen jetzt in `libs/cache_engine/profile_facade/` statt `tests/unit/thesis_tiere/`. Change-Set: git mv + Codegen-String bare (`catalog_codegen_tool/main.cpp:280`) + Attach-Root (`catalog_codegen.cmake:50`) + Facade/adhoc/test_ap2-Include-Pfade (additiv). **Verifikation (ce-standalone g++ 16):** configure grün · Katalog regeneriert `static permutations=320` · Fassade kompiliert+linkt · Voll-Build `all` grün · **ctest 209/209 grün** (beide Round-Trip-Gates: `test_limits_entkopplung_vorstufe` registriert + `test_profile_roundtrip` „Diff leer") · clang-format-22 sauber · kein Mojibake · `golden_fullpilot_320` unberührt (TABU gewahrt). ⇒ entsperrt die spätere `thesis_tiere`-Löschung.
- ✅ **P1/G1 (Workload-Achse XML-selbst-suffizient) VOLLZOGEN + verifiziert** — ce commit `fbc0411b` + super commit `80f3c14` (beide `development`, **lokal, nicht gepusht**). Der kritischste XML-Suffizienz-Gap ist geschlossen: (1) `run_profile_facade` defaultet leeres `load_profile_dir` auf die zum Profil co-lokalisierten Lastprofile (`algorithm_profiles/load_profiles/`) → XML braucht kein `COMDARE_LOAD_PROFILE_DIR` mehr (env = Override); (2) `<workloads>` wird AUTORITATIVE Achse-2-Auswahl (`is_selected`/`std::find` — toter Parse `tp.workloads` lebendig gemacht); (3) `messung_driver`-FATAL entfernt, `two_phase_valid=0`-Schutz in die WIE-Schicht verlagert (Fassade: 0 Profile → exit 4); (4) `m3v2 <workloads>` = `ycsb_a..ycsb_f` (direkter id-Match). **Verifikation:** ce ctest 209/209 grün · Round-Trip test_profile_roundtrip „Diff leer" (golden-320 byte-identisch) · clang-format-22 sauber · super `messung_driver` baut grün · **Filter deduktiv+literal bewiesen: {ycsb_a..f} ∩ 21 vorhandene Lastprofil-ids = exakt 6** (ohne Filter fälschlich 21). Offen: e2e-Vollmesslauf-Pilot (1-Binary-g++-Compile, template-schwer/minutenlang) = Teil des golden-320-Milestones.
- ✅ **P2/G3 (Working-Set-Sweep env-Shadowing) VOLLZOGEN + verifiziert** — ce commit `adbb5f42` (`development`, lokal). `working_set_override` (env `COMDARE_WORKLOAD_RECORDS`, PS-foreach-Behelf) kollabierte den mehrwertigen XML-`<working_set_sweep>` still auf 1 N → jetzt ist das Profil-`<working_set_sweep>` AUTORITATIV, env nur Fallback ohne Profil-Sweep. Verifikation: ce ctest 209/209 · Round-Trip `working_set_sweep == {16384,131072,1048576,8388608}` (Diff leer) · clang-format sauber. (Die übrigen E4-env-Reads `COMDARE_E4_CAP`/`COMDARE_BUILD_VERSION`/`COMDARE_RUN_SOTA` sind DOKUMENTIERTE, strukturerhaltende Overrides — kein Shadowing-Bug, bleiben als Override.)
- ✅ **P3/G5+G4 (n_ops XML-steuerbar + n_repeats-Konsistenz) VOLLZOGEN + verifiziert** — ce commit `e72dba1d`. G5: `ThesisRunOptions.n_ops` + Parse `<run_options n_ops>` + `run_profile` speist `cfg.n_ops` autoritativ (Fassaden-Default 10000 nur Fallback; m3v2 bewusst ungesetzt → golden unverändert). G4: `cfg.n_repeats` konsistent aus `<repetitions count>` (die echten Wiederholungen laufen ohnehin über die repetition-DynDim; `cfg.n_repeats` wird im Iterator nie geloopt — breit verifiziert → Kosmetik/Doppelquelle beseitigt, kein Mess-Verhalten berührt). Verifikation: ce ctest 209/209 · Round-Trip run_options-Pfad + golden „Diff leer" · clang-format sauber. **XML-Suffizienz-Gaps G1/G3/G4/G5 damit geschlossen; G2=DEFER; G6-G10 Design/niedrig.**
- ✅ **P5 (`--validate` migriert) + BEHELFSWEG-LÖSCHUNG VOLLZOGEN** — ce commits `dd0fe177` (P5: `validate_profile_facade` in die Fassade gehoben; super `--validate`-Flag → „VALIDAT OK") + `e3adec03` (Löschung: **37 Dateien** — `run_lazy_150.cpp` + `test_run_profile_union.cpp` + 15 Orphan-`.cpp` + 18 `.ps1`; CMakeLists-Targets entfernt; Keeper-Header-Kommentare bereinigt). BEHALTEN: `test_profile_roundtrip` (Gate), `test_axis_sweep_pilot` (Referenz für #18), `test_ap2`/`test_profile_coverage`, pmc-Smokes. Verifiziert: ce reconfigure grün, Voll-Build grün, **ctest 209/209**, clang-format sauber. **Alles auf beide ce-Remotes gepusht; ce-CI (9597 für dd0fe177) = SUCCESS.**
- 🔗 **Cross-Agent-Merge + Push:** super `ccf960f` (Merge von User-`cc4582a` „track development" + mein P1/P5/Docs; ce-Gitlink=dd0fe177) → beide super-Remotes. **super-CI = infra-rot** (Runner-CI_JOB_TOKEN kann ce-Submodul nicht klonen; `branch=development` löst es NICHT; ce-eigene Pipeline grün) — bekannter Infra-Handover, User-akzeptiert (treibt ce-Pointer bewusst vorwärts).
- ⏳ **P6 (E4-XML = Alleinweg) = GEGATET auf golden-320-Vollmesslauf.** Der Legacy-`ExperimentDriver`-Pfad (main.cpp:596-671, 3 Messreihen A/B/C via config_a/b/c) ist eine ANDERE Maschinerie als E4-XML (basis-320+SOTA aus m3v2). Ob E4-XML sie byte-äquivalent ablöst, ist erst durch den vollen Mess-Lauf beweisbar. **Legacy-Entfernung erst NACH bestätigter Subsumtion** — sonst Verlust der 3-Messreihen-Fähigkeit. Zwischenschritt möglich (nicht risikofrei): Opt-in `COMDARE_RUN_E4_XML` zu Default flippen (Legacy als expliziter Fallback bleibt), erst danach Legacy-Rücknahme.
- ✅ **Task #18 (goldener Coverage-Test) CODE-EBENE VOLLZOGEN + verifiziert** — ce commits `e1784e26` (Slice 1: Achsen-Sweep-Maschinerie von 8→**alle 19 Achsen**; `AxisSweepCatalogFull`-Template + 11 neue `SweepCataloge` + registrierter Gate `test_axis_sweep_coverage` als echter Konsument) + `fc855b20` (Slice 2: `m3_golden_coverage.profile.xml` — alle 19 `axis_sweeps` + alle 21 Lastprofile + alle 7 Lebewesen × 3 Merge-Stufen). Verifiziert: ctest **210/210**, Round-Trip golden==320 (Sweeps disjunkt), `--validate` „19 Achsen, 19 axis_sweeps, 21 sota_series — VALIDAT OK", clang-format sauber. Auf beide ce-Remotes gepusht. **Verbleibend (mehrtägig, mit golden-320):** der tatsächliche Coverage-MESSLAUF (Codegen→Build→Measure).
- ⛔ **P4 (4 RC-Achsen ins m3v2-Profil) = KORRIGIERT AUF DEFER** (Ledger `:408(b)`/DD-C): die 4-RC-Verdrahtung wurde gebaut (ce 1f9c2eef) und **revertiert** (ce 290e306c) wegen **15 Mess-Defekten (8 CONFIRMED)** (batch_size erreicht CSV nie, budget-Datenverlust). RC-Werte sind eine unbenannte Mess-Design-Eigenschaft (Deep-Research-Pflicht) + Korrektheit DATA-gated (#156). **NICHT ins golden-Profil** bis #221-Rest sauber + erforscht. (binary_id-Invariante ist bewiesen golden-neutral — das war nie das Problem; das Problem ist die Konsum-Korrektheit.)
- ⚠️ **Audit-Korrektur:** `test_profile_roundtrip.cpp` + `test_ap2_katalog_pfad_stubfrei` sind **echte Gates** (nicht löschbare Behelfe) — der Behelfswege-Finder hatte `test_profile_roundtrip` fälschlich als Tier-2 gelistet. `test_ap2` ist registriertes CI-ctest.
- ⚠️ **`.ps1`-Löschung nicht isoliert sauber:** die 18 getrackten `.ps1` sind referenzlos in CMake/CI, aber in **Code-Kommentaren** offizieller Header (`profile_runner.hpp`, `xml_config_parser.hpp`) + vielen Test-`.cpp`-Kommentaren + Docs als Build-Anleitung genannt → Löschung erfordert gepaarte Kommentar-Bereinigung (Teil der P5-Kohärenz, nicht davor).

---

## NEUE GEPLANTE AUFGABE (User 2026-07-11) — GOLDENER COVERAGE-TEST (Task #18, nach dem P-Strang)

**User-Auftrag:** Den golden-320-Lauf zu **einem goldenen Coverage-Test** erweitern, der **JEDE steuerbare Achse mit ≥1 Nicht-Baseline-Konfiguration** berührt + **alle Features, Frameworks und Lastprofile** fordert. Standard-Messen wird dadurch deutlich umfangreicher, aber 100% Funktions-Abdeckung. „Die Anzahl der steuerbaren Achsen hat sich zuletzt erweitert" (RC-/dynamische Achsen einbeziehen). **Sequenz: NACH dem aktuellen P-Strang** (P5/Löschung/P6) + nach P4-Deferral-Auflösung.

**Grounded Plan (passt in die vorhandene E4/XML-Maschinerie, kein Behelf):**
1. **Per-Achse-Coverage** via der `<axis_sweep>`-Maschinerie (`axis_sweep_source_map`/`make_all_axis_sweeps_source_map`, `source_catalog.hpp:253-286`) — heute nur **4 vertiefte Achsen** + 9 `<axis_sweep>` im m3v2 → **auf alle 19 Kompositions-Achsen + die neuen RC/runtime_dynamic-Achsen heben** (je ein Sweep gegen index0-Baseline). Baseline + N per-Achse-Sweeps = kompakte Coverage, NICHT das 137-Bio-Kreuzprodukt.
2. **Alle Frameworks:** SOTA-Reihen A/B/C × alle Lebewesen (prt_art/art/hot/masstree/surf/start/wormhole) × alle 3 Merge-Stufen — vorhandene `<sota_series_set>`-Mechanik voll ausschöpfen.
3. **Alle Lastprofile:** `<workloads>` auf alle intended Profile erweitern (ycsb_a..f + ggf. lp_*/coco_*/ih/lh — welche genau = kurze User-Klärung; 21 vorhanden; P1-Filter greift schon).
4. **Realisierung:** neues `algorithm_profiles/thesis_profiles/m3_golden_coverage.profile.xml` (rein XML-getrieben) + `test_profile_coverage`-Gate erweitern (assert „jede Achse ≥1× berührt").
5. **TABU:** `golden_fullpilot_320_binary_ids.txt` bleibt der Basis-320-Round-Trip-Fixture (unberührt); der Coverage-Test ist ein **eigenes, größeres Profil** (kein 320-Gate-Bruch). Offene Klärung: Coverage-Test = neuer Standard oder additiv?

---

## 0. TL;DR — was JETZT zu tun ist (Reihenfolge bindend)

1. **P0 HEBUNG** `profile_run_entry.hpp` (+ 3 Header) aus `tests/unit/thesis_tiere/` → `libs/cache_engine/profile_facade/` — Voraussetzung für ALLES (der offizielle Weg greift heute in den Test-Ordner).
2. **P1 (kritischster XML-Gap G1):** Workload-Achse XML-referenziert machen — ohne XML-Lastprofile ist der Lauf `two_phase_valid=0` = **wissenschaftlich ungültig**.
3. **P2–P5:** env-Shadowing → Fallback, n_repeats/n_ops/RC-Achsen ins XML, Capability-Parität zu `run_lazy_150` (`sweep_axis`/`resume`/`cores`/`--validate`).
4. **Cross-Platform-Milestone:** kleiner **g++-Linux-Pilot** durch `messung_driver` E4 grün (wörtliche Ausgabe) — VOR jeder Löschung.
5. **P6:** E4-XML = Default-/Alleinweg (Opt-in `COMDARE_RUN_E4_XML` + Legacy-Pfade zurücknehmen).
6. **Löschung** Tier 1 → Tier 2 → Tier 3 (erst NACH P0–P5 bzw. P6).
7. **Golden-320-Vollmesslauf** (mehrtägig, Cluster) — erst nach 1–6 grün.

Vollständiger Diff-Plan als Backup: `docs/sessions/backups/20260711-produktions-single-xml-path-audit/production-single-xml-path-audit-FULL.json` (ultracode-Workflow `wf_d5e03598-b5a`, 4 Agenten, 408k Tokens).

---

## 1. DER EINE OFFIZIELLE PRODUKTIONSWEG (autoritativ)

**Entry:** `Code/02_messung_driver` → Binary `comdare-messung-driver`.
Die golden-320-Strecke ist der E4-XML-Block:

```
02_messung_driver/main.cpp:516-584   (E4-XML-Block)
  → pf::run_profile_facade(pa)         libs/cache_engine/profile_facade/profile_run_facade.cpp:98
    → run_profile(...)                 tests/unit/thesis_tiere/profile_run_entry.hpp:105   ← HEUTE NOCH IM TEST-ORDNER (P0!)
      → Codegen union_gen → g++ -fPIC -shared -std=c++23 (.so) → dlopen → measure → EINE CSV (+SOTA A/B/C, resume)
```

- **Default-Profil** in CMake gebacken: `02_messung_driver/CMakeLists.txt:24-27` → `m3v2_study.profile.xml`; `cap=320` aus `<run_options cap="320">` (`m3v2_study.profile.xml:145`).
- **Cross-platform gesichert:** g++ via `posix_spawnp` OHNE `/bin/sh` (`build_orchestrator.hpp:463-489`); Compiler-Override nur `COMDARE_CXX` (`profile_run_facade.cpp:91-94`). **Kein `cl.exe`, kein PowerShell in dieser Kette.**
- **Include-Satz** CMake-nativ gebacken (`COMDARE_FACADE_PERM_INCLUDES`, `profile_facade/CMakeLists.txt:130-137`); `COMDARE_PILOT_INCLUDES` nur noch optionaler Override.

**Belege, dass dies der SOLL-Weg ist (im Plan verankert):**
- `m3v2_study.profile.xml:5-7` — das Profil erklärt sich selbst als vollständig-deklarativer Ersatz von `run_lazy_150.cpp` + der PS-foreach.
- `apps/cache_engine_builder/main.cpp:80-82` — die Builder-App bezeichnet sich als **Demo** und verweist auf `messung_driver` als echten Orchestrator ⇒ `cache_engine_builder` ist **NICHT** der offizielle Weg.
- `profile_run_entry.hpp:2-4` (Doc `10_schichten_modell_M.md §2.2`) + `docs/sessions/20260618-M3v2-NEUMESSUNG-DESIGN-SPEC.md:80`.

**⚠️ Ehrlichkeits-Korrektur (muss VOR „fertig" behoben werden):** Der offizielle Weg ist heute
(1) nur hinter Opt-in `COMDARE_RUN_E4_XML=1` erreichbar (`main.cpp:526`), und
(2) danach läuft trotzdem der **Legacy-`ExperimentDriver`/messreihen-Pfad** weiter (`main.cpp:586-671`), plus im selben Binary noch der alte **V38.C-perm-Mikrobench** (`main.cpp:295-475`).
SOLL: E4-XML = Default **und einziger** Pfad (→ P6).

---

## 2. XML-SUFFIZIENZ — GAP-LISTE (reicht die XML für ALLES?)

| # | Feature | Ist-Steuerung | GAP / SOLL | Prio |
|---|---------|---------------|------------|------|
| **G1** | **Workload-Wahl (Achse 2)** | env `COMDARE_LOAD_PROFILE_DIR` (Verzeichnisinhalt); `<compile_dims><workloads>` ist **toter Parse** (`tp.workloads` unkonsumiert, `xml_config_parser.cpp:238`). | **KRITISCHSTER GAP.** Profil muss Lastprofile referenzieren (`<workloads><ref>../load_profiles/ycsb_a.xml</ref>…</workloads>`), Parser → `workload_values`-DynDim (`profile_run_entry.hpp:133-135`). Ohne XML-Ref = fixed-workload = `two_phase_valid=0` = **UNGÜLTIG** (`main.cpp:551-556`). | **HOCH** |
| **G2** | **4 RC-Achsen** (prefetch_distance, pool_budget_bytes, batch_size, inline_threshold_bytes) | Schema+Wiring existieren (`xml_config_parser.cpp:261-265`, `profile_to_tree.hpp:79-87`), aber **nicht** im Studien-`<runtime_dynamic>` (`m3v2_study.profile.xml:135-138` hat nur thread_count+hw_prefetcher). | In `m3v2_study.profile.xml:135-138` aufnehmen. **Reiner Profil-Edit.** ⚠️ Round-Trip-TABU (§4). | MITTEL |
| **G3** | **working_set_sweep** | XML `<working_set_sweep>` (`m3v2:123-125`) existiert, wird aber von env `COMDARE_WORKLOAD_RECORDS` **geshadowed** (`main.cpp:558-559` → `profile_run_entry.hpp:164-167` verwirft Sweep). | env zu reinem Fallback: nur greifen, wenn Profil keinen Sweep setzt. | MITTEL |
| **G4** | **n_repeats** | Doppelquelle: `<repetitions count=3>` (`m3v2:141`) treibt nur die repetition-index-DynDim, NICHT `cfg.n_repeats` (Fassaden-Default 3). | Vereinheitlichen: `cfg.n_repeats` aus `<repetitions count>`. | MITTEL |
| **G5** | **n_ops** | argv-only (`run_lazy_150.cpp:160`); offizieller Weg Fassaden-Default 10000. | `<run_options n_ops="…">` in Schema+Parser+`ProfileRunArgs`. | MITTEL |
| **G6** | **Observer/Mess-Kategorien** | compile-define hartkodiert (`COMDARE_MEASUREMENT_ON`+`COMDARE_CE_ENABLE_STATISTICS`, `profile_run_facade.cpp:67-69`). | **Design-Entscheid:** Observer-Wahl als Mess-Achse? ⚠️ Direktive „compile-time-only" — bleibt compile-define, aber *per-Profil selektiert* (Pre-Build-Codegen), nicht Runtime. | DESIGN |
| **G7** | **Reihe C** (Merge alt↔neu) | build-übergreifend, kein `id=C` in `<sota_series_set>`. | Echter GAP: nicht als sota_series ausdrückbar → eigenes cross-build Analyse-Tool (Post-hoc über zwei Voll-Läufe). | NIEDRIG |
| **G8** | **Output CSV/LaTeX-Pfade** | argv-only; offizieller Weg konventionell `e4_dir/measurements.csv`. | Optional `<output csv=… latex=…>`. Konvention vertretbar. | NIEDRIG |
| **G9** | **Compiler/OS/Arch/Cache-Line/Includes** | compile-time `#ifdef`/env/CMake-baked; isa-Achse (`m3v2:65`) nur binary_id-Label. | **Kein Suffiziens-Gap per Doktrin** (compile-time-only). Offen nur Design-Frage, ob `platform`/`isa` echte Codegen-Flags erzeugen. | DESIGN |
| **G10** | **build_version (Resume-Marke)** | argv-only; Profil-`build_version` nur CSV-Tag. | Entscheiden, ob Resume-Marke aus XML; sonst dokumentierter Run-Parameter. | NIEDRIG |

---

## 3. NACHIMPLEMENTIERUNGS-PLAN (P0–P7) + LÖSCH-LISTE

### Kritischer Pfad zu „golden-320 aus XML allein"
- **P0 — HEBUNG** `profile_run_entry.hpp` (+ `profile_runner.hpp`, `source_catalog.hpp`, `sota_catalog.hpp`) `tests/unit/thesis_tiere/` → `libs/cache_engine/profile_facade/`. Include-Pfad `tests/unit/thesis_tiere` aus `profile_facade/CMakeLists.txt:52` entfernen; Fassade von `STATIC EXCLUDE_FROM_ALL` (`:81`) zum normalen Lib-Target. **Entsperrt die spätere `thesis_tiere`-Löschung.**
- **P1 — Workload-Achse XML-referenziert (G1).** Wichtigster Suffiziens-Gap. `COMDARE_LOAD_PROFILE_DIR` → reiner Fallback.
- **P2 — env-Shadowing zu Fallback (G3 + E4-Block-env-Reads)** `COMDARE_WORKLOAD_RECORDS/E4_CAP/BUILD_VERSION/RUN_SOTA` (`main.cpp:557-563`): nur greifen, wenn XML das Feld nicht setzt.
- **P3 — n_repeats vereinheitlichen (G4) + n_ops in XML (G5).**
- **P4 — 4 RC-Achsen ins Studien-Profil (G2).** ⚠️ binary_id-Komposition unberührt (Round-Trip-TABU §4).
- **P5 — Capability-Parität zu `run_lazy_150`** in `messung_driver`/XML: `sweep_axis` (`pa.sweep_axis`), `resume`-Override (`pa.resume/resume_override_set`), `cores_per_build`, `--validate` read-only Gate (`run_lazy_150.cpp:108-151` → offizielles Vorab-Gate ohne DLL-Bau). **Erst danach ist `run_lazy_150` löschbar.**
- **P6 — E4-XML zum Default-/Alleinweg:** Opt-in `COMDARE_RUN_E4_XML=1` (`main.cpp:526`) entfernen; Legacy-3-Reihen (`main.cpp:586-671`) + V38.C-Mikrobench (`main.cpp:295-475`) zurücknehmen — **erst nachdem** verifiziert ist, dass die messreihen-Spec-Fähigkeit wirklich abgelöst ist.
- **P7 (deferbar)** — Reihe C (G7), Output-Pfade (G8), Observer-Achse (G6), isa/platform-Codegen (G9).

### Löschung (NACH P0–P5; Tier-3 nach P6)
**PHASE 0 — HEBUNG (siehe P0, keine Löschung).**

**TIER 1 — 100% sicher (keine CMake/CI/ctest-Referenz, grep-verifiziert):**
- **~19 `.ps1`-Behelfe:** `tests/unit/thesis_tiere/{build_and_measure_150_tiere, build_and_measure_thesis_tiere, build_and_measure_adapter_tiere, build_axis_sweep_pilot, build_sota_pilot, build_pruefling_type_pilot, build_profile_roundtrip, build_run_profile_union, build_validate_profile, build_node_delegation_proof, k10_double_build_verify, k10_release_probe_only, scratch_clu_pmd1_verify, analyze_f15_holm}.ps1`; `tests/unit/{build_test_cow_capable_wrappers, buildvariant_dll_roundtrip, genus_dll_roundtrip}.ps1`; `scripts/collect_partial_results.ps1`.
- **~20 Orphan-Quellen** (nur via `.ps1`/`cl.exe` baubar): `tier150_axis_grid.cpp, measure_adapter_tiere.cpp, gen_golden_fullpilot.cpp, test_sota_series_pilot.cpp, test_pruefling_type_pilot.cpp, test_node_delegation_proof.cpp, test_layout_aware_store.cpp, test_validate_profile.cpp, validate_profile.hpp, thesis_nt_node{4,16,48}.cpp, thesis_sa_{array256,bst,btree,linear_scan,vector_u8u8}.cpp`; `tests/unit/test_lazy_static_dynamic_driver.cpp`.
- ⚠️ **VORHER:** `--validate`-Logik aus `run_lazy_150.cpp:108-151` als offizielles Gate übernehmen, bevor `validate_profile.hpp` fällt (= P5).

**TIER 2 — nur mit gepaartem CMake-Edit** (ADHOC-Targets; `.cpp`-Löschung ohne Zeilen-Entfernung ⇒ configure-Fehler in ALLEN CI-Jobs). Block `tests/unit/CMakeLists.txt:2674-2723`:
- `run_lazy_150.cpp` + Zeilen 2721-2723; `test_axis_sweep_pilot.cpp` + 2718-2719; `test_profile_roundtrip.cpp` + 2711-2712; `test_run_profile_union.cpp` + 2714-2716.
- Nach Entfernen aller vier ist der **ganze Block 2674-2723 tot** (Kommentar + `_thesis_adhoc_includes/_libs` + `function(comdare_thesis_adhoc_executable)`) → komplett entfernen.
- ⚠️ **VORHER:** Capability-Parität (P5), sonst Fähigkeits-Regression.

**TIER 3 — koordinierte CMake-Chirurgie** (CI-verdrahteter Alt-Codegen→Build→Measure):
- `apps/adhoc_emitter/` (SUPERSEDED Ganz-Tier-F15-Emitter, verletzt „Achse=Organ") + `cmake/adhoc_emitter.cmake` — Referenzen: `apps/CMakeLists.txt:20`, `tests/unit/CMakeLists.txt:1417 include(adhoc_emitter),1425-1474`, Codegen-Kante `:1433`.
- `apps/f15_compare/` (dritter Mess-Orchestrator R5.D) — bricht ctest-Smoke `f15_compare_cli_smoke` (`:1462-1468`); Smoke vorher umhängen.
- ADHOC-DLL/Mess-Maschinerie `tests/unit/CMakeLists.txt:1365, :2348, :1149/:1397/:1442, :2373-2392` — ctest-registriert + Codegen-Consumer; nur koordiniert nach Entscheid, ob diese Achsen-DLL-Beweise in den offiziellen Weg wandern.

**Behelfe, die KEINE Behelfe sind (NICHT löschen):** `apps/perm_runner` (Cluster-Mess-Primitiv je EINER DLL, vom offiziellen Weg treibbar), `apps/catalog_codegen_tool`, `apps/anatomy_codegen_tool`, `apps/is_original_validator` (offizielle Codegen); alle registrierten Gates (`test_profile_coverage`, `test_ap2_katalog_pfad_stubfrei`, `m3v2_pmc_smoke`, `linux_perf_pmc_smoke`, `test_harness_compile`).

**⚠️ Erste Handlung vor jeder Löschung (Direktive: nie ✓ ohne wörtliche Ausgabe):**
```
grep -rn "run_lazy_150\|build_and_measure_150\|adhoc_emitter\|f15_compare" .gitlab-ci.yml cmake/ **/CMakeLists.txt
```

---

## 4. RISIKEN / TABU

- **TABU Round-Trip-Fixture:** `tests/unit/thesis_tiere/golden_fullpilot_320_binary_ids.txt` ist getrackte Golden-Fixture von `test_limits_entkopplung_vorstufe` (`tests/unit/CMakeLists.txt:2583`). Die neue XML-Basis-320 muss **positions-identisch** bleiben ⇒ **`permute_axes` (19 Achsen) + Werte + binary_id-Komposition unberührt.** G2/G4 dürfen die binary_id-Bildung nicht verschieben.
- **TABU Messdaten** (Direktive „nie löschen"): `tier150_measurements.csv` (6.7 MB), `adapter_measurements.csv`, die Golden-Fixture — behalten. ABI/Schema darf brechen, Rohdaten nie.
- **`buildsystem.xml` Hands-off** (eigener Agent) — nur CMake/CI-Referenzen anfassen.
- **Cross-platform-Beweis fehlt am 320-Maßstab:** g++/`.so`-Pfad ist verdrahtet, aber die realen Voll-Läufe entstanden per `cl`/PowerShell (DESIGN-SPEC:83). **Kleiner g++-Pilot durch `messung_driver` E4 muss grün laufen (wörtliche Ausgabe), bevor `run_lazy_150`/PS-Harness fällt** — sonst Regression auf einer Plattform, die nie end-to-end lief.
- **Dossier-Drift:** Der E4-Block hat sich bewegt (env-Wiring für cap/working_set/platform/build_version_tag/run_sota + FATAL bei fehlendem `COMDARE_LOAD_PROFILE_DIR`). **Vor jedem Edit den Live-Stand `02_messung_driver/main.cpp:516-584` lesen**, nicht gegen Dossier-Zeilen blind patchen.
- **Direktive „nur punktuelle Refactorings":** System ist CI-grün + messfähig — kein Greenfield. Diese Strecke = gezielte Behelf-Entfernung + XML-Suffizienz-Schließung.
- **Multi-Agent-Git:** granular committen; nach jedem Push GitLab-Pipeline GRÜN verifizieren (wörtliche Ausgabe). Session-Transkripte enthalten Live-Tokens → nie committen.

---

## 5. INFRA-BLOCKER (Submodul-CI) — Diagnose abgeschlossen, Fix = Handover

**Endgültiger Befund (2026-07-11, Admin-API + Test-Branch `ci-test-ce-bump`, super-Pipeline 9577 ROT):**
- Die inbound-`job_token_scope`-Allowlists sind für **ALLE DREI** Submodul-Projekte **korrekt** gesetzt: `{inbound_enabled:true}` + super(288) ∈ Allowlist von ce(286), prt-art(287), thesis(289).
- **`GIT_STRATEGY: clone` ist NICHT der Fix — es macht es schlimmer:** Frischklon failt an ALLEN drei Submodulen mit `remote: HTTP Basic: Access denied … Authentication failed`. (Heutige grüne Läufe funktionieren nur, weil der Runner die ALTEN Commits im warmen Build-Dir cacht und `GIT_STRATEGY=fetch` sie ohne Re-Auth wiederverwendet.)
- ⇒ Ursache ist **Runner-/Instance-Ebene** (CI_JOB_TOKEN-Cross-Projekt-Auth wird per HTTP-Basic abgelehnt trotz korrekter Allowlist). Kandidaten: Instance-Setting „CI/CD job token allowlist / limit access", Runner-Credential-Injection-Bug, oder `gitlab-ci-token:$CI_JOB_TOKEN`-URL-Rewrite greift beim rekursiven Submodul-Update nicht. **NICHT per CI-YAML/Allowlist-API fixbar.**
- **HARTE REGEL:** super-ce-Gitlink bleibt auf letztem CI-fetchbaren Commit **`c022ce05`** gelaggt; **NICHT bumpen**, bis Infra den Runner-Token-Fix liefert.
- **Aufräum-Rest:** Test-Branch `ci-test-ce-bump` (isoliert, rot) ist ein Diagnose-Artefakt — Löschung braucht je-Repo-User-GO. thesis-Commit `1a0a6eb` fehlt zusätzlich ganz in gitlab-thesis(289)=404 (Thesis-Agent-Push-Gap; nur er kann pushen).
- Doku: Memory `reference_super_ci_cannot_fetch_new_ce_submodule_commits` (aktualisiert).

---

## 6. WAS DIESE SESSION GELIEFERT HAT (verifiziert)

- **Cluster-Probelauf bestätigt WORKS:** `pmc:amd` Job auf `prod-baremetal-prod1` = success mit realem PMC (`delta.cache_misses_l1=4191982`, `delta.dtlb_misses=2112501`, `SMOKE_OK`). Die Messmaschinerie misst real auf baremetal.
- **golden-320-Config validiert:** `m3v2_study.profile.xml --validate` → `VALIDAT OK: 19 Achsen, 32 Werte, 8 axis_sweeps, 21 sota_series`. `run_lazy_150` **baut+validiert bereits auf Linux** (g++).
- **Modul-Migration (measurement-all):** Struktur bereits SOLL-konform (300 umbrella clean, Zellen 76/320/321 populiert, keine Duplikate); 296 via API getombstoned.
- **6 CI-grüne Increments früher** in der Session (Phase 0.1, 0.3a, E4′ §C, CMD-2, #31-Vorbau, SLICE 1).
- **2 Memories persistiert** (Produktions-Direktiven), **1 Memory korrigiert** (Submodul-CI-Ursache), **Audit-Workflow-Backup** abgelegt.

---

## 7. VOLLSTÄNDIGE OFFENE-TODO-LISTE (Stand Kontextende)

### A — PRODUKTIONS-KRITISCHER PFAD (diese Übergabe, Reihenfolge bindend)
- [x] **P0** HEBUNG `profile_run_entry.hpp`+3 Header → `libs/cache_engine/profile_facade/` — **DONE + verifiziert** (ce `6b384d6e`, ctest 209/209, lokal/nicht gepusht). Rest-Optional: Fassade-`EXCLUDE_FROM_ALL` lösen (Build-Policy-Entscheid, separater Increment).
- [x] **P1** Workload-Achse XML-referenziert (G1) — **DONE + verifiziert** (ce `fbc0411b` + super `80f3c14`; Fassade defaultet co-lokalisiert + `<workloads>`-Filter; Treiber-FATAL weg; ctest 209/209; Filter=6 bewiesen). Lokal/nicht gepusht.
- [x] **P2/G3** env-Shadowing → Fallback — **DONE** (ce `adbb5f42`; `<working_set_sweep>` autoritativ, env-Override nur Fallback). Cap/build_version/run_sota-env = dokumentierte Overrides, kein Bug.
- [ ] **P3** n_repeats vereinheitlichen (G4) + n_ops in XML (G5).
- [ ] **P4** 4 RC-Achsen ins `m3v2_study.profile.xml:135-138` (G2) — Round-Trip grün halten.
- [ ] **P5** Capability-Parität `sweep_axis`/`resume`/`cores`/`--validate` in `messung_driver`.
- [ ] **Milestone** kleiner g++-Linux-Pilot durch `messung_driver` `COMDARE_RUN_E4_XML=1` grün (wörtliche Ausgabe).
- [ ] **Löschung** Tier 1 → Tier 2 (Block `CMakeLists.txt:2674-2723`) → Tier 3 (adhoc_emitter/f15_compare + Gates).
- [ ] **P6** Opt-in + Legacy-Pfade zurücknehmen; E4-XML = Alleinweg.
- [ ] **P7** (deferbar) Reihe C, Output-Pfade, Observer-Achse, isa/platform-Codegen.
- [ ] **Golden-320-Vollmesslauf** (mehrtägig, Cluster) — nach allem obigen grün. Nie aktiv pollen.

### B — INFRA-HANDOVER (nicht mein Domain)
- [ ] Runner-CI_JOB_TOKEN-Cross-Projekt-Submodul-Auth reparieren (§5). Danach ce-Gitlink auf aktuellen Commit bumpen.
- [ ] Test-Branch `ci-test-ce-bump` löschen (braucht User-GO).
- [ ] thesis-Commit `1a0a6eb` fehlt in gitlab-thesis (Thesis-Agent-Push-Gap).

### C — ROADMAP-INCREMENTS (aus Dossier `noble-shimmying-fairy`, unabhängig von A)
- [ ] **#188** E2-Wurzel finalisieren (honest-0-Design/Store-Backing; stale `search_organ_`-Kommentare).
- [ ] **#221** E1: 4 fehlende RC-Setter + apply1 + hw_prefetcher-POD/MSR — **Hard-Gate vor #156**.
- [ ] **#223** E3-Gate nach Recompile re-verifizieren (Einzeldatei-Grep).
- [ ] **#215** 320-DLL-Neubau (Wirksamkeit) — gated/mehrtägig, nach P1/P2 (Code) UND P4 (XML).

### D — GEPARKT (je eigenes User-GO)
- [ ] Task #3 EXTERN_GATED-Forks; #5 Hebel-A-Rest; #8 Phase-0.2-Rest (NUMA/Page); #9 Phase-0.3b; #11 Messkurven-Typsystem-WURZEL (Null-Consumer-Trap, DATA-gated auf #156).

---

## 8. DIREKTIVEN-KADENZ (bei jedem Increment)
Ist-Verifikation (git beide Remotes) → fresh-context-Kartierung `datei:zeile` → manuelle Umsetzung → VOLL-REVIEW → Mojibake-grep `'Ã|â€'==0` → clang-format 22.1.8 dry-run==0 → **doppelt-literal** (g++-Build + eigener Lauf) → **golden-Roundtrip==320** wo berührt → granularer Commit (nie `git add -A`) → beide Remotes → **CI STRIKT GRÜN** vor nächster Aufgabe. Je Schicht EIN großer Review-Workflow + eigener Rohdaten-Backup-Ordner in `docs/sessions/backups/`.

---
*Diese Übergabe ist der autoritative Einstiegspunkt für die nächste Session. Der volle Diff-Plan liegt als JSON-Backup daneben. Erst P0 lesen, dann `02_messung_driver/main.cpp:516-584` live prüfen, dann handeln.*
