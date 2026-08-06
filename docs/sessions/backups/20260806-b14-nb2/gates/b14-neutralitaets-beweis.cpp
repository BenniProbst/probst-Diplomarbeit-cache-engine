// TEMPORAERER BEWEIS-TU (nicht committet): Byte-Neutralitaet der kLbufBytes-Ableitung.
#include <axes/layout/axis_05_memory_layout_observable.hpp>
#include <axes/layout/axis_05_memory_layout_aos_strict.hpp>
#include <axes/layout/axis_05_memory_layout_aosoa.hpp>
#include <axes/layout/axis_05_memory_layout_soa.hpp>
#include <axes/layout/axis_05_memory_layout_cache_line_aligned.hpp>
#include <axes/layout/axis_05_memory_layout_packed_bitmap.hpp>
#include <axes/cacheline/cacheline_line_bytes.hpp>
#include <cstddef>

namespace ml = ::comdare::cache_engine::layout;
namespace cl = ::comdare::cache_engine::cacheline;

template <class L>
constexpr std::size_t stride(std::size_t rs) {
    constexpr std::size_t line = cl::line_bytes_of<L>();
    return ((rs + line - 1u) / line) * line;
}

#define PROVE(S)                                                                         \
    static_assert(cl::line_bytes_of<ml::ObservableMemoryLayout<ml::S>>() == 64,           \
                  #S ": line_bytes_of != 64 -- NICHT byte-neutral!");                     \
    static_assert(stride<ml::ObservableMemoryLayout<ml::S>>(48) == 64, #S ": stride != 64"); \
    static_assert(16384u * stride<ml::ObservableMemoryLayout<ml::S>>(48) == 1048576u,     \
                  #S ": kLbufBytes != 1048576 -- ALT-WERT VERLETZT!");                    \
    /* nackte Strategie (ohne Huelle) muss denselben Wert liefern */                      \
    static_assert(cl::line_bytes_of<ml::S>() == 64, #S ": nackte Strategie != 64");

PROVE(AoSStrictMemoryLayout)
PROVE(AoSoAMemoryLayout)
PROVE(SoAMemoryLayout)
PROVE(CacheLineAlignedMemoryLayout)
PROVE(PackedBitmapMemoryLayout)

// GEGENPROBE: die Ableitung IST scharf -- bei B256 aendert sich der Puffer wirklich.
static_assert(cl::line_bytes_of<cl::CacheLineAware<cl::CacheLineConfig{cl::CacheLineSize::B256}>>() == 256);
static_assert(stride<cl::CacheLineAware<cl::CacheLineConfig{cl::CacheLineSize::B256}>>(48) == 256);
static_assert(16384u * 256u == 4194304u);

int main() { return 0; }
