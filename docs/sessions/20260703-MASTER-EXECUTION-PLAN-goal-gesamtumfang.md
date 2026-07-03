# MASTER-EXECUTION-PLAN — /goal Gesamtumfang (2026-07-03, für User-GO)

> Verabschiedete Reihenfolge (User 03.07.: „beste strategische Rekombination"). Grundlage: SE-22 §2-§5
> (Kartierungen), Masterplan `20260702-…-cmd-visitor.md`, Memory `feedback_command_pattern_achsen_mess_visitor_container_in_sa`.
> Prinzip: EINE serielle god-header-Kette (Spur S) + parallele disjunkte Worktree-Schwärme (Spur P), die
> GLEICHZEITIG laufen. Verify NUR Pipeline (cache-engine=286), je Increment ein Beleg. Worktrees an
> PERSISTENTEM Pfad `…/Diplomarbeit - Datenbanken/.wt/<task>` (NICHT Scratchpad — SE-22 §0-Lektion).

## SPUR S — serieller god-header-Strang (abi_adapter.hpp / observable_tier.hpp / measurement_snapshot.hpp)
Ein Increment offen, nie halb committen, je Pipeline-Beleg + super-Submodul-Bump.

| # | Aufgabe | Kern | Risiko |
|---|---------|------|--------|
| **S1** | #216-H2 | NEUE `tier_reset_statistics()` (daten-erhaltend) + Host-Aufruf nach Load (SE-22 §4-Dossier) | niedrig |
| **S2** | #217 | Array-Gattung-Achse als Container-Metaprog-Rekursion (registry `axis_03a`:104-130 + container_algorithm_t); KEIN uint16→uint64-Cast | mittel |
| **S3** | AP-7 | SwissTable EIGENER T0-Baustein S22 neben S14 (registry:83 → +S22; NEU axis_03a_search_algo_swisstable.hpp; Pool-Familie wie Hash) — nach/mit #217 | mittel |
| **S4** | #221 | RC Null-Object → DynamicVariableNode VOLLENDEN (XML-only-Steuerung; runtime_variable_loop:103 + experiment_tree + RC-apply abi_adapter:187-204) | mittel |
| **S5** | **CMD-1 (5 Teil-Increments, #188-4c-Muster)** | | HOCH |
| S5-0 | CMD-1-0 | Conformance-/Baseline-Gate: Ist-Mess-Verhalten festnageln VOR Umbau (Orakel-Test über die 11+320) | niedrig |
| S5-i | CMD-1-i | F1-Zwei-Wurzel: separate Mess-Basis von IExecutionEngine abspalten (execution_engine_base.hpp + anatomy_base.hpp) | HOCH |
| S5-ii | CMD-1-ii | EIN Basis-Interface (Antriebs-Op via IDriveableTier + Mess-Slot-Visitor MEASUREMENT_ON-gated via MeasurableComponent + Limitations via IResourceControllableTier/conformance_gate); Andock axis_base-CRTP | HOCH |
| S5-iii | CMD-1-iii | Command-Inseln subsumieren/stilllegen: i_command.hpp + anatomy_commands/ + strategy_command/ + algorithm_visitor/ (mit Tests) — WorkloadOp/MeasurableComponent BEHALTEN | mittel |
| S5-iv | CMD-1-iv | RuntimeMeasureVisitor→korrekter Name; anatomy_execution_context:116-Paar konsolidieren; **Text-Agent-Handoff** (fig:patterns + le_limitierung Z.15 + Anti-Etiketten-Kommentare) | niedrig |
| **S6** | **CMD-2 + AP-1 + AP-8-POD (EIN POD-Bruch)** | AP-1 branch_misses+throughput in Mess-POD; AP-8 p50/p95/p99 in T10; CMD-2 Container-Anteil-Sidecar + statischer Visitor-Pfad; ABI-Major-Bump; alle DLLs neu | HOCH |
| **S7** | #234 | per-Familie Node-Shape-Achse + nativer Pool-Store + observe-Hooks (schließt honest-0-DEG) | mittel |
| **S8** | #215 | CoW real für die 320 aktivieren (cowfix-v1 320-DLL-Neubau) — WIRKSAMKEITS-SCHLEUSE | mittel |
| **S9** | #224 | GoF-Etiketten-Hygiene (Achsen-/Pattern-Namen kanonisch) — ZULETZT, alle Namen final | niedrig |

## SPUR P — parallele disjunkte Worktree-Schwärme (kein abi_adapter/POD)
Je eigener Worktree/Branch von main; Codex editiert, Integrator committet+reviewt adversarisch; sequenziell
konfliktfrei nach main mergen. Bis 16 gleichzeitig; realistisch 4-6 pro Welle wegen Review-Bandbreite.

**Welle P-A (SOFORT, klar-spezifiziert, dateidisjunkt):**
- AP-2 (#236) PRT-ART-Echtpfad: DefaultMapBackend/Simulation-V32-Stub raus, echter prt_art_reference-Adapter (`include/cache_engine/abi/…engine_adapter.hpp` + `builder/commands/execute_engine_command.hpp`).
- AP-3 (#237) IPlatformProbe: cpuid_probe.hpp-Impl + HardwareFilter-Verdrahtung (`platform_probe/` + `builder/commands/auto_permutator.hpp`).
- AP-13 (#247) P/E-Core-Pinning (IPinningEngine-Impl `subsystems/c02_pinning_engine/`) + 3-ISA-Build-Matrix (CMake/CI).
- AP-8-Vendoring (#242-Teil) HDR-Histogramm vendoren (`ext/` + `libs/common/measurement/hdr_histogram_wrapper/`) + LatencyHistogram-Impl (axis_11). ⚠️ P50/95/99-POD-Surface = S6.

**Welle P-B (nach fachlicher Thesis-Grundlage — Text-Agent-Vorlauf oder Thesis-Read):**
- AP-6 (#240) Profil-XML sota 30→33 + allocators 10→23 (`libs/cache_engine/algorithm_profiles/sota+allocators`; Zuordnung P01-P33/A01-A23 aus Thesis, #170 done).
- AP-11 (#245) Lastprofil lp_*.xml 8→14 + LP-ID (`…/load_profiles`; LP01-14-Semantik Doc 32).
- AP-10 (#244) Datensatz-Akten 8/8 + Schema checksum/line_count + echte String-Loader (`dataset_loader/`).

**Welle P-C (Mess-Gate-Rest, teils abhängig):**
- AP-4 (#238) Stufe-3-Full-Join + Messreihe B echt (statt A_full-Kopie).
- AP-5 (#239) Full-Sampled-Modus (deterministisch 1:1000, seed-stabil).
- AP-9 (#243) Provenance-Logging (Compiler/Flags/ISA/Allokator/Commit-Hashes) — mit AP-1/S6.
- AP-12 (#246) Fairness-Harness (Common-Denominator vs Native) — setzt AP-2 voraus.
- AP-15 (#249) std::map-Vertrags-Vollausbau (17-Dagger-Ops + get_allocator).
- AP-14 (#248) Achsen-Sensitivität/Varianz-Dekomposition — NACH #215/#156.

## AUSSERHALB dieses GO (gated/extern/User)
- #156 M3-Gesamtmessung (HELD bis Linux+PMC-Fenster, User-Go) · #152 Cache-Misses (PMC) · #163 SIMD/ISA-2-Plattformen (Mess-gebunden) · #162 PRT-ART-SOTA-Messreihen (nach AP-2).
- #189 / #199-#210 / #231 Infra-Handoffs (Rollen-Direktive: read-only-verify) · #209 MinIO-Key-Rotation.
- #225 Second-Execution-Grundsatz (NUR Diskussion, USER) · #226 Appendix-Limitierungen (M3-gated).
- #25 Diplomarbeit-Text (User schreibt) · #184/#185 Text-Agent (Dataset-Doc/TPIE).

## VERIFIKATIONS- & MERGE-PROTOKOLL (je Aufgabe)
1. Worktree `.wt/<task>` von main. 2. Dossier (Kartierungs-Fundstellen + Ziel + Constraints). 3. Codex
`--sandbox workspace-write -c model_reasoning_effort=xhigh -c plugins.\"workflow-orchestrator@barkain-plugins\".enabled=false`.
4. Diff-Verify + adversarischer Review-Codex (read-only) → False-Positives mit Beleg ablehnen. 5. Integrator
committet (Co-Authored-By Opus 4.8) im Worktree. 6. Merge nach main (sequenziell, dateidisjunkt). 7. Push
origin+gitlab. 8. Eine Sammel-Pipeline pro Merge-Runde → Literal-Beleg. 9. super-Submodul-Bump + Task completed.
Spur S: strikt seriell (nächstes Increment erst nach grünem Vorgänger). Spur P: parallel, aber Merges serialisiert.
