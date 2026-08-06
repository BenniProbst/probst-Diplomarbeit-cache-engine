// SPDX-License-Identifier: Apache-2.0
#include "appendix_generator.hpp"

#include "csv_to_latex.hpp"
#include "diagram_generator.hpp"

#include <algorithm>
#include <fstream>
#include <iostream>
#include <iterator>
#include <system_error>

namespace comdare::da::appendix_generator {

namespace c2l = comdare::da::csv_to_latex;
namespace dg  = comdare::da::diagram_generator;

namespace {

// ── Minimaler, hermetischer XML-Attribut-Scanner ──────────────────────────────
// Die drei Registry-XML sind GENERIERT (compile-time-Reflektion) und tragen eine
// feste, attribut-getriebene Gestalt. Statt einer Fremdbibliothek liest dieser
// Scanner Tag-Namen und Attribute und ueberspringt Kommentare/Deklarationen. Er
// rekonstruiert bewusst KEINEN Baum: die Eltern-Bezuege stehen als Attribute in
// den Dateien selbst (parent=...), sind also nicht aus der Verschachtelung zu raten.
struct XmlTag {
    std::string                                      name;
    std::vector<std::pair<std::string, std::string>> attrs;
};

[[nodiscard]] bool is_name_char(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' || c == '-' ||
           c == ':';
}

[[nodiscard]] std::string attr_of(XmlTag const& t, std::string_view key) {
    auto const it = std::find_if(t.attrs.begin(), t.attrs.end(), [key](auto const& kv) { return kv.first == key; });
    return it == t.attrs.end() ? std::string{} : it->second;
}

// Zerlegt den gesamten Text in die Folge der OEFFNENDEN (bzw. leeren) Tags.
// Schliessende Tags, Kommentare, Prolog und Doctype werden uebersprungen.
[[nodiscard]] std::vector<XmlTag> scan_xml_tags(std::string const& text) {
    std::vector<XmlTag> tags;
    std::size_t         i = 0;
    while (i < text.size()) {
        auto const lt = text.find('<', i);
        if (lt == std::string::npos) break;
        i = lt + 1;
        if (i >= text.size()) break;
        if (text.compare(i, 3, "!--") == 0) { // Kommentar: bis "-->" ueberspringen
            auto const end = text.find("-->", i + 3);
            i              = (end == std::string::npos) ? text.size() : end + 3;
            continue;
        }
        if (text[i] == '/' || text[i] == '?' || text[i] == '!') { // schliessend / Prolog / Doctype
            auto const end = text.find('>', i);
            i              = (end == std::string::npos) ? text.size() : end + 1;
            continue;
        }
        XmlTag tag;
        while (i < text.size() && is_name_char(text[i])) tag.name += text[i++];
        if (tag.name.empty()) continue;
        // Attribute bis '>' bzw. '/>'.
        while (i < text.size() && text[i] != '>') {
            if (static_cast<unsigned char>(text[i]) <= ' ' || text[i] == '/') {
                ++i;
                continue;
            }
            std::string key;
            while (i < text.size() && is_name_char(text[i])) key += text[i++];
            if (key.empty()) { // unerwartetes Zeichen: nicht raten, weiterschieben
                ++i;
                continue;
            }
            while (i < text.size() && static_cast<unsigned char>(text[i]) <= ' ') ++i;
            if (i >= text.size() || text[i] != '=') continue; // Attribut ohne Wert: ignorieren
            ++i;
            while (i < text.size() && static_cast<unsigned char>(text[i]) <= ' ') ++i;
            if (i >= text.size() || (text[i] != '"' && text[i] != '\'')) continue;
            char const  quote = text[i++];
            std::string value;
            while (i < text.size() && text[i] != quote) value += text[i++];
            if (i < text.size()) ++i; // schliessendes Anfuehrungszeichen
            tag.attrs.emplace_back(std::move(key), std::move(value));
        }
        if (i < text.size()) ++i; // '>'
        tags.push_back(std::move(tag));
    }
    return tags;
}

[[nodiscard]] RegistrySubAxis sub_axis_from(XmlTag const& t, bool is_group) {
    RegistrySubAxis s;
    s.id            = attr_of(t, "id");
    s.parent        = attr_of(t, "parent");
    s.stage         = attr_of(t, "stage");
    s.value_type    = attr_of(t, "value_type");
    s.option_source = attr_of(t, "option_source");
    s.is_group      = is_group;
    return s;
}

// LaTeX-Maskierung der Registry-Bezeichner. Sie bestehen aus [a-z0-9_]; der
// Unterstrich ist das einzige Sonderzeichen, das real vorkommt — er wird mit einem
// Umbruchpunkt versehen, damit lange Kennungen die Tabellenspalte nicht sprengen.
[[nodiscard]] std::string tex_id(std::string_view s) {
    std::string out;
    out.reserve(s.size() + 16);
    for (char const c : s) {
        switch (c) {
            case '_': out += "\\_\\allowbreak{}"; break;
            case '&': out += "\\&"; break;
            case '%': out += "\\%"; break;
            case '#': out += "\\#"; break;
            case '$': out += "\\$"; break;
            case '{': out += "\\{"; break;
            case '}': out += "\\}"; break;
            case '\\': out += "\\textbackslash{}"; break;
            default: out += c; break;
        }
    }
    return out;
}

[[nodiscard]] std::string realm_label(AxisRealm r, bool de) {
    switch (r) {
        case AxisRealm::organ: return de ? "Organ" : "organ";
        case AxisRealm::system: return de ? "System" : "system";
        case AxisRealm::measurement: return de ? "Messen" : "measurement";
    }
    return de ? "unbekannt" : "unknown";
}

} // namespace

int parse_axis_registry(std::filesystem::path const& xml, AxisRealm realm, AxisRegistry& out) {
    out       = AxisRegistry{};
    out.realm = realm;
    if (xml.empty()) return status_io_error;
    std::ifstream in(xml, std::ios::binary);
    if (!in) return status_io_error;
    std::string const text((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
    if (text.empty()) return status_parse_error;

    bool in_dynamic_dims = false;
    for (auto const& tag : scan_xml_tags(text)) {
        if (tag.name == "axis" || tag.name == "system_complex_axis") {
            RegistryAxis a;
            a.realm              = realm;
            a.id                 = attr_of(tag, "id");
            a.slot               = attr_of(tag, "slot");
            a.category           = attr_of(tag, "category");
            a.stage              = attr_of(tag, "stage");
            a.binary_id          = attr_of(tag, "binary_id");
            a.is_complex_bracket = (tag.name == "system_complex_axis");
            if (auto const bc = attr_of(tag, "baustein_count"); !bc.empty()) {
                a.baustein_count     = static_cast<std::size_t>(std::stoul(bc));
                a.has_baustein_count = true;
            }
            if (a.id.empty()) return status_parse_error; // generierte Registry ohne id => kaputt
            out.axes.push_back(std::move(a));
            in_dynamic_dims = false;
        } else if (tag.name == "sub_axis" || tag.name == "sub_axis_group") {
            if (out.axes.empty()) return status_parse_error; // Unter-Achse ohne Achse
            out.axes.back().sub_axes.push_back(sub_axis_from(tag, tag.name == "sub_axis_group"));
        } else if (tag.name == "dynamic_dims") {
            in_dynamic_dims = true;
        } else if (tag.name == "dim" && in_dynamic_dims) {
            RegistrySubAxis d;
            d.id         = attr_of(tag, "id");
            d.parent     = attr_of(tag, "source");
            d.stage      = attr_of(tag, "stage");
            d.value_type = attr_of(tag, "value_type");
            out.dynamic_dims.push_back(std::move(d));
        }
    }
    return out.axes.empty() ? status_parse_error : status_ok;
}

int write_axis_inventory_table(std::filesystem::path const& out, std::span<AxisRegistry const> registries,
                               std::string const& lang) {
    std::size_t axis_total = 0;
    for (auto const& r : registries) axis_total += r.axes.size();
    if (axis_total == 0) return status_empty_input; // honest-empty: KEINE Datei, kein Phantom

    std::ofstream f{out};
    if (!f) return status_io_error;
    bool const de = (lang == "de");

    f << "% AUTO-GENERATED durch appendix_generator::write_axis_inventory_table (lang=" << lang << ")\n";
    f << "% Quelle: die drei GENERIERTEN Achsen-Registries des Codes (Organ/System/Messen).\n";
    f << "% Keine handgepflegte Achsen-Liste: die Registries entstehen per compile-time-Reflektion.\n";

    std::string const cap     = de ? "Achsen-Inventar aus den drei generierten Registries "
                                     "(Organ-, System- und Mess-Realm)"
                                   : "Axis inventory from the three generated registries "
                                     "(organ, system and measurement realm)";
    std::string const colhead = de ? "Realm \\& Slot & Achse & Stufe / \\texttt{binary\\_id} & Bausteine & "
                                     "Unter-Achsen \\\\"
                                   : "Realm \\& slot & Axis & Stage / \\texttt{binary\\_id} & Blocks & Sub-axes \\\\";

    f << "\\begin{scriptsize}\n";
    f << "\\begin{longtable}{@{}>{\\raggedright\\arraybackslash}p{1.8cm} >{\\raggedright\\arraybackslash}p{3.0cm} "
      << ">{\\raggedright\\arraybackslash}p{2.6cm} r >{\\raggedright\\arraybackslash}p{5.0cm}@{}}\n";
    f << "\\caption{" << cap << "}\\label{tab:axis-inventory}\\\\\n";
    f << "\\toprule\n" << colhead << "\n\\midrule\n\\endfirsthead\n";
    f << "\\multicolumn{5}{c}{\\tablename\\ \\thetable{} -- " << (de ? "Fortsetzung" : "continued")
      << "}\\\\\n\\toprule\n"
      << colhead << "\n\\midrule\n\\endhead\n";
    f << "\\midrule\n\\multicolumn{5}{r}{" << (de ? "Fortsetzung n\\\"achste Seite" : "continued on next page")
      << "}\\\\\n\\endfoot\n\\bottomrule\n\\endlastfoot\n";

    for (auto const& reg : registries) {
        for (auto const& a : reg.axes) {
            f << realm_label(a.realm, de);
            if (!a.slot.empty()) f << " " << tex_id(a.slot);
            f << " & \\texttt{" << tex_id(a.id) << "}";
            if (a.is_complex_bracket) f << " " << (de ? "(Klammer)" : "(bracket)");
            f << " & ";
            if (!a.stage.empty()) f << "\\texttt{" << tex_id(a.stage) << "}";
            if (!a.stage.empty() && !a.binary_id.empty()) f << " / ";
            if (!a.binary_id.empty()) f << "\\texttt{" << tex_id(a.binary_id) << "}";
            f << " & ";
            if (a.has_baustein_count)
                f << a.baustein_count;
            else
                f << "--";
            f << " & ";
            bool first = true;
            for (auto const& s : a.sub_axes) {
                if (s.id.empty()) continue;
                if (!first) f << ", ";
                first = false;
                f << "\\texttt{" << tex_id(s.id) << "}";
                if (s.is_group) f << (de ? " (Gruppe)" : " (group)");
            }
            if (first) f << "--";
            f << " \\\\\n";
        }
    }
    f << "\\end{longtable}\n\\end{scriptsize}\n";

    // Sweep-Dimensionen des Mess-Realms als Legende UNTER dem Float (Legende-unter-Float-Regel).
    std::vector<std::string> dims;
    for (auto const& reg : registries)
        for (auto const& d : reg.dynamic_dims)
            if (!d.id.empty()) dims.push_back(d.id);
    if (!dims.empty()) {
        f << "\n\\emph{" << (de ? "Sweep-Dimensionen des Mess-Realms" : "Sweep dimensions of the measurement realm")
          << ":} ";
        for (std::size_t i = 0; i < dims.size(); ++i) {
            if (i) f << ", ";
            f << "\\texttt{" << tex_id(dims[i]) << "}";
        }
        f << ".\n";
    }
    return status_ok;
}

std::string default_bias_caption(std::string const& lang) {
    // Wortgleich zu generate_wide_appendix.ps1:61-64 (die Caption wird ROH übergeben;
    // write_bias_matrix_latex escaped selbst → hier KEIN Doppel-Escape).
    if (lang == "de") return "Bias-Bruch-Matrix (Median ns/op, Suchverfahren x Lastprofil)";
    return "Bias-break matrix (median ns/op, search method x load profile)";
}

int generate_wide_appendix(AppendixConfig const& cfg) {
    // ── Parse EINMAL: drei row-Typen, je genau einmal, über alle Sprachen wiederverwendet ──
    // (Der exe-Spawn-Weg parste je Sprache × Sub-Kommando neu; in-process fällt das weg.)

    // (1) Bias — WIDE (tier×workload): parse_wide_csv → aggregate_tier_workload (lang-unabhängig).
    std::vector<c2l::WideMeasurementRow> bias_rows;
    if (int const rc = c2l::parse_wide_csv(cfg.csv, bias_rows); rc != c2l::status_ok) {
        std::cerr << "appendix-generator: parse_wide_csv (bias) failed " << rc << "\n";
        return status_parse_error;
    }
    auto const bias_aggs = c2l::aggregate_tier_workload(bias_rows);

    // (2) Surface — WIDE + op_*_p50 (05er Parser/Row-Typ): dg::parse_wide_csv.
    std::vector<dg::WideMeasurementRow> surf_rows;
    if (int const rc = dg::parse_wide_csv(cfg.csv, surf_rows); rc != dg::status_ok) {
        std::cerr << "appendix-generator: dg::parse_wide_csv (surface) failed " << rc << "\n";
        return status_parse_error;
    }

    // (3) Exchange — volle 17-Achsen-Tupel (M-4: CE kV3AxisCount): parse_wide_csv_full → aggregate_exchange (lang-unabhängig).
    std::vector<c2l::WideFullRow> full_rows;
    if (int const rc = c2l::parse_wide_csv_full(cfg.csv, full_rows); rc != c2l::status_ok) {
        std::cerr << "appendix-generator: parse_wide_csv_full (exchange) failed " << rc << "\n";
        return status_parse_error;
    }
    std::vector<c2l::SiblingPairCount> exch_counts;
    auto const                         exch_aggs = c2l::aggregate_exchange(full_rows, exch_counts);

    // (4) ADDITIV (2026-08-03): das VOLLE Achsen-Inventar aus den drei generierten Registries.
    // EINMAL geparst und ueber alle Sprachen wiederverwendet (dieselbe Disziplin wie oben).
    // Ein NICHT gesetzter Pfad wird still ausgelassen; eine gesetzte, aber unlesbare oder
    // kaputte Datei ist ein ECHTER Parse-Fehler (kein stilles Degradieren auf 4 Achsen —
    // genau dieses stille Degradieren war die Achsen-Luecke).
    std::vector<AxisRegistry> registries;
    {
        auto const load = [&registries](std::filesystem::path const& p, AxisRealm realm) -> int {
            if (p.empty()) return status_ok; // nicht angefordert
            AxisRegistry reg;
            if (int const rc = parse_axis_registry(p, realm, reg); rc != status_ok) return rc;
            registries.push_back(std::move(reg));
            return status_ok;
        };
        if (int const rc = load(cfg.organ_axis_registry, AxisRealm::organ); rc != status_ok) {
            std::cerr << "appendix-generator: parse_axis_registry (organ) failed " << rc << "\n";
            return status_parse_error;
        }
        if (int const rc = load(cfg.system_axis_registry, AxisRealm::system); rc != status_ok) {
            std::cerr << "appendix-generator: parse_axis_registry (system) failed " << rc << "\n";
            return status_parse_error;
        }
        if (int const rc = load(cfg.measurement_axis_registry, AxisRealm::measurement); rc != status_ok) {
            std::cerr << "appendix-generator: parse_axis_registry (measurement) failed " << rc << "\n";
            return status_parse_error;
        }
    }

    // ── Je Sprache: 12 .tex nach <out_root>/<lang>/tabellen/ (bias 1 + surface 6 + exchange 4 + limitierung 1) ──
    for (auto const& lang : cfg.langs) {
        std::filesystem::path const out_dir = cfg.out_root / lang / "tabellen";
        std::error_code             ec;
        std::filesystem::create_directories(out_dir, ec);
        if (ec) {
            std::cerr << "appendix-generator: create_directories(" << out_dir << ") failed: " << ec.message() << "\n";
            return status_io_error;
        }

        // (1) Bias-Bruch-Matrix (WIDE) — bias_matrix_table.tex.
        auto const        it      = cfg.bias_caption_by_lang.find(lang);
        std::string const caption = (it != cfg.bias_caption_by_lang.end()) ? it->second : default_bias_caption(lang);
        if (int const rc = c2l::write_bias_matrix_latex(out_dir / "bias_matrix_table.tex", bias_aggs, caption,
                                                        cfg.bias_label, lang);
            rc != c2l::status_ok) {
            std::cerr << "appendix-generator: write_bias_matrix_latex (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (2) 6× lc_surface_<z> (Heatmap je Interface-Funktion; Default-PageConstraints wie das .ps1).
        for (auto const z_sv : kSurfaceFields) {
            std::string const z{z_sv};
            if (int const rc = dg::write_surface_search_algo_x_workload(out_dir / ("lc_surface_" + z + ".tex"),
                                                                        surf_rows, z, lang);
                rc != dg::status_ok) {
                std::cerr << "appendix-generator: write_surface (" << z << "," << lang << ") failed " << rc << "\n";
                return status_io_error;
            }
        }

        // (3) 4× ld_exchange_<achse> (Writer benennt ld_exchange_*.tex selbst je variabler Achse).
        if (int const rc = c2l::write_exchange_longtables(out_dir, exch_aggs, exch_counts, lang);
            rc != c2l::status_ok) {
            std::cerr << "appendix-generator: write_exchange_longtables (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (4) le_limitierung (statisch, keine CSV). In-Process gibt es KEINE Stale-Binary-Gefahr →
        //     der .ps1-Schutz (temp-Datei + Vorbehalts-Zeilen-Zählung) entfällt ersatzlos: der Writer
        //     ist immer die frisch gelinkte Lib, kann also nie eine ältere/kürzere Tabelle emittieren.
        if (int const rc = c2l::write_limitations_longtable(out_dir / "le_limitierung.tex", lang);
            rc != c2l::status_ok) {
            std::cerr << "appendix-generator: write_limitations_longtable (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // ── (5) ADDITIV (Inc-2a): 4 neue Darstellungs-Writer aus den BEREITS geparsten Rows/Aggregaten ──
        // KEIN Doppel-Parsen: die 3 05er-Writer speisen sich aus surf_rows (dg::WideMeasurementRow trägt nach
        // P4/P3 die seg_*_ns + op_*_p99_ns), der Forest-Plot aus DENSELBEN exch_aggs/exch_counts wie die Longtables.
        // HONEST-EMPTY-SEMANTIK: liefert ein Writer status_empty_input (dg=11 / c2l=12) — z.B. seg n/a (Nicht-Mess-
        // DLL), keine op_*_p99-Spalten, oder keine gültige Austausch-Zeile — legt der Writer bewusst KEINE Datei an.
        // Das ist KEIN Fehler der Gesamt-Facade (die 12 Kern-.tex sind bereits vollständig geschrieben); nur ein
        // echter status_io_error wird als status_io_error propagiert.
        auto const dg_ok  = [](int rc) { return rc == dg::status_ok || rc == dg::status_empty_input; };
        auto const c2l_ok = [](int rc) { return rc == c2l::status_ok || rc == c2l::status_empty_input; };

        // (5a) Segment-Attribution (gestapelte Balken) — surf_rows (dg::WideMeasurementRow, trägt seg_*_ns).
        if (int const rc = dg::write_segment_attribution_stacked_bar(out_dir / "seg_attribution.tex", surf_rows, lang);
            !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_segment_attribution_stacked_bar (" << lang << ") failed " << rc
                      << "\n";
            return status_io_error;
        }

        // (5b) Latenz-Range (Punkt=p50, Whisker→p99) — surf_rows (trägt op_*_p99_ns).
        if (int const rc = dg::write_latency_range_bar(out_dir / "latency_range.tex", surf_rows, lang); !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_latency_range_bar (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (5c) Latenz-ECDF (Config-Streuung über die Permutationen) — surf_rows.
        if (int const rc = dg::write_latency_ecdf(out_dir / "latency_ecdf.tex", surf_rows, lang); !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_latency_ecdf (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (5d) Forest-Plot der Achsen-Austauschbarkeit — DIESELBEN exch_aggs/exch_counts (ns/op-Headline).
        if (int const rc =
                c2l::write_exchange_forest_plot(out_dir / "exchange_forest.tex", exch_aggs, exch_counts, lang);
            !c2l_ok(rc)) {
            std::cerr << "appendix-generator: write_exchange_forest_plot (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (5e) INC-4 (xml→pdf-Konsolidierung): Per-Achsen-Observer-Detail-Tabelle (stat_<achse>_<feld> aus
        // kV3AxisSchema[17][8] (M-4: 17 = kV3AxisCount, ABI-6/INC-2d), single-source). Speist sich aus DENSELBEN
        // geparsten full_rows (c2l::WideFullRow
        // trägt seit INC-4 den durchgereichten stat_-Block) — KEIN Doppel-Parsen. HONEST-EMPTY (dg_ok): fehlt der
        // stat_-Block bzw. sind alle Zähler "n/a" (Nicht-Mess-DLL/altes Schema), liefert der Writer
        // status_empty_input → KEINE observer_detail.tex, KEIN Facade-Fehler. Thesis-\input erst INC-7 (Overleaf).
        if (int const rc = dg::write_axis_observer_detail_table(out_dir / "observer_detail.tex", full_rows, lang);
            !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_axis_observer_detail_table (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // (5f) ADDITIV (2026-08-03): Achsen-Inventar aus den DENSELBEN geparsten Registries.
        // HONEST-EMPTY: keine Registry angefordert ⇒ status_empty_input ⇒ KEINE Datei, kein Fehler.
        if (int const rc = write_axis_inventory_table(out_dir / "axis_inventory.tex", registries, lang);
            rc != status_ok && rc != status_empty_input) {
            std::cerr << "appendix-generator: write_axis_inventory_table (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        // -- (5g) GRAPH-UMBAU 2D/3D, P1a (2026-08-06): die echte 3D-Flaeche je z-Feld ---------------------
        // Die Funktion war seit L-c gebaut und honest-empty-hart (E-2b), aber NIRGENDS verdrahtet -- im
        // Anhang stand je Metrik ausschliesslich die 2D-Heatmap. Owner-KERN E-2 verlangt 2D UND 3D.
        // ROLLEN-SCHNITT: lc_surface_<z> (2D) und lc_surface3d_<z> (3D) sind beide Rohdaten-/QA-Ansichten
        // derselben (search_algo x workload)-Matrix -- zwei NOMINALE Achsen tragen keine Trendaussage.
        // KEIN Ersatz: die 6 lc_surface_<z> oben bleiben unveraendert (blankes \input in A_measurements).
        // dg_ok-Toleranz wie (5a)-(5e): ohne gueltige Achsen gibt es keine Datei, das ist kein Fehler.
        for (auto const z_sv : kSurfaceFields) {
            std::string const z{z_sv};
            if (int const rc = dg::write_surface3d_search_algo_x_workload(out_dir / ("lc_surface3d_" + z + ".tex"),
                                                                          surf_rows, z, lang);
                !dg_ok(rc)) {
                std::cerr << "appendix-generator: write_surface3d (" << z << "," << lang << ") failed " << rc << "\n";
                return status_io_error;
            }
        }

        // -- (5h) GRAPH-UMBAU 2D/3D, P1b (2026-08-06): Working-Set-Sweep-Kurve je z-Feld ------------------
        // Die klassische 2D-Paper-Form: Metrik ueber die Arbeitsmengen-Groesse, eine Kurve je gesweepter
        // Achsen-Auspraegung. Anders als die Flaeche traegt hier die x-Achse eine ECHTE Ordnung
        // (working_set_n), die Kurve zwischen den Stuetzstellen ist also lesbar. Ebenfalls seit A2 gebaut
        // und bis hier unverdrahtet. Auf cowfix-v1-Korpora ohne working_set_n-Spalte ist der Aufruf ein
        // reines No-Op (status_empty_input, keine Datei) -- deshalb ist das Wiring risikofrei.
        for (auto const z_sv : kSweepFields) {
            std::string const z{z_sv};
            if (int const rc =
                    dg::write_working_set_sweep_curve(out_dir / ("ld_sweep_" + z + ".tex"), surf_rows, z, lang);
                !dg_ok(rc)) {
                std::cerr << "appendix-generator: write_working_set_sweep_curve (" << z << "," << lang << ") failed "
                          << rc << "\n";
                return status_io_error;
            }
        }

        // -- (5i) GRAPH-UMBAU 2D/3D, P1c (2026-08-06): Forest-Plot gegen eine FESTE Referenz ------------
        // Der bestehende exchange_forest.tex vergleicht Geschwister-Paare UNTEREINANDER; welche
        // Auspraegung "der Massstab" ist, bleibt dort offen. Diese Variante dreht alle Paare EINER Achse
        // auf EINE Referenz-Auspraegung (Default search_algo/linear_scan) -- dieselbe Aggregation,
        // dieselbe Zeichen-Funktion, nur eine duenne Auswahl-/Umrechnungsschicht davor.
        // Die Referenz-Umrechnung ist exakt (nicht blosse Vorzeichen-Umkehr), siehe
        // select_exchange_vs_reference. KEINE std::map-Baseline: die gibt es im Korpus nicht.
        {
            auto const ref_aggs = c2l::select_exchange_vs_reference(exch_aggs, cfg.reference_axis,
                                                                     cfg.reference_value);
            if (int const rc = c2l::write_exchange_forest_plot(out_dir / "exchange_forest_vs_reference.tex", ref_aggs,
                                                               exch_counts, lang, /*body_only=*/false,
                                                               c2l::kExchangeForestSmallSampleThreshold,
                                                               cfg.reference_value);
                !c2l_ok(rc)) {
                std::cerr << "appendix-generator: write_exchange_forest_plot (vs-reference," << lang << ") failed "
                          << rc << "\n";
                return status_io_error;
            }
        }

        // -- (5j) GRAPH-UMBAU 2D/3D, P2 (2026-08-06): baseline-relative Verhaeltnis-Matrix -------------
        // Die vom SOTA-Katalog empfohlene Abloesung der Heatmap als ANALYSE-Figur. Die rohe Latenz-
        // Heatmap (lc_surface_<z>) bleibt daneben bestehen und wechselt nur die Rolle zur Rohdaten-/QA-
        // Ansicht. Zellwert = Median / Referenz-Median DERSELBEN Workload-Spalte, divergente Farbskala
        // um 1.0. Referenz = cfg.reference_value (Achsenauspraegung, KEINE externe Bibliothek).
        for (auto const z_sv : kSurfaceFields) {
            std::string const z{z_sv};
            if (int const rc = dg::write_surface_ratio_vs_reference(out_dir / ("lc_surface_ratio_" + z + ".tex"),
                                                                     surf_rows, z, cfg.reference_value, lang);
                !dg_ok(rc)) {
                std::cerr << "appendix-generator: write_surface_ratio_vs_reference (" << z << "," << lang
                          << ") failed " << rc << "\n";
                return status_io_error;
            }
        }

        // -- (5k) GRAPH-UMBAU 2D/3D, P3a (2026-08-06): baseline-normalisierte Balken -------------------
        // Verdichtet die Verhaeltnis-Matrix ueber die Lastprofile zu EINEM Balken je search_algo. Die
        // Matrix zeigt, WO ein Unterschied herkommt; der Balken, OB er ueber die Lastprofile traegt.
        // honest-empty: ohne gueltiges Verhaeltnis KEINE Datei (dg_ok-Toleranz).
        for (auto const z_sv : kSurfaceFields) {
            std::string const z{z_sv};
            if (int const rc = dg::write_normalized_bar_vs_reference(out_dir / ("lc_normbar_" + z + ".tex"), surf_rows,
                                                                      z, cfg.reference_value, lang);
                !dg_ok(rc)) {
                std::cerr << "appendix-generator: write_normalized_bar_vs_reference (" << z << "," << lang
                          << ") failed " << rc << "\n";
                return status_io_error;
            }
        }

        // -- (5l) GRAPH-UMBAU 2D/3D, P3b (2026-08-06): Pareto-/Tradeoff-Streuung p50 gegen p99 ---------
        // Die einzige Form hier, die ZWEI KONKURRIERENDE Kostenachsen gegeneinander auftraegt (Idreos/
        // Dayan-Familie). Ein echter Lese-vs-Speicher-Pareto ist NICHT moeglich: das WIDE-Schema traegt
        // keine Speicher-/Byte-Spalte -- p50 gegen p99 (typischer Fall gegen Dienstguete-Fall) ist das
        // Kostenpaar, das die Daten wirklich hergeben. honest-empty ohne p99 (dg_ok-Toleranz).
        if (int const rc = dg::write_latency_tradeoff_scatter(out_dir / "latency_tradeoff.tex", surf_rows, lang);
            !dg_ok(rc)) {
            std::cerr << "appendix-generator: write_latency_tradeoff_scatter (" << lang << ") failed " << rc << "\n";
            return status_io_error;
        }

        std::cout << "appendix-generator [" << lang
                  << "]: 12 Kern- + 5 Darstellungs-.tex + 3D-Flaechen + Sweep-Kurven + Achsen-Inventar "
                     "(honest-empty ausgelassen wo ohne Daten) -> "
                  << out_dir << "\n";
    }
    return status_ok;
}

} // namespace comdare::da::appendix_generator
