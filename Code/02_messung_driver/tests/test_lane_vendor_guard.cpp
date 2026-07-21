// Scheibe 2a (2026-07-21, Ledger 61/62) - Unit-Gate der Lane-Fehlrouting-Wache (lane_vendor_guard.hpp).
//
// Prueft die REINE Entscheidung check_lane_vendor (Match/Mismatch/Skip) ohne echte CPU-Abhaengigkeit,
// plus lane_expected_vendor (Lane-Praefix-Parsing) und detect_cpu_vendor (nur: liefert genau eine der
// drei erlaubten Vendor-Klassen). Gate-frei (reine Host-Logik, kein Treiber-Lauf, kein #156-Messdaten).

#include "lane_vendor_guard.hpp"

#include <cstdio>
#include <string>

namespace md = comdare::diplomarbeit::messung_driver;

static int  g_fail = 0;
static void check(bool ok, char const* msg) {
    std::printf("  [%s] %s\n", ok ? "OK" : "FAIL", msg);
    if (!ok) ++g_fail;
}

int main() {
    using LVC = md::LaneVendorCheck;

    // lane_expected_vendor: Praefix-Parsing der emittierten Lane-Form "amd@<host>"/"intel@<host>".
    check(md::lane_expected_vendor("amd@prod1") == "amd", "lane 'amd@prod1' -> amd");
    check(md::lane_expected_vendor("intel@prod2") == "intel", "lane 'intel@prod2' -> intel");
    check(md::lane_expected_vendor("").empty(), "leere Platform -> kein Lane-Vendor");
    check(md::lane_expected_vendor("linux-x86_64").empty(), "grobe Detektion -> kein Lane-Vendor");
    check(md::lane_expected_vendor("amd").empty(), "'amd' ohne @ -> kein Lane-Vendor (nur Praefix zaehlt)");

    // check_lane_vendor: Match -> laeuft.
    check(md::check_lane_vendor("amd@prod1", "amd") == LVC::kMatch, "amd@ + amd -> Match");
    check(md::check_lane_vendor("intel@prod2", "intel") == LVC::kMatch, "intel@ + intel -> Match");

    // check_lane_vendor: Mismatch -> harter Abbruch.
    check(md::check_lane_vendor("amd@prod1", "intel") == LVC::kMismatch, "amd@ + intel -> Mismatch");
    check(md::check_lane_vendor("intel@prod2", "amd") == LVC::kMismatch, "intel@ + amd -> Mismatch");

    // check_lane_vendor: Skip -> kein Praefix ODER Vendor unbekannt (Notausgang, nie Fehlalarm).
    check(md::check_lane_vendor("linux-x86_64", "amd") == LVC::kSkipped, "kein Lane-Praefix -> Skip");
    check(md::check_lane_vendor("", "intel") == LVC::kSkipped, "leere Platform -> Skip");
    check(md::check_lane_vendor("amd@prod1", "unknown") == LVC::kSkipped, "Vendor unknown -> Skip");
    check(md::check_lane_vendor("amd@prod1", "") == LVC::kSkipped, "Vendor leer -> Skip");

    // detect_cpu_vendor: liefert genau eine der erlaubten Klassen (Host-abhaengig, aber wohldefiniert).
    std::string const v = md::detect_cpu_vendor();
    check(v == "amd" || v == "intel" || v == "unknown", "detect_cpu_vendor in {amd,intel,unknown}");
    std::printf("  [INFO] detektierter Host-Vendor: %s\n", v.c_str());

    std::printf("%s: %d Fehler\n", g_fail == 0 ? "PASS" : "FAIL", g_fail);
    return g_fail == 0 ? 0 : 1;
}
