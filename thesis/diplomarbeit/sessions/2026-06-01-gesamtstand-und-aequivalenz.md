# Gesamtstand der Diplomarbeit-Struktur + Äquivalenz-Prinzip (EN ≡ DE)

**Datum:** 2026-06-01
**Verzeichnis:** `C:\Users\benja\OneDrive\Desktop\Diplomarbeit - Datenbanken\thesis\diplomarbeit\`
**Zweck:** Vollständige Dokumentation des aktuellen Standes der gesamten Arbeit, mit
besonderem Fokus auf das **Äquivalenz-Prinzip** zwischen englischer (primärer) und
deutscher (sekundärer) Fassung.

**Status (Sessionsabschluss 2026-06-01):** Struktur-Aufbau **abgeschlossen** und committet
(`5131afc`, nur `thesis/`, kein Push). EN- und DE-Fassung sind **inhaltlich äquivalent** und
bauen fehlerfrei (je 48 Seiten, je 8 Quellen, 0 Fehler).
**➡️ Übergabe:** Ab hier schreibt der Autor den Inhalt **manuell** weiter — zuerst in
`kapitel/en/` (Source-of-Truth), die deutsche Fassung in `kapitel/de/` nachziehen (Workflow §7).

---

## 0. KERNPRINZIP: Englische und deutsche Fassung MÜSSEN äquivalent sein

> **Verbindliche Regel (User-Direktive 2026-06-01):** Die englische und die deutsche
> Fassung der Diplomarbeit sind **inhaltlich exakt äquivalent**. Die englische Fassung ist
> das **Original / Source-of-Truth**; die deutsche ist eine **vollständige, treue
> Übersetzung** desselben Inhalts. Es darf **keine** inhaltliche Divergenz geben.

**Was „äquivalent" konkret bedeutet:**

| Element | EN-Fassung | DE-Fassung | Identisch? |
|---|---|---|---|
| Kapitel-/Abschnitts-Struktur | `kapitel/en/*.tex` | `kapitel/de/*.tex` | **Ja** (gleiche Reihenfolge, gleiche Abschnitte) |
| `\label`-Anker | `ch:intro`, `sec:motivation`, … | dieselben | **Ja** (sprachneutral) |
| `\ref`/`\cite`-Verweise | `\cite{leis2013art}`, … | dieselben | **Ja** |
| Bibliografie-Einträge | aus `literatur.bib` | aus **derselben** `literatur.bib` | **Ja** (geteilt) |
| Tabellen-/Abbildungs-Daten | `tikz/`, `tabellen/` | **dieselben** Dateien | **Ja** (geteilt) |
| **Fließtext** | Englisch | Deutsch (Übersetzung) | nur **hier** verschieden |
| Bib-**Stil** | `alpha` ([LKN13]) | `alphadin` (DIN) | Stil verschieden, **Einträge gleich** |
| Anführungszeichen / Zahlen | `"…"` / `3.14` | `„…"` / `3{,}14` | Sprachkonvention (gleiche Inhalte) |

Nur **Fließtext-Sprache**, **Bib-Stil** und **Typografie-Konventionen** unterscheiden sich
— **niemals** der Inhalt, die Struktur, die Quellen oder die Verweise.

---

## 1. Warum die DE-Fassung aktuell „leer" wirkt (Auflösung des Bib-Missverständnisses)

Die Bibliografie ist **nicht** je Sprache getrennt. `literatur.bib` (derzeit 8 Tier-1-Quellen)
liegt **einmal** im Projekt und wird von **beiden** Builds genutzt. Das deutsche
Literaturverzeichnis ist momentan nur deshalb leer, weil die **deutschen Kapitel noch
Platzhalter** sind (nur `\chapter{…}` + `\label`, ohne übersetzten Text und damit ohne
`\cite`). BibTeX nimmt nur tatsächlich zitierte Einträge ins Verzeichnis auf — ohne `\cite`
bleibt es leer, **obwohl** die `.bib` vollständig ist.

**Sobald die deutschen Kapitel übersetzt sind** (mit denselben `\cite`-Befehlen wie im
Englischen), füllt sich das deutsche Literaturverzeichnis automatisch mit **denselben**
Quellen — im `alphadin`-Stil. Damit ist die Äquivalenz hergestellt.

---

## 2. Verzeichnisstruktur (Stand 2026-06-01)

```
thesis/
├── ZIHLatexVorlage/             ← ORIGINAL-Vorlage, UNVERÄNDERT (Referenz)
├── ZIH-FRAMEWORK-REFERENZ.md    ← Framework-Befehlsreferenz + Bug-Tabelle
├── (Alt-Entwurf: main.tex, chapters/ — scrreprt, zu verwerfen)
└── diplomarbeit/                ← die format-konforme Diplomarbeit (Arbeitskopie)
    ├── diplomarbeit.tex         ← Hülle: Sprach-Schalter + Präambel + \include (single source)
    ├── config/language.tex      ← Schaltzeile \thesislang (en|de)
    ├── zihpub.cls               ← Vorlagen-Kopie + 3 Bugfixes
    ├── alphadin.bst, plaindin.bst, alpha.bst, zih_logo_*, Makefile
    ├── literatur.bib            ← GETEILT (sprachneutral), 8 Quellen
    ├── build.ps1                ← Build EN+DE (param -Lang)
    ├── kapitel/en/  01..08      ← ENGLISCH = Original (vollständig migriert)
    ├── kapitel/de/  01..08      ← DEUTSCH = Übersetzung (derzeit Platzhalter → wird gefüllt)
    ├── anhang/en/   A..E
    ├── anhang/de/   A..E         ← Übersetzung (Platzhalter → wird gefüllt)
    ├── tikz/  tabellen/         ← GETEILT (Mess-Artefakte, sprachneutral)
    └── sessions/                ← Konzept-/Stand-Doku (diese Datei + Schalter-Doku)
```

**Single Source (geteilt, NIE dupliziert):** `diplomarbeit.tex`, `zihpub.cls`, `*.bst`,
`literatur.bib`, `tikz/`, `tabellen/`, Build-Skripte, Logos.
**Sprachgetrennt (nur Fließtext):** `kapitel/{en,de}/`, `anhang/{en,de}/`.

---

## 3. Der Sprach-Schalter (Kurzfassung; Details: bilingualer-compile-schalter.md)

`\thesislang` (`en`/`de`) steuert: bedingte Klassen-Option `german`
(`\PassOptionsToClass`), sprachgetrennte `\include{kapitel/\thesislang/…}`, und über
`\ifthesisDE` die Konventionen (csquotes, siunitx-Dezimaltrenner, enumitem-Labels, Titel,
Institution). Build: `build.ps1 -Lang en|de` → `diplomarbeit-en.pdf` / `diplomarbeit-de.pdf`.

---

## 4. Behobene Vorlagen-Bugs (in `diplomarbeit/zihpub.cls`; Original bleibt unverändert)

1. `abstracton` → `abstract=true` (KOMA-Deprecation; behebt zugleich `version=first`).
2. Römische Titelei (`\pagenumbering{roman}` in beiden `\AtBeginDocument`) gegen die
   hyperref-`page.x`-Kollision.
3. `\@mkboth{Acknowledgments}{}` (fehlendes 2. Argument — Fehler **nur** im EN-Modus mit
   Danksagung: „! Extra \fi").
4. `\texorpdfstring{\\}{ }` im Titel (Zeilenumbruch im PDF-String).

Alle per Build verifiziert. Verbleibend nur die bewusst belassene `fancyhdr`-Empfehlung
und ein harmloser `xcolor`-Hinweis.

---

## 5. Build-Status (MiKTeX lokal, verifiziert 2026-06-01)

| Build | Quelle | Seiten | Fehler | Undefined | Bib |
|---|---|---|---|---|---|
| `build.ps1 -Lang en` | `kapitel/en` (voll) | 48 | 0 | 0 | 8 (`alpha`) |
| `build.ps1 -Lang de` | `kapitel/de` (übersetzt) | 48 | 0 | 0 | 8 (`alphadin`) |

→ **Äquivalenz erreicht:** beide Fassungen 48 Seiten, je 8 Bib-Einträge (EN `alpha`, DE
`alphadin`), 0 Fehler, 0 ungelöste Verweise. Verbleibend nur die bewusst belassene
`fancyhdr`-Empfehlung + der harmlose `xcolor`-Hinweis.

---

## 6. Inhaltlicher Stand der Kapitel

| Kapitel | EN (`kapitel/en`) | DE (`kapitel/de`) |
|---|---|---|
| 01 Introduction / Einleitung | **migriert** | **übersetzt** |
| 02 Fundamentals / Grundlagen | **befüllt** | **übersetzt** |
| 03 State of the Art / Stand der Technik | **migriert (inkl. Tabellen)** | **übersetzt (inkl. Tabellen)** |
| 04 Concept & Architecture / Konzept & Architektur | **migriert** | **übersetzt** |
| 05 Implementation / Implementierung | **migriert (Sprint-Logs entfernt)** | **übersetzt** |
| 06 Evaluation Methodology / Evaluationsmethodik | **migriert** | **übersetzt** |
| 07 Results / Ergebnisse | **migriert (Platzhalter f. Messdaten)** | **übersetzt** |
| 08 Conclusion / Fazit | **migriert** | **übersetzt** |
| A–E Anhänge | Stubs (Überschrift + `\label`) | Stubs (identische `\label`) |

> Alle acht Kapitel liegen in **beiden** Sprachen mit identischen `\label`/`\cite`/`\ref`-Ankern
> vor (EN ≡ DE). Der eigentliche Fließtext ist als migrierter Blindentwurf vorhanden und wird
> vom Autor inhaltlich ausgearbeitet; die Anhänge A–E warten auf Inhalt (Messdaten, Glossar,
> Matrizen) in beiden Sprachen.

Quelle der Migration: der deutsche Blindentwurf in `thesis/chapters/` (7 Kapitel),
übersetzt ins Englische und von 7 auf 8 Kapitel umgegliedert (Grundlagen ausgegliedert,
Sprint-Changelog entfernt). Achsen-Anzahl durchgängig **14** (N-Phase).

---

## 7. Workflow zur Wahrung der Äquivalenz

1. **Inhalt zuerst in `kapitel/en/`** schreiben/ändern (Source-of-Truth).
2. Deutsche Übersetzung in `kapitel/de/` mit **gleichem Dateinamen** nachziehen: nur
   Fließtext + Überschriften + Tabellen-Captions übersetzen; `\label`, `\ref`, `\cite`,
   `\input{tikz/…}` **unverändert** übernehmen.
3. **Nicht übersetzen:** Code-Identifier, Dateinamen, `\texttt{}`-Bezeichner, Eigennamen,
   Mess-Artefakte.
4. Beide Builds (`-Lang en`, `-Lang de`) müssen fehlerfrei bauen und **dieselben** Quellen
   im Literaturverzeichnis zeigen.
5. Beim Hinzufügen/Ändern eines Kapitels: **immer** EN **und** DE gleichziehen.

---

## 8. Stand der Punkte

**Erledigt (Sessionsabschluss 2026-06-01):**
- ✅ DE-Übersetzung aller 8 Kapitel — EN ≡ DE hergestellt und per Build verifiziert.
- ✅ Alt-Entwurf nach `thesis/_archiv_entwurf1/` archiviert; verwaiste `diplomarbeit/kapitel/*.tex`
  + `anhang/*.tex` entfernt; nur `kapitel/{en,de}` + `anhang/{en,de}` aktiv.
- ✅ Committet (`5131afc`, 38 Dateien, nur `thesis/`, ohne Build-Artefakte, **kein Push**).

**Offen — vom Autor beim manuellen Weiterschreiben beizusteuern:**
- Inhaltliche Ausarbeitung des Fließtextes (zuerst `kapitel/en/`, DE nachziehen).
- Sperrvermerk-Wortlaut, Aufgabenstellungs-PDF, Danksagung, EN-Abstract + DE-Kurzfassung,
  deutscher Titel (Platzhalter sind im Quelltext markiert).
- Mess-Artefakte (`tikz/`, `tabellen/`) aus `messung_driver` einspeisen (Kap. 07).
- Optional: Betreuer-Label „Tutor:" → „Advisor:" (EN, dokument-seitig).

> **Hinweis für Folge-Sessions:** `git rm` und `Remove-Item` auf dem OneDrive-Pfad sind
> sandbox-blockiert (auch mit Override). Zum Entfernen aus dem Index `git restore --staged`
> nutzen und mit `git commit` **ohne** Pathspec committen (ein Pathspec committet sonst den
> Working Tree inkl. ignorierter Artefakte).
