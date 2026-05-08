# UML — Hardware/ISA + Flag-System + PlatformProbe (Block AO)

**Bezug:**
- ADR F4 (Permutationsraum + ISA-Filter via CMake compile-time)
- ADR F9 (ABI-Stabilitaet via C++23-Modules; Compile-Time UND Runtime-Detection)
- ADR F10-K (Strukturiertes Flag-System nach CPUID-Vorbild, Bank pro Achse)
- ADR F13 (Cross-Compilation + ZIH-Lieferung + CI/CD)
- Block AO (Production-Plattform: Ryzen 9 9950X3D + i9-14900KS, 64 GB DDR5-5600 CL36)
- Flag_System.txt (Bank-Layout pro Achse mit Bit-Belegung)

---

## 1. PlatformProbe (F9 dual-mode)

```
class PlatformProbe <<runtime detection>> {
    -- Methoden --
    + detect() : PlatformProfile
    ' Compile-Time: Build-Flag steuert Auswahl
    ' Runtime: CPUID/sysfs/proc-Auswertung

    -- Attribute --
    - cpu_model_string : string  ' z.B. "AMD Ryzen 9 9950X3D"
    - cpu_class : enum {ZEN5_X3D, RAPTOR_LAKE_HYBRID, GRACE_HOPPER, ARM_PI5, ARM_VISIONFIVE2, OTHER}
    - cache_topology : CacheTopology
    - isa_features : IsaFlagBank
    - cores_layout : CoreLayout
}

class CacheTopology {
    + l1_data_bytes : size_t
    + l1_inst_bytes : size_t
    + l2_per_core_bytes : size_t
    + l3_total_bytes : size_t
    + l3_asymmetric : bool   ' Ryzen 9950X3D X3D-V-Cache (96+32 MiB)
    + l3_per_ccd : map<CcdId, size_t>
}

class CoreLayout {
    + p_core_ids : vector<CoreId>   ' Intel Hybrid P-Cores
    + e_core_ids : vector<CoreId>   ' Intel Hybrid E-Cores
    + total_cores : int
    + total_threads : int
}

class IsaFlagBank {
    + sse2 / sse4_1 / sse4_2 : bool
    + avx / avx2 / avx512f / avx512vl / avx512bw : bool
    + bmi1 / bmi2 / aesni / popcnt : bool
    + neon / sve / sve2 : bool   ' ARM
    + risv_v : bool              ' RISC-V V-Extension
}

class PlatformProfile <<value>> {
    + cpu_class : CpuClass
    + cache_topology : CacheTopology
    + isa_features : IsaFlagBank
    + cores_layout : CoreLayout
    + memory_latency_cycles : int
    + sig() : PlatformSignature  ' deterministischer Hash
}
```

## 2. F10-K — PermutationFlags + Bank-Layout (Flag_System.txt)

```
class PermutationFlags <<value>> <<F10-K>> {
    ' Eine Bank pro Achse, je 64 Bit
    + page_bank          : uint64_t
    + node_bank          : uint64_t
    + traversal_bank     : uint64_t
    + value_handle_bank  : uint64_t
    + memory_layout_bank : uint64_t
    + allocator_bank     : uint64_t
    + prefetch_bank      : uint64_t
    + concurrency_bank   : uint64_t
    + isa_bank           : uint64_t
    + telemetry_bank     : uint64_t  <<NEU 2026-05-09>>
    + to_identifier() const noexcept : string_view
    + is_valid_combination() const noexcept : bool
}

namespace comdare::flags {
    struct PageBank {
        constexpr uint64_t DENSEBYTE_ART256        = 1ULL << 0
        constexpr uint64_t SPARSE_NODE4_ART        = 1ULL << 1
        constexpr uint64_t COMPOUND_HOT            = 1ULL << 2
        constexpr uint64_t MULTIBYTE_START         = 1ULL << 3
        constexpr uint64_t MACRO_COCO              = 1ULL << 4
        constexpr uint64_t DECISION_B2TREE         = 1ULL << 5
        constexpr uint64_t LOUDS_DENSE_SURF        = 1ULL << 6
        constexpr uint64_t LOUDS_SPARSE_SURF       = 1ULL << 7
        ...
        constexpr uint64_t PRTART_DENSEBYTE        = 1ULL << 56
    }

    struct IsaBank {
        constexpr uint64_t SCALAR_X86_64           = 1ULL << 0
        constexpr uint64_t SCALAR_ARM64            = 1ULL << 1
        constexpr uint64_t SCALAR_RISCV            = 1ULL << 2
        constexpr uint64_t X86_SSE2                = 1ULL << 3
        constexpr uint64_t X86_SSE4_2              = 1ULL << 4
        constexpr uint64_t X86_AVX2                = 1ULL << 5
        constexpr uint64_t X86_AVX512F             = 1ULL << 6
        constexpr uint64_t X86_BMI2                = 1ULL << 7
        constexpr uint64_t ARM_NEON                = 1ULL << 8
        constexpr uint64_t ARM_SVE                 = 1ULL << 9
        constexpr uint64_t ARM_SVE2                = 1ULL << 10
        constexpr uint64_t RISCV_V                 = 1ULL << 11
    }
    /* ... weitere Banks analog ... */
}
```

## 3. ConstraintFilter (F4 ISA-Filter)

```
class ConstraintFilter <<compile-time>> <<F4>> {
    + is_consistent(flags : PermutationFlags) : constexpr bool
    ' Beispiele:
    ' AVX-512-Bit nur wenn Target X86_AVX512F unterstuetzt
    ' NEON-Bit nur auf ARM
    ' LeafOnlyCounter erfordert RetroactiveAggregation (Block AJ)
    ' ART-Page erfordert ART-Node-Familie
    ' B2Tree-Page erfordert MEMORY_EMBEDDED_TREE-Layout
}
```

## 4. Block AO — Production-Plattform-spezifika

### Ryzen 9 9950X3D (Zen 5, X3D-V-Cache)

```
class RyzenX3DProbe <<extends PlatformProbe>> {
    -- Spezifika --
    + ccd_count : 2
    + v_cache_ccd : CcdId         ' bevorzugt CCD0 mit 96 MiB V-Cache
    + standard_ccd : CcdId        ' CCD1 mit 32 MiB Standard-L3
    -- Methoden --
    + detect_v_cache() : bool
    + recommend_pinning() : CpuPinningPolicy
    ' "V_CACHE_CCD" fuer Hot-Path-Threads
}
```

### Intel i9-14900KS (Raptor Lake Refresh, Hybrid-CPU)

```
class IntelHybridProbe <<extends PlatformProbe>> {
    -- Spezifika --
    + p_core_count : 8
    + e_core_count : 16
    -- Methoden --
    + detect_hybrid() : bool
    + recommend_pinning() : CpuPinningPolicy   ' "P_CORE" fuer Hot-Path
    + perf_event_separation() : bool           ' cpu_core/* vs cpu_atom/*
}
```

## 5. F13 — Cross-Compile-Toolchain

```
class CrossCompileToolchain {
    + target_platform : PlatformClass
    + main_compiler : CompilerInfo  ' immer C++23
    + bauteil_compilers : map<BausteinId, CompilerInfo>
    + build(specs : vector<ModuleSpec>) : ExitCode
}

class DeliveryDriver {
    -- F13: SOCKS5 (default) + GitLab-CI-Push (Erweiterung) --
    + deliver_socks5(target : path) : ExitCode  ' default fuer ZIH
    + deliver_gitlab_ci(target : path) : ExitCode
}
```

## 6. drawio-Tab-Struktur

| Tab | Inhalt |
|-----|--------|
| 04-A | PlatformProbe + PlatformProfile |
| 04-B | PermutationFlags + Bank-Layout (CPUID-Vorbild, F10-K) |
| 04-C | ConstraintFilter + ISA-Filter (F4) |
| 04-D | Block AO Plattform-Spezifika (X3D + Hybrid-CPU) |
| 04-E | Cross-Compile + Delivery (F13) |
