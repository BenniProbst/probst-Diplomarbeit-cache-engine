#pragma once
// #31-Schritt-2/A2 (F7 Kategorie-Achse M) — die 16 MeasurementCategory als compile-time-Liste + Regime-
// Klassifikator. Achse M der feingliedrigen 2D-Mess-Matrix (Doc 15 §4 Option A, super docs/architektur/
// 15_F7_mess_frameworks_workloads_2d_matrix_plan.md). REUSE des bestehenden `enum class MeasurementCategory`
// (measurement_category.hpp) UNVERÄNDERT — kein neuer Enum, kein Enum-Wert-Shift.
//
// **M projiziert Spalten, multipliziert KEINE Läufe:** alle Metriken eines Mess-Laufs entstehen gleichzeitig in
// EINEM Snapshot-POD (builder/measurement_snapshot.hpp, ComdareMeasurementSnapshotV1, 16+6 Spalten). M ist daher
// eine compile-time-LISTE (selektierbare Kollektor-/Spalten-Menge), NICHT ein mp_product-Faktor der Lauf-Matrix
// (ein Kreuzprodukt mit M würde die Läufe fälschlich ×16 blähen — Doc 15 §4). Sie ist orthogonal zur Achse W×D
// (workload_matrix.hpp): |Läufe| = W·D, |Spalten je Lauf| = |M-Teilmenge|.
//
// **Regime-Gate (Doc 15 §2/§4):** die kanonische Zweiteilung „zeit-/observer-basiert (unprivilegiert, metrics b0)
// vs. zählerbasiert/PMC (privilegiert, pmc b1)" — POD-verankert über `pmc_available` (measurement_snapshot.hpp:50,
// das die 6 HW-Counter gated). Als drittes, feineres Regime die abgeleiteten Verhältnisse (CLU, IPC/CPI): sie
// brauchen zwar privilegierte PMC-Rohdaten (→ category_needs_pmc == true), sind aber selbst berechnet, kein roher
// Counter. Rein constexpr (kein Runtime-Switch/vtable, feedback_no_runtime_switch, feedback_compile_time_only_no_runtime).
//
// **golden/ABI-NEUTRAL:** additiver header-only-Trait; die MeasurementCategory-Enum-Werte werden NICHT verschoben
// (sizeof/POD unberührt), keine permutation_axes.xml/golden_fullpilot_320-Berührung. Analog #31-Schritt-1.

#include "measurement_category.hpp" // MeasurementCategory (Bestands-Enum, REUSE)

#include <boost/mp11.hpp>

#include <cstddef>
#include <cstdint>
#include <string_view>
#include <type_traits>

namespace comdare::cache_engine::measurement {

namespace mp = boost::mp11;

/// measurement_category_list — die 16 MeasurementCategory als compile-time-Liste = Achse M der 2D-Mess-Matrix.
/// Reihenfolge = Enum-Reihenfolge (CLU=0 … FILL_BUFFER_OCCUPANCY=15), mp11-iterierbar.
using measurement_category_list =
    mp::mp_list<std::integral_constant<MeasurementCategory, MeasurementCategory::CLU>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::CACHE_MISS_L1>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::CACHE_MISS_L2>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::CACHE_MISS_L3>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::DTLB_MISS>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::MEMORY_FOOTPRINT>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::BRANCH_MISS>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::IPC_CPI>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::LATENCY_MEAN>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::LATENCY_P50>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::LATENCY_P95>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::LATENCY_P99>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::LATENCY_P999>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::THROUGHPUT>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::ENERGY_J>,
                std::integral_constant<MeasurementCategory, MeasurementCategory::FILL_BUFFER_OCCUPANCY>>;

inline constexpr std::size_t measurement_category_count = mp::mp_size<measurement_category_list>::value;

/// MeasurementRegime — das Kollektor-Regime einer Kategorie (Doc 15 §2/§4).
enum class MeasurementRegime : std::uint8_t {
    Observer = 0, ///< zeit-/funktional-basiert, unprivilegiert (metrics b0): Latenz/Durchsatz/Footprint
    Counter  = 1, ///< roher PMC-Hardware-Counter, privilegiert (pmc b1): Cache/dTLB/Branch-Miss, Energie, Fill-Buffer
    Derived  = 2  ///< aus PMC-Rohgrößen berechnetes Verhältnis (privilegiert): Cache-Line-Auslastung, IPC/CPI
};

/// category_regime — reiner constexpr-Klassifikator (kein Runtime-Dispatch). Zuordnung nach Doc 15 §2 + der
/// pmc_available-Zweiteilung im Snapshot-POD (measurement_snapshot.hpp).
[[nodiscard]] constexpr MeasurementRegime category_regime(MeasurementCategory c) noexcept {
    switch (c) {
        // Counter (privilegiert, roher HW-Counter — die 6 PMC-Counter des POD + Fill-Buffer als PMC-Event):
        case MeasurementCategory::CACHE_MISS_L1:
        case MeasurementCategory::CACHE_MISS_L2:
        case MeasurementCategory::CACHE_MISS_L3:
        case MeasurementCategory::DTLB_MISS:
        case MeasurementCategory::BRANCH_MISS:
        case MeasurementCategory::ENERGY_J:
        case MeasurementCategory::FILL_BUFFER_OCCUPANCY:
            return MeasurementRegime::Counter;
        // Derived (privilegiert, berechnetes Verhältnis aus PMC-Rohgrößen):
        case MeasurementCategory::CLU:     // Cache-Line-Auslastung = genutzte / geladene Cache-Line-Bytes
        case MeasurementCategory::IPC_CPI: // Instructions-per-Cycle bzw. Cycles-per-Instruction
            return MeasurementRegime::Derived;
        // Observer (unprivilegiert, zeit-/funktional — direkt aus Timing-/Allocator-Observer):
        case MeasurementCategory::MEMORY_FOOTPRINT:
        case MeasurementCategory::LATENCY_MEAN:
        case MeasurementCategory::LATENCY_P50:
        case MeasurementCategory::LATENCY_P95:
        case MeasurementCategory::LATENCY_P99:
        case MeasurementCategory::LATENCY_P999:
        case MeasurementCategory::THROUGHPUT:
            return MeasurementRegime::Observer;
    }
    return MeasurementRegime::Observer; // alle 16 Enum-Werte oben abgedeckt; defensiver Default (unerreichbar)
}

/// category_needs_pmc — true gdw. die Kategorie privilegierte PMC-Rohdaten braucht (Counter ODER Derived).
/// Bildet die Doc-15-§4-Zweiteilung „privilegiert vs. immutable" ab: needs_pmc == (Regime != Observer).
[[nodiscard]] constexpr bool category_needs_pmc(MeasurementCategory c) noexcept {
    return category_regime(c) != MeasurementRegime::Observer;
}

/// regime_name — Compile-Time-String je Regime (Mess-Protokoll-/Doku-Ausgaben).
[[nodiscard]] constexpr std::string_view regime_name(MeasurementRegime r) noexcept {
    switch (r) {
        case MeasurementRegime::Observer: return "Observer";
        case MeasurementRegime::Counter: return "Counter";
        case MeasurementRegime::Derived: return "Derived";
    }
    return "Unknown";
}

// ── Self-proving (compile-time; kein Raten) ─────────────────────────────────────────────────────
static_assert(measurement_category_count == 16,
              "#31-Schritt-2: Achse M = 16 MeasurementCategory (CLU … FILL_BUFFER_OCCUPANCY).");
static_assert(category_regime(MeasurementCategory::CACHE_MISS_L1) == MeasurementRegime::Counter);
static_assert(category_regime(MeasurementCategory::ENERGY_J) == MeasurementRegime::Counter);
static_assert(category_regime(MeasurementCategory::FILL_BUFFER_OCCUPANCY) == MeasurementRegime::Counter);
static_assert(category_regime(MeasurementCategory::CLU) == MeasurementRegime::Derived);
static_assert(category_regime(MeasurementCategory::IPC_CPI) == MeasurementRegime::Derived);
static_assert(category_regime(MeasurementCategory::LATENCY_P99) == MeasurementRegime::Observer);
static_assert(category_regime(MeasurementCategory::THROUGHPUT) == MeasurementRegime::Observer);
static_assert(category_needs_pmc(MeasurementCategory::CACHE_MISS_L3)); // Counter → PMC
static_assert(category_needs_pmc(MeasurementCategory::CLU));           // Derived → PMC-Rohdaten
static_assert(!category_needs_pmc(MeasurementCategory::LATENCY_MEAN)); // Observer → unprivilegiert

} // namespace comdare::cache_engine::measurement
