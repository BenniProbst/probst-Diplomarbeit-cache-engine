// #31 — Regressions-Gate der E4-XML-Workload-Drive (submodul-CI-konform: liest <workload> ueber den ce-DOM-
// Reader, kein Bump). Gate-frei: reine Host-Logik auf synthetischem XML-String, kein Treiber-Lauf, kein #156.

#include "messreihen_workload.hpp"

#include <cstdio>
#include <string_view>

namespace mw  = comdare::messung;
namespace wg  = comdare::workload_generator;
namespace cxr = comdare::common::xml;

static int  g_fail = 0;
static void check(bool ok, char const* msg) {
    std::printf("  [%s] %s\n", ok ? "OK" : "FAIL", msg);
    if (!ok) ++g_fail;
}

int main() {
    using W = wg::YcsbWorkload;

    // ycsb_workload_from_string: Kurzform + kanonisch + Fallback (nullopt).
    check(mw::ycsb_workload_from_string("A") == W::A, "'A' -> A");
    check(mw::ycsb_workload_from_string("YCSB_E") == W::E, "'YCSB_E' -> E");
    check(mw::ycsb_workload_from_string("F") == W::F, "'F' -> F");
    check(!mw::ycsb_workload_from_string("X").has_value(), "'X' -> nullopt (kein erfundenes Vokabular)");
    check(!mw::ycsb_workload_from_string("").has_value(), "'' -> nullopt");

    // workloads_from_root: synthetisches <comdare_messreihen> ueber den ce-DOM-Reader.
    char const* xmlstr = "<comdare_messreihen version=\"1\">"
                         "  <messreihe id=\"A_defined\"><mode>defined</mode><workload>A</workload></messreihe>"
                         "  <messreihe id=\"B\"><mode>full</mode><workload>YCSB_E</workload></messreihe>"
                         "  <messreihe id=\"C\"><mode>full</mode></messreihe>"
                         "  <messreihe><workload>D</workload></messreihe>" // ohne id -> ignoriert
                         "</comdare_messreihen>";
    auto        root   = cxr::parse_document(xmlstr);
    check(root.has_value(), "parse_document ok (ce-DOM-Reader)");
    if (root) {
        auto m = mw::workloads_from_root(*root);
        check(m.size() == 2, "genau 2 Reihen mit gueltigem id+<workload>");
        check(m.count("A_defined") != 0 && m["A_defined"] == W::A, "A_defined -> A");
        check(m.count("B") != 0 && m["B"] == W::E, "B -> E (YCSB_E)");
        check(m.find("C") == m.end(), "C ohne <workload> -> kein Eintrag (Aufrufer behaelt Default)");
    }

    std::printf(g_fail == 0 ? "#31 MESSREIHEN-WORKLOAD: ALLE OK\n" : "#31 MESSREIHEN-WORKLOAD: %d FAIL\n", g_fail);
    return g_fail == 0 ? 0 : 1;
}
