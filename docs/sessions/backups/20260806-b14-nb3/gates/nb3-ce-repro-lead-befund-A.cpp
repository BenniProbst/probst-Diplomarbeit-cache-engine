// B14-NB3 REPRODUKTIONS-SONDE (temporaer, NICHT committet) -- LEAD-BEFUND A am OBJEKT nachgezaehlt:
// "CacheLineAlignedMemoryLayout::scan_field_sum traegt hart kCacheLine = 64 und fragt die Achse NICHT."
//
// Die Sonde beweist die Aussage OHNE die Quelle zu aendern, indem sie den HEUTIGEN Rumpf (Literal 64)
// und den ACHSEN-GEBUNDENEN Rumpf in je eine Probe-Strategie legt, die sich NUR in der cacheline-
// Unterachse unterscheidet. Gemessen wird der REALE Lese-Fussabdruck (welche Byte-Offsets beruehrt der
// Scan?), nicht eine Behauptung ueber ihn.
#include <axes/cacheline/cacheline_config.hpp>
#include <axes/cacheline/cacheline_line_bytes.hpp>
#include <axes/layout/axis_05_memory_layout_cache_line_aligned.hpp>
#include <axes/layout/axis_05_memory_layout_observable.hpp>
#include <axes/layout/axis_05_memory_layout_strategy_base.hpp>

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <set>
#include <string_view>
#include <vector>

namespace cl = ::comdare::cache_engine::cacheline;
namespace ml = ::comdare::cache_engine::layout;

// ---- Probe-Strategien: identisch bis auf DEN EINEN Rumpf; beide tragen die Unterachse als NTTP. --------
template <cl::CacheLineSize S>
struct ProbeIst : ml::MemoryLayoutStrategyBase<ProbeIst<S>, cl::CacheLineConfig{S}> {
    using topic_tag = ::comdare::cache_engine::memory_layout::concepts::MemoryLayoutTopicTag;
    [[nodiscard]] static constexpr std::size_t      cache_line_size() noexcept { return 64; }
    [[nodiscard]] static constexpr std::string_view name() noexcept { return "probe_ist"; }
    [[nodiscard]] static constexpr ml::RepresentationKind representation_kind() noexcept {
        return ml::RepresentationKind::aos_interleaved_padded;
    }
    // VERBATIM der heutige Rumpf aus axis_05_memory_layout_cache_line_aligned.hpp:58-69.
    [[nodiscard]] static std::uint64_t scan_field_sum(unsigned char const* buf, std::size_t n,
                                                      std::size_t record_size) noexcept {
        constexpr std::size_t kCacheLine     = 64;
        std::size_t const     aligned_stride = (record_size + kCacheLine - 1u) & ~(kCacheLine - 1u);
        std::uint64_t         s              = 0;
        for (std::size_t i = 0; i < n; ++i) {
            std::uint32_t v;
            std::memcpy(&v, buf + i * aligned_stride, sizeof(v));
            s += v;
        }
        return s;
    }
};

template <cl::CacheLineSize S>
struct ProbeSoll : ml::MemoryLayoutStrategyBase<ProbeSoll<S>, cl::CacheLineConfig{S}> {
    using topic_tag = ::comdare::cache_engine::memory_layout::concepts::MemoryLayoutTopicTag;
    [[nodiscard]] static constexpr std::size_t      cache_line_size() noexcept { return 64; }
    [[nodiscard]] static constexpr std::string_view name() noexcept { return "probe_soll"; }
    [[nodiscard]] static constexpr ml::RepresentationKind representation_kind() noexcept {
        return ml::RepresentationKind::aos_interleaved_padded;
    }
    // Achsen-gebundener Rumpf (der Heil-Vorschlag).
    [[nodiscard]] static std::uint64_t scan_field_sum(unsigned char const* buf, std::size_t n,
                                                      std::size_t record_size) noexcept {
        constexpr std::size_t kCacheLine =
            ml::MemoryLayoutStrategyBase<ProbeSoll<S>, cl::CacheLineConfig{S}>::cacheline_subaxis_line_bytes();
        std::size_t const aligned_stride = ((record_size + kCacheLine - 1u) / kCacheLine) * kCacheLine;
        std::uint64_t     s              = 0;
        for (std::size_t i = 0; i < n; ++i) {
            std::uint32_t v;
            std::memcpy(&v, buf + i * aligned_stride, sizeof(v));
            s += v;
        }
        return s;
    }
};

// ---- Fussabdruck-Messung: welche Byte-Offsets liest der Scan wirklich? ---------------------------------
constexpr std::size_t kRecords    = 64;   // klein genug fuer eine sichtbare Offset-Liste
constexpr std::size_t kRecordSize = 48;   // der Mess-Build-Wert (abi_adapter.hpp)
constexpr std::size_t kBuf        = 1u << 20;

template <class L>
static std::size_t effektiver_stride(std::vector<unsigned char>& buf) {
    // Zwei Records mit unterscheidbarem Muster: der Scan meldet, WO er liest.
    std::memset(buf.data(), 0, buf.size());
    // Wir markieren jeden 4-Byte-Kopf mit seinem Offset/4; die Summe verraet die Offsets eindeutig genug,
    // aber wir bestimmen den Stride direkt: setze nur EIN Feld ungleich 0 und suche, ab welchem Offset
    // die Summe reagiert.
    for (std::size_t off = 4; off <= 512; off += 4) {
        std::memset(buf.data(), 0, 1024);
        std::uint32_t const marker = 0xABCDu;
        std::memcpy(buf.data() + off, &marker, sizeof(marker));
        if (L::scan_field_sum(buf.data(), kRecords, kRecordSize) != 0u) return off; // Offset von Record 1
    }
    return 0;
}

static int g_fail = 0;
static void zeile(char const* was, std::size_t got, std::size_t want) {
    bool const ok = (got == want);
    if (!ok) ++g_fail;
    std::cout << (ok ? "  [OK]  " : "  [ERR] ") << was << " = " << got;
    if (!ok) std::cout << "  (erwartet " << want << ")";
    std::cout << "\n";
}

int main() {
    std::vector<unsigned char> buf(kBuf, 0);
    std::cout << "== B14-NB3 REPRODUKTION, LEAD-BEFUND A ==\n";
    std::cout << "-- (1) Was SAGT die Achse? (line_bytes_of ueber die Konsum-Bruecke) --\n";
    zeile("Achse ProbeIst<B32>   line_bytes_of", cl::line_bytes_of<ProbeIst<cl::CacheLineSize::B32>>(), 32);
    zeile("Achse ProbeIst<B64>   line_bytes_of", cl::line_bytes_of<ProbeIst<cl::CacheLineSize::B64>>(), 64);
    zeile("Achse ProbeIst<B128>  line_bytes_of", cl::line_bytes_of<ProbeIst<cl::CacheLineSize::B128>>(), 128);
    zeile("Achse ProbeIst<B256>  line_bytes_of", cl::line_bytes_of<ProbeIst<cl::CacheLineSize::B256>>(), 256);

    std::cout << "-- (2) Was TUT der HEUTIGE Rumpf (Literal 64)? realer Lese-Offset von Record 1 --\n";
    std::size_t const i32  = effektiver_stride<ProbeIst<cl::CacheLineSize::B32>>(buf);
    std::size_t const i64  = effektiver_stride<ProbeIst<cl::CacheLineSize::B64>>(buf);
    std::size_t const i128 = effektiver_stride<ProbeIst<cl::CacheLineSize::B128>>(buf);
    std::size_t const i256 = effektiver_stride<ProbeIst<cl::CacheLineSize::B256>>(buf);
    zeile("IST-Rumpf B32   effektiver Stride", i32, 64);
    zeile("IST-Rumpf B64   effektiver Stride", i64, 64);
    zeile("IST-Rumpf B128  effektiver Stride", i128, 64);
    zeile("IST-Rumpf B256  effektiver Stride", i256, 64);
    std::cout << "  ==> BEFUND A REPRODUZIERT: vier verschiedene Achsen-Belegungen, EIN einziger Stride 64.\n"
                 "      KF-6-line_size-Permutationen differenzieren den CLA-Scan NICHT (Mess-Validitaets-Loch).\n";

    std::cout << "-- (3) Was TUT der achsen-gebundene Rumpf? --\n";
    zeile("SOLL-Rumpf B32   effektiver Stride", effektiver_stride<ProbeSoll<cl::CacheLineSize::B32>>(buf), 64);
    zeile("SOLL-Rumpf B64   effektiver Stride", effektiver_stride<ProbeSoll<cl::CacheLineSize::B64>>(buf), 64);
    zeile("SOLL-Rumpf B128  effektiver Stride", effektiver_stride<ProbeSoll<cl::CacheLineSize::B128>>(buf), 128);
    zeile("SOLL-Rumpf B256  effektiver Stride", effektiver_stride<ProbeSoll<cl::CacheLineSize::B256>>(buf), 256);
    std::cout << "  HINWEIS B32: round_up(48,32) = 64 -- der Stride BLEIBT 64. B32 und B64 sind auf der\n"
                 "  Scan-Seite bei kRecordSize=48 zwangslaeufig gleich; der Unterschied liegt beim Alignment.\n";

    std::cout << "-- (4) HEUTE (alle 5 Strategien am Default B64): Ist == Soll, also byte-neutral --\n";
    zeile("CLA line_bytes_of (real)", cl::line_bytes_of<ml::CacheLineAlignedMemoryLayout>(), 64);
    zeile("CLA effektiver Stride (real, IST-Quelle)", effektiver_stride<ml::CacheLineAlignedMemoryLayout>(buf), 64);
    zeile("CLA effektiver Stride via Observable-Huelle",
          effektiver_stride<ml::ObservableMemoryLayout<ml::CacheLineAlignedMemoryLayout>>(buf), 64);

    std::cout << "\n== " << (g_fail == 0 ? "SONDE OK (alle Erwartungen getroffen)" : "SONDE MIT ABWEICHUNGEN")
              << " ==\n";
    return g_fail == 0 ? 0 : 1;
}
