# KOORDINIERTE BAU-REIHENFOLGE — 6 Konformitäts-Fixes (ultracode `wf_6c341b15`)

> Design-Planung je Aufgabe + Quer-Synthese. **Kern-Erkenntnis: EIN einziges ABI/golden-Regen-Fenster (nur INC-2d, Schritt 7); Schritte 1–6 sind ALLE golden==320 byte-identisch + ABI-neutral** (kAbiMajor=5, kCompositionAxisNames=18 bleiben bis Schritt 7).

## Reihenfolge (Kopplung Achsen-Library aufgelöst)
| # | Schritt | Golden/ABI | Warum hier |
|---|---|---|---|
| **1** | **INC-29** Infra-Fehler-Taxonomie (InfraErrorClass + ErrorDomain/CoR + HandlingPolicy + `hardware_erweiterung_fehlt`-Label) + isa_features FATAL→WARNING + SampleStatus | golden-neutral, additiv | unabhängigst; liefert die geteilte Fehler-Infra, die F-SIMD/INC-2d/isa_features brauchen |
| **2** | **Namensfalle** `OptO*SubAxis`→`OptO*Option` (+ Alias `DefaultOptLevelOption`) | golden-neutral, reiner Rename | MUSS vor F-SIMD/INC-0: etabliert die `*Option`-Konvention; ist zugleich F-SIMDs Guss-Quelle |
| **3** | **INC-1a** `OrganAxis<Derived>`-Dach (topics::Axis+AxisBase, EBO, `axis_kind()==organ` DRY) + 20 StrategyBase rehängen (isa T11 AUS = INC-2d, page_type zurückgestellt) | golden==320 byte-id (EBO) | Fundament |
| **4** | **INC-1b** `genus_organ_binding.hpp` `RequiredOrgans<G>` (5 Genera, static_assert gegen `axis_names()`) + **INC-1c** `freigabe_contract.hpp` (Stub+Doku) | golden-neutral | vor INC-2d (gleiche Datei `genus_binding_traits.hpp`) |
| **5** | **F-SIMD** `simd_sub_axis.hpp` (`SimdSubAxis`:CebSystemAxis, parent=extension_hardware) + `<extension_hardware><simd><option>` (XSD/golden/Parser/opt-g) + `SimdExtensionHardwareAxis`-Familien-Knoten | golden-neutral, system_config | nach Namensfalle (Guss-Quelle im Endzustand) |
| **6** | **INC-0** `compiler_isa_feature_sub_axis.hpp` (unter compiler) + `axis_06_allocator_build_contract.hpp` (unter OrganAxis) — malloc→Organ / Flags→Compiler-System | golden==320 (allocator ×1 std_malloc) | nach Namensfalle + INC-1 |
| **7** | **INC-2d** isa→hardware_isa-System-Achse: `kCompositionAxisNames` 18→17, `AdHocComposition`, 5 Genera-Kompositionen, Observer-POD (sizeof 1344→1272, **ABI 5→6**), golden-Regen `gen_golden_fullpilot` (count bleibt 320, binary_id verliert `/isa=`-Segment) | **EINZIGES golden-Regen + ABI-Fenster** | letzter; das koordinierte Fenster |
| — | **A2-Neben** (#45) | golden-neutral | nach den Achsen-Fixes (überlappende Files) |

## Aufgelöste offene Fragen (Empfehlungen adoptiert unter „Volles GO")
- INC-1 **Mixin** (nicht 22×-Zwischenlösung) — DRY. · Alias → **DefaultOptLevelOption**. · F-SIMD **SimdExtensionHardwareAxis**-Familien-Knoten JA (symmetrisch Gcc/Clang) · `.options`-Feld behalten. · INC-0 **SNMALLOC_*-Strings am Organ-Build-Contract** (Emission via Compiler-Flag-Naht); **-mcx16 bleibt Compiler-ISA-Freigabe** (wandert NICHT nach hardware_isa). · INC-29 **`std::variant<InfraErrorClass,CompilerCompilerErrorClass>`** + Planer-seitiges isa_features-Skip.
- **ZURÜCKGESTELLT (getrackter Punkt, blockiert nicht):** `page_type`-Zuordnung — echter Nachschlagewerk-Widerspruch (§1/§3 build-only System vs §2 Organ-Sub unter node_type). INC-1a lässt page_type aus.
- **SIMD-Observer-Re-Homing (INC-2d):** SIMD-Messung bleibt honest-0 (F-SIMD=system_config ohne Messung); Observer-Zeile fällt wie telemetry weg. Reales Re-Homing = getrackter Folge-Punkt.

## Kadenz je Schritt
ctest + golden-Roundtrip==320 (Schritte 1–6; INC-2d: golden-Neubau messdaten-erhaltend + POD/ABI-Diff-Checkpoint) + cf22=0 + Mojibake=0 + super-Sub-Build + beide Remotes + CI hart-grün. Granulare Commits je Sub-Schritt.
