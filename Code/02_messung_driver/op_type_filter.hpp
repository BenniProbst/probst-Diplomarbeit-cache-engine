#pragma once
// V41.P5 (G10, 2026-05-31) — op_type_filter: wirksame OP-1..OP-6 → Strategie-Auswahl
//
// Vor dieser Achse war die OP-getriebene Strategie-Auswahl NUR dokumentarisch
// (docs/datasets/OP_1_to_6_SPECIFICATIONS.md §0 Master-Tabelle) und im XSD
// (test_data_xml/messreihe_v32_schema.xsd <op_type> OP-1..OP-6), aber NICHT als
// wirksamer Runtime-Filter verdrahtet — V32Orchestrator ignorierte den op_type.
//
// op_type_filter schliesst diese Luecke: es parst das XSD-<op_type>-Token,
// bildet es auf den empfohlenen cache_engine::WorkloadKind ab und traegt die
// Hardware-/Scheduling-/Telemetry-Empfehlungen als Identifier mit. Damit wird
// die §0-Empfehlungstabelle zur EINEN autoritativen Quelle (kein doppelter Stand).
//
// Header-only, constexpr — kein Runtime-Switch im Hot-Path (Direktive
// feedback_no_runtime_switch): die Abbildung ist eine reine constexpr-Tabelle.

#include "cache_engine/builder/commands/workload.hpp"

#include <array>
#include <optional>
#include <string_view>

namespace comdare::diplomarbeit::messung_driver::v32 {

namespace cmd = comdare::cache_engine::builder::commands;

/**
 * @brief OpType — die sechs in den Datasets spezifizierten Operations-Typen (Q.2)
 * @subsystem MessungDriver
 *
 * Spiegelt die XSD-<op_type>-Enumeration OP-1..OP-6
 * (test_data_xml/messreihe_v32_schema.xsd) 1:1.
 */
enum class OpType {
    OP_1_Read,            ///< Pure Lookup (YCSB_C)
    OP_2_Insert,          ///< Bulk-Insert (custom)
    OP_3_Update,          ///< Read/Write 50/50 (YCSB_A)
    OP_4_Scan,            ///< Range-Scan 95% (YCSB_E)
    OP_5_ReadModifyWrite, ///< RMW (YCSB_F)
    OP_6_RangeDelete      ///< Range-Delete (custom)
};

/**
 * @brief OpTypeRecommendation — Empfehlungs-Tupel je OP-Typ
 *
 * Entspricht exakt einer Zeile der §0-Master-Tabelle in
 * docs/datasets/OP_1_to_6_SPECIFICATIONS.md. `workload_kind` ist die WIRKSAME
 * Auswahl (steuert die Messung); die *_hint-Felder sind die dokumentierten
 * Hardware-/Scheduling-/Telemetry-Empfehlungen (als stabile Identifier).
 */
struct OpTypeRecommendation {
    OpType            op_type{};
    std::string_view  op_label{};         ///< "OP-1".."OP-6" (XSD-Token)
    cmd::WorkloadKind workload_kind{};    ///< wirksame Workload-Auswahl
    std::string_view  simd_hint{};        ///< z.B. "AVX2", "AVX512", "Scalar"
    std::string_view  cache_level_hint{}; ///< z.B. "L1Aware", "L2Aware", "L3Aware"
    std::string_view  scheduling_hint{};  ///< z.B. "ThreadPerCore+WorkStealing"
    std::string_view  telemetry_hint{};   ///< z.B. "LeafOnlyCounter (11.X1)"
};

/// Autoritative Empfehlungstabelle (constexpr, = §0-Master-Tabelle).
/// Reihenfolge identisch zur OpType-Enum, sodass static_cast<size_t>(op) indiziert.
inline constexpr std::array<OpTypeRecommendation, 6> kOpTypeTable{{
    {OpType::OP_1_Read, "OP-1", cmd::WorkloadKind::YCSB_C_ReadOnly, "AVX2", "L1Aware", "ThreadPerCore+WorkStealing",
     "LeafOnlyCounter (11.X1)"},
    {OpType::OP_2_Insert, "OP-2", cmd::WorkloadKind::Custom_BulkInsert, "Scalar", "L3Aware", "ThreadPerCore+Limit_1",
     "RetroactiveAggregator (11.X3)"},
    {OpType::OP_3_Update, "OP-3", cmd::WorkloadKind::YCSB_A_Read50Write50, "AVX2", "L2Aware", "WorkStealing+Limit_2",
     "LeafOnlySampledCounter (11.X2)"},
    {OpType::OP_4_Scan, "OP-4", cmd::WorkloadKind::YCSB_E_Scan95, "AVX512", "L3Aware", "ThreadPerCore+MacroBatch",
     "PathReadCounter (11.X3b)"},
    {OpType::OP_5_ReadModifyWrite, "OP-5", cmd::WorkloadKind::YCSB_F_ReadModifyWrite, "AVX2", "L2Aware",
     "CpuPinning+Limit_2", "LeafOnlyCounter (11.X1)"},
    {OpType::OP_6_RangeDelete, "OP-6", cmd::WorkloadKind::Custom_RangeDelete, "Scalar", "L1Aware",
     "ThreadPerCore+Limit_1", "RetroactiveAggregator (11.X3)"},
}};

/// Empfehlung je OpType (O(1) Index in die constexpr-Tabelle).
[[nodiscard]] constexpr const OpTypeRecommendation& recommend(OpType op) noexcept {
    return kOpTypeTable[static_cast<std::size_t>(op)];
}

/// Parst das XSD-<op_type>-Token ("OP-1".."OP-6") → OpType.
/// std::nullopt bei unbekanntem/leerem Token (op_type ist minOccurs="0").
[[nodiscard]] constexpr std::optional<OpType> parse_op_type(std::string_view token) noexcept {
    for (const auto& row : kOpTypeTable) {
        if (row.op_label == token) { return row.op_type; }
    }
    return std::nullopt;
}

/// Wirkt die OP-Empfehlung auf einen Workload: setzt `kind` (wirksam) + `name`.
/// record_count/operation_count/seed des Basis-Workloads bleiben unangetastet,
/// damit Messreihen-Groesse + Determinismus extern steuerbar bleiben.
[[nodiscard]] constexpr cmd::Workload apply_op_type(OpType op, cmd::Workload base) noexcept {
    const auto& rec = recommend(op);
    base.kind       = rec.workload_kind;
    base.name       = rec.op_label;
    return base;
}

/// Komfort: XSD-Token direkt auf einen Workload anwenden.
/// Gibt false zurueck (Workload unveraendert), wenn das Token nicht erkannt wird.
[[nodiscard]] constexpr bool apply_op_type_token(std::string_view token, cmd::Workload& workload) noexcept {
    if (const auto op = parse_op_type(token)) {
        workload = apply_op_type(*op, workload);
        return true;
    }
    return false;
}

} // namespace comdare::diplomarbeit::messung_driver::v32
