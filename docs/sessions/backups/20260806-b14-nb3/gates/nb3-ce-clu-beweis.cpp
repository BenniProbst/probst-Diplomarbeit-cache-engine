// B14-NB3 BEWEIS-TU (temporaer) -- GESCHWISTER-BEFUND: observe_scan zaehlte cache_lines_touched mit dem
// Literal 64 statt mit der Line der cacheline-Unterachse. cache_lines_touched ist eine MESSGROESSE
// (Observer-Statistik -> CSV), also dieselbe Klasse wie der Lead-Befund, nur ein Zaehler weiter.
//
// (1) BYTE-NEUTRALITAET am Achsen-Default: die Zahl ist identisch zur Alt-Formel ceil(n*rs/64).
// (2) SCHAERFE: mit einer permutierten Line folgt der Zaehler ihr (Alt-Stand: immer derselbe Wert).
#include <axes/cacheline/cacheline_config.hpp>
#include <axes/cacheline/cacheline_line_bytes.hpp>
#include <axes/layout/axis_05_memory_layout_cache_line_aligned.hpp>
#include <axes/layout/axis_05_memory_layout_observable.hpp>
#include <axes/layout/axis_05_memory_layout_strategy_base.hpp>
#include <axes/layout/axis_05_memory_layout_subaxes_hm1_to_hm4.hpp>

#include <cstddef>
#include <cstdint>
#include <iostream>
#include <string_view>
#include <type_traits>
#include <vector>

namespace cl = ::comdare::cache_engine::cacheline;
namespace ml = ::comdare::cache_engine::layout;

template <cl::CacheLineSize S>
struct ProbeCla : ml::MemoryLayoutStrategyBase<ProbeCla<S>, cl::CacheLineConfig{S}> {
    using topic_tag = ::comdare::cache_engine::memory_layout::concepts::MemoryLayoutTopicTag;
    using axis_tag  = ml::subaxes::alignment_strategy_tag;
    using family_id = std::integral_constant<int, 1>;

    static constexpr bool             enabled      = true;
    static constexpr std::string_view algo_version = "probe";

    [[nodiscard]] static constexpr std::size_t      cache_line_size() noexcept { return 64; }
    [[nodiscard]] static constexpr std::string_view name() noexcept { return "probe_cla"; }
    [[nodiscard]] static constexpr std::string_view family_name() noexcept { return "ProbeCla"; }
    [[nodiscard]] static constexpr std::string_view flag_suffix() noexcept { return "PROBE"; }
    [[nodiscard]] static constexpr ml::RepresentationKind representation_kind() noexcept {
        return ml::RepresentationKind::aos_interleaved_padded;
    }
    [[nodiscard]] static std::uint64_t scan_field_sum(unsigned char const* buf, std::size_t n,
                                                      std::size_t record_size) noexcept {
        return ml::detail::padded_aos_field_sum(buf, n, record_size, ProbeCla::cacheline_subaxis_line_bytes());
    }
};

static int g_fail = 0;
static void gleich(char const* was, std::uint64_t got, std::uint64_t want) {
    bool const ok = (got == want);
    if (!ok) ++g_fail;
    std::cout << (ok ? "  [OK]  " : "  [ERR] ") << was << " = " << got;
    if (!ok) std::cout << "  (erwartet " << want << ")";
    std::cout << "\n";
}

template <class L>
static std::uint64_t clu_lines(std::vector<unsigned char>& buf, std::size_t n, std::size_t rs) {
    ml::ObservableMemoryLayout<L> organ{};
    (void)organ.observe_scan(buf.data(), n, rs);
    return organ.statistics().cache_lines_touched;
}

int main() {
    constexpr std::size_t      kN  = 1024;
    constexpr std::size_t      kRs = 48;
    std::vector<unsigned char> buf(kN * 256u + 64u, 0u);

    // Alt-Formel, VERBATIM: ceil(n*rs / 64)
    std::uint64_t const alt = (static_cast<std::uint64_t>(kN) * kRs + 63u) / 64u;

    std::cout << "== B14-NB3 CLU-BEWEIS (cache_lines_touched folgt der Unterachse) ==\n";
    std::cout << "-- (1) Byte-Neutralitaet am Achsen-Default (Soll: Alt-Formel " << alt << ") --\n";
    gleich("CLA (echte Strategie)", clu_lines<ml::CacheLineAlignedMemoryLayout>(buf, kN, kRs), alt);
    gleich("ProbeCla<B64>", clu_lines<ProbeCla<cl::CacheLineSize::B64>>(buf, kN, kRs), alt);

    std::cout << "-- (2) Schaerfe: dieselben Daten, nur die Unterachse permutiert --\n";
    std::uint64_t const l32  = clu_lines<ProbeCla<cl::CacheLineSize::B32>>(buf, kN, kRs);
    std::uint64_t const l64  = clu_lines<ProbeCla<cl::CacheLineSize::B64>>(buf, kN, kRs);
    std::uint64_t const l128 = clu_lines<ProbeCla<cl::CacheLineSize::B128>>(buf, kN, kRs);
    std::uint64_t const l256 = clu_lines<ProbeCla<cl::CacheLineSize::B256>>(buf, kN, kRs);
    gleich("B32  (ceil(1024*48/32))", l32, (static_cast<std::uint64_t>(kN) * kRs + 31u) / 32u);
    gleich("B64  (ceil(1024*48/64))", l64, alt);
    gleich("B128 (ceil(1024*48/128))", l128, (static_cast<std::uint64_t>(kN) * kRs + 127u) / 128u);
    gleich("B256 (ceil(1024*48/256))", l256, (static_cast<std::uint64_t>(kN) * kRs + 255u) / 256u);
    bool const scharf = (l32 != l64) && (l64 != l128) && (l128 != l256);
    gleich("vier paarweise VERSCHIEDENE Werte (am Alt-Stand waeren alle gleich gewesen)", scharf ? 1u : 0u, 1u);

    std::cout << "\n== " << (g_fail == 0 ? "CLU-BEWEIS OK -- byte-neutral am Default, scharf bei Permutation"
                                         : "ABWEICHUNG")
              << " ==\n";
    return g_fail == 0 ? 0 : 1;
}
