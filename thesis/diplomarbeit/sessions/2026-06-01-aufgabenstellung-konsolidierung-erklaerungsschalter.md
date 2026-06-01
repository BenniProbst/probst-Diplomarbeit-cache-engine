# Aufgabenstellung-Konsolidierung + Erklärungs-Sprachschalter (2026-06-01)

## Ziel (User-Direktiven dieser Session)
1. **Aufgabenstellung konsolidieren** aus `docs/termine` (Termin 1-9) bzgl. des
   Diplomarbeit-Projekts und gegen die **GESAMTE Architektur + Sessions**.
2. **Selbständigkeitserklärung:** separater Sprach-Schalter `de | en | same_as_document`
   (Default `same_as_document` = folgt Dokumentsprache).
3. **Tier/Organ-Metapher** (Suchalgorithmus = „Tier", Achse = „Organ") in Abstract +
   Kapitel 1 + Aufgabenstellung verankern; ermitteln, welche Achsen existieren und welche
   **cache-line-aware relevant** sind; begründen, warum **vollständig permutativ** gemessen
   werden muss.
4. ZIP neu bauen (erst danach lädt der Autor hoch).

## Quellen der Konsolidierung
- **Termine** (`docs/termine/_extracted_text/`): Exposé „CPU-only cache-line-aware
  Präfixindex" + technische Skizze (PRT-ART als Kombination CoCo/ART/START/HOT/Masstree/
  CSS/CSB+/B²); Termin 7/8: Drei-Repo-Architektur, 3 Pflicht-Messreihen A/B/C, 30 SOTA- +
  10 Allokator-Profile, F15-Bausteine-Permutation, 1800+ Permutationen.
- **Architektur** (`docs/architektur/14_achsen_komposition_organ_metapher.md`): autoritative
  Tier/Organ-Metapher (Säugetier-Anatomie, „genetisches Experiment", schnellstes Tier =
  F15-Ziel). `docs/bausteine/07_bausteine_matrix_N_erweitert.md` + `kapitel/04`: 14 Haupt-
  achsen + ~30 Sub-Achsen; Traversal 3.A→3.B→3.M als cache-line-zentrale Übersetzung.

## Umgesetzt

### 1. Aufgabenstellung (bilingual, `aufgabenstellung/{en,de}.tex`)
Konsolidierte Themenstellung mit Abschnitten: Kontext/Motivation, Zielsetzung,
**Methodischer Ansatz (Tier/Organ-Metapher)**, **Bausteinachsen + Cache-Line-Relevanz**
(14 Achsen aufgelistet, cache-line-relevante markiert: Node-Type, Memory-Layout,
Traversal 3.B/3.M, Allocator NUMA/Huge-Page, Prefetch, ISA, Hardware-Strategie),
**Warum vollständige Permutation** (Achsen-Interaktion, keine Isolation, >10¹¹),
6 Teilaufgaben (inkl. cache-line-Identifikation + schnellste Komposition je Lastmuster),
Methodik/Evaluation, Umfangsabgrenzung. EN = Original, DE = treue Übersetzung.

### 2. Einbau-Mechanismus (`zihpub.cls` + `diplomarbeit.tex`)
- Neues Klassen-Feld `\aufgabenstellung{...}`: ersetzt den Platzhalter „Insert the
  official thesis assignment here!" / „Hier Aufgabenstellung einfügen!", wenn gesetzt
  (sonst Platzhalter-Fallback erhalten).
- `diplomarbeit.tex`: `\ifthesisDE\aufgabenstellung{\input{aufgabenstellung/de}}\else\aufgabenstellung{\input{aufgabenstellung/en}}\fi`.

### 3. Selbständigkeitserklärung-Sprachschalter
- Neuer `\declarationlang` = `de | en | same_as_document` (Default; in `diplomarbeit.tex`
  via `\providecommand`, daher auch per CLI überschreibbar).
- `zihpub.cls`: neuer `\if@declde`, berechnet aus `\declarationlang` + `\if@german`
  (robust gegen `\long`-`\ifx`-Bug via `\edef`-Normalisierung). Erklärung (Überschrift,
  Einleitung, Schlusssatz, „den"/Datum, „Mat.-Nr."/„Mat.-No.", `\selectlanguage` für
  Datum/Trennung) folgt jetzt `\if@declde` statt `\if@german`.
- **Geburtsdatum** zweiformatig (`\birthdateDE` „11.~April 1996" / `\birthdateEN`
  „11~April 1996"): Titelseite folgt `\thesislang`, Erklärung folgt `\declarationlang`
  → korrektes Format auch im gemischten Fall.

### 4. Tier/Organ-Metapher verankert
- Abstract (`\abstracten`/`\abstractde`) + Kapitel 1 (`kapitel/{en,de}/01`): je ein Satz/
  Absatz „Suchalgorithmus = Tier, Achsen = Organe, Permutation = genetisches Experiment,
  Ziel = schnellstes Tier".

## Verifikation (MiKTeX lokal, alle Builds 48 S, 0 Fehler, 0 undefinierte Makros)
| Test | Ergebnis |
|---|---|
| EN-Build (same_as_document) | Aufgabenstellung EN (2 S), Erklärung EN „Statement of Authorship" |
| DE-Build (same_as_document) | Aufgabenstellung DE (2 S), Erklärung DE „Selbstständigkeitserklärung" |
| EN-Dok + `declarationlang=de` | Erklärung DEUTSCH, „geboren am 11. April 1996", „Dresden, den 1. Juni 2026"; Titel/Inhalt EN |
| DE-Dok + `declarationlang=en` | Erklärung ENGLISCH, „born on 11 April 1996", „Dresden, June 1, 2026"; Titel/Inhalt DE |

## Overleaf
`thesis/diplomarbeit-overleaf.zip` neu (jetzt inkl. `aufgabenstellung/{en,de}.tex`;
30 `.tex`, ~180 KB, flache Root-Struktur, `config=en`).

## Offen / rechtlich
- **EN-Selbständigkeitserklärung** weiterhin mit Habich/Prüfungsamt verifizieren (ggf.
  rechtsverbindlich deutsch → `\declarationlang{de}` setzen).
- Offizielles Aufgabenstellungs-PDF kann die konsolidierte Fassung ersetzen (Feld leeren →
  Platzhalter, oder PDF via `\includepdf` einbinden).
- Danksagung, Sperrvermerk, Mess-Artefakte (`tikz/`+`tabellen/`) weiterhin Autor-Beitrag.
