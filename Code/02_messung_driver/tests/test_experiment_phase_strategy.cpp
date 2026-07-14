// INC-E (2026-07-14) -- Unit-Test des Experiment-Phase-Strategy-Pattern
// (experiment_phase_strategy.hpp). Gate-frei: reine Compile-Time-/Host-Logik, kein
// Treiber-Lauf, kein #156-Messdaten, UNABHAENGIG vom COMDARE_V32_ENABLE-Gate.
//
// Beweist: (1) die 3 Strategies werden compile-time instanziiert; (2) select_merge()
// liefert je Phase die korrekte MergeStrategy; (3) der Concept-Guard greift (positiv +
// negativ, static_assert); (4) statischer Dispatch -- KEIN vtable (compile-time).

#include "experiment_phase_strategy.hpp"

#include <anatomy/pruefling_merge.hpp> // ce-Single-Source MergeStrategy (Discriminator)

#include <cstdio>
#include <string_view>
#include <type_traits>

namespace strat = comdare::diplomarbeit::messung_driver::v32::strategy;
namespace pm    = comdare::cache_engine::anatomy::pruefling;

// ─────────────────────────────────────────────────────────────────────────────
// (A) COMPILE-TIME-Beweise -- Concept-Guard + kein-vtable (static_assert)
// ─────────────────────────────────────────────────────────────────────────────

// (1) Concept-Guard POSITIV: die 3 Strategies erfuellen die Familie.
static_assert(strat::ExperimentPhaseStrategy<strat::Stufe1CeOnlyStrategy>);
static_assert(strat::ExperimentPhaseStrategy<strat::Stufe2PrueflingReplaceStrategy>);
static_assert(strat::ExperimentPhaseStrategy<strat::Stufe3FullJoinStrategy>);

// (2) Concept-Guard NEGATIV: Nicht-Strategies werden abgewiesen (kein "missing method"-Leak).
struct NotAStrategy {
    // falscher Rueckgabetyp fuer select_merge() + phase_name()/describe() fehlen ganz.
    static constexpr int select_merge() noexcept { return 0; }
};
static_assert(!strat::ExperimentPhaseStrategy<NotAStrategy>);
static_assert(!strat::ExperimentPhaseStrategy<int>);

// (3) select_merge() liefert compile-time die korrekte MergeStrategy je Phase.
static_assert(strat::Stufe1CeOnlyStrategy::select_merge() == pm::MergeStrategy::Stufe1_CeOnly);
static_assert(strat::Stufe2PrueflingReplaceStrategy::select_merge() == pm::MergeStrategy::Stufe2_PrueflingReplace);
static_assert(strat::Stufe3FullJoinStrategy::select_merge() == pm::MergeStrategy::Stufe3_FullJoin);

// (4) Policy-Based Auswahl (Discriminator -> konkrete Strategy) ist typ-korrekt.
static_assert(std::is_same_v<strat::PhaseStrategyFor<pm::MergeStrategy::Stufe1_CeOnly>, strat::Stufe1CeOnlyStrategy>);
static_assert(std::is_same_v<strat::PhaseStrategyFor<pm::MergeStrategy::Stufe2_PrueflingReplace>,
                             strat::Stufe2PrueflingReplaceStrategy>);
static_assert(
    std::is_same_v<strat::PhaseStrategyFor<pm::MergeStrategy::Stufe3_FullJoin>, strat::Stufe3FullJoinStrategy>);

// (5) KEIN vtable / kein Runtime-Polymorphismus (statischer Dispatch, zero-cost).
static_assert(!std::is_polymorphic_v<strat::Stufe1CeOnlyStrategy>);
static_assert(!std::is_polymorphic_v<strat::Stufe2PrueflingReplaceStrategy>);
static_assert(!std::is_polymorphic_v<strat::Stufe3FullJoinStrategy>);
static_assert(std::is_empty_v<strat::Stufe1CeOnlyStrategy>);

// (6) CRTP-Basis leitet static-polymorph korrekt weiter.
static_assert(strat::Stufe1CeOnlyStrategy::resolved_merge() == pm::MergeStrategy::Stufe1_CeOnly);
static_assert(strat::Stufe1CeOnlyStrategy::is_ce_only());
static_assert(strat::Stufe2PrueflingReplaceStrategy::involves_pruefling());
static_assert(strat::Stufe3FullJoinStrategy::involves_pruefling());

static int  g_fail = 0;
static void check(bool ok, char const* msg) {
    std::printf("  [%s] %s\n", ok ? "OK" : "FAIL", msg);
    if (!ok) ++g_fail;
}

int main() {
    // ── (B) RUNTIME-Spiegel der Compile-Time-Beweise (les- + berichtbar) ──

    // 3 Strategies compile-time instanziiert, select_merge() je Phase korrekt.
    constexpr strat::Stufe1CeOnlyStrategy           s1{};
    constexpr strat::Stufe2PrueflingReplaceStrategy s2{};
    constexpr strat::Stufe3FullJoinStrategy         s3{};
    (void)s1;
    (void)s2;
    (void)s3;

    check(strat::Stufe1CeOnlyStrategy::select_merge() == pm::MergeStrategy::Stufe1_CeOnly,
          "Stufe1CeOnlyStrategy::select_merge() == Stufe1_CeOnly");
    check(strat::Stufe2PrueflingReplaceStrategy::select_merge() == pm::MergeStrategy::Stufe2_PrueflingReplace,
          "Stufe2PrueflingReplaceStrategy::select_merge() == Stufe2_PrueflingReplace");
    check(strat::Stufe3FullJoinStrategy::select_merge() == pm::MergeStrategy::Stufe3_FullJoin,
          "Stufe3FullJoinStrategy::select_merge() == Stufe3_FullJoin");

    // phase_name() == MergeStrategy-Name (stabile Phasen-Identitaet).
    check(strat::Stufe1CeOnlyStrategy::phase_name() == "Stufe1_CeOnly", "Stufe1 phase_name() == 'Stufe1_CeOnly'");
    check(strat::Stufe2PrueflingReplaceStrategy::phase_name() == "Stufe2_PrueflingReplace",
          "Stufe2 phase_name() == 'Stufe2_PrueflingReplace'");
    check(strat::Stufe3FullJoinStrategy::phase_name() == "Stufe3_FullJoin", "Stufe3 phase_name() == 'Stufe3_FullJoin'");

    // describe() liefert nicht-leere Kompositions-Semantik je Phase.
    check(!strat::Stufe1CeOnlyStrategy::describe().empty(), "Stufe1 describe() nicht leer");
    check(!strat::Stufe2PrueflingReplaceStrategy::describe().empty(), "Stufe2 describe() nicht leer");
    check(!strat::Stufe3FullJoinStrategy::describe().empty(), "Stufe3 describe() nicht leer");

    // Policy-Based Auswahl: Discriminator -> konkrete Strategy -> gleiche MergeStrategy.
    check(strat::PhaseStrategyFor<pm::MergeStrategy::Stufe1_CeOnly>::select_merge() == pm::MergeStrategy::Stufe1_CeOnly,
          "PhaseStrategyFor<Stufe1_CeOnly> -> Stufe1_CeOnly");
    check(strat::PhaseStrategyFor<pm::MergeStrategy::Stufe2_PrueflingReplace>::select_merge() ==
              pm::MergeStrategy::Stufe2_PrueflingReplace,
          "PhaseStrategyFor<Stufe2_PrueflingReplace> -> Stufe2_PrueflingReplace");
    check(strat::PhaseStrategyFor<pm::MergeStrategy::Stufe3_FullJoin>::select_merge() ==
              pm::MergeStrategy::Stufe3_FullJoin,
          "PhaseStrategyFor<Stufe3_FullJoin> -> Stufe3_FullJoin");

    // CRTP-Basis: is_ce_only()/involves_pruefling() static-polymorph korrekt.
    check(strat::Stufe1CeOnlyStrategy::is_ce_only(), "Stufe1 is_ce_only() == true");
    check(!strat::Stufe1CeOnlyStrategy::involves_pruefling(), "Stufe1 involves_pruefling() == false");
    check(strat::Stufe2PrueflingReplaceStrategy::involves_pruefling(), "Stufe2 involves_pruefling() == true");
    check(strat::Stufe3FullJoinStrategy::involves_pruefling(), "Stufe3 involves_pruefling() == true");

    // Concept-Guard-Spiegel (Compile-Time-Beweise oben) im Report.
    check(strat::ExperimentPhaseStrategy<strat::Stufe1CeOnlyStrategy>,
          "Concept-Guard POSITIV: Stufe1 erfuellt Familie");
    check(!strat::ExperimentPhaseStrategy<NotAStrategy>, "Concept-Guard NEGATIV: NotAStrategy abgewiesen");
    check(!std::is_polymorphic_v<strat::Stufe1CeOnlyStrategy>, "kein vtable: Stufe1 nicht polymorph (zero-cost)");

    std::printf(g_fail == 0 ? "INC-E.strategy: ALLE OK\n" : "INC-E.strategy: %d FAIL\n", g_fail);
    return g_fail == 0 ? 0 : 1;
}
