#pragma once
// DEPRECATED-BY-DESIGN (Fork A, User 2026-07-16): Parallel-Antrieb wird durch die CEB-Bruecke ersetzt
// (3-Phasen-XML -> offizieller E4/CEB/DLL-Pfad -> 16-col-CSV); INC-A..E bleiben gueltig; NICHT weiterentwickeln.
//
// INC-F (C.1, 2026-07-14) -- v32_katalog_driver: die W4-Gate-konforme Ersatz-Verdrahtung des Surrogats im
// EE-A/EE-B-Vergleich. Statt der beiden Surrogat-Adapter (die CE- und die Pruefling-ExecutionEngine mit ihrem
// std-Hash-Backend, v32_orchestrator.hpp:154-155 -- die verbotenen Alt-Pfad-Marker sind bewusst NICHT literal
// in diesem Header, damit die W4-Quellen-grep den Treiber sauber belegt)
// treibt diese Variante BEIDE ExecutionEngines ueber den REALEN CEB-Katalog-Pfad:
//   * eine echte SOTA-/Prueflings-Komposition wird als IObservableTier materialisiert
//     (SearchAlgorithmAbiAdapter<SearchAlgorithmAnatomy<C>> -- EXAKT die Form, die
//     COMDARE_DEFINE_ANATOMY_MODULE emittiert und der AnatomyModuleLoader zur Laufzeit liefert),
//   * das Pruefdock-Konformitaets-Gate (run_conformance_gate gegen std::map<uint64,uint64>) laeuft VOR der Messung,
//   * die per-Op-Latenzen fliessen UNVERAENDERT ueber ExecuteEngineCommand -> ExecutionResult::latency_samples_ns
//     -> CompareEngineCommand/Welch (execute_engine_command.hpp:101-137, compare_engine_command.hpp:84-92).
//
// W4-GATE (Ledger #### W4 :967-969, "Ein 'echter Adapter'-Neubau waere ein vierter Laufzeit-Pfad ... nie das
// Hash-Backend-Surrogat"): der Mess-Pfad referenziert AUSSCHLIESSLICH reale Kompositionen -- HotComposition
// (Stufe1_CeOnly, CE-SOTA-Baseline) und HotPrtStufe2ReplaceComposition (Stufe2_PrueflingReplace, das
// PrtArtPathCompressionOrgan ersetzt den path_compression-Slot). KEIN std-Hash-Backend-Surrogat, KEIN
// 90ns-Stub, KEIN vierter Laufzeit-Pfad an der Architektur vorbei. Die vier verbotenen Alt-Pfad-Marker
// kommen in DIESER Quelle bewusst NICHT literal vor (W4-grep). Dies ist
// derselbe Katalog-Pfad wie in sota_catalog.hpp (render_sota_module_source -> COMDARE_DEFINE_ANATOMY_MODULE);
// die Abstraktheit des Merge-Slots bleibt UNBERUEHRT (keine 19-Achsen-Vervollstaendigung, W4 :969). Das
// Gegenstueck test_v32_katalog_driver.cpp greppt diese Quelle literal + belegt die Katalog-Typ-Identitaet.
//
// INERT: dieser Header hat KEINEN Konsumenten im Default-Build. Er wird NUR unter COMDARE_V32_DRIVER_ENABLE
// (Code/02_messung_driver/CMakeLists.txt) + COMDARE_MEASUREMENT_ON kompiliert. v32_orchestrator.hpp bleibt
// BYTE-UNBERUEHRT -> Default-Build byte-identisch, golden-320 unveraendert (Flag OFF).
//
// @pattern GoF Object Adapter (Gamma/Helm/Johnson/Vlissides 1994, S.139): KatalogTierEngineCallable adaptiert
//   die IObservableTier-Gattungs-vtable (tier_insert/tier_lookup) an die cmd::EngineCallable-Signatur der
//   ExecuteEngineCommand -- ein injizierter Adaptee (der reale Tier), kein Neuerfinden der Mess-Schleife.
// @task INC-F (C.1) -- Surrogat -> reale CEB-Katalog-Tier im EE-A/EE-B-Vergleich (W4-Gate, INERT)
// @related v32_orchestrator.hpp (Surrogat-Pfad, deprecatet-aber-nicht-geloescht)
// @related cache_engine builder/commands/execute_engine_command.hpp (EngineCallable/latency_samples_ns)
// @related cache_engine profile_facade/sota_catalog.hpp (render_sota_module_source -- selbe Katalog-Kompositionen)
// @related cache_engine builder/experiment_tree/perm_runner.hpp (run_observable_perm -- selbe Tier-Antriebs-Semantik)

#include <builder/commands/compare_engine_command.hpp> // CompareEngineCommand / Verdict / Welch
#include <builder/commands/execute_engine_command.hpp> // EngineCallable / ExecuteEngineCommand / OperationOutcome / ExecutionResult
#include <builder/commands/workload.hpp>               // Workload / WorkloadKind

#include <anatomy/abi_adapter.hpp>                  // SearchAlgorithmAbiAdapter (MEASUREMENT_ON -> IObservableTier)
#include <anatomy/observable_tier.hpp>              // IObservableTier (der CEB-Katalog-Tier ueber die Gattungs-vtable)
#include <anatomy/search_algorithm_anatomy.hpp>     // SearchAlgorithmAnatomy<Composition>
#include <builder/pruef_dock/conformance_gate.hpp>  // run_conformance_gate (Pruefdock gegen std::map-Oracle)
#include <compositions/hot_reference.hpp>           // HotComposition (Stufe1_CeOnly CE-SOTA-Baseline)
#include <compositions/prt_art_merge_reference.hpp> // HotPrtStufe2ReplaceComposition (Stufe2, PRT-Slot)
#include <compositions/prt_art_reference.hpp>       // PrtArtComposition (echtes Pruefling-Lebewesen, W4-Beleg)

#include <cstdint>
#include <string>
#include <string_view>

namespace comdare::diplomarbeit::messung_driver::v32::katalog {

namespace cmd  = ::comdare::cache_engine::builder::commands;
namespace an   = ::comdare::cache_engine::anatomy;
namespace comp = ::comdare::cache_engine::compositions;
namespace pd   = ::comdare::cache_engine::builder::pruef_dock;

// W4-Compile-Gate: die Mess-Pfad-Kompositionen sind die REALEN Katalog-Lebewesen (compile-time praesent, KEIN
// Surrogat-Typ). Genau diese Typen emittiert sota_catalog.hpp als COMDARE_DEFINE_ANATOMY_MODULE-Quelle.
static_assert(!std::string_view{comp::HotComposition::name}.empty(),
              "W4: EE-A muss die reale CE-SOTA-Komposition (Stufe1_CeOnly) treiben");
static_assert(!std::string_view{comp::HotPrtStufe2ReplaceComposition::name}.empty(),
              "W4: EE-B muss die reale Pruefling-Ersetzt-Komposition (Stufe2_PrueflingReplace) treiben");
static_assert(!std::string_view{comp::PrtArtComposition::name}.empty(),
              "W4: das echte PrtArtComposition-Lebewesen ist compile-time im Katalog-Pfad (kein Stub)");

/// KatalogPermutationOutcome -- das Mess-Ergebnis EINER Permutation ueber den realen Katalog-Pfad. Spiegelt die
/// Mess-Felder von v32::PermutationOutcome (ee_a/ee_b/verdict/welch/throughput), ist aber BEWUSST eigenstaendig,
/// damit dieser Header KEINE Surrogat-Adapter (v32_orchestrator.hpp) einzieht -> W4-rein (grep-belegt).
struct KatalogPermutationOutcome {
    std::string                        axis_id;
    std::string                        variant_name;
    cmd::ExecutionResult               ee_a_result; ///< Stufe1_CeOnly-Katalog-Tier (echte Per-Op-Latenzen)
    cmd::ExecutionResult               ee_b_result; ///< Stufe2_PrueflingReplace-Katalog-Tier (echte Per-Op-Latenzen)
    cmd::CompareEngineCommand::Verdict verdict{cmd::CompareEngineCommand::Verdict::InconclusiveData};
    double                             welch_p_value{1.0};
    double                             throughput_ratio{0.0};
    std::uint64_t                      ee_a_conformance_cases{0}; ///< Pruefdock: geprueften std::map-Zusicherungen
    std::uint64_t                      ee_b_conformance_cases{0};
    bool                               ee_a_conformance_passed{false};
    bool                               ee_b_conformance_passed{false};
};

/// KatalogTierEngineCallable -- GoF Object Adapter: adaptiert einen realen IObservableTier an die
/// cmd::EngineCallable-Signatur. Pro Op wird EINE reale Gattungs-Operation (insert + lookup ueber den
/// gemeinsamen uint64-Key-Raum nach Umstufung-B) auf der geladenen Komposition getrieben; ExecuteEngineCommand
/// timet jeden Aufruf -> die per-Op-Latenz stammt aus dem ECHTEN Tier (kein Surrogat, keine Simulation).
class KatalogTierEngineCallable {
public:
    explicit KatalogTierEngineCallable(an::IObservableTier& tier) noexcept : tier_{&tier} {}

    cmd::OperationOutcome operator()(std::size_t op, cmd::WorkloadKind /*kind*/, std::uint64_t seed) const noexcept {
        // Deterministischer Schluessel je Op (gleiche Config + Seed => reproduzierbare Sequenz je Engine).
        std::uint64_t const key = (static_cast<std::uint64_t>(op) * 2654435761ull) ^ seed;
        (void)tier_->tier_insert(key, key * 7u +
                                          1u); // reale Gattungs-Op #1 (T0 search_algo + T3 path_compression gekoppelt)
        std::uint64_t         v   = 0;
        bool const            hit = tier_->tier_lookup(key, &v); // reale Gattungs-Op #2
        cmd::OperationOutcome out{};
        out.cache_misses_delta = 0; // ehrlich: ohne PMC in-process nicht messbar (kein Fabrikat)
        out.bytes_touched      = sizeof(std::uint64_t) * 2; // key + value ueber die vtable beruehrt
        out.success            = hit; // gerade eingefuegter Key MUSS gefunden werden (std::map-Konform)
        return out;
    }

private:
    an::IObservableTier* tier_;
};

/// drive_one_engine -- materialisiert eine reale Komposition als IObservableTier (CEB-Pfad-Form), faehrt das
/// Pruefdock-Konformitaets-Gate (std::map-Oracle) und misst danach die per-Op-Latenzen ueber
/// ExecuteEngineCommand (-> ExecutionResult::latency_samples_ns). C = die reale Katalog-Komposition.
template <class C>
[[nodiscard]] inline cmd::ExecutionResult drive_one_engine(std::string_view engine_name, cmd::Workload const& workload,
                                                           std::uint64_t& conformance_cases, bool& conformance_passed) {
    using AnatomyT = an::SearchAlgorithmAnatomy<C>;
    an::SearchAlgorithmAbiAdapter<AnatomyT> tier; // == COMDARE_DEFINE_ANATOMY_MODULE-Adapter, hier in-process (INERT)
    auto* obs = dynamic_cast<an::IObservableTier*>(static_cast<an::IAnatomyBase*>(&tier));

    // (Pruefdock) Konformitaets-Gate VOR der Messung: die Gattungs-Huelle gegen std::map<uint64,uint64> als Oracle.
    auto const cg      = pd::run_conformance_gate(*obs); // IObservableTier IS-A IDriveableTier
    conformance_cases  = cg.cases_total;
    conformance_passed = cg.passed();
    obs->tier_clear(); // frischer Zustand fuer den Mess-Lauf (das Gate hat das Tier befuellt/geleert)

    KatalogTierEngineCallable callable{*obs};
    cmd::ExecuteEngineCommand cmd_engine(engine_name, workload, callable);
    cmd_engine.execute(); // timet jeden callable-Aufruf -> latency_samples_ns aus dem REALEN Tier
    return cmd_engine.result();
}

/// execute_one_permutation_katalog -- die W4-Gate-Variante von V32Orchestrator::execute_one_permutation
/// (v32_orchestrator.hpp:148-180). EE-A = reale Stufe1_CeOnly-Katalog-Tier (StufeOneC, CE-SOTA-Baseline),
/// EE-B = reale Stufe2_PrueflingReplace-Katalog-Tier (StufeTwoC, PRT ersetzt den path_compression-Slot). BEIDE
/// ueber den CEB-Pfad (IObservableTier -> Pruefdock -> ExecuteEngineCommand); die per-Op-Latenzen ->
/// CompareEngineCommand/Welch (UNVERAENDERT). Die Defaults sind das gepinnte Reihe-A-Paar (HOT-Host);
/// der Aufrufer (Stufe G) waehlt per-Host ueber die Template-Parameter.
template <class StufeOneC = comp::HotComposition, class StufeTwoC = comp::HotPrtStufe2ReplaceComposition>
[[nodiscard]] inline KatalogPermutationOutcome execute_one_permutation_katalog(std::string_view     axis_id,
                                                                               std::string_view     variant_name,
                                                                               cmd::Workload const& workload) {
    KatalogPermutationOutcome outcome;
    outcome.axis_id      = std::string(axis_id);
    outcome.variant_name = std::string(variant_name);

    outcome.ee_a_result = drive_one_engine<StufeOneC>("Stufe1_CeOnly-Katalog-Tier(EE-A)", workload,
                                                      outcome.ee_a_conformance_cases, outcome.ee_a_conformance_passed);
    outcome.ee_b_result = drive_one_engine<StufeTwoC>("Stufe2_PrueflingReplace-Katalog-Tier(EE-B)", workload,
                                                      outcome.ee_b_conformance_cases, outcome.ee_b_conformance_passed);

    cmd::CompareEngineCommand compare(outcome.ee_a_result, outcome.ee_b_result);
    compare.execute();
    outcome.verdict          = compare.verdict();
    outcome.throughput_ratio = compare.throughput_ratio();
    if (compare.welch().valid) { outcome.welch_p_value = compare.welch().p_value; }
    return outcome;
}

} // namespace comdare::diplomarbeit::messung_driver::v32::katalog
