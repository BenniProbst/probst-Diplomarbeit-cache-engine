#pragma once
// V32.GG.1 (2026-05-18) + V33.C.1 (2026-05-21) - V32 Orchestrator: parallele EE-Submission
//
// AA.2-Korrektur: messung_driver registriert BEIDE ExecutionEngines beim CEB
// (CE-as-EE-A + PrtArt-as-EE-B) parallel via Command-Pattern.
//
// V31.F-Code in main.cpp bleibt unveraendert (Memory-Direktive).
// V32-Orchestrator wird in main.cpp ueber COMDARE_V32_ENABLE Compile-Flag aktiviert.

#include "cache_engine/abi/cache_engine_execution_engine_adapter.hpp"
#include "cache_engine/builder/commands/auto_permutator.hpp"
#include "cache_engine/builder/commands/axis_library_registry.hpp"
#include "cache_engine/builder/commands/compare_engine_command.hpp"
#include "cache_engine/builder/commands/execute_engine_command.hpp"
#include "cache_engine/builder/commands/workload.hpp"
#include "prt_art/default_lookup/default_lookup_registry.hpp"
#include "prt_art/identity/prt_art_execution_engine_adapter.hpp"

#include <chrono>
#include <future>
#include <memory>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::diplomarbeit::messung_driver::v32 {

namespace cmd = comdare::cache_engine::builder::commands;
namespace dl = comdare::prt_art::default_lookup;

/**
 * @brief PermutationOutcome - Ergebnis einer Permutation (EE-A vs EE-B Vergleich)
 * @subsystem MessungDriver
 */
struct PermutationOutcome {
    std::string axis_id;
    std::string variant_name;
    cmd::ExecutionResult ee_a_result;
    cmd::ExecutionResult ee_b_result;
    cmd::CompareEngineCommand::Verdict verdict {cmd::CompareEngineCommand::Verdict::InconclusiveData};
    double welch_p_value {1.0};
    double throughput_ratio {0.0};
};

/**
 * @brief MessreiheReport - Aggregat-Ergebnis ueber alle Permutationen
 * @subsystem MessungDriver
 */
struct MessreiheReport {
    std::vector<PermutationOutcome> outcomes;
    std::size_t total_axes {0};
    std::size_t total_variants {0};
    std::size_t ee_a_wins {0};
    std::size_t ee_b_wins {0};
    std::size_t ties {0};
    std::chrono::nanoseconds total_elapsed {};
};

/**
 * @brief V32Orchestrator - parallel EE-Submission an CacheEngineBuilder (AA.2)
 * @subsystem MessungDriver (Subsystem 1 Outer-Loop)
 *
 * V33.C.1 Vollausbau:
 * - run_default_lookup_messreihe(): konsumiert prt_art DefaultLookupRegistry,
 *   iteriert pro Achse die CE-Bibliothek-Variants, fuehrt parallel EE-A + EE-B
 *   via std::async, vergleicht via Welch's t-Test.
 * - Result-Aggregation in MessreiheReport.
 */
class V32Orchestrator {
public:
    V32Orchestrator() = default;

    /// V32.GG.1 Skelett-Kompatibilitaet
    void submit_to_builder() {
        // Im V33.C.1 Vollausbau: ExecuteEngineCommands werden pro Permutation
        // direkt im run_default_lookup_messreihe() konstruiert + parallel ausgefuehrt.
    }

    /// V32.GG.1 Skelett-Kompatibilitaet (existierende Tests)
    int execute_messreihe(std::string_view config_xml,
                          std::string_view mode = "defined") {
        (void)config_xml;
        (void)mode;
        return 0;
    }

    /**
     * @brief V33.C.1 Hauptmethode: Default-Lookup-Messreihe ueber alle PRT-ART-Achsen
     *
     * Workflow:
     * 1. Enumerate DefaultLookupRegistry (9 Achsen)
     * 2. Pro Achse: AxisLibraryRegistry.lookup() -> Variant-Liste
     * 3. Pro Variant: std::async(EE-A) + std::async(EE-B), get() beide
     * 4. CompareEngineCommand mit beiden Results
     * 5. Outcome in Report sammeln
     *
     * @param workload Gemeinsamer Workload fuer EE-A + EE-B
     * @return MessreiheReport mit kompletter Outcome-Liste + Statistik
     */
    [[nodiscard]] MessreiheReport run_default_lookup_messreihe(const cmd::Workload& workload) {
        MessreiheReport report;
        const auto start = std::chrono::steady_clock::now();

        constexpr auto default_axes = dl::DefaultLookupRegistry::enumerate();
        report.total_axes = default_axes.size();

        for (const auto& axis : default_axes) {
            auto variants = cmd::AxisLibraryRegistry::lookup(std::string(axis.axis_id));
            for (const auto& variant : variants) {
                ++report.total_variants;
                auto outcome = execute_one_permutation(axis.axis_id, variant.variant_name, workload);
                switch (outcome.verdict) {
                    case cmd::CompareEngineCommand::Verdict::EE_A_Wins: ++report.ee_a_wins; break;
                    case cmd::CompareEngineCommand::Verdict::EE_B_Wins: ++report.ee_b_wins; break;
                    case cmd::CompareEngineCommand::Verdict::Tie:       ++report.ties;       break;
                    default: break;
                }
                report.outcomes.push_back(std::move(outcome));
            }
        }

        report.total_elapsed = std::chrono::steady_clock::now() - start;
        return report;
    }

    /// V33.C.1 Einzel-Permutation: parallel EE-A + EE-B + Vergleich
    /// V34.A.3 (2026-05-21): nutzt echte Adapter mit as_engine_callable() statt Simulation
    [[nodiscard]] PermutationOutcome execute_one_permutation(
        std::string_view axis_id,
        std::string_view variant_name,
        const cmd::Workload& workload)
    {
        PermutationOutcome outcome;
        outcome.axis_id = std::string(axis_id);
        outcome.variant_name = std::string(variant_name);

        comdare::cache_engine::abi::CacheEngineExecutionEngineAdapter<> ee_a;
        comdare::prt_art::identity::PrtArtExecutionEngineAdapter<> ee_b;

        auto callable_a = ee_a.as_engine_callable();
        auto callable_b = ee_b.as_engine_callable();

        auto fut_a = std::async(std::launch::async, [&]() {
            cmd::ExecuteEngineCommand cmd_a(ee_a.engine_name(), workload, callable_a);
            cmd_a.execute();
            return cmd_a.result();
        });
        auto fut_b = std::async(std::launch::async, [&]() {
            cmd::ExecuteEngineCommand cmd_b(ee_b.engine_name(), workload, callable_b);
            cmd_b.execute();
            return cmd_b.result();
        });

        outcome.ee_a_result = fut_a.get();
        outcome.ee_b_result = fut_b.get();

        cmd::CompareEngineCommand compare(outcome.ee_a_result, outcome.ee_b_result);
        compare.execute();
        outcome.verdict = compare.verdict();
        outcome.throughput_ratio = compare.throughput_ratio();
        if (compare.welch().valid) {
            outcome.welch_p_value = compare.welch().p_value;
        }
        return outcome;
    }
};

}  // namespace comdare::diplomarbeit::messung_driver::v32
