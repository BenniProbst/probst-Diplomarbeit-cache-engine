#pragma once
// Scheibe 2a (2026-07-21, Ledger 61/62) - Lane-Fehlrouting-Wache: Runtime-CPU-Vendor-Detektion.
//
// @subsystem MessungDriver
// @phase_owner MessungDriver
//
// Zweck: die emittierte Lane-Form COMDARE_PLATFORM="amd@<host>" / "intel@<host>" (ce emit_measure_job,
// (h)/(k)-Host-Lanes) traegt bereits die beabsichtigte CPU-Hersteller-Zuordnung. Vor JEDER Messung
// prueft der Treiber per Laufzeit-CPUID (kein Compile-Time-#ifdef -- der DLL-Bau ist build-typ-blind
// und compile_time_platform_tag ist grob "linux-x86_64", kann Zen5 nicht von RaptorLake trennen), ob
// die reale CPU zur Lane passt. Ein Fehlrouting (avx512-Zelle auf Intel, Combo-macro-Lane auf AMD)
// waere ein BETRIEBS-Fehler: er wuerde stundenlang Messdaten unter falscher Hardware-Provenienz
// schreiben. Statt still weiterzumessen bricht der Treiber HART ab (exit != 0) -> die CI wird rot.
//
// Bruecke zu #49 (feine Hardware-Identitaet: RAM-Frequenz/CAS, exakte CPU-Fabrikation) und #46
// (Cache-Log-Claim): diese Wache unterscheidet nur die grobe Vendor-Aequivalenzklasse (AMD/Intel).
// Die feine Identitaet + der Cache-Log loesen die Lane-Form spaeter ab (Lanes = Interim, Ledger 62).
//
// Header-only, testbar: die reine Entscheidung (check_lane_vendor) ist von der CPUID-Detektion
// getrennt, damit ein Unit-Test Match/Mismatch/Skip ohne echte CPU-Abhaengigkeit prueft.

#include <cstring>
#include <string>
#include <string_view>

#if defined(__x86_64__) || defined(__i386__) || defined(_M_X64) || defined(_M_IX86)
#if defined(_MSC_VER)
#include <intrin.h>
#else
#include <cpuid.h>
#endif
#endif

namespace comdare::diplomarbeit::messung_driver {

/// Grobe CPU-Hersteller-Aequivalenzklasse aus dem Laufzeit-CPUID-Vendor-String (Leaf 0).
/// Rueckgabe: "amd" (AuthenticAMD) / "intel" (GenuineIntel) / "unknown" (fremder Vendor, non-x86
/// oder CPUID nicht verfuegbar). "unknown" => die Wache ueberspringt (Notausgang, nie Fehlalarm).
[[nodiscard]] inline std::string detect_cpu_vendor() {
#if defined(__x86_64__) || defined(__i386__) || defined(_M_X64) || defined(_M_IX86)
    unsigned int ebx = 0, ecx = 0, edx = 0;
#if defined(_MSC_VER)
    int regs[4] = {0, 0, 0, 0};
    __cpuid(regs, 0);
    ebx = static_cast<unsigned int>(regs[1]);
    ecx = static_cast<unsigned int>(regs[2]);
    edx = static_cast<unsigned int>(regs[3]);
#else
    unsigned int eax = 0;
    if (__get_cpuid(0U, &eax, &ebx, &ecx, &edx) == 0) return "unknown";
#endif
    char vendor[13] = {};
    std::memcpy(vendor + 0, &ebx, 4); // Vendor-String-Layout im CPUID-Leaf-0: EBX, EDX, ECX (12 Bytes)
    std::memcpy(vendor + 4, &edx, 4);
    std::memcpy(vendor + 8, &ecx, 4);
    std::string_view const v{vendor, 12};
    if (v == "AuthenticAMD") return "amd";
    if (v == "GenuineIntel") return "intel";
    return "unknown";
#else
    return "unknown";
#endif
}

/// Erwarteter Vendor aus der emittierten Lane-Form. Leer = kein Lane-Praefix (bare-metal/manuell).
[[nodiscard]] inline std::string lane_expected_vendor(std::string_view platform) {
    if (platform.rfind("amd@", 0) == 0) return "amd";
    if (platform.rfind("intel@", 0) == 0) return "intel";
    return {};
}

enum class LaneVendorCheck { kSkipped, kMatch, kMismatch };

/// Reine Entscheidung (ohne CPUID-Seiteneffekt, damit unit-testbar):
///  - kein amd@/intel@-Praefix          -> kSkipped (bare-metal / Notausgang)
///  - Vendor leer oder "unknown"        -> kSkipped (Detektion unmoeglich, nie Fehlalarm)
///  - Vendor == erwarteter Lane-Vendor  -> kMatch
///  - sonst                             -> kMismatch (Fehlrouting)
[[nodiscard]] inline LaneVendorCheck check_lane_vendor(std::string_view platform, std::string_view detected_vendor) {
    std::string const expected = lane_expected_vendor(platform);
    if (expected.empty()) return LaneVendorCheck::kSkipped;
    if (detected_vendor.empty() || detected_vendor == "unknown") return LaneVendorCheck::kSkipped;
    return detected_vendor == expected ? LaneVendorCheck::kMatch : LaneVendorCheck::kMismatch;
}

} // namespace comdare::diplomarbeit::messung_driver
