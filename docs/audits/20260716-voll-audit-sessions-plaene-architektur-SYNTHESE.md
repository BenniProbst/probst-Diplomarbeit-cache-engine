# Chef-Auditor-Synthese — Voll-Audit (letzte 10 Sessions/Pläne/Architektur), 83 bestätigte Befunde

Stand 2026-07-16. Alle Befunde `confirmed:true` mit korrigierten Severities. Verteilung: **9 high / 38 med / 36 low** · Kinds: 18 bug, 29 stale-doc, 18 untracked-promise, 11 design-conflict, 7 wrong-assumption · **70 autonom fixbar, 13 user-/infra-gated**. Kein Befund bricht TABU, golden-320, POD-1416 oder ABI-4; kein Befund verfälscht bereits persistierte Messdaten.

---

## (1) Befundtabelle

Dim-Kürzel: SN=super-neu-code · CE=ce-neu-code · RW=registry-wahrheit · KW=konsolidat-widersprüche · SB=sessions-backups · AR=architektur-in-sich · LK=ledger-kontinuität-4repos

| ID | Dim | Kind | Befund (Kurzform) | Ort (Beleg) | Sev | Autonom |
|---|---|---|---|---|---|---|
| F01 | SN | bug | Konformitäts-Gate gated nicht: Fail fließt unmarkiert in CSV, Exit 0 | v32_katalog_driver.hpp:122-131 + v32_messreihe_antrieb.hpp:122-183 | **high** | ja |
| F02 | SN | bug | `<metadata><mode>` nie konsumiert; env ersetzt XML still | v32_messreihe_antrieb.hpp:256/271 + main.cpp:303-306 | **high** | ja |
| F03 | SN | wrong-assumption | WorkloadKind verworfen: OP-1..6 messen identisch (Phantom-Etiketten) | v32_katalog_driver.hpp:94-106 vs op_type_filter.hpp:48-54 | **high** | ja |
| F04 | SN | bug | ee_b_engine-Label hartkodiert — CSV lügt in 2/3 Phasen | v32_katalog_driver.hpp:148-151 | med | ja |
| F05 | SN | bug | TikZ: unescapte `_` in symbolic x coords + stale Legende | messreihe_report_exporter.hpp:87-106 | med | ja |
| F06 | SN | bug | CSV ohne Quoting: Komma in phase.name verschiebt Spalten still | messreihe_report_exporter.hpp:51-57 + antrieb:173 | med | ja |
| F07 | SN | bug | defined()-Gate-Mismatch + ungeprüfter dynamic_cast (UB bei =0) | v32_katalog_driver.hpp:119-123 + main.cpp:56/302 | low | ja |
| F08 | SN | untracked-promise | Offizieller INERT-Andock in keiner Build-Konfig baubar (MEASUREMENT_ON fehlt) | 02_messung_driver/CMakeLists.txt:54-56 | med | **nein** |
| F09 | SN | design-conflict | In-process statt Laufzeit-DLLs; Hosts HOT-gepinnt, `<lebewesen>` ignoriert | v32_katalog_driver.hpp:119/140 + antrieb:100-117 | med | **nein** |
| F10 | SN | untracked-promise | Workloads hartkodiert 2000/2000/seed42; `<workloads>/<datasets>` tot | v32_messreihe_antrieb.hpp:216-219 | med | **nein** |
| F11 | SN | bug | parse_enumeration_mode: stiller Defined-Fallback bei Tippfehler | v32_messreihe_antrieb.hpp:78-83 | med | ja |
| F12 | SN | bug | op_types ungeprüft: Bogus-Token mislabelt, leer erfindet "OP-1" | antrieb:141/150/170 + validate_profile (fehlend) | med | ja |
| F13 | SN | bug | ${date} 2× berechnet, lokale TZ (End- statt Startdatum) | v32_messreihe_antrieb.hpp:233-249/281-282 | low | ja |
| F14 | SN | wrong-assumption | Relative `<output>`-Pfade gegen Prozess-CWD, `<output_dir>` außen vor | antrieb:281-288 + test:116 | low | **nein** |
| F15 | SN | bug | dispatch_phase-Fehler per `(void)` verschluckt (Phantom-total_axes) | v32_messreihe_antrieb.hpp:225 | low | ja |
| F16 | SN | stale-doc | "per-Op static dispatch" falsch: std::function+vtable im Timed-Loop | antrieb:35-36 vs execute_engine_command.hpp:51/101-115 | low | ja |
| F17 | SN | design-conflict | Exporter zieht Surrogat-Header transitiv in jeden W4-Mess-TU | messreihe_report_exporter.hpp:13 + v32_orchestrator.hpp:10/17-18 | low | ja |
| F18 | CE | bug | 3 Wave-Tests (INC-D/INC-3/M-CE-05) laufen in KEINEM CI-Job (Muster F) | .gitlab-ci.yml:286/408 + tests/unit/CMakeLists.txt:2410/2534/2562 | **high** | ja |
| F19 | CE | design-conflict | sota_series merge nie validiert → stiller Reihen-Drop (19-von-21-Rauschen) | validate_profile.hpp:229-256 + sota_catalog.hpp:346-347 | **high** | ja |
| F20 | CE | untracked-promise | Versprochene mode-Enum-Prüfung fehlt; op_types/version/ep.datasets ungeprüft, kein xmllint | xml_config_parser.hpp:259 + validate_profile.hpp:376-386 | med | ja |
| F21 | CE | wrong-assumption | Phasen-Kardinalität: XSD==3 vs Doku ">=1" vs Validator >=1; engine/engines-XOR unerzwungen | XSD:84 vs hpp:294 vs validate:457-459 | med | **nein** |
| F22 | CE | bug | phase.engine/pruefling/engine-id-Eindeutigkeit ungeprüft; prt-Registry gegen nichts | validate_profile.hpp:465-527 | med | ja |
| F23 | CE | stale-doc | 3 Kommentare behaupten VOR-M-CE-10-Semantik (St2⇒"hot"/1 Binary/14) — Test asserted Gegenteil | sota_catalog:355 + profile_run_entry:401 + tests-CMake:2564-2568 | med | ja |
| F24 | CE | wrong-assumption | Registry type= compiler-abhängig (MSVC "class "-Prefixe, kein strip) | axis_registry_gen/main.cpp:136 + type_name.hpp:36-40 | med | ja |
| F25 | CE | bug | derive_pruefling_type bekommt Reihen-Tag statt series-id — Fallback tot | sota_catalog.hpp:353 vs 286-297 | low | ja |
| F26 | CE | bug | xml_reader: Close-Tag ungeprüft, UTF-8-BOM→nullopt, Doppel first/last-wins | xml_reader.hpp:160/175-199 | low | ja |
| F27 | CE | stale-doc | 2 ungesyncte experiment_golden.xml-Kopien; ce-Kopie mit lokal danglender xsd-Ref | tests/unit/thesis_tiere:23 + Code/test_data_xml | low | **nein** |
| F28 | RW | bug | engine-Attribut nie gegen Referenz; Doppel-ce last-wins; unlesbare Registry nur WARNING | validate_profile.hpp:497 (+486-494) | med | ja |
| F29 | RW | untracked-promise | Kein Round-Trip-Test beider Registry-XMLs (Generatoren EXCLUDE_FROM_ALL, 0 CI) | tools/axis_registry_gen/CMake + prt registry_gen/CMake:12 | med | ja |
| F30 | RW | design-conflict | type-Spelling (mit/ohne `::`), slot-Vokabular (T03 vs axis_02), genus-Literal divergieren; page_type fehlt ce | beide Registry-XMLs + beide Generator-main.cpp | low | ja |
| F31 | RW | wrong-assumption | Audit-Prämisse falsch — 32/90 golden_wired KORREKT (17 variiert + 15 gepinnt); Code honest | Registry-XML + main.cpp:35-38 + source_catalog.hpp | low | ja (Text) |
| F32 | RW | stale-doc | Ledger V5.8 "permutation_axes evtl. = ce-Registry" widerlegt, nie nachgezogen | Ledger:102 + Design-Backup 20260713 | low | **nein** |
| F33 | RW | untracked-promise | prt-Registry-Fixture = Cross-Repo-Kopie ohne Sync-Guard (heute identisch) | tests/unit/thesis_tiere + CMake:2560-2561 | low | ja |
| F34 | RW | stale-doc | algorithm_profiles/README stale (11 Achsen, `_schema.xsd`); XSD existiert real im super | README.md:16-17 (XSD: Code/test_data_xml, INC-C) | low | ja |
| F35 | KW | bug | §15.5 "#36-Scheduling" + falsches Set (#38 fehlt) — durch Z.79/§15.8 entschärft | Ledger:1202 vs 385/79 | low | ja |
| F36 | KW | bug | G2-Eintrag ordnet q1-is-original #37 statt #38 zu | Ledger:368 vs 79/1221 | med | ja |
| F37 | KW | stale-doc | §15.6 wiederholt falsches offenes Set #35/#36/#37 | Ledger:1208 vs 385/79/1217/1223 | med | ja |
| F38 | KW | stale-doc | V5.8-Klammer "#36 vs #37 uneindeutig" trotz Z.79-Auflösung | Ledger:102 | low | ja |
| F39 | KW | untracked-promise | #34-honest-100%-Audit (PMC real verdrahtet) aus allen Boards verloren | Ledger:385 vs §15.5/15.6/15.8 | med | ja |
| F40 | KW | design-conflict | Nummernraum #33-#40 doppelt belegt (07-08-Infra vs 07-13-Kernfeatures), unmarkiert | Ledger:572 vs 385 | low | ja |
| F41 | KW | wrong-assumption | "#37-3-Achsen" — zwei Labels für #37, nur per User auflösbar | Ledger:385 | low | **nein** |
| F42 | KW | stale-doc | §14.1: alle 9 Gates 07-07 entschieden, 6 vollzogen/supersediert — 0 Vermerke | Ledger:1106-1118 vs 550/592/558/586/602/598/667 | med | ja |
| F43 | KW | untracked-promise | G-270a (P/E-Core CPUID 0x1A) echt offen, vom Board gefallen | Ledger:1115, letzte Spur 652; Code cpuid_platform_probe:38 | med | ja |
| F44 | KW | untracked-promise | G-AP15-Rest (Genus→Typ-ABI-GO, Option A/B, Set/Sequence) nur implizit getrackt | Ledger:1116/282/554 | med | ja |
| F45 | KW | stale-doc | §14.1-G-274 "KEIN Schritt ausgeführt" — real Schritte 0-7 vollzogen, Rest=V5-G5 | Ledger:1117 vs 550/554/566-584 | low | ja |
| F46 | KW | stale-doc | §11-B fast komplett überholt (AP-2/AP-6/Runway erledigt); Rest nur #162-HELD | Ledger:281 vs 536/420/426/650/969/667 | **high** | ja |
| F47 | KW | stale-doc | §11-A: 7 erledigte Punkte als offen; realer Rest #215 (+Deferrals) | Ledger:280 vs 650/1140/969/667/195/558/586/422 | med | ja |
| F48 | KW | stale-doc | §11-C statuslos: AP-8/9/10/11 DONE; echt offen AP-12/AP-14/AP-13-Rest/AP-15-Folge | Ledger:282 vs 424-427/538/602/611/911 | med | ja |
| F49 | KW | untracked-promise | AP-14/#248 im Ledger ohne Definition/Status (Gate #215/#156 nur im Handover-Board) | Ledger:282; HANDOVER-BOARD:42 | low | ja |
| F50 | KW | stale-doc | Z.30 FF3-Kette trägt W4-ersetzte AP-2-Alt-Definition; Z-Verweise verrottet | Ledger:30 (+172/185/209) vs 1032/1081/1095/536 | med | ja |
| F51 | KW | stale-doc | §11-I GO 2-5 ohne Vollzugsmarker (GO 1-5 komplett per Z.124/399); Memory-Index stale | Ledger:358-361 | low | ja |
| F52 | KW | stale-doc | §15.2/§15.3 führen gitlab-PAT-Blocker fort — beide Remotes seit 07-14/15 bedient | Ledger:1177/1183 vs 367/369/371 | low | ja |
| F53 | KW | stale-doc | §15.5.3 (F-H+M-CE-10+R-E) und §15.3 "GO nötig" ohne DONE trotz Vollzug | Ledger:1198/1186 vs 373/374/369 | med | ja |
| F54 | KW | stale-doc | V5.4(g)/V5.11 "Bit-Bank entfernen" — Tilgung #36 DONE (ce ebcc5498) | Ledger:94/118 vs 385/1179 | low | ja |
| F55 | KW | wrong-assumption | 07-10/11-Einträge re-gaten Entschiedenes (#266-Q2, 6-vs-48) | Ledger:652/673 vs 550/592/602/611 | low | ja |
| F56 | SB | untracked-promise | 07-11-REV-Handover teil-geminet: REV-DATA-01/04/05/06/07, CXX-02/05, TEX-01/02 code-verifiziert offen, ohne Disposition | Session-Doc 20260711:225-254 + Ledger:394 | **high** | ja |
| F57 | SB | untracked-promise | Muster B (noexcept-auf-Alloc, ~15 Bodies) G3-gemappt, nie umgesetzt — G3 trotzdem "erschöpft" | REVIEW-BERICHT.md:277 + Ledger:150/367; tree_node_pool_store:148 | med | ja |
| F58 | SB | untracked-promise | F-B-Wiedervorlage 2 (alloc_hw-Codegen-Bäckung) nach GO-2 entsperrt, untracked | NACHTRAG-F-B:71-74; Ledger nur Z.400 | low | ja |
| F59 | SB | untracked-promise | Diagnose-Branch ci-test-ce-bump (rot) weiter auf origin; Löschung=je-Repo-GO, untracked | Session-Doc 20260711:162; ls-remote verifiziert | low | **nein** |
| F60 | AR | design-conflict | Laufzeit-DLL-Anspruch (§15.1/W4/DoD-7) vs in-process-Ist; "W4-grün"-Overclaim, Brücken-Task unbenannt | v32_katalog_driver.hpp:119 + Ledger:1171/89/374/1229 | **high** | ja (Doku) |
| F61 | AR | bug | Aktivierungskette tot: COMDARE_RUN_V32_EXPERIMENT in jeder Build-Konfig präprozessor-entfernt | CMakeLists.txt:55 + main.cpp:302 | med | ja (Doku; sauber=F08) |
| F62 | AR | design-conflict | CI verifiziert Surrogat hart (5× V32_ENABLE=ON), W4-Treiber 0 CI-Abdeckung | .gitlab-ci.yml:120-519 + test_v32_orchestrator.cpp:44-71 | med | **nein** |
| F63 | AR | design-conflict | Kein [[deprecated]]-Guard am Surrogat; Exporter-Doku EMPFIEHLT Surrogat-Aufruf | v32_orchestrator.hpp:70 + exporter:13/36 | med | ja |
| F64 | AR | design-conflict | Baustein-Wahrheit 3-fach ohne Drift-Gate (Enabled* → Registry-XML ≠ permutation_axes) | Registry-XML:2-5 + Ledger V5.8:102 | med | ja |
| F65 | AR | untracked-promise | XML-Dimensionen (lebewesen/workloads/datasets/axes_default_lookup) geparst, nie getrieben; Registry-Checks offiziell degradiert | antrieb:100-117/264 + golden.xml:56-79 | med | **nein** (Task-Benennung ja) |
| F66 | AR | design-conflict | Fixture-Kopien (prt-Registry 2×, golden 2×) ohne Sync-Gate | ce tests/unit CMake:2540-2541 | low | ja |
| F67 | LK | stale-doc | Beide ce-Alt-Ledger "Single-Source" ohne SUPERSEDED-Banner; Y2/Y3/Y4/Z3-Banner routen aktiv dorthin | ce arch-ledger:1 + goal-v6:1 | **high** | ja |
| F68 | LK | stale-doc | GATE-MAXIMAL-ZIH (apptainer/sbatch) supersediert durch prod-Runner-Pivot, unmarkiert | goal-v6:116-151 vs Pivot-Dok 20260623 | med | ja |
| F69 | LK | stale-doc | F.6 Phase-C (23 Legacy-Header) vollzogen (6b3ed0d9) — Ledger führt termin-gated offen | arch-ledger:166 | med | ja |
| F70 | LK | stale-doc | #22/E4.1+E6 (6 Submodule befüllen) supersediert — Spiegel gelöscht/Tombstone | arch-ledger:190/40 vs modules/README + 53ff03a3 | med | ja |
| F71 | LK | design-conflict | E11-Facade-Impl: Gate #22 entfallen; Richtung jetzt #274/Fork-4 (User) | arch-ledger:165 | med | ja |
| F72 | LK | untracked-promise | A1/A2.1 (Vendor-Allokatoren) nur unverankertes "M4→#19"; K78-CE-D4 verloren; E2 mit-verwaist | super:286 + goal-v6:166-170 | med | ja |
| F73 | LK | stale-doc | V5-I0 "Mehr-Achsen treiben" supersediert durch L-74c (alle 4 OperativeCapable) + S7/#261 | arch-ledger:95 vs goal-v6:70 + super:452 | med | ja |
| F74 | LK | untracked-promise | C2 Grace Hopper ("kritisch") nirgends entschieden; ARM lebt nur als arm64-smoke | arch-ledger:163; super 0 Treffer; 276-Matrix:81 | med | **nein** |
| F75 | LK | stale-doc | ctest-gtest-Enumeration + MSB3073 root-cause-gelöst — beide ce-Ledger führen offen | goal-v6:108/150/176 + arch:117 vs gtest_setup.cmake:54-90 | low | ja |
| F76 | LK | stale-doc | Doku-11/14 "nicht im Repo" — existieren im super, bereits konsumiert | arch-ledger:167-168 | low | ja |
| F77 | LK | stale-doc | V5-I-Drive-Vollausbau: Map-Teil via #263 KOMPLETT; Set/Sequence-Rest user-gated | arch-ledger:115 vs super:933/458 | low | ja |
| F78 | LK | stale-doc | L-BACKLOG AVX-512-Sub-Flags OFFEN — implementiert (313d08d5, inkl. Schichten) | goal-v6:129 vs axis_09b_avx512.hpp:59-65 | low | ja |
| F79 | LK | untracked-promise | axis_05-IMC-Runtime-Heuristik nur Code-Kommentar/Doc 16 — fehlt im super §8 | axis_05_hm1_to_hm4.hpp:26-27 | low | ja |
| F80 | LK | stale-doc | E10.6/E10.7 ZIH-Verteil-Topologie gegenstandslos (Runner-/CEB-Modell) | arch-ledger:164 (+Doc 25:70) | low | ja |
| F81 | LK | untracked-promise | Naming-Refactor-Backlog + E9 raw-string verloren (Kern via #9 done; Rest User) | arch-ledger:187-188 | low | **nein** |
| F82 | LK | stale-doc | V5-I6-Rest: Kern via #44 + CoW-Memento (Doc 33 Rev.2); Symmetrie-Rest untracked | arch-ledger:102 vs :111 + abi_adapter:1765 | low | ja |
| F83 | LK | stale-doc | R5.D-Blocker-Begründung (Intel PCM/MSR) veraltet — prod1-perf/PAPI real, CI-Smokes | arch-ledger:161 (+:129) vs super:216 + ce-CI:95 | low | ja |

---

## (2) Autonome Fixes (golden-/ABI-neutral) in Fix-Reihenfolge

Ordnungsprinzip: erst Verifikationssignal, dann Mess-Integrität des offiziellen Pfads, dann Validator/Registry-Absicherung, dann Alt-Schulden, dann Doku-Sweep. Jedes WP endet mit vollem ctest + (bei ce) golden-Roundtrip==320 + Pipeline-GRÜN-Beleg nach Push (Direktive).

**WP-0 — CI-Verifikationssignal (F18, high, kleinster Eingriff zuerst)**
`contract:profile_coverage`: `test_experiment_parser` + `test_measurement_categories` in --target-Liste UND -R-Regex; `test_lazy_resume_binary` analog in `contract:harness`. Reine CI-YAML-Erweiterung; danach WÖRTLICHER Pipeline-GRÜN-Beleg. Zuerst, weil alle folgenden ce-Fixes sonst unverifiziert landen.

**WP-1 — super W4-Antrieb, Mess-Integrität (ein Increment, INERT-gegatet; Tests im Flag-ON-Target, TIMEOUT 300 beachten)**
1. **F01**: In execute_one_permutation_katalog/drive_phase bei `!ee_a/b_conformance_passed`: Outcome=InconclusiveData + stderr-Diagnose; execute_messreihe neuer Exit-Code **6** (Konformitäts-Fail); optional Konformitäts-Spalten additiv in CSV (Konsument test_v32_messreihe_antrieb synchron nachziehen). Stellt die bindende Gate-Doktrin (conformance_gate.hpp:8, Vorbild perm_runner.hpp:142-148) her.
2. **F02+F11** (gleiche Funktionszone): parse_enumeration_mode → `std::optional<EnumerationMode>`; leer ⇒ Default aus `profile->metadata.mode`; env nur expliziter Override mit Log-Zeile; unbekanntes Token ⇒ Abbruch mit Meldung + eigenem rc. Test mit `<mode>full</mode>`-Instanz ergänzen.
3. **F12**: validate_experiment_profile prüft op_types gegen kOpTypeTable (hart); Antrieb wertet Rückgabe von apply_op_type_token aus (fail-loud); OP-1-Erfindung bei leerem `<op_types>` ⇒ Validierungsfehler (XSD deklariert required).
4. **F03**: KatalogTierEngineCallable dispatcht ehrlich je WorkloadKind über IDriveableTier (YCSB_C: prefill+lookup-only; OP-2: insert-only; YCSB_A: 50/50; Scan/RangeDelete: fail-loud "nicht unterstützt" bis IScannableTier-Anbindung). Stellt die vom deprecateten Adapter regredierte Semantik wieder her.
5. **F04**: Engine-Labels aus `StufeOneC::name`/`StufeTwoC::name` (constexpr string_view, Lifetime für ExecutionResult::engine_name stabil).

**WP-2 — super Exporter + Härtung**
6. **F17**: MessreiheReport/PermutationOutcome in adapterfreies `messreihe_report.hpp` extrahieren; Exporter+Antrieb inkludieren nur diesen; v32_orchestrator.hpp re-includet (byte-konsumierend). Entkoppelt zugleich den ${COMDARE_PRT_ART_DIR}-CMake-Zwang.
7. **F06**: RFC-4180-Quoting im write_csv (Komma/Quote/Newline ⇒ "…" + Quote-Verdopplung).
8. **F05**: `_`→`\_`-Escape-Helper (Muster diagram_generator::escape_latex) auf axis_id; Legende aus realen Engine-Namen des Reports statt "PrtArt"-Hartkodierung.
9. **F63**: `[[deprecated]]` auf V32Orchestrator + beide Surrogat-Adapter-Aliase; Exporter-Doku-Beispiel auf antrieb::execute_messreihe umschreiben; im Ledger die INC-F-Klausel "byte-unberührt" explizit als supersediert vermerken. CI bleibt grün (kein -Werror in test:unit).
10. **F13**: Datum EINMAL je execute_messreihe (UTC, im Header dokumentiert), beiden substitute_date-Aufrufen injizieren.
11. **F15**: dispatch_phase-bool akkumulieren; bei false stderr + Fehler-Flag im Report.
12. **F07**: Gates wertbasiert vereinheitlichen (`#if COMDARE_V32_DRIVER_ENABLE && COMDARE_MEASUREMENT_ON`), `static_assert(COMDARE_MEASUREMENT_ON,…)` im Treiber, fail-loud Null-Check nach dem dynamic_cast.
13. **F16**: Kommentar präzisieren (static dispatch = Strategy-/Kompositions-Wahl; per-Op = std::function + Gattungs-vtable, differential-neutral, ABI-kanonisch).

**WP-3 — ce Validator-Härtung (additiv, Golden-XML bleibt grün — je _v verifiziert)**
14. **F19**: merge ∈ {Stufe1_CeOnly, Stufe2_PrueflingReplace, Stufe3_FullJoin} als HARTER Fehler (Single-Source merge_strategy_name); WARNUNG für deterministisch nicht baubare Paare (prt_art × St2/St3).
15. **F20**: mode∈{defined,full,full_sampled} hart; op_types∈{OP-1..OP-6} hart; version=="1" Warnung; ep.datasets mit denselben 5 ThesisProfile-Checks (Helfer extrahieren, Single-Source).
16. **F22+F28** (gleiche Funktion): phase.engine/engines gegen deklarierte engine-ids (XOR-Check mitnehmen, soweit ohne F21-Entscheid); pruefling gegen lebewesen-ids; engine-id-Eindeutigkeit; engine-Attr-Abgleich ee_ce→cache_engine / ee_prt→prt_art (Mismatch=ERROR); Doppel-cache_engine=ERROR; unlesbare Registry=ERROR statt WARNING.
17. **F26**: Schritt 1 BOM-Skip (3 Bytes, gefahrlos — 0 BOMs im Bestand); Schritt 2 Close-Tag-Name==out.tag sonst false, davor Regressionslauf über alle ~280 committeten XMLs (Ergebnis byte-identisch); Doppel-Direktkind optional als Warnung. Tests je Fehlerfall.

**WP-4 — Registry-Wahrheit absichern**
18. **F29+F64(a)**: ctest je Repo: Generator bauen → nach ${CMAKE_BINARY_DIR} regenerieren → byte-diff gegen committete XML == 0 (Muster R-E/M-CE-27); Referenz-Konfiguration dokumentieren.
19. **F24**: strip_all_elaborated-Normalisierung im axis_registry_gen (Helfer mit adhoc_emitter teilen); type_name.hpp-Kommentar "einziger Konsument" nachziehen. GCC-Datei bleibt byte-identisch.
20. **F30**: ce-Generator emittiert `::`-präfixiertes cpp_type_name-Literal (Makro-Konvention organ_location.hpp:42); genus aus Slot reflektieren; slot-Mapping als additiver Kommentar/Attribut.
21. **F33+F66**: super-seitiger Byte-Vergleichs-ctest (layering-sauber, super konsumiert beide Submodule): ce-Fixture-Kopien == Master; SKIP ohne Nachbar-Checkout; Provenienz-Kommentar "KOPIE von comdare-prt-art@<commit>, Sync-Pflicht bei Regeneration" in die Fixtures.
22. **F34**: README additiv (alter Baum als Legacy markiert, Ist-Baum mit 19 Achsen/Registry-XML/thesis_profiles ergänzt); XSD NICHT nachliefern — existiert im super (Code/test_data_xml, INC-C).
23. **F23**: 3 Stale-Kommentare per Deprecation-Korrektur auf per-Host-Semantik + 19-Pässe (wörtlich aus test_sota_st2_dedup-Kopf). Byte-neutral.
24. **F25**: Aufruf auf `derive_pruefling_type(s.id, s.merge, s.pruefling_type)` — für alle erreichbaren Pfade byte-identisch.
25. **F31**: keine Code-Änderung; künftige Audit-/Ledger-Formulierung: golden_wired = "geht in golden-320-Katalog ein" (variiert ODER gepinnt).

**WP-5 — Alt-Schulden aus Sessions (eigene Increments)**
26. **F56**: Rest-Mining: alle 30 REV-IDs gegen Ist-Code dispositionieren (fixed/gated/reject, je Beleg) und in §12 verbuchen; code-bestätigte, golden-/ABI-neutrale Fixes: REV-DATA-01 Capability-Zell-Invalidierung host-seitig (scan-unfähiges Tier darf YCSB-E nicht gewinnen), DATA-04 strikter Zahl-Parser+isfinite, DATA-05 Stamm-Allowlist+Pfad-Containment, DATA-06 temp-dir+atomic-rename vor Manifest, DATA-07 Cell-Key statt binary_id-Aggregat, CXX-02 CAS-Schleife statt fetch_add, CXX-05 noexcept von allozierendem record() entfernen. REV-DATA-02 als fixed-by-gate (Oracle-Conformance) dispositionieren. REV-TEX-01/02 = Text-Agent-/Infra-Zone ⇒ Handover-Vermerk, kein Selbst-Fix.
27. **F57**: Muster-B-Increment: ~15 gelistete noexcept-Bodies (Pool-Stores, Queuing, Prefetch, value_handle, pmr_resource_adapter, path_read_counter) — noexcept entfernen oder Allokation herausheben; Gate = voller ctest + golden-Roundtrip==320 + cf22==0; §12-Eintrag korrigiert die G3-Erschöpfungs-Behauptung.
28. **F58**: G7-Ledger-Zeile: alloc_hw-Codegen-Bäckung als Vorlauf-Increment zum NUMA-Fenster (profil-aktiviert fb_numa_page_study, golden-320 trägt 0× alloc_hw ⇒ golden-neutral).

**WP-6 — Ledger-/Doku-Sweep** = Abschnitt (4); F67 (high, Banner + Y2-Z3-Routing) und F46 (high, §11-B) zuerst.

---

## (3) USER-vorzulegen (Design-Konflikte / ABI / je-GO)

**A. Design-Bündel "Offizieller XML-Weg messreif" (F08+F09+F10+F14+F65, plus sauberer Teil von F61)** — ein Design-Increment, Klartext-Vorlage:
1. Brücken-Task v32-Experiment-Pfad → BuildOrchestrator(make_gpp_compile_fn) + AnatomyModuleLoader (render_sota_module_source je Phase-Komposition → Laufzeit-DLL → IObservableTier). Erfüllt §15.1/W4-Laufzeit-Anspruch (Ledger:1171, V5.4(b)); Maschinerie existiert im m3v2/E4-Pfad (profile_run_facade.cpp:150).
2. `<lebewesen>`/phase.engine/pruefling wirksam: compile-time-Dispatch (mp_for_each) über die vorhandenen per-Host-Kompositionen (M-CE-10) — kein Runtime-Switch (Kanon).
3. Workloads/Datasets aus den referenzierten load_profiles statt 2000/2000/seed42 (Fassaden-Anbindung); registry_dir aus `<engine registry>`-Refs auflösen (Fehler statt Warnung).
4. Output-Verankerung relativer `<output>`-Pfade: XML-Verzeichnis vs. expliziter Output-Root (F14).
5. CMake-Pfad/Preset, das messung_driver mit MEASUREMENT_ON+Driver-Flag baut (F08); vorgelagert Infra-Handover: A07-snmalloc-**Laufzeit-Segfault** (V31AdapterAlloc.A07, bislang ohne §15-Eintrag).
6. DoD-7-Bestätigung (liegt per Z.79 explizit beim User).

**B. F62 — CI-Politik W4**: W4-Treiber-Tests (Label measured) in CI aufnehmen vs. Doktrin "CI-Grün=Messung AUS"; V32_ENABLE-Jobs als Legacy-/Surrogat-Gate kennzeichnen bzw. nach Subsumtions-Beweis zurückbauen. Bis Entscheid: Ledger-Einbuchung (autonom).

**C. F21 — Phasen-Kardinalität**: Validator auf ==3 härten (XSD-treu) ODER XSD auf 1..unbounded lockern; engine/engines-XOR zusätzlich. WAS-Entscheidung (super/Thesis-Definition).

**D. F27 — Golden-Fixture-Kanonizität**: ce-Kopie als Test-Wahrheit deklarieren oder super-Kopie kanonisch + Sync-Check. Cross-Repo-Schnitt.

**E. F32 — V5.8-Nachzieh (User-GO, Ledger=Steuerdokument)**: "(geklärt 20260713: Legacy-11-Achsen-Katalog, NICHT informations-redundant zur ce-Registry, bleibt TABU-read-only; Registries = neue Single-Source)".

**F. F41 — Klartext-Fork**: Was war "#37-3-Achsen" (eigenes Feature → neue Nummer, oder Tippfehler)?

**G. F59 — Branch-Hygiene (je-Repo-GO)**: ci-test-ce-bump löschen? Vorher prüfen: ci-fix-submodule-deploy-token ist NICHT gemergt (--no-merged verifiziert), feat-persist-measurements ist gemergt.

**H. F74 — C2/GH200-Fork**: (a) offiziell ersetzt durch eigene ARM-Strategie (#270b/#23/#189) oder (b) als messgebundenen §8-Punkt aufnehmen (POWER11-vs-AArch64-Frage aus 276-Matrix:81).

**I. F81 — Naming-Backlog/E9**: supersedieren (Kern via #9 done; raw-string im deprecateten Header) oder je 1 Zeile super §8.

**J. Restaurierte offene User-Gates** (Tracking autonom, Entscheid User): G-270a gemeinsame Sichtung verriegelte Plattform-Tests → dann eigener Increment (prod2-Intel verfügbar) [F43]; G-AP15: Genus→Typ-Umstrukturierung (ABI/golden-GO) + Option A/B Container-Typ [F44]; Kernfeature-Vorlagen #35/#37/#38 (per §15.8 korrekt getrackt).

---

## (4) Ledger-Nachzieh-Liste (alles ADDITIV, Doku nie löschen)

**super `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`:**

| Zeile | Additiver Vermerk | Befund |
|---|---|---|
| 30 (+172/185/209) | "(AP-2-Definition per W4 ersetzt → Katalog-Pfad-Gate; AP-2-neu DONE Z.536)"; Z-Verweise in Z.1081 als historisch markieren | F50 |
| 94 + 118 | "Tilgung DONE 07-13 (#36, ce ebcc5498); offen nur B+-Baum-Neuverortung (gated)" | F54 |
| 102 | "(→ aufgelöst, s. Präambel-(ii) Z.79: #37)"; permutation_axes-Klärstand nur mit User-GO (Punkt E) | F38/F32 |
| 280 (§11-A) | DONE-Marker #221/CMD-1/AP-1/AP-8/#224; CMD-2 + #234 als "DONE (Rest geparkt/gated)"; "Rest = #215 (HELD)" | F47 |
| 281 (§11-B) | AP-2-neu DONE (Z.536, W4); AP-6 DONE (Z.420/426); Runway-Satz OBSOLET (Bump→#37/V5.2); AP-7b = Verifikations-TODO; Rest #162-HELD/G6 | F46 |
| 282 (§11-C) | Status je AP (8/9/11 DONE; 10 DONE mit honest-0-Residuen xml/sosd; 13 teil, Rest infra-gated; 15 map+container DONE, Sequence=Planung); AP-12 gegen AP-2-neu-Gate verifizieren; AP-14 mit Gate-Annotation "NACH #215/#156" (Def. Handover-Board:42) | F48/F49 |
| 358-361 (§11-I) | Vollzugsmarker GO 2-5 (Beleg Z.124/399); Memory project_diplomarbeit_stand_20260712: Index-Zeile/Description nachziehen | F51 |
| 368 (G2) | "#37"→"#38 (is_original-Konsolidierung; #37=Scheduling)" | F36 |
| 385 | Nummernraum-Hinweis: #33-#40 in ZWEI Räumen (07-08-Infra Z.572 vs 07-13-Kernfeatures); Kernfeature-Raum gültig | F40 |
| 652 / 673 | Korrektur-Klammern: #266 aufgelöst (Z.550/592); 6-vs-48 geliefert (#25/#45, Z.602/611) | F55 |
| 1106-1118 (§14.1) | Je Gate: ENTSCHIEDEN Z.550 + DONE/SUPERSEDED-Beleg (G-Q2→592, G-234V-a→558, -b→586, G-6v48→602/613, G-7b3→590/598, G-268→667/385); Rest-Residuen G-270a + G-AP15 explizit OFFEN; G-274: GO Z.550/554, Schritte 0-7 vollzogen, Rest=V5-G5 | F42/F45 |
| 1177 + 1183 (§15.2/15.3) | "G-a1 gelöst (Z.367/369/371, beide Remotes); offen nur CI-Teil (baremetal P1)"; auch Z.1202-G1-Punkt | F52 |
| 1186 + 1198 (§15.3/15.5.3) | F-H+M-CE-10+R-E DONE (Belege Z.373/374/369) | F53 |
| 1202 (§15.5) | Offene Kernfeatures = #35/#37/#38; "#36-Scheduling"→"#37-Scheduling"; #36=DONE (ce ebcc5498) | F35 |
| 1208 (§15.6) | Set = #35/#37/#38 (s. Z.79) | F37 |
| §15.8/Board (neu, additiv) | #34 mit Status-Split (code-done: linux_perf_pmc_source/pmc-Smokes vs run-gated: G6/prod1) · G-270a · G-AP15-Rest · #19/A1/A2.1-Zeile in §8 (Entsperr: Infra-K78-CE-D4; E2 als Sub-Punkt; Vorsicht: Nummer #19 doppelt beschattet) · IMC-Doc-16-Zeile §8 · G7-Zeile alloc_hw-Bäckung · G4-Notiz Branch-Hygiene · INC-F = typ-identische in-process-Vorstufe + benannter Brücken-Task + "W4-grün"-Präzisierung (§15.7-R8) · W4-CI-Coverage-Defizit · C2-Fork | F39/F43/F44/F72/F79/F58/F59/F60/F61/F62/F74 |

**ce `docs/ledger-sections/architektur-ziele-offene-punkte-ledger.md`:** Kopf-SUPERSEDED-Banner (→ super-Ledger autoritativ) [F67] · :95 V5-I0 → L-74c + S7/#261 [F73] · :102 V5-I6 → #44/CoW-Memento Doc 33 Rev.2, Symmetrie-Rest ggf. super §8 [F82] · :115 V5-I-Drive → Map via #263 (ce 4cc8c75e), Set/Sequence user-gated [F77] · :117 MSB3073 → gelöst (gtest_setup.cmake:54-90; 1 gtest_discover-Insel builder/commands bleibt, ctest grün) [F75] · :129 + :161 P4-PMC/R5.D → prod1-perf/PAPI-Stand, Blocker=#156-Fenster [F83] · :163 C2 → User-Fork vermerkt [F74] · :164 E10.6/7 → Mechanismus supersediert (#156/#189-Runner+CEB-Laufzeit), Ziel lebt in #189/#26; Doc 25:70 mit-markieren [F80] · :165 E11 → supersediert durch #274/Fork-4; get_cache_engine()=Pflicht-Feature-Frage im Design-Fork (Achtung: 414ed8c2 wurde revertiert) [F71] · :166 F.6 Phase-C → done-verified 6b3ed0d9 + Tag [F69] · :167-168 Doku-11/14 → done-verified mit super-Pfad, nach §(e) [F76] · :187-188 Naming/E9 → User-Punkt I [F81] · :190 #22 → SUPERSEDED (Löschung 07-04, Nachfolger #274) [F70].

**ce `docs/ledger-sections/goal-v6-luecken-ledger.md`:** Kopf-SUPERSEDED-Banner [F67] · :108/150/176 ctest-gtest → gelöst [F75] · :116-151 GATE-MAXIMAL-ZIH → supersediert durch #156-prod-Runner-Pivot (ZIH deprioritisiert per User 2026-06-23, nicht gestrichen); deploy/comdare-ce.def + build_sif.sh + slurm_launcher.hpp Deprecation-Banner (KEINE Löschung ohne je-GO) [F68] · :129 AVX-512-Sub-Flags → done 313d08d5 (inkl. Schichten; Doc-16-IMC/s4/PMC-Rest bleibt offen) [F78] · :166-170 K78-CE-D4 → in super §8 verankern [F72].

**Sonstige:** ce docs/uml_planning Y2/Y3/Y4/Z3:3 — Banner-Routing auf den stale Architektur-Ledger korrigieren [F67] · Code-Kommentare (F16/F23/F24-type_name.hpp) sind in WP-2/WP-4 enthalten.

---

## (5) Gesamt-Verdikt

**Die Schutzwälle halten.** Über alle 83 Befunde: kein TABU-Bruch (permutation_axes/golden-320/CatalogAxes/POD-1416/ABI-4 unberührt, mehrfach verifiziert), INERT-Doktrin real erfüllt (Default-Build byte-identisch, doppelt gegatet), W4-Anti-Surrogat-Kern im Mess-Pfad erfüllt (grep-belegt), und **kein einziger Befund verfälscht bereits produzierte Messdaten** — golden-320 (#9916) läuft über den intakten E4/m3v2-Pfad. Alles Gefundene ist latent, doc-seitig oder aktivierungs-gated.

**Neuer Code (INC-C..H-Welle, super+ce): Gerüst richtig, Pfad nicht messreif.** Parser/Validator/Treiber sind sauber typisiert und typ-identisch zum Katalog, aber der als "der EINE offizielle XML-Weg" deklarierte Pfad hat 3 high-Integritätslücken (Gate gated nicht F01, XML-mode ignoriert F02, OP-Typen Phantom-Etiketten F03), misst Miniatur-Workloads (F10), ist über eine tote Define-Kette gar nicht aktivierbar (F08/F61), fährt in-process statt Laufzeit-DLLs (F09/F60) und hat 0 CI-Abdeckung, während der deprecatete Surrogat-Pfad CI-hart grün-zementiert ist (F62). Hätte heute jemand einen echten Lauf gestartet, wäre er still falsch etikettiert gewesen — deshalb ist WP-1 die dringlichste Code-Arbeit, und Design-Bündel A die dringlichste User-Vorlage.

**Verifikationsnetz: zwei echte Löcher, sonst tragfähig.** Drei frische Tests laufen in keinem CI-Job (F18 — Phantom-Verifikationssignal für die neueste Welle, drittes Auftreten des Muster-F-Lochs), und beide Registry-XMLs sowie alle Fixture-Kopien haben kein Round-Trip-/Sync-Gate (F29/F33/F64/F66) — die Registry-Inhalte selbst sind nachweislich korrekt und honest (F31 entlastet sogar die Audit-Prämisse).

**Pläne/Ledger: Kern-Wahrheit konsistent, Peripherie stark verrottet.** Die autoritativen Anker (Z.79-Auflösung, Z.385, §15.8) sind in sich stimmig und entschärfen die meisten Nummern-/Statusfehler auf low. Aber die user-sichtbaren Steuerflächen §11-A/B/C/I und §14.1 sowie §15.2-15.6 tragen 14+ stale Einträge (F35-F55), zwei User-Gates (G-270a, G-AP15-Rest) und ein Task (#34) sind aus allen Boards gefallen, und der Nummernraum #33-#40 ist doppelt belegt — genau die Fehlerklasse, die bereits nachweislich Fehlentscheidungen verursacht hat (Ledger Z.665/667). §11-B (F46) ist zu Recht high: Wer der Zeile folgt, wartet auf einen entfallenen ABI-Bump.

**4-Repo-Kontinuität: ein aktiver Fehlleiter.** Die beiden ce-Alt-Ledger beanspruchen unmarkiert "Single-Source", werden von lebenden UML-Bannern aktiv angesteuert und enthalten eine Lösch-Anweisung gegen die je-GO-Doktrin (F67, high) plus 10 supersedierte/erledigte Punkte (F68-F83) — vollständig per Banner-Sweep heilbar.

**Sessions/Handover: gut gesichert, unvollständig geminet.** Das 07-11-REV-Handover ist die einzige offene Code-Schuld mit Messgültigkeits-Relevanz außerhalb des neuen Pfads (F56, high: Capability-/Ranking-Defekte VOR G6) plus das nie umgesetzte Muster B (F57) — beide fielen durch die G2/G3-Verify-Raster, deren "erschöpft"-Claims damit überclaimt sind.

**Fazit:** Substanz gesund, Selbstauskunft stellenweise stale bis überclaimt ("W4-grün", "G2/G3 erschöpft", "KEIN Schritt ausgeführt"). **70/83 Befunde (84%) sind autonom, golden-/ABI-neutral heilbar** in 6 Arbeitspaketen + 1 Ledger-Sweep; danach verbleiben 1 Design-Bündel (offizieller Mess-Weg → Laufzeit-DLLs/Workloads/Aktivierung), 4 kleinere User-Forks (CI-Politik, Kardinalität, Fixture-Kanonizität, GH200), 3 Klartext-/GO-Punkte (V5.8, #37-3-Achsen, Branches) und 2 Infra-Gates (snmalloc-Laufzeit-Segfault, baremetal-CI). Empfohlener Einstieg: WP-0 (F18) sofort, dann WP-1 (F01-F04) — beides vor jedem echten Messlauf über den v32-Weg zwingend.