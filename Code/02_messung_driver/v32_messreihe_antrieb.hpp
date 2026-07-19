#pragma once
// ── PL-0 PHASE-0-RECONCILE (2026-07-19) — DEPRECATION-STAND FORTGESCHRIEBEN ─────────────────────────────
// REAKTIVIERT ALS OFFIZIELLES SKELETT des Planer-Phasen-Walks (Roadmap 20260719 PL-0; Ledger §29-
// Praezisierung (a) + §30-Stufen-Zuordnung Planer=Mess / CEB=System / Tier=Organ): execute_messreihe
// (unten in diesem Header) ist die VOLL implementierte INC-G+H-Kette (parse -> validate -> Phasen-
// Strategy -> Katalog-Treiber -> CSV/TikZ) — INERT via main.cpp-Opt-in (COMDARE_RUN_V32_EXPERIMENT,
// doppelt gegatet, s. INERT-Block unten). Der return-0-Stub liegt NICHT hier, sondern in
// v32_orchestrator.hpp (V32Orchestrator::execute_messreihe). Phase 0 = Input-Umstellung unter
// WIEDERVERWENDUNG dieses Skeletts (PhaseStrategyFor + execute_messreihe als Planer-Phasen-Walk-
// Substrat) — NICHT neu schreiben, KEIN dritter Walk daneben (Bauplan 20260719 Phase-0-Blocker/
// Kritik 1; feedback_vor_aufgaben_erst_projektstruktur_analyse).
//
// Historisches Ruling (Fork A, User 2026-07-16 — fortgeschrieben, nicht geloescht): Parallel-Antrieb wird
// durch die CEB-Bruecke ersetzt (3-Phasen-XML -> offizieller E4/CEB/DLL-Pfad -> 16-col-CSV); INC-A..E
// bleiben gueltig. Das "NICHT weiterentwickeln" gilt FORT fuer den Surrogat-Strang (v32_orchestrator.hpp);
// fuer DIESES Skelett gilt seit PL-0: als Phase-0-Substrat andocken statt eine dritte Engine bauen.
//
// INC-G (C.2) + INC-H (C.3), 2026-07-14 -- v32_messreihe_antrieb: die W4-Gate-konforme Verdrahtung von
// execute_messreihe. Der EINE offizielle XML-getriebene Weg fuer das comdare_experiment-Profil:
//
//   parse_experiment_profile (INC-D)            -> ExperimentProfile (rein-lesend, common-Schicht)
//     -> validate_experiment_profile (INC-D)    -> Abbruch vor jedem Antrieb bei ungueltigem Profil
//       -> je <phase>: PhaseStrategyFor<merge>  (INC-E, compile-time Strategy je MergeStrategy)
//         -> INC-F-Katalog-Treiber              (reale IObservableTier -> Pruefdock -> Messsystem -> Welch)
//           -> MessreiheReport                  (Akkumulat ueber alle Phasen/Permutationen)
//             -> messreihe_report_exporter      (INC-H: 12-Spalten-CSV + TikZ Wins/Ties/Losses)
//
// mode (defined|full|full_sampled) steuert die ENUMERATIONS-BREITE (wie viele OP-Typen je Phase gemessen
// werden); die Phase (merge) steuert den Kompositionalen Join -- ORTHOGONAL (Doku 14 §18-§19, pruefling_merge.hpp).
//
// ── W4-GATE ──────────────────────────────────────────────────────────────────────────────────────────────
// Der MESS-PFAD (die tatsaechlich getriebene Messung) referenziert AUSSCHLIESSLICH den INC-F-Katalog-Treiber
// (katalog::execute_one_permutation_katalog -> reale HotComposition / HotPrtStufe2ReplaceComposition /
// HotPrtStufe3FullJoinComposition ueber SearchAlgorithmAbiAdapter -> IObservableTier). Die Surrogat-Adapter
// (CacheEngineExecutionEngineAdapter / PrtArtExecutionEngineAdapter, v32_orchestrator.hpp) werden NUR
// transitiv fuer die MessreiheReport-/PermutationOutcome-STRUKTUREN via messreihe_report_exporter.hpp
// mitkompiliert -- sie werden NIE instanziiert und NIE im Antriebs-/Mess-Pfad aufgerufen (der Antrieb ruft
// einzig execute_one_permutation_katalog). Die vier verbotenen Alt-Pfad-Marker (Surrogat-Hash-Backend,
// Zyklen-je-Op-Stub, der std-Hash-Container, der Prueflings-Body -- identisch zu
// test_v32_katalog_driver::kAltPfadMarker) kommen in DIESER Quelle bewusst NICHT literal vor -> die W4-grep
// belegt sie surrogatfrei.
//
// ── INERT ────────────────────────────────────────────────────────────────────────────────────────────────
// Dieser Header hat KEINEN Konsumenten im Default-Build. Er wird NUR unter COMDARE_V32_DRIVER_ENABLE +
// COMDARE_MEASUREMENT_ON kompiliert (der abi_adapter-Guard fordert MEASUREMENT, damit der
// SearchAlgorithmAbiAdapter ein IObservableTier traegt). v32_orchestrator.hpp behaelt seinen return-0-Stub
// (execute_messreihe dort; die PL-0-Banner-Fortschreibung 2026-07-19 dort ist KOMMENTAR-ONLY) -> Default-
// Build verhaltensidentisch, golden-320 unveraendert.
//
// @pattern GoF-Strategy (INC-E PhaseStrategyFor) + Policy-Based Design (PhaseCompositions<S>, compile-time) +
//   GoF-Object-Adapter (INC-F KatalogTierEngineCallable) + Command (ExecuteEngineCommand/CompareEngineCommand).
//   Der Runtime->Compile-Time-Dispatch der 3 MergeStrategy-Werte ist ein EINMALIGER Enumerations-Switch
//   (KEIN Hot-Path-Switch: die per-Op-Messung bleibt static dispatch, feedback_no_runtime_switch gewahrt).
// @task INC-G (Antrieb: parse->Strategy->Katalog-Treiber->Report) + INC-H (Export: CSV/TikZ)
// @related v32_katalog_driver.hpp (INC-F, W4-Katalog-Treiber) · experiment_phase_strategy.hpp (INC-E)
// @related messreihe_report_exporter.hpp (INC-H Exporter) · op_type_filter.hpp (OP-1..OP-6 -> WorkloadKind)
// @related cache_engine profile_facade/validate_profile.hpp (INC-D validate) · xml_config_parser (INC-D parse)

#include "experiment_phase_strategy.hpp" // INC-E: PhaseStrategyFor<MergeStrategy>
#include "messreihe_report_exporter.hpp" // INC-H: MessreiheReport / PermutationOutcome / MessreiheReportExporter
#include "op_type_filter.hpp"            // OP-1..OP-6 -> WorkloadKind (wirksame Enumeration)
#include "v32_katalog_driver.hpp"        // INC-F: W4-Katalog-Treiber (reale IObservableTier)

#include <compositions/prt_art_merge_reference.hpp> // HotPrtStufe2/Stufe3-Kompositionen (Phasen-Kompositionen)
#include <profile_facade/validate_profile.hpp>      // INC-D: validate_experiment_profile + merge_strategy_name
#include <xml_config_parser/xml_config_parser.hpp>  // INC-D: parse_experiment_profile + ExperimentProfile

#include <chrono>
#include <cstddef>
#include <cstdint>
#include <ctime>
#include <filesystem>
#include <iostream>
#include <optional>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

namespace comdare::diplomarbeit::messung_driver::v32::antrieb {

namespace cmd   = ::comdare::cache_engine::builder::commands;
namespace comp  = ::comdare::cache_engine::compositions;
namespace strat = ::comdare::diplomarbeit::messung_driver::v32::strategy;
namespace kat   = ::comdare::diplomarbeit::messung_driver::v32::katalog;
namespace cx    = ::comdare::builder::xml;
namespace tlz   = ::comdare::cache_engine::thesis_lazy;

using strat::MergeStrategy;

/// EnumerationMode -- <metadata><mode> (defined|full|full_sampled). Steuert die ENUMERATIONS-BREITE je Phase
/// (wie viele OP-Typen gemessen werden); ORTHOGONAL zur Phase (die den Kompositionalen Join = Merge waehlt).
enum class EnumerationMode { Defined, Full, FullSampled };

/// parse_enumeration_mode -- <metadata><mode>-Token -> EnumerationMode. Unbekannt/leer -> Defined (sicherer Default).
[[nodiscard]] inline EnumerationMode parse_enumeration_mode(std::string_view mode) noexcept {
    if (mode == "full") return EnumerationMode::Full;
    if (mode == "full_sampled") return EnumerationMode::FullSampled;
    return EnumerationMode::Defined;
}

/// merge_strategy_from_name -- der String->Enum-Roundtrip zur validate-Seite (tlz::merge_strategy_name ist
/// Enum->String). Single-Source der 3 Werte = tlz::kExperimentMergeStrategies (validate_profile.hpp), KEIN
/// dupliziertes Enum. nullopt bei unbekanntem Namen (validate_experiment_profile hat das i.d.R. schon gefangen).
[[nodiscard]] inline std::optional<MergeStrategy> merge_strategy_from_name(std::string_view name) {
    for (auto const s : tlz::kExperimentMergeStrategies) {
        if (tlz::merge_strategy_name(s) == name) { return s; }
    }
    return std::nullopt;
}

/// PhaseCompositions<S> -- die realen Katalog-Kompositionen je MergeStrategy (Policy-Based Design, compile-time).
/// EE-A ist STETS die CE-SOTA-Baseline (HotComposition, Stufe1_CeOnly); EE-B ist die Phasen-Komposition:
///   Stufe1_CeOnly           -> HotComposition                   (Baseline gegen Baseline: erwarteter Tie)
///   Stufe2_PrueflingReplace -> HotPrtStufe2ReplaceComposition   (PRT ersetzt den path_compression-Slot)
///   Stufe3_FullJoin         -> HotPrtStufe3FullJoinComposition  (non-redundante Union CE + Pruefling)
template <MergeStrategy S>
struct PhaseCompositions;

template <>
struct PhaseCompositions<MergeStrategy::Stufe1_CeOnly> {
    using EngineA = comp::HotComposition;
    using EngineB = comp::HotComposition;
};
template <>
struct PhaseCompositions<MergeStrategy::Stufe2_PrueflingReplace> {
    using EngineA = comp::HotComposition;
    using EngineB = comp::HotPrtStufe2ReplaceComposition;
};
template <>
struct PhaseCompositions<MergeStrategy::Stufe3_FullJoin> {
    using EngineA = comp::HotComposition;
    using EngineB = comp::HotPrtStufe3FullJoinComposition;
};

/// to_permutation_outcome -- KatalogPermutationOutcome (INC-F) -> v32::PermutationOutcome (Exporter-Eingabe).
/// Reine Feld-Projektion (beide tragen cmd::ExecutionResult + Verdict + welch/throughput); die Pruefdock-
/// Konformitaets-Felder werden nicht in die 12-Spalten-CSV projiziert (der Exporter kennt sie nicht).
[[nodiscard]] inline PermutationOutcome to_permutation_outcome(kat::KatalogPermutationOutcome const& ko) {
    PermutationOutcome po;
    po.axis_id          = ko.axis_id;
    po.variant_name     = ko.variant_name;
    po.ee_a_result      = ko.ee_a_result;
    po.ee_b_result      = ko.ee_b_result;
    po.verdict          = ko.verdict;
    po.welch_p_value    = ko.welch_p_value;
    po.throughput_ratio = ko.throughput_ratio;
    return po;
}

/// op_labels_for_mode -- die je-Phase enumerierte OP-Typ-Liste aus dem Profil, gefiltert nach EnumerationMode:
///   Defined     = genau der erste deklarierte OP-Typ (1 Permutation je Phase -> stets >= 1 Verdikt je Phase).
///   Full        = alle deklarierten OP-Typen.
///   FullSampled = jeder zweite (mindestens 1).
/// Leeres <op_types> -> Fallback "OP-1" (auch dann >= 1 Permutation je Phase).
[[nodiscard]] inline std::vector<std::string> op_labels_for_mode(std::vector<std::string> const& op_types,
                                                                 EnumerationMode                 mode) {
    std::vector<std::string> const source = op_types.empty() ? std::vector<std::string>{"OP-1"} : op_types;
    std::vector<std::string>       out;
    switch (mode) {
        case EnumerationMode::Defined: out.push_back(source.front()); break;
        case EnumerationMode::Full: out = source; break;
        case EnumerationMode::FullSampled:
            for (std::size_t i = 0; i < source.size(); i += 2) { out.push_back(source[i]); }
            break;
    }
    if (out.empty()) { out.push_back(source.front()); }
    return out;
}

/// drive_phase<S> -- treibt EINE Phase (compile-time MergeStrategy S) ueber alle enumerierten OP-Typen. Je
/// OP-Typ eine reale Katalog-Permutation (INC-F): EE-A/EE-B = PhaseCompositions<S>, distinktes Seed je
/// (phase,op) -> unabhaengige Mess-Laeufe. Ergebnisse akkumulieren in den MessreiheReport (Wins/Ties-Bilanz).
/// Der Concept-Guard (INC-E) erzwingt die vollstaendige Phase-Strategy-API zur Compile-Zeit.
template <MergeStrategy S>
inline void drive_phase(MessreiheReport& report, cx::ExperimentPhase const& phase,
                        std::vector<std::string> const& op_labels, cmd::Workload base, std::size_t phase_index) {
    using PhaseStrat = strat::PhaseStrategyFor<S>;
    static_assert(strat::ExperimentPhaseStrategy<PhaseStrat>, "INC-E Concept-Guard: Phase-Strategy unvollstaendig");
    using EngineA = typename PhaseCompositions<S>::EngineA;
    using EngineB = typename PhaseCompositions<S>::EngineB;

    std::string const axis_id = std::string{PhaseStrat::phase_name()}; // == merge-Name (stabile Phasen-Identitaet)
    std::size_t       op_idx  = 0;
    for (auto const& op_label : op_labels) {
        cmd::Workload wl = base;
        (void)apply_op_type_token(op_label, wl);                     // OP-Typ -> WorkloadKind (op_type_filter)
        wl.seed = base.seed + phase_index * 997U + (op_idx++) * 31U; // distinktes Seed je (phase,op) -> unabhaengig

        std::string const variant = phase.name + "@" + op_label;
        auto const        ko      = kat::execute_one_permutation_katalog<EngineA, EngineB>(axis_id, variant, wl);

        switch (ko.verdict) {
            case cmd::CompareEngineCommand::Verdict::EE_A_Wins: ++report.ee_a_wins; break;
            case cmd::CompareEngineCommand::Verdict::EE_B_Wins: ++report.ee_b_wins; break;
            case cmd::CompareEngineCommand::Verdict::Tie: ++report.ties; break;
            default: break;
        }
        ++report.total_variants;
        report.outcomes.push_back(to_permutation_outcome(ko));
    }
}

/// dispatch_phase -- der EINMALIGE Runtime->Compile-Time-Switch (Enumerations-Zeit, KEIN Hot-Path): loest den
/// phase.merge-String auf die MergeStrategy-Enum auf und ruft drive_phase<S> mit der compile-time gewaehlten
/// Strategy + Komposition. false = unbekannte Merge-Strategie (validate_experiment_profile faengt das zuvor ab).
[[nodiscard]] inline bool dispatch_phase(MessreiheReport& report, cx::ExperimentPhase const& phase,
                                         std::vector<std::string> const& op_labels, cmd::Workload const& base,
                                         std::size_t phase_index) {
    auto const s = merge_strategy_from_name(phase.merge);
    if (!s) { return false; }
    switch (*s) {
        case MergeStrategy::Stufe1_CeOnly:
            drive_phase<MergeStrategy::Stufe1_CeOnly>(report, phase, op_labels, base, phase_index);
            return true;
        case MergeStrategy::Stufe2_PrueflingReplace:
            drive_phase<MergeStrategy::Stufe2_PrueflingReplace>(report, phase, op_labels, base, phase_index);
            return true;
        case MergeStrategy::Stufe3_FullJoin:
            drive_phase<MergeStrategy::Stufe3_FullJoin>(report, phase, op_labels, base, phase_index);
            return true;
    }
    return false;
}

/// run_experiment_profile -- der reine Antrieb (INC-G): je Phase des validierten Profils die realen Katalog-
/// Tiers treiben und in einen MessreiheReport akkumulieren. KEIN Datei-IO (das ist INC-H/execute_messreihe).
[[nodiscard]] inline MessreiheReport run_experiment_profile(cx::ExperimentProfile const& profile,
                                                            EnumerationMode              mode) {
    MessreiheReport report;
    auto const      start = std::chrono::steady_clock::now();

    cmd::Workload base;
    base.record_count    = 2000; // moderat: genug Samples fuer Welch, Test < TIMEOUT (== INC-F-Gate)
    base.operation_count = 2000;
    base.seed            = 42;

    auto const op_labels = op_labels_for_mode(profile.op_types, mode);

    report.total_axes       = profile.phases.size();
    std::size_t phase_index = 0;
    for (auto const& phase : profile.phases) { (void)dispatch_phase(report, phase, op_labels, base, phase_index++); }

    report.total_elapsed = std::chrono::steady_clock::now() - start;
    return report;
}

/// substitute_date -- ersetzt jedes ${date}-Token in einem <output>-Pfad durch das aktuelle Datum (YYYYMMDD).
/// Erlaubt den in der Golden-Instanz genutzten _runs/${date}/... -Pfad ohne externe Shell-Expansion.
[[nodiscard]] inline std::string substitute_date(std::string path) {
    constexpr std::string_view token = "${date}";
    if (path.find(token) == std::string::npos) { return path; }
    std::time_t const now = std::time(nullptr);
    std::tm           tm{};
#if defined(_WIN32)
    localtime_s(&tm, &now);
#else
    localtime_r(&now, &tm);
#endif
    char buf[16] = {};
    std::strftime(buf, sizeof(buf), "%Y%m%d", &tm);
    for (auto p = path.find(token); p != std::string::npos; p = path.find(token, p)) {
        path.replace(p, token.size(), buf);
    }
    return path;
}

/// execute_messreihe -- der OFFIZIELLE Einstieg (INC-G+H): parse (INC-D) -> validate (INC-D) -> Antrieb
/// (run_experiment_profile) -> Export (INC-H: CSV + TikZ nach <output>). Rueckgabe int (Test-Kompat):
///   0 = ok · 2 = parse-Fehler · 3 = validate-Fehler · 4 = leerer Report · 5 = Export-Fehler.
/// registry_dir wird leer gelassen (rein strukturelle Validierung); der volle Registry-Abgleich (4)+(5) ist
/// Sache der Fassade, die das Registry-Verzeichnis kennt (analog test_experiment_parser::make_registry_dir).
/// PL-4 (L6, 2026-07-19): <metadata><mode> der Experiment-XML ist die AUTORITATIVE Mode-Quelle (single-
/// XML-Doktrin). mode_override ist NUR noch expliziter Debug-Override (leer = XML gilt); greift er
/// abweichend, wird das LAUT geloggt — nie still (der L6-Bruch war: env ersetzte die XML still).
[[nodiscard]] inline int execute_messreihe(std::string_view config_xml, std::string_view mode_override = {}) {
    cx::XmlConfigParser const parser;
    auto const                profile = parser.parse_experiment_profile(std::filesystem::path{std::string{config_xml}});
    if (!profile) {
        std::cerr << "[INC-G] parse_experiment_profile fehlgeschlagen: " << config_xml << "\n";
        return 2;
    }

    auto const vr = tlz::validate_experiment_profile(*profile); // registry_dir leer -> strukturelle Validierung
    if (!vr.ok) {
        std::cerr << "[INC-G] validate_experiment_profile: " << vr.errors.size() << " Fehler.\n";
        for (auto const& e : vr.errors) { std::cerr << "  [FEHLER] " << e << "\n"; }
        return 3;
    }

    // PL-4: Mode-Quelle = XML <metadata><mode>; leer/unbekannt faellt in parse_enumeration_mode sicher auf
    // Defined zurueck. Ein abweichender expliziter Override wird LAUT geloggt (nie stiller XML-Bypass).
    std::string effective_mode = profile->metadata.mode;
    if (!mode_override.empty() && mode_override != profile->metadata.mode) {
        std::cout << "[PL-4] mode-Override AKTIV: XML <metadata><mode>='" << profile->metadata.mode
                  << "' -> expliziter Override '" << mode_override << "' (geloggt, nie still).\n";
        effective_mode = std::string{mode_override};
    }

    MessreiheReport const report = run_experiment_profile(*profile, parse_enumeration_mode(effective_mode));
    if (report.outcomes.empty()) {
        std::cerr << "[INC-G] leerer MessreiheReport (keine Permutation getrieben).\n";
        return 4;
    }

    // INC-H: Export CSV + TikZ nach den <output>-Pfaden der Experiment-XML (${date} aufgeloest, Parent-Dirs
    // angelegt). Der <binary_path> wird bewusst NICHT geschrieben -- der MessreiheReportExporter emittiert
    // ausschliesslich CSV + TikZ; der binaere Mess-Record-Pfad ist Sache des Voll-Pipeline-Writers (nicht INC-H).
    MessreiheReportExporter const ex;
    std::filesystem::path const   csv_path = substitute_date(profile->output.csv_path);
    std::filesystem::path const   tex_path = substitute_date(profile->output.latex_path);

    std::error_code ec;
    if (csv_path.has_parent_path()) { std::filesystem::create_directories(csv_path.parent_path(), ec); }
    if (tex_path.has_parent_path()) { std::filesystem::create_directories(tex_path.parent_path(), ec); }

    auto const cs = ex.write_csv(report, csv_path);
    auto const ts = ex.write_tikz_summary(report, tex_path);
    if (!cs.ok() || !ts.ok()) {
        std::cerr << "[INC-H] Export-Fehler: csv=" << cs.message << " tikz=" << ts.message << "\n";
        return 5;
    }

    std::cout << "[INC-G+H] execute_messreihe ok: " << report.outcomes.size() << " Permutationen -> "
              << csv_path.string() << " + " << tex_path.string() << "\n";
    return 0;
}

} // namespace comdare::diplomarbeit::messung_driver::v32::antrieb
