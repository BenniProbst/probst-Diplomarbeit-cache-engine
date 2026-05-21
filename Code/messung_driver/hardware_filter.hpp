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
        return hc;
    }
};

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

    [[nodiscard]] const HostCapabilities& host() const noexcept { return host_; }

private:
    HostCapabilities host_;
};

}  // namespace comdare::diplomarbeit::messung_driver::v32
