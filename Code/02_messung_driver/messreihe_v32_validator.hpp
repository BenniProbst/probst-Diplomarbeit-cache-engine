#pragma once
// V33.D.2 (2026-05-21) - MessreiheV32Validator: Code-side XML-Schema-Validation
//
// @subsystem MessungDriver
// @phase_owner MessungDriver
//
// Validiert messreihe_v32_*.xml gegen das informelle Schema in
// test_data_xml/messreihe_v32_schema.xsd. Kein externer XML-Parser noetig —
// nutzt nur std::string Find-Operations + Struktur-Pruefungen.
//
// Header-only, keine Dependencies. Wenn spaeter pugixml/tinyxml2 verfuegbar
// ist, kann der Validator gegen vollstaendige XSD-Validation getauscht werden.
//
// INC-V32-C.parser (2026-07-14) — TYPISIERTE Validierung nachgezogen:
//   validate_string()/validate_file() unten sind der DEPRECATED Legacy-Praesenzcheck: sie
//   pruefen NUR das Vorhandensein von Tags (std::string_view::find), lesen aber KEINE Attribut-
//   oder Element-WERTE. Sie bleiben erhalten (Doku/Code nie loeschen) als schneller Wohlgeformt-
//   heits-Smoke ohne DOM-Aufbau. Die neue, wertetreue Validierung laeuft ueber den echten
//   XML->Struct-Parser (messreihe_v32_parser.hpp): validate_parsed() prueft die GEPARSTEN
//   Struct-Felder (genau 2 Engines, >=1 Tupel mit Workload, gueltiger op_type, comparison_metrics
//   gelesen, gueltiger mode). validate_parsed() ist bewusst ein Template (statisches Duck-Typing
//   ueber die MessreiheV32-Felder) STATT eines harten `#include "messreihe_v32_parser.hpp"`, damit
//   bestehende Validator-Konsumenten OHNE serialization-Include-Pfad (z.B.
//   tests/unit/test_messreihe_v32_validator) unveraendert kompilieren; instanziiert wird es nur
//   dort, wo der Parser bereits inkludiert ist (der 02-Stufen-Parser-Test).

#include <algorithm>
#include <fstream>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::diplomarbeit::messung_driver::v32 {

struct ValidationIssue {
    enum class Severity { Error, Warning };
    Severity    severity{Severity::Error};
    std::string message;
};

struct ValidationReport {
    std::vector<ValidationIssue> issues;
    bool                         valid{false};

    [[nodiscard]] bool has_errors() const noexcept {
        for (const auto& i : issues) {
            if (i.severity == ValidationIssue::Severity::Error) return true;
        }
        return false;
    }
    [[nodiscard]] std::size_t error_count() const noexcept {
        return std::ranges::count_if(issues,
                                     [](const auto& i) { return i.severity == ValidationIssue::Severity::Error; });
    }
};

class MessreiheV32Validator {
public:
    [[nodiscard]] static ValidationReport validate_string(std::string_view xml) {
        ValidationReport report;

        // Pflicht: XML-Header
        if (xml.find("<?xml") == std::string_view::npos) { add_error(report, "Missing <?xml declaration"); }

        // Pflicht: <messreihe version="32"> Root-Element
        if (xml.find("<messreihe") == std::string_view::npos) {
            add_error(report, "Missing root element <messreihe>");
        } else if (xml.find("version=\"32\"") == std::string_view::npos) {
            add_error(report, "Root <messreihe> must have version=\"32\"");
        }

        // Pflicht: <metadata> mit <mode>
        require_element(report, xml, "<metadata>", "metadata block");
        require_element(report, xml, "<name>", "metadata/name");
        require_element(report, xml, "<mode>", "metadata/mode");
        if (xml.find("<mode>defined</mode>") == std::string_view::npos &&
            xml.find("<mode>full</mode>") == std::string_view::npos &&
            xml.find("<mode>full_sampled</mode>") == std::string_view::npos) {
            add_error(report, "metadata/mode must be 'defined', 'full', or 'full_sampled'");
        }

        // Pflicht: <execution_engines> mit GENAU 2 <engine>
        require_element(report, xml, "<execution_engines>", "execution_engines block");
        const auto engine_count = count_occurrences(xml, "<engine ");
        if (engine_count != 2) {
            add_error(report,
                      "execution_engines must contain exactly 2 <engine>, found " + std::to_string(engine_count));
        }

        // Pflicht: mindestens 1 <tupel>
        const auto tupel_count = count_occurrences(xml, "<tupel ");
        if (tupel_count == 0) { add_error(report, "At least one <tupel> required"); }
        // Pro tupel: <workload>
        const auto workload_count = count_occurrences(xml, "<workload ");
        if (workload_count < tupel_count) {
            add_error(report, "Every <tupel> needs a <workload>, found " + std::to_string(workload_count) +
                                  " workloads for " + std::to_string(tupel_count) + " tupels");
        }

        // Pflicht: <output> mit Pfaden
        require_element(report, xml, "<output>", "output block");
        require_element(report, xml, "<binary_path>", "output/binary_path");
        require_element(report, xml, "<csv_path>", "output/csv_path");
        require_element(report, xml, "<latex_path>", "output/latex_path");

        // Optional: <axes_default_lookup enabled="...">
        if (xml.find("<axes_default_lookup") != std::string_view::npos &&
            xml.find("enabled=\"") == std::string_view::npos) {
            add_warning(report, "axes_default_lookup present but enabled-attribute missing");
        }

        // Closing tag
        if (xml.find("</messreihe>") == std::string_view::npos) { add_error(report, "Missing closing </messreihe>"); }

        report.valid = !report.has_errors();
        return report;
    }

    [[nodiscard]] static ValidationReport validate_file(std::string_view path) {
        std::ifstream f{std::string(path)};
        if (!f.is_open()) {
            ValidationReport report;
            add_error(report, "Cannot open XML file: " + std::string(path));
            return report;
        }
        std::stringstream ss;
        ss << f.rdbuf();
        return validate_string(ss.str());
    }

    // INC-V32-C.parser (2026-07-14) — Wertetreue Validierung der vom echten DOM-Parser
    // (messreihe_v32_parser.hpp::parse_messreihe_v32) gelieferten Struct-Felder. Additiv zum
    // DEPRECATED string-find-Pfad oben. Template (statisches Duck-Typing) statt hartem #include —
    // s. Header-Kommentar. `MessreiheV32Like` ist erwartungsgemaess das MessreiheV32-Struct.
    template <class MessreiheV32Like>
    [[nodiscard]] static ValidationReport validate_parsed(MessreiheV32Like const& m) {
        ValidationReport report;

        // Pflicht: GENAU 2 <engine> (XSD ExecutionEnginesType minOccurs=maxOccurs=2)
        if (m.engines.size() != 2) {
            add_error(report,
                      "execution_engines must contain exactly 2 <engine>, parsed " + std::to_string(m.engines.size()));
        }

        // Pflicht: mode aus {defined, full, full_sampled}
        if (m.metadata.mode != "defined" && m.metadata.mode != "full" && m.metadata.mode != "full_sampled") {
            add_error(report,
                      "metadata/mode must be 'defined', 'full', or 'full_sampled' (parsed: '" + m.metadata.mode + "')");
        }

        // Pflicht: mindestens 1 <tupel>, jeder mit <workload>, op_type (falls gesetzt) gueltig
        if (m.tupel.empty()) { add_error(report, "At least one <tupel> required (parsed 0)"); }
        for (const auto& t : m.tupel) {
            if (!t.has_workload) { add_error(report, "tupel '" + t.id + "' missing <workload>"); }
            if (!t.op_type.empty() && !is_valid_op_type(t.op_type)) {
                add_error(report, "tupel '" + t.id + "' has invalid op_type '" + t.op_type + "' (expected OP-1..OP-6)");
            }
        }

        // comparison_metrics MUSS gelesen worden sein (OutputType, xs:boolean)
        if (!m.output.has_comparison_metrics) {
            add_warning(report, "output/comparison_metrics not present (F15-Verdict/Ratios undefiniert)");
        }

        report.valid = !report.has_errors();
        return report;
    }

private:
    // XSD op_type-Enumeration (messreihe_v32_schema.xsd:76-87).
    [[nodiscard]] static bool is_valid_op_type(std::string_view s) noexcept {
        return s == "OP-1" || s == "OP-2" || s == "OP-3" || s == "OP-4" || s == "OP-5" || s == "OP-6";
    }

    static void add_error(ValidationReport& report, const std::string& msg) {
        report.issues.push_back({ValidationIssue::Severity::Error, msg});
    }
    static void add_warning(ValidationReport& report, const std::string& msg) {
        report.issues.push_back({ValidationIssue::Severity::Warning, msg});
    }
    static void require_element(ValidationReport& report, std::string_view xml, std::string_view needle,
                                std::string_view human) {
        if (xml.find(needle) == std::string_view::npos) {
            add_error(report, "Missing " + std::string(human) + " (needle: " + std::string(needle) + ")");
        }
    }
    static std::size_t count_occurrences(std::string_view haystack, std::string_view needle) {
        if (needle.empty()) return 0;
        std::size_t count = 0;
        std::size_t pos   = 0;
        while ((pos = haystack.find(needle, pos)) != std::string_view::npos) {
            ++count;
            pos += needle.size();
        }
        return count;
    }
};

} // namespace comdare::diplomarbeit::messung_driver::v32
