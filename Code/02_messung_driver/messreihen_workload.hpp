#pragma once
// #31 (2026-07-11) — E4-XML Workload-Drive INNERHALB der Submodul-CI-Grenze.
//
// Problem: der E4-XML-Abnahmekriterium-Rest (#229/#31) = den hartkodierten Workload (main.cpp
// `w.workload = YcsbWorkload::C`) durch den je <messreihe> aus XML gelesenen ersetzen. Die naheliegende
// Loesung (workload-Feld in ce XmlConfigParser::Messreihe) braucht einen ce-Submodul-Bump, den der super-CI-
// Job-Token NICHT fetchen kann (reference_super_ci_cannot_fetch_new_ce_submodule_commits). Ein super-seitiger
// Regex-Reader waere ein Phase-7-Konsolidierungs-Regress (der lokale Regex-Reader wurde bewusst entfernt).
//
// Loesung (kein Bump, kein Regress): lies das Zusatz-Tag <workload> ueber den BESTEHENDEN, bei c022ce05
// vorhandenen ce-DOM-Reader `comdare::common::xml` (xml_reader.hpp). Der typisierte
// `XmlConfigParser::load_messreihen` bleibt die EINE Quelle fuer id/mode/sota (Phase-7 respektiert); hier wird
// NUR das <workload>-Tag ergaenzt, das der typisierte Parser (noch) nicht exponiert. Reine ce-Bibliotheks-
// Nutzung, keine neue Parser-Quelle.
//
// Fork-Aufloesung (User-Freigabe 2026-07-11, Fork-Analyse 20260709-v32-fork-analyse-31-e4xml):
//   R1 (Vokabular): A-F ist thesis-kanonisch (YCSB, workload_generator.hpp:22). OP-1..6/Custom = dokumentierte
//     Folge (measurement_category-Achse), hier bewusst NICHT — kein erfundenes Vokabular.
//   R2 (Doppelquelle): das messreihe-<workload> ist autoritativ fuer die WorkloadOptions des messreihen-Pfads
//     (der bisher flat-C hartkodierte). test_data_sets.xml bleibt der ExperimentDriver-Dataset-Pfad (getrennt).
//   R3 (Freeze): additiv, ausserhalb der V31.F-Orchestrator-Logik. Fehlendes <workload> -> Fallback = heute.

#include "xml_config_parser/xml_reader.hpp"                  // comdare::common::xml::{XmlNode, parse_document}
#include <comdare/workload_generator/workload_generator.hpp> // workload_generator::YcsbWorkload

#include <filesystem>
#include <fstream>
#include <map>
#include <optional>
#include <sstream>
#include <string>
#include <string_view>

namespace comdare::messung {

// A-F (thesis-kanonisch). Akzeptiert kurz "A".."F" UND kanonisch "YCSB_A".."YCSB_F" (= workload_to_string,
// experiment_driver.cpp:428). Unbekannt/leer -> nullopt (Aufrufer nutzt seinen bisherigen Default).
[[nodiscard]] inline std::optional<workload_generator::YcsbWorkload> ycsb_workload_from_string(std::string_view s) {
    using W = workload_generator::YcsbWorkload;
    if (s == "A" || s == "YCSB_A") return W::A;
    if (s == "B" || s == "YCSB_B") return W::B;
    if (s == "C" || s == "YCSB_C") return W::C;
    if (s == "D" || s == "YCSB_D") return W::D;
    if (s == "E" || s == "YCSB_E") return W::E;
    if (s == "F" || s == "YCSB_F") return W::F;
    return std::nullopt;
}

// Aus dem <comdare_messreihen>-Wurzelknoten: id -> Workload je <messreihe id=".."><workload>X</workload>.
// Kein <workload> / unbekannter Wert -> KEIN Eintrag (der Aufrufer behaelt seinen Default). Testbar ohne Datei.
[[nodiscard]] inline std::map<std::string, workload_generator::YcsbWorkload>
workloads_from_root(common::xml::XmlNode const& root) {
    std::map<std::string, workload_generator::YcsbWorkload> out;
    for (auto const* mr : root.children_named("messreihe")) {
        std::string const id = mr->attr("id");
        if (id.empty()) continue;
        if (auto const* wl = mr->child("workload"))
            if (auto w = ycsb_workload_from_string(wl->text)) out.emplace(id, *w);
    }
    return out;
}

// Datei-Variante: liest die messreihen.xml ueber den ce-DOM-Reader. Fehlende/ungueltige Datei -> leere Map
// (der Aufrufer behaelt fuer jede Reihe seinen Default; keine Fabrikation).
[[nodiscard]] inline std::map<std::string, workload_generator::YcsbWorkload>
parse_messreihe_workloads(std::filesystem::path const& xml_path) {
    std::ifstream in{xml_path};
    if (!in) return {};
    std::ostringstream ss;
    ss << in.rdbuf();
    auto root = common::xml::parse_document(ss.str());
    return root ? workloads_from_root(*root) : std::map<std::string, workload_generator::YcsbWorkload>{};
}

} // namespace comdare::messung
