# BAUPLAN Bau-INC-1 — CEB-System-Achsen-Schichtung (System ⊃ Tier)

> **STATUS: ERSTELLT ZUR FREIGABE.** Kein Bau-Start ohne explizites User-GO für Bau-INC-1.
> Erstellt 2026-07-17. Basis: 4 Erfassungs-Reports (Modell / Plandocs / Ist-Code / ABI-TABU-Grenze), alle Zeilenbelege stichprobenartig eigenhändig gegen den CE-Baum verifiziert (grep 2026-07-17).
>
> Pfade: **CE** = `Code/external/comdare-cache-engine`; **SUPER** = Repo-Wurzel; **LEDGER** = `docs/DIPLOMARBEIT-ZIELE-OFFENE-PUNKTE-LEDGER.md`. Alle CE-Belege relativ zu CE.

---

## (0) KOPF — Zweck, Scope-Grenze, Freigabe-Status

### Zweck
Bau-INC-1 hebt die **4 CEB-System-Achsen** (Scheduling #37 / Hardware-ISA + H-7 / Telemetrie-RAHMEN / Last + Last-Frameworks) aus ihrer heutigen **flachen, verstreuten** Lage in eine **gemeinsame compile-time-Schicht ÜBER den 19 Organ-Achsen** — `System-Achsen ⊃ Tier-Binary-Achsen` (LEDGER:86; §19.C). Heute liegen alle 26 Achsen flach in **einem** `std::vector<AxisLevel>` (`registry_to_axis_levels.hpp:81-83`, `build_all_axis_levels()`, `lv.reserve(26)`), ohne System/Organ-Trennung; die 4 System-Achsen sind verstreut (Telemetrie als Organ-Slot T10, Hardware als Organ-Slot T12 + 3 Build-only-Achsen, Scheduling als verwaiste Runtime-vtable, Last als dynamischer Antriebspunkt) — das §19.D-Schichtungs-Delta.

INC-1 spaltet `build_system_axis_levels()` von `build_all_axis_levels()` ab, gibt der System-Schicht eine **eigene abstrakte Wurzel** („Blut", getrennt von der Organ-Wurzel `AxisBase`), und verankert die 4 System-Achsen als **CRTP + Concept-Guard** (keine vtable) über den Organen.

### Scope-Grenze (HART)
- **ABI-MAJOR == 4 bleibt** — `anatomy_module_abi_v1_decl.hpp:43` (`#define COMDARE_ANATOMY_ABI_MAJOR 4`), Magic `.A4.` (`:47` `0x434F4D444141342EULL`). INC-1 ist **ABI-4-KOMPATIBEL**, bumpt den Major **NICHT**. Der 4→5-Bump ist Bau-INC-2 (LEDGER:87, LEDGER:96).
- **golden == 320 UNVERÄNDERT** — `CatalogAxes<4,4,5,4>=320` (`source_catalog.hpp:80,112`). golden-Roundtrip==320 bleibt Kadenz-Gate; INC-1 ändert golden nicht (LEDGER:1882).
- **TABU unberührt** (T1–T8, siehe §5): POD-1416, kV3AxisSchema, GenusBindingTraits, serialize_composition_path/kCompositionAxisNames, golden_fullpilot_320, permutation_axes.xml, Registry-mp_list — nur additiv, Default-OFF.
- **KEINE Telemetrie-Herauslösung aus binary_id** — Organ-Slot T10 bleibt in `kCompositionAxisNames`. Herauslösung = ABI-Major-Bruch = **INC-2** (LEDGER:87; Report 4 W4).
- **KEIN POD-Feld-Anhang** (auch nicht AVX10 an `BuildVariantDefinitionV1` oder an `ComdareTierObserverSnapshot`) — jede POD-Erweiterung wäre ABI-4-Bruch = INC-2 (Report 4 W2).

### User-Freigabe-Status
**ERSTELLT ZUR FREIGABE.** Der INC-1-**Inhalt** ist durch „VOLLES GO" (§19.A, §20.E) sachlich entschieden; die explizite **Bau**-Freigabe für Bau-INC-1 steht formal noch aus (§20.B, §20.E). Bau beginnt erst nach ausdrücklichem User-GO.

---

## (1) IST-KARTIERUNG (datei:zeile, aus Report 3, stichprobenverifiziert)

### 1.1 Die flache Achsen-Struktur (der Schichtungs-Andockpunkt)
- **AxisLevel-POD**: `builder/experiment_tree/experiment_tree.hpp:189` `struct AxisLevel { std::string axis; std::vector<std::string> values; bool is_static=true; … }`. **KEIN system/organ-Feld** — die Schichtung existiert im POD heute nicht.
- **Der EINE Befüllpunkt**: `builder/experiment_tree/registry_to_axis_levels.hpp:81-83` `build_all_axis_levels()` → `std::vector<AxisLevel> lv; lv.reserve(26);` + 26× `push_static_axis<…>(…)`. ALLE 26 uniform, ALLE `is_static=true`, KEINE System/Organ-Trennung.
- **push_static_axis**: `axis_reflect.hpp:40-43` — setzt `is_static=true`, `block_id=Achsenname`, hart für jede Achse gleich.
- **Drei unkoordinierte Achsen-Inventare** (Report 3 Befund 1): 26-typgetrieben (`registry_to_axis_levels.hpp:50-76`) / 19-Pfad (`axis_path_serialization.hpp:30`, `kCompositionAxisNames`) / String-Legacy (`axis_library_registry.hpp:25-384`). In KEINEM wird System von Organ unterschieden.
- ⇒ **Andockpunkt Schichtung**: `build_all_axis_levels()` (`registry_to_axis_levels.hpp:81`) ist der eine Punkt, an dem `build_system_axis_levels()` abgespalten werden muss.

### 1.2 Scheduling (#37) — verwaiste Runtime-vtable
- `include/cache_engine/concepts/scheduling_strategy.hpp:56` `class ISchedulingStrategy` = REINE VTABLE (5 pure-virtual `:58-62`, virtueller dtor `:64`). DEPRECATED-Marker `:3` (nachgezogen 2026-07-17 F6). **0 C++-Konsumenten** (grep-verifiziert). Verletzt `no_runtime_switch`/`compile_time_only`.
- 3 Schwestern gleiches Muster, alle DEPRECATED, 0 Konsum: `concepts/numa_affinity.hpp`, `concepts/locking_mode.hpp`, `concepts/hardware_strategy.hpp`.

### 1.3 Telemetrie — Organ-Slot T10 + parallele Mess-System-Achse
- Organ: `registry_to_axis_levels.hpp:60/94` → `push_static_axis<…T10_telemetry>(lv,"telemetry")`; `composition_factory.hpp:35/62`; `kCompositionAxisNames[10]="telemetry"` (`axis_path_serialization.hpp:33`) ⇒ **permutiert binary_id**.
- Mess-Seite (das „Blut", bereits Soll-Muster): `include/cache_engine/measurement/system_axis.hpp:148` `struct SystemAxis`, Concept `:183`, `system_axes_always_present()==true` `:145`. Registry `measurement/measurement_axis_registry.hpp:32` `kMeasurementAxisRegistry` (16 Kategorien), `consteval registry_is_complete()` `:52`, `static_assert` `:61`. Kommentar `:3` „KEIN Runtime-Switch — reine constexpr-Tabelle"; `:5` „Konsumenten … = Folge-Increment".

### 1.4 Hardware/ISA — -march/-mavx heute NICHT gekoppelt
- Build-Definitions-POD: `anatomy/build_variant_definition.hpp:17` `struct BuildVariantDefinitionV1` (nur uint64 → ABI-fest; `simd_avx512` `:24`, `hw_cache_line` `:26`). Flach als T17/T18/T19 im 26er-Vektor.
- Organ-ISA = T12 (`composition_factory.hpp:37`).
- **Fehl-Andockpunkt**: `builder/build_orchestrator/build_orchestrator.hpp:466` `make_gpp_compile_fn` schreibt `.rsp` mit HART `-std=c++23` (`:475`) / `-O2` (`:476`) / `-fPIC` / `-shared` — **KEIN `-march`/`-mavx`** ⇒ Binary faktisch generisch. Der ISA→Flag-Mapper existiert nur im codegen-Weg (`permutation_codegen_tool.cpp:43-48` `simd_flags()`), nicht im Facade/Orchestrator-Weg.

### 1.5 Last / Last-Frameworks — dynamischer Antriebspunkt
- `builder/workload_driver/load_profile_parser.hpp:74` `parse_load_profile`; Treibe-Punkt `anatomy/measurable_workload.hpp:31` `run_workload(…)`.
- Workload heute DYNAMISCHE Achse (`is_static=false`): `profile_facade/experiment_run_entry.hpp:145-147` `AxisLevel{"workload", …, /*is_static=*/false, …}` ⇒ verändert binary_id NICHT.

### 1.6 CEB-System-Achsen-Versionierung (H-10)
- `build_orchestrator.hpp:62` `std::string build_version` (BuildConfig; „leer = nie überspringen"). Sidecar: `:162` `version_sidecar_path`, `:170` Vergleich (Skip/Resume via `dll_is_current`, aufgerufen `:282`), `:175` `write_version_sidecar` (aufgerufen `:322`). Default „m3v2".
- **Delta**: `build_version` kodiert die System-Achsen-Wahl (Scheduling/ISA-march/Workload/Telemetrie-Regime) heute NICHT ⇒ Gefahr falsches Skip bei geänderter System-Achse.

### 1.7 Vorhandene CRTP+Concept-Vorlagen im Code (das Soll-Muster existiert dreifach)
- Organ-Wurzel: `topics/axis_base.hpp:52` `struct AxisBase`, Concept `:91` `AxisBaseConcept`.
- Organ-Achse ISA (für #37 am nächsten): `axes/simd/axis_09_isa_strategy_base.hpp:11-16` `IsaStrategyBase<Derived> : public …::topics::AxisBase` mit `static_assert(concepts::IsaStrategy<Derived>)` + `AxisBaseConcept<Derived>`.
- Organ-Achse concurrency: `axes/concurrency_axis/axis_08_concurrency_strategy_base.hpp:12-17` (identisches CRTP+static_assert(concept)-Muster).
- **System-Seite („Blut") bereits gebaut**: `measurement/system_axis.hpp:148` `SystemAxis<Derived>` (empty base) + Concept `:183` (`is_empty_v && !is_polymorphic_v` ⇒ zero-cost, keine vtable).

---

## (2) DESIGN der Schichtung

### (2a) Eigene abstrakte Wurzel für die System-Achsen („Blut", getrennt von den Organ-Achsen)

**Doktrin** (Memory `feedback_system_axes_measurement_own_abstract_root_blood`; Report 4 §3): Organ- vs System-Achsen NIE mischen; jede Schicht eigene abstrakte Wurzel — die Wurzeln **schneiden sich nicht** (verschiedene Basen), verwenden sich nur lesend.

Zwei Wurzeln existieren/entstehen (beide zero-cost, keine vtable):
- **Organ-Wurzel** (bestehend): `topics/axis_base.hpp:52` `AxisBase` + `AxisBaseConcept` — trägt die 19 Organ-Achsen. **UNBERÜHRT.**
- **System-Wurzel „Blut"**: die bestehende `measurement/system_axis.hpp:148` `SystemAxis<Derived>` ist die Mess-Seite dieser Schicht (16 Mess-Kategorien). Die **4 CEB-Konfig-System-Achsen** sind KEINE Mess-Quellen, sondern **Bau-/Konfig-Achsen** (sie treiben, wie die Tier-Binary kompiliert/durchgemessen wird). f4-A dokumentiert ausdrücklich, dass die Registry-16 reine MESS-Kategorien sind und die 4 Pflicht-Konfig-Achsen HEUTE keine Verankerung haben.

**Konservative Empfehlung (Typ-Skizze):** eine **neue, dedizierte Konfig-System-Achsen-Wurzel** `CebSystemAxis<Derived>` als Geschwister der Mess-`SystemAxis`, beide unter der System/„Blut"-Familie, beide getrennt von der Organ-`AxisBase`. Muster 1:1 nach `IsaStrategyBase` / Mess-`SystemAxis` (empty base, CRTP, Concept-Guard):

```cpp
// NEU (INC-1a) — Konfig-System-Achsen-Wurzel; zero-cost, keine vtable, static-dispatch via Derived.
template <class Derived>
struct CebSystemAxis {          // empty base — is_empty_v<CebSystemAxis<Derived>> == true
    // static-constexpr-Properties je Achse via Derived::… (analog SystemAxis::do_categories)
    [[nodiscard]] static constexpr std::string_view axis_label() noexcept { return Derived::do_axis_label(); }
    // reine Compile-time-Reflektion; KEINE virtuellen Funktionen.
};

template <class A>
concept CebSystemAxisConcept =
    std::derived_from<A, CebSystemAxis<A>> &&
    std::is_empty_v<CebSystemAxis<A>> &&
    (!std::is_polymorphic_v<CebSystemAxis<A>>) &&
    requires { { A::do_axis_label() } -> std::convertible_to<std::string_view>; };
```

Der Concept-Guard (`is_empty_v && !is_polymorphic_v`) **schlägt beim Kompilieren fehl**, falls je eine vtable eingeschleppt wird (Anti-Runtime-Switch-Sicherung). Benanntes Pattern: **CRTP (Coplien 1995) + Concept-as-Static-Interface (C++20, „Concept-Guard") + Separation of Hierarchies** (Report 4 §3).

> **Alternative (dokumentiert, nicht empfohlen):** die 4 Konfig-Achsen direkt unter die bestehende Mess-`SystemAxis<Derived>` hängen. Nachteil: überlädt die Mess-Semantik (`do_categories`/`do_collect`) mit Konfig-Achsen, die keine Mess-Quellen sind. → Root-Wahl ist die eine echte Design-Detailfrage, siehe §7-Q1.

### (2b) Die 4 System-Achsen — compile-time-Interface, Umschließung, Andockpunkt

Jede der 4 wird ein `template<class D> struct XxxSystemAxis : CebSystemAxis<D>` mit `static_assert(CebSystemAxisConcept<D>)` (Muster wie `IsaStrategyBase`, `axis_09_isa_strategy_base.hpp:11-16`). Sie **umschließen** die Organ-Schicht, indem sie als Bauparameter der CEB bestimmen, wie die untergeordneten Tier-Binaries statisch gebaut/durchgemessen werden — sie **permutieren die 19 Organe NICHT** und stehen **nicht** in `kCompositionAxisNames`.

| System-Achse | compile-time-Interface (CRTP+Concept, benanntes Pattern) | Umschließung der Organ-Schicht | Andockpunkt (datei:zeile) |
|---|---|---|---|
| **Scheduling (#37)** | `SchedulingSystemAxis<D> : CebSystemAxis<D>`; trägt die 5 Scheduling-Enums (`scheduling_strategy.hpp:36-45`) als **static constexpr Properties** (kein vtable). Pattern: CRTP + Concept-Guard. Runtime-Unter-Achse referenziert `thread_count` im RC-POD (nicht neu erfinden, Report 2/D). | Bau-Parameter der CEB; **ersetzt NICHT** die verwaiste Runtime-vtable (das ist INC-2), sondern tritt daneben; golden-neutral, da die vtable nie konsumiert wird. | neuer Base analog `axis_09_isa_strategy_base.hpp:11`; registriert in `build_system_axis_levels()` (aus `registry_to_axis_levels.hpp:81`). Alte `ISchedulingStrategy` bleibt DEPRECATED (`:3`), **nicht gelöscht**. |
| **Hardware-ISA + H-7** | `HardwareIsaSystemAxis<D> : CebSystemAxis<D>`; trägt die `-march`/`-mavx`-Belegung als static-constexpr, abgeleitet aus dem Build-ISA-Wert (09b/simd_extension). Pattern: CRTP + Concept-Guard; **Compiler-Makro-guarded** SIMD-Dispatch bleibt (phase01, `__AVX2__`/`__AVX512F__`, build-invariant uint64). | treibt `-march`/`-mavx` in `make_gpp_compile_fn`, unter dem die gesamte Organ-Permutation gebaut wird; die **Hardware-System-Achse selbst berührt NIE binary_id** (e18: Host-Deskriptor vs. Build-ISA getrennt). | `build_orchestrator.hpp:466/476` (`make_gpp_compile_fn`, heute nur `-O2`) ← Flag-Quelle analog `simd_flags()` (`permutation_codegen_tool.cpp:43-48`). W-C-Grenzfrage siehe §7-Q2. |
| **Telemetrie-RAHMEN** | Nur der **Rahmen/Wurzel-Reflex** — die Mess-Telemetrie-System-Achse bleibt Mess-Seite (`system_axis.hpp:192-332`, immer präsent, golden-neutral). INC-1 baut KEINE Herauslösung des Organ-Slots T10. | die Mess-Telemetrie steht bereits ÜBER den Organen (immer präsent, kein Achsen-Slot); INC-1 verankert sie nur als Teil der abgespaltenen System-Schicht. | `system_axis.hpp:148` (Wurzel) + `measurement_axis_registry.hpp:32` (bleiben Mess-Seite). Organ-Slot T10 (`registry_to_axis_levels.hpp:60/94`) **UNBERÜHRT** (Herauslösung = INC-2). |
| **Last + Last-Frameworks (H-9)** | `LoadFrameworkSystemAxis<D> : CebSystemAxis<D>`; trägt die **Framework-Wahl** als static-constexpr (Ordner-Etikett). Die einzelnen Workload-Parameter bleiben dynamische Unter-Achse. Pattern: CRTP + Concept-Guard + Prüf-Dock-Settings (`ComdareResourceControlV1`, immer präsent). | die Framework-Wahl umschließt (als Ordner/Label) die dynamische Workload-Sub-Dim; die Prüf-Dock-Settings-Naht (`IResourceControllableTier`) ist bereits additiv vorhanden. | Load-Framework-Label über der bestehenden dyn. Workload-Sub-Dim (`experiment_run_entry.hpp:145`, `is_static=false` **bleibt** → binary_id-neutral). |

**Zusatz (4+1):** Compiler-System-Achse `gcc|clang` (GOAL-V6.2 Z.86, „golden-neutral"; Report 1). Reitet auf demselben `make_gpp_compile_fn`-Andockpunkt (CompileFn-Injektion, `build_orchestrator.hpp:466`); realisiert **nur** als System-Achse/Ordner-Etikett/Sidecar, **nie** als Segment in `serialize_composition_path`/`kCompositionAxisNames` (Report 4 W1). Diskrepanz zur LEDGER:86-„4er"-Formulierung siehe §7-Q3.

### (2c) Nachweis golden-Neutralität + ABI-4-Kompatibilität

**golden-neutral (binary_id nur aus 19 Organ-Achsen → System-Achsen orthogonal):**
- `axis_path_serialization.hpp:48` `serialize_composition_path<P>()` iteriert NUR über `P::variants` (19-Achsen-PermTuple) und indexiert `kCompositionAxisNames` (`:30`, `std::array<…,19>`). Andere Eingänge existieren nicht.
- golden-Format-Beleg (Report 4): jede der 320 ids hat exakt 19 Segmente; `grep -c "page_type|simd_extension|general_hardware|scheduling|system_axis"` auf `golden_fullpilot_320_binary_ids.txt` == 0.
- Additiv-orthogonaler Präzedenzfall existiert: `axis_path_serialization.hpp:88` `with_shape_segment<Shape>()` — Default `Shape=void` ⇒ Pfad byte-identisch (golden unberührt). Genau das Muster für eine neue orthogonale Schicht.
- Dynamische Dims ändern binary_id nie (`experiment_run_entry.hpp` `is_static=false`).
- ⇒ Solange keine System-Achse in `kCompositionAxisNames`/`P::variants` einfließt, bleibt golden == 320. **Belegt, kein Rateschluss.**

**ABI-4-kompatibel:**
- Die System-Wurzel ist header-only, liest nur bestehende Host-PODs, „Keine ABI-Erweiterung" (`system_axis.hpp:5`). Keine Änderung an `COMDARE_ANATOMY_ABI_MAJOR`(=4), an POD-1416 (`observable_tier.hpp:130`, `sizeof==1416` `:128`, `static_assert standard_layout` `:148` / `trivially_copyable` `:150`), an kV3AxisSchema (`:66`), an GenusBindingTraits (`container_framework.hpp`), an der Loader-vtable.
- Alt-DLLs bleiben ladbar (`host_compatible_with`, `anatomy_module_abi_v1_decl.hpp:106`: `major == module.major && module.minor <= minor`).

### (2d) CEB-System-Achsen-Versionierung (H-10-Metadaten) — Andockpunkt

- INC-1-Rahmen: die System-Achsen-Belegung wird in `build_version` (`build_orchestrator.hpp:62`) kodiert, damit eine unter anderer System-Achse gebaute CEB ein **eigenes** `.version`-Sidecar bekommt (`write_version_sidecar` `:175`), sonst falsches Skip via `dll_is_current` (`:170/:282`).
- Das Sidecar ist eine **Textdatei neben der .so** — ABI-neutral. **KEIN** AVX10-Feld an `BuildVariantDefinitionV1` und **KEIN** Feld an `ComdareTierObserverSnapshot` (das wäre ABI-4-Bruch = INC-2, Report 4 W2).

---

## (3) SCHRITTFOLGE als Mini-Increments (konservativ geschnitten)

**Prinzip** (Memory `feedback_e_schichten_separat_fertigstellen_top_down`, Task): erst die abstrakte System-Achsen-Wurzel + Concept, dann je Achse EINE, jede für sich golden==320 + ctest grün. Jedes Mini-Increment eigene literale, **lokal-doppelte** Verifikation: **ce-standalone build-conf** UND **super build-i2** (super-Sub-Build PFLICHT, nicht nur ce-standalone).

| Inc | Dateien (Änderungsskizze) | Verifikation (literal, lokal-doppelt) |
|---|---|---|
| **INC-1a** — Konfig-System-Achsen-Wurzel | **NEU** header `measurement/ceb_system_axis.hpp` (o.ä.): `CebSystemAxis<Derived>` (empty base) + `CebSystemAxisConcept` (analog `system_axis.hpp:148/183`, `IsaStrategyBase`-Muster). KEINE Verdrahtung in `build_all_axis_levels`. Reiner Rahmen. | ce-standalone build-conf grün + super build-i2 grün; ctest grün; golden==320 (unberührt, nichts an Serialisierung). `static_assert(CebSystemAxisConcept<…>)` compiliert. |
| **INC-1b** — `build_system_axis_levels()` abspalten | `registry_to_axis_levels.hpp:81` — strukturelle Abspaltung: neue `build_system_axis_levels()` gibt die System-Schicht (zunächst die 3 bereits binary_id-orthogonalen Build-only-Achsen T17/T18/T19) getrennt von den Organ+Dyn-Levels zurück. **Die 19 Organ-Segment-Strings + Reihenfolge dürfen NICHT verändert werden.** | golden-Roundtrip==320 **byte-identisch** (W3-Checkpoint, `profile_runner.hpp:107`); ctest grün; ce+super grün. |
| **INC-1c** — Scheduling-System-Achse | **NEU** `SchedulingSystemAxis<D> : CebSystemAxis<D>` (5 Enums aus `scheduling_strategy.hpp:36-45` als static-constexpr). Registrieren in `build_system_axis_levels()` als Ordner-Label (golden-neutral, NICHT in `kCompositionAxisNames`). `ISchedulingStrategy`-vtable bleibt DEPRECATED, **nicht gelöscht**. Kein vtable neu. | golden==320; ctest grün; ce+super grün; grep-Check: keine neue vtable (`CebSystemAxisConcept` `!is_polymorphic` hält). |
| **INC-1d** — Hardware-ISA + H-7 `-march`-Kopplung (+ Compiler +1) | **NEU** `HardwareIsaSystemAxis<D>`; `build_orchestrator.hpp:466/476` `make_gpp_compile_fn` um `-march`/`-mavx…` erweitern (Flag-Quelle analog `simd_flags()`, `permutation_codegen_tool.cpp:43-48`). Compiler `gcc\|clang` reitet auf CompileFn-Injektion (`:466`). **Vor Start W-C-Ruling einholen (§7-Q2).** | golden==320 (Flags berühren Serialisierung nicht); **build-Invarianz** (uint64-Akkumulation, phase01 VERIFIKATION SSE2/AVX2/AVX512 identisch); ctest grün; ce+super grün. |
| **INC-1e** — Telemetrie-RAHMEN | Nur Rahmen-Reflex: Mess-Telemetrie-System-Achse (`system_axis.hpp:192-332`) als Teil der abgespaltenen System-Schicht verankern. **Organ-Slot T10 (`registry_to_axis_levels.hpp:60/94`) UNBERÜHRT.** | golden==320 (T10 bleibt in `kCompositionAxisNames`, binary_id unverändert); ctest grün; ce+super grün. |
| **INC-1f** — Last/Last-Framework-System-Achse | **NEU** `LoadFrameworkSystemAxis<D>`; Framework-Wahl als Ordner-Label über der bestehenden dyn. Workload-Sub-Dim (`experiment_run_entry.hpp:145`, `is_static=false` **bleibt**). | golden==320 (workload bleibt dyn., binary_id-neutral); ctest grün; ce+super grün. |
| **INC-1g** — H-10 CEB-System-Achsen-Versionierung | `build_orchestrator.hpp:62` `build_version` um System-Achsen-Belegung erweitern; `write_version_sidecar` (`:175`) schreibt eigenes Sidecar je System-Achse. **KEIN POD-Feld, KEIN AVX10-Anhang** (Sidecar-Text). | Skip/Resume-Verhalten literal geprüft (`dll_is_current` `:170/:282`); golden==320; ctest grün; ce+super grün. |

**Konsolidierungs-Checkpoint** nach INC-1g: voller super-Sub-Build + golden-Roundtrip==320 + cf22==0 + Mojibake==0 + beide Remotes ref-gleich.

---

## (4) VERIFIKATIONS-PLAN (je Mini-Increment)

Pro Mini-Increment, in dieser Reihenfolge (Memory `reference_cache_engine_standalone_build_pipeline`, `feedback_ci_infra_blocked_proceed_local_double_verify_mode_a`):
1. **ctest** grün (ce-standalone, offizieller CMake/ctest-Weg — kein Behelf).
2. **golden-Roundtrip == 320** (`profile_runner.hpp:107` Round-Trip-Gate; INC-1b zusätzlich byte-identisch). Nie als Nullen — Mess-Fehler als CSV-„failed" + Log sichtbar (Memory `feedback_measurement_failure_visibility_csv_failed_not_null_plus_log`).
3. **cf22 == 0** (clang-format 22.1.8; `~/tools/cf22/usr/bin`, Memory `reference_ce_facade_super_subbuild_verify`).
4. **Mojibake == 0** (`grep -R "Ã\|â€"` == 0; Memory `reference_codex_utf8_mojibake_double_encoding`).
5. **super-Sub-Build PFLICHT** (build-i2, ~15 vendored Links; nicht nur ce-standalone).
6. **beide Remotes ref-gleich** (origin=gitlab / github=github; batch, Memory `feedback_all_projects_dual_remote_github_gitlab`) — **erst nach explizitem User-Bau-GO und granular** (keine Commits/Pushes in der Planungsphase; diese Direktive gilt für den Bau-Vollzug).

TABU-Objekte nach jedem Increment unberührt bestätigen (§5, T1–T8).

---

## (5) RISIKEN + ROLLBACK

**Harte TABU-Liste INC-1 (nicht anfassen; Report 4):**
- **T1** ABI-MAJOR==4 / Magic `.A4.` — `anatomy_module_abi_v1_decl.hpp:43/47`; `best_binary_selector.hpp:46`.
- **T2** POD-1416 `ComdareTierObserverSnapshot` — `observable_tier.hpp:130`, `sizeof==1416` `:128`, `static_assert standard_layout` `:148` / `trivially_copyable` `:150`.
- **T3** kV3AxisSchema (19×8) — `observable_tier.hpp:66`; Index-Freeze `container_attribution.hpp:53-55`.
- **T4** GenusBindingTraits<G> — `container_framework.hpp` (`AnatomyGattung` NUR 3, `anatomy_base.hpp:40`).
- **T5** serialize_composition_path / kCompositionAxisNames — `axis_path_serialization.hpp:30/48`.
- **T6** golden_fullpilot_320 / `CatalogAxes<4,4,5,4>=320` — `source_catalog.hpp:80/112`; Round-Trip-Gate `profile_runner.hpp:107`.
- **T7** permutation_axes.xml (read-only).
- **T8** Registry-mp_list (EnabledVendors) — nur additiv, Default-OFF.

| Risiko | Auslöser (datei:zeile) | Mitigation | Rollback |
|---|---|---|---|
| **R1 golden-Bruch** durch versehentliches Berühren der binary_id-Projektion | `serialize_composition_path`/`kCompositionAxisNames`/`P::variants` (`axis_path_serialization.hpp:30/48`); INC-1b-Umbau verändert 19 Organ-Segmente | golden-Roundtrip==320-Gate nach JEDEM Mini-Increment; INC-1b byte-identisch (W3); NIE eine System-/Compiler-Achse in `kCompositionAxisNames` (W1); `with_shape_segment`-Additiv-Muster nutzen | Working-Tree des betroffenen Increments verwerfen (keine Commits vor Grün) |
| **R2 ABI-4-Bruch** (gehört zu INC-2) | POD-Feld-Anhang (auch AVX10) an `observable_tier.hpp:130`/`build_variant_definition.hpp:17`; kV3AxisSchema-Umordnung; Major-Bump | TABU-Guard T1–T8; bestehende `static_assert` (standard_layout/trivially_copyable `:148/150`, Index-Freeze `container_attribution.hpp:53`) brechen den Build; H-10 nur als Sidecar-Text (W2) | Working-Tree verwerfen |
| **R3 vtable-Rückfall bei Scheduling** | Wieder-Einführung von Runtime-Polymorphie beim #37-Umbau | `CebSystemAxisConcept` (`is_empty && !is_polymorphic`) schlägt beim Kompilieren fehl; `ISchedulingStrategy` bleibt DEPRECATED & unkonsumiert (`scheduling_strategy.hpp:3`) | Working-Tree verwerfen |
| **R4 falsches DLL-Skip** durch stale `.version`-Sidecar | System-Achsen-Belegung nicht in `build_version` kodiert (`build_orchestrator.hpp:62`) | INC-1g kodiert Belegung in `build_version`; Skip/Resume literal geprüft (`:170/:282`) | Sidecar löschen + Rebuild |
| **R5 W-C-Fehlentscheid** (H-7 an 09b vs. Hardware-System-Achse) | Grenzfrage §7-Q2 | Ein-Zeilen-User-Ruling VOR INC-1d; konservativer Default dokumentiert | Working-Tree verwerfen |

---

## (6) NAHT ZU INC-2 (was INC-1 BEWUSST offen lässt — DER EINE koordinierte 4→5-Bump)

INC-1 legt NUR den compile-time-Schichtungs-Rahmen. Ausschließlich in **Bau-INC-2** (Magic `.A4.`→`.A5.`; §18.2.4; LEDGER:87):
- **4→5-ABI-Major-Bump**: `COMDARE_ANATOMY_ABI_MAJOR 5`, Magic `.A5.`, Loader verwirft alle ABI-4-DLLs.
- **Telemetrie-Herauslösung aus binary_id**: T10 raus aus `kCompositionAxisNames` → neue Achsen-Zahl → neues kV3AxisSchema → POD-1416-Layout-Bruch = ABI-Major-Bruch. INC-1 baut nur den Telemetrie-**Rahmen** (INC-1e), NICHT die Herauslösung (Report 4 W4).
- **Metadaten-Versionsfeld / AVX10-Feld**: POD-Erweiterung an `BuildVariantDefinitionV1` / neue Schema-Version = ABI-Bruch. INC-1 macht nur die Sidecar-Text-Versionierung (INC-1g).
- **Set-Ebene-1-Promotion** (Gattung 3→4): `AnatomyGattung` heute NUR 3 (`anatomy_base.hpp:40`, Set als Genus UNTER Container `:35`); + native ISetTier/Set-POD-V2/SetDock.
- **#37 Scheduling-vtable-ERSATZ**: die Deprecation-Faltung der Runtime-vtable in die 4→5-ABI-Grenze. INC-1 fügt nur die compile-time-Scheduling-System-Achse DANEBEN (INC-1c), ersetzt die vtable NICHT.
- **golden-Neubau messdaten-erhaltend** (golden_abi5 additiv; alt `…_abi4` einfrieren): **W3 STRUKTUR-OFFEN** — eigenes Bau-INC-3 vs. in 4→5 gefaltet (Report 2 W-D; LEDGER:87). Nicht INC-1-blockierend, aber VOR INC-2-Planung zu klären.

**Trennschärfe** (Report 1): Scheduling erscheint in beiden — INC-1 zieht die Scheduling-System-Achse compile-time ein (ABI-4-neutral, da nie konsumiert); die vtable-ERSETZUNG ist INC-2. H-7: der `-march`-Kopplungs-RAHMEN ist INC-1; die Metadaten-VERSIONS-Bruch-Kopplung ist INC-2.

---

## (7) OFFENE DETAILFRAGEN AN DEN USER (nur ECHT offene nach Doktrin-Check)

**Doktrin-Check-Ergebnis:** Die 3 kritischsten Design-Punkte aus Bauplan-INC0 §6 sind **bereits entschieden** (Report 2 bestätigt):
- (1) strikte E4→E0-Trennung Organ vs. System, eigene abstrakte Wurzel/„Blut" → **ENTSCHIEDEN** (Doktrin + LEDGER:86 + VOLLES GO).
- (2) Q2 Scheduling = compile-time CRTP+Concept-System-Achse (kein Runtime-Switch) → **ENTSCHIEDEN** (§19.A Q2, GOAL-V6.2).
- (3) Q5 H-7 `-march`/`-mavx` koppelt an neue Metadaten-Version → **ENTSCHIEDEN als Split** (Version-Bump = INC-2; `-march`-Rahmen = INC-1).

Ebenfalls durch Report-Evidenz entschieden (NICHT offen): welche 4 (Report 2 W-A: neuere KONSTRUKTIONSLOGIK 07-17 = {Telemetrie, Hardware/ISA, Scheduling, Last} ist autoritativ, NUMA=Hardware-Sub-Achse, Locking=Organ-axis_08); #37 = System-Achse, nicht 27. Organ-Permutation (W-B, neuere Fassung supersediert).

**Echt offene Detailfragen (mit konservativem Default):**

- **Q1 — Wurzel-Wahl der Konfig-System-Achsen:** neue Geschwister-Wurzel `CebSystemAxis<Derived>` (empfohlen) vs. Wiederverwendung der Mess-`SystemAxis<Derived>`? Kein Report entscheidet dies explizit; f4-A dokumentiert nur, dass die Registry-16 reine Mess-Kategorien sind und die 4 Konfig-Achsen keine Verankerung haben. **Konservativer Default: neue Geschwister-Wurzel** (überlädt die Mess-Semantik nicht; erfüllt „own root per layer"). — 1-Zeilen-Ruling genügt.
- **Q2 — W-C H-7-Aufhängung:** hängt die `-march`-Kopplung formal an der Build-ISA-Organ-Achse (09b/simd_extension) oder an der Hardware-System-Achse? Report 2 markiert dies als „in INC-1 zu entscheiden". **Konservativer Default: Flag-Quelle = Build-ISA (09b), Hardware-System-Achse = reiner Host-Deskriptor/Mess-Gate** (e18-konsistent). — Ruling VOR INC-1d nötig.
- **Q3 — Compiler `gcc|clang` als 4+1:** GOAL-V6.2 Z.86 nennt ihn als 5. Pflicht-System-Achse (Report 1); LEDGER:86 listet nur 4 (Report 4). **Konservativer Default: als golden-neutraler 4+1-Begleiter behandeln**, der auf demselben CompileFn-Andockpunkt reitet, realisiert nur als Ordner-Label/Sidecar. — Bestätigung erwünscht.

*(Q4/Q5 nicht INC-1-blockierend: W-D golden-Materialisierung INC-3-vs-4→5 → vor INC-2 klären; W-E NUMA/Page→allocator-Reifegrad → nicht INC-1-kritisch.)*

---

## Bei Widersprüchen zwischen Reports — konservative Empfehlungen (zusammengefasst)
- **W-A (welche 4):** neuere KONSTRUKTIONSLOGIK 07-17 autoritativ → {Telemetrie, Hardware/ISA, Scheduling, Last}; NUMA=Hardware-Sub, Locking=Organ. Konservativ: exakt die 4 des Tasks bauen.
- **W-B (#37 Organ vs System):** System-Achse (neuere Fassung supersediert); ABI-brechender Teil = INC-2.
- **W-C (H-7 an 09b vs Hardware-System-Achse):** → §7-Q2, Default Flag-Quelle = 09b.
- **Compiler 4 vs 5:** → §7-Q3, Default 4+1.
- **W-D (golden-Materialisierung):** nicht INC-1-blockierend; vor INC-2 klären.
