// NB2 Gate-Sonde: die LIVE-Werte + der Frozen-Digest, unabhaengig nachgerechnet.
#include <cache_engine/abi/anatomy_fingerprint.hpp>
#include <cache_engine/abi/toolchain_stamp_glied.hpp>
#include <profile_facade/toolchain_stamp_naht.hpp>
#include <sha512/ctsha512.hpp>
#include <cstdio>
#include <span>
#include <string>
int main() {
    namespace pf = ::comdare::cache_engine::profile_facade;
    namespace abi = ::comdare::cache_engine::abi;
    std::printf("CEB-Realversion (CT)   : '%s'\n", std::string{abi::kDetectedCompilerRealVersion}.c_str());
    std::printf("CEB-Dialekt (CT)       : '%s'\n", std::string{abi::kDetectedCompilerDialect}.c_str());
    std::printf("Tier-Treiber-Tag (live): '%s'\n", pf::active_cxx_driver_tag().c_str());
    std::printf("Deckung (NB2-1 streng) : %s\n",
                pf::ct_realversion_deckt_treiber(pf::active_cxx_driver_tag()) ? "JA" : "NEIN");
    std::string const tc = pf::compose_live_toolchain_stamp_glied();
    std::printf("LIVE Glied [5] (NB2-1) : '%s'\n", tc.c_str());
    std::printf("LIVE Glied [5] Laenge  : %zu (Budget %zu)\n", tc.size(), abi::kAnatomyFingerprintToolchainMax);
    std::printf("LIVE Glied [6] Praefix : '%.40s...'\n", pf::live_build_variant_set_signature_glied().c_str());

    // Die zwei Faelle aus dem Codex-Befund, am LIVE-Renderer:
    abi::ToolchainStampParts a{}; a.cxx_dialect = "gcc"; a.cxx_driver = "g++-17";
    abi::ToolchainStampParts b{}; b.cxx_dialect = "gcc"; b.cxx_driver = "g++-18";
    std::printf("g++-17 -> '%s'\n", abi::render_toolchain_stamp_glied(a).c_str());
    std::printf("g++-18 -> '%s'\n", abi::render_toolchain_stamp_glied(b).c_str());

    // Der FROZEN-Vektor, unabhaengig nachgerechnet (nicht aus dem Test uebernommen).
    std::string const organ = "search_algo=k_ary@1.0.0c;path_compression=path_compression_none@1.0.0c";
    std::string const system = "target_isa=code@1.0.0c;operating_system=code@1.0.0c;external_utils=code@1.0.0c;[simd=code@1.0.0c]";
    std::string const mess = "measurement_tooling=wallclock@1.0.0c;[load_framework=ycsb@1.0.0c]";
    std::string const ftc = "tc=1;cxx=gcc-16.2.0@1.0.0c;opt=O3{-O3}@1.0.0c;ext=avx512;ceb=8.0;gate=avx512;atomic128=cx16{-mcx16}@1.0.0c";
    std::string const fbv = "bvset=1;bv=2;page_type[{bplus;hw_cache_line=64;hw_numa_capable=0}];simd_extension[{avx512}];general_hardware[{x86_64;hw_cache_line=64;hw_numa_capable=0}]";
    auto const gl = abi::anatomy_fingerprint_glieder(organ, system, mess, abi::ToolchainGlied{ftc}, abi::BvsetGlied{fbv});
    std::string const pre = abi::anatomy_fingerprint_preimage(std::span<std::string_view const>{gl.data(), gl.size()});
    std::printf("Frozen-Preimage Laenge : %zu Bytes\n", pre.size());
    auto const d = ::comdare::cache_engine::sha512::sha512(
        std::span<std::uint8_t const>{reinterpret_cast<std::uint8_t const*>(pre.data()), pre.size()});
    auto const hx = ::comdare::cache_engine::sha512::to_hex(d);
    std::printf("Frozen-Digest (RT-Weg) : %.128s\n", hx.data());
    return 0;
}
