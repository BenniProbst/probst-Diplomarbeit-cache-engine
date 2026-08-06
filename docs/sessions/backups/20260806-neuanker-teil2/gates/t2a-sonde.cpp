// T2-A Gate-Sonde: der Frozen-Vektor auf dem RT-Weg (Preimage-Laenge + Digest).
#include <cache_engine/abi/anatomy_fingerprint.hpp>
#include <cstdio>
#include <string>
#include <string_view>
namespace abi = ::comdare::cache_engine::abi;
int main() {
    constexpr std::string_view kOrgan   = "search_algo=k_ary@1.0.0c;path_compression=path_compression_none@1.0.0c";
    constexpr std::string_view kSystem  = "target_isa=code@1.0.0c;operating_system=code@1.0.0c;"
                                          "external_utils=code@1.0.0c;[simd=code@1.0.0c]";
    constexpr std::string_view kMeasure = "measurement_tooling=wallclock@1.0.0c;[load_framework=ycsb@1.0.0c]";
    constexpr std::string_view kTc =
        "tc=1;cxx=gcc-16.2.0@1.0.0c;opt=O3{-O3}@1.0.0c;ext=avx512;ceb=8.0;gate=avx512;atomic128=cx16{-mcx16}@1.0.0c";
    constexpr std::string_view kBvset = "bvset=1;bv=2;page_type[{bplus;hw_cache_line=64;hw_numa_capable=0}];"
                                        "simd_extension[{avx512}];"
                                        "general_hardware[{x86_64;hw_cache_line=64;hw_numa_capable=0}]";
    auto const glieder = abi::anatomy_fingerprint_glieder(kOrgan, kSystem, kMeasure, abi::ToolchainGlied{kTc},
                                                          abi::BvsetGlied{kBvset});
    std::string const pre =
        abi::anatomy_fingerprint_preimage(std::span<std::string_view const>{glieder.data(), glieder.size()});
    auto const digest = ::comdare::cache_engine::sha512::sha512(
        std::span<const std::uint8_t>{reinterpret_cast<std::uint8_t const*>(pre.data()), pre.size()});
    auto const hex = ::comdare::cache_engine::sha512::to_hex(digest);
    std::printf("  Frozen-Preimage Laenge : %zu Bytes\n", pre.size());
    std::printf("  Frozen-Digest (RT-Weg) : %.128s\n", hex.data());
    return 0;
}
