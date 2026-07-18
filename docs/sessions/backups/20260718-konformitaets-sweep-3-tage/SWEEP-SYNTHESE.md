# KONFORMITÄTS-SWEEP 8 Themen (Abarbeitungskette 16.–18.07.) — Synthese

> ultracode `wf_5b71c862` (17 Agenten, je Thema Plan-SOLL→Ist-Map→adversariales Diff + Quer-Synthese).
> Auftrag: User 2026-07-18 nach opt-g-Beinahe-Fehltritt. **Gesamt: ABWEICHUNG über alle 8 — 0/8 voll konform.**
> **POSITIV: KEIN golden-320-Regress** (alle betroffenen Achsen binary_id-neutral / ×1-gepinnt; kCompositionAxisNames durchgängig 18).

## A — KRITISCH (golden/ABI-neutral, KEIN GO nötig) — sofort fixen
1. **INC-29 Infra-Fehletikettierung** (DESIGN:61 / TABU:142): Infra-Codes (spawn/rsp/waitpid Exit 125/127/-2) werden im d1-Carrier als D1-Klassen (ToolchainFehlt/CompileKombination) verbucht statt als **separater InfraError**. Infra ≠ Compiler-Compiler-Fehler. → `build_orchestrator.hpp:107` Carrier heben (InfraError-Typ / variant), 125/127/-2 getrennte `[Infra-Fehler:…]`-Zeile.
2. **INC-29 `isa_features.cmake` FATAL_ERROR** (DESIGN:102 / TABU:138 / „Pipeline hart grün"): 7 Stellen (`:141/164/171/175/178/181/205`) reißen die Pipeline bei HW-/Flag-Fehlen. → `FATAL_ERROR` → `message(WARNING [Compiler-Compiler-Fehler: hardware_erweiterung_fehlt] …)` + Permutation überspringen.

## B — DOKTRIN / GO-gated (near-TABU Kern-Library) — brauchen deinen GO
3. **INC-1 Blut-Direktive**: Organ-Familie hängt NICHT unterm Dach — `axis_base.hpp:52 AxisBase` ist plain struct, erbt NICHT `topics::Axis<Derived>`; die 22 StrategyBase auch nicht. Dach real nur über 2 System-Familien. Aufschub-Gate (golden byte-identisch / ABI-4) ist bei INC-2c **erschöpft** (ABI schon 4→5). → Zwischenlösung `StrategyBase : AxisBase, topics::Axis<Derived>` ODER Voll-Dach `OrganAxis` + 22 Umhängungen. **Kern-Library → GO.**
4. **Namensfalle `OptO*SubAxis`→`OptO*Option`** (opt-arc + opt-g, EIN Fix): Optionen tragen irreführend „SubAxis". `optimization_level_sub_axis.hpp:76-127` + static_asserts + `experiment_run_entry.hpp:105-109`. **Kern-Library → GO** (bereits §21.D vertagt).

## C — ENTSCHEIDUNG (deine Wahl)
5. **F-SIMD RESURFACED**: Der Sweep-opt-g-Review liest die DESIGN-§5-Tabelle (die **symmetrisch** `<extension_hardware><simd><option>` + `SimdSubAxis` empfahl) als Ziel — **ich habe aber „direkte Optionen" implementiert** (F-SIMD-Auflösung, matcht den gebauten Code). Widerspruch Dossier-§5 ↔ Impl. **Deine Wahl:** (a) **symmetrisch** (`<simd>`-Container + neue `SimdSubAxis`, konsistentes Leveling, GPU-erweiterbar, Kern-Library-GO) ODER (b) **direkt behalten** (matcht Code, §5-Doku nachziehen).
6. **INC-2c `isa`**: `isa` ist ×1 auf `isa_amd64` gepinnt (golden==320 gewahrt), aber noch in `kCompositionAxisNames`. → analog telemetry herauslösen (INC-2d) ODER als getrackten offenen Punkt festhalten (nicht still „konform" führen).

## D — MESSLAUF-BLOCKER (vor variierendem Messlauf, kein Kern-GO)
7. **Provenienz-Sidecar-Lücke**: `system_axes_version_suffix()` (`profile_run_facade.cpp:218-224`) kodiert nur `+ext=/+cxx=/+opt=`; telemetry-Regime/page_type/general_hardware fehlen im Sidecar. → um `+tel=` (ggf. `+page=/+hw=`) erweitern ODER `build_system_axis_levels()` als echten H-10-.version-Writer.

## E — MITTEL (meist kein GO)
8. **INC-29 Organ-Ebene**: `SystemAxisSample` um `SampleStatus` (N/A vs Failed splitten, `invalidate()`→`mark_not_applicable()/mark_failed()`), `op_lat`-Serialisierung `iterator:351-362` volle SampleStatus; 2 von 4 benannten Patterns fehlen (Policy-Based-Design + CoR `error_domain()`).
9. **INC-0 Scope-Grenze** (User-Absprache): `COMDARE_FACADE_PERM_EXTRA_CFLAGS`/`-mcx16` (`CMakeLists.txt:159-176`, `profile_run_facade.cpp:98-104/:156`) ist im Plan als „Nicht Teil von INC-0" markiert, aber aktiv in jede Perm injiziert. → entfernen+vertagen ODER Plandoc §2.4/§7 nachziehen. Kein stiller Erhalt.
10. **opt-f single-source**: `validate_profile.hpp:556/568` dupliziert erlaubte Werte statt `opt_level_id()/simd_extension_id()`. Golden-neutral.

## F — GERING (never-delete-Nachzug, golden-neutral, Sammel-Sweep zuletzt)
11. Stale-Doku: INC-1 4× „19" (`axis.hpp:18`, `ceb_system_axis.hpp:7`, `axis_path_serialization.hpp:45 V18→V17`, `:95 19→18`); INC-2c Major-4→5 + Alt-T-Index (`observable_tier.hpp`, `abi_adapter.hpp`, `genus_binding_traits.hpp`); `axis_error.hpp:7`; Ofast-Default-Nachzug in 3 BAUPLAN-Docs.

## Empfohlene Reihenfolge
KRITISCH (1,2) sofort → Messlauf-Blocker (7) → [GO] INC-1 Blut (3) → Entscheidungen (5,6) → MITTEL (8,9,10) → A2-Neben-Bau → [GO] Namensfalle (4) → GERING-Sammel (11).
