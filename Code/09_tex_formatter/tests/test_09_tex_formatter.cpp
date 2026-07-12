// Regressions-Test Pipeline-Stufe 09 (tex_formatter).
//
// BEWEIS: die C++23-Portierung format_text() ist BYTE-IDENTISCH zur Python-Referenz
// thesis/diplomarbeit/tools/format_tex.py (#25). Die golden-Outputs unter tests/fixtures/golden/
// wurden EINMALIG offline mit genau jenem Python-Skript erzeugt (kein Python im Test).
// Drei Achsen:
//   (1) ByteIdentical  — format_doc(input) == golden (byte-genau) je Fixture.
//   (2) Idempotent     — format_doc(golden) == golden (erneutes Formatieren aendert nichts).
//   (3) CodePointWidth — die Umlaut-Fixture enthaelt eine Zeile <=100 Code-Points ABER >100 Bytes;
//                        ein byte-zaehlender Formatierer haette sie frueher umgebrochen -> Beweis
//                        der UTF-8-Code-Point-Zaehlung (cp_len).

#include "tex_formatter.hpp"

#include <gtest/gtest.h>

#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iterator>
#include <string>
#include <vector>

namespace tf = comdare::da::tex_formatter;
namespace fs = std::filesystem;

namespace {

fs::path fixtures_dir() {
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_09"); env != nullptr) { return fs::path(env); }
#ifdef COMDARE_FIXTURES_DIR_09_FALLBACK
    return fs::path(COMDARE_FIXTURES_DIR_09_FALLBACK); // CMake-einkompilierter Source-Dir-Fallback.
#else
    return fs::current_path() / "fixtures";
#endif
}

std::string read_all(fs::path const& p) {
    std::ifstream in(p, std::ios::binary);
    return std::string((std::istreambuf_iterator<char>(in)), std::istreambuf_iterator<char>());
}

// Trailing-Newline-Regel aus format_tex.py::main() — die CLI/der Datei-Writer, nicht format_text.
std::string format_doc(std::string const& src) {
    std::string r = tf::format_text(src);
    if (r.empty() || r.back() != '\n') r += "\n";
    return r;
}

// Fixture-Basisnamen: input/<name>.tex  <->  golden/<name>.tex.
std::vector<std::string> const& fixture_names() {
    static std::vector<std::string> const kNames = {"prose_umlaut_width", "nested_envs",   "verbatim_block",
                                                    "tabular_noreflow",   "itemize_list",  "comments_escaped",
                                                    "display_math",       "thesis_excerpt"};
    return kNames;
}

} // namespace

// (1) Byte-Identitaet gegen die Python-golden-Outputs.
TEST(Stufe09TexFormatter, ByteIdenticalToPythonGolden) {
    auto const dir = fixtures_dir();
    for (auto const& name : fixture_names()) {
        auto const in_p = dir / "input" / (name + ".tex");
        auto const go_p = dir / "golden" / (name + ".tex");
        ASSERT_TRUE(fs::exists(in_p)) << "input fehlt: " << in_p;
        ASSERT_TRUE(fs::exists(go_p)) << "golden fehlt: " << go_p;
        std::string const input  = read_all(in_p);
        std::string const golden = read_all(go_p);
        EXPECT_EQ(format_doc(input), golden) << "byte-diff (vs Python-golden) in " << name;
    }
}

// (2) Idempotenz: format(format(x)) == format(x).
TEST(Stufe09TexFormatter, Idempotent) {
    auto const dir = fixtures_dir();
    for (auto const& name : fixture_names()) {
        std::string const golden = read_all(dir / "golden" / (name + ".tex"));
        ASSERT_FALSE(golden.empty()) << "golden leer: " << name;
        EXPECT_EQ(format_doc(golden), golden) << "nicht idempotent: " << name;
    }
}

// (3) Beweis der Code-Point-Zaehlung: mind. eine golden-Zeile ist <=100 Code-Points UND >100 Bytes.
TEST(Stufe09TexFormatter, CodePointWidthNotByteWidth) {
    std::string const golden = read_all(fixtures_dir() / "golden" / "prose_umlaut_width.tex");
    ASSERT_FALSE(golden.empty());
    bool        proof = false;
    std::size_t start = 0;
    while (true) {
        std::size_t const nl   = golden.find('\n', start);
        std::string const line = (nl == std::string::npos) ? golden.substr(start) : golden.substr(start, nl - start);
        // Reine Prosa-Fixture: KEINE Zeile darf 100 Code-Points ueberschreiten (Umbruch-Korrektheit).
        EXPECT_LE(tf::cp_len(line), static_cast<std::size_t>(tf::kWidth)) << "Zeile > 100 Code-Points: " << line;
        if (tf::cp_len(line) <= static_cast<std::size_t>(tf::kWidth) && line.size() > 100) proof = true;
        if (nl == std::string::npos) break;
        start = nl + 1;
    }
    EXPECT_TRUE(proof) << "kein Beweis (<=100 Code-Points UND >100 Bytes) — Umlaut-Fixture untauglich";
}
