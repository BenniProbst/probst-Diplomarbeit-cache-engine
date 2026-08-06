// Punkt 3: wuerde die Fingerprint-Formwache die Ebene DAUERHAFT inert machen?
// Gemessen an den ECHTEN golden-320-binary_ids gegen die Enable-Menge dieses Baums.
#include <profile_facade/lazy_adhoc_source_gen.hpp>
#include <builder/build_orchestrator/fingerprint_sidecar.hpp>
#include <cstdio>
#include <fstream>
#include <string>
#include <vector>
namespace tl = ::comdare::cache_engine::thesis_lazy;
namespace ex = ::comdare::cache_engine::builder::experiment;
int main(int argc, char** argv) {
    std::ifstream in{argv[1]};
    std::vector<std::string> ids;
    for (std::string z; std::getline(in, z);) {
        while (!z.empty() && (z.back() == '\r' || z.back() == ' ')) z.pop_back();
        if (!z.empty() && z[0] != '#') ids.push_back(z);
    }
    auto const tables       = tl::lazy_slot_type_tables();
    auto const version_table = ex::build_axis_variant_version_table();
    std::size_t leer = 0, gut = 0, formwidrig = 0;
    std::string erstes_leer;
    for (auto const& id : ids) {
        auto const fp = tl::lazy_adhoc_fingerprint_for(tables, id, version_table);
        if (fp.empty()) { if (erstes_leer.empty()) erstes_leer = id; ++leer; }
        else if (!ex::detail::fp_is_hex_128(fp)) ++formwidrig;
        else ++gut;
    }
    std::printf("  binary_ids gepruefte Menge : %zu\n", ids.size());
    std::printf("  gueltige 128-hex           : %zu\n", gut);
    std::printf("  LEER (nicht materialisierbar): %zu\n", leer);
    std::printf("  formwidrig (weder leer noch 128-hex): %zu\n", formwidrig);
    if (leer) std::printf("  erste leere binary_id      : %s\n", erstes_leer.c_str());
    std::printf("  => Formwache wuerde die Plan-Ablage %s\n",
                (leer || formwidrig) ? "INERT LASSEN (Ebene formal scharf, faktisch aus)" : "DURCHLASSEN (Ebene wirksam)");
    return 0;
}
