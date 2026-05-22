#pragma once
// V34.B.1 (2026-05-21) - MessreiheReportExporter: CSV + TikZ aus MessreiheReport
//
// @subsystem MessungDriver
// @phase_owner MessungDriver
//
// V33.C.1 V32Orchestrator liefert MessreiheReport. Dieser Exporter macht daraus:
// 1. CSV-Datei mit allen PermutationOutcomes (eine Zeile pro Permutation)
// 2. TikZ-Summary mit Wins/Ties/Losses-Bilanz pro Achse
//
// Header-only, keine externe Dependency. Folgekompatibel zu thesis/chapters/06_ergebnisse.tex.

#include "v32_orchestrator.hpp"

#include <filesystem>
#include <fstream>
#include <map>
#include <sstream>
#include <string>
#include <string_view>

namespace comdare::diplomarbeit::messung_driver::v32 {

struct ExportStatus {
    enum class Code { Ok, IoError, EmptyReport };
    Code code {Code::Ok};
    std::string message;
    [[nodiscard]] bool ok() const noexcept { return code == Code::Ok; }
};

/**
 * @brief MessreiheReportExporter - persistiert MessreiheReport in CSV + TikZ
 * @subsystem MessungDriver
 *
 * Beispiel:
 *   auto report = orchestrator.run_default_lookup_messreihe(workload);
 *   MessreiheReportExporter ex;
 *   ex.write_csv(report, "results.csv");
 *   ex.write_tikz_summary(report, "summary.tex");
 */
class MessreiheReportExporter {
public:
    /// CSV-Export: 12 Spalten pro PermutationOutcome
    [[nodiscard]] ExportStatus write_csv(const MessreiheReport& report,
                                         const std::filesystem::path& out_path) const {
        if (report.outcomes.empty()) {
            return {ExportStatus::Code::EmptyReport, "report has no outcomes"};
        }
        std::ofstream f(out_path);
        if (!f.is_open()) {
            return {ExportStatus::Code::IoError, "cannot open output: " + out_path.string()};
        }
        f << "axis_id,variant_name,verdict,welch_p_value,throughput_ratio,"
          << "ee_a_engine,ee_a_throughput,ee_a_p99_ns,ee_a_cache_misses,"
          << "ee_b_engine,ee_b_throughput,ee_b_p99_ns\n";
        for (const auto& outcome : report.outcomes) {
            f << outcome.axis_id << ','
              << outcome.variant_name << ','
              << verdict_string(outcome.verdict) << ','
              << outcome.welch_p_value << ','
              << outcome.throughput_ratio << ','
              << outcome.ee_a_result.engine_name << ','
              << outcome.ee_a_result.throughput_ops_per_sec << ','
              << outcome.ee_a_result.latency_p99.count() << ','
              << outcome.ee_a_result.total_cache_misses << ','
              << outcome.ee_b_result.engine_name << ','
              << outcome.ee_b_result.throughput_ops_per_sec << ','
              << outcome.ee_b_result.latency_p99.count() << '\n';
        }
        return {};
    }

    /// TikZ-Summary: Stacked-Bar Wins/Ties/Losses pro Achse
    [[nodiscard]] ExportStatus write_tikz_summary(const MessreiheReport& report,
                                                  const std::filesystem::path& out_path) const {
        if (report.outcomes.empty()) {
            return {ExportStatus::Code::EmptyReport, "report has no outcomes"};
        }
        std::ofstream f(out_path);
        if (!f.is_open()) {
            return {ExportStatus::Code::IoError, "cannot open output: " + out_path.string()};
        }

        std::map<std::string, std::array<std::size_t, 3>> per_axis;  // [ee_a_wins, ee_b_wins, ties]
        for (const auto& o : report.outcomes) {
            auto& bucket = per_axis[o.axis_id];
            switch (o.verdict) {
                case cmd::CompareEngineCommand::Verdict::EE_A_Wins: ++bucket[0]; break;
                case cmd::CompareEngineCommand::Verdict::EE_B_Wins: ++bucket[1]; break;
                case cmd::CompareEngineCommand::Verdict::Tie:       ++bucket[2]; break;
                default: break;
            }
        }

        f << "% V34.B.1 TikZ-Summary fuer MessreiheReport\n"
          << "% Pro Achse: stacked-bar (EE-A wins, EE-B wins, Ties)\n"
          << "\\begin{tikzpicture}\n"
          << "\\begin{axis}[\n"
          << "    ybar stacked, bar width=12pt,\n"
          << "    legend style={at={(0.5,-0.18)}, anchor=north, legend columns=3},\n"
          << "    ylabel={Anzahl Permutationen},\n"
          << "    xlabel={Achse},\n"
          << "    symbolic x coords={";
        bool first = true;
        for (const auto& [axis_id, _] : per_axis) {
            if (!first) f << ',';
            f << axis_id;
            first = false;
        }
        f << "},\n"
          << "    xtick=data,\n"
          << "    ymin=0]\n"
          << "\\addplot+[fill=green!60] coordinates {";
        for (const auto& [axis_id, b] : per_axis) {
            f << "(" << axis_id << ',' << b[0] << ") ";
        }
        f << "};\n"
          << "\\addplot+[fill=orange!60] coordinates {";
        for (const auto& [axis_id, b] : per_axis) {
            f << "(" << axis_id << ',' << b[1] << ") ";
        }
        f << "};\n"
          << "\\addplot+[fill=gray!40] coordinates {";
        for (const auto& [axis_id, b] : per_axis) {
            f << "(" << axis_id << ',' << b[2] << ") ";
        }
        f << "};\n"
          << "\\legend{EE-A wins (CacheEngine), EE-B wins (PrtArt), Tie}\n"
          << "\\end{axis}\n"
          << "\\end{tikzpicture}\n";
        f << "% Total: axes=" << report.total_axes
          << " variants=" << report.total_variants
          << " ee_a_wins=" << report.ee_a_wins
          << " ee_b_wins=" << report.ee_b_wins
          << " ties=" << report.ties
          << " elapsed_ns=" << report.total_elapsed.count() << "\n";
        return {};
    }

private:
    static std::string_view verdict_string(cmd::CompareEngineCommand::Verdict v) {
        switch (v) {
            case cmd::CompareEngineCommand::Verdict::EE_A_Wins:        return "EE_A_Wins";
            case cmd::CompareEngineCommand::Verdict::EE_B_Wins:        return "EE_B_Wins";
            case cmd::CompareEngineCommand::Verdict::Tie:              return "Tie";
            case cmd::CompareEngineCommand::Verdict::InconclusiveData: return "Inconclusive";
        }
        return "Unknown";
    }
};

}  // namespace comdare::diplomarbeit::messung_driver::v32
