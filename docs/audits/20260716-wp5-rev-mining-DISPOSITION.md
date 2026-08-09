# WP-5 (Audit F56/F57) — Disposition aller 30 REV-IDs des 07-11-Readonly-Review-Handovers

**Datum:** 2026-07-16 · **Quelle der IDs:** `docs/sessions/20260711-SESSION-UEBERGABE-gitlab-sync-submodule-stand-und-readonly-review.md` (§5/§6, 30 IDs)
**Auftrag:** Voll-Audit 2026-07-16, SYNTHESE.md WP-5 (Punkte 26–28, F56/F57), freigegeben durch Richtungs-Verdikt wf_68031d76.
**Methode:** verify-first — jede ID wurde gegen den IST-Code (ce `e750eb45`-Basis, prt-art `1d66ded`-Basis, super `0543fa3`) geprüft; Disposition nur mit datei:zeile-Beleg.

## Statistik

| Disposition | Anzahl | IDs |
|---|---|---|
| **fixed (vor WP-5, verifiziert)** | 7 | CXX-01, CXX-03, CXX-04, DATA-02 (fixed-by-gate), DATA-08, CI-02, CI-04 |
| **jetzt gefixt (WP-5, diese Session)** | 7 | DATA-01, DATA-04, DATA-05, DATA-06, DATA-07, CXX-02, CXX-05 |
| **reject (Befund im Ist widerlegt)** | 1 | CI-01 |
| **offen/gated (mit Gate-Begründung)** | 15 | DATA-03, DATA-09, DATA-10, DATA-11, DATA-12, DATA-13, DATA-14, CI-03, CI-05, CI-06, TEX-01..05 |

Zusätzlich **F57 (Muster B, ~15 noexcept-auf-Alloc-Bodies): UMGESETZT** — 16 verifizierte Bodies bereinigt (ce `c38144e5`), s. Abschnitt F57 unten. Damit ist die G3-„autonom erschöpft"-Behauptung (§12 2026-07-15) um den fehlenden Muster-B-Increment **korrigiert**.

## WP-5-Commits

| Repo | SHA | Inhalt |
|---|---|---|
| ce | `fb11ee4d` | REV-DATA-01: Capability-Zell-Invalidierung host-seitig + E3-Contract-Test (Negativ+Positiv) |
| ce | `a6fbf5f4` | REV-DATA-04: strikter Zahl-Parser (from_chars, Vollverbrauch) + isfinite + Zeilen-Diagnose |
| ce | `f9351b9a` | REV-DATA-05: Artefaktnamen-Allowlist + weakly_canonical-Containment |
| ce | `fe74b1c8` | REV-DATA-06: atomarer Publish (tmp-Sibling, verifizierte Writes, rename DLL→Version→Manifest) |
| ce | `f4bd67ac` | REV-DATA-07: Zell-Raster-Stratifizierung (Cell-Key, Union-Grid-Disqualifikation, Median der Zell-Mediane) |
| ce | `c38144e5` | F57 Muster B: 16 noexcept-auf-Alloc-Bodies (14× noexcept entfernt, 2× Allokation herausgehoben) |
| prt-art | `dbc05ce` | REV-CXX-02: OLC begin_write als CAS-Schleife + 2 Mehr-Writer-Contract-Tests |
| prt-art | `fc80c61` | REV-CXX-05: noexcept von DensityTracker::record entfernt; set() → status_out_of_memory |

## Einzeldisposition (alle 30 IDs)

### REV-CXX (prt-art)

| ID | Disposition | Beleg (IST-Code) |
|---|---|---|
| REV-CXX-01 (P0, LeafOnlyCounter UAF) | **fixed (vorher, 07-13 Sweep B1)** | `prt_art/include/prt_art/telemetry/leaf_only_counter.hpp:93-125`: record_access hält shared_lock über Lookup UND fetch_add (Fast-Path) bzw. unique_lock (Slow-Path); Kommentar zitiert „264-Folgebefund (Goal-V4 G3 / REV-CXX-01)"; ensure_slot existiert nicht mehr (expliziter Hinweis-Kommentar am Klassenende). |
| REV-CXX-02 (P1, OLC Odd/Even-Vertrag) | **jetzt gefixt (`dbc05ce`)** | Vorher `olc_with_reserved_blocks.hpp:38` `begin_write { fetch_add }` — 2 Writer kippten ungerade→gerade. Jetzt: CAS-Schleife (nur gerade→nächste ungerade; Warten via spin+yield), Invariante „Writer aktiv ⇒ Version ungerade". Tests `SecondWriterCannotEnterWhileFirstActive` + `ConcurrentWritersKeepMonotoneEvenGenerations` (nicht timing-flaky: Eintritt während aktiven Writers ist per CAS unmöglich). |
| REV-CXX-03 (P1, Hit/Miss-Datenrace) | **fixed (vorher, M-PA-02)** | `prt_art_search_engine.hpp:~697-704`: `const_hits_`/`const_misses_` sind `std::atomic<uint64_t>` (relaxed, unter shared_lock inkrementiert); `inserts_`/`erases_` nur unter unique_lock geschrieben, Getter unter shared_lock; noexcept dort entfernt. Kommentar zitiert M-PA-02 wörtlich. |
| REV-CXX-04 (P1, Pointer/Iterator-Lifetime) | **fixed (vorher, M-PA-02 HANDLE-CONTRACT)** | `prt_art_search_engine.hpp:~131-143` (vector) + `~429-439` (map): dokumentierter HANDLE-CONTRACT (Iterator-/Pointer-Rückgaben ausdrücklich NICHT thread-safe), by-value-Accessoren at()/front()/back()/lookup()/range_scan() ergänzt, size/empty/capacity jetzt unter shared_lock. Entspricht der Review-Abhilfe „ungelockte std-container-ähnliche API nicht als thread-safe ausgeben + API-Doku benennt Thread-Safety". |
| REV-CXX-05 (P1, noexcept-record) | **jetzt gefixt (`fc80c61`)** | Vorher `density_tracker.hpp:23` `record(...) noexcept { per_node_[id]=…; }` (unordered_map::op[] alloziert). Jetzt: noexcept entfernt (Doku [[allocation-failure-exception]]); Konsumenten verifiziert: alle `update_density()`-Aufrufer (push_back ×2, emplace_back, insert_internal) hatten catch(bad_alloc)→status_out_of_memory; `set()` als einziger ohne — jetzt konsistent gemappt. note_observation/reset/density_for bleiben noexcept (allokationsfrei). |

### REV-DATA (ce + super)

| ID | Disposition | Beleg (IST-Code) |
|---|---|---|
| REV-DATA-01 (P0, Scan-Capability) | **jetzt gefixt (`fb11ee4d`)** | Vorher: `workload_orchestrator.hpp:142` Op-Skip + `perm_runner.hpp:252` two_phase_valid=nur rb_exact ⇒ scan-unfähiges Tier blieb in YCSB-E valide. Jetzt `perm_runner.hpp` run_workload_perm: `if (cfg.pct_scan > 0.0 && scan == nullptr) return gate_failed_result_(...)` VOR Gate/Load/Run — ganze Zelle ungültig, genullte Zeile, keine partielle Leistungszeile. Beweis: `test_e3_contract_conformance_gate_wirksam` Fall „scan-pflichtiges Profil auf scan-unfähigem Tier" (+ Positiv-Kontrolle mit IScannableTier-Fake). |
| REV-DATA-02 (P0, Insert/Erase/Lookup-Semantik) | **fixed-by-gate (vorher, Audit K9/V5-I4)** | Oracle-Konformitäts-Gate: `perm_runner.hpp:135-149` apply_conformance_gate_ + gate_failed_result_, aufgerufen in BEIDEN Mess-Pfaden (run_observable_perm:~164, run_workload_perm:~246); `pruef_dock/conformance_gate.hpp` treibt IDriveableTier gegen `std::map<uint64,uint64>`-Oracle (RF1-7 + 2000 deterministische Ops, insert/lookup/erase/clear/size + dagger-Ordnungs-Ops). Reihenfolge import→GATE→messen bindend; Beweis-Test `test_e3_contract_conformance_gate_wirksam` (beide Zweige). |
| REV-DATA-03 (P1, XML-Zusatzparser-Formen) | **offen — legacy-gated** | `Code/02_messung_driver/messreihen_workload.hpp` unverändert (nur direkte root-Kinder); ABER der konsumierende Legacy-Pfad läuft nur noch bei `COMDARE_LEGACY_MESSREIHEN=1` (main.cpp:327/344/631; E4-XML ist Alleinweg, P6/#229). Kein Selbst-Fix in WP-5 (nicht mandatiert); Auflösung fällt mit der data-gated P6-Voll-Entfernung des Legacy-Pfads zusammen. |
| REV-DATA-04 (P1, NaN/Inf/partial-stod) | **jetzt gefixt (`a6fbf5f4`)** | Vorher `best_binary_selector.cpp:28-33` rohes stod+catch→0. Jetzt: `parse_double_strict` (std::from_chars, voller Token-Verbrauch, std::isfinite); Pflichtfeld ns_per_op strikt, op_* leer=0 (n/a) sonst strikt; Zeilen-Verwerfung mit Diagnose (`reject_diags`, CLI-WARN). Fixture `best_binary_strict_values.csv`: 12junk/nan/inf/-inf/leer-Pflicht/op-junk verworfen (6 Diagnosen), Dezimal+Exponential akzeptiert; „strict rank: kein NaN/Inf im Ranking". |
| REV-DATA-05 (P0, --name-Pfad-Traversal) | **jetzt gefixt (`f9351b9a`)** | Vorher `best_binary_selector.cpp:165` ungeprüfter Pfad-Join. Jetzt: `valid_artifact_stem` (nur `[A-Za-z0-9_-]`, 1..120, reservierte Windows-Namen CON/PRN/AUX/NUL/COM1-9/LPT1-9 abgelehnt) als Schritt 0a VOR jedem Schreib-Effekt + weakly_canonical-Containment-Wache (Schritt 0b). 16 Allowlist-Checks + Builder-E2E-Negativ (`../evil` abgelehnt, keine Datei außerhalb out_dir). |
| REV-DATA-06 (P1, nicht-atomarer Publish) | **jetzt gefixt (`fe74b1c8`)** | Vorher: DLL direkt overwrite_existing, Sidecar-Fehler verschluckt, Manifest zuletzt geschrieben aber Mischstand möglich. Jetzt: komplettes Set in `.tmp_publish_<name>/` (DLL-Größe verifiziert, Sidecar-/Manifest-Flush geprüft), dann fs::rename-Commit DLL→Version→MANIFEST-ZULETZT (Commit-Marke); Fehler vor erstem rename lässt vorherige Generation vollständig unverändert; tmp-Aufräumen auf jedem Pfad. Builder-E2E-Positiv im Test. |
| REV-DATA-07 (P0, binary_id-Aggregat) | **jetzt gefixt (`f4bd67ac`)** | Vorher `rank_binaries` gruppierte NUR nach binary_id. Jetzt: kanonischer Cell-Key `workload\|working_set_n\|platform\|build_version\|series\|setting` (ohne Wiederholungs-Segment), erwartetes Raster = Union aller beobachteten Zellen, unvollständiger Kandidat DISQUALIFIZIERT (Diagnose), Aggregation = Median der Zell-Mediane; Manifest nennt cells/cell_dims/aggregation/missing_cells_policy. Fixture `best_binary_cells.csv`: Cherry-Picker (nur leichte Zelle, Median 50) verliert gegen vollständigen Kandidaten. Alte CSVs ohne Zell-Spalten = 1 Zelle = altes Verhalten (Fixture-1-Checks unverändert grün). |
| REV-DATA-08 (P0, Zyklen-als-ns) | **fixed (vorher, G2)** | `Code/02_messung_driver/measurement_writer.hpp:86-108` make_record_from_run: total_cycles/bytes honest-0 mit explizitem Kommentar „frueher: total_us*3000 @ 3 GHz bzw. n_ops*64" — Fabrikation ENTFERNT. Rest-Kante: `diagram_generator.cpp:379-382` rechnet weiterhin cycles~ns, konsumiert aber real nur noch honest-0 (⇒ 0-Balken statt Faktor-3-Fehler); reale Werte-Fabrikation existiert nicht mehr. |
| REV-DATA-09 (P1, Legacy-Mikrobench-Achsen) | **offen — legacy-gated** | `tools/permutation_codegen/codegen.cmake:434-483` unverändert (Layout wechselt Algorithmus, Allokatorstress vor t0); Konsument ist ausschließlich der V38.C-Plugin-Mikrobench hinter `COMDARE_LEGACY_MESSREIHEN=1` (main.cpp:344ff). Wissenschaftliche Tabellen speisen sich aus dem E4-XML-Weg. Voll-Entfernung = P6, data-gated (golden-320-Subsumtion unbestätigt, §12 07-13). |
| REV-DATA-10 (P1, ExperimentDriver-Erfolg) | **offen — legacy- + ABI-gated** | `libs/cache_engine/builder/experiment_driver/experiment_driver.cpp:497` `pr.succeeded = true;` bedingungslos; `module_abi_v1`-run_workload hat keinen Statusreturn (Fix bräuchte ABI-Kanal = ABI-gated). Pfad läuft nur bei `COMDARE_LEGACY_MESSREIHEN=1`. |
| REV-DATA-11 (P1, Baseline≠Kandidat-Workload) | **offen — legacy-gated** | `libs/execution_engine/src/result_aggregator.cpp:21-33` compare_against_baseline prüft weiterhin nur succeeded, nicht workload_used (das Feld wird seit V20.2/V20.3 getragen und exportiert, aber nicht als Vergleichsgate genutzt). Konsument = Legacy-Pfad. |
| REV-DATA-12 (P2, Median-Divergenz) | **offen** | Selector `best_binary_selector.cpp` lower_median (untere Mitte, `vals[(n-1)/2]`) vs. `csv_to_latex.cpp:48-54` + ~~`diagram_generator.cpp:414-420`~~ **→ `diagram_generator.cpp` `nearest_rank_median`, am 09.08.2026 auf `:653-659` (Anker gedriftet, s. Nachtrag D5-3 unter dieser Tabelle)** nearest_rank_median (obere Mitte, `rank=0.5*(n-1)+0.5`) — Divergenz bei geradem n besteht; im DATA-07-Umbau bewusst NICHT mitgeändert (nicht mandatiert; jetzt aber im Code ehrlich als „REV-DATA-12 offen" annotiert statt der früheren falschen „identisch"-Behauptung). Fix = zentrale Medianfunktion (eigener kleiner Increment). |
| REV-DATA-13 (P2, Welch-Zweitsample/Multiplizität) | **offen — legacy-gated** | `Code/02_messung_driver/main.cpp:458-515`: Welch-Sampling ist ein ZWEITER Lauf, rohe p<0,05 ohne Korrektur — unverändert; liegt vollständig im `COMDARE_LEGACY_MESSREIHEN=1`-Block (:344ff). |
| REV-DATA-14 (P2, Writer-Teilverlust) | **offen — legacy-gated** | `measurement_writer.hpp:49-66` add() inkrementiert num_records_ ohne per-Write-Statusprüfung; `main.cpp:415` meldet „geschrieben" bei `writer.ok() \|\| count>0`. Liegt im Legacy-Block; der offizielle E4-Pfad schreibt über den ce-Iterator (stream-verifizierter CSV-Write + Stamp-Gate, GOAL-M1.4). |

> **NACHTRAG 09.08.2026 — POSTEN D5-3, VORLAGE-KORREKTUR ZU REV-DATA-12.**
> *(Die Zelle oben bleibt wörtlich stehen. Was hier steht, kommt DANEBEN, nicht darüber.)*
>
> **1. Die Werkzeuge leben.** Eine frühere Planzeile führte REV-DATA-12 als „zeigt auf zwei
> **gelöschte** Werkzeuge" (Endfassung v1, Abschnitt 2.5 / S-A). Das ist am Objekt falsch: beide
> liegen im super-Baum und werden gepflegt — `Code/04_csv_to_latex/csv_to_latex.cpp` (1442 Zeilen)
> und `Code/05_diagram_generator/diagram_generator.cpp` (2064 Zeilen); letzter Commit, der beide
> Verzeichnisse berührt: **`6d837e7d`, 07.08.2026**, *„fix(csv_to_latex): der Generator wird an den
> Thesis-Stand nachgezogen (Owner-GO)"*. Der Befund REV-DATA-12 ist damit **nicht** erledigt, er ist
> **lebendig** — und D5-2 hat einen echten Gegenstand.
>
> **2. Ein Anker war gedriftet, der andere nicht — und nichts unterschied sie.**
> Beide Verweise standen in derselben Tabellenzelle:
>
> | Verweis in der Zelle | Ist am 09.08.2026 | Differenz |
> |---|---|---|
> | `csv_to_latex.cpp:48-54` | `nearest_rank_median` steht auf **48–54** | **0** — Anker hält |
> | ~~`diagram_generator.cpp:414-420`~~ | `nearest_rank_median` steht auf **653–659** | **+239 Zeilen** |
>
> Die im Wellenplan v2 behauptete Drift von 239 Zeilen ist damit **am Objekt bestätigt**, nicht
> übernommen. Zeile 414 trägt heute `f << "$1$"; // Gleichheit mit der Referenz` — eine Stelle aus
> der Achsenbeschriftung, die mit dem Median nichts zu tun hat. **Warum das teuer gewesen wäre:**
> D5-2 soll Sieger-Kürung, `csv_to_latex` und `diagram_generator` auf EINE Median-Definition bringen.
> Wer dafür `:414-420` aufsucht, vereinheitlicht eine Stelle, an der die Funktion nicht mehr steht —
> und der Kanon wäre grün, ohne den Divergenz-Fall zu berühren.
>
> **3. Die Heilung ist die Ankerform, nicht die neue Zahl.** Eine Zeilennummer als Anker ist eine
> Falle, die genau einmal pro Bearbeitung zuschnappt. Verankert wird ab jetzt am **Symbol**; die
> Zeilennummer läuft nur als datierte Bequemlichkeit mit und wird von `ci/anker_wache.sh` bei jedem
> Lauf gegen den Code gehalten. Die Wache druckt bei Drift **beide** Zeilennummern und die Differenz.
>
> **4. Nicht gedriftet, mitgeprüft:** der Gegenpol des Befundes, `best_binary_selector.cpp:183-188`
> (`lower_median`, Kommentar „= REV-DATA-12 (offen)" auf `:184`), steht in **beiden** heute
> erreichbaren ce-Bäumen (`wt-ce-xml 404ff6cf` und vendoriertes ce `a1d0c201`) unverändert auf
> denselben Zeilen. Dieser Anker bleibt, wie er ist.
>
> **Belegkommandos:** `grep -n '^\[\[nodiscard\]\] double nearest_rank_median' <datei>` ·
> `git -C /home/comdare/wt-super-landung log -1 --format='%H %ad %s' --date=short -- Code/04_csv_to_latex/ Code/05_diagram_generator/`
>
> ANKER-SYMBOL  Code/04_csv_to_latex/csv_to_latex.cpp  nearest_rank_median  48
> ANKER-SYMBOL  Code/05_diagram_generator/diagram_generator.cpp  nearest_rank_median  653

### REV-CI (super)

| ID | Disposition | Beleg (IST-Code) |
|---|---|---|
| REV-CI-01 (P0, „nicht existierendes Target") | **reject** | Behauptung „cmake --build --target löst nach CMake-Targetnamen auf ⇒ harter Fail" gilt nicht für den verwendeten Ninja-Generator: literal bewiesen (Scratch-Projekt, Target `messung_driver` mit OUTPUT_NAME `comdare-messung-driver`; `cmake --build build --target comdare-messung-driver` ⇒ „Linking CXX executable comdare-messung-driver", EXIT=0 — Ninja-Basename-Phony). Alle betroffenen Jobs konfigurieren `-G Ninja` (.gitlab-ci.yml:220-222/445/521); super-Pipelines liefen nachweislich grün (Ledger §12, z.B. 9221/9225/9229). Kosmetik-Empfehlung (comdare_da_tools verwenden) bleibt möglich, ist aber kein Defekt. |
| REV-CI-02 (P2, Libs statt CLIs) | **fixed (vorher)** | `.gitlab-ci.yml:269` integration:smoke baut `binary_to_csv_cli csv_to_latex_cli diagram_generator_cli` UND führt sie gegen Fixtures aus (:278ff); `comdare_da_tools` (Code/CMakeLists.txt:439-446) enthält beide Benennungs-Sätze. CLI-/main-Pfad ist damit CI-gedeckt. |
| REV-CI-03 (P1, Downstream main statt Gitlink) | **offen — CI-Politik-gated** | `.gitlab-ci.yml:163/173/183` triggern weiterhin `branch: main`; `.gitmodules` verfolgt development, Super konsumiert Gitlink-SHAs. Fix erfordert Parent-Gitlink-SHA-Forwarding + Kind-Assert = CI-Politik-Entscheid (nicht WP-5-mandatiert; gehört in den CI-Politik-Fork des Audits). |
| REV-CI-04 (P2, update=merge im CI) | **fixed (vorher, 07-13 Sweep B4/#22)** | `.gitlab-ci.yml:199-208`: harter Guard `git submodule status --recursive \| grep -E '^[-+U]'` ⇒ exit 1, Kommentar zitiert REV-CI-04 wörtlich. |
| REV-CI-05 (P2, Template-ref development) | **offen — Infra-gated** | `.gitlab-ci.yml:13` `ref: development` (mutable) unverändert; Pinning braucht zentralen Template-Release-Prozess (Infra/Cluster-Zone = Handover, kein Selbst-Fix). |
| REV-CI-06 (P3, Preset-Asymmetrie) | **offen** | `Code/CMakePresets.json`: 11 Build- vs. 7 Test-Presets (fehlend: ninja-mingw-minsizerel, ninja-mingw-relwithdebinfo, ninja-gcc-release, clang-release) — unverändert; P3, nicht mandatiert. |

### REV-TEX (thesis — Text-Agent-/Infra-Zone: NUR Handover-Vermerk, KEIN Selbst-Fix)

| ID | Disposition | Beleg (IST-Code) |
|---|---|---|
| REV-TEX-01 (P0, stale PDF = Erfolg) | **offen — Text-Agent-Zone → Handover-Vermerk** | `thesis/diplomarbeit/build.ps1:6` `$ErrorActionPreference = 'Continue'`, kein LASTEXITCODE-Check, Erfolg = `Test-Path "$job.pdf"` (Zeile 15) — unverändert. |
| REV-TEX-02 (P0, joblos-grüne Pipeline) | **offen — Infra-/Text-Agent-Zone → Handover-Vermerk** | `thesis/diplomarbeit/.gitlab-ci.yml:46/67` nur `if COMDARE_TEXLIVE_AVAILABLE == "true"`, keine Else-Fail-Regel — Pipeline ohne Toolchain bleibt joblos-grün. (Hinweis: der thesis:pdf-Job selbst ist inzwischen gehärtet — latexmk -halt-on-error + Warning-/.blg-Gates :72-75 — das deckt TEX-02 aber nicht, weil die Rule den Job ganz entfallen lässt.) |
| REV-TEX-03 (P1, EN nicht gegatet) | **offen — Text-Agent-Zone → Handover-Vermerk** | thesis-CI baut nur `diplomarbeit.tex` (DE-Default); keine de/en-Matrix. |
| REV-TEX-04 (P1, Provenienz nicht eingefroren) | **offen — gated (Messdaten + Manifest-Design) → Handover-Vermerk** | `generate_wide_appendix.ps1` ohne Input-Hash/Commit-Pinning (grep sha/hash = 0). Hängt an stabilen Messdaten (#156) + Provenienz-Manifest (G8/FF4). |
| REV-TEX-05 (P2, DE/EN-Generierung nicht atomar) | **offen — Text-Agent-Zone → Handover-Vermerk** | `generate_measurement_appendix.ps1`/`generate_wide_appendix.ps1` schreiben weiterhin sequenziell in kanonische Zielpfade. |

## F57 — Muster B (noexcept-auf-Alloc, REVIEW-BERICHT.md:277): UMGESETZT (ce `c38144e5`)

Alle im Voll-Review gelisteten Bodies verify-first geprüft (FP-Wache: nur bestätigt-allozierende geändert; die vielen `clear()`/Setter-noexcept der Pool-Stores sind allokationsfrei = keine Änderung):

**noexcept ENTFERNT (14):**
1–7. `axes/lookup/composable/{tree,btree,art_trie,hot_patricia,masstree_layer,start_trie,wormhole_leaf_list}_*pool_store.hpp` `free_node` (free_.push_back; Pool-Concepts verlangen kein noexcept — `tree_node_pool_concept.hpp:12` „KEIN noexcept-Zwang" wörtlich)
8. `axes/path_compression/axis_02_path_compression_real_trie.hpp` `insert_key` (nodes_.push_back) + 8b. pc-observable-Wrapper `insert_key`
9. `axes/prefetch_axis/axis_07_prefetch_path_oriented_impl.hpp` `note_hot_path_bytes` (enqueue→push_back)
10. `axes/prefetch_axis/axis_07_prefetch_observable.hpp` `observe_prefetch` (tracker_.enqueue; 0 produktive Aufrufer, Defekt trotzdem real)
11–12. `axes/value_handle_axis/axis_14_value_handle_real_slot.hpp` `store_value` ×2 (pool_/slots_/chain_.push_back) + 12b. vh-observable-Wrapper `store_value`
13. `include/cache_engine/allocators/families/a22_pmr_resource/pmr_resource_adapter.hpp` ctor (make_unique der pmr-Pool-Resource; IAllocationStrategy verlangt nur nothrow-DEstruktor, `axis_06_allocator_concept.hpp:86`)
14. `include/cache_engine/concepts/telemetry/path_read_counter.hpp` `record_block_read` (unordered_map::op[]; kein virtual — ITelemetryStrategy hat nur `kind()` virtuell)

**Allokation HERAUSGEHOBEN (2 — weil der Gattungs-Concept `BufferStrategy` clear()/peek_back() noexcept VERLANGT, `axis_q1_queuing_concept.hpp:50-55`):**
15. `topics/queuing/axis_q1_queuing/axis_q1_queuing_copy_on_write.hpp` `clear()`: teilt den im (nicht-noexcept) ctor vorab allozierten unveränderlichen Leer-Snapshot (CoW-korrekt: put/get mutieren *current_ nie in place)
16. `topics/queuing/axis_q1_queuing/axis_q1_queuing_priority_heap.hpp` `peek_back()`: O(1)-Min-Tracker (gepflegt in put/get/clear) statt Heap-Vollkopie; Minimum verlässt den Max-Heap nur als top() bei Gleichstand oder Leerung — Ergebnis exakt wie zuvor.

**ABI-gated-Rest (dokumentiert, NICHT angefasst):** die noexcept-ABI-Grenzfunktionen (`idriveable_tier.hpp:33` `virtual bool tier_insert(...) noexcept = 0` u. Geschwister + deren Overrides in `abi_adapter.hpp`) bleiben unverändert (ABI-Freeze §4). Ein dort auflaufender bad_alloc terminiert weiterhin an der ABI-Grenze — die Auflösung bräuchte einen ABI-Statuskanal (= #215/#216-Kette, User-gated). Die internen Pfade (Organe, Tools, Tests, nicht-ABI-Konsumenten) propagieren jetzt ehrlich.

**prt-art-Anmerkung:** `density_tracker.hpp` record (= REV-CXX-05) war der prt-art-Anteil von Muster B → `fc80c61`. Ein wörtliches free_node-Pendant existiert in prt-art nicht (Audit-F57-Randnotiz bestätigt).

## Verifikation (wörtlich, 2026-07-16)

- ce voller ctest (build-conf, g++ 16.0.1/Ninja): `100% tests passed, 0 tests failed out of 269` (ein Erstlauf hatte `99% … 1 tests failed` = `test_all19_segment_timer`, Label `measured` — Timing-Test unter Suite-Volllast; Rerun `Passed 0.18 sec`, Bestätigungslauf 269/269).
- golden: `1/1 Test #267: test_profile_roundtrip ........... Passed` (m3v2 → 320 binary_ids positionsidentisch zur Golden-Liste; zusätzlich in jedem Fix-Zyklus einzeln grün).
- E3-Gate inkl. neuem Capability-Fall: `Test #254: test_e3_contract_conformance_gate_wirksam ... Passed`.
- Selector: `Test #252: test_best_binary_selector_parse_rank ... Passed` (nach jedem der 4 Selector-Fixes).
- prt-art voller ctest: `100% tests passed, 0 tests failed out of 215` (213 vor WP-5 + 2 neue OLC-Tests).
- clang-format-22.1.8 `--dry-run --Werror` auf allen geänderten Dateien: exit 0 (je Commit).
- Mojibake-grep (nur addierte Zeilen): 0 (je Commit).
- CI-01-Beweis: Ninja-Scratch-Projekt `cmake --build build --target comdare-messung-driver` ⇒ EXIT=0.

## Folgearbeit (nicht WP-5)

- REV-TEX-01..05 → Handover an Text-Agent (Thesis-Repo) bzw. Infra (TEX-02-Rule); TEX-04 zusätzlich messdaten-gated.
- REV-CI-03/05 → CI-Politik-/Infra-Entscheid; REV-CI-06 → P3-Kosmetik.
- REV-DATA-03/09/10/11/13/14 → entfallen mit der data-gated P6-Voll-Entfernung des Legacy-Pfads (bzw. DATA-10 zusätzlich ABI-Kanal).
- REV-DATA-12 → eigener kleiner Increment „zentrale Medianfunktion" (Selector ↔ csv_to_latex ↔ diagram_generator).
- prt-art `main`-Branch: development ist jetzt 2 Commits voraus; main-Nachzug = separater Entscheid (nicht WP-5).
