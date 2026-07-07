// V35.D.4 (2026-05-22) - Stufen-Test mit gecachten Fixtures (06_latex_to_pdf)
//
// Anders als Stufen 03-05: 06_latex_to_pdf hat keinen C++-Body (nur CMake-Driver
// + sh/bat-Skripte). Tests pruefen daher:
// - Toolchain-Files existieren (CMake-Output)
// - build_thesis.sh/bat sind valide
// - Cached minimal-LaTeX-Snippet kann (optional) mit pdflatex gebaut werden

#include <gtest/gtest.h>

#include <cstdlib>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <string>
#if !defined(_WIN32)
#include <unistd.h> // Skip-Audit #12: ::getuid fuer per-User-Tempdir
#endif

namespace fs = std::filesystem;

namespace {

constexpr const char* kMinimalTexContent = R"(\documentclass[a4paper,12pt]{article}
\usepackage[utf8]{inputenc}
\usepackage{booktabs}
\usepackage{pgfplots}
\pgfplotsset{compat=newest}

\begin{document}
\section{V35.D.4 Minimal-LaTeX Smoke-Test}

\begin{table}[!htbp]
  \centering
  \begin{tabular}{lr}
    \toprule
    Permutation & Throughput (ops/s) \\
    \midrule
    CE-Pure-SOTA      & 1000.0 \\
    PrtArt-Innovative & 1500.0 \\
    \bottomrule
  \end{tabular}
  \caption{Sample-Tabelle Pipeline-Stage 04 Output.}
  \label{tab:v35d4_minimal}
\end{table}

\begin{figure}[!htbp]
  \centering
  \begin{tikzpicture}
    \begin{axis}[width=0.7\textwidth,height=4cm,ybar,symbolic x coords={CE,PA},xtick=data]
      \addplot+[] coordinates {(CE,1000) (PA,1500)};
    \end{axis}
  \end{tikzpicture}
  \caption{Sample-TikZ Pipeline-Stage 05 Output.}
  \label{fig:v35d4_minimal}
\end{figure}

\end{document}
)";

void ensure_cached_minimal_tex(fs::path const& p) {
    if (!fs::exists(p)) {
        fs::create_directories(p.parent_path());
        std::ofstream f(p);
        f << kMinimalTexContent;
    }
}

fs::path fixtures_dir() {
    if (auto* env = std::getenv("COMDARE_FIXTURES_DIR_06"); env != nullptr) { return fs::path(env); }
    return fs::current_path() / "fixtures" / "cached";
}

fs::path module_source_dir() {
    if (auto* env = std::getenv("COMDARE_MODULE_SOURCE_DIR_06"); env != nullptr) { return fs::path(env); }
    return fs::current_path();
}

bool tool_available(std::string_view tool) {
#ifdef _WIN32
    std::string cmd = std::string("where ") + std::string(tool) + " >NUL 2>&1";
#else
    std::string cmd = std::string("command -v ") + std::string(tool) + " >/dev/null 2>&1";
#endif
    return std::system(cmd.c_str()) == 0;
}

} // namespace

TEST(Stufe06Pipeline, CachedMinimalTexFixtureExistsOrIsGenerated) {
    auto dir = fixtures_dir();
    ensure_cached_minimal_tex(dir / "minimal_main.tex");
    EXPECT_TRUE(fs::exists(dir / "minimal_main.tex"));
    EXPECT_GT(fs::file_size(dir / "minimal_main.tex"), 500u);
}

TEST(Stufe06Pipeline, MinimalTexContainsExpectedSections) {
    auto dir = fixtures_dir();
    ensure_cached_minimal_tex(dir / "minimal_main.tex");
    std::ifstream in(dir / "minimal_main.tex");
    std::string   content((std::istreambuf_iterator<char>(in)), {});
    EXPECT_NE(content.find("\\documentclass"), std::string::npos);
    EXPECT_NE(content.find("\\begin{document}"), std::string::npos);
    EXPECT_NE(content.find("\\begin{tabular}"), std::string::npos);
    EXPECT_NE(content.find("\\begin{tikzpicture}"), std::string::npos);
    EXPECT_NE(content.find("\\end{document}"), std::string::npos);
}

TEST(Stufe06Pipeline, BuildThesisShellScriptExists) {
    auto src = module_source_dir();
    EXPECT_TRUE(fs::exists(src / "build_thesis.sh"));
    EXPECT_TRUE(fs::exists(src / "build_thesis.bat"));
    EXPECT_GT(fs::file_size(src / "build_thesis.sh"), 100u);
    EXPECT_GT(fs::file_size(src / "build_thesis.bat"), 100u);
}

TEST(Stufe06Pipeline, BuildThesisScriptsReferencePdflatex) {
    auto          src = module_source_dir();
    std::ifstream in_sh(src / "build_thesis.sh");
    std::string   sh_content((std::istreambuf_iterator<char>(in_sh)), {});
    EXPECT_NE(sh_content.find("pdflatex"), std::string::npos);

    std::ifstream in_bat(src / "build_thesis.bat");
    std::string   bat_content((std::istreambuf_iterator<char>(in_bat)), {});
    EXPECT_NE(bat_content.find("pdflatex"), std::string::npos);
}

TEST(Stufe06Pipeline, PdfBuildSkippedIfPdflatexAbsent) {
    // Smoke-Test: wenn pdflatex verfuegbar, build die minimal-tex; sonst SKIP
    if (!tool_available("pdflatex")) {
        GTEST_SKIP() << "pdflatex nicht verfuegbar — Stufe 06 nur als CMake-Toolchain-Wrapper getestet";
    }
    auto dir = fixtures_dir();
    ensure_cached_minimal_tex(dir / "minimal_main.tex");

    // Skip-Audit #12 (2026-07-07): per-User-Tempdir (CI-/tmp-Kollisionsklasse, Muster comdare_user_tmp).
#if defined(_WIN32)
    auto work_dir = fs::temp_directory_path() / "v35d4_pdflatex_smoke";
#else
    auto work_dir = fs::temp_directory_path() / ("comdare_test_" + std::to_string(::getuid())) /
                    "v35d4_pdflatex_smoke";
#endif
    fs::create_directories(work_dir);
    auto in_tex = work_dir / "main.tex";
    fs::copy_file(dir / "minimal_main.tex", in_tex, fs::copy_options::overwrite_existing);

    // pdflatex -interaction=nonstopmode -halt-on-error -output-directory=work_dir main.tex
#if defined(_WIN32)
    char const* devnull = ">NUL 2>&1";
#else
    char const* devnull = ">/dev/null 2>&1"; // Skip-Audit #12: ">NUL" erzeugte auf Linux eine Junk-Datei ./NUL
#endif
    std::string cmd = std::string("pdflatex -interaction=nonstopmode -halt-on-error ") + "-output-directory=\"" +
                      work_dir.string() + "\" \"" + in_tex.string() + "\" " + devnull;
    int         rc  = std::system(cmd.c_str());
    // Skip-Audit #12 (2026-07-07): rc != 0 war frueher ein GTEST_SKIP — das MASKIERTE einen echten
    // Stufe-06-Defekt (pdflatex vorhanden, Lauf scheitert = kaputte Toolchain/Fixture). Jetzt HART.
    ASSERT_EQ(rc, 0) << "pdflatex-Lauf scheiterte (rc=" << rc << ") — Stufe-06-Toolchain/Pakete pruefen";
    auto pdf = work_dir / "main.pdf";
    EXPECT_TRUE(fs::exists(pdf));
    EXPECT_GT(fs::file_size(pdf), 1000u);

    std::error_code ec;
    fs::remove_all(work_dir, ec);
}
