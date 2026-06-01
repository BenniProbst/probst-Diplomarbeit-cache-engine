# Session: Bilingualer Compile-Schalter (EN primär / DE sekundär) + Sprachkonventionen

**Datum:** 2026-06-01
**Projekt:** Diplomarbeit B.-E. Probst — `thesis/diplomarbeit/`
**Status:** Konzept festgelegt; Umsetzung folgt unmittelbar in diesem Arbeitsblock.
**Auslöser:** Nutzer-Direktive — „einen Compile-Schalter je eingestellter Sprache mit einbauen,
damit wir mit demselben Quelldokument automatisch eine englische und deutsche Version je nach
Wunsch erstellen können. Dazu gehören auch Anpassung der Enumerations-Standards und sonstige
Konventionen je Sprachraum."

---

## 1. Ziel und Anforderung

Die Diplomarbeit wird **im Original auf Englisch** verfasst; eine **deutsche Fassung** wird
sekundär (als Übersetzung, u. a. mit Claude Code) gepflegt. Beide Fassungen sollen aus **einem
gemeinsamen Projekt** entstehen, gesteuert über **einen einzigen Schalter**:

- **EN** → Hauptsprache American English, Stil `alpha`, englische Typografie-Konventionen.
- **DE** → Hauptsprache Deutsch (`ngerman`), Stil `alphadin`, deutsche Typografie-Konventionen.

Wichtig: Es soll **kein** zweites, divergierendes Projekt entstehen. Gemeinsame Bestandteile
(Layout, Präambel, Build, Bibliografie, Abbildungen/Tabellen, Mess-Pipeline-Inputs) bleiben
**single source**; nur der **sprachlich verschiedene Fließtext** liegt getrennt vor.

---

## 2. Architektur-Entscheidung: getrennte Inhaltsdateien + gemeinsame Hülle

Es gibt grundsätzlich zwei Wege für bilinguale LaTeX-Dokumente:

| Ansatz | Idee | Bewertung für eine Diplomarbeit |
|---|---|---|
| **(A) Inline-Schalter** | Pro Textstück ein Makro `\TL{english}{deutsch}` im selben File | ❌ Bei Thesis-Umfang unlesbar; jeder Absatz doppelt inline; Diff-/Review-Hölle |
| **(B) Getrennte Inhaltsdateien** | Gemeinsame Hülle (Präambel/Schalter/Build) + `kapitel/en/…` vs. `kapitel/de/…` | ✅ Klar, übersetzungs-freundlich, Claude kann `de/` aus `en/` generieren |

**Gewählt: Ansatz (B).** Begründung:
1. Passt exakt zum Workflow „EN schreiben → übersetzen → DE". Die Übersetzung erzeugt
   eine **Datei** (`kapitel/de/01_introduction.tex`) aus dem englischen Pendant — kein
   Verflechten im selben File.
2. **EN ist Source-of-Truth.** Die deutschen Dateien sind ableitbar und nachführbar.
3. Review/Diff bleibt pro Sprache sauber.
4. Die **Hülle** (`diplomarbeit.tex`, Präambel, `zihpub.cls`, `literatur.bib`, `tikz/`,
   `tabellen/`, Build-Skripte) ist und bleibt **single source** — genau das „eine Quelldokument".

---

## 3. Der Sprach-Schalter (Mechanismus)

### 3.1 Zentrale Schaltstelle

Eine einzige Variable `\thesislang` mit Wert `en` oder `de`. Default `en`.

```latex
% diplomarbeit.tex — GANZ OBEN, noch vor \documentclass:
% Sprach-Schalter. Override ohne Datei-Edit moeglich (siehe Build, §6):
%   pdflatex "\def\thesislang{de}\input{diplomarbeit.tex}"
\providecommand{\thesislang}{en}     % 'en' (primaer) | 'de' (sekundaer)

\def\langDE{de}
\newif\ifthesisDE
\ifx\thesislang\langDE \thesisDEtrue \else \thesisDEfalse \fi

% Klassen-Option 'german' nur im DE-Modus an zihpub durchreichen:
\ifthesisDE \PassOptionsToClass{german}{zihpub}\fi

\documentclass[diplominf,utf8,hyperref,lof,lot,twoside]{zihpub}
```

**Warum `\providecommand` + `\PassOptionsToClass`:**
- `\providecommand{\thesislang}{en}` setzt den Default **nur**, wenn `\thesislang` nicht bereits
  (z. B. via Kommandozeile `\def\thesislang{de}`) gesetzt wurde. So funktioniert **beides**:
  Datei-Default *und* CLI-Override.
- `\PassOptionsToClass{german}{zihpub}` ist der saubere Weg, der Klasse **bedingt** die Option
  `german` mitzugeben (die Klassen-Optionsliste selbst kann nicht in ein `\if` gehüllt werden,
  weil `\documentclass` die Optionen direkt parst). Im EN-Modus wird nichts übergeben → Englisch
  ist der Vorlagen-Standard.

### 3.2 Was der Schalter automatisch über die ZIH-Klasse steuert

Durch das (bedingte) `german` schaltet `zihpub.cls` von sich aus um:
- **babel-Hauptsprache**: `main=ngerman` (DE) bzw. `main=american` (EN) — jeweils mit der
  anderen Sprache als Sekundärsprache.
- **Bibliografie-Stil**: `\bibliographystyle{alphadin}` (DE) bzw. `{alpha}` (EN) — **automatisch**.
- **Deckblatt-Labels**: „Hochschullehrer:"/„Betreuer:" (DE) bzw. „Professor:"/„Tutor:" (EN).
- **Abschnitts-/Verzeichnis-Titel**: über babel/KOMA (z. B. „Inhaltsverzeichnis" vs. „Contents",
  „Abbildung" vs. „Figure", „Tabelle" vs. „Table", „Kapitel" vs. „Chapter").

### 3.3 Sprachgetrennte Inhalts-Includes

```latex
\include{kapitel/\thesislang/01_introduction}
\include{kapitel/\thesislang/02_fundamentals}
% ...
\appendix
\include{anhang/\thesislang/A_measurements}
% ...
```

`\thesislang` expandiert zu `en` oder `de` → es wird automatisch der passende Ordner gewählt.

---

## 4. Verzeichnis-Layout (Single-Source-Hülle + sprachgetrennter Inhalt)

```
thesis/diplomarbeit/
├── diplomarbeit.tex            ← Hülle + Schalter (single source)
├── config/
│   └── language.tex            ← optionale ausgelagerte Schaltzeile (\def\thesislang{en})
├── kapitel/
│   ├── en/  01_introduction.tex … 08_conclusion.tex   ← Original (EN)
│   └── de/  01_introduction.tex … 08_conclusion.tex   ← Übersetzung (DE)
├── anhang/
│   ├── en/  A_measurements.tex … E_architecture_decisions.tex
│   └── de/  A_messreihen.tex   … E_architekturentscheidungen.tex
├── literatur.bib               ← sprachneutral (Stil wählt die Klasse)
├── tikz/  tabellen/            ← sprachneutrale Mess-Artefakte (single source)
├── build.ps1                   ← Default-Build (EN)
├── build-en.ps1 / build-de.ps1 ← explizite Sprach-Builds
├── zihpub.cls (+ alphadin.bst, plaindin.bst, alpha.bst, Logos)
└── sessions/  (diese Doku)
```

**Hinweis Dateinamen:** Innerhalb von `en/` und `de/` werden **identische Basisnamen** verwendet
(z. B. beide `01_introduction.tex`), damit der `\include{kapitel/\thesislang/01_introduction}`-Pfad
für beide Sprachen aufgeht. (Bestehende deutsch benannte Stubs `01_einleitung.tex` etc. werden im
Zuge der Umstellung auf dieses Schema überführt.)

---

## 5. Sprachraumspezifische Konventionen

Zentral gebündelt in der Präambel über `\ifthesisDE … \else … \fi`.

| Konvention | Englisch (EN) | Deutsch (DE) | Umsetzung |
|---|---|---|---|
| **babel-Hauptsprache** | `american` | `ngerman` | via `german`-Klassenoption (§3.2) |
| **Anführungszeichen** | „curly" `"…"` | „deutsch" `„…"` | `csquotes` + `\enquote{…}` (babel-aware) |
| **Dezimaltrennzeichen** | Punkt `3.14` | Komma `3{,}14` | `\sisetup{output-decimal-marker={.}/{,}}` |
| **Tausendertrennzeichen** | `1{,}000` / thin space | `1\,000` (schmales Leerz.) | `\sisetup{group-separator}` |
| **Enumerations-2.-Ebene** | `(a) (b) (c)` | `a) b) c)` | `enumitem` `\setlist` |
| **Aufzählungszeichen** | `•` / `–` | `–` | `enumitem` (optional vereinheitlicht) |
| **Datum** | `June 1, 2026` | `1.\ Juni 2026` | babel `\today` |
| **„z. B." / „e.g."** | e.g., i.e. | z.\,B., d.\,h. | Autor-seitig je Sprachdatei |
| **Abbildung/Tabelle/Kapitel** | Figure/Table/Chapter | Abbildung/Tabelle/Kapitel | babel + KOMA automatisch |
| **Bibliografie-Stil** | `alpha` | `alphadin` | zihpub-Klasse automatisch (§3.2) |
| **Titel der Arbeit** | englischer Titel | deutscher Titel | `\ifthesisDE`-Verzweigung |
| **Selbständigkeitserklärung** | **immer Deutsch** | Deutsch | zihpub erzwingt `ngerman` (rechtlich) |

### 5.1 Präambel-Block (sprachabhängig)

```latex
\usepackage{csquotes}                 % \enquote{...} statt manueller Quotes
\ifthesisDE
  \sisetup{output-decimal-marker={,}, group-separator={\,}}
  \setlist[enumerate,2]{label=\alph*)}        % DE: a) b) c)
\else
  \sisetup{output-decimal-marker={.}, group-separator={,}}
  \setlist[enumerate,2]{label=(\alph*)}       % EN: (a) (b) (c)
\fi

% sprachabhaengiger Titel:
\ifthesisDE
  \title{Aktive cache-bewusste Hardware-Adaption:\texorpdfstring{\\}{ }%
         Eine Cache-Engine für Trie-basierte Indexstrukturen}
\else
  \title{Active Cache-Aware Hardware Adaptation:\texorpdfstring{\\}{ }%
         Cache Engine for Trie-Based Index Structures}
\fi
```

> **Konvention für Autoren:** Im Fließtext **immer** `\enquote{…}` für Anführungszeichen und
> `\num{…}` / `\SI{…}{…}` (siunitx) für Zahlen/Einheiten verwenden — dann sind Quotes und
> Dezimal-/Tausendertrennzeichen **automatisch** sprachkorrekt, ohne manuelle Eingriffe.

---

## 6. Build-Workflow

### 6.1 Lokal (Windows, MiKTeX)

```powershell
# Standard = Englisch:
pwsh -File build.ps1
# Explizit:
pwsh -File build-en.ps1     # erzwingt EN  -> diplomarbeit-en.pdf
pwsh -File build-de.ps1     # erzwingt DE  -> diplomarbeit-de.pdf
```

`build-de.ps1` ruft pdflatex mit CLI-Override und eigenem Jobname auf:
```powershell
pdflatex -interaction=nonstopmode -jobname=diplomarbeit-de "\def\thesislang{de}\input{diplomarbeit.tex}"
bibtex   diplomarbeit-de
pdflatex -interaction=nonstopmode -jobname=diplomarbeit-de "\def\thesislang{de}\input{diplomarbeit.tex}"
pdflatex -interaction=nonstopmode -jobname=diplomarbeit-de "\def\thesislang{de}\input{diplomarbeit.tex}"
```
→ EN und DE erzeugen **getrennte PDFs** (`diplomarbeit-en.pdf` / `diplomarbeit-de.pdf`) und
getrennte Aux-Dateien (kein gegenseitiges Überschreiben dank `-jobname`).

### 6.2 Overleaf

Overleaf erlaubt keinen CLI-`\def`. Dort wird der Schalter über **eine Zeile** gesetzt:
- entweder die Zeile `\providecommand{\thesislang}{en}` in `diplomarbeit.tex` auf `{de}` ändern,
- oder die ausgelagerte `config/language.tex` (eine Zeile) tauschen.
Danach „Recompile". (Empfehlung: für die Abgabe pro Sprache ein eigener Overleaf-Snapshot.)

---

## 7. Übersetzungs-Workflow (EN → DE)

1. **EN ist Source-of-Truth.** Inhalt wird in `kapitel/en/*.tex` geschrieben.
2. Übersetzung erzeugt das deutsche Pendant `kapitel/de/*.tex` (mit Claude Code), **gleiche
   Struktur, gleiche `\label`-Anker, gleiche `\ref`/`\cite`** — nur der Fließtext wird übersetzt.
3. `\label`/`\ref`/`\cite`/`\input{tikz/…}` bleiben **identisch** in beiden Sprachen → Querverweise,
   Zitate und Mess-Grafiken funktionieren in beiden Fassungen ohne Mehraufwand.
4. **Nicht zu übersetzen:** Code-Identifier, Dateinamen, `\texttt{}`-Bezeichner, Eigennamen,
   Mess-Artefakte.

---

## 8. Wartung & Synchronität

- Änderungen am Inhalt **zuerst in `en/`**, dann `de/` nachziehen (übersetzen).
- `\label`-Schema sprachunabhängig halten (z. B. `ch:intro`, `sec:motivation`) — **nicht** je
  Sprache umbenennen, sonst brechen Querverweise in der jeweils anderen Fassung.
- Gemeinsame Artefakte (`literatur.bib`, `tikz/`, `tabellen/`) **nie** duplizieren.
- Beim Hinzufügen eines Kapitels: in `en/` **und** `de/` eine Datei gleichen Basisnamens anlegen
  (sonst schlägt der `\include` in der fehlenden Sprache fehl).

---

## 9. Umsetzungsschritte (dieser Arbeitsblock)

1. `config/` + `kapitel/en` + `kapitel/de` + `anhang/en` + `anhang/de` anlegen.
2. `diplomarbeit.tex` um Schalter + `\ifthesisDE`-Konventionsblock + sprachgetrennte `\include`s
   erweitern; `csquotes` ergänzen.
3. Bestehende (bereits englische) Kapitel-/Anhang-Stubs nach `kapitel/en` bzw. `anhang/en`
   überführen; deutsche Platzhalter-Dateien in `…/de` anlegen.
4. `build-en.ps1` + `build-de.ps1` erstellen; `build.ps1` = EN-Default.
5. Verifizieren: **beide** Builds (`-en`, `-de`) bauen fehlerfrei (Baseline mit Stubs).
6. Inhalts-Migration (DE→EN) in `kapitel/en/` fortsetzen.

---

## 10. Offene Punkte / Empfehlungen

- **Deutscher Titel**: derzeit Platzhalter-Übersetzung (§5.1) — vom Autor final festzulegen.
- **Hyphenation/Trennung**: babel lädt je Sprache die korrekten Trennmuster automatisch; bei
  Bedarf `\hyphenation{…}` pro Sprachdatei.
- **`csquotes`-Stil**: Standard ist babel-gesteuert; bei Sonderwünschen
  `\setquotestyle{german}/{american}` explizit pro Modus.
- **Abgabe**: Welche Sprache ist die einzureichende? (EN vermutlich primär — final klären.)
- **glossaries/Akronyme**: Falls später ein Akronym-/Symbolverzeichnis genutzt wird, sind die
  Definitionen ebenfalls sprachabhängig zu halten (analoge `\ifthesisDE`-Struktur).
