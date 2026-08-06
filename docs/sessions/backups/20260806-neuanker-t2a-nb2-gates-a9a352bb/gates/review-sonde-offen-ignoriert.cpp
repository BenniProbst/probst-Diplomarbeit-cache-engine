// Zusatz-Nachmessung: der Plan-Resume ignoriert die FRISCHE Miss-Zahl (PlanFach::offen).
#include <builder/bestandslog/batch_planner.hpp>
#include <cstdio>
#include <vector>
namespace bl = ::comdare::cache_engine::builder::bestandslog;
int main() {
    // Zwei Faecher a 4 Atome. Das FUEHRENDE Fach ist laut FRISCHEM Scan VOLLSTAENDIG LEER (offen==count).
    std::vector<bl::PlanFach> const f{{0, 4, 4}, {4, 4, 0}};
    std::uint64_t const             zaehler = 8; // ein Alt-Lauf hat beide Faecher gebucht
    std::printf("  Fach 0: count=%llu offen=%llu (der frische Scan sagt: KEINE dieser Binaries liegt)\n",
                (unsigned long long)f[0].count, (unsigned long long)f[0].offen);
    std::printf("  plan_resume_faecher(f, %llu) = %zu von %zu -> uebersprungen werden %zu Faecher\n",
                (unsigned long long)zaehler, bl::plan_resume_faecher(f, zaehler), f.size(),
                bl::plan_resume_faecher(f, zaehler));
    return bl::plan_resume_faecher(f, zaehler) == 2 ? 0 : 1;
}
