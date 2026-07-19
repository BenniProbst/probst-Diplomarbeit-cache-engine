# Ketten-Konformitaets-Audit Planer->CEB->Tier-Binary (ultracode wf_dbf8accf)
> 2026-07-19, 7 Agenten, adversarial, neueste-Fakten-gewinnen. Vertraege zwischen voll beweglichen Modulen + Achsen-Typ-Verteilung (Mess/System/Organ). Schwester zum 9-Dim-Audit (docs/audits/20260718-konformitaets-audit-9dim-REPORT.md).

---

# Ketten-Konformitaets-Report — Experiment-Planer → CEB → Tier-Binary

Basis: konsolidierte Befunde aus 5 Pruef-Dimensionen. Belege als `datei:zeile`. Neueste Fakten (Ledger 22 / INC-2d) sind autoritativ.

---

## 1. GESAMT-VERDIKT: 3/5 KONFORM (2/5 TEILWEISE)

| Dimension | Verdikt | Max-Severity |
|---|---|---|
| ketten-struktur | **TEILWEISE** | mittel |
| vertraege-abi-stabil | **KONFORM** | gering |
| bewegliche-module | **KONFORM** | gering |
| planung-korrekt | **KONFORM** | gering |
| achsen-typ-verteilung | **TEILWEISE** | mittel |

**Keine kritischen und keine hohen Befunde.** Hoechste bestaetigte Severity = *mittel* (3 Befunde: Ebene-1-Dock nicht ABI, kein Planer-Executable, System ⊃ Tier nicht verschachtelt). Alle drei sind als IST-Delta bzw. INC-1/INC-2-Roadmap dokumentiert — kein verdeckter Bruch.

### Executive Summary zur Kette
Die **untere** Kettenhaelfte (CEB → Tier-Binary) ist real, hart und test-bewiesen: echte `.so`-ABI-Grenze via `AnatomyModuleLoader` (dlopen `RTLD_NOW|RTLD_LOCAL`, 4 Pflicht-Symbole, Magic+Major-Gate, sauberes `native_unload` bei Mismatch), memcpy-POD-Snapshot, korrekte Mixed-Radix-Bijektion der Experiment-Planung. Die **obere** Kettenhaelfte (Experiment-Planer → CEB) ist noch **keine** ABI-/Dock-Grenze, sondern eine header-only Funktions-Naht in derselben Lib; der benannte Planer-Codegen (Director/Builder) und ein Planer-Executable existieren noch nicht. Die Multi-Gattungs-Faehigkeit ist als Header vorhanden, aber im Produktions-Iterator noch nicht verdrahtet (SearchAlgorithm-only).

### Vertraege (Kurzstatus)
- **ABI-Major = 6**, Magic `0x434F4D444141362E` = `COMDAA6.` (`.A6.`) — `anatomy_module_abi_v1_decl.hpp:54/58`.
- **Snapshot-POD 1272 B**, Version 7, `kV3AxisCount=17`, `standard_layout`+`trivially_copyable` — `observable_tier.hpp:49/125-154`, Groesse test-gesichert `test_s7_10_swiss_pool_allocator_deg.cpp:139`.
- **3-teiliger Pruef-Dock-Vertrag** vollstaendig: `AbiTierTraceConfig` + `ComdareResourceControlV1` (immer verfuegbar) + `ComdareTierObserverSnapshot` (ein memcpy-POD). `IDriveableTier` immer einkompiliert, `IObservableTier` erbt nur bei Messung-AN.
- **Kardinalitaets-Identitaet** literal test-verankert: `binary_count == PROD mp_size == PermutationEngine::count` — `experiment_tree.hpp:361`, `source_catalog.hpp:141`, `permutation_engine.hpp:112`, Gate `test_br1_full22_count.cpp:69` (320 / 131072).

### Achsen-Typ-Verteilung (Kurzstatus)
- **17 Organ-Achsen** (Komposition) bilden `binary_id`/`algo_sig` **ausschliesslich** — `kCompositionAxisNames` (17) `axis_path_serialization.hpp:34`, `compose_algo_signature` iteriert nur diese `axis_variant_version_table.hpp:64-84`.
- **System-Achsen** haben eigene Wurzel („Blut", `system_axes_always_present()==true`) — `system_axis.hpp:146/150`; CEB-Konfig (Compiler/ExtensionHardware/TargetIsa/HardwareIsa/Scheduling/LoadFramework) erben `CebSystemAxis` `ceb_system_axis.hpp:22`.
- `telemetry` (INC-2c) und `isa` (INC-2d) haben die Komposition verlassen. **Keine Fehl-Typisierung** (kein Organ erbt System-Wurzel, keine System-Achse erbt `OrganAxis` — grep leer). Restproblem: **Stufen-Ort** (System ⊃ Tier) noch flach statt verschachtelt (siehe §4).

---

## 2. Bestaetigte Abweichungen je Dimension (kritisch → gering)

### 2.1 ketten-struktur — TEILWEISE

| Sev | Abweichung | code_ref | Verletzte Anforderung |
|---|---|---|---|
| **mittel** | Rekursive Zwei-Ebenen-Dock-Topologie nur halb real: Ebene 2 echter ABI-`.so`-Uebergang, Ebene 1 (Planer↔CEB) nur header-only Funktions-Naht in dieselbe Fassaden-/Harness-Lib (kein Planer-`.so`, keine ABI-Grenze, keine ueber die Grenze gespiegelten Concepts). | `experiment_run_entry.hpp:138-144` vs `pruef_dock/pruef_dock.hpp:11-14` | Anf. (a) rekursive Dock-Topologie auf zwei Ebenen (Ledger 18.1.1 + 19.C) |
| **mittel** | Kein Planer-Executable / kein CLI-Einstieg: `run_experiment_profile` ist reiner Fassaden-Bibliothekscode ohne `apps/`-Aufrufer; `parse_experiment_profile` nur test-verdrahtet; `apps/f15_compare` misst nur vor-gebaute perm-DLLs (Ebene 2), faehrt NICHT die Planer→CEB-Baukette. | `profile_run_facade.cpp:494-599`, `test_experiment_parser.cpp:71` | Anf. (a) Planer = versteckte root-Minimal-Binary, XML-abhaengiges Build (Ledger 18.1.8/18.1.1) |
| gering | Codegen-Director/Builder-Bauplan nicht implementiert (grep `ExperimentPlanDirector`/`IPlanBuilder`/`CiYamlBuilder`/`CMakeGraphBuilder` leer); Planung laeuft imperativ als `opt×simd×Phasen`-Schleife statt EIN Walk + 2 ConcreteBuilder + Template-Method. `codegen.cpp` ist Alt-Phase-6.4-Stub. | `experiment_run_entry.hpp:257-365`, `builder/codegen/codegen.cpp:11` | Anf. (d) Director + 2 ConcreteBuilder + Template Method (Design-Doc 20260716) |
| gering | Multi-Gattungs-Dock-Dispatch nicht im Produktions-Mess-Pfad: Iterator ruft hartkodiert `acquire_search_algorithm_drive`, `PruefDockRegistry::select_for`/`IPruefDock::accepts` ungenutzt → heute nur SearchAlgorithm-Gattung baubar/messbar. | `cache_engine_builder_iterator.hpp:811-812`, `pruef_dock_registry.hpp:22-49` | Anf. (a) CEB baut+misst verschiedene Gattungen ueber ihr Pruef-Dock (Ledger 18.1.2/19.C) |
| gering | Ergebnis-Rueckschrieb nur indirekt/inert: XML-`<output>` nur geloggt („Provenienz"), Rueckschrieb ueber `measurement_sink` per Default No-Op (Storage #51 inert); autoritatives Ziel ist host-gereichte `out_csv` (E8) statt XML-Ziel. | `experiment_run_entry.hpp:169-173`, `:374-376` | Anf. (a) CEB schreibt selbst ans XML-Ziel |
| gering | Veralteter Kommentar (interne Inkonsistenz): `genus_organ_binding.hpp:10` „18 Komposition-Achsen" vs `:27` korrekt „17". | `genus_organ_binding.hpp:10` vs `:27` | Anf. (b) `kV3AxisCount==17` (Ledger 22) |

### 2.2 vertraege-abi-stabil — KONFORM
Alle harten ABI-/Versionierungs-Anforderungen erfuellt (siehe §1). **Keine bestaetigte ABI-Verletzung.** Verbleibende Befunde = Doku-Drift + Haertungs-Luecken (alle gering, in §3/§5).

### 2.3 bewegliche-module — KONFORM
`KaryPerKCatalog` umgeht bewusst den Registry-enabled-Filter (`source_catalog.hpp:514`), adversarial geprueft **kein Bruch**: legitime `axis_03a`-Vendor-Typen, Bypass betrifft nur das enable-Flag (Default-OFF, opt-in, `#188`), golden-neutral (disjunkter `binary_id`-Raum), **kein Cross-Achsen-Hardwiring**. Keine Abweichung.

### 2.4 planung-korrekt — KONFORM
Kardinalitaets-Invariante und Mixed-Radix-Bijektion (Ebene 0 = MSB, `experiment_tree.hpp:236-289`) literal test-bewiesen (`test_e3_contract_binary_id_bijektion.cpp:104-165`), lazy (keine 2^17-Materialisierung, `FullSourceCatalog::Engine` nie instanziiert). Keine Abweichung. Transparenz-Hinweis: benannter Planer-Codegen fehlt (gehoert zu §2.1).

### 2.5 achsen-typ-verteilung — TEILWEISE

| Sev | Abweichung | code_ref | Verletzte Anforderung |
|---|---|---|---|
| **mittel** | Stufen-Ort (System ⊃ Tier) nicht umgesetzt: `build_system_axis_levels()` spaltet `page_type/simd_extension/general_hardware/telemetry/isa` ab, markiert sie aber `is_static=true` und `build_all_axis_levels()` konkateniert sie FLACH neben die Organ-Achsen. Latent: einziger Live-Konsument (`profile_run_facade.cpp:417`) nutzt sie nur fuer Validierungs-Registry, nicht fuer Baum-Provisionierung → **kein Live-Leak**. | `registry_to_axis_levels.hpp:113-122`, `axis_reflect.hpp:42` | Ledger 21.B (System ⊃ Tier) + INC-1-Bauplan |
| gering | `all_axes_binary_count()` multipliziert System-Achsen-Dimensionen in einen Wert namens „binary_count" — Namens-/Semantik-Drift (nach INC-2d nicht Teil der `binary_id`); nur in Doku-Kommentaren, kein Provisioning-Konsument. | `registry_to_axis_levels.hpp:147-161` | Ledger 22 INC-2d (`binary_id` nur aus 17 Organ) |
| gering | Veraltete Slot-Zahl-Kommentare (19/18) widersprechen Stand 17. | `axis.hpp:18`, `ceb_system_axis.hpp:7`, `axis_path_serialization.hpp:87`, `genus_organ_binding.hpp:10` | Ledger 22 (INC-2d KOMPLETT) |

Positive Durchsetzung (konform): `build_orchestrator` achsen-blind, trennt System-Provenienz (`.version`) von Organ-`algo_sig` (`.algos`) — `build_orchestrator.hpp:181-186`; `genus_organ_binding` erzwingt compile-time Gattung-bindet-nur-Organ — `genus_organ_binding.hpp:30-58`.

---

## 3. Vertrags-/ABI-Luecken

| # | Luecke | code_ref | Severity |
|---|---|---|---|
| V1 | **Ebene-1-Grenze (Planer↔CEB) nicht ABI-stabil**: header-only Funktions-Naht, kein Planer-`.so`, keine Vertrags-Grenze, keine gespiegelten Concepts. Modul-Vertrag fehlt vollstaendig auf dieser Ebene. | `experiment_run_entry.hpp:138-144` | mittel |
| V2 | **Kein Planer-Executable / kein untergeordnetes tiefes Build** (3. Framework-Anwendung); Anatomy-Major-Bump „reitet" laut Kommentar an einer Naht ohne eigenes Planer-Binary. | `profile_run_facade.cpp:494-599`, `apps/*` (kein Aufrufer) | mittel |
| V3 | **Multi-Gattungs-Vertrag vorhanden, aber ungenutzt**: `PruefDockRegistry`/`set_dock`/`sequence_dock`/`view_dock`/`adapter_dock` als Header da, Iterator dispatcht nicht darueber → Grenze faktisch nur SearchAlgorithm. | `pruef_dock_registry.hpp:22-49`, `cache_engine_builder_iterator.hpp:811-812` | gering |
| V4 | **ABI-Haertung am memcpy-POD unvollstaendig**: `sizeof==1272` nur als Laufzeit-`EXPECT_EQ` in einem Allokator-Test, KEIN `static_assert(sizeof==1272)` am Struct → versehentliches Feld kompiliert still durch. | `observable_tier.hpp:146` (Guard fehlt), Test `test_s7_10:139` | gering |
| V5 | **Loader nutzt nicht die benannte Vertrags-Methode**: reimplementiert Major/Minor-Gate inline statt `AnatomyAbiVersion::host_compatible_with()` (`decl:124-127`, dort explizit als Gate ausgewiesen) → latentes Divergenz-Risiko bei Semantik-Aenderung (z.B. N/N-1). | `anatomy_module_loader.cpp:138` | gering |

Grenzen, die **korrekt ABI-stabil** sind: Loader-Gate (Magic+Major, `loader.cpp:130-145`), Snapshot-POD (Version 7, `observable_tier.hpp:49`), Genus-ABIs (Set/Sequence/View/Adapter alle an `COMDARE_ANATOMY_ABI_MAJOR` gegated), `ceb_contract_version` in `build_version` gefaltet mit strikt getrenntem `perm.algos` (`profile_run_facade.cpp:293-315`).

---

## 4. Achsen-Typ-Fehlverteilungen (Mess / System / Organ am falschen Ort)

**Keine echte Typ-Fehlplatzierung im Vererbungssinn** — grep bestaetigt: kein Organ-`StrategyBase` erbt System-Wurzel, keine System-Achse erbt `OrganAxis`/`AxisBase`. Verbleibende Fehlverteilungen sind **struktureller Ort** und **Zaehl-Semantik**:

| # | Fehlverteilung | code_ref | Severity |
|---|---|---|---|
| A1 | **System-Achsen am Organ-Ort markiert**: `build_system_axis_levels()`-Achsen tragen `is_static=true` und sitzen als FLACHE Geschwister neben Organ-Achsen statt als umschliessende System-Schicht. Bei Aufruf von `static_binary_view()` auf einem aus `build_all_axis_levels()` gebauten Baum wanderten 5 System-Achsen als Segmente in die `binary_id` (`StaticBinaryView::operator[]` konkateniert alle `is_static`-Ebenen). Heute latent (Live-Konsument meidet den Pfad). | `registry_to_axis_levels.hpp:113-122`, `experiment_tree.hpp:271-286` | mittel |
| A2 | **System-Achsen-Dimensionen in „binary_count" verquickt**: `all_axes_binary_count()` multipliziert `telemetry/isa/page_type/simd_extension/general_hardware` in eine „Binary"-Zaehlung; sollte „all-axes matrix count" heissen. | `registry_to_axis_levels.hpp:147-161` | gering |

---

## 5. Alt/Neu-Konflikte (gewinnender neuester Fakt)

Neuester Fakt: **Ledger 22 / INC-2d** — Major = 6, 17 Organ-Slots (`isa` raus, davor `telemetry` raus in INC-2c: 19→18→17), Snapshot `sizeof==1272`, Version 7. Laufzeit-Konstanten sind ueberall korrekt 17 — die Konflikte sind reine Doku-/Kommentar-Drift ohne Verhaltensfolge.

| Alt (Kommentar/Doku) | Neu (gewinnt) | code_ref |
|---|---|---|
| „18 Komposition-Achsen" (Zeile 10) vs „17" (Zeile 27) — interne Inkonsistenz | 17 (`kV3AxisCount`, `slot_count`) | `genus_organ_binding.hpp:10` vs `:27` / `genus_binding_traits.hpp:39` |
| `organ_count()`-Doku „Pflicht 19 (17 Such + q1/q2)", Enum „19-Achsen-Anatomie" | 17 (`composition_organ_count::value==17` alle Kompositionen, test-gesichert) | `anatomy_base.hpp:169`, `:79` / `test_v41_anatomy.cpp:51-56` |
| Modul-Autor-Makros „19 Achsen (T0..T18) / organ_count()==19 / 19-Slot-ABI-Invariante"; ebenso `validate_profile.hpp:54`, `genus_binding_traits.hpp:12` | 17 (datengetriebenes `AdHocComposition<...>`, kein ABI-Bruch) | `anatomy_module_abi_v1.hpp:74 (66-90)` |
| „19 Slots" / „19 Organ-Achsen" / „19-Achsen-binary_id" | 17 (`kCompositionAxisNames` `std::array<...,17>`) | `axis.hpp:18`, `ceb_system_axis.hpp:7`, `axis_path_serialization.hpp:87` |
| Alt-Phase-6.4-Stub-Emitter (`module_abi_v1`) als vermeintlicher Planer-Codegen | Planer-Codegen (Director/Builder) noch NICHT gebaut; reale Naht `experiment_run_entry.hpp` → `cache_engine_builder_iterator.hpp` | `builder/codegen/codegen.cpp:11` |
| `IAnatomyBase`-Vertragstext auf eingefrorener ABI-Grenze „19 Slots" | 17 (Laufzeit-ABI aus `composition_organ_count` getrieben, nicht hartkodiert → kein Bruch) | `anatomy_base.hpp:169` |

---

## 6. Priorisierte Fix-Liste (mit Aufwand)

Reihung: Wirkung × Ease. Quick-Wins zuerst, dann ABI-Haertung, dann Roadmap-Architektur.

| Prio | Fix | code_ref | Sev | Aufwand |
|---|---|---|---|---|
| **P1** | `static_assert(sizeof(ComdareTierObserverSnapshot)==1272)` direkt am Struct ergaenzen (Compile-Time-ABI-Guard). | `observable_tier.hpp:146` | gering (V4) | **klein** (~10 min, 1 Zeile) |
| **P2** | Alle veralteten 19/18-Slot-Kommentare auf 17 ziehen (loest §5 + interne Inkonsistenz `genus_organ_binding.hpp:10↔27`). | `anatomy_base.hpp:169/79`, `anatomy_module_abi_v1.hpp:74`, `axis.hpp:18`, `ceb_system_axis.hpp:7`, `axis_path_serialization.hpp:87`, `validate_profile.hpp:54`, `genus_binding_traits.hpp:12`, `genus_organ_binding.hpp:10` | gering | **klein** (reine Kommentare, ~30 min) |
| **P3** | Loader auf `AnatomyAbiVersion::host_compatible_with()` umstellen (Divergenz-Risiko schliessen; Tests decken beide Pfade bereits). | `anatomy_module_loader.cpp:138` | gering (V5) | **klein** (~20 min) |
| **P4** | `all_axes_binary_count()` → `all_axes_matrix_count()` umbenennen; Doku-Kommentare (`axis_03m_mapping_registry.hpp:21`, `source_catalog.hpp:137`) klarstellen (System-Achsen ≠ `binary_id`). | `registry_to_axis_levels.hpp:147-161` | gering (A2) | **klein** (~20 min, Rename) |
| **P5** | Multi-Gattungs-Dispatch verdrahten: Iterator ueber `PruefDockRegistry::select_for`/`IPruefDock::accepts` statt hartkodiertem `acquire_search_algorithm_drive`. | `cache_engine_builder_iterator.hpp:811-812` | gering (V3) | **mittel** (INC-2d/2e, mehrere Gattungen + Tests) |
| **P6** | Stufen-Ort System ⊃ Tier: System-Achsen aus dem `is_static`-Organ-Zweig loesen und als umschliessende Schicht verschachteln (Andockpunkt `build_system_axis_levels()`). | `registry_to_axis_levels.hpp:113-122`, `axis_reflect.hpp:42` | **mittel** (A1) | **gross** (INC-1/INC-2-Umbau, Baum-Struktur) |
| **P7** | Planer-Codegen bauen: `ExperimentPlanDirector` + `IPlanBuilder` + `CiYamlBuilder`/`CMakeGraphBuilder`, EIN Walk + Template-Method; Alt-Stub `codegen.cpp` ersetzen. | `experiment_run_entry.hpp:257-365`, `builder/codegen/codegen.cpp:11` | gering (Design-Delta) | **gross** (Design-Doc 20260716, Neubau) |
| **P8** | Ebene-1 zu echtem Dock: Planer als versteckte root-Minimal-Binary mit XML-abhaengigem Build + ABI-`.so`-Grenze Planer↔CEB (schliesst V1+V2). | `experiment_run_entry.hpp:138-144`, `profile_run_facade.cpp:494-599` | mittel (V1/V2) | **gross** (neues Executable + ABI-Grenze; Roadmap) |

**Hinweis:** P5–P8 sind samtlich als IST-Delta bzw. INC-1/INC-2-Roadmap dokumentiert (Req(a)-supersedes-Note, INC-2d/2e-Kommentare) — kein verdeckter Bruch, sondern bekannte geplante Zukunft. P1–P4 sind sofortige, golden-neutrale Quick-Wins.
