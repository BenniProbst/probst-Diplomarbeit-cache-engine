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

// ---------------------------------------------------------------------------
// HOHLE WACHE, gefunden im clang-Warnungs-Review am 09.08.2026 (-Wunused-variable auf 'hc').
//
// BESTAND war:
//     auto hc = v32::HostCapabilities::detect_compile_time();
//     #if defined(__AVX2__)   EXPECT_TRUE(hc.supports_avx2);   #endif
//     #if defined(__AVX512F__) EXPECT_TRUE(hc.supports_avx512); #endif
//     SUCCEED();
//
// ZWEI Defekte, beide vom Uebersetzer belegt, nicht vermutet:
//  (1) NULL Zusicherungen. Das Projekt uebersetzt ohne -march/-mavx2, also ist WEDER __AVX2__ NOCH
//      __AVX512F__ definiert; beide #if-Bloecke verschwinden im Praeprozessor. Uebrig blieb
//      "auto hc = ...; SUCCEED();". Genau deshalb meldete clang 'hc' als UNBENUTZT -- die Warnung
//      war das einzige Signal, dass diese Wache nichts mehr zusichert. Der Test war gruen
//      per Konstruktion.
//  (2) Nur die WAHR-Richtung. Selbst mit -mavx2 stand dort ausschliesslich "Makro gesetzt =>
//      Flag true". Die Gegenrichtung fehlte, und genau sie faengt die realistische Mutation:
//      ein hart verdrahtetes supports_avx2 = true haette den Bestandstest NIE rot gemacht.
//
// WAS JETZT ZUGESICHERT WIRD: fuer JEDES der vier ISA-Flags BEIDE Richtungen (Makro gesetzt =>
// true, Makro nicht gesetzt => false), also in jeder Bau-Konfiguration 4 laufende Zusicherungen
// statt 0 bis 2. Der Nenner steht in der Ausgabe (RecordProperty + SCOPED_TRACE), damit eine
// spaetere Null von einem echten Freispruch unterscheidbar bleibt.
//
// EHRLICHE GRENZE (bewusst nicht ueberschritten): das Orakel teilt sich die Praeprozessor-Makros
// mit dem Prueflind, ist also kein VOLL unabhaengiges Orakel im Sinne T-3/T-5. Das unabhaengige
// Orakel waere die Bauflagge selbst: dieselbe Erhebung in zwei TUs, eine mit -mavx2, eine mit
// -mno-avx2. Dieser Weg ist HIER NICHT GANGBAR, und das ist der Grund: detect_compile_time() ist
// eine inline Member-Funktion im Header. Zwei TUs mit verschiedenem Makro-Stand ergaeben zwei
// verschiedene Rueumpfe DERSELBEN inline-Funktion -- eine ODR-Verletzung (IFNDR). Der Linker
// behaelt genau EIN COMDAT, ohne -O2 wird nicht inlinet, und beide Sonden lieferten still
// denselben Wert. Der Test waere dann kein schaerferes Messgeraet, sondern ein LUEGENDES.
// Die saubere Loesung ist ein Architektur-Schnitt (ISA-Erhebung in EINE TU statt inline im
// Header) und liegt als benanntes Paket beim Owner -- nicht als halber Umbau hier.
// ---------------------------------------------------------------------------
TEST(HostCapabilities, DetectCompileTimeMirrorsBuildFlagsBothDirections) {
    auto const hc = v32::HostCapabilities::detect_compile_time();

    // Nenner in die Ausgabe: wie viele ISA-Flags diese Wache ueberhaupt prueft.
    int constexpr kIsaFlagsChecked = 4;
    RecordProperty("isa_flags_checked", kIsaFlagsChecked);
    RecordProperty("isa_flags_total", 4);

    {
        SCOPED_TRACE("ISA-Flag 1 von 4: supports_avx2 (__AVX2__)");
#if defined(__AVX2__)
        EXPECT_TRUE(hc.supports_avx2) << "__AVX2__ ist gesetzt, das Flag muss true sein";
#else
        EXPECT_FALSE(hc.supports_avx2) << "__AVX2__ ist NICHT gesetzt, das Flag darf nicht true sein";
#endif
    }
    {
        SCOPED_TRACE("ISA-Flag 2 von 4: supports_avx512 (__AVX512F__)");
#if defined(__AVX512F__)
        EXPECT_TRUE(hc.supports_avx512) << "__AVX512F__ ist gesetzt, das Flag muss true sein";
#else
        EXPECT_FALSE(hc.supports_avx512) << "__AVX512F__ ist NICHT gesetzt, das Flag darf nicht true sein";
#endif
    }
    {
        SCOPED_TRACE("ISA-Flag 3 von 4: supports_neon (__ARM_NEON)");
#if defined(__ARM_NEON)
        EXPECT_TRUE(hc.supports_neon) << "__ARM_NEON ist gesetzt, das Flag muss true sein";
#else
        EXPECT_FALSE(hc.supports_neon) << "__ARM_NEON ist NICHT gesetzt, das Flag darf nicht true sein";
#endif
    }
    {
        SCOPED_TRACE("ISA-Flag 4 von 4: supports_sve2 (__ARM_FEATURE_SVE2)");
#if defined(__ARM_FEATURE_SVE2)
        EXPECT_TRUE(hc.supports_sve2) << "__ARM_FEATURE_SVE2 ist gesetzt, das Flag muss true sein";
#else
        EXPECT_FALSE(hc.supports_sve2) << "__ARM_FEATURE_SVE2 ist NICHT gesetzt, das Flag darf nicht true sein";
#endif
    }

    // Gegenprobe zur Selbstverwechslung: x86- und ARM-Flags duerfen nie gleichzeitig gesetzt sein.
    // Faengt die Kopier-Mutation (avx512 aus dem avx2-Makro, neon aus dem x86-Zweig) unabhaengig
    // von der Makro-Lage der Plattform.
    EXPECT_FALSE((hc.supports_avx2 || hc.supports_avx512) && (hc.supports_neon || hc.supports_sve2))
        << "x86- und ARM-ISA gleichzeitig gemeldet -- die Zweige sind vertauscht oder kopiert";

    // Der Compiler, der DIESE TU uebersetzt, muss erkannt sein. Unknown = Erkennung ist durchgefallen.
    EXPECT_NE(hc.compiler_family, v32::CompilerFamily::Unknown)
        << "compiler_family bleibt Unknown -- die Compiler-Erkennung greift fuer diesen Uebersetzer nicht";
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
