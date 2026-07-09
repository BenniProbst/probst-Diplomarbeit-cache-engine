// V35.D.1 (2026-05-22) - Stufen-Test mit gecachten Fixtures (03_binary_to_csv)
//
// @subsystem Pipeline-Stufe 03
// @phase_owner Stufe 03
//
// Konsumiert gecachte binary records aus tests/fixtures/cached/
// (analog dem Format das Stufe 02_messung_driver produziert).
// Beim ersten Lauf werden Fixtures programmatisch erzeugt + auf Disk persistiert
// (in CI/Klon kann der User die committed Versionen direkt verwenden).

#include "binary_to_csv.hpp"

#include <gtest/gtest.h>

#include <cstdint>
#include <filesystem>
#include <fstream>
#include <vector>
#include <unistd.h>

namespace btc = comdare::da::binary_to_csv;
namespace fs  = std::filesystem;

namespace {

// Benutzer-eindeutige tmp-Basis: /tmp ist host-weit geteilt (prod1: lokale Läufe als comdare, CI als
// gitlab-runner) — feste Namen gehören dem Erst-Ersteller und blocken den jeweils anderen (8081/213626).
std::filesystem::path comdare_user_tmp() {
    auto p = std::filesystem::temp_directory_path() / ("comdare_test_" + std::to_string(::getuid()));
    std::filesystem::create_directories(p);
    return p;
}

/// V35.D.1 Helper — schreibt Binary-Records im Format von Stufe 02_messung_driver
void write_binary_fixture(fs::path const& p, std::vector<btc::LabeledRecord> const& records) {
    fs::create_directories(p.parent_path());
    std::ofstream out{p, std::ios::binary | std::ios::trunc};
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
        out.write(reinterpret_cast<char const*>(&r.record), sizeof(r.record));
    }
}

/// V35.D.1 Helper — ensure_cached_fixture: generiert wenn nicht existiert
void ensure_cached_fixture(fs::path const& p, std::vector<btc::LabeledRecord> const& records) {
    if (!fs::exists(p)) { write_binary_fixture(p, records); }
}

/// V35.D.1 — Fixture-Pfade unter <repo>/Code/03_binary_to_csv/tests/fixtures/cached/
/// Resolution: COMDARE_FIXTURES_DIR env-var > Source-Dir relative
fs::path fixtures_dir() {
    // CMake-Helper: in tests/CMakeLists.txt setzen wir COMDARE_FIXTURES_DIR_03=...
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_03"); env != nullptr) { return fs::path(env); }
#ifdef COMDARE_FIXTURES_DIR_03_FALLBACK
    // Deterministischer Fallback = per-Stufe Source-Dir (von CMake einkompiliert) — KEIN CWD-Stray.
    // Früher: fs::current_path()/"fixtures"/"cached" — legte bei manuellem .exe-Start aus der DA-Wurzel
    // ein verirrtes fixtures/ an (V35.D.1-Altlast, 2026-06-01 gehärtet).
    return fs::path(COMDARE_FIXTURES_DIR_03_FALLBACK);
#else
    return fs::current_path() / "fixtures" / "cached"; // letzter Notnagel (CMake liefert den Fallback i.d.R.)
#endif
}

std::vector<btc::LabeledRecord> make_sample_3_records() {
    std::vector<btc::LabeledRecord> v(3);
    for (std::size_t i = 0; i < 3; ++i) {
        v[i].permutation_id           = "perm_zipf_" + std::to_string(i);
        v[i].fingerprint              = 0xCAFE0000ULL + i;
        v[i].succeeded                = true;
        v[i].record.version           = 1;
        v[i].record.op_count          = (i + 1) * 1000;
        v[i].record.total_cycles      = (i + 1) * 25'000;
        v[i].record.cache_misses_l1   = (i + 1) * 50;
        v[i].record.cache_misses_l2   = (i + 1) * 10;
        v[i].record.cache_misses_l3   = (i + 1) * 2;
        v[i].record.bytes_allocated   = (i + 1) * 4096;
        v[i].record.bytes_in_use_peak = (i + 1) * 3072;
    }
    return v;
}

std::vector<btc::LabeledRecord> make_failed_run() {
    std::vector<btc::LabeledRecord> v(1);
    v[0].permutation_id  = "perm_failed";
    v[0].fingerprint     = 0xDEAD;
    v[0].succeeded       = false;
    v[0].record.op_count = 0;
    return v;
}

} // namespace

// ============================================================================
// V35.D.1 — Fixture-Setup (Generator-as-Test)
// ============================================================================

TEST(Stufe03Pipeline, CachedFixturesExistOrAreGenerated) {
    auto dir = fixtures_dir();
    ensure_cached_fixture(dir / "sample_3_records.bin", make_sample_3_records());
    ensure_cached_fixture(dir / "sample_failed.bin", make_failed_run());

    EXPECT_TRUE(fs::exists(dir / "sample_3_records.bin"));
    EXPECT_TRUE(fs::exists(dir / "sample_failed.bin"));
    // Size-Check: 3-Record-Fixture muss > 100 Bytes sein
    EXPECT_GT(fs::file_size(dir / "sample_3_records.bin"), 100u);
}

// ============================================================================
// V35.D.1 — Consumer-Tests (echte Pipeline-Stufe gegen Fixture)
// ============================================================================

TEST(Stufe03Pipeline, ReadCachedSample3Records) {
    auto dir = fixtures_dir();
    ensure_cached_fixture(dir / "sample_3_records.bin", make_sample_3_records());
    std::vector<btc::LabeledRecord> loaded;
    ASSERT_EQ(btc::read_binary(dir / "sample_3_records.bin", loaded), btc::status_ok);
    ASSERT_EQ(loaded.size(), 3u);
    EXPECT_EQ(loaded[0].permutation_id, "perm_zipf_0");
    EXPECT_EQ(loaded[0].record.op_count, 1000u);
    EXPECT_EQ(loaded[1].record.cache_misses_l1, 100u);
    EXPECT_EQ(loaded[2].record.bytes_allocated, 12288u);
    EXPECT_TRUE(loaded[2].succeeded);
}

TEST(Stufe03Pipeline, ReadFailedRunFixture) {
    auto dir = fixtures_dir();
    ensure_cached_fixture(dir / "sample_failed.bin", make_failed_run());
    std::vector<btc::LabeledRecord> loaded;
    ASSERT_EQ(btc::read_binary(dir / "sample_failed.bin", loaded), btc::status_ok);
    ASSERT_EQ(loaded.size(), 1u);
    EXPECT_FALSE(loaded[0].succeeded);
    EXPECT_EQ(loaded[0].record.op_count, 0u);
}

TEST(Stufe03Pipeline, WriteCsvFromCachedFixture) {
    auto dir = fixtures_dir();
    ensure_cached_fixture(dir / "sample_3_records.bin", make_sample_3_records());
    std::vector<btc::LabeledRecord> loaded;
    ASSERT_EQ(btc::read_binary(dir / "sample_3_records.bin", loaded), btc::status_ok);

    auto csv_out = comdare_user_tmp() / "v35d1_pipeline_test.csv";
    ASSERT_EQ(btc::write_csv(csv_out, loaded), btc::status_ok);

    std::string content;
    {
        std::ifstream in(csv_out);
        content.assign((std::istreambuf_iterator<char>(in)), {});
    } // ifstream out-of-scope -> Datei wird geschlossen
    EXPECT_NE(content.find("permutation_id,fingerprint,succeeded"), std::string::npos);
    EXPECT_NE(content.find("perm_zipf_0"), std::string::npos);
    EXPECT_NE(content.find("perm_zipf_1"), std::string::npos);
    EXPECT_NE(content.find("perm_zipf_2"), std::string::npos);

    std::error_code ec;
    fs::remove(csv_out, ec); // best-effort cleanup
}

TEST(Stufe03Pipeline, FullPipelineThreeStepsBinaryToCsv) {
    // Stufe 03 isoliert: nimmt Vorgaenger-Output (binary), produziert Stufe-04-Input (CSV)
    auto dir = fixtures_dir();
    ensure_cached_fixture(dir / "sample_3_records.bin", make_sample_3_records());

    // Schritt A: Read binary (= Stufe 02 Output)
    std::vector<btc::LabeledRecord> records;
    ASSERT_EQ(btc::read_binary(dir / "sample_3_records.bin", records), btc::status_ok);
    ASSERT_EQ(records.size(), 3u);

    // Schritt B: Write CSV (= Stufe 04 Input)
    auto csv_out = comdare_user_tmp() / "v35d1_pipeline_intermediate.csv";
    ASSERT_EQ(btc::write_csv(csv_out, records), btc::status_ok);

    // Schritt C: Verifiziere CSV-Schema-Konsistenz
    int data_rows     = 0;
    int header_commas = 0;
    {
        std::ifstream in(csv_out);
        std::string   header_line;
        std::getline(in, header_line);
        // Zaehle Kommas: kanonisches 16-Spalten-Format (P1/#50, mit workload_used@idx3) hat 15 Kommas.
        // (Frühere Erwartung 14 = 15-Spalten-Altschema, vor der 16-col-Migration; 2026-06-01 nachgezogen.)
        header_commas = static_cast<int>(std::count(header_line.begin(), header_line.end(), ','));

        std::string row;
        while (std::getline(in, row)) ++data_rows;
    }
    EXPECT_EQ(header_commas, 15);
    EXPECT_EQ(data_rows, 3);

    std::error_code ec;
    fs::remove(csv_out, ec);
}
