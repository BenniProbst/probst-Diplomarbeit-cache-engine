// V33.E.4 (2026-05-21) - HardwareFilter Tests (Q.1 Akzeptanz-Kriterium)

#include "../../02_messung_driver/hardware_filter.hpp"

#include <gtest/gtest.h>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;

namespace {

v32::HostCapabilities make_avx2_only_host() {
    v32::HostCapabilities hc;
    hc.supports_avx2   = true;
    hc.supports_avx512 = false;
    return hc;
}

v32::HostCapabilities make_avx512_host() {
    v32::HostCapabilities hc;
    hc.supports_avx2   = true;
    hc.supports_avx512 = true;
    hc.numa_available  = true;
    return hc;
}

} // namespace

TEST(HardwareFilter, EmptyRequestAlwaysPasses) {
    v32::HardwareFilter  filter(make_avx2_only_host());
    v32::HardwareRequest req{};
    auto                 decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, AVX512OnAVX2HostSkipped) {
    v32::HardwareFilter  filter(make_avx2_only_host());
    v32::HardwareRequest req{};
    req.simd      = "AVX512";
    auto decision = filter.evaluate(req);
    EXPECT_FALSE(decision.passes());
    EXPECT_NE(decision.reason.find("AVX512"), std::string::npos);
}

TEST(HardwareFilter, AVX2OnAVX2HostPasses) {
    v32::HardwareFilter  filter(make_avx2_only_host());
    v32::HardwareRequest req{};
    req.simd      = "AVX2";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, AVX512OnAVX512HostPasses) {
    v32::HardwareFilter  filter(make_avx512_host());
    v32::HardwareRequest req{};
    req.simd      = "AVX512";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, ScalarAlwaysPasses) {
    v32::HardwareFilter  filter(v32::HostCapabilities{}); // alles default = false
    v32::HardwareRequest req{};
    req.simd      = "Scalar";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, NumaInterleaveOnNonNumaHostSkipped) {
    v32::HostCapabilities hc;
    hc.supports_avx2  = true;
    hc.numa_available = false;
    v32::HardwareFilter filter(hc);

    v32::HardwareRequest req{};
    req.simd      = "AVX2";
    req.numa      = "Interleave";
    auto decision = filter.evaluate(req);
    EXPECT_FALSE(decision.passes());
    EXPECT_NE(decision.reason.find("NUMA"), std::string::npos);
}

TEST(HardwareFilter, NumaLocalAlwaysPasses) {
    v32::HardwareFilter  filter(v32::HostCapabilities{}); // numa_available = false
    v32::HardwareRequest req{};
    req.numa      = "Local";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, NeonOnX86Skipped) {
    v32::HardwareFilter  filter(make_avx2_only_host());
    v32::HardwareRequest req{};
    req.simd      = "NEON";
    auto decision = filter.evaluate(req);
    EXPECT_FALSE(decision.passes());
}

TEST(HostCapabilities, DetectCompileTime) {
    auto hc = v32::HostCapabilities::detect_compile_time();
    // Auf x86_64 erwarten wir mindestens SSE/AVX
#if defined(__AVX2__)
    EXPECT_TRUE(hc.supports_avx2);
#endif
#if defined(__AVX512F__)
    EXPECT_TRUE(hc.supports_avx512);
#endif
    SUCCEED(); // mindestens default-Konstruktion
}

// ===========================================================================
// V35.B.5 — CompilerRequest Tests (Achse 15)
// ===========================================================================

TEST(CompilerFilter, EmptyRequestPasses) {
    v32::HardwareFilter  filter(v32::HostCapabilities{});
    v32::CompilerRequest req{};
    EXPECT_TRUE(filter.evaluate(req).passes());
}

TEST(CompilerFilter, MatchingFamilyPasses) {
    auto                 hc = v32::HostCapabilities::detect_compile_time();
    v32::HardwareFilter  filter(hc);
    v32::CompilerRequest req{};
    req.family    = std::string(v32::compiler_family_name(hc.compiler_family));
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes()) << decision.reason;
}

TEST(CompilerFilter, WrongFamilyIsSkipped) {
    auto                 hc = v32::HostCapabilities::detect_compile_time();
    v32::HardwareFilter  filter(hc);
    v32::CompilerRequest req{};
    // bewusst falsche Family
    req.family    = (hc.compiler_family == v32::CompilerFamily::MSVC) ? "GCC" : "MSVC";
    auto decision = filter.evaluate(req);
    EXPECT_FALSE(decision.passes());
    EXPECT_TRUE(decision.reason.find(req.family) != std::string::npos);
}

TEST(CompilerFilter, AVX512TargetArchOnNonAVX512HostSkipped) {
    v32::HostCapabilities hc;
    hc.supports_avx2   = true;
    hc.supports_avx512 = false;
    v32::HardwareFilter  filter(hc);
    v32::CompilerRequest req{};
    req.target_arch = "x86-64-v4";
    auto decision   = filter.evaluate(req);
    EXPECT_FALSE(decision.passes());
    EXPECT_TRUE(decision.reason.find("x86-64-v4") != std::string::npos);
}

TEST(CompilerFilter, OptLevelAndLtoAreSoftConstraints) {
    auto                 hc = v32::HostCapabilities::detect_compile_time();
    v32::HardwareFilter  filter(hc);
    v32::CompilerRequest req{};
    // Family leer = kein Check; OptLevel/LTO/PGO sind Compile-Time-only
    req.opt_level = "Ofast";
    req.lto       = "FullLTO";
    req.pgo       = "Generate";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(CompilerFamilyName, AllVariantsHaveDistinctNames) {
    EXPECT_EQ(v32::compiler_family_name(v32::CompilerFamily::GCC), "GCC");
    EXPECT_EQ(v32::compiler_family_name(v32::CompilerFamily::Clang), "Clang");
    EXPECT_EQ(v32::compiler_family_name(v32::CompilerFamily::AppleClang), "AppleClang");
    EXPECT_EQ(v32::compiler_family_name(v32::CompilerFamily::MSVC), "MSVC");
    EXPECT_EQ(v32::compiler_family_name(v32::CompilerFamily::Unknown), "Unknown");
}

TEST(HostCapabilities, DetectsCompilerAtCompileTime) {
    auto hc = v32::HostCapabilities::detect_compile_time();
    EXPECT_TRUE(hc.compiler_family != v32::CompilerFamily::Unknown)
        << "detected family: " << v32::compiler_family_name(hc.compiler_family);
}
