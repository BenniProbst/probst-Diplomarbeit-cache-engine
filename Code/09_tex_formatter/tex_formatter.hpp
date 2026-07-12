#pragma once
// tex_formatter — verlustfreie C++23-Portierung von thesis/diplomarbeit/tools/format_tex.py (#25).
//
// Satz-neutraler LaTeX-Quelltext-Formatierer (identische Semantik zur Python-Referenz):
//   (1) 2-Space-Einrueckung geschachtelter \begin..\end-Umgebungen (UNIT je Ebene),
//   (2) Hart-Umbruch von Prosa-Absaetzen auf WIDTH=100, NUR an Leerzeichen auf Klammertiefe 0.
// Satz-neutral, weil TeX fuehrende Leerzeichen ignoriert UND ein Quell-Zeilenumbruch in Prosa
// einem Wort-Zwischenraum entspricht.
// Ausgespart (nur eingerueckt, nie umgebrochen): verbatim/listings (inhaltlich unangetastet),
// Tabellen-/Mathe-/tikz-Umgebungen, Zeilen mit & oder \\ , Kommentarzeilen, Strukturbefehle.
//
// KRITISCHE KORREKTHEIT: alle Laengen-Vergleiche zaehlen UTF-8-CODE-POINTS (nicht Bytes). Python
// len() zaehlt Code-Points; std::string::size() zaehlt Bytes — deutsche Umlaute (ue/oe/ae/ss = 2
// Byte UTF-8) verzaehlten sonst die Breite und erzeugten falsche Umbrueche. Siehe cp_len().
//
// "Kein Python in der Chain" (Direktive): cross-platform C++23-Ersatz, in-place ueber die CLI.

#include <cstddef>
#include <string>

namespace comdare::da::tex_formatter {

inline constexpr int kWidth = 100; // WIDTH aus format_tex.py (Code-Points, nicht Bytes).

// Anzahl UTF-8-Code-Points in s = Anzahl fuehrender Bytes ((b & 0xC0) != 0x80; Fortsetzungsbytes
// haben das Muster 10xxxxxx und werden nicht mitgezaehlt). Schliesst die Luecke zwischen
// std::string::size() (Bytes) und Python len() (Code-Points) fuer valides UTF-8.
std::size_t cp_len(std::string const& s);

// Kernfunktion — entspricht EXAKT format_tex.py::format_text: gibt den formatierten Text OHNE
// erzwungenen Trailing-Newline zurueck (das Trailing-\n setzt der CLI-/Datei-Writer, wie main()).
std::string format_text(std::string const& text);

} // namespace comdare::da::tex_formatter
