#pragma once
// INC-E (2026-07-14) -- Experiment-Phase-Strategy-Pattern: die 3 Experiment-Phasen
// (Kompositionale Joins Stufe 1/2/3) als benannte Strategy-Familie ueber dem ce-
// MergeStrategy-Discriminator. HEADER-ONLY, INERT: KEIN Konsument -- die Verdrahtung
// in V32Orchestrator::execute_messreihe (v32_orchestrator.hpp) bleibt Stufe G, NICHT hier.
// Hier NUR die Strategy-Huelle mit klarer API select_merge()/phase_name()/describe();
// der reale MergeAxis-Aufruf + CEB-Antrieb ist ebenfalls G.
//
// ============================================================================
// BENANNTE PATTERNS (zitierfaehig -- keine musterlosen Konstrukte)
// ============================================================================
//   @pattern GoF-Strategy
//     Jede Experiment-Phase kapselt EINEN austauschbaren Merge-/Kompositions-
//     Algorithmus hinter einer einheitlichen API. Die konkreten Strategies sind
//     gegen das ExperimentPhaseStrategy-Concept austauschbar (Family-of-Algorithms).
//     Primaerquelle: Gamma/Helm/Johnson/Vlissides, "Design Patterns: Elements of
//     Reusable Object-Oriented Software", Addison-Wesley 1994, Strategy S.315-323.
//
//   @pattern Policy-Based-Design (Compile-Time Strategy-Auswahl statt Runtime-Switch)
//     PhaseStrategyFor<MergeStrategy S> waehlt die konkrete Strategy per Non-Type-
//     Template-Parameter (Partial-Specialization-Dispatch, gespiegelt zu detail::
//     MergeImpl in anatomy/pruefling_merge.hpp:136-158). ZERO-COST, kein vtable,
//     kein Runtime-Switch im Hot-Path.
//     Primaerquelle: Alexandrescu, "Modern C++ Design: Generic Programming and
//     Design Patterns Applied", Addison-Wesley 2001, Kap. 1 (Policy-Based Design).
//
//   @pattern CRTP + Concept-Guard (statischer Dispatch, kein Runtime-Polymorphismus)
//     PhaseStrategyBase<Derived> ist die CRTP-Basis (static polymorphism: die Basis
//     leitet resolved_merge() an Derived::select_merge() weiter); das C++23-Concept
//     ExperimentPhaseStrategy erzwingt die Pflicht-API zur Compile-Zeit (static_assert
//     statt "missing method"-Diagnose). Konsistent zu topics/axis_base.hpp
//     (AxisBase-CRTP-Wurzel + AxisBaseConcept).
//     Primaerquellen: Coplien, "Curiously Recurring Template Patterns", C++ Report
//     7(2) 1995, S.24-27; Gregor/Jaervi/Siek/Stroustrup u.a., "Concepts: Linguistic
//     Support for Generic Programming in C++", OOPSLA 2006, S.291-310.
//
// Discriminator = comdare::cache_engine::anatomy::pruefling::MergeStrategy (Single-
// Source der 3 Stufen, anatomy/pruefling_merge.hpp:130-134) -- KEIN dupliziertes Enum.
//
// @task INC-E (A-E-Welle: Strategy-Pattern der Experiment-Configs)
// @related anatomy/pruefling_merge.hpp (MergeStrategy/MergeAxis/detail::MergeImpl)
// @related builder/commands/compare_engine_command.hpp (@command_pattern-Nachbarmuster)
// @related topics/axis_base.hpp (CRTP+Concept-Guard-Achsen -- Muster-Vorlage)
// @related reference_meta_driven_concept_hardening_pattern (Pattern-Fach-Benennung + Primaerquellen)

#include <anatomy/pruefling_merge.hpp> // MergeStrategy (Discriminator, Single-Source der 3 Stufen)

#include <concepts>
#include <string_view>
#include <type_traits>

namespace comdare::diplomarbeit::messung_driver::v32::strategy {

/// MergeStrategy-Alias auf die ce-Single-Source (anatomy/pruefling_merge.hpp) -- kein
/// eigenes Enum. Die 3 Werte: Stufe1_CeOnly / Stufe2_PrueflingReplace / Stufe3_FullJoin.
using MergeStrategy = ::comdare::cache_engine::anatomy::pruefling::MergeStrategy;

// ─────────────────────────────────────────────────────────────────────────────
// (1) Concept-Guard -- die Pflicht-API jeder Experiment-Phasen-Strategy
// ─────────────────────────────────────────────────────────────────────────────

/// ExperimentPhaseStrategy -- Compile-Time-Vertrag der Strategy-Familie (GoF-Strategy).
///
/// Jede konkrete Strategy MUSS statisch (compile-time, kein vtable) liefern:
///   - select_merge() -> MergeStrategy : WELCHE der 3 Kompositionalen Joins die Phase waehlt.
///   - phase_name()   -> string_view   : stabile Identitaet der Phase (== MergeStrategy-Name).
///   - describe()     -> string_view   : Kurzbeschreibung der Kompositions-Semantik.
///
/// Bei Verletzung: klare Concept-Diagnose statt "missing method" (analog AxisBaseConcept).
template <class S>
concept ExperimentPhaseStrategy = requires {
    { S::select_merge() } -> std::same_as<MergeStrategy>;
    { S::phase_name() } -> std::convertible_to<std::string_view>;
    { S::describe() } -> std::convertible_to<std::string_view>;
};

// ─────────────────────────────────────────────────────────────────────────────
// (2) CRTP-Basis -- static polymorphism, gemeinsame Ableitungen ueber Derived
// ─────────────────────────────────────────────────────────────────────────────

/// PhaseStrategyBase<Derived> -- CRTP-Wurzel der Strategy-Familie.
///
/// Static Dispatch: die Basis leitet auf die compile-time Merge-Wahl der abgeleiteten
/// Strategy weiter (Derived::select_merge()) -- KEINE virtuellen Funktionen, kein vtable.
/// Konkrete Strategies erben von dieser Basis und definieren die Policy (select_merge()).
/// Die Basis stellt daraus abgeleitete Praedikate bereit, die alle Strategies teilen.
template <class Derived>
struct PhaseStrategyBase {
    /// Static-polymorphe Aufloesung auf die Merge-Wahl der abgeleiteten Strategy.
    [[nodiscard]] static constexpr MergeStrategy resolved_merge() noexcept { return Derived::select_merge(); }

    /// true, wenn die Phase KEINE Pruefling-Beteiligung hat (Stufe 1, CE-only Baseline).
    [[nodiscard]] static constexpr bool is_ce_only() noexcept {
        return Derived::select_merge() == MergeStrategy::Stufe1_CeOnly;
    }

    /// true, wenn die Phase den Pruefling einbezieht (Stufe 2 ERSETZT oder Stufe 3 FullJoin).
    [[nodiscard]] static constexpr bool involves_pruefling() noexcept {
        return Derived::select_merge() != MergeStrategy::Stufe1_CeOnly;
    }
};

// ─────────────────────────────────────────────────────────────────────────────
// (3) Die 3 konkreten Strategies -- je 1 Kompositionaler Join (Stufe 1/2/3)
// ─────────────────────────────────────────────────────────────────────────────

/// Stufe 1 -- CE-only Baseline: KEINE Pruefling-Beteiligung.
/// Kompositions-Semantik: Achsenliste == ce-DefaultList (StufeOneAxis, pruefling_merge.hpp).
struct Stufe1CeOnlyStrategy final : PhaseStrategyBase<Stufe1CeOnlyStrategy> {
    [[nodiscard]] static constexpr MergeStrategy    select_merge() noexcept { return MergeStrategy::Stufe1_CeOnly; }
    [[nodiscard]] static constexpr std::string_view phase_name() noexcept { return "Stufe1_CeOnly"; }
    [[nodiscard]] static constexpr std::string_view describe() noexcept {
        return "CE-only Baseline -- keine Pruefling-Beteiligung; Achsenliste == ce-DefaultList (StufeOneAxis).";
    }
};

/// Stufe 2 -- ERSETZT-mit-Fallback: die Pruefling-Varianten ERSETZEN die ce-DefaultList
/// pro Achse (Fallback = DefaultList, wenn der Pruefling-Slot leer ist).
/// Kompositions-Semantik: StufeTwoAxis via HasPruefling_v<Slot> (pruefling_merge.hpp).
struct Stufe2PrueflingReplaceStrategy final : PhaseStrategyBase<Stufe2PrueflingReplaceStrategy> {
    [[nodiscard]] static constexpr MergeStrategy select_merge() noexcept {
        return MergeStrategy::Stufe2_PrueflingReplace;
    }
    [[nodiscard]] static constexpr std::string_view phase_name() noexcept { return "Stufe2_PrueflingReplace"; }
    [[nodiscard]] static constexpr std::string_view describe() noexcept {
        return "ERSETZT-mit-Fallback -- Pruefling-Varianten ersetzen die ce-DefaultList pro Achse (StufeTwoAxis).";
    }
};

/// Stufe 3 -- FullJoin: Union aller Default- + Pruefling-Varianten, dedupliziert.
/// Kompositions-Semantik: StufeThreeAxis == mp_unique<mp_append<...>> (pruefling_merge.hpp).
struct Stufe3FullJoinStrategy final : PhaseStrategyBase<Stufe3FullJoinStrategy> {
    [[nodiscard]] static constexpr MergeStrategy    select_merge() noexcept { return MergeStrategy::Stufe3_FullJoin; }
    [[nodiscard]] static constexpr std::string_view phase_name() noexcept { return "Stufe3_FullJoin"; }
    [[nodiscard]] static constexpr std::string_view describe() noexcept {
        return "FullJoin -- non-redundante Union aller Default- + Pruefling-Varianten (StufeThreeAxis, mp_unique).";
    }
};

// ─────────────────────────────────────────────────────────────────────────────
// (4) Policy-Based Auswahl -- Discriminator -> konkrete Strategy (compile-time)
// ─────────────────────────────────────────────────────────────────────────────

namespace detail {
/// PhaseStrategySelector<S> -- Partial-Specialization-Dispatch je MergeStrategy-Wert
/// (gespiegelt zu detail::MergeImpl in anatomy/pruefling_merge.hpp). Kein Runtime-Switch.
template <MergeStrategy S>
struct PhaseStrategySelector;

template <>
struct PhaseStrategySelector<MergeStrategy::Stufe1_CeOnly> {
    using type = Stufe1CeOnlyStrategy;
};

template <>
struct PhaseStrategySelector<MergeStrategy::Stufe2_PrueflingReplace> {
    using type = Stufe2PrueflingReplaceStrategy;
};

template <>
struct PhaseStrategySelector<MergeStrategy::Stufe3_FullJoin> {
    using type = Stufe3FullJoinStrategy;
};
} // namespace detail

/// PhaseStrategyFor<S> -- die konkrete Strategy zum Discriminator S (Policy-Based Design).
/// Beispiel: PhaseStrategyFor<MergeStrategy::Stufe3_FullJoin> == Stufe3FullJoinStrategy.
template <MergeStrategy S>
using PhaseStrategyFor = typename detail::PhaseStrategySelector<S>::type;

// ─────────────────────────────────────────────────────────────────────────────
// (5) Header-lokale Concept-Guards -- die Familie validiert sich selbst (inert)
// ─────────────────────────────────────────────────────────────────────────────

// Jede konkrete Strategy erfuellt den Familien-Vertrag (Concept-Guard greift).
static_assert(ExperimentPhaseStrategy<Stufe1CeOnlyStrategy>);
static_assert(ExperimentPhaseStrategy<Stufe2PrueflingReplaceStrategy>);
static_assert(ExperimentPhaseStrategy<Stufe3FullJoinStrategy>);

// Discriminator-Roundtrip: die Policy-Auswahl liefert die zur MergeStrategy passende Strategy.
static_assert(PhaseStrategyFor<MergeStrategy::Stufe1_CeOnly>::select_merge() == MergeStrategy::Stufe1_CeOnly);
static_assert(PhaseStrategyFor<MergeStrategy::Stufe2_PrueflingReplace>::select_merge() ==
              MergeStrategy::Stufe2_PrueflingReplace);
static_assert(PhaseStrategyFor<MergeStrategy::Stufe3_FullJoin>::select_merge() == MergeStrategy::Stufe3_FullJoin);

// CRTP-Basis leitet static-polymorph korrekt weiter.
static_assert(Stufe1CeOnlyStrategy::resolved_merge() == MergeStrategy::Stufe1_CeOnly);
static_assert(Stufe1CeOnlyStrategy::is_ce_only());
static_assert(Stufe2PrueflingReplaceStrategy::involves_pruefling());
static_assert(Stufe3FullJoinStrategy::involves_pruefling());

// KEIN vtable / kein Runtime-Polymorphismus (statischer Dispatch, zero-cost).
static_assert(!std::is_polymorphic_v<Stufe1CeOnlyStrategy>);
static_assert(!std::is_polymorphic_v<Stufe2PrueflingReplaceStrategy>);
static_assert(!std::is_polymorphic_v<Stufe3FullJoinStrategy>);
static_assert(std::is_empty_v<Stufe1CeOnlyStrategy>);
static_assert(std::is_empty_v<Stufe2PrueflingReplaceStrategy>);
static_assert(std::is_empty_v<Stufe3FullJoinStrategy>);

} // namespace comdare::diplomarbeit::messung_driver::v32::strategy
