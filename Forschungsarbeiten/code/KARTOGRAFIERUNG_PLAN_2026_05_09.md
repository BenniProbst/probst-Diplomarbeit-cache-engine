# Kartografierungs-Plan — Systematische Strukturierung aller 33 Code-Quellen

**Phase 4.B-detail · OPEN-1** · TU Dresden Diplomarbeit PRT-ART
**Stand:** 2026-05-09
**Architekt-Auftrag (2026-05-09):** "Wir muessen wohl alle 33 Code Quellen systematisch durchsuchen und für jede erstmal deren Struktur kartografieren, damit wir deren Code klassifiziert in Aspekte zerlegen können."

## Ziel

Systematische **Bausteine-Klassifikation** pro Quelle:
1. **Code-Struktur** kartografieren (Verzeichnisse, Source-Files, LOC, Build-System)
2. **Code-Kommentare** auswerten (Compiler-Anforderungen, Plattform-Hinweise, ueber Pseudocode hinausgehende Implementierungs-Details)
3. **Aspekte zerlegen** in unsere 11 Bausteine-Achsen (Page / Node / Traversal / ValueHandle / MemoryLayout / Allocator / Prefetch / Concurrency / ISA / Measurement / Telemetry-Strategy)
4. **Code-Qualitaet bewerten** (Habich H2: Quelle/Ziel/Aenderungs-Beschreibung pro Adapter)

## Drei Klassen von Quellen

### Klasse A — 12 geklonte Originalcode-Repos (`ext/<paper>/<repo>/`)

| P-ID | Repo | Status |
|------|------|--------|
| P01 | unodb (laurynas-biveinis/unodb) | ✅ geklont, Apache-2.0 |
| P02 | hot (speedskater/hot) | ✅ geklont, ISC |
| P03 | masstree-beta (kohler/masstree-beta) | ✅ geklont, MIT |
| P04 | CoCo-trie (aboffa/CoCo-trie) | ✅ geklont, GPL-3.0 (Architekt-Direktive: OK) |
| P05 | START (jungmair/START) | ✅ geklont, MIT |
| P06 | b2-tree-master + bart-master | ✅ erhalten 2026-05-08 (PENDING LICENSE) |
| P07 | wormhole (wuxb45/wormhole) | ✅ geklont, GPL-3.0 |
| P10 | SuRF (efficient/SuRF) | ✅ geklont, Apache-2.0 |
| P20 | leanstore (B-Trees Are Back) | ✅ geklont, MIT |
| P25 | hpides/prefetching | ✅ geklont, NO LICENSE |
| P29 | userspace-rcu | ✅ geklont, LGPL-2.1 (nur Konzept-Quelle, F2-Beschluss) |
| P30 | huangjiahua/haz_ptr | ✅ geklont, NO LICENSE (NICHT genutzt — F12-K) |

**Pro Repo eine `STRUKTUR_NOTIZ.md` mit:**
- Verzeichnis-Hierarchie (find-Output)
- Source-Files-Inventar mit LOC-Summary
- Build-System (CMakeLists / Makefile)
- README + LICENSE Zusammenfassung
- **Bausteine-Klassifikation:** welche Source-Files implementieren welche Bausteine-Achse?
- **Code-Qualitaets-Bewertung:** Habich-Skala 1-5 (★) + Begruendung
- **Compiler-Anforderungen:** aus README/CMake/CI ablesbar
- **Adapter-Strategie:** wie binden wir das via `adapters/<paper>/<file>.hpp`?

### Klasse B — 14 LEGACY_REIMPL (kein Originalcode, Skelett vorhanden)

| P-ID | Paper | Status |
|------|-------|--------|
| P11 | CSS-tree (Rao/Ross 1999) | Skelett `prt_art/legacy_reimpl/P11-CSS-tree/` |
| P12 | CSB+-tree (Rao/Ross 2000) | Skelett |
| P13 | Hankins (2003) | Skelett |
| P14 | Samuel CSB-Conscious (2005) | Skelett |
| P16 | Bender Tree Layout (2002) | Skelett |
| P17 | Bender Cache-Oblivious (2005) | Skelett |
| P18 | Saikkonen Multi-Level (2008) | Skelett |
| P19 | Saikkonen Layout-Invariant (2016) | Skelett |
| P21 | Chen Prefetching B+ (2001) | Skelett |
| P22 | Chen Fractal (2002) | Skelett |
| P23 | Khan Adaptive Prefetch (2010) | Skelett |
| P24 | NaderanTahan (2016) | Skelett |
| P26 | Q. Zhang FGCS Prefetch (2024) | Skelett (Email verschickt) |
| P27 | T. Zhang ASPLOS Hierarchical (2025) | Skelett (Email verschickt, BSD-3-Clause Repo gem5-fork) |

**Pro Skelett bereits eine README.md vorhanden** (durch Task #72 generiert). Erweitere um:
- **Pseudocode-Auszug** aus dem Originalpaper (Re-Impl-Plan)
- **Zugewiesene Bausteine-Achse(n)** — bereits in Skelett-README erwaehnt
- **Code-Qualitaets-Bewertung:** entfaellt (kein Code), aber Paper-Klarheit ★ 1-5

### Klasse C — 5 INSTITUTION_INTERN + 2 ORIGINALPAPER-KONZEPT

| P-ID | Status |
|------|--------|
| P28 | Kuehn Code zugesagt — wartet auf Download-Link nach Aufraeumen |
| P31 | Habich Direktanfrage — Antwort offen |
| P32 | Habich Direktanfrage — Antwort offen |
| P33 | Habich Direktanfrage — Antwort offen |
| P09 | Jacobson 1989 LOUDS — Originalpaper-Konzept, kein Code (SDSL als Drittanbieter-Inspiration via F3-C++23-Portierung) |
| P15 | Graefe Survey 2001 — kein Code, nur Survey-Konzepte |

**Pro Quelle:** Verweis-Eintrag in zentralem Inventar (kein STRUKTUR_NOTIZ.md noetig vor Erhalt).

## Werkzeug-Direktive

**KEIN PYTHON** — Voranalyse via Bash (`find`, `wc`, `grep`, `head`).

## Vorgehen Klasse A (12 geklonte Repos)

**Schritt 1: Voranalyse-Skript** (`_voranalyse_klasse_a.sh`)
   - Pro Repo: Verzeichnis-Hierarchie, Source-File-Liste, LOC, Top-Level-README-Zeilen,
     LICENSE-Erkennung, CMakeLists/Makefile-Erkennung
   - Output: `_voranalyse_output_klasse_a/<repo>.txt`

**Schritt 2: Pro Repo manuelle STRUKTUR_NOTIZ.md** (12 Dokumente)
   - Lese Voranalyse-Output + README + Top-Level-Code-Files
   - Klassifiziere Bausteine (welche Datei → welche Achse)
   - Code-Qualitaets-Bewertung
   - Adapter-Strategie

**Schritt 3: Konsolidiertes Inventar** (`STRUKTUR_NOTIZ_UEBERSICHT.md`)
   - Tabellarische Zusammenfassung aller STRUKTUR_NOTIZ.md
   - Cross-Reference Bausteine ↔ Repo

## Vorgehen Klasse B (14 LEGACY_REIMPL)

**Schritt 1: Pseudocode-Extraktion-Plan**
   - Pro Paper das Originalpaper-PDF lesen, Pseudocode-Sektionen identifizieren
   - In bestehende `prt_art/legacy_reimpl/<paper>/README.md` ergaenzen

**Schritt 2: Klarheits-Bewertung** (★ 1-5 fuer Paper-Pseudocode-Klarheit)

## Vorgehen Klasse C (Institution-Intern + Konzept)

**Schritt 1: Verweis-Eintrag** im zentralen Inventar
**Schritt 2:** Bei Code-Erhalt → in Klasse A einsortieren

## Lieferung dieser Aufgabe (Task #108)

| Lieferung | Aufwand |
|-----------|---------|
| Plan-Dokument (dieses) | ✅ |
| Voranalyse-Skript Klasse A (sh + bat) | ~30 Min |
| Voranalyse-Output Klasse A (12 Repos) | ~10 Min Laufzeit |
| 12 × STRUKTUR_NOTIZ.md (Klasse A) | je ~15 Min, total ~3 h |
| 14 × Erweiterung der Skelett-READMEs (Klasse B) | je ~10 Min, total ~2.3 h |
| Konsolidiertes UEBERSICHT.md | ~30 Min |

**Gesamt:** ca. 6.5 Stunden Detail-Arbeit, davon ein Grossteil Lese- und Analysearbeit pro Quelle.

## Iterations-Strategie in dieser Konversation

Da die Vollstaendigung mehrere Stunden dauert, gehe ich iterativ vor:
1. ✅ Plan-Dokument (jetzt)
2. ✅ Voranalyse-Skript + Voranalyse-Output (jetzt)
3. ✅ Erste 3 STRUKTUR_NOTIZ.md (P01 unodb, P02 hot, P03 masstree-beta) als Beispiel-Form
4. Restliche 9 STRUKTUR_NOTIZ.md iterativ (in Folge-Schritten oder kann der User auch
   einzelne anstoßen)
5. Klasse B + Klasse C in spaeteren Iterationen

## Bezug zu anderen Tasks

- **Task #80** (STRUKTUR_NOTIZ.md pro Repo) wird durch dies erfuellt
- **Task #79** (Adapter-Skelette) wartet auf diese Kartografierung
- **Task #101** (Code-Qualitaets-Bewertung pro Bausteine-Quelle, Habich H2) faedelt sich
  in jede STRUKTUR_NOTIZ.md ein
