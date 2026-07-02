// SPDX-License-Identifier: Apache-2.0
// Tests fuer binary_to_csv

#include "binary_to_csv.hpp"

#include <gtest/gtest.h>

#include <filesystem>
#include <fstream>
#include <vector>

namespace btc = comdare::da::binary_to_csv;

namespace {

class BinaryToCsvFixture : public ::testing::Test {
protected:
    void SetUp() override {
        tmp_ = std::filesystem::temp_directory_path() /
               ("da_btc_test_" + std::to_string(::testing::UnitTest::GetInstance()->random_seed()));
        std::filesystem::create_directories(tmp_);
    }
    void TearDown() override {
        std::error_code ec;
        std::filesystem::remove_all(tmp_, ec);
    }
    std::filesystem::path tmp_;
};

void write_test_binary(std::filesystem::path const& p, std::vector<btc::LabeledRecord> const& records) {
    std::ofstream out{p, std::ios::binary};
    out.write(reinterpret_cast<char const*>(&btc::kBinaryMagic), sizeof(btc::kBinaryMagic));
    out.write(reinterpret_cast<char const*>(&btc::kBinaryVersion), sizeof(btc::kBinaryVersion));
    std::uint64_t n = records.size();
    out.write(reinterpret_cast<char const*>(&n), sizeof(n));
    for (auto const& r : records) {
        std::uint32_t id_len = static_cast<std::uint32_t>(r.permutation_id.size());
        out.write(reinterpret_cast<char const*>(&id_len), sizeof(id_len));
        out.write(r.permutation_id.data(), id_len);
        out.write(reinterpret_cast<char const*>(&r.fingerprint), sizeof(r.fingerprint));
        std::uint8_t succ = r.succeeded ? 1 : 0;
        out.write(reinterpret_cast<char const*>(&succ), sizeof(succ));
        // V41.P1: Container-v2 schreibt workload_used (laengen-praefixiert) vor dem POD-Record.
        std::uint32_t wl_len = static_cast<std::uint32_t>(r.workload_used.size());
        out.write(reinterpret_cast<char const*>(&wl_len), sizeof(wl_len));
        out.write(r.workload_used.data(), wl_len);
        out.write(reinterpret_cast<char const*>(&r.record), sizeof(r.record));
    }
}

} // namespace

TEST_F(BinaryToCsvFixture, RoundtripSingleRecord) {
    btc::LabeledRecord r;
    r.permutation_id      = "test_perm";
    r.fingerprint         = 0xC0FFEE;
    r.succeeded           = true;
    r.workload_used       = "YCSB_A"; // V41.P1
    r.record.version      = 1;
    r.record.op_count     = 500;
    r.record.total_cycles = 99999;

    auto bin_path = tmp_ / "test.bin";
    write_test_binary(bin_path, {r});

    std::vector<btc::LabeledRecord> loaded;
    EXPECT_EQ(btc::read_binary(bin_path, loaded), btc::status_ok);
    ASSERT_EQ(loaded.size(), 1u);
    EXPECT_EQ(loaded[0].permutation_id, "test_perm");
    EXPECT_EQ(loaded[0].fingerprint, 0xC0FFEEu);
    EXPECT_EQ(loaded[0].workload_used, "YCSB_A"); // V41.P1: roundtrip
    EXPECT_EQ(loaded[0].record.op_count, 500u);
    EXPECT_EQ(loaded[0].record.total_cycles, 99999u);
}

TEST_F(BinaryToCsvFixture, MissingFileReturnsIoError) {
    std::vector<btc::LabeledRecord> dummy;
    EXPECT_EQ(btc::read_binary("/nonexistent/path.bin", dummy), btc::status_io_error);
}

TEST_F(BinaryToCsvFixture, InvalidMagicReturnsFormatError) {
    auto bin_path = tmp_ / "bad.bin";
    {
        std::ofstream out{bin_path, std::ios::binary};
        std::uint32_t bad_magic = 0xDEADBEEF;
        out.write(reinterpret_cast<char const*>(&bad_magic), sizeof(bad_magic));
        std::uint32_t ver = 1;
        std::uint64_t n   = 0;
        out.write(reinterpret_cast<char const*>(&ver), sizeof(ver));
        out.write(reinterpret_cast<char const*>(&n), sizeof(n));
    }
    std::vector<btc::LabeledRecord> loaded;
    EXPECT_EQ(btc::read_binary(bin_path, loaded), btc::status_invalid_format);
}

TEST_F(BinaryToCsvFixture, WriteCsvHasHeader) {
    btc::LabeledRecord r;
    r.permutation_id  = "test";
    r.fingerprint     = 1;
    r.succeeded       = true;
    r.record.op_count = 100;
    auto csv_path     = tmp_ / "test.csv";
    EXPECT_EQ(btc::write_csv(csv_path, {&r, 1}), btc::status_ok);

    std::ifstream in{csv_path};
    std::string   line;
    std::getline(in, line);
    EXPECT_NE(line.find("permutation_id"), std::string::npos);
    EXPECT_NE(line.find("workload_used"), std::string::npos); // V41.P1: 16-Spalten-Schema
    EXPECT_NE(line.find("op_count"), std::string::npos);
}

TEST_F(BinaryToCsvFixture, RoundtripThreeRecords) {
    std::vector<btc::LabeledRecord> records(3);
    for (std::size_t i = 0; i < 3; ++i) {
        records[i].permutation_id  = "perm_" + std::to_string(i);
        records[i].fingerprint     = 0xA0 + i;
        records[i].succeeded       = true;
        records[i].record.op_count = 100 * (i + 1);
    }
    auto bin_path = tmp_ / "three.bin";
    write_test_binary(bin_path, records);

    std::vector<btc::LabeledRecord> loaded;
    EXPECT_EQ(btc::read_binary(bin_path, loaded), btc::status_ok);
    ASSERT_EQ(loaded.size(), 3u);
    EXPECT_EQ(loaded[0].record.op_count, 100u);
    EXPECT_EQ(loaded[2].record.op_count, 300u);
}
