// B14-NB3 Gate-Sonde (unveraendert aus NB2 uebernommen: derselbe Vektor, derselbe Weg): der Frozen-Vektor dieses Branches, UNABHAENGIG vom Test nachgerechnet
// (eigener TU, eigener Aufruf-Weg -- nicht aus dem gtest uebernommen).
#include <cache_engine/abi/anatomy_fingerprint.hpp>
#include <sha512/ctsha512.hpp>
#include <cstdio>
#include <cstdint>
#include <span>
#include <string>
#include <string_view>

int main() {
    namespace abi = ::comdare::cache_engine::abi;
    std::string const organ  = "search_algo=k_ary@1.0.0c;path_compression=path_compression_none@1.0.0c";
    std::string const system = "target_isa=code@1.0.0c;operating_system=code@1.0.0c;"
                               "external_utils=code@1.0.0c;[simd=code@1.0.0c]";
    std::string const mess   = "measurement_tooling=wallclock@1.0.0c;[load_framework=ycsb@1.0.0c]";
    auto const gl  = abi::anatomy_fingerprint_glieder(organ, system, mess);
    std::string const pre = abi::anatomy_fingerprint_preimage(
        std::span<std::string_view const>{gl.data(), gl.size()});
    std::printf("Glieder-Zahl           : %zu\n", gl.size());
    std::printf("Frozen-Preimage Laenge : %zu Bytes\n", pre.size());
    auto const d = ::comdare::cache_engine::sha512::sha512(
        std::span<std::uint8_t const>{reinterpret_cast<std::uint8_t const*>(pre.data()), pre.size()});
    auto const hx = ::comdare::cache_engine::sha512::to_hex(d);
    std::printf("Frozen-Digest (RT-Weg) : %.128s\n", hx.data());
    return 0;
}
