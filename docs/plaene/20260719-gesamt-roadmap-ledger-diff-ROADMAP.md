# GESAMT-ROADMAP — Ledger-Diff-Synthese (557 Review-Items → dedupliziert)

> 2026-07-19. VERFEINERT die bestehenden Planungen — ERSETZT sie NICHT:
> - `docs/audits/20260719-konsolidierung-register-post-crash-REGISTER.md` (61 Einträge + adversariale Kritik 1–9 — hier eingearbeitet)
> - `docs/plaene/20260719-planer-ceb-tier-topdown-BAUPLAN.md` (Phasen 1–3 + Phase-0-Blocker + Forks A–E)
> - die 6+1 `docs/plaene/20260718-*.md` (Konformitäts-Reihenfolge · INC-2d · Incremental-Cache · New-Golden-All-Axes · opt-g/A2-Neben/neue-golden · Two-Cache-Storage · Storage-Verortungs-Brief)
>
> Faktenstand (gewinnt gegen Älteres): ce HEAD `5da2caf7`, super HEAD `1a8b95e`, Pipeline 11278 grün.
> ABI-6 / Magic `.A6.` / 17 Organ-Kompositions-Achsen / POD 1272 / golden-320 = Alias/Snapshot.
> `#50` Caching DONE · `#51` Storage CE-fertig+INERT (Weg-A-CI-Gate gelandet, Infra P1–P6 offen) · `#52` variant-Verbot DONE · `#45` A2-Neben DONE · INC-2d Variante A DONE · opt-Default O3 · 6 CEB-System-Achsen als CT-Schicht · Planer-Kopf FEHLT · Fuß CEB↔Tier REAL.
> Doktrin unverändert: Organ-Achsen bilden binary_id AUSSCHLIESSLICH; System/Mess-Achsen NIE binary_id; CT-only Hot-Path; Mess=1-Thread; CI-Grün=Messung AUS; NUR EIN offizielles XML-Programm; Messdaten/Doku nie löschen; golden-Neutralität je Schritt ausweisen.

---

## (A) Executive Summary — Marschrichtung zur Deadline 28.07.

**Was steht (CE-seitig fertig):** 17-Achsen-Komposition unter ABI-6; Fuß CEB↔Tier real (AnatomyModuleLoader dlopen, IPruefDock, 4 Symbole, `host_compatible_with`); DLL-Load-B (link_libs); die 3 golden-N-Voraussetzungen `#50`/`#51`-CE/`#52`; opt-f/opt-g (opt×simd-Permutation) im **Experiment-XML-Kanal** gebaut; Fehlerklassen-Framework D1/D2; golden-N-CRC64-Fixture (`all_axes_golden.profile.xml` + `FullSourceCatalog=CatalogAxes<2×17>` + `kNewGolden131072Crc64`) gelandet.

**Was fehlt auf dem kritischen Pfad (KORRIGIERT gegenüber Register-Exec-Summary, per Register-Kritik 1):** Der Engpass ist **NICHT nur Infra**. Es gibt **zwei parallele Beine**, die sich vor dem Messlauf treffen:

```
BEIN 1 (Infra, extern):  G-5 PAT-Rotation ─┐
                         G-3 #56 P1–P6 ────┤→ G-4 #51 scharf + E2E ─┐
                                                                    ├→ G-1 #46 Messlauf ─→ G-2 #47 Thesis-PDF
BEIN 2 (CE, selbst):     E-4 ext_hw-Knoten → E-3 Entkopplung+Guards ┤        (Deadline 28.07.)
                         → E-1 golden-N-XML/Wiring (+E-2-Timing) ───┘
PARALLEL (golden-neutral): Planer Phase 0 + Phase-1-I1/I2 + Phase-2-Wiring (Fork-C-Schnitt)
VOR der Auswertung:        17-Achsen-Nachzug super-Stufen 04/05/08 (sonst seg_attribution dauerhaft leer)
```

**Härtester Zeit-Konflikt:** golden-320-Volllauf hat 10-Tage-Timeout; bis zur Deadline sind es 9 Tage; golden-N=131072 wäre ~409× golden-320. → Die **#46-Baseline-Entscheidung (GN-11)** ist die wichtigste offene User-Entscheidung: Messlauf vor 28.07. gegen golden-320/kuratierten Satz (+Smoke) fahren, golden-N-Referenz als Compile+Test-Regressions-Detektor (bereits verankert) — Voll-Materialisierung/Voll-Messung golden-N nach der Deadline gestaffelt. `#49` bleibt OFFEN (Register-Kritik 2: nur der Fixture-Teil ist gelandet).

**Sofort ziehbar ohne GO:** die 9 Quick-Wins aus Register (C) + Bookkeeping-Nachzug (B6). **Vor jedem Bau:** die im Register (D) + hier B1/B2/B3 gesammelten User-Entscheide als EINE Morgen-Liste vorlegen (O-1…O-14, E-2-Timing, GN-11, Planer-Forks A–E, F1b, ISA-Pinning, page_type).

---

## (B) Diff-Tabelle Ledger vs. Code — OFFEN / DRIFT / ENTSCHEIDUNG, dedupliziert, je Strang

Legende: gn = golden_neutral (✓/✗). Status: O=OFFEN, D=DRIFT, E=ENTSCHEIDUNG nötig, (G)=gated-Anteil. Register-IDs (L/V/E/G/O/D-*) referenzieren `20260719-…REGISTER.md`.

### B1 — Strang Planer-Kette (Phase 0–3, Bauplan 20260719)

**Diff zum Bauplan:** Phase-0-Blocker präzisiert — der return-0-Stub liegt in `v32_orchestrator.hpp:92`, NICHT im Antrieb; `v32_messreihe_antrieb.hpp:259 execute_messreihe` ist VOLL implementiert, aber DEPRECATED-BY-DESIGN (Fork A 2026-07-16) + INERT. `resolve_selection` existiert NICHT (Bauplan-Kritik 4) → als NEU deklarieren. Phase 2 kann PARALLEL zu Phase 1 laufen (Bauplan-Kritik 5).

> **KONSOLIDIERUNGS-VERMERK §30 (2026-07-19):** Stufen-Zuordnung revidiert — Planer=MESS-Achsen (Permutation wandert von der CEB in den Planer; Planer kompiliert HART ein CEB je Messsystem) · CEB=SYSTEM-Achsen · Tier=ORGAN-Achsen · + optionaler Hybrid-Einschub. Bauplan-Fork A damit VERSCHÄRFT ENTSCHIEDEN. Präzisierungen PL-1-Scope + NEU PL-19/PL-20/PL-21 siehe „## KONSOLIDIERUNG §30 (2026-07-19)" am Dokumentende.

| # | Item | St | Quelle | Code-Ist | next_action | gn | berührte Fläche |
|---|---|---|---|---|---|---|---|
| PL-0 | Phase-0-Reconcile super-Skelett: Deprecation-Ruling vs. Bauplan-Wiederverwendung auflösen | O | Bauplan Phase-0; Ledger:2081; §12 Z.419 | `v32_messreihe_antrieb.hpp:1-3` DEPRECATED-BY-DESIGN, `:259` execute_messreihe REAL+INERT (COMDARE_V32_DRIVER_ENABLE); Stub = `v32_orchestrator.hpp:92`; PhaseStrategyFor real (`experiment_phase_strategy.hpp:166`) | Skelett (PhaseStrategyFor + execute_messreihe) WIEDERVERWENDEN/andocken statt 3. Engine; Deprecation-Banner als „reaktiviert als offizielles Skelett" fortschreiben | ✓ | super `02_messung_driver/{v32_messreihe_antrieb,v32_orchestrator,main}.{hpp,cpp}`, ce `profile_facade/experiment_run_entry.hpp` |
| PL-1 | Planer-Kopf: EIN Director + 2 ConcreteBuilder + Executable + Planer↔CEB-Vertragsgrenze (E-10/F5/PF2–PF4/§16.1-C3/§19.E-5) | O | Ledger:1885/1411-1415; Register E-10; Bauplan Phase 1 | nur header-only Naht `run_experiment_profile` (`experiment_run_entry.hpp:144`), 5-tiefer Schleifennest `:257-365`; `.gitlab-ci.yml` hand-maintained; kein Director-Typ im Baum | Phase-1-I1 (Director-Zerlegung + `--dump-plan` + Contract-Test) → I2 `CMakeGraphBuilder` opt-in → I3–I5 nach Fork C; Forks A–E User-GO | ✓ (INERT) | ce `profile_facade/`, neue App `comdare_experiment_planner`, `cmake/experiment_plan.cmake`, super CI |
| PL-2 | Phase-2: `CebSystemAxisDrive`-Vertrag (Spiegel `SearchAlgorithmDrive`) statt host-vorgebackener Closure | O | Bauplan Phase 2 | Achsen-Vokabular fertig (6 CT-Familien); Injektion heute `std::function`-Closure (`profile_run_facade.cpp:560-568`) | Drive-POD + `acquire_ceb_system_axis_drive`; **parallel zu Phase 1 machbar** (Kritik 5) | ✓ | ce `measurement/*_system_axis.hpp`, `build_orchestrator.hpp:227-230`, `profile_run_facade.cpp` |
| PL-3 | CoR `selection_filter_chain` verdrahten — Andockpunkt `resolve_selection` ist NEU (existiert nicht) | O | Ledger:1141/1414; Bauplan-Kritik 4 | `selection_filter_chain.hpp:87` einziger Konsument = `test_d15` | im Director als S4-Reduktionsstufe einhängen; leere Kette = Identität | ✓ | ce `builder/experiment_tree/selection_filter_chain.hpp`, Director |
| PL-4 | L6: `<metadata><mode>` nie konsumiert (env-Bypass) + kein MEASUREMENT_ON-Preset | O | §20.D-B7 (F02/F08/F61); Register L6 | env ersetzt XML still; verletzt single-XML-Doktrin | im Phase-0-Reconcile XML-mode-Konsum verdrahten; Build-Preset ergänzen | ✓ | super `02_messung_driver/`, `CMakePresets.json` |
| PL-5 | XML-Kanal-Konvergenz (Fork E): Experiment- vs. ThesisProfile nicht feature-deckungsgleich; ThesisProfile OHNE `<system_axes>` (G3); Pilot-Env `COMDARE_PILOT_*` umgeht XML (Audit-G3/G-7) | E | experiment_schema.xsd:22-40; xml_config_parser.hpp:195-246 vs :300-318; `profile_run_facade.cpp:122/258` | nur Experiment-Kanal hat opt/simd-XML; Thesis-Kanal hat repetitions/sweeps/run_options exklusiv | User-Entscheid: EIN Interpreter-Ziel — Experiment-XML additiv erweitern ODER ThesisProfile `<system_axes>` nachziehen; Pilot-Env danach nur Debug-Override | ✓ | XSD, `xml_config_parser.*`, `validate_profile.hpp`, `profile_run_facade.cpp` |
| PL-6 | 4 von 6 System-Achsen ohne XML-Kanal (target_isa, scheduling, load_framework, compiler-FAMILIE) | O | experiment_schema.xsd:129-184 | nur opt_level+simd haben Kanäle; Legacy-v32 hatte compiler_strategy/scheduling_strategy | entscheiden, welche XML-permutierbar werden (Haupt→Unter→Option-Muster, additiv) | ✓ | XSD, Parser, `validate_profile.hpp` |
| PL-7 | Schema-Erweiterungen: E11 Phasen-Kardinalität >3 klären; E9 Experiment-Serien-Envelope; F3i Reihe-C-Kategorie-Design | O | §12 Z.433 E11/E9; Ledger:1466-1470 | Validator prüft nur ≥1 Phase; kein Serien-Element; MergeStrategy 3-Enum-Kanon hält (korrekt) | Phasen-Struktur aus Thesis/Doku klären → XSD+Validator; Envelope-Variante 1; Reihe-C-Design dem User vorlegen | ✓ | XSD, `validate_profile.hpp`, `pruefling_merge.hpp` (nur lesen) |
| PL-8 | §16.2-M1: `<measurement mode="debug\|mess" threads>`-Schalter + echter thread_count-Konsum (#221 Fix A; heute LABEL-ONLY = Drift) | O/D | Ledger:1427-1431; m3v2:133-139 | `runtime_thread_count()` ohne Konsument; ehrlich auf 1 gepinnt (Mess=1-Thread-Doktrin) | Planer-I4: Schalter + Konsum NUR falls Multi-Thread-Messung je gewollt; sonst Kanal dokumentiert gepinnt lassen | ✓ | Parser, `runtime_variable_loop.hpp`, abi_adapter |
| PL-9 | Auswertungs-Verträge: E1 additive CSV-Endspalten (je Achse Algo-Wahl + `;phase;engine`); E3 n_repeats≥3-PFLICHT-Validierung | O | §12 Z.433 E1/E3; Ledger:1439-1443 | `lazy_csv_header` ohne phase/engine (grep=0); kein repeats-Check in `validate_profile.hpp` | additive Endspalten aus perm.algos + phase/engine; ≥3-Check fail-loud | ✓ | ce `cache_engine_builder_iterator.hpp`, `validate_profile.hpp`; super 04/08 header-tolerant |
| PL-10 | Serialisierung Q1–Q4 + §16.1-C2: Systemachsen-Ordner flach, tiefer Tier-Baum, dynamic-only-Spalten, Index-Manifest, atomarer build→ziel-Copy, Ein-Ziel-Ordner-`<output>` | O | §12 Z.423; Ledger:1405-1409/1433-1437/1885 | nur Sidecars (.version/.algos) + per_binary_subdirs als Embryo; Exporter schreibt DIREKT in `<output>`-Pfade (`v32_messreihe_antrieb.hpp:280-296`), altes ee_a_/ee_b_-Schema | Planer-I5 (nach Fork C i.d.R. NACH 28.07.); Q3 additiv gespiegelt, resume-sicher | ✓ | ce Emitter/`axis_path_serialization.hpp`, super Exporter, XSD `<output>` |
| PL-11 | Fehler-Sichtbarkeit Teil 2: aggregierter Fehler-/Fortschritts-Log NEBEN der CSV je Experiment | O | §12 Z.423; feedback_measurement_failure_visibility | „failed"-Zelle gebaut (INC-29.1); Log-Sidecar-Emitter fehlt (grep=0) | `<binary_id>.error.log` + Lauf-Log neben measurements.csv; Harness misst weiter | ✓ | ce Iterator, `experiment_run_entry.hpp` |
| PL-12 | „CEB schreibt SELBST ans XML-Ziel zurück" nicht erfüllt (Register-Kritik 4) | O | §12 Z.416 (User); Ketten-Audit §2.1 | `<output>` nur Provenienz-Log; autoritativ = host-gereichte out_csv; measurement_sink No-Op | als eigenen #44-Punkt tracken; Rückschrieb-Ziel vs. #51-measure-drop vs. out_csv im Planer-Strang reconcilen | ✓ | ce `experiment_run_entry.hpp:169-173/374-376` |
| PL-13 | E-9/P6: System⊃Tier-Stufen-Ort — System-Achsen flach im selben Vektor statt umschließende Baum-Schicht | O | Ketten-Audit P6; Ledger:1883 | `build_system_axis_levels()` konkateniert flach (`registry_to_axis_levels.hpp:113-141`) | großer Baum-Umbau, eigener Bauplan + GO, **NICHT golden-neutral planen**; nach 28.07. | ✗ | ce `registry_to_axis_levels.hpp`, `experiment_tree.hpp`, `profile_to_tree.hpp` |
| PL-14 | E-8/P5: Multi-Gattungs-Dispatch (Registry `select_for` statt hartkodiertem SearchAlgorithm) + V42-Docks + Graph-Genus (§19.C-Drift: Ledger „4 Gattungen inkl. graph" vs. 5 Genera OHNE Graph) | O/D | Ketten-Audit P5; §18.5.1; Ledger:1875 | Iterator `:811-812` hartkodiert `acquire_search_algorithm_drive`; Set/Sequence/Adapter/View-Docks als Header ohne register_dock; `graph_dock` fehlt | Registry-Dispatch + V42-Docks additiv (nach 28.07.); Graph-Genus bauen ODER Ledger auf 5-Genera-Ist | ✓ | ce `pruef_dock/*`, Iterator, `genus_binding_traits.hpp` |
| PL-15 | Zentralisierung: Auswertungs-Generatoren 03–09 als CEB-Bibliothek | O | Ledger:1297 (§15.5-5) | eigenständige super-Stufen; kein CEB-Einzug | nach Planer-Kopf optional andocken (XML wählt Auswertung) | ✓ | super `Code/03..09`, ce `profile_facade/` |
| PL-16 | H-8 Governor/Heuristik-CoR + Messkurven-Typsystem + Arbeitsmodus (Dossier 19/20) | (G) | §12 Z.418 H-8/Z.728-732 | kein Governor-Typ; CoR nur planer-seitig test-only | nach Messdaten (#156-Fenster) als E4'-Increment | ✓ | ce builder/topics (neu), `curve_fit` |

### B2 — Strang golden-N-Bau (N=2¹⁷=131.072)

**Diff zum NEW-GOLDEN-Bauplan (20260718):** §4-Schritte 1/3/4 sind GELANDET (`all_axes_golden.profile.xml` existiert; `CatalogAxes` 17-parametrig; `static_assert==131072` + CRC64-Anker `0xF1C1F26A1232073B`). Die 131072-Zeilen-id-Datei ist per Direktive durch die **CRC64-Referenz ersetzt** (keine Materialisierung der id-Datei nötig). Offen: Schritte 2 (Repoint — bewusst NICHT vollzogen, Entkopplungs-Entscheid), 5/6 (Generator-/Registry-Gen-Sync), 7 (Test-Umhängung), opt×simd-Wiring. Die All-Vary-take-2-Empfehlungen je Achse liegen aus dem Achsen-Inventar KOMPLETT vor (O-6 damit entscheidungsreif).

| # | Item | St | Quelle | Code-Ist | next_action | gn | berührte Fläche |
|---|---|---|---|---|---|---|---|
| GN-1 | E-4: aktiver `extension_hardware`-Familien-Knoten fehlt (Q2 Option C); §22 „F-SIMD KOMPLETT" = Drift | O/D | Register E-4; Ledger:2059 vs 2092; Audit G2 | einzige Klasse mit Label ist DEPRECATED (`extension_hardware_system_axis.hpp:4`); `SimdSubAxis.parent` (`simd_sub_axis.hpp:37`) zeigt auf verwaisten String | aktiven `CebSystemAxis` `axis_label()=="extension_hardware"` bauen (Analog CompilerSystemAxis, symm. gcc/clang), SimdSubAxis dranhängen; DEPRECATED-Insel NICHT reaktivieren | ✓ | ce `measurement/{extension_hardware_system_axis,simd_sub_axis}.hpp`, `validate_profile.hpp`, opt-g-Facade |
| GN-2 | E-3: golden-Referenz ↔ materialisierter Katalog entkoppeln + §26.6 negativer Instanziierungs-Guard (2¹⁷-Voll-Materialisierung = GB-TU/ICE, latenter Build-Bruch) | O | Register E-3 + Kritik 9; `source_catalog.hpp:86-88` | Entkopplung nur per Konvention/Doku; kein static_assert an der Katalog-Naht; `catalog_codegen.cmake` bewusst auf 320 | Design bestätigen + Guard (`static_assert` gegen `build_pilot_source_map<FullSourceCatalog::Engine>`) implementieren | ✓ | ce `source_catalog.hpp`, `catalog_codegen.cmake`-Umfeld |
| GN-3 | E-1: golden-N-XML-Vollzug — `all_axes_golden.profile.xml` EXISTIERT, trägt aber KEINE opt/simd-System-Achsen-Sektion (Kanal G3!) und ist nicht an den Lauf-Pfad gedockt | O | Register E-1 (+Kritik: §26.1-Wortlaut „XML fehlt" überholt); Ledger §22/§23.B | Fixture + CRC64 + static_asserts da; ThesisProfile-Schema kann system_axes nicht ausdrücken; Katalog bleibt 320 | opt×simd-Wiring über den PL-5-Kanal-Entscheid (Experiment-Kanal fahren ODER ThesisProfile additiv); gen_golden_fullpilot-Guard + Test-Umhängung (NEW-GOLDEN §4.5/4.7); Materialisierung gestaffelt (Storage-gated) | ✗ (Fixture-Schritt), Wiring ✓ | ce `thesis_profiles/all_axes_golden.profile.xml`, `source_catalog.hpp`, `experiment_run_entry.hpp`, `tools/gen_golden_fullpilot/`, tests |
| GN-4 | E-2-Rest: opt-f/g GEBAUT (Experiment-Kanal, §21.C ERLEDIGT) — offen = Timing des O3-Voll-Rebuilds + golden-N-Andockung | E | Register E-2 (Text präzisieren); Ledger:1984 | `ep.compiler.opt_levels`+`simd_options` + Perm-Schleife + per-Perm build_version real | Rebuild-Fenster-Timing vom User bestätigen (mehrtägig, NICHT golden-neutral) | ✗ | Messlauf-Fenster, `experiment_run_entry.hpp` |
| GN-5 | L2: stale-skip-Guard — `reflect_versions<alle 17>`-Instanziierungstest fehlt im Default-ctest (#50-Stale-Green-Wurzel; skaliert mit golden-N) | O | Register L2 (hoch); Ledger:2099 | grep `reflect_versions tests/` = leer; einziger Exerciser = CEB-Runtime | Unit-Test der `build_axis_variant_version_table`-Instanziierung über alle 17 Achsen; Force-Recompile+CI-Grün als completed-Kriterium | ✓ | ce `tests/unit/` (neu), `axis_variant_version_table.hpp` |
| GN-6 | O-6: 2. Variant-`name()` je Achse für All-Vary-2 | E | NEW-GOLDEN §7-GAP | Empfehlungs-Satz KOMPLETT vorhanden (Achsen-Inventar: k_ary+linear_scan · linear_fanout+hash_lookup · direct+pool_relative · none+patricia · node4+node256 · cache_line_aligned+packed_bitmap · std_malloc+pool_resource · none+path_oriented · none+wait_free · raw_binary+succinct · inline+chain_ref · heap+iot · in_memory+direct · none+adaptive · bloom+range_surf · no_buffer+lockfree_mpmc · eager+lazy) | User-Bestätigung des take-2-Satzes, dann XML-Werte fixieren | ✓ | `all_axes_golden.profile.xml` |
| GN-7 | O-1: rm `tier150_measurements.csv`(tests+build) + `adapter_measurements.csv` — §21.C-E2 sagt „freigegeben", nie vollzogen (Drift), Konflikt „Messdaten nie löschen" | E/D | Register O-1; Ledger:1980 | alle 3 weiterhin getrackt (git ls-files bestätigt) | EXPLIZITES User-GO einholen; sonst bis Messlauf zurückstellen + im Ledger vermerken | ✗ | ce `tests/unit/thesis_tiere/*.csv`, `build/thesis_tiere/` |
| GN-8 | O-3 opt-Stufen-Set der Mess-golden (Empf. O2/O3, Ofast nie: bricht Determinismus) · O-5 `COMDARE_GOLDEN_320_IDS`-Makro + 2 Grad-Hartkodierungen (source_catalog vs axis_registry_gen) · O-2/O-4 codegen-Minor-Politik + CI-Tripwire/Lock-Ort | E | Register O-2..O-5; Cache-Bauplan §8 | GO fixierte nur Default O3, nicht golden-Mitgliedschaft; Tripwire-Job nicht angelegt | als Block in die Morgen-Entscheidungsliste | — | tests/CMake, `tools/axis_version_lock/` (neu), CI |
| GN-9 | E-7: Bloat-Messung Binary-Größe je Tier-Binary (6-TB-Feasibility 131k×≤5MB) | O | Register E-7; Ledger:2049 | kein Größen-Artefakt; Andockpunkt `07_tier_binary_report` existiert | Stichproben beim golden-N-Probebau messen + persistieren | ✓ | super `07_tier_binary_report/`, ce build_orchestrator (Hook) |
| GN-10 | E7-Fixture-Single-Source + F27-Fixture-Kanon (experiment_golden.xml Doppel-Kopie ce/super) | O/(G) | §12 Z.433 E7; F27 user-gated | Sync-Pflicht via ctest-Gate; I7 nie gebaut | im golden-N-Umbau mit-erledigen; F27-User-Entscheid (kanonische Kopie) | ✓ | ce+super Fixtures, `fixture_sync_check.cmake` |
| GN-11 | #46-Baseline-Klärung: misst der Deadline-Lauf gegen golden-320 (materialisiert) oder golden-N (ungebaut)? `#49` OFFEN halten | E | Register-Kritik 1+2; Ledger:2013/2067 | §24.G-Kette springt #45→#44/#43→#46 und lässt #49 aus | User-Entscheid VOR Messlauf-Planung; Empfehlung: 320/kuratiert vor 28.07., golden-N-Vollzug danach | — | Messlauf-Scope, Board #46/#49 |

### B3 — Strang Storage-Scharfschaltung (#51/#56)

**Diff zum TWO-CACHE-Bauplan + Verortungs-Brief:** Phase I (CE-Seite) ist KOMPLETT gelandet (`artifact_cache.hpp` @HEAD, Nähte, from_env, Weg-A-CI-Gate). Ebene C ist per User-Entscheid A (2026-07-18) **measure-drop HTTPS-PUT, KEIN POSIX-NFS-Mount** — die POSIX-copy-Passagen des Bauplans sind damit superseded. Verbleibend = Infra-Ausführung + Policy-Entscheide.

| # | Item | St | Quelle | Code-Ist | next_action | gn | berührte Fläche |
|---|---|---|---|---|---|---|---|
| ST-1 | G-5: geleakter Vault-PAT rotieren + Transkript scrubben | (G) | Register G-5 (kritisch/Security); Ledger §25 Z.2077 | Leak im lokalen Transkript (`${PAT:-NEIN}`-Bug) | SOFORT durch Infra-Agent; blockt keinen Build | ✓ | Infra/Vault |
| ST-2 | G-3/#56: Infra-Handout P1–P6 AUSFÜHREN (prod-MinIO→V91, #72-vhid-91-Fix, Bucket `cache-engine-tier-binaries`, mc im Runner-Image, measure-drop-Endpoint, CI-Vars Projekt 288, persistentes Volume) | (G) | Register G-3; §24.F; INFRA-HANDOUT 2026-07-18; Verortungs-Brief §3 | Dokument done, Ausführung offen; CE byte-neutral bis Env | Infra-Agent abarbeiten lassen (Cluster für Impl-Agent read-only); DoD literal verifizieren | ✓ | Infra/Cluster, GitLab-CI-Vars |
| ST-3 | G-4/#51: Scharfschaltung `COMDARE_STORAGE_CACHE=true` + `COMDARE_PERSIST_MEASUREMENTS` + Ebene B/C End-to-End-Probe | (G) | Register G-4 | Weg-A inert-by-default gelandet (super `.gitlab-ci.yml:439-468`); Nähte synchron im 1-Thread-Loop | nach Infra-DoD: Probe-Lauf, mc-cp + curl-PUT literal belegen | ✓ | super CI, ce `artifact_cache.hpp` (unverändert) |
| ST-4 | measure-drop-VLAN-Verortung: „V60" (neueste Fakten) vs „V80, VIP 10.0.80.226" (Ledger §24.F + Verortungs-Brief Filterpod) | O | Ledger:2015-2020 vs NEUESTE FAKTEN | Widerspruch unaufgelöst | beim Infra-Vollzug verifizieren, Ledger danach fixieren | ✓ | Infra-Doku |
| ST-5 | Storage-Policy-Entscheide O-7…O-11: curl-PUT ersetzt/parallel Git-Writeback · Retention alter ABI-Binaries (5→6) · PULL im 1. Increment vs push-only · Granularität/Timestamp-Besitzer · Registry-XML-Versions-Spiegel optional | E | Register O-7..O-11; TWO-CACHE §6 | Doppel-Persistenz heute: git-persist (Token id=54) + Drop parallel angelegt | als Block in die Morgen-Entscheidungsliste; bis dahin Doppel-Persistenz (additiv) beibehalten | — | CI persist:measurements, artifact_cache-Konfig |
| ST-6 | Audit-G4: unmarkierter NAS-SMB-Behelfsweg neben dem EINEN measure-drop-Pfad (+V3 `copy_results_to_nas.sh`) | O | Audit 9dim G4; Register V3 | Behelf unmarkiert; Skript ohne DEPRECATED | DEPRECATED-Marker + Verweis auf measure-drop (NICHT löschen) — Quick-Win | ✓ | `scripts/copy_results_to_nas.sh`, Doku |

### B4 — Strang Konformitäts-Fixes (Audit G1–G10/P1–P8 + Quick-Wins + Klein-OFFEN)

**Diff zum KOORDINIERTE-REIHENFOLGE-Bauplan (20260718):** Schritte 1–7 + A2-Neben sind ALLE gelandet (INC-29, Namensfalle, INC-1a/b/c, F-SIMD bis auf Familien-Knoten=GN-1, INC-0, INC-2d, #45). Verbleibend sind die Audit-Findings + INC-29.2/29.3-Reste.

| # | Item | St | Quelle | Code-Ist | next_action | gn | berührte Fläche |
|---|---|---|---|---|---|---|---|
| K-1 | L1/G1==A1: Organ-only-binary_id nur Autor-Konvention — struktureller Guard fehlt | O | Register L1; Ledger:1975 | `profile_to_tree.hpp:70-82` pusht JEDEN `<axis ref>` als statisches Level; fertiger Prüfer `is_organ_axis_label` ungenutzt (`genus_organ_binding.hpp:39-45`) | Guard: Nicht-Organ-Achsen als statische Levels ablehnen; System nur über CEB-Kanal; + Regressionstest | ✓ | ce `profile_to_tree.hpp`, `validate_profile.hpp`, tests |
| K-2 | L3/P1: `static_assert(sizeof(ComdareTierObserverSnapshot)==1272)` fehlt | O | Register L3 (QW1) | nur Laufzeit-EXPECT + Kommentar `:125` | static_assert am Struct (~10 min) | ✓ | ce `anatomy/observable_tier.hpp:146` |
| K-3 | L4/G8+P2: Slot-Zahlen-Sweep 19/18/15/11/7→17/13/9/5 inkl. AKTIVEM stale static_assert (`kSetCompositionSlotCount=15` vs Soll 13, von `test_d9_set.cpp:38` zementiert) | O/D | Register L4 (QW8) | Konstante+Test stale; ~12 Kommentar-Loci (`axis.hpp:18` „19 Slots" u.a.) | Sweep als ein Commit; `organ_count()` bleibt honest 13 | ✓ | ce `set_composition.hpp:59`, `test_d9_set.cpp`, Kommentar-Loci |
| K-4 | L5: 3 build-i2-Tests (smoke/measurement/wdk) stale-rot + falscher generated-Include-Root im super-Sub-Build — per Kritik 6 AKTIVER Direktiv-Bruch (hart-grün), Severity hoch | O | Register L5 + Kritik 6; §20.D-B2/B4 | B2/B4-Include-Root-Gap vorbestehend; CI-Pipeline läuft die Tests nicht | Include-Root fixen (unter #44/L5), clean-rebuild-Beleg literal | ✓ | super `Code/CMakeLists.txt`, `Code/cmake/`, build-i2 |
| K-5 | best_binary_selector ABI-Spiegel STALE: kAbiMajor=5/„.A5." vs Host 6/„.A6." — Manifest schreibt FALSCHE Provenienz (§4-DEG, #179-Posten) | D | Ledger Z.251; b1-Item | `best_binary_selector.hpp:46/48`, `.cpp:384/386` „abi_major=5"; kein Paritäts-Test | Spiegel auf 6/.A6. syncen (oder decl-Header inkludieren) + Paritäts-static_assert; perm.algos-Mitkopie (Cache-Bauplan §10.9) prüfen | ✓ | ce `builder/best_binary_selector/*`, tests |
| K-6 | V6/P3: Loader reimplementiert Major/Minor-Gate inline statt `host_compatible_with()` | O | Register V6 (QW2) | `anatomy_module_loader.cpp:138-146` Hand-Check; Vertrag `:124-127` ungenutzt | umstellen (~20 min) | ✓ | ce `anatomy_module_loader.cpp` |
| K-7 | V7/P4: `all_axes_binary_count()` → `all_axes_matrix_count()` (System-Achsen ≠ binary_id) | O | Register V7 (QW3) | Name suggeriert binary_id-Produkt | Rename + Konsumenten-Sweep (~20 min) | ✓ | ce `registry_to_axis_levels.hpp:147-161` |
| K-8 | V2 + G-270a/H-1: cpuid_probe-Lücken (0x1A/0xB/0x1F, physical/logical_cores) + P/E-Core als dynamische Hardware-Unter-Achse | O | Register V2; Ledger:1211/1472-1476/1952 | kein 0x1A-Leaf (grep leer); keine P/E-Unterachse; ScopedThreadPin existiert | M-Aufwand-Increment (nach Deadline; prod2-gated für Intel-Tests) | ✓ | ce `platform_probe/cpuid_probe.hpp`, `hardware_isa_system_axis.hpp`, `runtime_variable_loop.hpp` |
| K-9 | E-5/INC-29.2: `ToolchainFehlt` (D1) definiert, kein Emitter — fehlender Compiler landet als ProzessStart/127 | O | Register E-5 | `axis_error.hpp:41` + `build_orchestrator.hpp:380-381` | Planer-Zeit-Toolchain-Vorprüfung emittiert D1; Ledger Z.1939 präzisieren | ✗ (Log-Verhalten) | ce build_orchestrator, axis_error |
| K-10 | E-6/INC-29.3/G6+#43: SampleStatus-Split (bool-valid-Konflation) + n/a-Renderer über Enum | O | Register E-6 (QW7-Teil); Ledger:1990 | `axis_error.hpp:13,49` „ersetzt SPÄTER…"; Iterator `:382-388` emittiert rohes „n/a" | n/a-Renderer als QW; voller Split als Klein-Increment | ✓ | ce Iterator, measurement_record/system_axis, perm_runner |
| K-11 | Marker-QWs: V3 NAS-Skript-DEPRECATED · V4 `CMakeLists.txt:550` Python-Codegen-Kommentar · V5 4 Root-Python-Skripte DEPRECATED + Windows-Pfad raus · V8 OPT-C-Bauplan Ofast→O3 | O | Register V3/V4/V5/V8 (QW4-6/9) | alle unmarkiert/stale (grep=0) | 4 Mini-Commits, NICHT löschen | ✓ | scripts/, ce CMakeLists, `_*.py`, Bauplan-Doku |
| K-12 | Kommentar-Drift-Sweep (byte-neutral): M-CE-10 „18 Achsen" (`prt_art_merge_reference.hpp:117/120`) · XSD-Kopf „19 Achsen/90 Bausteine" · m3v2-Kopf „19 SLOTS T0..T18" · `experiment_run_entry.hpp:143` „4→5-Bump"-Breadcrumb · 2 `OptO*SubAxis`-Reste · CI „16 Darstellungs-.tex" (`.gitlab-ci.yml:530/588/612`) | D | je Item-Quellen | Inhalt korrekt, Prosa stale | ein Sammel-Sweep bei nächster Berührung (m3v2 nur TABU-verträglich) | ✓ | Kommentar-Loci |
| K-13 | Registry-XML-Manifest-Drift: committed 18 Achsen/86 Bausteine (isa als composition T11) vs Generator HEAD 17+system_axis | D | `cache_engine_axis_registry.xml:1+77-82` vs `axis_registry_gen/main.cpp:206-238` | Generator emittiert korrekt, Commit stale | per `tools/axis_registry_gen` neu generieren+committen (binary_id-neutral); prt-art-Registry Schema-Gleichstand prüfen | ✓ | ce `algorithm_profiles/cache_engine_axis_registry.xml` |
| K-14 | Dataset-Doppelquelle `test_data_sets.xml` ohne DEPRECATED-Marker (GO-5 Fork 2: Akten=Single-Source) | O | Ledger:1288 | kein Marker (grep=0) | additiver DEPRECATED-Kopf mit Verweis auf `Code/test_data_xml/` | ✓ | ce `builder/example_configs/test_data_sets.xml` |
| K-15 | prt-art `PRT_ART_AXES_REUSE_MATRIX.md` ohne SUPERSEDED-Banner (verweist auf deprecatete vtable-Header + altes Profil-Modell; V32.FF.3-Taxonomie ≠ 17-Achsen-ABI-6) | D | b7-Item | einziges Alt-Dokument ohne Banner | Banner + Verweis auf `prt_art_axis_registry.xml`/CEB-System-Achsen (autonom-fähig, Doku) | ✓ | prt-art `docs/architektur/PRT_ART_AXES_REUSE_MATRIX.md` |
| K-16 | CI-Härtung: §7-CI-2-Drift (verbliebene allow_failure vs „gesamte Pipeline hart grün") + CI-5 -j/RAM-Politik je Runner-Tag | D/O | Ledger Z.269/272 | ce-CI `:124/:360` u.a. allow_failure | Hard-Gate-Sweep nach dokumentiertem Grün-Beweis; Politik-Doku minor | ✓ | ce+super `.gitlab-ci.yml` |
| K-17 | #21: A07-snmalloc LAUFZEIT-Segfault (V31AdapterAlloc) unadressiert | O | §12 Z.441/1000-1001 | Compile-Strecke geheilt (F12i); Runtime-Ursache offen | Vendor-Runtime-Untersuchung; bis dahin ehrliche „failed"-Zelle + Log | ✓ | ce ext/A07 (read-only), Adapter, Harness |
| K-18 | H-10 AVX10-Versionsfeld fehlt im BuildVariant-Sidecar | O | Ledger §18.1.7/§18.2.4 | nur simd_width_bits+simd_avx512 (grep avx10=0) | additives Feld + Reader + test_d7 (Sidecar-Versions-Bump ausweisen) | ✓ | ce `build_variant_definition*.hpp`, test_d7 |
| K-19 | §21.C-E3-Rest: perm_runner in `harness/`, Namespace aber weiter `builder::experiment` („so sauber wie möglich" nicht erfüllt) | D | Ledger:1981 | Commit cb775ea3 explizit „Namespace unverändert" | Mini-Increment Namespace-Umzug ODER bewusste Abweichung im Ledger verbuchen | ✓ | ce `harness/perm_runner.hpp` + Includer |
| K-20 | E16: Naming-Backlog + E9-raw-string echte Tilgung | O | §12 Z.433 E16; Ledger:1346 | kein Tilgungs-Beleg; Stelle nicht lokalisiert | verify-first lokalisieren, dann Klein-Increment | ✓ | ce xml_config_parser/, super v32-Parser |
| K-21 | memento_all-Mini: V5-I6-Rest (in-process memento_all auf SearchAlgorithmAnatomy) nirgends getrackt | O | b7-Item (F82-Lücke) | grep=0 in Code UND Ledger | 1 §8-Zeile nachziehen ODER bewusst supersedieren (Adapter-CoW deckt funktional) | ✓ | ce `search_algorithm_anatomy.hpp`, Ledger §8 |
| K-22 | §26.5: 07-16-VOLL-AUDIT (83 Befunde) ungelesen — F57 (noexcept-auf-Alloc ~15 Bodies) + DATA-07 unbestätigt; **VOR #46 abgleichen** | O | Register-Kritik 5; Ledger:2094 | `befunde-83.json` liegt; kein Abgleich-Artefakt | gegen Register abgleichen (v32-superseded vs live), Register nachziehen | ✓ | docs/, ggf. ce `axes/alloc/` |
| K-23 | #54-Nachweis: dedizierter datei:zeile-Beleg-Report „alle 3 Achsen-Familien XML/B+-Baum-gesteuert, kein Bypass" | O | Ledger:2022-2023; b6-Item | 2 Audits decken Teil; kein dedizierter Report | nach K-1 (gleiche Fläche) als Beleg-Agent-Lauf | ✓ | docs/audits/ (neu) |
| K-24 | G-8/G7: constexpr-Gate Organ-SIMD ≤ System-Zulassung nur Kommentar; Laufzeit-cpuid-Gate am Runner fehlt | (G) | Register G-8; Ledger:1975/1978 | Bau-Zeit-Gate existiert (`experiment_run_entry.hpp:124/277`); Runner-Gate „kommt mit PF2" | an PF2/INC-1c `freigabe_contract` gated; additiv | ✗ | ce hardware_isa/cpuid_probe/perm_runner |
| K-25 | F1b/F2: Set-Ebene-1-Promotion + native Set-Ops-ABI — Ledger sagt „Teil des Bündel-Bumps (UNVERHANDELBAR)", Code hat NICHT promoted (AnatomyGattung weiterhin 3; INC-2c-Kommentar sogar gegenläufig); 18.07.-Gattungs-Ruling deckt Ist evtl. | D/E | Ledger:1478-1485/1884 vs `anatomy_base.hpp:40-44/75-77`; b7-DRIFT | Set=Ebene-2-Genus MIT eigener ABI (ISetTier V1); extract/merge/V2-POD fehlen | User-Klärung: eigener ABI-7-Schritt terminieren ODER per 18.07.-Ruling supersedieren + Ledger/ABI-Kommentar nachziehen; NICHT autonom bauen | ✗ | ce anatomy_base/set_tier/set_dock/ABI-Decl, golden-Fixtures |
| K-26 | G-10/#52-Insel: 3 REV7-Header (algorithm_baustein/baustein_variants/resolve_baustein) deprecaten + `test_abi_interface` auf metaprog-Achsen-Wahl umstellen | E | Register G-10; Ledger:2048 | Quarantäne-Marker gesetzt; test-only-Konsument bleibt | unter GO additiv-erst deprecaten (nicht löschen); Test umstellen | ✓ | ce `abi/*.hpp`, `test_abi_interface.cpp` |
| K-27 | S-2c-Drift: Ledger fordert 4 Pflicht-Systemachsen inkl. NUMA+Locking — gebaut sind 6 andere; numa/locking_system_axis fehlen | D | Ledger:1318/1325 | ls leer für numa/locking-Achsen | User-Richtung: nachziehen ODER dokumentierten Ersatz (RC-/Scheduling-Unterachsen) als Supersede verankern | ✓ | ce `measurement/` (neu) oder Ledger |
| K-28 | Entscheidungs-Reste: O-12 page_type (Nachschlagewerk-Widerspruch) · ISA-Pinning der SIMD-Gate-Jobs jetzt vs #276 (§20.B) · prt-art telemetry-Demo-Slot Umkategorisierung · Allocator-16er-Familienraum nachziehen vs dokumentiert entfallen · S-4 eigene Mess-Kategorie · #254 RESTORE-2 · full_sampled-Semantik definieren/deprecaten | E | je Quellen | — | gebündelt in die Morgen-Entscheidungsliste | ✓ | divers |
| K-29 | AP-12/#246-Verifikation gegen AP-2-neu-Gate (+AP-14 messlauf-gated) · E14 Branch-Audit (4 Branches, je-Repo-GO vor Löschung) · F4/F7-Reststatus auflösen | O | Ledger Z.329/433; §18.3.1 | kein Abschluss-Beleg | einplanen (klein); Branch-Audit-Ergebnis als GO-Vorlage | ✓ | tests-Harness, Repo-Branches, Ledger |

### B5 — Strang Messlauf + PDF (FF0–FF4 → Thesis)

| # | Item | St | Quelle | Code-Ist | next_action | gn | berührte Fläche |
|---|---|---|---|---|---|---|---|
| M-1 | G-1/#46: FF0–FF4-Voll-Messlauf honest-100% (Deadline 28.07.) | (G) | Register G-1; Ledger §24.G/§23.B/§6 | gated auf ST-2/ST-3 + GN-Strang + mehrtägiges Fenster (nie pollen); Ablauf: Smoke DANN golden (COMDARE_RUN_MEASURE, PMC ON, --validate-Pre-Flight) | Baseline per GN-11 entscheiden; Fenster planen; K-22 vorher | ✗ | super measure-Jobs, prod1 |
| M-2 | G-2/#47: Thesis-PDF mit Messwerten, latexmk DE+EN grün | (G) | Register G-2 | gated auf M-1; im Autonomie-Scope (Messwert-LaTeX+PDF) | Anhang-Regen einspielen, beide Sprachen bauen | ✓ | thesis anhang/kapitel, Build |
| M-3 | DoD-6-Beweis: erster `measurement/<ts>/`-Ordner via persist:measurements | O | Ledger Z.33-39 | Mechanik komplett+INERT; measurement/ leer | beim Lauf `COMDARE_PERSIST_MEASUREMENTS=true` mitgeben | ✓ | super CI persist, measurement/ |
| M-4 | 19→17-ACHSEN-NACHZUG super-Stufen 04/05/08: `kSegmentCount=20` hartkodiert MIT seg_isa/seg_telemetry → 17-Achsen-WIDE liefert 17+1 seg-Spalten → `has_seg_ns=false` → **seg_attribution.tex wird NIE erzeugt**; + Thesis-Zahlen „neunzehn Achsen"/T-Nummern | D | b-latex-Item; `diagram_generator.hpp:182`, `.cpp:31-32` | Segment-Liste fix statt CE-Single-Source; Thesis-Text durchgehend 19 | Stufen 04/05/08 auf Single-Source (kV3AxisCount) umstellen **VOR der Lauf-Auswertung**; Thesis-Zahlen in Einleitung/Fazit/Anhang DE+EN korrigieren | ✗ (Anhang-Inhalt) | super 04/05/08, thesis kapitel+anhang DE+EN |
| M-5 | thesis:pdf-CI baut nur EIN PDF (Default de) vs. bilinguale Pflicht; zudem COMDARE_TEXLIVE_AVAILABLE-gated | D/(G) | `.gitlab-ci.yml:395-413` vs `build_all.ps1` | ein main-tex, kein -en-Jobname | auf 2×latexmk (\thesislang de/en) heben, sobald TeXLive-Gate fällt (Infra) | ✓ | super CI, thesis build |
| M-6 | CI-Kettenende NICHT geschlossen (INC-7): kein Copy-Back regenerierter .tex ins Thesis-Submodul; thesis:pdf hängt nicht hinter measure; + F10 Overleaf-Übernahme je Messung | O | `.gitlab-ci.yml:507-730`; §12 Z.432 F10 | persist sammelt nur nach measurement/<ts>/ | Copy-Back-Schritt (Submodul-Commit/Overleaf-Sync, Token+Loop-Schutz) + Job-Ordnung definieren = Kettenende „PDF mit Messwerten" | ✓ | super CI, thesis anhang/tabellen, .gitmodules |
| M-7 | Haupt-Text-Einbindung: `tikz/<spec_id>/` + `tabellen/` sprachneutral existieren nicht; 4 \input-Zeilen auskommentiert | O | 05_evaluation.tex:100-112 | kein Generator-Pfad erzeugt sie | nach erstem Lauf Stufe-04/05-Outputs ablegen + einkommentieren (oder auf Anhang konsolidieren) | ✓ | thesis tikz/tabellen, super 04/05 |
| M-8 | Achsen-Sensitivitätsanalyse (Kern-Auswertungs-Forderung: Varianz-Attribution je Achse, Ranking, Standard-Konfig-Empfehlung = Heuristik-Grundlage) — kein Writer existiert | O | 05_evaluation.tex:7-22/114-128 | nächstliegend: ld_exchange-Paar-Differenzen + exchange_forest | neuer 04/05-Writer + 08-Facade-Schritt; braucht golden-N-Datenbasis | ✓ | super 04/05/08 |
| M-9 | 4 fertige Heuristik-Kurven-Writer (sota_series/sweep_axis/seg_coverage/working_set_curve) parametrisch übersprungen — WIDE trägt series/sweep_axis/working_set_n nicht | (G) | csv_to_latex.hpp:195-224; appendix_generator.hpp:23-25 | Writer implementiert, kein Facade-Aufruf, keine \input-Stellen | sobald Läufe die Spalten emittieren: in 08-Facade + Anhang A (DE+EN, \InputIfFileExists) aufnehmen | ✓ | super 08, thesis Anhang A |
| M-10 | FF-Antworten in 06_fazit „steht aus"→Befunde; Anhang-A-Prosa Smoke-43-kalibriert nachziehen (additiv, alte Sektion historisch) | O/(G) | 01_einleitung sec:rqs; 06_fazit:9-51 | Fazit verweist auf outlook | nach Lauf umschreiben (DE+EN), Deadline-Teil | ✗ | thesis 05/06 + Anhang A |
| M-11 | G8-Rest: Anhänge B/E real geliefert (AP-B4/B5), CRC-Phantom doku-korrigiert — Rest = Messwert-Anhang-A-Regen | O | Ledger Z.90 + Z.912-926; Register-Abgrenzung | binary_blob_writer als reserviertes Nullfeld korrigiert | nur noch A-Regen nach Lauf; G8 im Ledger fortschreiben | ✓ | thesis Anhang |
| M-12 | PMC-Ausbau: I-PMC-2 (L3+branch_misses) / I-PMC-3 (Zen5-RAW L2+coherence, #187); Branch-Misses/IPC fehlen im Record-Schema (FF3-Metriken!) | O | Ledger:1325; A_measurements:12-13 | golden-Job baut mit PMC ON; Schema ohne branch/IPC-Spalten | verify-first Eventset; Record-Erweiterung separat entscheiden (ABI darf brechen); danach Limitierungs-Texte zurückbauen | ✗ | ce pmc_source, module_abi, super 03 |
| M-13 | Dataset-Loader-MESS-Konsum im Workload-Pfad (lauf-gated) + checksums sosd_books_200M/xml nachziehen | O | experiment_schema §datasets; b3-#269 | Loader-Slot hermetisch bewiesen (#184); 6/8 Akten mit checksum | im Mess-Fenster verdrahten; Checksums nur gegen echte Dateien | ✓ | ce dataset_loader, Workload-Pfad, Akten |
| M-14 | FF0-Owner Multi-Plattform explizit benennen | O | Ledger Z.215 | implizit (TargetIsa, ext_hw); kein Owner | bei 3-ISA-Strecke in Thesis+Ledger benennen | ✓ | thesis 01, ce CI |
| M-15 | E2: Welch-Konsument als EIGENE Auswertungs-Stufe über der WIDE-CSV | O | §12 Z.433 E2 | Welch nur im Katalog-Treiber-Pfad | eigene Stufe (liest measurements.csv je (phase,engine)) | ✓ | super Auswertungs-Stufe (neu) |
| M-16 | Post-Messlauf-GATED-Familie: fairness common_denominator-Pinnung (#156/#162) · HYBRID/IPC · curve_fit real · G-9/#27 telemetry-Sidecar-Token · chaos-Schwellen-Kalibrierung · AP-14 · Kap.-5-Ergebnisteil | (G) | je Quellen | Apparat steht, DATEN-gated | nach M-1 abarbeiten | — | divers |

### B6 — Strang Bookkeeping (Ledger/Board/Doku-Nachzug — kein Code)

| # | Item | Quelle | next_action |
|---|---|---|---|
| BK-1 | §12-LOG-Nachzug 07-18/19-SHAs NICHT erfolgt (Register-Kritik 8: neuester Eintrag 2026-07-17) | Ledger:413ff | SHAs aa25c9a4/d0313bf2/4334f1b8/ea2c544c/93a21233/0b669e9/9614ae0e/ce0e252d/cb775ea3/f1562636/5da2caf7 (+super ebf3ac5/0b669e9/65bf1bf/1a8b95e) eintragen; „NÄCHSTER STACK-SCHRITT" auf golden-N→FF0–FF4→PDF |
| BK-2 | Board-Fortschreibung: #45 DONE in §24.G/§22/§21.C; **#49 OFFEN halten** (nur Fixture-Teil verbuchen, Kritik 2); #53/#55 als EINE Einheit; D-2-prod2-Grün nur mit literalem Job-Beleg verbuchen (Kritik 7) | Register D-3/D-4/D-7 + Kritik | fortschreiben |
| BK-3 | Ledger-Stände in-place: §2-Blocker-Tabelle (alle 8 geräumt/ersetzt), §3-Tabelle S4–S9, §4 ABI-6-Stand + Bump-Historie, §6-Gate-Grund, DoD-1-Wortlaut (2 Bumps), §18.4.2 „18"→17 Verzeichnisse, System-Achsen-Zählung (6er-Liste compiler/opt/simd/target_isa/scheduling/load), §22 „F-SIMD KOMPLETT"→E-4-offen (Kritik 3), Repo-Stand-Zeilen | b-Items | ein Ledger-Sweep (WP-6), nichts löschen |
| BK-4 | Register-Selbst-Korrekturen: Exec-Summary „einziger Engpass=Infra" (Kritik 1), L5-Severity→hoch (Kritik 6), D-1-Wortlaut „nur ABI-kritisch frisch-grün" | Register (F) | Register additiv annotieren |
| BK-5 | O-13 Nummern-Kollision Board #43–#50 Epoch-2 vs §12 Epoch-1 → Epoch-Mapping-Note | Register O-13 | Note setzen |
| BK-6 | O-14 INC-2d-RECON: „isa raus" vs „isa-Organ-Typ bleibt Codegen-Träger" gegen Ist-Code als EINE Formulierung reconcilen | Register O-14 | Doku-Absatz |
| BK-7 | WP-6-Sweep-Rest: stale §11/§14/§15-Einträge (F35–F55), Nummernraum F40, F67-Alt-Ledger-Banner | §12 Z.435 | supersedieren, nie löschen |
| BK-8 | V1: #44-Backlog — G1–G10/P1–P8 als getrackte Ledger-Punkte aufnehmen (+PL-12 als neuer Punkt) | Register V1 | unter #44 eintragen |
| BK-9 | Bauplan-20260719-Präzisierung: Phase-0-Stub-Ort (v32_orchestrator:92, Antrieb real) + `resolve_selection`=NEU + Phase-2-Parallelität + Spiegel-Tabellen-.so-Zeilen als Fork-A-kontingent markieren (Kritik 3 des Bauplans) | Bauplan + Kritiken | additiv annotieren (dieses Dokument gilt als Diff-Träger) |
| BK-10 | S8/#215-Substanz (CoW real) in golden-N-/Messlauf-Strecke neu verorten („der 320-Neubau" ist mehrfach passiert) | Ledger Z.243 | §3-Zeile umformulieren |

---

## (C) DRIFT-Liste — Ledger/Doku korrigieren (Code ist weiter / anders als der Text)

Reine Fortschreibung, KEINE Löschung. ★ = zusätzlich CODE-Fix nötig (nicht nur Text).

1. **★ best_binary_selector ABI-Spiegel 5/„.A5." vs Host 6/„.A6."** — Manifest schreibt falsche Provenienz (K-5). Einziger Drift mit falscher Daten-Emission.
2. **★ L4 Slot-Zahlen** inkl. aktivem `static_assert(kSetCompositionSlotCount==15)` (Soll 13) — Test zementiert stale Wert (K-3).
3. **★ Registry-XML committed 18/86** vs Generator-HEAD 17 — Regen+Commit (K-13).
4. **★ 19-vs-17 in super-Stufen 04/05/08** (`kSegmentCount=20`, seg_isa/seg_telemetry) + Thesis-Text „neunzehn Achsen" — blockiert seg_attribution (M-4).
5. **★ thread_count LABEL-ONLY** vs XML-Kanal (ehrlich gepinnt; Fix A nur bei Bedarf) (PL-8).
6. **★ thesis:pdf-CI einsprachig** vs bilinguale Pflicht (M-5).
7. **★ full_sampled** parst still zu Defined (K-28-Entscheid: definieren oder deprecaten).
8. **★ perm_runner-Namespace** `builder::experiment` trotz harness/-Umzug (K-19).
9. **★ §7-CI-2 allow_failure-Jobs** vs Direktive hart-grün (K-16).
10. §4 Ledger „Major 4, Magic .A4." → real 6/.A6. (BK-3).
11. §22 „F-SIMD symmetrisch KOMPLETT" vs fehlendem aktiven extension_hardware-Knoten (GN-1; Register-Kritik 3).
12. §20.B „Die 6 CEB-System-Achsen stehen" zählt Telemetrie + deprecatete ExtHW-Insel — korrekte 6er-Liste: compiler/opt_level/simd/target_isa/scheduling/load_framework (BK-3).
13. §21.C-E2 „rm freigegeben" — nie vollzogen; Konflikt „Messdaten nie löschen" → O-1/GN-7.
14. E18-F1b/F2 „Teil des Bündel-Bumps" — Bumps liefen OHNE Promotion; AnatomyGattung weiter 3 (K-25).
15. §19.C „4 Ebene-1-Gattungen inkl. graph" vs 5 gebaute Genera ohne Graph (PL-14).
16. §18.4.2 „18 Verzeichnisse 20260716-*" → 17 (+13× 20260717) (BK-3).
17. Bauplan-Phase-0 „execute_messreihe = return-0-Stub" — Stub liegt in `v32_orchestrator.hpp:92`; Antrieb ist real (BK-9).
18. XSD-Kopf „19 Achsen/90 Bausteine" · m3v2-Kopf „19 SLOTS" · M-CE-10-Kommentar „18 Achsen" · `experiment_run_entry.hpp:143` 4→5-Breadcrumb · OptO*SubAxis-Kommentar-Reste · CI „16 Darstellungs-.tex" (K-12-Sweep).
19. §2/§3-DoD-Tabellen (B-Blocker, S4–S9) faktisch geräumt, Tabellen nie nachgezogen (BK-3).
20. S8/#215 „konsumiert 4→5, DER EINE 320-Neubau" — Rolle überholt, Substanz (CoW real) neu verorten (BK-10).
21. S-2c „4 Pflicht-Systemachsen inkl. NUMA/Locking" vs 6 gebaute andere (K-27 — User-Richtung).
22. Audit-G3: COMDARE_PILOT_*-Env steuert System-Achsen im Thesis-Pfad vs Eine-XML-Doktrin (PL-5/G-7).
23. prt-art REUSE-MATRIX ohne SUPERSEDED-Banner + V32.FF.3-Taxonomie ≠ 17-Achsen-Nomenklatur (K-15).
24. Vorlagen-/Zähl-Drifts Register selbst: Exec-Summary-Engpass, L5-Severity, D-1/D-2-Wortlaut (BK-4).
25. §24.F measure-drop „V80/10.0.80.226" vs neueste Fakten „V60" (ST-4 — beim Infra-Vollzug klären).

---

## (D) SUPERSEDED-Liste — Ledger-Nachzug (Historie behalten, als überholt markieren)

| Ledger-/Doku-Stelle | Überholt durch (Ist) |
|---|---|
| §13.1/§13.4/§13.12 TABU „POD 1416 · ABI-4 · .A4. · 19 Achsen · golden-320 unantastbar"; §12-passim-Invarianten „golden==320 UNVERÄNDERT" | koordinierte GO-Bumps INC-2b/2d: ABI-6/.A6., POD 1272, 17 Achsen; golden-320 = Alias/Snapshot (`_abi4`/`_abi5` additiv); neue Referenz = all-axes-N CRC64 |
| §0 DoD-1 „nach 3→4 genau EIN weiterer Bump 4→5"; §19.E-4/§19.F „der EINE reservierte Bump"; #268 „Reserve unverbraucht" | ZWEI genehmigte Bumps (4→5 INC-2c, 5→6 INC-2d), messdaten-erhaltend |
| V6.2 „4 CEB-System-Achsen über 19 Organ-Achsen"; §18.1.2 „VIER System-Achsen"; §18.2.1 „~70% konform, Schichtung fehlt"; §19.D-Delta | 6 CT-System-Achsen über 17 Organ-Achsen; Schichtung gebaut (AxisKind-Dach, build_system_axis_levels) |
| V6.3 „Bau NOCH NICHT freigegeben"; §17.B-Morgen-Entscheide; §18.5.2 „Freigabe steht aus"; §22-Schlusszeile „GO → INC-2d bauen" | VOLLES GO 17./18.07. (§19.A/§24); INC-2d vollzogen |
| V6.7/§19.F/§22-Kadenz „golden-Roundtrip==320 als Referenz" | Doppel-Anker: 320-Alias-Roundtrip + `kNewGolden131072Crc64` (source_catalog:126/167) |
| §21.B „FullSourceCatalog=CatalogAxes<4,4,5,4>" | `CatalogAxes<2×17>=131072`; 320 nur Alias `golden_320_catalog` |
| §21.D „keine erfundene `<simd>`-Zwischenebene" | §21.E-F-SIMD-Ruling: `<extension_hardware><simd><option>` symmetrisch zu opt_level (XSD+SimdSubAxis bewusst) |
| §20.B opt-c OF-2-Blocker (Ofast-Lesart) | A1-Ruling: Default O3; Ofast nicht-deterministisch getrennt |
| 18.1.8 „parse_experiment_profile nur test-/--validate-verdrahtet"; §16.6-I3-„LÜCKE"; I2-Infra-Block (snmalloc); §17.E measured=0 (mi_*); §17.E-Nebenbefund build-i2-Projektion | Brücke I1–I4 + F12i + INC-0/DLL-Load-B; Pipeline 11278 grün |
| §12 E10 „erst erweitern, DANN V32 zurückbauen"; Voll-Audit „v32 nicht messreif"; INC-G/H-v32-Strecke | Fork A: v32-Strang DEPRECATED-BY-DESIGN, aber per Bauplan 20260719 als OFFIZIELLES Planer-Skelett wiederverwendet (PL-0) — nicht rückbauen |
| F8 „4 Branch-Löschungen GO" | ersetzt durch E14-Branch-Audit-Pflicht (K-29) |
| #37-Scheduling „A+B echte 27. Organ-Achse (TABU-GO)" | 07-17-Ruling: CT-System-Achse (`scheduling_system_axis.hpp`); Organ-Variante separater, nicht begonnener TABU-Entscheid |
| §18.2.4/18.5.1 „INC-3 je GATTUNG golden_abi5_map/_set/_sequence materialisieren" | überholt durch golden-N-all-axes-Konzept (keine per-Gattung-Fixtures) |
| Legacy-XML-Welt: permutation_axes.xml-Cartesian, messreihe_v32-Schema (hardware/scheduling/compiler_strategy), config_a/b/c-REV7.6, CacheEngineConfig-4-Satz, isa-Domäne | Registry+Experiment-/ThesisProfil-Kanal; COMDARE_LEGACY_MESSREIHEN-gated; nichts löschen |
| §15.3 G-a1/G-a2 (PAT verloren/Runner offline, Modus a); §14.4/§17.D/§18.4.3/§19.G Repo-Stände | beide Remotes aktiv; HEADs ce 5da2caf7 / super 1a8b95e; Pipeline 11278 |
| Messlauf #9916 „läuft" | nie persistiert; Voll-Lauf wird neu aufgesetzt (M-1) |
| §0-V4/V5-Blöcke, Codex-Manager-Direktiven (§9), Worktree-Lektionen, B4.1 MinGW, §13.2/13.5–13.8-Historie, 20260618-Alt-Ledger-Punkte (#168/#149/A5/#125/c1-c2), V8-prt-art-ABI-Inheritance-Doku, Neben-Ledger (F67-Banner) | historisch; Nachfolger im Haupt-Ledger; Banner-Pflicht siehe BK-7/K-15 |
| §6-Gate-Grund „User-Zeitfenster + MinIO-500 + prod2-I/O" | heutige Gates: Planer-Kopf + golden-N + #51-Infra P1–P6 + Deadline (BK-3) |
| Q4-Befund „Lazy-Iterator castet an IPruefDock vorbei" | INC-2a: `acquire_search_algorithm_drive` (Rest = Multi-Gattungs-Dispatch PL-14) |
| §5/§2-B8 „AP-2/#236 90ns-Stub-Gate" | per W4-Katalog-Pfad-Gate ersetzt (F50) |
| I4-Teil-1 „failed-Zelle separater Increment" | INC-29.1 gebaut (Teil 2 = PL-11 offen) |
| TWO-CACHE-Ebene-C „POSIX-NFS-Mount-copy" | User-Entscheid A (18.07.): measure-drop HTTPS-PUT, KEIN POSIX-Mount |

---

## (E) Geordnete Marschrichtung — Meilensteine mit Abhängigkeiten

**Heute 19.07. → Deadline 28.07. = 9 Tage.** Prinzip: beide Beine parallel fahren; alles Golden-Berührende nur nach GO; jeden Schritt mit golden-Neutralitäts-Ausweis; CI-Grün=Messung AUS.

### VOR 28.07.

**M0 — SOFORT (Tag 0–1, parallel, kein GO nötig)**
- a) **ST-1** PAT-Rotation anstoßen (Infra, Security-sofort). — Abh.: keine.
- b) **ST-2** Infra-Handout P1–P6 beim Infra-Agenten anstoßen (der externe Engpass; jede Verzögerung schiebt M4/M5). — Abh.: keine.
- c) **Quick-Wins 1–9** (Register C): K-2, K-6, K-7, ST-6/K-11, K-10-Renderer, K-3, V8 — als 2–3 Sammel-Commits, je golden-neutral ausgewiesen. Dazu K-13 (Registry-Regen), K-14, K-15, K-12-Sweep-Teil, K-5 (ABI-Spiegel — klein, aber Daten-korrektheitsrelevant).
- d) **Bookkeeping BK-1…BK-10** (Ledger-/Board-/Register-/Bauplan-Nachzug; verhindert Falsch-Abschlüsse #49/D-2).
- e) **K-4/L5** build-i2-Include-Root fixen (aktiver hart-grün-Direktiv-Bruch).

**M1 — Morgen-Entscheidungsliste an den User (Tag 1; blockiert M2/M3-Start in Teilen)**
Ein Dokument, gebündelt: **GN-11** #46-Baseline (320/kuratiert vor Deadline vs golden-N danach — WICHTIGSTE Entscheidung) · O-1/GN-7 rm-CSVs · **E-2/GN-4** Rebuild-Fenster-Timing · O-2/O-3/O-4/O-5/**O-6 (take-2-Satz liegt vor)** · Planer-**Forks A–E** + E-10-Timing vor/nach Deadline · O-7…O-11 Storage-Policy · K-25/F1b · K-27/S-2c · K-28-Block (page_type, ISA-Pinning, telemetry-Slot, Allocator-16er, S-4, #254, full_sampled) · O-13/O-14.

**M2 — golden-N-CE-Strang (Tag 1–4; CE-seitig, NICHT infra-gated)**
Reihenfolge: **GN-1 (E-4)** → **GN-2 (E-3 + §26.6-Guard)** + **GN-5 (L2-Test)** → **GN-3 (E-1: Kanal-Entscheid aus PL-5, opt×simd-Wiring, Generator-/Test-Umhängung)**; GN-6-Werte nach M1-Bestätigung; **GN-9** Bloat-Stichprobe beim Probebau; **GN-10** Fixture-Single-Source mitnehmen. Materialisierung/Voll-Bau selbst erst nach M4 (persistentes Volume/Storage) bzw. laut GN-11-Schnitt. — Abh.: M1 (Teilentscheide); golden-neutral bis auf den ausgewiesenen Fixture-/Materialisierungs-Schritt.

**M3 — Planer-Strang golden-neutral (Tag 2–6, parallel zu M2; nur nach Phasen-GO aus M1)**
**PL-0** Phase-0-Reconcile (+ **PL-4** mode-Konsum) → **Phase-1-I1** (Director-Zerlegung, `--dump-plan`, Contract-Test, CSV-Byte-Identität bei Planer-OFF) → **I2** CMakeGraphBuilder opt-in → **PL-2** Phase-2-Wiring (parallelisierbar). PL-3 CoR im Director. Fork-C-Schnitt: I3–I5, Fork-A-.so, PL-10/PL-13/PL-14 NACH 28.07. — Abh.: M1-Forks.

**M4 — Storage scharf (sobald Infra-DoD; Ziel Tag 3–6)**
**ST-3** `COMDARE_STORAGE_CACHE=true`-Probe + Ebene-B/C-E2E literal · **ST-4** V60/V80-Verortung klären · ST-5-Politik gemäß M1. — Abh.: ST-2.

**M5 — Messlauf #46 (Fenster so früh wie möglich nach M2+M4; mehrtägig, NIE pollen)**
Vorher zwingend: **K-22** befunde-83-Abgleich · **M-4** 17-Achsen-Nachzug Stufen 04/05/08 (sonst Auswertung strukturell falsch/leer). Dann opt-in: Smoke (`COMDARE_MEASURE_PROFILE=smoke`) → Voll (`COMDARE_RUN_MEASURE=true`, PMC ON, `--validate`-Pre-Flight, `COMDARE_PERSIST_MEASUREMENTS=true` → **M-3**-DoD-6-Beweis). Scope laut GN-11. — Abh.: M2 (Baseline), M4 (Storage; notfalls per GN-11 auch ohne scharfes Storage mit lokal-persistentem output_dir — Entscheid in M1).

**M6 — Auswertung + Thesis-PDF #47 (während/nach Lauf, bis 28.07.)**
Anhang-Regen einspielen (**M-6**-Copy-Back-Minimalweg genügt zur Not manuell-dokumentiert) · **M-10** FF-Antworten + Prosa-Nachzug DE+EN · **M-5** beide Sprachen (TeXLive-Gate bei Infra eskalieren) · M-7 soweit Daten tragen · M-11 G8-Rest. — Abh.: M5. **Deadline-Definition erfüllt, wenn:** FF0–FF4 mit realen, CI-verifizierten Werten honest-100% beantwortbar + beide PDFs grün + measurement/<ts>/ persistiert.

### NACH 28.07. (geordnet)

**M7 — Planer-Vollausbau:** I3 CiYamlBuilder (Child-Pipeline, INERT) · I4 mode/failed+PL-8 · **I5/PL-10** Serialisierung Q1–Q4 + build→ziel-Copy + Ein-Ziel-`<output>` · PL-11 Fehler-Log · PL-12 CEB-Selbst-Rückschrieb · Fork-A-.so-Grenze · PL-6/PL-7-Schema-Erweiterungen · PL-9 CSV-Endspalten+n_repeats-Gate · M-15 Welch-Stufe · PL-15. — Abh.: M3.
**M8 — E-9/PL-13 System⊃Tier-Baum-Umbau** (eigener Bauplan + GO, nicht golden-neutral). — Abh.: M7-Grundgerüst.
**M9 — Gattungs-Ausbau:** PL-14 Multi-Gattungs-Dispatch + V42-Docks + Graph-Genus; K-25/K-26 F1b/F2 als koordiniertes ABI-7-Bündel-Fenster (falls M1 so entscheidet). — Abh.: M8 sinnvoll, nicht zwingend.
**M10 — golden-N-Vollzug:** Voll-Materialisierung gestaffelt (inkrementeller Cache + Storage tragen), Voll-/gesampelte Messkampagne, M-8-Sensitivität + M-9-Kurven-Writer → Heuristik-Messkurven (Dossier 20), H-8/PL-16-Governor, curve_fit real, M-16-Familie. — Abh.: M5-Erfahrung, M4.
**M11 — Konformitäts-/Klein-Reste:** K-8 (P/E-Core, prod2-gated) · K-9 · K-10-Voll-Split · K-17 A07 · K-18 AVX10 · K-19/K-20/K-21 · K-23 #54-Report · K-24 PF2-Gate · K-16-Hard-Gate-Sweep-Abschluss · M-12 PMC/Record-Erweiterung · M-13/M-14 · K-29.
**M12 — Infra-/Extern-gated:** G-11 aarch64-Cross (Toolchain-Handover) · G-12 prod2-P/E (`COMDARE_PROD2_AVAILABLE`, RMA ~Sept.) · G-13 GH200 (Miet-Zusage) · #273-T2 gcc-15.3-Pin · G-14/S-7 (Opus-Session; Plan auf ABI-6/1272 re-basieren) · #38 · F72-Vendor-Allokatoren.
**M13 — ALLERLETZT (User-Anordnung):** #276 3-ISA-Voll-Matrix hart. **Projektende:** G-15/#274 measurement-all-Migration (G5-Vorlage neu fahren).

---

## (F) KORREKTUR-NACHTRAG (Vollständigkeits-Kritik 2026-07-19, adversarial verifiziert)

**F-1 — FEHLENDE Ledger-§ §27+§28 (die 2 NEUESTEN Einträge, 19.07.) — Lücke im Ledger-Diff:**
- **§27 Registry=ANGEBOT / Anwender-XML=ANZEIGE (.pom-Resolver-Modell):** zusätzliche Resolver-/Link-Stufe im Planer (Angebots-Parse der Registries → Anwender-XML-Parse → Resolve jeder Referenz, unregistriert = harter Validierungsfehler; Andocken an `validate_profile.hpp`, KEIN Parallel-Validator). §27 fordert EXPLIZIT den Fold in DIESE Roadmap (wf_14d29ad2) — nachzutragen als **PL-17** im Planer-Strang B1 (Fläche: `validate_profile.hpp` [Hotspot 4, Owner Agent-E/Planer-Owner], XSD/Parser; Ergebnis-Doc existiert bereits: `docs/plaene/20260719-registry-angebot-anwender-xml-resolver-STUFE.md`, hier bislang NICHT referenziert).
- **§28 DREI art-spezifische Achsen-Registries (je Modul):** Organ-Registry (existiert: ce + prt-art) + **System-Registry (NEU, measurement-Modul: 6/7 CEB-System-Achsen + Unter-Achsen opt/Flags/simd/march/target)** + **Mess-Registry (NEU, Mess-Modul: 16 Kategorien/Kollektoren/DynamicDims/Workload)**; Haupt-Achse CT-statisch, Unter-Achsen meist dynamisch. Betrifft PL-5/PL-6 (die 4 fehlenden System-Achsen-XML-Kanäle laufen per §28 über die NEUE System-Registry, nicht nur über XSD-Erweiterung) und den „2-Registry-Kanon" (CI-DETAIL 1.1/KATALOG A.6 — dort Ist-Beschreibung, Ziel = 3 Angebots-Bibliotheken). → als **PL-18** tracken; Morgen-Liste M1 um Scope-Frage ergänzen (Resolver-Stufe VOR oder MIT Phase-1-I1?).

**F-2 — K-9-Timing-Diskrepanz zur Parallelisierungs-ANALYSE:** M11 (nach 28.07.) listet K-9; die ANALYSE (Seriell-Strang Schritt 4) plant K-9 „zwischen den Fenstern" VOR M-1. Kein Sachkonflikt im Inhalt, aber die Einplanung ist zu vereinheitlichen (Entscheid: nur nötig VOR Messlauf, falls D1-ToolchainFehlt-Sichtbarkeit im #46-Lauf gewünscht — sonst M11). In die M1-Liste aufgenommen.

*Golden-Neutralität: Alle M0/M3-Schritte ✓; M2 ✓ bis auf ausgewiesene Fixture-/Materialisierungs-Schritte (✗, GO liegt vor); M5/M6-Messteile ✗ per Definition (Messdaten additiv, nie löschen); M8/M9 ✗ (eigene GO-Fenster). Dieses Dokument ist additiv — es ersetzt weder Register noch Bauplan noch die 20260718-Pläne, sondern trägt deren Ledger-Diff.*

---

## KONSOLIDIERUNG §30 (2026-07-19) — PL-Strang-Präzisierung

> Quelle: Ledger §30 (User-Entscheid 2026-07-19, autoritativ; revidiert frühere Zuordnungen). ADDITIV; ergänzt B1 + (F).

- **PL-1-Scope PRÄZISIERT:** der Planer trägt (a) die **MESS-Achsen-Permutation** (wandert von der CEB in den Planer; 16 Kategorien/Kollektoren, DynamicDims, Workload-Achse — gespeist aus der Mess-Registry, PL-18/§28) und (b) die **CEB-GENERIERUNG**: der Planer bestimmt das Messsystem und **kompiliert HART ein effizientes CEB je Messsystem**. Stufen-Zuordnung: Planer=Mess · CEB=System (kompiliert Tier-Binaries) · Tier=Organ. **Fork A damit VERSCHÄRFT ENTSCHIEDEN** (CEB = vom Planer generierte+kompilierte Binary, nicht nur .so-Grenze) — in der M1-Liste „Planer-Forks A–E" als entschieden führen; B–E bleiben offen. PL-2 (`CebSystemAxisDrive`) bleibt gültig als System-Nutzlast der CEB→Tier-Stufe.
- **NEU PL-19 — Gesamtbaum-Färbung/Zerlegung:** EIN Experiment-B+-Baum, Nodes je Achsen-Art GEFÄRBT (Träger existiert: `AxisKind{organ, system_measurement, system_config}`, `topics/axis.hpp:17-20`) und filterbar + Filter-/Zerlege-Operation je Achsen-Art → je Stufe permutieren, lazy Kette gestaffelt (Organ-Teilbaum→binary_id · System-Teilbaum→CEB-Kompilation · Mess-Teilbaum→Planer-Permutation). PL-13/Audit-P6 geht darin auf (EINE Baustelle; eigener Bauplan + GO, nicht golden-neutral, nach 28.07.).
- **NEU PL-20 — HYBRID-Binary (optionales 4. Kettenglied, späteres Increment):** die CEB entwickelt nach der Mess-Auswertung Heuristik-Hybrid-Tier-Binaries, die ihrerseits echte Tier-Binaries delegiert durch CEB entwickeln/laden (rekursive Delegation; Dossier 19 + architektur/20; knüpft an PL-16/H-8 an). NACH Abgabe (M10-Umfeld).
  **→ NACHTRAG §31 (User 2026-07-19, REVIDIERT — SCOPE-ÄNDERUNG):** „NACH Abgabe (M10-Umfeld)" ist ÜBERHOLT — der Hybrid-Einschub ist **ABGABE-PFLICHT vor 28.07.** („Da der Fuß und die Tier-Binary-Permutation vollständig steht, ist dies auch ein Abgabekriterium … das ist mit Pflicht"); PL-20 wandert aus M7+ in den Vor-Deadline-Scope, Meilensteine entsprechend nachziehen.
- **NEU PL-21 — System-/Mess-Achsen-Join (deprioritisiert-getrackt):** Achsen-Algorithmus-Join wird auch für System- und Mess-Achsen unterstützt; Implementierung per §30 nach hinten geschoben (nach Ergebnisse/Abgabe) — als getrackter Punkt führen, nicht still fallen lassen. Organ-Join (Stufe1_CeOnly/Stufe2_PrueflingReplace/Stufe3_FullJoin) = JETZT, existiert.
- **Mess-Modi (§30.3):** XML-Steuerbefehle je Achse ODER per Gesamtexperiment (enumerierte Range oder benannte Algorithmus-Listen je Achse, permutiert durchgetestet) — konkretisiert Fork R5 der PL-17-Resolver-Stufe.
- **Registry-Stufen-Mapping (§28×§30):** Mess-Registry→Planer · System-Registry→CEB · Organ-Registry(+prt)→Tier (präzisiert PL-17/PL-18).
- **Infra-Stand-Nachtrag (ST-Strang):** Storage Ebene B+C scharfschaltbar (P1–P3 done); Smoke-Pipeline 11365 mit `COMDARE_STORAGE_CACHE=true` gelaufen — ST-2 teilweise vollzogen; ST-3-Rest = literale E2E-Belege + Politik-Entscheide (ST-5). **NACHTRAG §31 (Storage-Stufen-Zuordnung, User-präzisiert):** CI-Cache (dev-MinIO `minio.comdare.local`) hält NUR die Planer-Binary (statisch, Kopf); prod-MinIO (`https://minio.prod.comdare.de`, Bucket `cache-engine-tier-binaries`) hält ALLE dynamisch GENERIERTEN Folge-Stufen-Binaries (CEB je Messsystem + Tier + Hybrid) + Systemaufstellungen (Sidecars/Provenienz) — Ebene B erweitert von „Tier-Binaries" auf „alle generierten Folge-Stufen".

---

## KONSOLIDIERUNG §35–§39 (2026-07-19 abends) — Meilenstein-Nachzug

Die Abschnitte §35–§39 des Ledgers (Cluster-Parallelisierung, Pool-Modell, Freigabe-Generalisierung, §38-Dock-Protokoll, Infra-Autonomie) verschieben/ergänzen die (E)-Marschrichtung wie folgt:

| Neu | Inhalt | Stand 19.07. abends | Haengt an |
|---|---|---|---|
| M-§35a | 24-Zellen-Bau-Matrix (resource_group-Locking + Capability-Tag-Routing + mc-Dedup) | **GELIEFERT** (W4-A, super-CI) | — |
| M-§35b | Runner-Capability-Tags amd64/avx2/avx512 | **GELIEFERT** (IMPL selbst, §39-Freigabe; prod1/prod2 getaggt, kleine Nodes bei Online-Gang) | — |
| M-§35c | Kalibrierungslauf (TOTAL=64, 24 Zellen a 16, Ebene B scharf) | **LAEUFT** (Pipeline 11453) | M-§35a+b |
| M-§35d | Voll-Matrix golden-N 2^17 (4 Chunks a 32768 je System-Permutation) | offen — GO nach 11453-Auswertung (Zeit-Hochrechnung + GN-9-Bloat-Deckel) | M-§35c |
| M-§38a | Dock-Nutzlast hinab: ExperimentSubtreePayload + R5-XML + Roundtrip-Gate | **IN BAU** (W5-C) | — |
| M-§38b | Fortschritts-Rueck-Kanal: ProgressDelta + ProgressSinkFn-Naht + done-Signal | **IN BAU** (W5-C) | — |
| M-§38c | --dump-plan-CLI (I1-Rest) + CMakeGraphBuilder (I2) | **IN BAU** (W5-B) | — |
| M-§38d | ceb-measurement-exclusive resource_group (Mess-Jobs) | **GELIEFERT** (W5-A, 7cca57a) | — |
| M-§37a | Aktive CEB-Generierung je Messsystem (Fork C .so-Schnitt) + State-Pattern-Freigabe | offen (nach W5; Fork C ungeschnitten, Ledger-Designluecke) | M-§38a-c |
| M-§39a | Ebene-C-Basic-Auth-Fix (artifact_cache) | **IN INTEGRATION** (Fix im Tree, 201 live belegt) | — |

B5 (Messlauf+PDF) bleibt der kritische Pfad: nach M-§35d folgt F2-Regime → M-4 → #47 (unveraendert).
