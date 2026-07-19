# Konsolidierungs-Register offene/vergessene Arbeit (post-Crash, ultracode wf_932a5505)
> 2026-07-19, 7 Agenten (5 Leser + Synthese + adversariale Kritik), 94 Roh-Items → 61 Einträge. Grundlage für Ledger-Nachzug. Neueste-Fakten-gewinnen.

# Register offener/vergessener Arbeit — konsolidiert aus 94 Roh-Items

Stand 2026-07-19. Dedup: 94 Roh-Items → **61 konsolidierte Einträge** (neueste Fakten gewinnen; VOLLES GO Q1–Q5/#50/#51/#52, golden N=2^17, INC-2d=Variante A vollzogen, Q2=Option C, opt-Default O3 als entschieden vorausgesetzt).

Wesentliche Dedup-Merges: `9-Dim-G1 == Ketten-A1` (Organ-only binary_id-Guard), `P1 == V4/P1` (sizeof-static_assert), `IC-STALE == STALE-KLASSE` (stale-skip-Guard), `G8 == P2` (Slot-Zahlen-Sweep), `#45(ledger) == #45(drift) == E3 == E4` (A2-Neben gebaut), `#49 == GN-N == GN-XML` (golden-N), `G2 == SIMD` (extension_hardware), `G5(audit) == INC-29.2` (ToolchainFehlt), `INC-29.3 == G6 == #43` (SampleStatus), `P7 == P8 == PLANER-CODEGEN` (Planer-Ebene), `#54 == G3` (B+-Baum-Nachweis), `#50 + IC-* + SWEEP-50` (Caching), `#56 + ST-GAPS + IC-OUTDIR + Storage-Handout` (Infra-Storage), `aarch64 == INC2D-AARCH64`.

---

## (A) Executive Summary

| tag | Anzahl | davon kritisch/hoch |
|---|---|---|
| **LATENTER-BUILD-BRUCH** | 6 | L2 (stale-skip-Guard, hoch) |
| **VERGESSEN** | 8 | V1 (#44 Backlog nicht getrackt, mittel) |
| **ENTSCHIEDEN-NICHT-GEBAUT** | 10 | E-1/E-2/E-3 golden-N-Strang (hoch) |
| **GATED (warten)** | 15 | **G-1/#46 + G-2/#47** (kritisch, Deadline **28.07.**), **G-5/P5-PAT** (kritisch, Security), G-3/#56 + G-4/#51 (hoch, Engpass) |
| **OFFENE-ENTSCHEIDUNG (braucht GO)** | 14 | **O-1/E2** (rm CSVs — Konflikt „Messdaten nie löschen", kritisch), O-2/IC-MINOR (hoch) |
| **ERLEDIGT** | 8 | — (Board/Ledger-Fortschreibung teils offen) |

**Kritischer Pfad zur Deadline 28.07.:** G-5/G-3 (Infra: PAT-Rotation + prod-MinIO@V91/measure-drop) → G-4 (#51 Storage scharf) → G-1 (#46 FF0–FF4-Messlauf) → G-2 (#47 Thesis-PDF). **Einziger Engpass = Infra-Ausführung**, keine CE-seitige Blockade mehr.

**Sofort ohne GO ziehbar (golden-neutral Quick-Wins): 9** — siehe Abschnitt (C).

---

## (B) Gesamt-Tabelle

| Item | Quelle (datei:zeile / §) | tag | nächste Aktion | golden-neutral | severity |
|---|---|---|---|---|---|
| **L1** Organ-only binary_id-Guard | `builder/experiment_tree/profile_to_tree.hpp:82`, `validate_profile.hpp:141`, `experiment_tree.hpp:124` (9-Dim G1 = Ketten A1) | LATENTER-BUILD-BRUCH | `build_axis_levels`/`validate_profile` auf 17 `kCompositionAxisNames` restringieren; System-Achsen (isa/simd_extension/telemetry) über eigenen nicht-binary_id-Kanal. M-Aufwand, kein Micro-Win | ✓ | mittel |
| **L2** Stale-Skip systemischer Guard fehlt | `builder/experiment_tree/axis_variant_version_table.hpp:54` (IC-STALE = STALE-KLASSE); Ledger §25 Z.2073 | LATENTER-BUILD-BRUCH | `reflect_versions<alle 17>`-Instanziierungstest ins Default-ctest; geteilte Organ-Helfer eindeutig einer `version()` bucketen; CI-Tripwire-Scope exakt. Force-Recompile+CI-Grün als hartes „completed"-Kriterium | ✓ | hoch |
| **L3** `static_assert(sizeof(ComdareTierObserverSnapshot)==1272)` fehlt | `anatomy/observable_tier.hpp:146` (P1 = V4/P1) | LATENTER-BUILD-BRUCH | static_assert direkt am Struct (heute nur Laufzeit-EXPECT_EQ in `test_s7_10_swiss_pool_allocator_deg.cpp:139`) | ✓ | gering |
| **L4** Slot-Zahlen 19/18/15/11/7 stale + aktiver static_assert auf falschem Wert | `anatomy/set_composition.hpp:59`, `tests/unit/test_d9_set.cpp:38` (kSetCompositionSlotCount=15), `sequence_composition.hpp:65`, `view_composition.hpp:71` + P2-Loci | LATENTER-BUILD-BRUCH | Sweep → 17/13/9/5; `kSetCompositionSlotCount` 15→13 inkl. aktivem static_assert. `organ_count()` bleibt honest 13 | ✓ | gering |
| **L5** super-Sub-Build generated-Include-Root-Gap | §20.D-B2/B4 / §22 INC-2d-Verif-Note | LATENTER-BUILD-BRUCH | 3 Tests (smoke/measurement/wdk) stale-rot + `test_experiment_projection` falscher Include-Root im super-Tree korrigieren; INC-0/F12i im super-Sub-Build verifizieren | ✓ | mittel |
| **L6** `<metadata><mode>` env-Override + kein MEASUREMENT_ON-Preset | §20.D-B7 (F02/F08/F61) | LATENTER-BUILD-BRUCH | `<metadata><mode>` im offiziellen Pfad konsumieren (nicht still per env); Build-Preset mit MEASUREMENT_ON. Verletzt single-XML-Doktrin | ✓ | mittel |
| **V1** #44 Rest-Konformität-Backlog nicht getrackt | `docs/audits/…9dim-REPORT.md §5`; `…ketten-REPORT §6` | VERGESSEN | G1–G10/P1–P8 als getrackte offene Ledger-Punkte unter #44 aufnehmen | ✓ | mittel |
| **V2** cpuid_probe.hpp-Lücken H-1/H-7/H-9 | §20.D-B3 (`cpuid_probe.hpp`) | VERGESSEN | `physical_cores`/`logical_cores` via sysfs befüllen; Leafs 0x1A/0xB/0x1F + CPUID.07H:EDX[15] ergänzen. M-Aufwand | ✓ | gering |
| **V3** `copy_results_to_nas.sh` ohne DEPRECATED-Marker | `scripts/copy_results_to_nas.sh:1` (G4) | VERGESSEN | DEPRECATED-Marker + Verweis auf measure-drop HTTPS-PUT; NICHT löschen | ✓ | mittel |
| **V4** CMake-Kommentar suggeriert Python-Codegen | `CMakeLists.txt:550` (G9; vgl. `permutations.cmake:1`) | VERGESSEN | Kommentar auf NO-PYTHON C++23/cmake/sh/bat-Backend korrigieren | ✓ | gering |
| **V5** 4 Root-Python-Skripte unmarkiert + hardcoded Windows-Pfad | `_copy_ext_repos.py:8` +3 (G10) | VERGESSEN | DEPRECATED-markieren/relocaten; Personen-Windows-Pfad entfernen | ✓ | gering |
| **V6** Loader reimplementiert Major/Minor-Gate inline | `libs/…/anatomy_module_loader.cpp:138` (Vertrag `anatomy_module_abi_v1_decl.hpp:124-127`) (P3) | VERGESSEN | Auf benannte `host_compatible_with()` umstellen | ✓ | gering |
| **V7** `all_axes_binary_count()` Namens-Drift | `builder/experiment_tree/registry_to_axis_levels.hpp:147-161` (P4) | VERGESSEN | → `all_axes_matrix_count()` umbenennen; System-Achsen ≠ binary_id klarstellen | ✓ | gering |
| **V8** Backup-Bauplan Ofast→O3 nachziehen | `…BAUPLAN-INC2C-OPT-C-UEBERSETZER.md` (§21.D-3) | VERGESSEN | Additiv deprecaten/korrigieren; Code ist bereits O3 | ✓ | gering |
| **E-1** golden-N XML-Definition aller 17 Achsen + opt×simd-Wiring + Materialisierung | Ledger §22/§23.B; `20260718-new-golden-…ALL-AXES.md:92` (#49 = GN-N) | ENTSCHIEDEN-NICHT-GEBAUT | 3 Voraussetzungen CE-fertig (#50/#51/#52); XML bauen, opt-f/opt-g verdrahten, golden materialisieren. **Materialisierung gated auf Storage #56 (Bloat >6TB)**; golden-320 bleibt Alias | ✗ | hoch |
| **E-2** opt-f/opt-g (XML opt_level+simd + Planer-Permutation je Perm CompileFn+build_version-Sidecar) | Ledger §21.C (BAU freigegeben) / §20.A | ENTSCHIEDEN-NICHT-GEBAUT | GO liegt vor; triggert O3-golden-Rebuild + mehrtägigen Mess-Lauf → **Timing-Bestätigung des Rebuild-Fensters** vom User | ✗ | hoch |
| **E-3** golden-Referenz ↔ materialisierter Katalog entkoppeln | `20260718-new-golden-…ALL-AXES.md:94` (GN-DECOUPLE) | ENTSCHIEDEN-NICHT-GEBAUT | Zwingend durch 2^17-Wahl (`generated_source_catalog.hpp` bei 131k = GB-TU/ICE). Design-Bestätigung + Impl ausstehend → **latenter Build-Bruch wenn ignoriert** | ✓ | hoch |
| **E-4** extension_hardware CebSystemAxis + symmetrische typed SimdSubAxis (Q2=Option C) | `measurement/simd_sub_axis.hpp:37`, `extension_hardware_system_axis.hpp:4` (G2 = SIMD-Plan) | ENTSCHIEDEN-NICHT-GEBAUT | Aktiven `CebSystemAxis` `axis_label()=='extension_hardware'` bauen (analog Compiler, symm. Gcc/Clang), `SimdSubAxis.parent` verdrahten; DEPRECATED F-SIMD-Insel NICHT reaktivieren | ✗ | mittel |
| **E-5** `ToolchainFehlt` (D1) definiert, kein Emitter | `measurement/axis_error.hpp:41`, `build_orchestrator.hpp:380-381` (G5-audit = INC-29.2-Drift) | ENTSCHIEDEN-NICHT-GEBAUT | INC-29.2: Planer-Zeit-Toolchain-Vorprüfung emittiert D1 (heute fehlender Compiler → Exit 127 → ProzessStart). **Ledger Z.1939 präzisieren** (nicht pauschal „done") | ✗ | gering |
| **E-6** SampleStatus-Split + n/a-Renderer (INC-29.3) | `cache_engine_builder_iterator.hpp:382-388`, `axis_error.hpp:53-54` (INC-29.3 = G6 = #43) | ENTSCHIEDEN-NICHT-GEBAUT | `SampleStatus{Ok,NotApplicable,SourceUnavailable,Failed}`-Split durchziehen; n/a über Enum statt `unified_real`-Literalpfad (n/a-Renderer = Quick-Win, s. C) | ✓ | gering |
| **E-7** Bloat-Messung Binary-Größe je Tier-Binary | §23.D/§23.A (#52-Bloat) | ENTSCHIEDEN-NICHT-GEBAUT | Größe vor/nach messen (Ziel ≪ MB); speist 6-TB-Feasibility (131k×≤~5MB<6TB) | ✓ | mittel |
| **E-8** Multi-Gattungs-Dock-Dispatch nur SearchAlgorithm | `cache_engine_builder_iterator.hpp:811-812` (Registry `pruef_dock_registry.hpp:22-49`) (P5) | ENTSCHIEDEN-NICHT-GEBAUT | INC-2d/2e: über `PruefDockRegistry::select_for`/`IPruefDock::accepts` dispatchen statt hartkodiertem `acquire_search_algorithm_drive`. Roadmap | ✗ | gering |
| **E-9** System⊃Tier Stufen-Ort (System-Achsen flach konkateniert) | `registry_to_axis_levels.hpp:113-122`, `experiment_tree.hpp:271-286` (P6) | ENTSCHIEDEN-NICHT-GEBAUT | INC-1/INC-2: System-Achsen aus `is_static`-Organ-Zweig lösen + als umschließende Schicht verschachteln; Andockpunkt `build_system_axis_levels()`. Roadmap (groß) | ✗ | mittel |
| **E-10** Planer-Ebene: Codegen + ABI-Dock-Grenze + Executable | `builder/codegen/codegen.cpp:11`, `experiment_run_entry.hpp:138-144` (P7 = P8 = PLANER-CODEGEN) | ENTSCHIEDEN-NICHT-GEBAUT | `ExperimentPlanDirector`+`IPlanBuilder`+`CiYamlBuilder`/`CMakeGraphBuilder`, EIN Walk; Planer als root-Minimal-Binary + echte `.so`-ABI-Grenze Planer↔CEB. **User-Entscheid vor/nach Deadline**. Roadmap (groß) | ✓ | mittel |
| **G-1** #46 FF0–FF4 Voll-Messlauf (golden-N honest-100%) prod1+prod2 | Ledger §24.G/§23.B/§6 | GATED | Gated auf Storage (#56/#51) + mehrtägiges Cluster-Fenster (nie pollen); dann opt-in CI-Job `measure`. **Deadline 28.07.** | ✗ | kritisch |
| **G-2** #47 Thesis-PDF Messwerte in LaTeX + latexmk DE/EN grün | Ledger §24.G/§22 | GATED | Gated auf #46; Messwerte-Sektion generieren (Mess→PDF §11-G), DE+EN. Liegt im Autonomie-Scope. **Deadline 28.07.** | ✓ | kritisch |
| **G-3** #56 Infra-Handout-**Ausführung** (prod-MinIO→V91, #72-Fix, measure-drop, mc im Runner) | Ledger §24.F/§25 Z.2077; `docs/sessions/2026-07-18-INFRA-HANDOUT-…` (+ST-GAPS, IC-OUTDIR) | GATED | Infra-Agent P1–P6 abarbeiten + DoD (Bucket `cache-engine-tier-binaries` + CI-Vars + .1-SNI + persistentes Volume). **Dokument done, Ausführung offen** | ✓ | hoch |
| **G-4** #51 Storage-Aktivierung CE-Seite scharfstellen (INERT→aktiv) | ce `ea2c544c`/`93a21233`/`0b669e9` (§24.G-#51) | GATED | Nach Infra-DoD `COMDARE_STORAGE_CACHE=true`/`COMDARE_PERSIST_MEASUREMENTS`; Ebene B mc-cp + Ebene C measure-drop curl-PUT end-to-end verifizieren. Weg-A inert-by-default gelandet | ✓ | hoch |
| **G-5** Geleakter Vault-PAT rotieren + Transkript scrubben | Ledger §25 Z.2077 (P5); cluster-git `116a862` | GATED | **Sofort** durch Infra-Agent rotieren; `${PAT:-NEIN}`-Shell-Bug schrieb ins lokale Transkript. Blockt nichts am Build, Security-Sofortmaßnahme | ✓ | kritisch |
| **G-6** CI-Nachzug Dual-Verifikation gesamte Pipeline hart-grün | §24.A/§20.B (geparkt) | GATED | Nach Aufgaben-Abschluss: ce+super, prod1+prod2, alle Jobs. Diese Session: #50-CI-Bruch behoben (`5da2caf7`/`ebf3ac5`) + Weg-A (`0b669e9`) | ✓ | mittel |
| **G-7** #54/G3 ThesisProfile `<system_axes>`-XML statt COMDARE_PILOT_*-Env | `profile_facade/profile_run_facade.cpp:122/258` (#54 = G3) | GATED | Board #54 gegen gelieferten Nachweis aktualisieren (Verdikt TEILWEISE); Rest-Gap gated an Planer-Strang (P7/P8). Heute byte-neutral, aber Runtime-Umgehung | ✓ | mittel |
| **G-8** constexpr-Gate Organ-SIMD ≤ System-Zulassung (nur Kommentar) | `measurement/target_isa_system_axis.hpp:7`, `hardware_isa_system_axis.hpp:6` (G7) | GATED | Gated an PF2-Matrix/INC-1c `freigabe_contract`: constexpr-Gate durchsetzen. Additiv | ✗ | gering |
| **G-9** #27 H-10-Sidecar-telemetry-Verankerung | §20.B (2c-Auflage A) | GATED | Nach Messlauf Telemetrie-Organ als CEB-System-Achse per Sidecar planen+bauen | ✓ | gering |
| **G-10** #52-Insel: 3 REV7-Header deprecaten + `test_abi_interface` umstellen | §23.D/§24.G-#52 (`algorithm_baustein.hpp`/`baustein_variants.hpp`/`resolve_baustein.hpp`) | GATED | Unter GO (Code-Entfernung nur additiv-erst): deprecaten, nicht löschen. Kern-Guard `HotPathIsVariantFree` bereits gelandet (`9614ae0e`) | ✓ | gering |
| **G-11** Echter aarch64-Cross-Lauf über TargetIsaSystemAxis | §22 INC-2d (aarch64 = INC2D-AARCH64) | GATED | aarch64-linux-gnu-Toolchain-Handover (+sysroot prod1/prod2). Kanal `perm_target_isa_cflags` + Default native gebaut | ✓ | gering |
| **G-12** prod2 P/E-Core-Tests (#270a/#189/#63) | §20.D-B6/§8 | GATED | Gated auf `COMDARE_PROD2_AVAILABLE=true` | ✓ | gering |
| **G-13** GH200/Grace-Hopper ARM-Voll-Messkampagne | §8 (E15, Audit F74) | GATED | Entsperr = Miet-Zusage/Zugang | ✓ | gering |
| **G-14** S-7 Deep-Research (Locking/Concurrency) → INC-1 | §20.E/§18.5.2 | GATED | Tooling-/Fable-Safety-Block; nach Freigabe Opus-Session, dann S-7-INC-1 | ✓ | gering |
| **G-15** measurement-all-Migration (G5/#274) | §16.4-G5/§20.E | GATED | Bewusst ans Projektende terminiert; G5-Vorlage neu fahren (Fable-529 tötete `wf_800861e9`) | ✓ | gering |
| **O-1** rm-Umfang `tier150_measurements.csv` + `adapter_measurements.csv` | `20260718-optg-…neue-golden.md:68` (E2) | OFFENE-ENTSCHEIDUNG | **Explizites User-GO nötig — KONFLIKT mit „Messdaten nie löschen"** + getrackte Mess-CSV im build-Dir; git-Reversibilität reicht NICHT | ✗ | hoch |
| **O-2** codegen-Minor-Politik manuell vs CI-Tripwire | `…TIER-BINARY-CACHE.md:91` (IC-MINOR) | OFFENE-ENTSCHEIDUNG | Direkt gekoppelt an stale-skip-Risiko (L2); Plan lehnt zu Tripwire (rot bis gebumpt) + CEB-Header-Set-Umfang. User entscheiden | — | hoch |
| **O-3** welche opt-Stufen in die Mess-golden | `…neue-golden.md:67` (E1b) | OFFENE-ENTSCHEIDUNG | O2/O3 in golden, O0/O1/Ofast additiv (Ofast bricht 1-Thread-Determinismus). GO fixierte nur opt-Default=O3, nicht golden-Mitgliedschaft | — | mittel |
| **O-4** CI-Guard hart-rot + Lock-Datei-Ort | `…TIER-BINARY-CACHE.md:92` (IC-GUARD) | OFFENE-ENTSCHEIDUNG | Guard-Job hart-rot nur bei Version-Drift; Lock `tools/axis_version_lock/axis_version.lock` bestätigen | — | mittel |
| **O-5** neue XML additiv + Makro-Rename + 2 Grad-Hartkodierungen | `…ALL-AXES.md:95` (GN-XML) | OFFENE-ENTSCHEIDUNG | `COMDARE_GOLDEN_320_IDS`-Makro umbenennen? + 2 Grad-Hartkodierungen (`source_catalog` vs `axis_registry_gen`) synchron/entkoppelt (Drift-Risiko) | — | mittel |
| **O-6** 2. Variant-`name()` je Achse (Baustein golden-N) | `…ALL-AXES.md:96` (GN-VARNAME) | OFFENE-ENTSCHEIDUNG | Prerequisite: 2. `name()` mechanisch aus `EnabledStrategies name()` ableiten (Lookup) | — | mittel |
| **O-7** measure-drop curl-PUT ersetzt/parallel Git-Writeback | `…TWO-CACHE-STORAGE.md:73` (ST-SINK) | OFFENE-ENTSCHEIDUNG | Ersetzt curl-PUT-Drop den `persist:measurements`-Git-Writeback (Token id=54, Projekt 288) oder Doppel-Persistenz? | — | mittel |
| **O-8** minio-Retention alte ABI-Binaries (5→6) | `…TWO-CACHE-STORAGE.md:74` (ST-RETAIN) | OFFENE-ENTSCHEIDUNG | Behalten oder evicten? „Nie-löschen" gilt für Ergebnisse; Bau-Binaries explizit offen | — | mittel |
| **O-9** PULL im 1. Increment vs push-only zuerst | `…TWO-CACHE-STORAGE.md:75` (ST-PULL) | OFFENE-ENTSCHEIDUNG | PULL (größere ABI-Reuse-Fläche) schon im 1. Increment? Weg-A inert-by-default, Pull-Scope offen | — | mittel |
| **O-10** measure-drop-Granularität + Timestamp-Besitzer | `…TWO-CACHE-STORAGE.md:76` (ST-GRAN) | OFFENE-ENTSCHEIDUNG | per-Binary result.csv + whole-run vs nur whole-run; Timestamp Aufrufer vs Sink | — | gering |
| **O-11** Versions-Quelle zusätzlich Registry-XML-Spiegel? | `…TIER-BINARY-CACHE.md:90` (IC-VSRC) | OFFENE-ENTSCHEIDUNG | constexpr-am-Klassen entschieden; XML-Spiegel als OPTIONAL (#10) markiert | — | gering |
| **O-12** page_type-Achse (Nachschlagewerk-Widerspruch) | `docs/architektur/…ACHSEN-NACHSCHLAGEWERK.md` (page_type) | OFFENE-ENTSCHEIDUNG | Widerspruch klären, dann page_type entscheiden/verorten | ✓ | gering |
| **O-13** Nummern-Kollision Board #43–#50 (Epoch-2) vs Ledger §12 #43–#50 (Epoch-1) | Ledger §12 Z.645-694 vs Board (NUM-KOLLISION) | OFFENE-ENTSCHEIDUNG | Epoch-Mapping-Note (alt #43–#50 superseded) oder Board-IDs prefixen; verhindert Fehl-Referenz | ✓ | mittel |
| **O-14** INC-2d isa-Telemetrie-Erhalt vs entfernter Organ-Slot reconcilen | `20260718-inc-2d-…ISA-SYSTEM-ACHSE.md:125` (INC2D-RECON) | OFFENE-ENTSCHEIDUNG | VERIFY-Diskrepanz: GO „isa raus" vs Doc „isa-Organ-Typ bleibt telemetry-treu" gegen Ist-Code abgleichen | ✓ | mittel |
| **D-1** INC-2d Variante A VOLLZOGEN (ABI 5→6, 17 Slots, isa raus, sizeof 1344→1272) | ce `bc5ae9a3→eeb91f11`, super `65bf1bf` | ERLEDIGT | Keine — 275/275 + golden==320 Roundtrip + super-Sub clang-grün verifiziert | ✗ | — |
| **D-2** #50 Caching CE-seitig + CI-Bruch behoben + Sweep sauber | ce `d0313bf2`/`f1562636`/`5da2caf7`, super `ebf3ac5`; `axis_variant_version_table.hpp:54` (SWEEP-50) | ERLEDIGT | Bestätigen: Pipeline 11278 auf prod1 UND prod2 hart-grün (build:clang + analyse:thesis-data). 1. golden-N-Voraussetzung erfüllt | ✓ | — |
| **D-3** #45 A2-Neben Stufe 1 (pmc_source→measurement/) + Stufe 2 (perm_runner→harness/) gebaut | ce `ce0e252d`+`cb775ea3` | ERLEDIGT | **Ledger §24.G/§22/§21.C fortschreiben** (listen weiter als „NÄCHSTES" = Drift); Roadmap-Pointer auf #44/#43 | ✓ | — |
| **D-4** golden-N CRC64-Fixture gebaut | ce `aa25c9a4`; Ledger §22 (#49-drift) | ERLEDIGT | **Board #49 als done verbuchen + §12-Log-Eintrag** (Fixture 320→131072 bewusst nicht golden-neutral, alt-320 additiv) | ✗ | — |
| **D-5** Storage-Handout-Dokument P1–P6 + Weg-A inert-by-default | ce `0b669e9`; §24.B | ERLEDIGT | Keine seitens CE — Ball beim Infra-Agenten (=G-3) | ✓ | — |
| **D-6** Ledger-Roadmap-Drift: §12-Log fehlen 07-18/19-SHAs | ce `aa25c9a4..5da2caf7` (ROADMAP-DRIFT) | ERLEDIGT/Bookkeeping | §12-Log nachziehen (aa25c9a4/d0313bf2/4334f1b8/ea2c544c/93a21233/0b669e9/9614ae0e/ce0e252d/cb775ea3/f1562636/5da2caf7); „NÄCHSTER STACK-SCHRITT" auf FF0–FF4/Thesis-PDF | ✓ | — |
| **D-7** #53/#55 Doppel-Tracking (1 Arbeitseinheit) | ce `4334f1b8`/`80cb1434`/`a91f3339` | ERLEDIGT | Board-Hygiene: als eine Einheit vermerken (kein Scheinfortschritt) | ✓ | — |
| **D-8** Fixierte Entscheidungen | E1/E5/INC2D-FORK/INC2D-GAPS/IC-MANIFEST/IC-CEB/IC-RESUME/ST-TRANS/ST-ENDPT | ERLEDIGT | golden-320=Alias/Snapshot; `_abi4.txt` behalten; Variante A; kein super-golden-Spiegel; perm.algos-Sidecar; ceb= in build_version; Resume bricht bei Algo-Version; mc-Shellout; Binaries→prod-MinIO V91 | ✓ | — |

---

## (C) SOFORT golden-neutral umsetzbar (OHNE GO) — Quick-Wins mit exaktem Andockpunkt

Alle golden-neutral, ABI-neutral, kein Verhaltens-/Golden-Effekt. Reihenfolge nach Aufwand.

1. **L3 — static_assert am Struct** (~10 min): `static_assert(sizeof(ComdareTierObserverSnapshot)==1272)` direkt an **`anatomy/observable_tier.hpp:146`** ergänzen (Compile-Time-ABI-Guard; heute nur Laufzeit-EXPECT_EQ in `test_s7_10_swiss_pool_allocator_deg.cpp:139`).
2. **V6/P3 — benannte Vertragsmethode** (~20 min): Loader **`libs/…/anatomy_module_loader.cpp:138`** auf `host_compatible_with()` umstellen (Vertrag `anatomy_module_abi_v1_decl.hpp:124-127`); Tests decken beide Pfade.
3. **V7/P4 — Rename** (~20 min): `all_axes_binary_count()` → `all_axes_matrix_count()` in **`builder/experiment_tree/registry_to_axis_levels.hpp:147-161`** (+ Doku `axis_03m_mapping_registry.hpp:21`, `source_catalog.hpp:137`); nur Kommentare, kein Provisioning-Konsument.
4. **V3/G4 — DEPRECATED-Marker** (S): **`scripts/copy_results_to_nas.sh:1`** Marker + Verweis auf measure-drop HTTPS-PUT; NICHT löschen (V20-NAS/`backup1.comdare.de` überholt).
5. **V4/G9 — Kommentar-Fix** (S): **`CMakeLists.txt:550`** von „Python-Codegen" auf NO-PYTHON C++23/cmake/sh/bat-Backend.
6. **V5/G10 — Skripte markieren** (S): **`_copy_ext_repos.py:8`** +3 Root-Python-Skripte DEPRECATED-markieren/relocaten; hardcoded Personen-Windows-Pfad entfernen.
7. **E-6-Teil/G6 — n/a-Renderer** (S): n/a-Zell-Renderer über `SampleStatus`-Enum ziehen statt `unified_real`-Literalpfad — **`cache_engine_builder_iterator.hpp:382-388`** (Enum `axis_error.hpp:53-54`); reine Utilization-Lücke, Verhalten heute nicht falsch.
8. **L4/G8+P2 — Slot-Zahlen-Sweep** (~30 min): 19/18/15/11/7 → 17/13/9/5 in Kommentaren + inerten Konstanten; **insb. `anatomy/set_composition.hpp:59` + aktiver static_assert `tests/unit/test_d9_set.cpp:38` (kSetCompositionSlotCount 15→13)**; weitere Loci `sequence_composition.hpp:65`, `view_composition.hpp:71`, `genus_organ_binding.hpp:10/27`, `anatomy_base.hpp:169/79`, `anatomy_module_abi_v1.hpp:74`, `axis.hpp:18`, `ceb_system_axis.hpp:7`, `axis_path_serialization.hpp:87`, `validate_profile.hpp:54`, `genus_binding_traits.hpp:12`. `organ_count()` bleibt honest 13.
9. **V8/§21.D-3 — Doku-Nachzug** (S): `…BAUPLAN-INC2C-OPT-C-UEBERSETZER.md` Ofast→O3 additiv deprecaten/korrigieren.

**Golden-neutral aber KEIN Micro-Win (M-Aufwand, ohne GO ziehbar, aber Planung nötig):** L1 Organ-only binary_id-Guard (`profile_to_tree.hpp:82`), L2 stale-skip-Guard (`axis_variant_version_table.hpp:54` + reflect_versions-Test ins ctest), V2 cpuid_probe-Lücken, E-3 golden-Referenz-Entkopplung.

---

## (D) BRAUCHT USER-GO / ENTSCHEIDUNG

**Kritisch / hoch — blockiert golden-N-Strang:**
- **O-1/E2 — rm der Mess-CSVs**: `tier150_measurements.csv` + `adapter_measurements.csv`. **Explizites GO zwingend — steht im Konflikt mit Direktive „Messdaten nie löschen" + getrackte CSV im build-Dir; git-Reversibilität reicht nicht.**
- **E-2/opt-f/opt-g Timing**: GO liegt vor, aber NICHT golden-neutral → triggert O3-golden-Rebuild + mehrtägigen Mess-Lauf. **Rebuild-Fenster-Timing bestätigen.**
- **O-2/IC-MINOR**: codegen-Minor-Bump manuell vs CI-Tripwire (rot bis gebumpt) + CEB-Header-Set-Umfang — direkt an stale-skip-Risiko (L2) gekoppelt.
- **E-10/Planer-Ebene**: vor oder nach FF0–FF4-Deadline bauen? (großer Neubau, golden-neutral).

**Mittel — golden-N-Bausteine & Storage-Policy:**
- **O-3/E1b** opt-Stufen-Set der Mess-golden · **O-4/IC-GUARD** Guard-Job hart-rot + Lock-Ort · **O-5/GN-XML** Makro-Rename + 2 Grad-Hartkodierungen · **O-6/GN-VARNAME** 2. `name()` je Achse.
- **O-7/ST-SINK** curl-PUT ersetzt/parallel Git-Writeback · **O-8/ST-RETAIN** alte ABI-Binaries retain/evict · **O-9/ST-PULL** PULL im 1. Increment · **O-10/ST-GRAN** Granularität/Timestamp-Besitzer · **O-11/IC-VSRC** Registry-XML-Spiegel optional.

**Bookkeeping-Entscheide (Board/Ledger-Hygiene):**
- **O-13/NUM-KOLLISION** Epoch-Mapping-Note (alt #43–#50 superseded) · **O-14/INC2D-RECON** isa-Telemetrie vs Slot reconcilen · **O-12/page_type** Nachschlagewerk-Widerspruch.
- Nachziehen ohne Entscheid, nur Fortschreibung: **D-3** (#45 A2-Neben DONE in §24.G/§22/§21.C), **D-4** (#49 golden-N-Fixture done + §12-SHA), **D-6** (§12-Log 07-18/19-SHAs), **D-7** (#53/#55 eine Einheit).

**Code-Entfernung nur mit GO (additiv-erst):** **G-10/#52-Insel** 3 REV7-Header deprecaten (nicht löschen).

---

## (E) GATED — warten (Entsperr-Bedingung notiert)

**Infra-Ausführung = Engpass des kritischen Pfades zur Deadline 28.07.:**
- **G-5/P5-PAT** — Vault-PAT-Rotation durch Infra-Agent (**Security, sofort**; blockt keinen Build).
- **G-3/#56** — Infra-Agent P1–P6: prod-MinIO→V91 + #72-Fix (vhid-91-Split-Brain) + Bucket `cache-engine-tier-binaries` + measure-drop-Endpoint + mc im Runner-Image + persistentes Volume (ST-GAPS/IC-OUTDIR). **Dokument done, Ausführung offen.**
- **G-4/#51** — nach Infra-DoD `COMDARE_STORAGE_CACHE`/`COMDARE_PERSIST_MEASUREMENTS` scharf, Ebene B/C end-to-end.
- **G-1/#46** → gated auf G-3/G-4 + mehrtägiges Cluster-Fenster (**nie pollen**).
- **G-2/#47** → gated auf G-1.

**Aufgaben-Abschluss-gated:** G-6/CI-Nachzug (Dual-Verifikation hart-grün) · G-9/#27 H-10-Sidecar (nach Messlauf).

**Architektur-Strang-gated:** G-7/G7 constexpr-Freigabe-Gate (an PF2/INC-1c) · G-8/#54-G3 ThesisProfile `<system_axes>` (an Planer-Strang E-10).

**Hardware/Toolchain-gated:** G-11/aarch64 (Toolchain-Handover) · G-12/prod2-PE (`COMDARE_PROD2_AVAILABLE`) · G-13/GH200 (Miet-Zusage).

**Terminlich verschoben:** G-14/S-7 (Tooling-Freigabe) · G-15/measurement-all-Migration (Projektende).

---

# (F) VOLLSTÄNDIGKEITS-KRITIK (adversarial)

Verified against ledger §12/§20–§25, both 07-18 audits (all G1–G10/P1–P8 present in register), the six 07-18 plan docs, and live ce-code greps. The register is substantially complete — every audit finding and quick-win maps through. Residual gaps below, ranked, each verified.

---

**VERDIKT: Register ~90% vollständig. 9 konkrete Lücken — überwiegend Widersprüche/Falsch-Abschlüsse rund um den golden-N-Strang + eine ungelesene Quelle. Kein neuer harter Build-Bruch-Typ; die geprüften Verdächtigen (binary_blob_writer-CRC, D2-Nullzeilen, REV-DATA-01) sind bereits behoben.**

**1. (d, KRITISCH) Exec-Summary „keine CE-seitige Blockade mehr / Einziger Engpass = Infra" ist FALSCH.** G-1/#46 ist definiert als „golden-N honest-100%", aber der golden-N-Bau (E-1 XML aller 17 Achsen + E-2 opt×simd-Materialisierung + E-3 Referenz-Entkopplung) ist CE-seitig, NICHT gebaut und NICHT Infra-gated. Zusätzlich: Ledger §24.G/§22 „NÄCHSTES"-Kette (`LEDGER:2013/2067`) springt #45→#44/#43→**#46** und lässt **#49 (golden-N) als Vorstufe ganz aus** → unspezifiziert, ob #46 gegen golden-320 (materialisiert) oder golden-N (ungebaut) misst. → Aktion: golden-N-Bau als expliziten CE-Kritischer-Pfad-Knoten VOR G-1 einziehen; #46-Baseline (320 vs N) klären; Exec-Summary korrigieren.

**2. (d/e) #49 doppelter Status — D-4 sagt „Board #49 als done verbuchen", E-1 sagt #49-Kern nicht gebaut.** #49 ist Dach: nur die CRC64/Count-Fixture-Teilleistung landete (ce `aa25c9a4`); die All-Achsen-XML + opt×simd-Verdrahtung + Materialisierung (plan `…NEW-GOLDEN-ALL-AXES.md:66/77`) fehlt. #49 per D-4 zu schließen wäre exakt der Stale-Green-Falschabschluss. → Aktion: #49 OFFEN halten; nur Fixture-Teil verbuchen.

**3. (d/e) Ledger §22 „F-SIMD symmetrisch KOMPLETT" widerspricht Code + Audit G2 — Register reconcilet das nicht.** Live verifiziert: die EINZIGE Klasse mit `do_axis_label()=="extension_hardware"` ist **DEPRECATED** (`extension_hardware_system_axis.hpp:4`); `SimdSubAxis::parent_axis_label()=="extension_hardware"` (`simd_sub_axis.hpp:37`) zeigt auf diesen verwaisten Knoten — **kein aktiver `CebSystemAxis` trägt das Label**. Register führt die Lücke als E-4, flaggt aber nicht, dass §22 sie schon „KOMPLETT" nannte (Doppelzähl-/Falschabschluss-Risiko). → Aktion: §22-„KOMPLETT" gegen G2/E-4 abgleichen; aktiven `extension_hardware`-Knoten bauen, damit `SimdSubAxis.parent` auflöst.

**4. (b) Fehlender Konformitäts-Punkt: „CEB schreibt selbst ans XML-Ziel" nicht erfüllt.** Ketten-Audit §2.1-gering (`experiment_run_entry.hpp:169-173/:374-376`): XML-`<output>` wird nur als Provenienz geloggt, Rückschrieb über `measurement_sink` = No-Op, autoritatives Ziel ist host-gereichte `out_csv` (E8) statt XML-Ziel. Nicht in Register enumeriert (nur lose unter E-10/G-4). → Aktion: als eigenen Konformitäts-Punkt unter #44 tracken (Rückschrieb-Ziel vs Storage-#51 measure-drop vs E8 out_csv reconcilen).

**5. (a) Ungelesene Quelle: 07-16 VOLL-AUDIT (83 Befunde, `wf_0de715c9`, backup `befunde-83.json`, Ledger:435).** Teils disponiert (REV-DATA-01 belegt behoben, `perm_runner.hpp:154`), aber **F57 (Muster B: noexcept-auf-Alloc, ~15 Bodies, „G3-gemappt, nie umgesetzt")** und **DATA-07 (Cell-Key-Aggregat)** sind im Register unsichtbar, Disposition unbestätigt. → Aktion: befunde-83.json gegen Register abgleichen (v32-superseded vs noch-live) VOR #46.

**6. (e) D-1 „super-Sub clang-grün verifiziert" überstellt + kollidiert mit stehender Direktive.** §22 selbst (`LEDGER:2064`) fußnotet „3 build-i2-Tests smoke/measurement/wdk stale-**rot** (B2/B4-Include-Gap)". Register hat das als L5 (nur „latent/mittel") — aber gegen `feedback_gesamte_pipeline_immer_hart_gruen` sind 3 rote super-Sub-Tests ein **aktiver Direktiv-Bruch, nicht latent**. → Aktion: L5-Severity auf hoch heben, D-1-Wortlaut „super-Sub clang-grün" auf „nur ABI-kritisch frisch-grün" präzisieren.

**7. (e) D-2 (#50) als ERLEDIGT geführt, aber prod2-Grün nicht wörtlich belegt.** §25 (`LEDGER:2073`) belegt Pipeline 11278 grün, nennt aber prod2 nicht literal; D-2s eigene Aktion verlangt noch „prod1 UND prod2 hart-grün". Gegen `feedback_no_success_marks_without_literal_output` + die #50-Stale-Green-Lehre selbst ist ERLEDIGT verfrüht. → Aktion: literalen prod2-11278-Job-Status holen, erst dann verbuchen.

**8. (e/Bookkeeping) D-6 als „ERLEDIGT/Bookkeeping" getaggt, aber der §12-LOG-Nachzug ist NICHT erfolgt.** Verifiziert: §12-FORTSCHREIBUNGS-LOG (`LEDGER:413ff`) hat als neuesten Eintrag **2026-07-17** — kein 07-18/07-19-SHA-Eintrag. → Aktion: Tag auf „OFFEN-Bookkeeping"; SHAs (aa25c9a4…5da2caf7) tatsächlich nachziehen.

**9. (c) Neuer latenter Bruch-Typ ungeprüft: kein Compile-Guard gegen versehentliche 2^17-Voll-Materialisierung.** `…NEW-GOLDEN-ALL-AXES.md:100` warnt `generated_source_catalog.hpp` bei 131k = GB-TU/ICE; heute nur Design-Lazy (Ketten §2.4: `FullSourceCatalog::Engine` nie instanziiert), aber **kein `static_assert`** verhindert, dass ein künftiger Codegen-Change die Voll-Instanziierung auslöst — Analogon zu L3/L4 (fehlender CT-Guard). → Aktion: negativen Instanziierungs-Guard/`static_assert` an der Katalog-Naht (E-3-Entkopplung) ergänzen.

---

Belegte Nicht-Lücken (zur Abgrenzung): L2 literal bestätigt OFFEN — `grep reflect_versions libs/cache_engine/tests` = **leer**, `build_axis_variant_version_table` hat NULL Unit-Test-Instanziierung, einziger Exerciser = CEB-Runtime (= #50-Stale-Green-Wurzel); golden-N multipliziert das über alle Achsen-Varianten → L2-Severity zurecht hoch, Fix noch offen. D2-Nullzeilen (§20.B) sind durch INC-29.1 behoben (`perm_runner.hpp:161`, CSV rendert „failed"). `binary_blob_writer.hpp:52` ist bereits als reserviertes Nullfeld doku-korrigiert (kein Phantom-CRC mehr).
