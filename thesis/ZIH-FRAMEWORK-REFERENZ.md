# ZIH-LaTeX-Vorlage — Framework-Befehlsreferenz (Backup)

> **Zweck:** Destillierte Nachschlage-Referenz der TU-Dresden-ZIH-Vorlage für die
> Diplomarbeit-Strukturierung. Quelle: `ZIHLatexVorlage/doku.tex` (Framework-Doku
> von Guido Juckeland), `ZIHLatexVorlage/zihpub.cls` (Style-File) und das verifizierte
> Anwendungsmuster aus `20250811_Großer_Beleg_Beispiel.zip` (eigener Großer Beleg).
> Erstellt am 2026-06-01. Die Original-`doku.tex`/`doku.pdf` bleiben unverändert in
> `ZIHLatexVorlage/` erhalten.

---

## 1. Dokumenttyp wählen (genau EINE Typ-Option)

`\documentclass[<TYP>,<weitere Optionen>]{zihpub}`

| Typ-Option | Verwendung | Basisklasse | Höchste Ebene |
|---|---|---|---|
| `proseminar` / `hauptseminar` / `mathseminar` | Seminararbeiten | `scrartcl` | `\section` |
| `plainarticle` | neutraler ZIH-Artikel | `scrartcl` | `\section` |
| `beleg` / `belegsonst` | Großer Beleg / Belegarbeit | `scrreprt` | `\chapter` |
| `plainreport` | neutraler ZIH-Bericht | `scrreprt` | `\chapter` |
| **`diplominf`** | **Diplomarbeit Diplom-Informatiker(in)** | `scrreprt` | `\chapter` |
| `diplomist` | Diplomarbeit Dipl.-Ing. Informationssystemtechnik | `scrreprt` | `\chapter` |
| `diplomtmath` | Diplomarbeit Dipl.-Mathematiker (Technomath.) | `scrreprt` | `\chapter` |
| `bachinf` / `mastinf` | Bachelor- / Master-Arbeit (B.Sc./M.Sc.) | `scrreprt` | `\chapter` |
| `dissrernat` / `dissing` | Dissertation (Dr. rer. nat. / Dr.-Ing.) | `scrreprt` | `\chapter` |

> **Für diese Arbeit relevant:** `diplominf` (Diplom-Informatiker, Fakultät Informatik).

## 2. Weitere Dokument-Optionen

| Option | Wirkung |
|---|---|
| `german` | deutsche Arbeit (Default sonst: Englisch) |
| `utf8` | UTF-8-Eingabekodierung (Default sonst: Latin-1) |
| `hyperref` | klickbare Links/Referenzen (lädt `hyperref`) |
| `lof` / `lot` | Abbildungs- / Tabellenverzeichnis erzeugen |
| `nomencl` | Symbol-/Abkürzungsverzeichnis (siehe §7) |
| `bibnum` | numerische Zitate `[1]` (`plaindin`) statt alphanumerisch `[GuJu04]` (`alphadin`) |
| `twoside` | zweiseitig (große Arbeiten) |
| `final` | **ZIH-Report-Veröffentlichungs**-Format: erzwingt zweiseitig + anderer Zeilenabstand. **Für eine Diplomarbeit i.d.R. NICHT setzen** (sonst nicht 1½-zeilig). |
| `notoc` | kein Inhaltsverzeichnis |
| `notitlepage` | kein Titelblatt (eigene Titelseite verwenden) |
| `noproblem` | entfernt den Platzhalter „Hier Aufgabenstellung einfügen!" |
| `zihtitle` | ZIH-Deckblatt (Nagel) statt Professur-Rechnerarchitektur-Deckblatt |
| `female` | hängt bei Diplomarbeiten „in" an den Grad an |
| `selbststaendigkeit` | fügt Selbständigkeitserklärung ein (bei Diplomarbeiten **automatisch** aktiv) |

## 3. Pflicht-/Metadaten-Befehle (Diplomarbeit)

```latex
\author{Vorname Nachname}
\title{Titel der Arbeit}
\matno{Matrikelnummer}            % erscheint als (Mat.-Nr.: ...)
\birthday{TT. Monat JJJJ}         % Form: "11. April 1996"
\placeofbirth{Geburtsort}
\betreuer{Dr. ...}                % Betreuer:-Zeile
\hsl{Prof. Dr. ...}              % Hochschullehrer: (Default sonst Prof. Nagel!)
\bibfiles{dateiname-ohne-endung}  % z.B. \bibfiles{literatur}  -> literatur.bib (klass. BibTeX)
\abstractde{Deutsche Kurzfassung} % NUR bei Diplom-/Dissertation
\abstracten{English abstract}     % NUR bei Diplom-/Dissertation
\acknowledgments{Danksagung ...}  % optional
\copyrighterklaerung{...}         % optional, Urheberrechts-Erklärungen
\date{...}                        % optional, sonst heutiges Datum
```

## 4. Was die Klasse AUTOMATISCH generiert (nicht manuell setzen!)

Bei `diplominf` erzeugt `zihpub.cls` selbsttätig — **kein manuelles `\maketitle`,
`\tableofcontents`, keine eigene Titel-/Erklärungsseite nötig:**

1. **Titelseite** (Institution, Titel, Autor, Geburtsdatum/-ort, Betreuer, Datum)
2. Platzhalter **„Hier Aufgabenstellung einfügen!"** (entfällt mit `noproblem`)
3. **Selbständigkeitserklärung** (automatisch bei Diplomarbeit)
4. **Kurzfassung** (`\abstractde`) + **Abstract** (`\abstracten`)
5. **Inhaltsverzeichnis** (`\tableofcontents`)
6. (optional) Symbolverzeichnis (`nomencl`)
7. **am Ende / vor `\appendix`:** Literaturverzeichnis (`\bibfiles`), dann `lof`/`lot`,
   dann Danksagung, dann Copyright-Erklärung.

> **Konsequenz für `main.tex`:** Nur Präambel-Metadaten + `\begin{document}` +
> die `\include{kapitel/...}` + `\appendix` + `\include{anhang/...}`. Das
> `\appendix`-Kommando triggert automatisch Bibliographie + LOF + LOT davor.

## 5. Gliederungsebenen (Report-Typen wie `diplominf`)

`\chapter` → `\section` → `\subsection` → `\subsubsection` → `\paragraph` → `\subparagraph`
(`secnumdepth` und `tocdepth` sind in der Klasse auf 3 gesetzt → bis `\subsubsection` nummeriert & im TOC).

## 6. Bibliographie (WICHTIG: klassisches BibTeX, NICHT biblatex/biber)

Die Klasse setzt fest:
- `\bibliographystyle{alphadin}` (alphanumerisch, deutsch) — bzw. `plaindin` mit Option `bibnum`.
- ruft selbst `\bibliography{\@bibfiles}` auf.

→ Workflow ist **`pdflatex → bibtex → pdflatex → pdflatex`**. `\bibfiles{name}` ohne `.bib`.
→ `biblatex`/`biber` ist **nicht** vorgesehen; eine Umstellung würde gegen die Klasse arbeiten.

Bereitgestellte Zitierbefehle:
- `\cite{schlüssel}` — Standardzitat
- `\longcite{schlüssel}{seite}` → „(vgl. [Ref], S. xx)"
- `\shortcite{schlüssel}{seite}` → „([Ref], S. xx)"

## 7. Symbol-/Abkürzungsverzeichnis (Option `nomencl`)

```latex
\nomenclature{<Symbol>}{<Erklärung>}     % im Text
\setnomenclmargin{3cm}                    % Spaltenbreite (optional)
% Build zusätzlich: makeindex <Hauptdatei>.nlo -s nomencl.ist -o <Hauptdatei>.nls
```

## 8. Eigene Zusatzbefehle der Klasse

- `\Paragraph{Überschrift}` — fette Absatzüberschrift mit Zeilenumbruch (`\minisec`)
- `\correctme{Text}` — färbt Text rot (= „noch zu bearbeiten"), max. 1 Absatz
- `\begin{correctmore} … \end{correctmore}` — rote Markierung über Absätze hinweg

## 9. Grafiken & Tabellen (Konvention)

- Grafik: `figure`-Umgebung, `\includegraphics[width=0.5\textwidth]{...}`, **Caption UNTER** Grafik, mit `\label`/`\ref`.
- Tabelle: `table`-Umgebung, **Caption ÜBER** Tabelle. `tabularx`, `longtable` sind geladen.

## 10. Von der Klasse geladene Pakete (NICHT erneut laden)

`fontenc[T1]`, `times`, `graphicx`, `url`, `fancyvrb`, `amsmath/amsfonts/amssymb`,
`color`, `enumerate`, `setspace`, `tabularx`, `longtable`, `babel`, `inputenc`,
(`hyperref` nur mit Option), `fancyhdr`, (`nomencl` nur mit Option).

**Selbst nachzuladen** (im Großen Beleg so gemacht): `booktabs`, `pgfplots`(+`\pgfplotsset{compat=1.18}`),
`siunitx`, `enumitem`, `tikz`, `listings` — je nach Bedarf.

## 11. Build (lokal, MiKTeX vorhanden)

```powershell
# im Arbeitsverzeichnis der Arbeit:
pdflatex -interaction=nonstopmode main.tex
bibtex   main
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```
(Die mitgelieferte `Makefile` macht exakt diese 3-Pass-bibtex-Sequenz für `TARGET=doku`.)

## 12. Bekannte Vorlagen-Warnungen (Stand `bugs.log` / Beleg-`doku.log`)

Treten in BEIDEN Logs auf, stammen aus `zihpub.cls`, **verhindern die Kompilation nicht**:

| # | Warnung | Ursache (zihpub.cls) | empfohlener minimal-invasiver Fix |
|---|---|---|---|
| 1 | `deprecated option 'abstracton'` | `\LoadClass[...,abstracton,...]` (Z. 336–351) | `abstracton` → `abstract=true` (funktional identisch) — behebt zugleich #2/#3 |
| 2 | `version=first` Kompatibilität | Folge von #1 | entfällt mit Fix #1 |
| 3 | `deprecated option 'enabledeprecatedfontcommands'` | Folge von #1 | entfällt mit Fix #1 |
| 4 | `fancyhdr together with KOMA-Script not recommended` | `\RequirePackage{fancyhdr}` (Z. 780) | bewusst belassen (Umbau wäre Struktur-Änderung; auch Großer Beleg behält es) |
| 5 | `destination with the same identifier (name{page.1/2})` | hyperref-Anker doppelt (Titelei arabisch + Body-Reset) | `\hypersetup{plainpages=false,pdfpagelabels=true}` ODER römische Titelei-Nummerierung — nach Install verifizieren |

## 13. Anwendungsmuster aus dem eigenen Großen Beleg

> **Wichtig (User 2026-06-01):** Die `zihpub.cls` im Großen Beleg wurde damals manuell und
> **unsauber** gepatcht (Institution/HSL direkt in der Klasse von „ZIH/Nagel" auf
> „Softwaretechnologie/Aßmann"; zudem Typ `beleg`, keine Diplomarbeit). Das ist **NICHT**
> nachzuahmen. **Maßgeblich ist die unveränderte Original-`ZIHLatexVorlage/`.** Anpassungen
> erfolgen sauber dokument-seitig, nicht in der Klasse.

Übernehmbares Präambel-Muster (gut):
- Selbst geladene Zusatzpakete: `setspace`, `booktabs`, `pgfplots`(+`\pgfplotsset{compat=1.18}`), `enumitem`, `siunitx`.
- `\let\cleardoublepage\clearpage` nach `\begin{document}` (vermeidet Leerseiten bei `oneside`).
- Persönliche Titelseiten-Daten (bereits von dir verwendet): `\birthday{11. April 1996}`,
  `\placeofbirth{Potsdam}`, `\matno{4510512}`.

Saubere Institution/HSL-Konfiguration **statt `.cls`-Hack** — dokument-seitig in der Präambel:
```latex
\hsl{Prof. Dr.-Ing. Wolfgang Lehner}      % Hochschullehrer (überschreibt Default Nagel)
\betreuer{apl. Prof. Dr.-Ing. Dirk Habich}
\makeatletter
\renewcommand{\@institution}{%            % Deckblatt-Institution überschreiben
  \begin{center}\huge\textsc{Technische Universit\"at Dresden}\par\bigskip
  \Large\textsc{Fakult\"at Informatik\\ Institut f\"ur Systemarchitektur\\
  Professur f\"ur Datenbanken\\ Prof. Dr.-Ing. Wolfgang Lehner}\end{center}}
\makeatother
```
(Diplomarbeit-Typ wird allein über die Klassen-Option `diplominf` gesetzt — **keine** `.cls`-Änderung.)

## 14. Englisch als Originalsprache (Stand 2026-06-01)

Die Arbeit ist im Original **Englisch**; Deutsch entsteht später als Übersetzung. Daher in `diplomarbeit/`:
- `\documentclass[diplominf,utf8,hyperref,lof,lot,twoside]{zihpub}` — **ohne** `german` (Englisch ist Vorlagen-Standard). Babel lädt `main=american` + `ngerman` (Sekundärsprache).
- **Selbständigkeitserklärung** wird von der Klasse **trotzdem auf Deutsch** gesetzt (rechtlich korrekt) — `\selectlanguage{ngerman}` im Erklärungs-Block.
- **Bibliografie-Stil** ist im EN-Modus automatisch **`alpha`** (statt `alphadin` im DE-Modus) — sprach-konform.
- Titelblatt-Labels im EN-Modus: „Professor:" / „Tutor:" (Vorlagen-Default; bei Bedarf dokument-seitig via `\renewcommand{\betreuerlabel}{Advisor: }` änderbar).

Zusätzliche, erst im EN-Modus aufgedeckte & behobene Vorlagen-Fehler (in `diplomarbeit/zihpub.cls`):

| # | Fehler | Ursache | Fix (verifiziert) |
|---|---|---|---|
| 6 | `! Extra \fi` (nur EN + Danksagung) | `\@mkboth{Acknowledgments}` ohne 2. Argument | `\@mkboth{Acknowledgments}{}` (2×) |
| 7 | Titel-`\\` → `Token not allowed in PDF string` | `\\` landet im hyperref-`pdftitle` | `\texorpdfstring{\\}{ }` im `\title` |

**Status:** Alle Fixes (#1 abstracton, #5 römische Titelei, #6 mkboth, #7 Titel) sind in `diplomarbeit/zihpub.cls` + `diplomarbeit.tex` umgesetzt und per Build verifiziert (ExitCode 0, 0 Fehler; verbleibend nur die bewusste `fancyhdr`-Empfehlung + harmloser `xcolor`-Hinweis).
