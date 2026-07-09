// SPDX-License-Identifier: Apache-2.0
// tier_binary_report.hpp (#279-a, 2026-07-07)
//
// Nachgelagerte Ueberwachungs-Stufe der Mess-Pipeline: macht die dynamische
// Build-Sichtbarkeit der Tier-Binary-Rekombinationen (CacheEngineBuilder +
// permutations) sichtbar und rostert je Tier-Binary den generischen
// Interface-Vertrag (PASS/FAIL). Reine std-Logik, KEIN dlopen und KEIN
// windows.h/dlfcn -> der Unit-Test linkt diesen Header ohne Plattform-Deps.
// Der eigentliche Plugin-Load (dlopen) fuer --interface-check liegt in der CLI
// (main.cpp), die den bestehenden Loader Code/02_messung_driver/plugin_loader.hpp
// wiederverwendet (keine Duplikation).
//
// Untouchables (nur gelesen): permutations_manifest.txt (geplante Menge),
// perm/<subsystem>/perm_<id>.<ext> (gebaute Menge). golden_fullpilot_320,
// permutation_axes und die conformance_gate-Oracle werden NICHT beruehrt.

#pragma once

#include <algorithm>
#include <cctype>
#include <cstddef>
#include <filesystem>
#include <fstream>
#include <set>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::tier_binary_report {

// ─────────────────────────────────────────────────────────────────────────────
// Geplante Rekombinations-Menge (aus permutations_manifest.txt)
// ─────────────────────────────────────────────────────────────────────────────
struct PlannedSet {
    std::string              profile; // z.B. "smoke" | "medium" | "full" (falls im Manifest annotiert)
    std::vector<std::string> ids;     // eine perm-id je Eintrag, Manifest-Reihenfolge erhalten
};

namespace detail {

[[nodiscard]] inline std::string trim(std::string_view sv) {
    std::size_t b = 0;
    std::size_t e = sv.size();
    while (b < e && (std::isspace(static_cast<unsigned char>(sv[b])) != 0)) ++b;
    while (e > b && (std::isspace(static_cast<unsigned char>(sv[e - 1])) != 0)) --e;
    return std::string{sv.substr(b, e - b)};
}

// Erstes whitespace-getrenntes Token einer bereits getrimmten Zeile.
[[nodiscard]] inline std::string first_token(std::string const& line) {
    std::size_t e = 0;
    while (e < line.size() && (std::isspace(static_cast<unsigned char>(line[e])) == 0)) ++e;
    return line.substr(0, e);
}

// Kanonische perm-id: ein fuehrendes "perm_" wird entfernt, damit die geplante
// Menge (Manifest listet real "perm_<id>") und die gebaute Menge (Dateien
// "perm_<id>.<ext>") im SELBEN Id-Raum verglichen werden. Fixtures ohne Praefix
// bleiben unveraendert.
[[nodiscard]] inline std::string canonical_id(std::string s) {
    if (s.rfind("perm_", 0) == 0) return s.substr(5); // strlen("perm_")
    return s;
}

[[nodiscard]] inline std::string to_lower(std::string s) {
    std::transform(s.begin(), s.end(), s.begin(), [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
    return s;
}

// Prueft, ob ein (bereits vom fuehrenden '#' befreiter) Zeilenrest MIT "profile="
// BEGINNT (case-insensitive); nur dann ist es eine Profil-Deklaration. Prosa-
// Kommentare, die "profile=" irgendwo mittendrin enthalten, sind KEINE Deklaration.
// Bei Treffer wird das erste Token nach "profile=" in out geschrieben (true).
[[nodiscard]] inline bool try_extract_profile(std::string const& content, std::string& out) {
    static constexpr std::string_view kKey = "profile=";
    if (to_lower(content).rfind(kKey, 0) != 0) return false;
    out = first_token(trim(content.substr(kKey.size())));
    return !out.empty();
}

} // namespace detail

// permutations_manifest.txt lesen: Leerzeilen ueberspringen; das Profil kommt
// entweder als Nicht-Kommentar-Zeile "profile=NAME" (Fixture) ODER im
// Kommentar-Header "# Profile=NAME ISA=... Mode=..." (reales ce-Codegen-Manifest).
// Als Profil-Deklaration gilt NUR eine Zeile, deren Inhalt MIT "profile=" beginnt
// (case-insensitive) — Prosa-Kommentare mit "profile=" mittendrin zaehlen NICHT.
// Jede sonstige Nicht-Kommentar-Zeile: erstes Token = perm-id.
[[nodiscard]] inline PlannedSet parse_manifest(std::filesystem::path const& manifest) {
    PlannedSet    out;
    std::ifstream in{manifest};
    if (!in) return out;

    std::string raw;
    while (std::getline(in, raw)) {
        std::string const line = detail::trim(raw);
        if (line.empty()) continue;

        bool const        is_comment = (line.front() == '#');
        std::string const content    = is_comment ? detail::trim(line.substr(1)) : line;

        // Profil aus beiden Formen ableiten (erstes Vorkommen gewinnt).
        if (out.profile.empty()) {
            std::string prof;
            if (detail::try_extract_profile(content, prof)) {
                out.profile = prof;
                continue; // eine profile=-Deklarationszeile ist keine perm-id
            }
        }
        if (is_comment) continue;

        std::string const id = detail::first_token(content);
        if (!id.empty()) out.ids.push_back(detail::canonical_id(id));
    }
    return out;
}

// ─────────────────────────────────────────────────────────────────────────────
// Gebaute Rekombinations-Menge (Dateiscan, KEIN dlopen)
// ─────────────────────────────────────────────────────────────────────────────
struct BuiltSet {
    std::vector<std::string> ids; // perm-ids gebauter perm_<id>.<ext>-Libs (dedupliziert)
};

// Scannt perm_root/cache_engine + perm_root/prt_art rekursiv nach
// perm_*.{so,dll,dylib}; id = Dateistamm ohne fuehrendes "perm_".
[[nodiscard]] inline BuiltSet scan_built(std::filesystem::path const& perm_root) {
    namespace fs = std::filesystem;
    BuiltSet              out;
    std::set<std::string> seen;

    for (char const* sub : {"cache_engine", "prt_art"}) {
        fs::path const  root = perm_root / sub;
        std::error_code ec;
        if (!fs::exists(root, ec)) continue;
        for (fs::recursive_directory_iterator it{root, ec}, end; it != end; it.increment(ec)) {
            if (ec) break;
            if (!it->is_regular_file(ec)) continue;
            fs::path const&   p   = it->path();
            std::string const ext = p.extension().string();
            if (ext != ".so" && ext != ".dll" && ext != ".dylib") continue;
            std::string const stem = p.stem().string();
            if (stem.rfind("perm_", 0) != 0) continue;
            std::string id = detail::canonical_id(stem);
            if (id.empty()) continue;
            if (seen.insert(id).second) out.ids.push_back(std::move(id));
        }
    }
    return out;
}

// ─────────────────────────────────────────────────────────────────────────────
// Sichtbarkeits-Report (#279(3))
// ─────────────────────────────────────────────────────────────────────────────
struct VisibilityReport {
    bool                     builder_built{false}; // CacheEngineBuilder-Orchestrator gebaut?
    std::string              profile;
    std::size_t              planned{0};
    std::size_t              built{0};
    std::size_t              open{0};
    std::vector<std::string> open_ids; // geplante, aber noch nicht gebaute (Planungs-Reihenfolge)
};

[[nodiscard]] inline VisibilityReport compute_visibility(PlannedSet const& planned, BuiltSet const& built,
                                                         bool builder_built) {
    VisibilityReport r;
    r.builder_built = builder_built;
    r.profile       = planned.profile;

    std::set<std::string> const built_set(built.ids.begin(), built.ids.end());
    r.planned = planned.ids.size();
    for (auto const& id : planned.ids) {
        if (built_set.count(id) != 0) {
            ++r.built;
        } else {
            r.open_ids.push_back(id);
        }
    }
    r.open = r.open_ids.size();
    return r;
}

[[nodiscard]] inline std::string format_visibility(VisibilityReport const& r) {
    std::ostringstream os;
    os << "== Tier-Binary-Build-Sichtbarkeit (#279) ==\n";
    os << "CacheEngineBuilder: " << (r.builder_built ? "gebaut" : "fehlt") << "\n";
    std::string const profile = r.profile.empty() ? "unbekannt" : r.profile;
    os << "Tier-Binaries: " << r.built << "/" << r.planned << " gebaut, " << r.open << " offen (Profil " << profile
       << ")\n";
    if (!r.open_ids.empty()) {
        os << "Noch offen:\n";
        for (auto const& id : r.open_ids) os << "  - " << id << "\n";
    }
    return os.str();
}

// ─────────────────────────────────────────────────────────────────────────────
// Interface-Roster (#279(4)) — je Tier-Binary der generische Vertrag PASS/FAIL.
// Die InterfaceCheck-Eintraege erzeugt die CLI ueber den dlopen-Loader; dieser
// Header stellt nur das Datenmodell + die deterministische Formatierung.
// ─────────────────────────────────────────────────────────────────────────────
struct InterfaceCheck {
    std::string id;
    bool        loaded{false};        // Plugin ueberhaupt ladbar (dlopen/LoadLibrary)
    bool        descriptor_ok{false}; // comdare_perm_descriptor() liefert non-null
    bool        run_ok{false};        // desc->run(n, &out) == 0

    [[nodiscard]] bool passed() const noexcept { return loaded && descriptor_ok && run_ok; }
};

[[nodiscard]] inline std::string format_interface_roster(std::vector<InterfaceCheck> const& roster) {
    std::ostringstream os;
    os << "== Tier-Binary-Interface-Roster (#279) ==\n";
    if (roster.empty()) {
        os << "0 Tier-Binaries gebaut - nichts zu pruefen\n";
        os << "Interface-Roster: 0/0 PASS\n";
        return os.str();
    }
    std::size_t npass = 0;
    for (auto const& c : roster) {
        if (c.passed()) {
            ++npass;
            os << "[PASS] " << c.id << "\n";
        } else {
            os << "[FAIL] " << c.id << " (loaded=" << (c.loaded ? 1 : 0) << " descriptor=" << (c.descriptor_ok ? 1 : 0)
               << " run=" << (c.run_ok ? 1 : 0) << ")\n";
        }
    }
    os << "Interface-Roster: " << npass << "/" << roster.size() << " PASS\n";
    return os.str();
}

} // namespace comdare::tier_binary_report
