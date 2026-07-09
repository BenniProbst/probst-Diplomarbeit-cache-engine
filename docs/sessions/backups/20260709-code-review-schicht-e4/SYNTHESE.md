# SYNTHESE — Schicht-E4-Review (adversarial, max-Effort), 2026-07-09 abends

> Workflow `wf_ca5b3523-7fb` (29 Agenten: 5 Dimensions-Finder + 24 Verifier à 2 Lenses, 1,68M Tokens). Scope = der UNCOMMITTED Schicht-E4-Diff (Codex-Erstimpl. beider Pakete A+B, nach meinem Zeile-für-Zeile-Voll-Review): ce profile_facade/** + build_orchestrator (make_gpp_compile_fn) + Parser/Baum-RC-XML-Eingang + Contract-Test + super E4-Dock. Rohdaten: `rohdaten/ERGEBNIS-wf_ca5b3523.txt` (Status-Dump inkl. aller Verifier-Begründungen) + `rohdaten/journal.jsonl` (29 Agent-Returns) + `rohdaten/review-schicht-e4-wf_ca5b3523-7fb.js` (Skript). 12 Kandidaten → 6 CONFIRMED (2:0-Votes) / 4 PLAUSIBLE (1:1) / 1 REFUTED / 1 Dedup. **Alle CONFIRMED + 3 PLAUSIBLE wurden noch VOR dem Commit manuell gefixt (User-Direktive: Korrekturen ohne Codex).**

## Prozess-Notiz (Scope-Verstoß des Erstimplementierers)
Der Paket-A-Codex-Lauf implementierte entgegen seinem Datei-Scope AUCH Paket B vollständig mit (Parser/Baum/Fixture/Test), ohne es im Abschluss-Manifest auszuweisen — inhaltlich Dossier-konform und im Voll-Review mitgeprüft, aber als Manifest-Untertreibung festzuhalten (Lehre: Codex-Manifeste nie als vollständig annehmen; git status ist die Wahrheit).

## CONFIRMED (gefixt vor Commit)
| # | Fund (Datei:Zeile) | Schwere | Fix |
|---|---|---|---|
| C1 | super `main.cpp:~561` — **B1 nur halb geheilt:** `COMDARE_RUN_E4_XML=1` OHNE `COMDARE_LOAD_PROFILE_DIR` → Fassaden-exit-4-Guard feuert nicht (nur „gesetzt-aber-leer"), run_profile fällt still auf fixed-workload zurück → **mehrtägiger Lauf, JEDE Zeile two_phase_valid=0, exit 0** | **critical** | **FIX-1:** Dock erzwingt `COMDARE_LOAD_PROFILE_DIR` bei aktivem Opt-in (leer → throw → try/catch → E4-Abbruch, klassischer Pfad läuft weiter) |
| C2 | ce `tests/unit/CMakeLists.txt:2442` — Contract-Test mit Label `contract` ist **CI-tot** (test:unit läuft `-LE contract\|pmc`; kein dediziertes Gate matcht ihn) | major | **FIX-2:** Label → `profiles;e4` (ohne `contract`) → läuft in test:unit; Kommentar dokumentiert die Konvention |
| C3 | ce `xml_config_parser.cpp:237-240` + `SCHEMA.md:21` — 4 neue uint64-Felder werden **unvalidiert** durchgereicht; `parse_u64` mappt nicht-numerisch später still auf 0 = falsch etikettierte Mess-Zeilen (SCHEMA verspricht uint64) | major (2 Funde, dedupliziert) | **FIX-3:** `parse_u64_list_strict` im Parser — ungültiges Token ⇒ Profil unlesbar (`nullopt`, Bestands-Konvention); Contract-Test um Invalid-Fall erweitert |
| C4 | super `CMakeLists.txt:30` — Fassaden-Target fehlt ⇒ nur Configure-WARNING, `COMDARE_RUN_E4_XML=1` zur Laufzeit **kommentarlos ignoriert** (silent feature loss; einziger Lese-Zugriff sitzt im #ifdef) | minor | **FIX-4:** WARNING → **FATAL_ERROR** (ce+super sind atomar submodul-gebumpt; Fehlen = de-synchroner Klon) |
| C5 | ce `profile_facade/CMakeLists.txt:81` — EXCLUDE_FROM_ALL-Fassade hat **ce-seitig 0 Compile-Coverage** (kein ce-Konsument/CI-Job baut sie); Naht-Refactor bräche erst im super beim Bump (#230-Klasse, cross-repo verzögert) | minor | **FIX-8 = dokumentierte Debt** (kein CI-Umbau in dieser Schicht): super-CI baut die Fassade in JEDER Pipeline (Kadenz erzwingt super-Sub-Build je Increment) + FIX-4 macht Fehlen fail-loud. Echte ce-Gate-Aufnahme = Folge-Increment (Ledger-Vermerk) |
| C6 | (Dimension dock-integrity, Duplikat von C1 aus zweiter Dimension) | major | in FIX-1 enthalten |

## PLAUSIBLE (1:1-Votes; 3 von 4 trotzdem gefixt)
- super `main.cpp:253` — malformed `COMDARE_MIN_FREE_GB` („4,5"/„4gb") fiel per Dossier-Spec still auf 0.0 = RAM-Admission aus (B3-Klasse). **FIX-6:** fail-loud (throw statt 0.0; strenger als die Spec, konsistent mit B4-cap).
- super `main.cpp:249` — `compile_time_platform_tag` ohne RISC-V-Zweig → `unknown-platform` auf der erklärten Plattform-Matrix. **FIX-5:** `__riscv/__riscv_xlen==64`-Zweig ergänzt.
- ce `build_orchestrator.hpp:374/378` — Windows-Fallback-Whitelist lehnte `g++-16` am `+` ab (de-facto toter Zweig). **FIX-7:** `+` in die Whitelist; `:`/`\\` bleiben bewusst draußen (Injection-Schutz), Kommentar verweist Windows auf den MSVC-Pfad `make_system_compile_fn`.
- REFUTED (nicht gefixt): `COMDARE_MESSUNG_DEFAULT_THESIS_PROFILE` backt absoluten Source-Tree-Pfad ein — beide Verifier: kein unterstützter Deploy-Workflow verletzt; die gesamte E4-Mechanik ist build-tree-gebunden (auch `COMDARE_FACADE_PERM_INCLUDES`), messung_driver hat keine install()-Rule.

## Verifikations-Endstand nach den Fixes (eigene Läufe, literal in Session-Log)
clang-format-22 dry-run rc=0 · Mojibake 0 · ce build/ (g++-16-trunk 16.0.1): `test_e4_contract_xml_to_axislevels` PASSED (inkl. Invalid-Fall) + `test_v31_adapters` PASSED + 3 `test_striktheit_*` PASSED · super-Sub-Build `facade-verify`: `comdare-messung-driver` linkt · golden-Dateien unberührt; Negativ-Contract-Fall beweist Bestands-AxisLevels (7 Ebenen/3 dyn) byte-verhaltens-gleich.
