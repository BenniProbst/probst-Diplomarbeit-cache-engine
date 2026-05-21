// V33.E.4 (2026-05-21) - HardwareFilter Tests (Q.1 Akzeptanz-Kriterium)

#include "../../messung_driver/hardware_filter.hpp"

#include <gtest/gtest.h>

namespace v32 = comdare::diplomarbeit::messung_driver::v32;

namespace {

v32::HostCapabilities make_avx2_only_host() {
    v32::HostCapabilities hc;
    hc.supports_avx2 = true;
    hc.supports_avx512 = false;
    return hc;
}

v32::HostCapabilities make_avx512_host() {
    v32::HostCapabilities hc;
    hc.supports_avx2 = true;
    hc.supports_avx512 = true;
    hc.numa_available = true;
    return hc;
}

}  // namespace

TEST(HardwareFilter, EmptyRequestAlwaysPasses) {
    v32::HardwareFilter filter(make_avx2_only_host());
    v32::HardwareRequest req {};
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, AVX512OnAVX2HostSkipped) {
    v32::HardwareFilter filter(make_avx2_only_host());
    v32::HardwareRequest req {};
    req.simd = "AVX512";
    auto decision = filter.evaluate(req);
    EXPECT_FALSE(decision.passes());
    EXPECT_NE(decision.reason.find("AVX512"), std::string::npos);
}

TEST(HardwareFilter, AVX2OnAVX2HostPasses) {
    v32::HardwareFilter filter(make_avx2_only_host());
    v32::HardwareRequest req {};
    req.simd = "AVX2";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, AVX512OnAVX512HostPasses) {
    v32::HardwareFilter filter(make_avx512_host());
    v32::HardwareRequest req {};
    req.simd = "AVX512";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, ScalarAlwaysPasses) {
    v32::HardwareFilter filter(v32::HostCapabilities{});  // alles default = false
    v32::HardwareRequest req {};
    req.simd = "Scalar";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, NumaInterleaveOnNonNumaHostSkipped) {
    v32::HostCapabilities hc;
    hc.supports_avx2 = true;
    hc.numa_available = false;
    v32::HardwareFilter filter(hc);

    v32::HardwareRequest req {};
    req.simd = "AVX2";
    req.numa = "Interleave";
    auto decision = filter.evaluate(req);
    EXPECT_FALSE(decision.passes());
    EXPECT_NE(decision.reason.find("NUMA"), std::string::npos);
}

TEST(HardwareFilter, NumaLocalAlwaysPasses) {
    v32::HardwareFilter filter(v32::HostCapabilities{});  // numa_available = false
    v32::HardwareRequest req {};
    req.numa = "Local";
    auto decision = filter.evaluate(req);
    EXPECT_TRUE(decision.passes());
}

TEST(HardwareFilter, NeonOnX86Skipped) {
    v32::HardwareFilter filter(make_avx2_only_host());
    v32::HardwareRequest req {};
    req.simd = "NEON";
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
    SUCCEED();  // mindestens default-Konstruktion
}
