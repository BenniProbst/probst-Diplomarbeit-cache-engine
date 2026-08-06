// T2-B Gate-Sonde: das PER-PERM-Glied [5] -- der Beweis, dass O2 und O3 derselben Zelle
// NICHT mehr denselben Fingerprint bekommen (Codex [CX-B1], KRITISCH).
#include <cache_engine/abi/anatomy_fingerprint.hpp>
#include <cache_engine/abi/toolchain_stamp_glied.hpp>
#include <profile_facade/toolchain_stamp_naht.hpp>
#include <sha512/ctsha512.hpp>
#include <cstdio>
#include <span>
#include <string>
namespace pf = ::comdare::cache_engine::profile_facade;
namespace abi = ::comdare::cache_engine::abi;

static std::string fp_of(std::string const& tc) {
    std::string const organ  = "search_algo=k_ary@1.0.0c";
    std::string const system = "target_isa=code.x86_64@1.0.0c";
    std::string const mess   = "measurement_tooling=wallclock@1.0.0c";
    std::string const bv     = "bvset=1;bv=2;page_type[{a;page_kind=1}]";
    auto const gl = abi::anatomy_fingerprint_glieder(organ, system, mess, abi::ToolchainGlied{tc}, abi::BvsetGlied{bv});
    std::string const pre = abi::anatomy_fingerprint_preimage(std::span<std::string_view const>{gl.data(), gl.size()});
    auto const d = ::comdare::cache_engine::sha512::sha512(
        std::span<std::uint8_t const>{reinterpret_cast<std::uint8_t const*>(pre.data()), pre.size()});
    auto const hx = ::comdare::cache_engine::sha512::to_hex(d);
    return std::string(hx.data(), 32);
}

int main() {
    std::printf("RUN-KONSTANT (compose_live)     : '%s'\n", pf::compose_live_toolchain_stamp_glied().c_str());
    std::printf("atomic128-Wahl dieses Baus      : id='%s' flags='%s'\n",
                std::string{pf::active_atomic128_wahl().id}.c_str(),
                std::string{pf::active_atomic128_wahl().flags}.c_str());
    pf::PermToolchainAchsen o2{}; o2.opt = "O2"; o2.opt_flags = "-O2";
    pf::PermToolchainAchsen o3{}; o3.opt = "O3"; o3.opt_flags = "-O3";
    pf::PermToolchainAchsen o3a{}; o3a.opt = "O3"; o3a.opt_flags = "-O3"; o3a.simd = "avx512";
    std::string const g2 = pf::compose_toolchain_stamp_glied_for_perm(o2);
    std::string const g3 = pf::compose_toolchain_stamp_glied_for_perm(o3);
    std::string const g3a = pf::compose_toolchain_stamp_glied_for_perm(o3a);
    std::printf("PERM opt=O2                     : '%s'\n", g2.c_str());
    std::printf("PERM opt=O3                     : '%s'\n", g3.c_str());
    std::printf("PERM opt=O3 ext=avx512          : '%s'\n", g3a.c_str());
    std::printf("Fingerprint(32) O2 / O3 / O3avx : %s / %s / %s\n",
                fp_of(g2).c_str(), fp_of(g3).c_str(), fp_of(g3a).c_str());
    std::printf("O2 != O3 ?                      : %s\n", (fp_of(g2) != fp_of(g3)) ? "JA (geheilt)" : "NEIN (BEFUND)");
    std::printf("O3 != O3+avx512 ?               : %s\n", (fp_of(g3) != fp_of(g3a)) ? "JA (geheilt)" : "NEIN (BEFUND)");
    // Die Identitaets-Zusage: leere Perm-Achsen == der run-konstante Wert.
    std::printf("leere Achsen == compose_live ?  : %s\n",
                (pf::compose_toolchain_stamp_glied_for_perm(pf::PermToolchainAchsen{}) ==
                 pf::compose_live_toolchain_stamp_glied()) ? "JA" : "NEIN");
    return 0;
}
