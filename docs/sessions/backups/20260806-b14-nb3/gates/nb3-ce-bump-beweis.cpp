// B14-NB3 BEWEIS-TU (temporaer, NICHT committet) -- BUMP-ENTSCHEIDUNG fuer algo_version.
//
// FRAGE: aendert die Achsenbindung von CacheLineAlignedMemoryLayout::scan_field_sum (Literal 64 ->
// cacheline_subaxis_line_bytes()) und die Auslagerung des Rumpfes nach detail::padded_aos_field_sum
// irgendeinen GEMESSENEN Wert? Wenn ja -> Bump nach Versions-FLAG-Grammatik; wenn nein -> kein Bump.
//
// METHODE: der VORHER-Rumpf wird hier BYTE-VERBATIM als Referenz nachgebaut (aus dem git-Stand 6a40071f)
// und gegen die HEUTIGE Quelle laufen gelassen -- ueber echte Puffer, echte Werte, alle fuenf Strategien,
// gehuellt UND nackt. Nicht behauptet, sondern verglichen.
#include <axes/cacheline/cacheline_line_bytes.hpp>
#include <axes/layout/axis_05_memory_layout_aos_strict.hpp>
#include <axes/layout/axis_05_memory_layout_aosoa.hpp>
#include <axes/layout/axis_05_memory_layout_cache_line_aligned.hpp>
#include <axes/layout/axis_05_memory_layout_observable.hpp>
#include <axes/layout/axis_05_memory_layout_packed_bitmap.hpp>
#include <axes/layout/axis_05_memory_layout_soa.hpp>

#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <random>
#include <vector>

namespace cl = ::comdare::cache_engine::cacheline;
namespace ml = ::comdare::cache_engine::layout;

// ---- VORHER: der Rumpf aus 6a40071f, Zeile fuer Zeile ------------------------------------------------
[[nodiscard]] static std::uint64_t cla_scan_VORHER(unsigned char const* buf, std::size_t n,
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

static int g_fail = 0;
template <class A, class B>
static void gleich(char const* was, A got, B want) {
    bool const ok = (got == want);
    if (!ok) ++g_fail;
    std::cout << (ok ? "  [OK]  " : "  [ERR] ") << was << " : " << got;
    if (!ok) std::cout << "  != " << want;
    std::cout << "\n";
}

#define ZEIGE_LINE(S)                                                                                        \
    gleich("line_bytes_of<" #S ">           (nackt)", cl::line_bytes_of<ml::S>(), std::size_t{64});          \
    gleich("line_bytes_of<Observable<" #S ">> (gehuellt)",                                                   \
           cl::line_bytes_of<ml::ObservableMemoryLayout<ml::S>>(), std::size_t{64});

int main() {
    // Realistischer Mess-Puffer: 16384 Records a 48 B, nach dem groesstmoeglichen Stride 64 dimensioniert
    // (exakt die abi_adapter-Geometrie am Achsen-Default).
    constexpr std::size_t      kRecords    = 16384;
    constexpr std::size_t      kRecordSize = 48;
    constexpr std::size_t      kLbufBytes  = kRecords * 64;
    std::vector<unsigned char> buf(kLbufBytes);
    std::mt19937_64            rng{0xB14ull * 1000003ull + 3ull};
    for (auto& b : buf) b = static_cast<unsigned char>(rng() & 0xFFu);

    std::cout << "== B14-NB3 BUMP-BEWEIS ==\n";
    std::cout << "-- (1) Achsen-Belegung ALLER fuenf Strategien, nackt und gehuellt (Soll: ueberall 64) --\n";
    ZEIGE_LINE(AoSStrictMemoryLayout)
    ZEIGE_LINE(AoSoAMemoryLayout)
    ZEIGE_LINE(SoAMemoryLayout)
    ZEIGE_LINE(CacheLineAlignedMemoryLayout)
    ZEIGE_LINE(PackedBitmapMemoryLayout)

    std::cout << "-- (2) CLA-Scan: HEUTIGE Quelle gegen den VORHER-Rumpf, auf denselben Bytes --\n";
    std::uint64_t const vorher   = cla_scan_VORHER(buf.data(), kRecords, kRecordSize);
    std::uint64_t const nachher  = ml::CacheLineAlignedMemoryLayout::scan_field_sum(buf.data(), kRecords, kRecordSize);
    std::uint64_t const gehuellt = ml::ObservableMemoryLayout<ml::CacheLineAlignedMemoryLayout>::scan_field_sum(
        buf.data(), kRecords, kRecordSize);
    std::cout << "  VORHER   (Literal 64)         = " << vorher << "\n";
    std::cout << "  NACHHER  (Achse, neue Quelle) = " << nachher << "\n";
    std::cout << "  NACHHER  (ueber die Huelle)   = " << gehuellt << "\n";
    gleich("Pruefsumme identisch (nackt)", nachher, vorher);
    gleich("Pruefsumme identisch (gehuellt)", gehuellt, vorher);

    // Ueber mehrere record_size-Werte, nicht nur den Mess-Wert -- damit die Gleichheit nicht zufaellig ist.
    bool alle_gleich = true;
    for (std::size_t rs : {std::size_t{4}, std::size_t{8}, std::size_t{16}, std::size_t{48}, std::size_t{64},
                           std::size_t{63}, std::size_t{65}, std::size_t{128}}) {
        std::size_t const   stride = ((rs + 63u) / 64u) * 64u;
        std::size_t const   n      = (stride == 0) ? 0 : (kLbufBytes - 4u) / stride;
        std::uint64_t const a      = cla_scan_VORHER(buf.data(), n, rs);
        std::uint64_t const b      = ml::CacheLineAlignedMemoryLayout::scan_field_sum(buf.data(), n, rs);
        if (a != b) {
            alle_gleich = false;
            std::cout << "  [ERR] record_size=" << rs << " : " << b << " != " << a << "\n";
        }
    }
    gleich("VORHER == NACHHER fuer alle 8 geprueften record_size-Werte", alle_gleich, true);

    std::cout << "-- (3) Die anderen vier Strategien: unberuehrt (Kontroll-Pruefsummen) --\n";
    std::cout << "  aos_strict    = " << ml::AoSStrictMemoryLayout::scan_field_sum(buf.data(), kRecords, kRecordSize)
              << "\n";
    std::cout << "  soa           = " << ml::SoAMemoryLayout::scan_field_sum(buf.data(), kRecords, kRecordSize) << "\n";
    std::cout << "  aosoa         = " << ml::AoSoAMemoryLayout::scan_field_sum(buf.data(), kRecords, kRecordSize)
              << "\n";
    std::cout << "  packed_bitmap = "
              << ml::PackedBitmapMemoryLayout::scan_field_sum(buf.data(), kRecords, kRecordSize) << "\n";

    std::cout << "-- (4) GEGENPROBE: die Ableitung IST scharf -- derselbe Rumpf mit einer anderen Achsen-Line --\n";
    std::uint64_t const b64  = ml::detail::padded_aos_field_sum(buf.data(), kRecords, kRecordSize, 64);
    std::uint64_t const b32  = ml::detail::padded_aos_field_sum(buf.data(), kRecords, kRecordSize, 32);
    std::uint64_t const b128 = ml::detail::padded_aos_field_sum(buf.data(), 8192, kRecordSize, 128);
    std::uint64_t const b256 = ml::detail::padded_aos_field_sum(buf.data(), 4096, kRecordSize, 256);
    gleich("line=64 == CLA-Scan heute (der Default-Weg)", b64, nachher);
    gleich("line=32 == line=64 (round_up(48,32)=64, kein Unterschied)", b32, b64);
    std::cout << "  line=128 (n=8192) = " << b128 << "\n  line=256 (n=4096) = " << b256 << "\n";
    gleich("line=128 liefert einen ANDEREN Wert als line=64", b128 != b64, true);
    gleich("line=256 liefert einen ANDEREN Wert als line=128", b256 != b128, true);

    std::cout << "\n== BEFUND: " << (g_fail == 0 ? "KEIN algo_version-Bump faellig" : "ABWEICHUNG -- Bump pruefen!")
              << " ==\n";
    return g_fail == 0 ? 0 : 1;
}
