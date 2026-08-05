// Einmal-Sonde (kein Repo-Artefakt): misst die realen Glied-Laengen des Format-3-Preimage.
#include <builder/driver_build_variant_signature.hpp>
#include <cache_engine/abi/anatomy_fingerprint.hpp>
#include <cache_engine/abi/anatomy_version_stamp.hpp>
#include <cache_engine/abi/toolchain_stamp_glied.hpp>
#include <cstdio>
#include <string>

int main() {
    namespace abi = comdare::cache_engine::abi;
    namespace ex  = comdare::cache_engine::builder::experiment;

    std::string const system = std::string{abi::system_stamp_line()};
    std::string const mess   = abi::measurement_stamp_line_full_set();
    std::string const bvset{ex::kDriverBuildVariantSignature};

    abi::ToolchainStampParts p{};
    p.cxx_dialect = "clang"; p.cxx_realversion = "22.1.8";
    p.opt = "Ofast"; p.opt_flags = "-Ofast -ffast-math";
    p.simd = "avx512"; p.ceb = "8.0"; p.target_isa = "aarch64"; p.telemetry = "silent";
    p.build_type = "Debug"; p.gate_contribution = "avx512";
    p.atomic128 = "cx16"; p.atomic128_flags = "-mcx16";
    std::string const tc = abi::render_toolchain_stamp_glied(p);

    std::size_t const organ_max = abi::kAnatomyFingerprintOrganMax;
    std::size_t const summe_real = abi::kAnatomyFingerprintFormat.size() + organ_max + system.size() + mess.size() +
                                   abi::kSubAxisValuesetSegment.size() + tc.size() + bvset.size() + 128u + 7u;

    std::printf("== BUDGET-NACHWEIS Format 3 (reale Messung am Objekt) ==\n");
    std::printf("[0] Format-Kennung   IST %4zu  BUDGET %4zu   '%s'\n", abi::kAnatomyFingerprintFormat.size(),
                abi::kAnatomyFingerprintFormatMax, std::string{abi::kAnatomyFingerprintFormat}.c_str());
    std::printf("[1] Organ-Zeile      IST    -  BUDGET %4zu   (Obergrenze aus golden-320: 546 + 18*12 = 762)\n",
                abi::kAnatomyFingerprintOrganMax);
    std::printf("[2] System-Zeile     IST %4zu  BUDGET %4zu\n", system.size(), abi::kAnatomyFingerprintSystemMax);
    std::printf("[3] Mess-Zeile       IST %4zu  BUDGET %4zu\n", mess.size(), abi::kAnatomyFingerprintMeasurementMax);
    std::printf("[4] Werteset         IST %4zu  BUDGET %4zu   '%s'\n", abi::kSubAxisValuesetSegment.size(),
                abi::kAnatomyFingerprintValuesetMax, std::string{abi::kSubAxisValuesetSegment}.c_str());
    std::printf("[5] Toolchain (voll) IST %4zu  BUDGET %4zu\n", tc.size(), abi::kAnatomyFingerprintToolchainMax);
    std::printf("      -> '%s'\n", tc.c_str());
    std::printf("[6] bvset (LEBEND)   IST %4zu  BUDGET %4zu\n", bvset.size(), abi::kAnatomyFingerprintBvsetMax);
    std::printf("[7] Overlay          IST %4zu  BUDGET %4zu   (leer, L14/Phase 6)\n",
                abi::kOverlaySourceHash.size(), abi::kAnatomyFingerprintOverlayMax);
    std::printf("Separatoren: %zu\n", abi::kAnatomyFingerprintGliedCount - 1);
    std::printf("SUMME BUDGETS (static_assert-Wert) = %zu  <=  kAnatomyFingerprintPreimageMax = %zu\n",
                abi::kAnatomyFingerprintBudgetSum, abi::kAnatomyFingerprintPreimageMax);
    std::printf("SUMME REAL (Organ mit Obergrenze 768, Rest gemessen) = %zu  <=  %zu\n", summe_real,
                abi::kAnatomyFingerprintPreimageMax);
    std::printf("KOPFRAUM = %zu Bytes\n", abi::kAnatomyFingerprintPreimageMax - abi::kAnatomyFingerprintBudgetSum);
    return 0;
}
