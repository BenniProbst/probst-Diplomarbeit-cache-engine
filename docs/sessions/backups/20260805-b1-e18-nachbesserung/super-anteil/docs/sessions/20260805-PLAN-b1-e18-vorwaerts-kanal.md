# B1 / E-18 -- LaTeX-Anhang-VORWAERTS-Kanal je CI (Bau-Session 2026-08-05)

> **Stand:** gebaut + am Fixture bewiesen, **NICHT gepusht/gemerged** (Lead-Sache nach Dual-Review;
> Scharfschaltung erst nach Lebend-Check). Basis super `d08f5dde` (development), ce `b4110cd0` (Gate 405).
> **NACHBESSERUNGS-Welle 05.08. (FABLE-B-1..B-4 + CODEX-MAJOR/MINOR):** hinzugefuegte Zeilen
> ASCII-only; Zahlen am Objekt nachgezaehlt; PDF-Gate-Geltungsbereich als deklarierte Grenze im
> Kopf des Kerns; Korpus-Zweig-Zusicherung auf den belegbaren Ist zurueckgenommen (s. Sec-6.4).
> `.gitlab-ci.yml` ist seit `94f960dd` unbewegt -- `git apply --check` gegen den aktuellen
> development-HEAD `7d468505` ist gruen (RC=0).

## 1. Auftrag und SOLL (Owner-Dekret, nicht abgeleitet)

- **Ledger Sec-68c (26.07., Owner):** "E-18 = LaTeX-Anhang-VORWAERTS-Kanal je CI (= HAUPT-ZIEL des
  Gesamt-Systems). Beide [E-04+E-18] sind als eigene Bau-Pakete VOR dem Voll-Bau-4-Trigger einzuplanen."
- **Owner verbatim nr529:** "Das Generieren der Latex-Anhaenge im Diplomarbeit-Code ist HAUPT-ZIEL des
  Gesamt-Systems und kombiniert das automatische Erstellen der Ergebnisse in die Diplomarbeit-PDF mit
  Auswertungsautomatisierung aus der xml-Kette bis zu den fertigen Ergebnissen." -- **nr541:** "Ja B1/B2
  auto befuellen bzw. bei jedem CI neu setzen".
- **Ist vor diesem Paket:** die CI regeneriert die `.tex` NUR als Artefakt (`measure:smoke` /
  `measure:golden-320` -> `Code/measure_out*/appendix/`). Push nach 289, eigenes Write-Token und
  Post-measure-Rebuild fehlten. Weg A (`\InputIfFileExists`-Wiring in `A_measurements.tex`) ist seit
  GO-1/INC-7 komplett; offen war Weg B = die Auto-Befuellung.

**Abgrenzung (NICHT E-18):** E-04/B2 (CI-Live-Fortschritt + Interface-Nachtests); B12-xlsx;
B5 T6-Einsammel-Naht (Grandchild-CSV; E-18 dockt an der persistierten Ebene an); G8 Anhang-B/E-Prosa
(Owner-Content); M-CE-18 (`ce tools/latex_anhang`: Deprecate-KANDIDAT, je-GO, Aufraeumpass-Liste --
**nicht tot**: `tools/CMakeLists.txt:4` baut es im Default-Build und `tests/unit/CMakeLists.txt:278-280`
haengt den aktiven Test `test_latex_anhang` daran; Grund fuer den Kandidaten-Status ist allein, dass
es nicht im Produktions-/Forward-Pfad liegt).

## 2. Gebaut

| Teil | Datei | Inhalt |
|------|-------|--------|
| S3 | **NEU** `ci/anhang_forward_core.sh` | Kern: Quellen-Kaskade, WIDE-Aggregat, Whitelist-Kopie, Idempotenz, **PDF-Gate**, Commit, Push mit MERGE-Retry. env-parametrisiert + DRY-RUN-faehig. |
| S1 | `.gitlab-ci.yml` | **NEU** Job `anhang:forward` (Stage `persist`, hinter `persist:measurements`, vor `planer:delegate`): Credentials, 289-Klon, Kern-Aufruf, Gitlink-Bump auf 288. |
| S2 | `.gitlab-ci.yml` | Doku-Nachzug: `stages:`-Kommentar + Kopf des persist-Blocks nennen den Schwester-Kanal (sonst Doku-Luege). |
| S4 | dieses Dossier | Plan-/Beweis-Doku. |
| S5 | `Cluster/.../2026-08-05-DIPLOM-AN-INFRA-e18-289-thesis-writeback-token.md` | Infra-Handout: eigenes 289-Write-Token + CI-Vars + Branch-Protection-Check. |

**ce-Anteil:** 0 Code (der E-18-Kern liegt super+289). Die ce-Commits sind ausschliesslich eine
additive Abgrenzungs-Notiz im ce-Ledger (`07fc470d`), damit das Vier-Ledger-Audit (E-02) die Grenze
findet, plus deren Nachbesserung (`253bcd86`), die vier Ist-Behauptungen darin am Objekt korrigiert
(Kanal ist ENTWORFEN statt existent; Korpus-Zweig-Zusicherung zurueckgenommen; `tools/latex_anhang`
ist Kandidat, nicht "tot"; Pfad des Directors auf `libs/cache_engine/...` berichtigt).

## 3. Wie der Kanal arbeitet

1. **Quellen-Kaskade (deterministisch):** (a) frische Pipeline-Artefakte
   `Code/measure_out*/appendix/<lang>/tabellen/*.tex` in deklarierter Reihenfolge -- (b) sonst
   Regeneration aus dem **neuesten** `measurement/<RUN_TS>/`-Korpus (replace-Semantik) via
   `appendix_generator_cli` -- (c) sonst **honest-empty NO-OP** (exit 0, kein Commit).
   Damit greift "bei jedem CI neu setzen" auch OHNE frische Messung.
2. **Whitelist-Kopie** ausschliesslich nach `anhang/<lang>/tabellen/<name>.tex`; nie loeschen, nie
   ausserhalb; Namens-Wache gegen Pfad-/Sonderzeichen-Namen.
3. **Idempotenz:** `git diff --cached` -- ohne Byte-Delta kein Commit (kein Commit-Rauschen, kein Loop).
4. **PDF-Gate:** die Thesis-PDF wird im 289-Klon gebaut, BEVOR committet wird; rot => Rollback + Abbruch.
   Der Rollback nimmt **genau die Pfade** zurueck, die dieser Lauf angefasst hat (Buchfuehrung waehrend
   der Kopie) -- bewusst **kein** `git clean` ueber ein Verzeichnis, damit fremde unversionierte Dateien
   im Ziel niemals mitgerissen werden.
5. **Commit + Push** nach `development` **ohne** `ci.skip` -- die 289-Pipeline (lint + thesis-pdf de/en)
   IST der Post-measure-Rebuild. 289 triggert 288 nicht zurueck => kein Loop.
6. **Gitlink-Bump auf 288** mit dem vollen Dreifach-Loop-Schutz des Schwester-Jobs
   (`-o ci.skip` + `[skip ci]` + `_bot_`->never) und MERGE-Retry (kein rebase, kein `--force`).
7. **INERT-by-default** hinter `COMDARE_ANHANG_FORWARD == "true"` + `development`-only + `_bot_`->never.

## 4. Der Fund, der das Design geaendert hat (load-bearing)

Am Fixture mit den **echten** committeten D-03-Erstbeleg-CSV
(`measurement/20260726-164259-d03-strukt-r-erstbeleg/per_binary/*.result.csv`) hat sich gezeigt:

> Fuer eine Metrik **ohne** Messwerte schreibt der Generator trotzdem eine Heatmap, deren z-Matrix
> komplett `0.0000` ist (`lc_surface_op_erase_p50_ns.tex`, `mesh/cols=2`). pgfplots bricht daran
> **fatal** ab -- literal: `! Package pgfplots Error: Error using 'plot graphics': I got too few
> coordinates!` ... `Fatal error occurred, no output PDF file produced!` -- die Thesis-PDF entsteht
> **gar nicht** mehr (latexmk rc=12), waehrend derselbe Klon vor dem Kanal-Lauf sauber baut (rc=0).

Die 12 Kern-Tabellen haengen in `A_measurements.tex` an blankem `\input` (nur die 5 Darstellungs-`.tex`
an `\InputIfFileExists`) -- einzelne Dateien weglassen rettet also nichts. Ohne Gegenmassnahme haette
E-18 die PDF-Strecke **gerissen** statt sie zu schliessen. Antwort: das **PDF-Gate** im Kern
(alles-oder-nichts, fail-loud, Rollback). Die Ursache selbst -- fehlende honest-empty-Regel im
Flaechen-Writer der Stufe 05 -- ist ein **eigenes Folge-Paket** (s. Sec-6).

## 5. Beweise (literal, alle lokal, ohne neue Messung)

| ID | Beweis | Ergebnis |
|----|--------|----------|
| B-1 | `ctest` Stufe 08 (`fixtures/cached`) | `100% tests passed, 0 tests failed out of 7` |
| B-2/L1 | Korpus-Zweig E2E gegen Fixture-289 (file://-Remote) | `34 .tex` committet + gepusht, `OK: gepusht (Versuch 1)` |
| B-2/L2 | identische Wiederholung | `IDEMPOTENT: 0 Aenderungen -> kein Commit` (Generator byte-deterministisch) |
| B-2/L3 | leere Quelle | `NO-OP: keine Anhang-Quelle`, RC 0, kein Commit |
| B-2/L4 | Negativ-Pruefung | 6 Fremd-Dateien sha256-identisch; 0 Dateien ausserhalb `anhang/<lang>/tabellen/*.tex`; 0 Loeschungen; `kapitel/` unberuehrt |
| B-2/L5 | Artefakt-Zweig + 1-Byte-Delta | Quelle `kind=artefakt`, **genau 1** Datei committet |
| B-2/L6 | Korpus da, Generator fehlt | RC 1, fail-loud (kein stilles Gruen) |
| B-2/L7 | Namens-Wache | `..evil.tex` und `a b;rm -rf .tex` uebersprungen, 0 im Ziel |
| B-2/L8 | non-ff-Race (Fremd-Push auf den Remote) | `push abgelehnt -> fetch + MERGE (kein rebase)` -> `OK: gepusht (Versuch 2)`; Fremd-Prosa erhalten |
| B-3 | YAML | YAML-Load gruen (32 -> 33 Top-Level-Keys, alle Bestands-Jobs semantisch unveraendert, `stages`-Liste unveraendert); Inertness-Matrix 4x NICHT ERZEUGT / 1x ERZEUGT; Diff **0 entfernte**, **173 hinzugefuegte** Zeilen (2 stages-Kommentar + 6 persist-Kopf + 165 Job-Block) |
| B-4a | PDF-Gate ROT (D-03-Korpus, echter Thesis-Klon) | Abbruch RC 1, **0 Commits**, `Rollback: 10 neu angelegte Datei(en) wieder entfernt`, eine daneben liegende **fremde unversionierte** Datei sha256-identisch erhalten |
| B-4b | PDF-Gate GRUEN (bau-faehige Quelle) | `PDF-Gate GRUEN` in 14 s, genau 1 Datei committet, `diplomarbeit.pdf` 736.708 Bytes gebaut; unmittelbare Wiederholung = `IDEMPOTENT: 0 Aenderungen` |
| B-5 | **Lebend-Check** | **OFFEN** -- braucht das 289-Token (Infra-Handout S5) und eine getriggerte Pipeline. |

## 6. Offene Punkte / Folge-Pakete

1. **PDF-Gate-Ursache (neues Paket, super Stufe 05 `diagram_generator`):** der Flaechen-Writer muss
   honest-empty werden (keine Heatmap ohne Datenpunkte), analog zum bestehenden honest-empty der
   Darstellungs-Writer. Bis dahin schuetzt das PDF-Gate -- aber es bedeutet auch: **mit einem
   Teil-Korpus wie D-03 landet der Kanal bewusst NICHTS.**
2. **Lebend-Check (B-5)** und danach erst die Scharfschaltung "jeder CI" per Projekt-Variable.
3. **Branch-Naht:** Ziel ist der Submodul-Branch `development`; `trigger:thesis` zielt auf 289/`main`,
   Overleaf synct GitHub/`main`. Sichtbarkeit im Live-Overleaf entsteht erst ueber den bestehenden
   main-FF-/Watcher-Weg. Owner-Entscheid noetig, falls Direkt-Sichtbarkeit je CI gewuenscht ist.
4. **Grandchild-Verlaengerung** hinter B5 (T6-Einsammel-Naht). **KORREKTUR 05.08. (Codex-MAJOR):**
   die fruehere Zusicherung "bis dahin traegt der Korpus-Zweig auch den dynamischen Pfad" ist durch
   den Ist NICHT gedeckt und wird zurueckgenommen. Belegter Ist: `measurement/` traegt genau EINEN
   Laufordner (`20260726-164259-d03-strukt-r-erstbeleg/`) aus dem statischen Pfad, und der Job
   `ergebnis:holen` ist per eigenem Kommentar SKELETT mit auskommentierter Sammel-Naht und DREIFACH
   inert (`COMDARE_BUILD_GOLDEN_N` + `when: manual` + `_bot_`->never). Delegierte Stufe-2/3-Messwerte
   erreichen den Korpus also NICHT und wuerden vom Korpus-Zweig **still ausgelassen** -- der Anhang
   saehe vollstaendig aus, ohne es zu sein. Bis B5 ist der dynamische Pfad **nicht** vorwaerts-faehig;
   das ist eine bewusste, deklarierte Luecke, kein stilles Gruen.
5. **Deklarierte Grenzen des PDF-Gates** (jetzt im Kern-Kopf + YAML-Kommentar festgeschrieben):
   es baut NUR das ERSTE Top-Level-Haupt-`.tex` (heute deckungsgleich -- 289 traegt genau
   `diplomarbeit.tex`; kommt ein EN-Hauptdokument hinzu, ist die Auswahl auf eine Liste zu
   erweitern), und `AF_PDF_GATE=auto` prueft ohne TeX-Toolchain GAR NICHTS (loggt das literal).
   Restnetz ausserhalb TeX-faehiger Runner ist die 289-Pipeline NACH dem Push.
