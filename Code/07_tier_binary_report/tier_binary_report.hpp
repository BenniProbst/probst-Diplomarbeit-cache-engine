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
// 2c/OP-8 (2026-07-27): die GEPLANTE Menge kommt aus der EINEN kanonischen
// Planer-Rohausgabe "comdare-messung-driver plan dump" (Format v1.1) -- exakt
// derselbe Text, den auch der CI-Job visibility:tier-binaries liest
// (EIN-FORMAT-REGEL, Ledger 73.1). Damit endet die permutations_manifest.txt-
// Aera (V-2/2a Treiber -> 2b CI-Job -> 2c dieses Werkzeug).
//
// Untouchables (nur gelesen): die plan-dump-Ausgabe (geplante Menge),
// perm/<subsystem>/perm_<id>.<ext> (gebaute Menge). golden_fullpilot_320,
// permutation_axes und die conformance_gate-Oracle werden NICHT beruehrt.

#pragma once

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
// Geplante Rekombinations-Menge (aus "comdare-messung-driver plan dump", v1.1)
// ─────────────────────────────────────────────────────────────────────────────
struct PlannedSet {
    // Kopf-Anker '# comdare-experiment-plan v1.1' gefunden? false = die Quelle ist KEINE
    // plan-dump-Ausgabe (fehlt/leer/Formatbruch); dann sind alle Zahlen unten bedeutungslos
    // und der Aufrufer muss das als Fehler behandeln statt ein falsches "0/0" zu melden.
    bool        format_ok{false};
    std::string profile;                 // profile_id= aus dem Plan-Kopf
    std::string source_kind;             // thesis | experiment -- erklaert eine leere id-Menge
    std::size_t perm_blocks{0};          // 'perm <i> ...'-Bloecke
    std::size_t steps{0};                // 'step <j> ...'-Zeilen (= STEPS-Zaehler des CI-Jobs)
    std::size_t steps_without_binary{0}; // davon mit binary_id=- (Thesis-Sweeps tragen NIE eine id)
    std::size_t ids_beyond_stem_cap{0};  // ids oberhalb detail::kCeStemMax (nicht zuordenbar)
    // Datei-Stem-Raum der geplanten Tier-Binaries, dedupliziert in Plan-Reihenfolge.
    // Dedupliziert, weil derselbe binary_id in JEDEM perm-Block wiederkehrt -- und weil die
    // gebaute Menge (scan_built) ueber die perm-Unterbaeume ebenfalls dedupliziert.
    std::vector<std::string> ids;
};

namespace detail {

[[nodiscard]] inline std::string trim(std::string_view sv) {
    std::size_t b = 0;
    std::size_t e = sv.size();
    while (b < e && (std::isspace(static_cast<unsigned char>(sv[b])) != 0)) ++b;
    while (e > b && (std::isspace(static_cast<unsigned char>(sv[e - 1])) != 0)) --e;
    return std::string{sv.substr(b, e - b)};
}

// Kanonische id der GEBAUTEN Menge: ein fuehrendes "perm_" wird entfernt, damit
// Datei-Stems ("perm_<stem>.<ext>") und die geplante Menge (plan_stem, s.u.) im
// SELBEN Id-Raum verglichen werden.
[[nodiscard]] inline std::string canonical_id(std::string s) {
    if (s.rfind("perm_", 0) == 0) return s.substr(5); // strlen("perm_")
    return s;
}

// Kopf-Anker der Planer-Emission. Die Version ist bewusst mitgepinnt: ein Formatwechsel
// muss hier UND im CI-Job visibility:tier-binaries nachgezogen werden (ein Format, eine
// Wahrheit) -- er darf nicht stillschweigend als "leerer Plan" durchgehen.
inline constexpr std::string_view kPlanAnchor = "# comdare-experiment-plan v1.1";

// Feldschluessel der Plan-Zeilen; die Werte sind whitespace-getrennte Token.
inline constexpr std::string_view kSourceKindKey = "source_kind=";
inline constexpr std::string_view kProfileIdKey  = "profile_id=";
inline constexpr std::string_view kBinaryIdKey   = "binary_id=";
inline constexpr std::string_view kPermPrefix    = "perm ";
inline constexpr std::string_view kStepPrefix    = "step ";
// Leerwert-Platzhalter der Emission (PlanTextBuilder::nz) -- kein Feld bleibt leer.
inline constexpr std::string_view kEmptyField = "-";

// Wert eines '<key>=<wert>'-Feldes einer Plan-Zeile. Getrennt wird NUR an Whitespace,
// denn der Wert selbst darf '=' enthalten (real: binary_id=sota_tier=sota::A::ArtComposition).
[[nodiscard]] inline std::string field_value(std::string const& line, std::string_view key) {
    std::istringstream is{line};
    std::string        tok;
    while (is >> tok) {
        if (tok.rfind(key, 0) == 0) return tok.substr(key.size());
    }
    return {};
}

// ce bildet aus dem binary_id den Datei-Stem "perm_<sanitisiert>" (build_orchestrator.hpp
// orch_sanitize/KF-8: jedes Nicht-alnum-Zeichen -> '_'). Die geplante Menge wird in DIESEN
// Raum abgebildet, sonst waere sie mit scan_built gar nicht vergleichbar.
[[nodiscard]] inline std::string plan_stem(std::string_view binary_id) {
    std::string out;
    out.reserve(binary_id.size());
    for (char c : binary_id) out += ((std::isalnum(static_cast<unsigned char>(c)) != 0) ? c : '_');
    return out;
}

// GRENZE der Zuordnung: oberhalb dieses Deckels kappt ce den Stem auf Praefix +
// '_<perm-index>_<fnv1a-hex>' (build_orchestrator.hpp kStemMax). Die Kappung wird hier
// BEWUSST NICHT nachgebaut -- sie braeuchte den ce-Hash UND den Perm-Index. Betroffene
// Binaries erscheinen als "offen" und werden im Report ausdruecklich benannt, statt still
// falsch zugeordnet zu werden.
inline constexpr std::size_t kCeStemMax = 120;

} // namespace detail

// Die plan-dump-Ausgabe (v1.1) lesen. Tragend ist -- wie im 2b-Handout festgelegt -- die
// Zeile "step <j> ... binary_id=<b> ...": sie traegt die GEPLANTE Menge, die frueher aus
// permutations_manifest.txt kam. Aus dem Kopf kommen profile_id und source_kind.
//
// Zwei Feinheiten, die den Report ehrlich halten:
//   * binary_id=- ist KEINE id, sondern der Leerwert-Platzhalter der Emission. THESIS-
//     Profile emittieren ihn durchgaengig (nur EXPERIMENT-Profile tragen echte ids), also
//     ist eine leere id-Menge dort der KORREKTE Befund -- gezaehlt in steps_without_binary,
//     damit "0 geplant" nicht wie ein Datenverlust aussieht.
//   * ids werden in den Datei-Stem-Raum abgebildet und dedupliziert (jeder binary_id kehrt
//     in JEDEM perm-Block wieder; die gebaute Menge dedupliziert genauso).
// Unbekannte Zeilen (registry_trio, resolver, measurement_combo, ...) werden ignoriert --
// additive Kopf-Felder duerfen dieses Werkzeug nicht brechen.
[[nodiscard]] inline PlannedSet parse_plan_dump(std::filesystem::path const& plan_dump) {
    PlannedSet    out;
    std::ifstream in{plan_dump};
    if (!in) return out; // fehlende Datei = format_ok bleibt false

    std::set<std::string> seen;
    std::string           raw;
    while (std::getline(in, raw)) {
        std::string const line = detail::trim(raw);
        if (line.empty()) continue;

        if (line.rfind(detail::kPlanAnchor, 0) == 0) {
            out.format_ok = true;
            continue;
        }
        if (line.front() == '#') continue;
        if (line.rfind(detail::kSourceKindKey, 0) == 0) {
            out.source_kind = line.substr(detail::kSourceKindKey.size());
            continue;
        }
        if (line.rfind(detail::kProfileIdKey, 0) == 0) {
            out.profile = line.substr(detail::kProfileIdKey.size());
            continue;
        }
        if (line.rfind(detail::kPermPrefix, 0) == 0) { // NICHT "perm_count=" (kein Leerzeichen)
            ++out.perm_blocks;
            continue;
        }
        if (line.rfind(detail::kStepPrefix, 0) != 0) continue;

        ++out.steps;
        std::string const binary_id = detail::field_value(line, detail::kBinaryIdKey);
        if (binary_id.empty() || binary_id == detail::kEmptyField) {
            ++out.steps_without_binary;
            continue;
        }
        std::string stem = detail::plan_stem(binary_id);
        if (!seen.insert(stem).second) continue; // schon aus einem frueheren perm-Block bekannt
        if (stem.size() > detail::kCeStemMax) ++out.ids_beyond_stem_cap;
        out.ids.push_back(std::move(stem));
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
    bool                     format_ok{false};     // Plan-Quelle war eine echte plan-dump-Ausgabe
    std::string              profile;
    std::string              source_kind;
    std::size_t              perm_blocks{0};
    std::size_t              steps{0};
    std::size_t              steps_without_binary{0};
    std::size_t              ids_beyond_stem_cap{0};
    std::size_t              planned{0};
    std::size_t              built{0};
    std::size_t              open{0};
    std::vector<std::string> open_ids; // geplante, aber noch nicht gebaute (Planungs-Reihenfolge)
};

[[nodiscard]] inline VisibilityReport compute_visibility(PlannedSet const& planned, BuiltSet const& built,
                                                         bool builder_built) {
    VisibilityReport r;
    r.builder_built        = builder_built;
    r.format_ok            = planned.format_ok;
    r.profile              = planned.profile;
    r.source_kind          = planned.source_kind;
    r.perm_blocks          = planned.perm_blocks;
    r.steps                = planned.steps;
    r.steps_without_binary = planned.steps_without_binary;
    r.ids_beyond_stem_cap  = planned.ids_beyond_stem_cap;

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
    if (!r.format_ok) {
        // Kein Anker = keine Plan-Ausgabe. Das MUSS als Fehler stehen bleiben, sonst liest
        // sich eine fehlende/kaputte Quelle wie ein leerer, aber gueltiger Plan.
        os << "PLAN-QUELLE UNGUELTIG: Kopf-Anker \"" << detail::kPlanAnchor
           << "\" fehlt (keine plan-dump-Ausgabe v1.1)\n";
        return os.str();
    }
    std::string const profile = r.profile.empty() ? "unbekannt" : r.profile;
    os << "Plan-Quelle: plan dump v1.1 (Profil " << profile << ", source_kind "
       << (r.source_kind.empty() ? "unbekannt" : r.source_kind) << ")\n";
    os << "Plan-Umfang: " << r.perm_blocks << " perm-Block(e), " << r.steps << " step-Zeile(n), davon "
       << r.steps_without_binary << " ohne binary_id\n";
    os << "CacheEngineBuilder: " << (r.builder_built ? "gebaut" : "fehlt") << "\n";
    os << "Tier-Binaries: " << r.built << "/" << r.planned << " gebaut, " << r.open << " offen (Profil " << profile
       << ")\n";
    if (r.ids_beyond_stem_cap > 0) {
        os << "HINWEIS: " << r.ids_beyond_stem_cap << " geplante id(s) ueberschreiten den ce-Stem-Deckel ("
           << detail::kCeStemMax << ") -- ihr Datei-Stem traegt Index+Hash und wird hier nicht zugeordnet\n";
    }
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
