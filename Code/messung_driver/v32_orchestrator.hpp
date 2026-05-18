#pragma once
// V32.GG.1 (2026-05-18 spaet) - V32 Orchestrator fuer parallele EE-Submission
//
// AA.2-Korrektur: messung_driver registriert BEIDE ExecutionEngines beim CEB
// (CE-as-EE-A + PrtArt-as-EE-B) parallel via Command-Pattern.
//
// V31.F-Code in main.cpp bleibt unveraendert (Memory-Direktive).
// V32-Orchestrator wird in main.cpp ueber V32_ENABLE Compile-Flag aktiviert.

#include <memory>
#include <string_view>
#include <vector>

// Forward-Declarations zu vermeiden Cross-Submodule include-cycle
namespace comdare::cache_engine::abi {
class CacheEngineExecutionEngineAdapter;
}
namespace comdare::prt_art::identity {
class PrtArtExecutionEngineAdapter;
}

namespace comdare::diplomarbeit::messung_driver::v32 {

/**
 * @brief V32Orchestrator - parallel EE-Submission an CacheEngineBuilder (AA.2)
 * @subsystem MessungDriver (Subsystem 1 Outer-Loop)
 *
 * Korrektur AA.2: CacheEngineBuilder orchestriert BEIDE ExecutionEngines
 * (CE-as-EE-A + PrtArt-as-EE-B) parallel via Command-Pattern.
 *
 * Diese Klasse ist V32-Outer-Loop, der die V31-CacheEngineBuilder-API
 * minimal-invasiv erweitert.
 *
 * V32-Workflow:
 *   1. Construct CE-as-EE-A Adapter + PrtArt-as-EE-B Adapter
 *   2. ceb.submit_engine(ee_a)
 *   3. ceb.submit_engine(ee_b)
 *   4. ceb.execute_messreihe(config_xml, mode=defined|full|full_sampled)
 *      - Iteriert Permutationen
 *      - Pro Permutation: ExecuteEngineCommand fuer beide EE-A + EE-B
 *      - Pro Permutation: CompareEngineCommand (F15-Vergleich)
 *      - Pro fehlender Achsen-Spec: AutoPermutateAxisCommand (AA.3 Default-Lookup)
 *   5. ResultAggregator.collect() pro Tupel
 *   6. binary_to_csv + csv_to_latex + diagram_generator
 */
class V32Orchestrator {
public:
    /// Konstruiert beide ExecutionEngine-Adapter
    V32Orchestrator() {
        // V32.GG.1 Skelett - konkrete Konstruktion in V32.2+ Sprint:
        // ee_a_ = std::make_shared<CacheEngineExecutionEngineAdapter>();
        // ee_b_ = std::make_shared<PrtArtExecutionEngineAdapter>();
    }

    /// Registriert beide EEs beim CacheEngineBuilder (Submission)
    void submit_to_builder(/* CacheEngineBuilder& ceb */) {
        // V32.GG.1 Skelett:
        // ceb.submit_engine(ee_a_);
        // ceb.submit_engine(ee_b_);
    }

    /// V32-Lifecycle: execute eine Messreihe mit parallel EE-A + EE-B
    int execute_messreihe(std::string_view config_xml,
                          std::string_view mode = "defined") {
        // V32.GG.1 Skelett - V32.2+ Sprint:
        // 1. ceb.load_config(config_xml)
        // 2. ceb.set_mode(mode)
        // 3. ceb.execute()  // intern: ICommand-Liste pro Permutation
        // 4. aggregator.write_binary_results(output_path)
        (void)config_xml;
        (void)mode;
        return 0;
    }

private:
    std::shared_ptr<comdare::cache_engine::abi::CacheEngineExecutionEngineAdapter> ee_a_;
    std::shared_ptr<comdare::prt_art::identity::PrtArtExecutionEngineAdapter> ee_b_;
};

}  // namespace comdare::diplomarbeit::messung_driver::v32
