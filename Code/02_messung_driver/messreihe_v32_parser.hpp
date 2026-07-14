#pragma once
// INC-V32-C.parser (2026-07-14) — Typisierter XML->Struct-Parser fuer das allgemeine
// Diplomarbeit-Experiment-XML-Interface `<messreihe version="32">` (Familie C).
//
// @subsystem MessungDriver
// @phase_owner MessungDriver
//
// Motivation: bis dato existierte fuer messreihe_v32_*.xml NUR ein Praesenz-Validator
// (messreihe_v32_validator.hpp), der ausschliesslich `std::string_view::find`-Checks macht —
// er liest KEINE Attribut- oder Element-WERTE. Dieser Header ergaenzt die fehlende,
// faithful typisierte Parse-Schicht: er liest die Struktur aus messreihe_v32_schema.xsd
// (Wurzel `<messreihe version="32">`) in ein starkes C++-Struct.
//
// WIEDERVERWENDUNG statt neuer Parser-Quelle: liest ueber den bestehenden, self-contained
// ce-DOM-Reader `comdare::common::xml` (xml_config_parser/xml_reader.hpp) — KEIN tinyxml2,
// KEIN regex, KEINE neue Parser-Engine (identisches Muster wie messreihen_workload.hpp, #31).
//
// BEWUSST NICHT Teil dieser Schicht (spaeterer, design-gated Schritt):
//   - Verdrahtung an den Katalog / CompareEngineCommand (v32_orchestrator execute_messreihe).
//   - Aufloesung `<axis id baustein>` -> serialize_composition_path (offene Design-Frage L-6).
// Der Parser bleibt eine REINE Lese-Schicht ueber wohlgeformtem messreihe-v32-XML.
//
// Fehlertoleranz: fehlende OPTIONALE Felder -> Defaults (leerer String / 0 / false / nullopt).
// Struktureller Fehler (nicht wohlgeformt, falsches Wurzelelement) -> nullopt + klare Meldung
// (via optionalem `std::string* error`-Out-Parameter; ohne Out-Parameter still).
//
// ── DEPRECATED (INC-D, 2026-07-14) ──────────────────────────────────────────────────────────
// Dieser Interim-Standalone-Parser fuer `<messreihe version="32">` ist ABGELOEST vom Experiment-
// Parser als MODUL im allgemeinen ce-Parser: `parse_experiment_profile` (comdare_experiment,
// ce libs/common/serialization/xml_config_parser) + `validate_experiment_profile` (cache_engine
// profile_facade/validate_profile.hpp). Die Parse-Funktionen sind [[deprecated]]-markiert. Er wird
// BEHALTEN (Doku/Code nie loeschen) + bleibt funktional (sein Unit-Test bleibt gruen), NUR fuer die
// bestehende v32-Fixture messreihe_v32_schema_example.xml; NEUE Aufrufer nutzen parse_experiment_profile.
// ────────────────────────────────────────────────────────────────────────────────────────────

#include "xml_config_parser/xml_reader.hpp" // comdare::common::xml::{XmlNode, parse_document}

#include <charconv>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <optional>
#include <sstream>
#include <string>
#include <string_view>
#include <vector>

namespace comdare::diplomarbeit::messung_driver::v32 {

// ── Struct-Modell (1:1 zu messreihe_v32_schema.xsd) ─────────────────────────────────────────

struct MetadataV32 {
    std::string name;        // <metadata><name>
    std::string description; // <metadata><description>
    std::string mode;        // <metadata><mode> — "defined" | "full" | "full_sampled"
};

struct EngineV32 {
    std::string id;   // <engine id=..>
    std::string type; // <engine type=..>
    std::string name; // <engine name=..> (optional im XSD)
};

struct DefaultLookupAxisV32 {
    std::string id;               // <axis id=..>
    std::string allowed_variants; // <axis allowed_variants=..> (roher komma-getrennter String)
};

struct DefaultLookupV32 {
    bool                              present{false}; // war <axes_default_lookup> ueberhaupt vorhanden?
    bool                              enabled{false}; // <axes_default_lookup enabled=..>
    std::vector<DefaultLookupAxisV32> axes;           // <axis id allowed_variants>*
};

struct WorkloadV32 {
    std::string   kind;               // <workload kind=..>
    std::uint64_t record_count{0};    // <workload record_count=..> (XSD positiveInteger)
    std::uint64_t operation_count{0}; // <workload operation_count=..> (XSD positiveInteger)
    std::uint64_t seed{0};            // <workload seed=..> (XSD unsignedLong)
};

// Hardware-Strategie (V33.E.3), alle Leaf-Elemente optional (minOccurs=0) -> leerer String = fehlt.
struct HardwareStrategyV32 {
    std::string simd;               // <simd>
    std::string cache_level;        // <cache_level>
    std::string numa;               // <numa>
    std::string prefetch_distance;  // <prefetch_distance>
    std::string atomic_granularity; // <atomic_granularity>
};

// Scheduling-Strategie (V33.E.3), alle Leaf-Elemente optional.
struct SchedulingStrategyV32 {
    std::string worker_pool;             // <worker_pool>
    std::string simd_workers;            // <simd_workers> (XSD positiveInteger; roh belassen)
    std::string heterogeneous_awareness; // <heterogeneous_awareness>
    std::string memory_interleave;       // <memory_interleave>
    std::string batching;                // <batching>
};

// Compiler-Strategie (V35.B.4, Achse 15), alle Leaf-Elemente optional.
struct CompilerStrategyV32 {
    std::string family;      // <family> — GCC | Clang | AppleClang | MSVC (roh belassen)
    std::string opt_level;   // <opt_level>
    std::string lto;         // <lto>
    std::string pgo;         // <pgo>
    std::string target_arch; // <target_arch>
};

struct TupelAxisV32 {
    std::string id;       // <axis id=..>
    std::string baustein; // <axis baustein=..>
};

struct TupelV32 {
    std::string                          id;                  // <tupel id=..>
    bool                                 has_workload{false}; // war <workload> vorhanden?
    WorkloadV32                          workload;            // <workload ..>
    std::string                          op_type;             // <op_type> (optional) "OP-1".."OP-6"
    std::optional<HardwareStrategyV32>   hardware_strategy;   // <hardware_strategy> (optional)
    std::optional<SchedulingStrategyV32> scheduling_strategy; // <scheduling_strategy> (optional)
    std::optional<CompilerStrategyV32>   compiler_strategy;   // <compiler_strategy> (optional)
    std::vector<TupelAxisV32>            axes;                // <axes><axis id baustein>*
};

struct OutputV32 {
    std::string binary_path;                   // <binary_path>
    std::string csv_path;                      // <csv_path>
    std::string latex_path;                    // <latex_path>
    bool        has_comparison_metrics{false}; // war <comparison_metrics> vorhanden?
    bool        comparison_metrics{false};     // <comparison_metrics> (bool)
};

struct MessreiheV32 {
    std::string            version;        // <messreihe version=..> (XSD fixed "32")
    MetadataV32            metadata;       // <metadata>
    std::vector<EngineV32> engines;        // <execution_engines><engine>* (XSD: genau 2)
    DefaultLookupV32       default_lookup; // <axes_default_lookup> (optional)
    std::vector<TupelV32>  tupel;          // <tupel>+ (XSD: >=1)
    OutputV32              output;         // <output>
};

namespace detail {

// Tolerante uint64-Konvertierung eines Attribut-/Textwerts. Nicht-numerisch / leer -> `def`.
[[nodiscard]] inline std::uint64_t parse_u64_or(std::string_view s, std::uint64_t def) {
    std::uint64_t v     = 0;
    auto const*   begin = s.data();
    auto const*   end   = s.data() + s.size();
    auto [ptr, ec]      = std::from_chars(begin, end, v);
    if (ec != std::errc{} || ptr != end) return def; // partieller / fehlgeschlagener Parse
    return v;
}

// Tolerante bool-Konvertierung (XSD xs:boolean: "true"/"false"/"1"/"0"). Unbekannt -> `def`.
[[nodiscard]] inline bool parse_bool_or(std::string_view s, bool def) {
    if (s == "true" || s == "1") return true;
    if (s == "false" || s == "0") return false;
    return def;
}

// Direkter Textinhalt eines Kind-Elements (getrimmt vom Reader); fehlt -> leerer String.
[[nodiscard]] inline std::string child_text(common::xml::XmlNode const& n, std::string_view name) {
    if (auto const* c = n.child(name)) return c->text;
    return {};
}

[[nodiscard]] inline HardwareStrategyV32 parse_hardware_strategy(common::xml::XmlNode const& hw) {
    HardwareStrategyV32 h;
    h.simd               = child_text(hw, "simd");
    h.cache_level        = child_text(hw, "cache_level");
    h.numa               = child_text(hw, "numa");
    h.prefetch_distance  = child_text(hw, "prefetch_distance");
    h.atomic_granularity = child_text(hw, "atomic_granularity");
    return h;
}

[[nodiscard]] inline SchedulingStrategyV32 parse_scheduling_strategy(common::xml::XmlNode const& sc) {
    SchedulingStrategyV32 s;
    s.worker_pool             = child_text(sc, "worker_pool");
    s.simd_workers            = child_text(sc, "simd_workers");
    s.heterogeneous_awareness = child_text(sc, "heterogeneous_awareness");
    s.memory_interleave       = child_text(sc, "memory_interleave");
    s.batching                = child_text(sc, "batching");
    return s;
}

[[nodiscard]] inline CompilerStrategyV32 parse_compiler_strategy(common::xml::XmlNode const& co) {
    CompilerStrategyV32 c;
    c.family      = child_text(co, "family");
    c.opt_level   = child_text(co, "opt_level");
    c.lto         = child_text(co, "lto");
    c.pgo         = child_text(co, "pgo");
    c.target_arch = child_text(co, "target_arch");
    return c;
}

[[nodiscard]] inline TupelV32 parse_tupel(common::xml::XmlNode const& tp) {
    TupelV32 t;
    t.id = tp.attr("id");
    if (auto const* wl = tp.child("workload")) {
        t.has_workload             = true;
        t.workload.kind            = wl->attr("kind");
        t.workload.record_count    = parse_u64_or(wl->attr("record_count"), 0);
        t.workload.operation_count = parse_u64_or(wl->attr("operation_count"), 0);
        t.workload.seed            = parse_u64_or(wl->attr("seed"), 0);
    }
    if (auto const* op = tp.child("op_type")) t.op_type = op->text;
    if (auto const* hw = tp.child("hardware_strategy")) t.hardware_strategy = parse_hardware_strategy(*hw);
    if (auto const* sc = tp.child("scheduling_strategy")) t.scheduling_strategy = parse_scheduling_strategy(*sc);
    if (auto const* co = tp.child("compiler_strategy")) t.compiler_strategy = parse_compiler_strategy(*co);
    if (auto const* ax = tp.child("axes"))
        for (auto const* a : ax->children_named("axis")) t.axes.push_back({a->attr("id"), a->attr("baustein")});
    return t;
}

} // namespace detail

// ── Parse aus einem bereits geparsten DOM-Wurzelknoten (testbar ohne Datei) ─────────────────
//
// Erwartet den `<messreihe>`-Wurzelknoten. Falsches Wurzelelement -> nullopt + Meldung.
[[deprecated("superseded by parse_experiment_profile / comdare_experiment — INC-D")]]
[[nodiscard]] inline std::optional<MessreiheV32>
parse_messreihe_v32_from_root(common::xml::XmlNode const& root, std::string* error = nullptr) {
    if (root.tag != "messreihe") {
        if (error) *error = "root element is <" + root.tag + ">, expected <messreihe>";
        return std::nullopt;
    }

    MessreiheV32 m;
    m.version = root.attr("version");

    if (auto const* md = root.child("metadata")) {
        m.metadata.name        = detail::child_text(*md, "name");
        m.metadata.description = detail::child_text(*md, "description");
        m.metadata.mode        = detail::child_text(*md, "mode");
    }

    if (auto const* ee = root.child("execution_engines"))
        for (auto const* e : ee->children_named("engine"))
            m.engines.push_back({e->attr("id"), e->attr("type"), e->attr("name")});

    if (auto const* dl = root.child("axes_default_lookup")) {
        m.default_lookup.present = true;
        m.default_lookup.enabled = detail::parse_bool_or(dl->attr("enabled"), false);
        for (auto const* a : dl->children_named("axis"))
            m.default_lookup.axes.push_back({a->attr("id"), a->attr("allowed_variants")});
    }

    for (auto const* tp : root.children_named("tupel")) m.tupel.push_back(detail::parse_tupel(*tp));

    if (auto const* out = root.child("output")) {
        m.output.binary_path = detail::child_text(*out, "binary_path");
        m.output.csv_path    = detail::child_text(*out, "csv_path");
        m.output.latex_path  = detail::child_text(*out, "latex_path");
        if (auto const* cm = out->child("comparison_metrics")) {
            m.output.has_comparison_metrics = true;
            m.output.comparison_metrics     = detail::parse_bool_or(cm->text, false);
        }
    }

    return m;
}

// ── Parse aus einem XML-String ──────────────────────────────────────────────────────────────
[[deprecated("superseded by parse_experiment_profile / comdare_experiment — INC-D")]]
[[nodiscard]] inline std::optional<MessreiheV32>
parse_messreihe_v32_string(std::string_view xml, std::string* error = nullptr) {
    auto root = common::xml::parse_document(xml);
    if (!root) {
        if (error) *error = "XML not well-formed (parse_document failed)";
        return std::nullopt;
    }
    return parse_messreihe_v32_from_root(*root, error);
}

// ── Parse aus einer Datei ───────────────────────────────────────────────────────────────────
[[deprecated("superseded by parse_experiment_profile / comdare_experiment — INC-D")]]
[[nodiscard]] inline std::optional<MessreiheV32>
parse_messreihe_v32(std::filesystem::path const& xml_path, std::string* error = nullptr) {
    std::ifstream in{xml_path};
    if (!in) {
        if (error) *error = "cannot open XML file: " + xml_path.string();
        return std::nullopt;
    }
    std::ostringstream ss;
    ss << in.rdbuf();
    return parse_messreihe_v32_string(ss.str(), error);
}

} // namespace comdare::diplomarbeit::messung_driver::v32
