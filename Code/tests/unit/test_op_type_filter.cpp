// V41.P5 (G10, 2026-05-31) — op_type_filter Tests
//
// Beweist die wirksame OP-1..OP-6 → WorkloadKind-Abbildung (datasets §0 Master)
// + Parsing des XSD-<op_type>-Tokens + apply_op_type auf den Workload.
//
// @subsystem MessungDriver (Subsystem 1)

#include "../../02_messung_driver/op_type_filter.hpp"

#include <gtest/gtest.h>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;
namespace cmd = comdare::cache_engine::builder::commands;

// --- §0-Master-Tabelle: jede Zeile wirksam (workload_kind), nicht nur dokumentarisch ---

TEST(OpTypeFilter, MasterTableMapsAllSixOpsToWorkloadKind) {
    EXPECT_EQ(v32::recommend(v32::OpType::OP_1_Read).workload_kind, cmd::WorkloadKind::YCSB_C_ReadOnly);
    EXPECT_EQ(v32::recommend(v32::OpType::OP_2_Insert).workload_kind, cmd::WorkloadKind::Custom_BulkInsert);
    EXPECT_EQ(v32::recommend(v32::OpType::OP_3_Update).workload_kind, cmd::WorkloadKind::YCSB_A_Read50Write50);
    EXPECT_EQ(v32::recommend(v32::OpType::OP_4_Scan).workload_kind, cmd::WorkloadKind::YCSB_E_Scan95);
    EXPECT_EQ(v32::recommend(v32::OpType::OP_5_ReadModifyWrite).workload_kind,
              cmd::WorkloadKind::YCSB_F_ReadModifyWrite);
    EXPECT_EQ(v32::recommend(v32::OpType::OP_6_RangeDelete).workload_kind, cmd::WorkloadKind::Custom_RangeDelete);
}

// --- compile-time-Garantie: die Tabelle ist constexpr auswertbar (Hot-Path-Direktive) ---

TEST(OpTypeFilter, TableIsConstexpr) {
    static_assert(v32::recommend(v32::OpType::OP_4_Scan).workload_kind == cmd::WorkloadKind::YCSB_E_Scan95,
                  "OP-4 muss compile-time auf YCSB_E_Scan95 abbilden");
    static_assert(v32::kOpTypeTable.size() == 6, "genau 6 OP-Typen");
    SUCCEED();
}

// --- XSD-Token-Parsing OP-1..OP-6 ---

TEST(OpTypeFilter, ParsesXsdTokens) {
    EXPECT_EQ(v32::parse_op_type("OP-1"), v32::OpType::OP_1_Read);
    EXPECT_EQ(v32::parse_op_type("OP-6"), v32::OpType::OP_6_RangeDelete);
    EXPECT_FALSE(v32::parse_op_type("OP-7").has_value());
    EXPECT_FALSE(v32::parse_op_type("").has_value());
    EXPECT_FALSE(v32::parse_op_type("garbage").has_value());
}

// --- apply_op_type: setzt kind wirksam, erhaelt record/op-count/seed ---

TEST(OpTypeFilter, ApplyPreservesSizeAndSeedButSetsKind) {
    cmd::Workload base;
    base.record_count    = 5'000'000;
    base.operation_count = 250'000;
    base.seed            = 1234;

    const auto w = v32::apply_op_type(v32::OpType::OP_2_Insert, base);
    EXPECT_EQ(w.kind, cmd::WorkloadKind::Custom_BulkInsert);
    EXPECT_EQ(w.name, std::string_view{"OP-2"});
    EXPECT_EQ(w.record_count, 5'000'000u);  // unangetastet
    EXPECT_EQ(w.operation_count, 250'000u); // unangetastet
    EXPECT_EQ(w.seed, 1234u);               // Determinismus erhalten
}

// --- apply_op_type_token: Komfort-Pfad + Fehlschlag laesst Workload unveraendert ---

TEST(OpTypeFilter, ApplyTokenReturnsFalseAndKeepsWorkloadOnUnknown) {
    cmd::Workload w;
    w.kind = cmd::WorkloadKind::YCSB_B_Read95Write5;
    EXPECT_FALSE(v32::apply_op_type_token("OP-99", w));
    EXPECT_EQ(w.kind, cmd::WorkloadKind::YCSB_B_Read95Write5); // unveraendert

    EXPECT_TRUE(v32::apply_op_type_token("OP-4", w));
    EXPECT_EQ(w.kind, cmd::WorkloadKind::YCSB_E_Scan95);
}

// --- Hardware-/Scheduling-/Telemetry-Hints stimmen mit §0-Master ueberein (Spot-Check) ---

TEST(OpTypeFilter, HintsMatchMasterTable) {
    const auto& op4 = v32::recommend(v32::OpType::OP_4_Scan);
    EXPECT_EQ(op4.simd_hint, std::string_view{"AVX512"});
    EXPECT_EQ(op4.cache_level_hint, std::string_view{"L3Aware"});

    const auto& op1 = v32::recommend(v32::OpType::OP_1_Read);
    EXPECT_EQ(op1.simd_hint, std::string_view{"AVX2"});
    EXPECT_EQ(op1.cache_level_hint, std::string_view{"L1Aware"});
}
