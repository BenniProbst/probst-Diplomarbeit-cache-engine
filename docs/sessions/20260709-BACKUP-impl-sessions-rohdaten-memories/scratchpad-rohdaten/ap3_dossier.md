# DOSSIER AP-3/#237 — IPlatformProbe implementieren + HardwareFilter/Phase-1 verdrahten (ABI-NEUTRAL)

> Für Codex (`--sandbox workspace-write`, `model_reasoning_effort=xhigh`). Arbeite DIREKT als EIN
> Agent — KEINE Sub-Agenten/Orchestrator/collab-Route. Setze §6 vollständig um, halte §4 strikt ein,
> verifiziere §7 lokal (Kommandos + literale Ergebnisse), gib §8-Report aus. **NICHT committen, KEINE
> git-Operationen** — nur Dateien editieren; Claude reviewt jede Datei manuell + committet selbst.

## 1. Auftrag (eine Zeile)
Implementiere die bestehende `IPlatformProbe`-Schnittstelle real (CPUID auf Windows/x86, sysfs bzw.
/proc/cpuinfo auf Linux) und verdrahte sie in den HardwareFilter/Phase-1 (#650) — ABI-neutral, host-seitig.

## 2. Fachliche Substanz
Der Prüf-Dock/Builder muss die reale Host-Plattform ehrlich erkennen (CPU-Vendor/Family/Model, ISA-
Features SSE2/AVX/AVX2/AVX-512, ggf. Cache-Größen, Core-Topologie), damit HardwareFilter/Phase-1
entscheidet, WELCHE Binaries/Bausteine auf DIESER HW lauffähig/messbar sind (z.B. AVX-512-Binary nur
auf AVX-512-fähiger HW). Bisher ist das ein Stub/hardkodiert → ehrliche Laufzeit-Erkennung statt Fiktion.

## 3. Scope-Abgrenzung (HART)
- **IN (AP-3):** `IPlatformProbe`-Implementierung (mind. Windows-x86-CPUID real; Linux-Pfad real ODER
  sauber OS-guarded mit klarem Fallback) + HardwareFilter/Phase-1-Verdrahtung + Host-Smoke-Test.
- **OUT (markieren `// AP-3-Follow:`):** vollständige ARM/NEON-Erkennung (falls nur x86-Host testbar);
  P/E-Core-Pinning (= AP-13, TABU); 3-ISA-Build-Matrix (= AP-13/AP-247).

## 4. HARTE Auflagen (Verstoß = Abbruch, Claude verwirft)
1. **ABI-NEUTRAL:** `COMDARE_ANATOMY_ABI_MAJOR` bleibt **4**. IPlatformProbe ist eine HOST-seitige
   Build-/Filter-Komponente (NICHT im Tier-Modul-ABI). KEINE Änderung an extern-C
   (`anatomy_module_abi_v1_decl.hpp`), vtable (`idriveable_tier.hpp`), Mess-POD (`observable_tier.hpp`).
2. **TABU (nicht mutieren):** `modules/**`, `ext/**`, golden-/Registry-`mp_list`-Dateien, **UND die
   AP-13-Dateien** (`platform/core_layout.hpp`, Pinning-/Affinity-Header). AP-3 ist Single-Owner
   `platform/` NUR für die Probe-Dateien — `core_layout.hpp`/Pinning gehört AP-13 (nach AP-3 rebasen).
   Falls Probe + core_layout dieselbe Datei teilen: NUR den Probe-Teil anfassen, den Layout-Teil unberührt.
3. **OS-PORTABEL + EHRLICH:** Windows-Pfad via `__cpuid`/`__cpuidex` (`<intrin.h>`), Linux-Pfad via
   inline-asm/`__get_cpuid` bzw. /proc/cpuinfo/sysfs — sauber per `#ifdef _WIN32`/`__linux__` gesplittet.
   Wo eine Plattform NICHT ehrlich erkannt werden kann: klarer Fallback/`unknown`-Status + Kommentar,
   NIEMALS erfundene/hardkodierte Feature-Werte. Muster spiegeln von der PMC-OS-Guard-Vorlage (#153,
   WindowsPcmPmcSource + COMDARE_ENABLE_PMC).
4. **Stil:** umgebenden Code-Stil/Namens-/Kommentar-Dichte spiegeln. Namespace `comdare::*`, C++23,
   keine neuen externen Abhängigkeiten (nur Compiler-Intrinsics/OS-Header).

## 5. Kartierung (file:line — verifiziert Explore+Codex+Claude)
- **5.1 Interface:** `libs/cache_engine/include/cache_engine/platform/i_platform_probe.hpp` — reines Interface,
  Namespace `comdare::cache_engine::platform`. `:14` `struct PlatformPropertySet` (bool-Flags `has_asymmetric_l3/
  has_hybrid_cores/has_hbm_tier/has_software_prefetch/has_hardware_transactional/cpu_core_atom_perf_separation`,
  `:21` `preferred_pinning_policy`, `:22` `usable_simd_width_bytes`, `:23` `std::map<string,double> measured_metrics`).
  `:27` `class IPlatformProbe` → `:32` `virtual PlatformPropertySet discover_and_measure() = 0;`.
  (Fein-Infos in `isa_features.hpp:42` IIsaFeatureSet, `cache_topology.hpp` — NUR lesen, nicht Pflicht für AP-3.)
- **5.2 Probe (existiert, macht echtes CPUID):** `libs/cache_engine/include/cache_engine/platform_probe/cpuid_probe.hpp`
  — Namespace `comdare::cache_engine::platform_probe` (≠ platform!). `:72` `inline CpuidProbeResults probe_cpuid()`
  (freie Funktion → `CpuidProbeResults` `:25` mit vendor/brand/sse2/avx/avx2/avx512f/bmi/popcnt/neon/... + cache_line);
  `:51` `cpuid()` OS-geguardet (`:54` MSVC `__cpuidex` via `<intrin.h>`, `:62` GCC/Clang asm; `:117` ARM/RISC-V-Fallback).
  **FEHLT:** `class : public platform::IPlatformProbe` (Brücke Probe→Interface) — das ist der Kern von AP-3.
- **5.3 Verdrahtungs-Stelle (#650):** `libs/cache_engine/builder/commands/auto_permutator.hpp:58-63` `void platform_filter()`
  = LEERER STUB (Kommentar "IPlatformProbe-Verdrahtung in V32.2+ / pro Variant: pruefe supports(variant); setze
  host_compatible"). `:25` `struct AxisVariant` mit `:29` `bool host_compatible{true}` (Default filtert nichts) +
  `variant_name`. `:74` `generate_permutations()` konsumiert `host_compatible && user_allowed`; `:132`
  `discover_all()` ruft `platform_filter()`. **Codex: exakte AxisVariant-Felder + variant_name-Werte selbst lesen.**
- **5.4 AP-13-Abgrenzung:** `platform/core_layout.hpp` (ICoreLayout/IPinningPolicy = Pinning) = **AP-13, NUR includieren,
  NIE editieren**. `live_platform_model.hpp:6` inkludiert core_layout — nicht anfassen. PlatformPropertySet-Felder
  `has_hybrid_cores/cpu_core_atom_perf_separation/preferred_pinning_policy` in AP-3 **unbefüllt/false lassen** (AP-13).
- **5.5 OS-Split-Vorlage:** `libs/cache_engine/builder/pmc_source_factory.hpp:29` `make_pmc_source()` = die EINE
  OS-Diskriminierungsstelle (`_WIN32`→Windows, `__linux__`→Linux, sonst NullPmcSource) — Muster für `make_platform_probe()`.
- **5.6 ABI-neutral:** PlatformPropertySet/CpuidProbeResults nutzen std::string/map/vector → nicht extern-C, nicht
  POD-über-DLL, kein Bestandteil des Mess-POD → `COMDARE_ANATOMY_ABI_MAJOR` (abi_v1_decl.hpp:43) unberührt. Präzedenz
  `pmc_source.hpp:6` ("Drop-in, keine POD/Pipeline-Änderung").
- **5.7 Test-Vorlage:** `tests/unit/test_cpuid_probe.cpp` (gtest: DoesNotCrash/VendorIsSensible/CacheLineBytesIsValid/
  AlderLakeHasAvx2NotAvx512), registriert `tests/unit/CMakeLists.txt:69-71` (`comdare_add_test ... LIBRARIES
  comdare::cache_engine_concepts`).

## 6. Soll-Umsetzung (konkret — Windows-Host-Pfad; alles im Haupt-Repo, kein Submodul)
1. **NEU** `libs/cache_engine/include/cache_engine/platform_probe/cpuid_platform_probe.hpp` (additiv, header-only):
   `class CpuidPlatformProbe final : public platform::IPlatformProbe` → `discover_and_measure()` ruft
   `platform_probe::probe_cpuid()` und mappt `CpuidProbeResults → PlatformPropertySet`:
   `usable_simd_width_bytes = avx512f ? 64 : (avx2 ? 32 : 16)`; `has_software_prefetch = true` (x86);
   `measured_metrics` optional (vendor/feature-Flags als Diagnose-Einträge). AP-13-Felder
   (`has_hybrid_cores`/`cpu_core_atom_perf_separation`/`preferred_pinning_policy`) NICHT setzen (Default/false,
   Kommentar `// AP-13: Topologie/Pinning`). Beide Namespaces sauber ziehen (platform + platform_probe).
   Optional Factory `make_platform_probe()` streng nach `pmc_source_factory.hpp:29`-Muster (_WIN32 real, sonst honest-null/x86-Fallback).
2. **Edit** `builder/commands/auto_permutator.hpp` `platform_filter()` (:58-63): Probe EINMAL instanziieren
   (`CpuidPlatformProbe`), `PlatformPropertySet ps = probe.discover_and_measure()`; pro `AxisVariant` das nötige
   ISA-Merkmal aus `variant_name` ableiten (z.B. „AVX512"→`ps.usable_simd_width_bytes>=64`, „AVX2"→`>=32`; Nicht-ISA-
   Varianten bleiben `host_compatible=true`) und `v.host_compatible` setzen. `#include` des neuen Bridge-Headers.
   **Exakte variant_name-Konvention aus dem Header ablesen** (nicht raten); kein Merkmal → kompatibel lassen (ehrlich).
3. **Edit** `tests/unit/test_cpuid_probe.cpp`: + Test `CpuidPlatformProbeYieldsSanePropertySet` (`discover_and_measure()`:
   `usable_simd_width_bytes >= 16` auf x86, `has_software_prefetch==true`) + optional Filter-Smoke (AVX512-Variant wird
   auf Host ohne avx512f verworfen). Keine CMake-Änderung nötig (test_cpuid_probe bereits registriert), es sei denn der
   Bridge-Header braucht einen zusätzlichen Include-Pfad — dann minimal ergänzen.
**BEWUSST ausgeklammert (`// AP-3-Follow:` / AP-13):** Linux-sysfs L1/L2/L3-Größen; NEON/ARM/RISC-V über Fallback hinaus;
P/E-Core-Topologie + physical/logical_cores-Befüllung (AP-13 core_layout); die compile-time `axis_12_general_hardware_registry.hpp`
`AllPlatforms/EnabledPlatforms`-mp_list (golden/TABU) — Runtime-Filter NUR in auto_permutator.hpp.

## 7. Verifikation (PFLICHT — Codex, Kommandos + literale Ergebnisse)
- Kompiliert die Probe + HardwareFilter + Smoke-Test sauber (cmake-Target + Exit-Status).
- Baut+läuft den Host-Smoke-Test → Probe liefert SANE Werte auf DIESEM Host (z.B. AVX2 vorhanden,
  vendor nichtleer, family>0) → PASS (literal). Kein Commit.

## 8. Ausgabe an Claude (strukturiert)
(a) neue+geänderte Dateien (Liste, je Datei was), (b) welche Plattform-Infos real erkannt werden +
OS-Split, (c) ABI-Neutralität (MAJOR/vtable/POD/extern-C unverändert) + AP-13-Abgrenzung (core_layout
unberührt), (d) HardwareFilter-Verdrahtung, (e) Compile-/Smoke-Test-Ergebnisse literal, (f) Follow-ups
(ARM/NEON, AP-13-Pinning) offen markiert.
