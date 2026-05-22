#pragma once
// V33.E.4 (2026-05-21) - HardwareFilter: Tupel-Filter gegen Host-Capabilities
//
// @subsystem MessungDriver
// @phase_owner MessungDriver
//
// Q.1-Akzeptanz-Kriterium: messung_driver filtert Datasets gegen verfuegbare Hardware.
//
// Wenn ein Tupel <hardware_strategy><simd>AVX512</simd></hardware_strategy> verlangt,
// aber der Host nur AVX2 unterstuetzt, wird der Tupel uebersprungen.
//
// Header-only, keine Dependencies. Echte IPlatformProbe-Verdrahtung folgt V34+.

#include <algorithm>
#include <array>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::diplomarbeit::messung_driver::v32 {

/// V35.B.2 — Compiler-Family (Achse 15.1)
enum class CompilerFamily { Unknown, GCC, Clang, AppleClang, MSVC };

/**
 * @brief HostCapabilities - Auswahl an Hardware-Faehigkeiten des Hosts
 * @subsystem MessungDriver
 *
 * Wird typischerweise via IPlatformProbe ermittelt (cache-engine V31).
 * Hier vereinfacht als Compile-time bzw. constructor-init Wert.
 */
struct HostCapabilities {
    bool supports_avx2 {false};
    bool supports_avx512 {false};
    bool supports_neon {false};
    bool supports_sve2 {false};
    bool numa_available {false};
    bool huge_pages_2mb {false};
    bool huge_pages_1gb {false};
    std::size_t num_p_cores {0};
    std::size_t num_e_cores {0};

    /// V35.B.2 — Compiler-Family (Achse 15.1) erfasst beim Build dieses Binaries
    CompilerFamily compiler_family {CompilerFamily::Unknown};

    /// Default-Konstruktor mit konservativen Annahmen (alles false ausser scalar)
    constexpr HostCapabilities() noexcept = default;

    /// Compile-time bekannte Capabilities (z.B. via Build-Flags injiziert)
    static HostCapabilities detect_compile_time() noexcept {
        HostCapabilities hc;
#if defined(__AVX2__)
        hc.supports_avx2 = true;
#endif
#if defined(__AVX512F__)
        hc.supports_avx512 = true;
#endif
#if defined(__ARM_NEON)
        hc.supports_neon = true;
#endif
#if defined(__ARM_FEATURE_SVE2)
        hc.supports_sve2 = true;
#endif
        // V35.B.2 — Compiler-Detection
#if defined(__clang__) && defined(__APPLE_CC__)
        hc.compiler_family = CompilerFamily::AppleClang;
#elif defined(__clang__)
        hc.compiler_family = CompilerFamily::Clang;
#elif defined(__GNUC__)
        hc.compiler_family = CompilerFamily::GCC;
#elif defined(_MSC_VER)
        hc.compiler_family = CompilerFamily::MSVC;
#endif
        return hc;
    }
};

/// V35.B.2 — Compiler-Family string conversion
[[nodiscard]] inline std::string_view compiler_family_name(CompilerFamily f) noexcept {
    switch (f) {
        case CompilerFamily::GCC:        return "GCC";
        case CompilerFamily::Clang:      return "Clang";
        case CompilerFamily::AppleClang: return "AppleClang";
        case CompilerFamily::MSVC:       return "MSVC";
        case CompilerFamily::Unknown:    return "Unknown";
    }
    return "Unknown";
}

/**
 * @brief HardwareRequest - Hardware-Strategie aus messreihen.xml `<hardware_strategy>`
 * @subsystem MessungDriver
 */
struct HardwareRequest {
    std::string simd;                ///< z.B. "AVX2", "AVX512", "Scalar", "NEON", "SVE2"
    std::string cache_level;         ///< z.B. "L1Aware", "L2Aware", "L3Aware", "HBMAware"
    std::string numa;                ///< z.B. "Local", "Interleave", "Preferred", "Bind"
    std::string prefetch_distance;   ///< z.B. "PrefetchT0", "PrefetchT1", "PrefetchNTA"
    std::string atomic_granularity;  ///< z.B. "CAS_64", "CAS_128", "LL_SC"

    [[nodiscard]] bool empty() const noexcept {
        return simd.empty() && cache_level.empty() && numa.empty()
            && prefetch_distance.empty() && atomic_granularity.empty();
    }
};

/**
 * @brief CompilerRequest - Compiler-Strategie aus messreihen.xml `<compiler_strategy>` (V35.B)
 * @subsystem MessungDriver
 *
 * Achse 15: 15.1 family, 15.2 opt_level, 15.3 lto, 15.4 pgo, 15.5 target_arch.
 */
struct CompilerRequest {
    std::string family;          ///< "GCC", "Clang", "AppleClang", "MSVC"
    std::string opt_level;       ///< "O0".."O3", "Ofast", "MSVC_Od", "MSVC_O1", "MSVC_O2"
    std::string lto;             ///< "None", "ThinLTO", "FullLTO", "MSVC_LTCG"
    std::string pgo;             ///< "None", "Generate", "Use", "SamplePGO"
    std::string target_arch;     ///< "native", "x86-64-v3", "x86-64-v4", "znver4", "armv9-a", "generic"

    [[nodiscard]] bool empty() const noexcept {
        return family.empty() && opt_level.empty() && lto.empty()
            && pgo.empty() && target_arch.empty();
    }
};

/**
 * @brief FilterDecision - Ergebnis des HardwareFilter
 * @subsystem MessungDriver
 */
struct FilterDecision {
    enum class Verdict { Pass, Skip };
    Verdict verdict {Verdict::Pass};
    std::string reason;  ///< Begruendung wenn Skip
    [[nodiscard]] bool passes() const noexcept { return verdict == Verdict::Pass; }
};

/**
 * @brief HardwareFilter - Pruefe Tupel gegen Host-Capabilities
 * @subsystem MessungDriver
 *
 * Akzeptiert Tupel wenn Host die geforderte SIMD-Family unterstuetzt.
 * Empty HardwareRequest -> immer pass.
 */
class HardwareFilter {
public:
    explicit HardwareFilter(HostCapabilities host) noexcept : host_{host} {}

    [[nodiscard]] FilterDecision evaluate(const HardwareRequest& req) const {
        if (req.empty()) {
            return {FilterDecision::Verdict::Pass, "no hardware constraints"};
        }

        if (!req.simd.empty()) {
            if (req.simd == "AVX2" && !host_.supports_avx2) {
                return {FilterDecision::Verdict::Skip, "AVX2 required but host lacks it"};
            }
            if (req.simd == "AVX512" && !host_.supports_avx512) {
                return {FilterDecision::Verdict::Skip, "AVX512 required but host lacks it"};
            }
            if (req.simd == "NEON" && !host_.supports_neon) {
                return {FilterDecision::Verdict::Skip, "NEON required but host lacks it"};
            }
            if (req.simd == "SVE2" && !host_.supports_sve2) {
                return {FilterDecision::Verdict::Skip, "SVE2 required but host lacks it"};
            }
            // Scalar ist immer verfuegbar.
        }

        if (!req.numa.empty() && req.numa != "Local" && !host_.numa_available) {
            return {FilterDecision::Verdict::Skip,
                "NUMA strategy '" + req.numa + "' requires NUMA support"};
        }

        // Cache-Level + Prefetch + Atomic-Granularity sind Soft-Constraints (kein Skip)
        return {FilterDecision::Verdict::Pass, "all constraints satisfied"};
    }

    /// V35.B.3 — Compiler-Filter (Achse 15.1 family + 15.5 target_arch)
    /// Soft-Filter: prueft nur ob die geforderte Family auf dem Host verfuegbar ist.
    /// LTO/PGO/OptLevel sind reine Compile-Time-Konfigurationen und werden hier nicht gefiltert.
    [[nodiscard]] FilterDecision evaluate(const CompilerRequest& req) const {
        if (req.empty()) {
            return {FilterDecision::Verdict::Pass, "no compiler constraints"};
        }
        if (!req.family.empty()) {
            const auto host_family_name = compiler_family_name(host_.compiler_family);
            if (req.family != host_family_name) {
                return {FilterDecision::Verdict::Skip,
                    "compiler '" + req.family + "' requested but host built with '"
                    + std::string(host_family_name) + "'"};
            }
        }
        if (req.target_arch == "armv9-a" && !host_.supports_neon) {
            return {FilterDecision::Verdict::Skip,
                "target_arch 'armv9-a' requires ARM host but x86-Detection fehlt NEON"};
        }
        if (req.target_arch == "x86-64-v4" && !host_.supports_avx512) {
            return {FilterDecision::Verdict::Skip,
                "target_arch 'x86-64-v4' requires AVX-512"};
        }
        // OptLevel / LTO / PGO sind Compile-Time-only -> kein Skip
        return {FilterDecision::Verdict::Pass, "compiler constraints satisfied"};
    }

    [[nodiscard]] const HostCapabilities& host() const noexcept { return host_; }

private:
    HostCapabilities host_;
};

}  // namespace comdare::diplomarbeit::messung_driver::v32
