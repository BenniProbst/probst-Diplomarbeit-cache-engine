# PROJECT_LAYER_MAP — Diplomarbeit (REV 7.6, 2026-05-13)

Strategische Strukturübersicht für **manuelles Code-Review**.
**REV 7.6:** Diplomarbeit hat jetzt EIGENEN Code unter `Code/` —
zusaetzlich zur Dokumentation. Die Code-Repos `comdare-cache-engine` und
`comdare-prt-art` sind weiterhin separat, werden aber als **parallele
Submodules** unter `Code/external/` konsumiert.

> **REV 7.6 Update:** Drei-Repo-Architektur klarer getrennt.
> Diplomarbeit = **WAS** getestet wird (XML-Configs der 3 Messreihen)
> + Binary-Ergebnis-AUSWERTUNG (CSV → LaTeX → PDF). Siehe
> `FINDINGS_REV7_6_2026_05_13.md` + `STRUCTURAL_CORRECTION_2026_05_13.md`
> + `Phase5_UML_Detail/30_architektur_delta_REV7_6_drei_repo_layer_…md`.

---

## 0. Repo-Rolle (REV 7.6 prazisiert)

`probst-Diplomarbeit-cache-engine` ist:

### Teil A: Wissenschafts-Doku (Phasen 1-6)
- Recherche (33 Such-Paper P01–P33, 21 Allokator-Paper A01–A23)
- Architektur-Skizzen (REV 1 bis REV 7.6)
- Termin-Protokolle (Termin 1–7)
- Begriffsglossar (v1–v5)
- Habich-Sprechstunden-Protokolle
- Email-Korrespondenz mit Paper-Autoren

### Teil B: Code-Schicht (NEU REV 7.6, unter `Code/`)
Anwender-Code, der die 3 Pflicht-Messreihen durchfuehrt + Auswertung:
- `Code/messung_driver/` — Loop ueber 3 Messreihen (A/B/C)
- `Code/binary_to_csv/` — Deserialisiert measurement_record_v1 binary
- `Code/csv_to_latex/` — CSV + Algorithmus-Baustein-Steckbrief → LaTeX
- `Code/diagram_generator/` — C++ → TikZ (A4-Awareness)
- `Code/latex_to_pdf/` — Wrapper um cache-engine latex_toolchain
- `Code/experiment_config/` — 3 XML-Configs (A/B/C)
- `Code/external/comdare-{prt-art, cache-engine}/` — Submodules parallel

### Teil C: Manuskript (NOCH NICHT)
- `thesis/main.tex` + `thesis/refs.bib` + `thesis/chapters/` (TBD)

---

## 1. Top-Level-Hierarchie (chronologisch nach Phasen)

```
Diplomarbeit/
├─ Phase 1: Recherche
│   ├─ Forschungsarbeiten/   (33 Original-PDFs + Volltexte)
│   ├─ Allokator_Recherche/  (21 Allokator-PDFs + Volltexte)
│   └─ Begriffsglossar_v*.md (Domänen-Identitäten)
│
├─ Phase 2: Tieflektüre
│   └─ Phase3_Tieflektuere/    (Cluster A–F, Konsolidierung G+H)
│
├─ Phase 3: Domänenmodell + Bausteine-Matrix
│   ├─ Bausteine_Matrix.txt
│   ├─ Allokator_Matrix.txt
│   ├─ Domaenenmodell_v3.md
│   └─ Flag_System.txt
│
├─ Phase 4: Setup + Code-Strukturierung
│   ├─ STATUS_PROJEKT.md
│   ├─ ADR_Beschluesse_F*.md
│   └─ Lizenz_Analyse_v2.md
│
├─ Phase 5: UML + Architektur
│   └─ 20260508 Termin 7/Phase5_UML_Detail/
│      ├─ 11..23_*.md          (REV 3 bis REV 6)
│      ├─ 24_architektur_skizze_REV7_2026_05_13.md
│      ├─ 25_…hybrid_search_engine_…md         NEU heute
│      ├─ 26_…legacy_reimpl_…md                NEU heute
│      ├─ 27_…ycsb_cli_…md                     NEU heute
│      ├─ 28_…cmake_pipeline_…md               NEU heute
│      ├─ 29_…phase4_7_loader_…md              NEU heute
│      └─ phase5_uml_detail_REV6.drawio
│
├─ Phase 6: Code-Setup (REV 6/7 INK-1..INK-8 + 12 Sub-Engines)
│
├─ Phase 7: Permutations-Builder + Experiment-Loop
│
├─ Termin 1..7/  (Habich-Sprechstunden-Protokolle)
│   ├─ Termin 1 — Erster Termin Notizen.md
│   ├─ Termin 2 — *
│   ├─ ...
│   └─ 20260508 Termin 7/        (8. Mai, langer Terminanlass)
│       ├─ Termin 7 — Habich-Sprechstunde.md
│       ├─ Termin 7 — H1/H2/H3/H4 Direktiven.md
│       ├─ Phase5_UML_Detail/    (s.o.)
│       ├─ Bausteine_Matrix.txt
│       └─ NOTES.md
│
└─ EMAIL_KONTAKTE.md            (P26/P27 Zhang, P06, P28 Kuehn, P31-P33 Habich)
```

---

## 2. Lese-Reihenfolge (empfohlen für strategisches Gegenlesen)

### Variante A: "Erstes Mal in die Diplomarbeit eintauchen"

| # | Dokument | Zweck |
|---|---|---|
| 1 | `20260508 Termin 7/Termin 7 — Habich-Sprechstunde.md` | Aktueller Stand des Projekts mit Habich |
| 2 | `20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md` | **Master-Architektur-Doku** mit 23 Allokator-Achsen + 3-Schichten-Hierarchie |
| 3 | `Domaenenmodell_v3.md` | High-level Konzept (Such-Algorithmen vs. Cache-Engine) |
| 4 | `Begriffsglossar_v5.md` | Vokabular vor Tieflektüre |
| 5 | `Bausteine_Matrix.txt` | Was wird wo verwendet (P01..P33 ↔ Code-Adapter) |
| 6 | Termin-Protokolle 1–6 chronologisch | Entwicklung der Konzepte |

### Variante B: "Heutigen Sprint nachvollziehen"

| # | Dokument | Inhalt |
|---|---|---|
| 1 | `25_architektur_delta_hybrid_search_engine_2026_05_13.md` | **REV 7.1** — Hybride PrtArtSearchEngine (Vector-/Map-/Tuple-API + errno-style) |
| 2 | `26_architektur_delta_legacy_reimpl_2026_05_13.md` | **REV 7.2** — 14 LEGACY_REIMPL Skelette ausgefüllt |
| 3 | `27_architektur_delta_ycsb_cli_2026_05_13.md` | **REV 7.3** — YCSB-Generator-CLI als Datasets-Tool |
| 4 | `28_architektur_delta_cmake_pipeline_2026_05_13.md` | **REV 7.4** — echte cmake-Pipeline (54 DLLs gebaut) |
| 5 | `29_architektur_delta_phase4_7_loader_2026_05_13.md` | **REV 7.5** — Phase 4-7 Loader + RunWorkload + Aggregator |

### Variante C: "Paper-Tieflektüre nachvollziehen"

| Cluster | Doc-Pfad | Paper |
|---|---|---|
| A — Trie | `Phase3_Tieflektuere/Cluster_A_Trie.md` | P01, P02, P04, P05, P09, P10 |
| B — Hybrid + B+ | `Phase3_Tieflektuere/Cluster_B_Hybrid_BPlus.md` | P03, P06, P07, P11, P12, P13 |
| C — Layout | `Phase3_Tieflektuere/Cluster_C_Layout.md` | P14, P15, P16, P17, P18, P19 |
| D — Prefetch 1 | `Phase3_Tieflektuere/Cluster_D_Prefetch1.md` | P20, P21, P22, P23 |
| E — Prefetch 2 + Telemetry | `Phase3_Tieflektuere/Cluster_E_Prefetch2.md` | P24, P25, P26, P27, P28 |
| F — Sync + TUD-Habich | `Phase3_Tieflektuere/Cluster_F_Sync_TUD.md` | P08, P29, P30, P31, P32, P33 |
| Konsolidierung G | `Phase3_Tieflektuere/Konsolidierung_G_Cache_Strategien.md` | Cache-Strategien-Taxonomie |
| Konsolidierung H | `Phase3_Tieflektuere/Konsolidierung_H_Algorithmus_Strategien.md` | Iterator-Inventar |

---

## 3. Cross-Projekt-Referenzen (in Doc-Texten)

Die Diplomarbeit referenziert **beide Code-Repos** in folgenden Mustern:

### `comdare-cache-engine/...` Pfade

Sind in Architektur-Skizzen REV 6/7 als konkrete Code-Pfade angegeben.
Beispiele in `24_architektur_skizze_REV7_2026_05_13.md`:
- `cache_engine/include/cache_engine/abi/module_abi_v1.hpp`
- `cache_engine/builder/main.cpp` (Phase 1–7)
- `cache_engine/include/cache_engine/allocators/families/aXX_*/`

### `prt_art/include/prt_art/...` Pfade

Sind in REV 6 §5.17 als PRT-ART-Bausteine spezifiziert.
Beispiele:
- `prt_art/identity/prt_art_search_engine.hpp` (heute hybride API)
- `prt_art/allocator/pool_set.hpp` (4+2 Pools)
- `prt_art/concurrency/olc_with_reserved_blocks.hpp`

### Paper-IDs

Konsistente Naming-Convention:
- **P01..P33** — 33 Such-Algorithmus-Paper (Phase 3.B)
- **A01..A23** — 23 Allokator-Paper (Phase 6.2.B)

Bei externer Kommunikation (Habich, Email-Autoren) NIEMALS P-IDs benutzen,
immer vollständige Bibliografie (siehe `EMAIL_KONTAKTE.md`).

---

## 4. Habich-Direktiven (Hierarchie)

Habich hat im Lauf der Sprechstunden folgende H-Direktiven gegeben:

| ID | Kurzbeschreibung | Status |
|---|---|---|
| **H1** | nur 1 Hauptcompiler (C++23) — andere optional | umgesetzt |
| **H2** | Code-Qualitäts-Bewertung pro Bausteine-Quelle | **HEUTE FERTIG** — `docs/quality_audit/HABICH_H2_CODE_QUALITY_2026_05_13.md` in cache-engine |
| **H3** | LaTeX-Toolchain mit dynamischer Diagramm-Compile | **HEUTE FERTIG** — `tools/latex_toolchain/` in cache-engine |
| **H4** | Repo-Separation + GitHub-Push | **HEUTE FERTIG** — 3 Repos gepusht (today) |
| H5 | Habich-Sprechstunde-Protokoll-Format | umgesetzt |
| H6 | NO Python in Build-Pipeline | F-EXTRA-5 KORREKTUR |

---

## 5. Heutige Änderungen (zum priorisierten Review)

Nur **5 neue Dokumente** + IDE-Config:

| Datei | Wichtigkeit | Inhalt |
|---|---|---|
| `25_..._hybrid_search_engine_2026_05_13.md` | **HOCH** | REV 7.1 Architektur-Korrektur: Hybride Klasse |
| `26_..._legacy_reimpl_2026_05_13.md` | MITTEL | REV 7.2 14 LEGACY_REIMPL ausgefüllt |
| `27_..._ycsb_cli_2026_05_13.md` | MITTEL | REV 7.3 YCSB-CLI |
| `28_..._cmake_pipeline_2026_05_13.md` | **HOCH** | REV 7.4 cmake-Pipeline + 54 DLLs |
| `29_..._phase4_7_loader_2026_05_13.md` | **HOCH** | REV 7.5 Phase 4-7 voll funktional |
| `.idea/` | NIEDRIG | IntelliJ/CLion-Config |

**Review-Schwerpunkt:** REV 7.1 (User-Direktive zur hybriden Klasse) und REV 7.5
(End-to-End-Pipeline-Verifikation).

---

## 6. Termin-7-Struktur (8. Mai 2026 — der große Anlass)

`20260508 Termin 7/` ist der wichtigste Sub-Tree:

```
20260508 Termin 7/
├── Termin 7 — Habich-Sprechstunde.md       (Protokoll)
├── Termin 7 — H1/H2/H3/H4 Direktiven.md   (4 H-Direktiven aus Habich)
├── Bausteine_Matrix.txt                     (P01..P33 ↔ Code-Adapter)
├── Allokator_Matrix.txt                    (A01..A23 ↔ Code-Adapter)
├── NOTES.md
├── _archive_code_pre_migration/            (lokal nur, ignored)
└── Phase5_UML_Detail/
    ├── 00..10_*.md   (Vor-Vorbereitung)
    ├── 11..13_*.md   (Domänenmodell + Cache-Strategien)
    ├── 14..19_*.md   (Allokator-Recherche)
    ├── 20_architektur_skizze_REV3_2026_05_10.md
    ├── 21_architektur_skizze_REV4_2026_05_10.md
    ├── 22_architektur_skizze_REV5_2026_05_11.md
    ├── 23_architektur_skizze_REV6_2026_05_11.md
    ├── 24_architektur_skizze_REV7_2026_05_13.md      ← MASTER
    ├── 25..29_*.md   ← REV 7.1..7.5 Delta-Docs
    ├── 30_architektur_delta_REV7_6_drei_repo_layer_2026_05_13.md  ← REV 7.6
    └── phase5_uml_detail_REV{3..6}.drawio
```

**Master-Architektur:** `24_…REV7_2026_05_13.md` (872 Zeilen) +
`30_…REV7_6…md` (REV 7.6 Drei-Repo-Schichten-Korrektur) — beides Pflicht.

---

## 6.5 NEU REV 7.6: Code/-Verzeichnis-Struktur

```
Diplomarbeit/Code/
├── CMakeLists.txt                       (top-level, C++23, ruft Submodules)
├── README.md                            (Code-Schicht-Doku)
├── .gitignore                           (build/, _runs/)
├── external/
│   ├── comdare-prt-art/                Submodule (parallel)
│   └── comdare-cache-engine/           Submodule (parallel)
├── messung_driver/
│   ├── main.cpp                        (3-Messreihen-Loop A/B/C)
│   └── CMakeLists.txt
├── binary_to_csv/
│   ├── binary_to_csv.{hpp,cpp}         (magic 0xC0FFEE02)
│   ├── main_cli.cpp                     (binary-to-csv Executable)
│   └── CMakeLists.txt
├── csv_to_latex/
│   ├── csv_to_latex.{hpp,cpp}           (mit generate_baustein_description)
│   ├── main_cli.cpp                     (csv-to-latex Executable)
│   └── CMakeLists.txt
├── diagram_generator/
│   ├── diagram_generator.{hpp,cpp}      (Bar+Scatter+Heatmap → TikZ)
│   ├── main_cli.cpp                     (diagram-generator Executable)
│   └── CMakeLists.txt
├── latex_to_pdf/
│   ├── build_thesis.sh + .bat           (POSIX + Windows Frontend)
│   └── CMakeLists.txt
├── experiment_config/
│   ├── config_a_prt_art_vs_sota.xml    (Messreihe A)
│   ├── config_b_cache_engine_perms.xml  (Messreihe B)
│   └── config_c_merge_alt_neu.xml       (Messreihe C)
└── tests/unit/
    ├── test_binary_to_csv.cpp
    ├── test_csv_to_latex.cpp
    └── test_diagram_generator.cpp
```

---

## 7. Strategie für vollständiges Gegenlesen

### Tag 1 (Architektur, Konzept)
- `20260508 Termin 7/Phase5_UML_Detail/24_architektur_skizze_REV7_2026_05_13.md`
- **`30_architektur_delta_REV7_6_drei_repo_layer_2026_05_13.md`** (Drei-Repo-Modell)
- **`STRUCTURAL_CORRECTION_2026_05_13.md`** (User-Original-Nachricht §10)
- **`FINDINGS_REV7_6_2026_05_13.md`** (was war wo verloren / gefixt)
- Begriffsglossar
- Domänenmodell v3
- Bausteine_Matrix + Allokator_Matrix

### Tag 2 (Heutige Updates REV 7.1-7.6)
- 6 Delta-Docs (25–30) in Reihenfolge

### Tag 3 (Code-Review: Diplomarbeit/Code/ NEU)
- `Code/README.md` zuerst
- `Code/CMakeLists.txt` (Submodule-Layout)
- `Code/messung_driver/main.cpp` (3-Messreihen-Loop)
- `Code/experiment_config/config_{a,b,c}*.xml` (WAS getestet wird)
- `Code/binary_to_csv/`, `csv_to_latex/`, `diagram_generator/`, `latex_to_pdf/`

### Tag 4 (Code-Review: cache-engine)
- `comdare-cache-engine/PROJECT_LAYER_MAP.md` zuerst
- `cache_engine/include/cache_engine/abi/module_abi_v1.hpp` (zentral)
- `cache_engine/builder/main.cpp` (heutige Phase 4-7)
- `cache_engine/builder/codegen/codegen.cpp` (heutige Aggregator)
- `cache_engine/builder/module_loader/{hpp,cpp}` (heute NEU)

### Tag 5 (Code-Review: prt-art)
- `comdare-prt-art/PROJECT_LAYER_MAP.md` zuerst
- `prt_art/include/prt_art/identity/prt_art_search_engine.hpp` (hybride API)
- 51 neue Tests in `tests/unit/test_prt_art_identity.cpp`

### Tag 6 (Tools + LEGACY_REIMPL + Stand der Technik)
- `cache-engine/tools/{ycsb_cli,latex_anhang,latex_toolchain}/`
- 14 LEGACY_REIMPL Skelette (P11–P27) — je 1 Header
- `docs/quality_audit/HABICH_H2_CODE_QUALITY_2026_05_13.md`

---

## 8. Querverweis zu Code-Repos (Stand REV 7.6, heute Abend)

```
comdare-cache-engine    →  github.com/BenniProbst/comdare-cache-engine
                           (Library-Refactoring + Diagnose-Restore + gitignore-Fix)

comdare-prt-art          →  github.com/BenniProbst/comdare-prt-art
                           (unveraendert seit REV 7.1)

Diplomarbeit (this)      →  github.com/BenniProbst/probst-Diplomarbeit-cache-engine
                           (Code/-Verzeichnis NEU + Submodules + Delta 30)
```

Submodule-Pfade (parallel):
```
Diplomarbeit/Code/external/comdare-prt-art       ← prt-art Pin
Diplomarbeit/Code/external/comdare-cache-engine  ← cache-engine Pin
```

Die `PROJECT_LAYER_MAP.md` von **jedem** der drei Repos ist die Ausgangs-
basis für das systematische Review.

---

## 9. Bekannte offene Items (Phase 8+)

1. **#74 Email-Antworten warten** (P06, P28, P31, P32, P33 von Habich)
2. **#77 Cluster-Migration** (Fortigate-31G + COMDARE-Modules-GitLab-Push)
3. **#88 ↔ LaTeX-Anhang-Tool** in cache-engine ist gebaut, aber das echte
   Diplomarbeits-LaTeX-Manuskript existiert noch nicht in diesem Repo
4. **Habich-Termine 8+ folgen** — nächste Sprechstunde-Protokolle
5. **Diplomarbeits-Manuskript (`*.tex`)** muss noch geschrieben werden;
   `tools/latex_toolchain` von cache-engine ist bereit es zu kompilieren

---

## 10. V8-V11 Delta (REV 7.6 Vollimplementierung, 2026-05-13/14)

### 10.1 Neue Files in Code/
- `Code/messung_driver/main.cpp` — V8.12 EXPERIMENT_MODE check, V9.6 --messreihen-xml, V11.3 Spec→ExperimentDriver E2E
- `Code/experiment_config/messreihen.xml` (V11.5) — Standard-Template fuer 4 Messreihen (A_defined/A_full/B/C)
- `Code/experiment_config/config_a_prt_art_vs_sota.xml` — V8.13 defined/full Mode XML-Schema
- `Code/USAGE.md` — V11.8 V8-V11 Delta-Sektion ergaenzt

### 10.2 Tests
- `Code/tests/unit/test_messung_driver.cpp` — V8.4 Skelett, V11.6 MessreihenMode-Tests + Options-Defaults-Tests

### 10.3 Submodule-Pin-Bumps
- `Code/external/comdare-cache-engine` — V11 → e824d30 (V8.4-V10.5)
- `Code/external/comdare-prt-art` — V11 → fd67e82 (V8.9-V10.3)

### 10.4 CI
- `.gitlab-ci.yml` (V11.7) — primaer
- `.github/workflows/ci.yml` (V11.7) — synchron

### 10.5 Sessions
- `docs/sessions/` — komplette Sprint-Anker + Final-Sessions V8/V9/V10/V11

### Querverweis
- Letzte V11-Anker-Session: `docs/sessions/20260514-1430-v11-anker-mit-delta.md`
- STRUCTURAL_CORRECTION_diplomarbeit.md §11.5 — korrigiertes Diagramm

---

## 11. V12-V14 Delta (REV 7.6 weitere Iterationen, 2026-05-14)

### 11.1 Diplomarbeit/Code/ Aenderungen
- `Code/messung_driver/main.cpp` — V11.3 Spec→ExperimentDriverOptions E2E
- `Code/experiment_config/messreihen.xml` (V11.5) — 4 Pflicht-Messreihen
- `Code/tests/unit/test_messung_driver.cpp` — V11.6 + V14.2 MessreihenMode-Tests

### 11.2 docs/ neu (V12.5 + V15.x)
- `docs/NAMING_CONVENTIONS.md` (V12.5) — 2 legitime Naming-Stile dokumentiert (snake_case ABI vs PascalCase Domain)

### 11.3 thesis/ Manuskript-Skelett (V13.7 + V14.4 + V15.1)
- `thesis/main.tex` — KOMA-Script + biber + tikz/pgfplots
- `thesis/chapters/` — 9 Kapitel (V14.4 02-04 inhaltlich; V15.1 01+05+06+07 inhaltlich)
- `thesis/literatur.bib` — 8 Tier-1-Paper
- `thesis/README.md` — Build-Anleitung + Diagramm-Integration

### 11.4 CI Test-Discovery-Workaround (V14.3)
- `.gitlab-ci.yml` + `.github/workflows/ci.yml`: direkte Test-Binary-Ausfuehrung

### 11.5 Submodule-Pin-Bumps Verlauf
- V8 (b88eab1, 0d3baeb) → V9 (4048638, 54a7224) → V10 (e824d30, fd67e82) → V11 (493db36, 54f024f) → V12 (9208ceb, eaf1234) → V13 (e31faf6, 0ad2eab) → V14 (13260c7, e6b79a3)

### 11.6 Sessions
- 7 Anker-Sessions + 7 Final-Sessions (V8 bis V14) — vollstaendige Sprint-Doku

### Querverweis
- thesis/main.tex (Build via cache-engine tools/latex_toolchain)
- HABICH_TERMIN8 (V15.3): siehe 20260508 Termin 7/HABICH_TERMIN8_*.md

---

## REV 7.7 V19-V27 (2026-05-14): Pipeline + Layout + Konsistenz

### V19-V22: Mess-Pipeline-Vollendung
- V19 Profile-Tag `<expected_workload>` (cache-engine)
- V20 `workload_used` durchs Mess-Pipeline-Output (CSV/JSON)
- V21 ART-ext-Skelett + sample_data_generator + thesis chapter 06
- V22 diagram_generator nutzt Sample-CSV → echte TikZ + thesis re-built

### V23: cache-engine Layout-Refactoring (Pitchfork/ClickHouse)
- V23.A Cleanup + CMakePresets (8 build-dirs weg, 7 GB)
- V23.B `apps/cache_engine_builder/`
- V23.C `libs/common/{succinct, serialization, platform, measurement}/`
- V23.E `libs/deprecated/prt_art_legacy/` (Folly-Stil)
- V23.F `libs/test_infra/{workload_generator, test_data, benchmark_suite}/`
- V23.D `libs/domain/` deferred (~280 Dateien hochrisikant)

### V24: Konsistenz alle 3 Repos
- V24.A prt-art Cleanup + CMakePresets
- V24.B Diplomarbeit Code/ Cleanup + CMakePresets
- V24.C cache-engine PROJECT_LAYER_MAP +Kapitel 12 (V19-V24 Delta)
- V24.D thesis chapter 04 +V19-V24 Sections (4 Sections)
- Direktive verankert: "Niemals Doku loeschen"

### V25: Profile-Vollstaendigkeit + Adapter-Schicht
- V25.A prt-art Audit (READMEs in cmake/, prt_art/src/ — keine Loeschung)
- V25.B 30/30 SOTA-Profile mit `<expected_workload>`
- V25.C 11 SOTA-Adapter-Skelette in cache-engine adapters/P*
- V25.D Diplomarbeit docs/termine/INDEX.md (Wegweiser statt Reorganisation)

### V26: Allokator-Schicht
- V26.A 10 Allokator-Profile in cache-engine
- V26.B 10 Allokator-Adapter-Skelette (21 Adapter-Total: 11 SOTA + 10 Allokator)

### V27: PROJECT_LAYER_MAPs in 3 Repos
- V27.A cache-engine +Kap 13 (V25-V26 Delta)
- V27.B prt-art +Kap 12
- V27.C Diplomarbeit +diese Sektion

### Diplomarbeit-Code-Erweiterungen V21-V25
| Pfad | Eingefuehrt | Zweck |
|---|---|---|
| `Code/sample_data_generator/` | V21.3 | Sample-CSV-Generator |
| `Code/test_data_xml/` | V23.X1 | Diplomarbeit-eigene Testdatensatz-XMLs |
| `Code/tools/fetch_testdata.{sh,bat}` | V23.3 | Lazy-Download fuer ~30 GB |
| `Code/tests/fixtures/external/` | V23.3 | Daten gitignored |
| `Code/CMakePresets.json` | V24.B | analog cache-engine V23.A |
| `docs/termine/INDEX.md` | V25.D | Wegweiser |

### Pin-Bump-Kette V19-V27 (cache-engine)
2f0222d (V18) → 08aca46 → ccb1555 → eee33fb → d70b9a4 → 94123c4 → 141e3eb → 205e848 → 803c577 → 5528184 → b9abc72 → e11f925 (V23.F) → afad1c6 (V24.C) → cb925ff (V25.C) → 8b8e312 (V26) → 11ab988 (V27.A)

### Pin-Bump-Kette V19-V27 (prt-art)
eca14a2 (V18) → bc877ed (V19) → a1bcd09 (V24) → afbdd75 (V25.A) → c3688fa (V27.B)

### Querverweis V19-V27
- 20+ Session-Dokus in `docs/sessions/20260514-*.md`
- Tags `v22-final` in 3 Repos (Pre-V23 Rollback-Punkt)
- Memory-Direktive: `feedback_never_delete_documentation.md`
