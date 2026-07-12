// tex_formatter — Implementierung. Zeile-fuer-Zeile-Portierung von format_tex.py (#25).
//
// Kartierung Python -> C++ (jede Regel ist unten am jeweiligen Konstrukt annotiert):
//   VERB_ENVS / NOREFLOW_ENVS  -> is_verb_env / is_noreflow_env
//   has_comment                -> has_comment
//   CMD_BOUNDARY/LONE_CMD/...   -> kCmdBoundary/kLoneCmd/kDisplayMath (std::regex, ECMAScript)
//   is_boundary                -> is_boundary
//   reflow (escape-aware chunk) -> reflow (byte-iterierend, WIDTH-Vergleich per cp_len)
//   format_text                -> format_text
//   len()  (Code-Points)       -> cp_len()  (fuehrende UTF-8-Bytes)

#include "tex_formatter.hpp"

#include <algorithm>
#include <regex>
#include <string>
#include <vector>

namespace comdare::da::tex_formatter {

// UTF-8-Code-Point-Zaehlung: nur fuehrende Bytes ((b & 0xC0) != 0x80) zaehlen.
std::size_t cp_len(std::string const& s) {
    std::size_t count = 0;
    for (unsigned char b : s)
        if ((b & 0xC0) != 0x80) ++count;
    return count;
}

namespace {

// VERB_ENVS: inhaltlich unangetastet (nur Zeilen bis \end{env} durchgereicht).
bool is_verb_env(std::string const& e) {
    return e == "verbatim" || e == "Verbatim" || e == "lstlisting" || e == "lstlisting*" || e == "minted" ||
           e == "comment" || e == "alltt";
}

// NOREFLOW_ENVS: nur eingerueckt, nie umgebrochen.
bool is_noreflow_env(std::string const& e) {
    static std::vector<std::string> const kNoReflow = {
        "tabular",   "tabular*",     "tabularx",     "longtable",  "supertabular", "array",    "align",
        "align*",    "alignat",      "alignat*",     "gather",     "gather*",      "multline", "equation",
        "equation*", "split",        "cases",        "matrix",     "bmatrix",      "pmatrix",  "tikzpicture",
        "axis",      "semilogyaxis", "semilogxaxis", "loglogaxis", "pspicture"};
    return std::find(kNoReflow.begin(), kNoReflow.end(), e) != kNoReflow.end();
}

std::string const kUnit = "  "; // UNIT (2 Leerzeichen je Ebene)

// Python str.strip()/rstrip() (ASCII-Whitespace-Umfang; LaTeX-Quelltext enthaelt keine exotischen
// Unicode-Whitespaces am Zeilenrand — siehe Modul-Doku "offene Punkte").
bool is_ascii_ws(unsigned char c) { return c == ' ' || c == '\t' || c == '\n' || c == '\v' || c == '\f' || c == '\r'; }
std::string rstrip(std::string const& s) {
    std::size_t end = s.size();
    while (end > 0 && is_ascii_ws(static_cast<unsigned char>(s[end - 1]))) --end;
    return s.substr(0, end);
}
std::string strip(std::string const& s) {
    std::size_t b = 0;
    std::size_t e = s.size();
    while (b < e && is_ascii_ws(static_cast<unsigned char>(s[b]))) ++b;
    while (e > b && is_ascii_ws(static_cast<unsigned char>(s[e - 1]))) --e;
    return s.substr(b, e - b);
}

// UNIT * n (n >= 0).
std::string repeat_unit(int n) {
    std::string r;
    for (int k = 0; k < n; ++k) r += kUnit;
    return r;
}

int count_of(std::vector<std::string> const& v, std::string const& e) {
    int c = 0;
    for (auto const& x : v)
        if (x == e) ++c;
    return c;
}

// has_comment: ein '%' ist ein Kommentar, ausser er ist mit '\' escaped (\x ueberspringt 2 Zeichen).
// Byte-iterierend identisch zur Code-Point-Variante, da nur gegen ASCII ('\\','%') verglichen wird
// und Fortsetzungsbytes (>= 0x80) nie '\\' oder '%' sind.
bool has_comment(std::string const& s) {
    std::size_t i = 0;
    while (i < s.size()) {
        if (s[i] == '\\') {
            i += 2;
            continue;
        }
        if (s[i] == '%') return true;
        i += 1;
    }
    return false;
}

// CMD_BOUNDARY / LONE_CMD / DISPLAY_MATH — die exakten Regex-Muster der Python-Referenz.
// std::regex(ECMAScript) mit match_continuous == Python re.match (Anker am Stringanfang).
std::regex const kCmdBoundary(
    R"(\\(begin|end|section|subsection|subsubsection|paragraph|subparagraph|chapter|part|caption|captionof|label|input|include|bibliography|bibliographystyle|printbibliography|newcommand|renewcommand|providecommand|def|setlength|addtolength|hline|toprule|midrule|bottomrule|cmidrule|rowcolor|vspace|hspace|bigskip|medskip|smallskip|noindent|centering|raggedright|raggedleft|clearpage|newpage|pagebreak|maketitle|tableofcontents|listoffigures|listoftables|minisec|item\b))",
    std::regex::ECMAScript);
std::regex const kLoneCmd(R"(\\[a-zA-Z@]+\*?$)", std::regex::ECMAScript);
std::regex const kDisplayMath(R"(^(\\\[|\\\]|\$\$))", std::regex::ECMAScript);

bool match_at_start(std::string const& s, std::regex const& re) {
    return std::regex_search(s, re, std::regex_constants::match_continuous);
}

// re.findall(r"\\<kind>\{([^}]*)\}", s) — sammelt alle Umgebungs-Namen. Handgerollt (literaler
// Praefix "\<kind>{" + Capture bis zum ersten '}'), verhaltensgleich zum Regex-findall.
std::vector<std::string> findall_env(std::string const& s, std::string const& kind) {
    std::vector<std::string> res;
    std::string const        needle = "\\" + kind + "{";
    std::size_t              pos    = 0;
    while (true) {
        std::size_t const start = s.find(needle, pos);
        if (start == std::string::npos) break;
        std::size_t const open  = start + needle.size();
        std::size_t const close = s.find('}', open);
        if (close == std::string::npos) {
            pos = open; // kein '}' => keine Regex-Uebereinstimmung hier; weiter hinter dem Praefix suchen.
            continue;
        }
        res.push_back(s.substr(open, close - open));
        pos = close + 1;
    }
    return res;
}

// is_boundary — Reihenfolge exakt wie Python (LONE_CMD VOR CMD_BOUNDARY; z.B. bare "\item" ist
// bereits ueber LONE_CMD eine boundary).
bool is_boundary(std::string const& stripped) {
    if (stripped.find('&') != std::string::npos) return true;
    if (stripped.find("\\\\") != std::string::npos) return true; // enthaelt "\\" (LaTeX-Zeilenumbruch)
    if (has_comment(stripped)) return true;
    if (match_at_start(stripped, kLoneCmd)) return true;
    if (match_at_start(stripped, kDisplayMath)) return true;
    if (match_at_start(stripped, kCmdBoundary) && stripped.rfind("\\item", 0) != 0) return true;
    return false;
}

// reflow: escape-aware Chunking (\x als Einheit, {}-Tiefe, Space-Break nur auf Tiefe 0) + greedy
// Wrap. WIDTH-Vergleich per cp_len (Code-Points!). Byte-iterierend; die Ausgabe-Bytes sind
// identisch zur Python-Code-Point-Iteration (Fortsetzungsbytes sind nie '\\','{','}',' ').
std::vector<std::string> reflow(std::string const& text, std::string const& indent) {
    std::vector<std::string> chunks;
    std::string              buf;
    int                      depth = 0;
    std::size_t              i     = 0;
    std::size_t const        n     = text.size();
    while (i < n) {
        char const c = text[i];
        if (c == '\\' && i + 1 < n) {
            buf.push_back(text[i]);
            buf.push_back(text[i + 1]);
            i += 2;
            continue;
        }
        if (c == '{') {
            depth += 1;
            buf.push_back(c);
            i += 1;
            continue;
        }
        if (c == '}') {
            depth = std::max(0, depth - 1);
            buf.push_back(c);
            i += 1;
            continue;
        }
        if (c == ' ' && depth == 0) {
            if (!buf.empty()) {
                chunks.push_back(buf);
                buf.clear();
            }
            i += 1;
            while (i < n && text[i] == ' ') ++i;
            continue;
        }
        buf.push_back(c);
        i += 1;
    }
    if (!buf.empty()) chunks.push_back(buf);

    std::vector<std::string> lines;
    std::string              cur = indent;
    for (auto const& ch : chunks) {
        std::string const cand = (cur == indent) ? (cur + ch) : (cur + " " + ch);
        if (cp_len(cand) > static_cast<std::size_t>(kWidth) && cur != indent) {
            lines.push_back(cur);
            cur = indent + ch;
        } else {
            cur = cand;
        }
    }
    if (cur != indent || lines.empty()) lines.push_back(cur);
    return lines;
}

// text.replace("\r","").split("\n") mit rstrip je Zeile.
std::vector<std::string> split_lines_rstrip(std::string const& text) {
    std::string t;
    t.reserve(text.size());
    for (char c : text)
        if (c != '\r') t.push_back(c);
    std::vector<std::string> lines;
    std::size_t              start = 0;
    while (true) {
        std::size_t const nl = t.find('\n', start);
        if (nl == std::string::npos) {
            lines.push_back(rstrip(t.substr(start)));
            break;
        }
        lines.push_back(rstrip(t.substr(start, nl - start)));
        start = nl + 1;
    }
    return lines;
}

} // namespace

std::string format_text(std::string const& text) {
    std::vector<std::string> const lines = split_lines_rstrip(text);

    std::vector<std::string> out;
    int                      depth   = 0;
    bool                     in_verb = false;
    std::string              verb;
    std::vector<std::string> para;
    int                      para_indent = 0;
    std::vector<std::string> noreflow;

    auto flush = [&]() {
        if (!para.empty()) {
            std::string joined;
            for (std::size_t k = 0; k < para.size(); ++k) {
                if (k) joined += " ";
                joined += strip(para[k]);
            }
            auto const reflowed = reflow(joined, repeat_unit(para_indent));
            out.insert(out.end(), reflowed.begin(), reflowed.end());
            para.clear();
        }
    };

    for (auto const& line : lines) {
        if (in_verb) {
            out.push_back(line);
            if (line.find("\\end{" + verb + "}") != std::string::npos) {
                in_verb = false;
                verb.clear();
            }
            continue;
        }
        std::string const stripped = strip(line);
        if (stripped.empty()) {
            flush();
            out.emplace_back();
            continue;
        }
        std::vector<std::string> const begins      = findall_env(stripped, "begin");
        std::vector<std::string> const ends        = findall_env(stripped, "end");
        int const                      rd          = (stripped.rfind("\\end", 0) == 0) ? std::max(depth - 1, 0) : depth;
        bool const                     in_noreflow = !noreflow.empty();

        if (in_noreflow || is_boundary(stripped)) {
            flush();
            out.push_back(repeat_unit(rd) + stripped);
        } else if (stripped.rfind("\\item", 0) == 0) {
            flush();
            para.clear();
            para.push_back(stripped);
            para_indent = depth;
        } else {
            if (para.empty()) para_indent = depth;
            para.push_back(stripped);
        }

        depth = std::max(depth + static_cast<int>(begins.size()) - static_cast<int>(ends.size()), 0);
        for (auto const& e : begins) {
            if (is_verb_env(e) && count_of(begins, e) > count_of(ends, e)) {
                in_verb = true;
                verb    = e;
            } else if (is_noreflow_env(e)) {
                noreflow.push_back(e);
            }
        }
        for (auto const& e : ends) {
            if (is_noreflow_env(e)) {
                auto const it = std::find(noreflow.begin(), noreflow.end(), e);
                if (it != noreflow.end()) noreflow.erase(it);
            }
        }
    }
    flush();

    std::string result;
    for (std::size_t k = 0; k < out.size(); ++k) {
        if (k) result += "\n";
        result += out[k];
    }
    return result;
}

} // namespace comdare::da::tex_formatter
