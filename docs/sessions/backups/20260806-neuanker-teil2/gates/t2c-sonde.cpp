// T2-C Gate-Sonde: die RT-Realversion am Tier-Treiber selbst.
#include <profile_facade/toolchain_stamp_naht.hpp>
#include <cstdio>
#include <cstdlib>
#include <string>
namespace pf = ::comdare::cache_engine::profile_facade;
static void zeige(char const* tag) {
    auto const v = pf::tier_realversion_von(tag);
    std::printf("  Sonde '%-22s' -> %s\n", tag, v.has_value() ? v->c_str() : "UNBEKANNT (fail-closed)");
}
int main() {
    std::printf("AKTIVER Treiber          : '%s'\n", pf::active_cxx_driver_tag().c_str());
    std::printf("AKTIVE Realversion (RT)  : '%s'\n", pf::active_tier_realversion().c_str());
    std::printf("skip-faehig?             : %s\n", pf::tier_realversion_ist_bekannt() ? "JA" : "NEIN");
    std::printf("LIVE Glied [5]           : '%s'\n", pf::compose_live_toolchain_stamp_glied().c_str());
    std::printf("Die REALE Flotte (Owner-KERN frueh-12: gcc 15.3 + gcc 16, keine Phantom-Versionen):\n");
    zeige("g++"); zeige("g++-16");
    std::printf("Fail-closed-Faelle:\n");
    zeige("g++-999");                 // existiert nicht -> Sonde scheitert
    zeige("g++ -o /tmp/pwn");         // Whitespace -> nicht sondierbar (Wache greift VOR der Shell)
    zeige("g++;touch /tmp/pwn");      // Struktur-Zeichen -> nicht sondierbar
    zeige("g++$(id)");                // Shell-Metazeichen -> nicht sondierbar (Allowlist)
    std::printf("Nebenwirkungs-Probe /tmp/pwn existiert? %s\n",
                std::system("test -e /tmp/pwn") == 0 ? "JA (BEFUND!)" : "NEIN (gut)");
    return 0;
}
